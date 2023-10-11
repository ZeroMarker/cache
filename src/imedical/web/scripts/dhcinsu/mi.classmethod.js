/**
 * FileName: dhcinsu/mi.classmethod.js
 * Anchor: tangzf
 * Date: 2021-04-20
 * Description: 国家版-医保数据上传 类方法维护
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
	//回车事件
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
				msg:'请先选择方法',
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

//确认并保存数据
function Update(){
	var dg = $('#dg').datagrid('getSelected');
	if(dg ){
		if( dg){
			
		}
	}
	var AdmType =  getValueById('AdmType');
	var ParentId = AdmType == "IP" ? dg.Arrcp : dg.PrtRowID;
  	$.messager.confirm('提示', '是否继续提交修改信息？', function (r) {
		if (r) {
	    	var SQLCODE = tkMakeServerCall("BILL.COM.ModifyINVPayMode", "InsertPayMode", insertStr , session['LOGON.USERID'],AdmType,ParentId);
	    	if(SQLCODE=='0'){
		    	$.messager.popover({
					msg:'提交成功',
					type:'success'	
				});	
		    }else{
			   $.messager.popover({
					msg:'提交失败',
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
 * Description: 查询面板回车事件
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
			{field:'CLASSNAME',title:'类名',width:150,editor:{
				type: 'text'
			}},
			{field:'METHODNAME',title:'方法名',width:150,editor:{
				type: 'text'
			}},
			{field:'METHODTYP',title:'方法类型',width:80,editor:{
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
			{field:'METHODDESC',title:'方法描述',width:100,editor:{
				type: 'text'
			}},
			{field:'DEMO',title:'备注',width:150,editor:{
				type: 'text'
			}},
			{field:'EFFTFLAG',title:'生效标志',width:120,editor:{
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
			{field:'MULTSPLIT',title:'出参多行分隔符',width:100,editor:{
				type: 'text'
			}},
			{field:'DATASPLIT',title:'数据分割符',width:100,editor:{
				type: 'text'
			}},
			{field:'OUTPUTTYPE',title:'返回值类型',width:120,editor:{
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
			{field:'SEQ',title:'序号',width:110,editor:{
				type: 'text'
			}},
			{field:'ARGCODE',title:'参数代码',width:120,editor:{
				type: 'text'
			}},
			{field:'ARGNAME',title:'参数名称',width:110,editor:{
				type: 'text'
			}},
			{field:'ARGTYPE',title:'参数类型',width:100,editor:{
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
			{field:'PARNODETYPE',title:'入出参类型',width:150,editor:{
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
			{field:'MAXLENG',title:'最大长度',width:120,editor:{
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
// 保存单行
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
	INSUMIAlert('本次共保存:' + TotalNum + '条，' + '成功:' + SuccessNum + '，失败：' + ErrorNum +'条');
	LoadDG();
}
// 保存
function SaveSingleEDG(){
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		INSUMIAlert('请先选择类方法' , 'error');
        return ;	
	}
	if(!dgSelect.ROWID){
		INSUMIAlert('请先选择类方法' , 'error');
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
	INSUMIAlert('本次共保存:' + TotalNum + '条，' + '成功:' + SuccessNum + '，失败：' + ErrorNum +'条');
	LoadEDG();
}
// 新增
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
// 新增EDG
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
			INSUMIAlert('请选择要编辑的行' , 'error');	
			return;
		}
		var SelectIndex = INSUMIGetEditRowIndexByID('dg');
		if(SelectIndex > -1 ){
			$('#dg').datagrid('endEdit',SelectIndex);
			//$.messager.alert('提示', '一次只能编辑一行','error');
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
			INSUMIAlert('请选择要编辑的行' , 'error');	
			return;
		}
		var SelectIndex = INSUMIGetEditRowIndexByID('edg');
		if(SelectIndex > -1 ){
			$('#edg').datagrid('endEdit',SelectIndex);
			//$.messager.alert('提示', '一次只能编辑一行','error');
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
			msg:'请选择一条记录',
			type:'error'	
		});
		return;	
	}
	$.messager.confirm('提示','是否继续删除该参数?',function(r){
		var rtn = $.m({ClassName: "INSU.MI.ClassMethodArgsCom", MethodName: "Delete", RowId: selectRow.ROWID}, false);
		if(rtn == '0'){
			INSUMIPOP('删除成功' , 'success');
		}else{
			INSUMIPOP('删除成功' , 'error');
		}
		LoadEDG();	
	});	
}
function DeleteDG(){
	var selectRow = $('#dg').datagrid('getSelected');
	if(!selectRow){
		$.messager.popover({
			msg:'请选择一条记录',
			type:'error'	
		});
		return;	
	}
	$.messager.confirm('提示','是否继续删除该方法及其参数?',function(r){
		var rtn = $.m({ClassName: "INSU.MI.ClassMethodCom", MethodName: "Delete", RowId: selectRow.ROWID}, false);
		if(rtn == '0'){
			INSUMIPOP('删除成功' , 'success');
		}else{
			INSUMIPOP('删除成功' , 'error');
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
