//Create by MLH

var CurrentSel=0
var SelectedRow=-1
var UserId=session['LOGON.USERID']
var gLastRow;
function BodyLoadHandler()
{	
	//alert(window.opener.event.srcElement.id);
	var TblObj=document.getElementById('tDHCPEItemResult_List');
	var Updateobj=document.getElementById("Update");
	if (Updateobj) Updateobj.onclick=Update_Click;  
	
	var GetTempArr=document.getElementsByName('TTemplate');

	for(var j=1;j<TblObj.rows.length;j++){
		var GetTempObj=document.getElementById('TTemplatez'+j);
		var ShowTempBtnObj=document.getElementById('TShowTempBtnz'+j);
		//var showTempBtn=ShowTempBtnObj.value
		if (GetTempObj){
			if (ShowTempBtnObj.value==0) {
				GetTempObj.style.visibility = "hidden";	
			} 
			GetTempObj.onclick=GetTemplate_Click;
		} 	
	}	
}

//¸üÐÂ
function Update_Click()
{	
	//window.opener.IChangeResult("Update");
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    if (obj){
		EpisodeID=obj.value
	}
	
	var ItemID=""
  	var obj=document.getElementById("ItemID");
    if (obj){
		ItemID=obj.value
	}

	var OEORIRowId=""
  	var obj=document.getElementById("OEORIRowId");
    if (obj){
		OEORIRowId=obj.value
	}


	var TblObj=document.getElementById('tDHCPEItemResult_List');
	//alert("TblObj.Length:"+TblObj.rows.length);
	
	var RltStr=""
	var RtnStr=""
	
	for(var j=1;j<TblObj.rows.length;j++){
		var RowObj=TblObj.rows[j];
		var CellSelect;
		var CellTextVal;
		var CellRowId;
		var Nature;
		var CellSelect=document.getElementById('TSelectz'+j)
		var CellTextVal=document.getElementById('TTextValz'+j)
		var CellTempDesc=document.getElementById('TTemplateDetailz'+j)
		var CellNatureValue=document.getElementById('TNatureValuez'+j)
		var CellRowId=document.getElementById('TRowIdz'+j)
		if (CellSelect.checked==true) {
			Nature=0;
			if (CellNatureValue.checked==true){
				Nature=1;
			}
			if (RltStr==""){
				RltStr=CellTextVal.innerText+'\001'+CellTempDesc.value+'\001'+Nature
				RtnStr=CellTextVal.innerText
			}
			else{
				RltStr=RltStr+"^"+CellTextVal.innerText+'\001'+CellTempDesc.value+'\001'+Nature
				RtnStr=RtnStr+";"+CellTextVal.innerText
			}
		} 	
	}
   	var Ins=document.getElementById('UpdateBox');
   	if (Ins) {var encmeth=Ins.value} 
    else {var encmeth=''};
    var flag=cspRunServerMethod(encmeth,ItemID,RltStr,EpisodeID,OEORIRowId)
    if ('0'==flag) 
    {
	    window.opener.ChangeResult(RtnStr);
		window.close();
	}
    else{
		alert("Update error.ErrNo="+flag)
    } 	
	
	return false;
}   

function GetTemplate_Click(){

	var src=window.event.srcElement;
	gLastRow=getRow(src);
	var RowIdOBJ=document.getElementById('TRowIdz'+gLastRow.rowIndex);
	if (RowIdOBJ){
		var ODSRowId=RowIdOBJ.value;
	}
	var DetailOBJ=document.getElementById('TTemplateDetailz'+gLastRow.rowIndex);
	if (DetailOBJ){
		var TemplateDetail=DetailOBJ.value;
	}
	
	var GetTempMothod=document.getElementById("GetTemplateBox");
	if (GetTempMothod) {var encmeth=GetTempMothod.value} else {var encmeth=''}
	var GetTempRtn=cspRunServerMethod(encmeth,ODSRowId);
	
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEItemTemplate&ODSRowId='+ODSRowId+"&TemplateDetail="+TemplateDetail;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=400,height=300,left=200,top=200')
	//return false;

}
//Create by MLH 20071205
function ChangeTemplate(TemplateValue){
	//alert("gLastRow.rowIndex:"+gLastRow.rowIndex);
	if (gLastRow.rowIndex<=0) return;
	//alert("gLastRow.all.length:"+gLastRow.all.length);
	for (k=0; k<gLastRow.all.length; k++)	{
		var ItemObj=gLastRow.all[k]
		if (ItemObj.id==('TTemplateDetailz'+gLastRow.rowIndex)) {
			ItemObj.value=TemplateValue;
		}
	}
	//alert("TemplateValue:"+TemplateValue);
}

document.body.onload = BodyLoadHandler;