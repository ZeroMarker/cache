
document.write("<SCRIPT type='text/javascript' src='../scripts/jQuery/jquery-1.7.2.min.js'><\/SCRIPT>");
//引用医嘱录入的样式 保持关联医嘱颜色一致
document.write("<link rel='stylesheet' type='text/css' href='../scripts/dhcdoc/css/dhcdocCustomEasyUI.css' \/>");
document.write("<link rel='stylesheet' type='text/css' href='../scripts/dhcdoc/css/dhcdoc.OSItem.css' \/>");

document.body.onload = BodyLoadHandler;
var count=0;
var First=0;
var SelectedRow=0;
var MaxTblRowIndex=0; 
function BodyLoadHandler() {
	//在按钮栏<p>标签前插入一个有高度的div
	var obj=document.getElementById("tempContainer");
	if (!obj) $("body").prepend("<div id='tempContainer' class='spaceContainer'></div>");
	
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAllClickHandler;

	var obj=document.getElementById("UnSelectAll");
	 if (obj) obj.onclick=UnSelectAllClickHandler;

	var obj=document.getElementById("Add");
	if (obj)  obj.onclick=AddClickHandler;
	
	var obj=document.getElementById("CopyShort");
	if (obj) obj.onclick=CopyShortClickHandler;
	var obj=document.getElementById("CopyLong");
	if (obj) obj.onclick=CopyLongClickHandler;
	var obj=document.getElementById("Insert");
	if (obj) obj.onclick=InsertClickHandler;
	SelectAllClickHandler();
	var eTABLE=document.getElementById("tUDHCOEOrder_OSItem");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var ItemData=GetColumnData("ItemData",i);
			var TempArr=ItemData.split("^");
			var RowStyleFlag=TempArr[7];
			var RowObj=eTABLE.rows[i];
			var CNMedItemFlag=GetColumnData("CNMedItemFlag",i); //草药标志
			if (1) {	//RowStyleFlag=="SS"
				var AddItemObj=document.getElementById("AddItemz"+i);
				var ItemQty=Trim(GetColumnData("ItemQty",i));
				var ItemDoseQty=Trim(GetColumnData("ItemDoseQty",i));
				var Urgentrowid=GetColumnData("Urgentrowid",i);
				if (Urgentrowid!="Y"){
					var UrgentObj=document.getElementById("Urgentz"+i);
					if (UrgentObj) {
						UrgentObj.checked=false;
						UrgentObj.disabled=true;
					}
				}else{
					var UrgentObj=document.getElementById("Urgentz"+i);
					UrgentObj.disabled=false;
				}
				if (parseInt(ItemQty)==0) AddItemObj.checked=false;
				var ItemStatusObj=document.getElementById("ItemStatusz"+i);
				if (ItemStatusObj&&((ItemStatusObj.innerText=="停用")||(ItemStatusObj.innerText=="无权限"))) {
					if (AddItemObj) {AddItemObj.checked=false;AddItemObj.disabled=true;}
					RowObj.className="Yellow";
				}else{
					//if ((AddItemObj)&&(AddItemObj.disabled!=true)) AddItemObj.checked=false;
					for (var j=0;j<RowObj.cells.length;j++) {
			      		if (!RowObj.cells[j].firstChild) {continue} 
					  	var Id=RowObj.cells[j].firstChild.id;
						var arrId=Id.split("z");
					  	var objindex=arrId[1];
					  	var objwidth=RowObj.cells[j].style.width;
					  	var objheight=RowObj.cells[j].style.height;
					  	if (CNMedItemFlag=="1"){
						  	if (arrId[0]=="ItemDoseQty"){
								var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\""+ItemDoseQty+"\" onchange=\"ItemDoseQtychangehandler()\" onkeypress=\"ItemDoseQtykeypresshandler()\" onkeydown=\"ItemDoseQtykeydownhandler()\">";
				        		RowObj.cells[j].innerHTML=str;
		        			}
						}else{
							if (arrId[0]=="ItemQty"){
								var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\""+ItemQty+"\" onchange=\"OrderItemQtychangehandler()\" onkeypress=\"OrderItemQtykeypresshandler()\" onkeydown=\"OrderItemQtykeydownhandler()\">";
				        		RowObj.cells[j].innerHTML=str;
		        			}
						}
					  	
		        		//隐藏元素的显示
						if (arrId[0]=="ItemRowid"){RowObj.cells[j].style.display='none'}
						if (arrId[0]=="ItemData"){RowObj.cells[j].style.display='none'}
						if (arrId[0]=="ItemOrderType"){RowObj.cells[j].style.display='none'}
						if (arrId[0]=="ItemSpecCode"){RowObj.cells[j].style.display='none'}
						if (arrId[0]=="ItemPriorRemarksDR"){RowObj.cells[j].style.display='none'}
		      		}
		      		var RecLocStr=document.getElementById("ReclocDescStrz"+i).value;
					if(RecLocStr==""){
						eTABLE.rows[i].style.backgroundColor="red"	
					}

		    	}
		    	var OrderMustEnterObj=document.getElementById("OrderMustEnterz"+i);
		    	if(OrderMustEnterObj){
			    	OrderMustEnter=OrderMustEnterObj.value;
			    	if(OrderMustEnter=="Y"){
				    	if((AddItemObj)&&(!AddItemObj.disabled)){
					    	AddItemObj.checked=true
					    	AddItemObj.disabled=true;
				    	}
				    	var SeqNo=DHCC_GetColumnData("ItemSeqNo",i);
				    	var arry1=SeqNo.split(".");
				    	if ((arry1.length>=1)&&(+arry1[0]!=0)) {
					    	var MasterSeqNo=arry1[0];
					    	ChangelLinkItemSelect(MasterSeqNo,AddItemObj.checked,OrderMustEnter);
					    }
				    }	
			    }
			}
		}
	}
  	document.onkeydown=DocKeyDownHandler;
  	document.onclick=OrderDetails;
	SetLinkItemStyle()
}
function OrderItemQtychangehandler(e){
	try {
		try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
		var Row=GetEventRow(e);
		var AddItem=GetColumnData("AddItem",Row);
	  	var ItemQty=GetColumnData("ItemQty",Row);
	  	if (ItemQty=="") ItemQty=0;
	  	if (!isPositiveInteger(ItemQty)){
		   SetColumnData("ItemQty",Row,"")
	    }
		GetSum();
		/*var AddItemObj=document.getElementById('AddItemz'+Row);
		if (parseFloat(ItemQty)>0) {
		  	if (AddItemObj)AddItemObj.checked=true;
		}else if (parseFloat(ItemQty)<=0) {
			if (AddItemObj)AddItemObj.checked=false;
		}*/
	}catch(e) {}
}
function OrderItemQtykeypresshandler(e){
	var Row=GetEventRow(e);
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}
	var AddItem=GetColumnData("AddItem",Row);
  	var ItemQty=GetColumnData("ItemQty",Row);
  	if (ItemQty=="") ItemQty=0;
	if (!isPositiveInteger(ItemQty)){
		SetColumnData("ItemQty",Row,"")
	}
	/*var AddItemObj=document.getElementById('AddItemz'+Row);
	if (keycode>48) {
	  	if (AddItemObj)AddItemObj.checked=true;
	}else if ((keycode==48)&&(parseFloat(ItemQty)<=0)) {
		if (AddItemObj)AddItemObj.checked=false;
	}*/
}
function OrderItemQtykeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		//if ((keycode==8)||(keycode==9)||(keycode==46)||(keycode==13)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
		if ((keycode==13)||(keycode==9)){
			var objtbl=document.getElementById('tUDHCOEOrder_OSItem');
			var rows=objtbl.rows.length;
		  if (rows-1>SelectedRow) {
		  	var Row=GetRow(parseInt(SelectedRow)+1);
		  	SetFocusColumn("ItemQty",Row);
		  	objtbl.rows[parseInt(SelectedRow)+1].click();
		  }
			return websys_cancel();
}
	}catch(e) {}
}
function ItemDoseQtychangehandler(e){
	try {
		try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
		var Row=GetEventRow(e);
		var AddItem=GetColumnData("AddItem",Row);
	  	var ItemQty=GetColumnData("ItemDoseQty",Row);
	  	if (ItemQty=="") ItemQty=0;
	  	if (!isPositiveInteger(ItemQty)){
		   SetColumnData("ItemDoseQty",Row,"")
	    }
		GetSum();
	}catch(e) {}
}
function ItemDoseQtykeypresshandler(e){
	var Row=GetEventRow(e);
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}
	var AddItem=GetColumnData("AddItem",Row);
  	var ItemDoseQty=GetColumnData("ItemDoseQty",Row);
  	if (ItemDoseQty=="") ItemDoseQty=0;
	if (!isPositiveInteger(ItemDoseQty)){
		SetColumnData("ItemDoseQty",Row,"")
	}
}
function ItemDoseQtykeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		if ((keycode==13)||(keycode==9)){
			var objtbl=document.getElementById('tUDHCOEOrder_OSItem');
			var rows=objtbl.rows.length;
		  if (rows-1>SelectedRow) {
		  	var Row=GetRow(parseInt(SelectedRow)+1);
		  	SetFocusColumn("ItemDoseQty",Row);
		  	objtbl.rows[parseInt(SelectedRow)+1].click();
		  }
			return websys_cancel();
        }
	}catch(e) {}
}
//是否为正整数
function isPositiveInteger(s){
   var re = /^[0-9]+$/ ;
   return re.test(s)
} 
function DocKeyDownHandler(){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	var objtbl=document.getElementById('tUDHCOEOrder_OSItem');
	var rows=objtbl.rows.length;
	if (keycode==38) {
		if ((SelectedRow==0)&&(rows>1)) {
			objtbl.rows[rows-1].click();
			SetFocusColumn("ItemQty",GetRow(rows-1));
			return;
		}
		if (SelectedRow==1) return;
		var objrow=objtbl.rows[SelectedRow-1];
		objrow.click();
		SetFocusColumn("ItemQty",GetRow(SelectedRow));
	}else if (keycode==40) {
		if ((SelectedRow==0)&&(rows>1)) {
			objtbl.rows[1].click();
			SetFocusColumn("ItemQty",GetRow(1));
			return;
		}
		if (SelectedRow==(objtbl.rows.length-1)) return;
		var objrow=objtbl.rows[SelectedRow+1];
		objrow.click();
		SetFocusColumn("ItemQty",GetRow(SelectedRow));
	}else if(keycode==115){
		AddClickHandler();
	}
}
function isNumber(objStr){
 strRef = "-1234567890.";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}
function SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
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
function GetRow(Rowindex){
	var objtbl=document.getElementById('tUDHCOEOrder_OSItem');
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}
function GetEventRow(e)
{
	var obj=websys_getSrcElement(e);
	var Id=obj.id;

	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1];
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);
	SelectedRow=TRSrc.rowIndex;
	return Row
}
function SetFocusColumn(ColName,Row){
	var obj=document.getElementById(ColName+"z"+Row);
	if (obj){websys_setfocus(ColName+"z"+Row)};
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tUDHCOEOrder_OSItem');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow==SelectedRow){
		SelectedRow=0;
	}else{
		SelectedRow=selectrow;
	}
	if (selectrow!="0") {
		var ItemQty='ItemQtyz'+selectrow;
		if(eSrc.id==ItemQty){
			var ItemQtyobj=document.getElementById("ItemQtyz"+selectrow);
			//ItemQtyobj.onchange =GetSum;
			ItemQtyobj.onblur =GetSum; 
		}
	}
	GetSum()
}
function SelectAllClickHandler(){
	var eTABLE=document.getElementById("tUDHCOEOrder_OSItem");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var Row=GetRow(i);
			var AddItemObj=document.getElementById("AddItemz"+Row);
			var descObj=document.getElementById("Item"+Row);
			if ((AddItemObj)&&(AddItemObj.disabled!=true)) AddItemObj.checked=true;
		}
	}
	GetSum()
}
function GetSum(){
	var Sum=0;
	var eTABLE=document.getElementById("tUDHCOEOrder_OSItem");
	var nowOrderPrior=document.getElementById("nowOrderPrior").value;
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			var ItemPriorRemarks=Trim(GetColumnData("ItemPriorRemarks",i));
			var CNMedItemFlag=Trim(GetColumnData("CNMedItemFlag",i));
			if((AddItemObj.checked)&&(+ItemPriorRemarks=="0")){ //
				var ItemPrice=document.getElementById("ItemPricez"+i).value;
				var OrderConFac=GetColumnData("OrderConFac",i);
				if (OrderConFac==""){
					OrderConFac=1	
				}
				var ItemFreqFactor=GetColumnData("ItemFreqFactor",i);
				if(ItemFreqFactor==""){
					ItemFreqFactor=1	
				}
				var BaseDoseQty=GetColumnData("BaseDoseQty",i);
				if(BaseDoseQty==""){
					BaseDoseQty=1
				}
				var DHCDocOrderType=Trim(GetColumnData("DHCDocOrderType",i));
				var ItemQty=GetColumnData("ItemQty",i);
				var ItemDoseQty=GetColumnData("ItemDoseQty",i);
				/*
				if(isNaN(ItemQty)){
					ItemQty=1
				}
				*/
				var ItemQty=GetColumnData("ItemQty",i);
				//alert(ItemPrice+"^"+ItemQty+"^"+OrderConFac+"^"+ItemFreqFactor+"^"+BaseDoseQty)
				if ((DHCDocOrderType=="临时医嘱")||(DHCDocOrderType=="出院带药")||((+DHCDocOrderType==0)&&(nowOrderPrior=="0"))){
					if (+ItemQty==0) ItemQty=1;
					if (+ItemDoseQty==0) ItemDoseQty=1;
					if (CNMedItemFlag=="1"){
						var OrderSum=parseFloat(ItemPrice)*parseFloat(ItemDoseQty)
					}else{
						var OrderSum=parseFloat(ItemPrice)*parseFloat(ItemQty)
					}
				}else{
					if (CNMedItemFlag=="1"){
						var OrderSum=parseFloat(ItemPrice)/OrderConFac*ItemFreqFactor*ItemDoseQty
					}else{
						var OrderSum=parseFloat(ItemPrice)/OrderConFac*ItemFreqFactor*BaseDoseQty
					}
					
				}
				/*if((ItemQty!=" ")&&((DHCDocOrderType=="临时医嘱")||(DHCDocOrderType=="出院带药")||((DHCDocOrderType=="")&&(nowOrderPrior=="0")))){
					if (ItemQty=="") ItemQty=1;
					var OrderSum=parseFloat(ItemPrice)*parseFloat(ItemQty)
				}else {
					var OrderSum=parseFloat(ItemPrice)/OrderConFac*ItemFreqFactor*BaseDoseQty
				}*/
				if(OrderSum==""){continue}		
				Sum=parseFloat(Sum)+parseFloat(OrderSum);
			}
			
		}
	}
	
	Sum=Sum.toFixed(4);
	var OrderSum=document.getElementById("OrderSum");
	//OrderSum.style.color = '#ff0000';
	OrderSum.style.fontSize = 18;
	OrderSum.style.disabled = false;
	OrderSum.value=Sum+"元"
}
function UnSelectAllClickHandler(){
	var eTABLE=document.getElementById("tUDHCOEOrder_OSItem");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var Row=GetRow(i);
			var AddItemObj=document.getElementById("AddItemz"+Row);
			var descObj=document.getElementById("Item"+Row);
			var OrderMustEnterObj=document.getElementById("OrderMustEnterz"+Row);
			if(OrderMustEnterObj){
				var OrderMustEnter=OrderMustEnterObj.value;
				var SeqNo=DHCC_GetColumnData("ItemSeqNo",i);
				if ((+SeqNo!=0)&&(OrderMustEnter!="Y")){
					//成组医嘱,判断是否有必填标志
					if (CheckLinkMustEnter(i)) OrderMustEnter="Y";
					var ItemStatusObj=document.getElementById("ItemStatusz"+Row);
					if (ItemStatusObj&&((ItemStatusObj.innerText=="停用")||(ItemStatusObj.innerText=="无权限"))) {
						OrderMustEnter="N";
					}
				}
				if(OrderMustEnter=="Y"){
					AddItemObj.checked=true
				}else{
				    if (AddItemObj) AddItemObj.checked=false;
			    }
			}
			
		}
	}
	GetSum();
}
function CheckLinkMustEnter(Row){
	var SeqNo=DHCC_GetColumnData("ItemSeqNo",Row);
	if (SeqNo.indexOf(".")) MasterSeqNo=SeqNo.split(".")[0];
	else  MasterSeqNo=SeqNo;
	var eTABLE=document.getElementById("tUDHCOEOrder_OSItem");
	if (eTABLE){
		for (var m=1; m<eTABLE.rows.length; m++) {
			if (m!=Row){
				var tmpSeqNo=DHCC_GetColumnData("ItemSeqNo",m);
				if (tmpSeqNo.indexOf(".")) tmpMasterSeqNo=tmpSeqNo.split(".")[0];
				else  tmpMasterSeqNo=tmpSeqNo;
				if (tmpMasterSeqNo==MasterSeqNo){
					var tmpOrderMustEnter=document.getElementById("OrderMustEnterz"+m).value;
					if (tmpOrderMustEnter=="Y") {
						return true;
						break;
					}
				}
				
			}
			
		}
	}
	return false;
}
function CanInsertRow(objtbl){
	var rows=objtbl.rows.length;
  	if (rows==1) return false;
	var Row=GetRow(MaxTblRowIndex);
	var ItemData=GetColumnData("ItemData",Row);
	if (ItemData==""){	
		SetFocusColumn("Item",Row);
		SelectedRow=MaxTblRowIndex;
		return false;
	}
	return true;
}
function InsertClickHandler() {
	//try {
		var objtbl=document.getElementById('tUDHCOEOrder_OSItem');
		var rows=objtbl.rows.length;
		if (MaxTblRowIndex==0){MaxTblRowIndex=rows-1}
		var ret=CanInsertRow(objtbl);
		if (ret) InsertRowToList(objtbl);
		//InsertRowToList(objtbl);
	    //可以控制屏幕不跳动
	    return false;
	//} catch(e) {};
}

