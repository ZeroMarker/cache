/// DHCPEMonthStatistic.js
/// ����ʱ��		2007.07.13
/// ������			xuwm
/// ��Ҫ����		��ͳ�Ʊ���
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���	

var CurrentSel=0;

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("btnPrint")
	if (obj) { obj.onclick=Print_click; }

	obj=document.getElementById('ImportDate');
	if (obj) {
		obj.onchange = ImportDate_change;
	}
	iniForm();

}

function BodyUnLoadHandler() {

	var obj;

}

function iniForm() {
	var obj;
	var now= new Date();

	obj=document.getElementById("ImportDate")
	if (obj) { obj.value=now.getYear()+"-"+now.getMonth(); }
	
	obj=document.getElementById("SavePath")
	if (obj) { obj.value='D:\\'+now.getMonth()+"�·�����.xls"; }
	
}

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//����Ϊ��
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function ImportDate_change() {
	
	
}

function Print_click() {
	var obj;
	/*
	var  value=  '1^2007/04/1^45;'
				+'2^2007/04/2^51;'
				+'7^2007/04/7^12;'
				+'10^2007/04/10^45;'
				+'13^2007/04/13^32;'
				+'15^2007/04/15^21;'
				+'16^2007/04/16^52;'
				+'23^2007/04/23^101;'
				+'29^2007/04/29^85;'
				+'30^2007/04/30^96;'
	*/
	
	var SaveFilePath='';
	var ImportDate="";
	obj=document.getElementById("ImportDate")
	if (obj && ""!=obj.value) {
		ImportDate=obj.value;
	}
	var Instring=ImportDate;
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'','',Instring)	
	//alert(flag)
	//if (flag=='0') {}
	
	obj=document.getElementById("SavePath")
	if (obj && ""!=obj.value) { SaveFilePath=obj.value; }

	DataImport(value,ImportDate,SaveFilePath);
	
}

document.body.onload = BodyLoadHandler;
