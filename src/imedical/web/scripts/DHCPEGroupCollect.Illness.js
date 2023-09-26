
var Char_1="#"
var Char_2="^"
function BodyLoadHandler() 
{
	var obj
	obj=document.getElementById("ExportReport");
	if (obj){ obj.onclick=ExportReport_click; }
	
	var obj=document.getElementById("AllSelect");
	//if (obj) { obj.onchange=SelectAll; }
	if (obj) { obj.onclick=SelectAll; }
	
	var obj=document.getElementById("CheckDetail");
	if (obj) { obj.onclick=CheckDetail_click; }
	
	
	var obj=document.getElementById("CollectReport");
	if (obj) { obj.onclick=CollectReport_click; }
	
}


function CollectReport_click()
{
	var Str=""
	
	var inputs = document.getElementsByTagName("input");
	for(var i=0;i<inputs.length;i++){
  		var obj = inputs[i];
  		if(obj.type=='checkbox'){
	  		if(obj.id=='AllSelect') {continue;}
	  		if(obj.checked) { Str=Str+"^"+obj.id }
	  		
  		}
	}
	if(Str!="") {Str=Str+"^"}
	
	var tkclass="web.DHCPE.Report.GroupCollect"
    var iGADMDR="";
    obj=document.getElementById("GroupList");
	if (obj){ iGADMDR=obj.value; }
    
	var ret=tkMakeServerCall(tkclass,"GetGroupInfo",iGADMDR,"","","","","","",Str);
	
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGroupCollect.Report"+"&IllList="+Str;
	var wwidth=800;
	var wheight=650;
	
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	
}

function CheckDetail_click()
{
	var Str=""
	var inputs = document.getElementsByTagName("input");
	for(var i=0;i<inputs.length;i++){
  		var obj = inputs[i];
  		if(obj.type=='checkbox'){
	  		if(obj.id=='AllSelect') {continue;}
	  		if(obj.checked) { Str=Str+"^"+obj.id }
	  		
  		}
	}
	
	var lnk="dhcpegroupcollectdetail.csp"+"?IllStr="+Str;
	var wwidth=1250;
	var wheight=650;
	
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}

function SelectAll()
{
	var Allobj=document.getElementById("AllSelect");
	var inputs = document.getElementsByTagName("input");
	for(var i=0;i<inputs.length;i++){
  		var obj = inputs[i];
  		if(obj.type=='checkbox'){
	  		
	  		if(obj.name=='ILL') {
		  		obj.checked=Allobj.checked;
		  		SetSelectED(obj)
		  	}
	  		
  		}
	}
}


function ExportReport_click()
{
	var Str=""
	var inputs = document.getElementsByTagName("input");
	for(var i=0;i<inputs.length;i++){
  		var obj = inputs[i];
  		if(obj.type=='checkbox'){
	  		if(obj.id=='AllSelect') {continue;}
	  		if(obj.checked) { Str=Str+"^"+obj.id }
	  		
  		}
	}
	if(Str!="") {Str=Str+"^"}
	
	
	var DealWord;
    var tkclass="web.DHCPE.Report.GroupCollect"
    var iGADMDR="";
    obj=document.getElementById("GroupList");
	if (obj){ iGADMDR=obj.value; }
    
	var ret=tkMakeServerCall(tkclass,"GetGroupInfo",iGADMDR,"","","","","","",Str);
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
	
    DealWord.SetChart(ChartRet, TableIndex, "各年龄组性别分布情况", 51);
    
    //第二个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLInfo");
	var TableRet=Char_2+ret;
	
	DealWord.SetTableValue(TableRet,TableIndex,1);
	var ChartRet=""+Char_1+"疾病"
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1];
	}
    DealWord.SetChart(ChartRet, TableIndex, "异常指标检出率", 51);
    
	//第三个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLHistoryInfo");
	var TableRet=Char_2+ret;
	DealWord.SetTableValue(TableRet,TableIndex,0);
	var ChartRet=""+Char_1+"本次"+Char_1+"上次"+Char_1+"再上次"
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[2]+Char_1+OneArr[4]+Char_1+OneArr[6];
	}
    DealWord.SetChart(ChartRet, TableIndex, "历史数据比较", 51);
    
	//第四个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLAgeSexMax");
	var TableRet=Char_2+ret;
	DealWord.SetTableValue(TableRet,TableIndex,0);
	/*
	//疾病分类解释
	var ret=tkMakeServerCall(tkclass,"GetAllILL");
	var ILLArr=ret.split("^");
	for (var i=0;i<ILLArr.length;i++)
	{
		var OneILL=ILLArr[i];
		TableIndex=TableIndex+1;
		var ret=tkMakeServerCall(tkclass,"GetOneILLInfo",OneILL);
		DealWord.SetTableValue(ret,TableIndex);
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
		DealWord.SetChart(ChartRet, TableIndex);
	}
	*/
	DealWord.SaveWordDoc("D:\\Test.doc");
	DealWord.CloseWordApp();
	alert("导出完成!")
    return false;

}
function SetSelectED(e)
{
	var IllnessID=e.id;
	var ObjArr=document.getElementsByName(IllnessID);
	for (var i=0;i<ObjArr.length;i++)
	{
		ObjArr[i].checked=e.checked;
	}
}
function GetSelectED()
{
	var IllObj=document.getElementsByName("ILL");
	var Strs=""
	var IllLength=IllObj.length;
	for (var i=0;i<IllLength;i++)
	{
		var IllID=IllObj[i].id;
		var EDObj=document.getElementsByName(IllID);
		var EDlength=EDObj.length;
		var HadFlag=0;
		var OneStr="";
		for (var j=1;j<EDlength;j++)
		{
			if (!EDObj[j].checked) continue;
			if (HadFlag==0) OneStr=IllID
			HadFlag=1;
			var EDDesc=EDObj[j].id;
			OneStr=OneStr+"$"+EDDesc;
			
		}
		if (OneStr!=""){
			if (Strs==""){
				Strs=OneStr;
			}else{
				Strs=Strs+"^"+OneStr;
			}
		}
	}
	return Strs;
}
document.body.onload = BodyLoadHandler;