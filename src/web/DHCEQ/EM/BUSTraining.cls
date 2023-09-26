Import SQLUser

/// 培训考核
/// add by csj 2020-05-18
Class web.DHCEQ.EM.BUSTraining Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.EM.BUSTraining).DeleteRecordList("65")
ClassMethod DeleteRecordList(DelRowid)
{
	new Length,TRRLRowID,Flag,i
	s Flag=0
	i DelRowid="" q 0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s TRRLRowID=$p(DelRowid,",",i)
		if (TRRLRowID>0)
		{
			&SQL(delete from sqluser.DHC_EQTrainingRecordList where TRRL_RowID=:TRRLRowID)
			i SQLCODE s Flag=TRRLRowID_"^更新操作失败"
		}
	}
	q Flag
}

/// w ##Class(web.DHCEQ.EM.BUSTraining).SaveRecordList("241","1^365^^361^担架车^2^30^2^922^1601")
ClassMethod SaveRecordList(TRRowID, val)
{
	new (TRRowID, val)
	i TRRowID="" q -1
	i val="" q 0
	s Flag=0
	s PLISTMX(2)=TRRowID  				;TRRL_TrainingRecordDR
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,"&",i)
		s TRRLRowID= $p(valList,"^",1)
		s PLISTMX(3)=$p(valList,"^",2)  	;TRRL_TrainUserDR
		s PLISTMX(4)=$p(valList,"^",3)		;TRRL_Status
		s PLISTMX(5)=##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",4),"time")	;TRRL_CheckinTime
		s PLISTMX(6)=$p(valList,"^",5)  	;TRRL_Remark
		s PLISTMX(7)="N"  					;TRRL_InvalidFlag
		;Set PLIST(8) = ""	;TRRL_Hold1
	 	;Set PLIST(9) = ""	;TRRL_Hold2
	 	;Set PLIST(10) = ""	;TRRL_Hold3
	 	;Set PLIST(11) = ""	;TRRL_Hold4
	 	;Set PLIST(12) = ""	;TRRL_Hold5

		if (TRRLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQTrainingRecordList Values :PLISTMX())
			s TRRLRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQTrainingRecordList values :PLISTMX() where TRRL_RowID=:TRRLRowID)
		}
		i SQLCODE s Flag=index_"^更新明细记录失败!"
	}
	q Flag
}

/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSTraining).DeleteTrainingRecord(3)
ClassMethod DeleteTrainingRecord(RowID)
{
	Set $ZT="ERRORDelete"
	
	&SQL(Update SQLUSER.DHC_EQTrainingRecord Set TRR_InvalidFlag='Y' where TRR_RowID=:RowID)
 	q SQLCODE_"^"_RowID
ERRORDelete 
	Set ErrorMsg=$ZE
 	Quit "ERRORDelete"_ErrorMsg
}

