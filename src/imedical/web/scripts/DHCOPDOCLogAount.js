document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	
	var obj=document.getElementById("InfectStr");
	var InfectStr=obj.value;
	var obj=document.getElementById("PatSum");
	obj.value=InfectStr.split("^")[1];
	var obj=document.getElementById("ReportSum");
	obj.value=InfectStr.split("^")[0];
	
	var obj=document.getElementById("Find");
	if (obj) obj.onclick=FindClickHandler;
}

function FindClickHandler() {
	var StDate="";
	var EdDate="";
	var StDateObj=document.getElementById("StDate");
	if (StDateObj){
		StDate=StDateObj.value;
		var StDateArr=StDate.split('/');
		if (StDateArr.length==3) {
			StDate=StDateArr[2]+"-"+StDateArr[1]+"-"+StDateArr[0];
		}
	}
	var EdDateObj=document.getElementById("EdDate");
	if (EdDateObj){
		EdDate=EdDateObj.value;
		var EdDateArr=EdDate.split('/');
		if (EdDateArr.length==3) {
			EdDate=EdDateArr[2]+"-"+EdDateArr[1]+"-"+EdDateArr[0];
		}
	}
	
	var CompareRet=DHCC_DateCompare(EdDate,StDate);
	if (!CompareRet) {
		alert("查询的开始日期不能大于结束日期.");
		return;
	}
	return Find_click();
}


