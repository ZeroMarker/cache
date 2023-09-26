Class CHSS.PersonYearCheckHBV Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = HBVRecordRowId, SqlTableName = PersonYearCheckHBV ]
{

/// 随访记录
Property YearCheckRowIdParref As CHSS.PersonYearCheckRecord [ Required ];

/// 目前肝脏大小
Property CurSizeOfLiver As CHSS.DictLiverSize;

/// 目前肝脏硬度
Property CurRigidityOfLiver As CHSS.DictLiverRigidity;

/// 目前脾脏大小
Property CurSizeOfSpleen As CHSS.DictLiverSize;

/// 目前脾脏硬度
Property CurRigidityOfSpleen As CHSS.DictLiverRigidity;

/// 目前肝功能
Property CurLiverFunction As CHSS.DictLiverFunction;

/// 目前肝功能异常情况指标
/// CurALT
Property CurALT As %String(MAXLEN = 10, TRUNCATE = 1);

/// CurAST
Property CurAST As %String(MAXLEN = 10, TRUNCATE = 1);

/// CurALB
Property CurALB As %String(MAXLEN = 10, TRUNCATE = 1);

/// CurGLOB
Property CurGLOB As %String(MAXLEN = 10, TRUNCATE = 1);

/// CurAG
Property CurAG As %String(MAXLEN = 10, TRUNCATE = 1);

/// CurTB
Property CurTB As %String(MAXLEN = 10, TRUNCATE = 1);

/// CurDB
Property CurDB As %String(MAXLEN = 10, TRUNCATE = 1);

/// 乙肝标志物指标
/// HbsAg
Property HbsAg As CHSS.DictHBVTag;

/// HbsAb
Property HbsAb As CHSS.DictHBVTag;

/// HbeAg
Property HbeAg As CHSS.DictHBVTag;

/// HBeAb
Property HBeAb As CHSS.DictHBVTag;

/// HbcAb
Property HbcAb As CHSS.DictHBVTag;

/// HBV-DNA定量
/// Property HBVDNA As %Float;
/// AFP
Property AFP As %Float;

/// 肝脏大小
Property SizeOfLiver As CHSS.DictLiverSize;

/// 肝脏形态
Property ShapeOfLiver As CHSS.DictLiverShape;

/// 肝脏包膜
Property EnvelopeOfLiver As CHSS.DictLiverEnvelope;

/// 肝脏回声
Property EchoOfLiver As CHSS.DictLiverEcho;

/// 肝脏结节
Property NoduleOfLiver As CHSS.DictLiverNodule;

/// 肝脏门静脉
Property PortalOfLiver As CHSS.DictLiverPortal;

/// 肝脏门静脉增宽
Property WidthOfLiverPortal As %String(MAXLEN = 10, TRUNCATE = 1);

/// 脾脏大小
Property SizeOfSpleen As CHSS.DictLiverSize;

/// 脾脏形态
Property ShapeOfSpleen As CHSS.DictLiverShape;

/// 脾脏厚度
Property DepthOfSpleen As CHSS.DictSpleenDepth;

/// 脾脏结节
Property NoduleOfSpleen As CHSS.DictLiverNodule;

/// 脾静脉
Property SplenicVein As CHSS.DictLiverPortal;

/// 脾静脉增宽
Property WidthOfSplenicVein As %String(MAXLEN = 10, TRUNCATE = 1);

/// B超结论
Property LiverBUS As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现在的症状
Property CurStatusValue As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现在的体征
Property PhysicalSignValue As %String(MAXLEN = 100, TRUNCATE = 1);

/// 胆囊大小
Property GallSize As CHSS.DictLiverSize;

/// 胆囊厚度
Property DepthOfGall As CHSS.DictSpleenDepth;

/// 胆囊结石
Property GallStone As %String(MAXLEN = 5, TRUNCATE = 1);

/// 肝脾其他
Property LiverPortalOther As %String(MAXLEN = 50, TRUNCATE = 1);

///  其他药物
///  Property OtherDrug As %String(MAXLEN = 60);
///  其他药物剂量
///  Property OtherDrugDosage As %String(MAXLEN = 30);
///  其他药物开始时间
///  Property DateOfOtherDrugStart As %Date;
Index YearCheckRowIdParrefIndex On YearCheckRowIdParref [ Unique ];

Storage Default
{
<Data name="PersonYearCheckHBVDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AFP</Value>
</Value>
<Value name="3">
<Value>CurLiverFunction</Value>
</Value>
<Value name="4">
<Value>CurLiverFunctionInfo</Value>
</Value>
<Value name="5">
<Value>CurRigidityOfSpleen</Value>
</Value>
<Value name="6">
<Value>CurSizeOfLiver</Value>
</Value>
<Value name="7">
<Value>CurSizeOfSpleen</Value>
</Value>
<Value name="8">
<Value>CurcRigidityOfLiver</Value>
</Value>
<Value name="9">
<Value>DateOfOtherDrugStart</Value>
</Value>
<Value name="10">
<Value>DepthOfSpleen</Value>
</Value>
<Value name="11">
<Value>EchoOfLiver</Value>
</Value>
<Value name="12">
<Value>EnvelopeOfLiver</Value>
</Value>
<Value name="13">
<Value>HBVDNA</Value>
</Value>
<Value name="14">
<Value>HBVM</Value>
</Value>
<Value name="15">
<Value>HBVRecordRowId</Value>
</Value>
<Value name="16">
<Value>LiverBUS</Value>
</Value>
<Value name="17">
<Value>NoduleOfLiver</Value>
</Value>
<Value name="18">
<Value>NoduleOfSpleen</Value>
</Value>
<Value name="19">
<Value>OtherDrug</Value>
</Value>
<Value name="20">
<Value>OtherDrugDosage</Value>
</Value>
<Value name="21">
<Value>PortalOfLiver</Value>
</Value>
<Value name="22">
<Value>ShapeOfLiver</Value>
</Value>
<Value name="23">
<Value>ShapeOfSpleen</Value>
</Value>
<Value name="24">
<Value>SizeOfLiver</Value>
</Value>
<Value name="25">
<Value>SizeOfSpleen</Value>
</Value>
<Value name="26">
<Value>SplenicVein</Value>
</Value>
<Value name="27">
<Value>UseInjector</Value>
</Value>
<Value name="28">
<Value>YearCheckRowIdParref</Value>
</Value>
<Value name="29">
<Value>bIVDrug</Value>
</Value>
<Value name="30">
<Value>bNotOneTIme</Value>
</Value>
<Value name="31">
<Value>bUseOneInjector</Value>
</Value>
<Value name="32">
<Value>CurRigidityOfLiver</Value>
</Value>
<Value name="33">
<Value>AG</Value>
</Value>
<Value name="34">
<Value>ALB</Value>
</Value>
<Value name="35">
<Value>ALT</Value>
</Value>
<Value name="36">
<Value>AST</Value>
</Value>
<Value name="37">
<Value>DB</Value>
</Value>
<Value name="38">
<Value>GLOB</Value>
</Value>
<Value name="39">
<Value>HBeAb</Value>
</Value>
<Value name="40">
<Value>HbcAb</Value>
</Value>
<Value name="41">
<Value>HbeAg</Value>
</Value>
<Value name="42">
<Value>HbsAb</Value>
</Value>
<Value name="43">
<Value>HbsAg</Value>
</Value>
<Value name="44">
<Value>TB</Value>
</Value>
<Value name="45">
<Value>CurAG</Value>
</Value>
<Value name="46">
<Value>CurALB</Value>
</Value>
<Value name="47">
<Value>CurALT</Value>
</Value>
<Value name="48">
<Value>CurAST</Value>
</Value>
<Value name="49">
<Value>CurDB</Value>
</Value>
<Value name="50">
<Value>CurGLOB</Value>
</Value>
<Value name="51">
<Value>CurTB</Value>
</Value>
<Value name="52">
<Value>WidthOfLiverPortal</Value>
</Value>
<Value name="53">
<Value>WidthOfSplenicVein</Value>
</Value>
<Value name="54">
<Value>PStatusValue</Value>
</Value>
<Value name="55">
<Value>StatusValue</Value>
</Value>
<Value name="56">
<Value>CurStatusValue</Value>
</Value>
<Value name="57">
<Value>PhysicalSignValue</Value>
</Value>
<Value name="58">
<Value>DepthOfGall</Value>
</Value>
<Value name="59">
<Value>GallSize</Value>
</Value>
<Value name="60">
<Value>GallStone</Value>
</Value>
<Value name="61">
<Value>LiverPortalOther</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonYearCheckHBVD</DataLocation>
<DefaultData>PersonYearCheckHBVDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonYearCheckHBVD</IdLocation>
<IndexLocation>^CHSS.PersonYearCheckHBVI</IndexLocation>
<StreamLocation>^CHSS.PersonYearCheckHBVS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
