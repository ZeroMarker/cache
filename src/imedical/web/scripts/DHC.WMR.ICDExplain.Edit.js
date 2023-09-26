function initForm()
{
	DisplayDetail();
	document.getElementById("cmdUpdate").onclick = cmdUpdateOnClick;
}

function DisplayDetail()
{
	var obj=document.getElementById("txtRowid");
	if (obj){
		var Rowid=obj.value;
		if (!Rowid) return;
		var obj=document.getElementById("MethodGetExplain");
		if (obj) {var encmeth=obj.value} else {var encmeth=''}
		var ret=cspRunServerMethod(encmeth,Rowid);
		if (!ret) return;
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtCode");
		if (obj&&tmpList[1]){obj.value=tmpList[1];}
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtDesc");
		if (obj&&tmpList[2]){obj.value=tmpList[2];}
		
		var obj=document.getElementById("chkActive");
		if (obj&&tmpList[3]){
			if (tmpList[3]=="Y"){
				obj.checked=true;
			}else{
				obj.checked=false;
			}
		}
		
		var obj=document.getElementById("txtResume");
		if (obj&&tmpList[4]){obj.value=tmpList[4];}
	}
}

function cmdUpdateOnClick()
{
	var cRowid="",cCode="",cDesc="",cActive="",cResume="";
	var obj=document.getElementById("txtRowid");
	if(obj) {cRowid=obj.value;}
	var obj=document.getElementById("txtCode");
	if (obj){cCode=Trim(obj.value);}
	var obj=document.getElementById("txtDesc");
	if (obj){cDesc=Trim(obj.value);}
	
	var obj=document.getElementById("chkActive");
	if (obj){
		if (obj.checked){cActive="Yes";}
		else{cActive="No";}
	}
	var obj=document.getElementById("txtResume");
	if (obj){cResume=Trim(obj.value);}

	if ((!cCode)||(!cDesc)||(!cActive)) {
		alert(t["DataError"]);
		return;
	}
	var UpdateData=cRowid+"^"+cCode+"^"+cDesc+"^"+cActive+"^"+cResume;
	var obj=document.getElementById("MethodUpdateExplain");
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