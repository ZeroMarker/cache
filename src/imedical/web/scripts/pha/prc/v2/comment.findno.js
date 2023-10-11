/**
 * ����:	 ��������-��������-�鵥
 * ��д��:	 pushuangcai
 * ��д����: 2020/11/06
 */
var FindNoDialog = {
	type: "",
	findFlag: "",
	loadWayCode: '',
	callback: ""
}

function InitFindNoDialog(opts){	
	FindNoDialog.type = opts.type;
	FindNoDialog.callback = opts.callback;
	if(opts.type === "OP"){
		FindNoDialog.findFlag = 1;
	}else{
		FindNoDialog.findFlag = 2;
	}
	InitFindNoDialogDict();
	InitSetFindNoDialogDefVal();
	InitGridFindNo();
	InitDialogFindNo();
}
		
function InitFindNoDialogDict() {
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
	PHA.ComboBox("conWay", {
		url: PRC_STORE.PCNTSWay(FindNoDialog.findFlag, "CNTS").url,
		width:140
	});
	PHA.ComboBox("conResult", {
		data: [{
			RowId: "1",
			Description: $g("���н��")
		}, {
			RowId: "2",
			Description: $g("���޽��")
		}, {
			RowId: "3",
			Description: $g("������")
		}, {
			RowId: "4",
			Description: $g("��������")
		}, {
			RowId: "5",
			Description: $g("��ҽ������")
		}],
		panelHeight: "auto",
		width:160
	});
	PHA.ComboBox("conPharmacist", {
		url: PRC_STORE.PhaUser(),
		width:160
	});
	PHA.ComboBox("comState", {
		data: [{
			RowId: "5",
			selected: true,
			Description: $g("������")
		},{
			RowId: "1",
			Description: $g("δ����")
		}, {
			RowId: "2",
			Description: $g("������")
		}, {
			RowId: "3",
			Description: $g("�������")
		}, {
			RowId: "4",
			Description: $g("���ύ")
		}],
		panelHeight: "auto",
		width:140
	});
}

// ������Ϣ��ʼ��
function InitSetFindNoDialogDefVal() {
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.ComStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.ComEndDate);
		// ���ε������ñ�־
		if (jsonColData.ReCntFlag == "Y"){
			width = 0 ;
			hiddenFlag = false ;
		}
		if (jsonColData.DefaultLogonUser == "Y"){
			var phaFlag=tkMakeServerCall("PHA.PRC.Com.Util", "ChkPharmacistFlag", logonUserId)
			if (phaFlag=="Y"){	
				$("#conPharmacist").combobox("setValue", logonUserId);
			}
		}
		if (gDateRange != ""){
			var ComStartDate =tkMakeServerCall("PHA.COM.Util", "T2HtmlDate", gDateRange.split(",")[0]);
			var ComEndDate =tkMakeServerCall("PHA.COM.Util", "T2HtmlDate", gDateRange.split(",")[1]);
			$("#conStartDate").datebox("setValue", ComStartDate);
			$("#conEndDate").datebox("setValue", ComEndDate);
		}
		SearchComments();
	});	
}

function InitGridFindNo() {
	var columns = [[
        { field: "pcntId", 		title: 'rowid', 	width: 80, hidden:true},
        { field: "pcntNo", 		title: '����',		width: 150 },
        { field: 'pcntDate', 	title: '����', 		width: 100},
        { field: "pcntTime", 	title: 'ʱ��', 		width: 80 },
        { field: "pcntUserName", title: '�Ƶ���',	width: 80},
        { field: "typeDesc", 	title: '����',		width: 120 },
        { field: 'wayDesc', 	title: '��ʽ', 		width: 150},
        { field: "pcntText", 	title: '��ѯ����' ,	width: 400},
        { field: "pcntState", 	title: '����״̬',	width: 80 },
        { field: 'pcntWayCode',	title: '��ʽ����', 	width: 200, hidden: true},
		{ field: 'pcntWayId', 	title: '��ʽ', 		width: 200, hidden: true}
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectComments',
			findFlag: FindNoDialog.findFlag,
			stDate: $("#conStartDate").datebox('getValue'),
			endDate: $("#conEndDate").datebox('getValue'),
			parStr: '',
			logonLocId: logonLocId,
			searchFlag: ''
        },      
        columns: columns,
        toolbar: "#gridFindNoBar",
        border: true ,
        isTopZindex:true ,
        bodyCls:'panel-header-gray',
        onDblClickRow:function(rowIndex,rowData){
	         SelectCommentItms() ;
		}   
    };
	PHA.Grid("gridFindNo", dataGridOption);
}

