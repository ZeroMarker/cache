var job,RecDr
function BodyLoadHandler() { 
  gusercode=session['LOGON.USERCODE'] 
  var prt=document.getElementById("Print");
  if (prt){
     prt.onclick=Print_click;	  
  }  
  
  var obj=document.getElementById("receipt");
  if (obj){
     obj.onclick=receipt_click;	  
  }
  var obj=document.getElementById("Handin");
  if (obj){
     obj.onclick=RecHis_click;	  
  }
  var obj=document.getElementById("LinkRec");
    DHCWeb_DisBtn(obj);
  job=document.getElementById("job");
 
}

function Print_click()
{  //UDHCJFOPPreDepositHz
   var SelRowObj=document.getElementById('Jobz'+1);
   var mmm=SelRowObj.innerText;
   document.getElementById('job').value=mmm
   //job=SelRowObj.innerText;   
   //alert(RecDr)    
   CommonPrint("UDHCJFOPPrtDeptHz");      
}
function receipt_click()
{
   var StDate=document.getElementById("StDate").value
   var EndDate=document.getElementById("EndDate").value
   var Guser=session['LOGON.USERID']
   var getrec=document.getElementById('getreceipt');
   if (getrec) {var encmeth=getrec.value} else {var encmeth=''};
   if (cspRunServerMethod(encmeth,StDate,EndDate,Guser)==0){
		 alert(t['01'])
   }
}
function getuserid(value)	{
	var user=value.split("^");
	var obj=document.getElementById('userid');
	obj.value=user[1];
	
}
function RecHis_click(){
	var obj=document.getElementById("Handin")
	if (obj.checked==true) 
	{
		var obj=document.getElementById("receipt");
		DHCWeb_DisBtn(obj);
		var obj=document.getElementById("LinkRec");
			if (obj)
			{	obj.disabled=false;
				obj.onclick=LinkRec_Click;
			}
	
	}else{
		document.getElementById("RecDr").value==""
		 var obj=document.getElementById("LinkRec");
		 DHCWeb_DisBtn(obj);
		 var obj=document.getElementById("receipt");
			if (obj)
			{	obj.disabled=false;
				obj.onclick=receipt_click;
			}
		
		
	}
	}
function LinkRec_Click(){
       var obj=document.getElementById("StDate");
	   if (obj) var StDate=obj.value;
	   var obj=document.getElementById("EndDate");
	   if (obj) var EndDate=obj.value;      
       var Guser=session['LOGON.USERID']
       var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillRecDetail&StDate='+StDate+'&EndDate='+EndDate+'&Guser='+Guser+"&Flag="+"Acc"
       window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
}
document.body.onload = BodyLoadHandler;