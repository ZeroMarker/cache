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
	var objtbl=document.getElementById('tDHCANCViewSuperCat');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('OPRRowid');
	var obj1=document.getElementById('Code');
	var obj2=document.getElementById('Desc');
	
	
	var SelRowObj=document.getElementById('RowIdz'+selectrow);
	var SelRowObj1=document.getElementById('TANCVSCCodez'+selectrow);
	var SelRowObj2=document.getElementById('TANCVSCDescz'+selectrow);
	

	if (preRowInd==selectrow){
	   obj.value="";
	obj1.value="";
	obj2.value="";
   		preRowInd=0;
    }
   else{if (obj) obj.value=SelRowObj.innerText;
	if (obj1) obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	preRowInd=selectrow;
   }
	return;
	}
	
	
function BADD_click(){
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
	var obj=document.getElementById('RepOperSuperCat')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,Code)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	var obj=document.getElementById('InsertOperSuperCat')
	if(obj) var encmeth=obj.value;
    if (cspRunServerMethod(encmeth,Code,Desc)!='0')
		{alert(cspRunServerMethod(encmeth,Code,Desc));
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BUpdate_click(){
	if(preRowInd<1)return;
	var obj=document.getElementById('OPRRowid')
	if(obj) var OPRRowid=obj.value;
	if(OPRRowid==""){
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
	/*var obj=document.getElementById('RepOperRoom')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,OPRCode,OPRDesc)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		} */
	var obj=document.getElementById('UpdateOperSuperCat')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,OPRRowid,Code,Desc)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BDelete_click(){

	if(preRowInd<1)return;
	var obj=document.getElementById('OPRRowid')
	if(obj) var OPRRowid=obj.value;
	if(OPRRowid==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('DeleteOperSuperCat')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,OPRRowid)!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}



document.body.onload=BodyLoadHandler;