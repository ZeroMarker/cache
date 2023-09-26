/**
*FileName:	dhcipbillchargesearch.js
*Anchor:	Lid
*Date:	2015-01-21
*Description:	新版住院收费多条件查询界面
*/


//初始化查询界面面板
function initSearchPanel() {
	jQuery('#searchStDate').val(getDefStDate(-30));
	//add 14.11.15 控制未结算和最终结算互斥，默认未最终结算
	//+2017-05-25 modify by ZhYW 
	//jQuery("#checkCurAdm, #checkFinal, #checkMedical, #checkPayflag").get(0).checked = false;
	//将【当前在院】checkBox设为默认勾选
	var defaultValue = "checkCurAdm";
	jQuery("#" + defaultValue).attr({checked: 'checked'});
	var checkArray = ["checkCurAdm", "checkFinal", "checkMedical", "checkPayflag"];
	jQuery.each(checkArray, function(index, value) {
		if ((defaultValue != value) && (jQuery("#" + value).attr('checked'))){
			jQuery("#" + defaultValue).removeAttr('checked');
		}
	})
	//
	jQuery("#checkCurAdm, #checkFinal, #checkMedical, #checkPayflag").on("click", this, function(e) {
		e.stopPropagation();
		//var checkArray = ["checkCurAdm", "checkFinal", "checkMedical", "checkPayflag"];
		jQuery.each(checkArray, function(index, value) {
			if(this.id != value) {
				jQuery("#" + value).get(0).checked = false;
			}
		})
		jQuery("#" + this.id).get(0).checked = true;
	});

	initSearchPatAdmList();
}

function initSearchPatAdmList() {
	jQuery("#tpatAdmList").datagrid({
		fit:true,
		width: 'auto',
		border:true,
		//height:300,	    //jQuery("#tt").tabs("options").height-200,               
		striped: true,  	//是否显示斑马线效果
		singleSelect : true,
		selectOnCheck: false,
		fitColumns:false,
		autoRowHeight:false,
		scrollbarSize:'10px',
		url:null,
		loadMsg:'Loading...',
		pagination: true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers: true,  //如果为true，则显示一个行号列。
		pageSize: 10,
		remoteSort: false,
		pageNumber:1,
		pageList:[10,25,50,100],
		columns:[[  
			{ title: '登记号', field: 'TpatNo',width:100},
			{ title: '病案号', field: 'TpatMedicare' ,width:80},
			{ title: '姓名',  field: 'TpatName' ,width:80},
			{ title: '年龄', field: 'Tage',width:40},
			{ title: '科室', field: 'TpatLoc' ,width:120},
			{ title: '病区',  field: 'TpatWard',width:160 },
			{ title: '床位', field: 'TpatBed',width:80 },
			{ title: '就诊日期',  field: 'TadmDate',width:80 },
			{ title: '就诊时间', field: 'TadmTime',width:80},
			{ title: '出院日期', field: 'TdiscDate',width:80},
			{ title: '出院时间', field: 'TdiscTime',width:80},
			{ title: '性别', field: 'Tsex',width:30 },
			{ title: '费别',  field: 'TadmReason',width:80}
		]],
		onBeforeLoad: function(data) {
		},
		onLoadSuccess: function(data) {
		},
		onLoadError: function() {
			jQuery.messager.alert('错误', '加载查询病人列表失败.');
		},
		onDblClickRow: function(rowIndex, rowData) {
			jQuery("#chargeSearchPanel").window("close");
			jQuery("#patientNO").val(rowData.TpatNo);
			jQuery("#medicareNO").val(rowData.TpatMedicare);
			getPatInfo();
		}

	});
}

//初始化查询界面事件
function initSearchEvent() {
	jQuery('#searchStDate,#searchEndDate').off("click").on("click",searchDateClick);
	jQuery("#searchAdmReason").off("click").on("click", searchAdmReasonClick);
	jQuery('#searchBtnFind').off("click").on("click",searchBtnClick);
	jQuery("#searchBtnClear").off("click").on("click", searchClear);
	jQuery("#searchPatLoc").off("click").on("click", searchLocClick);
	jQuery("#searchPatWard").off("click").on("click", searchWardClick);
}

