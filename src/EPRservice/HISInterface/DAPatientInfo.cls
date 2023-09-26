Class EPRservice.HISInterface.DAPatientInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	姓名
/// Return:	desc
ClassMethod GetName(APapmiDR As %String) As %String
{
	q:($d(^PAPER(APapmiDR,"ALL"))'=1)&&($d(^PAPER(APapmiDR,"ALL"))'=11) ""
	q $P($G(^PAPER(APapmiDR,"ALL")),"^",1)
}

/// Desc:	登记号
/// Table:	PA_PatMas.PAPMI_IPNo
/// Return:	desc	
ClassMethod GetPapmiNo(APapmiDR As %String) As %String
{
	q:(($d(APapmiDR)=0)||(APapmiDR="")) ""
	q $P($g(^PAPER(APapmiDR,"PAT",1)),"^",1)
}

/// Desc:	性别
/// Return:	rowid^code^desc
ClassMethod GetGender(APapmiDR As %String) As %String
{
	q:(APapmiDR = "") ""
	
	s result = ""

	s dr = $P($G(^PAPER(APapmiDR,"ALL")),"^",7)
	if (dr '= "")
	{ 
		s code = $P($g(^CT("SEX",dr)),"^",1)
		s desc = $P($g(^CT("SEX",dr)),"^",2)
		s result = dr_"^"_code_"^"_desc
	}

	q result
}

/// Desc:	出生日期
ClassMethod GetBirthDate(APapmiDR As %String) As %String
{
	q:($d(APapmiDR)=0)||(APapmiDR="") ""
	s Birthday=$P($G(^PAPER(APapmiDR,"ALL")),"^",6)
	q Birthday
}

/// Desc:	年龄
ClassMethod GetAge(APapmiDR As %String, AEpisodeID As %String) As %String
{
	q:($d(APapmiDR)=0)||(APapmiDR="") ""
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ""
	s ClinicAge = ""
	s AdmDate = $P($G(^PAADM(AEpisodeID)),"^",6)
	s AdmTime = $P($G(^PAADM(AEpisodeID)),"^",7)
	//调用年龄统一接口	[ClinicAge]
   	s ClinicAge = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(APapmiDR,AEpisodeID,AdmDate,AdmTime)
   	
	q ClinicAge
}

/// Desc:	现住址
ClassMethod GetCurAddress(APapmiDR As %String) As %String
{
	q:($d(APapmiDR)=0)||(APapmiDR="") ""
	//现住址
	s CurAddress = ""
 	s tmpcuraddr=##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentAddressNew(APapmiDR,"")
 	s tmpcuraddr=$tr(tmpcuraddr,"\","")
 	if (tmpcuraddr '= "")
 	{
 		// 现住址城市 
   		s tmpcurCity = $p($g(tmpcuraddr),"!",2)
 
   		// 现住址省份 
   		s tmpcurProvince = $p($g(tmpcuraddr),"!",1)
   		
   		// 现住址区县 
   		s tmpcurBlock = $p($g(tmpcuraddr),"!",3)
   		
		s curStreet= $p($g(tmpcuraddr),"!",4)

   		// 现住址
   		s CurAddress = $p($g(tmpcurProvince),"^",3)_$p($g(tmpcurCity),"^",3)_$p($g(tmpcurBlock),"^",3)_curStreet
 	}
	q CurAddress
}

/// Desc:	住院病案号
ClassMethod GetIPRecordNo(APapmiDR As %String) As %String
{
	q:($d(APapmiDR)=0)||(APapmiDR="") ""
	q $P($g(^PAPER(APapmiDR,"PAT",1)),"^",22)
}

/// Desc:	住院病案号
ClassMethod GetIPRecordNo2(APapmiDR As %String, AEpisodeID As %String) As %String
{
	q:($d(APapmiDR)=0)||(APapmiDR="") ""
	
	/*
	s method = ##class(%Dictionary.CompiledMethod).%OpenId("web.DHCWMRService||IGetMrNoByEpisodeID")
	if (method = "")
	{
		q $P($g(^PAPER(APapmiDR,"PAT",1)),"^",22)
	}
	else
	{
		q ##class(web.DHCWMRService).IGetMrNoByEpisodeID(AEpisodeID)
	}
	*/
	//修改为产品组公用接口
	q ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(AEpisodeID)
}

/// Desc:	根据姓名获取登记rowid列表
/// Debug:	s list = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiListByName("田永温")
ClassMethod GetPapmiListByName(AName As %String) As %ListOfDataTypes
{
	s retList = ##Class(%ListOfDataTypes).%New()
	
	q:(AName = "") retList
	
	s upName = $zcvt(AName,"u")
	
	s papmiID = ""
	for {
		s papmiID = $O(^PAPERi("PAPER_PatName",$zstrip(upName,"*p"),papmiID))
		q:(papmiID = "")
		
		d retList.Insert(papmiID)
	}
	
	q retList
}

/// Desc:	根据登记号获取登记rowid列表
/// Debug:	s list = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiListByPapmiNo("00000005")
ClassMethod GetPapmiListByPapmiNo(APapmiNo As %String) As %ListOfDataTypes
{
	s retList = ##Class(%ListOfDataTypes).%New()
	
	q:(APapmiNo = "") retList
	
	s upPapmiNo = $zcvt(APapmiNo,"u")
	
	s papmiID = ""
	for {
		s papmiID = $O(^PAPERi("PAPMI_PatNo",upPapmiNo,papmiID))
		q:(papmiID = "")
		
		d retList.Insert(papmiID)
	}
	
	q retList
}

}
