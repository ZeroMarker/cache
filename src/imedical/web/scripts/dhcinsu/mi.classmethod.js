/**
 * FileName: dhcinsu/mi.classmethod.js
 * Anchor: tangzf
 * Date: 2021-04-20
 * Description: ���Ұ�-ҽ�������ϴ� �෽��ά��
 */

$(function(){
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			LoadDG();
		}
	});
	$HUI.linkbutton("#btnAdd", {
		onClick: function () {
			AddDGRows();
		}
	});
	$HUI.linkbutton("#btnSaveSingle", {
		onClick: function () {
			SaveSingleDG();
		}
	});
	$HUI.linkbutton("#btnDelete", {
		onClick: function () {
			DeleteDG();
		}
	});
	// edg
	$HUI.linkbutton("#btnEDGAdd", {
		onClick: function () {
			AddEDGRows();
		}
	});
	$HUI.linkbutton("#btnEDGSaveSingle", {
		onClick: function () {
			SaveSingleEDG();	
		}
	});
	$HUI.linkbutton("#btnEDGDelete", {
		onClick: function () {
			DeleteDG();
		}
	});
	$HUI.linkbutton("#btnEDGFind", {
		onClick: function () {
			LoadEDG();
		}
	});
	$HUI.linkbutton("#btnClear", {
		onClick: function () {
			ClearDG();
		}
	});
	$HUI.linkbutton("#btnEDGClear", {
		onClick: function () {
			ClearEDG();
		}
	});
	//�س��¼�
	init_Keyup();	
	// method
	init_dg();
	// param
	init_EDG();
	// init_MEDTHOTYPE
	init_MEDTHOTYPE();
	init_PARNODETYPE();
	init_ARGTYPE();
});
function init_MEDTHOTYPE(){
	$('#METHODTYP').combobox({
		defaultFilter: 4,
			valueField: 'cCode',
			textField: 'cDesc',
			url:$URL,
			mode:'remote',
			onBeforeLoad:function(param){
		      	param.ClassName = 'web.INSUDicDataCom';
		      	param.QueryName = 'QueryDic1';
		      	param.Type = 'METHODTYPE';
		      	param.HospDr = '';
		      	param.ResultSetType = 'array';
		      	return true;
			},
			onSelect: function (data) {
				
			}	
	})		
}
function init_PARNODETYPE(){
	$('#PARNODETYPE').combobox({
		defaultFilter: 4,
			valueField: 'cCode',
			textField: 'cDesc',
			url:$URL,
			mode:'remote',
			onBeforeLoad:function(param){
		      	param.ClassName = 'web.INSUDicDataCom';
		      	param.QueryName = 'QueryDic1';
		      	param.Type = 'PARNODETYPE';
		      	param.HospDr = '';
		      	param.ResultSetType = 'array';
		      	return true;
			},
			onSelect: function (data) {
				
			}	
	})		
}
function init_ARGTYPE(){
	$('#ARGTYPE').combobox({
		defaultFilter: 4,
			valueField: 'cCode',
			textField: 'cDesc',
			url:$URL,
			mode:'remote',
			onBeforeLoad:function(param){
		      	param.ClassName = 'web.INSUDicDataCom';
		      	param.QueryName = 'QueryDic1';
		      	param.Type = 'ARGTYPE';
		      	param.HospDr = '';
		      	param.ResultSetType = 'array';
		      	return true;
			},
			onSelect: function (data) {
				
			}	
	})		
}
// 
function LoadDG(){
	INSUMIClearGrid('dg');
	INSUMIClearGrid('edg');
	var CLASSNAME = getValueById('CLASSNAME');
	var METHODNAME = getValueById('METHODNAME');
	var METHODTYP = getValueById('METHODTYP');
	var METHODDESC = getValueById('METHODDESC');
	var queryParams = { // StDate, EnDate , Inv , User , Type
		ClassName : 'INSU.MI.ClassMethodCom',
		QueryName : 'QueryClassMethod',
		ParamInput : CLASSNAME + '|' + METHODNAME + '|' + METHODTYP + '|' + METHODDESC
	}
	loadDataGridStore('dg',queryParams);
}
// 
function LoadEDG(){
	INSUMIClearGrid('edg');
	var DGSelect = $('#dg').datagrid('getSelected');
	if(!DGSelect){
		$.messager.popover({
				msg:'����ѡ�񷽷�',
				type:'error'	
			});
		return;	
	}
	var ARGCODE = getValueById('ARGCODE');
	var ARGNAME = getValueById('ARGNAME');
	var ARGTYPE = getValueById('ARGTYPE');
	var PARNODETYPE = getValueById('PARNODETYPE');
	var queryParams = {
		ClassName : 'INSU.MI.ClassMethodArgsCom',
		QueryName : 'QueryClassMethodArgs',
		ParamInput : DGSelect.ROWID + '|' + ARGCODE + '|' + ARGNAME + '|' + ARGTYPE + '|' + PARNODETYPE
	}
	loadDataGridStore('edg',queryParams);	
}

