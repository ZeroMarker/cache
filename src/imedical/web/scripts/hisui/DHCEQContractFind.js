/// Modified By HZY 2011-10-19 HZY0018
/// �޸ĺ���: InitPage

function BodyLoadHandler()
{
	InitUserInfo();	
	InitPage();
	SetBEnable();		// �������:	716778	Mozy	2018-11-8
	//InitTblEvt();
	initButtonWidth();
	// Mozy0253	1214408		2020-3-4	����������
	if (GetElementValue("ContractType")==2)
	{
		HiddenTblColumn("tDHCEQContractFind","TContractName");
	}
	else
	{
		HiddenTblColumn("tDHCEQContractFind","TContractNameNew");
	}
}

function InitPage()
{
	KeyUp("SignLoc^Provider^Status");
	Muilt_LookUp("SignLoc^Provider^Status");

	var Type=GetElementValue("Type");
	if (Type=="0")
	{
		// ��������ͬ��
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("ReplacesAD");
		// Mozy0245		1187444	2020-1-21
		var obj=document.getElementById("BImport");
		if (obj) obj.onclick=BImport_Clicked;
	}
	else
	{
		// ������ͬ��
		DisableBElement("BAdd",true);
		DisableBElement("BAdd1",true);
		EQCommon_HiddenElement("BImport");		// Mozy0245		1187444	2020-1-21
	}
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
}
function CheckChange()
{
	var eSrc=window.event.srcElement;
	if (eSrc.checked)
	{
		if (eSrc.id=="WaitAD") SetChkElement("ReplacesAD","0");
		if (eSrc.id=="ReplacesAD") SetChkElement("WaitAD","0");
	} 
}

