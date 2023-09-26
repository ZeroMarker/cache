///Filename: DHCPEResultItemEdit.js
///---------------------------
///Description: instead ItemDesc with ItemCode in function "ComputeExp()"
///Description: process labItems

var ComponentID=""
var gLastRow
var HospitalCode

function InitMe()	{
	var TblArr=document.getElementsByName('tDHCPEResultItemEdit');
	//if (TblArr)
	var UpdateArr=document.getElementsByName('Update');
	var GetNormalVArr=document.getElementsByName("btnGetNormalV");
	var RefuseArr=document.getElementsByName('Refuse');
	var RefreshArr=document.getElementsByName("btnRefresh");
	var ItemArr=document.getElementsByName('ItemParRef');
	var GetBaseDataArr=document.getElementsByName('GetBaseData');
    var DocNameArr=document.getElementsByName('DocName');
    var DocIDArr=document.getElementsByName('DocID');
	var DealExe=document.getElementsByName("BPisRequestPrint");
	
	
	
	for (var i=0; i<TblArr.length; i++)	{
		if (TblArr[i].Name=='tDHCPEResultItemEdit')	{
			TblArr[i].onclick=Tbl_click;
			TblArr[i].Name=TblArr[i].Name+ItemArr[i].value;
		}
	}
	for (var i=0; i<UpdateArr.length; i++)	{
		if (UpdateArr[i].id=='Update') {
			UpdateArr[i].id=UpdateArr[i].id+ItemArr[i].value;
			var CurRow=i+1;
			UpdateArr[i].Name=UpdateArr[i].Name+ItemArr[i].value+"^"+CurRow;
			UpdateArr[i].onclick=Update_Click;
		}
	}

	for (var i=0; i<GetNormalVArr.length; i++)	{
		
		if (GetNormalVArr[i].id=='btnGetNormalV') {
			
			GetNormalVArr[i].id=GetNormalVArr[i].id+ItemArr[i].value;
			var CurRow=i+1;
			GetNormalVArr[i].Name=GetNormalVArr[i].Name+ItemArr[i].value+"^"+CurRow;
 
			GetNormalVArr[i].onclick=btnGetNormalV_Click;
			
			//RefreshArr[i].onclick=btnRefresh_Click;
		
		}
	}
	
	    /*
		for (var i=0; i<DocNameArr.length; i++)	{
		if (DocNameArr[i].id=='DocName') {
			DocNameArr[i].id=DocNameArr[i].id+ItemArr[i].value;
			var CurRow=i+1;
			DocNameArr[i].Name=DocNameArr[i].Name+ItemArr[i].value+"^"+CurRow;
		}
	} */
		for (var i=0; i<DocNameArr.length; i++)	{
		if (DocNameArr[i].id=='DocName') {
			DocNameArr[i].id=DocNameArr[i].id+ItemArr[i].value;
			var CurRow=i+1;
			DocNameArr[i].Name=DocNameArr[i].Name+ItemArr[i].value+"^"+CurRow;
			DocNameArr[i].onkeydown=UserKeyDown;
		}
	}

	for (var i=0; i<DocIDArr.length; i++)	{
		if (DocIDArr[i].id=='DocID') {
			DocIDArr[i].id=DocIDArr[i].id+ItemArr[i].value;
			var CurRow=i+1;
			DocIDArr[i].Name=DocIDArr[i].Name+ItemArr[i].value+"^"+CurRow;
	
		}
	}
	var RefuseCheckArr=document.getElementsByName('RefuseCheck');
	for (var i=0; i<RefuseCheckArr.length; i++)	{
		if (RefuseCheckArr[i].id=='RefuseCheck') {
			RefuseCheckArr[i].id=RefuseCheckArr[i].id+ItemArr[i].value;
			var CurRow=i+1;
			RefuseCheckArr[i].Name=RefuseCheckArr[i].Name+ItemArr[i].value+"^"+CurRow;
			RefuseCheckArr[i].onclick=RefuseCheckArr_Click;
            RefreshArr[i].onclick=btnRefresh_Click;
			//alert("linked event");
		}
	}

	for (var i=0; i<RefuseArr.length; i++)	{
		if (RefuseArr[i].id=='Refuse') {
			RefuseArr[i].id=RefuseArr[i].id+ItemArr[i].value;
			var CurRow=i+1;
			RefuseArr[i].Name=RefuseArr[i].Name+ItemArr[i].value+"^"+CurRow;;
			RefuseArr[i].onclick=Refuse_Click;
		}
	}
	for (var i=0; i<TblArr.length; i++)	{
		var TblObj=TblArr[i];
		for(var j=1;j<TblObj.rows.length;j++){
			var RowObj=TblObj.rows[j];
			var ResultType=""
			var Flag=1;
			var HighRisk="N";
			for (k=0; k<RowObj.all.length; k++)	{
				var ItemObj=RowObj.all[k]
				if (ItemObj.id=='ResultTypez'+j) {ResultType=ItemObj.value;};
				if (ItemObj.id=='ResultSelectz'+j) {
					if (ResultType!="S"){
						ItemObj.style.visibility = "hidden"; 
					}
					ItemObj.onclick=ResultSelect_Click;
				}
				if (ItemObj.id=="TFlagz"+j){Flag=ItemObj.value;}
				if (ItemObj.id=="THighRiskz"+j){HighRisk=ItemObj.value;}
				ItemObj.className="Green";   //add by lxl 20121203
				if (ItemObj.id=="ItemDescz"+j)
				{
					if ((Flag=="2")||(Flag=="0")||(Flag=="3"))
					{
						ItemObj.style.color="red";	
					}
					
					if (HighRisk=="Y"){
						ItemObj.style.color="yellow";	
					}
				}
			}
			
		}	
	}
	
	//Delete Item  Add by MLH 20080312
	for (var i=0; i<TblArr.length; i++)	{
		var TblObj=TblArr[i];
		for(var j=1;j<TblObj.rows.length;j++){
			var RowObj=TblObj.rows[j];
			var ResultType=""
			for (k=0; k<RowObj.all.length; k++)	{
				var ItemObj=RowObj.all[k]
				if (ItemObj.id=='ResultTypez'+j) {ResultType=ItemObj.value;};
				if (ItemObj.id=='DeleteItemz'+j) {
					if (ResultType=="C"){
						ItemObj.style.visibility = "hidden"; 
					}
					ItemObj.onclick=DeleteItem_Click;
				}
			}
		}	
	}
	// 
	for (var i=0; i<GetBaseDataArr.length; i++)	{
		if (GetBaseDataArr[i].id=='GetBaseData') {
			GetBaseDataArr[i].id=GetBaseDataArr[i].id+ItemArr[i].value;
			GetBaseDataArr[i].Name=GetBaseDataArr[i].Name+ItemArr[i].value;
			GetBaseDataArr[i].onclick=GetBaseData_Click;
			GetBaseDataArr[i].style.display="inline";;
		}
	}
	for (var i=0; i<DealExe.length; i++)	{
		if (DealExe[i].id=='BPisRequestPrint') {
			DealExe[i].id=DealExe[i].id;
			DealExe[i].name=ItemArr[i].value+"^"+i;
			DealExe[i].onclick=BPisRequestPrint_click;
			//UserLookUpObj[i].onclick=UserLookUpObj[0].onclick;
		}
	}
	
	var HospitalCodeobj=document.getElementById("HospitalCode");
	if (HospitalCodeobj) HospitalCode=HospitalCodeobj.value;
	PermissonSetting();
	zd()
    
	//GetLabData();
	//BodyKeyDown()
}
function Tbl_click(e)
{
	var ID=window.event.srcElement.id;
	if (ID.substring(0,2)=="ED"){
		return;
	}else if (ID.substring(0,7)=="ItemSel"){
		return;
	}else{
		removeDiv("div");
	}
}
function UserKeyDown(){
	var key=websys_getKey(e);
	if (13==key) {

		
	     var ButtId=window.event.srcElement.id;
	     if (ButtId=="") return false;  //避免点到图片弹出一个错误退出
	     var name=window.event.srcElement.Name;
	     var CurRow=name.split("^")[1];
	     var Tblsuffix=ButtId.split('DocName')
	     gLastRow=Tblsuffix[1]
         var obj=document.getElementById("DocName"+Tblsuffix[1]);
	    if (obj) DocName=obj.value;
		ShowUser(DocName);
		return false;
		}
}
function ShowUser(Arg)
{
	var method="web.DHCPE.PreIADM:UserList"
	var jsfunction="GetUserID"
	var url='websys.lookup.csp';
		url += "?ID=";
		url += "&CONTEXT=K"+method;
		url += "&TLUJSF="+jsfunction;	
		url += "&P1="+ Arg;
	websys_lu(url,1,'');
	return websys_cancel();	
}
function GetUserID(value)
{ 
	var Data=value.split("^");
	var name=document.getElementById('DocID'+gLastRow);
	if (name) name.value=Data[1];
	var name=document.getElementById('DocName'+gLastRow);
	if (name) name.value=Data[0];
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

function DeleteItem_Click(){
	var obj=window.event.srcElement;
	gLastRow=getRow(obj);

	for (k=0; k<gLastRow.all.length; k++)	{
		var ItemObj=gLastRow.all[k]
		if (ItemObj.id==('ItemSelz'+gLastRow.rowIndex)) {
			ItemObj.value="";
		}
	}	
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
	if (btnId=="") return false;
	var name=window.event.srcElement.Name;
	var CurRow=name.split("^")[1];
	var Tblsuffix=btnId.split('btnGetNormalV')
   
	var subfix=btnId.substr("btnGetNormalV".length);
	var TblObj=GetCurTab(subfix);
	var DocName=""
    var obj=document.getElementById("DocName"+Tblsuffix[1]);
	if (obj) DocName=obj.value;
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
	////////////////////////Modified by MLH 2008-03-05 Add GetNormalData And Save
	//var ButtId=window.event.srcElement.id;
	//if (ButtId=="") return false;  //避免点到图片弹出一个错误退出
	//var Tblsuffix=ButtId.split('Update')
	//var TblObj=GetCurTab(Tblsuffix[1]);
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
		for (k=1; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id=='ItemIDz'+j) {ItemID=ItemObj.value};
			if (ItemObj.id=='ItemDescz'+j) {ItemDesc=ItemObj.innerText};
			if (ItemObj.id=='ItemSelz'+j) {ItemSel=ItemObj.value, CellSel=ItemObj};
			if (ItemObj.id=='ARCIMz'+j) {ARCIM=ItemObj.value};
			if (ItemObj.id=='OEORIRowIdz'+j) {OEORIRowId=ItemObj.value};
			if (ItemObj.id=='ResultTypez'+j) {ResultType=ItemObj.value};
			if (ItemObj.id=='ComputeExpz'+j) {strComputeExp=ItemObj.value};
		}
		if (ResultType=="N") {ItemSel=ItemSel;	}
		if (ResultType=="C") {ItemSel=ComputeExp(subfix,strComputeExp)}
     
		CellSel.value=ItemSel; // reset the TextBox
		if (ResultType!="S") {
			rowStr=ItemID+'\001'+ItemSel
			
			if (ResultStr=='')	{ResultStr=rowStr}
			else  {ResultStr=ResultStr+'\002'+rowStr}
		}
		  
		if (ResultType=="S") {
			var sss=ItemSel.split(";")
			for (i=0; i<sss.length; i++){
				rowStr=ItemID+'\001'+sss[i]
				if (ResultStr=='')	{ResultStr=rowStr}
				else  {ResultStr=ResultStr+'\002'+rowStr}
			}
		}

	}
	
	if (HospitalCode!="NBMZ"){
		var UpdateMothod=document.getElementById("UpdateSrc");
		var EpisodeIDobj=document.getElementById("EpisodeID");
		if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
		if (UpdateMothod) {var encmeth=UpdateMothod.value} else {var encmeth=''}
		//alert("EpisodeID+OEORIRowId+ARCIM+ResultStr"+EpisodeID+"&"+OEORIRowId+"&"+ARCIM+"&"+ResultStr+"&"+ResultStr);
		var UpdateCode=cspRunServerMethod(encmeth,EpisodeID,OEORIRowId,ResultStr,DocName);
		if (UpdateCode=='0') {alert(t['UpdateFailure']);}
		else if((UpdateCode=="GeneralAdviceAudited")||(UpdateCode=="NoArrived"))
		{
			alert(t[UpdateCode]);
		}
		else if(UpdateCode=="RefuseItem"){alert(t['RefuseItem'])}
		else
		 {
			 try{
				if (parent.frames("result")){
					return false;
				}
			}catch(e){
			 	zd(CurRow);
			}
		 }
		}
	return false;
}

