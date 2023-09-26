/// creator:lulin
/// createdate:2019-12-04
/// description:敏感指标-指标配置-元素类
Class CT.DHCNS.Config.NsElement Extends %Persistent
{

Relationship ChildSub As CT.DHCNS.Config.NsElementSub [ Cardinality = children, Inverse = Parref ];

Relationship NsEleType As CT.DHCNS.Config.NsEleType [ Cardinality = children, Inverse = Parref ];

/// 元素ID
Property ID As %String [ SqlColumnNumber = 2, SqlFieldName = ID ];

/// 元素名称
Property EleDesc As %String [ SqlColumnNumber = 3, SqlFieldName = EleDesc ];

/// 元素分类-关联数据字典
Property EleClass As %String [ SqlColumnNumber = 4, SqlFieldName = EleClass ];

/// 频率-D:日、W:周、M:月、Q:季、H:半年、Y:年【弃用】
Property Rate As %String [ SqlColumnNumber = 5, SqlFieldName = Rate ];

/// 数据来源-A:自动、C:计算、M:手动。
Property DataMode As %String [ SqlColumnNumber = 6, SqlFieldName = DataMode ];

/// 元素状态-Y:启,N:停。【弃用】
Property Status As %String [ SqlColumnNumber = 7, SqlFieldName = Status ];

/// 元素定义
Property Remark As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = Remark ];

/// 关键字定义
Property KeyWord As %String [ SqlColumnNumber = 9, SqlFieldName = KeyWord ];

/// 类名
Property ClassName As %String [ SqlColumnNumber = 10, SqlFieldName = ClassName ];

/// 方法
Property MethodName As %String [ SqlColumnNumber = 11, SqlFieldName = MethodName ];

/// 参数
Property MethodParam As %String [ SqlColumnNumber = 12, SqlFieldName = MethodParam ];

/// 自动获取方式:O:医嘱执行、L:医嘱启停、V:不良事件、A:护理管理、R:护理病历、P:患者数,Z:其他
Property AutoType As %String [ SqlColumnNumber = 13, SqlFieldName = AutoType ];

/// 阶段性数据获取计算方式：A:期初/E:期末,S:和值
Property DualType As %String [ SqlColumnNumber = 14, SqlFieldName = DualType ];

/// 自动获取护理管理相关类型：Q离职数、I:在职数、D:白班小时数、N:夜班小时数
Property NurMgType As %String [ SqlColumnNumber = 15, SqlFieldName = NurMgType ];

/// 自动获取护理管理子类型：学历、职务、聘任专业技术职称、年资
Property NurMgSubType As %String [ SqlColumnNumber = 16, SqlFieldName = NurMgSubType ];

/// 自动获取护理管理子类型id
Property NurMgSubTypeID As %String [ SqlColumnNumber = 17, SqlFieldName = NurMgSubTypeID ];

/// 自动获取护理管理子年资范围:包头不包尾--头
Property SenioritySt As %String [ SqlColumnNumber = 18, SqlFieldName = SenioritySt ];

/// 自动获取护理管理子年资范围:包头不包尾--尾
Property SeniorityEnd As %String [ SqlColumnNumber = 19, SqlFieldName = SeniorityEnd ];

/// 不良事件发生类型，唯一值。三位：类型,子类，子类明细。三个分号进行隔开
Property AdvType As %String [ SqlColumnNumber = 20, SqlFieldName = AdvType ];

/// 患者类型：S:总数，B：床日数, DN:白班新收,NN:夜班新收,DT:白天转入,NT:夜班转入,DO:白天转出,NO:夜班转出
Property PatType As %String [ SqlColumnNumber = 21, SqlFieldName = PatType ];

/// 医嘱类型：O:例次，L：留置数, P:患者数
Property OrderType As %String [ SqlColumnNumber = 22, SqlFieldName = OrderType ];

/// 不良事件发生区间："":全天,"D":白班，"N":夜班
Property AdvDual As %String [ SqlColumnNumber = 23, SqlFieldName = AdvDual ];

/// 医嘱存在的某个时间点
Property OrderTime As %Time [ SqlColumnNumber = 24, SqlFieldName = OrderTime ];

/// 是否不要婴儿数据【""/Y:是,N:否】
Property IsNoBaby As %String [ SqlColumnNumber = 25, SqlFieldName = IsNoBaby ];

/// 是否执业护士【""/Y:是,N:否】
Property IsRegister As %String [ SqlColumnNumber = 26, SqlFieldName = IsRegister ];

