//DHCNurOPExecTitleButton.js
var GetUserGroupAccess=document.getElementById("GetUserGroupAccess");
if (GetUserGroupAccess)
{
	var QueryTypeBtnStr=cspRunServerMethod(GetUserGroupAccess.value,session['LOGON.GROUPID'],session['LOGON.USERID'],"oldSheet","",session['LOGON.CTLOCID']);
	var objdiv=document.getElementById("dDHCNurOPExecTitle");
	var objdivtable=objdiv.getElementsByTagName("table");
	if ((objdivtable)&&(objdivtable.length>0)) {
		var objdivtabletr=objdivtable[0].getElementsByTagName("tr");
		if ((objdivtabletr)&&(objdivtabletr.length>0)) {
			var objdivtabletrtd=objdivtabletr[1].getElementsByTagName("td");
			if ((objdivtabletrtd)&&(objdivtabletrtd.length>0)) {
				var tmpQueryTypeBtn=QueryTypeBtnStr.split("!");
				var QueryTypeBtn=tmpQueryTypeBtn[0].split("^"); 
				var DefalutBtn=tmpQueryTypeBtn[1];
				for (var i=0;i<QueryTypeBtn.length;i++) {
					var QueryTypeBtnOne=QueryTypeBtn[i];
					var bt=document.createElement("a");
			        //bt.type="button";
			        //bt.style.height="30px"
			        bt.className="i-btn"
			        //bt.style.width="80px"
					//bt.style.fontSize=16;
					//bt.style.fontWeight = "bold"; 
			        //bt.style.color="blue";
			        //bt.style.backgroundColor = "#7D7DFF";
			       
			        var btid=QueryTypeBtnOne.split("|")[0];
			        if (btid==DefalutBtn) bt.style.color="blue";
			        bt.id=QueryTypeBtnOne.split("|")[0];
			        bt.innerHTML=QueryTypeBtnOne.split("|")[1].replace(" ","");
			        bt.onclick=show;
			        objdivtabletrtd[0].appendChild(bt);
				}
			}		
		}		
	}
}
var varTypeColorStr="";
function show(){
    var eSrc=window.event.srcElement;
    if (!eSrc) return;  
    var strId=eSrc.id;
    var strValue=eSrc.innerText;
	showcomm(strId,strValue);
	ShowTypeColor(varTypeColorStr);
	changeDisplay();
	
	Search(false);
}
function showcomm(strId,strValue){
	doclick(strId);
    var objHospitalRowId=document.getElementById("HospitalRowId");
	var obj=document.getElementById('queryTypeCode');
	if (obj) obj.value=strId.split("@")[1];
	if (objHospitalRowId) objHospitalRowId.value=strId.split("@")[0];
	var objReportList=document.getElementById('ReportList');
	if (objReportList) objReportList.value=strValue;
}
function doclick(strId) {
	var objdiv=document.getElementById("dDHCNurOPExecTitle");
	var objdivtable=objdiv.getElementsByTagName("table");
	if ((objdivtable)&&(objdivtable.length>0)) {
		var objdivtabletr=objdivtable[0].getElementsByTagName("tr");
		if ((objdivtabletr)&&(objdivtabletr.length>0)) {
			var objdivtabletrtd=objdivtabletr[1].getElementsByTagName("td");
			if ((objdivtabletrtd)&&(objdivtabletrtd.length>0)) {
				var objdivtabletrtdinput=objdivtabletrtd[0].getElementsByTagName("a");
				for (var i=0;i<objdivtabletrtdinput.length;i++) {
					if (strId==objdivtabletrtdinput[i].id) {
						//objdivtabletrtdinput[i].style.backgroundColor="#7D7DFF";
						objdivtabletrtdinput[i].className="tabactive i-btn"
						objdivtabletrtdinput[i].style.color="blue";
					}else{
						//objdivtabletrtdinput[i].style.backgroundColor="";
						objdivtabletrtdinput[i].className="i-btn"
						objdivtabletrtdinput[i].style.color="";
					}
				}
			}
		}
	}
}
function ShowTypeColor(str) {
	var firstType="";
	var objdiv=document.getElementById("dDHCNurOPExecTitle");
	var objdivtable=objdiv.getElementsByTagName("table");
	if ((objdivtable)&&(objdivtable.length>0)) {
		var objdivtabletr=objdivtable[0].getElementsByTagName("tr");
		if ((objdivtabletr)&&(objdivtabletr.length>0)) {
			var objdivtabletrtd=objdivtabletr[1].getElementsByTagName("td");
			if ((objdivtabletrtd)&&(objdivtabletrtd.length>0)) {
				var objdivtabletrtdinput=objdivtabletrtd[0].getElementsByTagName("a");
				for (var i=0;i<objdivtabletrtdinput.length;i++) {
					if (str.indexOf(objdivtabletrtdinput[i].id)>-1) {

						objdivtabletrtdinput[i].style.color='blue';

						objdivtabletrtdinput[i].style.color="blue";

						//objdivtabletrtdinput[i].style.cssText="background:palegreen;width:80px;border-radius:5px 5px 0px 0px;margin:0 3 0 3";
						//objdivtabletrtdinput[i].setAttribute("style","background: palegreen;color: red;");
        				//objdivtabletrtdinput[i].style.cssText="background:palegreen;color:red;";
						//objdivtabletrtdinput[i].style.backgroundColor="palegreen"; //"#7D7DFF";
						//objdivtabletrtdinput[i].style.cssText="PADDING: 3px;MARGIN: 3px;COLOR: yellow;BACKGROUND-COLOR: #336699;BORDER: 2px outset #336699;FONT-WEIGHT: bold;cursor: hand;";
						//objdivtabletrtdinput[i].style.cssText="BACKGROUND-COLOR: #336699;BORDER: 4px outset #336699;";
						//objdivtabletrtdinput[i].style.color="blue";
						if (firstType=="")  firstType=objdivtabletrtdinput[i].id+"^"+objdivtabletrtdinput[i].innerText;
					}else{
						//objdivtabletrtdinput[i].style.backgroundColor="";
						//objdivtabletrtdinput[i].style.cssText="background:#ecf3ff;width:80px;border-radius:5px 5px 0px 0px;margin:0 3 0 3";
						objdivtabletrtdinput[i].style.color="";
					}
				}
			}
		}
	}
	return firstType;
}
///刷卡或登记号回车时调用flag为1,有医嘱的单据变为绿色且自动进入第一个有医嘱单据中
///其它flag为0,有医嘱的单据变为绿色
///DHCNurOPExecTitle.js中
///1.登记号回车RegNoBlur函数中新加if (queryFlag==false) GetPatOrderButton(1);
///2.读卡ReLoadOPFoot函数中新加GetPatOrderButton(1);
///3.刷卡CardNo_KeyDown函数中GetPatOrderButton(1);
///4.急诊选择病人进执行医嘱BodyLoadHandler函数中
///if (EpisodeID!="") {GetPatOrderButton(1);Search(true);}
function GetPatOrderButton(flag){
    var wardId=document.getElementById("wardId").value;
    var regNo=document.getElementById("regNo").value;
    if (regNo!="") BasPatinfo(regNo);
	if (EpisodeID!="") regNo=regNo; //+"^"+EpisodeID;
    var locId=document.getElementById("locId").value;
    var queryTypeCode=document.getElementById("queryTypeCode").value;
    var HospitalRowId=document.getElementById("HospitalRowId").value;
    var stdate=document.getElementById("startDate").value;
    var edate=document.getElementById("endDate").value;
    var wardDesc=document.getElementById("PacWard").value;
   // var Dept=document.getElementById("Dept").value;
    var ExeCheck=document.getElementById("exeFlag").checked;
    var exeFlag;
    var gap="";
    if (ExeCheck==false) {exeFlag=0;}
    else{ exeFlag=1;}
    //if (Dept=="")   {locId="";}
	if (queryTypeCode=="") return;
    var userId=session['LOGON.USERID'];
    var ssgrp=session['LOGON.GROUPID'];
	var GetPatOrdBtn=document.getElementById("GetPatOrdBtn");
	if (GetPatOrdBtn) {		
		//alert(ssgrp+","+wardId+","+regNo+","+userId+","+stdate+","+edate+","+queryTypeCode+","+gap+","+locId+","+admType+","+exeFlag+","+HospitalRowId)	
		var retStr=cspRunServerMethod(GetPatOrdBtn.value,ssgrp,wardId,regNo,userId,stdate,edate,queryTypeCode,gap,locId,admType,exeFlag,HospitalRowId);
		varTypeColorStr=retStr;
		var firstType=ShowTypeColor(retStr);
		if (flag==1) {
			var tmpFirstType=firstType.split("^");
			if (tmpFirstType.length>1) {
				//有医嘱时自动跳到第一个单据
				var TypeCode=tmpFirstType[0];
				var TypeDesc=tmpFirstType[1];
				showcomm(TypeCode,TypeDesc)
				ShowTypeColor(retStr);
			}
			else {
				//无医嘱时自动跳到默认单据
				GotoDefaultButton();
			}
		}
	}
}
function GotoDefaultButton(){
	var QueryTypeBtnStr=cspRunServerMethod(GetUserGroupAccess.value,session['LOGON.GROUPID'],session['LOGON.USERID'],"oldSheet","",session['LOGON.CTLOCID']);
	if (QueryTypeBtnStr!="") {
		var tmpQueryTypeBtn=QueryTypeBtnStr.split("!");
		var DefalutBtn=tmpQueryTypeBtn[1];
		if (DefalutBtn!="") {
			var QueryTypeBtn=tmpQueryTypeBtn[0].split("^");
			for (var i=0;i<QueryTypeBtn.length;i++){
				if (QueryTypeBtn[i]=="") continue;
				var QueryTypeBtnCode=QueryTypeBtn[i].split("|")[0];
				var QueryTypeBtnDesc=QueryTypeBtn[i].split("|")[1];
				if (DefalutBtn==QueryTypeBtnCode){
					showcomm(QueryTypeBtnCode,QueryTypeBtnDesc);	
				}
			}
		}
	}	
}

