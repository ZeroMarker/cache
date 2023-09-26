Class dhc.qm.data.QMSchem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = QMSchem_RowID, SqlTableName = QMSchem ]
{

/// QMSchem_Code
Property QMSchemCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = QMSchem_Code ];

/// QMSchem_name
Property QMSchemname As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = QMSchem_name ];

/// QMSchem_desc 
Property QMSchemdesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = QMSchem_desc ];

/// QMSchem_shortcut  
Property QMSchemshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = QMSchem_shortcut ];

/// QMSchem_active  
Property QMSchemactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = QMSchem_active ];

/// QMSchem_Arcitem  关联医嘱 保存arc_itmmast的rowid以“;”分割
Property QMSchemArcitem As %Library.String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = QMSchem_Arcitem ];

/// QMSchem_periodType  M:月 Q:季度 H:半年 Y:年 
Property QMSchemperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = QMSchem_periodType ];

/// QMSchem_importType 1:PAD 2:PC
Property QMSchemimportType As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = QMSchem_importType ];

/// QMSchem_importType 1:不合格记录 2:全部 3:特殊检查点
Property QMSchemdataType As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = QMSchem_dataType ];

Index QMSchemCodeName On (QMSchemCode, QMSchemname);

//Index QMSchemCode On QMSchemCode;

Index QMSchemCode On QMSchemCode;

Storage Default
{
<Data name="QMSchemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QMSchemCode</Value>
</Value>
<Value name="3">
<Value>QMSchemname</Value>
</Value>
<Value name="4">
<Value>QMSchemdesc</Value>
</Value>
<Value name="5">
<Value>QMSchemshortcut</Value>
</Value>
<Value name="6">
<Value>QMSchemactive</Value>
</Value>
<Value name="7">
<Value>QMSchemArcitem</Value>
</Value>
<Value name="8">
<Value>QMSchemperiodType</Value>
</Value>
<Value name="9">
<Value>QMSchemimportType</Value>
</Value>
<Value name="10">
<Value>QMSchemdataType</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMQMSchemD</DataLocation>
<DefaultData>QMSchemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMQMSchemD</IdLocation>
<IndexLocation>^DHCCJXQMQMSchemI</IndexLocation>
<StreamLocation>^DHCCJXQMQMSchemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
