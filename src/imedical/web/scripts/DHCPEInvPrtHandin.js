
    var Guser;
	var GuserCode;
	var GuserName;
	var RegNo;
	var PatientID;
	var PatName;
	var CardNo;
	var CardVerify;
	var ExchCardVerify;
	var IDCardNo;
	var UserIDobj;
	var StartDateobj;
	var StartTimeobj;
	var EndDateobj;
	var EndTimeobj;
	var AmtSumobj;
	var ReceiptsNumobj;
	var RefundNumobj;
	var ReceiptsFieldobj;
	var refinvnoobj;
	var CashAmtobj;
	var ChequeAmtobj;
	var OtherAmtobj;
	var Footobj;
	var Printobj;
	var Findobj;
	var PDFootDetailobj;
	var Pamtobj;
	var Ramtobj;
	var today;
	
	var UserCountobj;
	var UserInfoobj;
	var CashNormalobj;
	var CashRefundobj;
	var rptTypeobj;
	var RowIdobj;
	var BAuditobj;
	var sswrobj;
	var AccountNosobj;
    var RoundFeeobj;
    var count=0;
    var CardDaySumobj;
function BodyLoadHandler() {
   
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GuserName=session['LOGON.USERNAME']
	UserIDobj=document.getElementById('UserID');
	UserIDobj.value=Guser
	StartDateobj=document.getElementById('StartDate');
	StartTimeobj=document.getElementById('StartTime');
	EndDateobj=document.getElementById('EndDate');
	EndTimeobj=document.getElementById('EndTime');
	AmtSumobj=document.getElementById('AmtSum');
	ReceiptsNumobj=document.getElementById('ReceiptsNum');
	RefundNumobj=document.getElementById('RefundNum');
	ReceiptsFieldobj=document.getElementById('ReceiptsField');
	refinvnoobj=document.getElementById('RefInvNo');
	CashAmtobj=document.getElementById('CashAmt');
	ChequeAmtobj=document.getElementById('ChequeAmt');
	OtherAmtobj=document.getElementById('OtherAmt');
	Footobj=document.getElementById('Foot');
	Printobj=document.getElementById('Print');
	Findobj=document.getElementById('Find');
	PDFootDetailobj=document.getElementById('PDFootDetail');
	Pamtobj=document.getElementById('Pamt');
	Ramtobj=document.getElementById('Ramt');
	today=document.getElementById('ToDay').value;
	CardDaySum=document.getElementById('PreViewCardDaySum');
	
	
	UserCountobj=document.getElementById('UserCount');
	UserInfoobj=document.getElementById('UserInfo');
	CashNormalobj=document.getElementById('CashNormal');
	CashRefundobj=document.getElementById('CashRefund');
	rptTypeobj=document.getElementById('RptType');
	RowIdobj=document.getElementById('RowID');
	sswrobj=document.getElementById('sswr');
	AccountNosobj=document.getElementById('AccountNos');  //Add 20080708
    	RoundFeeobj=document.getElementById('RoundFee');      //Add 20080708
	
	
	
	if (Findobj) Findobj.onclick = Find_Click;
	if (CardDaySum) CardDaySum.onclick = CardDaySum_Click;
	
	
	var obj=document.getElementById("BPreview");
	if (obj) obj.onclick=BPreview_click;
		
	if (Footobj) 
	{
		Footobj.onclick = Foot_Click;
		if (""!=RowIdobj.value)	
		{		
			Footobj.disabled=true;
			Footobj.style.color = "gray";	
		}
	}
	if (Printobj) 
	{
		var HospitalCode="";
		var obj=document.getElementById("HospitalCode");
		if (obj) HospitalCode=obj.value;
		if (HospitalCode=="NBMZ"){
		Printobj.onclick = PrintNBMZ_Click;}
		else if (HospitalCode=="SYYD")
		{
			Printobj.onclick = PrintCatPayMode_Click;
		}
		else if (HospitalCode=="YTZYY")
		{
			Printobj.onclick = PrintYTZYY_Click;
		}
		else if (HospitalCode=="ZSSY")
		{
			Printobj.onclick = PrintZSSY_Click;
		}
		else 
		{
		Printobj.onclick = Print_Click;}


		if ((""==RowIdobj.value)&&("1"==rptTypeobj.value))
		{	
			Printobj.disabled=true;
			Printobj.style.color = "gray";
		}
	}
	if (PDFootDetailobj) PDFootDetailobj.onclick = PDFootDetail_Click;
	
	BAuditobj=document.getElementById('BAudit');
	if (BAuditobj)
	{
		BAuditobj.onclick=BAudit_Click;
		var obj=document.getElementById('CanAuditFlag');
		if (obj&&(obj.value=="1"))
		{}
		else
		{
			BAuditobj.disabled=true;
			BAuditobj.style.color = "gray";
		
		}
	}
		
	//getpath();
	//gettoday();
	
    setreadonly();
    DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEUserRpt");
}

