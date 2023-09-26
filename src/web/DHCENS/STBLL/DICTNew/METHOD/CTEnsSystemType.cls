Class web.DHCENS.STBLL.DICTNew.METHOD.CTEnsSystemType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：CT_EnsSystemType
/// Table：CT_EnsSystemType
/// Input： 
/// Return：诊断信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEnsSystemType).CTEnsSystemType("")
ClassMethod CTEnsSystemType(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()
	set soap=##class(web.DHCENS.STBLL.DICTNew.Soap.HdcWebServiceImplPort).%New()
	set SuccessFlag=0
	set id="0" f  set id=$o(^Code.ENS.EnsSystemTypeD(id)) q:id=""  d
	.Quit:((id'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTEnsSystemType).%New()
	.set insObj.businessrowid=id
	.set insObj.CTESTCode=$lg(^Code.ENS.EnsSystemTypeD(id),2)
	.set insObj.CTESTDesc=$lg(^Code.ENS.EnsSystemTypeD(id),3)
	.set insObj.CTESTCodesystemCode="CT_EnsSystemType"	
	.d body.CTEnsSystemTypes.Insert(insObj)
	.set request.body=body
	.d request.XMLExportToStream(.stream)
	.set ret=soap.saveDictData("CT_EnsSystemType",stream)
	.d body.CTEnsSystemTypes.Clear()
	if SuccessFlag'=0 {
		s RetStr="-1^失败"
	}
	else{
		s RetStr="0^成功"
	}
	Quit RetStr
Exception
	Quit "-1^"_$ze
}

}
