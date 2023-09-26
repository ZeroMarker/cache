var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	KeyUp("Accessory^AccessoryType^MTPProvider^MTPManufacturer","N")
    InitUserInfo(); //系统参数
	InitEvent();	
	disabled(true);//灰化
	//刷新父级窗口配件费及总费用
	opener.SetElement("OtherFee",GetElementValue("GetTotalFee"));
	opener.TotalFee_Change();
	//MTPTotalFee_Change();
	Muilt_LookUp("Accessory^AccessoryType^MTPProvider^MTPManufacturer");
	var obj=document.getElementById("Chk");
	if (obj) obj.onclick=Chk_Clicked;
	document.getElementById("GetTotalFee").style.color="#ff8000";
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BConfirm");
	if (obj) obj.onclick=BConfirm_Click;
	var obj=document.getElementById("BCancelConfirm");
	if (obj) obj.onclick=BCancelConfirm_Click;
	var obj=document.getElementById("BSubmitManage");
	if (obj) obj.onclick=BSubmitManage_Click;
	var obj=document.getElementById("BCancelManage");
	if (obj) obj.onclick=BCancelManage_Click;
	//var obj=document.getElementById("Accessory");
	//if (obj) obj.onkeyup=AccessoryChange;
	var obj=document.getElementById("MTPQuantityNum");
	if (obj) obj.onchange=MTPTotalFee_Change;
	var obj=document.getElementById("MTPPriceFee");
	if (obj) obj.onchange=MTPTotalFee_Change;
	var obj=document.getElementById(GetLookupName("Accessory"));
	if (obj) obj.onclick=Accessory_Click;
	if (opener)
	{
		var obj=document.getElementById("BClose")
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	//需求序号:	400702		Mozy	20170710
	var obj=document.getElementById("Accessory");
	if (obj) obj.onchange=Accessory_Change;
}
//Modify DJ 2014-09-23
function GetAccessory(value)
{
	//TRowID,TLocDR,TAccessoryTypeDR,TItemDR,TAInStockListDR,TBaseUOMDR,TManuFactoryDR,TProviderDR,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TDesc,TCode,TLoc,TAccessoryType,TModel,TBprice,TManuFactory,TProvider,TStock,CanUseNum,FreezeNum,TInStockNo,TInDate,TStatus,THasStockFlag,TItem,TBatchNo,TExpiryDate,TSerialNo,TNo,TBaseUOM,TFreezeStock,TStartDate,TDisuseDate,TOrigin,TReturnFee,TTotalFee,TBatchFlag)
	//   0     1     		2      		3     		4        		5              6         7          8       9     	10        11          12        13       14    15   16     17         	18       19        20          21      22     23      	24      	25      26       27          28      29      30         31     	   32     33     34      	35          36		  37		38        39        40		  41
	var list=value.split("^")
	//SetElement('AccessoryDR',list[0]);
	//SetElement('Accessory',list[1]);
	//SetElement('MTPHold5',list[0]);
	SetElement("StockDetailDR",list[0]);
	SetElement('AccessoryDR',list[3]);
	SetElement('AISListDR',list[4]);
	SetElement('Accessory',list[29]);
	SetElement('MTPPriceFee',list[19]);
	SetElement('MTPManufacturerDR',list[6]);
	SetElement('MTPManufacturer',list[20]);
	SetElement('MTPQuantityNum',list[23]);
	SetElement('CanUseNum',list[23]);
	SetElement('MTPModel',list[18]);
	SetElement('MTPProviderDR',list[7]);
	SetElement('MTPProvider',list[21]);
	SetElement("MTPHold1",list[22]);		//库存数	Mozy	566327	201-3-16
	SetElement('CanUseNum',list[23]);
	SetElement('InvoiceNos',list[44]); //add by jyp 2018-02-26 546653
	MTPTotalFee_Change();
}/*
function GetAccessoryNew(value)
{
	//alertShow(value)
	//0		 1		2		3		4		5		6			7		8			9			
	//TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TBillUOM,TStdSPrice,TMinSPrice,
	//10			11			12		13			14		15		16	17		18					19
	//TMaxSPrice,TCurBPrice,TMinBPrice,TMaxBPrice,TFeeRules,TType,TCat,TCountry,TPlaceOfProduction,TGeneralName,
	//20				21		22				23			24				25					26			27				28			29
	//TCommercialName,TBrand,TBrandCertificate,TRegisterNo,TCertificateNo,TProductionLicence,TImportNo,TImportRegisterNo,TManuFactory,TManuFactoryDR,
	//30			31				32			33		34				35			36			37			38			39
	//TPakageType,TWastageRate,TSolitudeFlag,TBarCode,TExpiredFlag,TExpiredDays,TWarningDays,TSerialFlag,TMinOrderQty,TMaxOrderQty,
	//40			41		42				43		44			45				46			47			48			49		
	//TABCType,TOverStock,TSelfMakeFlag,TSaleFlag,TVirtualFlag,TPurchaseFlag,TFixPreDays,TExpSaleRate,TWorthQty,TSafeQty,
	//50		51		52				53		54			55		56			57			58				59
	//TMinQty,TMaxQty,TStockEnabledFlag,TVolume,TVolumeUOM,TWeight,TWeightUOM,TRequireNote,TShowMessage,TNeedTest,
	//60					61		62		63			64			65					66			67		68				69
	//TAllowOrderNoStock,TEffDate,TEffTime,TEffDateTo,TEffTimeTo,TVisibleInOrderList,TServMaterial,TVersion,TExtendCode,TReturnableFlag,
	//70							71			72		73
	//TReturnInspectRequirement,TPickingRule,TRemark,TRow
	var list=value.split("^")
	SetElement('AccessoryDR',list[0]);
	SetElement('Accessory',list[2]);
	SetElement('MTPPriceFee',list[8]);
	SetElement('MTPManufacturerDR',list[29]);
	SetElement('MTPManufacturer',list[28]);
	SetElement('MTPQuantityNum',1);
	SetElement('CanUseNum',0);
	SetElement('MTPModel',list[4]);
	//SetElement('MTPProviderDR',list[22]);
	//SetElement('MTPProvider',list[23]);
	
	DisableBElement("MTPPriceFee",false);
	DisableBElement("MTPModel",false);
	
	MTPTotalFee_Change();
}*/
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BAdd_Click() //增加
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'2');
	//alertShow(result+":"+plist)
	result=result.replace(/\\n/g,"\n")
	if (result<0)
	{
		alertShow(result+"   "+t[result]);	//Mozy	2018-3-21	567544	调整错误输出显示
		return
	}
	else
	{
		location.reload();
	}	
}	
function CombinData()
{
	var combindata="";
	
    combindata=GetElementValue("MTPRowID") ;
	combindata=combindata+"^"+GetElementValue("MTPMaintDR") ;
  	combindata=combindata+"^"+GetElementValue("AccessoryDR") ; 
  	combindata=combindata+"^"+GetElementValue("MTPQuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("MTPPriceFee") ;
  	combindata=combindata+"^"+GetElementValue("MTPTotalFee") ;
  	combindata=combindata+"^"+GetElementValue("MTPRemark") ; 
  	combindata=combindata+"^"+GetElementValue("MTPStoreRoomDR") ;
  	combindata=combindata+"^"+GetElementValue("MTPFeeFlag") ;
  	combindata=combindata+"^"+GetElementValue("MaintRequestDR") ;
  	combindata=combindata+"^"+GetElementValue("AccessoryTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ASMLRowID") ;
  	combindata=combindata+"^";	//GetElementValue("PurchaseFlag") ;
  	if (GetChkElementValue("Chk"))
	{combindata=combindata+"Y";}
	else
	{combindata=combindata+"N";}
  	combindata=combindata+"^"+GetElementValue("StockDetailDR") ;
  	combindata=combindata+"^"+GetElementValue("MTPModel") ;
  	combindata=combindata+"^"+GetElementValue("MTPManufacturerDR") ;
  	combindata=combindata+"^"+GetElementValue("MTPProviderDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintItemDR") ;
	combindata=combindata+"^"+GetElementValue("AISListDR");
	combindata=combindata+"^"+GetElementValue("Accessory");
	combindata=combindata+"^"+GetElementValue("InvoiceNos");
	combindata=combindata+"^"+GetElementValue("MTPHold1");		//库存数	Mozy	566327	201-3-16
	// MTP_Hold1 MTP_Hold2 MTP_Hold3 MTP_Hold4 MTP_Hold5 
	
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'2');
	//alertShow(plist)
	result=result.replace(/\\n/g,"\n")
	if (result<0)
	{
		alertShow(t[result]+"  "+t[-3001]);
		return
	}
	else 
	{
		location.reload();
	}
}
function BDelete_Click() 
{
	var truthBeTold = window.confirm(t["-4003"]);//add by jyp 2018-02-26 546004
	if (!truthBeTold) return;                    //add by jyp 2018-02-26 546004
	var rowid=GetElementValue("MTPRowID");
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return	;
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result>0)
	{
		location.reload();
		
	}
	else if(result=-1)
	{
		alertShow("删除操作失败.本次维修配件如需修改请与配件管理员联系.");
	}
	else
	{
		alertShow(t[-3001]);
	}
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var Status=GetElementValue("Status");
	if (Status!=1) return;
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMMaintPart');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	
	if (SelectedRow==selectrow)
	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("MTPRowID","");
		if (GetChkElementValue("Chk")) SetChkElement("Chk","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TMTPRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}
function Clear()
{
	SetElement("MTPRowID","")
	SetElement("Accessory",""); 
	SetElement("MTPQuantityNum","");
	SetElement("MTPPriceFee","");
	SetElement("MTPTotalFee","");
	SetElement("MTPRemark","");
	SetElement("MTPManufacturer","");
	SetElement("MTPProvider","");
	SetElement("MTPModel","");
	SetElement("MTPProviderDR","");
	SetElement("MTPManufacturerDR","");
	SetElement("AccessoryDR","");
	SetElement("InvoiceNos","");
	SetElement("MTPHold1","");		//库存数	Mozy	572335	201-3-16
	//SetChkElement("Chk","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	var sort=26;
	//alertShow(gbldata)
	SetElement("MTPRowID",list[0]); 
	SetElement("MTPMaintDR",list[1]); 
	SetElement("AccessoryDR",list[2]); 
	//SetElement("Accessory",list[sort+0]);
	SetElement("MTPQuantityNum",list[3]);
	SetElement("MTPPriceFee",list[4]);	//SetElement("MTPPriceFee",list[sort+7]);   //add by mwz 20180320 需求号542809		//Mozy	572345	201-3-26	修正
	SetElement("MTPTotalFee",list[5]);
	SetElement("MTPRemark",list[6]);
	SetElement("MTPStoreRoomDR",list[7]);
	SetElement("MTPFeeFlag",list[8]);
	SetElement("MaintRequestDR",list[9]);
	SetElement("AccessoryTypeDR",list[10]);
	SetElement("AccessoryType",list[sort+5]);
	SetElement("ASMLRowID",list[11]);
	if (list[12]=="Y")
	{
		SetElement("Chk",1);
	}
	else
	{
		SetElement("Chk",0);
	}
	SetElement("StockDetailDR",list[13]);
	SetElement("MTPModel",list[14]);
	SetElement("MTPManufacturerDR",list[15]);
	SetElement("MTPManufacturer",list[sort+3]);
	SetElement("MTPProviderDR",list[16]);
	SetElement("MTPProvider",list[sort+4]);
	SetElement("MaintItemDR",list[17]);
	SetElement("AISListDR",list[18]);
	SetElement("Accessory",list[19]);
	SetElement("InvoiceNos",list[20]);
	SetElement("CanUseNum",list[sort+6]);
	SetElement("MTPHold1",list[21]);		//库存数	Mozy	572335	201-3-16
}
function disabled(value)//灰化
{
	InitEvent();
	var Status=GetElementValue("Status");
	if (Status==1)
	{
		DisableBElement("BUpdate",value);
	    DisableBElement("BDelete",value);
	    DisableBElement("BAdd",!value);
	    DisableBElement("BConfirm",!value);
	    DisableBElement("BCancelConfirm",!value);
	    DisableBElement("BSubmitManage",!value);
	    DisableBElement("BCancelManage",!value);
	}
	else
	{
		DisableBElement("BUpdate",true);
	    DisableBElement("BDelete",true);
	    DisableBElement("BAdd",true);
	    DisableBElement("BConfirm",true);
	    DisableBElement("BCancelConfirm",true);
	    DisableBElement("BSubmitManage",true);
	    DisableBElement("BCancelManage",true);
	}
	if (GetElementValue("Chk"))
	{
		DisableElement("MTPModel",false);
		DisableElement("MTPProvider",false);
	    DisableElement("MTPManufacturer",false);
	    DisableElement("InvoiceNos",false);
	    DisableElement("MTPPriceFee",false);
	    var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPProvider");
		if (obj) imgId.style.visibility ="visible";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPManufacturer");
		if (obj) imgId.style.visibility ="visible";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iAccessory"); //add by mwz 需求号543259
		if (obj) imgId.style.visibility ="hidden";
	}
	else
	{
		DisableElement("MTPModel",true);
		DisableElement("MTPProvider",true);
	    DisableElement("MTPManufacturer",true);
	    DisableElement("InvoiceNos",true);
	    DisableElement("MTPPriceFee",true);
	    var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPProvider");
		if (obj) imgId.style.visibility ="hidden";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPManufacturer");
		if (obj) imgId.style.visibility ="hidden";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iAccessory");   //add by mwz 需求号543259
		if (obj) imgId.style.visibility ="visible";
	}
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function MTPTotalFee_Change()
{
	var Originalfee=GetElementValue("MTPPriceFee");
	if (Originalfee=="") Originalfee=0
	Originalfee=parseFloat(Originalfee);
	var QuantityNum=GetElementValue("MTPQuantityNum")*1;
	if (QuantityNum=="") QuantityNum=0
	//判断数量是否数值及是否在可用数量范围内
	if (isNaN(QuantityNum)||(QuantityNum<=0))
	{
		alertShow("数量输入有误,请检查!")
		SetElement("MTPQuantityNum","");
		SetElement("MTPTotalFee","");
		return
	}
	var CanUseNum=GetElementValue("CanUseNum")*1;
	if ((QuantityNum>CanUseNum)&&(!GetChkElementValue("Chk")))
	{
		alertShow("最大可用数量为"+CanUseNum);
		SetElement("MTPQuantityNum","");
		SetElement("MTPTotalFee","");
		return
	}
	QuantityNum=parseFloat(QuantityNum);
	SetElement("MTPTotalFee", Originalfee*QuantityNum);	
}
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("MTPTotalFee"),1,1,0,1)==0)
	{
		alertShow("配件费用数据异常,请修正.");
		return true;
	}
	return false;
}
/*function AccessoryChange()
{
	SetElement('AccessoryDR',"");
	SetElement('MTPPriceFee',"");
	SetElement('TMTPTotalFee',"0");
	SetElement('MTPManufacturerDR',"");
	SetElement('MTPManufacturer',"");
	SetElement('MTPQuantityNum',"");
	SetElement('MTPModel',"");
	SetElement('MTPProviderDR',"");
	SetElement('MTPProvider',"");
	SetElement('CanUseNum',"");
	//MTPTotalFee_Change();
}*/
function GetAccessoryType(value)
{
	GetLookUpID('AccessoryTypeDR',value);
}

