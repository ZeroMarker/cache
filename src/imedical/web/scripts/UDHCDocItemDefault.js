/*
UDHCDocItemDefault.Js   guorongyong 2011.11.02
*/
var SelectedRow=0;
var LoopCount=0;
var BlankRow=1;
var frequenceCombo;
var InstrCombo;
var ItemDuratCombo;
document.body.onload = BodyLoadHandler;

var obj=document.getElementById('ItemDesc');
if (obj) obj.onkeydown=xItem_lookuphandler;

function BodyLoadHandler(){
    ResetButton(0);
 	SelectedRow=0
 	SetPAAdmTypeList()
 	var cobj=document.getElementById("ItemContralType");
	if (cobj) {
		Setmultiple(cobj)
		cobj.onchange=ItemContralTypeSelect;
	}
	var cobj=document.getElementById("ItemPriority");
	if (cobj) {
		Setmultiple(cobj)
		cobj.onchange=ItemPrioritySelect;
	}
	var cobj=document.getElementById("ItemDoseUom");
	if (cobj) {
		Setmultiple(cobj)
		cobj.onchange=ItemDoseUomSelect;
	}
	/*
	var cobj=document.getElementById("ItemInstr");
	if (cobj) {
		Setmultiple(cobj)
		cobj.onchange=ItemInstrSelect;
	}
	
	var cobj=document.getElementById("ItemPHFreq");
	if (cobj) {
		Setmultiple(cobj)
		cobj.onchange=ItemPHFreqSelect;
	}

	var cobj=document.getElementById("ItemDurat");
	if (cobj) {
		Setmultiple(cobj)
		cobj.onchange=ItemDuratSelect;
	}*/
		
	var cobj=document.getElementById("ItemSkinAction");
	if (cobj) {
		Setmultiple(cobj)
		cobj.onchange=ItemSkinActionSelect;
	}
	InitDoc();
	DisableAddButton(0);	    
}
function Setmultiple(obj){
	if (!obj) return;
	obj.multiple=false;
	obj.size=1
}
function InitDoc() {
	DHCWebD_ClearAllListA("ItemContralType");
	var encmeth=DHCWebD_GetObjValue("ReadItemContralType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ItemContralType");
	}
	
	DHCWebD_ClearAllListA("ItemPriority");
	var encmeth=DHCWebD_GetObjValue("ReadItemPriority");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ItemPriority");
	}
	
	DHCWebD_ClearAllListA("ItemDoseUom");
	var encmeth=DHCWebD_GetObjValue("ReadItemDoseUom");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ItemDoseUom");	
	}
	/*
	DHCWebD_ClearAllListA("ItemInstr");
	var encmeth=DHCWebD_GetObjValue("ReadItemInstr");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ItemInstr");	
	}
	
	/*
	DHCWebD_ClearAllListA("ItemPHFreq");
	var encmeth=DHCWebD_GetObjValue("ReadItemPHFreq");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ItemPHFreq");
	}
	*/
	if(InstrCombo) InstrCombo.clearAll();
	var encmeth=DHCWebD_GetObjValue("ReadItemInstr");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"");	
	}
	InstrCombo=dhtmlXComboFromStr("ItemInstr",rtn);
	InstrCombo.enableFilteringMode(true);
	InstrCombo.attachEvent("onSelectionChange", ItemInstrSelect); 
	if(frequenceCombo) frequenceCombo.clearAll();
    var ret=""  
	var GetFreq=document.getElementById("ReadItemPHFreq")
			if (GetFreq) {var encmeth=GetFreq.value} else {var encmeth=''};
			if (encmeth!="") {
				 ret=cspRunServerMethod(encmeth,'^N')
				
			}
    frequenceCombo=dhtmlXComboFromStr("ItemPHFreq",ret);
	frequenceCombo.enableFilteringMode(true);
	frequenceCombo.attachEvent("onSelectionChange", ItemPHFreqSelect); 
	
	if(ItemDuratCombo) ItemDuratCombo.clearAll();
    var ret=""  
	var GetReadItemDurat=document.getElementById("ReadItemDurat")
			if (GetReadItemDurat) {var encmeth=GetReadItemDurat.value} else {var encmeth=''};
			if (encmeth!="") {
				 ret=cspRunServerMethod(encmeth,'')
				
			}
    ItemDuratCombo=dhtmlXComboFromStr("ItemDurat",ret);
	ItemDuratCombo.enableFilteringMode(true);
	ItemDuratCombo.attachEvent("onSelectionChange", ItemDuratSelect); 
	
	/*
	DHCWebD_ClearAllListA("ItemDurat");
	var encmeth=DHCWebD_GetObjValue("ReadItemDurat");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ItemDurat");	
	}
	*/
	DHCWebD_ClearAllListA("ItemSkinAction");
	var encmeth=DHCWebD_GetObjValue("ReadItemSkinAction");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ItemSkinAction");	
	}
}

