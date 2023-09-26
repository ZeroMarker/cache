/*
UDHCARCOrderSetItem.Edit.Js   zhouzq 2005.11.13
	dhc.ssuser.log.csp
	dhc.logon.csp
*/
var SelectedRow=0;
var LoopCount=0;
var BlankRow=1;
document.body.onload = BodyLoadHandler;
var ExtTop=top.Ext;
var frequenceCombo;
var ItemInstrCombo;
var remarkCombo;
var OrderPriorRemarksCombo;
var obj=document.getElementById('ItemDesc');
if (obj) obj.onkeydown=xItem_lookuphandler;

function ItemUpClickHandler() {
	if (SelectedRow==0) {
		alert("请选择行");
		return;
	}
	if ((SelectedRow-1)<=0) {
		alert("第一行不能上移");
		return;
	}
	var TblObj=document.getElementById("tUDHCARCOrderSetItem_Edit");
	var RowObj=TblObj.rows[SelectedRow];
	
	var trArr = TblObj.getElementsByTagName("tr");
	var tr1 = trArr[SelectedRow];
	var tr2 = trArr[SelectedRow - 1];

	//使用javascript写好的交换方法
	//tr1.swapNode(tr2);

	var cloneTr = tr1.cloneNode(true);
	cloneTr.className="";
	
	//交换位置,交换会失败,替换后,会少一行
	tr2.parentNode.replaceChild(cloneTr, tr2);
	tr1.parentNode.replaceChild(tr2, tr1);
	
	//序号不交换
	var tr1Row=GetRow(SelectedRow);
	var tr2Row=GetRow(SelectedRow-1);
	
	var tr1NOObj=document.getElementById("NOz"+tr1Row);
	var tr2NOObj=document.getElementById("NOz"+tr2Row);
	if (tr1NOObj && tr2NOObj) {
		var temp=tr1NOObj.innerText;
		tr1NOObj.innerText=tr2NOObj.innerText;
		tr2NOObj.innerText=temp;
		
		//同时更新两行记录的序号
		var UpdateItemSerialNo=document.getElementById("UpdateItemSerialNo")
		if (UpdateItemSerialNo) {var encmeth=UpdateItemSerialNo.value} else {var encmeth=''};
		if (encmeth!="") {
			var tr1ItemObj=document.getElementById('ARCOSItemRowidz'+tr1Row);
			if (tr1ItemObj) {
				var ret=cspRunServerMethod(encmeth,tr1ItemObj.value,tr1NOObj.innerText);
				if (ret!="0") {
					alert("更新序号为"+tr1NOObj.innerText+"的行失败.");
				}
			}
			var tr2ItemObj=document.getElementById('ARCOSItemRowidz'+tr2Row);
			if (tr2ItemObj) {
				var ret=cspRunServerMethod(encmeth,tr2ItemObj.value,tr2NOObj.innerText);
				if (ret!="0") {
					alert("更新序号为"+tr2NOObj.innerText+"的行失败.");
				}
			}
		}
	}
	
	//默认选中移动到的行
	TblObj.focus();
	HighlightRow_OnLoad("ARCIMDescz"+tr2Row);
	//tr2.className="clsRowSelected";
	//tr2.click();
}
function ItemDownClickHandler() {
	var TblObj=document.getElementById("tUDHCARCOrderSetItem_Edit");
	var rows=TblObj.rows.length;
	if (SelectedRow==0) {
		alert("请选择行");
		return;
	}
	if ((SelectedRow+1)>=rows) {
		alert("最后一行不能下移");
		return;
	}
	
	var RowObj=TblObj.rows[SelectedRow];
	
	var trArr = TblObj.getElementsByTagName("tr");
	var tr1 = trArr[SelectedRow];
	var tr2 = trArr[SelectedRow + 1];

	//使用javascript写好的交换方法
	//tr1.swapNode(tr2);

	var cloneTr = tr1.cloneNode(true);
	cloneTr.className="";
	
	//交换位置,交换会失败,替换后,会少一行
	tr2.parentNode.replaceChild(cloneTr, tr2);
	tr1.parentNode.replaceChild(tr2, tr1);
	
	//序号不交换
	var tr1Row=GetRow(SelectedRow);
	var tr2Row=GetRow(SelectedRow+1);
	
	var tr1NOObj=document.getElementById("NOz"+tr1Row);
	var tr2NOObj=document.getElementById("NOz"+tr2Row);
	if (tr1NOObj && tr2NOObj) {
		var temp=tr1NOObj.innerText;
		tr1NOObj.innerText=tr2NOObj.innerText;
		tr2NOObj.innerText=temp;
		
		//同时更新两行记录的序号
		var UpdateItemSerialNo=document.getElementById("UpdateItemSerialNo")
		if (UpdateItemSerialNo) {var encmeth=UpdateItemSerialNo.value} else {var encmeth=''};
		if (encmeth!="") {
			var tr1ItemObj=document.getElementById('ARCOSItemRowidz'+tr1Row);
			if (tr1ItemObj) {
				var ret=cspRunServerMethod(encmeth,tr1ItemObj.value,tr1NOObj.innerText);
				if (ret!="0") {
					alert("更新序号为"+tr1NOObj.innerText+"的行失败.");
				}
			}
			var tr2ItemObj=document.getElementById('ARCOSItemRowidz'+tr2Row);
			if (tr2ItemObj) {
				var ret=cspRunServerMethod(encmeth,tr2ItemObj.value,tr2NOObj.innerText);
				if (ret!="0") {
					alert("更新序号为"+tr2NOObj.innerText+"的行失败.");
				}
			}
		}
	}
	
	TblObj.focus();
	HighlightRow_OnLoad("ARCIMDescz"+tr2Row);
}

