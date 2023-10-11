/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: 用药预警监测

var HospID = "";
var AppType="ADR";
var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
var HospID=session['LOGON.HOSPID']
var monItmArrList="";
$(function(){

	//initScroll();//初始化显示横向滚动条
	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//科室
	$('#dept').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#dept').combobox('reload',url+'&action=GetAllLocNewVersion&hospId='+HospID+'  ')
			//$('#dept').combobox('reload',url+'&action=SelAllLoc&HospID='+HospID)
		}
	}); 

	//病区
	$('#ward').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#ward').combobox('reload',url+'&action=GetAllWardNewVersion&hospId='+HospID+'  ')
			//$('#ward').combobox('reload',url+'&action=SelAllWard')
		}
	});

	//监测项目
	$('#monitem').combobox({
		onShowPanel:function(){
			$('#monitem').combobox('reload',url+'&action=SelMonItemByTheme&Theme='+AppType)
		},	
		panelHeight:"auto"  //设置容器高度自动增长
	});
	
	//登记号回车事件
	$("#patno").bind('keypress',function(event){
        if(event.keyCode == "13"){
			SetPatNoLength();	 
	     	Query();
           }
    });
	
	
	var phdesccolumns=[[
		{field:'ck',checkbox:true,resize:false},
		{field:'Desc',title:$g('描述'),width:380}, 
		{field:'RowID',title:'rowid',width:50},
		{field:'Type',title:$g('类型'),width:50},
	]];
	
	$('#phdesc').combogrid({ 
		url:'', 
		valueField:'RowID',
		panelWidth:440,
		idField:'RowID',
		textField:'Desc',
		//fitColumns: true,  
		multiple:true,
		columns:phdesccolumns,
		onShowPanel: function(){
            var monItmID=$('#monitem').combobox('getValue'); //监测项目
            //重新加载  
            $('#phdesc').combogrid("grid").datagrid({
	            url:url+'&action=FunLibSubTheItm',
				queryParams:{
					page:1,
					rows:30,
					monItmID:monItmID}
            })
		}
	});
	
	InitPatList(); //初始化病人列表

	$('#Find').bind("click",Query); //点击查询
})

//查询
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var WardID=$('#ward').combobox('getValue');    //病区ID
	var PatNo=$.trim($("#patno").val());           //病人登记号
	var MonItem=$('#monitem').combobox('getValue'); //监测项目
	var params=StDate+"^"+EndDate+"^"+trsUndefinedToEmpty(WardID)+"^"+trsUndefinedToEmpty(LocID)+"^"+PatNo+"^"+AppType+"^"+trsUndefinedToEmpty(MonItem)+"^"+""+"^"+""+"^"+HospID;

	$('#maindg').datagrid({
		url:url+'&action=GetUntoEffectPatList',	
		queryParams:{
			params:params}
	});
}

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:'Ward',title:$g('病区'),width:160},
		{field:'PatNo',title:$g('登记号'),width:80,formatter:SetCellUrl},
		{field:'InMedicare',title:$g('病案号'),width:80,hidden:true},
		{field:'PatName',title:$g('姓名'),width:80},
		{field:'Bed',title:$g('床号'),width:80},
		{field:'PatSex',title:$g('性别'),width:80},
		{field:'PatAge',title:$g('年龄'),width:80},
		{field:'PatHeight',title:$g('身高'),width:80},
		{field:'PatWeight',title:$g('体重'),width:80},
		{field:'AdmLoc',title:$g('科室'),width:160},
		{field:'AdmDoc',title:$g('医生'),width:80},
		{field:'PatDiag',title:$g('诊断'),width:180},
		{field:'PatInDate',title:$g('入院时间'),width:120},
		{field:'ExpCause',title:$g('异常原因'),width:200,formatter:showExpCause},
		{field:"AdmDr",title:'AdmDr',width:90}
	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		title:$g('病人列表'),
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true
	});
	
	initScroll("#maindg");//初始化显示横向滚动条
	$('#maindg').datagrid('loadData',{total:0,rows:[]});  //qunianpeng 2016-09-08
}

//登记号设置连接 formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>"+value+"</a>";
}

/// 异常指标显示样式
function showExpCause(value,rowData,rowIndex){
	
	var html = '<span style="color:red;font-weight:bold;">'+ value +'</span>';
	return html;
}

///显示窗口 formatter="SetCellUrl"
function showWin(AdmDr)
{
	createPatInfoWin(AdmDr); //调用窗体 createPatInfoWin.js
}


//登记号位数不足时，补零    qunianpeng 2016-11-21 
function SetPatNoLength(){	
	var PatientNo=$('#patno').val();    //登记号
	if(PatientNo!=""){
	var PatLen=PatientNo.length;			
	if(PatLen<10)     //登记号长度为10位
	{
		for (i=1;i<=10-PatLen;i++)
		{
			PatientNo="0"+PatientNo; 
		}
	}
	$('#patno').val(PatientNo);
	}
}

//未填项默认为空  //qunianpeng 2016/11/23
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}