/// 名称:DtPortal.OD.OD15MRDiagnosis
/// 描述:查询门诊诊断前十的疾病信息
/// 编写者:DanPJ
/// 编写日期:2020-12-03
Class DtPortal.OD.OD15MRDiagnosis Extends %RegisteredObject [ ProcedureBlock ]
{

/// OD15.01.01	查询门诊诊断前十的信息
/// DanPJ 2020-12-03
/// 输出字段:索引、诊断ID、诊断code、诊断描述、诊断数量
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD15MRDiagnosis","OD150101","2020-12-03","2020-12-03","")
Query OD150101(StartDate As %String = "", EndDate As %String = "", HospitalId As %String = "", ifOPEPConf As %String = "") As DtPortal.Query(ROWSPEC = "ind,MRCIDRowId,MRCode,MRDesc,MRNum") [ SqlProc ]
{
}

ClassMethod OD150101Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HospitalId As %String = "", ifOPEPConf As %String = "") As %Status
{
	set repid=$I(^||CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	kill ^DHCPOROD($j,"MRCIDNum")
	kill ^DHCPOROD($j,"IDNum")
	if ((StartDate="")||(EndDate=""))  set StartDate=+$H,EndDate=+$H
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	//^MRi("Date",{MRDIA_Date},{MR_Adm.MRADM_RowId},{MRDIA_Childsub})
	for MRDIADate=StartDate:1:EndDate {
		set MRADMRowId=""
		for {
			set MRADMRowId=$o(^MRi("Date",MRDIADate,MRADMRowId))
			quit:MRADMRowId=""
			
			set MRADMADMDR=$P($G(^MR(MRADMRowId,"PRO",1)),"^",9)				//就诊号
			continue:MRADMADMDR=""
			
			set PAADMType=$P($G(^PAADM(MRADMADMDR)),"^",2)						//就诊类型
			continue:PAADMType="I"												//过滤住院
			
			if ((ifOPEPConf'="")){
				if (ifOPEPConf'["E"){					
					continue:PAADMType="E"
				}
			}
			
			
			set PAADMDepCodeDR=$P($G(^PAADM(MRADMADMDR)),"^",4)					//获取就诊科室
			continue:PAADMDepCodeDR=""
			set CTLOCHospitalDR=$P($G(^CTLOC(PAADMDepCodeDR)),"^",22)			//科室所属院区
			continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))			//过滤院区
			
			set MRDIAChildSub=""
			for {
				set MRDIAChildSub=$o(^MRi("Date",MRDIADate,MRADMRowId,MRDIAChildSub))
				quit:MRDIAChildSub=""
				
				//^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
				set MRDIAICDCodeDR=$P($G(^MR(MRADMRowId,"DIA",MRDIAChildSub)),"^",1) 		//诊断表索引
				continue:MRDIAICDCodeDR=""
				
				//^MRC("ID",{MRCID_RowId})  MRC_ICDDx
				set MRCIDCode=$P($G(^MRC("ID",MRDIAICDCodeDR)),"^",1)						//诊断Code
				continue:MRCIDCode=""
				set MRCIDDesc=$P($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)						//诊断描述
				continue:MRCIDDesc=""
				
				set MRDIADiagStatDR=$P($G(^MR(MRADMRowId,"DIA",MRDIAChildSub)),"^",9)		//诊断状态，确诊、疑诊、确诊
				continue:MRDIADiagStatDR'="3"												//过滤非确诊的
				
				set ^DHCPOROD($j,"MRCIDNum",MRDIAICDCodeDR)=$G(^DHCPOROD($j,"MRCIDNum",MRDIAICDCodeDR))+1
			}
		}	
	}
	
	
	//对MRCID数量进行排序
	set MRCID=""
	for {
		set MRCID=$o(^DHCPOROD($j,"MRCIDNum",MRCID))
		quit:MRCID=""
		
		set MRCIDNum=$G(^DHCPOROD($j,"MRCIDNum",MRCID))
		
		set ^DHCPOROD($j,"IDNum",MRCIDNum,MRCID)=1
	}
	
	
	//输出字段
	set MRNum="",MRIndex=0
	for {
		set MRNum=$o(^DHCPOROD($j,"IDNum",MRNum),-1)
		quit:+MRNum=0
		
		set MRCIDRowId=""
		for {
			set MRCIDRowId=$o(^DHCPOROD($j,"IDNum",MRNum,MRCIDRowId))
			quit:MRCIDRowId=""
		
			set MRIndex=MRIndex+1											//计数
			quit:MRIndex>10													//只输出前十
			
			set MRCode=$P($G(^MRC("ID",MRCIDRowId)),"^",1)						//诊断code	
			set MRDesc=$P($G(^MRC("ID",MRCIDRowId)),"^",2)						//诊断描述
			//w MRCIDRowId_"^"_MRCode_"^"_MRDesc_"^"_MRNum,!
			set ^||CacheTemp(repid,ind)=$lb(ind,MRCIDRowId,MRCode,MRDesc,MRNum)
			set ind=ind+1
		}		
	}
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

/// OD15.01.02	根据诊断表ID获取一段时间内患者信息
/// DanPJ 2020-12-03
/// 输出字段:索引、姓名、性别、年龄、就诊号、费用类别、登记号、病人号、医生ID、医生、就诊时间
/// 	ind,Name,Sex,Age,AdmReason,MRADMADMDR,RegNo,PatientID,UserID,AdmDocDesc,AdmDateTime,EMRDocID,EMRInstanceID,LocID,DiagnoseDesc
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD15MRDiagnosis","OD150102","2020-12-03","2020-12-03","15699","")
Query OD150102(StartDate As %String = "", EndDate As %String = "", MRCID As %String, HospitalId As %String = "", ifOPEPConf As %String = "") As DtPortal.Query(ROWSPEC = "ind,Name,Sex,Age,MRADMADMDR,AdmReason,RegNo,PatientID,UserID,AdmDocDesc,AdmDateTime,EMRDocID,EMRInstanceID,LocID,LocDesc,DiagnoseDesc") [ SqlProc ]
{
}

ClassMethod OD150102Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", MRCID As %String, HospitalId As %String = "", ifOPEPConf As %String = "") As %Status
{
	set repid=$I(^||CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	
	quit:MRCID="" $$$OK
	if ((StartDate="")||(EndDate=""))  set StartDate=EndDate=+$H
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)

	//^MRi("Date",{MRDIA_Date},{MR_Adm.MRADM_RowId},{MRDIA_Childsub})
	for MRDIADate=StartDate:1:EndDate {
		set MRADMRowId=""
		for {
			set MRADMRowId=$o(^MRi("Date",MRDIADate,MRADMRowId))
			quit:MRADMRowId=""
			
			set MRADMADMDR=$P($G(^MR(MRADMRowId,"PRO",1)),"^",9)				//就诊号
			continue:MRADMADMDR=""
			
			set PAADMType=$P($G(^PAADM(+MRADMADMDR)),"^",2)						//就诊类型
			continue:PAADMType="I"												//过滤住院
			
			if ((ifOPEPConf'="")){
				if (ifOPEPConf'["E"){					
					continue:PAADMType="E"
				}
			}

			set PAADMDepCodeDR=$P($G(^PAADM(+MRADMADMDR)),"^",4)				//获取就诊科室
			continue:PAADMDepCodeDR=""
			set CTLOCHospitalDR=$P($G(^CTLOC(PAADMDepCodeDR)),"^",22)			//科室所属院区
			continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))			//过滤院区
			
			set MRDIAChildSub=""
			for {
				set MRDIAChildSub=$o(^MRi("Date",MRDIADate,MRADMRowId,MRDIAChildSub))
				quit:MRDIAChildSub=""
				
				//^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
				set MRDIAICDCodeDR=$P($G(^MR(MRADMRowId,"DIA",MRDIAChildSub)),"^",1) 		//诊断表索引
				continue:MRDIAICDCodeDR=""
				
				continue:MRDIAICDCodeDR'=MRCID												//过滤诊断ID
				
				//^MRC("ID",{MRCID_RowId})  MRC_ICDDx
				set MRCIDCode=$P($G(^MRC("ID",MRDIAICDCodeDR)),"^",1)						//诊断Code
				continue:MRCIDCode=""
				set MRCIDDesc=$P($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)						//诊断描述
				continue:MRCIDDesc=""
				
				set MRDIADiagStatDR=$P($G(^MR(MRADMRowId,"DIA",MRDIAChildSub)),"^",9)		//诊断状态，确诊、疑诊、确诊
				continue:MRDIADiagStatDR'="3"												//过滤非确诊的
				
				set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(+MRADMADMDR)
				set Name=$p(PatInfo,"^",2)											//姓名
				set Sex=$p(PatInfo,"^",3)											//性别
				set Age=$p(PatInfo,"^",4)											//年龄
				set AdmReason=$p(PatInfo,"^",6)										//费用类别
				set RegNo=$p(PatInfo,"^",7)    										//登记号
 				set AdmDocDesc=$p(PatInfo,"^",11)									//主管医生
				set DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(+MRADMADMDR)			//诊断
				set AdmDate=$P($G(^PAADM(+MRADMADMDR)),"^",6)						//就诊日期
				set AdmTime=$P($G(^PAADM(+MRADMADMDR)),"^",7)						//就诊时间
				set AdmDateTime=$zd(AdmDate,3)_"&nbsp;"_$zt(AdmTime,2)
					
				//获取打开电子病历所需要的参数
				set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(+MRADMADMDR)
				set EMRDocID=$p(EMRinfo,"^",1)
				set EMRInstanceID=$p(EMRinfo,"^",2)
				set LocID=$p(EMRinfo,"^",3)
				set PatientID=$p(EMRinfo,"^",4)
				set EMREpisodeID=$p(EMRinfo,"^",5)	
				set CPDocID=$p($g(^PAADM(+MRADMADMDR)),"^",9)     //主管医生
				set:CPDocID'="" UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
				set LocDesc=$P($G(^CTLOC(LocID)),"^",2)	
				set ^||CacheTemp(repid,ind)=$lb(ind,Name,Sex,Age,MRADMADMDR,AdmReason,RegNo,PatientID,UserID,AdmDocDesc,AdmDateTime,EMRDocID,EMRInstanceID,LocID,LocDesc,DiagnoseDesc)
				set ind=ind+1	
			}
		}
	}
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

}
