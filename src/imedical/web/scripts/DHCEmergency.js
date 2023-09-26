function DocumentLoadHandler() {
	var Obj=document.getElementById('Delete');
	if (Obj) Obj.onclick = DeleteClickHandler;
	var Obj=document.getElementById('Save');
	if (Obj) Obj.onclick = SaveHandler;
	var Obj=document.getElementById('EmergCondItem');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('ACUDesc');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('InjuryDesc');
	if (Obj) Obj.onkeydown = nextfocus;
	Query();
	/*var Obj=document.getElementById('ID');
	if (Obj.value==""){
		var Obj=document.getElementById('Height');
		if (Obj) Obj.disabled = true;
		var Obj=document.getElementById('Weight');
		if (Obj) Obj.disabled = true;
		var Obj=document.getElementById('BPDiastolic');
		if (Obj) Obj.disabled = true;
		var Obj=document.getElementById('BPSystolic');
		if (Obj) Obj.disabled = true;
		
		var Obj=document.getElementById('PulseRate');
		if (Obj) Obj.disabled = true;
		var Obj=document.getElementById('Resp');
		if (Obj) Obj.disabled = true;
		
		
	} */
}
function EmergCondLookupSelect(txt) {
	//Add an item to EMCDesc when an item is selected from
	//the Lookup, then clears the Item text field.
	var Obj=document.getElementById('EpisodeID');
	if (Obj.value==""){
		return
	}
	
	var adata=txt.split("^");
	var obj=document.getElementById("EMCDesc")
	for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].text == adata[0]) {
				alert(t["DupCondition"]);
				var obj=document.getElementById("EmergCondItem")
				if (obj) obj.value="";
				return;
			}
	}

	AddItemToList(obj,adata[0],adata[1]);
	var obj=document.getElementById("EmergCondItem")
	if (obj) obj.value="";
}

function DeleteClickHandler() {
	//Delete items from EMCDesc listbox when a "Delete" button is clicked.
	var obj=document.getElementById("EMCDesc")
	if (obj)
		RemoveFromList(obj);
	
	return false;
}
function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {	
		var lstlen=obj.length;
		obj.options[lstlen] = new Option(arytxt,aryval)
				
	}
}
function RemoveFromList(obj) {
	//var frm=document.fPAAdm_EditEmergency;
	//TDIRTY=document.getElementById("TDIRTY")
	//frm.TDIRTY.value=2
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function Query(){

			var tmp=document.getElementById('ID');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			
			var obj=document.getElementById('EpisodeID');
            if(p1=="") {
				var p1=obj.value 
			} 			
			
			var GetDetail=document.getElementById('GetQueryMethod');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'QueryResult','',p1)=='0') {
			//obj.className='clsInvalid';
			//websys_setfocus('Name');	
			return websys_cancel();
		
		}
		obj.className='';
}

function QueryResult(value) {
	try {
		//alert(value)
		var Split_Value=value.split("^")
		var obj=document.getElementById('BPSystolic');
		if(obj) obj.value=unescape(Split_Value[0]);
		var obj=document.getElementById('BPDiastolic');
		if(obj) obj.value=unescape(Split_Value[1]);
		var obj=document.getElementById('Resp');
		if(obj) obj.value=unescape(Split_Value[2]);
		var obj=document.getElementById('PulseRate');
		if(obj) obj.value=unescape(Split_Value[3]);
		var obj=document.getElementById('Weight');
		if(obj) obj.value=unescape(Split_Value[4]);
		var obj=document.getElementById('Height');
		if(obj) obj.value=unescape(Split_Value[5]);
	
		var obj=document.getElementById('ACUDesc');
		if(obj) obj.value=unescape(Split_Value[6]);
		
		//if Reg Call then do ....
		if (window.name=="RegCallDHCEmergency"){
		   if(obj.value==""){
		   		obj.value=t["ACUDesc:Default"]
		   }
		}
		var obj=document.getElementById('InjuryDesc');
		if(obj) obj.value=unescape(Split_Value[7]);
		
		if(Split_Value[8]==""){
			return
		}
		
		var valueAry=Split_Value[8].split("!");
		var arytxt=new Array();
		var aryval=new Array();
		var obj=document.getElementById('EMCDesc');
		if (valueAry.length>0) {
			var j=0
			for (var i=0;i<valueAry.length;i++) {
				var arytmp=valueAry[i].split("&");
				arytxt[j]=arytmp[1]
				aryval[j]=arytmp[0]
  			AddItemToList(obj,arytxt[j],aryval[j])

			}
		}
		var obj=document.getElementById('TransferMeans');
		if(obj) obj.value=unescape(Split_Value[9]);	
	} catch(e) {};
}

