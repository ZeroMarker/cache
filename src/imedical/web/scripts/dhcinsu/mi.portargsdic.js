/**
 * FileName: dhcinsu/mi.portargsdic.js
 * Anchor: tangzf
 * Date: 2021-02-02
 *2022-11-10/��˧/UI�޸�
 * Description: ���Ұ�-����Ԫ�ֵ�����
 */
 $(function(){
	 init_portargsdicDG();
	 
	 // ����״̬	
	 $("#PUBLISHSTATUS").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	        {text:'�ݸ�',id:'0',selected:true},
	        {text:'���',id:'1'},
	        {text:'����',id:'2'}
	    ],
	    onClick:function(v){
			LoadportargsdicDG();    
		}
	});
	 // ��������
	 $('#CONTENTTYPE').combobox({
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'CONTENTTYPE';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {
		}
	});	
	 // �����ʶ 
	 $('#MUSTFLAG').combobox({
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'MUSTFLAG';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {			
		}
	});	
	 // ��Ч��ʶ
	 $('#EFFTFLAG').combobox({
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'EFFTFLAG';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;
		},
		onSelect: function (data) {
		
		}
	});	
	$('.textbox').keyup(function(){
		if(event.keyCode==13){
			LoadportargsdicDG();
		}
	});
	$HUI.linkbutton("#Find", {
		onClick: function () {
			LoadportargsdicDG();
		}
	});
	$HUI.linkbutton("#Save", {
		onClick: function () {
			var dgSelect = $('#portargsdicDG').datagrid('getSelected');
			var selectROWID = '';
			if(dgSelect){
				selectROWID = dgSelect.ROWID;	
			}
			if(selectROWID != ''){ // uodate
				$.messager.confirm('ȷ��','�Ƿ����[�޸�]����Ϊ:' + dgSelect.CONTENTCODE +'������?',function(r){		
					if(r){
						SavePortList();	
					}			
				})
			}else{ // add
				$.messager.confirm('ȷ��','�Ƿ����[����]����?',function(r){		
					if(r){
						SavePortList();	
					}			
				})	
			}
		}
	});
	// ����
	$HUI.linkbutton("#Imp", {
		onClick: function () {
			INSUMIFileOpenWindow(import_PortArgsDic);
		}
	});
	$HUI.linkbutton("#Del", {
		onClick: function () {
			DeletePortList();		
		}
	});
	$HUI.linkbutton("#Clean", {
		onClick: function () {
			clean();		
		}
	});
	$HUI.linkbutton("#Build", {
		onClick: function () {
			BuildSplitWords();		
		}
	});
	var Param = getParam('CONTENTCODE');
	if(Param){
		setValueById('CONTENTCODE',Param);	
	}
	LoadportargsdicDG();
})
// �ִ�
function BuildSplitWords(){
		
}
function init_portargsdicDG(){
	var colums = [[
		{field:'ck',title:'ck',width:220, checkbox:true},
		{field:'CONTENTCODE',title:'��������',width:140},
		{field:'CONTENTNAME',title:'��������',width:140},
		{field:'CONTENTTYPE',title:'��������',width:140,formatter:function(value, data,index){
				var rtn = GLOBAL.CONTENTTYPE[value] || value;
				return rtn ;	
			}
		},
		{field:'CONTENTLENG',title:'��������',width:140},
		{field:'CONTENTDICFLAG',title:'�����־',width:140},
		{field:'MUSTFLAG',title:'�����־',width:140,formatter:function(value, data,index){
				var rtn = GLOBAL.MUSTFLAG[value] || value;
				return rtn ;	
			}},
		{field:'EFFTFLAG',title:'��Ч��־',width:140,formatter:function(value, data,index){
				var rtn = GLOBAL.EFFTFLAG[value] || value;
				return rtn ;	
			}},
		{field:'VER',title:'�汾��',width:108},
		{field:'PUBLISHSTATUS',title:'����״̬',width:130,formatter:function(value, data,index){
				var rtn = GLOBAL.PUBLISHSTATUS[value] || value;
				return rtn ;	
			}},
		{field:'ROWID',title:'ROWID',width:120,hidden:true}
	]];
	$HUI.datagrid('#portargsdicDG',{
		border:false,
		//fitColumns: true,
		singleSelect: false,
		data: [],
		fit:true,
		columns:colums,
		pageSize:30,
		pageList:[30,60,90],
		pagination:true,
		toolbar:'#TB',
		onLoadSuccess:function(data){

		},
		onDblClickRow:function(){
			
		},
		onSelect:function(rowIndex, rowData){
			FillportargsdicDG(rowData);
			$('#Save').linkbutton({text:'�޸�'});
		},
		onUnselect:function(rowIndex, rowData){
			var checkedRows = $('#portargsdicDG').datagrid('getChecked');
			if (checkedRows.length == '0'){
				$('#Save').linkbutton({text:'����'});
			} 
		}
	});	
	
}
function FillportargsdicDG(rowData){
	setValueById('CONTENTCODE',rowData.CONTENTCODE);
	setValueById('CONTENTNAME',rowData.CONTENTNAME);
	setValueById('CONTENTTYPE',rowData.CONTENTTYPE);
	setValueById('CONTENTLENG',rowData.CONTENTLENG);
	setValueById('CONTENTDICFLAG',rowData.CONTENTDICFLAG);	
	setValueById('MUSTFLAG',rowData.MUSTFLAG);
	setValueById('EFFTFLAG',rowData.EFFTFLAG);
	setValueById('VER',rowData.VER);	
}
function LoadportargsdicDG(){
	var PUBLISHSTATUS = $('#PUBLISHSTATUS').keywords('getSelected')[0].id;
	var CONTENTCODE = getValueById('CONTENTCODE');
	var CONTENTNAME = getValueById('CONTENTNAME');
	var CONTENTTYPE = getValueById('CONTENTTYPE');
	var CONTENTLENG = getValueById('CONTENTLENG');
	var CONTENTDICFLAG = getValueById('CONTENTDICFLAG');
	var MUSTFLAG = getValueById('MUSTFLAG');
	var EFFTFLAG = getValueById('EFFTFLAG');
	var VER = getValueById('VER');
	var ParamInput = PUBLISHSTATUS + "|" + CONTENTCODE + "|" + CONTENTNAME + "|"  + CONTENTTYPE + "|"  + EFFTFLAG+ "|"  + VER
	var queryParams = {
	    ClassName : 'INSU.MI.PortArgsDicCom',
	    QueryName : 'QueryPortArgsDic',
	    ParamInput : ParamInput
	  }	
    loadDataGridStore('portargsdicDG',queryParams);	
    //clean();			
}

