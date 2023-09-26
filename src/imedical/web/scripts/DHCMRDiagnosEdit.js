var PrivateIndexNum = "";
var x = null;
var listObj = null;
var combo_DiagnosDesc;
var combo_CtLoc;
var ListCustomWidth;
var DiagnosListChangeFlag;
var FristPrivteDesc = '';
var FristPrivteValue = '';
var PrivateChangeFlag;
var MAXGROUPS = 5;
var FocusDiagListIndex=1;
function BodyLoadHandler() {

  Obj = document.getElementById('PrivateAdd');
  if (Obj) Obj.onclick = NewPrivateAdd;
  Obj = document.getElementById('AddPrivateItem');
  if (Obj) Obj.onclick = AddPrivateItem;
  
  GetPrivateList();

  Obj = document.getElementById('PrivateUp');
  if (Obj) Obj.onclick = upListItem;

  Obj = document.getElementById('PrivateDown');
  if (Obj) Obj.onclick = downListItem;

  Obj = document.getElementById('PrivateorderSave');
  if (Obj) Obj.onclick = PrivateorderSaveFUN;

  Obj = document.getElementById('DelPrivate');
  if (Obj) Obj.onclick = DelPrivateFUN;

  Obj = document.getElementById('PrivateChangeName');
  if (Obj) Obj.onclick = PrivateChangeNameFUN;
  
  var obj=document.getElementById('DiagnosDesc');
  if (obj) obj.onkeydown=DiagnosDesc_lookuphandler;
  //combo_DiagnosDesc = dhtmlXComboFromStr("DiagnosDesc", "");
  //combo_DiagnosDesc.selectHandle = combo_DiagnosDescKeydownhandler;
  //combo_DiagnosDesc.keyenterHandle = combo_DiagnosDescKeyenterhandler;
  //combo_DiagnosDesc.attachEvent("onKeyPressed", combo_DiagnosDescKeyenterhandler);

  DepStr = document.getElementById('DepStr').value;
  /*var obj=document.getElementById('Ctloc');
  if (obj) obj.setAttribute("isDefualt","false");
  combo_CtLoc = dhtmlXComboFromStr("Ctloc", DepStr);
  combo_CtLoc.enableFilteringMode(true);
  combo_CtLoc.selectHandle = combo_CtLocSelecthandler;*/
  
  //科室	
  combo_CtLoc=dhtmlXComboFromStr("Ctloc",DepStr);
  combo_CtLoc.enableFilteringMode(true);
  combo_CtLoc.selectHandle=combo_CtLocSelecthandler;;
  combo_CtLoc.attachEvent("onKeyPressed", combo_CtLocKeyenterhandler);
  

  Obj = document.getElementById('DiagnosList1');
  if (Obj) Obj.onclick = DiagnosList1Onclick;

  Obj = document.getElementById('DiagnosList2');
  if (Obj) Obj.onclick = DiagnosList2Onclick;

  Obj = document.getElementById('DiagnosList3');
  if (Obj) Obj.onclick = DiagnosList3Onclick;

  Obj = document.getElementById('DiagnosList4');
  if (Obj) Obj.onclick = DiagnosList4Onclick;

  Obj = document.getElementById('DiagnosList5');
  if (Obj) Obj.onclick = DiagnosList5Onclick;

  Obj = document.getElementById('Listup');
  if (Obj) Obj.onclick = ListupFUN;

  Obj = document.getElementById('Listdown');
  if (Obj) Obj.onclick = ListdownFUN;

  Obj = document.getElementById('ListLeft');
  if (Obj) Obj.onclick = ListLeftFUN1;

  Obj = document.getElementById('ListRight');
  if (Obj) Obj.onclick = ListRightFUN1;

  Obj = document.getElementById('DiagnosDel');
  if (Obj) Obj.onclick = DiagnosDelFUN;

  Obj = document.getElementById('PrivateSave');
  if (Obj) Obj.onclick = PrivateSaveFUN;
  
  var listObj = document.getElementById('DiagnosList1');
  ListCustomWidth = listObj.style.width;

  var ListObj = document.getElementById('PrivateList');
  if (ListObj) {
	  ListObj.ondblclick = PrivateListItemClick;
      ListObj.onclick = function(){setTimeout("PrivateListItemClick()",300);}
  }
 
  var CtLocListObj = document.getElementById('CtLocList');
  if (CtLocListObj) {
	  CtLocListObj.ondbclick = CtLocListItemClick;
	  CtLocListObj.onclick = function(){setTimeout("CtLocListItemClick()",300);}
  }

  AddToPrivateObj = document.getElementById('AddToPrivate');
  if (AddToPrivateObj) AddToPrivateObj.onclick = AddToPrivateObjClick;

  AddToCtlocObj = document.getElementById('AddToCtloc');
  if (AddToCtlocObj) AddToCtlocObj.onclick = AddToCTLocTemplet;

  //lpd
  DelFromCTLocTempletObj = document.getElementById('DelFromCTLocTemplet');
  if (DelFromCTLocTempletObj) DelFromCTLocTempletObj.onclick = DelFromCTLocTemplet;


  ReturnMrdiagnosObj = document.getElementById('ReturnMrdiagnos');
  if (ReturnMrdiagnosObj) ReturnMrdiagnosObj.onclick = ReturnMrdiagnosFun;

  BPasteObj = document.getElementById('BPaste');
  if (BPasteObj) BPasteObj.onclick = BPasteFun;

  BPasteObj = document.getElementById('BPasteAll');
  if (BPasteObj) BPasteObj.onclick = BPasteAll;

  BPasteObj = document.getElementById('CopyAllToClipboard');
  if (BPasteObj) BPasteObj.onclick = CopyAllToClipboard;

  DiagnosListChangeFlag = false;
  PrivateChangeFlag = false;
  var obj=document.getElementById('CNDiagnoseFlag')
  if(obj)obj.onclick=CNDiagnoseFlagClick
  
  var obj=document.getElementById('SyndromeFlag')
  if(obj)obj.onclick=SyndromeFlagClick
  
  document.getElementById("CNDiagnoseFlag1").value=0
}

function NewPrivateAdd() {
  var PrivateDesc = '',
  USERID = '',
  CTLOCID = '',
  INDEXNum = '';
  var PrivateDesc = document.getElementById('PrivateDiagnos').value;
  var PrivateDesc =PrivateDesc.replace(/(^\s*)|(\s*$)/g, "");
  if (PrivateDesc == '') {
    alert('新增的个人模板的名称为空');
    return
  }
  if (CheckPrivateNameIsRepeat(PrivateDesc,"")){
	  alert(PrivateDesc+" 模板名重复!")
	  return false;
  }
  var USERID = session['LOGON.USERID'];
  var CTLOCID = session['LOGON.CTLOCID'];
  var INDEXNum = document.getElementById('PrivateIndexNum').value;
  INDEXNum = Number(INDEXNum) + 1;
  //alert(PrivateDesc+' '+USERID+' '+CTLOCID+' '+INDEXNum);
  var AddPrivateMethod = document.getElementById('AddPrivateMethod').value
  Ret = cspRunServerMethod(AddPrivateMethod, PrivateDesc, USERID, CTLOCID, INDEXNum)
  GetPrivateList();
  document.getElementById('PrivateDiagnos').value="";
}

