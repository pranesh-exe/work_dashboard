package com.billingparadise.web.controllers;

import com.billingparadise.web.beans.ExcelEobDto;
import com.billingparadise.web.beans.Job;
import com.billingparadise.web.dao.ColumnCustomizationDao;
import com.billingparadise.web.dao.DenialDao;
import com.billingparadise.web.dao.EVDao;
import com.billingparadise.web.dao.ExcelEobDao;
import com.billingparadise.web.dao.ManualEobDao;
import com.billingparadise.web.datatablespagination.model.PaginationCriteria;
import com.billingparadise.web.datatablespagination.model.TablePage;
import com.billingparadise.web.service.ExcelEobAsyncService;
import com.billingparadise.web.service.ExportReportService;
import com.billingparadise.web.util.ExportUtility;
import com.billingparadise.web.util.SessionUtils;
import com.billingparadise.web.util.StringUtilities;
import java.io.IOException;
import com.itextpdf.text.DocumentException;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.List;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import javax.servlet.http.HttpSession;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.thymeleaf.TemplateEngine;

/**
 *
 * @author BALAJI N
 */
@Controller
public class ExcelEobController {

    @Autowired
    private EVDao evDao;
    @Autowired
    private ExcelEobDao excelEobDao;
    @Autowired
    private ColumnCustomizationDao columnCustomizationDao;
    @Autowired
    private Environment environment;
    @Autowired
    private DenialDao denialDao;
    @Autowired
    private ExportReportService exportReportService;
    @Autowired
    private TemplateEngine templateEngine;
    @Autowired
    private ManualEobDao manualEOBDao;
    @Autowired
    private ExcelEobAsyncService excelEobAsyncService;

    private static final Logger LOGGER = LoggerFactory.getLogger(ExcelEobController.class);
    private static final String FILE_SEPARATOR = File.separator;

    @GetMapping(value = "/excel-eob")
    public String excelEob(ModelMap model, HttpSession session) {
        LOGGER.info("ExcelEob Controller excel-eob Is Entered.!");
        List<Job> jobTypeList = evDao.getJobType();
        model.addAttribute("jobtypelist", jobTypeList);
        List<Job> jobStatusList = excelEobDao.getJobStatus();
        model.addAttribute("jobStatusList", jobStatusList);
        List<Job> jobIdList = excelEobDao.getJobId();
        model.addAttribute("jobIdList", jobIdList);
        model.addAttribute("practiceList", excelEobDao.getPracticeListForExcelEob(SessionUtils.getSessionEntityId(session), SessionUtils.getSessionPracticeId(session), SessionUtils.getSessionUserType(session),
                SessionUtils.getSessionUserId(session)));
        model.addAttribute("payeelist", manualEOBDao.getPayee(SessionUtils.getSessionEntityId(session)));
        List<Integer> columnsList = columnCustomizationDao.getColumns(ColumnCustomizationDao.ColumnCustomizationType.TYPE_29);
        model.addAttribute("columnsList", columnsList);
        List<Integer> advisoryColumnsList = columnCustomizationDao.getColumns(ColumnCustomizationDao.ColumnCustomizationType.TYPE_30);
        model.addAttribute("advisoryColumnsList", advisoryColumnsList);
        List<Integer> postingColumnsList = columnCustomizationDao.getColumns(ColumnCustomizationDao.ColumnCustomizationType.TYPE_31);
        model.addAttribute("postingColumnsList", postingColumnsList);
        return "excelEob";
    }

