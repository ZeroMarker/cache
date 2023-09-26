Class DHCDoc.DHCDocCure.Assessment Extends DHCDoc.Util.RegisteredObject
{

/// Creator：      nikang
/// CreatDate：    2019-08-30
/// Description:： 查询治疗申请评估信息
/// Table: 		   DHC_DocCureAssessment
/// Input：        DCARowIdStr:治疗申请ID
/// 
Query FindCureAssessmentList(DCARowIdStr As %String) As %Query(ROWSPEC = "DCARowId:%String,DCAssRowId:%String,ArcimDesc:%String,PatientNo:%String,PatientName:%String,ApplyNo:%String,PatOther:%String,DCAssUser:%String,DCAssDate:%String,DCAssContent:%String,DCAssLastUser:%String,DCAssLastDate:%String,DCAssTempID:%String,DCAssAdmID:%String,ApplyStatus:%String,OrdBilled:%String,DCAssTempTitile:%String")
{
}

ClassMethod FindCureAssessmentListExecute(ByRef qHandle As %Binary, DCARowIdStr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Assessment","FindCureAssessmentList",20)
	Set repid=$I(^CacheTemp)
	Set ind=1
	if DCARowIdStr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s langid=..%LanguageID()
	s DCARowIdLen=$l(DCARowIdStr,"^")
	for mycount=1:1:DCARowIdLen{
		d ReverseAss
		s DCARowId=$P(DCARowIdStr,"^",mycount)
		s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+DCARowId)
		continue:CureAppStr=""
		s (ArcimDesc,PatientNo,PatientName,PatOther,ApplyNo)=""
		s (DCAssRowId,DCAssUser,DCAssDate,DCAssContent,DCAssLastUser,DCAssLastDate)=""
		s (ApplyStatus,OrdBilled)=""
		if (CureAppStr'=""){
			s CureAppInfo=$p(CureAppStr,$c(1),2)
			s ArcimDesc=$p(CureAppInfo,"^")
			s ApplyStatus=$p($g(^DHCDocCure(+DCARowId)),"^",3)
			s AdmId=$p(CureAppInfo,"^",16)
			s OrdBilled=$p(CureAppInfo,"^",18)
			s ApplyNo=$p(CureAppInfo,"^",31)
			s PatientInfo=$p(CureAppStr,$c(1),1)
			s PatientNo=$p(PatientInfo,"^",2)
			s PatientName=$p(PatientInfo,"^",3)
			s PatientSex=$p(PatientInfo,"^",4)
			s PatientAge=$p(PatientInfo,"^",5)
			s PatientTel=$p(PatientInfo,"^",25)
			if PatientTel="" s PatientTel="-"
			s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel
		}
		s AssTempStr=..GetAssTemp(+DCARowId)
		s DCAssTempID=$p(AssTempStr,"^",2)
		s DCAssAdmID=$p(AssTempStr,"^",1)
		s AssFlag=0
		s DCAssChildSub=0 
		for{
			s DCAssChildSub=$o(^DHCDocCure(DCARowId,"ASS",DCAssChildSub)) q:DCAssChildSub=""
			s DCAssActiveFlag=$p(^DHCDocCure(DCARowId,"ASS",DCAssChildSub),"^",9)
			continue:DCAssActiveFlag'="Y"
			s DCAssRowId=DCARowId_"||"_DCAssChildSub
			s AssFlag=1
			s DCAssUser="",DCAssDate="",DCAssContent="",DCAssTempID="",DCAssTempTitile=""
			s AssInfo=..GetCureAssessment(DCAssRowId)
			if AssInfo'=""{
				s DCAssUser=$p(AssInfo,"^",1)
				s DCAssDate=$p(AssInfo,"^",2)
				s DCAssLastUser=$p(AssInfo,"^",4)
				s DCAssLastDate=$p(AssInfo,"^",5)
				s DCAssActiveFlag=$p(AssInfo,"^",7)
				s DCAssTempID=$p(AssInfo,"^",10)
				s DCAssTempTitile=$p(AssInfo,"^",12)
			}
			d OutputRowAss
		}
		if AssFlag=0{
			d OutputRowAss
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAss 
	set Data=$lb(DCARowId,DCAssRowId,ArcimDesc,PatientNo,PatientName,ApplyNo,PatOther,DCAssUser,DCAssDate,DCAssContent,DCAssLastUser,DCAssLastDate,DCAssTempID,DCAssAdmID,ApplyStatus,OrdBilled,DCAssTempTitile)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
ReverseAss
	set (DCAssRowId,ArcimDesc,PatientNo,PatientName,ApplyNo,PatOther,DCAssUser,DCAssDate,DCAssContent,DCAssLastUser,DCAssLastDate,DCAssTempID,DCAssAdmID,ApplyStatus,OrdBilled,DCAssTempTitile)=""
	quit
}

ClassMethod FindCureAssessmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureAssessmentListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureAssessmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureAssessmentListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCureAssessment(DCAssRowId As %String, cspName As %String = "doccure.cureassessmentlist.csp")
{
	s langid=..%LanguageID()
	s DCAssData=$g(^DHCDocCure(+DCAssRowId,"ASS",$p(DCAssRowId,"||",2)))
	s DCAssUser=""
	s DCAssActiveFlag=$p(DCAssData,"^",9)
	s DCAssUserDr=$p(DCAssData,"^",1)
	if DCAssUserDr'=""{
		s DCAssUser=$p($g(^SSU("SSUSR",DCAssUserDr)),"^",2)
		s DCAssUser=##class(DHCDoc.Common.Translate).GetTransUser(DCAssUser)
	}
	s DCAssDate=$p(DCAssData,"^",2)
	s DCAssTime=$p(DCAssData,"^",3)
	s DCAssDate=##class(websys.Conversions).DateLogicalToHtml(DCAssDate)
	s:DCAssTime'="" DCAssTime=$zt(DCAssTime,1)
	s DCAssDate=DCAssDate_" "_DCAssTime
	s DCAssContent=$p(DCAssData,"^",4)
	s DCAssLastUser=""
	s DCAssLastUserDr=$p(DCAssData,"^",5)
	if DCAssLastUserDr'=""{
		s DCAssLastUser=$p($g(^SSU("SSUSR",DCAssLastUserDr)),"^",2)
		s DCAssLastUser=##class(DHCDoc.Common.Translate).GetTransUser(DCAssLastUser)
	}
	s DCAssLastDate=$p(DCAssData,"^",6)
	s DCAssLastTime=$p(DCAssData,"^",7)
	s DCAssLastDate=##class(websys.Conversions).DateLogicalToHtml(DCAssLastDate)
	s:DCAssLastTime'="" DCAssLastTime=$zt(DCAssLastTime,1)
	if DCAssLastDate'=""{
		s DCAssLastDate=DCAssLastDate_" "_DCAssLastTime	
	}
	s DCAssUpdateStatus=$p(DCAssData,"^",8)
	s DCAssActiveFlag=$p(DCAssData,"^",9)
	s DCAssOEOrdExecDR=$p(DCAssData,"^",10)
	s DCAssMapID=$p(DCAssData,"^",11)
	s DCAssContentJsonStr=$g(^DHCDocCure(+DCAssRowId,"ASS",$p(DCAssRowId,"||",2),"JsonStr"))
	;s AssTempStr=..GetAssTemp(+DCAssRowId)
	;s AssTempID=+$p(AssTempStr,"^",2)
	;if DCAssMapID'="" s AssTempID=DCAssMapID
	s AssTempID=DCAssMapID
	s AssTempTitle=..%Translate(cspName,"通用评估")
	s:AssTempID'="" AssTempTitle=$P(^DHCDocAppBLMap(AssTempID),"^",2)
	s AssTempTitle=##class(User.DHCDocAppBLMap).GetTranByDesc("APPMapName",AssTempTitle,langid)
	s ArcimDesc=""
	s CureData=$g(^DHCDocCure(+DCAssRowId))
	s OrderId=$p(CureData,"^",2)
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	if ArcimId'=""{
		s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
		s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	}
	
	s ret=DCAssUser_"^"_DCAssDate_"^"_DCAssContent_"^"_DCAssLastUser_"^"_DCAssLastDate
	s ret=ret_"^"_DCAssUpdateStatus_"^"_DCAssActiveFlag_"^"_DCAssOEOrdExecDR_"^"_DCAssContentJsonStr_"^"_AssTempID
	s ret=ret_"^"_ArcimDesc_"^"_AssTempTitle
	Q ret
}

