/*
模块:住院药房
子模块:住院药房-发药统计
createdate:2016-06-29
creator:yunhaibao
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var thisUrl="dhcpha.inpha.dispstat.action.csp"
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gInciRowID="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'225'
}
$(function(){
	var stkGrpCombo=new ListCombobox("stkGrp",commonInPhaUrl+'?action=GetLocStkGrpDs&locId='+gLocId,'',combooption);
	stkGrpCombo.init(); //初始化类组
	var dispTypeCombo=new ListCombobox("dispType",commonInPhaUrl+'?action=GetLocDispTypeDs&locId='+gLocId,'',combooption);
	dispTypeCombo.init(); //初始化发药类别
	InitPhaLoc();
	InitDispWardGrid(); //初始化病区grid
	InitDispStatGrid(); //初始化发药统计明细
	InitCondition();
	$('#inciDesc').bind('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#inciDesc").val());
		 if (input!="")
		 {
			var mydiv = new IncItmDivWindow($("#inciDesc"), input,getDrugList);
            mydiv.init();
		 }else{
			gInciRowID="";
		 }	
	 }
	});
	$('#chkWard').on('click', function(){
		if ($('#chkWard').is(':checked')){
			$('#chkLoc').attr('checked',false); 
		}else{
			$('#chkLoc').attr('checked',true); 
		}
	});
	$('#chkLoc').on('click', function(){
		if ($('#chkLoc').is(':checked')){
			$('#chkWard').attr('checked',false); 
		}else{
			$('#chkWard').attr('checked',true);
		}
	});
	$('#btnClear').on('click', InitCondition);//点击清空
	$('#btnFind').on('click', btnFindHandler);//点击统计
	$('#btnFindSum').on('click', btnFindSumHandler);//点击统计明细
	$('#btnPrint').on('click', btnPrintHandler);//点击打印明细
});
 //初始化条件
function InitCondition(){
	gInciRowID="";
	$("#inciDesc").val("");
	$("#startDate").datebox("setValue", formatDate(0));  
	$("#endDate").datebox("setValue", formatDate(0));  
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$('#stkGrp').combobox("setValue","");
	$('#dispType').combobox("setValue","");
	$('#phaLoc').combobox("setValue",gLocId);
	$('#dispstatgrid').datagrid('loadData',{total:0,rows:[]});
	$('#dispstatgrid').datagrid('options').queryParams.params = ""; 
	$('#dispwardgrid').datagrid('loadData',{total:0,rows:[]});
	$('#dispwardgrid').datagrid('options').queryParams.params = ""; 
}
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    },
	    onSelect:function(){
		    var selectLoc=$('#phaLoc').combobox("getValue")
	        $('#stkGrp').combobox('reload',commonInPhaUrl+'?action=GetLocStkGrpDs&locId='+selectLoc);           
	        $('#dispType').combobox('reload',commonInPhaUrl+'?action=GetLocDispTypeDs&locId='+selectLoc);           
		}

	});
}

function InitDispWardGrid(){
	//定义columns
	var columns=[
		{field:"ProcessID",title:'ProcessID',width:80,hidden:true},
		{field:"AdmLocRowid",title:'AdmLocRowid',width:80,hidden:true},
		{field:"TSelect",checkbox:true},
		{field:"AdmLocDesc",title:'科室',width:250,sortable:true}									
	];
	//定义datagrid
	$('#dispwardgrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		nowrap:false,
		columns:[columns],
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize:999,  // 每页显示的记录条数
		pageList:[999],  // 可以设置每页记录条数的列表
	    onBeforeLoad:function(param){
			KillTmpBeforeLoad();
		}
	});
}

function InitDispStatGrid(){
	//定义columns
	var columns=[[
		{field:"PID",title:'PID',width:50,hidden:true},
		{field:"AdmLocID",title:'AdmLocID',width:50,hidden:true},
		{field:"Tinci",title:'Tinci',width:100,hidden:true},
		{field:"DispItmCode",title:'药品代码',width:75,sortable:true},
		{field:"DispItmDesc",title:'药品名称',width:220},
		{field:"DispQty",title:'发药数量',width:60,align:'right',sortable:true},		
		{field:"RetQty",title:'退药数量',width:60,align:'right',sortable:true},	
		{field:"Total",title:'合计数量',width:60,align:'right',sortable:true},	
		{field:"Uom",title:'单位',width:60},
		{field:"TPhciPrice",title:'单价',width:75,align:'right',sortable:true},		
		{field:"Amount",title:'金额',width:100,align:'right',sortable:true},
		{field:"TBarCode",title:'规格',width:80},		
		{field:"TManf",title:'厂家',width:120},	
		{field:"TPhcfDesc",title:'剂型',width:100},	
		{field:"Tward",title:'病区',width:150},	
		{field:"Tgeneric",title:'通用名',width:100,hidden:true},
		{field:"TTotalUom",title:'数量(单位)',width:100,hidden:true}						
	]];
	//定义datagrid
	$('#dispstatgrid').datagrid({
		border:false,
		url:'', //thisUrl+'?action=jsQueryDispList',
		fit:true,
		//rownumbers:true,
		nowrap:false,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//chectOnCheck: true, 
		//checkOnSelect: true,
		pageSize:100,  // 每页显示的记录条数
		pageList:[100,300,500],   // 可以设置每页记录条数的列表
		pagination:true,
		onRowContextMenu: onRowContextMenu, //[表头(tab)右键onHeaderContextMenu,树形(tree)右键onContextMenu]
	    onBeforeLoad:function(param){
		//	KillTmpBeforeLoad();
		}
	});
	//initScroll("#dispstatgrid"); //此初始化会导致默认行数是1
}
////添加右击菜单内容
function onRowContextMenu(e, rowIndex, rowData){
   e.preventDefault();
    $('#rightmenu').menu('show', {
        left:e.pageX,
        top:e.pageY
    });       
}
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#inciDesc").val(returndata["InciDesc"]);
		gInciRowId=returndata["Inci"];
	}
	else{
		$("#inciDesc").val("");
		gInciRowId="";
	}
}
function btnFindHandler(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('提示',"请输入开始日期!","info");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('提示',"请输入开始日期!","info");
		return;
	}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var phaLoc=$('#phaLoc').combobox("getValue")
	if (($.trim($('#phaLoc').combobox("getText"))=="")||(phaLoc==undefined)){
		phaLoc="";
		$.messager.alert('提示',"药房不允许为空!","info");
		return;
	}
	var stkGrp=$('#stkGrp').combobox("getValue")
	if (($.trim($('#stkGrp').combobox("getText"))=="")||(stkGrp==undefined)){
		stkGrp="";
	}
	var dispType=$('#dispType').combobox("getValue")
	if (($.trim($('#dispType').combobox("getText"))=="")||(dispType==undefined)){
		dispType="";
	}
	if ($.trim($("#inciDesc").val())==""){
		gInciRowId="";
	}
	var statFlag=""
	if ($('#chkWard').is(':checked')){
		statFlag="1"
	}
	if ($('#chkLoc').is(':checked')){
		statFlag="0"
	}
	$('#dispstatgrid').datagrid('loadData',{total:0,rows:[]});
	$('#dispstatgrid').datagrid('options').queryParams.params = ""; 
	var phcCat="",includeDisp="",patNo=""
	var params=startDate+"^"+endDate+"^"+phaLoc+"^"+dispType+"^"+startTime
		  +"^"+endTime+"^"+gInciRowId+"^"+statFlag+"^"+phcCat+"^"+includeDisp
		  +"^"+patNo+"^"+stkGrp
	$('#dispwardgrid').datagrid({
		url:thisUrl+'?action=QueryDispStat',	
		queryParams:{
			params:params}
	});
}
 //查询选择病区的发药统计明细
function btnFindSumHandler(){
	var dispwardgridrowsdata=$('#dispwardgrid').datagrid("getRows");
	var dispwardgridrows=dispwardgridrowsdata.length;
	if (dispwardgridrows<=0){
		$.messager.alert('提示',"无选择数据!","info");
		return;
	}
	var checkedItems = $('#dispwardgrid').datagrid('getChecked');
	if ((checkedItems==null)||(checkedItems=="")){
		$.messager.alert('提示',"请勾选需要统计的科室!","info");
		return;
	}
	var admLocStr="",pid="";	
	$.each(checkedItems, function(index, item){
		if (admLocStr==""){
			admLocStr=item.AdmLocRowid;
		}else{
			admLocStr=admLocStr+"^"+item.AdmLocRowid;
		}
		pid=item.ProcessID
	});
	var params=pid+","+admLocStr;
	$('#dispstatgrid').datagrid({
		url:thisUrl+'?action=QueryDispStatDetail',	
		queryParams:{
			params:params}
	});
}
//导出
function ExportClick(){
	ExportAllToExcel("dispstatgrid")
}
//打印
function btnPrintHandler(){
	if ($('#dispstatgrid').datagrid('getData').rows.length == 0){
		$.messager.alert("提示","页面没有数据","info");
		return ;
	}
	var statgridOption=$("#dispstatgrid").datagrid("options")
	var statgridParams=statgridOption.queryParams.params;
	var statgridUrl=statgridOption.url;
	$.ajax({
		type: "GET",
		url: statgridUrl+"&page=1&rows=9999&params="+statgridParams,
		async:false,
		dataType: "json",
		success: function(returndata){
			PrintDispStat(returndata);
		}
	});

}
function PrintDispStat(returndata){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//获取模板路径
	var locdesc=$("#phaLoc").combobox("getText");
	if (locdesc.indexOf("-")>0){
		locdesc=locdesc.split("-")[1];
	}
	var tmpjsonObject = JSON.stringify(returndata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length;
	var datestart = $('#startDate').datebox('getValue');
	var dateend = $('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook;
	var Template;
	Template = path + "DHCSTP_PhaDispStat_ZYD.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var startRow=3,cols=11,h=1,j=0;
	for (var i=0;i<rows;i++){
		var itmdesc=colarray[i].DispItmDesc;
		var dispqty=colarray[i].DispQty;
		var retqty=colarray[i].RetQty;
		var totalqty=colarray[i].Total;
		var uom=colarray[i].Uom;
		var amt=colarray[i].Amount;
		var rPhcfDesc=colarray[i].TPhcfDesc;
		var rmanf=colarray[i].TManf;
		var BarCode=colarray[i].TBarCode;
		var phciprice=colarray[i].TPhciPrice;
		var ward=colarray[i].Tward;
		var TotalQtyUom=colarray[i].TTotalUom;
		if ((tmpward!=ward)&&($.trim(ward)!="")){
			startRow=startRow+4
		    xlsheet.Cells(i+startRow-2,1).Value="病区:"+ward+"   "+"开始日期:"+datestart+" "+"   "+"结束日期:"+dateend
			xlsheet.Cells(i+startRow-1,1).Value="序号"
			xlsheet.Cells(i+startRow-1,2).Value="药品名称"
			xlsheet.Cells(i+startRow-1,3).Value="规格"
			xlsheet.Cells(i+startRow-1,4).Value="剂型"
			xlsheet.Cells(i+startRow-1,5).Value="厂家"
			xlsheet.Cells(i+startRow-1,6).Value="单位"
			xlsheet.Cells(i+startRow-1,7).Value="发药数量"
			xlsheet.Cells(i+startRow-1,8).Value="退药数量"
			xlsheet.Cells(i+startRow-1,9).Value="合计数量"
			xlsheet.Cells(i+startRow-1,10).Value="药品单价"
			xlsheet.Cells(i+startRow-1,11).Value="药品金额"
			for (j=1;j<=cols;j++){ 
  		       xlsheet.Cells(i+startRow-1,j).Borders(9).LineStyle = 1;    
       	       xlsheet.Cells(i+startRow-1,j).Borders(7).LineStyle = 1;    
      	       xlsheet.Cells(i+startRow-1,j).Borders(10).LineStyle = 1;   
       	       xlsheet.Cells(i+startRow-1,j).Borders(8).LineStyle = 1;    
 	       	   xlApp.ActiveSheet.Cells(i+startRow-1,j).HorizontalAlignment = 3;
   	        }
			h=1
		}		
		for (j=1;j<=cols;j++){ 
  
	       xlsheet.Cells(i+startRow,j).Borders(9).LineStyle = 1;    
   	       xlsheet.Cells(i+startRow,j).Borders(7).LineStyle = 1;    
  	       xlsheet.Cells(i+startRow,j).Borders(10).LineStyle = 1;   
   	       xlsheet.Cells(i+startRow,j).Borders(8).LineStyle = 1;    
       	   xlApp.ActiveSheet.Cells(i+startRow,j).HorizontalAlignment = 3;
        }
	    var tmpitm=itmdesc.split("(")
		itmdesc=tmpitm[0];
		xlsheet.Cells(i+startRow,1).Value=h  //编号
		xlsheet.Cells(i+startRow,2).Value=itmdesc;
		xlsheet.Cells(i+startRow,3).Value=BarCode;
		xlsheet.Cells(i+startRow,4).Value=rPhcfDesc;
		xlsheet.Cells(i+startRow,5).Value=rmanf;
		xlsheet.Cells(i+startRow,6).Value=uom;
		xlsheet.Cells(i+startRow,7).Value=dispqty;
		xlsheet.Cells(i+startRow,8).Value=retqty;
		xlsheet.Cells(i+startRow,9).Value=TotalQtyUom;
		xlsheet.Cells(i+startRow,10).Value=phciprice;
		xlsheet.Cells(i+startRow,11).Value=amt;		
		var tmpward=ward
		h=h+1
    }
	xlsheet.printout
    xlBook.Close(savechanges = false);
    xlApp = null;
    xlsheet = null
}

function KillTmpBeforeLoad(){
	var dispwardgridrowsdata=$('#dispwardgrid').datagrid("getRows");
	var dispwardgridrows=dispwardgridrowsdata.length;
	if (dispwardgridrows>0){
		var selecteddata=$('#dispwardgrid').datagrid('getData').rows[0];
		var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillCollTmpGlobal","","",selecteddata["ProcessID"])
	}
}
window.onbeforeunload = function (){
	KillTmpBeforeLoad();
}
