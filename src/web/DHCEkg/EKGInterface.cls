Class web.DHCEkg.EKGInterface Extends %Library.RegisteredObject
{

/// Creator：		yyl
/// CreatDate：		2018-3-21
/// modify:			yyl
/// modifyDate:		2018-12-27
/// modifyDesc:		静息取所有数据记录，其他的取最新的一条数据
/// Description:	获取心电图报告图片路径
/// w ##class(web.DHCEkg.EKGInterface).GetEKGRptImg("821||WL0007")
ClassMethod GetEKGRptImg(OrdId As %String) As %String
{
	new $NAMESPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	s imgUrl=""
	s imgUrl=##class(EKGService.Method.GetRptImg).GetEKGRptImg(OrdId)
	q imgUrl
	
	
	d GetImgUrl
	;i (imgUrl="") d
	;.s obj=##class(EkgImgReport1.EkgImgReport1Soap).%New()
	;.s imgUrl=obj.getEkgImgReport(OrdId)
	q imgUrl
GetImgUrl
	new $NAMESPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	s configId=$o(^dbo.tblConfigureI("idxKey"," FTPHTTPURL",""))
	
	q:(configId="") 
	s configInfo=^dbo.tblConfigureD(configId)
	q:(configInfo="")
	s httpUrl=$listget(configInfo,6,"")
	
	q:(httpUrl="")
	s reqID=$o(^dbo.tblRequestI("indexBarcode"," "_OrdId,""))
	q:(reqID="") 
	
	s (examId,tmpExamId)=""
	f  s tmpExamId=$o(^dbo.tblExaminationI("idxRequestID",reqID,tmpExamId)) q:(tmpExamId="")!(examId'="")  d
	.s tmpExamInfo=$g(^dbo.tblExaminationD(tmpExamId))
	.q:(tmpExamInfo="")
	.s tmpStatusCode=$listget(tmpExamInfo,20)
	.i (tmpStatusCode="15")!(tmpStatusCode="17") s examId=tmpExamId
	q:(examId="")
	
	;获取检查类型
	s (devId,devInfo,testTypeId)=""
	s examInfo=$g(^dbo.tblExaminationD(examId))
	q:(examInfo="")
	s devId=$listget(examInfo,10,"")
	q:(devId="")
	s devInfo=$g(^dbo.tblDeviceD(devId))
	q:(devInfo="")
	s testTypeId=$listget(devInfo,3,"")
	b ; w
	i (testTypeId="1") d ;静息类设备，取所有数据记录
	.s filepathId=""
	.f  s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId)) q:(filepathId="")  d
	..;b ;w filepathId
	..s imgId=""
	..f  s imgId=$o(^dbo.tblImgReportI("idxFilePathID",filepathId,imgId)) q:(imgId="")  d
	...;b ; w imgId
	...s imgInfo=^dbo.tblImgReportD(imgId)
	...q:(imgInfo="")
	...s imgPath=$listget(imgInfo,6,"")
	...q:(imgPath="")
	...s tmpmgUrl=httpUrl_imgPath
	...;b ; w tmpmgUrl
	...i (imgUrl'="") s imgUrl=imgUrl_"#"_tmpmgUrl
	...e  s imgUrl=tmpmgUrl
	e  d ;非静息类，只取最新的一条数据
	.s filepathId=""
	.s avlFilepathId="" ;有效数据
	.f  s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId)) q:(filepathId="")  d
	..b ;w filepathId
	..s avlFilepathId=filepathId
	.q:(avlFilepathId="")
	.s imgId=""
	.f  s imgId=$o(^dbo.tblImgReportI("idxFilePathID",avlFilepathId,imgId)) q:(imgId="")  d
	..b ; w imgId
	..s imgInfo=^dbo.tblImgReportD(imgId)
	..q:(imgInfo="")
	..s imgPath=$listget(imgInfo,6,"")
	..q:(imgPath="")
	..s tmpmgUrl=httpUrl_imgPath
	..b ; w tmpmgUrl
	..i (imgUrl'="") s imgUrl=imgUrl_"#"_tmpmgUrl
	..e  s imgUrl=tmpmgUrl
	q
}

}
