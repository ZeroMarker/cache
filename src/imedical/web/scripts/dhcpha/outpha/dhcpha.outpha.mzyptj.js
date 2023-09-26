/*
模块:门诊药房
子模块:门诊药房-药房统计-麻醉药品处方统计
createdate:2016-07-04
creator:dinghongying
*/
var commonOutPhaUrl ="DHCST.OUTPHA.ACTION.csp";
var thisurl = "dhcpha.outpha.mzyptj.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitMZYPTJList();
	var stkCatCombo=new ListCombobox("stkCat",commonOutPhaUrl+'?action=GetStkCatDs','',combooption);
	stkCatCombo.init(); //初始化库存分类
	combooption.required='true'
	var poisonCatCombo=new ListCombobox("poisonCat",commonOutPhaUrl+'?action=GetPoisonCatDs','',combooption);
	poisonCatCombo.init(); //初始化管制分类

	$('#BReset').on('click', Reset);//点击清空
	$('#BRetrieve').on('click', Query);//点击统计
	$('#BExport').on('click', function(){  //点击导出
		ExportAllToExcel("mzyptjdg")
	});
	$('#mzyptjdg').datagrid('loadData',{total:0,rows:[]});
	$('#mzyptjdg').datagrid('options').queryParams.params = ""; 
	
});
//初始化麻醉药品处方统计列表
function InitMZYPTJList(){
	//定义columns
	var columns=[[
	    {field:'TPhDate',title:'日期',width:80},
	    {field:'TPmiNo',title:'登记号',width:100},
	    {field:'TPatName',title:'姓名',width:80},
	    {field:'TPatSex',title:'性别',width:40,align:'center'},
	    {field:'TPatAge',title:'年龄',width:50,align:'center'},
	    {field:'TPatSN',title:'身份证号',width:150,align:'center'},
	    {field:'TMR',title:'诊断',width:200},
	    {field:'TPrescNo',title:'处方号',width:100,align:'center'},
	    {field:'TPhDesc',title:'药品名称',width:200},
	    {field:'TPhQty',title:'数量',width:60,align:'right'},
	    {field:'TPhUom',title:'单位',width:60},
	   	{field:'TPhMoney',title:'金额',width:60,align:'right'},
	    {field:'TIncBatCode',title:'批号',width:100},
	    {field:'TYF',title:'用法',width:80},
	    {field:'TPatLoc',title:'科别',width:120},
	    {field:'TDoctor',title:'医生',width:80},
	    {field:'TFYUser',title:'发药人',width:80},
	    {field:'TBZ',title:'备注',width:100}
	]];  
    //定义datagrid	
    $('#mzyptjdg').datagrid({    
        url:thisurl+'?action=GetMZYPTJList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    nowrap:false,
        columns:columns,
        pageSize:50,  // 每页显示的记录条数
	    pageList:[50,100,300,500],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onLoadError:function(data){
			$.messager.alert("错误","加载数据失败,请查看错误日志!","warning")
			$('#mzyptjdg').datagrid('loadData',{total:0,rows:[]});
			$('#mzyptjdg').datagrid('options').queryParams.params = ""; 
		}
    });
}
///麻醉药品处方统计清空
function Reset(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期
	$("#stkCat").combobox("setValue", "");  //Init库存分类
	$("#poisonCat").combobox("setValue", "");  //Init管制分类
	$('#mzyptjdg').datagrid('loadData',{total:0,rows:[]});
	$('#mzyptjdg').datagrid('options').queryParams.params = ""; 
}
///麻醉药品处方统计查询
function Query(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('提示',"请输入开始日期!","info");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('提示',"请输入截止日期!","info");
		return;
	}
	var stkCatId=$("#stkCat").combobox("getValue");
	if (($.trim($("#stkCat").combobox("getText"))=="")||(stkCatId==undefined)){
		stkCatId="";
	}
	var regCatId=$("#poisonCat").combobox("getValue");
	if (($.trim($("#poisonCat").combobox("getText"))=="")||(stkCatId==undefined)){
		$.messager.alert('提示',"管制分类为必填项!","info");
		return;
	}
	var params=startDate+"^"+endDate+"^"+gLocId+"^"+stkCatId+"^"+regCatId
	$('#mzyptjdg').datagrid({
		url:thisurl+'?action=GetMZYPTJList',
     	queryParams:{
			params:params}
	});	
}

