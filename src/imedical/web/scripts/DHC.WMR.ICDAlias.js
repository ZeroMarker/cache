function initForm()
{
	DisplayICDDxDetail();
	DisplayICDAliasDetail();
	document.getElementById("cmdUpdate").onclick = cmdUpdateOnClick;
}

function DisplayICDDxDetail()
{
	var obj=document.getElementById("txtICDDxId");
	if (obj){
		var ICDDxId=obj.value;
		if (!ICDDxId) return;
		var obj=document.getElementById("MethodGetICDDx");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,ICDDxId);
		if (!ret) return;
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtName");
		if (obj&&tmpList[3]){
			obj.value=tmpList[3];
		}
	}
}

function DisplayICDAliasDetail()
{
	var obj=document.getElementById("txtRowid");
	if (obj){
		var Rowid=obj.value;
		if (Rowid){
			var obj=document.getElementById("MethodGetICDAlias");
		    if (obj) {var encmeth=obj.value} else {var encmeth=''}
		    var ret=cspRunServerMethod(encmeth,Rowid);
			if (!ret) return;
			
			var tmpList=ret.split("^");
			var obj=document.getElementById("txtAlias");
			if (obj&&tmpList[2]){obj.value=tmpList[2]}
		}else{	
			var obj=document.getElementById("txtAlias");
			if (obj){obj.value="";}
		}
	}
}

function cmdUpdateOnClick()
{
	var cRowid="",cICDDxId="",cAlias="";
	var obj=document.getElementById("txtRowid");
	if(obj) {cRowid=Trim(obj.value);}
	var obj=document.getElementById("txtICDDxId");
	if (obj){cICDDxId=Trim(obj.value);}
	var obj=document.getElementById("txtAlias");
	if (obj){cAlias=Trim(obj.value);}
	
	if ((!cICDDxId)||(!cAlias)) {
		alert(t["DataError"]);
		return;
	}
	
	var UpdateData=cRowid+"^"+cICDDxId+"^"+cAlias;
	var obj=document.getElementById("MethodUpdateICDAlias");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,UpdateData);
    if (ret&&ret>0){
	    //alert(t["UpdateTrue"]);
	}else{
		alert(t["UpdateFalse"]);
	}
	location.reload();
}

function SelectRowHandler()	{
	var cRowid="";
	var objtbl=document.getElementById('tDHC_WMR_ICDAlias');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var eSrc=window.event.srcElement;
	var objRow=getRow(eSrc);
	var selectrow=objRow.rowIndex;
	if (selectrow <= 0) return;
	
	obj=document.getElementById('Rowidz'+selectrow);
	if (obj){cRowid=obj.innerText;}
	if (!cRowid) return;
	
	obj=document.getElementById("txtRowid");
	if (obj){
		var tmpRowid=obj.value;
		if (tmpRowid!==cRowid){
			obj.value=cRowid;
		}else{
			obj.value="";
		}
	}
	DisplayICDAliasDetail();
}
initForm();