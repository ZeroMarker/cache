function initForm()
{
	obj=document.getElementById("cboVersion");
	if(obj){
		obj.size=1;
		obj.multiple=false;
		obj.selectedIndex=-1;
	}
	DisplayDetail();
	document.getElementById("cmdUpdate").onclick = cmdUpdateOnClick;
}

function DisplayDetail()
{
	var obj=document.getElementById("txtRowid");
	if (obj){
		var Rowid=obj.value;
		if (!Rowid) return;
		var obj=document.getElementById("MethodGetICDDx");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,Rowid);
		if (!ret) return;
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtICD");
		if (obj&&tmpList[1]){obj.value=tmpList[1];}
		
		var obj=document.getElementById("txtICD1");
		if (obj&&tmpList[2]){obj.value=tmpList[2];}
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtName");
		if (obj&&tmpList[3]){obj.value=tmpList[3];}
		
		var obj=document.getElementById("cboVersion");
		if (obj&&tmpList[4]){
			for (var i=0;i<obj.options.length;i++){
				if (obj.options[i].value==tmpList[4]){
					obj.selectedIndex=i;
					break;
				}
			}
		}
		
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
	var cRowid="",cICD="",cICD1="",cName="",cVersion="",cResume="",cActive="",cAlias="";
	var obj=document.getElementById("txtRowid");
	if(obj) {cRowid=obj.value;}
	var obj=document.getElementById("txtICD");
	if (obj){cICD=Trim(obj.value);}
	var obj=document.getElementById("txtICD1");
	if (obj){cICD1=Trim(obj.value);}
	var obj=document.getElementById("txtName");
	if (obj){cName=Trim(obj.value);}
	var obj=document.getElementById("cboVersion");
	if (obj){
		var Ind=obj.options.selectedIndex;
		if (Ind>=-1){
			cVersion=obj.options[Ind].value;
		}else{cVersion="";}
	}
	
	var obj=document.getElementById("txtResume");
	if (obj){cResume=Trim(obj.value);}
	
	var obj=document.getElementById("chkActive");
	if (obj){
		if (obj.checked){cActive="Yes";}
		else{cActive="No";}
	}
	
	//if ((!cICD)||(!cICD1)||(!cName)||(!cVersion)||(!cActive)) {
	if ((!cICD)||(!cName)||(!cVersion)||(!cActive)) {
		alert(t["DataError"]);
		return;
	}
	
	cAlias=getPinyin(cName);
	if (!cAlias){
		alert("ICDDx Alias is NULL!");
		return;
	}
	
	var UpdateData=cRowid+"^"+cICD+"^"+cICD1+"^"+cName+"^"+cVersion+"^"+cResume+"^"+cActive;
	var obj=document.getElementById("MethodUpdateICDDx");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,UpdateData,cAlias);
    if (ret&&ret>0){
	    //alert(t["UpdateTrue"]);
	}else{
		alert(t["UpdateFalse"]);
	}
	window.close();
}

initForm();