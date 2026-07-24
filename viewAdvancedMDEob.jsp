<%-- 
    Document   : viewAdvancedMDEob
    Created on : Jun 17, 2026, 1:38:58 PM
    Author     : Sivananthi
--%>

<%@page contentType="text/html"  pageEncoding="UTF-8" autoFlush="true"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>

<head>
    <title>AdvancedMD EOB</title>
    <style>
        .select-container {
            position: relative;
        }
        .js-select-placeholder-multiple {
            width: 100%;
        }
        .close {
            position: absolute;
            top: 50%;
            right: 10px;
            transform: translateY(-50%);
            cursor: pointer;
        }
        .select2-container .select2-selection__arrow {
            display: none !important;
        }
        .nav-pills {
            padding: 0px !important;
        }
        .tab-content {
            padding:20px!important;
        }
        #templateTable.table thead th {
            border-bottom: 1px solid #024444 !important;
        }
        .dataTables_processing {
            z-index: 999!important;
        }
        .close-btn {
            position: absolute;
            top: 0px;
            right: 40px;
            font-weight: bold;
            font-size: 25px;
            cursor: pointer;
        }
        .select2-container .select2-selection__arrow {
            display: none !important;
        }
        .menu-styler .style-toggler > a:before {
            top:80px!important;
        }

        .badge-light-danger2:focus, .badge-light-danger2:hover {
            color: #fc798d;
        }
        .badge-light-danger2 {
            background: rgba(252, 121, 141, 0.15);
            color: #fc798d;
        }
        #select2-filterJobId-results .select2-results__option:before
        {
            content: "";
            display: inline-block;
            position: relative;
            height: 15px;
            width: 15px;
            border: 2px solid #8F8F9D;
            border-radius: 4px;
            background-color: #fff;
            margin-right:10px;
            vertical-align: middle;
        }
        #select2-filterJobId-results .select2-results__option[aria-selected=true]:before
        {
            font-family:'Font Awesome\ 5 Free';
            content: "\f00c";
            color: #fff;
            background-color: #0060DF;
            border: 0;
            display: inline-block;
            padding-left: 3px;
            font-weight: 900;
            font-size:10px;
        }
    </style>
    <jsp:include page="includes/header.jsp"></jsp:include>
        <!-- [ Main Content ] start -->
    <div class="pcoded-main-container">
        <div class="pcoded-wrapper">
            <div class="pcoded-content">
                <div class="pcoded-inner-content">
                    <div class="main-body">
                        <div class="page-wrapper">
                            <div class="row">
                                <!-- [ form-element ] start -->
                                <div class="col-lg-12">

                                <form:form method="POST" id="benefituploadform" name="bulkev" action="advancedmd-import-excel-eob" modelAttribute="nexgen-import-excel-eob" enctype="multipart/form-data">
                                    <input type="hidden" id="activeTab" name="activeTab" value="${activeTab != null ? activeTab : 'home'}" />
                                    <ul class="nav nav-pills" id="myTab" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link text-uppercase" id="home-tab" tabindex="1"  data-toggle="tab" href="#home" role="tab" aria-controls="home" aria-selected="true">Upload</a>
                                        <li class="nav-item">
                                            <a class="nav-link text-uppercase" id="error-tab" tabindex="2"  data-toggle="tab" href="#error" role="tab" aria-controls="error" aria-selected="false">Upload Log</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-uppercase" id="payment-tab" tabindex="3"  data-toggle="tab" href="#payment" role="tab" aria-controls="payment" aria-selected="false">Payment</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-uppercase" id="advisory-tab" tabindex="4"  data-toggle="tab" href="#advisory" role="tab" aria-controls="advisory" aria-selected="false">Advisory</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-uppercase" id="posting-tab" tabindex="5"  data-toggle="tab" href="#posting" role="tab" aria-controls="posting" aria-selected="false">Posting</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" id="pills-template-tab" tabindex="6" data-toggle="tab" href="#pills-template" role="tab" aria-controls="pills-template" aria-selected="false">Download Template</a>
                                        </li>
                                    </ul>
                                    <div class="tab-content" id="myTabContent">
                                        <div class="tab-pane fade show" id="home" role="tabpanel" aria-labelledby="home-tab">
                                            <div class="row">
                                                <div class="col-lg-4 ">
                                                    <div class="form-group">
                                                        <label class="form-label"  for="practiceId">Practice <span class="text-danger">*</span></label>
                                                        <div class="select-container">
                                                            <select class="form-control js-select-placeholder-multiple col-sm-12" id="practiceId" data-placeholder="Select Account" tabindex="4" name="practiceId">
                                                                <c:forEach var="payee" items="${payeelist}">
                                                                    <option value = ${payee.payee}> ${payee.payee} </option>  
                                                                </c:forEach>                                                                
                                                            </select>
                                                            <span class="close" id="closePractice" style="display:none; right:10px!important;">&times;</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="col-lg-4 p-l-0">
                                                    <div class="form-group">
                                                        <label class="form-label" for="jobTypeId">Job Type <span class="text-danger">*</span></label>
                                                        <select class="required form-control" id="jobTypeId"  tabindex="6" name ="jobTypeId">
                                                            <c:forEach var="Job" items="${jobtypelist}">
                                                                <option value = ${Job.jobtypeid} >${Job.job_type}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>        
                                                <div class="col-lg-4">
                                                    <div class="form-group">
                                                        <label class="form-label">Document <span class="text-danger f-12">* (Allow only .xls and .xlsx file type)  </span></label>
                                                        <input type="file" class="form-control"  name="file" class="upload" tabindex="9" id="fileUpload">  
                                                        <input id="uploadFile" placeholder="Choose File" style="display:none;" disabled="disabled" />
                                                    </div>
                                                    <div class="progress mt-2" style="height: 20px; display:none;" id="progressWrapper">
                                                        <div id="progressBar" class="progress-bar progress-bar-striped progress-bar-animated bg-success"
                                                             role="progressbar" style="width: 0%">0%
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                            <div class="row">                                                
                                                <div class="col-6 offset-6 text-right p-r-0">                                                   
                                                    <button type="submit" tabindex="18" id="btnSubmit" class="btn btn-rounded btn-warning">Submit</button>
                                                </div>  
                                            </div>
                                        </div>

                                        <div class="tab-pane fade show" id="error" role="tabpanel" aria-labelledby="error-tab">
                                            <div class="dt-responsive table-responsive tablehide" style="width:100%;">
                                                <table id="simpletable" width="100%" class="table table-bordered nowrap" >
                                                    <thead style="color:#768ba0;">
                                                        <tr>                                                           
                                                            <th data-element="eob_job_id">Job Id</th>
                                                            <th data-element="job_type">Type</th>
                                                            <th data-element="ftp_user">Practice</th>
                                                            <th data-element="filename">File Name</th>
                                                            <th data-element="totalXlRows" data-toggle="tooltip" data-placement="right" title="Total rows in XL">Xl Rows</th>
                                                            <th data-element="absorbedRecords" data-toggle="tooltip" data-placement="right" title="Absorbed line items">Absorbed</th>
                                                            <th data-element="createdBy">By</th>
                                                            <th data-element="createdDate">Date</th>
                                                            <th data-element="status">Status</th>
                                                            <th data-element="action">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>                                                                  
                                                    </tbody>
                                                </table>                                                   
                                            </div> 
                                        </div>

                                        <div class="tab-pane fade show" id="payment" role="tabpanel" aria-labelledby="payment-tab">
                                            <div class="dt-responsive table-responsive tablehide" style="width:100%;">
                                                <table id="simpletable1" width="100%" class="table table-bordered nowrap" >
                                                    <thead style="color:#768ba0;">
                                                        <tr>
                                                            <th style="position: sticky; top: 0; z-index: 1;" ><input id="headercheck" type="checkbox"></th>
                                                            <th data-element="tid">Id</th>
                                                            <th data-element="filename">File Name</th>
                                                            <th data-element="check_no">Check No</th>
                                                            <th data-element="claimCount">Claim Count</th>
                                                            <th data-element="payment_date">PMT Date</th>
                                                            <th data-element="applied_payment">Applied PMT</th>
                                                            <th data-element="payor">Payor</th>
                                                            <th data-element="ftp_user">Account</th>
                                                            <th data-element="status">Status</th> 
                                                            <th data-element="job_id">Job Id</th>
                                                            <th data-element="createdBy">Created By</th>
                                                            <th data-element="created_date">Created Date</th>
                                                            <th data-element="updatedBy">Updated By</th>
                                                            <th data-element="updated_date">Updated Date</th>
                                                            <th data-element="recievedDate">Rec Dt</th>
                                                            <th data-element="">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>                                                                  
                                                    </tbody>
                                                </table>                                                   
                                            </div> 
                                        </div>    

                                        <div class="tab-pane fade show" id="advisory" role="tabpanel" aria-labelledby="advisory-tab">
                                            <div class="dt-responsive table-responsive tablehide" style="width:100%;">
                                                <table id="simpletable2" width="100%" class="table table-bordered nowrap" >
                                                    <thead style="color:#768ba0;">
                                                        <tr>
                                                            <th style="position: sticky; top: 0; z-index: 1;" ><input id="advHeaderCheck" type="checkbox"></th>
                                                            <th data-element="tid">Id</th>
                                                            <th data-element="filename">Filename</th>
                                                            <th data-element="ftp_user">Account</th>
                                                            <th data-element="check_no">Check No</th>
                                                            <th data-element="claimno">Claim No</th>
                                                            <th data-element="total_charge">Total Charge</th>
                                                            <!--<th data-element="allowed">Allowed</th>-->
                                                            <th data-element="applied_payment">Applied Pmt</th>
                                                            <th data-element="patient_name">Patient Name</th>
                                                            <th data-element="received_date">Recieved Dt</th>
                                                            <th data-element="cpt">CPT</th>
                                                            <th data-element="units">Unit</th> 
                                                            <th data-element="payor">Payor</th>
                                                            <th data-element="status">Status</th>
                                                            <th data-element="claim_status">Claim Status</th>
                                                            <th data-element="dos">DOS</th>
                                                            <th data-element="job_id">Job ID</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>                                                                  
                                                    </tbody>
                                                </table>                                                   
                                            </div> 
                                        </div>  

                                        <div class="tab-pane fade show" id="posting" role="tabpanel" aria-labelledby="posting-tab">
                                            <div class="dt-responsive table-responsive tablehide" style="width:100%;">
                                                <table id="simpletable3" width="100%" class="table table-bordered nowrap" >
                                                    <thead style="color:#768ba0;">
                                                        <tr>
                                                            <th style="position: sticky; top: 0; z-index: 1;" ><input id="postingHeaderCheck" type="checkbox"></th>                                                            
                                                            <th data-element="filename">File Name</th>
                                                            <th data-element="check_no">Check No</th>
                                                            <th data-element="visit_id">Claim No</th>
                                                            <th data-element="units">Unit</th>
                                                            <th data-element="cpt">cpt</th>
                                                            <th data-element="charge_amount">Charge</th>
                                                            <th data-element="payment">Payment</th>
                                                            <th data-element="adjustment">Adjustment</th>
                                                            <th data-element="dos">Dos</th>
                                                            <th data-element="patient_name">Patient Name</th>
                                                            <th data-element="facility_name">Rend Prov</th>
                                                            <th data-element="provider_profile">Prov Profile</th>
                                                            <th data-element="received_date">Rec Dt</th>
                                                            <th data-element="status">Status</th>
                                                            <th data-element="job_id">Job ID</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>                                                                  
                                                    </tbody>
                                                </table>                                                   
                                            </div> 
                                        </div>   
                                        <div class="row" style="background-color: #e5f4f1 !important;" id="summary">
                                            <div class="col-lg-4 border-right col-md-4" id="totalCheckAmountDiv" style="padding: 0 25px !important;height: 33px;">
                                                <div class="form-group row" style="padding-top: 7px">
                                                    <label class="form-label m-l-5">Total Check Amount:  </label>
                                                    <h5 class="m-l-5" id="totalCheckAmount" style="font-size: 15px;margin-top: 2px;">$ 0</h5>
                                                </div>
                                            </div>
                                            <div class="col-lg-3 border-right col-md-4" id="totalBilledDiv" style="padding: 0 25px !important;height: 33px;">
                                                <div class="form-group row" style="padding-top: 7px">
                                                    <label class="form-label">Total Applied: </label>
                                                    <h5 class="m-l-5" id="totalBilled" style="font-size: 15px;margin-top: 2px;">$ 0</h5>
                                                </div>
                                            </div>
                                            <div class="col-lg-3  col-md-4" id="totalAllowedDiv" style="padding: 0 25px !important;height: 33px;">
                                                <div class="form-group row" style="padding-top: 7px;">
                                                    <label class="form-label">Total Charge:</label>
                                                    <h5 class="m-l-5" id="totalAllowed" style="font-size: 15px;margin-top: 2px;">$ 0</h5>
                                                </div>
                                            </div>
                                            <div class="col-lg-3  col-md-4" id="totalPaidDiv" style="padding: 0 25px !important;height: 33px;">
                                                <div class="form-group row" style="padding-top: 7px;">
                                                    <label class="form-label">Total Paid:</label>
                                                    <h5 class="m-l-5" id="totalPaid" style="font-size: 15px;margin-top: 2px;">$ 0</h5>
                                                </div>
                                            </div>
                                            <div class="col-lg-3  col-md-4" id="totalAdjDiv" style="padding: 0 25px !important;height: 33px;">
                                                <div class="form-group row" style="padding-top: 7px;">
                                                    <label class="form-label">Total Adj:</label>
                                                    <h5 class="m-l-5" id="totalAdj" style="font-size: 15px;margin-top: 2px;">$ 0</h5>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="pills-template" role="tabpanel" aria-labelledby="pills-template-tab">
                                            <div class="alert alert-success m-t-15" id="alerttemplatetag">
                                                <a target='_blank' href= '../ExcelEOB/advanced_md_eob_template.xls' class='btn-icon singledownbutton'>Sample Template:  <i class='fas fa-download' style='font-size:15px; margin:0 3px;color: #19BCBF;'></i></a>
                                            </div>
                                        </div>
                                    </div>
                                </form:form>
                                <!-- [ form-element ] end -->
                            </div>
                            <!-- [ Main Content ] end -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="styleSelector" class="menu-styler open" style="z-index:1071!important;">
    <div class="style-toggler" id="toggleBenefit"><a href="#!"></a></div>
    <div class="style-block">
        <h5 class="border-bottom">Filters</h5>
        <div id="adjustmentCardBody">
            <!-- log table -->
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Account" name="logPractice" id="logPractice">
                        <option value=""></option>
                        <c:forEach var="payee" items="${payeelist}">
                            <option> ${payee.payee} </option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="closeLogPractice">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousLogPractice">&#11165;</span> 
                            <span class="down-arrow" id="nextLogPractice">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class='input-group pull-right col-11 p-0' id='logDateRange' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important;">
                            <i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select Upload date range" style="height: 34px;"/>
                </div>
                <span id="closeLogDateRange" class="close-btn">&times;</span>
                <div class="input-group-append" id="" style="float: right; position: relative; margin-top: -34px;">
                    <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                        <span class="up-arrow" id="previousLogDateRange">&#11165;</span> 
                        <span class="down-arrow" id="nextLogDateRange">&#11167;</span>
                    </span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Job Type" name="logJobTypeList" id="logJobTypeList">
                        <option value="">Select Job Type</option>
                        <c:forEach var="Job" items="${jobtypelist}">
                            <option value = ${Job.jobtypeid} >${Job.job_type}</option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="closelogTypelist">&times;</span>
                    <div class="input-group-append" style="float: right; position: relative; margin-top:-38px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousLogTypelist">&#11165;</span> 
                            <span class="down-arrow" id="nextLogTypelist">&#11167;</span>
                        </span>
                    </div>
                </div>   
            </div> 
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Status" name="logJobStatus" id="logJobStatus">
                        <option value="">Select Status</option>
                        <option value="File uploaded">File uploaded</option>
                        <option value="Completed">Data Imported</option>                       
                    </select>                          
                    </select>
                    <span class="close-btn" id="closeStatus">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousStatus">&#11165;</span> 
                            <span class="down-arrow" id="nextStatus">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <!-- payment table -->
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Account" name="paymentPractice" id="paymentPractice">
                        <option value=""></option>
                        <c:forEach var="payee" items="${payeelist}">
                            <option> ${payee.payee} </option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="closePaymentPractice">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousPaymentPractice">&#11165;</span> 
                            <span class="down-arrow" id="nextPaymentPractice">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class='input-group pull-right col-11 p-0' id='checkDateRange' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important; "><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select Check date range" style="height: 34px;"/>
                </div>
                <span id="closeCheckDateRange" class="close-btn">&times;</span>
                <div class="input-group-append" style="float: right; position: relative; margin-top:-34px;">
                    <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                        <span class="up-arrow" id="previousCheckDateRange">&#11165;</span> 
                        <span class="down-arrow" id="nextCheckDateRange">&#11167;</span>
                    </span>
                </div>
            </div>

            <!-- Job ID dropdown filter - shared across all tabs, shown/hidden per tab -->
            <div class="col-lg-12 m-b-10 p-0" id="filterJobIdWrapper">
                <div class="select-container" id="filterJobIdContainer">
                    <select class="form-control js-select2 js-select-placeholder-multiple" multiple data-placeholder="Select Job Id" id="filterJobId" name="filterJobId">
                        <c:forEach var="jobId" items="${jobIdList}">
                            <option value="${jobId}">${jobId}</option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="closeFilterJobId" style="display:none;">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-38px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousJobId">&#11165;</span> 
                            <span class="down-arrow" id="nextJobId">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>              

            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="paymentCheckNo" placeholder="Enter Check No"/>
                    <span id="closepaymentCheckNo" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>
            <!-- payment status filter -->
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Status" name="paymentStatus" id="paymentStatus">
                        <option value="">Select Status</option>
                        <option value="File uploaded">File uploaded</option>
                        <option value="Completed">Data Imported</option>
                        <option value="Exception">Exception</option>
                    </select>
                    <span class="close-btn" id="closePaymentStatus">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousPaymentStatus">&#11165;</span>
                            <span class="down-arrow" id="nextPaymentStatus">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <!-- advisory table -->
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Practice" name="advisoryPayee" id="advisoryPayee">
                        <option value=""></option>
                        <c:forEach var="payee" items="${payeelist}">
                            <option> ${payee.payee} </option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="closeAdvisoryPayee">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousAdvisoryPayee">&#11165;</span> 
                            <span class="down-arrow" id="nextAdvisoryPayee">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0" style="">
                <div class='input-group pull-right col-11 p-0' id='receivedDateRange' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select Received date range" style="height: 34px;"/>
                </div>
                <span id="closeReceivedDateRange" class="close-btn">&times;</span>
                <div class="input-group-append" id="" style="float: right; position: relative; margin-top: -34px;">
                    <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                        <span class="up-arrow" id="previousReceivedDateRange">&#11165;</span> 
                        <span class="down-arrow" id="nextReceivedDateRange">&#11167;</span>
                    </span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class='input-group pull-right col-11 p-0' id='dosDateRange' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select DOS date range" style="height: 34px;"/>
                </div>
                <span id="closeDosDateRange" class="close-btn">&times;</span>
                <div class="input-group-append" id="" style="float: right; position: relative; margin-top: -34px;">
                    <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                        <span class="up-arrow" id="previousDosDateRange">&#11165;</span> 
                        <span class="down-arrow" id="nextDosDateRange">&#11167;</span>
                    </span>
                </div>
            </div>

            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="advisoryCheckNo" placeholder="Enter Check No"/>
                    <span id="closeAdvisoryCheckNo" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="advisoryClaimNo" placeholder="Enter Claim No"/>
                    <span id="closeAdvisoryClaimNo" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="advisoryPatientName" placeholder="Enter Patient Name"/>
                    <span id="closeAdvisoryPatientName" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>            
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Status" name="advisoryStatus" id="advisoryStatus">
                        <option value="">Select Status</option>
                        <option value="File uploaded">File uploaded</option>
                        <option value="Completed">Data Imported</option>
                        <option value="Exception">Exception</option>
                    </select>
                    <span class="close-btn" id="closeAdvisoryStatus">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousAdvisoryStatus">&#11165;</span>
                            <span class="down-arrow" id="nextAdvisoryStatus">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <!-- posting table -->
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Account" name="postingPayee" id="postingPayee">
                        <option value=""></option>
                        <c:forEach var="payee" items="${payeelist}">
                            <option> ${payee.payee} </option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="closePostingPayee">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousPostingPayee">&#11165;</span> 
                            <span class="down-arrow" id="nextPostingPayee">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0" style="">
                <div class='input-group pull-right col-11 p-0' id='postDateRange' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select Received date range" style="height: 34px;"/>
                </div>
                <span id="closePostDateRange" class="close-btn">&times;</span>
                <div class="input-group-append" id="" style="float: right; position: relative; margin-top: -34px;">
                    <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                        <span class="up-arrow" id="previousPostDateRange">&#11165;</span> 
                        <span class="down-arrow" id="nextPostDateRange">&#11167;</span>
                    </span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class='input-group pull-right col-11 p-0' id='dosDateRangePosting' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select DOS date range" style="height: 34px;"/>
                </div>
                <span id="closeDosDateRangePosting" class="close-btn">&times;</span>
                <div class="input-group-append" id="" style="float: right; position: relative; margin-top: -34px;">
                    <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                        <span class="up-arrow" id="previousDosDateRangePosting">&#11165;</span> 
                        <span class="down-arrow" id="nextDosDateRangePosting">&#11167;</span>
                    </span>
                </div>
            </div>

            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="postingCheckNo" placeholder="Enter Check No"/>
                    <span id="closePostingCheckNo" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="postingClaimNo" placeholder="Enter Claim No"/>
                    <span id="closePostingClaimNo" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="postingCode" placeholder="Enter Code"/>
                    <span id="closePostingCode" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Status" name="postingStatus" id="postingStatus">
                        <option value="File uploaded">File uploaded</option>
                        <option value="Completed">Data Imported</option>
                        <option value="Exception">Exception</option>
                    </select>
                    <span class="close-btn" id="closePostingStatus">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousPostingStatus">&#11165;</span>
                            <span class="down-arrow" id="nextPostingStatus">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>                                                      

            <div class="row searchEvent">
                <div class="col-md-12  p-r-5"> 
                    <button id="showall" class="btn btn-primary float-right" style="padding:6px 22px!important;">Reset</button>
                    <button id="search" class="btn btn-warning float-right" style="padding:6px 22px!important;">Search</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="modalConfirmYesNo" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" 
                        class="close" data-dismiss="modal" aria-label="Close">
                </button>
                <h4 id="lblTitleConfirmYesNo" class="modal-title">Confirmation </h4>
            </div>
            <div class="modal-body">
                <p id="lblMsgConfirmYesNo"></p>
            </div>
            <div class="modal-footer">
                <button id="btnYesConfirmYesNo" 
                        type="button" class="btn btn-primary">Yes</button>
                <button id="btnNoConfirmYesNo" 
                        type="button" class="btn btn-light">No</button>
            </div>
        </div>
    </div>
