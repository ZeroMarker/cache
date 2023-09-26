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
	
	UserCountobj=document.getElementById('UserCount');
	UserInfoobj=document.getElementById('UserInfo');
	CashNormalobj=document.getElementById('CashNormal');
	CashRefundobj=document.getElementById('CashRefund');
	rptTypeobj=document.getElementById('RptType');
	RowIdobj=document.getElementById('RowID');
	
	
	if (Findobj) Findobj.onclick = Find_Click;
		
	if (Footobj) 
	{
		Footobj.onclick = Foot_Click;
		if (""!=RowIdobj.value)	
		{	Footobj.disabled=true;	}
	}
	if (Printobj) 
	{
		Printobj.onclick = Print_Click;
		if ((""==RowIdobj.value)&&("1"==rptTypeobj.value))
		{	Printobj.disabled=true;}
	}
	if (PDFootDetailobj) PDFootDetailobj.onclick = PDFootDetail_Click;
		
	//getpath();
	//gettoday();
	
    setreadonly();
    DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEUserRpt");
}

function setreadonly()
{
	//StartDateobj.readOnly=true;
	//EndDateobj.readOnly=true;
	if ("1"==rptTypeobj.value)
	{		
		StartDateobj.disabled=true;
		EndDateobj.disabled=true;
	}
	else
	{
		HiddenElement("StartTime",0,1);
		HiddenElement("EndTime",0,1);
		HiddenElement("ReceiptsField",1,1);
		HiddenElement("RefInvNo",1,1);
		HiddenElement("Foot");
		HiddenElement("PDFootDetail");
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
	//alert(begindate);
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

function Print_Click()
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
		//现金信息
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[16];
		xlsheet.cells(xlsrow,5)=val[17];
		xlsheet.cells(xlsrow,6)=val[5];
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
		xlsheet.cells(xlsrow,4)=val[2];
		xlsheet.cells(xlsrow,9)=paysum;
		//借贷合计信息
		xlsrow=xlsrow+2;
		xlsheet.cells(xlsrow,2)="1"+xlsheet.cells(xlsrow,2);
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
{
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
		
		///var val=value.split("^");
	if (val[0]=="0")
	{	if (rptTypeobj.value=="1") alert(t[2047]);
		if (rptTypeobj.value=="2") alert(t[2046]);
		return;		}
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

document.body.onload = BodyLoadHandler;