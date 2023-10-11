/// UDHCJFQFPATIENT.js

var Adm;

$(function () {
	ini_LayoutStyle();
	
	var defDate = getDefStDate(0);
	setValueById('Stdate', defDate);
	setValueById('Enddate', defDate);

	$HUI.linkbutton('#Print', {
		onClick: function () {
			PrintClick();
		}
	});
	
	$HUI.linkbutton('#UPQFFlag', {
		onClick: function () {
			UPQFFlagClick();
		}
	});
	
	$HUI.linkbutton('#UPCanQFFlag', {
		onClick: function () {
			UPCanQFFlagClick();
		}
	});
	
	//余额
	$HUI.combobox("#LeftAmt", {
		panelHeight: "auto",
		editable: false,
		valueField: 'id',
		textField: 'text',
		data:[{id: 'plus', text: '余额大于0'},
			  {id: 'equal', text: '余额等于0'},
			  {id: 'min', text: '余额小于0', selected: true}
			  ],
		onChange: function (newValue, oldValue) {
			switch(newValue) {
				case "plus":
					setValueById("jy", 1);
					setValueById("qf", 0);
					setValueById("zero", 0);
					break;
				case "equal":
					setValueById("jy", 0);
					setValueById("qf", 0);
					setValueById("zero", 1);
					break;
				case "min":
					setValueById("jy", 0);
					setValueById("qf", 1);
					setValueById("zero", 0);
					break;
				default:
			}
		}
	});
	
	//在院状态
	$HUI.combobox("#CurrentFlag", {
		panelHeight: "auto",
		editable: false,
		valueField: "id",
		textField: "text",
		data:[{id: 'in', text: '在院', selected: true},
			  {id: 'out', text: '出院未结算'}
			 ],
		onChange: function (newValue, oldValue) {
			switch(newValue){
				case "in":
					setValueById("Admitval", 1);
					setValueById("Dischval", 0);
					break;
				case "out":
					setValueById("Admitval", 0);
					setValueById("Dischval", 1);
					break;
				default:
			}
		}
	});
	
	$HUI.combobox("#CtLoc", {
		url: $URL + '?ClassName=web.UDHCJFQFPATIENT&QueryName=FindDept&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		mode: 'remote',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function (newValue, oldValue) {
			setValueById("Locid", (newValue || ""));
		}
	});
	
	$HUI.combobox("#WardCombo", {
		url: $URL + "?ClassName=web.UDHCJFQFPATIENT&QueryName=FindWard&ResultSetType=array",
		valueField: 'id',
		textField: 'text',
		mode: 'remote',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function (newValue, oldValue) {
			setValueById("wardid", (newValue || ""));
		}
	});
});

function PrintClick() {
	var Stdate = getValueById('Stdate');
	var Enddate = getValueById('Enddate');
	var qf = getValueById('qf');
	var jy = getValueById('jy');
	var zero = getValueById('zero');
	var Locid = getValueById('Locid');
	var wardid = getValueById('wardid');
	var Admitval = getValueById('Admitval');
	var Dischval = getValueById('Dischval');
	var HospId = getValueById('HospId');
	fileName = "DHCBILL-IPBILL-QFPATIENT.rpx" + "&Stdate=" + Stdate+ "&Enddate=" + Enddate+ "&qf=" + qf+ "&jy=" + jy+ "&Locid=" + Locid+ "&wardid=" + wardid;
	fileName += "&Admitval=" + Admitval + "&Dischval=" + Dischval+ "&zero=" + zero + "&HospId=" + HospId;
	DHCCPM_RQPrint(fileName, 1200, 750);
}

function SelectRowHandler(index, rowData) {
	Adm = rowData.Tadmrowid;
}

function UPQFFlagClick() {
	if (Adm == "") {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var userid = session['LOGON.USERID'];
	var flag = 1;
	var AdmArrearsinfro = Adm + "^" + userid + "^" + flag;
	$.m({
		ClassName: "web.UDHCJFQFPATIENT",
		MethodName: "UpAdmArrears",
		AdmArrearsinfro: AdmArrearsinfro
	}, function(rtn) {
		if (rtn == 0) {
			$.messager.popover({msg: "为患者置欠费标志成功", type: "success"});
			return;
		} 
		if (rtn == 1) {
			$.messager.popover({msg: "该患者已经欠费不需再置欠费标志", type: "error"});
			return;
		}
		$.messager.popover({msg: "为患者置欠费标志失败", type: "error"});
	});	
}

function UPCanQFFlagClick() {
	if (Adm == "") {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var userid = session['LOGON.USERID'];
	var flag = 0;
	var AdmArrearsinfro = Adm + "^" + userid + "^" + flag;
	$.m({
		ClassName: "web.UDHCJFQFPATIENT",
		MethodName: "UpAdmArrears",
		AdmArrearsinfro: AdmArrearsinfro
	}, function(rtn) {
		if (rtn == 0) {
			$.messager.popover({msg: "取消欠费标志成功", type: "success"});
			return;
		}
		if (rtn == 1) {
			$.messager.popover({msg: "该患者已经取消欠费标志不需取消欠费标志", type: "error"});
			return;
		}
		$.messager.popover({msg: "取消欠费标志失败", type: "error"});
	});
}

function ini_LayoutStyle() {
	$('.datagrid-sort-icon').text('');
	$('td.i-tableborder>table').css("border-spacing","0px 8px");
	$('.first-col').parent().parent().parent().css('margin-top','2px');
	$('#PageContent').find('.panel-body-noheader').css('margin-top','1px');
	$('#PageContent>table').find('label').css("margin-right","9px");
}