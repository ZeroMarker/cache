Class web.DHCLabPortal Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：      wwh
/// CreatDate：    2014-10-08
/// Description:   发布报告
/// Table：        无
/// Input：        tsRowID:检验医嘱RowID,error:错误信息
/// Output：       无
/// Return：       0=失败,1=成功
/// Others：       无
/// ##Class(web.DHCLabPortal).PublishReport(tsRowID)
ClassMethod PublishReport(VisitNumberReportDR As %String, ByRef error As %String = "") As %Boolean
{
	S VisitNumberReportDR=$G(VisitNumberReportDR),error=""
	I '$L(VisitNumberReportDR) {
		S error="参数错误,检验报告RowID错误"
		Q 0	
	}
	s ReportStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)  ///审核状态
	
	I ReportStatus'="3" {
		S error="检验报告"_VisitNumberReportDR_"未审核"
		Q 0	
	}
	
	s reportDate=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),19)
	s reportTime=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),20)
	i $l(reportDate) s reportDate=$e(reportDate,1,4)_"-"_$e(reportDate,5,6)_"-"_$e(reportDate,7,8)
	i $l(reportDate) s reportDate=$zdh(reportDate,3)

	s AuthUserDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),21)
	s reportUserID=$lg($g(^dbo.SYSUserD(AuthUserDR)),2)
	I $L(reportUserID) {
		S reportUserDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(reportUserID,"U"),""))
		I $L(reportUserDr) {
			S reportUserID=$P($G(^SSU("SSUSR",reportUserDr)),"^",1)
		} ELSE {
			S reportUserID=""	
		}
	}
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
	s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)	
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),4)
	s TestSetDR="" 
	f {
    	s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexWGMachineDR",VisitNumberDR,WorkGroupMachineDR,TestSetDR)) 
		q:TestSetDR=""
		s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexWGMachineDR",VisitNumberDR,WorkGroupMachineDR,TestSetDR,""))
		s orderRowID=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),10)
		i '$l(orderRowID) s error="医嘱RowID为空" q
		s orderID=$p(orderRowID,"||",1), orderSubID=$p(orderRowID,"||",2)
		S admID=$P($G(^OEORD(orderID)),"^",1)
		I '$L(admID) {
			S error="就诊号为空"
		}
		S patMastRowID=$P($G(^PAADM(admID)),"^",1)
		I '$L(patMastRowID) {
			S error="病人信息错误"
			Q
		}

		S patientID=$P($G(^PAPER(patMastRowID,"PAT",1)),"^",1)
		S patName=$P($G(^PAPER(patMastRowID,"ALL")),"^",1)
		S patSexID=$P($G(^PAPER(patMastRowID,"ALL")),"^",7)
		S patSex=""
		S:$L(patSexID) patSex=$P($G(^CT("SEX",patSexID)),"^",2)
		S birthday=$P($G(^PAPER(patMastRowID,"ALL")),"^",6)
	
		S attendingDoctorDr=$P($G(^PAADM(admID)),"^",9),attendingDoctorID=""
	   	S:$L(attendingDoctorDr) attendingDoctorID=$P($G(^SSU("SSUSR",attendingDoctorDr)),"^",1)
	   	S requestDoctorDr=$P($G(^OEORD(orderID,"I",orderSubID,7)),"^",1),requestDoctorID=""
		S:$L(requestDoctorDr) requestDoctorID=$P($G(^SSU("SSUSR",requestDoctorDr)),"^",1)
	   	S requestDate=$P($G(^OEORD(orderID,"I",orderSubID,1)),"^",9)
	   	S requestTime=$P($G(^OEORD(orderID,"I",orderSubID,1)),"^",10)
		S orderItemRowID=$P($G(^OEORD(orderID,"I",orderSubID,1)),"^",2)
	
		S isModify="N"
		I $D(^DHCRBCLINICCHECKRPTINFOi("STUDYNO",1,Labno)) {
			S isModify="Y"
		}
	
		S reportURL=""_"PatientID="_patientID_"&VisitNumberReportDR="_VisitNumberReportDR_"&OrderID="_orderRowID

		S portalInfo="",deli="^",index=0
		S index=index+1,$P(portalInfo,deli,index)=patMastRowID		//01,病人ID
		S index=index+1,$P(portalInfo,deli,index)=patName			//02,病人姓名
		S index=index+1,$P(portalInfo,deli,index)=patSex			//03,性别
		S index=index+1,$P(portalInfo,deli,index)=birthday			//04,生日
		S index=index+1,$P(portalInfo,deli,index)=orderItemRowID	//05,检查项目
		S index=index+1,$P(portalInfo,deli,index)=attendingDoctorID	//06,主治医生
		S index=index+1,$P(portalInfo,deli,index)=requestDoctorID	//07,申请医生
		S index=index+1,$P(portalInfo,deli,index)="1"				//08,检查类型
		S index=index+1,$P(portalInfo,deli,index)=Labno				//09,检查号
		S index=index+1,$P(portalInfo,deli,index)=requestDate		//10,医嘱日期
		S index=index+1,$P(portalInfo,deli,index)=requestTime		//11,医嘱时间
		S index=index+1,$P(portalInfo,deli,index)=reportDate		//12,报告日期
		S index=index+1,$P(portalInfo,deli,index)=reportTime		//13,报告时间
		S index=index+1,$P(portalInfo,deli,index)=reportUserID		//14,检查医生
		S index=index+1,$P(portalInfo,deli,index)=reportURL			//15,报告内容
		S index=index+1,$P(portalInfo,deli,index)=orderRowID		//16,医嘱rowid
		S index=index+1,$P(portalInfo,deli,index)=isModify			//17,报告是否修改
		S ret=##Class(RISService.ReadReportInfo).SetPortalRPTInfo(portalInfo)
		i $e(ret)'=1 {
			S error=$p(ret,"^",2)
			q
		}
	} 
	i $l(error) q 0
	Q 1
}

