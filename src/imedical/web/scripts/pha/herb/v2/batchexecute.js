/**
 * @ģ��:     ��ҩ����״̬����ִ��
 * @��д����: 2020-11-12
 * @��д��:   MaYuqiang
 * csp:pha.herb.v2.batchexecute.csp
 * js: pha/herb/v2/batchexecute.js
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
PHA_COM.App.ProCode = "HERB"
PHA_COM.App.ProDesc = "��ҩ����"
PHA_COM.App.Csp = "pha.herb.v2.batchexecute.csp"
PHA_COM.App.Name = "��ҩ״̬����ִ��"
var ComPropData		// ��������
var AppPropData		// ģ������
var combWidth = 160;
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 30 * 1000;
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
    PHA_COM.SetPanel('#pha_herb_v2_scanexe', $('#pha_herb_v2_scanexe').panel('options').title);
	InitDict();
	InitSetDefVal();
	InitGridPrescList();
	
	//�����Żس��¼�
	$('#txtPrescNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo=$.trim($("#txtPrescNo").val());
			if (prescNo!=""){
				AddPrescInfo();
			}	
		}
	});
	//�ǼǺŻس��¼�
	$('#txtBarCode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txtBarCode").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryPreList();
			}	
		}
	});
	
	// ���Żس��¼�
	$("#txtCardNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardNo = $.trim($("#txtCardNo").val());
			if (cardNo != "") {
				BtnReadCardHandler();
			}
		}
	})
	
	$('#readCard').on('click', BtnReadCardHandler) ;
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	
});

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	//��������
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

	$("#dateColStart").datebox("setValue", ComPropData.ExecuteStartDate);
	$("#dateColEnd").datebox("setValue", ComPropData.ExecuteEndDate);
	$('#txtUserCode').val('');
	$('#txtPrescNo').val('');
	$('#txtBarCode').val('');
	$('#txtCardno').val('');
	var CancelExeFlag = ComPropData.CancelExecuteFlag;
	if (CancelExeFlag !== "Y"){
		$("#btnCancelExecute").attr({
            "style": "display:none"
        });
	}
	
}

function InitDict(){
	/// ִ��״̬�б�
	var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
	var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
	var QueryType = "Exe" ;
	PHA.ComboBox("cmbState", {
		url: PHA_HERB_STORE.Process(gLocId,QueryType,gHospId,"","PC").url,
		width: combWidth,
		onLoadSuccess: function(){
			var data = $('#cmbState').combobox('getData');
			if (data.length > 0) {
				//��������ݵĻ�Ĭ��ѡ�е�һ������
				$('#cmbState').combobox('select', data[0].RowId);
			}

		},
		onSelect: function (selData) {
			var selDesc = selData.Description;
			if(selDesc == $g("��ʼ��ҩ")){
				$("#btnAutoExecute").linkbutton('enable');
			}
			else {
				$("#btnAutoExecute").linkbutton('disable');
			}
			QueryPreList();
		}
	});
	// �����б�
	PHA.ComboBox("cmbWard", {
		width: combWidth,
		url: PHA_STORE.WardLoc().url
	});
	// ҽ������
	PHA.ComboBox('cmbDocLoc', {
        width: combWidth,
        url: PHA_STORE.DocLoc().url
    });
	// ��ҩ��������
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_HERB_STORE.HMPreForm(gLocId).url
	});
	// ��ҩ��ʽ
    PHA.ComboBox('conCookType', {
        width: 122,
        url: PHA_HERB_STORE.CookType('', gLocId).url,
        panelHeight: 'auto'
	});
	// ��������
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O', Description: $g('�ż���') },
            { RowId: 'I', Description: $g('סԺ') }
        ],
        panelHeight: 'auto',
        onSelect: function () {
	    	var admType = $("#conAdmType").combobox("getValue")||'';
			PHA.ComboBox("cmbState", {
				url: PHA_HERB_STORE.Process(gLocId,"Exe",gHospId,admType,"PC").url
			});    
	    }
	});
	// ��ҩ����
	PHA.ComboBox('conDispWin', {
		multiple: true,
        width: combWidth,
        rowStyle: 'checkbox',
        url: PHA_HERB_STORE.WindowStore(gLocId).url
    });

	// ��ִ��
	$('#chk-execute').change(function() {
		if($(this).is(":checked")){
        	$("#btnExecute").linkbutton('disable');
		}
		else {
			$("#btnExecute").linkbutton('enable');
		}
		
	})


}
	
	/**
 * ��ʼ�������б�
 * @method InitGridOutPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	{
				field:'pdCheck',	
				checkbox: true 
			}, {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 80,
				hidden:true
			}, {
				field: 'TPrescInfo',
				title: '������Ϣ',
				align: 'left',
				width: 1700
			}, {
				field: 'TOrdInfo',
				title: 'ҩƷ��Ϣ',
				align: 'left',
				width: 100,
				hidden:true
			}, {
				field: 'TPhbdId',
				title: '��ҩҵ���Id',
				align: 'left',
				width: 70,
				hidden:true
			},{
				field: 'TaltFlag',
				title: '�б�ɫ��־',
				align: 'left',
				width: 70,
				hidden:true
			}
			
		]
	];
	
	var dataGridOption = {
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:false ,
		pagination: false,
		exportXls: false,
		singleSelect: false,
		toolbar: '#gridBatchExeBar',
		rowStyler: HERB.Grid.RowStyler.PersonAlt,
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Execute.Query",
			QueryName: "GetPrescList",
		},
		onClickRow: function (rowIndex, rowData) {
			//$("#gridPrescList").datagrid("expandRow",rowIndex);
		},
		groupField:'TPrescNo',
		view: detailview,
		detailFormatter:function(rowIndex, rowData){
			var ordInfo = rowData.TOrdInfo ;
			var ordInfoData = ordInfo.split("&&")
			var num = 0
			var detailHtml = '<div style="padding-top:0px">';
			for (num = 0;num<ordInfoData.length;num++){
				var ordDetailInfo = ordInfoData[num] ;
				var ordDetailData = ordDetailInfo.split("^")
				var inciDesc = ordDetailData[0] ;
				var qty = ordDetailData[1] ;
				var remark = ordDetailData[2] ;
				
				detailHtml += '<div class="herb">';
					detailHtml += '<div class="herb-name">' + inciDesc + '</div>';
					detailHtml += '<div class="herb-remark">' + remark + '</div>';
					detailHtml += '<div class="herb-qty">' + qty + '</div>';
				detailHtml += '</div>'	;				
			}
			detailHtml += '</div>'
			return detailHtml;
			
		},
		/*
		onExpandRow:function(rowIndex, rowData){
			alert(rowIndex)
		},*/
		onLoadSuccess:function(data){
			var row = $("#gridPrescList").datagrid("getRows");
			for (var r = 0; r < row.length; r++)
			{
				$("#gridPrescList").datagrid("expandRow",r);
			}	
		}
	};

	PHA.Grid("gridPrescList", dataGridOption);
}

