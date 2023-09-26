Class web.DHCEQDepreFind Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 折旧到期查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQDepreFind","GetDepreFindList","63004","","","","","")
Query GetDepreFindList(BeginDate As %Library.String = "", EndDate As %Library.String = "", UseLocDR As %Library.String = "", Name As %Library.String = "", EquipTypeDR As %Library.String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TNo:%String,TProvider:%String,TModel:%String,TEquipCat:%String,TEquipType:%String,TOriginalFee:%String,TQuantity:%String,TLimitYearsNum:%String,TStoreLoc:%String,TStoreLocDR:%String,TStatCat:%String,TUseLoc:%String,TDepreTotalFee:%String")
{
}

ClassMethod GetDepreFindListExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", UseLocDR As %Library.String = "", Name As %Library.String = "", EquipTypeDR As %Library.String = "", QXType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s rowid=0
	s TotalFee=0
	s TTotalNum=0
	if ((BeginDate="")&&(EndDate="")) Quit $$$OK	
	s start=0
	i BeginDate'="" s start=BeginDate-1
	s end=+$H
	i EndDate'="" s end=EndDate
	s locdr=0
	s ETIDS=##class(web.DHCEQCommon).GetEquipTypesByGroup("")  ;MR0012  2014-04-03
	s EquipTypeIDS="^"_ETIDS_"^" 
	;s EquipTypeIDS=""
	f  s locdr=$o(^DHCEQMonthDepre(0,"Loc",locdr))  quit:locdr=""  d
	.q:((UseLocDR'="")&&(UseLocDR'=locdr))
	.;q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,locdr))) //2010-10-29 DJ
	.s auditdate=start
	.f  s auditdate=$o(^DHCEQMonthDepre(0,"Loc",locdr,auditdate))  quit:((auditdate="")||(auditdate>end))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQMonthDepre(0,"Loc",locdr,auditdate,rowid))  quit:((rowid=""))  d
	...s depredata=$g(^DHCEQMonthDepre(rowid))
	...s MDStatus=$p($g(^DHCEQMonthDepre(rowid)),"^",20)	//DJ0136
	...q:MDStatus="3"
	...;q:($p(depredata,"^",3)'=IsMainFlag)
	...s equipid=$p(depredata,"^",1)
	...s Status=$p($g(^DHCEQEquip(equipid)),"^",38)
	...q:Status="3"
	...s InvalidFlag=$p($g(^DHCEQEquip(equipid)),"^",59)
	...q:InvalidFlag="Y"
	...s TNetFee=$p(depredata,"^",17) ;MR0012   2014-04-03
	...q:TNetFee>0
	...s TName = $ZCONVERT($p($g(^DHCEQEquip(equipid)),"^",1),"U")
	...s Code = $ZCONVERT($p($g(^DHCEQEquip(equipid)),"^",6),"U") 
	...s TNo = $ZCONVERT($p($g(^DHCEQEquip(equipid)),"^",71),"U")
	...q:(Name'="")&&(TName'[Name)&&(Code'[Name)&&(TNo'[Name)
	...s equiptype=$p($g(^DHCEQEquip(equipid)),"^",63)
	...q:(EquipTypeIDS'="")&&(EquipTypeIDS'[("^"_equiptype_"^")) 
	...q:(EquipTypeDR'="")&&(EquipTypeDR'=equiptype)
	...d BuildDataDepreFindList
	...d OutputRowGetDepreFindList
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0 //2011-01-28 DJ
		d ResetVariablesDepreFind
		s TName="合计:"
		s TQuantity=TTotalNum
		s TOriginalFee=TotalFee
		//add by jdl 2009-9-25  JDL0036
		//格式化金额为小数点两位
		i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
		s Data=$lb(TRowID,TName,TNo,TProvider,TModel,TEquipCat,TEquipType,TOriginalFee,TQuantity,TLimitYearsNum,TStoreLoc,TStoreLocDR,TStatCat,TUseLoc,TDepreTotalFee)
		Set ^CacheTemp(repid,TotalLoc)=Data
	}
	
	Quit $$$OK
BuildDataDepreFindList
	s (TRowID,TName,TNo,TEquipDR,TProvider,TProviderDR,TModel,TModelDR,TEquipCat,TEquipCatDR,TEquipType,TEquipTypeDR,TOriginalFee,TQuantity,TLimitYearsNum,TStoreLoc,TStoreLocDR,TStatCat,TStatCatDR,TUseLoc,TUseLocDR,TDepreTotalFee)=""
	s TEquipDR = $p($g(^DHCEQMonthDepre(rowid)),"^",1)
	s TRowID = TEquipDR
	s equipdata=$g(^DHCEQEquip(TEquipDR))
	s TName = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	s TProviderDR=$p(equipdata,"^",25)
	i TProviderDR '=""  d
	.s TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TModelDR=$p(equipdata,"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TEquipCatDR=$p(equipdata,"^",4)
	i TEquipCatDR '=""  d
	.s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	s TEquipTypeDR=$p(equipdata,"^",63)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TOriginalFee=$p(equipdata,"^",27)
	s TotalFee=TotalFee+TOriginalFee
	s TQuantity=1
	s TTotalNum=TTotalNum+TQuantity
	s TLimitYearsNum=$p(equipdata,"^",31)
	s TStoreLocDR=$p(equipdata,"^",67)
	i TStoreLocDR '=""  d
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s TStatCatDR=$p(equipdata,"^",75)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TUseLocDR=$p(equipdata,"^",19)
	i TUseLocDR '=""  d
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TDepreTotalFee=$p(equipdata,"^",35)
	
	quit
	
ResetVariablesDepreFind
	s (TRowID,TName,TNo,TEquipDR,TProvider,TProviderDR,TModel,TModelDR,TEquipCat,TEquipCatDR,TEquipType,TEquipTypeDR,TOriginalFee,TQuantity,TLimitYearsNum,TStoreLoc,TStoreLocDR,TStatCat,TStatCatDR,TUseLoc,TUseLocDR,TDepreTotalFee)=""
	quit
OutputRowGetDepreFindList
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s Data=$lb(TRowID,TName,TNo,TProvider,TModel,TEquipCat,TEquipType,TOriginalFee,TQuantity,TLimitYearsNum,TStoreLoc,TStoreLocDR,TStatCat,TUseLoc,TDepreTotalFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetDepreFindListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepreFindListExecute ]
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

ClassMethod GetDepreFindListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepreFindListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