/// Creator：      wwh
/// CreatDate：    2014-10-08
/// Description:   发布报告
/// Table：        无
/// Input：        tsRowID:检验医嘱RowID,error:错误信息
/// Output：       无
/// Return：       0=失败,1=成功
/// Others：       无
/// ##Class(web.DHCLabPortal).PublishReport(tsRowID)
ClassMethod PublishReportOld(tsRowID As %String, ByRef error As %String = "") As %Boolean
{
	S tsRowID=$G(tsRowID),error=""
	S labno=$P(tsRowID,"||",1)
	I '$L(labno) {
		S error="参数错误,检验医嘱RowID错误"
		Q 0	
	}
	S tsCode=$P(tsRowID,"||",2)
	I '$L(tsCode) {
		S error="参数错误,检验医嘱RowID"_tsRowID_"错误"
		Q 0	
	}
	S tsCnt=$P(tsRowID,"||",3)
	I '$L(tsCnt) {
		S error="参数错误,检验医嘱RowID"_tsRowID_"错误"
		Q 0	
	}
	
	S labdata=""
	S config=##Class(websys.Configuration).%OpenId(1)
	S:$L(config) labdata=config.LabDataNamespace
	S:'$L(labdata) labdata="labdata"
	I '$D(^|labdata|TEPI(labno,1,tsCode,tsCnt)) {
		S error="参数错误,检验医嘱RowID"_tsRowID_"错误,未找到数据"
		Q 0	
	}
	
	S reportStatusID=$P($G(^|labdata|TEPI(labno,1,tsCode,tsCnt)),"\",31)
	I reportStatusID'="A" {
		S error="检验报告"_tsRowID_"未审核"
		Q 0	
	}
	S reportDate=+$P($G(^|labdata|TEPI(labno,1,tsCode,tsCnt)),"\",4)
	S reportTime=+$P($G(^|labdata|TEPI(labno,1,tsCode,tsCnt)),"\",5)*60
	S reportUserID=$P($G(^|labdata|TEPI(labno,1,tsCode,tsCnt)),"\",6)
	I $L(reportUserID) {
		S reportUserDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(reportUserID,"U"),""))
		I $L(reportUserDr) {
			S reportUserID=$P($G(^SSU("SSUSR",reportUserDr)),"^",1)
		} ELSE {
			S reportUserID=""	
		}
	}
	S orderID=$O(^OEORD(0,"EpisNo",labno,""))
	I '$L(orderID) {
		S error="参数错误,检验医嘱RowID"_tsRowID_"错误,未找到关联的HIS医嘱"
		Q 0	
	}
	s orderSubID=$o(^OEORDi(0,"LabTS",orderID,tsRowID,""))
	I '$L(orderSubID) {
		S error="参数错误,检验医嘱RowID"_tsRowID_"错误,未找到关联的HIS医嘱"
		Q 0	
	}
	S orderRowID=orderID_"||"_orderSubID
	
	S admID=$P($G(^OEORD(orderID)),"^",1)
	I '$L(admID) {
		S error="就诊号为空"
		Q 0	
	}
	S patMastRowID=$P($G(^PAADM(admID)),"^",1)
	I '$L(patMastRowID) {
		S error="病人信息错误"
		Q 0	
	}
	S patientID=$P($G(^PAPER(patMastRowID,"PAT",1)),"^",1)
	S patName=$P($G(^PAPER(patMastRowID,"ALL")),"^",1)
	S patSexID=$P($G(^PAPER(patMastRowID,"ALL")),"^",7)
	S patSex=""
	S:$L(patSexID) patSex=$P($G(^CT("SEX",patSexID)),"^",2)
	S birthday=$P($G(^PAPER(patMastRowID,"ALL")),"^",6)
	
	S attendingDoctorDr=$P($G(^PAADM(admID)),"^",9),attendingDoctorID=""
   	S:$L(attendingDoctorDr) attendingDoctorID=$P($G(^SSU("SSUSR",attendingDoctorDr)),"^",1)
   	S requestDoctorDr=$P($G(^OEORD(orderID,"I",orderSubID,7)),"^",1),requestDoctorID=""
	S:$L(requestDoctorDr) requestDoctorID=$P($G(^SSU("SSUSR",requestDoctorDr)),"^",1)
   	S requestDate=$P($G(^OEORD(orderID,"I",orderSubID,1)),"^",9)
   	S requestTime=$P($G(^OEORD(orderID,"I",orderSubID,1)),"^",10)
	S orderItemRowID=$P($G(^OEORD(orderID,"I",orderSubID,1)),"^",2)
	
	S isModify="N"
	I $D(^DHCRBCLINICCHECKRPTINFOi("STUDYNO",1,tsRowID)) {
		S isModify="Y"
	}
	
	S reportURL=""_"PatientID="_patientID_"&TestSetRow="_tsRowID_"&OrderID="_orderRowID

	S portalInfo="",deli="^",index=0
	S index=index+1,$P(portalInfo,deli,index)=patMastRowID		//01,病人ID
	S index=index+1,$P(portalInfo,deli,index)=patName			//02,病人姓名
	S index=index+1,$P(portalInfo,deli,index)=patSex			//03,性别
	S index=index+1,$P(portalInfo,deli,index)=birthday			//04,生日
	S index=index+1,$P(portalInfo,deli,index)=orderItemRowID	//05,检查项目
	S index=index+1,$P(portalInfo,deli,index)=attendingDoctorID	//06,主治医生
	S index=index+1,$P(portalInfo,deli,index)=requestDoctorID	//07,申请医生
	S index=index+1,$P(portalInfo,deli,index)="1"				//08,检查类型
	S index=index+1,$P(portalInfo,deli,index)=tsRowID			//09,检查号
	S index=index+1,$P(portalInfo,deli,index)=requestDate		//10,医嘱日期
	S index=index+1,$P(portalInfo,deli,index)=requestTime		//11,医嘱时间
	S index=index+1,$P(portalInfo,deli,index)=reportDate		//12,报告日期
	S index=index+1,$P(portalInfo,deli,index)=reportTime		//13,报告时间
	S index=index+1,$P(portalInfo,deli,index)=reportUserID		//14,检查医生
	S index=index+1,$P(portalInfo,deli,index)=reportURL			//15,报告内容
	S index=index+1,$P(portalInfo,deli,index)=orderRowID		//16,医嘱rowid
	S index=index+1,$P(portalInfo,deli,index)=isModify			//17,报告是否修改
	S ret=##Class(RISService.ReadReportInfo).SetPortalRPTInfo(portalInfo)
	i $e(ret)'=1 {
		S error=$p(ret,"^",2)
		q 0
	}
	Q 1
}