function BodyLoadHandler(){
	var obj=document.getElementById("ItemUp");
	if (obj) obj.onclick=ItemUpClickHandler;
	var obj=document.getElementById("ItemDown");
	if (obj) obj.onclick=ItemDownClickHandler;
	
     var closeObj=document.getElementById("Exit")
	 if ((closeObj) && (window.opener))
	 {
 
		 closeObj.onclick=function ()
		 {
			 window.close();
		 }
	 }
	else
	{
		closeObj.disabled=true;
		closeObj.onclick=function() 
		{
			return false;}
	}
 	var obj=document.getElementById("ARCOSRowid");
	if (obj) var ARCOSRowid=obj.value;
    var sampleTypeobj=document.getElementById("sampleType");
	if (sampleTypeobj){
	    sampleTypeobj.multiple=false;
		sampleTypeobj.size=1;
	}
	
	//----------------------------------------------ItemInstruction  lxz-------屏蔽
	/*
	var ret=""  
	var GetPrescList=document.getElementById("GetFrequence")
			if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
			if (encmeth!="") {
				 ret=cspRunServerMethod(encmeth,'')
				
			}
    frequenceCombo=dhtmlXComboFromStr("ItemFrequence",ret);
	frequenceCombo.enableFilteringMode(true);
	frequenceCombo.attachEvent("onSelectionChange", FrequenceKeydownhandler); 
	//ItemInstruction
	var ret=""  
	var GetItemInst=document.getElementById("GetInstruction")
			if (GetPrescList) {var encmeth=GetItemInst.value} else {var encmeth=''};
			if (encmeth!="") {
				 ret=cspRunServerMethod(encmeth,'')
				
			}
    ItemInstrCombo=dhtmlXComboFromStr("ItemInstruction",ret);
	ItemInstrCombo.enableFilteringMode(true);
	*/
	//-------------------------------------------------------lxz
	//frequenceCombo.attachEvent("onSelectionChange", FrequenceKeydownhandler); 
		
   
	

	//frequenceCombo.selectHandle=FrequenceKeydownhandler;
	//frequenceCombo.attachEvent("onSelectionChange", FrequenceKeydownhandler); 
	
	DisableAddButton(1)
	DisableDeleteButton(1);
    DisableUpdateButton(1);
	DisableInsertButton(1);
	if (ARCOSRowid!=''){
		
	FindData();
	/*
    var cobj=document.getElementById("ItemFrequence");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1;
		var NewIndex=cobj.length;
		cobj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetFrequence")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetFrequenceList')!='0') {
			}
		}
		cobj.onchange=ItemFrequenceClickHandler
	}
	*/
	//-----------------lxz   草药事件
	var obj=document.getElementById("ChoseType");
	if (obj) {
		obj.onclick=ChangeChoseType;
		var CheckGet=ChoseTypeValueSet();
		if (CheckGet=="Y"){obj.checked=true}
	}
	ChoseTypeChange();
	//-----------------lxz	
	var cobj=document.getElementById("ItemDuration");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1
		var NewIndex=cobj.length;
		cobj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("ReadItemDurationNew")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			//lxz  -------加入草药设置
			var obj=document.getElementById("ChoseType");
			if (obj){if (obj.checked){if (cspRunServerMethod(encmeth,'SetDurationList',"^Clear")!='0') {}}else{if (cspRunServerMethod(encmeth,'SetDurationList',"^N")!='0') {}}}
			else{if (cspRunServerMethod(encmeth,'SetDurationList',"")!='0') {}}
		}
	}
	/*
	var cobj=document.getElementById("ItemInstruction");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1
		var NewIndex=cobj.length;
		cobj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetInstruction")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetInstructionList')!='0') {
			}
		}
	}
	*/
	//加入医嘱类型的描述说明
	var cobj=document.getElementById("DHCDocOrderType");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1
		var NewIndex=cobj.length;
		cobj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetDHCDocOrderType")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetDHCDocOrderType')!='0') {
			}
		}
	}
	var cobj=document.getElementById("ItemDoseUOM");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1
	}
	

	
	var cobj=document.getElementById("ItemQty");
	if (cobj) {
		cobj.onkeydown=ItemQty_Keydownhandler;
	}

	var cobj=document.getElementById("ItemDoseQty");
	if (cobj) {
		cobj.onkeydown=ItemDoseQty_Keydownhandler;
	}

	var cobj=document.getElementById("ItemDoseUOM");
	if (cobj) {
		cobj.onkeydown=ItemDoseUOM_Keydownhandler;
	}

	var obj=document.getElementById("Add");
	if (obj) obj.onclick=AddClickHandler;
	
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClickHandler;
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById("Insert");
	if (obj) obj.onclick=InsertClickHandler;
	
	ResetButton(0);
 	SelectedRow=0;
	
	GetOrdActiveFlag=document.getElementById("GetOrdActiveFlag");
	if (GetOrdActiveFlag) {var encmeth=GetOrdActiveFlag.value} else {var encmeth=''};
		
    var eTABLE=document.getElementById("tUDHCARCOrderSetItem_Edit");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var RowObj=eTABLE.rows[i];
			//Row=GetRow(selectrow);
		    var ARCIMRowid=document.getElementById('ARCIMRowidz'+i);
          if (encmeth!="") {
			var ret=cspRunServerMethod(encmeth,ARCIMRowid.value) 
			if (ret==1)
			RowObj.className="Yellow";
		 }		
		}
	}
	
	
	}
    else{
		DisableAddButton(1);
		var odObj=document.getElementById("ItemFrequence");		 
	    if (odObj){
		    odObj.disabled=true;odObj.innertext="";
		   // odObj.style.height="22px"
		    };
		   try{
		frequenceCombo.disable(true)
		ItemInstrCombo.disable(true);}
		catch(e){}
	    var odObj=document.getElementById("ItemDuration");	    
	    if (odObj){
		    odObj.disabled=true;odObj.innertext="";
		    //odObj.style.height="22px"
		    };
		var odObj=document.getElementById("ItemDesc");
	    if (odObj){odObj.disabled=true;odObj.innertext="";};
	    var odObj=document.getElementById("ItemQty");
	    if (odObj){odObj.disabled=true;odObj.innertext="";};
	    var odObj=document.getElementById("ItemDoseQty");
	    if (odObj){odObj.disabled=true;odObj.innertext="";};
	    var odObj=document.getElementById("ItemDoseUOM");
	    if (odObj){
		    odObj.disabled=true;odObj.innertext="";
		   // odObj.style.height="22px"
		    };
	    var odObj=document.getElementById("ItemInstruction");
	    if (odObj){
		    odObj.disabled=true;odObj.innertext="";
		    //odObj.style.height="22px"
		    };
	     var odObj=document.getElementById("ItemBillUOM");
	    if (odObj){odObj.disabled=true;odObj.innertext="";};
	    var odObj=document.getElementById("ItmLinkDoctor");
	    if (odObj){odObj.disabled=true;odObj.innertext="";};
	    var odObj=document.getElementById("remark");
	    if (odObj){odObj.disabled=true;odObj.innertext="";};
	    var odObj=document.getElementById("DHCDocOrderType");
	    if (odObj){
		    odObj.disabled=true;odObj.innertext="";
		    odObj.style.height="22px"
		    //alert(odObj.style.heigth);
		    };
	    return ;
    }
	
	websys_setfocus("ItemDesc");
}

function FindData() {
	//alert(EpisodeID+"^"+PrescNo);
	var obj=document.getElementById('ARCOSRowid');
	if (obj) var ARCOSRowid=obj.value;
	var GetPrescItems=document.getElementById('FindData');
	if (GetPrescItems) {var encmeth=GetPrescItems.value;} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,'AddTabRow',ARCOSRowid)=='0') {
			obj.className='';
		}
	}
}

function AddTabRow(value) {
	try {
		if (value!=""){	
			var Split_Value=value.split("^")

			var objtbl=document.getElementById('tUDHCARCOrderSetItem_Edit');
	        if (LoopCount!=0) AddRowToList(objtbl);
	        LoopCount=LoopCount+1;
	 		var rows=objtbl.rows.length;
			var LastRow=rows - 1;
	        
	        var Row=GetRow(LastRow);
	        //alert(Row);
			var Split_Value=value.split("^")
             //ARCIMDesc:ARCOSItemQty:ARCOSItemDoseQty:ARCOSItemUOM:ARCOSItemFrequence:
             //ARCOSItemDuration:ARCOSItemInstruction:ARCOSItemRowid:ARCIMRowid:
             //ARCOSItemUOMDR:ARCOSItemFrequenceDR:ARCOSItemDurationDR:ARCOSItemInstructionDR:	        var Tbl_FavRowid=document.getElementById("FavRowidz"+Row);
	        SetCell("ARCIMDesc",Row,Split_Value[0]);
			SetCell("ARCOSItemQty",Row,Split_Value[1]);
	    	SetCell("ARCOSItemBillUOM",Row,Split_Value[2]);
	    	SetCell("ARCOSItemDoseQty",Row,Split_Value[3]);
	    	SetCell("ARCOSItemUOM",Row,Split_Value[4]);
	    	SetCell("ARCOSItemFrequence",Row,Split_Value[5]);
	        SetCell("ARCOSItemDuration",Row,Split_Value[6]);
			SetCell("ARCOSItemInstruction",Row,Split_Value[7]);
	    	SetCell("ARCOSItemRowid",Row,Split_Value[8]);
	    	SetCell("ARCIMRowid",Row,Split_Value[9]);
	    	SetCell("ARCOSItemUOMDR",Row,Split_Value[10]);
	    	SetCell("ARCOSItemFrequenceDR",Row,Split_Value[11]);
	    	SetCell("ARCOSItemDurationDR",Row,Split_Value[12]);
	    	SetCell("ARCOSItemInstructionDR",Row,Split_Value[13]);
	    	SetCell("ARCOSItmLinkDoctor",Row,Split_Value[17]);
	    	SetCell("Tremark",Row,Split_Value[18]);
	    	SetCell("ARCOSDHCDocOrderType",Row,Split_Value[19]);
	    	SetCell("ARCOSDHCDocOrderTypeDR",Row,Split_Value[20]);
			SetCell("sample",Row,Split_Value[(Split_Value.length-5)]);
			SetCell("SampleID",Row,Split_Value[(Split_Value.length-6)]);
			SetCell("ARCOSItemNO",Row,Split_Value[(Split_Value.length-4)]);
			SetCell("NO",Row,Split_Value[(Split_Value.length-3)]);
			// 加入附加说明
			SetCell("OrderPriorRemarksDR",Row,Split_Value[(Split_Value.length-2)]);
			SetCell("OrderPriorRemarks",Row,Split_Value[(Split_Value.length-1)]);
			
		}
		
	} catch(e) {};
}

