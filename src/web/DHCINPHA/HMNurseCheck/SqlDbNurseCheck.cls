/// Description:核对揭药信息操作表结构相关
/// Creator:    hulihua
/// CreateDate: 2017-09-14
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
Class web.DHCINPHA.HMNurseCheck.SqlDbNurseCheck Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:更新揭药子表关于护士核对的表结构方法
/// Creator:	hulihua
/// CreateDate:	2017-09-14
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		Phmbi-揭药明细ID，NurseCheckUser-审核护士ID	
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMNurseCheck.SqlDbNurseCheck).SaveBroNurCheckDb("3##")
ClassMethod SaveBroNurCheckDb(Phmbi As %String, NurseCheckUserID As %String) As %String
{
	n (Phmbi, NurseCheckUserID)
	//s ^tmyq($this,"SaveBroNurCheckDb")=$lb(Phmbi, NurseCheckUserID)
	s NurseCheckDate=+$h
	s NurseCheckTime=$p($h,",",2)
	s UncovMedFlag=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",5)
	/// 装箱ID
	s boxId=+$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",16)
	s err=0
	ts
	s obj=##class(User.DHCPhaMedBrothItm).%OpenId(Phmbi)
	d obj.PHMBINurseCheckUserDRSetObjectId(NurseCheckUserID)
	s obj.PHMBINurseCheckDate=NurseCheckDate
	s obj.PHMBINurseCheckTime=NurseCheckTime
	s obj.PHMBINurseCheckFlag="Y"
	i UncovMedFlag'="Y" d
	.s obj.PHMBIUncovMedFlag="Y"
	.s obj.PHMBIRemarks="护士揭药室领取"
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.s err="更新揭药子表失败"
	.tro
	q:err'=0 $SYSTEM.Status.GetErrorText(sc)
	// 不存在未完成的子表记录则更新主表完成状态
	s phmbId=+Phmbi
	i '$d(^DHCPHAMEDBi("UncovMedFlag","N",phmbId)) d
	.s objM=##class(User.DHCPhaMedBroth).%OpenId(phmbId)
	.s objM.PHMBMedBroCompFlag="Y"
	.s sc=objM.%Save()
	.d objM.%Close()
	.i $$$ISERR(sc) d
	..s err="更新揭药主表失败"
	..tro
	q:err'=0 $SYSTEM.Status.GetErrorText(sc)
	
	i boxId'=0 d
	.s obj=##class(User.DHCPHBox).%OpenId(boxId)
	.d obj.PHBUserWardChkDrSetObjectId(NurseCheckUserID)
	.s obj.PHBDateWardChk=NurseCheckDate
	.s obj.PHBTimeWardChk=NurseCheckTime
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s err="更新装箱表核对人失败"
	..tro
	.
	q:err'=0 $SYSTEM.Status.GetErrorText(sc)
	
	tc
	q err
}

}