/**
 * ��ѯ����
 * @method QueryPreList
 */
function QueryPreList() {
	$('#gridPrescList').datagrid('uncheckAll');
	$('#gridPrescList').datagrid('clear');
	var pJson = GetParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});	 
	Setfocus();
}

/**
 * ��ѯ������JSON
 * @method GetParamsJson
 */
function GetParamsJson() {
	var startDate = $("#dateColStart").datebox('getValue') ;
    var endDate = $("#dateColEnd").datebox('getValue') ;
    var exeDictId = $("#cmbState").combobox("getValue") || '' ;
    if ((startDate == "")||(endDate == "")||(exeDictId == "")){
		$.messager.alert('��ʾ',"���ڷ�Χ�Լ�ִ��״̬����Ϊ��!","info");
		return;
	}
    return {
        startDate: startDate,
        endDate: endDate,
        loc: gLocId,
        exeDictId: exeDictId,
        ordLocId: $("#cmbDocLoc").combobox("getValue") || '',
        wardLocId: $("#cmbWard").combobox("getValue") || '',
        patNo: $('#txtBarCode').val(),
		prescNo: $('#txtPrescNo').val(),		
		cookType: $('#conCookType').combobox('getValue') || '',
		preFormCode: $('#conForm').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
		exeFlag: ($('#chk-execute').checkbox('getValue')==true?'Y':'N') ,
		dispWinStr: ($('#conDispWin').combobox('getValues') || []).join(',')
    };
}