/// 查询课程培训登记记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSTraining","GetTrainingRecord","")
Query GetTrainingRecord(StartDate As %String = "", EndDate As %String = "", Status As %String = "", CourseName As %String = "", LocDR As %String = "", Institution As %String = "", TrainPlace As %String = "", SourceType As %String = "", SourceID As %String = "", TrainingUser As %String = "", ItemDR As %String = "", ModelDR As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TNo:%String,TName:%String,TTrainingDR:%String,TCOName:%String,TStage:%String,TLocDR:%String,TLoc:%String,TInstitution:%String,TTrainPlace:%String,TSourceType:%String,TSourceID:%String,TManager:%String,TItem,TModel,TTrainingUser:%String,TTrainContent:%String,TTrainType:%String,TTrainStartDate:%String,TTrainStartTime:%String,TTrainEndDate:%String,TTrainEndTime:%String,TClassHours:%String,TRemark:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetTrainingRecordExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", Status As %String = "", CourseName As %String = "", LocDR As %String = "", Institution As %String = "", TrainPlace As %String = "", SourceType As %String = "", SourceID As %String = "", TrainingUser As %String = "", ItemDR As %String = "", ModelDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	;s ^DHCEQMozy("GetTrainingRecord")=StartDate_","_EndDate_","_Status_","_CourseName_","_LocDR_","_Institution_","_TrainPlace_","_SourceType_","_SourceID
	i StartDate'="" s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate'="" s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	s rowid=0
	f  s rowid=$o(^DHCEQTrainingRecord(rowid)) quit:rowid=""  d
	.d ResetVariablesGetTrainingRecord
	.s TRowID = rowid
	.s TNo = $p($g(^DHCEQTrainingRecord(rowid)),"^",1)
	.s TTrainingDR = $p($g(^DHCEQTrainingRecord(rowid)),"^",2)
	.i TTrainingDR'="" d
	..s TCOName=$p($g(^DHCEQCourse(TTrainingDR)),"^",2)		;CO_Name
	..s TManager=$p($g(^DHCEQCourse(TTrainingDR)),"^",3)
	..s TInstitution=$p($g(^DHCEQCourse(TTrainingDR)),"^",4)
	..s TSourceType=$p($g(^DHCEQCourse(TTrainingDR)),"^",7)
	..s TSourceID=$p($g(^DHCEQCourse(TTrainingDR)),"^",8)
	..s TItem=$p($g(^DHCEQCourse(TTrainingDR)),"^",9)
	..s TModel=$p($g(^DHCEQCourse(TTrainingDR)),"^",10)
	..s TRemark = $p($g(^DHCEQCourse(TTrainingDR)),"^",14) //add by csj 2020-06-08 课程备注
	.q:(Institution'="")&&(TInstitution'[Institution)
	.q:(SourceType'="")&&(TSourceType'=SourceType)
	.q:(ItemDR'="")&&(TItem'=ItemDR)
	.q:(ModelDR'="")&&(TModel'=ModelDR)
	.i TSourceType=0 d
	..s TSourceID = ##Class(web.DHCEQCommon).GetTrakNameByID("masteritem", TSourceID)
	.else  if TSourceType=1 d
	..s TSourceID = $p($g(^DHCEQEquip(TSourceID)),"^",1)
	.else  if TSourceType=2 d
	..s TSourceID = $o(^DHCEQOpenCheckList("0","OpenCheckRequest",TSourceID,""))
	..s TSourceID = $p($g(^DHCEQOpenCheckList(TSourceID)),"^",2)
	.s TSourceType=$CASE(TSourceType,"0":"设备项","1":"设备","2":"验收单","":"")
	.s TItem = ##Class(web.DHCEQCommon).GetTrakNameByID("masteritem", TItem)
	.s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model", TModel)
	.
	.s TName = $p($g(^DHCEQTrainingRecord(rowid)),"^",3)
	.q:(CourseName'="")&&(TName'[CourseName)
	.s TStage = $p($g(^DHCEQTrainingRecord(rowid)),"^",4)
	.s TLocDR = $p($g(^DHCEQTrainingRecord(rowid)),"^",5)
	.q:(LocDR'="")&&(TLocDR'=LocDR)
	.s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.s TTrainPlace = $p($g(^DHCEQTrainingRecord(rowid)),"^",6)
	.q:(TrainPlace'="")&&(TTrainPlace'[TrainPlace)
	.s TTrainingUser = $p($g(^DHCEQTrainingRecord(rowid)),"^",7)
	.q:(TrainingUser'="")&&(TTrainingUser'[TrainingUser)
	.s TTrainContent = $p($g(^DHCEQTrainingRecord(rowid)),"^",8)
	.s TTrainType = $p($g(^DHCEQTrainingRecord(rowid)),"^",9)
	.s TTrainStartDate = $p($g(^DHCEQTrainingRecord(rowid)),"^",10)
	.q:(StartDate'="")&&(TTrainStartDate<StartDate)
	.s TTrainStartDate=##class(web.DHCEQCommon).TransValueToPage(TTrainStartDate,"date")
	.s TTrainStartTime = $p($g(^DHCEQTrainingRecord(rowid)),"^",11)
	.s TTrainStartTime=##class(web.DHCEQCommon).TransValueToPage(TTrainStartTime,"time")
	.s TTrainEndDate = $p($g(^DHCEQTrainingRecord(rowid)),"^",12)
	.q:(EndDate'="")&&(TTrainEndDate>EndDate)
	.s TTrainEndDate=##class(web.DHCEQCommon).TransValueToPage(TTrainEndDate,"date")
	.s TTrainEndTime = $p($g(^DHCEQTrainingRecord(rowid)),"^",13)
	.s TTrainEndTime=##class(web.DHCEQCommon).TransValueToPage(TTrainEndTime,"time")
	.s TClassHours = $p($g(^DHCEQTrainingRecord(rowid)),"^",14)
	.;s TRemark = $p($g(^DHCEQTrainingRecord(rowid)),"^",15) //modified by csj 2020-06-08 改为从取课程备注
	.s TStatus = $p($g(^DHCEQTrainingRecord(rowid)),"^",16)
	.q:(Status'="")&&(TStatus'=Status)
	.s TStatus = $CASE(TStatus,"0":"新增","2":"审核","3":"作废","":"")
	.s TInvalidFlag = $p($g(^DHCEQTrainingRecord(rowid)),"^",17)
	.q:(TInvalidFlag="Y")
	.s THold1 = $p($g(^DHCEQTrainingRecord(rowid)),"^",18)
	.s THold2 = $p($g(^DHCEQTrainingRecord(rowid)),"^",19)
	.s THold3 = $p($g(^DHCEQTrainingRecord(rowid)),"^",20)
	.s THold4 = $p($g(^DHCEQTrainingRecord(rowid)),"^",21)
	.s THold5 = $p($g(^DHCEQTrainingRecord(rowid)),"^",22)
	.d OutputRowGetTrainingRecord
	Quit $$$OK
OutputRowGetTrainingRecord
	Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TNo,TName,TTrainingDR,TCOName,TStage,TLocDR,TLoc,TInstitution,TTrainPlace,TSourceType,TSourceID,TManager,TItem,TModel,TTrainingUser,TTrainContent,TTrainType,TTrainStartDate,TTrainStartTime,TTrainEndDate,TTrainEndTime,TClassHours,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetTrainingRecord
	Set (TRowID,TNo,TName,TTrainingDR,TCOName,TStage,TLocDR,TLoc,TInstitution,TTrainPlace,TSourceType,TSourceID,TManager,TItem,TModel,TTrainingUser,TTrainContent,TTrainType,TTrainStartDate,TTrainStartTime,TTrainEndDate,TTrainEndTime,TClassHours,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetTrainingRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTrainingRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTrainingRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTrainingRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询课程培训登记明细记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSTraining","GetTrainingRecordDetail","","",2)
Query GetTrainingRecordDetail(StartDate As %String = "", EndDate As %String = "", Status As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TNo:%String,TName:%String,TTrainingDR:%String,TCOName:%String,TStage:%String,TLocDR:%String,TLoc:%String,TTrainPlace:%String,TTrainingUser:%String,TTrainContent:%String,TTrainType:%String,TTrainStartDate:%String,TTrainStartTime:%String,TTrainEndDate:%String,TTrainEndTime:%String,TClassHours:%String,TRemark:%String,TStatus:%String,TrainUserDR:%String,TUserDR:%String,TrainUser:%String,TRRLStatus:%String,TCheckinTime:%String,TRRLRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetTrainingRecordDetailExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", Status As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	i StartDate'="" s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate'="" s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	s TRDR=0
	f  s TRDR=$o(^DHCEQTrainingRecordList(0,"TrainingRecord",TRDR)) quit:TRDR=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQTrainingRecordList(0,"TrainingRecord",TRDR,rowid)) quit:rowid=""  d
	..d ResetVariablesGetTRDetail
	..s TRowID = rowid
	..s TNo = $p($g(^DHCEQTrainingRecord(TRDR)),"^",1)
	..s TTrainingDR = $p($g(^DHCEQTrainingRecord(TRDR)),"^",2)
	..i TTrainingDR'="" s TCOName=$p($g(^DHCEQCourse(TTrainingDR)),"^",2)		;CO_Name
	..s TName = $p($g(^DHCEQTrainingRecord(TRDR)),"^",3)
	..s TStage = $p($g(^DHCEQTrainingRecord(TRDR)),"^",4)
	..s TLocDR = $p($g(^DHCEQTrainingRecord(TRDR)),"^",5)
	..s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	..s TTrainPlace = $p($g(^DHCEQTrainingRecord(TRDR)),"^",6)
	..s TTrainingUser = $p($g(^DHCEQTrainingRecord(TRDR)),"^",7)
	..s TTrainContent = $p($g(^DHCEQTrainingRecord(TRDR)),"^",8)
	..s TTrainType = $p($g(^DHCEQTrainingRecord(TRDR)),"^",9)
	..s TTrainStartDate = $p($g(^DHCEQTrainingRecord(TRDR)),"^",10)
	..q:(StartDate'="")&&(TTrainStartDate<StartDate)
	..s TTrainStartDate=##class(web.DHCEQCommon).TransValueToPage(TTrainStartDate,"date")
	..s TTrainStartTime = $p($g(^DHCEQTrainingRecord(TRDR)),"^",11)
	..s TTrainStartTime=##class(web.DHCEQCommon).TransValueToPage(TTrainStartTime,"time")
	..s TTrainEndDate = $p($g(^DHCEQTrainingRecord(TRDR)),"^",12)
	..q:(EndDate'="")&&(TTrainEndDate>EndDate)
	..s TTrainEndDate=##class(web.DHCEQCommon).TransValueToPage(TTrainEndDate,"date")
	..s TTrainEndTime = $p($g(^DHCEQTrainingRecord(TRDR)),"^",13)
	..s TTrainEndTime=##class(web.DHCEQCommon).TransValueToPage(TTrainEndTime,"time")
	..s TClassHours = $p($g(^DHCEQTrainingRecord(TRDR)),"^",14)
	..s TRemark = $p($g(^DHCEQTrainingRecord(TRDR)),"^",15)
	..s TStatus = $p($g(^DHCEQTrainingRecord(TRDR)),"^",16)
	..q:(Status'="")&&(TStatus'=Status)
	..s TStatus = $CASE(TStatus,"0":"新增","2":"审核","3":"作废","":"")
	..s TInvalidFlag = $p($g(^DHCEQTrainingRecord(TRDR)),"^",17)
	..q:(TInvalidFlag="Y")
	..s TrainUserDR=$p($g(^DHCEQTrainingRecordList(rowid)),"^",2)
	..s TUserDR=$p($g(^DHCEQTrainingUser(TrainUserDR)),"^",1)
	..s TrainUser=$p($g(^DHCEQCCode("DHCEQCUser",TUserDR)),"^",4)
	..s TRRLStatus=$p($g(^DHCEQTrainingRecordList(rowid)),"^",3)
	..s TRRLStatus = $CASE(TRRLStatus,"1":"正常","2":"请假","3":"缺席","":"")
	..s TCheckinTime=$p($g(^DHCEQTrainingRecordList(rowid)),"^",4)
	..s TCheckinTime=##class(web.DHCEQCommon).TransValueToPage(TCheckinTime,"time")
	..s TRRLRemark=$p($g(^DHCEQTrainingRecordList(rowid)),"^",5)
	..s TInvalidFlag=$p($g(^DHCEQTrainingRecordList(rowid)),"^",6)
	..q:(TInvalidFlag="Y")
	..s THold1 = $p($g(^DHCEQTrainingRecordList(rowid)),"^",7)
	..s THold2 = $p($g(^DHCEQTrainingRecordList(rowid)),"^",8)
	..s THold3 = $p($g(^DHCEQTrainingRecordList(rowid)),"^",9)
	..s THold4 = $p($g(^DHCEQTrainingRecordList(rowid)),"^",10)
	..s THold5 = $p($g(^DHCEQTrainingRecordList(rowid)),"^",11)
	..d OutputRowGetTRDetail
	Quit $$$OK
OutputRowGetTRDetail
	Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TNo,TName,TTrainingDR,TCOName,TStage,TLocDR,TLoc,TTrainPlace,TTrainingUser,TTrainContent,TTrainType,TTrainStartDate,TTrainStartTime,TTrainEndDate,TTrainEndTime,TClassHours,TRemark,TStatus,TrainUserDR,TUserDR,TrainUser,TRRLStatus,TCheckinTime,TRRLRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetTRDetail
	Set (TRowID,TNo,TName,TTrainingDR,TCOName,TStage,TLocDR,TLoc,TTrainPlace,TTrainingUser,TTrainContent,TTrainType,TTrainStartDate,TTrainStartTime,TTrainEndDate,TTrainEndTime,TClassHours,TRemark,TStatus,TrainUserDR,TUserDR,TrainUser,TRRLStatus,TCheckinTime,TRRLRemark,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetTrainingRecordDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTrainingRecordDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTrainingRecordDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTrainingRecordDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 人员培训成绩表
/// w ##class(web.DHCEQ.EM.BUSTraining).SaveTrainingUser("{""TUTrainUser"":""Demo Group"",""TURemark"":""13125116998"",""NewCourceFlag"":false,""SelectCourse"":""核磁共振培训"",""COName"":""核磁共振培训"",""TRRLoc"":"""",""COInstitution"":"""",""TRRTrainingUser"":""11"",""COSourceTypeDesc"":""设备项"",""COSource"":""154栋维修队用房"",""COItem"":""154栋维修队用房"",""COModel"":"""",""TRRTrainPlace"":"""",""TRRTrainType"":"""",""TRRTrainStartDate"":""2020-05-18"",""TRRTrainEndDate"":""2020-05-18"",""TRRTrainStartTime"":"""",""TRRTrainEndTime"":"""",""CONo"":"""",""TRRNo"":"""",""TRRStage"":"""",""CORowID"":""8"",""TRRRowID"":""16"",""COOpenCheckDR"":"""",""TRRLocDR"":"""",""COSourceType"":""0"",""COSourceID"":""1345"",""COItemDR"":""1345"",""COModelDR"":"""",""TURowID"":"""",""TUTrainUserDR"":""1"",""TRRStatus"":""0"",""COCourseContent"":""1"",""COTrainObj"":""2"",""CORemark"":""3""}",0)
ClassMethod SaveTrainingUser(val As %String = "", isDel As %String = "")
{
	i val="" q 0
	new RowID
	Kill PLIST
	
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQTrainingUser",JsonData,.PLIST)
	Set PLIST(3) = JsonData.CORowID	;TU_TrainingDR
	Set PLIST(4) = JsonData.TRRStage
	Set PLIST(12) = "N"					;TU_InvalidFlag
	
	Set RowID=JsonData.TURowID
	
	i (+isDel=1)
	{
		&SQL(update SQLUSER.DHC_EQTrainingUser set TU_InvalidFlag='Y' where TU_RowID = :val)
	 	 if (SQLCODE)&(SQLCODE'=100)
	 	 {
		 	 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 	 }
	 	 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
 	}
 	If RowID=""
 	{
	 	s count=0
	 	if (PLIST(4)="")
	 	{
		 	&SQL(select count(1) into :count from sqluser.DHC_EQTrainingUser where TU_TrainingDR=:PLIST(3) and TU_Stage is NULL and TU_TrainUserDR=:PLIST(2) and TU_InvalidFlag!='Y')
		}else{
		 	&SQL(select count(1) into :count from sqluser.DHC_EQTrainingUser where TU_TrainingDR=:PLIST(3) and TU_Stage=:PLIST(4) and TU_TrainUserDR=:PLIST(2) and TU_InvalidFlag!='Y')
		}
		if count'=0 
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9210,JsonData.TUTrainUser)
		}
		&SQL(insert into sqluser.DHC_EQTrainingUser values :PLIST())
		If SQLCODE
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		Set RowID=$Get(%ROWID)
 	}
 	Else
 	{
		&SQL(update sqluser.DHC_EQTrainingUser values :PLIST() where TU_RowID=:RowID)
		If SQLCODE
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
 	}
 	
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
}

/*
/// 考核登记表
/// w ##class(web.DHCEQ.EM.BUSTraining).SaveTrainingScore("^52^24407^1^")
ClassMethod SaveTrainingScore(val As %String = "", valList As %String = "", DelRowid As %String = "")
{
	i val="" q 0
	new RowID
	Set $ZT="ERRORSaveTrainingScore"
	Kill PLIST
	
	Set RowID=$Piece(val,"^",1)
	Set PLIST(2) = $Piece(val,"^",2)	;TS_No
 	Set PLIST(3) = $Piece(val,"^",3)	;TS_TrainingDR
 	Set PLIST(4) = $Piece(val,"^",4)	;TS_Stage
 	Set PLIST(5) = $Piece(val,"^",5)	;TS_Desc
 	Set PLIST(6) = $Piece(val,"^",6)	;TS_Manager
 	Set PLIST(7) = $Piece(val,"^",7)	;TS_LocDR
 	Set PLIST(8) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;TS_ExamStartDate
 	Set PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"time")	;TS_ExamStartTime
 	Set PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;TS_ExamEndDate
 	Set PLIST(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"time")	;TS_ExamEndTime
 	Set PLIST(12) = $Piece(val,"^",12)	;TS_ExamContent
 	Set PLIST(13) = $Piece(val,"^",13)	;TS_Num
 	Set PLIST(14) = $Piece(val,"^",14)	;TS_Remark
 	Set PLIST(15) = 0					;TS_Status		0:新增|2:审核|3:作废
 	Set PLIST(16) = "N"					;TS_InvalidFlag
 	Set PLIST(17) = ""					;TS_Hold1
 	Set PLIST(18) = ""					;TS_Hold2
 	Set PLIST(19) = ""					;TS_Hold3
 	Set PLIST(20) = ""					;TS_Hold4
 	Set PLIST(21) = ""					;TS_Hold5
	
	TSTART	
 	If RowID=""
 	{
		&SQL(insert into sqluser.DHC_EQTrainingScore values :PLIST())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set RowID=$Get(%ROWID)
 	}
 	Else
 	{
		&SQL(update sqluser.DHC_EQTrainingScore values :PLIST() where TS_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
 	}
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSTraining).DeleteScoreList(DelRowid)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSTraining).SaveScoreList(RowID,valList)
 	i SQLCODE
 	{
		TROLLBACK
		Quit SQLCODE
 	}
	TCOMMIT
 	Quit SQLCODE_"^"_RowID
ERRORSaveTrainingScore
	TRollBack
	Set ErrorMsg=$ZE
 	Quit "<ERRORSaveTrainingScore>"_ErrorMsg
}
*/
/// w ##Class(web.DHCEQ.EM.BUSTraining).DeleteScoreList("65")
ClassMethod DeleteScoreList(DelRowid)
{
	new Length,TSLRowID,Flag,i
	s Flag=0
	i DelRowid="" q 0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s TSLRowID=$p(DelRowid,",",i)
		if (TRRLRowID>0)
		{
			&SQL(delete from sqluser.DHC_EQTrainingScoreList where TSL_RowID=:TSLRowID)
			i SQLCODE s Flag=TSLRowID_"^更新操作失败"
		}
	}
	q Flag
}

/// w ##Class(web.DHCEQ.EM.BUSTraining).SaveRecordList("241","1^365^^361^担架车^2^30^2^922^1601")
ClassMethod SaveScoreList(TSRowID, val)
{
	new (TSRowID, val)
	i (TSRowID="")||(val="") q -1
	s Flag=0
	s PLISTMX(2)=TSRowID  				;TSL_TrainingScoreDR
	
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,"&",i)
		s TSLRowID= $p(valList,"^",1)
		s PLISTMX(3)=$p(valList,"^",2)  	;TSL_TrainUserDR
		s PLISTMX(4)=$p(valList,"^",3)		;TSL_Forms
		s PLISTMX(5)=$p(valList,"^",4)		;TSL_PassFlag
		s PLISTMX(6)=$p(valList,"^",5)  	;TSL_Score
		s PLISTMX(7)=$p(valList,"^",6)  	;TSL_Remark
		s PLISTMX(8)="N"  					;TSL_InvalidFlag
		;Set PLIST(9) = ""	;TSL_Hold1
	 	;Set PLIST(10) = ""	;TSL_Hold2
	 	;Set PLIST(11) = ""	;TSL_Hold3
	 	;Set PLIST(12) = ""	;TSL_Hold4
	 	;Set PLIST(13) = ""	;TSL_Hold5
		if (TRRLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQTrainingRecordList Values :PLISTMX())
			s TRRLRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQTrainingRecordList values :PLISTMX() where TRRL_RowID=:TSLRowID)
		}
		i SQLCODE s Flag=index_"^更新明细记录失败!"
	}
	q Flag
}

/// 查询考核登记记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSTraining","GetTrainingScore","")
/// modify by jyp 2021-05-31 JYP0028  1598144 增加参数Stage对期次进行过滤
Query GetTrainingScore(No As %String = "", Desc As %String = "", Manager As %String = "", LocDR As %String = "", TrainingDR As %String = "", Stage As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TNo:%String,TTrainingDR:%String,TStage:%String,TDesc:%String,TManager:%String,TLocDR:%String,TLoc:%String,TExamStartDate:%String,TExamStartTime:%String,TExamEndDate:%String,TExamEndTime:%String,TExamContent:%String,TNum:%String,TRemark:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetTrainingScoreExecute(ByRef qHandle As %Binary, No As %String = "", Desc As %String = "", Manager As %String = "", LocDR As %String = "", TrainingDR As %String = "", Stage As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	
	s rowid=0
	f  s rowid=$o(^DHCEQTrainingScore(rowid)) quit:rowid=""  d
	.d ResetVariablesGetTrainingScore
	.s TInvalidFlag = $p($g(^DHCEQTrainingScore(rowid)),"^",15)
	.q:(TInvalidFlag'="N")
	.s TRowID = rowid
	.s TNo = $p($g(^DHCEQTrainingScore(rowid)),"^",1)
	.q:(No'="")&&(TNo'[No)
	.s TTrainingDR = $p($g(^DHCEQTrainingScore(rowid)),"^",2)
	.q:(TTrainingDR'=TrainingDR)
	.s TStage = $p($g(^DHCEQTrainingScore(rowid)),"^",3)
	.q:(Stage'="")&&(Stage'=TStage) 
	.s TDesc = $p($g(^DHCEQTrainingScore(rowid)),"^",4)
	.q:(Desc'="")&&(TDesc'[Desc)
	.s TManager = $p($g(^DHCEQTrainingScore(rowid)),"^",5)
	.q:(Manager'="")&&(TManager'[Manager)
	.s TLocDR = $p($g(^DHCEQTrainingScore(rowid)),"^",6)
	.q:(LocDR'="")&&(TLocDR'=LocDR)
	.s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.s TExamStartDate = $p($g(^DHCEQTrainingScore(rowid)),"^",7)
	.s TExamStartDate=##class(web.DHCEQCommon).TransValueToPage(TExamStartDate,"date")
	.s TExamStartTime = $p($g(^DHCEQTrainingScore(rowid)),"^",8)
	.s TExamStartTime=##class(web.DHCEQCommon).TransValueToPage(TExamStartTime,"time")
	.s TExamEndDate = $p($g(^DHCEQTrainingScore(rowid)),"^",9)
	.s TExamEndDate=##class(web.DHCEQCommon).TransValueToPage(TExamEndDate,"date")
	.s TExamEndTime = $p($g(^DHCEQTrainingScore(rowid)),"^",10)
	.s TExamEndTime=##class(web.DHCEQCommon).TransValueToPage(TExamEndTime,"time")
	.s TExamContent = $p($g(^DHCEQTrainingScore(rowid)),"^",11)
	.s TNum = $p($g(^DHCEQTrainingScore(rowid)),"^",12)
	.s TRemark = $p($g(^DHCEQTrainingScore(rowid)),"^",13)
	.s TStatus = $p($g(^DHCEQTrainingScore(rowid)),"^",14)
	.
	.s THold1 = $p($g(^DHCEQTrainingScore(rowid)),"^",16)
	.s THold2 = $p($g(^DHCEQTrainingScore(rowid)),"^",17)
	.s THold3 = $p($g(^DHCEQTrainingScore(rowid)),"^",18)
	.s THold4 = $p($g(^DHCEQTrainingScore(rowid)),"^",19)
	.s THold5 = $p($g(^DHCEQTrainingScore(rowid)),"^",20)
	.d OutputRowGetTrainingScore
	
	Quit $$$OK
OutputRowGetTrainingScore
	Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TNo,TTrainingDR,TStage,TDesc,TManager,TLocDR,TLoc,TExamStartDate,TExamStartTime,TExamEndDate,TExamEndTime,TExamContent,TNum,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetTrainingScore
	Set (TRowID,TNo,TTrainingDR,TStage,TDesc,TManager,TLocDR,TLoc,TExamStartDate,TExamStartTime,TExamEndDate,TExamEndTime,TExamContent,TNum,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetTrainingScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTrainingScoreExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTrainingScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTrainingScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSTraining).SaveTrainingRecord("{""TUTrainUser"":"""",""TURemark"":"""",""COName"":""设备管理系统培训"",""TRRLoc"":""呼吸内科门诊"",""COInstitution"":""设备科"",""TRRTrainingUser"":""csj"",""COSourceTypeDesc"":""设备项"",""COSource"":""154栋维修队用房"",""COItem"":""154栋维修队用房"",""COModel"":"""",""TRRTrainPlace"":""9-2-1"",""TRRTrainType"":""现场授课"",""TRRTrainStartDate"":""2020-05-11"",""TRRTrainEndDate"":""2020-05-11"",""TRRTrainStartTime"":""09:00"",""TRRTrainEndTime"":""11:00"",""CORowID"":"""",""TRRRowID"":"""",""COOpenCheckDR"":"""",""TRRLocDR"":""1"",""COSourceType"":""0"",""COSourceID"":""1345"",""COItemDR"":""1345"",""COModelDR"":"""",""TURowID"":"""",""TUTrainUserDR"":"""",""COCourseContent"":""课程内容"",""COTrainObj"":""培训目标"",""CORemark"":""备注\t""}",0)
ClassMethod SaveTrainingRecord(data, DelIs)
{
	s $ZT="ERRORTrainingRecord"
	k PLIST,RowID,TPLIST
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	TSTART
	if DelIs=1
	{
		s TRRRowID=data
		&SQL(Update sqluser.DHC_EQTrainingRecord set TRR_InvalidFlag='Y' where TRR_RowID = :TRRRowID)
		
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
		s RowID = JsonData.TRRRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCourse",JsonData,.PLIST)
		s CORowID = JsonData.CORowID
		s PLIST(17) = "N"
		if CORowID=""
		{
	 		&SQL(insert into sqluser.DHC_EQCourse values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQCourse values :PLIST() where CO_RowID=:CORowID)
		}
		 i SQLCODE
 		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
		s CORowID=$G(%ROWID)
		
		s TPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQTrainingRecord",JsonData,.TPLIST)
		s TRRRowID = JsonData.TRRRowID
		s TPLIST(3) = CORowID
		s TPLIST(4) = JsonData.COName
		s TPLIST(17) = "0"
		s TPLIST(18) = "N"					;TRR_InvalidFlag
		if TRRRowID=""
		{
	 		&SQL(insert into sqluser.DHC_EQTrainingRecord values :TPLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQTrainingRecord values :TPLIST() where TRR_RowID=:RowID)
		}
		 i SQLCODE
 		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
		s TRRRowID=$G(%ROWID)
		
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,TRRRowID)
	
ERRORTrainingRecord
	TROLLBACK 
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSTraining).GetOneTrainingRecord(3)
ClassMethod GetOneTrainingRecord(RowID As %Library.String = "")
{
	s ObjReturn=##Class(User.DHCEQTrainingRecord).%OpenId(RowID)
	s ReturnInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjReturn)
	d ReturnInfo.%Set("TRRLoc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjReturn.TRRLocDR))
	d ReturnInfo.%Set("CORowID",ReturnInfo.TRRTrainingDR)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnInfo)
}

/// w ##Class(web.DHCEQ.EM.BUSTraining).GetOneCourse(1)
ClassMethod GetOneCourse(RowID As %Library.String = "")
{
	s ObjReturn=##Class(User.DHCEQCourse).%OpenId(RowID)
	s ReturnInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjReturn)
	s COSourceTypeDesc=$CASE(ObjReturn.COSourceType,"0":"设备项","1":"设备","2":"验收单","":"")
	d ReturnInfo.%Set("COSourceTypeDesc",COSourceTypeDesc)
	s Source="" //add by csj 2020-05-26 需求号：1335556
	i ObjReturn.COSourceType=0 d
	.s Source = ##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",ObjReturn.COSourceID)
	else  if ObjReturn.COSourceType=1 d
	.s Source = $p($g(^DHCEQEquip(ObjReturn.COSourceID)),"^",1)
	else  if ObjReturn.COSourceType=2 d
	.s Source = $o(^DHCEQOpenCheckList("0","OpenCheckRequest",ObjReturn.COSourceID,""))
	.s Source = $p($g(^DHCEQOpenCheckList(Source)),"^",2)
	d ReturnInfo.%Set("COSource",Source)
	d ReturnInfo.%Set("COItem",ObjReturn.COItemDR.MIDesc)
	d ReturnInfo.%Set("CORowID",RowID)
	d ReturnInfo.%Set("COModel",ObjReturn.COModelDR.MDesc)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnInfo)
}

/// 查询课程培训登记明细记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSTraining","GetTrainingUser",2,8,1)
Query GetTrainingUser(TRDR As %String = "", CODR As %String = "", TRRStage As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TTrainUserDR:%String,TTrainUser:%String,TStage:%String,TFrequency:%String,TAbsence:%String,TLeave:%String,TAverageScore:%String,TTimes:%String,TPassFlag:%String,TRemark:%String,TLocDR:%String,TLoc:%String")
{
}

ClassMethod GetTrainingUserExecute(ByRef qHandle As %Binary, TRDR As %String = "", CODR As %String = "", TRRStage As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	i TRDR'="" d
	.s CORowID=$p($g(^DHCEQTrainingRecord(TRDR)),"^",2)
	e  s CORowID=CODR
	s rowid=0
	f  s rowid=$o(^DHCEQTrainingUser(0,"Training",CORowID,rowid)) quit:rowid=""  d
	.d ResetVariablesGetTrainingUser
	.s TRowID = rowid
	.s TTrainUserDR = $p($g(^DHCEQTrainingUser(rowid)),"^",1)
	.i TTrainUserDR'=""  d
	..s TTrainUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TTrainUserDR)
	..s TLocDR= $p($g(^DHCEQCCode("DHCEQCUser",TTrainUserDR)),"^",14)
	..s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TStage = $p($g(^DHCEQTrainingUser(rowid)),"^",3)
	.q:(TRRStage'="")&&(TStage'=TRRStage)
	.s TFrequency = $p($g(^DHCEQTrainingUser(rowid)),"^",4)
	.s TAbsence = $p($g(^DHCEQTrainingUser(rowid)),"^",5)
	.s TLeave = $p($g(^DHCEQTrainingUser(rowid)),"^",6)
	.s TAverageScore = $p($g(^DHCEQTrainingUser(rowid)),"^",7)
	.s TTimes = $p($g(^DHCEQTrainingUser(rowid)),"^",8)
	.s TPassFlag = $p($g(^DHCEQTrainingUser(rowid)),"^",9)
	.s TPassFlag= $Case(TPassFlag,"Y":"是","N":"否","":"")
	.s TRemark = $p($g(^DHCEQTrainingUser(rowid)),"^",10)
	.s TInvalidFlag = $p($g(^DHCEQTrainingUser(rowid)),"^",11)
	.q:TInvalidFlag="Y"
	.d OutputRowGetTrainingUser
	Quit $$$OK
OutputRowGetTrainingUser
	Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TTrainUserDR,TTrainUser,TStage,TFrequency,TAbsence,TLeave,TAverageScore,TTimes,TPassFlag,TRemark,TLocDR,TLoc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetTrainingUser
	Set (TRowID,TTrainUserDR,TTrainUser,TStage,TFrequency,TAbsence,TLeave,TAverageScore,TTimes,TPassFlag,TRemark,TLocDR,TLoc)=""
	quit
}

ClassMethod GetTrainingUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTrainingUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTrainingUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTrainingUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##Class(web.DHCEQ.EM.BUSTraining).SaveTrainingScore(7,"",1)
ClassMethod SaveTrainingScore(data, valList, DelIs)
{
	k PLIST,TSRowID,TPLIST
	Set $ZT="ERRORSaveTrainingScore"
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	TStart
	if DelIs=1
	{
		s TSRowID=data
		&SQL(Update SQLUSER.DHC_EQTrainingScore set TS_InvalidFlag='Y' where TS_RowID = :TSRowID)
		//add by csj 2020-06-08 删除后重新更新最终成绩
		i SQLCODE
 		{
	 		TROllBack
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
		s TSLRowID=0
		f  s TSLRowID=$O(^DHCEQTrainingScoreList(TSLRowID))  q:(TSLRowID="")||(SQLCODE'=0)  d
		.q:$p(^DHCEQTrainingScoreList(TSLRowID),"^",1)'=TSRowID
		.s TSLTrainUserDR=$p(^DHCEQTrainingScoreList(TSLRowID),"^",2)
		.s SQLCODE=..updateUltimateScore(TSRowID,TSLTrainUserDR)
		i SQLCODE
 		{
	 		TROllBack
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
		s CORowID = JsonData.CORowID
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQTrainingScore",JsonData,.PLIST)
		s TSRowID = JsonData.TSRowID
		s PLIST(3) = CORowID
		s PLIST(4) = JsonData.TRRStage
		s PLIST(5) = JsonData.COName
		s PLIST(15) = "0"
		s PLIST(16) = "N"					;TRR_InvalidFlag
		if TSRowID=""
		{
	 		&SQL(insert into sqluser.DHC_EQTrainingScore values PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQTrainingScore values :PLIST() where TS_RowID=:TSRowID)
		}
		i SQLCODE
 		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
		s TSRowID=$G(%ROWID)
		s SQLCODE=..SaveTrainingScoreList(TSRowID,valList)
		i SQLCODE
 		{
	 		TROllBack
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
		
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,TSRowID)
ERRORSaveTrainingScore 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSTraining).GetOneTrainingRecord(3)
ClassMethod GetOneTrainingScore(RowID As %Library.String = "")
{
	s ObjReturn=##Class(User.DHCEQTrainingScore).%OpenId(RowID)
	s ReturnInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjReturn)
	d ReturnInfo.%Set("TSLoc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjReturn.TSLocDR))
	d ReturnInfo.%Set("CORowID",ReturnInfo.TSTrainingDR)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnInfo)
}

/// add by csj 2020-05-15 保存成绩明细
/// d ##Class(web.DHCEQ.EM.BUSTraining).SaveTrainingScoreList(16,"{""TRow"":""1"",""TSLRowID"":""9"",""TSLTrainingScoreDR"":""16"",""TSLTrainUserDR"":""17"",""TSLTrainUserName"":""Demo Group"",""TSLTrainUserPhone"":""13125116998"",""TSLFroms"":""1"",""TSLPassFlag"":""Y"",""TSLScore"":""80"",""TSLRemark"":""2""}$CHAR(3){""TRow"":""2"",""TSLRowID"":""10"",""TSLTrainingScoreDR"":""16"",""TSLTrainUserDR"":""18"",""TSLTrainUserName"":""Inpatient Admission"",""TSLTrainUserPhone"":""1111111111"",""TSLFroms"":"""",""TSLPassFlag"":""N"",""TSLScore"":""2"",""TSLRemark"":""""}$CHAR(3){""TRow"":""3"",""TSLRowID"":""11"",""TSLTrainingScoreDR"":""16"",""TSLTrainUserDR"":""19"",""TSLTrainUserName"":""innurse"",""TSLTrainUserPhone"":""111"",""TSLFroms"":"""",""TSLPassFlag"":""N"",""TSLScore"":""3"",""TSLRemark"":""""}$CHAR(3){""TRow"":""4"",""TSLRowID"":""12"",""TSLTrainingScoreDR"":""16"",""TSLTrainUserDR"":""20"",""TSLTrainUserName"":"""",""TSLTrainUserPhone"":"""",""TSLFroms"":"""",""TSLPassFlag"":"""",""TSLScore"":"""",""TSLRemark"":""""}")
ClassMethod SaveTrainingScoreList(ScoreDR, list)
{
	k PLIST,RowID,TPLIST
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$Length(list,SplitRowCode)
	For i=1:1:Length  q:SQLCODE'=0  d
	.K LIST	
	.Set valList= $Piece(list,SplitRowCode,i)
	.s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
	.s TSLRowID=JsonData.TSLRowID
	.s LIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQTrainingScoreList",JsonData,.LIST)
	.s LIST(2)=ScoreDR	
	.If (TSLRowID="")  d
	..&SQL(Insert Into SQLUSER.DHC_EQTrainingScoreList Values :LIST())
	.Else  d
	..&SQL(Update SQLUSER.DHC_EQTrainingScoreList Values :LIST() where TSL_RowID = :TSLRowID)
	.s SQLCODE=..updateUltimateScore(ScoreDR,JsonData.TSLTrainUserDR)
	q SQLCODE
}

/// add by csj 2020-05-15
/// 查询分数明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSTraining","TrainingScoreList","",1,13)
Query TrainingScoreList(TRScoreDR As %String = "", Stage As %String = "", CourseDR As %String = "") As %Query(ROWSPEC = "TRow,TSLRowID,TSLTrainingScoreDR,TSLTrainUserDR,TSLTrainUserName,TSLTrainUserPhone,TSLForms,TSLPassFlag,TSLScore,TSLRemark")
{
}

ClassMethod TrainingScoreListExecute(ByRef qHandle As %Binary, TRScoreDR As %String = "", Stage As %String = "", CourseDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0	
	i TRScoreDR="" 
	{
		s TURowid=0
		f  s TURowid=$o(^DHCEQTrainingUser(TURowid)) quit:TURowid=""  d
		.d ResetVariablesTrainingScoreList
		.s TSLTrainUserDR=TURowid
		.s TUTrainingDR=$p($g(^DHCEQTrainingUser(TURowid)),"^",2)
		.s TUStage=$p($g(^DHCEQTrainingUser(TURowid)),"^",3)
		.s TUInvalidFlag=$p($g(^DHCEQTrainingUser(TURowid)),"^",11)
		.q:TUInvalidFlag="Y"
		.q:(CourseDR'=TUTrainingDR)||(Stage'=TUStage)
		.s TUTrainUserDR=$p($g(^DHCEQTrainingUser(TURowid)),"^",1)
		.s TSLTrainUserName= ##Class(web.DHCEQCommon).GetTrakNameByID("user", TUTrainUserDR)
		.s TSLTrainUserPhone=$p($g(^DHCEQTrainingUser(TURowid)),"^",10)
		.d OutputRowTrainingScoreList
	}
	else
	{
		s rowid=0
		f  s rowid=$o(^DHCEQTrainingScoreList(rowid)) quit:rowid=""  d
		.d ResetVariablesTrainingScoreList
		.s TSLRowID = rowid
		.s TSLTrainingScoreDR = $p($g(^DHCEQTrainingScoreList(TSLRowID)),"^",1)
		.q:(TRScoreDR'="")&&(TRScoreDR'=TSLTrainingScoreDR)
		.s TSLTrainUserDR= $p($g(^DHCEQTrainingScoreList(TSLRowID)),"^",2)
		.i TSLTrainUserDR'="" d
		..s TSLTrainUserName= ##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQTrainingUser(TSLTrainUserDR)),"^",1))
		..s TSLTrainUserPhone=$p($g(^DHCEQTrainingUser(TSLTrainUserDR)),"^",10)
		.s TSLForms= $p($g(^DHCEQTrainingScoreList(TSLRowID)),"^",3)
		.s TSLPassFlag=$p($g(^DHCEQTrainingScoreList(TSLRowID)),"^",4)
		.s TSLScore=$p($g(^DHCEQTrainingScoreList(TSLRowID)),"^",5)
		.s TSLRemark=$p($g(^DHCEQTrainingScoreList(TSLRowID)),"^",6)
		.d OutputRowTrainingScoreList
	}	
	Quit $$$OK
OutputRowTrainingScoreList
	Set TRow=TRow+1
	Set Data=$lb(TRow,TSLRowID,TSLTrainingScoreDR,TSLTrainUserDR,TSLTrainUserName,TSLTrainUserPhone,TSLForms,TSLPassFlag,TSLScore,TSLRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesTrainingScoreList
	Set (TSLRowID,TSLTrainingScoreDR,TSLTrainUserDR,TSLTrainUserName,TSLTrainUserPhone,TSLForms,TSLPassFlag,TSLScore,TSLRemark)=""
	quit
}

ClassMethod TrainingScoreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TrainingScoreListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod TrainingScoreListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TrainingScoreListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by csj 2020-05-13
/// 查询历史课程
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSTraining","GetCourse",3)
Query GetCourse(COName As %String = "") As %Query(ROWSPEC = "TRow,TRowID,TCONo,TCOName,TCOInstitution,TCOSourceType,TCOSourceTypeDesc,TCOSourceID,TSourceIDDesc,TCOItemDR,TCOItemDesc,TCOModelDR,TCOModelDesc,TCOCourseContent,TCOTrainObj,TCORemark")
{
}

ClassMethod GetCourseExecute(ByRef qHandle As %Binary, COName As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0	
	s rowid=0
	f  s rowid=$o(^DHCEQCourse(rowid)) quit:rowid=""  d
	.d ResetVariablesGetCourse
	.s TRowID = rowid
	.s TRRowID=$o(^DHCEQTrainingRecord(0,"Training",TRowID,0))	//add by csj 2020-06-15	需求号：1370099
	.q:$p($g(^DHCEQTrainingRecord(TRRowID)),"^",17)="Y"	//add by csj 2020-06-15	需求号：1370099
	.s TCONo = $p($g(^DHCEQCourse(rowid)),"^",1)
	.s TCOName = $p($g(^DHCEQCourse(rowid)),"^",2)
	.q:(COName'="")&&(TCOName'[COName)
	.s TCOInstitution=$p($g(^DHCEQCourse(rowid)),"^",4)
	.s TCOSourceType = $p($g(^DHCEQCourse(rowid)),"^",7)
	.s TCOSourceTypeDesc = $CASE(TCOSourceType,"0":"设备项","1":"设备","2":"验收单","":"")
	.s TCOSourceID = $p($g(^DHCEQCourse(rowid)),"^",8)
	.i TCOSourceType=0 d
	..s TSourceIDDesc = ##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TCOSourceID)
	.else  if TCOSourceType=1 d
	..s TSourceIDDesc = $p($g(^DHCEQEquip(TCOSourceID)),"^",1)
	.else  if TCOSourceType=2 d
	..s TSourceIDDesc = $o(^DHCEQOpenCheckList("0","OpenCheckRequest",TCOSourceID,""))
	..s TSourceIDDesc = $p($g(^DHCEQOpenCheckList(TSourceIDDesc)),"^",2)
	.s TCOItemDR = $p($g(^DHCEQCourse(rowid)),"^",9)
	.s TCOItemDesc = ##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TCOItemDR)
	.s TCOModelDR = $p($g(^DHCEQCourse(rowid)),"^",10)
	.i TCOModelDR'="" s TCOModelDesc=##Class(web.DHCEQCommon).GetTrakNameByID("model",TCOModelDR)
	.s TCOCourseContent = $p($g(^DHCEQCourse(rowid)),"^",11)
	.s TCOTrainObj=$p($g(^DHCEQCourse(rowid)),"^",13)
	.s TCORemark=$p($g(^DHCEQCourse(rowid)),"^",14)
	.d OutputRowGetCourse
	Quit $$$OK
OutputRowGetCourse
	Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TCONo,TCOName,TCOInstitution,TCOSourceType,TCOSourceTypeDesc,TCOSourceID,TSourceIDDesc,TCOItemDR,TCOItemDesc,TCOModelDR,TCOModelDesc,TCOCourseContent,TCOTrainObj,TCORemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetCourse
	Set (TRowID,TCONo,TCOName,TCOInstitution,TCOSourceType,TCOSourceTypeDesc,TCOSourceID,TSourceIDDesc,TCOItemDR,TCOItemDesc,TCOModelDR,TCOModelDesc,TCOCourseContent,TCOTrainObj,TCORemark)=""
	quit
}

ClassMethod GetCourseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCourseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCourseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCourseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by csj 2020-05-18 培训记录提交
ClassMethod SubmitTrainingRecord(TRRID)
{
	s $p(^DHCEQTrainingRecord(TRRID),"^",16)="2"
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,TRRID)
}

/// add by csj 2020-05-18 培训记录提交
ClassMethod SubmitTrainingScore(TSID)
{
	s $p(^DHCEQTrainingScore(TSID),"^",14)="2"
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,TSID)
}

/// add by csj 2020-05-18
/// 最终成绩更新
/// w ##Class(web.DHCEQ.EM.BUSTraining).updateUltimateScore(24,27)
ClassMethod updateUltimateScore(ScoreDR, TrainingUserDR)
{
	n (ScoreDR, TrainingUserDR)
	s MaxScore=0
	s MaxScorePassFlag=""
	s TrainingDR=$p($g(^DHCEQTrainingScore(ScoreDR)),"^",2)
	s Stage=$p($g(^DHCEQTrainingScore(ScoreDR)),"^",3)
	s TSRowID=0
	f  s TSRowID=$O(^DHCEQTrainingScore(0,"Training",TrainingDR,TSRowID)) q:TSRowID=""  d
	.q:$p($g(^DHCEQTrainingScore(TSRowID)),"^",15)="Y"	//add by csj 2020-06-08
	.s TSStage=$p($g(^DHCEQTrainingScore(TSRowID)),"^",3)
	.q:TSStage'=Stage
	.s TSLRowID=0
	.f  s TSLRowID=$O(^DHCEQTrainingScoreList(0,"TrainingScore",TSRowID,TrainingUserDR,TSLRowID)) q:TSLRowID=""  d
	..s TSLPassFlag=$p($g(^DHCEQTrainingScoreList(TSLRowID)),"^",4)
	..s TSLScore=$p($g(^DHCEQTrainingScoreList(TSLRowID)),"^",5)
	..i TSLScore>MaxScore d
	...s MaxScore=TSLScore
	...s MaxScorePassFlag=TSLPassFlag
	&SQL(update SQLUSER.DHC_EQTrainingUser set TU_AverageScore=:MaxScore,TU_PassFlag=:MaxScorePassFlag where TU_RowID=:TrainingUserDR) //TU_TrainUserDR=:TrainingUserDR and TU_TrainingDR=:TrainingDR and TU_Stage=:Stage)
	q SQLCODE
}

}