function AddTabRow(value) {
	try {
		//alert(value);
		if (value!=""){	
			var Split_Value=value.split("^")
			var objtbl=document.getElementById('tUDHCDocItemDefault');
      if (objtbl.rows.length==1) {
      	window.location.reload();
      	return websys_cancel();
      }else{
      	AddRowToList(objtbl);
      }
	 		var rows=objtbl.rows.length;
			var LastRow=rows - 1;
		  
		    var Row=GetRow(LastRow);
				var Split_Value=value.split("^")
            //ItemDesc+"^"+ItemContralType+"^"+ContralKey+"^"+OrderPriorRowid+"^"+ItemPriority+"^"+
            //OrderDoseQty+"^"+ItemDoseUom+"^"+OrderDoseUOMRowid+"^"+ItemInstr+"^"+OrderInstrRowid+"^"+
            //ItemPHFreq+"^"+OrderFreqRowid+"^"+ItemDurat+"^"+OrderDurRowid+"^"+OrderPackQty+"^"+
            //OrderSkinTest+"^"+ItemSkinAction+"^"+ItemSkinActionRowid
				SetCell("TabARCIMDR",Row,Split_Value[0]);
				SetCell("TabArcimDesc",Row,Split_Value[1]);
				SetCell("TabContralType",Row,Split_Value[2]);
				SetCell("TabContralKey",Row,Split_Value[3]);
				SetCell("TabPriorityDR",Row,Split_Value[4]);
				SetCell("TabPriority",Row,Split_Value[5]);
				SetCell("TabDose",Row,Split_Value[6]);
				SetCell("TabDoseUom",Row,Split_Value[7]);
				SetCell("TabDoseUomDR",Row,Split_Value[8]);
				SetCell("TabInstr",Row,Split_Value[9]);
				SetCell("TabInstrDR",Row,Split_Value[10]);
				SetCell("TabPHFreq",Row,Split_Value[11]);
				SetCell("TabPHFreqDR",Row,Split_Value[12]);
				SetCell("TabDurat",Row,Split_Value[13]);
				SetCell("TabDuratDR",Row,Split_Value[14]);
				SetCell("TabPackQty",Row,Split_Value[15]);
				//SetCell("TabSkinTest",Row,Split_Value[16]);
				var CellObj=document.getElementById("TabSkinTest"+"z"+Row);
				if (Split_Value[16]=="Y"){CellObj.checked=true}else {CellObj.checked=false}
				SetCell("TabSkinAction",Row,Split_Value[17]);
				SetCell("TabSkinActionDR",Row,Split_Value[18]);
				SetCell("TabContralTypeCode",Row,Split_Value[19]);
				SetCell("Rowid",Row,Split_Value[20]);
				
				
		}
		
	} catch(e) {alert(e.message)};
}

function DeleteTabRow(selectrow){
	var selectrow=GetRow(selectrow);
	var objtbl=document.getElementById('tUDHCDocItemDefault');
	var rows=objtbl.rows.length;
	if (rows>2){
		objtbl.deleteRow(selectrow);
	}else{
		var objlastrow=objtbl.rows[rows-1];
		var rowitems=objlastrow.all; //IE only
		if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split("z");
				arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
				rowitems[j].innerText="";
			}
		}
	 	LoopCount=0;
	 	ResetButton(0);
	}
}