function CardDaySum_Click()
{
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+"DHCPECardDaySum.xlsx"
	
	var DaySumID=0;
	if (rptTypeobj.value=="1"){
		//日结
	if (""!=RowIdobj.value) DaySumID=RowIdobj.value; 
	var Infos=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetCardDaySum",DaySumID);
	}else{
		//日结汇总
		var begindate=StartDateobj.value;
		var enddate=EndDateobj.value;
		var Infos=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetCardDaySumHZ",begindate,enddate);
	}

	//if (""!=RowIdobj.value) DaySumID=RowIdobj.value;	
	//var Infos=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetCardDaySum",DaySumID);
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	
	//var HospName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
	var HospName=""
    var HospName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
	if(HospName.indexOf("[")>-1){var HospName=HospName.split("[")[0];}
	xlsheet.cells(2,2)=HospName+"体检中心体检卡收入日报表";

	var Count=8
	//alert(Info)
	var Info=Infos.split("$");
	var k=Info.length;
	//alert(k)
	for (var l=0;l<k;l++)
	{
		//alert(Info[l])
		var Datas=Info[l];
		var Data=Datas.split("^");
		xlsheet.cells(l+8,1).Value=Data[0];
		xlsheet.cells(l+8,2).Value=Data[1];
		xlsheet.cells(l+8,3).Value=Data[2];
		xlsheet.cells(l+8,4).Value=Data[3];
		xlsheet.cells(l+8,5).Value=Data[4];
		xlsheet.cells(l+8,7).Value=Data[5];
		xlsheet.cells(l+8,8).Value=Data[6];
		xlsheet.cells(l+8,10).Value=Data[7];
		xlsheet.cells(l+8,11).Value=Data[8];
		xlsheet.cells(l+8,12).Value=Data[9];
		//xlsheet.cells(l,11).Value=Data[10];
		
	}

	xlApp.Visible = true;
   	xlApp.UserControl = true;
	
	
	//return;
	
	
	
	
}

function setreadonly()
{
	//StartDateobj.readOnly=true;
	//EndDateobj.readOnly=true;

	if ("1"==rptTypeobj.value)
	{		
		if(StartDateobj) websys_disable(StartDateobj);
 		if(EndDateobj) websys_disable(EndDateobj);
 		if(StartTimeobj) websys_disable(StartTimeobj);
 		if(EndTimeobj) websys_disable(EndTimeobj);
 		var ComponentID="";
 	    var obj=document.getElementById("GetComponentID");
		if (obj){var ComponentID=obj.value;}
 		var obj=document.getElementById('ld'+ComponentID+'iStartDate');
	    if(obj) obj.style.display="none";
	    var obj=document.getElementById('ld'+ComponentID+'iEndDate');
	    if(obj) obj.style.display="none";
		//StartDateobj.disabled=true;
		//EndDateobj.disabled=true;

	}
	else
	{
		HiddenElement("StartTime",0,1);
		HiddenElement("EndTime",0,1);
		HiddenElement("ReceiptsField",1,1);
		HiddenElement("RefInvNo",1,1);
		HiddenElement("Foot");
		HiddenElement("PDFootDetail");
		HiddenElement("AccountNos",1,1);  //Add 20080708	
	}
	
	StartTimeobj.readOnly=true;	
	EndTimeobj.readOnly=true;
	AmtSumobj.readOnly=true;
	ReceiptsNumobj.readOnly=true;
	RefundNumobj.readOnly=true;
	ReceiptsFieldobj.readOnly=true;
	CashAmtobj.readOnly=true;
	ChequeAmtobj.readOnly=true;
	OtherAmtobj.readOnly=true;
	Pamtobj.readOnly=true;
	Ramtobj.readOnly=true;
	refinvnoobj.readOnly=true;
	
	UserCountobj.readOnly=true;
	UserInfoobj.readOnly=true;
	CashNormalobj.readOnly=true;
	CashRefundobj.readOnly=true;
	
	AccountNosobj.readOnly=true;       //Add 20080708
    RoundFeeobj.readOnly=true;         //Add 20080708

	
	FillData();
	}

function HiddenElement(elname,hiddenTD,hiddenCaption)
{
	var obj=document.getElementById(elname);
	if (obj)
	{
		obj.style.display="none";
		if (hiddenTD)
		{
			var sTD=obj.parentElement;
			sTD.style.display="none";
		}
	}
	if (hiddenCaption)
	{
		obj=document.getElementById("c"+elname);
		if (obj)
		{
			obj.style.display="none";
			if (hiddenTD)
			{
				var sTD=obj.parentElement;
				sTD.style.display="none";
			}
		}
	}
}

function Find_Click()
{
	FillData();	
}

