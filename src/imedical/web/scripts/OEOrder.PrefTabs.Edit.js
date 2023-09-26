// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var MAXGROUPS=5;
var itemdataDelim = String.fromCharCode(4);
var groupitemDelim = String.fromCharCode(28);
var tabgroupDelim = String.fromCharCode(1);
var selectedGrp="1";
var NoNeedSaveFlag=0;
// 
function ExportTabsClicked()
{
   var OEOrderStr="";
   for(k=1;k<6;k++){
    var obj = document.getElementById("NAMEGroup"+k);
	if (obj) StrNAMEGroup = obj.value;
	if (StrNAMEGroup == '') StrNAMEGroup = '标签'+k;
	if (OEOrderStr =='') 
	{
		OEOrderStr = StrNAMEGroup +'\n';
	}
	else
	{
		OEOrderStr = OEOrderStr+ '\n\n' + StrNAMEGroup +'\n';
	}
  	var OEOrderListObj=document.getElementById("LISTGroup"+k);
  	if (!OEOrderListObj) continue;
   	if(OEOrderListObj){
        for (i = 0; i < OEOrderListObj.length; i++) {
        //if (OEOrderListObj.options[i].selected==false) continue;
        var OEOrderValue= OEOrderListObj.options[i].value;
		var lu=OEOrderValue.split(itemdataDelim);
		var type=lu[0];
		var code=lu[1]
        var OEOrderText = OEOrderListObj.options[i].text;
        if ((OEOrderValue != '') & (OEOrderText != '')) {
        if (OEOrderStr == '') {
          OEOrderStr = OEOrderValue
        } else {
          OEOrderStr = OEOrderStr  + '\n' + OEOrderText

        }
      }
    }
  }
 } 
  if(window.clipboardData) {   
              window.clipboardData.clearData();   
              window.clipboardData.setData("Text", OEOrderStr);
            alert("复制成功");
               
      }  	
}
function CopyAllToClipboard()
{
	
   var DiagnosStr = '';
   var GroupCount=0;
   for(l=1;l<6;l++){
  		var NAMEGroupObj=document.getElementById("NAMEGroup"+l);
  		if (!NAMEGroupObj) continue;
  		//if (NAMEGroupObj.value=="") NAMEGroupObj.value="未定义"
		if (GroupCount==0) {
			DiagnosStr=NAMEGroupObj.value;
		}else{
			DiagnosStr = DiagnosStr + String.fromCharCode(2) + NAMEGroupObj.value;
		}
		GroupCount=GroupCount+1;
   }
   DiagnosStr=DiagnosStr + 'DHCCCDHCCA'
   //var DiagnosStr = 'DHCCA';
   for(k=1;k<6;k++){
  	var DiagnosListObj=document.getElementById("LISTGroup"+k);
  	if (!DiagnosListObj) continue;
   	if(DiagnosListObj){
	   	if (k > 1)
	   	{DiagnosStr = DiagnosStr + "DHCCBDHCCA"
		   	}
        for (i = 0; i < DiagnosListObj.length; i++) {
        //if (DiagnosListObj.options[i].selected==false) continue;
        var DiagnosValue= DiagnosListObj.options[i].value;
		var lu=DiagnosValue.split(itemdataDelim);
		var type=lu[0];
		var code=lu[1]
        var DiagnosText = DiagnosListObj.options[i].text;
        if ((DiagnosValue != '') & (DiagnosText != '')) {
        if (DiagnosStr == '') {
          DiagnosStr = DiagnosValue
        } else {
          DiagnosStr = DiagnosStr + String.fromCharCode(2) + DiagnosText +'^'+code+'^'+type
        }
      }
    }
  }
 } 
  if(window.clipboardData) {   
              window.clipboardData.clearData();   
              window.clipboardData.setData("Text", DiagnosStr);
            alert("复制成功");   
      }  
 }
