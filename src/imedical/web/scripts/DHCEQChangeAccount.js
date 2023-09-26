/// Modified By HZY 2012-02-06 HZY0022
/// Desc:��������:1.SetLink��lnk_Click :����'�ʽ���Դ'�������.
/// 	 �޸ĺ���:1.SaveData:���˽��Ϊ0ʱ,Ϊ����'�ʽ���Դ' 
/// ---------------------------------------------------
/// Modify DJ 2010-03-15 
/// �޸������¼ΪDJ0041�δ���
/// ����:��������˼�¼��������ӡ������ⵥ���������ⵥ
///---------------------------------------------------
var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitPage();
	Clear();
	SetLink();
}

function InitPage()
{
	InitUserInfo();
	InitStandardKeyUp();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAudit",true);
		DisableBElement("BAffix",true);
		DisableBElement("BAffixISPrint",true);
		DisableBElement("BAffixSMPrint",true);
		DisableBElement("BPrintCA",true);
	}
	InitButton(false);
	var obj=document.getElementById("ChangeFee");
	if (obj) obj.onchange=ChangeFee_Changed;
	var obj=document.getElementById("ChangeDepreTotalFee");
	if (obj) obj.onchange=ChangeDepreTotalFee_Changed;
}

function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQChangeAccount');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TFundsz'+i);
		if (SelRowObj)
		{
			SelRowObj.onclick=lnk_Click;//����
			SelRowObj.href="#";
		}
	}	
}

function lnk_Click()
{
	var eSrc=window.event.srcElement;	//��ȡ�¼�Դͷ
	var row=GetRowByColName(eSrc.id);	//����
    var lnk=GetHref(row);				//����
    window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}

function GetHref(row)
{
	var selectrow=GetTableCurRow();	//�õ����ǰ�к�
	var TRowID=GetElementValue('TRowIDz'+selectrow);
	var FundsAmount=GetElementValue('TChangeFeez'+selectrow);
	var DepreTotal=GetElementValue('TChangeDepreTotalFeez'+selectrow);
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',TRowID);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	var sort=27
	var TStatus=list[10];
	var TLinkAffixFlag=list[43];
	var ReadOnly=0;	//����ʱ,�ʽ���Դ �ɱ༭
	//������ʱ,�ʽ���Դ ���ɱ༭
	//�����Ӹ�����,�ʽ���ԴҲ���ɱ༭
	if ((TLinkAffixFlag==1)||(TStatus!="0"))
	{
		ReadOnly=1;
	}
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAFunds&FromType=7&FromID='+TRowID+'&ReadOnly='+ReadOnly+'&FundsAmount='+FundsAmount+'&DepreTotal='+DepreTotal;	//Mozy0148
	return lnk;
}

function ChangeFee_Changed()
{
	var equipid=GetElementValue("EquipDR");
	if (equipid=="") return;	
	var ChangeFee=GetElementValue("ChangeFee");
	if (ChangeFee=="") return;
	if (isNaN(ChangeFee)) return;

	var OriginalFee=GetElementValue("OriginalFee");
	if (OriginalFee=="") return;
	var obj=document.getElementById("ChangedOriginalFee");
	if (obj) obj.value=(parseFloat(OriginalFee)+parseFloat(ChangeFee)).toFixed(2);
	
	var NetFee=GetElementValue("NetFee")
	if (NetFee=="") return;
	var obj=document.getElementById("ChangedNetFee");
	if (obj)
	{
		var tmpValue=parseFloat(NetFee)+parseFloat(ChangeFee);
		if (tmpValue<0) tmpValue=0;
		obj.value=tmpValue.toFixed(2);
	}
	var obj=document.getElementById("TotalDepreFee");
	if (obj)
	{
		var tmpValue=parseFloat(OriginalFee)-parseFloat(NetFee);
		if (tmpValue<0) tmpValue=0;
		obj.value=tmpValue.toFixed(2);
	}
}

