Class EPRmeta.SysOption Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Parameter EXTENTSIZE = 26;

Index NameIndex On Name [ Unique ];

Property Description As %String(MAXLEN = 1000, TRUNCATE = 1);

Property IsVisible As %String(TRUNCATE = 1);

// Visible:Null or "Y";  Unvisible:"N"

Property Name As %String(TRUNCATE = 1);

Property OptionValue As %String(MAXLEN = 2000, TRUNCATE = 1);

ClassMethod CheckMinusFieldExist(ATableName As %String, AFieldName As %String) As %String
{
 new Result
 
 &sql(SELECT Count(OptionValue)
 	into :Result 
 	FROM EPRmeta.SysOption
 	WHERE  Name = 'NotRemoveMinus' )
 
 if (Result="")||(Result="0")
 {s Result="0" }
 if '(Result="0")
 { 
 	New OptionValueStr
   	&sql(SELECT OptionValue
   		into :OptionValueStr
   		FROM EPRmeta.SysOption
   		WHERE  Name = 'NotRemoveMinus' )
   	
   	if '($F(OptionValueStr,ATableName)=0)
   	{ 
   		if ('$F(OptionValueStr,AFieldName)=0)  
		{ s Result="1" }
		else { s Result="0" } 
   	}
	else 
	{ 	s Result="0" }
  }
  
  QUIT Result
}

ClassMethod CheckIdExist(AID As %String) As %Integer
{
 new Result
 &sql(SELECT Count(ID)
 into :Result 
 FROM EPRmeta.SysOption
 WHERE ID = :AID)
 if Result=""
 {s Result=0 }
 QUIT Result
}

ClassMethod CheckNameUnique(AName As %String) As %Integer
{
 new Result
 &sql(SELECT Count(Name)
 into :Result 
 FROM EPRmeta.SysOption
 WHERE Name = :AName)
 QUIT Result
}

ClassMethod CheckUpdateNameUnique(AID As %String, AName As %String) As %Integer
{
 ;b "S"
 new Result
 new OldID 
 &sql(SELECT Count(Name)
 into :Result 
 FROM EPRmeta.SysOption
 WHERE Name = :AName)
 if (Result="")!(Result=0)
 {
 s Result=0
 }
 if '(Result=0) 
 {
 &sql(SELECT ID
 into :OldID
 FROM EPRmeta.SysOption
 WHERE Name = :AName)
 if ('OldID=AID)     
 { 
 s Result= 1
	  }
 if (OldID=AID)     
 { 
 s Result= 0
	  }

 }
 QUIT Result
}

ClassMethod GetOptionValueByName(AName As %String) As %String
{
 /*
 new Result
 New NumCount
 &sql(SELECT Count(OptionValue)
 into :NumCount
 FROM EPRmeta.SysOption
 WHERE Name = :AName)
 if 'NumCount=0
 {
 &sql(SELECT OptionValue
 into :Result 
 FROM EPRmeta.SysOption
 WHERE Name = :AName)
 QUIT Result
 }
 elseif (NumCount=0)
 {
	Quit "" 	 }
 */
 s Result=""
 k SQLCODE
 &sql(SELECT OptionValue
 into :Result 
 FROM EPRmeta.SysOption
 WHERE Name = :AName)
 q:(SQLCODE=0) Result
 q ""
}

ClassMethod GetOptionValueByName2(AName As %String, ADefaultValue As %String) As %String
{
	s ret = ..GetOptionValueByName(AName)
	s:(ret = "") ret = ADefaultValue
	q ret
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,OptionValue:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_SysOption_SELECTALL, SqlProc ]
{
 SELECT ID, Name,OptionValue,  Description
 FROM EPRmeta.SysOption
 WHERE ((IsVisible = 'Y') OR (IsVisible is null))
 ORDER BY Description
}

Storage Default
{
<Data name="SysOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>OptionValue</Value>
</Value>
<Value name="5">
<Value>IsVisible</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.SysOptionD</DataLocation>
<DefaultData>SysOptionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.SysOptionD</IdLocation>
<IndexLocation>^DHCEPRM.SysOptionI</IndexLocation>
<Property name="Description">
<Selectivity>4.0000%</Selectivity>
</Property>
<Property name="IsVisible">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Name">
<Selectivity>1</Selectivity>
</Property>
<Property name="OptionValue">
<Selectivity>5.2632%</Selectivity>
</Property>
<StreamLocation>^DHCEPRM.SysOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
