Class DHCEPRFS.BL.BLDirLoc Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod AddDirLocByFullPath(AFullPath As %String) As %String
{
	s count = $Length(AFullPath, "/")
	q:(count < 2) ""
	
	s parentID = "0", dirLocID = ""
	for i = 2:1:count
	{
		s path = $P(AFullPath, "/", i)
		s pathLevel = i - 1
		s bigPath = $zcvt(path,"u")
		s dirLocID = $O(^DHCEPRFS.INST.DirLocI("IdxParentIDAndPath", parentID, " "_bigPath, ""))
		if (dirLocID = "")
		{
			s dirLocID = ..AddDirLoc(parentID, path, pathLevel)
		}
		q:(dirLocID = "")
		
		s parentID = dirLocID
	}
	
	q dirLocID
}

ClassMethod AddDirLoc(AParentID As %String, APath As %String, APathLevel As %String) As %String
{
	s newDirLoc = ##Class(DHCEPRFS.INST.DirLoc).%New()
	s newDirLoc.ParentID = AParentID
	s newDirLoc.Path = APath
	s newDirLoc.PathLevel = APathLevel
	
	s sc = newDirLoc.%Save()
	if ($$$ISOK(sc))
	{
		q newDirLoc.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod GetMaxDirLocID() As %String
{
	s maxID = $O(^DHCEPRFS.INST.DirLocD(""))
	q mzxID
}

/// w ##class(DHCEPRFS.BL.BLDirLoc).GetFullDirLocName(4)
ClassMethod GetFullDirLocName(ADirLocID As %String) As %String
{
	q:(ADirLocID="") ""
	q:(ADirLocID="0") "/"
	
	s retDirLocName = "", curDirLocID = ADirLocID
	for {
		s objDirLoc = ##Class(DHCEPRFS.INST.DirLoc).%OpenId(curDirLocID)
		if (objDirLoc="")
		{
			s retDirLocName = ""
			q
		}
		else
		{
			s retDirLocName = "/"_objDirLoc.Path_retDirLocName
			s curDirLocID = objDirLoc.ParentID
			q:(curDirLocID = "0")
		}
	}
	
	q retDirLocName
}

/// w ##class(DHCEPRFS.BL.BLDirLoc).GetNamespaceByDirLocID(4)
ClassMethod GetNamespaceByDirLocID(ADirLocID As %String) As %String
{
	q:(ADirLocID ="") ""
	s nameSpace = ""
	s objOne = ##class(DHCEPRFS.INST.DirLoc).%OpenId(ADirLocID)
	s nameSpace = objOne.Path
	s count = objOne.PathLevel
	s rowID = ADirLocID
	for i =1:1:count
	{
		s obj = ##class(DHCEPRFS.INST.DirLoc).%OpenId(rowID)
		s rowID = obj.ParentID
		s nameSpace = obj.Path
	}
		
	
	q nameSpace
}

}