/// 是否责班【""/Y:是,N:否】
Property IsDuty As %String [ SqlColumnNumber = 27, SqlFieldName = IsDuty ];

/// 额外数
Property OtherNum As list Of %String [ SqlColumnNumber = 28, SqlFieldName = OtherNum ];

/// 是否本病区工作年限 Y：是，N/"":否
Property IsOnlyWard As %String [ SqlColumnNumber = 29, SqlFieldName = IsOnlyWard ];

/// 是否仅病区 Y：是，N/"":否
Property IsOnlyInWard As %String [ SqlColumnNumber = 30, SqlFieldName = IsOnlyInWard ];

/// 过滤病区
Property FilterWard As list Of %String [ SqlColumnNumber = 31, SqlFieldName = FilterWard ];

/// 患者子类类型：""/"S":总数，D:诊断，Y:年龄
Property PatSubType As %String [ SqlColumnNumber = 32, SqlFieldName = PatSubType ];

/// 院感类型：PICC:PICC，CVC：CVC, UC:导尿管，VAP:呼吸机
Property InfType As %String [ SqlColumnNumber = 33, SqlFieldName = InfType ];

/// 患者子类值
Property PatSubValue As %String [ SqlColumnNumber = 34, SqlFieldName = PatSubValue ];

/// 患者子类年龄的单位[{rw:"Y",desc:"年"},{rw:"M",desc:"月"},{rw:"D",desc:"日"}]
Property PatSubValueType As %String [ SqlColumnNumber = 35, SqlFieldName = PatSubValueType ];

/// 患者子类年龄上线
Property PatSubEndValue As %String [ SqlColumnNumber = 36, SqlFieldName = PatSubEndValue ];

/// 自动类型是否重复
Property RepeatFlag As %String [ SqlColumnNumber = 37, SqlFieldName = RepeatFlag ];

Index ID On ID [ Unique ];

Index AutoType On AutoType;

Storage Default
{
<Data name="NsElementDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ID</Value>
</Value>
<Value name="3">
<Value>EleDesc</Value>
</Value>
<Value name="4">
<Value>EleClass</Value>
</Value>
<Value name="5">
<Value>Rate</Value>
</Value>
<Value name="6">
<Value>DataMode</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>KeyWord</Value>
</Value>
<Value name="10">
<Value>ClassName</Value>
</Value>
<Value name="11">
<Value>MethodName</Value>
</Value>
<Value name="12">
<Value>MethodParam</Value>
</Value>
<Value name="13">
<Value>AutoType</Value>
</Value>
<Value name="14">
<Value>DualType</Value>
</Value>
<Value name="15">
<Value>NurMgType</Value>
</Value>
<Value name="16">
<Value>NurMgSubType</Value>
</Value>
<Value name="17">
<Value>NurMgSubTypeID</Value>
</Value>
<Value name="18">
<Value>SenioritySt</Value>
</Value>
<Value name="19">
<Value>SeniorityEnd</Value>
</Value>
<Value name="20">
<Value>AdvType</Value>
</Value>
<Value name="21">
<Value>PatType</Value>
</Value>
<Value name="22">
<Value>OrderType</Value>
</Value>
<Value name="23">
<Value>AdvDual</Value>
</Value>
<Value name="24">
<Value>OrderTime</Value>
</Value>
<Value name="25">
<Value>IsNoBaby</Value>
</Value>
<Value name="26">
<Value>IsRegister</Value>
</Value>
<Value name="27">
<Value>IsDuty</Value>
</Value>
<Value name="28">
<Value>OtherNum</Value>
</Value>
<Value name="29">
<Value>IsOnlyWard</Value>
</Value>
<Value name="30">
<Value>IsOnlyInWard</Value>
</Value>
<Value name="31">
<Value>FilterWard</Value>
</Value>
<Value name="32">
<Value>PatSubType</Value>
</Value>
<Value name="33">
<Value>InfType</Value>
</Value>
<Value name="34">
<Value>PatSubValue</Value>
</Value>
<Value name="35">
<Value>PatSubValueType</Value>
</Value>
<Value name="36">
<Value>PatSubEndValue</Value>
</Value>
<Value name="37">
<Value>RepeatFlag</Value>
</Value>
</Data>
<DataLocation>^CT.DHCNS.Config.NsElementD</DataLocation>
<DefaultData>NsElementDefaultData</DefaultData>
<IdLocation>^CT.DHCNS.Config.NsElementD</IdLocation>
<IndexLocation>^CT.DHCNS.Config.NsElementI</IndexLocation>
<StreamLocation>^CT.DHCNS.Config.NsElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