function UpdateTabRow(value) {
	try {
		//alert(value);
		if (value!=""){	
			var objtbl=document.getElementById('tUDHCDocItemDefault');
	 		var rows=objtbl.rows.length;
			if (rows==1) return ;
			if (SelectedRow==0) return ;
            var Row=GetRow(SelectedRow);
			var Split_Value=value.split("^")
            //ItemDesc+"^"+ItemContralType+"^"+ContralKey+"^"+OrderPriorRowid+"^"+ItemPriority+"^"+
            //OrderDoseQty+"^"+ItemDoseUom+"^"+OrderDoseUOMRowid+"^"+ItemInstr+"^"+OrderInstrRowid+"^"+
            //ItemPHFreq+"^"+OrderFreqRowid+"^"+ItemDurat+"^"+OrderDurRowid+"^"+OrderPackQty+"^"+
            //OrderSkinTest+"^"+ItemSkinAction+"^"+ItemSkinActionRowid
			SetCell("TabArcimDesc",Row,Split_Value[0]);
			SetCell("TabContralType",Row,Split_Value[1]);
			if(Split_Value[1]=="保存到科室常用"){
				var LocDesc=tkMakeServerCall("web.DHCDocItemDefault","GetLocDesc",session['LOGON.CTLOCID'])
				SetCell("TabContralDesc",Row,LocDesc)
			}else{
				SetCell("TabContralDesc",Row,session['LOGON.USERNAME'])
			}
			SetCell("TabContralKey",Row,Split_Value[2]);
			SetCell("TabPriorityDR",Row,Split_Value[3]);
			SetCell("TabPriority",Row,Split_Value[4]);
			SetCell("TabDose",Row,Split_Value[5]);
			SetCell("TabDoseUom",Row,Split_Value[6]);
			SetCell("TabDoseUomDR",Row,Split_Value[7]);
			SetCell("TabInstr",Row,Split_Value[8]);
			SetCell("TabInstrDR",Row,Split_Value[9]);
			SetCell("TabPHFreq",Row,Split_Value[10]);
			SetCell("TabPHFreqDR",Row,Split_Value[11]);
			SetCell("TabDurat",Row,Split_Value[12]);
			SetCell("TabDuratDR",Row,Split_Value[13]);
			SetCell("TabPackQty",Row,Split_Value[14]);
			SetCell("TabSkinTest",Row,Split_Value[15]);
			SetCell("TabSkinAction",Row,Split_Value[16]);
			SetCell("TabSkinActionDR",Row,Split_Value[17]);
			SetCell("TPAAdmType",Row,Split_Value[18]);
			SetCell("TabLastUpdateDate",Row,Split_Value[19]);
			SetCell("TabLastUpdateTime",Row,Split_Value[20]);
			if (Split_Value[15]=="N") {
				var CellObj=document.getElementById("TabSkinTest"+"z"+Row);
				CellObj.checked=false
			}
		}
	} catch(e) {};
}

function SetCell(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				CellObj.checked=Val;
			}else{
				CellObj.value=Val;
			}
		}
	}
}
function GetCell(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){return CellObj.innerText;}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}

function AddRowToList(objtbl) {
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
			//rowitems[j].innerText="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}

function GetRow(Rowindex){
	var objtbl=document.getElementById('tUDHCDocItemDefault');
	var RowObj=objtbl.rows[Rowindex];
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("label");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tUDHCDocItemDefault');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	
	//alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	if (selectrow!=SelectedRow){
		Row=GetRow(selectrow);
		var TabArcimDesc=GetCell("TabArcimDesc",Row);
		if (TabArcimDesc=="") return;
		SetValue('ItemDesc',TabArcimDesc);
		var TabARCIMDR=GetCell("TabARCIMDR",Row);
		SetValue('ItemDescRowid',TabARCIMDR);
		
		var TabContralTypeCode=GetCell("TabContralTypeCode",Row)
		SetValue('ItemContralType',TabContralTypeCode);
		SetValue('ItemContralTypeID',TabContralTypeCode);
		var TabContralDesc=GetCell("TabContralDesc",Row)
		SetValue('ItemContralDesc',TabContralDesc);
		var TabPriorityDR=GetCell("TabPriorityDR",Row)
		SetValue('ItemPriority',TabPriorityDR);
		SetValue('ItemPriorityRowid',TabPriorityDR);

		var TabDose=GetCell("TabDose",Row)
		SetValue('ItemDose',TabDose);
		
		///刷新单次剂量单位
		SetDoseUOM(TabARCIMDR);
		var TabDoseUomDR=GetCell("TabDoseUomDR",Row)
		SetValue('ItemDoseUom',TabDoseUomDR);
		SetValue('ItemDoseUomRowid',TabDoseUomDR);
		
		var TabInstrDR=GetCell("TabInstrDR",Row)
		SetValue('ItemInstr',"");
		InstrCombo.setComboValue(TabInstrDR+"^");
		SetValue('ItemInstrRowid',TabInstrDR);
		
		var TabPHFreqDR=GetCell("TabPHFreqDR",Row)
		SetValue('ItemPHFreq',"");
		frequenceCombo.setComboValue(TabPHFreqDR+"^");
		SetValue('ItemPHFreqRowid',TabPHFreqDR);
		
		var TabDuratDR=GetCell("TabDuratDR",Row)
		SetValue('ItemDurat',""); 
		ItemDuratCombo.setComboValue(TabDuratDR+"^");
		SetValue('ItemDuratRowid',TabDuratDR);
		
		var TabPackQty=GetCell("TabPackQty",Row)
		SetValue('ItemPackQty',TabPackQty);
		
		var TabSkinTest=GetCell("TabSkinTest",Row)
		SetValue('ItemSkinTest',TabSkinTest);

		var TabSkinActionDR=GetCell("TabSkinActionDR",Row)
		SetValue('ItemSkinAction',TabSkinActionDR);
		SetValue('ItemSkinActionRowid',TabSkinActionDR);
		
		var TabRelevanceNo=GetCell("TabRelevanceNo",Row)
		SetValue('ItemRelevanceNo',TabRelevanceNo);
		var TPAAdmType=GetCell("TPAAdmType",Row)
		if (TPAAdmType=="住院") {var TPAAdmType="I"}
		if (TPAAdmType=="门诊") {var TPAAdmType="O"}
		if (TPAAdmType=="急诊") {var TPAAdmType="E"}
		SetValue('PAAdmType',TPAAdmType)
		
		SelectedRow = selectrow;
		ResetButton(1);
	}else{
		SelectedRow=0;
		ResetButton(0)
	}
}

