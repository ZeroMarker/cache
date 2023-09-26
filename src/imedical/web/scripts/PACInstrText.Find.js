// Log 53928 YC - "Find" Query can only take 16 params so we concatenate the last 3 into one hidden field

document.body.onload=BodyLoadHandler;

function BodyLoadHandler() {
	var FindObj = document.getElementById("find1");
	if (FindObj) FindObj.onclick = Find1ClickHandler;
}

function Find1ClickHandler() {
	// Concatenate Parameters
	var obj = document.getElementById("LastParams");
	if (obj) {
		obj.value="";
		var RSTDescObj = document.getElementById("RSTDesc");
		if (RSTDescObj) obj.value = RSTDescObj.value;
		obj.value += "^";
		var READescObj = document.getElementById("READesc");
		if (READescObj) obj.value += READescObj.value;
		obj.value += "^";
		var INTXRepCodeObj = document.getElementById("INTXReportCode");
		if (INTXRepCodeObj) obj.value += INTXRepCodeObj.value;	
		obj.value += "^";
		var SPPPDescObj = document.getElementById("SPPPDesc");
		if (SPPPDescObj) obj.value += SPPPDescObj.value;	
		//log 63501 TedT
		obj.value += "^";
		var OfferDesc = document.getElementById("OfferDesc");
		if (OfferDesc) obj.value += OfferDesc.value;	
	}
	return find1_click();
}