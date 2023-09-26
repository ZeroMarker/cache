Class web.DHCEQ.EM.BUSEquipRange Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modefied by lmm 2018-04-09
/// 描述：新增更新设备范围数据
/// w ##Class(web.DHCEQ.EM.BUSEquipRange).SaveEquipRange("24^1^2^48^Y^N^N^N^Y^Y","^1^后勤房屋及建筑物,医疗专用设备^Y&^5^2^Y&^5^3^Y&^5^4^Y&33^6^795^Y&34^6^796^Y")
ClassMethod SaveEquipRange(val, valList)
{
	new (val, valList)
	k PLIST,RowID
	Set $ZT="ERRORSave"
	s RowID=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2) ;RangeDesc
	s PLIST(3)=$p(val,"^",3) ;SourceType
	s SourceType=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4) ;SourceID
	s SourceID=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5) ;EquipTypeFlag
	s PLIST(6)=$p(val,"^",6) ;StatCatFlag
	s PLIST(7)=$p(val,"^",7) ;EquiCatFlag
	s PLIST(8)=$p(val,"^",8) ;LocFlag
	s PLIST(9)=$p(val,"^",9) ;EquipFlag
	s PLIST(10)=$p(val,"^",10) ;ItemFlag
	TSTART
	i (RowID="")  //新增按钮操作
	{
		s tmpid=""
		&SQL(select ER_RowID into :tmpid from sqluser.DHC_EQEquipRange where ER_SourceType=:SourceType and ER_SourceID=:SourceID)
		if (tmpid'="") q "数据有重复"	;重复记录
		&SQL(Insert into sqluser.DHC_EQEquipRange Values :PLIST())
		s RowID=$G(%ROWID) 

		if SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_RowID
		}
	}
	else
	{
		
		s tmpid=""
		&SQL(select ER_RowID into :tmpid from sqluser.DHC_EQEquipRange where ER_SourceType=:SourceType and ER_SourceID=:SourceID)
		if ((tmpid'="")&&(tmpid'=RowID)) q "数据有重复"	;重复记录
		&SQL(Update sqluser.DHC_EQEquipRange Values :PLIST() where ER_RowID = :RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_RowID
		}
	}
	 s SQLCODE=..SaveEquipRangeList(RowID,valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
	
	TCOMMIT
 	q SQLCODE_"^"_RowID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// Modefied by lmm 2018-04-09
/// 描述：删除设备范围数据
/// w ##Class(web.DHCEQ.EM.BUSEquipRange).DeleteEquipRange("5","3,4") 
ClassMethod DeleteEquipRange(Rowid As %String)
{
	
	Set $ZT="ERRORDelete"
	TSTART
	i Rowid="" q 0
		&SQL(delete from sqluser.DHC_EQEquipRange where ER_RowID = :Rowid)
		if SQLCODE
		{
			TROLLBACK
			
			q SQLCODE_"^"_Rowid
		}
	
	s valList=""
	s ERLID=0
	f  s ERLID=$o(^DHCEQEquipRangeList(0,"LimitDR",Rowid,ERLID)) q:ERLID=""  d
	.i valList="" s valList=ERLID
	.e  s valList=valList_","_ERLID
	
	
	 s SQLCODE=..DeleteManageLimitList(valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_Rowid
	}

	
	TCOMMIT
 	q SQLCODE_"^"_Rowid
ERRORDelete 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORDelete>"_ErrorMsg     //返回错误消息 ;
}

/// Modefied by lmm 2018-04-09
/// 描述：新增与更新分开，此部分为更新
/// w ##Class(web.DHCEQ.EM.BUSEquipRange).SaveEquipRangeList("24","^1^后勤房屋及建筑物,医疗专用设备^Y&^5^2^Y&^5^3^Y&^5^4^Y&33^6^795^Y&34^6^796^Y") 
ClassMethod SaveEquipRangeList(ERRowID As %String, val As %String)
{
	new Length,ERLRowID,i
	n valList
	k PLISTMX
	i val="" q 0
	i ERRowID="" q -1
	s Length=$l(val,"&")
	s PLISTMX(2)=ERRowID  				;EquipRangeDR
	
	for i=1:1:Length
	{
		s valList=$p(val,"&",i)
		s ERLRowID= $p(valList,"^",1)
		s PLISTMX(3)=$p(valList,"^",2)  	;ERL_Type
		s PLISTMX(4)=$p(valList,"^",3) 		;ERL_Value
		s PLISTMX(5)=$p(valList,"^",4)		;ERL_AccessFlag
		if (ERLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQEquipRangeList Values :PLISTMX())
			
		}
		else
		{
			&SQL(update SQLUSER.DHC_EQEquipRangeList values :PLISTMX() where ERL_RowID=:ERLRowID)
		}
	}
	Quit SQLCODE
}

