/// Modified By HZY 2011-08-29	HZY0006
/// 修改函数：GetMaintExecute
/// 描述：增加‘无效标志’的判断。
Class web.DHCEQMaintNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetMaint(BussType, EquipDR, MaintLocDR, MaintUserDR, MaintTypeDR, StartDate, EndDate, Status, QXType As %String = "", CurUser, TypeCode) As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TEquipDR:%String,TModelDR:%String,TModel:%String,TMaintPlanDR:%String,TMaintPlan:%String,TMaintTypeDR:%String,TMaintType:%String,TMaintDate:%String,TMaintLocDR:%String,TMaintLoc:%String,TMaintUserDR:%String,TMaintUser:%String,TMaintModeDR:%String,TMaintMode:%String,TTotalFee:%String,TNormalFlag:%String,TManageLocDR:%String,TManageLoc:%String,TUseLocDR:%String,TUseLoc:%String,TStatus:%String,TOtherFee:%String,TRemark:%String,TEquipNo:%String,TRow:%String")
{
}

// Modified By HZY 2011-08-29	HZY0006

// 描述：增加‘无效标志’的判断。

ClassMethod GetMaintExecute(ByRef qHandle As %Binary, BussType, EquipDR, MaintLocDR, MaintUserDR, MaintTypeDR, StartDate, EndDate, Status, QXType As %String = "", CurUser, TypeCode) As %Status
{
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1  //add by zx 2015-09-17 
	d BuildDataGetMaint
	Quit $$$OK
BuildDataGetMaint
	set EquipID=0
	f  s EquipID=$o(^DHCEQMaint(0,"Equip",BussType,EquipID))  quit:EquipID=""  d
	.q:(EquipDR'="")&&(EquipDR'=EquipID)
	.s TEquipDR = EquipID
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TModel=""    ///modify by lmm 2017-03-26 352436
	.s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModelDR '= "" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71) //add by zx 2015-09-17
	.s rowid=0
	.f  s rowid=$o(^DHCEQMaint(0,"Equip",BussType,EquipID,rowid))  quit:rowid=""  d
	..;Add By QW20160229 筛选个人单据
	..i CurUser'=""  d
	...s CurUserID="^"_CurUser_"^"
	...s useid="^"_$p($g(^DHCEQMaint(rowid)),"^",7)_"^"_$Piece($Get(^DHCEQMaint(rowid)),"^",15)_"^"_$Piece($Get(^DHCEQMaint(rowid)),"^",18)_"^"_$Piece($Get(^DHCEQMaint(rowid)),"^",21)_"^"_$Piece($Get(^DHCEQMaint(rowid)),"^",40)_"^" ;Add By QW20160229 筛选个人单据
	..q:(CurUser'="")&&(useid'[CurUserID) 
	..;End By QW20160229 筛选个人单据
	..d ResetVariablesGetMaint
	..s TRowID = rowid
	..s TMaintInvalidFlag = $p($g(^DHCEQMaint(rowid)),"^",39)	//无效标志
	..q:(TMaintInvalidFlag = "Y")								//2011-08-29 HZY0006 .判断是否有效.
	..s TMaintPlanDR = $p($g(^DHCEQMaint(rowid)),"^",3)
	..i TMaintPlanDR '="" s TMaintPlan = $p($g(^DHCEQMaintPlan(TMaintPlanDR)),"^",1)
	..s TMaintTypeDR = $p($g(^DHCEQMaint(rowid)),"^",4)
	..q:(TMaintTypeDR '= MaintTypeDR)&(MaintTypeDR '= "")
	..q:(TMaintTypeDR '="")&&(TypeCode'="")&&(TypeCode'=$p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",1)) ;Add By QW20160229
	..i TMaintTypeDR '="" s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	..s TMaintDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",5),"date")
	..q:($p($g(^DHCEQMaint(rowid)),"^",5)<StartDate)!($p($g(^DHCEQMaint(rowid)),"^",5)>EndDate)
	..s TMaintLocDR = $p($g(^DHCEQMaint(rowid)),"^",6)
	..q:(TMaintLocDR '= MaintLocDR)&(MaintLocDR '= "")
	..q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR)))
	..i TMaintLocDR '=""  d
	...s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	..s TMaintUserDR = $p($g(^DHCEQMaint(rowid)),"^",7)
	..q:(TMaintUserDR '= MaintUserDR)&(MaintUserDR '= "")
	..i TMaintUserDR '=""  d
	...s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMaintUserDR)
	..s TMaintModeDR = $p($g(^DHCEQMaint(rowid)),"^",8)
	..i TMaintModeDR '=""  d
	...s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	..s TTotalFee = ##Class(web.DHCEQCommon).FormatNumber(##Class(web.DHCEQMaintPlanNew).GetOtherFee(rowid),"")
	..s TNormalFlag =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",10),"bool")
	..s TManageLocDR = $p($g(^DHCEQMaint(rowid)),"^",11)
	..i TManageLocDR '="" s TManageLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TManageLocDR)
	..s TUseLocDR = $p($g(^DHCEQMaint(rowid)),"^",12)
	..i TUseLocDR '="" s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	..s TStatus = $p($g(^DHCEQMaint(rowid)),"^",13)
	..q:(Status'="")&&(Status'=TStatus)
	..s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核")
	..s TRemark = $p($g(^DHCEQMaint(rowid)),"^",14)
	..s TOtherFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMaint(rowid)),"^",24),"")
	..d OutputRowGetMaint
	quit
