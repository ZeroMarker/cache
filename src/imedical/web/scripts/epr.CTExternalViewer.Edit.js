function BodyLoadHandler() {
	var CacheScript=document.getElementById("CacheScript");
	var PACSSystemCode=document.getElementById("PACSSystemCode");
	if(CacheScript && PACSSystemCode) {
		if(PACSSystemCode.value=="CUST") {
			EnableField("CacheScript");
		}
		else DisableField("CacheScript");
	}
	var showAll=document.getElementById("ShowAlways");
	if(showAll){
		ShowAllClickHandler();
		showAll.onclick=ShowAllClickHandler;
	}

	var doNotDisp=document.getElementById("DoNotDisplayInResBanner");
	if(doNotDisp){
		DoNotDisplayInHeaderHandler();
		doNotDisp.onclick=DoNotDisplayInHeaderHandler;
	}
}

function PACSSystemLookupHandler(str) {
  var ary=str.split("^");
  var CacheScript=document.getElementById("CacheScript");
  if(CacheScript) {
  	if(ary[2]=="CUST") EnableField("CacheScript");
		else DisableField("CacheScript");
	}
	var startingClass=document.getElementById("StartingClass");
  if(startingClass) {
		if (ary[2]=="USRD") EnableField("StartingClass");
		else DisableField("StartingClass");
	}
}

function ShowAllClickHandler(){
	var showAll=document.getElementById("ShowAlways");
	if ( showAll ) {
		if ( showAll.checked ) {
			DisableField("ExeOrdersOnly");
			DisableField("DoNotDisplayInResBanner");
		}else{
			EnableField("ExeOrdersOnly");
			EnableField("DoNotDisplayInResBanner");
		}
	}
}

function DoNotDisplayInHeaderHandler(){
	var doNotDisp=document.getElementById("DoNotDisplayInResBanner");
	if(doNotDisp){
		if(doNotDisp.checked){
			DisableField("ShowAlways");
		}else{
			EnableField("ShowAlways");
		}
	}
}

document.body.onload=BodyLoadHandler;
