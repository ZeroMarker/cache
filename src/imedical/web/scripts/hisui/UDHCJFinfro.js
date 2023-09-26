/// UDHCJFinfro.js

$(function () {
	init_Layout();
	var defDate = getDefStDate(0);
	setValueById("stdate", defDate);
	setValueById("enddate", defDate);

	$("#regno").keydown(function (e) {
		regNoKeydown(e);
	});
	
	$("#name").keydown(function (e) {
		patNameKeydown(e);
	});

	$HUI.linkbutton("#clear", {
		onClick: function () {
			Clear_Click();
		}
	});
		
	$HUI.linkbutton("#outExp", {
		onClick: function () {
			outExp_click();
		}
	});
	
	$HUI.combobox("#currentFlag", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'id',
		textField: 'text',
		data:[{
    			id: 'flagout',
    			text: '退院'
    		},{
    			id: 'PaidFlag',
    			text: '已结算'
    		},{
    			id: 'CurAdmFlag',
    			text: '当前在院',
    			selected: true
    		},{
    			id: 'flagin',
    			text:'入院'
    		}]
	});
	
	$HUI.combobox("#warddesc", {
		url: $URL + '?ClassName=web.UDHCJFinfro&QueryName=FindWard&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.desc = "";
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function (newValue, oldValue) {
			setValueById("wardid", (newValue || ""));
		}
	});
	
	$HUI.combobox("#admreason", {
		url: $URL + '?ClassName=web.UDHCJFinfro&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function (newValue, oldValue) {
			setValueById("admreasonid", (newValue || ""));
		}
	});
	
	$HUI.combobox("#username", {
		url: $URL + "?ClassName=web.UDHCJFinfro&QueryName=FindCashier&ResultSetType=array",
		valueField: "id",
		textField: "text",
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function (newValue, oldValue) {
			setValueById("userid", (newValue || ""));
		}
	});
});

function regNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var regNo = $(e.target).val();
		if ((regNo)&&(checkno(regNo))) {
			var patientNo = $.m({
				ClassName: "web.UDHCJFBaseCommon",
				MethodName: "regnocon",
				PAPMINo: regNo
			}, false);
			$(e.target).val(patientNo);
		}
		$("#find").click();
	}
}

function patNameKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$("#find").click();
	}
}

function checkno(inputtext) {
	var checktext = "1234567890";
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum = checktext.indexOf(chr);
		if (indexnum < 0) {
			return false;
		}
	}
	return true;
}

function Clear_Click() {
	$(":text:not(.pagination-num, .datebox-f)").val("");
	$(".combobox-f:not(#currentFlag)").combobox("setValue", "");
	$("#currentFlag").combobox("select", "CurAdmFlag");
	$(".datagrid-f").datagrid("loadData", {
		total: 0,
		rows: []
	});
	var today = getDefStDate(0);
	setValueById("stdate", today);
	setValueById("enddate", today);
}

function outExp_click() {
	var stdate = getValueById("stdate");
	var enddate = getValueById("enddate");
	var admreasonid = getValueById("admreasonid");
	var userid = getValueById("userid");
	var wardid = getValueById("wardid");
	var name = getValueById("name");
	var regno = getValueById("regno");
	var currentFlag = getValueById("currentFlag");
	var hospId = getValueById("hospId");
	var fileName = "DHCBILL-IPBILL-HZYLB.rpx&stdate=" + stdate + "&enddate=" + enddate + "&admreasonid=" + admreasonid;
	fileName += "&userid=" + userid + "&regno=" + regno + "&name=" + name;
	fileName += "&wardid=" + wardid + "&currentFlag=" + currentFlag + "&hospId=" + hospId;
	DHCCPM_RQPrint(fileName, 800, 500);
}

function init_Layout() {
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
	$('.first-col').parent().parent().parent().css('margin-top', '1px');
	$('#PageContent').find('.panel-body-noheader').css('margin-top', '1px');
	$('#cstdate').parent().parent().css('width', '72px');
	$('.datagrid-sort-icon').text('');
	
	//固定列头
	$('#tUDHCJFinfro').datagrid({
		frozenColumns:[[{field:'Tregno', title:'登记号', width: 120},
						{field:'Tname', title:'姓名', width: 100}
		]],
		onLoadSuccess:function(data) {
			$('.datagrid-sort-icon').text('');  // 金额列 文字和金额右对齐
			$('.datagrid-view2').find('td[field=Tregno]').hide();
			$('.datagrid-view2').find('td[field=Tname]').hide();
		}
	});
	$('#tUDHCJFinfro').datagrid('reload');
}