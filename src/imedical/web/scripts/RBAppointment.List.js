// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tRBAppointment_List");
var f=document.getElementById("fRBAppointment_List");
var dt=f.elements['DateNow'].value;

function DocumentLoadHandler() {

	//obj = document.getElementById("PatientDetails")
	//obj.onclick = PatientDetailsClickHandler;
	//LOG 29800 28-10-2002 BC
	SetCorrectLink();

}

//function PatientDetailsClickHandler(e) {
//	var eSrc = websys_getSrcElement(e);
//	var obj = document.getElementById("PatientDetails");
//	if (eSrc.name=="PatientDetails") {
//		alert(eSrc.innerText)
//		var currentlink=eSrc.href.split("?");
//		eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Edit&" + currentlink[1];
//		alert(eSrc.href)
//		//return false
//	}
//}

//LOG 29800 28-10-2002 BC
document.body.onload = DocumentLoadHandler;

// LOG 28946 RC 02/10/02 Had to create a new instance of the change outcome handler in this script to handle the resource id properly.
// Consequently added two new fields in the RBAppointment.List: ApptID and DateNow.


function RBAppointmentList_ChangeOCHandler() {
	try {
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			var RescID=f.elements['ApptIDz'+rowid].value;
			if (RescID!="") RescID=RescID.split("||");
			websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.OutcomeOfAppt&RescID='+RescID[0]+'&date='+dt+'&ID='+f.elements['ApptIDz'+rowid].value,'out','top=0,left=0,width=400,height=400');
		}
		if (aryfound.length>0) {
			var aryID=new Array();var aryOutcome=new Array();var n=0;var RescID=new Array();
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					if ((aryfound[j]==i)||(selectedRowObj.rowIndex==i)) {
						aryID[n]=f.elements['ApptIDz'+i].value;
						RescID[n]=aryID[n].split("||");
						//alert (aryID[n])
						if (f.elements['OutcomeCodez'+i]) aryOutcome[n]=f.elements['OutcomeCodez'+i].value;
						n++
					}
				}
			}
	websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.OutcomeOfAppt&RescID='+RescID.join(",")+'&date='+dt+'&ID='+aryID.join(","),'out','top=0,left=0,width=400,height=400');

		}
	} catch(e) {
		if ((selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			var RescID=f.elements['ApptIDz'+rowid].value;
			if (RescID!="") RescID=RescID.split("||");
			websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.OutcomeOfAppt&RescID='+RescID[0]+'&date='+dt+'&ID='+f.elements['ApptIDz'+rowid].value,'out','top=0,left=0,width=400,height=400');
		}
	}
}
//LOG 29800 28-10-2002 BC
function SetCorrectLink() {
	//Sets the correct link to RBEvent.Edit.csp if the appointment is part of an event
		for (var i=1;i<tbl.rows.length;i++) {
			//var Service=f.elements['SERDescz'+i];
			var Service=document.getElementById("SERDescz"+i);
			var EventID=f.elements['EventIDz'+i].value;
			if ((EventID!="")&&(Service)) {
				//alert(i+"   " +Service.innerHTML+ "    "+EventID);
				var url="<A id=SERDescz"+i+" name=SERDescz"+i+" HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('rbevent.edit.csp?ID="+EventID+"',false,'top=10,left=10');"+'"'+" >"+Service.innerHTML+'</A>';
				Service.outerHTML=url;
			}
		}
}