var scdrobj=document.getElementById("SNOMEDConceptDR");
var scobj=document.getElementById("SNOMEDConcept");

var mradmobj=document.getElementById("mradm");
var mradm = "";
if(mradmobj) mradm = mradmobj.value;

var editcompobj=document.getElementById("SNOeditcomp");
var SNOeditcomp = "";
if(editcompobj) SNOeditcomp = editcompobj.value;

var ConsIDobj=document.getElementById("ConsultID");
var ConsultID = "";
if(ConsIDobj) ConsultID = ConsIDobj.value;

var epId=document.getElementById("EpisodeID");
var episodeId=""
if(epId) episodeId=epId.value;
var conEpId=document.getElementById("ConsultEpisodeID");
var consultEpisodeId=""
if(conEpId) consultEpisodeId=conEpId.value;

function SNOMEDConceptLookUp(str) {
	var lu=str.split("^");
	var Desc=lu[1]
	if (scdrobj) scdrobj.value=Desc;
	var ConceptID=lu[3];
	var DescID=lu[4];

	if(ConceptID!="")	{
		var url="websys.default.csp?WEBSYS.TCOMPONENT=PACSnomedConcept.Search.Tree&parConceptID="+ConceptID+"&mradm="+mradm+"&SNOeditcomp="+SNOeditcomp+"&ConsultID="+ConsultID+"&EpisodeID="+episodeId+"&ConsultEpisodeID="+consultEpisodeId;
		websys_createWindow(url,"snomed_tree");

		var url2="pacsnomed.edit.csp?ConceptID="+ConceptID+"&TermID="+DescID+"&desc="+escape(Desc)+"&PARREF="+mradm+"&SNOeditcomp="+SNOeditcomp+"&ConsultID="+ConsultID+"&EpisodeID="+episodeId+"&ConsultEpisodeID="+consultEpisodeId;
		websys_createWindow(url2,"snomed_main");
	}
}
