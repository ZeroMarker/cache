Import SQLUser

/// add by zx 2014-09-16
/// 增加消耗项收费价格,方便统计消耗项在医嘱之外收取费用
Class web.DHCEQCConsumableItem Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CI_RowID";

Parameter SQLDESCRIPTION = "CI_RowID";

Parameter SQLROWID = "CI_RowID";

ClassMethod GetConsumableItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumableItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
/// modified by sjh 2020-01-19 增加输出	TChargeType,TExpenseType,TAdditionRate,TBillItemNo,TRegistrationNo,TExpenseRate,TDisposableFlag
ClassMethod GetConsumableItemExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ExTypeDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Code=##Class(web.DHCEQCommon).UnEscape(Code)
	Set Code=$ZCONVERT(Code ,"U")
	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetConsumableItem
	Quit $$$OK
	
BuildDataGetConsumableItem
	f  s rowid=$o(^DHCEQCCode("DHCEQCConsumableItem",rowid))  quit:rowid=""  d
	.d ResetVariablesGetConsumableItem
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",7)
	.q:InvalidFlag="Y"
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",1)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",2)
	.q:(Code'="")&&($ZCONVERT(TCode ,"U")'[Code)&&($ZCONVERT(TDesc ,"U")'[Code)
	.q:(Desc'="")&&($ZCONVERT(TDesc ,"U")'[Desc)
	.s TUnit=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",4)
	.i TUnit'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.s TPrice=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",3)
	.s TExType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",5)
	.q:(ExTypeDR'="")&&(TExType'=ExTypeDR)
	.s TExID=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",6)
	.s TExDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",8)
	.s TPayPrice=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",9)
	.s TChargeType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",14)
	.i TChargeType'="" s TChargeType=##Class(web.DHCEQCConsumableItem).GetChargeType(TChargeType)
	.s TExpenseType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",15)
	.i TExpenseType'="" s TExpenseType=##Class(web.DHCEQCConsumableItem).GetExpenseType(TExpenseType)
	.s TAdditionRate=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",16)
	.s TBillItemNo=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",17)
	.s TRegistrationNo=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",18)
	.s TExpenseRate=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",19)
	.s TDisposableFlag=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",20)
	.i TDisposableFlag'="" s TDisposableFlag=##Class(web.DHCEQCConsumableItem).GetDisposableFlag(TDisposableFlag)
	.d OutputRowGetConsumableItem
	quit
OutputRowGetConsumableItem
	s Data=$lb(TRowID,TDesc,TCode,TUnit,TPrice,TExType,TExID,TExDesc,TPayPrice,TRow,TChargeType,TExpenseType,TAdditionRate,TBillItemNo,TRegistrationNo,TExpenseRate,TDisposableFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetConsumableItem
	s (TRowID,TDesc,TCode,TUnit,TPrice,TExType,TExID,TExDesc,TPayPrice,TChargeType,TExpenseType,TAdditionRate,TBillItemNo,TRegistrationNo,TExpenseRate,TDisposableFlag)=""
	quit
}

ClassMethod GetConsumableItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumableItemExecute ]
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

/// modified by sjh SJH0041 2020-12-02 输出列标题修改
Query GetConsumableItem(Code As %String = "", Desc As %String = "", ExTypeDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String:描述,TCode:%String:编码,TUnit:%String:单位,TPrice:%String:单价,TExType:%String:对照类型,TExID:%String:对照ID,TExDesc:%String:对照描述,TPayPrice:%String:付款金额,TRow:%String,TChargeType:%String:收费类型,TExpenseType:%String:医保报销类型,TAdditionRate:%String:加成例,TBillItemNo:%String:收费项目编号,TRegistrationNo:%String:注册证号,TExpenseRate:%String:报销比例,TDisposableFlag:%String:一次性标志")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQCCode("DHCEQCConsumableItem",rowid))
	
	//扩展类型是DHC-ST的，到材料库取价格
	//add by kdf 2018-03-21 需求号568861;列表展示的单价都是从DHC_EQCConsumableItem中获取的，选中行后，展示的数据应该与列表数据保持一致。
	;i ($p(result,"^",5)="DHC-ST")&($p(result,"^",6)'="") d
	;.s consumableItemInfo=##Class(web.DHCEQ.Interface.DHCEQForST).GetConsumableItemInfo("DHC-ST",$p(result,"^",6))
	;.s $p(result,"^",4)=$p(consumableItemInfo,"^",3) //入库单位
	;.s $p(result,"^",3)=$p(consumableItemInfo,"^",4)
	;.s $p(result,"^",8)=$p(consumableItemInfo,"^",2)
	;.s $p(result,"^",1)=$p(consumableItemInfo,"^",2)
	;.s $p(result,"^",2)=$p(consumableItemInfo,"^",1)

	s resultex=resultex_"^"
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",4))
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

// add by sjh 2020-01-20 下拉列表取值

ClassMethod GetChargeType(ChargeType) As %String
{
	q $CASE(ChargeType,"1":"单独收费","2":"打包收费","3":"不 收 费",:"")
}

// add by sjh 2020-01-20 下拉列表取值

ClassMethod GetExpenseType(ExpenseType) As %String
{
	q $CASE(ExpenseType,"1":"医 保 报 销","2":"医保不报销","3":"医保部分报销",:"")
}

// add by sjh 2020-01-20 下拉列表取值

ClassMethod GetDisposableFlag(DisposableFlag) As %String
{
	q $CASE(DisposableFlag,"1":"是","2":"否",:"")
}

// add by sjh 2020-01-20 下拉列表

ClassMethod ChargeTypeList(name, width) As %String
{
		;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	
	w "<option value=></option>"
	w "<option value=1>单独收费</option>"
	w "<option value=2>打包收费</option>"
	w "<option value=3>不 收 费</option>"
	w "</select>",!
}

// add by sjh 2020-01-20 下拉列表

ClassMethod ExpenseTypeList(name, width) As %String
{
		;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	
	w "<option value=></option>"
	w "<option value=1>医 保 报 销</option>"
	w "<option value=2>医保不报销</option>"
	w "<option value=3>医保部分报销</option>"
	w "</select>",!
}

// add by sjh 2020-01-20 下拉列表

ClassMethod DisposableList(name, width, Type) As %String
{
		;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	
	w "<option value=></option>"
	w "<option value=1>是</option>"
	w "<option value=2>否</option>"
	w "</select>",!
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	//删除按钮操作,更新InvalidFlag标识.
 	s PLIST(8)="Y"
 	&SQL(Update SQLUSER.DHC_EQCConsumableItem Values :PLIST() where CI_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //Desc
 s desc=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //Code
 s code=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //Price
 s PLIST(5)=$P(val,"^",5) //Unit
 s PLIST(6)=$P(val,"^",6) //ExType
 s extype=$P(val,"^",6)
 s PLIST(7)=$P(val,"^",7) //ExID
 s exid=$P(val,"^",7)
 s PLIST(8)="N"
 s PLIST(9)=$P(val,"^",8) //Exdesc
 s PLIST(10)=$P(val,"^",9) //PayPrice  //add by zx 2014-09-16

 // add by sjh 2020-01-20  start
 s PLIST(15)=$P(val,"^",14) //ChargeType
 s PLIST(16)=$P(val,"^",15) //ExpenseType
 s PLIST(17)=$P(val,"^",16) //AdditionRate
 s PLIST(18)=$P(val,"^",17) //BillItemNo
 s PLIST(19)=$P(val,"^",18) //RegistrationNo
 s PLIST(20)=$P(val,"^",19) //ExpenseRate
 s PLIST(22)=$P(val,"^",20) //DisposableFlag
  // add by sjh 2020-01-20  end
  
 i (rowid="")  //新增按钮操作
 {
	 //检测当前记录是否已经存在
	 i exid=""
	 {
		 &SQL(select CI_RowID into :RowidFind from DHC_EQCConsumableItem where CI_InvalidFlag='N' and CI_Desc=:desc)
	 }
	 else
	 {
		 &SQL(select CI_RowID into :RowidFind from DHC_EQCConsumableItem where CI_InvalidFlag='N' and CI_Desc=:desc and CI_ExType=:extype and CI_ExID=:exid)
	 }
	 i (RowidFind="") //当前记录为新记录,否则已经存在
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQCConsumableItem Values :PLIST())
	 }
 }
 else  //更新按钮操作
 {
	 i exid=""
	 {
		 &SQL(select CI_RowID into :RowidFind from DHC_EQCConsumableItem where CI_InvalidFlag='N' and CI_Desc=:desc)
	 }
	 else
	 {
		 &SQL(select CI_RowID into :RowidFind from DHC_EQCConsumableItem where CI_InvalidFlag='N' and CI_Desc=:desc and CI_ExType=:extype and CI_ExID=:exid)
	 }
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQCConsumableItem Values :PLIST() where CI_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQCConsumableItem Values :PLIST() where CI_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/*
移至web.DHCEQ.Interface.Inner.DHCEQSTFrom  JDL 2014-12-05
/// add by zy 2014-09-15  ZY0117
/// 从材料库中取材料最新进价
/// w ##Class(web.DHCEQCConsumableItem).GetConsumableItemInfo(8179)
ClassMethod GetConsumableItemInfo(incid)
{
	//s Loc=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s Loc=1
	i Loc="" q ""
	s Hospital=$p($g(^CTLOC(Loc)),"^",22)
	s IncCode=$p(^INCI(incid,1),"^",1) //材料code
	s IncDesc=$p(^INCI(incid,1),"^",2) //材料desc
	//s UomId=$p(^INCI(incid,1),"^",10) //基本单位
	s UomId=$p(^INCI(incid,3),"^",6) //入库单位
	s Price=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(incid,+$h,UomId,Hospital,"M")
	//s Price=##Class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(incid,+$h,UomId,Hospital,"M")
	//s prprice=##class(web.DHCSTPRICE).GetInciLRp(inci,puomdr) //入库单位进价(最后入库)  C/S版本的材料
	q IncCode_"^"_IncDesc_"^"_UomId_"^"_Price
}
*/
/// add by zy 2014-09-15  ZY0117
Query GetUseConsumableItemList(ExType As %String = "", ExID As %String = "", LocDR As %String = "", BeginDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String,TUnit:%String,TPrice:%String,TExType:%String,TExID:%String,TExDesc:%String")
{
}

ClassMethod GetUseConsumableItemListExecute(ByRef qHandle As %Binary, ExType As %String = "", ExID As %String = "", LocDR As %String = "", BeginDate As %String = "", EndDate As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCConsumableItem",rowid))  quit:rowid=""  d
	.d ResetVariablesGetUseConsumableItemList
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",7)
	.q:InvalidFlag="Y"
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",1)
	.q:(Desc'="")&&(TDesc'=Desc)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",2)
	.q:(Code'="")&&(TCode'=Code)
	.s TUnit=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",4)
	.i TUnit'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.s TPrice=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",3)
	.s TExType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",5)
	.q:(ExTypeDR'="")&&(TExType'=ExTypeDR)
	.s TExID=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",6)
	.s TExDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",8)
	.d OutputRowGetUseConsumableItemList
	Quit $$$OK
OutputRowGetUseConsumableItemList
	s Data=$lb(TRowID,TDesc,TCode,TUnit,TPrice,TExType,TExID,TExDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUseConsumableItemList
	s (TRowID,TDesc,TCode,TUnit,TPrice,TExType,TExID,TExDesc)=""
	quit
}

ClassMethod GetUseConsumableItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseConsumableItemListExecute ]
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

ClassMethod GetUseConsumableItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseConsumableItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2014-09-15  ZY0117
/// w ##Class(web.DHCEQCConsumableItem).InsertConsumableItemByExID("DHC-ST",8178)
ClassMethod InsertConsumableItemByExID(ExType, ExID)
{
	///消耗项目明细
	new PCILIST,Code,Desc,Price,UomDR,tmpid
	k PCILIST
	i ExType="DHC-ST"
	{
		s Code=$p($g(^INCI(ExID,1)),"^",1)  ;Code
		s Desc=$p($g(^INCI(ExID,1)),"^",2)  ;Desc
		s Price=##Class(web.DHCEQ.Interface.DHCEQForST).GetConsumableItemInfo(ExType,ExID)
		s Price=$p(Price,"^",4)  			;Price
		s UomDR=$p($g(^INCI(ExID,1)),"^",10)  ;UomDR
	}
	q:ExType'="DHC-ST"
	s PCILIST(2)=Desc			;Desc
	s PCILIST(3)=Code			;Code
	s PCILIST(4)=Price			;Price
	s PCILIST(5)=UomDR			;UomDR
	s PCILIST(6)="DHC-ST"		;ExType 
	s PCILIST(7)=ExID			;ExID
	s PCILIST(8)="N"			;InvalidFlag
	s PCILIST(9)=Desc			;ExDesc 
	
	s (tmpid)=""
	&SQL(Select CI_RowID into :tmpid  from sqluser.DHC_EQCConsumableItem where CI_ExType=:ExType and CI_ExID=:ExID and CI_InvalidFlag<>'Y')
	i tmpid=""  d
	.&SQL(Insert Into SQLUSER.DHC_EQCConsumableItem Values :PCILIST())
	.s tmpid=$G(%ROWID)
	e  d
	.&SQL(update SQLUSER.DHC_EQCConsumableItem Values :PCILIST() where CI_RowID=:tmpid)
	quit tmpid
}

/*
移至web.DHCEQ.Interface.Inner.DHCEQSTFrom  JDL 2014-12-05
/// add by zy 2014-09-15  ZY0117
/// d ##class(%ResultSet).RunQuery("web.DHCEQCConsumableItem","GetIncItmList","AB")
Query GetIncItmList(Code As %String = "") As %Query(ROWSPEC = "TDesc:%String,TCode:%String,hidden:%String,TUnit:%String,TPrice:%String,hidden:%String,TExID:%String,hidden:%String")
{
}

ClassMethod GetIncItmListExecute(ByRef qHandle As %Binary, Code As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0) 	
 	Set Code=$ZCONVERT(Code,"U")
 	i Code="" Quit $$$OK
	s index=1
	//^INCALIAS(0,"INCI",{INCA_INCI_DR},{INCA_ROWID})
	s IncId=0
	f  s IncId=$o(^INCALIAS(0,"INCI",IncId))  quit:IncId=""  d
	.s Alias=0
	.s FindFlag=0
	.f  s Alias=$o(^INCALIAS(0,"INCI",IncId,Alias))  quit:Alias=""  d
	..q:$p($g(^INCALIAS(Alias)),"^",4)'[Code
	..s FindFlag=1
	.q:FindFlag=0
	.d ResetVariablesGetIncItmList
	.s ConsumableItemInfo=##Class(web.DHCEQCConsumableItem).GetConsumableItemInfo(IncId)
	.s TDesc=$p(ConsumableItemInfo,"^",2)
	.s TCode=$p(ConsumableItemInfo,"^",1)
	.s TUnitDR=$p(ConsumableItemInfo,"^",3)
	.i TUnitDR'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TPrice=$p(ConsumableItemInfo,"^",4)
	.s TExType="DHC-ST"
	.s TExID=IncId
	.s TExDesc=$p(ConsumableItemInfo,"^",2)
	.d OutputRowGetIncItmList
	Quit $$$OK
OutputRowGetIncItmList
	s Data=$lb(TDesc,TCode,TUnitDR,TUnit,TPrice,TExType,TExID,TExDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetIncItmList
	s (TDesc,TCode,TUnitDR,TUnit,TPrice,TExType,TExID,TExDesc)=""
	quit
}

ClassMethod GetIncItmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncItmListExecute ]
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

ClassMethod GetIncItmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncItmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}
*/
}