function DeleteTabRow(selectrow){
	var objtbl=document.getElementById('tUDHCARCOrderSetItem_Edit');
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
			var objtbl=document.getElementById('tUDHCARCOrderSetItem_Edit');
	 		var rows=objtbl.rows.length;
			if (rows==1) return ;
			if (SelectedRow==0) return ;
            var Row=GetRow(SelectedRow);
			var Split_Value=value.split("^")
             //ARCIMDesc:ARCOSItemQty:ARCOSItemDoseQty:ARCOSItemUOM:ARCOSItemFrequence:
             //ARCOSItemDuration:ARCOSItemInstruction:ARCOSItemRowid:ARCIMRowid:
             //ARCOSItemUOMDR:ARCOSItemFrequenceDR:ARCOSItemDurationDR:ARCOSItemInstructionDR:	       
             // var Tbl_FavRowid=document.getElementById("FavRowidz"+Row);
	        SetCell("ARCIMDesc",Row,Split_Value[0]);
			SetCell("ARCOSItemQty",Row,Split_Value[1]);
	    	SetCell("ARCOSItemBillUOM",Row,Split_Value[2]);
	    	SetCell("ARCOSItemDoseQty",Row,Split_Value[3]);
	    	SetCell("ARCOSItemUOM",Row,Split_Value[4]);
	    	SetCell("ARCOSItemFrequence",Row,Split_Value[5]);
	        SetCell("ARCOSItemDuration",Row,Split_Value[6]);
			SetCell("ARCOSItemInstruction",Row,Split_Value[7]);
	    	SetCell("ARCOSItemRowid",Row,Split_Value[8]);
	    	SetCell("ARCIMRowid",Row,Split_Value[9]);
	    	SetCell("ARCOSItemUOMDR",Row,Split_Value[10]);
	    	SetCell("ARCOSItemFrequenceDR",Row,Split_Value[11]);
	    	SetCell("ARCOSItemDurationDR",Row,Split_Value[12]);
	    	SetCell("ARCOSItemInstructionDR",Row,Split_Value[13]);
	    	SetCell("ARCOSItmLinkDoctor",Row,Split_Value[14]);
	    	SetCell("Tremark",Row,Split_Value[15]);
	    	SetCell("ARCOSDHCDocOrderType",Row,Split_Value[16]);
	    	SetCell("ARCOSDHCDocOrderTypeDR",Row,Split_Value[17]);
			SetCell("sample",Row,Split_Value[(Split_Value.length-3)]);
			SetCell("SampleID",Row,Split_Value[(Split_Value.length-4)]);
			//加入附加说明
			SetCell("OrderPriorRemarksDR",Row,Split_Value[(Split_Value.length-2)]);
			SetCell("OrderPriorRemarks",Row,Split_Value[(Split_Value.length-1)]);
	    
	    	
	    	
	    	
		}
	} catch(e) {};
}

function SetCell(ColName,Row,value){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj.tagName=='LABEL'){CellObj.innerText=value}else{CellObj.value=value}
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
	var objtbl=document.getElementById('tUDHCARCOrderSetItem_Edit');
	var RowObj=objtbl.rows[Rowindex];
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("*");
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
	var objtbl=document.getElementById('tUDHCARCOrderSetItem_Edit');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	
	//alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	if (selectrow!=SelectedRow){
		Row=GetRow(selectrow);
		var obj=document.getElementById('ARCIMDescz'+Row);
		if ((obj.innerText=='')||(obj.innerText==' ')){
		   ResetButton(1);
		   DisableDeleteButton(1);
		   DisableUpdateButton(1);
		   DisableInsertButton(1);
        		return;
		}
		
	var getSample=document.getElementById("GetSample");
	var encmeth=getSample?getSample.value:"";
	var icode=document.getElementById('ARCIMRowidz'+Row).value;
	var getSampleResult=cspRunServerMethod(encmeth,icode);
	var ret=getSampleResult;
	var sampleType=document.getElementById("sampleType");
	ClearAllList(sampleType);
	//有标本
	if (ret!=""){
	   if (sampleType.disabled=="true")
	   sampleType.disabled=false;
	   sampleType.add(new Option("",""));
	   var sampleMessage=ret.split(String.fromCharCode(2));	  
	   for(var i=0;i<sampleMessage.length;i++) 
	   {
	   var sample=sampleMessage[i].split(String.fromCharCode(3));
	   if (sample.length>=2)
	   sampleType.add(new Option(sample[1],sample[0]));
	   }
	
	}
	else{
	sampleType.disabled=true;
	}
		
		if (obj) SetValue('ItemDesc',obj.innerText);
		var obj=document.getElementById('ARCOSItemQtyz'+Row);
		if (obj) SetValue('ItemQty',obj.innerText);
		var obj=document.getElementById('ARCOSItemBillUOMz'+Row);
		if (obj) SetValue('ItemBillUOM',obj.innerText);
		var obj=document.getElementById('ARCOSItemDoseQtyz'+Row);
		if (obj) SetValue('ItemDoseQty',obj.innerText);
		//标本
		var obj=document.getElementById('SampleIDz'+Row);
		//alert(obj.value+","+document.getElementById('samplez'+Row).innerText)
		if (obj) SetValue('sampleType',obj.value); 
		
		//刷新关联
		var obj=document.getElementById('ARCOSItmLinkDoctorz'+Row);
		if (obj) SetValue('ItmLinkDoctor',obj.innerText);
	   
	    var obj=document.getElementById('ARCOSItemUOMDRz'+Row);
	 
	    var obj=document.getElementById('Tremarkz'+Row)
		if (obj) SetValue('remark',obj.innerText);
		
	
		
		if (obj) {
			var DoseUOMDR=obj.value;
			var obj=document.getElementById('ARCIMRowidz'+Row);
			if (obj) {
				var ARCIMRowid=obj.value;
				if (ARCIMRowid=='') return;
				SetValue('ItemRowid',ARCIMRowid);
				SetDoseUOM(ARCIMRowid);
				//SetValue('ItemDoseUOM',DoseUOMDR);
			}
		}
		var obj=document.getElementById('ARCOSItemFrequenceDRz'+Row);
		if (obj) {
			var FrequenceID=obj.value;
			//SetValue('ItemFrequence',FrequenceID);
			frequenceCombo.setComboValue(FrequenceID+"^");
			if (FrequenceID==""){frequenceCombo.setComboText('');}
			
		}
		var obj=document.getElementById('ARCOSItemInstructionDRz'+Row);
		if (obj) {
			var ItemInstructionID=obj.value;
			//SetValue('ItemFrequence',FrequenceID);
			ItemInstrCombo.setComboValue(ItemInstructionID+"^");
			
		}
		var obj=document.getElementById('ARCOSItemDurationDRz'+Row);
		if (obj) {
			var DurationID=obj.value;
			SetValue('ItemDuration',DurationID);
		}
		/*
		var obj=document.getElementById('ARCOSItemInstructionDRz'+Row);
		if (obj) {
			var InstructionID=obj.value;
			SetValue('ItemInstruction',InstructionID);
			
		}
		*/
		//取到单位
		var obj=document.getElementById('ARCOSItemUOMDRz'+Row);
		if (obj) {
			var ItemDoseUOMID=obj.value;
			SetValue('ItemDoseUOM',ItemDoseUOMID);
		}
		//取医嘱类型
		var obj=document.getElementById('ARCOSDHCDocOrderTypeDRz'+Row);
		if (obj) {
			var DHCDocOrderTypeID=obj.value;
			SetValue('DHCDocOrderType',DHCDocOrderTypeID);
		      }
		//取附加说明
		var obj=document.getElementById('OrderPriorRemarksDRz'+Row);
		if (obj) {
			var OrderPriorRemarksDR=obj.value;
			OrderPriorRemarksCombo.setComboValue(OrderPriorRemarksDR);
			if (OrderPriorRemarksDR==""){OrderPriorRemarksCombo.setComboText('');}
		      }
		  
		/*
		var obj=document.getElementById('ARCOSOrdCatDRz'+Row);
		if (obj) {
			var CatID=obj.value;
			SetValue('Category',CatID);
			if (CatID!=''){
				SetSubCategory(CatID);
				var obj=document.getElementById('ARCOSOrdSubCatDRz'+Row);
				if (obj) SetValue('SubCategory',obj.value);
			}
		}
		*/
		SelectedRow = selectrow;
		ResetButton(1);
	}else{
		SelectedRow=0;
		ResetButton(0)
	}
}