//ȷ�ϲ���������
function Update(){
	var dg = $('#dg').datagrid('getSelected');
	if(dg ){
		if( dg){
			
		}
	}
	var AdmType =  getValueById('AdmType');
	var ParentId = AdmType == "IP" ? dg.Arrcp : dg.PrtRowID;
  	$.messager.confirm('��ʾ', '�Ƿ�����ύ�޸���Ϣ��', function (r) {
		if (r) {
	    	var SQLCODE = tkMakeServerCall("BILL.COM.ModifyINVPayMode", "InsertPayMode", insertStr , session['LOGON.USERID'],AdmType,ParentId);
	    	if(SQLCODE=='0'){
		    	$.messager.popover({
					msg:'�ύ�ɹ�',
					type:'success'	
				});	
		    }else{
			   $.messager.popover({
					msg:'�ύʧ��',
					type:'error'	
				}); 
			}
			LoadInvPayMode();			
		}	    
  	});
}
/**
 * Creator: tangzf
 * CreatDate: 2019-6-12
 * Description: ��ѯ���س��¼�
 */
function init_Keyup() {
	$('#DGSearch .textbox').keyup(function(){
		if(event.keyCode==13){
			LoadDG();
		}
	});
	$('#EDGSearch .textbox').keyup(function(){
		if(event.keyCode==13){
			LoadEDG();
		}
	});
}

