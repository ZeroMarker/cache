Class web.DHCRisInstallComponent Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// do ##class(web.DHCRisInstallComponent).GetRISComponent()
ClassMethod GetRISComponent()
{
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisWorkBenchEx","C:\")
    kill
    d ##Class(web.Util.UtilService).GetExportComponents("DHCRisAppFieldContent","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisAppFieldMatch","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisApplicationField","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisApplicationShape","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisAppointmentLoc","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisBookedEx","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisBookedItem","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisBookTime","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisCancelBooked","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisClinicSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisItemCatAppSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisItemMastAppSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisItemSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisLocationSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisLocParam","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisLocRoomSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisMedium","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisMemoSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisMemoTemplate","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisNumberCreatRule","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisOrdAppSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisOrdCatAppSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisOrditemBodyPart","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisPatRegisterEx","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisPostureSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisReportSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisResApptSchdule","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisResSchduleDetail","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisRoomEquipment","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisServerSet","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisStudyNoCreatRule","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisSystemParam","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisUnRegisterPatient","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisUseMethod","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisWardNurseQuery","C:\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisResPlan","C:\")
	kill
}

// d ##Class(web.Util.UtilService).PutComponent("d:\ris\DHCRisExamSortGroup.xml")

// DHCRisOrdBodyPart   DHCRisOrdBodyPartSerGroup  DHCRisUnRegisterPatient

// d ##Class(web.Util.UtilService).PutComponent("d:\ris\DHCRisUnRegisterPatient.xml")

// d ##Class(web.Util.UtilService).PutComponent("d:\ris\DHCRisOrdBodyPart.xml")

// d ##Class(web.Util.UtilService).PutComponent("d:\ris\DHCRisOrdBodyPartSerGroup.xml")

/// do ##class(web.DHCRisInstallComponent).getExamGroupComponent()
ClassMethod getExamGroupComponent()
{
	
	kill
    d ##Class(web.Util.UtilService).GetExportComponents("DHCRisExamGroupSet","C:\123\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisExamGroupItemSet","C:\123\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisExamSortPropertySet","C:\123\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisExamRejectItemSet","C:\123\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisExamPrepositionItemSet","C:\123\")
	kill
	d ##Class(web.Util.UtilService).GetExportComponents("DHCRisExamSortGroup","C:\123\")
}

}
