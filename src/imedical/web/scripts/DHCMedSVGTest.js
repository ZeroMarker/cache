function BodyLoadHandler()
{
	InitForm();
}

function InitForm()
{
	//var strApplet = "<APPLET ID = 'EvaluationApp' Name = 'EvaluationApp' codebase = '../addins/java' code = 'com/dhcc/wmr/qualityctl/Evaluation/EvaluationPanel.class' width = '900' height	= '600' >";
    var svgstring='<EMBED id="SVGEmbed" name="SVGEmbed" type="image/svg-xml" src="dhcsvgline.csp" height="600" width="840">';
    var objTable = document.getElementsByTagName("table")[2];
    objTable.rows[1].cells[0].innerHTML=svgstring;
    //var s=#server(web.DHCMedRMOPAdm.GetRMOPAdm(0,1))#
    //alert(s);
    
}

document.body.onload = BodyLoadHandler;