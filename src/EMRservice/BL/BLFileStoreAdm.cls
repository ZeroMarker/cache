Class EMRservice.BL.BLFileStoreAdm Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetFSAdmID(AEpisodeID As %String) As %String
{
	s id = $o(^DHCEMRI.FileStoreAdmI("IdxEpisodeID", " "_AEpisodeID, ""))
	q id
}

ClassMethod CreateFSAdm(AEpisodeID As %String) As %String
{
	s patientID = $P($g(^PAADM(AEpisodeID)),"^",1)
	q:(patientID = "") ""
	
	s admDate = $P($G(^PAADM(AEpisodeID)),"^",6)
	q:(admDate = "") ""
	
	s obj = ##Class(EMRinstance.FileStoreAdm).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.PatientID = patientID
	s obj.AdmDate = admDate
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod RegFSAdm(AEpisodeID As %String, AOutPutType As %String) As %String
{
	s id = ..GetFSAdmID(AEpisodeID)
	if (id = "")
	{
		s id = ..CreateFSAdm(AEpisodeID)
	}
	q:(id = "") ""
	
	s obj = ##class(EMRinstance.FileStoreAdm).%OpenId(id)
	q:(obj = "") ""
	
	s admDate = obj.AdmDate
	s patientID = obj.PatientID
	
	s fsc = ##Class(EMRservice.BL.BLFileStoreConfig).GetFSConfig(admDate)
	q:(fsc = "") ""
	
	s admDirType = $p(fsc,"|",3)
	s admPath = ##class(EMRservice.BL.BLFileStoreConfig).AdmDirType2Path(admDirType,patientID,AEpisodeID,admDate,AOutPutType)
	
	s $p(fsc,"|",3) = admPath
	
	q fsc
}

/// Debug:	w ##Class(EMRservice.BL.BLFileStoreAdm).GetFileStore("1")
ClassMethod GetFSAdm(AEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") ""
	
	s id = ..GetFSAdmID(AEpisodeID)
	if (id = "")
	{
		s obj = ##class(EMRinstance.FileStoreAdm).%OpenId(id)
		q:(obj = "") ""
		
		s admDate = obj.AdmDate
		s patientID = obj.PatientID
	}
	else
	{
		s admDate = $P($G(^PAADM(AEpisodeID)),"^",6)
	
		s patientID = $P($g(^PAADM(AEpisodeID)),"^",1)
		q:(patientID = "") ""
	}
	
	s fsc = ##Class(EMRservice.BL.BLFileStoreConfig).GetFSConfig(admDate)
	q:(fsc = "") ""
	
	s admDirType = $p(fsc,"|",3)
	s admPath = ##class(EMRservice.BL.BLFileStoreConfig).AdmDirType2Path(admDirType,patientID,AEpisodeID,admDate)
	
	s $p(fsc,"|",3) = admPath
	
	q fsc
}

ClassMethod GetAdmFilePath(AEpisodeID As %String) As %String
{
	s fsc = ..GetFSAdm(AEpisodeID)
	q:($L(fsc,"|") '= 3) ""
	
	s vitualDir = $p(fsc,"|",2)
	s admDir = $p(fsc,"|",3)
	if (vitualDir = "/")
	{
		q $p(fsc,"|",1)_"|"_admDir
	}
	else
	{
		q $p(fsc,"|",1)_"|"_vitualDir_admDir
	}
}

}
