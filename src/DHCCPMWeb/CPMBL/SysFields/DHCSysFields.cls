/// 获取系统字段的类
Class DHCCPMWeb.CPMBL.SysFields.DHCSysFields Extends (DHCCPMWeb.CPMSevice.entity.DHCERepFields, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter SCPMCTLocID = "SCPM.CTLocID";

Parameter SCPMCTLocName = "SCPM.CTLocName";

Parameter SCPMDate = "SCPM.Date";

Parameter SCPMGroupID = "SCPM.GroupID";

Parameter SCPMGroupName = "SCPM.GroupName";

Parameter SCPMTime = "SCPM.Time";

Parameter SCPMHospCode = "SCPM.HospCode";

Parameter SCPMUserCode = "SCPM.UserCode";

Parameter SCPMUserID = "SCPM.UserID";

Parameter SCPMUserName = "SCPM.UserName";

/// 获得系统的数据列表
ClassMethod GetSysFields() As %List
{
	;w ##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetSysFields()
	n (ad)
	
	s myList=##class(%ListOfDataTypes).%New()
	
	;DHCCPMWeb.CPMSevice.entity.DHCERepPanels
	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetCTLocID()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetCTLocName()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetDate()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetGroupID()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetGroupName()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetHospCode()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetTime()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetUserCode()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetUserID()
	d myList.Insert(obj)
	d obj.%Close()

	s obj=##class(DHCCPMWeb.CPMBL.SysFields.DHCSysFields).GetUserName()
	d myList.Insert(obj)
	d obj.%Close()
	
	q myList
}

ClassMethod GetCTLocID() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="登陆科室的ID"
	s RFDataType="string"
	s RFDefaultValue=""
	s RFDescription=""
	s RFName="SCPM.CTLocID"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetCTLocName() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="登陆科室名称"
	s RFDataType="string"
	s RFDefaultValue=""
	s RFDescription=""
	s RFName="SCPM.CTLocName"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetDate() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="系统日期"
	s RFDataType="Date"
	s RFDefaultValue=+$h
	s RFDescription=""
	s RFName="SCPM.Date"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetGroupID() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="登陆安全组ID"
	s RFDataType="string"
	s RFDefaultValue=""
	s RFDescription=""
	s RFName="SCPM.GroupID"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetGroupName() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="登陆安全组名称"
	s RFDataType="string"
	s RFDefaultValue=""
	s RFDescription=""
	s RFName="SCPM.GroupName"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetHospCode() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="医院代码"
	s RFDataType="string"
	s RFDefaultValue=""
	s RFDescription="医院的代码"
	s RFName="SCPM.HospCode"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetTime() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="系统时间"
	s RFDataType="Time"
	s RFDefaultValue=$p($h,",",2)
	s RFDescription=""
	s RFName="SCPM.Time"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetUserCode() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="登陆用户代码"
	s RFDataType="string"
	s RFDefaultValue=""
	s RFDescription=""
	s RFName="SCPM.UserCode"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetUserID() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="登陆用户ID"
	s RFDataType="string"
	s RFDefaultValue=""
	s RFDescription=""
	s RFName="SCPM.UserID"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

ClassMethod GetUserName() As DHCCPMWeb.CPMSevice.entity.DHCERepFields
{
	n (ad)
	s obj=##class(DHCCPMWeb.CPMSevice.entity.DHCERepFields).%New()
	s RFCaption="登陆用户名称"
	s RFDataType="string"
	s RFDefaultValue=""
	s RFDescription=""
	s RFName="SCPM.UserName"
	
	d obj.SetField(RFCaption,RFDataType,RFDefaultValue, RFDescription, RFName)
	q obj
}

}
