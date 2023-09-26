
var combo_DiagnosDesc;
var selectedRow=0
function BodyLoadHandler() {
	var obj=document.getElementById("AddLink")
	if (obj) obj.onclick=addDiagnosSyndLink;
	var obj=document.getElementById("Del")
	if (obj) obj.onclick=DelDiagnosSyndLink;
	var obj=document.getElementById("MRCICDDesc") 
	if (obj) obj.ondblclick=ListDoubleClickHandler;
	var obj=document.getElementById("SyndSign") 
	if (obj) obj.ondblclick=SyndListDoubleClickHandler;
	var obj=document.getElementById("MRCICDLookup") 
	if (obj) obj.onkeydown=List;
	var obj=document.getElementById("SyndSignLookup") 
	if (obj) obj.onkeydown=SyndList;

	var obj=document.getElementById("LinkSyndSignCreat") 
	if (obj) obj.onclick=LinkSyndSignCreat;
	
	

	
	
	
	//initList();

}
function initList(){
	var obj=document.getElementById("SyndSign");
	if(obj){
		//obj.size=1; ///就是说listbox只显示1行
		obj.multiple=true;
		var objSignSympListDesc=document.getElementById('GetSignSymptomlist');
		if (objSignSympListDesc) {var encmeth=objSignSympListDesc.value} else {var encmeth=''};
		var OutStr=cspRunServerMethod(encmeth)
		if(OutStr!=""){
			var VerArr1=OutStr.split("|");
			var ArrTxt= new Array(VerArr1.length-1);
			var ArrValue = new Array(VerArr1.length-1);
			for(i=1;i<VerArr1.length;i++){
				var VerArr2=VerArr1[i].split("^");
				ArrTxt[i-1]=VerArr2[1];
				ArrValue[i-1]=VerArr2[0];
			}
			ClearAllList(obj);
			AddItemToList(obj,ArrTxt,ArrValue)
		}
			
	}
	
}
function MRDiagnosSelect(str){
  var MRDIAICDCodeObj=document.getElementById("MRCICDLookup")
  var MRDIAICDCodeDRObj=document.getElementById("MRDIAICDCodeDR")
  var ICDCode=str.split("^")[0]
  MRDIAICDCodeObj.value=ICDCode.split("|")[0]
  MRDIAICDCodeDRObj.value=str.split("^")[1]
  var DiagnosDesc = MRDIAICDCodeObj.value;
  DiagnosValue = MRDIAICDCodeDRObj.value
  if ((DiagnosDesc == '') || (DiagnosValue == '')) return;
  var DiagnosListObj = document.getElementById('MRCICDDesc');
  DiagnosListObj.add(new Option(DiagnosDesc, DiagnosValue));
  if(DiagnosListObj.options[0].text!= ''){
    MRDIAICDCodeObj.value="";
    MRDIAICDCodeDRObj.value="";
    }
}

function SyndSignSelect(str){
  var SyndSignObj=document.getElementById("SyndSignLookup")
  SyndSignObj.value=str.split("^")[1]
  var SyndRowid=str.split("^")[0]
  var SyndSign = SyndSignObj.value;
  if ((SyndSign == '') || (SyndSign == '')) return;
  var SyndSignListObj = document.getElementById('SyndSign');
  SyndSignListObj.add(new Option(SyndSign, SyndRowid));
  if(SyndSignListObj.options[0].text!= ''){
    SyndSignObj.value="";
    }
}

function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}	

