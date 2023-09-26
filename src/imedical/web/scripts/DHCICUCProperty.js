var SelectedRow = 0;
var preRowInd=0;

function BodyLoadHandler(){
	//alert('aaaaaaaaaaaa')
	var obj=document.getElementById('Insert')
	if(obj) obj.onclick=Insert_click;
	var obj=document.getElementById('Update')
	if(obj) obj.onclick=Update_click;
	var obj=document.getElementById('Delete')
	if(obj) obj.onclick=Delete_click;
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCICUCProperty');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('ICUCPRowID');
	var obj1=document.getElementById('ICUCPCode');
	var obj2 = document.getElementById('ICUCPDesc');
	var obj3 = document.getElementById("ICUCPDefaultValue");
	
	
	var SelRowObj=document.getElementById('tICUCPRowIDz'+selectrow);
	var SelRowObj1=document.getElementById('tICUCPCodez'+selectrow);
	var SelRowObj2 = document.getElementById('tICUCPDescz' + selectrow);
	var SelRowObj3 = document.getElementById("tICUCPDefaultValuez" + selectrow);
	

	if (preRowInd==selectrow){
	   obj.value="";
	   obj1.value="";
	   obj2.value = "";
	   obj3.value = "";
   	   preRowInd=0;
    }
   else{if (obj) obj.value=SelRowObj.innerText;
	if (obj1) obj1.value=SelRowObj1.innerText;
	obj2.value = SelRowObj2.innerText;
	obj3.value = SelRowObj3.innerText;
	preRowInd=selectrow;
   }
	return;
	}

function Insert_click(){
	//alert('aaaaaaaaa')
	var obj=document.getElementById('ICUCPCode')
	if(obj) var ICUCPCode=obj.value;
	if(ICUCPCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('ICUCPDesc')
	if(obj) var ICUCPDesc=obj.value;
	if(ICUCPDesc==""){
		alert(t['02']) 
		return;
    }

    var ICUCPDefaultValue = document.getElementById("ICUCPDefaultValue").value;
	var obj=document.getElementById('RepProperty')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,ICUCPCode)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
		
	var obj=document.getElementById('InsertProperty')
	if(obj) var encmeth=obj.value;
	var result = cspRunServerMethod(encmeth, ICUCPCode, ICUCPDesc, ICUCPDefaultValue);
    if (result!='0')
		{alert(result);
		return;}	
	try {		   
	    alert("Ìí¼Ó"+t['succeed']);
	    window.location.reload();
		} catch(e) {};
	
	}
	
function Update_click(){
	if(preRowInd<1)return;
	var obj=document.getElementById('ICUCPRowID')
	if(obj) var ICUCPRowID=obj.value;
	if(ICUCPRowID==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('ICUCPCode')
	if(obj) var ICUCPCode=obj.value;
	if(ICUCPCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('ICUCPDesc')
	if(obj) var ICUCPDesc=obj.value;
	if(ICUCPDesc==""){
		alert(t['02']) 
		return;
    }
    var ICUCPDefaultValue = document.getElementById("ICUCPDefaultValue").value;
	var obj=document.getElementById('UpdateProperty')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth, ICUCPRowID, ICUCPCode, ICUCPDesc, ICUCPDefaultValue) != '0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert("ÐÞ¸Ä"+t['succeed']);
	    window.location.reload();
		} catch(e) {};
	
	}

function Delete_click()
{
	if(preRowInd<1)return;
	var obj=document.getElementById('ICUCPRowID')
	if(obj) var ICUCPRowID=obj.value;
	if(ICUCPRowID==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('DeleteProperty')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,ICUCPRowID)!='0')
		{alert(t['baulk']);
		return;}	
	try {alert("É¾³ý"+t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
	
document.body.onload=BodyLoadHandler;