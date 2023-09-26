/// 名称：DHCMA.CPW.IO.FromDoc
/// 描述：从医生站获取接口方法类
/// 编写者：yankai
/// 编写日期：2019-05-27
Class DHCMA.CPW.IO.FromDoc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2019-05-27
/// Description:  医生站获取草药相关医嘱子类字符串接口
/// Input：
/// Return:		  
/// w ##class(DHCMA.CPW.IO.FromDoc).GetCPWCNMedItemCatStr()
ClassMethod GetCPWCNMedItemCatStr(aHospID As %String = "") As %String
{
	New (aHospID,%session)
	Set return=""
	Set $ZT="GetCPWCNMedItemCatStrErr"
	
	Set:aHospID="" aHospID=$g(%session.Data("LOGON.HOSPID"))
	Set methodParam=$g(^oddCOM("web.DHCDocOrderCommon","m","GetCNMedItemCatStr",60))
	If $ll(methodParam)=1{
		Set return=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr(+aHospID)
	}Else{
		Set return=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	}
	
	Quit return
	
GetCPWCNMedItemCatStrErr
	Quit "-999"
}

/// Creator：     yankai
/// CreatDate：   2019-05-27
/// Description:  医生站检查医嘱是否是中草药医嘱接口
/// Input：       aArcimRowid : 医嘱项ID
/// Return:		  0：不是；1：是
/// w ##class(DHCMA.CPW.IO.FromDoc).IsCPWCNMedItem("3618||1")
ClassMethod IsCPWCNMedItem(aArcimRowid As %String, aHospID As %String = "") As %String
{
	
	New (aArcimRowid,aHospID,%session)
	Set ret=0
	Quit:aArcimRowid="" ret
	Set $ZT="IsCPWCNMedItemErr"
	
	Set:aHospID="" aHospID=$g(%session.Data("LOGON.HOSPID"))
	If aArcimRowid["||"{																		//医嘱项												
		Set methodParam=$g(^oddCOM("web.DHCDocOrderCommon","m","IsCNMedItem",60))
		If $ll(methodParam)=1{
			Set ret=##Class(web.DHCDocOrderCommon).IsCNMedItem(aArcimRowid)	
		}else{
			Set ret=##Class(web.DHCDocOrderCommon).IsCNMedItem(aArcimRowid,+aHospID)		
		}															
	}Else{
		Set CNMSubCatStr=##class(DHCMA.CPW.IO.FromDoc).GetCPWCNMedItemCatStr(+aHospID) 		//医嘱套
		Set SubCatDr=$p($g(^ARCOS(aArcimRowid)),"^",9)
		Set:$lf($lfs(CNMSubCatStr,"^"),SubCatDr)>0 ret=1
	}
	Quit ret

IsCPWCNMedItemErr
	Quit "-999"
}

/// Creator:	  yankai
/// CreatDate：   2019-06-11
/// Description:  取诊断分类
/// Input：       aICDDxID：MRC_ICDDx表Rowid，aDiagnosID：MR_Diagnos表Rowid
/// Return:		  
/// w ##class(DHCMA.CPW.IO.FromDoc).GetDiagnosCat("23252","")
ClassMethod GetDiagnosCat(aICDDxID As %String = "", aDiagnosID As %String = "") As %String
{
	New (aICDDxID,aDiagnosID)
	Set return=""
	Quit:(aICDDxID="")&&(aDiagnosID="") return
	
	Set $ZT="GetDiagnosCatErr"
	Set DiagnosCat=""
	//引用医生站获取诊断分类方式，适用8.1版本以后
	If aICDDxID'=""{
		Set BillFlag1=$p($g(^MRC("ID",+aICDDxID)),"^",13)
		Set BillFlag3=$p($g(^MRC("ID",+aICDDxID)),"^",15)
		Set DiagnosCat=$s(BillFlag3'="Y":"西医",(BillFlag3="Y")&&(BillFlag1'="Y"):"中医",1:"证候")
	}Else{
		Set Questionnaire=$p($g(^MR($p(aDiagnosID,"||",1),"DIA",$P(aDiagnosID,"||",2))),"^",22)
		Set DiagnosCat=$s(Questionnaire=1:"西医",Questionnaire=2:"中医",Questionnaire=3:"证候",1:"")
	}
	Set return=DiagnosCat
	Quit return
	
GetDiagnosCatErr
	Quit ""
}

