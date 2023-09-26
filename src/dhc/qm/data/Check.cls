Class dhc.qm.data.Check Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Check_rowid, SqlTableName = CheckInfo ]
{

/// Check_code
Property CheckCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Check_code ];

/// Check_name
Property CheckName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Check_name ];

/// Check_locType 1-扣选择科室 2-扣列表科室
Property CheckLocType As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = Check_locType ];

/// Check_colType  1：录入 2：采集 3：计算 4:Excel导入
Property CheckColType As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = Check_colType ];

/// Check_AssessType  1:选项 2：文本   3:时间文本选择
Property CheckAssessType As %Library.Integer [ SqlColumnNumber = 6, SqlFieldName = Check_AssessType ];

/// Check_desc
Property CheckDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Check_desc ];

/// Check_active
Property CheckActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = Check_active ];

/// Check_photo
Property CheckPhoto As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = Check_photo ];

/// Check_spcil 
Property CheckSpcil As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = Check_spcil ];

/// Check_ObjectType 1-科室 2-病人
Property CheckObjectType As %Library.Integer [ SqlColumnNumber = 11, SqlFieldName = Check_ObjectType ];

/// Check_comp 
Property Checkcomp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = Check_comp ];

Index CheckSpcil On CheckSpcil;

Index CheckName On CheckName;

Index CheckCode On CheckCode;

Storage Default
{
<Data name="CheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConditionCode</Value>
</Value>
<Value name="3">
<Value>ConditionName</Value>
</Value>
<Value name="4">
<Value>ConditionShortcut</Value>
</Value>
<Value name="5">
<Value>ConditionDesc</Value>
</Value>
<Value name="6">
<Value>ConditionActive</Value>
</Value>
<Value name="7">
<Value>CheckCode</Value>
</Value>
<Value name="8">
<Value>CheckName</Value>
</Value>
<Value name="9">
<Value>CheckLocType</Value>
</Value>
<Value name="10">
<Value>CheckColType</Value>
</Value>
<Value name="11">
<Value>CheckAssessType</Value>
</Value>
<Value name="12">
<Value>CheckDesc</Value>
</Value>
<Value name="13">
<Value>CheckActive</Value>
</Value>
<Value name="14">
<Value>CheckPhoto</Value>
</Value>
<Value name="15">
<Value>CheckSpcil</Value>
</Value>
<Value name="16">
<Value>CheckObjectType</Value>
</Value>
<Value name="17">
<Value>Checkcomp</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMCheckD</DataLocation>
<DefaultData>CheckDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMCheckD</IdLocation>
<IndexLocation>^DHCCJXQMCheckI</IndexLocation>
<StreamLocation>^DHCCJXQMCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
