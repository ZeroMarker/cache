Class User.DHCMGDepMessage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChildSub As User.DHCMGDepMessageSub [ Cardinality = children, Inverse = ParentRef ];

Property Dep As %String(TRUNCATE = 1);

Property Content As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

Property RecUser As %String(TRUNCATE = 1);

Property RDate As %Library.Date(FORMAT = 1);

Property RecDate As %Library.Date(FORMAT = 1);

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)} ];

Index DepDate On (Dep, RDate);

ClassMethod Save(parr As %String) As %String
{
   s content=$P(parr,$C(1),3)
   s id=$P(parr,$C(1),1)
   s User=$P(parr,$C(1),3)
   s Dep=$P(parr,$C(1),2)
   s content=$P(parr,$C(1),4)
   if id="" s a=##class(User.DHCMGDepMessage).%New()
   else  s a=##class(User.DHCMGDepMessage).%OpenId(id)
   s a.Content=content
   if id="" s a.RecUser=User
   if id="" s a.Dep=Dep
   s a.RecDate=+$H
   s a.RecTime=$P($H,",",2)
  if id="" s a.RDate=+$H
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGDepMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>Dep</Value>
</Value>
<Value name="4">
<Value>RecDate</Value>
</Value>
<Value name="5">
<Value>RecTime</Value>
</Value>
<Value name="6">
<Value>RecUser</Value>
</Value>
<Value name="7">
<Value>RDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGDepMessageD</DataLocation>
<DefaultData>DHCMGDepMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGDepMessageD</IdLocation>
<IndexLocation>^User.DHCMGDepMessageI</IndexLocation>
<StreamLocation>^User.DHCMGDepMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
