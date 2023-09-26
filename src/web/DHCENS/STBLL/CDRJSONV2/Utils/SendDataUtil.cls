Class web.DHCENS.STBLL.CDRJSONV2.Utils.SendDataUtil Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod sendDataMethod(Sid, Eid, ClassName, MethodName, MessageCode) As %String
{
	for i=Sid:1:Eid{
		set stream=##class(%GlobalCharacterStream).%New()
		set exstr="stream=##class("_ClassName_").("_MethodName_")"
		set @exstr	
		set tRequest=##class(%Net.HttpRequest).%New()
		set tRequest.Server="127.0.0.1"
		set tRequest.Port="9098"
		d tRequest.InsertFormData("content",stream)
		set tSc = tRequest.Post("/hdc/SaveService/"_MessageCode)
		set sc=tRequest.HttpResponse.Data
		
	}	
	
	quit 1
}

}
