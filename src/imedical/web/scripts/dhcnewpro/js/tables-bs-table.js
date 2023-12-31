
// Tables-BS-Table.js
// ====================================================================
// This file should not be included in your project.
// This is just a sample how to initialize plugins or components.
//
// - ThemeOn.net -



$(document).ready(function() {


    // BOOTSTRAP TABLES USING FONT AWESOME ICONS
    // =================================================================
    // Require Bootstrap Table
    // http://bootstrap-table.wenzhixin.net.cn/
    //
    // =================================================================
    jQuery.fn.bootstrapTable.defaults.icons = {
        paginationSwitchDown: 'fa-arrow-down',
        paginationSwitchUp: 'fa-arrow-up',
        refresh: 'fa-refresh',
        toggle: 'fa-th-large',
        columns: 'fa-th-list',
        detailOpen: 'fa-add',
        detailClose: 'fa-remove'
    }





    // EDITABLE - COMBINATION WITH X-EDITABLE
    // =================================================================
    // Require X-editable
    // http://vitalets.github.io/x-editable/
    //
    // Require Bootstrap Table
    // http://bootstrap-table.wenzhixin.net.cn/
    //
    // Require X-editable Extension of Bootstrap Table
    // http://bootstrap-table.wenzhixin.net.cn/
    // =================================================================
    $('#demo-editable').bootstrapTable({
		showRefresh:true,
		showToggle:true,
		iconsPrefix:'fa',
		clickToSelect:true,
        idField: 'id',
        url: 'data/bs-table.json',
		toolbar: '#toolbar',                //工具按钮用哪个容器
        columns: [{
            checkbox: true
        },{
            field: 'ff',
            formatter:'invoiceFormatter',
            title: '打印标记'
        }, {
            field: 'name',
            title: 'Name',
            editable: {
                type: 'text'
            }
        }, {
            field: 'date',
            title: '登记号'
        }, {
            field: 'amount',
            title: '床位号',
            editable: {
                type: 'text'
            }
        }, {
            field: 'status',
            align: 'center',
            title: '病人姓名',
            formatter:'statusFormatter'
        }, {
            field: 'track',
            title: '病人身份',
			align: 'center',
            editable: {
                type: 'text'
            }
        }]
    });



    // X-EDITABLE USING FONT AWESOME ICONS
    // =================================================================
    // Require X-editable
    // http://vitalets.github.io/x-editable/
    //
    // Require Font Awesome
    // http://fortawesome.github.io/Font-Awesome/icons/
    // =================================================================
    $.fn.editableform.buttons =
        '<button type="submit" class="btn btn-primary editable-submit">'+
            '<i class="fa fa-fw fa-check"></i>'+
        '</button>'+
        '<button type="button" class="btn btn-default editable-cancel">'+
            '<i class="fa fa-fw fa-times"></i>'+
        '</button>';





    // BOOTSTRAP TABLE - CUSTOM TOOLBAR
    // =================================================================
    // Require Bootstrap Table
    // http://bootstrap-table.wenzhixin.net.cn/
    // =================================================================
    var $table = $('#demo-custom-toolbar'),	$remove = $('#demo-delete-row');

    $table.on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
        $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);
    });

    $remove.click(function () {
        var ids = $.map($table.bootstrapTable('getSelections'), function (row) {
            return row.id
        });
        $table.bootstrapTable('remove', {
            field: 'id',
            values: ids
        });
        $remove.prop('disabled', true);
    });


});




// FORMAT COLUMN
// Use "data-formatter" on HTML to format the display of bootstrap table column.
// =================================================================


// Sample format for Invoice Column.
// =================================================================
function invoiceFormatter(value, row) {
    return '<a href="#" class="btn-link" > Order #' + value + '</a>';
}




// Sample Format for User Name Column.
// =================================================================
function nameFormatter(value, row) {
    return '<a href="#" class="btn-link" > ' + value + '</a>';
}




// Sample Format for Order Date Column.
// =================================================================
function dateFormatter(value, row) {
    var icon = row.id % 2 === 0 ? 'fa-star' : 'fa-user';
    return '<span class="text-muted"><i class="fa fa-clock-o"></i> ' + value + '</span>';
}



// Sample Format for Order Status Column.
// =================================================================
function statusFormatter(value, row) {
    var labelColor;
    if (value == "Paid") {
        labelColor = "success";
    }else if(value == "Unpaid"){
        labelColor = "warning";
    }else if(value == "Shipped"){
        labelColor = "info";
    }else if(value == "Refunded"){
        labelColor = "danger";
    }
    var icon = row.id % 2 === 0 ? 'fa-star' : 'fa-user';
    return '<div class="label label-table label-'+ labelColor+'"> ' + value + '</div>';
}



// Sample Format for Tracking Number Column.
// =================================================================
function trackFormatter(value, row) {
    if (value) return '<i class="fa fa-plane"></i> ' + value;
}



// Sort Price Column
// =================================================================
function priceSorter(a, b) {
    a = +a.substring(1); // remove $
    b = +b.substring(1);
    if (a > b) return 1;
    if (a < b) return -1;
    return 0;
}

