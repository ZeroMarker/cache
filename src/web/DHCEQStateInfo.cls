Import SQLUser

/// Mozy	2017-6-9
/// 设备情况记录
Class web.DHCEQStateInfo Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// RecordFlag:查询记录标志(非空)
/// d ##class(%ResultSet).RunQuery("web.DHCEQStateInfo","GetStateInfo","","2029900000002","","","","202","78","","")
/// QW20181019 HISUI改造:修改入参及出参
/// Modify by zx 2020-09-01 移动端增加类组入参
Query GetStateInfo(PFileNo As %String = "", PNo As %String = "", PName As %String = "", PRecordDate As %String = "", PRecordFlag As %String = "", PLoc As %String = "", PUser As %String = "", PStartDate As %String = "", PEndDate As %String = "", PGroup As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TType:%String,TEquipDR:%String,TName:%String,TFileNo:%String,TNo:%String,TModel:%String,TLeaveFactoryNo:%String,TStoreLoc:%String,TEquipType:%String,TRecordDate:%String,TStartDate:%String,TStartTime:%String,TEndDate:%String,TEndTime:%String,TTotalTime:%String,TUseContent:%String,TStartState:%String,TStartStateInfo:%String,TEndState:%String,TEndStateInfo:%String,TUserDR:%String,TUser:%String,TStatus:%String,TUpdateUser:%String")
{
}

ClassMethod GetStateInfoExecute(ByRef qHandle As %Binary, PFileNo As %String = "", PNo As %String = "", PName As %String = "", PRecordDate As %String = "", PRecordFlag As %String = "", PLoc As %String = "", PUser As %String = "", PStartDate As %String = "", PEndDate As %String = "", PGroup As %String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	If (PFileNo="")&(PNo="")&(PName="")&(PRecordFlag="") Quit $$$OK
 	
	Set Row=1
	Set index=1
	;Set ^DHCEQMozy("GetStateInfo")=PFileNo_","_PNo_","_PName_","_PRecordDate_","_PRecordFlag_","_PLoc_","_PUser_","_PStartDate_","_PEndDate
 	Set PFileNo=$ZCONVERT(PFileNo ,"U")
 	Set PNo=$ZCONVERT(PNo ,"U")
 	Set PName=$ZCONVERT(PName ,"U")		;Mozy0200	2017-10-11
	;;需求： 570551		Mozy	2018-3-23	修正日期参数转换
	;Modified By QW20181105 需求号:743277
 	If PStartDate'="" Set PStartDate=##Class(web.DHCEQCommon).TransValueFromPage(PStartDate,"date")
 	If PEndDate'="" Set PEndDate=##Class(web.DHCEQCommon).TransValueFromPage(PEndDate,"date")
 	;End By QW20181105 需求号:743277
 	Set ShowLines=3	;设置默认每台设备显示记录数
 	
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid)) quit:rowid=""  d
	.d ResetVariablesGetStateInfo
	.s EquipDR = rowid
	.d CheckDataEquip
	.q:passed=0
	.s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	.Quit:(PName'="")&&($ZCONVERT(Name ,"U")'[PName)	;Mozy0200	2017-10-11
	.s ModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	.s Model = ##Class(web.DHCEQCommon).GetTrakNameByID("model", ModelDR)
	.s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	.s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", StoreLocDR)
	.s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", EquipTypeDR)
	.;^DHCEQStateInfo(0,"Equip","N",0,170,1)
	.s count=1
	.s rrid=""
	.f  s rrid=$o(^DHCEQStateInfo(0,"Equip","N",0,rowid,rrid),-1) quit:rrid=""  d
	..q:(count>ShowLines)&&(PRecordFlag="")
	..s RowID=rrid
	..q:(PRecordDate'="")&&(PRecordDate'=$p($g(^DHCEQStateInfo(RowID)),"^",2))
	..s Type=##Class(web.DHCEQStateInfo).GetTypeDisplay($p($g(^DHCEQStateInfo(RowID)),"^",1))
	..s RecordDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(RowID)),"^",3),"date")	;需求： 830104		Mozy	2019-2-20
	..q:(PStartDate'="")&&($p($g(^DHCEQStateInfo(RowID)),"^",4)<PStartDate)		;;需求： 570551		Mozy	2018-3-23
	..s StartDate=$p($g(^DHCEQStateInfo(RowID)),"^",4)	//modified by csj 20180323	
	..i StartDate'=""  s StartDate=##class(web.DHCEQCommon).TransValueToPage(StartDate,"date") //modified by csj 20180323 日期格式调整 需求号：571551
	..s StartTime=$ZTIME($p($g(^DHCEQStateInfo(RowID)),"^",5),1)
	..q:(PEndDate'="")&&($p($g(^DHCEQStateInfo(RowID)),"^",6)>PEndDate)			;;需求： 570551		Mozy	2018-3-23
	..s EndDate=$p($g(^DHCEQStateInfo(RowID)),"^",6)	//modified by csj 20180323
	..i EndDate'=""  s EndDate=##class(web.DHCEQCommon).TransValueToPage(EndDate,"date")	//modified by csj 20180323 日期格式调整 需求号：571551
	..s EndTime=$ZTIME($p($g(^DHCEQStateInfo(RowID)),"^",7),1)
	..s TotalTime=$p($g(^DHCEQStateInfo(RowID)),"^",8)
	..s UseContent=$p($g(^DHCEQStateInfo(RowID)),"^",9)
	..s StartState=$p($g(^DHCEQStateInfo(RowID)),"^",10)
	..s StartStateInfo=$p($g(^DHCEQStateInfo(RowID)),"^",11)
	..i StartStateInfo="" s StartStateInfo=StartState
	..s EndState=$p($g(^DHCEQStateInfo(RowID)),"^",12)
	..s EndStateInfo=$p($g(^DHCEQStateInfo(RowID)),"^",13)
	..i EndStateInfo="" s EndStateInfo=EndState
	..s UserDR=$p($g(^DHCEQStateInfo(RowID)),"^",14)
	..q:(PUser'="")&&(UserDR'=PUser)
	..s User=##Class(web.DHCEQCommon).GetTrakNameByID("user", UserDR)
	..s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay($p($g(^DHCEQStateInfo(RowID)),"^",17))
	..s UpdateUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQStateInfo(RowID)),"^",22))
	..d OutputRowGetStateInfo
	.
	.i (count=1)&&(PRecordFlag="") d OutputRowGetStateInfo		;登记操作记录如果没有使用记录的设备应该输出空的使用记录行
	Quit $$$OK
