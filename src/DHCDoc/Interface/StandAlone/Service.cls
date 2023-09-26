/// Filename         :DHCDoc.Interface.StandAlone.Service
/// Description      :应急系统与his对接业务类
/// Time             :2021/11/19
/// Author           :zhouc
Class DHCDoc.Interface.StandAlone.Service Extends Base
{

/***
  **Description      :应急系统是否可用
  **Author           :zhouc
  **Time             :2021/11/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Service).CESEnable()
  **Parameter        :
  **Returns          :0:否;1:是
***/
ClassMethod CESEnable()
{
	q:$D(^oddCOM("BILL.CES.COM.Log","m","IsCESFlag")) 1
	q 0
}

/***
  **Description      :根据业务表和ID获取判断数据是否是应急收费系统导入的数据
  **Author           :zhouc
  **Time             :2021/11/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Service).IsCESFlag("pa_adm",1)
  **Parameter        :TableName:表名;rowId:表主键
  **Returns          :0:否;1:是
***/
ClassMethod IsCESFlag(tableName As %String, rowId As %String)
{
	s CESEnable=..CESEnable()
	q:CESEnable=0 0
	q ##class(BILL.CES.COM.Log).IsCESFlag(tableName,rowId)
}

/***
  **Description      :判断是否是应急系统传回的患者
  **Author           :zhouc
  **Time             :2021/11/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Service).IsCESAdm(1)
  **Parameter        :就诊号
  **Returns          :0:否;1:是
***/
ClassMethod IsCESAdm(EpisodeId As %String)
{
	q ..IsCESFlag("pa_adm",EpisodeId)
}

/***
  **Description      :判断应急系统患者队列状态
  **Author           :zhouc
  **Time             :2021/11/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Service).GetCESAdmQueStatInfo(439)
  **Parameter        :就诊号 队列表rowid 队列表id若不为空则返回对应队列的状态,若为空则按应急系统患者判断
  **Returns          :就诊队列状态 id^code^desc
  **public			 : 新产品组亦使用
***/
ClassMethod GetCESAdmQueStatInfo(EpisodeId As %String, QueDr As %String = "")
{
	s StatusDr=""
	Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
	if ($ISOBJECT(QueObj)){
		s StatusDr=QueObj.QueStateDr.%Id()
		k QueObj
		q $$OutputQueStat(StatusDr)
	}
	q:..IsCESAdm(EpisodeId)=0 $$OutputQueStat(StatusDr)
	
	s WaitStatusDr=""
	&sql(select ID into :WaitStatusDr from SQLUser.dhcperstate where PersName='等候')
	s ArriveStatusDr=""
	&sql(select ID into :ArriveStatusDr from SQLUser.dhcperstate where PersName='到达')
	s StatusDr=ArriveStatusDr
	q $$OutputQueStat(StatusDr)
	
	s HospId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeId)
	s OrdDr=$o(^OEORD(0,"Adm",EpisodeId,""))
	s OrdObj=##class(User.OEOrder).%OpenId(OrdDr)
	
	q:'$ISOBJECT(OrdObj) $$OutputQueStat(StatusDr)
	
	s OrdItmCount=OrdObj.ChildOEOrdItem.Count()
	f ItmInd=1:1:OrdItmCount{
		#Dim OrdItmObj As User.OEOrdItem
		s OrdItmObj=OrdObj.ChildOEOrdItem.GetAt(ItmInd)
		s ArcDr=OrdItmObj.OEORIItmMastDR.%Id()
		s ArcBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcDr,HospId)
		if (ArcBillSubType="NotRegFee"){
			s StatusDr=ArriveStatusDr
			q
		}
		s:StatusDr="" StatusDr=WaitStatusDr
	}
	
	
	q $$OutputQueStat(StatusDr)
OutputQueStat(StatusDr)
	q:StatusDr="" ""
	s StatusInfo=""
	s StatusCode=$lg(^User.DHCPerStateD(StatusDr),2)
	s StatusDesc=$lg(^User.DHCPerStateD(StatusDr),4)
	q StatusDr_"^"_StatusCode_"^"_StatusDesc
}

