//DHCANCOPCount.JS
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
	var objtbl=document.getElementById('tDHCANCOPCount');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('OPCountId');
	var obj1=document.getElementById('Code');
	var obj2=document.getElementById('Desc');
	var obj3=document.getElementById('OPCountType');
	var obj4=document.getElementById('OPCountTypeId')	
	
	var SelRowObj=document.getElementById('tOPCountIdz'+selectrow);
	var SelRowObj1=document.getElementById('OPCountCodez'+selectrow);
	var SelRowObj2=document.getElementById('OPCountDescz'+selectrow);
	var SelRowObj3=document.getElementById('tOPCountTypez'+selectrow);
	var SelRowObj4=document.getElementById('tOPCountTypeIdz'+selectrow);

	if (preRowInd==selectrow){
	   obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";
		obj4.value="";
   		preRowInd=0;
    }
   	else{
		if (obj) obj.value=SelRowObj.innerText;
		if (obj1) obj1.value=SelRowObj1.innerText;
		if (obj2) obj2.value=SelRowObj2.innerText;
		var CountType=SelRowObj3.innerText;
		CountType=CountType.replace(" ","");
		if (obj3) obj3.value=CountType;
		var CountTypeId=SelRowObj4.innerText;
		CountTypeId=CountTypeId.replace(" ","");
		if (obj4) obj4.value=CountTypeId;
		preRowInd=selectrow;
   }
   return;
}
	
	
function BADD_click(){
	var Code="",Desc="",OPCountTypeId="";
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
	var obj=document.getElementById('OPCountTypeId')
	if(obj) OPCountTypeId=obj.value;
	var obj=document.getElementById('OPCountType')
	if((obj)&&(obj.value=="")) OPCountTypeId="";

	var obj=document.getElementById('RepOPCount')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,Code)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	var obj=document.getElementById('AddMethod')
	if(obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,Code,Desc,OPCountTypeId);
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
	var Code="",Desc="",OPCountTypeId="";
	var obj=document.getElementById('OPCountId')
	if(obj) var OPCountId=obj.value;
	if(OPCountId==""){
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
	var obj=document.getElementById('OPCountTypeId')
	if(obj) OPCountTypeId=obj.value;
	var obj=document.getElementById('OPCountType')
	if((obj)&&(obj.value=="")) OPCountTypeId="";
	var obj=document.getElementById('UpdateMethod')
	if(obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,OPCountId,Code,Desc,OPCountTypeId);
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
	var obj=document.getElementById('OPCountId')
	if(obj) var OPCountId=obj.value;
	if(OPCountId==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('DeleteMethod')
	if(obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,OPCountId);
	if (ret!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}

function GetOPCountType(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("OPCountType")
	obj.value=loc[1];
	var obj=document.getElementById("OPCountTypeId")
	obj.value=loc[2];
}
document.body.onload=BodyLoadHandler;