function Foot_Click()
{
	if (Footobj.disabled) return;
	if (ReceiptsNumobj.value<1)
	{
	    alert(t[2047]);
		return;	
		}
	DHCWeb_DisBtn(Footobj);
	if (Guser!=""){
			p1=Guser
			p2=ReceiptsNumobj.value
			p3=AmtSumobj.value
			var getregno=document.getElementById('FootClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
			
			var rtn=cspRunServerMethod(encmeth,p1,p2,p3)
				//alert(rtn)
				if (rtn=="-2"){
					alert(t[2048]);
					Footobj.disabled=false;
					Footobj.onclick = Foot_Click;
					return;
					}
				if (rtn=="-3"){
					alert(t[2049]);
					Footobj.disabled=false;
					Footobj.onclick = Foot_Click;
					return;
					}
				if (rtn>0){
					alert(t[2050]);
					var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEInvPrtHandin"+"&RptType=1&RowID="+rtn;
    				location.href=lnk; 
				}
				else
				{
					alert(rtn + t[2015]);
					Footobj.disabled=false;
					Footobj.onclick = Foot_Click;
					return;
					}
			    
			}
	}
function BAudit_Click()
{
	if (BAuditobj.disabled) return;
	AuditPD();
}

function AuditPD()
{
	var GetAuditBox=document.getElementById('GetAuditBox');
	if (GetAuditBox) {var encmeth=GetAuditBox.value} else {var encmeth=''};
	rowid=RowIdobj.value;
	var rtn=cspRunServerMethod(encmeth,rowid,Guser)
	if (rtn!="") 
	{alert(rtn);}
	else
	{alert(t[2051]);}
}

///rpttype:  1收费员日结?2日结汇总
///rowid? 日结id
function GetData(rpttype,rowid,userid,begindate,enddate)
{
	var rtn=""
	var rpttype,rowid,userid,begindate,enddate;
	rpttype=rptTypeobj.value;
	rowid=RowIdobj.value;
	begindate=StartDateobj.value;
	enddate=EndDateobj.value;
	
	var getPD=document.getElementById('GetPD');
	if ((getPD)&&(""!=getPD.value))
	{
		var encmeth=getPD.value;
		rtn=cspRunServerMethod(encmeth,rpttype,rowid,Guser,begindate,enddate);		
	}
	return rtn;
	
	if (2==rpttype)
	{
	}
	else
	{
		if (""==rowid)
		{
			if (Guser!="")
			{
				p1=Guser
				var getregno=document.getElementById('FindClass');
				if (getregno) 
					{var encmeth=getregno.value} 
				else 
					{var encmeth=''};
				rtn=cspRunServerMethod(encmeth,p1)
			}
		}
		else
		{
			var getregno=document.getElementById('FindFoot');
			if (getregno) 
				{var encmeth=getregno.value} 
			else 
				{var encmeth=''};
			rtn=cspRunServerMethod(encmeth,rowid)
		}
	}
	return rtn;
}
function StringIsNull(String)
{
	if (String==null) return ""
	if (String==undefined) return ""
	return String
}
function BPreview_click()
{
	if (RowIdobj.value==""){
		PrintForXH("",Guser,1);
	}else{
		PrintForXH(RowIdobj.value,"",1);
	}
	//Guser
}
function PrintForXH(FootID,UserID,Priview)
{
	var rptPath=document.getElementById('RptPath');
	var Template=rptPath.value+"DHCPEUserRpt.xls";
	var selrow;
	var xlApp,xlsheet,xlBook;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	
	//var HospName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
	var HospName=""
    var HospName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
	if(HospName.indexOf("[")>-1){var HospName=HospName.split("[")[0];}
	xlsheet.cells(2,2)=HospName+"体检收入个人报表";

	if (rptTypeobj.value=="1"){
		var ret=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetReportInfoForXH",FootID,UserID,"Y");
	}else{
		var begindate=StartDateobj.value;
		var enddate=EndDateobj.value;
		var ret=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORTEx","GetReportInfoForXH",begindate,enddate,Guser);
	}
	var DataArr=ret.split("^");
	xlsheet.cells(3,2)=xlsheet.cells(3,2).value+DataArr[1];
	xlsheet.cells(3,4)=xlsheet.cells(3,4).value+DataArr[1];
	xlsheet.cells(4,2)=xlsheet.cells(4,2).value+DataArr[2];
	xlsheet.cells(4,4)=xlsheet.cells(4,4).value+DataArr[3];
	
	xlsheet.cells(18,3)=DataArr[8];
	xlsheet.cells(19,3)=DataArr[6];
	
	xlsheet.cells(49,3)=DataArr[4];
	xlsheet.cells(50,3)=DataArr[5];
	
	xlsheet.cells(51,3)=DataArr[6];
	xlsheet.cells(52,3)=DataArr[7];
	//预缴金存、退、当天增加
	xlsheet.cells(13,3)=DataArr[11];
	xlsheet.cells(14,3)=DataArr[10];
	xlsheet.cells(15,3)=DataArr[9];
	
	var encmeth=document.getElementById("GetInfo").value;
	for (var i=6;i<46;i++)
	{
		var Info=StringIsNull(xlsheet.cells(i,3).value);
		var retInfo=cspRunServerMethod(encmeth,DataArr[0],Info);
		var retArr=retInfo.split("^");
		if (retArr[0]!=0) xlsheet.cells(i,3)=retArr[1];
		var Info=StringIsNull(xlsheet.cells(i,5).value);
		var retInfo=cspRunServerMethod(encmeth,DataArr[0],Info);
		var retArr=retInfo.split("^");
		if (retArr[0]!=0) xlsheet.cells(i,5)=retArr[1];
		
	}
	
	if (Priview==1)
	{
		xlApp.Visible = true;
		xlApp.UserControl = true; 
	}else{
		xlsheet.printout
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null
	}
}
function Print_Click()
{
	
	if (Printobj.disabled) return;
	///对于日结?尚未结算?则不能打印
	if ((1==rptTypeobj.value)&&(""==RowIdobj.value))
	{
		return;
	}
	//alert(rptTypeobj.value)	
	PrintForXH(RowIdobj.value,"",0)
	return false;
	var rtn=GetData();
	var val1=rtn.split("&");
	var val=val1[0].split("^");	
	var RMB=val[2]	                    //add by zhouli strart
    var Obj=document.getElementById("GetRMBDX");
    if (Obj)
	{    var encmeth=Obj.value;
		 var RMBDX=cspRunServerMethod(encmeth,"","",RMB);
		}	     //add by zhouli end 
	
	if (val[0]=="0")
		{if ("1"==rptTypeobj.value) 
		 {alert(t[2047]);}
		else
		 {alert(t[2046]);}
		 return;		}
		 
	     val1=val1[1];
    	var val2=val1.split("%%");
    	var CatFee=val2[1]
	
	var CatFeevalue=CatFee.split("$");
	
    	var CatFeevaluelen=CatFeevalue.length;

    
    
 
	var amount;
	try
	{
		var xlsrow=1
		var xlApp,xlsheet,xlBook;
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		var title=xlsheet.cells(xlsrow,1).value;
		var title=title.split("^");
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,1)=title[0];}
		else
		{	xlsheet.cells(xlsrow,1)=title[1];}
		//统计日期
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,6)=val[8]+" "+val[9]+" 至 "+val[10]+" "+val[11];	//日期
		//收费员信息
		if ("1"==rptTypeobj.value)
		{
			selrow=xlsrow+1;
			xlsheet.Rows(selrow+":"+selrow).Delete;
		}
		else
		{
			xlsrow=xlsrow+1;
			xlsheet.cells(xlsrow,3)=val[14];
		}
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,1)=xlsheet.cells(xlsrow,1)+val[15]+"("+val[24]+")";
		//收费发票信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[0];
		xlsrow=xlsrow+1;
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,1)=xlsheet.cells(xlsrow,1)+val[12];}
		else
		{	
			xlsheet.cells(xlsrow,1)="";
			xlsheet.Rows(xlsrow+":"+xlsrow).RowHeight=1;	}
		//作废发票信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)+val[1];
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)+val[13];
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)}
		else
		{	xlsheet.cells(xlsrow,7)="";}
		//体检收入信息
		xlsheet.cells(xlsrow,3)=val[3]-val[26];
		xlsheet.cells(xlsrow,5)=val[4]-val[27];
		xlsheet.cells(xlsrow,6)=val[2]-val[25];
		
		//现金信息或凑整费信息
		xlsrow=xlsrow+1;
		if (xlsheet.cells(xlsrow,3).value=="RoundFee")
		{///显示凑整费信息
			xlsheet.cells(xlsrow,3)=val[26];
			xlsheet.cells(xlsrow,5)=val[27];
			xlsheet.cells(xlsrow,6)=val[25];
		}
		else
		{
			///显示现金信息
			xlsheet.cells(xlsrow,3)=val[16];
			xlsheet.cells(xlsrow,5)=val[17];
			xlsheet.cells(xlsrow,6)=val[5];
		}
		xlsrow=xlsrow+1;
		var CatFeevalue=CatFee.split("$");
        var length=CatFeevalue.length;
   
        for (var i=0;i<length;i++)
        { 
      
        var Feevalue=CatFeevalue[i].split(":");
        
        xlsheet.cells(xlsrow,1)=Feevalue[3]
		xlsheet.cells(xlsrow,3)=Feevalue[0]
		xlsheet.cells(xlsrow,5)=Feevalue[1]
		xlsheet.cells(xlsrow,6)=Feevalue[2]
           xlsrow=xlsrow+1;
	 
        }
   
		
	    xlsrow=xlsrow+(8-length-1)
	    
		xlsheet.cells(xlsrow,4)=val[2];
		xlsheet.cells(xlsrow,1)="实收体检收入"
		var tmplist;
		var valList=val1.split("#");
		var len=valList.length;
		for (var i=20;i>=len;i--)
		{
			selrow=xlsrow+i;
			xlsheet.Rows(selrow+":"+selrow).Delete;
		}
		//var tmpdesc=xlsheet.cells(xlsrow,7);
		//支付方式信息
		var paysum=0
		for (var i=0;i<len;i++)
		{
			tmplist=valList[i].split("^");
			//xlsheet.cells(xlsrow,7)=tmpdesc;
			xlsheet.cells(xlsrow,8)=tmplist[6];
			amount=tmplist[1];
			if ((!amount)||(""==amount)) amount="0.00";
			xlsheet.cells(xlsrow,9)=amount;
			paysum=paysum+parseFloat(amount);
			xlsrow=xlsrow+1;
		}
		xlsheet.cells(xlsrow,4)=RMBDX;
		xlsheet.cells(xlsrow,9)=paysum;
		//借贷合计信息
		xlsrow=xlsrow+2;
		//xlsheet.cells(xlsrow,2)="1"+xlsheet.cells(xlsrow,2);
		xlsheet.cells(xlsrow,7)=val[19]+"("+val[20]+")";
	
		xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} 
	catch(e) 
	{	alert(e.message);	}
}
function PrintYTZYY_Click()
{
	
	if (Printobj.disabled) return;
	///对于日结?尚未结算?则不能打印
	if ((1==rptTypeobj.value)&&(""==RowIdobj.value))
	{
		return;
	}	
	var rptPath=document.getElementById('RptPath');
	var Template=rptPath.value+"DHCPEUserRpt.xls";
	var selrow;
	
	var rtn=GetData();
	var val1=rtn.split("&");
	var val=val1[0].split("^");	
	var RMB=val[2]	                    //add by zhouli strart
    var Obj=document.getElementById("GetRMBDX");
    if (Obj)
	{    var encmeth=Obj.value;
		 var RMBDX=cspRunServerMethod(encmeth,"","",RMB);
		}	     //add by zhouli end 
		
	if (val[0]=="0")
		{if ("1"==rptTypeobj.value) 
		 {alert(t[2047]);}
		else
		 {alert(t[2046]);}
		 return;		}
	     val1=val1[1];
    	var val2=val1.split("%%");
    	var CatFee=val2[1]
	
	var CatFeevalue=CatFee.split("$");
	
    	var CatFeevaluelen=CatFeevalue.length;

    
    
 
	var amount;

	try
	{
		var xlsrow=1
		var xlApp,xlsheet,xlBook;
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		var title=xlsheet.cells(xlsrow,1).value;
		var title=title.split("^");
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,1)=title[0];}
		else
		{	xlsheet.cells(xlsrow,1)=title[1];}
		//统计日期
	
		xlsrow=xlsrow+1;
		xlsheet.Range(xlsheet.Cells(xlsrow, 1), xlsheet.Cells(xlsrow,9)).Borders(4).LineStyle=1;  //单元格下边框
		xlsheet.cells(xlsrow,5)=xlsheet.cells(xlsrow,5)+" "+val[8]+" "+val[9]+" 至 "+val[10]+" "+val[11]	//日期
	
		//收费员信息
		if ("1"==rptTypeobj.value)
		{
			selrow=xlsrow+1;
			xlsheet.Rows(selrow+":"+selrow).Delete;
		}
		else
		{
			xlsrow=xlsrow+1;
			xlsheet.cells(xlsrow,3)=val[14];
		}
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,1)=xlsheet.cells(xlsrow,1)+val[15]+"("+val[24]+")";
		//收费发票信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[0];
		xlsrow=xlsrow+1;
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,1)=xlsheet.cells(xlsrow,1)+val[12];}
		else
		{	
			xlsheet.cells(xlsrow,1)="";
			xlsheet.Rows(xlsrow+":"+xlsrow).RowHeight=1;	}
		//作废发票信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)+val[1];
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)+val[13];
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)}
		else
		{	xlsheet.cells(xlsrow,7)="";}
		//体检收入信息
		xlsheet.cells(xlsrow,3)=val[3]-val[26];
		xlsheet.cells(xlsrow,5)=val[4]-val[27];
		xlsheet.cells(xlsrow,6)=val[2]-val[25];
		
		//现金信息或凑整费信息
		xlsrow=xlsrow+1;
		
		if (xlsheet.cells(xlsrow,3).value=="RoundFee")
		{///显示凑整费信息
			xlsheet.cells(xlsrow,3)=val[26];
			xlsheet.cells(xlsrow,5)=val[27];
			xlsheet.cells(xlsrow,6)=val[25];
		}
		else
		{
			///显示现金信息
			xlsheet.cells(xlsrow,3)=val[16];
			xlsheet.cells(xlsrow,5)=val[17];
			xlsheet.cells(xlsrow,6)=val[5];
		}
		xlsrow=xlsrow+1;
		var CatFeevalue=CatFee.split("$");
        var length=CatFeevalue.length;
         
        for (var i=0;i<length;i++)
        { 
      
        var Feevalue=CatFeevalue[i].split(":");
        if (i>1)
    
        {xlsheet.Rows(xlsrow+":"+xlsrow).Insert;
        xlsheet.Range(xlsheet.Cells(xlsrow,1),xlsheet.Cells(xlsrow,2)).mergecells=true;
        xlsheet.Range(xlsheet.Cells(xlsrow,3),xlsheet.Cells(xlsrow,4)).mergecells=true
         xlsheet.Range(xlsheet.Cells(xlsrow,7),xlsheet.Cells(xlsrow,8)).mergecells=true
        gridlist(xlsheet,xlsrow,xlsrow,1,6) 
        }
        xlsheet.cells(xlsrow,1)=Feevalue[3]
		xlsheet.cells(xlsrow,3)=Feevalue[0]
		xlsheet.cells(xlsrow,5)=Feevalue[1]
		xlsheet.cells(xlsrow,6)=Feevalue[2]
           xlsrow=xlsrow+1;
	 
        }
   
		
	    //xlsrow=xlsrow+(8-length-1)
	    

		var tmplist;
		var valList=val1.split("#");
		var len=valList.length;
		for (var i=20;i>=len;i--)
		{
			selrow=xlsrow+i;
			xlsheet.Rows(selrow+":"+selrow).Delete;
		}
		//var tmpdesc=xlsheet.cells(xlsrow,7);
		//支付方式信息
		var paysum=0
		for (var i=0;i<len;i++)
		{
			tmplist=valList[i].split("^");
			//xlsheet.cells(xlsrow,7)=tmpdesc;
			xlsheet.cells(xlsrow,8)=tmplist[6];
			amount=tmplist[1];
			if ((!amount)||(""==amount)) amount="0.00";
			xlsheet.cells(xlsrow,9)=amount;
			paysum=paysum+parseFloat(amount);
			xlsrow=xlsrow+1;
		}
			xlsheet.cells(xlsrow-1,4)=val[2];
		xlsheet.cells(xlsrow-1,1)="实收体检收入"
		xlsheet.cells(xlsrow,4)=RMBDX;
		xlsheet.cells(xlsrow,9)=paysum;
		//借贷合计信息
	
		xlsrow=xlsrow+2;
		//xlsheet.cells(xlsrow,2)="1"+xlsheet.cells(xlsrow,2);
		xlsheet.cells(xlsrow,7)=val[19]+"("+val[20]+")";
	
		xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} 
	catch(e) 
	{	alert(e.message);	}
}
function gridlist(objSheet,row1,row2,c1,c2)
{   objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(9).Weight = 2;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

/*
function Print_Click()
{
	if (Printobj.disabled) return;
	var TxtInfo,ListInfo
	var c=String.fromCharCode(2)
	TxtInfo="StartDate"+c+StartDateobj.value+"^"+"StartTime"+c+StartTimeobj.value+"^"+"EndDate"+c+EndDateobj.value+"^"+"EndTime"+c+EndTimeobj.value+"^"
	TxtInfo=TxtInfo+"AmtSum"+c+AmtSumobj.value+"^"+"CashAmt"+c+CashAmtobj.value+"^"+"Pamt"+c+Pamtobj.value+"^"+"Ramt"+c+Ramtobj.value+"^"
	TxtInfo=TxtInfo+"ChequeAmt"+c+ChequeAmtobj.value+"^"+"OtherAmt"+c+OtherAmtobj.value+"^"+"ReceiptsNum"+c+ReceiptsNumobj.value+"^"+"RefundNum"+c+RefundNumobj.value+"^"
	TxtInfo=TxtInfo+"GuserName"+c+GuserName+"^"+"PrintDate"+c+today+"^"+"PrtInvNoStr"+c+ReceiptsFieldobj.value+"^"+"RefPrtInvNoStr"+c+refinvnoobj.value
	//alert(TxtInfo)
	//return
	ListInfo=""
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
	}
*/

function PDFootDetail_Click()
{
	var footid=0;
	if (""!=RowIdobj.value) footid=RowIdobj.value;	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEInvPrtDetail&USERID='+Guser+'&FOOTID='+footid;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0')
}
/*	
function getPDbyUser()
{
    
		if (Guser!=""){
			p1=Guser
			var getregno=document.getElementById('FindClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,p1)
				if (rtn=="-2"){
					alert(t[2047]);
					return;
					}
			    setpdinfo_val(rtn);
			}
	
	}*/

