
var SelectedRow = 0;
var Guser
function BodyLoadHandler() 
{  
  Guser=document.getElementById("MyGuser").value   //session["LOGON.USERID"];
}
 function SelectRowHandler()	
{  	var stdate,enddate
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById("tUDHCJFOPDayRptHis");
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelRowObj=document.getElementById("RowIdz"+selectrow);
	stdate=document.getElementById("Tstdatez"+selectrow).innerText;
	enddate=document.getElementById("Tenddatez"+selectrow).innerText;
	sttime=document.getElementById("Tsttimez"+selectrow).innerText;
	endtime=document.getElementById("Tendtimez"+selectrow).innerText;
	job=document.getElementById("Tjobz"+selectrow).innerText;
	jkDr=document.getElementById("RowIdz"+selectrow).innerText;
	var hospDr=session['LOGON.HOSPID'];
	var year,mon,day
	//var str=stdate.split("-")
	//year=str[0],mon=str[1],day=str[2]
	//stdate=day+"/"+mon+"/"+year
	//var str=enddate.split("-")
	//year=str[0],mon=str[1],day=str[2]
	//enddate=day+"/"+mon+"/"+year
    var jsrowid=SelRowObj.innerText;
    var flag=document.getElementById("findflag").value;
    if (flag=="INV")
    {  alert("1111")
       window.opener.document.getElementById("StDate").value=stdate
       window.opener.document.getElementById("EndDate").value=enddate
       window.opener.document.getElementById("Handin").checked=true
       var obj=window.opener.document.getElementById("BHandin");
	   DHCWeb_DisBtn(obj);
       window.opener.location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPInvDaily&StDate="+stdate+"&EndDate="+enddate+"&Guser="+Guser+"&Handin="+"on"+"&JkDr="+jsrowid+"&StartTime="+sttime+"&EndTime="+endtime; 
    }else if (flag=="PreDept"){
	    alert("2222")
       window.opener.document.getElementById("StDate").value=stdate
       window.opener.document.getElementById("EndDate").value=enddate
       window.opener.document.getElementById("Handin").checked=true 
       window.opener.location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPPreDepositDaily&StDate="+stdate+"&EndDate="+enddate+"&Guser="+Guser+"&Handin="+"Y"+"&JkDr="+jsrowid;  
     }else{
	   Guser=document.getElementById("MyGuser").value
	   //alert(Guser)
	   window.opener.parent.frames('DHCOPBillDailySearch').document.getElementById("StDate").value=stdate
       window.opener.parent.frames('DHCOPBillDailySearch').document.getElementById("EndDate").value=enddate
       window.opener.parent.frames('DHCOPBillDailySearch').document.getElementById("StTime").value=sttime
       window.opener.parent.frames('DHCOPBillDailySearch').document.getElementById("EndTime").value=endtime
       window.opener.parent.frames('DHCOPBillDailySearch').document.getElementById("Guser").innerText=Guser
       window.opener.parent.frames('DHCOPBillDailySearch').document.getElementById("job").innerText=job
       window.opener.parent.frames('DHCOPInvDaily').location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPInvDaily&stDate="+stdate+"&stTime="+sttime+"&endDate="+enddate+"&endTime="+endtime+"&handin=true"+"&job="+job+"&jkDr="+jsrowid+"&guser="+Guser+"&hospDr="+hospDr;  
       window.opener.parent.frames('DHCOPPreDepositDaily').location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPPreDepositDaily&stDate="+stdate+"&stTime="+sttime+"&endDate="+enddate+"&endTime="+endtime+"&handin=true"+"&job="+job+"&jkDr="+jsrowid+"&guser="+Guser+"&hospDr="+hospDr;
	 }   
    window.close();
 }
 document.body.onload = BodyLoadHandler