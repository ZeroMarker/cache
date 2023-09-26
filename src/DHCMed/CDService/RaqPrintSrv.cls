/// 名称 : DHCMed.CDService.RaqPrintSrv
/// 描述 : 润乾报表打印query
/// 编写者：liuzhenhe
/// 编写日期: 2019-11-13
Class DHCMed.CDService.RaqPrintSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-15
/// Description:  查询慢病报卡： 
/// Return:       报告单位,报告医生,报告时间,科室(部分报卡用到)
/// w ##class(DHCMed.CDService.RaqPrintSrv).GetRepInfoByID(1)
ClassMethod GetRepInfoByID(aReportID As %String) As %String
{
	new (aReportID)
	Set return=$lb("","","")
	Set (ReportOrgan,ReportUser,ReportDate,LocDesc,CRCheckDate,CRCheckUser,UserCABaseImg) = ""
	Quit:aReportID="" return
	Kill objRep
	Kill objReportUser
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Set RepTypeCode=objRep.CRReportType.CRFCode
	Set ReportOrgan= objRep.CRReportOrgan
	Set ReportUser = objRep.CRReportUser
	Set ReportUserID = ""
	if ((RepTypeCode="ZLK")){
		set objReportUser=##Class(DHCMed.Base.SSUser).GetObjById(+ReportUser)
		set ReportUserDesc=objReportUser.Rowid_","_objReportUser.Name
		Set ReportUserID = $p(ReportUserDesc,",",1)
		Set ReportUser = $p(ReportUserDesc,",",2)
	}

	Set ReportDate = objRep.CRReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set LocID      = objRep.CRReportLoc
	Set LocDesc    = $p($g(^CTLOC(+LocID)),"^",2)
	Set:$p(LocDesc,"-",2)'="" LocDesc = $p(LocDesc,"-",2) 
	
	Set CRCheckDate = objRep.CRCheckDate
	Set:CRCheckDate'="" CRCheckDate=$zd(CRCheckDate,3)
	Set CRCheckUser = objRep.CRCheckUser
	Set objCheckUser = ""
	Set:CRCheckUser'="" objCheckUser = ##Class(DHCMed.Base.SSUser).GetObjById(+CRCheckUser)
	Set:$IsObject(objCheckUser) CRCheckUser = objCheckUser.Name
	
	Set ClassExist = ##class(%Dictionary.ClassDefinition).%ExistsId("CA.BICAService")
	if ((ClassExist=1)&&(ReportUserID'="")){
		Set UserCABaseImg = ##class(CA.BICAService).GetImageByUserID(ReportUserID)
		Set:UserCABaseImg'="" UserCABaseImg="data:image/png;base64,"_UserCABaseImg
	}
	Set return=$lb(ReportOrgan,ReportUser,ReportDate,LocDesc,CRCheckDate,CRCheckUser,UserCABaseImg)
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-13
/// Description:  查询慢病病人基础信息
/// Table：       DHCMed.CD.CRReportPAT  
/// Output:  	  MZH:门诊号,ZYH住院号,DJH:登记号,CRXM:姓名,SFZH:身份证号,CRXB:性别,PatAge:年龄,CRCSRQ:出生日期,CRZY:住院号,CRGZ:工种,CRMZ:民族,CRJTDH:家庭电话,CRGZDW:工作单位)
/// 		      常住地址->  CZDZS:省,CZDZS2:市,CZDZX:县,CZDZX2:乡,CZDZC:村,CZDZXX:详细地址)
/// 		      户籍地址->  HJDZS:省,HJDZS2,HJDZX,HJDZX2,HJDZC,HJDZXX)  
///         补充：WHCD:%String,LXDH:%String,CRHJ:%String
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryCDPat","1")
Query QryCDPat(aReportID As %String = "") As %Query(ROWSPEC = "MZH:%String,ZYH:%String,DJH:%String,CRXM:%String,SFZH:%String,CRXB:%String,PatAge:%String,CSRQ:%String,CRZY:%String,CRGZ:%String,CRMZ:%String,JTDH:%String,GZDW:%String,CZDZS:%String,CZDZS2:%String,CZDZX:%String,CZDZX2:%String,CZDZC:%String,CZDZXX:%String,HJDZS:%String,HJDZS2:%String,HJDZX:%String,HJDZX2:%String,HJDZC:%String,HJDZXX:%String,WHCD:%String,LXDH:%String,CRHJ:%String,HYZK:%String") [ SqlProc ]
{
}

ClassMethod QryCDPatExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Kill objPAT
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
	Set HJDZS=objPAT.CRHJDZS.ShortDesc
	Set HJDZS2=objPAT.CRHJDZS2.ShortDesc
	Set HJDZX=objPAT.CRHJDZX.ShortDesc
	Set HJDZX2=objPAT.CRHJDZX2.ShortDesc
	Set HJDZC=objPAT.CRHJDZC
	Set HJDZXX=objPAT.CRHJDZXX
	if (CZDZXX=""){
		Set CZDZXX = CZDZS_CZDZS2_CZDZX_CZDZX2_CZDZC
	}
	if (HJDZXX=""){
		Set HJDZXX = HJDZS_HJDZS2_HJDZX_HJDZX2_HJDZC
	}
	
	
	//  患者文化程度 联系电话 户籍 婚姻
	Set WHCD=objPAT.CRWHCD.Description
	Set LXDH=objPAT.CRLXDH
	Set CRHJ=objPAT.CRHJ
	Set HYZK=objPAT.CRHYZK.Description

	Set Data=$lb(MZH,ZYH,DJH,CRXM,SFZH,CRXB,PatAge,CSRQ,CRZY,CRGZ,CRMZ,JTDH,GZDW)
	Set Data=Data_$lb(CZDZS,CZDZS2,CZDZX,CZDZX2,CZDZC,CZDZXX,HJDZS,HJDZS2,HJDZX,HJDZX2,HJDZC,HJDZXX)
	Set Data=Data_$lb(WHCD,LXDH,CRHJ,HYZK)
	
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryCDPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCDPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCDPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCDPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-13
/// Description:  查询肿瘤病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportZLK ,DHCMed.CD.CRReport
/// Output:       KPBH:卡片编号,BQYGZBR:病情已告知病人,ZDBW:诊断部位,CRZD:诊断,ZDICD:诊断ICD-10,BLXLX:病理学类型,YZD:原诊断,BLH:病理号
///               YZDRQ:原诊断日期,TNMFQT:TNM分期-T,TNMFQN:TNM分期-N,TNMFQM:TNM分期-M,FHCD:分化程度
///               ZDRQ:诊断日期,ZGZDDW:最高诊断单位,SWRQ:死亡日期,SWYY:死亡原因,SYICD:死因ICD-10,JTSWYY:死亡具体原因
///               BSZY:病史摘要,ZDYJ:诊断依据
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepZLK","16")
Query QryRepZLK(aReportID As %String = "") As %Query(ROWSPEC = "KPBH:%String,BQYGZBR:%String,ZDBW:%String,CRZD:%String,ZDICD:%String,BLXLX:%String,YZD:%String,BLH:%String,YZDRQ:%String,TNMFQT:%String,TNMFQN:%String,TNMFQM:%String,FHCD:%String,ZDRQ:%String,ZGZDDW:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String,CRCheckDate:%String,CRCheckUser:%String,UserCABaseImg:%String,SWRQ:%String,SWYY:%String,SYICD:%String,JTSWYY:%String,BSZY:%String,ZDYJ:%String,CardType:%String,ContactOne:%String,RelationOne:%String,PhoneOne:%String,ContactTwo:%String,RelationTwo:%String,PhoneTwo:%String,ContactThr:%String,RelationThr:%String,PhoneThr:%String,AttackDate:%String,Action:%String") [ SqlProc ]
{
}

ClassMethod QryRepZLKExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objZLK
	Quit:aReportID="" $$$OK
	Set objZLK=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(aReportID)
	Quit:'$IsObject(objZLK) $$$OK
	
	Set KPBH=objZLK.CRKPBH
	Set BQYGZBR=objZLK.CRBQYGZBR.Description
	//诊断、报告信息
	Set ZDBW=objZLK.CRZDBW      
		
	Set ZDStr=##class(DHCMed.CD.CRICDDx).GetDescByID(objZLK.CRZD)
	Set CRZD=$p(ZDStr,$c(1),2)
	Set ZDICD=objZLK.CRZDICD
	Set BLXLX=objZLK.CRBLXLX
	Set YZD=##class(DHCMed.CD.CRICDDx).GetDescByID(objZLK.CRYZD)
	Set YZD=$p(YZD,$c(1),2)
	Set BLH=objZLK.CRBLH
	Set YZDRQ=objZLK.CRYZDRQ
	Set:YZDRQ'="" YZDRQ=$zd(YZDRQ,3)
	//确认时期别 
	Set (TNMFQT,TNMFQN,TNMFQM,FHCD)=""
	Set:$IsObject(objZLK.CRTNMFQT) TNMFQT=objZLK.CRTNMFQT.Description
	Set:$IsObject(objZLK.CRTNMFQN) TNMFQN=objZLK.CRTNMFQN.Description
	Set:$IsObject(objZLK.CRTNMFQM) TNMFQM=objZLK.CRTNMFQM.Description
	Set:$IsObject(objZLK.CRFHCD) FHCD=objZLK.CRFHCD.Description
	
	Set ZDRQ=objZLK.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set ZGZDDW=objZLK.CRZGZDDW.Description
	Set RepInfo=..GetRepInfoByID(aReportID)
	Set SWRQ=objZLK.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set SWYY=objZLK.CRSWYY.Description      
	Set SYICD=objZLK.CRSYICD
	Set JTSWYY=objZLK.CRJTSWYY
	Set BSZY=objZLK.CRBSZY
	//诊断依据  --多选
	Set ZDYJ=""
	For index=1:1:objZLK.CRZDYJ.Count() {
		Set objDic=objZLK.CRZDYJ.GetAt(index)
		Continue:'$IsObject(objDic)
		Set xDesc=objDic.Description
		Set ZDYJ=ZDYJ_","_xDesc
	}
	Set:ZDYJ'="" ZDYJ=$e(ZDYJ,2,*)
	
	Set (CardType,RelationOne,RelationTwo,RelationThr,Action)=""
	Set:$IsObject(objZLK.CRCardType) CardType=objZLK.CRCardType.Description
	Set ContactOne=objZLK.ContactOne
	Set:$IsObject(objZLK.RelationOne) RelationOne=objZLK.RelationOne.Description
	Set PhoneOne=objZLK.PhoneOne
	
	Set ContactTwo=objZLK.ContactTwo
	Set:$IsObject(objZLK.RelationTwo) RelationTwo=objZLK.RelationTwo.Description
	Set PhoneTwo=objZLK.PhoneTwo
	
	Set ContactThr=objZLK.ContactThr
	Set:$IsObject(objZLK.RelationThr) RelationThr=objZLK.RelationThr.Description
	Set PhoneThr=objZLK.PhoneThr
	Set AttackDate=objZLK.AttackDate
	Set:AttackDate'="" AttackDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AttackDate)
	Set:$IsObject(objZLK.Action) Action=objZLK.Action.Description
	
	Set Data=$lb(KPBH,BQYGZBR,ZDBW,CRZD,ZDICD,BLXLX,YZD,BLH,YZDRQ)
	Set Data=Data_$lb(TNMFQT,TNMFQN,TNMFQM,FHCD,ZDRQ,ZGZDDW)
	Set Data=Data_RepInfo_$lb(SWRQ,SWYY,SYICD,JTSWYY,BSZY,ZDYJ,CardType,ContactOne,RelationOne,PhoneOne,ContactTwo,RelationTwo,PhoneTwo,ContactThr,RelationThr,PhoneThr,AttackDate,Action)
	
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepZLKClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepZLKExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepZLKFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepZLKExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-14
/// Description:  查询慢性病病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportMBBK ,DHCMed.CD.CRReport
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepMBBK","62")
Query QryRepMBBK(aReportID As %String = "") As websys.Query(ROWSPEC = "BGKLX:%String,KPBH:%String,FBRQ:%String,SFFBRQGJ:%String,QZRQ:%String,SWRQ:%String,JTSWYY:%String,MBZDYJ:%String,QZDW:%String,SBWZ:%String,GXBZD:%String,NCZZD:%String,TNBZD:%String,GZZD:%String,ZDMC:%String,YFBW:%String,JFBW:%String,BLXLX:%String,ZDBM:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepMBBKExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objMBBK
	
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
	
	Set Data=$lb(BGKLX,KPBH,FBRQ,SFFBRQGJ,QZRQ,SWRQ,JTSWYY,MBZDYJ,QZDW)
	Set Data=Data_$lb(SBWZ,GXBZD,NCZZD,TNBZD,GZZD,ZDMC,YFBW,JFBW,BLXLX,ZDBM)
	Set Data=Data_..GetRepInfoByID(aReportID)
	
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepMBBKClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepMBBKExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepMBBKFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepMBBKExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-14
/// Description:  查询非职业一氧化碳中毒病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportFZYCO ,DHCMed.CD.CRReport
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepFZYCO11","62")
Query QryRepFZYCO11(aReportID As %String = "") As %Query(ROWSPEC = "KPBH:%String,COZDRQ:%String,COZDSJ:%String,ZDYY:%String,ZDCS:%String,ZDYS:%String,ZYZZ:%String,QTZZ:%String,ZDZD:%String,JZCS:%String,COZG:%String,ZDRQ:%String,SWRQ:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepFZYCO11Execute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objCO
	Quit:aReportID="" $$$OK
	Set objCO=##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(aReportID)
	Quit:'$IsObject(objCO) $$$OK
	
	Set KPBH=objCO.CRKPBH
	//中毒情况
	Set COZDRQ=objCO.CRCOZDRQ
	Set:COZDRQ'="" COZDRQ=$zd(COZDRQ,3)
	Set COZDSJ=objCO.CRCOZDSJ
	Set:COZDSJ'="" COZDSJ=$zt(COZDSJ,2)
	Set ZDYY=objCO.CRZDYY.Description
	Set ZDCS=objCO.CRZDCS.Description
	Set ZDYS=objCO.CRZDYS.Description
	Set ZYZZ=""
	For index=1:1:objCO.CRZYZZ.Count() {
		Set objDic=objCO.CRZYZZ.GetAt(index)
		Continue:'$IsObject(objDic)
		Set ZYZZ=ZYZZ_","_objDic.Description
	}
	Set:ZYZZ'="" ZYZZ=$e(ZYZZ,2,*)
	Set QTZZ=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTZZ")
	Set ZDZD=objCO.CRZDZD.Description
	Set JZCS=""
	For index=1:1:objCO.CRJZCS.Count() {
		Set objDic=objCO.CRJZCS.GetAt(index)
		Continue:'$IsObject(objDic)
		Set JZCS=JZCS_","_objDic.Description
	}
	Set:JZCS'="" JZCS=$e(JZCS,2,*)
	Set COZG=objCO.CRCOZG.Description
	//报告信息
	Set ZDRQ=objCO.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set SWRQ=objCO.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	
	Set Data=$lb(KPBH,COZDRQ,COZDSJ,ZDYY,ZDCS,ZDYS,ZYZZ,QTZZ,ZDZD,JZCS,COZG,ZDRQ,SWRQ)
	Set Data=Data_..GetRepInfoByID(aReportID)
	
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepFZYCO11Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepFZYCO11Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepFZYCO11Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepFZYCO11Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-14
/// Description:  查询农药中毒病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportNYZD ,DHCMed.CD.CRReport
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepNYZD","8")
Query QryRepNYZD(aReportID As %String = "") As %Query(ROWSPEC = "KPBH:%String,ZDNYMC:%String,NYZLSL:%String,ZDYY:%String,ZSPX:%String,SYFS:%String,WXXW:%String,ZDZG:%String,ZGQT:%String,ZDRQ:%String,SWRQ:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepNYZDExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objNY
	Quit:aReportID="" $$$OK
	Set objNY=##class(DHCMed.CD.CRReportNYZD).GetObjByParRef(aReportID)
	Quit:'$IsObject(objNY) $$$OK
	
	Set KPBH =objNY.CRKPBH
	//中毒信息
	Set ZDNYMC=objNY.CRZDNYMC
	Set NYZLSL=objNY.CRNYZLSL.Description
	Set ZDYY  =objNY.CRZDYY.Description
	Set ZSPX  =objNY.CRZSPX.Description
	Set SYFS  =objNY.CRSYFS.Description
	Set WXXW  =""
	For index=1:1:objNY.CRWXXW.Count() {
		Set objDic=objNY.CRWXXW.GetAt(index)
		Continue:'$IsObject(objDic)
		Set WXXW=WXXW_","_objDic.Description
	}
	Set:WXXW'="" WXXW=$e(WXXW,2,*)
	Set ZDZG=objNY.CRZDZG.Description
	Set ZGQT=""
	Set:ZDZG="其他" ZGQT=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTZG")
	Set ZDRQ=objNY.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set SWRQ=objNY.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	
	Set Data=$lb(KPBH,ZDNYMC,NYZLSL,ZDYY,ZSPX,SYFS,WXXW,ZDZG,ZGQT,ZDRQ,SWRQ)
	Set Data=Data_..GetRepInfoByID(aReportID)
	
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepNYZDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepNYZDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepNYZDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepNYZDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-20
/// Description:  查询伤害监测病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportSHK ,DHCMed.CD.CRReport,DHCMed.CD.CRReportPAT
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepSHK","10")
Query QryRepSHK(aReportID As %String = "") As %Query(ROWSPEC = "YYBH:%String,KPBH:%String,SHFSRQ:%String,SHFSSJ:%String,HZJZRQ:%String,HZJZSJ:%String,SHFSYY:%String,SHFSDD:%String,SHFSSHD:%String,SHSFGY:%String,SHXZ:%String,SHBW:%String,SHYZCD:%String,SHZD:%String,SHZDICD:%String,SHJJ:%String,CPMC1:%String,CPXH1:%String,CPFL1:%String,CPMC2:%String,CPXH2:%String,CPFL2:%String,DXAL:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepSHKExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objSHK
	Quit:aReportID="" $$$OK
	Set objSHK=##class(DHCMed.CD.CRReportSHK).GetObjByParRef(aReportID)
	Quit:'$IsObject(objSHK) $$$OK
	
	Set YYBH=objSHK.CRYYBH
	Set KPBH=objSHK.CRKPBH
	//伤害发生日期时间  这里的时间只取小时
	Set SHFSRQ=objSHK.CRSHFSRQ
	Set:SHFSRQ'="" SHFSRQ=$zd(SHFSRQ,3)
	Set SHFSSJ=objSHK.CRSHFSSJ
	Set SHFSSJ=$Extract(SHFSSJ,1,2)
	Set HZJZRQ=objSHK.CRHZJZRQ
	Set:HZJZRQ'="" HZJZRQ=$zd(HZJZRQ,3)
	Set HZJZSJ=objSHK.CRHZJZSJ
	Set HZJZSJ=$Extract(HZJZSJ,1,2)	
	// 伤害发生原因
	Set SHFSYY=objSHK.CRSHFSYY.Description
	Set:SHFSYY="" SHFSYY=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTYY")
	// 伤害发生地点
	Set SHFSDD=objSHK.CRSHFSDD.Description
	Set:SHFSDD="" SHFSDD=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTDD")
	// 伤害发生时活动
	Set SHFSSHD=objSHK.CRSHFSSHD.Description
	Set:SHFSSHD="" SHFSSHD=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTHD")
	Set SHSFGY=objSHK.CRSHSFGY.Description 
	// 伤害性质
	Set SHXZ=objSHK.CRSHXZ.Description
	Set:SHXZ="" SHXZ=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTXZ")
	// 伤害部位
	Set SHBW=objSHK.CRSHBW.Description
	Set:SHBW="" SHBW=##class(DHCMed.CD.CRReportBZQT).GetByPaCode(aReportID,"CRQTBW")
	Set SHYZCD=objSHK.CRSHYZCD.Description 
	// 伤害诊断
	Set ICDstr=##class(DHCMed.CD.CRReportSHK).GetICDDescByID(objSHK.CRSHZD)
	Set SHZD=$p(ICDstr,$c(1),2)
	Set SHZDICD=$p(ICDstr,$c(1),3)
	Set SHJJ=objSHK.CRSHJJ.Description
	//产品信息
	Set CPMC1=objSHK.CRCPMC1
	Set CPXH1=objSHK.CRCPXH1
	Set CPFL1=objSHK.CRCPFL1.Description
	Set CPMC2=objSHK.CRCPMC2
	Set CPXH2=objSHK.CRCPXH2
	Set CPFL2=objSHK.CRCPFL2.Description
	//典型案例
	Set DXAL=""	
	For index=1:1:objSHK.CRDXAL.Count() {
		Set objDic=objSHK.CRDXAL.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set DXAL=DXAL_","_SubDesc
	}
	Set:DXAL'="" DXAL=$e(DXAL,2,*)
	
	Set Data=$lb(YYBH,KPBH,SHFSRQ,SHFSSJ,HZJZRQ,HZJZSJ,SHFSYY,SHFSDD,SHFSSHD,SHSFGY)
	Set Data=Data_$lb(SHXZ,SHBW,SHYZCD,SHZD,SHZDICD,SHJJ,CPMC1,CPXH1,CPFL1,CPMC2,CPXH2,CPFL2,DXAL)
	Set Data=Data_..GetRepInfoByID(aReportID)
	
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepSHKClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepSHKExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepSHKFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepSHKExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-20
/// Description:  查询疑似职业病病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportYSZYB ,DHCMed.CD.CRReport,DHCMed.CD.CRReportPAT
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepYSZYB","6")
Query QryRepYSZYB(aReportID As %String = "") As %Query(ROWSPEC = "KPBH:%String,YRDWMC:%String,YRDWDZ:%String,YRDWYB:%String,YRDWLXR:%String,YRDWLXRDH:%String,JJLX:%String,DWHY:%String,QYGM:%String,BRLY:%String,ZYBZL:%String,JTBM:%String,ZDSGBM:%String,TSZDRS:%String,TJGZ:%String,ZYGLN:%String,ZYGLY:%String,JCSJT:%String,JCSJS:%String,JCSJF:%String,FSRQ:%String,ZDRQ:%String,SWRQ:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepYSZYBExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objYSZYB
	Quit:aReportID="" $$$OK
	Set objYSZYB=##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(aReportID)
	Quit:'$IsObject(objYSZYB) $$$OK
	
	Set KPBH = objYSZYB.CRKPBH
	// 用人单位信息
	Set YRDWMC=objYSZYB.CRYRDWMC
	Set YRDWDZ=objYSZYB.CRYRDWDZ
	Set YRDWYB=objYSZYB.CRYRDWYB
	Set YRDWLXR=objYSZYB.CRYRDWLXR
	Set YRDWLXRDH=objYSZYB.CRYRDWLXRDH
	Set JJLX=objYSZYB.CRJJLX
	Set DWHY=objYSZYB.CRDWHY
	Set QYGM=objYSZYB.CRQYGM.Description // 企业规模
	Set BRLY=objYSZYB.CRBRLY.Description // 病人来源
	//职业病种类
	Set ZYBZL=objYSZYB.CRZYBZL
	Set JTBM=objYSZYB.CRJTBM
	Set ZDSGBM=objYSZYB.CRZDSGBM
	Set TSZDRS=objYSZYB.CRTSZDRS
	Set TJGZ=objYSZYB.CRTJGZ.Description // 统计工种
	Set ZYGLN=objYSZYB.CRZYGLN
	Set ZYGLY=objYSZYB.CRZYGLY
	Set JCSJT=objYSZYB.CRJCSJT
	Set JCSJS=objYSZYB.CRJCSJS
	Set JCSJF=objYSZYB.CRJCSJF
	// 发生日期
	Set FSRQ=objYSZYB.CRFSRQ
	Set:FSRQ'="" FSRQ=$zd(FSRQ,3)
	Set ZDRQ=objYSZYB.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set SWRQ=objYSZYB.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	
	Set Data=$lb(KPBH,YRDWMC,YRDWDZ,YRDWYB,YRDWLXR,YRDWLXRDH,JJLX,DWHY,QYGM,BRLY,ZYBZL,JTBM,ZDSGBM,TSZDRS,TJGZ,ZYGLN,ZYGLY,JCSJT,JCSJS,JCSJF,FSRQ,ZDRQ,SWRQ)
	Set Data=Data_..GetRepInfoByID(aReportID)
	
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepYSZYBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepYSZYBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepYSZYBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepYSZYBExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-20
/// Description:  查询糖尿病病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportYSZYB ,DHCMed.CD.CRReport,DHCMed.CD.CRReportPAT
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepTNB","5")
Query QryRepTNB(aReportID As %String = "") As %Query(ROWSPEC = "KPBH:%String,ZDLX:%String,CRZD:%String,ZDICD:%String,BFZ:%String,WHYS:%String,CRTZ:%String,CRSG:%String,CRRS:%String,JZS:%String,LCBX:%String,QTLCBX:%String,ZYJCQK1:%String,ZYJCQK2:%String,ZYJCQK3:%String,ZYJCQK4:%String,ZYJCQK5:%String,ZYJCQK6:%String,ZYJCQK7:%String,ZYJCQK8:%String,ZYJCQK9:%String,ZDRQ:%String,ZGZDDW:%String,SWRQ:%String,SWYY:%String,SYICD:%String,JTSWYY:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepTNBExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objTNB
	Quit:aReportID="" $$$OK
	Set objTNB=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(aReportID)
	Quit:'$IsObject(objTNB) $$$OK
	
	Set KPBH=objTNB.CRKPBH
	//诊断、报告信息
	Set ZDLX =objTNB.CRZDLX.Description    //糖尿病类型
	Set ZDStr=##class(DHCMed.CD.CRReportTNB).GetICDDescByID(objTNB.CRZD)
	Set CRZD =$p(ZDStr,$c(1),2)
	Set ZDICD=objTNB.CRZDICD
	Set BFZ=""
	For index=1:1:objTNB.CRBFZ.Count() {
		Set objDic=objTNB.CRBFZ.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set BFZ=BFZ_","_SubDesc
	}
	Set:BFZ'="" BFZ=$e(BFZ,2,*)
	Set WHYS=""      // 危害因素
	For index=1:1:objTNB.CRWHYS.Count() {
		Set objDic=objTNB.CRWHYS.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set WHYS=WHYS_","_SubDesc
	}
	Set:WHYS'="" WHYS=$e(WHYS,2,*)
	Set CRTZ=objTNB.CRTZ
	Set CRSG=objTNB.CRSG
	Set CRRS=objTNB.CRRS
	Set JZS=""
	For index=1:1:objTNB.CRJZS.Count() {
		Set objDic=objTNB.CRJZS.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set JZS=JZS_","_SubDesc
	}
	Set:JZS'="" JZS=$e(JZS,2,*)
	Set LCBX=""
	For index=1:1:objTNB.CRLCBX.Count() {
		Set objDic=objTNB.CRLCBX.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set LCBX=LCBX_","_SubDesc
	}
	Set:LCBX'="" LCBX=$e(LCBX,2,*)
	Set QTLCBX=objTNB.CRQTLCBX
	Set ZYJCQK1=objTNB.CRZYJCQK1
	Set ZYJCQK2=objTNB.CRZYJCQK2
	Set ZYJCQK3=objTNB.CRZYJCQK3
	Set ZYJCQK4=objTNB.CRZYJCQK4
	Set ZYJCQK5=objTNB.CRZYJCQK5
	Set ZYJCQK6=objTNB.CRZYJCQK6
	Set ZYJCQK7=objTNB.CRZYJCQK7
	Set ZYJCQK8=objTNB.CRZYJCQK8
	Set ZYJCQK9=objTNB.CRZYJCQK9
	Set ZDRQ=objTNB.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set ZGZDDW=objTNB.CRZGZDDW.Description
	Set SWRQ=objTNB.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set SWYY=objTNB.CRSWYY.Description
	Set SYICD=objTNB.CRSYICD
	Set JTSWYY=objTNB.CRJTSWYY
	
	Set Data=$lb(KPBH,ZDLX,CRZD,ZDICD,BFZ,WHYS,CRTZ,CRSG,CRRS,JZS,LCBX,QTLCBX)
	Set Data=Data_$lb(ZYJCQK1,ZYJCQK2,ZYJCQK3,ZYJCQK4,ZYJCQK5,ZYJCQK6,ZYJCQK7,ZYJCQK8,ZYJCQK9,ZDRQ,ZGZDDW,SWRQ,SWYY,SYICD,JTSWYY)
	Set Data=Data_..GetRepInfoByID(aReportID)

	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepTNBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepTNBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepTNBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepTNBExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-20
/// Description:  查询心脑血管病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportYSZYB ,DHCMed.CD.CRReport,DHCMed.CD.CRReportPAT
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepXNXG","4")
Query QryRepXNXG(aReportID As %String = "") As %Query(ROWSPEC = "KPBH:%String,BGKLX:%String,CRZD:%String,ZDBM:%String,GXBZD:%String,NCZZD:%String,SYZZ:%String,CRBS:%String,FBRQ:%String,QZRQ:%String,SFSCFB:%String,QZDW:%String,SJJG:%String,SHTD:%String,SWRQ:%String,SWYY:%String,SYBM:%String,SYMC:%String,BSZY:%String,ZDYJ:%String,CRRepProvince:%String,CRRepCity:%String,CRRepCounty:%String,CRCardType:%String,CRLiveSix:%String,CRLevel:%String,CROutCome:%String,CRCureMethod:%String,CRApoplexyType:%String,CRSCD:%String,CRInfer:%String,CRDiag:%String,CRBiochemicalMark:%String,CRReissue:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String,CRCheckDate:%String,CRCheckUser:%String") [ SqlProc ]
{
}

ClassMethod QryRepXNXGExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Kill objXNXG
	Quit:aReportID="" $$$OK
	Set objXNXG=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(aReportID)
	Quit:'$IsObject(objXNXG) $$$OK
	
	Set KPBH=objXNXG.CRKPBH
	Set BGKLX=objXNXG.CRBGKLX.Description
	//诊断、报告信息
	Set ZDStr=##class(DHCMed.CD.CRReportXNXG).GetICDDescByID(objXNXG.CRZDID)
	Set CRZD =$p(ZDStr,$c(1),2)
	Set ZDBM =objXNXG.CRZDBM
	Set ZDMC =objXNXG.CRZDMC    //诊断名称
	Set GXBZD="",NCZZD=""
	Set:$p(ZDMC,"-",2)="GXB" GXBZD=$p(ZDMC,"-",1)
	Set:$p(ZDMC,"-",2)="NCZ" NCZZD=$p(ZDMC,"-",1)
	Set SYZZ=""
	For index=1:1:objXNXG.CRSYZZ.Count() {
		Set objDic=objXNXG.CRSYZZ.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set SYZZ=SYZZ_","_SubDesc
	}
	Set:SYZZ'="" SYZZ=$e(SYZZ,2,*)
	Set CRBS=""
	For index=1:1:objXNXG.CRBS.Count() {
		Set objDic=objXNXG.CRBS.GetAt(index)
		Continue:'$IsObject(objDic)
		Set SubDesc=objDic.Description
		Set CRBS=CRBS_","_SubDesc
	}
	Set:CRBS'="" CRBS=$e(CRBS,2,*)
	Set FBRQ=objXNXG.CRFBRQ
	Set:FBRQ'="" FBRQ=$zd(FBRQ,3)
	Set QZRQ=objXNXG.CRQZRQ
	Set:QZRQ'="" QZRQ=$zd(QZRQ,3)
	//是否首次发病
	Set SFSCFB=objXNXG.CRSFSCFB.Description   //1-chkY
	Set QZDW=objXNXG.CRQZDW.Description
	Set SJJG=objXNXG.CRSJJG.Description
	//诊断依据  拆分
	Set ZDYJ=""
	For index=1:1:objXNXG.CRZDYJ.Count() {
		Set objDic=objXNXG.CRZDYJ.GetAt(index)
		Continue:'$IsObject(objDic)		
		Set SubDesc=objDic.Description
		Set ZDYJ=ZDYJ_","_SubDesc
		
	}
	Set:ZDYJ'="" ZDYJ = $e(ZDYJ,2,*)
	Set SHTD=objXNXG.CRSHTD.Description
	Set SWRQ=objXNXG.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set SWYY=objXNXG.CRSWYY.Description   
	Set SYBM=objXNXG.CRSYBM
	Set SYMC=objXNXG.CRSYMC     //死亡具体原因
	Set BSZY=objXNXG.CRBSZY
	
	Set CRRepProvince	=objXNXG.CRRepProvince.ShortDesc
	Set CRRepCity		=objXNXG.CRRepCity.ShortDesc
	Set CRRepCounty		=objXNXG.CRRepCounty.ShortDesc
	Set CRCardType		=objXNXG.CRCardType.Description
	Set CRLiveSix		=objXNXG.CRLiveSix.Description
	Set CRLevel			=objXNXG.CRLevel.Description
	Set CROutCome		=objXNXG.CROutCome.Description
	
	Set CRCureMethod	=objXNXG.CRCureMethod.Description
	Set CRApoplexyType	=objXNXG.CRApoplexyType.Description
	Set CRSCD			=objXNXG.CRSCD.Description
	Set CRInfer			=objXNXG.CRInfer.Description
	Set CRDiag			=objXNXG.CRDaig.Description
	Set CRBiochemicalMark=objXNXG.CRBiochemicalMark.Description
	Set CRReissue		=objXNXG.CRReissue.Description
	
	Set Data=$lb(KPBH,BGKLX,CRZD,ZDBM,GXBZD,NCZZD,SYZZ,CRBS,FBRQ,QZRQ,SFSCFB,QZDW,SJJG,SHTD,SWRQ,SWYY,SYBM,SYMC,BSZY,ZDYJ,CRRepProvince,CRRepCity,CRRepCounty,CRCardType,CRLiveSix,CRLevel,CROutCome,CRCureMethod,CRApoplexyType,CRSCD,CRInfer,CRDiag,CRBiochemicalMark,CRReissue)
	Set Data=Data_..GetRepInfoByID(aReportID)
	
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepXNXGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepXNXGExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepXNXGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepXNXGExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-20
/// Description:  查询高温中暑病人报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportYSZYB ,DHCMed.CD.CRReport,DHCMed.CD.CRReportPAT
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepGWZS","7")
Query QryRepGWZS(aReportID As %String = "") As %Query(ROWSPEC = "KPBH:%String,ZSDD:%String,ZSXZ:%String,ZSLCBX:%String,ZSZD:%String,ZSZLGY:%String,ZSZG:%String,ZDRQ:%String,SWRQ:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepGWZSExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objGWZS
	Quit:aReportID="" $$$OK
	Set objGWZS=##class(DHCMed.CD.CRReportGWZS).GetObjByParRef(aReportID)
	Quit:'$IsObject(objGWZS) $$$OK
	
	Set KPBH=objGWZS.CRKPBH
	Set ZSDD=objGWZS.CRZSDD
	Set ZSXZ  =objGWZS.CRZSXZ.Description
	Set ZSLCBX=objGWZS.CRZSLCBX
	Set ZSZD  =objGWZS.CRZSZD.Description
	Set ZSZLGY=objGWZS.CRZLGY
	Set ZSZG=objGWZS.CRZSZG.Description
	Set ZDRQ=objGWZS.CRZDRQ
	Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set SWRQ=objGWZS.CRSWRQ
	Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	
	Set Data=$lb(KPBH,ZSDD,ZSXZ,ZSLCBX,ZSZD,ZSZLGY,ZSZG,ZDRQ,SWRQ)
	Set Data=Data_..GetRepInfoByID(aReportID)
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepGWZSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepGWZSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepGWZSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepGWZSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenrui
/// CreatDate：   2019-12-16
/// Description:  查询出生缺陷儿报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportCSQX ,DHCMed.CD.CRReport,DHCMed.CD.CRReportPAT
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepCSQX","")
Query QryRepCSQX(aReportID As %String = "") As %Query(ROWSPEC = "KPBH:%String,HJLX:%String,YC:%String,CC:%String,IsHJ:%String,JZDSSQ:%String,JZSJ:%String,IsFZSZ:%String,JTNRJSR:%String,CSRQ:%String,CSYY:%String,TL:%String,TZ:%String,SC:%String,JXS:%String,TS:%String,TLYL:%String,XB:%String,ZG:%String,IsZLXYC:%String,ZDYJ:%String,ZDYJTxt:%String,JXQZSJ:%String,CQZDYZ:%String,CQZDYY:%String,ZD:%String,ZDZY:%String,ZDNDXL:%String,ZDXTXXZB:%String,ZDDZHPXLX:%String,ZDTxt:%String,YZQHBFR:%String,YZQHBBDGR:%String,YZQHBTNB:%String,YZQHBTxt:%String,YZQFYHAL:%String,YZQFYKSS:%String,YZQFYBYY:%String,YZQFYZJY:%String,YZQFYTxt:%String,YZQQTYJ:%String,YZQQTNY:%String,YZQQTSX:%String,YZQQTHXZJ:%String,YZQQTTxt:%String,JZSYYCSYS:%String,JZSYST:%String,JZSYZRLC:%String,JZSYQXE:%String,JZSYQXM:%String,JZYCQXM1:%String,JZYCQYGX1:%String,JZYCQXM2:%String,JZYCQYGX2:%String,JZYCQXM3:%String,JZYCQYGX3:%String,JZHPIsJQ:%String,JZHPJQGX:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String,CRCheckDate:%String,CRCheckUser:%String") [ SqlProc ]
{
}

ClassMethod QryRepCSQXExecute(ByRef qHandle As %Binary, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Kill objCSQX
	Quit:aReportID="" $$$OK
	Set objCSQX=##class(DHCMed.CD.CRReportCSQX).GetObjByParRef(aReportID)
	Quit:'$IsObject(objCSQX) $$$OK
		
	Set KPBH=objCSQX.CRKPBH
	Set HJLX=objCSQX.CRHJLXDr.Description
	Set YC=objCSQX.CRYC
	Set CC=objCSQX.CRCC
	Set IsHJ=objCSQX.CRIsHJ
	
	Set JZDSSQ=objCSQX.CRJZDSSQ
	Set JZSJ=objCSQX.CRJZSJ
	Set IsFZSZ=objCSQX.CRIsFZSZ
	Set JTNRJSR=objCSQX.CRJTNRJSRDr.Description
	Set CSRQ=objCSQX.CRCSRQ
	Set:CSRQ'="" CSRQ=$zd(CSRQ,3)
	
	Set CSYY=objCSQX.CRCSYY
	Set TL=objCSQX.CRTL
	Set TZ=objCSQX.CRTZ
	Set SC=objCSQX.CRSC
	Set JXS=objCSQX.CRJXS
	
	Set TS=objCSQX.CRTSDr.Description
	Set TLYL=objCSQX.CRTLYLDr.Description
	Set XB=objCSQX.CRXBDr.Description
	Set ZG=objCSQX.CRZGDr.Description
	Set IsZLXYC=objCSQX.CRIsZLXYC
	
	Set ZDYJ=objCSQX.CRZDYJDr.Description
	Set ZDYJTxt=objCSQX.CRZDYJTxt
	Set JXQZSJ=objCSQX.CRJXQZSJDr.Description
	Set CQZDYZ=objCSQX.CRCQZDYZ
	Set CQZDYY=objCSQX.CRCQZDYY
	
	Set ZD=objCSQX.CRZDDr.Description
	Set ZDZY=objCSQX.CRZDZYDr.Description
	Set ZDNDXL=objCSQX.CRZDNDXL
	Set ZDXTXXZB=objCSQX.CRZDXTXXZBDr.Description
	Set ZDDZHPXLX=objCSQX.CRZDDZHPXLXDr
	Set ZDTxt=objCSQX.CRZDTxt

	Set YZQHBFR=objCSQX.CRYZQHBFR
	Set YZQHBBDGR=objCSQX.CRYZQHBBDGR
	Set YZQHBTNB=objCSQX.CRYZQHBTNB
	Set YZQHBTxt=objCSQX.CRYZQHBTxt
	Set YZQFYHAL=objCSQX.CRYZQFYHAL

	Set YZQFYKSS=objCSQX.CRYZQFYKSS
	Set YZQFYBYY=objCSQX.CRYZQFYBYY
	Set YZQFYZJY=objCSQX.CRYZQFYZJY
	Set YZQFYTxt=objCSQX.CRYZQFYTxt
	Set YZQQTYJ=objCSQX.CRYZQQTYJ

	Set YZQQTNY=objCSQX.CRYZQQTNY
	Set YZQQTSX=objCSQX.CRYZQQTSX
	Set YZQQTHXZJ=objCSQX.CRYZQQTHXZJ
	Set YZQQTTxt=objCSQX.CRYZQQTTxt
	Set JZSYYCSYS=objCSQX.CRJZSYYCSYSDr
	
	Set JZSYST=objCSQX.CRJZSYST
	Set JZSYZRLC=objCSQX.CRJZSYZRLC
	Set JZSYQXE=objCSQX.CRJZSYQXE
	Set JZSYQXM=objCSQX.CRJZSYQXM

	Set JZYCQXM1=objCSQX.CRJZYCQXM1
	Set JZYCQYGX1=objCSQX.CRJZYCQYGX1
	Set JZYCQXM2=objCSQX.CRJZYCQXM2
	Set JZYCQYGX2=objCSQX.CRJZYCQYGX2
	Set JZYCQXM3=objCSQX.CRJZYCQXM3
	Set JZYCQYGX3=objCSQX.CRJZYCQYGX3
	Set JZHPIsJQ=objCSQX.CRJZHPIsJQ
	Set JZHPJQGX=objCSQX.CRJZHPJQGX
		
	Set Data=$lb(KPBH,HJLX,YC,CC,IsHJ,JZDSSQ,JZSJ,IsFZSZ,JTNRJSR,CSRQ,CSYY,TL,TZ,SC,JXS,TS,TLYL,XB,ZG,IsZLXYC,ZDYJ,ZDYJTxt,JXQZSJ,CQZDYZ,CQZDYY,ZD,ZDZY,ZDNDXL,ZDXTXXZB,ZDDZHPXLX,ZDTxt,YZQHBFR,YZQHBBDGR,YZQHBTNB,YZQHBTxt,YZQFYHAL,YZQFYKSS,YZQFYBYY,YZQFYZJY,YZQFYTxt,YZQQTYJ,YZQQTNY,YZQQTSX,YZQQTHXZJ,YZQQTTxt,JZSYYCSYS,JZSYST,JZSYZRLC,JZSYQXE,JZSYQXM,JZYCQXM1,JZYCQYGX1,JZYCQXM2,JZYCQYGX2,JZYCQXM3,JZYCQYGX3,JZHPIsJQ,JZHPJQGX)
	Set Data=Data_..GetRepInfoByID(aReportID)
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepCSQXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepCSQXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepCSQXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepCSQXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenrui
/// CreatDate：   2021-10-14
/// Description:  查询儿童伤害报卡信息（润乾打印）
/// Table：       DHCMed.CD.CRReportETSH ,DHCMed.CD.CRReport,DHCMed.CD.CRReportPAT
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CDService.RaqPrintSrv","QryRepETSH","26")
Query QryRepETSH(aReportID As %String) As %Query(ROWSPEC = "HospNumber:%String,AdmLocType:%String,CRKPBH:%String,Weight:%String,Height:%String,ChildSchool:%String,ChildRegister:%String,FatherEdc:%String,MotherEdc:%String,HappenTime:%String,AdmTime:%String,HappenResaon:%String,OtherResaon:%String,HappenPlace:%String,OtherPlace:%String,HappenActivity:%String,OtherActivity:%String,IsWillfully:%String,OtherWillfully:%String,IsDrink:%String,IsCaregiver:%String,CaregiverType:%String,CaregiverStatus:%String,OtherStatus:%String,Injure:%String,Otherinjure:%String,InjurePalce:%String,OtherInjurePalce:%String,InjureSystem:%String,OtherInjureSystem:%String,PTSScore:%String,AirwayStatus:%String,SBP:%String,CentralSystem:%String,OpenWound:%String,Fracture:%String,InjurySeverity:%String,InjuryDiag:%String,InjuryEnd:%String,OtherEnd:%String,ReportOrgan:%String,ReportUser:%String,ReportDate:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRepETSHExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Kill objETSH
	Quit:aReportID="" $$$OK
	Set objETSH=##class(DHCMed.CD.CRReportETSH).GetObjByParRef(aReportID)
	Quit:'$IsObject(objETSH) $$$OK
	Set (HospNumber,AdmLocType,CRKPBH,Weight,Height,ChildSchool,ChildRegister,FatherEdc,MotherEdc,HappenTime,AdmTime,HappenResaon,OtherResaon,HappenPlace,OtherPlace,HappenActivity,OtherActivity,IsWillfully,OtherWillfully,IsDrink,IsCaregiver,CaregiverType,CaregiverStatus,OtherStatus,Injure,Otherinjure,InjurePalce,OtherInjurePalce,InjureSystem,OtherInjureSystem,PTSScore,AirwayStatus,SBP,CentralSystem,OpenWound,Fracture,InjurySeverity,InjuryDiag,InjuryEnd,OtherEnd)=""
	
	Set HospNumber 	= objETSH.HospNumber
	Set AdmLocType 	= objETSH.AdmLocType.Description
	Set CRKPBH 		= objETSH.CRKPBH
	Set Weight 		= objETSH.ChildWeight_"kg"
	Set Height 		= objETSH.ChildHeight_"cm"
	Set ChildSchool = objETSH.ChildSchool.Description
	Set ChildRegister = objETSH.ChildRegister.Description
	Set FatherEdc 	= objETSH.FatherEdc.Description
	Set MotherEdc 	= objETSH.MotherEdc.Description
	Set HappenTime 	= objETSH.HappenTime
	Set AdmTime 	= objETSH.AdmTime
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
	
	
	Set Data=$lb(HospNumber,AdmLocType,CRKPBH,Weight,Height,ChildSchool,ChildRegister,FatherEdc,MotherEdc,HappenTime,AdmTime,HappenResaon,OtherResaon,HappenPlace,OtherPlace,HappenActivity,OtherActivity,IsWillfully,OtherWillfully,IsDrink,IsCaregiver,CaregiverType,CaregiverStatus,OtherStatus,Injure,Otherinjure,InjurePalce,OtherInjurePalce,InjureSystem,OtherInjureSystem,PTSScore,AirwayStatus,SBP,CentralSystem,OpenWound,Fracture,InjurySeverity,InjuryDiag,InjuryEnd,OtherEnd)
	
	Set Data=Data_..GetRepInfoByID(aReportID)
	Set ^CacheTemp(repid,ind)=Data
	Quit $$$OK
}

ClassMethod QryRepETSHClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepETSHExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepETSHFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepETSHExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