/// 保存治疗记录 
/// RecordAsAss=Y 按照评估方式保存治疗记录，不自动获取原先的治疗记录内容 
/// w ##class(DHCDoc.DHCDocCure.Record).SaveCureRecord(^TMP("SaveCureRecord"))
ClassMethod SaveCureAssBroker(Para As %String, DCRowIDStr As %String = "")
{
	;DCAARowId+"^"+DCRRowId+"^"+OEORERowID_$_DCAARowId+"^"+DCRRowId+"^"+OEORERowID
	s retstr=""
	s len=$l(DCRowIDStr,"$")
	if DCRowIDStr=""{
		s retstr=..SaveCureAssessment(Para)	
		s ret=$replace(retstr,"^",$c(1))
		Q ret
	}
	s RowIDStr=""
	Ts
	for loop=1:1:len{
		s oneIDStr=	$p(DCRowIDStr,"$",loop)
		s DCAARowId=$p(oneIDStr,"^",1)
		s $p(Para,"^",1)=DCAARowId
		
		s ret=..SaveCureAssessment(Para)
		s AssRowID=$p(ret,"^",2)
		s ret=$p(ret,"^",1)
		s msg=""
		if ret="0" s msg=""
		else  s msg="保存失败,错误代码:"_ret	
		if msg'=""{	
			s DCARowId=+DCAARowId

			s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
			s ArcimDesc="",PatientNo="",PatientName=""
			if (CureAppStr'=""){
				s CureAppInfo=$p(CureAppStr,$c(1),2)
				s ArcimDesc=$p(CureAppInfo,"^")
				s PatientInfo=$p(CureAppStr,$c(1),1)
				s PatientNo=$p(PatientInfo,"^",2)
				s PatientName=$p(PatientInfo,"^",3)
			}
			s msg="患者姓名:"_PatientName_",治疗项目"_ArcimDesc_" "_msg
			
			if retstr="" s retstr=msg
			else  s retstr=retstr_";<br>"_msg
			
			Quit
		}else{
			if RowIDStr="" s RowIDStr=AssRowID
			else  s RowIDStr=RowIDStr_"^"_AssRowID
		}
	}
	
	if retstr'=""{
		Tro	
	}else{
		TC	
	}
	
	s ret=retstr_$c(1)_RowIDStr
	Q ret
}