function InitButton(isselected)
{
	if (1==GetElementValue("ReadOnly")) return;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	var obj=document.getElementById("BAffix"); //2010-03-15 ���� begin DJ0041
	if (obj) obj.onclick=BAffix_Click;
	var obj=document.getElementById("BAffixISPrint");
	if (obj) obj.onclick=BAffixISPrint_Click;
	var obj=document.getElementById("BAffixSMPrint");
	if (obj) obj.onclick=BAffixSMPrint_Click; //2010-03-15 ���� end DJ0041
	var obj=document.getElementById("BPrintCA");
	if (obj) obj.onclick=BPrintCA_Click;
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	DisableBElement("BAudit",!isselected);
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	DisableBElement("BAffixISPrint",!isselected);  //2010-03-15 ���� begin DJ0041
	DisableBElement("BAffixSMPrint",!isselected);  //2010-03-15 ���� end DJ0041
	DisableBElement("BPrintCA",!isselected);
}
function BAffix_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCAAffix&EquipDR='+GetElementValue("EquipDR")+'&ChangeAccountDR='+GetElementValue("RowID")+'&AddChange='+GetChkElementValue("AddChange")+'&CAAffixIDS='+GetElementValue("CAAffixIDS")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BAffixISPrint_Click()
{
	var CARowID=GetElementValue("RowID")
	if (CARowID=="") return;
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,CARowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,GetElementValue("EquipDR"),CARowID);
	var list=gbldata.split("_");
	var Listall=list[0];
	rows=list[1];
	var PageRows=6;
	var Pages=parseInt(rows / PageRows); //��ҳ��?1  3Ϊÿҳ�̶�����
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try 
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQCAAffixInStock.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//ҽԺ�����滻 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,1)="��  ��  ��:"+CARowID;
	    	xlsheet.cells(2,5)=ChangeDateFormat(lista[2]);	//Mozy0073	2011-12-08
	    	xlsheet.cells(3,1)="���豸���:"+lista[0];
	    	xlsheet.cells(3,5)=lista[1];
	    	xlsheet.cells(11,2)=lista[3];
	    	xlsheet.cells(11,6)=lista[4];
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Lists=Listall.split(":");
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				xlsheet.cells(Row,1)=List[0];//����
				xlsheet.cells(Row,2)=List[1];//���
				xlsheet.cells(Row,3)=List[2];//����
				xlsheet.cells(Row,4)=List[3];//����
				xlsheet.cells(Row,5)=List[4];//���
				xlsheet.cells(Row,6)=List[5];//��ע
	    	}
	    	xlsheet.cells(12,6)="ҳ��:"+(i+1)+"/"+(Pages+1);
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQInStock");
		    if (0!=size)
		    {
			    xlsheet.PageSetup.PaperSize = size;
		    }
		    else
		    {
			    alertShow("No Find PaperSet DHCEQInStock");
			    return
		    }
			//var savepath=GetFileName();
			//xlBook.SaveAs(savepath);
			xlBook.printout();
	    	xlBook.Close (savechanges=false);
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function BAffixSMPrint_Click()
{
	var CARowID=GetElementValue("RowID")
	if (CARowID=="") return;
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,CARowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,GetElementValue("EquipDR"),CARowID);
	var list=gbldata.split("_");
	var Listall=list[0];
	rows=list[1];
	var PageRows=6;
	var Pages=parseInt(rows / PageRows); //��ҳ��?1  3Ϊÿҳ�̶�����
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try 
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQCAAffixStoreMove.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//ҽԺ�����滻 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,1)="��  ��  ��:"+CARowID;
	    	xlsheet.cells(2,3)=ChangeDateFormat(lista[2]);	//Mozy0073	2011-12-08
	    	xlsheet.cells(2,6)=GetShortName(lista[5],"-");
	    	xlsheet.cells(3,1)="���豸���:"+lista[0];
	    	xlsheet.cells(3,5)=lista[1];
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Lists=Listall.split(":");
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				xlsheet.cells(Row,1)=List[0];//����
				xlsheet.cells(Row,2)=List[1];//���
				xlsheet.cells(Row,3)=List[2];//����
				xlsheet.cells(Row,4)=List[3];//����
				xlsheet.cells(Row,5)=List[4];//���
				xlsheet.cells(Row,6)=List[5];//��ע
	    	}
	    	xlsheet.cells(12,6)="ҳ��:"+(i+1)+"/"+(Pages+1);
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQInStock");
		    if (0!=size)
		    {
			    xlsheet.PageSetup.PaperSize = size;
		    }
		    else
		    {
			    alertShow("No Find PaperSet DHCEQInStock");
			    return
		    }
			//var savepath=GetFileName();
			//xlBook.SaveAs(savepath);
			xlBook.printout();
	    	xlBook.Close (savechanges=false);
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function Selected(selectrow)
{
	if (SelectedRow==selectrow)	{	
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
		}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		InitButton(true);
		SetData(rowid);	
	}
}

