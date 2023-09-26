/**
 * ����:	 ��������-������ʽά��
 * ��д��:	 dinghongying
 * ��д����: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.way.csp";
PHA_COM.App.Name = "PRC.ConFig.Way";
PHA_COM.App.Load = "";
$(function () {
	InitGridWay();
	InitEvents();
});

// �¼�
function InitEvents() {
	$("#btnAdd").on("click", SaveWay);
	$("#btnEdit").on("click", EditWay);
}


// ���-������ʽά��
function InitGridWay() {
    var columns = [
        [
            { field: "wayId", title: 'rowId',width: 100,hidden: true },
            { field: "wayCode", title: '����',width: 120, },
            { field: 'wayDesc', title: '��ʽ', width: 300},
            { field: "wayActive", title: '����' ,width: 120},
            { field: 'wayReSave', title: '�ظ���ȡ', width: 120}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Way',
            QueryName: 'SelectWay'
        },
        columns: columns,
        toolbar: "#gridWayBar",
        onClickRow:function(rowIndex,rowData){
			var rowId=rowData.wayId;
			var wayCode=rowData.wayCode;
			var wayDesc=rowData.wayDesc;
			var activeFlag=rowData.wayActive;
			var repeatFlag=rowData.wayReSave;
			$("#conCode").val(wayCode);
			$("#conDesc").val(wayDesc);
			$HUI.checkbox("#chkActive", { "checked": activeFlag == "��" ? true : false });
			$HUI.checkbox("#chkRepeat", { "checked": repeatFlag == "��" ? true : false });
		}   
    };
	PHA.Grid("gridWay", dataGridOption);
}

function SaveWay(){
	var wayCode = $("#conCode").val();
	var wayCode = wayCode.replace(/\s+/g,"");
	if (wayCode == "") {
		PHA.Popover({
			msg: "������д����������ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var wayDesc = $("#conDesc").val();
	var wayDesc = wayDesc.replace(/\s+/g,""); 
	if (wayDesc == "") {
		PHA.Popover({
			msg: "������д������ʽ�������ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	if ($("#chkActive").is(':checked')){
		activeFlag = "Y"	
	}
	else{
		activeFlag = "N"		
	}
	if ($("#chkRepeat").is(':checked')){
		reSaveFlag = "Y"	
	}
	else{
		reSaveFlag = "N"		
	}
	var Params = wayCode + "^" + wayDesc + "^" + activeFlag + "^" + reSaveFlag ;
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Way',
		MethodName: 'SaveWay',
		wayId: '',
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
		ClearWay();
	}
	
}
function EditWay(){
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
	var wayCode = $("#conCode").val();
	var wayCode = wayCode.replace(/\s+/g,"");
	if (wayCode == "") {
		PHA.Popover({
			msg: "������д������ʽ������ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var wayDesc = $("#conDesc").val();
	var wayDesc = wayDesc.replace(/\s+/g,"");
	if (wayDesc == "") {
		PHA.Popover({
			msg: "������д������ʽ�������ٱ��棡",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	if ($("#chkActive").is(':checked')){
		activeFlag = "Y"	
	}
	else{
		activeFlag = "N"		
	}
	if ($("#chkRepeat").is(':checked')){
		reSaveFlag = "Y"	
	}
	else{
		reSaveFlag = "N"		
	}
	var Params = wayCode + "^" + wayDesc + "^" + activeFlag + "^" + reSaveFlag ;
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Way',
		MethodName: 'SaveWay',
		wayId: wayId,
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
		ClearWay();
	}
}

function ClearWay(){
	$("#conCode").val('');
	$("#conDesc").val('');
	$HUI.checkbox("#chkActive", { "checked": false });
	$HUI.checkbox("#chkRepeat", { "checked": false });
	$("#gridWay").datagrid("reload");
	
	
}