/// Modefied by lmm 2018-04-09
/// 描述：删除设备范围明细数据
/// w ##Class(web.DHCEQEquipRange).DeleteManageLimitList("5") 
ClassMethod DeleteManageLimitList(DelListIDs)
{
	
	new Length,ERLRowID,i,SQLCODE
	s SQLCODE=0
	
	s Length=$l(DelListIDs,",")
	for i=1:1:Length  d
	.s ERLRowID=$p(DelListIDs,",",i)
	.if (ERLRowID>0)  d
	..&SQL(delete from  sqluser.DHC_EQEquipRangeList where ERL_RowID=:ERLRowID)
	
	Q SQLCODE
}

/// Modefied by lmm 2018-04-09
/// 描述：查询设备范围数据
/// d ##class(%ResultSet).RunQuery("web.DHCEQEquipRange","GetEquipRange")
Query GetEquipRange(SourceType As %String = "", SourceID As %String = "", MinPrice As %String = "", MaxPrice As %String = "") As %Query(ROWSPEC = "rowid:%String,rangedesc:%String,sourcetypeid:%String,sourcetype:%String,sourcedesc:%String,equiptypeflag:%String,statcatflag:%String,equipcatflag:%String,locflag:%String,equipflag:%String,itemflag:%String,TRow:%String,minprice:%String,maxprice:%String")
{
}