OutputRowGetMaint
	s Data=$lb(TRowID,TEquip,TEquipDR,TModelDR,TModel,TMaintPlanDR,TMaintPlan,TMaintTypeDR,TMaintType,TMaintDate,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TTotalFee,TNormalFlag,TManageLocDR,TManageLoc,TUseLocDR,TUseLoc,TStatus,TOtherFee,TRemark,TEquipNo,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1  //add by zx 2015-09-17 
	quit
ResetVariablesGetMaint
	s (TRowID,TMaintPlanDR,TMaintPlan,TMaintTypeDR,TMaintType,TMaintDate,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TTotalFee,TNormalFlag,TManageLocDR,TManageLoc,TUseLocDR,TUseLoc,TStatus,TOtherFee,TRemark)=""
	quit
}

ClassMethod GetMaintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintExecute ]
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

ClassMethod GetMaintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMaintEquipByPlanID(MaintPlanDR, Equip, QXType) As %Query(ROWSPEC = "TName:%String,Hidden:%String,TNo:%String,TModel:%String,TModelDR:%String")
{
}

ClassMethod GetMaintEquipByPlanIDExecute(ByRef qHandle As %Binary, MaintPlanDR, Equip, QXType) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	set Job=$j
	s index=1
	s Type = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",2)
	s SourceType = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",3)
	s SourceID = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",4)
	s MaintLocDR=$p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",14)
	if SourceType=1 d  //"1":"设备分类"
	.s EquipCatStr=##Class(web.DHCEQCEquipeCat).GetChildIDsByCatID(sourceid)
	.s Len=$l(EquipCatStr,"^")
	.s i=0
	.f i=1:1:Len  d
	..s ChildsSourceID=$p(EquipCatStr,"^",i)
	..s EquipID=0
	..f  set EquipID=$order(^DHCEQEquip(0,"StoreLocEquipCat",MaintLocDR,SourceID,EquipID))  quit:EquipID=""  d
	...d OutputRowGetMaintEquipByPlanID
	else  if SourceType=2 d  //"2":"设备项"
	.s EquipID=0
	.f  s EquipID=$o(^DHCEQEquip(0,"StoreLocItem",MaintLocDR,SourceID,EquipID))  quit:EquipID=""  d
	..d OutputRowGetMaintEquipByPlanID
	else  if SourceType=3 d  //"3":"设备"
	.s EquipID=SourceID
	.d OutputRowGetMaintEquipByPlanID
	Quit $$$OK
