// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tOEOrdItem_ListLabEpisodeProfileEMR");
var frm=document.getElementById("fOEOrdItem_ListLabEpisodeProfileEMR");

if (EpisodeID==null) {
	var EpisodeID=frm.elements['EpisodeID'].value;
}
for (var i=1;i<tbl.rows.length;i++) {
	var eSrc=frm.elements['episodeidz'+i];
	if (eSrc) {
		//alert(i+" "+eSrc);
		var obj=getRow(eSrc);
		var epid=frm.elements['episodeidz'+i].value;
		var abnrml=frm.elements['Abnormalz'+i].value;
		if (epid!=EpisodeID) {
			if ((i%2)==1) {
				obj.className="EMROtherEpsOdd";
			} else {
				obj.className="EMROtherEpsEven";
			}
			if ((abnrml=="Y")&&((i%2)==1)) {
				obj.className="AbnrmlEMROtherEpsOdd";
			} else if (abnrml=="Y") {
				obj.className="AbnrmlEMROtherEpsEven";
			}
		} else if (abnrml=="Y") {
				if ((i%2)==1) {
						obj.className="AbnrmlResOdd";
				} else {
						obj.className="AbnrmlResEven";
				}
		}
	}
}

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {if (eSrc.tagName == "TH") break;eSrc=eSrc.parentElement;}
	return eSrc;
}