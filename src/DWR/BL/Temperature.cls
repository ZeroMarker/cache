Class DWR.BL.Temperature Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(DWR.BL.Temperature).GetTempatureImagPath()
ClassMethod GetTempatureImagPath(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>2200774</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s netWorkType=request.netWorkType
	   s netWorkType=$TR(netWorkType,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	i netWorkType'="Internet" s netWorkType="Intranet"
	i netWorkType'="Internet" s netWorkType="SERVERINTRA"
	e  s netWorkType="SERVERINTER"
	s ftpPath=$G(^DHCDWRSET("NUR",netWorkType))
	i ftpPath="" s ftpPath=$G(^DHCDWRSET("NUR","FTP"))
	q:ftpPath="" "202^体温单未设置浏览路径!"
	/*
	f i=1:1:12 d
	.///测试
    .s filePath=ftpPath_"/ipad/"_i_".JPG"
    .s weekNo=i
	.s myObj=##class(DWR.MSG.TempImageFile).%New()
	.s myObj.weekNo=weekNo
	.s myObj.filePath=filePath
	.d myObj.%Close()
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml,"TempImageFile")
	.i ret=1 s retStr=retStr_Xml
	*/
    s imageId=""  
    ///f  s imageId=$O(^Nur.DHCNurPaTemCE0AI("Adm"," "_admId,imageId)) q:imageId=""  d
    f  s imageId=$O(^Nur.DHCNurPaTempA50I("Adm"," "_admId,imageId)) q:imageId=""  d
    .s imageObj=##class(Nur.DHCNurPaTemperatureFilePath).%OpenId(imageId)
    .s filePath=ftpPath_imageObj.filePath
    .s weekNo=imageObj.weekno
    .d imageObj.%Close()
	.s myObj=##class(DWR.MSG.TempImageFile).%New()
	.s myObj.weekNo=weekNo
	.s myObj.filePath=filePath
	.d myObj.%Close()
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml,"TempImageFile")
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

}
