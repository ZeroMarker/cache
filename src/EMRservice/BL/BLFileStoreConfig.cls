Class EMRservice.BL.BLFileStoreConfig Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter EMRFileStoreNS = "DHCEMR";

Parameter DefaultFSConfig = "|/|VOL";

ClassMethod AdmDirType2Path(AAdmDirType, APatientID, AEpisodeID, AAdmDate, AOutPutType) As %String
{
	q:(AAdmDirType = "")||(APatientID = "")||(AEpisodeID = "")||(AAdmDate = "") ""
	
	s path = ""
	s strFileName ="dhcepr"
	if (AOutPutType="XML")
	{
		s strFileName ="emrcdaxml"
	}
	else
	{
		s strFileName ="dhcepr"
	}
	s:($f(AAdmDate,"-")=0) AAdmDate = $zd(AAdmDate,3)
	
	
	if (AAdmDirType = "VOL")
	{
		s volno = (APatientID \ 10000) + 1
		
    	s path="/"_strFileName_"/vol"_volno_"/"_APatientID_"/"_AEpisodeID
		
	}
	elseif (AAdmDirType = "ADMDATE")
	{
		s path = "/"_strFileName_"/"_AAdmDate_"/"_AEpisodeID
	}
	else
	{
		s volno = (APatientID \ 10000) + 1
    	s path="/"_strFileName_"/vol"_volno_"/"_APatientID_"/"_AEpisodeID
	}
	
	q path
}

/// w ##Class(EMRservice.BL.BLFileStoreConfig).GetFSConfig(64449)
ClassMethod GetFSConfig(ADate As %Date) As %String
{
	q:(ADate = "") ""
	
	s config = ..#DefaultFSConfig
	s ANameSpace = ..#EMRFileStoreNS
	
	//^DHCEMRM.FileStoreConfigI("IdxDate",63631,64727,3) = $lb("","127.0.0.1","/fs02","ADMDATE")]
	s stDate = ""
	for {
		//b "s"
		s stDate = $O(^DHCEMRM.FileStoreConfigI("IdxDate"," "_ANameSpace,stDate))
		q:(stDate="")||(stDate > ADate)
		
		s endDate = $O(^DHCEMRM.FileStoreConfigI("IdxDate"," "_ANameSpace,stDate,""))
		continue:(endDate < ADate)
		
		s id = 	$O(^DHCEMRM.FileStoreConfigI("IdxDate"," "_ANameSpace,stDate,endDate,""))
		
		s configLB = $g(^DHCEMRM.FileStoreConfigI("IdxDate"," "_ANameSpace,stDate,endDate,id))
		s config = $lg(configLB,2)_"|"_$lg(configLB,3)_"|"_$lg(configLB,4)
		q
	}
	
	q config
}

/// w ##Class(EMRservice.BL.BLFileStoreConfig).AddFSConfig("1840-12-31","2015-05-31","10.160.16.30","/","VOL")
/// w ##Class(EMRservice.BL.BLFileStoreConfig).AddFSConfig("2015-06-01","2020-12-31","10.160.16.30","/eprftp02","ADMDATE")
ClassMethod AddFSConfig(AStartDate As %String, AEndDate As %String, AFileServerIP As %String, AVirtualDir As %String, AAdmDirType As %String) As %String
{
	s ns = ..#EMRFileStoreNS
	
	s stDate = $zdh(AStartDate,3)
	s enDate = $zdh(AEndDate,3)
	s cfg = ##class(EMRmeta.FileStoreConfig).%New()
	s cfg.NameSpace = ns
	s cfg.StartDate = stDate
	s cfg.EndDate = enDate
	s cfg.FileServerIP = AFileServerIP
	s cfg.VirtualDir = AVirtualDir
	s cfg.AdmDirType = AAdmDirType	
	d cfg.%Save()
	q cfg.%Id()
}

}
