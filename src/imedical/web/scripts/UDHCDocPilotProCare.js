//UDHCDocPilotProCare.js
document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var Obj=document.getElementById("ProjectList");
	if (Obj) {
		Obj.onchange=ProjectListChangeHander;
		Obj.onclick=ProjectListClick;
	}
	var Obj=document.getElementById("SelAdd");
	if (Obj) Obj.onclick=SelAddClick;
	var Obj=document.getElementById("SelDel");
	if (Obj) Obj.onclick=SelDelClick;
	var Obj=document.getElementById("Save");
	if (Obj) Obj.onclick=SaveClick;
	var Obj=document.getElementById("JionUserList");
	if (Obj) Obj.onclick=JionUserListClick;
	var Obj=document.getElementById("UpdateWarnSum");
	if (Obj) Obj.onclick=UpdateWarnSumClick;
	
	LoadProjectList();
	if (window.name=="JoinUser")SetOnlyOneProjectList();
	DisabledElement("cContactFlag",false);
	DisabledElement("ContactFlag",false);
	DisabledElement("cContactTel",false);
	DisabledElement("ContactTel",false);
	HiddenWarnSum("hidden")
	var Obj=document.getElementById('FindProjectList');
	if (Obj){
	  Obj.onkeyup =FindProjectListChange;
	}
}
var TimeOutDept;
function FindProjectListChange(){
	var FindProjectStr=DHCC_GetElementData('FindProjectList');
	var tmp=document.getElementById('ProjectList');
	if(FindProjectStr==""){
		tmp.selectedIndex=-1
		return 	
	}
	if(TimeOutDept){
		clearTimeout(TimeOutDept)    
	}
	TimeOutName=setTimeout("FindDept()",500)
}
function FindDept(){
	var FindProjectStr=DHCC_GetElementData('FindProjectList');	
	FindProjectStr=FindProjectStr.toUpperCase()
	var tmp=document.getElementById('ProjectList');
	var len=tmp.length
	var ProjectId=""
	for(var i=0;i<len;i++){
		var selItem=tmp.options[i];	
		var selText=selItem.text
		var selTextArr=selText.split("-")
		if ((selTextArr[0].toUpperCase().indexOf(FindProjectStr)>=0)||(selTextArr[1].toUpperCase().indexOf(FindProjectStr)>=0)){
			tmp.selectedIndex=i;
			ProjectListClick();
			ProjectListChangeHander();
			ProjectId=selItem.value
			break;
		}
	}
	if(ProjectId==""){
		tmp.selectedIndex=-1;
		ProjectListClick();
		ProjectListChangeHander();
	}
}	
function LoadProjectList(){
	var ProjectListObj=document.getElementById("ProjectList");
	
	var Str=DHCC_GetElementData("GetProjectStr");
	var myArray=DHCC_StrToArray(Str);
	for (var i=0;i<myArray.length;i++){
		var myArrayTemp=myArray[i];
		ProjectListObj.options[i]=new Option(myArrayTemp[1],myArrayTemp[0])
	}
	
}
function SetOnlyOneProjectList(){
	var ProjectListObj=document.getElementById("ProjectList");
	var PPRowId=DHCC_GetElementData("PPRowId");
	
	for (var i=0;i<ProjectListObj.length;i++){
		if((ProjectListObj.options[i].value==PPRowId)&&(PPRowId!="")){
			ProjectListObj.options[i].selected=true;
			SetJoinUserList(PPRowId);
			SetWarnSum(PPRowId)
			ProjectListObj.disabled=true;
			ProjectListObj.onclick=function(){return false;}
			ProjectListObj.onchange=function(){return false;}
			return;
		}
	}
}
function ProjectListChangeHander(){
	var ProjectListObj=document.getElementById("ProjectList");
	var selIndex=ProjectListObj.selectedIndex;
	if (selIndex==-1) return;
	var SelectedPro=GetSelectedPro();
	if (SelectedPro==false){
		alert("不可以多选.");
		ProjectListObj.options[selIndex].selected=false;
		return;
	}
	var PPRowId=ProjectListObj.options[selIndex].value;
	SetJoinUserList(PPRowId);
	SetWarnSum(PPRowId)
}
function ProjectListClick(){
	/*
	var ProjectListObj=document.getElementById("ProjectList");
	var SelectedPro=GetSelectedPro();
	if (SelectedPro==false){
		alert("不可以多选.");
		return;
	}
	for(var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected==true){
			var PPRowId=ProjectListObj.options[i].value;
			SetJoinUserList(PPRowId);
		}
	}
	*/
	DisabledElement("cContactFlag",false);
	DisabledElement("ContactFlag",false);
	DisabledElement("cContactTel",false);
	DisabledElement("ContactTel",false);
	return
}
function JionUserListClick(){
	var obj=document.getElementById("JionUserList");
	if (obj) {
		if (obj.selectedIndex!=-1){
			var JionUserRowId=obj.options[obj.selectedIndex].value;
			if (JionUserRowId==""){
				alert("请选择有效的参与者");
				DisabledElement("cContactFlag",false);
				DisabledElement("ContactFlag",false);
				DisabledElement("cContactTel",false);
				DisabledElement("ContactTel",false);
				return
			}
			var CurIndex=GetSelectedIndex();
			if (CurIndex<0){
				alert("没有选择科研项目.");
				return;
			}
			var ProjectListObj=document.getElementById("ProjectList");
			var PPRowId=ProjectListObj.options[CurIndex].value;
			
			var encmeth=DHCC_GetElementData("GetProCareInfo");
			if (encmeth!="") {
				var ProCareInfo=cspRunServerMethod(encmeth,PPRowId,JionUserRowId);
				if (ProCareInfo!="") {
					var ProCareAry=ProCareInfo.split("^");
					var Rowid=ProCareAry[0];
					var JoinUserDr=ProCareAry[1];
					var DoctorDr=ProCareAry[2];
					var CurGroupDr=ProCareAry[3];
					var Level=ProCareAry[4];
					var State=ProCareAry[5];
					var StartDate=ProCareAry[6];
					var EndDate=ProCareAry[7];
					var Note1=ProCareAry[8];
					var Note2=ProCareAry[9];
					var ContactFlag=ProCareAry[10];
					var ContactTel=ProCareAry[11];
					
					if (ContactFlag=="Y") {ContactFlag=true;}else{ContactFlag=false;}
					DHCC_SetElementData("ContactFlag",ContactFlag);
					DHCC_SetElementData("ContactTel",ContactTel);
				}
			}
			DisabledElement("cContactFlag",true);
			DisabledElement("ContactFlag",true);
			DisabledElement("cContactTel",true);
			DisabledElement("ContactTel",true);
		}else{
			DisabledElement("cContactFlag",false);
			DisabledElement("ContactFlag",false);
			DisabledElement("cContactTel",false);
			DisabledElement("ContactTel",false);
		}
	}
}
function GetSelectedPro(){
	var Findnum=0;
	var ProjectListObj=document.getElementById("ProjectList");
	for(var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected==true){
			Findnum=Findnum+1;
		}
	}
	if (Findnum>1){
		return false
	}else{
		return true;
	}
}
function GetSelectedIndex(){
	var CurIndex=-1;
	var ProjectListObj=document.getElementById("ProjectList");
	for(var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected==true){
			CurIndex=i;
		}
	}
	return CurIndex;
}
function SelAddClick(){
	var UserName=DHCC_GetElementData("UserName");
	var UserRowId=DHCC_GetElementData("UserRowId");
	if (UserRowId==""){
			alert("请选择参与者.");
			return;
		}
	var UserListObj=document.getElementById("JionUserList");
	for (var i=0;i<UserListObj.length;i++){
		var UserListValue=UserListObj.options[i].value;
		if (UserListValue==UserRowId){
			alert("参与者已经存在.");
			return;
		}
	}
	UserListObj.options[UserListObj.length]=new Option(UserName,UserRowId);
	
	//Save
	//SaveClick();
}
function SetJoinUserList(PPRowId){
	//已经控制每次只能选择一个项目
	DHCC_ClearList("JionUserList");
	var UserListObj=document.getElementById("JionUserList");
	UserListObj.length=0
	var encmeth=DHCC_GetElementData("GetJoinUserStrByProID");
	if (encmeth!=""){
		var rtnStr=cspRunServerMethod(encmeth,PPRowId);
		var rtnArray=rtnStr.split("^");
		for (var i=0;i<rtnArray.length;i++){
			var rtnArrayTemp=rtnArray[i].split(String.fromCharCode(1))
			if (rtnArrayTemp[0]==""){continue;}
			UserListObj.options[i]=new Option(rtnArrayTemp[1],rtnArrayTemp[0])
		}
	}
}
function SetWarnSum(PPRowId){
	HiddenWarnSum("")
	var UserDr=session['LOGON.USERID'];
	var WarnSum=tkMakeServerCall("web.PilotProject.DHCDocPilotProject", "GetWarnSum", PPRowId,UserDr);
	var obj=document.getElementById("WarnSum");
	if(obj){
		obj.value=WarnSum
	}
		
}
function SelDelClick(){
	var CurGroupDr=session['LOGON.GROUPID'];
	var ExpStr="";
	var CurIndex=GetSelectedIndex();
	if (CurIndex<0){
		alert("没有选择科研项目.");
		return;
	}
	var ProjectListObj=document.getElementById("ProjectList");
	var PPRowId=ProjectListObj.options[CurIndex].value;
	var UserListObj=document.getElementById("JionUserList")
	for (var i=0;i<UserListObj.length;i++){
		if (UserListObj.options[i].selected!=true) continue;
		var UserRowId=UserListObj.options[i].value;
		var encmeth=DHCC_GetElementData("DeleteProjectCare");
		if (encmeth!=""){
			var myrtn=cspRunServerMethod(encmeth,PPRowId,UserRowId);
			if (myrtn=="0"){
				alert("删除成功!");
			}else{
				alert("删除失败! 错误代码:"+myrtn);
			}
		}
	}
	DHCC_ClearList("JionUserList");
	SetJoinUserList(PPRowId);
	SetWarnSum(PPRowId)
}