/// Creator：      wwh
/// CreatDate：    2014-10-08
/// Description:   阅读记录
/// Table：        无
/// Input：        orderRowID:医嘱RowID,userID:阅读用户,error:错误信息
/// Output：       无
/// Return：       0=失败,1=成功
/// Others：       无
/// ##Class(web.DHCLabPortal).ReadingLog(orderRowID,userID)
ClassMethod ReadingLog(orderRowIDs As %String, userID As %String, ByRef error As %String = "") As %Boolean
{
	S orderRowIDs=$G(orderRowIDs),userID=$G(userID),error=""
	s ret=0
	f i=1:1:$l(orderRowIDs,",") d
	.s orderRowID=$p(orderRowIDs,",",i)
	.i '$l(orderRowID) q
	.s ret=##Class(web.DHCLabPortal).SaveReadingLog(orderRowID,userID,.error)
	q ret
}

/// Creator：      liuzf
/// CreatDate：    2015-01-26
/// Description:   保存阅读记录
/// Table：        无
/// Input：        orderRowID:医嘱RowID,userID:阅读用户,error:错误信息
/// Output：       无
/// Return：       0=失败,1=成功
/// Others：       无
ClassMethod SaveReadingLog(orderRowID As %String, userID As %String, ByRef error As %String = "") As %Boolean
{
	S orderID=$P(orderRowID,"||",1)
	S orderSubID=$P(orderRowID,"||",2)
	I ('$L(orderID))||('$L(orderSubID)) {
		S error="医嘱RowID"_orderRowID_"错误"
		Q 0
	}
	I '$L(userID) {
		S error="用户代码为空"
		Q 0	
	}
	I '$D(^OEORD(orderID,"I",orderSubID)) {
		S error="医嘱RowID"_orderRowID_"错误"
		Q 0
	}
	S VisitNumberTestSetDR=$P($G(^OEORD(orderID,"I",orderSubID,3)),"^",35)
	I '$L(VisitNumberTestSetDR) {
		S error="检验报告RowID为空"
		Q 0	
	}	
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	i '$l(WorkGroupMachineDR) S error="检验报告RowID为空" Q 0
	s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
	i '$l(OrderNo) S error="检验报告RowID为空" Q 0
	s VisitNumberReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""))
	i '$l(VisitNumberReportDR) S error="检验报告RowID为空" Q 0

	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
	s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)	

	I '$D(^DHCRBCLINICCHECKRPTINFOi("STUDYNO",1,Labno)) {
		S error="检验报告尚未发布"
		Q 0
	}
	S admID=$P($G(^OEORD(orderID)),"^",1)
	I '$L(admID) {
		S error="就诊号为空"
		Q 0	
	}
	S attendingDoctorDr=$P($G(^PAADM(admID)),"^",9),attendingDoctorID=""
   	S:$L(attendingDoctorDr) attendingDoctorID=$P($G(^SSU("SSUSR",attendingDoctorDr)),"^",1)
   	
	S requestDoctorDr=$P($G(^OEORD(orderID,"I",orderSubID,7)),"^",1),requestDoctorID=""
	S:$L(requestDoctorDr) requestDoctorID=$P($G(^SSU("SSUSR",requestDoctorDr)),"^",1)
	
	/*
	I userID'=requestDoctorID,userID'=attendingDoctorID {
		S error="阅读用户"_userID_"不是申请医师或者主治医师"
		Q 0	
	}
	*/
	S ret=##class(RISService.ReadReportInfo).SetPortalRPTCheckedByOEORowid(orderRowID,Labno,userID,"Y")
	i $e(ret)'=1 {
		S error=$p(ret,"^",2)
		q 0
	}
	Q 1
}

