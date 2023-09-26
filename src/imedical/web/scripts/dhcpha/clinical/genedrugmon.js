
/// Creator: bianshuai
/// CreateDate: 2014-08-31
/// Descript: 药物基因监测

var AppType="JYJC";
var url="dhcpha.clinical.action.csp";
var HospID=session['LOGON.HOSPID']
$(function(){
	
	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//科室
	$('#dept').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+HospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc')
		}
		//panelHeight:"auto",  //设置容器高度自动增长
		//url:url+'?actiontype=SelAllLoc' 
	}); 

	//病区
	$('#ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+HospID+'  ')
			//$('#ward').combobox('reload',url+'?action=SelAllWard')
		}
		//panelHeight:"auto",  //设置容器高度自动增长
		//url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID'] 
	});
	
	//登记号回车事件
	$('#patno').bind('keypress',function(event){
	    if(event.keyCode == "13")    
	    {
	        SetPatNoLength();  //登记号前补0
	    }
	});

   	//检验项目
	$('#labitm').combobox({
		onShowPanel:function(){
			$('#labitm').combobox('reload',url+'?action=SelMonItemByTheme&Theme='+AppType)
		},	
		panelHeight:"auto"  //设置容器高度自动增长

	});
	
	InitPatList(); //初始化病人信息列表
	
	$('#Find').bind('click',function(){
		Query();
	})
})

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:'Ward',title:'病区',width:160},
		{field:'PatNo',title:'登记号',width:80,formatter:SetCellUrl},
		{field:'PatName',title:'姓名',width:80},
		{field:'Bed',title:'床号',width:80},
		{field:'PatSex',title:'性别',width:80},
		{field:'PatAge',title:'年龄',width:80},
		{field:'PatHeight',title:'身高',width:80},
		{field:'PatWeight',title:'体重',width:80},
		{field:'AdmLoc',title:'科室',width:120},
		{field:'AdmDoc',title:'主管医师',width:80},
		{field:'PatDiag',title:'诊断',width:180},
		{field:'PatInDate',title:'入院时间',width:80},
		{field:'ExpCause',title:'异常原因',width:200,formatter:showExpCause},
		{field:"AdmDr",title:'AdmDr',width:90}
	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		title:'病人列表',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	initScroll("#maindg");//初始化显示横向滚动条
        $('#maindg').datagrid('loadData', {total:0,rows:[]});
}

//查询
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue'); //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue'); //科室ID
	var WardID=$('#ward').combobox('getValue'); //病区ID
	if (LocID== undefined){LocID="";}
	if (WardID== undefined){WardID="";}
	var LabItm=$('#labitm').combobox('getValue');  //检验项目
	if (LabItm== undefined){LabItm="";}
	var PatNo=$.trim($("#patno").val());;
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+PatNo+"^"+AppType+"^"+LabItm+"^"+HospID;

	$('#maindg').datagrid({
		url:url+'?action=QueryPhaGenPatList',	
		queryParams:{
			params:params}
	});
	//$('#dg').datagrid('load',{params:params}); 
}
        
//设置列颜色  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if((value>"0")||(value="↑")){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

//登记号设置连接 formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex){
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>"+value+"</a>";
}

///显示窗口 formatter="SetCellUrl"
function showWin(AdmDr){
	createPatInfoWin(AdmDr); //调用窗体 createPatInfoWin.js
}

/// 异常指标显示样式
function showExpCause(value,rowData,rowIndex){
	
	var html = '<span style="color:red;font-weight:bold;">'+ value +'</span>';
	return html;
}

//取登记号长度，不足时补0
function SetPatNoLength()
{
	var PatNo=$('#patno').val();
	if(PatNo!=""){
	$.post(url+'?action=GetPatRegNoLen',function(PatNoLen){
		var PLen=PatNo.length; //输入登记号的长度
		for (i=1;i<=PatNoLen-PLen;i++)
		{
			PatNo="0"+PatNo; 
		}
		$('#patno').val(PatNo); //赋值
		Query();  //查询
	},'text');
	}

}