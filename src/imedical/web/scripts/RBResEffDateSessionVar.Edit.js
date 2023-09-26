var timerenabled=true;

function BodyLoadHandler() {
    var frm = document.forms['fRBResEffDateSessionVar_Edit'];
    if (frm) {frm.method="GET";}

    //var obj=document.getElementById('VARReasonForVarianceDR');
	//if (obj) obj.onblur = VarTextBlurHandler;

}

function CodeDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('VARReasonForVarianceDR');
	if (obj) obj.value=lu[1];
}

function VarTextBlurHandler(e) {
	/*
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('VARReasonForVarianceDR');
		if (obj) obj.value=""
	}
	*/
}

document.body.onload = BodyLoadHandler;