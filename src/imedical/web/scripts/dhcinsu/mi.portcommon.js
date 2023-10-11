/**
 * FileName: dhcinsu/mi.portcommon.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * Description: ���Ұ�-ҽ�������ϴ�-�������Ե���
 */
function CleanPortPubCommon(){
	setValueById('PortCom-TYPE','');
	//$('#PortCom-HITYPE').combobox('clear');
	setValueById('PortCom-MEDMDTRTTYPE','');
	setValueById('PortCom-INSUTYPE','');
	setValueById('PortCom-NODECODE','');
	setValueById('PortCom-NODENAME','');
	setValueById('PortCom-CONINFO','');
	//setValueById('PortCom-HOSPID',rowData.HOSPID);
	//$('#PortCom-HOSPID').combobox('clear');
	setValueById('PortCom-ROWID','');
	
		
}
 // ����
function SavePortCommon(){
	var TYPE = getValueById('PortCom-TYPE');
	var HITYPE = $('#InsuType').combobox('getValue');
	var HOSPID = $('#Hospital').combobox('getValue');
	var HOSPID = $('#Hospital').combobox('getValue');

	var MEDMDTRTTYPE = getValueById('PortCom-MEDMDTRTTYPE');
	var INSUTYPE = getValueById('PortCom-INSUTYPE');
	var NODECODE = getValueById('PortCom-NODECODE');
	var NODENAME = getValueById('PortCom-NODENAME');
	var CONINFO = getValueById('PortCom-CONINFO');
	
	var ROWID = '';
	var selectedRow = $('#PubDG').datagrid('getSelected');
	if(selectedRow){
		ROWID = selectedRow.ROWID
	}
	var InStr = ROWID + '^' + HOSPID  + '^' + TYPE + '^' + HITYPE  + '^' + MEDMDTRTTYPE + '^' + INSUTYPE  + '^' + NODECODE + '^' + NODENAME + '^' + CONINFO;
	var rtn = $.m({ClassName: "INSU.MI.PortCommonCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
	if (rtn == '0'){
		INSUMIAlert('����ɹ�' , 'success');
		LoadPubDG();
	}else{
		INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
		LoadPubDG();
	}
	LoadPubDG();
}
// ɾ��
function DeletePortCommon(){
	var selectedRow = $('#PubDG').datagrid('getSelected');
	if (!selectedRow){
		INSUMIAlert('��ѡ��Ҫɾ������' , 'error');
		return;	
	}	
	ROWID = selectedRow.ROWID;
	var rtn = $.m({ClassName: "INSU.MI.PortCommonCom", MethodName: "Delete", RowId:ROWID}, false);
	if (rtn == '0'){
		INSUMIAlert('ɾ���ɹ�' , 'success');
		LoadPubDG();
	}else{
		INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
		LoadPubDG();
	}
}
// ����
//
function init_PortCommonDg(){
	var colums = [[
		{field:'TYPE',title:'��������',width:100,align:'center'},
		{field:'HITYPE',title:'ҽ������',width:100,align:'center'},
		{field:'MEDMDTRTTYPE',title:'��������',width:94,align:'center'},
		{field:'INSUTYPE',title:'��������',width:100,align:'center'},
		{field:'NODECODE',title:'�ڵ����',width:60,align:'center'},
		{field:'NODENAME',title:'�ڵ�����',width:50,align:'center'},
		{field:'CONINFO',title:'������Ϣ',width:100},
		{field:'HOSPID',title:'ҽԺ',width:70,align:'center'},
		{field:'ROWID',title:'ROWID',width:48,align:'center',hidden:true}
	]];
	var width = 871;
	$HUI.datagrid('#PubDG',{
		//height: 150,
		border:true,
		fitColumns: true,
		singleSelect: true,
		data: [],
		width:width,
		height:660-240,
		//toolbar:'#PubDGTB',
		columns:colums,
		pageSize:10,
		pageList:[10,20],
		pagination:true,
		onLoadSuccess:function(data){

		},
		onDblClickRow:function(){
			
		},
		onSelect:function(rowIndex, rowData){
			FillTableInfo(rowData);
		},
		onUnselect:function(rowIndex, rowData){
			
		}
	});	
}
function FillTableInfo(rowData){
	//$('#PortCom-HOSPID').combogrid('setValue',rowData.HOSPID)
	setValueById('PortCom-TYPE',rowData.TYPE);
	//$('#PortCom-HITYPE').combobox('clear');
	//$('#PortCom-HITYPE').combogrid('setValue',rowData.HITYPE); 
	//setValueById('PortCom-HITYPE',rowData.HITYPE);
	setValueById('PortCom-MEDMDTRTTYPE',rowData.MEDMDTRTTYPE);
	setValueById('PortCom-INSUTYPE',rowData.INSUTYPE);
	setValueById('PortCom-NODECODE',rowData.NODECODE);
	setValueById('PortCom-NODENAME',rowData.NODENAME);
	setValueById('PortCom-CONINFO',rowData.CONINFO);
	setValueById('PortCom-ROWID',rowData.ROWID);	
}
function LoadPubDG(){
	INSUMIClearGrid('PubDG');
	var HITYPE = $('#InsuType').combobox('getValue');
	var HOSPID = $('#Hospital').combobox('getValue');
	var queryParams = {
	    ClassName : 'INSU.MI.PortCommonCom',
	    QueryName : 'QueryPortCommon',
	    HospID:HOSPID,
	    InsuType:HITYPE
	}	
    loadDataGridStore('PubDG',queryParams);		
	init_PortComType();		
}

// ��������
function init_PortComType(){
	$('#PortCom-TYPE').combobox({
		defaultFilter: 4,
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'INSUMIType';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {
		},onLoadSuccess:function(){

		}
	});		 
	 
}