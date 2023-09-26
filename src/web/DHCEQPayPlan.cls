Class web.DHCEQPayPlan Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询付款计划
/// 入参：SourceType:来源类型 1:对应合同的付款计划,2:对应验收的付款计划
/// 		 SourceID:对应的业务ID
Query GetPayPlan(SourceType, SourceID) As %Query(ROWSPEC = "TSourceType:%String,TSourceID:%String,TRowID:%String,TDesc:%String,TPayType:%String,TDateType:%String,TPlanPayDate:%String,TPeriodNum:%String,TPeriodUnitDR:%String,TPayPercent:%String,TPayAmount:%String,TCondition:%String,TPayFlag:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TPeriod:%String,TRow:%String")
{
}

ClassMethod GetPayPlanExecute(ByRef qHandle As %Binary, SourceType, SourceID) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	s TSourceType=0
	f  s TSourceType=$o(^DHCEQPayPlan(0,"Source",TSourceType))  quit:TSourceType=""  d
	.q:((SourceType'="")&&(TSourceType'=SourceType))
	.s TSourceID=SourceID
	.i TSourceID>0 s TSourceID=TSourceID-1
	.f  s TSourceID=$o(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID))  quit:((TSourceID="")||((TSourceID>SourceID)&&(SourceID'="")))  d
	..q:(SourceID'="")&&(TSourceID'=SourceID)
	..s TRowID=0
	..f  s TRowID=$o(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID,TRowID))  quit:(TRowID="")  d
	...d ResetVariablesGetPayPlan
	...s TDesc=$p($g(^DHCEQPayPlan(TRowID)),"^",1)
	...;s TSourceType=$p($g(^DHCEQPayPlan(TRowID)),"^",2)
	...;s TSourceID=$p($g(^DHCEQPayPlan(TRowID)),"^",3)
	...s TPayType=$p($g(^DHCEQPayPlan(TRowID)),"^",4)
	...s TPayType=..GetPayTypeDisplay(TPayType)
	...s TDateType=$p($g(^DHCEQPayPlan(TRowID)),"^",5)
	...s TDateType=..GetDateTypeDisplay(TDateType)
	...s TPlanPayDate=$p($g(^DHCEQPayPlan(TRowID)),"^",6)
	...s TPlanPayDate=##class(web.DHCEQCommon).TransValueToPage(TPlanPayDate,"date")
	...s TPeriodNum=$p($g(^DHCEQPayPlan(TRowID)),"^",7)
	...s TPeriodUnitDR=$p($g(^DHCEQPayPlan(TRowID)),"^",8)
	...i TPeriodUnitDR'="" s TPeriod=TPeriodNum_$p($g(^DHCEQCCode("DHCEQCCycleUnit",TPeriodUnitDR)),"^",2)
	...s TPayPercent=$p($g(^DHCEQPayPlan(TRowID)),"^",9)
	...i TPayPercent'="" s TPayPercent=TPayPercent_"%"
	...s TPayAmount=$p($g(^DHCEQPayPlan(TRowID)),"^",10)
	...i TPayAmount'="" s TPayAmount=##Class(web.DHCEQCommon).FormatNumber(TPayAmount,"",2)
	...s TCondition=$p($g(^DHCEQPayPlan(TRowID)),"^",11)
	...s TPayFlag=$p($g(^DHCEQPayPlan(TRowID)),"^",12)
	...i TPayFlag'="" s TPayFlag=..GetPayFlagDisplay(TPayFlag)
	...s TRemark=$p($g(^DHCEQPayPlan(TRowID)),"^",13)
	...s THold1=$p($g(^DHCEQPayPlan(TRowID)),"^",14)
	...s THold2=$p($g(^DHCEQPayPlan(TRowID)),"^",15)
	...s THold3=$p($g(^DHCEQPayPlan(TRowID)),"^",16)
	...s THold4=$p($g(^DHCEQPayPlan(TRowID)),"^",17)
	...s THold5=$p($g(^DHCEQPayPlan(TRowID)),"^",18)
	...d OutputRowGetPayPlan
	;##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(rowid)),"^",1),"date")
	Quit $$$OK
	
OutputRowGetPayPlan
	s TRow=TRow+1
	s Data=$lb(TSourceType,TSourceID,TRowID,TDesc,TPayType,TDateType,TPlanPayDate,TPeriodNum,TPeriodUnitDR,TPayPercent,TPayAmount,TCondition,TPayFlag,TRemark,THold1,THold2,THold3,THold4,THold5,TPeriod,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPayPlan
	s (TDesc,TPayType,TDateType,TPlanPayDate,TPeriodNum,TPeriodUnitDR,TPayPercent,TPayAmount,TCondition,TPayFlag,TRemark,THold1,THold2,THold3,THold4,THold5,TPeriod)=""
	quit
}

ClassMethod GetPayPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayPlanExecute ]
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

ClassMethod GetPayPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 保存付款计划
ClassMethod UpdateData(Val)
{
	Set $ZT="ERROR"
	
	s RowID=$P(Val,"^",1)	;RowID
	s PLIST(2)=$P(Val,"^",2) ;Desc
	s PLIST(3)=$P(Val,"^",3) ;SourceType
	s PLIST(4)=$P(Val,"^",4) ;SourceID
	s PLIST(5)=$P(Val,"^",5) ;PayType
	s PLIST(6)=$P(Val,"^",6) ;DateType
	i PLIST(6)="" s PLIST(6)=1	// MZY0058	1558051		2020-10-18	确定日期
	s PLIST(7)=$P(Val,"^",7) ;PlanPayDate
	s PLIST(7)=##class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",7),"date")
	s PLIST(8)=$P(Val,"^",8) ;PeriodNum
	s PLIST(9)=$P(Val,"^",9) ;PeriodUnitDR
	s PLIST(10)=$P(Val,"^",10) ;PayPercent
	s PLIST(11)=$P(Val,"^",11) ;PayAmount
	s PLIST(12)=$P(Val,"^",12) ;Condition
	s PLIST(13)=$P(Val,"^",13) ;PayFlag
	s PLIST(14)=$P(Val,"^",14) ;Remark
	s PLIST(15)=$P(Val,"^",15) ;Hold1
	s PLIST(16)=$P(Val,"^",16) ;Hold2
	s PLIST(17)=$P(Val,"^",17) ;Hold3
	s PLIST(18)=$P(Val,"^",18) ;Hold4
	s PLIST(19)=$P(Val,"^",19) ;Hold5
	
	TSTART
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQPayPlan values :PLIST())
		s RowID=$G(%ROWID)
	}
	else
	{
		&SQL(update sqluser.DHC_EQPayPlan values :PLIST() where PP_RowID=:RowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	if (..CheckPayPlan($P(Val,"^",3), $P(Val,"^",4))="-2")
	{
		TROLLBACK
		q -1010
	}
 	TCOMMIT
 	q SQLCODE_"^"_RowID
ERROR
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "^ERROR"_ErrorMsg     	 //返回错误消息 ;
}

/// 删除付款计划
/// 入参：RowID:付款计划ID
/// 		  SourceType:来源类型 1:对应合同的付款计划,2:对应验收的付款计划
/// 		  SourceID:对应的业务ID
/// 返回：0:操作成功
/// 		 其他：操作失败,返回SQLCODE	
ClassMethod DeleteData(RowID, SourceType As %Library.String = "", SourceID As %Library.String = "")
{
	i RowID'=""
	{
		&SQL(delete from sqluser.DHC_EQPayPlan where PP_RowID=:RowID)
		q SQLCODE
	}
	else
	{		
		if (SourceType="")||(SourceID="") q -1001
		&SQL(delete from sqluser.DHC_EQPayPlan where PP_SourceType=:SourceType and PP_SourceID=:SourceID)
		if SQLCODE=100 q 0
		q SQLCODE
	}
}

/// 根据付款计划ID获取付款计划信息
ClassMethod GetPayPlanByRowID(rowid)
{
	new result
	s (result,resultex)=""
	s result=$g(^DHCEQPayPlan(rowid))
	
	s resultex=resultex_"^"	;PayType
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_..GetPayTypeDisplay($p(result,"^",4))
	s resultex=resultex_"^"	;DateType
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_..GetDateTypeDisplay($p(result,"^",5))
	s resultex=resultex_"^"	;PlanPayDate
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")
	s resultex=resultex_"^"	;PeriodUnitDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCycleUnit",$p(result,"^",8))),"^",2)
	s resultex=resultex_"^"	;PayFlag
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_..GetPayFlagDisplay($p(result,"^",12))
	
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 解析付款类型
ClassMethod GetPayTypeDisplay(PayType As %Library.String) As %Status
{
	i PayType=""  q ""
	i PayType="0" q "全款"	
	i +PayType="1"  q "预付款"
	i +PayType="2"  q "尾款"
	i +PayType="3"  q "期款"
	
	q "未定义"
}

/// 解析付款时间类型
/// 1:指定日期 2:相对验收日期  3:相对入库日期
ClassMethod GetDateTypeDisplay(DateType As %Library.String) As %Status
{
	i +DateType="1"  q "确定日期"
	i +DateType="2"  q "相对日期(验收日期)"
	i +DateType="3"  q "相对日期(入库日期)"	
	q "未定义"
}

/// 解析付款标志
/// 0:未付 1:已付 2:部分支付
ClassMethod GetPayFlagDisplay(PayFlag As %Library.String) As %Status
{
	i +PayFlag="0"  q "未付"
	i +PayFlag="1"  q "已付"
	i +PayFlag="2"  q "部分支付"
	q "未定义"
}

/// 输出付款类型 下拉框
/// -------------------------------
ClassMethod CreateCboPayType(name, width) As %String
{
	;;下拉列表
	;modify by lmm 2019-09-05 修改下拉列表必填提示
	;w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	//add by csj 20180903 hisui下拉列表调整
	if (width="")||(width=0) s width=155	//modified by czf 20181211
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;;' class='hisui-combobox' data-required=true data-options="""_"prompt:"_"'必填项'"_""">"
	
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=>"_..GetPayTypeDisplay("")_"</option>"
	w "<option value=0>"_..GetPayTypeDisplay("0")_"</option>"
	w "<option value=1>"_..GetPayTypeDisplay("1")_"</option>"
	w "<option value=2>"_..GetPayTypeDisplay("2")_"</option>"
	w "<option value=3>"_..GetPayTypeDisplay("3")_"</option>"
	w "</select>",!
}

/// 输出付款时间类型 下拉框
/// -------------------------------
ClassMethod CreateCboDateType(name, width) As %String
{
	;;下拉列表
	;modify by lmm 2019-09-05 修改下拉列表必填提示
	;w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	//add by csj 20180903 hisui下拉列表调整
	if (width="")||(width=0) s width=155	//modified by czf 20181211
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;;' class='hisui-combobox' data-required=true data-options="""_"prompt:"_"'必填项'"_""">"
	w "<option value=></option>"
	w "<option value=1>"_..GetDateTypeDisplay("1")_"</option>"
	;;Mozy	884926	2019-5-22
	;w "<option value=2>"_..GetDateTypeDisplay("2")_"</option>"
	;w "<option value=3>"_..GetDateTypeDisplay("3")_"</option>"
	w "</select>",!
}

/// 输出付款标志 下拉框
/// 入参：
/// name:界面元素名字
/// width:生成下拉框的宽度
/// -------------------------------
ClassMethod CreateCboPayFlag(name, width) As %String
{
	;;下拉列表
	;modify by lmm 2019-09-05 修改下拉列表必填提示
	;w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	//add by csj 20180903 hisui下拉列表调整
	if (width="")||(width=0) s width=155	//modified by czf 20181211
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;;' class='hisui-combobox' data-required=true data-options="""_"prompt:"_"'必填项'"_""">"
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>"_..GetPayFlagDisplay("0")_"</option>"
	w "<option value=1>"_..GetPayFlagDisplay("1")_"</option>"
	w "<option value=2>"_..GetPayFlagDisplay("2")_"</option>"
	w "</select>",!
}

/// 检测付款计划的数据是否合乎逻辑
/// 入参：SourceType:来源类型 1:对应合同的付款计划,2:对应验收的付款计划
/// 		 SourceID:对应的业务ID
/// 返回: 0:正常
/// 		其他异常 -1:参数有为空
/// 				 -2:付款比例合计大于100%
/// 				 -3:付款比例不足100%
ClassMethod CheckPayPlan(SourceType, SourceID)
{
	new TRowID,PayPercent
	if (SourceType="")||(SourceID="") q -1002	
	s PayPercent=0
	
	s TRowID=0
	f  s TRowID=$o(^DHCEQPayPlan(0,"Source",SourceType,SourceID,TRowID))  quit:(TRowID="")  d
	.;s TPayType=$p($g(^DHCEQPayPlan(TRowID)),"^",4)
	.;s TDateType=$p($g(^DHCEQPayPlan(TRowID)),"^",5)
	.;s TPlanPayDate=$p($g(^DHCEQPayPlan(TRowID)),"^",6)
	.;s TPeriodNum=$p($g(^DHCEQPayPlan(TRowID)),"^",7)
	.;s TPeriodUnitDR=$p($g(^DHCEQPayPlan(TRowID)),"^",8)
	.;i TPeriodUnitDR'="" s TPeriod=TPeriodNum_$p($g(^DHCEQCCode("DHCEQCCycleUnit",TPeriodUnitDR)),"^",2)
	.s PayPercent=PayPercent+$p($g(^DHCEQPayPlan(TRowID)),"^",9)
	
	if (PayPercent>100) q -2
	if (PayPercent<100) q -3
	
	q 0
}

/// 查询付款计划
/// 入参：SourceType:来源类型 1:入库明细
/// 		 SourceID:对应的业务ID
Query ShortPayPlan(SourceType, SourceID, ISLRowID, Desc) As %Query(ROWSPEC = "HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TPayPercent:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TRemark:%String,HIDDEN:%String,TSourceTypeDesc:%String,TSourceDesc:%String")
{
}

ClassMethod ShortPayPlanExecute(ByRef qHandle As %Binary, SourceType, SourceID, ISLRowID, Desc) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	i (ISLRowID="")
	{
		s TSourceType=""
		f  s TSourceType=$o(^DHCEQPayPlan(0,"Source",TSourceType))  quit:(TSourceType="")  d
		.q:(SourceType'="")&&(TSourceType'=SourceType)
		.s TSourceTypeDesc=..GetSourceTypeDisplay(TSourceType)
		.s TSourceID=0
		.f  s TSourceID=$o(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID))  quit:(TSourceID="")  d
		..q:(SourceID'="")&&(TSourceID'=SourceID)
		..s TSourceDesc=..GetSourceDisplay(TSourceType,TSourceID)
		..s TSourceDesc=$p(TSourceDesc,"^",1)
		..s TRowID=0
		..f  s TRowID=$o(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID,TRowID))  quit:(TRowID="")  d
		...d ResetVariablesShortPayPlan
		...d FillDataShortPayPlan
		Quit $$$OK
	}
	else
	{
		;当为入库明细时,取入库明细对应的验收的明细ID
		s TSourceType=$p(^DHCEQInStockList(ISLRowID),"^",18)
		s TSourceID=$P(^DHCEQInStockList(ISLRowID),"^",19)
		;非来自验收单的,返回
		i TSourceType'=2 Quit $$$OK
		
		;如果验收单没有对应的付款计划时,取验收单对应的合同是否有付款计划
		i '$d(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID))
		{			
			s TSourceType=$p(^DHCEQOpenCheckList(TSourceID),"^",63) 
			;非来自于合同的,返回
			i TSourceType'=1 Quit $$$OK
			s TSourceID=$p(^DHCEQOpenCheckList(TSourceID),"^",64)			
		}		

		s TSourceTypeDesc=..GetSourceTypeDisplay(TSourceType)
		s TSourceDesc=..GetSourceDisplay(TSourceType,TSourceID)
		s TSourceDesc=$p(TSourceDesc,"^",1)
		s TRowID=0
		f  s TRowID=$o(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID,TRowID))  quit:(TRowID="")  d
		.d ResetVariablesShortPayPlan
		.d FillDataShortPayPlan
	}
	;##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(rowid)),"^",1),"date")
	Quit $$$OK
