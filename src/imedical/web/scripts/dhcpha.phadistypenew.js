
function BodyLoadHandler()
{
	var obj=document.getElementById("OK");
	if (obj) obj.onclick=Modify;
	var obj=document.getElementById("Cancel");
	if (obj) obj.onclick=Cancel;
	
	}
function Cancel()
{ window.close();
	}
	

function Modify()
{ //insert or update one record
//
  var rowid ;
  var code;
  var desc;
  
  var obj=document.getElementById("Rowid");
  if (obj) rowid =obj.value; 
  var obj=document.getElementById("Code");
  if (obj) code =obj.value; 
  var obj=document.getElementById("Desc");
  if (obj) desc =obj.value;
  //Config----------
  var prtTotal=0;prtDetail=0;prtOther="";ispack=0;reserve=0,reqflag=0,prtResRet=0,isPreView=0,prtNoStock=0
  
  var objPrtTotal=document.getElementById("PrtTotal");
  if (objPrtTotal) {if (objPrtTotal.checked) {var prtTotal=1} }
  
  var objPrtDetail=document.getElementById("PrtDetail");
  if (objPrtDetail) {if (objPrtDetail.checked) {var prtDetail=1} }
  
  var objPrtOther=document.getElementById("PrtOther");
  if (objPrtOther)  prtOther =objPrtOther.value;
  
  var objIsPack=document.getElementById("IsPack");
  if (objIsPack)  {if (objIsPack.checked) {ispack=1} };
  
  var objReserve=document.getElementById("Reserve");
  if (objReserve)  {if (objReserve.checked) {reserve=1} };
  
  var objReqFlag=document.getElementById("ReqFlag");
  if (objReqFlag)  {if (objReqFlag.checked) {reqflag=1} };
  //add wyx 2014-12-01
  var objPrtResRet=document.getElementById("PrtResRet");
  if (objPrtResRet) {if (objPrtResRet.checked) {var prtResRet=1} }
  //add wyx 2014-12-01
  var objIsPreView=document.getElementById("IsPreView");
  if (objIsPreView) {if (objIsPreView.checked) {var isPreView=1} } 
  //add wyx 2014-12-02
  var objPrtNoStock=document.getElementById("PrtNoStock");
  if (objPrtNoStock) {if (objPrtNoStock.checked) {var prtNoStock=1} }   
  
  var ConfigStr=code+"^"+prtDetail+"^"+prtTotal+"^"+trim(prtOther)+"^"+prtResRet+"^"+isPreView+"^"+prtNoStock
  var ConfigStr=ConfigStr+"@"+ispack+"@"+reserve+"@"+reqflag
  
  if (rowid>0)
	  {var ret=Update(rowid,code,desc,ConfigStr)  ;
	  if (ret==false) 
	  {alert(t['UPDATE_ERROR']) ;
	    	 return ;	}
	  }
  else
  	{var ret=Insert(code,desc,ConfigStr);
  	 if (ret==false)
  	 {alert(t['INSERT_ERROR']) ;
  	 return ;
  	 }
	}	
  opener.location.reload();
  window.close();
}
function Insert(code,desc,ConfigStr)
{
	var obj=document.getElementById("mInsert")
	if (obj) {	var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,code,desc,ConfigStr) ;
	if (result<=0) return false
	return true
	
	}
function Update(rowid,code,desc,ConfigStr)
{
	var obj=document.getElementById("mUpdate");
	if (obj) {	var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,rowid,code,desc,ConfigStr) ;
	if (result<=0) return false
	return true
	
}
document.body.onload=BodyLoadHandler;