function BPasteAll(){
 	 var PasteText=window.clipboardData.getData("text");
 	 var PasteHead=PasteText.split("DHCCC");
	 if (PasteText.indexOf('DHCCCDHCCA')==-1){alert('粘贴板里面的内容不是使用<复制全部医嘱>获得的数据');return}
 	 var PasteHeadItem=PasteHead[0].split(String.fromCharCode(2));
   for(l=1;l<6;l++){
  		var NAMEGroupObj=document.getElementById("NAMEGroup"+l);
  		if (!NAMEGroupObj) continue;
		NAMEGroupObj.value = PasteHeadItem[l - 1]
   }

 	 PasteAllArray=PasteHead[1].split("DHCCB");
 	 for (k = 0; k < PasteAllArray.length; k++) {
	 	 var Pasteitem=PasteAllArray[k]
		 var PasteArray=Pasteitem.split(String.fromCharCode(2));
		 if (PasteArray[0]!='DHCCA'){alert('粘贴板里面的内容不是科室诊断');return}
		 if (k>5) return;
		 DiagnosListObj = document.getElementById('LISTGroup' + (k+1));
		 if (!DiagnosListObj){return;}
		 for(i=1;i<PasteArray.length;i++){
			var lu=PasteArray[i].split("^");
			var DiagnosDesc=lu[0];
			var Diagnosvalue=lu[1];
			var type=lu[2];
			code = type+itemdataDelim+Diagnosvalue;
			if (DiagnosListObj) AddItemSingle(DiagnosListObj,code,DiagnosDesc);
	      //DiagnosListChangeFlag = true;
			}
 	 }
	alert("粘贴结束");
	}
function copyToClipboard()
{
   var DiagnosStr = 'DHCCA';
   for(k=1;k<6;k++){
  	var DiagnosListObj=document.getElementById("LISTGroup"+k);
  	if (!DiagnosListObj) continue;
   	if(DiagnosListObj){
        for (i = 0; i < DiagnosListObj.length; i++) {
        if (DiagnosListObj.options[i].selected==false) continue;
        var DiagnosValue= DiagnosListObj.options[i].value;
		var lu=DiagnosValue.split(itemdataDelim);
		var type=lu[0];
		var code=lu[1]
        var DiagnosText = DiagnosListObj.options[i].text;
        if ((DiagnosValue != '') & (DiagnosText != '')) {
        if (DiagnosStr == '') {
          DiagnosStr = DiagnosValue
        } else {
          DiagnosStr = DiagnosStr + String.fromCharCode(2) + DiagnosText +'^'+code+'^'+type
        }
      }
    }
  }
 } 
  if(DiagnosStr=='DHCCA') {
	 alert("请选择需要复制的项目!")
	 return false;
  }
  if(window.clipboardData) {   
              window.clipboardData.clearData();   
              window.clipboardData.setData("Text", DiagnosStr);
            alert("复制成功");   
      }  
 }
 

function BPasteFun(){
/*
	if (PrivateChangeFlag == true) {
    var PrivateChangeFlagMessage = window.confirm('是否保存个人模板显示顺序的修改');
    if (PrivateChangeFlagMessage == true) {
      PrivateorderSaveFUN();
    }
  }
  if (DiagnosListChangeFlag == true) {
    var DiagnosListChangeMessage = window.confirm('是否保存个人模板 ' + FristPrivteDesc + ' 的修改');
    if (DiagnosListChangeMessage == true) {
      var USERID = session['LOGON.USERID'];
      for (k = 1; k < 6; k++) {
        var DiagnosListObj = document.getElementById('LISTGroup' + k);
        var DiagnosStr = '';
        for (i = 0; i < DiagnosListObj.length; i++) {
          var DiagnosValue = DiagnosListObj.options[i].value;
          var DiagnosText = DiagnosListObj.options[i].text;
          if ((DiagnosValue != '') & (DiagnosText != '')) {
            if (DiagnosStr == '') {
              DiagnosStr = DiagnosValue
            } else {
              DiagnosStr = DiagnosStr + '^' + DiagnosValue
            }
          }
        }
        var PrivateSaveMethod = document.getElementById('PrivateSaveMethod').value;
        Ret = cspRunServerMethod(PrivateSaveMethod, USERID, FristPrivteValue, DiagnosStr, k);
      }
    }
  }
    var ListNum = '';
  ListNum = SetListFocus();
  var PrivateListObj = document.getElementById('PrivateList');
  var PrivateListselIndex = PrivateListObj.selectedIndex;
  if ((ListNum == '') || (!ListNum)) {
    if (PrivateListselIndex < 0) {
      alert('没有选择个人模板并且没有选择下面的列表框');
      combo_DiagnosDesc.setComboText('');
      combo_DiagnosDesc.setComboValue('');
      combo_DiagnosDesc.clearAll();
      return;
    } else {
      alert('请选择下面的列表框');
      combo_DiagnosDesc.setComboText('');
      combo_DiagnosDesc.setComboValue('');
      combo_DiagnosDesc.clearAll();
      return;
    }
  }
  if (PrivateListselIndex < 0) {
    alert('没有选择个人模板');
    combo_DiagnosDesc.setComboText('');
    combo_DiagnosDesc.setComboValue('');
    combo_DiagnosDesc.clearAll();
    return;
  }*/
 	 PasteText=window.clipboardData.getData("text");
	 PasteArray=PasteText.split(String.fromCharCode(2));
	 if (PasteArray[0]!='DHCCA'){alert('粘贴板里面的内容不是使用<复制医嘱>获得的数据');return}
	 DiagnosListObj = document.getElementById('LISTGroup' + selectedGrp);
	 if (!DiagnosListObj){return;}
	 for(i=1;i<PasteArray.length;i++){
		var lu=PasteArray[i].split("^");
		var DiagnosDesc=lu[0];
		var Diagnosvalue=lu[1];
		var type=lu[2];
		code = type+itemdataDelim+Diagnosvalue;
		if (DiagnosListObj) AddItemSingle(DiagnosListObj,code,DiagnosDesc);
      //DiagnosListChangeFlag = true;
		}
	alert("粘贴结束");
	}