function FillData()
{
	var rtn=GetData();
  
	if ((""==rtn)||("-1"==rtn))
	{}
	else if (rtn=="-2")
	{	if (rptTypeobj.value=="1") alert(t[2047]);
		if (rptTypeobj.value=="2") alert(t[2046]);}
	else
	{	setpdinfo_val(rtn);}
		
}
function GetPD()
{
	if ((""!=RowIdobj.value)||(Guser!=""))
	{
		var rtn=GetData();
		
		if (rtn=="-2"){
			alert(t[2047]);
			return;
			}
		setpdinfo_val(rtn);
	}
}

function setpdinfo_val(value)
	{
		//footnum_"^"_refundnum_"^"_footsum_"^"_pdsum_"^"_refundsum_"^"_cashsum_"^"_chequesum_"^"_othersum_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr
	var val1=value.split("&");
	var val=val1[0].split("^");
	val1=val1[1];
	//alert(val1);

	  
	//if (val[0]=="0")
	//{	if (rptTypeobj.value=="1") alert(t[2047]);
	//	if (rptTypeobj.value=="2") alert(t[2046]);
	//	return;		}
	StartDateobj.value=val[8];
	StartTimeobj.value=val[9];
	EndDateobj.value=val[10];
	EndTimeobj.value=val[11];
	AmtSumobj.value=val[2];
	ReceiptsNumobj.value=val[0];
	RefundNumobj.value=val[1];
	ReceiptsFieldobj.value=val[12];
	CashAmtobj.value=val[5];
	ChequeAmtobj.value=val[6];
	OtherAmtobj.value=val[7];
	Pamtobj.value=val[3];
	Ramtobj.value=val[4];
	refinvnoobj.value=val[13];
	
	UserCountobj.value=val[14];
	UserInfoobj.value=val[15];
	CashNormalobj.value=val[16];
	CashRefundobj.value=val[17];
	RoundFeeobj.value=val[25];
	var sswr=0;
	sswr=(+val[29])-(+val[30]);
	sswrobj.value=sswr;
	var listobj=document.getElementById('PayModeList');
	FillList(listobj,val1);
}

