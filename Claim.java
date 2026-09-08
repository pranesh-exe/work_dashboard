package com.billingparadise.web.beans;

import java.util.List;

public class Claim {

    /**
     * @return the lineitem
     */
    public List<ClaimLineItem> getLineitem() {
        return lineitem;
    }

    /**
     * @param lineitem the lineitem to set
     */
    public void setLineitem(List<ClaimLineItem> lineitem) {
        this.lineitem = lineitem;
    }
    private int tid;
    private String fn;
    private String claimno;
    private String claimstatus;
    private String status;
    private String chargeamt;
    private String paidamt;
    private String patientres;
    private String payericn;
    private String lname;
    private String fname;
    private String recdate;
    private String taxid;
    private String patient;
    private String coveramt;
    private String payer;
    private String payee;
    private String spayer;
    private String spayee;
    private String cfi;
    private String scfi;
    private String insid;
    private String inslname;
    private String insfname;
    private String rendproid;
    private String rendprolname;
    private String rendprofname;
    private String suggestion;
    private String suggby;
    private String actiontaken;
    private String actedby;
    private String denialstatus;
    private String pataccno;
    private String fromdos;
    private String todos;
    private String mastervendor;
    private String stalinid;
    private String receiveddate;
    private String printclaim;
    private String errdes;
    private String eft;
    private String rrecdate;
    private String desc;
    private String eftdate;
    private String seftdate;
    private String claimcount;
    private String paid;
    private String pr;
    private String statusdes;
    private int difference;
    private int ticket_id;
    private String action_taken;
    private String action_taken_by;
    private String service_facility_npi;
    private String facilityname;
    private List<ClaimLineItem> lineitem;
    private String assign_to;
    private String covered;
    private String flag;
    private List<RuleEngineData> suggestionList;
    private String filename;
    private String billingNpi;
    private int claimCount;
    private String account_no;
    private String velocity;
    private String patmemid;
    private int daysDifference;
    private int assignToId;
    private String claimDate;
    private String procedureCode;
    private String reasonCode;
    private String dateOfService;
    private String comments;
    private String claimAdjustmentGroupReason;
    private String adjustmentAmount;
    private String rxDate;
    private String categoryCode;
    private String categoryCodeDescription;
    private String statusCode;
    private String statusCodeDescription;
    private String secondCategoryCode;
    private String secondCategoryCodeDescription;
    private String secondStatusCode;
    private String secondStatusCodeDescription;
    private String dateOfStatus;
    private String chkDate;
    private String crDate;
    private String clmDate;
    private String payorName;
    private String dosFrom;
    private String dosTo;
    private String totalCharge;
    private String dateOfBirth;
    private String payorId;
    private int claimStatusId;
    private boolean noteAdded;
    private String changeFieldIndex;
    private String changeField;
    private int actionTakenId;
    private String actionCode;
    private String lineItemChangeField;
    private String lineItemDisplayName;
    private Double coveredAmount;
    private Double allowedAmount;
    private Double feeDifference;
    private int percentage;
    private boolean errorAdded;
    private boolean historyAvailable;
    private int claimId;
    private boolean missedClaim;
    private Long ticketId;
    private int statusId;
    private List<TicketDetail> ticketHistoryList;
    private String headerId;
    private String paymentStatus;
    private String createdBy;
    private String createdDate;
    private int flagId;
    private int claimNoCount;
    private int trackerFlag;
    private String recentAssigned;
    private String ticketElapsed;
    private int claimIndex;
    private int claimHeaderId;
    private String insuredSex;
    private String insuredAge;
    private int dayToClaim;
    private String denialIds;
    private String claimIds;
    private int lastTouchedDays;
    private int agingDays;
    private String renderingProvider;
    private String pType;
    private Long fileId;
    private String recordStatus;
    private String interChangeDate;
    private String fileStatus;
    private Long header837Id;
    private List<String> fileNames;
    private List<String> acctNames;
    private boolean hasCallHistory;

