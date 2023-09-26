/// 输血记录
Class CIS.AN.BloodTransRecord Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BloodTransRecord ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 受血者复检ABO血型
Property ABO As %String [ SqlColumnNumber = 3 ];

/// 受血者复检RH血型
Property RH As %String [ SqlColumnNumber = 4 ];

/// 复检人员
Property TestProv As %String [ SqlColumnNumber = 5 ];

/// 血袋编码
Property BloodBag As CIS.AN.BloodBag [ SqlColumnNumber = 6 ];

/// 输血血型
Property BloodType As %String [ SqlColumnNumber = 7 ];

/// 血液种类
Property BloodCategory As %String [ SqlColumnNumber = 8 ];

/// 血量
Property Volume As %String [ SqlColumnNumber = 9 ];

/// 输血单位
Property Unit As %String [ SqlColumnNumber = 10 ];

/// 交叉配血
Property CrossMatching As %String [ SqlColumnNumber = 11 ];

/// 配血者
Property MatchingProv As %String [ SqlColumnNumber = 12 ];

/// 发血者
Property GrantProv As %String [ SqlColumnNumber = 13 ];

/// 取血者
Property FetchProv As %String [ SqlColumnNumber = 14 ];

/// 取血日期
Property FetchDate As %Date [ SqlColumnNumber = 15 ];

/// 取血时间
Property FetchTime As %Time [ SqlColumnNumber = 16 ];

/// 输血执行者
Property ExecProv As %String [ SqlColumnNumber = 17 ];

/// 输血核对者
Property CheckProv As %String [ SqlColumnNumber = 18 ];

/// 输血开始日期
Property TransStartDate As %Date [ SqlColumnNumber = 19 ];

/// 输血开始时间
Property TransStartTime As %Time [ SqlColumnNumber = 20 ];

/// 输血结束日期
Property TransEndDate As %Date [ SqlColumnNumber = 21 ];

/// 输血结束时间
Property TransEndTime As %Time [ SqlColumnNumber = 22 ];

/// 最后更新用户
Property UpdateUser As %String [ SqlColumnNumber = 23 ];

/// 最后更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 24 ];

/// 最后更新时间
Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 25 ];

/// 配血日期
Property MatchingDate As %Date [ SqlColumnNumber = 26 ];

/// 配血时间
Property MatchingTime As %Time [ SqlColumnNumber = 27 ];

/// 输血执行者证书ID
Property ExecProvCertID As %String [ SqlColumnNumber = 28 ];

/// 输血执行者签名时间戳
Property ExecTimeStamp As %GlobalCharacterStream(LOCATION = "^CIS.AN.BloodTransRecordS") [ SqlColumnNumber = 29 ];

/// 输血执行者签名数据
Property ExecSignData As %GlobalCharacterStream(LOCATION = "^CIS.AN.BloodTransRecordS") [ SqlColumnNumber = 30 ];

/// 输血核对者证书ID
Property CheckProvCertID As %String [ SqlColumnNumber = 31 ];

/// 输血核对者签名时间戳
Property CheckTimeStamp As %GlobalCharacterStream(LOCATION = "^CIS.AN.BloodTransRecordS") [ SqlColumnNumber = 32 ];

/// 输血核对者签名数据
Property CheckSignData As %GlobalCharacterStream(LOCATION = "^CIS.AN.BloodTransRecordS") [ SqlColumnNumber = 33 ];

/// 配血者姓名
Property MatchingProvDesc As %String [ SqlColumnNumber = 34 ];

/// 发血者姓名
Property GrantProvDesc As %String [ SqlColumnNumber = 35 ];

/// 复检者姓名
Property TestProvDesc As %String [ SqlColumnNumber = 36 ];

/// 输血ABO血型
Property TransABO As %String [ SqlColumnNumber = 37 ];

/// 输血RH血型
Property TransRH As %String [ SqlColumnNumber = 38 ];

/// 说明
Property Note As %String [ SqlColumnNumber = 39 ];

/// 手术麻醉记录表单索引
Index IRecordSheet On RecordSheet;

/// 输血日期索引
Index ITransDate On TransStartDate;

/// 血袋索引
Index IBloodBag On BloodBag;

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="BloodTransRecordDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>ABO</Value>
</Value>
<Value name="3">
<Value>RH</Value>
</Value>
<Value name="4">
<Value>TestProv</Value>
</Value>
<Value name="5">
<Value>BloodBag</Value>
</Value>
<Value name="6">
<Value>BloodType</Value>
</Value>
<Value name="7">
<Value>BloodCategory</Value>
</Value>
<Value name="8">
<Value>Volume</Value>
</Value>
<Value name="9">
<Value>Unit</Value>
</Value>
<Value name="10">
<Value>CrossMatching</Value>
</Value>
<Value name="11">
<Value>MatchingProv</Value>
</Value>
<Value name="12">
<Value>GrantProv</Value>
</Value>
<Value name="13">
<Value>FetchProv</Value>
</Value>
<Value name="14">
<Value>FetchDate</Value>
</Value>
<Value name="15">
<Value>FetchTime</Value>
</Value>
<Value name="16">
<Value>ExecProv</Value>
</Value>
<Value name="17">
<Value>CheckProv</Value>
</Value>
<Value name="18">
<Value>TransStartDate</Value>
</Value>
<Value name="19">
<Value>TransStartTime</Value>
</Value>
<Value name="20">
<Value>TransEndDate</Value>
</Value>
<Value name="21">
<Value>TransEndTime</Value>
</Value>
<Value name="22">
<Value>UpdateUser</Value>
</Value>
<Value name="23">
<Value>UpdateDate</Value>
</Value>
<Value name="24">
<Value>UpdateTime</Value>
</Value>
<Value name="25">
<Value>MatchingDate</Value>
</Value>
<Value name="26">
<Value>MatchingTime</Value>
</Value>
<Value name="27">
<Value>ExecProvCertID</Value>
</Value>
<Value name="28">
<Value>ExecTimeStamp</Value>
</Value>
<Value name="29">
<Value>ExecSignData</Value>
</Value>
<Value name="30">
<Value>CheckProvCertID</Value>
</Value>
<Value name="31">
<Value>CheckTimeStamp</Value>
</Value>
<Value name="32">
<Value>CheckSignData</Value>
</Value>
<Value name="33">
<Value>MatchingProvDesc</Value>
</Value>
<Value name="34">
<Value>GrantProvDesc</Value>
</Value>
<Value name="35">
<Value>TestProvDesc</Value>
</Value>
<Value name="36">
<Value>TransABO</Value>
</Value>
<Value name="37">
<Value>TransRH</Value>
</Value>
<Value name="38">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.BloodTransRecordD</DataLocation>
<DefaultData>BloodTransRecordDefaultData</DefaultData>
<IdLocation>^CIS.AN.BloodTransRecordD</IdLocation>
<IndexLocation>^CIS.AN.BloodTransRecordI</IndexLocation>
<StreamLocation>^CIS.AN.BloodTransRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
