package com.billingparadise.web.service;

import com.billingparadise.web.dao.ExcelEobDao;
import com.billingparadise.web.util.StringUtilities;
import java.io.File;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 *
 * @author user
 */
@Service
public class ExcelEobAsyncService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExcelEobAsyncService.class);

    @Autowired
    private ExcelEobDao excelEobDao;

    @Async
    public void processExcelFile(String filePath, String practiceId, String fileName, Long createdBy, int eobJobId, String dateRange) throws SQLException {
        boolean stagingSuccess = true;
        int totalRows = 0;
        String fromDate = null;
        String toDate = null;
        if (dateRange != null && !dateRange.trim().isEmpty()) {
            String[] dates = dateRange.split(" / ", 2);
            if (dates.length >= 2) {
                fromDate = dates[0].trim();
                toDate = dates[1].trim();
            }
        }
        excelEobDao.updateEobJobStatus(eobJobId, 0, "Processing");

        try (Workbook workbook = WorkbookFactory.create(new File(filePath))) {

            Sheet sheet = workbook.getSheetAt(0);
            totalRows = sheet.getLastRowNum();

            processCheckSection(sheet, "AQ", "AY",
                    new String[]{"B", "H", "D", "AF", "AT", "AZ", "BA", "BB", "AY", "AU"},
                    new String[]{"B", "H", "T", "AF", "AT", "AZ", "BA", "BB", "AY", "AU"},
                    practiceId, fileName, createdBy, eobJobId, totalRows, 1, fromDate, toDate);

            processCheckSection(sheet, "BK", "BS",
                    new String[]{"B", "H", "D", "AF", "BN", "BT", "BU", "BV", "BS", "BO"},
                    new String[]{"B", "H", "T", "AF", "BN", "BT", "BU", "BV", "BS", "BO"},
                    practiceId, fileName, createdBy, eobJobId, totalRows, 2, fromDate, toDate);

            processCheckSection(sheet, "CC", "CK",
                    new String[]{"B", "H", "D", "AF", "CF", "CL", "CM", "CN", "CK", "CG"},
                    new String[]{"B", "H", "T", "AF", "CF", "CL", "CM", "CN", "CK", "CG"},
                    practiceId, fileName, createdBy, eobJobId, totalRows, 99, fromDate, toDate);

        } catch (Exception e) {
            stagingSuccess = false;
        }

        if (stagingSuccess) {
            excelEobDao.updateEobJobStatus(eobJobId, totalRows, "Staging success");
        } else {
            excelEobDao.updateEobJobStatus(eobJobId, totalRows, "Staging fail");
        }
    }

    private void processCheckSection(Sheet sheet, String checkColLetter, String amtColLetter,
            String[] advCols, String[] postCols, String practiceId, String fileName, Long createdBy,
            int eobJobId, int totalRows, int status, String fromDate, String toDate) throws SQLException, Exception {

        int checkColIdx = StringUtilities.colIndex(checkColLetter);
        int amtColIdx = StringUtilities.colIndex(amtColLetter);
        int ecwPmtId = 0;
        int byCount = 0;
        int amCount = 0;
        int bgCount = 0;
        boolean isExists = false;

        LOGGER.info("From: {} To: {} Status: {}", fromDate, toDate, status);
        for (int rowIndex = 1; rowIndex <= totalRows; rowIndex++) {
            Row row = sheet.getRow(rowIndex);
            if (row == null) {
                continue;
            }
            isExists = false;
            String checkNo = StringUtilities.getCellValue(row.getCell(checkColIdx));
            if (checkNo.isEmpty()) {
                continue;
            }

            if (excelEobDao.isCheckNumberExistsInERA(checkNo, practiceId)) {
                continue;
            }

            String checkAmt = sumColumnForCheck(sheet, amtColIdx, checkNo, checkColIdx);

            if (status == 99 && "CC".equals(checkColLetter) && isDateBetween(fromDate, toDate, StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BY"))))) {
                LOGGER.info("99 [BY] - Check No {} : ", checkNo);
                isExists = true;
                byCount++;
                ecwPmtId = excelEobDao.insertEcwPaymentSkipDup(
                        checkNo,
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BZ"))),
                        checkAmt,
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("CB"))),
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BX"))),
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BY"))),
                        createdBy, "Active", practiceId, fileName, eobJobId
                );
            } else if (status == 1 && isDateBetween(fromDate, toDate, StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AM"))))) {
                LOGGER.info("1 [AM] - Check No {} : ", checkNo);
                isExists = true;
                amCount++;
                ecwPmtId = excelEobDao.insertEcwPaymentSkipDup(
                        checkNo,
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AN"))),
                        checkAmt,
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AP"))),
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AL"))),
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("AM"))),
                        createdBy, "Active", practiceId, fileName, eobJobId);
            } else if (status == 2 && isDateBetween(fromDate, toDate, StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BG"))))) {
                LOGGER.info("2 [BG] - Check No {} : ", checkNo);
                isExists = true;
                bgCount++;
                ecwPmtId = excelEobDao.insertEcwPaymentSkipDup(
                        checkNo,
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BH"))),
                        checkAmt,
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BJ"))),
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BF"))),
                        StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("BG"))),
                        createdBy, "Active", practiceId, fileName, eobJobId);
            }

            if (ecwPmtId == 0 && eobJobId > 0 && isExists) {           
                LOGGER.info("getExistingEcwPaymentId : is existing ecwPmtId {} Check No {} eobJobId {} isExist {} ", ecwPmtId, checkNo, eobJobId, isExists);
                Integer existing = excelEobDao.getExistingEcwPaymentId(checkNo, practiceId, eobJobId);
                if (existing != null) {
                    ecwPmtId = existing;
                }
            } else {
                LOGGER.info("getExistingEcwPaymentId: is Not existing ecwPmtId {} Check No {} eobJobId {} isExist {} ", ecwPmtId, checkNo, eobJobId, isExists);
            }

            if (ecwPmtId > 0 && eobJobId > 0 && isExists) {           
                LOGGER.info("insertAdvisoryAndPosting : is existing ecwPmtId {} Check No {} eobJobId {} isExist {} ", ecwPmtId, checkNo, eobJobId, isExists);
                insertAdvisoryAndPosting(sheet, checkNo, checkColLetter, ecwPmtId, eobJobId, createdBy, fileName, practiceId, advCols, postCols, status);
            } else {
                LOGGER.info("insertAdvisoryAndPosting: is Not existing ecwPmtId {} Check No {} eobJobId {} isExist {} ", ecwPmtId, checkNo, eobJobId, isExists);
            }
        }
        LOGGER.info(" BYCount: {} AMCount: {} BGCount: {} ", byCount, amCount, bgCount);
    }

    private void insertAdvisoryAndPosting(Sheet sheet, String checkNo, String checkColLetter, int ecwPmtId, int eobJobId,
            Long createdBy, String fileName, String practiceId,
            String[] advCols, String[] postCols, int status) throws SQLException, Exception {

        int checkColIdx = StringUtilities.colIndex(checkColLetter);
        java.util.Set<String> insertedClaims = new java.util.HashSet<>();

        for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
            Row row = sheet.getRow(rowIndex);
            if (row == null) {
                continue;
            }
            String rowCheck = StringUtilities.normalizeId(StringUtilities.getCellValue(row.getCell(checkColIdx)));
            if (!StringUtilities.normalizeId(checkNo).equals(rowCheck)) {
                continue;
            }

            String claimNo = StringUtilities.normalizeId(StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex(advCols[0]))));
            if (claimNo.isEmpty()) {
                continue;
            }

            String key = checkNo + "|" + claimNo;
            if (!insertedClaims.add(key)) {
                continue;
            }

            String billed = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[3]), claimNo, checkNo, checkColIdx);
            String allowed = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[4]), claimNo, checkNo, checkColIdx);
            String deduct = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[5]), claimNo, checkNo, checkColIdx);
            String coins = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[6]), claimNo, checkNo, checkColIdx);
            String copay = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[7]), claimNo, checkNo, checkColIdx);
            String paid = sumForClaimAndCheck(sheet, StringUtilities.colIndex(advCols[8]), claimNo, checkNo, checkColIdx);

            String adj;
            switch (status) {
                case 1 -> {
                    adj = sumForClaimAndCheck(sheet, StringUtilities.colIndex("AU"), claimNo, checkNo, checkColIdx);
                    adj = String.valueOf(Double.parseDouble(adj) + Double.parseDouble(sumForClaimAndCheck(sheet, StringUtilities.colIndex("AW"), claimNo, checkNo, checkColIdx)));
                }
                case 2 -> {
                    adj = sumForClaimAndCheck(sheet, StringUtilities.colIndex("BO"), claimNo, checkNo, checkColIdx);
                    adj = String.valueOf(Double.parseDouble(adj) + Double.parseDouble(sumForClaimAndCheck(sheet, StringUtilities.colIndex("BQ"), claimNo, checkNo, checkColIdx)));
                }
                default -> {
                    adj = sumForClaimAndCheck(sheet, StringUtilities.colIndex("CG"), claimNo, checkNo, checkColIdx);
                    adj = String.valueOf(Double.parseDouble(adj) + Double.parseDouble(sumForClaimAndCheck(sheet, StringUtilities.colIndex("CI"), claimNo, checkNo, checkColIdx)));
                }
            }

            int ecwAdvId = excelEobDao.insertEcwPaymentAdvisorySkipDup(
                    checkNo,
                    claimNo,
                    StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex(advCols[1]))),
                    StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex(advCols[2]))),
                    billed, allowed, deduct, coins, copay, paid, adj,
                    "", "", "",
                    createdBy, practiceId, fileName, eobJobId, ecwPmtId, status
            );

            if (ecwAdvId > 0) {
                for (int pr = 1; pr <= sheet.getLastRowNum(); pr++) {
                    Row prow = sheet.getRow(pr);
                    if (prow == null) {
                        continue;
                    }
                    String prowCheck = StringUtilities.normalizeId(StringUtilities.getCellValue(prow.getCell(checkColIdx)));
                    String prowClaim = StringUtilities.normalizeId(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(advCols[0]))));
                    if (!StringUtilities.normalizeId(checkNo).equals(prowCheck) || !claimNo.equals(prowClaim)) {
                        continue;
                    }
                    String firstCode, secondCode;
                    double adj1, adj2;
                    switch (status) {
                        case 1 -> {
                            adj1 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("AU"))));
                            adj2 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("AW"))));
                            firstCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("AV")));
                            secondCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("AX")));
                        }
                        case 2 -> {
                            adj1 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("BO"))));
                            adj2 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("BQ"))));
                            firstCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("BP")));
                            secondCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("BR")));
                        }
                        default -> {
                            adj1 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("CG"))));
                            adj2 = StringUtilities.parseDoubleValue(StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("CI"))));
                            firstCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("CH")));
                            secondCode = StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex("CJ")));
                        }
                    }
                    String lineAdj = String.valueOf(adj1 + adj2);
                    String codeCommaSep = "";
                    if (StringUtilities.isNotEmpty(firstCode)) {
                        codeCommaSep = firstCode;
                    }
                    if (StringUtilities.isNotEmpty(secondCode)) {
                        if (!codeCommaSep.isEmpty()) {
                            codeCommaSep += ",";
                        }
                        codeCommaSep += secondCode;
                    }
                    excelEobDao.insertEcwPaymentPostingSkipDup(
                            checkNo,
                            claimNo,
                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[1]))),
                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[2]))),
                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[3]))),
                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[4]))),
                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[5]))),
                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[6]))),
                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[7]))),
                            StringUtilities.getCellValue(prow.getCell(StringUtilities.colIndex(postCols[8]))),
                            lineAdj, codeCommaSep,
                            createdBy, practiceId, fileName, eobJobId, ecwAdvId
                    );
                    excelEobDao.updateEcwPayment(ecwPmtId);
                }
            }
        }
    }

    private String sumColumnForCheck(Sheet sheet, int valueColIdx, String checkNo, int checkColIdx) {
        double sum = 0;

        String checkNorm = StringUtilities.normalizeId(checkNo);

        for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
            Row row = sheet.getRow(rowIndex);
            if (row == null) {
                continue;
            }

            String rowCheck = StringUtilities.normalizeId(
                    StringUtilities.getCellValue(row.getCell(checkColIdx))
            );

            if (!checkNorm.equals(rowCheck)) {
                continue;
            }

            try {
                String valueColumnIndex = StringUtilities.getCellValue(row.getCell(valueColIdx));
                if (valueColumnIndex != null && !valueColumnIndex.isEmpty()) {
                    sum += Double.parseDouble(valueColumnIndex);
                }
            } catch (NumberFormatException ignore) {
            }
        }
        return String.format("%.2f", sum);
    }

    private String sumForClaimAndCheck(Sheet sheet, int colIdx, String claimNo, String checkNo, int checkColIdx) {
        double sum = 0.0;
        String claimNorm = StringUtilities.normalizeId(claimNo);
        String checkNorm = StringUtilities.normalizeId(checkNo);
        for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
            Row row = sheet.getRow(rowIndex);
            if (row == null) {
                continue;
            }
            String rowCheck = StringUtilities.normalizeId(StringUtilities.getCellValue(row.getCell(checkColIdx)));
            String rowClaim = StringUtilities.normalizeId(StringUtilities.getCellValue(row.getCell(StringUtilities.colIndex("B"))));
            if (!checkNorm.equals(rowCheck) || !claimNorm.equals(rowClaim)) {
                continue;
            }
            try {
                String columnIndex = StringUtilities.getCellValue(row.getCell(colIdx));
                if (columnIndex != null && !columnIndex.isEmpty()) {
                    sum += Double.parseDouble(columnIndex);
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return String.format("%.2f", sum);
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