//只保存选中的项目的项目参与者
function SaveClick(){
	var SelProjectRowId="";
	var ListStr="";
	var UserListStr="";
	var SeledUserListStr="";
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if ((ProjectListObj.options[i].value=="")||(ProjectListObj.options[i].selected!=true)) continue;
		SelProjectRowId=ProjectListObj.options[i].value;
		break;
		/*
		var UserListStr="";
		var UserListObj=document.getElementById("JionUserList");
		for (var j=0;j<UserListObj.length;j++){
			if (UserListObj.options[j].value=="") continue;
			if (UserListStr=="")UserListStr=UserListObj.options[j].value+String.fromCharCode(2)+UserListObj.options[j].text;
			else UserListStr=UserListStr+String.fromCharCode(1)+UserListObj.options[j].value+String.fromCharCode(2)+UserListObj.options[j].text;
		}
		if (ListStr=="")ListStr=ProjectListObj.options[i].value+"!"+UserListStr;
		else ListStr=ListStr+"^"+ProjectListObj.options[i].value+"!"+UserListStr;
		*/
	}
	if (SelProjectRowId==""){
		alert("请选择项目.");
		return;
	}
	
	var UserListObj=document.getElementById("JionUserList");
	for (var j=0;j<UserListObj.length;j++){
		if (UserListObj.options[j].value=="") continue;
		if (UserListStr=="")UserListStr=UserListObj.options[j].value+String.fromCharCode(2)+UserListObj.options[j].text;
		else UserListStr=UserListStr+String.fromCharCode(1)+UserListObj.options[j].value+String.fromCharCode(2)+UserListObj.options[j].text;
		if (UserListObj.options[j].selected==true){
			if (SeledUserListStr=="") SeledUserListStr=UserListObj.options[j].value;
			else SeledUserListStr=SeledUserListStr+String.fromCharCode(1)+UserListObj.options[j].value;
		}
	}
    ListStr=SelProjectRowId+"!"+UserListStr;
	var CurGroupDr=session['LOGON.GROUPID'];
	var ContactFlag=DHCC_GetElementData("ContactFlag");
	if (ContactFlag==true) {ContactFlag="Y";}else{ContactFlag="N";}
	var ContactTel=DHCC_GetElementData("ContactTel");
	var ExpStr=SeledUserListStr+"^"+ContactFlag+"^"+ContactTel;
	
	//联系人,联系电话不能为空
	if ((ContactFlag=="Y")&&(ContactTel=="")) {
			alert("联系人的联系电话不能为空.")
			return;
	}
	//判断必须有一个联系人
	var CheckIsExistContact=DHCC_GetElementData("CheckIsExistContact");
	if (CheckIsExistContact!="") {
		var ExistContactStr=cspRunServerMethod(CheckIsExistContact,SelProjectRowId,SeledUserListStr,ContactFlag);
		var ExistContactFlag=ExistContactStr.split('$')[0];
		//此项目保存数据之前是否存在联系人 0 不存在 1 存在
		if (ExistContactFlag=="0") {
			if (ContactFlag!="Y") {
				alert("请至少指定一名联系人.")
				return;
			}
			if((ContactFlag=="Y")&&(SeledUserListStr=="")){
				alert("请至少指定一名联系人.")
				return;
			}
		}
		/*var ExistContactFlag=ExistContactStr.split('^')[0];
		if (ExistContactFlag=="0") {
			if (ContactFlag!="Y") {
				alert("请至少指定一名联系人.")
				return;
			}
			if((ContactFlag=="Y")&&(SeledUserListStr=="")){
				alert("请至少指定一名联系人.")
				return;
			}
		}else{
			var ExistContactUserID=ExistContactStr.split('^')[1];
			var tempSeledUserListStr=String.fromCharCode(1)+SeledUserListStr+String.fromCharCode(1);
			var tempExistContactUserID=String.fromCharCode(1)+ExistContactUserID+String.fromCharCode(1);
			if ((tempSeledUserListStr.indexOf(tempExistContactUserID)!=-1)&&(ContactFlag!="Y")) {
				alert("请至少指定一名联系人.")
				return;
			}
		}*/
	}
	
	
	var encmeth=DHCC_GetElementData("SaveMethod");
	var UserID=session['LOGON.USERID']
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,CurGroupDr,ListStr,ExpStr,UserID);
		if (myrtn=="0"){
			alert("保存成功!");
			if (window.name=="JoinUser"){
				AddJoinUserToOpener(ListStr);
			}
		}else{
			alert("保存失败! 错误代码:"+myrtn);
		}
	}
}
function AddJoinUserToOpener(ListStr){
	var rtnStr="";
	var ListStrTemp=ListStr.split("^")
	for (var i=0;i<ListStrTemp.length;i++){
		var UserListStr=ListStrTemp[i].split("!")[1];
		var UserListStrTemp=UserListStr.split(String.fromCharCode(1));
		for (var j=0;j<UserListStrTemp.length;j++){
			var UserListStrTemp1=UserListStrTemp[j].split(String.fromCharCode(2));
			var UserRowId=UserListStrTemp1[0];
			var UserName=UserListStrTemp1[1];
			if (rtnStr=="") rtnStr=UserName;
			else rtnStr=rtnStr+","+UserName
		}
	}
	if (window.opener.document.getElementById("JoinedUser")){
		window.opener.document.getElementById("JoinedUser").value=rtnStr;
		//window.close();
	}
}
function LookUpUserSelect(value){
	var myArr=value.split("^");
	DHCC_SetElementData("UserRowId",myArr[2]);
	DHCC_SetElementData("UserName",myArr[1]);
}

