Class web.DHCFHQ.DataBaseUp Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod up1()
{
	
	k ^rINDEXSQL("rv","EPR","FAVPATIENTLIST_PATIENTS")
	d $system.OBJ.Delete("User.UDHCJFCPTReimbursement")
	d $system.OBJ.Delete("User.DHCINVPRTRepInsTypePayMode")
	d $system.OBJ.Delete("User.DHCStkYear")
	d $system.OBJ.Delete("User.DHCWMRNoTypeExt")
	d $system.OBJ.Delete("User.NewClass1hisinfo")
	d $system.OBJ.Delete("web.udhcOPHandin3")
	d $system.OBJ.Delete("web.udhcOPHandin3")
	d $system.OBJ.Delete("web.DHCRegConFree1")
	d $system.OBJ.Delete("web.DHCIPBillPatBillDetailsOld")
	d $system.OBJ.Delete("web.UDHCANVitalSign")
	d $system.OBJ.Delete("web.DHCRegConFree1")
	d $system.OBJ.Delete("web.NewClass1")
}

ClassMethod up2(para As %String)
{
	if para'=2 d
	.d $System.OBJ.CompilePackage("websys","f")
	.d $System.OBJ.CompilePackage("epr","f")
	.d $System.OBJ.CompilePackage("User","f")
	.d $System.OBJ.CompilePackage("Nur","f")
	.d $System.OBJ.CompilePackage("NurEmr","f")
	if para=2 d
	.d $System.OBJ.CompilePackage("User","f")
	d $System.OBJ.CompilePackage("web","f")
	d $System.OBJ.CompilePackage("lab","f")
	d $System.OBJ.CompilePackage("dhc","f")
	d $System.OBJ.CompilePackage("web","f")
	d $System.OBJ.CompilePackage("epr","f")
	d $System.OBJ.CompilePackage("websys","f")
	d $System.OBJ.CompilePackage("appcom","f")
	d $System.OBJ.CompilePackage("DHCCPM","f")
	d $System.OBJ.CompilePackage("DHCCPMWeb","f")
	d $System.OBJ.CompilePackage("DHCCPMWeb","f")
	d $System.OBJ.CompilePackage("DHCOPINFUSION","f") 
	d $System.OBJ.CompilePackage("DHCOPINFUSION","f")
	d $System.OBJ.CompilePackage("dhcservice","f")
	d $System.OBJ.CompilePackage("dhcservice","f")
	d $System.OBJ.CompilePackage("DHCWL","f")
	d $System.OBJ.CompilePackage("DHCWL","f")
	d $System.OBJ.CompilePackage("DWR","f")
	d $System.OBJ.CompilePackage("DWR","f")
	d $System.OBJ.CompilePackage("LisService","f")
	d $System.OBJ.CompilePackage("LisService","f")
	d $System.OBJ.CompilePackage("RISService","f")
	d $System.OBJ.CompilePackage("RISService","f")
	d $System.OBJ.CompilePackage("PackPharmacyToMa","f")
	d $System.OBJ.CompilePackage("PackPharmacyToMa","f")
	d $System.OBJ.CompilePackage("portalinterface","f")
	d $System.OBJ.CompilePackage("portalinterface","f")
	d $System.OBJ.CompilePackage("DHCENS","f")
	d $System.OBJ.CompilePackage("DHCBILL","f")
	d $System.OBJ.CompilePackage("DHCOLB","f")
	d $System.OBJ.CompilePackage("DHCMed","f")
	d $System.OBJ.CompilePackage("VIS","f")
}

ClassMethod v7up()
{
	d $System.OBJ.Compile("User.PADischargeSummary")
	d $System.OBJ.Compile("User.PAAdm2DischargeSummary")
	d $System.OBJ.Compile("User.PAPersonConsultSetConsR")
	d $System.OBJ.Compile("User.MRPictConsRef")
}

ClassMethod up3()
{
	d $System.OBJ.Compile("EPRinstance.InstanceData")
	d $System.OBJ.Compile("EPRservice.BOInstanceData")
	d $System.OBJ.Compile("DHCLabToEPR.DHCLabTestSetQuery","f")
	d $System.OBJ.Compile("web.DHCRisclinicQueryEPR","f")
	d $System.OBJ.Compile("EPRmeta.CustomDictionary","f")
	d $System.OBJ.CompilePackage("EPRinstance","f")
	d $System.OBJ.CompilePackage("EPRmeta","f")
	d $System.OBJ.CompilePackage("EPRservice","f")
	d $System.OBJ.CompilePackage("web.eprajax","f")
	d $System.OBJ.Compile("web.DHCEPRExt","f")
	d $System.OBJ.Compile("web.DHCEPR","f")
}

}
