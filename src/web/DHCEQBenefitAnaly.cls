Import SQLUser

Class web.DHCEQBenefitAnaly Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 283;

Parameter SQLCODE = "BA_RowID";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "BA_RowID";

Parameter SQLROWID = "BA_RowID";

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQBenefitAnaly(rowid)
	s No=$p(result,"^",1)
	s Year=$p(result,"^",3)
	s Month=$p(result,"^",4)
	s CTLocDR=$p(result,"^",5)
	s CTLoc=""
	i CTLocDR'="" s CTLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",CTLocDR)
	s EquipDR=$p(result,"^",6)
	s Equip=""
	i EquipDR'="" s Equip=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s PlanUse=$p(result,"^",7)
	s FactUse=$p(result,"^",8)
	s Amount=$p(result,"^",10)
	s ProfitLossAmount=$p(result,"^",11)
	s OriginalFee=$p(result,"^",12)
	s Status=$p(result,"^",13)
	s ProfitRate=$p(result,"^",17)
	s Remark=$p(result,"^",18)
	s OutTotalFee=$p(result,"^",25)
	s resultex=rowid_"^"_No_"^"_Year_"^"_Month_"^"_CTLocDR_"^"_CTLoc_"^"_EquipDR_"^"_Equip_"^"_PlanUse_"^"_FactUse_"^"_Amount_"^"_ProfitLossAmount_"^"_OriginalFee_"^"_Status_"^"_ProfitRate_"^"_Remark_"^"_OutTotalFee
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q resultex
}

/// isDel说明(1:删除 2：新增/更新 3:提交 4:取消提交 5:审核)
ClassMethod SaveData(val As %Library.String = "", vallist As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 s rowid=$p(val,"^",1)
 s ID=rowid
 TSTART
 i (+isDel=1) //删除
 {
	 &SQL(Delete from DHC_EQBenefitAnaly where BA_RowID = :rowid)
	 i SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 &SQL(Delete from DHC_EQBenefitAnalyList where BAL_BenefitAnalyDR = :rowid)
	 i SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
 	q rowid
 }
 i (+isDel=2) //新增,更新
 {
	 s PLIST(3)=+$H			  ;Indate
	 s PLIST(4)=$P(val,"^",2) ;Year
	 s PLIST(5)=$P(val,"^",3) ;Month
	 s PLIST(6)=$P(val,"^",4) ;CTLocDR
	 s PLIST(7)=$P(val,"^",5) ;EquipDR
	 s PLIST(8)=$P(val,"^",6) ;PlanUse
	 s PLIST(9)=$P(val,"^",7) ;FactUse
	 s PLIST(11)=$P(val,"^",8) ;Amount
	 s PLIST(12)=$P(val,"^",9) ;ProfitLossAmount
	 s PLIST(13)=$P(val,"^",10) ;OriginalFee
	 s PLIST(14)=0				;Status
	 s PLIST(15)=User			;UserDR
	 s PLIST(18)=$P(val,"^",12) ;ProfitRate
	 s PLIST(19)=$P(val,"^",13) ;Remark
	 s PLIST(26)=$P(val,"^",14) ;OutTotalFee
	 i (rowid="")
	 {
		 s find=$o(^DHCEQBenefitAnaly(0,"EquipYearMonth",PLIST(7),PLIST(4),PLIST(5),0))
		 i find'="" q -99
		 &SQL(Insert into DHC_EQBenefitAnaly Values :PLIST())
		 i SQLCODE
		 {
			 TROLLBACK
			 q SQLCODE
		 }
		 s ID=$g(%ROWID)
		 s ListCount=$l(vallist,"||") - 1
		 f j=1:1:ListCount
		 {
			 k PLIST
			 s ListInfo=$p(vallist,"||",j)
			 s PLIST(2)=ID
			 s PLIST(3)=$P(ListInfo,"^",2) ;ResourceTypeDR
			 s PLIST(4)=$P(ListInfo,"^",3) ;Fee
			 s PLIST(5)=$P(ListInfo,"^",4) ;DutyUserDR
			 s PLIST(6)=$P(ListInfo,"^",5) ;Remark
			 &SQL(Insert into DHC_EQBenefitAnalyList Values :PLIST())
			 i SQLCODE QUIT
		 }
	 }
	 else
	 {
		 &SQL(Update DHC_EQBenefitAnaly Values :PLIST() where BA_RowID = :rowid)
		 i SQLCODE
		 {
			 TROLLBACK
			 q SQLCODE
		 }
		 s ListCount=$l(vallist,"||") - 1
		 f j=1:1:ListCount
		 {
			 k PLIST
			 s ListInfo=$p(vallist,"||",j)
			 s BALRowID=$p(ListInfo,"^",1)
			 s PLIST(4)=$P(ListInfo,"^",3) ;Fee
			 s PLIST(5)=$P(ListInfo,"^",4) ;DutyUserDR
			 s PLIST(6)=$P(ListInfo,"^",5) ;Remark
			 &SQL(Update DHC_EQBenefitAnalyList Values :PLIST() where BAL_RowID=:BALRowID)
			 i SQLCODE QUIT
		 }
	 }
 }
 i (+isDel=3) //提交
 {
	 s PLIST(14)=1
	 &SQL(Update DHC_EQBenefitAnaly Values :PLIST() where BA_RowID = :rowid)
 }
 i (+isDel=4) //取消提交
 {
	 s PLIST(14)=0
	 &SQL(Update DHC_EQBenefitAnaly Values :PLIST() where BA_RowID = :rowid)
 }
 i (+isDel=5) //审核
 {
	 s PLIST(14)=2
	 s PLIST(16)=User
	 s PLIST(17)=+$H
	 &SQL(Update DHC_EQBenefitAnaly Values :PLIST() where BA_RowID = :rowid)
 }
 i SQLCODE
 {
	 TROLLBACK
	 q SQLCODE
 }
 TCOMMIT
 q ID
}

