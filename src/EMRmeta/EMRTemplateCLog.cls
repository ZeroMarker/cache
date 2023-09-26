/// Desc:       病历展现树操作日志
/// Creator:    yejian
/// CreateDate: 2018-6-13
Class EMRmeta.EMRTemplateCLog Extends %Persistent
{

Index IdxTypeDataID On (EmrType, DataID);

/// 类型 展现目录 CATEGORY，模板分类 CATEGORYCHAPTER,模板目录(DOCID) TEMPCATE,模板 EMRTEMPLATE
Property EmrType As %String(TRUNCATE = 1);

/// 关联数据ID
Property DataID As %String(TRUNCATE = 1);

/// 事件 添加 ADD，更新 UP,添加模板组：ADDGROUP,移除模板组:REMOVEGROUP，删除：DELETE
Property Action As %String(TRUNCATE = 1);

/// 状态 未启用：NOSTART ,启用：START,停用：STOP,删除：DELETE（只针对DOCID一级）
Property Status As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 启用日期
Property StartDate As %Date;

/// 启用时间
Property StartTime As %Time;

/// 停用日期
Property StopDate As %Date;

/// 停用时间
Property StopTime As %Time;

/// 操作者ID
Property UserID As %String(TRUNCATE = 1);

/// 操作者
Property UserName As %String(TRUNCATE = 1);

/// 操作IP地址
Property MachineIP As %String(TRUNCATE = 1);

/// 备注信息
Property Remark As %String(MAXLEN = 5000, TRUNCATE = 1);

Storage Default
{
<Data name="EMRTemplateCLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>OperateDate</Value>
</Value>
<Value name="5">
<Value>OperateTime</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>UserName</Value>
</Value>
<Value name="8">
<Value>MachineIP</Value>
</Value>
<Value name="9">
<Value>EmrType</Value>
</Value>
<Value name="10">
<Value>DataID</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>StartDate</Value>
</Value>
<Value name="13">
<Value>StartTime</Value>
</Value>
<Value name="14">
<Value>StopDate</Value>
</Value>
<Value name="15">
<Value>StopTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRTemplateCLogD</DataLocation>
<DefaultData>EMRTemplateCLogDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRTemplateCLogD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemplateCLogI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemplateCLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
