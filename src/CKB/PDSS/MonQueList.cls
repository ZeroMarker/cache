Class CKB.PDSS.MonQueList Extends (%Persistent, User.Abstract) [ SqlRowIdName = CM_RowID, SqlTableName = MonQueList ]
{

/// 监测主表ID  CM_Parrf_Dr
Property CMParrfDr As CKB.PDSS.MonMaster [ SqlColumnNumber = 2, SqlFieldName = CM_Parrf_Dr ];

/// 实体标识  CM_Item_Dr
Property CMItemDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 3, SqlFieldName = CM_Item_Dr ];

/// 问题目录  CM_Pro_Dr
Property CMProDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 4, SqlFieldName = CM_Pro_Dr ];

/// 问题项  CM_Fun_Dr
Property CMFunDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 5, SqlFieldName = CM_Fun_Dr ];

/// 提示内容  CM_TipsMsg
Property CMTipsMsg As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CM_TipsMsg ];

/// 管理级别  CM_ManLev_Dr
Property CMManLevDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 7, SqlFieldName = CM_ManLev_Dr ];

/// 医嘱标识  CM_Order_Dr
Property CMOrderDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CM_Order_Dr ];

/// 备注  CM_Remarks
Property CMRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CM_Remarks ];

/// 备注  CM_Sings
Property CMSings As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CM_Sings ];

Index Parref On CMParrfDr As Exact;

Storage Default
{
<Data name="MonQueListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CMParrfDr</Value>
</Value>
<Value name="3">
<Value>CMItemDr</Value>
</Value>
<Value name="4">
<Value>CMProDr</Value>
</Value>
<Value name="5">
<Value>CMFunDr</Value>
</Value>
<Value name="6">
<Value>CMTipsMsg</Value>
</Value>
<Value name="7">
<Value>CMManLevDr</Value>
</Value>
<Value name="8">
<Value>CMOrderDr</Value>
</Value>
<Value name="9">
<Value>CMRemarks</Value>
</Value>
<Value name="10">
<Value>CMSings</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.MonQueListD</DataLocation>
<DefaultData>MonQueListDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.MonQueListD</IdLocation>
<IndexLocation>^CKB.PDSS.MonQueListI</IndexLocation>
<StreamLocation>^CKB.PDSS.MonQueListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
