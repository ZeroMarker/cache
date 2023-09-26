
var selectrow=0
var confirmFlag,rowid,tstno,tendno,tcurno,tgruser,ttitle,trctpLoc,treturnFlag
function BodyLoadHandler() {	
	
	Guser=session['LOGON.USERNAME']
	document.getElementById('user').value=Guser;
	var ConfirmObj=document.getElementById('Confirm')
	if(ConfirmObj)ConfirmObj.onclick=ConfirmObj_click
	var ReturnObj=document.getElementById('Return')
	if(ReturnObj)ReturnObj.onclick=Return_click
}

function ConfirmObj_click()
{
	
    var confirmObj=document.getElementById("confirmCheck")
	if(confirmObj)
	 {var encmeth=confirmObj.value}
	else {var encmeth=''}
	
	if(selectrow==0)
	{
		alert("请选择一行数据!")
		return
	}
	if(confirmFlag!=" ")
	{
		alert("该信息已经审核!")
		return
	}
	var rs=cspRunServerMethod(encmeth,"","",rowid)
     if(rs==0)
	  {
		  alert("审核成功!")
		  //window.location.reload();
		  Find_click();
	  }
	  else
	  {
	    alert("审核失败!")
	    return
	  }


}
function Return_click()
{
	if(selectrow==0)
	{
		alert("请选择一行记录!")
		return
	}
	if(treturnFlag!=" ")
	{
		alert("该记录已经退回,不能重复退回!")
		return
	}	
	var rtnBack=document.getElementById("returnBack")	
	if(rtnBack)
	 {var encmeth=rtnBack.value}
	else {var encmeth=''}
	if(confirm("确定要退回吗?"))
	{ 
    var HospDr=session['LOGON.HOSPID'];
	var rs=cspRunServerMethod(encmeth,"","",confirmFlag,rowid,tstno,tendno,tcurno,tgruser,ttitle,trctpLoc,HospDr)
	
	if(rs==0)
	  {
		  alert("退回成功!")
		  //window.location.reload();
		  Find_click();
	  }
	  else
	  {
	    alert("退回失败!")
	  }
	}
}
function SelectRowHandler()
{
   var eSrc=window.event.srcElement;	
   var rowObj=getRow(eSrc);
   selectrow=rowObj.rowIndex;
    if(selectrow==0) return
    var SelRowObj=document.getElementById('TconfirmFlagz'+selectrow);	
    confirmFlag=SelRowObj.innerText;
    var SelRowObj=document.getElementById('Trowidz'+selectrow);	
    rowid=SelRowObj.innerText;
    var SelRowObj=document.getElementById('Tstnoz'+selectrow);	
    tstno=SelRowObj.innerText;
    var SelRowObj=document.getElementById('Tendnoz'+selectrow);	
    tendno=SelRowObj.innerText;
    var SelRowObj=document.getElementById('Tcurnoz'+selectrow);	
    tcurno=SelRowObj.innerText;
    var SelRowObj=document.getElementById('Tgruserz'+selectrow);	
    tgruser=SelRowObj.innerText;
    var SelRowObj=document.getElementById('Ttitlez'+selectrow);	
    ttitle=SelRowObj.innerText;
    var SelRowObj=document.getElementById('TrctpLocz'+selectrow);	
    trctpLoc=SelRowObj.innerText;
    
    var SelRowObj=document.getElementById('TreturnFlagz'+selectrow);	
    treturnFlag=SelRowObj.innerText;
    


}
document.body.onload = BodyLoadHandler; 