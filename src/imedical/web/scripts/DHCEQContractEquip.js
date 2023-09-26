function BodyLoadHandler() 
{	
	SetEvent();
	var obj=document.getElementById("Name");
	if (obj) obj.onchange=clear;

	SetBEnabled();
	InitUserInfo();
	KeyUp("Model^ManuFac");
	Muilt_LookUp("BuyPlan^Model^ManuFac^Name");
}
function SetEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	var obj=document.getElementById("BConfig");
	if (obj) obj.onclick=BConfig_Click;
	var obj=document.getElementById("BAffix");
	if (obj) obj.onclick=BAffix_Click;
	var obj=document.getElementById("BImportAffixConfig");
	if (obj) obj.onclick=BImportAffixConfig_Click;	
	var obj=document.getElementById("PriceFee");
	if (obj) obj.onchange=SetTotal;
	var obj=document.getElementById("QuantityNum");
	if (obj) obj.onchange=SetTotal;
	var obj=document.getElementById("BuyPlan");
	if (obj) obj.onchange=ClearPlan;
	var obj=document.getElementById(GetLookupName("Name"));
	if (obj) obj.onclick=Equip_Click;
}
function Equip_Click()
{
	var SelectType=GetElementValue("SelectEquipType");
	var BuyPlan=GetElementValue("BuyPlanDR");
	if ((SelectType=="1")&&(BuyPlan==""))
	{
		alertShow(t["05"]);
		return;
	}
	if (BuyPlan=="")
	{
		LookUpMasterItem("GetMasterItem",",,Name")
	}
	else
	{
		LookUpContractEquipSelectEquipByBuyPlan("GetOtherValue","BuyPlanDR")
	}
}
function GetMasterItem(value)
{
	list=value.split("^");
	SetElement("Name",list[0]);
	SetElement("ItemDR",list[1]);
	
}
function SetTotal()
{
	var PriceFee=GetElementValue("PriceFee")
	var QuantityNum=GetElementValue("QuantityNum")
	SetElement("TotalFee",PriceFee*QuantityNum)
}
function ClearPlan()
{
	SetElement("BuyPlanListDR","");
	SetElement("ItemDR","");
	SetElement("BuyPlanDR","")
	SetElement("Name","")
}
function clear()
{
	SetElement("BuyPlanListDR","");
	SetElement("ItemDR","");
	/*SetElement("ModelDR","");
	SetElement("Model","");
	SetElement("ManuFacDR","");
	SetElement("ManuFac","");
	SetElement("QuantityNum","");
	SetElement("PriceFee","");
	SetElement("TotalFee","");
	SetChkElement("TestFlag","0");*/
}

function BClose_Click() 
{
	window.close();
}
function BConfig_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractConfig&ContractListDR='+GetElementValue("RowID")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=650,height=450,left=120,top=0')
}
function BAffix_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractAffix&ContractListDR='+GetElementValue("RowID")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=560,left=120,top=0')
}
function BImportAffixConfig_Click()
{
	ImportAffixAndConfig();
}
function BAdd_Click() 
{
	if (CheckNull()) return;
	var Return=UpdateData("0");
	if (Return!=0)
	{
		alertShow(t[Return]+"  "+t["01"]);
	}
	else
	{
		SetContract();
		window.location.reload();
	}
}

function BUpdate_Click() 
{
	if (CheckNull()) return;
	var Return=UpdateData("1");
	if (Return!=0)
	{
		alertShow(t[Return]+"  "+t["01"]);
	}
	else
	{
		SetContract();
		window.location.reload();
	}
}

