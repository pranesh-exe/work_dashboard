package com.billingparadise.web.dao;

import com.billingparadise.web.beans.Job;
import com.billingparadise.web.beans.ExcelEobDto;
import com.billingparadise.web.beans.Practice;
import com.billingparadise.web.datatablespagination.model.OrderingCriteria;
import com.billingparadise.web.datatablespagination.model.PaginationCriteria;
import com.billingparadise.web.datatablespagination.model.TablePage;
import com.billingparadise.web.help.UserRole;
import com.billingparadise.web.util.StringUtilities;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;

/**
 *
 * @author BALAJI N
 */
@Service
public class ExcelEobDao {

    @Autowired
    private JdbcTemplate template;
    private static final Logger LOGGER = LoggerFactory.getLogger(ExcelEobDao.class);
    private static final String[] tables = {"ecw_payment_xl", "ecw_payment_advisory_xl", "ecw_payment_posting_xl"};

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public List<Job> getJobStatus() {
        return template.query("SELECT job_status_id, job_status FROM job_status ORDER BY job_status", new RowMapper<Job>() {
            @Override
            public Job mapRow(ResultSet rs, int row) throws SQLException {
                Job job = new Job();
                job.setJobStatusId(rs.getInt("job_status_id"));
                job.setJobStatus(rs.getString("job_status"));
                return job;
            }
        });
    }
    
    public List<Job> getJobId() {
        return template.query("SELECT eob_job_id FROM eob_jobs ORDER BY eob_job_id DESC", new RowMapper<Job>() {
            @Override
            public Job mapRow(ResultSet rs, int row) throws SQLException {
                Job job = new Job();
                job.setJobid(rs.getInt("eob_job_id"));
                return job;
            }
        });
    }

