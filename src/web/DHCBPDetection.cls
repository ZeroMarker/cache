Import SQLUser

/// 质量检测
/// table:DHC_BP_Detection
/// 能够实现对数据表的维护，实现增删改查功能
Class web.DHCBPDetection Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 插入数据
/// w ##class(web.DHCBPDetection).InsertBPDetection("3^2^63385^^010101^无^6552^^^0^^6536")
ClassMethod InsertBPDetection(BPDetectionInfo) As %String
{
	q:BPDetectionInfo="" "数据为空，请重新输入"
	Tstart //事务开始
	k PLIST
	s PLIST(2)=$p(BPDetectionInfo,"^",1)
	s PLIST(3)=$p(BPDetectionInfo,"^",2)
	s tBPDDate=$p(BPDetectionInfo,"^",3)
	s PLIST(4)=##class(web.DHCANOPCom).ConvertToDateH(tBPDDate)
	s tBPDTime=$p(BPDetectionInfo,"^",4)
	s PLIST(5)=##class(web.DHCANOPCom).ConvertToTimeH(tBPDTime)
	s PLIST(6)=$p(BPDetectionInfo,"^",5)
	s PLIST(7)=$p(BPDetectionInfo,"^",6)
	s PLIST(8)=$p(BPDetectionInfo,"^",7)
	s tUpdateDate=$p(BPDetectionInfo,"^",8)
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToDateH(tUpdateDate)
	s tUpdateTime=$p(BPDetectionInfo,"^",9)
	s PLIST(10)=##class(web.DHCANOPCom).ConvertToTimeH(tUpdateTime)
	s PLIST(11)=$p(BPDetectionInfo,"^",10)
	s PLIST(12)=$p(BPDetectionInfo,"^",11)
	s detectionUserList=$p(BPDetectionInfo,"^",12)
	&SQL(insert into DHC_BP_Detection Values :PLIST())
	i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE
	s tRowid=%ROWID
	//b ;01
	//插入参加人数据
	s userLength=$l(detectionUserList,",")
	s Error=0
	f i=1:1:userLength q:Error'=0  d
	.s userId=$p(detectionUserList,",",i)
	.s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	.&SQL(insert into DHC_BP_DetectionUser Values(:tRowid,:userId,:userName))
	.s Error=SQLCODE
	i Error'=0  Trollback
	q:Error'=0 Error
	tcommit
	q Error
}

/// 更新数据
/// w ##class(web.DHCBPDetection).UpdateBPDetection("9^3^3^63385^^010101^无^6552^^^0^^6537,6536")
ClassMethod UpdateBPDetection(BPDetectionInfo) As %String
{
	q:BPDetectionInfo="" "数据为空，请重新输入"
	k PLIST
	s tRowid=$p(BPDetectionInfo,"^",1)
	q:tRowid="" "请选中一行要修改的数据"
	s PLIST(2)=$p(BPDetectionInfo,"^",2)
	s PLIST(3)=$p(BPDetectionInfo,"^",3)
	s tBPDDate=$p(BPDetectionInfo,"^",4)
	s PLIST(4)=##class(web.DHCANOPCom).ConvertToDateH(tBPDDate)
	s tBPDTime=$p(BPDetectionInfo,"^",5)
	s PLIST(5)=##class(web.DHCANOPCom).ConvertToTimeH(tBPDTime)
	s PLIST(6)=$p(BPDetectionInfo,"^",6)
	s PLIST(7)=$p(BPDetectionInfo,"^",7)
	s PLIST(8)=$p(BPDetectionInfo,"^",8)
	s tUpdateDate=$p(BPDetectionInfo,"^",9)
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToDateH(tUpdateDate)
	s tUpdateTime=$p(BPDetectionInfo,"^",10)
	s PLIST(10)=##class(web.DHCANOPCom).ConvertToTimeH(tUpdateTime)
	s PLIST(11)=$p(BPDetectionInfo,"^",11)
	s PLIST(12)=$p(BPDetectionInfo,"^",12)
	s detectionUserList=$p(BPDetectionInfo,"^",13)
	;b ;00
	Tstart ;事务开始
	&SQL(update DHC_BP_Detection Values :PLIST() where BPD_RowId=:tRowid)
	i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE
	;s tRowid=%ROWID
	;b ;01
	;插入参加人数据
	s userLength=$l(detectionUserList,",")
	s Error=0 ;更新不成功标志
	k deleteUserIdList
	s tDetUserRowid=0
	f i=1:1:userLength q:Error'=0  d
	.s userId=$p(detectionUserList,",",i)
	.i userId'="" s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	.e  s userName=""
	.s isExistFlag=0 
	.;要更新的用户是否在表中参加人表中存在“0”不存在；“1”存在
	.f  s tDetUserRowid=$o(^DHCBPDetectionUser(0,"Detection",tRowid,tDetUserRowid)) q:tDetUserRowid=""  d
	..s DUserid=$lg($g(^DHCBPDetectionUser(tDetUserRowid)),2) //原用户id
	..i userId=DUserid   s isExistFlag=1
	..i (","_detectionUserList_",")'[(","_DUserid_",") s deleteUserIdList(tDetUserRowid)=""
	..;b ;02
	.;要更新的userid在原表中不存在时
	.i isExistFlag=0 d
	..&SQL(insert into DHC_BP_DetectionUser Values(:tRowid,:userId,:userName))
	.s Error=SQLCODE
	s bpduId=""
	f  s bpduId=$o(deleteUserIdList(bpduId)) q:bpduId=""  d
		.&SQL(delete from DHC_BP_DetectionUser where BPDU_RowId=:bpduId)
	i Error'=0  Trollback
	q:Error'=0 Error
	tcommit
	q Error
}

