Class DHCEPRFS.BL.BLFileStoreConfig Extends %RegisteredObject
{

/// w ##Class(DHCEPRFS.BL.BLFileStoreConfig).GetFileStoreConfig(64449,"DHCEPRFS")
ClassMethod GetFileStoreConfig(ADate As %Date, ANameSpace As %String = "DHCEPRFS") As %String
{
	//^DHCEPRFS.META.FileStoreConfigI("IdxDate",63631,64727,3) = $lb("","127.0.0.1","/fs02")]
	s config = ""
	s id = ..GetFileStoreConfigBase(ADate,ANameSpace)
	s obj = ##class(DHCEPRFS.META.FileStoreConfig).%OpenId(id)
	s DecryptUserName = ##class(web.Util.Encryption).SimpleDecrypt(obj.FileServerUserName)
	s DecryptPassword = ##class(web.Util.Encryption).SimpleDecrypt(obj.FileServerPassword)
	
	s config = obj.FTPMethod_"^"_obj.FileServerIP_"^"_obj.FileServerPort_"^"_DecryptUserName_"^"_DecryptPassword_"^"_obj.FileServerTimeOut_"@@@"_obj.FileServerIP_"|"_obj.VirtualDir
	q config
}

ClassMethod GetFileStoreConfigBase(ADate As %Date, ANameSpace As %String = "DHCEPRFS") As %String
{
	s id = ""	
	s stDate = ""
	for {
		//b "s"
		s stDate = $O(^DHCEPRFS.META.FileStoreConfigI("IdxDate"," "_ANameSpace,stDate))
		q:(stDate="")||(stDate > ADate)
		
		s endDate = $O(^DHCEPRFS.META.FileStoreConfigI("IdxDate"," "_ANameSpace,stDate,""))
		continue:(endDate < ADate)
		
		s id = 	$O(^DHCEPRFS.META.FileStoreConfigI("IdxDate"," "_ANameSpace,stDate,endDate,""))
		
		q
	}
	
	q id
}

/// d ##Class(DHCEPRFS.BL.BLFileStoreConfig).AddFileStoreConfig("1840-12-31","2017-06-01","127.0.0.1","/","DHCEPRFS")
/// d ##Class(DHCEPRFS.BL.BLFileStoreConfig).AddFileStoreConfig("2017-06-01","2018-03-20","127.0.0.1","/fs02","DHCEPRFS")
ClassMethod AddFileStoreConfig(AStartDate As %String, AEndDate As %String, AFileServerIP As %String, AVirtualDir As %String, ANameSpace As %String = "", APort As %String = "21", AUserName As %String = "anonymous", APassword As %String = "", ATimeOut As %String = "5", AFTPMethod = "edtftp") As %String
{
	s stDate = $zdh(AStartDate,3)
	s enDate = $zdh(AEndDate,3)
	s cfg = ##class(DHCEPRFS.META.FileStoreConfig).%New()
	s cfg.StartDate = stDate
	s cfg.EndDate = enDate
	s cfg.FileServerIP = AFileServerIP
	s cfg.VirtualDir = AVirtualDir
	s cfg.NameSpace = ANameSpace
	s cfg.FileServerPort = APort
	s cfg.FileServerUserName = AUserName
	s cfg.FileServerPassword = APassword
	s cfg.FileServerTimeOut = ATimeOut
	s cfg.FTPMethod = AFTPMethod
	s sc = cfg.%Save()
	q cfg.%Id()
}

}
