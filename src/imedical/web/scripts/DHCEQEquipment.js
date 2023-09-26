
function Equipment(RowID,Data)
{
	var encmeth=GetElementValue("GetEquipById");
	var result;
	if (Data!="")
	{	result=Data; }
	else
	{	result=cspRunServerMethod(encmeth,'','',RowID);	}
	
	if (result=="")
	{
		this.ID="";
		return;
	}
	//alertShow(result)
	result=result.replace(/\\n/g,"\n");
	var list=result.split("^");
	var sort=EquipGlobalLen;
	
	this.ID=RowID;
	this.Name=list[0];
	this.ABCType=list[1];
	this.ModelDR=list[2];
	this.Model=list[sort+0];
	this.EquiCatDR=list[3];
	this.EquiCat=list[sort+1];
	this.UnitDR=list[4];
	this.Unit=list[sort+2];
	this.Code=list[5];
	this.ItemDR=list[6];
	this.InstallLocDR=list[7];
	this.InstallLoc=list[sort+3];
	this.InstallDate=list[8];
	this.LeaveFactoryNo=list[9];
	this.LeaveFactoryDate=list[10];
	this.OpenCheckDate=list[11];
	this.CheckDate=list[12];
	this.MakeDate=list[13];
	this.ComputerFlag=list[14];
	this.CountryDR=list[15];
	this.Country=list[sort+4];
	this.ManageLocDR=list[16];
	this.ManageLoc=list[sort+5];
	this.ManageLevelDR=list[17];
	this.ManageLevel=list[sort+6];
	this.UseLocDR=list[18];
	this.UseLoc=list[sort+7];
	this.OriginDR=list[19];
	this.Origin=list[sort+8];
	this.FromDeptDR=list[20];
	this.FromDept=list[sort+9];
	this.ToDeptDR=list[21];
	this.ToDept=list[sort+10];
	this.BuyTypeDR=list[22];
	this.BuyType=list[sort+11];
	this.EquipTechLevelDR=list[23];
	this.ProviderDR=list[24];
	this.Provider=list[sort+12];
	this.ManuFactoryDR=list[25];
	this.ManuFactory=list[sort+13];
	this.OriginalFee=list[26];
	this.NetFee=list[27];
	this.NetRemainFee=list[28];
	this.GroupDR=list[29];
	this.Group=list[sort+14];
	this.LimitYearsNum=list[30];
	this.ContractListDR=list[31];
	this.ContractList=list[sort+15];
	this.DepreMethodDR=list[32];
	this.DepreMethod=list[sort+16];
	this.Remark=list[33];
	this.DepreTotalFee=list[34];
	this.DesignWorkLoadNum=list[35];
	this.WorkLoadUnitDR=list[36];
	this.WorkLoadUnit=list[sort+17];
	this.Status=list[37];
	this.ManageUserDR=list[38];
	this.ManageUser=list[sort+18];
	this.MaintUserDR=list[39];
	this.MaintUser=list[sort+19];
	this.ProviderHandler=list[40];
	this.ProviderTel=list[41];
	this.AppendFeeTotalFee=list[42];
	this.StartDate=list[43];
	this.TransAssetDate=list[44];
	this.GuaranteeFlag=list[45];
	this.InputFlag=list[46];
	this.TestFlag=list[47];
	this.MedicalFlag=list[48];
	this.GuaranteeStartDate=list[49];
	this.GuaranteeEndDate=list[50];
	this.AddUserDR=list[51];
	this.AddUser=list[sort+20];
	this.AddDate=list[52];
	this.AddTime=list[53];
	this.UpdateUserDR=list[54];
	this.UpdateUser=list[sort+21];
	this.UpdateDate=list[55];
	this.UpdateTime=list[56];
	
	this.StatusDisplay=list[sort+29];
	this.MemoryCode=list[60];
	this.UrgencyFlag=list[61];
	this.EquipTypeDR=list[62];
	this.EquipType=list[sort+22];
	this.PurchaseTypeDR=list[63];
	this.PurchaseType=list[sort+23];
	this.PurposeTypeDR=list[64];
	this.PurposeType=list[sort+24];
	this.KeeperDR=list[65];
	this.Keeper=list[sort+25];
	this.StoreLocDR=list[66];
	this.StoreLoc=list[sort+26];
	this.StartDepreMonth=list[67];
	this.ServiceDR=list[68];
	this.Service=list[sort+27];
	this.InStockListDR=list[69];
	this.No=list[70];
	this.EquipTechLevel=list[sort+30];
	this.LocationDR=list[71];
	this.GuaranteePeriodNum=list[72];
	this.Service=list[sort+27];
	this.StatCatDR=list[74];
	this.StatCat=list[sort+31];
	this.InStockDate=list[sort+32];
	
	this.Hold1=list[75];
	this.Hold2=list[76];
	this.Hold3=list[77];
	this.Hold4=list[78];
	this.Hold5=list[79];
	this.EquiCatCode=list[sort+33];
	
	this.WorkLoadPerMonth=list[83];
	this.Location=list[sort+34];
	this.Hospital=list[sort+35];
	this.FileNo=list[84];
	this.Item=list[sort+36];
	this.Expenditures=list[sort+64];
}
