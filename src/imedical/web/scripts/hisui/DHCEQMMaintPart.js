var SelectedRow = -1;	//hisui改造：修改开始行号  Add By DJ 2018-10-12
var rowid=0;
function BodyLoadHandler() 
{
	KeyUp("Accessory^AccessoryType^MTPProvider^MTPManufacturer^MTPHold4Desc","N");	// MZY0118	2542893		2022-03-28
	$("#tDHCEQMMaintPart").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui改造：隐藏翻页条内容
    InitUserInfo(); //系统参数
    InitEvent();
	disabled(true);//灰化
	InitAccessory();	//Add by CZF0091 2020-09-25
	//刷新主窗口配件费及总费用
	//Modify by zx 2022-11-22 模态窗处理维修界面配件费
	//parent.$("#MROtherFee").val(getElementValue("GetTotalFee"));
	//parent.totalFee_Change();
	websys_showModal("options").mth(getElementValue("GetTotalFee"));
	//MTPTotalFee_Change();
	Muilt_LookUp("Accessory^AccessoryType^MTPProvider^MTPManufacturer^MTPAccessoryOriginal"); //Modify by zx 2020-02-27 BUG ZX0078
	// 2019-11-17	Mozy0232
	$("#MTChkFlag").click(function (e) {
		Clear();
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		if ($("#MTChkFlag").is(":checked"))
		{
			// 待购
			DisableElement("Accessory",true);
			DisableElement("AccessoryName",false);
			DisableElement("MTPPriceFee",false);
			DisableElement("MTPModel",false);
			DisableElement("MTPProvider",false);
		    DisableElement("MTPManufacturer",false);
		    DisableElement("InvoiceNos",false);
		    DisableElement("MTPHold4Desc",false);	// MZY0118	2542893		2022-03-28
		}
		else
		{
			DisableElement("Accessory",false);
			DisableElement("AccessoryName",true);
			DisableElement("MTPPriceFee",true);
			DisableElement("MTPModel",true);
			DisableElement("MTPProvider",true);
		    DisableElement("MTPManufacturer",true);
		    DisableElement("InvoiceNos",true);
		    DisableElement("MTPHold4Desc",true);	// MZY0118	2542893		2022-03-28
		}
	})
	//DisableElement("AccessoryName",true);	//modified by CZF0091 2020-03-09	
	DisableElement("GetTotalFee",true);
	document.getElementById("GetTotalFee").style.color="#ff8000";
	initButtonWidth();
	initButtonColor();
	initPanelHeaderStyle();
	$(".eq-toolborder").css("border-top","1px dashed #e2e2e2");
}

//add by CZF0091 2020-03-09
function InitAccessory()
{
	var AInputType=GetElementValue("GetAccessoryInputType");	//配件录入方式 0或空:手工录入配件,DHC-EQA:设备维修配件,DHC-STM:物资耗材库
	if((AInputType=="DHC-EQA"))
	{
		//singlelookup("AccessoryType","PLAT.L.AccessoryType",[{name:"AccessoryType",type:1,value:"AccessoryType"},{name:"GroupID",type:3,value:"LOGON.GROUPID"}],GetAccessoryType);
		//singlelookup("Accessory","MP.L.AInStock.AccessoryList",[{name:"Desc",type:1,value:"Accessory"},{name:"TypeDR",type:4,value:"AccessoryTypeDR"}],GetAccessory);
	}
	else if(AInputType=="DHC-STM")
	{
		singlelookup("AccessoryType","PLAT.L.STM.AccessoryType",[{name:"gLocId",type:3,value:"LOGON.CTLOCID"},{name:"AccessoryType",type:1,value:"AccessoryType"}],GetAccessoryTypeNew);
		singlelookup("Accessory","PLAT.L.STM.AccessoryList",[{name:"InciDesc",type:1,value:"Accessory"},{name:"AccesoryType",type:4,value:"AccessoryTypeDR"}],GetAccessoryNew);
		disableElement("MTChkFlag",true);
		DisableElement("AccessoryName",true);
		hiddenObj("cMTChkFlag",1);
		hiddenObj("BSubmitManage",1);
		hiddenObj("BCancelManage",1);
		$('input#MTChkFlag').next().css('display','none');		//czf 2021-04-21 1880158
	}
	else if((AInputType=="0")||(AInputType==""))
	{
		SetChkElement("MTChkFlag","Y");
		disableElement("MTChkFlag",true);
		hiddenObj("BSubmitManage",1);
		hiddenObj("BCancelManage",1);
		DisableElement("Accessory",true);
		DisableElement("AccessoryName",false);
		DisableElement("MTPPriceFee",false);
		DisableElement("MTPModel",false);
		DisableElement("MTPProvider",false);
	    DisableElement("MTPManufacturer",false);
	    DisableElement("InvoiceNos",false);
	    DisableElement("MTPHold4Desc",false);	// MZY0118	2542893		2022-03-28
	}
}

