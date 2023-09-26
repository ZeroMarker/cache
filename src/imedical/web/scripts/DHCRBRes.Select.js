document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=document.getElementById("ResDoc");
	if (obj){obj.onchange=ResDocchangehandler;}
	
	var obj=document.getElementById("Session");
	if (obj){obj.onchange=Sessionchangehandler;}
	

}

function ResDocchangehandler(e){
	var obj=document.getElementById("ResDoc");
	var ResRowid=obj.options[obj.selectedIndex].value;
	/*
	if (window.parent.frames["RPright"]){
		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.NotAvail&ResRowId="+ResRowid;
		window.parent.frames["RPright"].location=url;
	}
	*/
	SetSessionList(ResRowid)
}

function Sessionchangehandler(e){
	var obj=document.getElementById("Session");
	var SessionRowid=obj.options[obj.selectedIndex].value;
	if (window.parent.frames["RPright"]){
		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.Session.NotAvail&ResSessRowId="+SessionRowid;
		window.parent.frames["RPright"].location=url;
	}
}

function SetResDocList(LocID){
	var obj=document.getElementById('GetResDocMethod');
	if (obj) {
		var encmeth=obj.value;
		//alert("encmeth:"+encmeth);
		if (encmeth!=''){
			var retDetail=cspRunServerMethod(encmeth,"AddToResDocList",LocID);
			if (retDetail==1) return true;
		}
	}	
}

function AddToResDocList(val){
	var obj=document.getElementById('ResDoc');
	ClearAllList(obj)
	var DocArray=val.split("^");
	for (var i=0;i<DocArray.length;i++) {
		var DocData=DocArray[i].split(String.fromCharCode(1));
		obj.options[obj.length] = new Option(DocData[1],DocData[0]);
	}
}


function SetSessionList(ResRowId){
	var obj=document.getElementById('GetSessionMethod');
	if (obj) {
		var encmeth=obj.value;
		//alert("encmeth:"+encmeth);
		if (encmeth!=''){
			var retDetail=cspRunServerMethod(encmeth,"AddToSessionList",ResRowId);
			if (retDetail==1) return true;
		}
	}	
}

function AddToSessionList(val){
	var obj=document.getElementById('Session');
	ClearAllList(obj)
	var DocArray=val.split("^");
	for (var i=0;i<DocArray.length;i++) {
		var DocData=DocArray[i].split(String.fromCharCode(1));
		obj.options[obj.length] = new Option(DocData[1],DocData[0]);
	}
}


function LocLookupSelect(val) {
	var Split_Value=val.split("^");
	try {
		var LocID=Split_Value[2];
		var obj=document.getElementById("LocID");
		if (obj){
			obj.value=LocID;
			SetResDocList(LocID);
		}
	}catch(e){
		alert(e.message);
	}
}

function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}