document.body.onload = BodyLoadHandler;
var SelectedRow=0
var LoopCount=1;
var myCombAry=new Array();
function BodyLoadHandler(){
	var obj=document.getElementById("New");
	if(obj){obj.onclick=New_click;}
	//var obj=document.getElementById("Update");
	//if(obj){obj.onclick=Update_click;}
	var obj=document.getElementById("Delete");
	if(obj){obj.onclick=Delete_click;}
	var obj=document.getElementById("Save");
	if(obj){obj.onclick=Save_click;}
	Init();
	LoadDepartment();
	
}
function Init(){
	var par_win = window.opener;
	var obj=par_win.document.getElementById("OtherDepStr");
	if(obj)var OtherDepStr=obj.value
	var obj=par_win.document.getElementById("OtherDepartment");
	if(obj)var OtherDepartment=obj.value
	if (OtherDepStr=="") return;
	if(OtherDepStr.indexOf("^")!="-1"){
	var arr=OtherDepStr.split("^")
	var arr1=OtherDepartment.split(";")
	var len=arr.length
	for (var i=0;i<len;i++){
		var objtbl=document.getElementById('tUDHCDocPilotProDept');
		if (LoopCount!=1) AddRowToList(objtbl);
        LoopCount=LoopCount+1;
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		var eSrc=objtbl.rows[LastRow];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName('label');
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split('z');
				var Row=arrId[arrId.length-1];
			}
		}
		var Tbl_TPPCreateDepartmentDr=document.getElementById('TPPCreateDepartmentDrz'+Row);
		var Tbl_TPPCreateDepartment=document.getElementById('TPPCreateDepartmentz'+Row);
		var Tbl_TPPStartUserDr=document.getElementById('TPPStartUserDrz'+Row);
		var Tbl_TPPStartUser=document.getElementById('TPPStartUserz'+Row);
		if (((arr1[i].split("-"))[0]=="")||((arr1[i].split("-"))[1]=="")) continue;
   	 	Tbl_TPPCreateDepartment.innerText=(arr1[i].split("-"))[0];
    	Tbl_TPPStartUser.innerText=(arr1[i].split("-"))[1]
        Tbl_TPPCreateDepartmentDr.value=(arr[i].split("-"))[0]
        Tbl_TPPStartUserDr.value=(arr[i].split("-"))[1]
		
	}
}else{
		var objtbl=document.getElementById('tUDHCDocPilotProDept');
		if (LoopCount!=1) AddRowToList(objtbl);
        LoopCount=LoopCount+1;
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		var eSrc=objtbl.rows[LastRow];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName('label');
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split('z');
				var Row=arrId[arrId.length-1];
			}
		}
		var Tbl_TPPCreateDepartmentDr=document.getElementById('TPPCreateDepartmentDrz'+Row);
		var Tbl_TPPCreateDepartment=document.getElementById('TPPCreateDepartmentz'+Row);
		var Tbl_TPPStartUserDr=document.getElementById('TPPStartUserDrz'+Row);
		var Tbl_TPPStartUser=document.getElementById('TPPStartUserz'+Row);
		Tbl_TPPCreateDepartment.innerText=(OtherDepartment.split("-"))[0];
		Tbl_TPPStartUser.innerText=(OtherDepartment.split("-"))[1];
		Tbl_TPPCreateDepartmentDr.value=(OtherDepStr.split("-"))[0];
		Tbl_TPPStartUserDr.value=(OtherDepStr.split("-"))[1];
	}
	
}
function LookUpPPStartUser(value){
	var obj=document.getElementById('PPStartUserDr');
	var tem=value.split("^");
	obj.value=tem[1];
	
}
function LoadDepartment(){
	var PPCreateDepartmentName=DHCC_GetElementData('PPCreateDepartment');
	if (document.getElementById('PPCreateDepartment')){
		var DepStr=DHCC_GetElementData('DepStr');
		combo_Dep=dhtmlXComboFromStr("PPCreateDepartment",DepStr);
		myCombAry["PPCreateDepartment"]=combo_Dep;
		combo_Dep.enableFilteringMode(true);
		combo_Dep.selectHandle=combo_LocationKeydownhandler;
		combo_Dep.setComboText(PPCreateDepartmentName)
	}
}
function LoadStartUser(){
	var PPStartUser=DHCC_GetElementData('PPStartUser');
	if (document.getElementById('PPStartUser')){
		var StartUsrStr=DHCC_GetElementData('StartUsrStr');
		combo_StartUser=dhtmlXComboFromStr("PPStartUser",StartUsrStr);
		myCombAry["PPStartUser"]=combo_StartUser;
		combo_StartUser.enableFilteringMode(true);
		combo_StartUser.selectHandle=combo_StartUserKeydownhandler;
		combo_StartUser.setComboText(PPStartUser)
	}
}
function combo_LocationKeydownhandler(){
	var DepRowId=combo_Dep.getSelectedValue();
	DHCC_SetElementData('PPCreateDepartmentDr',DepRowId);
	
}
function combo_StartUserKeydownhandler(){
	var StartUserRowId=combo_StartUser.getSelectedValue();
	DHCC_SetElementData('PPStartUserDr',StartUserRowId);
}
function New_click(){
	try {
		var PPCreateDepartment= DHCC_GetElementData('PPCreateDepartment')
		var PPStartUser=DHCC_GetElementData('PPStartUser')
		var PPCreateDepartmentDr= DHCC_GetElementData('PPCreateDepartmentDr')
		var PPStartUserDr=DHCC_GetElementData('PPStartUserDr')
		var PPRowId=DHCC_GetElementData('PPRowId')
	    if(PPStartUser=="") var PPStartUserDr="";
		if(PPCreateDepartmentDr==""){
			alert("科室不能为空")
			return false;
		}
		var objtbl=document.getElementById('tUDHCDocPilotProDept');
        if (LoopCount!=1) AddRowToList(objtbl);
        LoopCount=LoopCount+1;
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		var eSrc=objtbl.rows[LastRow];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName('label');
		//alert(rowitems.length);
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split('z');
				var Row=arrId[arrId.length-1];
			}
		}
		var Tbl_TPPCreateDepartmentDr=document.getElementById('TPPCreateDepartmentDrz'+Row);
		var Tbl_TPPCreateDepartment=document.getElementById('TPPCreateDepartmentz'+Row);
		var Tbl_TPPStartUserDr=document.getElementById('TPPStartUserDrz'+Row);
		var Tbl_TPPStartUser=document.getElementById('TPPStartUserz'+Row);
   	 	Tbl_TPPCreateDepartment.innerText=PPCreateDepartment;
    	Tbl_TPPStartUser.innerText=PPStartUser;
        Tbl_TPPCreateDepartmentDr.value=PPCreateDepartmentDr;
        Tbl_TPPStartUserDr.value=PPStartUserDr
	} catch(e) {};
	var par_win = window.opener;
	var OtherDepStr=""
	var OtherDepartment=""
	var objtbl=document.getElementById('tUDHCDocPilotProDept');
	if (!objtbl) objtbl=document.getElementById('tUDHCDocPilotProDept0');
	if (objtbl)
	{
		var rows = objtbl.rows;
		for(var i=1;i<rows.length;i++)
		{
			var TPPCreateDepartmentDr=DHCC_GetColumnData("TPPCreateDepartmentDr",i)
			var TPPStartUserDr=DHCC_GetColumnData("TPPStartUserDr",i)
			var TPPCreateDepartment=DHCC_GetColumnData("TPPCreateDepartment",i)
			var TPPStartUser=DHCC_GetColumnData("TPPStartUser",i)
			if(OtherDepStr=="") OtherDepStr=TPPCreateDepartmentDr+"-"+TPPStartUserDr
			else OtherDepStr=OtherDepStr+"^"+TPPCreateDepartmentDr+"-"+TPPStartUserDr
			if(OtherDepartment=="") OtherDepartment=TPPCreateDepartment+"-"+TPPStartUser
			else OtherDepartment=OtherDepartment+";"+TPPCreateDepartment+"-"+TPPStartUser
		}	
	}	
	var obj=par_win.document.getElementById("OtherDepStr");
	if(obj)obj.value=OtherDepStr
	var obj=par_win.document.getElementById("OtherDepartment");
	if(obj)obj.value=OtherDepartment
}
function GetStrLength(str){
	var len=str.length;
	var len1=0;
	for (var j=0;j<len;j++) {
		var char1=str.substring(j,j+1);
		if (CheckChinese(char1)) {len1=len1+2}else{len1=len1+1	}
	}
	return len1;
}
function CheckChinese(char1){
	if(escape(char1).indexOf('%u')!=-1) return true;
	return false;
}

