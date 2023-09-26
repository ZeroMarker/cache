function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&vEquipDR="+getElementValue("EquipDR");
	lnk=lnk+"&vEquipNo=";
	lnk=lnk+"&vEquipName=";
	lnk=lnk+"&vModelDR="+getElementValue("ModelDR");
	lnk=lnk+"&vFromOriginalFee="+jQuery("#FromOriginalFee").val();
	lnk=lnk+"&vToOriginalFee="+jQuery("#ToOriginalFee").val();
	lnk=lnk+"&vItemDR="+getElementValue("ItemDR");
	lnk=lnk+"&vEquipTypeDR="+getElementValue("EquipTypeDR");
	lnk=lnk+"&vStatCatDR="+getElementValue("StatCatDR");
	lnk=lnk+"&vEquipCatDR="+getElementValue("EquipCatDR");
	lnk=lnk+"&vLocDR="+getElementValue("UseLocDR");
	lnk=lnk+"&vSDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&vEDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&vFromMaintAmount=";
	lnk=lnk+"&vToMaintAmount=";
	lnk=lnk+"&vMaintUserDR="+getElementValue("MaintUserDR");
	lnk=lnk+"&vMaintGroupDR="+getElementValue("MaintGroupDR");
	lnk=lnk+"&vInsurFlag="+getElementValue("InsurFlagDR");
	lnk=lnk+"&vProviderDR="+getElementValue("ProviderDR");
	lnk=lnk+"&vManufactoryDR="+getElementValue("ManuFacturerDR");
	lnk=lnk+"&vServiceDR="+getElementValue("ServiceDR");
	lnk=lnk+"&vFromYear="+jQuery("#FromYear").val();
	lnk=lnk+"&vToYear="+jQuery("#ToYear").val();
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="Equip^UseLoc^Service^MaintUser^Provider^ManuFacturer^Model^MaintGroup^Item^EquipType^StatCat^EquipCat";
	var Elements2="vLoc=UseLoc";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}