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
	if(DateFormat=="4"){ 				//日期格式 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //当年开始日期
	}else if(DateFormat=="3"){ 			//日期格式 3:"YMD" YYYY-MM-DD
		StDate=2018+"-"+"01"+"-"+"01";  //当年开始日期
	}else if(DateFormat=="1"){ 			//日期格式 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //当年开始日期
	}
	$('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	$('#FindByLoc').bind("click",Query);  	   				    //查询
    $('#ExportByLoc').bind("click",ExportByMonths); 	 			//导出
	$("#stdate").datebox("setValue", StDate);  
	$("#enddate").datebox("setValue", EndDate); 
	$("#reqList").height($(window).height()-245)//hxy 08-28 st
	InitPatList();
});

//初始化报告列表
function InitPatList()
{
	//定义columns
	var columns=[[
	    {field:'locName',title:'上报科室',width:120},
	    {field:'oneMonNum',title:'一月',width:60},
	    {field:'TwoMonNum',title:'二月',width:60},
	    {field:'ThreeMonNum',title:'三月',width:60},
	    {field:'SpringMonNum',title:'一季度',width:60},
	    {field:'FourMonNum',title:'四月',width:60},
	    {field:'FiveMonNum',title:'五月',width:60},
	    {field:'SixMonNum',title:'六月',width:60},
	    {field:'SummerMonNum',title:'二季度',width:60},
	    {field:'SevenMonNum',title:'七月',width:60},
	    {field:'EightMonNum',title:'八月',width:60},
	    {field:'NineMonNum',title:'九月',width:60},
	    {field:'AutumnMonNum',title:'三季度',width:60},
	    {field:'TenMonNum',title:'十月',width:60},
	    {field:'ElevenMonNum',title:'十一月',width:60},
	    {field:'TwelveMonNum',title:'十二月',width:60},
	    {field:'WinterMonNum',title:'四季度',width:60},
	    {field:'TotleNum',title:'合计',width:60}
	

	]];
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	if (LocID==undefined){LocID="";}
	var StrParam=StDate +"^"+ EndDate +"^"+ LocID+"^"+LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID ; //hxy 2020-02-26 4567
  
	//定义datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',
		title:'',
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StatAllRepByLocMon'+'&StrParam='+StrParam,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  			// 每页显示的记录条数
		pageList:[40,80],   	// 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
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
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	if (LocID==undefined){LocID="";}
	var StrParam=StDate+"^"+EndDate+"^"+LocID
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StatAllRepByLocMon',	
		queryParams:{
			StrParam:StrParam}
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
 	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	if (LocID==undefined){LocID="";}
	var StrParam=StDate +"^"+ EndDate +"^"+ LocID+"^"+LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID ; //hxy 2020-02-26 4567	
	runClassMethod("web.DHCADVCOMMONPART","StatAllRepByLocMon",{"StrParam":StrParam},
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
	//alert(TemplatePath)
	xlsBook = xlsApp.Workbooks.Add();
	xlsSheet = xlsBook.ActiveSheet;
	xlsSheet.PageSetup.LeftMargin=0;  
	xlsSheet.PageSetup.RightMargin=0;
	xlsSheet.Application.Visible = true;
	
	xlsApp.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,18)).MergeCells = true;
	xlsSheet.cells(1,1).Font.Bold = true;
	xlsSheet.cells(1,1).Font.Size =18;
	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
	
	runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':LgCtLocID},function(jsonString){
		xlsSheet.cells(1,1) = jsonString;     //QQA  2016-10-16   
	},'text',false)
	xlsSheet.cells(2,1)="上报科室";  
	xlsSheet.cells(2,2)="一月";
   	xlsSheet.cells(2,3)="二月";
    xlsSheet.cells(2,4)="三月";
    xlsSheet.cells(2,5)="一季度";
    xlsSheet.cells(2,6)="四月";
    xlsSheet.cells(2,7)="五月";
    xlsSheet.cells(2,8)="六月";
    xlsSheet.cells(2,9)="二季度";
    xlsSheet.cells(2,10)="七月";
    xlsSheet.cells(2,11)="八月";
    xlsSheet.cells(2,12)="九月";
    xlsSheet.cells(2,13)="三季度";
    xlsSheet.cells(2,14)="十月";
    xlsSheet.cells(2,15)="十一月";
    xlsSheet.cells(2,16)="十二月";
    xlsSheet.cells(2,17)="四季度";
    xlsSheet.cells(2,18)="合计";
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
	succflag=xlsBook.SaveAs("按上报科室和月份查询.xls");
	xlApp.Visible=true;
     
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

function $g(){	
	if (arguments[0]== null || arguments[0]== undefined) return "" 
	return arguments[0];
}