/// w ##class(DHCDoc.DHCDocCure.Assessment).SaveCureAssessment(^TMP("SaveCureAssessment"))
ClassMethod SaveCureAssessment(Para As %String) As %String
{
	s ^TMP("SaveCureAssessment")=Para
	s DCARowId=+$p(Para,"^",1)
	s Rowid=$p(Para,"^",2)
	s Content=$p(Para,"^",3)
	s UserDR=$p(Para,"^",4)
	s OrdExecDR=$p(Para,"^",5)
	s UpdateStatus=$p(Para,"^",6)
	s MapID=$p(Para,"^",7)
	s err=100
	if (Rowid="")&&(DCARowId=""){
		Q err	
	}
	if Rowid="" 
	{
		k PLIST
		s PLIST(0)=DCARowId
		s PLIST(3)=UserDR
		s PLIST(4)=+$h
		s PLIST(5)=$p($h,",",2)
		s PLIST(13)=Content
		s PLIST(10)=UpdateStatus
		s PLIST(11)="Y"
		s PLIST(12)=OrdExecDR
		s PLIST(14)=MapID
	 	&sql(insert into SQLUser.DHC_DocCureAssessment values :PLIST())
	 	s err=SQLCODE
	 	s Rowid=$p(%ROWID,$c(1))
	 	
	 	s CDRPara=+Rowid_"^^"_$g(Rowid)_"^"_"CUREASS"_"^"_UserDR
		Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(CDRPara)
	}else{
		k PLIST
		s PLIST(13)=Content
		s PLIST(7)=UserDR
		s PLIST(8)=+$h
		s PLIST(9)=$p($h,",",2)
		s PLIST(10)=UpdateStatus
		s PLIST(14)=MapID
		&sql(update SQLUser.DHC_DocCureAssessment VALUES :PLIST() WHERE  DCAASS_RowID=:Rowid )
	    s err=SQLCODE
	}
	
  	Q err_"^"_Rowid
}

ClassMethod DelCureAssBatch(RowidStr As %String, UserDR As %String) As %String
{
	s ^TMP("DelCureAssBatch")=RowidStr
	s BrokeMsg=0
	s SucessIDStr=""
	for loop=1:1:$l(RowidStr,"^"){
		s DCAssRowId=$p(RowidStr,"^",loop)
		s ret=..DelCureAssessment(DCAssRowId,UserDR,.ErrMsg)
		if +ret'=0{
			s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(+DCAssRowId)
			s ArcimDesc="",PatientNo="",PatientName=""
			if (CureAppStr'=""){
				s CureAppInfo=$p(CureAppStr,$c(1),2)
				s ArcimDesc=$p(CureAppInfo,"^")
				s PatientInfo=$p(CureAppStr,$c(1),1)
				s PatientNo=$p(PatientInfo,"^",2)
				s PatientName=$p(PatientInfo,"^",3)
			}
			s DCAssDate=$p($g(^DHCDocCure(+DCAssRowId,"ASS",$p(DCAssRowId,"||",2))),"^",2)
			s DCAssTime=$p($g(^DHCDocCure(+DCAssRowId,"ASS",$p(DCAssRowId,"||",2))),"^",3)
			s DCAssDate=##class(websys.Conversions).DateLogicalToHtml(DCAssDate)
			s:DCAssTime'="" DCAssTime=$zt(DCAssTime,1)
			s DCAssDate=DCAssDate_" "_DCAssTime
			s BrokeMsg=PatientName_" "_ArcimDesc_" "_DCAssDate_",评估记录删除失败:"_ErrMsg
			q	
		}else{
			if SucessIDStr=""{
				s SucessIDStr=DCAssRowId
			}else{
				s SucessIDStr=SucessIDStr_"^"_DCAssRowId	
			}	
		}
	}
	Q BrokeMsg_$c(1)_SucessIDStr
}

ClassMethod DelCureAssessment(Rowid As %String, UserDR As %String, ByRef ErrMsg As %String = "") As %String
{
	s ^TMP("SaveCureAssessment")=Rowid

	s err=100
	if (Rowid=""){
		s ErrMsg="必要参数为空"
		Q err	
	}

	s DCAssUserDr=$p($g(^DHCDocCure(+Rowid,"ASS",$p(Rowid,"||",2))),"^",1)
	if UserDR'=DCAssUserDr{
		s ErrMsg="非本人新增的评估记录不允许删除"
		Q "101"	
	}

	k PLIST
	s PLIST(7)=UserDR
	s PLIST(8)=+$h
	s PLIST(9)=$p($h,",",2)
	s PLIST(11)="N"
	&sql(update SQLUser.DHC_DocCureAssessment VALUES :PLIST() WHERE  DCAASS_RowID=:Rowid )
	s err=SQLCODE
	if 'err{
		s CDRPara=+Rowid_"^^"_$g(Rowid)_"^"_"CURECASS"_"^"_UserDR
		Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(CDRPara)
	}else{
		s ErrMsg="删除失败,错误代码:"_err  
	}

	Q err
}