/// Creator：      liuzf
/// CreatDate：    2015-01-26
/// Description:   保存阅读记录
/// Table：        无
/// Input：        orderRowID:医嘱RowID,userID:阅读用户,error:错误信息
/// Output：       无
/// Return：       0=失败,1=成功
/// Others：       无
ClassMethod SaveReadingLogOLD(orderRowID As %String, userID As %String, ByRef error As %String = "") As %Boolean
{
	S orderID=$P(orderRowID,"||",1)
	S orderSubID=$P(orderRowID,"||",2)
	I ('$L(orderID))||('$L(orderSubID)) {
		S error="医嘱RowID"_orderRowID_"错误"
		Q 0
	}
	I '$L(userID) {
		S error="用户代码为空"
		Q 0	
	}
	I '$D(^OEORD(orderID,"I",orderSubID)) {
		S error="医嘱RowID"_orderRowID_"错误"
		Q 0
	}
	S tsRowID=$P($G(^OEORD(orderID,"I",orderSubID,3)),"^",35)
	I '$L(tsRowID) {
		S error="检验报告RowID为空"
		Q 0	
	}	
	 
	I '$D(^DHCRBCLINICCHECKRPTINFOi("STUDYNO",1,tsRowID)) {
		S error="检验报告尚未发布"
		Q 0
	}
	
	S admID=$P($G(^OEORD(orderID)),"^",1)
	I '$L(admID) {
		S error="就诊号为空"
		Q 0	
	}
	S attendingDoctorDr=$P($G(^PAADM(admID)),"^",9),attendingDoctorID=""
   	S:$L(attendingDoctorDr) attendingDoctorID=$P($G(^SSU("SSUSR",attendingDoctorDr)),"^",1)
   	
	S requestDoctorDr=$P($G(^OEORD(orderID,"I",orderSubID,7)),"^",1),requestDoctorID=""
	S:$L(requestDoctorDr) requestDoctorID=$P($G(^SSU("SSUSR",requestDoctorDr)),"^",1)
	
	/*
	I userID'=requestDoctorID,userID'=attendingDoctorID {
		S error="阅读用户"_userID_"不是申请医师或者主治医师"
		Q 0	
	}
	*/
	S ret=##class(RISService.ReadReportInfo).SetPortalRPTCheckedByOEORowid(orderRowID,tsRowID,userID,"Y")
	b
	i $e(ret)'=1 {
		S error=$p(ret,"^",2)
		q 0
	}
	Q 1
}

