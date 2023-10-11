/**
 * FileName: dhcinsu/mi.portargsdic.js
 * Anchor: tangzf
 * Date: 2021-02-02
 *2022-11-10/靳帅/UI修改
 * Description: 国家版-数据元字典配置
 */
 $(function(){
	 init_portargsdicDG();
	 
	 // 发布状态	
	 $("#PUBLISHSTATUS").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	        {text:'草稿',id:'0',selected:true},
	        {text:'审核',id:'1'},
	        {text:'发布',id:'2'}
	    ],
	    onClick:function(v){
			LoadportargsdicDG();    
		}
	});
	 // 参数类型
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
	 // 必填标识 
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
	 // 有效标识
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
				$.messager.confirm('确认','是否继续[修改]代码为:' + dgSelect.CONTENTCODE +'的数据?',function(r){		
					if(r){
						SavePortList();	
					}			
				})
			}else{ // add
				$.messager.confirm('确认','是否继续[新增]数据?',function(r){		
					if(r){
						SavePortList();	
					}			
				})	
			}
		}
	});
	// 导入
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
// 分词
function BuildSplitWords(){
		
}
function init_portargsdicDG(){
	var colums = [[
		{field:'ck',title:'ck',width:220, checkbox:true},
		{field:'CONTENTCODE',title:'参数代码',width:140},
		{field:'CONTENTNAME',title:'参数名称',width:140},
		{field:'CONTENTTYPE',title:'参数类型',width:140,formatter:function(value, data,index){
				var rtn = GLOBAL.CONTENTTYPE[value] || value;
				return rtn ;	
			}
		},
		{field:'CONTENTLENG',title:'参数长度',width:140},
		{field:'CONTENTDICFLAG',title:'代码标志',width:140},
		{field:'MUSTFLAG',title:'必填标志',width:140,formatter:function(value, data,index){
				var rtn = GLOBAL.MUSTFLAG[value] || value;
				return rtn ;	
			}},
		{field:'EFFTFLAG',title:'生效标志',width:140,formatter:function(value, data,index){
				var rtn = GLOBAL.EFFTFLAG[value] || value;
				return rtn ;	
			}},
		{field:'VER',title:'版本号',width:108},
		{field:'PUBLISHSTATUS',title:'发布状态',width:130,formatter:function(value, data,index){
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
			$('#Save').linkbutton({text:'修改'});
		},
		onUnselect:function(rowIndex, rowData){
			var checkedRows = $('#portargsdicDG').datagrid('getChecked');
			if (checkedRows.length == '0'){
				$('#Save').linkbutton({text:'新增'});
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
	$('#Save').linkbutton({text:'新增'});
}
 // 保存
function SavePortList(){
	var PUBLISHSTATUS = '0'; // 只能新增草稿状态的数据
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
		INSUMIAlert('保存成功' , 'success');
	}else{
		INSUMIAlert('保存失败：'  + rtn , 'error');
	}
	LoadportargsdicDG();
}
// 删除
function DeletePortList(){
	var dgSelect = $('#portargsdicDG').datagrid('getSelected');
	var RowId = '';
	if(dgSelect){
		RowId = dgSelect.ROWID;	
	}
	if (RowId == ''){
		INSUMIAlert('请选择要删除的行' , 'error');
		return;	
	}
	$.messager.confirm('提示','是否继续删除该数据?该操作会删除对应的参数',function(r){
				if(r){	
	var rtn = $.m({ClassName: "INSU.MI.PortArgsDicCom", MethodName: "Delete", RowId:RowId,}, false);
	if (rtn == '0'){
		INSUMIAlert('删除成功' , 'success');
		LoadportargsdicDG();
	}else{
		INSUMIAlert('删除失败'  + rtn , 'error');
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
		INSUMIAlert('没有需要操作的数据' , 'info');
		return;
	}
	for (var i = 0; i <= checkedRows.length - 1; i++) {
		RowIdStr = RowIdStr + '^' + checkedRows[i].ROWID; 
	}
	var rtn = $.m({ClassName: "INSU.MI.PortArgsDicCom", MethodName: "UpdatePublishStatusById", Status:type,RowIdStr:RowIdStr,User:session['LOGON.USERID']}, false);
	if (rtn == '0'){
		$.messager.alert('提示','操作成功' , 'success',function(){
			LoadportargsdicDG();
		});
	}else{
		$.messager.alert('提示','操作失败' + rtn , 'error',function(){
			//LoadportargsdicDG();
		});
	}	
}