//执行后调用,保留原来单据,不重新查询
function GetPatOrderButtonNew(TypeCode,TypeDesc){
    var wardId=document.getElementById("wardId").value;
    var regNo=document.getElementById("regNo").value;
    if (regNo!="") BasPatinfo(regNo);
	if (EpisodeID!="") regNo=regNo; //+"^"+EpisodeID;
    var locId=document.getElementById("locId").value;
    var queryTypeCode=document.getElementById("queryTypeCode").value;
    var HospitalRowId=document.getElementById("HospitalRowId").value;
    var stdate=document.getElementById("startDate").value;
    var edate=document.getElementById("endDate").value;
    var wardDesc=document.getElementById("PacWard").value;
   // var Dept=document.getElementById("Dept").value;
    var ExeCheck=document.getElementById("exeFlag").checked;
    var exeFlag;
    var gap="";
    if (ExeCheck==false) {exeFlag=0;}
    else{ exeFlag=1;}
    //if (Dept=="")   {locId="";}
	if (queryTypeCode=="") return;
    var userId=session['LOGON.USERID'];
    var ssgrp=session['LOGON.GROUPID'];
	var GetPatOrdBtn=document.getElementById("GetPatOrdBtn");
	if (GetPatOrdBtn) {		
		//alert(ssgrp+","+wardId+","+regNo+","+userId+","+stdate+","+edate+","+queryTypeCode+","+gap+","+locId+","+admType+","+exeFlag+","+HospitalRowId)	
		var retStr=cspRunServerMethod(GetPatOrdBtn.value,ssgrp,wardId,regNo,userId,stdate,edate,queryTypeCode,gap,locId,admType,exeFlag,HospitalRowId);
		varTypeColorStr=retStr;
		var firstType=ShowTypeColor(retStr);
		showcomm(TypeCode,TypeDesc);
		ShowTypeColor(retStr);
	}
}