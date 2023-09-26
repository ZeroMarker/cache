Class DHCDoc.DHCDocCure.Record Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:治疗处理保存执行时调用的判断
ClassMethod CheckBeforeUpdateExec(DCAARowId As %String, UserID As %String, Type As %String = "E")
{
	n (DCAARowId,UserID,Type)
	s ErrMsg=""
	s DCAAStatus=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",7)
	if DCAAStatus="C"{
		s ErrMsg="预约记录已取消"
	}elseif DCAAStatus="A"{
		s ErrMsg="预约记录已治疗,如需修改,请使用[浏览治疗记录]"
	}
	if ErrMsg=""{
		s OEOREDR=$P($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",2)
		s ErrMsg=##class(DHCDoc.DHCDocCure.ExecApply).CheckBeforeUpdateExec(+DCAARowId,UserID,OEOREDR,Type)
	}
	
	Q ErrMsg
}

ClassMethod CheckBeforeUpdateBatch(DCAARowIdStr As %String, UserID As %String, Type As %String = "E", TransExpStr As %String = "")
{
	n (DCAARowIdStr,UserID,Type,TransExpStr,%session)
	s BrokeMsg=""
	for loop=1:1:$l(DCAARowIdStr,"^"){
		s DCAARowId=$p(DCAARowIdStr,"^",loop)
		s BrokeMsg=..CheckBeforeUpdateExec(DCAARowId,UserID,Type)
		if BrokeMsg'=""{
			s BrokeMsg=..FormatReturnMsg(DCAARowId,BrokeMsg,"",TransExpStr)
			Q	
		}
	}
	Q BrokeMsg
}

/// Description:治疗记录批量保存
/// Input:RowIdStr E：执行记录ID R：治疗预约记录ID
/// 		 UserDR      操作用户
/// 		 LocDeptDr   操作科室
/// 		 Source      调用来源：E(治疗直接执行调用) R(治疗记录添加调用)
/// w ##class(DHCDoc.DHCDocCure.Record).SaveCureRecordBatch("303||142||94","18881",$lg(^tmplog("SaveCureRecordBatch"),3),"E")
ClassMethod SaveCureRecordBatch(RowIdStr As %String, UserDR As %String, ParaJson As %String, Source As %String = "R", TransExpStr As %String = "") As %String
{
	s ^tmplog("SaveCureRecordBatch")=$lb(RowIdStr,UserDR,ParaJson,Source,TransExpStr)
	k PataArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ParaJson,.ParaArr)
	s HOSPID=$p(TransExpStr,"^",1)
	s:(HOSPID="")&&($d(%session)) HOSPID=%session.Get("LOGON.HOSPID")
	s retstr="",DCRRowIdStr=""
	s RowIdStrLen=$l(RowIdStr,"^")
	for count=1:1:RowIdStrLen{
		s (DCRRowId,DCAARowId,OEORERowId)=""
		s (DCRTitle,DCRContent,CheckBeforeExecRet)=""
		if Source="R"{
			s DCAARowId=$p(RowIdStr,"^",count)
			s ParaArr("DCAARowId")=DCAARowId
			s OEORERowId=$P($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",2)
		}elseif  Source="E"{
			s OEORERowId=$p(RowIdStr,"^",count)
			s ParaArr("OEORERowID")=OEORERowId
			s CureAppVersion=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureAppVersion",HOSPID)
			if (CureAppVersion="V1"){
				s AppStatus=##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus(OEORERowId)
				if AppStatus=1{
					s CheckBeforeExecRet="执行记录存在预约记录,请到治疗处理进行治疗记录添加."	
				}	
			}
			s OEOREStatus=$p($g(^OEORD(+OEORERowId,"I",$p(OEORERowId,"||",2),"X",$p(OEORERowId,"||",3))),"^",16)
			s OEOREStatusCode=""
			s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1)
			if OEOREStatusCode="F"{
				s CheckBeforeExecRet="执行记录已执行,不允许添加治疗记录,如需修改,请使用浏览执行进行修改."
			}
			if OEOREStatusCode="D"{
				s CheckBeforeExecRet="执行记录已停止执行,不允许添加治疗记录."
			}
		}
		s OEORIRowID=$P(OEORERowId,"||",1,2)
		s DCARowId=$o(^DHCDocCure(0,"OEORI",OEORIRowID,""))
		s:CheckBeforeExecRet="" CheckBeforeExecRet=##class(DHCDoc.DHCDocCure.ExecApply).CheckBeforeUpdateExec(DCARowId,UserDR,OEORERowId,"",.ParaArr)
		if CheckBeforeExecRet=""{
			s ParaJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ParaArr)
			s ret=..SaveCureRecord(ParaJson)
			s mRowID=$p(ret,"^",2)
			s ret=$p(ret,"^",1)
			if mRowID'=""{
				if DCRRowIdStr="" s DCRRowIdStr=mRowID
				else  s DCRRowIdStr=DCRRowIdStr_"^"_mRowID	
			}
		}else{
			s ret=CheckBeforeExecRet	
		}
		if ret="0"{
			s BrokeMsg=""
		}elseif ret="101"{
			s BrokeMsg="一个预约仅限添加一条治疗记录"
		}elseif ret="102"{
			s BrokeMsg="预约记录没有对应的执行记录,不能做治疗"
		}elseif ret="103"{
			s BrokeMsg="已取消预约的不能够添加治疗记录"
		}elseif ret="104"{
			s BrokeMsg="治疗结束日期不能早于治疗开始日期"
		}elseif ret="-303"{
			s BrokeMsg="该预约记录已被执行!"
		}else{
			s BrokeMsg=ret
		}	
		if $g(BrokeMsg)'=""{	
			s BrokeMsg=..FormatReturnMsg(DCAARowId,BrokeMsg,OEORERowId,TransExpStr)
			if retstr="" s retstr=BrokeMsg
			else  s retstr=retstr_";<br>"_BrokeMsg
		}
	}
	q retstr_$C(1)_DCRRowIdStr
}

