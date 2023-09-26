Class DHCDoc.Interface.Inside.Drgs.Mesage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = Mesage ]
{

Index ADMDateTime On (DrgsAdmDr, DrgsInsertDate, DrgsInsertTime);

Index ADM On DrgsAdmDr;

Index DateTime On (DrgsAdmDr, DrgsInsertDate, DrgsInsertTime);

Property DrgsAdmDr As User.PAAdm [ SqlColumnNumber = 2 ];

Property DrgsParamJson As %String(COLLATION = "Exact", MAXLEN = 50000, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property DrgsRtnJson As %String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property DrgsInsertDate As %Date [ SqlColumnNumber = 5 ];

Property DrgsInsertTime As %Time [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="DHCDoc.Interface.Drgs.DrgsMesage">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DrgsAdmDr</Value>
</Value>
<Value name="3">
<Value>DrgsParamJson</Value>
</Value>
<Value name="4">
<Value>DrgsRtnJson</Value>
</Value>
<Value name="5">
<Value>DrgsInsertDate</Value>
</Value>
<Value name="6">
<Value>DrgsInsertTime</Value>
</Value>
</Data>
<DataLocation>^Doc.Interface.Drgs.MesageD</DataLocation>
<DefaultData>DHCDoc.Interface.Drgs.Mesage</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Doc.Interface.Drgs.MesageD</IdLocation>
<IndexLocation>^Doc.Interface.Drgs.MesageI</IndexLocation>
<StreamLocation>^Doc.Interface.Drgs.MesageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
