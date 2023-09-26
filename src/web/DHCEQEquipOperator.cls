Import SQLUser

Class web.DHCEQEquipOperator Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EO_RowID";

Parameter SQLDESCRIPTION = "EO_RowID";

Parameter SQLROWID = "EO_RowID";

ClassMethod GetEquipOperatorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipOperatorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
ClassMethod GetEquipOperatorExecute(ByRef qHandle As %Binary, EquipDR As %String = "", UserDR As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetEquipOperator
	Quit $$$OK
BuildDataGetEquipOperator
	f  s rowid=$o(^DHCEQEquipOperator(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquipOperator
	.s TRowID = rowid	//rowid
	.s TEquip=$p($g(^DHCEQEquipOperator(rowid)),"^",1)
	.q:(EquipDR'="")&&(TEquip'=EquipDR)
	.s TNo=$p($g(^DHCEQEquip(TEquip)),"^",71)
	.s Find=0 //2010-10-29 DJ
	.s StoreLoc=$p($g(^DHCEQEquip(TEquip)),"^",67)
	.i StoreLoc'=""  d
	..s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)
	.q:Find'=0 //2010-10-29 DJ
	.s TEquipDR=TEquip
	.i TEquip'="" s TEquip=$p($g(^DHCEQEquip(TEquip)),"^",1)
	.s TUser=$p($g(^DHCEQEquipOperator(rowid)),"^",2)
	.q:(UserDR'="")&&(TUser'=UserDR)
	.i TUser'="" s TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUser)
	.s TPercent=$p($g(^DHCEQEquipOperator(rowid)),"^",3)
	.s TRemark=$p($g(^DHCEQEquipOperator(rowid)),"^",4)
	.s TFromDate=$p($g(^DHCEQEquipOperator(rowid)),"^",5)
	.s TFromDate=##class(web.DHCEQCommon).TransValueToPage(TFromDate,"date")
	.s TToDate=$p($g(^DHCEQEquipOperator(rowid)),"^",6)
	.s TToDate=##class(web.DHCEQCommon).TransValueToPage(TToDate,"date")
	.d OutputRowGetEquipOperator
	quit
OutputRowGetEquipOperator
	s Data=$lb(TRowID,TEquip,TUser,TFromDate,TToDate,TPercent,TRemark,TNo,TEquipDR,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetEquipOperator
	s (TRowID,TEquip,TUser,TFromDate,TToDate,TPercent,TRemark,TNo,TEquipDR)=""
	quit
}

ClassMethod GetEquipOperatorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipOperatorExecute ]
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

Query GetEquipOperator(EquipDR As %String = "", UserDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TUser:%String,TFromDate:%String,TToDate:%String,TPercent:%String,TRemark:%String,TNo:%String,TEquipDR:%String,TRow:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQEquipOperator(rowid))
	s resultex=resultex_"^"
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",2))
	i $p(result,"^",5)'=""  s $p(result,"^",5)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")
	i $p(result,"^",6)'=""  s $p(result,"^",6)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQEquipOperator where EO_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //EquipDR
 s Equip=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //UserDR
 s User=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //Percent
 s PLIST(5)=$P(val,"^",5) //Remark
 i $p(val,"^",6)'="" s PLIST(6)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date") //FromDate
 i $p(val,"^",7)'="" s PLIST(7)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date") //ToDate
 
 i (rowid="")  //新增按钮操作
 {
	 //检测当前记录是否已经存在
	 &SQL(select EO_RowID into :RowidFind from DHC_EQEquipOperator where EO_EquipDR=:Equip and EO_UserDR=:User)
	 i (RowidFind="") //当前记录为新记录,否则已经存在
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQEquipOperator Values :PLIST())
	 }
 }
 else  //更新按钮操作
 {
	 &SQL(select EO_RowID into :RowidFind from DHC_EQEquipOperator where EO_EquipDR=:Equip and EO_UserDR=:User)
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQEquipOperator Values :PLIST() where EO_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQEquipOperator Values :PLIST() where EO_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/// MZY0071		1760015		2021-04-08	效益分析用户可操作设备是否包括本科室设备及效益分析设备增加执行科室
/// modified by czf 421875 增加TRow并输出
/// d ##Class(%ResultSet).RunQuery("web.DHCEQEquipOperator","GetOperatorEquipList","","")
Query GetOperatorEquipList(EquipDR As %String = "", UserDR As %String = "", Equip As %String = "", QXType As %String = "", Location As %String = "") As %Query(ROWSPEC = "TEquip:%String:设备,TEquipDR:%String:设备RowID,TNo:%String:设备编码,Hidden:%String,TRow:%String:序号,TLocation:%String:存放地点,TLoc:%String:科室,TFlag:%String:配置标识")
{
}

ClassMethod GetOperatorEquipListExecute(ByRef qHandle As %Binary, EquipDR As %String = "", UserDR As %String = "", Equip As %String = "", QXType As %String = "", Location As %String = "") As %Status
{
	new repid, index, rowid, DataInfo
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	
	Set TempID=$I(^DHCEQTemp("web.DHCEQEquipOperator.GetOperatorEquipList",+$H))
	Do ##Class(web.DHCEQCommon).KillTempGlobalNew("web.DHCEQEquipOperator.GetOperatorEquipList",TempID)	// MZY0074	1877414		2021-04-30
	;Set ^DHCEQTemp("web.DHCEQEquipOperator.GetOperatorEquipList",+$H,TempID,AdjustDataDR)=FundsFee
	s flag=##class(web.DHCEQCommon).GetSysInfo("992012")
	
	s rowid=0
	f  s rowid=$o(^DHCEQEquipOperator(rowid)) quit:rowid=""  d
	.d ResetVariablesGetOperatorEquipList
	.s TRowID = rowid	//rowid
	.s TEquipDR=$p($g(^DHCEQEquipOperator(rowid)),"^",1)
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.q:##class(web.DHCEQCommon).LocIsInEQ(QXType,$p($g(^DHCEQEquip(TEquipDR)),"^",67))'=0
	.s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.q:(Equip'="")&&(TEquip'[Equip)		; MZY0156	3377013		2023-03-24	模糊查询
	.s TUser=$p($g(^DHCEQEquipOperator(rowid)),"^",2)
	.q:(UserDR'="")&&(TUser'=UserDR)
	.s TLocation = ##class(web.DHCEQCommon).GetTrakNameByID("location", $Piece($Get(^DHCEQEquip(TEquipDR)),"^",72))
	.q:(Location'="")&&(TLocation'[Location)	; MZY0156	3377013		2023-03-24	模糊查询
	.Set ^DHCEQTemp("web.DHCEQEquipOperator.GetOperatorEquipList",+$H,TempID,TEquipDR,1)=TEquip_","_TNo_","_TRowID_","_TLocation
	
	s rowid=0
	s CTLOCID=##Class(web.DHCEQCommon).getMapIDBySource("dept", %session.Get("LOGON.CTLOCID"))
	;;;;f  s rowid=$o(^DHCEQEquip(rowid)) q:rowid=""  d
	f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",CTLOCID,rowid)) q:rowid=""  d
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(rowid)),"^",63))
	.q:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)=0
	.q:(EquipDR'="")&&(rowid'=EquipDR)
	.s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	.s TEquip=$p($g(^DHCEQEquip(rowid)),"^",1)
	.q:(Equip'="")&&(TEquip'[Equip)		; MZY0156	3377013		2023-03-24	模糊查询
	.s TLocation = ##class(web.DHCEQCommon).GetTrakNameByID("location", $Piece($Get(^DHCEQEquip(rowid)),"^",72))
	.q:(Location'="")&&(TLocation'[Location)	; MZY0156	3377013		2023-03-24	模糊查询
	.Set ^DHCEQTemp("web.DHCEQEquipOperator.GetOperatorEquipList",+$H,TempID,rowid,2)=TEquip_","_TNo_",,"_TLocation
	
	s rowid=0
	f  s rowid=$o(^DHCEQBenefitEquipList(rowid)) q:rowid=""  d
	.s BELHold1=$p($g(^DHCEQBenefitEquipList(rowid)),"^",10)			;执行科室
	.q:(BELHold1'=%session.Get("LOGON.CTLOCID"))
	.s TEquipDR=$p($g(^DHCEQBenefitEquipList(rowid)),"^",1)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(TEquipDR)),"^",63))
	.q:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(TEquipDR)=0
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.q:(Equip'="")&&(TEquip'[Equip)		; MZY0156	3377013		2023-03-24	模糊查询
	.s TLocation = ##class(web.DHCEQCommon).GetTrakNameByID("location", $Piece($Get(^DHCEQEquip(TEquipDR)),"^",72))
	.q:(Location'="")&&(TLocation'[Location)	; MZY0156	3377013		2023-03-24	模糊查询
	.Set ^DHCEQTemp("web.DHCEQEquipOperator.GetOperatorEquipList",+$H,TempID,TEquipDR,3)=TEquip_","_TNo_",,"_TLocation
	
	
	//输出
	k ^DHCEQTemp("web.DHCEQEquipOperator.Output")
	s TEquipDR=0
	f  s TEquipDR=$o(^DHCEQTemp("web.DHCEQEquipOperator.GetOperatorEquipList",+$H,TempID,TEquipDR)) quit:TEquipDR=""  d
	.s sort=$o(^DHCEQTemp("web.DHCEQEquipOperator.GetOperatorEquipList",+$H,TempID,TEquipDR,""))
	.s ^DHCEQTemp("web.DHCEQEquipOperator.Output",sort,TEquipDR)=$g(^DHCEQTemp("web.DHCEQEquipOperator.GetOperatorEquipList",+$H,TempID,TEquipDR,sort))
	
	s sort=""
	f  s sort=$o(^DHCEQTemp("web.DHCEQEquipOperator.Output",sort)) quit:sort=""  d
	.q:(flag=0)&&(sort=2)		// MZY0074	1877414		2021-04-30
	.s TFlag = $CASE(sort,"1":"个人","2":"本科室","3":"执行科室",:"没有定义")
	.s TEquipDR=0
	.f  s TEquipDR=$o(^DHCEQTemp("web.DHCEQEquipOperator.Output",sort,TEquipDR)) quit:TEquipDR=""  d
	..;d ResetVariablesGetOperatorEquipList
	..s DataInfo=$g(^DHCEQTemp("web.DHCEQEquipOperator.Output",sort,TEquipDR))
	..s TEquip=$p(DataInfo,",",1)
	..s TNo=$p(DataInfo,",",2)
	..s TRowID=$p(DataInfo,",",3)
	..s TLocation=$p(DataInfo,",",4)
	..s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept", $Piece($Get(^DHCEQEquip(TEquipDR)),"^",67))
	..d OutputRowGetOperatorEquipList
	
	Quit $$$OK
OutputRowGetOperatorEquipList
	Set Data=$lb(TEquip,TEquipDR,TNo,TRowID,TRow,TLocation,TLoc,TFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetOperatorEquipList
	s (TEquip,TEquipDR,TNo,TRowID,TLocation,TLoc)=""
	quit
}

ClassMethod GetOperatorEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperatorEquipListExecute ]
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

ClassMethod GetOperatorEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperatorEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
