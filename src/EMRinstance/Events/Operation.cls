/// 名称:EMRinstance.Events.Operation                          
/// 描述:实例数据-医疗活动事件-手术\操作信息
/// 编写者：Guozongtao
/// 编写日期: 2014-08-16
Class EMRinstance.Events.Operation Extends %Persistent
{

Index IdxEpisodeIsActive On (EpisodeID, IsActive, OperStartDate, OperStartTime);

Index IdxOpaID On OpaID;

Relationship OperSub As EMRinstance.Events.OperationSub [ Cardinality = children, Inverse = OperRef ];

Property PatientID As %String;

Property EpisodeID As %String;

/// 手术ID
Property OpaID As %String;

/// 手术日期
Property OperDate As %String;

/// 手术开始日期
Property OperStartDate As %String;

/// 手术开始时间
Property OperStartTime As %String;

/// 手术结束日期
Property OperEndDate As %String;

/// 手术结束时间
Property OperEndTime As %String;

/// 术者ID
Property OperDocID As %String;

/// 术者名称
Property OperDoc As %String;

/// 一助ID
Property OperAssistFirstID As %String;

/// 一助Desc
Property OperAssistFirst As %String;

/// 二助ID
Property OperAssistSecondID As %String;

/// 二助Desc
Property OperAssistSecond As %String;

/// 手术部位ID
Property BodsDescID As %String;

/// 手术部位
Property BodsDesc As %String;

/// 手术体位ID
Property OperPositionID As %String;

/// 手术体位
Property OperPosition As %String;

/// 手术室Id
Property OperLocID As %String;

/// 手术室描述
Property OperLoc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 申请科室ID
Property OperAppLocID As %String;

/// 申请科室描述
Property OperAppLoc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术前诊断ID
Property OperPreopDiagID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术前诊断描述
Property OperPreopDiag As %String(MAXLEN = 800, TRUNCATE = 1);

/// 诊断备注
Property OperDiagMemo As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 体外循环
Property OperCirculation As %String;

/// 自体血回输
Property OperUseSelfBlood As %String;

/// 血型
Property OperBloodType As %String;

/// Rh血型
Property OperRhBloodType As %String;

/// 乙肝
Property OperHBsAg As %String;

/// 丙肝
Property OperHCVAb As %String;

/// HIV
Property OperHivAb As %String;

/// 梅毒
Property OperTPAb As %String;

/// 其他
Property OperOther As %String;

/// 麻醉医师Id
Property AnaDoctorID As %String;

/// 麻醉医师
Property AnaDoctor As %String;

/// 麻醉方法ID
Property AnaMethodID As %String;

/// 麻醉方法
Property AnaMethod As %String;

/// 麻醉开始日期
Property AnaStartDate As %String;

/// 麻醉开始时间
Property AnaStartTime As %String;

/// 麻醉结束日期
Property AnaEndDate As %String;

/// 麻醉结束时间
Property AnaEndTime As %String;

/// 手术间ID
Property OperRoomID As %String;

/// 手术间描述
Property OperRoom As %String(MAXLEN = 500, TRUNCATE = 1);

/// 台次
Property OperOrdNo As %String;

/// 安排日期
Property OperArrangeDate As %String;

/// 安排时间
Property OperArrangeTime As %String;

/// 入室日期
Property InRoomDate As %String;

/// 入室时间
Property InRoomTime As %String;

/// 离室日期
Property LeaveRoomDate As %String;

/// 离室时间
Property LeaveRoomTime As %String;

/// 器械护士一ID
Property ScrubNurFirstID As %String;

/// 器械护士一描述
Property ScrubNurFirst As %String;

/// 器械护士二ID
Property ScrubNurSecondID As %String;

/// 器械护士二描述
Property ScrubNurSecond As %String;

/// 器械护士三ID
Property ScrubNurThirdID As %String;

/// 器械护士三描述
Property ScrubNurThird As %String;

/// 巡回护士一ID
Property CirculNurFirstID As %String;

/// 巡回护士一描述
Property CirculNurFirst As %String;

/// 巡回护士二ID
Property CirculNurSecondID As %String;

/// 巡回护士二描述
Property CirculNurSecond As %String;

/// 巡回护士三ID
Property CirculNurThirdID As %String;

/// 巡回护士三描述
Property CirculNurThird As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 不否活动
Property IsActive As %String;

/// 手术状态(申请,撤销,拒绝,安排,非预约,术中,恢复室,术毕,完成,未审核)
Property OperPAStatus As %String;

/// 三助ID
Property OperAssistThirdID As %String;

/// 三助Desc
Property OperAssistThird As %String;

/// 副麻醉医师
Property AuxAnesthesiaDoc As %String;

/// 出血量
Property BleedBlood As %String;

/// 悬浮红
Property SuspenRed As %String;

/// 血浆
Property Plasma As %String;

/// 麻醉等级
Property AnesthesiaGrad As %String;

/// 术前诊断ICD编码
Property OperPreopDiagICD As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术后诊断ID
Property OperPostDiagId As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术后诊断描述
Property OperPostDiag As %String(MAXLEN = 800, TRUNCATE = 1);

/// 导管室技师一Id
Property TechnicianOneId As %String(TRUNCATE = 1);

/// 导管室技师一名称
Property TechnicianOneDes As %String(TRUNCATE = 1);

/// 导管室技师二Id
Property TechnicianTwoId As %String(TRUNCATE = 1);

/// 导管室技师二名称
Property TechnicianTwoDes As %String(TRUNCATE = 1);

/// 手术医师2Id
Property ANAOPSurgeonDR2 As %String(TRUNCATE = 1);

/// 手术医师2Code
Property ANAOPSurgeonCode2 As %String(TRUNCATE = 1);

/// 手术医师2
Property ANAOPSurgeon2 As %String(TRUNCATE = 1);

Storage Default
{
<Data name="OperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>OpaID</Value>
</Value>
<Value name="5">
<Value>OperDate</Value>
</Value>
<Value name="6">
<Value>OperStartDate</Value>
</Value>
<Value name="7">
<Value>OperStartTime</Value>
</Value>
<Value name="8">
<Value>OperEndDate</Value>
</Value>
<Value name="9">
<Value>OperEndTime</Value>
</Value>
<Value name="10">
<Value>OperDocID</Value>
</Value>
<Value name="11">
<Value>OperDoc</Value>
</Value>
<Value name="12">
<Value>OperAssistFirstID</Value>
</Value>
<Value name="13">
<Value>OperAssistFirst</Value>
</Value>
<Value name="14">
<Value>OperAssistSecondID</Value>
</Value>
<Value name="15">
<Value>OperAssistSecond</Value>
</Value>
<Value name="16">
<Value>AnaDoctorID</Value>
</Value>
<Value name="17">
<Value>AnaDoctor</Value>
</Value>
<Value name="18">
<Value>AnaMethod</Value>
</Value>
<Value name="19">
<Value>BodsDesc</Value>
</Value>
<Value name="20">
<Value>OperPosition</Value>
</Value>
<Value name="21">
<Value>OperLocID</Value>
</Value>
<Value name="22">
<Value>OperLoc</Value>
</Value>
<Value name="23">
<Value>CreateDate</Value>
</Value>
<Value name="24">
<Value>CreateTime</Value>
</Value>
<Value name="25">
<Value>IsActive</Value>
</Value>
<Value name="26">
<Value>OperAppLocID</Value>
</Value>
<Value name="27">
<Value>OperAppLoc</Value>
</Value>
<Value name="28">
<Value>OperPreopDiagID</Value>
</Value>
<Value name="29">
<Value>OperPreopDiag</Value>
</Value>
<Value name="30">
<Value>OperDiagMemo</Value>
</Value>
<Value name="31">
<Value>OperCirculation</Value>
</Value>
<Value name="32">
<Value>OperUseSelfBlood</Value>
</Value>
<Value name="33">
<Value>OperBloodType</Value>
</Value>
<Value name="34">
<Value>OperRhBloodType</Value>
</Value>
<Value name="35">
<Value>OperHBsAg</Value>
</Value>
<Value name="36">
<Value>OperHCVAb</Value>
</Value>
<Value name="37">
<Value>OperHivAb</Value>
</Value>
<Value name="38">
<Value>OperTPAb</Value>
</Value>
<Value name="39">
<Value>OperOther</Value>
</Value>
<Value name="40">
<Value>AnaStartDate</Value>
</Value>
<Value name="41">
<Value>AnaStartTime</Value>
</Value>
<Value name="42">
<Value>AnaEndDate</Value>
</Value>
<Value name="43">
<Value>AnaEndTime</Value>
</Value>
<Value name="44">
<Value>OperRoomID</Value>
</Value>
<Value name="45">
<Value>OperRoom</Value>
</Value>
<Value name="46">
<Value>OperOrdNo</Value>
</Value>
<Value name="47">
<Value>OperArrangeDate</Value>
</Value>
<Value name="48">
<Value>OperArrangeTime</Value>
</Value>
<Value name="49">
<Value>InRoomDate</Value>
</Value>
<Value name="50">
<Value>InRoomTime</Value>
</Value>
<Value name="51">
<Value>LeaveRoomDate</Value>
</Value>
<Value name="52">
<Value>LeaveRoomTime</Value>
</Value>
<Value name="53">
<Value>ScrubNurFirstID</Value>
</Value>
<Value name="54">
<Value>ScrubNurFirst</Value>
</Value>
<Value name="55">
<Value>ScrubNurSecondID</Value>
</Value>
<Value name="56">
<Value>ScrubNurSecond</Value>
</Value>
<Value name="57">
<Value>ScrubNurThirdID</Value>
</Value>
<Value name="58">
<Value>ScrubNurThird</Value>
</Value>
<Value name="59">
<Value>CirculNurFirstID</Value>
</Value>
<Value name="60">
<Value>CirculNurFirst</Value>
</Value>
<Value name="61">
<Value>CirculNurSecondID</Value>
</Value>
<Value name="62">
<Value>CirculNurSecond</Value>
</Value>
<Value name="63">
<Value>CirculNurThirdID</Value>
</Value>
<Value name="64">
<Value>CirculNurThird</Value>
</Value>
<Value name="65">
<Value>BodsDescID</Value>
</Value>
<Value name="66">
<Value>OperPositionID</Value>
</Value>
<Value name="67">
<Value>AnaMethodID</Value>
</Value>
<Value name="68">
<Value>OperPAStatus</Value>
</Value>
<Value name="69">
<Value>OperAssistThirdID</Value>
</Value>
<Value name="70">
<Value>OperAssistThird</Value>
</Value>
<Value name="71">
<Value>AuxAnesthesiaDoc</Value>
</Value>
<Value name="72">
<Value>BleedBlood</Value>
</Value>
<Value name="73">
<Value>SuspenRed</Value>
</Value>
<Value name="74">
<Value>Plasma</Value>
</Value>
<Value name="75">
<Value>AnesthesiaGrad</Value>
</Value>
<Value name="76">
<Value>OperPreopDiagICD</Value>
</Value>
<Value name="77">
<Value>OperPostDiagId</Value>
</Value>
<Value name="78">
<Value>OperPostDiag</Value>
</Value>
<Value name="79">
<Value>TechnicianOneId</Value>
</Value>
<Value name="80">
<Value>TechnicianOneDes</Value>
</Value>
<Value name="81">
<Value>TechnicianTwoId</Value>
</Value>
<Value name="82">
<Value>TechnicianTwoDes</Value>
</Value>
<Value name="83">
<Value>ANAOPSurgeonDR2</Value>
</Value>
<Value name="84">
<Value>ANAOPSurgeonCode2</Value>
</Value>
<Value name="85">
<Value>ANAOPSurgeon2</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.OperationD</DataLocation>
<DefaultData>OperationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.Events.OperationD</IdLocation>
<IndexLocation>^DHCEMRI.Events.OperationI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.OperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
