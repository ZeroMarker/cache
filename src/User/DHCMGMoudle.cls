Class User.DHCMGMoudle Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_Moudle ]
{

Property mlname As %String(MAXLEN = 400, TRUNCATE = 1);

Property mlcode As %String(MAXLEN = 300, TRUNCATE = 1);

Relationship ChildSub As User.DHCMGMoudleSub [ Cardinality = children, Inverse = MouldParRef ];

Index code On mlname;

ClassMethod save(parr) As %String
{
   s ^TM=parr
   s id=$P(parr,"^",1)
   s name=$P(parr,"^",2)
   s code=$P(parr,"^",3)
   
   if id="" s a=##class(User.DHCMGMoudle).%New()
   e  s a=##class(User.DHCMGMoudle).%OpenId(id)
   s a.mlname=name
   s a.mlcode=code
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGMoudleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>mlcode</Value>
</Value>
<Value name="3">
<Value>mlname</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGMoudleD</DataLocation>
<DefaultData>DHCMGMoudleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGMoudleD</IdLocation>
<IndexLocation>^User.DHCMGMoudleI</IndexLocation>
<StreamLocation>^User.DHCMGMoudleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
