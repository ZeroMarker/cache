/// 名称:DtPortal.OD.OD14NotOnTimeDoctors
/// 描述:查询门诊未准时出诊的医生信息
/// 编写者:DanPJ
/// 编写日期:2020-12-02
Class DtPortal.OD.OD14NotOnTimeDoctors Extends %RegisteredObject [ ProcedureBlock ]
{

/// OD14.01.01	查询门诊科室未准时出诊的医生数量(根据医生第一个到达患者的时间)
/// DanPJ 2020-12-02
/// 输出字段:ID、医生工号、医生姓名、科室ID、科室描述、就诊时段ID、就诊时段描述、第一个到达患者的就诊号、第一个到达患者的到达时间、时段开始时间
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD14NotOnTimeDoctors","OD140101","2020-12-03","2020-12-03","")
Query OD140101(StartDate As %String = "", EndDate As %String = "", HospitalId As %String = "", ifOPEPConf As %String = "") As DtPortal.Query(ROWSPEC = "ind,SSUSRInitials,SSUSRName,SSUserSexDesc,QueDepDr,CTLocDesc,RegfeeTimeRangeDr,TRDesc,QuePaadmDr,QSTime,TRStartTime,RegfeeRoomDesc") [ SqlProc ]
{
}

ClassMethod OD140101Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HospitalId As %String = "", ifOPEPConf As %String = "") As %Status
{
	set repid=$I(^||CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	kill ^TEMPDHCPOROD($j,"QueLocDocId")
	if ((StartDate="")||(EndDate=""))  set StartDate=+$H,EndDate=+$H
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	//根据队列表DHCQueue,获取各个门诊科室医生的第一个点击到达的患者的时间
	//^User.DHCQueueI("QueDateDeptIndex",QueDate,QueDepDr,ID)
	for QueDate=StartDate:1:EndDate {
		set QueDepDr=""
		for {
			set QueDepDr=$o(^User.DHCQueueI("QueDateDeptIndex",QueDate,QueDepDr))
			quit:QueDepDr=""
			
			if ((ifOPEPConf'="")){
			if (ifOPEPConf'["E"){
				set ifEm=##class(DtPortal.Common.PublicService).ifEmDept(QueDepDr)
				continue:ifEm=1
			}
			
		}
			
			set CTLocDesc=$P($G(^CTLOC(QueDepDr)),"^",2)									//医生所在科室
			
			set CTLOCHospitalDR=$P($G(^CTLOC(QueDepDr)),"^",22)								//科室所属院区
			continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))
			set QueId=""
			for {
				set QueId=$o(^User.DHCQueueI("QueDateDeptIndex",QueDate,QueDepDr,QueId))
				quit:QueId=""
				
				//^User.DHCQueueD(ID)=$LB(%%CLASSNAME,QueCompDr,QueDate,QueDepDr,QueDocDr,QueExabDr,QueFirstDr,QueMarkDr,QueName,QueNo
				//,QuePaadmDr,QuePersonId,QueRoomDr,QueStateDr,Operuserid,QueCalled,QueStateTime,QueConsultFlag,QueStateDate,QueTime
				//,QueStatusDate,QueStatusTime,ChangeDepDr,Comm1,Comm2,QueIsBloodColl,QueBloodCollCalled,QueBCCalled)	
				set QueStateDr=$list(^User.DHCQueueD(QueId),14)									//获取排队状态
				continue:QueStateDr=""
				//^User.DHCPerStateD(ID)=$LB(%%CLASSNAME,PersCode,PersMemo,PersName,PersTem)
				set PersName=$list(^User.DHCPerStateD(QueStateDr),4)
				//continue:((PersName'="到达")&&(PersName'="等候"))
				continue:(PersName'="到达")
				
				set QueDocDr=$list(^User.DHCQueueD(QueId),5)									//获取排队医生
				continue:QueDocDr=""
				
				continue:$d(^DHCPOROD($j,"QueLocDocId",QueDepDr,QueDocDr))						//已经存在的医生就退出，只取第一个到达状态的
				
				//获取医生在SS_User表中的附加信息
				//^SSU("SSUSR",0,"CTPCP",{SSUSR_CareProv_DR},{SSUSR_RowId})
				set SSUSRRowId=$o(^SSU("SSUSR",0,"CTPCP",QueDocDr,""))							//SS_User表中的ID
				continue:SSUSRRowId=""
				//^SSU("SSUSR",{SSUSR_RowId})
				set SSUserCardId=$p($G(^SSU("SSUSR",SSUSRRowId)),"^",122)						//医生身份证ID
				//性别默认为空，只有维护了才显示具体维护的性别信息
				set SSUserSexDesc=""
				set SSUserSexId=$p($G(^SSU("SSUSR",SSUSRRowId)),"^",123)						//医生性别ID
				//^CT("SEX",{CTSEX_RowId})
				set:SSUserSexId'="" SSUserSexDesc=$P($G(^CT("SEX",SSUserSexId)),"^",2)				//医生性别描述
				set SSUSRInitials=$P($G(^SSU("SSUSR",SSUSRRowId)),"^",1)						//医生工号
				set SSUSRName=$P($G(^SSU("SSUSR",SSUSRRowId)),"^",2)							//医生姓名
				
					
				
				
				//获取DHCQueueStatus表中的最后一个状态的时间，既为到达时间
				//^DHCQueueStatus({QS_ParRef},{QS_ChildSub})
				set QSChildSub=$o(^DHCQueueStatus(QueId,""),-1)
				set QSDate=$P($g(^DHCQueueStatus(QueId,QSChildSub)),"^",1)						//到达日期
				continue:QSDate'=QueDate
				
				set QSTime=$P($g(^DHCQueueStatus(QueId,QSChildSub)),"^",2)						//到达时间
				
				set QuePaadmDr=$list(^User.DHCQueueD(QueId),11)									//就诊号
				continue:QuePaadmDr=""
			
				//^User.DHCRegistrationFeeD(ID)=$LB(%%CLASSNAME,RegfeeAdmDr,RegfeeArcDr,RegfeeArcPrice,RegfeeBespFlag,RegfeeDoFlag
				//,RegfeeName,RegfeeNo,RegfeeLookPrice,RegfeePrint,Regfeetemp1,Regfeetemp2,RegfeeDepDr,RegfeeDocDr,RegfeeDate,RegfeeTime
				//,RegfeeUserDr,RegfeeRBASDr,RegfeeSessionTypeDr,RegfeeRoomDr,RegfeeTimeRangeDr,RegTransferFlag,RegTransferReDoc
				//,RegfeeInsuAdmDr,RegfeeInsuCash,RegfeeInsuCount,RegfeeInsuFund,RegfeeInsuOverallPlanning,RegfeeInsuOther,RegfeeInsuCoDR
				//,RegfeeInsuCoProDR,RegfeeInsuCoPatPay,RegfeePrintUserDR,RegfeePrintDate,RegfeePrintTime,RegfeeInvReportDR
				//,RegfeeHandinUserDR,RegfeeHandinDate,RegfeeHandinTime,RegfeeMethodSeqNo,RegfeeTransactionId)
				//^User.DHCRegistrationFeeI("ADM",RegfeeAdmDr,ID)
				set DHCRegFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_QuePaadmDr,""))				//挂号表
				continue:DHCRegFeeId=""
			
				set RegfeeTimeRangeDr=$list(^User.DHCRegistrationFeeD(DHCRegFeeId),21)				//就诊时段		
				continue:RegfeeTimeRangeDr=""
				
				set RegfeeRoomDesc=""
				set RegfeeRoomDr=$list(^User.DHCRegistrationFeeD(DHCRegFeeId),20)					//诊室DR
				set:RegfeeRoomDr'="" RegfeeRoomDesc=$P($G(^CTLOC(RegfeeRoomDr)),"^",2) 				//诊室描述
				
				//^DHCTimeRange({TR_Rowid})
				set TRStartTime=$P($G(^DHCTimeRange(RegfeeTimeRangeDr)),"^",3)						//就诊开始时间
				continue:'(QSTime>TRStartTime)														//过滤准时开诊的医生
				set TRDesc=$P($G(^DHCTimeRange(RegfeeTimeRangeDr)),"^",2)							//时段描述
				//w QueId_"^"_QuePaadmDr_"^"_PersName_"^"_$zt(QSTime,1)_"^"_RegfeeTimeRangeDr_"^"_$zt(TRStartTime,1),!
				set ^TEMPDHCPOROD($j,"QueLocDocId",QueDepDr,QueDocDr)=QueId_"^"_QuePaadmDr_"^"_PersName_"^"_$zt(QSTime,1)_"^"_RegfeeTimeRangeDr_"^"_$zt(TRStartTime,1)								//保存门诊科室医生所有到达患者的数据
				set ^||CacheTemp(repid,ind)=$lb(ind,SSUSRInitials,SSUSRName,SSUserSexDesc,QueDepDr,CTLocDesc,RegfeeTimeRangeDr,TRDesc,QuePaadmDr,$zt(QSTime,1),$zt(TRStartTime,1),RegfeeRoomDesc)
				set ind=ind+1
			}	
		}	
	}
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

}