/// Creator：      wwh
/// CreatDate：    2014-10-08
/// Description:   是否已读
/// Table：        无
/// Input：        orderRowID:医嘱RowID,userID:阅读用户,error:错误信息
/// Output：       无
/// Return：       0=失败,1=成功
/// Others：       无
/// ##Class(web.DHCLabPortal).IsRead(orderRowID,userID)
ClassMethod IsRead(orderRowID As %String, userID As %String, ByRef error As %String = "") As %Boolean
{
	S orderRowID=$G(orderRowID),userID=$G(userID),error=""
	 
	S orderID=$P(orderRowID,"||",1)
	S orderSubID=$P(orderRowID,"||",2)
	I ('$L(orderID))||('$L(orderSubID)) {
		S error="医嘱RowID"_orderRowID_"错误"
		Q 0
	}
	
	S VisitNumberTestSetDR=$P($G(^OEORD(orderID,"I",orderSubID,3)),"^",35)
	I '$L(VisitNumberTestSetDR) {
		S error="检验报告RowID为空"
		Q 0	
	}
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	i '$l(WorkGroupMachineDR) S error="检验报告RowID为空" Q 0
	s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
	i '$l(OrderNo) S error="检验报告RowID为空" Q 0
	s VisitNumberReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""))
	i '$l(VisitNumberReportDR) S error="检验报告RowID为空" Q 0
	S logRowID=$O(^DHCRBCLINICCHECKRPTINFOi("STUDYNO",1,VisitNumberReportDR,""))
	I '$L(logRowID) {
		S error="检验报告尚未发布"
		Q 0
	}
	S returnStatus=##Class(RISService.ReadReportInfo).GetRPTCMStatus(orderRowID,VisitNumberReportDR,userID)
	S readStatus=$P(returnStatus,"^",1)    	//阅读状态
	S modifyStatus=$P(returnStatus,"^",2)	//修改状态
	b //1
	Q:readStatus="Y" 1
	I '$L(userID) {
		S isReadAT=$P(^DHCRBCLINICCHECKRPTINFO(logRowID),"^",8)  	//主治医师阅读状态
		S isReadAP=$P(^DHCRBCLINICCHECKRPTINFO(logRowID),"^",12)	//申请医师阅读状态
		I (isReadAT="Y")||(isReadAP="Y") {
			Q 1	
		}
	}
	Q 0
}

/// Creator：      wwh
/// CreatDate：    2014-10-08
/// Description:   是否已修改
/// Table：        无
/// Input：        orderRowID:医嘱RowID,userID:阅读用户,error:错误信息
/// Output：       无
/// Return：       0=失败,1=成功
/// Others：       无
/// ##Class(web.DHCLabPortal).IsModify(orderRowID,userID)
ClassMethod IsModify(orderRowID As %String, userID As %String, ByRef error As %String = "") As %Boolean
{
	S orderRowID=$G(orderRowID),userID=$G(userID),error=""
	S orderID=$P(orderRowID,"||",1)
	S orderSubID=$P(orderRowID,"||",2)
	I ('$L(orderID))||('$L(orderSubID)) {
		S error="医嘱RowID"_orderRowID_"错误"
		Q 0
	}
	S tsRowID=$P($G(^OEORD(orderID,"I",orderSubID,3)),"^",35)
	I '$L(tsRowID) {
		S error="检验报告RowID为空"
		Q 0	
	}
	
	S logRowID=$O(^DHCRBCLINICCHECKRPTINFOi("STUDYNO",1,tsRowID,""))
	I '$L(logRowID) {
		S error="检验报告尚未发布"
		Q 0
	}
	
	S isModifyAT=$P(^DHCRBCLINICCHECKRPTINFO(logRowID),"^",23)  	//主治医师修改状态
	S isModifyAP=$P(^DHCRBCLINICCHECKRPTINFO(logRowID),"^",24)		//申请医师修改状态
	I (isModifyAT="Y")||(isModifyAP="Y") {
		Q 1	
	}
	Q 0
}

}