/// Add Date :20200611
/// 以下为新版治疗评估功能
/// 包含维护评估模板功能，维护功能同新版病理申请单维护功能
/// 
/// d ##class(DHCDoc.DHCDocCure.Assessment).GetCacheMap(MapID,.CacheMapRowIDStr,.CacheMapIDStr)
ClassMethod GetCacheMap(MapID, ByRef CacheMapRowIDStr, ByRef CacheMapIDStr, ByRef BLIDStr)
{
	s MapStr=$P(^DHCDocAppBLMap(MapID),"^",3)
	s i=1
	s CacheMapRowIDStr=""
	s CacheMapIDStr=""
	s BLIDStr=""
	for{
		s RowID=$P(MapStr,"||",i)
		q:RowID=""
		s i=i+1
		s BLContentDesc=$P(^DHCDocBLTem(RowID),"^",1)
		s BLContentText=$g(^DHCDocBLTem(RowID,"ConT"))
		s BLID=$P(^DHCDocBLTem(RowID),"^",3)
		s BLIDItemRowid=$O(^DHCDocAppBLItemi("BLTemp",RowID, 0))
		
		if (BLIDItemRowid=""){
			if (CacheMapRowIDStr="") s CacheMapRowIDStr=RowID  
			e  s CacheMapRowIDStr=CacheMapRowIDStr_"^"_RowID
			if (CacheMapIDStr="") s CacheMapIDStr=BLID  
			e  s CacheMapIDStr=CacheMapIDStr_"^"_BLID
		}
		w !,BLContentText
		s InitFunFlag=0
		if ($g(^DHCDocBLTem(RowID,"JSStr"))'=""){
			w "<script type='text/javascript' src='../"_$g(^DHCDocBLTem(RowID,"JSStr"))_"'></script>"
			s InitFunFlag=1
		}
		
		if (BLIDStr="") s BLIDStr=BLID_$c(1)_InitFunFlag
		e  s BLIDStr=BLIDStr_"^"_BLID_$c(1)_InitFunFlag
	}
	q 0
}

/// 得到模板缓存的元素
/// w ##class(DHCDoc.DHCDocCure.Assessment).GetCacheItem(17)
ClassMethod GetCacheItem(MapID As %String)
{
	s Str=""
	s MapStr=$P($g(^DHCDocAppBLMap(MapID)),"^",3)
	for i=1:1:$l(MapStr,"||"){
		s RowID=$P(MapStr,"||",i)
		q:RowID=""
		s BLIDItemRowid=""
		for{
			s BLIDItemRowid=$O(^DHCDocAppBLItemi("BLTemp",RowID, BLIDItemRowid))
			Q:BLIDItemRowid=""
			s BLIDItemCode=$p(^DHCDocAppBLItem(BLIDItemRowid),"^",1)
			continue:(BLIDItemCode="EndAss_DateTime")  ;时间存为模板时不保存
			if Str="" s Str=BLIDItemCode
		 	else  s Str=Str_"^"_BLIDItemCode
		}
	}
	
	q Str
}

/// 按模板类型及操作类型保存模板内容
ClassMethod SaveAssTemplate(MapID, Type, JsonStr, UserID)
{
	if (UserID="")&&($d(%session)){
		s UserID=%session.Get("LOGON.USERID")
	}
	&SQL(Insert Into SQLUser.DHC_DocCureAssTemplate(DCAss_TempType,DCAss_TempSubType,DCAss_TempJsonStr,DCAss_TempUserDr)
		values(:MapID,:Type,:JsonStr,:UserID))
		
	s Rowid=+%ROWID 
	q SQLCODE_"^"_Rowid
}

/// 按模板类型及操作类型获取模板内容
/// w ##class(DHCDoc.DHCDocCure.Assessment).GetAssTemplate("17","NC")
ClassMethod GetAssTemplate(MapID, Type, UserID As %String = "")
{
	if (UserID="")&&($d(%session)){
		s UserID=%session.Get("LOGON.USERID")
	}
	s JsonStr=""
	if UserID'=""{
		s Rowid=$o(^DHCDocCureAssTempi("UserType",UserID,MapID,Type,""),-1)
	}
	s:Rowid="" Rowid=$o(^DHCDocCureAssTempi("Type",MapID,Type,""),-1)
	if Rowid'=""{
		s JsonStr=$g(^DHCDocCureAssTemp(Rowid,"JsonStr"))
	}
	Q JsonStr
}

/// 根据治疗申请获取对应的医嘱项名称信息
/// w ##class(DHCDoc.DHCDocCure.Assessment).GetArcimDesc("2||1","")
ClassMethod GetArcimDesc(DCRowIDStr)
{
	s ^tmpnk("GetArcimDesc")=DCRowIDStr
	s ret=""
	s count=$l(DCRowIDStr,"$")
	for i=1:1:count{
		s OEORIRowID=""
		s aRowIDStr=$p(DCRowIDStr,"$",i)
		s DCAARowId=$p(aRowIDStr,"^",1)
		s DCRRowId=$p(aRowIDStr,"^",2)
		s OEORERowID=$p(aRowIDStr,"^",3)
		
		if DCRRowId'=""{
			Set Data=$g(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)))
			Set DCAARowId=$p(Data,"^",1)
			Set OEORERowID=$p(Data,"^",2)
		}
		if DCAARowId'=""{
			Set DCARowId=+DCAARowId
			Set CureData=$g(^DHCDocCure(DCARowId))
			Set OEORIRowID=$p(CureData,"^",2)
		}elseif OEORERowID'=""{
			Set OEORIRowID=+OEORERowID_"||"_$P(OEORERowID,"||",2)
		}
		if OEORIRowID'=""{
			Set ArcimId=$p($g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),1)),"^",2)
			Set OrderName=##class(web.DHCDocOrderCommon).GetFormateOrderName(ArcimId)
			if ret="" s ret=OrderName
			else  s ret=ret_","_OrderName
		}
	}
	Q ret
}

