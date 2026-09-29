<%@page contentType="text/html"  pageEncoding="UTF-8" autoFlush="true"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html lang="en">
    <head>
        <title>Audit Log</title>

        <jsp:include page="includes/header.jsp"></jsp:include>
            <style>
                .table td, .table th {
                    font-size:13px!important;
                    font-family: math !important;
                }
                .close-btn{
                    position: absolute;
                    top: 0%;
                    right: 40px;
                    cursor: pointer;
                    font-weight:700;
                    font-size:24px;
                }
            </style>
            <!-- [ Main Content ] start -->
        <div class="pcoded-main-container">
            <div class="pcoded-wrapper">
                <div class="pcoded-content">
                    <div class="pcoded-inner-content">
                        <div class="main-body">
                            <div class="page-wrapper">
                                <!-- [ Main Content ] end -->
                                <div class="row">
                                    <!-- Zero config table start -->
                                    <div class="col-sm-12">
                                        <div class="card">

                                            <div class="card-body">
                                                <div class="dt-responsive table-responsive">
                                                    <table id="simpletable" width="100%" class="table table-striped table-bordered nowrap">
                                                        <thead>
                                                            <tr>
                                                                <th style="position: sticky; top: 0; z-index: 1;"><input id="headercheck" type="checkbox"></th>
                                                                <th data-element='log_id'>Log Id</th>
                                                                <th data-element='username'>User Name</th>
                                                                <th data-element='user_type'>Affected By</th>
                                                                <th data-element='user_type'>User Type</th>
                                                                <th data-element='log_type'>Log Type</th>
                                                                <th data-element='user_type'>Performed By</th>
                                                                <th data-element='event_time'>Log Time</th>
                                                                <th data-element='ip_address'>IP Address</th>
                                                                <th data-element='browser_name'>Browser Name</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        </tbody>
                                                    </table>
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

        <div id="styleSelector" class="menu-styler open" style="z-index:1071!important;">
            <div class="style-toggler" id="toggleBenefit"><a href="#!"></a></div>
            <div class="style-block">
                <h5 class="border-bottom">Filters</h5>
                <div id="auditLogCardBody" >                 
                    <div class="col-lg-12 m-b-10 p-0">
                        <div class='input-group pull-right col-11 p-0' id='pc-daterangepicker-6' style="height: 34px;">
                            <div class='input-group-append'>
                                <span class="input-group-text arrow-box" style="padding:5px 8px!important; height:34px;border:0px!important;"><i class="feather icon-calendar" style="color:#fff!important;"></i></span>
                            </div>
                            <input type='text' readonly="" class="form-control" placeholder="Select date range" />
                        </div>
                        <div class="input-group-append" style="float: right; position: relative; margin-top:-34px;">
                            <span class="input-group-text arrow-box" style="border:0px!important; border-radius:5px; height:34px;">
                                <span class="up-arrow" id="previousDateRange">&#11165;</span> 
                                <span class="down-arrow" id="nextDateRange">&#11167;</span>
                            </span>
                        </div>
                    </div>
                    <div class="col-lg-12 m-b-10 p-0"> 
                        <!--<label class="form-label" for="practice">User Type</label><br>-->
                        <div class="select-container ">
                            <select class="form-control js-select-placeholder-multiple" data-placeholder="Select UserType" name="userType" id="userType">
                                <option value="">Select User Type</option>
                            </select>
                            <span class="close-btn" id="closeuserType" onclick="deselectOption(this)">&times;</span>
                            <div class="input-group-append" style="float: right; position: relative; margin-top:-33px;">
                                <span class="input-group-text arrow-box" style="border:0px!important;">
                                    <span class="up-arrow" id="previoususerType">&#11165;</span> 
                                    <span class="down-arrow" id="nextuserType">&#11167;</span>
                                </span>
                            </div>
                        </div>
                    </div>  
                    <div class="col-lg-12 m-b-10 p-0"> 
                        <!--<label class="form-label" for="status">Log Type</label><br>-->
                        <div class="select-container ">
                            <select class="form-control js-select-placeholder-multiple" data-placeholder="Select LogType" name="logType" id="logType">
                                <option value="">Select Log Type</option>
                            <c:forEach var="logType" items="${logTypeList}">
                                <option value = ${logType.logTypeId}>${logType.auditLogType}</option>
                            </c:forEach>
                        </select>
                        <span class="close-btn" id="closelogType" onclick="deselectOption(this)">&times;</span>
                        <div class="input-group-append" style="float: right; position: relative; margin-top:-33px;">
                            <span class="input-group-text arrow-box" style="border:0px!important;">
                                <span class="up-arrow" id="previouslogType">&#11165;</span> 
                                <span class="down-arrow" id="nextlogType">&#11167;</span>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-12 m-b-10 p-0">
                    <input type="text" class="form-control" id="browserName" name ="browserName" placeholder="Enter Browser Name"/>
                    <span class="close-btn" id="closebrowserName" onclick="deselectOption(this)" style="right:10px!important;display:none;">&times;</span>
                </div>                                     

                <div class="col-lg-12 m-b-10 p-0">
                    <!--<label class="form-label" for="userName">UserName</label>-->
                    <input type="text" class="form-control" id="userName" placeholder="Enter UserName"/>
                    <span class="close-btn" id="closeuserName" onclick="deselectOption(this)" style="right:10px!important;display:none;">&times;</span>
                </div>
                <div class="row form-group">   
                    <div class="col-lg-12 text-right  p-r-0">                                                                                                      
                        <button id="search" class="btn btn-warning" style="padding:6px 22px!important;">Search</button>
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
    <jsp:include page="includes/footer.jsp"></jsp:include>
        <script>
            function deselectOption(closeButton) {
                var selectElement = $(closeButton).siblings('select');
                selectElement.val(null).trigger('change');
            }
        </script>
        <script type="text/javascript">
            $(document).ready(function () {

                $('#browserName').on('input', function () {
                    if ($(this).val().length > 0) {
                        $('#closebrowserName').show();
                    } else {
                        $('#closebrowserName').hide();
                    }
                });

                $('#closebrowserName').on('click', function () {
                    $('#browserName').val('').trigger('input'); // also hides the button
                });

                $('#userName').on('input', function () {
                    if ($(this).val().length > 0) {
                        $('#closeuserName').show();
                    } else {
                        $('#closeuserName').hide();
                    }
                });

                $('#closeuserName').on('click', function () {
                    $('#userName').val('').trigger('input'); // also hides the button
                });

                $('#closeuserType').attr('hidden', true);
                $('#closelogType').attr('hidden', true);
                function toggleCloseButton(inputElement, closeButton) {
                    $(inputElement).on("change", function () {
                        if ($(inputElement).val() !== "") {
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

                toggleCloseButton("#userType", "#closeuserType");
                toggleCloseButton("#logType", "#closelogType");

                var roleList = '${rolesListJson}';
                var roles = JSON.parse(roleList);
                $.each(roles, function (index, role) {
                    $('#userType').append('<option value="' + role.id + '">' + role.displayName + '</option>');
                });
                var logDateRange = localStorage.getItem("logDateRange");
                var start, end, para = '', paraVal = '';
                if (logDateRange === null) {
                    start = moment().subtract(6, 'days');
                    end = moment();
                    $('#pc-daterangepicker-6 .form-control').val(start.format('MM/DD/YYYY') + ' / ' + end.format('MM/DD/YYYY'));
                } else {
                    var currentVal = logDateRange;
                    start = currentVal.split(" / ")[0];
                    end = currentVal.split(" / ")[1];
                    $('#pc-daterangepicker-6 .form-control').val(moment(start).format("MM/DD/YYYY") + ' / ' + moment(end).format("MM/DD/YYYY"));
                    localStorage.setItem("logDateRange", moment(start).format("MM/DD/YYYY") + ' / ' + moment(end).format("MM/DD/YYYY"));
                }
                $('#pc-daterangepicker-6').daterangepicker({
                    buttonClasses: ' btn',
                    applyClass: 'btn-primary',
                    cancelClass: 'btn-secondary',
                    startDate: start,
                    endDate: end,
                    showDropdowns: true,
                    minDate: moment('2024-01-01'),
                    maxDate: moment().add(3, 'months'),
                    opens: 'right',
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
                    if (endVal.isAfter(startVal.clone().add(89, 'days'), 'day')) {
                        endVal = startVal.clone().add(89, 'days');
                        msgbox("Selected end date exceeds maximum date.End date processed: " + endVal.format("MM/DD/YYYY") + ".!", "", "warning");
                    }
                    end = endVal.format('YYYY-MM-DD');
                    $('#pc-daterangepicker-6 .form-control').val(startVal.format('MM/DD/YYYY') + ' / ' + endVal.format('MM/DD/YYYY'));
                    localStorage.setItem("logDateRange", startVal.format("MM/DD/YYYY") + ' / ' + endVal.format("MM/DD/YYYY"));
                });

                $('td[data-event-time]').each(function () {
                    var eventTime = $(this).data('event-time');
                    var utcDate = convertLocalDateToUTCDate(eventTime);
                    $(this).text(utcDate);
                });
                var searchColumn = '';
                var searchValue = '';
                var innerSearchValue = '';
                var searchValueDt = '';
                var multiSearchColumn = [];
                var multiSearchValue = [];
                var orderData = [];
                var checkedIndexes = [];
                var isCheckAllClicked = 0;
                var currentTableResponse = [];
                var currentTableRowTotal = 0;
                var maxRowsForExport = 0;
        <c:forEach var="limitVal" items="${maxLimitForExport}">
                maxRowsForExport = '${limitVal}';
        </c:forEach>
                $('#headercheck').prop('checked', false);
                var checked = 0;
                var rowsCount;
                var recordsFiltered = 0;
                var exportType;

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
                    var visibleColumns = table.columns(':visible').indexes().toArray();
                    visibleColumns.shift();
                    var visibleColumnsParam = visibleColumns.join(',');
                    $('#flading').show();
                    location.href = "export-auditlog-data-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                    $('.loader1').addClass("process-hide");
                    $('#flading').hide();
                    $('#export-flading').hide();
                    deselectAllFunction();
                }

                function exportCurrentTable(exportType) {
                    var visibleColumns = table.columns(':visible').indexes().toArray();
                    visibleColumns.shift();
                    var visibleColumnsParam = visibleColumns.join(',');
                    $('#flading').show();
                    if (checkedIndexes.length > 0) {
                        location.href = "export-auditlog-data-report?startIndex=" + checkedIndexes[0] + "&endIndex=" + checkedIndexes[checkedIndexes.length - 1] + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                    } else {
                        location.href = "export-auditlog-data-report?startIndex=0&endIndex=" + (currentTableResponse.length - 1) + "&selectedIndexes=&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                    }
                    $('.loader1').addClass("process-hide");
                    $('#flading').hide();
                    $('#export-flading').hide();
                    deselectAllFunction();
                }

                function exportAll(exportType) {
                    var visibleColumns = table.columns(':visible').indexes().toArray();
                    visibleColumns.shift();
                    var visibleColumnsParam = visibleColumns.join(',');
                    // re-run the current search without paging so the session holds every filtered row
                    $.ajax({
                        url: 'get-auditlog-data',
                        type: 'POST',
                        contentType: 'application/json',
                        dataType: 'json',
                        data: JSON.stringify({
                            "start": 0,
                            "length": -1,
                            "startDate": moment(start).format("YYYY-MM-DD"),
                            "endDate": moment(end).format("YYYY-MM-DD"),
                            "multiSearchColumn": multiSearchColumn.toString(),
                            "multiSearchValue": multiSearchValue.toString(),
                            "search": {"value": searchValueDt, "regex": false},
                            "order": orderData
                        }),
                        success: function (data) {
                            $('#flading').show();
                            location.href = "export-auditlog-data-report?startIndex=-1&endIndex=-1&selectedIndexes=" + checkedIndexes + "&visibleColumns=" + visibleColumnsParam + "&exportType=" + exportType;
                            $('.loader1').addClass("process-hide");
                            $('#flading').hide();
                            $('#export-flading').hide();
                            deselectAllFunction();
                        }
                    });
                }

                var total = 0;
                $('#simpletable').on('click', 'tbody input[type="checkbox"]', function () {
                    var table = $('#simpletable').DataTable();
                    total = table.column(1, {page: 'current'}).data().count();
                    var isSelected = $(this).is(':checked');
                    if (isSelected) {
                        checked++;
                    } else {
                        checked--;
                    }
                    if (checked === total) {
                        $('#headercheck').prop('checked', true);
                    } else {
                        $('#headercheck').prop('checked', false);
                    }
                });

                $('#headercheck').change(function () {
                    var table = $('#simpletable').DataTable();
                    total = table.column(1, {page: 'current'}).data().count();
                    checked = 0;
                    var isSelected = $(this).is(':checked');
                    if (isSelected) {
                        $('#simpletable tbody input[type=checkbox]').each(function () {
                            $(this).prop('checked', true);
                            if (checked <= total) {
                                checked++;
                            }
                        });
                    } else {
                        $('#simpletable tbody input[type=checkbox]').each(function () {
                            $(this).prop('checked', false);
                            if (checked > 0) {
                                checked--;
                            }
                        });
                    }
                });

                function handleOrderChange(settings) {
                    // Get the DataTable instance
                    var table = $('#simpletable').DataTable();
                    // Get the current order
                    var currentOrder = table.order();
                    // Extract the column index and sorting direction
                    if (currentOrder.length > 0) {
                        var columnIndex = currentOrder[0][0]; // Index of the sorted column
                        var sortingDirection = currentOrder[0][1]; // Sorting direction ('asc' or 'desc')
                        // Update the orderData variable based on the current order
                        var column = table.column(columnIndex);
                        var dataElement = column.header().getAttribute('data-element') || "";
                        orderData = sortingDirection ? [{"columnName": dataElement, "dir": sortingDirection}] : [];
                    } else {
                        orderData = [];
                    }
                }

                var table = $('#simpletable').DataTable({
                    "aaSorting": [],
                    "lengthMenu": [10, 30, 50, 100, 200, 500],
                    "pageLength": 100,                    
                    stateSave: true,
                    scrollY: "60vh",
                    scrollX: true,
                    scrollCollapse: false,
                    paging: true,
                    fixedHeader: false,
                    "oLanguage": {
                        "sEmptyTable": "No Data...",
                        "sLoadingRecords": "No Data..."
                    },
                    'columnDefs': [{
                            'visible': true,
                            'ordering': false,
                            'targets': [0] // column index (start from 0)
                        }],
                    processing: true,
                    serverSide: true,
                    "ajax": {
                        "type": "POST",
                        "url": 'get-auditlog-data',
                        "contentType": 'application/json',
                        "dataType": "json",
                        "data": function (d) {
                            return JSON.stringify($.extend({}, d, {
                                "startDate": moment(start).format("YYYY-MM-DD"),
                                "endDate": moment(end).format("YYYY-MM-DD"),
                                "multiSearchColumn": multiSearchColumn.toString(),
                                "multiSearchValue": multiSearchValue.toString(),
                                "search": {
                                    "value": searchValueDt,
                                    "regex": false
                                },
                                "order": orderData
                            }));
                        }, dataSrc: function (data) {
                            rowsCount = data.data.length;
                            if (data.exportData) {
                                currentTableResponse = JSON.parse(data.exportData);
                                recordsFiltered = data.recordsFiltered;
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
                        {"data": "logId", "orderable": true, "searchable": true, "name": "logId"},
                        {"data": "userName", "orderable": true, "searchable": true, "name": "userName"},
                        {"data": "affectedUser", "orderable": true, "searchable": true, "name": "affectedUser"},
                        {"data": "userType", "orderable": true, "searchable": true, "name": "userType"},
                        {"data": "auditLogType", "orderable": true, "searchable": true, "name": "auditLogType"},
                        {"data": "performedBy", "orderable": true, "searchable": true, "name": "performedBy"},
                        {"data": function (data) {
                                return " " + convertLocalDateToUTCDate(data.eventTime);
                            }, "orderable": true, "searchable": true, "name": "eventTime"},
                        {"data": "ipAddress", "orderable": true, "searchable": true, "name": "ipAddress"},
                        {"data": "browserName", "orderable": true, "searchable": true, "name": "browserName"}
                    ],
                    dom: '<"d-flex justify-content-between align-items-center mb-2"B f>rt<"d-flex justify-content-between align-items-center mt-2"l i p>',
                    buttons: [
                        {
                            extend: 'csv',
                            text: '<img src="assets/images/excelicon.png">',
                            className: 'dt-pdf-btn ',
                            titleAttr: 'Download list in excel Format',
                            action: function (e, dt, button, config) {
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
                        }
                    ],
                    preDrawCallback: function (settings) {
                        handleOrderChange(settings);
                    },
                    drawCallback: function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip('update');
                    },
                    createdRow: function (row, data, dataIndex) {
                    }, footerCallback: function (tfoot, data, start, end, display) {
                        $('#flading').hide();
                    }
                  }); 
                showProcessing();
                table.on('search.dt', function () {
                    $('#flading').show();
                    searchValueDt = getModifiedSearchValue(table.search().trim());
                });
                $('#search').click(function () {
                    multiSearchColumn = [];
                    multiSearchValue = [];

                    if ($('#userName').val().trim().length > 0) {
                        multiSearchColumn.push('um.username');
                        multiSearchValue.push(getModifiedSearchValue($('#userName').val().trim()));
                    }

                    if ($('#userType').val() != 0) {
                        multiSearchColumn.push('ut.user_type_id');
                        multiSearchValue.push($('#userType').val());
                    }
                    if ($('#logType').val() != 0) {
                        multiSearchColumn.push('lt.log_type_id');
                        multiSearchValue.push($('#logType').val());
                    }
                    if ($('#browserName').val().trim().length > 0) {
                        multiSearchColumn.push("browser");
                        multiSearchValue.push(getModifiedSearchValue($('#browserName').val().trim()));
                    }

                    if (multiSearchColumn.length > 0) {
                        table.columns().search('').search().draw();
                    } else {
                        table.draw();
                    }
                });

                $('#showall').click(function () {
                    multiSearchColumn = [];
                    multiSearchValue = [];
                    $('#browserName').val('');
                    $('#logType').val('').change();
                    $('#userName').val('');
                    $('#userType').val('').change();
                    resetDate();
                    table.columns().search('').search().draw();
                });

                function resetDate() {
                    start = moment().subtract(6, 'days');
                    end = moment();
                    $('#pc-daterangepicker-6').data('daterangepicker').setStartDate(start);
                    $('#pc-daterangepicker-6').data('daterangepicker').setEndDate(end);
                    $('#pc-daterangepicker-6 .form-control').val(start.format('MM/DD/YYYY') + ' / ' + end.format('MM/DD/YYYY'));
                    $('#pc-daterangepicker-6 .form-control').val(start.format('MM/DD/YYYY') + ' / ' + end.format('MM/DD/YYYY'));
                    localStorage.setItem("logDateRange", moment(start).format("MM/DD/YYYY") + ' / ' + moment(end).format("MM/DD/YYYY"));
                }

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
//                    let newEnd = moment(nextDates.nextToDate);
//                    let maxDate = moment();
//                    if (newEnd.isAfter(maxDate)) {
//                        msgbox("Data cannot be shown for future dates.", "", "warning");
//                        return;
//                    }
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

            });
            function selectNextuserType() {
                const $selectElement = $('#userType');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPrevioususerType() {
                const $selectElement = $('#userType');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextuserType").on("click", function () {
                selectNextuserType();
                defaultSets();
            });

            $("#previoususerType").on("click", function () {
                selectPrevioususerType();
                defaultSets();
            });


            function selectNextlogType() {
                const $selectElement = $('#logType');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex < $selectElement.find('option').length - 1) {
                    $selectElement.prop('selectedIndex', currentIndex + 1).trigger('change');
                }
            }
            function selectPreviouslogType() {
                const $selectElement = $('#logType');
                const currentIndex = $selectElement.prop('selectedIndex');
                if (currentIndex > 1) {
                    $selectElement.prop('selectedIndex', currentIndex - 1).trigger('change');
                }
            }

            $("#nextlogType").on("click", function () {
                selectNextlogType();
                defaultSets();
            });

            $("#previouslogType").on("click", function () {
                selectPreviouslogType();
                defaultSets();
            });
    </script>     