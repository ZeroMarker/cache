function initForm()
{
	var obj = document.getElementById("cboMrType");
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
		var obj=document.getElementById("MethodGetFPTemp");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,Rowid);
		if (!ret) return;
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtCode");
		if (obj&&tmpList[1]){obj.value=tmpList[1];}
		
		var obj=document.getElementById("txtDescription");
		if (obj&&tmpList[2]){obj.value=tmpList[2];}
		
		var obj=document.getElementById("cboMrType");
		if (obj&&tmpList[3]){
			for (var i=0;i<obj.options.length;i++){
				if (obj.options[i].value==tmpList[3]){
					obj.selectedIndex=i;
					break;
				}
			}
		}
		
		var obj=document.getElementById("chkActive");
		if (obj&&tmpList[4]){
			if (tmpList[4]=="Y"){
				obj.checked=true;
			}else{
				obj.checked=false;
			}
		}
				
		var obj=document.getElementById("txtResume");
		if (obj&&tmpList[5]){obj.value=tmpList[5];}
	}
}

function cmdUpdateOnClick()
{
	var cRowid="",cCode="",cDesc="",cMrType="",cActive="",cResume="";
	var obj=document.getElementById("txtRowid");
	if(obj) {cRowid=obj.value;}
	var obj=document.getElementById("txtCode");
	if (obj){cCode=Trim(obj.value);}
	var obj=document.getElementById("txtDescription");
	if (obj){cDesc=Trim(obj.value);}
	var obj=document.getElementById("cboMrType");
	if (obj){
		var Ind=obj.selectedIndex;
		if (Ind>=-1){cMrType=Trim(obj.options[Ind].value);}
		else{cMrType="";}
	}
	var obj=document.getElementById("chkActive");
	if (obj){
		if (obj.checked){cActive="Yes";}
		else{cActive="No";}
	}
	var obj=document.getElementById("txtResume");
	if (obj){cResume=Trim(obj.value);}
	
	if ((!cCode)||(!cDesc)||(!cMrType)||(!cActive)) {
		alert(t["DataError"]);
		return;
	}
	var UpdateData=cRowid+"^"+cCode+"^"+cDesc+"^"+cMrType+"^"+cActive+"^"+cResume;
	var obj=document.getElementById("MethodUpdateTemp");
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