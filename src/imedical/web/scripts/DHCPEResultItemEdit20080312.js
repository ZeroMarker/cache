///Filename: DHCPhyExamItemEdit.js
///---------------------------
///Description: instead ItemDesc with ItemCode in function "ComputeExp()"
///Description: process labItems

var ComponentID=""
var gLastRow

function InitMe()	{
	var TblArr=document.getElementsByName('tDHCPEResultItemEdit');
	var UpdateArr=document.getElementsByName('Update');
	var GetNormalVArr=document.getElementsByName("btnGetNormalV");
	var RefreshArr=document.getElementsByName("btnRefresh");
	var ItemArr=document.getElementsByName('ItemParRef');
	for (var i=0; i<TblArr.length; i++)	{
		if (TblArr[i].Name=='tDHCPEResultItemEdit')	{
			TblArr[i].Name=TblArr[i].Name+ItemArr[i].value;
		}
	}
	for (var i=0; i<UpdateArr.length; i++)	{
		if (UpdateArr[i].id=='Update') {
			UpdateArr[i].id=UpdateArr[i].id+ItemArr[i].value;
			UpdateArr[i].Name=UpdateArr[i].Name+ItemArr[i].value;
			UpdateArr[i].onclick=Update_Click;
		}
	}
	for (var i=0; i<GetNormalVArr.length; i++)	{
		if (GetNormalVArr[i].id=='btnGetNormalV') {
			GetNormalVArr[i].id=GetNormalVArr[i].id+ItemArr[i].value;
			GetNormalVArr[i].Name=GetNormalVArr[i].Name+ItemArr[i].value;
			GetNormalVArr[i].onclick=btnGetNormalV_Click;
			RefreshArr[i].onclick=btnRefresh_Click;
			//alert("linked event");
		}
	}
	
	for (var i=0; i<TblArr.length; i++)	{
		var TblObj=TblArr[i];
		for(var j=1;j<TblObj.rows.length;j++){
			var RowObj=TblObj.rows[j];
			var ResultType=""
			for (k=0; k<RowObj.all.length; k++)	{
				var ItemObj=RowObj.all[k]
				if (ItemObj.id=='ResultTypez'+j) {ResultType=ItemObj.value;};
				if (ItemObj.id=='ResultSelectz'+j) {
					if (ResultType!="S"){
						ItemObj.style.visibility = "hidden"; 
					}
					ItemObj.onclick=ResultSelect_Click;
				}
			}
		}	
	}	
	
	GetLabData();
}

function  ResultSelect_Click() { 

	var obj=window.event.srcElement;
	gLastRow=getRow(obj);
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	
	//alert("gLastRow.rowIndex:"+gLastRow.rowIndex);
	for (k=0; k<gLastRow.all.length; k++)	{
		var ItemObj=gLastRow.all[k]
		if (ItemObj.id==('ItemIDz'+gLastRow.rowIndex)) {
			ItemID=ItemObj.value
		}
	}	
	for (k=0; k<gLastRow.all.length; k++)	{
		var ItemObj=gLastRow.all[k]
		if (ItemObj.id==('OEORIRowIdz'+gLastRow.rowIndex)) {
			OEORIRowId=ItemObj.value
		}
	}	
	//var EpisodeID="20";
	//var ItemID="65||1";
	
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEItemResult.List&EpisodeID='+EpisodeID+'&ItemID='+ItemID+'&OEORIRowId='+OEORIRowId;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=600,left=200,top=200')
}

function ChangeResult(NewValue){	
	if (gLastRow.rowIndex<=0) return;
	for (k=0; k<gLastRow.all.length; k++)	{
		var ItemObj=gLastRow.all[k]
		if (ItemObj.id==('ItemSelz'+gLastRow.rowIndex)) {
			ItemObj.value=NewValue;
		}
	}	
}

function btnGetNormalV_Click(){
	var btnId=window.event.srcElement.id;
	var subfix=btnId.substr("btnGetNormalV".length);
	var TblObj=GetCurTab(subfix);
	for(var j=1;j<TblObj.rows.length;j++){
		var RowObj=TblObj.rows[j];
		var CellNormalV;
		var CellSel;
		for (k=0; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id=='NormalVz'+j) {CellNormalV=ItemObj};
			if (ItemObj.id=='ItemSelz'+j) {CellSel=ItemObj};
			if (ItemObj.id=='ResultTypez'+j) {CellResultType=ItemObj;};
		}
		if ((MyReplace(CellNormalV.innerText," ","")!="")
				&(CellResultType.value=="S")
				& (MyReplace(CellSel.value," ","")=="")){
			CellSel.value=CellNormalV.innerText;
		}
	}
	return false;
}

function btnRefresh_Click(){
	location.reload(true);
}