OutputRowGetStateInfo
	Set count=count+1	;累加器
	Set Data=$lb(Row,RowID,Type,EquipDR,Name,FileNo,No,Model,LeaveFactoryNo,StoreLoc,EquipType,RecordDate,StartDate,StartTime,EndDate,EndTime,TotalTime,UseContent,StartState,StartStateInfo,EndState,EndStateInfo,UserDR,User,Status,UpdateUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set Row=Row+1
	quit
ResetVariablesGetStateInfo
	Set (Type,EquipDR,Name,FileNo,No,Model,LeaveFactoryNo,EquipType,RowID,RecordDate,StartDate,StartTime,EndDate,EndTime,TotalTime,UseContent,StartState,StartStateInfo,EndState,EndStateInfo,UserDR,User,Status,UpdateUser)=""
	quit
CheckDataEquip
	s passed=1
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag'="N" s passed=0
	i passed=0 q
	;i (##Class(web.DHCEQCommon).CheckManageLimit("","","","","","","",rowid)) s passed=0
	i passed=0 q
	
	s EquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,PGroup)) s passed=0
	s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	i (PNo'="")&&($ZCONVERT(No,"U")'[PNo) s passed=0
	i passed=0 q
	Set FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
	i (PFileNo'="")&&($ZCONVERT(FileNo,"U")'[PFileNo) s passed=0
	i passed=0 q	
	s EQStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	i ((EQStatus="3")||(EQStatus="4")) d
	.s passed=0
	s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	;i (StoreLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR))) s passed=0
	i (PLoc'="")&&(StoreLocDR'=PLoc) s passed=0
	i passed=0 q
	
	s StockStatus = $p($g(^DHCEQEquip(rowid)),"^",60)
	i ((StockStatus="0")||(StockStatus="3")) s passed=0
	
	quit
}

ClassMethod GetStateInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStateInfoExecute ]
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

