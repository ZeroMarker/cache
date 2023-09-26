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
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('NANCKCRowId');
	var obj1=document.getElementById('NANCKCCode');
	var obj2=document.getElementById('NANCKCDesc');
	var obj3=document.getElementById('NANCKSCANCKCDR');
	var SelRowObj=document.getElementById('ANCKC_RowIdz'+selectrow);
	var SelRowObj1=document.getElementById('ANCKC_Codez'+selectrow);
	var SelRowObj2=document.getElementById('ANCKC_Descz'+selectrow);
	var SelRowObj3=document.getElementById('ANCKSC_ANCKC_DRz'+selectrow);
	if (preRowInd==selectrow){
	    obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";
   		preRowInd=0;
    }
   else{if (obj) obj.value=SelRowObj.innerText;
	if (obj1) obj1.value=SelRowObj1.innerText;
	if (obj2) obj2.value=SelRowObj2.innerText;
	if (obj3) obj3.value=SelRowObj3.innerText;
	preRowInd=selectrow;
   }
	return;
	}
	
	
function BADD_click(){
	var obj=document.getElementById('NANCKSCANCKCDR')
	if(obj) var NANCKSCANCKCDR=obj.value;
	
	if(NANCKSCANCKCDR==""){
		alert(t['05']) 
		return;
		}
	var obj=document.getElementById('NANCKCCode')
	if(obj) var NANCKCCode=obj.value;
	
	if(NANCKCCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('NANCKCDesc')
	if(obj) var NANCKCDesc=obj.value;
	
	if(NANCKCDesc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('RepOperKnowledgeSubCat')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,NANCKCCode,NANCKCDesc,NANCKSCANCKCDR)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	var obj=document.getElementById('InsertOperKnowledgeSubCat')
	if(obj) var encmeth=obj.value;

    if (cspRunServerMethod(encmeth,NANCKCCode,NANCKCDesc,NANCKSCANCKCDR)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BUpdate_click(){
	if(preRowInd<1)return;
	var obj=document.getElementById('NANCKSCANCKCDR')
	if(obj) var NANCKSCANCKCDR=obj.value;
	if(NANCKSCANCKCDR==""){
		alert(t['05']) 
		return;
		}
	var obj=document.getElementById('NANCKCRowId')
	if(obj) var NANCKCRowId=obj.value;
	if(NANCKCRowId==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('NANCKCCode')
	if(obj) var NANCKCCode=obj.value;
	if(NANCKCCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('NANCKCDesc')
	if(obj) var NANCKCDesc=obj.value;
	if(NANCKCDesc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('UpdateOperKnowledgeSubCat')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,NANCKCRowId,NANCKCCode,NANCKCDesc,NANCKSCANCKCDR)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BDelete_click(){

	if(preRowInd<1)return;
	var obj=document.getElementById('NANCKCRowId')
	if(obj) var NANCKCRowId=obj.value;
	if(NANCKCRowId==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('DeleteOperKnowledgeSubCat')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,NANCKCRowId)!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function getKnowledgeCat(str)
{
	var CKCDR=str.split("^");
	
	var obj=document.getElementById("NANCKSCANCKCDR")
  
	obj.value=CKCDR[1];
	
}
document.body.onload=BodyLoadHandler;