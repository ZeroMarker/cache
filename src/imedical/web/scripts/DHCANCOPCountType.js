//DHCANCOPCountType.JS

var SelectedRow = 0;
var preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('BADD')
	if(obj) obj.onclick=BADD_click;
	var obj=document.getElementById('BUpdate')
	if(obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById('BDelete')
	if(obj) obj.onclick=BDelete_click;
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCOPCountType');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var objSelrow=document.getElementById("selrow");
    objSelrow.value=selectrow;
	if (!selectrow) return;
	var obj=document.getElementById('CountTypeId');
	var obj1=document.getElementById('Code');
	var obj2=document.getElementById('Desc');	
	
	var SelRowObj=document.getElementById('TypeIdz'+selectrow);
	var SelRowObj1=document.getElementById('TypeCodez'+selectrow);
	var SelRowObj2=document.getElementById('TypeDescz'+selectrow);

	if (preRowInd==selectrow){
	   	obj.value="";
		obj1.value="";
		obj2.value="";
   		preRowInd=0;
    }
   	else{
		if (obj) obj.value=SelRowObj.innerText;
		if (obj1) obj1.value=SelRowObj1.innerText;
		if (obj2) obj2.value=SelRowObj2.innerText;
		preRowInd=selectrow;
		var TypeId=SelRowObj.innerText;
		var lnk;
    	lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANCOPCountTypeDetail&TypeId="+TypeId;
    	parent.frames[1].location.href=lnk;
     	lnk1= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANCOPCountTypeDefault&TypeId="+TypeId;
    	parent.frames[2].location.href=lnk1;   	 
   }
   return;
}
	
	
function BADD_click(){
	var Code="",Desc="";
	var obj=document.getElementById('Code')
	if(obj) Code=obj.value;
	if(Code==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('Desc')
	if(obj) var Desc=obj.value;
	if(Desc==""){
		alert(t['02']) 
		return;
		}

	var obj=document.getElementById('RepType')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,Code)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	var obj=document.getElementById('AddType')
	if(obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,Code,Desc);
    if (ret!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BUpdate_click(){
	if(preRowInd<1)return;
	var Code="",Desc="";
	var obj=document.getElementById('CountTypeId')
	if(obj) var CountTypeId=obj.value;
	if(CountTypeId==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('Code')
	if(obj) var Code=obj.value;
	if(Code==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('Desc')
	if(obj) var Desc=obj.value;
	if(Desc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('UpdateType')
	if(obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,CountTypeId,Code,Desc);
	if (ret!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BDelete_click(){

	if(preRowInd<1)return;
	var obj=document.getElementById('CountTypeId')
	if(obj) var CountTypeId=obj.value;
	if(CountTypeId==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('DeleteType')
	if(obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,CountTypeId);
	if (ret!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
document.body.onload=BodyLoadHandler;