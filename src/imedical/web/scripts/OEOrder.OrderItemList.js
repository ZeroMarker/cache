// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	var tblOrdItemOS=document.getElementById("tOEOrder_OrderItemOSList");
	var tblOrdItem=document.getElementById("tOEOrder_OrderItemList");

	var selObj=document.getElementById("selectAll")
	if (selObj) selObj.onclick=SelectClickHandler;

	var selObj=document.getElementById("unselectAll")
	if (selObj) selObj.onclick=SelectClickHandler;
	
	var addObj=document.getElementById("AddItem")
	if (addObj) addObj.onclick=AddNewItemClickHandler;
	
	var updObj=document.getElementById("update")
	if (updObj) updObj.onclick=UpdateClickHandler;
	
	var updObj=document.getElementById("updateclose")
	if (updObj) updObj.onclick=UpdateCloseClickHandler;
	
	//var rcobj=document.getElementById("RecLocation")
	//if (rcobj) rcobj.onchange=RecLocChangeHandler;
	
	var ReadOnly=false;
	var roObj=document.getElementById("ReadOnly")
	

	//var ReadyForBilling="ReadyForBilling"
	var rbobj=document.getElementById("ReadyForBilling")
	if (rbobj && roObj && rbobj.checked) roObj.value=1;
	
	if (roObj.value==1) {
		var upd=document.getElementById("update")
		if (upd) upd.disabled=true
		var updcls=document.getElementById("updateclose")
		if (updcls) updcls.disabled=true
	}
	
	var checkAll=1
	
	if (roObj && roObj.value==1) {
		ReadOnly=true;
		var obj=document.getElementById("ld2118iRecLocation")
		if (obj) obj.disabled=true;
		var obj=document.getElementById("ld2118iItem")
		if (obj) obj.disabled=true;
		var obj=document.getElementById("AddItem")
		if (obj) obj.disabled=true;
	}

	if (tblOrdItem){
		for (var i=1; i<tblOrdItem.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if (AddItemObj && AddItemObj.checked) checkAll=0;
			var QuantityObj=document.getElementById("Quantityz"+i);
			var TypeObj=document.getElementById("Typez"+i);
			var PartSelObj=document.getElementById("PartialSelectionz"+i);
			if (AddItemObj && TypeObj) {
				if (TypeObj.value=="ARCOS") {
					//AddItemObj.outerHTML="<LABEL id=AddItemz"+i+" name=AddItemz"+i+">";
					QuantityObj.outerHTML="<LABEL id=Quantityz"+i+" name=Quantityz"+i+">";
					if (PartSelObj && PartSelObj.value==1) {
						AddItemObj.className="clsPartialSelect";
						//AddItemObj.style.backgroundColor="#ffff99";
						AddItemObj.title=t["PartialSelect"];
					}
					AddItemObj.onclick=AddItemClickHandler;
				}
			}
		}
	}
	var cnt=0
	var cnt2=0
	var cnt3=0
	var prevSrcAry=0
	arrCx=document.getElementsByTagName("INPUT");
	for (var i=0; i<arrCx.length; i++) {
		var eSrcAry=arrCx[i].id.split("z");
		if (ReadOnly) {
			arrCx[i].disabled=true; 
			if (arrCx[i].type!="checkbox") arrCx[i].className="disabledField";
		}
		if (arrCx[i].type=="checkbox" && eSrcAry[0]=="AddItemOS") {
			if (eSrcAry[1]==1) cnt=cnt+1
			arrCx[i].id="AddItemOSz"+eSrcAry[1]+"y"+cnt
			arrCx[i].onclick=AddItemClickHandler;
			prevSrcAry=eSrcAry[1]
		}
		if (arrCx[i].type=="checkbox" && eSrcAry[0]=="AddItem") {
			arrCx[i].onclick=ClearQtyClickHandler;
		}
		if (arrCx[i].type=="hidden" && eSrcAry[0]=="AddItemVal") {
			if (eSrcAry[1]==1) cnt2=cnt2+1
			arrCx[i].id="AddItemValz"+eSrcAry[1]+"y"+cnt2
		}
		if (arrCx[i].type=="hidden" && eSrcAry[0]=="OrderSetID") {
			if (eSrcAry[1]==1) cnt3=cnt3+1
			arrCx[i].id="OrderSetIDz"+eSrcAry[1]+"y"+cnt3
		}
	}
	
	var Ary=new Array();
	Ary=["Password","UserCode"]
	for (var i=0; i<Ary.length; i++) {
		var obj=document.getElementById(Ary[i])
		if (obj) {
			obj.disabled=false;
			obj.className="";
		}
	}
	
	if (checkAll==1) {
		var obj=document.getElementById("selectAll")
		if (obj) obj.click()
	}

	LoadRecLocation(); 

}

function SelectClickHandler(evt){
	var el = websys_getSrcElement(evt);
	var eSrcAry1=el.id.split("z");
	var lblName=eSrcAry1[0]
	var value=true;
	if (lblName=="unselectAll") value=false;
	var eTABLE=document.getElementById("tOEOrder_OrderItemList");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if ((AddItemObj)&&(AddItemObj.disabled!=true)) {
				AddItemObj.checked=value;
			}
		}
	}
	var arrCx=document.getElementsByTagName("INPUT");
	for (var i=0; i<arrCx.length; i++) {
		var eSrcAry2=arrCx[i].id.split("z");
		if (arrCx[i].type=="checkbox" && eSrcAry2[0]=="AddItemOS") {
			if ((arrCx[i])&&(arrCx[i].disabled!=true)) {
				if (lblName=="unselectAll" && arrCx[i].checked) arrCx[i].click();
				if (lblName=="selectAll" && !arrCx[i].checked) arrCx[i].click();
			}
		}
	}
	return false;
}