FillDataShortPayPlan
	s TDesc=$p($g(^DHCEQPayPlan(TRowID)),"^",1)
	s TPayType=$p($g(^DHCEQPayPlan(TRowID)),"^",4)
	s TPayType=..GetPayTypeDisplay(TPayType)
	s TDateType=$p($g(^DHCEQPayPlan(TRowID)),"^",5)
	s TDateType=..GetDateTypeDisplay(TDateType)
	s TPlanPayDate=$p($g(^DHCEQPayPlan(TRowID)),"^",6)
	s TPlanPayDate=##class(web.DHCEQCommon).TransValueToPage(TPlanPayDate,"date")
	s TPeriodNum=$p($g(^DHCEQPayPlan(TRowID)),"^",7)
	s TPeriodUnitDR=$p($g(^DHCEQPayPlan(TRowID)),"^",8)
	i TPeriodUnitDR'="" s TPeriod=TPeriodNum_$p($g(^DHCEQCCode("DHCEQCCycleUnit",TPeriodUnitDR)),"^",2)
	s TPayPercent=$p($g(^DHCEQPayPlan(TRowID)),"^",9)
	i TPayPercent'="" s TPayPercent=TPayPercent_"%"
	s TPayAmount=$p($g(^DHCEQPayPlan(TRowID)),"^",10)
	i TPayAmount'="" s TPayAmount=##Class(web.DHCEQCommon).FormatNumber(TPayAmount,"",2)
	s TCondition=$p($g(^DHCEQPayPlan(TRowID)),"^",11)
	s TPayFlag=$p($g(^DHCEQPayPlan(TRowID)),"^",12)
	i TPayFlag'="" s TPayFlag=..GetPayFlagDisplay(TPayFlag)
	s TRemark=$p($g(^DHCEQPayPlan(TRowID)),"^",13)
	s THold1=$p($g(^DHCEQPayPlan(TRowID)),"^",14)
	s THold2=$p($g(^DHCEQPayPlan(TRowID)),"^",15)
	s THold3=$p($g(^DHCEQPayPlan(TRowID)),"^",16)
	s THold4=$p($g(^DHCEQPayPlan(TRowID)),"^",17)
	s THold5=$p($g(^DHCEQPayPlan(TRowID)),"^",18)
	d OutputRowShortPayPlan
	quit
