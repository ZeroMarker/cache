/// DHC Nurse FaYao Time Set
Class User.DHCNurFaYaoTimeSet Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = DHCNur_FyTimeSet_RowId, SqlTableName = DHCNur_FaYaoTimeSet ]
{

/// Ward_Dr
Property WardDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Ward_Dr ];

/// MedTyp_Dr
Property MedTypDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MedTyp_Dr ];

/// EDate
Property EDate As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EDate ];

/// ETime
Property ETime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = ETime ];

/// HospID
Property HospID As %Library.String [ SqlColumnNumber = 6, SqlFieldName = HospID ];

/// SDate
Property SDate As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SDate ];

/// STime
Property STime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = STime ];

Property pharmacyDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = pharmacy_Dr ];

Index HospID On HospID;

Index Med On MedTypDr;

Index wardLinkPharmacyDr On (WardDr, pharmacyDr) [ Unique ];

/// ##class(User.DHCNurFaYaoTimeSet).Save("8^237^^^23:00:00")
ClassMethod Save(parr As %String, HospID = "") As %String
{
  // s parr="^1^首都医科大学^首都医科大学^2009-03-12^"
   s ^tempsc("svFYTSt")=parr
   s ret=0
   s id=$P(parr,"^",1)
   s Ward=$P(parr,"^",2)
   s MedTyp=$P(parr,"^",3)
   s EDate=$P(parr,"^",4)
   s ETime=$P(parr,"^",5)
   i ETime'="" s ETime=$zth(ETime)
   if id'="" s a=##class(User.DHCNurFaYaoTimeSet).%OpenId(id)
   e  s a=##class(User.DHCNurFaYaoTimeSet).%New()
   s a.WardDr=Ward
   s a.MedTypDr=MedTyp
   s a.EDate=EDate
   s a.ETime=ETime
   s a.HospID=HospID
   s sc=a.%Save()
   i $$$ISERR(sc) d 
   .s ret=$system.Status.GetErrorText(sc)
   .s errCode=$system.Status.GetErrorCodes(sc)
   .i errCode=5808 s ret="记录重复！"
   q ret
}

ClassMethod Del(id As %String) As %String
{
   q:id="" -1
   s a=##class(User.DHCNurFaYaoTimeSet).%DeleteId(id)
   q 0
}

Storage Default
{
<Data name="DHCNurFaYaoTimeSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDate</Value>
</Value>
<Value name="3">
<Value>ETime</Value>
</Value>
<Value name="4">
<Value>MedTypDr</Value>
</Value>
<Value name="5">
<Value>WardDr</Value>
</Value>
<Value name="6">
<Value>HospID</Value>
</Value>
<Value name="7">
<Value>SDate</Value>
</Value>
<Value name="8">
<Value>STime</Value>
</Value>
<Value name="9">
<Value>pharmacyDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurFaYaoTimeSetD</DataLocation>
<DefaultData>DHCNurFaYaoTimeSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurFaYaoTimeSetD</IdLocation>
<IndexLocation>^User.DHCNurFaYaoTimeSetI</IndexLocation>
<StreamLocation>^User.DHCNurFaYaoTimeSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
