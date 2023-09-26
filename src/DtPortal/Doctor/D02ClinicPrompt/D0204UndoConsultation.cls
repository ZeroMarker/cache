/// 名称:DtPortal.Doctor.D02ClinicPrompt.D0204UndoConsultation
/// 描述:Portal医生角色 D02 被邀会诊服务
/// 编写者：白明哲
/// 编写日期: 2014-07-11
Class DtPortal.Doctor.D02ClinicPrompt.D0204UndoConsultation Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 白明哲----修改按对象取值--20141215--改为取推送的数据--bmz20160316--bmz修改了按推送类型判断代码
/// CreatDate： 2014-7-10
/// Description: 获取会诊申请的列表
/// Input：  UserID         
/// Return：申请日期、申请科室、会诊日期、 床号、会诊id、姓名、年龄、性别、申请摘要、会诊医生、就诊号
/// 服务编码：D02.04.01
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0204UndoConsultation","D020401ConsultList","P","601","false")
Query D020401ConsultList(QueryType As %String, UserCode As %String, IfUsePushData As %String = "false") As DtPortal.Query(ROWSPEC = "ApplyDate:%String,ApplyDept:%String,ApplyDoc:%String,ConsultationDate:%String,BedCode:%String,ConsultId:%String,Name:%String,Age:%String,Sex:%String,ConDestination:%String,admId:%String,Attitude:%String,ConLocDept:%String,Diag:%String,MedicareNo:%String,AdmReason:%String,Attitudetsy:%String,Arcitmmastdesc:%String,ConsultType:%String,PatientID:%String,CsStatDesc:%String,MulWriFlag:%String,CsCategory:%String,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,logonGroupID,logonHospID,loginLocID")
{
}

