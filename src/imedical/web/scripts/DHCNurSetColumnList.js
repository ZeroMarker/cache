var selrow="";
var SelectedRow = "";
var Tbl = document.getElementById("tDHCNurSetColumnList");

function BodyLoadHandler() {
  //var queryTypeCode=document.getElementById("queryTypeCode").value;
  //var index=document.getElementById("index").value;
  //var HospitalRowId=document.getElementById("HospitalRowId").value;
  //alert(queryTypeCode+" "+HospitalRowId)
  var obj = document.getElementById('add');
  if (obj) {
    obj.onclick = add_click;
  }
  var DelBt = document.getElementById("Del");
  if (DelBt) {
    DelBt.onclick = Delclick;
  }
  var UpdateBt = document.getElementById("Update");
  if (UpdateBt) {
    UpdateBt.onclick = UpdateBtclick;
  }
}

function UpdateBtclick() {
  var index = document.getElementById("index").value;
  if (index == -1) {
    alert("not type!");
    return false;
  }
  if (selrow == ""){
    alert("请选择一条记录!")
    return;
  }
  var queryTypeCode = document.getElementById("queryTypeCode").value;
  var HospitalRowId = document.getElementById("HospitalRowId").value;
  var Typ = HospitalRowId + "@" + queryTypeCode
  var columName = document.getElementById("txtcolumName").value;
  var columWTH = document.getElementById("txtcolumWTH").value;
  var seqno = document.getElementById("txtseqno").value;
  var ordLinkID = document.getElementById("hntxtLinkID").value;
  if ((columName == "") || (columWTH == "") || (seqno == "")) {
    alert("not null")
    return false;
  }
  columWTH = columWTH * 56.7;
  columWTH = columWTH.toFixed(1);

  var OrdLink = document.getElementById("txtOrdLink").value;
  if (OrdLink == "") {
    ordLinkID = ""
  }
  if (selrow != "") {
    var rw = document.getElementById("Rwz" + selrow).innerText;
    var UpdateTitl = document.getElementById("UpdateTitl").value;
    var TypStr = columName + "|" + columWTH + "|" + OrdLink + "|" + ordLinkID + "|" + seqno
    var ret;
    ret = cspRunServerMethod(UpdateTitl, rw, TypStr, Typ);
  }
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetColumnList&queryTypeCode=" + queryTypeCode + "&Index=" + index + "&HospitalRowId=" + HospitalRowId;
  window.location.href = lnk;


}

function DHCWeb_GetRowIdx(wobj) {
  try {
    var eSrc = wobj.event.srcElement;
    //alert(wobj.name);
    if (eSrc.tagName == "IMG") eSrc = wobj.event.srcElement.parentElement;
    var rowObj = getRow(eSrc);
    var selectrow = rowObj.rowIndex;
    return selectrow
  } catch (e) {
    alert(e.toString());
    return -1;
  }
}

function SelectRowHandler() {
  selrow = DHCWeb_GetRowIdx(window);
  var columName = document.getElementById("txtcolumName");
  var columWTH = document.getElementById("txtcolumWTH");
  var seqno = document.getElementById("txtseqno");
  var ordLinkID = document.getElementById("hntxtLinkID");
  var OrdLink = document.getElementById("txtOrdLink");
  var wth = document.getElementById("columWTHz" + selrow).innerText;
  wth = wth.split("mm");
  columName.value = document.getElementById("columNamez" + selrow).innerText
  columWTH.value = wth[0];
  seqno.value = document.getElementById("seqnoz" + selrow).innerText
  ordLinkID.value = document.getElementById("LinkIDz" + selrow).innerText
  OrdLink.value = document.getElementById("OrdLinkz" + selrow).innerText;
  if (SelectedRow == selrow) {
    if (columName) columName.value = "";
    if (columWTH) columWTH.value = "";
    if (seqno) seqno.value = "";
    if (ordLinkID) ordLinkID.value = "";
    if (OrdLink) OrdLink.value = "";
     selrow=""
  }
  SelectedRow = selrow;


}

function Delclick() {
	var index = document.getElementById("index").value;
	if (index == -1) {
		return false;
	}
	//var Typ=Code.options[index].value;
	var queryTypeCode = document.getElementById("queryTypeCode").value;
	var HospitalRowId = document.getElementById("HospitalRowId").value;
	var Typ = HospitalRowId + "@" + queryTypeCode
		if (selrow != "") {
			var r = confirm("确认删除?")
				if (r == true) {
					var rw = document.getElementById("Rwz" + selrow).innerText;
					var DelFun = document.getElementById("DelFun").value;
					var ret;
					ret = cspRunServerMethod(DelFun, Typ, rw);
					alert("删除成功")
					var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetColumnList&queryTypeCode=" + queryTypeCode + "&Index=" + index + "&HospitalRowId=" + HospitalRowId;
					window.location.href = lnk;
				} 
		} else {
			alert("请选择一条记录")
		}
}

function add_click() { //Add
  var index = document.getElementById("index").value;
  if (index == -1) {
    alert("not type!");
    return false;
  }
  //var Typ=Code.options[index].value;
  var queryTypeCode = document.getElementById("queryTypeCode").value;
  var HospitalRowId = document.getElementById("HospitalRowId").value;
  var Typ = HospitalRowId + "@" + queryTypeCode
  var mthnadd = document.getElementById("mthnadd").value;
  var columName = document.getElementById("txtcolumName").value;
  var columWTH = document.getElementById("txtcolumWTH").value;
  var seqno = document.getElementById("txtseqno").value;
  var ordLinkID = document.getElementById("hntxtLinkID").value;
  if ((columName == "") || (columWTH == "") || (seqno == "")) {
    alert(t['alert:null'])
    return false;
  }
  columWTH = columWTH * 56.7;
  columWTH = columWTH.toFixed(1);
  //alert(columWTH);
  // 1mm=56.7;
  var OrdLink = document.getElementById("txtOrdLink").value;

  var res = cspRunServerMethod(mthnadd, Typ, seqno, columName + "|" + columWTH + "|" + OrdLink + "|" + ordLinkID + "|" + seqno)

  if (res == 0) { //add ok
    alert(t['alert:success']);
  } else {
    alert(t['alert:error']);
  }
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetColumnList&queryTypeCode=" + queryTypeCode + "&Index=" + index + "&HospitalRowId=" + HospitalRowId;
  window.location.href = lnk;

}


function getOrdLinkID(str) {
  var arryLinkID = str.split("^");
  var obj = document.getElementById("hntxtLinkID")
  obj.value = arryLinkID[1];
  //sch_click();

}

function Trim(str) {
  return str.replace(/[\t\n\r ]/g, "");
}

function isInteger(objStr) {
  var reg = /^\+?[0-9]*[0-9][0-9]*$/;
  var ret = objStr.match(reg);
  if (ret == null) {
    return false
  } else {
    return true
  }
}

function isNumber(objStr) {
  strRef = "-1234567890.";
  for (i = 0; i < objStr.length; i++) {
    tempChar = objStr.substring(i, i + 1);
    if (strRef.indexOf(tempChar, 0) == -1) {
      return false;
    }
  }
  return true;
}
document.body.onload = BodyLoadHandler;