//grid
function init_dg() { 
	grid=$('#dg').datagrid({
		autoSizeColumn:false,
		fit:true,
		striped:true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		border:false,
		cache:true,
		toolbar:'#dgTB',
		pagination:true,
		columns:[[ // ,,,,,,,,,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,
			{field:'CLASSNAME',title:'����',width:150,editor:{
				type: 'text'
			}},
			{field:'METHODNAME',title:'������',width:150,editor:{
				type: 'text'
			}},
			{field:'METHODTYP',title:'��������',width:80,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'web.INSUDicDataCom';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'METHODTYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			}
			,formatter:function(value, data,index){
				var rtn = GLOBAL.METHODTYPE[value];
				return rtn ;	
			}},
			{field:'METHODDESC',title:'��������',width:100,editor:{
				type: 'text'
			}},
			{field:'DEMO',title:'��ע',width:150,editor:{
				type: 'text'
			}},
			{field:'EFFTFLAG',title:'��Ч��־',width:120,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
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
				}
			}},
			{field:'MULTSPLIT',title:'���ζ��зָ���',width:100,editor:{
				type: 'text'
			}},
			{field:'DATASPLIT',title:'���ݷָ��',width:100,editor:{
				type: 'text'
			}},
			{field:'OUTPUTTYPE',title:'����ֵ����',width:120,editor:{
				type: 'text'
			},hidden:true},
			{field:'ROWID',title:'ROWID',width:120,hidden:true}
		]],
        onSelect : function(rowIndex, rowData) {
		  LoadEDG();  
        },
        onUnselect: function(rowIndex, rowData) {
        },
        onBeforeLoad:function(param){
			
	    },
	    onDblClickRow:function(index,row){
			BeginEdit(index,row);
		},
	    onLoadSuccess:function(data){
			
		}
	});	
}
function init_EDG() { 
	$HUI.datagrid('#edg',{
		//height: 420,
		fit:true,
		border:false,
		fitColumns: true,
		singleSelect: true,
		data: [],
		toolbar:'#edgTB',
		columns:[[ 
			{field:'SEQ',title:'���',width:110,editor:{
				type: 'text'
			}},
			{field:'ARGCODE',title:'��������',width:120,editor:{
				type: 'text'
			}},
			{field:'ARGNAME',title:'��������',width:110,editor:{
				type: 'text'
			}},
			{field:'ARGTYPE',title:'��������',width:100,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'web.INSUDicDataCom';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'ARGTYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			}},
			{field:'PARNODETYPE',title:'���������',width:150,editor:{
				type: 'combobox',
				options: {
					defaultFilter: 4,
					valueField: 'cCode',
					textField: 'cDesc',
					url:$URL,
					mode:'remote',
					onBeforeLoad:function(param){
				      	param.ClassName = 'web.INSUDicDataCom';
				      	param.QueryName = 'QueryDic1';
				      	param.Type = 'PARNODETYPE';
				      	param.HospDr = '';
				      	param.ResultSetType = 'array';
				      	return true;

					},
					onSelect: function (data) {
						
					}
				}
			}},
			{field:'MAXLENG',title:'��󳤶�',width:120,editor:{
				type: 'text'
			}},
			{field:'ROWID',title:'ROWID',width:120,hidden:true}
		]],
		pageSize:99999,
		pagination:false,
		onLoadSuccess:function(data){
		},
		onDblClickRow:function(index,row){
			BeginEDGEdit(index,row);
		},
		onLoadSuccess:function(){
		},
		onAfterEdit:function(index,rows,changeData){
			
		},onBeginEdit:function(index){
		}
	});
}
// ���浥��
function SaveSingleDG(){
	var SelectIndex = INSUMIGetEditRowIndexByID('dg');
	if(SelectIndex > -1){
		$('#dg').datagrid('endEdit',SelectIndex);
	}
	var TotalNum = 0;
	var SuccessNum = 0;
	var ErrorNum = 0;
	var dgRows = $('#dg').datagrid('getChanges');
	for (var rowIndex = 0; rowIndex < dgRows.length; rowIndex++) {
		var dgRow = dgRows[rowIndex];
		if(dgRow){
			TotalNum++;
			var dgSelectRowId = dgRow.ROWID || '';
			var dgSelectIndex = $('#dg').datagrid('getRowIndex',dgRow);
			$('#dg').datagrid('beginEdit',dgSelectIndex);
			var editorRow = {
				CLASSNAME: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'CLASSNAME'),
				METHODNAME: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'METHODNAME'),  
				METHODTYP: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'METHODTYP'),  
				METHODDESC: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'METHODDESC'),
				DEMO: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'DEMO'),  
				EFFTFLAG: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'EFFTFLAG'), 
				DATASPLIT: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'DATASPLIT'), 
				OUTPUTTYPE: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'OUTPUTTYPE'), 
				MULTSPLIT: INSUMIDataGrid.getCellVal('dg',dgSelectIndex,'MULTSPLIT') ,
				ROWID : dgSelectRowId
			}
			$('#dg').datagrid('endEdit',dgSelectIndex);
			var InJson = JSON.stringify(editorRow);
			var rtn = $.m({ClassName: "INSU.MI.ClassMethodCom", MethodName: "Save", InStr: InJson,SessionStr: session['LOGON.USERID']}, false);
			if(rtn == '0'){
				SuccessNum++;
				$('#dg').datagrid('updateRow',{
					index : dgSelectIndex,
					row: editorRow
				});
			}else{
				ErrorNum++;
			}			
		}
	}
	INSUMIAlert('���ι�����:' + TotalNum + '����' + '�ɹ�:' + SuccessNum + '��ʧ�ܣ�' + ErrorNum +'��');
	LoadDG();
}
// ����
function SaveSingleEDG(){
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('����ѡ���෽��' , 'error');
        return ;	
	}
	if(!dgSelect.ROWID){
		INSUMIAlert('����ѡ���෽��' , 'error');
        return ;	
	}
	var SelectIndex = INSUMIGetEditRowIndexByID('edg');
	if(SelectIndex > -1){
		$('#edg').datagrid('endEdit',SelectIndex);
	}
	var TotalNum = 0;
	var SuccessNum = 0;
	var ErrorNum = 0;
	var dgRows = $('#edg').datagrid('getChanges');
	for (var rowIndex = 0; rowIndex < dgRows.length; rowIndex++) {
		var dgRow = dgRows[rowIndex];
		if(dgRow){
			TotalNum++;
			var dgSelectRowId = dgRow.ROWID || '';
			var dgSelectIndex = $('#edg').datagrid('getRowIndex',dgRow);
			$('#edg').datagrid('beginEdit',dgSelectIndex);
			var editorRow = {
				PARID: dgSelect.ROWID,
				SEQ: INSUMIDataGrid.getCellVal('edg',dgSelectIndex,'SEQ'),  
				ARGCODE: INSUMIDataGrid.getCellVal('edg',dgSelectIndex,'ARGCODE'),  
				ARGNAME: INSUMIDataGrid.getCellVal('edg',dgSelectIndex,'ARGNAME'),
				ARGTYPE: INSUMIDataGrid.getCellVal('edg',dgSelectIndex,'ARGTYPE'),  
				PARNODETYPE: INSUMIDataGrid.getCellVal('edg',dgSelectIndex,'PARNODETYPE'), 
				MAXLENG: INSUMIDataGrid.getCellVal('edg',dgSelectIndex,'MAXLENG'),
				ROWID : dgSelectRowId
			}
			$('#edg').datagrid('endEdit',dgSelectIndex);
			var InJson = JSON.stringify(editorRow);
			var rtn = $.m({ClassName: "INSU.MI.ClassMethodArgsCom", MethodName: "Save", InStr: InJson,SessionStr: session['LOGON.USERID']}, false);
			if(rtn == '0'){
				SuccessNum++;
				$('#edg').datagrid('updateRow',{
					index : dgSelectIndex,
					row: editorRow
				});
			}else{
				ErrorNum++;
			}			
		}
	}
	INSUMIAlert('���ι�����:' + TotalNum + '����' + '�ɹ�:' + SuccessNum + '��ʧ�ܣ�' + ErrorNum +'��');
	LoadEDG();
}
// ����
function AddDGRows() {
	var SelectIndex = DHCINSUGetEditRowIndexByID('dg');
	if(SelectIndex > -1 ){
		$('#dg').datagrid('endEdit', SelectIndex);	
	}
	var rows = $('#dg').datagrid('getRows');
	var  lastRows = rows.length;
	$('#dg').datagrid('appendRow',{
			CLASSNAME: '',
			METHODNAME: '',  
			METHODTYP: '',  
			METHODDESC: '',
			DEMO: '',  
			EFFTFLAG: '', 
			DATASPLIT: '', 
			OUTPUTTYPE: '', 
			MULTSPLIT: ''  
	});
	$('#dg').datagrid('beginEdit', lastRows);	
	$('#dg').datagrid('selectRow',lastRows);
}
// ����EDG
function AddEDGRows() {
	var SelectIndex = DHCINSUGetEditRowIndexByID('edg');
	if(SelectIndex > -1 ){
		$('#edg').datagrid('endEdit', SelectIndex);	
	}
	var rows = $('#edg').datagrid('getRows');
	var  lastRows = rows.length;
	$('#edg').datagrid('appendRow',{
			PARID: '',
			SEQ: '',  
			ARGCODE: '',  
			ARGNAME: '',
			ARGTYPE: '',  
			PARNODETYPE: '', 
			MAXLENG: ''
	});
	$('#edg').datagrid('beginEdit', lastRows);	
	$('#edg').datagrid('selectRow',lastRows);
}
// 
function BeginEdit(index,row){
	var rowIndex="-1";
	if(index==""){
		var dgSelected = $('#dg').datagrid('getSelected');
		if(!dgSelected){
			INSUMIAlert('��ѡ��Ҫ�༭����' , 'error');	
			return;
		}
		var SelectIndex = INSUMIGetEditRowIndexByID('dg');
		if(SelectIndex > -1 ){
			$('#dg').datagrid('endEdit',SelectIndex);
			//$.messager.alert('��ʾ', 'һ��ֻ�ܱ༭һ��','error');
    	    //return;	
		}	
		rowIndex = $('#dg').datagrid('getRowIndex',dgSelected);		
	}else{
		rowIndex=index
		var SelectIndex = INSUMIGetEditRowIndexByID('dg');
		if(SelectIndex > -1 ){
			$('#dg').datagrid('endEdit',SelectIndex);
		}		
	}	
	$('#dg').datagrid('beginEdit',rowIndex);
}
function BeginEDGEdit(index,row){
	var rowIndex="-1";
	if(index==""){
		var dgSelected = $('#edg').datagrid('getSelected');
		if(!dgSelected){
			INSUMIAlert('��ѡ��Ҫ�༭����' , 'error');	
			return;
		}
		var SelectIndex = INSUMIGetEditRowIndexByID('edg');
		if(SelectIndex > -1 ){
			$('#edg').datagrid('endEdit',SelectIndex);
			//$.messager.alert('��ʾ', 'һ��ֻ�ܱ༭һ��','error');
    	    //return;	
		}	
		rowIndex = $('#edg').datagrid('getRowIndex',dgSelected);		
	}else{
		rowIndex=index
		var SelectIndex = INSUMIGetEditRowIndexByID('edg');
		if(SelectIndex > -1 ){
			$('#edg').datagrid('endEdit',SelectIndex);
		}		
	}	
	$('#edg').datagrid('beginEdit',rowIndex);
}
function DeleteEDG(){
	var selectRow = $('#edg').datagrid('getSelected');
	if(!selectRow){
		$.messager.popover({
			msg:'��ѡ��һ����¼',
			type:'error'	
		});
		return;	
	}
	$.messager.confirm('��ʾ','�Ƿ����ɾ���ò���?',function(r){
		var rtn = $.m({ClassName: "INSU.MI.ClassMethodArgsCom", MethodName: "Delete", RowId: selectRow.ROWID}, false);
		if(rtn == '0'){
			INSUMIPOP('ɾ���ɹ�' , 'success');
		}else{
			INSUMIPOP('ɾ���ɹ�' , 'error');
		}
		LoadEDG();	
	});	
}
function DeleteDG(){
	var selectRow = $('#dg').datagrid('getSelected');
	if(!selectRow){
		$.messager.popover({
			msg:'��ѡ��һ����¼',
			type:'error'	
		});
		return;	
	}
	$.messager.confirm('��ʾ','�Ƿ����ɾ���÷����������?',function(r){
		var rtn = $.m({ClassName: "INSU.MI.ClassMethodCom", MethodName: "Delete", RowId: selectRow.ROWID}, false);
		if(rtn == '0'){
			INSUMIPOP('ɾ���ɹ�' , 'success');
		}else{
			INSUMIPOP('ɾ���ɹ�' , 'error');
		}
		LoadDG();	
	});	
}
function ClearDG(){
	$("#DGSearch").form('clear');
}
function ClearEDG(){
 	$("#EDGSearch").form('clear');	
}