function LISTGroupDblClkHandler() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		//if (lst) lst.ondblclick=OrderDetailsClickHandler;
		if (lst) lst.ondblclick=ShowOrderDetails;
	}
}

function ItemHasDefaultHandler() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		//  20090328
		var lst = document.getElementById("LISTGroup" + i);
		if (lst) {
			for (var j=0; j<lst.options.length; j++) {
				ItemValue=lst.options[j].value;
				if((ItemValue)&&(ItemValue.charAt(ItemValue.length-1)=="Y")) lst.options[j].style.color="Blue";
				ItemText=lst.options[j].text;
				SubItemText=ItemText.split(" - ");
				if (SubItemText.length >1)
				{
					NewItemText=SubItemText[1];
					lst.options[j].text=NewItemText;
				}
			}
		}
	}
}


function UpdateClickHandler() {
   if (evtTimer) {
		setTimeout('UpdateClickHandler();',200)
   } else {
	if (window.opener) {
		var lstTabs=window.opener.lstTabs;
		if (lstTabs) {
			var itm=lstTabs.options[lstTabs.selectedIndex];
			if (itm) {
				var maxlimit=MAXGROUPS+1;
				var arrLstItems = new Array(MAXGROUPS);
				for (var i=1; i<maxlimit; i++) {
					var arrItems = new Array();
					var lst = document.getElementById("LISTGroup" + i);
					if (lst) {
						for (var j=0; j<lst.options.length; j++) {
							var ItemID=lst.options[j].value;
							//alert("ItemID:"+ItemID);
							if(ItemID!="") ItemID=ItemID.replace("Y","");
							arrItems[j] = ItemID;
						}
						var obj = document.getElementById("NAMEGroup" + i);
						if (obj) desc=obj.value; else desc="";
						arrLstItems[i-1] = desc+groupitemDelim+arrItems.join(groupitemDelim);
					}
				}
				var obj = document.getElementById("TabDesc");
				if ((obj)&&(obj.value!="")) {itm.text = obj.value;itm.selected=true;}
				//itm.value = arrLstItems.join(tabgroupDelim);
				var val = arrLstItems.join(tabgroupDelim);
				
				var obj = document.getElementById("OrderCategory");
				if ((obj)&&(obj.value!="")) {
					if (obj.className=="clsInvalid") {
						alert(t['OrderCategory']+" "+t['XINVALID']);
						websys_setfocus('OrderCategory');
						return false;
					}
					val += tabgroupDelim + obj.value;
				} else val += tabgroupDelim;
				var obj = document.getElementById("OrderSubcategory");
				if ((obj)&&(obj.value!="")) {
					if (obj.className=="clsInvalid") {
						alert(t['OrderSubcategory']+" "+t['XINVALID']);
						websys_setfocus('OrderSubcategory');
						return false;
					}
					val += tabgroupDelim + obj.value;
				} else val += tabgroupDelim;
				//alert("itm.value="+val);
				itm.value = val;
			}
		}
		window.close();
	}
   }
   return false;
}

