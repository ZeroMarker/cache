Class User.DHCBedChangeApp Extends %Persistent
{

/// 患者
Property AppAdmDr As %String(TRUNCATE = 1);

/// 记录人
Property RecUser As %String(TRUNCATE = 1);

/// 记录日期
Property AppDate As %Library.Date(FORMAT = 1);

/// 记录时间
Property AppTime As %Library.Time;

/// 审核人
Property AuditUser As %String(TRUNCATE = 1);

/// 审核日期
Property AuditDate As %Library.Date(FORMAT = 1);

/// 审核时间
Property AuditTime As %Library.Time;

/// 申请状态0:申请 1：已审核
Property AppStatus As %String(TRUNCATE = 1);

/// 是否转科/换床: 1：护士已转
Property ChangeStatus As %String(TRUNCATE = 1);

/// 患者病区 CT_Loc
Property RecLoc As %String(TRUNCATE = 1);

Index ResultDateTime On (AppDate, AppTime);

Index ResultAdmDT On AppAdmDr;

ClassMethod Save(id As %String = "", adm As %String = "", AppStatus As %String = "") As %String
{
	q:adm="" "失败"
	s AppAdmDr=adm
	s RecUser=%session.Data("LOGON.USERID")
	s AppDate=+$h
	s AppTime=$p($h,",",2)
	s id=$o(^User.DHCBedChangeAppI("ResultAdmDT"," "_adm,""),-1)
	i id="" 
	{
	s a=##class(User.DHCBedChangeApp).%New(id)
	}
	else 
	{
	s a=##class(User.DHCBedChangeApp).%OpenId(id)
	i $ISObject(a)
	{
		s ChangeStatus=a.ChangeStatus
		i ChangeStatus="1"
		{
		d a.%Save()
        d a.%Close()
        s a=##class(User.DHCBedChangeApp).%New(id)
		}
		}	
		}
	s a.AppAdmDr=AppAdmDr
	s a.RecUser=RecUser
	s a.AppDate=AppDate
	s a.AppTime=AppTime
	s a.AppStatus=AppStatus
	d a.%Save()
	d a.%Close()
	q 0
}

ClassMethod Audit(id As %String = "") As %String
{
 q:id="" "请选中一条记录！"
 s ret="0" 
 s obj=##class(User.DHCBedChangeApp).%OpenId(id)	
 if $ISObject(obj) {
 s ret=obj.AppStatus
 if ret="1" 
 {
	d obj.%Save()
    d obj.%Close() 
    s ret="已经审核"
	 }
 s obj.AuditUser=%session.Data("LOGON.USERID")
 s obj.AuditDate=+$h
 s obj.AuditTime=$p($h,",",2)
 s obj.AppStatus="1"
 }
 d obj.%Save()
 d obj.%Close()
 q ret
}

Storage Default
{
<Data name="DHCBedChangeAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecUser</Value>
</Value>
<Value name="3">
<Value>AppStatus</Value>
</Value>
<Value name="4">
<Value>AppAdmDr</Value>
</Value>
<Value name="5">
<Value>AppDate</Value>
</Value>
<Value name="6">
<Value>AppTime</Value>
</Value>
<Value name="7">
<Value>AuditUser</Value>
</Value>
<Value name="8">
<Value>AuditDate</Value>
</Value>
<Value name="9">
<Value>AuditTime</Value>
</Value>
<Value name="10">
<Value>RecLoc</Value>
</Value>
<Value name="11">
<Value>ChangeStatus</Value>
</Value>
</Data>
<DataLocation>^User.DHCBedChangeAppD</DataLocation>
<DefaultData>DHCBedChangeAppDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCBedChangeAppD</IdLocation>
<IndexLocation>^User.DHCBedChangeAppI</IndexLocation>
<StreamLocation>^User.DHCBedChangeAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
