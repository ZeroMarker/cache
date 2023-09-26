/*
模块:门诊药房
子模块:门诊药房-首页-侧菜单-门诊打印标签用法维护
createdate:2016-06-24
creator:yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.instruction.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'200'
} 
$(function(){
	var instruCombo=new ListCombobox("instru",commonOutPhaUrl+'?action=GetInstuDs','',combooption);
	instruCombo.init(); //初始化用法
	InitInstruGrid();	
	$('#instructiongrid').datagrid('reload');
	$('#btnDelete').bind('click',btnDeleteHandler);//点击删除
	$('#btnAdd').bind('click', btnAddHandler);//点击增加
});
//初始化grid
function InitInstruGrid(){
	//定义columns
	var columns=[[
        {field:'TLocDesc',title:'药房名称',width:300},
        {field:'TYFDesc',title:'用法',width:300},
        {field:'TYFID',title:'TYFID',width:200,hidden:true},
        {field:'yfcodeid',title:'yfcodeid',width:200,hidden:true}
	]];  
	
   //定义datagrid	
   $('#instructiongrid').datagrid({    
        url:url+'?action=QueryLocInstruction',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    striped:true,
        columns:columns,
        pageSize:50,  // 每页显示的记录条数
	    pageList:[50,100,300],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true  
   });
}
///增加
function btnAddHandler()
{
	var instru=$("#instru").combobox('getValue');
	var instrudesc=$("#instru").combobox('getText')
	if  ($.trim(instrudesc)==""){
		instu="";
		$.messager.alert('提示',"请选择用法!","info");
		return;		
	}
	if (instru==undefined){
		$.messager.alert('提示',"请选择正确用法,选择后不允许手动修改文字!","info");
		return;	
	}
    var returnValue= tkMakeServerCall("PHA.OP.CfPrtLab.OperTab","Insert",gLocId,instru,instrudesc);
    if(returnValue==-1){
	    $.messager.alert('提示',"该用法在本药房已维护!","info");
	    return;
    }else{
	    $('#instructiongrid').datagrid('reload');
    }
}


///删除
function btnDeleteHandler(){
	var seletcted = $("#instructiongrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('提示',"请先选择需要删除的记录!","info");
		return;
	}
	var yfcodeid=seletcted["yfcodeid"];
	$.messager.confirm('提示',"确认删除吗？",function(r){
		if(r){
			var retValue=tkMakeServerCall("PHA.OP.CfPrtLab.OperTab","Delete",gLocId,yfcodeid);
			if(retValue==0){
				$('#instructiongrid').datagrid('reload');
			}
			else{
				$.messager.alert('提示',"删除失败,错误代码:"+retValue,"error");
			}
		}
	});
}
