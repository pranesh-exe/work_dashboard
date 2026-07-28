<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!--<% String  pageTitle = "ERA List";%> -->
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> ERA List</title>
        <script>
            var page = {
                bootstrap: 3
            };
            function swap_bs() {
                page.bootstrap = 3;
            }
        </script>
        <style>
            .datepicker>.datepicker-days {
                display: block;
            }
            .datepicker tbody tr > td.day.range {
                background: #c0b5b5 !important;
            }
            ol.linenums {
                margin: 0 0 0 -8px;
            }
            #para_file, #para_payor, #para_chk, #ddlSearchPractice, #para_npi{
                display: none;
            }
            .filter-icon {
                border: none;
                padding: 0;
                background-color: transparent;
                font-size: 19px;
            }
            #filterBy {
                display: none;
                position: absolute;
                top: 0;
                left: -10px !important;
                transform: translateX(10px);
                z-index: 1;
                font-size: 14px;
            }
            #filterBy.active {
                display: block !important;
            }
            .inline-label {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }
            .inline-label label {
                margin-right: 10px;
            }
            .dropdown {
                position: relative;
            }
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
            .close-btn {
                position: absolute;
                top: 0%;
                right: 40px;
                cursor: pointer;
                font-size:24px;
                font-weight:700;
            }
            .select2-container .select2-selection__arrow {
                display: none !important;
            }
            .sticky-top{
                background-color:#fff;
                top: 65px !important;
            }
            .form-label{
                margin-bottom: 0px!important;
            }
            .dropdown-menu > a.active, .dropdown-menu > a:active, .dropdown-menu > a:focus, .dropdown-menu > a:hover {
                background-color:#E9ECEF !important;
                color: #000!important;
            }
            .input-group {
                top:42px;
            }
            .account-label, .selectedDateRange-label{
                margin-right: 10px;
                margin-left: 10px;
            }
            #accountLabel, #selectedDateRange{
                font-weight: bold;
            }
             .loader {
                position: fixed!important;
                left: 0px!important;
                top: 0px!important;
                width: 100%!important;
                height: 100%!important;
                z-index: 10!important;
            }
            .readonly input[type="checkbox"],
            .readonly input[type="text"],
            .readonly input[type="search"],
            .readonly select,
            .readonly button {
                pointer-events: none;
                opacity: 0.5;
            }

            /* Custom Checkbox CSS for Account/Practice Select2 */
            #select2-payee-results .select2-results__option:before {
                content: "";
                display: inline-block;
                position: relative;
                height: 15px;
                width: 15px;
                border: 2px solid #8F8F9D;
                border-radius: 4px;
                background-color: #fff;
                margin-right: 10px;
                vertical-align: middle;
            }
            #select2-payee-results .select2-results__option[aria-selected=true]:before {
                font-family: 'Font Awesome 5 Free';
                content: "\f00c";
                color: #fff;
                background-color: #0060DF;
                border: 0;
                display: inline-block;
                padding-left: 3px;
                font-weight: 900;
                font-size: 10px;
            }
            .select2-container--default .select2-selection--multiple {
                height: 34px;
                overflow-x:hidden;
                border:2px solid #ced4da;
                margin-bottom: 10px;
                line-height:1.6;
            }
        </style>
    <jsp:include page="includes/header.jsp"></jsp:include>
    <section class="pcoded-main-container">
        <div class="pcoded-wrapper">
            <div class="pcoded-content">
                <div class="pcoded-inner-content">
                    <div class="main-body">
                        <div class="page-wrapper">
                            <div class="col-12 p-r-0 p-t-15">
                                <div class="row">
                                    <div class="col-lg-6 col-sm-12">
                                        <label for="account" class="account-label">Account: </label>
                                        <span id="accountLabel"></span>
                                    </div>
                                    <div class="col-lg-6 col-sm-12">
                                        <label for="selectedDateRange" class="selectedDateRange-label" id="selectedDateRangeType"></label>
                                        <span id="selectedDateRange"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12 m-t-5">
                                    <div class="card">
                                        <div class="card-body" style="padding-top:5px!important;">
                                            <div class="dt-responsive table-responsive">
                                                <div class="tableFixHead1">
                                                    <div style="min-height:500px;">
                                                        <table id="simpletable" width="100%" class="table table-striped table-bordered nowrap" >
                                                            <thead>
                                                                <tr>
                                                                    <th style="position: sticky; top: 0; z-index: 1;"><input id="headercheck" type="checkbox"></th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="fn">File #</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="dorr">Chk Dt</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="amount">Amount</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="mode">Mode</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="payer">Payor</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="eft">CHK/EFT #</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="payee">Payee</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="type">ERA Type</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="cd">ACCNT</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="tid">TID</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="rendproid">Bill_NPI</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="">Chk Dt</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="">fDORR</th>                                     
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="payer">Payor</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="payee">Practice</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="srendproid">NPI</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="accountno">Account</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="Recdate">Rec_Date</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="ticket_id">Ticket# </th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="accountno">Account</th>
                                                                    <th style="position: sticky; top: 0; z-index: 1;" data-element="action">Action</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>      
                                                            </tbody>
                                                            <tfoot hidden>
                                                                <tr style="background: antiquewhite;">
                                                                    <th colspan="17"></th>
                                                                </tr>
                                                            </tfoot>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6 border-right col-md-4" style="padding: 0 25px !important;height: 33px;">
                                                    <div class="form-group row" style="padding-top: 7px;">
                                                        <label class="form-label">Total Amount: </label>
                                                        <h5 class="m-l-5" id="totalamt" style="font-size: 15px;"></h5>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6  col-md-4" style="padding: 0 25px !important;height: 33px;">
                                                    <div class="form-group row" style="padding-top: 7px">
                                                        <label class="form-label">Screen Total : </label>
                                                        <h5 class="m-l-5" id="screentotoal" style="font-size: 15px"></h5>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>         

    <div id="styleSelector" class="menu-styler open" style="z-index:1071!important;">
        <div class="style-toggler" id="toggleBenefit"><a href="#!"></a></div>
        <div class="style-block">
            <h5 class="border-bottom">Filters</h5>
            <div id="eraCardBody">
                <div class="col-lg-12 p-0 m-b-10"> 
                    <div class="dropdown" data-toggle="tooltip" data-placement="top" title="Filter By Type Of Date">                                               
                        <select class="form-control" id="filterBy">
                            <option value="1">Received Date</option>
                            <option value="2">CHK Date</option>
                            <option value="0">No Date</option>
                        </select>
                        <div class="input-group-append float-right" style="position: relative; margin-bottom:-30px;z-index:1072;">
                            <span class="input-group-text arrow-box" style="border:0px!important;">
                                <span class="up-arrow" id="previousFilterBy">&#11165;</span> 
                                <span class="down-arrow" id="nextFilterBy">&#11167;</span>
                            </span>
                        </div>
                    </div>
                </div>      
                <div class="col-lg-12 p-0 m-b-10">                                               
                    <div class='input-group pull-right col-11 p-0' id='pc-daterangepicker-6'>
                        <div class='input-group-append'>
                            <span class="input-group-text arrow-box" style="padding:5px 8px; height:34px;background-color:#3f8db4!important; border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                        </div>
                        <input type='text' readonly="" class="form-control" placeholder="Select date range" style="height: 34px;"/>
                    </div>                                                                                                                                                                          
                    <div class="input-group-append" id="arrow-up-down" style="float: right; position: relative; margin-top: 8px;">
                            <span class="input-group-text arrow-box" style="border:0px!important; background-color:#3f8db4!important;border-radius:5px; height:34px;">
                                <span class="up-arrow" id="previousDateRange">&#11165;</span> 
                                <span class="down-arrow" id="nextDateRange">&#11167;</span>
                            </span>
                </div>
                </div>
                <div class="col-lg-12 p-0 m-b-10 m-t-50">
                    <div class="select-container practiceContainer">
                        <select class="form-control js-select-placeholder-multiple form-multi-select practice" multiple data-placeholder="Select Account" name="payee" id="payee">
                            <option value="selectAll">Select all</option>
                        <c:forEach var="payee" items="${payeelist}">
                            <option value="${payee.payee}">${payee.payee}</option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="close" onclick="deselectOption(this)">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-42px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousPractice">&#11165;</span> 
                            <span class="down-arrow" id="nextPractice">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>

            <div class="col-lg-12 p-0 m-b-10">
                <input type="text" class="form-control" id="fileName" placeholder="Enter File Name"/>
                <span class="close-btn" id="closefileName" onclick="deselectOption(this)" style="right:10px!important;display:none;">&times;</span>    
            </div>

            <div class="col-lg-12 p-0 m-b-10">
                <input type="text" class="form-control" id="checkEft" placeholder="Enter Chk/EFT"/>
                <span class="close-btn" id="closecheckEft" onclick="deselectOption(this)" style="right:10px!important;display:none;">&times;</span>
            </div>

            <div class="col-lg-12 p-0 m-b-10">
                <div class="select-container ">
                    <select class="form-control js-select-placeholder-multiple" data-placeholder="Select Payor" id="payor">
                        <option value="">Select Payor</option>
                        <c:forEach var="payor" items="${payorlist}">
                            <option>${payor.name}</option>
                        </c:forEach>
                    </select>
                    <span class="close-btn" id="closePayor" onclick="deselectOption(this)">&times;</span>
                    <div class="input-group-append float-right" style="position: relative; margin-top:-33px;">
                        <span class="input-group-text arrow-box" style="border:0px!important;">
                            <span class="up-arrow" id="previousPayor">&#11165;</span> 
                            <span class="down-arrow" id="nextPayor">&#11167;</span>
                        </span>
                    </div>
                </div>
            </div>                                                                                                            
            <div class="row">
                <div class="col-lg-12 text-right p-r-5">
                    <button id="search" class="btn btn-success" style="padding:6px 22px!important;">Search</button>
                    <button id="showall" class="btn btn-primary" style="padding:6px 22px!important;">Reset</button>
                </div>
            </div>
        </div>  
    </div>
