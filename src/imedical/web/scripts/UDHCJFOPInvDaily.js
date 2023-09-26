var path,CurDate,AllCateSum
var AccountFlag
function BodyLoadHandler() {  
  gusercode=session["LOGON.USERCODE"] 
  var prt=document.getElementById("Print");
  if (prt){
     prt.onclick=Print_click;
     //prt.onclick=PrintAll_ClickNew;	  
  }  
  
  var prt=document.getElementById("BPrtCTDetail");
  if (prt){
     prt.onclick=PrtCTDetail_click;	  
  }
  var handinobj=document.getElementById("Handin");
  if (handinobj) {handinobj.onclick=gethandin}
  var Handinobj=document.getElementById("BHandin");
  if (Handinobj) Handinobj.onclick=BHandin_Click;
  var findjsobj=document.getElementById("findjs");
  if (findjsobj) DHCWeb_DisBtn(findjsobj);
  var stdate=document.getElementById("StDate").value
  var sttime=document.getElementById("StartTime").value
  var enddate=document.getElementById("EndDate").value
  var endtime=document.getElementById("EndTime").value
 
  if (stdate=="")
  {   
	  gethandin()
	  
  }
 

  if (document.getElementById("Handin").checked==false) 
  { getnotjkdate() }
  getpath()
  var AccountFlagObj=document.getElementById('AccountFlag')
  if (AccountFlagObj) AccountFlag=AccountFlagObj.checked
  if (AccountFlag==true)
  {  
	  DHCWeb_DisBtn(Handinobj)
  }
}
function getpath() 
{
	var getpath=document.getElementById("getpath");
	if (getpath) {var encmeth=getpath.value} else {var encmeth=""};	
	path=cspRunServerMethod(encmeth,"","")
}
function BHandin_Click()
{
	var handencobj=document.getElementById("HandinEncmeth");
	if (handencobj) {var encmeth=handencobj.value} else {var encmeth=""};
	var myinfo="";
	var myrtn=confirm(t["03"]);
	if (myrtn==false){
		return;
	}
    var stdate=document.getElementById("StDate").value
    var sttime=document.getElementById("StartTime").value
    var enddate=document.getElementById("EndDate").value
    var endtime=document.getElementById("EndTime").value
    var Guser=session["LOGON.USERID"]
	myinfo=stdate+"^"+sttime+"^"+enddate+"^"+endtime
      
	if (encmeth!=""){
		var rtn=(cspRunServerMethod(encmeth,Guser,myinfo))
		alert(rtn) 
	}
	var mytmpary=rtn.split("^");
	if (mytmpary[0]=="0") {
		alert(t["01"]);
		var obj=document.getElementById("BHandin");
		DHCWeb_DisBtn(obj);	
	}else{
		alert(t["02"]);	  
	}
}
function findjs_click(){	
	  var stdate=document.getElementById("StDate").value
	  var enddate=document.getElementById("EndDate").value
	  var UserCode=document.getElementById("UserCode").value
	  var Guser=session["LOGON.USERID"]
	  var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPDayRptHis&stdate='+stdate+'&enddate='+enddate+'&Guser='+Guser+'&findflag='+"INV"+'&AccountFlag='+AccountFlag+'&UserCode='+UserCode
	  window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
	
	}