/// Creator:	  yankai
/// CreatDate：   2019-06-28
/// Description:  就诊ID获取病人id和身份证号
/// Input：       aEpisodeID
/// Return:		  病人ID^身份证号
/// w ##Class(DHCMA.CPW.IO.FromDoc).GetPatIDAndIDCardCode(8)
ClassMethod GetPatIDAndIDCardCode(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID="",IDCardCode=""
	Set:aEpisodeID["!!" aEpisodeID=$p(aEpisodeID,"!!",1)
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set IDCardCode=""
	
	Set IDCardCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)
	Set PACCardID=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	
	Set CardType=""
	Set:PACCardID'="" CardType=$p($g(^PAC("CARD",PACCardID)),"^",2)
	If (IDCardCode="")&&(CardType["身份证"){
		Set IDCardCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	}	
	
	Set return=PatientID_"^"_IDCardCode
	Quit return
}

/// 取HIS诊断字典串
/// w ##Class(DHCMA.CPW.IO.FromDoc).GetMRCICDDX(5020)
ClassMethod GetMRCICDDX(argID As %String) As %String
{
	New (argID)
	Set return=""
	Quit:argID="" return
	Quit:'$d(^MRC("ID",argID)) return
	Set tmpICD=$g(^MRC("ID",argID))
	Set Code=$p(tmpICD,"^",1)
	Set Desc=$p(tmpICD,"^",2)
    Set ICD10=$p(tmpICD,"^",4)    //MRC_ICDDx.MRCID_ICD9CM_Code  对应维护界面：ICD10
    Set ICD9=$p(tmpICD,"^",35)    //MRC_ICDDx.MRCID_ICD9_Map     对应维护界面：ICD9
    Set Verion=""
    Set Resume=""
    Set IsActive="Yes"
    Set DateFrom=$p(tmpICD,"^",6)
    Set DateTo=$p(tmpICD,"^",7)
    Set return=argID_"^"_Code_"^"_Desc_"^"_ICD10_"^"_ICD9_"^"_Verion_"^"_Resume_"^"_IsActive_"^"_DateFrom_"^"_DateTo
	Set return=$tr(return,$c(13),"")
	Set return=$tr(return,$c(10),"")
	Set return=$tr(return,$c(0),"")
	Quit return
}

/// Creator:	  yankai
/// CreatDate：   2021-12-10
/// Description:  根据就诊ID判断病人门诊就诊挂号是否在有效期内
/// Input：       aEpisodeID
/// Return:		  0：在有效就诊时间内 "-100^单位（天、小时）^时间：不在有效时间内，单位代表配置的单位，时间代表配置的时间
/// w ##Class(DHCMA.CPW.IO.FromDoc).GetOPVisitIsVaild(8)
ClassMethod GetOPVisitIsVaild(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set return=##class(web.DHCDocOrderCommon).GetVisitTimeToDay($p(aEpisodeID,"!!",1))
	Quit return
}

/// Creator:	  yankai
/// CreatDate：   2021-12-22
/// Description:  根据aEpisodeID/PathwayID(住院路径)/VisitID(门诊路径患者)获取患者就诊院区
/// Input：       aEpisodeID
/// Return:		  就诊医院OID
/// w ##Class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID()
ClassMethod GetAdmHospOID(aEpisodeID As %String, aPathwayID As %String = "", aVisitID As %String = "") As %String
{
	New (aEpisodeID,aPathwayID,aVisitID)
	Set return=""
	Quit:(aEpisodeID="")&&(aPathwayID="")&&(aVisitID="") return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set AdmHospID=""	
	If aEpisodeID'=""{
		Set AdmID=$p(aEpisodeID,"!!",1)
		Set AdmLocID=$p($g(^PAADM(AdmID)),"^",4)  //就诊科室
 		Set AdmHospID=$p($g(^CTLOC(AdmLocID)),"^",22)_"!!"_SYSDr		
	}ElseIf aPathwayID'=""{
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
		Quit:'$IsObject(objPathway) return
		Set EpisodeID=objPathway.CPEpisodeID
		Set AdmID=$p(EpisodeID,"!!",1)
		Set AdmLocID=$p($g(^PAADM(AdmID)),"^",4)  //就诊科室
 		Set AdmHospID=$p($g(^CTLOC(AdmLocID)),"^",22)_"!!"_SYSDr
	}ElseIf aVisitID'=""{
		Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(aVisitID)
		Quit:'$IsObject(objVisit) return
		Set EpisodeID=objVisit.CPEpisodeID
		Set AdmID=$p(EpisodeID,"!!",1)
		Set AdmLocID=$p($g(^PAADM(AdmID)),"^",4)  //就诊科室
 		Set AdmHospID=$p($g(^CTLOC(AdmLocID)),"^",22)_"!!"_SYSDr
	}
	Set return=AdmHospID
	
	Quit return
}

/// Creator:	  yankai
/// CreatDate：   2022-04-20
/// Description:  医生站方法获取开立医嘱接收科室 (如果就诊id不为空，优先根据就诊科室取接收科室，如就诊id为空，根据开单科室取接收科室)
/// Input:        EpisodeID:就诊ID
///               EpLoc:开单科室
///               Arcim:医嘱项ID
/// 			  OpenForAllHosp:是否跨院 (1是 0否)
/// 			  OrdDate:日期 (可以为空,空为当天)      
/// Return:		  
/// w ##Class(DHCMA.CPW.IO.FromDoc).GetRecLocByDoc("978!!1","191!!1","2080||1")
ClassMethod GetRecLocByDoc(aEpisodeID As %String, aEpLoc As %String, aArcim As %String, aOpenForAllHosp As %String = "", aOrdDate As %String = "") As %String
{
	New (aEpisodeID,aEpLoc,aArcim,aOpenForAllHosp,aOrdDate)
	Set return=""
	Quit:(aEpisodeID="")||(aEpLoc="")||(aArcim="") return
	
	Set $ZE="GetRecLocByDocErr"
	Set return=##class(DHCDoc.Interface.Inside.Service).GetRecloc(+aEpisodeID,+aEpLoc,aArcim,aOpenForAllHosp,aOrdDate)
	Quit return

GetRecLocByDocErr
	Quit ""
}

