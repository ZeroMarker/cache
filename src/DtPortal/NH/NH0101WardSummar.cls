/// 名称:DtPortal.NH.NH01WardSummar
/// 描述:查询病区概要的信息
/// 编写者：bmz
/// 编写日期: 2014-12-01
Class DtPortal.NH.NH0101WardSummar Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate： 2014-12-01
/// Description: 查询病区概要的信息
/// Input：  userCode(工号),wardId(病区id),NotPermissionStr(权限串)      
/// Return： 床位数、在院人数、床位使用率、待办出院人数、在岗护士数、病护比、空床数（包含空床信息）
/// 服务代码 NH01.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH0101WardSummar","NH010101WardInfoNum","411","10","false")
Query NH010101WardInfoNum(userCode As %String, wardId As %String, NotPermissionStr As %String) As DtPortal.Query(ROWSPEC = "CriticalPatNum:%String,CRITICALLYNum:%String,SERIOUSLYNum:%String,bedNum:%String,inNum:%String,bedPercent:%String,waitOutNum:%String,nurseOnDuty:%String,patNuserPercent:%String,emptyBedNum:%String")
{
}

ClassMethod NH010101WardInfoNumExecute(ByRef qHandle As %Binary, userCode As %String, wardId As %String, NotPermissionStr As %String) As %Status
{
	New (qHandle,userCode,wardId,NotPermissionStr)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:wardId="" $$$OK
	s IfContainWaitPat=##Class(DtPortal.Common.PublicService).getValueByCode("IFCONTAINWAITPAT")	
	//总床位数(View_WardNum),当前在院人数(View_StayHosNum),床位使用率(View_WardRate),待办出院人数(View_NoOutNum),在岗护士数(View_StayNurseNum),病护比(View_PatNurseRate),空床数(View_EmptyNum),
	Set bedNum=0,inNum=0,bedPercent=0,waitOutNum=0,nurseOnDuty=0,patNuserPercent=0,emptyBedNum="",emptyBedNum1=0
	//病危数量(View_IllCriticalPatNum),病重数量(View_IllSeriouslyPatNum),危重数量(View_CriticalPatNum)
	set CRITICALLYNum=0,SERIOUSLYNum=0,CriticalPatNum=0
	
	set arcimIDs=##class(DtPortal.Configure.arcim).getArcImID("CRITICALLY^SERIOUSLY",1)
	
	set locWarld=$p(^PAWARD(wardId),"^",5)
	Quit:locWarld="" $$$OK
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Set inNum=$l(admIdStr,"^")
	
	//取今日出院/明日出院医嘱ID
	s inHosNum=0
	s arcimID=##Class(DtPortal.Configure.arcim).getArcImID("TODAYDISCHARGE^TOMMORROWDISCHARGE",1)	//今日出院^明日出院
	f i=1:1:inNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	.s inHosNum=inHosNum+1
	.s ArcNums=##class(DtPortal.Common.PaadmService).getArcNums(EpisodeId,arcimIDs)
	.s CRITICALLYNum=CRITICALLYNum+$p(ArcNums,"^",1)
	.s SERIOUSLYNum=SERIOUSLYNum+$p(ArcNums,"^",2)
	.//病人同时开了病危、病重，只取一次
	.i ($p(ArcNums,"^",1)=1)&&($p(ArcNums,"^",2)=1) d
	..s CriticalPatNum=CriticalPatNum+1
	.e  s CriticalPatNum=CriticalPatNum+$p(ArcNums,"^",1)+$p(ArcNums,"^",2)
	.i (NotPermissionStr'["^View_NoOutNum^") d
	..s flag=0
	..s flag=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,arcimID,+$h)
	..s EstDischConfirmed=$p(^PAADM(EpisodeId,2),"^",25)  //医生医疗结算标记
	..i ((flag'=-1)&&(flag'=""))||(EstDischConfirmed="Y") s waitOutNum=waitOutNum+1   //待办出院人数
	

	
	//在岗护士人数
	//病护比
	try {
		//在岗护士数
		s nurseOnDuty=##class(DtPortal.NH.CommonService).GetNurAtPost(wardId,+$h)
		s patNuserPercent=""
		if (nurseOnDuty=0) {
			s patNuserPercent="0"
		}elseif(inNum=0){
			s patNuserPercent="1:0"
		}else{
			s patNurPer=$fn(inNum/nurseOnDuty,"",1)
			s patNuserPercent="1:"_patNurPer
		}
		
		
	} catch {
		s nurseOnDuty="ERR"
		s patNuserPercent="ERR"
	}
	
	
	Set bedInfo=""  //空床的详细信息
	//总床位数
	Set roomId=""
	For
	{
		Set roomId=$o(^PAWARD(0,"WardRoom",wardId,roomId)) 
		quit:roomId="" 
		
		Set bedChild=""
		For
		{
			Set bedChild=$o(^PAWARD(0,"WardRoom",wardId,roomId,bedChild)) 
			quit:bedChild=""
			s isValid=##class(DtPortal.Common.PublicService).isValidBed(wardId_"||"_bedChild)
			continue:isValid'="1"
			set rcFlag=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",4)
			if rcFlag'="Y" continue
			Set bedNum=bedNum+1
			s bedAvailable=$$CO18^at153(wardId_"||"_bedChild)  //取床位是否可用
			s ifBedExist=##class(DtPortal.Common.PublicService).ifBaoChuang(wardId_"||"_bedChild)  //判断床位是否被占用
			if (bedAvailable="Y")&&(ifBedExist=0){
				s emptyBedNum1=emptyBedNum1+1 //空床计数
				s bedCode=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",1)
				s bedRoomId=$p($g(^PAWARD(wardId,"BED",bedChild)),"^",3)
				
				s roomDesc=""
				i +bedRoomId'=0 Set roomDesc=$p(^PAROOM(roomId),"^",2)
				if bedCode'["床" s bedCode=bedCode_"床"
				If bedInfo="" {
					s bedInfo =roomDesc_"-"_bedCode
				}Else{
					s bedInfo =bedInfo_"###"_roomDesc_"-"_bedCode
				}
			}
				
		}  
		  
	}  
	
	s emptyBedNum=emptyBedNum1_"^"_bedInfo   //空床数和空床信息
	//床位数
	s bedNumCount=bedNum-emptyBedNum1
	//床位使用率
	Set bedPercent=$fn(bedNumCount/bedNum,"",4)*100_"%"
	
	
	
	
    d wardInfo 
	
 
  	q $$$OK
wardInfo
    s Data=$lb(CriticalPatNum,CRITICALLYNum,SERIOUSLYNum,bedNum,inHosNum,bedPercent,waitOutNum,nurseOnDuty,patNuserPercent,emptyBedNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