/// 保存治疗记录  
/// w ##class(DHCDoc.DHCDocCure.Record).SaveCureRecord($lg(^TMP("SaveCureRecord"),1))
ClassMethod SaveCureRecord(ParaJson As %String) As %String
{
	n (ParaJson,%session)
	s ^TMP("SaveCureRecord")=$lb(ParaJson)
	k PataArr,ParaExpArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ParaJson,.ParaArr)
	k NewParaArr
	s DCRCureJsonStr=""
	if $d(ParaArr("CureExpJsonStr")){
		m ParaExpArr=ParaArr("CureExpJsonStr")
		s DCRCureJsonStr=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ParaExpArr)
		s ParaID=""
		for{
			s ParaID=$o(ParaExpArr(ParaID)) 
			Q:ParaID=""
			s EleID=$g(ParaExpArr(ParaID,"ID"))	
			s EleVal=$g(ParaExpArr(ParaID,"Val"))
			s NewParaArr(EleID)=EleVal	
		}
		m ParaArr=NewParaArr
	}
	s Rowid=$g(ParaArr("DCRRowId"))
	s AppArriveDR=$g(ParaArr("DCAARowId"))
	s DCRTitle=$g(ParaArr("DCRTitle"))
	s DCRContent=$g(ParaArr("DCRContent"))
	s UserDR=$g(ParaArr("UserDR"))
	s LogonLocDr=$g(ParaArr("LogonLocDr"))
	s OEORERowID=$g(ParaArr("OEORERowID"))
	s DCRCureDate=$g(ParaArr("DCRCureDate"))
	s DCRDosage=""
	s DCRResponse=$g(ParaArr("DCRResponse"))
	s DCREffect=$g(ParaArr("DCREffect"))
	s DCRCureEndDate=$g(ParaArr("DCRCureEndDate"))
	s DCRCurePOAID=$g(ParaArr("CurePOA"))
	s DCRCureExecDate=$g(ParaArr("DCRCureExecDate"))
	s DCRReconfirmUser=$g(ParaArr("ReConfirmUser"))
	s HospId=$g(ParaArr("HospId"))
	s DCRCureMapID=$g(ParaArr("DCRCureMapID"))
	s QueId=$g(ParaArr("QueId"))
	
	s DCRCureTime=""
	if DCRCureDate'=""{
		s DCRCureTime=$$FormatTime(DCRCureDate)
		s DCRCureDate=$$FormatDate(DCRCureDate)
	}else{
		s DCRCureTime=$p($H,",",2)	
		s DCRCureDate=+$H
	}
	s DCRCureEndTime=""
	if DCRCureEndDate'=""{
		s DCRCureEndTime=$$FormatTime(DCRCureEndDate)
		s DCRCureEndDate=$$FormatDate(DCRCureEndDate)
	}else{
		s DCRCureEndTime=$p($H,",",2)	
		s DCRCureEndDate=+$H
	}
	if (DCRCureEndDate<DCRCureDate)!((DCRCureEndDate=DCRCureDate)&&(DCRCureEndTime<DCRCureTime)){
		Q "104"	
	}
	if DCRCureExecDate'=""{
		s DCRCureExecTime=$$FormatTime(DCRCureExecDate)
		s DCRCureExecDate=$$FormatDate(DCRCureExecDate)
	}else{
		s DCRCureExecTime=$p($H,",",2)	
		s DCRCureExecDate=+$H
	}
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId="")&&(LogonLocDr'=""){
		s HospId=$p(^CTLOC(LogonLocDr),"^",22)	
	}
	s OEOREDR=""
	s err=103
	if Rowid="" 
	{
		if (AppArriveDR="")&&(OEORERowID="")  Q 100
		s DCARowId="",Resource=""
		if (AppArriveDR'=""){
			;治疗记录添加
			s DCARowId=+AppArriveDR
			s OEOREDR=$P($g(^DHCDocCure(+AppArriveDR,"Arrive",$p(AppArriveDR,"||",2))),"^",2)
			s DCAAStatus=$p($g(^DHCDocCure(+AppArriveDR,"Arrive",$p(AppArriveDR,"||",2))),"^",7)
			if (DCAAStatus="C") Q 103
			s Resource="Record"
		}elseif(OEORERowID'=""){
			;直接执行添加治疗记录
			s OEORIRowID=+OEORERowID_"||"_$P(OEORERowID,"||",2)
			s DCARowId=$o(^DHCDocCure(0,"OEORI",OEORIRowID,""))
		}
		s DCRRowId=..GetDCRRowID(AppArriveDR,OEORERowID)
		;一个预约仅限开添加一条治疗记录
		if (DCRRowId'="") Q 101
		if (OEOREDR="")&&(OEORERowID'="") s OEOREDR=OEORERowID
		TS
		if (QueId'="")&&(AppArriveDR="") {
			s AppArriveSub=$o(^DHCDocCure(0,"OEORE",OEORERowID,DCARowId,0))
			if AppArriveSub'="" {
				s AppArriveDR=DCARowId_"||"_AppArriveSub
			}else {
				s AppArriveDR=..AutoInsertArrive(QueId,DCARowId,OEORERowID,UserDR)
			}
			if AppArriveDR="" {
				tro
				q "-1001"
			}
			s Resource="Record"
		}
		k PLIST
		s PLIST(0)=DCARowId //+AppArriveDR
		s PLIST(3)=AppArriveDR
		s PLIST(4)=OEOREDR
		s PLIST(5)=DCRTitle
		s PLIST(6)=DCRContent
		s PLIST(7)=UserDR
		s PLIST(8)=+$h
		s PLIST(9)=$p($h,",",2)
		s PLIST(13)="Y"
		s PLIST(15)=DCRCureDate
		s PLIST(16)=DCRCureTime
		s PLIST(17)=DCRResponse
		s PLIST(18)=DCREffect
		s PLIST(19)=DCRDosage
		s PLIST(20)=DCRCureEndDate
		s PLIST(21)=DCRCureEndTime
		s PLIST(22)=DCRCureMapID
		s PLIST(23)=DCRCureJsonStr
		s PLIST(24)=DCRCurePOAID
		s PLIST(25)=DCRReconfirmUser
		s PLIST(26)=DCRCureExecDate
		s PLIST(27)=DCRCureExecTime
	 	&sql(insert into SQLUser.DHC_DocCureRecode values :PLIST())
	 	s Rowid=$p(%ROWID,$c(1))
	 	s err=SQLCODE
	 	if err'=0
	 	{
		 	TRO
		 	q err
		}
		if (AppArriveDR'=""){
		 	s err=##class(DHCDoc.DHCDocCure.Appointment).AppArrive(AppArriveDR,UserDR,LogonLocDr,DCRCureExecDate,DCRCureExecTime)
		 	if err'=0
		 	{
			 	TRO
			 	q err
			}
		}
		s Qty=1
		s Qty=##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID(OEOREDR)
		s err=##class(DHCDoc.DHCDocCure.ExecApply).ExecCureApply(DCARowId,UserDR,Qty,"E",Resource,OEOREDR,LogonLocDr,HospId,DCRCureExecDate,DCRCureExecTime)
		if +err'=0
	 	{
		 	TRO
		 	q err
		}
		TC 
		
		s CDRPara=+DCARowId_"^^"_$g(Rowid)_"^"_"CUREZL"_"^"_UserDR
		Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(CDRPara)
	}else{
		s OldData=..GetCureRecord(Rowid)
		k PLIST
		s PLIST(5)=DCRTitle
		s PLIST(6)=DCRContent
		s PLIST(10)=UserDR
		s PLIST(11)=+$h
		s PLIST(12)=$p($h,",",2)
		s PLIST(15)=DCRCureDate
		s PLIST(16)=DCRCureTime
		s PLIST(17)=DCRResponse
		s PLIST(18)=DCREffect
		s PLIST(19)=DCRDosage
		s PLIST(20)=DCRCureEndDate
		s PLIST(21)=DCRCureEndTime
		s PLIST(23)=DCRCureJsonStr
		s PLIST(24)=DCRCurePOAID
		s PLIST(25)=DCRReconfirmUser
		s PLIST(26)=DCRCureExecDate
		s PLIST(27)=DCRCureExecTime
		&sql(update SQLUser.DHC_DocCureRecode VALUES :PLIST() WHERE DCR_RowId=:Rowid )
	    s err=SQLCODE
	    if ('err){
		    s DCAADR=$p($g(^DHCDocCure(+Rowid,"Recode",$p(Rowid,"||",2))),"^",1)
		    if (DCAADR'=""){
			    s PerStateId=##class(DHCDoc.DHCDocCure.CureCall).GetCurePerStateId("Complete")
			 	&sql(update SQLUser.DHC_DocCureAppArrive set DCAA_PerStatusDr=:PerStateId where DCAA_RowId=:DCAADR)
			}
			d ..SaveFileLog(OldData,Rowid,UserDR)    
		}
	}
	Q err_"^"_Rowid
FormatDate(DateTime)
	if DateTime'=""{
		s Date=$p(DateTime," ",1)
		s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	}else{
		s Date=+$H
	}
	Q Date
FormatTime(DateTime)
	if DateTime'=""{
		s Time=$p(DateTime," ",2)
		s Time=$zth(Time,1)
	}else{
		s Time=$p($H,",",2)	
	}
	Q Time
}

/// 自动插入一条预约记录
ClassMethod AutoInsertArrive(QueRowId As %String, DCARowId As %String, OEORERowId As %String, UserDR As %String) As %String
{
	n (QueRowId,DCARowId, OEORERowId, UserDR)
	s QueRBASDr=$lg(^User.DHCDocCureQueueD(QueRowId),2)
	s QueOperUserDr=$lg(^User.DHCDocCureQueueD(QueRowId),7)
	s QueInsertDate=$lg(^User.DHCDocCureQueueD(QueRowId),15)
	s QueInsertTime=$lg(^User.DHCDocCureQueueD(QueRowId),16)
	s:QueOperUserDr'="" UserDR=QueOperUserDr
	s DCAARowId=""
	k PLIST
	s PLIST(0)=DCARowId
	s PLIST(3)=QueRBASDr
	s PLIST(4)=OEORERowId
	s PLIST(5)=UserDR
	s PLIST(6)=QueInsertDate
	s PLIST(7)=QueInsertTime
	s PLIST(8)="M"
	s PLIST(9)="I"
	s PLIST(21)=QueRowId
	&sql(insert into SQLUser.DHC_DocCureAppArrive values :PLIST())
	if 'SQLCODE s DCAARowId=$p(%ROWID,$c(1))
	q DCAARowId
}

/// w ##class(DHCDoc.DHCDocCure.Record).GetCureRecordByDCA("186||3")
ClassMethod GetCureRecordByDCA(AppArriveDR, SpecFlag As %String = "", OEORERowID As %String = "", HospId As %String = "") As %String
{
	n (AppArriveDR,SpecFlag,OEORERowID,HospId,%session)
	s ^tmpnk("GetCureRecordByDCA")=$lb(AppArriveDR, SpecFlag,OEORERowID)
	s CureRecordInfo=""
	Quit:(AppArriveDR="")&&(OEORERowID="") CureRecordInfo
	s DCRRowId=""
	s DCRRowId=..GetDCRRowID(AppArriveDR,OEORERowID)
	if AppArriveDR'=""{
		s DCARowId=+AppArriveDR
	}else{
		s OEORIRowID=+OEORERowID_"||"_$P(OEORERowID,"||",2)
		s DCARowId=$o(^DHCDocCure(0,"OEORI",OEORIRowID,""),-1)
	}
	
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	
	if DCRRowId'=""{
		s CureRecordInfo=..GetCureRecord(DCRRowId)
	}else{
		Set CureData=$g(^DHCDocCure(DCARowId))
		Set Adm=$p(CureData,"^",1)
		Q:Adm="" ""
		Set PatientId=$P($G(^PAADM(Adm)),"^",1)
		Set OrderId=$p(CureData,"^",2)
		q:OrderId="" ""
		s OrderRecLocDr=$P(^OEORD(+OrderId,"I",$P(OrderId,"||",2),3),"^",6)
		if (HospId="")&&(OrderRecLocDr'=""){
			s HospId=$p(^CTLOC(OrderRecLocDr),"^",22)	
		}
		s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
		q:ArcimId="" ""
		s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
		s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
		s DCRContent=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureRecordContent",HospId)
		if ((DCRContent=0)!(DCRContent="")) s DCRContent="治疗过程："_$c(13)_"治疗结果："
		if SpecFlag=1 s DCRContent=""
		s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,HospId)
		s CureRecordInfo=AppArriveDR_"^"_""_"^"_ArcimDesc_"^"_DCRContent_"^"_""
		s CureRecordInfo=CureRecordInfo_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""	
		s CureRecordInfo=CureRecordInfo_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""	
		s CureRecordInfo=CureRecordInfo_"^"_""_"^"_DDCISRowid
	}
	q CureRecordInfo
}

