Class CIS.OPApp.DTO.OP.Registration Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLTYPE = "Model";

Parameter XMLNAME = "Registration";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 外部ID
Property ExternalID As %String;

/// 内部ID
Property RowId As %String;

/// 申请表ID
Property ApplicationID As %String;

/// 旧版申请表ID（5.0以前的手术申请）
Property OldID As %String;

/// 患者
Property Patient As CIS.OPApp.DTO.HIS.Person;

/// 就诊
Property Admission As CIS.OPApp.DTO.HIS.Admission;

/// 手术预约状态
Property StatusCode As %String;

/// 手术预约状态描述
Property StatusDesc As %String;

/// 手术预约类型: B,E,D
Property SourceType As %String(TRUNCATE = 1);

/// 手术预约类型描述: B 择期, E 急诊, D 日间
Property SourceTypeDesc As %String(TRUNCATE = 1);

/// 日间手术：Y 是，N 否
Property DaySurgery As %String(TRUNCATE = 1);

/// 手术类型: OOP,IOP,DOP
Property SurgeryType As %String(TRUNCATE = 1);

/// 手术类型描述: 门诊手术,住院手术,科内手术
Property SurgeryTypeDesc As %String(TRUNCATE = 1);

/// 手术申请科室Id
Property ApplyDepartmentID As %String(TRUNCATE = 1);

/// 手术申请科室
Property ApplyDepartment As %String(TRUNCATE = 1);

/// 手术申请日期
Property ApplyDate As %String(TRUNCATE = 1);

/// 手术日期
Property OperDate As %String(TRUNCATE = 1);

/// 手术时间
Property OperTime As %String(TRUNCATE = 1);

/// 手术室Id
Property OperatingDepartmentID As %String(TRUNCATE = 1);

/// 手术室
Property OperatingDepartment As %String(TRUNCATE = 1);

/// 麻醉科Id
Property AnaDepartmentID As %String(TRUNCATE = 1);

/// 麻醉科
Property AnaDepartment As %String(TRUNCATE = 1);

/// 麻醉方法ID（实施麻醉）
Property AnaMethodID As %String(TRUNCATE = 1);

/// 麻醉方法（实施麻醉）
Property AnaMethod As %String(TRUNCATE = 1);

/// 麻醉方法国家标准码（实施麻醉）
Property AnaMethodStandardCode As %String(TRUNCATE = 1);

/// 术前诊断ID
Property PreviousDiagnosisID As %String(TRUNCATE = 1);

/// 术前诊断
Property PreviousDiagnosis As %String(TRUNCATE = 1);

/// 术后诊断ID
Property PostDiagnosisID As %String(TRUNCATE = 1);

/// 术后诊断
Property PostDiagnosis As %String(TRUNCATE = 1);

/// 拟施手术
Property PlanOperations As list Of CIS.OPApp.DTO.OP.Operation;

/// 实施手术
Property ActualOperations As list Of CIS.OPApp.DTO.OP.Operation;

/// 手术体位ID
Property OperPositionID As %String;

/// 手术体位
Property OperPosition As %String;

/// 非计划重返手术
Property UnplannedReentry As %String(TRUNCATE = 1);

/// 参观者
Property Visitor As %String(TRUNCATE = 1);

/// 手术间ID
Property OperRoomID As %String;

/// 手术间
Property OperRoom As %String;

/// 手术台次
Property OperSeq As %String;

/// 器械护士
Property ScrubNurses As list Of CIS.OPApp.DTO.Base.CareProvider;

/// 巡回护士
Property CirculatingNurses As list Of CIS.OPApp.DTO.Base.CareProvider;

/// 麻醉医生
Property Anaesthetist As CIS.OPApp.DTO.Base.CareProvider;

/// 麻醉指导
Property AnaDirector As CIS.OPApp.DTO.Base.CareProvider;

/// 麻醉助手
Property AnaAssistants As list Of CIS.OPApp.DTO.Base.CareProvider;

/// 入手术室
Property AreaIn As CIS.OPApp.DTO.OP.KeyTime;

/// 入手术间
Property RoomIn As CIS.OPApp.DTO.OP.KeyTime;

/// 麻醉开始
Property AnaStart As CIS.OPApp.DTO.OP.KeyTime;

/// 插管
Property TubeIn As CIS.OPApp.DTO.OP.KeyTime;

/// 手术开始
Property OperStart As CIS.OPApp.DTO.OP.KeyTime;

/// 手术结束
Property OperEnd As CIS.OPApp.DTO.OP.KeyTime;

/// 拔管
Property TubeOut As CIS.OPApp.DTO.OP.KeyTime;

/// 麻醉结束
Property AnaEnd As CIS.OPApp.DTO.OP.KeyTime;

/// 出手术间
Property RoomOut As CIS.OPApp.DTO.OP.KeyTime;

/// 入恢复室
Property PACUIn As CIS.OPApp.DTO.OP.KeyTime;

/// 出恢复室
Property PACUOut As CIS.OPApp.DTO.OP.KeyTime;

/// 出手术室
Property AreaOut As CIS.OPApp.DTO.OP.KeyTime;

/// 手术执行闭环流程
Property Procedures As list Of CIS.OPApp.DTO.OP.Procedure;

/// 手术交接班信息
Property Shifts As list Of CIS.OPApp.DTO.OP.Shift;

/// 提交日期
Property SubmitDate As %String(TRUNCATE = 1);

/// 提交用户ID
Property SubmitUserID As %String(TRUNCATE = 1);

/// 提交用户
Property SubmitUser As %String(TRUNCATE = 1);

Method Validate(ByRef message As %String) As %Boolean
{
	set valid=1
	
	if ##this.ApplicationID=""
	{
		set valid=0,message="ApplicationID can not be null!"
	}
	elseif ##this.OperRoomID=""
	{
		set valid=0,message="OperRoomID can not be null!"
	}
	
	quit valid
}

}
