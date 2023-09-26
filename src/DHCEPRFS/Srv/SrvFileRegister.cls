Class DHCEPRFS.Srv.SrvFileRegister Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvFileRegister";

ClassMethod RegisterFileByFile(AFullFileName As %String, AMD5Code As %String = "", ANameSpace As %String = "DHCEPRFS") As DHCEPRFS.Entity.EFileRegister [ WebMethod ]
{
	s eFileReg = ##Class(DHCEPRFS.Entity.EFileRegister).%New()
	s eFileReg.FullFileMasterName = AFullFileName
	s eFileReg.MD5Code = AMD5Code
	s eFileReg.NameSpace = ANameSpace
	s retEFileRegister = ##Class(DHCEPRFS.BL.BLFileRegister).RegisterFile(eFileReg)
	q retEFileRegister
}

ClassMethod RegisterFile(AEFileReg As DHCEPRFS.Entity.EFileRegister) As DHCEPRFS.Entity.EFileRegister [ WebMethod ]
{
	s retEFileRegister = ##Class(DHCEPRFS.BL.BLFileRegister).RegisterFile(AEFileReg)
	q retEFileRegister
}

ClassMethod GetRegisterFile(AFileMasterID As %String) As DHCEPRFS.Entity.EFileRegister [ WebMethod ]
{
	s retEFileRegister = ##Class(DHCEPRFS.BL.BLFileRegister).GetRegisterFile(AFileMasterID)
	q retEFileRegister
}

ClassMethod GetRegisterFileByName(AFileMasterName As %String) As DHCEPRFS.Entity.EFileRegister [ WebMethod ]
{
	s retEFileRegister = ##Class(DHCEPRFS.BL.BLFileRegister).GetRegisterFileByName(AFileMasterName)
	q retEFileRegister
}

ClassMethod RegFileList(AFileMasterNameList As %String, AMD5CodeList As %String = "", ANameSpaceList As %String = "") As %String [ WebMethod ]
{
	s:(AFileMasterNameList = $c(0)) AFileMasterNameList = ""
	s:(AMD5CodeList = $c(0)) AMD5CodeList = ""
	s:(ANameSpaceList = $c(0)) ANameSpaceList = ""
	s ret = ##Class(DHCEPRFS.BL.BLFileRegister).RegFileList(AFileMasterNameList,AMD5CodeList,ANameSpaceList)
	q ret
}

ClassMethod UpdateMD5Code(AParam As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLFileRegister).UpdateMD5Code(AParam)
	q ret
}

/// d ##Class(DHCEPRFS.Srv.SrvFileRegister).Test()
ClassMethod Test()
{
	s obj = ..RegisterFileByFile("/pat1/epi1/epr/hdsd00.11/5.pdf")
	b "s"
}

/// d ##Class(DHCEPRFS.Srv.SrvFileRegister).TestGet2()
ClassMethod TestGet2()
{
	s name = "/pat1/epi1/epr/hdsd00.11/5.pdf"
	s retEFileRegister = ..GetRegisterFileByName(name)
	b "s"
}

/// Desc:	注册文件
/// debug: w ##class(DHCEPRFS.BL.BLFileRegister).RegisterFileAlone("test1.tiff","md51","DHCEPRFS")  
ClassMethod RegisterFileScan(AFileName As %String, AMD5Code As %String, ANameSpace As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLFileRegister).RegisterFileScan(AFileName,AMD5Code,ANameSpace)
}

}