/// 获取默认的治疗记录信息
/// w ##class(DHCDoc.DHCDocCure.Record).GetCureDefSetInfo(2)
ClassMethod GetCureDefSetInfo(HOSPID) As %String
{
	s DefSetObj={}
	s CureRecordContent=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureRecordContent",HOSPID)
	s CureRecordContent=$tr(CureRecordContent,$c(10),"^")
	s:CureRecordContent="0" CureRecordContent=""
	s CureDefTimeSet=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureDefTimeSet",HOSPID)
	s CurrDate=+$H
	s CurrTime=$p($H,",",2)
	s (CureDefSttDate,CureDefSttTime,CureDefEndDate,CureDefEndTime)=""
	if CureDefTimeSet'=""{
		s CureDefSttTimeSet=$p(CureDefTimeSet,"@",1)
		s CureDefEndTimeSet=$p(CureDefTimeSet,"@",2)
		if CureDefSttTimeSet'=""{
			s CureDefSttTime=CurrTime+(CureDefSttTimeSet*3600)	
			if CureDefSttTime<0{
				s CureDefSttDate=CurrDate-1	
				s CureDefSttTime=86400+CureDefSttTime	
			}
			elseif CureDefSttTime>=86400{
				s CureDefSttDate=CurrDate+1	
				s CureDefSttTime=CureDefSttTime-86400	
			}else{
				s CureDefSttDate=CurrDate	
			}
			s CureDefSttDate=..%ZD(CureDefSttDate)_" "_..%ZT(CureDefSttTime)
		}
		if CureDefEndTimeSet'=""{
			s CureDefEndTime=CurrTime+(CureDefEndTimeSet*3600)	
			if CureDefEndTime<0{
				s CureDefEndDate=CurrDate-1	
				s CureDefEndTime=86400+CureDefEndTime	
			}elseif CureDefEndTime>=86400{
				s CureDefEndDate=CurrDate+1	
				s CureDefEndTime=CureDefEndTime-86400	
			}else{
				s CureDefEndDate=CurrDate	
			}
			s CureDefEndDate=..%ZD(CureDefEndDate)_" "_..%ZT(CureDefEndTime)
		}
	}
	;保证对象元素名称与界面元素ID保持一致,方便前台赋值
	s DefSetObj.DCRContent=CureRecordContent
	s DefSetObj.DCRCureDate=CureDefSttDate
	s DefSetObj.DCRCureEndDate=CureDefEndDate
	Q DefSetObj.%ToJSON()
}

/// 取单条治疗记录
/// w ##class(DHCDoc.DHCDocCure.Record).GetCureRecord("782||5")
ClassMethod GetCureRecord(DCRRowId) As %String
{
	n (DCRRowId,%session)
	s langid=..%LanguageID()
	Q:DCRRowId="" ""
	s CureRecordInfo=""
	s Data=$g(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)))
	Q:Data="" ""
	s (CreateUser,UpdateUser)=""
	s AppArriveDR=$p(Data,"^",1)
	s OEOREDR=$p(Data,"^",2)
	s DCRTitle=$p(Data,"^",3)
	s DCRContent=$p(Data,"^",4)
	s CreateUserDR=$p(Data,"^",5)
	s:CreateUserDR'="" CreateUser=$p($g(^SSU("SSUSR",CreateUserDR)),"^",2)
	s CreateUser=##class(DHCDoc.Common.Translate).GetTransUser(CreateUser,langid)
	s CreateDate=$p(Data,"^",6)
	s CreateDate=##class(websys.Conversions).DateLogicalToHtml(CreateDate)
	s CreateTime=$p(Data,"^",7)
	s:CreateTime'="" CreateTime=$zt(CreateTime,1)
	s CreateDate=CreateDate_" "_CreateTime
	s UpdateUserDR=$p(Data,"^",8)
	s:UpdateUserDR'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	s UpdateUser=##class(DHCDoc.Common.Translate).GetTransUser(UpdateUser,langid)
	s UpdateDate=$p(Data,"^",9)
	s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	s UpdateTime=$p(Data,"^",10)
	s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	s UpdateDate=UpdateDate_" "_UpdateTime
	s DCRActive=$p(Data,"^",11)
	s IsPicture=$p(Data,"^",12)
	s DCRCureDate=$p(Data,"^",13)
	s DCRCureDate=##class(websys.Conversions).DateLogicalToHtml(DCRCureDate)
	s DCRCureTime=$p(Data,"^",14)
	s:DCRCureTime'="" DCRCureTime=$zt(DCRCureTime,1)
	s DCRCureDate=DCRCureDate_" "_DCRCureTime
	s DCRResponse=$p(Data,"^",15)
	s DCREffect=$p(Data,"^",16)
	s DCRDoseage=$p(Data,"^",17)
	s DCRCureEndDate=$p(Data,"^",18)
	s DCRCureEndDate=##class(websys.Conversions).DateLogicalToHtml(DCRCureEndDate)
	s DCRCureEndTime=$p(Data,"^",19)
	s DCRCureMapID=$p(Data,"^",20)
	s DCRCurePOAID=$p(Data,"^",21)
	s DCRReconfirmUserCode=$p(Data,"^",22)
	s:DCRCureEndTime'="" DCRCureEndTime=$zt(DCRCureEndTime,1)
	s DCRCureEndDate=DCRCureEndDate_" "_DCRCureEndTime
	s OrderId=$p($g(^DHCDocCure(+DCRRowId)),"^",2)
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByOrd(OrderId)
	
	s DCRCureExecDate=""
	if OEOREDR'=""{
		s OEOREExDate=$p($g(^OEORD(+OEOREDR,"I",$p(OEOREDR,"||",2),"X",$p(OEOREDR,"||",3))),"^",19)
		s:OEOREExDate'="" OEOREExDate=##class(websys.Conversions).DateLogicalToHtml(OEOREExDate)
		s OEOREExTime=$p($g(^OEORD(+OEOREDR,"I",$p(OEOREDR,"||",2),"X",$p(OEOREDR,"||",3))),"^",20)
		s:OEOREExTime'="" OEOREExTime=$zt(OEOREExTime,1)
		s DCRCureExecDate=OEOREExDate_" "_OEOREExTime	
	}
	
	s CureRecordInfo=AppArriveDR_"^"_OEOREDR_"^"_DCRTitle_"^"_DCRContent_"^"_CreateUserDR
	s CureRecordInfo=CureRecordInfo_"^"_$g(CreateUser)_"^"_CreateDate_"^"_UpdateUserDR_"^"_$g(UpdateUser)_"^"_UpdateDate
	s CureRecordInfo=CureRecordInfo_"^"_IsPicture_"^"_DCRCureDate_"^"_DCRResponse_"^"_DCREffect_"^"_DCRDoseage
	s CureRecordInfo=CureRecordInfo_"^"_DCRCureEndDate_"^"_DDCISRowid_"^"_DCRCurePOAID_"^"_DCRCureExecDate_"^"_DCRActive
	s CureRecordInfo=CureRecordInfo_"^"_DCRReconfirmUserCode_"^"_DCRCureMapID
	q CureRecordInfo
}

/// Creator：      郭宝平
/// CreatDate：    2014-12-20
/// Description:： 查询单个申请单的治疗记录
/// Table: 		  DHC_DocCureRecord
/// Input：        EpisodeID:就诊ID
/// 
Query FindCureRecordList(DCARowIdStr As %String, DCAOEOREDR As %String = "", Type As %String = "") As %Query(ROWSPEC = "Rowid:%String,DCRTitle:%String,CreateUser:%String,CreateDate:%String,UpdateUser:%String,UpdateDate:%String,PatientNo:%String,PatientName:%String,ArcimDesc:%String,ID:%String,DDCRSLoc:%String,CTCareProv:%String,DDCRSDate:%String,TimeRangeDesc:%String,ServiceGroupDesc:%String,DCAAStatus:%String,DCAARowId:%String,IsPicture:%String,EpisodeId:%String")
{
}

