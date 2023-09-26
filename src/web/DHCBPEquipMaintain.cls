Import SQLUser

Class web.DHCBPEquipMaintain Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 插入数据
/// 插入数据时的字符串顺序：设备id^更换部件id^维护内容^更换部件类型^开始日期开始时间
/// 							结束日期^结束时间^备注^维护费用^更新人^更新日期^更新时间^参加人
/// w ##class(web.DHCBPEquipMaintain).InsertBPEquipMaintain("3^2^C^^2014-01-01^11:01:01^2014-10-11^11:11:11^把手^200^1^6536^张三,李四")
ClassMethod InsertBPEquipMaintain(BPEquipMaintainInfo) As %String
{
	q:BPEquipMaintainInfo="" "数据为空，请重新输入"
	k PLIST
	s PLIST(2)=$p(BPEquipMaintainInfo,"^",1)
	s PLIST(3)=$p(BPEquipMaintainInfo,"^",2)
	s PLIST(4)=$p(BPEquipMaintainInfo,"^",3)
	s PLIST(5)=$p(BPEquipMaintainInfo,"^",4)
	
	s tBPEMStartDate=$p(BPEquipMaintainInfo,"^",5)
	s PLIST(6)=##class(web.DHCANOPCom).ConvertToDateH(tBPEMStartDate)
	s tBPEMStartTime=$p(BPEquipMaintainInfo,"^",6)
	s PLIST(7)=##class(web.DHCANOPCom).ConvertToTimeH(tBPEMStartTime)
	
	s tBPEMEndDate=$p(BPEquipMaintainInfo,"^",7)
	s PLIST(8)=##class(web.DHCANOPCom).ConvertToDateH(tBPEMEndDate)
	s tBPEMEndTime=$p(BPEquipMaintainInfo,"^",8)
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH(tBPEMEndTime)
	s PLIST(10)=$p(BPEquipMaintainInfo,"^",9)
	s PLIST(12)=$p(BPEquipMaintainInfo,"^",10)
	s PLIST(13)=$p(BPEquipMaintainInfo,"^",11)
	s EMUserList=$p(BPEquipMaintainInfo,"^",12)
	s newEMUserListOut=$p(BPEquipMaintainInfo,"^",13)
	//q:$p(BPEquipMaintainInfo,"^",9)
	s tUpdateDate=$p(BPEquipMaintainInfo,"^",14)
	s PLIST(14)=##class(web.DHCANOPCom).ConvertToDateH(tUpdateDate)
	s tUpdateTime=$p(BPEquipMaintainInfo,"^",15)
	s PLIST(15)=##class(web.DHCANOPCom).ConvertToTimeH(tUpdateTime)
	
	//s result=$o(^DHCBPDetection())
	b ;00
	Tstart //事务开始
	&SQL(insert into DHC_BP_EquipMaintain Values :PLIST())
	i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE
	s tRowid=%ROWID
	
	;b ;01
	;插入附属表-“维护参加人(院内)”数据
	s Error=0
	i EMUserList'="" d
	.s userLength=$l(EMUserList,",")
	.f i=1:1:userLength q:Error'=0  d
	..s userId=$p(EMUserList,",",i)
	..s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	..&SQL(insert into DHC_BP_EquipMaintainUser Values(:tRowid,:userId,:userName))
	..s Error=SQLCODE
	.i (Error'=0)&&(Error'=100)  Trollback
	
	;插入 附属表-“维护记录参加人(院外)”数据
	i newEMUserListOut'="" d
	.s userId=""
	.&SQL(insert into DHC_BP_EquipMaintainUser Values(:tRowid,:userId,:newEMUserListOut))
	.s Error=SQLCODE
	.i (Error'=0)&&(Error'=100) Trollback
	tcommit
	q Error
}

