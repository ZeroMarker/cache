/// 仪器事件
Class dbo.QCMachineEvent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MachineEvent ]
{

Index IndexMaster On (MachineParameterDR, TestDate, TestTime) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKMachineEvent created via DDL
ForeignKey FKMachineEvent(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineEvent ];

/// Foreign Key FKMachineEventTestCode created via DDL
ForeignKey FKMachineEventTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineEventTestCode ];

/// Foreign Key FKMachineEventType created via DDL
ForeignKey FKMachineEventType(QCMachineEventTypeDR) References dbo.BTQCMachineEventType(PKBTQCMACHINEEVENTTYPE) [ SqlName = FK_MachineEventType ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检验日期  
Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 检验时间  
Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 6 ];

/// 新增用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 更新用户  
Property UpDateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 浓度  
Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 事件类型
Property QCMachineEventTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="QCMachineEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>TestDate</Value>
</Value>
<Value name="4">
<Value>TestTime</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>UpDateUserDR</Value>
</Value>
<Value name="8">
<Value>TestCodeDR</Value>
</Value>
<Value name="9">
<Value>LevelNo</Value>
</Value>
<Value name="10">
<Value>QCMachineEventTypeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMachineEventD</DataLocation>
<DefaultData>QCMachineEventDefaultData</DefaultData>
<IdLocation>^dbo.QCMachineEventD</IdLocation>
<IndexLocation>^dbo.QCMachineEventI</IndexLocation>
<StreamLocation>^dbo.QCMachineEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
