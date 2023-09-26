/// 创建View的类
Class web.DHCBL.RQ.Test.CreateView Extends %RegisteredObject
{

ClassMethod CreateADMView()
{
	&sql(create view V_QAdm as 
		select PAADM_PAPMI_DR->PAPMI_Name, PAADM_RowID,
		 PAADM_ADMNo,
		  PAADM_PAPMI_DR,
		   PAADM_PatType_DR, PAADM_DepCode_DR->CTLOC_Desc,PAADM_DepCode_DR,
		    PAADM_AdmCateg_DR,
		     PAADM_AdmDate, PAADM_AdmTime,
		      PAADM_Type,
		       PAADM_AdmSrc_DR,
		        PAADM_Specialty_DR, PAADM_AdmDocCodeDR,
		         PAADM_SourceRef_DR,
		          PAADM_ExpAdmDate, PAADM_PreAdmitted,
		           PAADM_RefDocCodeDR, PAADM_DischgDate,
		            PAADM_DischgTime, PAADM_DischgDoc_DR,
		             PAADM_VisitStatus, PAADM_Dispos_DR,
		              PAADM_HCR_DR, PAADM_TrafficAccident_DR, PAADM_ShowInFutureEpisode,
		               PAADM_Confidential,
		                PAADM_ExpLOS, PAADM_DischargeAppoint_DR,
		                 PAADM_RefClinic_DR, PAADM_InPatNo,
		                  PAADM_EmergencyNo, PAADM_PreAdmNo, PAADM_ConvertedFromOut,
		                   PAADM_Priority_DR, PAADM_PreAdmitDate, PAADM_PreAdmitTime,
		                    PAADM_Isolate, PAADM_EmergencyDate, PAADM_EmergencyTime,
		                     PAADM_PaidEmergencySurcharge, PAADM_OriginalAdmissionDR,
		                      PAADM_MealPreference, PAADM_CreateDate,
		                       PAADM_CreateTime, PAADM_CreateUser->SSUSR_Name,PAADM_CreateUser, PAADM_Remark,
		                        PAADM_Current PAADM_BillFlag  
		from SQLUser.PA_Adm)
}

ClassMethod CreateSimpleADMView()
{
	
	&sql(create view V_QSimpleAdm as 
		select  PAADM_RowID,
			PAADM_ADMNo,
			PAADM_PAPMI_DR,
			PAADM_PatType_DR, PAADM_DepCode_DR,PAADM_DepCode_DR,
			PAADM_AdmCateg_DR,
			PAADM_AdmDate, PAADM_AdmTime,
			PAADM_Type,
			PAADM_AdmSrc_DR,
			PAADM_Specialty_DR, PAADM_AdmDocCodeDR,
			PAADM_SourceRef_DR,
			PAADM_ExpAdmDate, PAADM_PreAdmitted,
			PAADM_RefDocCodeDR, PAADM_DischgDate,
			PAADM_DischgTime, PAADM_DischgDoc_DR,
			PAADM_VisitStatus, PAADM_Dispos_DR,
			PAADM_HCR_DR, PAADM_TrafficAccident_DR, PAADM_ShowInFutureEpisode,
			PAADM_Confidential,
			PAADM_ExpLOS, PAADM_DischargeAppoint_DR,
			PAADM_RefClinic_DR, PAADM_InPatNo,
			PAADM_EmergencyNo, PAADM_PreAdmNo, PAADM_ConvertedFromOut,
			PAADM_Priority_DR, PAADM_PreAdmitDate, PAADM_PreAdmitTime,
			PAADM_Isolate, PAADM_EmergencyDate, PAADM_EmergencyTime,
			PAADM_PaidEmergencySurcharge, PAADM_OriginalAdmissionDR,
			PAADM_MealPreference, PAADM_CreateDate,
			PAADM_CreateTime, PAADM_CreateUser,PAADM_CreateUser, PAADM_Remark,
			PAADM_Current PAADM_BillFlag  
		from SQLUser.PA_Adm)
}

ClassMethod CreateView()
{
	;d ##class(web.DHCBL.RQ.Test.CreateView).CreateView()
	d ..CreateCTLoc()
}

ClassMethod CreateCTLoc()
{
	b	;;
	&sql(
		create view Sample.MyTestView as
			select *  from websys.Component
	)
	b
}

}
