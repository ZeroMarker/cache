/// Deription: 毒麻药品销毁主表
Class User.PHAINNarcDestroy Extends %Persistent [ SqlRowIdName = PIND_RowId, SqlTableName = PHAIN_NarcDestroy ]
{

/// 索引
Index No On PINDNo As Exact;

Index Date On PINDDate As Exact;

/// ===============
/// 指向子表
Relationship ChildPHAINNarcDestroyItm As User.PHAINNarcDestroyItm [ Cardinality = children, Inverse = PINDIParRef ];

/// 销毁单号
Property PINDNo As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PIND_No ];

/// 销毁日期
Property PINDDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = PIND_Date ];

/// 销毁时间
Property PINDTime As %Time [ SqlColumnNumber = 4, SqlFieldName = PIND_Time ];

/// 销毁执行人(可能是多人)
Property PINDExeUserDR As %String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = PIND_ExeUser_DR ];

/// 销毁批准人(可能是多人)
Property PINDAuditUserDR As %String(MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = PIND_AuditUser_DR ];

/// 销毁监督人(可能是多人)
Property PINDSuperUserDR As %String(MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = PIND_SuperUser_DR ];

/// 销毁地点
Property PINDPlace As %String [ SqlColumnNumber = 8, SqlFieldName = PIND_Place ];

/// 销毁方式
Property PINDType As %String [ SqlColumnNumber = 9, SqlFieldName = PIND_Type ];

/// 销毁科室
Property PINDLocDR As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = PIND_Loc_DR ];

/// 销毁单明细数据来源(R-回收; S-报损)
Property PINDItmFrom As %String [ SqlColumnNumber = 11, SqlFieldName = PIND_ItmFrom ];

Storage Default
{
<Data name="PHAINNarcDestroyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PINDNo</Value>
</Value>
<Value name="3">
<Value>PINDDate</Value>
</Value>
<Value name="4">
<Value>PINDTime</Value>
</Value>
<Value name="5">
<Value>PINDExeUserDR</Value>
</Value>
<Value name="6">
<Value>PINDAuditUserDR</Value>
</Value>
<Value name="7">
<Value>PINDSuperUserDR</Value>
</Value>
<Value name="8">
<Value>PINDPlace</Value>
</Value>
<Value name="9">
<Value>PINDType</Value>
</Value>
<Value name="10">
<Value>PINDLocDR</Value>
</Value>
<Value name="11">
<Value>PINDItmFrom</Value>
</Value>
</Data>
<DataLocation>^BS.PHA.IN.NarcDestroy</DataLocation>
<DefaultData>PHAINNarcDestroyDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^BS.PHA.IN.NarcDestroy</IdLocation>
<IndexLocation>^BS.PHA.IN.NarcDestroyI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="PINDAuditUserDR">
<AverageFieldSize>13</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDDate">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDExeUserDR">
<AverageFieldSize>13</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDItmFrom">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDLocDR">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDNo">
<AverageFieldSize>21</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDPlace">
<AverageFieldSize>10</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDSuperUserDR">
<AverageFieldSize>13</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDTime">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PINDType">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Date">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="No">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^User.PHAINNarcDestroyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