/// w ##class(DHCDoc.DHCDocCure.Assessment).GetAssAdmInfo(^tmplog("GetAssAdmInfo"))
ClassMethod GetAssAdmInfo(RowIDs)
{
	s ^tmplog("GetAssAdmInfo")=RowIDs
	k DataArr
	s count=$l(RowIDs,$c(1))
	for i=1:1:count{
		s DCARowId=+$p(RowIDs,$c(1),i)
		continue:DCARowId=""
		s AdmIDStr=##class(DHCDoc.DHCDocCure.Common).GetPatAdmIDByDCA(DCARowId)
		s AdmID=$p(AdmIDStr,"^",1)
		continue:AdmID=""
		s PatientId=$p(AdmIDStr,"^",2)
		if '$d(DataArr(AdmID)){
			s DataArr(AdmID)=DCARowId
		}else{
			s DataArr(AdmID)=DataArr(AdmID)_"^"_DCARowId
		}
	}
	s RetObj={}
	s RetObj.List=[]
	s adm=""
	for{
		s adm=$o(DataArr(adm))
		Q:adm=""	
		s JsonObj={}
		s idstr=DataArr(adm)
		s JsonObj.AssAdmID=adm
		s JsonObj.RowIDStr=idstr
		d RetObj.List.%Push(JsonObj)
	}
	Q RetObj.%ToJSON()
}

/// 根据治疗申请(治疗记录,执行记录)获取治疗评估配置模板
/// w ##class(DHCDoc.DHCDocCure.Assessment).GetAssTempStr(^tmpnk("GetAssTempStr"))
ClassMethod GetAssTempStr(RowIDs)
{
	s ^tmpnk("GetAssTempStr")=RowIDs
	k DataArr
	k NullTempDataArr
	s count=$l(RowIDs,$c(1))
	for i=1:1:count{
		s aRowIDStr=$p(RowIDs,$c(1),i)
		s DCAARowId=$p(aRowIDStr,"^",1)
		s DCRRowId=$p(aRowIDStr,"^",2)
		s OEORERowID=$p(aRowIDStr,"^",3)
		
		s AssTypeStr=..GetAssTemp(DCAARowId, OEORERowID, DCRRowId)
		if AssTypeStr'=""{
			s AssAdmID=$p(AssTypeStr,"^",1)	
			s AssTempID=$p(AssTypeStr,"^",2)
			if AssTempID'=""{
				if '$d(DataArr(AssAdmID,AssTempID)){
					s DataArr(AssAdmID,AssTempID)=aRowIDStr
				}else{
					s DataArr(AssAdmID,AssTempID)=DataArr(AssAdmID,AssTempID)_"$"_aRowIDStr
				}
			}else{
				if '$d(NullTempDataArr(AssAdmID)){
					s NullTempDataArr(AssAdmID)=aRowIDStr
				}else{
					s NullTempDataArr(AssAdmID)=NullTempDataArr(AssAdmID)_"$"_aRowIDStr
				}
			}
		}
	}
	s RetObj={}
	s RetObj.List=[]
	s adm=""
	for{
		s adm=$o(NullTempDataArr(adm))
		Q:adm=""	
		s JsonObj={}
		s idstr=NullTempDataArr(adm)
		s JsonObj.AssAdmID=adm
		s JsonObj.AssTempID=""
		s JsonObj.RowIDStr=idstr
		d RetObj.List.%Push(JsonObj)
	}
	s adm=""
	for{
		s adm=$o(DataArr(adm))
		Q:adm=""	
		s id=""
		for{
			s JsonObj={}
			s id=$o(DataArr(adm,id))
			Q:id=""
			s idstr=DataArr(adm,id)
			s JsonObj.AssAdmID=adm
			s JsonObj.AssTempID=id
			s JsonObj.RowIDStr=idstr
			d RetObj.List.%Push(JsonObj)
		}
	}
	Q RetObj.%ToJSON()
}

