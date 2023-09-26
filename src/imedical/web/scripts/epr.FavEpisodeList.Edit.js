// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 24.09.03

var f=document.all.fepr_FavEpisodeList_List;
var tbl=document.getElementById("tepr_FavEpisodeList_List");

function SelectRowHandler()
{
	var Default;
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=eSrc.parentElement;
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>0) {
		var def=document.getElementById("DefaultListz"+eSrcAry[1]);
		var newdef=document.getElementById("NewDefault");
		var id=document.getElementById("ListIDz"+eSrcAry[1]);
		if (def) {
			// dont allow them to uncheck all of them
			if (def.checked==false) def.checked=true;
			if ((newdef)&&(id)) newdef.value=id.value;
			
			// uncheck all the other default checkboxes
			for (var i=1;i<tbl.rows.length;i++) {
				if (i!=eSrcAry[1]) {
					var obj=document.getElementById("DefaultListz"+i);
					if (obj) obj.checked=false;
				}
			}
			
		}
	}
}
