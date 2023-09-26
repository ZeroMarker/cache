function BodyLoadHandler()
{
	var obj=document.getElementById("BPrint");
	if (obj) { obj.onclick=BPrint_click;}
}

function BPrint_click()
{
	var rptPath=document.getElementById('RptPath');
	var Template=rptPath.value+"DHCPEInvPrtDetail.xls";
	var row=0;
	var rtn;
	var getPD=document.getElementById('GetData');
	var beginrow,endrow;
	beginrow=5;
	if ((getPD)&&(""!=getPD.value))
	{
		var encmeth=getPD.value;		
	}
	if (encmeth=="") return;
	try
	{
		rtn=cspRunServerMethod(encmeth,row);
		
		var varlist=rtn.split("^");
		row=varlist[0];
		if (row=="")
		{
			alert("û������");
			return;
		}
		
		var xlsrow=3
		var refundflag="";
		var xlApp,xlsheet,xlBook;
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		
		var HosName=""
		var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
		xlsheet.cells(1,1)=HosName+"�ձ���֮"

		xlsheet.cells(xlsrow,2)=varlist[3]; 
		xlsheet.cells(xlsrow,4)=varlist[4]; 
		xlsheet.cells(xlsrow,6)=xlsheet.cells(xlsrow,6).value+" "+varlist[5]+" "+varlist[6]; 
		
		xlsrow=xlsrow+1;
		refundflag=varlist[7];
		if (refundflag=="on")
		{
			xlsheet.cells(xlsrow,1)="����Ʊ��";
			xlsheet.cells(1,1)=xlsheet.cells(1,1).value+"�˷���ϸ"; }
		else
		{	xlsheet.cells(xlsrow,1)="��ƱƱ��";
			xlsheet.cells(1,1)=xlsheet.cells(1,1).value+"��Ʊ��ϸ";}
		xlsrow=xlsrow+1;
		
		while (row!="")
		{
			xlsrow=xlsrow+1;
			rtn=cspRunServerMethod(encmeth,row);		
			varlist=rtn.split("^");
			row=varlist[0];
			
			//tdate_"^"_ttime_"^"_tamt_"^"_tflag_"^"_tuser_"^"_treceiptsno_"^"_tjkdate_"^"_tpayamt_"^"_tpaymode_"^"_tchequeno_
			//tbank_"^"_tcompany_"^"_tdeposit_"^"_tregno_"^"_tname_"^"_trowid_"^"_trefinvno
			xlsheet.cells(xlsrow,2)=varlist[15];  //����
			xlsheet.cells(xlsrow,5)=varlist[18];  //Э�������
			if ((refundflag=="on")||(varlist[6]==""))
			{	xlsheet.cells(xlsrow,1)=varlist[17];} //��Ʊ��
			else
			{	xlsheet.cells(xlsrow,1)=varlist[6];}
			if ((varlist[6]=="")&&(varlist[17]!="")) xlsheet.cells(xlsrow,1)="��"+varlist[17];
			xlsheet.cells(xlsrow,6)=varlist[5]; //����Ա
			xlsheet.cells(xlsrow,7)=varlist[1]; //����
			xlsheet.cells(xlsrow,3)=varlist[3]; //���
			xlsheet.cells(xlsrow,4)=varlist[9]; //֧����ʽ
		}
		
		xlsheet.Range(xlsheet.Cells(beginrow, 1), xlsheet.Cells(xlsrow,7)).Borders(1).LineStyle=1 ;
 		xlsheet.Range(xlsheet.Cells(beginrow, 1), xlsheet.Cells(xlsrow,7)).Borders(2).LineStyle=1;
 		xlsheet.Range(xlsheet.Cells(beginrow, 1), xlsheet.Cells(xlsrow,7)).Borders(3).LineStyle=1 ;
 		xlsheet.Range(xlsheet.Cells(beginrow, 1), xlsheet.Cells(xlsrow,7)).Borders(4).LineStyle=1 ;
		
	
		xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} 
	catch(e) 
	{	alert(e.message);	}
}

document.body.onload = BodyLoadHandler;