function GetPrivateList() {
  var GetPrivateListMethod = document.getElementById('GetPrivateListMethod').value;
  var USERID = session['LOGON.USERID'];
  Ret = cspRunServerMethod(GetPrivateListMethod, USERID)
  var DefaultPrivateItem="";
  if (Ret != '') {
    var PrivateIndexNum = Ret.split(String.fromCharCode(2))[1];
    var ListStr = Ret.split(String.fromCharCode(2))[0];
    if (PrivateIndexNum != '') {
      document.getElementById('PrivateIndexNum').value = PrivateIndexNum;
    };
    PrivateListObj = document.getElementById('PrivateList');
    PrivateListObj.length = 0;
    if (ListStr != '') {
      PrivateListArray = ListStr.split(String.fromCharCode(1));
      for (i = 0; i < PrivateListArray.length; i++) {
        PrivateListRowid = PrivateListArray[i].split("^")[0];
        PrivateListDesc = PrivateListArray[i].split("^")[1];
        PrivateListObj.add(new Option(PrivateListDesc, PrivateListRowid));
      }
      PrivateListObj.options[PrivateListArray.length-1].selected=true;
      PrivateListItemClick();
    }
  }
}

function setTimeStart(type) {
  listObj = document.getElementById('forder');
  //超过0.3秒启动连续的向上(下)的操作 
  if (type == "up") {
    x = setTimeout(upListItem, 300);
  } else {
    x = setTimeout(downListItem, 300);

  }

}

function upListItem() {
  var listObj = document.getElementById('PrivateList');
  var selIndex = listObj.selectedIndex;
  if (selIndex < 0) {
    if (x != null) {
      clearTimeout(x);
    }
    return;
  }
  if (selIndex == 0) {
    if (x != null) {
      clearTimeout(x);
    }
    return;
  }
  var selValue = listObj.options[selIndex].value;
  var selText = listObj.options[selIndex].text;
  var PreselValue=listObj.options[selIndex - 1].value;
  var PreselText=listObj.options[selIndex - 1].text;
  listObj.options[selIndex] =  new Option(PreselText,PreselValue);
  listObj.options[selIndex - 1] = new Option(selText,selValue);
  listObj.selectedIndex = selIndex - 1;
  /*if (selIndex + 1 > 0) {
        x = setTimeout(upListItem, 200)
    }*/
  PrivateChangeFlag = true;
 websys_setfocus("PrivateList")
}

function downListItem() {
  var listObj = document.getElementById('PrivateList');
  var selIndex = listObj.selectedIndex;
  if (selIndex < 0) {
    if (x != null) {
      clearTimeout(x);
    }
    return;
  }
  if (selIndex == listObj.options.length - 1) {
    if (x != null) {
      clearTimeout(x);
    }
    return;
  }
  var selValue = listObj.options[selIndex].value;
  var selText = listObj.options[selIndex].text;
  var NextselValue=listObj.options[selIndex + 1].value;
  var NextselText=listObj.options[selIndex + 1].text;
  listObj.options[selIndex] =  new Option(NextselText,NextselValue);
  listObj.options[selIndex + 1] = new Option(selText,selValue);
  listObj.selectedIndex = selIndex + 1;
  /*if (selIndex + 1 < listObj.options.length - 1) {
        x = setTimeout(downListItem, 200)
    }*/
  PrivateChangeFlag = true;
  websys_setfocus("PrivateList")
}

function PrivateorderSaveFUN() {
  var listObj = document.getElementById('PrivateList');
  var PrivateStr = '';
  for (selIndex = 0; selIndex < listObj.options.length; selIndex++) {
    //alert(listObj.options[selIndex].value+' '+listObj.options[selIndex].text);
    PrivateRowid = listObj.options[selIndex].value;
    if (PrivateStr == '') {
      PrivateStr = PrivateRowid
    } else {
      PrivateStr = PrivateStr + '^' + PrivateRowid
    }
  }
  if (PrivateStr == '') {
    alert('参数不正确,没有传入值');
    return
  }
  var USERID = session['LOGON.USERID'];
  var PrivateorderSaveMethod = document.getElementById('PrivateorderSaveMethod').value;
  Ret = cspRunServerMethod(PrivateorderSaveMethod, PrivateStr, USERID)
  GetPrivateList();
  PrivateChangeFlag = false;
}
function DelPrivateFUN() {
  var UndelListArr=new Array();
  var listObj = document.getElementById('PrivateList');
  for (k = listObj.length - 1; k >= 0; k--) {
    if (listObj.options[k].selected == true) {
      PrivateRowid = listObj.options[k].value;
      PrivateDesc = listObj.options[k].text;
      var PrivateConfirm = window.confirm('是否删除' + PrivateDesc + '下的所有内容');
      if (PrivateConfirm == true) {
        var USERID = session['LOGON.USERID'];
        var PrivateDelMethod = document.getElementById('PrivateDelMethod').value;
        Ret = cspRunServerMethod(PrivateDelMethod, USERID, PrivateRowid);
        listObj.remove(k);
        var CTLocValue = combo_CtLoc.getSelectedValue();
        if (CTLocValue != '') combo_CtLocSelecthandler();
        if (PrivateDesc==FristPrivteDesc){
	        DiagnosListChangeFlag=false;
	    }
      } else {
	     UndelListArr[UndelListArr.length]=PrivateRowid;
	  }
    }
  }
  
  if(listObj.length>0)PrivateorderSaveFUN();
  else {
	   for(k=1;k<6;k++){
		  	var DiagnosListObj=document.getElementById("DiagnosList"+k);
		  	if (!DiagnosListObj) continue;
		   	if(DiagnosListObj){
			   	DiagnosListObj.length=0;
			}
		}
  }
  if (UndelListArr.length>0){
	  UndelListStr=UndelListArr.join("^");
	  UndelListStr="^"+UndelListStr+"^";
	  var listObj = document.getElementById('PrivateList');
	  for (selIndex = 0; selIndex < listObj.options.length; selIndex++) {
		  var PrivateRowid = listObj.options[selIndex].value;
		  PrivateRowid="^"+PrivateRowid+"^";
		  if (UndelListStr.indexOf(PrivateRowid)>=0){
			  listObj.options[selIndex].selected = true;
		  }else{
			  listObj.options[selIndex].selected = false;
		  }
	  }
	  PrivateListItemClick();
  }
}

function PrivateChangeNameFUN() {
  var listObj = document.getElementById('PrivateList');
  var NewDescName = document.getElementById('PrivateDiagnos').value;
  if (NewDescName == '') {
    alert('请输入名称');
    return
  }
  for (i = listObj.length - 1; i >= 0; i--) {
    if (listObj.options[i].selected == true) {
	      PrivateRowid = listObj.options[i].value;
	      PrivateDesc = listObj.options[i].text;
	      if (CheckPrivateNameIsRepeat(NewDescName,i)){
			  alert(NewDescName+" 模板名重复!")
			  return false;
		  }
	      var PrivateConfirm = window.confirm('是否修改' + PrivateDesc + '的名称');
	      if (PrivateConfirm == true) {
	        var USERID = session['LOGON.USERID'];
	        var PrivateChangeNameMethod = document.getElementById('PrivateChangeNameMethod').value;
	        Ret = cspRunServerMethod(PrivateChangeNameMethod, USERID, PrivateRowid, NewDescName);
	        //listObj.options[i].text = NewDescName;
	       listObj.options[i]=new Option(NewDescName,PrivateRowid); 
	       listObj.options[i].selected=true;
	      } /*else {

	      }*/
    }
  }
  document.getElementById('PrivateDiagnos').value="";
}