</div>   

<div id="flading" class="loader process-hide">
</div>

<div id="export-flading" class="loader1 process-hide">
    <img src="assets/images/loading-pink.gif" alt="Processing..." width="50" height="50">
</div>

<div id="modalConfirmYesNo" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" 
                        class="close" data-dismiss="modal" aria-label="Close">
                </button>
                <h4 id="lblTitleConfirmYesNo" class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p id="lblMsgConfirmYesNo"></p>
            </div>
            <div class="modal-footer">
                <button id="btnYesConfirmYesNo" 
                        type="button" class="btn btn-primary">Yes</button>
                <button id="btnNoConfirmYesNo" 
                        type="button" class="btn btn-default">No</button>
            </div>
        </div>
    </div>
</div>
<div class="q-view" style="z-index:1071!important;">
    <div class="overlay"></div>
    <div class="content" style="padding-top:0px!important;">
        <div class="card-body">
            <h4 class="m-b-0">Raise Ticket</h4>
            <div class="border-bottom">
                <div class="row">
                    <div class="col-md-7">
                        <p class="list-inline-item mb-0">By <label class="mb-0" id="raiseduser" ></label></p>
                    </div>
                    <div class="col-md-5 text-right">
                        <p class="d-inline-block mb-0"><i class="feather icon-calendar mr-1"></i><label class="mb-0" id="currentdate" ></label></p>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-12">
            <div class="card border-0 shadow-none">
                <div class="card-body pr-0 pl-0 pt-0">
                    <div>
                        <form:form method="POST" action="uploadticket" id="ticketForm" modelAttribute="uploadticket" enctype="multipart/form-data">
                            <div class="form-group row">
                                <div class="col-lg-6">
                                    <label class="form-label" for="subject">Subject <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" maxlength="150" id="subject" name="subject" placeholder="Enter Subject" />
                                    <span class="close-btn" id="closesubject" onclick="clearSubject()"  style="top:20px;right:25px;">&times;</span>
                                </div>
                                <div class="col-lg-6">
                                    <label class="form-label" for="ticketTypeId">Type <span class="text-danger">*</span></label>
                                    <select class="form-control" required id="ticketTypeId" name ="ticketTypeId">
                                        <option value = "" >--Select--</option>
                                        <c:forEach var="ticket" items="${tickettypelist}">
                                            <option value = ${ticket.tid} >${ticket.ticketType}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-lg-6">
                                    <label class="form-label" for="ticketPriorityId">Priority <span class="text-danger">*</span></label>
                                    <select class="form-control" required id="ticketPriorityId" name ="ticketPriorityId">
                                        <c:forEach var="ticket" items="${ticketprioritylist}">
                                            <option value = ${ticket.tid}>${ticket.ticketPriority}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-lg-6">
                                    <label class="form-label">Browse </label>
                                    <input class="form-control" type="file" name="file" id="attachmentId" multiple accept="application/pdf, image/jpeg">  
                                    <div class="preview"></div>
                                    <div class="progress1" style="display:none">
                                        <div class="progress-bar1"  id="ticketprogress" role="progressbar" aria-valuenow="0"
                                             aria-valuemin="0" aria-valuemax="100" style="width:0%">
                                            0%
                                        </div>
                                    </div>
                                </div>	
                            </div>									
                            <div class="form-group row">
                                <div class="col-lg-6">
                                    <label class="form-label"  for="assigned_to">Assign To</label>
                                    <select class="form-control js-select-placeholder-multiple" required id="assigned_to"  name="assigned_to">
                                        <option value = "" >--Select--</option>
                                        <c:forEach var="ticket" items="${assignuserlist}">
                                            <option value = ${ticket.user_id}>${ticket.username}</option>
                                        </c:forEach>
                                    </select>
                                    <span class="close-btn" id="closeassigned" onclick="deselectOption(this)"  style="top:20px;right:25px;">&times;</span>
                                </div>
                                <div class="col-lg-6" id="followupSection">
                                    <label class="form-label" for="para_Dos">Followup Date</label>
                                    <div class="input-container">
                                        <input type="text" class="form-control" autocomplete="new" id="followupDate" name="followupDate" placeholder="Enter followupDate" />
                                    </div>
                                    <span class="close-btn" id="closefollowup" onclick="clearfollowup()"  style="top:20px;right:25px;">&times;</span>
                                </div>
                            </div>
                            <input type="hidden" id="hiddenDateTime">
                            <div class="form-group row">
                                <div class="col-lg-12 p-0">
                                    <div class="card-body" style="padding:7px 15px!important;">
                                        <div id="summernote">
                                            <p>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group row">                                
                                <div class="col-6 text-right offset-6 p-r-0">
                                    <a class="btn btn-rounded btn-danger" href="#" id="cancelTicketScreen" > Cancel </a>
                                    <button type="submit"  id="btnsubmit"  class="btn btn-rounded btn-warning">Submit</button>                                            
                                </div>
                            </div>
                        </form:form>
                    </div>
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
                <h4 id="lblTitleConfirmYesNo" class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p id="lblMsgConfirmYesNo"></p>
            </div>
            <div class="modal-footer">
                <button id="btnYesConfirmYesNo" 
                        type="button" class="btn btn-primary">Yes</button>
                <button id="btnNoConfirmYesNo" 
                        type="button" class="btn btn-default">No</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>

    <script src="assets/js/plugins/select2.full.min.js"></script>
    <script src="assets/js/pages/form-select-custom.js"></script>
     <script src="assets/js/select-handler.js?v=5"></script>
     <script>
          function clearSubject() {
                $("#subject").val(""); // Clear the input value
            }

            function clearfollowup() {
                $("#followupDate").val(""); // Clear the input value
            }
        </script>
    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const filterIcon = document.getElementById("filterIcon");
                            const filterDropdown = document.getElementById("filterBy");
                            filterDropdown.classList.toggle("active");
                            filterIcon.addEventListener("click", function (event) {
                                event.stopPropagation();
                            });
                            document.addEventListener("click", function (event) {
                                if (!filterDropdown.contains(event.target) && !filterIcon.contains(event.target)) {
                                }
                            });
                            filterDropdown.addEventListener("change", function () {
                            });
                        });
                        const toggleButton = $('#toggleEra');
                        const cardBody = $('#eraCardBody');
                        toggleButton.addClass('fa-minus-circle');
                        toggleButton.click(function (event) {
                            event.preventDefault();
                            if (cardBody.css('display') === 'none') {
                                cardBody.css('display', 'block');
                                toggleButton.removeClass('fa-plus-circle');
                            } else {
                                cardBody.css('display', 'none');
                                toggleButton.addClass('fa-plus-circle');
                            }
                        });
    </script>
    <script>
        function deselectOption(closeButton) {
            var selectElement = $(closeButton).siblings('select');
            selectElement.val(null).trigger('change');
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            
            $('#fileName').on('input', function () {
                    if ($(this).val().length > 0) {
                        $('#closefileName').show();
                    } else {
                        $('#closefileName').hide();
                    }
                });

                $('#closefileName').on('click', function () {
                    $('#fileName').val('').trigger('input'); // also hides the button
                });
                
                $('#checkEft').on('input', function () {
                    if ($(this).val().length > 0) {
                        $('#closecheckEft').show();
                    } else {
                        $('#closecheckEft').hide();
                    }
                });

                $('#closecheckEft').on('click', function () {
                    $('#checkEft').val('').trigger('input'); 
                });
                
            $('.practice').select2({
                         dropdownParent: $('.practiceContainer'), // Ensures dropdown is not cut off
                         closeOnSelect: false
                     }).on('select2:unselect', function (e) {
                         var select = $(this);
                         setTimeout(function () {
                             select.select2('open');
                         });
                     });
                
            var rowsCount;
            $("#cancelTicketScreen").on("click", function () {
                $(".overlay").click();
            });
            $('#close').attr('hidden', true);    
            $('#closePayor').attr('hidden', true);
            $('#closesubject').attr('hidden', true);
                $('#closeassigned').attr('hidden', true);
                $('#closefollowup').attr('hidden', true);
                
            function closeButton(inputElement, closeButton) {
                $(inputElement).on("change", function () {
                    if ($(inputElement).val() !== "" && $(inputElement).val() !== null) {
                        $(closeButton).removeAttr('hidden');
                    } else {
                        $(closeButton).attr('hidden', true);
                    }
                });

                $(closeButton).on("click", function () {
                    if ($(inputElement).val() !== "") {
                        $(closeButton).removeAttr('hidden');
                    } else {
                        $(closeButton).attr('hidden', true);
                    }
                });
            }
            closeButton("#payor", "#closePayor");
            closeButton("#payee", "#close");
            closeButton("#subject", "#closesubject");
            closeButton("#assigned_to", "#closeassigned");
            closeButton("#followupDate", "#closefollowup");

            setupSelectAllHandler('payee');
        
            function hideSearchHistoryOnSelect(inputElement) {
                $(inputElement).on("select2:select", function () {
                    $(".select2-search__field").val("");
                });
            }
            hideSearchHistoryOnSelect("#payee");

            var eobdt = localStorage.getItem("eobdate");
            var start, end, para = '', paraVal = '';
            var multiSearchColumn = [], multiSearchValue = [], multiSearchColumnName = [], multiSearchColumnValue = [];
            if (eobdt === null) {
                start = moment().subtract(1, 'month').startOf('month');
                end = moment().subtract(1, 'month').endOf('month');
                $('#pc-daterangepicker-6 .form-control').val(start.format('MM/DD/YYYY') + ' / ' + end.format('MM/DD/YYYY'));
            } else {
                var currentVal = eobdt;
                start = currentVal.split(" / ")[0];
                end = currentVal.split(" / ")[1];
                $('#pc-daterangepicker-6 .form-control').val(moment(start).format("MM/DD/YYYY") + ' / ' + moment(end).format("MM/DD/YYYY"));
                localStorage.setItem("eobdate", moment(start).format("MM/DD/YYYY") + ' / ' + moment(end).format("MM/DD/YYYY"));
            }
            var from = GetParameterValues('from');
            var to = GetParameterValues('to');
            if (typeof (from) !== 'undefined') {
                $('#filterBy option:eq(1)').prop('selected', true);
                $('#pc-daterangepicker-6 .form-control').val(moment(from).format('MM/DD/YYYY') + ' / ' + moment(to).format('MM/DD/YYYY'));
                start = moment(from).format("YYYY-MM-DD");
                end = moment(to).format("YYYY-MM-DD");
            }
            var practice = decodeURIComponent(GetParameterValues('practice'));
            if (typeof (practice) !== 'undefined') {
                practice = practice.toString().split('%')[0];
                $("#payee option").each(function () {
                    if ($(this).val().includes(practice)) {
                        $(this).prop('selected', true);
                        $("#payee").trigger('change');
                        multiSearchColumn.push('eob.ftp_username');
                        multiSearchValue.push($(this).val());
                    }
                });
            }

            function updatePracticeAndDateLabels() {
                // MODIFIED: Summary for Account Label Header
                let selectedTexts = $("#payee option:selected").filter((_, el) => $(el).val() !== 'selectAll').map((_, el) => $(el).text().trim()).get();
                if (selectedTexts.length > 0) {
                    let displayHeader = selectedTexts.length > 2 ? selectedTexts[0] + " + " + (selectedTexts.length - 1) + " more" : selectedTexts.join(', ');
                    $('#accountLabel').text(displayHeader).change();
                } else {
                    $('#accountLabel').text(' --- ').change();
                }

                let selectedFilterBy = $('#filterBy option:selected').text().trim();
                $('#selectedDateRangeType').text(selectedFilterBy + ": ");
                if (selectedFilterBy !== 'No Date') {
                    $('#selectedDateRange').text(moment(start).format("MM/DD/YYYY") + " To " + moment(end).format("MM/DD/YYYY")).change();
                } else {
                    $('#selectedDateRange').text(' --- ').change();
                }
            }
            updatePracticeAndDateLabels();
            $(".tableFixHead1").removeClass("tablehide");
            $(".tableFixHead1").addClass("tableshow");
            var checked = 0;
            var notflag = 'N';
            var now = new Date();
            var year = now.getFullYear();
            var myyearSelect = $('#yearid');
            myyearSelect.find('option').remove();
            $('<option>').val(0).text('').appendTo(myyearSelect);
            for (var i = year - 20; i < year + 1; i++) {
                $('<option>').val(i).text(i).appendTo(myyearSelect);
            }

            function ShowConfirmYesNo() {
                AsyncConfirmYesNo(
                        "Confirmation Box",
                        "You are about to create multiple tickets, Do you wish to continue?",
                        MyYesFunction,
                        MyNoFunction
                        );
            }

            $("#followupDate").datepicker({
                    format: "mm/dd/yyyy",
                    autoclose: true,
                    orientation: "bottom left",
                    startDate: new Date(),
                    endDate: "+30d"
                }).mask('99/99/9999');

            function MyYesFunction() {
                $(".q-view").addClass("active");
                getFollowUpDate();
            }

            function MyNoFunction() {
                $(".overlay").click();
                $('#headercheck').prop('checked', false);
                $('#simpletable tbody input[type=checkbox]').each(function () {
                    $(this).prop('checked', false);
                    if (checked > 0) {
                        checked--;
                    }
                });
            }

            function AsyncConfirmYesNo(title, msg, yesFn, noFn) {
                var $confirm = $("#modalConfirmYesNo");
                $confirm.modal('show');
                $("#lblTitleConfirmYesNo").html(title);
                $("#lblMsgConfirmYesNo").html(msg);
                $("#btnYesConfirmYesNo").off('click').click(function () {
                    yesFn();
                    $confirm.modal("hide");
                });
                $("#btnNoConfirmYesNo").off('click').click(function () {
                    noFn();
                    $confirm.modal("hide");
                });
            }

            $('#headercheck').prop('checked', false);
            var practiceid = '<%=session.getAttribute("practiceid")%>';
            var entityId = '<%= session.getAttribute("Entityid")%>';
            if (entityId !== '') {
                if (practiceid > 0) {
                    $('#practiceHeader').show();
                } else {
                    $('#practiceHeader').show();
                }
            }

            var entity_user = '';
            var entity_user_to = '';
            var entity_user_cc = '';
            var entity_user_bcc = '';
            var now = new Date();
            var today = timeformatYMD(now);
            var today1 = timeformat(now);
            $('#monthid').val('');
            $('#yearid').val('0');
            $('#currentdate').text(today1);
            var LoginUsername = '<%= session.getAttribute("LoginUsername")%>';
            $('#raiseduser').text(LoginUsername);
            $('#flading').hide();
            $('#export-flading').hide();

            $(".overlay").click(function () {
                $(".q-view").removeClass("active");
            });
            var checkedIndexes = [];
            var isCheckAllClicked = 0;
            var currentTableResponse;
            var currentTableRowTotal = 0;
            var maxRowsForExport = 0;
    <c:forEach var="limitVal" items="${maxLimitForExport}">
            maxRowsForExport = '${limitVal}';
    </c:forEach>
            function deselectAllFunction() {
                $(".overlay").click();
                $('#headercheck').prop('checked', false);
                $('#simpletable tbody input[type=checkbox]').each(function () {
                    $(this).prop('checked', false);
                    if (checked > 0) {
                        checked--;
                    }
                });
                checkedIndexes = [];
                isCheckAllClicked = 0;
            }

            $('#simpletable tbody').on('change', 'input[type="checkbox"]', function () {
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

            $('[id*=simpletable] thead').on('click', 'th:first-child', function () {
                var checkboxes = $('#simpletable tbody input[type=checkbox]');
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
            function exportAllSelection(exportType) {
                if (isCheckAllClicked === 0 && checkedIndexes.length > 0) {
                    exportSelection(exportType);
                } else if (isCheckAllClicked === 0 && recordsFiltered > currentTableResponse.length) {
                    exportAll(exportType);
                } else {
                    exportCurrentTable(exportType);
                }
                checkedIndexes = [];
            }

            function exportSelection(exportType) {
                $('#flading').show();
                var visibleColumns = table.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                visibleColumns.pop();
                var visibleColumnsParam = visibleColumns.join(',');
                location.href = "export-eob-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction();
            }

            function exportCurrentTable(exportType) {
                $('#flading').show();
                var visibleColumns = table.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                visibleColumns.pop();
                var visibleColumnsParam = visibleColumns.join(',');
                if (checkedIndexes.length > 0) {
                    location.href = "export-eob-report?startIndex=" + checkedIndexes[0] + "&endIndex=" + checkedIndexes[checkedIndexes.length - 1] + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                } else {
                    location.href = "export-eob-report?startIndex=0&endIndex=" + (currentTableResponse.length - 1) + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                }
                $('.loader1').addClass("process-hide");
                $('#flading').hide();
                $('#export-flading').hide();
                deselectAllFunction();
            }

            function exportAll(exportType) {
                var visibleColumns = table.columns(':visible').indexes().toArray();
                visibleColumns.shift();
                visibleColumns.pop();
                var visibleColumnsParam = visibleColumns.join(',');
                $.ajax({
                    url: 'eobData',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        "startDate": moment(start).format("YYYY-MM-DD"),
                        "endDate": moment(end).format("YYYY-MM-DD"),
                        "filterBy": $('#filterBy').val(),
                        "multiSearchColumn": multiSearchColumn.toString(),
                        "multiSearchValue": multiSearchValue.toString(),
                        "multiSearchColumnName": multiSearchColumnName.toString(),
                        "multiSearchColumnValue": multiSearchColumnValue.toString(),
                        "search": {
                            "value": table.search().trim(),
                            "regex": false
                        },
                        "order": orderData
                    }),
                    success: function (data) {
                        location.href = "export-eob-report?startIndex=-1&endIndex=-1&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                        $('.loader1').addClass("process-hide");
                        $('#flading').hide();
                        $('#export-flading').hide();
                        deselectAllFunction();
                    }
                });
            }

            var flag = 'Y';
            $('#mobile-collapse').click(function () {
                table.ajax.reload(null, false);
            });

            var orderData = [];
            var exportType;
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
            var columnsList = ${columnsList};
            var table = $('#simpletable').DataTable({
                "aaSorting": [], 
                "lengthMenu": [10, 30, 50, 100, 200, 500],
                "pageLength": 100,
                stateSave: true,
                scrollY: "60vh",
                scrollX: "800px",
                scrollCollapse: true,
                paging: true,
                fixedHeader: false,
                "oLanguage": {
                    "sEmptyTable": "No Data..."
                },
                "columnDefs": [
                    {'visible': false, 'targets': [1, 7, 8, 10, 12, 13, 16, 14, 15, 17, 19, 20]}
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
                    "url": 'eobData',
                    "contentType": 'application/json',
                    "dataType": "json",
                    "data": function (d) {
                        return JSON.stringify($.extend({}, d, {
                            "startDate": moment(start).format("YYYY-MM-DD"),
                            "endDate": moment(end).format("YYYY-MM-DD"),
                            "filterBy": $('#filterBy').val(),
                            "multiSearchColumn": multiSearchColumn.toString(),
                            "multiSearchValue": multiSearchValue.toString(),
                            "multiSearchColumnName": multiSearchColumnName.toString(),
                            "multiSearchColumnValue": multiSearchColumnValue.toString(),
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
                            let totalAmount = parseFloat(footerValues[0]);
                            $('#totalamt').html('$ ' + totalAmount.toFixed(2));
                        }
                        return  data.data;
                    }, "error": function (xhr, status, error) {
                        if (flag === "Y") {
                            $("#flading").hide();
                            msgbox("An error occurred while contacting the server. ", "ERA List Portal", "error");
                            flag = "N";
                            return false;
                        }
                    }
                },
                 dom:'<"d-flex justify-content-between align-items-center mb-2"B f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                "columns": [
                    {"data": function (data) {
                            return '<input type="checkbox" class = "check">';
                        }, "orderable": false, "searchable": false, "name": "check"}, 
                    {"data": function (data) {
                            var fileName = data.fn;
                            var chunkedFileName = [];
                            for (var i = 0; i < fileName.length; i += 15) {
                                chunkedFileName.push('<span>' + fileName.substr(i, 15) + '</span><br/>');
                            }
                            return  "<a  class='vu-idbole filename-cell' href= '#' data-value=" + data.fn + " value=" + data.fn + ">" + chunkedFileName.join('') + "</a>"; 
                        }, "orderable": true, "searchable": true, "name": "fn"}, 
                    {"data": function (data) {
                            return '<span class="dorr-cell"  data-ticketid="' + data.ticketId + '" data-value="' + data.dorr + '">' + data.dorr + '</span>';
                        }, "orderable": true, "searchable": true, "name": "dorr"}, 
                    {"data": function (data) {
                            return '<span class="amount-cell" data-value="' + data.amount + '">' + data.amount + '</span>';
                        }, "orderable": true, "searchable": true, "name": "amount"}, 
                    {"data": function (data) {
                            return data.mode !== null ? '<span class="mode-cell" data-value="' + data.mode + '">' + data.mode + '</span>' : "";
                        }, "orderable": true, "searchable": true, "name": "mode"}, 
                    {"data": function (data) {
                            return '<span class="spayer-cell" data-value="' + data.payer + '">' + data.spayer + '</span>';
                        }, "orderable": true, "searchable": true, "name": "payer"}, 
                    {"data": function (data) {
                            var eft = data.eft;
                            return "<a class='vu-idbole eft-cell' target='_blank' data-value=" + data.eft + "  href= 'claimsinera?id=" + data.tid + "&para=1&type=0'>" + eft + "</a>";
                        }, "orderable": true, "searchable": true, "name": "eft"}, 
                    {"data": function (data) {
                            return '<span class="spayee-cell" data-value="' + data.payee + '">' + data.spayee + '</span>';
                        }, "orderable": true, "searchable": true, "name": "payee"}, 
                    {"data": function (data) {
                            return '<span class="type-cell" data-value="' + data.type + '">' + data.type + '</span>';
                        }, "orderable": true, "searchable": true, "name": "type"}, 
                    {"data": function (data) {
                            return '<span class="cd-cell" data-value="' + data.cd + '">' + data.cd + '</span>';
                        }, "orderable": true, "searchable": true, "name": "cd"}, 
                    {"data": function (data) {
                            return '<span class="tid-cell" data-value="' + data.tid + '">' + data.tid + '</span>';
                        }, "orderable": true, "searchable": true, "name": "tid"}, 
                    {"data": function (data) {
                            var billingNPI = data.billingNPI;
                            return '<span class="billingnpi-cell" data-value="' + data.billingNPI + '">' + billingNPI.substring(0, 10) + '</span>';
                        }, "orderable": true, "searchable": true, "name": "billingNPI"}, 
                    {"data": function (data) {
                            return '<span class="dorr-cell" data-value="' + data.dorr + '">' + data.dorr + '</span>';
                        }, "orderable": true, "searchable": true, "name": "dorr"}, 
                    {"data": function (data) {
                            return '<span class="dor-cell" data-value="' + data.dor + '">' + data.dor + '</span>';
                        }, "orderable": true, "searchable": true, "name": "dor"}, 
                    {"data": function (data) {
                            return '<span class="payer-cell" data-value="' + data.payer + '">' + data.payer + '</span>';
                        }, "orderable": true, "searchable": true, "name": "payer"}, 
                    {"data": function (data) {
                            return '<span class="payee-cell" data-value="' + data.payee + '">' + data.payee + '</span>';
                        }, "orderable": true, "searchable": true, "name": "payee"}, 
                    {"data": function (data) {
                            return '<span class="billingnpi-cell" data-value="' + data.billingNPI + '">' + data.billingNPI + '</span>';
                        }, "orderable": true, "searchable": true, "name": "billingNPI"}, 
                    {"data": function (data) {
                            var billName = data.accountno;
                            if (billName !== "") {
                                return '<span class="accountno-cell" data-value="' + data.accountno + '">' + billName.substring(0, 10) + '</span>';
                            } else {
                                return billName;
                            }
                        },
                        "orderable": true, "searchable": true, "name": "accountno"}, 
                    {"data": function (data) {
                            return '<span class="receivedDate-cell" data-value="' + data.receivedDate + '">' + data.receivedDate + '</span>';
                        }, "orderable": true, "searchable": true, "name": "receivedDate"}, 
                    {"data": function (data) {
                            if (data.ticketId > 0) {
                                return "<span class='ticketid-cell'  data-value=" + data.ticketId + "><a target= '_blank'  href= 'viewticket?ticketid=" + data.ticketId + "&assignTo=" + data.assignToId + "'><span style='color: green; font-weight: bold;'>" + data.ticketId + "</span></a></span>";
                            } else {
                                return '<span class="ticketid-cell"  data-value="' + data.ticketId + '">' + data.ticketId + '</span>';
                            }
                        }, "orderable": true, "searchable": true, "name": "ticket_id"},
                    {"data": function (data) {
                            return '<span class="accountno-cell" data-value="' + data.accountno + '">' + data.accountno + '</span>';
                        }, "orderable": true, "searchable": true, "name": "accountno"}, 
                    {"data": function (data) {
                            var deleteOption = '';
                            if ($.trim(data.type) === "Manual") {
    <sec:authorize access="hasAuthority('DELETE_MANUAL_EOB_PRIVILEGE')">
                                deleteOption = ' <a role="tooltip" data-microtip-position="left" title="" aria-label="Delete" href="#" id="delete" class="delete" ><i class="fas fa-trash-alt" style="font-size:15px; margin:0 3px;color:#FF425C;"></i></a>';
    </sec:authorize>
                            }
                            return deleteOption;
                        }, "orderable": false, "searchable": false, "name": "accountno"} 
                ],
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<img src="assets/images/excelicon.png">',
                        className: 'dt-pdf-btn',
                        titleAttr: 'Download list in excel Format',
                        exportOptions: {
                            columns: [1, 6, 12, 3, 4, 18, 19, 8, 20, 14, 15, 16, 17]
                        }, action: function (e, dt, button, config) {
                            if (currentTableRowTotal > maxRowsForExport) {
                                msgbox("Number of rows exceeds the maximum possible rows per sheet in this report. Rows processed: 50000.!", "", "warning");
                            }
                            exportType = 1;
                              if (rowsCount > 0) {
                                  $('.loader1').removeClass("process-hide");
                                  $('#flading').show();
                                  $('#export-flading').show();
                                  exportAllSelection(exportType);
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
                            columns: [1, 6, 12, 3, 4, 18, 19, 8, 20, 14, 15, 16, 17]
                        },
                        action: function (e, dt, button, config) {
                            if (currentTableRowTotal > maxRowsForExport) {
                                msgbox("Number of rows exceeds the maximum possible rows per sheet in this report. Rows processed: 50000.!", "", "warning");
                            }
                            exportType = 2;
                              if (rowsCount > 0) {
                                  $('.loader1').removeClass("process-hide");
                                  $('#flading').show();
                                  $('#export-flading').show();
                                  exportAllSelection(exportType);
                              } else {
                                  msgbox("No Records Found.", "Export Content", "warning");
                              }
                        }
                    },  
              <sec:authorize access="hasAuthority('DELETE_MANUAL_EOB_PRIVILEGE')"> 
                                {
                className: 'dt-pdf-btn ',
                text: '<i class="fa fa-trash" style="font-size:25px;color:red"></i>',
                titleAttr: 'Delete Selected Records',
                action: function (e, dt, node, config) {
                    deleteManualEob(true);
                }
            },
              </sec:authorize>
                                {
                        extend: 'colvis',
                        className: 'btn-outline-secondary btn-sm ',
                        text: 'Columns <i class="fas fa-plus m-r-5 m-l-5" style="font-size:9px"></i>/<i class="fas fa-minus m-l-5" style="font-size:9px;"></i> ',
                        columns: columnsList
                    }
                ],
                createdRow: function (row, data, dataIndex) {
                    initializeTooltips(row, data);
                },
                footerCallback: function (tfoot, data, start, end, display) {
                    var api = this.api(), data;
                    var intVal = function (i) {
                        return typeof i === 'string' ?
                                i.replace(/[\$,]/g, '') * 1 :
                                typeof i === 'number' ?
                                i : 0;
                    };
                    var numericValue;
                    var pageTotal = api
                            .column(3, {page: 'current'})
                            .data()
                            .reduce(function (a, b) {
                                if ($(b).text() === "") {
                                    numericValue = 0;
                                } else {
                                    numericValue = parseFloat($(b).text().replace(/[^\d.-]/g, ''));
                                }
                                return intVal(a) + intVal(numericValue);
                            }, 0);
                    $('#screentotoal').html('$ ' + pageTotal.toFixed(2));
                    $('#flading').hide();
                }
            });

            showProcessing();

            table.on('column-visibility.dt', function (e, settings, column, state) {
                if (state) { 
                    table.rows().every(function () {
                        var row = this.node();
                        var data = this.data();
                        initializeTooltips(row, data);
                    });
                }
            });

            function initializeTooltips(row, data) {
                $(row).find('.tid-cell').attr('class', 'selectid');
                $(row).find('.dorr-cell').text(data["dorr"]);
                $(row).find('.spayer-cell').attr('role', "tooltip");
                $(row).find('.spayer-cell').attr('data-microtip-position', "left");
                $(row).find('.spayer-cell').attr('data-microtip-size', "medium");
                $(row).find('.spayer-cell').attr('aria-label', data["payer"]);
                $(row).find('.eft-cell').attr('role', "tooltip");
                $(row).find('.eft-cell').attr('data-microtip-position', "left");
                $(row).find('.eft-cell').attr('data-microtip-size', "medium");
                $(row).find('.eft-cell').attr('aria-label', data["eft"]);
                $(row).find('.spayee-cell').attr('role', "tooltip");
                $(row).find('.spayee-cell').attr('data-microtip-position', "left");
                $(row).find('.spayee-cell').attr('data-microtip-size', "medium");
                $(row).find('.spayee-cell').attr('aria-label', data["payee"].toString());
                $(row).find('.spayer-cell').attr('filename', data["fn"].toString());
                $(row).find('.spayer-cell').attr('payee', data["payee"].toString());
                $(row).find('.spayer-cell').attr('type', data["type"].toString());
                $(row).find('.spayer-cell').attr('tid', data["tid"].toString());
                $(row).find('.eft-cell').attr('eft', data["eft"].toString());
                // $(row).find('.accountno-cell').attr('accountno', data["accountno"].toString());  
                $(row).find('.spayer-cell').attr('accountno', data["accountno"].toString());
                if (data["billingNPI"].toString() !== '') {
                    $(row).find('.billingnpi-cell').attr('role', "tooltip");
                    $(row).find('.billingnpi-cell').attr('data-microtip-position', "left");
                    $(row).find('.billingnpi-cell').attr('data-microtip-size', "medium");
                    $(row).find('.billingnpi-cell').attr('aria-label', data["billingNPI"].toString());
                }
                if (data["accountno"].toString() !== '') {
                    $(row).find('.accountno-cell').attr('role', "tooltip");
                    $(row).find('.accountno-cell').attr('data-microtip-position', "left");
                    $(row).find('.accountno-cell').attr('data-microtip-size', "medium");
                    $(row).find('.accountno-cell').attr('aria-label', data["accountno"].toString());
                }
                if (data["flag"].toString() === 'N') {
                } else if (data["flag"].toString() === 'Y') {
                    $(row).find('input.check').css('background', "yellow");
                }
                var ticket_id = $(row).find('.ticketid-cell').data('value');
                if (ticket_id > 0) {
                    $(row).find('.ticketid-cell').attr('role', "tooltip");
                    $(row).find('.ticketid-cell').attr('data-microtip-position', "bottom");
                    $(row).find('.ticketid-cell').attr('data-microtip-size', "medium");
                    $(row).find('.ticketid-cell').attr('aria-label', data["assignTo"]);
                    $(row).find('.claimno-cell').attr('ticketaction', data["assignTo"]);
                }
            }

            table.on('page.dt', function () {
                $('.dataTables_scrollBody').scrollTop(0);
            });

            table.on('length.dt', function () {
                $('.dataTables_scrollBody').scrollTop(0);
            });

            table.on('search.dt', function () {
                $('#flading').show();
            });

            $('#pc-daterangepicker-6').daterangepicker({
                buttonClasses: ' btn',
                applyClass: 'btn-primary',
                cancelClass: 'btn-secondary',
                startDate: start,
                endDate: end,
                showDropdowns: true,
                minDate: moment('2024-01-01'),
                maxDate: moment('9999-99-99'),
                opens:'right',
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Last 60 Days': [moment().subtract(59, 'days'), moment()],
                    'Last 90 Days': [moment().subtract(89, 'days'), moment()]
                }
            }, function (startVal, endVal, label) {
                    start = startVal.format('YYYY-MM-DD');
                    end = endVal.format('YYYY-MM-DD');
                $('#pc-daterangepicker-6 .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                localStorage.setItem("eobdate", startVal.format("MM/DD/YYYY") + ' / ' + endVal.format("MM/DD/YYYY"));
                });

            $(document).on("click", "#simpletable a.delete", function () {
                let tr = $(this).closest('tr');
                deleteManualEob(false, tr);
            });

            function deleteManualEob(isBulk = false, clickedRow = null) {
                var table = $('#simpletable').DataTable();
                var deleteData = [];
                if (isBulk) {
                    var anySelected = false;
                    table.$('input[type="checkbox"]').each(function () {
                        if (this.checked) {
                            let tr = $(this).closest('tr');
                            let fn = tr.find('.spayer-cell').attr('filename');
                            let eft = tr.find('.eft-cell').attr('eft');
                            let account = tr.find('.spayer-cell').attr('accountno');
                            let type = tr.find('.spayer-cell').attr('type');
                            if (type === 'Manual') {
                                anySelected = true;
                                deleteData.push({fileName: fn, eft: eft, accountno: account});
                            }
                        }
                    });
                    if (!anySelected) {
                        msgbox("Only manually uploaded EoBs could be deleted !", "", "warning");
                        return;
                    }
                } else if (clickedRow) {
                    let fn = clickedRow.find('.spayer-cell').attr('filename');
                    let eft = clickedRow.find('.eft-cell').attr('eft');
                    let account = clickedRow.find('.spayer-cell').attr('accountno');
                    deleteData.push({fileName: fn, eft: eft, accountno: account});
                }
                $("#lblMsgConfirmYesNo").text("Are you sure you want to delete the selected records?");
                $("#modalConfirmYesNo").modal("show");
                $("#btnYesConfirmYesNo").off().on("click", function () {
                    $("#modalConfirmYesNo").modal("hide");
                    $('#flading').show();
                    $.ajax({
                        url: "delete-manual-eob-details",
                        type: "PUT",
                        contentType: 'application/json',
                        data: JSON.stringify(deleteData),
                        success: function (response) {
                            $('#flading').hide();
                            msgbox("Selected records deleted successfully.", "", "success");
                            table.ajax.reload(null, false);
                        },
                        error: function (error) {
                            $('#flading').hide();
                            msgbox("Error deleting records!", "", "error");
                        }
                    });
                });

                $("#btnNoConfirmYesNo").off().on("click", function () {
                    $("#modalConfirmYesNo").modal("hide");
                });
            }

            $('#filterBy').change(function () {
                var selectedValue = $(this).val();
                if (selectedValue === "0") {
                    $('#pc-daterangepicker-6 input[type="text"]').prop('disabled', true);
                    $('#pc-daterangepicker-6 .input-group-append .input-group-text').css('display', 'none');
                    $('#pc-daterangepicker-6').removeClass('col-11 p-0');
                    $('#arrow-up-down').css('display', 'none');
                } else {
                    $('#pc-daterangepicker-6 input[type="text"]').prop('disabled', false);
                    $('#pc-daterangepicker-6 .input-group-append .input-group-text').css('display', 'inline');
                    $('#pc-daterangepicker-6').addClass('col-11 p-0');
                    $('#arrow-up-down').css('display', 'inline');
                }
            });
            $('#app-search').change(function () {
                localStorage.setItem("app-search", $('#app-search').val());
                var table = $('#simpletable').DataTable();
                table.search(as).draw();
            });
            var as = localStorage.getItem("app-search");
            if (typeof (as) !== 'undefined' && as !== '' && $.isEmptyObject(as) === false) {
                var table = $('#simpletable').DataTable();
                table.search(as).draw();
            }

            var not_tid = GetParameterValues('tid');
            if (typeof (not_tid) !== 'undefined') {
                $('#filterBy').val(0).change();
                if (multiSearchColumn.toString() != '') {
                    multiSearchValue = [];
                    multiSearchColumn = [];
                }
                multiSearchColumn.push('eob.tid');
                multiSearchValue.push(not_tid);
                table.search('').search(not_tid).draw();
            }

            var eftValue = GetParameterValues('eft');
            if (eftValue !== null && typeof (eftValue) !== 'undefined' && eftValue !== "") {
                $('#filterBy').val(0).change();
                table.search('').search(eftValue).draw();
                searchColumn = "eft";
                searchValue = eftValue;
            }

            var total = 0;
            $('#simpletable tbody').on('change', 'input[type="checkbox"]', function () {
                var table = $('#simpletable').DataTable();
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

            $('#simpletable tbody').on('click', 'td', function () { // 2nd
                var index = table.cell(this).index().columnVisible;
                if (index === 1) {
                    var str = $(this).find('a').attr('value');
                    table.search('').search(str).draw();
                }
            });

            $('#showall').click(function () {
                $('#flading').show();
                $('#simpletable_wrapper').addClass('readonly');
                if (searchRequest && searchRequest.readyState !== 4) {
                    searchRequest.abort();
                    searchRequest = null;
                 }                
                table.columns().search('').draw();
                multiSearchColumn = []; multiSearchValue = []; multiSearchColumnName = []; multiSearchColumnValue = [];
                $('#fileName').val('');
                $('#payee').val(null).trigger('change'); // MODIFIED: Correct Reset for Multi-select
                $('#checkEft').val('');
                $('#payor').val('').change();
                $('#billingNPI').val('');
                $('#filterBy').val(1).change();
                resetDate();
                updatePracticeAndDateLabels();
                table.ajax.url("eobData").load(function () {
                    $('#flading').hide();
                    $('#simpletable_wrapper').removeClass('readonly');
                });
//                table.ajax.url("eobData?startDate=" + moment(start).format("YYYY-MM-DD") + "&endDate=" + moment(end).format("YYYY-MM-DD")).load();
                $('#ddlsearch').val(0).change();
            });

            function resetDate() {
                start = moment().subtract(1, 'month').startOf('month');
                end = moment().subtract(1, 'month').endOf('month');
                $('#pc-daterangepicker-6').data('daterangepicker').setStartDate(start);
                $('#pc-daterangepicker-6').data('daterangepicker').setEndDate(end);
                $('#pc-daterangepicker-6 .form-control').val(start.format('MM/DD/YYYY') + ' / ' + end.format('MM/DD/YYYY'));
                $('#pc-daterangepicker-6 .form-control').val(start.format('MM/DD/YYYY') + ' / ' + end.format('MM/DD/YYYY'));
                localStorage.setItem("eobdate", start.format("MM/DD/YYYY") + ' / ' + end.format("MM/DD/YYYY"));
            }

           let searchRequest = null;
                $('#search').click(function () {
                   console.log("Previous search request:", searchRequest);
                   $('#flading').show();
                   if (searchRequest && searchRequest.readyState !== 4) {
                      console.log("Aborting previous search request...");
                      searchRequest.abort();
                      searchRequest = null;
                    }
                var filterBy = $('#filterBy').val();
                var fileName = $('#fileName').val().trim();
                var checkEft = $('#checkEft').val().trim();
                var payee = $('#payee').val();
                var payor = $('#payor').val();
                if (filterBy == '0') {
                    if (fileName === "" && checkEft === "") {
                        msgbox("When using 'No Date', select at least one of the filters 'Filename and EFT'.", "ERA List Portal", "warning");
                        $('#flading').hide();
                        return false;
                    }
                }
                multiSearchColumn = []; multiSearchValue = []; multiSearchColumnName = []; multiSearchColumnValue = [];
                
                if ($('#fileName').val().trim().length > 0) {
                    multiSearchColumn.push('eob.fn');
                    multiSearchColumnName.push("FileName");
                    multiSearchValue.push(getModifiedSearchValue($('#fileName').val().trim()));
                    multiSearchColumnValue.push(getModifiedSearchValue($('#fileName').val().trim()));
                }
                
                if ($('#payee').val().length > 0) {
                        var selectedValues = $('#payee').val().map(v => v.trim()).filter(v => v.toLowerCase() !== "selectall");
                        var selectedValuesPipe = selectedValues.join('|').replace(/,/g, '~');
                        multiSearchColumn.push('eob.ftp_username');
                        multiSearchValue.push(selectedValuesPipe);
                        var selectedTextPipe = $("#payee option:selected").map(function () {
                            var val = $(this).val();
                            if (val && val.toLowerCase() !== "selectall") {
                                return $(this).text().trim().replace(/,/g, '~');
                            }
                        }).get().join('~');
                    }

                if ($('#checkEft').val().trim().length > 0) {
                    multiSearchColumn.push('eob.eft');
                    multiSearchValue.push(getModifiedSearchValue($('#checkEft').val().trim()));
                    multiSearchColumnValue.push(getModifiedSearchValue($('#checkEft').val().trim()));
                    multiSearchColumnName.push("EFT");
                }
                if ($('#payor').val().trim().length > 0) {
                    multiSearchColumn.push('eob.payer');
                    multiSearchValue.push($('#payor').val());
                    multiSearchColumnName.push("payor");
                    multiSearchColumnValue.push($("#payor option:selected").text());
                }
                updatePracticeAndDateLabels();
                if (multiSearchColumn.length > 0) {
                    $('.dataTables_processing').show();
                        searchRequest = $.ajax({
                            url: "eobData",
                            type: "POST",
                            contentType: "application/json",
                            dataType: "json",
                            data: JSON.stringify({
                                  "startDate": moment(start).format("YYYY-MM-DD"),
                                  "endDate": moment(end).format("YYYY-MM-DD"),
                                  "filterBy": $('#filterBy').val(),
                                  "multiSearchColumn": multiSearchColumn.toString(),
                                  "multiSearchValue": multiSearchValue.toString(),
                                    "multiSearchColumnName": multiSearchColumnName.toString(),
                                    "multiSearchColumnValue": multiSearchColumnValue.toString(),
                                  "order": orderData
                            }),
                                    success: function (response, status, xhr) {
                                        if (xhr.status !== 200) {
                                            console.error("Server responded with error:", xhr.status);
                                            return;
                                        }
                                        console.log("Search successful:", response);
                                table.clear().rows.add(response.data).draw();
                            },
                                    error: function (xhr, status, error) {
                                        if (status === 'abort') {
                                            msgbox("Previous request was aborted. ", "ERA List Portal", "warning");
                                            console.warn("Previous request was aborted. Ignoring error.");
                                            return;
                                        }
                                        console.error("Search request error:", error);
                                        searchRequest = null;
                                    },
                            complete: function () {
                                        //  $('.dataTables_processing').hide();
                                searchRequest = null;
                                $('#flading').hide();
                            }
                        });
                } else {
                    table.draw();
                }
            });

            $('#headercheck').change(function () {
                var table = $('#simpletable').DataTable();
                total = table.column(3, {
                    page: 'current'
                }).data().count();
                checked = 0;
                var isSelected = $(this).is(':checked');
                if (isSelected) {
                    $('#simpletable tbody input[type=checkbox]').each(function () {
                        $(this).prop('checked', true);
                        if (checked <= total) {
                            checked++;
                        }
                    });
                    if (checked > 1) {
                        notflag = 'Y';
                    }
                } else {
                    $('#simpletable tbody input[type=checkbox]').each(function () {
                        $(this).prop('checked', false);
                        if (checked > 0) {
                            checked--;
                        }
                    });
                    notflag = 'N';
                }
            });

            var brid = '';
            $('#brid').hide();
            var ticketid = '';
            $('#raiseticket').click(function () {
                brid = '';
                var newTicketIds = [];
                var existingTicketIds = [];
                var checkboxChecked = false;
                var table = $('#simpletable').DataTable();
                table.$('input[type="checkbox"]').each(function () {
                    if (this.checked) {
                        checkboxChecked = true;
                        let tr = $(this).closest('tr');
                        if (!tr.find('.check').find('input').prop('disabled')) {
                        ticketid = tr.find('.dorr-cell').data("ticketid");
                        if (ticketid == 0) {
                            brid = tr.find('.spayer-cell').attr('tid') + ',' + brid;
                            newTicketIds.push(tr.find('.spayer-cell').attr('tid'));
                        } else {
                            existingTicketIds.push(tr.find('.spayer-cell').attr('tid'));
                        }
                    }
                    }
                });
                if (!checkboxChecked) {
                    msgbox("Select at least one claim(s).", "Ticket Portal", "warning");
                    return;
                }
                if (newTicketIds.length === 0 && existingTicketIds.length > 0) {
                    msgbox("Already Ticket Raised.", "Ticket Portal", "warning");
                }
                brid = brid.substring(0, brid.length - 1);
                if (newTicketIds.length > 0) {
                    if (notflag === 'Y') {
                        ShowConfirmYesNo();
                    } else {
                        $(".q-view").addClass("active");
                        getFollowUpDate();
                }
                    $('#ticketTypeId').val("1");
                    var ticketTypeId = $("select#ticketTypeId").val();
                    $('#ticketTypeId').attr('disabled', "true");
                    $('#flading').show();
                    var currentDate = new Date();
                    var responseUser = LoginUsername.split('@');
                    var username = toTitleCase(responseUser[0]);
                    //Payor
                    $.ajax({
                        url: "ticket-type-description",
                        type: "get", //send it through get method
                        data: {
                            ticketTypeId: ticketTypeId
                        },
                        success: function (response) {
                            if (response.length > 0) {
                                    var content = (response.length > 0) ? response[0].autoDesc : '';
                                    var finalContent = "<p><em>" + username + "</em> : <em>" + currentDate + "</em></p>" + content;
                                    $(".note-editable").html(finalContent);
                                    $('#flading').hide();
                                } else {
                                    var finalContent = "<p><em>" + username + "</em> : <em>" + currentDate + "</em></p>";
                                    $(".note-editable").html(finalContent);
//                                    $(".note-editable").html('');
                                    $('#flading').hide();
                                }
                        },
                        error: function (err) {
                            $(".note-editable").html('');
                            $('#flading').hide();
                        }
            });

                    $.ajax({
                        url: "ticket-default-user",
                        type: "get", //send it through get method
                        data: {
                            ticketTypeId: ticketTypeId,
                            entityId: entityId
                        },
                        success: function (response) {
                            if (response.length > 0) {
                                $.each(response, function (index, item) {
                                    entity_user = item.assigned_to;
                                    entity_user_to = item.toMail;
                                    entity_user_cc = item.ccMail;
                                    entity_user_bcc = item.bccMail;
                                });
                                $("select#assigned_to").val(entity_user);
                                $('#assigned_to').trigger('change');
                                if ($("select#assigned_to").val() === "0") {
                                    $("#followupSection").hide();
                                    $("#hiddenDateTime").val("");
                                }
                                $('#flading').hide();
                            } else {
                                $('#flading').hide();
                            }
                        }
                    });
                }
            });

            $(function () {
                $('#summernote').summernote({
                    height: 150,
                    codemirror: {
                        mode: 'text/html',
                        htmlMode: true,
                        lineNumbers: true,
                        theme: 'monokai'
                    }
            });
            });
            var userId = '<%= session.getAttribute("Userid")%>';
            var ticketsource = '<%=session.getAttribute("source")%>';
            var files = '';
            var progressbar = $('.progress-bar1');

            $("#btnsubmit").click(function () {
                $('#flading').show();
                $("form").ajaxForm({
                    beforeSend: function () {
                        $(".progress1").css("display", "block");
                        progressbar.width('0%');
                        progressbar.text('0%');
                    },
                    uploadProgress: function (event, position, total, percentComplete) {
                        if (percentComplete <= 100) {
                            progressbar.width(percentComplete + '%');
                            progressbar.text(percentComplete + '%');
                        }
                    },
                    complete: function (xhr) {
                        $('#attachmentId').val('');
                        $(".progress1").css("display", "block");
                        progressbar.width('0%');
                        progressbar.text('0%');
                        $('#flading').hide();
                    }
                });
            });

            var mulfilename = '';
            $('#attachmentId').change(function (e) {
                mulfilename = e.target.files.name;
            });

            $("#ticketForm").submit(function () {
                $('#flading').show();
                files = $('#attachmentId').prop("files");
                var names = $.map(files, function (val) {
                    return val.name;
                });
                var size = $.map(files, function (val) {
                    return val.size;
                });
                let namestext = names.toString();
                let sizetext = size.toString();
                var fns = '';
                for (let i = 0; i < names.length; i++) {
                    fns += names[i].replaceAll(',', '').replaceAll('#', '') + ",";
                }
                fns = fns.substring(0, fns.length - 1);
                var ticketstatus = 1;
                var tstatus = '';
                if ($("select#assigned_to").val() === "0") {
                    ticketstatus = 1;
                    tstatus = 'Created';
                    $("#hiddenDateTime").val("");
                } else {
                    ticketstatus = 2;
                    tstatus = 'Assigned';
                }
                var tsource = '';
                if (ticketsource === 1) {
                    tsource = 'Practice';
                } else if (ticketsource === 2) {
                    tsource = 'Entity';
                } else {
                    tsource = 'Practice';
                }
                if ($("#subject").val() == "") {
                    msgbox("Select Subject..!", "Ticket Form", "error");
                    return;
                }
                var tickettype = $("#ticketTypeId option:selected").text();
                var ticketpriority = $("#ticketPriorityId option:selected").text();
                var assignto = $("#assigned_to option:selected").text();
                var followupdate = $("#hiddenDateTime").val();
                var subject = $("#subject").val();
                const getData = {
                    ticketTypeId: "1",
                    assigned_to_id: $("select#assigned_to").val(),
                    ticketPriorityId: $("select#ticketPriorityId").val(),
                    ticketStatusId: ticketstatus,
                    ticketSourceId: ticketsource,
                    createdById: userId,
                    creationTimeStamp: today,
                    followUpDate: followupdate,
                    fileSize: sizetext,
                    fileName: fns,
                    summernote: $(".note-editable").html(),
                    requestId: brid,
                    subject: subject,
                    segment: "D"
                };
                const data = JSON.stringify(getData);
                $.ajax({
                    url: "create-bulk-ticket",
                    type: "Post",
                    contentType: 'application/json',
                    data: data,
                    success: function (response) {
                        $("select#ticketTypeId").val('1');
                        $("select#assigned_to").val('0');
                        $(".note-editable").html('');
                        msgbox("Ticket Saved", "Ticket Form", "success");
                        table.ajax.reload(null, false);
                        deselectAllFunction();
                        MyNoFunction();
                        $('#flading').hide();
                        $(".overlay").click();
                    },
                    error: function (err) {
                        msgbox("Ticket Not Saved", "Ticket Form", "error");
                        table.ajax.reload(null, false);
                        deselectAllFunction();
                        MyNoFunction();
                        $('#flading').hide();
                        $(".overlay").click();
                    }
                });

                if ($("select#assigned_to").val() !== "0") {
                    var strcontent = "Hi " + assignto + ", <br><br>" + "Type: " + tickettype + "<br>Source: " + tsource + "<br>Priority: " + ticketpriority + "<br> Assign To: " + assignto + "<br>Segment: ERA / EOB List [D]" + "<br><br>" + $(".note-editable").html();
                    // Email Config
                    $.post('EmailSendingServlet', {
                        recipient: entity_user_to,
                        subject: 'Ticket Raised from [ERA / EOB List] Form: ' + tickettype + ' : ' + tstatus + ' to ' + assignto,
                        content: strcontent,
                        cc: entity_user_cc,
                        bcc: entity_user_bcc
                    }, function (response) {
            });
                }
            });

            $('#assigned_to').change(function (event) {
                var userId = $("select#assigned_to").val();
                if ($(this).val() === "0") {
                    $("#followupSection").hide();
                    $("#hiddenDateTime").val("");
                } else {
                    $("#followupSection").show();
                    $("#hiddenDateTime").val(convertDateMMDDYYToYYMMDDFormat(formatDateAsMMDDYYYY(new Date($("#followupDate").val()))));
                }
                if (userId !== "0" && userId !== null && userId !== "") {
                    $('#flading').show();
                    //Payor
                    $.ajax({
                        url: "ticket-entity-user",
                        type: "get", //send it through get method
                        data: {
                            userId: userId
                        },
                        success: function (response) {
                            if (response.length > 0) {
                                $.each(response, function (index, item) {
                                    entity_user_to = item.username;
                                    $('#flading').hide();
                                });
                            } else {
                                $('#flading').hide();
                            }
                        }
                    });
                }
            });
            function setPreviousDateRange() {
        let previousDates = calculatePreviousDateRange(moment(start).format('YYYY-MM-DD'), moment(end).format('YYYY-MM-DD'));
        let newStart = moment(previousDates.progressFromDate);
        let minDate = $('#pc-daterangepicker-6').data('daterangepicker').minDate;
        if (newStart.isBefore(minDate)) {
            msgbox("Selection cannot be made before the data availability date.", "", "warning");
            return;
        }
        start = newStart.format("MM/DD/YYYY");
        end = moment(previousDates.progressToDate).format("MM/DD/YYYY");
        $('#pc-daterangepicker-6').data('daterangepicker').setStartDate(start);
        $('#pc-daterangepicker-6').data('daterangepicker').setEndDate(end);
        $('#pc-daterangepicker-6 .form-control').val(start + ' / ' + end).trigger('change');
    }

    function setNextDateRange() {
        let nextDates = calculateNextDateRange(moment(start).format('YYYY-MM-DD'), moment(end).format('YYYY-MM-DD'));
//        let newEnd = moment(nextDates.nextToDate);
//        let maxDate = moment();
//        if (newEnd.isAfter(maxDate)) {
//            msgbox("Data cannot be shown for future dates.", "", "warning");
//            return;
//        }
        start = moment(nextDates.nextFromDate).format('MM/DD/YYYY');
        end = moment(nextDates.nextToDate).format('MM/DD/YYYY');
        $('#pc-daterangepicker-6').data('daterangepicker').setStartDate(start);
        $('#pc-daterangepicker-6').data('daterangepicker').setEndDate(end);
        $('#pc-daterangepicker-6 .form-control').val(start + ' / ' + end).trigger('change');
    }

    $("#nextDateRange").on("click", function () {
        setNextDateRange();
        });

    $("#previousDateRange").on("click", function () {
        setPreviousDateRange();
    });
  
        function goBack() {
            window.history.back();
        }
        function defaultFilterBySets() {
            var selectedValue = $('#filterBy').val();
            if (selectedValue === "0") {
                defaultFilter = 'true';
            } else {
                defaultFilter = '';
            }
        }
        function selectNextFilterBy() {
                const $selectElement = $('#filterBy');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
        }
        function selectPreviousFilterBy() {
                const $selectElement = $('#filterBy');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
        }

        $("#nextFilterBy").on("click", function () {
            selectNextFilterBy();
            defaultFilterBySets();
            });

        $("#previousFilterBy").on("click", function () {
            selectPreviousFilterBy();
            defaultFilterBySets();
        });

        function selectNextPractice() {
                const $selectElement = $('#payee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
        }
        function selectPreviousPractice() {
                const $selectElement = $('#payee');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
        }

        $("#nextPractice").on("click", function () {
            selectNextPractice();
            defaultFilterBySets();
            });

        $("#previousPractice").on("click", function () {
            selectPreviousPractice();
            defaultFilterBySets();
        });
        function selectNextPayor() {
                const $selectElement = $('#payor');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
        }
        function selectPreviousPayor() {
                const $selectElement = $('#payor');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
        }

        $("#nextPayor").on("click", function () {
            selectNextPayor();
            defaultFilterBySets();
            });

        $("#previousPayor").on("click", function () {
            selectPreviousPayor();
            defaultFilterBySets();
        });
        });
</script>