function Update_Click()	{
	var ButtId=window.event.srcElement.id;
	if (ButtId=="") return false;//避免点到图片弹出一个错误退出
	var Tblsuffix=ButtId.split('Update')
	var TblObj=GetCurTab(Tblsuffix[1]);
	var ResultStr="";
	var ARCIM="";
	var OEORIRowId="";
	for (var j=1; j<TblObj.rows.length; j++)	{
		var RowObj=TblObj.rows[j];
		var ItemDesc="";
		var ItemSel="";
		var ItemID="";
		var rowStr="";
		var strComputeExp="";
		var CellSel;
		for (k=0; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id=='ItemIDz'+j) {ItemID=ItemObj.value};
			if (ItemObj.id=='ItemDescz'+j) {ItemDesc=ItemObj.innerText};
			if (ItemObj.id=='ItemSelz'+j) {ItemSel=ItemObj.value, CellSel=ItemObj};
			if (ItemObj.id=='ARCIMz'+j) {ARCIM=ItemObj.value};
			if (ItemObj.id=='OEORIRowIdz'+j) {OEORIRowId=ItemObj.value};
			if (ItemObj.id=='ResultTypez'+j) {ResultType=ItemObj.value};
			if (ItemObj.id=='ComputeExpz'+j) {strComputeExp=ItemObj.value};
		}
		//if (ResultType=="N") {ItemSel=Val(ItemSel);	}  //Modified by MLH 0905
		if (ResultType=="N") {ItemSel=ItemSel;	}
		if (ResultType=="C") {ItemSel=ComputeExp(Tblsuffix[1],strComputeExp)}

		CellSel.value=ItemSel; // reset the TextBox
		if (ResultType!="S") {
			rowStr=ItemID+'\001'+ItemSel
			if (ResultStr=='')	{ResultStr=rowStr}
			else  {ResultStr=ResultStr+'\002'+rowStr}
		}
		
		if (ResultType=="S") {
			//rowStr=ItemID+'\001'+ItemSel
			var sss=ItemSel.split(";")
			for (i=0; i<sss.length; i++){
				rowStr=ItemID+'\001'+sss[i]
				//alert("rowStr:"+rowStr)
				if (ResultStr=='')	{ResultStr=rowStr}
				else  {ResultStr=ResultStr+'\002'+rowStr}
			}
		}
		
	}
	//Insert or Update to Cache Database
	var UpdateMothod=document.getElementById("UpdateSrc");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	if (UpdateMothod) {var encmeth=UpdateMothod.value} else {var encmeth=''}
	//alert("EpisodeID+OEORIRowId+ARCIM+ResultStr"+EpisodeID+"&"+OEORIRowId+"&"+ARCIM+"&"+ResultStr+"&"+ResultStr);
	var UpdateCode=cspRunServerMethod(encmeth,EpisodeID,OEORIRowId,ResultStr);
	if (UpdateCode=='0') {alert(t['UpdateFailure']);}
	else if((UpdateCode=="GeneralAdviceAudited")||(UpdateCode=="NoArrived"))
	{
		alert(t[UpdateCode]);
	}
	else
	 {alert(t['UpdateSuccessful']);}
	return false;
}

function ComputeExp(tabSubfix, strExpression){	
	var TblObj=GetCurTab(tabSubfix);

	for(var j=1;j<TblObj.rows.length;j++){
		var RowObj=TblObj.rows[j];
		var CellItemDesc;
		var CellSel;
		for (k=0; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id=='ItemDescz'+j) {CellItemDesc=ItemObj};
			if (ItemObj.id=='ItemCodez'+j) {CellItemCode=ItemObj};
			if (ItemObj.id=='ItemSelz'+j) {CellSel=ItemObj};
			if (ItemObj.id=='ResultTypez'+j) {CellResultType=ItemObj};			
		}
		while(strExpression.indexOf("["+CellItemCode.value+"]")>=0){
			if (CellSel.value=="") return "";
			strExpression=MyReplace(strExpression,"["+CellItemCode.value+"]", Val(CellSel.value));
		}
	}
	var ret=0;
	if (strExpression!="") {
		strExpression="ret="+strExpression;
		eval(strExpression);
		if (!eval(strExpression)) {ret=0};
	}
	
	ret=(parseInt((ret*100)+0.5))/100
	return ret;
}

//return: the current table
function GetCurTab(tabSubfix){
	var TblArr=document.getElementsByName('tDHCPEResultItemEdit');
	for (var i=0; i<TblArr.length; i++)	{
		if (TblArr[i].Name=='tDHCPEResultItemEdit'+tabSubfix)	{
			return TblArr[i]
		}
	}
	alert("Error: wrong tableName:" +'tDHCPEResultItemEdit'+tabSubfix);
}

function ColValueHandler(ColName)	{
	var WorkComponent=document.getElementById("ComponentID");
	if (WorkComponent) {ComponentID=WorkComponent.value;}	
	var url='websys.lookup.csp';
	url += "?ID=d"+ComponentID+"iColValue";
	url += "&CONTEXT=Kweb.CTSex:LookUp";
	var obj=document.getElementById(ColName);
	if (obj) url += "&P1=" + websys_escape(obj.value);
	websys_lu(url,1,'');
	return websys_cancel();
}
function ColValue_lookupsel(value) {
	try {
		alert('AAAA:'+value);
		var obj=document.getElementById('CTSEXDesc');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
			websys_nexttab('6',obj.form);
		}
	} catch(e) {};
}

function GetLabData(){
	var srcObj=document.getElementById("GetLabResultBox");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
	if (srcObj) {var encmeth=srcObj.value} else {var encmeth=''}
	if (encmeth=='') {encmeth="web.DHCPE.TransResult.Main"};
	var ret=cspRunServerMethod(encmeth,EpisodeID);	
}