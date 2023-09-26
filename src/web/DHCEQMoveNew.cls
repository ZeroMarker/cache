/// 邹旋	配送业务
Class web.DHCEQMoveNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQMoveNew).SaveData("^^6616^1^15^2^设备返送,送出单为:PS2017040014^1^87^355^^^^1^^^^^^^", "1")
/// add by zx 2017-09-19 增加配送附件的处理
ClassMethod SaveData(val, User, valList As %Library.String = "", DelRowIDs As %Library.String = "")
{
    //new (val,User,valList,DelRowIDs)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PLIST,rowid
	s rowid=$p(val,"^",1)		//RowID   
	s PLIST(2)=$p(val,"^",2)	//No
	s PLIST(3)="1"				//ObjType
	s PLIST(4)=$p(val,"^",3)	//ObjID
	s PLIST(5)=$p(val,"^",4)	//SourceType
	s PLIST(6)=$p(val,"^",5)	//SourceID
	s PLIST(7)=$p(val,"^",6)	//EventType
	s PLIST(8)=$p(val,"^",7)	//MoveReason
	s PLIST(9)=$p(val,"^",8)	//FromDeptType
	s PLIST(10)=$p(val,"^",9)	//FromDeptID
	s PLIST(11)=$p(val,"^",10)	//FromLocationDR
	s PLIST(12)=$p(val,"^",11)	//StartDate
	i $p(val,"^",11)'="" s PLIST(12)=$zdh($p(val,"^",11),3)
	s PLIST(13)=$p(val,"^",12)	//StartTime
	i $p(val,"^",12)'="" s PLIST(13)=$zth($p(val,"^",12),3)
	i (PLIST(12)'="")&(PLIST(13)="") s PLIST(13)=$p($h,",",2)
	s PLIST(14)=$p(val,"^",13)	//ToLocationDR
	s PLIST(15)=$p(val,"^",14)	//ToDeptType
	s PLIST(16)=$p(val,"^",15)	//ToDeptID
	s PLIST(17)=$p(val,"^",16)	//EndDate
	i $p(val,"^",16)'="" s PLIST(17)=$zdh($p(val,"^",16),3)
	s PLIST(18)=$p(val,"^",17)	//EndTime
	i $p(val,"^",17)'="" s PLIST(18)=$zth($p(val,"^",17),3)
	i (PLIST(17)'="")&(PLIST(18)="") s PLIST(18)=$p($h,",",2)
	s PLIST(19)=$p(val,"^",18)	//SendUserDR
	s PLIST(20)=$p(val,"^",19)	//AcceptUserDR
	S PLIST(21)=User
	S PLIST(22)=+$H
	S PLIST(23)=$P($H,",",2)
	s PLIST(30)=$p(val,"^",20)	//Remark
	s PLIST(31)=$p(val,"^",21)				//Status
	i $p(val,"^",21)="" s PLIST(31)="0"
	s PLIST(32) ="N"
		
	s tmpid=""
	&SQL(select M_RowID into :tmpid from sqluser.DHC_EQMove where M_ObjID=:PLIST(4) and M_EventType=:PLIST(7) and M_SourceType=:PLIST(5) and M_SourceID=:PLIST(6) and M_FromDeptType=:PLIST(9) and M_FromDeptID=:PLIST(10) and M_InvalidFlag='N') 
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	if (rowid="")
	{
        i PLIST(2)="" s PLIST(2)=##Class(web.DHCEQCCounter).GetNextNo("DHC_EQMove",+$h,PLIST(10))
		&SQL(Insert Into sqluser.DHC_EQMove Values :PLIST())
		i SQLCODE
		{
			q SQLCODE
		}
		s rowid=$G(%ROWID)
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQMove Values :PLIST() where M_RowID = :rowid)
		i SQLCODE
		{
			q SQLCODE
		}
	}
    //add by zx 2017-09-19 附件处理 begin
    s SQLCODE=..DeleteAffixList(DelRowIDs)
    i SQLCODE
    {
        q SQLCODE
    }
    
    s SQLCODE=..SaveAffixList(rowid,valList)
    i SQLCODE
    {
        q SQLCODE
    }
    //add by zx 2017-09-19 附件处理 end
	i PLIST(11)'=""
	{
		s SQLCODE=..SavePosition(rowid,"1",User) //送出
		i SQLCODE
		{
			q SQLCODE
		}
	}
	i PLIST(14)'=""
	{
		s SQLCODE=..SavePosition(rowid,"2",User) //到达
		i SQLCODE
		{
			q SQLCODE
		}
	}
	Set ID=rowid
	q ID
}

/// 位置信息保存
ClassMethod SavePosition(MoveDR, Process, User)
{
	//new (MoveDR, Process, User)
	s (EventType, LocationDR, Date, Time, InvalidFlag)=""
	
	s CurDate=+$H
	s CurTime=$P($H,",",2)
	i MoveDR="" q -1
	s Result=$g(^DHCEQMove(MoveDR))
	i Process="1" d
	.s EventType=$p(Result,"^",6)
	.s LocationDR=$p(Result,"^",10)
	.s Date=$p(Result,"^",11)
	.s Time=$p(Result,"^",12)
	.s InvalidFlag=$p(Result,"^",31)
	e  d
	.s EventType=$p(Result,"^",6)
	.s LocationDR=$p(Result,"^",13)
	.s Date=$p(Result,"^",16)
	.s Time=$p(Result,"^",17)
	.s InvalidFlag=$p(Result,"^",31)
	k PLISTX
	s PLISTX(2)=MoveDR
	s PLISTX(3)=EventType
	s PLISTX(4)=Process
	s PLISTX(5)=LocationDR
	s PLISTX(6)=Date
	s PLISTX(7)=Time
	s PLISTX(8)=User
	s PLISTX(9)=CurDate
	s PLISTX(10)=CurTime
	s PLISTX(12)=InvalidFlag
	i PLISTX(12)="Y"
	{
		s PLISTX(14)=User
		s PLISTX(15)=CurDate
		s PLISTX(16)=CurTime
	}
	s mrowid=""
	&SQL(Select MP_RowID into :mrowid from SQLUSER.DHC_EQMovePosition where MP_MoveDR=:MoveDR and MP_EventType=:EventType and MP_EventProcess=:Process) 
	if (mrowid="")
	{
		&SQL(Insert Into SQLUSER.DHC_EQMovePosition Values :PLISTX())
	}
	else
	{
		&SQL(update sqluser.DHC_EQMovePosition values :PLISTX() where MP_RowID=:mrowid)
	}
 	q SQLCODE
}

/// add by zx 2017-04-18
/// 根据设备ID获取相关联单据
/// d ##class(%ResultSet).RunQuery("web.DHCEQMoveNew","BusinessList","9613")
Query BusinessList(EquipDR) As %Query(ROWSPEC = "TSourceType:%String, TSourceID:%String, TEquipName:%String, TFileNo:%String, TInfo:%String, TEventType:%String") [ SqlProc ]
{
}

ClassMethod BusinessListExecute(ByRef qHandle As %Binary, EquipDR) As %Status
{
	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
 	i EquipDR="" Quit $$$OK
 	s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
 	s TFileNo=$p($g(^DHCEQEquip(EquipDR)),"^",85)
 	
 	s ReturnIf=##Class(web.DHCEQMoveNew).CheckMoveByEquip(EquipDR)
 	i ReturnIf'=0 d
 	.d ResetVariablesBusinessList
 	.s TEventType="2"
 	.s TMoveID=ReturnIf
 	.s TSourceType="65"
 	.s TSourceID=TMoveID
 	.s TFromLoc=$p($g(^DHCEQMove(TMoveID)),"^",9)
 	.i TFromLoc'="" s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLoc)
 	.s TToLoc=$p($g(^DHCEQMove(TMoveID)),"^",15)
 	.i TToLoc'="" s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLoc)
 	.s TSendUser=$p($g(^DHCEQMove(TMoveID)),"^",18)
 	.i TSendUser'="" s TSendUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TSendUser)
 	.s TStartDate=$p($g(^DHCEQMove(TMoveID)),"^",11)
 	.i TStartDate'="" s TStartDate=$zd(TStartDate,3)
 	.s TRequestNo=$p($g(^DHCEQMove(TMoveID)),"^",1)
 	.s TInfo="单号："_TRequestNo_"，设备于"_TStartDate_""_TFromLoc_"送至"_TToLoc_"，配送责任人："_TSendUser_"，无对应返回单。"
 	.d OutputRowBusinessList
 	e  d
 	.d ResetVariablesBusinessList
 	.s TEventType="1"
 	.s EXObjID=$o(^DHCEQMExObj(0,"ExID","1",EquipDR,0)) 
 	.i EXObjID'="" d
 	..s InvalidFlag=0 //先遍历未完成的维修单据,同一设备可能多维修单未完成
 	..s MaintBussNum=##class(web.DHCEQCommon).GetSysInfo("990054")
 	..s MaintRequestID=0
 	..f  s MaintRequestID=$o(^DHCEQMMaintRequest(0,"Status","1",MaintRequestID)) q:MaintRequestID=""  d
 	...q:$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",57)="Y"
 	...s TEXObjID=$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",5)
 	...q:EXObjID'=TEXObjID
 	...s InvalidFlag=InvalidFlag+1
 	...d SetMaintRequestInfo
 	..i InvalidFlag=0 d
 	...s MaintRequestID=""
 	...f  s MaintRequestID=$o(^DHCEQMMaintRequest(0,"Source","1",EXObjID,MaintRequestID),-1) q:(MaintRequestID="")||(MaintBussNum<1)  d
 	....q:$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",57)="Y"
 	....q:$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",41)<1
 	....s MaintBussNum=MaintBussNum-1
 	....d SetMaintRequestInfo
 	.s InvalidFlag=0 //先遍历未完成的租赁单据,同一设备只能一张租赁单未完成
 	.s RentID=0
 	.f  s RentID=$o(^DHCEQRent(0,"Status","1",RentID)) q:(RentID="")||(InvalidFlag>0)  d
 	..s TEquipDR=$p($g(^DHCEQRent(RentID)),"^",9)
 	..q:EquipDR'=TEquipDR
 	..q:$p($g(^DHCEQRent(RentID)),"^",31)="Y"
 	..s InvalidFlag=InvalidFlag+1
 	..d SetRentInfo
 	.i InvalidFlag=0 d
 	..s RentBussNum=##class(web.DHCEQCommon).GetSysInfo("990054")
 	..s RentID=""
 	..f  s RentID=$o(^DHCEQRent(0,"Equip",EquipDR,RentID),-1) q:(RentID="")||(RentBussNum<1)  d
 	...q:$p($g(^DHCEQRent(RentID)),"^",31)="Y"
 	...q:$p($g(^DHCEQRent(RentID)),"^",36)<1
 	...s RentBussNum=RentBussNum-1
 	...d SetRentInfo
 	
	Quit $$$OK

SetMaintRequestInfo
	s TSourceType="31"
 	s TSourceID=MaintRequestID
 	s TRequestNo=$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",1)
 	s TRequestLoc=$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",6)
 	i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TRequestLoc)
 	s TFaultCase=$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",10)
 	i TFaultCase'="" s TFaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",TFaultCase)),"^",2)
 	s TFaultCaseRemark=$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",11)
 	s TRequestDate=$p($g(^DHCEQMMaintRequest(MaintRequestID)),"^",18)
 	i TRequestDate'="" s TRequestDate=$zd(TRequestDate,3)
 	i TFaultCase="" s TFaultInfo=TFaultCaseRemark
 	e  i TFaultCaseRemark="" s TFaultInfo=TFaultCase
 	e  i (TFaultCaseRemark'="")&&(TFaultCase'="") s TFaultInfo=TFaultCase_"("_TFaultCaseRemark_")"
 	s TInfo="单号："_TRequestNo_"，"_TRequestLoc_"于"_TRequestDate_"申请报修""，故障原因："_TFaultInfo
 	d OutputRowBusinessList
 	quit
SetRentInfo
	s TSourceType="64"
 	s TSourceID=RentID
 	s TRequestNo=$p($g(^DHCEQRent(RentID)),"^",1)
 	s TRequestLoc=$p($g(^DHCEQRent(RentID)),"^",2)
 	i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TRequestLoc)
 	s TRentDate=$p($g(^DHCEQRent(RentID)),"^",10)
 	i TRentDate'="" s TRentDate=$zd(TRentDate,3)
 	s TRequestDate=$p($g(^DHCEQRent(RentID)),"^",5)
 	i TRequestDate'="" s TRequestDate=$zd(TRequestDate,3)
 	s TInfo="单号："_TRequestNo_"，"_TRentLoc_"于"_TRequestDate_"申请租借"_"，借出时间："_TRentDate
 	d OutputRowBusinessList
 	quit
