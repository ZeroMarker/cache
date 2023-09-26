Import SQLUser

/// 创建:zy 2010-07-22    No ZY0026
/// ----------------------------------
Class web.DHCEQDepreSet Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 132;

// 设备折旧设置表

Parameter SQLCODE = "DS_RowID";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "DS_RowID";

Parameter SQLROWID = "DS_RowID";

/// w ##Class(web.DHCEQDepreSet).SaveData("10544^^1^^^^0^asdf^1^1^0^3006^^^8^^^^^","0","1")
/// ////////////////////
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "", type As %Library.String = "")
{
 	new (val,isDel,type)
 	s rowid=$p(val,"^",1)
 	s MainFlag=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"bool")
 	s AutoFlag=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")
 	s AutoAudit=$p(val,"^",21)
 	b //isdel
 	if (+isDel=1)  //删除
 	{
	 	i (MainFlag'="Y")
	 	{
 			&SQL(Delete From SQLUSER.DHC_EQDepreSet where DS_RowID= :rowid)
	 	}
 		if SQLCODE  q SQLCODE
 		q rowid
 	}
 	elseif  (+isDel=0)  //更新
 	{
	 	s tmpid=""
	 	s flag=0
 		s PLIST(2) = $p(val,"^",2)				;设备
 		s PLIST(3) = $p(val,"^",3)				;折旧方法
 		s DepreMethodDR=$p(val,"^",3)
 		s PLIST(4) = MainFlag					;主标志
 		s PLIST(5) = AutoFlag 					;自动记入折旧标志
 		s PLIST(6) = $p(val,"^",6)				;上次折旧月份
 		s PLIST(7) = $p(val,"^",7)				;成本分配类型
 		s CostAllotType=$p(val,"^",7)
 		s PLIST(9) = $p(val,"^",8)				;备注
 		s PLIST(10) = "0"						;status
 		s PLIST(20) = $p(val,"^",10)			;DepreTypeDR
 		s DepreTypeDR=$p(val,"^",10)
 		s PLIST(21) = $p(val,"^",11)			;SourceType
 		s SourceType=$p(val,"^",11)
 		s PLIST(22) = $p(val,"^",12)			;SourceID
 		s SourceID=$p(val,"^",12)
 		s PLIST(23) = $p(val,"^",13)			;DepreTotal
 		s PLIST(24) = $p(val,"^",14)			;DepreTotalFee
 		s PLIST(25) = $p(val,"^",15)			;Years
 		s PLIST(26) = $p(val,"^",16)			;hold1
 		s PLIST(27) = $p(val,"^",17)			;hold2
 		s PLIST(28) = $p(val,"^",18)			;hold3
 		s PLIST(29) = $p(val,"^",19)			;hold4
 		s PLIST(30) = $p(val,"^",20)			;hold5
 		i (type="1")
 		{
	 		s preDepreMethodDR=$p($g(^DHCEQDepreSet(rowid)),"^",2)
	 		s preCostAllotType=$p($g(^DHCEQDepreSet(rowid)),"^",6)
	 		i (DepreMethodDR=preDepreMethodDR)&(CostAllotType=preCostAllotType) s flag=1
	 	}
	 	i (AutoAudit="Y")
	 	{
 			s PLIST(10) = "1"					;status
 			s PLIST(17) = $p(val,"^",9)			;审核人5
 			s PLIST(18) = +$H 					;审核日期
 			s PLIST(19) = $P($H,",",2) 			;审核时间
		}
 		&SQL(select DS_RowID into :tmpid from DHC_EQDepreSet where DS_SourceType=:SourceType and DS_SourceID=:SourceID and DS_DepreTypeDR=:DepreTypeDR)
 		if (tmpid'="")
 		{
 			s PLIST(14) = $p(val,"^",9)			;更新人5
			s PLIST(15) = +$H 					;更新日期
 			s PLIST(16) = $P($H,",",2) 			;更新时间 
 			&SQL(Update SQLUSER.DHC_EQDepreSet Values :PLIST() where DS_RowID = :rowid)
 			Set ID=$g(%ROWID)
 		}
 		else
 		{
 			s PLIST(11) = $p(val,"^",9)			;新增人5
 			s PLIST(12) = +$H 					;新增日期
 			s PLIST(13) = $P($H,",",2) 			;新增时间
			&SQL(Insert Into SQLUSER.DHC_EQDepreSet Values :PLIST())
			s DSDRowID=$G(%ROWID)
			b //DSDRowID
			if (flag=1)
			{
				s preCostAllotDR=$p($g(^DHCEQDepreSet(rowid)),"^",7)
				if (preCostAllotDR'="")
				{
					&SQL(Insert Into sqluser.DHC_EQDepreSetDetail
				   (DSD_DepreSetDR,DSD_ExceedFlag,DSD_FromYear,DSD_ToYear,DSD_Rate,DSD_Hold1,DSD_Hold2,DSD_Hold3,DSD_Hold4,DSD_Hold5)
	 				Select :DSDRowID,DSD_ExceedFlag,DSD_FromYear,DSD_ToYear,DSD_Rate,DSD_Hold1,DSD_Hold2,DSD_Hold3,DSD_Hold4,DSD_Hold5
 	 				From sqluser.DHC_EQDepreSetDetail Where DSD_DepreSetDR=:rowid)
				}
			}
			Set ID=DSDRowID
 		}	
	}
	elseif  (+isDel=2)  //审核
	{
 		s PLIST(10) = "1"					;status
 		s PLIST(17) = $p(val,"^",9)			;审核人5
 		s PLIST(18) = +$H 					;审核日期
 		s PLIST(19) = $P($H,",",2) 			;审核时间
		&SQL(Update SQLUSER.DHC_EQDepreSet Values :PLIST() where DS_RowID = :rowid)
		Set ID=$g(%ROWID)
	}
 	if SQLCODE  q SQLCODE
 	q ID
}

/// w ##Class(web.DHCEQDepreSet).GetDocByID("6")
ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQDepreSet(rowid)
	s resultex=resultex_"^"	//设备2
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	//折旧方法3
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	//主标志
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"bool")
	s resultex=resultex_"^"	//自动记入折旧标志
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"bool")
	s resultex=resultex_"^"	//成本分配类型7
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_..GetCostAllotTypeDisplay($p(result,"^",6))
	s resultex=resultex_"^"	//折旧类型
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreType",$p(result,"^",19))),"^",2)
	s resultex=resultex_"^"	//来源类型
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$case($p(result,"^",20),0:"设备",1:"分类")
	s resultex=resultex_"^"	//来源类型
	i $p(result,"^",21)'=""  d
	.i $p(result,"^",20)=0 s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",21))),"^",1)
	.i $p(result,"^",20)=1 s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",21))),"^",2)
	s resultex=resultex_"^"	//折旧方法code
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(result,"^",2))),"^",1)
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

