/// DHCOPBILLINVSeatch.js

$(function () {
    init_Layout();

    $HUI.linkbutton("#Print", {
        onClick: function () {
            Print_OnClick();
        }
    });
	
    $HUI.linkbutton("#Find", {
        onClick: function () {
            Find_click();
        }
    });

    $('#Type').combobox({
        panelHeight: 'auto',
        valueField: 'id',
        textField: 'text',
        editable: false,
        data: [{id: 'O', text: $g('门诊'), selected: true},
        	   {id: 'I', text: $g('住院')}
        ]
    });
});

function Find_click() {
    $.m({
	    ClassName: "web.DHCOPBILLINVSeatch",
	    MethodName: "GetInvInfoByInv",
	    StInv: getValueById("StInv"),
	    EnInv: getValueById("EnInv"),
	    AdmType: getValueById("Type"),
	    Exp: getValueById("Exp"),
	    HospId: session['LOGON.HOSPID']
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("NormSum", myAry[0]);
	    setValueById("Normnum", myAry[5]);
	    setValueById("Renum", myAry[1]);
	    setValueById("ReSum", myAry[2]);
	    setValueById("Voidnum", myAry[3]);
	    setValueById("VoidSum", myAry[4]);
	    setValueById("TotalAcount", myAry[6]);
	});
}

function Print_OnClick() {
    var NormSum = getValueById('NormSum');
    var ReSum = getValueById('ReSum');
    var VoidSum = getValueById('VoidSum');
    var TotalAcount = getValueById('TotalAcount');
    if (!((NormSum > 0) || (ReSum > 0) || (VoidSum > 0) || (TotalAcount > 0))) {
        $.messager.popover({msg: '没有打印的数据', type: 'info'});
        return;
    }
    var StInv = getValueById("StInv");
    var EnInv = getValueById("EnInv");
    var Exp = getValueById("Exp");
    var AdmType = getValueById("Type");
    fileName = "DHCBILL-INVSearch.rpx&StInv=" + StInv + "&EnInv=" + EnInv + "&AdmType=" + AdmType + "&Exp=" + Exp;
    fileName += "&HospId=" + session['LOGON.HOSPID'];
    var width = $(window).width() * 0.8;
	var height  = $(window).height() * 0.8;
    DHCCPM_RQPrint(fileName, width, height);
}

function init_Layout() {
    DHCWeb_ComponentLayout();
    $('#cNormnum').parent().parent().css("width", "99px");
}