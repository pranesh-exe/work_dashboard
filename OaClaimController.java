package com.billingparadise.web.controllers;

import com.billingparadise.web.beans.Claim;
import com.billingparadise.web.beans.ClaimDetail;
import com.billingparadise.web.beans.ClaimLineItem;
import com.billingparadise.web.dao.ColumnCustomizationDao;
import com.billingparadise.web.dao.DenialDao;
import com.billingparadise.web.dao.ManualEobDao;
import com.billingparadise.web.dao.OaClaimDao;
import com.billingparadise.web.datatablespagination.model.PaginationCriteria;
import com.billingparadise.web.datatablespagination.model.TablePage;
import com.billingparadise.web.service.ExportReportService;
import com.billingparadise.web.util.ExportUtility;
import com.billingparadise.web.util.SessionUtils;
import com.billingparadise.web.util.StringUtilities;
import com.itextpdf.io.exceptions.IOException;
import com.itextpdf.text.DocumentException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.thymeleaf.TemplateEngine;

/**
 *
 * @author Raja
 */
@Controller
public class OaClaimController {    
   
    @Autowired
    private ColumnCustomizationDao columnCustomizationDao;
    @Autowired
    private ExportReportService exportReportService;
    @Autowired
    private ManualEobDao manualEOBDao;
    @Autowired
    private DenialDao denialDao;
    @Autowired
    private TemplateEngine templateEngine;
    @Autowired
    private OaClaimDao oaClaimDao;

    private static final Logger LOGGER = LoggerFactory.getLogger(OaClaimController.class);

    @GetMapping(value = "/view-oa-claim")
    public String viewOaClaims(ModelMap model, HttpSession session) {
        LOGGER.info("OaClaimController viewOaClaims Is Entered.!");
        model.addAttribute("payeelist", manualEOBDao.getPayee(SessionUtils.getSessionEntityId(session)));
        List<Integer> columnsList = columnCustomizationDao.getColumns(ColumnCustomizationDao.ColumnCustomizationType.TYPE_41);
        model.addAttribute("columnsList", columnsList);
        List<Integer> lineitemColumnsList = columnCustomizationDao.getColumns(ColumnCustomizationDao.ColumnCustomizationType.TYPE_42);
        model.addAttribute("lineitemColumnsList", lineitemColumnsList);
        List<Integer> reworkColumnsList = columnCustomizationDao.getColumns(ColumnCustomizationDao.ColumnCustomizationType.TYPE_43);
        model.addAttribute("reworkColumnsList", reworkColumnsList);
        return "viewOaClaim";
    }