//日期初始化
function searchDateClick() {
	WdatePicker({
		isShowClear:true,
		skin:'ext',
		dateFmt:'yyyy-MM-dd',
		readOnly:false //平台接口
		
	});
}
//费别初始化
function searchAdmReasonClick() {
	jQuery('#searchAdmReason').combobox({
		panelHeight:80,
		multiple: false,
		url:QUERY_URL.QUERY_COMBO_URL,  
		valueField:'typeid',    
		textField:'type',
		editable: false,
		disabled: false, //平台接口
		readonly: false, //平台接口
		onShowPanel:function(){
			//var url = './dhcbill.query.combo.easyui.csp';    
			//jQuery('#comboCardTypeDR').combobox('reload', url);   
		},
		onBeforeLoad:function(param){
			param.ClassName = "web.DHCIPBillCashier";
			param.QueryName = "typelookup";
		},
		onLoadSuccess: function() {
			jQuery(this).combobox("showPanel");
		},
		onLoadError: function() {
			jQuery.messager.alert("错误", "费别列表加载错误");
		}
	});	
}
//科室初始化
function searchLocClick() {
	jQuery('#searchPatLoc').combobox({
		panelHeight:80,
		multiple: false,
		url:QUERY_URL.QUERY_COMBO_URL,  
		valueField:'locid',    
		textField:'loc',
		mode:'remote',
		editable: true,
		disabled: false, 
		readonly: false,
		onShowPanel:function(){
			//var url = './dhcbill.query.combo.easyui.csp';    
			//jQuery('#comboCardTypeDR').combobox('reload', url);   
		},
		onBeforeLoad:function(param){
			var patLocVal = jQuery(this).combobox("getText");
			var userLocDr = session['LOGON.CTLOCID'];
			
			param.ClassName = "web.DHCIPBillCashier";
			param.QueryName = "loclookup";
			param.Arg1 = patLocVal;
			param.Arg2 = userLocDr;
			param.ArgCnt = 2;
		},
		onLoadSuccess: function() {
			jQuery(this).combobox("showPanel");
		},
		onLoadError: function() {
			jQuery.messager.alert("错误", "科室列表加载错误");
		},
		onSelect: function() {
			if(jQuery("#searchPatWard[class='combobox-f combo-f']").length) {
				jQuery('#searchPatWard').combobox("clear");
				jQuery('#searchPatWard').combobox("reload");
			}else {
				searchWardClick();
			}
		},
		onChange:function(newValue, oldValue){
			if(newValue==""){
				jQuery('#searchPatLoc').combobox("clear");
			}
		}
	});	
}
//病区初始化
function searchWardClick() {
	jQuery('#searchPatWard').combobox({
		panelHeight:80,
		multiple: false,
		url:QUERY_URL.QUERY_COMBO_URL,  
		valueField:'wardid',    
		textField:'ward',
		editable: true,
		disabled: false, 
		readonly: false,
		onShowPanel:function(){
			//var url = './dhcbill.query.combo.easyui.csp';    
			//jQuery('#comboCardTypeDR').combobox('reload', url);   
		},
		onBeforeLoad:function(param){
			var  patLocVal = "",patWardVal = "";
			if(jQuery("#searchPatLoc[class='combobox-f combo-f']").length) {
				patLocVal = jQuery("#searchPatLoc").combobox("getValue");
			}
			patWardVal = jQuery(this).combobox("getValue");
			param.ClassName = "web.DHCIPBillCashier";
			param.QueryName = "wardlookup";
			param.Arg1 = patLocVal;
			param.Arg2 = patWardVal;
			param.ArgCnt = 2;
		},
		onLoadSuccess: function() {
			jQuery(this).combobox("showPanel");
		},
		onLoadError: function() {
			jQuery.messager.alert("错误", "病区列表加载错误");
		},
		onChange:function(newValue, oldValue){
			if(newValue==""){
				jQuery('#searchPatWard').combobox("clear");
			}
		}
	});	
}


function searchClear() {
	jQuery("#searchPatName").val("");
	jQuery("#searchInvoiceNO").val("");
	jQuery("#searchAdmReason").val("");
	jQuery("#searchPatLoc").val("");
	jQuery("#searchPatWard").val("");

	jQuery('#searchStDate').val(getDefStDate(-30)); //14.12.3 设置默认开始日期
	jQuery("#searchEndDate").val("");
	//清空费别
	if(jQuery("#searchAdmReason[class='combobox-f combo-f']").length) {
		jQuery("#searchAdmReason").combobox("setValue", "");
	}
	//初始化结算状态checkbox 14.11.15
	//jQuery("#discharge").attr('checked', 'checked');
	//IE 11 使用上边的没有效果
	jQuery("#checkCurAdm").get(0).checked = true;
	jQuery("#checkFinal").removeAttr('checked');
	jQuery("#checkMedical").removeAttr('checked');
	jQuery("#checkPayflag").removeAttr('checked');
	
	if(jQuery("#searchPatLoc[class='combobox-f combo-f']").length) {
		jQuery("#searchPatLoc").combobox("clear");
		jQuery("#searchPatLoc").combobox("setValue", "");
	}
	if(jQuery("#searchPatWard[class='combobox-f combo-f']").length) {
		jQuery("#searchPatWard").combobox("clear");
		jQuery("#searchPatWard").combobox("setValue", "");
	}

	jQuery("#tpatAdmList").datagrid('loadData', { total: 0, rows: [] });
}


