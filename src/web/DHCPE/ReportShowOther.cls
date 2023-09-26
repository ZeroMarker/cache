Class web.DHCPE.ReportShowOther Extends %Persistent
{

/// w ##class(web.DHCPE.ReportShowOther).GetRptImgByPaadm(1234)
ClassMethod GetRptImgByPaadm(PAADM)
{
	q:PAADM="" "[]"
	
    s LocID=$p($g(^PAADM(PAADM)),"^",4)
    
	s OrderID=$o(^OEORD(0,"Adm",PAADM,0))
	q:OrderID="" "[]"
	
	k TempDHCPERptImg
	s OrderSub="0"
	f  s OrderSub=$o(^OEORD(OrderID,"I",OrderSub)) q:OrderSub=""  d
    .s Stat=$p($g(^OEORD(OrderID,"I",OrderSub,1)),"^",13)
    .q:Stat="4"
    .s PayedFlag=$p($g(^OEORD(OrderID,"I",OrderSub,3)),"^",5)
    .q:(PayedFlag'="P")
    .
    .//报告上不打印某些医嘱(针对具体某个人的医嘱) start
    .s NoPrintFlag=""
    .s NoPrintFlag=$g(^DHCPEDataEx("DHCPEOrdItem","NotPrint",OrderID_"||"_OrderSub))
    .q:NoPrintFlag="Y"
    .//报告上不打印某些医嘱(针对具体某个人的医嘱) end 
    .
    .s ARCIMDR=$p($g(^OEORD(OrderID,"I",OrderSub,1)),"^",2)
    .//打印格式 
    .s STRowId=0
    .;s STRowId=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMDR, STRowId))
    .s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID)
    .s STRowId=$p(StatOrderDR,"||",1) 
    .q:(""=STRowId)
    .
    .//报告上不打印某些医嘱（针对医嘱项） start
    .s NoReprotPrintFlag=""
    .;s NoReprotPrintFlag=$g(^DHCPECTDataEx("DHCPEStationOrder","IFReprotPrint",ARCIMDR))
    .s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
    .s NoReprotPrintFlag=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),24)
    .q:NoReprotPrintFlag'="Y"   //报告上不需要打印
    .//报告上不打印某些医嘱（针对医嘱项）  end
    .
    .q:STRowId=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))
    .q:STRowId=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
    .
    .//站点顺序
    .;s STSequence=$p(^DHCPEST(STRowId),"^",9)
    .s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,STRowId,""))
    .s STSequence=$lg($g(^CF.PE.StationSetD(StatSetID)),5)
    .q:STSequence=""
    .//项目顺序
    .;s ARCSequence=$G(^DHCPECTDataEx("DHCPEStationOrder","Sequence",ARCIMDR))
    .s ARCSequence=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),8)
    .i ARCSequence="" d
    ..s ARCSequence="999999999"
    ..s SortID=$o(^CF.PE.StationOrdSortI("IdxOfOrderDR",StatOrderDR,0))
    ..i SortID'="" d
    ...s LocID=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),2)    //站点分类ID
    ...s ARCSequence=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),3) //站点分类顺序 
    ...s:ARCSequence="" ARCSequence="999999999"
    ..e  d
    ...s ARCSequence="999999999"
    ..;s LocInfo=$G(^DHCPEStationOrder("Loc",ARCIMDR))
    ..;s LocID=$P(LocInfo,"^",1)
    ..;i LocID'=""  d
    ..;.s ARCSequence=$P($g(^DHCPEST(+LocID,"STLOC",$P(LocID,"||",2))),"^",2)
    ..;.s:ARCSequence="" ARCSequence="999999999"
    ..;e  d
    ..;.s ARCSequence="999999999"
    ..
    .s TempDHCPERptImg(STSequence,STRowId,ARCSequence,OrderID_"||"_OrderSub)=..GetOtherURL(OrderID_"||"_OrderSub, LocID)
    
    s ret=""
    s stq=""
    f  s stq=$o(TempDHCPERptImg(stq)) q:stq=""  d
    .s stid=""
    .f  s stid=$o(TempDHCPERptImg(stq,stid)) q:stid=""  d
    ..s itmq=""
    ..f  s itmq=$o(TempDHCPERptImg(stq,stid,itmq)) q:itmq=""  d
    ...s ordid=""
    ...f  s ordid=$o(TempDHCPERptImg(stq,stid,itmq,ordid)) q:ordid=""  d
    ....s imgData=$g(TempDHCPERptImg(stq,stid,itmq,ordid))
    ....q:imgData=""
    ....s type=$p(imgData,"^",1)
    ....s url=$p(imgData,"^",2)
    ....s:ret'="" ret=ret_","_"{""t"":"""_type_""",""v"":"""_url_"""}"
    ....s:ret="" ret="{""t"":"""_type_""",""v"":"""_url_"""}"
    s ret="["_ret_"]"
    q ret
}

ClassMethod GetOtherURL(OEORDID, LocID = "")
{
	q ""
	;w ##class(web.DHCPE.ReportShowOther).GetOtherURL("366579||23")
	s $ZT="OtherErr"
	q:OEORDID="" ""
	
	i LocID="" {
		s PAADM=$p($g(^OEORD(+OEORDID)),"^",1)
		q:PAADM="" ""
    	s LocID=$p($g(^PAADM(PAADM)),"^",4)
	}
	
	s ARCIMID=$p($g(^OEORD(+OEORDID,"I",$P(OEORDID,"||",2),1)),"^",2)
	s MethodName=..GetMethodNameByArcID(ARCIMID,LocID)
	q:MethodName="" ""
	s Path=$zobjclassmethod("web.DHCPE.ReportShowOther",MethodName,OEORDID)
	q Path
OtherErr
	q ""
}

/// 根据医嘱ID得到对应的返回方法名称
ClassMethod GetMethodNameByArcID(ARCIMID, LocID = "")
{
	;s STID=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMID, 0))
    s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMID,LocID)
    s STID=$p(StatOrderDR,"||",1)
    
	q:STID="" ""
	;心电站点
	i STID=""
	{
		q "GetEkgURL"
	}
	;放射站点
	i STID=""
	{
		q "GetRaxURL"
	}
	;病理站点
	i STID=""
	{
		q "GetPISURL"
	}
	;超声站点
	i STID=""
	{
		q "GetCSURL"
	}
	;动脉硬化站点
	i STID=""
	{
		q "GetOwnImgURL"
	}
	q ""
}

/// 心电调用
ClassMethod GetEkgURL(OEORDID)
{
	s URL=##class(web.DHCPE.EkgInterface.Main).GetEkgImgSrc(OEORDID)
	q:URL="NONE" ""
	q "IMG^"_URL
}

/// 放射调用
ClassMethod GetRaxURL(OEORDID)
{
	s RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORDID,0))
	q:RARRowId="" ""
	s RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	q:RisStudyNo="" ""
	s URL=##class(web.DHCRisCommFunctionEx).GetReportUrl(OEORDID,RisStudyNo)
	q "HTML^"_URL
}

/// 病理调用
ClassMethod GetPISURL(OEORDID)
{
	s curZN=$ZNSpace
	s PisNameSpace=$g(^DHCPESetting("DHCPE","PisNameSpace"))
	//zn "PIS"
	zn PisNameSpace

	s value=##class(PISApp.PISService).GetRptInfoByOeorditemID(OEORDID)
	zn curZN
	q:value="" ""
	//以上判断是否存在病理结果
	s cLocDr=$P(^OEORD(+OEORDID,"I",$P(OEORDID,"||",2),1),"^",3)
	s URL="http://172.26.201.3/PISWeb/Default.aspx?OID="_OEORDID_"&LOCID="_cLocDr_"&RPTID=6"
	q "HTML^"_URL
}

/// 超声调用
ClassMethod GetCSURL(OEORDID)
{
	;FTP IP地址
	s FTPIP="10.160.17.11"
	;FTP用户名    
	s FTPUser="root"
	;FTP用户密码    
	s PassWord="Root!234"
	;存放图片的路径    
	s Directory="/tem/"   
	s RARRowId=$o(^DHCPACRegInfoi("OEORI",ordItmId,0))
	q:RARRowId="" ""
	s RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	q:RisStudyNo="" ""
	s FileName=RisStudyNo_".jpg"
	s sc=..FTPFileExit(FTPIP,FTPUser,PassWord,Directory,FileName)
	q:sc=0 ""
	s FileName="ftp://"_FTPUser_":"_PassWord_"@"_FTPIP_Directory_FileName
	q "IMG^"_FileName
}

/// 自己上传得调用，如动脉硬化
ClassMethod GetOwnImgURL(OEORDID)
{
	;FTP IP地址
	s FTPIP="10.160.17.11"
	;FTP用户名    
	s FTPUser="root"
	;FTP用户密码    
	s PassWord="Root!234"
	;存放图片的路径    
	s Directory="/tem/"   
	s FileName=OEORDID_".jpg"
	s sc=..FTPFileExit(FTPIP,FTPUser,PassWord,Directory,FileName)
	q:sc=0 ""
	s FileName="ftp://"_FTPUser_":"_PassWord_"@"_FTPIP_Directory_FileName
	q "IMG^"_FileName
}

/// 判断ftp文件是否存在
ClassMethod FTPFileExit(FTPIP, FTPUser, PassWord, Directory, FileName)
{
	;d ##class(web.DHCPE.Tools).FTPTest()
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(FTPIP,FTPUser,PassWord)  q 0
	s sc=ftp.Rename(Directory_FileName,Directory_FileName)
	If 'ftp.Logout() q 0
	q sc
}

/// 删除文件
ClassMethod DeleteFTPFile(FTPIP, FTPUser, PassWord, Directory, FileName)
{
	;d ##class(web.DHCPE.Tools).DeleteFTPFile("10.0.11.51","root","vplexa34","test","6318888||3.jpg")
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(FTPIP,FTPUser,PassWord)  q 0
	s sc=ftp.Delete(Directory_FileName)
	If 'ftp.Logout() q 0
	q sc
}

ClassMethod DeleteByOEID(OEID)
{
	;FTP IP地址
	s FTPIP="10.0.11.27"
	;FTP用户名    
	s FTPUser="administrator"
	;FTP用户密码    
	s PassWord="nyfyhis20081"
	;存放图片的路径    
	s Directory="/TJXT/"   
	s FileName=OEID_".jpg"
	q ..DeleteFTPFile(FTPIP, FTPUser, PassWord, Directory, FileName)
}

/// 输出自己上传的按钮
ClassMethod OutUploadButton(OEORDID)
{
	//d ##class(web.DHCPE.ReportShowOther).OutUploadButton("366579||23")
	q:OEORDID="" ""
	w "<input type= 'file' id= 'File' style= 'display:none'>"
	w "<button id='"_OEORDID_"' onclick='UploadImgInfo(this)'>上传</button>"
}

ClassMethod ViewImgInfo(OEORDID)
{
	s OtherInfo=..GetOtherURL(OEORDID)
	q:OtherInfo=""
	s Length=$L(OtherInfo,"^")
	s Flag=$P(OtherInfo,"^",1)
	f i=2:1:Length  d
	.s OneUrl=$P(OtherInfo,"^",i)
	.i Flag="HTML" d
	..w "<iframe src='"_OneUrl_"' width='660' height='940' frameborder='0' scrolling='no'>"
	..w "</iframe>" 
	.i Flag="IMG" d
	..w "<table border=0 cellspacing=0><tr><td><P>"
	..w "<img id='"_ARCIM_i_"' src='"_OneUrl_"' width='660' height='935'>"
	..w "</P></td></tr></table>"
	.i Flag="PDF" d
	..w "<embed width='660' height='935' src='"_OneUrl_"'></embed>"
}

Storage Default
{
<Data name="ReportShowOtherDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.ReportShowOtherD</DataLocation>
<DefaultData>ReportShowOtherDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.ReportShowOtherD</IdLocation>
<IndexLocation>^web.DHCPE.ReportShowOtherI</IndexLocation>
<StreamLocation>^web.DHCPE.ReportShowOtherS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