function BAudit_Click()
{
	AuditData();
}

function BAdd_Click() 
{
	SaveData();
}

function BUpdate_Click() 
{
	SaveData();
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t[-4002]);
		return;
	}
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser,'1');
	if (result<0)
	{	alertShow(t[result]);}
	else
	{	location.reload();	}
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeFee") ;
  	combindata=combindata+"^"+GetElementValue("ChangedOriginalFee") ;
  	combindata=combindata+"^"+GetElementValue("ChangedNetFee") ;
  	combindata=combindata+"^"+GetElementValue("TotalDepreFee") ;
  	combindata=combindata+"^"+GetElementValue("ChangeItem") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReasonDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReasonRemark") ;
  	combindata=combindata+"^"+GetElementValue("ChangeDate") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
  	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
  	combindata=combindata+"^"+GetElementValue("SubmitTime") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;
  	combindata=combindata+"^"+GetElementValue("OriginalFee") ;
  	combindata=combindata+"^"+GetElementValue("NetFee") ;
  	combindata=combindata+"^"+GetElementValue("NetRemainFee") ;
  	combindata=combindata+"^"+GetElementValue("ChangedNetRemainFee") ;
  	combindata=combindata+"^"+GetChkElementValue("AddChange") ; //2010-03-15 ���� DJ0041
  	combindata=combindata+"^"+GetElementValue("CAAffixIDS") ; //2010-03-15 ���� DJ0041
  	combindata=combindata+"^"+GetElementValue("ChangeDepreTotalFee");	//Mozy0148  //hold2
	//add by zy 20150610 ZY0128  //hold3 ���ӵ��۾��·���
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	return combindata;
}

function AuditData()
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") 
		{alertShow(t['04']);
		 retrun;	}
	//Function:Funds	2012-2-16 �����ʽ���Դ��Ϣ
	if (GetElementValue("GetSelfFundsID")=="") //2011-05-05 DJ
	{
		alertShow("�����ʽ����δ����!")
		return
	}
	///Modified by JDL 2012-1-17 JDL0112 �޸ĵ�����س��� ��ֵ����С��0,���Ե���0
	//���˺���С��0�˳�
	if (GetElementValue("ChangedOriginalFee")<0) //2011-05-11 DJ
	{
		alertShow("���˺�ԭֵС��0,����ȷ������˼�ֵ!")
		return
	}
	//�жϵ��˽���Ƿ�����������ܽ����� 2010-03-15 ���� DJ0041 Begin
	var encmeth=GetElementValue("CheckFee");
	var result=cspRunServerMethod(encmeth,rowid);
	if (result==1)
	{
		alertShow("���˽������������ܽ����,�������!");
	    return;
	}
	else if (result==2)
	{		
		var truthBeTold = window.confirm("���ε���δ��������,�Ƿ����?");
	    if (!truthBeTold) return;
	}
	else if (result==3)
	{
		alertShow("���˽��Ϊ0,���ܹ�������!");
	    return;
	}
	
	var encmeth=GetElementValue("GetAudit");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser,GetElementValue("ChangeTypeDR"));
	if (result<0)
	{	
		alertShow(t[result]);
	}
	else
	{
		if (GetElementValue("IsOpenFlag")=="1")
		{
			var ID=GetElementValue("EquipDR")
			var FundsAmount=GetElementValue("ChangedOriginalFee")
			var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQFunds&FromType=1&FromID='+ID+'&ReadOnly=1&FundsAmount='+FundsAmount
			window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
		}
		if (parent.opener.opener)
		{
			parent.opener.opener.location.reload();
		}
		else if (parent.opener)
		{
			parent.opener.location.reload();
		}
		location.reload();	
	}
}