ClassMethod GetEquipRangeExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", MinPrice As %String = "", MaxPrice As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	Set TRow=0
	Set rowid=0
	For  Set rowid=$Order(^DHCEQEquipRange(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetEquipRange
	.Set rangedesc=$Piece($Get(^DHCEQEquipRange(rowid)),"^",1)
	.Set sourcetypeid=$Piece($Get(^DHCEQEquipRange(rowid)),"^",2)
	.q:(SourceType'="")&&(sourcetypeid'=SourceType)
	.Set sourcetype=$CASE(sourcetypeid,"":"","1":"人员权限限定","2":"保养检查计划","3":"PM模板限定")  ///Modefied by zc0098 2021-1-29 增加PM模板限定解析
	.Set sourceid=$Piece($Get(^DHCEQEquipRange(rowid)),"^",3)
	.i sourcetypeid=1  d
	..Set sourcedesc=##class(web.DHCEQCommon).getMapIDBySource("user",sourceid)   //add by lmm 2018-11-05
	.e  d
	..Set sourcedesc=$Piece($Get(^DHCEQEquipRange(rowid)),"^",3)
	.Set equiptypeflag=$Piece($Get(^DHCEQEquipRange(rowid)),"^",4)
	.Set statcatflag=$Piece($Get(^DHCEQEquipRange(rowid)),"^",5)
	.Set equipcatflag=$Piece($Get(^DHCEQEquipRange(rowid)),"^",6)
	.Set locflag=$Piece($Get(^DHCEQEquipRange(rowid)),"^",7)
	.Set equipflag=$Piece($Get(^DHCEQEquipRange(rowid)),"^",8)
	.Set itemflag=$Piece($Get(^DHCEQEquipRange(rowid)),"^",9)
	.Set minprice=$Piece($Get(^DHCEQEquipRange(rowid)),"^",10)
	.q:(MinPrice'="")&&(minprice>MinPrice)
	.Set maxprice=$Piece($Get(^DHCEQEquipRange(rowid)),"^",11)
	.q:(MaxPrice'="")&&(maxprice<MaxPrice)
	.Do OutputRowEquipRange
	
	Quit $$$OK
OutputRowEquipRange
	Set TRow=TRow+1
	set Data=$lb(rowid,rangedesc,sourcetypeid,sourcetype,sourcedesc,equiptypeflag,statcatflag,equipcatflag,locflag,equipflag,itemflag,TRow,minprice,maxprice)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetEquipRange
	Set (rangedesc,sourcetypeid,sourcetype,sourcedesc,equiptypeflag,statcatflag,equipcatflag,locflag,equipflag,itemflag)=""
	Quit
}

ClassMethod GetEquipRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipRangeExecute ]
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

ClassMethod GetEquipRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipRangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by lmm 2018-04-09
/// 描述：查询设备范围数据
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSEquipRange","GetEquipRangeList","","","")
Query GetEquipRangeList(EquipRangeDR As %String = "", Type As %String = "", Value As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipRangeDR:%String,TTypeDR:%String,TType:%String,TValueDR:%String,TValue:%String,TAccessFlag:%String,TCode:%String,TUseLocDR:%String,TUseLoc:%String,TEquipTypeDR:%String,TEquipType:%String,TNo:%String,TModelDR:%String,TModel:%String,TLeaveFactoryNo:%String") [ SqlProc ]
{
}

ClassMethod GetEquipRangeListExecute(ByRef qHandle As %Binary, EquipRangeDR As %String = "", Type As %String = "", Value As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s mrowid=0
	f  s mrowid=$o(^DHCEQEquipRangeList(mrowid))  quit:mrowid=""  d
	.d ResetVariablesGetEquipRangeList
	.s rowid=mrowid
	.s equiprangedr=$p($g(^DHCEQEquipRangeList(mrowid)),"^",1)
	.q:equiprangedr'=EquipRangeDR
	.s typedr=$p($g(^DHCEQEquipRangeList(mrowid)),"^",2)
	.q:typedr'=Type
	.s type=$CASE(typedr,"":"","1":"类组","2":"类型","3":"分类","4":"科室","5":"设备","6":"设备项")
	.s accessflag=$p($g(^DHCEQEquipRangeList(mrowid)),"^",4)
	.s valuedr=$p($g(^DHCEQEquipRangeList(mrowid)),"^",3)
	.q:(Value'="")&&(valuedr'=Value)
	.i typedr=1 d
	..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipType",valuedr)),"^",4)  //Modefied by zc 2015-07-13 zc0027 begin
	..q:invalidFlag="Y"
	..s value=$p($g(^DHCEQCCode("DHCEQCEquipType",valuedr)),"^",2)
	..s code=$p($g(^DHCEQCCode("DHCEQCEquipType",valuedr)),"^",1)
	..d OutputRowEquipRangeList
	.e  i typedr=2 d
	..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",valuedr)),"^",4)
	..q:invalidFlag="Y"
	..s value=$p($g(^DHCEQCCode("DHCEQCStatCat",valuedr)),"^",2)
	..s code=$p($g(^DHCEQCCode("DHCEQCStatCat",valuedr)),"^",1)
	..d OutputRowEquipRangeList
	.e  i typedr=3 d
	..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipeCat",valuedr)),"^",7)
	..q:invalidFlag="Y"
	..s value=$p($g(^DHCEQCCode("DHCEQCEquipeCat",valuedr)),"^",2)
	..s code=$p($g(^DHCEQCCode("DHCEQCEquipeCat",valuedr)),"^",1)
	..d OutputRowEquipRangeList
	.e  i typedr=4 d
	..s value=##Class(web.DHCEQCommon).GetTrakNameByID("dept",valuedr)
	..s code=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",valuedr)
	..d OutputRowEquipRangeList
	.e  i typedr=5 d
	..s value=$p($g(^DHCEQEquip(valuedr)),"^",1)
	..s no=$p($g(^DHCEQEquip(valuedr)),"^",71)
	..s leavefactoryno=$p($g(^DHCEQEquip(valuedr)),"^",10)
	..s modeldr=$p($g(^DHCEQEquip(valuedr)),"^",3)
	..i modeldr'="" s model=$p($g(^DHCEQCCode("DHCEQCModel",modeldr)),"^",2)
	..s uselocdr=$p($g(^DHCEQEquip(valuedr)),"^",19)
	..s useloc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",uselocdr)   //modify by lmm 2019-05-29 919147
	..s equiptypedr=$p($g(^DHCEQEquip(valuedr)),"^",63)
	..s equiptypedesc=$p($g(^DHCEQCCode("DHCEQCEquipType",equiptypedr)),"^",2)
	..d OutputRowEquipRangeList
	.e  i typedr=6 d
	..s value=$p($g(^DHCEQCCode("DHCEQCMasterItem",valuedr)),"^",1)
	..;s code=$p($g(^DHCEQCCode("DHCEQCMasterItem",valuedr)),"^",2)
	..s equiptypedr=$p($g(^DHCEQCCode("DHCEQCMasterItem",valuedr)),"^",3)
	..s equiptypedesc=$p($g(^DHCEQCCode("DHCEQCEquipType",equiptypedr)),"^",2)
	..d OutputRowEquipRangeList
	Quit $$$OK
OutputRowEquipRangeList
	set Data=$lb(rowid,equiprangedr,typedr,type,valuedr,value,accessflag,code,uselocdr,useloc,equiptypedr,equiptypedesc,no,modeldr,model,leavefactoryno)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipRangeList
	Set (rowid,equiprangedr,typedr,type,valuedr,value,accessflag,code,uselocdr,useloc,equiptypedr,equiptypedesc,no,modeldr,model,leavefactoryno)=""
	Quit
}

ClassMethod GetEquipRangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipRangeListExecute ]
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

ClassMethod GetEquipRangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipRangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by lmm 2018-04-09
/// 描述：根据来源ID，来源类型获取设备范围相关数据
/// w ##Class(web.DHCEQ.EM.BUSEquipRange).GetOneEquipRange("167","2")
ClassMethod GetOneEquipRange(MaintPlanID As %Library.String, SourceType)
{
	new result,resultex
	s (result,resultex,ERRowID,TypeID,ERLRowID)=""
	s ERRowID=$o(^DHCEQEquipRange(0,"SourceID",SourceType,MaintPlanID,ERRowID))
	s result=ERRowID
	s result=result_"^"_^DHCEQEquipRange(ERRowID)
	s EquipTypeFlag=$p($g(^DHCEQEquipRange(ERRowID)),"^",4)  //add by lmm 2018-10-30
	s StatCatFlag=$p($g(^DHCEQEquipRange(ERRowID)),"^",5)  //add by lmm 2018-10-30
	//equiptype
	s resultex=resultex_"^"	
	s TypeID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,1,0))
	i EquipTypeFlag="N" s TypeID=""
	s resultex=resultex_TypeID
	s resultex=resultex_"^"
	i TypeID'=""  d
	.s EquipTypestr=""
	.s Length=$l(TypeID,",")
	.for i=1:1:Length  d
	..s EquipTypeID=$p(TypeID,",",i)
	..s EquipTypedesc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",2)
	..i EquipTypestr=""  d
	...s EquipTypestr=EquipTypedesc
	..e  d
	...s EquipTypestr=EquipTypestr_","_EquipTypedesc
	.i EquipTypeFlag="N" s EquipTypestr=""  //add by lmm 2018-10-30
	.i EquipTypestr'="" s resultex=resultex_EquipTypestr

	s resultex=resultex_"^"	
	i TypeID'="" s ERLRowID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,1,TypeID,ERLRowID))
	i ERLRowID'="" s resultex=resultex_ERLRowID
	//statcat
	s resultex=resultex_"^"	
	s TypeID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,2,0))
	i StatCatFlag="N" s TypeID=""
	s resultex=resultex_TypeID
	s resultex=resultex_"^"
	
	i TypeID'=""  d
	.s StatCatstr=""
	.s Length=$l(TypeID,",")
	.for i=1:1:Length  d
	..s StatCatID=$p(TypeID,",",i)
	..s StatCatdesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	..i StatCatstr=""  d
	...s StatCatstr=StatCatdesc
	..e  d
	...s StatCatstr=StatCatstr_","_StatCatdesc
	.i StatCatFlag="N" s StatCatstr=""  //add by lmm 2018-10-30
	.i StatCatstr'="" s resultex=resultex_StatCatstr

	s resultex=resultex_"^"	
	s ERLRowID=""
	i TypeID'="" s ERLRowID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,2,TypeID,ERLRowID))
	i ERLRowID'="" s resultex=resultex_ERLRowID

	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// add by lmm 2019-10-30 LMM0048