function DisabledElement(ElementName,Val){
	if (!Val) {Val="none";}else{Val="";}
	var Obj=document.getElementById(ElementName);
	if (Obj) {
		Obj.style.display=Val;
	}
}
function  HiddenWarnSum(flag){
	var Obj=document.getElementById("WarnSum");
	if (Obj) Obj.style.visibility=flag;
	var Obj=document.getElementById("cWarnSum");
	if (Obj) Obj.style.visibility=flag;
	var Obj=document.getElementById("UpdateWarnSum");
	if (Obj) Obj.style.visibility=flag;
}
function UpdateWarnSumClick(){
	var SelProjectRowId="";
	var SeledUserListStr="";
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if ((ProjectListObj.options[i].value=="")||(ProjectListObj.options[i].selected!=true)) continue;
		SelProjectRowId=ProjectListObj.options[i].value;
		break;
		/*
		var UserListStr="";
		var UserListObj=document.getElementById("JionUserList");
		for (var j=0;j<UserListObj.length;j++){
			if (UserListObj.options[j].value=="") continue;
			if (UserListStr=="")UserListStr=UserListObj.options[j].value+String.fromCharCode(2)+UserListObj.options[j].text;
			else UserListStr=UserListStr+String.fromCharCode(1)+UserListObj.options[j].value+String.fromCharCode(2)+UserListObj.options[j].text;
		}
		if (ListStr=="")ListStr=ProjectListObj.options[i].value+"!"+UserListStr;
		else ListStr=ListStr+"^"+ProjectListObj.options[i].value+"!"+UserListStr;
		*/
	}
	if (SelProjectRowId==""){
		alert("请选择项目.");
		return;
	}
	var WarnSum=DHCC_GetElementData("WarnSum")
	var UserDr=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.PilotProject.DHCDocPilotProject", "AddPPWarnSum", SelProjectRowId,WarnSum,UserDr);
	if (ret==0){
		alert("保存成功！")
	}else{
		alert("保存失败！")
	}
}