OutputRowShortPayPlan	
	s Data=$lb(TSourceType,TSourceID,TRowID,TDesc,TPayType,TDateType,TPlanPayDate,TPeriodNum,TPeriodUnitDR,TPayPercent,TPayAmount,TCondition,TPayFlag,TRemark,TPeriod,TSourceTypeDesc,TSourceDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesShortPayPlan
	s (TDesc,TPayType,TDateType,TPlanPayDate,TPeriodNum,TPeriodUnitDR,TPayPercent,TPayAmount,TCondition,TPayFlag,TRemark,THold1,THold2,THold3,THold4,THold5,TPeriod)=""
	quit
}

ClassMethod ShortPayPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ShortPayPlanExecute ]
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

ClassMethod ShortPayPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ShortPayPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 解析付款计划的来源类型
ClassMethod GetSourceTypeDisplay(SourceType As %Library.String) As %Status
{
	i SourceType="1" q "合同"	
	i SourceType="2"  q "验收单"
	
	q "未定义"
}

/// 解析付款计划的来源类型
ClassMethod GetSourceDisplay(SourceType As %Library.String, SourceID As %Library.String) As %Status
{
	n ParID,ParName,No,EquipName,ProviderDR
	s (ParID,ParName,No,EquipName,ProviderDR)=""
	i SourceID="" q ""
	i SourceType="1"	;"合同"
	{
		s EquipName=$p(^DHCEQContractList(SourceID),"^",2)
		s ParID=$p(^DHCEQContractList(SourceID),"^",1)
		i ParID'=""
		{
			s ParName=$p(^DHCEQContract(ParID),"^",1)
			s No=$p(^DHCEQContract(ParID),"^",2)
			Set ProviderDR=$Piece(^DHCEQContract(ParID),"^",18)
		}
	}
	elseif  (SourceType="2")	;"验收单"
	{
		s EquipName=$p(^DHCEQOpenCheckList(SourceID),"^",2)
		s ParID=$p(^DHCEQOpenCheckList(SourceID),"^",1)
		i ParID'=""
		{
			;s ParName=$p(^DHCEQContract(ParID),"^",1)
			;s No=$p(^DHCEQContract(ParID),"^",2)
			Set ProviderDR=$Piece(^DHCEQOpenCheckRequest(ParID),"^",5)
		}
	}
	
	q EquipName_"^"_ParID_"^"_ParName_"^"_No_"^"_ProviderDR
}