function combo_DiagnosDescKeyenterhandler() {
  var Str = combo_DiagnosDesc.getComboText();
  if (Str == '') {
    return
  };
  var DiagnosDescLookup = document.getElementById('DiagnosDescLookup').value;

  var CNDiagnoseFlag=0;
  var CNDiagnoseFlagObj = document.getElementById("CNDiagnoseFlag");
  if (CNDiagnoseFlagObj) {
		CNDiagnoseFlag = CNDiagnoseFlagObj.checked;
	  if (CNDiagnoseFlag) {
	  	CNDiagnoseFlag=1;
	  }else {
	  	CNDiagnoseFlag=0;
	  }  
  }
  Ret = cspRunServerMethod(DiagnosDescLookup, Str,CNDiagnoseFlag);
  //alert("Str=="+Str+"   CNDiagnoseFlag=="+CNDiagnoseFlag);

;
  combo_DiagnosDesc.clearAll();
  var Arr = DHCC_StrToArray(Ret);
  combo_DiagnosDesc.addOption(Arr);
}

function DHCC_StrToArray(str) {
  var x = new Array();
  var Arr = str.split('^');
  for (var i = 0; i < Arr.length; i++) {
    var Arr1 = Arr[i].split(String.fromCharCode(1));
    var label = Arr1[1];
    var val = Arr1[0];
    if ((typeof(val) == "undefined") || (val === null)) val = label;
    x[i] = [val, label];
  }
  return x;
}