    @PostMapping(value = "/oa-claim-tracker-header-data", produces = "application/json")
    public @ResponseBody
    TablePage oaClaimTrackerHeaderData(@RequestBody PaginationCriteria pagingRequest, HttpSession session) {
        TablePage oaClaimTrackerData = null;
        try {
            LOGGER.info("OaClaimController oa-claim-tracker-header-data is Entered!");
            oaClaimTrackerData = oaClaimDao.getClaimTrackerHeaderData(SessionUtils.getSessionEntityId(session), pagingRequest);
            List headerExportData = new ArrayList<>();
            headerExportData.addAll(oaClaimTrackerData.getData());
            session.setAttribute("claimHeaderData", headerExportData);
            PaginationCriteria paginationCriteria = new PaginationCriteria(pagingRequest.getFilterBy(), pagingRequest.getStartDate(), pagingRequest.getEndDate(),
                    pagingRequest.getDenialType(), pagingRequest.getType(), pagingRequest.getSubType(), pagingRequest.getServiceNPI(),
                    pagingRequest.getProviderNPI(), pagingRequest.getMultiSearchColumnName(), pagingRequest.getMultiSearchColumnValue(), "", pagingRequest.getSearchValueFromSearch()
            );
            session.setAttribute("claimHeaderFilters", paginationCriteria);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return oaClaimTrackerData;
    }

    @GetMapping(value = "/export-header-data-report")
    public void paymentScrapingReport(@ModelAttribute("Claim") Claim claim, Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response, int startIndex, int endIndex,
            @RequestParam(required = false) List<Integer> selectedIndexes, @RequestParam List<Integer> visibleColumns, @RequestParam String exportType) throws SQLException, DocumentException, IOException, java.io.IOException {
        LOGGER.info("exportType  if :" + exportType);
        List<Claim> claimHeaderDataList = (List<Claim>) session.getAttribute("claimHeaderData");
        List<Claim> exportDataList = StringUtilities.getExportDataList(claimHeaderDataList, startIndex, endIndex, selectedIndexes);
        String userDisplayName = (String) session.getAttribute("userDisplayName");
        PaginationCriteria paginationCriteria = (PaginationCriteria) session.getAttribute("claimHeaderFilters");
        String updatedFileName = denialDao.generateFileName("OA_CLAIM_TRACKER_HEADER", paginationCriteria);
        if ("1".equals(exportType)) {
            LinkedHashMap<String, String> fieldMapping = ExportUtility.OA_CLAIM_TRACKER_HEADER_REPORT.getFieldMapping();
            exportReportService.exportToExcel_V2("OA_CLAIM_TRACKER_HEADER", exportDataList, fieldMapping, visibleColumns, response, updatedFileName + ".xlsx", paginationCriteria, userDisplayName);
        } else {
            String fileName = "exportOaClaimTrackingHeaderPdfReport";
            exportReportService.exportToPdf_v1("OA CLAIM TRACKER HEADER", exportDataList, visibleColumns, response, templateEngine, fileName, paginationCriteria, userDisplayName, updatedFileName);
        }
    }

    @PostMapping(value = "/oa-claim-lineitem-data", produces = "application/json")
    public @ResponseBody
    TablePage oaClaimTrackerLineitemData(@RequestBody PaginationCriteria pagingRequest, HttpSession session) {
        TablePage oaClaimTrackerLineitemData = null;
        try {
            LOGGER.info("OaClaimController oa-claim-lineitem-data is Entered!");
            oaClaimTrackerLineitemData = oaClaimDao.getClaimTrackerLineitemData(SessionUtils.getSessionEntityId(session), pagingRequest);
            List lineitemExportData = new ArrayList<>();
            lineitemExportData.addAll(oaClaimTrackerLineitemData.getData());
            session.setAttribute("eobAdvisoryData", lineitemExportData);
            PaginationCriteria paginationCriteria = new PaginationCriteria(pagingRequest.getFilterBy(), pagingRequest.getStartDate(), pagingRequest.getEndDate(),
                    pagingRequest.getDenialType(), pagingRequest.getType(), pagingRequest.getSubType(), pagingRequest.getServiceNPI(),
                    pagingRequest.getProviderNPI(), pagingRequest.getMultiSearchColumnName(), pagingRequest.getMultiSearchColumnValue(), "", pagingRequest.getSearchValueFromSearch()
            );
            session.setAttribute("oaLineitemFilters", paginationCriteria);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return oaClaimTrackerLineitemData;
    }

    @GetMapping(value = "/export-lineitem-data-report")
    public void advisoryScrapingReport(@ModelAttribute("ClaimLineItem") ClaimLineItem claim, Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response, int startIndex, int endIndex,
            @RequestParam(required = false) List<Integer> selectedIndexes, @RequestParam List<Integer> visibleColumns, @RequestParam String exportType) throws SQLException, DocumentException, IOException, java.io.IOException {
        LOGGER.info("exportType  if :" + exportType);
        List<ClaimLineItem> lineitemDataList = (List<ClaimLineItem>) session.getAttribute("eobAdvisoryData");
        List<ClaimLineItem> exportDataList = StringUtilities.getExportDataList(lineitemDataList, startIndex, endIndex, selectedIndexes);
        String userDisplayName = (String) session.getAttribute("userDisplayName");
        PaginationCriteria paginationCriteria = (PaginationCriteria) session.getAttribute("oaLineitemFilters");
        String updatedFileName = denialDao.generateFileName("OA_CLAIM_TRACKER_LINEITEM", paginationCriteria);
        if ("1".equals(exportType)) {
            LinkedHashMap<String, String> fieldMapping = ExportUtility.OA_CLAIM_TRACKER_LINEITEM_REPORT.getFieldMapping();
            exportReportService.exportToExcel_V2("OA_CLAIM_TRACKER_LINEITEM", exportDataList, fieldMapping, visibleColumns, response, updatedFileName + ".xlsx", paginationCriteria, userDisplayName);
        } else {
            String fileName = "exportOaClaimLineitemPdfReport";
            exportReportService.exportToPdf_v1("EOB ADVISORY REPORT SCRAPING", exportDataList, visibleColumns, response, templateEngine, fileName, paginationCriteria, userDisplayName, updatedFileName);
        }
    }

    @PostMapping(value = "/claim-rework-data", produces = "application/json")
    public @ResponseBody
    TablePage oaClaimTrackerReworkData(@RequestBody PaginationCriteria pagingRequest, HttpSession session) {
        TablePage oaClaimTrackerReworkData = null;
        try {
            LOGGER.info("OaClaimController oa-claim-rework-data is Entered!");
            oaClaimTrackerReworkData = oaClaimDao.getClaimTrackerReworkData(SessionUtils.getSessionEntityId(session), pagingRequest);
            List reworkExportData = new ArrayList<>();
            reworkExportData.addAll(oaClaimTrackerReworkData.getData());
            session.setAttribute("oaReworkData", reworkExportData);
            PaginationCriteria paginationCriteria = new PaginationCriteria(pagingRequest.getFilterBy(), pagingRequest.getStartDate(), pagingRequest.getEndDate(),
                    pagingRequest.getDenialType(), pagingRequest.getType(), pagingRequest.getSubType(), pagingRequest.getServiceNPI(),
                    pagingRequest.getProviderNPI(), pagingRequest.getMultiSearchColumnName(), pagingRequest.getMultiSearchColumnValue(), "", pagingRequest.getSearchValueFromSearch()
            );
            session.setAttribute("oaReworkFilters", paginationCriteria);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return oaClaimTrackerReworkData;
    }

    @GetMapping(value = "/export-rework-data-report")
    public void oaReworkReport(@ModelAttribute("ClaimDetail") ClaimDetail claim, Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response, int startIndex, int endIndex,
            @RequestParam(required = false) List<Integer> selectedIndexes, @RequestParam List<Integer> visibleColumns, @RequestParam String exportType) throws SQLException, DocumentException, IOException, java.io.IOException {
        LOGGER.info("exportType  if :" + exportType);
        List<ClaimDetail> reworkDataList = (List<ClaimDetail>) session.getAttribute("oaReworkData");
        List<ClaimDetail> exportDataList = StringUtilities.getExportDataList(reworkDataList, startIndex, endIndex, selectedIndexes);
        String userDisplayName = (String) session.getAttribute("userDisplayName");
        PaginationCriteria paginationCriteria = (PaginationCriteria) session.getAttribute("oaReworkFilters");
        String updatedFileName = denialDao.generateFileName("OA_CLAIM_TRACKER_REWORK", paginationCriteria);
        if ("1".equals(exportType)) {
            LinkedHashMap<String, String> fieldMapping = ExportUtility.OA_CLAIM_TRACKER_REWORK_REPORT.getFieldMapping();
            exportReportService.exportToExcel_V2("OA_CLAIM_TRACKER_REWORK", exportDataList, fieldMapping, visibleColumns, response, updatedFileName + ".xlsx", paginationCriteria, userDisplayName);
        } else {
            String fileName = "exportOaClaimReworkPdfReport";
            exportReportService.exportToPdf_v1("OA_CLAIM_TRACKER_REWORK", exportDataList, visibleColumns, response, templateEngine, fileName, paginationCriteria, userDisplayName, updatedFileName);
        }
    }
    
    @PostMapping("/trigger-oa-claim-header")
    @ResponseBody
    public String triggerOaClaimHeader(@RequestBody(required = false) List<Integer> claimIdList,
            HttpSession session) throws SQLException {
        try {
            LOGGER.info("OaClaimController trigger-oa-claim-header entered!");
            Long userId = SessionUtils.getSessionUserId(session);
            oaClaimDao.triggerOaClaimHeader(userId, claimIdList);
            return "Success";
        } catch (Exception ex) {
            LOGGER.error("Exception in trigger-oa-claim-header:", ex);
            return "Failed";
        }
    }  
    
    @PostMapping("/update-oa-claim-status")
    @ResponseBody
    public String updateOaClaimStatus(@RequestBody Claim claim, HttpSession session) {
        try {
            LOGGER.info("OaClaimController update-oa-claim-status entered!");
            oaClaimDao.updateOaClaimStatus(claim, SessionUtils.getSessionUserId(session));
            return "Success";
        } catch (Exception ex) {
            LOGGER.error("Exception in update-oa-claim-status:", ex);
            return "Failed";
        }
    }
    
    @GetMapping(value = "/delete-oa-claim")
    @ResponseBody
    public String deleteOaClaim(@RequestParam String filename, @RequestParam String acctName) {
        try {
            LOGGER.info("OaClaimController delete-oa-claim entered!", filename);
            oaClaimDao.deleteOaClaim(filename, acctName);
            return "Success";
        } catch (Exception ex) {
            LOGGER.error("Exception in deleteOaClaim:", ex);
            return "Failed";
        }
    }
    
    @PostMapping("/move-oa-claim-stage-to-exception-status")
    @ResponseBody
    public String moveOaClaimDataToExceptionStatus(@RequestBody(required = false) List<Integer> claimIdList,
            HttpSession session) throws SQLException {
        try {
            LOGGER.info("OaClaimController move-oa-claim-stage-to-exception-status entered!");
            Long userId = SessionUtils.getSessionUserId(session);
            oaClaimDao.moveOaClaimDataToExceptionStatus(userId, claimIdList);
            return "Success";
        } catch (Exception ex) {
            LOGGER.error("Exception in move-oa-claim-stage-to-exception-status:", ex);
            return "Failed";
        }
    }
    
}
