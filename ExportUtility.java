package com.nellikkai.web.util;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.function.Supplier;

/**
 *
 * @author DELL
 */
public enum ExportUtility {

    CUSTOM_DENIAL_REPORT("customDenialReport", ExportUtility::createCustomDenialFieldMapping),
    ADJUSTMENT_REPORT("adjustmentReport", ExportUtility::createAdjustmentFieldMapping),
    CLAIM_EXCEPTION_REPORT("claimExceptionReport", ExportUtility::createClaimExceptionFieldMapping),
    OUTGOING_CLAIMS_REPORT("outgoingClaimsReport", ExportUtility::createOutGoingClaimsFieldMapping),
    UNDERPAID_CLAIMS_REPORT("outgoingClaimsReport", ExportUtility::createUnderPaidClaimsFieldMapping),
    CLAIM_WISE_REPORT("claimwiseReport", ExportUtility::createClaimwiseFieldMapping),
    CLIENT_SNAPSHOT_REPORT("clientSnapShotReport", ExportUtility::createClientSnapshotFieldMapping),
    DENIAL_REPORT("denialReport", ExportUtility::createDenialFieldMapping),
    PARTLY_DENIAL_REPORT("partlyDenialReport", ExportUtility::createPartlyDenialFieldMapping),
    EDI_EXCEPTION_REPORT("ediReport", ExportUtility::createEDIFieldMapping),
    EV_LIST_REPORT("evListReport", ExportUtility::createEvListFieldMapping),
    EOB_WISE_REPORT("eobWiseReport", ExportUtility::createEobWiseFieldMapping),
    ERA_EXCEPTION_REPORT("eraExceptionReport", ExportUtility::createEraExceptionFieldMapping),
    MISSED_CLAIMS_REPORT("missedClaimsReport", ExportUtility::createMissedClaimsFieldMapping),
    NO_RESPONSE_CLAIMS_REPORT("noResponseClaimsReport", ExportUtility::createNoResponseClaimsFieldMapping),
    REVERSAL_CLAIMS_REPORT("reversalClaimsReport", ExportUtility::createReversalClaimsFieldMapping),
    ML_FEE_SCHEDULE_REPORT("mlFeeScheduleReport", ExportUtility::createMlFeeScheduleFieldMapping),
    PROJECTED_REVENUE_REPORT("projectedRevenueReport", ExportUtility::createProjectedRevenueFieldMapping),
    KNOWLEDGE_BASE_REPORT("knowledgeBaseReport", ExportUtility::createKnowledgeBaseFieldMapping),
    DENIAL_RULES_REPORT("denialRulesReport", ExportUtility::createDenialRulesMapping),
    CLAIM_RULES_REPORT("claimRulesReport", ExportUtility::createClaimRulesMapping),
    CLAIM_DETAIL_VIEW_REPORT("claimDetailedViewReport", ExportUtility::createClaimDetailViewFieldMapping),
    CLAIM_REQUEST_REPORT("claimRequestViewReport", ExportUtility::createClaimRequestFieldMapping),
    COVERED_UNPAID_CLAIMS_REPORT("coveredunpaidReport", ExportUtility::createCoveredUnpaidClaimsFieldMapping),
    DENIAL_AR_REPORT("denialARReport", ExportUtility::createDenialArFieldMapping),
    PROSPECT_PATIENT_INFO_REPORT("prospectRuleReport", ExportUtility::createProspectPatientInfoFieldMapping),
    PROSPECT_PATIENT_REPORT("prospectRuleReport", ExportUtility::createProspectPatientFieldMapping),
    USER_MASTER_REPORT("userMasterReport", ExportUtility::createUserMasterFieldMapping),
    GENERIC_FEE_SCHEDULE_REPORT("genericFeeScheduleReport", ExportUtility::createGenericFeeScheduleFieldMapping),
    EOB_PAYMENT_REPORT("eobPaymentReport", ExportUtility::createEobPaymentFieldMapping),
    EOB_ADVISORY_REPORT("eobAdvisoryReport", ExportUtility::createEobAdvisoryFieldMapping),
    EOB_POSTING_REPORT("eobPostingReport", ExportUtility::createEobPostingFieldMapping),
    EOB_PAYMENT_SCRAPING_REPORT("eobPaymentReport", ExportUtility::createEobPaymentScrapingFieldMapping),
    EOB_ADVISORY_SCRAPING_REPORT("eobAdvisoryReport", ExportUtility::createEobAdvisoryScrapingFieldMapping),
    EOB_POSTING_SCRAPING_REPORT("eobPostingReport", ExportUtility::createEobPostingScrapingFieldMapping),
    OPEN_PROBLEM_REPORT("openProblemReport", ExportUtility::createOpenProblemFieldMapping),
    EV_QUERY_REPORT("evQueryReport", ExportUtility::createEvQueryFieldMapping),
    EV_RESULT_REPORT("evResultReport", ExportUtility::createEvResultFieldMapping),
    ALIAS_REPORT("aliasReport", ExportUtility::createAliasFieldMapping),
    FAVORITES_REPORT("favoritesReport", ExportUtility::createFavoritesFieldMapping),
    INCLUSION_REPORT("inclusionReport", ExportUtility::createInclusionFieldMapping),
    NETWORK_REPORT("networkReport", ExportUtility::createNetworkFieldMapping),
    EXCLUSION_REPORT("networkReport", ExportUtility::createExclusionFieldMapping),
    EV_CONFIG_NPI_REPORT("evConfigReport", ExportUtility::createEvConfigNpiFieldMapping),
    EXCEL_CONFIG_REPORT("excelConfigReport", ExportUtility::createExcelConfigMapping),
    AUTH_CONFIG_ML_REPORT("authConfigReport", ExportUtility::createAuthConfigMLFieldMapping),
    DENIAL_CONFIG_REPORT("denialConfigReport", ExportUtility::createDenialConfigMapping),
    SETTLED_EHR_CLAIMS_REPORT("settledEHRClaimsReport", ExportUtility::createSettledEHRClaimsFieldMapping),
    TEAM_USER_MAPPING_REPORT("teamUserMappingReport", ExportUtility::createTeamUserMappingFieldMapping),
    TEAM_PRACTICE_MAPPING_REPORT("teamPracticeMappingReport", ExportUtility::createTeamPracticeMappingFieldMapping),
    AUDIT_LOG_REPORT("auditLogReport", ExportUtility::createAuditLogFieldMapping),
    EXPORT_LOG_REPORT("exportLogReport", ExportUtility::createExportLogFieldMapping);