ClassMethod FindCureRecordListExecute(ByRef qHandle As %Binary, DCARowIdStr As %String, DCAOEOREDR As %String = "", Type As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Record","FindCureRecordList","34||1","","APP")
	s ^tmplog("FindCureRecordList")=DCARowIdStr_","_DCAOEOREDR_","_Type
	Set repid=$I(^CacheTemp)
	Set ind=1
	if DCARowIdStr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s DCARowIdLen=$l(DCARowIdStr,"!")
	for mycount=1:1:DCARowIdLen{
		s DCARowId=$P(DCARowIdStr,"!",mycount)
		if Type="APP" {
			s DCRChildSub=0
			for {
				s DCRChildSub=$o(^DHCDocCure(0,"AppArriveDR",DCARowId,+DCARowId,DCRChildSub))
				q:DCRChildSub=""
				s DCRRowId=+DCARowId_"||"_DCRChildSub
				s DCRActive=$p(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)),"^",11)
				continue:DCRActive'="Y"
				d OutputRowApply
			}
		}else{
			s DCRChildSub=0
			for{
				s DCRChildSub=$o(^DHCDocCure(DCARowId,"Recode",DCRChildSub)) q:DCRChildSub=""
				s DCRRowId=DCARowId_"||"_DCRChildSub
				s DCRActive=$p(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)),"^",11)
				continue:DCRActive'="Y"
				d OutputRowApply
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApply 
	s CureRecordInfo=..GetCureRecord(DCRRowId)
	s DCROEOREDR=$p(CureRecordInfo,"^",2)
	Q:(DCAOEOREDR'="")&&(DCAOEOREDR'=DCROEOREDR)
	s DCAARowId=$p(CureRecordInfo,"^",1)
	s (DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,ServiceGroupDesc,DCAAStatus)=""
	if DCAARowId'=""  d
	.s Data=##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment(DCAARowId)
	.s ASData=$p(Data,$c(1),1)
	.s AppData=$p(Data,$c(1),2)
	.;------排班信息-------
	.s DDCRSLoc=$p(ASData,"^",2)   //治疗科室
	.s CTCareProv=$p(ASData,"^",4)  //预约资源
	.s DDCRSDate=$p(ASData,"^",5)   //预约日期
	.s TimeRangeDesc=$p(ASData,"^",7)  //预约时间段
	.s StartTime=$p(ASData,"^",8)
	.s EndTime=$p(ASData,"^",9)
	.s ServiceGroupDesc=$p(ASData,"^",11)  //服务组
	.s DDCRSStatus=$p(ASData,"^",12)   //排班状态
	.s DCAAStatus=$p(AppData,"^",8) //预约状态
	.
	s DCRTitle=$p(CureRecordInfo,"^",3)
	s CreateUser=$p(CureRecordInfo,"^",6)
	s CreateDate=$p(CureRecordInfo,"^",7)
	s UpdateUser=$p(CureRecordInfo,"^",9)
	s UpdateDate=$p(CureRecordInfo,"^",10)
	s IsPicture=$p(CureRecordInfo,"^",11)
	s IsPicture=$case(IsPicture,"Y":"查看图片","N":"",:"")
	s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(+DCARowId)
	s ArcimDesc="",PatientNo="",PatientName="",EpisodeId=""
	if (CureAppStr'="") d
	.s CureAppInfo=$p(CureAppStr,$c(1),2)
	.s ArcimDesc=$p(CureAppInfo,"^")
	.s PatientInfo=$p(CureAppStr,$c(1),1)
	.s PatientNo=$p(PatientInfo,"^",2)
	.s PatientName=$p(PatientInfo,"^",3)
	set Data=$lb(DCRRowId,DCRTitle,CreateUser,CreateDate,UpdateUser,UpdateDate,PatientNo,PatientName,ArcimDesc,DCRRowId,DDCRSLoc,CTCareProv,DDCRSDate,TimeRangeDesc,ServiceGroupDesc,DCAAStatus,DCAARowId,IsPicture,EpisodeId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureRecordListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureRecordListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureRecordListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureRecordListExecute ]
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

/// Creator：     宋春莉
/// CreatDate：   2016-06-15
/// Description:：根据医嘱ID查找是否存在治疗结果记录
/// Table: 		  DHC_DocCureRecord
/// Input：       OEORIRowId:医嘱ID
/// OutPut:       1 存在 0 不存在
/// w ##class(DHCDoc.DHCDocCure.Record).FindCureRecordByOEORI("1584||28")
ClassMethod FindCureRecordByOEORI(OEORIRowId As %String) As %String
{
	n (OEORIRowId)
	s FindCureRecord=0
	s DCARowId=$o(^DHCDocCure(0,"OEORI",OEORIRowId,""))
	Q:DCARowId="" FindCureRecord
	/*s DCRChildSub=$o(^DHCDocCure(DCARowId,"Recode",""))
	i DCRChildSub'="" s FindCureRecord=1*/
	s DCRChildSub=0
	for {
		s DCRChildSub=$o(^DHCDocCure(DCARowId,"Recode",DCRChildSub)) q:DCRChildSub=""
		s DCROEOREDr=$p(^DHCDocCure(DCARowId,"Recode",DCRChildSub),"^",2)
		s OEOREOrderStatusDR=$p($g(^OEORD(+DCROEOREDr,"I",$p(DCROEOREDr,"||",2),"X",$p(DCROEOREDr,"||",3))),"^",16)
		if (OEOREOrderStatusDR="") s FindCureRecord=1 q
		s StatusCode=$p(^OEC("STAT",OEOREOrderStatusDR),"^",1)
		if (StatusCode="F")||(StatusCode="A") s FindCureRecord=1 q
	}
	Q FindCureRecord
}

ClassMethod SaveFileLog(OldData As %String, RowId As %String, UserID As %String, Type As %String = "") As %String
{
	n (%session,OldData,RowId,UserID,Type)
	s UPUserIP=$zutil(67,15,$j)   //获取IP地址
    s UPDate=+$h
 	s UPTime=$p($h,",",2)
    s OldTitle=$p(OldData,"^",3)
    s OldContent=$p(OldData,"^",4)
    s OldCureDate=$p(OldData,"^",12)
    s OldResponse=$p(OldData,"^",13)
    s OldEffect=$p(OldData,"^",14)
    s OldDoseage=$p(OldData,"^",15)
    s UpdStr=""
    if Type'="DEL"{
		s NewData=..GetCureRecord(RowId)
	    s NewTitle=$p(NewData,"^",3)
	    s NewContent=$p(NewData,"^",4)
	    s NewCureDate=$p(NewData,"^",12)
	    s NewResponse=$p(NewData,"^",13)
	    s NewEffect=$p(NewData,"^",14)
	    s NewDoseage=$p(NewData,"^",15)
	    if (OldTitle'=NewTitle)  d
	    .i UpdStr="" s UpdStr="治疗标题"_"由'"_OldTitle_"'改成了'"_NewTitle_"'"
	    .e  s UpdStr=UpdStr_";"_"治疗标题"_"由'"_OldTitle_"'改成了'"_NewTitle_"'"
		if (OldContent'=NewContent)  d
		.i UpdStr="" s UpdStr="治疗内容"_"由'"_OldContent_"'改成了'"_NewContent_"'"
		.e  s UpdStr=UpdStr_";"_"治疗内容"_"由'"_OldContent_"'改成了'"_NewContent_"'"
		if (OldCureDate'=NewCureDate)  d
		.i UpdStr="" s UpdStr="治疗时间"_"由'"_OldCureDate_"'改成了'"_NewCureDate_"'"
		.e  s UpdStr=UpdStr_";"_"治疗时间"_"由'"_OldCureDate_"'改成了'"_NewCureDate_"'"
		if (OldResponse'=NewResponse)  d
		.i UpdStr="" s UpdStr="治疗反应"_"由'"_OldResponse_"'改成了'"_NewResponse_"'"
		.e  s UpdStr=UpdStr_";"_"治疗反应"_"由'"_OldResponse_"'改成了'"_NewResponse_"'"
		if (OldEffect'=NewEffect)  d
		.i UpdStr="" s UpdStr="治疗效果"_"由'"_OldEffect_"'改成了'"_NewEffect_"'"
		.e  s UpdStr=UpdStr_";"_"治疗效果"_"由'"_OldEffect_"'改成了'"_NewEffect_"'"
    }else{
		s UpdStr="撤消了治疗标题为"_OldTitle_",治疗内容为"_OldContent_"的治疗记录"
	}
	Q:UpdStr="" 0
	k PLIST
	s PLIST(0)=RowId
	s PLIST(3)=UPDate
	s PLIST(4)=UPTime
	s PLIST(5)=UserID
	s PLIST(6)=UpdStr
	s PLIST(7)=UPDate
	s PLIST(8)=UPTime
	&sql(insert into SQLUser.DHC_DocCureRecodeChange values :PLIST())
    q SQLCODE
}

/// Debug：w ##class(DHCDoc.DHCDocCure.Record).CancelRecordBatch("119||3^119||4",18881)
ClassMethod CancelRecordBatch(DCRRowIdStr As %String, UserID As %String, ExecFlag As %String = "")
{
	n (DCRRowIdStr,UserID,ExecFlag)	
	s BrokeMsg="0",SucessIDStr=""
	if ExecFlag=""{
		for loop=1:1:$l(DCRRowIdStr,"^"){
			s DCRRowId=	$p(DCRRowIdStr,"^",loop)
		 	s checkret=##class(DHCDoc.DHCDocCure.ExecApply).CheckBeforeUpdateExec(+DCRRowId,UserID,"","C")
			if checkret'=""{
				s BrokeMsg=..FormatReturnMsg(DCAARowId,checkret)
				q	
			}
	 	}
	}
	if BrokeMsg="0"{
		for loop=1:1:$l(DCRRowIdStr,"^"){
			s DCRRowId=	$p(DCRRowIdStr,"^",loop)
			s ret=..CancelRecord(DCRRowId,UserID,ExecFlag)
			if +ret'=0{
				s DCAARowId=$p($g(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2))),"^",1)
				s BrokeMsg=..FormatReturnMsg(DCAARowId,checkret)
				q	
			}else{
				if SucessIDStr=""{
					s SucessIDStr=DCRRowId
				}else{
					s SucessIDStr=SucessIDStr_"^"_DCRRowId	
				}	
			}
		}
	}
	Q BrokeMsg_$c(1)_SucessIDStr
}

/// Desc:撤销治疗记录，将已添加的治疗记录置为无效状态，同时撤销相应的执行记录
/// Input:	DCRRowId：治疗记录ID 
///       	UserID：操作用户ID 
/// 		ExecFlag：调用来源（治疗记录撤销传空，其他调用传非空，不撤销执行记录）
/// Debug：w ##class(DHCDoc.DHCDocCure.Record).CancelRecord("2||1",1)
ClassMethod CancelRecord(DCRRowId As %String, UserID As %String, ExecFlag As %String = "")
{
	n (DCRRowId,UserID,ExecFlag)
	s Active="N"
	s UPDate=+$h
 	s UPTime=$p($h,",",2)
 	if ExecFlag=""{
	 	s checkret=##class(DHCDoc.DHCDocCure.ExecApply).CheckBeforeUpdateExec(+DCRRowId,UserID,"","C")
		Q:checkret'="" "-205^"_checkret
 	}
	Ts
	s Data=..GetCureRecord(DCRRowId)
	&sql(update  SQLUser.DHC_DocCureRecode set DCR_Active=:Active,DCR_LastUpdateUser_DR=:UserID,DCR_LastUpdateDate=:UPDate,DCR_LastUpdateTime=:UPTime where DCR_RowId=:DCRRowId)
	if 'SQLCODE{
		s err= ..SaveFileLog(Data,DCRRowId,UserID,"DEL")	
		if err{
			Tro
			Q "-100^"_"保存治疗记录变更记录数据错误,错误代码："_SQLCODE	
		}
		/*if ExecFlag=""{
			s DCAARowId=$p(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)),"^",1)
			if (DCAARowId=""){
				Tro
				Q "-102^"_"治疗预约记录指向为空"	
			}*/
		s DCAARowId=$p(^DHCDocCure(+DCRRowId,"Recode",$p(DCRRowId,"||",2)),"^",1)
		if (DCAARowId'=""){
			s PerStateId=##class(DHCDoc.DHCDocCure.CureCall).GetCurePerStateId("Wait")
			if PerStateId=""{
				Trollback
				Quit "-103^"_"获取等候队列状态失败"	
			}
		
			k PLIST
			s PLIST(9)="I"
			s PLIST(10)=UserID
			s PLIST(11)=UPDate
			s PLIST(12)=UPTime
			s PLIST(17)=PerStateId
			&sql(update SQLUser.DHC_DocCureAppArrive values :PLIST() where DCAA_RowId=:DCAARowId)
			if SQLCODE
		    {
			    Trollback
				Quit "-102^"_"更新治疗预约记录错误,错误代码："_SQLCODE	
			}
			if ExecFlag=""{
				s OEOREDR=$P($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",2)
				s rtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,"C",UserID,+$H,"","")
				if rtn'=0{
					Trollback
					s ErrMsg=##Class(web.DHCDocErrCodeRegister).GetErrCodeMsg("appcom.OEOrdExec",rtn)
					if ErrMsg="" s ErrMsg=rtn
					Quit "-102^"_"更新执行记录错误,错误代码："_ErrMsg
				}
				s StatusRowId=$O(^OEC("OSTAT",0,"Code","V",0))  
				&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=:StatusRowId Where OEORE_RowId=:OEOREDR)
			    if SQLCODE
			    {
				    Trollback
					Quit "-103^"_" "_"更新执行记录扩展表错误,错误代码："_SQLCODE
				}
			}
			s AppEexcNum=+$p(^DHCDocCure(+DCRRowId),"^",15)
			s AppEexcNum=AppEexcNum-1
			s CureObj=##class(User.DHCDocCureApp).%OpenId(+DCRRowId)
			if $IsObject(CureObj){
				s CureObj.DCAExecNum=AppEexcNum
				d CureObj.%Save()
			}
			d ##class(DHCDoc.DHCDocCure.Apply).FinishCureApply(+DCRRowId,UserID,"CF")
		}
	}else{
		tro
		Q "-101^"_"更新治疗记录错误,错误代码："_SQLCODE	
	}
	Tc
	s CDRPara=+DCRRowId_"^^"_$g(DCRRowId)_"^"_"CURECZL"_"^"_UserID
	Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(CDRPara)
	Q 0
}

