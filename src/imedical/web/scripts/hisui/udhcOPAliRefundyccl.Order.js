///udhcOPAliRefundyccl.Order.js

var trefundSum = 0;
var trefundSumFlag = 0;

$(function() {
	init_Layout();
    IntDoument();
});

function IntDoument() {
	var opt = $HUI.datagrid('#tudhcOPAliRefundyccl_Order').options;
	$.extend(opt, {
		onLoadSuccess: function (data) {
			trefundSum = 0;
            if (trefundSumFlag != 0) {
                return;
            }
            $.each(data.rows, function (index, row) {
                trefundSumFlag = trefundSumFlag + 1;
              	trefundSum = trefundSum + parseFloat(row.TOrderSum);
                trefundSum = Math.round(trefundSum * 100) / 100;
            });
            
            CalCurRefund();
        }
	});
}

function CalCurRefund() {
    var mainobj = parent.frames["udhcOPAliRefundYCCL"];
    if (mainobj) {
        var obj = mainobj.document.getElementById("RefundSum");
        if (obj) {
            obj.value = trefundSum;
        }
        var obj = mainobj.document.getElementById("FactRefSum");
        if (obj) {
            obj.value = trefundSum;
        }
    }
    return trefundSum;
}

function SelectRowHandler() {
    CalCurRefund();
}

function init_Layout() {
    DHCWeb_ComponentLayout();
}

function NoHideAlert(info) {
    DHCWeb_HISUIalert(info);
}