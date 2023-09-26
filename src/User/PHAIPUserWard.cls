Class User.PHAIPUserWard Extends (%Persistent, User.Abstract) [ SqlTableName = PHAIP_UserWard ]
{

Index LocUserWard On (IPUWLocDR, IPUWUserDR, IPUWWardLocDR);

/// 药房ID
Property IPUWLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = IPUW_Loc_DR ];

/// 用户ID
Property IPUWUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = IPUW_User_DR ];

/// 病区的CTLOC ID
Property IPUWWardLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = IPUW_WardLoc_DR ];

Storage Default
{
<Data name="PHAIPUserWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IPUWLocDR</Value>
</Value>
<Value name="3">
<Value>IPUWUserDR</Value>
</Value>
<Value name="4">
<Value>IPUWWardLocDR</Value>
</Value>
</Data>
<DataLocation>^CF.PHA.IP.UserWard</DataLocation>
<DefaultData>PHAIPUserWardDefaultData</DefaultData>
<IdLocation>^CF.PHA.IP.UserWard</IdLocation>
<IndexLocation>^CF.PHA.IP.UserWardi</IndexLocation>
<StreamLocation>^CF.PHA.IP.UserWards</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
