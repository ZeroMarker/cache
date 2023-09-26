/// Desc:处理病历代码类 
/// Creator:Candy
/// CreateDate:2017-6-19
Class EMRservice.BL.BLInstanceCode Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 取病历Code
/// Creator:Candy
/// CreateDate:2017-6-19
/// Input:  AInstanceID 病历ID 
ClassMethod GetInstanceCode(AInstanceID As %String) As %String
{
	s result = ""
	q:(AInstanceID = "") result
	s code = ""
	for
	{
		s code = $o(^DHCEMRI.InstanceCodeI("IdxMain"," "_AInstanceID,code))
		q:(code = "")
		s rowId = $o(^DHCEMRI.InstanceCodeI("IdxMain"," "_AInstanceID,code,""))
		s obj = ##Class(EMRinstance.InstanceCode).%OpenId(rowId)
		continue:(obj = "")
		s:(result '= "") result = result_"^"
		s result = result_obj.TitleCode
	}
	q result
}

/// Desc: 存储病历Code
/// Creator:Candy
/// CreateDate:2017-6-19
/// Input:  AInstanceID 病历ID ,ATitleCodes 病历代码以"^"分隔
/// Debug:  w ##Class(EMRservice.BL.BLInstanceCode).SetInstanceCode("2||28",2)
ClassMethod SetInstanceCode(AInstanceID As %String, ATitleCodes As %String) As %String
{
	s result = 1
	q:(AInstanceID = "") result
	for i=1:1:$l(ATitleCodes,"^")
	{
	   s tmpCode = $p(ATitleCodes,"^",i)
	   continue:(tmpCode = "")
	   s rowId = $o(^DHCEMRI.InstanceCodeI("IdxMain"," "_AInstanceID," "_$zcvt(tmpCode,"U"),""))
	   if (rowId '= "")
	   {
	   	   s objInstanceCode = ##Class(EMRinstance.InstanceCode).%OpenId(rowId)
	   }
	   else
	   {
		   s objInstanceCode = ##Class(EMRinstance.InstanceCode).%New() 
	   }
	   s objInstanceCode.InstanceID = AInstanceID
	   s objInstanceCode.TitleCode = tmpCode
	   s scInstanceCode = objInstanceCode.%Save() 
	   d objInstanceCode.%Close()
	   if ($$$ISERR(scInstanceCode))
	   {
		   s result = 0
		   q 
	   }
	}
	q result
}

}
