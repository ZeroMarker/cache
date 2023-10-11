/**
  *creator：guoguoming
  *date:2019-06-17
  *
 **/
var StDate="";  			
var EndDate=formatDate(0);  //系统的当前日期
var StrParam="";
var url = "dhcadv.repaction.csp";
$(function(){ 
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageButton();         /// 界面按钮控制
	InitPageDataGrid();		  /// 初始化页面datagrid
});
// 初始化界面控件内容
function InitPageComponent()
{
	var myDate = new Date();
    var yearArr = [];//创建年度数组-近10年
    for(year= parseInt(myDate.getFullYear())-10;year<=parseInt(myDate.getFullYear());year++)
	{
		yearArr.push({"value":year,"text":year});
	}
	//加载下拉框
	$("#year").combobox({
		data:yearArr,
        valueField:'value',
        textField:'text'
    });
    $("#year").combobox("setValue", myDate.getFullYear()); 
	$('#dept').combobox({ 
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	$("#reqList").height($(window).height()-245);
}
// 初始化界面按钮内容
function InitPageButton()
{
	$('#FindByLoc').bind("click",Query);  //查询
    $('#ExportByLoc').bind("click",ExportByMonths); //导出
}

//初始化报告列表
function InitPageDataGrid()
{
	//定义columns
	var columns=[[
	    {field:'locName',title:$g('上报科室'),width:120},
	    {field:'oneMonNum',title:$g('一月'),width:60},
	    {field:'TwoMonNum',title:$g('二月'),width:60},
	    {field:'ThreeMonNum',title:$g('三月'),width:60},
	    {field:'SpringMonNum',title:$g('一季度'),width:60},
	    {field:'FourMonNum',title:$g('四月'),width:60},
	    {field:'FiveMonNum',title:$g('五月'),width:60},
	    {field:'SixMonNum',title:$g('六月'),width:60},
	    {field:'SummerMonNum',title:$g('二季度'),width:60},
	    {field:'SevenMonNum',title:$g('七月'),width:60},
	    {field:'EightMonNum',title:$g('八月'),width:60},
	    {field:'NineMonNum',title:$g('九月'),width:60},
	    {field:'AutumnMonNum',title:$g('三季度'),width:60},
	    {field:'TenMonNum',title:$g('十月'),width:60},
	    {field:'ElevenMonNum',title:$g('十一月'),width:60},
	    {field:'TwelveMonNum',title:$g('十二月'),width:60},
	    {field:'WinterMonNum',title:$g('四季度'),width:60},
	    {field:'TotleNum',title:$g('合计'),width:60}
	

	]];
  
	//定义datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',
		title:'',
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StatAllRepByLocMon'+'&StrParam='+StrParam+'&LgParam='+LgParam,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  			// 每页显示的记录条数
		pageList:[40,80],   	// 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		nowrap:false,
		//height:300,
		rowStyler:function(index,row){
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        }  
    	}
	});
	if(StrParam==""){
		Query();
	}
	//initScroll("#maindg");//初始化显示横向滚动条
}

function Query()
{
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	var Year= $("#year").combobox("getValue") ; //年份
	var LocID=$('#dept').combobox('getValue');     //科室ID
	if (LocID==undefined){LocID="";}
	var StrParam=Year+"^"+ LocID ; 
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StatAllRepByLocMon',	
		queryParams:{
			StrParam:StrParam,
			LgParam:LgParam}
	});
}