function SetDoseUOMList(text,value){
	var obj=document.getElementById("ItemDoseUOM");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}

function SetDoseUOM(ARCIMRowid){
	var obj=document.getElementById("ItemDoseUOM");
	if (obj) {
		ClearAllList(obj);
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetDoseUOM")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			cspRunServerMethod(encmeth,'SetDoseUOMList',ARCIMRowid);
		}
	}
}
function ResetButton(ResetFlag){
	//alert(ResetFlag)
	if (ResetFlag==0){
		SetValue('ItemDesc','');
		SetValue('ItemDescRowid','');
		SetValue('ItemDose','');
		SetValue('ItemDoseUom','');
		SetValue('ItemDoseUomRowid','');
		SetValue('ItemDurat','');
		SetValue('ItemDuratRowid','');
		//
		SetValue('ItemInstr','');
		SetValue('ItemInstrRowid','');
		SetValue('ItemPackQty','');
		SetValue('ItemPHFreq','');
		SetValue('ItemPHFreqRowid','');
		SetValue('ItemPriority','');
		SetValue('ItemPriorityRowid','');
		SetValue('ItemRelevanceNo','');
		SetValue('ItemSkinAction','');
		SetValue('ItemSkinActionRowid','');
		SetValue('ItemSkinTest',false);
		SetValue('ItemActiveFlag','');
		SetValue('ItemContralDesc','');
		SetValue('ItemContralType','');
		SetValue('ItemContralTypeID','');
		
		
		DisableAddButton(0);
		DisableDeleteButton(1);
		DisableUpdateButton(1);
	}else{
		DisableAddButton(1);
		DisableDeleteButton(0);
		DisableUpdateButton(0);
	}
}
function DisableAddButton(Disable){
	//alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("Add");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=AddClickHandler;
	}
}
function DisableDeleteButton(Disable){
	//alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("Delete");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=DeleteClickHandler;
	}
}
function DisableUpdateButton(Disable){
	//alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("Update");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=UpdateClickHandler;
	}
}
function SetValue(name,value){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {
			obj.innerText=value;
		}else{
			if (obj.type=="checkbox") {
				obj.checked=value
			}else{
				obj.value=value
			}
		}
	}
}
function ItemQty_Keydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	var obj=document.getElementById("ItemQty");
	if ((keycode==13)||(keycode==9)) {websys_nextfocusElement(obj)}
	else {
		if ((keycode==8)||(keycode==46)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
			try {}
			catch(e) {}
		}else{
			return websys_cancel();
		}
	}
}