    public List<Practice> getPracticeListForExcelEob(final Long entityId, final Long practiceId, final Long userType, final Long userId) {
        List<Practice> practiceList = new ArrayList<>();
        String condition = "";
        UserRole loggedUserRole = UserRole.get(userType);
        if (UserRole.ROLE_ADMIN != loggedUserRole) {
            if (null == loggedUserRole) {
                condition = " WHERE s.active =1 AND find_in_set (p.practice_id , (SELECT GROUP_CONCAT(practice_id) FROM team_practice_mapping WHERE team_id  IN (SELECT team_id  FROM team_user_mapping  WHERE user_id = " + userId + "))) ";
            } else {
                switch (loggedUserRole) {
                    case ROLE_ENTITY_ADMIN:
                    case ROLE_ENTITY_STAFF:
                    case ROLE_ZONE_MANAGER:
                    case ROLE_ZONE_LEAD:
                    case ROLE_DIVISION_MANAGER:
                    case ROLE_DIVISION_LEAD:
                        condition = " WHERE s.active =1 AND p.entity_id = " + entityId;
                        break;
                    case ROLE_GROUPCLINIC_PROVIDER:
                    case ROLE_GROUPCLINIC_ADMIN:
                    case ROLE_GROUPCLINIC_STAFF:
                        condition = " WHERE s.active =1 AND find_in_set (p.practice_id , (SELECT GROUP_CONCAT(practice_id) FROM corp_master WHERE find_in_set (corp_id , ((SELECT corp_id  FROM group_master WHERE group_id IN ( "
                                + "SELECT group_id FROM user_master WHERE user_id = " + userId + ")))))) ";
                        break;
                    case ROLE_CORP_ADMIN:
                    case ROLE_CORP_STAFF:
                    case ROLE_CORP_PROVIDER:
                        condition = " WHERE s.active =1 AND find_in_set (p.practice_id , (SELECT GROUP_CONCAT(practice_id) FROM corp_master WHERE corp_id IN (SELECT corp_id FROM user_master WHERE user_id = " + userId + "))) ";
                        break;
                    case ROLE_PRACTICE_ADMIN:
                    case ROLE_PRACTICE_STAFF:
                    case ROLE_PRACTICE_PROVIDER:
                    case ROLE_REFERING_PROVIDER:
                        condition = " WHERE s.active =1 AND p.entity_id = " + entityId + " AND p.practice_id =" + practiceId;
                        break;
                    default:
                        condition = " WHERE s.active =1 AND find_in_set (p.practice_id , (SELECT GROUP_CONCAT(practice_id) FROM team_practice_mapping WHERE team_id  IN (SELECT team_id  FROM team_user_mapping  WHERE user_id = " + userId + "))) ";
                        break;
                }
            }
        } else {
             condition = " WHERE s.active = 1 AND p.entity_id = " + entityId;
        }

        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement("SELECT p.practice_id,s.ftpuser, p.name FROM practice_master p "
                + "LEFT JOIN subscription_master s ON s.tid = p.account_id " + condition + " ORDER BY p.name"); 
                ResultSet rs = preparedStatement.executeQuery()) {
            while (rs != null && rs.next()) {
                Practice practice = new Practice();
                practice.setPractice_id(rs.getInt("practice_id"));
                practice.setAccountNo(rs.getString("ftpuser"));
                practice.setName(rs.getString("name"));
                practiceList.add(practice);
            }
        } catch (SQLException | NullPointerException ex) {
            LOGGER.error("Exception:", ex);
        }
        return practiceList;
    }

    public TablePage getEobLogData(final Long entityId, final Long userType, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        UserRole loggedUserRole = UserRole.get(userType);
        if (UserRole.ROLE_ADMIN != loggedUserRole) {
            if (null == loggedUserRole) {
                condition = " WHERE pm.entity_id = '" + entityId + "' AND sm.active = 1 ";
            } else {
                switch (loggedUserRole) {
                    case ROLE_ENTITY_ADMIN:
                    case ROLE_ENTITY_STAFF:
                    case ROLE_ZONE_MANAGER:
                    case ROLE_ZONE_LEAD:
                    case ROLE_DIVISION_MANAGER:
                    case ROLE_DIVISION_LEAD:
                        condition = " WHERE pm.entity_id = '" + entityId + "' AND sm.active = 1 ";
                        break;
                }
            }
        } else {
            condition = " WHERE pm.entity_id = " + entityId;
        }
        if (pagingRequest.getInnerSearchValue() != null && StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " AND ("
                    + "eob_job_id LIKE '%" + innerQuery + "%' OR jt.job_type LIKE '%" + innerQuery + "%' OR pm.name LIKE '%" + innerQuery + "%' OR "
                    + "filename LIKE '%" + innerQuery + "%' OR um.first_name LIKE '%" + innerQuery + "%' OR IFNULL(DATE_FORMAT(CONVERT(created_on, DATE), '%m/%d/%Y'), '') LIKE '%" + innerQuery + "%' OR "
                    + "ej.status LIKE '%" + innerQuery + "%' OR ej.totalXlRows LIKE '%" + innerQuery + "%' OR ej.absorbedRecords LIKE '%" + innerQuery + "%'" + ") ";
        }

        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }
        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
               String columnName = order.getColumnName();
                        String orderColumn = null;
                        orderColumn = switch (columnName) {
                            case "createdDate" -> " created_on ";
                            default -> order.getColumnName();
                        };
                        orderBy = orderBy + "," + orderColumn + " " + order.getDir();
           }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY ej.eob_job_id DESC ";
        }

        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn()) && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("created_on".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND DATE_FORMAT(CONVERT(ej.created_on, DATE), '%m/%d/%Y') BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if (StringUtils.equalsAnyIgnoreCase(
                        msColumns[columnIndex],
                        "py.check_no",
                        "ep.check_no",
                        "ep.claim_no",
                        "ep.code",
                        "ep.ecw_adv_id")) {
                    searchCondition += " ";
                } else if (StringUtils.equalsAnyIgnoreCase(
                        msColumns[columnIndex],
                        "epp.check_no",
                        "epp.claim_no",
                        "epp.patient_name",
                        "epp.ecw_pmt_id",
                        "ep.service_dt")) {
                    searchCondition += " ";
                } else if (StringUtils.equalsAnyIgnoreCase(
                        msColumns[columnIndex],
                        "py.check_date",
                        "py.pmt_rcrd_dt",
                        "epp.dos")) {
                    searchCondition += " ";
                } else if ("eob_job_id".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("~"))
                            .map(String::trim)
                            .collect(Collectors.joining(", "));
                    searchCondition = searchCondition
                            + " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else if ("sm.ftpuser".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("\\|"))
                            .map(p -> "'" + p.trim() + "'")
                            .collect(Collectors.joining(", "));
                    searchCondition += " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' )  ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<ExcelEobDto> eobLogData = new ArrayList<>();
        String query = "SELECT eob_job_id, jt.job_type, pm.name AS practice, filename, "
                + "um.first_name AS createdBy, IFNULL(DATE_FORMAT(CONVERT(created_on, DATE), '%m/%d/%Y'), '') AS createdDate, "
                + "ej.status, ej.totalXlRows, ej.absorbedRecords, ej.comments  FROM eob_jobs ej "
                + "LEFT JOIN job_type jt ON jt.jobtypeid = ej.eob_job_type "
                + "LEFT JOIN practice_master pm ON (pm.practice_id = ej.practice_id OR pm.name = ej.practice_id) "
                + "INNER JOIN subscription_master sm ON sm.tid = pm.account_id "
                + "LEFT JOIN user_master um ON um.user_id = ej.created_by "
                + condition + innerSearchCondition + searchCondition + orderBy + limit;
        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(query); 
                ResultSet rs = preparedStatement.executeQuery()) {
            LOGGER.info("Log table   :-----" + query);
            while (rs != null && rs.next()) {
                ExcelEobDto excelEobDTO = new ExcelEobDto();
                excelEobDTO.setEobJobId(rs.getInt("eob_job_id"));
                excelEobDTO.setEobJobType(rs.getString("job_type"));
                excelEobDTO.setPractice(rs.getString("practice"));
                excelEobDTO.setFileName(rs.getString("filename"));
                excelEobDTO.setCreatedBy(rs.getString("createdBy"));
                excelEobDTO.setCreatedOn(rs.getString("createdDate"));
                excelEobDTO.setTotalXlRows(rs.getInt("totalXlRows"));
                excelEobDTO.setAbsorbedRecords(rs.getInt("absorbedRecords"));
                excelEobDTO.setStatus(rs.getString("status"));
                excelEobDTO.setComments(rs.getString("comments"));
                eobLogData.add(excelEobDTO);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }

        String countQuery = "SELECT COUNT(ej.eob_job_id) FROM eob_jobs ej "
                + "LEFT JOIN job_type jt ON jt.jobtypeid = ej.eob_job_type "
                + "LEFT JOIN practice_master pm ON (pm.practice_id = ej.practice_id OR pm.name = ej.practice_id) "
                + "INNER JOIN subscription_master sm ON sm.tid = pm.account_id "
                + "LEFT JOIN user_master um ON um.user_id = ej.created_by "
                + condition;
        int count = template.queryForObject(countQuery, Integer.class);
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String countSearchQuery = "SELECT COUNT(ej.eob_job_id) FROM eob_jobs ej "
                    + "LEFT JOIN job_type jt ON jt.jobtypeid = ej.eob_job_type "
                    + "LEFT JOIN practice_master pm ON (pm.practice_id = ej.practice_id OR pm.name = ej.practice_id) "
                    + "INNER JOIN subscription_master sm ON sm.tid = pm.account_id "
                    + "LEFT JOIN user_master um ON um.user_id = ej.created_by "
                    + condition + searchCondition + innerSearchCondition + searchCondition;
            searchCount = template.queryForObject(countSearchQuery, Integer.class);
        }
        returnObj.setData(eobLogData);
        returnObj.setDraw(pagingRequest.getDraw());
        returnObj.setRecordsTotal(count);
        returnObj.setRecordsFiltered(searchCount);
        returnObj.setExportData(StringUtilities.convertListToJson(eobLogData));
        return returnObj;
    }

    public TablePage getEobPaymentData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE py.eob_job_id > 0 AND py.ecw_pmt_id IS NOT NULL AND sm.entity_id = " + entityId;
        if (StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " AND ("
                    + "py.ecw_pmt_id LIKE '%" + innerQuery + "%' OR py.check_no LIKE '%" + innerQuery + "%' OR py.check_date LIKE '%" + innerQuery + "%' OR "
                    + "py.check_amt LIKE '%" + innerQuery + "%' OR py.pmt_from LIKE '%" + innerQuery + "%' OR py.pmt_id LIKE '%" + innerQuery + "%' OR "
                    + "py.pmt_rcrd_dt LIKE '%" + innerQuery + "%' OR py.cr_by LIKE '%" + innerQuery + "%' OR um.first_name LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(DATE_FORMAT(CONVERT(py.cr_dt, DATE), '%m/%d/%Y'), '') LIKE '%" + innerQuery + "%' OR py.eob_job_id LIKE '%" + innerQuery + "%' OR "
                    + "sm.ftpuser LIKE '%" + innerQuery + "%' OR py.filename LIKE '%" + innerQuery + "%' OR CASE py.status WHEN 'Completed' THEN 'Data Imported' WHEN 'Active' THEN 'Staging' ELSE 'Exception' END LIKE '%" + innerQuery + "%'" + ") ";
        }

        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }
        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                String columnName = order.getColumnName();
                String orderColumn = null;
                orderColumn = switch (columnName) {
                    case "check_date" -> " STR_TO_DATE(py.check_date, '%m/%d/%Y') ";
                    case "pmt_rcrd_dt" -> " STR_TO_DATE(py.pmt_rcrd_dt, '%m/%d/%Y') ";
                    case "createdDate" -> " DATE_FORMAT(CONVERT(py.cr_dt, DATE), '%m/%d/%Y') ";
                    case "upd_dt" -> " py.upd_dt ";
                    default -> order.getColumnName();
                };
                orderBy = orderBy + "," + orderColumn + " " + order.getDir();
           }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY py.ecw_pmt_id DESC ";
        }

        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn()) && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("py.check_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND py.check_date BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("py.pmt_rcrd_dt".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND py.pmt_rcrd_dt BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("py.eob_job_id".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("~"))
                            .map(String::trim)
                            .collect(Collectors.joining(", "));
                    searchCondition = searchCondition
                            + " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else if ("py.status".equalsIgnoreCase(msColumns[columnIndex])) {
                    if ("Exception".equalsIgnoreCase(msValues[columnIndex])) {
                        searchCondition += " AND ( "
                                + msColumns[columnIndex] + " NOT IN ('Active', 'Completed') "
                                + " OR " + msColumns[columnIndex] + " IS NULL "
                                + " OR TRIM(" + msColumns[columnIndex] + ") = '' ) ";
                    } else {
                        searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' ) ";
                    }
                } else if ("sm.ftpuser".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("\\|"))
                            .map(p -> "'" + p.trim() + "'")
                            .collect(Collectors.joining(", "));
                    searchCondition += " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' )  ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<ExcelEobDto> paymentData = new ArrayList<>();
        String query = "SELECT py.ecw_pmt_id, py.check_no, py.check_date, py.check_amt, py.pmt_from, py.pmt_id, py.pmt_rcrd_dt, "
                + "py.cr_by AS createdBy, IFNULL(DATE_FORMAT(CONVERT(py.cr_dt, DATE), '%m/%d/%Y'), '') AS createdDate, "
                + "sm.ftpuser AS account, py.filename, "
                + "CASE py.status WHEN 'Completed' THEN 'Data Imported' WHEN 'Active' THEN 'Staging' ELSE 'Exception' END AS status, "
                + " um.first_name AS updated_by, py.upd_dt, py.eob_job_id AS eobJobId "
                + "FROM ecw_payment_xl py "
                + " LEFT JOIN ecw_payment_advisory_xl epp ON py.ecw_pmt_id = epp.ecw_pmt_id "
                + " LEFT JOIN ecw_payment_posting_xl ep ON epp.ecw_adv_id = ep.ecw_adv_id "
                + " LEFT JOIN practice_master pm ON (pm.name =  py.account OR pm.practice_id = py.account) "
                + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                + " LEFT JOIN user_master um ON um.user_id = py.upd_by "
                + condition + innerSearchCondition + searchCondition + " GROUP BY py.ecw_pmt_id " + orderBy + limit;
        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(query); 
                ResultSet rs = preparedStatement.executeQuery()) {
            LOGGER.info("Payment   :-----" + query);
            while (rs != null && rs.next()) {
                ExcelEobDto excelEobDTO = new ExcelEobDto();
                excelEobDTO.setEcwPaymentId(rs.getInt("ecw_pmt_id"));
                excelEobDTO.setCheckNo(rs.getString("check_no"));
                excelEobDTO.setCheckDate(rs.getString("check_date"));
                excelEobDTO.setCheckAmount(rs.getString("check_amt"));
                excelEobDTO.setPaymentFrom(rs.getString("pmt_from"));
                excelEobDTO.setPaymentId(rs.getInt("pmt_id"));
                excelEobDTO.setPaymentReceivedDate(rs.getString("pmt_rcrd_dt"));
                excelEobDTO.setCreatedBy(rs.getString("createdBy"));
                excelEobDTO.setCreatedDate(rs.getString("createdDate"));
                excelEobDTO.setAccount(rs.getString("account"));
                excelEobDTO.setFileName(rs.getString("filename"));
                excelEobDTO.setStatus(rs.getString("status"));
                excelEobDTO.setUpdateBy(rs.getString("updated_by"));
                excelEobDTO.setUpdateDate(rs.getString("upd_dt"));
                excelEobDTO.setEobJobId(rs.getInt("eobJobId"));
                paymentData.add(excelEobDTO);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
        int count = 0;
        String countQuery = "SELECT IFNULL(COUNT(recordCount),0) AS recordsTotal, IFNULL(SUM(checkAmount),0) AS totalCheckAmount "
                + "FROM ( SELECT py.ecw_pmt_id AS recordCount, IFNULL(py.check_amt,0) AS checkAmount "
                + "FROM ecw_payment_xl py "
                + " LEFT JOIN ecw_payment_advisory_xl epp ON py.ecw_pmt_id = epp.ecw_pmt_id "
                + " LEFT JOIN ecw_payment_posting_xl ep ON epp.ecw_adv_id = ep.ecw_adv_id "
                + " LEFT JOIN practice_master pm ON (pm.name =  py.account OR pm.practice_id = py.account) "
                + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                + " LEFT JOIN user_master um ON um.user_id = py.upd_by "
                + condition + " GROUP BY py.ecw_pmt_id) AS temp";

        try (Connection connection2 = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement2 = connection2.prepareStatement(countQuery); 
                ResultSet rs2 = preparedStatement2.executeQuery()) {
            while (rs2 != null && rs2.next()) {
                count = rs2.getInt("recordsTotal");
                returnObj.setFooterData(rs2.getString("totalCheckAmount"));
            }
        } catch (Exception e) {
            LOGGER.error("Exception while getting count value:", e);
        }
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String searchCountQuery = "SELECT IFNULL(COUNT(recordCount),0) AS recordsTotal, IFNULL(SUM(checkAmount),0) AS totalCheckAmount "
                    + "FROM ( SELECT py.ecw_pmt_id AS recordCount, IFNULL(py.check_amt,0) AS checkAmount "
                    + "FROM ecw_payment_xl py "
                    + " LEFT JOIN ecw_payment_advisory_xl epp ON py.ecw_pmt_id = epp.ecw_pmt_id "
                    + " LEFT JOIN ecw_payment_posting_xl ep ON epp.ecw_adv_id = ep.ecw_adv_id "
                    + " LEFT JOIN practice_master pm ON (pm.name =  py.account OR pm.practice_id = py.account) "
                    + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                    + " LEFT JOIN user_master um ON um.user_id = py.upd_by "
                    + condition + searchCondition + innerSearchCondition + " GROUP BY py.ecw_pmt_id) AS temp";

            try (Connection connection3 = template.getDataSource().getConnection(); 
                    PreparedStatement preparedStatement3 = connection3.prepareStatement(searchCountQuery); 
                    ResultSet rs3 = preparedStatement3.executeQuery()) {
                while (rs3 != null && rs3.next()) {
                    searchCount = rs3.getInt("recordsTotal");
                    returnObj.setFooterData(rs3.getString("totalCheckAmount"));
                }
            } catch (Exception e) {
                LOGGER.error("Exception while getting search count:", e);
            }
        }
        returnObj.setData(paymentData);
        returnObj.setDraw(pagingRequest.getDraw());
        returnObj.setRecordsTotal(count);
        returnObj.setRecordsFiltered(searchCount);
        returnObj.setExportData(StringUtilities.convertListToJson(paymentData));

        return returnObj;
    }

    public TablePage getEobAdvisoryData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE epp.eob_job_id > 0 AND epp.ecw_adv_id IS NOT NULL AND sm.entity_id = " + entityId;
        if (StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            if (innerQuery.contains(",")) {
                String[] parts = innerQuery.split(",");
                String last = parts[0].trim();
                String first = parts.length > 1 ? parts[1].trim() : "";
                innerSearchCondition = " AND (" + "(epp.patient_name LIKE '%" + last + "%' AND epp.patient_name LIKE '%" + first + "%')" + ")";
            } else {
                innerSearchCondition = " AND ("
                        + "epp.ecw_adv_id LIKE '%" + innerQuery + "%' OR epp.check_no LIKE '%" + innerQuery + "%' OR epp.claim_no LIKE '%" + innerQuery + "%' OR "
                        + "epp.dos LIKE '%" + innerQuery + "%' OR epp.patient_name LIKE '%" + innerQuery + "%' OR "
                        + "epp.billed LIKE '%" + innerQuery + "%' OR "
                        + "epp.allowed LIKE '%" + innerQuery + "%' OR epp.deduct LIKE '%" + innerQuery + "%' OR "
                        + "epp.coins LIKE '%" + innerQuery + "%' OR epp.copay LIKE '%" + innerQuery + "%' OR "
                        + "epp.paid LIKE '%" + innerQuery + "%' OR epp.adj LIKE '%" + innerQuery + "%' OR "
                        + "epp.cr_by LIKE '%" + innerQuery + "%' OR epp.eob_job_id LIKE '%" + innerQuery + "%' OR "
                        + "IFNULL(DATE_FORMAT(CONVERT(epp.cr_dt, DATE), '%m/%d/%Y'), '') LIKE '%" + innerQuery + "%' OR "
                        + "clp.segment LIKE '%" + innerQuery + "%' OR sm.ftpuser LIKE '%" + innerQuery + "%' OR epp.filename LIKE '%" + innerQuery + "%' OR "
                        + "epp.ecw_pmt_id LIKE '%" + innerQuery + "%'" + ")";
            }
        }

        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }
        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                String columnName = order.getColumnName();
                String orderColumn = null;
                orderColumn = switch (columnName) {
                    case "dos" -> " STR_TO_DATE(dos, '%m/%d/%Y') ";
                    case "createdDate" -> " DATE_FORMAT(CONVERT(epp.cr_dt, DATE), '%m/%d/%Y') ";
                    default -> order.getColumnName();
                };
                orderBy = orderBy + "," + orderColumn + " " + order.getDir();
           }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY epp.ecw_adv_id DESC ";
        }
        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn()) && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("epp.dos".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND epp.dos BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("epp.patient_name".equalsIgnoreCase(msColumns[columnIndex])) {
                    searchCondition += " AND (" + msColumns[columnIndex] + " LIKE '%" + msValues[columnIndex] + "%' )  ";
                } else if ("epp.check_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    searchCondition += " ";
                } else if ("epp.pmt_rcrd_dt".equalsIgnoreCase(msColumns[columnIndex])) {
                    searchCondition += " ";
                } else if ("epp.eob_job_id".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("~"))
                            .map(String::trim)
                            .collect(Collectors.joining(", "));
                    searchCondition = searchCondition
                            + " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else if ("sm.ftpuser".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("\\|"))
                            .map(p -> "'" + p.trim() + "'")
                            .collect(Collectors.joining(", "));
                    searchCondition += " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' )  ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<ExcelEobDto> advisoryData = new ArrayList<>();
        String query = " SELECT epp.ecw_adv_id, epp.check_no, epp.claim_no, epp.dos, epp.patient_name, epp.billed, epp.allowed, epp.deduct, epp.coins, epp.copay, epp.paid, epp.adj, "
                + " epp.cr_by AS createdBy, IFNULL(DATE_FORMAT(CONVERT(epp.cr_dt, DATE), '%m/%d/%Y'), '') AS createdDate, "
                + " sm.ftpuser AS account, epp.filename, epp.ecw_pmt_id, epp.eob_job_id AS eobJobId, clp.segment "
                + " FROM ecw_payment_advisory_xl epp "
                + " LEFT JOIN ecw_payment_xl py ON py.ecw_pmt_id = epp.ecw_pmt_id "
                + " LEFT JOIN ecw_payment_posting_xl ep ON ep.ecw_adv_id = epp.ecw_adv_id "
                + " LEFT JOIN practice_master pm ON (pm.name =  py.account OR pm.practice_id = py.account) "
                + " LEFT JOIN CLP02 clp ON clp.code = epp.status "
                + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                + condition + innerSearchCondition + searchCondition + " GROUP BY epp.ecw_adv_id " + orderBy + limit;
        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(query); 
                ResultSet rs = preparedStatement.executeQuery()) {
            while (rs != null && rs.next()) {
                ExcelEobDto excelEobDTO = new ExcelEobDto();
                excelEobDTO.setAdvisoryId(rs.getInt("ecw_adv_id"));
                excelEobDTO.setCheckNo(rs.getString("check_no"));
                excelEobDTO.setClaimNo(rs.getString("claim_no"));
                excelEobDTO.setDos(rs.getString("dos"));
                excelEobDTO.setPatientName(rs.getString("patient_name"));
                excelEobDTO.setBilled(rs.getString("billed"));
                excelEobDTO.setAllowed(rs.getString("allowed"));
                excelEobDTO.setDeduct(rs.getString("deduct"));
                excelEobDTO.setCoins(rs.getString("coins"));
                excelEobDTO.setCopay(rs.getString("copay"));
                excelEobDTO.setPaid(rs.getString("paid"));
                excelEobDTO.setAdj(rs.getString("adj"));
                excelEobDTO.setCreatedBy(rs.getString("createdBy"));
                excelEobDTO.setCreatedDate(rs.getString("createdDate"));
                excelEobDTO.setAccount(rs.getString("account"));
                excelEobDTO.setFileName(rs.getString("filename"));
                excelEobDTO.setEcwPaymentId(rs.getInt("ecw_pmt_id"));
                excelEobDTO.setEobJobId(rs.getInt("eobJobId"));
                excelEobDTO.setClaimStatus(rs.getString("segment"));
                advisoryData.add(excelEobDTO);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
        int count = 0;
        String countQuery = "SELECT IFNULL(COUNT(recordCount),0) AS recordsTotal, IFNULL(SUM(billed),0) AS totalBilledAmount, "
                + "IFNULL(SUM(allowed),0) AS totalAllowed, IFNULL(SUM(paid),0) AS totalPaid, IFNULL(SUM(adj),0) AS totalAdj "
                + "FROM ( SELECT epp.ecw_adv_id AS recordCount, IFNULL(epp.billed,0) AS billed, IFNULL(epp.allowed,0) AS allowed, "
                + "IFNULL(epp.paid,0) AS paid, IFNULL(epp.adj,0) AS adj "
                + "FROM ecw_payment_advisory_xl epp "
                + " LEFT JOIN ecw_payment_xl py ON py.ecw_pmt_id = epp.ecw_pmt_id "
                + " LEFT JOIN ecw_payment_posting_xl ep ON ep.ecw_adv_id = epp.ecw_adv_id "
                + " LEFT JOIN practice_master pm ON (pm.name =  py.account OR pm.practice_id = py.account) "
                + " LEFT JOIN CLP02 clp ON clp.code = epp.status "
                + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                + condition + " GROUP BY epp.ecw_adv_id) AS temp";

        try (Connection connection2 = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement2 = connection2.prepareStatement(countQuery); 
                ResultSet rs2 = preparedStatement2.executeQuery()) {
            while (rs2 != null && rs2.next()) {
                count = rs2.getInt("recordsTotal");
                returnObj.setFooterData(rs2.getString("totalBilledAmount") + "," + rs2.getString("totalAllowed")
                        + "," + rs2.getString("totalPaid") + "," + rs2.getString("totalAdj"));
            }
        } catch (Exception e) {
            LOGGER.error("Exception while getting count value:", e);
        }
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String searchCountQuery = "SELECT IFNULL(COUNT(recordCount),0) AS recordsTotal, IFNULL(SUM(billed),0) AS totalBilledAmount, "
                    + "IFNULL(SUM(allowed),0) AS totalAllowed, IFNULL(SUM(paid),0) AS totalPaid, IFNULL(SUM(adj),0) AS totalAdj "
                    + "FROM ( SELECT epp.ecw_adv_id AS recordCount, IFNULL(epp.billed,0) AS billed, IFNULL(epp.allowed,0) AS allowed, "
                    + "IFNULL(epp.paid,0) AS paid, IFNULL(epp.adj,0) AS adj "
                    + "FROM ecw_payment_advisory_xl epp "
                    + " LEFT JOIN ecw_payment_xl py ON py.ecw_pmt_id = epp.ecw_pmt_id "
                    + " LEFT JOIN ecw_payment_posting_xl ep ON ep.ecw_adv_id = epp.ecw_adv_id "
                    + " LEFT JOIN practice_master pm ON (pm.name =  py.account OR pm.practice_id = py.account) "
                    + " LEFT JOIN CLP02 clp ON clp.code = epp.status "
                    + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                    + condition + searchCondition + innerSearchCondition + " GROUP BY epp.ecw_adv_id) AS temp";
            try (Connection connection3 = template.getDataSource().getConnection(); 
                    PreparedStatement preparedStatement3 = connection3.prepareStatement(searchCountQuery); 
                    ResultSet rs3 = preparedStatement3.executeQuery()) {
                while (rs3 != null && rs3.next()) {
                    searchCount = rs3.getInt("recordsTotal");
                    returnObj.setFooterData(rs3.getString("totalBilledAmount") + "," + rs3.getString("totalAllowed")
                            + "," + rs3.getString("totalPaid") + "," + rs3.getString("totalAdj"));
                }
            } catch (Exception e) {
                LOGGER.error("Exception while getting search count:", e);
            }
        }
        returnObj.setData(advisoryData);
        returnObj.setDraw(pagingRequest.getDraw());
        returnObj.setRecordsTotal(count);
        returnObj.setRecordsFiltered(searchCount);
        returnObj.setExportData(StringUtilities.convertListToJson(advisoryData));

        return returnObj;
    }

    public TablePage getEobPostingData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE ep.eob_job_id > 0 AND ep.ecw_pmt_posting_id IS NOT NULL AND sm.entity_id = " + entityId;
        if (StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " AND ("
                    + "ep.ecw_pmt_posting_id LIKE '%" + innerQuery + "%' OR sm.ftpuser LIKE '%" + innerQuery
                    + "%' OR ep.check_no LIKE '%" + innerQuery + "%' OR ep.claim_no LIKE '%" + innerQuery + "%' OR "
                    + "ep.service_dt LIKE '%" + innerQuery + "%' OR ep.units LIKE '%" + innerQuery + "%' OR "
                    + "ep.billed LIKE '%" + innerQuery + "%' OR  ep.paid LIKE '%" + innerQuery + "%' OR "
                    + "ep.allowed LIKE '%" + innerQuery + "%' OR ep.deduct LIKE '%" + innerQuery + "%' OR "
                    + "ep.coins LIKE '%" + innerQuery + "%' OR ep.copay LIKE '%" + innerQuery + "%' OR "
                    + "ep.adj LIKE '%" + innerQuery + "%' OR ep.eob_job_id LIKE '%" + innerQuery + "%' OR "
                    + "ep.code_comma_sep LIKE '%" + innerQuery + "%' OR ep.cr_by LIKE '%" + innerQuery + "%' OR "
                    + "IFNULL(DATE_FORMAT(CONVERT(ep.cr_dt, DATE), '%m/%d/%Y'), '') LIKE '%" + innerQuery + "%' OR ep.code LIKE '%" + innerQuery + "%' OR  "
                    + "clp.segment LIKE '%" + innerQuery + "%' OR sm.client_name LIKE '%" + innerQuery + "%' OR ep.filename LIKE '%" + innerQuery + "%' OR "
                    + "ep.ecw_adv_id LIKE '%" + innerQuery + "%'" + ")";
        }

        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }
        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                String columnName = order.getColumnName();
                String orderColumn = null;
                orderColumn = switch (columnName) {
                    case "service_dt" -> " STR_TO_DATE(ep.service_dt, '%m/%d/%Y') ";
                    case "createdDate" -> " DATE_FORMAT(CONVERT(ep.cr_dt, DATE), '%m/%d/%Y') ";
                    default -> order.getColumnName();
                };
                orderBy = orderBy + "," + orderColumn + " " + order.getDir();
            }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY ep.ecw_pmt_posting_id DESC ";
        }

        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn()) && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("ep.service_dt".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND ep.service_dt BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("ep.check_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    searchCondition += " ";
                } else if ("ep.pmt_rcrd_dt".equalsIgnoreCase(msColumns[columnIndex])) {
                    searchCondition += " ";
                } else if ("ep.eob_job_id".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("~"))
                            .map(String::trim)
                            .collect(Collectors.joining(", "));
                    searchCondition = searchCondition
                            + " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else if ("sm.ftpuser".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("\\|"))
                            .map(p -> "'" + p.trim() + "'")
                            .collect(Collectors.joining(", "));
                    searchCondition += " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' )  ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<ExcelEobDto> postingData = new ArrayList<>();

        String query = "SELECT ep.ecw_pmt_posting_id, ep.check_no, ep.claim_no, ep.service_dt, ep.units, ep.code, ep.billed, ep.allowed,"
                + " ep.deduct, ep.coins, ep.copay, ep.paid, ep.adj, ep.code_comma_sep,"
                + "ep.cr_by AS createdBy, IFNULL(DATE_FORMAT(CONVERT(ep.cr_dt, DATE), '%m/%d/%Y'), '') AS createdDate, "
                + "sm.ftpuser AS account, ep.filename, ep.ecw_adv_id, ep.eob_job_id AS eobJobId, clp.segment "
                + "FROM ecw_payment_posting_xl ep "
                + " LEFT JOIN practice_master pm ON (pm.name =  ep.account OR pm.practice_id = ep.account) "
                + " LEFT JOIN ecw_payment_advisory_xl epp ON epp.ecw_adv_id = ep.ecw_adv_id "
                + " LEFT JOIN ecw_payment_xl py ON py.ecw_pmt_id = epp.ecw_pmt_id "
                + " LEFT JOIN CLP02 clp ON clp.code = epp.status "
                + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                + condition + innerSearchCondition + searchCondition + orderBy + limit;
        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(query); 
                ResultSet rs = preparedStatement.executeQuery()) {
            while (rs != null && rs.next()) {
                ExcelEobDto dto = new ExcelEobDto();
                dto.setPostingId(rs.getInt("ecw_pmt_posting_id"));
                dto.setCheckNo(rs.getString("check_no"));
                dto.setClaimNo(rs.getString("claim_no"));
                dto.setDos(rs.getString("service_dt"));
                dto.setUnits(rs.getString("units"));
                dto.setCode(rs.getString("code"));
                dto.setBilled(rs.getString("billed"));
                dto.setAllowed(rs.getString("allowed"));
                dto.setDeduct(rs.getString("deduct"));
                dto.setCoins(rs.getString("coins"));
                dto.setCopay(rs.getString("copay"));
                dto.setPaid(rs.getString("paid"));
                dto.setAdj(rs.getString("adj"));
                dto.setReasonCode(rs.getString("code_comma_sep"));
                dto.setCreatedBy(rs.getString("createdBy"));
                dto.setCreatedDate(rs.getString("createdDate"));
                dto.setAccount(rs.getString("account"));
                dto.setFileName(rs.getString("filename"));
                dto.setAdvisoryId(rs.getInt("ecw_adv_id"));
                dto.setEobJobId(rs.getInt("eobJobId"));
                dto.setClaimStatus(rs.getString("segment"));
                postingData.add(dto);
            }

        } catch (Exception e) {
            LOGGER.error("Exception in getEobPostingData:", e);
        }
        int count = 0;
        String countQuery = "SELECT IFNULL(COUNT(recordCount),0) AS recordsTotal, IFNULL(SUM(billed),0) AS totalBilledAmount, "
                + "IFNULL(SUM(allowed),0) AS totalAllowed, IFNULL(SUM(paid),0) AS totalPaid, IFNULL(SUM(adj),0) AS totalAdj "
                + "FROM ( SELECT ep.ecw_pmt_posting_id AS recordCount, IFNULL(ep.billed,0) AS billed, IFNULL(ep.allowed,0) AS allowed, "
                + "IFNULL(ep.paid,0) AS paid, IFNULL(ep.adj,0) AS adj "
                + "FROM ecw_payment_posting_xl ep "
                + " LEFT JOIN practice_master pm ON (pm.name = ep.account OR pm.practice_id = ep.account) "
                + " LEFT JOIN ecw_payment_advisory_xl epp ON epp.ecw_adv_id = ep.ecw_adv_id "
                + " LEFT JOIN ecw_payment_xl py ON py.ecw_pmt_id = epp.ecw_pmt_id "
                + " LEFT JOIN CLP02 clp ON clp.code = epp.status "
                + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                + condition + " GROUP BY ep.ecw_pmt_posting_id) AS temp";

        try (Connection connection2 = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement2 = connection2.prepareStatement(countQuery); 
                ResultSet rs2 = preparedStatement2.executeQuery()) {
            while (rs2 != null && rs2.next()) {
                count = rs2.getInt("recordsTotal");
                returnObj.setFooterData(rs2.getString("totalBilledAmount") + "," + rs2.getString("totalAllowed")
                        + "," + rs2.getString("totalPaid") + "," + rs2.getString("totalAdj"));
            }
        } catch (Exception e) {
            LOGGER.error("Exception while getting count value:", e);
        }
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String searchCountQuery = " SELECT IFNULL(COUNT(recordCount),0) AS recordsTotal, IFNULL(SUM(billed),0) AS totalBilledAmount, "
                    + " IFNULL(SUM(allowed),0) AS totalAllowed, IFNULL(SUM(paid),0) AS totalPaid, IFNULL(SUM(adj),0) AS totalAdj "
                    + " FROM ( SELECT ep.ecw_pmt_posting_id AS recordCount, IFNULL(ep.billed,0) AS billed, IFNULL(ep.allowed,0) AS allowed, "
                    + " IFNULL(ep.paid,0) AS paid, IFNULL(ep.adj,0) AS adj "
                    + " FROM ecw_payment_posting_xl ep "
                    + " LEFT JOIN practice_master pm ON (pm.name = ep.account OR pm.practice_id = ep.account) "
                    + " LEFT JOIN ecw_payment_advisory_xl epp ON epp.ecw_adv_id = ep.ecw_adv_id "
                    + " LEFT JOIN ecw_payment_xl py ON py.ecw_pmt_id = epp.ecw_pmt_id "
                    + " LEFT JOIN CLP02 clp ON clp.code = epp.status "
                    + " LEFT JOIN subscription_master sm ON (sm.ftpuser = py.account OR sm.tid =  pm.account_id) "
                    + condition + searchCondition + innerSearchCondition + " GROUP BY ep.ecw_pmt_posting_id) AS temp ";

            try (Connection connection3 = template.getDataSource().getConnection(); 
                    PreparedStatement preparedStatement3 = connection3.prepareStatement(searchCountQuery); 
                    ResultSet rs3 = preparedStatement3.executeQuery()) {
                while (rs3 != null && rs3.next()) {
                    searchCount = rs3.getInt("recordsTotal");
                    returnObj.setFooterData(rs3.getString("totalBilledAmount") + "," + rs3.getString("totalAllowed")
                            + "," + rs3.getString("totalPaid") + "," + rs3.getString("totalAdj"));
                }
            } catch (Exception e) {
                LOGGER.error("Exception while getting search count:", e);
            }
        }
        returnObj.setData(postingData);
        returnObj.setDraw(pagingRequest.getDraw());
        returnObj.setRecordsTotal(count);
        returnObj.setRecordsFiltered(searchCount);
        returnObj.setExportData(StringUtilities.convertListToJson(postingData));
        return returnObj;
    }

    public int insertEobJob(int jobType, String practiceId, String fileName, Long createdBy) throws SQLException {
        LOGGER.info("fileName = " + fileName);
        String sql = "INSERT INTO eob_jobs (eob_job_type, practice_id, filename, created_on, created_by, status) VALUES (?, ?, ?, NOW(), ?, ?)";
        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            preparedStatement.setInt(1, jobType);
            preparedStatement.setString(2, practiceId);
            preparedStatement.setString(3, fileName);
            preparedStatement.setLong(4, createdBy);
            preparedStatement.setString(5, "File uploaded");
            preparedStatement.executeUpdate();
            try (ResultSet rs = preparedStatement.getGeneratedKeys()) {
                if (rs != null && rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean isCheckNumberExistsInERA(final String checkNo, final String practiceId) throws SQLException {
        String sql = "SELECT 1 FROM eobdetails WHERE eft = ? AND exception = 0 AND "
                + "ftp_username IN (SELECT ftpuser FROM subscription_master "
                + "WHERE tid = (SELECT account_id FROM practice_master "
                + "WHERE practice_id = ?)) ";
        try {            
            Integer result = template.queryForObject(sql, new Object[]{checkNo, practiceId},
                    (rs, rowNum) -> rs.getInt(1));
            LOGGER.info("Check number in ERA: {}", checkNo);
            LOGGER.info("Result: {}", result);
            return result != null && result == 1;
        } catch (EmptyResultDataAccessException e) {
            LOGGER.info("Check number not found in ERA: {}", checkNo);
            return false;
        }
    }

    public boolean isCheckNumberExistsInPayment(String checkNo, String practiceId) throws SQLException {
        String sql = "SELECT 1 FROM ecw_payment_xl WHERE check_no = ? AND account = ?";
        try {
            Integer result = template.queryForObject(sql, new Object[]{checkNo, practiceId},
                    (rs, rowNum) -> rs.getInt(1));
            return result != null && result == 1;
        } catch (EmptyResultDataAccessException e) {
            LOGGER.info("Check number not found: {}", checkNo);
            return false;
        }
    }

    public int insertEcwPaymentSkipDup(String checkNo, String checkDate, String checkAmt, String pmtFrom,
            String pmtId, String pmtRcrdDt, Long createdBy, String status,
            String account, String fileName, int eobJobId) {

        if (pmtId != null && pmtId.endsWith(".0")) {
            pmtId = pmtId.replace(".0", "");
        }

        if (StringUtils.isAnyBlank(checkNo, checkDate, pmtId, checkAmt)) {
            status = "Exception";
        }
        final String finalPmtId = pmtId;
        final String finalStatus = status;
        String sql = "INSERT INTO ecw_payment_xl "
                + "(check_no, check_date, check_amt, pmt_from, pmt_id, pmt_rcrd_dt, cr_by, cr_dt, status, account, filename, eob_job_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?)";

        KeyHolder keyHolder = new GeneratedKeyHolder();

        try {
            template.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

                ps.setString(1, checkNo);
                ps.setString(2, checkDate);
                ps.setString(3, checkAmt);
                ps.setString(4, pmtFrom);
                ps.setString(5, finalPmtId);
                ps.setString(6, pmtRcrdDt);
                ps.setLong(7, createdBy);
                ps.setString(8, finalStatus);
                ps.setString(9, account);
                ps.setString(10, fileName);
                ps.setInt(11, eobJobId);

                return ps;
            }, keyHolder);

            if (keyHolder.getKey() != null) {
                return keyHolder.getKey().intValue();
            }

        } catch (DuplicateKeyException e) {
            LOGGER.info("Duplicate ecw_payment_xl skipped: checkNo=" + checkNo);
            return 0;
        }
        return 0;
    }

//    public int insertEcwPaymentSkipDup(String checkNo, String checkDate, String checkAmt, String pmtFrom,
//            String pmtId, String pmtRcrdDt, Long createdBy, String status,
//            String account, String fileName, int eobJobId) throws SQLException {
//        if (pmtId.matches("\\d+\\.0")) {
//            pmtId = pmtId.replace(".0", "");
//        }
//        String sql = "INSERT INTO ecw_payment_xl (check_no, check_date, check_amt, pmt_from, pmt_id, pmt_rcrd_dt, cr_by, cr_dt, status, account, filename, eob_job_id) "
//                + "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?)";
//        try (Connection con = template.getDataSource().getConnection(); 
//                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            
//            if (StringUtils.isAnyBlank(checkNo, checkDate, pmtId, checkAmt)) {
//              status = "Exception";
//            }
//
//            ps.setString(1, checkNo);
//            ps.setString(2, checkDate);
//            ps.setString(3, checkAmt);
//            ps.setString(4, pmtFrom);
//            ps.setString(5, pmtId);
//            ps.setString(6, pmtRcrdDt);
//            ps.setLong(7, createdBy);
//            ps.setString(8, status);
//            ps.setString(9, account);
//            ps.setString(10, fileName);
//            ps.setInt(11, eobJobId);
//
//            ps.executeUpdate();
//            try (ResultSet rs = ps.getGeneratedKeys()) {
//                if (rs != null && rs.next()) {
//                    return rs.getInt(1);
//                }
//            }
//        } catch (SQLIntegrityConstraintViolationException e) {
//            LOGGER.warn("Duplicate ecw_payment_xl skipped: checkNo=" + checkNo);
//            return 0;
//        }
//        return 0;
//    }
//    public int insertEcwPaymentAdvisorySkipDup(String checkNo, String claimNo, String dos, String patientName,
//            String billed, String allowed, String deduct, String coins,
//            String copay, String paid, String adj, String withheld, String code, String claimBalance,
//            Long createdBy, String account, String fileName, int eobJobId, int ecwPmtId, int status) throws SQLException {
//
//        billed = StringUtilities.roundToTwoDecimal(billed.isEmpty() ? "0" : billed);
//        allowed = StringUtilities.roundToTwoDecimal(allowed.isEmpty() ? "0" : allowed);
//        deduct = StringUtilities.roundToTwoDecimal(deduct.isEmpty() ? "0" : deduct);
//        coins = StringUtilities.roundToTwoDecimal(coins.isEmpty() ? "0" : coins);
//        copay = StringUtilities.roundToTwoDecimal(copay.isEmpty() ? "0" : copay);
//        paid = StringUtilities.roundToTwoDecimal(paid.isEmpty() ? "0" : paid);
//        adj = StringUtilities.roundToTwoDecimal(adj.isEmpty() ? "0" : adj);
//
//        String sql = "INSERT INTO ecw_payment_advisory_xl (check_no, claim_no, dos, patient_name, billed, allowed, deduct, coins, copay, paid, adj, withheld, code, claim_balance, cr_by, cr_dt, account, filename, eob_job_id, ecw_pmt_id, status) "
//                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?)";
//
//        try (Connection con = template.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//
//            ps.setString(1, checkNo);
//            ps.setString(2, claimNo);
//            ps.setString(3, dos);
//            ps.setString(4, patientName);
//            ps.setString(5, billed);
//            ps.setString(6, allowed);
//            ps.setString(7, deduct);
//            ps.setString(8, coins);
//            ps.setString(9, copay);
//            ps.setString(10, paid);
//            ps.setString(11, adj);
//            ps.setString(12, withheld);
//            ps.setString(13, code);
//            ps.setString(14, claimBalance);
//            ps.setLong(15, createdBy);
//            ps.setString(16, account);
//            ps.setString(17, fileName);
//            ps.setInt(18, eobJobId);
//            ps.setInt(19, ecwPmtId);
//            ps.setInt(20, status);
//
//            ps.executeUpdate();
//            try (ResultSet rs = ps.getGeneratedKeys()) {
//                if (rs != null && rs.next()) {
//                    return rs.getInt(1);
//                }
//            }
//        } catch (SQLIntegrityConstraintViolationException e) {
//            LOGGER.warn("Duplicate ecw_payment_advisory_xl skipped: checkNo=" + checkNo + ", claimNo=" + claimNo);
//        }
//        return 0;
//    }
    public int insertEcwPaymentAdvisorySkipDup(String checkNo, String claimNo, String dos, String patientName,
            String billed, String allowed, String deduct, String coins,
            String copay, String paid, String adj, String withheld, String code, String claimBalance,
            Long createdBy, String account, String fileName, int eobJobId, int ecwPmtId, int status) {

        billed = StringUtilities.roundToTwoDecimal(billed.isEmpty() ? "0" : billed);
        allowed = StringUtilities.roundToTwoDecimal(allowed.isEmpty() ? "0" : allowed);
        deduct = StringUtilities.roundToTwoDecimal(deduct.isEmpty() ? "0" : deduct);
        coins = StringUtilities.roundToTwoDecimal(coins.isEmpty() ? "0" : coins);
        copay = StringUtilities.roundToTwoDecimal(copay.isEmpty() ? "0" : copay);
        paid = StringUtilities.roundToTwoDecimal(paid.isEmpty() ? "0" : paid);
        adj = StringUtilities.roundToTwoDecimal(adj.isEmpty() ? "0" : adj);

        final String finalBilled = billed;
        final String finalAllowed = allowed;
        final String finalDeduct = deduct;
        final String finalCoins = coins;
        final String finalCopay = copay;
        final String finalPaid = paid;
        final String finalAdj = adj;

        String sql = "INSERT INTO ecw_payment_advisory_xl "
                + "(check_no, claim_no, dos, patient_name, billed, allowed, deduct, coins, copay, paid, adj, withheld, code, claim_balance, cr_by, cr_dt, account, filename, eob_job_id, ecw_pmt_id, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?)";

        KeyHolder keyHolder = new GeneratedKeyHolder();

        try {
            template.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

                ps.setString(1, checkNo);
                ps.setString(2, claimNo);
                ps.setString(3, dos);
                ps.setString(4, patientName);
                ps.setString(5, finalBilled);
                ps.setString(6, finalAllowed);
                ps.setString(7, finalDeduct);
                ps.setString(8, finalCoins);
                ps.setString(9, finalCopay);
                ps.setString(10, finalPaid);
                ps.setString(11, finalAdj);
                ps.setString(12, withheld);
                ps.setString(13, code);
                ps.setString(14, claimBalance);
                ps.setLong(15, createdBy);
                ps.setString(16, account);
                ps.setString(17, fileName);
                ps.setInt(18, eobJobId);
                ps.setInt(19, ecwPmtId);
                ps.setInt(20, (status > 2) ? 1 : status);

                return ps;
            }, keyHolder);

            if (keyHolder.getKey() != null) {
                return keyHolder.getKey().intValue();
            }

        } catch (DuplicateKeyException e) {
            LOGGER.info("Duplicate ecw_payment_advisory_xl skipped: checkNo=" + checkNo + ", claimNo=" + claimNo);
        }
        return 0;
    }

    public void insertEcwPaymentPostingSkipDup(String checkNo, String claimNo, String serviceDt, String code,
            String billed, String allowed, String deduct, String coins,
            String copay, String paid, String adj, String codeCommaSep, Long createdBy,
            String account, String fileName, int eobJobId, int ecwAdvId) {

        billed = StringUtilities.roundToTwoDecimal(billed.isEmpty() ? "0" : billed);
        allowed = StringUtilities.roundToTwoDecimal(allowed.isEmpty() ? "0" : allowed);
        deduct = StringUtilities.roundToTwoDecimal(deduct.isEmpty() ? "0" : deduct);
        coins = StringUtilities.roundToTwoDecimal(coins.isEmpty() ? "0" : coins);
        copay = StringUtilities.roundToTwoDecimal(copay.isEmpty() ? "0" : copay);
        paid = StringUtilities.roundToTwoDecimal(paid.isEmpty() ? "0" : paid);
        adj = StringUtilities.roundToTwoDecimal(adj.isEmpty() ? "0" : adj);

        final String finalBilled = billed;
        final String finalAllowed = allowed;
        final String finalDeduct = deduct;
        final String finalCoins = coins;
        final String finalCopay = copay;
        final String finalPaid = paid;
        final String finalAdj = adj;

        final String finalCodeCommaSep= (StringUtilities.isNotEmpty(codeCommaSep) && codeCommaSep.matches("^[A-Za-z]{2}-.*$")) ? codeCommaSep : "";

        String sql = "INSERT INTO ecw_payment_posting_xl "
                + "(check_no, claim_no, service_dt, code, billed, allowed, deduct, coins, copay, paid, adj, code_comma_sep, cr_by, cr_dt, account, filename, eob_job_id, ecw_adv_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?)";

        try {
            template.update(sql,checkNo,claimNo,serviceDt,code,finalBilled,finalAllowed,finalDeduct,finalCoins,finalCopay,finalPaid,finalAdj,
                    finalCodeCommaSep,createdBy,account,fileName,eobJobId,ecwAdvId);

        } catch (DuplicateKeyException e) {
            LOGGER.info("Duplicate ecw_payment_posting_xl skipped: checkNo=" + checkNo + ", claimNo=" + claimNo);
        }
    }

