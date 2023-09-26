var CurrentSel=0;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
}
function BUpdate_click()
{
	var obj,encmeth="",Type="",ParRef="",ID="",StartTime="",EndTime="",Num="";
	obj=document.getElementById("Type");
	if (obj) Type=obj.value;
	obj=document.getElementById("ParRef");
	if (obj) ParRef=obj.value;
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	obj=document.getElementById("StartTime");
	if (obj) StartTime=obj.value;
	if (StartTime==""){
		$.messager.alert("提示","开始时间不能为空","info");
		return false;
	}
	obj=document.getElementById("EndTime");
	if (obj) EndTime=obj.value;
	if (EndTime==""){
		$.messager.alert("提示","结束时间不能为空","info");
		return false;
	}
	obj=document.getElementById("Num");
	if (obj) Num=obj.value;
	if (Num=="" || Num=="-"){
		MaleNum = 0;
		FemaleNum = 0;
	} else {
		MaleNum = Num.split("-")[0];
		FemaleNum = Num.split("-")[1];	
	}
	
	var currentMale = 0;  ///可以预约人数
	var currentFemale = 0;
	obj=document.getElementById("SearchPeopleCount");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ParRef,Type);
	currentMale = (ret.split("-"))[0];
	currentFemale = (ret.split("-"))[1];
	if(currentMale == null || currentMale == "" || currentMale == undefined){
		currentMale = 0;	
	}
	if(currentFemale == null || currentFemale == "" || currentFemale == undefined){
		currentFemale = 0;	
	}
	currentMale = parseInt(currentMale);
	currentFemale = parseInt(currentFemale);
	

	var totalMaleNum = 0; ///分时段总人数
	var totalFemaleNum = 0;
	var rows;
	obj=document.getElementById("tDHCPEPreTemplateTime");
	if (obj) { rows=obj.rows.length; }
	for (var i=1;i<rows;i++){
		tobj=document.getElementById("TIDz"+i);

		tobjMale=document.getElementById("TNumMalez"+i);
		tobjFemale=document.getElementById("TNumFemalez"+i);
		tobjMale = tobjMale.innerText;
		tobjFemale = tobjFemale.innerText;

		tobjMale = parseInt(tobjMale);
		tobjFemale = parseInt(tobjFemale);
		
		
		if(tobj.value != ID){
			totalMaleNum = totalMaleNum + tobjMale;
			totalFemaleNum = totalFemaleNum + tobjFemale;
		}
	}
	

	
	MaleNum = parseInt(MaleNum);
	FemaleNum = parseInt(FemaleNum);
	
	totalMaleNum = totalMaleNum + MaleNum;
	totalFemaleNum = totalFemaleNum + FemaleNum;
	
	
	if(totalMaleNum > currentMale){
		var balance = totalMaleNum - currentMale;
		$.messager.alert("提示","男性分时段总人数大于预约限额，更新失败！差额为："+balance+" 人","info");
		return false;	
		
	
	}
	
	if(totalFemaleNum > currentFemale){
		var balance = totalFemaleNum - currentFemale;
		$.messager.alert("提示","男性分时段总人数大于预约限额，更新失败！差额为："+balance+" 人","info");
		return false;	
		
	
	}
	/*
	if(totalMaleNum < currentMale){
		var balance = currentMale - totalMaleNum;
		if(!confirm("男性分时段总人数小于预约限额，是否继续？差额为："+balance+" 人")){
			return false;	
		}
	
	}
	
	if(totalFemaleNum < currentFemale){
		var balance = currentFemale - totalFemaleNum;
		if(!confirm("女性分时段总人数小于预约限额，是否继续？差额为："+balance+" 人？")){
			return false;	
		}
	
	}*/
	
	var Info=StartTime+"^"+EndTime+"^"+MaleNum+"^"+FemaleNum;
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,Type,ParRef,ID,Info);
	if (ret=="1"){
		window.location.reload();
	}else{
		$.messager.alert("提示",ret,"info");
		//alert(ret)
	}
}
function BDelete_click()
{
	var obj,encmeth="",Type="",ID="";
	obj=document.getElementById("Type");
	if (obj) Type=obj.value;
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	if(ID==""){
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;	
	}
	obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,Type,ID);
	if (ret=="0"){
		window.location.reload();
	}else{
		//alert(ret)
		$.messager.alert("提示","删除失败:"+ret,"info");
	}
}
function BCreate_click()
{
	var obj,LocID="",UserID="",StartDate="",EndDate="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	if ((StartDate=="")||(EndDate=="")){

		$.messager.alert("提示","日期不能为空","info");
		return false;
	}
	obj=document.getElementById("CreateClass");
	if (obj) encmeth=obj.value;
	//alert(LocID+","+UserID+","+StartDate+","+EndDate)
	var ret=cspRunServerMethod(encmeth,LocID,UserID,StartDate,EndDate);
	$.messager.alert("提示",ret,"info");
	//alert(ret)
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById("tDHCPEPreTemplateTime");	
	//if (objtbl) { var rows=objtbl.rows.length; }
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);
}
function ShowCurRecord(SelectRow)
{
	var obj,tobj;
	if (SelectRow==0){
		obj=document.getElementById("ID");
		if (obj) obj.value="";
		obj=document.getElementById("StartTime");
		if (obj) obj.value="";
		obj=document.getElementById("EndTime");
		if (obj) obj.value="";
		obj=document.getElementById("Num");
		if (obj) obj.value="";
	}else{
		obj=document.getElementById("ID");
		if (obj){
			tobj=document.getElementById("TIDz"+SelectRow);
			if (tobj) obj.value=tobj.value;
		}
		obj=document.getElementById("StartTime");
		if (obj){
			tobj=document.getElementById("TStartTimez"+SelectRow);
			if (tobj) obj.value=tobj.innerText;
		}
		obj=document.getElementById("EndTime");
		if (obj){
			tobj=document.getElementById("TEndTimez"+SelectRow);
			if (tobj) obj.value=tobj.innerText;
		}
		obj=document.getElementById("Num");
		if (obj){
			tobjMale=document.getElementById("TNumMalez"+SelectRow);
			tobjFemale=document.getElementById("TNumFemalez"+SelectRow);
			if (tobj) obj.value=tobjMale.innerText+"-"+tobjFemale.innerText;
		}
	}
	
}
document.body.onload = BodyLoadHandler;