/*
 * ��ҩ����״ִ̬��
 * @method Execute
 */
function Execute(){
	var gridSelectRows = $("#gridPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('��ʾ',"����ѡ����Ҫִ�еĴ���!","info");
		return;
	}
	var UserCode = $('#txtUserCode').val() ;
	if (UserCode == ""){
		$.messager.alert('��ʾ',"ҩʦ���Ų���Ϊ��!","info");
		return;	
	}
	var proDictId = $('#cmbState').combobox("getValue")
	if (proDictId == ""){
		$.messager.alert('��ʾ',"ִ��״̬����Ϊ��!","info");
		return;	
	}
	var proDictDesc = $('#cmbState').combobox("getText") ;
	
	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
		var gridSelect = gridSelectRows[pnum] ;
        var phbdId = gridSelect.TPhbdId;
		var prescNo = gridSelect.TPrescNo;
		var params = phbdId + tmpSplit + UserCode + tmpSplit + proDictId ;
		//DoExecute(params);
		var ret = $.m({
			ClassName: "PHA.HERB.Execute.Save",
			MethodName: "Execute",
			param: params,
			logonInfo: LogonInfo
		}, false);
		
		var retArr = ret.split("^")
		if (retArr[0] > 0) {
			var printPhbdId = retArr[0];
			var printPYDProCode = ComPropData.PrintPYDProCode;
			var proDictCode =  tkMakeServerCall("PHA.HERB.Com.Data", "GetProCodeById", proDictId)
			if (proDictCode == printPYDProCode){
				HERB_PRINTCOM.PYD(printPhbdId,"");
			}
		}
		else {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}

	}
	QueryPreList();
}

function DoExecute(params){
	var proDictDesc = $('#cmbState').combobox("getText") ;
	$.m({
		ClassName: "PHA.HERB.Execute.Save",
		MethodName: "Execute",
		param: params,
		logonInfo: LogonInfo
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] > 0) {
			var printPhbdId = retArr[0];
			var printPhbdId 
			// ִ�л�ȡ����ʱ��ӡ��ҩ��
			if (proDictDesc.indexOf("��ȡ����")>-1){
				HERB_PRINTCOM.PYD(printPhbdId,"");
			}
		}
		else {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
	});

}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#gridPrescList').datagrid('uncheckAll');
	$('#gridPrescList').datagrid('clear');
	$('#chk-execute').checkbox("uncheck",true) ;
	$('#txtTimeStep').val("");
	$('#txtCardNo').val("");
	prescrArr = [] ;
	InitDict();
}

/*
 * ��ҩ����״̬�Զ�ִ��
 * @method CancelExecute
*/
function CancelExecute(){
	var gridSelectRows = $("#gridPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('��ʾ',"����ѡ����Ҫ����ִ�еĴ���!","info");
		return;
	}
	var proDictId = $('#cmbState').combobox("getValue")
	if (proDictId == ""){
		$.messager.alert('��ʾ',"ִ��״̬����Ϊ��!","info");
		return;	
	}
	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
		var gridSelect = gridSelectRows[pnum] ;
        var phbdId = gridSelect.TPhbdId;
		var prescNo = gridSelect.TPrescNo;
		var params = phbdId +"^"+ proDictId;
		//DoExecute(params);
		var ret = $.m({
			ClassName: "PHA.HERB.Execute.Biz",
			MethodName: "CancelExecute",
			param: params,
			logonInfo: LogonInfo
		}, false);
		
		var retArr = ret.split("^")
		if (retArr[0] == 0) {
			//var printPhbdId = retArr[0];
		}
		else {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}

	}
	QueryPreList();
}

