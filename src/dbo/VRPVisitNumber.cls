Class dbo.VRPVisitNumber [ ClassType = view, CompileAfter = (dbo.RPVisitNumber, dbo.RPVisitNumberReport, dbo.BTAdmissionType, dbo.BTCertType, dbo.BTPaymentType, dbo.BTEthnicity, dbo.BTClinicalConditions, dbo.BTSpecies, dbo.BTAgeUnit, dbo.BTLocation, dbo.BTDoctor, dbo.BTWard, dbo.BTABOBG, dbo.BTRHBG, dbo.BTAnatomicalSite, dbo.BTSpecimen, dbo.BTContainer, dbo.BTSpecimenQuality, dbo.BTWorkGroupMachine, dbo.SYSUser), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_RP_VisitNumber, ViewQuery = { 
SELECT     dbo.RP_VisitNumber.RowID, dbo.RP_VisitNumber.VisitNumber, dbo.RP_VisitNumber.RegNo, dbo.RP_VisitNumber.AdmissionTypeDR, 
                      dbo.RP_VisitNumber.AdmNo, dbo.RP_VisitNumber.MedicalRecordNo, dbo.RP_VisitNumber.AdmDate, dbo.RP_VisitNumber.AdmTime, 
                      dbo.RP_VisitNumber.CertTypeDR, dbo.RP_VisitNumber.CertNo, dbo.RP_VisitNumber.IDNumber, dbo.RP_VisitNumber.PaymentTypeDR, 
                      dbo.RP_VisitNumber.SurName, dbo.RP_VisitNumber.GivenName, dbo.RP_VisitNumber.SpeciesDR, dbo.RP_VisitNumber.BirthDate, 
                      dbo.RP_VisitNumber.BirthTime, dbo.RP_VisitNumber.Age, dbo.RP_VisitNumber.AgeUnitDR, dbo.RP_VisitNumber.EthnicityDR, 
                      dbo.RP_VisitNumber.HospitalDR, dbo.RP_VisitNumber.LocationDR, dbo.RP_VisitNumber.DoctorDR, dbo.RP_VisitNumber.RequestDate, 
                      dbo.RP_VisitNumber.RequestTime, dbo.RP_VisitNumber.WardDR, dbo.RP_VisitNumber.BedNo, dbo.RP_VisitNumber.Symptom, 
                      dbo.RP_VisitNumber.MobileNo, dbo.RP_VisitNumber.PhoneNo, dbo.RP_VisitNumber.EMail, dbo.RP_VisitNumber.Height, dbo.RP_VisitNumber.Weight, 
                      dbo.RP_VisitNumber.BloodPressure, dbo.RP_VisitNumber.ClinicalConditionsDR, dbo.RP_VisitNumber.LMPDate, dbo.RP_VisitNumber.Pregnant, 
                      dbo.RP_VisitNumber.PregnantWeeks, dbo.RP_VisitNumber.AboDR, dbo.RP_VisitNumber.RhDR, dbo.RP_VisitNumber.Address, 
                      dbo.RP_VisitNumber.PostCode, dbo.RP_VisitNumber.InfectFlag, dbo.RP_VisitNumber.InfectAlert, dbo.RP_VisitNumber.SpecialFlag, 
                      dbo.RP_VisitNumber.PregnantNum, dbo.RP_VisitNumber.ChildbirthNum, dbo.RP_VisitNumber.ReqNotes, dbo.RP_VisitNumber.RequestNo, 
                      dbo.RP_VisitNumber.Urgent, dbo.RP_VisitNumber.CollectDate, dbo.RP_VisitNumber.CollectTime, dbo.RP_VisitNumber.CollectUserDR, 
                      dbo.RP_VisitNumber.AnatomicalSiteDR, dbo.RP_VisitNumber.CollectPositon, dbo.RP_VisitNumber.SpecimenDR, dbo.RP_VisitNumber.ContainerDR, 
                      dbo.RP_VisitNumber.CollectNotes, dbo.RP_VisitNumber.H24UVolume, dbo.RP_VisitNumber.H24UTimePeriod, dbo.RP_VisitNumber.BodyTemp, 
                      dbo.RP_VisitNumber.Confidential, dbo.RP_VisitNumber.CarryDate, dbo.RP_VisitNumber.CarryTime, dbo.RP_VisitNumber.CarryUserDR, 
                      dbo.RP_VisitNumber.ReceiveDate, dbo.RP_VisitNumber.ReceiveTime, dbo.RP_VisitNumber.ReceiveUserDR, 
                      dbo.RP_VisitNumber.SpecimenQualityDR, dbo.RP_VisitNumber.ReceiveNotes, dbo.RP_VisitNumber.InStorageDate, 
                      dbo.RP_VisitNumber.InStorageTime, dbo.RP_VisitNumber.InStorageUserDR, dbo.RP_VisitNumber.OutStorageDate, 
                      dbo.RP_VisitNumber.OutStorageTime, dbo.RP_VisitNumber.OutStorageUserDR, dbo.RP_VisitNumber.OutStorageType, 
                      dbo.RP_VisitNumber.ReceiveHospitalDR, dbo.RP_VisitNumber.AddDate, dbo.RP_VisitNumber.AddTime, dbo.RP_VisitNumber.AddUserDR, 
                      dbo.RP_VisitNumberReport.VisitNumberDR, dbo.RP_VisitNumberReport.TransmitDate, dbo.RP_VisitNumberReport.WorkGroupMachineDR, 
                      dbo.RP_VisitNumberReport.OrderNo, dbo.RP_VisitNumberReport.AssayNo, dbo.RP_VisitNumberReport.AccessionNo, 
                      dbo.RP_VisitNumberReport.EpisodeNo, dbo.RP_VisitNumberReport.AcceptDate, dbo.RP_VisitNumberReport.AcceptTime, 
                      dbo.RP_VisitNumberReport.UploadDate, dbo.RP_VisitNumberReport.AcceptUserDR, dbo.RP_VisitNumberReport.UploadTime, 
                      dbo.RP_VisitNumberReport.AssayDate, dbo.RP_VisitNumberReport.AssayTime, dbo.RP_VisitNumberReport.EntryDate, 
                      dbo.RP_VisitNumberReport.EntryUserDR, dbo.RP_VisitNumberReport.EntryTime, dbo.RP_VisitNumberReport.AuthDate, 
                      dbo.RP_VisitNumberReport.AuthTime, dbo.RP_VisitNumberReport.AuthUserDR, dbo.RP_VisitNumberReport.Status, 
                      dbo.RP_VisitNumberReport.ReAuthDate, dbo.RP_VisitNumberReport.ReAuthTime, dbo.RP_VisitNumberReport.ReAuthUserDR, 
                      dbo.RP_VisitNumberReport.AutoAuth, dbo.RP_VisitNumberReport.DigitSign, dbo.RP_VisitNumberReport.DigitSignString, 
                      dbo.RP_VisitNumberReport.DigitSignTime, dbo.RP_VisitNumberReport.Printed, dbo.RP_VisitNumberReport.Readed, 
                      dbo.RP_VisitNumberReport.FirstReadDate, dbo.RP_VisitNumberReport.FirstReadTime, dbo.RP_VisitNumberReport.FirstReadDoctorDR, 
                      dbo.RP_VisitNumberReport.ReportClass, dbo.RP_VisitNumberReport.DiscardDate, dbo.RP_VisitNumberReport.DiscardTime, 
                      dbo.RP_VisitNumberReport.DiscardUserDR, dbo.RP_VisitNumberReport.DisCardNotes, dbo.RP_VisitNumberReport.MajorConclusion, 
                      dbo.RP_VisitNumberReport.MinorConclusion, dbo.BT_AdmissionType.CName AS AdmTypeDesc, dbo.BT_CertType.CName AS CertTypeDesc, 
                      dbo.BT_PaymentType.CName AS PaymentTypeDesc, dbo.BT_ClinicalConditions.CName AS ClinicalConditionsDesc, 
                      dbo.BT_Ethnicity.CName AS EthnicityDesc, dbo.BT_Species.CName AS SpeciesDesc, dbo.BT_AgeUnit.CName AS AgeUnitDesc, 
                      dbo.BT_Location.CName AS LocationDesc, dbo.BT_Doctor.CName AS DoctorDesc, dbo.BT_Ward.CName AS WardDesc, 
                      dbo.BT_ABOBG.CName AS ABODesc, dbo.BT_RHBG.CName AS RHDesc, dbo.BT_AnatomicalSite.CName AS AnatomicalSiteDesc, 
                      dbo.BT_Specimen.IName AS SpecimenDesc, dbo.BT_Container.CName AS ContainerDesc, 
                      dbo.BT_SpecimenQuality.CName AS SpecimenQualityDesc, dbo.BT_WorkGroupMachine.CName AS WorkGroupMachineDesc, 
                      a1.CName AS CollectUserDesc, a2.CName AS CarryUserDesc, a3.CName AS ReceiveUserDesc, a4.CName AS InStorageUserDesc, 
                      a5.CName AS OutStorageUserDesc, a6.CName AS AddUserDesc, b1.CName AS AcceptUserDesc, b2.CName AS EntryUserDesc, 
                      b3.CName AS AuthUserDesc, b4.CName AS ReAuthUserDesc, b5.CName AS FirstReadDoctorDesc, b6.CName AS DiscardUserDesc
					  FROM         dbo.RP_VisitNumber LEFT OUTER JOIN
                      dbo.RP_VisitNumberReport ON dbo.RP_VisitNumber.RowID = dbo.RP_VisitNumberReport.VisitNumberDR LEFT OUTER JOIN
                      dbo.BT_AdmissionType ON dbo.RP_VisitNumber.AdmissionTypeDR = dbo.BT_AdmissionType.RowID LEFT OUTER JOIN
                      dbo.BT_CertType ON dbo.RP_VisitNumber.CertTypeDR = dbo.BT_CertType.RowID LEFT OUTER JOIN
                      dbo.BT_PaymentType ON dbo.RP_VisitNumber.PaymentTypeDR = dbo.BT_PaymentType.RowID LEFT OUTER JOIN
                      dbo.BT_Ethnicity ON dbo.RP_VisitNumber.EthnicityDR = dbo.BT_Ethnicity.RowID LEFT OUTER JOIN
                      dbo.BT_ClinicalConditions ON dbo.RP_VisitNumber.ClinicalConditionsDR = dbo.BT_ClinicalConditions.RowID LEFT OUTER JOIN
                      dbo.BT_Species ON dbo.RP_VisitNumber.SpeciesDR = dbo.BT_Species.RowID LEFT OUTER JOIN
                      dbo.BT_AgeUnit ON dbo.RP_VisitNumber.AgeUnitDR = dbo.BT_AgeUnit.RowID LEFT OUTER JOIN
                      dbo.BT_Location ON dbo.RP_VisitNumber.LocationDR = dbo.BT_Location.RowID LEFT OUTER JOIN
                      dbo.BT_Doctor ON dbo.RP_VisitNumber.DoctorDR = dbo.BT_Doctor.RowID LEFT OUTER JOIN
                      dbo.BT_Ward ON dbo.RP_VisitNumber.WardDR = dbo.BT_Ward.RowID LEFT OUTER JOIN
                      dbo.BT_ABOBG ON dbo.RP_VisitNumber.AboDR = dbo.BT_ABOBG.RowID LEFT OUTER JOIN
                      dbo.BT_RHBG ON dbo.RP_VisitNumber.RhDR = dbo.BT_RHBG.RowID LEFT OUTER JOIN
                      dbo.BT_AnatomicalSite ON dbo.RP_VisitNumber.AnatomicalSiteDR = dbo.BT_AnatomicalSite.RowID LEFT OUTER JOIN
                      dbo.BT_Specimen ON dbo.RP_VisitNumber.SpecimenDR = dbo.BT_Specimen.RowID LEFT OUTER JOIN
                      dbo.BT_Container ON dbo.RP_VisitNumber.ContainerDR = dbo.BT_Container.RowID LEFT OUTER JOIN
                      dbo.BT_SpecimenQuality ON dbo.RP_VisitNumber.SpecimenQualityDR = dbo.BT_SpecimenQuality.RowID LEFT OUTER JOIN
                      dbo.BT_WorkGroupMachine ON dbo.RP_VisitNumberReport.WorkGroupMachineDR = dbo.BT_WorkGroupMachine.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS a1 ON dbo.RP_VisitNumber.CollectUserDR = a1.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS a2 ON dbo.RP_VisitNumber.CarryUserDR = a2.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS a3 ON dbo.RP_VisitNumber.ReceiveUserDR = a3.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS a4 ON dbo.RP_VisitNumber.InStorageUserDR = a4.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS a5 ON dbo.RP_VisitNumber.OutStorageUserDR = a5.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS a6 ON dbo.RP_VisitNumber.AddUserDR = a6.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS b1 ON dbo.RP_VisitNumberReport.AcceptUserDR = b1.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS b2 ON dbo.RP_VisitNumberReport.EntryUserDR = b2.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS b3 ON dbo.RP_VisitNumberReport.AuthUserDR = b3.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS b4 ON dbo.RP_VisitNumberReport.ReAuthUserDR = b4.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS b5 ON dbo.RP_VisitNumberReport.FirstReadDoctorDR = b5.RowID LEFT OUTER JOIN
                      dbo.SYS_User AS b6 ON dbo.RP_VisitNumberReport.DiscardUserDR = b6.RowID
 } ]
{

}
