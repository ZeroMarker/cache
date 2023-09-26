/// Hospital:标准库
/// Class Description:安全组匹配HIS
/// Date:2015-01-26
Class DHCMGNUR.MgNurSecGrpForHIS Extends %Persistent
{

/// HIS安全组id
Property HisSecGrpCode As %String [ SqlColumnNumber = 2, SqlFieldName = His_SecGrpCode ];

/// HIS安全组描述
Property HisSecGrpDesc As %String [ SqlColumnNumber = 3, SqlFieldName = His_SecGrpDesc ];

/// 护理管理安全组code
Property MgSecGrpCode As %String [ SqlColumnNumber = 4, SqlFieldName = MgSecGrpCode ];

/// 护理管理安全组描述
Property MgSecGrpDesc As %String [ SqlColumnNumber = 5, SqlFieldName = MgSecGrpDesc ];

Index Typ On HisSecGrpCode;

Index Type On (HisSecGrpCode, MgSecGrpCode);

ClassMethod Save(parr As %String) As %String
{
	;s ^TEMP("g201501261802001")=parr
	//HisSecGrpCode|8^HisSecGrpDesc|住院收费^MgSecGrpCode|nurhead^MgSecGrpDesc|护士长^rw|
	s id=$P($P(parr,"^",5),"|",2)
	i id'="" s a=##class(DHCMGNUR.MgNurSecGrpForHIS).%OpenId(id)
	e  s a=##class(DHCMGNUR.MgNurSecGrpForHIS).%New()
	s a.HisSecGrpCode=$P($P(parr,"^",1),"|",2)
	s a.HisSecGrpDesc=$P($P(parr,"^",2),"|",2)
	s a.MgSecGrpCode=$P($P(parr,"^",3),"|",2)
	s a.MgSecGrpDesc=$P($P(parr,"^",4),"|",2)
	d a.%Save()
	q a.%Id()
}

ClassMethod DelItem(id) As %String
{
	;s ^TMEP("g201501261905001")=id
	s ret=""
	i id'=""
	{
		TStart
		s object=##class(DHCMGNUR.MgNurSecGrpForHIS).%OpenId(id)
		s sc = object.%DeleteId(id)
		i $$$ISERR(sc)  
		{
			TRollBack
			Do $System.Status.DisplayError(sc)
   			s ret="删除失败"
		}
		else
		{
			TCommit
			s ret="删除成功"
		}
	}
	q ret
}

ClassMethod IsExist(hisgrp, mggrp) As %String
{
	;s ^TMP("g201501261930001")=hisgrp_"%"_mggrp
	s ret=0
	;s id=$O(^DHCMGNUR.MgNurSecGrpForHISI("Type"," "_hisgrp," "_$ZConvert(mggrp,"U"),""))
	s id=$O(^DHCMGNUR.MgNurSecGrpForHISI("Typ"," "_hisgrp,""))
	i id'="" s ret=1
	e  s ret=0
	q ret
}

Storage Default
{
<Data name="MgNurSecGrpForHISDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HisSecGrpCode</Value>
</Value>
<Value name="3">
<Value>HisSecGrpDesc</Value>
</Value>
<Value name="4">
<Value>MgSecGrpCode</Value>
</Value>
<Value name="5">
<Value>MgSecGrpDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurSecGrpForHISD</DataLocation>
<DefaultData>MgNurSecGrpForHISDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurSecGrpForHISD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurSecGrpForHISI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurSecGrpForHISS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