/// 20140429  Mozy0129
/// 获取(生成)付款计划明细记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQPayPlan","GetPayPlanDetail","")
Query GetPayPlanDetail(Data As %Library.String = "") As %Query(ROWSPEC = "TJob:%String,TRowID:%String,TItem:%String,TDesc:%String,TPayType:%String,TDateType:%String,TPayDate:%String,TFee:%String,TPayAmount:%String,TPayPercent:%String,TProvider:%String,TCondition:%String,TPayFlag:%String,TRemark:%String,TModel:%String,TUnit:%String,TUseLoc:%String,TOriginalFee:%String,TQuantity:%String,TEquipType:%String,TStatCat:%String")
{
}

ClassMethod GetPayPlanDetailExecute(ByRef qHandle As %Binary, Data As %Library.String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	Set TJob=$job
 	Kill ^DHCEQTemp("PayPlanDetail",+$H,TJob)
	
 	Set Data=##Class(web.DHCEQCommon).UnEscape(Data)
 	Set Desc=$ZCONVERT(##Class(web.DHCEQCommon).GetDataByName(Data,"Desc"),"U")
 	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(Data,"StartDate")
 	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(Data,"EndDate")
 	Set PayType=##Class(web.DHCEQCommon).GetDataByName(Data,"PayType")
 	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(Data,"ProviderDR")
	Set PayAmount=##Class(web.DHCEQCommon).GetDataByName(Data,"PayAmount")
	Set MaxAmount=##Class(web.DHCEQCommon).GetDataByName(Data,"MaxAmount")
	Set StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	Set EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	
 	Set rowid=0
 	For  Set rowid=$Order(^DHCEQPayPlan(rowid)) Quit:rowid=""  Do
 	.Do ResetVariablesGetPayPlanDetail
 	.Set TRowID=rowid
 	.//检测该业务单对应付款记录是否都已经全部付款完成
 	.;s SourceTypeDR=$p($g(^DHCEQPayRecord(RowID)),"^",15)
	.;s SourceID=$p($g(^DHCEQPayRecord(RowID)),"^",16)
	.;s SQLCODE=..CheckPayFinish(RowID,SourceTypeDR,SourceID)
 	.;Quit:SQLCODE
 	.
 	.Set TDesc=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",1)
 	.Quit:(Desc'="")&(TDesc'[Desc)
 	.Set TSourceType=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",2)
 	.Set TSourceID=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",3)
 	.Set Source=##Class(web.DHCEQPayPlan).GetSourceDisplay(TSourceType,TSourceID)
 	.If TSourceType=2 Do
 	..Set TItem=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",2)
 	..Set TEquipType=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",3)
 	..If TEquipType'="" Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipType)
 	..Set TModelDR=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",5)
 	..If TModelDR'="" Set TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
 	..Set TUnitDR=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",7)
 	..If TUnitDR'="" Set TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	..Set TQuantity=+$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",16)
 	..Set TOriginalFee=+$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",17)
 	..Set TStatCat=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",28)
 	..If TStatCat'="" Set TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCat)
 	..Set TUseLocDR=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",33)
 	..If TUseLocDR'="" Set TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	..If TUseLoc'="" Set TUseLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag(TUseLoc,"-")
 	..Set TFee=TOriginalFee*TQuantity
 	..If TFee'="" Set TFee=##Class(web.DHCEQCommon).FormatNumber(TFee,"",2)
 	.Set TProviderDR=$Piece(Source,"^",5)
 	.Quit:TProviderDR=""
 	.Quit:(ProviderDR'="")&(TProviderDR'=ProviderDR)
 	.If TProviderDR'="" Set TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.If TProvider'="" Set TProvider=##Class(web.DHCEQCommon).GetSplitDataByFlag(TProvider,"-")
	.Set TPayType=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",4)
	.Quit:(PayType'="")&(PayType'=TPayType)
	.Set TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayType)
	.Set TDateType=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",5)
	.Set TDateType=##Class(web.DHCEQPayPlan).GetDateTypeDisplay(TDateType)
	.Set TPayDate=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",6)
	.Quit:(StartDate'="")&(StartDate>TPayDate)
	.Quit:(EndDate'="")&(EndDate<TPayDate)
	.Set TPayDate=##Class(web.DHCEQCommon).TransValueToPage(TPayDate,"date")
	.;s TPeriodNum=$p($g(^DHCEQPayPlan(TRowID)),"^",7)
	.;s TPeriodUnitDR=$p($g(^DHCEQPayPlan(TRowID)),"^",8)
	.;i TPeriodUnitDR'="" s TPeriod=TPeriodNum_$p($g(^DHCEQCCode("DHCEQCCycleUnit",TPeriodUnitDR)),"^",2)
	.
	.Set TPayPercent=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",9)
	.If TPayPercent'="" Set TPayPercent=TPayPercent_"%"
	.Set TPayAmount=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",10)
	.If TPayAmount'="" Set TPayAmount=##Class(web.DHCEQCommon).FormatNumber(TPayAmount,"",2)
	.Set TCondition=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",11)
	.Set TPayFlag=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",12)
	.If TPayFlag'="" Set TPayFlag=##Class(web.DHCEQPayPlan).GetPayFlagDisplay(TPayFlag)
	.Set TRemark=$Piece($Get(^DHCEQPayPlan(TRowID)),"^",13)
	.
 	.Do OutputRowGetPayPlanDetail
 	
 	Quit $$$OK
	
OutputRowGetPayPlanDetail
	Set Data=$lb(TJob,TRowID,TItem,TDesc,TPayType,TDateType,TPayDate,TFee,TPayAmount,TPayPercent,TProvider,TCondition,TPayFlag,TRemark,TModel,TUnit,TUseLoc,TOriginalFee,TQuantity,TEquipType,TStatCat)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("PayPlanDetail",+$H,TJob,TRowID)=TItem_"^"_TDesc_"^"_TPayType_"^"_TDateType_"^"_TPayDate_"^"_TFee_"^"_TPayAmount_"^"_TPayPercent_"^"_TProvider_"^"_TCondition_"^"_TPayFlag_"^"_TRemark_"^"_TModel_"^"_TUnit_"^"_TUseLoc_"^"_TOriginalFee_"^"_TQuantity_"^"_TEquipType_"^"_TStatCat
	
	Quit
ResetVariablesGetPayPlanDetail
	Set (TRowID,TItem,TDesc,TPayType,TDateType,TPayDate,TFee,TPayAmount,TPayPercent,TProvider,TCondition,TPayFlag,TRemark,TModel,TUnit,TUseLoc,TOriginalFee,TQuantity,TEquipType,TStatCat)=""
	
	Quit
}

ClassMethod GetPayPlanDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayPlanDetailExecute ]
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

ClassMethod GetPayPlanDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayPlanDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCEQPayPlan).GetList(3156,5)
ClassMethod GetList(job As %Library.String = "", gnum As %Library.String = "", rows As %Library.String = "")
{
	If (job="")||(gnum="") Quit ""
	Set str=^DHCEQTemp("PayPlanDetail",+$H,job,gnum)
	if rows'=""
	{
		for i=1:1:rows-1
		{
			Set str=str_$c(2)_^DHCEQTemp("PayPlanDetail",+$H,job,gnum+i)
		}
	}
  	Quit str
}

/// w ##class(web.DHCEQPayPlan).SetTotalData(1464,"1^3^4^5^9^10")
ClassMethod SetTotalData(job As %Library.String = "", rowids As %Library.String = "")
{
	If (job="")||(rowids="") Quit 0
	If ('$Data(^DHCEQTemp("PayPlanDetail",+$H,job))) Quit 0
	Set rowids="^"_rowids_"^"
	
	;汇总明细
	Kill ^DHCEQTemp("tmpPayPlanTotal",+$H,job)
	Set rowid=0
 	For  Set rowid=$Order(^DHCEQTemp("PayPlanDetail",+$H,job,rowid)) Quit:rowid=""  Do
	.Quit:(rowids'[("^"_rowid_"^"))
	.Set Provider=$Piece($Get(^DHCEQTemp("PayPlanDetail",+$H,job,rowid)),"^",9)
	.Set EquipType=$Piece($Get(^DHCEQTemp("PayPlanDetail",+$H,job,rowid)),"^",18)
	.Set SataCat=$Piece($Get(^DHCEQTemp("PayPlanDetail",+$H,job,rowid)),"^",19)
	.Set Quantity=$Piece($Get(^DHCEQTemp("PayPlanDetail",+$H,job,rowid)),"^",17)
	.Set Percent=$Piece($Get(^DHCEQTemp("PayPlanDetail",+$H,job,rowid)),"^",8)
	.Set Fee=$Piece($Get(^DHCEQTemp("PayPlanDetail",+$H,job,rowid)),"^",6)
	.Set PayAmount=$Piece($Get(^DHCEQTemp("PayPlanDetail",+$H,job,rowid)),"^",7)
	.If '($Data(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent))) Do
	..Set ^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent)=Quantity_"^"_Fee_"^"_PayAmount
	.Else  Do
	..Set $Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",1)=+$Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",1)+Quantity
	..Set $Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",2)=+$Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",2)+Fee
	..Set $Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",3)=+$Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",3)+PayAmount
	
	;生成打印信息
	Kill ^DHCEQTemp("PayPlanTotal",+$H,job)
	Set index=1
	Set tmpQuantity=0
	Set tmpFee=0
	Set tmpPayAmount=0
	Set Provider=""
 	For  Set Provider=$Order(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider)) Quit:Provider=""  Do
	.Set EquipType=""
 	.For  Set EquipType=$Order(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType)) Quit:EquipType=""  Do
	..Set SataCat=""
 	..For  Set SataCat=$Order(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat)) Quit:SataCat=""  Do
	...Set Percent=""
 	...For  Set Percent=$Order(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent)) Quit:Percent=""  Do
	....Set Quantity=+$Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",1)
	....Set Fee=+$Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",2)
	....Set PayAmount=+$Piece(^DHCEQTemp("tmpPayPlanTotal",+$H,job,Provider,EquipType,SataCat,Percent),"^",3)
	....Set tmpQuantity=tmpQuantity+Quantity
	....Set tmpFee=tmpFee+Fee
	....Set tmpPayAmount=tmpPayAmount+PayAmount
	....Set ^DHCEQTemp("PayPlanTotal",+$H,job,index)=Provider_"^"_EquipType_"^"_SataCat_"^"_Quantity_"^"_Fee_"^"_Percent_"^"_PayAmount
	....Set index=index+1
	....Set ^DHCEQTemp("PayPlanTotal",+$H,job,index)="小计:^^^"_Quantity_"^"_Fee_"^"_Percent_"^"_PayAmount
	....Set index=index+1
	.Set ^DHCEQTemp("PayPlanTotal",+$H,job,index)="合计:^^^"_tmpQuantity_"^"_tmpFee_"^"_Percent_"^"_tmpPayAmount
	
	Kill ^DHCEQTemp("tmpPayPlanTotal",+$H,job)
  	Quit index
}