function DeleteItems() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		if (lst) ClearSelectedList(lst);
	}
	return false;
}
function UnhighlightItems() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		if (lst) {
			lst.selectedIndex=-1;
		}
	}
	return false;
}

//除了当前选中的List,其他的项目均不选中
function UnhighlightOthers() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		if ((lst)&&(i!=selectedGrp)) {
			lst.selectedIndex=-1;
		}
	}
	return false;
}

function ShiftItemsLeft() {
	var maxlimit=MAXGROUPS+1;
	for (var i=2; i<maxlimit; i++) {
		var lstFrom = document.getElementById("LISTGroup" + i);
		if (lstFrom) {
			var lstTo = null;
			var j=i-1;
			//find the next list on the screen (by number order)
			while ((!lstTo) && (j>0)) {
				lstTo = document.getElementById("LISTGroup" + j);
				j--;
			}
			if (lstTo) SwapToList(lstFrom,lstTo,1);
		}
	}
	return false;
}
function ShiftItemsRight() {
	var maxlimit=MAXGROUPS+1;
	for (var i=MAXGROUPS-1; i>0; i--) {
		var lstFrom = document.getElementById("LISTGroup" + i);
		if (lstFrom) {
			var lstTo = null;
			var j=i+1;
			//find the next list on the screen (by number order)
			while ((!lstTo) && (j<maxlimit)) {
				lstTo = document.getElementById("LISTGroup" + j);
				j++;
			}
			if (lstTo) SwapToList(lstFrom,lstTo,1);
		}
	}
	return false;
}
function ShiftItemsUp() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		if (lst) {
			for (var j=1; j<lst.options.length; j++) {
				if ((lst.options[j].selected)&&(!lst.options[j-1].selected)) {
				  SwapListItem(lst,j,j-1);
				}
			}
		}
	}
	return false;
}

//交换List的两行
function SwapListItem(lst,a,b) { 
	var selValue = lst.options[a].value;
  var selText = lst.options[a].text;
  lst.options[a].value = lst.options[b].value;
  lst.options[a].text = lst.options[b].text;
  lst.options[b].value = selValue;
  lst.options[b].text = selText;
  lst.selectedIndex=b;
}

function ShiftItemsDown() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		if (lst) {
			for (var j=(lst.options.length-2); j>=0; j--) {
				if ((lst.options[j].selected)&&(!lst.options[j+1].selected)) {
					SwapListItem(lst,j,j+1);
				}
			}
		}
	}
	return false;
}

	var obj=document.getElementById("update1");
	if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById("ListItemDelete");
	if (obj) obj.onclick=DeleteItems;
	var obj=document.getElementById("ListItemLeft");
	if (obj) obj.onclick=ShiftItemsLeft;
	var obj=document.getElementById("ListItemUnhighlight");
	if (obj) obj.onclick=UnhighlightItems;
	var obj=document.getElementById("ListItemRight");
	if (obj) obj.onclick=ShiftItemsRight;
	var obj=document.getElementById("ListItemUp");
	if (obj) obj.onclick=ShiftItemsUp;
	var obj=document.getElementById("ListItemDown");
	if (obj) obj.onclick=ShiftItemsDown;
function DocumentLoadHandler() {
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	if (tsc['ListItemDelete']) websys_sckeys[tsc['ListItemDelete']]=DeleteItems;
	if (tsc['ListItemUnhighlight']) websys_sckeys[tsc['ListItemUnhighlight']]=UnhighlightItems;
	if (tsc['ListItemLeft']) websys_sckeys[tsc['ListItemLeft']]=ShiftItemsLeft;
	if (tsc['ListItemRight']) websys_sckeys[tsc['ListItemRight']]=ShiftItemsRight;
	if (tsc['ListItemUp']) websys_sckeys[tsc['ListItemUp']]=ShiftItemsUp;
	if (tsc['ListItemDown']) websys_sckeys[tsc['ListItemDown']]=ShiftItemsDown;
	
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup"+i);
		if (lst) lst.onclick=SetListGroupStyle;
	}
	SetListGroupStyle();
	obj=document.getElementById("OrderDetails")
	//if (obj) obj.onclick=OrderDetailsClickHandler;
	if (obj) obj.onclick=ShowOrderDetails;
	obj=document.getElementById("DeleteUserDefaults")
	if (obj) obj.onclick=DeleteUserDefaultsClickHandler;
	// 
	var obj=document.getElementById("CopyAllToClipboard");
	if (obj) obj.onclick=CopyAllToClipboard;

	var obj=document.getElementById("CopyToClipboard");
	if (obj) obj.onclick=copyToClipboard;
	var obj=document.getElementById("ExportTabs");
	if (obj) obj.onclick=ExportTabsClicked;

	BPasteObj = document.getElementById('BPaste');
  	if (BPasteObj) BPasteObj.onclick = BPasteFun;
	BPasteObj = document.getElementById('BPasteAll');
  	if (BPasteObj) BPasteObj.onclick = BPasteAll;
	

	LISTGroupDblClkHandler();
	ItemHasDefaultHandler();
}

