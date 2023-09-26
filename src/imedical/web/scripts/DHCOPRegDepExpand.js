
function BodyLoadHandler(){
	var obj=document.getElementById("Save");
	if (obj){obj.onclick=Save_Click;}
	
}

function Save_Click(){
	var objtbl=document.getElementById('tDHCOPRegDepExpand');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++) {
		var LocDesc=DHCC_GetColumnData("LocDesc",i);
		var LocId=DHCC_GetColumnData("LocId",i);
		var CFLocInsuNotRealTime=0,CFRegQtyNotAMP=0,CFLocRegLimit=0;
		var LocInsuNotRealTime=DHCC_GetColumnData("LocInsuNotRealTime",i);
		if (LocInsuNotRealTime==true) CFLocInsuNotRealTime=1;
		var RegQtyNotAMP=DHCC_GetColumnData("RegQtyNotAMP",i);
		if (RegQtyNotAMP==true) CFRegQtyNotAMP=1;
		
		var LocRegLimit=DHCC_GetColumnData("LocRegLimit",i);
		if (LocRegLimit==true) CFLocRegLimit=1;
		var SaveStr=CFLocInsuNotRealTime+"^"+CFRegQtyNotAMP+"^"+CFLocRegLimit;
		var SaveMethod=DHCC_GetElementData("SaveMethod");
		if (SaveMethod!=""){
			var rtn=cspRunServerMethod(SaveMethod,"OPRegDepExpand",LocId,SaveStr);
			if (rtn!=0) alert(LocDesc+",保存不成功.")
		}
	}
	alert("OK")
}

document.body.onload = BodyLoadHandler;