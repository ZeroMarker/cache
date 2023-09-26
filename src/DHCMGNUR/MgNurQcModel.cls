Class DHCMGNUR.MgNurQcModel Extends %Persistent
{

Relationship ChildSub As DHCMGNUR.MgNurQcModelChild [ Cardinality = children, Inverse = Parref ];

/// 科室
Property ModelDep As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Model_Dep ];

Property ModelName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Model_Name ];

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 4, SqlFieldName = Rec_Date ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 5, SqlFieldName = Rec_Time ];

Property RecUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Rec_User ];

/// H:(护理部) W:(病区护士长) Z:(总护士长)
Property ModelTyp As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Model_Typ ];

Property Status As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Status ];

Index typ On (ModelTyp, ModelName);

Index flag On (ModelTyp, ModelDep, ModelName);

ClassMethod Save(parr) As %String
{
	s ^TEMP("g06131433001")=parr //ModelDep|22^ModelName|产科测试模板^ModelTyp|W^RecUser|69^Status|Y^rw|
	s tmp=""
	s aa=##class(web.DHCMgNurQcRestruct).settmp(parr,.tmp)
	s id=$g(tmp("rw"))
	i id="" s obj=##class(DHCMGNUR.MgNurQcModel).%New()
	e  s obj=##class(DHCMGNUR.MgNurQcModel).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgNurQcModel","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..b 110
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod isExistRec(parr As %String) As %String
{
	s ^TEMP("g06141408001")=parr //ModelDep|22^ModelName|产科测试2^ModelTyp|W^RecUser|69^Status|Y^rw|
	s ward=$P($P(parr,"^",1),"|",2)
	s name=$zcvt($tr($P($P(parr,"^",2),"|",2)," ",""),"U")
	s typ=$P($P(parr,"^",3),"|",2)
	s rw=$P($P(parr,"^",6),"|",2)
	s ret=0
	s raw=$O(^DHCMGNUR.MgNurQcModelI("flag"," "_typ," "_ward," "_name,""))
	i raw="" s ret=0
	e  i ((raw'="")&&(rw'="")&&(raw'=rw)) s ret=1
	e  i ((raw'="")&&(rw'="")&&(raw=rw)) s ret=0
	e  i (raw'="")&&(rw="") s ret=1
	q ret
}

Storage Default
{
<Data name="MgNurQcModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModelDep</Value>
</Value>
<Value name="3">
<Value>ModelName</Value>
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
<Value>ModelTyp</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurQcModelD</DataLocation>
<DefaultData>MgNurQcModelDefaultData</DefaultData>
<IdLocation>^DHCMGNUR.MgNurQcModelD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurQcModelI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurQcModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
