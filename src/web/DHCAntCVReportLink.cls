Class web.DHCAntCVReportLink Extends %RegisteredObject
{

/// w ##class(web.DHCAntCVReportLink).SaveTransOrd("1||10000000019||1","293||1,293||2",1)
ClassMethod SaveTransOrd(reportID = "", OEOrdItemIds = "", UserID = "", Note = "")
{
	if reportID["||REEXAMINE" { //复查 为了方便 使用的还是医生站医嘱录入 只是在传过去的危急值ID后面拼了个||REEXAMINE 作为标志
		s reportID=$p(reportID,"||REEXAMINE",1)
		q ..SaveReexamine(reportID,OEOrdItemIds,UserID,Note)
	}
	
	
	s ret=..Save(reportID, "1",OEOrdItemIds, UserID,Note)
	if ret="-1001" q "-1^医嘱ID不能为空"
	q ret
}

/// w ##class(web.DHCAntCVReportLink).SaveOrDelTransOrd("1||10000000019||1","293||1,293||2",1)
ClassMethod SaveOrDelTransOrd(reportID = "", AddIds = "", DelIds, UserID = "", Note = "")
{
	if reportID["||REEXAMINE" { //复查 为了方便 使用的还是医生站医嘱录入 只是在传过去的危急值ID后面拼了个||REEXAMINE 作为标志
		s reportID=$p(reportID,"||REEXAMINE",1)
		q ..SaveReexamine(reportID,AddIds,UserID,Note)
	}
	
	if AddIds'="" {
		s ret=..Save(reportID, "1",AddIds, UserID,Note)
	}
	if DelIds'="" {
		s len=$l(DelIds,",")
		for i=1:1:len{
			s oneDelId=$p(DelIds,",",i)
			d ..DeleteByObjectId(reportID,"1",oneDelId,UserID)
		}
	}
	
	
	q 1
}

ClassMethod DeleteByObjectId(reportID, lkType, ObjectId, UserID = "")
{
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) "-1^危急值报告ID不正确"_reportID
	if lkType="" q "-1^类型不能为空"
	if ObjectId="" q "-1^链接对象业务ID为空"
	
	s lkOrder=0
	for {
		s lkOrder=$o(^DHCAntCVReport(0,"LKOBJID",ObjectId,lkType,repType,repLabno,repOrder,lkOrder))
		q:lkOrder=""
		s lkID=reportID_"||"_lkOrder
		s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
		continue:$p(lkInfo,"\",7)="D" //已删除
		d ..UpdateStatus(lkID,"D",UserID)
	}
	q 1
}

/// w ##class(web.DHCAntCVReportLink).SaveTransEMR("1||10000000019||1","210||1,211||1",1)
/// 20200513 电子病历要改成危急值与病历多对一关系 reportID可为多个^分隔
ClassMethod SaveTransEMR(reportID = "", InstanceIDs = "", UserID = "")
{
	//s ret=..Save(reportID, "2",InstanceIDs, UserID)
	//if ret="-1001" q "-1^病历ID不能为空"
	//q ret
	q ..SaveEMRLink(reportID,InstanceIDs,UserID,"2")
}

/// 保存病历关联关系
/// Add pLkType 关联类型  原本默认2病历  新增复查病历29 复查病历使用29
ClassMethod SaveEMRLink(reportIDs, InstanceID, UserID, pLkType = "2")
{
	s $zt="Err"
	s pLkType=$s($g(pLkType)="":2,1:pLkType)
	
	k repList,upList,delList
	//addList 危急值报告ID列表
	//upList 更新列表 原来就有的关联关系 更新下时间
	//delList 删除列表 原来有的关联关系现在去掉 ( 1.报告ID关联记录的ObjID不是传的InstanceID 2.InstanceID查到关联记录不在reportID参数中)
	s len=$l(reportIDs,"^")
	for i=1:1:len {
		s reportID=$p(reportIDs,"^",i)
		s repType=$p(reportID,"||",1)
		s repLabno=$p(reportID,"||",2)
		s repOrder=$p(reportID,"||",3)
		continue:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder)))
		s repList(reportID)=""
		
		s lkOrder=0
		for{
			s lkOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder))
			q:lkOrder=""
			s lkID=reportID_"||"_lkOrder
			s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
			continue:$p(lkInfo,"\",1)'=pLkType
			continue:$p(lkInfo,"\",7)="D" //已删除的不再操作
			if $p(lkInfo,"\",2)=InstanceID { //已存在的且InstanceID一致更新时间
				s upList(lkID)=reportID 
			}elseif InstanceID=""{ //病历删除时 调用危急值接口时  是reportID传危急值ID，InstanceID传空 20221011
				s delList(lkID)=reportID
			}else{ //InstanceID不一致 删除   
				//新的转科模式需要再写病历模式下 可以出现1个危急值ID 多个病历情况  2021-11-03
				//s delList(lkID)=reportID
				
			}
		}
	}
	if InstanceID'="",reportIDs="" {   //reportIDs为空才删除
		s repType=""
		for {
			s repType=$o(^DHCAntCVReport(0,"LKOBJID",InstanceID,pLkType,repType))
			q:repType=""
			s repLabno=""
			for {
				s repLabno=$o(^DHCAntCVReport(0,"LKOBJID",InstanceID,pLkType,repType,repLabno))
				q:repLabno=""
				s repOrder=""
				for {
					s repOrder=$o(^DHCAntCVReport(0,"LKOBJID",InstanceID,pLkType,repType,repLabno,repOrder))
					q:repOrder=""
					s reportID=repType_"||"_repLabno_"||"_repOrder
					if '$d(repList(reportID)) { //此次入参reportIDs不包含 则删除此关联关系
						s lkOrder=0
						for {
							s lkOrder=$o(^DHCAntCVReport(0,"LKOBJID",InstanceID,pLkType,repType,repLabno,repOrder,lkOrder))
							q:lkOrder=""
							s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
							continue:$p(lkInfo,"\",7)="D" //已删除的不再操作
							s lkID=reportID_"||"_lkOrder
							s delList(lkID)=reportID
						}
					}
				}
			}
		}
	}
	
	TS
	s hasAffOp=0
	s lkID="",ret=1
	for {
		s lkID=$o(delList(lkID))
		q:lkID=""
		s ret=..UpdateStatus(lkID,"D",UserID)
		if ret'=1 q
		s hasAffOp=1
	}
	if ret'=1 {
		tro 
		q ret
	}
	
	s lkID="",ret=1
	for {
		s lkID=$o(upList(lkID))
		q:lkID=""
		s ret=..UpdateStatus(lkID,"N",UserID)
		k repList(upList(lkID)) //更新的 也就是还存在关联关系 不需要再新增关联关系
		if ret'=1 q
		s hasAffOp=1
	}
	if ret'=1 {
		tro 
		q ret
	}
	
	if InstanceID'="" { //InstanceID 不为空才会可能有新增
		s reportID="",ret=1
		for {
			s reportID=$o(repList(reportID))
			q:reportID=""
			s ret=..Save(reportID,pLkType,InstanceID,UserID,"","","")
			if ret'=1 q
			s hasAffOp=1
		}
		if ret'=1 {
			tro 
			q ret
		}
	}
	tc
	
	
	if InstanceID'="",##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCAntCVResult||OnSaveEMR") {
		s reportID=""
		for {
			s reportID=$o(repList(reportID))
			q:reportID=""
			d ##class(web.DHCAntCVResult).OnSaveEMR(reportID,UserID)
		}	
	}
	
	
	
	if hasAffOp=1 q ret
	else  q "-1^没有有效的记录"
