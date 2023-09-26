///DHCWeb.COMMHardManager.JS
///
/////tkMakeServerCall('web.DHCCPSchedBatch','SendBatchLocMsg');

//// Read Person Info Equip
//// 
function DHCWCOM_PersonInfoRead(EquiqDR)
{
	var myrtn =DHCHardComm_RandomPersonInfoEquip(EquiqDR, "R","","","");
	return myrtn;
}

////PWKeyPress Equip

function DHCWCOM_PWKeyPress()
{
	
}

////

////Bar Code Equip  or Other Print Device
function DHCWCOM_OtherPrintDeviceEquip(EquiqDR, Inpara1, Inpara2,Inpara3)
{
	var myrtn=DHCHardComm_BarCodeEquip(EquiqDR,"P",Inpara1, Inpara2,Inpara3);
	return myrtn;
}

//// Sound Quote
function DHCWCOM_SoundQuotePrice(EquiqDR, XMLStr)
{
	var myrtn =DHCHardComm_SoundQuoteEquip(EquiqDR, "R", XMLStr,"","");
	return myrtn;
}

function DHCWCOM_SoundPriceService(EquipDR,XmlStr,TipFlag){
	
	DHCWCOM_SoundQuotePrice(EquipDR,XmlStr);
	if (TipFlag=="1"){
	}else{
		return true;
	}
}