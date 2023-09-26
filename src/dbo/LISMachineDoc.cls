/// 仪器文档
Class dbo.LISMachineDoc Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = LIS_MachineDoc ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKLISMachineDoc On RowID [ PrimaryKey, SqlName = PK_LIS_MachineDoc, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 关键字  
Property KeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

/// 通讯方式  
Property CommDirection As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 6 ];

/// 项目分隔符  
Property DelimiterForTests As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

/// 结果分隔符  
Property DelimiterForResults As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

/// 抗生素分隔符  
Property DelimiterForAnt As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

/// 微生物分隔符  
Property DelimiterForSen As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 10 ];

/// 接口程序  
Property IFProgram As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 11 ];

/// 端口  
Property ComPort As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 波特率  
Property BaudRate As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 13 ];

/// 数据位  
Property DataBits As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 14 ];

/// 结束位  
Property StopBits As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 15 ];

/// Parity  
Property Parity As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 16 ];

/// 设备型号  
Property DeviceCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 19 ];

/// 生产商  
Property Manufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 20 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 21 ];

/// 设备型号  
Property EquipmentType As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 22 ];

/// 连接类型  
Property LinkType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 23 ];

/// 使用医院  
Property UsingHos As %Library.String(COLLATION = "Exact", MAXLEN = 4000) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="LISMachineDocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>KeyWord</Value>
</Value>
<Value name="5">
<Value>CommDirection</Value>
</Value>
<Value name="6">
<Value>DelimiterForTests</Value>
</Value>
<Value name="7">
<Value>DelimiterForResults</Value>
</Value>
<Value name="8">
<Value>DelimiterForAnt</Value>
</Value>
<Value name="9">
<Value>DelimiterForSen</Value>
</Value>
<Value name="10">
<Value>IFProgram</Value>
</Value>
<Value name="11">
<Value>ComPort</Value>
</Value>
<Value name="12">
<Value>BaudRate</Value>
</Value>
<Value name="13">
<Value>DataBits</Value>
</Value>
<Value name="14">
<Value>StopBits</Value>
</Value>
<Value name="15">
<Value>Parity</Value>
</Value>
<Value name="16">
<Value>DeviceCode</Value>
</Value>
<Value name="17">
<Value>Sequence</Value>
</Value>
<Value name="18">
<Value>Active</Value>
</Value>
<Value name="19">
<Value>Manufacturer</Value>
</Value>
<Value name="20">
<Value>Remark</Value>
</Value>
<Value name="21">
<Value>EquipmentType</Value>
</Value>
<Value name="22">
<Value>LinkType</Value>
</Value>
<Value name="23">
<Value>UsingHos</Value>
</Value>
</Data>
<DataLocation>^dbo.LISMachineDocD</DataLocation>
<DefaultData>LISMachineDocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.LISMachineDocD</IdLocation>
<IndexLocation>^dbo.LISMachineDocI</IndexLocation>
<StreamLocation>^dbo.LISMachineDocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
