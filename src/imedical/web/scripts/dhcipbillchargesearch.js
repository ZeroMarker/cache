/**
*FileName:	dhcipbillchargesearch.js
*Anchor:	Lid
*Date:	2015-01-21
*Description:	�°�סԺ�շѶ�������ѯ����
*/


//��ʼ����ѯ�������
function initSearchPanel() {
	jQuery('#searchStDate').val(getDefStDate(-30));
	//add 14.11.15 ����δ��������ս��㻥�⣬Ĭ��δ���ս���
	//+2017-05-25 modify by ZhYW 
	//jQuery("#checkCurAdm, #checkFinal, #checkMedical, #checkPayflag").get(0).checked = false;
	//������ǰ��Ժ��checkBox��ΪĬ�Ϲ�ѡ
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
		striped: true,  	//�Ƿ���ʾ������Ч��
		singleSelect : true,
		selectOnCheck: false,
		fitColumns:false,
		autoRowHeight:false,
		scrollbarSize:'10px',
		url:null,
		loadMsg:'Loading...',
		pagination: true,  //���Ϊtrue������DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		pageSize: 10,
		remoteSort: false,
		pageNumber:1,
		pageList:[10,25,50,100],
		columns:[[  
			{ title: '�ǼǺ�', field: 'TpatNo',width:100},
			{ title: '������', field: 'TpatMedicare' ,width:80},
			{ title: '����',  field: 'TpatName' ,width:80},
			{ title: '����', field: 'Tage',width:40},
			{ title: '����', field: 'TpatLoc' ,width:120},
			{ title: '����',  field: 'TpatWard',width:160 },
			{ title: '��λ', field: 'TpatBed',width:80 },
			{ title: '��������',  field: 'TadmDate',width:80 },
			{ title: '����ʱ��', field: 'TadmTime',width:80},
			{ title: '��Ժ����', field: 'TdiscDate',width:80},
			{ title: '��Ժʱ��', field: 'TdiscTime',width:80},
			{ title: '�Ա�', field: 'Tsex',width:30 },
			{ title: '�ѱ�',  field: 'TadmReason',width:80}
		]],
		onBeforeLoad: function(data) {
		},
		onLoadSuccess: function(data) {
		},
		onLoadError: function() {
			jQuery.messager.alert('����', '���ز�ѯ�����б�ʧ��.');
		},
		onDblClickRow: function(rowIndex, rowData) {
			jQuery("#chargeSearchPanel").window("close");
			jQuery("#patientNO").val(rowData.TpatNo);
			jQuery("#medicareNO").val(rowData.TpatMedicare);
			getPatInfo();
		}

	});
}

//��ʼ����ѯ�����¼�
function initSearchEvent() {
	jQuery('#searchStDate,#searchEndDate').off("click").on("click",searchDateClick);
	jQuery("#searchAdmReason").off("click").on("click", searchAdmReasonClick);
	jQuery('#searchBtnFind').off("click").on("click",searchBtnClick);
	jQuery("#searchBtnClear").off("click").on("click", searchClear);
	jQuery("#searchPatLoc").off("click").on("click", searchLocClick);
	jQuery("#searchPatWard").off("click").on("click", searchWardClick);
}

//���ڳ�ʼ��
function searchDateClick() {
	WdatePicker({
		isShowClear:true,
		skin:'ext',
		dateFmt:'yyyy-MM-dd',
		readOnly:false //ƽ̨�ӿ�
		
	});
}
//�ѱ��ʼ��
function searchAdmReasonClick() {
	jQuery('#searchAdmReason').combobox({
		panelHeight:80,
		multiple: false,
		url:QUERY_URL.QUERY_COMBO_URL,  
		valueField:'typeid',    
		textField:'type',
		editable: false,
		disabled: false, //ƽ̨�ӿ�
		readonly: false, //ƽ̨�ӿ�
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
			jQuery.messager.alert("����", "�ѱ��б���ش���");
		}
	});	
}
//���ҳ�ʼ��
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
			jQuery.messager.alert("����", "�����б���ش���");
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
//������ʼ��
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
			jQuery.messager.alert("����", "�����б���ش���");
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

	jQuery('#searchStDate').val(getDefStDate(-30)); //14.12.3 ����Ĭ�Ͽ�ʼ����
	jQuery("#searchEndDate").val("");
	//��շѱ�
	if(jQuery("#searchAdmReason[class='combobox-f combo-f']").length) {
		jQuery("#searchAdmReason").combobox("setValue", "");
	}
	//��ʼ������״̬checkbox 14.11.15
	//jQuery("#discharge").attr('checked', 'checked');
	//IE 11 ʹ���ϱߵ�û��Ч��
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

//��ʼ�������б�����
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

//����Ĭ�Ͽ�ʼ����
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

