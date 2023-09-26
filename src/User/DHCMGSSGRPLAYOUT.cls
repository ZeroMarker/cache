Class User.DHCMGSSGRPLAYOUT Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_SSGRPLAYOUT ]
{

Relationship ChildSub As User.DHCMGSSGRPLAYOUTSUB [ Cardinality = children, Inverse = layparref ];

Property layGrp As User.DHCMGSSGROUP;

Property laytitle As %String(TRUNCATE = 1);

Property layPos As %String(TRUNCATE = 1);

Property layflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

Index grp On layGrp;

ClassMethod save(parr As %String) As %String
{
    s id=$P(parr,"^",1)
    s grp=$P(parr,"^",2)
    s title=$P(parr,"^",3)
    s pos=$P(parr,"^",4)
    s flag=$P(parr,"^",5)
    if id'=""  s a=##class(User.DHCMGSSGRPLAYOUT).%OpenId(id)
    e  s a=##class(User.DHCMGSSGRPLAYOUT).%New()
    s a.layGrp=##class(User.DHCMGSSGROUP).%OpenId(grp)
    s a.laytitle=title
    s a.layPos=pos
    if flag'="" s a.layflag=flag
    d a.%Save()
    q 0
}

Storage Default
{
<Data name="DHCMGSSGRPLAYOUTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>layGrp</Value>
</Value>
<Value name="3">
<Value>laytitle</Value>
</Value>
<Value name="4">
<Value>layPos</Value>
</Value>
<Value name="5">
<Value>layflag</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGSSGRPLAYOUTD</DataLocation>
<DefaultData>DHCMGSSGRPLAYOUTDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGSSGRPLAYOUTD</IdLocation>
<IndexLocation>^User.DHCMGSSGRPLAYOUTI</IndexLocation>
<StreamLocation>^User.DHCMGSSGRPLAYOUTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
