/// DtPortal.Doctor.D01PatList.D0104CstPat
/// 描述:Portal医生角色 D01发邀会诊服务
/// 创建者：  程鹏
/// 创建日期: 2018-11-03
Class DtPortal.Doctor.D01PatList.D0104CstPat Extends %RegisteredObject
{

/// Creator： humiao---修改按对象取值--20141215bmz
/// CreatDate： 2014-7-11
/// Description: 查询会诊申请列表
/// Input：		queryType:查询范围（P：本人  PG:就诊组）
/// 			Type : 查询单位(1.待会诊2.已会诊); 
/// 		   	StartDate：查询开始日期;
/// 		  	EndDate：查询结束日期
/// 			UserCode:用户code
/// Return： 	ApplyDate：申请时间
/// 			ApplyDept：申请科室
/// 			ApplyDoc：申请医生
/// 			MedicareNo：病案号
/// 			Name：姓名 
/// 			ConsultDept：被邀科室
/// 			ConsultDoc：被邀医生
/// 			Introduction: 病情介绍   
/// 			ConStatus：会诊状态
///             ConsultID：会诊号
///             PAPMINO：登记号
/// 			ConAttitude：会诊意见
/// 服务号:		D01.04.01
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0104CstPat","D010401CstPat","P","1","2018-11-13","2018-11-20","601")
Query D010401CstPat(QueryType As %String, Type As %String, StartDate As %String, EndDate As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "ind1,bedCode,MedicareNo,Name,sex,age,AdmReason,diag,ConsultDept,conTypeDesc,Introduction,conDate,conTime,ConsultDoc,ConAttitude,ConStatus,CsStatDesc,ApplyDoc,ApplyDate,AppTime,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

// 63379

ClassMethod D010401CstPatExecute(ByRef qHandle As %Binary, QueryType As %String, Type As %String, StartDate As %String, EndDate As %String, UserCode As %String) As %Status
{
	Set repid1=$I(^||CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	quit:((QueryType="")&&(UserCode="")&&(Type="")) $$$OK

	if StartDate["-"  Set StartDate=$zdh(StartDate,3)
	if EndDate["-" Set EndDate=$zdh(EndDate,3)
	if StartDate="" Set StartDate=+$h    //取当天
	if EndDate=""  Set EndDate=+$h

	if Type="" Quit $$$OK
	
	s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(UserCode,"U"),0))
	Quit:UserID="" $$$OK
	s DocId=$P($g(^SSU("SSUSR",UserID)),"^",14)    //当前医生医护人员表id
	Quit:DocId="" $$$OK
	//hulei
	if QueryType="P" {//个人
		set MUDocIDs="^"_DocId_"^"
	}elseif QueryType="PG" {//主诊组
		//获取医生ID集合
		set MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId)  
	}else{
		set MUDocIDs="^"_DocId_"^"
	}
	//hulei
	
	set CstBanben=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTATION")
	
	if CstBanben=1 
	{
		s ConStatus=""
		//待会诊
		if Type=1 s ConStatus="V"
		//已会诊
		if Type=2 s ConStatus="E"
	
		Set LocStr=##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode(UserCode)
		s LocStr="^"_LocStr_"^"
		if LocStr="" Quit $$$OK
		
		f Date=StartDate:1:EndDate  d
		.s appdept=""
		.f  s appdept=$o(^User.DHCConsultationI("AppDep",Date,appdept)) q:appdept=""  d
		..s appdepttemp="^"_$p(appdept," ",2)_"^"
		..q:LocStr'[appdepttemp
		..s consultno=""
		..f  s consultno=$o(^User.DHCConsultationI("AppDep",Date,appdept,consultno)) q:consultno=""  d
		...s b=##class(User.DHCConsultation).%OpenId(consultno)  //用对象去取值 
		...s status=b.Status     //会诊状态        
		...i ConStatus'="" d
		....q:status'=ConStatus
		....s ApplyDocID=""          
		....s ApplyUserID=b.AppDoc    //申请医生  ----存的是userId
		....s ApplyDocID=$P($g(^SSU("SSUSR",ApplyUserID)),"^",14) 
		....s ApplyDocIDs="^"_ApplyDocID_"^"
		....i (MUDocIDs [ApplyDocIDs) d
		.....s ConsultDept="",conTypeDesc="",ConsultDoc="",CsStatDesc=""
		.....s ConsultDeptID=b.ConsultDep		//要求会诊科室ID
		.....i ConsultDeptID'="" s ConsultDept=$P(^CTLOC(ConsultDeptID),"^",2) //被邀科室Name
		.....set:ConsultDept["-" ConsultDept=$p(ConsultDept,"-",2)     
		.....s ConsultDocID=b.ConsultDoc    //会诊医生ID			
		.....s RequestConDoc=b.RequestConDoc		//要求会诊医生ID
		.....i ConsultDocID'="" s ConsultDoc=$P($g(^CTPCP(ConsultDocID,1)),"^",2)
		.....i ApplyDocID'="" s ApplyDoc=$P($g(^CTPCP(ApplyDocID,1)),"^",2)
		.....s ConAttitude=b.Attitude    //会诊意见                      
		.....s EpisodeID=b.Adm				//病人就诊ID
		.....s Introduction=b.ConDestination   //会诊简历及会诊目的---会诊描述
		.....s conDate=b.ConsultDate		//会诊日期
		.....s conTime=b.ConsultTime		//会诊时间
		.....if conDate'="" s conDate=$ZD(conDate,3)
		.....if conTime'=""  s conTime=$ZT(conTime,2)
		.....s ApplyDate=b.AppDate                    
		.....if ApplyDate'="" s ApplyDate=$ZD(ApplyDate,3)  //申请日期
		.....e  s ApplyDate=""    
		.....s AppTime=b.AppTime
		.....i AppTime'="" s AppTime=$ZT(AppTime,2)       //申请时间
		.....s conType=b.ConType		//会诊类型
    	.....i conType="E" s conTypeDesc="急"
		.....e  i conType="M" s conTypeDesc="多科"
		.....e  i conType="A" s conTypeDesc="抗菌药"
		.....e  s conTypeDesc="普通"
		.....i ConStatus="V" s CsStatDesc="待会诊"
    	.....i ConStatus="E" s CsStatDesc="已会诊"  	
		.....d OutPutRow            //与输入状态Type不同退出
	}else
	{
		s ConStatusDesc=""
		s ConStatusCodeStr=""
		//未完成
		if Type=1 s ConStatusCodeStr=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTNOTFINISHSTATE"),ConStatus="V"
		//已完成
		if Type=2 s ConStatusCodeStr=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTFINISHSTATE"),ConStatus="E"
		s length=$l(MUDocIDs,"^")
		f i=1:1:length d
		.s docId=$p(MUDocIDs,"^",i)
		.q:docId=""
		.set obj=##class(%ResultSet).%New("web.DHCEMConsInterface:QryDocCstList")
		.set sCode=$p($g(^CTPCP(docId,1)),"^",1)
		.q:sCode=""
		.d obj.Execute(sCode,"",StartDate,EndDate,ConStatusCodeStr,"R")
		.f  Quit:'obj.Next()  d   
		..s CsStatDesc=obj.Data("CsStatDesc")    //会诊状态描述     
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
	 	..s AppTime=obj.Data("CstRTime")  	 //申请时间
	 	..s ApplyDate=##class(DtPortal.Common.PublicService).dateFormat(ApplyDate)
		..d OutPutRow
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