ClassMethod D020401ConsultListExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String, IfUsePushData As %String = "false") As %Status
{
	n (qHandle,QueryType,UserCode,IfUsePushData)
	s repid=$I(^||CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	i UserCode="" q $$$OK
	set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	i UserID="" 	Quit $$$OK
	
	
	//会诊查询天数取配置
	s days=##Class(DtPortal.Common.PublicService).getValueByCode("DOCTORCONSULTATIONQUERYDAYS")
	s days=+days
	s StartDate=+$h-days,EndDate=+$h
	
	if (IfUsePushData="true"){
		//从消息平台---推送只支持 新产品组的 会诊
		set messageData=##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetMessageDataByType(UserID,"1014")
		
		set conIdStr=messageData.GetValue("bizObjId")
		i conIdStr="" q $$$OK
		s length=$l(conIdStr,"^")
		f i=1:1:length d
		.s id=$p(conIdStr,"^",i)
		.q:+id=0
		.s data=##Class(web.DHCEMConsInterface).GetCstContent(id)
		.q:data=""
		.set ApplyDept=$p(data,"^",3) ///申请科室
		.set admId=$p(data,"^",1) ///患者的就诊id
		.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admId) ///取病人的信息
	 	.s BedCode=$p(patInfoStr,"^",1)
	 	.s Name=$p(patInfoStr,"^",2)
	 	.s Sex=$p(patInfoStr,"^",3)
	 	.s Age=$p(patInfoStr,"^",4)
	 	.s MedicareNo=$p(patInfoStr,"^",5)   //病案号
	 	.s AdmReason=$p(patInfoStr,"^",6)    //费用类型
	    
	    .s diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admId)    //取诊断

		.s ConsultId=id   //会诊单号
		.s ConDestination= $p(data,"^",9) ///简要病历以及会诊目的
		.s ConLocDept = $p(data,"^",24) ///会诊科室
		.s ApplyDoc = $p(data,"^",7) ///申请医生
		.s ConsultationDate = $p(data,"^",10)_"&nbsp;"_$p(data,"^",11) ///会诊时间
		.s ApplyDate = $p(data,"^",4)_"&nbsp;"_$p(data,"^",5)  ///申请时间
		.s ConsultType  = $p(data,"^",23) ///会诊类型
		.s PatientID=$p($g(^PAADM(+admId)),"^",1)
		.s Attitude=$p(data,"^",21) ///会诊意见
		.s ConsultCate=$p(data,"^",25) ///会诊分类
		.i ConsultCate="DOCA" set ConsultType="抗生素会诊"
		.set attitudetsy=$p(data,"^",26) ///医生意见
		.i attitudetsy="Y" set attitudetsy=1
		.else  set attitudetsy=2
		.set arcitmmastdesc="" ///临床申请使用
		.i ConsultCate="DOCA" set arcitmmastdesc="抗菌药"
		.d ConsultList 
	
	}else{
		//会诊版本  1-护理组   2-新产品
		s version=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTATION")
		
		s LocStr=##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode(UserCode)
		s DocId=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)  		 //当前医生医护人员表id

		
		if QueryType="P" {//个人
			set MUDocIDs="^"_DocId_"^"
		}elseif QueryType="PG" {//主诊组
			//获取医生ID集合
			set MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId)  
		}else{
			set MUDocIDs="^"_DocId_"^"
		}
		
		s LocStr1="^"_LocStr_"^"
		s LocNum=$l(LocStr,"^")   
		
		
		
		
		
		if (version=1){
			f date=StartDate:1:EndDate d
			.s locId=""
			.f i=1:1:LocNum d
			..s locId=$p(LocStr,"^",i)   //通过病人所有的科室遍历
			..s locId1=" "_locId   //索引里面有空格
			..s id="" f  s id=$O(^User.DHCConsultationI("ConSultDep",date,locId1,id)) q:id=""  d
			...s b=##class(User.DHCConsultation).%OpenId(id)
			...s conStatus=b.Status			//会诊状态
			...q:conStatus'="V"   //非核实状态的退出
			...s conlocId=b.ConsultDep    //会诊科室Id
			...s admId=b.Adm             //就诊Id 
			...s RequestConDoc=b.RequestConDoc   //要求会诊医生id
			...q:(RequestConDoc'="")&&(MUDocIDs'[("^"_RequestConDoc_"^"))    //会诊医生不是登陆医生过滤----要求会诊医生不为空时判定
			...s applocId=b.AppDep        //会诊申请科室id
			...s ApplyDept=$P(^CTLOC(applocId),"^",2)  //会诊申请科室   
			...s appdate=b.AppDate		//申请日期
			...if appdate'="" s appdate=$ZD(appdate,3)
			...e  s appdate=""   
			...s apptime=b.AppTime		//申请时间
		    ...if apptime'=""  s apptime=$ZT(apptime,2)
		    ...e  s apptime=""
		    ...s ApplyDate=appdate_","_apptime  
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
	    
	    
		    ...s ConLocDept=$P(^CTLOC(conlocId),"^",2)  //要求会诊科室    
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
			...d GetPatInfo 
		}elseif(version="2") {
			
			s ConsultId="" 
			//发送\接受\审核---取配置
			s Type=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTAPPLYSTATE")
			s ConLocDept="" //要求会诊科室
			s arcitmmastdesc=""   //抗菌药描述
			s ConsultType=""  //会诊类型描述
			s length=$l(MUDocIDs,"^")
			f i=1:1:length d
			.s docId=$p(MUDocIDs,"^",i)
			.q:docId=""
			.set obj=##class(%ResultSet).%New("web.DHCEMConsInterface:QryDocCstList")
			.set sCode=$p($g(^CTPCP(docId,1)),"^",1)
			.q:sCode=""
			.d obj.Execute(sCode,"",StartDate,EndDate,Type,"C")
			.f  Quit:'obj.Next()  d               
			..s ConsultId=obj.Data("CsItmID")
			..s ApplyUserID=obj.Data("CstUserID")    //申请医生	 
			..s ApplyDeptID=obj.Data("CstRLocID")    //申请科室ID	
			..s ApplyDept=obj.Data("CstRLoc")    //申请科室 
			..s Attitude=obj.Data("Opinion")    //会诊意见                     
			..s EpisodeID=obj.Data("EpisodeID")				//病人就诊ID
			..s Introduction=obj.Data("CstPurpose")   //会诊简历及会诊目的---会诊描述
			..s ConDestination=Introduction
			..s conDate=obj.Data("CstNDate") 	//会诊日期
		 	..s conTime=obj.Data("CstNTime")			//会诊时间
		 	..s conDate=##class(DtPortal.Common.PublicService).dateFormat(conDate)
		 	..i conDate'=""  s ConsultationDate=conDate_"&nbsp;"_conTime
		    ..e  s ConsultationDate=""
		 	..s CstType=obj.Data("CstType")		//会诊类型
		 	..s CstEmType=obj.Data("CstEmType")  //会诊性质
		 	..s ConsultType=CstEmType_"("_CstType_")"   //会诊类型输出为   会诊性质（会诊类型）
		 	..s ConLocDept=obj.Data("CsLocDesc")		//会诊科室
		 	..s ApplyDoc=obj.Data("CstRUser")    //申请医生
		 	..s ApplyDate=obj.Data("CstRDate")
		 	..s ApplyDate=##class(DtPortal.Common.PublicService).dateFormat(ApplyDate)
		 	..s ApplyDate=ApplyDate_"&nbsp;"_obj.Data("CstRTime")  //会诊申请时间 
		 	..s AppTime="" 
		 	..s attitudetsy=obj.Data("AgreeFlag")  
		 	..s attitudetsy=""
		 	..i attitudetsy="Y" s attitudetsy="同意"
	    	..i attitudetsy="N" s attitudetsy="不同意" 
	    	..s CsStatDesc=obj.Data("CsStatDesc")	
	    	..s MulWriFlag=obj.Data("MulWriFlag")	//1-表示被邀会诊医生不能填写   其他-正常情况
	    	..s CsCategory=obj.Data("CsCategory")  //DOCA-为抗生素会诊
	    	..i CsCategory="DOCA" set arcitmmastdesc="抗菌药"
	    	..s loginLocID=obj.Data("CsLocID")
			..d GetPatInfo
		}
		
		
		
		
		
		
	}
   	q $$$OK


