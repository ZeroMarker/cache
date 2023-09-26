var SelectedRow=0
function BodyLoadHandler() 
{
	 
	 var opacid=document.getElementById("opacid").value
     var obj=document.getElementById("tarsub")
     obj.onkeyup=clear
     var obj=document.getElementById("insert");
     obj.onclick = put_in;
     var obj=document.getElementById("update");
     obj.onclick = put_up;
     var obj=document.getElementById("del");
     obj.onclick = del_down; 
	 
}
function clear(){
	if (document.getElementById("tarsub").value==""){
		document.getElementById("tarsubid").value=""
		}
	
	}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc)
	Objtbl=document.getElementById('tUDHCJFOPAppCC');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

    var tarsubidobj=document.getElementById("tarsubid")
	var tarsubobj=document.getElementById("tarsub")
	var opaccidobj=document.getElementById("opaccid")
	var minamtobj=document.getElementById("minamt")
	var datefrmobj=document.getElementById("datefrm")
    var datetoobj=document.getElementById("dateto")
    
    if (selectrow==0){
    tarsubobj.readOnly=false
    datefrmobj.readOnly=false
    opaccidobj.value=""}
    else{
    tarsubobj.readOnly=true
    datefrmobj.readOnly=true
        }
	if (selectrow!=SelectedRow) {
	   var SelRowObj=document.getElementById('Topaccidz'+selectrow);
	      opaccidobj.value=SelRowObj.value;
	       
	   var SelRowObj=document.getElementById('Ttarsubz'+selectrow);
	       tarsubobj.value=SelRowObj.innerText;
	   var tarsub=tarsubobj.value
	       tarsub=tarsub.replace(" ","")
	       if (tarsub!=""){ tarsubobj.readOnly=true}
	       
	   var SelRowObj=document.getElementById('Ttarsidz'+selectrow);
	       tarsubidobj.value=SelRowObj.value;
	   var SelRowObj=document.getElementById('Tminamtz'+selectrow);
	       minamtobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tdatefrmz'+selectrow);
	       datefrmobj.value=SelRowObj.innerText;
	   var SelRowObj=document.getElementById('Tdatetoz'+selectrow);
	       datetoobj.value=SelRowObj.innerText;
	    
	    SelectedRow=selectrow   
	}
	else{
		datetoobj.value=""
		datefrmobj.value=""
		minamtobj.value=""
		tarsubidobj.value=""
		opaccidobj.value=""
		tarsubobj.value=""
		tarsubobj.readOnly=false
        datefrmobj.readOnly=false
		SelectedRow=0
		}
	
}
function del_down(){
	if (SelectedRow==0)  return;
	 var opacid=document.getElementById("opacid").value

	 var SelRowObj=document.getElementById('Topaccidz'+SelectedRow);
	 var opaccid=SelRowObj.value
	 
	var putout=document.getElementById('setout');
	if (putout) {var encmeth=putout.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,opaccid) 
	if (num==0) {
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPAppCC&opacid="+opacid;
	    }
	else{ alert(t['04'])}
	
	}
function put_in(){

	var opacc=document.getElementById("opaccid").value
	opacc=opacc.replace(" ","")
	if (opacc!="")  return;
	var opacid=document.getElementById("opacid").value
	var tarsubid=document.getElementById("tarsubid").value
	var minamt=document.getElementById("minamt").value
	var datefrm=document.getElementById("datefrm").value
	var dateto=document.getElementById("dateto").value
    
	if ((opacid=="")||(datefrm=="")||(tarsubid=="")) {alert(t['01']);return;}
	
	
	
	var P1=opacid+"^"+minamt+"^"+datefrm+"^"+dateto+"^"+tarsubid

	
	 var putin=document.getElementById('putin');
	if (putin) {var encmeth=putin.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,P1) 
	
    if (num==0){
	   
	
	    location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPAppCC&opacid="+opacid;
	    }
	else{ alert(t['02'])}
	
	
	}
function put_up(){
	if (SelectedRow==0) return;
	var opacid=document.getElementById("opacid").value
    var SelRowObj=document.getElementById('Tdatetoz'+SelectedRow);
    var dateto=SelRowObj.innerText;
    var SelRowObj=document.getElementById('Tminamtz'+SelectedRow);
    var minsum=SelRowObj.innerText;
    var enddate=document.getElementById("dateto").value
    var minamt=document.getElementById("minamt").value
    

    if ((enddate==dateto)&&(minamt==minsum)) return;
    
    var SelRowObj=document.getElementById('Topaccidz'+SelectedRow);
	var opaccid=SelRowObj.value   
	var refresh=document.getElementById('refresh');
	if (refresh) {var encmeth=refresh.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,enddate,minamt,opaccid)
	if (num==0) {
		
	    location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPAppCC&opacid="+opacid;
	   
	}
	else{alert(t['03'])}		
	
	}


function setid(value){
	
	var str=value.split("^")
   var obj=document.getElementById("tarsubid")
   obj.value=str[1]
 
   }


document.body.onload = BodyLoadHandler;