function SaveData()
{
	if (CheckSaveData()) return;
	if (GetElementValue("GetSelfFundsID")=="")
	{
		alertShow("�����ʽ����δ����!")
		return
	}
	//Modified by JDL 2012-1-17 JDL0112 �޸ĵ�����س��� ��ֵ����С��0 ���Ե���0
	//���˺���С��0�˳�
	if (GetElementValue("ChangedOriginalFee")<0) //2011-05-11 DJ
	{
		alertShow("���˺�ԭֵС��0,����ȷ������˼�ֵ!")
		return
	}

	//Modified by JDL 2012-1-17 JDL0112 �޸ĵ�����س��� ��ֵ����С��0 ���Ե���0 ������˽��Ϊ0,���ڵ����ʽ���Դ
	//���˽��Ϊ0�˳�
	//if (GetElementValue("ChangeFee")==0) //2010-03-15 ���� DJ0041 begin
	//{
	//	alertShow("����ȷ������˼�ֵ!")
	//	return
	//}
	
	//�ж�����һ����
	var AddChangeDR=GetChkElementValue("AddChangeDR");
	var AddChange=GetChkElementValue("AddChange");
	var ChangeFee=GetElementValue("ChangeFee");
	var CAAffixIDS=GetElementValue("CAAffixIDS");
	if ((CAAffixIDS=="")&&(AddChange==false)&&(ChangeFee>0))
	{
		alertShow("��ֵ����ʱ���˽��ӦΪ����!")
		return
	}
	if ((CAAffixIDS=="")&&(AddChange==true)&&(ChangeFee<0))
	{
		alertShow("��ֵ����ʱ���˽��Ӧ����0!")
		return
	}
	if ((AddChangeDR!=AddChange)&&(CAAffixIDS!=""))
	{
		alertShow("���˱�ʶ����ѡ�񸽼���ʶ��ͬ!")
		return
	}
	if ((ChangeFee>0)&&(AddChangeDR==false)&&(CAAffixIDS!=""))
	{
		alertShow("��ֵ����ʱ���˽��ӦΪ����!")
		return
	}
	if ((ChangeFee<0)&&(AddChangeDR==true)&&(CAAffixIDS!=""))
	{
		alertShow("��ֵ����ʱ���˽��Ӧ����0!")
		return
	}
	//2010-03-15 ���� DJ0041 end
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,'','',plist,Guser,'0');
	if (result>0)
	{	location.reload();	}
	else
	{	alertShow(t[result]);}
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	var sort=36;
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("ChangeFee",list[1]);
	SetElement("ChangedOriginalFee",list[2]);
	SetElement("ChangedNetFee",list[3]);
	SetElement("TotalDepreFee",list[4]);
	SetElement("ChangeItem",list[5]);
	SetElement("ChangeReasonDR",list[6]);
	SetElement("ChangeReason",list[sort+1]);
	SetElement("ChangeReasonRemark",list[7]);
	SetElement("ChangeDate",list[8]);
	SetElement("Remark",list[9]);
	SetElement("Status",list[10]);
	SetElement("AddUserDR",list[11]);
	SetElement("AddUser",list[sort+2]);
	SetElement("AddDate",list[12]);
	SetElement("AddTime",list[13]);
	SetElement("UpdateUserDR",list[14]);
	SetElement("UpdateUser",list[sort+3]);
	SetElement("UpdateDate",list[15]);
	SetElement("UpdateTime",list[16]);
	SetElement("SubmitUserDR",list[17]);
	SetElement("SubmitUser",list[sort+4]);
	SetElement("SubmitDate",list[18]);
	SetElement("SubmitTime",list[19]);
	SetElement("AuditUserDR",list[20]);
	SetElement("AuditUser",list[sort+5]);
	SetElement("AuditDate",list[21]);
	SetElement("AuditTime",list[22]);
	SetElement("OriginalFee",list[23]);
	SetElement("NetFee",list[24]);
	SetElement("NetRemainFee",list[25]);
	SetElement("ChangedNetRemainFee",list[26]);
	SetElement("CAAffixIDS",""); //2010-03-15 ���� DJ0041
	if (list[1]>0) //2010-03-15 ���� DJ0041 begin
	{
		SetChkElement("AddChange",1);
		SetChkElement("AddChangeDR",1);
	}
	else
	{
		SetChkElement("AddChange",0);
		SetChkElement("AddChangeDR",0);
	} //2010-03-15 ���� DJ0041 end
	SetDisableButton(list[10],false);
	if (list[10]==0) //2010-03-15 ���� begin DJ0041
	{
		DisableBElement("BAffixISPrint",true);
		DisableBElement("BAffixSMPrint",true);
		DisableBElement("BPrintCA",true);
	}
	if (list[10]==2)
	{
		DisableBElement("BAffixISPrint",false);
		DisableBElement("BAffixSMPrint",false);  
		DisableBElement("BPrintCA",false);
	} //2010-03-15 ���� end DJ0041
	//add by zy 20150610 ZY0128  //hold3 ���ӵ��۾��·���
	SetElement("Hold1",list[31]);
	SetElement("ChangeDepreTotalFee",list[32]);	//Mozy0148
	SetElement("Hold3",list[33]);
	SetElement("Hold4",list[34]);
	SetElement("Hold5",list[35]);
}