function ItemDoseQty_Keydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	var obj=document.getElementById("ItemDoseQty");
	if ((keycode==13)||(keycode==9)) {websys_nextfocusElement(obj)}
	else {
		if ((keycode==8)||(keycode==46)||(keycode==190)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
			try {}
			catch(e) {}
		}else{
			return websys_cancel();
		}
	}
}
function AddClickHandler(){
	var ItemDescRowid=DHCC_GetElementData("ItemDescRowid");
	if (ItemDescRowid=='') {
		alert(t['NoItem']);
		websys_setfocus('ItemDesc');
		return;
	}
	var ItemContralTypeID=DHCC_GetElementData("ItemContralTypeID");
	if (ItemContralTypeID=='') {
		alert(t['NoContralType']);
		websys_setfocus('ItemContralType');
		return;
	}
    
    var OrderARCIMRowid=ItemDescRowid
    var ContralKey="";
	var ContralType=DHCC_GetElementData("ItemContralTypeID");
	if (ContralType=="User") ContralKey=session["LOGON.USERID"];
	if (ContralType=="Location") ContralKey=session["LOGON.CTLOCID"];
	var OrderPriorRowid=DHCC_GetElementData("ItemPriorityRowid");
	var OrderDoseQty=DHCC_GetElementData("ItemDose");
	var OrderDoseUOMRowid=DHCC_GetElementData("ItemDoseUomRowid");
	var OrderInstrRowid=DHCC_GetElementData("ItemInstrRowid");
	var OrderFreqRowid=DHCC_GetElementData("ItemPHFreqRowid");
	var OrderDurRowid=DHCC_GetElementData("ItemDuratRowid");
	var OrderPackQty=DHCC_GetElementData("ItemPackQty");
	var OrderSkinTest=DHCC_GetElementData("ItemSkinTest");
	if (OrderSkinTest==true){OrderSkinTest="Y"}else{OrderSkinTest="N"}
	var PAAdmType=DHCC_GetElementData("PAAdmType");
	var OrderActionRowid=DHCC_GetElementData("ItemSkinActionRowid");
	//暂只能使用更新来维护成组医嘱
	var OrderMasterSeqNo="";
	var OrderSeqNo=1
	var Notes="";
	
	
	var ContralStr=OrderARCIMRowid+"^"+ContralType+"^"+ContralKey+"^"+OrderPriorRowid+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid;
	    ContralStr=ContralStr+"^"+OrderInstrRowid+"^"+OrderFreqRowid+"^"+OrderDurRowid+"^"+OrderPackQty+"^"+OrderSkinTest;
	    ContralStr=ContralStr+"^"+OrderActionRowid+"^"+OrderMasterSeqNo+"^"+OrderSeqNo+"^"+Notes+"^"+PAAdmType;
	var UserID=session["LOGON.USERID"];
	
	var InsertObj=document.getElementById("InsertMethod")
	if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	if (encmeth!="") {
		var ret=cspRunServerMethod(encmeth,ContralStr,UserID)
		var TempArr=ret.split("^");
		if (TempArr[0]=="0") {
			alert(t['InsertSeccess']);
			var ItemDesc=DHCC_GetElementData("ItemDesc");
			var ItemContralType=DHCC_GetListSelectedText("ItemContralType");
			var ItemPriority=DHCC_GetListSelectedText("ItemPriority");
			var ItemDose=DHCC_GetElementData("ItemDose");
			var ItemDoseUom=DHCC_GetListSelectedText("ItemDoseUom");
			//var ItemInstr=DHCC_GetListSelectedText("ItemInstr");
			var ItemInstr=InstrCombo.getSelectedText();
			//var ItemPHFreq=DHCC_GetListSelectedText("ItemPHFreq");
			var ItemPHFreq=frequenceCombo.getSelectedText();
			//var ItemDurat=DHCC_GetListSelectedText("ItemDurat");
			var ItemDurat=ItemDuratCombo.getSelectedText();
			var ItemSkinAction=DHCC_GetListSelectedText("ItemSkinAction");
			var ContralTypeCode=DHCC_GetElementData("ItemContralTypeID");

	    var valueStr=OrderARCIMRowid+"^"+ItemDesc+"^"+ItemContralType+"^"+ContralKey+"^"+OrderPriorRowid+"^"+ItemPriority+"^"+OrderDoseQty+"^"+ItemDoseUom+"^"+OrderDoseUOMRowid;
	    var valueStr=valueStr+"^"+ItemInstr+"^"+OrderInstrRowid+"^"+ItemPHFreq+"^"+OrderFreqRowid+"^"+ItemDurat+"^"+OrderDurRowid+"^"+OrderPackQty+"^"+OrderSkinTest+"^"+ItemSkinAction+"^"+OrderActionRowid
	    var valueStr=valueStr+"^"+ContralTypeCode+"^"+TempArr[1]
			AddTabRow(valueStr);
			ResetButton(0);
		
			return;
		}else{
			if (TempArr[0]=="-100"){
				alert(t['NoItem']);
				return;
			}else if (TempArr[0]=="-101"){
				alert(t['ItemRepeat']);
				return;
			}else{
				alert(t['InsertFail']);
				return;
			}
		}
		
	}
}

