<!-- Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. --> 
var cfobj=document.getElementById("ConfSelect");
if (cfobj && cfobj.value=="Y") {
	var slobj=document.getElementById("Selectz1");
	if(slobj) slobj.checked=true;
}

function SERDescLookUpSelect(str) { //Returned from RBAppointment Desc:Message:HIDDEN:,Frequency:,Duration:
	if (str=="") return;
	var lu = str.split("^");
	//alert(str);
	//alert("0=desc= "+lu[0])
	//alert("1=msg= "+lu[1])
	//alert("2=id= "+lu[2])
	//alert("3=Frequency= "+lu[4]) // Freq
	//alert("4=Duration= "+lu[5]) //Duration
	//alert("5=freqfactor= "+lu[6]) //freq factor
	//alert("6=int in days= "+lu[7]) //Interval in days
	//alert("7=dur factor= "+lu[8]) //duration factor
	//alert("8=dispensing time = "+lu[9]) //Dispensing Time

	//LOG 43072 PeterC 01/04/04 There is a mis-alignment of lu[x], below is the correct parameter position
	//0=Code, 1=Description, 2=Message, 3=ID, 4=Frequency, 5=Duration, 
	//6=FreqFactor, 7=FreqIntDays, 8=DurFactor, 9=DipensingTime, 10bypassdatecheck

	var obj=document.getElementById('Service');
	if (obj) obj.value=lu[1];
	var templu=lu[3].split(String.fromCharCode(4));
	lu[3]="";
	for (var bm8=0;bm8<templu.length;bm8++) {
		if (lu[3]=="") lu[3]=templu[bm8];
		else lu[3]=lu[3]+"^"+templu[bm8];
	}
	var SSobj=document.getElementById('StepServiceID');
	if (SSobj) SSobj.value=lu[3];
	
	var Freqobj=document.getElementById('PHCFRDesc1'); //Freq log 31442 added lookups
	if (Freqobj) Freqobj.value=lu[4];
	
	var Durobj=document.getElementById('PHCDUDesc1'); //Duration log 31442 added lookups
	if (Durobj) {
		if (lu[3]==""){   
			Durobj.value=""; //ID = 5^SS = lu[2] &lu[3] when nothing comes lenth of str changes from 0-5 to 0-4
		}else{  Durobj.value=lu[5]; 
		}
	}
	
	var FreqFactobj=document.getElementById('Freqfactor'); //freqFactor(valye) log 31442 added lookups
	if (FreqFactobj) FreqFactobj.value=lu[6];
	
	var DurFactobj=document.getElementById('DurFactor'); //Duration factor(value) log 31442 added lookups
	if (DurFactobj) DurFactobj.value=lu[8];
	
	var IntInDaysObj=document.getElementById('IntInDays'); //Interval In Days log 31442 added lookups
	if (IntInDaysObj) IntInDaysObj.value=lu[7];	
	
	var DispTimeObj=document.getElementById('DispTime'); //Dispensing Time log 31442 added lookups
	if (lu[9] && (lu[9]!="")){
		var ARR=lu[9].split("*");
		lu[9]=ARR.join("*")
	}
	//alert(DispTimeObj+"  "+lu[8]);
	if (DispTimeObj) {
		if (lu[9]&&(lu[9]!=""))	DispTimeObj.value=lu[8];
		else DispTimeObj.value="";
	}
	//alert("Disp Time value when inserting  "+DispTimeObj.value);
}

function FreqLookUpSelect(str) { //Returned from RBAppointment Desc:Message:HIDDEN:,Frequency:,Duration:
	var lu = str.split("^");
	//alert("1=freq desc= "+lu[0]) 
	//alert("2=freq code= "+lu[1]) 
	//alert("3= freq factor= "+lu[2])
	//alert("4= IntInDays = "+lu[3]) 
	//alert("5=dispensing time = "+lu[4])

	
	var Freqobj=document.getElementById('PHCFRDesc1'); //Freq log 31442 added lookups
	if (Freqobj) Freqobj.value=lu[0];
	

	var FreqFactobj=document.getElementById('Freqfactor'); //freqFactor(valye) log 31442 added lookups
	if (FreqFactobj) FreqFactobj.value=lu[2];
	
	var IntInDaysObj=document.getElementById('IntInDays'); //Interval In Days log 31442 added lookups
	if (IntInDaysObj) IntInDaysObj.value=lu[3];	
	
	var DispTimeObj=document.getElementById('DispTime'); //Dispensing Time log 31442 added lookups
	if (DispTimeObj) DispTimeObj.value=lu[4];
}
function DurLookUpSelect(str) { //Returned from RBAppointment Desc:Message:HIDDEN:,Frequency:,Duration:
	var lu = str.split("^");
	//alert("1=dur desc= "+lu[0]) 
	//alert("2=dur code= "+lu[1]) 
	//alert("3= dur factor= "+lu[2])

	
	var Durobj=document.getElementById('PHCDUDesc1'); //Duration log 31442 added lookups
	if (Durobj) Durobj.value=lu[0]; 

	var DurFactobj=document.getElementById('DurFactor'); //Duration factor(value) log 31442 added lookups
	if (DurFactobj) DurFactobj.value=lu[2];
}
function ServiceTextChangeHandler() {
	//SB 12/06/02: This function is called from RBAppointment.LookUpBrokerServ, as the onchange handler overwrites the broker method.
	//Do not remove.
}

function DeselectAll(e) {  //AmiN log 30869	
	var tbl=document.getElementById("tMRClinicalPathways_CarePlanSchedule");
	var f=document.getElementById("tMRClinicalPathways_CarePlanSchedule");	
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Selectz'+j);
			if ((obj) && (!obj.disabled)) {
				obj.checked=false;				
			}
		}
	}
	return false;
}

function SelectAll(e) {  //AmiN log 30869	
	var tbl=document.getElementById("tMRClinicalPathways_CarePlanSchedule");
	var f=document.getElementById("fMRClinicalPathways_Schedule");	
	if ((f)&&(tbl)) {		
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('Selectz'+j);
			if ((obj) && (!obj.disabled)) {
				obj.checked=true;				
			}
		}
	}
	return false;
}
// Body Load handler is written in UpdateScedulepage. this bodyload does not run since both js's belong to the same csp
function BodyLoadHandler() {
	var ServString="";
	//alert("IN bodyloadhandler Careplansched");
	
	var SSobj=CPSchedForm.document.getElementById('ServString'); 
	if (SSobj) ServString=SSobj.value; 
	//alert("serv string "+ServString);
	if (ServString!="") {
		SERDescLookUpSelect(ServString);
	}
	
}
