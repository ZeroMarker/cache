//DHCMedPVMDictAdd
function initForm()
{
	var obj=document.getElementById("btnAdd");
	if(obj)obj.onclick=btnAdd_click;
	
}

function btnAdd_click()
{
	var obj=document.getElementById("DictType");
	dictType=obj.value;
	if(dictType=="")return;
	var obj=document.getElementById("Code");
	code=obj.value;
	if(code=="")return;
	var obj=document.getElementById("Description");
	description=obj.value;
	if(description=="")return;
	var obj=document.getElementById("Description");
	description=obj.value;
	var obj=document.getElementById("Resume");
	resume=obj.value;
	var obj=document.getElementById("txtMethodDictAdd");
	encmeth=obj.value;
	var Instring="^"+code+"^"+description+"^"+dictType+"^Y^^^"+resume+"^"
	//alert(Instring);
	var ret=AddPVMDict(encmeth,Instring);
	if(ret>0)
	{
		alert(t['Success']);
		self.close();
	}
	else
	{
		alert(t['Failed']);
		var obj=document.getElementById("Code");
		obj.setFocus();
	}
}

function AddPVMDict(encmeth,Instring){
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,Instring);
		return ret;	
		}	
	}
document.body.onload=initForm;