function AddRowToList(objtbl) {
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName('*'); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split('z');
			//arrId[arrId.length-1]=arrId[arrId.length-1]+1;
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1
			rowitems[j].id=arrId.join('z');
			rowitems[j].name=arrId.join('z');
			rowitems[j].value='';
			//rowitems[j].innerText='';
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	if ((objnewrow.rowIndex)%2==0){objnewrow.className='RowEven';}else{objnewrow.className='RowOdd';}
}
function Update_click()
{
	var PPDRowId=""
	var obj=document.getElementById('PPDRowId');
	if(obj){
		PPDRowId=obj.value;
		if(PPDRowId==""){
			alert("请选择要修改的数据");
			return;
		}
	}
	var PPCreateDepartmentDr= DHCC_GetElementData('PPCreateDepartmentDr')
	var PPStartUserDr=DHCC_GetElementData('PPStartUserDr')
	if (PPCreateDepartmentDr==""){
		alert("科室不能为空！！")
		return false;
	}
	var UpdateProjectDept=document.getElementById('UpdateProjectDept');
	if (UpdateProjectDept) {var encmeth=UpdateProjectDept.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,PPDRowId,PPCreateDepartmentDr,PPStartUserDr)==0) {
		alert("修改成功")
		var par_win = window.opener;
		var OtherDepStr=""
		var OtherDepartment=""
		var objtbl=document.getElementById('tUDHCDocPilotProDept');
		if (!objtbl) objtbl=document.getElementById('tUDHCDocPilotProDept0');
		if (objtbl){
			var rows = objtbl.rows;
			for(var i=1;i<rows.length;i++){
				var TPPCreateDepartmentDr=DHCC_GetColumnData("TPPCreateDepartmentDr",i)
				var TPPStartUserDr=DHCC_GetColumnData("TPPStartUserDr",i)
				var TPPCreateDepartment=DHCC_GetColumnData("TPPCreateDepartment",i)
				var TPPStartUser=DHCC_GetColumnData("TPPStartUser",i)
				if(OtherDepStr=="") OtherDepStr=TPPCreateDepartmentDr+"-"+TPPStartUserDr
				else OtherDepStr=OtherDepStr+"^"+TPPCreateDepartmentDr+"-"+TPPStartUserDr
				if(OtherDepartment=="") OtherDepartment=TPPCreateDepartment+"-"+TPPStartUser
				else OtherDepartment=OtherDepartment+";"+TPPCreateDepartment+"-"+TPPStartUser
			}	
		}	
		var obj=par_win.document.getElementById("OtherDepStr");
		if(obj)obj.value=OtherDepStr
		var obj=par_win.document.getElementById("OtherDepartment");
		if(obj)obj.value=OtherDepartment
		location.reload();                ///从新加载页面
	}
	else{
		alert("修改失败");
	}
	
}

