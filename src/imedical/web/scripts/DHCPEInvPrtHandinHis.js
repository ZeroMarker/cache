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
	var SelectedRow="-1";
	var tid;
	
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
	//Footobj=document.getElementById('Foot');
	Printobj=document.getElementById('Print');
	//Findobj=document.getElementById('Find');
	PDFootDetailobj=document.getElementById('PDFootDetail');
	Pamtobj=document.getElementById('Pamt');
	Ramtobj=document.getElementById('Ramt');
	today=document.getElementById('ToDay').value;
	
	if (Printobj) Printobj.onclick = Print_Click;
	if (PDFootDetailobj) PDFootDetailobj.onclick = PDFootDetail_Click;
	
	
	//getpath();
	//gettoday();
	
    setreadonly();
    DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEUserRpt");
    
     
    
}

function setreadonly()
{
	StartDateobj.readOnly=true;
	StartTimeobj.readOnly=true;
	EndDateobj.readOnly=true;
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
	//getPDbyUser();
	}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc)
	var Objtbl=document.getElementById('tDHCPEInvPrtHandinHis');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	//var obj=document.getElementById('Adm');
	
	if (selectrow!=SelectedRow) {
		
	var SelRowObj=document.getElementById('TIDz'+selectrow);
	tid=SelRowObj.value;
	
	getPDbyFootInfo(tid);
	SelectedRow=selectrow;
	}
	else{
		
		SelectedRow="-1";
		tid=""
		ClearVal()
		
		}
	//alert(SelectedRow);
}
function Print_Click()
{
	
	var obj;
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+"DHCPEUserRpt.xlsx";
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var StartDate="",EndDate="",StartTime="",EndTime="",AmtSum="",CashAmt="",ChequeAmt="",OtherAmt="",Pamt="",Ramt="",ReceiptsNum=""
	var RefundNum="",ReceiptsField="",RefInvNo=""
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
    xlsheet.cells(1,1).Value=HosName;
	obj=document.getElementById('StartDate');
	if(obj){var StartDate=obj.value;}
	obj=document.getElementById('StartTime');
	if(obj){var StartTime=obj.value;}
	obj=document.getElementById('EndDate');
	if(obj){var EndDate=obj.value;}
	obj=document.getElementById('EndTime');
	if(obj){var EndTime=obj.value;}
	obj=document.getElementById('AmtSum');
	if(obj){var AmtSum=obj.value;}
	obj=document.getElementById('ReceiptsNum');
	if(obj){var ReceiptsNum=obj.value;}
	obj=document.getElementById('ReceiptsField');
	if(obj){var ReceiptsField=obj.value;}
	obj=document.getElementById('CashAmt');
	if(obj){var CashAmt=obj.value;}
	obj=document.getElementById('ChequeAmt');
	if(obj){var ChequeAmt=obj.value;}
	obj=document.getElementById('OtherAmt');
	if(obj){var OtherAmt=obj.value;}
	obj=document.getElementById('Pamt');
	if(obj){var Pamt=obj.value;}
	obj=document.getElementById('Ramt');
	if(obj){var Ramt=obj.value;}
	obj=document.getElementById('RefundNum');
	if(obj){var RefundNum=obj.value;}
	obj=document.getElementById('RefInvNo');
	if(obj){var RefInvNo=obj.value;}
	
	xlsheet.cells(2,1).Value="开始日期";
	xlsheet.cells(2,2).Value=StartDate;
	xlsheet.cells(3,1).Value="结束日期";
	xlsheet.cells(3,2).Value=EndDate;
	xlsheet.cells(2,5).Value="开始时间";
	xlsheet.cells(2,6).Value=StartTime;
	xlsheet.cells(3,5).Value="结束时间";
	xlsheet.cells(3,6).Value=EndTime;
	xlsheet.cells(4,1).Value="结算总金额";
	xlsheet.cells(4,2).Value=AmtSum;
	xlsheet.cells(4,5).Value="现金金额";
	xlsheet.cells(4,6).Value=CashAmt;
	xlsheet.cells(5,1).Value="收款金额";
	xlsheet.cells(5,2).Value=Pamt;
	xlsheet.cells(5,5).Value="支票金额";
	xlsheet.cells(5,6).Value=ChequeAmt;
	
	xlsheet.cells(6,1).Value="退款金额";
	xlsheet.cells(6,2).Value=Ramt;
	xlsheet.cells(6,5).Value="其他金额";
	xlsheet.cells(6,6).Value=OtherAmt;
	
	xlsheet.cells(7,1).Value="收据张数";
	xlsheet.cells(7,2).Value=ReceiptsNum;
	xlsheet.cells(7,5).Value="退款收据张数";
	xlsheet.cells(7,6).Value=RefundNum;
	
	xlsheet.cells(8,1).Value="收据号段";
	xlsheet.cells(8,2).Value=ReceiptsField;
	xlsheet.cells(9,1).Value="被冲红的收据号";
	xlsheet.cells(9,2).Value=RefInvNo;
	
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	}



function PDFootDetail_Click()
{	
	if (tid!=""){
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEInvPrtDetail&USERID='+Guser+'&FOOTID='+tid;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0')
	}
	}	
function getPDbyUser()
{
    
		if (Guser!=""){
			p1=Guser
			var getregno=document.getElementById('FindClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,p1)
				if (rtn=="-2"){
					//alert(t[2047]);
					return;
					}
			    setpdinfo_val(rtn);
			}
	
	}

function setpdinfo_val(value)
	{
		//footnum_"^"_refundnum_"^"_footsum_"^"_pdsum_"^"_refundsum_"^"_cashsum_"^"_chequesum_"^"_othersum_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr
	//	alert(value)
		
		var val=value.split("^");
		if (val[0]=="0"){
			//alert(t[2047])
			return;
			}
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
		}
function ClearVal()
{
	StartDateobj.value="";
	StartTimeobj.value="";
	EndDateobj.value="";
	EndTimeobj.value="";
	AmtSumobj.value="";
	ReceiptsNumobj.value="";
	RefundNumobj.value="";
	ReceiptsFieldobj.value="";
	CashAmtobj.value="";
	ChequeAmtobj.value="";
	OtherAmtobj.value="";
	Pamtobj.value="";
	Ramtobj.value="";
	refinvnoobj.value="";
	}
function getPDbyFootInfo(footid)
{
	ClearVal()
	if (footid!=""){
			p1=footid
			
			var getregno=document.getElementById('getPDbyFootIDClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,p1)
				
				if (rtn=="-2"){
					alert(t[2047]);
					return;
					}
			    setpdinfo_val(rtn);
			}
	}
document.body.onload = BodyLoadHandler;