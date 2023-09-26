///DHCOPBillInvInsuList.js
///Lid
///2014-07-08

function BodyLoadHandler() {
	RefreshDoc();
}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){
				return CellObj.checked;
			}else{
				return CellObj.value
			}
		}
	}
	return "";
}
function BulidPLStr(){
	var myRLStr="";
	var myRows=DHCWeb_GetTBRows("tDHCOPBillInvInsuList");
	for (var i=1;i<myRows+1;i++){		
		var mySelFlag=GetColumnData("SelFlag",i);
		if (mySelFlag){
			var myRLRowID=GetColumnData("PLRowID",i);
			var myPrtRowID=GetColumnData("PrtRowID",i);
			var myFairType=GetColumnData("TFairType",i);
			var myAdmSource=GetColumnData("TAdmSource",i);
			var myInsTypeDR=GetColumnData("TInsTypeDR",i);
			var tmp=myRLRowID+"^"+myPrtRowID+"^"+myFairType+"^"+myInsTypeDR+"^"+myAdmSource;
			myRLStr+=tmp+"!"
		}
	}
	return 	myRLStr;
}
function SetSelFlagDis()
{
	var myRLStr="";
	var myRows=DHCWeb_GetTBRows("tDHCOPBillInvInsuList");
	for (var i=1;i<myRows+1;i++){
		var obj=document.getElementById("SelFlagz"+i);
		obj.disabled=true;
	}
}

function SelectRowHandler() {
	RefreshDoc();
}
function RefreshDoc(){
	var myRLStr = BulidPLStr();
	//alert(myRLStr)

}
function SelectAll(myCheck) {
	var myRows = DHCWeb_GetTBRows("tDHCOPBillInvInsuList");
	for (var i = 1; i < myRows + 1; i++) {
		var obj = document.getElementById("SelFlagz" + i);
		///var mySelFlag=DHCWebD_GetCellValue(obj);
		DHCWebD_SetListValueA(obj, myCheck);
	}
	SelectRowHandler();

}


document.body.onload=BodyLoadHandler;