function Print_click()
{
	var GuserID=session['LOGON.USERID'] 
	var GetcurDate=document.getElementById('GetcurDate');
	if (GetcurDate) {var encmeth=GetcurDate.value} else {var encmeth=''};
	CurDate=cspRunServerMethod(encmeth)
	var SelRowObj=document.getElementById('TJobz'+1);
	var job=SelRowObj.innerText
	//取诊别
	var AdmissionType=tkMakeServerCall("web.UDHCJFEPDailyHand","GetInPatAdmissionType")
	var AdmissionType=AdmissionType.split("^")	
    
    var UserCode=document.getElementById('UserCode').value
    if ((AccountFlag==true)&(UserCode==""))
    {
	    GuserID="ALL"
    }
   
	for (i=0;i<AdmissionType.length;i++)
	{  
		var GetRetStr=document.getElementById('GetPrtDetail');
		if (GetRetStr) {var encmeth=GetRetStr.value} else {var encmeth=''};
		var RetStr=cspRunServerMethod(encmeth,GuserID,job,AdmissionType[i])
		
		//var RetDetail=RetStr.split("#")
		if (RetStr!="0")
		{
			
			var PrtStr=RetStr
			PrtDetail(PrtStr,AdmissionType[i])
		}
	}
}
function gethandin()
{
  var handinobj=document.getElementById("Handin");
  var handin=handinobj.checked;
  var stdateobj=document.getElementById('StDate');
  var enddateobj=document.getElementById('EndDate');
  var Myobj=document.getElementById('Myid');
  if (Myobj){
   var imgname="ld"+Myobj.value+"i"+"StDate"
   var stdateobj1=document.getElementById(imgname);
   var imgname="ld"+Myobj.value+"i"+"EndDate"
   var enddateobj1=document.getElementById(imgname);} 
   
  if (handin==true){
     // stdateobj1.style.display="";
	  stdateobj.readOnly=false;
	  enddateobj1.style.display="";
	  enddateobj.readOnly=false;
	  var findobj=document.getElementById("Find");
	  if (findobj){ 
   		findobj.disabled=true;
	  }
	  var findjsobj=document.getElementById("findjs");
	  	if (findjsobj){ 
   			findjsobj.disabled=false;
   			findjsobj.onclick=findjs_click;
   		}
         var obj=document.getElementById("BHandin");
         if (obj) {obj.disabled=true;
		}

   }
   if (handin==false){
	  
	  getnotjkdate() 
	 
	  //stdateobj1.style.display="none";
	  stdateobj.readOnly=true;
	  var findobj=document.getElementById("Find");
	  if (findobj){ 
   		findobj.disabled=false;
	  }
	  var findjsobj=document.getElementById("findjs");
	  if (findjsobj){ 
   		findjsobj.disabled=true;
   		findjsobj.onclick=findjs_click;
	  }
	  var obj=document.getElementById("BHandin");
         if (obj) {
		obj.disabled=false;
		obj.onclick=BHandin_Click;
		}
    }
}

function getnotjkdate()
{ 
  var user=session["LOGON.USERID"]
  var enddata=document.getElementById("EndDate").value;
  var getstdate=document.getElementById("getstdate");
  if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
  var datestr=cspRunServerMethod(encmeth,user,enddata)
  datestr=datestr.split("^")
  document.getElementById("StDate").value=datestr[0]
  document.getElementById("StartTime").value=datestr[1]
  document.getElementById("EndDate").value=datestr[2]
  document.getElementById("EndTime").value=datestr[3]
  }