/// 根据执行记录或者治疗预约ID  获取对应的治疗评估配置模板
/// w ##class(DHCDoc.DHCDocCure.Assessment).GetAssTemp("617","")
ClassMethod GetAssTemp(DCAARowId As %String, OEORERowID As %String = "", DCRRowId As %String = "")
{
	s ^tmplog("GetAssTemp")=$lb(DCAARowId, OEORERowID,DCRRowId)
	Set ret=""
	Set OEORIRowID=""
	if DCRRowId'=""{
		Set Data=$g(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)))
		Set DCAARowId=$p(Data,"^",1)
		Set OEORERowID=$p(Data,"^",2)
	}
	if DCAARowId'=""{
		Set DCARowId=+DCAARowId
		Set CureData=$g(^DHCDocCure(DCARowId))
		Set AdmID=$p(CureData,"^",1)
		Set OEORIRowID=$p(CureData,"^",2)
	}elseif OEORERowID'=""{
		Set OEORIRowID=+OEORERowID_"||"_$P(OEORERowID,"||",2)
	}
	s HospID=""
	if OEORIRowID'=""{
		Set RelateAssTemp=""
		Set AdmID=$p(^OEORD(+OEORIRowID),"^",1)
		Set ArcimId=$p($g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),1)),"^",2)
		Set OrderRecLocDr=$P($g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),3)),"^",6)
		Set OrderAddDeptDr=$p($g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),7)),"^",2)
		if OrderRecLocDr'="" {
			if HospID=""{
				s HospID=$p($g(^CTLOC(OrderRecLocDr)),"^",22)	
				i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
			}
		}
		
		s CureLocRelateAssTemp=##class(DHCDoc.DHCDocCure.Config).GetCureLocRelateAssTemp(OrderRecLocDr)
		if +CureLocRelateAssTemp>0{
			s RelateAssTemp=CureLocRelateAssTemp
		}else{
			Set DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,HospID)
			if DDCISRowid'=""{
				s RelateAssTemp=##class(DHCDoc.DHCDocCure.CureItemSet).GetRelateTemp(DDCISRowid,"A")
				if RelateAssTemp=""{
					s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
					s SGAssTemp=##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).GetGroupRelateAssTemp(ServiceGroupDR)	
					if SGAssTemp'=""{
						s RelateAssTemp=$p(SGAssTemp,"^",1)
					}
				}
			}
		}
		Set ret=AdmID_"^"_RelateAssTemp
	}
	Q ret
}

ClassMethod GetAssTemplateByDCR(DCRRowId, Type)
{
	s AssTemp=..GetAssTemp("","",DCRRowId)
	s RelateAssTemp=$p(AssTemp,"^",2)
	if RelateAssTemp=""{
		Q ""
	}
	s TempJsonStr=..GetAssTemplate(RelateAssTemp,Type)
	Q TempJsonStr
}

ClassMethod GetDCAssRowID(DCARowId, OrdExecID)
{
	s DCAssRowID=""
	s AssChild=0
	for{
		s AssChild=$o(^DHCDocCure(0,"AssOrdExec",OrdExecID,DCARowId,AssChild))
		Q:AssChild=""
		s DCAssData=$g(^DHCDocCure(+DCARowId,"ASS",AssChild))
		s DCAssActiveFlag=$p(DCAssData,"^",9)
		continue:DCAssActiveFlag'="Y"
		s DCAssRowID=DCARowId_"||"_AssChild
	}
	Q DCAssRowID
}