///回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
// 导出Excel
function ExportByMonths()
{	
	var strjLen=0; 
 	var strjData="";
 	var Year= $("#year").combobox("getValue") ; //年份
	var LocID=$('#dept').combobox('getValue');     //科室ID
	if (LocID==undefined){LocID="";}
	var StrParam=Year+"^"+ LocID+"^"+LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID ; //hxy 2020-02-26 4567	
	runClassMethod("web.DHCADVCOMMONPART","StatAllRepByLocMon",{"StrParam":StrParam,"LgParam":LgParam},
	function(data){ 
		strjData=data.rows;
		strjLen=data.total;
	},'json',false)
	
	var TemplatePath="";
	var xlsApp,xlsSheet,xlsBook;
	runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
		TemplatePath = jsonString;
	},'',false)
	
	xlsApp = new ActiveXObject("Excel.Application");
	xlsBook = xlsApp.Workbooks.Add();
	xlsSheet = xlsBook.ActiveSheet;
	xlsSheet.PageSetup.LeftMargin=0;  
	xlsSheet.PageSetup.RightMargin=0;
	xlsSheet.Application.Visible = true;
	
	xlsApp.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,18)).MergeCells = true;
	xlsSheet.cells(1,1).Font.Bold = true;
	xlsSheet.cells(1,1).Font.Size =18;
	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
	
	xlsSheet.cells(1,1) = LgHospDesc;     
	xlsSheet.cells(2,1)=$g("上报科室");  
	xlsSheet.cells(2,2)=$g("一月");
   	xlsSheet.cells(2,3)=$g("二月");
    xlsSheet.cells(2,4)=$g("三月");
    xlsSheet.cells(2,5)=$g("一季度");
    xlsSheet.cells(2,6)=$g("四月");
    xlsSheet.cells(2,7)=$g("五月");
    xlsSheet.cells(2,8)=$g("六月");
    xlsSheet.cells(2,9)=$g("二季度");
    xlsSheet.cells(2,10)=$g("七月");
    xlsSheet.cells(2,11)=$g("八月");
    xlsSheet.cells(2,12)=$g("九月");
    xlsSheet.cells(2,13)=$g("三季度");
    xlsSheet.cells(2,14)=$g("十月");
    xlsSheet.cells(2,15)=$g("十一月");
    xlsSheet.cells(2,16)=$g("十二月");
    xlsSheet.cells(2,17)=$g("四季度");
    xlsSheet.cells(2,18)=$g("合计");
    for (i=1;i<=strjLen;i++)
    { 
    
	    xlsSheet.cells(i+2,1)=strjData[i-1].locName;
		xlsSheet.cells(i+2,2)="'"+strjData[i-1].oneMonNum;
	    xlsSheet.cells(i+2,3)="'"+strjData[i-1].TwoMonNum;
	    xlsSheet.cells(i+2,4)="'"+strjData[i-1].ThreeMonNum;
	    xlsSheet.cells(i+2,5)="'"+strjData[i-1].SpringMonNum;
	    xlsSheet.cells(i+2,6)="'"+strjData[i-1].FourMonNum;
	    xlsSheet.cells(i+2,7)="'"+strjData[i-1].FiveMonNum;
	    xlsSheet.cells(i+2,8)="'"+strjData[i-1].SixMonNum; 
	    xlsSheet.cells(i+2,9)="'"+strjData[i-1].SummerMonNum; 
	    xlsSheet.cells(i+2,10)="'"+strjData[i-1].SevenMonNum; 
	    xlsSheet.cells(i+2,11)="'"+strjData[i-1].EightMonNum;
	    xlsSheet.cells(i+2,12)="'"+strjData[i-1].NineMonNum;
	    xlsSheet.cells(i+2,13)="'"+strjData[i-1].AutumnMonNum; 
	    xlsSheet.cells(i+2,14)="'"+strjData[i-1].TenMonNum
	    xlsSheet.cells(i+2,15)="'"+strjData[i-1].ElevenMonNum
	    xlsSheet.cells(i+2,16)="'"+strjData[i-1].TwelveMonNum;
	    xlsSheet.cells(i+2,17)="'"+strjData[i-1].WinterMonNum;
	    xlsSheet.cells(i+2,18)="'"+strjData[i-1].TotleNum;	   
	    
 	 }
	xlsSheet.Columns.AutoFit; 
	succflag=xlsBook.SaveAs(Year+"年按上报科室和月份查询.xls");
	xlsApp.Visible=true;
     
	xlsBook=null; 
	xlsSheet=null;
	return succflag; 
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