function SelectOSClickHandler(osId,val) {
	var OrderSetID=""
	var arrCx=document.getElementsByTagName("INPUT");
	for (var i=0; i<arrCx.length; i++) {
		if (arrCx[i].id!="") {
			var eSrcAry2=arrCx[i].id.split("z");
			var osObj=document.getElementById("OrderSetIDz"+eSrcAry2[1]);
			if (osObj) OrderSetID=osObj.value;
			if (arrCx[i].type=="checkbox" && eSrcAry2[0]=="AddItemOS" && osId==OrderSetID) {
				if ((val==1) && (!arrCx[i].checked)) arrCx[i].click();
				if ((val==0) && (arrCx[i].checked)) arrCx[i].click();
			}
		}
	}
	return false;
}

function AddItemClickHandler(evt) {
	var el = websys_getSrcElement(evt);
	var eSrcAry=el.id.split("z");
	var tblOrdItem=document.getElementById("tOEOrder_OrderItemList");
	var AddItemVal=document.getElementById("AddItemValz"+eSrcAry[1]);
	if (!AddItemVal) var AddItemVal=document.getElementById("AddItemValz1");
	if (AddItemVal) {
		AddItemVal.value=0
		if (el && el.checked) AddItemVal.value=1
	}
	if (eSrcAry[0]=="AddItemOS") {
		var osId=document.getElementById("OrderSetIDz"+eSrcAry[1]).value
		if (tblOrdItem){
			for (var i=1; i<tblOrdItem.rows.length; i++) {
				var id=document.getElementById("IDz"+i)
				if (id && id.value==osId) {
					var AddItemObj=document.getElementById("AddItemz"+i);
					if (AddItemObj) {
						var noItems=document.getElementById("noItemsSelectedz"+i)
						var noItemsTotal=document.getElementById("noItemsz"+i)
						if (noItems) {
							if (el.checked) noItems.value=parseInt(noItems.value)+1
							if (!el.checked) noItems.value=parseInt(noItems.value)-1
							var PartSelObj=document.getElementById("PartialSelectionz"+i);
							if (noItems.value!=0) {
								AddItemObj.className="clsPartialSelect";
								//AddItemObj.style.backgroundColor="#ffff99";
								AddItemObj.checked=true;
								AddItemObj.title=t["PartialSelect"];
								if (PartSelObj) PartSelObj.value=1;
							} else {
								AddItemObj.className="";
								//AddItemObj.style.backgroundColor="";
								AddItemObj.title="";
								AddItemObj.checked=false;
								if (PartSelObj) PartSelObj.value=0;
							}
							//alert(noItemsTotal.value)
							if (noItemsTotal && noItemsTotal.value==noItems.value) {
								AddItemObj.className="";
								//AddItemObj.style.backgroundColor="";
								AddItemObj.title="";
								AddItemObj.checked=true;
								if (PartSelObj) PartSelObj.value=0;
							}
							if (noItems.value<0) {
								noItems.value=0
							}
						}
					}
				}
			}
		}
		
	}
	var typeObj=document.getElementById("Typez"+eSrcAry[1])
	if (typeObj && typeObj.value=="ARCOS") {
		var osId=document.getElementById("IDz"+eSrcAry[1]).value
		SelectOSClickHandler(osId,AddItemVal.value);
	}
	
}

function ItemLookUpHandler(str) {
	var obj=document.getElementById("ItemStr")
	if (obj) obj.value=str
}

function AddNewItemClickHandler() {
	var objAdd=document.getElementById("AddItem")
	if (objAdd && objAdd.disabled) return false;
	var obj=document.getElementById("ItemStr")
	if (obj && obj.value=="") {
		alert(t["SelectOrderItem"]);
		return false;
	}

	return AddItem_click();
}


function UpdateClickHandler() {
	var ReadOnly=false;
	var roObj=document.getElementById("ReadOnly")
	if (roObj && roObj.value==1) ReadOnly=true;
	
	if (ReadOnly==true) return false;
	
	if(!RecLocationCheck()) return false; 
	
	arrCx=document.getElementsByTagName("INPUT");
	for (var i=0; i<arrCx.length; i++) {
		var eSrcAry=arrCx[i].id.split("z");
		if (ReadOnly) arrCx[i].disabled=false; 
	}
	return update_click();
}

function UpdateCloseClickHandler() {
	var ReadOnly=false;
	var roObj=document.getElementById("ReadOnly")
	if (roObj && roObj.value==1) ReadOnly=true;
	
	if (ReadOnly==true) return false;
	
	if(!RecLocationCheck()) return false; 
	
	arrCx=document.getElementsByTagName("INPUT");
	for (var i=0; i<arrCx.length; i++) {
		var eSrcAry=arrCx[i].id.split("z");
		if (ReadOnly) arrCx[i].disabled=false; 
	}
	return updateclose_click();
}

function ClearQtyClickHandler(evt) {
	var el = websys_getSrcElement(evt);
	var eSrcAry=el.id.split("z");
	var objQty=document.getElementById("Quantityz"+eSrcAry[1]);
	if (objQty) objQty.value=""
}

//log58216 TedT Receiving location is not mandatory field
function RecLocationCheck() {
	return true;

}

function LoadRecLocation() {
}

document.body.onload = BodyLoadHandler;