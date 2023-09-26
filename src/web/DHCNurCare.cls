Import SQLUser

/// 名称: 			护理
/// 描述: 			护理业务程序
/// 编写者：		YPZ
/// 编写日期:		2009-3-11
Class web.DHCNurCare Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：      	ypz
/// CreatDate：    	2009-03-11
/// Description： 	按日期查找护理计划明细
/// Table：        	DHC_NurC_ICD,DHC_NurCare,DHC_NurCarePlan,DHC_NurCarePlanDetail
/// Input：        	EpisodeID, startDate, startTime, endDate, endTime
/// Output：        
/// Return：       	返回查找的数据。无数据则返回""。数据分两级，第一级"^"记录各个护理措施,
///                 第二级$c(3)。ndpiId(护理计划明细RowId)_$c(3)_ancvcId(显示分类RowId)_$c(3)_显示分类名_$c(3)_ancoId(常用医嘱RowId)_$c(3)_常用医嘱名_$c(3)_是否应用_$c(3)_备注_$c(3)_其它说明
ClassMethod FindNurCarePlanDetail(EpisodeID As %String, ctlocId As %String, sttDate As %String, sttTime As %String, endDate As %String, endTime As %String, userId As %String = "", ncicdId As %String = "") As %String
{
	//w ##class(web.DHCNurCare).FindNurCarePlanDetail(1024515,578,"2009-3-1","1:0","2009-3-5","1:0")
 	// ^DHCNurC("ICD",{NCICD_RowId}),{PAADM_DepCode_DR},"P",{NCP_ChildSub=1},"D",{NCPI_ChildSub})
    // ^DHCNurCare({NC_RowId},"P",{NCP_ChildSub},"D", {NCPI_ChildSub})
    // i ^DHCNurC("ICD",{NCICD_RowId},{PAADM_DepCode_DR}) m ^DHCNurCare({NC_RowId})=^DHCNurC("ICD",{NCICD_RowId},{PAADM_DepCode_DR})

	q:EpisodeID="" ""
	q:userId="" ""
	s curDateTime=$h
	s curDate=+curDateTime,curTime=$p(curDateTime,",",2)
	i $l(sttDate,"-")>2 s sttDate=$zdh(sttDate,3)
	i sttDate="" s sttDate=curDate
	i $l(sttTime,":")>1 s sttTime=$zth(sttTime)
	i sttTime="" s sttTime=curTime
	i $l(endDate,"-")>2 s endDate=$zdh(endDate,3)
	i endDate="" s endDate=curDate
	i $l(endTime,":")>1 s endTime=$zth(endTime)
	i endTime="" s endTime=curTime
	s sttDateTime=sttDate+(sttTime/100000)
	s endDateTime=endDate+(endTime/100000)
	
	s retStr=""
	s ncId=$o(^DHCNurCare(0,"Adm",EpisodeID,""))
	
	i ncId="" d
		.i ncicdId="" s ncicdId=$o(^DHCNurC("ICD",0))
		.q:ncicdId=""
		.q:userId=""
		.s ncId=..GetNurCareId(EpisodeID, ncicdId, userId)
	q:ncId="" ""
	s ncIcdId=$p($g(^DHCNurCare(ncId)),"^",5)
	k seqList,curDetailList
	i ncIcdId'="",ctlocId'="" d
	.s tmpNcpSub=0,seqNo=0
	.f  s tmpNcpSub=$o(^DHCNurC("ICD",ncIcdId,ctlocId,"P",tmpNcpSub)) q:tmpNcpSub=""  d
	..s tmpNcpiSub=0
	..f  s tmpNcpiSub=$o(^DHCNurC("ICD",ncIcdId,ctlocId,"P",tmpNcpSub,"D",tmpNcpiSub)) q:tmpNcpiSub=""  d
	...s ancvcId=$p(^DHCNurC("ICD",ncIcdId,ctlocId,"P",tmpNcpSub,"D",tmpNcpiSub),"^",7)
	...s ancoId=$p(^DHCNurC("ICD",ncIcdId,ctlocId,"P",tmpNcpSub,"D",tmpNcpiSub),"^",8)
	...i ancvcId="" s ancvcId=$p(^DHCANC("ComOrd",ancoId),"^",5)
	...q:(ancvcId="")&(ancoId="")
	...s seqNo=seqNo+1
	...s seqList(ancvcId_","_ancoId)=seqNo
	...s ancvcDesc=$p($g(^DHCANC("ViewCat",+ancvcId)),"^",2)
	...s ancoDesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
	...s curDetailList(seqList(ancvcId_","_ancoId))=$c(3)_ancvcId_$c(3)_ancvcDesc_$c(3)_ancoId_$c(3)_ancoDesc
	//w sttDateTime,",",endDateTime,!
	s ncpSub=0
	f  s ncpSub=$o(^DHCNurCare(ncId,"P",ncpSub)) q:ncpSub=""  d
	.s ncpiSub=0
	.f  s ncpiSub=$o(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub)) q:ncpiSub=""  d
	..q:"AF"'[$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^")
	..s ncpiStartDate=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",3)
	..s ncpiStartTime=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",4)
	..s ncpiEndDate=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",5)
	..s ncpiEndTime=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",6)
	..
	..//w ncId,"||",ncpSub,"||",ncpiSub," "
	..i ncpiEndDate="" s ncpiEndDate=curDate,ncpiEndTime=curTime
	..
	..s ncpiStartDateTime=ncpiStartDate+(ncpiStartTime/100000)
	..s ncpiEndDateTime=ncpiEndDate+(ncpiEndTime/100000)
	..//w ncpiStartDateTime,",",ncpiEndDateTime
	..q:ncpiEndDateTime<sttDateTime
	..q:ncpiStartDateTime'<endDateTime
	..s ancvcId=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",7)
	..s ancoId=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",8)
	..i ancvcId="" s ancvcId=$p(^DHCANC("ComOrd",ancoId),"^",5)
	..q:'$d(seqList(ancvcId_","_ancoId))
	..s ancvcDesc=$p($g(^DHCANC("ViewCat",+ancvcId)),"^",2)
	..s ancoDesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
	..//w seqList(ancvcId_","_ancoId),"/",curDetailList(seqList(ancvcId_","_ancoId)),!
	..s $p(curDetailList(seqList(ancvcId_","_ancoId)),$c(3),1)=ncId_"||"_ncpSub_"||"_ncpiSub  //ypz add 090401
	..s $p(curDetailList(seqList(ancvcId_","_ancoId)),$c(3),6)="Y"
	..s $p(curDetailList(seqList(ancvcId_","_ancoId)),$c(3),7)=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",10) //NCPI_Note
	..s $p(curDetailList(seqList(ancvcId_","_ancoId)),$c(3),8)=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",1)  //NCPI_Statu
	..s $p(curDetailList(seqList(ancvcId_","_ancoId)),$c(3),9)=$zd($p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",3),3)_" "_$zt($p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",4),1)
	..s $p(curDetailList(seqList(ancvcId_","_ancoId)),$c(3),10)=$zd($p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",5),3)_" "_$zt($p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",6),1)
	..s $p(curDetailList(seqList(ancvcId_","_ancoId)),$c(3),11)=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",14) //NCPI_OtherDescription
	..//w seqList(ancvcId_","_ancoId),"/",curDetailList(seqList(ancvcId_","_ancoId)),!
	
	s seqNo=0
	f  s seqNo=$o(curDetailList(seqNo)) q:seqNo=""  d
	.i retStr'="" s retStr=retStr_"^"
	.s retStr=retStr_curDetailList(seqNo)
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2009-04-01
/// Description： 	取护理计划明细模板数据
/// Table：        	DHC_NurC_ICD
/// Input：        	EpisodeID,ctlocId
/// Output：        
/// Return：       	返回查询结果数据，无数据返回""。数据分两级，第一级用"^"分割，记录各个护理措施,
///                 第二级用$c(3)分割: $c(3)_ndpiId(护理计划明细RowId)_$c(3)_ancvcId(显示分类RowId)_$c(3)_显示分类名_$c(3)_ancoId(常用医嘱RowId)_$c(3)_常用医嘱名
ClassMethod GetNurCareTemplate(EpisodeID As %String, ctlocId As %String) As %String
{
	//w ##class(web.DHCNurCare).GetNurCareTemplate(1024515,578)
	q:EpisodeID="" ""
	q:ctlocId="" ""
	
	s retStr=""
	s ncId=$o(^DHCNurCare(0,"Adm",EpisodeID,""))
	q:ncId="" ""
	s ncIcdId=$p($g(^DHCNurCare(ncId)),"^",5)
	k seqList,curDetailList
	i ncIcdId'="",ctlocId'="" d
	.s tmpNcpSub=0,seqNo=0
	.f  s tmpNcpSub=$o(^DHCNurC("ICD",ncId,ctlocId,"P",tmpNcpSub)) q:tmpNcpSub=""  d
	..s tmpNcpiSub=0
	..f  s tmpNcpiSub=$o(^DHCNurC("ICD",ncIcdId,ctlocId,"P",tmpNcpSub,"D",tmpNcpiSub)) q:tmpNcpiSub=""  d
	...s ancvcId=$p(^DHCNurC("ICD",ncIcdId,ctlocId,"P",tmpNcpSub,"D",tmpNcpiSub),"^",7)
	...s ancoId=$p(^DHCNurC("ICD",ncIcdId,ctlocId,"P",tmpNcpSub,"D",tmpNcpiSub),"^",8)
	...i ancvcId="" s ancvcId=$p(^DHCANC("ComOrd",ancoId),"^",5)
	...q:(ancvcId="")&(ancoId="")
	...s seqNo=seqNo+1
	...s seqList(ancvcId_","_ancoId)=seqNo
	...s ancvcDesc=$p($g(^DHCANC("ViewCat",+ancvcId)),"^",2)
	...s ancoDesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
	...s ncpiId=ncId_"||"_tmpNcpSub_"||"_tmpNcpiSub
	...s curDetailList(seqList(ancvcId_","_ancoId))=ncpiId_$c(3)_ancvcId_$c(3)_ancvcDesc_$c(3)_ancoId_$c(3)_ancoDesc
	//w sttDateTime,",",endDateTime,!
	s seqNo=0
	f  s seqNo=$o(curDetailList(seqNo)) q:seqNo=""  d
	.i retStr'="" s retStr=retStr_"^"
	.s retStr=retStr_curDetailList(seqNo)
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2009-04-01
/// Description： 	修改单条护理计划明细
/// Table：        	DHC_NurC_ICD,DHC_NurCare,DHC_NurCarePlan,DHC_NurCarePlanDetail
/// Input：        	ncpId为护理计划RowId; ncpiStr为修改数据; userId。
///                 ncpiStr分为两级：第一级是"^"分割,是需要更新的记录，
///                 第二级是$c(3)分割:ncpiId(护理计划明细RowId)_$c(3)_ancvcId(显示分类RowId)_$c(3)_ancoId(常用医嘱RowId)_$c(3)_sttDate开始日期_$c(3)_sttTime开始时间_$c(3)_endDate结束日期_$c(3)_endTime结束时间_$c(3)_isFinish是否完成护理_$c(3)_ncpiNote说明_$c(3)_ncpiOtherDescription护理计划明细为“其它”的附加信息;
/// Output：        
/// Return：       	正常返回0，否则返回出错原因。
ClassMethod SaveNurCarePlanDetail(ncpId As %String, ncpiStr As %String, userId As %String) As %String
{
	//s ncpiStr="1||1||1"_$c(3)_$c(3)_$c(3)_$c(3)__$c(3)_32434_$c(3)_14444_$c(3)_44444_$c(3)_1^1||1||2_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_2_$c(3)_555_$c(3)_555_$c(3)_1"
	q:ncpId="" "无护理计划Id!"
	q:ncpiStr="" 0 // 无数据
	q:userId="" "无用户Id!"
	
	s retStr=0
	s num=$l(ncpiStr,"^")
	f i=1:1:num d
	.q:retStr'=0
	.s singleNcpiStr=$p(ncpiStr,"^",i)
	.s ncpiId=$p(singleNcpiStr,$c(3),1)
	.s ancvcId=$p(singleNcpiStr,$c(3),2)
	.s ancoId=$p(singleNcpiStr,$c(3),3)
	.s sttDate=$p(singleNcpiStr,$c(3),4)
	.s sttTime=$p(singleNcpiStr,$c(3),5)
	.s endDate=$p(singleNcpiStr,$c(3),6)
	.s endTime=$p(singleNcpiStr,$c(3),7)
	.i endDate="" s endDate=+$h,curTime=$p($h,",",2) //结束时间为空时置系统时间
	.s sttDateTime=sttDate+(sttTime/100000)
	.s endDateTime=endDate+(endTime/100000)
	.i endDateTime<sttDateTime s retStr="结束时间不能早于开始时间" q
	.s isFinish=$p(singleNcpiStr,$c(3),8)
	.s ncpiNote=$p(singleNcpiStr,$c(3),9)
	.s ncpiOtherDescription=$p(singleNcpiStr,$c(3),10)
	.s retStr=..SaveNurCarePlanDetailSingle(ncpId,ncpiId,ancvcId,ancoId,sttDate,sttTime,endDate,endTime,isFinish,userId,ncpiNote,ncpiOtherDescription)
	
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2009-04-01
/// Description： 	修改单条护理计划明细
/// Table：        	DHC_NurC_ICD,DHC_NurCare,DHC_NurCarePlan,DHC_NurCarePlanDetail
/// Input：        	ncpId(护理计划RowId); ncpiId(护理计划明细RowId);EpisodeID; startDate; startTime; endDate; endTime; isFinish：在ncpiId不为空时,为1改变状态为完成、为0修改;userId;note:说明等信息;otherDescription:护理计划明细为“其它”的附加信息。
///                 1. ncpiId为空插入数据
///                 2. 在ncpiId不为空时,如果isFinish为1,写结束日期和时间;如果isFinish为0,清空结束日期和时间
///                    sttDate为空时不更新开始日期和时间;
/// Output：        
/// Return：       	正常返回0，否则返回出错原因。
ClassMethod SaveNurCarePlanDetailSingle(ncpId As %String, ncpiId As %String, ancvcId As %String, ancoId As %String, sttDate As %String, sttTime As %String, endDate As %String, endTime As %String, isFinish As %String, userId As %String, note As %String, otherDescription As %String) As %String
{
	//w ##class(web.DHCNurCare).SaveNurCarePlanDetailSingle("1||1","1||1||1","","","","",0,10374)
	q:ncpId="" "无护理计划Id!"
	q:((ncpiId'="")&($p(ncpiId,"||",1,2)'=ncpId)) "护理计划Id与护理明细Id不符!"
	i $l(sttDate,"-")>2 s sttDate=$zdh(sttDate,3)
	i $l(sttTime,":")>1 s sttTime=$zth(sttTime)
	i $l(endDate,"-")>2 s endDate=$zdh(endDate,3)
	i $l(endTime,":")>1 s endTime=$zth(endTime)
	s curDate=+$h
	s curTime=$p($h,",",2)
	s retStr=0
	i ncpiId'="" d
		.s ncId=$p(ncpiId,"||",1)
		.s ncpSub=$p(ncpiId,"||",2)
		.s ncpiSub=$p(ncpiId,"||",3)
		.s ncpiStatus=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^")
		.s ncpiStartDate=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",3)
		.s ncpiStartTime=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",4)
		.s ncpiEndDate=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",5)
		.s ncpiEndTime=$p(^DHCNurCare(ncId,"P",ncpSub,"D",ncpiSub),"^",6)
		.i (ncpiStatus="F") s ncpiId="" //"该护理计划明细已完成,不能修改!" q
		.i (ncpiStatus="C") s ncpiId="" //"该护理计划明细已取消,不能修改!" q
	i ncpiId="" d //插入
		.s ncpiStatus="A"
		.i ancvcId="",ancoId="" s retStr="插入数据不能为空!" q
		.&SQL(insert into DHC_NurCarePlanDetail(NCPI_Parref,NCPI_Status,NCPI_ViewCat_Dr,NCPI_CommOrd_Dr,NCPI_StartDate,NCPI_StartTime,NCPI_UpdateUser_Dr,NCPI_UpdateDate,NCPI_UpdateTime,NCPI_Note,NCPI_OtherDescription)
	      values(:ncpId,:ncpiStatus,:ancvcId,:ancoId,:curDate,:curTime,:userId,:curDate,:curTime,:note,:otherDescription))
		.i SQLCODE s retStr="插入数据错! SQLOCDE="_SQLCODE
	e  d
		.q:('isFinish)&(ncpiStatus="A")&(ncpiEndDate="")&(ncpiEndTime="")    //不需要处理
		.i sttDate'="" s ncpiStartDate=sttDate,ncpiStartTime=+sttTime        //传入不为空时更新开始时间
		.i isFinish s ncpiStatus="F",ncpiEndDate=endDate,ncpiEndTime=endTime //结束时置结束时间
		.e  s ncpiEndDate="",ncpiEndTime=""
		.
		.&SQL(update DHC_NurCarePlanDetail set NCPI_Status=:ncpiStatus,NCPI_StartDate=:ncpiStartDate,NCPI_StartTime=:ncpiStartTime,NCPI_EndDate=:ncpiEndDate,NCPI_EndTime=:ncpiEndTime,NCPI_UpdateUser_Dr=:userId,NCPI_UpdateDate=:curDate,NCPI_UpdateTime=:curTime,NCPI_Note=:note,NCPI_OtherDescription=:otherDescription where NCPI_RowId=:ncpiId)
		.i SQLCODE s retStr="插入数据错! SQLOCDE="_SQLCODE
		.
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2009-04-10
/// Description： 	取护理计划RowId
/// Table：        	DHC_NurC_ICD,DHC_NurCare,DHC_NurCarePlan,DHC_NurCarePlanDetail
/// Input：        	EpisodeID; userId; ncicdId(护理诊断RowId)。
/// Output：        
/// Return：       	正常返回护理计划RowId，否则返回""
ClassMethod GetNurCarePlanId(EpisodeID As %String, userId As %String, ncicdId As %String = "") As %String
{
	//w ##class(web.DHCNurCare).GetNurCarePlanId(1024515,10374,"")
	q:EpisodeID="" "" //"无就诊号!"
	s ncId=$o(^DHCNurCare(0,"Adm",EpisodeID,""))
	i ncId="" d
		.s PLIST(2)=EpisodeID
		.i ncicdId="" s ncicdId=$o(^DHCNurC("ICD",0))
		.s PLIST(6)=ncicdId
		.s PLIST(8)=+$h
		.s PLIST(9)=$p($h,",",2)
		.s PLIST(15)=userId
		.s PLIST(16)=+$h
		.s PLIST(17)=$p($h,",",2)
		.&SQL(insert into DHC_NurCare Values :PLIST())
		.q:SQLCODE
		.s ncId=$g(%ROWID)
	q:ncId="" ""  //"无护理主表!"
	
	s ncpSub=$o(^DHCNurCare(ncId,"P",0))
	i ncpSub'="" q ncId_"||"_ncpSub
	
	k PLIST
	s PLIST(0)=ncId
	&SQL(insert into DHC_NurCarePlan Values :PLIST())
	q:SQLCODE "" //"插入护理计划表错误!"
	q $g(%ROWID)
}

ClassMethod GetNurCareId(EpisodeID As %String, ncicdId As %String, userId As %String) As %String
{
	Set $ZT="ERROR"
	s ncId=$o(^DHCNurCare(0,"Adm",EpisodeID,0))
	q:ncId'="" ncId
	i ncicdId="" s ncicdId=$o(^DHCNurC("ICD",0))
	q:ncicdId="" "没有指定护理计划码表!"
	TSTART
	k PLIST
	s PLIST(2)=EpisodeID
	s PLIST(6)=ncicdId
	s PLIST(8)=+$h
	s PLIST(9)=$p($h,",",2)
	s PLIST(15)=userId
	s PLIST(16)=+$h
	s PLIST(17)=$p($h,",",2)
	&SQL(insert into DHC_NurCare Values :PLIST())
	i SQLCODE TROLLBACK  q "插入护理表错误!"
	s ncId=$g(%ROWID)
	TCOMMIT
	q ncId
	
ERROR	
	Set ErrorMsg=$ZE	          
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg   
    q SQLCODE
}

}