    public int getClaimCount() {
        return claimCount;
    }

    public void setClaimCount(int claimCount) {
        this.claimCount = claimCount;
    }

    public String getBillingNpi() {
        return billingNpi;
    }

    public void setBillingNpi(String billingNpi) {
        this.billingNpi = billingNpi;
    }

    public String getClaimstatus() {
        return claimstatus;
    }

    public void setClaimstatus(String claimstatus) {
        this.claimstatus = claimstatus;
    }

    public String getTaxid() {
        return taxid;
    }

    public void setTaxid(String taxid) {
        this.taxid = taxid;
    }

    public int getTid() {
        return tid;
    }

    public String getFn() {
        return fn;
    }

    public String getClaimno() {
        return claimno;
    }

    public String getStatus() {
        return status;
    }

    public String getChargeamt() {
        return chargeamt;
    }

    public String getPaidamt() {
        return paidamt;
    }

    public String getPatientres() {
        return patientres;
    }

    public String getPayericn() {
        return payericn;
    }

    public String getLname() {
        return lname;
    }

    public String getFname() {
        return fname;
    }

    public String getRecdate() {
        return recdate;
    }

    public String getCoveramt() {
        return coveramt;
    }

    public void setTid(int tid) {
        this.tid = tid;
    }

    public void setFn(String fn) {
        this.fn = fn;
    }

