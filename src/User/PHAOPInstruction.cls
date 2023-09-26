Class User.PHAOPInstruction Extends (%Persistent, User.Abstract) [ SqlRowIdName = OPInst_RowId, SqlTableName = PHAOP_Instruction, StorageStrategy = CacheStorage ]
{

Index Loc On OPInstLocDr As Exact;

Index Inst On OPInstInstDr As Exact;

/// 科室
Property OPInstLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = OPInst_Loc_Dr ];

/// 用法
Property OPInstInstDr As User.PHCInstruc [ SqlColumnNumber = 3, SqlFieldName = OPInst_Inst_Dr ];

Storage CacheStorage
{
<Data name="PHAOPInstructionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPInstLocDr</Value>
</Value>
<Value name="3">
<Value>OPInstInstDr</Value>
</Value>
</Data>
<DataLocation>^CF.PHA.OP.INST</DataLocation>
<DefaultData>PHAOPInstructionDefaultData</DefaultData>
<IdLocation>^CF.PHA.OP.INST</IdLocation>
<IndexLocation>^CF.PHA.OP.INSTi</IndexLocation>
<StreamLocation>^User.PHAOPInstructionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