function BDelete_Click() 
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	
	var Return=UpdateData("2")
	if (Return!=0)
	{
		alertShow(t[Return]+"  "+t["01"]);
	}
	else
	{
		SetContract();
		window.location.reload();
	}
}
function SetContract()
{
	var BuyPlanDR=GetElementValue("ContractDR");
	var encemeth=GetElementValue("getFeeNum");
	var Return=cspRunServerMethod(encemeth,"","",BuyPlanDR,2);
	var ReturnList=Return.split("^");
	var obj=opener.document.getElementById("TotalFee");
	if (obj) obj.value=ReturnList[0];
	var obj=opener.document.getElementById("QuantityNum");
	if (obj) obj.value=ReturnList[1];
}
function UpdateData(AppType)
{
	var encmeth=GetElementValue("upd");
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ContractDR") ;
  	combindata=combindata+"^"+GetElementValue("Name") ;
  	combindata=combindata+"^"+GetElementValue("ModelDR") ;
  	combindata=combindata+"^"+GetElementValue("ManuFacDR") ;
  	combindata=combindata+"^"+GetChkElementValue("TestFlag") ;
  	combindata=combindata+"^"+GetElementValue("PriceFee") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("PriceFee")*GetElementValue("QuantityNum") //GetElementValue("TotalFee") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("ContractArriveDate") ;
  	combindata=combindata+"^"+GetElementValue("ArriveDate") ;
  	combindata=combindata+"^"+GetElementValue("ArriveQuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("CurrencyDR") ;
  	combindata=combindata+"^"+GetElementValue("BuyPlanListDR") ;
  	combindata=combindata+"^"+GetElementValue("ItemDR") ;
	user=curUserID;
	var Return=cspRunServerMethod(encmeth,"","",combindata,AppType,user)
	return Return
}
function CheckNull()
{
	if (CheckMustItemNull("BuyPlan")) return true;
	var SelectType=GetElementValue("SelectEquipType");
	var BuyPlan=GetElementValue("BuyPlanDR");
	if ((SelectType=="1")||(SelectType==""))
	{
		if (CheckItemNull(1,"BuyPlan")) return true;
	}
	if (BuyPlan!="")
	{
		if (CheckItemNull(2,"BuyPlanListDR","采购计划明细")) return true;
	}
	/*
	if (CheckItemNull(2,"Name")) return true;
	if (CheckItemNull(2,"QuantityNum")) return true;
	*/
	return false;
}

var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQContractEquip'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	SetEvent();
	if (selectrow==SelectedRow)
	{
		ValueClear("RowID^BuyPlan^BuyPlanListDR^BuyPlanDR^Name^ModelDR^Model^ManuFacDR^ManuFac^QuantityNum^PriceFee^TotalFee^Remark^ContractArriveDate^ArriveDate^ArriveQuantityNum");
		var obj=document.getElementById("TestFlag");
		if (obj) obj.checked=false;
		SelectedRow=0;
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BImportAffixConfig",true);
		DisableBElement("BConfig",true);
		DisableBElement("BAffix",true);
		var Status=GetElementValue("Status")
		if (Status==0)
		{
		DisableBElement("BAdd",false);}
		else
		{DisableBElement("BAdd",true);}
		return;
	}
	var Status=GetElementValue("Status")
	if (Status==0)
	{	
		DisableBElement("BUpdate",false);
		DisableBElement("BDelete",false);
		DisableBElement("BConfig",false);
		DisableBElement("BAffix",false);
		DisableBElement("BImportAffixConfig",false);
		DisableBElement("BAdd",true);
	}
	else
	{
		DisableBElement("BImportAffixConfig",true);
		DisableBElement("BConfig",false);
		DisableBElement("BAffix",false);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
	}
	FillData(selectrow);
	SelectedRow = selectrow;
}
function SetBuyPlanEnabled()
{
	var SelectType=GetElementValue("SelectEquipType");
	if (SelectType=="0")
	{
		DisableLookup("BuyPlan",true);
	}
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID)
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=18;
	SetElement("ContractDR",list[0]);
	//SetElement("Contract",list[sort+0]);
	SetElement("Name",list[1]);
	SetElement("ModelDR",list[2]);
	SetElement("Model",list[sort+1]);
	SetElement("ManuFacDR",list[3]);
	SetElement("ManuFac",list[sort+2]);
	SetChkElement("TestFlag",list[4]);
	SetElement("PriceFee",list[5]);
	SetElement("QuantityNum",list[6]);
	SetElement("TotalFee",list[7]);
	SetElement("Remark",list[8]);
	SetElement("ContractArriveDate",list[9]);
	SetElement("ArriveDate",list[10]);
	SetElement("ArriveQuantityNum",list[11]);
	SetElement("UpdateUserDR",list[12]);
	SetElement("UpdateUser",list[sort+3]);
	SetElement("UpdateDate",list[13]);
	SetElement("UpdateTime",list[14]);
	SetElement("CurrencyDR",list[15]);
	//SetElement("Currency",list[sort+4]);
	SetElement("BuyPlanListDR",list[16]);
	//SetElement("BuyPlanList",list[sort+5]);
	SetElement("BuyPlanDR",list[sort+6]);
	SetElement("BuyPlan",list[sort+7]);
	SetElement("ItemDR",list[17])
}
function ValueClear(Value)
{
	var value=Value.split("^");
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) {obj.value="";}
		else{
		//alertShow(value[i]);
		}
	}
}