function searchBtnClick() {
	//jQuery("#tPatList").datagrid("getPanel").panel("maximize");
	initPatListDataBySearch();
}

//初始化病人列表数据
function initPatListDataBySearch() {
	var queryParams = new Object();
	var ClassName="web.DHCIPBillCashier";
	var QueryName="findPatList";
	var StDate=jQuery("#searchStDate").val();
	var EndDate=jQuery("#searchEndDate").val();
	var checkMedical=jQuery("#checkMedical").get(0).checked;
	var checkFinal=jQuery("#checkFinal").get(0).checked;
	var checkPayflag=jQuery("#checkPayflag").get(0).checked;
	var checkCurAdm=jQuery("#checkCurAdm").get(0).checked;
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;

	//queryParams.Arg8 = jQuery("#admReason").val();
	//alert(jQuery("#admReason[class='combobox-f combo-f']").length);
	var  admReasonId = "";
	if(jQuery("#searchAdmReason[class='combobox-f combo-f']").length) {
		var admReasonText=jQuery.trim(jQuery("#searchAdmReason").combobox("getText"));
		if(admReasonText==""){
			jQuery("#searchAdmReason").combobox("clear");
		}
		admReasonId = jQuery("#searchAdmReason").combobox("getValue");
	}
	var  patLocId = "";
	if(jQuery("#searchPatLoc[class='combobox-f combo-f']").length) {
		var patLocText=jQuery.trim(jQuery("#searchPatLoc").combobox("getText"));
		if(patLocText==""){
			jQuery("#searchPatLoc").combobox("clear");
		}
		patLocId = jQuery("#searchPatLoc").combobox("getValue");
	}
	var  patWardId = "";
	if(jQuery("#searchPatWard[class='combobox-f combo-f']").length) {
		var patWardText=jQuery.trim(jQuery("#searchPatWard").combobox("getText"));
		if(patWardText==""){
			jQuery("#searchPatWard").combobox("clear");
		}
		patWardId = jQuery("#searchPatWard").combobox("getValue");
	}
	var checkedStr = checkMedical + "^" + checkFinal + "^" + checkPayflag + "^" + checkCurAdm;
	queryParams.Arg1 = StDate;
	queryParams.Arg2 = EndDate;
	queryParams.Arg3 = patLocId;
	queryParams.Arg4 = patWardId;
	queryParams.Arg5 = admReasonId;
	queryParams.Arg6 = jQuery("#searchInvoiceNO").val();
	queryParams.Arg7 = jQuery("#searchPatName").val();
	queryParams.Arg8 = checkedStr;
	queryParams.Arg9 = SessionObj.guser + "^" + SessionObj.group + "^" + SessionObj.ctLoc + "^" + SessionObj.hospital;
	queryParams.ArgCnt = 9;
	//console.log(queryParams)
	loadDataGridStore("tpatAdmList", queryParams);
}

//设置默认开始日期
function getDefStDate(space) {
	if(isNaN(space)) {
		space = -30;
	}
	var dateObj = new Date();
	dateObj.setDate(dateObj.getDate() + space);
	var myYear = dateObj.getFullYear();
	var myMonth = (dateObj.getMonth() + 1) < 10 ? "0" + (dateObj.getMonth() + 1) : (dateObj.getMonth() + 1);
	var myDay = (dateObj.getDate()) < 10 ? "0" + (dateObj.getDate()) : (dateObj.getDate());
	var dateStr = myYear + "-" + myMonth + "-" + myDay;
	dateStr = tkMakeServerCall("websys.Conversions","DateHtmlToLogical", dateStr);
	dateStr = tkMakeServerCall("websys.Conversions","DateLogicalToHtml", dateStr);
	return dateStr;
}

