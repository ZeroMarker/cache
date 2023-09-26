var DiagCode="",DiagDesc="",SDate="",EDate="",name="",PatNo="",CenterNo="",Flag=""
var OEORIRowId=""
 var now=new Date()
var Guser=session['LOGON.USERID']
var GuserName=session['LOGON.USERNAME']
function BodyLoadHandler() {
try{

	//var selectrow=parent.frames["INSUAudit"].document.InsuRow
	var selectrow=parent.frames["INSUAudit"].InsuRow
	PatNo=parent.frames["INSUAudit"].document.getElementById('TabPatNoz'+selectrow).innerText;
	name=parent.frames["INSUAudit"].document.getElementById('TabPatNamez'+selectrow).innerText;
	Flag=parent.frames["INSUAudit"].document.getElementById('TabPrescNoz'+selectrow).innerText;
	OEORIRowId=parent.frames["INSUAudit"].document.getElementById('TabOEORIRowIdz'+selectrow).innerText;
}
catch(e){}
	var obj=document.getElementById("PatNo");
	if(obj){obj.value=PatNo;}
	var obj=document.getElementById("PatNo");
	if(obj){obj.onkeydown=ReadCard_Click;}
	var obj=document.getElementById("Query");
	if(obj){obj.onclick=Query_onclick;}
	var obj=document.getElementById("Report");
	if(obj){obj.onclick=Report_onclick;}
	var objtbl=document.getElementById("tDHCINSUOedLinkTar") ;
	if (objtbl)
	{
		for (i=1;i<objtbl.rows.length;i++)
		{
			var obj=document.getElementById("Selectz"+i);
			obj.checked=true;
		}
	}
	websys_setfocus('PatNo');
}
function Query_onclick(){
	var obj=document.getElementById("OeOrdDr");
	if (obj) {OeOrdDr=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCINSUOedLinkTar&OeOrdDr="+OeOrdDr;
 	location.href=lnk;
	}
function Report_onclick(){
	var Amount="",flag=0,SDate="",EDate=""
	//add by zhangdongliang at 2016-09-29 for SucessCount 作为审批成功计数器
	var SucessCount=0
	//end
	var objtbl=document.getElementById("tDHCINSUOedLinkTar") ;
	if (objtbl)
	{
		var Year=now.getFullYear(); //默认时间处理
  		var Month=now.getMonth()+1;
  		var Date=now.getDate();
  		if (String(Month).length<2)   Month="0"+Month 
  		if (String(Date).length<2)   Date="0"+Date 
   		SDate=String(Year)+String(Month)+String(Date)
  		 now.setDate(now.getDate()+7)
  		 Year=now.getFullYear();Month=now.getMonth()+1;Date=now.getDate();
  		if (String(Month).length<2)   Month="0"+Month 
  		if (String(Date).length<2)   Date="0"+Date 
		EDate=String(Year)+String(Month)+String(Date)
		now.setDate(now.getDate()-7)
		//alert(EDate)
		var Selobj=document.getElementById('ZZ');  //症状
  		var ZZ=Selobj.value;
  		var Selobj=document.getElementById('MD');  //目的
  		var MD=Selobj.value;
  		var Selobj=document.getElementById('PatNo');  //个人编号
  		var PatNo=Selobj.value;
  		var Selobj=document.getElementById('States');  //参保地
  		var TMPCenterNo=Selobj.value;
  		var RptType=""
  		//var PatNo="0044512"
  		//alert(Flag)
  		/*
  		if (Flag.indexOf("特病")>0) {var RptType="17"}
  		else var RptType="41"
  		if ((RptType=="17")&&(ZZ=="")) {alert("请录入症状");return;}
  		if ((RptType=="17")&&(DiagCode=="")) {alert("请录入病种名称");return;}
  		*/
  		if (ZZ=="") {alert("请录入症状");return;}
  		if (DiagCode=="") {alert("请选择病种名称");return;}
  		//alert(RptType)
  		if(TMPCenterNo.length>1) {CenterNo=TMPCenterNo}
  		var States=CenterNo   //参保地
  		if(States=="") {alert("参保地数据错误，请重新录入");return;}	//modefy by zhangdongliang at 2015-10-12 for 修改alert提示信息。
  		//alert(States)
		for (i=1;i<objtbl.rows.length;i++)
		{
			var obj=document.getElementById("Selectz"+i);
			if (obj.checked==true)
			{
			 	var Selobj=document.getElementById('TariCodez'+i); 
  				var TariCode=Selobj.innerText;	
  				var Selobj=document.getElementById('TariDescz'+i); 
  				var TariDesc=Selobj.innerText;	
  				var Selobj=document.getElementById('InsuCodez'+i); 
  				var InsuCode=Selobj.innerText;	
  				var Selobj=document.getElementById('InsuDescz'+i); 
  				var InsuDesc=Selobj.innerText;
  				InsuDesc=InsuDesc.replace("","").replace("","")
  				var Selobj=document.getElementById('xmlbz'+i); 
  				var xmlb=Selobj.innerText;	
  				var Selobj=document.getElementById('slz'+i); 
  				var sl=Selobj.innerText;	
  				var Selobj=document.getElementById('Pricez'+i); 
  				var Price=Selobj.innerText;	
  				var Selobj=document.getElementById('Amountz'+i);
  				var Amount=Selobj.innerText;
  				if (RptType=="41") {Amount=Price;}	
				//var str=PatNo+"|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|"+OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|"+HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID+"|"+States
				var str=PatNo+"|"+RptType+"|"+""+"|"+""+"|"+""+"|"+DiagCode+"|"+DiagDesc+"|"+"01"+"|"+InsuCode+"|"+InsuDesc+"|"+sl+"|"+SDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|"+""+"|"+""+"|"+Amount+"|"+xmlb+"|"+""+"|"+ZZ+"|"+MD+"|"+""+"|"+""+"|"+"01"+"|"+"01"+"|"+GuserName+"|"+SDate+"|"+GuserName+"|"+TariCode+"|"+TariDesc+"|"+""+"|"+""+"|"+States
				//alert(ExpString)
				var ExpString=name+"^"+OEORIRowId
				//alert(ExpString)
				var rtn=InsuReport(str,Guser,ExpString)
				if (rtn=="-1"){
					 alert("第"+i+"条数据审批上报失败!请检查数据重新上传第"+i+"条数据");
					//flag=1
				}
				else
				{
					SucessCount=SucessCount+1	
				}
   				// else alert("审批上报成功!")
   				
			}
		}
		alert("审批上报成功数据"+SucessCount +"条!")
		if(SucessCount==objtbl.rows.length-1){
			parent.frames["INSUAudit"].Audit_Click();
		}
	}

}	
	
function ReadCard_Click()
{
	//location.reload();
	if (window.event.keyCode!=13) return
	var CardType="0",CardNo="",States=""
	var obj=document.getElementById("PatNo"); //个人编号
	if (obj) CardNo=obj.value;
	if ((String(CardNo).length==15)||(String(CardNo).length==18)) CardType="1"
	//var obj=document.getElementById("CardType"); //有无卡标志
	//if (obj.checked==true) CardType="0"; 
	//else CardType="1"
	//modefy by zhangdongliang at 2015-10-12 for读卡函数改为标准版版本。增加失败判断。
	//var str=ReadINSUCard(CardNo,Guser,CardType)
	var str= InsuReadCard(0,Guser,CardNo,"")
	if(str=="-1")
	{
		alert("读卡失败")
		return;
	}
	//alert(str)
	var TmpData=str.split("|")
	if (TmpData[0]!="0") alert("读卡失败")
 	else 
 	{ ///9037786^10110377^3501-5^杨玉仙^女^^19360914000000^450106360914002^南宁市多丽电器有限责任公司^^^21^^786.51^^^^0^^450100|10015424^^20020515000000^2^1^^^^450107^10^100^3132      ^0^2011^840.8^0^0^0^0^0^0^0^46^1^0
	 	var TmpData1=TmpData[1].split("^")
	 	var obj=document.getElementById("PatNo"); //个人编号
		if (obj) obj.value=TmpData1[0];
		CenterNo=TmpData[2].split("^")[8]
		if(name!=TmpData1[3]){alert("姓名不一致,卡上姓名:"+TmpData1[3])}
		/*var obj=document.getElementById("CardNo"); //卡号
		if (obj) obj.value=TmpData1[1];
	 	var obj=document.getElementById("name"); //姓名
		if (obj) obj.value=TmpData1[3];
		var obj=document.getElementById("Sex"); //性别
		if (obj) obj.value=TmpData1[4];*/
		CenterNo=TmpData[2].split("^")[8]
		//alert(CenterNo)
		//if (TmpData[2].split("^")[8]=="450100")	States="南宁市"
		if (CenterNo=="450122")	States="武鸣县"
		else if (CenterNo=="450123")	States="隆安县"
		else if (CenterNo=="450124")	States="马山县"
		else if (CenterNo=="450125")	States="上林县"
		else if (CenterNo=="450126")	States="横县"  
		else if (CenterNo=="450127")	States="宾阳县"
		else {States="南宁市";CenterNo=="450100";}
	 	var obj=document.getElementById("States"); //参保人所属地
		if (obj) obj.value=States;
		//11 在职待遇 21	退休待遇 31	离休待遇 33	伤残军人待遇 91	成年居民 92	未成年居民
		/*if (TmpData1[11]=="11") TmpData1[11]="在职待遇"
		if (TmpData1[11]=="21") TmpData1[11]="退休待遇"
		if (TmpData1[11]=="31") TmpData1[11]="离休待遇"
		if (TmpData1[11]=="33") TmpData1[11]="伤残军人待遇"
		if (TmpData1[11]=="91") TmpData1[11]="成年居民"
		if (TmpData1[11]=="92") TmpData1[11]="未成年居民"
		var obj=document.getElementById("rylb"); //人员类别
		if (obj) obj.value=TmpData1[11];*/
		
	 	}
}
function LookUpWithAlias(str) //病种名称
{  //alert(str)
	var tmp= str.split("^");
	var obj=document.getElementById("DiagDesc")
	if (obj) obj.value=tmp[0];
   DiagCode=tmp[2]
   DiagDesc=tmp[0].split("|")[0]
   //alert(DiagDesc)
}
document.body.onload = BodyLoadHandler;