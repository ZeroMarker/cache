Class EMRservice.BL.BLPatSign Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	获取患者签名配置信息
/// Input:	ACTLocID 登录科室ID
/// Return:	患者签名是否开启^签名厂商^是否支持PDF签名
/// Debug:	w ##Class(EMRservice.BL.BLPatSign).GetHandSignOption("100")
ClassMethod GetHandSignOption(ACTLocID As %String = "") As %String
{
	s isHandSignOn = "0", venderCode = "", supportPDF = 0, showQR = 0
	
	/*
	s version = ##Class(EMRservice.SystemParameter).CAVersion()
	if ("2" = version) {
		s HandSign=##Class(CA.DigitalSignatureService).IsHandSignCAON()
		q:("1"'=HandSign) isHandSignOn_"^"_venderCode_"^"_supportPDF_"^"_showQR
		
		s caCompany=##Class(CA.DigitalSignatureService).GetHandSignCACompany()	
	}else{
		s HandSign=$g(^CF("CA","HandSign"))
		q:("Y"'=HandSign) isHandSignOn_"^"_venderCode_"^"_supportPDF_"^"_showQR
		
		s caCompany = $g(^CF("CA","CAHandSignCompany"))
		s:(caCompany = "") caCompany=##Class(CA.DigitalSignatureService).GetCACompany()	
	}
	*/
	
    s hospID = ""
    s:(ACTLocID '= "") hospID = $P($G(^CTLOC(ACTLocID)),"^",22)
    
	s isHandSignOn = ##Class(EMRservice.SystemParameter).CAHandSign(hospID)
	q:(isHandSignOn '= "1") isHandSignOn_"^"_venderCode_"^"_supportPDF_"^"_showQR
	
	s vender = ##Class(EMRservice.SystemParameter).CAHandSignVender(hospID)
	s venderCode = $p(vender, "^", 1)
	s supportPDF = $p(vender, "^", 2)
	s showQR = $p(vender, "^", 3)
	
	q isHandSignOn_"^"_venderCode_"^"_supportPDF_"^"_showQR
}

}
