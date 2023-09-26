//document.styleSheets[0].addImport("DHCEQStyle.css",0);

function BannerBodyLoadHandler() 
{
	BannerInitPage();
}

function BannerInitPage()
{	
	InitBanner();	
	SetBannerInfo(GetElementValue("RowIDB"));
}

function InitBanner() 
{
	document.body.scroll="no";
	var obj=document.getElementById("BDetailB");
	if (obj) obj.onclick=BDetailB_Click;
	var All = document.getElementsByTagName( "table" );
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		All[I].style.width="100%";
	}

}


function SetBannerInfo(rowid)
{
	SetElement("RowIDB",rowid);	
	if ((rowid=="")||(rowid<1)) 
	{	return;	}
	var encmeth=GetElementValue("GetDataB");
	if (encmeth=="")
	{
		alertShow(t[21]);
		return;
	}	
	var result=cspRunServerMethod(encmeth,'','',rowid);	
	var list=result.split("^");
	var sort=EquipGlobalLen;
	SetCElement("cNameB",list[0]);
	SetCElement("cABCTypeB",list[1]);
	SetCElement("cModelDRB",list[2]);
	SetCElement("cModelB",list[sort+0]);
	SetCElement("cEquiCatDRB",list[3]);
	SetCElement("cEquiCatB",list[sort+1]);
	SetCElement("cUnitDRB",list[4]);
	SetCElement("cUnitB",list[sort+2]);
	SetCElement("cCodeB",list[5]);
	SetCElement("cDescB",list[6]);
	SetCElement("cInstallLocDRB",list[7]);
	SetCElement("cInstallLocB",list[sort+3]);
	SetCElement("cInstallDateB",list[8]);
	SetCElement("cLeaveFactoryNoB",list[9]);
	SetCElement("cLeaveFactoryDateB",list[10]);
	SetCElement("cOpenCheckDateB",list[11]);
	SetCElement("cCheckDateB",list[12]);
	SetCElement("cMakeDateB",list[13]);
	SetChkElement("cComputerFlagB",list[14]);
	SetCElement("cCountryDRB",list[15]);
	SetCElement("cCountryB",list[sort+4]);
	SetCElement("cManageLocDRB",list[16]);
	SetCElement("cManageLocB",list[sort+5]);
	SetCElement("cManageLevelDRB",list[17]);
	SetCElement("cManageLevelB",list[sort+6]);
	SetCElement("cUseLocDRB",list[18]);
	SetCElement("cUseLocB",list[sort+7]);
	SetCElement("cOriginDRB",list[19]);
	SetCElement("cOriginB",list[sort+8]);
	SetCElement("cFromDeptDRB",list[20]);
	SetCElement("cFromDeptB",list[sort+9]);
	SetCElement("cToDeptDRB",list[21]);
	SetCElement("cToDeptB",list[sort+10]);
	SetCElement("cBuyTypeDRB",list[22]);
	SetCElement("cBuyTypeB",list[sort+11]);
	SetCElement("cEquipTechLevelDR B",list[23]);
	SetCElement("cProviderDRB",list[24]);
	SetCElement("cProviderB",list[sort+12]);
	SetCElement("cManuFactoryDRB",list[25]);
	SetCElement("cManuFactoryB",list[sort+13]);
	SetCElement("cOriginalFeeB",list[26]);
	SetCElement("cNetFeeB",list[27]);
	SetCElement("cNetRemainFeeB",list[28]);
	SetCElement("cGroupDRB",list[29]);
	SetCElement("cGroupB",list[sort+14]);
	SetCElement("cLimitYearsNumB",list[30]);
	SetCElement("cContractListDRB",list[31]);
	SetCElement("cContractListB",list[sort+15]);
	SetCElement("cDepreMethodDRB",list[32]);
	SetCElement("cDepreMethodB",list[sort+16]);
	SetCElement("cRemarkB",list[33]);
	SetCElement("cDepreTotalFeeB",list[34]);
	SetCElement("cDesignWorkLoadNumB",list[35]);
	SetCElement("cWorkLoadUnitDRB",list[36]);
	SetCElement("cWorkLoadUnitB",list[sort+17]);
	SetCElement("cStatusB",list[37]);
	SetCElement("cManageUserDRB",list[38]);
	SetCElement("cManageUserB",list[sort+18]);
	SetCElement("cMaintUserDRB",list[39]);
	SetCElement("cMaintUserB",list[sort+19]);
	SetCElement("cContactUserB",list[40]);
	SetCElement("cContactModeB",list[41]);
	SetCElement("cAppendFeeTotalFeeB",list[42]);
	SetCElement("cStartDateB",list[43]);
	SetCElement("cTransAssetDateB",list[44]);
	SetChkElement("cGuaranteeFlagB",list[45]);
	SetChkElement("cInputFlagB",list[46]);
	SetChkElement("cTestFlagB",list[47]);
	SetChkElement("cMedicalFlagB",list[48]);
	SetCElement("cGuaranteeStartDateB",list[49]);
	SetCElement("cGuaranteeEndDateB",list[50]);
	SetCElement("cAddUserDRB",list[51]);
	SetCElement("cAddUserB",list[sort+20]);
	SetCElement("cAddDateB",list[52]);
	SetCElement("cAddTimeB",list[53]);
	SetCElement("cUpdateUserDRB",list[54]);
	SetCElement("cUpdateUserB",list[sort+21]);
	SetCElement("cUpdateDateB",list[55]);
	SetCElement("cUpdateTimeB",list[56]);
	SetCElement("cNoB",list[70]);
	SetCElement("cStatusB",list[sort+29]);
}

function BDetailB_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquip&RowID='+GetElementValue("RowIDB")+'&ReadOnly=1'
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=910,height=700,left=100,top=0')
}

document.body.onload = BannerBodyLoadHandler;
