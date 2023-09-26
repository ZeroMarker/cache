/// Creator:	yejian
/// CreatDate:  2019-4-15
/// Desc:		河南安阳地区医院在提供急诊留观视图表接口（需求号：870804）
Class EMRservice.InterfaceService.EMRObservationQuery Extends %RegisteredObject
{

/// Creator:	yejian
/// CreatDate:  2019-4-15
/// Desc:		急诊留观
/// Input：		AEpisodeID：就诊号
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMROutputSummaryQery","GetObservationData","58")
Query GetObservationData(AEpisodeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "WATENUMBER:%String,OrgCode:%String,SERIAL:%String,INPANUMBER:%String,PATINAME:%String,CYXJ:%String,OUTHOSPDATE:%String,XJRQ:%String") [ SqlProc ]
{
}

ClassMethod GetObservationDataExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(AEpisodeID) = "") $$$OK
	
	s AGlossaryCategoryID = "HDSD00.03.02"

	//s StandDataArry = ..GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
	s StandDataArry=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
	s (name,sex,age,clinicDoc,inToSaveTime,diagnosis,outSaveTime,treatRelsuet,isCRP,isCRPSucceed,patientto)=""

	s name= StandDataArry.GetAt("HDSD00.03.017") //姓名
	s sex= StandDataArry.GetAt("HDSD00.03.039") //性别
	s age= StandDataArry.GetAt("HDSD00.03.026") //年龄
	s clinicDoc= StandDataArry.GetAt("HDSD00.03.041") //就诊医师
	s inToSaveTime= StandDataArry.GetAt("HDSD00.03.900") //入抢救室时间
	s diagnosis= StandDataArry.GetAt("HDSD00.03.999") //初步诊断
	s outSaveTime= StandDataArry.GetAt("HDSD00.03.901") //出抢救室时间
	s treatRelsuet= StandDataArry.GetAt("HDSD00.03.902") //救治结果
	s isCRP = StandDataArry.GetAt("HDSD00.03.903") //是否CRP
	s isCRPSucceed = StandDataArry.GetAt("HDSD00.03.904") //是否CRP成功
	s patientto = StandDataArry.GetAt("HDSD00.03.905") //患者去向
	
	
	s Data = $lb(name,sex,age,clinicDoc,inToSaveTime,
				diagnosis,outSaveTime,treatRelsuet,isCRP,isCRPSucceed,
				patientto)
	s ^CacheTemp(repid,ind) = Data
	s ind = ind + 1
	
	
	q $$$OK
}

ClassMethod GetObservationDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetObservationDataExecute ]
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

ClassMethod GetObservationDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetObservationDataExecute ]
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
