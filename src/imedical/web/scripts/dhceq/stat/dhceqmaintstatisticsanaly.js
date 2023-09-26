function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&vEquipDR="+GlobalObj.EquipDR;
	lnk=lnk+"&vEquipNo=";
	lnk=lnk+"&vEquipName=";
	lnk=lnk+"&vModelDR="+GlobalObj.ModelDR;
	lnk=lnk+"&vFromOriginalFee="+jQuery("#FromOriginalFee").val();
	lnk=lnk+"&vToOriginalFee="+jQuery("#ToOriginalFee").val();
	lnk=lnk+"&vItemDR="+GlobalObj.ItemDR;
	lnk=lnk+"&vEquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&vStatCatDR="+GlobalObj.StatCatDR;
	lnk=lnk+"&vEquipCatDR="+GlobalObj.EquipCatDR;
	lnk=lnk+"&vLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&vSDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&vEDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&vFromMaintAmount=";
	lnk=lnk+"&vToMaintAmount=";
	lnk=lnk+"&vMaintUserDR="+GlobalObj.MaintUserDR;
	lnk=lnk+"&vMaintGroupDR="+GlobalObj.MaintGroupDR;
	lnk=lnk+"&vInsurFlag="+GlobalObj.InsurFlagDR;
	lnk=lnk+"&vProviderDR="+GlobalObj.ProviderDR;
	lnk=lnk+"&vManufactoryDR="+GlobalObj.ManuFacturerDR;
	lnk=lnk+"&vServiceDR="+GlobalObj.ServiceDR;
	lnk=lnk+"&vFromYear="+jQuery("#FromYear").val();
	lnk=lnk+"&vToYear="+jQuery("#ToYear").val();
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="Equip^UseLoc^Service^MaintUser^Provider^ManuFacturer^Model^MaintGroup^Item^EquipType^StatCat^EquipCat";
	var Elements2="vLoc=UseLoc";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}