function combo_DiagnosDescKeydownhandler() {
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
  }
  DiagnosDesc = combo_DiagnosDesc.getSelectedText();
  DiagnosValue = combo_DiagnosDesc.getSelectedValue();
  if ((DiagnosDesc == '') || (DiagnosValue == '')) return;
  DiagnosListObj = document.getElementById('DiagnosList' + ListNum);
  if (DiagnosListObj.options[0].text == '') {
    DiagnosListObj.options[0].text = DiagnosDesc;
    DiagnosListObj.options[0].value = DiagnosValue;
    combo_DiagnosDesc.clearAll();
    combo_DiagnosDesc.setComboText('');
  } else {
    DiagnosListObj.add(new Option(DiagnosDesc, DiagnosValue));
    combo_DiagnosDesc.clearAll();
    //combo_DiagnosDesc.setComboText('')
  }
  combo_DiagnosDesc.setComboText('');
  combo_DiagnosDesc.setComboValue('');
  combo_DiagnosDesc.clearAll();
  DiagnosListChangeFlag = true;
}
//var obj=document.getElementById('DiagnosDesc');
//if (obj) obj.onkeydown=PrescFrequence_lookuphandler;
function DiagnosDesc_lookuphandler(e) {
	if (evtName=='DiagnosDesc') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var obj=websys_getSrcElement(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))){
		var url='websys.lookup.csp';
		url += "?ID=DiagnosDesc";
		url += "&CONTEXT=Kweb.DHCMRDiagnos:LookUpWithAlias";
		url += "&TLUJSF=DiagnosDeschandler";
		var obj=document.getElementById('DiagnosDesc');
		if (obj) url += "&P1=" + obj.value;
		var obj=document.getElementById('""');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		var obj=document.getElementById('CNDiagnoseFlag1');
		if (obj) url += "&P5=" + obj.value;
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function DiagnosDeschandler(value){
	var ListNum = '';
    ListNum = SetListFocus();
    DiagnosListObj = document.getElementById('DiagnosList' + ListNum);
    
    
	var listArry=value.split("^")
	DiagnosDesc=listArry[0];
	DiagnosValue=listArry[1];
	var selmasterId="",selmasterIdStr="",newValue="",newText="";
    var obj=document.getElementById('CNDiagnoseFlag1');
	if (obj.value=="2"){
		AddSyndromItem(DiagnosValue,DiagnosDesc,ListNum);
	}else{
		if ((DiagnosDesc != '')&& (DiagnosValue != '')) {
			if (!CheckRepeat(DiagnosValue,DiagnosDesc)) {
				websys_setfocus("DiagnosDesc");
				return false;
			}
			/*if ((DiagnosListObj.options.length==0)||(DiagnosListObj.options[0].text == '')) {
				DiagnosListObj.options[0].text = DiagnosDesc;
				DiagnosListObj.options[0].value = DiagnosValue;
			} else {*/
				DiagnosListObj.add(new Option(DiagnosDesc, DiagnosValue));
				DiagnosListChangeFlag = true;
		   // }
		   
		}  
		
	}
	document.getElementById("DiagnosDesc").value=""
	websys_setfocus("DiagnosDesc")
} 
function CheckRepeat(Value,Desc){
	if (Value=="") var CheckValue=Desc;
	else var CheckValue=Value;
	var obj=document.getElementById('CNDiagnoseFlag1');
	var CNFlag=obj.value;
    for (k = 1; k < 6; k++) {
	    var DiagnosListObj = document.getElementById('DiagnosList' + k);
	    for (i = 0; i < DiagnosListObj.length; i++) {
		      var ChecktmpValue="";
		      var tmpDiagnosValue = DiagnosListObj.options[i].value;
		      var tmpDiagnosText = DiagnosListObj.options[i].text;
		      if (tmpDiagnosValue!=""){
			      var mainId=tmpDiagnosValue.split("*")[0];
			      var mainText=tmpDiagnosText.split("*")[0];
			      if (mainId=="") ChecktmpValue=mainText;
			      else ChecktmpValue=mainId;			  
			  }else{
				  ChecktmpValue=DiagnosText;
			  }	  
			  if (CNFlag=="0"){
				  if (ChecktmpValue==CheckValue){
					  alert(Desc+"已存在");
					  return false;
				  }
			  } 
			  if (CNFlag=="1"){
				  if (ChecktmpValue==CheckValue){
					  if (!window.confirm("中医诊断: "+Desc+" 已存在,是否确定添加?")){
						  return false;
					  }
				 }
			  }   
		 }
     }
     return true;
}
function DiagnosList1Onclick() {
  FocusDiagListIndex=1;
  Obj = document.getElementById('DiagnosList1');
  Itemobj = Obj.options[0];
  if (!Itemobj) {
    //Obj.add(new Option('', ''));
    //Obj.options[0].selected = true
  }
  UnListSelect(Obj);
}

function DiagnosList2Onclick() {
	FocusDiagListIndex=2;
  Obj = document.getElementById('DiagnosList2');
  Itemobj = Obj.options[0];
  if (!Itemobj) {
    //Obj.add(new Option('', ''));
    //Obj.options[0].selected = true
  }
  UnListSelect(Obj);
}

function DiagnosList3Onclick() {
	FocusDiagListIndex=3
  Obj = document.getElementById('DiagnosList3');
  Itemobj = Obj.options[0];
  if (!Itemobj) {
    //Obj.add(new Option('', ''));
    //Obj.options[0].selected = true
  }
  UnListSelect(Obj);
}

function DiagnosList4Onclick() {
	FocusDiagListIndex=4;
  Obj = document.getElementById('DiagnosList4');
  Itemobj = Obj.options[0];
  if (!Itemobj) {
    //Obj.add(new Option('', ''));
    //Obj.options[0].selected = true
  }
  UnListSelect(Obj);
}

function DiagnosList5Onclick() {
	FocusDiagListIndex=5;
  Obj = document.getElementById('DiagnosList5');
  Itemobj = Obj.options[0];
  if (!Itemobj) {
    //Obj.add(new Option('', ''));
    //Obj.options[0].selected = true
  }
  UnListSelect(Obj);
}

function UnListSelect(Obj) {
  for (k = 1; k < 6; k++) {
    NewObj = document.getElementById('DiagnosList' + k)
    if (NewObj != Obj) {
      if (!NewObj.options[0]) {
	      NewObj.style.width = ListCustomWidth;
	      continue;
	  }
      for (i = NewObj.length - 1; i >= 0; i--) {
        NewObj.style.width = ListCustomWidth;
        if (NewObj.options[i].selected == true) {
          NewObj.options[i].selected = false;
        }
      }
    } else {
      Obj.style.width = (Number(ListCustomWidth.split('p')[0]) + 100) + 'px';

    }
  }
}

function SetListFocus() {
	var DefaultSelDiagnosList=1;
    for (k = 1; k < 6; k++) {
	    ListObj = document.getElementById('DiagnosList' + k)
	    if (!ListObj.options[0]) continue;
	    for (i = ListObj.length - 1; i >= 0; i--) {
	      if (ListObj.options[i].selected == true) {
	        return k;
	        break;
	      }
	    }
  }
  var ListObj=document.getElementById('DiagnosList'+FocusDiagListIndex);
  ListObj.click();
  return FocusDiagListIndex;
  var ListObj1=document.getElementById('DiagnosList1');
  //if (ListObj1.length>0) {ListObj1.options[0].selected=true;}
  //else {ListObj1.click();}
  ListObj1.click();
  return 1;
  //if (ListObj1.options[0]) ListObj1.options[0].selected=true;
}
function GetListFocus(){
	return FocusDiagListIndex;
	var DefaultSelDiagnosList=1;
	for (k = 1; k < 6; k++) {
		ListObj = document.getElementById('DiagnosList' + k)
	    if (!ListObj.options[0]) continue;
	    for (i = ListObj.length - 1; i >= 0; i--) {
	      if (ListObj.options[i].selected == true) {
	        return k;
	        break;
	      }
	    }
	}
	return "";
}
//2009
function ListLeftFUN1() {
	var maxlimit=MAXGROUPS + 1;
	for (var i=2; i<maxlimit; i++) {
		var lstFrom = document.getElementById("DiagnosList" + i);
		if (lstFrom) {
			var lstTo = null;
			var j=i-1;
			//find the next list on the screen (by number order)
			while ((!lstTo) && (j>0)) {
				lstTo = document.getElementById("DiagnosList" + j);
				j--;
			}
			if (lstTo) {
				SwapToList(lstFrom,lstTo,1);
				DiagnosListChangeFlag = true;
			}
		}
	}
	return false;
}
function ListRightFUN1() {
	var maxlimit=MAXGROUPS + 1;
	for (var i=MAXGROUPS-1; i>0; i--) {
		var lstFrom = document.getElementById("DiagnosList" + i);
		if (lstFrom) {
			var lstTo = null;
			var j=i+1;
			//find the next list on the screen (by number order)
			while ((!lstTo) && (j<maxlimit)) {
				lstTo = document.getElementById("DiagnosList" + j);
				j++;
			}
			if (lstTo) {
				SwapToList(lstFrom,lstTo,1);
				DiagnosListChangeFlag = true;
			}
		}
	}
	return false;
}
//2009



function ListupFUN() {
  ListFocus = SetListFocus();
  if ((ListFocus == '') || (!ListFocus)) {
    alert('请选择下面的列表框');
    return
  };
  ListupListItem(ListFocus)
  DiagnosListChangeFlag = true;
}

function ListupListItem(ListFocus) {
  var listObj = document.getElementById('DiagnosList' + ListFocus);
  var selIndex = listObj.selectedIndex;
  if (selIndex < 0) {
    if (x != null) {
      clearTimeout(x);
    }
    return;
  }
  if (selIndex == 0) {
    if (x != null) {
      clearTimeout(x);
    }
    return;
  }
  var selValue = listObj.options[selIndex].value;
  var selText = listObj.options[selIndex].text;
  var PreselValue = listObj.options[selIndex - 1].value;
  var PreselText = listObj.options[selIndex - 1].text;
  listObj.options[selIndex] = new Option(PreselText,PreselValue);
  listObj.options[selIndex - 1]=new Option(selText,selValue);
  listObj.selectedIndex = selIndex - 1;
  /*if (selIndex + 1 > 0) {
        x = setTimeout(upListItem, 200)
    }*/
}

function ListdownFUN() {
  ListFocus = SetListFocus();
  if ((ListFocus == '') || (!ListFocus)) {
    alert('请选择下面的列表框');
    return
  };
  ListdownListItem(ListFocus);
  DiagnosListChangeFlag = true;
}

function ListdownListItem(ListFocus) {
  var listObj = document.getElementById('DiagnosList' + ListFocus);
  var selIndex = listObj.selectedIndex;
  if (selIndex < 0) {
    if (x != null) {
      clearTimeout(x);
    }
    return;
  }
  if (selIndex == listObj.options.length - 1) {
    if (x != null) {
      clearTimeout(x);
    }
    return;
  }
  var selValue = listObj.options[selIndex].value;
  var selText = listObj.options[selIndex].text;
  var NextselValue = listObj.options[selIndex + 1].value;
  var NextselText = listObj.options[selIndex + 1].text;
  listObj.options[selIndex] = new Option(NextselText,NextselValue);
  listObj.options[selIndex + 1]=new Option(selText,selValue);
  listObj.selectedIndex = selIndex + 1;
  /*if (selIndex + 1 < listObj.options.length - 1) {
        x = setTimeout(downListItem, 200)
    }*/
}
function ListLeftFUN() {
  ListFocus = SetListFocus();
  if ((ListFocus == '') || (!ListFocus)) {
    alert('请选择下面的列表框');
    return
  };
  if (Number(ListFocus) < 2) {
    return
  };
  sourceObj = document.getElementById('DiagnosList' + ListFocus);
  var selIndex = sourceObj.selectedIndex;
 
  var selValue = sourceObj.options[selIndex].value;
  var selText = sourceObj.options[selIndex].text;
  listObj = document.getElementById('DiagnosList' + (Number(ListFocus) - 1));
  Itemobj = listObj.options[0];
  UnListSelect(listObj);
  if (!Itemobj) {
    listObj.add(new Option(selText, selValue));
    sourceObj.remove(selIndex);
    UnListSelect(listObj);
    listObj.options[listObj.length - 1].selected = true;
    DiagnosListChangeFlag = true;
    UnListSelect(listObj);
    return;
  }
  if (listObj.options[0].value == '') {
    listObj.options[0].value = selValue;
    listObj.options[0].text = selText;
    sourceObj.remove(selIndex);
    listObj.options[listObj.length - 1].selected = true;
    UnListSelect(listObj);
    DiagnosListChangeFlag = true;
  } else {
    listObj.add(new Option(selText, selValue));
    sourceObj.remove(selIndex);
    UnListSelect(listObj);
    listObj.options[listObj.length - 1].selected = true;
    DiagnosListChangeFlag = true;
  }
  DiagnosListChangeFlag = true;
}

function ListRightFUN() {
  ListFocus = SetListFocus();
  if ((ListFocus == '') || (!ListFocus)) {
    alert('请选择下面的列表框');
    return
  };
  if (Number(ListFocus) > 4) {
    return
  };
  sourceObj = document.getElementById('DiagnosList' + ListFocus);
  var selIndex = sourceObj.selectedIndex;
  var selValue = sourceObj.options[selIndex].value;
  var selText = sourceObj.options[selIndex].text;
  listObj = document.getElementById('DiagnosList' + (Number(ListFocus) + 1));
  Itemobj = listObj.options[0];
  UnListSelect(listObj);
  if (!Itemobj) {
    listObj.add(new Option(selText, selValue));
    sourceObj.remove(selIndex);
    UnListSelect(listObj);
    listObj.options[listObj.length - 1].selected = true;
    DiagnosListChangeFlag = true;
    UnListSelect(listObj);
    return;
  }
  if (listObj.options[0].value == '') {
    listObj.options[0].value = selValue;
    listObj.options[0].text = selText;
    sourceObj.remove(selIndex);
    listObj.options[listObj.length - 1].selected = true;
    UnListSelect(listObj);
    DiagnosListChangeFlag = true;
  } else {
    listObj.add(new Option(selText, selValue));
    sourceObj.remove(selIndex);
    UnListSelect(listObj);
    listObj.options[listObj.length - 1].selected = true;
    DiagnosListChangeFlag = true;
  }
  DiagnosListChangeFlag = true;
}

function DiagnosDelFUN() {
  //ListFocus = SetListFocus();
  ListFocus =GetListFocus();
  if ((ListFocus == '') || (!ListFocus)) {
    alert('请选择下面的列表框');
    return
  };
  sourceObj = document.getElementById('DiagnosList' + ListFocus);
  var selIndex = sourceObj.selectedIndex;
  if (selIndex<0){
	  alert('请选择需要删除的数据');
      return
 }
  sourceObj.remove(selIndex);
  DiagnosListChangeFlag = true;
}

function PrivateSaveFUN() {
  if (document.getElementById('PrivateSave').disabled == true) return;
  var PrivateListObj = document.getElementById('PrivateList');
  var selIndex = PrivateListObj.selectedIndex;
  if (selIndex < 0) {
    alert('没有选择个人模板');
    return
  }
  var selValue = PrivateListObj.options[selIndex].value;
  var selText = PrivateListObj.options[selIndex].text;
  var USERID = session['LOGON.USERID'];
  for (k = 1; k < 6; k++) {
    var DiagnosListObj = document.getElementById('DiagnosList' + k);
    var DiagnosStr = '';
    for (i = 0; i < DiagnosListObj.length; i++) {
      var DiagnosValue = DiagnosListObj.options[i].value;
      var DiagnosText = DiagnosListObj.options[i].text;
      var MainICDInfo="",NewSyndromInfo="";
      
      if (DiagnosValue!=""){
	      var mainId=DiagnosValue.split("*")[0];
	      var mainText=DiagnosText.split("*")[0];
	      if ((mainId=="")&&(mainText!="")){
		      MainICDInfo="$"+mainText;
		  }else{
			  MainICDInfo=mainId;
		  }
		  var SyndromInfo=DiagnosValue.split("*")[1];
		  if ((SyndromInfo!="")&&(SyndromInfo!=undefined)){
			 var idStr=SyndromInfo.split("#")[0];
			 var descStr=SyndromInfo.split("#")[1];
			 for (var m=0;m<idStr.split("!").length;m++){
				 var oneId=idStr.split("!")[m];
				 if (oneId==""){
					 oneId=descStr.split("!")[m];
				 }
				 if (oneId=="") continue;
				 if (NewSyndromInfo=="") NewSyndromInfo=oneId;
				 else NewSyndromInfo=NewSyndromInfo+"!"+oneId;
			 }
		  }
		  if (NewSyndromInfo!="") MainICDInfo=MainICDInfo+"!"+NewSyndromInfo;
		  if (MainICDInfo!="") DiagnosValue=MainICDInfo;
	  }else{
		  if ((DiagnosValue=="")&&(DiagnosText!="")){
		      DiagnosValue=DiagnosValue+"$"+DiagnosText
		  }
	  }
	  
      if ((DiagnosValue != '') & (DiagnosText != '')) {
        if (DiagnosStr == '') {
          DiagnosStr = DiagnosValue
        } else {
          DiagnosStr = DiagnosStr + '^' + DiagnosValue
        }
      }
    }
    var PrivateSaveMethod = document.getElementById('PrivateSaveMethod').value;
    RetStr = cspRunServerMethod(PrivateSaveMethod, USERID, selValue, DiagnosStr, k);
    var Message=RetStr.split("^")[1]
    if(Message!=""){
		alert(Message+"诊断在该模板中存在重复记录！");
	}
  }
  DiagnosListChangeFlag = false;
  alert('保存成功');
  if (self.opener) self.opener.location.reload();
}
function PrivateListItemClick() {
  if (DiagnosListChangeFlag == true) {
    var DiagnosListChangeMessage = window.confirm('是否保存个人模板 ' + FristPrivteDesc + ' 的修改');
    if (DiagnosListChangeMessage == true) {
	     SavePriVateDiagnosList();
	      /*var USERID = session['LOGON.USERID'];
	      for (k = 1; k < 6; k++) {
	        var DiagnosListObj = document.getElementById('DiagnosList' + k);
	        var DiagnosStr = '';
	        for (i = 0; i < DiagnosListObj.length; i++) {
		          var DiagnosValue = DiagnosListObj.options[i].value;
		          var DiagnosText = DiagnosListObj.options[i].text;
		          if ((DiagnosValue=="")&&(DiagnosText!="")){
			        DiagnosValue=DiagnosValue+"$"+DiagnosText
			      }
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
	      }*/
    }

  }
  DiagnosListChangeFlag = false;

  var ListObj = document.getElementById('PrivateList');
  for (k = 1; k < 6; k++) {
    var DiagnosListObj = document.getElementById('DiagnosList' + k);
    var DiagnosStr = '';
    var PrivateListObj = document.getElementById('PrivateList');
    var selIndex = PrivateListObj.selectedIndex;
    if (selIndex < 0) {
      alert('没有选择个人模板');
      return
    }
    var selValue = PrivateListObj.options[selIndex].value;
    var selText = PrivateListObj.options[selIndex].text;
    FristPrivteDesc = selText;
    FristPrivteValue = selValue;
    DiagnosListObj.length = 0;
    if (ListCustomWidth)DiagnosListObj.style.width = ListCustomWidth;
    if (selValue != '') {
      var GetICDMethod = document.getElementById('GetICDMethod').value;
      DiagnosStr = cspRunServerMethod(GetICDMethod, selValue, k);
      
      if (DiagnosStr != '') {
        DiagnosListArray = DiagnosStr.split(String.fromCharCode(1));
        for (i = 0; i < DiagnosListArray.length; i++) {
          DiagnosDesc = DiagnosListArray[i].split('^')[1];
          DiagnosValue = DiagnosListArray[i].split('^')[0];
          DiagnosListObj.add(new Option(DiagnosDesc, DiagnosValue))
        }
      }
    }
  }
  UnCTlocListFocus();
  document.getElementById('PrivateSave').disabled = false;
  document.getElementById('AddToCtloc').disabled = false;
  document.getElementById('AddToPrivate').disabled = true;

}
function combo_CtLocKeyenterhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13){ 
		combo_CtLocSelecthandler();
	}
}
function combo_CtLocSelecthandler() {
  CTLocDesc = combo_CtLoc.getSelectedText();
  CTLocValue = combo_CtLoc.getSelectedValue();
  var GetCTLocTempletMethod = document.getElementById('GetCTLocTempletMethod').value;
  Ret = cspRunServerMethod(GetCTLocTempletMethod, CTLocValue);
  if (Ret != '') {
    var CTLocTempletIndexNum = Ret.split(String.fromCharCode(2))[1];
    var CTLocTempletStr = Ret.split(String.fromCharCode(2))[0];
    if (CTLocTempletIndexNum != '') {
      document.getElementById('CTLocTempletIndexNum').value = CTLocTempletIndexNum;
    };
	var CtLocListObj = document.getElementById('CtLocList');
    if (CTLocTempletStr != '') {
      CtLocListArray = CTLocTempletStr.split(String.fromCharCode(1));
      CtLocListObj.length = 0;
      for (i = 0; i < CtLocListArray.length; i++) {
        CtLocListRowid = CtLocListArray[i].split("^")[0];
        CtLocListDesc = CtLocListArray[i].split("^")[1];
        CtLocListObj.add(new Option(CtLocListDesc, CtLocListRowid));
      }
    }else{
		CtLocListObj.length=0;
	}
  }
}

