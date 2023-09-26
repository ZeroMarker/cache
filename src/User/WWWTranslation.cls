/// Language Translation for WEB Pages
Class User.WWWTranslation Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = WWW_Translation, StorageStrategy = SQLStorage ]
{

/// WEB Translation Line Counter
Property WTRNSCnt As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = WTRNS_Cnt ];

/// WEB Language (see SS_Lang)
Property WTRNSLang As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WTRNS_Lang ];

/// WEB Page reference
Property WTRNSPage As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WTRNS_Page ];

/// WEB Translated Text
Property WTRNSText As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = WTRNS_Text ];

Index RowIDBasedIDKeyIndex On (WTRNSPage, WTRNSLang, WTRNSCnt) [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.WWWTranslation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.WWWTranslation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.WWWTranslation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.WWWTranslation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.WWWTranslation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.WWWTranslation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.WWWTranslation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.WWWTranslation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.WWWTranslation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.WWWTranslation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterWTRNS">
<Data name="WTRNS_Text"/>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WTRNS_Page</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>WTRNS_Lang</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>WTRNS_Cnt</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSWWW"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{WTRNS_Page}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"LANG"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WTRNS_Lang}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>"CNT"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{WTRNS_Cnt}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>WTRNS_RowID</SqlRowIdName>
<StreamLocation>^User.WWWTranslationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