    @PostMapping(value = "/excel-eob-log", produces = "application/json")
    public @ResponseBody
    TablePage excelEobLog(@RequestBody PaginationCriteria pagingRequest, HttpSession session) {
        TablePage eobLogData = null;
        try {
            LOGGER.info("ExcelEob Controller excel-eob-log is Entered!");
            eobLogData = excelEobDao.getEobLogData(SessionUtils.getSessionEntityId(session),
                    SessionUtils.getSessionUserType(session), pagingRequest);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return eobLogData;
    }

    @PostMapping(value = "/payment-data", produces = "application/json")
    public @ResponseBody
    TablePage paymentData(@RequestBody PaginationCriteria pagingRequest, HttpSession session) {
        TablePage eobPaymentData = null;
        try {
            LOGGER.info("ExcelEob Controller payment-data is Entered!");
            eobPaymentData = excelEobDao.getEobPaymentData(SessionUtils.getSessionEntityId(session), pagingRequest);
            List paymentExportData = new ArrayList<>();
            paymentExportData.addAll(eobPaymentData.getData());
            session.setAttribute("eobPaymentData", paymentExportData);
            PaginationCriteria paginationCriteria = new PaginationCriteria(pagingRequest.getFilterBy(), pagingRequest.getStartDate(), pagingRequest.getEndDate(),
                    pagingRequest.getDenialType(), pagingRequest.getType(), pagingRequest.getSubType(), pagingRequest.getServiceNPI(),
                    pagingRequest.getProviderNPI(), pagingRequest.getMultiSearchColumnName(), pagingRequest.getMultiSearchColumnValue(), "", pagingRequest.getSearchValueFromSearch()
            );
            session.setAttribute("eobPaymentFilters", paginationCriteria);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return eobPaymentData;
    }

    @GetMapping(value = "/export-payment-data-report")
    public void paymentReport(@ModelAttribute("ExcelEobDto") ExcelEobDto claim, Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response, int startIndex, int endIndex,
            @RequestParam(required = false) List<Integer> selectedIndexes, @RequestParam List<Integer> visibleColumns, @RequestParam String exportType) throws SQLException, DocumentException, IOException {
        LOGGER.info("exportType  if :" + exportType);
        List<ExcelEobDto> paymentDataList = (List<ExcelEobDto>) session.getAttribute("eobPaymentData");
        List<ExcelEobDto> exportDataList = StringUtilities.getExportDataList(paymentDataList, startIndex, endIndex, selectedIndexes);
        String userDisplayName = (String) session.getAttribute("userDisplayName");
        PaginationCriteria paginationCriteria = (PaginationCriteria) session.getAttribute("eobPaymentFilters");
        String updatedFileName = denialDao.generateFileName("EOB_PAYMENT", paginationCriteria);
        if ("1".equals(exportType)) {
            LinkedHashMap<String, String> fieldMapping = ExportUtility.EOB_PAYMENT_REPORT.getFieldMapping();
            exportReportService.exportToExcel_V2("EOB PAYMENT REPORT", exportDataList, fieldMapping, visibleColumns, response, updatedFileName + ".xlsx", paginationCriteria, userDisplayName);
        } else {
            String fileName = "exportPaymentPdfReport";
            exportReportService.exportToPdf_v1("EOB PAYMENT REPORT", exportDataList, visibleColumns, response, templateEngine, fileName, paginationCriteria, userDisplayName, updatedFileName);
        }
    }

    @PostMapping(value = "/advisory-data", produces = "application/json")
    public @ResponseBody
    TablePage advisoryData(@RequestBody PaginationCriteria pagingRequest, HttpSession session) {
        TablePage eobadvisoryData = null;
        try {
            LOGGER.info("ExcelEob Controller advisory-data is Entered!");
            eobadvisoryData = excelEobDao.getEobAdvisoryData(SessionUtils.getSessionEntityId(session), pagingRequest);
            List advisoryExportData = new ArrayList<>();
            advisoryExportData.addAll(eobadvisoryData.getData());
            session.setAttribute("eobAdvisoryData", advisoryExportData);
            PaginationCriteria paginationCriteria = new PaginationCriteria(pagingRequest.getFilterBy(), pagingRequest.getStartDate(), pagingRequest.getEndDate(),
                    pagingRequest.getDenialType(), pagingRequest.getType(), pagingRequest.getSubType(), pagingRequest.getServiceNPI(),
                    pagingRequest.getProviderNPI(), pagingRequest.getMultiSearchColumnName(), pagingRequest.getMultiSearchColumnValue(), "", pagingRequest.getSearchValueFromSearch()
            );
            session.setAttribute("eobAdvisoryFilters", paginationCriteria);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return eobadvisoryData;
    }

    @GetMapping(value = "/export-advisory-data-report")
    public void advisoryReport(@ModelAttribute("ExcelEobDto") ExcelEobDto claim, Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response, int startIndex, int endIndex,
            @RequestParam(required = false) List<Integer> selectedIndexes, @RequestParam List<Integer> visibleColumns, @RequestParam String exportType) throws SQLException, DocumentException, IOException {
        LOGGER.info("exportType  if :" + exportType);
        List<ExcelEobDto> advisoryDataList = (List<ExcelEobDto>) session.getAttribute("eobAdvisoryData");
        List<ExcelEobDto> exportDataList = StringUtilities.getExportDataList(advisoryDataList, startIndex, endIndex, selectedIndexes);
        String userDisplayName = (String) session.getAttribute("userDisplayName");
        PaginationCriteria paginationCriteria = (PaginationCriteria) session.getAttribute("eobAdvisoryFilters");
        String updatedFileName = denialDao.generateFileName("EOB_ADVISORY", paginationCriteria);
        if ("1".equals(exportType)) {
            LinkedHashMap<String, String> fieldMapping = ExportUtility.EOB_ADVISORY_REPORT.getFieldMapping();
            exportReportService.exportToExcel_V2("EOB ADVISORY REPORT", exportDataList, fieldMapping, visibleColumns, response, updatedFileName + ".xlsx", paginationCriteria, userDisplayName);
        } else {
            String fileName = "exportAdvisoryPdfReport";
            exportReportService.exportToPdf_v1("EOB ADVISORY REPORT", exportDataList, visibleColumns, response, templateEngine, fileName, paginationCriteria, userDisplayName, updatedFileName);
        }
    }

    @PostMapping(value = "/posting-data", produces = "application/json")
    public @ResponseBody
    TablePage postingData(@RequestBody PaginationCriteria pagingRequest, HttpSession session) {
        TablePage eobPostingtData = null;
        try {
            LOGGER.info("ExcelEob Controller posting-log is Entered!");
            eobPostingtData = excelEobDao.getEobPostingData(SessionUtils.getSessionEntityId(session), pagingRequest);
            List postingExportData = new ArrayList<>();
            postingExportData.addAll(eobPostingtData.getData());
            session.setAttribute("eobPostingData", postingExportData);
            PaginationCriteria paginationCriteria = new PaginationCriteria(pagingRequest.getFilterBy(), pagingRequest.getStartDate(), pagingRequest.getEndDate(),
                    pagingRequest.getDenialType(), pagingRequest.getType(), pagingRequest.getSubType(), pagingRequest.getServiceNPI(),
                    pagingRequest.getProviderNPI(), pagingRequest.getMultiSearchColumnName(), pagingRequest.getMultiSearchColumnValue(), "", pagingRequest.getSearchValueFromSearch()
            );
            session.setAttribute("eobPostingFilters", paginationCriteria);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return eobPostingtData;
    }

    @GetMapping(value = "/export-posting-data-report")
    public void postingReport(@ModelAttribute("ExcelEobDto") ExcelEobDto claim, Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response, int startIndex, int endIndex,
            @RequestParam(required = false) List<Integer> selectedIndexes, @RequestParam List<Integer> visibleColumns, @RequestParam String exportType) throws SQLException, DocumentException, IOException {
        LOGGER.info("exportType  if :" + exportType);
        List<ExcelEobDto> postingDataList = (List<ExcelEobDto>) session.getAttribute("eobPostingData");
        List<ExcelEobDto> exportDataList = StringUtilities.getExportDataList(postingDataList, startIndex, endIndex, selectedIndexes);
        String userDisplayName = (String) session.getAttribute("userDisplayName");
        PaginationCriteria paginationCriteria = (PaginationCriteria) session.getAttribute("eobPostingFilters");
        String updatedFileName = denialDao.generateFileName("EOB_POSTING_", paginationCriteria);
        if ("1".equals(exportType)) {
            LinkedHashMap<String, String> fieldMapping = ExportUtility.EOB_POSTING_REPORT.getFieldMapping();
            exportReportService.exportToExcel_V2("EOB POSTING REPORT", exportDataList, fieldMapping, visibleColumns, response, updatedFileName + ".xlsx", paginationCriteria, userDisplayName);
        } else {
            String fileName = "exportPostingPdfReport";
            exportReportService.exportToPdf_v1("EOB POSTING REPORT", exportDataList, visibleColumns, response, templateEngine, fileName, paginationCriteria, userDisplayName, updatedFileName);
        }
    }

    @PostMapping("/importExcelEOB")
    public String importExcelEOB(RedirectAttributes redirectAttributes, @RequestParam("practiceId") String practiceId, @RequestParam("jobTypeId") int jobTypeId, @RequestParam("postDateRange") String dateRange, @RequestParam("file") MultipartFile file, HttpSession session) throws SQLException {
        LOGGER.info("ExcelEob Controller importExcelEOB is Entered!");
        int eobJobId = 0;
        try {
            redirectAttributes.addFlashAttribute("activeTab", "error");
            String path = environment.getProperty("web_location");
            //String path = "D:";
            String fileName = file.getOriginalFilename();
            fileName = fileName.replaceAll("\\s+", "").replaceAll("[^a-zA-Z0-9.]", "_");
            Long createdBy = SessionUtils.getSessionUserId(session);
            eobJobId = excelEobDao.insertEobJob(jobTypeId, practiceId, fileName, createdBy);
            if (eobJobId <= 0) {
                return "redirect:/excel-eob";
            }
            File resultFile = new File(path + File.separator + "ExcelEOB", fileName);
            while (resultFile.exists()) {
                resultFile = new File(path + File.separator + "ExcelEOB",
                        StringUtilities.getAlphaNumbericRandom(5) + "_" + fileName);
            }
            fileName = resultFile.getName();
            try (BufferedOutputStream bout = new BufferedOutputStream(new FileOutputStream(resultFile))) {
                bout.write(file.getBytes());
            }
            excelEobDao.updateEobJobStatus(eobJobId, 0, "File uploaded");
            excelEobAsyncService.processExcelFile(resultFile.getAbsolutePath(), practiceId, fileName, createdBy, eobJobId, dateRange);
        } catch (Exception e) {
            LOGGER.error("Upload failure", e);
            if (eobJobId > 0) {
                excelEobDao.updateEobJobStatus(eobJobId, 0, "Upload failure");
            }
        }
        return "redirect:/excel-eob";
    }

//    @PostMapping("/importExcelEOB")
//    public String importExcelEOB(@RequestParam("practiceId") String practiceId,
//            @RequestParam("jobTypeId") int jobTypeId, @RequestParam("postDateRange") String dateRange,
//            @RequestParam("file") CommonsMultipartFile file,
//            HttpSession session) throws SQLException {
//        LOGGER.info("ExcelEob Controller importExcelEOB is Entered!");
//        String fromDate = null;
//        String toDate = null;
//        boolean stagingSuccess = true;
//        int eobJobId = 0, totalXlRows = 0;
//        if (dateRange != null && !dateRange.trim().isEmpty()) {
//            String[] dates = dateRange.split(" / ", 2);
//            if (dates.length >= 2) {
//                fromDate = dates[0].trim();
//                toDate = dates[1].trim();
//            }
//        }
//
//        try {
//            String path = environment.getProperty("web_location");
//            //String path = "D:";
//            String fileName = file.getOriginalFilename();
//            fileName = fileName.replaceAll("\\s+", "").replaceAll("[^a-zA-Z0-9.]", "_");
//            Long createdBy = SessionUtils.getSessionUserId(session);
//
//            eobJobId = excelEobDao.insertEobJob(jobTypeId, practiceId, fileName, createdBy);
//            if (eobJobId <= 0) {
//                return "redirect:/excel-eob";
//            }
//
//            if (StringUtilities.isNotEmpty(fileName)) {
//                File resultFile = new File(path + FILE_SEPARATOR + "ExcelEOB" + File.separator, fileName);
//
//                while (resultFile.exists()) {
//                    resultFile = new File(path + FILE_SEPARATOR + "ExcelEOB" + File.separator, StringUtilities.getAlphaNumbericRandom(5) + "_" + fileName);
//                }
//                fileName = resultFile.getName();
//                byte[] barr = file.getBytes();
//                if (FileUtilities.isSupportedContentType(file.getContentType())) {
//                    try (BufferedOutputStream bout = new BufferedOutputStream(
//                            new FileOutputStream(path + File.separator + "ExcelEOB" + File.separator + fileName))) {
//                        bout.write(barr);
//                    }
//                }
//            }
//
//            excelEobDao.updateEobJobStatus(eobJobId, totalXlRows, "File uploaded");
//
//            try (InputStream inputStream = file.getInputStream(); Workbook workbook = WorkbookFactory.create(inputStream)) {
//                Sheet sheet = workbook.getSheetAt(0);
//                int totalRows = sheet.getLastRowNum();
//                totalXlRows = totalRows;
//
//                processCheckSection(sheet, "AQ", "AY",
//                        new String[]{"B", "H", "D", "AF", "AT", "AZ", "BA", "BB", "AY", "AU"},
//                        new String[]{"B", "H", "T", "AF", "AT", "AZ", "BA", "BB", "AY", "AU"},
//                        practiceId, fileName, createdBy, eobJobId, totalRows, 1, fromDate, toDate);
//
//                processCheckSection(sheet, "BK", "BS",
//                        new String[]{"B", "H", "D", "AF", "BN", "BT", "BU", "BV", "BS", "BO"},
//                        new String[]{"B", "H", "T", "AF", "BN", "BT", "BU", "BV", "BS", "BO"},
//                        practiceId, fileName, createdBy, eobJobId, totalRows, 2, fromDate, toDate);
//
//                processCheckSection(sheet, "CC", "CK",
//                        new String[]{"B", "H", "D", "AF", "CF", "CL", "CM", "CN", "CK", "CG"},
//                        new String[]{"B", "H", "T", "AF", "CF", "CL", "CM", "CN", "CK", "CG"},
//                        practiceId, fileName, createdBy, eobJobId, totalRows, 99, fromDate, toDate);
//
//            } catch (Exception e) {
//                stagingSuccess = false;
//                excelEobDao.updateEobJobStatus(eobJobId, totalXlRows, "Staging fail");
//                LOGGER.error("Staging error", e);
//            }
//
//            if (stagingSuccess) {
//                excelEobDao.updateEobJobStatus(eobJobId, totalXlRows, "Staging success");
//            }
//
//        } catch (Exception e) {
//            if (eobJobId > 0) {
//                excelEobDao.updateEobJobStatus(eobJobId, totalXlRows, "Upload failure");
//            }
//            LOGGER.error("Upload failure", e);
//        }
//        return "redirect:/excel-eob";
//    }
//
//    private void processCheckSection(Sheet sheet, String checkColLetter, String amtColLetter,
//            String[] advCols, String[] postCols, String practiceId, String fileName, Long createdBy,
//            int eobJobId, int totalRows, int status, String fromDate, String toDate) throws SQLException, Exception {
//
//        int checkColIdx = StringUtilities.colIndex(checkColLetter);
//        int amtColIdx = StringUtilities.colIndex(amtColLetter);
//        int ecwPmtId = 0;
//        for (int rowIndex = 1; rowIndex <= totalRows; rowIndex++) {
//            Row row = sheet.getRow(rowIndex);
//            if (row == null) {
//                continue;
//            }
//
//            String checkNo = StringUtilities.getCellValue(row.getCell(checkColIdx));
//            if (checkNo.isEmpty()) {
//                continue;
//            }
//
//            if (excelEobDao.isCheckNumberExistsInERA(checkNo, practiceId)) {
//                continue;
//            }
//
//            String checkAmt = sumColumnForCheck(sheet, amtColIdx, checkNo, checkColIdx);
//
//            if ("CC".equals(checkColLetter) && isDateBetween(fromDate, toDate, StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BY"))))) {
//                ecwPmtId = excelEobDao.insertEcwPaymentSkipDup(
//                        checkNo,
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BZ"))),
//                        checkAmt,
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("CB"))),
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BX"))),
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BY"))),
//                        createdBy, "Active", practiceId, fileName, eobJobId
//                );
//            } else if (status == 1 && isDateBetween(fromDate, toDate, StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AM"))))) {
//                ecwPmtId = excelEobDao.insertEcwPaymentSkipDup(
//                        checkNo,
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AN"))),
//                        checkAmt,
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AP"))),
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AL"))),
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AM"))),
//                        createdBy, "Active", practiceId, fileName, eobJobId);
//            } else if (status == 2 && isDateBetween(fromDate, toDate, StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BG"))))) {
//                ecwPmtId = excelEobDao.insertEcwPaymentSkipDup(
//                        checkNo,
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BH"))),
//                        checkAmt,
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BJ"))),
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BF"))),
//                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BG"))),
//                        createdBy, "Active", practiceId, fileName, eobJobId);
//            }
//
//            if (ecwPmtId == 0 && eobJobId > 0) {
//                Integer existing = excelEobDao.getExistingEcwPaymentId(checkNo, practiceId, eobJobId);
//                if (existing != null) {
//                    ecwPmtId = existing;
//                }
//            }
//
//            if (ecwPmtId > 0 && eobJobId > 0) {
//                insertAdvisoryAndPosting(sheet, checkNo, checkColLetter, ecwPmtId, eobJobId, createdBy, fileName, practiceId, advCols, postCols, status);
//            }
//        }
//    }
//
//    private void insertAdvisoryAndPosting(Sheet sheet, String checkNo, String checkColLetter, int ecwPmtId, int eobJobId,
//            Long createdBy, String fileName, String practiceId,
//            String[] advCols, String[] postCols, int status) throws SQLException, Exception {
//
//        int checkColIdx = StringUtilities.colIndex(checkColLetter);
//        java.util.Set<String> insertedClaims = new java.util.HashSet<>();
//
//        for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
//            Row row = sheet.getRow(rowIndex);
//            if (row == null) {
//                continue;
//            }
//            String rowCheck = StringUtilities.normalizeId(StringUtilities.getCellValue(row.getCell(checkColIdx)));
//            if (!StringUtilities.normalizeId(checkNo).equals(rowCheck)) {
//                continue;
//            }
//
//            String claimNo = StringUtilities.normalizeId(StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex(advCols[0]))));
//            if (claimNo.isEmpty()) {
//                continue;
//            }
//
//            String key = checkNo + "|" + claimNo;
//            if (!insertedClaims.add(key)) {
//                continue;
//            }
//
//            String billed = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[3]), claimNo, checkNo, checkColIdx);
//            String allowed = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[4]), claimNo, checkNo, checkColIdx);
//            String deduct = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[5]), claimNo, checkNo, checkColIdx);
//            String coins = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[6]), claimNo, checkNo, checkColIdx);
//            String copay = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[7]), claimNo, checkNo, checkColIdx);
//            String paid = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[8]), claimNo, checkNo, checkColIdx);
//
//            String adj;
//            switch (status) {
//                case 1 -> {
//                    adj = sumForClaimAndCheck(sheet, StringUtilities.colIndex("AU"), claimNo, checkNo, checkColIdx);
//                    adj = String.valueOf(Double.parseDouble(adj) + Double.parseDouble(sumForClaimAndCheck(sheet, StringUtilities.colIndex("AW"), claimNo, checkNo, checkColIdx)));
//                }
//                case 2 -> {
//                    adj = sumForClaimAndCheck(sheet, StringUtilities.colIndex("BO"), claimNo, checkNo, checkColIdx);
//                    adj = String.valueOf(Double.parseDouble(adj) + Double.parseDouble(sumForClaimAndCheck(sheet, StringUtilities.colIndex("BQ"), claimNo, checkNo, checkColIdx)));
//                }
//                default -> {
//                    adj = sumForClaimAndCheck(sheet, StringUtilities.colIndex("CG"), claimNo, checkNo, checkColIdx);
//                    adj = String.valueOf(Double.parseDouble(adj) + Double.parseDouble(sumForClaimAndCheck(sheet, StringUtilities.colIndex("CI"), claimNo, checkNo, checkColIdx)));
//                }
//            }
//
//            int ecwAdvId = excelEobDao.insertEcwPaymentAdvisorySkipDup(
//                    checkNo,
//                    claimNo,
//                    StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex(advCols[1]))),
//                    StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex(advCols[2]))),
//                    billed, allowed, deduct, coins, copay, paid, adj,
//                    "", "", "",
//                    createdBy, practiceId, fileName, eobJobId, ecwPmtId, status
//            );
//
//            if (ecwAdvId > 0) {
//                for (int pr = 1; pr <= sheet.getLastRowNum(); pr++) {
//                    Row prow = sheet.getRow(pr);
//                    if (prow == null) {
//                        continue;
//                    }
//                    String prowCheck = StringUtilities.normalizeId(StringUtilities.getCellValue(prow.getCell(checkColIdx)));
//                    String prowClaim = StringUtilities.normalizeId(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(advCols[0]))));
//                    if (!StringUtilities.normalizeId(checkNo).equals(prowCheck) || !claimNo.equals(prowClaim)) {
//                        continue;
//                    }
//                    String firstCode, secondCode;
//                    double adj1, adj2;
//                    switch (status) {
//                        case 1 -> {
//                            adj1 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("AU"))));
//                            adj2 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("AW"))));
//                            firstCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("AV")));
//                            secondCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("AX")));
//                        }
//                        case 2 -> {
//                            adj1 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("BO"))));
//                            adj2 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("BQ"))));
//                            firstCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("BP")));
//                            secondCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("BR")));
//                        }
//                        default -> {
//                            adj1 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("CG"))));
//                            adj2 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("CI"))));
//                            firstCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("CH")));
//                            secondCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("CJ")));
//                        }
//                    }
//                    String lineAdj = String.valueOf(adj1 + adj2);
//                    String codeCommaSep = "";
//                    if (StringUtilities.isNotEmpty(firstCode)) {
//                        codeCommaSep = firstCode;
//                    }
//                    if (StringUtilities.isNotEmpty(secondCode)) {
//                        if (!codeCommaSep.isEmpty()) {
//                            codeCommaSep += ",";
//                        }
//                        codeCommaSep += secondCode;
//                    }
//                    excelEobDao.insertEcwPaymentPostingSkipDup(
//                            checkNo,
//                            claimNo,
//                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[1]))),
//                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[2]))),
//                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[3]))),
//                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[4]))),
//                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[5]))),
//                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[6]))),
//                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[7]))),
//                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[8]))),
//                            lineAdj, codeCommaSep,
//                            createdBy, practiceId, fileName, eobJobId, ecwAdvId
//                    );
//                    excelEobDao.updateEcwPayment(ecwPmtId);
//                }
//            }
//        }
//    }
//
//    private String sumColumnForCheck(Sheet sheet, int valueColIdx, String checkNo, int checkColIdx) {
//        double sum = 0;
//
//        String checkNorm = StringUtilities.normalizeId(checkNo);
//
//        for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
//            Row row = sheet.getRow(rowIndex);
//            if (row == null) {
//                continue;
//            }
//
//            String rowCheck = StringUtilities.normalizeId(
//                    StringUtilities.getCellValue(row.getCell(checkColIdx))
//            );
//
//            if (!checkNorm.equals(rowCheck)) {
//                continue;
//            }
//
//            try {
//                String valueColumnIndex = StringUtilities.getCellValue(row.getCell(valueColIdx));
//                if (valueColumnIndex != null && !valueColumnIndex.isEmpty()) {
//                    sum += Double.parseDouble(valueColumnIndex);
//                }
//            } catch (NumberFormatException ignore) {
//            }
//        }
//        return String.format("%.2f", sum);
//    }
//
//    private String sumForClaimAndCheck(Sheet sheet, int colIdx, String claimNo, String checkNo, int checkColIdx) {
//        double sum = 0.0;
//        String claimNorm = StringUtilities.normalizeId(claimNo);
//        String checkNorm = StringUtilities.normalizeId(checkNo);
//        for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
//            Row row = sheet.getRow(rowIndex);
//            if (row == null) {
//                continue;
//            }
//            String rowCheck = StringUtilities.normalizeId(StringUtilities.getCellValue(row.getCell(checkColIdx)));
//            String rowClaim = StringUtilities.normalizeId(StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("B"))));
//            if (!checkNorm.equals(rowCheck) || !claimNorm.equals(rowClaim)) {
//                continue;
//            }
//            try {
//                String columnIndex = StringUtilities.getCellValue(row.getCell(colIdx));
//                if (columnIndex != null && !columnIndex.isEmpty()) {
//                    sum += Double.parseDouble(columnIndex);
//                }
//            } catch (NumberFormatException ignored) {
//            }
//        }
//        return String.format("%.2f", sum);
//    }
    @GetMapping(value = "/update-excel-eob-status")
    public @ResponseBody
    String updateExcelEobStatus(@RequestParam int id, @RequestParam String status) throws SQLException {
        try {
            LOGGER.info("Excel EOB Controller update-excel-eob-status is Entered!");
            excelEobDao.updateEobJobStatus(id, 0, status);
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return "redirect:/paperEob";
    }

    @GetMapping(value = "/move-data-from-stage-to-live")
    public @ResponseBody
    String moveDataFromStagingToLive(@RequestParam int id) throws SQLException {
        try {
            LOGGER.info("Excel EOB Controller move-data-from-stage-to-live is Entered!");
            excelEobDao.moveDataFromStagingToLive(id);
            return "Success";
        } catch (Exception ex) {
            LOGGER.error("Exception:", ex);
        }
        return "Failed";
    }

    @PostMapping("/move-data-from-stage-to-live-payment")
    @ResponseBody
    public String moveDataFromStagingToLivePayments(@RequestBody(required = false) List<Integer> pmtIdList,
            HttpSession session) throws SQLException {
        try {
            LOGGER.info("Excel EOB Controller move-data-from-stage-to-live-payment entered!");
            Long userId = SessionUtils.getSessionUserId(session);
            excelEobDao.moveDataFromStagingToLivePayment(userId, pmtIdList);
            return "Success";
        } catch (Exception ex) {
            LOGGER.error("Exception in move-data-from-stage-to-live-paymentss:", ex);
            return "Failed";
        }
    }

    private boolean isDateBetween(String fromDate, String toDate, String cellValue) {

        if (StringUtilities.isEmpty(fromDate) || StringUtilities.isEmpty(toDate)) {
            return true;
        }

        if (StringUtilities.isEmpty(cellValue)) {
            return false;
        }

        boolean result = false;
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
            LocalDate from = LocalDate.parse(fromDate.trim(), formatter);
            LocalDate to = LocalDate.parse(toDate.trim(), formatter);
            LocalDate cell = LocalDate.parse(cellValue.trim(), formatter);
            result = !cell.isBefore(from) && !cell.isAfter(to);
        } catch (Exception e) {
            LOGGER.info("Exception while parsing dates: " + e.getMessage());
        }

        return result;
    }

}
