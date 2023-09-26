var epId=document.getElementById("EpisodeID");
var episodeId=""
if(epId) episodeId=epId.value;
var conEpId=document.getElementById("ConsultEpisodeID");
var consultEpisodeId=""
if(conEpId) consultEpisodeId=conEpId.value;

function refreshEdit(ConceptID,descid,desc,mradm,SNOeditcomp,ConsultID) {
	var url="pacsnomed.edit.csp?ConceptID="+ConceptID+"&TermID="+descid+"&desc="+escape(desc)+"&mradm="+mradm+"&SNOeditcomp="+SNOeditcomp+"&ConsultID="+ConsultID+"&PARREF="+mradm+"&EpisodeID="+episodeId+"&ConsultEpisodeID="+consultEpisodeId;
	websys_createWindow(url,"snomed_main");
	return false;
}

function BodyLoadHandler() {
	var trees=document.getElementsByTagName("DIV");
	var hideElems = new Array();
	if(trees) {
		// hides empty trees
		for (var i=0; i<trees.length; i++) {
			if(trees[i].id=="dPACSnomedConcept_Search_Tree") {
				if(trees[i].innerHTML.indexOf("ConceptIDz1")==-1) {
					if(trees[i].parentElement.parentElement.tagName=="TR") {
						trees[i].parentElement.parentElement.style.display="none";
						hideElems[hideElems.length]=trees[i].parentElement.parentElement.id;
					}
				}
			}
		}
		// hides the plus/minus gif if there is nothing in the tree
		var imgs=document.getElementsByTagName("IMG");
		if(imgs) {
			for (var k=0;k<hideElems.length;k++) {
				for (var j=0;j<imgs.length;j++) {
					if(imgs[j].outerHTML.indexOf(hideElems[k])!=-1) {
						imgs[j].style.display="none";
					}
				}
			}
		}
	}
}

document.body.onload=BodyLoadHandler;
