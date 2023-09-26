var SelectedRow = 0;
var preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('BADD')
	if(obj) obj.onclick=BADD_click;
	
	var obj=document.getElementById('BDelete')
	if(obj) obj.onclick=BDelete_click;
	
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj1=document.getElementById('Nappdate');
	var SelRowObj1=document.getElementById('appdatez'+selectrow);
	if (preRowInd==selectrow){
		obj1.value="";
   		preRowInd=0;
    }
   else{if (obj1) obj1.value=SelRowObj1.innerText;
	preRowInd=selectrow;
   }
	return;
	}
	
	
function BADD_click(){
	var obj=document.getElementById('Nappdate')
	if(obj) var Nappdate=obj.value;
	
	if(Nappdate==""){
		alert("请选择特殊日期！")  
		return;
		}
		
	var obj=document.getElementById('InsertAncAppDate')
	if(obj) var encmeth=obj.value;

    if (cspRunServerMethod(encmeth,Nappdate)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}

function BDelete_click(){

	if(preRowInd<1)return;
	var obj=document.getElementById('Nappdate')
	if(obj) var Nappdate=obj.value;
	if(Nappdate==""){
		alert(t['03']) 
		return;
		}
	var obj=document.getElementById('DeleAncAppDate')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,Nappdate)!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
document.body.onload=BodyLoadHandler;