function FillList(listobj,value)
{
	var itmtext;
	var itmvalue;
	var tmplist;
	var tmp;
	var valList=value.split("#");
	var len=valList.length;
	listobj.options.length=0;
	for (var i=0;i<len;i++)
	{
		tmplist=valList[i].split("^");
		tmp=tmplist[6];
		itmtext=tmplist[6]+"                                    ";
		itmtext=itmtext.substring(0,36-tmp.length*2.7);
		tmp="               "+tmplist[1];
		tmp=tmp.substring(tmp.length-15,tmp.length);
		itmtext=itmtext+tmp;
		//itmtext=tmp;
		//alert(itmtext.length);
		itmvalue=tmplist[0];
		listobj.options.add(new Option(itmtext,itmvalue))
	}	
}
   function PrintNBMZ_Click()
   {
	if (Printobj.disabled) return;
	///对于日结?尚未结算?则不能打印
	if ((1==rptTypeobj.value)&&(""==RowIdobj.value))
	{
		return;
	}	
	var rptPath=document.getElementById('RptPath');
	var Template=rptPath.value+"DHCPEUserRpt.xls";
	
	var rtn=GetData();
	
	var val1=rtn.split("&");
	var val=val1[0].split("^");	
	if (val[0]=="0")
		{	
			if ("1"==rptTypeobj.value) 
				{alert(t[2047]);}
			else
				{alert(t[2046]);}
			return;		}
	val1=val1[1];
	var amount;
	
	//alert(Template);
	//return;
	try
	{
		var xlsrow=1
		var xlApp,xlsheet,xlBook;
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		var title=xlsheet.cells(xlsrow,1).value;
		var title=title.split("^");
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,1)=title[0];}
		else
		{	xlsheet.cells(xlsrow,1)=title[1];}
		//统计日期
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,7)=val[8]+xlsheet.cells(xlsrow,7)+val[10];	//日期
		//收费员信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[14];
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,1)=xlsheet.cells(xlsrow,1)+val[15];
		//收费发票信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[0];
		xlsrow=xlsrow+1;
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,1)=xlsheet.cells(xlsrow,1)+val[12];}
		else
		{	//xlsheet.Rows(xlsrow+":"+xlsrow).Delete;
			xlsheet.cells(xlsrow,1)="";
			xlsheet.Rows(xlsrow+":"+xlsrow).RowHeight=1;	}
		//作废发票信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)+val[1];
		xlsrow=xlsrow+1;
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)+val[13];}
		else
		{	xlsheet.cells(xlsrow,7)="";}
		//体检收入信息
		xlsheet.cells(xlsrow,3)=val[3];
		xlsheet.cells(xlsrow,5)=val[4];
		xlsheet.cells(xlsrow,6)=val[2];
		//小计信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[3];
		xlsheet.cells(xlsrow,5)=val[4];
		xlsheet.cells(xlsrow,6)=val[2];
		
		//协议调整费
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[26];
		xlsheet.cells(xlsrow,5)=val[27];
		xlsheet.cells(xlsrow,6)=val[25];		
		
		//现金信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[16];
		xlsheet.cells(xlsrow,5)=val[17];
		xlsheet.cells(xlsrow,6)=val[5];
		
		//记帐信息		
		xlsrow=xlsrow+1;
		var accountRow=xlsrow;
		
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,4)=val[2];
		
		var tmplist;
		var valList=val1.split("#");
		var len=valList.length;
		for (var i=20;i>=len;i--)
		{
			var selrow=xlsrow+i;
			xlsheet.Rows(selrow+":"+selrow).Delete;
		}
		//var tmpdesc=xlsheet.cells(xlsrow,7);
		//支付方式信息
		var paysum=0
		for (var i=0;i<len;i++)
		{	//alert(valList[i]);
			tmplist=valList[i].split("^");
			//xlsheet.cells(xlsrow,7)=tmpdesc;
			xlsheet.cells(xlsrow,7)=tmplist[6];  //dj080521
			amount=tmplist[1];
			if ((!amount)||(""==amount)) amount="0.00";
			xlsheet.cells(xlsrow,9)=amount;
			paysum=paysum+parseFloat(amount);
			if (tmplist[0]==4)
			{
				if ("1"==rptTypeobj.value)
				{
				xlsheet.cells(accountRow,3)=tmplist[2];
				xlsheet.cells(accountRow,5)=tmplist[4];
				xlsheet.cells(accountRow,6)=tmplist[1];
				//alert(AccountNosobj.value);
				if (AccountNosobj) xlsheet.cells(accountRow,7)="号码:"+AccountNosobj.value;
				}
				else
				{
					//xlsheet.Rows(accountRow+":"+accountRow).Delete;
				}
			}
			xlsrow=xlsrow+1;
		}
		xlsheet.cells(xlsrow,4)=val[2];
		xlsheet.cells(xlsrow,9)=paysum;
		//借贷合计信息
		xlsrow=xlsrow+2;
		xlsheet.cells(xlsrow,2)="1"+xlsheet.cells(xlsrow,2);
		xlsheet.cells(xlsrow,7)=val[19]+"("+val[20]+")";
		
		if ("1"!=rptTypeobj.value)
		{
			xlsheet.Rows(accountRow+":"+accountRow).Delete;
		}
	
		xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} 
	catch(e) 
	{	alert(e.message);	}
   }
