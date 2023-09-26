// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// w642dev
if (parent.frames["FindBulkRequestList"])	document.forms['fRTRequest_FindBulkRequest'].target="FindBulkRequestList";
var ChrCode="";
var selVolDescFlag="true";
var HasRegoVolDelim="";

function MultiCheck(val,obj) {
	var num="";
	var found=false;
	match1=0;
	if (val) val=val.toUpperCase();
	if (obj) num=obj.value.toUpperCase();
	//alert("passed: "+val);
	//alert("num: "+num);
	val="^"+val;
	match1 = val.indexOf("^"+num+"^");	
	if (match1>=0) found=true;
	//alert(found);
	return found;
}

function MultiCheckAll(regno,ReqID,BatchID,VolID,MRN) {
	//ANA LOG 27427 Checking combination of patient/mr-record-type/volume.
	
	if (regno) regno=regno.toUpperCase();
	if (ReqID) ReqID=ReqID.toUpperCase();
	if (BatchID) BatchID=BatchID.toUpperCase();
	if (VolID) VolID=VolID.toUpperCase();
	if (MRN) MRN=MRN.toUpperCase();
	URs=URs.toUpperCase();
	PatReqids=PatReqids.toUpperCase();
	Patbatchids=Patbatchids.toUpperCase();
	VolDescIds=VolDescIds.toUpperCase();
	MRNs=MRNs.toUpperCase();
	
	var rn=URs.split("^");
	var vn=PatReqids.split("^");
	var ty=Patbatchids.split("^");
	var vy=VolDescIds.split("^");
	var mrn=MRNs.split("^");

	var found=false;
	//alert(URs+"*"+PatReqids+"*"+Patbatchids+"*"+VolDescIds+"*"+mrn);
	//alert("URs "+URs+" regno "+regno)
	for (var i=0; i<rn.length; i++) {
		if ( (((regno==rn[i])&&(regno!="")&&(vy[i]=="")&&(mrn[i]=="") || ((ReqID==vn[i])&&(ReqID!="")&&(vn[i]!="")) || ((BatchID==ty[i])&&(BatchID!="")&&(ty[i]!=""))) && (VolID=="")&&(MRN==""))) {
			found=true;
		} 
		else if( ((regno==rn[i])&&(regno!="")) && ((VolID==vy[i])&&(VolID!="")) && ((MRN==mrn[i])&&(MRN!=""))) {
			found=true;
		}
		else if( ((regno==rn[i])&&(regno!="")) && ((VolID==vy[i])&&(VolID!="")) && ((MRN=="")&&(mrn[i]==""))) {
			found=true;
		}
		else if( ((regno==rn[i])&&(regno!="")) && ((VolID=="")&&(vy[i]=="")) && ((MRN==mrn[i])&&(MRN!=""))) {
			found=true;
		}
	}

	//alert(found);
	return found;
}
/*
function MultiCheckAll(regno,ReqID,BatchID,VolID) {
	//ANA LOG 27427 Checking combination of patient/mr-record-type/volume.
	
	if (regno) regno=regno.toUpperCase();
	if (ReqID) ReqID=ReqID.toUpperCase();
	if (BatchID) BatchID=BatchID.toUpperCase();
	if (VolID) VolID=VolID.toUpperCase();
	URs=URs.toUpperCase();
	PatReqids=PatReqids.toUpperCase();
	Patbatchids=Patbatchids.toUpperCase();
	VolDescIds=VolDescIds.toUpperCase();
	
	var rn=URs.split("^");
	var vn=PatReqids.split("^");
	var ty=Patbatchids.split("^");
	var vy=VolDescIds.split("^");

	var found=false;
	//alert(URs+"*"+PatReqids+"*"+Patbatchids+"*"+VolDescIds);
	//alert("URs "+URs+" regno "+regno)
	for (var i=0; i<rn.length; i++) {
		if ( (((regno==rn[i])&&(regno!="")&&(vy[i]=="")) || ((ReqID==vn[i])&&(ReqID!="")&&(vn[i]!="")) || ((BatchID==ty[i])&&(BatchID!="")&&(ty[i]!=""))) && (VolID=="")) {
			found=true;
		} 
		else if( ((regno==rn[i])&&(regno!="")) && ((VolID==vy[i])&&(VolID!="")) ) {
			found=true;
		}
	}

	//alert(found);
	return found;
}
*/