//    public void insertEcwPaymentPostingSkipDup(String checkNo, String claimNo, String serviceDt, String code,
//            String billed, String allowed, String deduct, String coins,
//            String copay, String paid, String adj, String codeCommaSep, Long createdBy,
//            String account, String fileName, int eobJobId, int ecwAdvId) throws SQLException {
//
//        billed = StringUtilities.roundToTwoDecimal(billed.isEmpty() ? "0" : billed);
//        allowed = StringUtilities.roundToTwoDecimal(allowed.isEmpty() ? "0" : allowed);
//        deduct = StringUtilities.roundToTwoDecimal(deduct.isEmpty() ? "0" : deduct);
//        coins = StringUtilities.roundToTwoDecimal(coins.isEmpty() ? "0" : coins);
//        copay = StringUtilities.roundToTwoDecimal(copay.isEmpty() ? "0" : copay);
//        paid = StringUtilities.roundToTwoDecimal(paid.isEmpty() ? "0" : paid);
//        adj = StringUtilities.roundToTwoDecimal(adj.isEmpty() ? "0" : adj);
//
//        String sql = "INSERT INTO ecw_payment_posting_xl (check_no, claim_no, service_dt, code, billed, allowed, deduct, coins, copay, paid, adj, code_comma_sep, cr_by, cr_dt, account, filename, eob_job_id, ecw_adv_id) "
//                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?)";
//
//        try (Connection con = template.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setString(1, checkNo);
//            ps.setString(2, claimNo);
//            ps.setString(3, serviceDt);
//            ps.setString(4, code);
//            ps.setString(5, billed);
//            ps.setString(6, allowed);
//            ps.setString(7, deduct);
//            ps.setString(8, coins);
//            ps.setString(9, copay);
//            ps.setString(10, paid);
//            ps.setString(11, adj);
//            if (StringUtilities.isNotEmpty(codeCommaSep) && codeCommaSep.matches("^[A-Za-z]{2}-.*$")) {
//                ps.setString(12, codeCommaSep);
//            } else {
//                ps.setString(12, "");
//            }
//            ps.setLong(13, createdBy);
//            ps.setString(14, account);
//            ps.setString(15, fileName);
//            ps.setInt(16, eobJobId);
//            ps.setInt(17, ecwAdvId);
//
//            ps.executeUpdate();
//        } catch (SQLIntegrityConstraintViolationException e) {
//            LOGGER.warn("Duplicate ecw_payment_posting_xl skipped: checkNo=" + checkNo + ", claimNo=" + claimNo);
//        }
//    }
    public void updateEobJobStatus(final int eobJobId, final int totalXlRows, final String status) throws SQLException {
        if (eobJobId <= 0 || status == null || status.trim().isEmpty()) {
            return;
        }

        String selectAbsorbedSql = "SELECT COUNT(eob_job_id) AS absorbedRecords FROM ecw_payment_posting_xl WHERE eob_job_id = ?";
        String updateWithCountsSql = "UPDATE eob_jobs SET status = ?, totalXlRows = ?, absorbedRecords = ? WHERE eob_job_id = ?";
        String updateStatusOnlySql = "UPDATE eob_jobs SET status = ? WHERE eob_job_id = ?";

        try (Connection con = template.getDataSource().getConnection()) {
            try {
                con.setAutoCommit(false);

                int updatedRows;

                if (totalXlRows > 0) {
                    int absorbedRecords;
                    try (PreparedStatement psSelect = con.prepareStatement(selectAbsorbedSql)) {
                        psSelect.setInt(1, eobJobId);
                        try (ResultSet rs = psSelect.executeQuery()) {
                            absorbedRecords = rs.next() ? rs.getInt("absorbedRecords") : 0;
                        }
                    }

                    try (PreparedStatement psUpdate = con.prepareStatement(updateWithCountsSql)) {
                        psUpdate.setString(1, status);
                        psUpdate.setInt(2, totalXlRows);
                        psUpdate.setInt(3, absorbedRecords);
                        psUpdate.setInt(4, eobJobId);
                        updatedRows = psUpdate.executeUpdate();
                    }
                } else {
                    try (PreparedStatement psUpdate = con.prepareStatement(updateStatusOnlySql)) {
                        psUpdate.setString(1, status);
                        psUpdate.setInt(2, eobJobId);
                        updatedRows = psUpdate.executeUpdate();
                    }
                }

                if (updatedRows > 0 && "Staging Removed".equalsIgnoreCase(status)) {
                    deleteRelatedEobDataByJobId(eobJobId);
                }

                con.commit();
            } catch (SQLException ex) {
                if (con != null) {
                    try {
                        con.rollback();
                    } catch (SQLException ignored) {
                    }
                }
                throw ex;
            }
        }
    }

    public void moveDataFromStagingToLivePayment(final Long userId, List<Integer> pmtIdList) throws SQLException {
        String pmtIds = pmtIdList.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
        try (Connection con = template.getDataSource().getConnection()) {
            con.setAutoCommit(false);
            try {
                CallableStatement callableStatement = con.prepareCall("{call create_paper_eob_entry(?,?)}");
                callableStatement.setLong(1, userId);
                callableStatement.setString(2, pmtIds);
                callableStatement.executeUpdate();
                con.commit();
            } catch (SQLException ex) {
                if (con != null) {
                    try {
                        con.rollback();
                    } catch (SQLException ignored) {
                    }
                }
                throw ex;
            } finally {
                if (con != null) {
                    try {
                        con.setAutoCommit(true);
                        con.close();
                    } catch (SQLException ignored) {
                    }
                }
            }
        }
    }

    public void moveDataFromStagingToLive(int eobJobId) throws SQLException {
        try (Connection con = template.getDataSource().getConnection()) {
            con.setAutoCommit(false);
            try {
                CallableStatement callableStatement = con.prepareCall("{call create_paper_eob_entry_v1(?)}"); //TODO Please Create further Procedure for this
                callableStatement.setInt(1, eobJobId);
                callableStatement.executeUpdate();
                con.commit();
            } catch (SQLException ex) {
                if (con != null) {
                    try {
                        con.rollback();
                    } catch (SQLException ignored) {
                    }
                }
                throw ex;
            } finally {
                if (con != null) {
                    try {
                        con.setAutoCommit(true);
                        con.close();
                    } catch (SQLException ignored) {
                    }
                }
            }
        }
    }

    public void deleteRelatedEobDataByJobId(int eobJobId) throws SQLException {
        try (Connection con = template.getDataSource().getConnection()) {
            con.setAutoCommit(false);
            try {
                for (String table : tables) {
                    String sql = "DELETE FROM " + table + " WHERE eob_job_id = ?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setInt(1, eobJobId);
                        ps.executeUpdate();
                    }
                }
                con.commit();
            } catch (SQLException e) {
                if (con != null) {
                    try {
                        con.rollback();
                    } catch (SQLException ignored) {
                    }
                }
                throw e;
            } finally {
                if (con != null) {
                    try {
                        con.setAutoCommit(true);
                        con.close();
                    } catch (SQLException ignored) {
                    }
                }
            }
        }
    }

    public Integer getExistingEcwPaymentId(String checkNo, String practiceId, int eobJobId) throws SQLException {
        String sql = "SELECT ecw_pmt_id FROM ecw_payment_xl WHERE eob_job_id = ? AND check_no = ? AND account = ? LIMIT 1";

        List<Integer> result = template.queryForList(sql, Integer.class, eobJobId, checkNo, practiceId);
        return result.isEmpty() ? null : result.get(0);
    }

    public void updateEcwPayment(final int ecwPmtId) throws Exception {
        String sql
                = "UPDATE ecw_payment_xl "
                + "SET check_amt = ( "
                + "   SELECT COALESCE(SUM(paid), 0) "
                + "   FROM ecw_payment_advisory_xl "
                + "   WHERE ecw_pmt_id = ? "
                + ") "
                + "WHERE ecw_pmt_id = ?";
        template.update(sql, ecwPmtId, ecwPmtId);
    }

}
