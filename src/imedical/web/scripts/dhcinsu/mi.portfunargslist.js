/**
 * FileName: dhcinsu/mi.portfunargslist.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * 2022-11-10/靳帅/UI修改
 * Description: 国家版-医保数据上传 接口清单参数维护
 */
 $(function(){
	 init_portlist();	
	 
	 LoadportfunlistDG(); 
	 
	 init_HOSPID();
	 
	 init_HITYPE();
	 
	 $('#HisQueryTab.textbox').keyup(function(){
		if(event.keyCode==13){
			LoadportfunlistDG();
		}
	});
	$("#Exp").click(InLocEpot);
})
function init_HOSPID(){
		
}
function init_HITYPE(){
		
}
function init_portlist(){
	var colums = [[

		{field:'INFNO',title:'交易编号',width:100},
		{field:'INFNAME',title:'交易名称',width:60},
		{field:'PARNODETYPE',title:'参数节点类型',width:50},
		{field:'NODECODE',title:'父节点代码',width:100},
		{field:'SEQ',title:'序号',width:100},
		{field:'ARGCODE',title:'参数代码',width:70},
		{field:'ARGNAME',title:'参数名称',width:100},
		{field:'ARGTYPE',title:'参数类型',width:100,formatter:function(value, data,index){
			var rtn = GLOBAL.ARGTYPE[value] || value ;
			return rtn ;	
		}},
		{field:'MAXLENG',title:'最大长度',width:100},
		{field:'CODEFLAG',title:'代码标识',width:100,formatter:function(value, data,index){
			var rtn = GLOBAL.CODEFLAG[value] || value ;
			return rtn ;	
		}},
		{field:'MUSTFLAG',title:'必填标志',width:94,formatter:function(value, data,index){
			var rtn = GLOBAL.MUSTFLAG[value] || value;
			return rtn ;	
		}},
		{field:'DATADESC',title:'描述',width:94},
		{field:'EFFTFLAG',title:'生效标识',width:94,formatter:function(value, data,index){
			var rtn = GLOBAL.EFFTFLAG[value] || value;
			return rtn ;	
		}},
		{field:'VER',title:'版本号',width:100},
		{field:'ROWID',title:'ROWID',width:48,hidden:true}
	]];
	$HUI.datagrid('#portfunlistDG',{
		border:false,
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
	setValueById('INFNO',rowData.INFNO);
	setValueById('INFNAME',rowData.INFNAME);
	setValueById('PARNODETYPE',rowData.PARNODETYPE);
	setValueById('NODECODE',rowData.NODECODE);
	setValueById('ARGCODE',rowData.ARGCODE);
	setValueById('ARGNAME',rowData.ARGNAME);
	setValueById('ARGTYPE',rowData.ARGTYPE);
	setValueById('CONTENTTYPE',rowData.CONTENTTYPE);	
	setValueById('MAXLENG',rowData.MAXLENG);
	setValueById('CODEFLAG',rowData.CODEFLAG);
	setValueById('MUSTFLAG',rowData.MUSTFLAG);
	setValueById('DATADESC',rowData.DATADESC);
	setValueById('EFFTFLAG',rowData.EFFTFLAG);
	setValueById('VER',rowData.VER);
	setValueById('SEQ',rowData.SEQ);	
}
function LoadportfunlistDG(){
	var ParamStr = getValueById('INFNO') + '|' + getValueById('INFNAME') + '|' + getValueById('ARGCODE') + '|' + getValueById('ARGNAME');
	var queryParams = {
	    ClassName : 'INSU.MI.PortFunArgsListCom',
	    QueryName : 'QueryPortFunArgsList',
	    ParamStr: ParamStr   
	}	
    loadDataGridStore('portfunlistDG',queryParams);				
}
$('#Find').bind('click', function () {
	LoadportfunlistDG();
});
$('#Save').bind('click', function () {
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
});
$('#Del').bind('click', function () {
	DeletePortList();
});
$('#Clean').bind('click', function () {
	setValueById('INFNO','');
	setValueById('INFNAME','');
	setValueById('PARNODETYPE','');
	setValueById('NODECODE','');
	setValueById('ARGCODE','');
	setValueById('ARGNAME','');
	setValueById('ARGTYPE','');
	setValueById('CONTENTTYPE','');	
	setValueById('MAXLENG','');
	setValueById('CODEFLAG','');
	setValueById('MUSTFLAG','');
	setValueById('DATADESC','');
	setValueById('EFFTFLAG','');
	setValueById('VER','');	
	setValueById('SEQ','');	
	$('#portfunlistDG').datagrid('unselectAll');
	$('#portfunlistDG').datagrid('uncheckAll');
});

 // 保存
function SavePortList(){
	var INFNO = getValueById('INFNO');
	var INFNAME = getValueById('INFNAME');
	var PARNODETYPE =getValueById('PARNODETYPE');
	var NODECODE= getValueById('NODECODE');
	var ARGCODE = getValueById('ARGCODE');
	var ARGNAME = getValueById('ARGNAME');
	var ARGTYPE = getValueById('ARGTYPE');
	
	var MAXLENG = getValueById('MAXLENG');
	var CODEFLAG = getValueById('CODEFLAG');
	var MUSTFLAG = getValueById('MUSTFLAG');
	var DATADESC = getValueById('DATADESC');
	var EFFTFLAG = getValueById('EFFTFLAG');
	var VER = getValueById('VER');
	var SEQ = getValueById('SEQ');
	var dgSelect = $('#portfunlistDG').datagrid('getSelected');
	var selectROWID = '';
	if(dgSelect){
		selectROWID = dgSelect.ROWID;	
	}
	var InStr = selectROWID + '^' + INFNO  + '^' + INFNAME + '^' + PARNODETYPE  + '^' + NODECODE + '^' + ARGCODE  + '^' + ARGNAME + '^' + ARGTYPE + '^' + MAXLENG;
	InStr = InStr + '^' + CODEFLAG  + '^' + MUSTFLAG + '^' + DATADESC  + '^' + EFFTFLAG + '^' + VER + '^' + SEQ;
	InStr.replace(undefined,'')
	var rtn = $.m({ClassName: "INSU.MI.PortFunArgsListCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
	if (rtn == '0'){
		INSUMIAlert('保存成功' , 'success');
	}else{
		INSUMIAlert('保存失败：'  + rtn , 'error');
	}
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
	
	$.messager.confirm('提示','是否继续删除该数据?该操作会删除对应的参数',function(r){
				if(r){
	var rtn = $.m({ClassName: "INSU.MI.PortFunArgsListCom", MethodName: "Delete", RowId:RowId,}, false);
	if (rtn == '0'){
		INSUMIAlert('删除成功' , 'success');
		LoadportfunlistDG();
	}else{
		INSUMIAlert('删除失败'  + rtn , 'error');
		LoadportfunlistDG();
	}
	
				}
				});
				
}
// 导入
$('#Imp').bind('click', function () {
	INSUMIFileOpenWindow(import_PortFunArgsList);
});
//导出  2022/10/31  靳帅1010
function InLocEpot()
{
	
	    
    var ParamStr = getValueById('INFNO') + '|' + getValueById('INFNAME') + '|' + getValueById('ARGCODE') + '|' + getValueById('ARGNAME'); 
	try
	{

	var rtn = $cm({
	dataType:'text',
	ResultSetType:"Excel",
	ExcelName:"接口清单参数维护", //默认DHCCExcel
	ClassName:"INSU.MI.PortFunArgsListCom",
	QueryName:"QueryPortFunArgsList",
    ParamStr: ParamStr   
     },false);
     location.href = rtn;
	$.messager.progress({
				title: "提示",
				msg: '接口清单参数维护',
				text: '导出中....'
			});
	setTimeout('$.messager.progress("close");', 3 * 1000);	
		
		return;
	} catch(e) {
		$.messager.alert("警告",e.message);
		$.messager.progress('close');
	};
	
	
	}
