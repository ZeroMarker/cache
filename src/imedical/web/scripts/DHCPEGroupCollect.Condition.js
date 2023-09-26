//DHCPEGroupCollect.Condition.js
//document.write("<object ID='DealWord' CLASSID='CLSID:8AFB3E62-E759-44BD-A661-F80787E73DCA' CODEBASE='../addins/client/DealWord.CAB#version=1,0,0,7'>");
document.write("<object ID='DealWord' CLASSID='CLSID:0C9F8A5C-C272-4BA0-9DAC-42FDF048BBC6' CODEBASE='../addins/client/DealWord.CAB#version=1,0,0,10'>");

document.write("</object>");
var Char_1="#"
var Char_2="^"

function BodyLoadHandler() 
{
	var obj=document.getElementById('QueryIll');
	if (obj){ obj.onclick=QueryIll_click; }
	
	var obj=document.getElementById("CollectReport");
	if (obj) { obj.onclick=CollectReport_click; }
	
	obj=document.getElementById("ExportReport");
	if (obj){ obj.onclick=ExportReport_click; }
	
	var obj=document.getElementById("CheckDetail");
	if (obj) { obj.onclick=CheckDetail_click; }
	
}

function CheckDetail_click()
{
	var Flag=GetGroupInfo();
	if (!Flag) return false;
	var Str="";
	var Str=parent.frames["center"].GetSelectED();
 
	/*
	var inputs = parent.frames("center").document.getElementsByTagName("input");
	for(var i=0;i<inputs.length;i++){
  		var obj = inputs[i];
  		if(obj.type=='checkbox'){
	  		if(obj.id=='AllSelect') {continue;}
	  		if(obj.checked) { Str=Str+"^"+obj.id }
	  		
  		}
	}
	alert(Str)
	if(Str!="") {Str=Str+"^"}
	*/
	var lnk="dhcpegroupcollectdetail.csp"+"?IllStr="+Str;
	var wwidth=800;
	var wheight=600;
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}


