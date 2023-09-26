/// 名称 : DHCMed.CDService.LodopRepSrv
/// 描述 : 慢病Lodop打印服务
/// 编写者：陈瑞
/// 编写日期: 2022-05-31
Class DHCMed.CDService.LodopRepSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenrui
/// CreatDate：   2022-05-31
/// Description:  查询慢病卡： 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetRepInfo(1)
ClassMethod GetRepInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return=""
	Quit:aReportID="" return
	Kill objRep
	Kill objReportUser
	
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Set RepTypeCode	= objRep.CRReportType.CRFCode
	Set ReportOrgan	= objRep.CRReportOrgan
	Set ReportUser 	= objRep.CRReportUser
	Set ReportUserID = ""
	if ((RepTypeCode="ZLK")){
		set objReportUser=##Class(DHCMed.Base.SSUser).GetObjById(+ReportUser)
		set ReportUserDesc=objReportUser.Rowid_","_objReportUser.Name
		Set ReportUserID = $p(ReportUserDesc,",",1)
		Set ReportUser = $p(ReportUserDesc,",",2)
	}
	
	Set ReportDate = objRep.CRReportDate
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
	Set LocID      = objRep.CRReportLoc
	Set LocDesc    = $p($g(^CTLOC(+LocID)),"^",2)
	Set:$p(LocDesc,"-",2)'="" LocDesc = $p(LocDesc,"-",2) 
	
	Set CRCheckDate = objRep.CRCheckDate
	Set:CRCheckDate'="" CRCheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CRCheckDate)
	Set CRCheckUser = objRep.CRCheckUser
	Set objCheckUser=##Class(DHCMed.Base.SSUser).GetObjById(CRCheckUser)
	If $IsObject(objCheckUser) {
		Set CRCheckUser = objCheckUser.Name
	}
	
	Set return=ReportOrgan_"^"_ReportUser_"^"_ReportDate_"^"_LocDesc_"^"_CRCheckDate_"^"_CRCheckUser
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-05-31
/// Description:  查询慢病PAT病人信息卡： 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetPATInfo(1)
ClassMethod GetPATInfo(aReportID As %String) As %String
{
	
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objPAT
	Set (MZH,ZYH,DJH,CRXM,SFZH,CRXB,PatAge,CSRQ,CRZY,CRGZ,CRMZ,JTDH,GZDW,CZDZS,CZDZS2,CZDZX,CZDZX2,CZDZC,CZDZXX,HJDZS,HJDZS2,HJDZX,HJDZX2,HJDZC,HJDZXX,WHCD,LXDH,CRHJ,HYZK) = ""
	Quit:aReportID="" $$$OK
	Set objPAT=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(aReportID)
	Quit:'$IsObject(objPAT) $$$OK
	//病人基本信息
	Set MZH=objPAT.CRMZH
	Set ZYH=objPAT.CRZYH
	Set DJH=objPAT.CRDJH
	Set CRXM=objPAT.CRXM
	Set SFZH=objPAT.CRSFZH
	Set CRXB=objPAT.CRXB
	Set PatAge=""
	If (objPAT.CRNLS'="") {
		Set PatAge=objPAT.CRNLS_"岁"
	} ElseIf (objPAT.CRNLY'="") {
		Set PatAge=objPAT.CRNLS_"月"
	} ElseIf (objPAT.CRNLT'="") {
		Set PatAge=objPAT.CRNLT_"天"
	}
	Set CSRQ=objPAT.CRCSRQ
	Set:CSRQ'="" CSRQ=$zd(CSRQ,3)
	Set CRZY=objPAT.CRZY.Description
	Set:CRZY="" CRZY=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTZY")   //其他职业
	Set CRGZ=objPAT.CRGZ.Description  //工种改为字典类型
	Set CRMZ=objPAT.CRMZ.Description
	Set JTDH=objPAT.CRJTDH
	Set GZDW=objPAT.CRGZDW
	Set CZDZS=objPAT.CRCZDZS.ShortDesc
	Set CZDZS2=objPAT.CRCZDZS2.ShortDesc
	Set CZDZX=objPAT.CRCZDZX.ShortDesc
	Set CZDZX2=objPAT.CRCZDZX2.ShortDesc
	Set CZDZC=objPAT.CRCZDZC
	Set CZDZXX=objPAT.CRCZDZXX
	Set:CZDZXX="" CZDZXX = CZDZS_CZDZS2_CZDZX_CZDZX2_CZDZC
	Set HJDZS=objPAT.CRHJDZS.ShortDesc
	Set HJDZS2=objPAT.CRHJDZS2.ShortDesc
	Set HJDZX=objPAT.CRHJDZX.ShortDesc
	Set HJDZX2=objPAT.CRHJDZX2.ShortDesc
	Set HJDZC=objPAT.CRHJDZC
	Set HJDZXX=objPAT.CRHJDZXX
	Set:HJDZXX="" HJDZXX = HJDZS_HJDZS2_HJDZX_HJDZX2_HJDZC
	//  患者文化程度 联系电话 户籍 婚姻
	Set WHCD=objPAT.CRWHCD.Description
	Set LXDH=objPAT.CRLXDH
	Set:LXDH="" LXDH=objPAT.CRJTDH
	Set CRHJ=objPAT.CRHJ
	Set HYZK=objPAT.CRHYZK.Description
	
	Set return=MZH_"^"_ZYH_"^"_DJH_"^"_CRXM_"^"_SFZH_"^"_CRXB_"^"_PatAge_"^"_CSRQ_"^"_CRZY_"^"_CRGZ_"^"_CRMZ_"^"_JTDH_"^"_GZDW_"^"_CZDZS_"^"_CZDZS2_"^"_CZDZX_"^"_CZDZX2_"^"_CZDZC_"^"_CZDZXX_"^"_HJDZS_"^"_HJDZS2_"^"_HJDZX_"^"_HJDZX2_"^"_HJDZC_"^"_HJDZXX_"^"_WHCD_"^"_LXDH_"^"_CRHJ_"^"_HYZK
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-05-31
/// Description:  查询慢病肿瘤卡： 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetZLKInfo(1)
ClassMethod GetZLKInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objZLK // 清除缓存
	Set (KPBH,BQYGZBR,CardType,ContactOne,RelationOne,PhoneOne,ContactTwo,RelationTwo,PhoneTwo,ContactThr,RelationThr,PhoneThr,ZDBW,CRZD,ZDICD,BLXLX,YZD,BLH,YZDRQ,TNMFQT,TNMFQN,TNMFQM,FHCD,AttackDate,Action,ZDRQ,ZGZDDW,SWRQ,SWYY,SYICD,JTSWYY,BSZY,ZDYJ) = ""
	
	// 肿瘤卡信息
	Set objZLK=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(aReportID)
	Quit:'$IsObject(objZLK) return
	
	Set KPBH		= objZLK.CRKPBH
	Set BQYGZBR		= objZLK.CRBQYGZBR.Description
	Set CardType	= objZLK.CRCardType.Description
	Set ContactOne	= objZLK.ContactOne
	Set RelationOne	= objZLK.RelationOne.Description
	Set PhoneOne	= objZLK.PhoneOne
	Set ContactTwo	= objZLK.ContactTwo
	Set RelationTwo	= objZLK.RelationTwo.Description
	Set PhoneTwo	= objZLK.PhoneTwo
	Set ContactThr	= objZLK.ContactThr
	Set RelationThr	= objZLK.RelationThr.Description
	Set PhoneThr	= objZLK.PhoneThr
	Set ZDBW		= objZLK.CRZDBW     
	Set ZDStr		= ##class(DHCMed.CD.CRICDDx).GetDescByID(objZLK.CRZD)
	Set CRZD		= $p(ZDStr,$c(1),2)
	Set ZDICD		= objZLK.CRZDICD
	Set BLXLX		= objZLK.CRBLXLX
	Set YZD			= ##class(DHCMed.CD.CRICDDx).GetDescByID(objZLK.CRYZD)
	Set:YZD'="" YZD = $p(YZD,$c(1),2)
	Set BLH			= objZLK.CRBLH
	Set YZDRQ		= objZLK.CRYZDRQ
	Set:YZDRQ'="" YZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(YZDRQ)
	//确认时期别 
	Set (TNMFQT,TNMFQN,TNMFQM,FHCD)=""
	Set:$IsObject(objZLK.CRTNMFQT) TNMFQT=objZLK.CRTNMFQT.Description
	Set:$IsObject(objZLK.CRTNMFQN) TNMFQN=objZLK.CRTNMFQN.Description
	Set:$IsObject(objZLK.CRTNMFQM) TNMFQM=objZLK.CRTNMFQM.Description
	Set:$IsObject(objZLK.CRFHCD) FHCD=objZLK.CRFHCD.Description
	Set AttackDate	= objZLK.AttackDate
	Set:AttackDate'="" AttackDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AttackDate)
	Set Action		= objZLK.Action.Description
	Set ZDRQ=objZLK.CRZDRQ
	Set:ZDRQ'="" ZDRQ = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
	Set ZGZDDW		= objZLK.CRZGZDDW.Description
	
	Set SWRQ		= objZLK.CRSWRQ
	Set:SWRQ'="" SWRQ= ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set SWYY		= objZLK.CRSWYY.Description      
	Set SYICD		= objZLK.CRSYICD
	Set JTSWYY		= objZLK.CRJTSWYY
	Set BSZY		= objZLK.CRBSZY
	//诊断依据  --多选
	Set ZDYJ=""
	For index=1:1:objZLK.CRZDYJ.Count() {
		Set objDic=objZLK.CRZDYJ.GetAt(index)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set ZDYJ=ZDYJ_","_xDesc
	}
	Set:ZDYJ'="" ZDYJ=$e(ZDYJ,2,*)
	Set RepInfo=..GetRepInfo(aReportID)
	
	Set return = KPBH_"^"_BQYGZBR_"^"_CardType_"^"_ContactOne_"^"_RelationOne_"^"_PhoneOne_"^"_ContactTwo_"^"_RelationTwo_"^"_PhoneTwo_"^"_ContactThr_"^"_RelationThr_"^"_PhoneThr_"^"_ZDBW_"^"_CRZD_"^"_ZDICD_"^"_BLXLX_"^"_YZD_"^"_BLH_"^"_YZDRQ_"^"_TNMFQT_"^"_TNMFQN_"^"_TNMFQM_"^"_FHCD_"^"_AttackDate_"^"_Action_"^"_ZDRQ_"^"_ZGZDDW_"^"_SWRQ_"^"_SWYY_"^"_SYICD_"^"_JTSWYY_"^"_BSZY_"^"_ZDYJ_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-05-31
/// Description:  查询高血压报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetGXYInfo(1)
ClassMethod GetGXYInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objGXY // 清除缓存
	Set (KPBH,PatStatus,FamilyConut,RelationList,GXYZD,GXYZDICD,Weight,Height,SymptomList,SSY,SZY,HeartRate,Resume,RepInfo) = ""
	
	// 高血压信息
	Set objGXY=##class(DHCMed.CD.CRReportGXY).GetObjByParRef(aReportID)
	Quit:'$IsObject(objGXY) return
	Set KPBH		= objGXY.CRKPBH
	Set PatStatus	= objGXY.CRPatStatus
	Set FamilyConut	= objGXY.CRFamilyConut
	
	Set RelationList=""
	For index=1:1:objGXY.CRRelationDrs.Count() {
		Set objDic=objGXY.CRRelationDrs.GetAt(index)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set RelationList=RelationList_","_xDesc
	}
	Set:RelationList'="" RelationList=$e(RelationList,2,*)
	Set GXYZD	= ##class(DHCMed.CD.CRReportGXY).GetICDDescByID(objGXY.CRGXYZD)
	Set:GXYZD'="" GXYZD = $p(GXYZD,$c(1),2)
	Set GXYZDICD	= objGXY.CRGXYZDICD
	Set Weight		= objGXY.CRWeight
	Set Height		= objGXY.CRHeight
	
	Set SymptomList=""
	For index=1:1:objGXY.CRSymptomDrs.Count() {
		Set objDic=objGXY.CRSymptomDrs.GetAt(index)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set SymptomList=SymptomList_","_xDesc
	}
	Set:SymptomList'="" SymptomList=$e(SymptomList,2,*)
	Set SSY			= objGXY.CRSSY
	Set SZY			= objGXY.CRSZY
	Set HeartRate	= objGXY.CRHeartRate
	Set Resume		= objGXY.CRResume
	Set RepInfo=..GetRepInfo(aReportID)
	
	Set return = KPBH_"^"_PatStatus_"^"_FamilyConut_"^"_RelationList_"^"_GXYZD_"^"_GXYZDICD_"^"_Weight_"^"_Height_"^"_SymptomList_"^"_SSY_"^"_SZY_"^"_HeartRate_"^"_Resume_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-06-20
/// Description:  获取高血压报卡字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetGXYDicList()
ClassMethod GetGXYDicList() As %List
{
	Set return = ""
	Set GXYRelationList = ..GetDictionary("GXYRelation")
	Set GXYSymptomsList = ..GetDictionary("GXYSymptoms")
	Set return =  $LB(GXYRelationList,GXYSymptomsList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：        
/// zw ##Class(DHCMed.EPDService.LodopReportInfo).GetDictionary("EpidemicReportRegion")
ClassMethod GetDictionary(aTypeCode As %String) As %List
{
	New (aTypeCode)
	Set return = ""
	Quit:aTypeCode="" return
	
	Set $ZT="GetActiveDicRowIDStrErr"

	Set aSeparate = "^"
	Set aTypeCode = $ZCVT(aTypeCode,"U")
	Set DicRowID = 0
	For {
		Set DicRowID = $o(^DHCMed.SS.DictionaryI("IdxofType"," "_aTypeCode,DicRowID))
		Quit:DicRowID=""
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(DicRowID)
		Continue:'$IsObject(objDic)
		
		// 仅加载标记为有效的基础字典数据
		Set Active = objDic.Active
		Continue:Active'=1
		Set Description = objDic.Description
		Set return = return_aSeparate_Description
	}
	Set:return'="" return=$Extract(return,2,$Length(return))
	Set return=$LFS(return,"^")
	Quit return
	
GetActiveDicRowIDStrErr
	Set return = -1
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-01
/// Description:  查询心脑血管报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetXNXGInfo(51)
ClassMethod GetXNXGInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objXNXG // 清除缓存
	Set (KPBH,CRRepProvince,CRRepCity,CRRepCounty,BGKLX,CRCardType,CRLiveSix,FBRQ,SFSCFB,ZDBM,QZRQ,CRDiag,CRCureMethod,CRApoplexyType,CRSCD,CRInfer,ZDYJ,CRBiochemicalMark,CRReissue,QZDW,CRLevel,CROutCome,SWRQ,SWYY,SYBM) = ""
	
	Set objXNXG=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(aReportID)
	Quit:'$IsObject(objXNXG) $$$OK
	Set KPBH			= objXNXG.CRKPBH
	Set CRRepProvince	= objXNXG.CRRepProvince.ShortDesc	// 报卡省
	Set CRRepCity		= objXNXG.CRRepCity.ShortDesc		// 报卡市
	Set CRRepCounty		= objXNXG.CRRepCounty.ShortDesc		// 报卡区
	Set BGKLX			= objXNXG.CRBGKLX.Description		// 报卡类型
	Set CRCardType		= objXNXG.CRCardType.Description	// 证件类型
	Set CRLiveSix		= objXNXG.CRLiveSix.Description		// 居住六个月以上
	Set FBRQ			= objXNXG.CRFBRQ					// 发病日期
	Set:FBRQ'="" FBRQ= ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FBRQ)
	Set SFSCFB			= objXNXG.CRSFSCFB.Description		//是否首次发病
	Set ZDBM 			= objXNXG.CRZDBM					// 诊断编码(ICD-10)
	Set QZRQ			= objXNXG.CRQZRQ					// 诊断日期
	Set:QZRQ'="" QZRQ= ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(QZRQ)
	Set CRDiag			= objXNXG.CRDaig.Description		// 诊断
	Set CRCureMethod	= objXNXG.CRCureMethod.Description	// 治疗措施
	Set CRApoplexyType	= objXNXG.CRApoplexyType.Description // 脑卒中类型
	Set CRSCD			= objXNXG.CRSCD.Description			// 心源性猝死
	Set CRInfer			= objXNXG.CRInfer.Description		// 推断
	// 诊断依据
	Set ZDYJ=""												
	For index=1:1:objXNXG.CRZDYJ.Count() {
		Set objDic=objXNXG.CRZDYJ.GetAt(index)
		Continue:'$IsObject(objDic)		
		Set SubDesc=objDic.Description
		Set ZDYJ=ZDYJ_","_SubDesc
		
	}
	Set:ZDYJ'="" ZDYJ = $e(ZDYJ,2,*)
	Set CRBiochemicalMark= objXNXG.CRBiochemicalMark.Description	// 生化标志物
	Set CRReissue		= objXNXG.CRReissue.Description				// 补发
	Set QZDW			= objXNXG.CRQZDW.Description				// 诊断单位
	Set CRLevel			= objXNXG.CRLevel.Description				// 诊断单位级别
	Set CROutCome		= objXNXG.CROutCome.Description				// 转归
	
	Set SWRQ			= objXNXG.CRSWRQ							// 死亡日期
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set SWYY			= objXNXG.CRSWYY.Description   				// 死亡原因
	Set SYBM			= objXNXG.CRSYBM							// 死亡编码
	Set RepInfo=..GetRepInfo(aReportID)
	
	Set return = KPBH_"^"_CRRepProvince_"^"_CRRepCity_"^"_CRRepCounty_"^"_BGKLX_"^"_CRCardType_"^"_CRLiveSix_"^"_FBRQ_"^"_SFSCFB_"^"_ZDBM_"^"_QZRQ_"^"_CRDiag_"^"_CRCureMethod_"^"_CRApoplexyType_"^"_CRSCD_"^"_CRInfer_"^"_ZDYJ_"^"_CRBiochemicalMark_"^"_CRReissue_"^"_QZDW_"^"_CRLevel_"^"_CROutCome_"^"_SWRQ_"^"_SWYY_"^"_SYBM_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-06-20
/// Description:  获取高血压报卡字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetXNXGDicList()
ClassMethod GetXNXGDicList() As %List
{
	Set return = ""
	Set DiagList 			= ..GetDictionary("XNXGDiagList")
	Set LiveSixMonthList 	= ..GetDictionary("XNXGLiveSixMonth")
	Set CureMethodList 		= ..GetDictionary("XNXGCureMethod")
	Set ApoplexyTypeList 	= ..GetDictionary("XNXGApoplexyType")
	Set SCDList 			= ..GetDictionary("XNXGSCD")
	Set InferList 			= ..GetDictionary("XNXGInfer")
	Set BiochemicalMarkList = ..GetDictionary("BiochemicalMark")
	Set ReissueList 		= ..GetDictionary("Reissue")
	Set XNXGDiagList 		= ..GetDictionary("XNXGDiag")
	Set LevelList 			= ..GetDictionary("XNXGLevel")
	Set return =  $LB(DiagList,LiveSixMonthList,CureMethodList,ApoplexyTypeList,SCDList,InferList,BiochemicalMarkList,ReissueList,XNXGDiagList,LevelList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  查询糖尿病报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetTNBInfo(51)
ClassMethod GetTNBInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objTNB // 清除缓存
	Set (KPBH,ZDLX,CRZD,ZDICD,BFZ,WHYS,CRTZ,CRSG,CRRS,JZS,LCBX,QTLCBX,ZYJCQK1,ZYJCQK2,ZYJCQK3,ZYJCQK4,ZYJCQK5,ZYJCQK6,ZYJCQK7,ZYJCQK8,ZYJCQK9,ZDRQ,ZGZDDW,SWRQ,SWYY,SYICD,JTSWYY) = ""
	
	Set objTNB=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(aReportID)
	Quit:'$IsObject(objTNB) $$$OK
	Set KPBH			= objTNB.CRKPBH
	Set ZDLX 			= objTNB.CRZDLX.Description    //糖尿病类型
	Set ZDStr			= ##class(DHCMed.CD.CRReportTNB).GetICDDescByID(objTNB.CRZD)	//诊断
	Set CRZD 			= $p(ZDStr,$c(1),2)
	Set ZDICD			= objTNB.CRZDICD			   // 诊断ICD编码
	Set BFZ=""										   // 并发症
	For index=1:1:objTNB.CRBFZ.Count() {
		Set objDic=objTNB.CRBFZ.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set BFZ=BFZ_","_SubDesc
	}
	Set:BFZ'="" BFZ=$e(BFZ,2,*)
	Set WHYS=""      									// 危害因素
	For index=1:1:objTNB.CRWHYS.Count() {
		Set objDic=objTNB.CRWHYS.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set WHYS=WHYS_","_SubDesc
	}
	Set:WHYS'="" WHYS=$e(WHYS,2,*)	
	Set CRTZ		= objTNB.CRTZ		// 体重
	Set CRSG		= objTNB.CRSG		// 身高
	Set CRRS		= objTNB.CRRS		// 人数
	Set JZS=""							// 家族史
	For index=1:1:objTNB.CRJZS.Count() {
		Set objDic=objTNB.CRJZS.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set JZS=JZS_","_SubDesc
	}
	Set:JZS'="" JZS=$e(JZS,2,*)
	Set LCBX=""							// 临床表现
	For index=1:1:objTNB.CRLCBX.Count() {
		Set objDic=objTNB.CRLCBX.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set LCBX=LCBX_","_SubDesc
	}
	Set:LCBX'="" LCBX=$e(LCBX,2,*)
	Set QTLCBX=objTNB.CRQTLCBX			// 其他临床表现
	Set ZYJCQK1		= objTNB.CRZYJCQK1	// E1
	Set ZYJCQK2		= objTNB.CRZYJCQK2	// E2
	Set ZYJCQK3		= objTNB.CRZYJCQK3	// E3
	Set ZYJCQK4		= objTNB.CRZYJCQK4	// E4
	Set ZYJCQK5		= objTNB.CRZYJCQK5	// E5
	Set ZYJCQK6		= objTNB.CRZYJCQK6	// E6
	Set ZYJCQK7		= objTNB.CRZYJCQK7	// E7
	Set ZYJCQK8		= objTNB.CRZYJCQK8	// E8
	Set ZYJCQK9		= objTNB.CRZYJCQK9	// E9
	Set ZDRQ		= objTNB.CRZDRQ		// 诊断日期
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)	
	Set ZGZDDW		= objTNB.CRZGZDDW.Description	// 诊断最高单位
	Set SWRQ		= objTNB.CRSWRQ		// 死亡日期
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set SWYY		= objTNB.CRSWYY.Description		// 死亡原因
	Set SYICD		= objTNB.CRSYICD				// 死亡原因ICD
	Set JTSWYY		= objTNB.CRJTSWYY				// 具体死亡原因
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = KPBH_"^"_ZDLX_"^"_CRZD_"^"_ZDICD_"^"_BFZ_"^"_WHYS_"^"_CRTZ_"^"_CRSG_"^"_CRRS_"^"_JZS_"^"_LCBX_"^"_QTLCBX_"^"_ZYJCQK1_"^"_ZYJCQK2_"^"_ZYJCQK3_"^"_ZYJCQK4_"^"_ZYJCQK5_"^"_ZYJCQK6_"^"_ZYJCQK7_"^"_ZYJCQK8_"^"_ZYJCQK9_"^"_ZDRQ_"^"_ZGZDDW_"^"_SWRQ_"^"_SWYY_"^"_SYICD_"^"_JTSWYY_"^"_RepInfo
	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  获取糖尿病报卡字典信息
/// Table：       
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetTNBDicList()
ClassMethod GetTNBDicList() As %List
{
	Set return = ""
	Set BFZList 			= ..GetDictionary("CRBFZ")
	Set WHYSList 			= ..GetDictionary("CRWHYS")
	Set JZSList 			= ..GetDictionary("CRJZS")
	Set LCBXList 			= ..GetDictionary("CRLCBX")
	Set return =  $LB(BFZList,WHYSList,JZSList,LCBXList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  查询疑似职业病报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetYSZYBInfo(53)
ClassMethod GetYSZYBInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objYSZYB // 清除缓存
	Set (KPBH,YRDWMC,YRDWDZ,YRDWYB,YRDWLXR,YRDWLXRDH,JJLX,DWHY,QYGM,BRLY,ZYBZL,JTBM,ZDSGBM,TSZDRS,TJGZ,ZYGLN,ZYGLY,JCSJT,JCSJS,JCSJF,FSRQ,ZDRQ,SWRQ) = ""
	
	Set objYSZYB=##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(aReportID)
	Quit:'$IsObject(objYSZYB) $$$OK
	Set KPBH			= objYSZYB.CRKPBH
	// 用人单位信息
	Set YRDWMC			= objYSZYB.CRYRDWMC				// 用人单位名称
	Set YRDWDZ			= objYSZYB.CRYRDWDZ				// 通讯地址
	Set YRDWYB			= objYSZYB.CRYRDWYB				// 邮编
	Set YRDWLXR			= objYSZYB.CRYRDWLXR			// 联系人
	Set YRDWLXRDH		= objYSZYB.CRYRDWLXRDH			// 联系电话
	Set JJLX			= objYSZYB.CRJJLX				// 经济类型
	Set DWHY			= objYSZYB.CRDWHY				// 行业
	Set QYGM			= objYSZYB.CRQYGM.Description 	// 企业规模
	Set BRLY			= objYSZYB.CRBRLY.Description 	// 病人来源
	Set ZYBZL			= objYSZYB.CRZYBZL				// 职业病种类
	Set JTBM			= objYSZYB.CRJTBM				// 具体病名
	Set ZDSGBM			= objYSZYB.CRZDSGBM				// 中毒事故编码
	Set TSZDRS			= objYSZYB.CRTSZDRS				// 同时中毒人数
	Set TJGZ			= objYSZYB.CRTJGZ.Description   // 统计工种
	Set ZYGLN			= objYSZYB.CRZYGLN				// 专业工龄年
	Set ZYGLY			= objYSZYB.CRZYGLY				// 专业工龄月
	Set JCSJT			= objYSZYB.CRJCSJT				// 接触时间天
	Set JCSJS			= objYSZYB.CRJCSJS				// 接触时间时
	Set JCSJF			= objYSZYB.CRJCSJF				// 接触时间分
	Set FSRQ			= objYSZYB.CRFSRQ				// 发生日期
	Set:FSRQ'="" FSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FSRQ)
	Set ZDRQ			= objYSZYB.CRZDRQ				// 诊断日期
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
	Set SWRQ			= objYSZYB.CRSWRQ				// 死亡日期
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = KPBH_"^"_YRDWMC_"^"_YRDWDZ_"^"_YRDWYB_"^"_YRDWLXR_"^"_YRDWLXRDH_"^"_JJLX_"^"_DWHY_"^"_QYGM_"^"_BRLY_"^"_ZYBZL_"^"_JTBM_"^"_ZDSGBM_"^"_TSZDRS_"^"_TJGZ_"^"_ZYGLN_"^"_ZYGLY_"^"_JCSJT_"^"_JCSJS_"^"_JCSJF_"^"_FSRQ_"^"_ZDRQ_"^"_SWRQ_"^"_RepInfo
	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  获取糖尿病报卡字典信息
/// Table：       
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetYSZYBDicList()
ClassMethod GetYSZYBDicList() As %List
{
	Set return = ""
	Set QYGMList 			= ..GetDictionary("CRQYGM")
	Set BRLYList 			= ..GetDictionary("CRBRLY")
	Set TJGZList 			= ..GetDictionary("CRTJGZ")
	Set return =  $LB(QYGMList,BRLYList,TJGZList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  查询高温中暑报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetGWZSInfo(54)
ClassMethod GetGWZSInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objGWZS // 清除缓存
	Set (KPBH,ZSDD,ZSXZ,ZSLCBX,ZSZD,ZSZLGY,ZSZG,ZDRQ,SWRQ) = ""
	
	Set objGWZS=##class(DHCMed.CD.CRReportGWZS).GetObjByParRef(aReportID)
	Quit:'$IsObject(objGWZS) $$$OK
	Set KPBH	= objGWZS.CRKPBH				// 卡片编号
	Set ZSDD	= objGWZS.CRZSDD				// 中暑地点
	Set ZSXZ  	= objGWZS.CRZSXZ.Description	// 中暑性质
	Set ZSLCBX	= objGWZS.CRZSLCBX				// 临床表现
	Set ZSZD  	= objGWZS.CRZSZD.Description	// 诊断
	Set ZSZLGY	= objGWZS.CRZLGY				// 治疗概要
	Set ZSZG	= objGWZS.CRZSZG.Description	// 转归
	Set ZDRQ	= objGWZS.CRZDRQ				// 诊断日期
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
	Set SWRQ	= objGWZS.CRSWRQ				// 死亡日期
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = KPBH_"^"_ZSDD_"^"_ZSXZ_"^"_ZSLCBX_"^"_ZSZD_"^"_ZSZLGY_"^"_ZSZG_"^"_ZDRQ_"^"_SWRQ_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  获取糖尿病报卡字典信息
/// Table：       
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetGWZSDicList()
ClassMethod GetGWZSDicList() As %List
{
	Set return = ""
	Set ZSXZList 			= ..GetDictionary("CRZSXZ")
	Set ZSZDList 			= ..GetDictionary("CRZSZD")
	Set ZSZGList 			= ..GetDictionary("CRZSZG")
	Set return =  $LB(ZSXZList,ZSZDList,ZSZGList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  查询农药中毒报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetNYZDInfo(54)
ClassMethod GetNYZDInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objNY // 清除缓存
	Set (KPBH,ZDNYMC,NYZLSL,ZDYY,ZSPX,SYFS,WXXW,ZDZG,ZGQT,ZDRQ,SWRQ) = ""
	Set objNY=##class(DHCMed.CD.CRReportNYZD).GetObjByParRef(aReportID)
	Quit:'$IsObject(objNY) $$$OK
	Set KPBH 	= objNY.CRKPBH					// 卡片编号
	Set ZDNYMC	= objNY.CRZDNYMC				// 中毒信息
	Set NYZLSL	= objNY.CRNYZLSL.Description	// 种类数量
	Set ZDYY  	= objNY.CRZDYY.Description		// 中毒原因
	Set ZSPX  	= objNY.CRZSPX.Description		// 知识培训
	Set SYFS  	= objNY.CRSYFS.Description		// 施药方式
	Set WXXW  =""
	For index=1:1:objNY.CRWXXW.Count() {
		Set objDic=objNY.CRWXXW.GetAt(index)
		Continue:'$IsObject(objDic)
		Set WXXW=WXXW_","_objDic.Description
	}
	Set:WXXW'="" WXXW=$e(WXXW,2,*)				// 危险行为
	Set ZDZG	= objNY.CRZDZG.Description		// 转归
	Set ZGQT=""
	Set:ZDZG="其他" ZGQT=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTZG")	// 其他转归
	Set ZDRQ	= objNY.CRZDRQ
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
	Set SWRQ	= objNY.CRSWRQ
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = KPBH_"^"_ZDNYMC_"^"_NYZLSL_"^"_ZDYY_"^"_ZSPX_"^"_SYFS_"^"_WXXW_"^"_ZDZG_"^"_ZGQT_"^"_ZDRQ_"^"_SWRQ_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  获取农药中毒报卡字典信息
/// Table：       
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetNYZDDicList()
ClassMethod GetNYZDDicList() As %List
{
	Set return = ""
	Set NYZLSLList 			= ..GetDictionary("CRNYZLSL")
	Set ZDYYList 			= ..GetDictionary("CRZDYY")
	Set ZSPXList 			= ..GetDictionary("CRZSPX")
	Set SYFSList 			= ..GetDictionary("CRSYFS")
	Set WXXWList 			= ..GetDictionary("CRWXXW")
	Set ZDZGList 			= ..GetDictionary("CRZDZG")
	Set return =  $LB(NYZLSLList,ZDYYList,ZSPXList,SYFSList,WXXWList,ZDZGList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  查询非职业CO中毒报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetFZYCOInfo(56)
ClassMethod GetFZYCOInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objCO // 清除缓存
	Set (KPBH,COZDRQ,COZDSJ,ZDYY,ZDCS,ZDYS,ZYZZ,QTZZ,ZDZD,JZCS,COZG,ZDRQ,SWRQ) = ""
	Set objCO=##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(aReportID)
	Quit:'$IsObject(objCO) $$$OK
	
	Set KPBH		= objCO.CRKPBH			// 卡片编号
	Set COZDRQ		= objCO.CRCOZDRQ		// 中毒日期
	Set:COZDRQ'="" COZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(COZDRQ)
	Set COZDSJ		= objCO.CRCOZDSJ		// 中毒时间
	Set:COZDSJ'="" COZDSJ=##Class(DHCMed.SSService.CommonCls).ChangeTimeFormat(COZDSJ)
	
	Set ZDYY		= objCO.CRZDYY.Description	// 中毒原因
	Set ZDCS		= objCO.CRZDCS.Description	// 中毒场所
	Set ZDYS		= objCO.CRZDYS.Description	// 中毒因素
	Set ZYZZ=""		
	For index=1:1:objCO.CRZYZZ.Count() {
		Set objDic=objCO.CRZYZZ.GetAt(index)
		Continue:'$IsObject(objDic)
		Set ZYZZ=ZYZZ_","_objDic.Description
	}
	Set:ZYZZ'="" ZYZZ=$e(ZYZZ,2,*)				// 主要症状
	Set QTZZ=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTZZ")	// 其他症状
	Set ZDZD=objCO.CRZDZD.Description			// 中毒诊断
	Set JZCS=""
	For index=1:1:objCO.CRJZCS.Count() {
		Set objDic=objCO.CRJZCS.GetAt(index)
		Continue:'$IsObject(objDic)
		Set JZCS=JZCS_","_objDic.Description
	}
	Set:JZCS'="" JZCS=$e(JZCS,2,*)				// 救治措施
	Set COZG=objCO.CRCOZG.Description			// 转归
	//报告信息
	Set ZDRQ=objCO.CRZDRQ
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
	Set SWRQ=objCO.CRSWRQ
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = KPBH_"^"_COZDRQ_"^"_COZDSJ_"^"_ZDYY_"^"_ZDCS_"^"_ZDYS_"^"_ZYZZ_"^"_QTZZ_"^"_ZDZD_"^"_JZCS_"^"_COZG_"^"_ZDRQ_"^"_SWRQ_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  获取非职业CO中毒报卡字典信息
/// Table：       
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetFZYCODicList()
ClassMethod GetFZYCODicList() As %List
{
	Set return = ""
	Set COZDYYList 			= ..GetDictionary("CRCOZDYY")
	Set ZDCSList 			= ..GetDictionary("CRZDCS")
	Set ZDYSList 			= ..GetDictionary("CRZDYS")
	Set ZYZZList 			= ..GetDictionary("CRZYZZ")
	Set ZDZDList 			= ..GetDictionary("CRZDZD")
	Set JZCSList 			= ..GetDictionary("CRJZCS")
	Set COZGList 			= ..GetDictionary("CRCOZG")
	Set return =  $LB(COZDYYList,ZDCSList,ZDYSList,ZYZZList,ZDZDList,JZCSList,COZGList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-05
/// Description:  查询伤害报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetSHKInfo(57)
ClassMethod GetSHKInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objSHK // 清除缓存
	Set (YYBH,KPBH,SHFSRQ,SHFSSJ,HZJZRQ,HZJZSJ,SHFSYY,SHFSDD,SHFSSHD,SHSFGY,SHXZ,SHBW,SHYZCD,SHZD,SHZDICD,SHJJ,CPMC1,CPXH1,CPFL1,CPMC2,CPXH2,CPFL2,DXAL) = ""
	
	Set objSHK=##class(DHCMed.CD.CRReportSHK).GetObjByParRef(aReportID)
	Quit:'$IsObject(objSHK) $$$OK
	
	Set YYBH		= objSHK.CRYYBH			// 医院编号
	Set KPBH		= objSHK.CRKPBH			// 卡片编号
	Set SHFSRQ		= objSHK.CRSHFSRQ		// 伤害发生日期
	Set:SHFSRQ'="" SHFSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SHFSRQ)
	Set SHFSSJ		= objSHK.CRSHFSSJ		// 伤害发生时间
	Set SHFSSJ		= $Extract(SHFSSJ,1,2)
	Set HZJZRQ		= objSHK.CRHZJZRQ		// 患者就诊日期
	Set:HZJZRQ'="" HZJZRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HZJZRQ)
	Set HZJZSJ		= objSHK.CRHZJZSJ		// 患者就诊时间
	Set HZJZSJ		= $Extract(HZJZSJ,1,2)	
	Set SHFSYY		= objSHK.CRSHFSYY.Description	// 伤害发生原因
	Set:SHFSYY="" SHFSYY=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTYY")
	Set SHFSDD		= objSHK.CRSHFSDD.Description	// 伤害发生地点	
	Set:SHFSDD="" SHFSDD=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTDD")
	Set SHFSSHD		= objSHK.CRSHFSSHD.Description	// 伤害发生时活动
	Set:SHFSSHD="" SHFSSHD=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTHD")
	Set SHSFGY		= objSHK.CRSHSFGY.Description 	// 是否故意
	Set SHXZ		= objSHK.CRSHXZ.Description		// 伤害性质
	Set:SHXZ="" SHXZ=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTXZ")
	Set SHBW		= objSHK.CRSHBW.Description		// 伤害部位
	Set:SHBW="" SHBW=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTBW")
	Set SHYZCD		= objSHK.CRSHYZCD.Description 	// 伤害严重程度
	
	Set ICDstr		= ##class(DHCMed.CD.CRReportSHK).GetICDDescByID(objSHK.CRSHZD)
	Set SHZD		= $p(ICDstr,$c(1),2)			// 伤害诊断
	Set SHZDICD		= $p(ICDstr,$c(1),3)			// 伤害诊断ICD
	Set SHJJ		= objSHK.CRSHJJ.Description		// 伤害结局
	//产品信息
	Set CPMC1		= objSHK.CRCPMC1
	Set CPXH1		= objSHK.CRCPXH1
	Set CPFL1		= objSHK.CRCPFL1.Description
	Set CPMC2		= objSHK.CRCPMC2
	Set CPXH2		= objSHK.CRCPXH2
	Set CPFL2		= objSHK.CRCPFL2.Description
	//典型案例
	Set DXAL=""	
	For index=1:1:objSHK.CRDXAL.Count() {
		Set objDic=objSHK.CRDXAL.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set DXAL=DXAL_","_SubDesc
	}
	Set:DXAL'="" DXAL=$e(DXAL,2,*)
	
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = YYBH_"^"_KPBH_"^"_SHFSRQ_"^"_SHFSSJ_"^"_HZJZRQ_"^"_HZJZSJ_"^"_SHFSYY_"^"_SHFSDD_"^"_SHFSSHD_"^"_SHSFGY_"^"_SHXZ_"^"_SHBW_"^"_SHYZCD_"^"_SHZD_"^"_SHZDICD_"^"_SHJJ_"^"_CPMC1_"^"_CPXH1_"^"_CPFL1_"^"_CPMC2_"^"_CPXH2_"^"_CPFL2_"^"_DXAL_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  获取非职业CO中毒报卡字典信息
/// Table：       
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetSHKDicList()
ClassMethod GetSHKDicList() As %List
{
	Set return = ""
	Set SHSFGYList 			= ..GetDictionary("CRSHSFGY")
	Set SHYZCDList 			= ..GetDictionary("CRSHYZCD")
	Set SHJJList 			= ..GetDictionary("CRSHJJ")
	Set SHDYALList 			= ..GetDictionary("CRSHDYAL")
	Set return =  $LB(SHSFGYList,SHYZCDList,SHJJList,SHDYALList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-05
/// Description:  查询伤害报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetCSQXInfo(58)
ClassMethod GetCSQXInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objCSQX // 清除缓存
	Set (KPBH,HJLX,JTNRJSR,YC,CC,IsHJ,IsFZSZ,JZDSSQ,JZSJ,CSRQ,CSYY,XB,TS,TLYL,TL,TZ,SC,JXS,IsZLXYC,JXQZSJ,CQZDYZ,CQZDYY,ZDYJ,ZDYJTxt,ZG,ZD,ZDZY,ZDXTXXZB,ZDNDXL,ZDDZHPXLX,ZDTxt,YZQHBFR,YZQHBBDGR,YZQHBTNB,YZQHBTxt,YZQFYHAL,YZQFYKSS,YZQFYBYY,YZQFYZJY,YZQFYTxt,YZQQTYJ,YZQQTNY,YZQQTSX,YZQQTHXZJ,YZQQTTxt,JZSYYCSYS,JZSYST,JZSYZRLC,JZSYQXE,JZSYQXM,JZYCQXM1,JZYCQYGX1,JZYCQXM2,JZYCQYGX2,JZYCQXM3,JZYCQYGX3,JZHPIsJQ,JZHPJQGX) = ""
	
	Set objCSQX=##class(DHCMed.CD.CRReportCSQX).GetObjByParRef(aReportID)
	Quit:'$IsObject(objCSQX) $$$OK
	Set KPBH		= objCSQX.CRKPBH					// 卡片编号
	Set HJLX		= objCSQX.CRHJLXDr.Description		// 户籍类型
	Set JTNRJSR		= objCSQX.CRJTNRJSRDr.Description	// 家庭年人均收入
	Set YC			= objCSQX.CRYC						// 孕次
	Set CC			= objCSQX.CRCC						// 产次
	Set IsHJ		= objCSQX.CRIsHJ					// 是否婚检
	Set IsFZSZ		= objCSQX.CRIsFZSZ					// 是否辅助生殖
	Set JZDSSQ		= objCSQX.CRJZDSSQ					// 居住地所属区
	Set JZSJ		= objCSQX.CRJZSJ					// 居住时间
	/*缺陷儿信息*/
	Set CSRQ		= objCSQX.CRCSRQ					// 出生日期
	Set:CSRQ'="" CSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CSRQ)
	Set CSYY		= objCSQX.CRCSYY					// 出生医院
	Set XB			= objCSQX.CRXBDr.Description		// 性别
	Set TS			= objCSQX.CRTSDr.Description		// 胎数
	Set TLYL		= objCSQX.CRTLYLDr.Description		// 同卵异卵		
	Set TL			= objCSQX.CRTL						// 胎龄
	Set TZ			= objCSQX.CRTZ						// 体重
	Set SC			= objCSQX.CRSC						// 身长
	Set JXS			= objCSQX.CRJXS						// 畸形数
	Set IsZLXYC		= objCSQX.CRIsZLXYC					// 为出生缺陷后治疗性引产
	Set JXQZSJ		= objCSQX.CRJXQZSJDr.Description	// 畸形确诊时间
	Set CQZDYZ		= objCSQX.CRCQZDYZ					// 产前诊断孕周
	Set CQZDYY		= objCSQX.CRCQZDYY					// 产前诊断医院
	Set ZDYJ		= objCSQX.CRZDYJDr.Description		// 诊断依据
	Set ZDYJTxt		= objCSQX.CRZDYJTxt					// 诊断备注
	Set ZG			= objCSQX.CRZGDr.Description		// 转归
	Set ZD			= objCSQX.CRZDDr.Description		// 缺陷诊断
	Set ZDZY	    = objCSQX.CRZDZYDr.Description		// 位置
	Set ZDXTXXZB	= objCSQX.CRZDXTXXZBDr.Description	// 先心病类型
	Set ZDNDXL		= objCSQX.CRZDNDXL					// 尿道下裂
	Set ZDDZHPXLX	= objCSQX.CRZDDZHPXLXDr				// 胎儿水中综合征
	Set ZDTxt		= objCSQX.CRZDTxt					// 其他缺陷
	/*产妇孕早期情况*/
	Set YZQHBFR		= objCSQX.CRYZQHBFR					// 发热
	Set YZQHBBDGR	= objCSQX.CRYZQHBBDGR				// 病毒感染类型
	Set YZQHBTNB	= objCSQX.CRYZQHBTNB				// 糖尿病
	Set YZQHBTxt	= objCSQX.CRYZQHBTxt				// 其他
	Set YZQFYHAL	= objCSQX.CRYZQFYHAL				// 磺胺类
	Set YZQFYKSS	= objCSQX.CRYZQFYKSS				// 抗生素
	Set YZQFYBYY	= objCSQX.CRYZQFYBYY				// 避孕药
	Set YZQFYZJY	= objCSQX.CRYZQFYZJY				// 镇静药
	Set YZQFYTxt	= objCSQX.CRYZQFYTxt				// 其他药
	Set YZQQTYJ		= objCSQX.CRYZQQTYJ					// 饮酒剂量
	Set YZQQTNY		= objCSQX.CRYZQQTNY					// 农药名称
	Set YZQQTSX		= objCSQX.CRYZQQTSX					// 射线种类
	Set YZQQTHXZJ	= objCSQX.CRYZQQTHXZJ				// 化学制剂
	Set YZQQTTxt	= objCSQX.CRYZQQTTxt				// 其他有害因素
	/*家族史*/
	Set JZSYYCSYSDrs= objCSQX.CRJZSYYCSYSDr				// 异常生育史
	Set JZSYYCSYS= ""
	For indDic=1:1:$l(JZSYYCSYSDrs,",") {
		Set tDicID=$p(JZSYYCSYSDrs,",",indDic)
		Continue:tDicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(tDicID)
		Set JZSYYCSYS = JZSYYCSYS_","_objDic.Description
	}
	Set:JZSYYCSYS'="" JZSYYCSYS = $e(JZSYYCSYS,2,*)
	
	
	Set JZSYST		= objCSQX.CRJZSYST					// 死胎
	Set JZSYZRLC	= objCSQX.CRJZSYZRLC				// 自然流产
	Set JZSYQXE		= objCSQX.CRJZSYQXE					// 缺陷儿
	Set JZSYQXM		= objCSQX.CRJZSYQXM					// 缺陷名
	Set JZYCQXM1	= objCSQX.CRJZYCQXM1				// 遗传史1
	Set JZYCQYGX1	= objCSQX.CRJZYCQYGX1				// 亲缘关系1
	Set JZYCQXM2	= objCSQX.CRJZYCQXM2				// 遗传史2
	Set JZYCQYGX2	= objCSQX.CRJZYCQYGX2				// 亲缘关系2
	Set JZYCQXM3	= objCSQX.CRJZYCQXM3				// 遗传史3
	Set JZYCQYGX3	= objCSQX.CRJZYCQYGX3				// 亲缘关系3
	Set JZHPIsJQ	= objCSQX.CRJZHPIsJQ				// 是否近亲婚配
	Set JZHPJQGX	= objCSQX.CRJZHPJQGX				// 婚配双方关系
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = KPBH_"^"_HJLX_"^"_JTNRJSR_"^"_YC_"^"_CC_"^"_IsHJ_"^"_IsFZSZ_"^"_JZDSSQ_"^"_JZSJ_"^"_CSRQ_"^"_CSYY_"^"_XB_"^"_TS_"^"_TLYL_"^"_TL_"^"_TZ_"^"_SC_"^"_JXS_"^"_IsZLXYC_"^"_JXQZSJ_"^"_CQZDYZ_"^"_CQZDYY_"^"_ZDYJ_"^"_ZDYJTxt_"^"_ZG_"^"_ZD_"^"_ZDZY_"^"_ZDXTXXZB_"^"_ZDNDXL_"^"_ZDDZHPXLX_"^"_ZDTxt_"^"_YZQHBFR_"^"_YZQHBBDGR_"^"_YZQHBTNB_"^"_YZQHBTxt_"^"_YZQFYHAL_"^"_YZQFYKSS_"^"_YZQFYBYY_"^"_YZQFYZJY_"^"_YZQFYTxt_"^"_YZQQTYJ_"^"_YZQQTNY_"^"_YZQQTSX_"^"_YZQQTHXZJ_"^"_YZQQTTxt_"^"_JZSYYCSYS_"^"_JZSYST_"^"_JZSYZRLC_"^"_JZSYQXE_"^"_JZSYQXM_"^"_JZYCQXM1_"^"_JZYCQYGX1_"^"_JZYCQXM2_"^"_JZYCQYGX2_"^"_JZYCQXM3_"^"_JZYCQYGX3_"^"_JZHPIsJQ_"^"_JZHPJQGX_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-05
/// Description:  查询伤害报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetETSHInfo(59)
ClassMethod GetETSHInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objETSH // 清除缓存
	Set objETSH=##class(DHCMed.CD.CRReportETSH).GetObjByParRef(aReportID)
	Quit:'$IsObject(objETSH) $$$OK
	Set (HospNumber,AdmLocType,CRKPBH,Weight,Height,ChildSchool,ChildRegister,FatherEdc,MotherEdc,HappenTime,AdmTime,HappenResaon,OtherResaon,HappenPlace,OtherPlace,HappenActivity,OtherActivity,IsWillfully,OtherWillfully,IsDrink,IsCaregiver,CaregiverType,CaregiverStatus,OtherStatus,Injure,Otherinjure,InjurePalce,OtherInjurePalce,InjureSystem,OtherInjureSystem,PTSScore,AirwayStatus,SBP,CentralSystem,OpenWound,Fracture,InjurySeverity,InjuryDiag,InjuryEnd,OtherEnd)=""
	
	Set HospNumber 		= objETSH.HospNumber
	Set AdmLocType 		= objETSH.AdmLocType.Description
	Set CRKPBH 			= objETSH.CRKPBH
	Set Weight 			= objETSH.ChildWeight_"kg"
	Set Height 			= objETSH.ChildHeight_"cm"
	Set ChildSchool 	= objETSH.ChildSchool.Description
	Set ChildRegister 	= objETSH.ChildRegister.Description
	Set FatherEdc 		= objETSH.FatherEdc.Description
	Set MotherEdc 		= objETSH.MotherEdc.Description
	Set HappenTime 		= objETSH.HappenTime
	Set AdmTime 		= objETSH.AdmTime
	Set HappenResaon 	= objETSH.HappenResaon.Description
	Set OtherResaon 	= objETSH.OtherResaon
	Set HappenPlace 	= objETSH.HappenPlace.Description
	Set OtherPlace 		= objETSH.OtherPlace
	Set HappenActivity 	= objETSH.HappenActivity.Description
	Set OtherActivity 	= objETSH.OtherActivity
	Set IsWillfully 	= objETSH.IsWillfully.Description
	Set OtherWillfully 	= objETSH.OtherWillfully
	Set IsDrink 		= objETSH.IsDrink.Description
	Set IsCaregiver 	= objETSH.IsCaregiver.Description
	Set CaregiverType 	= objETSH.CaregiverType.Description
	Set CaregiverStatus = objETSH.CaregiverStatus.Description
	Set OtherStatus 	= objETSH.OtherStatus
	Set Injure 			= objETSH.Injure.Description
	Set Otherinjure 	= objETSH.Otherinjure
	Set InjurePalce 	= objETSH.InjurePalce.Description
	Set OtherInjurePalce = objETSH.OtherInjurePalce
	Set InjureSystem 	= objETSH.InjureSystem.Description
	Set OtherInjureSystem = objETSH.OtherInjureSystem
	Set PTSScore 		= objETSH.PTSScore
	Set AirwayStatus 	= objETSH.AirwayStatus.Description
	Set SBP 			= objETSH.SBP.Description
	Set CentralSystem 	= objETSH.CentralSystem.Description
	Set OpenWound 		= objETSH.OpenWound.Description
	Set Fracture 		= objETSH.Fracture.Description
	Set InjurySeverity  = objETSH.InjurySeverity.Description
	Set InjuryDiag 		= objETSH.InjuryDiag
	Set InjuryEnd  		= objETSH.InjuryEnd.Description
	Set OtherEnd 		= objETSH.OtherEnd
	
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = HospNumber_"^"_AdmLocType_"^"_CRKPBH_"^"_Weight_"^"_Height_"^"_ChildSchool_"^"_ChildRegister_"^"_FatherEdc_"^"_MotherEdc_"^"_HappenTime_"^"_AdmTime_"^"_HappenResaon_"^"_OtherResaon_"^"_HappenPlace_"^"_OtherPlace_"^"_HappenActivity_"^"_OtherActivity_"^"_IsWillfully_"^"_OtherWillfully_"^"_IsDrink_"^"_IsCaregiver_"^"_CaregiverType_"^"_CaregiverStatus_"^"_OtherStatus_"^"_Injure_"^"_Otherinjure_"^"_InjurePalce_"^"_OtherInjurePalce_"^"_InjureSystem_"^"_OtherInjureSystem_"^"_PTSScore_"^"_AirwayStatus_"^"_SBP_"^"_CentralSystem_"^"_OpenWound_"^"_Fracture_"^"_InjurySeverity_"^"_InjuryDiag_"^"_InjuryEnd_"^"_OtherEnd_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  获取非职业CO中毒报卡字典信息
/// Table：       
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetETSHDicList()
ClassMethod GetETSHDicList() As %List
{
	Set return = ""
	Set HappenReasonList 			= ..GetDictionary("ETSHHappenReason")
	Set HappenPlaceList 			= ..GetDictionary("ETSHHappenPlace")
	Set InjuryActiveList 			= ..GetDictionary("ETSHInjuryActive")
	Set IsWillfullyList 			= ..GetDictionary("ETSHIsWillfully")
	Set IsDrinkList 				= ..GetDictionary("ETSHIsDrink")
	Set IsCaregiverList 			= ..GetDictionary("ETSHIsCaregiver")
	Set CaregiverTypeList 			= ..GetDictionary("ETSHCaregiverType")
	Set CaregiverStatusList 		= ..GetDictionary("ETSHCaregiverStatus")
	Set InjuryList 					= ..GetDictionary("ETSHInjury")
	Set InjuryPlaceList 			= ..GetDictionary("ETSHInjuryPlace")
	Set InjurySystemList 			= ..GetDictionary("ETSHInjurySystem")
	Set AirwayStatusList 			= ..GetDictionary("ETSHAirwayStatus")
	Set SBPList 					= ..GetDictionary("ETSHSBP")
	Set CentralSystemList 			= ..GetDictionary("ETSHCentralSystem")
	Set OpenWoundList 				= ..GetDictionary("ETSHOpenWound")
	Set FractureList 				= ..GetDictionary("ETSHFracture")
	Set InjurySeverityList 			= ..GetDictionary("ETSHInjurySeverity")
	Set InjuryEndList 				= ..GetDictionary("ETSHInjuryEnd")
	
	Set return =  $LB(HappenReasonList,HappenPlaceList,InjuryActiveList,IsWillfullyList,IsDrinkList,IsCaregiverList,CaregiverTypeList,CaregiverStatusList,InjuryList,InjuryPlaceList,InjurySystemList,AirwayStatusList,SBPList,CentralSystemList,OpenWoundList,FractureList,InjurySeverityList,InjuryEndList)
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-07
/// Description:  查询慢性病报卡 
/// Return:       
/// w ##class(DHCMed.CDService.LodopRepSrv).GetMBBKInfo(60)
ClassMethod GetMBBKInfo(aReportID As %String) As %String
{
	new (aReportID)
	Set return = ""
	Quit:aReportID="" return
	Kill objMBBK
	Set (BGKLX,KPBH,FBRQ,SFFBRQGJ,QZRQ,SWRQ,JTSWYY,MBZDYJ,QZDW,SBWZ,GXBZD,NCZZD,TNBZD,GZZD,ZDMC,YFBW,JFBW,BLXLX,ZDBM) = ""
	Quit:aReportID="" $$$OK
	
	Set objMBBK=##class(DHCMed.CD.CRReportMBBK).GetObjByParRef(aReportID)
	Quit:'$IsObject(objMBBK) $$$OK
	//报告卡类型
	Set BGKLX=objMBBK.CRBGKLX.Description        
	//卡片编号
	Set KPBH=objMBBK.CRKPBH
	//诊断、报告信息
	//发病日期
	Set FBRQ=objMBBK.CRFBRQ
	Set:FBRQ'="" FBRQ=$zd(FBRQ,3)
	//是否发病日期为估计
	Set SFFBRQGJ=objMBBK.CRSFFBRQGJ.Description   
	//确诊日期
	Set QZRQ=objMBBK.CRQZRQ
	Set:QZRQ'="" QZRQ=$zd(QZRQ,3)
	Set SWRQ=objMBBK.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set JTSWYY=objMBBK.CRJTSWYY
	//诊断依据  
	Set MBZDYJ=""
	For i=1:1:objMBBK.CRZDYJ.Count() {
		Set objDic=objMBBK.CRZDYJ.GetAt(i)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description 
		Set MBZDYJ=MBZDYJ_","_SubDesc
	}
	Set:MBZDYJ'="" MBZDYJ=$e(MBZDYJ,2,*)
	Set QZDW = objMBBK.CRQZDW.Description
	//上报位置（病房、门诊）
	Set SBWZ   =objMBBK.CRSBWZ.Description
	Set Type=1
	If ((BGKLX="更正")&&(objMBBK.CRGZZD'="")) {
		Set Type=0
	}
	Set GXBZD=objMBBK.CRGXBZD.Description
	Set NCZZD=objMBBK.CRNCZZD.Description
	Set TNBZD=objMBBK.CRTNBZD.Description
	Set GZZD =##class(DHCMed.CD.CRReportXNXG).GetICDDescByID(objMBBK.CRGZZD)  
	Set GZZD =$p(GZZD,$c(1),2)
	Set ZDMC =##class(DHCMed.CD.CRReportXNXG).GetICDDescByID(objMBBK.CRZDMC)  
	Set ZDMC =$p(ZDMC,$c(1),2)
	Set YFBW =objMBBK.CRYFBW
	Set JFBW =objMBBK.CRJFBW
	Set BLXLX=objMBBK.CRBLXLX
	Set ZDBM =objMBBK.CRZDBM
	
	Set RepInfo=..GetRepInfo(aReportID)
	Set return = BGKLX_"^"_KPBH_"^"_FBRQ_"^"_SFFBRQGJ_"^"_QZRQ_"^"_SWRQ_"^"_JTSWYY_"^"_MBZDYJ_"^"_QZDW_"^"_SBWZ_"^"_GXBZD_"^"_NCZZD_"^"_TNBZD_"^"_GZZD_"^"_ZDMC_"^"_YFBW_"^"_JFBW_"^"_BLXLX_"^"_ZDBM_"^"_RepInfo
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-07-04
/// Description:  获取非职业CO中毒报卡字典信息
/// Table：       
/// Input：      
/// Return：
/// zw ##Class(DHCMed.CDService.LodopRepSrv).GetMBBKDicList()
ClassMethod GetMBBKDicList() As %List
{
	Set return = ""
	Set MBReportTypeList 	= ..GetDictionary("CRMBReportType")
	Set MBSFFBRQGJList 		= ..GetDictionary("CRMBSFFBRQGJ")
	Set MBZDYJList 			= ..GetDictionary("CRMBZDYJ")
	Set MBSBWZList 			= ..GetDictionary("CRMBSBWZ")
	Set return =  $LB(MBReportTypeList,MBSFFBRQGJList,MBZDYJList,MBSBWZList)
	Quit return
}

}