Err
	tro
	q "-1^"_$ze
}

/// w ##class(web.DHCAntCVReportLink).SaveTransRead("1||10000000019||1",1)
/// 打开处理界面认为已读
ClassMethod SaveTransRead(reportID = "", UserID = "")
{
	s ret=..Save(reportID, "3",UserID, UserID)
	if ret="-1001" q "-1^用户ID不能为空"
	q ret
}

/// w ##class(web.DHCAntCVReportLink).SaveFirstRead("1||10000000019||1",1)
ClassMethod SaveFirstRead(reportID = "", UserID = "")
{
	s hasRead=..HasTransRead(reportID)
	if hasRead>0 q "-1^已读"
	q ..SaveTransRead(reportID,UserID)
}

/// w ##class(web.DHCAntCVReportLink).SaveNoticeDoctor("1||10000000019||1","张三",1)
ClassMethod SaveNoticeDoctor(reportID = "", DoctorName = "", UserID = "")
{
	q:DoctorName="" "-1^通知的医生姓名不能为空"
	s ret=..Save(reportID,"4",UserID,UserID,DoctorName)
	q ret
}

/// 接收
ClassMethod SaveTransReceive(reportID = "", UserID = "")
{
	s hasReceive=..HasTransReceive(reportID)
	if hasReceive>0 q "-1^已接收"
	s ret=..Save(reportID, "5",UserID, UserID)
	if ret="-1001" q "-1^用户ID不能为空"
	q ret
}

/// 撤销危急值
ClassMethod SaveCancelInfo(reportID = "", Date = "", Time = "", UserID = "", Note = "")
{
	s ret=..Save(reportID,"6",UserID,UserID,Note,Date,Time)
	q ret
}

/// 更新状态
ClassMethod UpdateStatus(lkID, Status, UserID)
{
	if UserID="",$d(%session) s UserID=%session.Get("LOGON.USERID")
	if UserID="" q "-1^UserID为空"
	if '$d(^SSU("SSUSR",UserID)) q "-1^UserID="_UserID_"不正确"
	s SessLoc=""
	if $d(%session) s SessLoc=%session.Get("LOGON.CTLOCID")
	
	s ret="-1^未知错误"
	s obj=##class(User.DHCAntCVReportLink).%OpenId(lkID)
	if $IsObject(obj){
		s obj.DPRLStatus=Status
		s obj.DPRLUpdateDate=+$h
		s obj.DPRLUpdateTime=+$p($h,",",2)
		s obj.DPRLUpdateUserID=UserID
		s obj.DPRLUpdateLoc=SessLoc
		s sc=obj.%Save()
		if $$$ISERR(sc){
			s ret= "-1^"_$system.Status.GetErrorText(sc)	
		}else{
			s ret=1	
		}
	}
	s obj=""
	q ret
}