function CtLocListItemClick() {
 if (DiagnosListChangeFlag == true) {
    var DiagnosListChangeMessage = window.confirm('是否保存个人模板 ' + FristPrivteDesc + ' 的修改');
    if (DiagnosListChangeMessage == true) {
	     SavePriVateDiagnosList();
    }
  }
  DiagnosListChangeFlag = false;
 
 
  var CtLocListObj = document.getElementById('CtLocList');
  for (k = 1; k < 6; k++) {
    var DiagnosListObj = document.getElementById('DiagnosList' + k);
    var DiagnosStr = '';
    var CtLocListObj = document.getElementById('CtLocList');
    var selIndex = CtLocListObj.selectedIndex;
    if (selIndex < 0) {
      alert('没有选择科室模板');
      return
    }
    var selValue = CtLocListObj.options[selIndex].value;
    var selText = CtLocListObj.options[selIndex].text;
    DiagnosListObj.length = 0;
    if (selValue != '') {
      var GetICDMethod = document.getElementById('GetICDMethod').value;
      DiagnosStr = cspRunServerMethod(GetICDMethod, selValue, k);
      if (DiagnosStr != '') {
        DiagnosListArray = DiagnosStr.split(String.fromCharCode(1));
        for (i = 0; i < DiagnosListArray.length; i++) {
          DiagnosDesc = DiagnosListArray[i].split('^')[1];
          DiagnosValue = DiagnosListArray[i].split('^')[0];
          DiagnosListObj.add(new Option(DiagnosDesc, DiagnosValue))
        }
      }
    }
  }
  UnPrivateFocus();
  document.getElementById('PrivateSave').disabled = true;
  document.getElementById('AddToCtloc').disabled = true;
  document.getElementById('AddToPrivate').disabled = false;
}

