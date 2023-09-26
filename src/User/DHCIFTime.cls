Class User.DHCIFTime Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Infu_OeoreId
Property InfuOeoreId As %String(TRUNCATE = 1);

/// Infu_Adm
Property InfuAdm As %String(TRUNCATE = 1);

/// Infu_RegNo
Property InfuRegNo As %String(TRUNCATE = 1);

/// Infu_Status
Property InfuStatus As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Infu_StDate
Property InfuStDate As %Library.Date(FORMAT = 1);

/// Infu_StTime
Property InfuStTime As %Library.Time;

/// Infu_PrefinalDate
Property InfuPrefinalDate As %Library.Date(FORMAT = 1);

/// Infu_PrefinalTime
Property InfuPrefinalTime As %Library.Time;

/// Infu_ActualEndDate 
Property InfuActualEndDate As %Library.Date(FORMAT = 1);

/// Infu_ActualEndTime 
Property InfuActualEndTime As %Library.Time;

/// Infu_WithTime
Property InfuWithTime As %String(TRUNCATE = 1);

/// Infu_finishUser 
Property InfufinishUser As %String(TRUNCATE = 1);

/// Infu_StartUser
Property InfuStartUser As %String(TRUNCATE = 1);

/// Infu_CTLocId
Property InfuCTLocId As %String(TRUNCATE = 1);

Index RegNo On InfuRegNo;

Index Oeore On InfuOeoreId;

Index CTLoc On (InfuCTLocId, InfuStDate);

ClassMethod Save(Parr As %String) As %String
{
	s id=$P(Parr,"^",1)
	s OeoreId=$P(Parr,"^",2)
	s Adm=$P(Parr,"^",3)
	s RegNo=$P(Parr,"^",4)
	s Status=$P(Parr,"^",5)
	s StDate=$P(Parr,"^",6)
	s StTime=$P(Parr,"^",7)
	s CTLocId=$P(Parr,"^",8)
	s ExecUserId=$P(Parr,"^",9)
	if id="" s a=##class(User.DHCIFTime).%New()
	else  s a=##class(User.DHCIFTime).%OpenId(id)
	s a.InfuOeoreId=OeoreId
	s a.InfuAdm=Adm
	s a.InfuRegNo=RegNo
	s a.InfuStatus=Status
	s a.InfuStDate=StDate
	s a.InfuStTime=StTime
	s a.InfuCTLocId=CTLocId
	s a.InfuStartUser=ExecUserId
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCIFTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfuActualEndDate</Value>
</Value>
<Value name="3">
<Value>InfuActualEndTime</Value>
</Value>
<Value name="4">
<Value>InfuAdm</Value>
</Value>
<Value name="5">
<Value>InfuCTLocId</Value>
</Value>
<Value name="6">
<Value>InfuOeoreId</Value>
</Value>
<Value name="7">
<Value>InfuPrefinalDate</Value>
</Value>
<Value name="8">
<Value>InfuPrefinalTime</Value>
</Value>
<Value name="9">
<Value>InfuRegNo</Value>
</Value>
<Value name="10">
<Value>InfuStDate</Value>
</Value>
<Value name="11">
<Value>InfuStTime</Value>
</Value>
<Value name="12">
<Value>InfuStartUser</Value>
</Value>
<Value name="13">
<Value>InfuStatus</Value>
</Value>
<Value name="14">
<Value>InfuWithTime</Value>
</Value>
<Value name="15">
<Value>InfufinishUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCIFTimeD</DataLocation>
<DefaultData>DHCIFTimeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCIFTimeD</IdLocation>
<IndexLocation>^User.DHCIFTimeI</IndexLocation>
<StreamLocation>^User.DHCIFTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
