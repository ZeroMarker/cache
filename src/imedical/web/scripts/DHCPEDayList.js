/// 
//����	DHCPEDayList.js
//����	�����Ա�б�
//���	
//����	
//����	2007.01.10
//����޸�ʱ��	
//����޸���
//���

var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("Print");
	if (obj) { obj.onclick=Print_click; }
	
	iniForm();
}

function iniForm(){

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}


function Print_click() {
	//alert('Print_click');
	var obj,PEDate='';
	obj=document.getElementById("PEDate")
	if (obj) { PEDate=obj.value; }

	PrintPEDayList(PEDate); // DHCPEDayListImport.js
}

document.body.onload = BodyLoadHandler;