package com.billingparadise.web.dao;

import com.billingparadise.web.beans.AdvancedMDEob;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

/**
 *
 * @author Sivananthi
 */
@Service
public class AdvancedMDEobDao {

    @Autowired
    private JdbcTemplate template;
    private static final Logger LOGGER = LoggerFactory.getLogger(AdvancedMDEobDao.class);

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

   public List<Integer> getAdvancedMdJobId() {
    return template.query(
        "SELECT DISTINCT eob_job_id FROM advancemd_eob_jobs ORDER BY eob_job_id DESC",
        (rs, rowNum) -> rs.getInt("eob_job_id")
    );
}

    public String saveEobUploadLog(String fileName, String practiceId, String jobTypeId, int totalRows, int absorbedRows, Long userId) {

        String insertQuery = "INSERT INTO advancemd_eob_jobs "
                + "(eob_job_type, ftp_user, filename, totalXlRows, absorbedRecords, created_on, created_by, status) "
                + "VALUES (?, ?, ?, ?, ?, NOW(), ?, ?)";
        template.update(insertQuery, jobTypeId, practiceId, fileName, totalRows, absorbedRows, userId, "File uploaded");
        return "Success";
    }

    public TablePage getAdvancedMDEobLogData(final Long entityId, final Long userType, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        UserRole loggedUserRole = UserRole.get(userType);
        if (UserRole.ROLE_ADMIN != loggedUserRole) {
            if (null == loggedUserRole) {
                condition = " WHERE sm.entity_id = '" + entityId + "' AND sm.active = 1 ";
            } else {
                switch (loggedUserRole) {
                    case ROLE_ENTITY_ADMIN:
                    case ROLE_ENTITY_STAFF:
                    case ROLE_ZONE_MANAGER:
                    case ROLE_ZONE_LEAD:
                    case ROLE_DIVISION_MANAGER:
                    case ROLE_DIVISION_LEAD:
                        condition = " WHERE sm.entity_id = '" + entityId + "' AND sm.active = 1 ";
                        break;
                }
            }
        } else {
            condition = " WHERE sm.entity_id = " + entityId;
        }
        if (pagingRequest.getInnerSearchValue() != null && StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " AND ("
                    + "aej.eob_job_id LIKE '%" + innerQuery + "%' OR "
                    + "aej.eob_job_type LIKE '%" + innerQuery + "%' OR "
                    + "aejftp_user LIKE '%" + innerQuery + "%' OR "
                    + "aej.filename LIKE '%" + innerQuery + "%' OR "
                    + "um.first_name LIKE '%" + innerQuery + "%' OR "
                    + "IFNULL(DATE_FORMAT(CONVERT(aej.created_on, DATE), '%m/%d/%Y'), '') LIKE '%" + innerQuery + "%' OR "
                    + "aej.status LIKE '%" + innerQuery + "%' OR "
                    + "aej.totalXlRows LIKE '%" + innerQuery + "%' OR "
                    + "aej.absorbedRecords LIKE '%" + innerQuery + "%'"
                    + ")";
        }

        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }
        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                String columnName = order.getColumnName();
                String orderColumn = null;
                orderColumn = switch (columnName) {
                    case "createdDate" ->
                        " created_on ";
                    default ->
                        order.getColumnName();
                };
                orderBy = orderBy + "," + orderColumn + " " + order.getDir();
            }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY nj.eob_job_id DESC ";
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
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' )  ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<AdvancedMDEob> advancedMDEobLogData = new ArrayList<>();
        String query = "SELECT aej.eob_job_id, jt.job_type,aej.eob_job_type, aej.ftp_user, aej.filename, IFNULL(um.first_name,'') AS createdBy, "
                + "IFNULL(DATE_FORMAT(CONVERT(aej.created_on, DATE), '%m/%d/%Y'), '') AS createdDate, "
                + "aej.status, aej.totalXlRows, aej.absorbedRecords "
                + "FROM advancemd_eob_jobs aej "
                + "LEFT JOIN user_master um ON um.user_id = aej.created_by "
                + "LEFT JOIN job_type jt ON jt.jobtypeid = aej.eob_job_type "
                + "LEFT JOIN practice_master pm ON (pm.name =  aej.ftp_user OR pm.practice_id = aej.ftp_user) "
                + " LEFT JOIN subscription_master sm ON (sm.ftpuser = aej.ftp_user OR sm.tid =  pm.account_id) "
                + condition + innerSearchCondition + searchCondition + orderBy + limit;
        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(query); 
                ResultSet rs = preparedStatement.executeQuery()) {
            LOGGER.info("Log table   :-----" + query);
            while (rs != null && rs.next()) {
                AdvancedMDEob advancedMDEob = new AdvancedMDEob();
                advancedMDEob.setEobJobId(rs.getInt("eob_job_id"));
                advancedMDEob.setEobJobType(rs.getString("job_type"));
                advancedMDEob.setFtpUser(rs.getString("ftp_user"));
                advancedMDEob.setFileName(rs.getString("filename"));
                advancedMDEob.setCreatedBy(rs.getString("createdBy"));
                advancedMDEob.setCreatedDate(rs.getString("createdDate"));
                advancedMDEob.setTotalXlRows(rs.getInt("totalXlRows"));
                advancedMDEob.setAbsorbedRows(rs.getInt("absorbedRecords"));
                advancedMDEob.setStatus(rs.getString("status"));
                advancedMDEobLogData.add(advancedMDEob);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }

        String countQuery = "SELECT COUNT(aej.eob_job_id) FROM advancemd_eob_jobs aej "
                + "LEFT JOIN practice_master pm ON (pm.name =  aej.ftp_user OR pm.practice_id = aej.ftp_user) "
                + " LEFT JOIN subscription_master sm ON (sm.ftpuser = aej.ftp_user OR sm.tid =  pm.account_id) "
                + condition;
        int count = template.queryForObject(countQuery, Integer.class);
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String countSearchQuery = "SELECT COUNT(aej.eob_job_id) FROM advancemd_eob_jobs aej "
                    + "LEFT JOIN user_master um ON um.user_id = aej.created_by "
                    + "LEFT JOIN practice_master pm ON (pm.name =  aej.ftp_user OR pm.practice_id = aej.ftp_user) "
                    + " LEFT JOIN subscription_master sm ON (sm.ftpuser = aej.ftp_user OR sm.tid =  pm.account_id) "
                    + condition + innerSearchCondition + searchCondition;
            searchCount = template.queryForObject(countSearchQuery, Integer.class);
        }
        returnObj.setData(advancedMDEobLogData);
        returnObj.setDraw(pagingRequest.getDraw());
        returnObj.setRecordsTotal(count);
        returnObj.setRecordsFiltered(searchCount);
        returnObj.setExportData(StringUtilities.convertListToJson(advancedMDEobLogData));
        return returnObj;
    }

    public TablePage getAdvancedMDEobPaymentData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE sm.entity_id = " + entityId;

        if (pagingRequest.getInnerSearchValue() != null && StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " WHERE ("
                    + " CAST(tid AS CHAR) LIKE '%" + innerQuery + "%' OR "
                    + " filename LIKE '%" + innerQuery + "%' OR "
                    + " check_no LIKE '%" + innerQuery + "%' OR "
                    + " CAST(claimCount AS CHAR) LIKE '%" + innerQuery + "%' OR "
                    + " payment_date LIKE '%" + innerQuery + "%' OR "
                    + " CAST(applied_payment AS CHAR) LIKE '%" + innerQuery + "%' OR "
                    + " payor LIKE '%" + innerQuery + "%' OR "
                    + " ftp_user LIKE '%" + innerQuery + "%' OR "
                    + " status LIKE '%" + innerQuery + "%' OR "
                    + " CAST(job_id AS CHAR) LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(createdBy, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(createdDate, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(updatedBy, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(updatedDate, '') LIKE '%" + innerQuery + "%' OR "
                    + " received_date LIKE '%" + innerQuery + "%'"
                    + " ) ";

        }

        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }

        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                String columnName = order.getColumnName();
                String orderColumn = switch (columnName) {
                    case "payment_date" ->
                        " payment_date ";
                    case "created_date" ->
                        " createdDate ";
                    case "updated_date" ->
                        " updatedDate ";
                    case "applied_payment" ->
                        " applied_payment ";
                    case "recievedDate" ->
                        " received_date ";
                    default ->
                        " " + columnName;
                };
                orderBy = orderBy + "," + orderColumn + " " + order.getDir();
            }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY tid DESC ";
        }

        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn())
                && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("check_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND oe.check_date BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("dos".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND dos BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("job_id".equalsIgnoreCase(msColumns[columnIndex])) {
                    String inClause = Arrays.stream(msValues[columnIndex].split("~"))
                            .map(String::trim)
                            .collect(Collectors.joining(", "));
                    searchCondition = searchCondition
                            + " AND (" + msColumns[columnIndex] + " IN (" + inClause + ") ) ";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' ) ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<AdvancedMDEob> paymentData = new ArrayList<>();
        String baseQuery = "SELECT oe.tid, oe.filename, oe.check_no, count(oe.visit_id) as claimCount, oe.check_date AS payment_date,"
                + " IFNULL(sum(oe.insurance_payment), 0) as applied_payment,  "
                + " oe.payor, oe.ftp_user, oe.status, oe.job_id, oe.created_by, oe.created_date, oe.updated_by, "
                + " oe.updated_date,UM.first_name AS createdBy,  "
                + " IFNULL(DATE_FORMAT(CONVERT(oe.created_date, DATE), '%m/%d/%Y'), '') AS createdDate, "
                + " UM1.first_name AS updatedBy, IFNULL(DATE_FORMAT(CONVERT(oe.updated_date, DATE), '%m/%d/%Y'), '') AS updatedDate, "
                + " oe.received_date "
                + " FROM advancemd_eob oe"
                + " LEFT JOIN subscription_master sm  ON sm.ftpuser = oe.ftp_user "
                + " LEFT JOIN user_master UM ON UM.user_id = oe.created_by "
                + " LEFT JOIN user_master UM1 ON UM1.user_id = oe.updated_by "
                + condition + searchCondition
                + " GROUP BY check_no, oe.ftp_user " + orderBy + limit;

        String query = " SELECT * FROM ( "
                + "   SELECT * FROM (" + baseQuery + ") AS level1 "
                + innerSearchCondition
                + " ) AS level2 "
                + orderBy + limit;

        LOGGER.info("getAdvancedMd Payment query: " + query);
        try (Connection connection = template.getDataSource().getConnection();
                PreparedStatement ps = connection.prepareStatement(query);
                ResultSet rs = ps.executeQuery()) {
            while (rs != null && rs.next()) {
                AdvancedMDEob advancedMDEob = new AdvancedMDEob();
                advancedMDEob.setTid(rs.getInt("tid"));
                advancedMDEob.setFileName(rs.getString("filename"));
                advancedMDEob.setCheckNo(rs.getString("check_no"));
                advancedMDEob.setClaimCount(rs.getInt("claimCount"));
                advancedMDEob.setPaymentDate(rs.getString("payment_date"));
                advancedMDEob.setInsurancePayment(rs.getBigDecimal("applied_payment"));
                advancedMDEob.setPayor(rs.getString("payor"));
                advancedMDEob.setFtpUser(rs.getString("ftp_user"));
                advancedMDEob.setStatus(rs.getString("status"));
                advancedMDEob.setJobId(rs.getInt("job_id"));
                advancedMDEob.setCreatedBy(rs.getString("createdBy"));
                advancedMDEob.setCreatedDate(rs.getString("createdDate"));
                advancedMDEob.setUpdatedBy(rs.getString("updatedBy"));
                advancedMDEob.setUpdatedDate(rs.getString("updatedDate"));
                advancedMDEob.setReceivedDate(rs.getString("received_date"));
                paymentData.add(advancedMDEob);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
        int count = 0;
        String countQuery = " SELECT IFNULL(COUNT(check_no), 0) AS recordsTotal, "
                + " IFNULL(SUM(appliedPayment), 0) AS totalAppliedPayment "
                + " FROM ( "
                + " SELECT oe.check_no, IFNULL(sum(oe.insurance_payment), 0) AS appliedPayment "
                + " FROM advancemd_eob oe "
                + " LEFT JOIN subscription_master sm ON sm.ftpuser = oe.ftp_user "
                + " LEFT JOIN user_master um_c ON um_c.user_id = oe.created_by "
                + " LEFT JOIN user_master um_u ON um_u.user_id = oe.updated_by "
                + condition
                + " GROUP BY oe.check_no, oe.ftp_user "
                + " ) AS temp ";
        LOGGER.info("getAdvancedMdEobPaymentData countQuery: " + countQuery);
        try (Connection connection2 = template.getDataSource().getConnection(); 
                PreparedStatement ps2 = connection2.prepareStatement(countQuery); 
                ResultSet rs2 = ps2.executeQuery()) {
            while (rs2 != null && rs2.next()) {
                count = rs2.getInt("recordsTotal");
                returnObj.setFooterData(rs2.getString("totalAppliedPayment"));
            }
        } catch (Exception e) {
            LOGGER.error("Exception while getting count value:", e);
        }
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String baseSearchQuery = "SELECT oe.tid, oe.filename, oe.check_no, count(oe.visit_id) as claimCount, oe.check_date AS payment_date,"
                    + " IFNULL(sum(oe.insurance_payment), 0) as applied_payment,  "
                    + " oe.payor, oe.ftp_user, oe.status, oe.job_id, oe.created_by, oe.created_date, oe.updated_by, "
                    + " oe.updated_date,UM.first_name AS createdBy,  "
                    + " IFNULL(DATE_FORMAT(CONVERT(oe.created_date, DATE), '%m/%d/%Y'), '') AS createdDate, "
                    + " UM1.first_name AS updatedBy, IFNULL(DATE_FORMAT(CONVERT(oe.updated_date, DATE), '%m/%d/%Y'), '') AS updatedDate, "
                    + " received_date "
                    + " FROM advancemd_eob oe"
                    + " LEFT JOIN subscription_master sm  ON sm.ftpuser = oe.ftp_user "
                    + " LEFT JOIN user_master UM ON UM.user_id = oe.created_by "
                    + " LEFT JOIN user_master UM1 ON UM1.user_id = oe.updated_by "
                    + condition + searchCondition
                    + " GROUP BY check_no, oe.ftp_user ";
            String searchCountQuery
                    = " SELECT IFNULL(COUNT(check_no), 0) AS recordsTotal, "
                    + " IFNULL(SUM(applied_payment), 0) AS totalAppliedPayment "
                    + " FROM ( "
                    + " SELECT * FROM (" + baseSearchQuery + ") AS search_level1 "
                    + innerSearchCondition
                    + " ) AS search_level2 ";
            LOGGER.info("getAdvanceMDEobPaymentData searchCountQuery: " + searchCountQuery);
            try (Connection connection3 = template.getDataSource().getConnection(); 
                    PreparedStatement ps3 = connection3.prepareStatement(searchCountQuery); 
                    ResultSet rs3 = ps3.executeQuery()) {
                while (rs3 != null && rs3.next()) {
                    searchCount = rs3.getInt("recordsTotal");
                    returnObj.setFooterData(rs3.getString("totalAppliedPayment"));
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

    public TablePage getAdvancedMDEobAdvisoryData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE sm.entity_id = " + entityId;
        if (pagingRequest.getInnerSearchValue() != null && StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " WHERE ("
                    + " filename LIKE '%" + innerQuery + "%' OR "
                    + " check_no LIKE '%" + innerQuery + "%' OR "
                    + " claimno LIKE '%" + innerQuery + "%' OR "
                    + " CAST(total_charge AS CHAR) LIKE '%" + innerQuery + "%' OR "
                    + " CAST(applied_payment AS CHAR) LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(patient_name, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(received_date, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(cpt, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(payor, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(ftp_user, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(status, '') LIKE '%" + innerQuery + "%' OR "
                    + " IFNULL(claim_status, '') LIKE '%" + innerQuery + "%' OR "
                    + " job_id LIKE '%" + innerQuery + "%' OR " 
                    + " dos LIKE '%" + innerQuery + "%' OR "
                    + " unit LIKE '%" + innerQuery + "%' "
                    + " ) ";
        }

        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }

        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                String columnName = order.getColumnName();
                String orderColumn = switch (columnName) {
                    case "applied_date" ->
                        " STR_TO_DATE(applied_date, '%m/%d/%Y') ";
                    case "total_charge" ->
                        " total_charge ";
                    case "applied_payment" ->
                        " applied_payment ";
                    case "units" ->
                        " unit ";
                    default ->
                        " " + columnName;
                };
                orderBy = orderBy + "," + orderColumn + " " + order.getDir();
            }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY tid DESC ";
        }

        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn())
                && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("dos".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND oe.dos BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("oe.received_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND oe.received_date BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("patient_name".equalsIgnoreCase(msColumns[columnIndex])) {
                    String patientName = msValues[columnIndex].trim().replace(",", "%");
                    searchCondition += " AND patient_name LIKE '%" + patientName + "%'";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' ) ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<AdvancedMDEob> advisoryData = new ArrayList<>();
        String baseQuery = "SELECT oe.tid, oe.filename, CASE WHEN payor =  oe.primary_payor THEN 'PRI'  "
                + " WHEN payor =  oe.secondary_payor THEN 'SEC' ELSE 'TER' "
                + " END AS claim_status, oe.check_no, oe.visit_id AS claimno, "
                + " fn_get_chargeamount_from_837(oe.visit_id, oe.ftp_user) AS total_charge, "
                + " sum(oe.insurance_payment) AS applied_payment,  "
                + " patient_name, received_date AS received_date, cpt, modifier, "
                + " oe.payor, oe.ftp_user, oe.status, oe.unit, oe.dos, oe.job_id "
                + " FROM advancemd_eob oe "
                + " LEFT JOIN subscription_master sm ON sm.ftpuser = oe.ftp_user "
                + condition + searchCondition
                + " GROUP BY oe.check_no, oe.visit_id ";
        String query = " SELECT * FROM ( "
                + " SELECT * FROM (" + baseQuery + ") AS level1 "
                + innerSearchCondition
                + " ) AS level2 "
                + orderBy + limit;
        LOGGER.info("getAdvancedMdEobAdvisoryData query: " + query);
        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement ps = connection.prepareStatement(query); 
                ResultSet rs = ps.executeQuery()) {
            while (rs != null && rs.next()) {
                AdvancedMDEob advancedMDEob = new AdvancedMDEob();
                advancedMDEob.setTid(rs.getInt("tid"));
                advancedMDEob.setFileName(rs.getString("filename"));
                advancedMDEob.setClaimStatus(rs.getString("claim_status"));
                advancedMDEob.setCheckNo(rs.getString("check_no"));
                advancedMDEob.setClaimNo(rs.getString("claimno"));
                advancedMDEob.setTotalCharge(rs.getBigDecimal("total_charge"));
                advancedMDEob.setInsurancePayment(rs.getBigDecimal("applied_payment"));
                advancedMDEob.setPatientName(rs.getString("patient_name"));
                advancedMDEob.setReceivedDate(rs.getString("received_date"));
                advancedMDEob.setCpt(rs.getString("cpt"));
                advancedMDEob.setModifier(rs.getString("modifier"));
                advancedMDEob.setPayor(rs.getString("payor"));
                advancedMDEob.setFtpUser(rs.getString("ftp_user"));
                advancedMDEob.setStatus(rs.getString("status"));
                advancedMDEob.setUnits(rs.getString("unit"));
                advancedMDEob.setDos(rs.getString("dos"));
                advancedMDEob.setJobId(rs.getInt("job_id"));
                advisoryData.add(advancedMDEob);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
        int count = 0;
        String countQuery = " SELECT IFNULL(COUNT(recordCount), 0) AS recordsTotal, "
                + " IFNULL(SUM(appliedPayment), 0) AS totalAppliedPayment, "
                + " IFNULL(SUM(totalCharge), 0) AS totalCharge "
                + " FROM ( "
                + " SELECT oe.tid AS recordCount, "
                + " IFNULL(sum(oe.insurance_payment) , 0)   AS appliedPayment, "
                + " fn_get_chargeamount_from_837(oe.visit_id, oe.ftp_user)  AS totalCharge "
                + " FROM advancemd_eob oe "
                + " LEFT JOIN subscription_master sm ON sm.ftpuser = oe.ftp_user "
                + condition
                + " GROUP BY oe.check_no, oe.visit_id "
                + " ) AS temp ";
        LOGGER.info("getAdvancedMDEobAdvisoryData countQuery: " + countQuery);
        try (Connection connection2 = template.getDataSource().getConnection(); 
                PreparedStatement ps2 = connection2.prepareStatement(countQuery); 
                ResultSet rs2 = ps2.executeQuery()) {
            while (rs2 != null && rs2.next()) {
                count = rs2.getInt("recordsTotal");
                returnObj.setFooterData(rs2.getString("totalAppliedPayment") + "," + rs2.getString("totalCharge"));
            }
        } catch (Exception e) {
            LOGGER.error("Exception while getting count value:", e);
        }
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String baseSearchQuery = "SELECT oe.tid, oe.filename, CASE WHEN payor =  oe.primary_payor THEN 'PRI'  "
                    + " WHEN payor =  oe.secondary_payor THEN 'SEC' ELSE 'TER' "
                    + "END AS claim_status, oe.check_no, oe.visit_id AS claimno, "
                    + "fn_get_chargeamount_from_837(oe.visit_id, oe.ftp_user) AS total_charge, "
                    + "sum(oe.insurance_payment) AS applied_payment,  "
                    + "patient_name, received_date AS received_date, cpt, modifier, "
                    + "oe.payor, oe.ftp_user, oe.status, unit, dos, job_id "
                    + "FROM advancemd_eob oe "
                    + " LEFT JOIN subscription_master sm ON sm.ftpuser = oe.ftp_user "
                    + condition + searchCondition
                    + " GROUP BY oe.check_no, oe.visit_id";
            String searchCountQuery = " SELECT IFNULL(COUNT(tid), 0) AS recordsTotal, "
                    + " IFNULL(SUM(applied_payment), 0) AS totalAppliedPayment, "
                    + " IFNULL(SUM(total_charge), 0)    AS totalCharge "
                    + " FROM ( "
                    + " SELECT * FROM (" + baseSearchQuery + ") AS search_level1 "
                    + innerSearchCondition
                    + " ) AS search_level2 ";
            LOGGER.info("getAdvanceMdEob searchCountQuery: " + searchCountQuery);
            try (Connection connection3 = template.getDataSource().getConnection(); 
                    PreparedStatement ps3 = connection3.prepareStatement(searchCountQuery); 
                    ResultSet rs3 = ps3.executeQuery()) {
                while (rs3 != null && rs3.next()) {
                    searchCount = rs3.getInt("recordsTotal");
                    returnObj.setFooterData(rs3.getString("totalAppliedPayment") + "," + rs3.getString("totalCharge"));
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

    public TablePage getAdvanceMDEobPostingData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE sm.entity_id = " + entityId;
        if (pagingRequest.getInnerSearchValue() != null && StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " AND ("
                    + "oe.filename LIKE '%" + innerQuery + "%' OR "
                    + "oe.check_no LIKE '%" + innerQuery + "%' OR "
                    + "oe.visit_id LIKE '%" + innerQuery + "%' OR "
                    + "oe.payment LIKE '%" + innerQuery + "%' OR "
                    + "oe.cpt LIKE '%" + innerQuery + "%' OR "
                    + "oe.modifier LIKE '%" + innerQuery + "%' OR "
                    + "oe.adjustment LIKE '%" + innerQuery + "%' OR "
                    + "oe.dos LIKE '%" + innerQuery + "%' OR "
                    + "oe.status LIKE '%" + innerQuery + "%' OR "
                    + "oe.patient_name LIKE '%" + innerQuery + "%' OR "
                    + "oe.facility_name LIKE '%" + innerQuery + "%' OR "
                    + "oe.provider_profile LIKE '%" + innerQuery + "%' OR "
                    + "oe.received_date LIKE '%" + innerQuery + "%' OR "
                    + "oe.job_id LIKE '%" + innerQuery + "%' OR "
                    + "oe.unit LIKE '%" + innerQuery + "%'"
                    + ")";
        }

        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }

        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                String columnName = order.getColumnName();
                String orderColumn = switch (columnName) {
                    case "applied_date" ->
                        " STR_TO_DATE(oe.applied_date, '%m/%d/%Y') ";
                    case "total_charge" ->
                        " oe.total_charge ";
                    case "applied_payment" ->
                        " SUM(oe.applied_payment) ";
                    case "charge_amount" ->
                        " charge_amount ";
                    case "units" ->
                        " unit ";
                    default ->
                        " oe." + columnName;
                };
                orderBy = orderBy + "," + orderColumn + " " + order.getDir();
            }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY oe.tid DESC ";
        }

        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn()) && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("dos".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND dos BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("oe.received_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND oe.received_date BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("patient_name".equalsIgnoreCase(msColumns[columnIndex])) {
                    String patientName = msValues[columnIndex].trim().replace(",", "%");
                    searchCondition += " AND patient_name LIKE '%" + patientName + "%'";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' ) ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<AdvancedMDEob> postingData = new ArrayList<>();

        String query = "SELECT oe.filename, oe.check_no, oe.visit_id AS claimno, oe.cpt, oe.modifier, "
                + " fn_get_lineitem_chargeamount_from_837(oe.visit_id, oe.ftp_user, oe.cpt) AS charge_amount,  "
                + " oe.payment, oe.adjustment AS deductible_amount, oe.dos, oe.status, "
                + " oe.patient_name, oe.facility_name, oe.provider_profile, oe.received_date, oe.job_id, oe.unit "
                + " FROM advancemd_eob oe "
                + "LEFT JOIN subscription_master sm ON sm.ftpuser = oe.ftp_user "
                + condition + innerSearchCondition + searchCondition
                + " GROUP BY oe.tid " + orderBy + limit;

        LOGGER.info("getAdvancedMDEobPostingData: " + query);
        try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(query); 
                ResultSet rs = preparedStatement.executeQuery()) {
            while (rs != null && rs.next()) {
                AdvancedMDEob advancedMDEob = new AdvancedMDEob();
                advancedMDEob.setFileName(rs.getString("filename"));
                advancedMDEob.setCheckNo(rs.getString("check_no"));
                advancedMDEob.setClaimNo(rs.getString("claimno"));
                advancedMDEob.setModifier(rs.getString("modifier"));
                advancedMDEob.setCpt(rs.getString("cpt"));
                advancedMDEob.setChargeAmount(rs.getBigDecimal("charge_amount"));
                advancedMDEob.setPayment(rs.getBigDecimal("payment"));
                advancedMDEob.setAdjustment(rs.getBigDecimal("deductible_amount"));
                advancedMDEob.setDos(rs.getString("dos"));
                advancedMDEob.setFacilityName(rs.getString("facility_name"));
                advancedMDEob.setPatientName(rs.getString("patient_name"));
                advancedMDEob.setProviderProfile(rs.getString("provider_profile"));
                advancedMDEob.setReceivedDate(rs.getString("received_date"));
                advancedMDEob.setStatus(rs.getString("status"));
                advancedMDEob.setJobId(rs.getInt("job_id"));
                advancedMDEob.setUnits(rs.getString("unit"));
                postingData.add(advancedMDEob);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }

        int count = 0;
        String countQuery = "SELECT IFNULL(COUNT(recordCount), 0) AS recordsTotal, IFNULL(SUM(appliedPayment), 0) AS totalAppliedPayment, "
                + " IFNULL(SUM(totalCharge),0) AS totalCharge, IFNULL(SUM(deductibleCharge), 0) AS deductibleCharge "
                + " FROM (SELECT oe.tid AS recordCount, IFNULL(SUM(oe.payment), 0) AS appliedPayment, "
                + " IFNULL(SUM(fn_get_lineitem_chargeamount_from_837(oe.visit_id, oe.ftp_user, oe.cpt)), 0) AS totalCharge, "
                + " IFNULL(SUM(oe.adjustment), 0) AS deductibleCharge "
                + " FROM advancemd_eob oe "
                + " LEFT JOIN subscription_master sm ON sm.ftpuser = oe.ftp_user "
                + condition + " GROUP BY oe.tid) AS temp";
        LOGGER.info("getAdvancedMDEobPostingData: count query ---------- " + countQuery);
        try (Connection connection2 = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement2 = connection2.prepareStatement(countQuery); 
                ResultSet rs2 = preparedStatement2.executeQuery()) {
            while (rs2 != null && rs2.next()) {
                count = rs2.getInt("recordsTotal");
                returnObj.setFooterData(rs2.getString("totalAppliedPayment") + "," + rs2.getString("totalCharge")
                        + "," + rs2.getString("deductibleCharge"));
            }
        } catch (Exception e) {
            LOGGER.error("Exception while getting count value:", e);
        }

        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String searchCountQuery = "SELECT IFNULL(COUNT(recordCount), 0) AS recordsTotal, IFNULL(SUM(appliedPayment), 0) AS totalAppliedPayment, "
                    + " IFNULL(SUM(totalCharge),0) AS totalCharge, IFNULL(SUM(deductibleCharge), 0) AS deductibleCharge "
                    + " FROM (SELECT oe.tid AS recordCount, IFNULL(SUM(oe.payment), 0) AS appliedPayment, "
                    + " IFNULL(fn_get_lineitem_chargeamount_from_837(oe.visit_id, oe.ftp_user, oe.cpt), 0) AS totalCharge, "
                    + " IFNULL(SUM(oe.adjustment), 0) AS deductibleCharge "
                    + " FROM advancemd_eob oe "
                    + " LEFT JOIN subscription_master sm ON sm.ftpuser = oe.ftp_user "
                    + condition + searchCondition + innerSearchCondition + " GROUP BY oe.tid) AS temp";
            try (Connection connection3 = template.getDataSource().getConnection(); 
                    PreparedStatement preparedStatement3 = connection3.prepareStatement(searchCountQuery); 
                    ResultSet rs3 = preparedStatement3.executeQuery()) {
                while (rs3 != null && rs3.next()) {
                    searchCount = rs3.getInt("recordsTotal");
                    returnObj.setFooterData(rs3.getString("totalAppliedPayment") + "," + rs3.getString("totalCharge")
                            + "," + rs3.getString("deductibleCharge"));
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

    public void moveAdvancedMDDataFromStagingToLiveUsingJobId(final Long userId, int jobId) throws SQLException {
        try (Connection con = template.getDataSource().getConnection()) {
            con.setAutoCommit(false);
            try {
                CallableStatement callableStatement = con.prepareCall("{call create_advancedmd_eob_entry(?,?)}");
                callableStatement.setLong("_user_id", userId);
                callableStatement.setInt("_jobId", jobId);
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

    public void moveAdvancedMDDataToLivePaymentUsingId(final Long userId, List<Integer> tidList) throws SQLException {

        String eobIds = tidList.stream().map(String::valueOf).collect(Collectors.joining(","));
        try (Connection con = template.getDataSource().getConnection()) {
            con.setAutoCommit(false);
            try {
                CallableStatement callableStatement = con.prepareCall("{call create_advancedmd_eob_entry_v1(?,?)}");
                callableStatement.setLong("_user_id", userId);
                callableStatement.setString("_eobIds", eobIds);
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

    public void deleteAdvancedMDEobStatus(final int id) throws Exception {
        String deleteEobSql = "DELETE e1 FROM advancemd_eob e1 "
                + " JOIN (SELECT check_no  FROM advancemd_eob "
                + " WHERE tid = ?) e2 ON e1.check_no = e2.check_no;";
        template.update(deleteEobSql, id);
    }

    public void deleteAdvancedMDJobId(final int id) throws Exception {
        String deleteJobSql = "DELETE FROM advancemd_eob_jobs WHERE eob_job_id = ?";
        template.update(deleteJobSql, id);

        String deleteEobSql = "DELETE FROM advancemd_eob WHERE job_id = ?";
        template.update(deleteEobSql, id);
    }

    public void updateAdvanceMDPaymentStatus(final AdvancedMDEob advancedMDEob, final Long userId) {
        List<Integer> advancedMdIds = advancedMDEob.getAdvancedMdIds();
        String status = advancedMDEob.getStatus();
        try {
            if ("Deleted".equalsIgnoreCase(status)) {
                for (Integer id : advancedMdIds) {
                    deleteAdvancedMDEobStatus(id);
                }
                return;
            }
            String statusValue = "Staging".equals(status) ? null : status;
            String fileStatusValue = "File uploaded".equals(status) ? null : status;
            String placeholders = advancedMdIds.stream().map(id -> "?").collect(Collectors.joining(","));
            String query = "UPDATE advancemd_eob e "
                    + "JOIN ( "
                    + "SELECT check_no, ftp_user FROM advancemd_eob WHERE tid IN (" + placeholders + ") "
                    + ") d ON d.check_no = e.check_no AND d.ftp_user = e.ftp_user "
                    + "SET e.file_status = ?, e.status=?, updated_by=?, updated_date=NOW() "
                    + "WHERE e.status IN ('File uploaded', 'Exception')";  
            try (Connection connection = template.getDataSource().getConnection();
                    PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                int index = 1;
                for (Integer id : advancedMdIds) {
                    preparedStatement.setInt(index++, id);
                }
                preparedStatement.setString(index++, fileStatusValue);
                preparedStatement.setString(index++, statusValue);
                preparedStatement.setLong(index++, userId);               
                preparedStatement.executeUpdate();
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
    }

}
