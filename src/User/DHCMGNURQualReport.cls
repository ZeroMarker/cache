Class User.DHCMGNURQualReport Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//护理质控数据；

Property ChecDep As %String(TRUNCATE = 1);

Property ChecRp As User.DHCNURMGQualItm;

Property ChecRpData As %GlobalCharacterStream(LOCATION = "^User.DHCMGNURQualReportS");

Property ChecDate As %Library.Date(FORMAT = 1);

Property ChecPoint As %String(TRUNCATE = 1);

Property ChecPerson As User.DHCMGPersons;

Property ChecUser As User.DHCMGPersons;

Property ChecRecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)} ];

Property ChecRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)} ];

Property ChecMem As %String(TRUNCATE = 1);

Property ChecCPRp As User.DHCMGNURCPReport;

//

Property Checlevel As %String;

//测评记录

Index PersonDate On (ChecPerson, ChecDate);

Index DepDate On (ChecDep, ChecDate);

Index CP On ChecCPRp;

//测评

Method SaveStream(ByRef Itm As User.DHCMGNURQualReport, str As %String) As %String
{
 //s a=##class(User.DHCMGNURQualReport).GetStream()
    
	d Itm.ChecRpData.Write(str)
	q 0
}

ClassMethod getId(parm As %String) As %String
{
 //##class(
  // s parm="2009-12-1^2983"
   s person=$P(parm,"^"),date=$P(parm,"^",2),cpid=$P(parm,"^",3)
   s date=$ZDH(date,3)
   s ret=""
   s rw="" f  s rw=$O(^User.DHCMGNURQualReportI("PersonDate",person,date,rw)) q:rw=""  d
   .s a=^User.DHCMGNURQualReportD(rw)
   .s cp=$List(a,7)
   .if cp=cpid s ret=rw
   q ret
}

ClassMethod GetStream(id) As %Stream
{
	   s a=##class(User.DHCMGNURQualReport).%OpenId(id)
	   q a.ChecRpData
}

ClassMethod ifexist(User, nurs, CpRepId) As %String
{
 //判断是否被测评s a=##class(User.DHCMGNURQualReport).ifexist()
   
  
     s flag="0"
     s rw="" f  s rw=$O(^User.DHCMGNURQualReportI("CP",CpRepId,rw)) q:rw=""  d
     .s a=^User.DHCMGNURQualReportD(rw)
     .s cuser=$ListGet(a,9),cnurse=$ListGet(a,11)
     .if (cuser=User)&(cnurse=nurs) s flag=rw
     q flag
}

Storage Default
{
<Data name="DHCMGNURQualReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChecDate</Value>
</Value>
<Value name="3">
<Value>ChecDep</Value>
</Value>
<Value name="4">
<Value>ChecMem</Value>
</Value>
<Value name="5">
<Value>ChecRecDate</Value>
</Value>
<Value name="6">
<Value>ChecRecTime</Value>
</Value>
<Value name="7">
<Value>ChecRp</Value>
</Value>
<Value name="8">
<Value>ChecRpData</Value>
</Value>
<Value name="9">
<Value>ChecUser</Value>
</Value>
<Value name="10">
<Value>ChecPoint</Value>
</Value>
<Value name="11">
<Value>ChecPerson</Value>
</Value>
<Value name="12">
<Value>ChecCPRp</Value>
</Value>
<Value name="13">
<Value>Checlevel</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNURQualReportD</DataLocation>
<DefaultData>DHCMGNURQualReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNURQualReportD</IdLocation>
<IndexLocation>^User.DHCMGNURQualReportI</IndexLocation>
<StreamLocation>^User.DHCMGNURQualReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
