document.body.onload = BodyLoadHandler;

var myCombAry=new Array();
function BodyLoadHandler(){
	var obj=document.getElementById("Save1");
	if (obj) obj.onclick=Save1Click;
	var obj=document.getElementById("AutoProCode");
	if (obj) obj.onclick=AutoProCodeClick;
	
	//LoadInitListInfo()和LoadInitInfo()的顺序不能反,必须先调建立信息函数再初始化信息
	LoadInitListInfo();
	LoadInitInfo();
	
}
function LoadInitListInfo(){
	//超级科室
	LoadDepartment();
	//药理子类
	LoadSubCat();
	//挂号次数
	LoadPilotProReg();
	//药理项目费别
	var obj=document.getElementById("PilotPatAdmReason");
	if (obj){obj.size=1; obj.multiple=false;}
	DHCWebD_ClearAllListA("PilotPatAdmReason");
	var rtn = tkMakeServerCall("web.PilotProject.DHCDocPPGroupSeting","ReadAdmReasonListBroker", "DHCWeb_AddToListA", "PilotPatAdmReason");
	//住院药理项目费别
	var obj=document.getElementById("IPPilotPatAdmReason");
	if (obj){obj.size=1; obj.multiple=false;}
	DHCWebD_ClearAllListA("IPPilotPatAdmReason");
	var rtn = tkMakeServerCall("web.PilotProject.DHCDocPPGroupSeting","ReadAdmReasonListBroker", "DHCWeb_AddToListA", "IPPilotPatAdmReason");
	
}
function LoadInitInfo(){
	var encmeth=DHCC_GetElementData('GetInitInfo');
	if (encmeth!=""){
		var rtnStr=cspRunServerMethod(encmeth);
		var PilotExpression=rtnStr.split("^")[0];
		var SuperDepRowId=rtnStr.split("^")[1];
		var ProRegList=rtnStr.split("^")[2];
		var SubConfigStr=rtnStr.split("^")[3];
		var ProCodeLenght=rtnStr.split("^")[4];
		var EntryOrdBillPad=rtnStr.split("^")[5];
		var PilotPatAdmReason=rtnStr.split("^")[6];
		var PatAddNeedProRem=rtnStr.split("^")[7];
		var IPPilotPatAdmReason=rtnStr.split("^")[8];
		var AutoProCode=rtnStr.split("^")[9];
		var ProCodeStart=rtnStr.split("^")[10];
		var ArchivesFilesNoStart=rtnStr.split("^")[11];
		
		//处理
		DHCC_SetElementData('PilotExpression',PilotExpression);
		combo_Dep.setComboValue(SuperDepRowId);DHCC_SetElementData('SuperDepRowId',SuperDepRowId);
		DHCC_SelectOptionByValue("ProRegList",ProRegList);
		var SubObj=document.getElementById('PilotProSubCatList')
		if (SubObj){
			for(var i=0;i<SubObj.length;i++){
				if(("!"+SubConfigStr+"!").indexOf("!"+SubObj.options[i].value+"!")!=-1){
					SubObj.options[i].selected=true;
				}
			}
		}
		
		DHCC_SetElementData('ProCodeLenght',ProCodeLenght);
		if (EntryOrdBillPad==1){EntryOrdBillPad=true;}else{EntryOrdBillPad=false;}
		DHCC_SetElementData('EntryOrdBillPad',EntryOrdBillPad);
		DHCC_SelectOptionByValue("PilotPatAdmReason",PilotPatAdmReason);
		if (PatAddNeedProRem==1){PatAddNeedProRem=true;}else{PatAddNeedProRem=false;}
		DHCC_SetElementData("PatAddNeedProRem",PatAddNeedProRem);
		DHCC_SelectOptionByValue("IPPilotPatAdmReason",IPPilotPatAdmReason);
		if (AutoProCode==1){AutoProCode=true;}else{AutoProCode=false;}
		DHCC_SetElementData("AutoProCode",AutoProCode);
		AutoProCodeClick();
		DHCC_SetElementData("ProCodeStart",ProCodeStart);
		DHCC_SetElementData("ArchivesFilesNoStart",ArchivesFilesNoStart);
	}
}
function CheckBeforeSave() {
	var ProCodeStart=DHCC_GetElementData('ProCodeStart');
	if (ProCodeStart!="" && !DHCC_isNumber(ProCodeStart)) {
		alert("项目编号起始号请填写数字");
		websys_setfocus("ProCodeStart");
		return false;
	}
	var ArchivesFilesNoStart=DHCC_GetElementData('ArchivesFilesNoStart');
	if (ArchivesFilesNoStart!="" && !DHCC_isNumber(ArchivesFilesNoStart)) {
		alert("档案文件夹编号起始号请填写数字");
		websys_setfocus("ArchivesFilesNoStart");
		return false;
	}
	var AutoProCode=DHCC_GetElementData('AutoProCode');
	if (AutoProCode && ProCodeStart=="") {
		alert("如果是自动生成项目编号,项目编号起始号不能为空");
		websys_setfocus("ProCodeStart");
		return false;
	}
	return true;
}
function Save1Click(){
	if (CheckBeforeSave()==false) return;
	
	var PilotExpression=DHCC_GetElementData('PilotExpression');
	var SuperDepRowId=DHCC_GetElementData('SuperDepRowId');
	var ProRegList=DHCC_GetElementData('ProRegList');
	var SubConfigStr="";
	var SubObj=document.getElementById('PilotProSubCatList')
	if (SubObj){
		for(var i=0;i<SubObj.length;i++){
			if(SubObj.options[i].selected==true){
				if(SubConfigStr=="") SubConfigStr=SubObj.options[i].value;
				else SubConfigStr=SubConfigStr+"!"+SubObj.options[i].value;
			}
		}
	}
	var ProCodeLenght=DHCC_GetElementData("ProCodeLenght");
	var EntryOrdBillPad=DHCC_GetElementData('EntryOrdBillPad');
	if (EntryOrdBillPad==true){EntryOrdBillPad=1;}else{EntryOrdBillPad=0;}
	var PilotPatAdmReason=DHCC_GetListSelectedValue("PilotPatAdmReason");
	var PatAddNeedProRem=DHCC_GetElementData('PatAddNeedProRem');
	if (PatAddNeedProRem==true){PatAddNeedProRem=1;}else{PatAddNeedProRem=0;}
	var IPPilotPatAdmReason=DHCC_GetListSelectedValue("IPPilotPatAdmReason");
	var AutoProCode=DHCC_GetElementData('AutoProCode');
	if (AutoProCode==true){AutoProCode=1;}else{AutoProCode=0;}
	var ProCodeStart=DHCC_GetElementData('ProCodeStart');
	var ArchivesFilesNoStart=DHCC_GetElementData('ArchivesFilesNoStart');
	
	var myStr=PilotExpression+"^"+SuperDepRowId+"^"+ProRegList+"^"+SubConfigStr+"^"+ProCodeLenght+"^"+EntryOrdBillPad+"^"+PilotPatAdmReason;
	var myStr=myStr+"^"+PatAddNeedProRem+"^"+IPPilotPatAdmReason+"^"+AutoProCode+"^"+ProCodeStart+"^"+ArchivesFilesNoStart;
	var encmeth=DHCC_GetElementData('Save1Method');
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,myStr);
		if (rtn=="0"){
			alert("保存成功");
			window.location.reload();
		}else{
			alert("保存失败");
		}
	}
}
function LoadDepartment(){
	var SuperLocName=DHCC_GetElementData('SuperLoc');
	if (document.getElementById('SuperLoc')){
		var DepStr=DHCC_GetElementData('DepStr');
		combo_Dep=dhtmlXComboFromStr("SuperLoc",DepStr);
		myCombAry["SuperLoc"]=combo_Dep;
		combo_Dep.enableFilteringMode(true);
		combo_Dep.selectHandle=combo_LocationKeydownhandler;
		combo_Dep.setComboText(SuperLocName)
	}
}
function combo_LocationKeydownhandler(){
	var DepRowId=combo_Dep.getSelectedValue();
	DHCC_SetElementData('SuperDepRowId',DepRowId);
}

