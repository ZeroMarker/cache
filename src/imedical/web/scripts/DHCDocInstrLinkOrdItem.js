document.body.onload = BodyLoadHandler;

function BodyLoadHandler() {
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAllClickHandler;
	var obj=document.getElementById("Add");
	if (obj)  obj.onclick=AddClickHandler;
	websys_setfocus("SelectAll")
}
function SelectAllClickHandler(){
	var eTABLE=document.getElementById("tDHCDocInstrLinkOrdItem");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			var descObj=document.getElementById("Item"+i);
			if ((AddItemObj)&&(AddItemObj.disabled!=true)) AddItemObj.checked=true;
		}
	}
	if (keycode=13)
	{
		websys_setfocus("Add")
	}
}
function AddClickHandler() {
	var Copyary=new Array();
	try{
	if (window.opener.parent.right) {
		var par_win = window.opener.parent.right.maindata.dataframe184;
	}else{
		var par_win = window.opener.parent.parent.right.maindata.dataframe184;
	}
	}catch(e){}
	var eTABLE=document.getElementById("tDHCDocInstrLinkOrdItem");
	for (var i=1; i<eTABLE.rows.length; i++) {
		var AddItemObj=document.getElementById("AddItemz"+i);
		if (AddItemObj.checked) {
			var CodeObj=document.getElementById("ItemRowidz"+i);
			var code=CodeObj.value;
			var TypeObj=document.getElementById("ItemOrderTypez"+i);
			var Type=TypeObj.value;
			var OrderSeqNo="";
			//alert(Copyary.length)
			Copyary[Copyary.length]=code+"!"+OrderSeqNo+"!"+""+"!"+Type+"!"+"";

		}
	}	
  var obj=document.getElementById("MasterOrderItemRowId");
  if (obj)  var MasterOrderItemRowId=obj.value;
  var obj=document.getElementById("MasterOrderSeqNo");
  if (obj)  var MasterOrderSeqNo=obj.value;
  var obj=document.getElementById("MasterOrderPriorRowid");
  if (obj)  var MasterOrderPriorRowid=obj.value;
  var obj=document.getElementById("MasterOrderFreqRowid");
  if (obj)  var MasterOrderFreqRowid=obj.value;
  var obj=document.getElementById("MasterOrderStartDate");
  if (obj)  var MasterOrderStartDate=obj.value;
  if ((par_win)&&(Copyary.length!=0)){
		par_win.AddLinkItemToList(Copyary,MasterOrderItemRowId,MasterOrderSeqNo,MasterOrderPriorRowid,MasterOrderFreqRowid,MasterOrderStartDate);
	}
  window.setTimeout("Add_click();",300);
  window.close();

} 
