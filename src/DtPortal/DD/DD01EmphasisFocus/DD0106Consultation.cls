Class DtPortal.DD.DD01EmphasisFocus.DD0106Consultation Extends %RegisteredObject
{

/// Creator： humiao---修改按对象取值--20141215bmz
/// CreatDate： 2014-7-11
/// Description: 查询会诊申请列表
/// Input：		UserCode:用户code
/// 			locGroupID : 科室组
/// 		   	Type：1-完成 2-未完成
/// 		  	findType：C-被邀会诊 R-申请会诊 			
/// 服务号:		DD01.06.01
/// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD01EmphasisFocus.DD0106Consultation","DD010601","ys01","110","1","R")
Query DD010601(UserCode As %String, locGroupID As %String, Type As %String, findType As %String) As DtPortal.Query(ROWSPEC = "ind1,bedCode,MedicareNo,Name,sex,age,AdmReason,diag,ConsultDept,conTypeDesc,Introduction,conDate,conTime,ConsultDoc,ConAttitude,ConStatus,CsStatDesc,ApplyDoc,ApplyDate,AppTime,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

ClassMethod DD010601Execute(ByRef qHandle As %Binary, UserCode As %String, locGroupID As %String, Type As %String, findType As %String) As %Status
{
	Set repid1=$I(^||CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	
	//会诊版本  1-护理组   2-新产品
	s version=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTATION")
	//q:(version'=2) $$$OK    //只取新版会诊的数据
	q:(Type'="1")&&(Type'="2") $$$OK
	q:(findType'="C")&&(findType'="R") $$$OK
	s DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"")
	Quit:DocLocStr="" $$$OK
	//会诊查询天数取配置
	s days=##Class(DtPortal.Common.PublicService).getValueByCode("DOCTORCONSULTATIONQUERYDAYS")
	s days=+days
	s StartDate=+$h-days,EndDate=+$h 
	
	if (version=1){
		if (findType="C") {
			s findTypeNode="ConSultDep"
		}elseif(findType="R"){
			s findTypeNode="AppDep"
		}else{
			q $$$OK
		}
		s length=$l(DocLocStr,"^")
		f date=StartDate:1:EndDate d
		.s locId=""
		.f i=1:1:length d
		..s locId=$p(DocLocStr,"^",i)   //通过病人所有的科室遍历
		..s locId1=" "_locId   //索引里面有空格
		..s id="" f  s id=$O(^User.DHCConsultationI(findTypeNode,date,locId1,id)) q:id=""  d
		...s b=##class(User.DHCConsultation).%OpenId(id)
		...s conStatus=b.Status			//会诊状态
		...//q:conStatus'="V"   //非核实状态的退出
		...q:(Type=1)&&(conStatus'="E")    //判断E状态为完成
		...q:(Type=2)&&(conStatus="E")    //判断E状态为完成
		...s conlocId=b.ConsultDep    //会诊科室Id
		...s admId=b.Adm             //就诊Id 
		...s RequestConDoc=b.RequestConDoc   //要求会诊医生id

		
		...;q:(RequestConDoc'="")		//&&(MUDocIDs'[("^"_RequestConDoc_"^"))    //会诊医生不是登陆医生过滤----要求会诊医生不为空时判定
		...s applocId=b.AppDep        //会诊申请科室id
		...s ApplyDept=$P(^CTLOC(applocId),"^",2)  //会诊申请科室
		...s appdate=b.AppDate		//申请日期
		...if appdate'="" s appdate=$ZD(appdate,3)
		...e  s appdate=""   
		...s AppTime=b.AppTime		//申请时间
		...if AppTime'=""  s AppTime=$ZT(AppTime,2)
		...e  s AppTime=""
		...s ApplyDate=appdate  
		...s conDate=b.ConsultDate  //会诊日期
		...if conDate'="" s conDate=$ZD(conDate,3)
		...e  s conDate=""  
		...s conTime=b.ConsultTime		//会诊时间
		...if conTime'=""  s conTime=$ZT(conTime,2)
		...e  s conTime=""
		...i conDate'=""  s ConsultationDate=conDate_","_conTime
		...e  s ConsultationDate=""
		   
			   

		...s ConsultationId=id   //会诊单号
		...s ConsultId=id
		    
		...s ConDestination=b.ConDestination //会诊描述--简要会诊及目的  
		...s ConsultDocID=b.ConsultDoc		//会诊医生id

		...i ConsultDocID'=""  s ApplyDoc=$P($g(^CTPCP(ConsultDocID,1)),"^",2) //被邀医生Name
		...e  s ApplyDoc=""    
		...s Attitude=b.Attitude		//会诊意见
		    
		    
		...s ConsultDept=$P(^CTLOC(conlocId),"^",2)  //要求会诊科室
		...i (ConsultDept'="") s ConsultDept=$p(ConsultDept,"-",2)
		...s Specordid=b.Specordid     //抗菌药id 
		...s attitudetsy=b.attitudetsy  //医生意见 1-同意  2-不同意
		...s arcitmmastdesc=""
		...i Specordid'="" d
		....s OEORDRowId=$p(Specordid,"_")
		....s OEORIChildsub=$p(Specordid,"_",2)
		....s arcitmmastdesc=$p(^ARCIM(OEORDRowId,OEORIChildsub,1),"^",2)
		...;会诊类型----用于判断是否是抗菌药会诊
		...s conType=b.ConType   //会诊类型
		...s PatientID=$p($g(^PAADM(+admId)),"^",1)
		...s EpisodeID=admId
		...d OutPutRow
		
		
		Quit $$$OK
		
		
	}elseif(version=2){
	
		s ConStatusDesc=""
	
		s ConStatusCode=""
		//未完成
		if Type=1 s ConStatusCode=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTNOTFINISHSTATE")
		//已完成
		if Type=2 s ConStatusCode=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTFINISHSTATE")
		s length=$l(DocLocStr,"^")
		f i=1:1:length d
		.s locId=$p(DocLocStr,"^",i)
		.q:locId=""
		.set obj=##class(%ResultSet).%New("web.DHCEMConsInterface:QryDocCstList")
		.d obj.Execute("",locId,StartDate,EndDate,ConStatusCode,findType)
		.f  Quit:'obj.Next()  d   
		..s CsStatDesc=obj.Data("CsStatDesc")    //会诊状态描述
		..s ConStatus=CsStatDesc
		..//s CsStatDescs="^"_CsStatDesc_"^"
		..//q:ConStatusDesc'[CsStatDescs      
		..s ConsultDoc=obj.Data("CsUser")    //会诊医生	
		..s ConAttitude=obj.Data("Opinion")    //会诊意见                      
		..s EpisodeID=obj.Data("EpisodeID")				//病人就诊ID
		..s Introduction=obj.Data("CstPurpose")   //会诊简历及会诊目的---会诊描述
		..s conDate=obj.Data("CstNDate") 	//会诊日期
		..s conDate=##class(DtPortal.Common.PublicService).dateFormat(conDate)
	 	..s conTime=obj.Data("CstNTime")			//会诊时间
	 	..s CstType=obj.Data("CstType")		//会诊类型
	 	..s CstEmType=obj.Data("CstEmType")  //会诊性质
	 	..s conTypeDesc=CstEmType_"("_CstType_")"   //会诊类型输出为   会诊性质（会诊类型）
	 	..s ConsultDept=obj.Data("CsLocDesc")		//会诊科室
	 	..s ApplyDoc=obj.Data("CstRUser")    //申请医生
	 	..s ApplyDate=obj.Data("CstRDate")   //申请日期   
	 	..s ApplyDate=##class(DtPortal.Common.PublicService).dateFormat(ApplyDate)
	 	..s AppTime=obj.Data("CstRTime")  	 //申请时间
		..d OutPutRow
	
	
	}else{
		q $$$OK
	}
	
	
	
	
	
	Quit $$$OK
OutPutRow
              
   
 	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	s bedCode=$p(patInfoStr,"^",1)
	s MedicareNo=$p(patInfoStr,"^",5)
	s Name=$p(patInfoStr,"^",2)
	s sex=$p(patInfoStr,"^",3)
	s age=$p(patInfoStr,"^",4)
	s AdmReason=$p(patInfoStr,"^",6)
 	
     //取诊断---先取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
	s diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID) 
	
	//获取打开电子病历所需要的参数
	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
	set EMRDocID=$p(EMRinfo,"^",1)
	set EMRInstanceID=$p(EMRinfo,"^",2)
	set locID=$p(EMRinfo,"^",3)
	set PatientID=$p(EMRinfo,"^",4)
	set EpisodeID=$p(EMRinfo,"^",5)
	Set ^||CacheTemp(repid1,ind1)=$lb(ind1,bedCode,MedicareNo,Name,sex,age,AdmReason,diag,ConsultDept,conTypeDesc,Introduction,conDate,conTime,ConsultDoc,ConAttitude,ConStatus,CsStatDesc,ApplyDoc,ApplyDate,AppTime,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId)
	Set ind1=ind1+1
	quit
}

}
