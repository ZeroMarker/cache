/**
 * FileName: dhcinsu/mi.portroot.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * Description: ���Ұ�-ҽ�������ϴ�-���ڵ����õ���
 */

function Clean(){
	setValueById('PortRoot-PORTCODE','');
	//$('#PortRoot-HITYPE').combobox('clear');
	setValueById('PortRoot-MEDMDTRTTYPE','');
	setValueById('PortRoot-NODECODE','');
	setValueById('PortRoot-NODENAME','');
	setValueById('PortRoot-CONINFO','');
	//setValueById('PortRoot-HOSPID',rowData.HOSPID);
	//$('#PortRoot-HOSPID').combobox('clear');
	setValueById('PortRoot-ROWID','');	
	if ($('#PortRoot-NODECODE').attr("class").indexOf("combobox") >= 0){
		$('#PortRoot-NODECODE').combobox('destroy');
		if($('#PortRoot-NODECODE').length == 0){
			$('#TDPortRoot-NODECODE').prepend('<input id="PortRoot-NODECODE" class="textbox PortCom"/>');l
		}
				
	}
	//setValueById('PortRoot-INFNO','');
	//setValueById('PortRoot-INFNAME','');
			
}
 // ����
function SavePortRootmon(){
	var dgSelected = $('#dg').datagrid('getSelected');
	if(!dgSelected){
		return;	
	}
	var HITYPE = dgSelected.HITYPE;//$('#PortRoot-HITYPE').combobox('getValue');
	var HOSPID = dgSelected.HOSPID; //$('#PortRoot-HOSPID').combobox('getValue');
	
	
	var PORTCODE = getValueById('PortRoot-PORTCODE');
	var HITYPE = dgSelected.HITYPE;//$('#PortRoot-HITYPE').combobox('getValue');
	var HOSPID = dgSelected.HOSPID; //$('#PortRoot-HOSPID').combobox('getValue');
	var INFNAME = getValueById('PortRoot-INFNAME');
	var INFNO = getValueById('PortRoot-INFNO');
	var NODECODE = getValueById('PortRoot-NODECODE');
	var NODENAME = getValueById('PortRoot-NODENAME');
	var CONINFO = getValueById('PortRoot-CONINFO');
	var ROWID = '';
	
	if (PORTCODE == ""){
		INSUMIAlert('�ڵ����Ͳ���Ϊ��' , 'error');
		return;	
	}
	if (NODECODE == ""){
		INSUMIAlert('�ڵ���벻��Ϊ��' , 'error');
		return;	
	}
	
	var Msg = '<span style="color:red" >����</span>';
	var selectedRow = $('#PortRootDG').datagrid('getSelected');
	if(selectedRow){
		ROWID = selectedRow.ROWID;
		Msg =  '<span style="color:red" >����</span>';
	}	
	$.messager.confirm('��ʾ','�Ƿ����[' + Msg + '],�ڵ����Ϊ��' + NODECODE + ',�ڵ�ֵ:' + CONINFO,function(r){
		if(r){
			var InStr = ROWID + '^' + HOSPID  + '^' + HITYPE + '^' + PORTCODE  + '^' + INFNO + '^' + INFNAME  + '^' + NODECODE + '^' + NODENAME + '^' + CONINFO;
			var rtn = $.m({ClassName: "INSU.MI.PortRoot", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
			if (rtn == '0'){
				INSUMIAlert('����ɹ�' , 'success');
			}else{
				INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
			}
			LoadPortRoot();	
		}		
	});

}
// ɾ��
function DeletePortRootmon(){
	var selectedRow = $('#PortRootDG').datagrid('getSelected');
	if (!selectedRow){
		INSUMIAlert('��ѡ��Ҫɾ������' , 'error');
		return;	
	}
	ROWID = selectedRow.ROWID;
	$.messager.confirm('��ʾ','�Ƿ����ɾ��?',function(r){
		if(r){
			var rtn = $.m({ClassName: "INSU.MI.PortRoot", MethodName: "Delete", RowId:ROWID}, false);
			if (rtn == '0'){
				INSUMIAlert('ɾ���ɹ�' , 'success');
				Clean();
				LoadPortRoot();
			}else{
				INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
				LoadPortRoot();
			}		
		}	
	})		
}
// 
//
function init_PortRootDg(){
	var colums = [[
		{field:'HOSPID',title:'ҽԺ',width:100,align:'center'},
		{field:'HITYPE',title:'ҽ������',width:100,align:'center'},
		{field:'PORTCODE',title:'�ڵ�����',width:94,align:'center'},
		{field:'INFNO',title:'���ױ��',width:100,align:'center'},
		{field:'INFNAME',title:'��������',width:60,align:'center'},
		{field:'NODECODE',title:'�ڵ����',width:50,align:'center'},
		{field:'NODENAME',title:'�ڵ�����',width:100},
		{field:'CONINFO',title:'�ڵ�ֵ',width:70,align:'center'},
		{field:'ROWID',title:'ROWID',width:48,align:'center',hidden:true}
	]];
	var width = 871;
	$HUI.datagrid('#PortRootDG',{
		//height: 150,
		border:true,
		fitColumns: true,
		singleSelect: true,
		data: [],
		width:width,
		height:(660-287),
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
			FillPortRootDGInfo(rowData);
		},
		onUnselect:function(rowIndex, rowData){
			
		}
	});	
	init_NodeType();
}

function init_NodeType(){
	try{
		$('#PortRoot-PORTCODE').combobox({
			valueField: 'cCode',
			textField: 'cDesc',
			data:[
				{
					'cCode':'Config',
					'cDesc':'��������ʱ������������'
				},
				{
					'cCode':'Root',
					'cDesc':'��������ʱ�����ĸ��ڵ�'
				}			
				],
			onSelect: function (data) {
				if(data.cCode == "Config"){ // config���� ����������
					init_PortRootNodeCode();	
				}else{ //root ����input�ı���
					if ($('#PortRoot-NODECODE').attr("class").indexOf("combobox") >= 0){
						$('#PortRoot-NODECODE').combobox('destroy');
					}
					if($('#PortRoot-NODECODE').length == 0){
						$('#TDPortRoot-NODECODE').prepend('<input id="PortRoot-NODECODE" class="textbox PortCom"/>');
					}
				}
				setValueById('PortRoot-CONINFO','');
				setValueById('PortRoot-NODENAME','');
			}
		});	
	}catch(e){
		INSUMIAlert(e.responseText , 'error');	
	}	
}
// �ڵ����
function init_PortRootNodeCode(){
	if ($('#PortRoot-NODECODE').attr("class").indexOf("combobox") >= 0){
		$('#PortRoot-NODECODE').combobox('destroy');
	}
	if($('#PortRoot-NODECODE').length == 0){
		$('#TDPortRoot-NODECODE').prepend('<input id="PortRoot-NODECODE" class="hisui-combobox textbox PortCom"/>');
	}
	$('#PortRoot-NODECODE').combobox({
		defaultFilter: 4,
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		editable:false,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'RootConfig';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;
		},
		onSelect: function (data) {
			setValueById('PortRoot-NODENAME',data.cDesc);
		}	
	});
}