    private final String report;
    private final LinkedHashMap<String, String> fieldMapping;

    ExportUtility(String report, Supplier<LinkedHashMap<String, String>> fieldMapper) {
        this.report = report;
        this.fieldMapping = fieldMapper.get();
    }

    public String getReport() {
        return report;
    }

    public LinkedHashMap<String, String> getFieldMapping() {
        if (fieldMapping.isEmpty()) {
            throw new IllegalStateException("Field mapping is empty or null for: " + report);
        }
        return fieldMapping;
    }

    public static Map<String, LinkedHashMap<String, String>> getAllFieldMappings() {
        Map<String, LinkedHashMap<String, String>> mappings = new LinkedHashMap<>();
        for (ExportUtility report : values()) {
            try {
                mappings.put(report.getReport(), report.getFieldMapping());
            } catch (Exception e) {
                throw new IllegalStateException("Error retrieving field mapping for: " + report.getReport(), e);
            }
        }
        return mappings;
    }

    private static LinkedHashMap<String, String> createCustomDenialFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("Status", "status");
        fieldMapping.put("ACCNT", "payee");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("Paid", "paidamt");
        fieldMapping.put("COV", "coveredAmount");
        fieldMapping.put("D_Status", "denialstatus");
        fieldMapping.put("Rec_Date", "claimDate");
        fieldMapping.put("DOS", "dateOfService");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("File", "fn");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("Patient", "patient");
        fieldMapping.put("EFT", "eft");
        fieldMapping.put("Payor_ICN", "payericn");
        fieldMapping.put("PR", "patientres");
        fieldMapping.put("CR_Date", "recdate");
        fieldMapping.put("Ticket_Id", "ticket_id");
        fieldMapping.put("Acted_By", "actedby");
        fieldMapping.put("REN_PROV", "rendproid");
        fieldMapping.put("Elapsed", "difference");
        fieldMapping.put("Action Code", "actiontaken");
        fieldMapping.put("Action Taken By", "action_taken_by");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("Reason_Code", "reasonCode");
        fieldMapping.put("SuggestionData", "suggestionList");
        fieldMapping.put("Ticket History", "ticketHistoryList");
        fieldMapping.put("Flag", "paymentStatus");
        fieldMapping.put("LTD", "ticketElapsed");
        fieldMapping.put("DOB", "dateOfBirth");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createAdjustmentFieldMapping() {
        LinkedHashMap<String, String> fields = new LinkedHashMap<>();
        fields.put("File", "fn");
        fields.put("DOR", "dor");
        fields.put("Fas_Per", "fiscal_period");
        fields.put("Amt", "amount");
        fields.put("Mode", "mode");
        fields.put("Payor", "payor");
        fields.put("Payee", "payee");
        fields.put("CHK/EFT", "eft");
        fields.put("Reason", "segment");
        fields.put("Identifier", "adj_identifier");
        fields.put("C/D", "type");
        fields.put("ACCNT", "cd");
        fields.put("Bill_NPI", "billingnpi");
        fields.put("Rec_Date", "receivedDate");
        return fields;
    }

    private static LinkedHashMap<String, String> createClaimExceptionFieldMapping() {
        LinkedHashMap<String, String> fields = new LinkedHashMap<>();
        fields.put("File", "fn");
        fields.put("EFT", "eft");
        fields.put("Claim", "claimno");
        fields.put("Payor_ICN", "payericn");
        fields.put("CHK_Date", "eftdate");
        fields.put("Status", "status");
        fields.put("Payor", "payer");
        fields.put("Payee", "payee");
        fields.put("Charge", "chargeamt");
        fields.put("COV", "coveredAmount");
        fields.put("Paid", "paidamt");
        fields.put("PR", "patientres");
        fields.put("CR_Date", "recdate");
        fields.put("CFI", "");
        fields.put("Patient", "lname,fname");
        fields.put("Covered", "");
        fields.put("SubscriberId", "");
        fields.put("SubscriberName", "");
        fields.put("ProviderNpi", "");
        fields.put("ProviderName", "");
        fields.put("CR_Date1", "");
        fields.put("TID", "tid");
        fields.put("Desc", "");
        fields.put("Payor1", "");
        fields.put("Payee1", "");
        fields.put("Chk_Date1", "");
        fields.put("CFI1", "");
        fields.put("ACCNT", "account_no");
        fields.put("MemberID", "");
        fields.put("Dos", "dateOfService");
        return fields;
    }

