//≤°»À–≈œ¢
var LabEpisode=document.getElementById('LabEpisode');
var AuthDateTime=document.getElementById('AuthDateTime');
var ReqDateTime=document.getElementById('ReqDateTime');
var SpecDateTime=document.getElementById('SpecDateTime');
var OrdSpecimen=document.getElementById('OrdSpecimen');
var PatAge=document.getElementById('PatAge');
var RecDateTime=document.getElementById('RecDateTime');
var ReqDoctor=document.getElementById('ReqDoctor');
var Ward=document.getElementById('Ward');
var Location=document.getElementById('Location');
var OrdName=document.getElementById('OrdName');
var TestSetRow=document.getElementById('TestSetRow');

LabEpisode.readOnly=true;
AuthDateTime.readOnly=true;
ReqDateTime.readOnly=true;
SpecDateTime.readOnly=true;
OrdSpecimen.readOnly=true;
PatAge.readOnly=true;
RecDateTime.readOnly=true;
ReqDoctor.readOnly=true;
Ward.readOnly=true;
Location.readOnly=true;
OrdName.readOnly=true;
function SetLabInfo(TSID)	{
	var TSInfo=document.getElementById('GetLabInfo');
	if (TSInfo) {var encmeth=TSInfo.value} else {var encmeth=''};
	var myExpStr="";
	//alert(TSID);
	var TSInfoStr=cspRunServerMethod(encmeth,TSID);
	//alert(TSInfoStr);
	if (TSInfoStr=='') {return 0;}
	var LabInfo=TSInfoStr.split("^");
	//tadmId.value=PatInfo[0];
	
	OrdSpecimen.value=LabInfo[0];
	//ReqDoctor.value=LabInfo[1];
    Ward.value=LabInfo[2];
    Location.value=LabInfo[3];
    ReqDateTime.value=LabInfo[4];
    SpecDateTime.value=LabInfo[5];
    RecDateTime.value=LabInfo[6];
    AuthDateTime.value=LabInfo[7];
    OrdName.value=LabInfo[8];
    LabEpisode.value=LabInfo[9];
    TestSetRow.value=LabInfo[10];
    //getLabInfo(PatientID.value);

    //getOrderItem();
  
}

function ChkAbnormalResult() {
	var tbl=document.getElementById("tDHCLabOrderResult");
	for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
		var FlagValue = document.getElementById("WarnFlagz" + curr_row);
		//var FlagCode=document.getElementById("OtherFlagCodez" + curr_row);
        if ((FlagValue)&&(FlagValue.value!="N")){
	        //alert(FlagValue.innerText);
        	MarkAsAbnormal(curr_row,tbl);
        }
	}
}
function MarkAsAbnormal(CurrentRow,tableobj) {
	for (var CurrentCell=0; CurrentCell<tableobj.rows[CurrentRow].cells.length; CurrentCell++) {
		tableobj.rows[CurrentRow].cells[CurrentCell].style.color="Red";
   	}
}
function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		if (eSrc.parentElement) {
			eSrc=eSrc.parentElement;
		} else {
			eSrc="";
			break;
		}
	}
	return eSrc;
}
function BodyLoadHandler() {
	//var objTestSetRow=document.getElementById("TestSetRow");
	var objTestSetRow=document.getElementById("OrderID");
	if ((objTestSetRow)&&(objTestSetRow.value!="")) {
		var TestSetRow=objTestSetRow.value;
   	   SetLabInfo(TestSetRow);
	} else {alert(t['02']);}
	ChkAbnormalResult();
}
function BodyUnLoadHandler(){

}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;