function FillPortRootDGInfo(rowData){
	//$('#PortRoot-HOSPID').combogrid('setValue',rowData.HOSPID)
	//$('#PortRoot-HITYPE').combobox('clear');
	//$('#PortRoot-HITYPE').combogrid('setValue',rowData.HITYPE); 
	//setValueById('PortRoot-HITYPE',rowData.HITYPE);
	setValueById('PortRoot-MEDMDTRTTYPE',rowData.MEDMDTRTTYPE);
	
	setValueById('PortRoot-INFNO',rowData.INFNO);
	setValueById('PortRoot-INFNAME',rowData.INFNAME);
	setValueById('PortRoot-PORTCODE',rowData.PORTCODE);
	
	setValueById('PortRoot-NODECODE',rowData.NODECODE);
	setValueById('PortRoot-NODENAME',rowData.NODENAME);
	setValueById('PortRoot-CONINFO',rowData.CONINFO);
	setValueById('PortRoot-ROWID',rowData.ROWID);	
}
function LoadPortRoot(){
	INSUMIClearGrid('PortRootDG');
	var dgSelected = $('#dg').datagrid('getSelected');
	if(!dgSelected){
		return;	
	}
	var HITYPE = dgSelected.HITYPE;//$('#PortRoot-HITYPE').combobox('getValue');
	var HOSPID = dgSelected.HOSPID; //$('#PortRoot-HOSPID').combobox('getValue');
	
	var queryParams = {
	    ClassName : 'INSU.MI.PortRoot',
	    QueryName : 'QueryPortRoot',
	    Hospital: HOSPID,
	    InsuType : HITYPE,
	    QINFNO:getValueById('PortRoot-INFNO')
	}	
    loadDataGridStore('PortRootDG',queryParams);				
}
function paramCFGClick(){
	var NodeCode = getValueById('PortRoot-NODECODE');
	if(NodeCode != "InputParam"){
		INSUMIPOP('�ð�ťֻ�������ýڵ����ΪInputParam������' , 'error');
		return;		
	}		
}