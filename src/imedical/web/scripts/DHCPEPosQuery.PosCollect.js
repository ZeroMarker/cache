/// DHCPEPosQuery.PosCollect.js
/// ����ʱ��		2007.10.26
/// ������			xuwm
/// ��Ҫ����		��ʾ������б�-��������
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���	
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BShowImage");
	if (obj){ obj.onclick=ShowImage_click; }
	
	obj=document.getElementById("btnImport");
	if (obj){ obj.onclick=Import_click; }
		
	iniForm();
}

function iniForm() {

}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function Import_click() {
	var obj;
	obj=document.getElementById("prnpath");
	if (obj&& ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPoscollect.xls';
	}else{
		alert("��Чģ��·��");
		return;
	}
	
	xlApp= new ActiveXObject("Excel.Application"); //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //�̶�
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel�±������
	
	var Rows=tkMakeServerCall("web.DHCPE.Report.PosCollect","GetPosCollectRows")
	for (var i=2;i<=Rows;i++)
    {
	var Info=tkMakeServerCall("web.DHCPE.Report.PosCollect","GetPosCollectInfo",i)
	var Data=Info.split("^");
	    for (var j=0;j<Data.length;j++)
    	{
	    	xlsheet.cells(i,j+1).value=Data[j];
    	}
    }
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
	
}

/*
function Import_click() {
	var obj;
	
	var SaveFilePath='';

	obj=document.getElementById("ImportSavePath")
	if (obj && ""!=obj.value) { SaveFilePath=obj.value; }
	var Contion=parent.GetImportContion();
	PosCollectImport(SaveFilePath,Contion); // DHCPEPosCollectImport.js

}*/
/*
function ShowImage_click() {
	var obj;
	var DSlabel='', DSvalue='';
	obj=document.getElementById("DSlabel");
	if (obj) { DSlabel=obj.value; }
	
	obj=document.getElementById("DSvalue");
	if (obj) { DSvalue=obj.value; }

	
	var lnk='dhcpe.chart.vml.csp?a=a'
		+'&'+'Data'+'='+DSvalue
		+'&'+'Label'+'='+DSlabel
		;
	var wwidth=630;
	var wheight=440; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	mywin=window.open(lnk,"_blank",nwin);
}
*/
function ShowImage_click() { 
var fileName="DHCPEPosCollectImageInfo.raq";
DHCCPM_RQPrint(fileName); 

}

document.body.onload = BodyLoadHandler;