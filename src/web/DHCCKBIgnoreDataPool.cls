Import SQLUser

/// Creator: 		乔庆澳
/// CreateDate: 	2022-06-9
/// Descript: 		忽略(优化速度)
Class web.DHCCKBIgnoreDataPool Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  提取忽略数据转换成药品相关
/// Input: syncImRowId:为空(同步所有数据), 不为空(只同步此id数据)
/// w ##Class(web.DHCCKBIgnoreDataPool).syncIgnDataPool()
ClassMethod syncIgnDataPool(syncImRowId = "")
{
	n (syncImRowId)
	
	s $zt="err"
	
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()
	k ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","interrupt",pid)
		
	;字典维护忽略配置
	s imRowId=0
	f  s imRowId=$o(^CF.CKB.PDSS.IgnoreManageD(imRowId)) q:imRowId=""  d
	.q:(syncImRowId'="")&&(syncImRowId'=imRowId)	;只同步一条忽略数据
	.s imItem = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),4)
	.q:+imItem=0 		;没有指向的
	.s imType = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),2)
	.s imValue = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),3)
	.s imItem = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),4)
	.s imFlag = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),5)
	.q:(+imValue=0)||(+imItem=0)||(imFlag="")
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(+imValue))
	.d addTempData
	
	d insertData
	k ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid)
	k ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","interrupt",pid)
	q 0
	
addTempData
	;存入表格，考虑同一个药品可能存在多次，这里用一个临时globle先记录
	s dicType = ##Class(web.DHCCKBIgnoreDataPool).dicType(imValue) ;1:药品，2:药品相关，3:药品无关, "":错误数据
	s dicTypeCode = ##Class(web.DHCCKBIgnoreDataPool).dicTypeCode(imValue)
	s dicTypeCodeDrug = ",Drug,DrugLink,DrugExt,"	;药品相关的
	s isDrugRelated = dicTypeCodeDrug[(","_dicTypeCode_",")	;是否药品相关
	
	i isDrugRelated d
	.i dicTypeCode="DrugExt" d	;3给药途径、3用药频率
	..s count=$i(^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid))
	..s ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid,count)=$lb("ALL",imItem,imFlag,dicTypeCode,imType,imValue,imRowId)
	.q:dicTypeCode="DrugExt"
	.
	.i dicType=1 d ;药品
	..s count=$i(^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid))
	..s ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid,count)=$lb(imValue,imItem,imFlag,dicTypeCode,imType,imValue,imRowId)
	.i dicType'=1 d ;非药品
	..s dlaRowId=0
	..f  s dlaRowId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",imValue,dlaRowId)) q:dlaRowId=""  d
	...s dlaDicDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),"^",2)
	...q:+dlaDicDr=0
	...s dicType = ##Class(web.DHCCKBIgnoreDataPool).dicType(dlaDicDr)
	...q:dicType'=1 ;非药品
	...s count=$i(^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid))
	...s ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid,count)=$lb(dlaDicDr,imItem,imFlag,dicTypeCode,imType,imValue,imRowId)
	i 'isDrugRelated d	;药品无关
	.s count=$i(^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid))
	.s ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid,count)=$lb("",imItem,imFlag,dicTypeCode,imType,imValue,imRowId)	
	
	q ""

insertData
	i syncImRowId="" &sql(DELETE CF_CKB_PDSS.IgnoreDataPool) ;先清除数据
	i syncImRowId'="" &sql(DELETE CF_CKB_PDSS.IgnoreDataPool WHERE IDP_IM_Dr=:syncImRowId) ;先清除数据
	
	s index=0
	f  s index=$o(^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid,index)) q:index=""  d
	.s lbItmData = ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","data",pid,index)
	.s lbLen = $ll(lbItmData)
	.K PLIST
	.f i=1:1:lbLen d
	..s PLIST(i+1)=$lg(lbItmData,i)
	.&sql(INSERT INTO CF_CKB_PDSS.IgnoreDataPool VALUES PLIST())
	q SQLCODE
	
err
	s ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","interrupt",pid)=imRowId ;记录中断时候的id
	q $ze
}

/// Descript:获取CommonDiction的类别
/// 				1:药品，2:药品相关，3:药品无关, "":错误数据
/// w ##Class(web.DHCCKBIgnoreDataPool).dicType(50032)
ClassMethod dicType(cdRowId)
{
	s isDrugCodeStr=",DrugData,ChineseDrugData,ChineseHerbalMedicineData,"
	s IsDrugRelatedStr=",DrugData,ChineseDrugData,ChineseHerbalMedicineData,"_		;不相关的是所有药品都忽略
						"ChinaMedPrescData,GeneralData,PrescriptionCopeData,"_
						"GeneralFromData,DrugProNameData,DrugCategoryData,"_
						"ingredientData,ExcipientData,FormData,OtherNameData,"	
	s topDicId = ##Class(web.DHCCKBIgnoreDataPool).commonDiction(cdRowId)
	q:+topDicId=0 ""
	s cdCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(topDicId)),2)
	s cdDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(topDicId)),3)
	q:isDrugCodeStr[(","_cdCode_",") 1	;指向是药品
	q:IsDrugRelatedStr[(","_cdCode_",") 2  ;指向是否药品相关
	q 3
}

/// Descript:获取CommonDiction的类别code
/// 				1药品(西药、中药、中药饮片)、1分类、1通用名、1商品名、1剂型：Drug
/// 					2化学名、2成分、2辅料：DrugLink
/// 					3给药途径、3用药频率：DrugExt
/// 					Other：其他code
/// w ##Class(web.DHCCKBIgnoreDataPool).dicTypeCode(50032)
ClassMethod dicTypeCode(cdRowId)
{
	;西药字典,中成药字典,中药饮片字典,药学分类字典,通用名字典,药品商品名字典,剂型字典
	s codeStrDrug = ",DrugData,ChineseDrugData,ChineseHerbalMedicineData,DrugCategoryData,GeneralFromData,DrugProNameData,FormData,"
	;化学名字典,成分字典,辅料字典
	s codeStrDrugLink = ",GeneralData,ingredientData,ExcipientData,"
	;给药途径字典,用药频率字典
	s codeStrDrugExt = ",DrugPreMetData,DrugFreqData,"
	
	
	s topDicId = ##Class(web.DHCCKBIgnoreDataPool).commonDiction(cdRowId)
	q:+topDicId=0 ""
	s cdCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(topDicId)),2)
	s cdDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(topDicId)),3)
	q:codeStrDrug[(","_cdCode_",") "Drug"	;指向是药品
	q:codeStrDrugLink[(","_cdCode_",") "DrugLink"  ;指向是否药品相关
	q:codeStrDrugExt[(","_cdCode_",") "DrugExt"  ;指向是否药品相关
	q cdCode
}

/// Descript:递归获取字典表顶层id
/// w ##Class(web.DHCCKBIgnoreDataPool).commonDiction(98178)
ClassMethod commonDiction(id)
{
	
	s parefId = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	s:+parefId'=0 id=##Class(web.DHCCKBIgnoreDataPool).commonDiction(parefId)
	q id
}

}
