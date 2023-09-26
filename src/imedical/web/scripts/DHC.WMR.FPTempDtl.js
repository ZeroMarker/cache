function initForm()
{
	DisplayTempDetail();
	DisplayItemDetail();
	document.getElementById("cmdUpdate").onclick = cmdUpdateOnClick;
}

function LookUpItem(str)
{
	var objItemDesc=document.getElementById('txtItemDesc');
	var objItemId=document.getElementById('txtItemId');
	if (objItemDesc && objItemId && str){
		var tem=str.split("^");
		objItemId.value=tem[0];
		objItemDesc.value=tem[1];
	}
}
function DisplayTempDetail()
{
	var obj=document.getElementById("txtTempId");
	if (obj){
		var TempId=obj.value;
		if (!TempId) return;
		var obj=document.getElementById("MethodGetFPTemp");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,TempId);
		if (!ret) return;
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtTempDesc");
		if (obj&&tmpList[2]){
			obj.value=tmpList[2];
		}
	}
}
/*
function DisplayTempDetail()
{
	var obj=document.getElementById("txtTempId");
	if (obj){
		var TempId=obj.value;
		if (!TempId) return;
		var obj=document.getElementById("MethodGetFPItem");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,TempId);
		if (!ret) return;
		var tmpList=ret.split("^");
		var obj=document.getElementById("txtTempDesc");
		if (obj&&tmpList[1]){
			obj.value=tmpList[1];
		}
	}
}
*/
function DisplayItemDetail()
{
	var obj=document.getElementById("txtRowid");
	if (obj){
		var Rowid=obj.value;
		if (Rowid){
			var obj=document.getElementById("MethodGetFPTempDtl");
		    if (obj) {var encmeth=obj.value} else {var encmeth=''}
		    var ret=cspRunServerMethod(encmeth,Rowid);
			if (!ret) return;
			
			var tmpList=ret.split("^");
			if (tmpList[2]){
				var obj=document.getElementById("MethodGetFPItem");
				if (obj) {var encmeth=obj.value} else {var encmeth=''}
		    	var ret1=cspRunServerMethod(encmeth,tmpList[2]);
				var tmpSubList=ret1.split("^");
				var obj0=document.getElementById("txtItemId");
				var obj1=document.getElementById("txtItemDesc");
				if (tmpSubList[0]&&tmpSubList[1]&&obj0&&obj1){
					obj0.value=tmpSubList[0];
					obj1.value=tmpSubList[1];
				}
			}
			var obj=document.getElementById("txtPos");
			if (obj&&tmpList[3]){obj.value=tmpList[3]}
			var obj=document.getElementById("txtDefaultValue");
			if (obj&&tmpList[4]){obj.value=tmpList[4];}
			var obj=document.getElementById("txtToolTip");
			if (obj&&tmpList[5]){obj.value=tmpList[5];}		
			var obj=document.getElementById("txtResume");
			if (obj&&tmpList[6]){obj.value=tmpList[6];}
		}else{
			var obj=document.getElementById("txtItemId");
			if (obj){obj.value="";}
			var obj=document.getElementById("txtItemDesc");
			if (obj){obj.value="";}
			var obj=document.getElementById("txtPos");
			if (obj){obj.value=""}
			var obj=document.getElementById("txtDefaultValue");
			if (obj){obj.value="";}
			var obj=document.getElementById("txtToolTip");
			if (obj){obj.value="";}		
			var obj=document.getElementById("txtResume");
			if (obj){obj.value="";}
		}
	}
}

function cmdUpdateOnClick()
{
	var cRowid="",cTempId="",cItemId="",cPos="",cDefaultValue="",cToolTip="",cResume="";
	var obj=document.getElementById("txtRowid");
	if(obj) {cRowid=Trim(obj.value);}
	var obj=document.getElementById("txtTempId");
	if (obj){cTempId=Trim(obj.value);}
	var obj1=document.getElementById("txtItemId");
	var obj2=document.getElementById("txtItemDesc");
	if (obj1&&obj2){
		var cItemDesc=Trim(obj2.value);
		if (cItemDesc){cItemId=Trim(obj1.value);}
	}
	var obj=document.getElementById("txtPos");
	if (obj){cPos=Trim(obj.value);}
	var obj=document.getElementById("txtDefaultValue");
	if (obj){cDefaultValue=Trim(obj.value);}
	var obj=document.getElementById("txtToolTip");
	if (obj){cToolTip=Trim(obj.value);}
	var obj=document.getElementById("txtResume");
	if (obj){cResume=Trim(obj.value);}
	if ((!cTempId)||(!cItemId)||(!cPos)) {
		alert(t["DataError"]);
		return;
	}
	
	var UpdateData=cRowid+"^"+cTempId+"^"+cItemId+"^"+cPos+"^"+cDefaultValue+"^"+cToolTip+"^"+cResume;
	var obj=document.getElementById("MethodUpdateTempDtl");
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
	var objtbl=document.getElementById('tDHC_WMR_FPTempDtl');
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
		}else{obj.value="";}
	}
	DisplayItemDetail();
}
initForm();