function Delete_click()
{
	var objtbl=document.getElementById('tUDHCDocPilotProDept')
  	DeleteTabRow(objtbl,SelectedRow)
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCDocPilotProDept');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (SelectedRow==selectrow) SelectedRow=0
	else SelectedRow=selectrow
		
     
	/*	var obj=document.getElementById('PPDRowId');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('PPCreateDepartment');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('PPStartUser');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('PPStartUserDr');
		if(obj){
			obj.value="";
		}
				return;
	}
	SelectedRow=selectrow
	SelRowObj=document.getElementById('TPPDRowIdz'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('PPDRowId');
		if(obj){
			obj.value=SelRowObj.value;
		}
	}
	SelRowObj=document.getElementById('TPPCreateDepartmentz'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('PPCreateDepartment');
		if(obj){
			obj.value=SelRowObj.innerText;
		}
	}
	SelRowObj=document.getElementById('TPPCreateDepartmentDrz'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('PPCreateDepartmentDr');
		if(obj){
			obj.value=SelRowObj.value;
		}
		var StartUsrStrMethod=DHCC_GetElementData("GetStartUsrStrMethod")
	if (StartUsrStrMethod!=""){
		var DocStr=cspRunServerMethod(StartUsrStrMethod,SelRowObj.value);
		if (DocStr!=""){
			var Arr=DHCC_StrToArray(DocStr);
			myCombAry["PPStartUser"].clearAll();
			myCombAry["PPStartUser"].addOption(Arr);
		}
	}
	}
	SelRowObj=document.getElementById('TPPStartUserz'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('PPStartUser');
		if(obj){
			obj.value=SelRowObj.innerText;
		}
	}
	SelRowObj=document.getElementById('TPPStartUserDrz'+selectrow);
	if (SelRowObj){
		//alert(SelRowObj.value)
		var obj=document.getElementById('PPStartUserDr');
		if(obj){
			obj.value=SelRowObj.value;
		}
	}*/
}
function AddRowToList(objtbl) {
	
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName('*'); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split('z');
			//arrId[arrId.length-1]=arrId[arrId.length-1]+1;
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1
			rowitems[j].id=arrId.join('z');
			rowitems[j].name=arrId.join('z');
			rowitems[j].value='';
			//rowitems[j].innerText='';
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	if ((objnewrow.rowIndex)%2==0){objnewrow.className='RowEven';}else {objnewrow.className='RowOdd';}
}
function DeleteTabRow(objtbl,SelRowIndex){
	if (SelRowIndex==0) return false;
	var rows=objtbl.rows.length;
	if (rows>2){
		objtbl.deleteRow(SelRowIndex);
	}else{
		objtbl.deleteRow(SelRowIndex);
		
	}
	var par_win = window.opener;
	var OtherDepStr=""
	var OtherDepartment=""
	var objtbl=document.getElementById('tUDHCDocPilotProDept');
	if (!objtbl) objtbl=document.getElementById('tUDHCDocPilotProDept0');
	if (objtbl){
			var rows = objtbl.rows;
			for(var i=0;i<=rows.length;i++){
				var TPPCreateDepartmentDr=DHCC_GetColumnData("TPPCreateDepartmentDr",i)
				var TPPStartUserDr=DHCC_GetColumnData("TPPStartUserDr",i)
				var TPPCreateDepartment=DHCC_GetColumnData("TPPCreateDepartment",i)
				var TPPStartUser=DHCC_GetColumnData("TPPStartUser",i)
				if ((TPPCreateDepartmentDr=="")||(TPPStartUser=="")) continue;
				if(OtherDepStr=="") OtherDepStr=TPPCreateDepartmentDr+"-"+TPPStartUserDr
				else OtherDepStr=OtherDepStr+"^"+TPPCreateDepartmentDr+"-"+TPPStartUserDr
				if(OtherDepartment=="") OtherDepartment=TPPCreateDepartment+"-"+TPPStartUser
				else OtherDepartment=OtherDepartment+";"+TPPCreateDepartment+"-"+TPPStartUser
			}	
		}	
	var obj=par_win.document.getElementById("OtherDepStr");
	if(obj)obj.value=OtherDepStr
	var obj=par_win.document.getElementById("OtherDepartment");
	if(obj)obj.value=OtherDepartment
	location.reload();
	SelectedRow=0
}
function Save_click(){
	var par_win = window.opener;
	var OtherDepStr=""
	var OtherDepartment=""
	var PPRowId=DHCC_GetElementData('PPRowId')	
	if (PPRowId!="") var ret=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","DeleteProjectDeptChild",PPRowId);
	var obj=document.getElementById('InsertProjectDept')
    if (obj) {var encemth=obj.value}else{encemth=""}
	var objtbl=document.getElementById('tUDHCDocPilotProDept');
	if (!objtbl) objtbl=document.getElementById('tUDHCDocPilotProDept0');
	if (objtbl)
	{
		var rows = objtbl.rows;
		for(var i=1;i<rows.length;i++)
		{
			var TPPCreateDepartmentDr=DHCC_GetColumnData("TPPCreateDepartmentDr",i)
			var TPPStartUserDr=DHCC_GetColumnData("TPPStartUserDr",i)
			var TPPCreateDepartment=DHCC_GetColumnData("TPPCreateDepartment",i)
			var TPPStartUser=DHCC_GetColumnData("TPPStartUser",i)
			if ((TPPCreateDepartmentDr=="")||(TPPStartUserDr=="")) continue;
			if(OtherDepStr=="") OtherDepStr=TPPCreateDepartmentDr+"-"+TPPStartUserDr
			else OtherDepStr=OtherDepStr+"^"+TPPCreateDepartmentDr+"-"+TPPStartUserDr
			if(OtherDepartment=="") OtherDepartment=TPPCreateDepartment+"-"+TPPStartUser
			else OtherDepartment=OtherDepartment+";"+TPPCreateDepartment+"-"+TPPStartUser
			if ((encemth!="")&&(PPRowId!="")){
				var ret=cspRunServerMethod(encemth,PPRowId,TPPCreateDepartmentDr,TPPStartUserDr)
			}
		}	
	}	
	var obj=par_win.document.getElementById("OtherDepStr");
	if(obj)obj.value=OtherDepStr
	var obj=par_win.document.getElementById("OtherDepartment");
	if(obj)obj.value=OtherDepartment
	window.close();
}