function GetBuyPlan (value)
{
    GetLookUpID("BuyPlanDR",value);
}
function SetBEnabled()
{
	SetBuyPlanEnabled()
	var obj=document.getElementById("Status");
	var Status=obj.value;
	if (Status!=0)
		{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		DisableBElement("BImportAffixConfig",true);
		DisableBElement("BAffix",true);
		DisableBElement("BConfig",true);
		}

	if (Status==0)
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BImportAffixConfig",true);
		DisableBElement("BAffix",true);
		DisableBElement("BConfig",true);
		}	
}
function GetOtherValue(Value)
{
	var ReturnList=Value.split("^");
	SetElement("BuyPlanListDR",ReturnList[1]);
	SetElement("Name",ReturnList[0])
	SetOtherValue(ReturnList[1]);
}
function SetOtherValue(BuyPlanListDR)
{
	var encmeth=GetElementValue("getBPListDetail");
	var Return=cspRunServerMethod(encmeth,"","",BuyPlanListDR);
	ReturnList=Return.split("^");
	SetElement("ModelDR",ReturnList[0]);
	SetElement("Model",ReturnList[1]);
	SetElement("ManuFacDR",ReturnList[2]);
	SetElement("ManuFac",ReturnList[3]);
	SetElement("QuantityNum",ReturnList[4]);
	SetElement("PriceFee",ReturnList[5]);
	SetElement("TotalFee",ReturnList[6]);
	if (ReturnList[7]=="Y")
	{
		ReturnList[7]="1";
	}
	else
	{
		ReturnList[7]="0";
	}
	SetChkElement("TestFlag",ReturnList[7]);
	SetElement("CurrencyDR",ReturnList[8]);
	SetElement("ItemDR",ReturnList[9]);
}
function GetContractDR(BuyPlanListDR)
{
	var encmeth=GetElementValue("getContractDR");
	return cspRunServerMethod(encmeth,"","",BuyPlanListDR);
}
function GetModel(Value)
{
	GetLookUpID("ModelDR",Value);
}
function GetManuFac(Value)
{
	GetLookUpID("ManuFacDR",Value);
}