/// 增加OtherInfo 参数 2019-3-4
ClassMethod Save(reportID = "", lkType = "", lkObjIDs = "", UserID = "", OtherInfo = "", lkDate = "", lkTime = "", Output ID)
{
	if UserID="",$d(%session) s UserID=%session.Get("LOGON.USERID")
	if UserID="" q "-1^UserID为空"
	if '$d(^SSU("SSUSR",UserID)) q "-1^UserID="_UserID_"不正确"
	
	s SessLoc=""
	if $d(%session) s SessLoc=%session.Get("LOGON.CTLOCID")
	s ID=""
	s OtherInfo=$tr(OtherInfo,"^\","") //把OtherInfo中的\和^ 都替换掉
	s $zt="Err"
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) "-1^错误的危急值ID"
	s len=$l(lkObjIDs,",")
	s startLkOrder=$i(^DHCAntCVReport(repType,repLabno,repOrder,"LK"))
	s endLkOrder=startLkOrder+len-1
	s ^DHCAntCVReport(repType,repLabno,repOrder,"LK")=endLkOrder
	if lkDate["-" s lkDate=$zdh(lkDate,3)
	if lkDate["/" s lkDate=$zdh(lkDate,4)
	if lkDate="" s lkDate=+$h
	if lkTime[":" s lkTime=$zth(lkTime)
	if lkTime="" s lkTime=$p($h,",",2)
	TS
	s ret="",cnt=0
	for i=1:1:len{
		s lkObjID=$p(lkObjIDs,",",i)
		continue:lkObjID=""
		s lkOrder=startLkOrder+i-1
		s obj=##class(User.DHCAntCVReportLink).%New(reportID)
		d obj.DPRLParRefSetObjectId(reportID)
		s obj.DPRLOrder=lkOrder
		s obj.DPRLType=lkType
		s obj.DPRLObjID=lkObjID
		s obj.DPRLDate=lkDate
		s obj.DPRLTime=lkTime
		s obj.DPRLUserID=UserID
		s obj.DPRLOtherInfo=OtherInfo
		
		///add 20200513
		s obj.DPRLStatus="N"
		s obj.DPRLUpdateDate=+$h
		s obj.DPRLUpdateTime=+$p($h,",",2)
		s obj.DPRLUpdateUserID=UserID
		/// add 20210311
		s obj.DPRLLoc=SessLoc
		s obj.DPRLUpdateLoc=SessLoc
		
		s sc=obj.%Save()
		if $$$ISERR(sc){
			s ret="-1^保存失败,"_$system.Status.GetErrorText(sc)
			s obj=""
			q 
		}
		s cnt=cnt+1
		s ID=ID_$s(ID="":"",1:",")_obj.%Id()
		s obj=""
	}
	if ret'=""{
		tro
		s ID=""
		q ret
	}else{
		tc:$tlevel
		if cnt>0 q 1
		else  q "-1001"
	}
Err
	tro
	s ID=""
	q "-1^未知程序错误,"_$ze
}

/// d ##class(%ResultSet).RunQuery("web.DHCAntCVReportLink","FindOrd","1||10000000019||1")
Query FindOrd(reportID = "", opType = "") As websys.Query(CONTAINID = 1, ROWSPEC = "lkID,ordItm,ordDesc,ordDoctorName,ordLocDesc,ordDateTime,ordExecNurseName,ordExecDateTime")
{
}

ClassMethod FindOrdExecute(ByRef QHandle As %Library.Binary, reportID = "", opType = "") As %Library.Status
{
 	s repid=$I(^CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
	
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) $$$OK
	
	s useTrans=0,langId=20
	if $d(%session),%session.Get("LOGON.LANGID")>0 s useTrans=1,langId=%session.Get("LOGON.LANGID")
	
	
	s plkType=1
	if opType="Ree" s plkType="26"
	if opType="ALL" s plkType=""
	
	for lkType="1","26" {
		continue:(plkType'="")&&(plkType'=lkType)
		s lkOrder=0
		for{
			s lkOrder=$o(^DHCAntCVReport(0,"LKTYPE",repType,repLabno,repOrder,lkType,lkOrder))   //$o(^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder))
			q:lkOrder=""
			s lkID=reportID_"||"_lkOrder
			s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
			//s lkType=$p(lkInfo,"\",1)
			//continue:lkType'=1
			continue:$p(lkInfo,"\",7)="D" //已删除
			s ordItm=$p(lkInfo,"\",2)
			s ordPar=+ordItm
			s ordSub=$p(ordItm,"||",2)
			s arcim=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",2)
			s arcimdesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
			s ordDesc=arcimdesc
			
			s ordDoctorName="",ordDoctorUserDr=""
			i $d(^OEORD(ordPar,"I",ordSub,1)){
				s DoctorDr=$p(^OEORD(ordPar,"I",ordSub,1),"^",11)
				if DoctorDr>0 s ordDoctorName=$p(^CTPCP(DoctorDr,1),"^",2),ordDoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
			}
			s ordLocDesc=""
			s ordLoc = $p($g(^OEORD(ordPar,"I",ordSub,7)),"^",2)
			s:+ordLoc>0 ordLocDesc = $P($g(^CTLOC(ordLoc)),"^",2)
			if ordLocDesc["-" s ordLocDesc=$p(ordLocDesc,"-",2)
			
			s ordDate=$p($g(^OEORD(ordPar,"I",ordSub,3)),"^",7)
			s ordTime=$p(^OEORD(ordPar,"I",ordSub,1),"^",17)
			s ordDateTime=$zd(ordDate,3)_" "_$zt(ordTime)
			
			s (ordExecNurseName,ordExecNurseUserDr,ordExecDate,ordExecTime,ordExecDateTime)=""
			
			if useTrans {
				d TransData
			}
			
			d outputrow
		}
	}
	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
TransData
	s ordDesc=##class(web.DHCAntCVComm).GetTranByDesc("User.ARCItmMast","ARCIMDesc",ordDesc,langId)
	s ordDoctorName=##class(web.DHCAntCVComm).GetTranByDesc("User.CTCareProv","CTPCPDesc",ordDoctorName,langId)
	s ordLocDesc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",ordLocDesc,langId)
	q
	
outputrow
	Set ^CacheTemp(repid,ind)=$lb(lkID,ordItm,ordDesc,ordDoctorName,ordLocDesc,ordDateTime,ordExecNurseName,ordExecDateTime)
	Set ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCAntCVReportLink","FindEMR","1||10000000019||1")
Query FindEMR(reportID = "", emrType = "") As websys.Query(CONTAINID = 1, ROWSPEC = "lkID,insID,insTitle,insCreateUserName,insCreateDateTime,insAdm")
{
}

ClassMethod FindEMRExecute(ByRef QHandle As %Library.Binary, reportID = "", emrType = "") As %Library.Status
{
 	s repid=$I(^CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
	
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) $$$OK
	
	s useTrans=0,langId=20
	if $d(%session),%session.Get("LOGON.LANGID")>0 s useTrans=1,langId=%session.Get("LOGON.LANGID")
	
	s plkType=2
	if emrType="ReeEMR" s plkType="29"
	if emrType="ZQTYS" s plkType="51"
	if emrType="ALL" s plkType=""  //所有病例的
	
	for lkType="2","29","51" {
		continue:(plkType'="")&&(plkType'=lkType)
		s lkOrder=0
		for{
			s lkOrder=$o(^DHCAntCVReport(0,"LKTYPE",repType,repLabno,repOrder,lkType,lkOrder))  //$o(^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder))
			q:lkOrder=""
			s lkID=reportID_"||"_lkOrder
			s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
			//s lkType=$p(lkInfo,"\",1)
			//continue:lkType'=2
			continue:$p(lkInfo,"\",7)="D" //已删除
			s insID=$p(lkInfo,"\",2)
			s objInstance=##class(EMRinstance.InstanceData).%OpenId(insID,0)
			if '$IsObject(objInstance) continue
			
			s (insCreateDate,insCreateTime,insCreateDateTime,insCreateUser,insCreateUserName,insTitle,insAdm)=""
			s insCreateDate=objInstance.CreateDate
			s insCreateTime=objInstance.CreateTime
			s insCreateDateTime=$zd(insCreateDate,3)_" "_$zt(insCreateTime)
			s insCreateUser=objInstance.CreateUser
			if insCreateUser>0 s insCreateUserName=$p($g(^SSU("SSUSR",insCreateUser)),"^",2)
			s insTitle=objInstance.Title
			s insAdm=objInstance.EpisodeID
			s objInstance=""
			
			if useTrans {
				d TransData
			}
			
			d outputrow
		}
	}
	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
	
TransData
	s insCreateUserName=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",insCreateUserName,langId)
	q	
	
outputrow
	Set ^CacheTemp(repid,ind)=$lb(lkID,insID,insTitle,insCreateUserName,insCreateDateTime,insAdm)
	Set ind=ind+1
	q
}

/// w ##class(web.DHCAntCVReportLink).HasTransOrd("1||10000000019||1")
ClassMethod HasTransOrd(reportID = "")
{
	q ..HasLink(reportID,"1")
}

/// /// w ##class(web.DHCAntCVReportLink).HasTransEMR("1||10000000019||1")
ClassMethod HasTransEMR(reportID = "", stDateTime = "")
{
	q ..HasLink(reportID,"2", stDateTime )
}

/// 是否有读记录
ClassMethod HasTransRead(reportID = "")
{
	q ..HasLink(reportID,"3")
}

/// 是否有接收记录
ClassMethod HasTransReceive(reportID = "")
{
	q ..HasLink(reportID,"5")
}

ClassMethod HasLink(reportID = "", lkType = "", stDateTime = "")
{
	s stDate=$p(stDateTime,",",1),stTime=$p(stDateTime,",",2)
	s flag=0
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) flag
	
	if lkType'="",$d(^DHCAntCVReport(0,"LKTYPE")) {
		s lkOrder=""
		for{
			s lkOrder=$o(^DHCAntCVReport(0,"LKTYPE",repType,repLabno,repOrder,lkType,lkOrder))
			q:(lkOrder="")||(flag=1)
			continue:lkOrder=0
			
			s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
			continue:$p(lkInfo,"\",7)="D"
			
			if stDateTime="" s flag=1  q
			s lkDate=$p(lkInfo,"\",4)
			s lkTime=$p(lkInfo,"\",5)
			if (lkDate>stDate)||((lkDate=stDate)&&(lkTime>stTime)) s flag=1  q
			
		}
		q flag
		
	}else {
		s lkOrder=""
		for{
			s lkOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder))
			q:(lkOrder="")||(flag=1)
			continue:lkOrder=0
			s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
			continue:$p(lkInfo,"\",7)="D"
			if (lkType="")||(lkType=$p(lkInfo,"\",1)) {
				if stDateTime="" s flag=1  q
				s lkDate=$p(lkInfo,"\",4)
				s lkTime=$p(lkInfo,"\",5)
				if (lkDate>stDate)||((lkDate=stDate)&&(lkTime>stTime)) s flag=1  q
			}
		}
		q flag
	}
	
	
	
	s lkOrder=0
	for{
		s lkOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder))
		q:(lkOrder="")||(flag=1)
		s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
		continue:$p(lkInfo,"\",7)="D"
		if (lkType="")||(lkType=$p(lkInfo,"\",1)) {
			if stDateTime="" s flag=1  q
			
		}
	}
	q flag
}

ClassMethod GetFirstLink(reportID = "", lkType = "", lkObjId = "")
{
	q ..GetFirstOrLastLink(reportID,lkType,1,lkObjId)
}

/// 增加 lkObjId
ClassMethod GetFirstOrLastLink(reportID, lkType, orderDir = "1", lkObjId = "", stDateTime = "")
{
	s stDate=$p(stDateTime,",",1),stTime=$p(stDateTime,",",2)
	s flag=0,ret=""
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) ret
	
	if lkType'="",$d(^DHCAntCVReport(0,"LKTYPE")) {
		s lkOrder=""
		for{
			s lkOrder=$o(^DHCAntCVReport(0,"LKTYPE",repType,repLabno,repOrder,lkType,lkOrder),orderDir)
			q:(lkOrder="")||(flag=1)
			continue:lkOrder=0
			s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
			continue:$p(lkInfo,"\",7)="D"
				s lkID=repType_"||"_repLabno_"||"_repOrder_"||"_lkOrder
				s lkObjID=$p(lkInfo,"\",2)
				continue:(lkObjId'="")&&(lkObjId'=lkObjID)  //过滤objid
				s lkUserID=$p(lkInfo,"\",3)
				s lkDate=$p(lkInfo,"\",4)
				s lkTime=$p(lkInfo,"\",5)
				
				if (stDateTime="")||(lkDate>stDate)||((lkDate=stDate)&&(lkTime>stTime)) {
					s lkOtherInfo=$p(lkInfo,"\",6)
					s lkLoc=$p(lkInfo,"\",11)
					s ret=lkObjID_"^"_lkUserID_"^"_lkDate_"^"_lkTime_"^"_lkOtherInfo_"^"_lkID_"^"_lkLoc
					s flag=1
					q
				}
				

			
		}
		q ret
		
	}else {
		s lkOrder=""
		for{
			s lkOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder),orderDir)
			q:(lkOrder="")||(flag=1)
			continue:lkOrder=0
			s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
			continue:$p(lkInfo,"\",7)="D"
			if (lkType="")||(lkType=$p(lkInfo,"\",1)) {
				s lkID=repType_"||"_repLabno_"||"_repOrder_"||"_lkOrder
				s lkObjID=$p(lkInfo,"\",2)
				continue:(lkObjId'="")&&(lkObjId'=lkObjID)  //过滤objid
				s lkUserID=$p(lkInfo,"\",3)
				s lkDate=$p(lkInfo,"\",4)
				s lkTime=$p(lkInfo,"\",5)
				if (stDateTime="")||(lkDate>stDate)||((lkDate=stDate)&&(lkTime>stTime)) {
					s lkOtherInfo=$p(lkInfo,"\",6)
					s lkLoc=$p(lkInfo,"\",11)
					s ret=lkObjID_"^"_lkUserID_"^"_lkDate_"^"_lkTime_"^"_lkOtherInfo_"^"_lkID_"^"_lkLoc
					s flag=1
					q
				}
			}
		}
		q ret
	}
}

ClassMethod GetLastLink(reportID, lkType, lkObjId = "", stDateTime = "")
{
	q ..GetFirstOrLastLink(reportID,lkType,-1,lkObjId,stDateTime)
}

ClassMethod GetFirstRead(reportID = "")
{
	q ..GetFirstLink(reportID,3)
}

ClassMethod GetFirstNoticeDoctor(reportID = "")
{
	q ..GetFirstLink(reportID,4)
}

ClassMethod GetFirstReceive(reportID = "")
{
	q ..GetFirstLink(reportID,5)
}

ClassMethod GetFirstCancel(reportID = "")
{
	q ..GetFirstLink(reportID,6)
}

/// ObjID 是不是某类型关联
ClassMethod IsLink(lkType = "", lkObjID = "")
{
	q:(lkType="")||(lkObjID="") 0
	q:'$d(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType)) 0
	s reportIDs=""
	s repType=""
	for {
		s repType=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType,repType))
		q:repType=""
		s repLabno=""
		for {
			s repLabno=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType,repType,repLabno))
			q:repLabno=""
			s repOrder=""
			for {
				s repOrder=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType,repType,repLabno,repOrder))
				q:repOrder=""
				s reportID=repType_"||"_repLabno_"||"_repOrder
				
				s lkOrder=0,isLink=0
				for {
					s lkOrder=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType,repType,repLabno,repOrder,lkOrder))
					q:lkOrder=""
					s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
					continue:$p(lkInfo,"\",7)="D" //已删除的不再操作
					s reportIDs=reportIDs_$s(reportIDs'="":"$",1:"")_reportID
					q
				}
			}
		}
	}
	if reportIDs'="" q "1^"_reportIDs
	q 0
}

/// w ##class(web.DHCAntCVReportLink).IsTransOrd("293||1")
ClassMethod IsTransOrd(OEOrdItemId = "")
{
	q ..IsLink(1,OEOrdItemId)
}

/// w ##class(web.DHCAntCVReportLink).IsTransEMR("210||1")
ClassMethod IsTransEMR(InstanceID = "")
{
	q ..IsLink(2,InstanceID)
}

/// 患者短信发送记录
/// w ##class(web.DHCAntCVReportLink).SavePatSMS("2||94--32||1",1,1)
/// Flag 1成功 0失败 
ClassMethod SavePatSMS(reportID = "", Flag = "", UserID = "", OtherInfo = "")
{
	s ret=..Save(reportID, "23",Flag, UserID,OtherInfo)
	q ret
}

/// 获取患者短信发送记录
/// w ##class(web.DHCAntCVReportLink).GetLastPatSMS("1||10000000019||1")
/// lkObjID_"^"_lkUserID_"^"_lkDate_"^"_lkTime_"^"_lkOtherInfo
ClassMethod GetLastPatSMS(reportID = "")
{
	q ..GetLastLink(reportID,23)
}

/// 第三方用户确认收到处理回传消息
ClassMethod SaveTPSConfirmExec(reportID, UserID)
{
	if ..HasLink(reportID,"40") q "-1^已确认"
	s ret=..Save(reportID, "40",UserID, UserID)
	if ret="-1001" q "-1^用户ID不能为空"
	q ret
}

ClassMethod GetFirstTPSConfirmExec(reportID)
{
	q ..GetFirstLink(reportID,"40")
}

ClassMethod SaveNurEmr(reportID = "", NurEmrID = "", UserID = "")
{
	s ret=..Save(reportID, "22",NurEmrID, UserID)
	if ret="-1001" q "-1^护理病历ID为空"
	q ret
}

ClassMethod GetFirstNurEmr(reportID = "")
{
	q ..GetFirstLink(reportID,22)
}

/// 会诊
ClassMethod SaveTransConsultation(reportID = "", CstID = "", UserID = "")
{
	s ret=..Save(reportID, "25",CstID, UserID)
	if ret="-1001" q "-1^会诊ID为空"
	q ret
}

/// 复查
ClassMethod SaveReexamine(reportID = "", OEOrdItemIds = "", UserID = "", Note = "")
{
	s ret=..Save(reportID, "26",OEOrdItemIds, UserID,Note)
	if ret="-1001" q "-1^复查医嘱ID为空"
	q ret
	
	
#;	//床边危机值 复查  
#;	if ret=1,$p(reportID,"||",1)="88" {
#;		s hrid=$p($p(reportID,"||",2),"-",2)
#;		if hrid>0 s hrret=##class(BSP.CV.BL.HandReport).SaveNeedReexamine(hrid,UserID)
#;	}
#;	//s ^cryze("ree")=$lb(ret,reportID,hrid,UserID,hrret)
#;	
#;	if ret>0 d ##class(web.DHCAntCVReportTrans).StopReePlan(reportID,UserID)
#;	q ret
}

/// w ##class(web.DHCAntCVReportLink).GetFirstReexamine("2||26133--6||1")
ClassMethod GetFirstReexamine(reportID = "")
{
	q ..GetFirstLink(reportID,26)
}

/// w ##class(web.DHCAntCVReportLink).SaveNurRead("1||10000000019||1",1)
/// 护士打开处理界面认为已读
ClassMethod SaveNurRead(reportID = "", UserID = "")
{
	s ret=..Save(reportID, "27",UserID, UserID)
	if ret="-1001" q "-1^用户ID不能为空"
	q ret
}

ClassMethod HasNurRead(reportID)
{
	q ..HasLink(reportID,"27")
}

/// w ##class(web.DHCAntCVReportLink).SaveFirstNurRead("1||10000000019||1",1)
ClassMethod SaveFirstNurRead(reportID = "", UserID = "")
{
	s hasRead=..HasNurRead(reportID)
	if hasRead>0 q "-1^已读"
	q ..SaveNurRead(reportID,UserID)
}

/// w ##class(web.DHCAntCVReportLink).SaveDocRead("1||10000000019||1",1)
/// 护士打开处理界面认为已读
ClassMethod SaveDocRead(reportID = "", UserID = "")
{
	s ret=..Save(reportID, "28",UserID, UserID)
	if ret="-1001" q "-1^用户ID不能为空"
	q ret
}

ClassMethod HasDocRead(reportID)
{
	q ..HasLink(reportID,"28")
}

/// w ##class(web.DHCAntCVReportLink).SaveFirstDocRead("1||10000000019||1",1)
ClassMethod SaveFirstDocRead(reportID = "", UserID = "")
{
	s hasRead=..HasDocRead(reportID)
	if hasRead>0 q "-1^已读"
	q ..SaveDocRead(reportID,UserID)
}

/// w ##class(web.DHCAntCVReportLink).SaveReexamineEMR("1||10000000019||1","210||1",1)
ClassMethod SaveReexamineEMR(reportID = "", InstanceID = "", UserID = "")
{
	s ret=..SaveEMRLink(reportID,InstanceID,UserID,"29")
	q ret
	
#;	//复查病历记录 置完成
#;	if ret=1 {
#;		d ##class(web.DHCAntCVResult).EndReport(reportID)	
#;		d ##class(web.DHCAntCVReportTrans).StopReePlan(reportID,UserID)
#;	}
#;	q ret
}

ClassMethod SaveReexamineNurEmr(reportID = "", NurEmrID = "", UserID = "")
{
	s ret=..Save(reportID, "30",NurEmrID, UserID)
	if ret="-1001" q "-1^护理病历ID为空"
	q ret
}

ClassMethod GetFirstReexamineNurEmr(reportID = "")
{
	q ..GetFirstLink(reportID,30)
}

ClassMethod SaveSpecial(reportID, SpRCode, UserID, OtherInfo, Output ID)
{
	s ret=..Save(reportID, "31",SpRCode, UserID,OtherInfo,"","",.ID)
	q ret
}

ClassMethod GetLastSpecial(reportID)
{
	q ..GetLastLink(reportID,31)
}

ClassMethod SaveSpecialAudit(reportID, specialID, UserID, OtherInfo)
{
	q ..Save(reportID,32,specialID,UserID,OtherInfo)
}

/// 输血申请
ClassMethod SaveTransBloodApp(reportID = "", AppNo = "", UserID = "")
{
	s ret=..Save(reportID, "33",AppNo, UserID)
	if ret="-1001" q "-1^申请单号为空"
	q ret
}

/// 无需医嘱处理
ClassMethod SaveTransNoOrder(reportID = "", UserID = "")
{
	s ret=..Save(reportID, "34",UserID, UserID)
	if ret="-1001" q "-1^用户ID为空"
	q ret
}

/// 无需医嘱处理
ClassMethod SaveFirstNoOrder(reportID = "", UserID = "")
{
	if ..HasLink(reportID,"34")	q "-1^已有无需医嘱处理记录"
	q ..SaveTransNoOrder(reportID,UserID)
}

/// 危急值 开复查医嘱又报危急值 医生填写病历时 自动将危急值闭环
ClassMethod SaveReCVEmr(reportID = "", reReportID = "", UserID = "")
{
	s ret=..Save(reportID, "35",reReportID, UserID)
	if ret="-1001" q "-1^用户ID为空"
	q ret
}

ClassMethod SaveReePlan(reportID, planid, note, UserID)
{
	s ret=..Save(reportID, "36",planid , UserID,note)
	if ret="-1001" q "-1^用户ID为空"
	q ret
}

ClassMethod GetLastReePlan(reportID)
{
	q ..GetLastLink(reportID,"36")
}

ClassMethod SaveReResult(reportID, ordItem, objType, objId, UserID)
{
	s ret=..Save(reportID, "37",ordItem , UserID,objType_"$"_objId)
	if ret="-1001" q "-1^用户ID为空"
	q ret
}

ClassMethod GetLKIDByObjID(lkType, lkObjID, order = 1)
{
	s ret=""
	s repType=""
	for {
		s repType=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType,repType))
		q:repType=""
		q:ret'=""
		s repLabno=""
		for {
			s repLabno=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType,repType,repLabno))
			q:repLabno=""
			q:ret'=""
			s repOrder=""
			for {
				s repOrder=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType,repType,repLabno,repOrder))
				q:repOrder=""
				q:ret'=""
				
				s lkOrder="",isLink=0
				for {
					s lkOrder=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID,lkType,repType,repLabno,repOrder,lkOrder),order)
					q:lkOrder=""
					continue:lkOrder=0
					s lkInfo=^DHCAntCVReport(repType,repLabno,repOrder,"LK",lkOrder)
					continue:$p(lkInfo,"\",7)="D" //已删除的不再操作
					set ret=repType_"||"_repLabno_"||"_repOrder_"||"_lkOrder
					q
				}
			}
		}
	}
	q ret
}

ClassMethod GetLastReeOrdItem(EpisodeID, ArcItmCode = "")
{
	if ArcItmCode="" s ArcItmCode=",QTYZ00047,HLYZ00023,"     //默认 测血糖的
	
	s ordPar=$o(^OEORD(0,"Adm",+EpisodeID,""))   //只查在这一次就诊记录上的医嘱
	q:ordPar="" ""
	
	s ordItemPrefix=ordPar_"||"
	
	s lkObjID=ordItemPrefix
	for {
		s lkObjID=$o(^DHCAntCVReport(0,"LKOBJID",lkObjID))
		q:lkObjID=""
		q:$e(lkObjID,1,$l(ordItemPrefix))'=ordItemPrefix  //肯定这个开头的
		
		s ordSub=$p(lkObjID,"||",2)
		s arcim=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",2)
		s arcimcode=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",1)
		continue:ArcItmCode'[(","_arcimcode_",")
		
		//continue:$d(^DHCAntCVReport(0,"LKOBJID",lkObjID,"37")) //复查结果记录有的不要
		
		if ..IsLink("26",lkObjID)>0 {
			s tempList(ordPar,ordSub)=""
		}
	}
	
	s lastOrdPar=$o(tempList(ordPar,""),-1) //最新的医嘱  id应是最大的 
	if lastOrdPar>0 {
		if ..IsLink("37",ordPar_"||"_lastOrdPar)>0 {  //是否已经关联结果了
			q ""
		}else{
			q ordPar_"||"_lastOrdPar
		}
	}else{
		q ""	
	}
}

ClassMethod SaveReResultByOrdItem(ordItem, objType, objId, userid)
{
	q:ordItem="" "-1^医嘱ID为空"
	s isLink=..IsLink("26",ordItem)
	q:(userid="")||'$d(^SSU("SSUSR",userid)) "-1^操作用户不正确"
	if isLink>0 {
		s reportIDs=$p(isLink,"^",2)
		s len=$l(reportIDs,"$")
		for i=1:1:len {
			s reportID=$p(reportIDs,"$",i)
			s ret=..SaveReResult(reportID,ordItem,objType,objId,userid)
			
		}
		q 1
	}
	q "-1^此医嘱"_ordItem_"不是复查医嘱"
}

/// 保存知情同意书
ClassMethod SaveZQTYS(reportID = "", InstanceIDs = "", UserID = "")
{
	q ..SaveEMRLink(reportID,InstanceIDs,UserID,"51")
}

ClassMethod HasZQTYS(reportID = "")
{
	q ..HasLink(reportID,"51")
}

ClassMethod SaveReePlanNoticeDoc(reportID, userid, doctor, note)
{
	q ..Save(reportID,"52",userid,userid,doctor_"$$"_note)
}

ClassMethod HasReePlanNoticeDoc(reportID)
{
	q ..HasLink(reportID,"52")
}

ClassMethod EndReport(reportID)
{
	
	&sql(
		update SQLUser.DHC_AntCVReport set DPRP_IsEnd=1 where DPRP_RowID=:reportID 
	)
}

/// 重新改为未闭环
ClassMethod RestartReport(reportID)
{
	
	&sql(
		update SQLUser.DHC_AntCVReport set DPRP_IsEnd=0 where DPRP_RowID=:reportID 
	)
}

/// 是否是 复查危急值报告 
/// w ##class(web.DHCAntCVResult).IsReCVReport("1||012081649400||1")
ClassMethod IsReCVReport(reportID)
{
	s repType=$p(reportID,"||",1),repLabno=$p(reportID,"||",2),repOrder=$p(reportID,"||",3)
	s ordItem=$p(^DHCAntCVReport(repType,repLabno,repOrder),"\",14)
	if ordItem'="" {
		s flg=##class(web.DHCAntCVReportLink).IsLink("26",ordItem)
		q flg
	}
	q 0
}

}
