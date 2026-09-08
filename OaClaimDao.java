package com.billingparadise.web.dao;

import com.billingparadise.web.beans.Claim;
import com.billingparadise.web.beans.ClaimDetail;
import com.billingparadise.web.beans.ClaimLineItem;
import com.billingparadise.web.datatablespagination.model.OrderingCriteria;
import com.billingparadise.web.datatablespagination.model.PaginationCriteria;
import com.billingparadise.web.datatablespagination.model.TablePage;
import com.billingparadise.web.util.StringUtilities;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
 * @author Raja
 */
@Service
public class OaClaimDao {

    @Autowired
    private JdbcTemplate template;
    private static final Logger LOGGER = LoggerFactory.getLogger(OaClaimDao.class);

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public TablePage getClaimTrackerHeaderData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE OAH.tid IS NOT NULL ";
        if (pagingRequest.getInnerSearchValue() != null && StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " AND ("
                    + "OAH.tid LIKE '%" + innerQuery + "%' OR OAH.header_id LIKE '%" + innerQuery + "%' OR OAH.claim_index_id LIKE '%" + innerQuery + "%' OR "
                    + "OAH.status LIKE '%" + innerQuery + "%' OR OAH.fileid LIKE '%" + innerQuery + "%' OR OAH.claimid LIKE '%" + innerQuery + "%' OR "
                    + "OCR.`11c_insuranceplanname`  LIKE '%" + innerQuery + "%' OR OAH.recdate LIKE '%" + innerQuery + "%' OR CONCAT(OAH.last, ', ', OAH.first) LIKE '%" + innerQuery + "%' OR "
                    + "OAH.patacctnum LIKE '%" + innerQuery + "%' OR DATE_FORMAT(STR_TO_DATE(OAH.fromdos, '%m/%d/%Y'), '%m/%d/%Y') LIKE '%" + innerQuery + "%' OR DATE_FORMAT(STR_TO_DATE(OAH.todos, '%m/%d/%Y'), '%m/%d/%Y') LIKE '%" + innerQuery + "%' OR "
                    + "OAH.taxid LIKE '%" + innerQuery + "%' OR OAH.statelicenseid LIKE '%" + innerQuery + "%' OR OAH.isuredid LIKE '%" + innerQuery + "%' OR "
                    + "OAH.totalcharge LIKE '%" + innerQuery + "%' OR OAH.errordescription LIKE '%" + innerQuery + "%' OR "
                    + "IFNULL(DATE_FORMAT(OAH.createddate, '%c/%d/%Y'), '') LIKE '%" + innerQuery + "%' OR OAH.recordstatus LIKE '%" + innerQuery + "%' OR "
                    + "OAH.Filename LIKE '%" + innerQuery + "%' OR "
                    + "IFNULL(DATE_FORMAT(STR_TO_DATE(OAH.InsChg_interChangeDate, '%y%m%d'), '%m/%d/%Y'), '') LIKE '%" + innerQuery + "%' OR "
                    + "OAH.Acct_name LIKE '%" + innerQuery + "%' OR OAH.`837_Header_id` LIKE '%" + innerQuery + "%' OR "
                    + "OAH.file_status LIKE '%" + innerQuery + "%'"
                    + ") ";
        }
        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }
        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                orderBy = orderBy + "," + order.getColumnName() + " " + order.getDir();
            }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY OAH.tid DESC ";
        }
        String groupBy = " GROUP BY OAH.tid ";
        String splitDate = getSplitDate();

        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn()) && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("todos".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND STR_TO_DATE(OAH.todos, '%m/%d/%Y') BETWEEN STR_TO_DATE('" + dates[0] + "', '%m/%d/%Y') " +
                                        "AND STR_TO_DATE('" + dates[1] + "', '%m/%d/%Y') ";
                } else if ("recdate".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND DATE_FORMAT(STR_TO_DATE(OAH.recdate, '%m/%d/%Y'), '%m/%d/%Y') BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("received_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND " + splitDate + " BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' )  ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<Claim> oaClaimData = new ArrayList<>();
        String query = "SELECT OAH.tid, OAH.header_id, OAH.claim_index_id, OAH.status, OAH.fileid, OAH.claimid, IFNULL(OCR.`11c_insuranceplanname`,'') AS payor, DATE_FORMAT(STR_TO_DATE(OAH.recdate, '%m/%d/%Y'), '%m/%d/%Y') AS recdate, "
                + "CONCAT(OAH.last, ', ', OAH.first) AS name , OAH.patacctnum, DATE_FORMAT(STR_TO_DATE(OAH.fromdos, '%m/%d/%Y'), '%m/%d/%Y') AS fromdos, DATE_FORMAT(STR_TO_DATE(OAH.todos, '%m/%d/%Y'), '%m/%d/%Y') AS todos, OAH.taxid, OAH.statelicenseid, OAH.isuredid, OAH.totalcharge, OAH.errordescription, "
                + "DATE_FORMAT(OAH.createddate, '%c/%d/%Y') AS createddate, OAH.recordstatus, OAH.Filename,"
                + " DATE_FORMAT(STR_TO_DATE(OAH.InsChg_interChangeDate, '%y%m%d'), '%m/%d/%Y') AS  InsChg_interChangeDate, "
                + "OAH.Acct_name, OAH.`837_Header_id`, OAH.file_status, " + splitDate + " AS receivedDate FROM oa_claim_tracker_header OAH "
                + "LEFT JOIN oa_claim_tracker_rework OCR ON OAH.filename = OCR.Filename AND OAH.header_id = OCR.header_id AND OAH.claimid = OCR.claimno "
                + condition + innerSearchCondition + searchCondition + groupBy + orderBy + limit;
        LOGGER.info("getClaimTrackerHeaderData: " + query);
        try ( Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(query); 
                ResultSet rs = preparedStatement.executeQuery()) {
            while (rs != null && rs.next()) {
                Claim claim = new Claim();
                claim.setTid(rs.getInt("tid"));
                claim.setHeaderId(rs.getString("header_id"));
                claim.setClaimIndex(rs.getInt("claim_index_id"));
                claim.setStatus(rs.getString("status"));
                claim.setFileId(rs.getLong("fileid"));
                claim.setClaimno(rs.getString("claimid"));
                claim.setPayorName(rs.getString("payor"));
                claim.setRecdate(rs.getString("recdate"));
                claim.setPatient(rs.getString("name"));
                claim.setPataccno(rs.getString("patacctnum"));
                claim.setFromdos(rs.getString("fromdos"));
                claim.setTodos(rs.getString("todos"));
                claim.setTaxid(rs.getString("taxid"));
                claim.setStalinid(rs.getString("statelicenseid"));
                claim.setInsid(rs.getString("isuredid"));
                claim.setTotalCharge(rs.getString("totalcharge"));
                claim.setErrdes(rs.getString("errordescription"));
                claim.setCreatedDate(rs.getString("createddate"));
                claim.setRecordStatus(rs.getString("recordstatus"));
                claim.setFilename(rs.getString("Filename"));
                claim.setInterChangeDate(rs.getString("InsChg_interChangeDate"));
                claim.setAccount_no(rs.getString("Acct_name"));
                claim.setHeader837Id(rs.getLong("837_Header_id"));
                claim.setFileStatus(rs.getString("file_status"));
                oaClaimData.add(claim);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
        String countQuery = "SELECT COUNT(OAH.tid) FROM oa_claim_tracker_header OAH " + condition ;
        int count = template.queryForObject(countQuery, Integer.class);
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String countSearchQuery = " SELECT COUNT(*) " 
                    + "FROM (SELECT COUNT(OAH.tid) FROM oa_claim_tracker_header OAH "
                    + "LEFT JOIN oa_claim_tracker_rework OCR ON OAH.filename = OCR.Filename AND OAH.header_id = OCR.header_id AND OAH.claimid = OCR.claimno " + condition
                    + searchCondition + innerSearchCondition + groupBy
                    + ") AS sub ";
            searchCount = template.queryForObject(countSearchQuery, Integer.class);
        }
        returnObj.setData(oaClaimData);
        returnObj.setDraw(pagingRequest.getDraw());
        returnObj.setRecordsTotal(count);
        returnObj.setRecordsFiltered(searchCount);
        returnObj.setExportData(StringUtilities.convertListToJson(oaClaimData));
        return returnObj;
    }

    public TablePage getClaimTrackerLineitemData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE lid IS NOT NULL ";
        if (pagingRequest.getInnerSearchValue() != null && StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " AND ("
                    + "lid LIKE '%" + innerQuery + "%' OR "
                    + "remdering_id LIKE '%" + innerQuery + "%' OR "
                    + "dos_from LIKE '%" + innerQuery + "%' OR "
                    + "dos_to LIKE '%" + innerQuery + "%' OR "
                    + "place_of_service LIKE '%" + innerQuery + "%' OR "
                    + "emg LIKE '%" + innerQuery + "%' OR "
                    + "cpt LIKE '%" + innerQuery + "%' OR "
                    + "modifier_a LIKE '%" + innerQuery + "%' OR "
                    + "modifier_b LIKE '%" + innerQuery + "%' OR "
                    + "modifier_c LIKE '%" + innerQuery + "%' OR "
                    + "totalcharge LIKE '%" + innerQuery + "%' OR "
                    + "modifier_d LIKE '%" + innerQuery + "%' OR "
                    + "diagnosis_pointer LIKE '%" + innerQuery + "%' OR "
                    + "charges LIKE '%" + innerQuery + "%' OR "
                    + "days_units LIKE '%" + innerQuery + "%' OR "
                    + "id_qual LIKE '%" + innerQuery + "%' OR "
                    + "claimno LIKE '%" + innerQuery + "%' OR "
                    + "rendering_npi LIKE '%" + innerQuery + "%' OR "
                    + "header_id LIKE '%" + innerQuery + "%' OR "
                    + "claim_index_id LIKE '%" + innerQuery + "%' OR "
                    + "l_index LIKE '%" + innerQuery + "%' OR "
                    + "Filename LIKE '%" + innerQuery + "%' OR "
                    + "Acct_name LIKE '%" + innerQuery + "%' OR "
                    + "IFNULL(DATE_FORMAT(STR_TO_DATE(InsChg_interChangeDate, '%y%m%d'), '%m/%d/%Y'), '') LIKE '%" + innerQuery + "%'"
                    + ")";
        }
        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }
        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                orderBy = orderBy + "," + order.getColumnName() + " " + order.getDir();
            }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY lid DESC ";
        }
        String splitDate = getSplitDate();
        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn()) && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("dos_to".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND STR_TO_DATE(dos_to, '%m/%d/%Y') BETWEEN STR_TO_DATE('" + dates[0] + "', '%m/%d/%Y') " +
                                        "AND STR_TO_DATE('" + dates[1] + "', '%m/%d/%Y') ";
                } else if ("recdate".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND STR_TO_DATE(InsChg_interChangeDate, '%y%m%d') " +
                                       "BETWEEN STR_TO_DATE('" + dates[0] + "', '%m/%d/%Y') " +
                                       "AND STR_TO_DATE('" + dates[1] + "', '%m/%d/%Y') ";
                } else if ("received_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND " + splitDate + " BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("claimid".equalsIgnoreCase(msColumns[columnIndex])) {
                    searchCondition += " AND (claimno = '" + msValues[columnIndex] + "') ";
                } else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' )  ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<ClaimLineItem> oaClaimLineItemData = new ArrayList<>();
        String query = " SELECT lid, remdering_id, dos_from, dos_to, place_of_service, emg, cpt, modifier_a, modifier_b, modifier_c, totalcharge, "
                + " modifier_d, diagnosis_pointer, charges, days_units, id_qual, claimno, rendering_npi, header_id, claim_index_id, "
                + "l_index, Filename,IFNULL(DATE_FORMAT(STR_TO_DATE(InsChg_interChangeDate, '%y%m%d'), '%m/%d/%Y'), '') AS InsChg_interChangeDate,"
                + " Acct_name, " + splitDate + " AS receivedDate FROM oa_claim_tracker_lineitem OAH "
                + condition + innerSearchCondition + searchCondition + " GROUP BY lid " + orderBy + limit;
        LOGGER.info("getClaimTrackerLineitemData: " + query);
        try ( Connection connection = template.getDataSource().getConnection();  
                PreparedStatement preparedStatement = connection.prepareStatement(query); 
                ResultSet rs = preparedStatement.executeQuery()) {
            while (rs != null && rs.next()) {
                ClaimLineItem claim = new ClaimLineItem();
                claim.setId(rs.getInt("lid"));
                claim.setRemderingId(rs.getString("remdering_id"));
                claim.setDosFrom(rs.getString("dos_from"));
                claim.setDosTo(rs.getString("dos_to"));
                claim.setPlaceOfService(rs.getString("place_of_service"));
                claim.setEmg(rs.getString("emg"));
                claim.setCpt(rs.getString("cpt"));
                claim.setModifierA(rs.getString("modifier_a"));
                claim.setModifierB(rs.getString("modifier_b"));
                claim.setModifierC(rs.getString("modifier_c"));
                claim.setTotalCharge(rs.getString("totalcharge"));
                claim.setModifierD(rs.getString("modifier_d"));
                claim.setDiagnosisPointer(rs.getString("diagnosis_pointer"));
                claim.setCharges(rs.getString("charges"));
                claim.setDaysUnits(rs.getString("days_units"));
                claim.setIdQual(rs.getString("id_qual"));
                claim.setClaimno(rs.getString("claimno"));
                claim.setRenderingNpi(rs.getString("rendering_npi"));
                claim.setHeaderId(rs.getString("header_id"));
                claim.setClaimIndex(rs.getInt("claim_index_id"));
                claim.setlIndex(rs.getInt("l_index"));
                claim.setFileName(rs.getString("Filename"));
                claim.setInterChangeDate(rs.getString("InsChg_interChangeDate"));
                claim.setAccount(rs.getString("Acct_name"));
                oaClaimLineItemData.add(claim);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
        String countQuery = "SELECT COUNT(lid) FROM oa_claim_tracker_lineitem OAH " + condition;
        int count = template.queryForObject(countQuery, Integer.class);
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String countSearchQuery = " SELECT COUNT(lid) FROM oa_claim_tracker_lineitem OAH "
                    + condition + searchCondition + innerSearchCondition;
            searchCount = template.queryForObject(countSearchQuery, Integer.class);
        }
        returnObj.setData(oaClaimLineItemData);
        returnObj.setDraw(pagingRequest.getDraw());
        returnObj.setRecordsTotal(count);
        returnObj.setRecordsFiltered(searchCount);
        returnObj.setExportData(StringUtilities.convertListToJson(oaClaimLineItemData));
        return returnObj;
    }

    public TablePage getClaimTrackerReworkData(final Long entityId, PaginationCriteria pagingRequest) {
        String searchCondition = "", condition = "", innerSearchCondition = "", orderBy = "", limit = "";
        condition = " WHERE OCR.rid IS NOT NULL ";
        if (pagingRequest.getInnerSearchValue() != null && StringUtils.isNotEmpty(pagingRequest.getInnerSearchValue())) {
            String innerQuery = pagingRequest.getInnerSearchValue();
            innerSearchCondition = " AND ("
                    + "OCR.`1a_insuredidnumber` LIKE '%" + innerQuery + "%' OR OCR.`2_patientfirstname` LIKE '%" + innerQuery + "%' OR "
                    + "OCR.`2_patientlastname` LIKE '%" + innerQuery + "%' OR OCR.`11c_insuranceplanname` LIKE '%" + innerQuery + "%' OR "
                    + "OCR.`26_patientaccountno` LIKE '%" + innerQuery + "%' OR OCR.`28_totalcharge` LIKE '%" + innerQuery + "%' OR "
                    + "OCR.`33_renderingprovider` LIKE '%" + innerQuery + "%' OR OCR.`33a_billingnpi` LIKE '%" + innerQuery + "%' OR "
                    + "OCR.claimno LIKE '%" + innerQuery + "%' OR OCR.CL_claimIndex LIKE '%" + innerQuery + "%' OR "
                    + "OCR.HeaderID LIKE '%" + innerQuery + "%' OR OAH.fromdos LIKE '%" + innerQuery + "%' OR "
                    + "OAH.todos LIKE '%" + innerQuery + "%' OR OCR.rendering_provider_npi LIKE '%" + innerQuery + "%' OR "
                    + "OCR.header_id LIKE '%" + innerQuery + "%' OR OCR.claim_index_id LIKE '%" + innerQuery + "%' OR "
                    + "OCR.Filename LIKE '%" + innerQuery + "%' OR OCR.Acct_name LIKE '%" + innerQuery + "%' OR "
                    + "OCR.P_Type LIKE '%" + innerQuery + "%' OR "
                    + "IFNULL(DATE_FORMAT(STR_TO_DATE(OCR.InsChg_interChangeDate, '%y%m%d'), '%m/%d/%Y'), '') LIKE '%" + innerQuery + "%'"
                    + ") ";
        }
        if (pagingRequest.getLength() > 0) {
            limit = " LIMIT " + pagingRequest.getStart() + ", " + pagingRequest.getLength();
        }
        if (CollectionUtils.isNotEmpty(pagingRequest.getOrder())) {
            for (OrderingCriteria order : pagingRequest.getOrder()) {
                orderBy = orderBy + "," + order.getColumnName() + " " + order.getDir();
            }
            orderBy = " ORDER BY " + orderBy.substring(1);
        } else {
            orderBy = " ORDER BY OCR.rid DESC ";
        }
        
        String splitDate = " COALESCE(DATE_FORMAT( COALESCE("
                + "STR_TO_DATE(SUBSTRING_INDEX(OCR.Filename, '_', -1), '%m%d%Y'), "
                + "STR_TO_DATE(SUBSTRING_INDEX(OCR.Filename, '_', -1), '%m-%d-%Y'), "
                + "STR_TO_DATE(SUBSTRING_INDEX(OCR.Filename, '_', -1), '%Y%m%d'), "
                + "STR_TO_DATE(SUBSTRING_INDEX(OCR.Filename, '_', -3), '%Y%m%d'), "
                + "STR_TO_DATE(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(OCR.Filename, '_', -1), '.', 1), '-', ''), '%Y%m%d') "
                + "), '%m/%d/%Y'), '') ";

        if (StringUtils.isNotEmpty(pagingRequest.getMultiSearchColumn()) && StringUtils.isNotEmpty(pagingRequest.getMultiSearchValue())) {
            String[] msColumns = pagingRequest.getMultiSearchColumn().split(",");
            String[] msValues = pagingRequest.getMultiSearchValue().split(",");
            for (int columnIndex = 0; columnIndex < msColumns.length; columnIndex++) {
                if ("OAH.dos_to".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND STR_TO_DATE(OAH.todos, '%m/%d/%Y') BETWEEN STR_TO_DATE('" + dates[0] + "', '%m/%d/%Y') " +
                                        "AND STR_TO_DATE('" + dates[1] + "', '%m/%d/%Y') ";
                } else if ("OCR.recdate".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND STR_TO_DATE(OCR.InsChg_interChangeDate, '%y%m%d') " +
                                       "BETWEEN STR_TO_DATE('" + dates[0] + "', '%m/%d/%Y') " +
                                       "AND STR_TO_DATE('" + dates[1] + "', '%m/%d/%Y') ";
                } else if ("OCR.received_date".equalsIgnoreCase(msColumns[columnIndex])) {
                    msValues[columnIndex] = msValues[columnIndex].replaceAll("\\s+", "").replace("~", ",");
                    String[] dates = msValues[columnIndex].split(",");
                    searchCondition += " AND " + splitDate + " BETWEEN '" + dates[0] + "' AND '" + dates[1] + "' ";
                } else if ("OCR.claimid".equalsIgnoreCase(msColumns[columnIndex])) {
                    searchCondition += " AND (claimno = '" + msValues[columnIndex] + "') ";
                }  else {
                    searchCondition += " AND (" + msColumns[columnIndex] + " = '" + msValues[columnIndex] + "' )  ";
                }
            }
            searchCondition = searchCondition.replace("~", ",");
        }

        TablePage returnObj = new TablePage();
        List<ClaimDetail> claimReworkData = new ArrayList<>();
        String query = "SELECT OCR.rid, OCR.`1a_insuredidnumber`, IFNULL(OCR.`11c_insuranceplanname`, '') AS `9d_insuranceplanname`, CONCAT(OCR.2_patientlastname, ', ', OCR.2_patientfirstname) AS patientName, "
                + "OCR.`28_totalcharge`, OCR.`33_renderingprovider`, OCR.`33a_billingnpi`, OCR.claimno, OCR.CL_claimIndex, OCR.HeaderID, OAH.fromdos AS dos_from, "
                + "OAH.todos AS dos_to, OCR.rendering_provider_npi, OCR.header_id, OCR.claim_index_id, OCR.Filename, OCR.Acct_name, OCR.P_Type, OCR.`26_patientaccountno`, "
                + "IFNULL(DATE_FORMAT(STR_TO_DATE(OCR.InsChg_interChangeDate, '%y%m%d'), '%m/%d/%Y'), '') AS InsChg_interChangeDate, "
                + splitDate + " AS receivedDate FROM oa_claim_tracker_rework OCR "
                + " LEFT JOIN oa_claim_tracker_header OAH  ON OAH.filename = OCR.Filename AND OAH.header_id = OCR.header_id AND OAH.claimid = OCR.claimno "
                + condition + innerSearchCondition + searchCondition + " GROUP BY OCR.rid " + orderBy + limit;
        LOGGER.info("getClaimTrackerReworkData: " + query);
        try ( Connection connection = template.getDataSource().getConnection();  
                PreparedStatement preparedStatement = connection.prepareStatement(query);  
                ResultSet rs = preparedStatement.executeQuery()) {
            while (rs != null && rs.next()) {
                ClaimDetail claim = new ClaimDetail();
                claim.setId(rs.getInt("rid"));
                claim.setC1a_insuredidnumber(rs.getString("1a_insuredidnumber"));
                claim.setC9d_insuranceplanname(rs.getString("9d_insuranceplanname"));
                claim.setC2_patientfirstname(rs.getString("patientName"));
                claim.setC28_totalcharge(rs.getString("28_totalcharge"));
                claim.setC33_renderingprovider(rs.getString("33_renderingprovider"));
                claim.setC33a_billingnpi(rs.getString("33a_billingnpi"));
                claim.setClaimNo(rs.getString("claimno"));
                claim.setClaimIndex(rs.getString("CL_claimIndex"));
                claim.setHeaderId(rs.getString("HeaderID"));
                claim.setDosFrom(rs.getString("dos_from"));
                claim.setDosTo(rs.getString("dos_to"));
                claim.setRendProviderNpi(rs.getString("rendering_provider_npi"));
                claim.setClaimHeaderId(rs.getString("header_id"));
                claim.setClaimIndexId(rs.getString("claim_index_id"));
                claim.setFileName(rs.getString("Filename"));
                claim.setAccount(rs.getString("Acct_name"));
                claim.setpType(rs.getString("P_Type"));
                claim.setC26_patientaccountno(rs.getString("26_patientaccountno"));
                claim.setC31_date(rs.getString("InsChg_interChangeDate"));
                claimReworkData.add(claim);
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
        String countQuery = "SELECT COUNT(rid) FROM oa_claim_tracker_rework OCR " 
                + " LEFT JOIN oa_claim_tracker_header OAH ON OAH.filename = OCR.Filename AND OAH.header_id = OCR.header_id AND OAH.claimid = OCR.claimno "
                + condition;
        int count = template.queryForObject(countQuery, Integer.class);
        int searchCount = count;
        if (StringUtils.isNotBlank(innerSearchCondition) || StringUtils.isNotBlank(searchCondition)) {
            String countSearchQuery = " SELECT COUNT(OCR.rid) FROM oa_claim_tracker_rework OCR "
                    + " LEFT JOIN oa_claim_tracker_header OAH  ON OAH.filename = OCR.Filename AND OAH.header_id = OCR.header_id AND OAH.claimid = OCR.claimno "
                    + condition + searchCondition + innerSearchCondition;
            searchCount = template.queryForObject(countSearchQuery, Integer.class);
        }
        returnObj.setData(claimReworkData);
        returnObj.setDraw(pagingRequest.getDraw());
        returnObj.setRecordsTotal(count);
        returnObj.setRecordsFiltered(searchCount);
        returnObj.setExportData(StringUtilities.convertListToJson(claimReworkData));
        return returnObj;
    }

    private String getSplitDate() {
        return " COALESCE(DATE_FORMAT( COALESCE("
                + "STR_TO_DATE(SUBSTRING_INDEX(OAH.Filename, '_', -1), '%m%d%Y'), "
                + "STR_TO_DATE(SUBSTRING_INDEX(OAH.Filename, '_', -1), '%m-%d-%Y'), "
                + "STR_TO_DATE(SUBSTRING_INDEX(OAH.Filename, '_', -1), '%Y%m%d'), "
                + "STR_TO_DATE(SUBSTRING_INDEX(OAH.Filename, '_', -3), '%Y%m%d'), "
                + "STR_TO_DATE(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(OAH.Filename, '_', -1), '.', 1), '-', ''), '%Y%m%d') "
                + "), '%m/%d/%Y'), '') ";
    }
        
    public void triggerOaClaimHeader(final Long userId, List<Integer> claimIdList) throws SQLException {
        String claimIds = claimIdList.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
        try (Connection con = template.getDataSource().getConnection()) {
            con.setAutoCommit(false);
            try {
                CallableStatement callableStatement = con.prepareCall("{call create_paper_eob_entry_v3(?,?)}");
                callableStatement.setLong("_user_id", userId);
                callableStatement.setString("_claimIds", claimIds);
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
    
     public void deleteOaClaim(final String filename, final String acctName) {
        try {
            template.update("DELETE FROM oa_claim_tracker_header WHERE Filename = ? AND Acct_name = ?", filename, acctName);
            template.update("DELETE FROM oa_claim_tracker_lineitem WHERE Filename = ? AND Acct_name = ?", filename, acctName);
            template.update("DELETE FROM oa_claim_tracker_rework WHERE Filename = ? AND Acct_name = ?", filename, acctName);            
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
    }
    
    public void updateOaClaimStatus(final Claim claim, final Long userId) {
        List<String> fileNames = claim.getFileNames();
        List<String> acctNames = claim.getAcctNames();
        String status = claim.getFileStatus();      
        LOGGER.info("updateOaClaimStatus status: " +status);
        try {
            if ("Deleted".equalsIgnoreCase(status)) {
                for (int deleteIndex = 0; deleteIndex < fileNames.size(); deleteIndex++) {
                    deleteOaClaim(fileNames.get(deleteIndex), acctNames.get(deleteIndex));
                }
                return;
            }
            String statusValue = "Staging".equalsIgnoreCase(status) ? "Active" : status;
            StringBuilder pairPlaceholders = new StringBuilder();
            for (int fileIndex = 0; fileIndex < fileNames.size(); fileIndex++) {
                if (fileIndex > 0) {
                    pairPlaceholders.append(",");
                }
                pairPlaceholders.append("(?, ?)");
            }
            String query = "UPDATE oa_claim_tracker_header "
                    + "SET file_status = ? "
                    + "WHERE (Filename, Acct_name) IN (" + pairPlaceholders + ")";
            try (Connection connection = template.getDataSource().getConnection(); 
                PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                int index = 1;
                preparedStatement.setString(index++, statusValue);
                for (int paramIndex = 0; paramIndex < fileNames.size(); paramIndex++) {
                    preparedStatement.setString(index++, fileNames.get(paramIndex));
                    preparedStatement.setString(index++, acctNames.get(paramIndex));
                }
                preparedStatement.executeUpdate();
            }
        } catch (Exception e) {
            LOGGER.error("Exception:", e);
        }
    }
    
    public void moveOaClaimDataToExceptionStatus(final Long userId, List<Integer> claimIdList) throws SQLException {
        String claimIds = claimIdList.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
        LOGGER.info("moveOaClaimDataToExceptionStatus claimIds: " + claimIds);
        try (Connection con = template.getDataSource().getConnection()) {
            con.setAutoCommit(false);
            try {
                CallableStatement callableStatement = con.prepareCall("{call check_exception_in_office_ally_claims(?,?)}");
                callableStatement.setLong("_userId", userId);
                callableStatement.setString("_claimIds", claimIds);
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
}