/******************************************************************************/
ClassMethod BenefitAnalyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BenefitAnalyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod BenefitAnalyExecute(ByRef qHandle As %Binary, BARowID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBenefitAnaly
	Quit $$$OK
BuildDataGetBenefitAnaly
	i BARowID=""  d
	.f  s rowid=$o(^DHCEQCCode("DHCEQCResourceType",rowid)) q:rowid=""  d
	..d ResetVariablesGetBenefitAnaly
	..s TResourceTypeDR=rowid
	..s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",4)
	..q:InvalidFlag="Y"
	..s TResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",rowid)),"^",2)
	..d OutputRowGetBenefitAnaly
	e  d
	.f  s rowid=$o(^DHCEQBenefitAnalyList(0,"BenefitAnaly",BARowID,rowid)) q:rowid=""  d
	..d ResetVariablesGetBenefitAnaly
	..s TRowID=rowid
	..s TResourceTypeDR=$p($g(^DHCEQBenefitAnalyList(rowid)),"^",2)
	..i TResourceTypeDR'="" s TResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",TResourceTypeDR)),"^",2)
	..i TResourceType="" s TResourceType="未定义"
	..s TFee=$p($g(^DHCEQBenefitAnalyList(rowid)),"^",3)
	..s TDutyUserDR=$p($g(^DHCEQBenefitAnalyList(rowid)),"^",4)
	..i TDutyUserDR'="" s TDutyUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TDutyUserDR)
	..s TRemark=$p($g(^DHCEQBenefitAnalyList(rowid)),"^",5)
	..d OutputRowGetBenefitAnaly
	quit
OutputRowGetBenefitAnaly
	s Data=$lb(TResourceType,TFee,TDutyUser,TRemark,TResourceTypeDR,TDutyUserDR,TRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBenefitAnaly
	s (TResourceType,TFee,TDutyUser,TRemark,TResourceTypeDR,TDutyUserDR,TRowID)=""
	quit
}

ClassMethod BenefitAnalyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BenefitAnalyExecute ]
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

Query BenefitAnaly(BARowID As %String = "") As %Query(ROWSPEC = "TResourceType:%String,TFee:%String,TDutyUser:%String,TRemark:%String,TResourceTypeDR:%String,TDutyUserDR:%String,TRowID:%String")
{
}

/******************************************************************************/
ClassMethod GetDepreFee(rowid As %Library.String = "", DepreMonth As %Library.String = "")
{
	s find=$o(^DHCEQMonthDepre(0,"EquipMonth",rowid,DepreMonth,0))
	i find="" q 0
	s DepreFee=$p($g(^DHCEQMonthDepre(find)),"^",14)
	i DepreFee="" q 0
	q DepreFee
}