Query DepreSet(EquipNameDR As %String = "", DepreMethodDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TEquipNameDR:%String,TEquipNo:%String,TDepreMethod:%String,TDepreMethodDR:%String,TMainFlag:%String,TAutoFlag:%String,TPreDepreMonth:%String,TCostAllotType:%String,TRemark:%String,TStatus:%String,TAuditUser:%String")
{
}

ClassMethod DepreSetExecute(ByRef qHandle As %Binary, EquipNameDR As %String = "", DepreMethodDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetDepreSet
	Quit $$$OK
BuildDataGetDepreSet
	f  s rowid=$o(^DHCEQDepreSet(rowid))  quit:rowid=""  d
	.d ResetVariablesGetDepreSet
	.s TRowID = rowid										//rowid
	.s TEquipNameDR=$p($g(^DHCEQDepreSet(rowid)),"^",1) 	//设备 
	.q:(TEquipNameDR'=EquipNameDR)&(EquipNameDR'="") 		//设备名称
    .i TEquipNameDR'=""  d
    ..s TEquipName=$p($g(^DHCEQEquip(TEquipNameDR)),"^",1) 	//设备名称
    ..s TEquipNo=$p($g(^DHCEQEquip(TEquipNameDR)),"^",71) 	//设备编号
    .s TDepreMethodDR=$p($g(^DHCEQDepreSet(rowid)),"^",2) 
	.q:(TDepreMethodDR'=DepreMethodDR)&(DepreMethodDR'="") 	//折旧方法
	.i TDepreMethodDR'="" s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2) //折旧方法
	.s TMainFlag=$p($g(^DHCEQDepreSet(rowid)),"^",3) 		//主标志
	.s TAutoFlag=$p($g(^DHCEQDepreSet(rowid)),"^",4) 		//自动产生折旧
	.s TPreDepreMonth=$p($g(^DHCEQDepreSet(rowid)),"^",5) 		//生成日期
	.s TCostAllotType=$p($g(^DHCEQDepreSet(rowid)),"^",6) 	//成本分配类型
	.s TRemark=$p($g(^DHCEQDepreSet(rowid)),"^",8) 			//备注
	.s TStatus=$p($g(^DHCEQDepreSet(rowid)),"^",9) 			//状态
	.s TAuditUser=$p($g(^DHCEQDepreSet(rowid)),"^",16) 		//审核人
	.d OutputRowGetDepreSet
	quit
OutputRowGetDepreSet
    s Data=$lb(TRowID,TEquipName,TEquipNameDR,TEquipNo,TDepreMethod,TDepreMethodDR,TMainFlag,TAutoFlag,TPreDepreMonth,TCostAllotType,TRemark,TStatus,TAuditUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDepreSet
	s (TRowID,TEquipName,TEquipNameDR,TEquipNo,TDepreMethod,TDepreMethodDR,TMainFlag,TAutoFlag,TPreDepreMonth,TCostAllotType,TRemark,TStatus,TAuditUser)=""
	quit
	Quit $$$OK
}

ClassMethod DepreSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepreSetExecute ]
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

ClassMethod DepreSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepreSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQDepreSet).GetRowID("1^0^294")
ClassMethod GetRowID(str)
{
	new (str)
	s flag=0
	s DepreTypeDR=$p(str,"^",1)
	s SourceType=$p(str,"^",2)
	s SourceID=$p(str,"^",3)
	s RowID=$o(^DHCEQDepreSet(0,"Source",DepreTypeDR,SourceType,SourceID,0))
	if RowID=""
	{
		s flag=""
		i SourceType=0
		{
			s EquipCatDR=$p($g(^DHCEQEquip(SourceID)),"^",4) 	//设备分类
			i EquipCatDR'="" s RowID=$o(^DHCEQDepreSet(0,"Source",DepreTypeDR,1,EquipCatDR,0))
			i RowID'="" s flag=1
		}
	}
	q RowID_"^"_flag
}

