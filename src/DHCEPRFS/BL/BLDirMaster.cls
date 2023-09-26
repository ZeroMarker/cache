Class DHCEPRFS.BL.BLDirMaster Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取目录ID
ClassMethod GetFullDirMasterIDByFileName(AFullFileName As %String) As %String
{
	/*
	s count = $Length(AFullFileName, "/")
	q:(count<3) ""
	
	s dirCount = count - 1
	
	s parentID = "0", dirMasterID = ""
	for i = 2:1:dirCount
	{
		s path = $P(AFullFileName, "/", i)
		s path = $zcvt(path,"u")
		s dirMasterID = $O(^DHCEPRFS.INST.DirMasterI("IdxFullPath", parentID, " "_path, ""))
	}
	*/
}

/// Desc:	获取目录ID
ClassMethod GetDirMasterIDByFile(AFullFileName As %String) As %String
{
	s count = $Length(AFullFileName, "/")
	q:(count<3) ""
	
	s dirCount = count - 1
	
	s parentID = "0", dirMasterID = ""
	for i = 2:1:dirCount
	{
		s path = $P(AFullFileName, "/", i)
		s path = $zcvt(path,"u")
		s dirMasterID = $O(^DHCEPRFS.INST.DirMasterI("IdxParentIDAndPath", parentID, " "_path, ""))
		q:(dirMasterID = "")
		
		s parentID = dirMasterID
	}
	
	q dirMasterID
}

/// Desc:	根据文件全名创建相应的文件目录
ClassMethod AddDirMasterByFile(AFullFileName As %String) As %String
{
	//b "s"
	s count = $Length(AFullFileName, "/")
	q:(count<3) ""
	
	s dirCount = count - 1
	
	s parentID = "0", dirMasterID = ""
	for i = 2:1:dirCount
	{
		b "s"
		s path = $P(AFullFileName, "/", i)
		s pathLevel = i - 1
		s bigPath = $zcvt(path,"u")
		s dirMasterID = $O(^DHCEPRFS.INST.DirMasterI("IdxParentIDAndPath", parentID, " "_bigPath, ""))
		if (dirMasterID = "")
		{
			s dirMasterID = ..AddDirMaster(parentID, path, pathLevel)
			q:(dirMasterID = "")
		}
		
		s parentID = dirMasterID
	}
	
	//b "s"
	q dirMasterID
}

/// Desc:	创建指定的文件目录
ClassMethod AddDirMaster(AParentID As %String, APath As %String, APathLevel As %String) As %String
{
	b "s"
	s newDir = ##Class(DHCEPRFS.INST.DirMaster).%New()
	s newDir.ParentID = AParentID
	s newDir.Path = APath
	s newDir.PathLevel = APathLevel
	s sc = newDir.%Save()
	if ($$$ISOK(sc))
	{
		q newDir.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod GetFullDirMasterName(ADirMasterID As %String) As %String
{
	q:(ADirMasterID="") ""
	q:(ADirMasterID="0") "/"
	
	s retDirMasterName = "", curDirMasterID = ADirMasterID
	for {
		s objDirMaster = ##Class(DHCEPRFS.INST.DirMaster).%OpenId(curDirMasterID)
		if (objDirMaster="")
		{
			s retDirMasterName = ""
			q
		}
		else
		{
			s retDirMasterName = "/"_objDirMaster.Path_retDirMasterName
			s curDirMasterID = objDirMaster.ParentID
			q:(curDirMasterID = "0")
		}
	}
	
	q retDirMasterName
}

}
