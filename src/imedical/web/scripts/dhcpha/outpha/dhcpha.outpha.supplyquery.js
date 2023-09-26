/*
模块:门诊药房
子模块:门诊药房-日常业务-基数药补货单查询
createdate:2016-07-05
creator:dinghongying
*/
var commonOutPhaUrl ="DHCST.OUTPHA.ACTION.csp";
var commonInPhaUrl ="DHCST.INPHA.ACTION.csp";
var thisurl = "dhcpha.outpha.supplyquery.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitSupplyQueryList();
	InitSupplyQueryTotalList();
	InitPhaLoc();
	//var wardLocCombo=new ListCombobox("wardLoc",commonInPhaUrl+'?action=GetWardLocDs','',combooption);
	//wardLocCombo.init(); //初始化病区
    var basicLocCombo=new ListCombobox("basicLoc",commonOutPhaUrl+'?action=GetBasicLocList','',combooption);
	basicLocCombo.init(); //初始化基数科室
	
	$('#BClear').on('click', Reset);//点击清空
	$('#BFind').on('click', Query);//点击统计
	$('#BPrint').on('click', Print)  //点击打印
		
	$('#supplyquerydg').datagrid('loadData',{total:0,rows:[]});
	$('#supplyquerydg').datagrid('options').queryParams.params = "";
	$('#supplyquerytotaldg').datagrid('loadData',{total:0,rows:[]});
	$('#supplyquerytotaldg').datagrid('options').queryParams.params = ""; 
	
});
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:150,
		panelWidth: 150,
		url:commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    },
	    onSelect:function(){  
		}
	});
}
//初始化基数药补货单列表
function InitSupplyQueryList(){
	//定义columns
	var columns=[[
	    {field:'Tward',title:'病区',width:60,align:'left',hidden:true},
	    {field:'Tdocloc',title:'基数科室',width:150,align:'left'},
	    {field:'Tsuppdate',title:'日期',width:80,align:'right'},
	    {field:'Tsupptime',title:'时间',width:70,align:'right'},
	    {field:'Tusername',title:'操作人',width:100,align:'left'},
	    {field:'Tsuppno',title:'单号',width:150},
	    {field:'Tsupp',title:'',width:60,align:'center',hidden:true},
	    {field:'Tpid',title:'pid',width:60,align:'center',hidden:true}
	    //{field:'TSelect',title:'选择',width:60,align:'center'}
	]];  
    //定义datagrid	
    $('#supplyquerydg').datagrid({    
        url:thisurl+'?action=GetSupplyQueryList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:10,  // 每页显示的记录条数
	    pageList:[10,30,50],   // 可以设置每页记录条数的列表
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onSelect:function(rowIndex,rowData){
		    QuerySub();
	    }
    });
    
}
//初始化基数药补货单汇总列表
function InitSupplyQueryTotalList(){
	//定义columns
	var columns=[[
	    {field:'Tincicode',title:'药品代码',width:100},
	    {field:'Tincidesc',title:'药品名称',width:300},
	    {field:'Tspec',title:'规格',width:135},
	    {field:'Tqty',title:'发药数量',width:100,align:'right'}
	    
	]];  
    //定义datagrid	
    $('#supplyquerytotaldg').datagrid({    
        url:thisurl+'?action=GetSupplyQueryTotalList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:50,  // 每页显示的记录条数
	    pageList:[50,100,300],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true
    });
}
///基数药补货单清空
function Reset(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	//$("#wardLoc").combobox("setValue", "");  //Init病区
	$("#basicLoc").combobox("setValue", "");  //Init基数科室
	$("#dispNo").val(""); 
	//$("#OutFlag").attr('checked',false);  //Init门诊标志
	//$("#InFlag").attr('checked',false);  //Init住院标志
	$('#supplyquerydg').datagrid('loadData',{total:0,rows:[]});
	$('#supplyquerydg').datagrid('options').queryParams.params = ""; 
	$('#supplyquerytotaldg').datagrid('loadData',{total:0,rows:[]});
	$('#supplyquerytotaldg').datagrid('options').queryParams.params = ""; 

}
///基数药补货单查询
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
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var DispLocId=$("#phaLoc").combobox("getValue");
	if (($.trim($("#phaLoc").combobox("getText"))=="")||(DispLocId==undefined)){
		DispLocId="";
		$.messager.alert('提示',"请选择药房!","info");
		return;
	}
	var WardId="" //$("#wardLoc").combobox("getValue");
	//if (($.trim($("#wardLoc").combobox("getText"))=="")||(WardId==undefined)){
	//	WardId="";
	//}
	var DoctorLocId=$("#basicLoc").combobox("getValue");
	if (($.trim($("#basicLoc").combobox("getText"))=="")||(DoctorLocId==undefined)){
		DoctorLocId="";
	}
	var DispNo=$("#dispNo").val();
	var OutFlag="1"
	var InFlag="0"
	/*
	if ($('#OutFlag').is(':checked')){
		OutFlag=1 
	}
	else{
		OutFlag=0
	}
	var InFlag=""
	if ($('#InFlag').is(':checked')){
		InFlag=1 
	}
	else{
		InFlag=0
	}
	if ((OutFlag=="")&&(InFlag=="")){
		$.messager.alert('提示',"请勾选需要查询的门诊住院类型!","info");
		return;
	}*/
	var PamStr=OutFlag+"^"+InFlag;
	var params=startDate+"#"+endDate+"#"+DispLocId+"#"+WardId+"#"+startTime+"#"+endTime+"#"+DoctorLocId+"#"+DispNo+"#"+PamStr
	$('#supplyquerydg').datagrid({
		url:thisurl+'?action=GetSupplyQueryList',
     	queryParams:{
			params:params}
	});	
}
///基数药补货单汇总查询
function QuerySub(){
	var selecteddata = $('#supplyquerydg').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var pid=selecteddata["Tpid"]
	var supp=selecteddata["Tsupp"]
	var params=pid+"^"+supp
	$('#supplyquerytotaldg').datagrid({
		url:thisurl+'?action=GetSupplyQueryTotalList',
     	queryParams:{
			params:params}
	});	
}
///基数药补货单打印
function Print(){	
	if($('#supplyquerydg').datagrid('getData').rows.length == 0) //获取当前界面数据行数
	{
		$.messager.alert("提示","页面没有数据","info");
		return ;
	}
	if($('#supplyquerydg').datagrid('getSelected') == null) {
		$.messager.alert("提示","请选择需要打印的行!","info");
		return ;
	}
	if($('#supplyquerytotaldg').datagrid('getData').rows.length == 0) //获取当前界面数据行数
	{
		$.messager.alert("提示","页面没有数据","info");
		return ;
	}
	var SupplyQueryTotaldgOption=$("#supplyquerytotaldg").datagrid("options")
	var SupplyQueryTotaldgparams=SupplyQueryTotaldgOption.queryParams.params;
	var SupplyQueryTotaldgUrl=SupplyQueryTotaldgOption.url;
	$.ajax({
		type: "GET",
		url: SupplyQueryTotaldgUrl+"&page=1&rows=9999&params="+SupplyQueryTotaldgparams,
		async:false,
		dataType: "json",
		success: function(supplyquerytotaldata){
			PrintSupplyQueryTotal(supplyquerytotaldata);
		}
	});
}
	
function PrintSupplyQueryTotal(supplyquerytotaldata){
	var supplyselect=$('#supplyquerydg').datagrid('getSelected');
	var warddesc=supplyselect["Tward"];
	var phalocdesc=$("#phaLoc").combobox("getText");
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//获取模板路径
	var tmpjsonObject = JSON.stringify(supplyquerytotaldata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length
	var xlApp,obook,osheet,xlsheet,xlBook
	var Template
	Template = path + "STP_DSY_BJXH.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.Cells(2, 1).Value = "发药科室:"+phalocdesc + " 病区:"+warddesc+ " 日期:"+getPrintDateTime()+ " 打印人:"+session['LOGON.USERNAME'];
	setBottomLine(xlsheet,3,1,3);
	for (i = 0; i < rows; i++) {
		setBottomLine(xlsheet,4+i,1,3);
		xlsheet.cells(4 + i, 1).value = colarray[i].Tincidesc
		xlsheet.cells(4 + i, 2).value = colarray[i].Tspec
		xlsheet.cells(4 + i, 3).value = colarray[i].Tqty
    }
	xlsheet.printout
    xlBook.Close(savechanges = false);
    xlApp = null;
    xlsheet = null
}