function PrintCatPayMode_Click()
{
	if (Printobj.disabled) return;
	if ((1==rptTypeobj.value)&&(""==RowIdobj.value))
	{
		return;
	}	
	var rptPath=document.getElementById('RptPath');
	var Template=rptPath.value+"DHCPEUSERREPORTCat.xls";
	//GetCatPayModeInfo
	var Flag=0
	if (RowIdobj.value=="")
	{
		var obj=document.getElementById("GetFootIDStrByDate");
		if (!obj) return false;
		var encmeth=obj.value;
		begindate=StartDateobj.value;
		enddate=EndDateobj.value;
		RowIdobj.value=cspRunServerMethod(encmeth,begindate,enddate);
		var Flag=1
	}
	var obj=document.getElementById("GetCatPayModeInfo");
	if (!obj) return false;
	var encmeth=obj.value;
	
	var rtn=cspRunServerMethod(encmeth,RowIdobj.value,"1");
	if (Flag==1) RowIdobj.value="";
	var Info=rtn.split("&");
	var i=Info.length;
	try
	{
		var xlsrow=1
		var xlApp,xlsheet,xlBook;
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		var RowStr=Info[0];
		var OneCell=RowStr.split("^");
		var k=OneCell.length;
		xlsheet.cells(6,1)=OneCell[0];
		xlsheet.cells(6,2)=OneCell[1];
		for (var j=2;j<k;j++)
		{
			xlsheet.cells(7,1+j)=OneCell[j];
		}
		
		for (var j=1;j<i;j++)
		{
			var RowStr=Info[j];
			xlsheet.Rows(j+8).insert();
			var OneCell=RowStr.split("^");
			for (var l=0;l<k;l++)
			{
				xlsheet.cells(j+7,1+l)=OneCell[l];
			}
		}
		xlsheet.Rows(j+7).Delete;
		xlsheet.Rows(j+7).Delete;
	}
	catch(e) 
	{
		alert(e.message);
	}
	
	var rtn=GetData();
	var Info=rtn.split("^")
	var InvNum="收款单据数"+Info[0]+"张,退款单据数"+Info[1]+"张";
	var StrtDate="时间范围: "+Info[8]+" "+Info[9]+" 至 "+Info[10]+" "+Info[11];
	var User="收银员:"+Info[24]+"("+Info[20]+")";
	xlsheet.cells(5,1)=StrtDate;
	xlsheet.cells(5,8)=RowIdobj.value;
	xlsheet.cells(j+7,1)=User;
	xlsheet.cells(j+7,6)=InvNum;
	xlsheet.cells(j+8,2)=Info[12];
	xlsheet.cells(j+9,2)=Info[13];
	xlsheet.printout;
	
	CloseExcel(xlApp,xlBook,xlsheet);
}
//彻底清除打开的Excel进程
function CloseExcel(xlApp,xlBook,xlsheet)
{
	xlBook.Close(savechanges=false);	
	xlApp.Quit();     
	xlApp=null; 
	xlsheet=null;  
	idTmr=window.setInterval("Cleanup();",1);	
}
var idTmr=""; 
function Cleanup()
{   
	window.clearInterval(idTmr);   
	CollectGarbage(); 
}
function PrintZSSY_Click()
{
	if (Printobj.disabled) return;
	if ((1==rptTypeobj.value)&&(""==RowIdobj.value))
	{
		return;
	}	
	var rptPath=document.getElementById('RptPath');
	var Template=rptPath.value+"DHCPEUserReportZSSY.xls";
	//GetCatPayModeInfo
	var Flag=0
	if (RowIdobj.value=="")
	{
		var obj=document.getElementById("GetFootIDStrByDate");
		if (!obj) return false;
		var encmeth=obj.value;
		begindate=StartDateobj.value;
		enddate=EndDateobj.value;
		RowIdobj.value=cspRunServerMethod(encmeth,begindate,enddate);
		var Flag=1
	}
	var obj=document.getElementById("GetCatPayModeInfoZSSY");
	if (!obj) return false;
	var encmeth=obj.value;
	
	var rtn=cspRunServerMethod(encmeth,RowIdobj.value);
	if (Flag==1) RowIdobj.value="";
	var Char_2=String.fromCharCode(2);
	var Char_1=String.fromCharCode(1);
	var Info=rtn.split(Char_2);
	var userInfo=Info[0];
	var catInfo=Info[1];
	var payModeInfo=Info[2];
	try
	{
		var xlsrow=1
		var xlApp,xlsheet,xlBook;
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		var userArr=userInfo.split("^");
		xlsheet.cells(2,2)=userArr[0];
		xlsheet.cells(30,2)=userArr[0];
		xlsheet.cells(2,7)=userArr[2]+"---"+userArr[1];
		xlsheet.cells(30,7)=userArr[2]+"---"+userArr[1];
		xlsheet.cells(51,1)=userArr[3]+xlsheet.cells(51,1)+userArr[4];
		xlsheet.cells(52,2)=userArr[5];
		var catArr=catInfo.split(Char_1);
		var i=catArr.length;
		for (var j=0;j<i;j++)
		{
			
			//if (j<i-1){
				var row=5+j
			//}else{
				//var row=20
			//}	
			var oneCatInfo=catArr[j];
			var oneCatArr=oneCatInfo.split("^");
			var k=oneCatArr.length;
			
			for (var l=0;l<k;l++)
			{
				//if (l<k-1){
					xlsheet.cells(row,l+1)=oneCatArr[l];
				//}else{
				//	xlsheet.cells(row,9)=oneCatArr[l];
				//}
					
				
			}
			
		}
		var modeArr=payModeInfo.split(Char_1);
		var i=modeArr.length;
		for (var j=0;j<i;j++)
		{
			
			//if (j<i-1){
				var row=33+j
			//}else{
			//	var row=50
			//}	
			var oneCatInfo=modeArr[j];
			var oneCatArr=oneCatInfo.split("^");
			var k=oneCatArr.length;
			for (var l=0;l<k;l++)
			{
				//if (l<k-1){
					xlsheet.cells(row,l+1)=oneCatArr[l];
				//}else{
				//	xlsheet.cells(row,8)=oneCatArr[l];
				//}
					
				
			}
			
		}
		
		
	}
	catch(e) 
	{
		alert(e.message);
	}
	xlsheet.printout(1,1,1,false,"TJReport");
	
	CloseExcel(xlApp,xlBook,xlsheet);
}
document.body.onload = BodyLoadHandler;