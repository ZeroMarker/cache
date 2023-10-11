/**
 * FileName: dhcinsu/mi.portfunlist.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * Description: 国家版-医保数据上传 接口清单维护
 */
 $(function(){
	 
	 init_portlist();	
	 
	 LoadportfunlistDG(); 
	 
	 init_HOSPID();
	 
	 init_HITYPE();
	 
	 // 
	 $('#LV1TYPE').combobox({
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'LV1TYPE';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {			
		}
	});	
	 // 
	 $('#LV2TYPE').combobox({
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'LV2TYPE';
	      	param.HospDr = '';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {			
		}
	});	
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
		},
		onLoadSuccess: function (data) {
			setValueById("EFFTFLAG","Y");  			
		}
	});	
	$('#HisQueryTab .textbox').keyup(function(){
		if(event.keyCode==13){
			LoadportfunlistDG();
		}
	});
	$HUI.linkbutton("#Clean", {
		onClick: function () {
			CLear();
		}
	});
	$HUI.linkbutton("#Find", {
		onClick: function () {
			//Load_dg_DataGrid();
			LoadportfunlistDG();
		}
	});
	$HUI.linkbutton("#Save", {
		onClick: function () {
				var dgSelect = $('#portfunlistDG').datagrid('getSelected');
				var selectROWID = '';
				if(dgSelect){
					selectROWID = dgSelect.ROWID;	
				}
				if(selectROWID != ''){ // uodate
					$.messager.confirm('确认','是否继续修改数据?',function(r){		
						if(r){
							SavePortList();	
						}			
					})
				}else{ // add	
					SavePortList();
				}
		}
	});
	$HUI.linkbutton("#Del", {
		onClick: function () {
			$.messager.confirm('提示','是否继续删除',function(r){
				if(r){
					DeletePortList();
				}
				
			})
		}
	});
	// 导入
	$HUI.linkbutton("#Imp", {
		onClick: function () {
			INSUMIFileOpenWindow(import_PortList);
		}
	});
})
function init_HOSPID(){
	$('#HOSPID').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'Rowid',   
	    textField:'Desc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryHospInfo';
	     },
	    columns:[[   
	        {field:'Rowid',title:'数据ID',width:60},  
	        {field:'Desc',title:'描述',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function(){
		    $('#HITYPE').combobox('clear');
		    $('#HITYPE').combogrid('grid').datagrid('reload');
		},
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				//$('#Hospital').combogrid('grid').datagrid('selectRow',0);
		    }
		}
	}); 	
}
function init_HITYPE(){
	$('#HITYPE').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'web.INSUDicDataCom';
	      	param.QueryName = 'QueryDic1';
	      	param.Type = 'DLLType';
	      	param.HospDr = $('#HOSPID').combobox('getValue');
	     },
	    columns:[[   
	        {field:'cCode',title:'医保代码',width:60},  
	        {field:'cDesc',title:'医保描述',width:100}
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				$('#HITYPE').combogrid('grid').datagrid('selectRow',0);
		    }
		}
	}); 	
}
function init_portlist(){
	var colums = [[

		{field:'INFNO',title:'交易编号',width:100,align:'center'},
		{field:'INFNAME',title:'交易名称',width:60,align:'center'},
		{field:'LV1TYPE',title:'一级分类',width:50,align:'center',formatter:function(value, data,index){
			var rtn = GLOBAL.LV1TYPE[value] || value ;
			return rtn ;	
		}},
		{field:'LV2TYPE',title:'二级分类',width:100,formatter:function(value, data,index){
			var rtn = GLOBAL.LV2TYPE[data.LV1TYPE + value] || value;
			return rtn ;	
		}},
		{field:'CALLWAY',title:'调用方式',width:70,align:'center',formatter:function(value, data,index){
			var rtn = GLOBAL.CALLWAY[value] || value;
			return rtn ;	
		}},
		{field:'DATADESC',title:'描述',width:100,align:'center'},
		{field:'EFFTFLAG',title:'生效标志',width:100,align:'center',formatter:function(value, data,index){
			var rtn = GLOBAL.EFFTFLAG[value] || value;
			return rtn ;	
		}},
		{field:'HOSPID',title:'医院',width:100,align:'center',hidden:true},
		{field:'TYPE',title:'配置类型',width:100,align:'center',hidden:true},
		{field:'HITYPE',title:'医保类型',width:94,align:'center',hidden:true},
		{field:'NODECODE',title:'父节点代码',width:94,align:'center',hidden:true},
		{field:'VER',title:'版本号',width:100,align:'center'},
		{field:'ROWID',title:'ROWID',width:48,align:'center',hidden:true}
	]];
	$HUI.datagrid('#portfunlistDG',{
		border:true,
		fitColumns: true,
		singleSelect: true,
		data: [],
		fit:true,
		columns:colums,
		pageSize:30,
		pageList:[10,20,30,40],
		pagination:true,
		toolbar:'#TB',
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
	$('#PortCom-HOSPID').combogrid('setValue',rowData.HOSPID)
	$('#PortCom-HITYPE').combobox('clear');
	$('#PortCom-HITYPE').combogrid('setValue',rowData.HITYPE); 
	setValueById('TYPE',rowData.TYPE);
	setValueById('HITYPE',rowData.HITYPE);
	setValueById('INFNO',rowData.INFNO);
	setValueById('LV1TYPE',rowData.LV1TYPE);
	setValueById('INFNAME',rowData.INFNAME);
	setValueById('LV2TYPE',rowData.LV1TYPE+rowData.LV2TYPE);
	setValueById('CALLWAY',rowData.CALLWAY);
	setValueById('DATADESC',rowData.DATADESC);	
	setValueById('EFFTFLAG',rowData.EFFTFLAG);
	setValueById('NODECODE',rowData.NODECODE);
	setValueById('VER',rowData.VER);	
}
function LoadportfunlistDG(){
	var queryParams = {
	    ClassName : 'INSU.MI.PortFunListCom',
	    QueryName : 'QueryPortFunList',
	    ExpStr : getValueById('INFNO') + '|' + getValueById('INFNAME')
	}	
    loadDataGridStore('portfunlistDG',queryParams);				
}
function CLear(){
	$('#HITYPE').combobox('clear');
	$('#HOSPID').combobox('clear');
	setValueById('TYPE',"");
	setValueById('HITYPE',"");
	setValueById('INFNO',"");
	setValueById('INFNAME',"");
	setValueById('LV2TYPE',"");
	setValueById('CALLWAY',"");
	setValueById('DATADESC',"");	
	setValueById('EFFTFLAG',"");
	setValueById('NODECODE',"");
	setValueById('VER',"");		
	setValueById('LV1TYPE',"");		
	$('#portfunlistDG').datagrid('unselectAll');
	$('#portfunlistDG').datagrid('uncheckAll');
}
 // 保存
function SavePortList(){
	var HOSPID = $('#HOSPID').combobox('getValue');
	var TYPE = getValueById('TYPE');
	var HITYPE = $('#HITYPE').combobox('getValue'); //getValueById('HITYPE');
	var INFNO = getValueById('INFNO');
	if (INFNO==""){
		INSUMIAlert('交易编号不能为空' , 'info');
		focusById('INFNO');
		return ;
		}
	var INFNAME = getValueById('INFNAME');
	if (INFNAME==""){
		INSUMIAlert('交易名称不能为空' , 'info');
		focusById('INFNAME');
		return ;
		}
	var LV1TYPE = getValueById('LV1TYPE');
	if (LV1TYPE==""){
		INSUMIAlert('一级分类不能为空' , 'info');
		focusById('LV1TYPE');
		return ;
		}
	var LV2TYPE = getValueById('LV2TYPE').substring(1,2);
	var CALLWAY = getValueById('CALLWAY');
	var DATADESC = getValueById('DATADESC');
	var EFFTFLAG = getValueById('EFFTFLAG');
	if (EFFTFLAG==""){
		INSUMIAlert('生效标志不能为空' , 'info');
		focusById('EFFTFLAG');
		return ;
		}
	var NODECODE = getValueById('NODECODE');
	var VER = getValueById('VER');
	
	var dgSelect = $('#portfunlistDG').datagrid('getSelected');
	var selectROWID = '';
	if(dgSelect){
		selectROWID = dgSelect.ROWID;	
	}
	
	var InStr = selectROWID + '^' + HOSPID  + '^' + TYPE + '^' + HITYPE  + '^' + INFNO + '^' + INFNAME  + '^' + LV1TYPE + '^' + LV2TYPE + '^' + CALLWAY;
	InStr = InStr + '^' + DATADESC  + '^' + EFFTFLAG + '^' + NODECODE  + '^' + VER;
	
	var rtn = $.m({ClassName: "INSU.MI.PortFunListCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
	if (rtn == '0'){
		INSUMIAlert('保存成功' , 'success');
	}else{
		INSUMIAlert('保存失败：'  + rtn , 'error');
	}
	CLear();
	LoadportfunlistDG();
}
// 删除
function DeletePortList(){
	var dgSelect = $('#portfunlistDG').datagrid('getSelected');
	var RowId = '';
	if(dgSelect){
		RowId = dgSelect.ROWID;	
	}
	if (RowId == ''){
		INSUMIAlert('请选择要删除的行' , 'error');
		return;	
	}	
	var rtn = $.m({ClassName: "INSU.MI.PortFunListCom", MethodName: "Delete", RowId:RowId,}, false);
	if (rtn == '0'){
		INSUMIAlert('删除成功' , 'success');
		LoadportfunlistDG();
	}else{
		INSUMIAlert('删除失败'  + rtn , 'error');
		LoadportfunlistDG();
	}
}

