/// Modified By HZY 2011-10-19 HZY0018
/// �޸ĺ���: InitPage

function BodyLoadHandler()
{
	InitUserInfo();	
	InitPage();
	SetBEnable();
	//InitTblEvt();
	initButtonWidth();
	initPanelHeaderStyle();
	initButtonColor();
	if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
		if (jQuery("#BAdd1").length>0)
		{
			if (($("#BAdd1").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BAdd1").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BAdd1").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
		if (jQuery("#BAddNew").length>0)
		{
			if (($("#BAddNew").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BAddNew").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BAddNew").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
	}
	// Mozy0253	1214408		2020-3-4	����������
	if (GetElementValue("ContractType")==2)
	{
		HiddenTblColumn("tDHCEQContractFind","TContractName");
		HiddenTblColumn("tDHCEQContractFind","TQuantityNum");	// MZY0057	1497996		2020-10-09
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
		hiddenObj("BAddNew",1);		//czf 1914903 2021-05-22
	}
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("BAddNew")	//czf 1914903
	if (obj) obj.onclick=BAddNew_Clicked;
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
	var CancelOper=GetElementValue("CancelOper");
	if ((WaitAD!="off")||(CancelOper=="Y"))
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
	var val="&ContractType="+ContractType+"&QXType="+QXType+"&Type="+Type+"&AuditType=1";	//czf 1914903 2021-05-22
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
 	Str +="var ConLocInfoStr='';"   //add by cjc 2022/08/18
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
 	
	Str +="xlsheet =xlBook.Worksheets('��ͬʹ�ÿ�����ϸ');"  //add by cjc 2022/08/18 begin
 	Str +="ConRow=xlsheet.UsedRange.Cells.Rows.Count;"
 	Str +="ConCol=xlsheet.UsedRange.Cells.Columns.Count;"
 	Str +="for (CurRow=2;CurRow<=ConRow;CurRow++){"
 	Str +="var OneInfo='';"
 	Str +="for (CurCol=1;CurCol<=ConCol;CurCol++){"
 	Str +="OneInfo=OneInfo+'^'+xlsheet.cells(CurRow,CurCol).text;}"
 	Str +="ConLocInfoStr=ConLocInfoStr+'&'+OneInfo;}" //add by cjc 2022/08/18 end
 	
	Str +="return '1||'+ConInfo+'||'+ConListInfo+'||'+ConAffixInfo+'||'+ConLocInfoStr;}());";//modify by cjc 2022/08/18 ������ConLocInfoStr����
	CmdShell.notReturn =0;  //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);    //ͨ���м�����д�ӡ����  
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
	var ConLocInfoStr=OneInfo[4]  //add by wy 2021-11-08 WY0096
	
	var ConInfo=new Array();
	var ConListInfo=new Array();
	var ConAffixInfo=new Array();
	var ConLocInfo=new Array();  //add by wy 2021-11-08 WY0096
	var contractdata="";
	var valList="";
	var affixList="";
	var LocList=""    //add by wy 2021-11-08 WY0096
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
			SignLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",SignLoc);	// MZY0055	1537698		2020-09-22
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
	    //var GuaranteePeriodNum=trim(ConCol[Col++]);
	    var BuyType=trim(ConCol[Col++]);   //add by wy 2021-11-08�ɹ���ʽ
		var BuyTypeDR="";
		if (BuyType!="")
		{
			BuyTypeDR=cspRunServerMethod(encmeth,"DHCEQCBuyType",BuyType);	// MZY0055	1537698		2020-09-22
			if (BuyTypeDR=="")
			{
				alertShow("�ɹ���ͬ:��"+CurRow+"�� �ɹ���ʽ����Ϣ����ȷ:"+BuyType);//modify by cjc 2022/08/18
				return 0;
			}
		}
	    var Remark=trim(ConCol[Col++]);
	    var ArriveMonthNum=trim(ConCol[Col++]);
	    var ServicePro=trim(ConCol[Col++]);
	    var ServiceHandler=trim(ConCol[Col++]);
	    var ServiceTel=trim(ConCol[Col++]);
	    var BuyUser=trim(ConCol[Col++]); //modify by cjc 2022/08/18
		var BuyUserDR="";
	    if (BuyUser!="")
		{
			BuyUserDR=cspRunServerMethod(encmeth,"DHCEQCUser",BuyUser);	// MZY0055	1537698		2020-09-22
			if (BuyUserDR=="")
			{
				alertShow("�ɹ���ͬ:��"+CurRow+"�� �ɹ��˵���Ϣ����ȷ:"+BuyUser);//modify by cjc 2022/08/18
				return 0;
			}
		}

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
		contractdata=contractdata+"^"   //+GuaranteePeriodNum;
		contractdata=contractdata+"^"+Remark;	
		contractdata=contractdata+"^"+ArriveMonthNum;
		contractdata=contractdata+"^"+ServicePro;
		contractdata=contractdata+"^"+ServiceHandler;
		contractdata=contractdata+"^"+ServiceTel;
		contractdata=contractdata+"^"+BuyTypeDR;
		contractdata=contractdata+"^"+BuyUserDR;
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
		//modified by wy 2021-9-2 WY0095 begin�����豸���ͣ����ർ��
		var EQStatCatDR="";
		var EQStatCat=trim(ConCol[ListCol++]);
		if (EQStatCat!="")
		{
			EQStatCatDR=cspRunServerMethod(encmeth,"DHCEQCStatCat",EQStatCat);
			if (EQStatCatDR=="")
			{
				alertShow("��ͬ��ϸ:��"+CurRow+"�� �豸���͵���Ϣ����ȷ:"+EQStatCat);//modify by cjc 2022/08/22
				return 0;
			}
		}
		var EQEquiCatDR="";
		var EQEquiCat=trim(ConCol[ListCol++]);
		if (EQEquiCat!="")
		{
			EQEquiCatDR=cspRunServerMethod(encmeth,"EquipCat",EQEquiCat);
			if (EQEquiCatDR=="")
			{
				alertShow("��ͬ��ϸ:��"+CurRow+"�� �豸�������Ϣ����ȷ:"+EQEquiCat);//modify by cjc 2022/08/18
				return 0;
			}
		}
		var UnitDR="";
		var Unit=trim(ConCol[ListCol++]);
		if (Unit!="")
		{
			UnitDR=cspRunServerMethod(encmeth,"DHCEQCUOM",Unit);
			if (UnitDR=="")
			{
				alertShow("��ͬ��ϸ:��"+CurRow+"�� �豸��λ����Ϣ����ȷ:"+Unit);//modify by cjc 2022/08/18
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
			    var val="^"+Item+"^"+GetPYCode(Item)+"^"+EquipTypeDR+"^"+EQStatCatDR+"^"+EQEquiCatDR+"^^"+UnitDR+"^^^^^^^^"
			    ItemDR=tkMakeServerCall("web.DHCEQCMasterItem","SaveData","","",val,"","");
			    if (ItemDR=="")  
			    {
				    alertShow("��ͬ��ϸ:��"+CurRow+"�� �豸�����Ϣ����ȷ:"+Item);//modify by cjc 2022/08/18
				    return 0;
				    }
			}
		}
		// modified by wy 2021-9-2 WY0095 end 
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
	    var GuaranteePeriodNum=trim(ConCol[ListCol++]); // modifiy by cjc 2022/08/19
	    var RegistrationNo=trim(ConCol[ListCol++]);	// modifiy by cjc 2022/08/19
	    //var LeaveFactoryNos=trim(Clistxlsheet.cells(ListRow,ListCol++).text);	
		if(valList!="") valList=valList+"&";			
		valList=valList+ListContractRow+"^"+ContractListRow+"^"+ItemDR+"^"+Model+"^"+ManuFactory+"^"+PriceFee+"^"+QuantityNum+"^"+ListRemark+"^"+GuaranteePeriodNum+"^"+RegistrationNo;
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
	//��ͬʹ�ÿ�����ϸ add by wy 2021-9-2 WY0096
	var ConRow=ConLocInfoStr.split("&")
	for (var CurRow=1;CurRow<ConRow.length;CurRow++)
	{
		ConLocInfo[CurRow]=new Array();
		var RowInfoStr=ConRow[CurRow];
		var ConCol=RowInfoStr.split("^");
		var LocCol=1;
		var LocListRow=trim(ConCol[LocCol++]);
		if (LocListRow=="")
		{
			alertShow("ʹ�ÿ���:��"+CurRow+"�к�ͬ��ϸ���Ϊ��,���Ȳ���!");// modifiy by cjc 2022/08/19
			return 0;
		}
		var UseLocDR="";
		var UseLoc=trim(ConCol[LocCol++]);
		if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc);	
			if (UseLocDR=="")
			{
				alertShow("�ɹ���ͬ:��"+LocListRow+"�� ʹ�ÿ��ҵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		var LocQuantityNum=trim(ConCol[LocCol++]);
		var LeaveFactoryNo=trim(ConCol[LocCol++]);
		if(LocList!="") LocList=LocList+"&";
		LocList=LocList+LocListRow+"^"+UseLocDR+"^"+LocQuantityNum+"^"+LeaveFactoryNo; //modify by cjc 2022/08/18 ��CLocListRow��ΪLocListRow

	}
	var Return=cspRunServerMethod(GetElementValue("ImportContractInfo"),contractdata,valList,affixList,LocList);
	if (Return<0)
	{
		// MZY0088	2021-08-16
		if (Return==-119)
		{
			alertShow(Return+"   �ɹ���ͬ���뷢������!�����ͬ���Ƿ��Ѿ�����(�ظ�)!");
		}
		else
		{
			alertShow(Return+"   �ɹ���ͬ���뷢������!");
		}
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
	var LocList=""    //add by wy 2021-11-08
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
			SignLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",SignLoc);	// MZY0055	1537698		2020-09-22
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
	    //var GuaranteePeriodNum=trim(xlsheet.cells(Row,Col++).text);  
	    var BuyType=trim(xlsheet.cells(Row,Col++).text);    //add by wy 2021-11-08�ɹ���ʽ
		var BuyTypeDR="";
		if (BuyType!="")
		{
			BuyTypeDR=cspRunServerMethod(encmeth,"DHCEQCBuyType",BuyType);	// MZY0055	1537698		2020-09-22
			if (BuyTypeDR=="")
			{
				alertShow("�ɹ���ͬ:��"+Row+"�� �ɹ���ʽ����Ϣ����ȷ:"+BuyType);
				return 0;
			}
		}
	    var Remark=trim(xlsheet.cells(Row,Col++).text);
	    var ArriveMonthNum=trim(xlsheet.cells(Row,Col++).text);
	    var ServicePro=trim(xlsheet.cells(Row,Col++).text);
	    var ServiceHandler=trim(xlsheet.cells(Row,Col++).text);
	    var ServiceTel=trim(xlsheet.cells(Row,Col++).text);	    
	    var BuyUser=trim(xlsheet.cells(Row,Col++).text);
		var BuyUserDR="";
	    if (BuyUser!="")
		{
			BuyUserDR=cspRunServerMethod(encmeth,"DHCEQCUser",BuyUser);	// MZY0055	1537698		2020-09-22
			if (BuyUserDR=="")
			{
				alertShow("�ɹ���ͬ:��"+Row+"�� �ɹ��˵���Ϣ����ȷ:"+BuyUser);
				return 0;
			}
		}
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
		contractdata=contractdata+"^"  //+GuaranteePeriodNum;
		contractdata=contractdata+"^"+Remark;	
		contractdata=contractdata+"^"+ArriveMonthNum;
		contractdata=contractdata+"^"+ServicePro;
		contractdata=contractdata+"^"+ServiceHandler;
		contractdata=contractdata+"^"+ServiceTel;
		contractdata=contractdata+"^"+BuyTypeDR;
		contractdata=contractdata+"^"+BuyUserDR;
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
		
		//modified by wy 2021-9-2 WY0096 begin�����豸���ͣ����ർ��
		var EQStatCatDR="";
		var EQStatCat=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (EQStatCat!="")
		{
			EQStatCatDR=cspRunServerMethod(encmeth,"DHCEQCStatCat",EQStatCat);
			if (EQStatCatDR=="")
			{
				alertShow("��ͬ��ϸ:��"+ListRow+"�� �豸���͵���Ϣ����ȷ:"+EQStatCat);
				return 0;
			}
		}
		var EQEquiCatDR="";
		var EQEquiCat=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (EQEquiCat!="")
		{
			EQEquiCatDR=cspRunServerMethod(encmeth,"EquipCat",EQEquiCat);
			if (EQEquiCatDR=="")
			{
				alertShow("��ͬ��ϸ:��"+ListRow+"�� �豸�������Ϣ����ȷ:"+EQEquiCat);
				return 0;
			}
		}
		var UnitDR="";
		var Unit=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
		if (Unit!="")
		{
			UnitDR=cspRunServerMethod(encmeth,"DHCEQCUOM",Unit);
			if (UnitDR=="")
			{
				alertShow("��ͬ��ϸ:��"+ListRow+"�� �豸��λ����Ϣ����ȷ:"+Unit);
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
			    var val="^"+Item+"^"+GetPYCode(Item)+"^"+EquipTypeDR+"^"+EQStatCatDR+"^"+EQEquiCatDR+"^^"+UnitDR+"^^^^^^^^"
			    ItemDR=tkMakeServerCall("web.DHCEQCMasterItem","SaveData","","",val,"","");
			    if (ItemDR=="")  
			    {
				    alertShow("��ͬ��ϸ:��"+ListRow+"�� �豸�����Ϣ����ȷ:"+Item);
				    return 0;
				    }
			}
		}
		// modified by wy 2021-9-2 WY0096 end 
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
	    var GuaranteePeriodNum=trim(Clistxlsheet.cells(ListRow,ListCol++).text); // modified by wy 2021-9-2 WY0096
	    var RegistrationNo=trim(Clistxlsheet.cells(ListRow,ListCol++).text);
	    //var LeaveFactoryNos=trim(Clistxlsheet.cells(ListRow,ListCol++).text);	
		if(valList!="") valList=valList+"&";			
		valList=valList+ListContractRow+"^"+ContractListRow+"^"+ItemDR+"^"+Model+"^"+ManuFactory+"^"+PriceFee+"^"+QuantityNum+"^"+ListRemark+"^"+GuaranteePeriodNum+"^"+RegistrationNo;
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
	
    //��ͬʹ�ÿ�����ϸ
	CLocxlsheet =xlBook.Worksheets("ʹ�ÿ���");
	var ContractLocListRows=CLocxlsheet.UsedRange.Cells.Rows.Count;
	for (var LocListRow=2;LocListRow<=ContractLocListRows;LocListRow++)
	{
		var LocListCol=1;
		var CLocListRow=trim(CLocxlsheet.cells(LocListRow,LocListCol++).text);
		if (CLocListRow=="")
		{
			alertShow("ʹ�ÿ���:��"+LocListRow+"�к�ͬ��ϸ���Ϊ��,���Ȳ���!");
			return 0;
		}
		var UseLocDR="";
		var UseLoc=trim(CLocxlsheet.cells(LocListRow,LocListCol++).text);
		if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc);	
			if (UseLocDR=="")
			{
				alertShow("�ɹ���ͬ:��"+LocListRow+"�� ʹ�ÿ��ҵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		var LocQuantityNum=trim(CLocxlsheet.cells(LocListRow,LocListCol++).text);
		var LeaveFactoryNo=trim(CLocxlsheet.cells(LocListRow,LocListCol++).text);
		if(LocList!="") LocList=LocList+"&";
		LocList=LocList+CLocListRow+"^"+UseLocDR+"^"+LocQuantityNum+"^"+LeaveFactoryNo;
	}
	xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet.Quit;
    xlsheet=null;
    
	var truthBeTold = window.confirm("�Ƿ�������������ͬ��Ϣ?");
	if (!truthBeTold) return 0;
	var Return=cspRunServerMethod(GetElementValue("ImportContractInfo"),contractdata,valList,affixList,LocList);
	if (Return<0)
	{
		// MZY0088	2021-08-16
		if (Return==-119)
		{
			alertShow(Return+"   �ɹ���ͬ���뷢������!�����ͬ���Ƿ��Ѿ�����(�ظ�)!");
		}
		else
		{
			alertShow(Return+"   �ɹ���ͬ���뷢������!");
		}
	}
	else
	{
		alertShow("�����ͬ��Ϣ�������,����˶Ը���ͬ����Ϣ!");
		//                           http://127.0.0.1/dthealth/web/csp/websys.csp?a=a&ContractType=0&StatusDR=0&Type=0&QXType=1&WaitAD=off&SignLocDR=153&StartDate=&EndDate=06/09/2019
		window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQContractFind&ContractType=0&StatusDR=0&Type=0&QXType=1&WaitAD=off&SignLocDR'+GetElementValue("SignLocDR");
	}
}

//czf 1914903 2021-05-22
function BAddNew_Clicked()
{
	var ContractType=GetElementValue("ContractType");
	var QXType=GetElementValue("QXType");
	var Type=GetElementValue("Type");
	var val="&ContractType="+ContractType+"&QXType="+QXType+"&Type="+Type+"&AuditType=2";
	url="dhceq.con.contract.csp?"+val;
	var Title="�ɹ���ͬ";
	if (ContractType==2) Title="Э��ɹ���ͬ";
	showWindow(url,Title,"","","icon-w-paper","modal","","","verylarge");
}
document.body.onload = BodyLoadHandler;