function xFindClick_Handler() {
	//alert(RTMAVVolDescObj");
	//alert("findclick: "+pobj.value+"***"+pvobj.value+"volume:"+Vobj.value);
	///scanning
	var scObj=document.getElementById("scanFlag");
	var ScanMode=false;
	if ((scObj) && (scObj.checked==true)) {
		ScanMode=true;
		//alert("findclick-scanning: "+pobj.value+"**BB*"+pbobj.value+"***"+pvobj.value);
		//alert("scanning");
		return find1_click();
	}

	///end scanning

	//alert("finding");
	var currRegNo="";
	var currReqID="";
	var currBatchID="";
	var currVolID="";
	
	if (URobj1) currRegNO=URobj1.value;
	if (Robj1) currReqID=Robj1.value;
	if (bobj) currBatchID=bobj.value;

	if (RTMAVVolDescObj) currVolID=RTMAVVolDescObj.value;
	//if (Vobj) currVolID=Vobj.value;


	var match=false;
	if (pobj) URs=pobj.value;
	if (probj) PatReqids=probj.value;
	if (pbobj) Patbatchids=pbobj.value;
	//alert("findclick2: "+pobj.value+"***"+pvobj.value);
	//alert("URs "+URs)
	if ((currRegNO!="")||(currReqID!="")||(currBatchID!="")) {
		var match=MultiCheckAll(currRegNO,currReqID,currBatchID);
		//alert(match);
		if (!match){
			if (currRegNO!=""){
				//see if a volume is appended to the regnumber
				var VolPos = currRegNO.indexOf("-");
				if (VolPos > 0)
				{
					var regID = URobj1.value.substr(0,VolPos).toUpperCase();
					if (URobj1) {
						URs+=regID+"^";
						//alert("VolDescIds-111: "+VolDescIds);
						VolDescIds+=URobj1.value.substr(VolPos+1).toUpperCase()+"^";
					}
					if(pur)	pur.value = regID; 	
				}
				else
				{
					if (URobj1) URs+=URobj1.value.toUpperCase()+"^";
					//if scan mode is off, don't run the following line
					//var scObj=document.getElementById("scanFlag");
					//alert("VolDescIds000: "+VolDescIds);
					//if ((scObj) && (scObj.checked==false)) {
						///VolDescIds+="^";
					//}
					//alert("VolDescIds111: "+VolDescIds);
					if(pur)	pur.value = URobj1.value; 	
				}
				//alert("findclick4: "+pobj.value+"**BB*"+pbobj.value+"***"+pvobj.value);
				if (pvobj) pvobj.value+=VolDescIds+"^";		
				if(Vobj) Vobj.value+=URobj1.value.toUpperCase()+"^";
				if (pobj) pobj.value=URs;				
				//alert("findclick5: "+pobj.value+"***"+pvobj.value);
			} else {
				URs+="^";
				if (pobj) pobj.value=URs;
			}
			
			//alert("URs "+URs);
			if (currReqID!=""){
				if (Robj1) PatReqids+=Robj1.value+"^";	
				if (probj) probj.value=PatReqids;
			} else {
				PatReqids+="^";
				if (probj) probj.value=PatReqids;
			}
			if (currBatchID!=""){
				if (bobj) Patbatchids+=bobj.value.toUpperCase()+"^";	
				if (pbobj) pbobj.value=Patbatchids;
			} else {
				Patbatchids+="^";	
				if (pbobj) pbobj.value=Patbatchids;
			}
			//alert("currVolID: "+currVolID);
			if (currVolID!=""){
				if (RTMAVVolDescObj) VolDescIds+=RTMAVVolDescObj.value+"^";	
				//alert("vol1.3: "+pvobj.value+"VolDescIds: "+VolDescIds);
				if (pvobj) pvobj.value=VolDescIds;
			} else {

				//VolDescIds+="^";
				//if (pvobj) pvobj.value=VolDescIds;
				//if (pvobj) pvobj.value=pvobj.value+"^";
				//alert("VolDescIds else 2: "+pvobj.value);
				
			}
			//alert("vol2: "+pvobj.value+"VolDescIds: "+VolDescIds);
			
			//alert("findclick6: "+pobj.value+"***"+pvobj.value);
		}
	}
	//alert("findclick  : "+pobj.value+"\n"+pbobj.value+"\n"+pvobj.value);
	var selectedItems="";
	var frame=parent.frames["FindBulkTracking"];

	var tbl=frame.document.getElementById("tRTVolume_FindMultiPatientReqList");
	if (tbl) {
		var f=frame.document.getElementById("f"+tbl.id.substring(1,tbl.id.length)); 
		var lenobj=document.getElementById("TblLength");
		if (lenobj) lenobj.value=tbl.rows.length;

		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		
		if (aryfound.length>0){
			for (var i=0;i<aryfound.length;i++) {
				selectedItems=selectedItems+aryfound[i]+"^";
			}
		}	
		//ANA 29-APR-02 added in new field length for logLoc for demo. needs to be taken off later.
		if (tbl.rows.length>1) {
			//selectedItems=selectedItems+(tbl.rows.length);
			var fobj=document.getElementById("TRlength");
			if (fobj) fobj.value=tbl.rows.length;
		}
	}
	else {
		var fobj=document.getElementById("TRlength");
		if (fobj) fobj.value=1;
		//selectedItems=selectedItems+1; this has been commented out for demo purpose. 
		//will need to added back and the prev 2 lines taken off.
	}

	var iobj=document.getElementById("selectedItems");
	if (iobj) iobj.value=selectedItems;
	//alert("vol: "+document.getElementById("RTMAVVolDesc").value)
	//alert("findclick2  : "+pobj.value+"\n"+pbobj.value+"\n"+pvobj.value);

	/*
	if (ScanMode==false) {
		///new
		RTMAVVolDescObj=document.getElementById("RTMAVVolDesc");
		if (!RTMAVVolDescObj) RTMAVVolDescObj.value="";
		VolDescIds+=RTMAVVolDescObj.value+"^";
		if (pvobj) pvobj.value=VolDescIds;
		///endnew
	}*/
	//alert("findclick3  : "+pobj.value+"\n"+pbobj.value+"\n"+pvobj.value);
	if (match==false) {
		return find1_click();
	}		
}
function FindClick_Handler() {
	//alert("finding-in bulk request");
	var scObj=document.getElementById("scanFlag");
	var ScanMode=false;
	if ((scObj) && (scObj.checked==true)) {
		ScanMode=true;
		//alert("findclick-scanning: "+pobj.value+"**BB*"+pbobj.value+"***"+pvobj.value);
		//alert("scanning");
		find1_click();
		var Fobj=document.getElementById("find1");
		if (Fobj) { Fobj.disabled=false; Fobj.onclick=FindClick_Handler; }
		return true;
	}

	var currRegNO="";
	var currReqID="";
	var currBatchID="";
	var currVolID="";   //amin log 26048 added volume like on page 
	var currTYPID="";
	var currMRN="";
	RTMAVVolDescobj="";

	if (URobj1) currRegNO=URobj1.value; 
	if (Robj1) currReqID=Robj1.value;
	if (bobj) currBatchID=bobj.value;
	if (Tobjl) currTYPID=Tobjl.value;
	if (Tobj) {
		if (Tobj.value=="") currTYPID="";
	}
	if (mrnobj) currMRN=mrnobj.value;
	
	if (RTMAVVolDescObj) currVolID=RTMAVVolDescObj.value; //amin log 26048 added volume like on page 
	//alert("RTMAVVolDescObj.value: "+RTMAVVolDescObj.value);
	var match=false;
	if (pobj) URs=pobj.value;
	//alert("patientid: "+pobj.value);
	if (probj) PatReqids=probj.value;
	if (pbobj) Patbatchids=pbobj.value;
	if (pmrnobj) MRNs=pmrnobj.value;
	//alert("URs "+URs)
	if ((currRegNO!="")||(currReqID!="")||(currBatchID!="")||(currMRN!="")) {
		var match=MultiCheckAll(currRegNO,currReqID,currBatchID,currVolID,currMRN);
		//alert(match);
		if (!match){
			if (currRegNO!=""||currMRN!=""){
				//see if a volume is appended to the regnumber
				var VolPos = currRegNO.indexOf("-");
				//Log 64039 PeterC 20/06/07: Below flag set in the custom script
				if ((VolPos > 0)&&(HasRegoVolDelim=="Y"))
				{
					var regID = URobj1.value.substr(0,VolPos).toUpperCase();
					if (URobj1) {
						//Log 34767 PeterC
						//URs+=regID+"^";
						URs=regID+"^"+URs;
						//VolDescIds+=URobj1.value.substr(VolPos+1).toUpperCase()+"^";
						VolDescIds=URobj1.value.substr(VolPos+1).toUpperCase()+"^"+VolDescIds;
					}
					if(pur)	pur.value = regID; 	
				}
				else
				{
					
					if (URobj1) {
						//Log 34767 PeterC
						//URs+=URobj1.value.toUpperCase()+"^";
						URs=URobj1.value.toUpperCase()+"^"+URs;
					}
					else URs="^"+URs;
					if (currVolID=="") {
						//Log 34767 PeterC
						//VolDescIds+="^";
						VolDescIds="^"+VolDescIds;
					}
					if(pur)	pur.value = URs; 	
					
				}
				//alert("VolDescIds: "+VolDescIds);
				//alert("findclick0  : "+pobj.value+"\n"+pbobj.value+"\n"+pvobj.value);
				///if (vdobj) vdobj.value+=VolDescIds;		
				if (pvobj) pvobj.value=VolDescIds;		
				if (Vobj && URobj1) {
					//Log 34767 PeterC
					//Vobj.value+=URobj1.value.toUpperCase()+"^";
					Vobj.value=URobj1.value.toUpperCase()+"^"+Vobj.value;
				}
				if (pobj) pobj.value=URs;
				//alert("findclick01  : "+pobj.value+"\n"+pbobj.value+"\n"+pvobj.value);					
			} else {
				//Log 34767 PeterC
				//URs+="^";
				URs="^"+URs;
				if (pobj) pobj.value=URs;
			}
			//alert("findclick1  : "+pobj.value+"\n"+pbobj.value+"\n"+pvobj.value);
			//alert("patientid: "+pobj.value);
			//alert("URs "+URs);		
			if (currReqID!=""){
				if (Robj1) {
					//Log 34767 PeterC
					//PatReqids+=Robj1.value+"^";	
					PatReqids=Robj1.value+"^"+PatReqids;
				}
				if (probj) probj.value=PatReqids;
			} else {
				//Log 34767 PeterC
				//PatReqids+="^";
				PatReqids="^"+PatReqids;
				if (probj) probj.value=PatReqids;
			}
			MRNs=currMRN+"^"+MRNs;
			if (pmrnobj) pmrnobj.value=MRNs;
			if (currBatchID!=""){
				if (bobj) {
					//Log 34767 PeterC
					//Patbatchids+=bobj.value.toUpperCase()+"^";	
					Patbatchids=bobj.value.toUpperCase()+"^"+Patbatchids;
				}
				if (pbobj) pbobj.value=Patbatchids;
			} else {
				//Log 34767 PeterC
				//Patbatchids+="^";
				Patbatchids="^"+Patbatchids;	
				if (pbobj) pbobj.value=Patbatchids;
			}		
			//alert("currVolID: "+currVolID+"patienid: "+pobj.value);
			if (currVolID!=""){      
				//alert("before VolDescIds: "+VolDescIds);
				if (RTMAVVolDescObj) {
					//Log 34767 PeterC
					//VolDescIds+=RTMAVVolDescObj.value+"^";	
					VolDescIds=RTMAVVolDescObj.value+"^"+VolDescIds;
				}
				//alert("currentvolume not blank: "+pvobj.value+"VolDescIds: "+VolDescIds);
				if (pvobj) pvobj.value=VolDescIds;
			} else {
				//VolDescIds+="^";
				//if (pvobj) pvobj.value=VolDescIds;
				//if (pvobj) pvobj.value=pvobj.value+"^";
				//alert("currentvolblank else 2: "+pvobj.value);				
			}
			if (currTYPID!=""){
				if (Tobjl) {
					//Log 34767 PeterC
					//TYPIds+=Tobjl.value+"^";	
					TYPIds=Tobjl.value+"^"+TYPIds;	
				}
				if (pTobjl) pTobjl.value=TYPIds;
			} else {
				//Log 34767 PeterC
				//TYPIds+="^";
				TYPIds="^"+TYPIds;	
				if (pTobjl) pTobjl.value=TYPIds;
			}
			//alert("vol2: "+pvobj.value+"VolDescIds: "+VolDescIds);
			//alert(TYPIds);
			//alert("findclick6: "+pobj.value+"***"+pvobj.value);
			
		}
	}
	var selectedItems="";
	var frame=parent.frames["1"];
	if (frame) {
	var tbl=frame.document.getElementById("tRTVolume_FindMultiPatientReqList");
	if (tbl) {
			var f=frame.document.getElementById("f"+tbl.id.substring(1,tbl.id.length)); 
			var lenobj=document.getElementById("TblLength");
			if (lenobj) lenobj.value=tbl.rows.length;
			
			var aryfound=checkedCheckBoxesReverseOrder(f,tbl,"Selectz");
			if (aryfound.length>0){
				//alert("within if")
				for (var i=0;i<aryfound.length;i++) {
					//alert("Selectz"+aryfound[i])
					selectedItems=selectedItems+aryfound[i]+"^";
				}
			}
			//ANA 29-APR-02 added in new field TblLength for logLoc for queensland demo. 
			if (tbl.rows.length>1) {
				//selectedItems=selectedItems+(tbl.rows.length);
				var fobj=document.getElementById("TblLength");	
				if (fobj) fobj.value=tbl.rows.length;
			}
		}
		else {
			var fobj=document.getElementById("TblLength");
			if (fobj) fobj.value=1;
		}

	}
	var iobj=document.getElementById("selectedItems");
	if (iobj) iobj.value=selectedItems;
	//alert("findclick2  : "+pobj.value+"\n"+pbobj.value+"\n"+pvobj.value);
	/*
	if (ScanMode==false) {
		///new
		RTMAVVolDescObj=document.getElementById("RTMAVVolDesc");
		if (!RTMAVVolDescObj) RTMAVVolDescObj.value="";
		VolDescIds+=RTMAVVolDescObj.value+"^";
		if (pvobj) pvobj.value=VolDescIds;
		///endnew
	}*/
	//alert("URs: "+URs+"\n"+"VolDescIds: "+VolDescIds+"\n"+"Vobj.value: "+Vobj.value+"\n"+"PatReqids: "+PatReqids+"\n"+"Patbatchids: "+Patbatchids+"\n"+"TYPIds: "+TYPIds+"\n");
	//alert("findclick3  : "+pobj.value+"\n"+pbobj.value+"\n"+pvobj.value);
	if (match==false) {
		find1_click();
		var Fobj=document.getElementById("find1");
		if(Fobj){
			Fobj.disabled=false; Fobj.onclick=FindClick_Handler;
		}
		return true;

	}
}

