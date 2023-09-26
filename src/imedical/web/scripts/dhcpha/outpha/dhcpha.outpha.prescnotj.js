/*
模块:门诊药房
子模块:门诊药房-药房统计-处方统计
createdate:2016-06-30
creator:dinghongying
*/
var commonOutPhaUrl ="DHCST.OUTPHA.ACTION.csp";
var thisurl = "dhcpha.outpha.prescnotj.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gNewCatId="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitPrescnoTJList();
	var stkCatCombo=new ListCombobox("stkCat",commonOutPhaUrl+'?action=GetStkCatDs','',combooption);
	stkCatCombo.init(); //初始化库存分类
	$('#phcCatLink').bind('click',function(event){
		var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatId,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
		if (!(retstr)){
			return;
		}   
		if (retstr==""){
			return;
		}
		var phacstr=retstr.split("^")
		$("#phcCat").val(phacstr[0]);
		gNewCatId=phacstr[1];
	});	
	$('#BReset').on('click', Reset);//点击清空
	$('#BRetrieve').on('click', Query);//点击统计
	$('#BPrint').on('click', Print);//点击打印
	$('#BExport').on('click', function(){  //点击导出
		ExportAllToExcel("prescnotjdg")
	});
	$('#prescnotjdg').datagrid('loadData',{total:0,rows:[]});
	$('#prescnotjdg').datagrid('options').queryParams.params = ""; 
	
});
//初始化处方统计列表
function InitPrescnoTJList(){
	//定义columns
	var columns=[[
	    {field:'TPrescType',title:'处方类型',width:100},
	    {field:'TPrescNum',title:'处方数量',width:100,align:'right'},
	    {field:'TPrescTotal',title:'处方总数',width:100,align:'right'},
	    {field:'TPrescBL',title:'处方比率(%)',width:80,align:'right'},
	    {field:'TPrescMax',title:'最高处方',width:100,hidden:true},
	    {field:'TPrescMin',title:'最低处方',width:100,hidden:true},
	    {field:'TPrescMaxPmi',title:'最高方登记号',width:100,align:'center'},
	    {field:'TPrescMinPmi',title:'最低方登记号',width:100,align:'center'},
	    {field:'TPrescMaxMoney',title:'最高方金额',width:80,align:'right'},
	    {field:'TPrescMinMoney',title:'最低方金额',width:80,align:'right'},
	    {field:'TPrescMoney',title:'合计金额',width:100,align:'right'},
	    {field:'TPrescPhNum',title:'品种数',width:80,align:'right'},
	    {field:'TCYFS',title:'草药付数',width:80,align:'right'},
	    {field:'TJYFS',title:'煎药付数',width:80,align:'right'},
	    {field:'TJYCF',title:'煎药处方',width:80,align:'right'}
	]];  
    //定义datagrid	
    $('#prescnotjdg').datagrid({    
        url:thisurl+'?action=GetPrescnoTJList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:30,  // 每页显示的记录条数
	    pageList:[30,50,100],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true
    });
}
///药房处方统计清空
function Reset(){
	gNewCatId="";
	$("#startDate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$("#phNum").val("");  //Init药品种数
	$("#stkCat").combobox("setValue", "");  //Init库存分类
	$("#phcCat").val("");  //Init药理分类
	$('#chkOP').attr("checked",false);
	$('#chkEM').attr("checked",false);
	$('#prescnotjdg').datagrid('loadData',{total:0,rows:[]}); 
	$('#prescnotjdg').datagrid('options').queryParams.params = ""; 

}
///药房处方统计查询
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
	var prescType=""; //没用呢
	if ($.trim($("#phcCat").val())==""){
		gNewCatId="";
	}
	var stkCatId=$("#stkCat").combobox("getValue");
	if (($.trim($("#stkCat").combobox("getText"))=="")||(stkCatId==undefined)){
		stkCatId="";
	}
	var OPFlag=""
	if ($('#chkOP').is(':checked')){
		OPFlag="Y"
	}
	var EMFlag=""
	if ($('#chkEM').is(':checked')){
		EMFlag="Y"
	}
	if ((OPFlag=="")&&(EMFlag=="")){
		$.messager.alert('提示',"请勾选需要统计的门急诊处方类型!","info");
		return;
	}
	var phNum=$('#phNum').val();
	var params=startDate+"^"+endDate+"^"+startTime+"^"+endTime+"^"+gLocId+"^"+prescType+"^"+phNum+"^"+stkCatId+"^"+gNewCatId+"^"+OPFlag+"^"+EMFlag
	$('#prescnotjdg').datagrid({
		url:thisurl+'?action=GetPrescnoTJList',
     	queryParams:{
			params:params}
	});	
}