function LoadPilotProReg(){
	var ProRegArray=new Array("一次","每次","");

	var obj=document.getElementById("ProRegList");
	if (obj){	
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(ProRegArray[0],"1");
	  obj.options[1]=new Option(ProRegArray[1],"2");
	  obj.options[2]=new Option(ProRegArray[2],"0");
		}
}
function LoadSubCat(){
	//得到所有子类
	var encmeth=DHCC_GetElementData('FindSubCatMethod');
	if (encmeth!=""){
		var SubCat=cspRunServerMethod(encmeth);
		 var obj=document.getElementById("PilotProSubCatList");
		 for (var i=0;i<SubCat.split(String.fromCharCode(2)).length;i++){
		 	var tempStr=SubCat.split(String.fromCharCode(2))[i];
		 	var SubRowId=tempStr.split(String.fromCharCode(1))[0];
		 	var SubDesc=tempStr.split(String.fromCharCode(1))[1];
		 	obj.options[i]=new Option(SubDesc,SubRowId);
		 }
	}
  //初始化设置过的子类
  InitSubConfig();
}
function InitSubConfig(){
	
}
function AutoProCodeClick() {
	var AutoProCode=DHCC_GetElementData("AutoProCode");
	if (AutoProCode) {
		var ProCodeStartObj=document.getElementById("ProCodeStart");
		if (ProCodeStartObj) ProCodeStartObj.disabled=false;
	}else{
		var ProCodeStartObj=document.getElementById("ProCodeStart");
		if (ProCodeStartObj) ProCodeStartObj.disabled=true;
		DHCC_SetElementData("ProCodeStart","");
	}
}