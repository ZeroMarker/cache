function initForm()
{
	var obj = document.getElementById("cboDataType");
	if (obj){
		obj.multiple = false;
		obj.size = 1;
		obj.selectedIndex=0;
	}
	DisplayDetail();
	document.getElementById("cmdUpdate").onclick = cmdUpdateOnClick;
}

function DisplayDetail(){
	var obj=document.getElementById("txtRowid");
	if (obj){
		var Rowid=obj.value;
		if (!Rowid) return;
		var obj=document.getElementById("MethodGetFPIDic");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,Rowid);
		if (!ret) return;
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtDescription");
		if (obj&&tmpList[1]){obj.value=tmpList[1];}
		
		var obj=document.getElementById("cboDataType");
		if (obj&&tmpList[2]){
			for (var i=0;i<obj.options.length;i++){
				if (obj.options[i].value==tmpList[2]){
					obj.selectedIndex=i;
					break;
				}
			}
		}
		
		var obj=document.getElementById("txtDefaultValue");
		if (obj&&tmpList[3]){obj.value=tmpList[3];}
		
		var obj=document.getElementById("txtDicName");
		if (obj&&tmpList[4]){obj.value=tmpList[4];}
		
		var obj=document.getElementById("txtResume");
		if (obj&&tmpList[5]){obj.value=tmpList[5];}
		
		var obj=document.getElementById("chkActive");
		if (obj&&tmpList[6]){
			if (tmpList[6]=="Y"){
				obj.checked=true;
			}else{
				obj.checked=false;
			}
		}
	}
}

function cmdUpdateOnClick()
{
	var cRowid="",cDesc="",cDefaultValue="",cDataType="",cDicName="",cResume="",cActive="";
	var obj=document.getElementById("txtRowid");
	if(obj) {cRowid=Trim(obj.value);}
	var obj=document.getElementById("txtDescription");
	if (obj){cDesc=Trim(obj.value);}
	var obj=document.getElementById("cboDataType");
	if (obj){
		var Ind=obj.selectedIndex;
		if (Ind>=-1){cDataType=Trim(obj.options[Ind].value);}
		else{cDataType="";}
	}
	var obj=document.getElementById("txtDefaultValue");
	if (obj){cDefauleValue=Trim(obj.value);}
	var obj=document.getElementById("txtDicName");
	if (obj){cDicName=Trim(obj.value);}
	var obj=document.getElementById("txtResume");
	if (obj){cResume=Trim(obj.value);}
	var obj=document.getElementById("chkActive");
	if (obj){
		if (obj.checked){cActive="Yes";}
		else{cActive="No";}
	}
	
	if ((!cDesc)||(!cDataType)||(!cDicName)||(!cActive)) {
		alert(t["DataError"]);
		return;
	}
	var UpdateData=cRowid+"^"+cDesc+"^"+cDataType+"^"+cDefauleValue+"^"+cDicName+"^"+cResume+"^"+cActive;
	var obj=document.getElementById("MethodUpdateItem");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,UpdateData);
    if (ret&&ret>0){
	    //alert(t["UpdateTrue"]);
	}else{
		alert(t["UpdateFalse"]);
	}
	window.close();
}

initForm();