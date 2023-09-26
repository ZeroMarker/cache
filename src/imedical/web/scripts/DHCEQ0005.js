function BPrint1_Clicked()
{
	UserDefinedPrint("DHCEQ0005","DHCEQBenefitAnaly.xls")
}
function OtherSet()
{
	var obj=document.getElementById("E_FeeScale");
	if (obj) obj.onchange=AllInCome_Change;
	var obj=document.getElementById("E_PersonPerYear");
	if (obj) obj.onchange=AllInCome_Change;
	var obj=document.getElementById("E_FeePerPerson");
	if (obj) obj.onchange=AllInCome_Change;
	var obj=document.getElementById("E_InvestFee");
	if (obj) obj.onchange=AllInvest_Change;
	var obj=document.getElementById("E_BInvestFee");
	if (obj) obj.onchange=AllInvest_Change;
	var obj=document.getElementById("E_FHInvestFee");
	if (obj) obj.onchange=AllInvest_Change;
	var obj=document.getElementById("E_LimitYearsNum");
	if (obj) obj.onchange=AllInvest_Change;
	var obj=document.getElementById("E_Area");
	if (obj) obj.onchange=AllInvest_Change;
	var obj=document.getElementById("E_PersonsNum");
	if (obj) obj.onchange=WagesAndWelFare_Change;
	var obj=document.getElementById("E_MaintFee");
	if (obj) obj.onchange=OperationCost_Change;
	var obj=document.getElementById("E_OtherFee");
	if (obj) obj.onchange=OperationCost_Change;

}

function AllInCome_Change()
{
	var FeeScale=GetElementValue("E_FeeScale")*1;
	var PersonPerYear=GetElementValue("E_PersonPerYear")*1;
	var FeePerPerson=GetElementValue("E_FeePerPerson")*1;
	var AllIncome=(FeeScale*PersonPerYear)/10000
	var MedicUsed=(PersonPerYear*FeePerPerson)/10000
	AllIncome=AllIncome.toFixed(2);
	MedicUsed=MedicUsed.toFixed(2);
	SetElement("E_AllIncome",AllIncome);
	SetElement("E_MedicUsed",MedicUsed);
	OperationCost_Change();
}

function AllInvest_Change()
{
	var InvestFee=GetElementValue("E_InvestFee")*1;
	var BInvestFee=GetElementValue("E_BInvestFee")*1;
	var FHInvestFee=GetElementValue("E_FHInvestFee")*1;
	var LimitYearsNum=GetElementValue("E_LimitYearsNum")*1;
	var Area=GetElementValue("E_Area")*1;
	var AllInvest=InvestFee+BInvestFee+FHInvestFee;
	var DepreFee=InvestFee/LimitYearsNum;
	var AreaFee=((Area*3000)/LimitYearsNum)/10000
	AllInvest=AllInvest.toFixed(2);
	DepreFee=DepreFee.toFixed(2);
	AreaFee=AreaFee.toFixed(2);
	SetElement("E_AllInvest",AllInvest);
	SetElement("E_DepreFee",DepreFee);
	SetElement("E_AreaFee",AreaFee);
	OperationCost_Change();
}

function WagesAndWelFare_Change()
{
	var PersonsNum=GetElementValue("E_PersonsNum")*1;
	var AvgWagesAndWelFare=GetElementValue("E_AvgWagesAndWelFare")*1;
	WagesAndWelFare=PersonsNum*AvgWagesAndWelFare
	WagesAndWelFare=WagesAndWelFare.toFixed(2);
	SetElement("E_WagesAndWelFare",WagesAndWelFare);
	OperationCost_Change();
}

function OperationCost_Change()
{
	var MedicUsed=GetElementValue("E_MedicUsed")*1
	var WagesAndWelFare=GetElementValue("E_WagesAndWelFare")*1
	var DepreFee=GetElementValue("E_DepreFee")*1
	var ManageFee=GetElementValue("E_ManageFee")*1
	var MaintFee=GetElementValue("E_MaintFee")*1
	var AreaFee=GetElementValue("E_AreaFee")*1
	var OtherFee=GetElementValue("E_OtherFee")*1
	var OperationCost=MedicUsed+WagesAndWelFare+DepreFee+ManageFee+MaintFee+AreaFee+OtherFee;
	OperationCost=OperationCost.toFixed(2);
	SetElement("E_OperationCost",OperationCost);
	var AllIncome=GetElementValue("E_AllIncome")*1;
	var BenefitFee=AllIncome-OperationCost;
	BenefitFee=BenefitFee.toFixed(2);
	SetElement("E_BenefitFee",BenefitFee);
	var NetCashFlow=BenefitFee*1+DepreFee*1;
	NetCashFlow=NetCashFlow.toFixed(2);
	SetElement("E_NetCashFlow",NetCashFlow);
	var AllInvest=GetElementValue("E_AllInvest")*1;
	var InvestPayBack=(AllInvest*1)/NetCashFlow;
	InvestPayBack=InvestPayBack.toFixed(2);
	SetElement("E_InvestPayBack",InvestPayBack);
}

function CheckData()
{
	var Str="E_FeeScale^E_PersonPerYear^E_FeePerPerson^E_Area^E_PersonsNum^E_AvgWagesAndWelFare^E_LimitYearsNum^E_InvestFee^E_BInvestFee^E_FHInvestFee^E_MedicUsed^E_WagesAndWelFare^E_ManageFee^E_MaintFee^E_OtherFee"
	var Filed=Str.split("^")
	for(var i=0;i<Filed.length;i++)
	{
		var FiledName=Filed[i]
		var Obj=document.getElementById(FiledName);
		if (Obj)
		{
			var FiledValue=Obj.value
			var FiledDesc=GetElementValue("c"+FiledName)
			if (FiledValue!="")
			{
				if (isNaN(FiledValue)||(FiledValue<=0))
				{
					alertShow("["+FiledDesc+"]录入有误!")
					return 1
				}
				if ((FiledName=="E_PersonPerYear")||(FiledName=="E_PersonsNum")||(FiledName=="E_LimitYearsNum"))
				{
					FiledValue=FiledValue*1
					var IntFiledValue=FiledValue.toFixed(0);
					if (FiledValue!=IntFiledValue)
					{
						alertShow("["+FiledDesc+"]只能录入整数!")
						return 1
					}
				}
			}
		}
	}
	//
	AllInCome_Change();
	AllInvest_Change();
	WagesAndWelFare_Change();
	return 0
}