ClassMethod GetDCRRowID(AppArriveDR As %String, OEORERowID As %String = "")
{
	n (AppArriveDR,OEORERowID)
	s DCRRowID=""
	if AppArriveDR'=""{
		s DCRChildSub=0
		for {
			s DCRChildSub=$o(^DHCDocCure(0,"AppArriveDR",AppArriveDR,+AppArriveDR,DCRChildSub))
			q:DCRChildSub=""
			s DCRActive=$p(^DHCDocCure(+AppArriveDR,"Recode",DCRChildSub),"^",11)
			continue:DCRActive'="Y"	
			s DCRRowID=+AppArriveDR_"||"_DCRChildSub
		}
	}else{
		s OEORIRowID=+OEORERowID_"||"_$P(OEORERowID,"||",2)
		s DCARowId=""
		for {
			s DCARowId=$o(^DHCDocCure(0,"OEORI",OEORIRowID,DCARowId))
			q:DCARowId=""
			s DCRChildSub=0
			for{
				s DCRChildSub=$o(^DHCDocCure(0,"OEOREDR",OEORERowID,DCARowId,DCRChildSub))
				Q:DCRChildSub=""
				s DCRActive=$p(^DHCDocCure(DCARowId,"Recode",DCRChildSub),"^",11)
				continue:DCRActive'="Y"	
				s DCRRowID=DCARowId_"||"_DCRChildSub
			}
		}
	}
	Q DCRRowID
}

/// 得到ftp的相关配置
/// w ##class(DHCDoc.DHCDocCure.Record).GetFTPConfig()
ClassMethod GetFTPConfig() As %String
{
	;配置属性
	s FTPIPAddr=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureFTPIPAddress") ;"10.160.16.112"
	s FTPUser=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureFTPUserCode") ;114
	s FTPPassword=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureFTPPassWord") ;114
	s FTPPort=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureFTPPort") ;114
	;临时存储数据库服务器的路径,因为ftp上传需要从数据库服务器传输文件
	s FileLocalPath="/tmp/"
	s UploadFilePath=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureFTPUploadPath") ;"/EcgwTemp/"
	
	Q FTPIPAddr_"^"_FTPUser_"^"_FTPPassword_"^"_FTPPort_"^"_FileLocalPath_"^"_UploadFilePath
}

/// 上传文件到ftp
/// input: DCRRowId 治疗记录RowId,PictrueCount 上传文件的计数器,filestream 单个文件流 %FileBinaryStream
/// SeccFlag 0 成功,其他 不成功
/// W ##class(DHCDoc.DHCDocCure.Record).UploadFile("74||1",1,$lg(^tmpnk("UploadFile"),3)) 
ClassMethod UploadFile(DCRRowId As %String, PictrueCount As %String, filestream As %String)
{
	;n (FilePath,OrdRowId)
	s ^tmpnk("UploadFile")=$lb(DCRRowId,PictrueCount,filestream)
	s ConfigStr=..GetFTPConfig()
	;配置属性
	s FTPIPAddr=$p(ConfigStr,"^",1)
	s FTPUser=$p(ConfigStr,"^",2)
	s FTPPassword=$p(ConfigStr,"^",3)
	s FTPPort=$p(ConfigStr,"^",4)
	;临时存储数据库服务器的路径,因为ftp上传需要从数据库服务器传输文件
	s FileLocalPath=$p(ConfigStr,"^",5)
	s UploadFilePath=$p(ConfigStr,"^",6)
	b ;get ftp
	s Ret=0
	s UploadFile=..GetUploadFilePath(UploadFilePath,DCRRowId,PictrueCount)
	Set ftp=##class(%Net.FtpSession).%New()
	d ftp.Connect(FTPIPAddr,FTPUser,FTPPassword,FTPPort)
	if 'ftp.Connected {
		quit "-110^FTP连接失败"
	}
	;判断路径是否存在,如果路径不存在则新建路径
	d ftp.MakeDirectory($p(UploadFile,"/",1,$l(UploadFile,"/")-1))
	
    Set ftp.UsePASV=0
	s Ret=..SendLargeFile(ftp,UploadFile,filestream)
	
	do ftp.Logout()
	
	do ..UpdateRecordPicData(DCRRowId,"Y")
	Q Ret
}

/// 得到上传FTP文件的全部路径(包括名称)
ClassMethod GetUploadFilePath(BasePath As %String, DCRRowId As %String, PictrueCount As %String) As %String
{
	n (BasePath,DCRRowId,PictrueCount)
	Set CureData=$g(^DHCDocCure(+DCRRowId))
	Set AdmId=$p(CureData,"^",1)
	s PatientID=$p(^PAADM(AdmId),"^",1)
	s PatientNo=$P(^PAPER(PatientID,"PAT",1),"^",2)
	s AdmDate=$p(^PAADM(AdmId),"^",6)
	s AdmDate=$zd(AdmDate,3)
	
	s DCRRowIdStr=$p(DCRRowId,"||",1)_"Z"_$p(DCRRowId,"||",2)
	if +PictrueCount=0 s PictrueCount=1
	 
	Q BasePath_PatientNo_"/"_AdmDate_"/"_"CURE_"_DCRRowIdStr_"_"_PictrueCount_".jpg"
}

