Import sqluser

/// wfg
/// 2019-6-19
/// transop表
Class web.CSSDHUI.Trans.TransOP Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 根据条码获取到患者相关信息信息
/// wfg
/// 2019-6-19
/// 使用	
/// 使用患者ID号  
/// 患者姓名
/// 手术医生   
/// 器械护士
/// 巡回护士   
/// 手术时间 
/// 手术室 
/// 手术房间号  
/// 使用科室   
/// 感染名称 
/// label 外标签(具体标签)
/// w ##class(web.CSSDHUI.Trans.TransOP).GetPkgUseInfo("002010001000001")
ClassMethod GetPkgUseInfo(label As %String) As %String
{
    n (label)
    s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
    s RtnDataStr="^^^^^^^^^"
	s RtnTitleStr="patientId^patientName^oprDoctorName^instNurseName^circNurseName^oprDt^oprRoom^oprRoomNo^useDept^infectName"
	s RtnStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(RtnDataStr,RtnTitleStr)
    q:label="" RtnStr
    s opid = $o(^User.CSSDTransOPI("CSSDTOPLabelIndex",label,""))
    q:opid="" RtnStr
    s transOp=##Class(User.CSSDTransOP).%OpenId(opid)
    s (paadm,patientId,useDept,patientName,oprDoctorName,instNurseName,circNurseName,oprRoom,oprRoomNo,infectName)=""
    s paadm=transOp.CSSDTOPPationtDR
    s patientId=paadm.%Id()
    s admLocId=$p($g(^PAADM(patientId)),"^",4) 
    s useDept=..sssLocDesc(admLocId)  ;患者所在科室
    s papmi=paadm.PAADMPAPMIDR
    s patientName=papmi.PAPMIName
    s oprDoctor=transOp.CSSDTOPOPDoctor  ;手术医生
    i $IsObject(oprDoctor) d
    .s oprDoctorName=oprDoctor.CTPCPDesc
    s instNurse=transOp.CSSDTOPCountNurseDR ;清点护士
    i $IsObject(instNurse) d
    .s instNurseName=instNurse.CTPCPDesc
    s circNurse=transOp.CSSDOPCircNurse  ;巡回护士
    i $IsObject(circNurse) d
    .s circNurseName=circNurse.CTPCPDesc
    s (oprDt,oprRoomNo,opArrange,infectName)=""
    s oprDt=transOp.CSSDOPCountDate  ;清点日期
    s oprDtNew=..DL2H(oprDt)
    s oprTime=transOp.CSSDOPCountTime		;清点时间
	s oprDtTime=..TL2H(oprTime)
	s oprDt=oprDtNew_" "_oprDtTime
    s oprRoomNo=transOp.CSSDTOPOPRoom   ;手术房间号
    s opArrange=transOp.CSSDTOPANOPID   ;手术安排表
    i $IsObject(opArrange) d
    .s (opaId,deptDr,chl,subchl,operLocId,oprRoom)=""
    .s opaId=opArrange.%Id()
    .s deptDr=opArrange.OPAPatDeptDr
    .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.;手术室 比如 第一手术室
	.s subchl=$o(^OR(patientId,"ANA",chl,"OP",0))
	.i subchl'=""  d
	..s operLocId=$P($G(^OR(patientId,"ANA",chl,"OP",subchl)),"^",10)
    ..s oprRoom=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetLocName(operLocId)
	s infectName=transOp.CSSDTOPInfectName ;感染病信息
	s DataStr=patientId_"^"_patientName_"^"_oprDoctorName_"^"_instNurseName
    		  _"^"_circNurseName_"^"_oprDt_"^"_oprRoom_"^"_oprRoomNo_"^"_useDept
    		  _"^"_infectName
	
	s TitleStr="patientId^patientName^oprDoctorName^instNurseName^circNurseName^oprDt^oprRoom^oprRoomNo^useDept^infectName"
	s Rtn=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

}
