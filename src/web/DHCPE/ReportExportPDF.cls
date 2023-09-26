/// 报告归档导出PDF
Class web.DHCPE.ReportExportPDF Extends %RegisteredObject
{

// d ##class(web.DHCPE.ReportExportPDF).AuditReport()

// 总检提交时插入待导出记录

ClassMethod AuditReport(PAADM, UserID As %String = "")
{
	s obj=##class(User.DHCPEReportExportPDF).%New()
	d obj.REPPAADMIDSetObjectId(PAADM)
	s:$D(%session) UserID=%session.Get("LOGON.USERID")
	d obj.REPAuditUserDRSetObjectId(UserID)
	s obj.REPAuditDate=+$H
	s obj.REPAuditTime=$P($H,",",2)
	s obj.REPStatus="0"
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

// d ##class(web.DHCPE.ReportExportPDF).CancelReport()

// 总检取消提交时取消记录

ClassMethod CancelReport(PAADM, UserID As %String = "")
{
	s OldID=$O(^User.DHCPEReportExportPDFI("REPPAADMIDIndex",PAADM,""),-1)
	q:OldID="" 0
	s:$D(%session) UserID=%session.Get("LOGON.USERID")
	s LocID=$P($G(^PAADM(PAADM)),"^",4)
	s obj=##class(User.DHCPEReportExportPDF).%OpenId(OldID)
	d obj.REPCancelUserDRSetObjectId(UserID)
	s obj.REPCancelDate=+$H
	s obj.REPCancelTime=$P($H,",",2)
	s obj.REPStatus=1
	s OldFileName=obj.REPExportFileName
	i OldFileName'="" d
	.s NewFileName=$P(OldFileName,".pdf",1)_"-"_OldID_".pdf"
	.;s ReportFtp=$G(^DHCPESetting("DHCPE","ReportFTP"))   ;FTPIP^FTPUser^FTPPassWord^FTPPort
	.s ReportFtp=$G(^DHCPESetting("DHCPE","ReportFTP",LocID))
	.s ServerIP=$P(ReportFtp,"^",1)
	.s User=$P(ReportFtp,"^",2)
	.s PassWord=$P(ReportFtp,"^",3)
	.s Port=$P(ReportFtp,"^",4)
	.s ConnectFlag=##class(web.DHCPE.FTPManager).Connect(.ftp,ServerIP, User, PassWord, Port)
	.i ConnectFlag=0 d
	..s obj.REPExportFileName=""
	.e  d
	..s ReNameFlag=##class(web.DHCPE.FTPManager).FTPFileRename(ServerIP, User, PassWord, Port,OldFileName,NewFileName)
	..i ReNameFlag=1 d
	...s obj.REPExportFileName=NewFileName
	..e  d
	...s obj.REPExportFileName=""
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

// 导出时更新报告导出记录

ClassMethod ExportReport(ID, Status, FileName)
{
	s obj=##class(User.DHCPEReportExportPDF).%OpenId(ID)
	s obj.REPExportDate=+$H
	s obj.REPExportTime=$P($H,",",2)
	s obj.REPStatus=Status
	s obj.REPExportFileName=FileName
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

// 得到报告上传使用的ftp信息

ClassMethod GetReportFTPInfo(LocID As %String = "")
{
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	//q $G(^DHCPESetting("DHCPE","ReportFTP"))
	q $G(^DHCPESetting("DHCPE","ReportFTP",LocID))
}

// 得到报告保存在ftp上的目录

ClassMethod GetReportAppName(PAADM)
{
	;w ##class(web.DHCPE.ReportExportPDF).GetReportAppName(273)
	s LocID=$P($G(^PAADM(PAADM)),"^",4)
	//s ReportFtp=$G(^DHCPESetting("DHCPE","ReportFTP")) ;FTPIP^FTPUser^FTPPassWord^FTPPort
	s ReportFtp=$G(^DHCPESetting("DHCPE","ReportFTP",LocID))

	s ServerIP=$P(ReportFtp,"^",1)
	s User=$P(ReportFtp,"^",2)
	s PassWord=$P(ReportFtp,"^",3)
	s Port=$P(ReportFtp,"^",4)
	s ConnectFlag=##class(web.DHCPE.FTPManager).Connect(.ftp,ServerIP, User, PassWord, Port)
	q:ConnectFlag=0 ""
	//获取报告地址
	s InPath="/PEReport/"
	s ret=##class(web.DHCPE.FTPManager).CreateDirectory(ServerIP, User, PassWord, Port, InPath)
	s PatID=$P(^PAADM(PAADM),"^",1)
	s Dir=InPath_"Report"_((PatID\10000)+1)
	s ret=##class(web.DHCPE.FTPManager).CreateDirectory(ServerIP, User, PassWord, Port, Dir)
	s Dir=Dir_"/"_PatID
	s ret=##class(web.DHCPE.FTPManager).CreateDirectory(ServerIP, User, PassWord, Port, Dir)
	q Dir_"/"
}

// w ##class(web.DHCPE.ReportExportPDF).GetReportPath("213")

// 得到报告上传到ftp上的文件名

ClassMethod GetReportPath(PAADM)
{
	//获取报告ftp信息
	s OldID=$O(^User.DHCPEReportExportPDFI("REPPAADMIDIndex",PAADM,""),-1)
	q:OldID="" ""
	s Status=$LG(^User.DHCPEReportExportPDFD(OldID),3)
	q:Status'=3 ""
	s FileName=$LG(^User.DHCPEReportExportPDFD(OldID),12)
	q FileName
}

}