function InitDialogFindNo(){
	var title;
	if(FindNoDialog.type === "OP"){
		title = "���������鵥";
	}else{
		title = "����סԺҽ���鵥";	
	}
	$('#diagFindNo').dialog({
		title: title,
		iconCls: 'icon-w-find',
		modal: true,
		closed: true,
		isTopZindex:true ,
		width: 1200,
		height: 550,
	});
}
// �򿪲鵥����
function ShowDiagFindNo() {
	$('#diagFindNo').dialog('open');
}

// ��ѯ������
function SearchComments(){
	var stDate = $("#conStartDate").datebox('getValue') ;
	var endDate = $("#conEndDate").datebox('getValue') ;
	var wayId = $("#conWay").combobox('getValue')||''; 
	var result = $("#conResult").combobox('getValue')||'';
	var phaUserId = $("#conPharmacist").combobox('getValue')||'';
	var state = $("#comState").combobox('getValue')||'';
	var parStr = wayId + "^" + result + "^" + phaUserId + "^" + state
	
	$("#gridFindNo").datagrid("query", {
		findFlag: FindNoDialog.findFlag,
		stDate: stDate,
		endDate: endDate,
		parStr: parStr,
		logonLocId: logonLocId,
		searchFlag: ''
	});		
}

// ɾ��������
function DeleteComment(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	var logonInfo = logonGrpId + "^" + logonLocId + "^" + logonUserId  ;
	if (pcntId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������Id��������ѡ�������!","info");
		return;
	}
	var delInfo = "��ȷ��ɾ����?"
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		var deleteRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'DeleteComment',
			pcntId: pcntId,
			logonInfo: logonInfo,
			dataType: 'text'
		}, false);
	
		var deleteRet = deleteRet.toString() ;
		var deleteArr = deleteRet.split('^');
		var deleteVal = deleteArr[0];
		var deleteInfo = deleteArr[1];
		
		if (deleteVal < 0) {
			PHA.Alert('��ʾ', deleteInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�',
				type: 'success'
			});
			$("#gridFindNo").datagrid("reload");
		}
	})
}

// �ύ������
function SubmitComment(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������Id��������ѡ�������!","info");
		return;
	}
	var logonInfo = logonGrpId + "^" + logonLocId + "^" + logonUserId  ;
	var subInfo = "��ȷ���ύ��?�ύ������ȡ���ύ��"
	PHA.Confirm("�ύ��ʾ", subInfo, function () {
		var submitRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'SubmitComment',
			pcntId: pcntId,
			logonInfo: logonInfo,
			dataType: 'text'
		}, false);
		
		var submitRet = submitRet.toString() ;
		var submitArr = submitRet.split('^');
		var submitVal = submitArr[0];
		var submitInfo = submitArr[1];
		
		if (submitVal < 0) {
			PHA.Alert('��ʾ', submitInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '�ύ�ɹ�',
				type: 'success'
			});
			$("#gridFindNo").datagrid("reload");
		}
	})
}

// ѡȡ��������Ϣ
function SelectCommentItms(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������Id��������ѡ�������!","info");
		return;
	}
	var loadPcntId = pcntId
	var loadWayId = gridSelect.pcntWayId ;
	var loadWayCode = gridSelect.pcntWayCode ;
	var selResult = $("#conResult").combobox('getValue')||'';
	var selPhaUserId = $("#conPharmacist").combobox('getValue')||'';
	FindNoDialog.loadWayCode = loadWayCode;
	var param = {
		pcntId: loadPcntId,	
		comResult: selResult,
		phaUserId: selPhaUserId,
		loadWayCode: loadWayCode,
		selPhaUserId: selPhaUserId
	}
	if(FindNoDialog.callback){
		FindNoDialog.callback(param);	
	}
	$('#diagFindNo').dialog('close');
}