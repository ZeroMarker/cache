
///��ӡ�û������嵥
function PrintListInfo(getlistinfo)
{
	/*
	var rptPath=document.getElementById('RptPath');
	var Template=rptPath.value+"DHCPEFeeList.xls";
	
	var getData=document.getElementById('GetPD');
	if ((getData)&&(""!=getData.value))
	{
		var encmeth=getPD.value;
		rtn=cspRunServerMethod(encmeth,rpttype,rowid,Guser,begindate,enddate);		
	}
	else
	{	return "";}	
	
	var xlsrow=1
	var xlApp,xlsheet,xlBook;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	
	var title=xlsheet.cells(xlsrow,1).value;
	var title=title.split("^");
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,1)=title[0];}
		else
		{	xlsheet.cells(xlsrow,1)=title[1];}
		//ͳ������
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,7)=val[8]+xlsheet.cells(xlsrow,7)+val[10];	//����
		//�շ�Ա��Ϣ
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[14];
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,1)=xlsheet.cells(xlsrow,1)+val[15];
		//�շѷ�Ʊ��Ϣ
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[0];
		xlsrow=xlsrow+1;
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,1)=xlsheet.cells(xlsrow,1)+val[12];}
		else
		{	//xlsheet.Rows(xlsrow+":"+xlsrow).Delete;
			xlsheet.cells(xlsrow,1)="";
			xlsheet.Rows(xlsrow+":"+xlsrow).RowHeight=1;	}
		//���Ϸ�Ʊ��Ϣ
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)+val[1];
		xlsrow=xlsrow+1;
		if ("1"==rptTypeobj.value)
		{	xlsheet.cells(xlsrow,7)=xlsheet.cells(xlsrow,7)+val[13];}
		else
		{	xlsheet.cells(xlsrow,7)="";}
		//���������Ϣ
		xlsheet.cells(xlsrow,3)=val[3];
		xlsheet.cells(xlsrow,5)=val[4];
		xlsheet.cells(xlsrow,6)=val[2];
		//С����Ϣ
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[3];
		xlsheet.cells(xlsrow,5)=val[4];
		xlsheet.cells(xlsrow,6)=val[2];
		//�ֽ���Ϣ
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,3)=val[16];
		xlsheet.cells(xlsrow,5)=val[17];
		xlsheet.cells(xlsrow,6)=val[5];
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,4)=val[2];
		
		var tmplist;
		var valList=val1.split("#");
		var len=valList.length;
		for (var i=20;i>=len;i--)
		{
			var selrow=xlsrow+i;
			xlsheet.Rows(selrow+":"+selrow).Delete;
		}
		//var tmpdesc=xlsheet.cells(xlsrow,7);
		//֧����ʽ��Ϣ
		var paysum=0
		for (var i=0;i<len;i++)
		{
			tmplist=valList[i].split("^");
			//xlsheet.cells(xlsrow,7)=tmpdesc;
			xlsheet.cells(xlsrow,8)=tmplist[6];
			amount=tmplist[1];
			if ((!amount)||(""==amount)) amount="0.00";
			xlsheet.cells(xlsrow,9)=amount;
			paysum=paysum+parseFloat(amount);
			xlsrow=xlsrow+1;
		}
		xlsheet.cells(xlsrow,4)=val[2];
		xlsheet.cells(xlsrow,9)=paysum;
		//����ϼ���Ϣ
		xlsrow=xlsrow+2;
		xlsheet.cells(xlsrow,2)="1"+xlsheet.cells(xlsrow,2);
		xlsheet.cells(xlsrow,7)=val[19]+"("+val[20]+")";
	
		xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	    */
	
}