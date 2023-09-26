var SelectedRow=0

function BodyLoadHandler() 
{
	 
	 var flag=document.getElementById("flag").value
	
	/* if (flag=="UDHCJFopapprov"){
         var obj=document.getElementById("ok");
         obj.Visible=true
         if (obj) obj.onclick = Linktoappr;
         }
     else {
	     var obj=document.getElementById("ok");
         obj.Visible=false
	     }*/
	     
     var obj=document.getElementById("insert");
     obj.onclick = put_in;
     var obj=document.getElementById("refresh");
     obj.onclick = put_up;
     var obj=document.getElementById("clear");
     obj.onclick = cancel;
     var obj=document.getElementById("del");
     obj.onclick = del_down; 
	 
}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc)
	Objtbl=document.getElementById('tUDHCJFOPAppCn');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

    var opacobj=document.getElementById("opac")
	var opacidobj=document.getElementById("opacid")
	var minamtobj=document.getElementById("minamt")
	var datefrmobj=document.getElementById("datefrm")
    var datetoobj=document.getElementById("dateto")
    
    if (selectrow==0){
    opacobj.readOnly=false
    datefrmobj.readOnly=false}
    else{
    opacobj.readOnly=true
    datefrmobj.readOnly=true
        }
	if (selectrow!=SelectedRow) {
	   var SelRowObj=document.getElementById('Topacz'+selectrow);
	      opacobj.value=SelRowObj.innerText;
	       
	   var SelRowObj=document.getElementById('Topacidz'+selectrow);
	       opacidobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tminamtz'+selectrow);
	       minamtobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tdatefrmz'+selectrow);
	       datefrmobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tdatetoz'+selectrow);
	       datetoobj.value=SelRowObj.innerText;
	    
	    SelectedRow=selectrow   
	}
	else{
		opacobj.value=""
		opacidobj.value=""
		minamtobj.value=""
		datefrmobj.value=""
		datetoobj.value=""
		opacobj.readOnly=false
        datefrmobj.readOnly=false
	    SelectedRow=0
		}
}

function cancel(){
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPAppCn";
	}
function put_in(){

	if (document.getElementById("opacid").value!="")   return;
	var opac=document.getElementById("opac").value
	var minamt=document.getElementById("minamt").value
	var datefrm=document.getElementById("datefrm").value
	var dateto=document.getElementById("dateto").value

	if ((opac=="")||(datefrm=="")) {alert(t['01']);return;}
	
	
	
	var P1=opac+"^"+minamt+"^"+datefrm+"^"+dateto

	
	 var putin=document.getElementById('putin');
	if (putin) {var encmeth=putin.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,P1)

    if (num==0){
	   
	    location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPAppCn";
	    }
	else{ alert(t['02'])}
	
	}
function del_down(){
	if (SelectedRow==0)  return;
	
	 var SelRowObj=document.getElementById('Topacidz'+SelectedRow);
	 var opac=SelRowObj.innerText;
	
	var putout=document.getElementById('setout');
	if (putout) {var encmeth=putout.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,opac) 
	if (num==0) {
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPAppCn"
	    }
	else{ 
	 if (num==100)   alert(t['05']);
	 else   alert(t['06']);
	 }
	
	}
function put_up(){
	if (SelectedRow==0) return;
    var SelRowObj=document.getElementById('Tdatetoz'+SelectedRow);
    var dateto=SelRowObj.innerText;
    var SelRowObj=document.getElementById('Tminamtz'+SelectedRow);
    var minsum=SelRowObj.innerText;
    var enddate=document.getElementById("dateto").value
    var minamt=document.getElementById("minamt").value
    
    if ((enddate==dateto)&&(minamt==minsum)) return;
    
    var SelRowObj=document.getElementById('Topacidz'+SelectedRow);
	var opacid=SelRowObj.innerText;  
	var refresh=document.getElementById('update');
	if (refresh) {var encmeth=refresh.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,enddate,minamt,opacid)
	if (num==0) {

	    location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPAppCn";   
	}
	else{alert(t['03'])}	
	
	}
function Linktoappr()
{  
  if (SelectedRow==0) {alert(t['04']);return;}
   var SelRowObj=document.getElementById('Topacidz'+SelectedRow)
   var opacid=SelRowObj.innerText

  window.opener.location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFopapprov&opacid='+opacid
  window.close 
    
}



document.body.onload = BodyLoadHandler;