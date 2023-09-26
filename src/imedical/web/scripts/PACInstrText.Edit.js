// Log 52712 YC - locations can have the same description so we need 
// hidden fields to save the id rather than getting the id from description

var update = document.getElementById("update1");
if (update) {
	update.onclick = UpdateClickHandler;
}

// populate CTLOCID when the lookup fires
function LookUpModLocation(str) { 
	var location = document.getElementById("CTLOCID");
	if(location) {
		var locArr = str.split("^");
		location.value = locArr[1];
	}
	
}

// populate SPCTLOCID when the lookup fires
function LookUpSpecLocation(str) {
	var location = document.getElementById("SPCTLOCID");
	if(location) {
		var locArr = str.split("^");
		location.value = locArr[1];
	} 
}

// lookup doesn't fire when the value has been deleted
// so we need to make the id field is blank if there is no value
function UpdateClickHandler() {
	var modlocID = document.getElementById("CTLOCID");
	var modloc = document.getElementById("CTLOCDesc");
	if(modloc && modlocID) {
		if (modloc.value=="") modlocID.value="";
	}

	var speclocID = document.getElementById("SPCTLOCID");
	var specloc = document.getElementById("SPCTLOCDesc");
	if(specloc && speclocID) {
		if (specloc.value=="") speclocID.value="";
	}
	
	return update1_click();
}

// END Log 52712