ClassMethod GetStateInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStateInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modify by zx 2020-09-01 移动端增加人员参数
/// w ##Class(web.DHCEQStateInfo).SaveStateInfo("5157,5158,5159&^0^^^2017-08-23 17:30:07^^2017-08-24 17:30:13^^^^^^正常^3828",0)
ClassMethod SaveStateInfo(info, type As %String = "", User As %String = "")
{
    new rowid,EquipDRStr,val,RowID,quantity
	k PLIST
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set DRStr=$Piece(info,"&",1)
	Set val=$Piece(info,"&",2)
	
	;Set RowID=$Piece(val,"^",1)
	Set PLIST(2)=$Piece(val,"^",2)  ; SI_Type
	;Set PLIST(3)=$Piece(val,"^",3)  ; SI_EquipDR
	;Set PLIST(4)=$ZDATEH($Piece(val,"^",4),3)  ; SI_RecordDate
	Set PLIST(4)=+$H
	Set StartDate=$Piece(val,"^",5)
	Set PLIST(5)=##class(web.DHCEQCommon).TransValueFromPage($Piece(StartDate," ",1),"date")  ; SI_StartDate
    Set PLIST(6)=##class(web.DHCEQCommon).TransValueFromPage($Piece(StartDate," ",2),"time")  ; SI_StartTime
    Set EndDate=$Piece(val,"^",7)
	Set PLIST(7)=##class(web.DHCEQCommon).TransValueFromPage($Piece(EndDate," ",1),"date")  ; SI_EndDate
	Set PLIST(8)=##class(web.DHCEQCommon).TransValueFromPage($Piece(EndDate," ",2),"time")  ; SI_EndTime
	Set TotalTime=0
	If PLIST(7)>=PLIST(5)
	{
		Set TotalTime=(PLIST(7)-PLIST(5))*24*3600+PLIST(8)-PLIST(6)
		If TotalTime<0 Set TotalTime=0
		Set TotalTime=##Class(web.DHCEQCommon).FormatNumber(TotalTime/3600,0,0)
	}
	Set PLIST(9)=TotalTime					; SI_TotalTime
	Set PLIST(10)=$Piece(val,"^",9)  		; SI_UseContent
	;Set PLIST(11)=$Piece(val,"^",10)  		; SI_StartState
	;20170831 Mozy0194	begin
	If ($Piece(val,"^",11)="")||($Piece(val,"^",11)="正常") Do
	.Set PLIST(11)="正常"
	.Set PLIST(12)=""
	Else  Do
	.Set PLIST(11)="异常"
	.Set PLIST(12)=$Piece(val,"^",11)  		; SI_StartStateInfo
	;Set PLIST(13)=$Piece(val,"^",12)  		; SI_EndState
	If ($Piece(val,"^",13)="")||($Piece(val,"^",13)="正常") Do
	.Set PLIST(13)="正常"
	.Set PLIST(14)=""
	Else  Do
	.Set PLIST(13)="异常"
	.Set PLIST(14)=$Piece(val,"^",13)  		; SI_EndStateInfo
	;20170831 Mozy0194	end
	Set PLIST(15)=$Piece(val,"^",14)  		; SI_UserDR
	;Set PLIST(16)=$Piece(val,"^",10)  		; SI_ExaminerDR
	;Set PLIST(17)=$Piece(val,"^",10)  		; SI_Remark
	Set PLIST(18)=0  						; SI_Status	",新增,提交,审核,作废"	",0,1,2,3"
	Set PLIST(19)="N"          				; SI_InvalidFlag 无效标志
	
	Set PLIST(23)=User   ; SI_UpdateUserDR
	Set PLIST(24)=+$H  							; SI_UpdateDate
	Set PLIST(25)=$Piece($H,",",2)  			; SI_UpdateTime
	
	;Set PLIST(32)=""	; SI_Hold1
	;Set PLIST(33)=""	; SI_Hold2
	;Set PLIST(34)=""	; SI_Hold3
	;Set PLIST(35)=""	; SI_Hold4
	;Set PLIST(36)=""	; SI_Hold5
	;Set PLIST(37)=""	; SI_Hold6
	;Set PLIST(38)=""	; SI_Hold7
	;Set PLIST(39)=""	; SI_Hold8
	;Set PLIST(40)=""	; SI_Hold9
	;Set PLIST(41)=""	; SI_Hold10
	
	if +type=0
	{
		Set PLIST(20)=User  ; SI_AddUserDR
		Set PLIST(21)=+$H  							; SI_AddDate
		Set PLIST(22)=$Piece($H,",",2)  			; SI_AddTime
		Set quantity=$L(DRStr,",")
		for i=1:1:quantity
		{
			Set PLIST(3)=$Piece(DRStr,",",i)  ; SI_EquipDR
			&SQL(insert into sqluser.DHC_EQStateInfo values :PLIST())
			q:SQLCODE
		}
	}
	else
	{
		Set quantity=$L(DRStr,",")
		for i=1:1:quantity
		{
			Set RowID=$Piece(DRStr,",",i)  ; SI_RowID
			&SQL(update sqluser.DHC_EQStateInfo values :PLIST() where SI_RowID=:RowID and SI_Status=0)
			q:SQLCODE
		}
	}
	Set ID=$g(%ROWID)
	Quit SQLCODE_"^"_quantity
}

