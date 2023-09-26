/// Order Linked 
Class User.DHCDocOrdLinked Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = L_Rowid, SqlTableName = DHC_Doc_OrdLinked ]
{

Parameter EXTENTSIZE = 250;

/// L_ArcIMDr
Property LArcIMDr As ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = L_ArcIMDr ];

/// L_LinkArcIMDr
Property LLinkArcIMDr As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = L_LinkArcIMDr ];

/// L_StDate
Property LStDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = L_StDate ];

/// L_EndDate
Property LEndDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = L_EndDate ];

/// L_HospDr
Property LHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = L_HospDr ];

Storage Default
{
<Data name="DHCDocOrdLinkedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LArcIMDr</Value>
</Value>
<Value name="3">
<Value>LLinkArcIMDr</Value>
</Value>
<Value name="4">
<Value>LStDate</Value>
</Value>
<Value name="5">
<Value>LEndDate</Value>
</Value>
<Value name="6">
<Value>LHospDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocOrdLinkedD</DataLocation>
<DefaultData>DHCDocOrdLinkedDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCDocOrdLinkedD</IdLocation>
<IndexLocation>^User.DHCDocOrdLinkedI</IndexLocation>
<SQLMap name="DataMast">
<Data name="L_ArcIMDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="L_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="L_LinkArcIMDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="L_StDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^TOL</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>L_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"Linked"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{L_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocOrdLinkedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
