var SelectedRow=0
function BodyLoadHandler() 
{
	 var opacid=document.getElementById("opacid").value
	 
     var obj=document.getElementById("defin");
     obj.onclick = Linktofac;
     var obj=document.getElementById("insert");
     obj.onclick = put_in;
     var obj=document.getElementById("update");
     obj.onclick = put_up;
     var obj=document.getElementById("clear");
     obj.onclick = cancel;
     document.onkeyup=clear
	 var obj=document.getElementById("del");
     obj.onclick = del_down; 
	 
}
function clear(){

	var eSrc=window.event.srcElement;
    if (eSrc.value==""){
	if (eSrc.id=="admreason"){
		document.getElementById("admreasid").value=""
		}
	if (eSrc.id=="ordreason"){
		document.getElementById("ordreasid").value=""
		}
	if (eSrc.id=="disreason"){
		document.getElementById("disreasid").value=""
		}
    }
	}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc)
	Objtbl=document.getElementById('tUDHCJFopapprov');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

    var admreasobj=document.getElementById("admreason")
	var ordreasobj=document.getElementById("ordreason")
	var disreasobj=document.getElementById("disreason")
	var datefrmobj=document.getElementById("datefrm")
    var datetoobj=document.getElementById("dateto")
    var approbj=document.getElementById("apprid")
    var opacobj=document.getElementById("opac")
    var opacidobj=document.getElementById("opacid")
    if (selectrow==0){
    admreasobj.readOnly=false
    ordreasobj.readOnly=false
    disreasobj.readOnly=false
    datefrmobj.readOnly=false
    approbj.value=""}
    else{
	admreasobj.readOnly=true
    ordreasobj.readOnly=true
    disreasobj.readOnly=true
    datefrmobj.readOnly=true
        }
	if (selectrow!=SelectedRow) {
	   var SelRowObj=document.getElementById('Tpatadmreaz'+selectrow);
	   var  admreas=SelRowObj.innerText;
	        admreasobj.value=admreas
	   var SelRowObj=document.getElementById('Tordadmreaz'+selectrow);
	       ordreasobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tdisadmreaz'+selectrow);
	       disreasobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tdatefrmz'+selectrow);
	       datefrmobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tdatetoz'+selectrow);
	       datetoobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tappridz'+selectrow);
	       approbj.value=SelRowObj.value;   
	       
	   var SelRowObj=document.getElementById('Topacidz'+selectrow);
	       opacidobj.value=SelRowObj.value; 
	
	   var SelRowObj=document.getElementById('Topacz'+selectrow);
	       opacobj.value=SelRowObj.innerText; 
	      
	       if (opacobj.value!=""){opacobj.readOnly=true}
	    SelectedRow=selectrow   
	}
	else{
		document.getElementById("admreasid").value=""
		document.getElementById("ordreasid").value=""
		document.getElementById("disreasid").value=""
		document.getElementById("acid").value=""
		approbj.value=""
		opacidobj.value=""
		opacobj.value=""
		admreasobj.value=""
		ordreasobj.value=""
		disreasobj.value=""
		datefrmobj.value=""
		datetoobj.value=""
		admreasobj.readOnly=false
        ordreasobj.readOnly=false
        disreasobj.readOnly=false
        datefrmobj.readOnly=false
		SelectedRow=0
		}
}
function del_down(){
	if (SelectedRow==0)  return;
    var admreasid=document.getElementById("admreasid").value
   
    var SelRowObj=document.getElementById('Tappridz'+SelectedRow);
	       appr=SelRowObj.value;  
	      
	var putout=document.getElementById('setout');
	if (putout) {var encmeth=putout.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,appr) 

	if (num==0) {
	 location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFopapprov&admreasid="+admreasid;
	   }
	else{ alert(t['06'])}
	
	}
function put_in(){

	
	if (document.getElementById("apprid").value!="")   return;
	var admreasid=document.getElementById("admreasid").value
	var ordreasid=document.getElementById("ordreasid").value
	var disreasid=document.getElementById("disreasid").value
	var datefrm=document.getElementById("datefrm").value
	var dateto=document.getElementById("dateto").value
	var opacid=document.getElementById("opacid").value

	if ((admreasid=="")||(ordreasid=="")||(disreasid=="")) {alert(t['01']);return;}
		
	if (datefrm=="") {alert(t['02']);return;}
	
	var P1=admreasid+"^"+ordreasid+"^"+disreasid+"^"+datefrm+"^"+dateto+"^"+opacid

	
	 var putin=document.getElementById('putin');
	if (putin) {var encmeth=putin.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,P1)
     if (num==0)  {
	     location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFopapprov&admreasid="+admreasid;
	   }
      else{ alert(t['04']);}
        

	
	
	}
function cancel(){
	var admreasid=document.getElementById("admreasid")
	var ordreasid=document.getElementById("ordreasid")
	var disreasid=document.getElementById("disreasid")

	var opacid=document.getElementById("opacid")
	
	var admreasobj=document.getElementById("admreason")
	var ordreasobj=document.getElementById("ordreason")
	var disreasobj=document.getElementById("disreason")
	var datefrmobj=document.getElementById("datefrm")
    var datetoobj=document.getElementById("dateto")
    var approbj=document.getElementById("apprid")
    admreasid.value=""
    ordreasid.value=""
    disreasid.value=""
    opacid.value=""
    ordreasobj.value=""
    disreasobj.value=""
    datefrmobj.value=""
    datetoobj.value=""
    approbj.value=""
    admreasobj.value=""
    SelectedRow=0
    
	}
function put_up(){
	if (SelectedRow==0) {alert(t['03']);return;}
    var SelRowObj=document.getElementById('Tdatetoz'+SelectedRow);
    var dateto=SelRowObj.innerText;
    var enddate=document.getElementById("dateto").value
    //if (enddate==dateto) return;

    var SelRowObj=document.getElementById('Tappridz'+SelectedRow);
	var apprid=SelRowObj.value 
	 var SelRowObj=document.getElementById('Topacidz'+SelectedRow);
	var opacid=SelRowObj.value   
	    opacid=opacid.replace(" ","")
	if (opacid=="") {
	          opacid=document.getElementById("opacid").value	} 

	var refresh=document.getElementById('refresh');
	if (refresh) {var encmeth=refresh.value} else {var encmeth=''};	

	var num=cspRunServerMethod(encmeth,enddate,opacid,apprid)
	if (num==0) {
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFopapprov&apprid="+apprid;
	   }
	   else{ alert(t['05']);}
		
	
	}
function Linktofac()
{  
   
   var loc="UDHCJFopapprov"
  var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPAppCn&flag='+loc
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
}

function setadmr(value)
{  var str=value.split("^")
   var obj=document.getElementById("admreasid")
   obj.value=str[1]

	}
function setordr(value){
	var str=value.split("^")
   var obj=document.getElementById("ordreasid")
   obj.value=str[1]
   }
function setdisr(value){
	var str=value.split("^")
   var obj=document.getElementById("disreasid")
   obj.value=str[1]
   }
function setac(value){

	var str=value.split("^")
   var obj=document.getElementById("opacid")
   obj.value=str[1]
   }


document.body.onload = BodyLoadHandler;