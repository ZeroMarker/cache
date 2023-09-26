document.body.onload = BodyLoadHandler;

function BodyLoadHandler(){
	var Obj=document.getElementById('Update');
	if (Obj) Obj.onclick = UpdateClickHandler;
	var Obj=document.getElementById("ConsultDepList");
	if (Obj) Obj.onchange=ConsultDepListChangeHander;
	var Obj=document.getElementById("ConsultDocList");
	if (Obj) Obj.onchange=ConsultDocListChangeHander;
	
	//通过用户得到诊区内的所有科室
	LoadConsultDepList(session['LOGON.USERID']);
}
function LoadConsultDepList(UserID){
	var Para=DHCC_GetElementData("Para");
	var RoomId=Para.split("^")[1]
	DHCC_ClearList("ConsultDepList");
	var ConsultDepListObj=document.getElementById("ConsultDepList");
	var encmeth=DHCC_GetElementData("GetBorDepListByUser");
	if (encmeth!=""){
		//var rtnStr=cspRunServerMethod(encmeth,UserID);
		var rtnStr=cspRunServerMethod(encmeth,RoomId);
		var rtnArray=rtnStr.split("^");
		for (var i=0;i<rtnArray.length;i++){
			var rtnArrayTemp=rtnArray[i].split(String.fromCharCode(1))
			ConsultDepListObj.options[i]=new Option(rtnArrayTemp[1],rtnArrayTemp[0])
		}
	}
}

function ConsultDepListChangeHander(){
	DHCC_ClearList("ConsultDocList");
	var ConsultDepListObj=document.getElementById("ConsultDepList");
	if (ConsultDepListObj.options[ConsultDepListObj.selectedIndex].selected==true){
		for (var i=0;i<ConsultDepListObj.length;i++){
			if (i==ConsultDepListObj.selectedIndex) continue;
			if (ConsultDepListObj.options[i].selected==true)ConsultDepListObj.options[i].selected=false;
		}
	}
	var SelDepID=DHCC_GetListSelectedValue("ConsultDepList");
	SetDocList(SelDepID);
}
function SetDocList(DepID){
	if (DepID=="")return;
	var ConsultDocListObj=document.getElementById("ConsultDocList");
	var ConsultDocListLen=ConsultDocListObj.length;
	var encmeth=DHCC_GetElementData("GetConsultDocListByDepID");
	if (encmeth!=""){
		var rtnStr=cspRunServerMethod(encmeth,DepID);
		var rtnArray=rtnStr.split("^");
		for (var i=ConsultDocListLen;i<ConsultDocListLen+rtnArray.length;i++){
			var rtnArrayTemp=rtnArray[i-ConsultDocListLen].split(String.fromCharCode(1))
			ConsultDocListObj.options[i]=new Option(rtnArrayTemp[1],rtnArrayTemp[0])
		}
	}
	
}
function ConsultDocListChangeHander(){
	var ConsultDocListObj=document.getElementById("ConsultDocList");
	if (ConsultDocListObj.options[ConsultDocListObj.selectedIndex].selected==true){
		for (var i=0;i<ConsultDocListObj.length;i++){
			if (i==ConsultDocListObj.selectedIndex) continue;
			if (ConsultDocListObj.options[i].selected==true)ConsultDocListObj.options[i].selected=false;
		}
	}
}

function UpdateClickHandler(){
	var Para=DHCC_GetElementData("Para");
	var SelDepID=DHCC_GetListSelectedValue("ConsultDepList");
	var SelDocID=DHCC_GetListSelectedValue("ConsultDocList");
	if (SelDepID==""){
		alert("请选择会诊科室");
		return;
	}
	if (SelDocID==""){
		alert("请选择会诊医生");
		return;
	}
	var encmeth=""
	var Obj=document.getElementById("UpdateMethod");
	if (Obj) encmeth=Obj.value;
	if (encmeth!=""){
		//var Para=Para+"^"+RoomID+"^"+SeqNo;
		var ExpStr=SelDepID+"^"+SelDocID+"^"+"Y"+"^"+session['LOGON.USERID'];
		var ret=cspRunServerMethod(encmeth,Para,ExpStr);
		if (ret!="0"){
			alert("会诊记录失败,Code:"+ret);
		}else{
			alert("会诊记录成功");
		}
	}
	
	var par_win = window.opener;
	if (par_win){
		//var CardNo=DHCC_GetElementData("CardNo");
    try{
			par_win.FindPatQueue("","");
    }catch(e){alert(e.message)}
 		window.setTimeout("window.close();",500);	
	}
}