function SaveHandler(){
			var p1=""

			var obj=document.getElementById('ID');
			if(obj) {
				var p1=obj.value 	 
			}				
			
			var obj=document.getElementById('EpisodeID');
            if(p1=="") {
				var p1=obj.value 
			} 
			
			if(p1=="") {return}			 
		    
		    var obj=document.getElementById('BPSystolic');
			if(obj) {var p2=obj.value} else {p2=""};
			var obj=document.getElementById('BPDiastolic');
			if(obj) {var p3=obj.value} else {p3=""};
			var obj=document.getElementById('Resp');
			if(obj) {var p4=obj.value} else {p4=""};
			var obj=document.getElementById('PulseRate');
			if(obj) {var p5=obj.value} else {p5=""};
			var obj=document.getElementById('Weight');
			if(obj) {var p6=obj.value} else {p6=""};
			var obj=document.getElementById('Height');
			if(obj) {var p7=obj.value} else {p7=""};
	
			var obj=document.getElementById('ACUDesc');
			if(obj) {var p8=obj.value} else {p8=""};
		    
			p9=""
			var obj=document.getElementById('EMCDesc');   
		    if (obj.options.length>0) {
				for (var i=0; i<=obj.options.length-1; i++) 
				{
					var EMCItem=obj.options[i];
					//alert(EMCItem.value)
					if (p9==""){
						p9=EMCItem.value+"^"
					}else{
						p9=p9+EMCItem.value+"^"
					}
				}
			}else{
				alert(t["NullValue"])
				return
			}
			
			
			p10=session['LOGON.USERID']
			
			var obj=document.getElementById('InjuryDesc');
			if(obj) {var p11=obj.value} else {p11=""};
			var obj=document.getElementById('TransferMeans');
			if(obj) {var p12=obj.value} else {p12=""};
			//alert(p9)
		    var par=p1+","+p2+","+p3+","+p4+","+p5+","+p6+","+p7+","+p8+","+p9+","+p10+","+p11+","+p12
			
			//return
			
			var GetDetail=document.getElementById('GetSaveMethod');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'SaveReturn','',par)=='0') {
			//obj.className='clsInvalid';
			//websys_setfocus('Name');	
			return websys_cancel();
		
		}
		obj.className='';
}

function SaveReturn(value) {
	try {
		if (value==0){
			alert(t["SaveSuccess"])
			if (window.name=="RegCallDHCEmergency")
			{
			 	window.close()

			}else{
				var userID=session['LOGON.USERID']
				var GetWorkflowID=document.getElementById('GetWorkflowID');
			    if (GetWorkflowID) {var encmeth=GetWorkflowID.value} else {var encmeth=""};
			    var TWKFL=cspRunServerMethod(encmeth,userID)
			    if(TWKFL!=""){
			    var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=";
			    window.location=lnk;
			    }
				//opener.parent.location.reload();   //¼±Õï·Ö¼¶
				//window.close();
			}
			
		}else{
			alert(t["SaveFail"])
		}
} catch(e) {};
}
function nextfocus() {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
document.body.onload = DocumentLoadHandler;