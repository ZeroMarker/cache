/// Desc:专科知识库目录
/// Creator:Candy
/// CreateDate:2018-2-28
Class EMRservice.BL.BLTextKBCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 初始化数据
/// Creator:Candy
/// CreateDate:2018-2-28
/// Debug:d ##Class(EMRservice.BL.BLTextKBCategory).InitData()
ClassMethod InitData()
{
		d ..AddData("病毒性肌炎","folder",0)
		d ..AddData("大动脉炎","folder",0)	
		d ..AddData("TX并发症","folder",1)
}

/// Desc:添加目录数据
/// Creator:Candy
/// CreateDate:2018-2-28
/// Input: AName 名称
///       AType 类型
///       AParentID 父节点
ClassMethod AddData(AName As %String, AType As %String, AParentID As %String) As %String
{
		s result = ""
		q:(AName = "")||(AType = "")||(AParentID = "") result
		s rowId = $o(^DHCEMRM.TextKBCategoryI("IdxKBCCode"," "_$zcvt(AName,"u"),""))
		if (rowId = "")
		{
			s obj = ##Class(EMRmeta.TextKBCategory).%New()
			s obj.Sequence = $case($d(^DHCEMRM.TextKBCategoryD)>0,0:1,:^DHCEMRM.TextKBCategoryD+1)
		}
		else
		{
			s obj = ##Class(EMRmeta.TextKBCategory).%OpenId(rowId)
		}
		s obj.Name = AName
		s obj.Type = AType
		s obj.ParentID = AParentID
		s obj.IsValid = "Y"
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:      取目录数据
/// Creator:   Candy
/// CreateDate:2018-2-28
/// Input:     AName 名称
///            AType 类型
///            AParentID 父节点
/// Debug:     s a= ##Class(EMRservice.BL.BLTextKBCategory).GetData(1)
ClassMethod GetData(AParentID As %String, ALocID As %String, AType = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(AParentID = "") json
	d json.Write("[")
	s seq = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	for
	{
		s seq = $o(^DHCEMRM.TextKBCategoryI("IdxParentIDSeq",AParentID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.TextKBCategoryI("IdxParentIDSeq",AParentID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.TextKBCategory).%OpenId(rowId)
			continue:(obj = "")
			continue:(obj.IsValid = "N")
			if ((ALocID '= "")&&(obj.ParentID '= "0"))
			{
				s tmpobj = ##Class(EMRmeta.TextKBCategory).%OpenId(obj.ParentID)
				q:((tmpobj.ParentID = "0")&&($d(^DHCEMRM.TextKBLocI("IdxCategoryLocID",rowId,ALocID))<=0))
				s tmpobj = ""
			}
		    q:(..CheckContentStatus(rowId) = "0")
			
			d:(json.Size '= 1) json.Write(",")
			d json.Write("{")
			d json.Write("""id"":"""_rowId_"""")
			s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.TextKBCategory","Name",obj.Name,langid)
			if (AType = "hisui")
			{
				d json.Write(",""text"":"""_name_"""")
			}
			else
			{
				d json.Write(",""name"":"""_name_"""")
			}
			d json.Write(",""attributes"":")
			d json.Write("{")
			d json.Write("""type"":"""_obj.Type_"""")
			d json.Write("}")
			if (obj.Type = "folder")
			{
				d json.Write(",""icon"":""/img/parent.gif""")
			}
			else
			{
				d json.Write(",""icon"":""/img/leaf.gif""")
			}
			d json.Write(",""children"":")
			s child = ..GetData(rowId,ALocID,AType)
			d json.CopyFrom(child)
			d json.Write("}")
		}
	}
	d json.Write("]")
	q json
}

/// Desc:      检查知识库是否审核
/// Creator:   Candy
/// CreateDate:2018-3-14
ClassMethod CheckContentStatus(ACategoryID As %String)
{
	s result = "1"
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.TextKBContentI("IdxCategoryID",ACategoryID,rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.TextKBContent).%OpenId(rowId)
		q:(obj = "")
		s:(obj.Status '= 1) result = "0"
		q:(result = 0)
	}
	q result
}

/// Desc:      取目录大类
/// Creator:   Candy
/// CreateDate:2018-3-14
ClassMethod GetCategory() As %String
{
	s result = ""
	s seq = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	for
	{
		s seq = $o(^DHCEMRM.TextKBCategoryI("IdxParentIDSeq","0",seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.TextKBCategoryI("IdxParentIDSeq","0",seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.TextKBCategory).%OpenId(rowId)
			continue:(obj = "")
			continue:(obj.IsValid = "N")
			s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.TextKBCategory","Name",obj.Name,langid)
			s:(result '= "") result = result_","
			s result = result_"{"
			s result = result_"""id"":"""_rowId_""""
			s result = result_",""text"":"""_name_""""
			s result = result_"}"
		}
	}
	s result = "["_result_"]"
	q result
}

/// Creator:     Candy
/// CreateDate:  2017-12-5
/// Input:       pDocID 病历docId 目录展现结构第3层
/// ///          pText 查询条件
/// Output:      rowID,Code,Desc,Type
/// Debug:       d ##Class(EMRservice.BL.BLTextKBCategory).GetTextKBLoc("1","") 
ClassMethod GetTextKBLoc(pCategoryID As %String, pText As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	d json.Write("[]")
	q:(pCategoryID = "") json
	d json.Clear()
	s arryCtLocID = ##Class(%ArrayOfDataTypes).%New()
	d json.Write("[")
	s tmpCategoryId = ""
	for
	{
		s tmpCategoryId = $o(^DHCEMRM.TextKBCategoryI("IdxParentID",pCategoryID,tmpCategoryId))
		q:(tmpCategoryId = "")
		s locId = ""
		for
		{
			s locId = $o(^DHCEMRM.TextKBLocI("IdxCategoryLocID",tmpCategoryId,locId))
			q:(locId = "")
			s locCode = $p($g(^CTLOC(locId)),"^",1)
			s locDesc = $p($g(^CTLOC(locId)),"^",2)
			continue:((pText '= "")&&($zcvt(locDesc,"U")'[ $zcvt(pText,"U")))
			continue:(arryCtLocID.GetAt(locId) '= "")
			//支持首拼检索
			s locjp = ##class(web.DHCINSUPort).GetCNCODE(locDesc,4,"")
			s locDescJP = locjp_locDesc
			d arryCtLocID.SetAt(locCode,locId)
			d:(json.Size>1) json.Write(",")
			d json.Write("{")
			d json.Write("""RowID"":"""_locId_"""")
			d json.Write(",""Code"":"""_locCode_"""")
			d json.Write(",""Desc"":"""_locDesc_"""")
			d json.Write(",""DescJP"":"""_locDescJP_"""")
			d json.Write("}")				
		}
	}
	d json.Write("]")
	k arryCtLocID
	q json
}

}
