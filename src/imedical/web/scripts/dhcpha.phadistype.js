

function BodyLoadHandler()
{
	var obj=document.getElementById("Add");
	if (obj) obj.onclick=AddRow;
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteRow;

	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateRow;
	
	var obj=document.getElementById("Exit");
	if (obj) obj.onclick=Exit;
	
	//setTimer();
	}
function AddRow()
{
	var link="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadistypenew"
	window.open(link,"_TARGET","height=400,width=600,menubar=no,status=no,toolbar=no,resizable=yes")
//	window.showModalDialog(link,"_TARGET","height=120,width=400,menubar=no,status=no,toolbar=no")
	
	}
function UpdateRow()
{  // get rowid 

	var row ;
	var obj=document.getElementById("currentRow") ;
	if (obj) row=obj.value ;
	if (row>0) {
		var rowid;
		var code;
		var desc;
		
		var obj2=document.getElementById("tRowid"+"z"+row)
		if (obj2) 
		{rowid=obj2.value}
		
		var obj3=document.getElementById("tCode"+"z"+row)
		if (obj3) 
		{code=obj3.innerText}
		
		var obj4=document.getElementById("tDesc"+"z"+row)
		if (obj4) 
		{desc=obj4.innerText}
		
		var objPrtDetail=document.getElementById("tPrtDetail"+"z"+row)
		if (objPrtDetail.checked) 
			{var prtDetail=1}
		else
			{var prtDetail=0}
		
		var objPrtTotal=document.getElementById("tPrtTotal"+"z"+row)
		if (objPrtTotal.checked) 
			{var prtTotal=1}
		else
			{var prtTotal=0}
		
		
		var objPrtOther=document.getElementById("tPrtOther"+"z"+row)
		if (objPrtOther) 
		{prtOther=objPrtOther.innerText}
		
		
		var objIsPack=document.getElementById("tIsPack"+"z"+row)
		if (objIsPack.checked) 
			{var IsPack=1}
		else
			{var IsPack=0}
		
			
	    var objReserve=document.getElementById("tReserve"+"z"+row)
		if (objReserve.checked) 
			{var Reserve=1}
		else
			{var Reserve=0}
			
			
		var objReqFlag=document.getElementById("tReqFlag"+"z"+row)
		if (objReqFlag.checked) 
			{var ReqFlag=1}
		else
			{var ReqFlag=0}
              //add wyx 2014-12-01
		var objPrtResRet=document.getElementById("tPrtResRet"+"z"+row)
		if (objPrtResRet.checked) 
			{var prtResRet=1}
		else
			{var prtResRet=0}
		//add wyx 2014-12-01
		var objIsPreView=document.getElementById("tIsPreView"+"z"+row)
		if (objIsPreView.checked) 
			{var isPreView=1}
		else
			{var isPreView=0}
		//add wyx 2014-12-02
		var objPrtNoStock=document.getElementById("tPrtNoStock"+"z"+row)
		if (objPrtNoStock.checked) 
			{var prtNoStock=1}
		else
			{var prtNoStock=0}		
		if (rowid>0) {
			var link="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadistypenew&Rowid="+rowid+"&Code="+code+"&Desc="+desc+"&PrtTotal="+prtTotal+"&PrtDetail="+prtDetail+"&PrtOther="+prtOther+"&IsPack="+IsPack+"&Reserve="+Reserve+"&ReqFlag="+ReqFlag+"&PrtResRet="+prtResRet+"&IsPreView="+isPreView+"&PrtNoStock="+prtNoStock
		    window.open(link,"_TARGET","height=400,width=600,menubar=no,status=no,toolbar=no,resizable=yes")
		}
	}
}
function DeleteRow()
{
  var currRow;
  var obj=document.getElementById("currentRow")	
  if (obj) currRow=obj.value;
 if (currRow>0)
 {   
 	 var rowid;
	 var obj=document.getElementById("tRowid"+"z"+currRow);
	 if (obj) 	 rowid=obj.value; 
	 if (rowid>0)
	 {
		 var ret=confirm(t['IF_DELETE']);
		 if (ret==true)
		 {
		 	var objdel=document.getElementById("mDelete")
			if (objdel) {	var encmeth=objdel.value;}	else {var encmeth='';}
			var result=cspRunServerMethod(encmeth,rowid) ;
			if (result<=0)
			{alert(t['FAIL_DELETE']) ;
			}
			window.location.reload();
		 }
	 }
 } 
}

function Exit()
{
	history.back();
	//
	//parent.close();
}

function SelectRowHandler()
 {
	var row=selectedRow(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row

   //retrieve ordcat
   RetrieveOrdCat(row);
}
function RetrieveOrdCat(row)
{
	var obj=document.getElementById("tRowid"+"z"+row)
	if (obj) var rowid=obj.value;
			
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadistypeordcat&distype="+rowid	
	parent.frames['dhcpha.phadistypeordcat'].location.href=lnk;
	
}
function setTimer()
{
	var xx=0;
	waitTime=10000; //10 Ãë 
    timer=setInterval("OnTimer()",4000); 

}

function OnTimer(){ 
    waitTime=waitTime-1000; 
    if(waitTime==0){ 
        window.close(); 
    }
  //  txtTimer.value=waitTime/1000+"Ãë"; 
  //  xx=xx+6;
  //  
    var link=window.location
   window.open(link,"_TARGET");
	//window.showModalDialog("")
 //   window.focus();
}

document.body.onload=BodyLoadHandler