    public void setClaimno(String claimno) {
        this.claimno = claimno;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setChargeamt(String chargeamt) {
        this.chargeamt = chargeamt;
    }

    public void setPaidamt(String paidamt) {
        this.paidamt = paidamt;
    }

    public void setPatientres(String patientres) {
        this.patientres = patientres;
    }

    public void setPayericn(String payericn) {
        this.payericn = payericn;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public void setRecdate(String recdate) {
        this.recdate = recdate;
    }

    public void setCoveramt(String coveramt) {
        this.coveramt = coveramt;
    }

    public String getPayer() {
        return payer;
    }

    public String getPayee() {
        return payee;
    }

    public void setPayer(String payer) {
        this.payer = payer;
    }

    public void setPayee(String payee) {
        this.payee = payee;
    }

    public String getCfi() {
        return cfi;
    }

    public void setCfi(String cfi) {
        this.cfi = cfi;
    }

    public String getSpayer() {
        return spayer;
    }

    public String getSpayee() {
        return spayee;
    }

    public String getScfi() {
        return scfi;
    }

    public void setSpayer(String spayer) {
        this.spayer = spayer;
    }

    public void setSpayee(String spayee) {
        this.spayee = spayee;
    }

    public void setScfi(String scfi) {
        this.scfi = scfi;
    }

    public String getInsid() {
        return insid;
    }

    public String getInslname() {
        return inslname;
    }

    public String getInsfname() {
        return insfname;
    }

    public String getRendproid() {
        return rendproid;
    }

    public String getRendprolname() {
        return rendprolname;
    }

    public String getRendprofname() {
        return rendprofname;
    }

    public void setInsid(String insid) {
        this.insid = insid;
    }

    public void setInslname(String inslname) {
        this.inslname = inslname;
    }

    public void setInsfname(String insfname) {
        this.insfname = insfname;
    }

    public void setRendproid(String rendproid) {
        this.rendproid = rendproid;
    }

    public void setRendprolname(String rendprolname) {
        this.rendprolname = rendprolname;
    }

    public void setRendprofname(String rendprofname) {
        this.rendprofname = rendprofname;
    }

    public String getSuggestion() {
        return suggestion;
    }

    public String getSuggby() {
        return suggby;
    }

    public String getActiontaken() {
        return actiontaken;
    }

    public String getActedby() {
        return actedby;
    }

    public String getDenialstatus() {
        return denialstatus;
    }

    public void setSuggestion(String suggestion) {
        this.suggestion = suggestion;
    }

    public void setSuggby(String suggby) {
        this.suggby = suggby;
    }

    public void setActiontaken(String actiontaken) {
        this.actiontaken = actiontaken;
    }

    public void setActedby(String actedby) {
        this.actedby = actedby;
    }

    public void setDenialstatus(String denialstatus) {
        this.denialstatus = denialstatus;
    }

    public String getPataccno() {
        return pataccno;
    }

    public String getFromdos() {
        return fromdos;
    }

    public String getTodos() {
        return todos;
    }

    public String getMastervendor() {
        return mastervendor;
    }

    public String getStalinid() {
        return stalinid;
    }

    public String getReceiveddate() {
        return receiveddate;
    }

    public String getPrintclaim() {
        return printclaim;
    }

    public String getErrdes() {
        return errdes;
    }

    public void setPataccno(String pataccno) {
        this.pataccno = pataccno;
    }

    public void setFromdos(String fromdos) {
        this.fromdos = fromdos;
    }

    public void setTodos(String todos) {
        this.todos = todos;
    }

    public void setMastervendor(String mastervendor) {
        this.mastervendor = mastervendor;
    }

    public void setStalinid(String stalinid) {
        this.stalinid = stalinid;
    }

    public void setReceiveddate(String receiveddate) {
        this.receiveddate = receiveddate;
    }

    public void setPrintclaim(String printclaim) {
        this.printclaim = printclaim;
    }

    public void setErrdes(String errdes) {
        this.errdes = errdes;
    }

    public String getEft() {
        return eft;
    }

    public void setEft(String eft) {
        this.eft = eft;
    }

    public String getRrecdate() {
        return rrecdate;
    }

    public void setRrecdate(String rrecdate) {
        this.rrecdate = rrecdate;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getEftdate() {
        return eftdate;
    }

    public String getSeftdate() {
        return seftdate;
    }

    public void setEftdate(String eftdate) {
        this.eftdate = eftdate;
    }

    public void setSeftdate(String seftdate) {
        this.seftdate = seftdate;
    }

    public String getClaimcount() {
        return claimcount;
    }

    public String getPaid() {
        return paid;
    }

    public String getPr() {
        return pr;
    }

    public void setClaimcount(String claimcount) {
        this.claimcount = claimcount;
    }

    public void setPaid(String paid) {
        this.paid = paid;
    }

    public void setPr(String pr) {
        this.pr = pr;
    }

    public String getStatusdes() {
        return statusdes;
    }

    public void setStatusdes(String statusdes) {
        this.statusdes = statusdes;
    }

    public String getService_facility_npi() {
        return service_facility_npi;
    }

    public String getFacilityname() {
        return facilityname;
    }

    public void setService_facility_npi(String service_facility_npi) {
        this.service_facility_npi = service_facility_npi;
    }

    public void setFacilityname(String facilityname) {
        this.facilityname = facilityname;
    }

    public int getDifference() {
        return difference;
    }

    public int getTicket_id() {
        return ticket_id;
    }

    public void setDifference(int difference) {
        this.difference = difference;
    }

    public void setTicket_id(int ticket_id) {
        this.ticket_id = ticket_id;
    }

    public String getAction_taken() {
        return action_taken;
    }

    public String getAction_taken_by() {
        return action_taken_by;
    }

    public void setAction_taken(String action_taken) {
        this.action_taken = action_taken;
    }

    public void setAction_taken_by(String action_taken_by) {
        this.action_taken_by = action_taken_by;
    }

    public String getAssign_to() {
        return assign_to;
    }

    public void setAssign_to(String assign_to) {
        this.assign_to = assign_to;
    }

    public String getCovered() {
        return covered;
    }

    public void setCovered(String covered) {
        this.covered = covered;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public List<RuleEngineData> getSuggestionList() {
        return suggestionList;
    }

    public void setSuggestionList(List<RuleEngineData> suggestionList) {
        this.suggestionList = suggestionList;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public String getPatient() {
        return patient;
    }

    public void setPatient(String patient) {
        this.patient = patient;
    }

    public String getAccount_no() {
        return account_no;
    }

    public void setAccount_no(String account_no) {
        this.account_no = account_no;
    }

    public String getVelocity() {
        return velocity;
    }

    public void setVelocity(String velocity) {
        this.velocity = velocity;
    }

    public String getPatmemid() {
        return patmemid;
    }

    public void setPatmemid(String patmemid) {
        this.patmemid = patmemid;
    }

    public int getDaysDifference() {
        return daysDifference;
    }

    public void setDaysDifference(int daysDifference) {
        this.daysDifference = daysDifference;
    }

    public int getAssignToId() {
        return assignToId;
    }

    public void setAssignToId(int assignToId) {
        this.assignToId = assignToId;
    }

    public String getClaimDate() {
        return claimDate;
    }

    public void setClaimDate(String claimDate) {
        this.claimDate = claimDate;
    }

    public String getProcedureCode() {
        return procedureCode;
    }

    public void setProcedureCode(String procedureCode) {
        this.procedureCode = procedureCode;
    }

    public String getReasonCode() {
        return reasonCode;
    }

    public void setReasonCode(String reasonCode) {
        this.reasonCode = reasonCode;
    }

    public String getDateOfService() {
        return dateOfService;
    }

    public void setDateOfService(String dateOfService) {
        this.dateOfService = dateOfService;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getClaimAdjustmentGroupReason() {
        return claimAdjustmentGroupReason;
    }

    public void setClaimAdjustmentGroupReason(String claimAdjustmentGroupReason) {
        this.claimAdjustmentGroupReason = claimAdjustmentGroupReason;
    }

    public String getAdjustmentAmount() {
        return adjustmentAmount;
    }

    public void setAdjustmentAmount(String adjustmentAmount) {
        this.adjustmentAmount = adjustmentAmount;
    }

    public String getRxDate() {
        return rxDate;
    }

    public void setRxDate(String rxDate) {
        this.rxDate = rxDate;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getCategoryCodeDescription() {
        return categoryCodeDescription;
    }

    public void setCategoryCodeDescription(String categoryCodeDescription) {
        this.categoryCodeDescription = categoryCodeDescription;
    }

    public String getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(String statusCode) {
        this.statusCode = statusCode;
    }

    public String getStatusCodeDescription() {
        return statusCodeDescription;
    }

    public void setStatusCodeDescription(String statusCodeDescription) {
        this.statusCodeDescription = statusCodeDescription;
    }

    public String getDateOfStatus() {
        return dateOfStatus;
    }

    public void setDateOfStatus(String dateOfStatus) {
        this.dateOfStatus = dateOfStatus;
    }

    public String getSecondCategoryCode() {
        return secondCategoryCode;
    }

    public void setSecondCategoryCode(String secondCategoryCode) {
        this.secondCategoryCode = secondCategoryCode;
    }

    public String getSecondCategoryCodeDescription() {
        return secondCategoryCodeDescription;
    }

    public void setSecondCategoryCodeDescription(String secondCategoryCodeDescription) {
        this.secondCategoryCodeDescription = secondCategoryCodeDescription;
    }

    public String getSecondStatusCode() {
        return secondStatusCode;
    }

    public void setSecondStatusCode(String secondStatusCode) {
        this.secondStatusCode = secondStatusCode;
    }

    public String getSecondStatusCodeDescription() {
        return secondStatusCodeDescription;
    }

    public void setSecondStatusCodeDescription(String secondStatusCodeDescription) {
        this.secondStatusCodeDescription = secondStatusCodeDescription;
    }

    public String getChkDate() {
        return chkDate;
    }

    public void setChkDate(String chkDate) {
        this.chkDate = chkDate;
    }

    public String getCrDate() {
        return crDate;
    }

    public void setCrDate(String crDate) {
        this.crDate = crDate;
    }

    public String getClmDate() {
        return clmDate;
    }

    public void setClmDate(String clmDate) {
        this.clmDate = clmDate;
    }

    public String getPayorName() {
        return payorName;
    }

    public void setPayorName(String payorName) {
        this.payorName = payorName;
    }

    public String getDosFrom() {
        return dosFrom;
    }

    public void setDosFrom(String dosFrom) {
        this.dosFrom = dosFrom;
    }

    public String getDosTo() {
        return dosTo;
    }

    public void setDosTo(String dosTo) {
        this.dosTo = dosTo;
    }

    public String getTotalCharge() {
        return totalCharge;
    }

    public void setTotalCharge(String totalCharge) {
        this.totalCharge = totalCharge;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getPayorId() {
        return payorId;
    }

    public void setPayorId(String payorId) {
        this.payorId = payorId;
    }

    public int getClaimStatusId() {
        return claimStatusId;
    }

    public void setClaimStatusId(int claimStatusId) {
        this.claimStatusId = claimStatusId;
    }

    public boolean isNoteAdded() {
        return noteAdded;
    }

    public void setNoteAdded(boolean noteAdded) {
        this.noteAdded = noteAdded;
    }

    public String getChangeFieldIndex() {
        return changeFieldIndex;
    }

    public void setChangeFieldIndex(String changeFieldIndex) {
        this.changeFieldIndex = changeFieldIndex;
    }

    public String getChangeField() {
        return changeField;
    }

    public void setChangeField(String changeField) {
        this.changeField = changeField;
    }

    public int getActionTakenId() {
        return actionTakenId;
    }

    public void setActionTakenId(int actionTakenId) {
        this.actionTakenId = actionTakenId;
    }

    public String getActionCode() {
        return actionCode;
    }

    public void setActionCode(String actionCode) {
        this.actionCode = actionCode;
    }

    public String getLineItemChangeField() {
        return lineItemChangeField;
    }

    public void setLineItemChangeField(String lineItemChangeField) {
        this.lineItemChangeField = lineItemChangeField;
    }

    public String getLineItemDisplayName() {
        return lineItemDisplayName;
    }

    public void setLineItemDisplayName(String lineItemDisplayName) {
        this.lineItemDisplayName = lineItemDisplayName;
    }

    public Double getCoveredAmount() {
        return coveredAmount;
    }

    public void setCoveredAmount(Double coveredAmount) {
        this.coveredAmount = coveredAmount;
    }

    public Double getAllowedAmount() {
        return allowedAmount;
    }

    public void setAllowedAmount(Double allowedAmount) {
        this.allowedAmount = allowedAmount;
    }

    public Double getFeeDifference() {
        return feeDifference;
    }

    public void setFeeDifference(Double feeDifference) {
        this.feeDifference = feeDifference;
    }

    public int getPercentage() {
        return percentage;
    }

    public void setPercentage(int percentage) {
        this.percentage = percentage;
    }

    public boolean isErrorAdded() {
        return errorAdded;
    }

    public void setErrorAdded(boolean errorAdded) {
        this.errorAdded = errorAdded;
    }

    public boolean isHistoryAvailable() {
        return historyAvailable;
    }

    public void setHistoryAvailable(boolean historyAvailable) {
        this.historyAvailable = historyAvailable;
    }

    public int getClaimId() {
        return claimId;
    }

    public void setClaimId(int claimId) {
        this.claimId = claimId;
    }

    public boolean isMissedClaim() {
        return missedClaim;
    }

    public void setMissedClaim(boolean missedClaim) {
        this.missedClaim = missedClaim;
    }

    public Long getTicketId() {
        return ticketId;
    }

    public void setTicketId(Long ticketId) {
        this.ticketId = ticketId;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public List<TicketDetail> getTicketHistoryList() {
        return ticketHistoryList;
    }

    public void setTicketHistoryList(List<TicketDetail> ticketHistoryList) {
        this.ticketHistoryList = ticketHistoryList;
    }

    public String getHeaderId() {
        return headerId;
    }

    public void setHeaderId(String headerId) {
        this.headerId = headerId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(String createdDate) {
        this.createdDate = createdDate;
    }

    public int getFlagId() {
        return flagId;
    }

    public void setFlagId(int flagId) {
        this.flagId = flagId;
    }

    public int getClaimNoCount() {
        return claimNoCount;
    }

    public void setClaimNoCount(int claimNoCount) {
        this.claimNoCount = claimNoCount;
    }

    public int getTrackerFlag() {
        return trackerFlag;
    }

    public void setTrackerFlag(int trackerFlag) {
        this.trackerFlag = trackerFlag;
    }

    public String getRecentAssigned() {
        return recentAssigned;
    }

    public void setRecentAssigned(String recentAssigned) {
        this.recentAssigned = recentAssigned;
    }

    public String getTicketElapsed() {
        return ticketElapsed;
    }

    public void setTicketElapsed(String ticketElapsed) {
        this.ticketElapsed = ticketElapsed;
    }

    public int getClaimIndex() {
        return claimIndex;
    }

    public void setClaimIndex(int claimIndex) {
        this.claimIndex = claimIndex;
    }

    public int getClaimHeaderId() {
        return claimHeaderId;
    }

    public void setClaimHeaderId(int claimHeaderId) {
        this.claimHeaderId = claimHeaderId;
    }

    public String getInsuredSex() {
        return insuredSex;
    }

    public void setInsuredSex(String insuredSex) {
        this.insuredSex = insuredSex;
    }

    public String getInsuredAge() {
        return insuredAge;
    }

    public void setInsuredAge(String insuredAge) {
        this.insuredAge = insuredAge;
    }

    public int getDayToClaim() {
        return dayToClaim;
    }

    public void setDayToClaim(int dayToClaim) {
        this.dayToClaim = dayToClaim;
    }

    public String getDenialIds() {
        return denialIds;
    }

    public void setDenialIds(String denialIds) {
        this.denialIds = denialIds;
    }

    public int getLastTouchedDays() {
        return lastTouchedDays;
    }

    public void setLastTouchedDays(int lastTouchedDays) {
        this.lastTouchedDays = lastTouchedDays;
    }

    public int getAgingDays() {
        return agingDays;
    }

    public void setAgingDays(int agingDays) {
        this.agingDays = agingDays;
    }

    public String getRenderingProvider() {
        return renderingProvider;
    }

    public void setRenderingProvider(String renderingProvider) {
        this.renderingProvider = renderingProvider;
    }

    public String getClaimIds() {
        return claimIds;
    }

    public void setClaimIds(String claimIds) {
        this.claimIds = claimIds;
    }

    public String getpType() {
        return pType;
    }

    public void setpType(String pType) {
        this.pType = pType;
    }

    public Long getFileId() {
        return fileId;
    }

    public void setFileId(Long fileId) {
        this.fileId = fileId;
    }

    public String getRecordStatus() {
        return recordStatus;
    }

    public void setRecordStatus(String recordStatus) {
        this.recordStatus = recordStatus;
    }

    public String getInterChangeDate() {
        return interChangeDate;
    }

    public void setInterChangeDate(String interChangeDate) {
        this.interChangeDate = interChangeDate;
    }

    public String getFileStatus() {
        return fileStatus;
    }

    public void setFileStatus(String fileStatus) {
        this.fileStatus = fileStatus;
    }

    public Long getHeader837Id() {
        return header837Id;
    }

    public void setHeader837Id(Long header837Id) {
        this.header837Id = header837Id;
    }

    public List<String> getFileNames() {
        return fileNames;
    }

    public void setFileNames(List<String> fileNames) {
        this.fileNames = fileNames;
    }

    public List<String> getAcctNames() {
        return acctNames;
    }

    public void setAcctNames(List<String> acctNames) {
        this.acctNames = acctNames;
    }

    public boolean isHasCallHistory() {
        return hasCallHistory;
    }

    public void setHasCallHistory(boolean hasCallHistory) {
        this.hasCallHistory = hasCallHistory;
    }

}
