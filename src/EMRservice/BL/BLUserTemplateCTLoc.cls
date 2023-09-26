/// 名称:EMRservice.BL.BLUserTemplateCTLoc
/// 描述:模板科室服务
/// 编写者：yejian
/// 编写日期: 2016-5-17
Class EMRservice.BL.BLUserTemplateCTLoc Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定DocID下的所有科室ID
/// Input: aSchemeCode,aItemCode
/// Return: 科室1^科室2^科室3
ClassMethod GetItemLoc(aItemCode As %String) As %String
{
	
	q:(($d(aItemCode) = 0)||(aItemCode = "")) ""
	s result = ""
	
	&sql(declare myCursor cursor for
		select CTLocID into :groupid from EMRmeta.UserTemplateCTLoc
		where Code = :aItemCode)
	&sql(open myCursor)
	for {
		&sql(fetch myCursor)
		q:(SQLCODE)
		
		if result = ""
		{	s result = groupid}
		else
		{	s result =  result_"^"_groupid}
	}
	&sql(close myCursor)
	
	q result
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：保存指定科室项下所适用的科室
/// Input: aSchemeCode,aItemCode--itemcode^itemname sltLocs--所有选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name), unSltLocs--所有未选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifyLoc(aItemCode As %String, sltLocs As %String, unSltLocs As %String) As %String
{
	q:((aItemCode="")||(aItemCode = $c(0))) "0"
	s strItemCode = $p(aItemCode,"^",1)
	s strItemName = $p(aItemCode,"^",2)
	if ((sltLocs = "") || (sltLocs = $c(0)))
	{
		s sltLocsCount = 0
	}
	else
	{
		s sltLocsCount = $l(sltLocs, "^")
	}
	
	if ((unSltLocs = "") || (unSltLocs = $c(0)) )
	{
		s unSltLocsCount = 0
	}
	else
	{
		s unSltLocsCount = $l(unSltLocs, "^")
	}

	//保存选中的科室
	s i = 1
	WHILE (i <= sltLocsCount) 
	{
		s curSltLocID = $p(sltLocs, "^", i)
		//s strcurSltLocID = $p(curSltLocID,"|",1)
		//s strcurSltLocName = $p(curSltLocID,"|",2)
		s strcurSltLocID = curSltLocID
		S strcurSltLocName = $p($g(^CTLOC(curSltLocID)),"^",2)
		if (curSltLocID '= "")
		{
			s docLocRowID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCodeAndCTLocID", " "_strItemCode, " "_strcurSltLocID, 0))
			//如果没有,则新增;有则不处理
			if (docLocRowID = "")
			{
				s objTemCTLoc = ##class(EMRmeta.UserTemplateCTLoc).%New()
				q:(objTemCTLoc = "")
				
				s objTemCTLoc.Code = strItemCode
				s objTemCTLoc.CTLocID = strcurSltLocID
				s objTemCTLoc.CTLocName = strcurSltLocName
				d objTemCTLoc.%Save()
				d objTemCTLoc.%Close()
				s objTemCTLoc = ""
			}
		}
		
		s i = i + 1
	}
	
	//删除未选中的科室
	s i = 1
	WHILE (i <= unSltLocsCount) 
	{
		s curUnSltLocID = $p(unSltLocs, "^", i)
		//s strcurSltLocID = $p(curUnSltLocID,"|",1)
		s strcurSltLocID = curUnSltLocID
		if (strcurSltLocID '= "")
		{
			s itemLocRowID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCodeAndCTLocID", " "_strItemCode, " "_strcurSltLocID, 0))
			//如果有,则删除; 没有则不处理
			if (itemLocRowID '= "")
			{
				d ##class(EMRmeta.UserTemplateCTLoc).%DeleteId(itemLocRowID)
			}
		}
		
		s i = i + 1
	}
	
	//返回
	q "1"
}

/// Creator:     Candy
/// CreateDate:  2017-12-5
/// Input:       pDocID 病历docId 目录展现结构第3层
/// ///          pText 查询条件
/// Output:      rowID,Code,Desc,Type
/// Debug:       d ##Class(EMRservice.BL.BLUserTemplateCTLoc).GetUserTemplateCTLoc("66","") 
ClassMethod GetUserTemplateCTLoc(pDocID As %String, pText As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(pDocID = "") json
	s arryCtLocID = ##Class(%ArrayOfDataTypes).%New()
	d json.Write("[")
	s templateId = ""
	for
	{
		s templateId = $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_pDocID,templateId))
		q:(templateId = "")
		s code = ""
		for
		{
			s code = $o(^DHCEMRM.UserTemplateI("IdxTemplateCode",templateId,code))	
			q:(code = "")
			s userRowId =$o(^DHCEMRM.UserTemplateI("IdxTemplateCode",templateId,code,""))
			continue:(userRowId = "")
			s objUserTempalte = ##Class(EMRmeta.UserTemplate).%OpenId(userRowId)
			continue:((objUserTempalte="")||(objUserTempalte.Status '=1))
			s ctLocId = ""
			for
			{
				s ctLocId = $o(^DHCEMRM.UserTemplateCTLocI("IdxCodeAndCTLocID",code,ctLocId))
				q:(ctLocId = "")
				s rowId =  $zstrip(ctLocId,"*P")
				s locCode = $p($g(^CTLOC(rowId)),"^",1)
				s locDesc = $p($g(^CTLOC(rowId)),"^",2)
				continue:((pText '= "")&&($zcvt(locDesc,"U")'[ $zcvt(pText,"U")))
				continue:(arryCtLocID.GetAt(rowId) '= "")
				d arryCtLocID.SetAt(code,rowId)
				d:(json.Size>1) json.Write(",")
				d json.Write("{")
				d json.Write("""RowID"":"""_rowId_"""")
				d json.Write(",""Code"":"""_locCode_"""")
				d json.Write(",""Desc"":"""_locDesc_"""")
				d json.Write("}")	
			}
		 }
	}
	d json.Write("]")
	k arryCtLocID
	q json
}

/// Creator:     yejian
/// CreateDate:  2021-6-24
/// Description: 根据多个docId获取科室列表
/// Input:       ACategoryIDs 病历目录ID,ID2,ID3 
///         	 pText 查询条件
///         	 pEpisodeID 就诊ID
///         	 pUserID 当前登录用户ID
/// 			 pLocID 当前科室ID
/// Output:      rowID,Code,Desc,Type
/// Debug:       d ##Class(EMRservice.BL.BLUserTemplateCTLoc).GetUserTemplateCTLocs("1,2,3,4,5,6,23,25","",4,10209) 
ClassMethod GetUserTemplateCTLocs(ACategoryIDs As %String, pText As %String = "", pEpisodeID As %String, pUserID As %String, pLocID As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:((ACategoryIDs = "")||(pEpisodeID="")||(pUserID="")) json
	s arryCtLocID = ##Class(%ArrayOfDataTypes).%New()
	d json.Write("[")
	d json.Write("{")
	d json.Write("""RowID"":"""_"ALL"_"""")
	d json.Write(",""Code"":"""_"ALL"_"""")
	d json.Write(",""Desc"":"""_"全院"_"""")
	d json.Write("}")
	s strCIDCount = $l(ACategoryIDs,",")
	s flag = 0
	s admCTLOC="",admCTLOCID=""
	s admCTLOC = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(pEpisodeID,"","")
	s:(admCTLOC'="") admCTLOCID = $P(admCTLOC,"^",1)
	s admHospitalID = $p($g(^CTLOC(admCTLOCID)),"^",22)
	
	
	for j=1:1:strCIDCount
	{
		s categoryID = $p(ACategoryIDs,",",j)
		//先根据目录ID获取docID集合
		s pDocIDs = ##Class(EMRservice.BL.BLClientCategory).GetTempDocIdsByCategoryID(categoryID,pEpisodeID,pUserID)
		s docIDCount = $l(pDocIDs,"^")
		for i=1:1:docIDCount
		{
			s pDocID = $p(pDocIDs,"^",i)
			s templateId = ""
			for
			{
				s templateId = $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_pDocID,templateId))
				q:(templateId = "")
				s code = ""
				for
				{
					s code = $o(^DHCEMRM.UserTemplateI("IdxTemplateCode",templateId,code))	
					q:(code = "")
					s userRowId =$o(^DHCEMRM.UserTemplateI("IdxTemplateCode",templateId,code,""))
					continue:(userRowId = "")
					s objUserTempalte = ##Class(EMRmeta.UserTemplate).%OpenId(userRowId)
					continue:((objUserTempalte="")||(objUserTempalte.Status '=1))
					s ctLocId = ""
					for
					{
						s ctLocId = $o(^DHCEMRM.UserTemplateCTLocI("IdxCodeAndCTLocID",code,ctLocId))
						q:(ctLocId = "")
						s rowId =  $zstrip(ctLocId,"*P")
						
						s HospitalID = $p($g(^CTLOC(rowId)),"^",22)
						continue:(HospitalID'=admHospitalID)
						
						s locCode = $p($g(^CTLOC(rowId)),"^",1)
						s locDesc = $p($g(^CTLOC(rowId)),"^",2)
						continue:((pText '= "")&&($zcvt(locDesc,"U")'[ $zcvt(pText,"U")))
						continue:(arryCtLocID.GetAt(rowId) '= "")
						d arryCtLocID.SetAt(code,rowId)
						d:(json.Size>1) json.Write(",")
						d json.Write("{")
						d json.Write("""RowID"":"""_rowId_"""")
						d json.Write(",""Code"":"""_locCode_"""")
						d json.Write(",""Desc"":"""_locDesc_"""")
						d json.Write("}")
						s:(rowId=pLocID) flag=1	
					}
				 }
			}
		}	
	}
	if (flag=0)&&(pLocID'="")
	{
		s curCode = $p($g(^CTLOC(pLocID)),"^",1)
		s curDesc = $p($g(^CTLOC(pLocID)),"^",2)
		d:(json.Size>1) json.Write(",")
		d json.Write("{")
		d json.Write("""RowID"":"""_pLocID_"""")
		d json.Write(",""Code"":"""_curCode_"""")
		d json.Write(",""Desc"":"""_curDesc_"""")
		d json.Write("}")
	}
	d json.Write("]")
	k arryCtLocID
	q json
}

}