Query CostAllotType(desc As %String = "") As %Query(ROWSPEC = "TDesc:%String,hidden:%String")
{
}

ClassMethod CostAllotTypeExecute(ByRef qHandle As %Binary, EquipNameDR As %String = "", DepreMethodDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetCostAllotType
	Quit $$$OK
BuildDataGetCostAllotType
 	for TRowID=0:1:2 d
 	.i TRowID'=1  d
 	..s TDesc=..GetCostAllotTypeDisplay(TRowID)
	..d OutputRowGetCostAllotType
	quit
OutputRowGetCostAllotType
    s Data=$lb(TDesc,TRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod CostAllotTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CostAllotTypeExecute ]
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

ClassMethod CostAllotTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CostAllotTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCostAllotTypeDisplay(id As %Library.String) As %Status
{
	i id=""  q ""
	i +id=0  q "科室独占"
	//i +id=1  q "各科室按使用比例分摊"
	i +id=2  q "各科室按固定比例分摊"
	q "未定义"
}

/// add By ZY 2013-7-24 zy0108
/// w ##Class(web.DHCEQDepreSet).GetLimitYearsByOriginalFee("1^0^294")
ClassMethod GetLimitYearsByOriginalFee(originalfee, depretypedr As %Library.String = "2")
{
	s limityears=0
	s depremethoddr=""
	s deprerate=""
	if (originalfee>=200000)
	{
		s limityears=12
	}
	elseif((originalfee<200000)&&(originalfee>=100000))
	{
		s limityears=8
	}
	elseif((originalfee<100000)&&(originalfee>=30000))
	{
		s limityears=5
	}
	elseif((originalfee<30000)&&(originalfee>=10000))
	{
		s limityears=3
	}
	else
	{
		s limityears=1
	}
	q limityears_"^"_depremethoddr_"^"_deprerate
}

/// add By ZY 2013-7-25 zy0108
/// 当初次新增第二折旧(或更多折旧)时，新增系统中已有设备对照的第二折旧设置信息
ClassMethod UpdateDepreSet(depretypedr As %Library.String = "2")
{
	k PLIST
	s SQLCODE=0
	s eqrowid=0
	f  s eqrowid=$o(^DHCEQEquip(eqrowid)) q:((eqrowid="")||(SQLCODE'=0))  d
	.q:("Y"=$p($g(^DHCEQEquip(eqrowid)),"^",59))	//InvalidFlag
	.s originalfee=$p($g(^DHCEQEquip(eqrowid)),"^",27)
	.s depreinfo=##Class(web.DHCEQDepreSet).GetLimitYearsByOriginalFee(originalfee,depretypedr)
	.s limityears=$p(depreinfo,"^",1)
	.s depremethod=$p(depreinfo,"^",2)
	.i depremethod="" s depremethod=$p($g(^DHCEQEquip(eqrowid)),"^",33)
	.&sql(Insert into Sqluser.DHC_EQDepreSet(DS_EquipDR,DS_DepreMethodDr,DS_MainFlag,DS_DepreTypeDR,DS_SourceType,DS_SourceID,DS_Years) values (:eqrowid,:depremethod,'N',:depretypedr,0,:eqrowid,:limityears))
	
	q SQLCODE
}

/// czf 2020-06-02 
/// 触发器，删除DHCEQDepreSet表纪录时执行此操作
ClassMethod AfterDelete(id, equipdr)
{
	&sql(Delete from DHC_EQDepreInfo where DI_EquipDR=:equipdr)
	k ^DHCEQEquipShadow("RecordEQCurDepre",equipdr)
}

/// czf 2020-06-02 
/// 触发器，插入DHCEQDepreSet表记录时执行此操作
ClassMethod AfterInsert(id, equipdr, predepremonth, depretotalnum)
{
	&sql(insert into DHC_EQDepreInfo(DI_EquipDR,DI_DepreTotal,DI_PreDepreMonth) values(:equipdr,:depretotalnum,:predepremonth))
	;^DHCEQEquipShadow("RecordEQCurDepre")记录设备当前折旧月_"^"_折旧期数_"^"_当前月折旧额，用于台账检索取值
	s ^DHCEQEquipShadow("RecordEQCurDepre",equipdr)=predepremonth_"^"_depretotalnum_"^"
}

/// czf 2020-06-02 
/// 触发器，更新DHCEQDepreSet表时执行此操作
ClassMethod AfterUpdate(id, equipdr, predepremonth, depretotalnum)
{
	&sql(Update DHC_EQDepreInfo(DI_DepreTotal,DI_PreDepreMonth) values(:depretotalnum,:predepremonth) where DI_EquipDR=:equipdr)
	;^DHCEQEquipShadow("RecordEQCurDepre")记录设备当前折旧月_"^"_折旧期数_"^"_当前月折旧额，用于台账检索取值
	s ^DHCEQEquipShadow("RecordEQCurDepre",equipdr)=predepremonth_"^"_depretotalnum_"^"
}

/// czf 2020-06-02 
/// 已存在业务数据时初始化DHC_EQDepreInfo表
/// w ##Class(web.DHCEQDepreSet).UpdateDepreInfo()
ClassMethod UpdateDepreInfo()
{
	k ^DHCEQDepreInfo
	s flag=0
	s dsid=0
	f  s dsid=$o(^DHCEQDepreSet(dsid)) q:dsid=""  d
	.s equipdr=$p($g(^DHCEQDepreSet(dsid)),"^",1)
	.s predepremonth=$p($g(^DHCEQDepreSet(dsid)),"^",5)
	.s depretotalnum=$p($g(^DHCEQDepreSet(dsid)),"^",22)
	.&sql(insert into DHC_EQDepreInfo(DI_EquipDR,DI_DepreTotal,DI_PreDepreMonth) values(:equipdr,:depretotalnum,:predepremonth))
	.i SQLCODE s flag=1
	.q:SQLCODE
	.q:predepremonth=""
	.s deprefee=0
	.s DepreID=0
	.f  s DepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",equipdr,predepremonth,DepreID)) q:DepreID=""  d
	..s deprefee=deprefee+$p($g(^DHCEQMonthDepre(DepreID)),"^",14)
	.&sql(Update DHC_EQDepreInfo set DI_PreDepreFee=:deprefee where DI_EquipDR=:equipdr)
	.i SQLCODE s flag=1
	.q:SQLCODE
	
	q flag
}

/// czf 2020-06-02 
/// 已存在业务数据时初始化^DHCEQEquipShadow("RecordDepreset")
/// w ##Class(web.DHCEQDepreSet).UpdateEquipShadow()
ClassMethod UpdateEquipShadow()
{
	k ^DHCEQEquipShadow("RecordEQCurDepre")
	s flag=0
	s dsid=0
	f  s dsid=$o(^DHCEQDepreSet(dsid)) q:dsid=""  d
	.s equipdr=$p($g(^DHCEQDepreSet(dsid)),"^",1)
	.s predepremonth=$p($g(^DHCEQDepreSet(dsid)),"^",5)
	.s depretotalnum=$p($g(^DHCEQDepreSet(dsid)),"^",22)
	.s ^DHCEQEquipShadow("RecordEQCurDepre",equipdr)=predepremonth_"^"_depretotalnum_"^"
	.q:predepremonth=""
	.s deprefee=0
	.s DepreID=0
	.f  s DepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",equipdr,predepremonth,DepreID)) q:DepreID=""  d
	..s deprefee=deprefee+$p($g(^DHCEQMonthDepre(DepreID)),"^",14)
	.s ^DHCEQEquipShadow("RecordEQCurDepre",equipdr)=predepremonth_"^"_depretotalnum_"^"_deprefee
	
	q flag
}

}
