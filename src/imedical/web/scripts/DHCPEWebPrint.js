document.write('<object classid ="clsid:DC2A3C42-24DC-4FD6-836A-A2E8594ABC15" codebase ="ReYoPrint.CAB#version=1,601,0,2102" id="ReYoPrint1" width="0" height="0"></object>')

function SetAttribute(URL)
{
    	ReYoPrint1.ContentURL=URL;
    	ReYoPrint1.Copies =1;   5 ;//'��ӡ����
    	ReYoPrint1.Orientation =1 ;//'��ӡ����s  1����  2����
	
	ReYoPrint1.PaperSize = "A4";
	
    	ReYoPrint1.selectedPages = false;
    	ReYoPrint1.pageFrom = 1;
    	ReYoPrint1.pageTo =  2;
    	ReYoPrint1.pageHeight = 0;
    	ReYoPrint1.pageWidth = 0;
    	ReYoPrint1.marginBottom = 10;
    	ReYoPrint1.marginLeft = 10;
    	ReYoPrint1.marginRight = 10;
    	ReYoPrint1.marginTop = 20;
	ReYoPrint1.header='<IMG src="http://www.baidu.com/img/baidu_logo.gif"width="100" height="42" border="0">  <span style="color:#339900;font-size:11px"><strong>֧��html��ͼ�Ĳ�ïҳü</strong></span><hr size="1" /> ';  //ҳü
	ReYoPrint1.footer='<hr width="100%" size="1" /><div style="float:right"><span style="color:#339900;font-size:11px">֧��html��ͼ�Ĳ�ïҳ��</span></div>';����//ҳ��
	ReYoPrint1.defaultPrinterName='fapiao';
	ReYoPrint1.ShowMargin=false;  //��ʾ�߾�
	ReYoPrint1.ShowHeaderFooter=true;   //�Ƿ�����ҳüҳ��
	if(true)
	{
		ReYoPrint1.SetMarginMeasure(1);
	}
	else
	{
		ReYoPrint1.SetMarginMeasure(2);
	}
}
function Preview(URL)
{
	SetAttribute(URL);
	ReYoPrint1.Preview();
}
function print(URL)
{
	SetAttribute(URL);
	ReYoPrint1.ReYoPrint(true)
}