/// 删除数据
/// w ##class(web.DHCBPDetection).DeleteBPDetection("3")
ClassMethod DeleteBPDetection(rowid) As %String
{
	q:rowid="" "请选择一条数据"
	Tstart ;事务开始
	;删除关联表数据
	&SQL(delete from DHC_BP_DetectionUser where BPDU_BPD_Dr=:rowid)
	i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE
	;删除主表数据
	s Error=0
	&SQL(delete from DHC_BP_Detection where BPD_RowId=:rowid)
	s Error=SQLCODE
	i Error'=0  Trollback
	q:Error'=0 Error
	tcommit
	q Error
}

/// 查询血液透析常用医嘱的一些信息。
/// return:rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBPDetection","FindBPCReItem")
Query FindBPCReItem() As %Query(ROWSPEC = "tRowId:%String,tBPCRICode:%String,tBPCRIDesc:%String")
{
}

ClassMethod FindBPCReItemExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tRowId=0
	f  s tRowId=$o(^DHCBPC("RecordItem",tRowId))  q:tRowId=""  d
	.s tBPCRICode=$lg(^DHCBPC("RecordItem",tRowId),1)
	.s tBPCRIDesc=$lg(^DHCBPC("RecordItem",tRowId),2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tRowId,tBPCRICode,tBPCRIDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCReItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCReItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindBPCReItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCReItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询质量检测表中的数据信息
/// table: DHC_BP_Detection
/// d ##class(%ResultSet).RunQuery("web.DHCBPDetection","FindBPDetection","2014-10-16","2014-10-18")
Query FindBPDetection(startDate As %String = "", endDate As %String = "", equipName As %String = "", equioSeqNo As %String = "") As %Query(ROWSPEC = "tRowId:%String,tBPCDetectionDr:%String,tBPCDetectionDesc:%String,tBPDBPCEquipCode:%String,tBPDBPCEquip:%String,tDBPDEquipSeqNo:%String,tBPDDate:%String,tBPDTime:%String,tBPDSpecimenNo:%String,tBPDNote:%String,curUserId:%String,curUserName:%String,tBPDIsQualified:%String,IsQualified:%String,tBPDBatchSeqNo:%String,userIdList:%String,userNameList:%String")
{
}

ClassMethod FindBPDetectionExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", equipName As %String = "", equioSeqNo As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tRowid=0
	i startDate'="" s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate) 
	i endDate'="" s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	i (startDate="")&&(endDate="") d
	.f  s tRowid=$o(^DHCBPDetection(tRowid)) q:tRowid=""  d
	..s tBPCDetectionDr=$lg($g(^DHCBPDetection(tRowid)),1)
	..s tBPCDetectionDesc=""
	..s tBPCDetectionDesc=$lg(^DHCBPC("Detection",+tBPCDetectionDr),2)
	..s tDBPCEquipDr=$lg($g(^DHCBPDetection(tRowid)),2) //设备id
	..s tDBPDEquipDesc=""
	..i tDBPCEquipDr'="" s tDBPDEquipDesc=$lg($g(^DHCBPC("Equip",tDBPCEquipDr)),3) 
	..q:(equipName'="")&&(tDBPDEquipDesc'[equipName)
	..s tDBPDEquipSeqNo=""
	..i tDBPCEquipDr'="" s tDBPDEquipSeqNo=$lg($g(^DHCBPC("Equip",tDBPCEquipDr)),4) //设备序列号
	..q:(equioSeqNo'="")&&(equioSeqNo'=tDBPDEquipSeqNo)
	..s tBPDDate=$lg($g(^DHCBPDetection(tRowid)),3)
	..s tBPDDate=##class(web.DHCANOPCom).ConvertToDate(tBPDDate) //检测日期
	..s tBPDTime=$lg($g(^DHCBPDetection(tRowid)),4)
	..s tBPDTime=##class(web.DHCANOPCom).ConvertToTime(tBPDTime)  //检测时间
	..s tBPDSpecimenNo=$lg($g(^DHCBPDetection(tRowid)),5)
	..s tBPDNote=$lg($g(^DHCBPDetection(tRowid)),6) //备注
	..s curUserid=$lg($g(^DHCBPDetection(tRowid)),7) //用户名id
	..s curUserName=$p(^SSU("SSUSR",curUserid),"^",2) //用户名	
	..s tBPDIsQualified=$lg($g(^DHCBPDetection(tRowid)),10)
	..i tBPDIsQualified="1" s IsQualified="合格"
	..i tBPDIsQualified="0" s IsQualified="不合格"
	..s tBPDBatchSeqNo=$lg($g(^DHCBPDetection(tRowid)),11)
	..;参加人
	..s tBPDUserInfo=##class(web.DHCBPDetectionUser).GetDetectionUser(tRowid)
	..s userIdList=$p(tBPDUserInfo,"^",1)
	..s userNameList=$p(tBPDUserInfo,"^",2)
	..d OutputRow1
	e  d
	.s tRowid=0
	.f date=startDate:1:endDate d
	..f  s tRowid=$o(^DHCBPDetection(0,"Date",date,tRowid)) q:tRowid=""  d
	...s tBPCDetectionDr=$lg($g(^DHCBPDetection(tRowid)),1)
	...s tBPCDetectionDesc=""
	...i tBPCDetectionDr'="" s tBPCDetectionDesc=$lg(^DHCBPC("Detection",+tBPCDetectionDr),2)
	...s tDBPCEquipDr=$lg($g(^DHCBPDetection(tRowid)),2) //设备id
	...s tDBPDEquipDesc=""
	...i tDBPCEquipDr'="" s tDBPDEquipDesc=$lg($g(^DHCBPC("Equip",tDBPCEquipDr)),3)
	...q:(equipName'="")&&(tDBPDEquipDesc'[equipName)
	...s tDBPDEquipSeqNo=""
	...i tDBPCEquipDr'="" s tDBPDEquipSeqNo=$lg($g(^DHCBPC("Equip",tDBPCEquipDr)),4) //设备序列号 
	...q:(equioSeqNo'="")&&(equioSeqNo'=tDBPDEquipSeqNo)
	...s tBPDDate=$lg($g(^DHCBPDetection(tRowid)),3)
	...s tBPDDate=##class(web.DHCANOPCom).ConvertToDate(tBPDDate) //检测日期
	...s tBPDTime=$lg($g(^DHCBPDetection(tRowid)),4)
	...s tBPDTime=##class(web.DHCANOPCom).ConvertToTime(tBPDTime)  //检测时间
	...s tBPDSpecimenNo=$lg($g(^DHCBPDetection(tRowid)),5)
	...s tBPDNote=$lg($g(^DHCBPDetection(tRowid)),6) //备注
	...s curUserid=$lg($g(^DHCBPDetection(tRowid)),7) //用户名id
	...s curUserName=$p(^SSU("SSUSR",curUserid),"^",2) //用户名	
	...s tBPDIsQualified=$lg($g(^DHCBPDetection(tRowid)),10)
	...i tBPDIsQualified="1" s IsQualified="合格"
	...i tBPDIsQualified="0" s IsQualified="不合格"
	...s tBPDBatchSeqNo=$lg($g(^DHCBPDetection(tRowid)),11)
	...;参加人
	...B
	...s tBPDUserInfo=##class(web.DHCBPDetectionUser).GetDetectionUser(tRowid)
	...s userIdList=$p(tBPDUserInfo,"^",1)
	...s userNameList=$p(tBPDUserInfo,"^",2)
	...d OutputRow1	
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tRowid,tBPCDetectionDr,tBPCDetectionDesc,tDBPCEquipDr,tDBPDEquipDesc,tDBPDEquipSeqNo,tBPDDate,tBPDTime,tBPDSpecimenNo,tBPDNote,curUserid,curUserName,tBPDIsQualified,IsQualified,tBPDBatchSeqNo,userIdList,userNameList)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPDetectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPDetectionExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindBPDetectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPDetectionExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
