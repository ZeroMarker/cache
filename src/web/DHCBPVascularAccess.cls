Import SQLUser

Class web.DHCBPVascularAccess Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

//w ##class(web.DHCBPVascularAccess).SaveVascularAccess("")

ClassMethod SaveVascularAccess(paraStr As %String) As %String
{
	s Id=$p(paraStr,$c(3),1)
	s obj=""
	q:(paraStr="") obj
	i Id="" s obj=##class(User.DHCBPVascularAccess).%New()
	e  s obj=##class(User.DHCBPVascularAccess).%OpenId(Id)
	s registerId=$p(paraStr,$c(3),2)
	i registerId'="" s obj.BPVBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
	s bpcVascularAccessId=$p(paraStr,$c(3),3)
	i bpcVascularAccessId'="" s obj.BPVVascularAccessDr=##class(User.DHCBPCVascularAccess).%OpenId(bpcVascularAccessId)
	s obj.BPVBodySiteDr=$p(paraStr,$c(3),4)
	s buildingDate=$p(paraStr,$c(3),5)
	s obj.BPVBuildingDate=##class(web.DHCClinicCom).ConvertToDateH(buildingDate)
	s buildingTime=$p(paraStr,$c(3),6)
	s obj.BPVBuildingTime=##class(web.DHCClinicCom).ConvertToTimeH(buildingTime)
	s startDate=$p(paraStr,$c(3),7)
	s obj.BPVStartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=$p(paraStr,$c(3),8)
	s obj.BPVStartTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=$p(paraStr,$c(3),9)
	s obj.BPVEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=$p(paraStr,$c(3),10)
	s obj.BPVEndTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s obj.BPVEndReason=$p(paraStr,$c(3),11)
	s status=$p(paraStr,$c(3),12)
	s obj.BPVStatus=status
	s startDate=obj.BPVStartDate
	i startDate>+$h d
	.s obj.BPVStatus="I"
	s endDate=obj.BPVEndDate
	i endDate<=+$h  d
	.s obj.BPVStatus="D"
	e  d
	.i status="D" s obj.BPVStatus="I"
	s obj.BPVUpdateUserDr=$p(paraStr,$c(3),13)
	s updateDate=$p(paraStr,$c(3),14)
	s obj.BPVUpdateDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
	s updateTime=$p(paraStr,$c(3),15)
	s obj.BPVUpdateTime=##class(web.DHCClinicCom).ConvertToDateH(updateTime)
	d obj.%Save()
	s result=obj.%Id()
	d obj.%Close()
	q result
}

Query FindBPVascularAccess(registerId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID As Id,BPV_BPPatRegister_Dr As RegisterId,BPV_VascularAccess_Dr As VascularAccessId,BPV_BodySite_Dr As BodySiteId,
	BPV_BuildingDate As BuildingDate,
	BPV_BuildingTime As BuildingTime,
	BPV_StartDate As StartDate,	
	BPV_StartTime As StartTime,BPV_EndDate As EndDate,
	BPV_EndTime As EndTime,BPV_EndReason As Reason,BPV_Status As Status,
	BPV_UpdateUser_Dr As UpdateUserId,BPV_UpdateDate As UpdateDate,BPV_UpdateTime As UpdateTime
	from DHC_BP_VascularAccess  where BPV_BPPatRegister_Dr=:registerId
}

ClassMethod TerminateVascularAccessScheme(paraStr) As %String
{
   s id=$p(paraStr,$c(3),1)
   q:id="" -1
   s endDate=$p(paraStr,$c(3),2)
   s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
   k PLIST 
   i endDate<=+$h  d
   .s PLIST(12)="D"
   e  s PLIST(12)="I"
   s PLIST(9)=endDate 
   s PLIST(11)=$p(paraStr,$c(3),3)   
   TSTART
   &sql(update DHC_BP_VascularAccess values:PLIST() where %ID=:id )
   i SQLCODE'=0 TROLLBACK  Q "更新状态失败" 
   TCOMMIT
   q 1
}

//w ##class(web.DHCBPVascularAccess).UpdateStatus(11)

ClassMethod UpdateStatus(id) As %String
{
  TSTART 
  s schemeId=""
  s curDate=+$h,count=0
  &sql( update DHC_BP_Scheme set BPS_VascularAccess_Dr=:id
  from DHC_BP_Scheme 
  where BPS_BPRegister_Dr=(select BPV_BPPatRegister_Dr from DHC_BP_VascularAccess where %ID=:id)
  and (BPS_StartDate<=:curDate and BPS_EndDate>:curDate))
  i (SQLCODE'=0)&(SQLCODE'=100) TROLLBACK  Q "更新透析方案失败"
  &sql(update DHC_BP_VascularAccess set BPV_Status='D' where BPV_EndDate<=:curDate or BPV_StartDate>:curDate )
  i (SQLCODE'=0)&(SQLCODE'=100) TROLLBACK  Q "更新状态失败"
  ;i SQLCODE=-110 d
  .;&sql(UNLOCK DHC_BP_VascularAccess IN EXCLUSIVE MODE) 
  &sql(update DHC_BP_VascularAccess set BPV_Status='I'	where BPV_BPPatRegister_Dr=(select 
  BPV_BPPatRegister_Dr from DHC_BP_VascularAccess where %ID=:id) and %ID<>:id and
   (BPV_Status is null or BPV_Status<>'D' ))
  i (SQLCODE'=0)&(SQLCODE'=100) TROLLBACK  Q "更新状态失败" 
  &sql(update DHC_BP_VascularAccess set BPV_Status='N' where  %ID=:id)
  i (SQLCODE'=0)&(SQLCODE'=100) TROLLBACK  Q "更新状态失败" 
  TCOMMIT
  q 1
}

}
