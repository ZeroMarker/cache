/// Creator:	yejian
/// CreatDate:  2019-4-15
/// Desc:		珠海智慧医疗在提供出院小结视图表接口
Class EMRservice.InterfaceService.EMROutputSummaryQery Extends %RegisteredObject
{

/// Creator:	yejian
/// CreatDate:  2019-4-15
/// Desc:		出院小结
/// Input：		DateFrom：出院日期始，DateTo：出院日期结束
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMROutputSummaryQery","GetWJYBEMRCYXJ","2015-8-23","2016-8-23")
Query GetWJYBEMRCYXJ(DateFrom As %String, DateTo As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "WATENUMBER:%String,OrgCode:%String,SERIAL:%String,INPANUMBER:%String,PATINAME:%String,CYXJ:%String,OUTHOSPDATE:%String,XJRQ:%String") [ SqlName = WJYB_EMRCYXJ, SqlProc ]
{
}

ClassMethod GetWJYBEMRCYXJExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s AGlossaryCategoryID = "HDSD00.16"
	s StartDate	= $g(DateFrom)
	s EndDate	= $g(DateTo)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""
	
	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for {
		s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
		q:(AEpisodeID = "")
		//s StandDataArry = ..GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
		s StandDataArry=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
		s (WATENUMBER,OrgCode,SERIAL,INPANUMBER,PATINAME,CYXJ,OUTHOSPDATE,XJRQ)=""
	
		s WATENUMBER= AEpisodeID //住院就诊流水号
		s OrgCode= "" //医疗机构代码
		s SERIAL= ##Class(EMRservice.HISInterface.PatientInfoAssist).InTimes(AEpisodeID) //住院次数
		s INPANUMBER= StandDataArry.GetAt("HDSD00.16.052") //住院号
		s PATINAME= StandDataArry.GetAt("HDSD00.16.019") //姓名
		s CYXJ= StandDataArry.GetAt("HDSD00.16.004") //出院小结
		s OUTHOSPDATE= StandDataArry.GetAt("HDSD00.16.005") //出院日期
		s XJRQ= StandDataArry.GetAt("HDSD00.16.028") //小结开具日期
	
	
		s Data = $lb(WATENUMBER,OrgCode,SERIAL,INPANUMBER,PATINAME,
					CYXJ,OUTHOSPDATE,XJRQ)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	}
	q $$$OK
}

ClassMethod GetWJYBEMRCYXJFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWJYBEMRCYXJExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetWJYBEMRCYXJClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWJYBEMRCYXJExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取指定术语集范畴下的所有术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory("1","1")
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String, instanceDataID As %String = "") As %ArrayOfDataTypes
{
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ""

	s retArray = ##Class(%ArrayOfDataTypes).%New()

	s glossaryID = ""
	for {
		s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
		q:(glossaryID="")
	
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
		continue:(objGlossary="")
	
		s internalID = objGlossary.InternalID
		;s value = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		
		//通过注册号，术语rowId获取业务数据
		s strDataValue = ..GetScatterDataByGlossaryID(AEpisodeID,glossaryID,instanceDataID)
		if (strDataValue ="")
		{
			s strDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		}
		/*S objStandData =  ##Class(EPRservice.entity.EStandDataInfo).%New()
		S objStandData.strInternalID = internalID
		s strValue=$tr(value,"<","(")
		s strValue=$tr(strValue,">",")")
		S objStandData.displayName = strValue
		*/

		d retArray.SetAt(strDataValue, internalID)
	
	}
	q retArray
}

/// Desc: 	使用术语集取电子病历打散数据
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EPRservice.BLL.BLDataETranFactory).GetScatterDataByGlossaryID("58","1811","810||2")
ClassMethod GetScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String, instanceDataID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			
			s itemCode = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s ret = ""
			if (instanceDataID = ""){
			s ret = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,templateID,itemCode,valueType)
			}else{
			s ret = ##Class(EPRservice.BOScatterData).GetMultipleScatterData(AEpisodeID,templateID,itemCode,instanceDataID,valueType)
			}
			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s parGlossaryID = objGlossary.ParentID
		q:(parGlossaryID = "") ret

		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlossaryID)
		q:(objParGlossary = "") ret
			
		s parRowID = ""
		for {
			s parRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlossaryID,parRowID))
			q:(parRowID = "")
			
			s objParItem = ##Class(EPRmeta.GlossaryItem).%OpenId(parRowID)
			
			s parItemCode = objParItem.ItemCode
			s parValueType = objParItem.ValueType
			s parTemplateID = objParItem.TemplateID

			//s parItemValue = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,parTemplateID,parItemCode,parValueType)
			//if (parItemValue = "")
			//{
			//	q
			//}
			s kbRowID = ""
			for {
				s kbRowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",AGlossaryID,kbRowID))
				q:(kbRowID = "")
			
				s objParItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbRowID)
				s curItemCode = objParItem.ItemCode
				s curValueType = objParItem.ValueType
				s kbPartNo = objParItem.KBPartNo
				S KBNodeID = objParItem.KBNodeID
			
				s curTextSimpleRowID= ""
				for
				{
					s curTextSimpleRowID = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate"," "_instanceDataID," "_parItemCode," "_KBNodeID," "_kbPartNo," "_curItemCode,curTextSimpleRowID))
					q:(curTextSimpleRowID = "")
					s curItemType = $e($tr(curItemCode," ",""),0,1)
					s curTextSimpleValue = ##Class(EPRservice.BOScatterData).GetITextDescSimpleValue(curTextSimpleRowID,curItemType,$tr(curValueType," ",""))
					if (curTextSimpleValue '= "")
					{
						s ret = curTextSimpleValue
						q	
					}	
				}	
			}	
		}
	}
	s:(ret="Null") ret = ""
	q ret
}

}