/// w ##class(web.DHCEQPayPlan).GetList(3156,5)
ClassMethod GetTotalList(job As %Library.String = "", gnum As %Library.String = "", rows As %Library.String = "")
{
	If (job="")||(gnum="") Quit ""
	Set str=^DHCEQTemp("PayPlanTotal",+$H,job,gnum)
	if rows'=""
	{
		for i=1:1:rows-1
		{
			Set str=str_$c(2)_^DHCEQTemp("PayPlanTotal",+$H,job,gnum+i)
		}
	}
  	Quit str
}

ClassMethod GetSourceAmount(vSourceType As %String = "", vSourceID As %String = "")
{
	i vSourceType=1
	{
		i vSourceID'=""
		{
			s CTAmount=$p($g(^DHCEQContract(vSourceID)),"^",4)
			s CTAmount=##Class(web.DHCEQCommon).FormatNumber(CTAmount)
			q CTAmount
		}
	}
	//1 合同 2验收
	i vSourceType="2"
	{
		i vSourceID'=""
		{
			s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",vSourceID,0))
			s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
			s OCLOriginalFee=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17)
			s OCLAmount=##Class(web.DHCEQCommon).FormatNumber(OCLNum*OCLOriginalFee)
			q OCLAmount
		}
	}
	q 0
}

}