OutputRowGetMaintEquipByPlanID
	Quit:$p($g(^DHCEQEquip(EquipID)),"^",38)>"2"
	s TRowID=EquipID
	s TName =$p($g(^DHCEQEquip(EquipID)),"^",1)
	q:(Equip'="")&&((TName'[Equip)&&(No'[Equip))
	s No =$p($g(^DHCEQEquip(EquipID)),"^",71)
	s ModelDR =$p($g(^DHCEQEquip(EquipID)),"^",3)
	i ModelDR'="" s Model =##Class(web.DHCEQCommon).GetTrakNameByID("model",ModelDR)
	s Data=$lb(TName,TRowID,TNo,TModel,TModelDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintEquipByPlanID
	Set (TName,TRowID,TNo,TModel,TModelDR)=""
	quit
}

ClassMethod GetMaintEquipByPlanIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintEquipByPlanIDExecute ]
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

ClassMethod GetMaintEquipByPlanIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintEquipByPlanIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQMaintPlanNew).GetOneMaintPlan("1")
ClassMethod GetOneMaint(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaint(rowid)
	s resultex=resultex_"^"	;EquipDR		1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;BussType		2
	i $p(result,"^",2)'=""  d  
	.s resultex=resultex_$CASE($p(result,"^",2),"1":"保养","2":"检查","3":"维修")
	s resultex=resultex_"^"	;MaintPlanDR	3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaintPlan($p(result,"^",3))),"^",1)
	s resultex=resultex_"^"	;MaintTypeDR	4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintType",$p(result,"^",4))),"^",2)
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;MaintDate
	s resultex=resultex_"^"	;MaintLocDR		5
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",6))
	s resultex=resultex_"^"	;MaintUserDR	6
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",7))
	s resultex=resultex_"^"	;MaintModeDR	7
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",$p(result,"^",8))),"^",2)
	s $p(result,"^",9)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",9),"")
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"bool")	;NormalFlag
	s resultex=resultex_"^"	;ManageLocDR	8
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",11))
	s resultex=resultex_"^"	;UseLocDR		9
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",12))
	
	s resultex=resultex_"^"	;Status			10
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",13),"0":"新增","1":"提交","2":"审核")
	s resultex=resultex_"^"	;UpdateUserDR	11
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s $p(result,"^",16)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;UpdateDate
	s resultex=resultex_"^"	;AuditUserDR	12
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;AuditDate
	s resultex=resultex_"^"	;SubmitUserDR	13
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",21))
	s $p(result,"^",22)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",22),"date")	;SubmitDate
	s $p(result,"^",24)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",24),"")
	s $p(result,"^",30)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",30),"bool")	;MeasureFlag
	
	s resultex=resultex_"^"	;MeasureDeptDR		14
	i $p(result,"^",31)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",$p(result,"^",31))),"^",1)
	s resultex=resultex_"^"	;ServiceDR			15
	i $p(result,"^",35)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",$p(result,"^",35))),"^",1)	
	s $p(result,"^",39)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",39),"bool")	;InvalidFlag
	s resultex=resultex_"^"	;DelUserDR			16
	i $p(result,"^",40)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",40))
	s $p(result,"^",41)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",41),"date")	;DelDate
	
	s AvailableDate=""
	s CIRowID=$o(^DHCEQCertificateInfo(0,"Source",4,rowid,0))
	i CIRowID'="" s AvailableDate=$p($g(^DHCEQCertificateInfo(CIRowID)),"^",8)
	s AvailableDate=##Class(web.DHCEQCommon).TransValueToPage(AvailableDate,"date")
	s CertificateNo=""
	i CIRowID'="" s CertificateNo=$p($g(^DHCEQCertificateInfo(CIRowID)),"^",4)
	
	s result=result_resultex_"^"_AvailableDate_"^"_CertificateNo
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:新增、更新
/// w ##Class(web.DHCEQMaintNew).SaveData("^38058^1^6^1^21/03/2011^114^^^^true^^^^^^^^^^^false^^^^^^^^^true")
/// ----------------------------------
ClassMethod SaveData(val, type As %String = "", User As %String = "")
{
	new RowID,Date,Time  //add by zx 2015-12-17
	k PLIST, PL
	Set $ZT="ERRORSave"
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //add by zx 2015-12-17
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)	;RowID
	s PLIST(2) = $p(val,"^",2)	;EquipDR
	s PLIST(3) = $p(val,"^",3)	;BussType
	s PLIST(4) = $p(val,"^",4)	;MaintPlanDR
	s PLIST(5) = $p(val,"^",5)	;MaintTypeDR
	s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")	;MaintDate
	s PLIST(7) = $p(val,"^",7)	;MaintLocDR
	s PLIST(8) = $p(val,"^",8)	;MaintUserDR
	s PLIST(9) = $p(val,"^",9)	;MaintModeDR
	i RowID'=""
	{
		// Modified By QW20180726 BUG:QW0014 更新单据总金额totalfee=修改后maintfee+partfee
		s PLIST(10)=##Class(web.DHCEQMaintPlanNew).GetOtherFee(RowID)+$p(val,"^",16)
	}
	else
	{
		s PLIST(10) = +$p(val,"^",16)	;Total = OtherFee
	}
	s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"bool")	;NormalFlag
	s PLIST(12) = $p(val,"^",12)	;ManageLocDR
	s PLIST(13) = $p(val,"^",13)	;UseLocDR
	s PLIST(14) = $p(val,"^",14)	;Status
	i PLIST(14)="" s PLIST(14) = 0	;Status
	s PLIST(15) = $p(val,"^",15)	;Remark
	s PLIST(16) = User				;UpdateUserDR
	s PLIST(17) = Date				;UpdateDate
	s PLIST(18) = Time				;UpdateTime
	if (type=1)
	{
		s PLIST(19) = User				;AuditUserDR
		s PLIST(20) = Date				;AuditDate
		s PLIST(21) = Time				;AuditTime
	}
	/*
	s PLIST(22) = $p(val,"^",15)	;SubmitUserDR
	s PLIST(23) = $p(val,"^",15)	;SubmitDate
	s PLIST(24) = $p(val,"^",15)	;SubmitTime*/
	
	s PLIST(25) = +$p(val,"^",16)   ;OtherFee
	s PLIST(26) = $p(val,"^",17)	;Hold1
	s PLIST(27) = $p(val,"^",18)	;Hold2
	s PLIST(28) = $p(val,"^",19)	;Hold3
	s PLIST(29) = $p(val,"^",20)	;Hold4
	s PLIST(30) = $p(val,"^",21)	;Hold5
	s PLIST(31) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"bool")	;MeasureFlag
	s PLIST(32) = $p(val,"^",23)	;MeasureDeptDR
	s PLIST(33) = $p(val,"^",24)	;MeasureHandler
	s PLIST(34) = $p(val,"^",25)	;MeasureTel
	s PLIST(35) = $p(val,"^",26)	;MeasureUsers
	s PLIST(36) = $p(val,"^",27)	;ServiceDR
	s PLIST(37) = $p(val,"^",28)	;ServiceHandler
	s PLIST(38) = $p(val,"^",29)	;ServiceTel
	s PLIST(39) = $p(val,"^",30)	;ServiceUsers
	s PLIST(40) =  ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",31),"bool")	;InvalidFlag
	
	s PL(2)="4"    			//检查记录类型
	s PL(3)=$p(val,"^",1)      //检查记录DR  
	s PL(5)=$p(val,"^",33)  ;Add By QW20160314增加计量号 
	s PL(9)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",32),"date")		//Add By HHM HHM0029 证书效期，直接存在直接存在DHC_EQCertificateInfo不做维护
	/*
	s PLIST(41) = $p(val,"^",21)	;DelUserDR
	s PLIST(42) = $p(val,"^",21)	;DelDate
	s PLIST(43) = $p(val,"^",21)	;DelTime
	*/
	TSTART
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQMaint values :PLIST())
		s RowID=$G(%ROWID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		i (PL(9)'="")||(PL(5)'="")
		{
			s PL(3)=RowID
			&SQL(INSERT INTO SQLUSER.DHC_EQCertificateInfo VALUES:PL())			
		}
	}
	else
	{
		s tmpid=""
		&SQL(SELECT CI_RowID INTO:tmpid FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:RowID AND CI_SourceType='4')
		i (PL(9)'="")||(PL(5)'="")
		{
			i (tmpid="")
			{
				s PL(3)=RowID
				&SQL(INSERT INTO SQLUSER.DHC_EQCertificateInfo VALUES:PL())	
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}				
			}
			else
			{
				&SQL(UPDATE SQLUSER.DHC_EQCertificateInfo VALUES:PL() WHERE CI_SourceID=:RowID AND CI_SourceType='4')
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}			
			}
		}
		else
		{
			i tmpid'=""
			{
				&SQL(DELETE FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:RowID AND CI_SourceType='4')  
				i SQLCODE=100 s SQLCODE=0
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}
			}			
		}
		&SQL(update sqluser.DHC_EQMaint values :PLIST() where MT_RowID=:RowID)

	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s Status=PLIST(14)             //add by czf 388716 begin
	i Status=2  s SQLCODE=##class(web.DHCEQMaintNew).InsertEQLifeInfo(RowID,User)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}                                //add by czf 388716 end
 	TCOMMIT
 	q RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:删除
