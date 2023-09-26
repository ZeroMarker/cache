/**
 * INSUMsgInfo.js
 * ҽ����־��ѯ
 * tangzf 20190709
 */
 var HospDr=session['LOGON.HOSPID'];
//�������
$(function(){
	//�س��¼�    
	key_enter();
		
	//ҵ������box
	ini_YWLX();
	
	// ��Ʒ��
	ini_ProductLine();
	
	//Ĭ��ʱ��
	setDateBox();
	
	// grid
	init_dg();
});
//�������
function init_dg(){
	var dgobj = $HUI.datagrid("#dg", {
		fit: true,
		border:false,
		nowrap: true,
		striped: true,
		pagination: true,
		singleSelect: true,
		collapsible: true,
		onSelect: function (rowIndex, rowData) { rowindex = rowIndex; },
		onClickCell: function (rowIndex, field, value) { FormDialog(field, value, rowIndex); },
		onDblClickCell: function (rowIndex, field, value) { doubleCell("Edit", rowIndex, field); },
		columns: [[
			{ title: '������', field: 'MsgInfoDr', width: 70, hidden: true },
			{ title: '����', field: 'OutUserCode', width: 70 },
			{ title: '�ǼǺ�', field: 'OutRegNo', width: 90 },
			{ title: '����', field: 'OutPaName', width: 70 },
			{ title: 'ҽ����', field: 'OutInsuNo', width: 80 },
			{ title: '�����', field: 'OutAdmDr', width: 70 },
			{ title: '��ƱDr', field: 'OutInvPrtDr', width: 60 },
			{ title: '�˵�', field: 'OutPBDr', width: 70 },
			{ title: 'ҵ�����ʹ���', field: 'OutYWLX', width: 100 },
			
			{ title: '������Ϣ', field: 'OutMsg', width: 400, },
			{ title: '������', field: 'OutSolveFlag', width: 80 },
			{ title: '�������', field: 'OutResolvent', width: 400, },
			/* 					{title:'������Ϣ',field:'OutMsg',width:400,halign:'center', formatter: function (value) {
						//return ; //Ding
								return "<span title='" + value + "'>" + value + "</span>";}},	
					  {title:'�������',field:'OutResolvent',width:400,halign:'center', formatter: function (value) {
						//return ; //Ding
								return "<span title='" + value + "'>" + value + "</span>"}, editor:{type:'text'}}, */
			{ title: '��������', field: 'OutDate', width: 90 },
			{ title: '����ʱ��', field: 'OutTime', width: 90 },
			{ title: '�����', field: 'OutSolveUser', width: 80 },
			{ title: '�������', field: 'OutSolveDate', width: 90 },
			{ title: '���ʱ��', field: 'OutSolveTime', width: 90 },
			{ title: '�ͻ���IP', field: 'OutIPAdress', width: 70 },
			{ title: 'MAC', field: 'OutIPMAC', width: 85 },
			{ title: '�ͻ�������', field: 'OutCliDate', width: 90 },
			{ title: '�ͻ���ʱ��', field: 'OutCliTime', width: 90 },
			{ title: '��Ʒ��', field: 'ProductLine', width: 100 },
			{ title: '�ͻ�������', field: 'OutCliName', width: 80 }
		]],
		data:[]
	});
	
}
function deleteMsg() {
	var dgobj = $HUI.datagrid("#dg")
	if (dgobj) {
		$.m({
			ClassName: "web.INSUMsgInfo",
			MethodName: "delete",
			MsgInfoDr: dgobj.MsgInfoDr
		}, function (txtData) {
			if(txtData=='0'){
				$.messager.alert('��ʾ','ɾ���ɹ�','info');
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��','info');		
			}
		});
	}
}

