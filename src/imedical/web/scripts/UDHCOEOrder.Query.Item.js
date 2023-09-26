document.body.onload = BodyLoadHandler;

function BodyLoadHandler(){
	var obj=document.getElementById("Add");
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById("CopyShort");
	if (obj) obj.onclick=CopyShortClickHandler;
	var obj=document.getElementById("CopyLong");
	if (obj) obj.onclick=CopyLongClickHandler;
	obj=document.getElementById("SelectAll");
	var obj=document.getElementById("Find");
	if (obj) obj.onclick=FindClickHandler;
	
}


function SelectAllClickHandler(e){
 // alert("ss");
  var obj=document.getElementById("SelectAll");
  var Objtbl=document.getElementById('tUDHCOEOrder_Item_List');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('AddItemz'+i);  
	selobj.checked=obj.checked;  
	}
}
//add at HF 2007.1.14
function FindClickHandler(){
	var Days=document.getElementById("Days").value;
	var DaysLimitobj=document.getElementById("QueryItemDayLimit");
	if (DaysLimitobj) {var DaysLimit=DaysLimitobj.value;}else{var DaysLimit=0}
	if (DaysLimit=="") {DaysLimit=0;}
	if ((DaysLimit>0)&&(Days>DaysLimit)){
		alert(t['Days_Long']+DaysLimit);
	}else{
		Find_click();
	}
	
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
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj.tagName=='LABEL'){
		return CellObj.innerText;
	}else{
		if (CellObj.type=="checkbox"){
			return CellObj.checked;
		}else{
			return CellObj.value;}
		}
	return "";
}

function AddClickHandler(){
	var Copyary=new Array();
	
    var objshort=document.getElementById("DefShortPriorRowid");
    if (objshort){var DefShortPriorRowid=objshort.value}
    var objlong=document.getElementById("DefLongPriorRowid");
    if (objlong){var DefLongPriorRowid=objlong.value}
    var ReturnStr=""
	var par_win = window.opener;
    try{
		var eTABLE=document.getElementById("tUDHCOEOrder_Query_Item");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if (AddItemObj.checked) {
				var Rowid=GetColumnData("Rowid",i);
				var Type=GetColumnData("OrderType",i);
		        var ItemData=Rowid+"!"+""+"!"+""+"!"+Type;
				Copyary[Copyary.length]=ItemData
			}
		}
    }catch(e){alert(e.message)}
	if ((par_win)&&(Copyary.length!=0)){
		par_win.AddCopyItemToList(Copyary);
	}
	window.setTimeout("Add_click();",500);
}
