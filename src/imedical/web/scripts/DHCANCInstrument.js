var SelectedRow = 0;
var preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('BADD')
	if(obj) obj.onclick=BADD_click;
	var obj=document.getElementById('BUpdate')
	if(obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById('BDelete')
	if(obj) obj.onclick=BDelete_click;
	var obj=document.getElementById('BAutoAddRoom')
	if(obj) obj.onclick=BAutoAddRoom_click;
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCInstrument');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('OPRRowid');
	var obj1=document.getElementById('Code');
	var obj2=document.getElementById('Desc');
	
	
	var SelRowObj=document.getElementById('RowIdz'+selectrow);
	var SelRowObj1=document.getElementById('ANCINSTR_Codez'+selectrow);
	var SelRowObj2=document.getElementById('ANCINSTR_Descz'+selectrow);
	

	
	//引用宋加强?作用是选中有返回值?在选中删除返回值
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
	var obj=document.getElementById('RepOperInstrument')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,Code)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	var obj=document.getElementById('InsertOperInstrument')
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
	var obj=document.getElementById('UpdateOperInstrument')
	if(obj) var encmeth=obj.value;
	ret=cspRunServerMethod(encmeth,OPRRowid,Code,Desc)
	if (ret!='0')
		{alert(ret);
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
	var obj=document.getElementById('DeleteOperInstrument')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,OPRRowid)!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BAutoAddRoom_click(){
	var obj=document.getElementById('CountNum')
	var CountNum=obj.value;
	if(CountNum==""){alert(t['NullCountNum']);return;}
	var obj=document.getElementById('PreCode')
	var PreCode=obj.value;
	if(PreCode==""){alert(t['NullPreCode']);return;}
	var obj=document.getElementById('PreDesc')
	var PreDesc=obj.value;
	if(PreDesc==""){alert(t['NullPreDesc']);return;}
	if (isNaN(CountNum)==false){
		alert(CountNum)
	for (i=0;i<=CountNum;i++){
		
		}
	}
}

function getloc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("OPRLocID")
	obj.value=loc[1];
}
document.body.onload=BodyLoadHandler;