function Accessory_Click()
{
	var Chk=GetElementValue("Chk");
	if (Chk)
	{
		//LookUp("","web.DHCEQCAccessory:GetAccessory","GetAccessoryNew",",,,AccessoryTypeDR,,,,Accessory");
	}
	else
	{
		LookUp("","web.DHCEQAReduce:GetAStockDetailNew","GetAccessory",",,AccessoryTypeDR,Accessory,vFlag,ChangeType,MTPRowID,MTPProviderDR");
	}
} 
function GetProvider(value)
{
	var val=value.split("^");
	SetElement("MTPProviderDR",val[1]);
}
function GetManuFactory(value)
{
	var val=value.split("^");
	SetElement("MTPManufacturerDR",val[1]);
}
function Chk_Clicked()
{
	Clear();
	DisableBElement("BUpdate",true);
	DisableBElement("BDelete",true);
	if (GetElementValue("Chk"))
	{
		DisableElement("MTPPriceFee",false);
		DisableElement("MTPModel",false);
		DisableElement("MTPProvider",false);
	    DisableElement("MTPManufacturer",false);
	    DisableElement("InvoiceNos",false);
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPProvider");
		if (imgId) imgId.style.visibility ="visible";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPManufacturer");
		if (imgId) imgId.style.visibility ="visible";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iAccessory");  //add by mwz 需求号543259
		if (obj) imgId.style.visibility ="hidden";
		
	}
	else
	{
		DisableElement("MTPPriceFee",true);
		DisableElement("MTPModel",true);
		DisableElement("MTPProvider",true);
	    DisableElement("MTPManufacturer",true);
	    DisableElement("InvoiceNos",true);
	    var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPProvider");
		if (imgId) imgId.style.visibility ="hidden";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPManufacturer");
		if (imgId) imgId.style.visibility ="hidden";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iAccessory");   //add by mwz 需求号543259
		if (obj) imgId.style.visibility ="visible";
	}
}
function BConfirm_Click()
{
	var encmeth=GetElementValue("ConfirmMaintPart");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("MaintRequestDR"));
	if (result==0)
	{
		alertShow("提交成功,待科室配件确认.请等待!");
		location.reload();
	}
	else
	{
		alertShow("提交失败!   "+result);
	}
}
function BCancelConfirm_Click()
{
	var encmeth=GetElementValue("CancelConfirmMaintPart");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("MaintRequestDR"));
	if (result>0)
	{
		alertShow("取消成功!");
		location.reload();
	}
	else
	{
		alertShow("取消失败!   "+result);
	}
}
function BSubmitManage_Click()
{
	var Objtbl=document.getElementById('tDHCEQMMaintPart');
	var Rows=Objtbl.rows.length;
	if (Rows==1)
	{
		alertShow("无消耗配件记录,未能提交成功!");
		return;
	}
	var flag=0;
	for (var i=1;i<Rows;i++)
	{
		var obj=document.getElementById("TMTPPriceFeez"+i)
		if(obj)
		{
			if ((GetElementValue("TMTPPriceFeez"+i)=="0.00")&&(GetElementValue("TChkz"+i)=="Y"))
			{
				alertShow("请填写核对配件( "+GetElementValue("TMTPAccessoryz"+i)+ " )价格!!!");
				return;
			}
		}
		var obj=document.getElementById("TMTPProviderz"+i)
		if(obj)
		{
			if ((GetElementValue("TMTPProviderDRz"+i)=="")&&(GetElementValue("TChkz"+i)=="Y"))
			{
				alertShow("请填写核对配件( "+GetElementValue("TMTPAccessoryz"+i)+ " )供应商!!!");
				return;
			}
		}
		var obj=document.getElementById("TInvoiceNosz"+i)
		if(obj)
		{
			//alertShow(obj.innerText)
			//alertShow(obj.innerHTML)
			if ((obj.innerHTML=="&nbsp;")&&(GetElementValue("TChkz"+i)=="Y"))
			{
				alertShow("请填写核对配件( "+GetElementValue("TMTPAccessoryz"+i)+ " )发票号!!!");
				return;
			}
		}
	}
	/// Mozy 判断是否打印过单据
	var encmeth=GetElementValue("CheckBussPrint");
	if (encmeth=="") return;
	//alertShow(GetElementValue("MaintRequestDR"))
	var result=cspRunServerMethod(encmeth,GetElementValue("MaintRequestDR"));
	if (result!="")
	{
		alertShow("不能再次提交!!!\n\n"+result);
		return;
	}
	var CurUser=curUserID;
	var MaintPartStoreDR=GetElementValue("MaintPartStoreDR");
	var encmeth=GetElementValue("SubmitManage");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("MaintRequestDR"),MaintPartStoreDR,CurUser);	//;Mozy	默认取 SBLJCK-设备零件仓库的配件
	if (result>0)
	{
		alertShow("提交成功,配件管理部门待审核确认!");
		location.reload();
	}
	else
	{
		alertShow("提交失败!   "+result);
		return;    //add by mwz 20180228 需求号 543010
	}
}
function BCancelManage_Click()
{
	var Objtbl=document.getElementById('tDHCEQMMaintPart');
	var Rows=Objtbl.rows.length;
	if (Rows==1)
	{
		alertShow("无消耗配件记录,未能取消成功!");
		return;
	}
	var encmeth=GetElementValue("CancelManage");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("MaintRequestDR"));
	if (result==0)
	{
		alertShow("取消成功!");
		location.reload();
	}
	else
	{
		alertShow("取消失败!   "+result);
		return;  //add by mwz 20180228 需求号 543010
	}
}
//需求序号:	400702		Mozy	20170710
function Accessory_Change()
{
	//非待购配件需清空供应商信息
	if (!GetElementValue("Chk"))
	{
		SetElement("MTPProvider","");
		SetElement("MTPProviderDR","");
	}
}
/*
function Accessory_lookuphandler(e) {
	if (evtName=='Accessory') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var url='websys.lookup.csp';
		url += '?ID=d55520iAccessory&CONTEXT=Kweb.DHCEQAReduce:GetAStockDetail&TLUDESC='+encodeURI(t['Accessory']);
		url += "&TLUJSF=GetAccessory";
		var obj=document.getElementById('MTPHold5');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('AccessoryTypeDR');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('Accessory');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		var obj=document.getElementById('vFlag');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		var obj=document.getElementById('ChangeType');
		if (obj) url += "&P6=" + websys_escape(obj.value);
		var obj=document.getElementById('MaintRequestDR');
		if (obj) url += "&P7=" + websys_escape(obj.value);
		var obj=document.getElementById('MTPProviderDR');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		websys_lu(url,true,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('Accessory');
	if (obj) obj.onkeydown=Accessory_lookuphandler;
	var obj=document.getElementById('ld55520iAccessory');
	if (obj) obj.onclick=Accessory_lookuphandler;
	*/
document.body.onload = BodyLoadHandler;