    private static LinkedHashMap<String, String> createOutGoingClaimsFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Filename", "fn");
        fieldMapping.put("ACCNT", "pataccno");
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("DOS_From", "fromdos");
        fieldMapping.put("DOS_To", "todos");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("P-Type", "pType");
        fieldMapping.put("Claim_Date", "recdate");
        fieldMapping.put("Patient", "lname,fname");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("Tax_ID", "taxid");
        fieldMapping.put("StateLicenseID", "stalinid");
        fieldMapping.put("Insured_ID", "insid");
        fieldMapping.put("Print", "printclaim");
        fieldMapping.put("Err_Des", "");
        fieldMapping.put("Practice", "");
        fieldMapping.put("Tid", "tid");
        fieldMapping.put("Rec_Date", "recdate");
        fieldMapping.put("Serv_NPI", "service_facility_npi");
        fieldMapping.put("Facility", "facilityname");
        fieldMapping.put("Filename1", "fn");
        fieldMapping.put("Payor1", "payer");
        fieldMapping.put("PROJ", "coveredAmount");
        fieldMapping.put("Dob", "dateOfBirth");
        fieldMapping.put("Paid", "paid");
        fieldMapping.put("Percent", "percentage");
        fieldMapping.put("Claim_Status", "claimstatus");
        fieldMapping.put("TKT", "ticket_id");
        fieldMapping.put("Status", "status");
        fieldMapping.put("Activity", "actionCode");
        fieldMapping.put("CSV", "categoryCode");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("Flag", "paymentStatus");
        fieldMapping.put("DTC", "dayToClaim");
        fieldMapping.put("CFI", "cfi");
        fieldMapping.put("Allowed", "allowedAmount");
        fieldMapping.put("FeeDiff", "feeDifference");
        fieldMapping.put("Notes", "comments");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createClaimwiseFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("File", "fn");
        fieldMapping.put("EFT", "eft");
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("Payor_ICN", "payericn");
        fieldMapping.put("CHK_Date", "eftdate");
        fieldMapping.put("C_Status", "claimstatus");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("Payee", "payee");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("COV", "coveredAmount");
        fieldMapping.put("Paid", "paidamt");
        fieldMapping.put("PR", "patientres");
        fieldMapping.put("CR_Date", "recdate");
        fieldMapping.put("CFI", "");
        fieldMapping.put("Patient", "lname,fname");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("ACCNT", "account_no");
        fieldMapping.put("MemberID", "");
        fieldMapping.put("Dos", "dateOfService");
        fieldMapping.put("TKT", "ticketId");
        fieldMapping.put("Status", "status");
        fieldMapping.put("Rec_Date", "receiveddate");
        fieldMapping.put("Flag", "paymentStatus");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Date", "createdDate");
        fieldMapping.put("CPT Codes", "procedureCode");
        fieldMapping.put("Reason Codes", "reasonCode");
        fieldMapping.put("DOB", "dateOfBirth");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createClientSnapshotFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("PRACTICE_OR_MONTH", "practice|month");
        fieldMapping.put("SENT", "claimSent");
        fieldMapping.put("RESPONSE", "claimResponse");
        fieldMapping.put("OPEN", "openClaims");
        fieldMapping.put("PAID", "claimsPaid");
        fieldMapping.put("UR-DEN", "unResolvedDenials");
        fieldMapping.put("RPTG", "repeatingClaims");
        fieldMapping.put("UR-SEC", "secondaryDenials");
        fieldMapping.put("FIRST_PASS", "firstPassClaimRatio");
        fieldMapping.put("UR-COV", "coveredUnpaidClaims");
        fieldMapping.put("MC", "capitationClaims");
        fieldMapping.put("UR-PD", "partlyPaid");
        fieldMapping.put("PERF", "performance");
        fieldMapping.put("PROJ_REV", "projectedRevenue");
        fieldMapping.put("WL", "wlClaims");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createDenialFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("Status", "status");
        fieldMapping.put("ACCNT", "payee");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("Paid", "paidamt");
        fieldMapping.put("COV", "coveredAmount");
        fieldMapping.put("D_Status", "denialstatus");
        fieldMapping.put("Rec_Date", "claimDate");
        fieldMapping.put("DOS", "dateOfService");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("File", "fn");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("Patient", "patient");
        fieldMapping.put("EFT", "eft");
        fieldMapping.put("Payor_ICN", "payericn");
        fieldMapping.put("PR", "patientres");
        fieldMapping.put("CR_Date", "recdate");
        fieldMapping.put("Ticket_Id", "ticket_id");
        fieldMapping.put("Acted_By", "actedby");
        fieldMapping.put("REN_PROV", "rendproid");
        fieldMapping.put("Elapsed", "difference");
        fieldMapping.put("Action Code", "actiontaken");
        fieldMapping.put("Action Taken By", "action_taken_by");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("Reason_Code", "reasonCode");
        fieldMapping.put("SuggestionData", "suggestionList");
        fieldMapping.put("Ticket History", "ticketHistoryList");
        fieldMapping.put("Flag", "paymentStatus");
        fieldMapping.put("LTD", "ticketElapsed");
        fieldMapping.put("DOB", "dateOfBirth");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createPartlyDenialFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("Status", "status");
        fieldMapping.put("ACCNT", "payee");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("COV", "coveredAmount");
        fieldMapping.put("Paid", "paidamt");
        fieldMapping.put("D_Status", "denialstatus");
        fieldMapping.put("Rec_Date", "claimDate");
        fieldMapping.put("DOS", "dateOfService");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("File", "fn");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("Patient", "patient");
        fieldMapping.put("EFT", "eft");
        fieldMapping.put("Payor_ICN", "payericn");
        fieldMapping.put("PR", "patientres");
        fieldMapping.put("CR_Date", "recdate");
        fieldMapping.put("Ticket_Id", "ticket_id");
        fieldMapping.put("Acted_By", "actedby");
        fieldMapping.put("REN_PROV", "rendproid");
        fieldMapping.put("Elapsed", "difference");
        fieldMapping.put("Action Code", "actiontaken");
        fieldMapping.put("Action Taken By", "action_taken_by");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("Reason_Code", "reasonCode");
        fieldMapping.put("SuggestionData", "suggestionList");
        fieldMapping.put("Ticket History", "ticketHistoryList");
        fieldMapping.put("LTD", "ticketElapsed");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEDIFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "tableId");
        fieldMapping.put("FileName", "fileName");
        fieldMapping.put("Entity", "entityName");
        fieldMapping.put("Practice", "practiceName");
        fieldMapping.put("EMR", "emrName");
        fieldMapping.put("EDI_Type", "ediType");
        fieldMapping.put("No_of_Claims", "noOfClaims");
        fieldMapping.put("Error_Type", "errorType");
        fieldMapping.put("Status", "status");
        fieldMapping.put("Notes", "notes");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEvListFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("BR.ID", "requestid");
        fieldMapping.put("DOBEN", "dateofbenefit");
        fieldMapping.put("PatAcc", "patAccNo");
        fieldMapping.put("Job", "jobNumber");
        fieldMapping.put("Patient", "patient");
        fieldMapping.put("Subscriber", "subscriber");
        fieldMapping.put("Practice", "practicename");
        fieldMapping.put("EMR_Payor", "uploadPayor");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("DOS", "dos");
        fieldMapping.put("Status", "benefitstatus");
        fieldMapping.put("Clearing_House", "clearingHouse");
        fieldMapping.put("rqid", "requestid");
        fieldMapping.put("BenStatus", "benefitstatus");
        fieldMapping.put("Pid", "practiceid");
        fieldMapping.put("MemberId", "mid");
        fieldMapping.put("GroupNPI", "group_npi");
        fieldMapping.put("Dob", "dob");
        fieldMapping.put("Gender", "genderid");
        fieldMapping.put("Payor_Id", "payorid");
        fieldMapping.put("Practice", "practicename");
        fieldMapping.put("Patient", "patient");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("Auth Config", "authId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEobWiseFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("File", "fn");
        fieldMapping.put("Chk_Dt", "dorr");
        fieldMapping.put("Amount", "amount");
        fieldMapping.put("Mode", "mode");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("CHK_EFT", "eft");
        fieldMapping.put("Payee", "payee");
        fieldMapping.put("ERA_Type", "type");
        fieldMapping.put("ACCNT", "cd");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("Bill_NPI", "billingNPI");
        fieldMapping.put("Chk_Dt1", "dorr");
        fieldMapping.put("fDORR", "");
        fieldMapping.put("Payor1", "payer");
        fieldMapping.put("Practice", "payee");
        fieldMapping.put("NPI", "billingNPI");
        fieldMapping.put("Account", "cd");
        fieldMapping.put("Rec_Date", "receivedDate");
        fieldMapping.put("Ticket#", "ticketId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEraExceptionFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("File", "fn");
        fieldMapping.put("Chk_Dt", "dorr");
        fieldMapping.put("Amount", "amount");
        fieldMapping.put("Mode", "mode");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("CHK_EFT", "eft");
        fieldMapping.put("Payee", "payee");
        fieldMapping.put("ERA_Type", "type");
        fieldMapping.put("ACCNT", "cd");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("Bill_NPI", "billingNPI");
        fieldMapping.put("Chk_Dt1", "dorr");
        fieldMapping.put("fDORR", "");
        fieldMapping.put("Payor1", "payer");
        fieldMapping.put("Practice", "payee");
        fieldMapping.put("NPI", "billingNPI");
        fieldMapping.put("Account", "cd");
        fieldMapping.put("Account", "cd");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createMissedClaimsFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("TableId", "tableId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("File", "fileName");
        fieldMapping.put("Practice", "practice");
        fieldMapping.put("PatientName", "patientName");
        fieldMapping.put("gender", "gender");
        fieldMapping.put("MR_No", "medicalRecordNo");
        fieldMapping.put("Appt_Dt", "dos");
        fieldMapping.put("Check_In", "checkIn");
        fieldMapping.put("Check_Out", "checkOut");
        fieldMapping.put("Duration", "duration");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("memberId", "memberId");
        fieldMapping.put("dob", "dob");
        fieldMapping.put("Status", "appointmentStatus");
        fieldMapping.put("Claim_Id", "claimNo");
        fieldMapping.put("sentDate", "sentDate");
        fieldMapping.put("Claim_Date", "clmDate");
        fieldMapping.put("Comments", "comments");
        fieldMapping.put("CreatedBy", "createdBy");
        fieldMapping.put("CreatedDate", "createdDate");
        fieldMapping.put("UpdatedBy", "updatedBy");
        fieldMapping.put("UpdatedDate", "updatedDate");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createNoResponseClaimsFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("File", "fn");
        fieldMapping.put("ACCNT", "pataccno");
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("DOS_From", "fromdos");
        fieldMapping.put("DOS_To", "todos");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("P-Type", "pType");
        fieldMapping.put("CLM_Date", "recdate");
        fieldMapping.put("Patient", "lname,fname");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("Tax_ID", "taxid");
        fieldMapping.put("Insured_ID", "insid");
        fieldMapping.put("Err_Des", "errdes");
        fieldMapping.put("Practice", "facilityname");
        fieldMapping.put("Tid", "tid");
        fieldMapping.put("Rec_Date", "recdate");
        fieldMapping.put("PROJ", "coveredAmount");
        fieldMapping.put("Dob", "dateOfBirth");
        fieldMapping.put("Paid", "paid");
        fieldMapping.put("Percent", "percentage");
        fieldMapping.put("Status", "status");
        fieldMapping.put("TKT", "ticket_id");
        fieldMapping.put("Activity", "actionCode");
        fieldMapping.put("CSV", "categoryCode,categoryCodeDescription");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("DTC", "dayToClaim");
        fieldMapping.put("Action_By", "action_taken_by");
        fieldMapping.put("AGD", "agingDays");
        fieldMapping.put("LTD", "lastTouchedDays");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createReversalClaimsFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("Status", "status");
        fieldMapping.put("ACCNT", "payee");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("COV", "coveredAmount");
        fieldMapping.put("D_Status", "denialstatus");
        fieldMapping.put("Rec_Date", "claimDate");
        fieldMapping.put("DOS", "dateOfService");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("File", "fn");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("Patient", "patient");
        fieldMapping.put("EFT", "eft");
        fieldMapping.put("Payor_ICN", "payericn");
        fieldMapping.put("PR", "patientres");
        fieldMapping.put("CR_Date", "recdate");
        fieldMapping.put("Ticket_Id", "ticket_id");
        fieldMapping.put("Acted_By", "actedby");
        fieldMapping.put("REN_PROV", "rendproid");
        fieldMapping.put("Elapsed", "difference");
        fieldMapping.put("Action Code", "actiontaken");
        fieldMapping.put("Action Taken By", "action_taken_by");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("Reason_Code", "reasonCode");
        fieldMapping.put("SuggestionData", "suggestionList");
        fieldMapping.put("Ticket History", "ticketHistoryList");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createMlFeeScheduleFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("TableId", "tableId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("PayorName", "payor");
        fieldMapping.put("PLAN", "plan");
        fieldMapping.put("CFI", "cfiType");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("Units", "units");
        fieldMapping.put("Claims", "noOfClaims");
        fieldMapping.put("Total", "totalCoverageAmount");
        fieldMapping.put("AVG", "averageCoverageAmount");
        fieldMapping.put("Con_Fee", "contractedValue");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createProjectedRevenueFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("ACCOUNT", "account");
        fieldMapping.put("CLAIM_NO", "claimNumber");
        fieldMapping.put("CLAIM_STATUS", "claimStatus");
        fieldMapping.put("CHARGE_AMOUNT", "chargeamt");
        fieldMapping.put("PATIENT_NAME", "patientName");
        fieldMapping.put("PAYOR", "payor");
        fieldMapping.put("PLAN", "plan");
        fieldMapping.put("CFI", "cfiType");
        fieldMapping.put("DOS_FROM", "dosFrom");
        fieldMapping.put("DOS_TO", "dosTo");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("UNITS", "units");
        fieldMapping.put("PROJ_REV", "projectedRevenue");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createKnowledgeBaseFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("TID", "tableId");
        fieldMapping.put("CATEGORY", "category");
        fieldMapping.put("TITLE", "title");
        fieldMapping.put("STATE", "state");
        fieldMapping.put("PROCEDURECODE", "cptCode");
        fieldMapping.put("PAYOR", "insuranceName");
        fieldMapping.put("PLAN", "plan");
        fieldMapping.put("WEBSITE", "website");
        fieldMapping.put("CONTACT", "contact");
        fieldMapping.put("SOFTWARE_NAME", "softwareName");
        fieldMapping.put("SOFTWARE_TYPE", "softwareType");
        fieldMapping.put("FILE", "file");
        fieldMapping.put("INSTRUCTION", "instruction");
        fieldMapping.put("CREATED_BY", "createdBy");
        fieldMapping.put("CREATED_DATE", "createdDate");
        fieldMapping.put("UPDATED_BY", "updatedBy");
        fieldMapping.put("UPDATED_DATE", "updatedDate");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createDenialRulesMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("ID", "ruleId");
        fieldMapping.put("RULE_NAME", "ruleName");
        fieldMapping.put("PRACTICE", "practiceName");
        fieldMapping.put("SUGGESTION", "suggestName");
        fieldMapping.put("CREATED_BY", "createdUser");
        fieldMapping.put("CREATED_DT", "createdDate");
        fieldMapping.put("STATUS", "status");
        fieldMapping.put("UPDATED_BY", "updatedUser");
        fieldMapping.put("UPDATED_DT", "updatedDate");
        fieldMapping.put("RULE_TYPE", "ruleType");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createClaimRulesMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("ID", "ruleId");
        fieldMapping.put("RULE_NAME", "ruleName");
        fieldMapping.put("PRACTICE", "practiceName");
        fieldMapping.put("SUGGESTION", "suggestName");
        fieldMapping.put("CREATED_BY", "createdUser");
        fieldMapping.put("CREATED_DT", "createdDate");
        fieldMapping.put("STATUS", "status");
        fieldMapping.put("UPDATED_BY", "updatedUser");
        fieldMapping.put("UPDATED_DT", "updatedDate");
        fieldMapping.put("RULE_TYPE", "ruleType");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createClaimDetailViewFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("File", "fn");
        fieldMapping.put("Claim #", "claimno");
        fieldMapping.put("Line Item", "line_item_no");
        fieldMapping.put("DOS", "dos");
        fieldMapping.put("Desc", "code_mode|sdescr");
        fieldMapping.put("Unit", "unit_serv_paid");
        fieldMapping.put("Charge", "line_charge");
        fieldMapping.put("Paid", "paid");
        fieldMapping.put("Adj", "type_of_adjustment");
        fieldMapping.put("Reason", "reasoncode1|reasoncode2|reasoncode3|reasoncode4|reasoncode5");
        fieldMapping.put("Adj Amt", "adjamt1|adjamt2|adjamt3|adjamt4|adjamt5|adjamt6");
        fieldMapping.put("Covered", "amtamount");
        fieldMapping.put("Remark", "remarkcode1|remarkcode2|remarkcode3|remarkcode4");
        fieldMapping.put("Desc", "code_mode|descr");
        fieldMapping.put("Reason", "sreasoncode|sreasoncode1|sreasoncode2|sreasoncode3|sreasoncode4|sreasoncode5");
        fieldMapping.put("Remark", "remarkcode1|remarkcode2|remarkcode3|remarkcode4");
        fieldMapping.put("Adj", "typesegment");
        fieldMapping.put("Suggestion", "suggestionList");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createClaimRequestFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Tid", "tid");
        fieldMapping.put("Account", "accountant");
        fieldMapping.put("Claim No", "claimNumber");
        fieldMapping.put("Batch Id", "batchId");
        fieldMapping.put("Charge", "charge");
        fieldMapping.put("Patient", "patientName");
        fieldMapping.put("FromDos", "fromDos");
        fieldMapping.put("ToDos", "toDos");
        fieldMapping.put("Payor[837]", "payorId");
        fieldMapping.put("payor[276]", "payor");
        fieldMapping.put("Check", "checkNumber");
        fieldMapping.put("Do_Stat", "statusDate");
        fieldMapping.put("St_Cat", "statusCategory");
        fieldMapping.put("Code", "statusCode");
        fieldMapping.put("St_Desc", "codeDescription");
        fieldMapping.put("PaidAmt", "paidAmount");
        fieldMapping.put("Cat_Desc", "");
        fieldMapping.put("Check Date", "");
        fieldMapping.put("Status", "status");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createCoveredUnpaidClaimsFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("Status", "status");
        fieldMapping.put("ACCNT", "payee");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("COV", "coveredAmount");
        fieldMapping.put("D_Status", "denialstatus");
        fieldMapping.put("Rec_Date", "claimDate");
        fieldMapping.put("DOS", "dateOfService");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("File", "fn");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("Patient", "patient");
        fieldMapping.put("EFT", "eft");
        fieldMapping.put("Payor_ICN", "payericn");
        fieldMapping.put("PR", "patientres");
        fieldMapping.put("CR_Date", "recdate");
        fieldMapping.put("Ticket_Id", "ticket_id");
        fieldMapping.put("Acted_By", "actedby");
        fieldMapping.put("REN_PROV", "rendproid");
        fieldMapping.put("Elapsed", "difference");
        fieldMapping.put("Action Code", "actiontaken");
        fieldMapping.put("Action Taken By", "action_taken_by");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("Reason_Code", "reasonCode");
        fieldMapping.put("SuggestionData", "suggestionList");
        fieldMapping.put("Ticket History", "ticketHistoryList");
        fieldMapping.put("Flag", "paymentStatus");
        fieldMapping.put("LTD", "ticketElapsed");
        fieldMapping.put("DOB", "dateOfBirth");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createUnderPaidClaimsFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("File", "fn");
        fieldMapping.put("EFT", "eft");
        fieldMapping.put("Claim", "claimno");
        fieldMapping.put("Payor_ICN", "payericn");
        fieldMapping.put("CHK_Date", "eftdate");
        fieldMapping.put("C_Status", "claimstatus");
        fieldMapping.put("Payor", "payer");
        fieldMapping.put("Payee", "payee");
        fieldMapping.put("Charge", "chargeamt");
        fieldMapping.put("PROJ", "coveredAmount");
        fieldMapping.put("Paid", "paidamt");
        fieldMapping.put("PR", "patientres");
        fieldMapping.put("CR_Date", "recdate");
        fieldMapping.put("Patient", "lname,fname");
        fieldMapping.put("TID", "tid");
        fieldMapping.put("ACCNT", "account_no");
        fieldMapping.put("MemberId", "");
        fieldMapping.put("Dos", "dateOfService");
        fieldMapping.put("TKT", "ticketId");
        fieldMapping.put("Status", "status");
        fieldMapping.put("Rec_Date", "receiveddate");
        fieldMapping.put("Flag", "paymentStatus");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("CFI", "cfi");
        fieldMapping.put("Allowed", "allowedAmount");
        fieldMapping.put("FeeDiff", "feeDifference");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Date", "createdDate");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createDenialArFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "darId");
        fieldMapping.put("Account", "practiceName");
        fieldMapping.put("Claim No", "claimNo");
        fieldMapping.put("Dos", "dos");
        fieldMapping.put("AGD", "dayDifference");
        fieldMapping.put("Billed Amount", "billedAmount");
        fieldMapping.put("Patient Name", "patientName");
        fieldMapping.put("Payor", "insuranceName");
        fieldMapping.put("Last Activity", "lastActivity");
        fieldMapping.put("Prov", "providerName");
        fieldMapping.put("Den Cap Date", "denialCaptureDate");
        fieldMapping.put("Assigned To", "assignedToName");
        fieldMapping.put("Upload By", "assignedByName");
        fieldMapping.put("Ass Date", "assignedDate");
        fieldMapping.put("Comments", "comments");
        fieldMapping.put("FU Date", "followUpDate");
        fieldMapping.put("Status", "darStatus");
        fieldMapping.put("LTD", "lastTouchedDay");
        fieldMapping.put("DTC", "daysToClaim");
        fieldMapping.put("Action Code", "actionCode");
        fieldMapping.put("Days", "days");
        fieldMapping.put("Aging", "aging");
        fieldMapping.put("PVDR", "pvdr");
        fieldMapping.put("Payments", "payments");
        fieldMapping.put("Adj", "adjustment");
        fieldMapping.put("Withheld", "withHeld");
        fieldMapping.put("Balance", "balance");
        fieldMapping.put("Acc No", "accountNo");
        fieldMapping.put("Guarantor", "guarantorName");
        fieldMapping.put("Job Type", "jobType");
        fieldMapping.put("Policy No", "policyNo");
        fieldMapping.put("Patient Dob", "patientDob");
        fieldMapping.put("Billed CPT", "billedCpt");
        fieldMapping.put("CheckEft / No", "checkEft");
        fieldMapping.put("Check Date", "checkDate");
        fieldMapping.put("ANSI Code", "ansiCode");
        fieldMapping.put("Denied CPT", "deniedCpt");
        fieldMapping.put("Job Id", "jobId");
        fieldMapping.put("Tag", "darTag");
        fieldMapping.put("Remark Code", "remarksCode");
        fieldMapping.put("D-Aging", "denialAging");
        fieldMapping.put("AR History", "arHistory");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createProspectPatientInfoFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("TID", "tid");
        fieldMapping.put("Patient", "patient");
        fieldMapping.put("DOB", "dob");
        fieldMapping.put("City", "city");
        fieldMapping.put("STATUS", "status");
        fieldMapping.put("Zip", "zip");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("Plan", "plan");
        fieldMapping.put("Last DOS", "lastDos");
        fieldMapping.put("Rend Pro", "rendPro");
        fieldMapping.put("Payor Type", "payorType");
        fieldMapping.put("Last Visit", "lastVisit");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createProspectPatientFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("TID", "tid");
        fieldMapping.put("PATIENT", "patient");
        fieldMapping.put("DOB", "dob");
        fieldMapping.put("PLAN", "plan");
        fieldMapping.put("ACCOUNT", "ftpuser");
        fieldMapping.put("PAYOR", "payor");
        fieldMapping.put("DAYS", "days");
        fieldMapping.put("RULE", "ruleName");
        fieldMapping.put("LAST DOS", "lastDos");
        fieldMapping.put("STATUS", "status");
        fieldMapping.put("CITY", "city");
        fieldMapping.put("ZIP", "zip");
        fieldMapping.put("REND_PRO", "rendPro");
        fieldMapping.put("RULE TYPE", "ruleType");
        fieldMapping.put("Payor Type", "payorType");
        fieldMapping.put("Last Visit", "lastVisit");
        fieldMapping.put("CREATED BY", "createdByName");
        fieldMapping.put("CREATED DATE", "createdDate");
        fieldMapping.put("UPDATED BY", "updatedByName");
        fieldMapping.put("UPDATED DATE", "updatedDate");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createUserMasterFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("User Id", "user_id");
        fieldMapping.put("User Name", "username");
        fieldMapping.put("Name", "name");
        fieldMapping.put("user Type", "user_type");
        fieldMapping.put("Practice", "practice");
        fieldMapping.put("Provider", "Provider");
        fieldMapping.put("Status", "active");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createGenericFeeScheduleFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "tid");
        fieldMapping.put("CPT", "procedureCode");
        fieldMapping.put("AVG Fee Value", "averageFeeValue");
        fieldMapping.put("Created Date", "createdDate");
        fieldMapping.put("Updated Date", "updatedDate");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEobPaymentFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("pmd Id", "ecwPaymentId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("Check No", "checkNo");
        fieldMapping.put("Chk Date", "checkDate");
        fieldMapping.put("Chk Amt", "checkAmount");
        fieldMapping.put("ecw pmt id", "paymentId");
        fieldMapping.put("Rec Dt", "paymentReceivedDate");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Date", "createdDate");
        fieldMapping.put("pmt_from", "paymentFrom");
        fieldMapping.put("File Name", "fileName");
        fieldMapping.put("Status", "status");
        fieldMapping.put("Imported By", "updateBy");
        fieldMapping.put("Imported Date", "updateDate");
        fieldMapping.put("Job Id", "eobJobId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEobAdvisoryFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Adv Id", "advisoryId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("Check No", "checkNo");
        fieldMapping.put("Claim No", "claimNo");
        fieldMapping.put("Claim Status", "claimStatus");
        fieldMapping.put("DOS", "dos");
        fieldMapping.put("Patient Name", "patientName");
        fieldMapping.put("Billed", "billed");
        fieldMapping.put("Allowed", "allowed");
        fieldMapping.put("Deduct", "deduct");
        fieldMapping.put("Co-ins", "coins");
        fieldMapping.put("Co-pay", "copay");
        fieldMapping.put("Paid", "paid");
        fieldMapping.put("Adj", "adj");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Dt", "createdDate");
        fieldMapping.put("File Name", "fileName");
        fieldMapping.put("Pmt ID", "ecwPaymentId");
        fieldMapping.put("Job Id", "eobJobId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEobPostingFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Post Id", "postingId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("Check No", "checkNo");
        fieldMapping.put("Claim No", "claimNo");
        fieldMapping.put("Claim Status", "claimStatus");
        fieldMapping.put("DOS", "dos");
        fieldMapping.put("Code", "code");
        fieldMapping.put("Billed", "billed");
        fieldMapping.put("Paid", "paid");
        fieldMapping.put("Allowed", "allowed");
        fieldMapping.put("Deduct", "deduct");
        fieldMapping.put("Co-ins", "coins");
        fieldMapping.put("Co-pay", "copay");
        fieldMapping.put("Unit", "units");
        fieldMapping.put("Adj", "adj");
        fieldMapping.put("Reason Code", "reasonCode");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Dt", "createdDate");
        fieldMapping.put("File Name", "fileName");
        fieldMapping.put("Adv Id", "advisoryId");
        fieldMapping.put("Job Id", "eobJobId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEobPaymentScrapingFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("pmd Id", "ecwPaymentId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("Check No", "checkNo");
        fieldMapping.put("Chk Date", "checkDate");
        fieldMapping.put("Chk Amt", "checkAmount");
        fieldMapping.put("ecw pmt id", "paymentId");
        fieldMapping.put("Rec Dt", "paymentReceivedDate");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Date", "createdDate");
        fieldMapping.put("pmt_from", "paymentFrom");
        fieldMapping.put("File Name", "fileName");
        fieldMapping.put("Status", "status");
        fieldMapping.put("Imported By", "updateBy");
        fieldMapping.put("Imported Date", "updateDate");
        fieldMapping.put("Job Id", "eobJobId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEobAdvisoryScrapingFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Adv Id", "advisoryId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("Check No", "checkNo");
        fieldMapping.put("Claim No", "claimNo");
        fieldMapping.put("Claim Status", "claimStatus");
        fieldMapping.put("DOS", "dos");
        fieldMapping.put("Patient Name", "patientName");
        fieldMapping.put("Billed", "billed");
        fieldMapping.put("Allowed", "allowed");
        fieldMapping.put("Deduct", "deduct");
        fieldMapping.put("Co-ins", "coins");
        fieldMapping.put("Co-pay", "copay");
        fieldMapping.put("Paid", "paid");
        fieldMapping.put("Adj", "adj");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Dt", "createdDate");
        fieldMapping.put("File Name", "fileName");
        fieldMapping.put("Pmt ID", "ecwPaymentId");
        fieldMapping.put("Job Id", "eobJobId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEobPostingScrapingFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Post Id", "postingId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("Check No", "checkNo");
        fieldMapping.put("Claim No", "claimNo");
        fieldMapping.put("Claim Status", "claimStatus");
        fieldMapping.put("DOS", "dos");
        fieldMapping.put("Code", "code");
        fieldMapping.put("Billed", "billed");
        fieldMapping.put("Paid", "paid");
        fieldMapping.put("Allowed", "allowed");
        fieldMapping.put("Deduct", "deduct");
        fieldMapping.put("Co-ins", "coins");
        fieldMapping.put("Co-pay", "copay");
        fieldMapping.put("Unit", "units");
        fieldMapping.put("Adj", "adj");
        fieldMapping.put("Reason Code", "reasonCode");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Dt", "createdDate");
        fieldMapping.put("File Name", "fileName");
        fieldMapping.put("Adv Id", "advisoryId");
        fieldMapping.put("Job Id", "eobJobId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createOpenProblemFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "oplId");
        fieldMapping.put("Practice", "practice");
        fieldMapping.put("Provider", "provider");
        fieldMapping.put("Patient", "lastName,firstName");
        fieldMapping.put("Dob", "dob");
        fieldMapping.put("Dos", "dos");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("MemberId", "memberId");
        fieldMapping.put("ProblemList", "problemList");
        fieldMapping.put("Problem", "problem");
        fieldMapping.put("OtherProblem", "otherProblem");
        fieldMapping.put("StatusId", "statusId");
        fieldMapping.put("Status", "status");
        fieldMapping.put("CreatedById", "createdById");
        fieldMapping.put("CreatedBy", "createdBy");
        fieldMapping.put("CreatedDate", "createdDate");
        fieldMapping.put("AssignedToId", "assignedToId");
        fieldMapping.put("AssignedTo", "assignedTo");
        fieldMapping.put("AssignedDate", "assignedDate");
        fieldMapping.put("Elapsed", "dateYear");
        fieldMapping.put("StatusId", "statusId");
        fieldMapping.put("Flag", "flag");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEvQueryFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Table Id", "tableId");
        fieldMapping.put("Practice Id", "practiceid");
        fieldMapping.put("Practice", "practicename");
        fieldMapping.put("Default", "default_group");
        fieldMapping.put("Optional", "optional_group");
        fieldMapping.put("Hidden", "hidden_group");
        fieldMapping.put("Created Date", "created_date");
        fieldMapping.put("Created by", "createdbyname");
        fieldMapping.put("Updated Date", "updated_date");
        fieldMapping.put("Updated by", "updatedbyname");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEvResultFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Table Id", "tableId");
        fieldMapping.put("Practice Id", "practiceid");
        fieldMapping.put("Practice", "practicename");
        fieldMapping.put("Default", "default_group");
        fieldMapping.put("Optional", "optional_group");
        fieldMapping.put("Hidden", "hidden_group");
        fieldMapping.put("Created Date", "created_date");
        fieldMapping.put("Created by", "createdbyname");
        fieldMapping.put("Updated Date", "updated_date");
        fieldMapping.put("Updated by", "updatedbyname");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createAliasFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Table Id", "tid");
        fieldMapping.put("Practice", "practicename");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("Alias", "alias");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createFavoritesFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Table Id", "favid");
        fieldMapping.put("Practice", "practiceName");
        fieldMapping.put("Payor", "payorname");
        fieldMapping.put("State", "state");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createInclusionFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "id");
        fieldMapping.put("Practice", "practice");
        fieldMapping.put("Provider", "provider");
        fieldMapping.put("Payor Id", "payorId");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("ServiceId", "serviceId");
        fieldMapping.put("ServiceType", "serviceType");
        fieldMapping.put("Coverage Code", "columnId");
        fieldMapping.put("ColumnName", "columnName");
        fieldMapping.put("Plan", "keyphraseOne");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createNetworkFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "id");
        fieldMapping.put("Practice", "practice");
        fieldMapping.put("Provider", "provider");
        fieldMapping.put("Payor Id", "payorId");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("ServiceId", "serviceId");
        fieldMapping.put("ServiceType", "serviceType");
        fieldMapping.put("Coverage Code", "columnId");
        fieldMapping.put("ColumnName", "columnName");
        fieldMapping.put("Plan", "keyphraseOne");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createExclusionFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "id");
        fieldMapping.put("Practice", "practice");
        fieldMapping.put("Provider", "provider");
        fieldMapping.put("Payor Id", "payorId");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("ServiceId", "serviceId");
        fieldMapping.put("ServiceType", "serviceType");
        fieldMapping.put("Coverage Code", "columnId");
        fieldMapping.put("ColumnName", "columnName");
        fieldMapping.put("Plan", "keyphraseOne");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createEvConfigNpiFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "tid");
        fieldMapping.put("Practice", "practice");
        fieldMapping.put("Provider", "provider");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("NPI", "groupNpi");
        fieldMapping.put("Created DT", "createdDate");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Updated DT", "updatedDate");
        fieldMapping.put("Updated By", "updatedBy");
        fieldMapping.put("Flag", "flag");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createExcelConfigMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Practice", "practice");
        fieldMapping.put("Columns", "selectedColumns");
        fieldMapping.put("CONFIGURED By", "createdByUser");
        fieldMapping.put("Date", "createdDate");
        fieldMapping.put("Status", "status");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createAuthConfigMLFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("TID", "tid");
        fieldMapping.put("Claim Id", "claimId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("Plan", "plan");
        fieldMapping.put("Billing NPI", "billingNpi");
        fieldMapping.put("DOB", "dob");
        fieldMapping.put("MemberId", "memberId");
        fieldMapping.put("CFI", "cfi");
        fieldMapping.put("CFI Desc", "cfiDesc");
        fieldMapping.put("CPT", "cpt");
        fieldMapping.put("Reason Code", "reasonCode");
        fieldMapping.put("Claim No", "claimNo");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createDenialConfigMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Id", "tableId");
        fieldMapping.put("Entity", "entity");
        fieldMapping.put("Account", "payee");
        fieldMapping.put("Payor", "payor");
        fieldMapping.put("Charge", "chargeValue");
        fieldMapping.put("Procedure Code", "procedureCode");
        fieldMapping.put("Reason Code", "reasonCode");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Date", "createdDate");
        fieldMapping.put("Updated By", "updatedBy");
        fieldMapping.put("Updated Date", "updatedDate");
        fieldMapping.put("Flag", "flag");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createSettledEHRClaimsFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("ERA Claim Id", "eraClaimId");
        fieldMapping.put("Account", "account");
        fieldMapping.put("Claim No", "claimno");
        fieldMapping.put("837 Status", "status837");
        fieldMapping.put("835 Status", "status835");
        fieldMapping.put("Created By", "createdBy");
        fieldMapping.put("Created Date", "createdDate");
        fieldMapping.put("File Name", "filename");
        fieldMapping.put("Status", "status");
        fieldMapping.put("Updated By", "updateBy");
        fieldMapping.put("Updated Date", "updateDate");
        fieldMapping.put("ERA Job Id", "eraJobId");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createTeamUserMappingFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("User", "userName");
        fieldMapping.put("User Type", "userType");
        fieldMapping.put("Team", "teamName");
        fieldMapping.put("Entity", "entityName");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createTeamPracticeMappingFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Practice", "practiceName");
        fieldMapping.put("Team", "teamName");
        fieldMapping.put("Entity", "entityName");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createAuditLogFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Log Id", "logId");
        fieldMapping.put("User Name", "userName");
        fieldMapping.put("Affected By", "affectedUser");
        fieldMapping.put("User Type", "userType");
        fieldMapping.put("Log Type", "auditLogType");
        fieldMapping.put("Performed By", "performedBy");
        fieldMapping.put("Log Time", "eventTime");
        fieldMapping.put("IP Address", "ipAddress");
        fieldMapping.put("Browser Name", "browserName");
        return fieldMapping;
    }

    private static LinkedHashMap<String, String> createExportLogFieldMapping() {
        LinkedHashMap<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("Report Id", "reportId");
        fieldMapping.put("Report Type", "reportType");
        fieldMapping.put("Performed By", "performedBy");
        fieldMapping.put("Export Time", "eventTime");
        fieldMapping.put("Records Count", "recordsCount");
        fieldMapping.put("Report Format", "reportFormat");
        return fieldMapping;
    }

}