function SetListGroupStyle(e){
	var Obj=websys_getSrcElement(e);
	if (Obj){
		var Temp=Obj.id.split("LISTGroup")
		selectedGrp=Temp[1];
	}
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		if (i==selectedGrp){
			var ObjList = document.getElementById("LISTGroup" + i);
			if (ObjList) ObjList.style.width="300px";	
			var ObjListName = document.getElementById("NAMEGroup"+i);
			if (ObjListName) ObjListName.style.width="300px";
		}else{
			var ObjList = document.getElementById("LISTGroup" + i);
			if (ObjList) ObjList.style.width="150px";	
			var ObjListName = document.getElementById("NAMEGroup"+i);
			if (ObjListName) ObjListName.style.width="150px";
		}
	}
	if (!(event.ctrlKey)){
		UnhighlightOthers();
	}
}

function OrderDetailsClickHandler() {
	//add by zhouzq 2011.08.09 此处不再用
	return false;
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		if (lst) {
			for (var j=0; j<lst.options.length; j++) {
				if(lst.options[j].selected) {
					var ItemDesc="";
					var ItemValue="";
					var ItemID="";
					var EpisodeID="";
					var Eobj=document.getElementById("EpisodeID");
					if(Eobj) EpisodeID=Eobj.value;
					ItemDesc=lst.options[j].text;
					ItemValue=lst.options[j].value;
					if (ItemValue!="") ItemID=mPiece(ItemValue,itemdataDelim,1);
					if(ItemID!="") ItemID=ItemID.replace("Y","");
					if((ItemID!="")&&(ItemID.indexOf("||")==-1)) {
						var 

url="oeorder.ordersetfav.csp?ORDERSETID="+ItemID+"&ARCIMDesc="+ItemDesc+"&ID="+"&PatientID="+"&EpisodeID="+EpisodeID+"&OrderWindow="+window.name;
                                                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
						websys_createWindow(url,"Pref_tab","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
					}
					else {
						var url = "oeorder.mainloop.csp?ARCIMDesc="+ItemDesc+"&ID="+"&EpisodeID="+EpisodeID+"&itemdata="+"&OEORIItmMastDR="+ItemID+"&ORDERSETID="+"&PatientID="+"&ARCIMIDs="+"&selIndx="+"&PatientLoc="+"&PatientOrders="+"&LinkedItmID1="+"&CopiedARCIM="+"&CopiedFreq="+"&CopiedInstr="+"&CopiedDur="+"&OrderWindow="+window.name;
						//alert(url);
                                                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
						websys_createWindow(url, "Pref_tab","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
					}
				}
			}
		}
	}
	return false;
}

function ShowOrderDetails(){
	var lst = document.getElementById("LISTGroup" + selectedGrp);
	if (lst){
		for (var j=0; j<lst.options.length; j++) {
			if(lst.options[j].selected) {
				var ItemDesc="";
				var ItemValue="";
				var ItemID="";
				var EpisodeID="";
				var Eobj=document.getElementById("EpisodeID");
				if(Eobj) EpisodeID=Eobj.value;
				ItemDesc=lst.options[j].text;
				ItemValue=lst.options[j].value;
				if (ItemValue!="") {
					ItemType=mPiece(ItemValue,itemdataDelim,0);
					ItemID=mPiece(ItemValue,itemdataDelim,1);
				}
				if(ItemID!="") ItemID=ItemID.replace("Y","");
				if(ItemID!="") {
					url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.ItemLinkTar&OrderRowid="+ItemID+"&OrderType="+ItemType+"&LogonDepDR="+session['LOGON.CTLOCID'];
					websys_createWindow(url,'UDHCOEOrder_ItemLinkTar',"toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
				}
			}
		}
	}
	return false;
}

function DeleteUserDefaultsClickHandler() {
	var ItmMastIDs=""
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		if (lst) {
			for (var j=0; j<lst.options.length; j++) {
				if(lst.options[j].selected) {
					var ItemValue="";
					var ItemID="";
					ItemValue=lst.options[j].value;
					if (ItemValue!="") ItemID=mPiece(ItemValue,itemdataDelim,1);
					if(ItemID!="") {
						ItemID=ItemID.replace("Y","");
						ItmMastIDs=ItmMastIDs+ItemID+"^"
					}
				}
			}
		}
	}
	if (ItmMastIDs=="") {
		alert(t["SelectItemDelete"]);
		return false;
	}
	var objItmMastIDs = document.getElementById("ItmMastIDs");
	if (objItmMastIDs) objItmMastIDs.value=ItmMastIDs;
	return DeleteUserDefaults_click();
}

/////////
//lookups

function OrderItemLookupSelect(txt) {
	//Add an item to LISTGroup when an item is selected from
	//the Lookup, then clears the Item text field.
	//alert(txt);
	var lu=txt.split("^");
	var desc=lu[0];
	var id=lu[1];
	var type=lu[3];

	//Log 48858 PeterC 20/06/05 Item has default, need to make it blue when adding to the list
	if(lu[17]=="Y") id=id+"Y";

	code = type+itemdataDelim+id;
	//alert("code"+code)
	//this only adds the item to group 1
	//  20090328
	//var lst=document.getElementById("LISTGroup1")
	//alert(selectedGrp);
	var lst=document.getElementById("LISTGroup"+selectedGrp)
	if (lst) AddItemSingle(lst,code,desc);
	//Log 48858 PeterC 20/06/05 Item has default, need to make it blue when adding to the list
	//if(lu[17]=="Y") ItemHasDefaultHandler(); 
	document.getElementById('OrderItem').value="";
	websys_setfocus('OrderItem');
}

function OrderCategoryLookupSelect(txt) {
	//clear out subcategory and order item fields
	var obj=document.getElementById("OrderSubcategory");
	if (obj) obj.value="";
	var obj=document.getElementById("OrderItem");
	if (obj) obj.value="";
}

function OrderSubcategoryLookupSelect(txt) {
	//clear out order item field
	var obj=document.getElementById("OrderItem");
	if (obj) obj.value="";
}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

function AddItemToList(obj,arytxt,aryval) {
	alert("Here");
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {obj.options[lstlen] = new Option(arytxt[i],aryval[i]); lstlen++;}
		}
	}
}
//20090115 回车弹出窗口
function OrderItem_lookuphandler(e) {
	if (evtName=='OrderItem') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	//web.DHCDocOrderEntry
	//LookUpItem
	//OrderItem,SSGroupID,OrderCategory,OrderSubcategory,'','','',EpisodeID,'','',USERID,'',NonFormAndBrand,LogCTLOCID,HospID
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&((key==117)||(key==13)))) {
		var url='websys.lookup.csp';
		url += "?ID=ItemDesc";
		//url += "&CONTEXT=Kweb.OEOrdItem:LookUpItm"; // epr.PreferencesQuery  LookUpItem Kweb.DHCDocOrderEntry:LookUpItem
		//OrderItem,SSGroupID,OrderCategory,OrderSubcategory,'','','',EpisodeID,'','','','',NonFormAndBrand,'',HospID
		url += "&CONTEXT=Kweb.DHCDocOrderEntry:LookUpItem";
		url += "&TLUJSF=OrderItemLookupSelect";
		var obj=document.getElementById('OrderItem');
		if (obj) url += "&P1=" + websys_escape(obj.value);//整理字符串中的特殊字符
		var obj=document.getElementById('SSGroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('OrderCategory');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('OrderSubcategory');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		url += "&P5=" + '';
		url += "&P6=" + '';
		url += "&P7=" + '';
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		url += "&P9=" + '';
		url += "&P10=" + '';
		var obj=document.getElementById('USERID');
		if (obj) {
			url += "&P11=" + websys_escape(obj.value);
		}else{
			url += "&P11=" + session['LOGON.USERID'];
		}
		url += "&P12=" + '';
		var obj=document.getElementById('NonFormAndBrand');
		if (obj) url += "&P13=" + websys_escape(obj.value);
		var obj=document.getElementById('LogCTLOCID');
		if (obj) {
			url += "&P14=" + websys_escape(obj.value);
		}else{
			url += "&P14=" + session['LOGON.CTLOCID'];
		}
		var obj=document.getElementById('HospID');
		if (obj) url += "&P15=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
		///////////////////////////////////////////////////////////////////////////////////////
		
		var url='websys.lookup.csp';
		url += '?ID=d1222iOrderItem&CONTEXT=Kweb.OEOrdItem:LookUpItm&TLUDESC='+t['OrderItem'];
		url += "&TLUJSF=OrderItemLookupSelect";
		var obj=document.getElementById('OrderItem');
		if (obj) url += "&P1=" + websys_escape(obj.value);//整理字符串中的特殊字符
		var obj=document.getElementById('SSGroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		url += "&P3=" + '';
		url += "&P4=" + '';
		url += "&P5=" + '';
		var obj=document.getElementById('OrderCategory');
		if (obj) url += "&P6=" + websys_escape(obj.value);
		var obj=document.getElementById('OrderSubcategory');
		if (obj) url += "&P7=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		url += "&P9=" + '';
		url += "&P10=" + '';
		url += "&P11=" + '';
		url += "&P12=" + '';
		var obj=document.getElementById('NonFormAndBrand');
		if (obj) url += "&P13=" + websys_escape(obj.value);
		url += "&P14=" + '';
		var obj=document.getElementById('HospID');
		if (obj) url += "&P15=" + websys_escape(obj.value);
		//alert(url);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('OrderItem');
	if (obj) obj.onkeydown=OrderItem_lookuphandler;
	
function OrderSubcategory_lookuphandler(e) {
	if (evtName=='OrderSubcategory') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&((key==117)||(key==13)))) {
		var url='websys.lookup.csp';
		url += '?ID=d1222iOrderSubcategory&CONTEXT=Kweb.ARCItemCat:LookUpByCategory&TLUDESC='+t['OrderSubcategory'];
		url += "&TLUJSF=OrderSubcategoryLookupSelect";
		var obj=document.getElementById('OrderSubcategory');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('OrderCategory');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('SSGroupID');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('OrderSubcategory');
	if (obj) obj.onkeydown=OrderSubcategory_lookuphandler;

function OrderCategory_lookuphandler(e) {
	if (evtName=='OrderCategory') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&((key==117)||(key==13)))) {
		var url='websys.lookup.csp';
		url += '?ID=d1222iOrderCategory&CONTEXT=Kweb.OECOrderCategory:LookUpBySSGroup&TLUDESC='+t['OrderCategory'];
		url += "&TLUJSF=OrderCategoryLookupSelect";
		var obj=document.getElementById('OrderCategory');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('SSGroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
var obj=document.getElementById('OrderCategory');
if (obj) obj.onkeydown=OrderCategory_lookuphandler;


function LookUpCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the Category ID
	var adata=txt.split("^");
	var catDesc=adata[0];
	var catID=adata[1];
	var catCode=adata[2];
	var cobj=document.getElementById("DHCCateID");
	if (cobj) {
		cobj.value=catID;
	}
	var scobj=document.getElementById("DHCSubCateID");
	if (scobj) scobj.value="";
	var iobj=document.getElementById("DHCSubCategory");
	if (iobj) iobj.value="";
	var iobj=document.getElementById("DHCOrderItem");
	if (iobj) iobj.value="";

}

var obj=document.getElementById('DHCOrderCategory');
if (obj) obj.onkeydown=DHCOrderCategory_lookuphandler;
var obj=document.getElementById('ld1222iDHCOrderCategory');
if (obj) obj.onclick=DHCOrderCategory_lookuphandler;
function DHCOrderCategory_lookuphandler(e) {
	if (evtName=='DHCOrderCategory') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&((key==117)||(key==13)))) {
		var url='websys.lookup.csp';
		url += '?ID=d1222iDHCOrderCategory&CONTEXT=Kweb.OECOrderCategory:LookUpCat&TLUDESC='+t['DHCOrderCategory'];
		url += "&TLUJSF=LookUpCatSelect";
		var obj=document.getElementById('DHCOrderCategory');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

function LookUpSubCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the SubCategory ID
	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("DHCSubCateID");
	if (subcatobj) subcatobj.value=subCatID;
}

var obj=document.getElementById('DHCSubCategory');
if (obj) obj.onkeydown=DHCSubCategory_lookuphandler;
function DHCSubCategory_lookuphandler(e) {
	if (evtName=='DHCSubCategory') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&((key==117)||(key==13)))) {
		var url='websys.lookup.csp';
		url += '?ID=d1222iDHCSubCategory&CONTEXT=Kweb.ARCItemCat:LookUpSubCat&TLUDESC='+t['DHCSubCategory'];
		url += "&TLUJSF=LookUpSubCatSelect";
		var obj=document.getElementById('DHCOrderCategory');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('DHCSubCategory');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

var obj=document.getElementById('DHCOrderItem');
if (obj) obj.onkeydown=DHCOrderItem_lookuphandler;
function DHCOrderItem_lookuphandler(e) {
	if (evtName=='DHCOrderItem') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&((key==117)||(key==13)))) {
		var url='websys.lookup.csp';
		url += '?ID=d1222iDHCOrderItem&CONTEXT=Kweb.DHCDocOrderExt:LookUpItem&TLUDESC='+t['DHCOrderItem'];
		url += "&TLUJSF=DHCOrderItemLookupSelect";
		var obj=document.getElementById('DHCOrderItem');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('DHCCateID');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('DHCSubCateID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		url += "&P5=" + '';
		url += "&P6=" + '';
		url += "&P7=" + '';
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		url += "&P9=" + '';
		url += "&P10=" + '';
		url += "&P11=" + '';
		url += "&P12=" + '';
		url += "&P13=" + '';
		url += "&P14=" + '';
		url += "&P15=" + '';
		url += "&P16=" + '';
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

var scobj=document.getElementById("DHCSubCategory");
if (scobj) scobj.onblur=SubCatChangeHandler;
function SubCatChangeHandler() {
	var scobj=document.getElementById("DHCSubCategory");
	if ((scobj) && (scobj.value=="")) {
		var subcatobj=document.getElementById("DHCSubCateID");
		if (subcatobj) subcatobj.value="";
		var iobj=document.getElementById("DHCOrderItem");
		if (iobj) iobj.value="";
	}
}

var scobj=document.getElementById("DHCOrderCategory");
if (scobj) scobj.onblur=DHCCategoryChangeHandler;
function DHCCategoryChangeHandler() {
	var scobj=document.getElementById("DHCOrderCategory");
	if ((scobj) && (scobj.value=="")) {
		var cobj=document.getElementById("DHCCateID");
		if (cobj) cobj.value="";
		var scobj=document.getElementById("DHCSubCateID");
		if (scobj) scobj.value="";
		var iobj=document.getElementById("DHCSubCategory");
		if (iobj) iobj.value="";
		var iobj=document.getElementById("DHCOrderItem");
		if (iobj) iobj.value="";
	}
}

function DHCOrderItemLookupSelect(txt) {
	//alert("txt=="+txt);
	var lu=txt.split("^");
	var desc=lu[0];
	var id=lu[1];
	var type=lu[2];
	code = type+itemdataDelim+id;
	var lst=document.getElementById("LISTGroup"+selectedGrp);
	if (lst) AddItemSingle(lst,code,desc);
	document.getElementById('DHCOrderItem').value="";
	websys_setfocus('DHCOrderItem');
}

function ClearShortCode() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LISTGroup" + i);
		if (lst) {
			for (var j=0; j<lst.options.length; j++) {
				ItemText=lst.options[j].text;
				SubItemText=ItemText.split(" - ");
				NewItemText=SubItemText[1];
				lst.options[j].text=NewItemText;
			}
		}
	}
}


function DocumentOnBeforeUnLoadHandler(){
	return "  请确保在关闭窗口之前保存数据";
}

document.body.onload=DocumentLoadHandler
document.body.onbeforeunload=DocumentOnBeforeUnLoadHandler