GetPatInfo
	//取病人信息
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	s PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	s admId=EpisodeID
 	s BedCode=$p(patInfoStr,"^",1)
 	s Name=$p(patInfoStr,"^",2)
 	s Sex=$p(patInfoStr,"^",3)
 	s Age=$p(patInfoStr,"^",4)
 	s MedicareNo=$p(patInfoStr,"^",5)   //病案号
 	s AdmReason=$p(patInfoStr,"^",6)    //费用类型
    s diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)    //取诊断
    //获取打开电子病历所需要的参数
	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
	set EMRDocID=$p(EMRinfo,"^",1)
	set EMRInstanceID=$p(EMRinfo,"^",2)
	set locID=$p(EMRinfo,"^",3)
	set PatientID=$p(EMRinfo,"^",4)
	set EMREpisodeID=$p(EMRinfo,"^",5)

    s logonInfo=##class(DtPortal.Doctor.D00CommonService).getUserGroupHosp(UserCode,loginLocID)
	s logonGroupID=$p(logonInfo,"^",1)
	s logonHospID=$p(logonInfo,"^",2)
    d ConsultList
   	q

ConsultList
    s Data=$lb(ApplyDate,ApplyDept,ApplyDoc,ConsultationDate,BedCode,ConsultId,Name,Age,Sex,ConDestination,admId,Attitude,ConLocDept,diag,MedicareNo,AdmReason,attitudetsy,arcitmmastdesc,ConsultType,PatientID,CsStatDesc,MulWriFlag,CsCategory,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,logonGroupID,logonHospID,loginLocID)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2014-7-18
