/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: 手术用药监测

var AppType="SSYY";
var url="dhcpha.clinical.action.csp";
var ItmID="";    //医嘱项ID  qunianpeng
var HospID=session['LOGON.HOSPID']
$(function(){
	
	//initScroll();//初始化显示横向滚动条
	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//科室
	$('#dept').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+HospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc')
		}
	}); 

	//病区
	$('#ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+HospID+'  ')
			//$('#ward').combobox('reload',url+'?action=SelAllWard')
		}
	});

	//登记号回车事件
	$('#patno').bind('keypress',function(event){
	    if(event.keyCode == "13")    
	    {
	        SetPatNoLength();  //登记号前补0
	    }
	});
	
    //手术类别
	$('#oper').combobox({
		onShowPanel:function(){
			$('#oper').combobox('reload',url+'?action=SelOperCateGory')
		}
	});
	
	///回车事件 wangxuejian   2016/09/19  qunianpeng 引用
	$('#phdesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var unitUrl = url+'?action=QueryArcItmDetail&hospId='+HospID+'&Input='+$('#phdesc').val(); 
			//var unitUrl =  "&Input="+$('#drug').val();
			/// 调用医嘱项列表窗口
			new ListComponentWin($('#phdesc'), "", "600px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	})	
	
		
	$('#Find').bind("click",Query); //点击查询
	
	InitPatList(); //初始化病人列表
})

///查询按钮医嘱项响应函数  2016-09-21 qunianpeng 引用
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#phdesc').focus().select();  ///设置焦点 并选中内容
		return;
	}
	$('#phdesc').val(rowObj.itmDesc);  /// 医嘱项
	ItmID=rowObj.itmID;    //获取医嘱项ID
}

ArcColumns = [[
	    {field:'itmDesc',title:'医嘱项名称',width:220},
	    {field:'itmCode',title:'医嘱项代码',width:100},
	    //{field:'itmPrice',title:'单价',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];

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
	var PatNo=$.trim($("#patno").val());;
	var OperID=$('#oper').combobox('getValue');  //手术名称 qunianpeng
	if(OperID==undefined){
		OperID=""
	}
	var phDesc=$('#phdesc').val();		//药品描述
	if(phDesc==""){			//药品描述为空时，药品ID为空
		ItmID="";		
	}
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+PatNo+"^"+AppType+"^"+OperID+"^"+ItmID+"^"+HospID;
	$('#maindg').datagrid({
		url:url+'?action=GetOperMedPatList',	
		queryParams:{
			params:params}
	});
	//$('#dg').datagrid('load',{params:params}); 
}

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:'Ward',title:'病区',width:160},
		{field:'PatNo',title:'登记号',width:120,formatter:SetCellUrl},
		{field:'InMedicare',title:'病案号',width:80,hidden:true},
		{field:'PatName',title:'姓名',width:80},
		{field:'Bed',title:'床号',width:80},
		{field:'PatSex',title:'性别',width:80},
		{field:'PatAge',title:'年龄',width:80},
		{field:'PatHeight',title:'身高',width:80},
		{field:'PatWeight',title:'体重',width:80},
		{field:'AdmLoc',title:'科室',width:160},
		{field:'AdmDoc',title:'医生',width:80},
		{field:'PatDiag',title:'诊断',width:180},
		{field:'PatInDate',title:'入院时间',width:120},
		{field:'ExpCause',title:'异常原因',width:200,formatter:showExpCause},
		{field:"AdmDr",title:'AdmDr',width:90,hidden:true}
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
	$('#maindg').datagrid('loadData',{total:0,rows:[]});  //qunianpeng  2016-09-08
}

//登记号设置连接 formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>"+value+"</a>";
}

///显示窗口 formatter="SetCellUrl"
function showWin(AdmDr)
{
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
	},'text');
	Query();  //查询
    }
}