//add by CZF0091
//获取物资配件项
function GetAccessoryNew(Item)
{
	/*
	var Provider=Item.TProvider;
	var ProviderID=""
	if (Provider!="")
	{
		var val=GetPYCode(Provider)+"^"+Provider+"^^^2";
	 	var encmeth=GetElementValue("UpdProvider");
		var ProviderID=cspRunServerMethod(encmeth,val);
		if(ProviderID<=0)
		{
			alert("供应商登记失败");
			return
		}
	}
	var ManuFactory=Item.TManuFactory;
	var ManuFactoryID=""
	if(ManuFactory!="")
	{
		var val=GetPYCode(ManuFactory)+"^"+ManuFactory+"^^^3";
	 	var encmeth=GetElementValue("UpdProvider");
		var ManuFactoryID=cspRunServerMethod(encmeth,val);
		if(ManuFactoryID<=0)
		{
			alert("生产厂商登记失败");
			return
		}
	}
	*/
	SetElement('Accessory',Item.TDesc);
	SetElement('AccessoryDR',Item.TRowID);
	SetElement('MTPModel',Item.TModel);
	SetElement('MTPQuantityNum',Item.TNum);
	SetElement('MTPPriceFee',Item.TCurBPrice);
	SetElement('MTPProviderDR',Item.TProviderDR);
	SetElement('MTPProvider',Item.TProvider);
	SetElement('MTPManufacturerDR',Item.TManuFactoryDR);
	SetElement('MTPManufacturer',Item.TManuFactory);
	// MZY0118	2542893		2022-03-28
	//SetElement('MTPHold4',Item.TBaseUOM);
	//SetElement('MTPHold4Desc',Item.BUomDesc);
	MTPTotalFee_Change();
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
	var obj=document.getElementById("MTPQuantityNum");
	if (obj) obj.onchange=MTPTotalFee_Change;
	var obj=document.getElementById("MTPPriceFee");
	if (obj) obj.onchange=MTPTotalFee_Change;
	// 2019-11-17	Mozy0232
	//var obj=document.getElementById(GetLookupName("Accessory"));
	//if (obj) obj.onclick=Accessory_Click;
	//需求序号:	400702		Mozy	20170710
	var obj=document.getElementById("Accessory");
	if (obj) obj.onchange=Accessory_Change;
	// MZY0118	2542893		2022-03-28
	var obj=document.getElementById("MTPHold4Desc");
	if (obj) obj.onchange=MTPHold4Desc_Change;
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
	//SetElement("MTPHold1",list[22]);	//Modify by zx 2020-02-27 BUG ZX0078 库存数处理去掉
	SetElement('CanUseNum',list[23]);
	SetElement('InvoiceNos',list[44]); //add by jyp 2018-02-26 546653
	SetElement('SerialNo',list[32]); //czf 1877905 20210512
	SetElement('MTPHold4',list[5]);		// MZY0118	2542893		2022-03-28
	SetElement('MTPHold4Desc',list[34]);
	MTPTotalFee_Change();
}
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
	//messageShow("","","",result+":"+plist)
	result=result.replace(/\\n/g,"\n")
	if (result<0)
	{
		messageShow("","","",result+"   "+t[result]);	//Mozy	2018-3-21	567544	调整错误输出显示
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
  	if (GetChkElementValue("MTChkFlag"))
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
	combindata=combindata+"^"+GetElementValue("MTPOfferPrice");		//Modify by zx BUG ZX0078 改为报价
	combindata=combindata+"^"+GetElementValue("MTPAccessoryOriginalDR");  //Modify by zx BUG ZX0078
	combindata=combindata+"^"+GetElementValue("MTPHold3");
	combindata=combindata+"^"+GetElementValue("MTPHold4");
	combindata=combindata+"^"+GetElementValue("MTPHold5");
	combindata=combindata+"^"+GetElementValue("AccessoryName");
	
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
	//messageShow("","","",plist)
	result=result.replace(/\\n/g,"\n")
	if (result<0)
	{
		messageShow("","","",t[result]+"  "+t[-3001]);
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
	var MTPRowID=getElementValue("MTPRowID");
	var encmeth=getElementValue("GetUpdate");
	if (encmeth=="") return	;
	var result=cspRunServerMethod(encmeth,MTPRowID,'1');
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
		messageShow("","","",t[-3001]);
	}
}
///选择表格行触发此方法
function SelectRowHandler(index,rowdata)
{
	var Status=GetElementValue("Status");
	var MaintType=GetElementValue("MaintType");		//modified by CZF0075 2020-02-20
	//if ((MaintType!=1)&&(Status!=1)) return;
	if (index==SelectedRow)
	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=-1;
		SetChkElement("MTChkFlag","");
		//MTChkFlag_Clicked(true,"0")	// 2019-11-17	Mozy0232
		$('#tDHCEQMMaintPart').datagrid('unselectAll'); 
		return; 
	}
	SelectedRow=index;
	SetData(rowdata.TMTPRowID);//调用函数
	disabled(false);//反灰化
}
function Clear()
{
	SetElement("MTPRowID","")
	SetElement("Accessory","");
	SetElement("AccessoryName","");	// 2019-11-17	Mozy0232
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
	SetElement("MTPOfferPrice","");		//Modify by zx 2020-02-27 BUG ZX0078 报价
	// 2019-11-17	Mozy0232
	SetElement("StockDetailDR","");
	if (GetElementValue("GetAccessoryInputType")=="DHC-STM")
	{
		SetElement("AccessoryType","");
		SetElement("AccessoryTypeDR","");
	}
	else
	{
		SetElement("AccessoryType",tkMakeServerCall("web.DHCEQACommon","GetDefaultAccessoryType",2));
		SetElement("AccessoryTypeDR",tkMakeServerCall("web.DHCEQACommon","GetDefaultAccessoryType",1));
	}
	SetElement("MTPAccessoryOriginalDR",""); //Modify by zx 2020-02-27 BUG ZX0078 配件来源
	SetElement("MTPAccessoryOriginal","");
	SetElement("SerialNo","");		// MZY0080	1943178		2021-06-03
	
	// MZY0103	2324463		2021-12-06
	SetElement("MTPMaintDR","");
	SetElement("MTPStoreRoomDR","");
	SetElement("MTPFeeFlag","");
  	SetElement("ASMLRowID","");
  	SetElement("AISListDR","");
	SetElement("MaintItemDR","");
  	SetElement("MTPHold3","");
	SetElement("MTPHold4","");
	SetElement("MTPHold4Desc","");		// MZY0118	2542893		2022-03-28
	SetElement("MTPHold5","");
}
function SetData(rowid)
{
	var encmeth=getElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	var sort=29; //Modify by zx 2020-02-27 BUG ZX0078
	//messageShow("","","",gbldata)
	SetChkElement("MTChkFlag",list[12]);	// 2019-11-17	Mozy0232
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
	SetElement("AccessoryType",list[sort+6]);  //modified by wy 2023-3-3 3327258 begin
	SetElement("ASMLRowID",list[11]);
	SetElement("StockDetailDR",list[13]);
	SetElement("MTPModel",list[14]);
	SetElement("MTPManufacturerDR",list[15]);
	SetElement("MTPManufacturer",list[sort+4]);
	SetElement("MTPProviderDR",list[16]);
	SetElement("MTPProvider",list[sort+5]);  //modified by wy 2023-3-3  3327258 end
	SetElement("MaintItemDR",list[17]);
	SetElement("AISListDR",list[18]);
	// 2019-11-17	Mozy0232
	if (list[12]=="N")
	{
		SetElement("Accessory",list[19]);
	}
	else
	{
		SetElement("AccessoryName",list[19]);
	}
	SetElement("InvoiceNos",list[20]);
	SetElement("CanUseNum",list[sort+6]);
	SetElement("MTPOfferPrice",list[21]);		//Modify by zx 2020-02-27 BUG ZX0078 报价
	SetElement("MTPAccessoryOriginalDR",list[22]); //Modify by zx 2020-02-27 BUG ZX0078 配件来源
	SetElement("MTPAccessoryOriginal",list[sort+7]);
	SetElement("SerialNo",list[sort+8]);		// MZY0080	1943178		2021-06-03
	// MZY0118	2542893		2022-03-28
	SetElement("MTPHold4",list[24]);
	SetElement("MTPHold4Desc",list[sort+9])
}
function disabled(value)//灰化
{
	InitEvent();
	var Status=getElementValue("Status");
	var MaintType=getElementValue("MaintType"); 	//add by CZF0075
	// MZY0080	1891466		2021-06-03
	if (GetElementValue("ReadOnly")=="Y")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		DisableBElement("BCancelConfirm",true);
	    DisableBElement("BSubmitManage",true);
	    DisableBElement("BCancelManage",true);
	}
	else if (Status==1)
	{
		disableElement("BUpdate",value);
	    disableElement("BDelete",value);
	    disableElement("BAdd",!value);
	    disableElement("BConfirm",!value);
	    disableElement("BCancelConfirm",!value);
	    disableElement("BSubmitManage",!value);
	    disableElement("BCancelManage",!value);
	}
	else
	{
		if (MaintType!=1)					//add by CZF0075 begin
		{
			disableElement("BUpdate",true);
		    disableElement("BDelete",true);
		    disableElement("BAdd",true);
		    disableElement("BConfirm",true);
		    disableElement("BCancelConfirm",true);
		    disableElement("BSubmitManage",true);
		    disableElement("BCancelManage",true);
		}
		else
		{
			var MaintRequestDR=getElementValue("MaintRequestDR");
			if ((Status=="")||(Status==2)||(MaintRequestDR==""))
			{
				disableElement("BUpdate",true);
			    disableElement("BDelete",true);
			    disableElement("BAdd",true);
			    disableElement("BConfirm",true);
			    disableElement("BCancelConfirm",true);
			    disableElement("BSubmitManage",true);
			    disableElement("BCancelManage",true);
			}
			if ((Status==0)&&(MaintRequestDR!=""))
			{
				disableElement("BUpdate",value);
			    disableElement("BDelete",value);
			    disableElement("BAdd",!value);
			    disableElement("BConfirm",!value);
			    disableElement("BCancelConfirm",!value);
			    disableElement("BSubmitManage",!value);
			    disableElement("BCancelManage",!value);		//add by CZF0075 end
			}
		}
		
	}
	if (getElementValue("MTChkFlag"))
	{
		disableElement("MTPModel",false);
		disableElement("MTPProvider",false);
	    disableElement("MTPManufacturer",false);
	    disableElement("InvoiceNos",false);
	    disableElement("MTPPriceFee",false);
	    /*// 2019-11-17	Mozy0232
	    var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPProvider");
		if (imgId) imgId.style.visibility ="visible";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPManufacturer");
		if (imgId) imgId.style.visibility ="visible";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iAccessory"); //add by mwz 需求号543259
		if (imgId) imgId.style.visibility ="hidden";*/
	}
	else
	{
		disableElement("MTPModel",true);
		disableElement("MTPProvider",true);
	    disableElement("MTPManufacturer",true);
	    disableElement("InvoiceNos",true);
	    disableElement("MTPHold4Desc",true);	// MZY0118	2542893		2022-03-28
	    if (GetElementValue("GetAccessoryInputType")=="DHC-STM")
	    {
	    	disableElement("MTPPriceFee",false);    
		}
		else  disableElement("MTPPriceFee",true);
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
	if ((QuantityNum>CanUseNum)&&(!GetChkElementValue("MTChkFlag"))&&(GetElementValue("GetAccessoryInputType")!="DHC-STM"))		//czf 2020-09-25
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
function GetAccessoryType(value)
{
	//SetElement("AccessoryType",Item.TName);
	//SetElement("AccessoryTypeDR",Item.TRowID);
	GetLookUpID('AccessoryTypeDR',value);
}

//add by czf 2020-09-25
function GetAccessoryTypeNew(Item)
{
	SetElement("AccessoryType",Item.TName);
	SetElement("AccessoryTypeDR",Item.TRowID);
}
/* 2019-11-17	Mozy0232
function Accessory_Click()
{
	var MTChkFlag=GetElementValue("MTChkFlag");
	if (MTChkFlag)
	{
		//LookUp("","web.DHCEQCAccessory:GetAccessory","GetAccessoryNew",",,,AccessoryTypeDR,,,,Accessory");
	}
	else
	{
		LookUp("","web.DHCEQAReduce:GetAStockDetailNew","GetAccessory",",,AccessoryTypeDR,Accessory,vFlag,ChangeType,MTPRowID,MTPProviderDR");
	}
}*/
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
/* 2019-11-17	Mozy0232
function MTChkFlag_Clicked(value,flag)
{
	var MTPRowID=getElementValue("MTPRowID")
	if (MTPRowID=="")
	{
		Clear();
		disableElement("BUpdate",true);
		disableElement("BDelete",true);
	}
	else
	{
		Clear();
		SetElement("MTPRowID",MTPRowID);
	}
	if (!value)
	{
		disableElement("MTPPriceFee",false);
		disableElement("MTPModel",false);
		disableElement("MTPProvider",false);
	    disableElement("MTPManufacturer",false);
	    disableElement("InvoiceNos",false);
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPProvider");
		if (imgId) imgId.style.visibility ="visible";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPManufacturer");
		if (imgId) imgId.style.visibility ="visible";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iAccessory");  //add by mwz 需求号543259
		if (imgId) imgId.style.visibility ="hidden";
	}
	else
	{
		disableElement("MTPPriceFee",true);
		disableElement("MTPModel",true);
		disableElement("MTPProvider",true);
	    disableElement("MTPManufacturer",true);
	    disableElement("InvoiceNos",true);
	    var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPProvider");
		if (imgId) imgId.style.visibility ="hidden";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iMTPManufacturer");
		if (imgId) imgId.style.visibility ="hidden";
		var imgId = document.getElementById("ld"+GetElementValue("GetComponentID")+"iAccessory");   //add by mwz 需求号543259
		if (imgId) imgId.style.visibility ="visible";
	}
	setElement("ChkFlag","")
	if ((getElementValue("MTChkFlag")==false)&&(flag=="1"))
	{
		setElement("ChkFlag","Y")
	}
}*/
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
	// MZY0039		1416082		2020-7-20	修正获取配件记录数方式
	//var rows = $("#tDHCEQMMaintPart").datagrid('getRows');
	//var Rows=rows.length;
	//var Objtbl=document.getElementById('tDHCEQMMaintPart');
	//var Rows=Objtbl.rows.length;
	// MZY0046	1467448		2020-8-17
	var Rows=tkMakeServerCall("web.DHCEQM.DHCEQMMaintPart","GetMaintPartNum");
	if (Rows==0)
	{
		alertShow("无消耗配件记录,未能提交成功!");
		return;
	}
	//var flag=0;	// 2019-11-17	Mozy0232
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
			//messageShow("","","",obj.innerText)
			//messageShow("","","",obj.innerHTML)
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
	//messageShow("","","",GetElementValue("MaintRequestDR"))
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
	// MZY0039		1416082		2020-7-20	修正获取配件记录数方式
	//var rows = $("#tDHCEQMMaintPart").datagrid('getRows');
	//var Rows=rows.length;
	//var Objtbl=document.getElementById('tDHCEQMMaintPart');
	//var Rows=Objtbl.rows.length;
	if (tkMakeServerCall("web.DHCEQM.DHCEQMMaintPart","GetMaintPartNum")==0)
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
	if (!GetElementValue("MTChkFlag"))
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
// Add by zx 2020-02-27 BUG ZX0078
// 配件来源DR赋值 
function GetAccessoryOriginal(value)
{
	var val=value.split("^");
	SetElement("MTPAccessoryOriginalDR",val[1]);
}
document.body.onload = BodyLoadHandler;

// MZY0118	2542893		2022-03-28
function GetUOM(value)
{
	var list=value.split("^");
	SetElement('MTPHold4Desc',list[0]);
	SetElement('MTPHold4',list[1]);
}
function MTPHold4Desc_Change()
{
	SetElement("MTPHold4Desc","");
	SetElement("MTPHold4","");
}
