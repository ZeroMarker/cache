var SelectedRow = 0;

function BodyLoadHandler() {
	var obj = document.getElementById('AddBtn')
	if (obj) obj.onclick = BADD_click;
	var obj = document.getElementById('UpdBtn')
	if (obj) obj.onclick = BUpdate_click;
	var obj = document.getElementById('DelBtn')
	if (obj) obj.onclick = BDelete_click;
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tDHCNURTEMXMLConfig');
	var rows = objtbl.rows.length;
	var lastrowindex = rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) return;
	var obj1 = document.getElementById('CLlocId');
	var obj2 = document.getElementById('CTLoc');
	var obj3 = document.getElementById('XMLFileName');	
	var obj4 = document.getElementById('xmlNote');
	var obj5 = document.getElementById('xmlRowID');
	
	
	var SelRowObj1 = document.getElementById('CTLocDRz' + selectrow);
	var SelRowObj2 = document.getElementById('CTLocDescz' + selectrow);
	var SelRowObj3 = document.getElementById('XMLFileNamez' + selectrow);
	var SelRowObj4 = document.getElementById('notez' + selectrow);
	var SelRowObj5 = document.getElementById('rowIDz' + selectrow);
	
	if (obj1) obj1.value = SelRowObj1.innerText;
	if (obj2) obj2.value = SelRowObj2.innerText;
	if (obj3) obj3.value = SelRowObj3.innerText;
	if (obj4) obj4.value = SelRowObj4.innerText;
	if (obj5) obj5.value = SelRowObj5.innerText;
	
	var tmpSelectRow=selectrow;
	if (SelectedRow == selectrow) {
		if (obj1) obj1.value = "";
		if (obj2) obj2.value = "";
		if (obj3) obj3.value = "";
		if (obj4) obj4.value = "";
		if (obj5) obj5.value = "";
		tmpSelectRow="";
		SelectedRow="";
	}
	SelectedRow = tmpSelectRow;
}

function BADD_click() {
	var CTLocobj = document.getElementById('CTLoc');
	if (CTLocobj) var CTLoc = CTLocobj.value;
	var CTLocIdVal = document.getElementById('CLlocId').value;
	if ((CTLoc == "")||(CTLocIdVal=="")) {
		alert('请选择科室!');
		return;
	}
	var XMLFileobj = document.getElementById('XMLFileName');
	if (XMLFileobj) var XMLFileName = XMLFileobj.value;
	if (XMLFileName == "") {
		alert('文件名称不能为空');
		return;
	}
	
	var xmlNoteobj = document.getElementById('xmlNote');
	if (xmlNoteobj) var xmlNote = xmlNoteobj.value;
	
	var CLlocIdobj =document.getElementById('CLlocId');
	if (CLlocIdobj) var CLlocId = CLlocIdobj.value;
	
	var ret = tkMakeServerCall('Nur.DHCThreeXmlConfig','save','',CLlocId,CTLoc,XMLFileName,xmlNote);
	if(ret!="0"){
		alert(ret);
		return;
	}
	try {
		//alert("");
		window.location.reload();
	} catch (e) {};
}
function LookUpadmdep(str) {
    var temp=str.split("^");
	var arcimId=temp[1];
	document.getElementById('CLlocId').value=arcimId
}
function BUpdate_click() {
	if(SelectedRow==''){
		alert('请选中要修改的行!');
		return;
	}
	var CTLocobj = document.getElementById('CTLoc');
	if (CTLocobj) var CTLoc = CTLocobj.value;
	if (CTLoc == "") {
		alert('科室不能为空');
		return;
	}
	var XMLFileobj = document.getElementById('XMLFileName');
	if (XMLFileobj) var XMLFileName = XMLFileobj.value;
	if (XMLFileName == "") {
		alert('文件名称不能为空');
		return;
	}
	
	var xmlNoteobj = document.getElementById('xmlNote');
	if (xmlNoteobj) var xmlNote = xmlNoteobj.value;
	
	var CLlocIdobj =document.getElementById('CLlocId');
	if (CLlocIdobj) var CLlocId = CLlocIdobj.value;
	var xmlRowIDobj = document.getElementById('xmlRowID');
	if (xmlRowIDobj) var xmlRowID = xmlRowIDobj.value;
	
	var ret = tkMakeServerCall('Nur.DHCThreeXmlConfig','save',xmlRowID,CLlocId,CTLoc,XMLFileName,xmlNote);
	try {
		//alert("");
		window.location.reload();
	} catch (e) {};
}

function BDelete_click() {
	if(SelectedRow==''){
		alert('请选中要删除的行!');
		return;
	}
	if(confirm("确认删除选中的记录?")){
		var obj5 = document.getElementById('xmlRowID');
		var ret = tkMakeServerCall('Nur.DHCThreeXmlConfig','delete',obj5.value);
		if (ret != '0') {
			alert('删除失败!');
			return;
		}
		try {
			window.location.reload();
		} catch (e) {};
	}
}

document.body.onload = BodyLoadHandler;