function CollectReport_click()
{
	var Flag=GetGroupInfo();
	if (!Flag) return false;
	var Str="",iReportType=""
	Str=parent.frames["center"].GetSelectED()
	/*
	var inputs = parent.frames("center").document.getElementsByTagName("input");
	for(var i=0;i<inputs.length;i++){
  		var obj = inputs[i];
  		if(obj.type=='checkbox'){
	  		if(obj.id=='AllSelect') {continue;}
	  		if(obj.checked) { Str=Str+"^"+obj.id }
	  		
  		}
	}
	*/
	var ShowDetailFlag=0;
	var obj=document.getElementById("ShowDetail");
	if (obj&&obj.checked) ShowDetailFlag=1;
	var obj=document.getElementById("ReportType");
	if (obj){ iReportType=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGroupCollect.Report"+"&IllList="+"&ReportType="+iReportType+"&ShowDetailFlag="+ShowDetailFlag;
	//alert(lnk)
	var wwidth=800;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	
}



function QueryIll_click()
{
	
	var iReportType="",iGADMDR="",iGTeam="",iDepartment="",iStartDate="",iEndDate="",iVIP="",iSex="",iAgeStart="",iAgeEnd="",iType="";
    
    //var obj=parent.document.getElementById('GList');
	//if (obj){ iGADMDR=obj.value }
    var iGADMDR=parent.frames['GList'].GList.value;
    
    var obj=document.getElementById('GTeam');
	if (obj){ iGTeam=obj.value }
	
	var obj=document.getElementById('Department');
	if (obj){ iDepartment=obj.value }
    
    var obj=document.getElementById('StartDate');
	if (obj){ iStartDate=obj.value }
	
	var obj=document.getElementById('EndDate');
	if (obj){ iEndDate=obj.value }
    
    obj=document.getElementById("VIPLevel");
	if (obj){ iVIP=obj.value; }
	
	obj=document.getElementById("Sex");
	if (obj){ iSex=obj.value; }
	
	obj=document.getElementById("AgeStart");
	if (obj){ iAgeStart=obj.value; }
	
	obj=document.getElementById("AgeEnd");
	if (obj){ iAgeEnd=obj.value; }
	
	obj=document.getElementById("Type");
	if (obj){ iType=obj.value; }
	obj=document.getElementById("ReportType");
	if (obj){ iReportType=obj.value; }
	if (parent.frames["center"]){
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGroupCollect.Illness"
		+"&GroupList="+iGADMDR+"&StartDate="+iStartDate+"&EndDate="+iEndDate+"&GTeam="+iGTeam+"&Department="+iDepartment+"&VIP="+iVIP+"&Sex="+iSex+"&AgeStart="+iAgeStart+"&AgeEnd="+iAgeEnd+"&Type="+iType+"&ReportType="+iReportType;
		parent.frames["center"].location.href=lnk;
		
		}
	
	
}

function ExportReport_click()
{
	
	var iGADMList=""
	var Flag=GetGroupInfo();
	if (!Flag) return false;
	
	var tkclass="web.DHCPE.Report.GroupCollect"

	//var obj=parent.document.getElementById('GList');
	//if (obj){ var iGADMList=obj.value }
    var iGADMList=parent.frames['GList'].GList.value;
	var ExportName=tkMakeServerCall(tkclass,"GetGName",iGADMList);
	
	var DealWord;
	
	DealWord= new ActiveXObject("WordSet.DealWord");
	
	DealWord.CreateNewWordApp("C:\\DHCPEGroupReport.doc");
	//书签内容
	var ret=tkMakeServerCall(tkclass,"GetBaseInfo");
	
	var Arr=ret.split(Char_2)
	
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		DealWord.SetTextValue(OneArr[0],OneArr[1]);
	}
	
    //第一个表格
    var TableIndex=1;
    var ret=tkMakeServerCall(tkclass,"GetSexAgeCount");
    var TableRet=Char_2+ret;
    
	DealWord.SetTableValue(TableRet,TableIndex,0);
	var ChartRet=""+Char_1+"男"+Char_1+"女"
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1]+Char_1+OneArr[3]
	}
	//数据、第几个表格、图表名称、图表类型、图表上是否显示数值（2显示 1不显示）
    DealWord.SetChart(ChartRet, TableIndex, "各年龄组性别分布情况", 51,2);
    
    //第二个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLInfo");
	var TableRet=Char_2+ret;
	
	DealWord.SetTableValue(TableRet,TableIndex,0);
	var ChartRet=""+Char_1+"疾病"
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1];
	}
	//数据、第几个表格、图表名称、图表类型、图表上是否显示数值（2显示 1不显示）
    DealWord.SetChart(ChartRet, TableIndex, "异常指标检出率", 51,2);
    
	//第三个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLHistoryInfo");
	var TableRet=Char_2+ret;
	DealWord.SetTableValue(TableRet,TableIndex,0);
	var DateInfo=tkMakeServerCall(tkclass,"GetCheckDate");
	DealWord.SetTextValue("ThisDate",DateInfo);
	var ChartRet=""+Char_1+DateInfo+Char_1+""+Char_1+""
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[2]+Char_1+OneArr[4]+Char_1+OneArr[6];
	}
	//数据、第几个表格、图表名称、图表类型、图表上是否显示数值（2显示 1不显示）
    DealWord.SetChart(ChartRet, TableIndex, "历史数据比较", 51,1);
    
	//第四个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLAgeSexMax");
	var TableRet=Char_2+ret;
	DealWord.SetTableValue(TableRet,TableIndex,0);
	//疾病分类解释
	var ret=tkMakeServerCall(tkclass,"GetAllILL");
	//alert(ret)
	var ILLArr=ret.split("^");
	for (var i=0;i<ILLArr.length;i++)
	{
		var OneILL=ILLArr[i];
		TableIndex=TableIndex+1;
		var ret=tkMakeServerCall(tkclass,"GetOneILLInfo",OneILL);
		DealWord.SetTableValue(ret,TableIndex,0);
		var Arr=ret.split(Char_2)
		var SexFlag=Arr[0];
		if (SexFlag=="N"){
			var ChartRet=""+Char_1+"男"+Char_1+"女"
		}else{
			var ChartRet=""+Char_1+"人数"
		}
		for (var j=1;j<Arr.length;j++)
		{
			var OneInfo=Arr[j];
			var OneArr=OneInfo.split(Char_1);
			if (SexFlag=="N"){
				var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1]+Char_1+OneArr[3];	
			}else{
				var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1];
			}
		}
		//数据、第几个表格、图表名称、图表类型、图表上是否显示数值（2显示 1不显示）
		DealWord.SetChart(ChartRet, TableIndex,"",51,2);
	}
	DealWord.SaveWordDoc("D:\\"+ExportName+".doc");
	DealWord.CloseWordApp();
	alert("导出完成!")
    return false;

}
function GetGroupInfo()
{
	/*
	var Str=""
	var inputs = parent.frames("center").document.getElementsByTagName("input");
	for(var i=0;i<inputs.length;i++){
  		var obj = inputs[i];
  		if(obj.type=='checkbox'){
	  		if(obj.id=='AllSelect') {continue;}
	  		if(obj.checked) { Str=Str+"^"+obj.id }
	  		
  		}
	}
	*/
	var Str=parent.frames["center"].GetSelectED()
	if(Str=="") 
	{
		alert("请先选择团体疾病与诊断");
		return false;
	}
	var tkclass="web.DHCPE.Report.GroupCollect"
	var iGADMDR="",iGTeam="",iDepartment="",iStartDate="",iEndDate="",iVIP="",iSex="",iAgeStart="",iAgeEnd="",iType="";
    
    //var obj=parent.document.getElementById('GList');
	//if (obj){ iGADMDR=obj.value; }
	var iGADMDR=parent.frames['GList'].GList.value;
  
    var obj=document.getElementById('GTeam');
	if (obj){ iGTeam=obj.value }
	
	var obj=document.getElementById('Department');
	if (obj){ iDepartment=obj.value }
    
    var obj=document.getElementById('StartDate');
	if (obj){ iStartDate=obj.value }
	
	var obj=document.getElementById('EndDate');
	if (obj){ iEndDate=obj.value }
    
    obj=document.getElementById("VIPLevel");
	if (obj){ iVIP=obj.value; }
	
	obj=document.getElementById("Sex");
	if (obj){ iSex=obj.value; }
	
	obj=document.getElementById("AgeStart");
	if (obj){ iAgeStart=obj.value; }
	
	obj=document.getElementById("AgeEnd");
	if (obj){ iAgeEnd=obj.value; }
	
	obj=document.getElementById("Type");
	if (obj){ iType=obj.value; }
    
	var ret=tkMakeServerCall(tkclass,"GetGroupInfo",iGADMDR,iGTeam,iDepartment,iStartDate,iEndDate,iVIP,1,Str,iSex,iAgeStart,iAgeEnd,iType);
	return true;
	
}

document.body.onload = BodyLoadHandler;