//��ѯ
function RunQuery() {
	var YWLXobj = $HUI.combogrid("#YWLX")
	var tmpurl = "&UserCode=" + $('#UserCode').val() + "&StrIp=" + $('#StrIp').val() + "&IPMAC=" + $('#IPMAC').val() + "&RegNo=" + $('#RegNo').val() + "&InsuNo=" + $('#InsuNo').val();
	tmpurl = tmpurl + "&AdmDr=" + $('#AdmDr').val() + "&InvPrtDr=" + $('#InvPrtDr').val() + "&PBDr=" + $('#PBDr').val() + "&StartDate=" + getValueById('StartDate') + "&EndDate=" + getValueById('EndDate') + "&DateFlag=" + $('#DateFlag').checkbox('getValue') + "&SolveFlag=" + $('#SolveFlag').checkbox('getValue') + "&YWLX=" + YWLXobj.getValue();
	tmpurl = tmpurl + "&HospId=" + HospDr + "&ParamProductLine=" + $HUI.combogrid("#ProductLine").getValue();
	$HUI.datagrid("#dg", {
		url: $URL + "?ClassName=web.INSUMsgInfo&QueryName=GetINMSGInfo" + tmpurl,
		pageSize: 20
	})
}
//������Ԫ�� ����ģ̬��  w ##class(web.INSUMsgInfo).GetMsgAllInfoByRowId("202486")
function FormDialog(field, value, rowIndex) {
	switch (field) {
		case "OutMsg":
			var dgobj = $HUI.datagrid("#dg")
			dgobj.selectRow(rowIndex)
			var val = ""
			$.m({
				// get err detailinfo from global
				ClassName: "web.INSUMsgInfo",
				MethodName: "GetMsgAllInfoByRowId",
				RowId: dgobj.getSelected().MsgInfoDr,
			},function (textdata) {
					if (textdata != "") {
						openCellWindow(textdata,"disable",'������Ϣ')
					}else{
						$.messager.alert('��ʾ','Global��Ϣ������','error')
					}
				}
			)
			break;
		case "OutResolvent":
			if (value == "") { value = " "; }
			openCellWindow(value,"enable",'�������')
			break;
		case "Edit":
			openCellWindow(value,"enable",'�������')
			break;
		default:
			break;
	}
}
// �޸Ľ������
function saveSolveInfo() {
	var selectRowObj = $('#dg').datagrid('getSelected');
	var editInfo = $('#editCode').val();
	var rtn = tkMakeServerCall("web.INSUMsgInfo", "update", selectRowObj.MsgInfoDr, editInfo);
	if (rtn > 0) {
		$.messager.alert('��ʾ', '�޸ĳɹ�,RowId:' + rtn, 'info', function () {
			RunQuery();
			$('#Modifydl').window('close');
		});
	} else {
		$.messager.alert('��ʾ', '�޸�ʧ��,err:' + rtn, 'info', function () {
			$('#Modifydl').window('close');
		});
	}
}
//Ĭ��ʱ��
function setDateBox() {
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}
///�س�
function key_enter() {
	$('#UserCode').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#InsuNo').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#RegNo').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#AdmDr').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
}
// ˫����Ԫ��
function doubleCell(Flag, rowindex, field) {
	switch (field) {
		case "OutSolveFlag":
			var dgobj = $HUI.datagrid("#dg")
			dgobj.selectRow(rowindex)
			var msgobj = $.messager
			msgobj.defaults.ok = "��";
			msgobj.defaults.cancel = "��";
			msgobj.confirm('�޸�', '�ô����Ƿ�����', function (r) {
				if (r) { dgobj.getSelected().OutSolveFlag = "Y"; }
				else { dgobj.getSelected().OutSolveFlag = "N"; }
				$.m(
					{
						ClassName: "web.INSUMsgInfo",
						MethodName: "update",
						MsgInfoDr: dgobj.getSelected().MsgInfoDr,
						InString: "^" + dgobj.getSelected().OutSolveFlag //�������^������
					},
					function (textData) {
						if (textData != "") $.messager.alert('��ʾ', "�޸ĳɹ�,RowId:" + textData, 'info');
						RunQuery();
					}
				)
			});
			break;
		default:
			break;
	}
}
//����
function clear_click() {
	$('.search-table').form('clear');
}
//ҵ������
function ini_YWLX() {
	$HUI.combogrid("#YWLX", {
		url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=INSUMsgYWLX"+'&HospDr='+HospDr,
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '����', field: 'cCode', width: 200 },
			{ title: '����', field: 'cDesc', width: 200 },
		]]
	})
}
// ��Ʒ��
function ini_ProductLine() {
	$HUI.combogrid("#ProductLine", {
		url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=INSUMsgProductLine"+'&HospDr='+HospDr,
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '����', field: 'cCode', width: 200 },
			{ title: '����', field: 'cDesc', width: 200 },
		]]
	})
}
/**
 * Creator: tangzf
 * CreatDate: 2019-7-10
 * Description: ���ɴμ�����Modifydl
 * input:	msg : ��ʾ����
 * 			buttonType : �Ƿ���ʾ��ť "Y" ��ʾ
 * 			title : ��������
 */
function openCellWindow(msg,buttonType,title){
	$('#editCode').val(msg);
	$('#Modifydl').panel({
    	title:title,
 	});
	$("#saveBtn").linkbutton(buttonType);
	$('#Modifydl').window('open');	
}