function GetSignLoc (value)
{
    GetLookUpID("SignLocDR",value);
}
function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}
/*function InitTblEvt()
{
	var objtbl=document.getElementById('tDHCEQContractFind');
	var rows=objtbl.rows.length;
	messageShow("","","",rows)
	for (var i=1; i<rows; i++)
	{
		var obj=document.getElementById("TDetailz"+i);
		if (obj) obj.onclick=TDetail_Clicked;
	}
}
function TDetail_Clicked()
{
	var CurRow=GetTableCurRow();
	var val="&RowID="+GetElementValue("TRowIDz"+CurRow);
  val=val+"&CurRole="+GetElementValue("ApproveRole");
  val=val+"&QXType="+GetElementValue("QXType");
  val=val+"&Type="+GetElementValue("Type");
  var LinkComponentName="DHCEQContractNew";
  var ContractType=GetElementValue("TContractTypez"+CurRow);
  if (ContractType==1)
  {
	  LinkComponentName="DHCEQContractForMaint";
  }
  var str= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val;
  window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=680,left=120,top=0') //2011-10-27 DJ DJ0097
}
function TDetailHandler(rowdata,rowindex)
{
	var val="&RowID="+rowdata.TRowID;
	val=val+"&CurRole="+GetElementValue("ApproveRole");
	val=val+"&QXType="+GetElementValue("QXType");
	val=val+"&Type="+GetElementValue("Type");
	var LinkComponentName="DHCEQContractNew";
	var ContractType=rowdata.TContractType;
	if (ContractType==1)
	{
		LinkComponentName="DHCEQContractForMaint";
	}
	var str= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val;
	//messageShow("","","",str)
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=680,left=120,top=0')
}*/
// �������:	716778	Mozy	2018-11-8
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		//DisableBElement("BAdd1",true);
		hiddenObj("BAdd1",1);
	}
	else
	{
		var obj=document.getElementById("BAdd1");
		if (obj) obj.onclick=BAdd_Clicked;
	}
	if (GetElementValue("ContractType")==2) hiddenObj("BImport",1);	// Mozy		2019-10-04
}
function BAdd_Clicked()
{
	var ContractType=GetElementValue("ContractType");
	var QXType=GetElementValue("QXType");
	var Type=GetElementValue("Type");
	var val="&ContractType="+ContractType+"&QXType="+QXType+"&Type="+Type;
	url="dhceq.con.contract.csp?"+val;
	var Title="�ɹ���ͬ";
	if (ContractType==2) Title="Э��ɹ���ͬ";
	showWindow(url,Title,"","","icon-w-paper","modal","","","verylarge");	//modify by lmm 2020-06-04 UI
}
function BImport_Clicked()
{
	if (GetElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}
function BImport_Chrome()
{
	var FileName=GetFileName();
    if (FileName=="") {return 0;}
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)
	
 	var Str ="(function test(x){"
 	Str +="var xlApp,xlsheet,xlBook,ConRow,ConCol,CurRow,CurCol;"
 	Str +="var ConInfo='';"
 	Str +="var ConListInfo='';"
 	Str +="var ConAffixInfo='';"
 	Str +="xlApp = new ActiveXObject('Excel.Application');"
 	Str +="xlBook = xlApp.Workbooks.Add('"+NewFileName+".xls');" 	
 	Str +="xlsheet =xlBook.Worksheets('�ɹ���ͬ');"
 	Str +="ConRow=xlsheet.UsedRange.Cells.Rows.Count;"
 	Str +="ConCol=xlsheet.UsedRange.Cells.Columns.Count;"
 	Str +="for (CurRow=2;CurRow<=ConRow;CurRow++){"
 	Str +="var OneInfo='';"
 	Str +="for (CurCol=1;CurCol<=ConCol;CurCol++){"
 	Str +="OneInfo=OneInfo+'^'+xlsheet.cells(CurRow,CurCol).text;}"
 	Str +="ConInfo=ConInfo+'&'+OneInfo;}" 	
 	Str +="xlsheet =xlBook.Worksheets('��ͬ�豸��ϸ');"
 	Str +="ConRow=xlsheet.UsedRange.Cells.Rows.Count;"
 	Str +="ConCol=xlsheet.UsedRange.Cells.Columns.Count;"
 	Str +="for (CurRow=2;CurRow<=ConRow;CurRow++){"
 	Str +="var OneInfo='';"
 	Str +="for (CurCol=1;CurCol<=ConCol;CurCol++){"
 	Str +="OneInfo=OneInfo+'^'+xlsheet.cells(CurRow,CurCol).text;}"
 	Str +="ConListInfo=ConListInfo+'&'+OneInfo;}" 	
 	Str +="xlsheet =xlBook.Worksheets('�豸����');"
 	Str +="ConRow=xlsheet.UsedRange.Cells.Rows.Count;"
 	Str +="ConCol=xlsheet.UsedRange.Cells.Columns.Count;"
 	Str +="for (CurRow=2;CurRow<=ConRow;CurRow++){"
 	Str +="var OneInfo='';"
 	Str +="for (CurCol=1;CurCol<=ConCol;CurCol++){"
 	Str +="OneInfo=OneInfo+'^'+xlsheet.cells(CurRow,CurCol).text;}"
 	Str +="ConAffixInfo=ConAffixInfo+'&'+OneInfo;}"
 	
	Str +="return '1||'+ConInfo+'||'+ConListInfo+'||'+ConAffixInfo;}());";
	CmdShell.notReturn =0;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
	var AllInfo=rtn.rtn
	var OneInfo=AllInfo.split("||");
	if (OneInfo[0]!=1)
	{
		alertShow("��ȡEXCEL�ļ�ʧ��!")
		return
	}
	var ConInfoStr=OneInfo[1]
	var ConListInfoStr=OneInfo[2]
	var ConAffixInfoStr=OneInfo[3]
	var ConInfo=new Array();
	var ConListInfo=new Array();
	var ConAffixInfo=new Array();
	var contractdata="";
	var valList="";
	var affixList="";
	//��ͬ��Ϣ
	var encmeth=GetElementValue("GetIDByDesc");
	var ConRow=ConInfoStr.split("&")
	for (var CurRow=1;CurRow<ConRow.length;CurRow++)
	{
		ConInfo[CurRow]=new Array();
		var RowInfoStr=ConRow[CurRow];
		var ConCol=RowInfoStr.split("^");
//		for (var CurCol=1;CurCol<ConCol.length;CurCol++)
//		{
//			ConInfo[CurRow][CurCol]=ConCol[CurCol];
//		}
		var Col=1;
		var ContractRow=trim(ConCol[Col++]);
		if (ContractRow=="")
		{
			alertShow("�ɹ���ͬ:��"+CurRow+"�к�ͬ���Ϊ��,���Ȳ���!");
		    return 0;
		}
		var ContractName=trim(ConCol[Col++]);
		if (ContractName=="")
		{
			alertShow("�ɹ���ͬ:��"+CurRow+"�к�ͬ����Ϊ��,���Ȳ���!");
		    return 0;
		}
		var ContractNo=trim(ConCol[Col++]);
		var TotalFee=trim(ConCol[Col++]);
		var PreFeeFee=trim(ConCol[Col++]);
		var SignDate=trim(ConCol[Col++]);
		var SignLocDR="";
		var SignLoc=trim(ConCol[Col++]);
		if (SignLoc!="")
		{
			SignLocDR=cspRunServerMethod(encmeth,"CTLoc",SignLoc);
			if (SignLocDR=="")
			{
				alertShow("�ɹ���ͬ:��"+CurRow+"�� ǩ�����ŵ���Ϣ����ȷ:"+SignLoc);
				return 0;
			}
		}
	    var Provider=trim(ConCol[Col++]);
	    if (Provider=="")
		{
			alertShow("�ɹ���ͬ:��"+CurRow+"�й�Ӧ��Ϊ��,���Ȳ���!");
		    return 0;
		}
		
	    var ProviderTel=trim(ConCol[Col++]);
	    var ProviderHandler=trim(ConCol[Col++]);
	    var GuaranteePeriodNum=trim(ConCol[Col++]);
	    var Remark=trim(ConCol[Col++]);
	    var ArriveMonthNum=trim(ConCol[Col++]);
	    var ServicePro=trim(ConCol[Col++]);
	    var ServiceHandler=trim(ConCol[Col++]);
	    var ServiceTel=trim(ConCol[Col++]);
	    
		if(contractdata!="") contractdata=contractdata+"&";
		contractdata=contractdata+ContractRow;
		contractdata=contractdata+"^"+ContractName;
		contractdata=contractdata+"^"+ContractNo;
		contractdata=contractdata+"^"+TotalFee;
		contractdata=contractdata+"^"+PreFeeFee;
		contractdata=contractdata+"^"+SignDate;
		contractdata=contractdata+"^"+SignLocDR;
		contractdata=contractdata+"^"+Provider;
		contractdata=contractdata+"^"+ProviderTel;
		contractdata=contractdata+"^"+ProviderHandler;
		contractdata=contractdata+"^"+GuaranteePeriodNum;
		contractdata=contractdata+"^"+Remark;	
		contractdata=contractdata+"^"+ArriveMonthNum;
		contractdata=contractdata+"^"+ServicePro;
		contractdata=contractdata+"^"+ServiceHandler;
		contractdata=contractdata+"^"+ServiceTel;
	}
	//��ͬ��ϸ
	var ConRow=ConListInfoStr.split("&")
	for (var CurRow=1;CurRow<ConRow.length;CurRow++)
	{
		ConListInfo[CurRow]=new Array();
		var RowInfoStr=ConRow[CurRow];
		var ConCol=RowInfoStr.split("^");
//		for (var CurCol=1;CurCol<ConCol.length;CurCol++)
//		{
//			ConListInfo[CurRow][CurCol]=ConCol[CurCol];
//		}
		var ListCol=1;
		var ListContractRow=trim(ConCol[ListCol++]);
		if (ListContractRow=="")
		{
			alertShow("��ͬ�豸��ϸ:��"+CurRow+"�к�ͬ���Ϊ��,���Ȳ���!");
		    return 0;
		}
		var ContractListRow=trim(ConCol[ListCol++]);
		if (ContractListRow=="")
		{
			alertShow("��ͬ�豸��ϸ:��"+CurRow+"�к�ͬ��ϸ���Ϊ��,���Ȳ���!");
		    return 0;
		}
		var EquipTypeDR="";
		var EquipType=trim(ConCol[ListCol++]);
		if (EquipType!="")
		{
			EquipTypeDR=cspRunServerMethod(encmeth,"DHCEQCEquipType",EquipType);
			if (EquipTypeDR=="")
			{
				alertShow("��ͬ��ϸ:��"+CurRow+"�� �����������Ϣ����ȷ:"+EquipType);
				return 0;
			}
		}
		var ItemDR="";
		var Item=trim(ConCol[ListCol++]);
		if (Item!="")
		{
			ItemDR=cspRunServerMethod(encmeth,"DHCEQCMasterItem",Item,EquipTypeDR);
			if (ItemDR=="")
			{
				alertShow("��ͬ��ϸ:��"+CurRow+"�� �豸���Ƶ���Ϣ����ȷ:"+Item);
				return 0;
			}
		}
		var Model=trim(ConCol[ListCol++]);
		var ManuFactory=trim(ConCol[ListCol++]);
		var PriceFee=trim(ConCol[ListCol++]);
		if (PriceFee=="")
		{
			alertShow("��ͬ��ϸ:��"+CurRow+"�е���Ϊ��,���Ȳ���!");
	  	 	return 0;
		}
		var QuantityNum=trim(ConCol[ListCol++]);
		if (QuantityNum=="")
		{
			alertShow("��ͬ��ϸ:��"+CurRow+"������Ϊ��,���Ȳ���!");
	  	 	return 0;
		}
		var ListRemark=trim(ConCol[ListCol++]);
		if(valList!="") valList=valList+"&";			
		valList=valList+ListContractRow+"^"+ContractListRow+"^"+ItemDR+"^"+Model+"^"+ManuFactory+"^"+PriceFee+"^"+QuantityNum+"^"+ListRemark;
	}
	//����
	var ConRow=ConAffixInfoStr.split("&")
	for (var CurRow=1;CurRow<ConRow.length;CurRow++)
	{
		ConAffixInfo[CurRow]=new Array();
		var RowInfoStr=ConRow[CurRow];
		var ConCol=RowInfoStr.split("^");
//		for (var CurCol=1;CurCol<ConCol.length;CurCol++)
//		{
//			ConAffixInfo[CurRow][CurCol]=ConCol[CurCol];
//		}
		var AffixCol=1;
		var AffixListRow=trim(ConCol[AffixCol++]);
		if (AffixListRow=="")
		{
			alertShow("�豸����:��"+CurRow+"�к�ͬ��ϸ���Ϊ��,���Ȳ���!");
			return 0;
		}
		var PartSpec=trim(ConCol[AffixCol++]);
		if (PartSpec=="")
		{
			alertShow("�豸����:��"+CurRow+"�и�������Ϊ��,���Ȳ���!");
			return 0;
		}
		var PartModel=trim(ConCol[AffixCol++]);
		var PartManuFactory=trim(ConCol[AffixCol++]);
		var AffixQuantityNum=trim(ConCol[AffixCol++]);
		if (AffixQuantityNum=="")
		{
			alertShow("�豸����:��"+CurRow+"�и�������Ϊ��,���Ȳ���!");
			return 0;
		}
		var Receiver=trim(ConCol[AffixCol++]);
		var LeaveFacNo=trim(ConCol[AffixCol++]);
		var LeaveDate=trim(ConCol[AffixCol++]);
		var AffixPriceFee=trim(ConCol[AffixCol++]);
		if (AffixPriceFee=="")
		{
			alertShow("�豸����:��"+CurRow+"�и�������Ϊ��,���Ȳ���!");
			return 0;
		}
		var Uom=trim(ConCol[AffixCol++]);
		var AffixRemark=trim(ConCol[AffixCol++]);
		var AffixProvider=trim(ConCol[AffixCol++]);
		var InvoiceNo=trim(ConCol[AffixCol++]);
		var RegistrationNo=trim(ConCol[AffixCol++]);
		if(affixList!="") affixList=affixList+"&";			
		affixList=affixList+AffixListRow+"^"+PartSpec+"^"+PartModel+"^"+PartManuFactory+"^"+AffixQuantityNum+"^"+Receiver+"^"+LeaveFacNo+"^"+LeaveDate+"^"+AffixPriceFee+"^"+Uom+"^"+AffixRemark+"^"+AffixProvider+"^"+InvoiceNo+"^"+RegistrationNo;
	}
	var Return=cspRunServerMethod(GetElementValue("ImportContractInfo"),contractdata,valList,affixList);
	if (Return<0)
	{
		alertShow(Return+"   �ɹ���ͬ���뷢������!");
	}
	else
	{
		alertShow("�����ͬ��Ϣ�������,����˶Ը���ͬ����Ϣ!");
		window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQContractFind&ContractType=0&StatusDR=0&Type=0&QXType=1&WaitAD=off&SignLocDR'+GetElementValue("SignLocDR");
	}
}
///�����ͬ		Mozy		2019-10-04
function BImport_IE()
{
	var FileName=GetFileName();
    if (FileName=="") {return 0;}
    
    var xlApp,xlsheet,xlBook,Clistxlsheet, Caffixxlsheet
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(FileName);
    //xlsheet = xlBook.ActiveSheet
    
    xlsheet =xlBook.Worksheets("�ɹ���ͬ");
	var ContractRows=xlsheet.UsedRange.Cells.Rows.Count;
	//alertShow("�ɹ���ͬ��: "+(ContractRows-1))
	var contractdata="";
	var valList="";
	var affixList="";
	//��ͬ��Ϣ
	var encmeth=GetElementValue("GetIDByDesc");
	for (var Row=2;Row<=ContractRows;Row++)
	{
		var Col=1;
		var ContractRow=trim(xlsheet.cells(Row,Col++).text);
		if (ContractRow=="")
		{
			alertShow("�ɹ���ͬ:��"+Row+"�к�ͬ���Ϊ��,���Ȳ���!");
		    return 0;
		}
		var ContractName=trim(xlsheet.cells(Row,Col++).text);
		if (ContractName=="")
		{
			alertShow("�ɹ���ͬ:��"+Row+"�к�ͬ����Ϊ��,���Ȳ���!");
		    return 0;
		}
		var ContractNo=trim(xlsheet.cells(Row,Col++).text);
		var TotalFee=trim(xlsheet.cells(Row,Col++).text);
		var PreFeeFee=trim(xlsheet.cells(Row,Col++).text);
		var SignDate=trim(xlsheet.cells(Row,Col++).text);
		var SignLocDR="";
		var SignLoc=trim(xlsheet.cells(Row,Col++).text);
		if (SignLoc!="")
		{
			SignLocDR=cspRunServerMethod(encmeth,"CTLoc",SignLoc);
			//alertShow(SignLoc+"->"+SignLocDR)
			if (SignLocDR=="")
			{
				alertShow("�ɹ���ͬ:��"+Row+"�� ǩ�����ŵ���Ϣ����ȷ:"+SignLoc);
				return 0;
			}
		}
	    var Provider=trim(xlsheet.cells(Row,Col++).text);
	    if (Provider=="")
		{
			alertShow("�ɹ���ͬ:��"+Row+"�й�Ӧ��Ϊ��,���Ȳ���!");
		    return 0;
		}
		
	    var ProviderTel=trim(xlsheet.cells(Row,Col++).text);
	    var ProviderHandler=trim(xlsheet.cells(Row,Col++).text);
	    var GuaranteePeriodNum=trim(xlsheet.cells(Row,Col++).text);
	    var Remark=trim(xlsheet.cells(Row,Col++).text);
	    var ArriveMonthNum=trim(xlsheet.cells(Row,Col++).text);
	    var ServicePro=trim(xlsheet.cells(Row,Col++).text);
	    var ServiceHandler=trim(xlsheet.cells(Row,Col++).text);
	    var ServiceTel=trim(xlsheet.cells(Row,Col++).text);
	    
		if(contractdata!="") contractdata=contractdata+"&";
		contractdata=contractdata+ContractRow;
		contractdata=contractdata+"^"+ContractName;
		contractdata=contractdata+"^"+ContractNo;
		contractdata=contractdata+"^"+TotalFee;
		contractdata=contractdata+"^"+PreFeeFee;
		contractdata=contractdata+"^"+SignDate;
		contractdata=contractdata+"^"+SignLocDR;
		contractdata=contractdata+"^"+Provider;
		contractdata=contractdata+"^"+ProviderTel;
		contractdata=contractdata+"^"+ProviderHandler;
		contractdata=contractdata+"^"+GuaranteePeriodNum;
		contractdata=contractdata+"^"+Remark;	
		contractdata=contractdata+"^"+ArriveMonthNum;
		contractdata=contractdata+"^"+ServicePro;
		contractdata=contractdata+"^"+ServiceHandler;
		contractdata=contractdata+"^"+ServiceTel;
	}
	
	//��ͬ��ϸ��Ϣ
	Clistxlsheet =xlBook.Worksheets("��ͬ�豸��ϸ");
	var ContractListRows=Clistxlsheet.UsedRange.Cells.Rows.Count;
	//alertShow("�ɹ���ͬ��ϸ��: "+(ContractListRows-1))
	for (var ListRow=2;ListRow<=ContractListRows;ListRow++)
	{
		var ListCol=1;
		var ListContractRow=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (ListContractRow=="")
		{
			alertShow("��ͬ�豸��ϸ:��"+ListRow+"�к�ͬ���Ϊ��,���Ȳ���!");
		    return 0;
		}
		var ContractListRow=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (ContractListRow=="")
		{
			alertShow("��ͬ�豸��ϸ:��"+ListRow+"�к�ͬ��ϸ���Ϊ��,���Ȳ���!");
		    return 0;
		}
		var EquipTypeDR="";
		var EquipType=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (EquipType!="")
		{
			EquipTypeDR=cspRunServerMethod(encmeth,"DHCEQCEquipType",EquipType);
			if (EquipTypeDR=="")
			{
				alertShow("��ͬ��ϸ:��"+ListRow+"�� �����������Ϣ����ȷ:"+EquipType);
				return 0;
			}
		}
		var ItemDR="";
		var Item=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (Item!="")
		{
			ItemDR=cspRunServerMethod(encmeth,"DHCEQCMasterItem",Item,EquipTypeDR);
			if (ItemDR=="")
			{
				alertShow("��ͬ��ϸ:��"+ListRow+"�� �豸���Ƶ���Ϣ����ȷ:"+Item);
				return 0;
			}
		}
		var Model=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		var ManuFactory=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		var PriceFee=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (PriceFee=="")
		{
			alertShow("��ͬ��ϸ:��"+ListRow+"�е���Ϊ��,���Ȳ���!");
	  	 	return 0;
		}
		var QuantityNum=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (QuantityNum=="")
		{
			alertShow("��ͬ��ϸ:��"+ListRow+"������Ϊ��,���Ȳ���!");
	  	 	return 0;
		}
		var ListRemark=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if(valList!="") valList=valList+"&";			
		valList=valList+ListContractRow+"^"+ContractListRow+"^"+ItemDR+"^"+Model+"^"+ManuFactory+"^"+PriceFee+"^"+QuantityNum+"^"+ListRemark;
	}
	
	//��ͬ��ϸ������Ϣ
	Caffixxlsheet =xlBook.Worksheets("�豸����");
	var ContractAffixRows=Caffixxlsheet.UsedRange.Cells.Rows.Count;
	//alertShow("�ɹ��豸������: "+(ContractAffixRows-1))
	for (var AffixRow=2;AffixRow<=ContractAffixRows;AffixRow++)
	{
		var AffixCol=1;
		var AffixListRow=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		if (AffixListRow=="")
		{
			alertShow("�豸����:��"+AffixRow+"�к�ͬ��ϸ���Ϊ��,���Ȳ���!");
			return 0;
		}
		var PartSpec=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		if (PartSpec=="")
		{
			alertShow("�豸����:��"+AffixRow+"�и�������Ϊ��,���Ȳ���!");
			return 0;
		}
		var PartModel=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var PartManuFactory=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var AffixQuantityNum=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		if (AffixQuantityNum=="")
		{
			alertShow("�豸����:��"+AffixRow+"�и�������Ϊ��,���Ȳ���!");
			return 0;
		}
		var Receiver=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var LeaveFacNo=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var LeaveDate=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var AffixPriceFee=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		if (AffixPriceFee=="")
		{
			alertShow("�豸����:��"+AffixRow+"�и�������Ϊ��,���Ȳ���!");
			return 0;
		}
		var Uom=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var AffixRemark=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var AffixProvider=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var InvoiceNo=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		var RegistrationNo=trim(Caffixxlsheet.cells(AffixRow,AffixCol++).text);
		if(affixList!="") affixList=affixList+"&";			
		affixList=affixList+AffixListRow+"^"+PartSpec+"^"+PartModel+"^"+PartManuFactory+"^"+AffixQuantityNum+"^"+Receiver+"^"+LeaveFacNo+"^"+LeaveDate+"^"+AffixPriceFee+"^"+Uom+"^"+AffixRemark+"^"+AffixProvider+"^"+InvoiceNo+"^"+RegistrationNo;
	}
	//alertShow(affixList)
	xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet.Quit;
    xlsheet=null;
    
	var truthBeTold = window.confirm("�Ƿ�������������ͬ��Ϣ?");
	if (!truthBeTold) return 0;
	var Return=cspRunServerMethod(GetElementValue("ImportContractInfo"),contractdata,valList,affixList);
	if (Return<0)
	{
		alertShow(Return+"   �ɹ���ͬ���뷢������!");
	}
	else
	{
		alertShow("�����ͬ��Ϣ�������,����˶Ը���ͬ����Ϣ!");
		//                           http://127.0.0.1/dthealth/web/csp/websys.csp?a=a&ContractType=0&StatusDR=0&Type=0&QXType=1&WaitAD=off&SignLocDR=153&StartDate=&EndDate=06/09/2019
		window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQContractFind&ContractType=0&StatusDR=0&Type=0&QXType=1&WaitAD=off&SignLocDR'+GetElementValue("SignLocDR");
	}
}
document.body.onload = BodyLoadHandler;