<%-- 
    Document   : viewOaClaim
    Created on : Mar 30, 2026, 12:02:29 PM
    Author     : Raja
--%>

<%@page contentType="text/html"  pageEncoding="UTF-8" autoFlush="true"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>

<head>
    <title>OA Claim</title>
    <style>
        .select-container {
            position: relative;
        }
        .js-select-placeholder-multiple {
            width: 100%;
        }
        .close {
            position: absolute;
            top: 10%;
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
            top: 2%;
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
                                    <ul class="nav nav-pills" id="myTab" role="tablist">                                       
                                        <li class="nav-item">
                                            <a class="nav-link text-uppercase" id="header-tab" tabindex="3"  data-toggle="tab" href="#oaHeader" role="tab" aria-controls="oaheader" aria-selected="false">Header</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-uppercase" id="lineitem-tab" tabindex="4"  data-toggle="tab" href="#lineitem" role="tab" aria-controls="lineitem" aria-selected="false">LineItem</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-uppercase" id="rework-tab" tabindex="5"  data-toggle="tab" href="#rework" role="tab" aria-controls="rework" aria-selected="false">Rework</a>
                                        </li>                                       
                                    </ul>
                                    <div class="tab-content" id="myTabContent">       
                                        <div class="tab-pane fade show" id="oaHeader" role="tabpanel" aria-labelledby="header-tab">
                                            <div class="dt-responsive table-responsive tablehide" style="width:100%;">
                                                <table id="simpletable1" width="100%" class="table table-bordered nowrap" >
                                                    <thead style="color:#768ba0;">
                                                        <tr>
                                                            <th style="position: sticky; top: 0; z-index: 1;" ><input id="headercheck" type="checkbox"></th>
                                                            <th data-element="tid">Id</th>
                                                            <th data-element="header_id">Header Id</th>
                                                            <th data-element="Acct_name">Account</th>
                                                            <th data-element="claim_index_id">Claim Index</th>
                                                            <th data-element="status">Status</th>
                                                            <th data-element="fileid">File id</th>
                                                            <th data-element="claimid">Claim No</th>
                                                            <th data-element="payor">Payor</th>
                                                            <th data-element="recdate">Received Date</th> 
                                                            <th data-element="name">Patient</th>
                                                            <th data-element="patacctnum">Account No</th>
                                                            <th data-element="fromdos">From Dos</th>
                                                            <th data-element="todos">To Dos</th>
                                                            <th data-element="taxid">Tax Id</th>
                                                            <th data-element="statelicenseid">Licence Id</th>
                                                            <th data-element="isuredid">Insured ID</th>
                                                            <th data-element="totalcharge">Total Charge</th>
                                                            <th data-element="errordescription">Error Desc</th>
                                                            <th data-element="createddate">CR Dt</th>
                                                            <th data-element="recordstatus">Record Status</th>
                                                            <th data-element="Filename">Filename</th>
                                                            <th data-element="InsChg_interChangeDate">InterChange Date</th>
                                                            <th data-element="837_Header_id">837 Header Id</th>
                                                            <th data-element="file_status">File Status</th>
                                                            <th>action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>                                                                  
                                                    </tbody>
                                                </table>                                                   
                                            </div> 
                                        </div> 

                                        <div class="tab-pane fade show" id="lineitem" role="tabpanel" aria-labelledby="lineitem-tab">
                                            <div class="dt-responsive table-responsive tablehide" style="width:100%;">
                                                <table id="simpletable2" width="100%" class="table table-bordered nowrap" >
                                                    <thead style="color:#768ba0;">
                                                        <tr>
                                                            <th style="position: sticky; top: 0; z-index: 1;" ><input id="advHeaderCheck" type="checkbox"></th>
                                                            <th data-element="lid">Lid</th>
                                                            <th data-element="Acct_name">Account</th>
                                                            <th data-element="claimno">Claim No</th>
                                                            <th data-element="remdering_id">Remdering Id</th>
                                                            <th data-element="dos_from">Dos From</th>
                                                            <th data-element="dos_to">Dos To</th>
                                                            <th data-element="segment">Service Place</th>
                                                            <th data-element="emg">emg</th>
                                                            <th data-element="cpt">cpt</th>
                                                            <th data-element="modifier_a">modifier a</th>
                                                            <th data-element="modifier_b">modifier b</th>
                                                            <th data-element="modifier_c">modifier c</th> 
                                                            <th data-element="modifier_d">modifier d</th>
                                                            <th data-element="totalcharge">Total Charge</th>
                                                            <th data-element="diagnosis_pointer">Diagnosis</th>
                                                            <th data-element="charges">Charges</th>                                                          
                                                            <th data-element="days_units">Days Units</th>
                                                            <th data-element="id_qual">Id Qual</th>                                                            
                                                            <th data-element="rendering_npi">Rend_NPI</th>
                                                            <th data-element="header_id">HeaderId</th>
                                                            <th data-element="claim_index_id">Claim Index Id</th>
                                                            <th data-element="l_index">L index</th>
                                                            <th data-element="Filename">Filename</th>
                                                            <th data-element="InsChg_interChangeDate">InterChange Date</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>                                                                  
                                                    </tbody>
                                                </table>                                                   
                                            </div> 
                                        </div>   

                                        <div class="tab-pane fade show" id="rework" role="tabpanel" aria-labelledby="rework-tab">
                                            <div class="dt-responsive table-responsive tablehide" style="width:100%;">
                                                <table id="simpletable3" width="100%" class="table table-bordered nowrap" >
                                                    <thead style="color:#768ba0;">
                                                        <tr>
                                                            <th style="position: sticky; top: 0; z-index: 1;" ><input id="postingHeaderCheck" type="checkbox"></th>
                                                            <th data-element="rid">Rid</th>
                                                            <th data-element="Filename">Filename</th>
                                                            <th data-element="Acct_name">Account</th>
                                                            <th data-element="claimno">Claim No</th>
                                                            <th data-element="patientName">Patient</th>
                                                            <th data-element="dos_from">Dos From</th>
                                                            <th data-element="dos_to">Dos To</th>
                                                            <th data-element="header_id">HeaderId</th>
                                                            <th data-element="HeaderID">Header_id</th>
                                                            <th data-element="1a_insuredidnumber">Insurance Id</th>
                                                            <th data-element="9d_insuranceplanname">Ins Plan</th> 
                                                            <th data-element="26_patientaccountno">Pat Acc</th>
                                                            <th data-element="28_totalcharge">Total Charge</th>
                                                            <th data-element="33_renderingprovider">Rend Prov</th>
                                                            <th data-element="33a_billingnpi">Billing Npi</th>
                                                            <th data-element="CL_claimIndex">Cl Claim Index</th>
                                                            <th data-element="claim_index_id">Claim Index Id</th>
                                                            <th data-element="rendering_provider_npi">Rend Prov Npi</th>
                                                            <th data-element="P_Type">P type</th>
                                                            <th data-element="InsChg_interChangeDate">InterChange Date</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>                                                                  
                                                    </tbody>
                                                </table>                                                   
                                            </div> 
                                        </div>
                                    </div>
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
            <!-- header table -->
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Account" name="headerPractice" id="headerPractice">
                        <option value=""></option>
                        <c:forEach var="payee" items="${payeelist}">
                            <option> ${payee.payee} </option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="closeHeaderPractice">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousPaymentPractice">&#11165;</span> 
                            <span class="down-arrow" id="nextPaymentPractice">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class='input-group pull-right col-11 p-0' id='dosDateRange' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select Dos date range" style="height: 34px;"/>
                </div>
                <span id="closeDosDateRange" class="close-btn">&times;</span>
                <div class="input-group-append" style="float: right; position: relative; margin-top:-34px;">
                    <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                        <span class="up-arrow" id="previousDosDateRange">&#11165;</span> 
                        <span class="down-arrow" id="nextDosDateRange">&#11167;</span>
                    </span>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0" style="">
                <div class='input-group pull-right col-11 p-0' id='claimDateRange' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select Claim date range" style="height: 34px;"/>
                </div>
                <span id="closeClaimDateRange" class="close-btn">&times;</span>
                <div class="input-group-append" id="" style="float: right; position: relative; margin-top: -34px;">
                    <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                        <span class="up-arrow" id="previousClaimDateRange">&#11165;</span> 
                        <span class="down-arrow" id="nextClaimDateRange">&#11167;</span>
                    </span>
                </div>
            </div> 

            <div class="col-lg-12 m-b-10 p-0" style="">
                <div class='input-group pull-right col-11 p-0' id='receivedDateRange' >
                    <div class='input-group-append'>
                        <span class="input-group-text arrow-box" style="padding:5px 8px!important;height:34px; border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                    </div>
                    <input type='text' readonly="" class="form-control" placeholder="Select Received Date range" style="height: 34px;"/>
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
                <div class="select-container ">
                    <input type="text" class="form-control" id="headerFileName" placeholder="Enter File Name"/>
                    <span id="closeHeaderFileName" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>              

            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="headerClaimNo" placeholder="Enter Claim No"/>
                    <span id="closeheaderClaimNo" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>

            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select File Status" name="headerFileStatus" id="headerFileStatus">
                        <option value=""></option>
                        <option value="Completed">Completed</option>
                        <option value="Active">Staging</option>
                        <option value="Exception">Exception</option>
                    </select>
                    <span class="close-btn" id="closeHeaderFileStatus">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousFileStatus">&#11165;</span> 
                            <span class="down-arrow" id="nextFileStatus">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-lg-12 m-b-10 p-0">
                <div class="select-container ">
                    <input type="text" class="form-control" id="headerCpt" placeholder="Enter CPT"/>
                    <span id="closeHeaderCpt" class="close-btn" style="display:none; right:10px!important;">&times;</span>
                </div>
            </div>
            <div class="row searchEvent">
                <div class="col-md-12  p-r-5"> 
                    <button id="showall" class="btn btn-primary float-right" style="padding:6px 22px!important;">Reset</button>
                    <button id="search" class="btn btn-success float-right" style="padding:6px 22px!important;">Search</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="modalConfirmYesNo" class="modal fade draggable-modal">
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
<div class="modal fade md-effect-1 draggable-modal" id="modal-1" tabindex="-1" role="dialog"
     data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog modal-md" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Edit Payment</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form method="post" action="edit-payment" id="editPaymentForm" modelAttribute="editPayment">
                    <input type="hidden" name="ecwPaymentId" id="paymentId">
                    <div class="form-group">
                        <label>Check No <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="checkNo" id="echeckNo" required>
                    </div>
                    <div class="form-group">
                        <label>Check Date <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" name="checkDate" id="echeckDate" required>
                    </div>
                    <div class="form-group">
                        <label>Check Amount <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="checkAmount"
                               id="echeckAmount" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label>Status <span class="text-danger">*</span></label>
                        <select  class="form-control js-select-placeholder-multiple" data-placeholder="Select Status" name="status" id="estatus" required>
                            <option value="">-- Select Status --</option>
                            <option value="Active">Staging</option>
                            <option value="Deleted">Deleted</option>
                            <option value="Exception">Exception</option>
                        </select>
                    </div>
                    <div class="modal-footer p-0 pt-3">
                        <button type="submit" id="submitButton"
                                class="btn btn-warning btn-rounded">
                            Submit
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="statusModal">
    <div class="modal-dialog" style="max-width: 30rem;">
        <div class="modal-content">
            <div class="modal-body">
                <label>Status <span class="text-danger">*</span></label>
                <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Status" name="status" id="uStatus" required>
                    <option value="">-- Select Status --</option>
                    <option value="Exception">Exception</option>
                    <option value="Deleted">Deleted</option>
                    <option value="Active">Staging</option>
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
    <script src="assets/js/select-handler.js?v=10"></script>
    <script src="assets/js/calculatePreviousDateRange.js"></script>
    <script src="assets/js/calculateNextDateRange.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
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
            var receivedStart, receivedEnd, dosStart, dosEnd, claimStart, claimEnd;
            // $("#styleSelector").hide();
            //$("#summary").hide();

            $('#header-tab').trigger('click');

            toggleCloseVisibility('closeHeaderPractice', false);
            toggleCloseVisibility('closeDosDateRange', false);
            toggleCloseVisibility('closeClaimDateRange', false);
            toggleCloseVisibility('closeReceivedDateRange', false);
            toggleCloseVisibility('closeHeaderFileName', false);
            toggleCloseVisibility('closeHeaderClaimNo', false);
            toggleCloseVisibility('closeHeaderFileStatus', false);
            toggleCloseVisibility('closeHeaderCpt', false);

            closeButton("#headerPractice", "#closeHeaderPractice");
            closeButton("#dosDateRange", "#closeDosDateRange");
            closeButton("#claimDateRange", "#closeClaimDateRange");
            closeButton("#receivedDateRange", "#closeReceivedDateRange");
            closeButton("#headerFileName", "#closeHeaderFileName");
            closeButton("#headerClaimNo", "#closeHeaderClaimNo");
            closeButton("#headerFileStatus", "#closeHeaderFileStatus");
            closeButton("#headerCpt", "#closeHeaderCpt"); 
            
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

            $('#claimDateRange').daterangepicker({
                buttonClasses: ' btn',
                applyClass: 'btn-primary',
                cancelClass: 'btn-secondary',
                startDate: claimStart,
                endDate: claimEnd,
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
                claimStart = startVal.format('YYYY-MM-DD');
                claimEnd = endVal.format('YYYY-MM-DD');
                $('#claimDateRange .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                toggleCloseVisibility('closeClaimDateRange', true);
            });

            $('#closeClaimDateRange').on('click', function () {
                $('#claimDateRange .form-control').val('');
                claimStart = '';
                claimEnd = '';
                toggleCloseVisibility('closeClaimDateRange', false);
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

            function showFiltersForTableById(tableId) {
                $("#adjustmentCardBody > div").not('.searchEvent').hide();
                $("#summary").hide();
                $("#adjustmentCardBody")
                        .find("input, select")
                        .not(".searchEvent input")   // keep search button safe
                        .val("");
                dosStart = dosEnd = null;
                claimStart = claimEnd = null;
                receivedStart = receivedEnd = null;
                switch (tableId) {
                    case "header-tab":
                        $("#headerPractice").closest(".col-lg-12").show();
                        $("#dosDateRange").closest(".col-lg-12").show();
                        $("#claimDateRange").closest(".col-lg-12").show();
                        $("#receivedDateRange").closest(".col-lg-12").show();
                        $("#headerFileName").closest(".col-lg-12").show();
                        $("#headerClaimNo").closest(".col-lg-12").show();
                        $('#headerFileStatus').closest(".col-lg-12").show();
                        $('#headerCpt').closest(".col-lg-12").hide();
                        break;
                    case "lineitem-tab":
                        $("#headerPractice").closest(".col-lg-12").show();
                        $("#dosDateRange").closest(".col-lg-12").show();
                        $("#claimDateRange").closest(".col-lg-12").show();
                        $("#receivedDateRange").closest(".col-lg-12").show();
                        $("#headerFileName").closest(".col-lg-12").show();
                        $("#headerClaimNo").closest(".col-lg-12").show();
                        $('#headerFileStatus').closest(".col-lg-12").hide();
                        $('#headerCpt').closest(".col-lg-12").show();
                        break;
                    case "rework-tab":
                        $("#headerPractice").closest(".col-lg-12").show();
                        $("#dosDateRange").closest(".col-lg-12").show();
                        $("#claimDateRange").closest(".col-lg-12").show();
                        $("#receivedDateRange").closest(".col-lg-12").show();
                        $("#headerFileName").closest(".col-lg-12").show();
                        $("#headerClaimNo").closest(".col-lg-12").show();
                        $('#headerFileStatus').closest(".col-lg-12").hide();
                        $('#headerCpt').closest(".col-lg-12").hide();
                        break;
                }
            }

            $(document).on("shown.bs.tab", 'a[data-bs-toggle="tab"], a[data-toggle="tab"]', function (e) {
                $("#styleSelector").hide();
                var tabId = $(e.target).attr("id");
                showFiltersForTableById(tabId);
                $('#search').click();
                if (tabId === "home-tab") {
                    $("#styleSelector").hide();
                } else {
                    $("#styleSelector").show();
                }
            });

            showFiltersForTableById("header-tab");
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
                $('#headercheck').prop('checked', false);
                $('#simpletable1 tbody input[type=checkbox]').each(function () {
                    $(this).prop('checked', false);
                    if (checked > 0) {
                        checked--;
                    }
                });
            }



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
                var visibleColumns = headerTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                location.href = "export-header-data-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction();
            }

            function exportCurrentPaymentTable(exportType) {
                var visibleColumns = headerTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                if (checkedIndexes.length > 0) {
                    location.href = "export-header-data-report?startIndex=" + checkedIndexes[0] + "&endIndex=" + checkedIndexes[checkedIndexes.length - 1] + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                } else {
                    location.href = "export-header-data-report?startIndex=0&endIndex=" + (currentTableResponse.length - 1) + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                }
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction();
            }

            function exportAllPayment(exportType) {
                var visibleColumns = headerTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $.ajax({
                    url: 'oa-claim-tracker-header-data',
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
                        location.href = "export-header-data-report?startIndex=-1&endIndex=-1&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                        $('.loader1').addClass("process-hide");
                        $('#flading').hide();
                        $('#export-flading').hide();
                        deselectAllFunction();
                    }
                });
            }

            function handleOrderChange1(settings) {
                var headerTable = $('#simpletable1').DataTable();
                var currentOrder = headerTable.order();
                if (currentOrder.length > 0) {
                    var columnIndex = currentOrder[0][0];
                    var sortingDirection = currentOrder[0][1];
                    var column = headerTable.column(columnIndex);
                    var dataElement = column.header().getAttribute('data-element') || "";
                    orderData = sortingDirection ? [{"columnName": dataElement, "dir": sortingDirection}] : [];
                } else {
                    orderData = [];
                }
            }
            var exportType;
            var columnsList = ${columnsList};
            var headerTable = $('#simpletable1').DataTable({
                "aaSorting": [],
                "pageLength": 100,
                "lengthMenu": [10, 30, 50, 100, 200, 500],
                stateSave: true,
                scrollY: "350px",
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                fixedHeader: false,
                "oLanguage": {
                    "sEmptyTable": "No Data..."
                },
                "columnDefs": [
                    {'visible': false, 'targets': [2, 4, 5, 6, 9, 14, 15, 16, 18, 19, 20, 23]}
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
                    "url": 'oa-claim-tracker-header-data',
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
                    {"data": function (data) {
                            return '<span class="tId-cell" data-value="' + data.tid + '" data-filename="' + data.filename + '" data-acctname="' + data.account_no + '">' + data.tid + '</span>';
                        }, "orderable": true, "searchable": true, "name": "tid"},
                    {"data": "headerId", "orderable": true, "searchable": true, "name": "headerId"},
                    {"data": "account_no", "orderable": true, "searchable": true, "name": "account_no"},
                    {"data": "claimIndex", "orderable": true, "searchable": true, "name": "claimIndex"},
                    {"data": "status", "orderable": true, "searchable": true, "name": "status"},
                    {"data": "fileId", "orderable": true, "searchable": true, "name": "fileId"},
                    {"data": "claimno", "orderable": true, "searchable": true, "name": "claimId"},
                    {"data": function (data) {
                            return '<span class="payer-cell" style="white-space:break-spaces" data-value="' + data.payorName + '">' + data.payorName + '</span>';
                        }, "orderable": true, "searchable": true, "name": "payorName"},
                    {"data": "recdate", "orderable": true, "searchable": true, "name": "recdate"},
                    {"data": "patient", "orderable": true, "searchable": true, "name": "patient"},
                    {"data": "pataccno", "orderable": true, "searchable": true, "name": "pataccno"},
                    {"data": "fromdos", "orderable": true, "searchable": true, "name": "fromdos"},
                    {"data": "todos", "orderable": true, "searchable": true, "name": "todos"},
                    {"data": "taxid", "orderable": true, "searchable": true, "name": "taxid"},
                    {"data": "stalinid", "orderable": true, "searchable": true, "name": "stalinid"},
                    {"data": "insid", "orderable": true, "searchable": true, "name": "insid"},
                    {"data": "totalCharge", "orderable": true, "searchable": true, "name": "totalCharge"},
                    {"data": "errdes", "orderable": true, "searchable": true, "name": "errdes"},
                    {"data": "createdDate", "orderable": true, "searchable": true, "name": "createdDate"},
                    {"data": "recordStatus", "orderable": true, "searchable": true, "name": "recordStatus"},
                    {"data": "filename", "orderable": true, "searchable": true, "name": "filename"},
                    {"data": "interChangeDate", "orderable": true, "searchable": true, "name": "interChangeDate"},
                    {"data": "header837Id", "orderable": true, "searchable": true, "name": "header837Id"},
                    {"data": function (data) {
                            if (data.fileStatus === "Completed") {
                                return '<a href="#" data-value=' + data.fileStatus + ' class="badge badge-light-success status-cell f-12 m-r-5">' + data.fileStatus + '</a>';
                            } else if (data.fileStatus === "Active") {
                                return '<a href="#" data-value=' + data.fileStatus + ' class="badge badge-light-primary status-cell f-12 m-r-5">Stagging</a>';
                            } else if (data.fileStatus === "Exception") {
                                return '<a href="#" data-value=' + data.fileStatus + ' class="badge badge-light-danger2 status-cell f-12 m-r-5"> Exception </a>';
                            } else {
                                return " " + data.fileStatus;
                            }
                        }, "orderable": true, "searchable": true, "name": "status"},
                    {"data": function (data) {
                         let voidOption = '';
                         let fileStatus = data.fileStatus;
                            if (fileStatus === "Exception" || fileStatus === "Active") {
                                  voidOption = ' <a aria-label="Delete" role="tooltip"  data-microtip-position="left" id="deleteHeader" class="deleteOaClaim" ><i class="fas fa-trash-alt" style="font-size:15px; margin:0 3px;color:#FF425C;"></i></a>';
                            }
                             return voidOption;
                            }, "orderable": false, "searchable": false, "name": "action"}
                ], dom:'<"d-flex justify-content-between align-items-center mb-2"B f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                buttons: [
            <sec:authorize access="hasAuthority('OFFICE_ALLY_CLAIMS_TRIGGER_PRIVILEGE')">
                    {
                        className: 'dt-pdf-btn ',
                        text: '<img src="assets/images/automation.png" style="width:25px;height:25px;">',
                        titleAttr: 'Manual Trigger',
                        action: function (e, dt, node, config) {
                            callTriggerClaim();
                        }
                    }, {
                        className: 'dt-pdf-btn ',
                        text: '<img src="assets/images/exception.png" style="width:25px;height:25px;">',
                        titleAttr: 'Exception Trigger',
                        action: function (e, dt, node, config) {
                            callExceptionClaim();
                        }
                    }, 
                    {
                    className: 'dt-pdf-btn ',
                    text: '<img src="assets/images/edit.png" style="width:25px;height:25px;">',
                    titleAttr: 'Update Status',
                    action: function (e, dt, node, config) {
                    updateStatus();
                    }},
            </sec:authorize>
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
                        extend: 'colvis',
                        className: 'btn-outline-secondary btn-sm ',
                        text: 'Columns <i class="fas fa-plus m-r-5 m-l-5" style="font-size:9px"></i>/<i class="fas fa-minus m-l-5" style="font-size:9px;"></i> ',
                        columns: columnsList
                    }
                ],
                createdRow: function (row, data, dataIndex) {
                    // initializeTooltips(row, data);
                    if (data.status === "Deleted") {
                        $(row).find('td').not(':eq(12)').attr(
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
                headerTable.ajax.reload(null, false);
            });

            headerTable.on('search.dt', function () {
                $("#flading").show();
                searchValueDt = getModifiedSearchValue(headerTable.search().trim());
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

            $('#btnStatusSubmit').click(function () {
                var table = $('#simpletable1').DataTable();
                var selectedFileNames = [];
                var selectedAcctNames = [];
                table.$('input[type="checkbox"]:checked').each(function () {
                    let tr = $(this).closest('tr');
                    let rowData = table.row(tr).data();
                    if (rowData) {
                        selectedFileNames.push(rowData.filename);
                        selectedAcctNames.push(rowData.account_no);
                    }
                });
                var selectedStatus = $("#uStatus").val();
                if (selectedStatus.length === 0) {
                    msgbox("Please select status", "", "warning");
                    return;
                }
                if (selectedFileNames.length === 0) {
                    msgbox("Please select at least one record", "", "warning");
                    return;
                }
                $.ajax({
                    url: "update-oa-claim-status",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        fileNames: selectedFileNames,
                        acctNames: selectedAcctNames,
                        fileStatus: selectedStatus
                    }),
                    success: function (response) {
                        if (response === "Success") {
                            $('#statusModal').modal('hide');
                            headerTable.ajax.reload(null, false);
                            lineitemTable.ajax.reload(null, false);
                            reworkTable.ajax.reload(null, false);
                            deselectAllFunction();
                            msgbox("Updated Successfully!", "", "success");
                        }
                    },
                    error: function () {
                        msgbox("Something went wrong!", "", "error");
                    }
                });
            });

            $(document).on("click", "#simpletable1 a.deleteOaClaim", function () {
                let tableRow = $(this).closest('tr');
                let filename = tableRow.find('.tId-cell').attr('data-filename');
                let acctName = tableRow.find('.tId-cell').attr('data-acctname');
                $("#lblMsgConfirmYesNo").text("Are you sure you want to delete?");
                $("#modalConfirmYesNo").modal("show");
                $("#btnYesConfirmYesNo").off().on("click", function () {
                    $("#modalConfirmYesNo").modal("hide");
                    $.ajax({
                        url: "delete-oa-claim",
                        type: "get",
                        data: {
                            filename: $.trim(filename),
                            acctName: $.trim(acctName)
                        },
                        success: function (response) {
                            if (response.length > 0) {
                                msgbox("Deleted", "", "success");
                                headerTable.ajax.reload(null, false);
                            }
                        },
                        error: function (err) {
                            msgbox("Error", "", "error");
                        }
                    });
                });
                $("#btnNoConfirmYesNo").off().on("click", function () {
                    $("#modalConfirmYesNo").modal("hide");
                });
            });   

            var claimIdList = [];
            function callTriggerClaim() {                
                claimIdList = [];
                $('.check:checked').each(function () {
                    let tr = $(this).closest('tr');
                    let claimId = tr.find('.tId-cell').attr('data-value');
                    if (claimId) {
                        claimIdList.push(claimId);
                    }
                });
            if (claimIdList.length === 0) {
                msgbox("Please select at least one record!", "", "warning");
               return;
            }
               /* if (claimIdList.length === 0) {
                    console.log("No selection → sending all records");
                    $('#simpletable1 tbody tr').each(function () {
                        let claimId = $(this).find('.tId-cell').attr('data-value');
                        if (claimId) {
                            claimIdList.push(claimId);
                        }
                    });
                } */
                console.log("Final claimIdList:", claimIdList);
                $('#export-flading').show();
                $.ajax({
                    url: "trigger-oa-claim-header",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(claimIdList),
                    success: function (response) {
                        console.log(response);

                        if (response === "Success") {
                            setTimeout(function () {
                                msgbox("Data imported successfully!", "", "success");
                                headerTable.ajax.url("oa-claim-tracker-header-data").load();
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
            
            var claimExceptionList = [];
            function callExceptionClaim() {
                claimExceptionList = [];
                $('.check:checked').each(function () {
                    let tr = $(this).closest('tr');
                    let claimId = tr.find('.tId-cell').attr('data-value');
                    if (claimId) {
                        claimExceptionList.push(claimId);
                    }
                });
                if (claimExceptionList.length === 0) {
                    msgbox("Please select at least one record!", "", "warning");
                    return;
                }

                $('#export-flading').show();
                $.ajax({
                    url: "move-oa-claim-stage-to-exception-status",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(claimExceptionList),
                    success: function (response) {
                        console.log(response);
                        if (response === "Success") {
                            setTimeout(function () {
                                msgbox("Data updated to Exception successfully!", "", "success");
                                headerTable.ajax.url("oa-claim-tracker-header-data").load();
                                $('#export-flading').hide();
                            }, 2000);
                        } else {
                            msgbox("Unexpected response", "", "warning");
                            deselectAllFunction();
                            $('#export-flading').hide();
                        }
                    },
                    error: function (err) {
                        msgbox("Error while processing request!", "", "error");
                        $('#export-flading').hide();
                    }
                });
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

            function exportLineitemTable(exportType) {
                if (isCheckAllClicked === 0 && checkedIndexes.length > 0) {
                    exportSelectionLineitem(exportType);
                } else if (isCheckAllClicked === 0 && recordsFiltered > currentTableResponse.length) {
                    exportAllLineitem(exportType);
                } else {
                    exportCurrentLineitemTable(exportType);
                }
                checkedIndexes = [];
            }
            ;

            function exportSelectionLineitem(exportType) {
                var visibleColumns = lineitemTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                location.href = "export-lineitem-data-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction1();
            }

            function exportCurrentLineitemTable(exportType) {
                var visibleColumns = lineitemTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                if (checkedIndexes.length > 0) {
                    location.href = "export-lineitem-data-report?startIndex=" + checkedIndexes[0] + "&endIndex=" + checkedIndexes[checkedIndexes.length - 1] + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                } else {
                    location.href = "export-lineitem-data-report?startIndex=0&endIndex=" + (currentTableResponse.length - 1) + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                }
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction1();
            }

            function exportAllLineitem(exportType) {
                var visibleColumns = lineitemTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $.ajax({
                    url: 'oa-claim-lineitem-data',
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
                        location.href = "export-lineitem-data-report?startIndex=-1&endIndex=-1&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                        $('.loader1').addClass("process-hide");
                        $('#flading').hide();
                        $('#export-flading').hide();
                        deselectAllFunction1();
                    }
                });
            }

            function handleOrderChange2(settings) {
                var lineitemTable = $('#simpletable2').DataTable();
                var currentOrder = lineitemTable.order();
                if (currentOrder.length > 0) {
                    var columnIndex = currentOrder[0][0];
                    var sortingDirection = currentOrder[0][1];
                    var column = lineitemTable.column(columnIndex);
                    var dataElement = column.header().getAttribute('data-element') || "";
                    orderData = sortingDirection ? [{"columnName": dataElement, "dir": sortingDirection}] : [];
                } else {
                    orderData = [];
                }
            }

            var lineitemSearchValueDt = '';
            var lineitemColumnsList = ${lineitemColumnsList};
            var lineitemTable = $('#simpletable2').DataTable({
                "aaSorting": [],
                "pageLength": 100,
                "lengthMenu": [10, 30, 50, 100, 200, 500],
                stateSave: true,
                scrollY: "350px",
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                fixedHeader: false,
                "oLanguage": {
                    "sEmptyTable": "No Data..."
                },
                "columnDefs": [
                    {'visible': false, 'targets': [4, 8, 11, 12, 13, 14, 18, 20, 21, 22, 24]}
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
                    "url": 'oa-claim-lineitem-data',
                    "contentType": 'application/json',
                    "dataType": "json",
                    "data": function (d) {
                        return JSON.stringify($.extend({}, d, {
                            "multiSearchColumn": multiSearchColumn.toString(),
                            "multiSearchValue": multiSearchValue.toString(),
                            "innerSearchValue": lineitemSearchValueDt.trim(),
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
                    {"data": "id", "orderable": true, "searchable": true, "name": "id"},
                    {"data": "account", "orderable": true, "searchable": true, "name": "account"},
                    {"data": "claimno", "orderable": true, "searchable": true, "name": "claimno"},
                    {"data": "remderingId", "orderable": true, "searchable": true, "name": "remderingId"},
                    {"data": "dosFrom", "orderable": true, "searchable": true, "name": "dosFrom"},
                    {"data": "dosTo", "orderable": true, "searchable": true, "name": "dosTo"},
                    {"data": "placeOfService", "orderable": true, "searchable": true, "name": "placeOfService"},
                    {"data": "emg", "orderable": true, "searchable": true, "name": "emg"},
                    {"data": "cpt", "orderable": true, "searchable": true, "name": "cpt"},
                    {"data": "modifierA", "orderable": true, "searchable": true, "name": "modifierA"},
                    {"data": "modifierB", "orderable": true, "searchable": true, "name": "modifierB"},
                    {"data": "modifierC", "orderable": true, "searchable": true, "name": "modifierC"},
                    {"data": "modifierD", "orderable": true, "searchable": true, "name": "modifierD"},
                    {"data": "totalCharge", "orderable": true, "searchable": true, "name": "totalCharge"},
                    {"data": "diagnosisPointer", "orderable": true, "searchable": true, "name": "diagnosisPointer"},
                    {"data": "charges", "orderable": true, "searchable": true, "name": "charges"},
                    {"data": "daysUnits", "orderable": true, "searchable": true, "name": "daysUnits"},
                    {"data": "idQual", "orderable": true, "searchable": true, "name": "idQual"},
                    {"data": "renderingNpi", "orderable": true, "searchable": true, "name": "renderingNpi"},
                    {"data": "headerId", "orderable": true, "searchable": true, "name": "headerId"},
                    {"data": "claimIndex", "orderable": true, "searchable": true, "name": "claimIndex"},
                    {"data": "lIndex", "orderable": true, "searchable": true, "name": "lIndex"},
                    {"data": "fileName", "orderable": true, "searchable": true, "name": "fileName"},
                    {"data": "interChangeDate", "orderable": true, "searchable": true, "name": "interChangeDate"}
                ], dom:'<"d-flex justify-content-between align-items-center mb-2"B f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                buttons: [{
                        extend: 'colvis',
                        className: 'btn-outline-secondary btn-sm col-sm- col-lg-13',
                        text: 'Columns <i class="fas fa-plus m-r-5 m-l-5" style="font-size:9px"></i>/<i class="fas fa-minus m-l-5" style="font-size:9px;"></i> ',
                        columns: lineitemColumnsList
                    }, {
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
                                exportLineitemTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }, {
                        extend: 'pdfHtml5',
                        orientation: 'landscape',
                        text: '<img src="assets/images/pdficon.png">',
                        className: 'dt-pdf-btn',
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
                                exportLineitemTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }
                ],
                createdRow: function (row, data, dataIndex) {
                    if (data.status === "Deleted") {
                        $(row).find('td').not('pmtId-cell').attr('style', 'font-weight: bold !important; text-decoration: line-through; color:red!important;');
                    }
                }, footerCallback: function (tfoot, data, start, end, display) {
                    $("#flading").hide();
                }
            });

            showProcessing();

            $('#mobile-collapse').click(function () {
                lineitemTable.ajax.reload(null, false);
            });

            lineitemTable.on('search.dt', function () {
                $("#flading").show();
                lineitemSearchValueDt = getModifiedSearchValue(lineitemTable.search().trim());
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

            function exportReworkTable(exportType) {
                if (isCheckAllClicked === 0 && checkedIndexes.length > 0) {
                    exportSelectionRework(exportType);
                } else if (isCheckAllClicked === 0 && recordsFiltered > currentTableResponse.length) {
                    exportAllRework(exportType);
                } else {
                    exportCurrentReworkTable(exportType);
                }
                checkedIndexes = [];
            }
            ;

            function exportSelectionRework(exportType) {
                var visibleColumns = reworkTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                location.href = "export-rework-data-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction2();
            }

            function exportCurrentReworkTable(exportType) {
                var visibleColumns = reworkTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $('#flading').show();
                if (checkedIndexes.length > 0) {
                    location.href = "export-rework-data-report?startIndex=" + checkedIndexes[0] + "&endIndex=" + checkedIndexes[checkedIndexes.length - 1] + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                } else {
                    location.href = "export-rework-data-report?startIndex=0&endIndex=" + (currentTableResponse.length - 1) + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                }
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction2();
            }

            function exportAllRework(exportType) {
                var visibleColumns = reworkTable.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                var visibleColumnsParam = visibleColumns.join(',');
                $.ajax({
                    url: 'claim-rework-data',
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
                        location.href = "export-rework-data-report?startIndex=-1&endIndex=-1&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                        $('.loader1').addClass("process-hide");
                        $('#flading').hide();
                        $('#export-flading').hide();
                        deselectAllFunction2();
                    }
                });
            }

            function handleOrderChange3(settings) {
                var reworkTable = $('#simpletable3').DataTable();
                var currentOrder = reworkTable.order();
                if (currentOrder.length > 0) {
                    var columnIndex = currentOrder[0][0];
                    var sortingDirection = currentOrder[0][1];
                    var column = reworkTable.column(columnIndex);
                    var dataElement = column.header().getAttribute('data-element') || "";
                    orderData = sortingDirection ? [{"columnName": dataElement, "dir": sortingDirection}] : [];
                } else {
                    orderData = [];
                }
            }

            var reworkSearchValueDt = '';
            var reworkColumnsList = ${reworkColumnsList};
            var reworkTable = $('#simpletable3').DataTable({
                "aaSorting": [],
                "pageLength": 100,
                "lengthMenu": [10, 30, 50, 100, 200, 500],
                stateSave: true,
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
                    {'visible': false, 'targets': [6, 7, 8, 10, 11, 12, 14, 16, 17, 19]}
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
                    "url": 'claim-rework-data',
                    "contentType": 'application/json',
                    "dataType": "json",
                    "data": function (d) {
                        return JSON.stringify($.extend({}, d, {
                            "multiSearchColumn": multiSearchColumn.toString(),
                            "multiSearchValue": multiSearchValue.toString(),
                            "innerSearchValue": reworkSearchValueDt.trim(),
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
                    {"data": "id", "orderable": true, "searchable": true, "name": "id"},
                    {"data": "fileName", "orderable": true, "searchable": true, "name": "fileName"},
                    {"data": "account", "orderable": true, "searchable": true, "name": "account"},
                    {"data": "claimNo", "orderable": true, "searchable": true, "name": "claimNo"},
                    {"data": "c2_patientfirstname", "orderable": true, "searchable": true, "name": "c2_patientfirstname"},
                    {"data": "dosFrom", "orderable": true, "searchable": true, "name": "dosFrom"},
                    {"data": "dosTo", "orderable": true, "searchable": true, "name": "dosTo"},
                    {"data": "headerId", "orderable": true, "searchable": true, "name": "headerId"},
                    {"data": "claimHeaderId", "orderable": true, "searchable": true, "name": "claimHeaderId"},
                    {"data": "c1a_insuredidnumber", "orderable": true, "searchable": true, "name": "c1a_insuredidnumber"},
                    {"data": "c9d_insuranceplanname", "orderable": true, "searchable": true, "name": "c9d_insuranceplanname"},
                    {"data": "c26_patientaccountno", "orderable": true, "searchable": true, "name": "c26_patientaccountno"},
                    {"data": "c28_totalcharge", "orderable": true, "searchable": true, "name": "c28_totalcharge"},
                    {"data": "c33_renderingprovider", "orderable": true, "searchable": true, "name": "c33_renderingprovider"},
                    {"data": "c33a_billingnpi", "orderable": true, "searchable": true, "name": "c33a_billingnpi"},
                    {"data": "claimIndexId", "orderable": true, "searchable": true, "name": "claimIndexId"},
                    {"data": "claimIndex", "orderable": true, "searchable": true, "name": "claimIndex"},
                    {"data": "rendProviderNpi", "orderable": true, "searchable": true, "name": "rendProviderNpi"},
                    {"data": "pType", "orderable": true, "searchable": true, "name": "pType"},
                    {"data": "c31_date", "orderable": true, "searchable": true, "name": "c31_date"}
                ], dom:'<"d-flex justify-content-between align-items-center mb-2"B f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                buttons: [{
                        extend: 'colvis',
                        className: 'btn-outline-secondary btn-sm col-sm- col-lg-13',
                        text: 'Columns <i class="fas fa-plus m-r-5 m-l-5" style="font-size:9px"></i>/<i class="fas fa-minus m-l-5" style="font-size:9px;"></i> ',
                        columns: reworkColumnsList
                    }, {
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
                                exportReworkTable(exportType);
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
                                exportReworkTable(exportType);
                            } else {
                                msgbox("No Records Found.", "Export Content", "warning");
                            }
                        }
                    }
                ],
                createdRow: function (row, data, dataIndex) {
                    if (data.status === "Deleted") {
                        $(row).find('td').not('pmtId-cell').attr('style', 'font-weight: bold !important; text-decoration: line-through; color:red!important;');
                    }
                }, footerCallback: function (tfoot, data, start, end, display) {
                    $("#flading").hide();
                }
            });

            showProcessing();

            $('#mobile-collapse').click(function () {
                reworkTable.ajax.reload(null, false);
            });

            reworkTable.on('search.dt', function () {
                $("#flading").show();
                reworkSearchValueDt = getModifiedSearchValue(reworkTable.search().trim());
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

            function collectFilterValuesById(tabId) {
                let filterIds = [];
                switch (tabId) {
                    case 'oaHeader':
                        filterIds = ['headerPractice', 'dosDateRange', 'claimDateRange', 'receivedDateRange', 'headerFileName', 'headerClaimNo', 'headerFileStatus'];
                        break;
                    case 'lineitem':
                        filterIds = ['headerPractice', 'dosDateRange', 'claimDateRange', 'receivedDateRange', 'headerFileName', 'headerClaimNo', 'headerFileStatus', 'headerCpt'];
                        break;
                    case 'rework':
                        filterIds = ['headerPractice', 'dosDateRange', 'claimDateRange', 'receivedDateRange', 'headerFileName', 'headerClaimNo', 'headerFileStatus', 'headerCpt'];
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
                    oaHeader: $('#simpletable1').DataTable(),
                    lineitem: $('#simpletable2').DataTable(),
                    rework: $('#simpletable3').DataTable()
                };

                const activeTable = tablesMap[activeTabId];
                if (!activeTable) {
                    console.warn('No active table found for tab:', activeTabId);
                    return;
                }

                multiSearchColumn = [];
                multiSearchValue = [];

                const filters = collectFilterValuesById(activeTabId);
                const fieldColumnMap = {
                    headerPractice: 'OAH.Acct_name',
                    dosDateRange: 'todos',
                    claimDateRange: 'recdate',
                    receivedDateRange: 'receivedDate',
                    headerFileName: 'OAH.Filename',
                    headerClaimNo: 'claimid',
                    headerFileStatus: 'OAH.file_status',
                    headerCpt: 'cpt'
                };

                $.each(filters, function (fieldId, value) {
                    if (value && value.trim().length > 0) {
                        multiSearchColumn.push(fieldColumnMap[fieldId]);
                        multiSearchValue.push(value.trim());
                    }
                });
                switch (activeTabId) {
                    case 'oaHeader':
                        if (dosStart && dosEnd) {
                            multiSearchColumn.push("todos");
                            multiSearchValue.push(moment(dosStart).format("MM/DD/YYYY") + "~" + moment(dosEnd).format("MM/DD/YYYY"));
                        }
                        if (claimStart && claimEnd) {
                            multiSearchColumn.push("recdate");
                            multiSearchValue.push(moment(claimStart).format("MM/DD/YYYY") + "~" + moment(claimEnd).format("MM/DD/YYYY"));
                        }
                        if (receivedStart && receivedEnd) {
                            multiSearchColumn.push("received_date");
                            multiSearchValue.push(moment(receivedStart).format("MM/DD/YYYY") + "~" + moment(receivedEnd).format("MM/DD/YYYY"));
                        }  
                        break;
                    case 'lineitem':
                       if (dosStart && dosEnd) {
                            multiSearchColumn.push("dos_to");
                            multiSearchValue.push(moment(dosStart).format("MM/DD/YYYY") + "~" + moment(dosEnd).format("MM/DD/YYYY"));
                        }
                        if (claimStart && claimEnd) {
                            multiSearchColumn.push("recdate");
                            multiSearchValue.push(moment(claimStart).format("MM/DD/YYYY") + "~" + moment(claimEnd).format("MM/DD/YYYY"));
                        }
                        if (receivedStart && receivedEnd) {
                            multiSearchColumn.push("received_date");
                            multiSearchValue.push(moment(receivedStart).format("MM/DD/YYYY") + "~" + moment(receivedEnd).format("MM/DD/YYYY"));
                        }
                        break;
                    case 'rework':
                        if (dosStart && dosEnd) {
                            multiSearchColumn.push("OAH.dos_to");
                            multiSearchValue.push(moment(dosStart).format("MM/DD/YYYY") + "~" + moment(dosEnd).format("MM/DD/YYYY"));
                        }
                        if (claimStart && claimEnd) {
                            multiSearchColumn.push("OCR.recdate");
                            multiSearchValue.push(moment(claimStart).format("MM/DD/YYYY") + "~" + moment(claimEnd).format("MM/DD/YYYY"));
                        }
                        if (receivedStart && receivedEnd) {
                            multiSearchColumn.push("OCR.received_date");
                            multiSearchValue.push(moment(receivedStart).format("MM/DD/YYYY") + "~" + moment(receivedEnd).format("MM/DD/YYYY"));
                        }
                        break;
                }
                activeTable.ajax.reload();
                let logJobId = $("#logJobId").val();

                const relatedTabs = ['error', 'payment', 'lineitem', 'rework'];
                const relatedJobIdFields = {
                    error: '#logJobId',
                    oaHeader: '#paymentLogJobId',
                    lineitem: '#advisoryLogJobId',
                    rework: '#postingLogJobId'
                };

                const tableSelector = {
                    error: '#simpletable',
                    oaHeader: '#simpletable1',
                    lineitem: '#simpletable2',
                    rework: '#simpletable3'
                };

                relatedTabs.forEach(tab => {
                    $(relatedJobIdFields[tab]).val(logJobId || '');
                    if (tab === activeTabId &&
                            $.fn.DataTable.isDataTable(tableSelector[tab])) {
                        $(tableSelector[tab]).DataTable().ajax.reload();
                    }
                });
                deselectAllFunction();
                deselectAllFunction1();
                deselectAllFunction2();
            });

            $('#showall').click(function () {
                $('#flading').show();
                const activeTabId = $('.tab-pane.active').attr('id');
                const tablesMap = {
                    error: $('#simpletable').DataTable(),
                    oaHeader: $('#simpletable1').DataTable(),
                    lineitem: $('#simpletable2').DataTable(),
                    rework: $('#simpletable3').DataTable()
                };

                const activeTable = tablesMap[activeTabId];
                if (!activeTable)
                    return;

                multiSearchColumn = [];
                multiSearchValue = [];
                searchValueDt = '';
                orderData = [];

                const resetMap = {
                    error: ['#logPractice', '#logDateRange', '#logJobId', '#logJobTypeList', '#logJobStatus'],
                    oaHeader: ['#headerPractice', '#dosDateRange', '#claimDateRange', '#receivedDateRange', '#headerFileName', '#headerClaimNo', '#headerFileStatus'],
                    lineitem: ['#headerPractice', '#dosDateRange', '#claimDateRange', '#receivedDateRange', '#headerFileName', '#headerClaimNo', '#headerFileStatus', '#headerCpt'],
                    rework: ['#headerPractice', '#dosDateRange', '#claimDateRange', '#receivedDateRange', '#headerFileName', '#headerClaimNo', '#headerFileStatus', '#headerCpt']
                };

                const fieldsToReset = resetMap[activeTabId] || [];
                fieldsToReset.forEach(selector => {
                    if ($(selector).is('select')) {
                        $(selector).val('').trigger('change');
                    } else {
                        $(selector).val('');
                    }
                });
                switch (activeTabId) {
                    case 'error':
                        $('#closeLogDateRange').trigger('click');
                        break;
                    case 'oaHeader':
                    case 'lineitem':
                    case 'rework':
                        $('#closeDosDateRange').trigger('click');
                        $('#closeReceivedDateRange').trigger('click');
                        $('#closeClaimDateRange').trigger('click');
                        break;
                }

                activeTable.search('').columns().search('');
                activeTable.ajax.reload();
            });

            $('#export-flading').hide();
            $('#export-flading').hide();
            function ShowConfirmYesNo(element, msg, type, ruleId, triggerElement) {
                if (type) {
                    AsyncConfirmYesNo(element,
                            "Confirmation Box",
                            msg, type, triggerElement
                            );
                }
            }

            $(document).on("click", "#simpletable a.deleteEob", function () {
                ShowConfirmYesNo($(this), "Any Related Staging EoB data will be permanently lost. Are you sure you want to proceed with deletion?", "deleteEob", "", "");
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
                    } else {
                        //callProcedure(element);
                        callTriggerClaim();
                        $("#flading").show();
                    }
                    $confirm.modal("hide");
                });
                $("#btnNoConfirmYesNo").off('click').click(function () {
                    $confirm.modal("hide");
                });
            }


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
                const $selectElement = $('#headerPractice');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousPaymentPractice() {
                const $selectElement = $('#headerPractice');
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
                let minDate = $('#dosDateRange').data('daterangepicker').minDate;
                if (newStart.isBefore(minDate)) {
                    msgbox("Selection cannot be made before the data availability date.", "", "warning");
                    return;
                }
                checkStart = newStart.format("MM/DD/YYYY");
                checkEnd = moment(previousDates.progressToDate).format("MM/DD/YYYY");
                $('#dosDateRange').data('daterangepicker').setStartDate(checkStart);
                $('#dosDateRange').data('daterangepicker').setEndDate(checkEnd);
                $('#dosDateRange .form-control').val(checkStart + ' / ' + checkEnd).trigger('change');
                toggleCloseVisibility('closeDosDateRange', true);
            }

            function setNextCheckDateRange() {
                let nextDates = calculateNextDateRange(moment(checkStart).format('YYYY-MM-DD'), moment(checkEnd).format('YYYY-MM-DD'));
                checkStart = moment(nextDates.nextFromDate).format('MM/DD/YYYY');
                checkEnd = moment(nextDates.nextToDate).format('MM/DD/YYYY');
                $('#dosDateRange').data('daterangepicker').setStartDate(checkStart);
                $('#dosDateRange').data('daterangepicker').setEndDate(checkEnd);
                $('#dosDateRange .form-control').val(checkStart + ' / ' + checkEnd).trigger('change');
                toggleCloseVisibility('closeDosDateRange', true);
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

            function selectNextAdvisoryPayee() {
                const $selectElement = $('#lineItemPayee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousAdvisoryPayee() {
                const $selectElement = $('#lineItemPayee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextLineitemPayee").on("click", function () {
                selectNextAdvisoryPayee();
            });

            $("#previousLineitemPayee").on("click", function () {
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

            function selectNextReworkPayee() {
                const $selectElement = $('#reworkPayee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousReworkPayee() {
                const $selectElement = $('#reworkPayee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextReworkPayee").on("click", function () {
                selectNextReworkPayee();
            });

            $("#ReworkPayee").on("click", function () {
                selectPreviousReworkPayee();
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
            
            function selectNextFileStatus() {
                const $selectElement = $('#headerFileStatus');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviousFileStatus() {
                const $selectElement = $('#headerFileStatus');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextFileStatus").on("click", function () {
                selectNextFileStatus();
            });

            $("#previousFileStatus").on("click", function () {
                selectPreviousFileStatus();
            });
        });
</script>   