function UnPrivateFocus() {
  var ListObj = document.getElementById('PrivateList');
  for (i = ListObj.length - 1; i >= 0; i--) {
    if (ListObj.options[i].selected == true) {
      ListObj.options[i].selected = false;
    }
  }
}

function UnCTlocListFocus() {
  var CtLocListObj = document.getElementById('CtLocList');
  for (i = CtLocListObj.length - 1; i >= 0; i--) {
    if (CtLocListObj.options[i].selected == true) {
      CtLocListObj.options[i].selected = false;
    }
  }
}

function AddToPrivateObjClick() {
  if (document.getElementById('AddToPrivate').disabled == true) return;
  var CtLocListObj = document.getElementById('CtLocList');
  var selIndex = CtLocListObj.selectedIndex;
  if (selIndex < 0) {
    alert('没有选择科室模板');
    return
  };
  var CTLocTempletRowid = CtLocListObj.options[selIndex].value;
  if (CTLocTempletRowid == '') return;
  var USERID = session['LOGON.USERID'];
  var privateDesc=CtLocListObj[selIndex].text.split(" ")[0];
  if (CheckPrivateNameIsRepeat(privateDesc,"")){
	  alert(privateDesc+" 模板名重复!")
	  return false;
  }
  var AddPrivateMethod = document.getElementById('CTLocAddToPrivateMethod').value;
  Ret = cspRunServerMethod(AddPrivateMethod, CTLocTempletRowid, USERID);
  GetPrivateList();
}

function AddToCTLocTemplet() {
  if (document.getElementById('AddToCtloc').disabled == true) return;
  var PrivateListObj = document.getElementById('PrivateList');
  var selIndex = PrivateListObj.selectedIndex;
  var PrivateListRowid = PrivateListObj.options[selIndex].value;
  if (PrivateListRowid == '') return;
  var CTLOCID = session['LOGON.CTLOCID'];
  if (CTLOCID == '') return;
  var AddToCTLocTempletMetod = document.getElementById('AddToCTLocTempletMetod').value;
  Ret = cspRunServerMethod(AddToCTLocTempletMetod, PrivateListRowid, CTLOCID);
  if (Ret == '0') {
    alert('保存到科室成功')
  } else {
    alert('保存到科室失败:'+Ret);
    return
  };
  var CTLocValue = combo_CtLoc.getSelectedValue();
  if (CTLocValue != '') combo_CtLocSelecthandler();

}
//lpd
function DelFromCTLocTemplet() {
  //if (document.getElementById('AddToCtloc').disabled == true) return;
  var PrivateListObj = document.getElementById('PrivateList');
  var selIndex = PrivateListObj.selectedIndex;
  var PrivateListRowid = PrivateListObj.options[selIndex].value;
  if (PrivateListRowid == '') return;
  var CTLOCID = session['LOGON.CTLOCID'];
  if (CTLOCID == '') return;
  var AddToCTLocTempletMetod = document.getElementById('DelFromCTLocTempletMethod').value;
  Ret = cspRunServerMethod(AddToCTLocTempletMetod, PrivateListRowid, CTLOCID);
  if (Ret == '0') {
    alert('删除科室模板成功')
  } else {
    alert('删除科室模板失败');
    return
  };
  var CTLocValue = combo_CtLoc.getSelectedValue();
  if (CTLocValue != '') combo_CtLocSelecthandler();

}
function ReturnMrdiagnosFun() {
  if (PrivateChangeFlag == true) {
    var PrivateChangeFlagMessage = window.confirm('是否保存个人模板显示顺序的修改');
    if (PrivateChangeFlagMessage == true) {
      PrivateorderSaveFUN();
    }
  }
  if (DiagnosListChangeFlag == true) {
    var DiagnosListChangeMessage = window.confirm('是否保存个人模板 ' + FristPrivteDesc + ' 的修改');
    if (DiagnosListChangeMessage == true) {
	   SavePriVateDiagnosList();
      /*var USERID = session['LOGON.USERID'];
      for (k = 1; k < 6; k++) {
        var DiagnosListObj = document.getElementById('DiagnosList' + k);
        var DiagnosStr = '';
        for (i = 0; i < DiagnosListObj.length; i++) {
          var DiagnosValue = DiagnosListObj.options[i].value;
          var DiagnosText = DiagnosListObj.options[i].text;
          if ((DiagnosValue=="")&&(DiagnosText!="")){
	       DiagnosValue=DiagnosValue+"$"+DiagnosText
	      }
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
      }*/
    }
  }
  window.opener.location.reload();
  window.close();
}
function CopyAllToClipboard()
{
  var CtLocListObj = document.getElementById('CtLocList');
  var selIndex = CtLocListObj.selectedIndex;
  if (selIndex < 0) {
    alert('没有选择科室模板');
    return
  };
   var DiagnosStrSub = 'DHCCA';
   var DiagnosStr=""
   for(k=1;k<6;k++){
  	var DiagnosListObj=document.getElementById("DiagnosList"+k);
  	if (!DiagnosListObj) continue;
   	if(DiagnosListObj){
	   	//if (k > 1)
	   //	{DiagnosStr = DiagnosStr + "DHCCBDHCCA"
		//   	}
        for (i = 0; i < DiagnosListObj.length; i++) {
        //if (DiagnosListObj.options[i].selected==false) continue;
        var DiagnosValue= DiagnosListObj.options[i].value;
        var DiagnosText = DiagnosListObj.options[i].text;
        if ((DiagnosValue != '') & (DiagnosText != '')) {
        if (DiagnosStr == '') {
          DiagnosStr =DiagnosValue+'^'+DiagnosText
        } else {
          DiagnosStr = DiagnosStr + String.fromCharCode(2) + DiagnosValue+'^'+DiagnosText
        }
      }
    }
  }
 } 
 DiagnosStr=DiagnosStrSub+ String.fromCharCode(2) +DiagnosStr
 if(window.clipboardData) {   
              window.clipboardData.clearData();   
              window.clipboardData.setData("Text", DiagnosStr);
            alert("复制成功");   
      }  
 }