function RefuseCheckArr_Click(){
	
	var btnId=window.event.srcElement.id;
	if (btnId=="") return false;
	var name=window.event.srcElement.Name;
	var CurRow=name.split("^")[1];
	var subfix=btnId.substr("RefuseCheck".length);
	var Tblsuffix=btnId.split('RefuseCheck')
	var TblObj=GetCurTab(subfix);
	var DocName=""
    var obj=document.getElementById("DocName"+Tblsuffix[1]);
	if (obj) DocName=obj.value;
     
	for(var j=1;j<TblObj.rows.length;j++){
		var RowObj=TblObj.rows[j];
		var CellNormalV;
		var CellSel;
		for (k=0; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id=='NormalVz'+j) {CellNormalV=ItemObj};
			if (ItemObj.id=='ItemSelz'+j) {CellSel=ItemObj};
			if (ItemObj.id=='ResultTypez'+j) {CellResultType=ItemObj;};
			if (ItemObj.id=='ItemIDz'+j) {ItemID=ItemObj.value}
	
		}
			var Mothod=document.getElementById("GetRefuseInfo")
			if (Mothod) {var encmeth=Mothod.value} else {var encmeth=''}
		    var RefuseFlag=cspRunServerMethod(encmeth,ItemID);
		    if (RefuseFlag=="1")
				{
			CellSel.value="谢绝检查";
		}
	}
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
		for (k=1; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id=='ItemIDz'+j) {ItemID=ItemObj.value};
			if (ItemObj.id=='ItemDescz'+j) {ItemDesc=ItemObj.innerText};
			if (ItemObj.id=='ItemSelz'+j) {ItemSel=ItemObj.value, CellSel=ItemObj};
			if (ItemObj.id=='ARCIMz'+j) {ARCIM=ItemObj.value};
			if (ItemObj.id=='OEORIRowIdz'+j) {OEORIRowId=ItemObj.value};
			if (ItemObj.id=='ResultTypez'+j) {ResultType=ItemObj.value};
			if (ItemObj.id=='ComputeExpz'+j) {strComputeExp=ItemObj.value};
	
		}
		if (ResultType=="N") {ItemSel=ItemSel;	}
		if (ResultType=="C") {ItemSel=ComputeExp(subfix,strComputeExp)}

		CellSel.value=ItemSel; // reset the TextBox
		if (ResultType!="S") {
			rowStr=ItemID+'\001'+ItemSel
			
			if (ResultStr=='')	{ResultStr=rowStr}
			else  {ResultStr=ResultStr+'\002'+rowStr}
		}
		if (ResultType=="S") {
			var sss=ItemSel.split(";")
			for (i=0; i<sss.length; i++){
				rowStr=ItemID+'\001'+sss[i]
				if (ResultStr=='')	{ResultStr=rowStr}
				else  {ResultStr=ResultStr+'\002'+rowStr}
			}
		}
	}
	if (HospitalCode!="NBMZ"){
		var UpdateMothod=document.getElementById("UpdateRefuseInfo");
		var EpisodeIDobj=document.getElementById("EpisodeID");
		if (EpisodeIDobj) var EpisodeID=EpisodeIDobj.value;
		if (UpdateMothod) {var encmeth=UpdateMothod.value} else {var encmeth=''}

		var UpdateCode=cspRunServerMethod(encmeth,EpisodeID,OEORIRowId,ResultStr,DocName);
		if (UpdateCode=='0') {alert(t['UpdateFailure']);}
		else if((UpdateCode=="GeneralAdviceAudited")||(UpdateCode=="NoArrived"))
		{
			alert(t[UpdateCode]);
		}
		else
		 { //alert(t['UpdateSuccessful']);
			 	zd(CurRow);
		 }
		}
	return false;
}

