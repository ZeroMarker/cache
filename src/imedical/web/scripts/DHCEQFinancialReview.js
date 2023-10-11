var SelectedRow=0;
var rowid=0;
var readonly;
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
	FillData();
	FillEquipType();
	SetBussinessType();
	SetEnabled();
	initButtonWidth();
	initPanelHeaderStyle();
	initButtonColor();//cjc 2023-01-18 ���ü��������ť��ɫ
	initPanelHeaderStyle();//cjc 2023-01-17 ��ʼ�����������ʽ
	//add by cjc 20230208���������������
	document.getElementById("EquipType").classList.add("textbox");
	document.getElementById("EquipType").style.width='';
	
}

function InitPage()
{
	KeyUp("UseLoc^FundsType","N");
	Muilt_LookUp("UseLoc^FundsType");
	var obj=document.getElementById("BCreate");
	if (obj) obj.onclick=BCreate_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("EquipType");
	if (obj) obj.onchange=EquipType_Change;
	var obj=document.getElementById("BussinessType");
	if (obj) obj.onchange=BussinessType_Change;
	var obj=document.getElementById("Month");
	if (obj) obj.onchange=Month_Change;
	var obj=document.getElementById("BPDFCreate");
	if (obj) obj.onclick=BPDFCreate_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
	
}
function BCreate_Clicked()
{
	//����Ƿ��������
	var FRRowID=GetElementValue("FRRowID");
	var BussinessTypeDR=GetElementValue("BussinessType");
	if (BussinessTypeDR=="")
	{
		messageShow("","","","��ѡ��ҵ������!");
		return
	}
	var EquipTypeIDs=GetElementValue("EquipTypeIDs");
	if (EquipTypeIDs=="")
	{
		messageShow("","","","��ѡ������!");
		return
	}
	var BussinessSDate=GetElementValue("BussinessSDate");
	var BussinessEDate=GetElementValue("BussinessEDate");
	var Month=GetElementValue("Month");
	if ((BussinessTypeDR=="ZJ")&&(Month==""))
	{
		messageShow("","","","�������·�!");
		return
	}
	var Remark=GetElementValue("Remark");
	var val=BussinessTypeDR+"^"+Month+"^"+EquipTypeIDs+"^"+BussinessSDate+"^"+BussinessEDate+"^"+curUserID+"^"+FRRowID+"^"+curLocID+"^"+Remark;
  	var encmeth=GetElementValue("CheckCreateFlag");
  	if (encmeth=="") return;
	var RtnInfo=cspRunServerMethod(encmeth,val);
	var Rtn=RtnInfo.split("^");
	if (Rtn[0]!="")
	{
		alertShow(Rtn[1]);
		return
	}
	//��ʼ����ҵ������
  	var encmeth=GetElementValue("CreateData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,val,"3","");
	if (Rtn>0)
	{
		messageShow("","","","�ɹ���������");
		var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQFinancialReview&FRRowID='+Rtn;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
		
		var parenturl="dhccpmrunqianreport.csp?reportName=DHCEQFinancialReviewSum.raq&vFRRowID="+Rtn;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			parenturl += "&MWToken="+websys_getMWToken()
		}
	  	parent.DHCEQFinancialReviewList.location.href=parenturl;
	}
	else
	{
		messageShow("","","","����ʧ��!+"+Rtn);
		return
	}
}
function BSubmit_Clicked()
{
	UpdateData(2);
}
function BAudit_Clicked()
{
	UpdateData(3);
}
function BCancelSubmit_Clicked()
{
	UpdateData(4);
}
function BDelete_Clicked()
{
	var CancelReason=GetElementValue("CancelReason");
	if (CancelReason=="")
	{
		messageShow("","","","����������ԭ��");
		return
	}
	UpdateData(1);
}
function UpdateData(isDel)
{
	var FRRowID=GetElementValue("FRRowID");
	if (FRRowID=="")
	{
		messageShow("","","","���ݲ�����!");
		return
	}
  	var encmeth=GetElementValue("Update");
  	if (encmeth=="") return;
  	var val=FRRowID+"^"+curUserID+"^"+GetElementValue("CancelReason");
  	var Rtn=cspRunServerMethod(encmeth,val,isDel);
  	if (Rtn>0)
  	{
	  	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQFinancialReview&FRRowID='+Rtn;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
		
		var parenturl="dhccpmrunqianreport.csp?reportName=DHCEQFinancialReviewSum.raq&vFRRowID="+Rtn;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			parenturl += "&MWToken="+websys_getMWToken()
		}		
	  	parent.DHCEQFinancialReviewList.location.href=parenturl
  	}
  	else
  	{
	  	messageShow("","","","����ʧ��!");
	  	return
  	}
}
function FillEquipType()
{
	var equiptypeinfos=GetElementValue("EquipTypeInfos");
	var obj=document.getElementById("EquipType");
	var equiptypelist=equiptypeinfos.split("&");
	var typeids=GetElementValue("EquipTypeIDs");
	if (typeids!="") typeids=","+typeids+",";
	for (var i=0;i<equiptypelist.length;i++)
	{
		var list=equiptypelist[i].split("^");
		obj.options.add(new Option(list[1],list[13],true,true));
		if (typeids.indexOf(","+list[13]+",")>-1)
		{	obj.options[i].selected=true;
		}
		else
		{	obj.options[i].selected=false;	}
	}	
}

