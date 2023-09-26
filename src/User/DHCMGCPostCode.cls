Class User.DHCMGCPostCode Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMGC_PostCode ]
{

//代码

Property PostCode As %String(TRUNCATE = 1);

Property PostTyp As %String(TRUNCATE = 1);

Property PostDesc As %String(TRUNCATE = 1);

Index Typ On PostTyp;

ClassMethod savePostCode(parr As %String) As %String
{
    s id=$P(parr,"^",1)
    s code=$P(parr,"^",2)
    s desc=$P(parr,"^",3)
    s Typ=$P(parr,"^",4)
    if id="" s post=##class(User.DHCMGCPostCode).%New()
    e  s post=##class(User.DHCMGCPostCode).%OpenId(id)
    s post.PostCode=code
    s post.PostTyp=Typ
    s post.PostDesc=desc
    d post.%Save()
    q 0
}

Storage Default
{
<Data name="DHCMGCPostCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostCode</Value>
</Value>
<Value name="3">
<Value>PostDesc</Value>
</Value>
<Value name="4">
<Value>PostTyp</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCPostCodeD</DataLocation>
<DefaultData>DHCMGCPostCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCPostCodeD</IdLocation>
<IndexLocation>^User.DHCMGCPostCodeI</IndexLocation>
<StreamLocation>^User.DHCMGCPostCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
