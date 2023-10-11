/// DHCOPBillPayorShareFee.js

$(function () {
	init_Layout();
	
	$HUI.linkbutton('#BFind', {
		onClick: function () {
			BFindClick();
		}
	});
	
	$HUI.linkbutton('#BPrint', {
		onClick: function () {
			PrintClick();
		}
	});
	
	$HUI.combobox("#PatTypeStat", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array',
       	valueField: 'id',
		textField: 'text',
    	blurValidValue: true,
    	defaultFilter: 5,
		onBeforeLoad:function(param){
			param.hospId = session['LOGON.HOSPID'];
			param.langId = session['LOGON.LANGID'];
		}
   	});
	
	// 核算大类
	$HUI.combobox('#StatFlag', {
	    panelHeight: 'auto',
	    editable: false,
	    data: [{value: 'TOC', text: $g('门诊大类'), selected: true},
	           {value: 'TAC', text: $g('会计大类')}
	    ],
	    valueField: 'value',
	    textField: 'text',
	    onChange: function (newValue, oldValue) {
	        var ele = (newValue == "TOC") ? "getTarOCCat" : "getTarACCat";
	        var encmeth = getValueById(ele);
	        var cateStr = cspRunServerMethod(encmeth, session['LOGON.HOSPID']);
	        var cateAry = cateStr.split("^");
	        var catCount = cateAry.length;
	        var objtbl = $('#tDHCOPBillPayorShareFee');
	        for (var i = 1; i <= catCount; i++) {
	            $.extend(objtbl.datagrid("getColumnOption", ("TCAT" + i)), {title: cateAry[i - 1], align: 'right'});
	        }
	        for (var i = catCount + 1; i <= 27; i++) {
	            objtbl.datagrid("hideColumn", ("TCAT" + i)); //隐藏
	        }
			
	        LoadCateFeeList();
	    }
	});
});

function BFindClick() {
	LoadCateFeeList();
}

function LoadCateFeeList() {
    var StDate = getValueById("StDate");
    var EndDate = getValueById("EndDate");
    var InsType = getValueById("PatTypeStat");
    var StatFlag = getValueById('StatFlag');
    var HospId = session['LOGON.HOSPID'];
    $("#tDHCOPBillPayorShareFee").datagrid({
        queryParams: $.extend($("#tDHCOPBillPayorShareFee").datagrid("options").queryParams, {
            StDate: StDate,
            EndDate: EndDate,
            StatFlag: StatFlag,
            PatTypeStat: InsType,
            HospId: HospId
        })
    });
}

function PrintClick() {
	var data = $('#tDHCOPBillPayorShareFee').datagrid("getData");
	if (data.total == 0) {
		$.messager.popover({msg: "没有需要打印的数据", type: "info"});
	}
	var row = data.rows[0];
	if (!row || !row.TTMPJID) {
		return;
	}
	var pid = row.TTMPJID;
	var StDate = getValueById("StDate");
	var EndDate = getValueById("EndDate");
	var StatFlag = getValueById('StatFlag');
	var fileName = "DHCBILL-OPBILL-PayorShareFee.rpx";
	fileName += "&TMPGID=" + pid + "&StartDate=" + StDate+ "&EndDate=" + EndDate + "&CatType=" + StatFlag;
	fileName += "&HospId=" + session['LOGON.HOSPID'];
	DHCCPM_RQPrint(fileName, 1200, 750);
}

function init_Layout() {
	DHCWeb_ComponentLayout();
}