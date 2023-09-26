Class CIS.AN.DTO.ENS.Message.Body Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLTYPE = "Body";

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ﻿MsgSendRt As CIS.AN.DTO.ENS.Message.Content;

ClassMethod CloneFromObject(object As %RegisteredObject, modelName As %String = "") As CIS.AN.DTO.ENS.Message.Body
{
	set result=##class(CIS.AN.DTO.ENS.Message.Body).%New()
	quit result
}

Method Compose(model As CIS.AN.DTO.ENS.Message.Content) As %Status
{
	set ##this."﻿MsgSendRt" = model
	quit $$$OK
}

}
