/**
 * ����:	 ��������-����Ȩ��ά��
 * ��д��:	 dinghongying
 * ��д����: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.secgrp.csp";
PHA_COM.App.Name = "PRC.ConFig.SecGrp";
PHA_COM.App.Load = "";
$(function () {
	InitDict();
	InitGridWay();
	InitGridSecGrp();
	InitEvents();
});

// �¼�
function InitEvents() {
	$("#btnAdd").on("click", SaveScgGrp);
	$("#btnEdit").on("click", UpdateScgGrp);
	$("#btnDel").on("click", DeleteScgGrp);
}

// �ֵ�
function InitDict() {
	// ��ʼ����ȫ��
	PHA.ComboBox("conSecGrp", {
		url: PHA_STORE.SSGroup().url 		
	});
	
}

// ���-������ʽά��
function InitGridWay() {
    var columns = [
        [
            { field: "wayId", title: 'rowId', width: 100, hidden: true },
            { field: "wayCode", title: '����',width: 120, },
            { field: 'wayDesc', title: '��ʽ', width: 200},
            { field: "wayActive", title: '����' ,width: 120}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Way',
            QueryName: 'SelectWay',
            queryMenu: "secgrp"
        },
        columns: columns,
        onClickRow:function(rowIndex,rowData){
	         QueryGridSecGrp();
		}   
    };
	PHA.Grid("gridWay", dataGridOption);
}

// ���-������ȫ��ά��
function InitGridSecGrp() {
    var columns = [
        [
            { field: "wayItmId", title: 'wayItmId', width: 100, hidden: true },
            { field: "groupId", title: '��ȫ��Id',width: 120, hidden: true },
            { field: "groupDesc", title: '��ȫ��',width: 200, },
            { field: 'updateFlag', title: '�޸�Ȩ��', width: 200}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Way',
            QueryName: 'SelectWayItm'
        },
        columns: columns,
        toolbar: "#gridSecGrpBar",
        onClickRow:function(rowIndex,rowData){		
			//var wayItmId = rowData.wayItmId ;
			var updateFlag = rowData.updateFlag ;
			var groupId = rowData.groupId ;
			var groupDesc = rowData.groupDesc ;
			$("#conSecGrp").combobox('setValue', groupId); 				
			$("#conSecGrp").combobox('setText', groupDesc);
			if (updateFlag=="��"){
				//$('#chkUpdate').iCheck('check')
				$('#chkUpdate').checkbox("check",true) ;
			}
			else{
				//$('#chkUpdate').iCheck('uncheck')
				$('#chkUpdate').checkbox("uncheck",true) ;
			}
		}   
    };
    PHA.Grid("gridSecGrp", dataGridOption);
}

///��ѯ��ȫ������
function QueryGridSecGrp() {
	$("#conSecGrp").combobox("setValue",'') ;
	$("#conSecGrp").combobox("setText", '') ;
	$('#chkUpdate').checkbox("uncheck",true) ;
	var gridSelect = $("#gridWay").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫά��������!","info");
		return;
	}
	var wayId=gridSelect.wayId;
    $('#gridSecGrp').datagrid('query', {
        wayId: wayId
    });
}

function SaveScgGrp(){
	var gridSelect = $("#gridWay").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����ʽ!","info");
		return;
	}
	var wayId=gridSelect.wayId;
	if (wayId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������ʽid��������ѡ�������!","info");
		return;
	}
	
	var SecGrpId = $("#conSecGrp").combobox('getValue');
	if (SecGrpId == "") {
		PHA.Popover({
			msg: "����ѡ��ȫ����ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var checkFlag = ""
	if ($("#chkUpdate").is(':checked')){
		checkFlag = "Y"	
	}
	else{
		checkFlag = "N"		
	}
	var Params = wayId + "^" + SecGrpId + "^" + checkFlag
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Way',
		MethodName: 'SaveScgGrp',
		wayItmId: '',
		Params: Params,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
		ClearwayItm();
	}
	
}
function UpdateScgGrp(){
	var gridSelect = $("#gridWay").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ�е�����ʽ!","info");
		return;
	}
	var wayId=gridSelect.wayId;
	if (wayId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������ʽid��������ѡ�������!","info");
		return;
	}
	var gridSelectItm = $("#gridSecGrp").datagrid("getSelected");
	if (gridSelectItm==null){
		$.messager.alert('��ʾ',"����ѡ�а�ȫ����Ȩ��Ϣ!","info");
		return;
	}
	var wayItmId=gridSelectItm.wayItmId;
	if (wayItmId==''){
		$.messager.alert('��ʾ',"û�л�ȡ����Ȩ��ȫ��id��������ѡ�������!","info");
		return;
	}
	
	var SecGrpId = $("#conSecGrp").combobox('getValue');
	if (SecGrpId == "") {
		PHA.Popover({
			msg: "����ѡ��ȫ����ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var checkFlag = ""
	if ($("#chkUpdate").is(':checked')){
		checkFlag = "Y"	
	}
	else{
		checkFlag = "N"		
	}
	var Params = wayId + "^" + SecGrpId + "^" + checkFlag
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Way',
		MethodName: 'SaveScgGrp',
		wayItmId: wayItmId,
		Params: Params,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '�޸ĳɹ�',
			type: 'success'
		});
		ClearwayItm();
	}
}
function DeleteScgGrp(){
	var delInfo = "��ȷ��ɾ����?"
	var gridSelectItm = $('#gridSecGrp').datagrid('getSelected');
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		if ((gridSelectItm == "")||(gridSelectItm == null)) {
			PHA.Popover({
				msg: "����ѡ����Ҫɾ������Ȩ��Ϣ",
				type: "alert",
				timeout: 1000
			});
			return;
		}
		var wayItmId = gridSelectItm.wayItmId ;
		var saveRet = $.cm({
			ClassName: 'PHA.PRC.ConFig.Way',
			MethodName: 'DelScgGrp',
			wayItmId: wayItmId,			
			dataType: 'text'
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('��ʾ', saveInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�',
				type: 'success'
			});
			ClearwayItm();
		}
	})
}

function ClearwayItm(){
	$("#conSecGrp").combobox("setValue",'') ;
	$("#conSecGrp").combobox("setText", '') ;
	//$('#chkUpdate').iCheck('uncheck') ;
	$('#chkUpdate').checkbox("uncheck",true) ;
	$("#gridSecGrp").datagrid("reload") ;
	
	
}





