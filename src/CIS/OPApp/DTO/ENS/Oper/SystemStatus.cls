Class CIS.OPApp.DTO.ENS.Oper.SystemStatus Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLTYPE = "SystemStatus";

Parameter XMLNAME = "SystemStatus";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 手术ID（手术申请表主索引）
Property ExamID As %String;

/// 物理位置？
Property Position As %String;

/// 手术申请医嘱ID 或者 手术申请表主索引
Property OEOrdItemID As %String;

/// 备注
Property Notes As %String;

/// 状态更新日期时间
Property UpDateTime As %String;

/// 状态代码
/// CISANAP:日间手术申请 , CISANCAP:取消日间手术申请 , CISANAE:麻醉评估 , CISANCM:日间确认 , CISANA:手术排班
/// CISANCA:取消手术排班 , CISANWO:出病区 , CISANAI:入手术室 , CISANRI:入手术间 , CISANANS:麻醉开始
/// CISANOPS:手术开始 , CISANOPF:手术结束 , CISANANF:麻醉结束 , CISANRO:出手术间 , CISANPO:出PACU
/// CISANPI:入PACU , CISANAO:出手术室 , CISANWI:入病区 , CISANDA:出院评估 , CISANFU:随访
/// CISANAR:麻醉安排 , CISANCAR:取消麻醉安排
Property Status As %String;

/// 状态更新用户ID
Property UserID As %String;

/// 状态更新用户
Property UserName As %String;

/// 数据源系统标识，麻醉为AN
Property SourceSystem As %String;

ClassMethod CloneFromProcedure(procedure As CIS.OPApp.DTO.OP.Procedure) As CIS.OPApp.DTO.ENS.Oper.SystemStatus
{
	set instance=##class(CIS.OPApp.DTO.ENS.Oper.SystemStatus).%New()
	
	set instance.ExamID=procedure.ApplicationID
	set instance.Status=..TransformStatus(procedure.Code)
	set instance.UpDateTime=procedure.Date_" "_procedure.Time
	set instance.Notes=procedure.Note
	set instance.UserID=procedure.UserID
	set instance.UserName=procedure.User
	set instance.SourceSystem="AN"
	
	quit instance
}

/// OPA:手术安排,RA:排班撤回,ANA:麻醉安排,WO:离开病区,AI:入手术室
/// RI:入手术间,ANS:麻醉开始,OPS:手术开始,OPF:手术结束,ANF:麻醉结束
/// RO:离手术间,PI:入PACU,PO:离PACU,AO:离手术室,FNH:手术完成
/// DAT:日间手术确认
ClassMethod Match(procedure As CIS.OPApp.DTO.OP.Procedure) As %Boolean
{
	set list = $LISTFROMSTRING("OPA,RA,ANA,WO,AI,RI,ANS,OPS,OPF,ANF,RO,PI,PO,AO",",")
	
	if (procedure.Code'="")&&($LISTFIND(list,procedure.Code)) quit 1
	
	quit 0
}

/// CISANAP:日间手术申请 , CISANCAP:取消日间手术申请 , CISANAE:麻醉评估 , CISANCM:日间确认 , CISANA:手术排班
/// CISANCA:取消手术排班 , CISANWO:出病区 , CISANAI:入手术室 , CISANRI:入手术间 , CISANANS:麻醉开始
/// CISANOPS:手术开始 , CISANOPF:手术结束 , CISANANF:麻醉结束 , CISANRO:出手术间 , CISANPO:出PACU
/// CISANPI:入PACU , CISANAO:出手术室 , CISANWI:入病区 , CISANDA:出院评估 , CISANFU:随访
/// CISANAR:麻醉安排 , CISANCAR:取消麻醉安排
ClassMethod TransformStatus(code As %String) As %String
{
	set result=$case(code,
					"OPA":"CISANA","RA":"CISANCA","ANA":"CISANAR","WO":"CISANWO","AI":"CISANAI",
					"RI":"CISANRI","ANS":"CISANANS","OPS":"CISANOPS","OPF":"CISANOPF","RO":"CISANRO",
					"PI":"CISANPI","PO":"CISANPO","AO":"CISANAO","ANF":"CISANANF")
	quit result
}

Method Validate(ByRef message As %String) As %Boolean
{
	set valid=1
	
	if ##this.ExamID=""
	{
		set valid=0,message="ExamID can not be null!"
	}
	elseif ##this.Status=""
	{
		set valid=0,message="Status can not be null!"
	}
	
	quit valid
}

}