function InsertRowToList(objtbl) {
	//alert(SelectedRow)
	if (SelectedRow==0) {
		alert("请先选择一行,然后点击[插入]按钮.");
		return false;
	}
	if ((SelectedRow=="")||(SelectedRow<=0)) return false;
	var PreRow=GetRow(SelectedRow);
	var PreSelectRowIndex=SelectedRow;
	var rows=objtbl.rows.length;
	var objlastrow=objtbl.rows[MaxTblRowIndex];
	//alert((rows-1)+","+MaxTblRowIndex+","+objlastrow)
	var objtbody=tk_getTBody(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=parseInt(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
			//alert(rowitems[j].id+","+rowitems[j].name+","+Id+","+SelectedRow)
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}
	
	//默认置上前一条的医嘱类型
	var PreDHCDocOrderType=GetColumnData("DHCDocOrderType",PreRow);
	var PreDHCDocOrderTypeID=GetColumnData("DHCDocOrderTypeID",PreRow);
	//alert(objnewrow.innerHTML)
	//alert("PreSelectRowIndex:"+PreSelectRowIndex);
  	var objcurrentrow=objtbl.rows[PreSelectRowIndex];
  	//objcurrentrow.click();
	objnewrow=objtbody.insertBefore(objnewrow,objcurrentrow);
	ChangeRowStyle(objnewrow,1,false,false,false);
	//alert(objnewrow.innerHTML)
	var Row=GetRow(objnewrow.rowIndex);
	SetColumnData("DHCDocOrderType",Row,PreDHCDocOrderType);
	SetColumnData("DHCDocOrderTypeID",Row,PreDHCDocOrderTypeID);
	websys_setfocus("Itemz"+Row);
	
	SelectedRow=objnewrow.rowIndex;
	MaxTblRowIndex=objnewrow.rowIndex;
	//alert("add:"+SelectedRow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}
function ChangeRowStyle(RowObj,EnablePackQty,EnableDuration,EnableFrequence,EnableInstruction){
	for (var j=0;j<RowObj.cells.length;j++) {
    	if (!RowObj.cells[j].firstChild) {continue} 
		var Id=RowObj.cells[j].firstChild.id;
		var arrId=Id.split("z");
		var objindex=arrId[1];
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		var IMGId="ldi"+Id;
		//alert("type:"+RowObj.cells[j].firstChild.type)
		//var objtype=RowObj.cells[j].firstChild.type;
		//if (objtype) {continue}
		
		//alert(RowObj.cells[j].style.height);
		/*
		1.RowObj.cells[i]本身是个对象,本身有Style属性,里面可以包含多个element(HIDDEN TableItem就全放在了一个Cell中)
		2.cells[j].firstChild是Cell里的第一个element,如果为label的话就没有type属性
		3.将element的类型改变,实际上是改变Cell的innerHTML,因为element.style是不允许改变的
		4.只有列不为Display only?不一定会有Style属性(可以参见网页源码),所以最好只将Display Only的列变为可编辑时候
		对innerHTML属性进行重新定义,否则容易造成列自动变为一个默认长度
		*/
		if (arrId[0]=="AddItem"){
			var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\">";
      		RowObj.cells[j].innerHTML=str;
		}
		if (arrId[0]=="Item"){
			objwidth=AdjustWidth(objwidth);
			var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"xItem_lookuphandler()\">";
			str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"xItem_lookuphandler()\">";
			RowObj.cells[j].innerHTML=str;
		}
		if (arrId[0]=="ItemQty"){
			objwidth=AdjustWidth(objwidth);
			var ItemQty="";
			var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\""+ItemQty+"\" onchange=\"OrderItemQtychangehandler()\" onkeypress=\"OrderItemQtykeypresshandler()\" onkeydown=\"OrderItemQtykeydownhandler()\">";
			RowObj.cells[j].innerHTML=str;
		}
		
		/*
		if (arrId[0]=="OrderInsurSignSymptom"){
			objwidth=AdjustWidth(objwidth);
			var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderInsurSignSymptom_lookuphandler()\">";
			str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"OrderInsurSignSymptom_lookuphandler()\">";
			RowObj.cells[j].innerHTML=str;
		}
			
		if (arrId[0]=="OrderSpeedFlowRate"){
			var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\"\" onchange=\"OrderSpeedFlowRate_changehandler()\" onkeypress=\"OrderSpeedFlowRatekeypresshandler()\">";
			RowObj.cells[j].innerHTML=str;
		}
		if (arrId[0]=="OrderNutritionDrugFlag"){
			var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onchange=\"OrderNutritionDrugChangehandler()\">";
      		RowObj.cells[j].innerHTML=str;
		}
		if (arrId[0]=="OrderCoverMainIns"){
			RowObj.cells[j].firstChild.disabled=false;
		}
		*/
	}
}
function xItem_lookuphandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var ItemzLookupGrid;
		var OrderName = GetColumnData("Item",Row);
		var Id='Itemz'+Row;
		var GroupID = session['LOGON.GROUPID'];
		var catID = "";
		var subCatID = "";
		var P5 = "";
		var LogonDep = session['LOGON.CTLOCID'];
		var OrderPriorRowid = "" ;
		var EpisodeID = "";
		var P9="",P10 = "";
		var OrdCatGrp = "";
		if (ItemzLookupGrid&&ItemzLookupGrid.store) {
			ItemzLookupGrid.searchAndShow([OrderName,GroupID,catID,subCatID,P5,LogonDep,OrderPriorRowid,EpisodeID,P9,P10,session["LOGON.USERID"],OrdCatGrp]);
		}else {
			ItemzLookupGrid = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: "医嘱项选择",
				lookupName: Id,
				listClassName: 'web.DHCDocOrderEntry',
				listQueryName: 'LookUpItem',
				resizeColumn: true,
					
				listProperties: [OrderName,GroupID,catID,subCatID,P5,LogonDep,OrderPriorRowid,EpisodeID,P9,P10,session["LOGON.USERID"],OrdCatGrp], 
				listeners:{'selectRow': OrderItemLookupSelect}		
			});
		}
	}
	return websys_cancel();
}
function OrderItemLookupSelect(txt) { 
	
	//alert(txt);
	var Row=GetRow(SelectedRow);
	SetColumnData("AddItem",Row,true);
	
	var adata=txt.split("^");
	
	var idesc=adata[0];
	var icode=adata[1];
	var ifreq=adata[2];
	var iordertype=adata[3];
	var ialias=adata[4];
	//OrderType for example:"R"
	var isubcatcode=adata[5];
	//alert("isubcatcode "+isubcatcode)
	var iorderCatID=adata[6];
	var iSetID=adata[7];
	var mes=adata[8];
	var irangefrom=adata[9];
	var irangeto=adata[10]
	var iuom=adata[11];								//计量 片
	var idur=adata[12];  
	var igeneric=adata[13];
	var match="notfound";
	var SetRef=1;
	var OSItemIDs=adata[15];
	var iorderSubCatID=adata[16];
	var BillUOM=adata[19]; 							//单位

	SetColumnData("ItemBillUOM",Row,BillUOM); 		//单位
	SetColumnData("ItemDoseUOM",Row,iuom);			//计量
	
	var Obj=document.getElementById('GetItmMessageById');
 	if(Obj) {var encmeth=Obj.value} else {var encmeth=''};
	var Str=cspRunServerMethod(encmeth,icode);
	
	if (Str!="")
	{
		var Str=Str.split("^");
		
		var BillUOMRowid=Str[4];
		var UOMDesc=Str[1];
		var UOMRowid=Str[2];
		var Freq=Str[5];
		var ARCIMRMFrequencyDR=Str[6];
		
		var FreqFactor=Str[7];
		var FreqInterval=Str[8];
		var ItemInstr=Str[9];
		
		var ItemInstrRowid=Str[10];
		var Dur=Str[11];
		var DurationDR=Str[12];
		var DurFactor=Str[13];
	 
	}


	
	window.focus();
	var Sep=String.fromCharCode(1);
	var ItemDoseQty=0;
	var ItemDoseUOM=UOMDesc;
	var ItemDoseUOMRowid=UOMRowid
	var ItemFreq=Freq;
	var ItemFreqRowid=ARCIMRMFrequencyDR;
	var ItemFreqFactor=FreqFactor;
	var ItemFreqInterval=FreqInterval;
	var ItemInstr="";
	var ItemInstrRowid="";
	var ItemDur=Dur;
	var ItemDurRowid=DurationDR;
	var ItemDurFactor=DurFactor;
	var ItemQty=GetColumnData("ItemQty",Row);
	var ItemBillUOM=BillUOM;
	var ItemBillUOMRowid=BillUOMRowid;
	var DHCDocOrderType=GetColumnData("DHCDocOrderType",Row);
	var DHCDocOrderTypeID=GetColumnData("DHCDocOrderTypeID",Row);
	var ARCOSRowid="";
	var ARCOSSubCatRowid="";
	var ItemRemark="";
	var ItemSpecCode=""
	var ItemSeqNo="";
	/*
	.s ItemData=ItemDoseQty_$C(1)_ItemDoseUOM_$C(1)_ItemDoseUOMRowid
	.s ItemData=ItemData_"^"_ItemFreq_$C(1)_ItemFreqRowid_$C(1)_ItemFreqFactor_$C(1)_ItemFreqInterval
	.s ItemData=ItemData_"^"_ItemInstr_$C(1)_ItemInstrRowid
	.s ItemData=ItemData_"^"_ItemDur_$C(1)_ItemDurRowid_$C(1)_ItemDurFactor
	.s ItemData=ItemData_"^"_ItemQty_$C(1)_ItemBillUOM_$C(1)_ItemBillUOMRowid
	.s ItemData=ItemData_"^"_DHCDocOrderType_$C(1)_DHCDocOrderTypeID_$C(1)_""
	.s ItemData=ItemData_"^"_ARCOSRowid
	.s ItemData=ItemData_"^^"_ARCOSSubCatRowid_"^"_ItemRemark_"^"_ItemSpecCode
	*/
	var ItemData=ItemDoseQty+Sep+ItemDoseUOM+Sep+ItemDoseUOMRowid
	ItemData=ItemData+"^"+ItemFreq+Sep+ItemFreqRowid+Sep+ItemFreqFactor+Sep+ItemFreqInterval
	ItemData=ItemData+"^"+ItemInstr+Sep+ItemInstrRowid
	ItemData=ItemData+"^"+ItemDur+Sep+ItemDurRowid+Sep+ItemDurFactor
	ItemData=ItemData+"^"+ItemQty+Sep+ItemBillUOM+Sep+ItemBillUOMRowid
	ItemData=ItemData+"^"+DHCDocOrderType+Sep+DHCDocOrderTypeID+Sep+""
	ItemData=ItemData+"^"+ARCOSRowid
	ItemData=ItemData+"^^"+ARCOSSubCatRowid+"^"+ItemRemark+"^"+ItemSpecCode
	//alert(ItemData)
	SetColumnData("ItemBillUOM",Row,BillUOM); 	//单位
	SetColumnData("ItemDoseUOM",Row,iuom);		//计量
	SetColumnData("ItemQty",Row,0); 			//数量
	SetColumnData("ItemDoseQty",Row,0); 		//剂量

	SetColumnData("ItemRowid",Row,icode);
	SetColumnData("ItemData",Row,ItemData);
	SetColumnData("ItemOrderType",Row,isubcatcode);
	SetColumnData("ItemSeqNo",Row,ItemSeqNo);

	SetFocusColumn("ItemQty",Row);
}
//如果有图标和元素在同一列里?要调整元素的宽度
function AdjustWidth(objwidth){
  if (objwidth!=""){
  	 var objwidtharr=objwidth.split("px")
  	 var objwidthnum=objwidtharr[0]-25;
  	 objwidth=objwidthnum+"px"
  }
	return objwidth
}