</div>      
<div id="flading" class="loader process-hide">
</div>
<div id="export-flading" class="loader1 process-hide">
    <img src="assets/images/loading-pink.gif" alt="Processing..." width="50" height="50">
</div>
<div class="modal fade" id="statusModal">
    <div class="modal-dialog" style="max-width: 30rem;">
        <div class="modal-content">
            <div class="modal-body">
                <label>Status <span class="text-danger">*</span></label>
                <select  class="form-control js-select-placeholder-multiple" data-placeholder="Select Status" name="status" id="uStatus" required>
                    <option value="">-- Select Status --</option>
                    <option value="Deleted">Deleted</option>
                    <option value="Exception">Exception</option>
                    <option value="File uploaded">File uploaded</option>
                </select>
                <div class="text-right mt-3">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                    <button type="button" id="btnStatusSubmit" class="btn btn-warning">Submit</button>
                </div>

            </div>
        </div>
    </div>
</div>
<!-- Required Js -->
<jsp:include page="includes/footer.jsp"></jsp:include>
    <script src="assets/js/plugins/select2.full.min.js"></script>
    <script src="assets/js/pages/form-select-custom.js"></script>
    <script src="assets/js/datetime.js"></script>
    <script src="assets/plugins/chart-peity/js/jquery.peity.min.js"></script>
    <link href="assets/css/bootstrap-toggle.min.css" rel="stylesheet" type="text/css"/>
    <script src="assets/js/bootstrap-toggle.min.js" type="text/javascript"></script>   
    <script src="assets/js/getYMDFormatDate.js"></script>
    <script src="assets/js/closeButton.js"></script> 
    <script src="assets/js/toggleCloseVisibility.js"></script>
    <script src="assets/js/select-handler.js"></script>
    <script src="assets/js/calculatePreviousDateRange.js"></script>
    <script src="assets/js/calculateNextDateRange.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            // filterJobId - multiselect with select2, dropdownParent fixes sidebar clipping
            $('#filterJobId').select2({
                dropdownParent: $('#filterJobIdContainer'),
                placeholder: 'Select Job Id',
                allowClear: true,
                closeOnSelect: false,
                allowClear: false
            });
            $('#filterJobId').on('change', function () {
                var vals = $(this).val();
                if (vals && vals.length > 0) {
                    $('#closeFilterJobId').show();
                } else {
                    $('#closeFilterJobId').hide();
                }
            });
            $('#closeFilterJobId').on('click', function () {
                $('#filterJobId').val(null).trigger('change');
            });
            closeButton("#paymentStatus", "#closePaymentStatus");
            toggleCloseVisibility('closePaymentStatus', false);
            closeButton("#advisoryStatus", "#closeAdvisoryStatus");
            toggleCloseVisibility('closeAdvisoryStatus', false);
            $(document).on("click", ".singledownbutton", function (e) {
                e.preventDefault();
                var url = $(this).attr('href');
                $.ajax({
                    url: url,
                    type: 'HEAD',
                    success: function (data, textStatus, xhr) {
                        if (xhr.status === 200) {
                            window.open(url, '_blank');
                        } else {
                            msgbox("File Not Found.!", "", "warning");
                        }
                    },
                    error: function (xhr, textStatus, errorThrown) {
                        if (xhr.status === 404) {
                            msgbox("File Not Found.!", "", "warning");
                        } else {
                            console.log('Error: ' + xhr.status);
                        }
                    }
                });
                         });
            var logStart, logEnd, checkStart, checkEnd, receivedStart, receivedEnd, dosStart, dosEnd, dosStartPosting, dosEndPosting, postStart, postEnd;
            $("#styleSelector").hide();
            $("#summary").hide();
