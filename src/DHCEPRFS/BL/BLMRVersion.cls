Class DHCEPRFS.BL.BLMRVersion Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	注册MRVersion对象并获取其RowID
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRVersion).RegMRVersionID("21","SEALUP_13")
ClassMethod RegMRVersionID(AMRID As %String, AVersion As %String, AType As %String = "") As %String
{
	//处理入参
	//s AVersion = +AVersion
	
	//获取MRVersionID
	s mrVersionID = ..GetMRVersionID(AMRID, AVersion,AType)
	
	//MRVersion不存在，创建
	if (mrVersionID = "")
	{
		s mrVersionID = ..CreateMRVersion(AMRID, AVersion,AType)
	}
	
	q mrVersionID
}

ClassMethod GetMRVerionIDByType(AMrEpisodeID As %String, AVersionTypeCode As %String)
{
	if (AVersionTypeCode = "")
	{
		s versionType = "0"
	}
	else
	{
		if ($l(AVersionTypeCode,"_")=1)
		{
			s versionNum = ##class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionByTypeCode(AVersionTypeCode)
			s versionType = versionNum
		}
		else
		{
			s versionType = AVersionTypeCode
		}
	}
	s mrVersionID = ..GetMRVersionID(AMrEpisodeID,versionType)
	q mrVersionID
}

/// Desc:	获取MRVersionID
/// debug: w ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID("21","SEALUP_13","")
ClassMethod GetMRVersionID(AID As %String, AVersion As %String = "0", AType As %String = "") As %String
{
	q:(AID="")||(AVersion="") ""
	
	
	if ($l(AVersion,"_")=1)
	{
		s AVersion = +AVersion
		if (AType '= "")
		{
			s rowID = $O(^DHCEPRFS.INST.MRVersionI("IdxMRMedRecord", " "_AID, AVersion, ""))
		}
		else
		{
			s rowID = $O(^DHCEPRFS.INST.MRVersionI("IdxMain", " "_AID, AVersion, ""))
		}
	}
	else
	{
		s type = $p(AVersion,"_",1)
		s version = $p(AVersion,"_",2)
		s version = +version
		s rowID = $O(^DHCEPRFS.INST.MRVersionI("IdxType",  " "_AID,version, " "_type, ""))
	}
	q rowID
}

/// Desc:	创建MRVersion
ClassMethod CreateMRVersion(AID As %String, AVersion As %String, AType As %String = "") As %String
{
	s now = $h
	
	if ($l(AVersion,"_")=1)
	{
		s obj = ##Class(DHCEPRFS.INST.MRVersion).%New()
		s obj.Version = +AVersion
		if (AType '= "")
		{
			s obj.MRMedRecordID = AID
			s obj.MREpisodeID = ""
		}
		else
		{
			s obj.MRMedRecordID = ""
			s obj.MREpisodeID = AID	
		}
		s obj.CreateDate = $p(now,",",1)
		s obj.CreateTime = $p(now,",",2)
		s obj.ModifyDate = $p(now,",",1)
		s obj.ModifyTime = $p(now,",",2)
		s obj.Type = ""
	
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q ""
		}
	}
	else
	{
		s obj = ##Class(DHCEPRFS.INST.MRVersion).%New()
		s obj.Version = +$p(AVersion,"_",2)
		if (AType '= "")
		{
			s obj.MRMedRecordID = AID
			s obj.MREpisodeID = ""
		}
		else
		{
			s obj.MRMedRecordID = ""
			s obj.MREpisodeID = AID	
		}
		s obj.CreateDate = $p(now,",",1)
		s obj.CreateTime = $p(now,",",2)
		s obj.ModifyDate = $p(now,",",1)
		s obj.ModifyTime = $p(now,",",2)
		s obj.Type = $p(AVersion,"_",1)
	
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q ""
		}
	}
}

}
