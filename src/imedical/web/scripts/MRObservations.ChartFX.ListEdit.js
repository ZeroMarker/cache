var updated=document.getElementById("updated");
var valframe=window.parent.parent.frames['chartfxlink'];
if(updated && valframe) {
	if(updated.value==1) {
		//use try catch in case SubmitGraph doesn't exist (it should in ChartFX.Link.js!)
		try {
			valframe.SubmitGraph();
		} catch (e) {  }
	}
}

function OpenTextWindow(obsfld) {
	var obs=document.getElementById(obsfld);
	if(obs) {
		var url="websys.default.csp?WEBSYS.TCOMPONENT=MRObservations.ChartFX.TextEdit&obs="+escape(obs.value)+"&ObsFldId="+obsfld;
		websys_createWindow(url,"","resizable=yes,status=yes,scrollbars=yes");
	}
	return false;
}

function Obs_changehandler(obsfld) {
	var obs=document.getElementById(obsfld);
	if(obs) {
		var isValid=0;
		if (!isNaN(obs.value)) isValid=1;
		if (!isValid) {
			obs.className='clsInvalid';
			websys_setfocus(obs.value);
			websys_cancel();
		} else {
			if (obs.value!='') obs.value=parseFloat(obs.value);
			if (obs.readOnly) {obs.className='clsReadOnly'} else {obs.className=''}
		}
	}
}