OutputRowBusinessList
	s Data=$lb(TSourceType, TSourceID, TEquipName, TFileNo, TInfo, TEventType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBusinessList
	s (TSourceType, TSourceID, TInfo, TRequestNo, TRequestLoc, TRentLoc, TRequestDate, TRentDate, TFaultCase, TFaultCaseRemark, TFaultInfo, TFromLoc, TToLoc, TSendUser, TStartDate, TEventType)=""
	quit
}

ClassMethod BusinessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BusinessListExecute ]
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

ClassMethod BusinessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BusinessListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2017-04-18
/// 返回值 非0,需要建返还单 0,不可建返还单
/// 获取同一业务指定设备送出单有无,提示新建返还单 可业务交叉生成配送单
/// w ##Class(web.DHCEQMoveNew).CheckMoveReturn("64","9")
ClassMethod CheckMoveReturn(SourceType, SourceID)
{
	
	s ReturnFlag="0"
	i (SourceType="")||(SourceID)="" q ReturnFlag
	s MoveID=0
	f  s MoveID=$o(^DHCEQMove(0,"Source",SourceType,SourceID,MoveID)) q:(MoveID="")||(ReturnFlag'="0")  d
	.s TEventType=$p($g(^DHCEQMove(MoveID)),"^",6)
	.q:(TEventType'="1")
	.s TMoveReturnID=$p($g(^DHCEQMove(MoveID)),"^",36)
	.q:TMoveReturnID'=""
	.s TInvalidFlag=$p($g(^DHCEQMove(MoveID)),"^",31)
	.q:TInvalidFlag="Y"
	.s ReturnFlag=MoveID
	
	q ReturnFlag
}

/// add by zx 2017-04-18
/// 根据设备判断是否存在配送未返送的单据
/// w ##Class(web.DHCEQMoveNew).CheckMoveByEquip(6616)
ClassMethod CheckMoveByEquip(EquipID)
{
	s ReturnFlag="0"
	s MoveID=0
	f  s MoveID=$o(^DHCEQMove(0,"ObjID","1",EquipID,MoveID)) q:(MoveID="")||(ReturnFlag'="0")  d
	.s TEventType=$p($g(^DHCEQMove(MoveID)),"^",6)
	.q:(TEventType'="1")
	.s TMoveReturnID=$p($g(^DHCEQMove(MoveID)),"^",36)
	.q:TMoveReturnID'=""
	.s TInvalidFlag=$p($g(^DHCEQMove(MoveID)),"^",31)
	.q:TInvalidFlag="Y"
	.s ReturnFlag=MoveID
	
	q ReturnFlag
}

/// add by zx 2017-04-18
/// SourceType:31,维修 64,租赁 65,配送(返送单用)
/// 根据业务类型及业务ID生成对应配送单据
/// w ##Class(web.DHCEQMoveNew).CreatMoveByBuss("31","754","2","1","85")
/// add by zx 2017-09-19 增加附件信息处理
/// Modify by zc 2020-05-20 ZC0073  添加配送人员信息入参vMoveUser
ClassMethod CreatMoveByBuss(vSourceType, vSourceID, vEventType, vUser As %Library.String = "", vGroupID As %Library.String = "", valList As %Library.String = "", DelRowIDs As %Library.String = "", vMoveUser As %Library.String = "")
{
     //new (vSourceType, vSourceID, vEventType, vUser, vGroupID, valList, DelRowIDs)
    s (CurRowID,No,ObjID,SourceType,SourceID,EventType,MoveReason,FromDeptType,FromDeptID,FromLocationDR,StartDate,StartTime)=""
    s (ToLocationDR,ToDeptType,ToDeptID,EndDate,EndTime,SendUserDR,AcceptUserDR,Remark,Status)=""
    s SourceType=vSourceType
    s SourceID=vSourceID
    s EventType=vEventType
    s FromDeptType="1"  //目前只处理来源为科室的
    s ToDeptType="1"
    if vSourceType="31" //维修
    {
        s ObjID=$p($g(^DHCEQMMaintRequest(SourceID)),"^",5)
        i ObjID'="" s ObjID=$p($g(^DHCEQMExObj(ObjID)),"^",5)
        s MoveReason="设备故障送修"
        //维修送出时来源单位为设备所在科室,返送时由送出单生成,这里不考虑
        s FromDeptID=$p($g(^DHCEQMMaintRequest(SourceID)),"^",6)  
        //到达单位为器械科库房
        s LocInfo=##class(web.DHCEQCommon).GetSysInfo("990055")
        s EquipType=$p($g(^DHCEQMMaintRequest(SourceID)),"^",3)
        s len=$l(LocInfo,"^")
        s locFlag=0
        f n=1:1:len d
        .q:locFlag>0
        .i (","_$p($p(LocInfo,"^",n),"&",2)_",")[(","_EquipType_",") d
        ..s locFlag=locFlag+1
        ..s ToDeptID=$p($p(LocInfo,"^",n),"&",1)
        s AcceptUserDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",26)
    }
    elseif vSourceType="64" //租赁
    {
    	//Modify by qw 2020-07-08 DHCEQRent改为DHCEQSRent
        s ObjID=$p($g(^DHCEQSRent(SourceID)),"^",9)
        s MoveReason="设备租借"
        //租赁送出时来源单位为器械科,返送时由送出单生成,这里不考虑
        s FromDeptID=$p($g(^DHCEQSRent(SourceID)),"^",3) 
        //到达单位为租借科室
        s ToDeptID=$p($g(^DHCEQSRent(SourceID)),"^",2) 
    }
    elseif (vSourceType="65")&&(vEventType="2") //配送 只处理返送
    {
	    s Status="2"
        s Result=$g(^DHCEQMove(SourceID))
        i $p(Result,"^",36) q "-3" //返回单已存在
        s MoveReason="设备返送,送出单为:"_$p(Result,"^",1)
        s SourceType=$p(Result,"^",4)
        s SourceID=$p(Result,"^",5)
        s ObjID=$p(Result,"^",3)
        s FromDeptID=$p(Result,"^",15) // 返送时起止单位交换
        s FromLocationDR=$p(Result,"^",13)
        s ToDeptID=$p(Result,"^",9)
        s ToLocationDR=$p(Result,"^",10)
    }
    
    s val=CurRowID_"^"_No_"^"_ObjID_"^"_SourceType_"^"_SourceID_"^"_EventType_"^"_MoveReason_"^"_FromDeptType_"^"_FromDeptID
    s val=val_"^"_FromLocationDR_"^"_StartDate_"^"_StartTime_"^"_ToLocationDR_"^"_ToDeptType_"^"_ToDeptID_"^"_EndDate
    s val=val_"^"_EndTime_"^"_SendUserDR_"^"_AcceptUserDR_"^"_Remark_"^"_Status
    //^^43902^64^25^1^设备租借^1^662^^^^^1^342^^^^^^
    //^1^惠普^2^4^^^,^2^三星^2^3^^^,^3^欧普^2^3^^^^
    //w ##Class(web.DHCEQMoveNew).SaveData("^^43902^64^25^1^设备租借^1^662^^^^^1^342^^^^^^", "4352", "^1^惠普^2^4^^^,^2^三星^2^3^^^,^3^欧普^2^3^^^^", "")
    s vRowID=##Class(web.DHCEQMoveNew).SaveData(val, vUser, valList, DelRowIDs)
    s result=vRowID
	
	//Modify by zc 2020-05-20 ZC0073 begin
	i (result>0)&&(vMoveUser'="") d
    .&SQL(Insert Into SQLUSER.DHC_EQMoveUsers (MU_MoveDR,MU_UserDR) Values (:vRowID,:vMoveUser))
    .i SQLCODE s result=-1 
	//Modify by zc 2020-05-20 ZC0073 end 
	
    //返送时向对应送出单hold1字段中插入返送单id
    i (result>0)&&(vSourceType="65")&&(vEventType="2") d
    .&SQL(update sqluser.DHC_EQMove SET M_Hold1=:result where M_RowID=:vSourceID)
    .i SQLCODE s result=-1 //关联送出单和返还单失败
    
    //i (result>0) d
    //.s SQLCODE=##Class(web.DHCEQMoveNew).SubmitData(vRowID,vUser,vGroupID)
    //.i SQLCODE<0 s result=-2 //数据提交失败
    
    q result
}

/// 创建:ZX 2017-01-17  ZX0037
/// 描述:提交
ClassMethod SubmitData(RowID As %Library.String = "", User As %Library.String = "", GroupID As %Library.String = "")
{
	new (RowID,User,GroupID)
	i RowID="" q ""
	s InvalidFlag=$p($g(^DHCEQMove(RowID)),"^",31)
	i InvalidFlag="Y" q -1015
	
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	
	s $ZT="ERRORSubmit"
	s Date=+$H
  	
	s PLIST(24) = User	
 	s PLIST(25) = Date	
	s PLIST(31)="1"	
	
	s EquipTypeDR=""
	s EquipDR=$p($g(^DHCEQMove(RowID)),"^",3)
	i EquipDR'="" s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	s Status=$p($g(^DHCEQMove(RowID)),"^",30)
	i Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	s EventType=$p($g(^DHCEQMove(RowID)),"^",6)
	s SourceType=$p($g(^DHCEQMove(RowID)),"^",4)
	
	s ApproveCondition="EventType,DHCEQMove,"_EventType_"^SourceType,DHCEQMove,"_SourceType
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("31")
	;w ##class(web.DHCEQCApproveSet).JudgeApproveSet("31", "2", "", "", "", "", "EventType,DHCEQMove,1^SourceType,DHCEQMove,31")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "","",ApproveCondition)
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$p(ApproveFlow,"^",1)
	s NextStep=$p(ApproveFlow,"^",2)
	s NextRole=$p(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s PLIST(31)="2"	
		s PLIST(27)=User
		s PLIST(28)=Date
		s AppInfoStatus="2"
		s AuditFlag=1
	}
	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"31",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}

	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQMove values :PLIST() where M_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("65", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag,GroupID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// 创建:ZX 2017-01-17  ZX0037
/// 描述:审核
ClassMethod AuditData(val, CurAction, editFieldsInfo)
{
	n EquipType,ApproveType,ApproveSet,RoleStep,Step,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	n User,GroupID,Date,RowID,AuditFlag,PLIST,EventType,SourceType,vLimitActions,vLimitUserDR,vLimitLocActions,vLimitLocDR
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s User=$P(val,"^",2)
	s GroupID=$P(val,"^",6)
	s Date=+$H
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("31")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("31", RowID)	
	i ApproveSet="" q -4007	
	s RoleStep=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,CurAction)
	s Role=$p(RoleStep,"^",1)
	s Step=$p(RoleStep,"^",2)
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, Step, Role)
	
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	Set AppInfoStatus="1"
	s AuditFlag=0
	TSTART
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQMove(RowID)),"^",30)=2)
		{
			TROLLBACK
			q -1010
		}
		s PLIST(31)="2"
		s PLIST(27)=User	
		s PLIST(28)=Date	
		&SQL(update sqluser.DHC_EQMove values :PLIST() where M_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		Set AppInfoStatus="2"			;AppInfoStatus
		s AuditFlag=1
	}
	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",Role,Step,User)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,Step,Role,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s EventType=$p($g(^DHCEQMove(RowID)),"^",6)
	s SourceType=$p($g(^DHCEQMove(RowID)),"^",4)
	i (EventType="1")&&(SourceType="31")
	{
		//i CurAction="PS_Send"
		//{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Audit",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",18)_","_$p($g(^DHCEQMove(RowID)),"^",19)
			s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_SendAudit",0))
			s vLimitLocDR=$p($g(^DHCEQMove(RowID)),"^",9)
		/*}
		elseif CurAction="PS_SendAudit"
		{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Audit",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",19)
			s vLimitLocActions=""
			s vLimitLocDR=""
		}
		elseif CurAction="PS_Audit"
		{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",18)
			s vLimitLocActions=""
			s vLimitLocDR=""
		}
		else
		{
			s vLimitActions=""
			s vLimitUserDR=""
			s vLimitLocActions=""
			s vLimitLocDR=""
		}*/
		
	}
	elseif (EventType="2")&&(SourceType="31")
	{
		//i CurAction="PS_Send"
		//{
			s AcceptUser=""
			s SourceID=$p($g(^DHCEQMove(RowID)),"^",5)
			i SourceID'="" s AcceptUser=$p($g(^DHCEQMMaintRequest(SourceID)),"^",26)
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_SendAudit",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=AcceptUser_","_$p($g(^DHCEQMove(RowID)),"^",18)
			s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Audit",0))
			s vLimitLocDR=$p($g(^DHCEQMove(RowID)),"^",15)
		/*}
		elseif CurAction="PS_SendAudit"
		{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",18)
			s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Audit",0))
			s vLimitLocDR=$p($g(^DHCEQMove(RowID)),"^",15)
		}
		elseif CurAction="PS_Audit"
		{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",18)
			s vLimitLocActions=""
			s vLimitLocDR=""
		}
		else
		{
			s vLimitActions=""
			s vLimitUserDR=""
			s vLimitLocActions=""
			s vLimitLocDR=""
		}*/
	}
	elseif (EventType="1")&&(SourceType="64")
	{
		//if CurAction="PS_Send"
		//{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",18)
			s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Audit",0))
			s vLimitLocDR=$p($g(^DHCEQMove(RowID)),"^",15)
			
		/*}
		elseif CurAction="PS_Audit"
		{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",18)
			s vLimitLocActions=""
			s vLimitLocDR=""
		}
		else
		{
			s vLimitActions=""
			s vLimitUserDR=""
			s vLimitLocActions=""
			s vLimitLocDR=""
		}*/
	}
	elseif (EventType="2")&&(SourceType="64")
	{
		//if CurAction="PS_Send"
		//{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",18)
			s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_SendAudit",0))
			s vLimitLocDR=$p($g(^DHCEQMove(RowID)),"^",9)
		/*}
		elseif CurAction="PS_SendAudit"
		{
			s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","PS_Arrive",0))
			s vLimitUserDR=$p($g(^DHCEQMove(RowID)),"^",18)
			s vLimitLocActions=""
			s vLimitLocDR=""
		}
		else
		{
			s vLimitActions=""
			s vLimitUserDR=""
			s vLimitLocActions=""
			s vLimitLocDR=""
		}*/
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("65", RowID, User, ApproveFlow_"^"_ApproveSet, "N",Role,AuditFlag,GroupID,vLimitActions,vLimitUserDR,vLimitLocActions,vLimitLocDR)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

/// 创建:ZX 2017-01-17  ZX0037
/// 描述:反提交
ClassMethod CancelSubmitData(val, action)
{
	new (val, action)
	Set $ZT="ERRORCancel"
	s RowID=$P(val,"^",1)
	q:RowID=""
	s User=$P(val,"^",2)
	s CancelToFlowDR=$P(val,"^",3)
	s ApproveSet=$P(val,"^",4)
	s Date=+$H
	Set RejectReason=$P(val,"^",5)
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}	 	

	s PLIST(31)=Status
	TSTART
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("31")
	
	//取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("31", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,action)
	s CurRole=$p(RoleStep,"^",1)
	s CurStep=$p(RoleStep,"^",1)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,CurStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQMove values :PLIST() where M_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	else
	{
		s ApproveFlow="^^^^^^^^"_ApproveSet	//Add By DJ 2016-05-23
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("65", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// w ##class(web.DHCEQMoveNew).GetOneMoveByID("40")
ClassMethod GetOneMoveByID(rowid)
{
	new result,resultex,AppInfo,MoveReason
	s (result,resultex,AppInfo,MoveReason)=""
	s result= ^DHCEQMove(rowid)
	s $p(result,"^",21)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"date")  // Modefied by zc 2022-4-8
	s resultex=resultex_"^"
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$Case($p(result,"^",2),1:"设备",:"")
	s resultex=resultex_"^"
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",3))),"^",1)_"("_$p($g(^DHCEQEquip($p(result,"^",3))),"^",85)_")"
	s resultex=resultex_"^"	
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$Case($p(result,"^",4),"31":"维修","64":"租赁","22":"转移单",:"")
	s resultex=resultex_"^"	
	i ($p(result,"^",5)'="")&&($p(result,"^",4)=31)  d
	.s resultex=resultex_$p($g(^DHCEQMMaintRequest($p(result,"^",5))),"^",1)
	i ($p(result,"^",5)'="")&&($p(result,"^",4)=64)  d
	.s resultex=resultex_$p($g(^DHCEQRent($p(result,"^",5))),"^",1)
	i ($p(result,"^",5)'="")&&($p(result,"^",4)=22)  d
	.s resultex=resultex_$p($g(^DHCEQStoreMove($p(result,"^",5))),"^",1)
	s resultex=resultex_"^"	
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$Case($p(result,"^",6),1:"送出",2:"返还",:"")
	s resultex=resultex_"^"	
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$Case($p(result,"^",8),1:"科室",2:"服务商",3:"供应商",4:"生产厂商",:"")
	s resultex=resultex_"^"	
	i ($p(result,"^",9)'="")&&($p(result,"^",8)=1)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p(result,"^",9))
	i ($p(result,"^",9)'="")&&($p(result,"^",8)=2)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cservice", $p(result,"^",9))
	i ($p(result,"^",9)'="")&&($p(result,"^",8)=3)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov", $p(result,"^",9))
	i ($p(result,"^",9)'="")&&($p(result,"^",8)=4)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", $p(result,"^",9))
	s resultex=resultex_"^"	
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("location", $p(result,"^",10))
	s resultex=resultex_"^"	
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")   // Modefied by zc 2022-4-8
	s resultex=resultex_"^"	
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"time")
	s resultex=resultex_"^"	
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("location", $p(result,"^",13))
	s resultex=resultex_"^"	
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$Case($p(result,"^",14),1:"科室",2:"服务商",3:"供应商",4:"生产厂商",:"")
	s resultex=resultex_"^"	
	i ($p(result,"^",15)'="")&&($p(result,"^",14)=1)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p(result,"^",15))
	i ($p(result,"^",15)'="")&&($p(result,"^",14)=2)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cservice", $p(result,"^",15))
	i ($p(result,"^",15)'="")&&($p(result,"^",14)=3)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov", $p(result,"^",15))
	i ($p(result,"^",15)'="")&&($p(result,"^",14)=4)  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", $p(result,"^",15))
	s resultex=resultex_"^"	
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$zd($p(result,"^",16),3)
	s resultex=resultex_"^"	
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"time")
	s resultex=resultex_"^"	
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s resultex=resultex_"^"	
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s resultex=resultex_"^"	
	// Modefied by zc 2022-4-8 begin
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",20))
	// Modefied by zc 2022-4-8 end
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("31",rowid)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	s MoveReason=##class(web.DHCEQMoveNew).GetMoveReasonBySource($p(result,"^",4),$p(result,"^",5),$p(result,"^",6))
	q result_resultex_"^"_AppInfo_"^"_MoveReason
}

/// w ##Class(web.DHCEQMoveNew).GetEquipInfo(31,18)
ClassMethod GetEquipInfo(isDel, rowid)
{
	i (isDel="")||(rowid="") q ""
	s (MoveID,Info,Model,Unit,EquipID,EquipName,FileNo,StoreLocID,StoreLoc,LocationID,Location,No,SourceDesc)=""
	
	i isDel="65" d
	.s MoveID=rowid
	.s EquipID=$p($g(^DHCEQMove(MoveID)),"^",3)
	.s SourceID=$p($g(^DHCEQMove(MoveID)),"^",5)
	.s SourceType=$p($g(^DHCEQMove(MoveID)),"^",4)
	.i SourceType="31" d
	..s No=$p($g(^DHCEQMMaintRequest(SourceID)),"^",1)
	..s SourceDesc="维修"
	.else  if SourceType="64" d
	..s No=$p($g(^DHCEQRent(SourceID)),"^",1)
	..s SourceDesc="租赁"
	.s StoreLocID=$p($g(^DHCEQMove(MoveID)),"^",15)
	.i StoreLocID'="" s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", StoreLocID)
	.s LocationID=$p($g(^DHCEQMove(MoveID)),"^",13)
	.i LocationID'="" s Location=##Class(web.DHCEQCommon).GetTrakNameByID("location", LocationID)
	.i EquipID'="" d
	..s EquipName=$p($g(^DHCEQEquip(EquipID)),"^",1)
	..s FileNo=$p($g(^DHCEQEquip(EquipID)),"^",85)
	..s EquipName=EquipName_"("_FileNo_")"
	..s Model = $p($g(^DHCEQEquip(EquipID)),"^",3)
	..i Model'="" s Model = $p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	..s Unit = $p($g(^DHCEQEquip(EquipID)),"^",5)
	..i Unit'="" s Unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
	.s Info=EquipID_"^"_EquipName_"^"_FileNo_"^"_Model_"^"_Unit_"^"_StoreLocID_"^"_StoreLoc_"^"_LocationID_"^"_Location_"^"_No_"^"_SourceDesc
	else  if isDel="31" d
	.s EquipID=$p($g(^DHCEQMExObj($p($g(^DHCEQMMaintRequest(rowid)),"^",5))),"^",5)
	.s No=$p($g(^DHCEQMMaintRequest(rowid)),"^",1)
	.s SourceDesc="维修"
	.d SetEquipInfo
	e  i isDel="64" d
	.s EquipID=$p($g(^DHCEQRent(rowid)),"^",9)
	.s No=$p($g(^DHCEQRent(rowid)),"^",1)
	.s SourceDesc="租赁"
	.d SetEquipInfo
	
	q Info
	
SetEquipInfo 
	s EquipName=$p($g(^DHCEQEquip(EquipID)),"^",1)
	s FileNo=$p($g(^DHCEQEquip(EquipID)),"^",85)
	s EquipName=EquipName_"("_FileNo_")"
	s Model = $p($g(^DHCEQEquip(EquipID)),"^",3)
	i Model'="" s Model = $p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	s Unit = $p($g(^DHCEQEquip(EquipID)),"^",5)
	i Unit'="" s Unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
	s StoreLocID=$p($g(^DHCEQEquip(EquipID)),"^",19)
	s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", StoreLocID)
	s LocationID=$p($g(^DHCEQEquip(EquipID)),"^",72)
	s Location=##Class(web.DHCEQCommon).GetTrakNameByID("location", LocationID)
	s Info=EquipID_"^"_EquipName_"^"_FileNo_"^"_Model_"^"_Unit_"^"_StoreLocID_"^"_StoreLoc_"^"_LocationID_"^"_Location_"^"_No_"^"_SourceDesc
	quit
}

/// 获取全部配送人员信息及本转移单的配送次数
/// d ##class(%ResultSet).RunQuery("web.DHCEQMoveNew","MoveUser","1")
Query MoveUser(MoveDR) As %Query(ROWSPEC = "TUserDR:%String,TUser:%String,TFlag:%String") [ SqlProc ]
{
}

ClassMethod MoveUserExecute(ByRef qHandle As %Binary, MoveDR) As %Status
{
 	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	i MoveDR="" Quit $$$OK
 	
	s EmployeeDR=0
	f  s EmployeeDR=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EmployeeType","4",EmployeeDR))  q:EmployeeDR=""  d
	.d ResetVariablesMoveUser
	.s TInvalidFlag = $p($g(^DHCEQCCode("DHCEQCTypeEmployee",EmployeeDR)),"^",4)	//使用标识
	.q:TInvalidFlag="Y"
	.s TUserDR = $p($g(^DHCEQCCode("DHCEQCTypeEmployee",EmployeeDR)),"^",2)	//姓名
	.i TUserDR'="" s TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
	.s TFlag=$o(^DHCEQMoveUsers(0,"Move",MoveDR,TUserDR,0))
	.i TFlag'="" s TFlag=1
	.s TFlag=+TFlag
	.d OutputRowMoveUser
	Quit $$$OK
	
OutputRowMoveUser
	s Data=$lb(TUserDR,TUser,TFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMoveUser
	s (TInvalidFlag,TUserDR,TUser,TFlag)=""
	quit
}

ClassMethod MoveUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoveUserExecute ]
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

ClassMethod MoveUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoveUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQMoveNew).SaveMoveUser("1","148","")
ClassMethod SaveMoveUser(MoveDR, UserDR, Remark)
{
	k PLISTMX
	s PLISTMX(2)=MoveDR				
	s PLISTMX(3)=UserDR	
	s PLISTMX(4)=Remark 
	s rowid=""
	&SQL(select MU_RowID into :rowid from sqluser.DHC_EQMoveUsers where MU_MoveDR=:MoveDR and MU_UserDR=:UserDR)
	if (rowid="")
	{
		&SQL(Insert Into SQLUSER.DHC_EQMoveUsers Values :PLISTMX())
	}
	else
	{
		&SQL(delete from sqluser.DHC_EQMoveUsers where MU_RowID=:rowid)
	}
	s ID=$G(%ROWID)
	
	q ID
}

/// add by zx 2017-05-18 获取配送原由
/// w ##class(web.DHCEQMoveNew).GetMoveReasonBySource("64","320","2")
ClassMethod GetMoveReasonBySource(vSourceType, vSourceID, vEventType)
{
	i (vSourceType="")||(vSourceID="") q ""
	
	n Reason,AcceptUser,FaultCase,FaultCaseReason,RequestLoc
	s (Reason,AcceptUser,FaultCase,FaultCaseReason,RequestLoc)=""
	
	i vSourceType="31"
	{
		s AcceptUser=$p($g(^DHCEQMMaintRequest(vSourceID)),"^",26)
		i AcceptUser'="" s AcceptUser=##class(web.DHCEQCommon).GetTrakNameByID("user",AcceptUser)
		s RequestLoc=$p($g(^DHCEQMMaintRequest(vSourceID)),"^",6)
		i RequestLoc'="" s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", RequestLoc)
		s FaultCase=$p($g(^DHCEQMMaintRequest(vSourceID)),"^",10)
		i FaultCase'="" s FaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FaultCase)),"^",2)
		s FaultCaseReason=$p($g(^DHCEQMMaintRequest(vSourceID)),"^",11)
		i FaultCase'="" d
		.i FaultCaseReason'="" d
		..s FaultCase=FaultCase_"("_FaultCaseReason_")"
		e  d
		.s FaultCase=FaultCaseReason 
		
		i vEventType="1" s Reason="由于设备"_FaultCase_",需要送给维修工程师"_AcceptUser_"进行维修,正在配送中..."
		i vEventType="2" s Reason="由于设备"_FaultCase_",维修工程师"_AcceptUser_"维修完成,正在送回"_RequestLoc_"..."
	}
	elseif vSourceType="64"
	{
		s RequestLoc=$p($g(^DHCEQRent(vSourceID)),"^",2)
		i RequestLoc'="" s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", RequestLoc)
		
		i vEventType="1" s Reason=RequestLoc_"需要租借设备使用,正在配送中..."
		i vEventType="2" s Reason=RequestLoc_"设备租借使用完成,正送回租赁中心..."
	}
	
	q Reason
}

/// Mozy0201	2017-10-24
/// 配送业务单查询及报表
/// d ##class(%ResultSet).RunQuery("web.DHCEQMoveNew","GetMoveDetail",82,2620,"","","",2)
/// d ##class(%ResultSet).RunQuery("web.DHCEQMoveNew","GetMoveDetail",82,2620,"","","",2,"","","","","","","2017-11-03",3831)
Query GetMoveDetail(GROUPID As %String = "", No As %String = "", SourceType As %String = "", EventType As %String = "", Status As %String = "", FileNo As %String = "", Name As %String = "", EQNo As %String = "", FromDept As %String = "", ToDept As %String = "", SendStartDate As %String = "", SendEndDate As %String = "", SendUser As %String = "", AcceptStartDate As %String = "", AcceptEndDate As %String = "", AcceptUser As %String = "") As %Query(ROWSPEC = "TRow:%String,TMoveDR:%String,TNo:%String,TSourceType:%String,TEventType:%String,TMoveReason:%String,TEQNo:%String,TEQFileNo:%String,TEQName:%String,TFromDeptType:%String,TFromDept:%String,TFromLocation:%String,TStartDate:%String,TToLocation:%String,TToDeptType:%String,TToDept:%String,TEndDate:%String,TSendUser:%String,TAcceptUser:%String,TRemark:%String,TStatus:%String,TQuantityNum:%String,TUsedHours:%String,TPeople:%String") [ SqlProc ]
{
}

ClassMethod GetMoveDetailExecute(ByRef qHandle As %Binary, GROUPID As %String = "", No As %String = "", SourceType As %String = "", EventType As %String = "", Status As %String = "", FileNo As %String = "", Name As %String = "", EQNo As %String = "", FromDept As %String = "", ToDept As %String = "", SendStartDate As %String = "", SendEndDate As %String = "", SendUser As %String = "", AcceptStartDate As %String = "", AcceptEndDate As %String = "", AcceptUser As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("GetMoveDetail")=GROUPID_","_No_","_SourceType_","_EventType_","_Status_","_FileNo_","_Name_","_EQNo_","_FromDept_","_ToDept_","_SendStartDate_","_SendEndDate_","_SendUser_","_AcceptStartDate_","_AcceptEndDate_","_AcceptUser
	
	If SendStartDate'="" Set SendStartDate=$ZDATEH(SendStartDate,3)
	If SendEndDate'="" Set SendEndDate=$ZDATEH(SendEndDate,3)
	If AcceptStartDate'="" Set AcceptStartDate=$ZDATEH(AcceptStartDate,3)
	If AcceptEndDate'="" Set AcceptEndDate=$ZDATEH(AcceptEndDate,3)
 	;i StartDate="" s StartDate=0
 	;i EndDate="" s EndDate=+$H
 	s Name=$ZCONVERT(Name,"U")
 	
	s Total=0
	s TotalFee=0
	s index=2
	Set TRow=0
	
	i SourceType>0
	{
		;Modify by zc 2020-05-20 ZC0073 begin
		s SourceID=0
		f  s SourceID=$o(^DHCEQMove(0,"Source",SourceType,SourceID)) Quit:SourceID=""  Do
		.s MoveDR=0
		.f  s MoveDR=$o(^DHCEQMove(0,"Source",SourceType,SourceID,MoveDR)) Quit:MoveDR=""  Do
		..d GetOneGetMoveDetail
		;Modify by zc 2020-05-20 ZC0073 begin
	}
	else
	{
		s MoveDR=0
		f  s MoveDR=$o(^DHCEQMove(MoveDR)) Quit:MoveDR=""  Do
		.s SourceType=$p($g(^DHCEQMove(MoveDR)),"^",4)
		.s SourceID=$p($g(^DHCEQMove(MoveDR)),"^",5)
		.d GetOneGetMoveDetail
	}
	Quit $$$OK
GetOneGetMoveDetail
	d ResetVariablesGetMoveDetail
	s TMoveDR=MoveDR
	s TInvalidFlag=$p($g(^DHCEQMove(TMoveDR)),"^",31)
	q:(TInvalidFlag="Y")
	
	s TNo = $p($g(^DHCEQMove(TMoveDR)),"^",1)
	q:(No'="")&&(TNo'[No)
	s TObjType=$p($g(^DHCEQMove(TMoveDR)),"^",2)
	s TObjID=$p($g(^DHCEQMove(TMoveDR)),"^",3)
	s TempFlag=0
	i (TObjType=1)&&(TObjID'="") d
	.s TempFlag=##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(TObjID)),"^",63),GROUPID)
	.s TEQName=$p($g(^DHCEQEquip(TObjID)),"^",1)
	.s TEQNo=$p($g(^DHCEQEquip(TObjID)),"^",71)
	.s TEQFileNo=$p($g(^DHCEQEquip(TObjID)),"^",85)
	q:TempFlag'=0
	q:(FileNo'="")&&(TEQFileNo'[FileNo)
	q:(Name'="")&&($ZCONVERT(TEQName,"U")'[Name)
	q:(EQNo'="")&&(TEQNo'[EQNo)
	s TSourceType=$Case(SourceType,31:"维修",64:"租赁",22:"转移单",:"")
	q:(EventType>0)&&(EventType'=$p($g(^DHCEQMove(TMoveDR)),"^",6))
	s TEventType=$Case($p($g(^DHCEQMove(TMoveDR)),"^",6),1:"送出", 2:"返还",:"")
	s TMoveReason=$p($g(^DHCEQMove(TMoveDR)),"^",7)
	s TFromDeptType=$Case($p($g(^DHCEQMove(TMoveDR)),"^",8),1:"科室", 2:"服务商", 3:"供应商", 4:"生产厂商",:"")
	i TFromDeptType="科室" s TFromDept=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQMove(TMoveDR)),"^",9))
	q:(TFromDeptType="科室")&&(FromDept'="")&&(FromDept'=$p($g(^DHCEQMove(TMoveDR)),"^",9))
	s TFromLocation=##Class(web.DHCEQCommon).GetTrakNameByID("location", $p($g(^DHCEQMove(TMoveDR)),"^",10))
	q:(""'=SendStartDate)&&(+$p($g(^DHCEQMove(TMoveDR)),"^",11)<SendStartDate)
	q:(""'=SendEndDate)&&(+$p($g(^DHCEQMove(TMoveDR)),"^",11)>SendEndDate)
	s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMove(TMoveDR)),"^",11),"date")
	s TToLocation=##Class(web.DHCEQCommon).GetTrakNameByID("location", $p($g(^DHCEQMove(TMoveDR)),"^",13))
	s TToDeptType=$Case($p($g(^DHCEQMove(TMoveDR)),"^",14),1:"科室", 2:"服务商", 3:"供应商", 4:"生产厂商",:"")
	i TToDeptType="科室" s TToDept=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQMove(TMoveDR)),"^",15))
	q:(TToDeptType="科室")&&(ToDept'="")&&(ToDept'=$p($g(^DHCEQMove(TMoveDR)),"^",15))
	s TEndDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMove(TMoveDR)),"^",16),"date")
	q:(""'=AcceptStartDate)&&(+$p($g(^DHCEQMove(TMoveDR)),"^",16)<AcceptStartDate)
	q:(""'=AcceptEndDate)&&(+$p($g(^DHCEQMove(TMoveDR)),"^",16)>AcceptEndDate)
	q:(SendUser'="")&&(SendUser'=$p($g(^DHCEQMove(TMoveDR)),"^",18))
	q:(AcceptUser'="")&&(AcceptUser'=$p($g(^DHCEQMove(TMoveDR)),"^",19))
	s TSendUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQMove(TMoveDR)),"^",18))
	s TAcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQMove(TMoveDR)),"^",19))
	s TRemark=$p($g(^DHCEQMove(TMoveDR)),"^",29)
	s TStatus=$p($g(^DHCEQMove(TMoveDR)),"^",30)
	q:(Status'=-1)&(Status'="")&(Status'=TStatus)
	
	Set TStatus=##class(web.DHCEQInStock).GetInStockStatus(TStatus)
	Set TUsedHours=##Class(web.DHCEQRent).GetworkNumByMonth($p($g(^DHCEQMove(TMoveDR)),"^",11),$p($g(^DHCEQMove(TMoveDR)),"^",12),$p($g(^DHCEQMove(TMoveDR)),"^",16),$p($g(^DHCEQMove(TMoveDR)),"^",17))
	If TUsedHours="" Do
	.Set TUsedHours=0
	Else  Do
	.Set TUsedHours=$p($p(TUsedHours,":",2),";",1)+$p($p(TUsedHours,":",2),";",2)
	
	s UserID=0
	f  s UserID=$o(^DHCEQMoveUsers(0,"Move",TMoveDR,UserID)) Quit:UserID=""  Do
	.s TPeople=TPeople+1
	
	d OutputRowGetMoveDetail
	quit
OutputRowGetMoveDetail
	Set TRow=TRow+1
	Set Data=$lb(TRow,TMoveDR,TNo,TSourceType,TEventType,TMoveReason,TEQNo,TEQFileNo,TEQName,TFromDeptType,TFromDept,TFromLocation,TStartDate,TToLocation,TToDeptType,TToDept,TEndDate,TSendUser,TAcceptUser,TRemark,TStatus,TQuantityNum,TUsedHours,TPeople)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMoveDetail
	Set (TMoveDR,TNo,TSourceType,TEventType,TMoveReason,TEQNo,TEQFileNo,TEQName,TFromDeptType,TFromDept,TFromLocation,TStartDate,TToLocation,TToDeptType,TToDept,TEndDate,TSendUser,TAcceptUser,TRemark,TStatus)=""
	Set (TQuantityNum,TPeople)=1
	Set TUsedHours=0
	Quit
}

ClassMethod GetMoveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoveDetailExecute ]
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

ClassMethod GetMoveDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoveDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创建: add by zx 2017-09-19
/// 描述: 保存配送附件信息
/// 入参: MRowID:配送单ID, val:附件信息
/// w ##Class(web.DHCEQMoveNew).SaveAffixList("25", "^1^惠普^2^4^^^,^2^三星^2^3^^^,^3^欧普^2^3^^^^")
ClassMethod SaveAffixList(MRowID, val)
{
    new Length,MARowID,Flag,i,valList
    k PLISTMX
    i val="" q 0
    i MRowID="" q -1
    
    s PLISTMX(2)=MRowID     ;MAMoveDR
    s Flag=0
    s Length=$l(val,",")
    for i=1:1:Length
    {
        q:Flag'=0
        s valList=  $p(val,",",i)
        s MARowID=$p(valList,"^",1)         ;MARowID
        s PLISTMX(3)=$p(valList,"^",2)      ;MAAffixDR
        s PLISTMX(4)=$p(valList,"^",3)      ;MAModel
        s PLISTMX(5)=$p(valList,"^",4)      ;MAQuantity
        s PLISTMX(6)=$p(valList,"^",5)      ;MAStatus
        s PLISTMX(7)=$p(valList,"^",6)      ;MARemark
        s PLISTMX(8)=$p(valList,"^",7)      ;MALeaveFactoryNo 增加字段
        s PLISTMX(9)=$p(valList,"^",8)      ;MAHold1
        s PLISTMX(10)=$p(valList,"^",9)     ;MAHold2
        s PLISTMX(11)=$p(valList,"^",10)     ;MAHold3
        if (MARowID="")
        {
            &SQL(Insert Into SQLUSER.DHC_EQMoveAffix Values :PLISTMX())
        }
        else
        {
            &SQL(update sqluser.DHC_EQMoveAffix values :PLISTMX() where MA_RowID=:MARowID)
        }
        i SQLCODE
        {
            s Flag=SQLCODE
        }
        q:Flag'=0
    }
    
    q Flag
}

/// 创建: add by zx 2017-09-19
/// 描述: 删除配送附件信息
/// 入参: DelRowIDs:附件信息ID串
ClassMethod DeleteAffixList(DelRowIDs)
{
    new Length,ISLRowID,Flag,i
    
    i DelRowIDs="" q 0
    
    s Flag=0
    s Length=$l(DelRowIDs,",")
    for i=1:1:Length
    {
        q:Flag'=0
        s MARowID=$p(DelRowIDs,",",i)
        if (MARowID>0)
        {
            &SQL(delete from  sqluser.DHC_EQMoveAffix where MA_RowID=:MARowID)
            i SQLCODE s Flag=SQLCODE
            q:Flag'=0
        }
    }
    q Flag
}

/// add by czf 20170921
/// 配送附件信息
/// eventype:1：送出,2：返还
/// d ##class(%ResultSet).RunQuery("web.DHCEQMoveNew","GetMoveAffix",64,27,1)
Query GetMoveAffix(SourceType, SourceID, eventype As %String = "") As %Query(ROWSPEC = "TRowID:%String,TMoveID:%String,TMoveNo:%String,TEventypedr:%String,TEventype:%String,TSourceType:%String,TSourceID:%String,TMAffixID:%String,TMAModel:%String,TMAQuantity:%String,TMARemark:%String,TMAHold1:%String,TMAHold2:%String,TMAStatus:%String,TACode:%String,TAffix:%String,TARemark:%String")
{
}

ClassMethod GetMoveAffixExecute(ByRef qHandle As %Binary, SourceType, SourceID, eventype As %String = "") As %Status
{
    new repid, index
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set index=1
    i (SourceType="")||(SourceID="") Quit $$$OK
    
    s TMoveID=""
	;Modify by zc 2020-05-20 ZC0073 
    f  s TMoveID=$o(^DHCEQMove(0,"Source",SourceType,SourceID,TMoveID)) q:TMoveID=""  d
    .s TRowID=""
    .f  s TRowID=$o(^DHCEQMoveAffix(0,"Move",TMoveID,TRowID)) q:TRowID=""  d
    ..d ResetVariablesGetMoveAffix
    ..s TMoveNo=$p($g(^DHCEQMove(TMoveID)),"^",1)
    ..s TEventypedr=$p($g(^DHCEQMove(TMoveID)),"^",6)
    ..q:(eventype'="")&&(eventype'=TEventypedr)
    ..s TEventype=$Case(TEventypedr,1:"送出",2:"返还",:"")
    ..s TMInvalidFlag=$p($g(^DHCEQMove(TMoveID)),"^",31)
    ..q:TMInvalidFlag="Y"
    ..s TSourceType=$Case(SourceType,1:"维修",2:"租赁",3:"转移单",:"")
    ..s TSourceID=SourceID
    ..s TMAffixID=$p($g(^DHCEQMoveAffix(TRowID)),"^",2)
    ..s TMAModel=$p($g(^DHCEQMoveAffix(TRowID)),"^",3)
    ..s TMAQuantity=$p($g(^DHCEQMoveAffix(TRowID)),"^",4)
    ..s TMARemark=$p($g(^DHCEQMoveAffix(TRowID)),"^",5)
    ..s TMAHold1=$p($g(^DHCEQMoveAffix(TRowID)),"^",6)
    ..s TMAHold2=$p($g(^DHCEQMoveAffix(TRowID)),"^",7)
    ..s TMAHold3=$p($g(^DHCEQMoveAffix(TRowID)),"^",8)
    ..s TMAStatus=$p($g(^DHCEQMoveAffix(TRowID)),"^",9)
    ..s TACode=$p($g(^DHCEQCCode("DHCEQCAffix",TMAffixID)),"^",1)
    ..s TAffix=$p($g(^DHCEQCCode("DHCEQCAffix",TMAffixID)),"^",2)
    ..s TARemark=$p($g(^DHCEQCCode("DHCEQCAffix",TMAffixID)),"^",3)
    ..d OutputRowGetMoveAffix
    Quit $$$OK

ResetVariablesGetMoveAffix
    Set (TMoveNo,TEventypedr,TEventype,TMInvalidFlag,TSourceType,TSourceID,TMAffixID,TMAModel,TMAQuantity,TMARemark,TMAHold1,TMAHold2,TMAStatus,TACode,TAffix,TARemark)=""
    Quit    
OutputRowGetMoveAffix
    Set Data=$lb(TRowID,TMoveID,TMoveNo,TEventypedr,TEventype,TSourceType,TSourceID,TMAffixID,TMAModel,TMAQuantity,TMARemark,TMAHold1,TMAHold2,TMAStatus,TACode,TAffix,TARemark)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetMoveAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoveAffixExecute ]
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

ClassMethod GetMoveAffixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoveAffixExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by zx 2017-04-18
/// 根据判断录入数量是否超过设备标配数量
/// w ##Class(web.DHCEQMoveNew).CheckMoveAffixNum(686,1,2)
ClassMethod CheckMoveAffixNum(MoveID, Model, ItemAffixDR, Quantity, Type)
{
	i +Quantity=0 q 0
	i ItemAffixDR="" q 0
    s ReturnFlag="0"
    if (Type=1)
    {
    	s rowid=0
    	f  s rowid=$o(^DHCEQCCode("DHCEQCItemAffix",rowid))  quit:(rowid="")||(ReturnFlag'="0")  d
    	.q:$p($g(^DHCEQCCode("DHCEQCItemAffix",rowid)),"^",2)'=ItemAffixDR
    	.i ((+$p($g(^DHCEQCCode("DHCEQCItemAffix",rowid)),"^",4))-(+Quantity))<0 d
    	..s ReturnFlag=1
    }
    else
    {
	    i MoveID="" q 0
	    s rowid=0
    	f  s rowid=$o(^DHCEQMoveAffix(0,"Move",MoveID,rowid)) quit:(rowid="")||(ReturnFlag'="0")  d
    	.q:$p($g(^DHCEQMoveAffix(rowid)),"^",2)'=ItemAffixDR
    	.q:$p($g(^DHCEQMoveAffix(rowid)),"^",3)'=Model
    	.i ((+$p($g(^DHCEQMoveAffix(rowid)),"^",4))-(+Quantity))<0 d
    	..s ReturnFlag=1
	}
    q ReturnFlag
}

/// Modify by zc 2020-05-20 ZC0073 根据租赁单据获取对应配送单ID
/// w ##Class(web.DHCEQMoveNew).GetMoveIDBySourceType(64,4)
ClassMethod GetMoveIDBySourceType(SourceType, SourceID, EventType)
{
	s MaxMoveDR=""
	i (SourceType="")||(SourceID="") q ""
	s MoveRowID=0
    f  s MoveRowID=$o(^DHCEQMove(0,"Source",SourceType,SourceID,MoveRowID)) q:MoveRowID=""  d
    .q:$p($g(^DHCEQMove(MoveRowID)),"^",31)="Y"
    .q:$p($g(^DHCEQMove(MoveRowID)),"^",6)'=EventType
    .i MoveRowID>(+MaxMoveDR)  d
    ..s MaxMoveDR=MoveRowID
   
    q MaxMoveDR
}

/// Modify by zc 2020-05-20 ZC0073 根据配送单ID获取对应配送人员信息
/// w ##Class(web.DHCEQMoveNew).GetMoveUserInfo(3)
ClassMethod GetMoveUserInfo(MoveDR)
{
	i MoveDR="" q "^"
	s vFlag=##class(web.DHCEQCommon).GetSysInfo("511001")
	s Info=""
	s MURowID=0
    f  s MURowID=$o(^DHCEQMoveUsers(0,"Move",MoveDR,MURowID)) q:MURowID=""  d
    .i vFlag=0 d
    ..s Info=$p($g(^DHCEQMoveUsers(MURowID)),"^",2)_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQMoveUsers(MURowID)),"^",2))
    .e  d
    ..s Info="^"_$p($g(^DHCEQMoveUsers(MURowID)),"^",2)
    q Info
}

/// Modefied by zc 2022-4-8
/// w ##Class(web.DHCEQMoveNew).ReturnJsonFromDeptType()
ClassMethod ReturnJsonFromDeptType()
{
	//s ReturnInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetNewJSONObj()  // modify by jyp 2019-08-26
	s FromDeptTypeStr=##class(web.DHCEQCommon).GetSysInfo("503014")
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ReturnData="["
	s len=$l(FromDeptTypeStr,",")
	for i=1:1:len d
	.s rowid=$p(FromDeptTypeStr,",",i)
	.s Name = $Case(rowid,1:"科室",2:"服务商",3:"供应商",4:"生产厂商",5:"对外部门",:"未定义")
	.if ReturnData'="["  d
	..s ReturnData=ReturnData_","
	.s ReturnData=ReturnData_"{text:'"_Name_"',id:'"_rowid_"'}"
	s ReturnData=ReturnData_"]"
	d ReturnInfo.%Set("Data",ReturnData)
	q ReturnInfo.%ToJSON()
}

/// Modefied by zc 2022-4-8
/// d ##class(%ResultSet).RunQuery("web.DHCEQMoveNew","GetFromDeptType")
Query GetFromDeptType() As %Query(ROWSPEC = "TRowID:%String,TName:%String")
{
}

ClassMethod GetFromDeptTypeExecute(ByRef qHandle As %Binary) As %Status
{
    new repid, index
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set index=1
   
    s FromDeptTypeStr=##class(web.DHCEQCommon).GetSysInfo("503014")
	s len=$l(FromDeptTypeStr,",")
	for i=1:1:len d
    .d ResetVariablesGetFromDeptType
	.s TRowID=$p(FromDeptTypeStr,",",i)
	.s TName = $Case(TRowID,1:"科室",2:"服务商",3:"供应商",4:"生产厂商",5:"对外部门",:"未定义")
    .d OutputRowGetFromDeptType
    Quit $$$OK

ResetVariablesGetFromDeptType
    Set (TRowID,TName)=""
    Quit    
OutputRowGetFromDeptType
    Set Data=$lb(TRowID,TName)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetFromDeptTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFromDeptTypeExecute ]
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

ClassMethod GetFromDeptTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFromDeptTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