function clean(){
	setValueById('PUBLISHSTATUS',"");
	setValueById('CONTENTCODE',"");
	setValueById('CONTENTNAME',"");
	setValueById('CONTENTTYPE',"");	
	setValueById('CONTENTLENG',"");
	setValueById('CONTENTDICFLAG',"");
	setValueById('MUSTFLAG',"");
	setValueById('EFFTFLAG',"");
	setValueById('VER',"");		
	$('#portargsdicDG').datagrid('unselectAll');
	$('#portargsdicDG').datagrid('uncheckAll');
	$('#Save').linkbutton({text:'����'});
}
 // ����
function SavePortList(){
	var PUBLISHSTATUS = '0'; // ֻ�������ݸ�״̬������
	var CONTENTCODE = getValueById('CONTENTCODE');
	var CONTENTNAME = getValueById('CONTENTNAME');
	var CONTENTTYPE = getValueById('CONTENTTYPE');
	var CONTENTLENG = getValueById('CONTENTLENG');
	var CONTENTDICFLAG = getValueById('CONTENTDICFLAG');
	var MUSTFLAG = getValueById('MUSTFLAG');
	var EFFTFLAG = getValueById('EFFTFLAG');
	var VER = getValueById('VER');
	var dgSelect = $('#portargsdicDG').datagrid('getSelected');
	var selectROWID = '';
	if(dgSelect){
		selectROWID = dgSelect.ROWID;
		PUBLISHSTATUS = $('#PUBLISHSTATUS').keywords('getSelected')[0].id; //	
	}
	
	var InStr = selectROWID + '^' + PUBLISHSTATUS    + '^' + CONTENTCODE + '^' + CONTENTNAME + '^' + CONTENTTYPE;
	var InStr = InStr + '^' + CONTENTLENG  + '^' + CONTENTDICFLAG + '^' + MUSTFLAG  + '^' + EFFTFLAG+ '^'  + VER;
	var rtn = $.m({ClassName: "INSU.MI.PortArgsDicCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
	if (rtn == '0'){
		INSUMIAlert('����ɹ�' , 'success');
	}else{
		INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
	}
	LoadportargsdicDG();
}
// ɾ��
function DeletePortList(){
	var dgSelect = $('#portargsdicDG').datagrid('getSelected');
	var RowId = '';
	if(dgSelect){
		RowId = dgSelect.ROWID;	
	}
	if (RowId == ''){
		INSUMIAlert('��ѡ��Ҫɾ������' , 'error');
		return;	
	}
	$.messager.confirm('��ʾ','�Ƿ����ɾ��������?�ò�����ɾ����Ӧ�Ĳ���',function(r){
				if(r){	
	var rtn = $.m({ClassName: "INSU.MI.PortArgsDicCom", MethodName: "Delete", RowId:RowId,}, false);
	if (rtn == '0'){
		INSUMIAlert('ɾ���ɹ�' , 'success');
		LoadportargsdicDG();
	}else{
		INSUMIAlert('ɾ��ʧ��'  + rtn , 'error');
		LoadportargsdicDG();
	}
		}
				});
	clean();
}
function Operation(type){
	var checkedRows = $('#portargsdicDG').datagrid('getChecked');
	var RowIdStr = '';
	if (checkedRows.length == '0'){
		INSUMIAlert('û����Ҫ����������' , 'info');
		return;
	}
	for (var i = 0; i <= checkedRows.length - 1; i++) {
		RowIdStr = RowIdStr + '^' + checkedRows[i].ROWID; 
	}
	var rtn = $.m({ClassName: "INSU.MI.PortArgsDicCom", MethodName: "UpdatePublishStatusById", Status:type,RowIdStr:RowIdStr,User:session['LOGON.USERID']}, false);
	if (rtn == '0'){
		$.messager.alert('��ʾ','�����ɹ�' , 'success',function(){
			LoadportargsdicDG();
		});
	}else{
		$.messager.alert('��ʾ','����ʧ��' + rtn , 'error',function(){
			//LoadportargsdicDG();
		});
	}	
}
