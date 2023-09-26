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
	var obj=document.getElementById('NANCKSRowId');
	var obj1=document.getElementById('NANCKSCode');
	var obj2=document.getElementById('NANCKSDesc');
	var SelRowObj=document.getElementById('ANCKS_RowIdZ'+selectrow);
	var SelRowObj1=document.getElementById('ANCKS_Codez'+selectrow);
	var SelRowObj2=document.getElementById('ANCKS_Descz'+selectrow);
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
   }
	return;
	}
	
	
function BADD_click(){
	var obj=document.getElementById('NANCKSCode')
	if(obj) var NANCKSCode=obj.value;
	
	if(NANCKSCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('NANCKSDesc')
	if(obj) var NANCKSDesc=obj.value;
	
	if(NANCKSDesc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('RepOperKnowledgeSource')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,NANCKSCode,NANCKSDesc)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	var obj=document.getElementById('InsertOperKnowledgeSource')
	if(obj) var encmeth=obj.value;

    if (cspRunServerMethod(encmeth,NANCKSCode,NANCKSDesc)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BUpdate_click(){
	if(preRowInd<1)return;
	var obj=document.getElementById('NANCKSRowId')
	if(obj) var NANCKSRowId=obj.value;
	if(NANCKSRowId==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('NANCKSCode')
	if(obj) var NANCKSCode=obj.value;
	if(NANCKSCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('NANCKSDesc')
	if(obj) var NANCKSDesc=obj.value;
	if(NANCKSDesc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('UpdateOperKnowledgeSource')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,NANCKSRowId,NANCKSCode,NANCKSDesc)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
function BDelete_click(){

	if(preRowInd<1)return;
	var obj=document.getElementById('NANCKSRowId')
	if(obj) var NANCKSRowId=obj.value;
	if(NANCKSRowId==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('DeleteOperKnowledgeSource')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,NANCKSRowId)!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
document.body.onload=BodyLoadHandler;