/// 删除已上传到ftp的文件
/// input: OrdRowId 医嘱RowId,PictrueCount 上传文件的计数器,filestream 单个文件流
/// SeccFlag 0 成功,其他 不成功
/// w ##class(web.DHCDocMouth).DeleteFile("3983362||1")
ClassMethod DeleteFile(DCRRowId As %String) As %String
{
	KILL fileArray,key
	s ConfigStr=..GetFTPConfig()
	;配置属性
	s FTPIPAddr=$p(ConfigStr,"^",1)
	s FTPUser=$p(ConfigStr,"^",2)
	s FTPPassword=$p(ConfigStr,"^",3)
	s FTPPort=$p(ConfigStr,"^",4)
	;临时存储数据库服务器的路径,因为ftp上传需要从数据库服务器传输文件
	s FileLocalPath=$p(ConfigStr,"^",5)
	s UploadFilePath=$p(ConfigStr,"^",6)
	
	s Ret=0
	s NeedDelFile=..GetUploadFilePath(UploadFilePath,DCRRowId,0)
	s NeedDelFileDir=$p(NeedDelFile,"/",1,$l(NeedDelFile,"/")-1)
	Set ftp=##class(%Net.FtpSession).%New()
	d ftp.Connect(FTPIPAddr,FTPUser,FTPPassword,FTPPort)
	if 'ftp.Connected {
		quit "-110^FTP连接失败"
	}
	
    Set ftp.UsePASV=0
	If 'ftp.NameList(NeedDelFileDir,.fileArray){
		s ErrorMessage="得到FTP路径下的文件列表名称数组失败."
		quit "-111^"_ErrorMessage
	}
	
	d ftp.SetDirectory(NeedDelFileDir)
	s DCRRowIdStr=$p(DCRRowId,"||",1)_"Z"_$p(DCRRowId,"||",2)
	Set key=""
	s ItemCount=fileArray.Count()
	for ItemLoop=1:1:ItemCount {
		s ItemNameStr=fileArray.GetAt(ItemLoop)
		i ItemNameStr[("_"_DCRRowIdStr_"_") {
			s DelRet=ftp.Delete(ItemNameStr)
			if DelRet'=1 {
				i +Ret=0 s Ret="-112^删除"_ItemNameStr_"文件失败"
				e  s $p(Ret,"^",2)=$p(Ret,"^",2)_";删除"_ItemNameStr_"文件失败"
			}
		}
	}
	do ftp.Logout()
	do ..UpdateRecordPicData(DCRRowId,"N")
	Q Ret
}

/// 上传文件到ftp上
ClassMethod SendLargeFile(ftp As %Net.FtpSession, dir As %String, filename As %String)
{
	s $ZT="SendLargeFileErr"
	Set Ret=0
    Set filestream=##class(%FileBinaryStream).%New()
    Set sc=filestream.LinkToFile(dir)
    If $$$ISERR(sc) {
	    do $System.Status.DisplayError(sc) quit $$$ERROR()
    }
    
    //Uploaded file will have same name as the original
    Set newname=filename

    Set sc=ftp.Store(newname,filestream)
    If $$$ISERR(sc) {
	    Set Ret="-110"
	    do $System.Status.DisplayError(sc)
	    quit $$$ERROR()
    }
    
    Q Ret
SendLargeFileErr
	Q "-110"
}

ClassMethod SendLargeFileBak(ftp As %Net.FtpSession, ftpdir As %String, filestream As %FileBinaryStream)
{
	s $ZT="SendLargeFileErrBak"
	Set Ret=0
    //Uploaded file will have same name as the original
    Set newname=ftpdir

    Set sc=ftp.Store(newname,filestream)
    If $$$ISERR(sc) {
	    s ErrMessage="文件存储到FTP失败,"_$ZE
	    Set Ret="-110^"_ErrMessage
	    do $System.Status.DisplayError(sc)
	    quit $$$ERROR()
    }
    
    Q Ret
SendLargeFileErrBak
	s ErrMessage="文件存储到FTP失败,"_$ZE
	Q "-110^"_ErrMessage
}

/// 根据医嘱rowid得到已上传到ftp的文件路径串(javascript需要)
/// input: OrdRowId 医嘱RowId
/// 文件路径串
/// w ##class(DHCDoc.DHCDocCure.Record).GetFileByDCRRowID("3983362||1")  "ftp://10.160.16.112:21",
ClassMethod GetFileByDCRRowID(DCRRowID As %String, mPicPath As %String = "") As %String
{
	KILL fileArray,key
	s ConfigStr=..GetFTPConfig()
	;配置属性
	s FTPIPAddr=$p(ConfigStr,"^",1)
	s FTPUser=$p(ConfigStr,"^",2)
	s FTPPassword=$p(ConfigStr,"^",3)
	s FTPPort=$p(ConfigStr,"^",4)
	;临时存储数据库服务器的路径,因为ftp上传需要从数据库服务器传输文件
	s FileLocalPath=$p(ConfigStr,"^",5)
	s UploadFilePath=$p(ConfigStr,"^",6)
	s:mPicPath="" mPicPath="ftp://"_FTPIPAddr_":"_FTPPort
	
	s Ret=0,FilePathStr=""
	s NeedDelFile=..GetUploadFilePath(UploadFilePath,DCRRowID,0)
	s NeedDelFileDir=$p(NeedDelFile,"/",1,$l(NeedDelFile,"/")-1)
	b ;NeedDelFileDir
	Set ftp=##class(%Net.FtpSession).%New()
	d ftp.Connect(FTPIPAddr,FTPUser,FTPPassword,FTPPort)
	if 'ftp.Connected {
		quit "-110^FTP连接失败"
	}
	
    Set ftp.UsePASV=0
	If 'ftp.NameList(NeedDelFileDir,.fileArray){
		s ErrorMessage="得到FTP路径下的文件列表名称数组失败."
		quit "-111^"_ErrorMessage
	}
	
	d ftp.SetDirectory(NeedDelFileDir)
	s DCRRowIDStr=$p(DCRRowID,"||",1)_"Z"_$p(DCRRowID,"||",2)
	Set key=""
	s ItemCount=fileArray.Count()
	for ItemLoop=1:1:ItemCount {
		s ItemNameStr=fileArray.GetAt(ItemLoop)
		i ItemNameStr[("_"_DCRRowIDStr_"_") {
			i FilePathStr="" s FilePathStr=mPicPath_NeedDelFileDir_"/"_ItemNameStr
			e  s FilePathStr=FilePathStr_"!"_mPicPath_NeedDelFileDir_"/"_ItemNameStr
		}
	}
	do ftp.Logout()
	
	Q Ret_"^"_FilePathStr
}

/// ↑↑↑↑↑↑↑↑↑以上为保存图片到ftp的模式↑↑↑↑↑↑↑↑↑----
/// ↓↓↓↓↓↓↓↓↓以下为js将图片转成base64位后保存到数据库中↓↓↓↓----
/// w ##class(DHCDoc.DHCDocCure.Record).SaveRecordPic("74||1","1",$p(^tmpnk("SaveRecordPic"),",",3),"4661")
ClassMethod SaveRecordPic(DCRRowID As %String, PicName As %String, PicData, UserID As %String)
{
	s $zt="SaveRecordPicErr"
	set ^tmplog("SaveRecordPic")=DCRRowID_","_PicName_","_PicData_","_UserID
	s PicDataStream=##class(%Stream.GlobalCharacter).%New()
	if ($IsObject(PicData)) {
		d PicDataStream.CopyFrom(PicData)
	}else{
		d PicDataStream.Write(PicData) ;##class(%SYSTEM.Encryption).Base64Encode(PicData)	
	}
	set ret=0
	Ts
	set DCRPObj=##class(User.DHCDocCureRecodePicture).%New(DCRRowID)
	if $IsObject(DCRPObj){
		do DCRPObj.DCRPParRefSetObjectId(DCRRowID)
		set DCRPObj.DCRPDate=+$H
		set DCRPObj.DCRPTime=$p($H,",",2)
		do DCRPObj.DCRPUserDRSetObjectId(UserID)
		set DCRPObj.DCRPPictureName=PicName
		d DCRPObj.DCRPPictureStreamData.Clear()
		d DCRPObj.DCRPPictureStreamData.CopyFrom(PicDataStream)
		set sc=DCRPObj.%Save()
		If $$$ISERR(sc){
			Tro
			s ret="-100"	
		}else{
			set ret=..UpdateRecordPicData(DCRRowID,"Y")
			if ret'=0{
				Tro
				s ret="-101"	
			}
		}
	    do DCRPObj.%Close()
	}
	if ret=0{
		Tc	
	}
	Q ret
	
SaveRecordPicErr
	s $zt=""
	if $TLevel>0 tro
	q "-1^"_$ze
}

ClassMethod UpdateRecordPicData(DCRRowID As %String, PicFlag As %String)
{
	n (DCRRowID,PicFlag)
	s ret=0
	s DCRObj=##class(User.DHCDocCureRecode).%OpenId(DCRRowID)
	if $IsObject(DCRObj){
		s DCRObj.DCRIsPicture=PicFlag
		s sc=DCRObj.%Save()
		If $$$ISERR(sc){
			s ret="-100"	
		}
	    d DCRObj.%Close()
	}
	Q ret
}