function InitStandardKeyUp()
{
	KeyUp("Equip^ChangeReason^AddUser^UpdateUser^SubmitUser^AuditUser","N");
	Muilt_LookUp("Equip^ChangeReason^AddUser^UpdateUser^SubmitUser^AuditUser");
	return;
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ChangeReason");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AddUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("UpdateUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("SubmitUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AuditUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Equip","");
	//SetElement("EquipDR","");
	SetElement("ChangeFee","");
	SetElement("ChangedOriginalFee","");
	SetElement("ChangedNetFee","");
	SetElement("TotalDepreFee","");
	SetElement("ChangeItem","");
	SetElement("ChangeReason","");
	SetElement("ChangeReasonDR","");
	SetElement("ChangeReasonRemark","");
	//SetElement("ChangeDate","");
	SetElement("Remark","");
	SetElement("Status","");
	SetElement("AddUser","");
	SetElement("AddUserDR","");
	SetElement("AddDate","");
	SetElement("AddTime","");
	SetElement("UpdateUser","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("SubmitUser","");
	SetElement("SubmitUserDR","");
	SetElement("SubmitDate","");
	SetElement("SubmitTime","");
	SetElement("AuditUser","");
	SetElement("AuditUserDR","");
	SetElement("AuditDate","");
	SetElement("AuditTime","");
	SetElement("OriginalFee","");
	SetElement("NetFee","");
	SetElement("NetRemainFee","");
	SetElement("ChangedNetRemainFee","");
	SetChkElement("AddChange",1); //2010-03-15 ���� DJ0041
	SetChkElement("AddChangeDR",1); //2010-03-15 ���� DJ0041
	SetElement("CAAffixIDS",""); //2010-03-15 ���� DJ0041
	SetElement("ChangeDepreTotalFee","");	//Mozy0148
	//add by zy 20150610 ZY0128  //hold3 ���ӵ��۾��·���
	SetElement("Hold1","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetEquipInfo();
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQChangeAccount');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	Selected(selectrow);
}


function SetEquipInfo()
{
	var equipid=GetElementValue("EquipDR");
	if (equipid=="") return;
	var encmeth=GetElementValue("GetEquip");
	if (encmeth=="")	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',equipid);
	var list=gbldata.split("^");
	var sort=EquipGlobalLen;
	SetElement("OriginalFee",list[26]);
	SetElement("NetFee",list[27]);
	SetElement("NetRemainFee",list[28]);
	SetElement("DepreTotalFee",list[34]);
	SetElement("AppendFeeTotalFee",list[42]);	
}
function BPrintCA_Click()
{
	var CARowID=GetElementValue("RowID");
	if (CARowID=="") return;
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,CARowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,"","",CARowID);
	gbldata=gbldata.replace(/\\n/g,"\n");	///Modified by JDL 2012-3-21 JDL0125
	var list=gbldata.split("^");
	//alertShow(gbldata)
	var Listall=list[0];
	rows=list[1];
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var xlApp,xlsheet,xlBook;
	var Template=TemplatePath+"DHCEQChangeAccount.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	try 
	{
	    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
		xlsheet.cells(3,3)=CARowID;		//���˵���
	    xlsheet.cells(3,7)=ChangeDateFormat(lista[2]);	//�䶯����
	    
	    xlsheet.cells(4,3)=lista[0];	//�豸���
	    xlsheet.cells(4,5)=lista[1];	//�豸����
	    xlsheet.cells(4,7)=GetShortName(lista[5],"-");	//����
	    xlsheet.cells(5,3)=lista[8];	//�������
	    xlsheet.cells(5,5)=lista[6];	//����
	    xlsheet.cells(5,7)=lista[7];	//��λ
	    xlsheet.cells(6,3)=list[1];		//�������
	    xlsheet.cells(6,5)=lista[3];	//��ǰԭֵ
	    xlsheet.cells(6,7)=parseFloat(list[3])-parseFloat(list[1]);	//��ǰ��ֵ
	    
	    xlsheet.cells(7,5)=lista[4];	//����ԭֵ
	    xlsheet.cells(7,7)=list[3];		//����ֵ
	    xlsheet.cells(8,3)=list[7];		//����ԭ��
	    xlsheet.cells(9,3)=list[5];		//������Ŀ
	    xlsheet.cells(10,3)=list[9];	//��ע
	    
	    xlsheet.cells(11,3)=username;	//�Ƶ���
	    var encmeth=GetElementValue("GetCurDate");
		var curDate=cspRunServerMethod(encmeth);
	    xlsheet.cells(11,7)=ChangeDateFormat(curDate);	//��ӡ����
		
	   	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	   	var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size)
		{
			xlsheet.PageSetup.PaperSize = size;
		}
		//var savepath=GetFileName();
		//xlBook.SaveAs(savepath);
		xlBook.printout();
		//xlApp.Visible=true;
    	//xlsheet.PrintPreview();
	    xlBook.Close (savechanges=false);
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
//201702-04	Mozy
/// �Ϸ�ҽԺ���챨������ʽ�ĵ��˵�
function BPrintNew_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmetha=GetElementValue("fillData");
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,RowID);	//������Ϣ
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	//alertShow(ReturnList)
	
	var encmeth=GetElementValue("GetList");		//��ϸ������Ϣ
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,GetElementValue("EquipDR"),RowID);
	//alertShow(RowID+":"+gbldata);
	var list=gbldata.split(GetElementValue("SplitNumCode"));
	var Listall=list[0];
	rows=list[1];
	
	var PageRows=17;
	var ModRows=rows%PageRows;
	var Pages=parseInt(rows / PageRows);
	if (ModRows==0) {Pages=Pages-1;}
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQPayRequestList.xls";
	    if (curLocID=571) Template=TemplatePath+"DHCEQPayRequestListQCK.xls";	//�豸���ĿƲֿ�
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
		   	xlsheet = xlBook.ActiveSheet;
		    var sort=33;
	    	
		    //ҽԺ�����滻
		    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
		    //xlsheet.cells(3,1)=xlsheet.cells(3,1)+lista[sort+1];  //��Ӧ��
		    xlsheet.cells(3,4)=xlsheet.cells(3,4)+ChangeDateFormat(lista[2]);  //��������
		    xlsheet.cells(3,8)=RowID;    //�����
		    //xlsheet.cells(25,1)=xlsheet.cells(25,1)+GetShortName(lista[sort+0],"-");	//�Ʊ�λ
		    xlsheet.cells(25,4)=xlsheet.cells(25,4)+username;
		    xlsheet.cells(25,8)=ChangeDateFormat(GetCurrentDate());
		    xlsheet.cells(25,10)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
	    	
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		var Row=5;
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Lists=Listall.split(GetElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				//alertShow(Listl)
				// TAffix_"^"_TModel_"^"_TPrice_"^"_TNum_"^"_TAmount_"^"_TRemark_"^"_TUnit_"^"_Provider
				if (j==1) xlsheet.cells(3,1)=xlsheet.cells(3,1)+List[7];  //��Ӧ��
				xlsheet.cells(Row,1)=j;	//���
		    	xlsheet.cells(Row,2)=lista[5];//�豸����
		    	xlsheet.cells(Row,3)=List[0];//��������
				xlsheet.cells(Row,4)=List[1];//����
				xlsheet.cells(Row,5)=List[6];//��λ
				xlsheet.cells(Row,6)=List[3];//����
				xlsheet.cells(Row,7)=List[2];//ԭֵ
				xlsheet.cells(Row,8)=List[4];//������
				xlsheet.cells(Row,9)=lista[9];//������Դ
				xlsheet.cells(Row,10)=lista[10];//��ŵص�
				
				Row=Row+1;
			}
			xlsheet.cells(22,1)="�ϼ�(��д):"+list[3];
			xlsheet.cells(22,7)="��:"+list[2];
			xlApp.Visible=true;
		    xlsheet.PrintPreview();
			//xlsheet.printout; 	//��ӡ���
			//xlBook.SaveAs("D:\\InStock"+i+".xls");
			xlBook.Close (savechanges=false);
			xlsheet.Quit;
			xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(0,"ChangeDate")) return false;
	if (CheckItemNull(0,"ChangedOriginalFee")) return false;
	if (CheckItemNull(0,"ChangeFee")) return false;
	if (CheckItemNull(0,"ChangedNetFee")) return false;	
	*/
	return false;
}