function DeleteClickHandler(){
	var Row=GetRow(SelectedRow);
	var Rowid=GetCell("Rowid",Row)
	if (Rowid=="") {
		alert(t['NoRowid']);
		return;
	}
	var DeleteObj=document.getElementById("DeleteMethod")
	if (DeleteObj) {var encmeth=DeleteObj.value} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,Rowid)!='0') {
			alert(t['DeleteErr']);
		}else{
			//DeleteRow(SelectedRow);
			SelectedRow=0;
			ResetButton(0);
			window.treload('websys.csp');
		}
	}
}
function UpdateClickHandler(){
	var ItemDescRowid=DHCC_GetElementData("ItemDescRowid");
	if (ItemDescRowid=='') {
		alert(t['NoItem']);
		websys_setfocus('ItemDesc');
		return;
	}
	var ItemContralTypeID=DHCC_GetElementData("ItemContralTypeID");
	if (ItemContralTypeID=='') {
		alert(t['NoContralType']);
		websys_setfocus('ItemContralType');
		return;
	}
	var Row=GetRow(SelectedRow);
	var Rowid=GetCell("Rowid",Row);
	
	var OrderARCIMRowid=ItemDescRowid
    var ContralKey="";
	var ContralType=DHCC_GetElementData("ItemContralTypeID");
	if (ContralType=="User") ContralKey=session["LOGON.USERID"];
	if (ContralType=="Location") ContralKey=session["LOGON.CTLOCID"];
	var OrderPriorRowid=DHCC_GetElementData("ItemPriorityRowid");
	var OrderDoseQty=DHCC_GetElementData("ItemDose");
	var OrderDoseUOMRowid=DHCC_GetElementData("ItemDoseUomRowid");
	var OrderInstrRowid=DHCC_GetElementData("ItemInstrRowid");
	var OrderFreqRowid=DHCC_GetElementData("ItemPHFreqRowid");
	var OrderDurRowid=DHCC_GetElementData("ItemDuratRowid");
	var OrderPackQty=DHCC_GetElementData("ItemPackQty");
	var OrderSkinTest=DHCC_GetElementData("ItemSkinTest");
	if (OrderSkinTest==true){OrderSkinTest="Y"}else{OrderSkinTest="N"}
	var OrderActionRowid=DHCC_GetElementData("ItemSkinActionRowid");
	var PAAdmType=DHCC_GetElementData("PAAdmType");
	//暂只能使用更新来维护成组医嘱
	var OrderMasterSeqNo="";
	var OrderSeqNo=1
	var Notes="";
	

	var ContralStr=OrderARCIMRowid+"^"+ContralType+"^"+ContralKey+"^"+OrderPriorRowid+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid;
	    ContralStr=ContralStr+"^"+OrderInstrRowid+"^"+OrderFreqRowid+"^"+OrderDurRowid+"^"+OrderPackQty+"^"+OrderSkinTest;
	    ContralStr=ContralStr+"^"+OrderActionRowid+"^"+OrderMasterSeqNo+"^"+OrderSeqNo+"^"+Notes+"^"+PAAdmType;
	var UserID=session["LOGON.USERID"];
	var UpdateObj=document.getElementById("UpdateMethod")
	if (UpdateObj) {var encmeth=UpdateObj.value} else {var encmeth=''};
	if (encmeth!="") {
		var Err=cspRunServerMethod(encmeth,ContralStr,UserID,Rowid)
		if (Err!='0') {
			alert(t['UpdateErr']);
			return;
		}
		
        var ItemDesc=DHCC_GetElementData("ItemDesc");
		var ItemContralType=DHCC_GetListSelectedText("ItemContralType");
		var ItemPriority=DHCC_GetListSelectedText("ItemPriority");
		var ItemDose=DHCC_GetElementData("ItemDose");
		var ItemDoseUom=DHCC_GetListSelectedText("ItemDoseUom");
		//var ItemInstr=DHCC_GetListSelectedText("ItemInstr");
		var ItemInstr=InstrCombo.getSelectedText();
		if(OrderInstrRowid=="") ItemInstr=""
		//var ItemPHFreq=DHCC_GetListSelectedText("ItemPHFreq");
		var ItemPHFreq=frequenceCombo.getSelectedText();
		if(OrderFreqRowid=="") ItemPHFreq=""
		//var ItemDurat=DHCC_GetListSelectedText("ItemDurat");
		var ItemDurat=ItemDuratCombo.getSelectedText();
		if(OrderDurRowid=="") ItemDurat=""
		var ItemSkinAction=DHCC_GetListSelectedText("ItemSkinAction");
		var PAAdmType=DHCC_GetListSelectedText("PAAdmType");
        var valueStr=ItemDesc+"^"+ItemContralType+"^"+ContralKey+"^"+OrderPriorRowid+"^"+ItemPriority+"^"+OrderDoseQty+"^"+ItemDoseUom+"^"+OrderDoseUOMRowid;
        var valueStr=valueStr+"^"+ItemInstr+"^"+OrderInstrRowid+"^"+ItemPHFreq+"^"+OrderFreqRowid+"^"+ItemDurat+"^"+OrderDurRowid+"^"+OrderPackQty+"^"+OrderSkinTest+"^"+ItemSkinAction+"^"+OrderActionRowid+"^"+PAAdmType
		var LastUpdateInfo=tkMakeServerCall("web.DHCDocItemDefault","GetLastUpdateInfo",Rowid)
		var valueStr=valueStr+"^"+LastUpdateInfo;
		UpdateTabRow(valueStr);
		
	}
}
function OrderItemLookupSelect(txt) { 
    //passed in from the component manager.
	//Add an item to lstOrders when an item is selected from
	//the Lookup, then clears the Item text field.
	//alert(txt);
	var adata=txt.split("^");
	var idesc=adata[0];
	var icode=adata[1];
	var ifreq=adata[2];
	//ARCIM,ARCOS
	var iordertype=adata[3];
	var ialias=adata[4];
	//Ordertype example"R"
	var isubcatcode=adata[5];
	//alert("isubcatcode "+isubcatcode)
	var iorderCatID=adata[6];
	var iSetID=adata[7];
	var mes=adata[8];
	var irangefrom=adata[9];
	var irangeto=adata[10]
	var iuom=adata[11];
	var idur=adata[12];
	var igeneric=adata[13];
	var match="notfound";
	var SetRef=1;
	var OSItemIDs=adata[15];
	var iorderSubCatID=adata[16];
	var ibilluom=adata[19]
	//alert(mPiece(OSItemIDs,String.fromCharCode(12),1));
	window.focus();
    if (iordertype=="ARCOS") return;

	if (iordertype=="ARCIM") iSetID="";

	SetValue('ItemDesc','');
	SetValue('ItemQty','');
	SetValue('ItemBillUOM','');
	SetValue('ItemDoseQty','');
	SetValue('ItemFrequence','');
	SetValue('ItemDuration','');
	SetValue('ItemInstruction','');
	
	
	
	var obj=document.getElementById("ItemDoseUOM");
	if (obj) {
		ClearAllList(obj);
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option("","");
	}

	var GetARCIMDetail=document.getElementById("GetArcimDetail")
	if (GetARCIMDetail) {var encmeth=GetARCIMDetail.value} else {var encmeth=''};
	if (encmeth!="") {
		//alert(ARCOSItemRowid+"^"+ARCIMRowid+"^"+ItemQty+"^"+ItemDoseQty+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID);
		var ret=cspRunServerMethod(encmeth,icode);
		
		var idesc=mPiece(ret,"^",0);
		var OrderType=mPiece(ret,"^",1);
		var ipackqtystr=mPiece(ret,"^",5);
		var iformstr=mPiece(ret,"^",6);
		var idoseqtystr=mPiece(ret,"^",7);
		var ifrequencestr=mPiece(ret,"^",8);
		var iinstructionstr=mPiece(ret,"^",9);
		var idurationstr=mPiece(ret,"^",10);
		
		var OrderPackQty=mPiece(ipackqtystr,String.fromCharCode(1),0);
		var OrderPackUOM=mPiece(ipackqtystr,String.fromCharCode(1),1);
		var OrderPackUOMRowid=mPiece(ipackqtystr,String.fromCharCode(1),2);
		var OrderFreq=mPiece(ifrequencestr,String.fromCharCode(1),0);
		var OrderFreqRowid=mPiece(ifrequencestr,String.fromCharCode(1),1);
		var OrderFreqFactor=mPiece(ifrequencestr,String.fromCharCode(1),2);
		var OrderFreqInterval=mPiece(ifrequencestr,String.fromCharCode(1),3);
		var OrderInstr=mPiece(iinstructionstr,String.fromCharCode(1),0);
		var OrderInstrRowid=mPiece(iinstructionstr,String.fromCharCode(1),1);
		var OrderDur=mPiece(idurationstr,String.fromCharCode(1),0);
		var OrderDurRowid=mPiece(idurationstr,String.fromCharCode(1),1);
		var OrderDurFactor=mPiece(idurationstr,String.fromCharCode(1),2); 
		
		var DefaultDoseUOMRowid="";
		var DefaultDoseQty="";
		if (idoseqtystr!=""){
			var ArrData=idoseqtystr.split(String.fromCharCode(2));
			for (var i=0;i<ArrData.length;i++) {
				 var ArrData1=ArrData[i].split(String.fromCharCode(1));
				 obj.options[obj.length] = new Option(ArrData1[1],ArrData1[2]);
				 if (i==0) {
				 	var DefaultDoseQty=ArrData1[0];
				 	var DefaultDoseQtyUOM=RowidData=ArrData1[1];
				 	var DefaultDoseUOMRowid=RowidData=ArrData1[2];
				}
			}
		}
	}
    
	  SetValue('ItemDesc',idesc);
    SetValue('ItemDescRowid',icode);
    SetValue('ItemBillUOM',ibilluom);
    
    if (DefaultDoseQty!="") SetValue('ItemDoseQty',DefaultDoseQty);
    if (OrderFreqRowid!="") SetValue('ItemFrequence',OrderFreqRowid);
    if (OrderInstrRowid!="") SetValue('ItemInstruction',OrderInstrRowid);
    if (OrderDurRowid!="") SetValue('ItemDuration',OrderDurRowid);
    
   
	
	if (icode!=""){SetDoseUOM(icode);}
    if (DefaultDoseUOMRowid!="") SetValue('ItemDoseUOM',DefaultDoseUOMRowid);
    if (isubcatcode=="R"){
    	websys_setfocus("ItemDoseQty");
    }else{
	    websys_setfocus("ItemQty");
    }
}

