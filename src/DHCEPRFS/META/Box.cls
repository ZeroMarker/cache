Class DHCEPRFS.META.Box Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 扫描后装箱，箱定义类	
/// 箱名
Property BoxName As %String(TRUNCATE = 1);

/// 箱代码
Property BoxCode As %String(TRUNCATE = 1);

/// 箱描述
Property BoxDesc As %String(TRUNCATE = 1);

/// 箱顺序号
Property BoxNumber As %Integer;

/// 箱条码信息
Property BoxBarCode As %String(TRUNCATE = 1);

/// 箱位置代码
Property BoxLocationCode As %String(TRUNCATE = 1);

/// 箱位置描述
Property BoxLocationDesc As %String(TRUNCATE = 1);

/// 箱标签信息
Property BoxTag As %String(TRUNCATE = 1);

/// 创建者用户ID
Property CreateUserID As %String(TRUNCATE = 1);

/// 最后修改用户ID
Property LastModifyUserID As %String(TRUNCATE = 1);

/// 封箱用户ID
Property SealUserID As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

/// 封箱日期
Property SealDate As %Date;

/// 封箱时间
Property SealTime As %Time;

/// 箱当前状态 - E-空，F-满，N-正在装，C-作废
Property Status As %String(TRUNCATE = 1);

/// 箱中当前病案数量
Property TotalMedRecordCount As %Integer;

/// 箱中当前就诊数量
Property TotalEpisodeCount As %Integer;

Index IdxBoxNumber On BoxNumber;

Index IdxBoxCode On BoxCode;

Index IdxBoxStatus On (Status, BoxNumber);

Storage Default
{
<Data name="BoxDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BoxName</Value>
</Value>
<Value name="3">
<Value>BoxCode</Value>
</Value>
<Value name="4">
<Value>BoxDesc</Value>
</Value>
<Value name="5">
<Value>BoxNumber</Value>
</Value>
<Value name="6">
<Value>BoxTag</Value>
</Value>
<Value name="7">
<Value>CreateUserID</Value>
</Value>
<Value name="8">
<Value>ModifyUserID</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>ModifyDate</Value>
</Value>
<Value name="12">
<Value>ModifyTime</Value>
</Value>
<Value name="13">
<Value>TotalItemCount</Value>
</Value>
<Value name="14">
<Value>BoxBarCode</Value>
</Value>
<Value name="15">
<Value>BoxLocationCode</Value>
</Value>
<Value name="16">
<Value>BoxLocationDesc</Value>
</Value>
<Value name="17">
<Value>SealUserID</Value>
</Value>
<Value name="18">
<Value>SealDate</Value>
</Value>
<Value name="19">
<Value>SealTime</Value>
</Value>
<Value name="20">
<Value>TotalMedRecordCount</Value>
</Value>
<Value name="21">
<Value>TotalEpisodeCount</Value>
</Value>
<Value name="22">
<Value>Status</Value>
</Value>
<Value name="23">
<Value>LastModifyUserID</Value>
</Value>
<Value name="24">
<Value>LastModifyDate</Value>
</Value>
<Value name="25">
<Value>LastModifyTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.BoxD</DataLocation>
<DefaultData>BoxDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.BoxD</IdLocation>
<IndexLocation>^DHCEPRFS.META.BoxI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.BoxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