/// w ##Class(web.DHCEQStateInfo).DeleteStateInfo(2)
ClassMethod DeleteStateInfo(DRStr)
{
	i DRStr="" q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new quantity,RowID
	s Date=+$H
	s Time=$P($H,",",2)
	Set quantity=$L(DRStr,",")
	for i=1:1:quantity
	{
		Set RowID=$Piece(DRStr,",",i)  ; SI_RowID
		&SQL(Update SQLUSER.DHC_EQStateInfo Set SI_InvalidFlag='Y',SI_UpdateUserDR=:User,SI_UpdateDate=:Date,SI_UpdateTime=:Time where SI_RowID=:RowID and SI_Status=0)
	}
	;Set ID=$g(%ROWID)
	Quit SQLCODE_"^"_quantity
}

/// w ##Class(web.DHCEQStateInfo).AuditStateInfo(2)
ClassMethod AuditStateInfo(RowID)
{
	i RowID="" q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (RowID,User)
	s Date=+$H
	s Time=$P($H,",",2)
	
	&SQL(Update SQLUSER.DHC_EQStateInfo Set SI_Status=2,SI_AuditUserDR=:User,SI_AuditDate=:Date,SI_AuditTime=:Time where SI_RowID=:RowID and SI_Status<2)
	Set ID=$g(%ROWID)
	Quit SQLCODE_"^"_ID
}

/// w ##Class(web.DHCEQStateInfo).GetTypeDisplay(2)
ClassMethod GetTypeDisplay(Type As %Library.String) As %Status
{
	i Type=""  q ""
	i +Type=0  q "运行"
	i +Type=1  q "故障"
	
	q "未定义"
}

/// Mozy	2019-4-9	获取设备无结束日期的登记记录  2020-09-01提交
/// w ##Class(web.DHCEQStateInfo).GetOneStateInfo(374,85,126,0)
/// w ##Class(web.DHCEQStateInfo).GetOneStateInfo(11586,81)
ClassMethod GetOneStateInfo(EQDR As %String = "", CurGroupID As %String = "", LocDR As %String = "", Status As %String = "0")
{
	i EQDR="" q ""
	;s ^DHCEQMozy("web.DHCEQStateInfo.GetOneStateInfo")=EQDR_","_CurGroupID_","_LocDR_","_Status
	n str,rowid
	;;;;i (LocDR'="")&&($p($g(^DHCEQEquip(EQDR)),"^",67)'=LocDR) q ""
	i $p($g(^DHCEQEquip(EQDR)),"^",59)'="N" q ""
	;i (##Class(web.DHCEQCommon).CheckManageLimit("","","","","","","",EQDR)) q ""
	i ##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(EQDR)),"^",63), CurGroupID)=1 q ""
	i (($p($g(^DHCEQEquip(EQDR)),"^",38)="3")||($p($g(^DHCEQEquip(EQDR)),"^",38)="4")) q ""
	i (($p($g(^DHCEQEquip(EQDR)),"^",60)="0")||($p($g(^DHCEQEquip(EQDR)),"^",60)="3")) q ""
	w 111
	s str=""
	s rowid=""
	f  s rowid=$o(^DHCEQStateInfo(0,"Equip","N",0,EQDR,rowid)) q:(rowid="")||(str'="")  d
	.q:$Piece($Get(^DHCEQStateInfo(rowid)),"^",6)'=""
	.q:$Piece($Get(^DHCEQStateInfo(rowid)),"^",17)'=Status		; 0:新增|1:提交|2:审核|3:作废
	.q:$Piece($Get(^DHCEQStateInfo(rowid)),"^",18)'="N"
	.s str=rowid_"^"_$Get(^DHCEQStateInfo(rowid))
	.s str=str_"^"
	.i $Piece($Get(^DHCEQStateInfo(rowid)),"^",4)'="" s str=str_$ZD($Piece($Get(^DHCEQStateInfo(rowid)),"^",4),3)
	.s str=str_"^"
	.i $Piece($Get(^DHCEQStateInfo(rowid)),"^",5)'="" s str=str_$ZTIME($Piece($Get(^DHCEQStateInfo(rowid)),"^",5),1)
	.s str=str_"^"
	.i $Piece($Get(^DHCEQStateInfo(rowid)),"^",6)'="" s str=str_$ZD($Piece($Get(^DHCEQStateInfo(rowid)),"^",6),3)
	.s str=str_"^"
	.i $Piece($Get(^DHCEQStateInfo(rowid)),"^",7)'="" s str=str_$ZTIME($Piece($Get(^DHCEQStateInfo(rowid)),"^",7),1)
	
	q str
}

Storage Default
{
<Data name="DHCEQStateInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQStateInfoD</DataLocation>
<DefaultData>DHCEQStateInfoDefaultData</DefaultData>
<IdLocation>^web.DHCEQStateInfoD</IdLocation>
<IndexLocation>^web.DHCEQStateInfoI</IndexLocation>
<StreamLocation>^web.DHCEQStateInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
