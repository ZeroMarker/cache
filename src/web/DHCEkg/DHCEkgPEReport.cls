/// web.DHCEkg.DHCEkgPEReport
Class web.DHCEkg.DHCEkgPEReport Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "DHCEkgPEReport";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：		yyl
/// CreatDate：		2019-9-18
/// modify:			yyl
/// modifyDate:		2019-9-18
/// modifyDesc:		
/// Description:	定时触发此方法向体检发送报告图片
/// w ##class(web.DHCEkg.DHCEkgPEReport).SentPEImgReport()
ClassMethod SentPEImgReport() As %String [ WebMethod ]
{
	s ^tmpDHCEKG("SentPEImgReport")=$zdt($h,3)
	new $namespace
	s CurrentSpace=$ZNSPACE
	s (sDate,sTime,eDate,eTime)=""
	s sTime=$g(^DHCEKG("SentPEImgReport","LastInvoke"))
	i (sTime="") d
	.s sTime=0
	.s sDate=$p($h,",",1)
	e  d
	.s sDate=$p(sTime,",",1)
	.s sTime=$p(sTime,",",2)
	.i (sTime>120) s sTime=sTime-120
	.e  s sTime=0
	
	;s eDate=$p($h,",",1)
	s eDate=$zdh("2020-7-28",3)
	s eTime=$p($zdth("2020-07-28 12:50",3),",",2)
	
	;b ;w sDate_","_sTime_","_eDate_","_eTime
	
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	
	s examId="" 
	f  s examId=$o(^dbo.tblExaminationD(examId)) q:examId=""  d
	.s examInfo=$g(^dbo.tblExaminationD(examId))
	.q:examInfo=""
	.s arbiter=$listget(examInfo,6,"")
	.q:arbiter=""
	.;w arbiter,!
	.s aH=$zdth(arbiter,3)
	.s arbiterDate=$p(aH,",",1)
	.s arbiterTime=$p(aH,",",2)
	.;w arbiterDate_"^"_arbiterTime,!
	.q:((arbiterDate>eDate)!(arbiterDate<sDate))
	.q:((arbiterDate=eDate)&&(arbiterTime>eTime))
	.q:((arbiterDate=sDate)&&(arbiterTime<sTime))
	.;b ; w arbiter
	.s statuscode=$listget(examInfo,20,"")
	.q:((statuscode'="15")&&(statuscode'="17"))
	.s reqId=$listget(examInfo,19,"")
	.q:(reqId="")
	.s reqInfo=$g(^dbo.tblRequestD(reqId))
	.q:(reqInfo="")
	.s patSourceCode=$listget(reqInfo,15,"")
	.q:(patSourceCode'="1") ;非体检
	.s ordId=$listget(reqInfo,6,"")
	.q:(ordId="")
	.;b ; w ordId_","_arbiter
	.s sentRtn=""
	.d SentToPE
 	.w ordId_"==>"_sentRtn,!
	.i (sentRtn="ok") s ^DHCEKG("SentPEImgReport",ordId,"arbiterTime")=arbiter
	.h 0.1
	zn CurrentSpace
	s ^DHCEKG("SentPEImgReport","LastInvoke")=eDate_","_eTime
	q "ok"
	
SentToPE
	new $namespace
	zn "dhc-app"	
	s sentRtn=##class(web.DHCEkgService).SentPERptImg(ordId)
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
}

/// w ##class(web.DHCEkgService).SentPERptImg("15960492||12")
ClassMethod SentPERptImg(OrdId As %String) As %String
{
	s rtnSent=""
	new $namespace
	s CurrentSpace=$ZNSPACE
	zn "dhc-app"
	
	s rtnSent=##class(web.DHCEkgService).SentPERptImg(OrdId)
	zn CurrentSpace
	q rtnSent
}

/// Creator：		yyl
/// CreatDate：		2019-9-17
/// modify:			yyl
/// modifyDate:		2019-9-17
/// modifyDesc:		发布报告时向体检发送报告图片
/// Description:	发布报告时向体检发送报告图片
/// w ##class(web.DHCEkg.DHCEkgPEReport).SavePERptImg("17582652||16")
ClassMethod SavePERptImg(OrdId As %String) As %String [ WebMethod ]
{
	s ^DHCEKG("SavePERptImg","LastInvoke")=$zdt($h,3)
	s rtn=""
	s ekgRptImg=""
	s (httpIp,httpPort)=""
	d GetRptImgFromEKG
	i (ekgRptImg="") d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.DHCEkgPEReport","SavePERptImg",$zd($h,3),$zt($p($h,",",2),1),"图片路径为空",OrdId)

	q:(ekgRptImg="") "-1"
	;b ; w ekgRptImg
	;b ; w httpIp_":"_httpPort
	q:(httpIp="")!(httpPort="")
	
	TStart
	s error=0
	f i=1:1:$l(ekgRptImg,"^") d
	.s imgUrl=$p(ekgRptImg,"^",i)
	.q:(imgUrl="")
	.s imgStream=..ImgBase64Encode(httpIp,httpPort,imgUrl)
	.q:(imgStream.SizeGet()<1)
	.s DHCPEEkgImgInfoID=""
	.s DHCPEEkgImgInfoID=$o(^User.DHCPEEkgImgInfoI("EIIOrdItemDRIndex",OrdId,DHCPEEkgImgInfoID))
	.;旧记录处理
	.i (DHCPEEkgImgInfoID'="") d
	..&sql(DELETE FROM SQLUser.DHC_PE_EkgImgInfo WHERE EII_OrdItem_DR=:OrdId)
	..i SQLCODE s error=SQLCODE
	.b ; w 
	.&sql(INSERT INTO SQLUser.DHC_PE_EkgImgInfo (EIIImgInfo, EII_OrdItem_DR)
		VALUES (:imgStream, :OrdId))
	.i SQLCODE s error=SQLCODE
	.e  s rtn="ok"
	b ; after save
	i error TRollback  q error
 	TCOMMIT
 	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.DHCEkgPEReport","SavePERptImg",$zd($h,3),$zt($p($h,",",2),1),ekgRptImg,OrdId,"save")

 	i (rtn'="ok") s rtn=error
 	q rtn
 	
	
GetRptImgFromEKG
	new $NAMESPACE
	s $NAMESPACE="DHC-EKG"
	;s ^tmpDHCEKG("SentPERptImg",OrdId,$zdt($h,3),"0ekgin")=""
	s RptImgPath=""
	//查询检查报告图片路径
	s requestId=$o(^dbo.tblRequestI("idxExamCode"," "_OrdId,""))
	;s ^tmpDHCEKG("SentPERptImg",OrdId,$zdt($h,3),"2requestId")=requestId
	;;q:requestId="" ""
	i (requestId'="")
	{
		s examId=$o(^dbo.tblExaminationI("idxRequestID",requestId,""))
		;s ^tmpDHCEKG("SentPERptImg",OrdId,$zdt($h,3),"3examId")=examId
		i (examId'="") 
		{
			;b ;examId
			s fileId=""
			f  s fileId=$o(^dbo.tblFilePathI("idxExaminationID",examId,fileId)) q:(fileId="")  d
			.;b ;fileId
			.;s ^tmpDHCEKG("SentPERptImg",OrdId,$zdt($h,3),"4fileId")=fileId
			.s imgpathId=""
			.f  s imgpathId=$o(^dbo.tblImgReportI("idxFilePathId",fileId,imgpathId)) q:(imgpathId="")  d
			..;s ^tmpDHCEKG("SentPERptImg",OrdId,$zdt($h,3),"5imgpathId")=imgpathId
			..s imgInfo=^dbo.tblImgReportD(imgpathId)
			..;b ; imgInfo
			..i (imgInfo'="") d
			...s tmpImgPath=$li(imgInfo,6)
			...;s ^tmpDHCEKG("SentPERptImg",OrdId,$zdt($h,3),"6ImgPath")=tmpImgPath
			...;b ; tmpImgPath
			...i (RptImgPath'="") s RptImgPath=RptImgPath_"^"_tmpImgPath
			...e  s RptImgPath=tmpImgPath
		}
	}
	s ekgRptImg=RptImgPath
	
	s configId=$o(^dbo.tblConfigureI("idxKey"," FTPWEBURL",""))
	i (configId'="") d
	.;b ;configInfo
	.s configInfo=^dbo.tblConfigureD(configId)
	.i (configInfo'="") d
	..;b ;httpPath0
	..s httpPath=$li(configInfo,6)
	..q:(httpPath="")
	..b ; w httpPath
	..s httpPath=$e(httpPath,$l($p(httpPath,"//",1))+3,$l(httpPath))
	..s httpPath=$p(httpPath,"/",1)
	..s httpIp=$p(httpPath,":",1)
	..s httpPort=$p(httpPath,":",2)
	..i httpPort="" s httpPort="80"
	quit
}

/// Creator：		yyl
/// CreatDate：		2019-9-17
/// modify:			yyl
/// modifyDate:		2019-9-17
/// modifyDesc:		
/// Description:	图片转码
/// w ##class(web.DHCEkgService).ImgBase64Encode("http://172.16.16.93:8888/2019/38/749055_201909171216317546.ECG1250P.jpg")
ClassMethod ImgBase64Encode(httpip As %String, httpport As %String, imgPath As %String) As %GlobalCharacterStream
{
	s imgStream=##class(%GlobalCharacterStream).%New()
	try
	{
		/// get http jpg
		s httprequest=##class(%Net.HttpRequest).%New()
		s httprequest.Server=httpip
		s httprequest.Port=httpport
		s tSc = httprequest.Get("/"_imgPath)
		s httpResponse=##class(%Net.HttpResponse).%New()
		s httpResponse=httprequest.HttpResponse
		s data=##class(%GlobalBinaryStream).%New()
		s data=httpResponse.Data
		;b ; d httpResponse.OutputToDevice()
		 
		/// read data
		s file=##class(%FileBinaryStream).%New()
		f  s tmpByte= data.Read() q:(tmpByte="")  d
		.d file.Write(tmpByte)
		;b ; w file.SizeGet()
		
		/// encode
		s BinaryText=$ZCONVERT(file.Read(file.Size,.sc),"O","UTF8")
		s tc=file.%Close()
		;b ; w size
		s byteList = ##class(%SYSTEM.Encryption).Base64Encode(BinaryText)
		;b ; w byteList
		d imgStream.Write(byteList)
	}
	catch{}
	;b ; d imgStream.OutputToDevice()
	q imgStream
}

}
