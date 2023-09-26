Class User.DHCMDTMeetTemp Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_MDTMeetTemp ]
{

/// MDT主表ID   MC_Adm_Dr
Property MMParRefDr As User.DHCMDTConsult [ SqlColumnNumber = 2, SqlFieldName = MM_ParRef_Dr ];

/// 项目代码  MC_RLoc_Dr
Property MMItemCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = MM_Item_Code ];

/// 项目值  MC_RDate
Property MMItemVal As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MM_ItemVal ];

Index IndexMdtRecord On MMParRefDr;

Storage Default
{
<Data name="DHCMDTMeetTempDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MMParRefDr</Value>
</Value>
<Value name="3">
<Value>MMItemCode</Value>
</Value>
<Value name="4">
<Value>MMItemVal</Value>
</Value>
</Data>
<DataLocation>^User.DHCMDTMeetTempD</DataLocation>
<DefaultData>DHCMDTMeetTempDefaultData</DefaultData>
<IdLocation>^User.DHCMDTMeetTempD</IdLocation>
<IndexLocation>^User.DHCMDTMeetTempI</IndexLocation>
<StreamLocation>^User.DHCMDTMeetTempS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