function BClose_Click() 
{
	window.parent.close();
}
///Mozy0148
function ChangeDepreTotalFee_Changed()
{
	var equipid=GetElementValue("EquipDR");
	if (equipid=="") return;	
	var ChangeDepreTotalFee=GetElementValue("ChangeDepreTotalFee");
	if (ChangeDepreTotalFee=="") return;
	if (isNaN(ChangeDepreTotalFee)) return;
	var OriginalFee=GetElementValue("OriginalFee");
	if (OriginalFee=="") return;
	var NetFee=GetElementValue("NetFee");
	if (NetFee=="") return;
	//alertShow(ChangeDepreTotalFee)
	var obj=document.getElementById("TotalDepreFee");
	if (obj)
	{
		// �䶯ǰ�ۼ��۾�=�䶯ǰԭֵ-�䶯ǰ��ֵ
		// �䶯���ۼ��۾�=�䶯ǰ�ۼ��۾�+�䶯���ۼ��۾�
		var tmpValue=parseFloat(OriginalFee)-parseFloat(NetFee)+parseFloat(ChangeDepreTotalFee);
		if (tmpValue<0)
		{
			alertShow("�䶯���ۼ��۾�ֵ�쳣,����Ϊ0.");
			tmpValue=0;
		}
		obj.value=tmpValue.toFixed(2);
	}
	var ChangedOriginalFee=GetElementValue("ChangedOriginalFee");
	if (ChangedOriginalFee=="") return;
	var obj=document.getElementById("ChangedNetFee");
	if (obj)
	{
		// �䶯��ֵ=�䶯��ԭֵ-�䶯���ۼ��۾�
		var tmpValue=parseFloat(ChangedOriginalFee)-tmpValue.toFixed(2);
		if (tmpValue<0) tmpValue=0;
		obj.value=tmpValue.toFixed(2);
	}
}
document.body.onload = BodyLoadHandler;