function btnRefresh_Click(){
	location.reload(true);
}

function test(){
	alert("usise");
}

function Update_Click()	{
	var ButtId=window.event.srcElement.id;
	if (ButtId=="") return false;  //避免点到图片弹出一个错误退出
	var name=window.event.srcElement.Name;
	var CurRow=name.split("^")[1];
	var Tblsuffix=ButtId.split('Update')
	var TblObj=GetCurTab(Tblsuffix[1]);
	var ResultStr="";
	var ARCIM="";
	var OEORIRowId="";
   	var DocID="",DocName="" 
   
    var obj=document.getElementById("DocID"+Tblsuffix[1]);                    //add by zl 2010-11-29
	if (obj) DocID=obj.value;                                                 //add by zl 2010-11-29
    var obj=document.getElementById("DocName"+Tblsuffix[1]);                   //add by zl 2010-11-29        
	if (obj){ DocName=obj.value};                                             //add by zl 2010-11-29                                    
	 var DocStr=DocName+"^"+DocID                                             //add by zl 2010-11-29  
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
			if (ItemObj.id=='Selez'+j) {Sele=ItemObj.value};
		      
		}
		
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
	var UpdateCode=cspRunServerMethod(encmeth,EpisodeID,OEORIRowId,ResultStr,DocStr);
	
	if (UpdateCode=='0') {alert(t['UpdateFailure']);}
	else if((UpdateCode=="GeneralAdviceAudited")||(UpdateCode=="NoArrived"))
	{
		alert(t[UpdateCode]);
	}
	else if(UpdateCode=="RefuseItem"){alert(t['RefuseItem'])}
	else
	 {//alert(t['UpdateSuccessful']);
		if (HospitalCode!="NBMZ"){
			try{
				if (parent.frames("result")){
					//alert(t['UpdateSuccessful']);
					return false;
				}
			}catch(e){
		 		zd(CurRow);
			}
		 }
		else {
		 	//alert(t['UpdateSuccessful']);
		 }
	 }
	return false;
}

