Class EPRmeta.Privilege.PrivRuleType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Index IdxName On Name [ Data = Name, Unique ];

ClassMethod CheckIdExist(AID As %String) As %Integer
{
 set Result = ""
 &sql(SELECT Count(ID) into :Result  FROM EPRmeta_Privilege.PrivRuleType  WHERE ID = :AID)
 if Result=""
 {s Result=0 }
 QUIT Result
}

Query SELECTALL() As %SQLQuery(ROWSPEC = "ID:%String,Name:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_PrivRuleType_SELECTALL, SqlProc ]
{
 SELECT ID, Name, Description
 FROM EPRmeta_Privilege.PrivRuleType
 ORDER BY ID
}

Storage Default
{
<Data name="PrivRuleTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.PrivRuleTypeD</DataLocation>
<DefaultData>PrivRuleTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.PrivRuleTypeD</IdLocation>
<IndexLocation>^DHCEPRM.PrivRuleTypeI</IndexLocation>
<StreamLocation>^EPRmeta.Privil663.PrivRuleTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