function xItem_lookuphandler(e) {
	if (evtName=='ItemDesc') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
        
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url='websys.lookup.csp';
		url += "?ID=ItemDesc";
		//url += "&CONTEXT=Kweb.OEOrdItem:LookUpItm";
		//url += "&CONTEXT=Kweb.DHCDocOrderEntry:LookUpItem";
		url += "&CONTEXT=Kweb.DHCUserFavItems:LookUpItem";
		url += "&TLUJSF=OrderItemLookupSelect";
		var obj=document.getElementById('ItemDesc');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

function ItemContralTypeSelect(){
	var ItemContralTypeID=DHCC_GetListSelectedValue("ItemContralType");
	DHCC_SetElementData("ItemContralTypeID",ItemContralTypeID);
}
function ItemPrioritySelect(){
	var ItemPriorityRowid=DHCC_GetListSelectedValue("ItemPriority");
	DHCC_SetElementData("ItemPriorityRowid",ItemPriorityRowid);
}
function ItemDoseUomSelect(){
	var ItemDoseUomRowid=DHCC_GetListSelectedValue("ItemDoseUom");
	DHCC_SetElementData("ItemDoseUomRowid",ItemDoseUomRowid);
}
function ItemInstrSelect(){
	//var ItemInstrRowid=DHCC_GetListSelectedValue("ItemInstr");
	var ItemInstrRowid=InstrCombo.getSelectedValue();
	DHCC_SetElementData("ItemInstrRowid",ItemInstrRowid);
}
function ItemPHFreqSelect(){
	//var ItemPHFreqRowid=DHCC_GetListSelectedValue("ItemPHFreq");
	var ItemPHFreqRowid=frequenceCombo.getSelectedValue();
	DHCC_SetElementData("ItemPHFreqRowid",ItemPHFreqRowid);
}
function ItemDuratSelect(){
	//var ItemDuratRowid=DHCC_GetListSelectedValue("ItemDurat");
	var ItemDuratRowid=ItemDuratCombo.getSelectedValue();
	DHCC_SetElementData("ItemDuratRowid",ItemDuratRowid);
}
function ItemSkinActionSelect(){
	var ItemSkinActionRowid=DHCC_GetListSelectedValue("ItemSkinAction");
	DHCC_SetElementData("ItemSkinActionRowid",ItemSkinActionRowid);
}
function SetPAAdmTypeList(){
	var obj=document.getElementById("PAAdmType");
	if (obj){
		
		obj.options[0] = new Option("","");
		obj.options[1] = new Option("门诊","O")
		obj.options[2] = new Option("住院","I")
		obj.options[3] = new Option("急诊","E")
		obj.size=1;
		obj.multiple=false;
	}
}
