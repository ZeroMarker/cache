/*
住院药房退药汇总
createdate:2016-04-22
creator:yunhaibao
*/
var commonUrl = "DHCST.INPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var inciRowId="";
$(function(){
	InitDateBox(); 		//初始化日期
	InitPhaLoc(); 		//初始化药房
	InitWardList(); 	//初始化病区
	InitReturnTotalList(); //初始化列表
	$('#inciName').bind('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#inciName").val());
		 if (input!=""){
			var mydiv = new IncItmDivWindow($("#inciName"), input,getDrugList);
            mydiv.init();
		 }else{
			inciRowId="";
		 }	
	 }
	});
	$('#btnFind').bind("click",Query);  //点击查询
	$('#btnExport').bind("click",btnExportHandler); //导出
    $('#returntotalgrid').datagrid('loadData',{total:0,rows:[]});
	$('#returntotalgrid').datagrid('options').queryParams.params = "";  
});
function InitDateBox(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期	
}
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    }
	});
}
function InitWardList()
{
	$('#wardLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonUrl+'?action=GetWardLocDs',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){         
	    }
	});

}
function InitDrugList(alias)
{
		$('#inciName').combobox({
			width:370,
			panelWidth:370,    
			valueField:'RowId',  
			textField:'Desc',  
			Delay:200000, 
			url:commonUrl+'?action=GetInciListByAlias&alias='+alias   , 
			//keyHandler: {  //回车触发
			//	enter: function(){
			//		}
			//}
			//,
			onShowPanel:function(){ //下拉触发
				var inputtxt=$('#inciName').combobox("getText");
				InitDrugList(inputtxt)
			}
		});

}
function InitReturnTotalList(){
	//定义columns
	var columns=[[
		{field:"Inci",title:'Inci',hidden:true},
		{field:'inciCode',title:'药品代码',width:100},
		{field:'inciDesc',title:'药品名称',width:250},
		{field:'retQty',title:'退药数量',width:80,align:'right'},
		{field:'retUomDesc',title:'单位',width:80},
		{field:'sp',title:'售价',width:200,hidden:true},
		{field:'spAmt',title:'售价金额',width:150,align:'right'},
		{field:'rp',title:'进价',width:200,hidden:true},
		{field:'rpAmt',title:'进价金额',width:150,align:'right'},
		
	]];
	
	//定义datagrid
	$('#returntotalgrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:100,  // 每页显示的记录条数
		pageList:[100,300,500],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		selectOnCheck: true, 
		checkOnSelect: true,
		pagination:true

	});

}
function Query(){
	$('#returntotalgrid').datagrid('loadData',{total:0,rows:[]}); 
	var startDate=$('#startDate').datebox('getValue');   //起始日期
	var endDate=$('#endDate').datebox('getValue'); //截止日期
    if ($('#inciName').val()==""){inciRowId=""}
	var phaLoc=$('#phaLoc').combobox("getValue"); 
	if($.trim($('#phaLoc').combobox("getText"))==""){
		phaLoc="";
	}
	var wardLoc=$('#wardLoc').combobox("getValue");
	if($.trim($('#wardLoc').combobox("getText"))==""){
		wardLoc="";
	} 
	var params=startDate+"^"+endDate+"^"+phaLoc+"^"+wardLoc+"^"+inciRowId;
	$('#returntotalgrid').datagrid({
		url:commonUrl+'?action=jsQueryInPhaRetTotal',	
		queryParams:{
			params:params},
		onLoadSuccess: function(){
          
	    }
	});
}
function btnExportHandler(){
	ExportAllToExcel("returntotalgrid")
}
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#inciName").val(returndata["InciDesc"]);
		inciRowId=returndata["Inci"];
	}
	else{
		$("#inciName").val("");
		inciRowId="";
	}
}