/// 描述：获取维护具体指定范围的具体id串
/// 入参：MaintPlanID：范围id SourceType：范围类型：2维护 Type：指定类型
/// w ##Class(web.DHCEQ.EM.BUSEquipRange).GetEquipRangelistStr("15","2","2")
ClassMethod GetEquipRangelistStr(MaintPlanID As %Library.String, SourceType, Type)
{
	
	s (ERLStr,ERRowID,ERLRowID)=""
	s ERRowID=$o(^DHCEQEquipRange(0,"SourceID",SourceType,MaintPlanID,ERRowID))
	s ERLRowID=0
	f  s ERLRowID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,Type,ERLRowID))  q:ERLRowID=""  d
	.i ERLStr=""  d
	..s ERLStr=ERLRowID
	.e  d
	..s ERLStr=ERLStr_","_ERLRowID
	q ERLStr
}

/// Author: zx
/// Date: 2019-06-27
/// Description: 根据设备id获取单条默认计划或模板
/// Input: EquipID,设备RowID SourceType,来源类型 1人员限定,2检查保养计量范围,3模板 PlanType,检查、保养等类型 ExecuteFlag,不为空时获取最新一次执行单
/// Output: Result,来源id^来源描述
/// w ##Class(web.DHCEQ.EM.BUSEquipRange).GetRangSourceByEquip("9","2","2","1","85")
ClassMethod GetRangSourceByEquip(EquipID As %Library.String = "", SourceType As %Library.String = "", PlanType As %Library.String = "", ExecuteFlag As %Library.String = "", CurGroupID As %Library.String = "")
{
	s Result=""
	i (EquipID="")||(SourceType="") q Result
	
	
	i SourceType="2"
	{
		s ResultID=""
		i PlanType="" q result
		s SourceID=0
		f  s SourceID=$o(^DHCEQMaintPlan(0,"Type",PlanType,SourceID)) q:(SourceID="")||(ResultID'="")   d
		.q:(","_##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips(SourceType,SourceID,"",CurGroupID)_",")'[(","_EquipID_",")
		.s ResultID=SourceID
		if ResultID'="" //Modified By QW20201009 begin
		{
			i ResultID'="" s Result=ResultID_"^"_$p($g(^DHCEQMaintPlan(ResultID)),"^",1)
			i ExecuteFlag'="" d
			.s ExecuteID=$o(^DHCEQPlanExecute(0,"MaintPlan",ResultID,""),-1)
			.i ExecuteID'="" d
			..s Result=Result_"#"_ExecuteID_"^"_$p($g(^DHCEQPlanExecute(ExecuteID)),"^",1)
			.e  d
			..s Result=Result_"#"
		}
	}
	i SourceType="3"
	{
		s ResultID=""
		s defaultTemplate=##class(web.DHCEQCommon).GetSysInfo("503009")		// MZY0092	2021-08-27
		s SourceID=0
		f  s SourceID=$o(^DHCEQCCode("DHCEQCPMTemplate",SourceID)) q:(SourceID="")||(ResultID'="")  d
		.q:($p($g(^DHCEQCCode("DHCEQCPMTemplate",SourceID)),"^",6)'="")&&($p($g(^DHCEQCCode("DHCEQCPMTemplate",SourceID)),"^",6)<(+$h))   	//Modefied by zc0121  2022-9-13  已过期的PM模板信息的过滤
		.q:($p($g(^DHCEQCCode("DHCEQCPMTemplate",SourceID)),"^",7)'="")&&($p($g(^DHCEQCCode("DHCEQCPMTemplate",SourceID)),"^",7)>(+$h))		//Modefied by zc0121  2022-9-13  已过期的PM模板信息的过滤
		.q:(PlanType'="")&&(PlanType'=$p($g(^DHCEQCCode("DHCEQCPMTemplate",SourceID)),"^",1))
		.;i $p($g(^DHCEQCCode("DHCEQCPMTemplate",SourceID)),"^",8)'="" s defaultTemplate=SourceID	// MZY0092	2021-08-27
		.q:(","_##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips(SourceType,SourceID,"",CurGroupID)_",")'[(","_EquipID_",")
		.s ResultID=SourceID
		
		i ResultID'="" d
		.s Result=ResultID_"^"_$p($g(^DHCEQCCode("DHCEQCPMTemplate",ResultID)),"^",2)
		e  d
		.s Result=defaultTemplate_"^"_$p($g(^DHCEQCCode("DHCEQCPMTemplate",+defaultTemplate)),"^",2)
	}
	
	q Result
}

ClassMethod GetRangSource(EQRowID, GroupID, PlanType)
{
	s TemplateInfo=""
	s PlanInfo=##Class(web.DHCEQ.EM.BUSEquipRange).GetRangSourceByEquip(EQRowID,"2",PlanType,"1",GroupID)
	if PlanType="1" s TemplateInfo=##Class(web.DHCEQ.EM.BUSEquipRange).GetRangSourceByEquip(EQRowID,"3",PlanType,"",GroupID)
	q PlanInfo_"#"_TemplateInfo
}

/// MZY0072	1777017		2021-04-19
/// w ##Class(web.DHCEQ.EM.BUSEquipRange).GetList(40,5)
ClassMethod GetList(EquipRangeDR As %String = "", Type As %String = "", Value As %String = "")
{
	s Data=""
	s Num=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	s (sumFee,sumQty)=0
	
	s mrowid=0
	f  s mrowid=$o(^DHCEQEquipRangeList(mrowid))  quit:mrowid=""  d
	.s rowid=mrowid
	.s equiprangedr=$p($g(^DHCEQEquipRangeList(mrowid)),"^",1)
	.q:equiprangedr'=EquipRangeDR
	.s typedr=$p($g(^DHCEQEquipRangeList(mrowid)),"^",2)
	.q:typedr'=Type
	.s type=$CASE(typedr,"":"","1":"类组","2":"类型","3":"分类","4":"科室","5":"设备","6":"设备项")
	.s accessflag=$p($g(^DHCEQEquipRangeList(mrowid)),"^",4)
	.q:accessflag'="Y"
	.s valuedr=$p($g(^DHCEQEquipRangeList(mrowid)),"^",3)
	.q:(Value'="")&&(valuedr'=Value)
	.s EquipName=$p($g(^DHCEQEquip(valuedr)),"^",1)
	.s EquipNo=$p($g(^DHCEQEquip(valuedr)),"^",71)
	.s leavefactoryno=$p($g(^DHCEQEquip(valuedr)),"^",10)
	.s model=""  //Modeifed by zc0108 2021-11-23 初始化model
	.s modeldr=$p($g(^DHCEQEquip(valuedr)),"^",3)
	.i modeldr'="" s model=$p($g(^DHCEQCCode("DHCEQCModel",modeldr)),"^",2)
	.s uselocdr=$p($g(^DHCEQEquip(valuedr)),"^",19)
	.s useloc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",uselocdr)
	.s equiptypedr=$p($g(^DHCEQEquip(valuedr)),"^",63)
	.s equiptypedesc=$p($g(^DHCEQCCode("DHCEQCEquipType",equiptypedr)),"^",2)
	.                         //设备名称	设备编号	设备类组	科室	机型	出厂编号
	.s Data=Data_SplitRowCode_EquipName_"^"_EquipNo_"^"_equiptypedesc_"^"_useloc_"^"_model_"^"_leavefactoryno
	.s Num=Num+1
	;i Data'=""  d
	;.s Data=Data_SplitRowCode_"合计"_"^"_"^"_"^"_"^"_sumQty_"^"_"^"_sumFee_"^"_"^"_"^"_"^"_"^"
	;.s Num=Num+1
	q Data_SplitNumCode_Num
}

}