function SetFrequenceList(text,value){
	var obj=document.getElementById("ItemFrequence");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}
function SetUMLList(text,value){
	var obj=document.getElementById("ItemFrequence");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}
function SetDurationList(text,value){
	var obj=document.getElementById("ItemDuration");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}
function SetInstructionList(text,value){
	var obj=document.getElementById("ItemInstruction");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}

//加入医嘱类型取值方法
function SetDHCDocOrderType(text,value){
	var obj=document.getElementById("DHCDocOrderType");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
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
	if (obj) ClearAllList(obj);
	var NewIndex=obj.length;
	obj.options[NewIndex] = new Option("","");
	var GetPrescList=document.getElementById("GetDoseUOM")
	if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
	if (encmeth!="") {
		cspRunServerMethod(encmeth,'SetDoseUOMList',ARCIMRowid);
	}
}
//
function ResetButton(ResetFlag){
	//alert(ResetFlag);
	if (ResetFlag==0){
		SetValue('ItemDesc','');
		SetValue('ItemQty','');
		SetValue('ItemBillUOM','');
		SetValue('ItemDoseQty','');
		//SetValue('ItemFrequence','');
		frequenceCombo.setComboValue("^");
		ItemInstrCombo.setComboValue("^");
		SetValue('ItemDuration','');
		SetValue('ItemInstruction','');
		//加入双击后关联备注为空
		SetValue('remark','');
		SetValue('DHCDocOrderType','');
		
		SetValue('ItmLinkDoctor','');
		frequenceCombo.setComboValue('')
		frequenceCombo.setComboText('')
		OrderPriorRemarksCombo.setComboValue('')
		OrderPriorRemarksCombo.setComboText('')
		
		var obj=document.getElementById("ItemDoseUOM");
		if (obj) {
	     	ClearAllList(obj);
			var NewIndex=obj.length;
			obj.options[NewIndex] = new Option("","");
		}
		DisableAddButton(0);
		DisableDeleteButton(1);
		DisableInsertButton(1)
		DisableUpdateButton(1);
	}else{
		DisableAddButton(1);
		DisableDeleteButton(0);
		DisableInsertButton(0);
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
function DisableInsertButton(Disable){
	//alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("Insert");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=InsertClickHandler;
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
		if (obj.tagName=="LABEL") {obj.innerText=value;} else {obj.value=value}
	}
}
function ItemQty_Keydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	var obj=document.getElementById("ItemQty");
	if ((keycode==13)||(keycode==9)||(keycode==108)) {websys_nextfocusElement(obj)}
	else {
		if ((keycode==8)||(keycode==46)||(keycode==110)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
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
	if ((keycode==13)||(keycode==9)||(keycode==108)) {websys_nextfocusElement(obj)}
	else {
		if ((keycode==8)||(keycode==46)||(keycode==110)||(keycode==190)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
			try {}
			catch(e) {}
		}else{
			return websys_cancel();
		}
	}
}
function ItemDoseUOM_Keydownhandler(e){
	
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	var obj=document.getElementById("ItemDoseUOM");
	if ((keycode==13)||(keycode==9)) {websys_nextfocusElement(obj)}
}

function CheckBeforeSave() {
	var ARCIMRowid="";
	var obj=document.getElementById("ItemRowid");
	if (obj) ARCIMRowid=obj.value;
	
	if (ARCIMRowid=='') {
		alert(t['NoItem']);
		websys_setfocus('ItemDesc');
		return false;
	}
	var ARCOSRowid="";
	var obj=document.getElementById("ARCOSRowid");
	if (obj) ARCOSRowid=obj.value;
	if (ARCOSRowid=='') {
		alert(t['NoARCOSRowid']);
		websys_setfocus('ItemDesc');
		return false;
	}
	var ItmLinkDoctor='';
	var obj=document.getElementById("ItmLinkDoctor");
	if (obj) ItmLinkDoctor=obj.value;
	var OrderPriorRemarksValue="",OrderPriorRemarks="";
	if (typeof OrderPriorRemarksCombo != "undefined") {
		OrderPriorRemarksValue=OrderPriorRemarksCombo.getSelectedValue();
		OrderPriorRemarks=OrderPriorRemarksCombo.getSelectedText();
	}
	if (OrderPriorRemarks.indexOf("取药医嘱")!=-1) {
		if (ItmLinkDoctor!="") {
			alert("关联医嘱,不允许选择取药医嘱");
			websys_setfocus('OrderPriorRemarks');
			return false;
		}
		var ArcimInfo=tkMakeServerCall("web.DHCDocOrderCommon","GetARCIMDetail",ARCIMRowid);
		var OrderType=ArcimInfo.split('^')[1];
		if (OrderType!="R") {
			alert("非药品医嘱,不允许选择取药医嘱");
			websys_setfocus('OrderPriorRemarks');
			return false;
		}
	}
	
	return true;
}

function AddClickHandler(){
	if (!CheckBeforeSave()) return;
	
	var ARCIMRowid="";
    //var OrderSetsEdit=top.frames[0].frames[0]
	var obj=document.getElementById("ItemRowid");
	if (obj) ARCIMRowid=obj.value;
	
	var ARCOSRowid="";
	var obj=document.getElementById("ARCOSRowid");
	if (obj) ARCOSRowid=obj.value;

	var obj=document.getElementById("ItemDesc");
	if (obj) var ItemDesc=obj.value;

	var obj=document.getElementById("ItemQty");
	if (obj) var ItemQty=obj.value;

	var obj=document.getElementById("ItemDoseQty");
	if (obj) var ItemDoseQty=obj.value;

	var obj=document.getElementById("ItemBillUOM");
	if (obj) var ItemBillUOM=obj.innerText;
	
	//增加关联
	var ItmLinkDoctor='';
	var obj=document.getElementById("ItmLinkDoctor");
	if (obj) ItmLinkDoctor=obj.value;
	
	
	
	var remark='';
	var obj=document.getElementById("remark");
	if (obj) remark=obj.value;


	var ItemDoseUOM='';
	var obj=document.getElementById("ItemDoseUOM");
	if (obj) {
		var ItemDoseUOMID=obj.value;
		if (obj.selectedIndex!=-1) {ItemDoseUOM=obj.options[obj.selectedIndex].text};
	}

	var ItemFrequence='';
	/*
	var obj=document.getElementById("ItemFrequence");
	if (obj) {
		var ItemFrequenceID=obj.value;
		if (obj.selectedIndex!=-1) {ItemFrequence=obj.options[obj.selectedIndex].text};
	}*/
	ItemFrequence=frequenceCombo.getSelectedText();
	var ItemFrequenceID=frequenceCombo.getSelectedValue();
    var ItemDuration='';
  	var obj=document.getElementById("ItemDuration");
	if (obj) {
		var ItemDurationID=obj.value;
		if (obj.selectedIndex!=-1) {ItemDuration=obj.options[obj.selectedIndex].text};
	}
    /*
	var ItemInstruction='';
	var obj=document.getElementById("ItemInstruction");
	if (obj) {
		var ItemInstructionID=obj.value;
		if (obj.selectedIndex!=-1) {ItemInstruction=obj.options[obj.selectedIndex].text};
		
	}*/
	ItemInstruction=ItemInstrCombo.getSelectedText();
	var ItemInstructionID=ItemInstrCombo.getSelectedValue();
    //加入医嘱类型
	var DHCDocOrderType='';
	var obj=document.getElementById("DHCDocOrderType");
	if (obj){
		var DHCDocOrderTypeID=obj.value;
		if (obj.selectedIndex!=-1) {DHCDocOrderType=obj.options[obj.selectedIndex].text};
		//alert(DHCDocOrderTypeID);
	}
	var DHCSample=""
	var objsampleType=document.getElementById("sampleType");
	if  ((objsampleType)&&(obj.selectedIndex!='-1'))
	DHCSample=obj?obj.options[obj.selectedIndex]:"";
	
	//附加说明
	var OrderPriorRemarksValue=OrderPriorRemarksCombo.getSelectedValue();
	var OrderPriorRemarks=OrderPriorRemarksCombo.getSelectedText();
	
	var GetPrescList=document.getElementById("InsertItem")
	if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
	if (encmeth!="") {
		               // alert(ARCOSRowid+"^"+ARCIMRowid+"^"+ItemQty+"^"+ItemDoseQty+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID+"^"+ItmLinkDoctor+"^"+remark+"^"+DHCDocOrderTypeID);
	//当为添加按钮的时候输入的位置号为空
	 var objtbl=document.getElementById('tUDHCARCOrderSetItem_Edit');
	 var rows=objtbl.rows.length;
	 var Row=rows-1 //控制医嘱套的医嘱项开始的时候为空的情况下添加行会错误；
	 var ItemId=document.getElementById("ARCIMRowidz"+Row).value;
	 if (ItemId==""){var rows=Row};
		var ARCOSItemRowid=cspRunServerMethod(encmeth,ARCOSRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,objsampleType.selectedIndex!="-1"?DHCSample.value:"","",OrderPriorRemarksValue)
		if (ARCOSItemRowid=='-1') {
			alert(t['InsertErr']);
			return;
		}
	//再插入后将最大值返回
	var obj=document.getElementById("GetMaxItemNo")
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	if (encmeth!="") {var MaxItemNO=cspRunServerMethod(encmeth,ARCOSItemRowid)}
	//输入的最后一位是序号为最大值
     var value=ItemDesc+"^"+ItemQty+"^"+ItemBillUOM+"^"+ItemDoseQty+"^"+ItemDoseUOM+"^"+ItemFrequence+"^"+ItemDuration+"^"+ItemInstruction+"^"+ARCOSItemRowid+"^"+ARCIMRowid+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID+"^"+"^"+"^"+"^"+ItmLinkDoctor+"^"+remark+"^"+DHCDocOrderType+"^"+DHCDocOrderTypeID+"^"+(objsampleType.selectedIndex!="-1"?DHCSample.text:"");//+(obj.selectedIndex!="-1"?DHCSample.text:"")+"^"+(obj.selectedIndex!="-1"?DHCSample.value:"")+
     var tabvalue=ItemDesc+"^"+ItemQty+"^"+ItemBillUOM+"^"+ItemDoseQty+"^"+ItemDoseUOM+"^"+ItemFrequence+"^"+ItemDuration+"^"+ItemInstruction+"^"+ARCOSItemRowid+"^"+ARCIMRowid+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID+"^"+"^"+"^"+"^"+ItmLinkDoctor+"^"+remark+"^"+DHCDocOrderType+"^"+DHCDocOrderTypeID+"^"+(objsampleType.selectedIndex!="-1"?DHCSample.value:"")+"^"+(objsampleType.selectedIndex!="-1"?DHCSample.text:"")+"^"+MaxItemNO+"^"+rows+"^"+OrderPriorRemarksValue+"^"+OrderPriorRemarks;
	 AddTabRow(tabvalue);  
	 ResetButton(0);	
	}
}
function DeleteClickHandler(){
	var Row=GetRow(SelectedRow);
	var SelRowObj=document.getElementById('ARCOSItemRowidz'+Row);
	if (SelRowObj) {
		var ARCOSItemRowid=SelRowObj.value;
		if (ARCOSItemRowid=='') {
			alert(t['NoRowid']);
			return;
		}
		var GetPrescList=document.getElementById("DeleteItem")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if(confirm(t["DeleteOrderItemConfirm"]))
        {
		if (encmeth!="") {
			//alert(FavRowid);
			if (cspRunServerMethod(encmeth,ARCOSItemRowid)=='-1') {
				alert(t['DeleteErr']);
			}else{
				//DeleteRow(SelectedRow);
   			SelectedRow=0;
 				ResetButton(0);
 				window.treload('websys.csp');
 			}
		 }
		}
	}
}
//更新按钮
function UpdateClickHandler(){
	if (!CheckBeforeSave()) return;
	
	var ARCIMRowid="";
	var obj=document.getElementById("ItemRowid");
	if (obj) ARCIMRowid=obj.value;
	
	var obj=document.getElementById("ItemDesc");
	if (obj) var ItemDesc=obj.value;

	var obj=document.getElementById("ItemQty");
	if (obj) var ItemQty=obj.value;

	var obj=document.getElementById("ItemDoseQty");
	if (obj) var ItemDoseQty=obj.value;

	var obj=document.getElementById("ItemBillUOM");
	if (obj) var ItemBillUOM=obj.innerText;
	
	
	
	var remark="";
	var obj=document.getElementById("remark");
	if (obj) var remark=obj.value;
	

	//增加关联
	var ItmLinkDoctor='';
	var obj=document.getElementById("ItmLinkDoctor");
	if (obj) ItmLinkDoctor=obj.value;

	var ItemDoseUOM='';
	var obj=document.getElementById("ItemDoseUOM");
	if (obj) {
		var ItemDoseUOMID=obj.value;
		if (obj.selectedIndex!=-1) {ItemDoseUOM=obj.options[obj.selectedIndex].text};
	}

    var ItemFrequence='';
	/*
	var obj=document.getElementById("ItemFrequence");
	if (obj) {
		var ItemFrequenceID=obj.value;
		if (obj.selectedIndex!=-1) {ItemFrequence=obj.options[obj.selectedIndex].text};
	}*/
	ItemFrequence=frequenceCombo.getSelectedText();
	var ItemFrequenceID=frequenceCombo.getSelectedValue();
	
	
    var ItemDuration='';
  	var obj=document.getElementById("ItemDuration");
	if (obj) {
		var ItemDurationID=obj.value;
		if (obj.selectedIndex!=-1) {ItemDuration=obj.options[obj.selectedIndex].text};
	}
	
	//附加说明
	var OrderPriorRemarksValue=OrderPriorRemarksCombo.getSelectedValue();
	var OrderPriorRemarks=OrderPriorRemarksCombo.getSelectedText();
	
    /*
	var ItemInstruction='';
	var obj=document.getElementById("ItemInstruction");
	if (obj) {
		var ItemInstructionID=obj.value;
		if (obj.selectedIndex!=-1) {ItemInstruction=obj.options[obj.selectedIndex].text};
		
	}*/
	var ItemInstruction=ItemInstrCombo.getSelectedText();
	var ItemInstructionID=ItemInstrCombo.getSelectedValue();
	//加入医嘱类型
	var DHCDocOrderType='';
	var obj=document.getElementById("DHCDocOrderType");
	if (obj) {
		var DHCDocOrderTypeID=obj.value;
		if (obj.selectedIndex!=-1) {DHCDocOrderType=obj.options[obj.selectedIndex].text};
	          }

	var Row=GetRow(SelectedRow);
	var ARCOSItemRowid='';
	var SelRowObj=document.getElementById('ARCOSItemRowidz'+Row);
	if (SelRowObj) {ARCOSItemRowid=SelRowObj.value;}
	if (ARCOSItemRowid=='') {
		alert(t['NoRowid']);
		return;
	}
    
	var DHCSample="";
	var obj=document.getElementById("sampleType");
	if  ((obj)&&(obj.selectedIndex!="-1"))
	DHCSample=obj?obj.options[obj.selectedIndex]:"";
	
	var GetPrescList=document.getElementById("UpdateItem")
	if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
	if (encmeth!="") {
		//alert(ARCOSItemRowid+"^"+ARCIMRowid+"^"+ItemQty+"^"+ItemDoseQty+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID+"^"+ItmLinkDoctor+"^"+remark);
		//alert((obj.selectedIndex!="-1"?DHCSample.text:""));
		var Err=cspRunServerMethod(encmeth,ARCOSItemRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,obj.selectedIndex!="-1"?DHCSample.value:"",OrderPriorRemarksValue)
		if (Err=='-1') {
			alert(t['UpdateErr']);
			return;
		}
		
        var value=ItemDesc+"^"+ItemQty+"^"+ItemBillUOM+"^"+ItemDoseQty+"^"+ItemDoseUOM+"^"+ItemFrequence+"^"+ItemDuration+"^"+ItemInstruction+"^"+ARCOSItemRowid+"^"+ARCIMRowid+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID+"^"+ItmLinkDoctor+"^"+remark+"^"+DHCDocOrderType+"^"+DHCDocOrderTypeID+"^"+(obj.selectedIndex!="-1"?DHCSample.text:"");
		var tabvalue=ItemDesc+"^"+ItemQty+"^"+ItemBillUOM+"^"+ItemDoseQty+"^"+ItemDoseUOM+"^"+ItemFrequence+"^"+ItemDuration+"^"+ItemInstruction+"^"+ARCOSItemRowid+"^"+ARCIMRowid+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID+"^"+ItmLinkDoctor+"^"+remark+"^"+DHCDocOrderType+"^"+DHCDocOrderTypeID+"^"+(obj.selectedIndex!="-1"?DHCSample.value:"")+"^"+(obj.selectedIndex!="-1"?DHCSample.text:"")+"^"+OrderPriorRemarksValue+"^"+OrderPriorRemarks;
		UpdateTabRow(tabvalue);
		
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
	var obj=document.getElementById("ChoseType");
	if (obj.checked){var ibilluom=adata[19]}
	else{var ibilluom=adata[20]}	
	
	//alert(mPiece(OSItemIDs,String.fromCharCode(12),1));
	window.focus();
    if (iordertype=="ARCOS") return;

	if (iordertype=="ARCIM") iSetID="";

	SetValue('ItemDesc','');
	SetValue('ItemQty','');
	SetValue('ItemBillUOM','');
	SetValue('ItemDoseQty','');
	//SetValue('ItemFrequence','');
	frequenceCombo.setComboValue("^");
	SetValue('ItemDuration','');
	SetValue('ItemInstruction','');
	
	var getSample=document.getElementById("GetSample");
	var encmeth=getSample?getSample.value:"";
	var getSampleResult=cspRunServerMethod(encmeth,icode);
	var ret=getSampleResult;
	var sampleType=document.getElementById("sampleType");
	//先清空
	ClearAllList(sampleType);
	//有标本
	if (ret!=""){
	   if (sampleType.disabled==true)
	   sampleType.disabled=false;
	    sampleType.add(new Option("",""));
	   var sampleMessage=ret.split(String.fromCharCode(2));	  
	   for(var i=0;i<sampleMessage.length;i++) 
	   {
	   var sample=sampleMessage[i].split(String.fromCharCode(3));
	   if (sample.length>=2)
	   sampleType.add(new Option(sample[1],sample[0]));
	   }
	
	}
	else{
	sampleType.disabled=true;
	}
	
	
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
    SetValue('ItemRowid',icode);
    SetValue('ItemBillUOM',ibilluom);
    
    if (DefaultDoseQty!="") SetValue('ItemDoseQty',DefaultDoseQty);
	if(isubcatcode!="R") SetValue('ItemDoseQty',"");
    //if (OrderFreqRowid!="") SetValue('ItemFrequence',OrderFreqRowid);
	if (OrderFreqRowid!="") frequenceCombo.setComboValue(OrderFreqRowid+"^");
    //if (OrderInstrRowid!="") SetValue('ItemInstruction',OrderInstrRowid);
	if (OrderInstrRowid!="") ItemInstrCombo.setComboValue(OrderInstrRowid+"^");
    if (OrderDurRowid!="") SetValue('ItemDuration',OrderDurRowid);
    
   
	
	if (icode!=""){SetDoseUOM(icode);}
    if (DefaultDoseUOMRowid!="") SetValue('ItemDoseUOM',DefaultDoseUOMRowid);
	if(isubcatcode!="R") SetValue('ItemDoseUOM',"");
    if (isubcatcode=="R"){
    	websys_setfocus("ItemDoseQty");
    }else{
	    websys_setfocus("ItemQty");
    }
}


function ItemFrequenceClickHandler()
{
    var temporaryIndex;
    var longtermIndex;
	DHCDocOrderTypeObj=document.getElementById("DHCDocOrderType")
    for (var i=0 ;i<DHCDocOrderTypeObj.length;i++)
	{
	  if (DHCDocOrderTypeObj.options[i].text=="临时医嘱")
	  {
	    temporaryIndex=i;
	  }
	  if (DHCDocOrderTypeObj.options[i].text=="长期医嘱")
	  {
	    longtermIndex=i;
	  }
	}
  if  ((this.selectedIndex>-1)&&(this.options[this.selectedIndex].text=="ONCE"))
  {
      DHCDocOrderTypeObj.value=DHCDocOrderTypeObj.options[temporaryIndex].value;
	  DHCDocOrderTypeObj.disabled=true;	
  }
  else
  {
        DHCDocOrderTypeObj.disabled=false;
	    DHCDocOrderTypeObj.value=DHCDocOrderTypeObj.options[longtermIndex].value;
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
		url += "&CONTEXT=Kweb.DHCARCOrdSets:LookUpItem";
		url += "&TLUJSF=OrderItemLookupSelect";
		var obj=document.getElementById('ItemDesc');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var ChoseType=""
		var obj=document.getElementById('ChoseType'); //lxz
		if (obj.checked){ChoseType="on";}
		if (obj) url += "&P3=" + websys_escape(ChoseType);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

function FrequenceKeydownhandler()
{
    var temporaryIndex;
    var longtermIndex;
	DHCDocOrderTypeObj=document.getElementById("DHCDocOrderType")
	if(DHCDocOrderTypeObj.length==0)
	return;
    for (var i=0 ;i<DHCDocOrderTypeObj.length;i++)
	{
	  if (DHCDocOrderTypeObj.options[i].text=="临时医嘱")
	  {
	    temporaryIndex=i;
	  }
	  if (DHCDocOrderTypeObj.options[i].text=="长期医嘱")
	  {
	    longtermIndex=i;
	  }
	}
  if  (frequenceCombo.getSelectedText()=="ONCE")
  {
      DHCDocOrderTypeObj.value=DHCDocOrderTypeObj.options[temporaryIndex].value;
	  DHCDocOrderTypeObj.disabled=true;	
  }
  else
  {
        DHCDocOrderTypeObj.disabled=false;
	    DHCDocOrderTypeObj.value=DHCDocOrderTypeObj.options[longtermIndex].value;
  }
}
//--------------------------------------------------------插入行


var count=0;
var First=0;
var MaxTblRowIndex=0; 

function InsertClickHandler()
{			var objtbl=document.getElementById('tUDHCARCOrderSetItem_Edit');
	 		var rows=objtbl.rows.length;
			if (rows==1) return ;
			if (SelectedRow==0) return ;
            var Row=GetRow(SelectedRow);
            var ret=CanInsertRow(SelectedRow);
            if (ret) InsertRowToList(objtbl,rows-1,SelectedRow);
            else{alert("请选择要插入行的位置!");return;}
            return false;
         	
  
}
//判断所在行是不是选中要插入的行如果是返回false。
function CanInsertRow(SelectedRow){
	var ItemID=document.getElementById('ARCIMRowidz'+SelectedRow).value;
	if (ItemID==""){	
		return false;
	}
	return true;
}
//擦入行
function InsertRowToList(objtbl,rows,SelectedRow)
{
	var Tabvalue=GetInsertStr(SelectedRow);
	var ret1=GetRowValue(SelectedRow);  
	for(var i=1;i+SelectedRow<=rows+1;i++)
	{                             
		if (SelectedRow+i>rows){var ret2="";}
		else{var ret2=GetRowValue(SelectedRow+i);}
		if (i==1){SetRowValue(SelectedRow,Tabvalue);}
		if (SelectedRow+i>rows){var ret1=AddOne(ret1);AddLastRow(ret1);}
		else{var ret1=AddOne(ret1);SetRowValue(SelectedRow+i,ret1);}
		var RowNO=SelectedRow+i
	    document.getElementById("NOz"+RowNO).innerText=RowNO;
		var ret1=ret2;
		
	}
	
	
}
//将第选中行以后的ARCOSItemNO在赋值的时候自动加1
function AddOne(Str)
{
	var Split_Value=Str.split("^");
	Split_Value[20]=parseInt(Split_Value[20])+1
	var Str=Split_Value.join("^");
	return Str
}



//最后一行加入
function AddLastRow(ret1)
{			if (ret1!=""){	
			var objtbl=document.getElementById('tUDHCARCOrderSetItem_Edit');
	        if (LoopCount!=0) AddRowToList(objtbl);
	        LoopCount=LoopCount+1;
	 		var rows=objtbl.rows.length;
			var LastRow=rows - 1;
	        var Row=GetRow(LastRow);
	        SetRowValue(Row,ret1) 
		}
}
	

//得到一行数据串
function GetRowValue(Row)
{
	//SetValue('ItemDesc',obj.innerText);
		var ARCIMDesc=document.getElementById("ARCIMDescz"+Row).innerText;
		var ARCOSItemQty=document.getElementById("ARCOSItemQtyz"+Row).innerText;
	    var ARCOSItemBillUOM=document.getElementById("ARCOSItemBillUOMz"+Row).innerText;
	    var ARCOSItemDoseQty=document.getElementById("ARCOSItemDoseQtyz"+Row).innerText;
	    var ARCOSItemUOM=document.getElementById("ARCOSItemUOMz"+Row).innerText;
	    var ARCOSItemFrequence=document.getElementById("ARCOSItemFrequencez"+Row).innerText;
	    var ARCOSItemDuration=document.getElementById("ARCOSItemDurationz"+Row).innerText;
		var ARCOSItemInstruction=document.getElementById("ARCOSItemInstructionz"+Row).innerText;
	    var ARCOSItemRowid=document.getElementById("ARCOSItemRowidz"+Row).value;
	    var ARCIMRowid=document.getElementById("ARCIMRowidz"+Row).value;
	    var ARCOSItemUOMDR=document.getElementById("ARCOSItemUOMDRz"+Row).value;
	    var ARCOSItemFrequenceDR=document.getElementById("ARCOSItemFrequenceDRz"+Row).value
	    var ARCOSItemDurationDR=document.getElementById("ARCOSItemDurationDRz"+Row).value
	    var ARCOSItemInstructionDR=document.getElementById("ARCOSItemInstructionDRz"+Row).value
	    var ARCOSItmLinkDoctor=document.getElementById("ARCOSItmLinkDoctorz"+Row).innerText;
	    var Tremark=document.getElementById("Tremarkz"+Row).innerText;
	    var ARCOSDHCDocOrderType=document.getElementById("ARCOSDHCDocOrderTypez"+Row).innerText;
	    var ARCOSDHCDocOrderTypeDR=document.getElementById("ARCOSDHCDocOrderTypeDRz"+Row).value
		var sample=document.getElementById("samplez"+Row).innerText;
		var SampleID=document.getElementById("SampleIDz"+Row).value;
		var ARCOSItemNO=document.getElementById("ARCOSItemNOz"+Row).value;
		var OrderPriorRemarksDR=document.getElementById("OrderPriorRemarksDRz"+Row).value;
		var OrderPriorRemarks=document.getElementById("OrderPriorRemarksz"+Row).innerText;
        var ReturnTabvalue=ARCIMDesc+"^"+ARCOSItemQty+"^"+ARCOSItemBillUOM+"^"+ARCOSItemDoseQty+"^"+ARCOSItemUOM+"^"+ARCOSItemFrequence+"^"+ARCOSItemDuration+"^"+ARCOSItemInstruction+"^"+ARCOSItemRowid+"^"+ARCIMRowid+"^"+ARCOSItemUOMDR+"^"+ARCOSItemFrequenceDR+"^"+ARCOSItemDurationDR+"^"+ARCOSItemInstructionDR+"^"+ARCOSItmLinkDoctor+"^"+Tremark+"^"+ARCOSDHCDocOrderType+"^"+ARCOSDHCDocOrderTypeDR+"^"+sample+"^"+SampleID+"^"+ARCOSItemNO+"^"+OrderPriorRemarksDR+"^"+OrderPriorRemarks;
		return ReturnTabvalue;
	
}
//给指定行赋值
function SetRowValue(Row,Tablevalue)
{ 			
			var Split_Value=Tablevalue.split("^")
	        SetCell("ARCIMDesc",Row,Split_Value[0]);
			SetCell("ARCOSItemQty",Row,Split_Value[1]);
	    	SetCell("ARCOSItemBillUOM",Row,Split_Value[2]);
	    	SetCell("ARCOSItemDoseQty",Row,Split_Value[3]);
	    	SetCell("ARCOSItemUOM",Row,Split_Value[4]);
	    	SetCell("ARCOSItemFrequence",Row,Split_Value[5]);
	        SetCell("ARCOSItemDuration",Row,Split_Value[6]);
			SetCell("ARCOSItemInstruction",Row,Split_Value[7]);
	    	SetCell("ARCOSItemRowid",Row,Split_Value[8]);
	    	SetCell("ARCIMRowid",Row,Split_Value[9]);
	    	SetCell("ARCOSItemUOMDR",Row,Split_Value[10]);
	    	SetCell("ARCOSItemFrequenceDR",Row,Split_Value[11]);
	    	SetCell("ARCOSItemDurationDR",Row,Split_Value[12]);
	    	SetCell("ARCOSItemInstructionDR",Row,Split_Value[13]);
	    	SetCell("ARCOSItmLinkDoctor",Row,Split_Value[14]);
	    	SetCell("Tremark",Row,Split_Value[15]);
	    	SetCell("ARCOSDHCDocOrderType",Row,Split_Value[16]);
	    	SetCell("ARCOSDHCDocOrderTypeDR",Row,Split_Value[17]);
			SetCell("sample",Row,Split_Value[18]);
			SetCell("SampleID",Row,Split_Value[19]);
			SetCell("ARCOSItemNO",Row,Split_Value[20]);
			
			//附加说明赋值
			SetCell("OrderPriorRemarksDR",Row,Split_Value[21]);
			SetCell("OrderPriorRemarks",Row,Split_Value[22]);
			
		
}


//得到要插入数据，同时将数据保存。
function GetInsertStr(SelectedRow)
{
	var obj=document.getElementById("ItemRowid");
	if (obj) var ARCIMRowid=obj.value;
	
	if (ARCIMRowid=='') {
		alert(t['NoItem']);
		websys_setfocus('ItemDesc');
		return;
	}
	var obj=document.getElementById("ARCOSRowid");
	if (obj) var ARCOSRowid=obj.value;
	if (ARCOSRowid=='') {
		alert(t['NoARCOSRowid']);
		websys_setfocus('ItemDesc');
		return;
	}

	var obj=document.getElementById("ItemDesc");
	if (obj) var ItemDesc=obj.value;

	var obj=document.getElementById("ItemQty");
	if (obj) var ItemQty=obj.value;

	var obj=document.getElementById("ItemDoseQty");
	if (obj) var ItemDoseQty=obj.value;

	var obj=document.getElementById("ItemBillUOM");
	if (obj) var ItemBillUOM=obj.innerText;
	
	//增加关联
	var ItmLinkDoctor='';
	var obj=document.getElementById("ItmLinkDoctor");
	if (obj) ItmLinkDoctor=obj.value;
	var remark='';
	var obj=document.getElementById("remark");
	if (obj) remark=obj.value;
	var ItemDoseUOM='';
	var obj=document.getElementById("ItemDoseUOM");
	if (obj) {
		var ItemDoseUOMID=obj.value;
		if (obj.selectedIndex!=-1) {ItemDoseUOM=obj.options[obj.selectedIndex].text};
	}
	var ItemFrequence='';
	ItemFrequence=frequenceCombo.getSelectedText();
	var ItemFrequenceID=frequenceCombo.getSelectedValue();
    var ItemDuration='';
  	var obj=document.getElementById("ItemDuration");
	if (obj) {
		var ItemDurationID=obj.value;
		if (obj.selectedIndex!=-1) {ItemDuration=obj.options[obj.selectedIndex].text};
	}
  
	ItemInstruction=ItemInstrCombo.getSelectedText();
	var ItemInstructionID=ItemInstrCombo.getSelectedValue();
    //加入医嘱类型
	var DHCDocOrderType='';
	var obj=document.getElementById("DHCDocOrderType");
	if (obj){
		var DHCDocOrderTypeID=obj.value;
		if (obj.selectedIndex!=-1) {DHCDocOrderType=obj.options[obj.selectedIndex].text};
		
	}
	//标本
	var DHCSample=""
	var obj=document.getElementById("sampleType");
	if  ((obj)&&(obj.selectedIndex!='-1'))
	DHCSample=obj?obj.options[obj.selectedIndex]:"";
	//附加说明
	var OrderPriorRemarksValue=OrderPriorRemarksCombo.getSelectedValue();
	var OrderPriorRemarks=OrderPriorRemarksCombo.getSelectedText();
	
	var GetPrescList=document.getElementById("InsertItem")
	if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
	if (encmeth!="") {
		
	var ARCOSItemNO=document.getElementById("ARCOSItemNOz"+SelectedRow).value;
	var ARCOSItemNO=parseInt(ARCOSItemNO);
	  //alert(ARCOSRowid+"^"+ARCIMRowid+"^"+ItemQty+"^"+ItemDoseQty+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID+"^"+ItmLinkDoctor+"^"+remark+"^"+DHCDocOrderTypeID); 
		var ARCOSItemRowid=cspRunServerMethod(encmeth,ARCOSRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,obj.selectedIndex!="-1"?DHCSample.value:"",ARCOSItemNO,OrderPriorRemarksValue)
		if (ARCOSItemRowid=='-1') {
			alert(t['InsertErr']);
			return;
		}
     var tabvalue=ItemDesc+"^"+ItemQty+"^"+ItemBillUOM+"^"+ItemDoseQty+"^"+ItemDoseUOM+"^"+ItemFrequence+"^"+ItemDuration+"^"+ItemInstruction+"^"+ARCOSItemRowid+"^"+ARCIMRowid+"^"+ItemDoseUOMID+"^"+ItemFrequenceID+"^"+ItemDurationID+"^"+ItemInstructionID+"^"+ItmLinkDoctor+"^"+remark+"^"+DHCDocOrderType+"^"+DHCDocOrderTypeID+"^"+(obj.selectedIndex!="-1"?DHCSample.text:"")+"^"+(obj.selectedIndex!="-1"?DHCSample.value:"")+"^"+ARCOSItemNO+"^"+OrderPriorRemarksValue+"^"+OrderPriorRemarks;
	 return tabvalue;
		
	}
}


//lxz--------------加入草药应用
function ChangeChoseType()
{
	ChoseTypeValueSet(1)
	location.reload();
	
}	

function ChoseTypeValueSet(ValueGet)
{
	var returnget=""
	var obj=document.getElementById("ChoseType");
	if (obj) 
	{
		
		var UserID=session['LOGON.USERID'];
		if (ValueGet=="1"){
		if (obj.checked){returnget=tkMakeServerCall('web.DHCDocItemDefault','SetCMTypeCheck',UserID,"Y","1");}
		else {returnget=tkMakeServerCall('web.DHCDocItemDefault','SetCMTypeCheck',UserID,"N","1")}
		}
		else{
			returnget=tkMakeServerCall('web.DHCDocItemDefault','SetCMTypeCheck',UserID,"","2");
			
			}
	}
	return returnget
}
function ChoseTypeChange()
{
	var obj=document.getElementById("ChoseType");
	if (obj){
		if (obj.checked){
				var ret="" 
				var GetItemInst=document.getElementById("ReadItemInstrNew")
				if (GetItemInst) {var encmeth=GetItemInst.value} else {var encmeth=''};
				if (encmeth!="") {ret=cspRunServerMethod(encmeth,'^Clear')}
				ItemInstrCombo=dhtmlXComboFromStr("ItemInstruction",ret);
				ItemInstrCombo.enableFilteringMode(true);
				
				var ret=""  
				var GetPrescList=document.getElementById("ReadItemFrequenceNew")
				if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
				if (encmeth!="") {
				 ret=cspRunServerMethod(encmeth,'^Clear')
				}
   				frequenceCombo=dhtmlXComboFromStr("ItemFrequence",ret);
				frequenceCombo.enableFilteringMode(true);
				frequenceCombo.attachEvent("onSelectionChange", FrequenceKeydownhandler); 
				
				
				var ret="" 
				var PhSpecInstrList=document.getElementById("PhSpecInstrList")
				if (PhSpecInstrList) {var encmeth=PhSpecInstrList.value} else {var encmeth=''};
				if (encmeth!="") {ret=cspRunServerMethod(encmeth,'')}
				remarkCombo=dhtmlXComboFromStr("remark",ret);
				remarkCombo.enableFilteringMode(true);
				
				// 附加说明
				var ret="" 
				var GetPriorRemarks=document.getElementById("GetPriorRemarks")
				if (GetPriorRemarks) {var encmeth=GetPriorRemarks.value} else {var encmeth=''};
				if (encmeth!="") {ret=cspRunServerMethod(encmeth,'^Clear')}
				OrderPriorRemarksCombo=dhtmlXComboFromStr("OrderPriorRemarks",ret);
				OrderPriorRemarksCombo.enableFilteringMode(true);
				
			}
			else{
				
				var ret="" 
				var GetItemInst=document.getElementById("ReadItemInstrNew")
				if (GetItemInst) {var encmeth=GetItemInst.value} else {var encmeth=''};
				if (encmeth!="") {ret=cspRunServerMethod(encmeth,'^N')}
				ItemInstrCombo=dhtmlXComboFromStr("ItemInstruction",ret);
				ItemInstrCombo.enableFilteringMode(true);
				
				var ret=""  
				var GetPrescList=document.getElementById("ReadItemFrequenceNew")
				if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
				if (encmeth!="") {
				 ret=cspRunServerMethod(encmeth,'^N')
				}
   				frequenceCombo=dhtmlXComboFromStr("ItemFrequence",ret);
				frequenceCombo.enableFilteringMode(true);
				frequenceCombo.attachEvent("onSelectionChange", FrequenceKeydownhandler); 
				
				//附加说明
				var ret="" 
				var GetPriorRemarks=document.getElementById("GetPriorRemarks")
				if (GetPriorRemarks) {var encmeth=GetPriorRemarks.value} else {var encmeth=''};
				if (encmeth!="") {ret=cspRunServerMethod(encmeth,'^N')}
				OrderPriorRemarksCombo=dhtmlXComboFromStr("OrderPriorRemarks",ret);
				OrderPriorRemarksCombo.enableFilteringMode(true);
				
	
				}

		}
	
	}
	