function AddClickHandler() {
	SetCopyData('');
}

function CopyShortClickHandler(){
	SetCopyData(2);
}
function CopyLongClickHandler(){
	SetCopyData(3);
}
function SetCopyData(type){
	
	var objshort=document.getElementById("DefShortPriorRowid");
	if (objshort){var DefShortPriorRowid=objshort.value}

	var objlong=document.getElementById("DefLongPriorRowid");
	if (objlong){var DefLongPriorRowid=objlong.value}

	var OrderPrior="";
	var OrderPriorRowid='';
	
	if ((type==2)&&(DefShortPriorRowid!="")){
    OrderPrior="";
    OrderPriorRowid=DefShortPriorRowid;
  }
  if ((type==3)&&(DefLongPriorRowid!="")){
    OrderPrior="";
    OrderPriorRowid=DefLongPriorRowid;
  }

 	var Copyary=new Array();
	var par_win = window.opener;
     
	//try {
		var eTABLE=document.getElementById("tUDHCOEOrder_OSItem");
		for (var i=1; i<eTABLE.rows.length; i++) {
			
			var Row=GetRow(i);
			var AddItemObj=document.getElementById("AddItemz"+Row);
			if (AddItemObj.checked) {
				var code=GetColumnData("ItemRowid",Row);
				var ItemData=GetColumnData("ItemData",Row);
				var Type=GetColumnData("ItemOrderType",Row);
				var ItemQty=GetColumnData("ItemQty",Row);
				var ItemDoseQty=GetColumnData("ItemDoseQty",Row);
				var CNMedItemFlag=GetColumnData("CNMedItemFlag",Row);
			    var OrderSeqNo="";
				var obj=document.getElementById("ItemSeqNoz"+Row);
				if (obj) {
					OrderSeqNo=obj.innerHTML;
					if (OrderSeqNo=="&nbsp;") OrderSeqNo="";
				}
				var Urgent=GetColumnData("Urgent",Row);
				var TempArr=new Array();
				TempArr=ItemData.split("^");
				var ITMRowId=TempArr[13];
				var TempItemArr=TempArr[4].split(String.fromCharCode(1));
				if (CNMedItemFlag=="1"){
					TempArr[0]=ItemDoseQty;
				}else{
					TempItemArr[0]=ItemQty;
				}
				TempArr[4]=TempItemArr.join(String.fromCharCode(1));
				//TempArr[5]=OrderPrior+String.fromCharCode(1)+OrderPriorRowid;
				var OrderPriorRemarksDR=GetColumnData("OrderPriorRemarksDR",Row);
				TempArr[10]=OrderPriorRemarksDR
				TempArr[12]=Urgent
				TempArr[13]=ITMRowId
				ItemData=TempArr.join("^");
				Copyary[Copyary.length]=code+"!"+OrderSeqNo+"!"+ItemData+"!"+Type+"!"+"!"+""+"!"+"OSItem";

			}
		}
		if ((par_win)&&(Copyary.length!=0)){
		
			//par_win.AddOSItemToList(code,ItemData)
			par_win.AddCopyItemToList(Copyary);
		}
		window.setTimeout("Add_click();",300);
	//}catch(e){alert(e.message)}
}

