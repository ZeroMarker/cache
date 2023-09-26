var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","DHC.WMR.ICDVersion.Edit");
//alert(tmpChinese[0]+tmpChinese[1]);
//D--º≤≤°’Ô∂œ  O-- ÷ ı±‡¬Î

function initForm()
{
	obj=document.getElementById("cboType");
	if(obj){
		obj.size=1;
		obj.multiple=false;
		
		obj.length=0;
		for (var i=0;i<tmpChinese.length;i++)
		{
			var objItm=document.createElement("OPTION");
			obj.options.add(objItm);
			objItm.innerText =tmpChinese[i];
			objItm.value = i;
		}
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
		var obj=document.getElementById("MethodGetVersion");
	  if (obj) {var encmeth=obj.value} else {var encmeth=''}
	  var ret=cspRunServerMethod(encmeth,Rowid);
		if (!ret) return;
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtCode");
		if (obj&&tmpList[1]){obj.value=tmpList[1];}
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtDesc");
		if (obj&&tmpList[2]){obj.value=tmpList[2];}
		
		var obj=document.getElementById("cboType");
		if (obj&&tmpList[3]){
			for (var i=0;i<obj.options.length;i++){
				if (obj.options[i].text.indexOf(tmpList[3])==0){
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
	var cRowid="",cCode="",cDesc="",cType="",cActive="",cResume="";
	var obj=document.getElementById("txtRowid");
	if(obj) {cRowid=obj.value;}
	var obj=document.getElementById("txtCode");
	if (obj){cCode=Trim(obj.value);}
	var obj=document.getElementById("txtDesc");
	if (obj){cDesc=Trim(obj.value);}
	var obj=document.getElementById("cboType");
	if (obj){
		var Ind=obj.options.selectedIndex;
		if (Ind>=-1){
			var tmpType=obj.options[Ind].innerText;
			var tmp=tmpType.split("--");
			if (tmp.length>0) {cType=tmp[0];}
		}else{cType="";}
	}
	var obj=document.getElementById("chkActive");
	if (obj){
		if (obj.checked){cActive="Yes";}
		else{cActive="No";}
	}
	var obj=document.getElementById("txtResume");
	if (obj){cResume=Trim(obj.value);}

	if ((!cCode)||(!cDesc)||(!cType)||(!cActive)) {
		alert(t["DataError"]);
		return;
	}
	var UpdateData=cRowid+"^"+cCode+"^"+cDesc+"^"+cType+"^"+cActive+"^"+cResume;
	var obj=document.getElementById("MethodUpdateVersion");
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