function BPasteAll(){
 	 var PasteText=window.clipboardData.getData("text");
 	 PasteAllArray=PasteText.split("DHCCB");
 	 for (k = 0; k < PasteAllArray.length; k++) {
	 	 var Pasteitem=PasteAllArray[k]
		 PasteArray=Pasteitem.split(String.fromCharCode(2));
		 if (PasteArray.length<2){continue;}
		 if (PasteArray[0]!='DHCCA'){alert('粘贴板里面的内容不是科室诊断');return}
		 for(i=1;i<PasteArray.length;i++){
		 	DiagnosDesc=PasteArray[i].split('^')[1];
		 	Diagnosvalue=PasteArray[i].split('^')[0];
			 DiagnosListObj = document.getElementById('DiagnosList'+(k+1));
			 if (!DiagnosListObj){continue;}

		 	if ((DiagnosDesc=='')||(Diagnosvalue=='')) continue;
/*		    if (DiagnosListObj.options[0].text == ''){
		    	DiagnosListObj.options[0].text=DiagnosDesc;
		    	DiagnosListObj.options[0].value=Diagnosvalue;
		    	}else{
*/
		      DiagnosListObj.add(new Option(DiagnosDesc, Diagnosvalue));
//		      }
		}
      	DiagnosListChangeFlag = true;
 	 }
	alert("粘贴结束");
	}