/// 打印数据提取
/// w ##Class(DHCDoc.DHCDocCure.Assessment).GetAssPrintJson("3970||1")
ClassMethod GetAssPrintJson(AssRowId As %String, UserID As %String = "") As %String
{
	s PrintJson="{}"
	Q:AssRowId="" PrintJson
	
	s ComponentTypeArr(1)="text"
	s ComponentTypeArr(2)="combobox"
	s ComponentTypeArr(3)="radio"
	s ComponentTypeArr(4)="checkbox"
	s ComponentTypeArr(5)="datebox"
	s ComponentTypeArr(6)="numberbox"
	
	k PrintJsonArr
	s DCARowID=+AssRowId
	s PatientInfo=##class(DHCDoc.DHCDocCure.Apply).GetPatientBaseInfo(DCARowID,"")
	d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(PatientInfo,.PrintJsonArr)
	s DCAssContentJsonStr=$g(^DHCDocCure(+AssRowId,"ASS",$p(AssRowId,"||",2),"JsonStr"))
	s DCAssMapID=$p($g(^DHCDocCure(+AssRowId,"ASS",$p(AssRowId,"||",2))),"^",11)
	;s AssTempStr=..GetAssTemp(+AssRowId)
	;s AssTempID=$p(AssTempStr,"^",2)
	;if DCAssMapID'="" s AssTempID=DCAssMapID
	s AssTempID=DCAssMapID
	d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(DCAssContentJsonStr,.AssContentJsonArr)
	
	if AssTempID=""{
		s AssContentArrID=""
		for{
			s AssContentArrID=$o(AssContentJsonArr(AssContentArrID)) Q:AssContentArrID=""
			s AssContentVal=##Class(ext.util.String).EvalJSONNew(AssContentJsonArr(AssContentArrID))
			s PrintJsonArr(AssContentArrID)=AssContentVal
		}
		s AssDateTime=""
		s AssUser=""
		s AssInfo=..GetCureAssessment(AssRowId)
		if AssInfo'=""{
			s AssUser=$p(AssInfo,"^",1)
			s AssDateTime=$p(AssInfo,"^",2)
		}
		
		s PrintJsonArr("Ass_DateTime")=AssDateTime
		s PrintJsonArr("Ass_User")=AssUser
	}else{
		s myType=""
		for{
			s myType=$o(ComponentTypeArr(myType)) Q:myType=""
			s ComponentType=ComponentTypeArr(myType)
			s AssContentArrID=""
			for{
				s AssContentArrID=$o(AssContentJsonArr(AssContentArrID)) Q:AssContentArrID=""
				s AssContentType=$g(AssContentJsonArr(AssContentArrID,"Class"))
				continue:AssContentType'=ComponentType
				s AssContentID=$g(AssContentJsonArr(AssContentArrID,"ID"))
				s AssContentDesc=$g(AssContentJsonArr(AssContentArrID,"Desc"))
				s AssContentVal=$g(AssContentJsonArr(AssContentArrID,"Val"))
				s AssContentVal=##Class(ext.util.String).EvalJSONNew(AssContentVal)
				s AppBLItemName="",AppBLItemXPrtName=""
				s AppBLItemID=$o(^DHCDocAppBLItemi("APPItemID",AssContentID,""),-1)
				if (AppBLItemID'=""){
					s AppBLItemName=$p(^DHCDocAppBLItem(AppBLItemID),"^",2)
					s AppBLItemXPrtName=$p(^DHCDocAppBLItem(AppBLItemID),"^",10)
				}
				if ComponentType="text"{
					s PrintJsonArr(AssContentID)=AssContentVal
				}elseif ComponentType="checkbox"{
					s AssContentVal=$case(AssContentVal,"true":"☑",:"□")
					s:AppBLItemXPrtName'="Y" AssContentVal=AssContentVal_" "_AppBLItemName
					s PrintJsonArr(AssContentID)=AssContentVal
				}elseif ComponentType="radio"{
					s AssContentVal=$case(AssContentID,AssContentVal:"●",:"○")
					s:AppBLItemXPrtName'="Y" AssContentVal=AssContentVal_" "_AppBLItemName
					s PrintJsonArr(AssContentID)=AssContentVal
				}elseif ComponentType="combobox"{
					s PrintJsonArr(AssContentID)=AssContentVal
					s PrintJsonArr(AssContentID_"Desc")=AssContentDesc
				}else{
					s PrintJsonArr(AssContentID)=AssContentVal
				}
			}
		}
	}
	s ArcimDesc=..GetArcimDesc(AssRowId)
	s CurrentDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	s CurrentTime=$zt($p($h,",",2),2)
	s SysCurrentDateTime=CurrentDate_" "_CurrentTime
    s PrintJsonArr("CAImage")=""
    s CAImageStr="",DCAssUser=""
    s DCAssUserDr=$p($g(^DHCDocCure(+AssRowId,"ASS",$p(AssRowId,"||",2))),"^",1)
    s DCAssLastUserDr=$p($g(^DHCDocCure(+AssRowId,"ASS",$p(AssRowId,"||",2))),"^",5)
    if DCAssLastUserDr'="" s DCAssUserDr=DCAssLastUserDr
    if DCAssUserDr'=""{
        s DCAssUser=$p($g(^SSU("SSUSR",DCAssUserDr)),"^",2)
    }
	s CAImageStr=..GetCAImage(AssRowId)
	i CAImageStr'=""{
	    s PrintJsonArr("CAImage")=CAImageStr
	    s PrintJsonArr("EndAss_User")=""
	}else{
	    s EndAssUser=$g(PrintJsonArr("EndAss_User"))
	    if EndAssUser=""{
	        ;s PrintJsonArr("EndAss_User")=DCAssUser
	    }
	    ;s PrintJsonArr("EndAss_User")=DCAssUser
	}
	s AdmID=$p($g(^DHCDocCure(DCARowID)),"^",1)
	s PAAdmHosp=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmID)
	s HospDesc=$p(^CT("HOSP",PAAdmHosp),"^",2)
	s PrintJsonArr("PatNo")="*"_PrintJsonArr("baseInfoRegNo")_"*"
	s PrintJsonArr("img0")="" ;带log的医院图片
	s PrintJsonArr("HospDesc")=HospDesc
	s PrintJsonArr("Title")=ArcimDesc
	s PrintJsonArr("ItemDesc")=ArcimDesc
	s PrintJsonArr("PrintDate")=SysCurrentDateTime
	s PrintJsonArr("DCAApplyNo")=##class(DHCDoc.DHCDocCure.Apply).GetCureApplyNo(+AssRowId)
	m TPrintJsonArr("Para")=PrintJsonArr
	s TPrintJsonArr("Templet")=..GetAssXMLTemplet(AssRowId)
	
	s PrintJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.TPrintJsonArr)
	q PrintJson
}

ClassMethod GetCAImage(AssRowId)
{
    s CAImageStr="",Base64Str=""
    s DCAssUserDr=$p($g(^DHCDocCure(+AssRowId,"ASS",$p(AssRowId,"||",2))),"^",1)
    s DCAssLastUserDr=$p($g(^DHCDocCure(+AssRowId,"ASS",$p(AssRowId,"||",2))),"^",5)
    if DCAssLastUserDr'="" s DCAssUserDr=DCAssLastUserDr
    
    s Base64Str=##class(web.DHCDocSignVerify).GetImageByUserID(DCAssUserDr)
    i Base64Str'=""{
        s Base64Str="data:image/jpg;base64,"_Base64Str
        s CAImageStr=Base64Str
    }
    Q CAImageStr
}