//            $('#home-tab').trigger('click');

            toggleCloseVisibility('closeLogPractice', false);
            toggleCloseVisibility('closeLogDateRange', false);
            toggleCloseVisibility('closelogTypelist', false);
            toggleCloseVisibility('closeStatus', false);
            toggleCloseVisibility('closePaymentPractice', false);
            toggleCloseVisibility('closeCheckDateRange', false);
            toggleCloseVisibility('closeReceivedDateRange', false);
            toggleCloseVisibility('closePostDateRange', false);
            toggleCloseVisibility('closeAdvisoryPayee', false);
            toggleCloseVisibility('closeDosDateRange', false);
            toggleCloseVisibility('closeAdvisoryCheckNo', false);
            toggleCloseVisibility('closeAdvisoryClaimNo', false);
            toggleCloseVisibility('closeAdvisoryPatientName', false);
            toggleCloseVisibility('advisoryStatus', false);
            toggleCloseVisibility('closePostingPayee', false);
            toggleCloseVisibility('closeDosDateRangePosting', false);
            toggleCloseVisibility('closePostingCheckNo', false);
            toggleCloseVisibility('closePostingClaimNo', false);
            toggleCloseVisibility('closePostingCode', false);
            toggleCloseVisibility('postingStatus', false);
            closeButton("#logPractice", "#closeLogPractice");
            closeButton("#logDateRange", "#closeLogDateRange");
            closeButton("#logJobTypeList", "#closelogTypelist");
            closeButton("#logJobStatus", "#closeStatus");
            closeButton("#paymentPractice", "#closePaymentPractice");
            closeButton("#checkDateRange", "#closeCheckDateRange");
            closeButton("#receivedDateRange", "#closeReceivedDateRange");
            closeButton("#paymentCheckNo", "#closepaymentCheckNo");
            closeButton("#postDateRange", "#closePostDateRange");
            closeButton("#advisoryPayee", "#closeAdvisoryPayee");
            closeButton("#dosDateRange", "#closeDosDateRange");
            closeButton("#advisoryCheckNo", "#closeAdvisoryCheckNo");
            closeButton("#advisoryClaimNo", "#closeAdvisoryClaimNo");
            closeButton("#advisoryPatientName", "#closeAdvisoryPatientName");
            closeButton("#advisoryPaymentId", "#closeAdvisoryPaymentId");
            closeButton("#postingPayee", "#closePostingPayee");
            closeButton("#dosDateRangePosting", "#closeDosDateRangePosting");
            closeButton("#postingCheckNo", "#closePostingCheckNo");
            closeButton("#postingClaimNo", "#closePostingClaimNo");
            closeButton("#postingCode", "#closePostingCode");
            closeButton("#postingStatus", "#closePostingStatus");
            $('#logDateRange').daterangepicker({
                buttonClasses: ' btn',
                applyClass: 'btn-primary',
                cancelClass: 'btn-secondary',
                startDate: logStart,
                endDate: logEnd,
                showDropdowns: true,
                minDate: moment('2024-01-01'),
                maxDate: moment().add(3, 'months'),
                opens: 'right',
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 2 Days': [moment().subtract(2, 'days'), moment()],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Last 60 Days': [moment().subtract(59, 'days'), moment()],
                    'Last 90 Days': [moment().subtract(89, 'days'), moment()]
                }
            }, function (startVal, endVal, label) {
                logStart = startVal.format('YYYY-MM-DD');
                logEnd = endVal.format('YYYY-MM-DD');
                $('#logDateRange .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                toggleCloseVisibility('closeLogDateRange', true);
            });
            $('#closeLogDateRange').on('click', function () {
                $('#logDateRange .form-control').val('');
                logStart = '';
                logEnd = '';
                toggleCloseVisibility('closeLogDateRange', false);
            });
            $('#checkDateRange').daterangepicker({
                buttonClasses: ' btn',
                applyClass: 'btn-primary',
                cancelClass: 'btn-secondary',
                startDate: receivedStart,
                endDate: checkEnd,
                showDropdowns: true,
                minDate: moment('2024-01-01'),
                maxDate: moment().add(3, 'months'),
                opens: 'right',
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 2 Days': [moment().subtract(2, 'days'), moment()],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Last 60 Days': [moment().subtract(59, 'days'), moment()],
                    'Last 90 Days': [moment().subtract(89, 'days'), moment()]
                }
            }, function (startVal, endVal, label) {
                checkStart = startVal.format('YYYY-MM-DD');
                checkEnd = endVal.format('YYYY-MM-DD');
                $('#checkDateRange .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                toggleCloseVisibility('closeCheckDateRange', true);
            });
            $('#closeCheckDateRange').on('click', function () {
                $('#checkDateRange .form-control').val('');
                checkStart = '';
                checkEnd = '';
                toggleCloseVisibility('closeCheckDateRange', false);
            });
            $('#receivedDateRange').daterangepicker({
                buttonClasses: ' btn',
                applyClass: 'btn-primary',
                cancelClass: 'btn-secondary',
                startDate: receivedStart,
                endDate: receivedEnd,
                showDropdowns: true,
                minDate: moment('2024-01-01'),
                maxDate: moment().add(3, 'months'),
                opens: 'right',
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 2 Days': [moment().subtract(2, 'days'), moment()],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Last 60 Days': [moment().subtract(59, 'days'), moment()],
                    'Last 90 Days': [moment().subtract(89, 'days'), moment()]
                }
            }, function (startVal, endVal, label) {
                receivedStart = startVal.format('YYYY-MM-DD');
                receivedEnd = endVal.format('YYYY-MM-DD');
                $('#receivedDateRange .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                toggleCloseVisibility('closeReceivedDateRange', true);
            });
            $('#closeReceivedDateRange').on('click', function () {
                $('#receivedDateRange .form-control').val('');
                receivedStart = '';
                receivedEnd = '';
                toggleCloseVisibility('closeReceivedDateRange', false);
            });
            $('#postDateRange').daterangepicker({
                buttonClasses: ' btn',
                applyClass: 'btn-primary',
                cancelClass: 'btn-secondary',
                startDate: receivedStart,
                endDate: receivedEnd,
                showDropdowns: true,
                minDate: moment('2024-01-01'),
                maxDate: moment().add(3, 'months'),
                opens: 'right',
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 2 Days': [moment().subtract(2, 'days'), moment()],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Last 60 Days': [moment().subtract(59, 'days'), moment()],
                    'Last 90 Days': [moment().subtract(89, 'days'), moment()]
                }
            }, function (startVal, endVal, label) {
                postStart = startVal.format('YYYY-MM-DD');
                postEnd = endVal.format('YYYY-MM-DD');
                $('#postDateRange .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                toggleCloseVisibility('closePostDateRange', true);
            });
            $('#closePostDateRange').on('click', function () {
                $('#postDateRange .form-control').val('');
                postStart = '';
                postEnd = '';
                toggleCloseVisibility('closePostDateRange', false);
            });
            $('#dosDateRange').daterangepicker({
                buttonClasses: ' btn',
                applyClass: 'btn-primary',
                cancelClass: 'btn-secondary',
                startDate: dosStart,
                endDate: dosEnd,
                showDropdowns: true,
                minDate: moment('2024-01-01'),
                maxDate: moment().add(3, 'months'),
                opens: 'right',
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 2 Days': [moment().subtract(2, 'days'), moment()],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Last 60 Days': [moment().subtract(59, 'days'), moment()],
                    'Last 90 Days': [moment().subtract(89, 'days'), moment()]
                }
            }, function (startVal, endVal, label) {
                dosStart = startVal.format('YYYY-MM-DD');
                dosEnd = endVal.format('YYYY-MM-DD');
                $('#dosDateRange .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                toggleCloseVisibility('closeDosDateRange', true);
            });
            $('#closeDosDateRange').on('click', function () {
                $('#dosDateRange .form-control').val('');
                dosStart = '';
                dosEnd = '';
                toggleCloseVisibility('closeDosDateRange', false);
            });
            $('#dosDateRangePosting').daterangepicker({
                buttonClasses: ' btn',
                applyClass: 'btn-primary',
                cancelClass: 'btn-secondary',
                startDate: dosStartPosting,
                endDate: dosEndPosting,
                showDropdowns: true,
                minDate: moment('2024-01-01'),
                maxDate: moment().add(3, 'months'),
                opens: 'right',
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 2 Days': [moment().subtract(2, 'days'), moment()],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Last 60 Days': [moment().subtract(59, 'days'), moment()],
                    'Last 90 Days': [moment().subtract(89, 'days'), moment()]
                }
            }, function (startVal, endVal, label) {
                dosStartPosting = startVal.format('YYYY-MM-DD');
                dosEndPosting = endVal.format('YYYY-MM-DD');
                $('#dosDateRangePosting .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                toggleCloseVisibility('closeDosDateRangePosting', true);
            });
            $('#closeDosDateRangePosting').on('click', function () {
                $('#dosDateRangePosting .form-control').val('');
                dosStartPosting = '';
                dosEndPosting = '';
                toggleCloseVisibility('closeDosDateRangePosting', false);
            });
            function showFiltersForTableById(tableId) {
                $("#adjustmentCardBody > div").not('.searchEvent').hide();
                $("#filterJobIdWrapper").hide();
                $("#summary").hide();
                $("#totalCheckAmountDiv").hide();
                $("#totalBilledDiv").hide();
                $("#totalAllowedDiv").hide();
                $("#totalPaidDiv").hide();
                $("#totalAdjDiv").hide();
                switch (tableId) {
                    case "error-tab":
                        $("#logPractice").closest(".col-lg-12").show();
                        $("#logDateRange").closest(".col-lg-12").show();
                        $("#filterJobIdWrapper").show();
                        $("#logJobTypeList").closest(".col-lg-12").show();
                        $("#logJobStatus").closest(".col-lg-12").show();
                        break;
                    case "payment-tab":
                        $("#paymentPractice").closest(".col-lg-12").show();
                        $("#checkDateRange").closest(".col-lg-12").show();
                        $("#receivedDateRange").closest(".col-lg-12").hide();
                        $("#filterJobIdWrapper").show();
                        $("#paymentCheckNo").closest(".col-lg-12").show();
                        $("#paymentStatus").closest(".col-lg-12").show();
                        $("#summary").show();
                        $("#totalCheckAmountDiv").show();
                        break;
                    case "advisory-tab":
                        $("#advisoryPayee").closest(".col-lg-12").show();
                        $("#dosDateRange").closest(".col-lg-12").show();
                        $("#receivedDateRange").closest(".col-lg-12").show();
                        $("#filterJobIdWrapper").hide();
                        $("#advisoryCheckNo").closest(".col-lg-12").show();
                        $("#advisoryClaimNo").closest(".col-lg-12").show();
                        $("#advisoryPatientName").closest(".col-lg-12").show();
                        $("#advisoryStatus").closest(".col-lg-12").show();
                        $("#summary").show();
                        $("#totalBilledDiv").show();
                        $("#totalAllowedDiv").show();
                        $("#totalPaidDiv").hide();
                        $("#totalAdjDiv").hide();
                        break;
                    case "posting-tab":
                        $("#postingPayee").closest(".col-lg-12").show();
                        $("#dosDateRangePosting").closest(".col-lg-12").show();
                        $("#postDateRange").closest(".col-lg-12").show();
                        $("#filterJobIdWrapper").hide();
                        $("#postingCheckNo").closest(".col-lg-12").show();
                        $("#postingClaimNo").closest(".col-lg-12").show();
                        $("#postingCode").closest(".col-lg-12").hide();
                        $("#postingStatus").closest(".col-lg-12").show();
                        $("#summary").show();
                        $("#totalBilledDiv").show();
                        $("#totalAllowedDiv").show();
                        $("#totalPaidDiv").hide();
                        $("#totalAdjDiv").hide();
                        break;
                }
            }

            function clearFiltersForTab(tabId) {
                const resetMap = {
                    error: ['#logPractice', '#logDateRange', '#logJobTypeList', '#logJobStatus', '#filterJobId'],
                    payment: ['#paymentPractice', '#checkDateRange', '#paymentCheckNo', '#paymentStatus', '#filterJobId'],
                    advisory: ['#advisoryPayee', '#dosDateRange', '#advisoryCheckNo', '#receivedDateRange', '#advisoryStatus', '#advisoryClaimNo', '#advisoryPatientName', '#filterJobId'],
                    posting: ['#postingPayee', '#dosDateRangePosting', '#postingCheckNo', '#postDateRange', '#postingClaimNo', '#postingCode', '#postingStatus', '#filterJobId']
                };
                const fieldsToReset = resetMap[tabId] || [];
                fieldsToReset.forEach(function (selector) {
                    if (selector === '#filterJobId') {
                        $(selector).val(null).trigger('change'); // multiselect needs val(null)
                    } else if ($(selector).is('select')) {
                        $(selector).val('').trigger('change');
                    } else {
                        $(selector).val('');
                    }
                });
                switch (tabId) {
                    case 'error':
                        $('#closeLogDateRange').trigger('click');
                        break;
                    case 'payment':
                        $('#closeCheckDateRange').trigger('click');
                        $('#closeReceivedDateRange').trigger('click');
                        break;
                    case 'advisory':
                        $('#closeDosDateRange').trigger('click');
                        break;
                    case 'posting':
                        $('#closeDosDateRangePosting').trigger('click');
                        break;
                }
                multiSearchColumn = [];
                multiSearchValue = [];
            }

            $(document).on("shown.bs.tab", 'a[data-bs-toggle="tab"], a[data-toggle="tab"]', function (e) {
                var tabId = $(e.target).attr("id");
                showFiltersForTableById(tabId);
                if (tabId === "home-tab") {
                    $("#styleSelector").hide();
                } else {
                    $("#styleSelector").show();
                    // clear previous tab's filters before loading new tab
                    var activeTabId = tabId.replace('-tab', '');
                    // clearFiltersForTab(activeTabId);
                    $('#search').click();
                }
            });
            $(".table-responsive").removeClass("tablehide");
            $(".table-responsive").addClass("tableshow");
            $('#createdBy').hide();
            $('#alertdangertag').hide();
            $('#flading').hide();
            var orderData = [];
            var multiSearchColumn = [], multiSearchValue = [], multiSearchColumnName = [], multiSearchColumnValue = [];
            var searchValueDt = '';
            var rowsCount;
            $(document).on("click", ".singledownbutton1", function (e) {
                e.preventDefault();
                var url = $(this).attr('href');
                $.ajax({
                    url: url,
                    type: 'HEAD',
                    success: function (data, textStatus, xhr) {
                        if (xhr.status === 200) {
                            window.open(url, '_blank');
                        } else {
                            msgbox("File Not Found.!", "", "warning");
                        }
                    },
                    error: function (xhr, textStatus, errorThrown) {
                        if (xhr.status === 404) {
                            msgbox("File Not Found.!", "", "warning");
                        } else {
                            console.log('Error: ' + xhr.status);
                        }
                    }
                });
            });
            showProcessing();
            $('#filterBy option:eq(0)').prop('selected', true);
            function MyNoFunction() {
                $(".overlay").click();
                // $("#lblTestResult").html("You are not hungry");
                $('#headercheck').prop('checked', false);
                $('#simpletable1 tbody input[type=checkbox]').each(function () {
                    $(this).prop('checked', false);
                    if (checked > 0) {
                        checked--;
                    }
                });
            }

            function handleOrderChange(settings) {
                var table = $('#simpletable').DataTable();
                var currentOrder = table.order();
                if (currentOrder.length > 0) {
                    var columnIndex = currentOrder[0][0];
                    var sortingDirection = currentOrder[0][1];
                    var column = table.column(columnIndex);
                    var dataElement = column.header().getAttribute('data-element') || "";
                    orderData = sortingDirection ? [{"columnName": dataElement, "dir": sortingDirection}] : [];
                } else {
                    orderData = [];
                }
            }

            var searchValueDt = '';
            var table = $('#simpletable').DataTable({
                "aaSorting": [[0, 'desc']],
                "pageLength": 100,
                "lengthMenu": [10, 30, 50, 100, 200, 500],
                stateSave: true,
                deferLoading: 0,
                scrollY: "300px",
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                fixedHeader: false,
                "oLanguage": {
                    "sEmptyTable": "No Data..."
                },
                "columnDefs": [
                    {'visible': false, 'targets': []}
                ],
                preDrawCallback: function (settings) {
                    handleOrderChange(settings);
                },
                drawCallback: function (settings, json) {
                    $('[data-toggle="tooltip"]').tooltip('update');
                },
                processing: true,
                serverSide: true,
                "ajax": {
                    "type": "POST",
                    "url": 'advancedmd-eob-log',
                    "contentType": 'application/json',
                    "dataType": "json",
                    "data": function (d) {
                        return JSON.stringify($.extend({}, d, {
                            "multiSearchColumn": multiSearchColumn.toString(),
                            "multiSearchValue": multiSearchValue.toString(),
                            "innerSearchValue": searchValueDt.trim(),
                            "order": orderData
                        }));
                    }, dataSrc: function (data) {
                        return  data.data;
                    }, "error": function (xhr, status, error) {
                        msgbox("An error occurred while contacting the server, or the same user is logged in elsewhere. Please reload the page and try again. ", "Status Code Master Portal", "error");
                    }
                },
                "columns": [
                    {"data": "eobJobId", "orderable": true, "searchable": true, "name": "eobJodId"},
                    {"data": "eobJobType", "orderable": true, "searchable": true, "name": "eobJobType"},
                    {"data": "ftpUser", "orderable": true, "searchable": true, "name": "ftpUser"},
                    {"data": "fileName", "orderable": true, "searchable": true, "name": "fileName"},
                    {"data": "totalXlRows", "orderable": true, "searchable": true, "name": "totalXlRows"},
                    {"data": "absorbedRows", "orderable": true, "searchable": true, "name": "absorbedRows"},
                    {"data": "createdBy", "orderable": true, "searchable": true, "name": "createdBy"},
                    {"data": "createdDate", "orderable": true, "searchable": true, "name": "createdDate"},
                    {"data": function (data) {
                            if (data.status === "File uploaded") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-info status-cell f-12 m-r-5">' + data.status + '</a>';
                            } else if (data.status === "Upload failure") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-danger2 status-cell f-12 m-r-5">' + data.status + '</a>';
                            } else if (data.status === "Processing") {
                                return '<span class="text-danger">' +
                                        '<span class="spinner-border spinner-border-sm mr-1"></span>' +
                                        'Processing</span>';
                            } else if (data.status === "Staging success") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-primary status-cell f-12 m-r-5">' + data.status + '</a>';
                            } else if (data.status === "Staging fail") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-dark status-cell f-12 m-r-5">' + data.status + '</a>';
                            } else if (data.status === "Data imported" || data.status === "Completed") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-success status-cell f-12 m-r-5"> Data Imported</a>';
                            } else if (data.status === "Data import fail") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-warning status-cell f-12 m-r-5">' + data.status + '</a>';
                            } else if (data.status === "Staging Removed") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-danger status-cell f-12 m-r-5">' + data.status + '</a>';
                            } else {
                                return " " + data.status;
                            }
                        }, "orderable": true, "searchable": true, "name": "status"},
                    {"data": function (data) {
                            let deleteOption = '', downloadEOB = '', callProcedure = '';
                            let status = data.status;
                            if (status === "File uploaded") {
                                deleteOption = ' <a aria-label="Delete" role="tooltip"  data-microtip-position="left" id="deleteJob" class="deleteJob" ><i class="fas fa-trash-alt" style="font-size:15px; margin:0 3px;color:#FF425C;"></i></a> ';
                            }
                            if (status === "File uploaded" && data.absorbedRecords !== 0) {
                                callProcedure = ' <a aria-label="TriggerProcedure" role="tooltip"  data-microtip-position="left" id="callProcedure" class="callProcedure" ><i class="fas fa-check-square" style="font-size:15px; margin:0 3px;color:#2DCEE3;"></i></a> ';
                            }
                            return deleteOption + downloadEOB + callProcedure;
                        }, "orderable": false, "searchable": false, "name": "action"}
                ], dom: '<"d-flex justify-content-between align-items-center mb-2" f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                createdRow: function (row, data, dataIndex) {
                    if (data["status"] === "Staging Removed") {
                        $(row).find('td').not(':eq(7)').attr(
                                'style',
                                'font-weight: bold !important; text-decoration: line-through; color:red!important;'
                                );
                    }

                }, footerCallback: function (tfoot, data, start, end, display) {
                    $("#flading").hide();
                }
            });
            showProcessing();
            $('#mobile-collapse').click(function () {
                table.ajax.reload(null, false);
            });
            table.on('search.dt', function () {
                $("#flading").show();
                searchValueDt = getModifiedSearchValue(table.search().trim());
            });
            var checkedIndexes = [];
            var isCheckAllClicked = 0;
            var currentTableResponse;
            var currentTableRowTotal = 0;
            var maxRowsForExport = 0;
    <c:forEach var="limitVal" items="${maxLimitForExport}">
            maxRowsForExport = '${limitVal}';
    </c:forEach>
            $('#headercheck').prop('checked', false);
            var checked = 0;
            function deselectAllFunction() {
                $(".overlay").click();
                $('#headercheck').prop('checked', false);
                $('#simpletable1 tbody input[type=checkbox]').each(function () {
                    $(this).prop('checked', false);
                    if (checked > 0) {
                        checked--;
                    }
                });
                checkedIndexes = [];
                isCheckAllClicked = 0;
            }

            var tab = $('#activeTab').val();
            if (tab) {
                $('#' + tab + '-tab').tab('show');
                table.ajax.reload(null, false);
            } else {
                $('#home-tab').tab('show');
            }

            $('#simpletable1 tbody').on('change', 'input[type="checkbox"]', function () {
                var id = $(this).closest('tr').index();
                isCheckAllClicked = 0;
                if (checkedIndexes.length > 0 && checkedIndexes.includes(id)) {
                    var index = checkedIndexes.indexOf(id);
                    if (index !== -1) {
                        checkedIndexes.splice(index, 1);
                    }
                } else {
                    checkedIndexes.push(id);
                }
                checkedIndexes.sort(function (a, b) {
                    return a - b;
                });
            });
            $('[id*=simpletable1] thead').on('click', 'th:first-child', function () {
                var checkboxes = $('#simpletable1 tbody input[type=checkbox]');
                if (isCheckAllClicked === 0) {
                    checkedIndexes = [];
                    checkboxes.each(function (index) {
                        checkedIndexes.push(index);
                        isCheckAllClicked = 1;
                    });
                } else {
                    checkedIndexes = [];
                    isCheckAllClicked = 0;
                }
            });
            var recordsFiltered = 0;
            function exportPaymentTable(exportType) {
                if (isCheckAllClicked === 0 && checkedIndexes.length > 0) {
                    exportSelectionPayment(exportType);
                } else if (isCheckAllClicked === 0 && recordsFiltered > currentTableResponse.length) {
                    exportAllPayment(exportType);
                } else {
                    exportCurrentPaymentTable(exportType);
                }
                checkedIndexes = [];
            }
            ;
            function exportSelectionPayment(exportType) {
                var visibleColumns = paymentTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                location.href = "export-advancedmd-payment-data-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction();
            }

            function exportCurrentPaymentTable(exportType) {
                var visibleColumns = paymentTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                if (checkedIndexes.length > 0) {
                    location.href = "export-advancedmd-payment-data-report?startIndex=" + checkedIndexes[0] + "&endIndex=" + checkedIndexes[checkedIndexes.length - 1] + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                } else {
                    location.href = "export-advancedmd-payment-data-report?startIndex=0&endIndex=" + (currentTableResponse.length - 1) + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                }
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction();
            }

            function exportAllPayment(exportType) {
                var visibleColumns = paymentTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $.ajax({
                    url: 'advancedmd-payment-data',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        "multiSearchColumn": multiSearchColumn.toString(),
                        "multiSearchValue": multiSearchValue.toString(),
                        "innerSearchValue": searchValueDt.trim(),
                        "order": orderData
                    }),
                    success: function (data) {
                        $('#flading').show();
                        location.href = "export-advancedmd-payment-data-report?startIndex=-1&endIndex=-1&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                        $('.loader1').addClass("process-hide");
                        $('#flading').hide();
                        $('#export-flading').hide();
                        deselectAllFunction();
                    }
                });
            }

            function handleOrderChange1(settings) {
                var paymentTable = $('#simpletable1').DataTable();
                var currentOrder = paymentTable.order();
                if (currentOrder.length > 0) {
                    var columnIndex = currentOrder[0][0];
                    var sortingDirection = currentOrder[0][1];
                    var column = paymentTable.column(columnIndex);
                    var dataElement = column.header().getAttribute('data-element') || "";
                    orderData = sortingDirection ? [{"columnName": dataElement, "dir": sortingDirection}] : [];
                } else {
                    orderData = [];
                }
            }
            var exportType;
            var columnsList = ${columnsList};
            var paymentTable = $('#simpletable1').DataTable({
                "aaSorting": [],
                "pageLength": 100,
                "lengthMenu": [10, 30, 50, 100, 200, 500],
                stateSave: true,
                deferLoading: 0,
                scrollY: "350px",
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                fixedHeader: false,
                "oLanguage": {
                    "sEmptyTable": "No Data..."
                },
                "columnDefs": [
                    {'visible': false, 'targets': [11, 12, 13, 14]}
                ],
                preDrawCallback: function (settings) {
                    handleOrderChange1(settings);
                    this.api().columns.adjust();
                },
                drawCallback: function (settings, json) {
                    $('[data-toggle="tooltip"]').tooltip('update');
                },
                processing: true,
                serverSide: true,
                "ajax": {
                    "type": "POST",
                    "url": 'advancedmd-payment-data',
                    "contentType": 'application/json',
                    "dataType": "json",
                    "data": function (d) {
                        return JSON.stringify($.extend({}, d, {
                            "multiSearchColumn": multiSearchColumn.toString(),
                            "multiSearchValue": multiSearchValue.toString(),
                            "innerSearchValue": searchValueDt.trim(),
                            "order": orderData
                        }));
                    }, dataSrc: function (data) {
                        rowsCount = data.data.length;
                        if (data.exportData) {
                            currentTableResponse = JSON.parse(data.exportData);
                            recordsFiltered = data.recordsFiltered;
                        }
                        if (data.footerData) {
                            let footerValues = data.footerData.split(",");
                            let totalCheckAmount = parseFloat(footerValues[0]);
                            $('#totalCheckAmount').html('$ ' + totalCheckAmount.toFixed(2));
                        }
                        return  data.data;
                    }, "error": function (xhr, status, error) {
                        msgbox("An error occurred while contacting the server, or the same user is logged in elsewhere. Please reload the page and try again. ", "Status Code Master Portal", "error");
                    }
                },
                "columns": [
                    {"data": function (data) {
                            return '<input type="checkbox" class = "check">';
                        }, "orderable": false, "searchable": false, "name": "check"}, //0
                    {"data": "tid", "orderable": true, "searchable": true, "name": "tid"},
                    {"data": "fileName", "orderable": true, "searchable": true, "name": "fileName"},
                    {"data": "checkNo", "orderable": true, "searchable": true, "name": "checkNo"},
                    {"data": "claimCount", "orderable": true, "searchable": true, "name": "claimCount"},
                    {"data": "paymentDate", "orderable": true, "searchable": true, "name": "paymentDate"},
                    {"data": function (data) {
                            var chequeValue = parseFloat(data.insurancePayment);
                            return chequeValue.toFixed(2);
                        }, "orderable": true, "searchable": true, "name": "insurancePayment"},
                    {"data": "payor", "orderable": true, "searchable": true, "name": "payor"},
                    {"data": "ftpUser", "orderable": true, "searchable": true, "name": "ftpUser"},
                    {"data": function (data) {
                            if (data.status === "File uploaded") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-info status-cell f-12 m-r-5"> File Uploaded</a>';
                            } else if (data.status === "Active") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-primary status-cell f-12 m-r-5"> Staging success </a>';
                            } else if (data.status === "Completed") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-success status-cell f-12 m-r-5"> Data Imported </a>';
                            } else if (data.status === null || data.status === '') {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-danger status-cell f-12 m-r-5"> Staging </a>';
                            } else if (data.status === "Exception") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-danger2 status-cell f-12 m-r-5"> Exception </a>';
                            } else {
                                return " " + data.status;
                            }
                        }, "orderable": true, "searchable": true, "name": "status"},
                    {"data": function (data) {
                            return '<span class="jobId-cell" data-value="' + data.jobId + '" data-tid-value="' + data.tid + '">' + data.jobId + '</span>';
                        }, "orderable": true, "searchable": true, "name": "jobId"},
                    {"data": "createdBy", "orderable": true, "searchable": true, "name": "createdBy"},
                    {"data": "createdDate", "orderable": true, "searchable": true, "name": "createdDate"},
                    {"data": "updatedBy", "orderable": true, "searchable": true, "name": "updatedBy"},
                    {"data": "updatedDate", "orderable": true, "searchable": true, "name": "updatedDate"},
                    {"data": "receivedDate", "orderable": true, "searchable": true, "name": "receivedDate"},
                    {"data": function (data) {
                            let deleteOption = '';
                            let status = data.status;
                            if (status === "File uploaded" || status === "Exception") {
                                deleteOption = ' <a aria-label="Delete" role="tooltip"  data-microtip-position="left" id="deleteEob" class="deleteEob" ><i class="fas fa-trash-alt" style="font-size:15px; margin:0 3px;color:#FF425C;"></i></a> ';
                            }
                            return deleteOption;
                        }, "orderable": false, "searchable": false, "name": "action"}
                ], dom: '<"d-flex justify-content-between align-items-center mb-2"B f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                buttons: [
                    {
                        className: 'dt-pdf-btn ',
                        text: '<img src="assets/images/automation.png" style="width:25px;height:25px;">',
                        titleAttr: 'Manual Trigger',
                        action: function (e, dt, node, config) {
                            callPaymentProcedure();
                        }
                    },
                    {
                        extend: 'csv',
                        text: '<img src="assets/images/excelicon.png">',
                        className: 'dt-pdf-btn ',
                        titleAttr: 'Download list in excel Format',
                        exportOptions: {
                            columns: [1, 22, 2, 3, 4, 24, 25, 7, 8, 9, 32, 13, 26, 15]
                        },
                        action: function (e, dt, button, config) {
                            if (currentTableRowTotal > maxRowsForExport) {
                                msgbox("Number of rows exceeds the maximum possible rows per sheet in this report. Rows processed: 50000.!", "", "warning");
                            }
                            exportType = 1;
                            if (rowsCount > 0) {
                                $('.loader1').removeClass("process-hide");
                                $('#flading').show();
                                $('#export-flading').show();
                                exportPaymentTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }, {
                        extend: 'pdfHtml5',
                        orientation: 'landscape',
                        text: '<img src="assets/images/pdficon.png">',
                        className: 'dt-pdf-btn ',
                        titleAttr: 'Download list in PDF Format',
                        pageSize: 'LEGAL',
                        exportOptions: {
                            columns: [1, 22, 2, 3, 4, 24, 25, 7, 8, 9, 32, 13, 26, 15]
                        }, action: function (e, dt, button, config) {
                            if (currentTableRowTotal > maxRowsForExport) {
                                msgbox("Number of rows exceeds the maximum possible rows per sheet in this report. Rows processed: 50000.!", "", "warning");
                            }
                            exportType = 2;
                            if (rowsCount > 0) {
                                $('.loader1').removeClass("process-hide");
                                $('#flading').show();
                                $('#export-flading').show();
                                exportPaymentTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }, {
                        className: 'dt-pdf-btn ',
                        text: '<img src="assets/images/edit.png" style="width:25px;height:25px;">',
                        titleAttr: 'Update Status',
                        action: function (e, dt, node, config) {
                            updateStatus();
                        }
                    }, {
                        extend: 'colvis',
                        className: 'btn-outline-secondary btn-sm',
                        text: 'Columns <i class="fas fa-plus m-r-5 m-l-5" style="font-size:9px"></i>/<i class="fas fa-minus m-l-5" style="font-size:9px;"></i> ',
                        columns: columnsList
                    }
                ],
                createdRow: function (row, data, dataIndex) {
                    // initializeTooltips(row, data);
                }, footerCallback: function (tfoot, data, start, end, display) {
                    $("#flading").hide();
                }
            });
            showProcessing();
            $('#mobile-collapse').click(function () {
                paymentTable.ajax.reload(null, false);
            });
            paymentTable.on('search.dt', function () {
                $("#flading").show();
                searchValueDt = getModifiedSearchValue(paymentTable.search().trim());
            });
            var jobIdList = [];
            var tidList = [];
            function callPaymentProcedure() {
                jobIdList = [];
                tidList = [];
                $('.check:checked').each(function () {
                    let tr = $(this).closest('tr');
                    let span = tr.find('.jobId-cell');
                    let jobId = span.attr('data-value');
                    let tid = span.attr('data-tid-value');
                    if (jobId) {
                        jobIdList.push(jobId);
                    }
                    if (tid) {
                        tidList.push(tid);
                    }
                });
                let uniqueJobIds = [...new Set(jobIdList)];
                if (uniqueJobIds.length > 1) {
                    msgbox("Please select records belonging to the same Job ID only.", "", "warning");
                    return;
                }
                $('#export-flading').show();
                $.ajax({
                    url: "advancedmd-move-data-to-live-payment-id",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(tidList), // pass only tid values
                    success: function (response) {
                        if (response === "Success") {
                            setTimeout(function () {
                                msgbox("Data imported successfully!", "", "success");
                                paymentTable.ajax.url("advancedmd-payment-data").load();
                                deselectAllFunction();
                                $('#export-flading').hide();
                            }, 2000);
                        } else {
                            msgbox("Unexpected response", "", "warning");
                            deselectAllFunction();
                            $('#export-flading').hide();
                        }
                    },
                    error: function () {
                        msgbox("Error while processing request!", "", "error");
                        $('#export-flading').hide();
                    }
                });
            }

            $('#btnStatusSubmit').click(function () {
                var table = $('#simpletable1').DataTable();
                var selectedIds = [];
                table.$('input[type="checkbox"]:checked').each(function () {
                    let tr = $(this).closest('tr');
                    let tid = tr.find('.jobId-cell').attr("data-tid-value");
                    if (tid) {
                        selectedIds.push(tid);
                    }
                });
                var paymentStatus = $("#uStatus").val();
                if (paymentStatus.length === 0) {
                    msgbox("Please select status", "", "warning");
                    return;
                }
                if (selectedIds.length === 0) {
                    msgbox("Please select at least one record", "", "warning");
                    return;
                }
                var paymentStatus = $("#uStatus").val();
                $.ajax({
                    url: "update-advancedmd-payment-status",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        advancedMdIds: selectedIds,
                        status: paymentStatus
                    }),
                    success: function (response) {

                        if (response === "Success") {
                            $('#statusModal').modal('hide');
                            table.ajax.reload(null, false);
                            deselectAllFunction();
                            msgbox("Updated Successfully!", "", "success");
                        }
                    },
                    error: function () {
                        msgbox("Something went wrong!", "", "error");
                    }
                });
            });
            function updateStatus() {
                var table = $('#simpletable1').DataTable();
                var checkedBoxes = table.$('input[type="checkbox"]:checked');
                if (checkedBoxes.length === 0) {
                    msgbox("Please select at least one record.", "", "warning");
                    return;
                }
                $('#statusModal').modal('show');
            }

            var total = 0;
            $('#simpletable1').on('click', 'tbody input[type="checkbox"]', function () {
                var table = $('#simpletable1').DataTable();
                total = table.column(3, {
                    page: 'current'
                }).data().count();
                var isSelected = $(this).is(':checked');
                if (isSelected) {
                    checked++;
                } else {
                    checked--;
                }

                if (checked === total) {
                    $('#headercheck').prop('checked', true);
                    if (checked > 1) {
                        notflag = 'Y';
                    }
                } else {
                    $('#headercheck').prop('checked', false);
                    if (checked > 1) {
                        notflag = 'Y';
                    } else {
                        notflag = 'N';
                    }
                }
            });
            $('#headercheck').change(function () {
                var table = $('#simpletable1').DataTable();
                total = table.column(3, {
                    page: 'current'
                }).data().count();
                checked = 0;
                var isSelected = $(this).is(':checked');
                if (isSelected) {
                    $('#simpletable1 tbody input[type=checkbox]').each(function () {
                        $(this).prop('checked', true);
                        if (checked <= total) {
                            checked++;
                        }
                    });
                    if (checked > 1) {
                        notflag = 'Y';
                    }
                } else {
                    $('#simpletable1 tbody input[type=checkbox]').each(function () {
                        $(this).prop('checked', false);
                        if (checked > 0) {
                            checked--;
                        }
                    });
                    notflag = 'N';
                }
            });
            // advisory table

            function deselectAllFunction1() {
                $(".overlay").click();
                $('#advHeaderCheck').prop('checked', false);
                $('#simpletable2 tbody input[type=checkbox]').each(function () {
                    $(this).prop('checked', false);
                    if (checked > 0) {
                        checked--;
                    }
                });
                checkedIndexes = [];
                isCheckAllClicked = 0;
            }

            $('#simpletable2 tbody').on('change', 'input[type="checkbox"]', function () {
                var id = $(this).closest('tr').index();
                isCheckAllClicked = 0;
                if (checkedIndexes.length > 0 && checkedIndexes.includes(id)) {
                    var index = checkedIndexes.indexOf(id);
                    if (index !== -1) {
                        checkedIndexes.splice(index, 1);
                    }
                } else {
                    checkedIndexes.push(id);
                }
                checkedIndexes.sort(function (a, b) {
                    return a - b;
                });
            });
            $('[id*=simpletable2] thead').on('click', 'th:first-child', function () {
                var checkboxes = $('#simpletable2 tbody input[type=checkbox]');
                if (isCheckAllClicked === 0) {
                    checkedIndexes = [];
                    checkboxes.each(function (index) {
                        checkedIndexes.push(index);
                        isCheckAllClicked = 1;
                    });
                } else {
                    checkedIndexes = [];
                    isCheckAllClicked = 0;
                }
            });
            function exportAdvisoryTable(exportType) {
                if (isCheckAllClicked === 0 && checkedIndexes.length > 0) {
                    exportSelectionAdvisory(exportType);
                } else if (isCheckAllClicked === 0 && recordsFiltered > currentTableResponse.length) {
                    exportAllAdvisory(exportType);
                } else {
                    exportCurrentAdvisoryTable(exportType);
                }
                checkedIndexes = [];
            }
            ;
            function exportSelectionAdvisory(exportType) {
                var visibleColumns = advisoryTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                location.href = "export-advancedmd-advisory-data-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction1();
            }

            function exportCurrentAdvisoryTable(exportType) {
                var visibleColumns = advisoryTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                if (checkedIndexes.length > 0) {
                    location.href = "export-advancedmd-advisory-data-report?startIndex=" + checkedIndexes[0] + "&endIndex=" + checkedIndexes[checkedIndexes.length - 1] + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                } else {
                    location.href = "export-advancedmd-advisory-data-report?startIndex=0&endIndex=" + (currentTableResponse.length - 1) + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                }
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction1();
            }

            function exportAllAdvisory(exportType) {
                var visibleColumns = advisoryTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $.ajax({
                    url: 'advancedmd-advisory-data',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        "multiSearchColumn": multiSearchColumn.toString(),
                        "multiSearchValue": multiSearchValue.toString(),
                        "innerSearchValue": searchValueDt.trim(),
                        "order": orderData
                    }),
                    success: function (data) {
                        $('#flading').show();
                        location.href = "export-advancedmd-advisory-data-report?startIndex=-1&endIndex=-1&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                        $('.loader1').addClass("process-hide");
                        $('#flading').hide();
                        $('#export-flading').hide();
                        deselectAllFunction1();
                    }
                });
            }

            function handleOrderChange2(settings) {
                var advisoryTable = $('#simpletable2').DataTable();
                var currentOrder = advisoryTable.order();
                if (currentOrder.length > 0) {
                    var columnIndex = currentOrder[0][0];
                    var sortingDirection = currentOrder[0][1];
                    var column = advisoryTable.column(columnIndex);
                    var dataElement = column.header().getAttribute('data-element') || "";
                    orderData = sortingDirection ? [{"columnName": dataElement, "dir": sortingDirection}] : [];
                } else {
                    orderData = [];
                }
            }

            var advisorySearchValueDt = '';
            var advisoryColumnsList = ${advisoryColumnsList};
            var advisoryTable = $('#simpletable2').DataTable({
                "aaSorting": [],
                "pageLength": 100,
                "lengthMenu": [10, 30, 50, 100, 200, 500],
                stateSave: true,
                deferLoading: 0,
                scrollY: "350px",
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                fixedHeader: false,
                "oLanguage": {
                    "sEmptyTable": "No Data..."
                },
                "columnDefs": [
                    {'visible': false, 'targets': [8, 9, 13]}
                ],
                preDrawCallback: function (settings) {
                    handleOrderChange2(settings);
                    this.api().columns.adjust();
                },
                drawCallback: function (settings, json) {
                    $('[data-toggle="tooltip"]').tooltip('update');
                },
                processing: true,
                serverSide: true,
                "ajax": {
                    "type": "POST",
                    "url": 'advancedmd-advisory-data',
                    "contentType": 'application/json',
                    "dataType": "json",
                    "data": function (d) {
                        return JSON.stringify($.extend({}, d, {
                            "multiSearchColumn": multiSearchColumn.toString(),
                            "multiSearchValue": multiSearchValue.toString(),
                            "innerSearchValue": advisorySearchValueDt.trim(),
                            "order": orderData
                        }));
                    }, dataSrc: function (data) {
                        rowsCount = data.data.length;
                        if (data.exportData) {
                            currentTableResponse = JSON.parse(data.exportData);
                            recordsFiltered = data.recordsFiltered;
                        }
                        if (data.footerData) {
                            let footerValues = data.footerData.split(",");
                            let totalBilled = parseFloat(footerValues[0]);
                            let totalAllowed = parseFloat(footerValues[1]);
                            let totalPaid = parseFloat(footerValues[2]);
                            let totalAdj = parseFloat(footerValues[3]);
                            $('#totalBilled').html('$ ' + totalBilled.toFixed(2));
                            $('#totalAllowed').html('$ ' + totalAllowed.toFixed(2));
                            $('#totalPaid').html('$ ' + totalPaid.toFixed(2));
                            $('#totalAdj').html('$ ' + totalAdj.toFixed(2));
                        }
                        return  data.data;
                    }, "error": function (xhr, status, error) {
                        msgbox("An error occurred while contacting the server, or the same user is logged in elsewhere. Please reload the page and try again. ", "Status Code Master Portal", "error");
                    }
                },
                "columns": [
                    {"data": function (data) {
                            return '<input type="checkbox" class = "check">';
                        }, "orderable": false, "searchable": false, "name": "check"}, //0
                    {"data": "tid", "orderable": true, "searchable": true, "name": "tid"},
                    {"data": "fileName", "orderable": true, "searchable": true, "name": "fileName"},
                    {"data": "ftpUser", "orderable": true, "searchable": true, "name": "ftpUser"},
                    {"data": "checkNo", "orderable": true, "searchable": true, "name": "checkNo"},
                    {"data": "claimNo", "orderable": true, "searchable": true, "name": "claimNo"},
                    {"data": "totalCharge", "orderable": true, "searchable": true, "name": "totalCharge"},
//                    {"data": "allowed", "orderable": true, "searchable": true, "name": "allowed"},
                    {"data": "insurancePayment", "orderable": true, "searchable": true, "name": "insurancePayment"},
                    {"data": "patientName", "orderable": true, "searchable": true, "name": "patientName"},
                    {"data": "receivedDate", "orderable": true, "searchable": true, "name": "receivedDate"},
                    {"data": "cpt", "orderable": true, "searchable": true, "name": "cpt"},
                    {"data": "modifier", "orderable": true, "searchable": true, "name": "modifier"},
                    {"data": "payor", "orderable": true, "searchable": true, "name": "payor"},
                    {"data": function (data) {
                            if (data.status === "File uploaded") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-info status-cell f-12 m-r-5"> File Uploaded</a>';
                            } else if (data.status === "Active") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-primary status-cell f-12 m-r-5"> Staging success </a>';
                            } else if (data.status === "Completed") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-success status-cell f-12 m-r-5"> Data Imported </a>';
                            } else if (data.status === null || data.status === '') {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-danger status-cell f-12 m-r-5"> Staging </a>';
                            } else if (data.status === "Exception") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-danger2 status-cell f-12 m-r-5"> Exception </a>';
                            } else {
                                return " " + data.status;
                            }
                        }, "orderable": true, "searchable": true, "name": "status"},
                    {"data": "claimStatus", "orderable": true, "searchable": true, "name": "claimStatus"},
                    {"data": "dos", "orderable": true, "searchable": true, "name": "dos"},
                    {"data": "jobId", "orderable": true, "searchable": true, "name": "jobId"}
                ], dom: '<"d-flex justify-content-between align-items-center mb-2"B f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                buttons: [{
                        extend: 'csv',
                        text: '<img src="assets/images/excelicon.png">',
                        className: 'dt-pdf-btn ',
                        titleAttr: 'Download list in excel Format',
                        exportOptions: {
                            columns: [1, 23, 2, 3, 4, 5, 25, 26, 8, 9, 10, 33, 14, 27, 16]
                        },
                        action: function (e, dt, button, config) {
                            if (currentTableRowTotal > maxRowsForExport) {
                                msgbox("Number of rows exceeds the maximum possible rows per sheet in this report. Rows processed: 50000.!", "", "warning");
                            }
                            exportType = 1;
                            if (rowsCount > 0) {
                                $('.loader1').removeClass("process-hide");
                                $('#flading').show();
                                $('#export-flading').show();
                                exportAdvisoryTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }, {
                        extend: 'pdfHtml5',
                        orientation: 'landscape',
                        text: '<img src="assets/images/pdficon.png">',
                        className: 'dt-pdf-btn ',
                        titleAttr: 'Download list in PDF Format',
                        pageSize: 'LEGAL',
                        exportOptions: {
                            columns: [1, 23, 2, 3, 4, 5, 25, 26, 8, 9, 10, 33, 14, 27, 16]
                        }, action: function (e, dt, button, config) {
                            if (currentTableRowTotal > maxRowsForExport) {
                                msgbox("Number of rows exceeds the maximum possible rows per sheet in this report. Rows processed: 50000.!", "", "warning");
                            }
                            exportType = 2;
                            if (rowsCount > 0) {
                                $('.loader1').removeClass("process-hide");
                                $('#flading').show();
                                $('#export-flading').show();
                                exportAdvisoryTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }, {
                        extend: 'colvis',
                        className: 'btn-outline-secondary btn-sm col-sm- col-lg-13',
                        text: 'Columns <i class="fas fa-plus m-r-5 m-l-5" style="font-size:9px"></i>/<i class="fas fa-minus m-l-5" style="font-size:9px;"></i> ',
                        columns: advisoryColumnsList
                    }
                ],
                createdRow: function (row, data, dataIndex) {

                }, footerCallback: function (tfoot, data, start, end, display) {
                    $("#flading").hide();
                }
            });
            showProcessing();
            $('#mobile-collapse').click(function () {
                advisoryTable.ajax.reload(null, false);
            });
            advisoryTable.on('search.dt', function () {
                $("#flading").show();
                advisorySearchValueDt = getModifiedSearchValue(advisoryTable.search().trim());
            });
            $('#simpletable2').on('click', 'tbody input[type="checkbox"]', function () {
                var table = $('#simpletable2').DataTable();
                total = table.column(3, {
                    page: 'current'
                }).data().count();
                var isSelected = $(this).is(':checked');
                if (isSelected) {
                    checked++;
                } else {
                    checked--;
                }

                if (checked === total) {
                    $('#advHeaderCheck').prop('checked', true);
                    if (checked > 1) {
                        notflag = 'Y';
                    }
                } else {
                    $('#advHeaderCheck').prop('checked', false);
                    if (checked > 1) {
                        notflag = 'Y';
                    } else {
                        notflag = 'N';
                    }
                }
            });
            $('#advHeaderCheck').change(function () {
                var table = $('#simpletable2').DataTable();
                total = table.column(3, {
                    page: 'current'
                }).data().count();
                checked = 0;
                var isSelected = $(this).is(':checked');
                if (isSelected) {
                    $('#simpletable2 tbody input[type=checkbox]').each(function () {
                        $(this).prop('checked', true);
                        if (checked <= total) {
                            checked++;
                        }
                    });
                    if (checked > 1) {
                        notflag = 'Y';
                    }
                } else {
                    $('#simpletable2 tbody input[type=checkbox]').each(function () {
                        $(this).prop('checked', false);
                        if (checked > 0) {
                            checked--;
                        }
                    });
                    notflag = 'N';
                }
            });
            // Posting Table

            function deselectAllFunction2() {
                $(".overlay").click();
                $('#postingHeaderCheck').prop('checked', false);
                $('#simpletable3 tbody input[type=checkbox]').each(function () {
                    $(this).prop('checked', false);
                    if (checked > 0) {
                        checked--;
                    }
                });
                checkedIndexes = [];
                isCheckAllClicked = 0;
            }

            $('#simpletable3 tbody').on('change', 'input[type="checkbox"]', function () {
                var id = $(this).closest('tr').index();
                isCheckAllClicked = 0;
                if (checkedIndexes.length > 0 && checkedIndexes.includes(id)) {
                    var index = checkedIndexes.indexOf(id);
                    if (index !== -1) {
                        checkedIndexes.splice(index, 1);
                    }
                } else {
                    checkedIndexes.push(id);
                }
                checkedIndexes.sort(function (a, b) {
                    return a - b;
                });
            });
            $('[id*=simpletable3] thead').on('click', 'th:first-child', function () {
                var checkboxes = $('#simpletable3 tbody input[type=checkbox]');
                if (isCheckAllClicked === 0) {
                    checkedIndexes = [];
                    checkboxes.each(function (index) {
                        checkedIndexes.push(index);
                        isCheckAllClicked = 1;
                    });
                } else {
                    checkedIndexes = [];
                    isCheckAllClicked = 0;
                }
            });
            //  var recordsFiltered = 0;

            function exportPostingTable(exportType) {
                if (isCheckAllClicked === 0 && checkedIndexes.length > 0) {
                    exportSelectionPosting(exportType);
                } else if (isCheckAllClicked === 0 && recordsFiltered > currentTableResponse.length) {
                    exportAllPosting(exportType);
                } else {
                    exportCurrentPostingTable(exportType);
                }
                checkedIndexes = [];
            }
            ;
            function exportSelectionPosting(exportType) {
                var visibleColumns = postingTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                location.href = "export-advancedmd-posting-data-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction2();
            }

            function exportCurrentPostingTable(exportType) {
                var visibleColumns = postingTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                if (checkedIndexes.length > 0) {
                    location.href = "export-advancedmd-posting-data-report?startIndex=" + checkedIndexes[0] + "&endIndex=" + checkedIndexes[checkedIndexes.length - 1] + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                } else {
                    location.href = "export-advancedmd-posting-data-report?startIndex=0&endIndex=" + (currentTableResponse.length - 1) + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                }
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction2();
            }

            function exportAllPosting(exportType) {
                var visibleColumns = postingTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $.ajax({
                    url: 'advancedmd-posting-data',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        "multiSearchColumn": multiSearchColumn.toString(),
                        "multiSearchValue": multiSearchValue.toString(),
                        "innerSearchValue": searchValueDt.trim(),
                        "order": orderData
                    }),
                    success: function (data) {
                        $('#flading').show();
                        location.href = "export-advancedmd-posting-data-report?startIndex=-1&endIndex=-1&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                        $('.loader1').addClass("process-hide");
                        $('#flading').hide();
                        $('#export-flading').hide();
                        deselectAllFunction2();
                    }
                });
            }

            function handleOrderChange3(settings) {
                var postingTable = $('#simpletable3').DataTable();
                var currentOrder = postingTable.order();
                if (currentOrder.length > 0) {
                    var columnIndex = currentOrder[0][0];
                    var sortingDirection = currentOrder[0][1];
                    var column = postingTable.column(columnIndex);
                    var dataElement = column.header().getAttribute('data-element') || "";
                    orderData = sortingDirection ? [{"columnName": dataElement, "dir": sortingDirection}] : [];
                } else {
                    orderData = [];
                }
            }

            var postingSearchValueDt = '';
            var postingColumnsList = ${postingColumnsList};
            var postingTable = $('#simpletable3').DataTable({
                "aaSorting": [],
                "pageLength": 100,
                "lengthMenu": [10, 30, 50, 100, 200, 500],
                stateSave: true,
                deferLoading: 0,
                scrollY: "350px",
                scrollX: true,
                autoWidth: false,
                scrollCollapse: true,
                paging: true,
                fixedHeader: false,
                "oLanguage": {
                    "sEmptyTable": "No Data..."
                },
                "columnDefs": [
                    {'visible': false, 'targets': [10, 11, 12]}
                ],
                preDrawCallback: function (settings) {
                    handleOrderChange3(settings);
                },
                drawCallback: function (settings, json) {
                    $('[data-toggle="tooltip"]').tooltip('update');
                },
                processing: true,
                serverSide: true,
                "ajax": {
                    "type": "POST",
                    "url": 'advancedmd-posting-data',
                    "contentType": 'application/json',
                    "dataType": "json",
                    "data": function (d) {
                        return JSON.stringify($.extend({}, d, {
                            "multiSearchColumn": multiSearchColumn.toString(),
                            "multiSearchValue": multiSearchValue.toString(),
                            "innerSearchValue": postingSearchValueDt.trim(),
                            "order": orderData
                        }));
                    }, dataSrc: function (data) {
                        rowsCount = data.data.length;
                        if (data.exportData) {
                            currentTableResponse = JSON.parse(data.exportData);
                            recordsFiltered = data.recordsFiltered;
                        }
                        if (data.footerData) {
                            let footerValues = data.footerData.split(",");
                            let totalBilled = parseFloat(footerValues[0]);
                            let totalAllowed = parseFloat(footerValues[1]);
                            let totalPaid = parseFloat(footerValues[2]);
                            let totalAdj = parseFloat(footerValues[3]);
                            $('#totalBilled').html('$ ' + totalBilled.toFixed(2));
                            $('#totalAllowed').html('$ ' + totalAllowed.toFixed(2));
                            $('#totalPaid').html('$ ' + totalPaid.toFixed(2));
                            $('#totalAdj').html('$ ' + totalAdj.toFixed(2));
                        }
                        return  data.data;
                    }, "error": function (xhr, status, error) {
                        msgbox("An error occurred while contacting the server, or the same user is logged in elsewhere. Please reload the page and try again. ", "Status Code Master Portal", "error");
                    }
                },
                "columns": [
                    {"data": function (data) {
                            return '<input type="checkbox" class = "check">';
                        }, "orderable": false, "searchable": false, "name": "check"}, //0
                    {"data": "fileName", "orderable": true, "searchable": true, "name": "fileName"},
                    {"data": "checkNo", "orderable": true, "searchable": true, "name": "checkNo"},
                    {"data": "claimNo", "orderable": true, "searchable": true, "name": "claimNo"},
                    {"data": "units", "orderable": true, "searchable": true, "name": "units"},
                    {"data": "cpt", "orderable": true, "searchable": true, "name": "cpt"},
                    {"data": "chargeAmount", "orderable": true, "searchable": true, "name": "chargeAmount"},
                    {"data": "payment", "orderable": true, "searchable": true, "name": "payment"},
                    {"data": "adjustment", "orderable": true, "searchable": true, "name": "adjustment"},
                    {"data": "dos", "orderable": true, "searchable": true, "name": "dos"},
                    {"data": "patientName", "orderable": true, "searchable": true, "name": "patientName"},
                    {"data": "facilityName", "orderable": true, "searchable": true, "name": "facilityName"},
                    {"data": "providerProfile", "orderable": true, "searchable": true, "name": "providerProfile"},
                    {"data": "receivedDate", "orderable": true, "searchable": true, "name": "receivedDate"},
                    {"data": function (data) {
                            if (data.status === "File uploaded") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-info status-cell f-12 m-r-5"> File Uploaded</a>';
                            } else if (data.status === "Active") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-primary status-cell f-12 m-r-5"> Staging success </a>';
                            } else if (data.status === "Completed") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-success status-cell f-12 m-r-5"> Data Imported </a>';
                            } else if (data.status === null || data.status === '') {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-danger status-cell f-12 m-r-5"> Staging </a>';
                            } else if (data.status === "Exception") {
                                return '<a href="#" data-value=' + data.status + ' class="badge badge-light-danger2 status-cell f-12 m-r-5"> Exception </a>';
                            } else {
                                return " " + data.status;
                            }
                        }, "orderable": true, "searchable": true, "name": "status"},
                    {"data": "jobId", "orderable": true, "searchable": true, "name": "jobId"},
                ], dom: '<"d-flex justify-content-between align-items-center mb-2"B f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                buttons: [{
                        extend: 'csv',
                        text: '<img src="assets/images/excelicon.png">',
                        className: 'dt-pdf-btn ',
                        titleAttr: 'Download list in excel Format',
                        exportOptions: {
                            columns: [1, 23, 2, 3, 4, 5, 23, 26, 8, 9, 10, 33, 14, 27, 16]
                        },
                        action: function (e, dt, button, config) {
                            if (currentTableRowTotal > maxRowsForExport) {
                                msgbox("Number of rows exceeds the maximum possible rows per sheet in this report. Rows processed: 50000.!", "", "warning");
                            }
                            exportType = 1;
                            if (rowsCount > 0) {
                                $('.loader1').removeClass("process-hide");
                                $('#flading').show();
                                $('#export-flading').show();
                                exportPostingTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }, {
                        extend: 'pdfHtml5',
                        orientation: 'landscape',
                        text: '<img src="assets/images/pdficon.png">',
                        className: 'dt-pdf-btn ',
                        titleAttr: 'Download list in PDF Format',
                        pageSize: 'LEGAL',
                        exportOptions: {
                            columns: [1, 23, 2, 3, 4, 5, 23, 26, 8, 9, 10, 33, 14, 27, 16]
                        }, action: function (e, dt, button, config) {
                            if (currentTableRowTotal > maxRowsForExport) {
                                msgbox("Number of rows exceeds the maximum possible rows per sheet in this report. Rows processed: 50000.!", "", "warning");
                            }
                            exportType = 2;
                            if (rowsCount > 0) {
                                $('.loader1').removeClass("process-hide");
                                $('#flading').show();
                                $('#export-flading').show();
                                exportPostingTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }, {
                        extend: 'colvis',
                        className: 'btn-outline-secondary btn-sm col-sm- col-lg-13',
                        text: 'Columns <i class="fas fa-plus m-r-5 m-l-5" style="font-size:9px"></i>/<i class="fas fa-minus m-l-5" style="font-size:9px;"></i> ',
                        columns: postingColumnsList
                    }
                ],
                createdRow: function (row, data, dataIndex) {

                }, footerCallback: function (tfoot, data, start, end, display) {
                    $("#flading").hide();
                }
            });
            showProcessing();
            $('#mobile-collapse').click(function () {
                postingTable.ajax.reload(null, false);
            });
            postingTable.on('search.dt', function () {
                $("#flading").show();
                postingSearchValueDt = getModifiedSearchValue(postingTable.search().trim());
            });
            $('#simpletable3').on('click', 'tbody input[type="checkbox"]', function () {
                var table = $('#simpletable3').DataTable();
                total = table.column(3, {
                    page: 'current'
                }).data().count();
                var isSelected = $(this).is(':checked');
                if (isSelected) {
                    checked++;
                } else {
                    checked--;
                }

                if (checked === total) {
                    $('#postingHeaderCheck').prop('checked', true);
                    if (checked > 1) {
                        notflag = 'Y';
                    }
                } else {
                    $('#postingHeaderCheck').prop('checked', false);
                    if (checked > 1) {
                        notflag = 'Y';
                    } else {
                        notflag = 'N';
                    }
                }
            });
            $('#postingHeaderCheck').change(function () {
                var table = $('#simpletable3').DataTable();
                total = table.column(3, {
                    page: 'current'
                }).data().count();
                checked = 0;
                var isSelected = $(this).is(':checked');
                if (isSelected) {
                    $('#simpletable3 tbody input[type=checkbox]').each(function () {
                        $(this).prop('checked', true);
                        if (checked <= total) {
                            checked++;
                        }
                    });
                    if (checked > 1) {
                        notflag = 'Y';
                    }
                } else {
                    $('#simpletable3 tbody input[type=checkbox]').each(function () {
                        $(this).prop('checked', false);
                        if (checked > 0) {
                            checked--;
                        }
                    });
                    notflag = 'N';
                }
            });
            // ── Initial page load: fire only the active tab's table once ──
            (function () {
                var initialTab = $('#activeTab').val() || 'error';
                showFiltersForTableById(initialTab + '-tab');
                if (initialTab !== 'home') {
                    $("#styleSelector").show();
                    multiSearchColumn = [];
                    multiSearchValue = [];
                    $('#search').click();
                }
            })();
            function collectFilterValuesById(tabId) {
                let filterIds = [];
                switch (tabId) {
                    case 'error':
                        filterIds = ['logPractice', 'logJobTypeList', 'logJobStatus'];
                        break;
                    case 'payment':
                        filterIds = ['paymentPractice', 'paymentCheckNo', 'paymentStatus'];
                        break;
                    case 'advisory':
                        filterIds = ['advisoryPayee', 'advisoryCheckNo', 'advisoryClaimNo', 'advisoryPatientName', 'advisoryStatus'];
                        break;
                    case 'posting':
                        filterIds = ['postingPayee', 'postingCheckNo', 'postingClaimNo', 'postingCode', 'postingStatus'];
                        break;
                    default:
                        return {};
                }

                let result = {};
                filterIds.forEach(id => {
                    const val = $('#' + id).val();
                    if (val !== undefined) {
                        result[id] = val;
                    }
                });
                return result;
            }

            $('#search').click(function (e) {
                e.preventDefault();
                const activeTabId = $('.tab-pane.active').attr('id');
                const tablesMap = {
                    error: $('#simpletable').DataTable(),
                    payment: $('#simpletable1').DataTable(),
                    advisory: $('#simpletable2').DataTable(),
                    posting: $('#simpletable3').DataTable()
                };
                const activeTable = tablesMap[activeTabId];
                if (!activeTable) {
                    console.warn('No active table found for tab:', activeTabId);
                    return;
                }

                multiSearchColumn = [];
                multiSearchValue = [];
                // Tab-specific Job ID column mapping
                const jobIdColumnMap = {
                    error: 'eob_job_id',
                    payment: 'job_id',
                    advisory: 'epp.eob_job_id',
                    posting: 'ep.eob_job_id'
                };
                const jobIdVals = $('#filterJobId').val(); // returns array for multiselect
                if (jobIdVals && jobIdVals.length > 0) {
                    multiSearchColumn.push(jobIdColumnMap[activeTabId]);
                    multiSearchValue.push(jobIdVals.join(',').replace(/,/g, '~'));
                }

                const filters = collectFilterValuesById(activeTabId);
                const fieldColumnMap = {
                    logPractice: 'sm.ftpuser',
                    logJobTypeList: 'eob_job_type',
                    logJobStatus: 'status',
                    paymentPractice: 'sm.ftpuser',
                    paymentCheckNo: 'oe.check_no',
                    paymentStatus: 'oe.status',
                    advisoryPayee: 'ftp_user',
                    advisoryCheckNo: 'check_no',
                    advisoryClaimNo: 'visit_id',
                    advisoryPatientName: 'patient_name',
                    advisoryStatus: 'oe.status',
                    postingPayee: 'sm.ftpuser',
                    postingCheckNo: 'oe.check_no',
                    postingClaimNo: 'oe.visit_id',
                    postingCode: 'oe.code',
                    postingStatus: 'oe.status'
                };
                $.each(filters, function (fieldId, value) {
                    if (value && value.trim().length > 0) {
                        multiSearchColumn.push(fieldColumnMap[fieldId]);
                        multiSearchValue.push(value.trim());
                    }
                });
                switch (activeTabId) {
                    case 'error':
                        if (logStart && logEnd) {
                            multiSearchColumn.push("created_on");
                            multiSearchValue.push(moment(logStart).format("MM/DD/YYYY") + "~" + moment(logEnd).format("MM/DD/YYYY"));
                        }
                        break;
                    case 'payment':
                        if (checkStart && checkEnd) {
                            multiSearchColumn.push("check_date");
                            multiSearchValue.push(moment(checkStart).format("MM/DD/YYYY") + "~" + moment(checkEnd).format("MM/DD/YYYY"));
                        }
                        break;
                    case 'advisory':
                        if (dosStart && dosEnd) {
                            multiSearchColumn.push("dos");
                            multiSearchValue.push(moment(dosStart).format("MM/DD/YYYY") + "~" + moment(dosEnd).format("MM/DD/YYYY"));
                        }
                        if (receivedStart && receivedEnd) {
                            multiSearchColumn.push("oe.received_date");
                            multiSearchValue.push(moment(receivedStart).format("MM/DD/YYYY") + "~" + moment(receivedEnd).format("MM/DD/YYYY"));
                        }
                        break;
                    case 'posting':
                        if (dosStartPosting && dosEndPosting) {
                            multiSearchColumn.push("dos");
                            multiSearchValue.push(moment(dosStartPosting).format("MM/DD/YYYY") + "~" + moment(dosEndPosting).format("MM/DD/YYYY"));
                        }
                        if (postStart && postEnd) {
                            multiSearchColumn.push("oe.received_date");
                            multiSearchValue.push(moment(postStart).format("MM/DD/YYYY") + "~" + moment(postEnd).format("MM/DD/YYYY"));
                        }
                        break;
                }
                activeTable.ajax.reload();
                deselectAllFunction();
                deselectAllFunction1();
                deselectAllFunction2();
            });
            $('#showall').click(function () {
                $('#flading').show();
                const activeTabId = $('.tab-pane.active').attr('id');
                const tablesMap = {
                    error: $('#simpletable').DataTable(),
                    payment: $('#simpletable1').DataTable(),
                    advisory: $('#simpletable2').DataTable(),
                    posting: $('#simpletable3').DataTable()
                };
                const activeTable = tablesMap[activeTabId];
                if (!activeTable)
                    return;
                searchValueDt = '';
                orderData = [];
                clearFiltersForTab(activeTabId);
                activeTable.search('').columns().search('');
                activeTable.ajax.reload();
            });
            $('#export-flading').hide();
            var filename = '';
            $('#fileUpload').change(function (e) {
                var file = e.target.files[0];
                filename = file.name;
                var extension = filename.substr(filename.lastIndexOf(".")).toLowerCase();
                var allowedExtensionsRegx = /\.(xls|xlsx)$/i;
                if (!allowedExtensionsRegx.test(extension)) {
                    msgbox("Invalid file type. Please upload a file with .xls or .xlsx extension.", "", "warning");
                    $('#btnsubmit').attr('disabled', "true");
                    $(this).val("");
                    return false;
                }

                $('#btnsubmit').removeAttr('disabled');
            });
            document.getElementById("fileUpload").onchange = function () {
                document.getElementById("uploadFile").value = this.value;
            };
            function deleteEOBEntry(element) {
                let tr = element.closest('tr');
                let eobJobId = tr.find('td:eq(1)').text();
                $("#flading").show();
                $.ajax({
                    url: "delete-advancedmd-eob-status",
                    type: "get",
                    data: {
                        id: $.trim(eobJobId)
                    },
                    success: function (response) {
                        if (response.length > 0) {
                            msgbox("Deleted", "", "success");
                            paymentTable.ajax.reload(null, false);
                            $("#flading").hide();
                        }
                    },
                    error: function (err) {
                        msgbox("Error", "", "error");
                    }
                });
            }

            function deleteJobEntry(element) {
                let tr = element.closest('tr');
                let eobJobId = tr.find('td:eq(0)').text();
                $("#flading").show();
                $.ajax({
                    url: "delete-advancedmd-job-id",
                    type: "get",
                    data: {
                        id: $.trim(eobJobId)
                    },
                    success: function (response) {
                        if (response.length > 0) {
                            msgbox("Deleted", "", "success");
                            table.ajax.reload(null, false);
                            $("#flading").hide();
                        }
                    },
                    error: function (err) {
                        msgbox("Error", "", "error");
                    }
                });
            }

            $('#export-flading').hide();
            function callProcedure(element) {
                let tr = element.closest('tr');
                let eobJobId = tr.find('td:eq(0)').text();
                $('#export-flading').show();
                $.ajax({
                    url: "advancedmd-move-data-from-stage-to-live-payment-job-id",
                    type: "POST",
                    data: {
                        jobId: $.trim(eobJobId)
                    },
                    success: function (response) {
                        console.log(response);
                        if (response === "Success") {
                            setTimeout(function () {
                                msgbox("Data imported", "", "success");
                                table.ajax.reload(null, false);
                                $('#export-flading').hide();
                            }, 5000); // 5000 milliseconds = 5 seconds

                        }
                    },
                    error: function (err) {
                        msgbox("Error", "", "error");
                        $('#export-flading').hide();
                    }
                });
            }

            function ShowConfirmYesNo(element, msg, type, ruleId, triggerElement) {
                if (type) {
                    AsyncConfirmYesNo(element,
                            "Confirmation Box",
                            msg, type, triggerElement
                            );
                }
            }

            $(document).on("click", "#simpletable1 a.deleteEob", function () {
                ShowConfirmYesNo($(this), "Any Related Staging EoB data will be permanently lost. Are you sure you want to proceed with deletion?", "deleteEob", "", "");
            });
            $(document).on("click", "#simpletable a.deleteJob", function () {
                ShowConfirmYesNo($(this), "Any Related Staging EoB data will be permanently lost. Are you sure you want to proceed with deletion?", "deleteJob", "", "");
            });
            $(document).on("click", "#simpletable a.callProcedure", function () {
                ShowConfirmYesNo($(this), "Do you want to Move data to live?", "callProcedure", "", "");
            });
            function AsyncConfirmYesNo(element, title, msg, type, triggerElement) {
                var $confirm = $("#modalConfirmYesNo");
                $confirm.modal('show');
                $("#lblTitleConfirmYesNo").html(title);
                $("#lblMsgConfirmYesNo").html(msg);
                $("#btnYesConfirmYesNo").off('click').click(function () {
                    if (type === "deleteEob") {
                        deleteEOBEntry(element);
                    } else if (type === "deleteJob") {
                        deleteJobEntry(element);
                    } else {
                        callProcedure(element);
                    }
                    $confirm.modal("hide");
                });
                $("#btnNoConfirmYesNo").off('click').click(function () {
                    $confirm.modal("hide");
                });
            }

            $("form[name='bulkev']").submit(function () {
                $('#flading').show();
            });
            $("#benefituploadform").on("submit", function (e) {
                e.preventDefault();
            });
            $("#btnSubmit").click(function (e) {
                e.preventDefault();
                var practice = $("#practiceId").val();
                var jobType = $("#jobTypeId").val();
                var fileInput = $("#fileUpload").val();
                if (!practice || practice.trim() === "") {
                    msgbox("Please select a Practice.", "", "warning");
                    return;
                }

                if (!jobType || jobType.trim() === "") {
                    msgbox("Please select a Job Type.", "", "warning");
                    return;
                }

                if (!fileInput) {
                    msgbox("Please choose a file.", "", "warning");
                    return;
                }

                var allowedExtensions = /(\.xls|\.xlsx)$/i;
                if (!allowedExtensions.exec(fileInput)) {
                    msgbox("Invalid file type. Only .xls and .xlsx files are allowed.", "", "warning");
                    return;
                }

                $("#benefituploadform")[0].submit();
                $('#flading').show();
            });
            function selectNextPractice() {
                const $selectElement = $('#logPractice');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousPractice() {
                const $selectElement = $('#logPractice');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextLogPractice").on("click", function () {
                selectNextPractice();
            });
            $("#previousLogPractice").on("click", function () {
                selectPreviousPractice();
            });
            function setPreviousDateRange() {
                let previousDates = calculatePreviousDateRange(moment(logStart).format('YYYY-MM-DD'), moment(logEnd).format('YYYY-MM-DD'));
                let newStart = moment(previousDates.progressFromDate);
                let minDate = $('#logDateRange').data('daterangepicker').minDate;
                if (newStart.isBefore(minDate)) {
                    msgbox("Selection cannot be made before the data availability date.", "", "warning");
                    return;
                }
                logStart = newStart.format("MM/DD/YYYY");
                logEnd = moment(previousDates.progressToDate).format("MM/DD/YYYY");
                $('#logDateRange').data('daterangepicker').setStartDate(logStart);
                $('#logDateRange').data('daterangepicker').setEndDate(logEnd);
                $('#logDateRange .form-control').val(logStart + ' / ' + logEnd).trigger('change');
                toggleCloseVisibility('closeLogDateRange', true);
            }

            function setNextDateRange() {
                let nextDates = calculateNextDateRange(moment(logStart).format('YYYY-MM-DD'), moment(logEnd).format('YYYY-MM-DD'));
                logStart = moment(nextDates.nextFromDate).format('MM/DD/YYYY');
                logEnd = moment(nextDates.nextToDate).format('MM/DD/YYYY');
                $('#logDateRange').data('daterangepicker').setStartDate(logStart);
                $('#logDateRange').data('daterangepicker').setEndDate(logEnd);
                $('#logDateRange .form-control').val(logStart + ' / ' + logEnd).trigger('change');
                toggleCloseVisibility('closeLogDateRange', true);
            }

            $("#nextLogDateRange").on("click", function () {
                if (logStart && logEnd) {
                    setNextDateRange();
                } else {
                    msgbox("Please select date range.", "", "warning");
                }
            });
            $("#previousLogDateRange").on("click", function () {
                if (logStart && logEnd) {
                    setPreviousDateRange();
                } else {
                    msgbox("Please select date range.", "", "warning");
                }
            });
            function selectNextLogType() {
                const $selectElement = $('#logJobTypeList');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousLogType() {
                const $selectElement = $('#logJobTypeList');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextLogTypelist").on("click", function () {
                selectNextLogType();
            });
            $("#previousLogTypelist").on("click", function () {
                selectPreviousLogType();
            });
            function selectNextStatus() {
                const $selectElement = $('#logJobStatus');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousStatus() {
                const $selectElement = $('#logJobStatus');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextStatus").on("click", function () {
                selectNextStatus();
            });
            $("#previousStatus").on("click", function () {
                selectPreviousStatus();
            });
            function selectNextPaymentPractice() {
                const $selectElement = $('#paymentPractice');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousPaymentPractice() {
                const $selectElement = $('#paymentPractice');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextPaymentPractice").on("click", function () {
                selectNextPaymentPractice();
            });
            $("#previousPaymentPractice").on("click", function () {
                selectPreviousPaymentPractice();
            });
            function setPreviousCheckDateRange() {
                let previousDates = calculatePreviousDateRange(moment(checkStart).format('YYYY-MM-DD'), moment(checkEnd).format('YYYY-MM-DD'));
                let newStart = moment(previousDates.progressFromDate);
                let minDate = $('#checkDateRange').data('daterangepicker').minDate;
                if (newStart.isBefore(minDate)) {
                    msgbox("Selection cannot be made before the data availability date.", "", "warning");
                    return;
                }
                checkStart = newStart.format("MM/DD/YYYY");
                checkEnd = moment(previousDates.progressToDate).format("MM/DD/YYYY");
                $('#checkDateRange').data('daterangepicker').setStartDate(checkStart);
                $('#checkDateRange').data('daterangepicker').setEndDate(checkEnd);
                $('#checkDateRange .form-control').val(checkStart + ' / ' + checkEnd).trigger('change');
                toggleCloseVisibility('closeCheckDateRange', true);
            }

            function setNextCheckDateRange() {
                let nextDates = calculateNextDateRange(moment(checkStart).format('YYYY-MM-DD'), moment(checkEnd).format('YYYY-MM-DD'));
                checkStart = moment(nextDates.nextFromDate).format('MM/DD/YYYY');
                checkEnd = moment(nextDates.nextToDate).format('MM/DD/YYYY');
                $('#checkDateRange').data('daterangepicker').setStartDate(checkStart);
                $('#checkDateRange').data('daterangepicker').setEndDate(checkEnd);
                $('#checkDateRange .form-control').val(checkStart + ' / ' + checkEnd).trigger('change');
                toggleCloseVisibility('closeCheckDateRange', true);
            }

            $("#nextCheckDateRange").on("click", function () {
                if (checkStart && checkEnd) {
                    setNextCheckDateRange();
                } else {
                    msgbox("Please select check date range.", "", "warning");
                }
            });
            $("#previousCheckDateRange").on("click", function () {
                if (checkStart && checkEnd) {
                    setPreviousCheckDateRange();
                } else {
                    msgbox("Please select check date range.", "", "warning");
                }
            });
            function setPreviousReceivedDateRange() {
                let previousDates = calculatePreviousDateRange(moment(receivedStart).format('YYYY-MM-DD'), moment(receivedEnd).format('YYYY-MM-DD'));
                let newStart = moment(previousDates.progressFromDate);
                let minDate = $('#receivedDateRange').data('daterangepicker').minDate;
                if (newStart.isBefore(minDate)) {
                    msgbox("Selection cannot be made before the data availability date.", "", "warning");
                    return;
                }
                receivedStart = newStart.format("MM/DD/YYYY");
                receivedEnd = moment(previousDates.progressToDate).format("MM/DD/YYYY");
                $('#receivedDateRange').data('daterangepicker').setStartDate(receivedStart);
                $('#receivedDateRange').data('daterangepicker').setEndDate(receivedEnd);
                $('#receivedDateRange .form-control').val(receivedStart + ' / ' + receivedEnd).trigger('change');
                toggleCloseVisibility('closeReceivedDateRange', true);
            }

            function setNextReceivedDateRange() {
                let nextDates = calculateNextDateRange(moment(receivedStart).format('YYYY-MM-DD'), moment(receivedEnd).format('YYYY-MM-DD'));
                receivedStart = moment(nextDates.nextFromDate).format('MM/DD/YYYY');
                receivedEnd = moment(nextDates.nextToDate).format('MM/DD/YYYY');
                $('#receivedDateRange').data('daterangepicker').setStartDate(receivedStart);
                $('#receivedDateRange').data('daterangepicker').setEndDate(receivedEnd);
                $('#receivedDateRange .form-control').val(receivedStart + ' / ' + receivedEnd).trigger('change');
                toggleCloseVisibility('closeReceivedDateRange', true);
            }

            $("#nextReceivedDateRange").on("click", function () {
                if (receivedStart && receivedEnd) {
                    setNextReceivedDateRange();
                } else {
                    msgbox("Please select received date range.", "", "warning");
                }
            });
            $("#previousReceivedDateRange").on("click", function () {
                if (receivedStart && receivedEnd) {
                    setPreviousReceivedDateRange();
                } else {
                    msgbox("Please select received date range.", "", "warning");
                }
            });
            function setPreviousPostDateRange() {
                let previousDates = calculatePreviousDateRange(moment(postStart).format('YYYY-MM-DD'), moment(postEnd).format('YYYY-MM-DD'));
                let newStart = moment(previousDates.progressFromDate);
                let minDate = $('#postDateRange').data('daterangepicker').minDate;
                if (newStart.isBefore(minDate)) {
                    msgbox("Selection cannot be made before the data availability date.", "", "warning");
                    return;
                }
                postStart = newStart.format("MM/DD/YYYY");
                postEnd = moment(previousDates.progressToDate).format("MM/DD/YYYY");
                $('#postDateRange').data('daterangepicker').setStartDate(postStart);
                $('#postDateRange').data('daterangepicker').setEndDate(postEnd);
                $('#postDateRange .form-control').val(postStart + ' / ' + postEnd).trigger('change');
                toggleCloseVisibility('closePostDateRange', true);
            }

            function setNextPostDateRange() {
                let nextDates = calculateNextDateRange(moment(postStart).format('YYYY-MM-DD'), moment(postEnd).format('YYYY-MM-DD'));
                postStart = moment(nextDates.nextFromDate).format('MM/DD/YYYY');
                postEnd = moment(nextDates.nextToDate).format('MM/DD/YYYY');
                $('#postDateRange').data('daterangepicker').setStartDate(postStart);
                $('#postDateRange').data('daterangepicker').setEndDate(postEnd);
                $('#postDateRange .form-control').val(postStart + ' / ' + postEnd).trigger('change');
                toggleCloseVisibility('closePostDateRange', true);
            }

            $("#nextPostDateRange").on("click", function () {
                if (postStart && postEnd) {
                    setNextPostDateRange();
                } else {
                    msgbox("Please select post date range.", "", "warning");
                }
            });
            $("#previousPostDateRange").on("click", function () {
                if (postStart && postEnd) {
                    setPreviousPostDateRange();
                } else {
                    msgbox("Please select post date range.", "", "warning");
                }
            });
            function selectNextAdvisoryPayee() {
                const $selectElement = $('#advisoryPayee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousAdvisoryPayee() {
                const $selectElement = $('#advisoryPayee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextAdvisoryPayee").on("click", function () {
                selectNextAdvisoryPayee();
            });
            $("#previousAdvisoryPayee").on("click", function () {
                selectPreviousAdvisoryPayee();
            });
            function setPreviousDosDateRange() {
                let previousDates = calculatePreviousDateRange(moment(dosStart).format('YYYY-MM-DD'), moment(dosEnd).format('YYYY-MM-DD'));
                let newStart = moment(previousDates.progressFromDate);
                let minDate = $('#dosDateRange').data('daterangepicker').minDate;
                if (newStart.isBefore(minDate)) {
                    msgbox("Selection cannot be made before the data availability date.", "", "warning");
                    return;
                }
                dosStart = newStart.format("MM/DD/YYYY");
                dosEnd = moment(previousDates.progressToDate).format("MM/DD/YYYY");
                $('#dosDateRange').data('daterangepicker').setStartDate(dosStart);
                $('#dosDateRange').data('daterangepicker').setEndDate(dosEnd);
                $('#dosDateRange .form-control').val(dosStart + ' / ' + dosEnd).trigger('change');
                toggleCloseVisibility('closeDosDateRange', true);
            }

            function setNextDosDateRange() {
                let nextDates = calculateNextDateRange(moment(dosStart).format('YYYY-MM-DD'), moment(dosEnd).format('YYYY-MM-DD'));
                dosStart = moment(nextDates.nextFromDate).format('MM/DD/YYYY');
                dosEnd = moment(nextDates.nextToDate).format('MM/DD/YYYY');
                $('#dosDateRange').data('daterangepicker').setStartDate(dosStart);
                $('#dosDateRange').data('daterangepicker').setEndDate(dosEnd);
                $('#dosDateRange .form-control').val(dosStart + ' / ' + dosEnd).trigger('change');
                toggleCloseVisibility('closeDosDateRange', true);
            }

            $("#nextDosDateRange").on("click", function () {
                if (dosStart && dosEnd) {
                    setNextDosDateRange();
                } else {
                    msgbox("Please select dos date range.", "", "warning");
                }
            });
            $("#previousDosDateRange").on("click", function () {
                if (dosStart && dosEnd) {
                    setPreviousDosDateRange();
                } else {
                    msgbox("Please select dos date range.", "", "warning");
                }
            });
            function selectNextPostingPayee() {
                const $selectElement = $('#postingPayee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousPostingPayee() {
                const $selectElement = $('#postingPayee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextPostingPayee").on("click", function () {
                selectNextPostingPayee();
            });
            $("#previousPostingPayee").on("click", function () {
                selectPreviousPostingPayee();
            });
            function setPreviousDosDateRangePosting() {
                let previousDates = calculatePreviousDateRange(moment(dosStartPosting).format('YYYY-MM-DD'), moment(dosEndPosting).format('YYYY-MM-DD'));
                let newStart = moment(previousDates.progressFromDate);
                let minDate = $('#dosDateRange').data('daterangepicker').minDate;
                if (newStart.isBefore(minDate)) {
                    msgbox("Selection cannot be made before the data availability date.", "", "warning");
                    return;
                }
                dosStartPosting = newStart.format("MM/DD/YYYY");
                dosEndPosting = moment(previousDates.progressToDate).format("MM/DD/YYYY");
                $('#dosDateRangePosting').data('daterangepicker').setStartDate(dosStartPosting);
                $('#dosDateRangePosting').data('daterangepicker').setEndDate(dosEndPosting);
                $('#dosDateRangePosting .form-control').val(dosStartPosting + ' / ' + dosEndPosting).trigger('change');
                toggleCloseVisibility('closeDosDateRangePosting', true);
            }

            function setNextDosDateRangePosting() {
                let nextDates = calculateNextDateRange(moment(dosStartPosting).format('YYYY-MM-DD'), moment(dosEndPosting).format('YYYY-MM-DD'));
                dosStartPosting = moment(nextDates.nextFromDate).format('MM/DD/YYYY');
                dosEndPosting = moment(nextDates.nextToDate).format('MM/DD/YYYY');
                $('#dosDateRangePosting').data('daterangepicker').setStartDate(dosStartPosting);
                $('#dosDateRangePosting').data('daterangepicker').setEndDate(dosEndPosting);
                $('#dosDateRangePosting .form-control').val(dosStartPosting + ' / ' + dosEndPosting).trigger('change');
                toggleCloseVisibility('closeDosDateRangePosting', true);
            }

            $("#nextDosDateRangePosting").on("click", function () {
                if (dosStartPosting && dosEndPosting) {
                    setNextDosDateRangePosting();
                } else {
                    msgbox("Please select dos date range.", "", "warning");
                }
            });
            $("#previousDosDateRangePosting").on("click", function () {
                if (dosStartPosting && dosEndPosting) {
                    setPreviousDosDateRangePosting();
                } else {
                    msgbox("Please select dos date range.", "", "warning");
                }
            });
            function selectNextPaymentStatus() {
                const $sel = $('#paymentStatus');
                const idx = $sel.prop('selectedIndex');
                if (idx < $sel.find('option').length - 1) {
                    $sel.prop('selectedIndex', idx + 1).trigger('change');
                }
            }
            function selectPreviousPaymentStatus() {
                const $sel = $('#paymentStatus');
                const idx = $sel.prop('selectedIndex');
                if (idx > 1) {
                    $sel.prop('selectedIndex', idx - 1).trigger('change');
                }
            }
            $("#nextPaymentStatus").on("click", selectNextPaymentStatus);
            $("#previousPaymentStatus").on("click", selectPreviousPaymentStatus);
            function selectNextJobId() {
                const $sel = $('#filterJobId');
                const idx = $sel.prop('selectedIndex');
                if (idx < $sel.find('option').length - 1) {
                    $sel.prop('selectedIndex', idx + 1).trigger('change');
                }
            }
            function selectPreviousJobId() {
                const $sel = $('#filterJobId');
                const idx = $sel.prop('selectedIndex');
                if (idx > 1) {
                    $sel.prop('selectedIndex', idx - 1).trigger('change');
                }
            }
            $("#nextJobId").on("click", selectNextJobId);
            $("#previousJobId").on("click", selectPreviousJobId);
        });
</script>   