/******************************************************************************/
ClassMethod BenefitAnalyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BenefitAnalyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod BenefitAnalyListExecute(ByRef qHandle As %Binary, StatusDR As %String = "", Year As %String = "", Month As %String = "", UseLocDR As %String = "", EquipDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("BenefitAnalyList",User)
 	s PNum=1
	s index=1
	s rowid=0
	d BuildDataGetBenefitAnalyList
	Quit $$$OK
BuildDataGetBenefitAnalyList
	f  s rowid=$o(^DHCEQBenefitAnaly(rowid)) q:rowid=""  d
	.s TRowID=rowid
	.s TYear=$p($g(^DHCEQBenefitAnaly(rowid)),"^",3)
	.q:(Year'="")&&(TYear'=Year)
	.s TMonth=$p($g(^DHCEQBenefitAnaly(rowid)),"^",4)
	.q:(Month'="")&&(TMonth'=Month)
	.s TStatus=$p($g(^DHCEQBenefitAnaly(rowid)),"^",13)
	.q:(StatusDR'="")&&(TStatus'=StatusDR)
	.s TDate=TYear_"-"_TMonth
	.s TEquipDR=$p($g(^DHCEQBenefitAnaly(rowid)),"^",6)
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.s TUseLocDR=$p($g(^DHCEQBenefitAnaly(rowid)),"^",5)
	.q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	.i TEquipDR'="" d
	..s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	..s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TUnitDR=$p($g(^DHCEQEquip(TEquipDR)),"^",5)
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TStartDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(TEquipDR)),"^",44),"date")
	.i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TPlanUse=$p($g(^DHCEQBenefitAnaly(rowid)),"^",7)
	.s TFactUse=$p($g(^DHCEQBenefitAnaly(rowid)),"^",8)
	.s TInAmount=$p($g(^DHCEQBenefitAnaly(rowid)),"^",10)
	.s TProfitAmount=$p($g(^DHCEQBenefitAnaly(rowid)),"^",11)
	.s TOriginalFee=$p($g(^DHCEQBenefitAnaly(rowid)),"^",12)
	.s TProfitRate=$p($g(^DHCEQBenefitAnaly(rowid)),"^",17)
	.s TOutAmount=$p($g(^DHCEQBenefitAnaly(rowid)),"^",25)	
	.d OutputRowGetBenefitAnalyList
	quit
OutputRowGetBenefitAnalyList
	s Data=$lb(TRowID,TDate,TEquip,TUseLoc,TEquipNo,TModel,TUnit,TStartDate,TOriginalFee,TPlanUse,TFactUse,TInAmount,TOutAmount,TProfitAmount,TProfitRate,TStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("BenefitAnalyList",User,PNum)=TRowID_"^"_TDate_"^"_TEquip_"^"_TUseLoc_"^"_TEquipNo_"^"_TModel_"^"_TUnit_"^"_TStartDate_"^"_TOriginalFee_"^"_TPlanUse_"^"_TFactUse_"^"_TInAmount_"^"_TOutAmount_"^"_TProfitAmount_"^"_TProfitRate_"^"_TStatus
	s PNum=PNum+1
	quit
ResetVariablesGetBenefitAnalyList
	s (TRowID,TDate,TEquip,TUseLoc,TEquipNo,TModel,TUnit,TStartDate,TOriginalFee,TPlanUse,TFactUse,TInAmount,TOutAmount,TProfitAmount,TProfitRate,TStatus)=""
	quit
}

ClassMethod BenefitAnalyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BenefitAnalyListExecute ]
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

Query BenefitAnalyList(StatusDR As %String = "", Year As %String = "", Month As %String = "", UseLocDR As %String = "", EquipDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDate:%String,TEquip:%String,TUseLoc:%String,TEquipNo:%String,TModel:%String,TUnit:%String,TStartDate:%String,TOriginalFee:%String,TPlanUse:%String,TFactUse:%String,TInAmount:%String,TOutAmount:%String,TProfitAmount:%String,TProfitRate:%String,TStatus:%String")
{
}

ClassMethod GetOneBenefitAnalyList(PNum)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i PNum=0 q $o(^DHCEQTemp("BenefitAnalyList",User,""),-1)
	q $g(^DHCEQTemp("BenefitAnalyList",User,PNum))
}

/******************************************************************************/

/*
ClassMethod GetBenefitAnalyEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitAnalyEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetBenefitAnalyEquipExecute(ByRef qHandle As %Binary, CTLocDR As %String = "", Equip As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(0,"BenefitAnalyFlag","Y",rowid)) q:rowid=""  d
	.s EQRowID=rowid
	.s EQUseLoc=""
	.s Status=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:Status'=1
	.s UseLocDR=$p($g(^DHCEQEquip(rowid)),"^",19)
	.q:(CTLocDR'="")&&(UseLocDR'=CTLocDR)
	.s EQNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.q:(Equip'="")&&($e(EQNo,1,$l(Equip))'=Equip)&&(EQName'[Equip)
	.i UseLocDR'="" s EQUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
 	.Do OutputRowGetBenefitAnalyEquip	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetBenefitAnalyEquip
	set Data=$lb(EQName,EQRowID,EQNo,EQUseLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBenefitAnalyEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitAnalyEquipExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetBenefitAnalyEquip(CTLocDR As %String = "", Equip As %String = "") As %Query(ROWSPEC = "EQName:%String,Hidden:%String,EQNo:%String,EQUseLoc:%String")
{
}
*/

/******************************************************************************/
}