function checkedCheckBoxesReverseOrder(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var i=tbl.rows.length;i>0;i--) {
		if (f.elements[col+i] && f.elements[col+i].checked && !f.elements[col+i].disabled) {
			//alert("i="+i+" tbl.rows.length="+tbl.rows.length);
			aryfound[found]=tbl.rows.length-i;found++;
		}
	}
	return aryfound;
}
//Original Find click Handler ANA OCT 10th.
/*function FindClick_Handler() {

	var match=false;
	var currRegNo="";

	if (URobj1) currRegNO=URobj1.value;	
	if ((URobj1) && (Robj1) && (bobj)) {
		if ((URobj1.value!="") && (Robj1.value=="") && (bobj.value=="")) //match=MultiCheck(Vobj.value,URobj1);
		match=MultiCheck(URs,URobj1);
		if (!match){
			//see if a volume is appended to the regnumber
			var VolPos = currRegNO.indexOf("-");
			if (VolPos > 0){
				var regID = URobj1.value.substr(0,VolPos).toUpperCase();
				if (URobj1) URs+=regID+"^";
					VolDescIds+=URobj1.value.substr(VolPos+1).toUpperCase()+"^";
				if(pur)
					pur.value = regID; 	
			}else{
				if (URobj1) URs+=URobj1.value.toUpperCase()+"^";
				VolDescIds+="^";
				if (pur) pur.value = URobj1.value; 	
			}
		    if (vdobj) vdobj.value+=VolDescIds;		
			if (Vobj) Vobj.value+=URobj1.value.toUpperCase()+"^";	
		}
	}
	if (pobj) pobj.value=URs;
	
	if ((URobj1) && (Robj1) && (bobj)) {
		if ((URobj1.value=="") && (Robj1.value!="") && (bobj.value=="")) match=MultiCheck(PatReqids,Robj1);
	}
	if (Robj1) PatReqids+=Robj1.value+"^";	
	if (probj) probj.value=PatReqids;
	if ((URobj1) && (Robj1) && (bobj)) {
		if ((URobj1.value=="") && (Robj1.value=="") && (bobj.value!="")) match=MultiCheck(Patbatchids,bobj);
	}
	if (bobj) Patbatchids+=bobj.value.toUpperCase()+"^";	
	if (pbobj) pbobj.value=Patbatchids;
	
	var selectedItems="";
	var frame=parent.frames["1"];
	if (frame) {
	var tbl=frame.document.getElementById("tRTVolume_FindMultiPatientReqList");
	if (tbl) {
			var f=frame.document.getElementById("f"+tbl.id.substring(1,tbl.id.length)); 
			var lenobj=document.getElementById("TblLength");
			if (lenobj) lenobj.value=tbl.rows.length;
			
			var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
			if (aryfound.length>0){
				//alert("within if")
				for (var i=0;i<aryfound.length;i++) {
					//alert("Selectz"+aryfound[i])
					selectedItems=selectedItems+aryfound[i]+"^";
				}
			}
			//ANA 29-APR-02 added in new field TblLength for logLoc for queensland demo. 
			if (tbl.rows.length>1) {
				//selectedItems=selectedItems+(tbl.rows.length);
				var fobj=document.getElementById("TblLength");	
				if (fobj) fobj.value=tbl.rows.length;
			}
		}
		else {
			var fobj=document.getElementById("TblLength");
			if (fobj) fobj.value=1;
		}

	}
	var iobj=document.getElementById("selectedItems");
	if (iobj) iobj.value=selectedItems;

	if (match==false) {
		return find1_click();

	}
}*/