function Refuse_Click()	{
	var ButtonId=window.event.srcElement.id;
	if (ButtonId=="") return false;  //避免点到图片弹出一个错误退出
	var OEORIRowIdBak=ButtonId.split('Refuse')[1];
	//alert(ButtonId)
	var name=window.event.srcElement.Name;
	//alert(name)
	var CurRow=name.split("^")[1];
	var Tblsuffix=ButtonId.split('Refuse')
	var TblObj=GetCurTab(Tblsuffix[1]);
	var ResultStr="";
	var ARCIM="";
	var OEORIRowId="";
	var RefuseMothod=document.getElementById("RefuseBox");
	var OEORIRowIdobj=document.getElementById("OEORIRowIdItem"); 
	for (var j=1; j<TblObj.rows.length; j++)	{
		var RowObj=TblObj.rows[j];
		for (k=0; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id=='OEORIRowIdz'+j) {OEORIRowId=ItemObj.value};
			
		}
	}
	
	//if (OEORIRowIdobj) var OEORIRowId=OEORIRowIdobj.value;
	if (RefuseMothod) {var encmeth=RefuseMothod.value} else {var encmeth=''}
	if (OEORIRowId=="") OEORIRowId=OEORIRowIdBak;
	var RefuseCode=cspRunServerMethod(encmeth,OEORIRowId);
	
	if (RefuseCode=='0') 
	{alert(t['OrderItemRefused']);
	//window.location.reload();
	}
	else if(RefuseCode=="-1")
	{
		alert(t['OrderItemExecuted']);
	}
	else
	 {alert(t['RefuseErr']);}
	return false;
}