/// Descript: 获取治疗评估模板维护里维护的xml打印模板
/// w ##Class(DHCDoc.DHCDocCure.Assessment).GetAssXMLTemplet("144||1")
ClassMethod GetAssXMLTemplet(AssRowId As %String) As %String
{
	s PrintTemp="",Title=""
	s DCAssMapID=$p($g(^DHCDocCure(+AssRowId,"ASS",$p(AssRowId,"||",2))),"^",11)
	;s AssTempStr=..GetAssTemp(+AssRowId)
	;s AssTempID=$p(AssTempStr,"^",2)
	;if DCAssMapID'="" s AssTempID=DCAssMapID
	s AssTempID=DCAssMapID
	if AssTempID'=""{
		s PrintTemp=$P(^DHCDocAppBLMap(AssTempID),"^",10)
		s Title=$P(^DHCDocAppBLMap(AssTempID),"^",2)
	}else{
		s PrintTemp="DHCCureAss_Print"
	}
	Q PrintTemp
}

ClassMethod QryAssTempListExecute(ByRef qHandle As %Binary, Flag As %String, DCRowIDStr As %String, sDesc As %String = "") As %Status
{
	s LANGID=..%LanguageID()
	s Length=$l(DCRowIDStr,$C(1))
	k AssTempArr
	k AssIDTempArr
	for loop=1:1:Length{
		s DCRowID=$p(DCRowIDStr,$C(1),loop)
		s AssTypeStr=..GetAssTemp(DCRowID)
		if AssTypeStr'=""{
			s AssAdmID=$p(AssTypeStr,"^",1)	
			s AssTempIDStr=$p(AssTypeStr,"^",2)
			if AssTempIDStr'=""{
				s AssTempIDLen=$l(AssTempIDStr,",")
				for k=1:1:AssTempIDLen{
					s AssTempID=$p(AssTempIDStr,",",k)
					continue:AssTempID=""
					if $d(AssTempArr(AssTempID)){
						s AssTempArr(AssTempID)=AssTempArr(AssTempID)_"$"_DCRowID	
					}else{
						s AssTempArr(AssTempID)=DCRowID
					}
					
					s AssIDTempArr(DCRowID,AssTempID)=""
				}
			}else{
				s AssTempID=0
				if $d(AssTempArr(AssTempID)){
					s AssTempArr(AssTempID)=AssTempArr(AssTempID)_"$"_DCRowID	
				}else{
					s AssTempArr(AssTempID)=DCRowID
				}
				s AssIDTempArr(DCRowID,0)=""	
			}
		}
	}
		
	s mAssTempID="" 
	for{
		s mAssTempID=$o(AssTempArr(mAssTempID))
		Q:mAssTempID=""
		s Same=1,ArcimDesc=""
		for loop=1:1:Length{
			s DCRowID=$p(DCRowIDStr,$C(1),loop)
			if '$d(AssIDTempArr(DCRowID,mAssTempID)){
				s Same=0
				Q	
			}
		}
		if (Flag="Same")&&(Same=1){
			s mDCRowIDStr=AssTempArr(mAssTempID)
			Do OutputRow
		}
		if (Flag="Diff")&&(Same=0){
			s mDCRowIDStr=AssTempArr(mAssTempID)
			s ArcimDesc=..GetArcimDesc(mDCRowIDStr)
			Do OutputRow
		}
	}
	Quit $$$OK
OutputRow
	if +mAssTempID=0{
		s mAssTitle=..%Translate("doccure.asstemp.main.hui.csp","通用评估模板")
	}else{
		s mAssTitle=$P(^DHCDocAppBLMap(mAssTempID),"^",2)
		s mAssTitle=##class(User.DHCDocAppBLMap).GetTranByDesc("APPMapName",mAssTitle,LANGID)
	}
	Q:(sDesc'="")&&(mAssTitle'[sDesc)
	set Data=$lb(mAssTempID,mAssTitle,mDCRowIDStr,ArcimDesc)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod QryAssTempListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAssTempListExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Assessment","QryAssTempList","","617") 
Query QryAssTempList(Flag As %String, DCRowIDStr As %String, sDesc As %String = "") As %Query(ROWSPEC = "AssTempID:%String,AssTempLabel:%String,DCRowIDStr:%String,ArcimDesc:%String")
{
}

/// w ##Class(DHCDoc.DHCDocCure.Assessment).GetZYAssInfo("1")
ClassMethod GetZYAssInfo(EpisodeID)
{
    s JsonObj={}
    s Diagnosis=""
    if EpisodeID'=""{
	    s mradm=$P(^PAADM(EpisodeID),"^",61)
	    s val = ##class(websys.Conversions).IsValidMethodName("DHCDoc.Diagnos.Common","GetAdmDiagDesc")
		if (val){
			s Diagnosis=##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(EpisodeID)
		}else{
        	s Diagnosis=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(mradm,";")
		}
    }
    ;s Date=##class(websys.Conversions).DateLogicalToHtml(+$H)
    ;s Time=$zt($p($H,",",2),2)  
    s Date=..%ZD(..%SysDate())
    s Time=..%ZT(..%SysTime(),2)
    s JsonObj.Diagnosis=Diagnosis
    s JsonObj.DateTime=Date_" "_Time
    Q JsonObj.%ToJSON()
}

ClassMethod GetEMRConsTrePro(EpisodeID)
{
    q:EpisodeID="" ""
    
    s EMRConsTreProStr=""
    q EMRConsTreProStr
    
    s rtn=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.21")
    s EMRConsTreProStr=rtn.GetAt("HDSD00.21.001")
    
    q EMRConsTreProStr
}

}