function LookUpRecordType(str){
	var strArry=str.split("^");
	if (Tobj) Tobj.value=strArry[0];
	if (Tobjl) Tobjl.value=strArry[1];
	//alert("record ty id "+TYPIDObj.value)
}

function UROnChangeHandler(evt) {
	ChrCode='';
	if ((URobj1) && (URobj1.value!="")) {
		window.setTimeout(SelectField,350)
		window.setTimeout(FindClick_Handler,50)
		//FindClick_Handler();
		//SelectField();
	}

}

function RequestIDOnChangeHandler(evt) {
	ChrCode='';
	if ((Robj1) && (Robj1.value!="")) {
		FindClick_Handler();
	
		SelectField();
	}

}

function ReqBatchIDOnChangeHandler(evt) {
	ChrCode='';
	if ((bobj) && (bobj.value!="")) {
		FindClick_Handler();
	
		SelectField();
	}
}

function SelectField() {
	var URobj=document.getElementById("UR");
	
	if (URobj) {
		URobj.focus();
		URobj.select();

	}
}	


function URSelectHandler(str) {
	//alert(str);
	var lu=str.split("^");
	var obj=document.getElementById("UR");
	if (obj) obj.value=lu[0];
	
}

function UR_changehandler(encmeth) {	//have to have for broker only!!!
	UROnChangeHandler();
	var obj=document.getElementById('UR');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('UR');
	if (cspRunServerMethod(encmeth,'','URSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields. 
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function docLoaded() {
	
	//Log 46159 PeterC 06/09/04 Need to timeout for the location field to change
	if (tsc['find1']) {
		websys_sckeys[tsc['find1']]=TSCMRType;
	}
	window.setTimeout("DocLoadedDelay()",500)
}


function TSCMRType() {
	var TYPObj=document.getElementById("TYPDesc");
	if((TYPObj)&&(TYPObj.value!="")&&(TYPObj.onchange)) TYPObj.onchange();
	window.setTimeout("FindClick_Handler()",200);
}

function DocLoadedDelay() {
	
}

var URs="";
var PatReqids="";
var Patbatchids="";
var VolDescIds="";
var TYPIds="";
var MRNs="";
var RTMAVVolDescobj=""; //amin log 26048 added volume like on page

var URobj1=document.getElementById("UR");
//if (URobj1) URobj1.focus();
//Log 34282 PeterC: UROnChangeHandler now moved to UR_changehandler
//if (URobj1) URobj1.onchange=UROnChangeHandler;
var fobj=document.getElementById("find1");
if (fobj) {
	//Log 46159 PeterC 06/09/04 Need to timeout for the location field to change
	fobj.disabled=false;
	//fobj.onclick=FindClick_Handler;
	fobj.onclick=TSCMRType;
}
var Robj1=document.getElementById("RequestIDs");
if (Robj1) Robj1.onchange=RequestIDOnChangeHandler;
var pobj=document.getElementById("patids");
var probj=document.getElementById("patreqids");
var bobj=document.getElementById("ReqBatchID");
if (bobj) bobj.onchange=ReqBatchIDOnChangeHandler;
var pbobj=document.getElementById("patbatchids");
var pur=document.getElementById("PUR");
//var vdobj=document.getElementById("VolDescs");

var pvobj=document.getElementById("VolDescs");
var Vobj=document.getElementById("VolDesc");

var Tobjl=document.getElementById("TYPID");
var pTobjl=document.getElementById("TYPIDs");
var Tobj=document.getElementById("TYPDesc");
var mrnobj=document.getElementById("MRN");
var pmrnobj=document.getElementById("MRNs");

var sfObj=document.getElementById("scanFlag");
if (sfObj) sfObj.onclick=SelectField;
var RTMAVVolDescObj=document.getElementById("RTMAVVolDesc");
//RTMAVVolDescobj=document.getElementById("RTMAVVolDesc");//amin log 26048 added volume like on page
document.body.onload=docLoaded; 