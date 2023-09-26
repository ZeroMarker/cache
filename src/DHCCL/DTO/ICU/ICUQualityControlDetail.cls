/// 重症病人质控指标详细信息
Class DHCCL.DTO.ICU.ICUQualityControlDetail Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// A0001	唯一键
Property Id As %String;

/// A0002	数据源唯一键	转科表唯一键或者重症系统唯一键（多次转入ICU有多条）		
Property IcuaId As %String;

Property AdmId As %String;

Property PapmiId As %String;

Property PatName As %String;

Property MedcareNo As %String;

Property RegNo As %String;

Property BedCode As %String;

Property Age As %String;

Property Sex As %String;

Property PAAdmReasonDesc As %String;

Property DischDate As %String;

Property HospDesc As %String;

Property CurLocDesc As %String;

Property CurWardDesc As %String;

Property ICUAResidentCtcpDesc As %String;

Property InWardDate As %String;

Property InWardTime As %String;

Property OutWardDate As %String;

Property OutWardTime As %String;

Property ICUALeaveConditionDesc As %String;

Property InWardDays As %String;

Property InWardHours As %String;

Property TransferLocDesc As %String;

Property IfDanger As %String;

Property IfSerious As %String;

Property IfRescue As %String;

Property TransferICUTimes As %String;

Property ReturnICUHours As %String;

Property InvasiveVentilatorDays As %String;

Property NoninvasiveVentilatorDays As %String;

Property VentilatorDays As %String;

Property VentilatorTimes As %String;

Property CVTubuDays As %String;

Property CVTubuTimes As %String;

Property UrinaryTubeDays As %String;

Property UrinaryTubeTimes As %String;

Property IfUseAntibiotics As %String;

Property UseAntibiotics As %String;

Property IfUseAntibioticsPrevent As %String;

Property UseAntibioticsPreventDays As %String;

Property IfUseAntibioticsCure As %String;

Property UseAntibioticsDays As %String;

Property TracheaInOutTubeTimes As %String;

Property ApacheIIScore As %String;

Property AntibioticsSpecimenTest As %String;

Property ApacheIIScoreMoreThan15 As %String;

Property SepticShock3hBundle As %String;

Property SepticShock6hBundle As %String;

Property SepticShock As %String;

Property DVTPrevention As %String;

Property DeathProbability As %String;

Property StandardizedDeath As %String;

Property NonePlanTracheaCannula As %String;

Property TracheaCannula48hReIntubation As %String;

Property TracheaCannulaReIntubationDuration As %String;

Property NonePlanTransferICU As %String;

Property TranferOutAndReturnIn48h As %String;

Property VAP As %String;

Property CRBSI As %String;

Property CAUTI As %String;

Property SepticShock1hBundle As %String;

}