/*
 * ��ҩ����״̬�Զ�ִ��
 * @method AutoExecute
 */
function StartAutoExecute(){
	
	var timeStep = $("#txtTimeStep").val().trim();
	if (timeStep == "") {
		$.messager.alert('��ʾ', "�Զ�ִ�е�ʱ��������Ϊ��", 'warning');
		return false;
	}
	if ($.trim(timeStep) != "") {
		DHCPHA_CONSTANT.VAR.TIMERSTEP = $("#txtTimeStep").val()*1000;
	}	
	var userCode = $('#txtUserCode').val() ;
	if (userCode == ""){
		$.messager.alert('��ʾ',"ִ���˹��Ų���Ϊ��!","info");
		return;	
	}
	
	var stateId = $('#cmbState').combobox("getValue") ;
	if (stateId == ""){
		$.messager.alert('��ʾ',"ִ��״̬����Ϊ��!","info");
		return;	
	}
	var stateDesc = $('#cmbState').combobox("getText") ;
	//console.log("stateDesc:"+stateDesc)
	var ret = PHAHERB_COM.Window.Open({
		type:"AutoExe",
		title: $g("�����Զ�ִ��") + stateDesc
	},AutoExecute)
	
}

function AutoExecute(){
	$("#"+PHAHERB_COM.Element.AutoExeErrInfo).text("");
	//DHCPHA_CONSTANT.VAR.TIMER = setInterval("AutoPrint()", DHCPHA_CONSTANT.VAR.TIMERSTEP);	
	DHCPHA_CONSTANT.VAR.TIMER = setTimeout("AutoPrint()", DHCPHA_CONSTANT.VAR.TIMERSTEP);	
}


function AutoPrint(){
	
	var pJson = GetParamsJson();
	if (pJson == "") {
		return;
	}
	var proDictDesc = $('#cmbState').combobox("getText") ;
	var retVal = $.m({
		ClassName: 'PHA.HERB.Execute.Biz',
		MethodName: 'AutoExecute',
		pJsonStr: JSON.stringify(pJson),
		userCode: $('#txtUserCode').val(),
		logonInfo: LogonInfo
	},false);

	/* ����ֵ�쳣ʱ������ѯ */
	if (typeof retVal === 'undefined') {
		//clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
		StopAutoExe();
		return ;	
	}

	var retArr = retVal.split("$$");
	var prtInfo = retArr[0];
	var errInfo = retArr[1];
	
	if (errInfo!=""){
		var errInfoData=$("#"+PHAHERB_COM.Element.AutoExeErrInfo).text();
		if(errInfoData!="") {
			errInfo=errInfo+" \n"+errInfoData
		}
		$("#"+PHAHERB_COM.Element.AutoExeErrInfo).text(errInfo)
	}	
	DHCPHA_CONSTANT.VAR.TIMER = setTimeout("AutoPrint()", DHCPHA_CONSTANT.VAR.TIMERSTEP);	
}

// ֹͣ�Զ���ҩ
function StopAutoExe(){
	//clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
	if(PHAHERB_COM.Window.ComInfo.winId){
        $('#'+ PHAHERB_COM.Window.ComInfo.winId ).window('close');
    }

}

//����
function BtnReadCardHandler() {
	/*
	var readcardoptions = {
		CardNoId: "txtCardNo",
		PatNoId: "txtBarCode"
	}
	PHA_COM.ReadCard(readcardoptions, setTimeout("QueryPreList()",100)) ; 
	*/
	PHA_COM.ReadCard({
        CardNoId : "txtCardNo",
        PatNoId : "txtBarCode"
    },QueryPreList)
}

/// ���Ĭ��
function Setfocus()
{
	$("#txtBarCode").val("");
	$("#txtCardNo").val("");
	if(ComPropData.FocusFlag==0){
		$('#txtCardNo').focus();
	}
	else{
		$('#txtBarCode').focus();
	}
}

//��������
window.onload=function(){
	//setTimeout("QueryPreList()",500);
}
