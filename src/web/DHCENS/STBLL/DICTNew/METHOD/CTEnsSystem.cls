Class web.DHCENS.STBLL.DICTNew.METHOD.CTEnsSystem Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：CT_EnsSystemType
/// Table：CT_EnsSystemType
/// Input： 
/// Return：诊断信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEnsSystem).CTEnsSystem("")
ClassMethod CTEnsSystem(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()
	set soap=##class(web.DHCENS.STBLL.DICTNew.Soap.HdcWebServiceImplPort).%New()
	set SuccessFlag=0
	set id="0" f  set id=$o(^Config.ENS.EnsSystemD(id)) q:id=""  d
	.Quit:((id'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTEnsSystem).%New()
	.set insObj.businessrowid=id
	.set insObj.CTESYSCode=$lg(^Config.ENS.EnsSystemD(id),2)
	.set insObj.CTESYSDesc=$lg(^Config.ENS.EnsSystemD(id),3)
	.set insObj.CTESYStypeCode=$lg(^Config.ENS.EnsSystemD(id),5)
	.set insObj.CTESYSEffectiveFlag=$lg(^Config.ENS.EnsSystemD(id),4)
	.set insObj.CTESYSCodesystemCode="CT_EnsSystem"	
	.d body.CTEnsSystems.Insert(insObj)
	.set request.body=body
	.d request.XMLExportToStream(.stream)
	.set ret=soap.saveDictData("CT_EnsSystem",stream)
	.d body.CTEnsSystems.Clear()
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