/// w ##class(DHCDoc.DHCDocCure.Record).GetPicDataByDCRRowID("78||3")
ClassMethod GetPicDataByDCRRowID(DCRRowId As %String)
{
	n (DCRRowId)
	s DCRPChildStr=""
	s DCARowID=+DCRRowId
	s DCRChild=$p(DCRRowId,"||",2)
	s DCRPChild=0
	for  s DCRPChild=$o(^DHCDocCure(DCARowID,"Record",DCRChild,"Pic",DCRPChild)) Q:DCRPChild=""  d
	.if DCRPChildStr="" s DCRPChildStr=DCRPChild
	.else  s DCRPChildStr=DCRPChildStr_"^"_DCRPChild
	q DCRPChildStr
}

/// w ##class(DHCDoc.DHCDocCure.Record).GetPicBase64Data("78||3","13")
ClassMethod GetPicBase64Data(DCRRowId As %String, DCRPChild As %String)
{
	n (DCRRowId,DCRPChild)
	Set DCARowID=+DCRRowId
	Set DCRChild=$p(DCRRowId,"||",2)
	Set PicBase64Data="",PicName="",PicUserID=""
	Set obj=##class(User.DHCDocCureRecodePicture).%OpenId(DCRRowId_"||"_DCRPChild)
	if $IsObject(obj){
		Set PicName=obj.DCRPPictureName
		Set PicUserID=obj.DCRPUserDR.%Id()
		Set PicBase64Data=obj.DCRPPictureData
		;Set PicBase64Data=##class(%SYSTEM.Encryption).Base64Decode(PicBase64Data)
		;Set PicBase64Data=""
		;;While 'StreamData.AtEnd {
		;	Set PicBase64Data=PicBase64Data_StreamData.Read(1000)
		;}
	}
	if PicBase64Data=""{
		s ret=""
	}else{
		s ret=PicName_$c(1)_PicUserID_$c(1)_PicBase64Data
	}
	Q ret
}

/// w ##class(DHCDoc.DHCDocCure.Record).SaveRecordPic("74||1","1",$p(^tmpnk("SaveRecordPic"),",",3),"4661")
ClassMethod DelRecordPic(DCRPRowID As %String, UserID As %String)
{
	n (DCRPRowID,UserID)
	set ^tmpnk("DelRecordPic")=DCRPRowID_","_UserID
	set ret=0
	Ts
	Set sc=##class(User.DHCDocCureRecodePicture).%DeleteId(DCRPRowID)
	If $System.Status.IsError(sc) {
		Tro
		Set ret="-100"
	} Else {
		set DCRRowID=$p(DCRPRowID,"||",1,2)
		set PicDataStr=##class(DHCDoc.DHCDocCure.Record).GetPicDataByDCRRowID(DCRRowID)
		if PicDataStr=""{
			set ret=..UpdateRecordPicData(DCRRowID,"N")
			if ret'=0{
				Tro
				s ret="-101"	
			}else{
				s ret="100"	
			}
		}
	}
	if +ret'<0{
		Tc	
	}
	Q ret
}

Query QryRecordTrace(DCARRowId As %String, DCAARowID As %String = "", OEORERowID As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "DCARRowId:%String,PatientNo:%String,PatientName:%String,PatientSex:%String,PatientTel:%String,OrderAddDept:%String,ArcimDesc:%String,ApplyDate:%String,ApplyTime:%String,ApplyUser:%String,AppReqDate:%String,AppReqTime:%String,AppReqUser:%String,CRCreateDate:%String,CRCreateTime:%String,CRCreateUser:%String,CureReportUser:%String,CureReportDate:%String,CureReportTime:%String,CRCureStDate:%String,CRCureStTime:%String,CRCureEndDate:%String,CRCureEndTime:%String")
{
}

ClassMethod QryRecordTraceExecute(ByRef qHandle As %Binary, DCARRowId As %String, DCAARowID As %String = "", OEORERowID As %String = "", ExpStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Record","QryRecordTrace","","","761||3||1")
	if (DCARRowId="")&&(DCAARowID="")&&(OEORERowID=""){
		Quit $$$OK
	}
	if (DCARRowId'="")&&('$d(^DHCDocCure(+DCARRowId,"Recode",$p(DCARRowId,"||",2)))){
		Quit $$$OK
	}
	s langid=$p(ExpStr,"^",2)
	s cspName=$p(ExpStr,"^",3)
	s:cspName="" cspName="doccure.curerecord.trace.hui.csp"
	if OEORERowID'=""{
		s DCAARowID=""
		d ##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus(OEORERowID,.DCAARowID)	
		s DCARowID=$o(^DHCDocCure(0,"OEORI",$P(OEORERowID,"||",1,2),""))	
	}
	if DCARRowId'="" s DCARowID=+DCARRowId
	if (DCARRowId="")&&(DCAARowID'="") s DCARowID=+DCAARowID
	s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+DCARowID)
	s ArcimDesc="",PatientNo="",PatientName="",EpisodeId=""
	if (CureAppStr'="") d
	.s CureAppInfo=$p(CureAppStr,$c(1),2)
	.s ArcimDesc=$p(CureAppInfo,"^")
	.s ApplyDate=$p(CureAppInfo,"^",9)
	.s ApplyTime=$p(ApplyDate," ",2)
	.s ApplyDate=$p(ApplyDate," ",1)
	.s ApplyUser=$p(CureAppInfo,"^",8)
	.s OrderAddDept=$p(CureAppInfo,"^",26)
	.s PatientInfo=$p(CureAppStr,$c(1),1)
	.s PatientNo=$p(PatientInfo,"^",2)
	.s PatientName=$p(PatientInfo,"^",3)
	.s PatientSex=$p(PatientInfo,"^",4)
	.s PatientTel=$p(PatientInfo,"^",25)
	.s (CureReportUser,CureReportDate,CureReportDate)="" ;治疗报到时间，未有报到流程
	.s CRCreateUser="",CRCreateDate="",CRCreateTime="" ;治疗记录创建保存时间
	.s CRCureStDate="",CRCureStTime="" ;治疗开始时间
	.s CRCureEndDate="",CRCureEndTime="" ;治疗结束时间
	.s DCAARowId=""
	.if DCARRowId'="" d
	..s DCARData=$g(^DHCDocCure(+DCARRowId,"Recode",$p(DCARRowId,"||",2)))
	..s DCAARowId=$p(DCARData,"^",1)
	..s DCROEOREDR=$p(DCARData,"^",2)
	..s CreateUserDR=$p(DCARData,"^",5)
	..s:CreateUserDR'="" CRCreateUser=$p($g(^SSU("SSUSR",CreateUserDR)),"^",2) //治疗记录添加用户
	..s CRCreateUser=##class(DHCDoc.Common.Translate).GetTransUser(CRCreateUser,langid)
	..s CreateDate=$p(DCARData,"^",6) 
	..s CRCreateDate=##class(websys.Conversions).DateLogicalToHtml(CreateDate)
	..s CreateTime=$p(DCARData,"^",7)
	..s:CreateTime'="" CRCreateTime=$zt(CreateTime,1)
	..s CRCureStDate=$p(DCARData,"^",13) //治疗记录添加时界面上选择保存的时间
	..s CRCureStDate=##class(websys.Conversions).DateLogicalToHtml(CRCureStDate)
	..s CRCureStTime=$p(DCARData,"^",14)
	..s:CRCureStTime'="" CRCureStTime=$zt(CRCureStTime,1)
	..s CRCureEndDate=$p(DCARData,"^",18) //治疗记录添加时界面上选择保存的结束时间
	..s CRCureEndDate=##class(websys.Conversions).DateLogicalToHtml(CRCureEndDate)
	..s CRCureEndTime=$p(DCARData,"^",19)
	..s:CRCureEndTime'="" CRCureEndTime=$zt(CRCureEndTime,1)
	.if DCAARowId="" s DCAARowId=DCAARowID
	.s AppReqUser="/"_##class(websys.Translation).Get(cspName,"未预约")_"/"
	.s AppReqDate="",AppReqTime=""
	.s Data=##class(DHCDoc.DHCDocCure.Appointment).GetCureAppointment(DCAARowId)
	.if Data'="" d
	..s AppData=$p(Data,$c(1),2)
	..s AppReqUser=$p(AppData,"^",4)   //预约操作人
	..s AppReqDate=$p(AppData,"^",5)   //预约日期
	..s AppReqTime=$p(AppData,"^",6)   //预约日期
	.d OutputRowRecordTrace
	Quit $$$OK
OutputRowRecordTrace 
	set Data=$lb(DCARRowId,PatientNo,PatientName,PatientSex,PatientTel,OrderAddDept,ArcimDesc,
	ApplyDate,ApplyTime,ApplyUser,AppReqDate,AppReqTime,AppReqUser,CRCreateDate,CRCreateTime,CRCreateUser,CureReportUser,CureReportDate,CureReportTime,CRCureStDate,CRCureStTime,CRCureEndDate,CRCureEndTime)
 	Set qHandle($i(ind))=Data
 	quit
}

ClassMethod QryRecordTraceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRecordTraceExecute ]
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

