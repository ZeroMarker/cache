Class web.DHCENS.STBLL.DICT.METHOD.CTRegisterCareProvImage Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—09-11
/// Description：医护人员图片信息
/// Table：
/// Input： 
/// Return：医护人员图片信息
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTRegisterCareProvImage).CTImage("")
ClassMethod CTImage(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DICT.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=""
	set request.header=header
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	s i=0
	set RowId=0 f  set RowId=$O(^MHC.Store.DoctorInfoD(RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTRegisterCareProvImage).%New()
	.set stream=##class(%GlobalCharacterStream).%New()
	.set ImageObj=##class(MHC.Store.DoctorInfo).%OpenId(RowId)
	.set Obj.CTCPCode=ImageObj.userCode
	.set:Obj.CTCPCode'="" Obj.CTCPRowId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Obj.CTCPCode),""))
	.d Obj.ImageContent.CopyFrom(ImageObj.doctorImage)
	.d body.RegisterCareProvImages.Insert(Obj)
	.set request.body=body
	.d request.XMLExportToStream(.stream)
	.set soapObj=##class(web.DHCENS.STBLL.DRUG.SOAP.PUB0013Soap).%New()
	.set tSC=soapObj.sendDocImageInfo("T0054",stream)
	.d body.RegisterCareProvImages.Clear()
	.d stream.Rewind()
	
	Quit tSC.Read()
	
Exception
	b
	Quit "-1^"_$ze
}

}
