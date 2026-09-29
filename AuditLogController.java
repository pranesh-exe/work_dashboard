package com.nellikkai.web.controllers;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.itextpdf.text.DocumentException;
import com.nellikkai.persistence.dao.RoleRepository;
import com.nellikkai.persistence.model.Role;
import com.nellikkai.web.beans.AuditLog;
import com.nellikkai.web.dao.DenialDao;
import com.nellikkai.web.datatablespagination.model.PaginationCriteria;
import com.nellikkai.web.datatablespagination.model.TablePage;
import com.nellikkai.web.service.AuditLogService;
import com.nellikkai.web.service.ExportReportService;
import com.nellikkai.web.util.ExportUtility;
import com.nellikkai.web.util.SessionUtils;
import com.nellikkai.web.util.StringUtilities;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.thymeleaf.TemplateEngine;

/**
 *
 * @author kabil
 */
@Controller
public class AuditLogController {

    @Autowired
    private AuditLogService auditLogService;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private DenialDao denialDao;
    @Autowired
    private ExportReportService exportReportService;
    @Autowired
    private TemplateEngine templateEngine;

    private static final Logger LOGGER = LoggerFactory.getLogger(AuditLogController.class);

    @GetMapping(value = "/audit-logs")
    public String viewAuditLogs(ModelMap model) {
        try {
            List<Role> rolesList = roleRepository.findAll();
            String rolesListJson = objectMapper.writeValueAsString(rolesList);
            model.addAttribute("rolesListJson", rolesListJson);
            List<AuditLog> logTypeList = auditLogService.getLogTypes();
            model.addAttribute("logTypeList", logTypeList);
        } catch (Exception ex) {
            LOGGER.error("Error while processing audit logs view", ex);
        }
        return "viewauditlogs";
    }

    @PostMapping(value = "/get-auditlog-data", produces = "application/json")
    public @ResponseBody
    TablePage getAuditList(@RequestBody PaginationCriteria pagingRequest, HttpSession session) {
        LOGGER.info("AuditLogController getAuditList is Entered!");
        TablePage auditLogData = null;
        try {
            auditLogData = auditLogService.getAuditLogs(pagingRequest, SessionUtils.getSessionEntityId(session), SessionUtils.getSessionUserType(session));
            List auditExportData = new ArrayList<>();
            auditExportData.addAll(auditLogData.getData());
            session.setAttribute("auditLogData", auditExportData);
            PaginationCriteria paginationCriteria = new PaginationCriteria(pagingRequest.getFilterBy(), pagingRequest.getStartDate(), pagingRequest.getEndDate(),
                    pagingRequest.getDenialType(), pagingRequest.getType(), pagingRequest.getSubType(), pagingRequest.getServiceNPI(),
                    pagingRequest.getProviderNPI(), pagingRequest.getMultiSearchColumnName(), pagingRequest.getMultiSearchColumnValue(), "", pagingRequest.getSearchValueFromSearch()
            );
            session.setAttribute("auditLogFilters", paginationCriteria);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return auditLogData;
    }

    @GetMapping(value = "/export-auditlog-data-report")
    public void auditLogReport(HttpSession session, HttpServletResponse response, int startIndex, int endIndex,
            @RequestParam(required = false) List<Integer> selectedIndexes, @RequestParam List<Integer> visibleColumns, @RequestParam String exportType) throws SQLException, DocumentException, IOException, java.io.IOException {
        LOGGER.info("exportType  if :" + exportType);
        List<AuditLog> auditLogDataList = (List<AuditLog>) session.getAttribute("auditLogData");
        List<AuditLog> exportDataList = StringUtilities.getExportDataList(auditLogDataList, startIndex, endIndex, selectedIndexes);
        String userDisplayName = (String) session.getAttribute("userDisplayName");
        PaginationCriteria paginationCriteria = (PaginationCriteria) session.getAttribute("auditLogFilters");
        String updatedFileName = denialDao.generateFileName("AUDIT_LOG", paginationCriteria);
        if ("1".equals(exportType)) {
            LinkedHashMap<String, String> fieldMapping = ExportUtility.AUDIT_LOG_REPORT.getFieldMapping();
            exportReportService.exportToExcel_V2("AUDIT LOG REPORT", exportDataList, fieldMapping, visibleColumns, response, updatedFileName + ".xlsx", paginationCriteria, userDisplayName);
        } else {
            String fileName = "exportAuditLogPdfReport";
            exportReportService.exportToPdf_v1("AUDIT LOG REPORT", exportDataList, visibleColumns, response, templateEngine, fileName, paginationCriteria, userDisplayName, updatedFileName);
        }
    }

    @GetMapping("/active-users")
    public String viewActiveUsers(ModelMap model) {
        try {
            LOGGER.info("AuditLogController viewActiveUsers is Entered!");
            List<AuditLog> activeUserslist = auditLogService.getActiveUsers();
            model.addAttribute("activeUserslist", activeUserslist);
        } catch (Exception ex) {
            LOGGER.error("Exception while getting Active Users:", ex);
        }
        return "viewliveusers";
    }

    @GetMapping("/privilege-logs")
    public String viewPrivilegeLogs(ModelMap model) {
        try {
            LOGGER.info("AuditLogController viewPrivilegeLogs is Entered!");
            List<AuditLog> privilegeLogslist = auditLogService.getPrivilegeLogs();
            model.addAttribute("privilegeLogslist", privilegeLogslist);
        } catch (Exception ex) {
            LOGGER.error("Exception while getting Privilege Logs:", ex);
        }
        return "viewprivilegelogs";
    }

}