function UnloadHandler()
{	var flag="EPInvDailyHand"
    var job=document.getElementById("job").value
    var user=session["LOGON.USERID"] 
	var killobj=document.getElementById("Killtmp");
    if (killobj) {var encmeth=killobj.value} else {var encmeth=""};
    if (cspRunServerMethod(encmeth,flag,user,job)==0){
	    }
}
function PrtDetail(PrtStr,AdmissionType)
{
	var stdate=document.getElementById("StDate").value
	var stdate=stdate.split("/")
	var eddate=document.getElementById("EndDate").value
	var eddate=eddate.split("/")
	var StTime=document.getElementById("StartTime").value
	var EndTime=document.getElementById("EndTime").value
	var StDate=stdate[2]+"-"+stdate[1]+"-"+stdate[0]+" "+StTime
	var EndData=eddate[2]+"-"+eddate[1]+"-"+eddate[0]+" "+EndTime
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var k=0,l
	var pagerows,pagenum,prtrow
	var StrDetail=PrtStr.split("@")
	var CateNum=0
	var PayModeDetail=StrDetail[2].split("&")
	var PayModeNum=PayModeDetail.length
	
	var AccateStr=StrDetail[3]
	var PayModeSum=StrDetail[4]
	
	if (StrDetail[1]!="") 
	{  var CateDetail=StrDetail[1].split("!") 
	   CateNum=CateDetail.length  }
	if (PayModeSum==0) 
	{   
	    return
	 }
	pagerows=1
	Template=path+"JF_OPBillDaily.xls" 
	//Template="d:\\JF_OPBillDaily.xls" 
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlApp.visible=true
	if (AdmissionType=="T") { RegType="特诊" }
    if (AdmissionType=="Y") { RegType="业余诊" }
    if (AdmissionType=="Z") { RegType="正常诊" }
  
  	//var RegType=document.getElementById("ZType").value
	//xlsheet.cells(5,5).value="诊别:"+RegType
	//xlsheet.cells(23,5).value="诊别:"+RegType
	xlsheet.cells(18,4).value="收款员工号:"+session["LOGON.USERCODE"]
	xlsheet.cells(18,5).value="收款员姓名:"+session["LOGON.USERNAME"]
	xlsheet.cells(42,4).value="收款员工号:"+session["LOGON.USERCODE"]
	xlsheet.cells(42,5).value="收款员姓名:"+session["LOGON.USERNAME"]

	xlsheet.cells(3,2).value="收据信息:"+StrDetail[0]
	xlsheet.cells(4,2).value="时间范围:  "+StDate+"--"+EndData
	xlsheet.cells(5,2).value="打印时间:  "+CurDate
	xlsheet.cells(23,2).value="收据信息:"+StrDetail[0]
	xlsheet.cells(24,2).value="时间范围:  "+StDate+"--"+EndData
	xlsheet.cells(25,2).value="打印时间:  "+CurDate
		
	//var TpyeDetail=StrDetail[3].split("^")
	
	var m,n
	var AllCateSum=0
	var qtfee=0,YLSum=0,YPSum=0,qtsum=0  //表二的其他费
	for (m=0;m<CateNum;m++)
	{   var CateSub=CateDetail[m].split("^")
		xlsheet.cells(7+m,2).value=CateSub[0]
		xlsheet.cells(7+m,3).value=CateSub[1]
		xlsheet.cells(7+m,4).value=CateSub[2]
		xlsheet.cells(7+m,5).value=CateSub[3]
	}
	AccateStr=AccateStr.split("^")
	for (m=0;m<AccateStr.length;m++)
	{   
		xlsheet.cells(27+m,5).value=AccateStr[m]
	}
	var PayModeInfo
	for (m=0;m<PayModeNum-1;m++)
	{   PayModeInfo=PayModeDetail[m].split("^")
	    
		xlsheet.cells(27+m,2).value=PayModeInfo[0]
		xlsheet.cells(27+m,3).value=PayModeInfo[1]
	} 
	//alert(PayModeNum)
	PayModeInfo=PayModeDetail[PayModeNum-1].split("^")
	xlsheet.cells(39,3).value=PayModeInfo[1]
	
	/*if (PayModeDetail[0]!=0){xlsheet.cells(27,3).value=PayModeDetail[0]}
	if (PayModeDetail[1]!=0){xlsheet.cells(28,3).value=PayModeDetail[1]}
	if (PayModeDetail[2]!=0){xlsheet.cells(29,3).value=PayModeDetail[2]}
	if (PayModeDetail[3]!=0){xlsheet.cells(30,3).value=PayModeDetail[3]}
	if (PayModeDetail[4]!=0){xlsheet.cells(31,3).value=PayModeDetail[4]}
	if (PayModeDetail[5]!=0){xlsheet.cells(32,3).value=PayModeDetail[5]}
	if (PayModeDetail[6]!=0){xlsheet.cells(33,3).value=PayModeDetail[6]}
	if (PayModeDetail[7]!=0){xlsheet.cells(34,3).value=PayModeDetail[7]}
	if (PayModeDetail[8]!=0){xlsheet.cells(35,3).value=PayModeDetail[8]}
	if (PayModeDetail[9]!=0){xlsheet.cells(36,3).value=PayModeDetail[9]}
	if (PayModeDetail[10]!=0){xlsheet.cells(39,3).value=PayModeDetail[10]}
	*/
	
	xlsheet.printout
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null  
}
function PrtCTDetail_click()
{
	var GuserID=session["LOGON.USERID"] 
	var stdate=document.getElementById("StDate").value
	var stdate=stdate.split("/")
	var eddate=document.getElementById("EndDate").value
	var eddate=eddate.split("/")
	var StTime=document.getElementById("StartTime").value
	var EndTime=document.getElementById("EndTime").value
	var StDate=stdate[2]+"-"+stdate[1]+"-"+stdate[0]+" "+StTime
	var EndData=eddate[2]+"-"+eddate[1]+"-"+eddate[0]+" "+EndTime
	
	//var StDate=stdate[2]+"年"+stdate[1]+"月"+stdate[0]+"日"+"0点0分"
	//var EndData=eddate[2]+"年"+eddate[1]+"月"+eddate[0]+"日"+"23点59分"
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var k=0,l
	var pagerows,pagenum,prtrow
	pagerows=1
	var GetcurDate=document.getElementById("GetcurDate");
	if (GetcurDate) {var encmeth=GetcurDate.value} else {var encmeth=""};
	CurDate=cspRunServerMethod(encmeth)
	Template=path+"JF_OPBillCTDaily.xls" 
	//Template="d:\\JF_OPBillCTDaily.xls" 
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlApp.visible=true
	xlsheet.cells(3,2).value="时间范围:  "+StDate+"--"+EndData
	//xlsheet.cells(18,4).value="收款员工号:"+session["LOGON.USERCODE"]
	//xlsheet.cells(18,5).value="收款员姓名:"+session["LOGON.USERNAME"]
    var UserCode=document.getElementById('UserCode').value
    if ((AccountFlag==true)&(UserCode==""))
    {
	    GuserID="ALL"
    }
    var getnum=document.getElementById("getctnum");
	if (getnum) {var encmeth=getnum.value} else {var encmeth=""};
	var Num=cspRunServerMethod(encmeth,GuserID)
	var l
	
	for(l=1;l<=Num;l++)
	{
		var getctdata=document.getElementById("getctdata");
		if (getctdata) {var encmeth=getctdata.value} else {var encmeth=""};
		var Str=cspRunServerMethod(encmeth,GuserID,l)
		var StrDetail=Str.split("^")
		xlsheet.cells(4+l,9).value=StrDetail[2]
		xlsheet.cells(4+l,2).value=StrDetail[3]
		xlsheet.cells(4+l,3).value=StrDetail[4]
		xlsheet.cells(4+l,4).value=StrDetail[5]
		xlsheet.cells(4+l,5).value=StrDetail[6]
		xlsheet.cells(4+l,6).value=StrDetail[7]
		xlsheet.cells(4+l,7).value=StrDetail[8]
		xlsheet.cells(4+l,8).value=StrDetail[9]	
	}
	xlsheet.cells(4+l,2).value="收款员姓名:"+session["LOGON.USERNAME"]
	xlsheet.cells(4+l,7).value="打印时间:"+CurDate
	AddGrid(xlsheet,5,2,4+l,9,4,2)
	xlsheet.printout
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null 
}
function AddGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