ClassMethod GetCureRecordContent(DCAARowIdStr, OEORERowIDStr, HospId)
{
	n (DCAARowIdStr,OEORERowIDStr,HospId)
	s RecordContent=""
	if DCAARowIdStr'=""{
		for i=1:1:$L(DCAARowIdStr,"^"){
			s DCAARowId=$p(DCAARowIdStr,"^",i)
			s OrderId=$p($g(^DHCDocCure(+DCAARowId)),"^",2)
			s DCARowID=+DCAARowId
			d GetRecordContent
			q:RecordContent'=""
		}
	}elseif OEORERowIDStr'=""{
		for i=1:1:$L(OEORERowIDStr,"^"){
			s OEORERowID=$p(OEORERowIDStr,"^",i)
			s OrderId=$p(OEORERowID,"||",1,2)
			s DCARowID=$o(^DHCDocCure(0,"OEORI",OrderId,""))	
			continue:DCARowID=""
			d GetRecordContent
			q:RecordContent'=""
		}
	}
	if RecordContent=""{
		s RecordContent=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureRecordContent",HospId)	
	}
	q RecordContent
GetRecordContent
	s DCRChild=""
	s DCRChild=$o(^DHCDocCure(DCARowID,"Recode",DCRChild),-1)
	if DCRChild'=""{
		s RecordContent=$p($g(^DHCDocCure(DCARowID,"Recode",DCRChild)),"^",4)
	}
	if RecordContent=""{
		s RecordContent=$p($g(^DHCDocCure(DCARowID)),"^",11)
	}
	Q
}

/// w ##class(DHCDoc.DHCDocCure.Record).GetRowIdStr("459^455^453","")
ClassMethod GetRowIdStr(DCAARowIdStr, OEORERowIDStr)
{
	n (DCAARowIdStr,OEORERowIDStr,%session)
	k DataArr
	if DCAARowIdStr'=""{
		for i=1:1:$L(DCAARowIdStr,"^"){
			s DCAARowId=$p(DCAARowIdStr,"^",i)
			s DCARowID=+DCAARowId
			s DCAAdmId=$p($g(^DHCDocCure(DCARowID)),"^",1)
			s OrderId=$p($g(^DHCDocCure(DCARowID)),"^",2)
			;有关联治疗部位的独立
			s POAID=+$o(^User.DHCDocCureAppPartI("CureAppDRIndex",DCARowID,0))
			s RecordTemp=..GetRecordTemp(OrderId)
			if RecordTemp="" s RecordTemp=0
			if '$d(DataArr(DCAAdmId,RecordTemp,POAID)){
				s DataArr(DCAAdmId,RecordTemp,POAID)=DCAARowId
			}else{
				s DataArr(DCAAdmId,RecordTemp,POAID)=DataArr(DCAAdmId,RecordTemp,POAID)_"^"_DCAARowId
			}
		}
	}elseif OEORERowIDStr'=""{
		for i=1:1:$L(OEORERowIDStr,"^"){
			s OEORERowID=$p(OEORERowIDStr,"^",i)
			s OrderId=$p(OEORERowID,"||",1,2)
			s DCARowID=$o(^DHCDocCure(0,"OEORI",OrderId,""))	
			continue:DCARowID=""
			s DCAAdmId=$p($g(^DHCDocCure(DCARowID)),"^",1)
			;有关联治疗部位的独立
			s POAID=+$o(^User.DHCDocCureAppPartI("CureAppDRIndex",DCARowID,0))
			s RecordTemp=..GetRecordTemp(OrderId)
			if RecordTemp="" s RecordTemp=0
			if '$d(DataArr(DCAAdmId,RecordTemp,POAID)){
				s DataArr(DCAAdmId,RecordTemp,POAID)=OEORERowID
			}else{
				s DataArr(DCAAdmId,RecordTemp,POAID)=DataArr(DCAAdmId,RecordTemp,POAID)_"^"_OEORERowID
			}
		}
	}
	s ArrayObj=##class(DHCDoc.Util.ArrayData).%New()
	s ListDataObj=##class(DHCDoc.Util.ListData).%New()
	s RetObj={}
	s RetObj.List=[]
	s adm=""
	for{
		s adm=$o(DataArr(adm))
		Q:adm=""
		s tmp=""
		for{
			s tmp=$o(DataArr(adm,tmp))
			Q:tmp=""
			s poa=""
			for{
				s poa=$o(DataArr(adm,tmp,poa))
				Q:poa=""
				s JsonObj={}
				s JsonArray=##class(DHCDoc.Util.ArrayData).%New()
				s idstr=DataArr(adm,tmp,poa)
				s DCATempId=tmp
				s:+DCATempId=0 DCATempId=""
				d JsonArray.SetAt(adm,"DCAAdmId")
				d JsonArray.SetAt(DCATempId,"DCATempId")
				d JsonArray.SetAt(DCAARowIdStr,"DCAARowIdStr")
				d JsonArray.SetAt(OEORERowIDStr,"OEORERowIDStr")
				d:DCAARowIdStr'="" JsonArray.SetAt(idstr,"DCAARowIdStr")
				d:OEORERowIDStr'="" JsonArray.SetAt(idstr,"OEORERowIDStr")
				d ListDataObj.Insert(JsonArray)
			}
		}
	}
	d ArrayObj.SetAt(ListDataObj,"List")
	s JsonStr=##class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
	Q JsonStr.Read()
}

ClassMethod GetRecordTemp(OEORIRowID As %String, HospID As %String = "")
{
	n (OEORIRowID,HospID,%session)
	if HospID=""{
		s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId()
	}
	s RelateTemp=""
	if OEORIRowID'=""{
		Set DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByOrd(OEORIRowID,HospID)
		if DDCISRowid'=""{
			s RelateTemp=##class(DHCDoc.DHCDocCure.CureItemSet).GetRelateTemp(DDCISRowid,"R")
			if RelateTemp=""{
				s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
				s SGRecordTemp=##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).GetGroupRelateRecordTemp(ServiceGroupDR)	
				if SGRecordTemp'=""{
					s RelateTemp=$p(SGRecordTemp,"^",1)
				}
			}
		}
	}
	if RelateTemp=""{
		s CureDefRecordTemp=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureDefRecordTemp",HospID)	
		s:CureDefRecordTemp="" CureDefRecordTemp="CR-Common"	
		if CureDefRecordTemp'=""{
			s RelateTemp=$o(^DHCDocAppBLMapi("MapCode",CureDefRecordTemp,""))
		}
	}
	Q RelateTemp
}

ClassMethod FormatReturnMsg(DCAARowId, ErrMsg, OEORERowId As %String = "", TransExpStr As %String = "")
{
	n (DCAARowId,ErrMsg,OEORERowId,TransExpStr,%session)
	s HospID=$p(TransExpStr,"^",1)
	s langid=$p(TransExpStr,"^",2)
	s cspName=$p(TransExpStr,"^",3)
    s:langid="" langid=..%LanguageID()
    s:cspName="" cspName="doccure.worklist.hui.csp"
	s DCARowId=""
	if DCAARowId'=""{
		s DCARowId=+DCAARowId
		s DCAAASRowID=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",1)
		s DDCRSDate=$p($g(^DHCDocCureRBCResSchdule(DCAAASRowID)),"^",4)  //出诊日期
		s DDCRSDate=##class(websys.Conversions).DateLogicalToHtml(DDCRSDate)
		s DDCRSTimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(DCAAASRowID)),"^",5)  //排程出诊时段
		s DDCRSTimeRangeDesc=$P($G(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",2)
		s DDCRSTimeRangeDesc=##class(User.DHCDocCureRBCTimePeriodSet).GetTranByDesc("DDCTSDesc",DDCRSTimeRangeDesc,langid)
		s DCAAppSeqNo=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",13)
		s ItemInfo=DDCRSDate_"("_DDCRSTimeRangeDesc_")"_DCAAppSeqNo_##class(websys.Translation).Get(cspName,"号")
	}elseif OEORERowId'=""{
		s OEORIRowID=$P(OEORERowId,"||",1,2)
		s DCARowId=$o(^DHCDocCure(0,"OEORI",OEORIRowID,""))
		s execdata=$g(^OEORD(+OEORERowId,"I",$P(OEORERowId,"||",2),"X",$P(OEORERowId,"||",3)))
		s OEOREExStDate=$p(execdata,"^",1)
		s:OEOREExStDate'="" OEOREExStDate=##class(websys.Conversions).DateLogicalToHtml(OEOREExStDate)
		s OEOREExStTime=$p(execdata,"^",2)
		s:OEOREExStTime'="" OEOREExStTime=$zt(OEOREExStTime,1)
		s DDCRSDate=OEOREExStDate_" "_OEOREExStTime
		s ItemInfo=" "_##class(websys.Translation).Get(cspName,"要求执行日期")_":"_DDCRSDate
	}
	if DCARowId=""{
		Q ErrMsg 	
	}
	s CureAppStr=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(DCARowId)
	s ArcimDesc="",PatientNo="",PatientName=""
	if (CureAppStr'=""){
		s CureAppInfo=$p(CureAppStr,$c(1),2)
		s ArcimDesc=$p(CureAppInfo,"^")
		s PatientInfo=$p(CureAppStr,$c(1),1)
		s PatientNo=$p(PatientInfo,"^",2)
		s PatientName=$p(PatientInfo,"^",3)
	}
	Q PatientName_" "_ArcimDesc_" "_ItemInfo_","_##class(websys.Translation).Get(cspName,"治疗记录操作失败")_":"_##class(websys.Translation).Get(cspName,ErrMsg)
}

}