function Print(){	
	if($('#prescnotjdg').datagrid('getData').rows.length == 0) //获取当面界面数据行数
	{
		alert("页面没有数据");
		return ;
	}
	var PrescNotjdgOption=$("#prescnotjdg").datagrid("options")
	var PrescNotjdgparams=PrescNotjdgOption.queryParams.params;
	var PrescNotjdgUrl=PrescNotjdgOption.url;
	$.ajax({
		type: "GET",
		url: PrescNotjdgUrl+"&page=1&rows=9999&params="+PrescNotjdgparams,
		async:false,
		dataType: "json",
		success: function(prescnotjdata){
			PrintPrescNotj(prescnotjdata);
		}
	});
}
	
function PrintPrescNotj(prescnotjdata){
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");//获取模板路径
	var tmpjsonObject = JSON.stringify(prescnotjdata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var rows=colarray.length
	var datestart = $('#startDate').datebox('getValue');
	var dateend = $('#endDate').datebox('getValue');
	var xlApp,obook,osheet,xlsheet,xlBook
	var Template
	Template = path + "yfcftj.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	xlsheet.cells(2,1).value = " 统计日期:"+datestart + "至" +dateend
	var colnum=13;
	xlsheet.Range(xlsheet.Cells(3, 1), xlsheet.Cells(3+rows, colnum)).Borders(1).LineStyle=1 ;
	xlsheet.Range(xlsheet.Cells(3, 1), xlsheet.Cells(3+rows, colnum)).Borders(2).LineStyle=1 ;
	xlsheet.Range(xlsheet.Cells(3, 1), xlsheet.Cells(3+rows, colnum)).Borders(3).LineStyle=1 ;
	xlsheet.Range(xlsheet.Cells(3, 1), xlsheet.Cells(3+rows, colnum)).Borders(4).LineStyle=1 ;
	for (i = 0; i < rows; i++) {
		xlsheet.cells(4 + i, 1).value = colarray[i].TPrescType
		xlsheet.cells(4 + i, 2).value = colarray[i].TPrescNum
		xlsheet.cells(4 + i, 3).value = colarray[i].TPrescTotal
		xlsheet.cells(4 + i, 4).value = colarray[i].TPrescBL
		xlsheet.cells(4 + i, 5).value = colarray[i].TPrescMaxPmi
		xlsheet.cells(4 + i, 6).value = colarray[i].TPrescMinPmi
		xlsheet.cells(4 + i, 7).value = colarray[i].TPrescMaxMoney
		xlsheet.cells(4 + i, 8).value = colarray[i].TPrescMinMoney
		xlsheet.cells(4 + i, 9).value = colarray[i].TPrescMoney
		xlsheet.cells(4 + i, 10).value = colarray[i].TPrescPhNum
		xlsheet.cells(4 + i, 11).value = colarray[i].TCYFS
		xlsheet.cells(4 + i, 12).value = colarray[i].TJYFS
		xlsheet.cells(4 + i, 13).value = colarray[i].TJYCF
    }
	xlsheet.printout
    xlBook.Close(savechanges = false);
    xlApp = null;
    xlsheet = null
}