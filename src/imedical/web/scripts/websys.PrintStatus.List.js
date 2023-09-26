function LookupStatus(val){
	var ary = val.split("^")
	document.getElementById("StatusCode").value=ary[2];
}