function BPasteFun(){
	if (PrivateChangeFlag == true) {
    var PrivateChangeFlagMessage = window.confirm('是否保存个人模板显示顺序的修改');
    if (PrivateChangeFlagMessage == true) {
      PrivateorderSaveFUN();
    }
  }
  if (DiagnosListChangeFlag == true) {
    var DiagnosListChangeMessage = window.confirm('是否保存个人模板 ' + FristPrivteDesc + ' 的修改');
    if (DiagnosListChangeMessage == true) {
	    SavePriVateDiagnosList();
      /*var USERID = session['LOGON.USERID'];
      for (k = 1; k < 6; k++) {
        var DiagnosListObj = document.getElementById('DiagnosList' + k);
        var DiagnosStr = '';
        for (i = 0; i < DiagnosListObj.length; i++) {
          var DiagnosValue = DiagnosListObj.options[i].value;
          var DiagnosText = DiagnosListObj.options[i].text;
          if ((DiagnosValue=="")&&(DiagnosText!="")){
	      DiagnosValue=DiagnosValue+"$"+DiagnosText
	  }
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
      }*/
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
  }
 	 var PasteText=window.clipboardData.getData("text");
	 PasteArray=PasteText.split(String.fromCharCode(2));
	 if (PasteArray[0]!='DHCCA'){alert('粘贴板里面的内容不是科室诊断');return}
	 DiagnosListObj = document.getElementById('DiagnosList' + ListNum);
	 if (!DiagnosListObj){return;}
	 for(i=1;i<PasteArray.length;i++){
	 	DiagnosDesc=PasteArray[i].split('^')[1];
	 	Diagnosvalue=PasteArray[i].split('^')[0];
	 	if ((DiagnosDesc=='')||(Diagnosvalue=='')) continue;
	    /*if ((DiagnosListObj.options.length==0)||(DiagnosListObj.options[0].text == '')){
	    	DiagnosListObj.options[0].text=DiagnosDesc;
	    	DiagnosListObj.options[0].value=Diagnosvalue;
	    }else{*/
	      DiagnosListObj.add(new Option(DiagnosDesc, Diagnosvalue));
	    //}
	    DiagnosListChangeFlag = true;
	}
	alert("粘贴结束");
	}
function CNDiagnoseFlagClick()
{
  var CNDiagnoseFlag=0;
  var CNDiagnoseFlagObj = document.getElementById("CNDiagnoseFlag");
  if (CNDiagnoseFlagObj) {
	  CNDiagnoseFlag = CNDiagnoseFlagObj.checked;
	  if (CNDiagnoseFlag) {
	  	CNDiagnoseFlag=1;
	  }else {
	  	CNDiagnoseFlag=0;
	  }  
  }
  // 0 西医 1 中医 2 证型
  document.getElementById("CNDiagnoseFlag1").value=CNDiagnoseFlag
  var obj=document.getElementById("SyndromeFlag");
  if (obj){
	  obj.checked=false;
  }
}
function SyndromeFlagClick(){
	var obj=document.getElementById("CNDiagnoseFlag");
	if (obj){
		  obj.checked=false;
	}
	var obj1=document.getElementById("CNDiagnoseFlag1");
	var SyndromeFlagObj = document.getElementById("SyndromeFlag");
	if (SyndromeFlagObj){
		if (SyndromeFlagObj.checked){
			obj1.value=2;
		}else{
			obj1.value=0;
		}
	}
}
function AddPrivateItem(){
	var DiagnosDesc=document.getElementById("DiagnosDesc").value;
	var DiagnosValue="";
	if((DiagnosDesc=="")&&(DiagnosValue=="")){
		alert("请在诊断名称处录入非ICD诊断!")
		websys_setfocus("DiagnosDesc")
		return false;
	}
	if(DiagnosValue!=""){
		alert("增加按钮只能用来添加非ICD诊断")
		return false;
	}
	var ListNum = '';
    ListNum = SetListFocus();
    var obj=document.getElementById('CNDiagnoseFlag1');
	if (obj.value=="2"){
		AddSyndromItem(DiagnosValue,DiagnosDesc,ListNum);
	}else{
		if ((DiagnosDesc != '')&& (DiagnosValue == '')) {
			DiagnosListObj = document.getElementById('DiagnosList' + ListNum);
			if (!CheckRepeat(DiagnosValue,DiagnosDesc)) {
				websys_setfocus("DiagnosDesc")
				return false;
			}
			/*if ((DiagnosListObj.options!=undefined)&&(DiagnosListObj.options[0].text == '')) {
				DiagnosListObj.options[0].text = DiagnosDesc;
				DiagnosListObj.options[0].value = DiagnosValue;
			} else {*/
				DiagnosListObj.add(new Option(DiagnosDesc, DiagnosValue));
				DiagnosListChangeFlag = true;
		    //}
		   document.getElementById("DiagnosDesc").value=""
		   websys_setfocus("DiagnosDesc")
		}  
		
	}
}
function AddSyndromItem(DiagnosValue,DiagnosDesc,ListNum){
	var DiagnosListObj = document.getElementById('DiagnosList' + ListNum);
	var selmasterId="",selmasterIdStr="",newValue="",newText="";
	//如果维护证型则需要先选中一条中医诊断
   var sourceObj = document.getElementById('DiagnosList' + ListNum);
   if (sourceObj){
	    var selIndex = sourceObj.selectedIndex;
	    if (selIndex<0){
		    alert("请选中一条中医诊断!");
			return false;
		}
	    var id=sourceObj.options[selIndex].value;
	    var text=sourceObj.options[selIndex].text;
		var selMaterIdInfo=id.split("*")[0];
		var selMaterTextInfo=text.split("*")[0];
		if (selMaterIdInfo.indexOf("$")==-1){
			var masterId=selMaterIdInfo;
			if(masterId!=""){
				//判断是否是中医诊断 
				var ret=tkMakeServerCall("web.DHCMRDiagnos","CheckIsCNICD",masterId);
				if (ret=="0") {
					alert("请选中一条中医诊断!");
					return false;
				}
			}
		}
		var OldTextSyndromInfo=text.split("*")[1];
		if ((OldTextSyndromInfo=="")||(OldTextSyndromInfo==undefined)){
			newText=selMaterTextInfo+"*"+DiagnosDesc;
		}else{
			newText=selMaterTextInfo+"*"+OldTextSyndromInfo+"!"+DiagnosDesc;
		}
		
		
		var SyndromInfo=id.split("*")[1];
	    if ((SyndromInfo=="")||(SyndromInfo==undefined)){
		    if (DiagnosValue!=""){
			    newValue=selMaterIdInfo+"*"+DiagnosValue+"#";
			}else{
				newValue=selMaterIdInfo+"*"+DiagnosValue+"#"+DiagnosDesc;
			}
			
		}else{
			var IdSyndromInfo=SyndromInfo.split("#")[0];
			var TextSyndromInfo=SyndromInfo.split("#")[1];
			if ((IdSyndromInfo=="")&&(TextSyndromInfo=="")){
				if (DiagnosValue!=""){
				    newValue=selMaterIdInfo+"*"+DiagnosValue+"#";
				}else{
					newValue=selMaterIdInfo+"*"+DiagnosValue+"#"+DiagnosDesc;
				}
			}else{
				if (DiagnosValue!=""){
					//DiagnosValue,DiagnosDesc
					if (("!"+IdSyndromInfo+"!").indexOf("!"+DiagnosValue+"!")>=0){
						alert(DiagnosDesc+" 已存在!")
						return false;
					}
					newValue=selMaterIdInfo+"*"+IdSyndromInfo+"!"+DiagnosValue+"#"+TextSyndromInfo+"!";
				}else{
					if (("!"+TextSyndromInfo+"!").indexOf("!"+DiagnosDesc+"!")>=0){
						alert(DiagnosDesc+" 已存在!")
						return false;
					}
					newValue=selMaterIdInfo+"*"+IdSyndromInfo+"!"+DiagnosValue+"#"+TextSyndromInfo+"!"+DiagnosDesc;
				}
				
			}
		}
	}
   if (newValue!="") DiagnosValue=newValue;
   if (newText!="") DiagnosDesc=newText;
   //DiagnosListObj.options[selIndex].text = DiagnosDesc;
   //DiagnosListObj.options[selIndex].value = DiagnosValue;
   DiagnosListObj.options[selIndex]=new Option(DiagnosDesc,DiagnosValue); 
   DiagnosListObj.options[selIndex].selected=true;
   DiagnosListChangeFlag = true;
   document.getElementById("DiagnosDesc").value=""
   websys_setfocus("DiagnosDesc")
}
function SavePriVateDiagnosList(){
	var USERID = session['LOGON.USERID'];
    for (k = 1; k < 6; k++) {
	    var DiagnosListObj = document.getElementById('DiagnosList' + k);
	    var DiagnosStr = '';
	    for (i = 0; i < DiagnosListObj.length; i++) {
	      var DiagnosValue = DiagnosListObj.options[i].value;
	      var DiagnosText = DiagnosListObj.options[i].text;
	      var MainICDInfo="",NewSyndromInfo="";
	      
	      if (DiagnosValue!=""){
		      var mainId=DiagnosValue.split("*")[0];
		      var mainText=DiagnosText.split("*")[0];
		      if ((mainId=="")&&(mainText!="")){
			      MainICDInfo="$"+mainText;
			  }else{
				  MainICDInfo=mainId;
			  }
			  var SyndromInfo=DiagnosValue.split("*")[1];
			  if ((SyndromInfo!="")&&(SyndromInfo!=undefined)){
				 var idStr=SyndromInfo.split("#")[0];
				 var descStr=SyndromInfo.split("#")[1];
				 for (var m=0;m<idStr.split("!").length;m++){
					 var oneId=idStr.split("!")[m];
					 if (oneId==""){
						 oneId=descStr.split("!")[m];
					 }
					 if (oneId=="") continue;
					 if (NewSyndromInfo=="") NewSyndromInfo=oneId;
					 else NewSyndromInfo=NewSyndromInfo+"!"+oneId;
				 }
			  }
			  if (NewSyndromInfo!="") MainICDInfo=MainICDInfo+"!"+NewSyndromInfo;
			  if (MainICDInfo!="") DiagnosValue=MainICDInfo;
		  }else{
			  if ((DiagnosValue=="")&&(DiagnosText!="")){
			      DiagnosValue=DiagnosValue+"$"+DiagnosText
			  }
		  }
		  
	      if ((DiagnosValue != '') & (DiagnosText != '')) {
	        if (DiagnosStr == '') {
	          DiagnosStr = DiagnosValue
	        } else {
	          DiagnosStr = DiagnosStr + '^' + DiagnosValue
	        }
	      }
	    }
	    var PrivateSaveMethod = document.getElementById('PrivateSaveMethod').value;
	    RetStr = cspRunServerMethod(PrivateSaveMethod, USERID, FristPrivteValue, DiagnosStr, k);
  }
}
function CheckPrivateNameIsRepeat(checkName,index){
	var listObj = document.getElementById('PrivateList');
	for (l = listObj.length - 1; l >= 0; l--) {
		if ((index!="")&&(l==index)) continue;
     	var PrivateDesc = listObj.options[l].text;
     	if (checkName==PrivateDesc) {
	     	return true;
	    }
	}
	return false;
}
document.body.onload = BodyLoadHandler;