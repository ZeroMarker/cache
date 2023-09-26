/// 麻醉质控统计病人详细信息
Class DHCCL.DTO.AN.AnaQualityControlDetail Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property PatName As %String;

Property PatGender As %String;

Property PatAge As %String;

Property PatDeptDesc As %String;

Property PatientID As %String;

Property BloodType As %String;

Property EpisodeID As %String;

Property OPSID As %String;

Property AdmReason As %String;

Property OperDate As %String;

Property OperTime As %String;

Property SourceTypeDesc As %String;

Property TheatreInDate As %String;

Property TheatreInTime As %String;

Property OperRoom As %String;

Property AnaMethodDesc As %String;

Property OperDesc As %String;

Property SurgeonDesc As %String;

Property IfInPACU As %String;

Property PACUInDate As %String;

Property PACUInTime As %String;

Property PACUOutDate As %String;

Property PACUOutTime As %String;

Property PACUDuration As %String;

Property PACUFirstTemperature As %String;

Property ApneaInOper As %String;

Property CardiacArrestAfterAnaest24Hour As %String;

Property NonePlanArtificialAirway As %String;

Property NonePlanTransferToICU As %String;

Property NonePlanReTubeIn As %String;

Property HeatPreservationInOper As %String;

Property InRoomAndOperCancel As %String;

Property AnaStartAndOperCancel As %String;

Property DeathAfterAnaest24Hour As %String;

Property DeathIn24HourForAnaest As %String;

Property SevereAllergicReaction As %String;

Property SevereRegionBlockAnaest As %String;

Property ComplicatOfSpinalAnaest As %String;

Property IntubeOuttubeHoarseness As %String;

Property SevereCentralVenipuncture As %String;

Property PostAnaestComa As %String;

Property AwarenessInGeneralAnest As %String;

Property ToothDamageInOper As %String;

Property ConsciousnessDisorder As %String;

Property SPO2LowInOper As %String;

Property UseAwakeningDrug As %String;

Property RespiratoryBlock As %String;

Property CardiopulmonaryResume As %String;

Property CardiopulmonaryResumeSuccess As %String;

Property QualityControlUpdateDT As %String;

Property QualityControlUpdateDuration As %String;

Property DischDate As %String;

Property AttendingDoctor As %String;

Property HospitalDesc As %String;

Property AnaesthesiaID As %String;

}