function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				//alert(i)
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); 
				lstlen++;}
		}
	}
}
function addDiagnosSyndLink()
{
	var ItemDiagnos="",Discount="",ItemSynd=""
  
	var obj=document.getElementById("MRCICDDesc");
	if(obj)
	{
		for (var m=0;m<obj.options.length;m++) {
			if(ItemDiagnos=="")ItemDiagnos=obj.options[m].value;
			else ItemDiagnos=ItemDiagnos+"$"+obj.options[m].value;
			
		}
	}
	if(ItemDiagnos==""){
		alert("诊断不能为空!")
		return false;
	}
	var obj=document.getElementById("SyndSign");
	if(obj)
	{
		for (var m=0;m<obj.options.length;m++) {
			if(ItemSynd=="")ItemSynd=obj.options[m].value;
			else ItemSynd=ItemSynd+"$"+obj.options[m].value;}
		if(ItemSynd==""){
			alert(t['Select']);
			return false;}
	}
	var PutStr=ItemDiagnos+"^"+ItemSynd
	var obj=document.getElementById("InsertDiagnosSyndLinkMethod");
	if (obj) { encmeth=obj.value;}
	if (encmeth!='')var ret=cspRunServerMethod(encmeth,PutStr);
	if (ret==0){
		alert(t['FailUpdate']);
		location.reload();
		return;
			}
	else if (ret==-1){
		alert("对照关系已经存在ㄐ");
		return;
			}
	else{
		alert(t['SuccessUpdate']);
		location.reload();
		return;
			}	
}
function DelDiagnosSyndLink()
{

	var ItemDiagnos="",Discount="",ItemSynd=""
  
	var obj=document.getElementById("MRCICDDesc");
	if(obj) {var ItemDiagnos=obj.options[0].value}
	
	
	var obj=document.getElementById("SyndSign");
	if(obj) {var ItemSynd=obj.options[0].value}
		
	var PutStr=ItemDiagnos+"^"+ItemSynd
	var obj=document.getElementById("DeleteDiagnosSyndLinkMethod");
	if (obj) { encmeth=obj.value;}
	if (encmeth!='')var ret=cspRunServerMethod(encmeth,PutStr);
	if (ret==0){
		alert("删除成功!");
		Find_click();
		return;
	}else{
		alert("删除失败!");
		return;
	}	
}
function ListDoubleClickHandler()
{ 
	var obj=document.getElementById("MRCICDDesc")
	for (var m=0;m<obj.options.length;m++) {
			if(obj.options[m].selected){
				obj.options[m] = null;
				}
			}	
}
	
function SyndListDoubleClickHandler()
{
	var obj=document.getElementById("SyndSign");
	for (var m=0;m<obj.options.length;m++) {
			if(obj.options[m].selected){
				obj.options[m] = null;
				}
			}	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocDiagnosSyndlink');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj
	if(selectrow!=selectedRow){
		selectedRow=selectrow
		var obj=document.getElementById("MRCICDDesc");
		if(obj){
			ClearAllList(obj);
			var ArrTxt= new Array(1);
			var ArrValue = new Array(1);

			///AddItemToList(obj,1,SelRowObj.value)
			var SelRowObj=document.getElementById('ICDDescz'+selectrow);
			obj.options[0] = new Option(SelRowObj.innerText,0);
			var SelRowObj=document.getElementById('ICDDrz'+selectrow);
			obj.options[0].value=SelRowObj.value;
		}
		var obj=document.getElementById("SyndSign");
		if(obj){
			ClearAllList(obj);
			var ArrTxt= new Array(1);
			var ArrValue = new Array(1);

			///AddItemToList(obj,1,SelRowObj.value)
			var SelRowObj=document.getElementById('SyndDescz'+selectrow);
			obj.options[0] = new Option(SelRowObj.innerText,0);
			var SelRowObj=document.getElementById('SyndRowidz'+selectrow);
			obj.options[0].value=SelRowObj.value;

		}
	}else{
		var obj=document.getElementById("MRCICDDesc");
		if(obj){
			ClearAllList(obj);
		}
		var obj=document.getElementById("SyndSign");
		if(obj){
			ClearAllList(obj);
		}
		selectedRow=0
	}
	
}

function List()
{
    
	if (window.event.keyCode==13) 
	{
	   window.event.keyCode=117; 
	   MRCICDLookup_lookuphandler();
	 }
}
function SyndList()
{
    
	if (window.event.keyCode==13) 
	{
	   window.event.keyCode=117; 
	   SyndSignLookup_lookuphandler();
	 }
}
function LinkSyndSignCreat()
{ 
	
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocDiagnosSignSymptom";
        var NewWin=open(lnk,"udhcopbillif","status=1,scrollbars=1,resizable=no,top=6,left=6,width=1000,height=680");
}	
document.body.onload = BodyLoadHandler;