/// Description: 插入会诊意见和会诊时间和会诊医生
/// Input：   str---consultId^consultAtt^userCode    
/// Return： 1 
/// 服务编码：D02.04.02
/// w ##class("DtPortal.Doctor.D02ClinicPrompt.D0204UndoConsultation").D020402InsertConsult("285||1^23333^^ys01")
ClassMethod D020402InsertConsult(str) As DtPortal.OutPut
{
	n (str)
	
	//会诊版本  1-护理组   2-新产品
	s version=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTATION")
	
	//s ^chengpeng(1)=str
	#Dim ret1 As DtPortal.OutPut
	Set ret1 = ##class(DtPortal.OutPut).%New()
	s consultId=$p(str,"^",1)
	s consultAtt=$p(str,"^",2)   //会诊意见
	s attitudetsy=$p(str,"^",3)  //医生意见1-同意   2-不同意
	s userCode=$p(str,"^",4)
	
	if (version=1){
		TStart
		s userId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
		If (userId="") {
			Set ret1.status = -1
			Set ret1.errMSG = "该用户不存在或用户名传入错误"
			Set ret1.data = ""
			b ;yc
			Quit ret1
		}
		s docId=$P($g(^SSU("SSUSR",userId)),"^",14)
		If (docId="") {
			Set ret1.status = -1
			Set ret1.errMSG = "该用户没在维护科室人员表"
			Set ret1.data = ""
			b ;yc2
			Quit ret1
		} 
		s consultDate=+$h
		s consultTime=$p($h,",",2)
		s a=##class(User.DHCConsultation).%OpenId(consultId)
		s a.ConsultDoc=docId
		s a.Attitude=consultAtt
		s a.ConsultDate=consultDate
		s a.ConsultTime=consultTime
		
		s a.attitudetsy=attitudetsy   //保存医生意见
		
		d a.%Save()    //保存会诊信息
		
		
		s b=^User.DHCConsultationD(consultId)
		s admId=$listget(b,2)           //就诊id
		s consultDept=$listget(b,11)    //要求会诊科室
		
		
		
		//保存成功后执行医嘱  Y表示是否插入费用
		s flag=##class(User.DHCConsultation).ChangeStatus(consultId,"E","Y",userId,admId,consultDept)
		;b ;4
		If ((flag'="")&&(flag'=0)) {
			TRollBack
			Set ret1.status = -1
			Set ret1.errMSG = flag
			Set ret1.data = ""
			b ;yc2
			Quit ret1
		} 
		;b ;5
		
		
		s ret1.data=1
		// 发送成功,提交事务
		TCommit
		Set ret1.status = 1
		Set ret1.errMSG = ""
	
	}elseif(version=2) {
		s stat=##Class(web.DHCEMConsultQuery).GetCstCurStat(consultId)
		if ((stat="发送")||(stat="审核")){
			s rtn=##Class(web.DHCEMConsInterface).AcceptCstNo(userCode,"",consultId)
		}else{
			s rtn=0
		}
		
		 ///执行会诊记录计费
		if rtn=0 {//执行会诊记录计费 成功
			if attitudetsy="1" s attitudetsy="Y"
			if attitudetsy="2" s attitudetsy="N"
			///更新会诊意见
			set rtn1=##Class(web.DHCEMConsInterface).UpdCstOpinion(userCode,"",consultId,consultAtt,attitudetsy)
			
			if rtn1=0{
				set ret1.data="[]"
				set ret1.status=1
				set ret1.errMSG="1"
			}else{
				set ret1.data="[]"
				set ret1.status=-1
				set ret1.errMSG="更新会诊意见失败"
			}
		}else{
			set ret1.data="[]"
			set ret1.status=-1
			set ret1.errMSG="执行会诊记录失败"
		}
	}
	
	
	
	
	q ret1
}

}
