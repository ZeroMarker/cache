// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	var obj=document.getElementById("Update1");
	if (obj) obj.onclick=UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

	for (var i=1;i<6;i++) {
		var obj=document.getElementById("RosNursez"+i); if (obj) obj.onchange=TextChangeHandler;
		var obj=document.getElementById("ReqNursez"+i); if (obj) obj.onchange=TextChangeHandler;
		var obj=document.getElementById("RosRSAz"+i); if (obj) obj.onchange=TextChangeHandler;
		var obj=document.getElementById("ReqRSAz"+i); if (obj) obj.onchange=TextChangeHandler;
		// chf 28338 added fields for Technicians
		var obj=document.getElementById("RosTechz"+i); if (obj) obj.onchange=TextChangeHandler;
		var obj=document.getElementById("ReqTechz"+i); if (obj) obj.onchange=TextChangeHandler;
	}
	LoadFields();
	TextChangeHandler();
}

function LoadFields() {
	var objParams=document.getElementById("Params")
	for (var i=1;i<6;i++) {
		var rec=mPiece(objParams.value,"^",i)
		//alert(rec)
		var obj=document.getElementById("idz"+i); if (obj) obj.value=mPiece(rec,"|",1)
		var obj=document.getElementById("RosNursez"+i); if (obj) obj.value=mPiece(rec,"|",5)
		var obj=document.getElementById("ReqNursez"+i); if (obj) obj.value=mPiece(rec,"|",6)
		var obj=document.getElementById("RosRSAz"+i); if (obj) obj.value=mPiece(rec,"|",7)
		var obj=document.getElementById("ReqRSAz"+i); if (obj) obj.value=mPiece(rec,"|",8)
		// chf 29111 added fields for Technicians
		var obj=document.getElementById("RosTechz"+i); if (obj) obj.value=mPiece(rec,"|",9)
		var obj=document.getElementById("ReqTechz"+i); if (obj) obj.value=mPiece(rec,"|",10)
	}
}

function UpdateClickHandler(e) {
	var objParams=document.getElementById("Params")
	var str=""
	var fdelim="|"
	var rdelim="^"
	for (var i=1;i<6;i++) {
		var obj=document.getElementById("idz"+i); if (obj) str=str+obj.value+fdelim
		var obj=document.getElementById("shiftz"+i); if (obj) str=str+obj.innerText+fdelim
		var obj=document.getElementById("RosNursez"+i); if (obj) str=str+obj.value+fdelim
		var obj=document.getElementById("ReqNursez"+i); if (obj) str=str+obj.value+fdelim
		var obj=document.getElementById("RosRSAz"+i); if (obj) str=str+obj.value+fdelim
		var obj=document.getElementById("ReqRSAz"+i); if (obj) str=str+obj.value+fdelim
		// chf 29111 added fields for Technicians
		var obj=document.getElementById("RosTechz"+i); if (obj) str=str+obj.value+fdelim
		var obj=document.getElementById("ReqTechz"+i); if (obj) str=str+obj.value+fdelim
		str=str+rdelim
	}
	//alert(str)
	if (objParams) objParams.value=str
	return Update1_click();
}

function TextChangeHandler(e) {
	if (websys_getSrcElement(e)) {
		var itmVal=websys_getSrcElement(e).value
		//alert(itmVal)
		if (isNaN(itmVal)) {
			//alert("'"+itmVal+"'"+" is not a numeric value.")
			return
		}
	}
	for (var i=1;i<6;i++) {
		var obj1=document.getElementById("RosNursez"+i)
		var obj2=document.getElementById("ReqNursez"+i)
		ColourValidate(obj1,obj2)

		var obj1=document.getElementById("RosRSAz"+i)
		var obj2=document.getElementById("ReqRSAz"+i)
		ColourValidate(obj1,obj2)
		
		// chf 29111 added fields for Technicians		
		var obj1=document.getElementById("RosTechz"+i)
		var obj2=document.getElementById("ReqTechz"+i)
		ColourValidate(obj1,obj2)	
	}
}

function ColourValidate(obj1,obj2) {
	if (obj1 && obj2) {
		obj1.style.color="black"; obj2.style.color="black"
		if (parseInt(obj1.value)<parseInt(obj2.value)) obj2.style.color="red"
		if (parseInt(obj1.value)>parseInt(obj2.value)) obj1.style.color="green"
	}

}

//function BodyUnloadHandler(e) {
//
//}

function mPiece(s1,sep,n) {
    n=n-1
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];		
    }
	//return "";
}

//document.body.onunload=BodyUnloadHandler;
document.body.onload = DocumentLoadHandler;