function EquipType_Change()
{
	var typeids=GetSelectedEquipType(1);
	SetElement("EquipTypeIDs",typeids);
}

function GetSelectedEquipType(type)
{
	var typeids="";
	var obj=document.getElementById("EquipType");
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (typeids!="") typeids=typeids+",";
		if (type==1)
		{	typeids=typeids+obj.options[i].value;}
		else
		{	typeids=typeids+obj.options[i].text;}
	}
	return typeids;
}
function BussinessType_Change()
{
	var BussinessType=GetElementValue("BussinessType");
	SetElement("BussinessTypeDR",BussinessType);
}
function SetBussinessType()
{
	SetElement("BussinessType",GetElementValue("BussinessTypeDR"));
}
function Month_Change()
{
	var Month=GetElementValue("Month")
	var YearMonth=Month.substring(0,4)+"-"+Month.substring(4,6);
	var encmeth=GetElementValue("IsMonth");
	var IsMonth=cspRunServerMethod(encmeth,YearMonth);
	if ((Month.length!=6)||(IsMonth=="1"))
	{
		messageShow("","","","��ȷ�����·ݸ�ʽ(YYYYMM)");
		SetElement("BussinessSDate","");
		SetElement("BussinessEDate","");
		return
	}
  	var encmeth=GetElementValue("GetMonthDate");
  	if (encmeth=="") return;
  	var Rtn=cspRunServerMethod(encmeth,YearMonth,1);
  	SetElement("BussinessSDate",Rtn)
  	var Rtn=cspRunServerMethod(encmeth,YearMonth,2);
  	SetElement("BussinessEDate",Rtn)
}
function FillData()
{
	var FRRowID=GetElementValue("FRRowID");
	if (FRRowID=="") return
  	var encmeth=GetElementValue("GetOneFinancialReview");
  	if (encmeth=="") return;
  	var ReturnList=cspRunServerMethod(encmeth,FRRowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	SetElement("FRRowID",list[0]);
	SetElement("BussinessTypeDR",list[1]);
	SetElement("BussinessNo",list[2]);
	SetElement("EquipTypeIDs",list[3]);
	SetElement("PDFName",list[4]);
	SetElement("BussinessSDate",list[5]);
	SetElement("BussinessEDate",list[6]);
	SetChkElement("AutoCreateFlag",list[7]);
	SetElement("CancelReason",list[20]);
	SetElement("Status",list[21]);
	SetElement("Remark",list[23]);
	SetChkElement("AccountFlag",list[24]);
	SetElement("AccountDate",list[25]);
	SetElement("Month",list[28]);
}
function SetEnabled()
{
	var FRRowID=GetElementValue("FRRowID");
	var Status=GetElementValue("Status");
	var AccountFlag=GetChkElementValue("AccountFlag");
	
	if (FRRowID=="")
	{
		DisableElement("CancelReason",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BPDFCreate",true);
		DisableBElement("BPrint",true);
	}
	if (Status=="0")
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BPDFCreate",true);
		DisableBElement("BPrint",true);
	}
	if (Status=="1")
	{
		DisableBElement("BCreate",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BPDFCreate",true);
		DisableBElement("BPrint",true);
	}
	if (Status=="2")
	{
		DisableBElement("BCreate",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if ((Status=="3")||(AccountFlag=="Y"))
	{
		DisableElement("CancelReason",true);
		DisableBElement("BCreate",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BDelete",true);
	}
}
function BPDFCreate_Clicked()
{
    var FRRowID=GetElementValue("FRRowID");
    if (FRRowID=="")
    {
	    alertShow("�޵�����Ҫ����PDF!")
	    return
    }
    var FundsTypeDR=GetElementValue("FundsTypeDR");
    var FundsType=GetElementValue("FundsType");
    if (FundsTypeDR=="")
    {
	    FundsType="ȫ���ʽ���Դ"
		var truthBeTold = window.confirm("�Ƿ�����["+FundsType+"]��PDF?");
	    if (!truthBeTold) return;
    }
    //����Ƿ��Ѿ�����
    var encmeth=GetElementValue("CheckPDFFile");
    if (encmeth=="") return;
    var InputStr=FRRowID+"^"+FundsTypeDR;
    var myrtn=cspRunServerMethod(encmeth,InputStr);
    if (myrtn!="")
    {
	    alertShow("PDF�ļ������ɹ�!")
	    return
    }
    //��ʼ����
    var InputStr=FRRowID+"^"+curUserName+"^"+FundsTypeDR
  	var encmeth=GetElementValue("GetPDFQueueID");
  	if (encmeth=="") return;
  	var myrtn=cspRunServerMethod(encmeth,InputStr);
    if (myrtn=="")
    {
	    alertShow("����PDFʧ��")
	}
    else
    {
	    //�Ǽ�������PDF�ļ�
	    var encmeth=GetElementValue("SetPDFRecord");
	    if (encmeth=="") return;
	    var InputStr=FRRowID+"^"+FundsTypeDR;
	    var myrtn=cspRunServerMethod(encmeth,InputStr);
	    if (myrtn=="")
	    {
		    alertShow("�Ǽ�PDFʧ��")
	    }
	    else
	    {
		    alertShow("����PDF�ɹ�")
	    }
    }
}
function BPrint_Clicked()
{
	var vFRRowID=GetElementValue("FRRowID");
	var vUserName=curUserName;
	var vFundsType=GetElementValue("FundsTypeDR");
	var FundsType=GetElementValue("FundsType");
    if (vFundsType=="")
    {
	    FundsType="ȫ���ʽ���Դ"
		var truthBeTold = window.confirm("�Ƿ��ӡ["+FundsType+"]?");
	    if (!truthBeTold) return;
    }
	PDFPrint_Clicked(vFRRowID,vUserName,vFundsType)
}
function PDFPrint_Clicked(vFRRowID,vUserName,vFundsType)
{
	if (vFRRowID=="") return;
	/*****************�ܵ���Ϣ********************/
	var encmetha=GetElementValue("GetSumInfo");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,vFRRowID,vFundsType);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var Job=lista[1];
	var TBussinessNo=lista[2];
	var TEquipTypes=lista[4];
	var TBussinessSDate=lista[5];
	var TBussinessEDate=lista[6];
	var TMonth=lista[3];
	rows=lista[0];
	if (rows<=1) return
	/********************��ϸ��Ϣ******************/
	var PageRows=rows;
	var Pages=parseInt(rows / PageRows);
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
    var xlApp,xlsheet,xlBook;
    var Template=TemplatePath+"DHCEQFRDepreSum.xls";
    xlApp = new ActiveXObject("Excel.Application");
	var encmeth=GetElementValue("GetSumListInfo");
	if (encmeth=="") return;
	var GetRowsPerTime=100	//ÿ���50��ճ��һ��
	var strArr=new Array();
	var strLine="";
	var strConcat="";
	var CurRowCount=0
	for (var i=0;i<=Pages;i++)
    {
    	xlBook = xlApp.Workbooks.Add(Template);
    	xlsheet = xlBook.ActiveSheet;
    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
    	xlsheet.cells(2,1)="����:"+TBussinessNo;
    	xlsheet.cells(2,4)=TMonth;
    	var OnePageRow=PageRows;
   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
   		for (var j=1;j<=OnePageRow;j++)
		{
			var	PrintList=cspRunServerMethod(encmeth,Job,i*PageRows+j);
			PrintList=PrintList.replace(/\\n/g,"\n");
			PrintList=PrintList.replace(/\t/g," ");
			PrintList=PrintList.replace(/\r\n/g," ");	
			var List=PrintList.split("^");
			var Row=4+j;
			PrintList=List[0]+"\t"+List[1]+"\t"+List[2]+"\t"+List[3]+"\t"+List[4]+"\t"+List[5]+"\t"+List[6]+"\t"+List[7]+"\t"
			if (strLine=="")
			{
				strLine=PrintList;
			}
			else
			{
				strLine="\r"+PrintList;
			}
			strArr.push(strLine);
			CurRowCount=CurRowCount+1;
			if (CurRowCount==GetRowsPerTime)
			{
		     	strConcat=String.prototype.concat.apply("",strArr);
		     	xlsheet.Cells(i*PageRows+j-CurRowCount+4,1).Select();
			 	window.clipboardData.setData("Text",strConcat);
			 	xlsheet.Paste();
				strLine=""
				strConcat=""
				CurRowCount=0
				var strArr=new Array();
			}
			else if (rows==i*PageRows+j)
			{
		     	strConcat=String.prototype.concat.apply("",strArr);
		     	xlsheet.Cells(rows-CurRowCount+4,1).Select();
			 	window.clipboardData.setData("Text",strConcat);
			 	xlsheet.Paste();
				strLine=""
				strConcat=""
				CurRowCount=0
				var strArr=new Array();
			}
    	}
    	xlsheet.Range("A4",xlsheet.Cells(rows*1+3,8)).Borders.Weight = 2;
    	//var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    //var size=obj.GetPaperInfo("DHCEQInStock");
	    //if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    //xlBook.SaveAs(FileName);
    	xlsheet.printout; 	//��ӡ���
    	xlBook.Close (savechanges=false);
    	
    	xlsheet.Quit;
    	xlsheet=null;
    }
	xlApp=null;
}
/***********************************************************/
///����:��ϸ��¼��ӡ
function BPrint2_Clicked(vFRRowID,vUserName)
{
	if (vFRRowID=="") return;
	/*****************�ܵ���Ϣ********************/
	var encmetha=GetElementValue("CreatePrintInfo");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,vFRRowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var Job=lista[1];
	var FundsTypeStr=lista[2];
	var TBussinessType=lista[3];
	var TBussinessNo=lista[4];
	var TEquipTypes=lista[5];
	var TPDFName=lista[6];
	var TBussinessSDate=lista[7];
	var TBussinessEDate=lista[8];
	var TRemark=lista[9];
	var TMonth=lista[10];
	var FundsTypeInfo=FundsTypeStr.split("@")
	rows=lista[0];
	/********************��ϸ��Ϣ******************/
	var PageRows=rows;
	var Pages=parseInt(rows / PageRows);
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
    var xlApp,xlsheet,xlBook;
    var Template=TemplatePath+"DHCEQFRDepre.xls";
    xlApp = new ActiveXObject("Excel.Application");
	var encmeth=GetElementValue("GetPrintList");
	if (encmeth=="") return;
	var CurSourceID=0
	var CurLocDR=0
	var PreColCount=4		//��ʾ�ʽ���Դ����ǰ����
	var SufColCount=3		//��ʾ�ʽ���Դ���ݺ�����
	var GetRowsPerTime=100	//ÿ���50��ճ��һ��
	var SumNum=0
	var SumAmount=0
	var SumFundsType=new Array();
	var strArr=new Array();
	var strLine="";
	var strConcat="";
	var CurRowCount=0
	for (var i=0;i<=Pages;i++)
    {
    	xlBook = xlApp.Workbooks.Add(Template);
    	xlsheet = xlBook.ActiveSheet;
    	xlsheet.Range("A1",xlsheet.Cells(1, PreColCount+FundsTypeInfo.length-1+SufColCount)).MergeCells = true;
    	//xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
    	xlsheet.cells(1,1)="����ҽ��"+TMonth.substr(0,4)+"��"+TMonth.substr(4,6)+"���۾���ϸ"; //����
    	xlsheet.cells(1,1).HorizontalAlignment = 3;
    	xlsheet.cells(2,1)="����:"+TBussinessNo;
    	xlsheet.cells(2,4)="����:"+TBussinessSDate+"--"+TBussinessEDate;
    	xlsheet.Range("A3",xlsheet.Cells(3, PreColCount+FundsTypeInfo.length-1+SufColCount)).MergeCells = true;
    	xlsheet.cells(3,1)="����:"+TEquipTypes;
    	xlsheet.Range(xlsheet.Cells(4, PreColCount+1),xlsheet.Cells(4,PreColCount+FundsTypeInfo.length-1)).MergeCells = true;
    	xlsheet.cells(4, PreColCount+1)="����";
    	xlsheet.Range(xlsheet.Cells(4, PreColCount+FundsTypeInfo.length),xlsheet.Cells(5,PreColCount+FundsTypeInfo.length)).MergeCells = true;
    	xlsheet.Range(xlsheet.Cells(4, PreColCount+FundsTypeInfo.length+1),xlsheet.Cells(5,PreColCount+FundsTypeInfo.length+1)).MergeCells = true;
    	xlsheet.Range(xlsheet.Cells(4, PreColCount+FundsTypeInfo.length+2),xlsheet.Cells(5,PreColCount+FundsTypeInfo.length+2)).MergeCells = true;
    	xlsheet.cells(4, PreColCount+FundsTypeInfo.length)="��ע";
    	xlsheet.cells(4, PreColCount+FundsTypeInfo.length+1)="�豸����";
    	xlsheet.cells(4, PreColCount+FundsTypeInfo.length+2)="����";
    	xlsheet.Range("A4",xlsheet.Cells(5,PreColCount+FundsTypeInfo.length-1+SufColCount)).HorizontalAlignment = 3;
    	var FundsTypeDR=new Array();
    	for (var k=1;k<FundsTypeInfo.length;k++)
    	{
	    	var CurFundsType=FundsTypeInfo[k-1];
	    	var FundsType=CurFundsType.split("=");
	    	FundsTypeDR[k]=FundsType[0];
	    	SumFundsType[k]=0;
	    	var FundsTypeDesc=FundsType[1];
	    	xlsheet.cells(5, PreColCount+k)=FundsTypeDesc;
    	}
    	var OnePageRow=PageRows;
   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
   		for (var j=1;j<=OnePageRow;j++)
		{
			var	PrintList=cspRunServerMethod(encmeth,Job,vFRRowID,CurSourceID,CurLocDR);
			//PrintList=PrintList.replace(/\\n/g,"\n");
			var List=PrintList.split("^");
			CurSourceID=List[0];
			CurLocDR=List[1];
			var Row=5+j;
			//PrintList=PrintList.replace(/\t/g," ");
			//PrintList=PrintList.replace(/\r\n/g," ");	
			PrintList=List[2]+"\t"+List[3]+"\t"+List[4]+"\t"+List[5]+"\t"
			SumNum=SumNum+List[3]*1;
			SumAmount=SumAmount+List[5]*1;
			var ListFTInfo=List[11].split("@");
			for (var k=1;k<FundsTypeInfo.length;k++)
			{
				for (var m=1;m<=ListFTInfo.length;m++)
				{
					var ListFundsType=ListFTInfo[m-1].split("=");
					if (FundsTypeDR[k]==ListFundsType[0])
					{
						SumFundsType[k]=SumFundsType[k]+ListFundsType[1]*1;
						PrintList=PrintList+ListFundsType[1];
					}
				}
				PrintList=PrintList+"\t";
			}
			PrintList=PrintList+(i*PageRows+j)+"\t"+List[7]+"\t"+List[9];
			if (strLine=="")
			{
				strLine=PrintList;
			}
			else
			{
				strLine="\r"+PrintList;
			}
			strArr.push(strLine);
			CurRowCount=CurRowCount+1;
			if (CurRowCount==GetRowsPerTime)
			{
		     	strConcat=String.prototype.concat.apply("",strArr);
		     	xlsheet.Cells(i*PageRows+j-CurRowCount+6,1).Select();
			 	window.clipboardData.setData("Text",strConcat);
			 	xlsheet.Paste();
				strLine=""
				strConcat=""
				CurRowCount=0
				var strArr=new Array();
			}
			else if (rows==i*PageRows+j)
			{
		     	strConcat=String.prototype.concat.apply("",strArr);
		     	xlsheet.Cells(rows-CurRowCount+6,1).Select();
			 	window.clipboardData.setData("Text",strConcat);
			 	xlsheet.Paste();
				strLine=""
				strConcat=""
				CurRowCount=0
				var strArr=new Array();
				xlsheet.cells(Row+1,1)="�ϼ�:"
				xlsheet.cells(Row+1,2)=SumNum;
				xlsheet.cells(Row+1,4)=SumAmount;
				for (var k=1;k<FundsTypeInfo.length;k++)
				{
					xlsheet.cells(Row+1,PreColCount+k)=SumFundsType[k];
				}
			}
    	}
    	xlsheet.Range("B6",xlsheet.Cells(rows*1+6,PreColCount+FundsTypeInfo.length-1)).HorizontalAlignment = 4;
    	xlsheet.Range("A6",xlsheet.Cells(rows*1+6,PreColCount+FundsTypeInfo.length-1+SufColCount)).VerticalAlignment = 1;
    	xlsheet.Rows(6+":"+(rows*1+6)).RowHeight = 21.75;
		xlsheet.Range("A4",xlsheet.Cells(rows*1+6,PreColCount+FundsTypeInfo.length-1+SufColCount)).Borders.Weight = 1;
    	xlsheet.Range(xlsheet.Cells(rows*1+7, 1),xlsheet.Cells(rows*1+7, PreColCount+FundsTypeInfo.length-1+SufColCount)).MergeCells = true;
    	var CurDate=new Date();
    	xlsheet.cells(rows*1+7,1)="�Ƶ���:"+vUserName+"                            �Ƶ�����:"+CurDate.toLocaleString(); //�Ƶ���
    	//var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    //var size=obj.GetPaperInfo("DHCEQInStock");
	    //if (0!=size) xlsheet.PageSetup.PaperSize = size;
    	//xlsheet.printout; 	//��ӡ���
    	xlBook.Close (savechanges=false);
    	
    	xlsheet.Quit;
    	xlsheet=null;
    }
	xlApp=null;
}

/***********************************************************************/
function BPrintBAK_Clicked(vFRRowID,vUserName)
{
	if (vFRRowID=="") return;
	/*****************�ܵ���Ϣ********************/
	var encmetha=GetElementValue("CreatePrintInfo");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,vFRRowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var Job=lista[1];
	var FundsTypeStr=lista[2];
	var TBussinessType=lista[3];
	var TBussinessNo=lista[4];
	var TEquipTypes=lista[5];
	var TPDFName=lista[6];
	var TBussinessSDate=lista[7];
	var TBussinessEDate=lista[8];
	var TRemark=lista[9];
	var TMonth=lista[10];
	var FundsTypeInfo=FundsTypeStr.split("@")
	rows=lista[0];
	/********************��ϸ��Ϣ******************/
	var PageRows=rows;
	var Pages=parseInt(rows / PageRows);
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
    var xlApp,xlsheet,xlBook;
    var Template=TemplatePath+"DHCEQFRDepre.xls";
    xlApp = new ActiveXObject("Excel.Application");
	var encmeth=GetElementValue("GetPrintList");
	if (encmeth=="") return;
	var CurSourceID=0
	var CurLocDR=0
	var PreColCount=4		//��ʾ�ʽ���Դ����ǰ����
	var SufColCount=3		//��ʾ�ʽ���Դ���ݺ�����
	var SumNum=0
	var SumAmount=0
	var SumFundsType=new Array();
	for (var i=0;i<=Pages;i++)
    {
    	xlBook = xlApp.Workbooks.Add(Template);
    	xlsheet = xlBook.ActiveSheet;
    	xlsheet.Range("A1",xlsheet.Cells(1, PreColCount+FundsTypeInfo.length-1+SufColCount)).MergeCells = true;
    	//xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
    	xlsheet.cells(1,1)="����ҽ��"+TMonth.substr(0,4)+"��"+TMonth.substr(4,6)+"���۾���ϸ"; //����
    	xlsheet.cells(1,1).HorizontalAlignment = 3;
    	xlsheet.cells(2,1)="����:"+TBussinessNo;
    	xlsheet.cells(2,4)="����:"+TBussinessSDate+"--"+TBussinessEDate;
    	xlsheet.Range("A3",xlsheet.Cells(3, PreColCount+FundsTypeInfo.length-1+SufColCount)).MergeCells = true;
    	xlsheet.cells(3,1)="����:"+TEquipTypes;
    	xlsheet.Range(xlsheet.Cells(4, PreColCount+1),xlsheet.Cells(4,PreColCount+FundsTypeInfo.length-1)).MergeCells = true;
    	xlsheet.cells(4, PreColCount+1)="����";
    	xlsheet.Range(xlsheet.Cells(4, PreColCount+FundsTypeInfo.length),xlsheet.Cells(5,PreColCount+FundsTypeInfo.length)).MergeCells = true;
    	xlsheet.Range(xlsheet.Cells(4, PreColCount+FundsTypeInfo.length+1),xlsheet.Cells(5,PreColCount+FundsTypeInfo.length+1)).MergeCells = true;
    	xlsheet.Range(xlsheet.Cells(4, PreColCount+FundsTypeInfo.length+2),xlsheet.Cells(5,PreColCount+FundsTypeInfo.length+2)).MergeCells = true;
    	xlsheet.cells(4, PreColCount+FundsTypeInfo.length)="��ע";
    	xlsheet.cells(4, PreColCount+FundsTypeInfo.length+1)="�豸����";
    	xlsheet.cells(4, PreColCount+FundsTypeInfo.length+2)="����";
    	xlsheet.Range("A4",xlsheet.Cells(5,PreColCount+FundsTypeInfo.length-1+SufColCount)).HorizontalAlignment = 3;
    	var FundsTypeDR=new Array();
    	for (var k=1;k<FundsTypeInfo.length;k++)
    	{
	    	var CurFundsType=FundsTypeInfo[k-1];
	    	var FundsType=CurFundsType.split("=");
	    	FundsTypeDR[k]=FundsType[0];
	    	SumFundsType[k]=0;
	    	var FundsTypeDesc=FundsType[1];
	    	xlsheet.cells(5, PreColCount+k)=FundsTypeDesc;
    	}
    	var OnePageRow=PageRows;
   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
   		for (var j=1;j<=OnePageRow;j++)
		{
			var	PrintList=cspRunServerMethod(encmeth,Job,vFRRowID,CurSourceID,CurLocDR);
			PrintList=PrintList.replace(/\\n/g,"\n");
			var List=PrintList.split("^");
			CurSourceID=List[0];
			CurLocDR=List[1];
			var Row=5+j;
			xlsheet.cells(Row,1)=List[2];//�豸����
			xlsheet.cells(Row,2)=List[3];//����
			xlsheet.cells(Row,3)=List[4];//����
			xlsheet.cells(Row,4)=List[5];//���
			SumNum=SumNum+List[3]*1;
			SumAmount=SumAmount+List[5]*1;
			var ListFTInfo=List[11].split("@");
			for (var k=1;k<FundsTypeInfo.length;k++)
			{
				for (var m=1;m<=ListFTInfo.length;m++)
				{
					var ListFundsType=ListFTInfo[m-1].split("=");
					if (FundsTypeDR[k]==ListFundsType[0])
					{
						xlsheet.cells(Row,PreColCount+k)=ListFundsType[1];//�ʽ���Դ���
						SumFundsType[k]=SumFundsType[k]+ListFundsType[1]*1;
					}
				}
			}
			xlsheet.cells(Row,PreColCount+FundsTypeInfo.length)=List[6];//��ע
			xlsheet.cells(Row,PreColCount+FundsTypeInfo.length+1)=List[7];//�豸����			
			xlsheet.cells(Row,PreColCount+FundsTypeInfo.length+2)=List[9];//����
			//xlsheet.cells(Row,PreColCount+FundsTypeInfo.length+3)=List[8];//�豸����
			//xlsheet.cells(Row,PreColCount+FundsTypeInfo.length+4)=List[10];//��Դ
			if (rows==i*PageRows+j)
			{
				xlsheet.cells(Row+1,1)="�ϼ�:"
				xlsheet.cells(Row+1,2)=SumNum;
				xlsheet.cells(Row+1,4)=SumAmount;
				for (var k=1;k<FundsTypeInfo.length;k++)
				{
					xlsheet.cells(Row+1,PreColCount+k)=SumFundsType[k];
				}
			}
    	}
    	xlsheet.Range("B6",xlsheet.Cells(rows*1+6,PreColCount+FundsTypeInfo.length-1)).HorizontalAlignment = 4;
    	xlsheet.Range("A6",xlsheet.Cells(rows*1+6,PreColCount+FundsTypeInfo.length-1+SufColCount)).VerticalAlignment = 1;
    	xlsheet.Rows(6+":"+(rows*1+6)).RowHeight = 21.75;
		xlsheet.Range("A4",xlsheet.Cells(rows*1+6,PreColCount+FundsTypeInfo.length-1+SufColCount)).Borders.Weight = 1;
    	xlsheet.Range(xlsheet.Cells(rows*1+7, 1),xlsheet.Cells(rows*1+7, PreColCount+FundsTypeInfo.length-1+SufColCount)).MergeCells = true;
    	var CurDate=new Date();
    	xlsheet.cells(rows*1+7,1)="�Ƶ���:"+vUserName+"                            �Ƶ�����:"+CurDate.toLocaleString(); //�Ƶ���
    	//var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    //var size=obj.GetPaperInfo("DHCEQInStock");
	    //if (0!=size) xlsheet.PageSetup.PaperSize = size;
    	xlsheet.printout; 	//��ӡ���
    	xlBook.Close (savechanges=false);
    	
    	xlsheet.Quit;
    	xlsheet=null;
    }
	xlApp=null;
}

function GetFundsType(para)
{
	var Info=para.split("^");
	SetElement("FundsTypeDR",Info[1]);
}
function GetUseLocID(para)
{
	var Info=para.split("^");
	SetElement("UseLocDR",Info[1]);
}
function BFind_Clicked()
{
	var lnk="";
	lnk=lnk+"&vFRRowID="+GetElementValue("FRRowID");
	lnk=lnk+"&vFundsTypeDR="+GetElementValue("FundsTypeDR");
	lnk=lnk+"&vUseLocDR="+GetElementValue("UseLocDR");
	parent.DHCEQFinancialReviewList.location.href="dhccpmrunqianreport.csp?reportName=DHCEQFinancialReviewSum.raq"+lnk;
}
/***********************************************************************/
document.body.onload = BodyLoadHandler;