/// w ##Class(web.DHCEQMaintNew).DeleteData("9^^^516^1^^")
/// ----------------------------------
ClassMethod DeleteData(RowID)
{
	Set $ZT="ERRORDelete"	
	TSTART	
	&sql(Delete from sqluser.DHC_EQMaintItem where MTI_MaintDR=:RowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&sql(Delete from sqluser.DHC_EQMaintPart where MTP_MaintDR=:RowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(DELETE FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:RowID AND CI_SourceType='4')   ;Add By HHM0029 20151203 
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&sql(Delete from sqluser.DHC_EQMaint where MT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
ERRORDelete 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:提交
/// w ##Class(web.DHCEQMaintNew).SubmitData("3^^^516^1^^")
/// ----------------------------------
ClassMethod SubmitData(RowID, User As %String = "")
{
	new Date,Time  //add by zx 2015-12-17
	k AppList,PLIST
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //add by zx  2015-12-17
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s PLIST(14) = "2"	;Status 
	s PLIST(19) = User	;AuditUserDR
	s PLIST(20) = Date	;AuditDate
	s PLIST(21) = Time	;AuditTime
	s PLIST(22) = User	;SubmitUserDR
	s PLIST(23) = Date	;SubmitDate
	s PLIST(24) = Time	;SubmitTime
	TSTART
	&SQL(update sqluser.DHC_EQMaint values :PLIST() where MT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s Status=PLIST(14)                              //add by czf 388716 begin
	i Status=2 s SQLCODE=##class(web.DHCEQMaintNew).InsertEQLifeInfo(RowID,User)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}                                               //add by czf 388716 end
 	TCOMMIT
 	q RowID
ERRORSubmit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:反提交
/// w ##Class(web.DHCEQMaintNew).CancelSubmitData("2")
/// ----------------------------------
ClassMethod CancelSubmitData(RowID)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORCancel"
	k PLIST
 	//s PLIST(14) = "0"			;Status
	s PLIST(40) = "Y"			;InvalidFlag
	s PLIST(41) = User			;DelUserDR
	s PLIST(42) = Date			;DelDate
	s PLIST(43) = Time			;DelTime
	TSTART
	&SQL(update sqluser.DHC_EQMaint values :PLIST() where MT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQMaintNew).Execute("10^67442",1)
ClassMethod Execute(valRowIDs, BussType)
{
	new User,Date,Time,len,i,val,Plan,EquipID,flag,Str
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s MaintIDS=""	//CZF0134 2021-02-23
	set flag=0
	set len=$l(valRowIDs,",")
	for i=1:1:len
	{
		quit:flag'=0
		set val=$p(valRowIDs,",",i)
		set PlanID=$p(val,"^",1)
		set EquipID=$p(val,"^",2)
		set MaintTypeDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",9)
		set MaintDate=##Class(web.DHCEQCommon).TransValueToPage(Date,"date")
		set MaintLocDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",14)
		set MaintUserDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",15)
		set MaintModeDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",16)
		set TotalFee=##Class(web.DHCEQMaintPlanNew).GetOtherFee(PlanID)
		set NormalFlag=""
		set ManageLocDR=""
		set UseLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)  ///modify by lmm 2017-03-26
		set Status="2"
		set Remark=$p($g(^DHCEQMaintPlan(PlanID)),"^",25)
		set MaintFee=$p($g(^DHCEQMaintPlan(PlanID)),"^",13)
		set Hold1=""
		set Hold2=""
		set Hold3=""
		set Hold4=""
		set Hold5=""
		set MeasureFlag=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(PlanID)),"^",18),"bool")
		set MeasureDeptDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",19)
		set MeasureHandler=$p($g(^DHCEQMaintPlan(PlanID)),"^",20)
		set MeasureTel=$p($g(^DHCEQMaintPlan(PlanID)),"^",21)
		set MeasureUsers=""
		set ServiceDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",22)
		set ServiceHandler=$p($g(^DHCEQMaintPlan(PlanID)),"^",23)
		set ServiceTel=$p($g(^DHCEQMaintPlan(PlanID)),"^",24)
		set ServiceUsers=""
		set InvalidFlag=""
		set Str="^"_EquipID_"^"_BussType_"^"_PlanID_"^"_MaintTypeDR_"^"_MaintDate_"^"_MaintLocDR_"^"
		set Str=Str_MaintUserDR_"^"_MaintModeDR_"^"_TotalFee_"^"_NormalFlag_"^"_ManageLocDR_"^"
		set Str=Str_UseLocDR_"^"_Status_"^"_Remark_"^"_MaintFee_"^"_Hold1_"^"_Hold2_"^"_Hold3_"^"_Hold4_"^"_Hold5_"^"
		set Str=Str_MeasureFlag_"^"_MeasureDeptDR_"^"_MeasureHandler_"^"_MeasureTel_"^"_MeasureUsers_"^"
		set Str=Str_ServiceDR_"^"_ServiceHandler_"^"_ServiceTel_"^"_ServiceUsers_"^"_InvalidFlag
		set RtStr=##Class(web.DHCEQMaintNew).SaveData(Str,1)
		i MaintIDS="" s MaintIDS=RtStr		//CZF0134 2021-02-23
		e  s MaintIDS=MaintIDS_","_RtStr
		s flag=RtStr
		i flag>0 set flag=0
	}
	q flag_"^"_MaintIDS
}

/// add:czf 2017-06-1 388716
/// 描述:执行计划和新建维护记录时写入生命周期表
ClassMethod InsertEQLifeInfo(RowID, User)
{
	new (RowID,User)
	q:RowID=""
	s SQLCODE=0
	s Date=+$H
	s Time=$P($H,",",2)
	s EquipID=$p($g(^DHCEQMaint(RowID)),"^",1)
	s BussType=$p($g(^DHCEQMaint(RowID)),"^",2)
	s MaintTypeDR=$p($g(^DHCEQMaint(RowID)),"^",4)
	
	k LI
	s LI(2)=EquipID //设备
	s LI(4)=$p($g(^DHCEQEquip(EquipID)),"^",19)   	//原使用科室
	s LI(5)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//原管理科室
	s LI(6)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//原库房
	s LI(7)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//原值
	s LI(8)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//原净值
	s LI(9)=$p($g(^DHCEQEquip(EquipID)),"^",19)  	//变动后使用科室
 	s LI(10)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//变动后管理科室
 	s LI(11)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//变动后库房
 	s LI(12)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//变动后原值
 	s LI(13)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//变动后净值
	s LI(16)=Date			//变动日期
	s LI(17)=Time			//变动时间
	s LI(18)=$p($g(^DHCEQMaint(RowID)),"^",9)   	//费用
	s LI(19)="P"  			//生命周期类型
	i BussType=1 d
	.s LI(20)=32            //保养
	i BussType=2 d
	.s LI(20)=33            //检查
	.i MaintTypeDR=4 s LI(14)="巡检"
	.i MaintTypeDR=5 s LI(14)="计量"
	s LI(21)=RowID	//来源ID
	s LI(27)=User	//更新人
	s LI(28)=Date	//更新日期
	s LI(29)=Time	//更新时间
	&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	q SQLCODE
}

}
