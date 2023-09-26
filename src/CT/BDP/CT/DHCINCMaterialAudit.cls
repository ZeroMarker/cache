/// Function:材料审批表
/// CreateDate:2023-04-18
/// Creator:sunfengchao
Class CT.BDP.CT.DHCINCMaterialAudit Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_INCMaterialAudit ]
{

/// 材料代码
Property BDPINCAMaterialCode As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 2, SqlFieldName = BDPINCA_MaterialCode ];

/// 材料名称
Property BDPINCAMaterialDesc As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3, SqlFieldName = BDPINCA_MaterialDesc ];

/// 业务类型  (A 新增,U 修改)
Property BDPINCAType As %String [ Required, SqlColumnNumber = 4, SqlFieldName = BDPINCA_Type ];

///  spd数据同步日期
Property BDPINCACreatDate As %Date [ SqlColumnNumber = 5, SqlFieldName = BDPINCA_CreatDate ];

///  spd数据同步时间
Property BDPINCACreatTime As %Time [ SqlColumnNumber = 6, SqlFieldName = BDPINCA_CreatTime ];

///  spd推送的材料数据   
Property BDPINCAMaterialValue As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = BDPINCA_MaterialValue ];

/// 物价办审批状态 (N：未审核，Y：通过 ,R 拒绝）
Property BDPINCAWJAuditStatus As %String(VALUELIST = ",N,Y,R") [ SqlColumnNumber = 8, SqlFieldName = BDPINCA_WJAuditStatus ];

/// 物价办审批人
Property BDPINCAWJAuditerDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = BDPINCA_WJAuditer_DR ];

/// 物价办审批日期
Property BDPINCAWJAuditDate As %Date [ SqlColumnNumber = 10, SqlFieldName = BDPINCA_WJAuditDate ];

/// 物价办审批时间
Property BDPINCAWJAuditTime As %Time [ SqlColumnNumber = 11, SqlFieldName = BDPINCA_WJAuditTime ];

/// 医务处 审批状态 (N：未审核，Y：通过 ,R 拒绝）
Property BDPINCAYWAuditStatus As %String(VALUELIST = ",N,Y,R") [ SqlColumnNumber = 12, SqlFieldName = BDPINCA_YWAuditStatus ];

/// 医务处审批人
Property BDPINCAYWAuditerDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = BDPINCA_YWAuditer_DR ];

/// 医务处审批日期
Property BDPINCAYWAuditDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BDPINCA_YWAuditDate ];

/// 医务处审批时间
Property BDPINCAYWAuditTime As %Time [ SqlColumnNumber = 15, SqlFieldName = BDPINCA_YWAuditTime ];

///  物价办需审批的数据  (收费项主表字段)
Property BDPINCATarValue As %String(MAXLEN = "") [ SqlColumnNumber = 16, SqlFieldName = BDPINCA_TarValue ];

///  医务处审批 医嘱项主表字段 
Property BDPINCAARCIMValue As %String(MAXLEN = "") [ SqlColumnNumber = 17, SqlFieldName = BDPINCA_ARCIMValue ];

/// 物价审批完成生成的收费项id 
Property BDPINCATarReference As %String [ SqlColumnNumber = 18, SqlFieldName = BDPINCA_TarReference ];

/// 新增 医嘱项时存的医嘱id 
Property BDPINCAARCIMReference As %String [ SqlColumnNumber = 19, SqlFieldName = BDPINCA_ARCIMReference ];

///  库存项id 
Property BDPINCAMaterialReference As %String [ SqlColumnNumber = 20, SqlFieldName = BDPINCA_MaterialReference ];

///  流程平台对应的流程实例 id 
Property BDPINCAProcInsId As %String [ SqlColumnNumber = 21, SqlFieldName = BDPINCA_ProcInsId ];

/// 材料代码索引
Index CodeIdx On BDPINCAMaterialCode As Exact;

/// 材料名称索引
Index DescIdx On BDPINCAMaterialDesc As Exact;

/// 操作类型 索引
Index TypeIdx On BDPINCAType As Exact;

///  同步日期索引
Index CreatDateIdx On BDPINCACreatDate;

/// 物价审批结果索引
Index WJAuditStatusIdx On BDPINCAWJAuditStatus As Exact;

/// 医务处审批结果索引
Index YWAuditStatusIdx On BDPINCAYWAuditStatus As Exact;

/// 流程实例id 索引
Index ProcInsId On BDPINCAProcInsId As Exact;

Storage Default
{
<Data name="DHCINCMaterialAuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPINCAMaterialCode</Value>
</Value>
<Value name="3">
<Value>BDPINCAMaterialDesc</Value>
</Value>
<Value name="4">
<Value>BDPINCAType</Value>
</Value>
<Value name="5">
<Value>BDPINCACreatDate</Value>
</Value>
<Value name="6">
<Value>BDPINCACreatTime</Value>
</Value>
<Value name="7">
<Value>BDPINCAMaterialValue</Value>
</Value>
<Value name="8">
<Value>BDPINCAWJAuditStatus</Value>
</Value>
<Value name="9">
<Value>BDPINCAWJAuditerDR</Value>
</Value>
<Value name="10">
<Value>BDPINCAWJAuditDate</Value>
</Value>
<Value name="11">
<Value>BDPINCAWJAuditTime</Value>
</Value>
<Value name="12">
<Value>BDPINCAYWAuditStatus</Value>
</Value>
<Value name="13">
<Value>BDPINCAYWAuditerDR</Value>
</Value>
<Value name="14">
<Value>BDPINCAYWAuditDate</Value>
</Value>
<Value name="15">
<Value>BDPINCAYWAuditTime</Value>
</Value>
<Value name="16">
<Value>BDPINCATarValue</Value>
</Value>
<Value name="17">
<Value>BDPINCAARCIMValue</Value>
</Value>
<Value name="18">
<Value>BDPINCATarReference</Value>
</Value>
<Value name="19">
<Value>BDPINCAARCIMReference</Value>
</Value>
<Value name="20">
<Value>BDPINCAMaterialReference</Value>
</Value>
<Value name="21">
<Value>BDPINCAProcInsId</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.DHCINCMaterialAuditD</DataLocation>
<DefaultData>DHCINCMaterialAuditDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.DHCINCMaterialAuditD</IdLocation>
<IndexLocation>^CT.BDP.CT.DHCINCMaterialAuditI</IndexLocation>
<StreamLocation>^CT.BDP.CT.DHCINCMaterialAuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
