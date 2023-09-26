Class User.DHCMGPostDuty Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHCMG_Post_Duty ]
{

Property PostNurDutyDR As %String(TRUNCATE = 1) [ SqlFieldName = PostNur_Duty_DR ];

Property PostNurPostDR As %String(TRUNCATE = 1) [ SqlFieldName = PostNur_Post_DR ];

Index Post On PostNurPostDR;

ClassMethod savepostduty(parr) As %String
{
    s postdr=$P(parr,"^",1)
    s dutydr=$P(parr,"^",2)
    s a=##class(User.DHCMGPostDuty).%New()
    s a.PostNurDutyDR=dutydr
    s a.PostNurPostDR=postdr
    d a.%Save()
    s p=##class(User.DHCMGPost).%OpenId(postdr)
    s p.PostMaxTime=..gettimes(postdr)
    d p.%Save()
    q 0
}

ClassMethod delpostduty(rw) As %String
{
    s a=##class(User.DHCMGPostDuty).%OpenId(rw)
    s pst=a.PostNurPostDR
    d ##class(User.DHCMGPostDuty).%DeleteId(rw)
    s p=##class(User.DHCMGPost).%OpenId(pst)
    s p.PostMaxTime=..gettimes(pst)
    d p.%Save()
    q 0
}

ClassMethod gettimes(post) As %String
{
   	    s maxtime=0
   	    s rw="" f  s rw=$O(^User.DHCMGPostDutyI("Post"," "_post,rw)) q:rw=""  d
	    .s duty=$list(^User.DHCMGPostDutyD(rw),2)
	    .s a=^User.DHCMGCDutyD(duty)
        .s st=$List(a,13),et=$List(a,12)
        .s times=et-st
        .if times>maxtime s maxtime=times
      q maxtime/3600
}

Storage Default
{
<Data name="DHCMGPostDutyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostNurDutyDR</Value>
</Value>
<Value name="3">
<Value>PostNurPostDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPostDutyD</DataLocation>
<DefaultData>DHCMGPostDutyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPostDutyD</IdLocation>
<IndexLocation>^User.DHCMGPostDutyI</IndexLocation>
<StreamLocation>^User.DHCMGPostDutyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
