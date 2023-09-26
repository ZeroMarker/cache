var Guser
function BodyLoadHandler() 
{ 
  
  Guser=session['LOGON.USERID']
 }
 function SelectRowHandler()	
{  	var stdate,enddate
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCOPBillRecDetail');
	Rows=Objtbl.rows.length;
	
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	SelRowObj=document.getElementById('TRecIdz'+selectrow);
	stdate=document.getElementById('TStDatez'+selectrow).innerText;
	enddate=document.getElementById('TEndDatez'+selectrow).innerText;
	sttime=document.getElementById('TStTimez'+selectrow).innerText;
	endtime=document.getElementById('TEndTimez'+selectrow).innerText;
	var year,mon,day
	var str=stdate.split("-")
	year=str[0],mon=str[1],day=str[2]
	stdate=day+"/"+mon+"/"+year
	var str=enddate.split("-")
	year=str[0],mon=str[1],day=str[2]
	enddate=day+"/"+mon+"/"+year
    var jsrowid=SelRowObj.innerText;
    var flag=document.getElementById("Flag").value;
    if (flag=="Inv")
    {  window.opener.document.getElementById("StDate").value=stdate
       window.opener.document.getElementById("EndDate").value=enddate
       window.opener.document.getElementById("RecDr").value=jsrowid
       window.opener.location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOP_Footin&StDate="+stdate+"&EndDate="+enddate+"&StartTime="+sttime+"&EndTime="+endtime+"&RecDr="+jsrowid+"&StatFlag="+"Y";}
    else if (flag=="Acc")
    {  
       window.opener.document.getElementById("StDate").value=stdate
       window.opener.document.getElementById("EndDate").value=enddate
       window.opener.document.getElementById("RecDr").value=jsrowid
       window.opener.location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPPreDepositHz&StDate="+stdate+"&EndDate="+enddate+"&Guser="+Guser+"&Handin="+"on"+"&RecDr="+jsrowid;}
   
    window.close();
   // 
}
  document.body.onload = BodyLoadHandler;