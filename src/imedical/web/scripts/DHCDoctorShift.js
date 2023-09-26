//DHCDoctorShift.js
document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=document.getElementById("Add");
	if(obj) obj.onclick=AddPat_Click;
	var DepStr=DHCC_GetElementData('DepStr');
	ComboRecDep=dhtmlXComboFromStr("Dept",DepStr);
	ComboRecDep.enableFilteringMode(true);
	ComboRecDep.selectHandle=ComboRecDepselectHandle;
	
	var DefDept=session['LOGON.CTLOCID'];
	
	var DepRowidobj=document.getElementById('DepRowid');
	if (DepRowidobj){
		DepRowidobj.value=DefDept;
	}
	//alert(DepStr)
	//alert(DefDept)
	ComboRecDep.setComboValue(DefDept);
	var obj=document.getElementById('ShiftFromDoc');
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	var obj=document.getElementById('ShiftToDoc');
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	InitDoctorShift();
}
function InitDoctorShift(){
	//在界面初始化的时候读到这个医生的接班记录
	var InfoStr=getDSRowID();
	var InfoArr=InfoStr.split("^");
	if (InfoArr[0]){
		var DSRowID=InfoArr[0];
		var AdmissionNum=InfoArr[1];
		var BorrowInNum=InfoArr[2];
		var BorrowOutNum=InfoArr[3];
		var ChildbirthNum=InfoArr[4];
		var DeadNum=InfoArr[5];
		var DeptDR=InfoArr[6];
		var DischargedNum=InfoArr[7];
	  var PMRoundsNotes=InfoArr[8];
	  var RescueNum=InfoArr[9];
	  var ShiftDate=InfoArr[10];
	  var ShiftFromDocDR=InfoArr[11];
	  var ShiftPattern=InfoArr[12];
	  var ShiftToDocDR=InfoArr[13];
	  var ShiftTotal=InfoArr[14];
	  var SurgeryNumber=InfoArr[15];
	  var TransferInNum=InfoArr[16];
	  var TransferOutNum=InfoArr[17];
	  var WoundCheckNum=InfoArr[18];
	  var SerialIllNum=InfoArr[19];
	  
	  var obj=document.getElementById('DSRowID');
	  if (obj){
	  	obj.value=DSRowID;
	  }
	  var obj=document.getElementById('AdmissionNum');
	  if (obj){
	  	obj.value=AdmissionNum;
	  }
	  var obj=document.getElementById('BorrowInNum');
	  if (obj){
	  	obj.value=BorrowInNum;
	  }
	  var obj=document.getElementById('BorrowOutNum');
	  if (obj){
	  	obj.value=BorrowOutNum;
	  }
	  var obj=document.getElementById('ChildbirthNum');
	  if (obj){
	  	obj.value=ChildbirthNum;
	  }
	  var obj=document.getElementById('DeadNum');
	  if (obj){
	  	obj.value=DeadNum;
	  }
	  var obj=document.getElementById('DischargedNum');
	  if (obj){
	  	obj.value=DischargedNum;
	  }
	  var obj=document.getElementById('PMRoundsNotes');
	  if (obj){
	  	obj.value=PMRoundsNotes;
	  }
	  var obj=document.getElementById('RescueNum');
	  if (obj){
	  	obj.value=RescueNum;
	  }
	  var obj=document.getElementById('ShiftTotal');
	  if (obj){
	  	obj.value=ShiftTotal;
	  }
	  var obj=document.getElementById('SurgeryNumber');
	  if (obj){
	  	obj.value=SurgeryNumber;
	  }
	  var obj=document.getElementById('TransferInNum');
	  if (obj){
	  	obj.value=TransferInNum;
	  }
	  var obj=document.getElementById('TransferOutNum');
	  if (obj){
	  	obj.value=TransferOutNum;
	  }
	  var obj=document.getElementById('WoundCheckNum');
	  if (obj){
	  	obj.value=WoundCheckNum;
	  }
	  var obj=document.getElementById('SerialIllNum');
	  if (obj){
	  	obj.value=SerialIllNum;
	  }
	  
	  
	}
	
	
}
function getDSRowID(){
	var userid=session['LOGON.USERID'];
	//var ShiftToDocID=;
	var tkClass='web.DHCDoctorShift';
  var tkMethod='GetDSRowID';
  var ret=tkMakeServerCall(tkClass,tkMethod,userid);
  return ret;
}
function AddPat_Click()
{
	var DSRowID="";
	var ShiftFromDoc="";
	var ShiftToDoc="";
	var DSRowIDobj=document.getElementById('DSRowID');
	if (DSRowIDobj){
		DSRowID=DSRowIDobj.value;
	}
	var ShiftFromDocobj=document.getElementById('ShiftFromDoc');
	if (ShiftFromDocobj){
		ShiftFromDoc=ShiftFromDocobj.options[ShiftFromDocobj.selectedIndex].text;
	}
	var ShiftToDocobj=document.getElementById('ShiftToDoc');
	if (ShiftToDocobj){
		ShiftToDoc=ShiftToDocobj.options[ShiftToDocobj.selectedIndex].text;
	}
	alert(ShiftFromDoc+"%"+ShiftToDoc);
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDoctorShiftEdit&DSIDSParRef="+DSRowID+"&ShiftFromDoc="+ShiftFromDoc+"&ShiftToDoc="+ShiftToDoc;
	win=open(lnk,"AddDocShift","status=1,top=150,left=150,width=1000,height=650")
}
function ComboRecDepselectHandle(){
	try {
		
		var LocID=ComboRecDep.getSelectedValue();
    document.getElementById('DepRowid').value=LocID;
    SetResDocList(LocID);
	}catch(e){
		alert(e.message);
	}	
}
function SetResDocList(LocID){
	var obj=document.getElementById('ShiftFromDoc');
	ClearAllList(obj);
	var obj=document.getElementById('ShiftToDoc');
	ClearAllList(obj)
	if (LocID=="") return;
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
function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}
function AddToResDocList(val){
	//alert("val"+val)
	var obj=document.getElementById('ShiftFromDoc');
	//ClearAllList(obj)
	var DocArray=val.split("^");
	for (var i=0;i<DocArray.length;i++) {
		var DocData=DocArray[i].split(String.fromCharCode(1));
		obj.options[obj.length] = new Option(DocData[1],DocData[0]);
	}
	var obj=document.getElementById('ShiftToDoc');
	//ClearAllList(obj)
	for (var i=0;i<DocArray.length;i++) {
		var DocData=DocArray[i].split(String.fromCharCode(1));
		obj.options[obj.length] = new Option(DocData[1],DocData[0]);
	}
}
