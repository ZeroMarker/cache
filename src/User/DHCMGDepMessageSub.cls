Class User.DHCMGDepMessageSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ParentRef As User.DHCMGDepMessage [ Cardinality = parent, Inverse = ChildSub ];

Property Content As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

Property RecUser As %String(TRUNCATE = 1);

Property RecDate As %Library.Date(FORMAT = 1);

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)} ];

ClassMethod Save(parr As %String) As %String
{
 //s a=##class(User.DHCMGDepMessageSub).Save()
  //s parr="6"_$C(1)_""_$C(1)_"2636"_$C(1)_"sdfsdfsdfds"
   s parent=$P(parr,$C(1),1)
   s subrw=$P(parr,$C(1),2)
   s user=$P(parr,$C(1),3)
   s content=$P(parr,$C(1),4)
   if parent="" q 0
   if subrw'="" s a=##class(User.DHCMGDepMessageSub).%OpenId(parent_"||"_subrw)
   else  s a=##class(User.DHCMGDepMessageSub).%New()
   if (subrw'="")&(a.RecUser'=user) q 0
   s a.Content=content
   s a.ParentRef=##class(User.DHCMGDepMessage).%OpenId(parent)
   if subrw="" s a.RecUser=user
   s a.RecDate=+$H
   s a.RecTime=$P($H,",",2)
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGDepMessageSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>RecDate</Value>
</Value>
<Value name="4">
<Value>RecTime</Value>
</Value>
<Value name="5">
<Value>RecUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>DHCMGDepMessageSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^User.DHCMGDepMessageSubI</IndexLocation>
<StreamLocation>^User.DHCMGDepMessageSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
