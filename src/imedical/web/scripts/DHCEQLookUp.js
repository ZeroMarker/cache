//设备对照类型表	Mzy0018	2009-07-21
function LookUpOpenCheckSelectEquipByContract(jsfunction,paras)
{
	LookUp("","web.DHCEQOpenCheck:GetContractList",jsfunction,paras);
}
function LookUpContractEquipSelectEquipByBuyPlan(jsfunction,paras)
{
	LookUp("","web.DHCEQContractList:GetBPList",jsfunction,paras);
}
function LookUpModel(jsfunction,paras)
{
	LookUp("","web.DHCEQCModel:GetModel",jsfunction,paras);
}
function LookUpEquipCat(jsfunction,paras)
{
	LookUp("","web.DHCEQCEquipeCat:LookUp",jsfunction,paras);
}
function LookUpManuFactory(jsfunction,paras)
{
	LookUp("","web.DHCEQCManufacturer:LookUp",jsfunction,paras);
}
function LookUpReturnReason(jsfunction,paras)
{
	LookUp("","web.DHCEQCReturnReason:LookUp",jsfunction,paras);
}
function LookUpUnit(jsfunction,paras)
{
	LookUp("","web.DHCEQCUOM:GetUOM",jsfunction,paras);
}
function LookUpMasterItem(jsfunction,paras)
{
	LookUp("","web.DHCEQCMasterItem:GetMasterItem",jsfunction,paras);
}
//Mozy 2009-03-30
function LookUpMasterItemForXY2(jsfunction,paras)
{
	LookUp("","web.DHCEQCMasterItem:GetMasterItemForXY2",jsfunction,paras);
}
//Mzy0018 2009-07-21
function LookUpCTLoc(jsfunction,paras)
{
	LookUp("","web.DHCEQFind:GetEQLoc",jsfunction,paras);
}
//Mzy0018 2009-07-21
function LookUpCTCountry(jsfunction,paras)
{
	LookUp("","web.DHCEQFind:GetCountry",jsfunction,paras);
}

//Mozy 2010-02-26
function LookUpCTUser(jsfunction,paras)
{
	LookUp("","web.DHCEQFind:User",jsfunction,paras);
}
//Mozy 2010-02-26
function LookUpCTVendor(jsfunction,paras)
{
	LookUp("","web.DHCEQCVendor:GetVendor",jsfunction,paras);
}
//Mozy 2010-03-02
function LookUpCTUom(jsfunction,paras)
{
	LookUp("","web.DHCEQCUOM:Omdr",jsfunction,paras);
}
//Mozy 2010-03-02
function LookUpCTOrigin(jsfunction,paras)
{
	LookUp("","web.DHCEQCOrigin:LookUp",jsfunction,paras);
}
//Mozy 2010-03-02
function LookUpCTBuyType(jsfunction,paras)
{
	LookUp("","web.DHCEQCBuyType:LookUp",jsfunction,paras);
}

//Mozy 2010-03-13
function LookUpCTEquipCat(jsfunction,paras)
{
	LookUp("","web.DHCEQCEquipeCat:LookUp",jsfunction,paras);
}

//DJ 2013-07-16
function LookUpPurchaseType(jsfunction,paras)
{
	LookUp("","web.DHCEQCPurchaseType:LookUp",jsfunction,paras);
}

//DJ 2013-07-16
function LookUpPurposeType(jsfunction,paras)
{
	LookUp("","web.DHCEQCPurposeType:LookUp",jsfunction,paras);
}

//DJ 2013-07-16
function LookUpFundsType(jsfunction,paras)
{
	LookUp("","web.DHCEQFunds:FundsType",jsfunction,paras);
}

///Modified by jdl 2011-04-29
///修改传递的参数中,可以有值,如果传的是值,则需要用''表明
///例如paras为?RowID,'aa',Type?其中'aa'表示为值?
function LookUp(id,method,jsfunction,paras)
{
	var url='websys.lookup.csp';
	url += "?ID="+id;
	url += "&CONTEXT=K"+method;
	url += "&TLUJSF="+jsfunction;
	if (paras!="")
	{
		var list=paras.split(",");
		var i=0;
		for(i=0;i<list.length;i++)
		{
			
			if (list[i].indexOf("'")==0)
			{
				var parVal=list[i].substring(1,list[i].length-1);
				url += "&P"+(i+1)+"=" + websys_escape(trim(parVal));
			}
			else
			{
				var obj=document.getElementById(list[i]);
				if (obj)
				{
					if (obj.type=="checkbox")
					{
						url += "&P"+(i+1)+"=" + obj.checked;
					}
					else
					{
						url += "&P"+(i+1)+"=" + websys_escape(trim(obj.value));
					}
				}
			}
		}
	}
	websys_lu(url,1,'');
	return websys_cancel();
}
// add by csy 2017-07-21 CSY0006 begin 
function LookUpExpenditures(jsfunction,paras)
{
	LookUp("","web.DHCEQCExpenditures:GetExpenditures",jsfunction,paras);
}
// add by csy 2017-07-21 CSY0006 end