/// w ##class(web.DHCBPEquipMaintain).UpdateBPEquipMaintain("3^3^2^C^^2014-01-01^11:01:01^2014-10-11^11:11:11^把手^200^1^6537,6538^张三,王齐^")
ClassMethod UpdateBPEquipMaintain(BPEquipMaintainInfo) As %String
{
	q:BPEquipMaintainInfo="" "数据为空，请重新输入"
	k PLIST
	s tRowid=$p(BPEquipMaintainInfo,"^",1)
	q:tRowid="" "请选中一行要修改的数据"
	s PLIST(2)=$p(BPEquipMaintainInfo,"^",2)
	s PLIST(3)=$p(BPEquipMaintainInfo,"^",3)
	s PLIST(4)=$p(BPEquipMaintainInfo,"^",4)
	s PLIST(5)=$p(BPEquipMaintainInfo,"^",5)
	
	s tBPEMStartDate=$p(BPEquipMaintainInfo,"^",6)
	s PLIST(6)=##class(web.DHCANOPCom).ConvertToDateH(tBPEMStartDate)
	s tBPEMStartTime=$p(BPEquipMaintainInfo,"^",7)
	s PLIST(7)=##class(web.DHCANOPCom).ConvertToTimeH(tBPEMStartTime)
	
	s tBPEMEndDate=$p(BPEquipMaintainInfo,"^",8)
	s PLIST(8)=##class(web.DHCANOPCom).ConvertToDateH(tBPEMEndDate)
	s tBPEMEndTime=$p(BPEquipMaintainInfo,"^",9)
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH(tBPEMEndTime)
	s PLIST(10)=$p(BPEquipMaintainInfo,"^",10)
	s PLIST(12)=$p(BPEquipMaintainInfo,"^",11)
	s PLIST(13)=$p(BPEquipMaintainInfo,"^",12)
	s newEMUserList=$p(BPEquipMaintainInfo,"^",13)
	s newEMUserListOut=$p(BPEquipMaintainInfo,"^",14)
	//q:$p(BPEquipMaintainInfo,"^",9)
	s tUpdateDate=$p(BPEquipMaintainInfo,"^",15)
	s PLIST(14)=##class(web.DHCANOPCom).ConvertToDateH(tUpdateDate)
	s tUpdateTime=$p(BPEquipMaintainInfo,"^",16)
	s PLIST(15)=##class(web.DHCANOPCom).ConvertToTimeH(tUpdateTime)
	;b ;00
	Tstart //事务开始
	&SQL(update DHC_BP_EquipMaintain Values :PLIST() where BPEM_RowId=:tRowid)
	i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE
	
	;b ;01
	;插入附属表-“维护参加人(院内)”数据
	s userLength=$l(newEMUserList,",")
	s Error=0 ;更新不成功标志
	s tEMUserRowid=0
	
	;===更新前参加人(院内)信息===
	s tBPEMUserInfo=##class(web.DHCBPEquipMaintainUser).GetEquipMaintainUser(tRowid)
	s oldUserIdList=$p(tBPEMUserInfo,"^",1)
	
	f i=1:1:userLength q:Error'=0  d
	.s userId=$p(newEMUserList,",",i)
	.s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	.s isExistFlag=0 
	.;要更新的用户是否在表中参加人表中存在“0”不存在；“1”存在
	.f  s tEMUserRowid=$o(^DHCBPEquipMaintainUser(0,"EquipMaintain",tRowid,tEMUserRowid)) q:tEMUserRowid=""  d
	..s EMUserid=$lg($g(^DHCBPEquipMaintainUser(tEMUserRowid)),2) //原用户id
	..i userId=EMUserid   s isExistFlag=1
	..;b ;02
	.;要更新的userid在原表中不存在时
	.i isExistFlag=0 d
	..&SQL(insert into DHC_BP_EquipMaintainUser Values(:tRowid,:userId,:userName))
	.s Error=SQLCODE
	i Error'=0  Trollback
	q:Error'=0 Error

	;将原有且不在最新更新中的参加人删除
	s DError=0,NError=0
	f m=1:1:$l(oldUserIdList,",")  q:DError'=0  d
	.s oldUserId=$p(oldUserIdList,",",m)
	.s isExistFlag=0
	.f n=1:1:userLength  d
	..s userId=$p(newEMUserList,",",n)
	..i oldUserId=userId d
	...s isExistFlag=1
	.;旧的参加人不在最新更新的人中时，删除原来的
	.i isExistFlag=0 d
	..b
	..&SQL(delete from DHC_BP_EquipMaintainUser where (BPEMU_BPEM_Dr=:tRowid and BPEMU_BPEMUser_Dr=:oldUserId))
	..s DError=SQLCODE
	i (DError'=0)&& (DError'=100) Trollback
	q:(DError'=0)&&(DError'=100) DError
	
	;===更新院外参加人信息===
	s Error=0 ;更新不成功标志
	i newEMUserListOut'="" d
	.s userIdOut=""
	.s EMUserRowid=""
	.s exitFlag=0 //是否存在的flag
	.for  s EMUserRowid=$o(^DHCBPEquipMaintainUser(0,"EquipMaintain",tRowid,EMUserRowid)) q:(EMUserRowid="")!(Error'=0)  d
	..s userIdOut=$lg($g(^DHCBPEquipMaintainUser(EMUserRowid)),2)
	..q:'((userIdOut=$c(0))!(userIdOut="")) 
	..s exitFlag=1
	..s userName=$lg($g(^DHCBPEquipMaintainUser(EMUserRowid)),3)
	..;原有参加人(院外) 和新更新的不相等时，做更新
	..i newEMUserListOut'=userName d 
	...;b ;update
	...&SQL(update DHC_BP_EquipMaintainUser set BPEMU_BPEMName=:newEMUserListOut where BPEMU_RowId=:EMUserRowid)
	...s Error=SQLCODE
	...i (Error'=0)&&(Error'=100) Trollback
	.q:(Error'=0)&&(Error'=100)
	.s userNameOut=##class(web.DHCBPEquipMaintainUser).GetEquipMaintainUserOut(tRowid)
	.i userNameOut="" d ;原院外参加人不存在时
	..s userIdOut=""
	..&SQL(insert into DHC_BP_EquipMaintainUser Values(:tRowid,:userIdOut,:newEMUserListOut))
	..s Error=SQLCODE
	..i Error'=0  Trollback
	tcommit
	q Error
}

ClassMethod DeleteBPEquipMaintain(rowid)
{
	q:rowid="" "请选择一条数据"
	&SQL(delete from DHC_BP_EquipMaintain where BPEM_RowId=:rowid)
	q SQLCODE
}

/// 查询血液透析设备部件的基本信息
/// d ##class(%ResultSet).RunQuery("web.DHCBPEquipMaintain","FindBPEquipMaintain","")
Query FindBPEquipMaintain(Equipid, EquipModelId = "") As %Query(ROWSPEC = "tRowId:%String,tDBPCEquipDr:%String,tDBPCEquipDesc:%String,tDBPEquipPartDesc:%String,tBPEMType:%String,tBPEMTypeDesc:%String,tBPEMPartType:%String,tBPEMPartTypeDesc:%String,StartDate:%String,StartTime:%String,EndDate:%String,EndTime:%String,Note:%String,tBPEMExpense:%String,updateUserID:%String,userIdList:%String,userNameList:%String,userNameOut:%String")
{
}

ClassMethod FindBPEquipMaintainExecute(ByRef qHandle As %Binary, Equipid, EquipModelId = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPERowId=0
 	i Equipid ="" d
	.for  s tBPERowId=$o(^DHCBPEquipMaintain(tBPERowId)) q:tBPERowId=""  d
	..s tDBPCEquipDr=$lg(^DHCBPEquipMaintain(tBPERowId),1)
	..s tDBPCEquipDesc=""
	..i tDBPCEquipDr'="" s tDBPCEquipDesc=$lg($g(^DHCBPC("Equip",tDBPCEquipDr)),3) 
	..s tDBPEquipPartDesc=$lg(^DHCBPEquipMaintain(tBPERowId),2)
	..b
	..s tBPEMType=$lg(^DHCBPEquipMaintain(tBPERowId),3)
	..s tBPEMTypeDesc=""
	..i tBPEMType="C" s tBPEMTypeDesc="消毒"
	..i tBPEMType="M" s tBPEMTypeDesc="保养"
	..i tBPEMType="R" s tBPEMTypeDesc="维修"
	..s tBPEMPartType=$lg(^DHCBPEquipMaintain(tBPERowId),4)
	..s tBPEMPartTypeDesc=""
	..i tBPEMPartType="C" s tBPEMPartTypeDesc="清洁"
	..i tBPEMPartType="M" s tBPEMPartTypeDesc="保养"
	..i tBPEMPartType="R" s tBPEMPartTypeDesc="维修"
	..i tBPEMPartType="P" s tBPEMPartTypeDesc="替换"	
	..s tStartDate=$lg(^DHCBPEquipMaintain(tBPERowId),5)
	..s tStartDate=##class(web.DHCANOPCom).ConvertToDate(tStartDate)
	..s tStartTime=$lg(^DHCBPEquipMaintain(tBPERowId),6)
	..s tStartTime=##class(web.DHCANOPCom).ConvertToTime(tStartTime)
	..s tEndDate=$lg(^DHCBPEquipMaintain(tBPERowId),7)
	..s tEndDate=##class(web.DHCANOPCom).ConvertToDate(tEndDate)
	..s tEndTime=$lg(^DHCBPEquipMaintain(tBPERowId),8)
	..s tEndTime=##class(web.DHCANOPCom).ConvertToTime(tEndTime)
	..s tNote=$lg(^DHCBPEquipMaintain(tBPERowId),9)
	..s tBPEMExpense=$lg(^DHCBPEquipMaintain(tBPERowId),10)
	..s tUpUserId=$lg(^DHCBPEquipMaintain(tBPERowId),11)
	..;获取维护参加人
	..s tBPEMUserInfo=##class(web.DHCBPEquipMaintainUser).GetEquipMaintainUser(tBPERowId)
	..s userIdList=$p(tBPEMUserInfo,"^",1)
	..s userNameList=$p(tBPEMUserInfo,"^",2)
	..s userNameOut=##class(web.DHCBPEquipMaintainUser).GetEquipMaintainUserOut(tBPERowId)
	..d OutputRow1
	e  d
	.s tBPERowId=0
	.s tTmpDate=""
	.for  s tTmpDate=$o(^DHCBPEquipMaintain(0,"EquipDate",Equipid,tTmpDate)) q:tTmpDate=""  d
	..s tBPERowId=""
	..for  s tBPERowId=$o(^DHCBPEquipMaintain(0,"EquipDate",Equipid,tTmpDate,tBPERowId)) q:tBPERowId=""  d
	...s tDBPCEquipDr=$lg(^DHCBPEquipMaintain(tBPERowId),1)
	...s tDBPCEquipDesc=""
	...i tDBPCEquipDr'="" s tDBPCEquipDesc=$lg($g(^DHCBPC("Equip",tDBPCEquipDr)),3) 
	...s tDBPEquipPartDesc=$lg(^DHCBPEquipMaintain(tBPERowId),2)
	...s tBPEMType=$lg(^DHCBPEquipMaintain(tBPERowId),3)
	...s tBPEMTypeDesc=""
	...i tBPEMType="C" s tBPEMTypeDesc="消毒"
	...i tBPEMType="M" s tBPEMTypeDesc="保养"
	...i tBPEMType="R" s tBPEMTypeDesc="维修"
	...s tBPEMPartType=$lg(^DHCBPEquipMaintain(tBPERowId),4)
	...s tBPEMPartTypeDesc=""
	...i tBPEMPartType="C" s tBPEMPartTypeDesc="清洁"
	...i tBPEMPartType="M" s tBPEMPartTypeDesc="保养"
	...i tBPEMPartType="R" s tBPEMPartTypeDesc="维修"
	...i tBPEMPartType="P" s tBPEMPartTypeDesc="替换"	
	...s tStartDate=$lg(^DHCBPEquipMaintain(tBPERowId),5)
	...s tStartDate=##class(web.DHCANOPCom).ConvertToDate(tStartDate)
	...s tStartTime=$lg(^DHCBPEquipMaintain(tBPERowId),6)
	...s tStartTime=##class(web.DHCANOPCom).ConvertToTime(tStartTime)
	...s tEndDate=$lg(^DHCBPEquipMaintain(tBPERowId),7)
	...s tEndDate=##class(web.DHCANOPCom).ConvertToDate(tEndDate)
	...s tEndTime=$lg(^DHCBPEquipMaintain(tBPERowId),8)
	...s tEndTime=##class(web.DHCANOPCom).ConvertToTime(tEndTime)
	...s tNote=$lg(^DHCBPEquipMaintain(tBPERowId),9)
	...s tBPEMExpense=$lg(^DHCBPEquipMaintain(tBPERowId),10)
	...s tUpUserId=$lg(^DHCBPEquipMaintain(tBPERowId),11)
	...;获取维护参加人
	...s tBPEMUserInfo=##class(web.DHCBPEquipMaintainUser).GetEquipMaintainUser(tBPERowId)
	...s userIdList=$p(tBPEMUserInfo,"^",1)
	...s userNameList=$p(tBPEMUserInfo,"^",2)
	...s userNameOut=##class(web.DHCBPEquipMaintainUser).GetEquipMaintainUserOut(tBPERowId)
	...d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPERowId,tDBPCEquipDr,tDBPCEquipDesc,tDBPEquipPartDesc,tBPEMType,tBPEMTypeDesc,tBPEMPartType,tBPEMPartTypeDesc,tStartDate,tStartTime,tEndDate,tEndTime,tNote,tBPEMExpense,tUpUserId,userIdList,userNameList,userNameOut)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPEquipMaintainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPEquipMaintainExecute ]
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

ClassMethod FindBPEquipMaintainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPEquipMaintainExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