function ComputeExp(tabSubfix, strExpression){	
	
	try{
		if (parent.frames("diagnosis")){
			var TblObj=document.getElementById("tDHCPEResultItemEdit");
		}
	}catch(e){
		var TblObj=GetCurTab(tabSubfix);
	}
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
		//alert(CellItemCode)
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
	//ret=ret*10000
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
	return NUll
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


/// 复兴医院 2008.03.03 xuwm
/// 
function GetBaseData_Click(){
	var gebtn=window.event.srcElement;
	if (gebtn.id=="") return false;
	var obj=document.getElementById("GetBaseDataBox");
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var ret=cspRunServerMethod(encmeth,'');
	
	if (ret.indexOf('Error')>-1) { return ;}
	var Tblsuffix=gebtn.id.split('GetBaseData')
	var TblObj=GetCurTab(Tblsuffix[1]);
	var ItemID="";
	for (var j=1; j<TblObj.rows.length; j++)	{
		var RowObj=TblObj.rows[j];
			
			obj=document.getElementById('ItemIDz'+j);
			if (obj) { ItemID=obj.value; }
			else { ItemID=''; }
			
			if (ret.indexOf('^'+ItemID+':')>-1) {
				var star=ret.indexOf(':',ret.indexOf('^'+ItemID+':'));
				var end=ret.indexOf(';',ret.indexOf('^'+ItemID+':'));
				val=ret.substring(star+1,end);
				obj=document.getElementById('ItemSelz'+j);
				
				if (obj) { obj.value=val; };
			}
	}
}

function zd(LastRow)
{
	var obj=document.getElementById("ComponentID");
	if (obj){var ComponentID=obj.value;}
	var ItemName="r"+ComponentID+"iSelectz"
	var ItemName=ItemName+LastRow
	var ItemLength=ItemName.length
	var SummaryForm=document.forms['fDHCPE_Station_ResultEdit'];
	var j=0
	var i=SummaryForm.all.length
	/*
	for (j=0;j<i;j++)
	{
		var Name=SummaryForm.all[j].id;
		if (Name.substr(Name.length-ItemLength,ItemLength)==ItemName)
		{
			websys_component(SummaryForm.all[j],SummaryForm.all[j].id);
			var obj=SummaryForm.document.getElementById("ItemSelz"+LastRow);
	
			if (obj) websys_setfocus("ItemSelz"+LastRow);
		}
	}
	*/
	return false;
}
function BPisRequestPrint_click()
{
	var PAAdmId=GetCtlValueById("EpisodeID", 0);
	PrintByTemplate(PAAdmId);
	return false;
}
function PrintByTemplate(iPAADMDR)
{
	var Template="DHCPEPISRequest"
	var Data=tkMakeServerCall("web.DHCPE.ReportGetInfor","GetSpecialReportInfo",iPAADMDR,Template);
	if (Data!=""){
		PrintReportByXml(Data,Template);
		return false;
	}else{
		alert("没有设置打印格式对应的数据");
		return false;
	}	
}
function PrintReportByXml(ReportData,Template)
{
	DHCP_GetXMLConfig("InvPrintEncrypt",Template);
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,ReportData,"");
	return false
}

function PermissonSetting(){
	var UserId, PAAdmId, ChartId, SvrMethod
	UserId=session['LOGON.USERID'];
	PAAdmId=GetCtlValueById("EpisodeID", 0)
	ChartId=GetCtlValueById("ChartID", 1)
	SvrMethod=GetCtlValueById("methodResultPermission", 1)
	var MyPermission=cspRunServerMethod(SvrMethod,UserId, PAAdmId, 0, ChartId)
	if (MyPermission=="R"){
		DisabledCtls("A",true);
		DisabledCtls("input",true);
	    DisabledCtls("select",true);
	    if (parent.frames("query")){
		    var obj=parent.frames("query").document.getElementById("RegNo");
	    	if (obj){
				
				obj.select();
				obj.focus();
			}
		}
		return "R";
	}
	obj=document.getElementById('ItemSelz1');
	if (obj){
		obj.focus();
		obj.select();
	}
	return "W";
	
}