///导入附件内容和配置清单内容
function ImportAffixAndConfig()
{
	try 
	{
		var result=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCEQGetFileName','','')
  	 	if (result=="") return
   		var xlApp,xlsheet,xlBook
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.open(result);
		//xlsheet = xlBook.ActiveSheet;
		xlsheet = xlBook.Worksheets("SheBeiPeiZhi");
		var count=xlsheet.cells(2,2);
		if (count==""||count<1)
		{
			CloseExcel(xlBook,xlApp,xlsheet);
			return;
		}
		var i=0,data="",beginrow=0,endrow=0;
		var row=3;
		while(i<count)
		{
			row=row+2;
			beginrow=row;
			//alertShow(row)
			data=data+"^"+xlsheet.cells(row,2)+","+i+"_"+row;
			while(1)
			{
				row=row+1;
				if ("设备"==xlsheet.cells(row,1))
				{
					i++;
					endrow=row;
					break;
				}
				//@是结尾标记
				if (("@"==xlsheet.cells(row,1))||(row>500))
				{
					i=count;
					endrow=row;
					break;
				}
			}
			data=data+"_"+endrow;
			if (row>500) break;
		}
		if ((count>1)&&(data!=""))
		{
			//alertShow(data)
			data=data.substring(1);
			var result=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSelectList&OptionData='+data,'','',"dialogHeight:400px;dialogWidth:400px;center:yes;help:no;resizable:no;status:no;")
			if (!result||""==result) return;
			var list=result.split("_");
			beginrow=list[1];
			endrow=list[2];
		}
		for (i=Number(beginrow);i<=Number(endrow);i++)
		{
			//a 标记为配置内容?处理配置清单
			if ("a"==xlsheet.cells(i,1))
			{
				//以下是处理方法
				//ConfigVal=ConfigRowID^ContractListDR^ConfigItemDR^Value^Remark
				var ConfigVal=""
				ConfigVal=ConfigVal+"^"+GetElementValue("RowID");  //^ContractEquip
				ConfigVal=ConfigVal+"^" //+xlsheet.cells(i,'**');    //ConfigItemDR
				ConfigVal=ConfigVal+"^" //+xlsheet.cells(i,'**');    //Value
				ConfigVal=ConfigVal+"^"+GetExcelValue(xlsheet,i,2);    //Remark
				var encmeth=GetElementValue("InsertConfig");
				var result=cspRunServerMethod(encmeth,ConfigVal,"0");
				if (result<0)
				{
					alertShow(t['04']);
					return;
				}
			}
			//b 标记为附件内容?处理附件内容
			if ("b"==xlsheet.cells(i,1))
			{
				//以下是处理方法
				//val=AffixRowID^ContractListDR^AffixDR^AffixCatDR^PartSpec^PartModel^ManuFactoryDR^QuantityNum^ReceiverDR^LeaveFacNo^LeaveDate^PriceFee^Remark^CurrencyDR
				var AffixVal=""
				AffixVal=AffixVal+"^"+GetElementValue("RowID");   //^ContractEquip
				AffixVal=AffixVal+"^" //+xlsheet.cells(i,2);    //AffixDR
				AffixVal=AffixVal+"^" //+xlsheet.cells(i,'**');    //AffixCatDR
				AffixVal=AffixVal+"^"+GetExcelValue(xlsheet,i,3);    //PartSpec
				AffixVal=AffixVal+"^"+GetExcelValue(xlsheet,i,4);    //PartModel
				AffixVal=AffixVal+"^" //+xlsheet.cells(i,'**');    //ManuFactoryDR
				AffixVal=AffixVal+"^"+Number(GetExcelValue(xlsheet,i,5));    //QuantityNum
				AffixVal=AffixVal+"^" //+xlsheet.cells(i,'**');    //ReceiverDR
				AffixVal=AffixVal+"^"+GetExcelValue(xlsheet,i,6);    //LeaveFacNo
				AffixVal=AffixVal+"^"+GetExcelValue(xlsheet,i,7);    //LeaveDate
				AffixVal=AffixVal+"^"+Number(GetExcelValue(xlsheet,i,8));    //PriceFee
				AffixVal=AffixVal+"^"+GetExcelValue(xlsheet,i,2)+"  "+GetExcelValue(xlsheet,i,9);    //remark
				AffixVal=AffixVal+"^"//+xlsheet.cells(i,'**');    //CurrencyDR
				var encmeth=GetElementValue("InsertAffix");
				var result=cspRunServerMethod(encmeth,AffixVal,"0");
				if (result<0)
				{
					alertShow(t['04']);
					return;
				}
			}
		}
		CloseExcel(xlBook,xlApp,xlsheet);	
	} 
	catch(e)
	{
		if (e.number==-2146827284) return;
		CloseExcel(xlBook,xlApp,xlsheet);
		alertShow(e.message);
	}	
}

function CloseExcel(xlBook,xlApp,xlsheet)
{
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet.Quit;
	xlsheet=null;
}

document.body.onload = BodyLoadHandler;