function OrderDetails(e){
	var src=websys_getSrcElement(e);
	if (src.tagName == "A") return;
	if (src.id.substring(0,8)=="AddItemz")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj=document.getElementById("AddItemz"+rowsel);
		if (obj) {
			var SeqNo=DHCC_GetColumnData("ItemSeqNo",rowsel);
			var arry1=SeqNo.split(".");
			if ((arry1.length>=1)&&(+arry1[0]!=0)) {
				var OrderMustEnter="";
				var OrderMustEnterObj=document.getElementById("OrderMustEnterz"+rowsel);
		    	if(OrderMustEnterObj){
			    	OrderMustEnter=OrderMustEnterObj.value;
			    }
				var MasterSeqNo=arry1[0];
				ChangelLinkItemSelect(MasterSeqNo,obj.checked,OrderMustEnter);
			}
			GetSum();
		}
	}
}

function ChangelLinkItemSelect(MasterSeqNo,checkflag,OrderMustEnter){
    try{
			var eTABLE=document.getElementById("tUDHCOEOrder_OSItem");
			for (var k=1; k<eTABLE.rows.length; k++) {
				var AddItemObj=document.getElementById("AddItemz"+k);
				var SeqNo=DHCC_GetColumnData("ItemSeqNo",k)
				if (+SeqNo==0) continue;
				//if ((SeqNo=="")||(SeqNo==" ")) continue;
				var arry=SeqNo.split(".");
				if (arry[0]==MasterSeqNo) {
					DHCC_SetColumnData("AddItem",k,checkflag)
					if (OrderMustEnter=="Y"){
						AddItemObj.checked=true;
						AddItemObj.disabled=true;
					}
				}
			}
    }catch(e){alert(e.message)}
}
function Trim(str)
{
	//return str.replace(/[\t\n\r ]/g, "");
	return str.replace(/\s/g,"");
}

function SetLinkItemStyle()
{

	var objtbl=document.getElementById("tUDHCOEOrder_OSItem");
	for (var i=1; i<objtbl.rows.length; i++) {
	    var SeqNo=DHCC_GetColumnData("ItemSeqNo",i);
		var RowObj=objtbl.rows[i];
		if ((SeqNo=="") || (SeqNo.indexOf(".")>-1)) continue;
		var objtbl1=document.getElementById("tUDHCOEOrder_OSItem");
        for (var j=1; j<objtbl1.rows.length; j++) {
	         var SeqNo1=DHCC_GetColumnData("ItemSeqNo",j);
		     var RowObj1=objtbl.rows[j];
		     if (SeqNo1.indexOf(".")==-1) continue;
		     var arry=SeqNo1.split(".");
		     if (arry[0]==SeqNo){
				RowObj.className="OrderMasterM";
				RowObj1.className="OrderMasterS";
			 }
	    }
	}
}