function PrintAll_ClickNew()
{
	//var encmeth=""
	//var obj=document.getElementById("getPath");
	//if (obj) encmeth=obj.value;
	//if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var obj=document.getElementById("StDate");
	var StDatenew=obj.value;
	var obj=document.getElementById("EndDate");
	var EndDatenew=obj.value;
	var GuserID=session["LOGON.USERID"] 
	var GetcurDate=document.getElementById("GetcurDate");
	if (GetcurDate) {var encmeth=GetcurDate.value} else {var encmeth=""};
	var CurDate=cspRunServerMethod(encmeth,"","")
	var stdate=document.getElementById("StDate").value
	var stdate=stdate.split("/")
	var eddate=document.getElementById("EndDate").value
	var eddate=eddate.split("/")
	var StDate=stdate[2]+"年"+stdate[1]+"月"+stdate[0]+"日"+"0点0分"
	var EndData=eddate[2]+"年"+eddate[1]+"月"+eddate[0]+"日"+"23点59分"
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var k=0,l
	var pagerows,pagenum,prtrow
	pagerows=1
	//Template=TemplatePath+"JF_OPRPrtDailyHZnew.xls" 
	Template="d:\\JF_OPRPrtDailyHZnew.xls" 
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlApp.visible=true
	xlsheet.cells(3,2).value="时间范围: "+StDate+"--"+EndData
	var GetDetail=document.getElementById("ceshi");
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=""};
	var Str=cspRunServerMethod(encmeth,StDatenew,EndDatenew,GuserID)
	alert(Str)
	var StrDetail=Str.split("@")
	var Retvalue=StrDetail[0]
	if (Retvalue!="-1")
	{
		var AllCateStr=StrDetail[0].split("#")
		var CateNum=AllCateStr.length
		var m,n
		AllCateSum=0
		for (m=0;m<CateNum;m++)
		{
			var CateSub=AllCateStr[m].split("^")
			var CateName=CateSub[0]
			var CateFee=CateSub[1]
			PrtFeeDetail(CateName,CateFee,3,xlsheet)
			AllCateSum=AllCateSum-(0-CateFee)
		}
		xlsheet.cells(28,3).value=AllCateSum
	}
	var Retvalue=StrDetail[1]
	if (Retvalue!="-1")
	{
		var ZFCateStr=StrDetail[1].split("#")
		var ZFCateNum=ZFCateStr.length
		var m,n
		AllCateSum=0
		for (m=0;m<ZFCateNum;m++)
		{
			var CateSub=ZFCateStr[m].split("^")
			var CateName=CateSub[0]
			var CateFee=CateSub[1]
			PrtFeeDetail(CateName,CateFee,4,xlsheet)
			AllCateSum=AllCateSum-(0-CateFee)
		}
		xlsheet.cells(28,4).value=AllCateSum
	}
	var Retvalue=StrDetail[2]
	if (Retvalue!="-1")
	{
		var YBCateStr=StrDetail[2].split("#")
		var YBCateNum=YBCateStr.length
		var m,n
		AllCateSum=0
		for (m=0;m<YBCateNum;m++)
		{
			var CateSub=YBCateStr[m].split("^")
			var CateName=CateSub[0]
			var CateFee=CateSub[1]
			PrtFeeDetail(CateName,CateFee,5,xlsheet)
			AllCateSum=AllCateSum-(0-CateFee)
		}
		xlsheet.cells(28,5).value=AllCateSum
	}
	var Retvalue=StrDetail[3]
	if (Retvalue!="-1")
	{
		var AllCateStr=StrDetail[3].split("#")
		var CateNum=AllCateStr.length
		var m,n
		AllCateSum=0
		for (m=0;m<CateNum;m++)
		{
			var CateSub=AllCateStr[m].split("^")
			var CateName=CateSub[0]
			var CateFee=CateSub[1]
			PrtFeeDetail(CateName,CateFee,6,xlsheet)
			AllCateSum=AllCateSum-(0-CateFee)
		}
		xlsheet.cells(28,6).value=AllCateSum
	}var Retvalue=StrDetail[4]
	if (Retvalue!="-1")
	{
		var AllCateStr=StrDetail[4].split("#")
		var CateNum=AllCateStr.length
		var m,n
		AllCateSum=0
		for (m=0;m<CateNum;m++)
		{
			var CateSub=AllCateStr[m].split("^")
			var CateName=CateSub[0]
			var CateFee=CateSub[1]
			PrtFeeDetail(CateName,CateFee,7,xlsheet)
			AllCateSum=AllCateSum-(0-CateFee)
		}
		xlsheet.cells(28,7).value=AllCateSum
	}var Retvalue=StrDetail[5]
	if (Retvalue!="-1")
	{
		var AllCateStr=StrDetail[5].split("#")
		var CateNum=AllCateStr.length
		var m,n
		AllCateSum=0
		for (m=0;m<CateNum;m++)
		{
			var CateSub=AllCateStr[m].split("^")
			var CateName=CateSub[0]
			var CateFee=CateSub[1]
			PrtFeeDetail(CateName,CateFee,8,xlsheet)
			AllCateSum=AllCateSum-(0-CateFee)
		}
		xlsheet.cells(28,8).value=AllCateSum
	}var Retvalue=StrDetail[6]
	if (Retvalue!="-1")
	{
		var AllCateStr=StrDetail[6].split("#")
		var CateNum=AllCateStr.length
		var m,n
		AllCateSum=0
		for (m=0;m<CateNum;m++)
		{
			var CateSub=AllCateStr[m].split("^")
			var CateName=CateSub[0]
			var CateFee=CateSub[1]
			PrtFeeDetail(CateName,CateFee,9,xlsheet)
			AllCateSum=AllCateSum-(0-CateFee)
		}
		xlsheet.cells(28,9).value=AllCateSum
	}
	var Retvalue=StrDetail[7]
	if (Retvalue!="-1")
	{
		var AllPMStr=StrDetail[7].split("#")
		var PMNum=AllPMStr.length
		var m,n
		for (m=0;m<PMNum;m++)
		{
			var PMSub=AllPMStr[m].split("^")
			var PMName=PMSub[0]
			var PMFee=PMSub[1]
			PrtPMFeeDetail(PMName,PMFee,3,xlsheet)
		}
	}
	var Retvalue=StrDetail[8]
	if (Retvalue!="-1")
	{
		var ZFPMStr=StrDetail[8].split("#")
		var PMNum=ZFPMStr.length
		var m,n
		for (m=0;m<PMNum;m++)
		{
			var PMSub=ZFPMStr[m].split("^")
			var PMName=PMSub[0]
			var PMFee=PMSub[1]
			PrtPMFeeDetail(PMName,PMFee,4,xlsheet)
		}
	}
	var Retvalue=StrDetail[9]
	if (Retvalue!="-1")
	{
		var YBPMStr=StrDetail[9].split("#")
		var PMNum=YBPMStr.length
		var m,n
		for (m=0;m<PMNum;m++)
		{
			var PMSub=YBPMStr[m].split("^")
			var PMName=PMSub[0]
			var PMFee=PMSub[1]
			PrtPMFeeDetail(PMName,PMFee,5,xlsheet)
		}
	}
	var Retvalue=StrDetail[10]
	if (Retvalue!="-1")
	{
		var YBPMStr=StrDetail[10].split("#")
		var PMNum=YBPMStr.length
		var m,n
		for (m=0;m<PMNum;m++)
		{
			var PMSub=YBPMStr[m].split("^")
			var PMName=PMSub[0]
			var PMFee=PMSub[1]
			PrtPMFeeDetail(PMName,PMFee,6,xlsheet)
		}
	}
	var Retvalue=StrDetail[11]
	if (Retvalue!="-1")
	{
		var YBPMStr=StrDetail[11].split("#")
		var PMNum=YBPMStr.length
		var m,n
		for (m=0;m<PMNum;m++)
		{
			var PMSub=YBPMStr[m].split("^")
			var PMName=PMSub[0]
			var PMFee=PMSub[1]
			PrtPMFeeDetail(PMName,PMFee,7,xlsheet)
		}
	}
	var Retvalue=StrDetail[12]
	if (Retvalue!="-1")
	{
		var YBPMStr=StrDetail[12].split("#")
		var PMNum=YBPMStr.length
		var m,n
		for (m=0;m<PMNum;m++)
		{
			var PMSub=YBPMStr[m].split("^")
			var PMName=PMSub[0]
			var PMFee=PMSub[1]
			PrtPMFeeDetail(PMName,PMFee,8,xlsheet)
		}
	}
	var Retvalue=StrDetail[13]
	if (Retvalue!="-1")
	{
		var YBPMStr=StrDetail[13].split("#")
		var PMNum=YBPMStr.length
		var m,n
		for (m=0;m<PMNum;m++)
		{
			var PMSub=YBPMStr[m].split("^")
			var PMName=PMSub[0]
			var PMFee=PMSub[1]
			PrtPMFeeDetail(PMName,PMFee,9,xlsheet)
		}
	}
	xlsheet.cells(29,3).value=StrDetail[14]
	//xlsheet.cells(4,2).value="打印时间:"+CurDate
	xlsheet.cells(42,3).value=session["LOGON.USERNAME"]
	//xlsheet.cells(4,5).value="工号:"+session["LOGON.USERCODE"]
	
	xlsheet.printout
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null 
}


document.body.onload = BodyLoadHandler;