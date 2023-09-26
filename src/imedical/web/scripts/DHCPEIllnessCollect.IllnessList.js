/// DHCPEIllnessCollect.IllnessList.js
/// ����ʱ��		2007.12.20
/// ������			xuwm
/// ��Ҫ����		��ʾ������б�-��������
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���	
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BShowImage");
	if (obj){ obj.onclick=ShowImage_click; }
	
	obj=document.getElementById("BExport");
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
/*
function ShowImage_click() {
	var lnk='dhcpediagnosisstatistic.chart.csp';
	//var lnk='chart1.htm';
	var wwidth=630;
	var wheight=440; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	mywin=window.open(lnk,"_blank",nwin)	

	if (mywin){
 		excall = function(){
	 		var Llabel,Lvalue;
	 		
			for(var iLLoop=0;iLLoop<DSlabel.length-1;iLLoop++){
					Llabel=DSlabel[iLLoop];
					Lvalue=DSvalue[iLLoop];
					//alert(Llabel+":  :"+Lvalue);
					mywin.addChartValue(Lvalue, Llabel, true);
			}
			iLLoop=DSlabel.length-1;
			Llabel=DSlabel[iLLoop];
			Lvalue=DSvalue[iLLoop];
			//alert(Llabel+":  :"+Lvalue);
			mywin.addChartValue(Lvalue, Llabel, false);	
 		}
	}
}
*/
/*
function ShowImage_click() {
	var obj;
	var DSlabel='', DSvalue='';
	obj=document.getElementById("DSlabel");
	if (obj) { DSlabel=obj.value; }
	//alert(DSlabel);
	
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
	
var fileName="DHCPEIllnessCollectImageInfo.raq";
DHCCPM_RQPrint(fileName); 

}

function Import_click() {
	var obj;
	obj=document.getElementById("prnpath");
	if (obj&& ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEExportIllness.xls';
	}else{
		alert("��Чģ��·��");
		return;
	}
	var Rows=tkMakeServerCall("web.DHCPE.Report.IllnessCollect","GetRowLength")
	if(Rows==""){
			alert("û��Ҫ����������")
			return 
		}
	
	xlApp= new ActiveXObject("Excel.Application"); //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //�̶�
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel�±������
	var DetailFlag=0;
	var obj=document.getElementById("DetailFlag");
	if (obj&&obj.checked) DetailFlag="1";
	
	var m=0;
	for(var i=1;i<=Rows;i++)
	{
		var RowData=tkMakeServerCall("web.DHCPE.Report.IllnessCollect","GetRowData",i)
		var RowData1=RowData.split("$$")[0]
		var RowData2=RowData.split("$$")[1]
		if(RowData2=="")
		{
			var RowData1Str=RowData1.split("^")
			for(var j=0;j<RowData1Str.length;j++)
			{	
				xlsheet.cells(i,j+1).value=RowData1Str[j];
			}	
		}
		if(RowData2!="")
		{
			if( m==0) m=i+1;
			var RowData1Str=RowData1.split("^")
			for(var j=0;j<RowData1Str.length;j++)
			{	
				xlsheet.cells(m,j+1).value=RowData1Str[j];
			}
			var k=0;
			if (DetailFlag=="1"){
				var PersonData=tkMakeServerCall("web.DHCPE.Report.IllnessCollect","QueryIADMsPersonInfo",RowData2)
				var PersonDataLength=tkMakeServerCall("web.DHCPE.Report.IllnessCollect","GetRowLengthForPerInfo")
				for (var k=1;k<=PersonDataLength;k++)
				{
					var PersonDataStr=tkMakeServerCall("web.DHCPE.Report.IllnessCollect","GetRowDataForPerInfo",k)
					var PersonDataStrS=PersonDataStr.split("^")
					for(var j=0;j<PersonDataStrS.length;j++)
					{
						xlsheet.cells(m+k,j+1).value=PersonDataStrS[j];
					}
				}
			}
			m=m+k+1;
		}
	}
	/*
	xlsheet.SaveAs("d:\\��������.xls");	
	xlApp.Visible= true;
	xlApp.UserControl= true;
	*/
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;

}

document.body.onload = BodyLoadHandler;