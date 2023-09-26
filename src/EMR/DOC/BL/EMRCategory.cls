/// 名称:	EMR.DOC.BL.EMRCategory
/// 描述:	电子病历导航业务逻辑类
/// 编写者：yejian
/// 编写日期: 2022-6-8
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRCategory Extends %RegisteredObject
{

/// Desc:       取配置前端目录展现病历目录
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      ACTLocID 用户登录科室
///             ASSGroupID 用户安全组
///             AEpisodeID 患者就诊号
/// OutPut:     dataSet
/// Debug       d ##Class(%ResultSet).RunQuery("EMR.DOC.BL.EMRCategory","GetCategory",6,28,713)
Query GetCategory(ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String, aLangid As %String = "20") As %Query(ROWSPEC = "ID:%String,DOCCategoryCode:%String,ItemURL:%String,ItemParas:%String,ItemTitle:%String,recordFlag:%String")
{
}

ClassMethod GetCategoryExecute(ByRef qHandle As %Binary, ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String, aLangid As %String = "20") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(ACTLocID = "")||(ASSGroupID = "")||(AEpisodeID = "") $$$OK
	s episodeType= $p(^PAADM(AEpisodeID),"^",2)
	if (episodeType = "I")
	{
		s disDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
		s schemType = $case(disDateTime,"":"RUNNING",:"ARCHIVING")
	}
	else
	{
		s schemType = "OUTPATIENT"
	}
	//方案类型ID
	s schemTypeID = $o(^CF.EMR.DOC.EMRTSchemeTypeI("IdxCode"," "_schemType,""))
	q:(schemTypeID="") $$$OK
	//获取方案ID
	s schemID = $o(^CF.EMR.DOC.EMRTSchemeI("IdxSchemeType",schemTypeID,""))
	q:(schemID="") $$$OK
	s seq = ""
	//如果该科室设置病例导航科室项目顺序，通过科室项目顺序获取
	s rowSeqID = $o(^CF.EMR.DOC.EMRTSchemeGroupCTI("IdxLocGID",ACTLocID,""))
	if (rowSeqID'="")
	{
		s objItemSeqLoc = ##class(CF.EMR.DOC.EMRTSchemeGroupCT).%OpenId(rowSeqID)
		s strGroupCode = objItemSeqLoc.Code
		s seq = ""
		for
		{
			s seq = $o(^CF.EMR.DOC.EMRTSchemeGroupSeqI("IdxSchemeLocGSeq"," "_strGroupCode,seq))
			q:(seq = "")
			s seqrowId = ""
			for
			{
				s seqrowId = $o(^CF.EMR.DOC.EMRTSchemeGroupSeqI("IdxSchemeLocGSeq"," "_strGroupCode,seq,seqrowId))
				q:(seqrowId = "")
				s objGroupSeq = ##Class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(seqrowId)
				s strSchemTypeID = objGroupSeq.EMRTSchemeItem.EMRTScheme.%Id()
				continue:(strSchemTypeID'=schemTypeID)
				s rowId = objGroupSeq.EMRTSchemeItem.%Id()
				d getData
				
			}
		}
	}
	else //如果该科室没有设置病例导航科室项目顺序，通过默认顺序获取
	{
		s seq = ""
		for
		{
			s seq = $o(^CF.EMR.DOC.EMRTSchemeItemI("IdxItemSeq",schemID,seq))
			q:(seq = "")
			s rowId = ""
			for
			{
				s rowId = $o(^CF.EMR.DOC.EMRTSchemeItemI("IdxItemSeq",schemID,seq,rowId))
				q:(rowId = "")
				d getData
					
			}
		}
	}	
    Quit $$$OK
getData
	s objNavItem = ##Class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(rowId)
	q:(objNavItem = "")
	q:(objNavItem.DataID="")
	q:($d(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",rowId,ASSGroupID))<=0)			
	s locFlag = $d(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",rowId,ACTLocID))
	
	s recordFlag = ##class(EMR.DOC.BL.DocumentData).IsHasInstanceByBDMCode(AEpisodeID,objNavItem.DataID.Code)
	q:((locFlag <= 0)&&(recordFlag <= 0))
	
	s ItemTitle = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.TemplateCategory","EMRName",objNavItem.DataID.EMRName,aLangid)
	s data = $lb(objNavItem.DataID.%Id(),objNavItem.DataID.Code,objNavItem.HISURL,objNavItem.HISParameter,ItemTitle,recordFlag)
	s ^CacheTemp(repid,ind) = data
	s ind=ind+1
}

ClassMethod GetCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       判断分类编码是否有权限显示
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      ACTLocID 用户登录科室
///             ASSGroupID 用户安全组
///             AEpisodeID 患者就诊号
/// OutPut:     {""Visible"":""1"",""Sequence"":"""_strItemSeq_""",""Num"":"""_num_""",""PrintNum"":"""_printNum_"""}
/// Debug       d ##Class(EMR.DOC.BL.EMRCategory).GetCategoryStatus(6,28,713,"EMR1000")
ClassMethod GetCategoryStatus(ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String, ADocCategoryCode As %String, aLangid As %String = "20") As %String
{
	s strRes = ""
	s resData ={"Visible":"0","Sequence":"0","Num":"0","PrintNum":"0"}
	s Visible="0",Sequence="0",Num="0",PrintNum="",objGroupSeq=""
	q:(ACTLocID = "")||(ASSGroupID = "")||(AEpisodeID = "")||(ADocCategoryCode="") resData
	s ADocCategoryCode = $zcvt(ADocCategoryCode,"U")
	s episodeType= $p(^PAADM(AEpisodeID),"^",2)
	if (episodeType = "I")
	{
		s disDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
		s schemType = $case(disDateTime,"":"RUNNING",:"ARCHIVING")
	}
	else
	{
		s schemType = "OUTPATIENT"
	}
	
	s temCatId = $o(^CF.EMR.DOC.TemplateCategoryI("IdxCode"," "_ADocCategoryCode,""))
	q:(temCatId="") resData
	//方案类型ID
	s schemTypeID = $o(^CF.EMR.DOC.EMRTSchemeTypeI("IdxCode"," "_schemType,""))
	q:(schemTypeID="") resData
	//获取方案ID
	s schemID = $o(^CF.EMR.DOC.EMRTSchemeI("IdxSchemeType",schemTypeID,""))
	q:(schemID="") resData
    s emrSItemID = $o(^CF.EMR.DOC.EMRTSchemeItemI("IdxSchemeItemCode",schemID,temCatId,""))
    s objSItem = ##class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(emrSItemID)
    q:(objSItem="") resData
    s Sequence = objSItem.Sequence
	//如果该科室设置病例导航科室项目顺序，通过科室项目顺序获取
	s rowSeqID = $o(^CF.EMR.DOC.EMRTSchemeGroupCTI("IdxLocGID",ACTLocID,""))
	if (rowSeqID'="")
	{
		s objItemSeqLoc = ##class(CF.EMR.DOC.EMRTSchemeGroupCT).%OpenId(rowSeqID)
		s strGroupCode = $zcvt(objItemSeqLoc.Code,"U")
		s seqrowId = $o(^CF.EMR.DOC.EMRTSchemeGroupSeqI("IdxLocGItemID"," "_strGroupCode,emrSItemID,""))
		s:(seqrowId '= "") objGroupSeq = ##Class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(seqrowId)
		s:(objGroupSeq'="") Sequence = objGroupSeq.Sequence
	}
	s rowILocID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",emrSItemID,ACTLocID,""))
	s rowISSGroupID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",emrSItemID,ASSGroupID,""))
	s:(rowILocID'="")&&(rowISSGroupID'="") Visible="1"
	s num = ##Class(EMR.DOC.BL.DocumentData).GetDocumentCount(ADocCategoryCode,AEpisodeID)
    s printNum = ##Class(EMR.DOC.BL.DocumentPrintRecord).GetPrintCount(ADocCategoryCode,AEpisodeID)
    s:(Visible'="0") resData.Visible = Visible
    s:(Sequence'="0") resData.Sequence = Sequence
    s:(num'="0") resData.Num = num
    s:(printNum'="0") resData.PrintNum = printNum
    s:(resData'="") strRes = resData.%ToJSON()
    q strRes
}

}