/// Creater：	yankai
/// Descript： 	根据医嘱项和科室取库存数量、在途数等(一品多规调用！)
/// CreateDate：2022-04-20
/// Input：		医嘱项ID,科室ID
///             add: AdmType 如果病人类型为 I住院，则取住院加锁标致，否则取门诊加锁标致 2020-10-29 yangsj
/// Return：	库存项1信息串$C(2)库存项2信息串
/// 			库存项信息=1库存项ID^2库存项代码^3库存项名称^4规格^5住院单位id^6住院单位描述^7门诊单位ID^8门诊单位描述^9当前库存数^10可用库存数^11医嘱占用数^12库存业务占用数
/// w ##Class(DHCMA.CPW.IO.FromDoc).GetIncilQtyListByPHA("2080||1","184","I")
ClassMethod GetIncilQtyListByPHA(aArcim As %String, aRecLoc As %String, aAdmType As %String = "I") As %String
{
	New (aArcim,aRecLoc,aAdmType)
	Set return=""
	Quit:(aArcim="")||(aRecLoc="") return
	
	Set $ZE="GetIncilQtyListByPHAErr"
	Set return=##class(web.DHCSTINTERFACE).GetIncilQtyList(aArcim,aRecLoc,aAdmType)
	Quit return
	
GetIncilQtyListByPHAErr
	Quit ""
}

/// Creator：     yankai
/// CreatDate：   2022-01-05
/// Description:  检查是否是检查类医嘱
/// Table:        
/// Input：       医嘱项ID
/// w ##class(DHCMA.CPW.IO.FromDoc).IsExamOrder("2303||1")
ClassMethod IsExamOrder(aArcimID As %String) As %String
{
	New (aArcimID)
	Set return=0
	Quit:aArcimID="" return
	
	//调用医生站检查是否或者有检查医嘱标识
	Set return=##class(web.DHCDocOrderCommon).GetItemServiceFlag(aArcimID)
	Quit return
}

/// Creator:	  yankai
/// CreatDate：   2022-01-13
/// Description:  根据医嘱项id获取默认数量单位
/// Input：       
/// Return:		  UomID^UomDesc
/// Resume:		  对应医生站取协议包装单位(数量单位)w ##class(web.DHCDocOrderCommon).GetBillUOMStr("","") 
/// w ##Class(DHCMA.CPW.IO.FromDoc).GetQtyUomByArcimID(8)
ClassMethod GetQtyUomByArcimID(aARCIMRowid As %String) As %String
{
	New (aARCIMRowid)
	Set return=""
	Quit:aARCIMRowid="" return
	
	Set (QtyUomID,QtyUomDesc)=""
	Set ItemCatRowid=$p($g(^ARCIM(+aARCIMRowid,+$p(aARCIMRowid,"||",2),1)),"^",10)
	Set ARCOrdType=$p($g(^ARC("IC",+ItemCatRowid)),"^",7)					//医嘱项类型（药物R)
	
	//数量单位：药品取库存项表住院药房发药单位，其他取医嘱项表计价单位
	If ARCOrdType="R"{
		Set Inci=$o(^INCI(0,"ARCIM_DR",+aARCIMRowid,""))  
		Set:Inci'="" QtyUomID=$p($g(^INCI(Inci,1)),"^",13) 				
		Set:QtyUomID'="" QtyUomDesc=$p($g(^CT("UOM",QtyUomID)),"^",2)
	}Else{
		Set QtyUomID=$p($g(^ARCIM(+aARCIMRowid,$p(aARCIMRowid,"||",2),8)),"^",14)
		Set:QtyUomID'="" QtyUomDesc=$p($g(^CT("UOM",QtyUomID)),"^",2)
	}
	Set return=QtyUomID_"^"_QtyUomDesc
	
	Quit return
}

/// Creator:	  yankai
/// CreatDate：   2022-08-19
/// Description:  根据就诊ID获取患者当前病区id(ct_loc表）
/// Input：       EpisodeID 
/// Return:		  CTLoc表OID(病区记录）
/// w ##class(DHCMA.CPW.IO.FromDoc).GetCTLocOIDByAdm(1)
ClassMethod GetCTLocOIDByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return = ""
	Quit:aEpisodeID="" return
	
	Set PacWardID = $p($g(^PAADM(+aEpisodeID)),"^",70)
	Quit:PacWardID="" return
	Set CTLocID = $p($g(^PAWARD(PacWardID)),"^",5)
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set return = CTLocID_"!!"_SYSDr
	
	Quit return
}

}