/***
  **Description      :患者退号前进行应急系统相关判断
  **Author           :zhouc
  **Time             :2022/08/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Service).CheckBeforeCancelReg()
  **Parameter        :
  **Returns          :
***/
ClassMethod CheckBeforeCancelReg(EpisodeId)
{
	q:(EpisodeId="")||('$d(^PAADM(EpisodeId))) "0"
	q:..IsCESAdm(EpisodeId)=1 "0"		;应急系统患者暂不做判断
	
	;非应急系统患者需判断该患者是否有当天同科室的无挂号费用应急系统就诊记录
	s AdmLocId=$P(^PAADM(EpisodeId),"^",4)
	s AdmDate=$p(^PAADM(EpisodeId),"^",6)
	s PatientId=$p(^PAADM(EpisodeId),"^",1)
	
	s (HisNoRegAdms,CESNoRegAdms)=""
	s LEpisodeId=""
	f {
		s LEpisodeId=$o(^PAPERdr(PatientId,"ADM","O",LEpisodeId))
		q:LEpisodeId=""
		continue:EpisodeId=LEpisodeId
		s LAdmDate=$p(^PAADM(LEpisodeId),"^",6)
		continue:LAdmDate'=AdmDate
		s LAdmLocId=$P(^PAADM(LEpisodeId),"^",4)
		continue:LAdmLocId'=AdmLocId
		s LAdmVisitStatus=$P(^PAADM(LEpisodeId),"^",20)
		continue:LAdmVisitStatus="C"
		s HaveRegOrdFlag=..AdmHaveRegOrd(LEpisodeId)
		continue:HaveRegOrdFlag="1"
		s CESFlag=..IsCESAdm(LEpisodeId)
		if (CESFlag=1){
			s CESNoRegAdms=$s(CESNoRegAdms="":LEpisodeId,1:CESNoRegAdms_"^"_LEpisodeId)	
		}else{
			s HisNoRegAdms=$s(HisNoRegAdms="":LEpisodeId,1:HisNoRegAdms_"^"_LEpisodeId)	
		}
	}
	
	q:(CESNoRegAdms'="") "-1^CESReg"
	q "0"
}

/***
  **Description      :判断患者就诊记录是否有计费的挂号医嘱
  **Author           :zhouc
  **Time             :2022/08/19
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Service).AdmHaveRegOrd()
  **Parameter        :
  **Returns          :0:没有 1:有
***/
ClassMethod AdmHaveRegOrd(EpisodeId)
{
	s HaveRegOrd="0"
	s RegSerOrd=..GetAdmRegSerOrd(EpisodeId)
	s:RegSerOrd'="" HaveRegOrd="1"
	q HaveRegOrd
}

/***
  **Description      :获取患者的挂号类医嘱id串
  **Author           :zhouc
  **Time             :2022/10/12
  **debugger         :w ##Class(DHCDoc.Interface.StandAlone.Service).GetAdmRegSerOrd()
  **Parameter        :
  **Returns          :"" 或 id^id
***/
ClassMethod GetAdmRegSerOrd(EpisodeId)
{
	s RegSerOrd=""
	q:(EpisodeId="")||('$d(^PAADM(EpisodeId))) RegSerOrd
	s AdmType=$p(^PAADM(EpisodeId),"^",2)
	q:AdmType="I" RegSerOrd
	
	//此串同步web.DHCOPAdmReg:CancelOPRegist 中停挂号医嘱的串
	s RegSerBillSubTypeStr="^MR^Card^Reg^Check^ReCheck^App^Holi^Other^"
	s AdmHospId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeId)
	
	s OrdDr=$o(^OEORD(0,"Adm",EpisodeId,""))
	s OrdSub=0
	f {
		s OrdSub=$o(^OEORD(OrdDr,"I",OrdSub))
		q:OrdSub=""
		s ArcimId=$p(^OEORD(OrdDr,"I",OrdSub,1),"^",2)
		s BillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId,AdmHospId)
		continue:RegSerBillSubTypeStr'[("^"_BillSubType_"^")
		s OrdItemDr=OrdDr_"||"_OrdSub
		s RegSerOrd=$s(RegSerOrd="":OrdItemDr,1:RegSerOrd_"^"_OrdItemDr)
	}
	q RegSerOrd
}

}
