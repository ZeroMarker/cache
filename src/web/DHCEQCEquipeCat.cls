Import SQLUser

Class web.DHCEQCEquipeCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:设备分类,HIDDEN:%String,Code:%String:编码")
{
SELECT EC_Desc,
	   EC_RowID,
	   EC_Code
FROM sqluser.DHC_EQCEquipeCat
where EC_InvalidFlag = 'N' and EC_Desc like nvl(:para,'')||'%'
}
*/
/// MZY0030	1340074		2020-06-01		增加财务大类过滤
/// add by CSJ 20190603
/// 设备分类查询放大镜由SQL改为query
/// 入参：	para			描述或代码  
/// 			EquipTypeDR		管理类组
/// 			IncludeFlag		false：仅显示相关财务大类的分类		true：显示全部设备分类
/// 	输出：结果明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQCEquipeCat","LookUp","",3)
Query LookUp(para As %String = "", EquipTypeDR As %String = "", IncludeFlag As %String = "") As %Query(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod LookUpExecute(ByRef qHandle As %Binary, para As %String = "", EquipTypeDR As %String = "", IncludeFlag As %String = "") As %Status
{
	new repid, index,RowID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s RowID=0
	s Flag=##class(web.DHCEQCommon).GetSysInfo("990014") ;分类最末级限制参数 0:不限制  1:限制  2:提示
	s FinanceType=$p($g(^DHCEQCCode("DHCEQCEquipType", +EquipTypeDR)),"^",9)	;MZY0030	1340074		2020-06-01
	
	for  s RowID=$o(^DHCEQCCode("DHCEQCEquipeCat",RowID)) quit:RowID=""  d
	.d ResetVariablesLookUp
	.s TRowID=RowID
	.q:(IncludeFlag="false")&&(EquipTypeDR'="")&&($P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",10)'=FinanceType)	;MZY0030	1340074		2020-06-01
	.s Find='$d(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",RowID))	//是最末级:1 否:0
	.q:(+Flag=1)&&(Find=0)	//限制则只输出最末级
	.s TCode=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",1)
	.s TDesc=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",2)
	.q:(para'="")&&(TDesc'[para)&&($ZConvert(TCode,"U")'[$ZConvert(para,"U"))
	.s TInvalidFlag=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",7)
	.q:TInvalidFlag="Y"
	.d OutputRowLookUp
	Quit $$$OK
OutputRowLookUp
	s Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesLookUp
	s (TDesc,TRowID,TCode)=""
	quit
}

ClassMethod LookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpExecute ]
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

ClassMethod LookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 2009-08-12 党军 DJ0025 更新EC_Hold1, EC_Hold2, EC_ExCode字段信息
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod UpdateData(itmjs As %Library.String = "", itmjsex As %Library.String = "", AppType, RowID, Code, Desc, ParCat, Remark, SpecialType, YearsNum, EquipNoFlag, DepreMethod, Hold2, ExtendCode)
{
	i ParCat="" s ParCat="0"
	
	s $zt="ErrorUpdate"
 	s TableName="DHC_EQCEquipeCat"
 	s ClassName="User.DHCEQCEquipeCat"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s BussID=RowID	
 	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20	
	
	s EquipNoFlag=##Class(web.DHCEQCommon).TransValueFromPage(EquipNoFlag,"bool")
	TSTART
	i +AppType=0 //新增
	{
		Set BussID="",OperateType="A"
		&sql(insert into sqluser.DHC_EQCEquipeCat (EC_Code,EC_Desc,EC_ParCatDR,EC_Remark,EC_InvalidFlag,EC_SpecialTypeDR,EC_YearsNum,EC_EquipNoFlag, EC_Hold1, EC_Hold2, EC_Hold3) values (:Code,:Desc,:ParCat,:Remark,'N',:SpecialType,:YearsNum,:EquipNoFlag,:DepreMethod,:Hold2,:ExtendCode))
	}
	i +AppType=1 //更新
	{
		Set OperateType="U"
		s OldObject=##Class(User.DHCEQCEquipeCat).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&sql(update sqluser.DHC_EQCEquipeCat (EC_Code,EC_Desc,EC_ParCatDR,EC_Remark,EC_InvalidFlag,EC_SpecialTypeDR,EC_YearsNum,EC_EquipNoFlag, EC_Hold1, EC_Hold2, EC_Hold3) values (:Code,:Desc,:ParCat,:Remark,'N',:SpecialType,:YearsNum,:EquipNoFlag,:DepreMethod,:Hold2,:ExtendCode) where EC_RowID=:RowID)
	}
	i +AppType=2 //删除
	{
		s OldObject=##Class(User.DHCEQCEquipeCat).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		&sql(update sqluser.DHC_EQCEquipeCat set EC_InvalidFlag='Y' where EC_RowID=:RowID)

	 	If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""ECInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
	 	Quit SQLCODE //modified by sjh SJH0041
	}
	If SQLCODE
 	{
	 	TRollback
	 	q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCEquipeCat).%OpenId(ID))
	i BussID'=""	//更新数据获取更新字段Json串
	{
		s key=""
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
    		i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	else			//插入数据
	{
		s BussID=ID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
	}
	TCommit
	q SQLCODE //modified by sjh SJH0041
ErrorUpdate
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

ClassMethod GetOneCat(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID)
{
	s (Return,ParCatDR,ParCat,SpecialTypeDR,SpecialType,DepreMethodDR,DepreMethod,Hold2,FinanceType,ExtendCode)=""  // MZY0030	1340074		2020-06-01
	s Return=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",1)
	s Return=Return_"^"_$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",2)
	s ParCatDR=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",4)
	i ParCatDR'="" s ParCat=$P(^DHCEQCCode("DHCEQCEquipeCat",ParCatDR),"^",2)
	s SpecialTypeDR=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",5)
	i SpecialTypeDR'="" s SpecialType=$P(^DHCEQCCode("DHCEQCSpecialType",SpecialTypeDR),"^",2)
	s YearsNum=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",6)
	s EquipNoFlag=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",8)
	i EquipNoFlag="Y"
	{	s EquipNoFlag=1}
	else
	{	s EquipNoFlag=0}
	s Return=Return_"^"_ParCatDR_"^"_ParCat
	s Return=Return_"^"_$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",3)_"^"_SpecialTypeDR_"^"_SpecialType
	s Return=##class(web.DHCEQCommon).Replace(Return,$C(13,10),"\n")
	s DepreMethodDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",RowID)),"^",9) //2009-08-12 党军 begin DJ0025
	i DepreMethodDR'="" s DepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	s Hold2=$p($g(^DHCEQCCode("DHCEQCEquipeCat",RowID)),"^",10)
	// MZY0030	1340074		2020-06-01
	s Hold3=$p($g(^DHCEQCCode("DHCEQCEquipeCat",RowID)),"^",11)
	s FinanceType=$p($g(^DHCEQCCode("DHCEQCFinanceType",+Hold2)),"^",2)
	q Return_"^"_YearsNum_"^"_EquipNoFlag_"^"_DepreMethodDR_"^"_DepreMethod_"^"_Hold2_"^"_Hold3_"^"_FinanceType
}

ClassMethod GetParCat(ParCatDR)
{
	i ParCatDR="" q ""
	i ParCatDR=0 q ""
	q $P(^DHCEQCCode("DHCEQCEquipeCat",ParCatDR),"^",2)
}

ClassMethod GetCatValue(CatDR, Location)
{
	i CatDR="" q ""
	i CatDR=0 q ""
	q $P(^DHCEQCCode("DHCEQCEquipeCat",CatDR),"^",Location)
}

// 修改:2009-08-12 党军 DJ0025 

// 描述:增加EC_Hold1,EC_Hold2,EC_ExCode查询显示

/// add by mwz 2017-10-30 
/// 设备分类维护的查询方法由SQL改为query
/// 入参：父类     输出：子类明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQCEquipeCat","GetEquipCat","231000000")
Query GetEquipCat(VarParCatDR As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TCode:%String,TDesc:%String,TParCat:%String,TParCatDR:%String,TRemark:%String,TSpecialTypeDR:%String,TSpecialType:%String,TYearsNum:%String,TEquipNoFlag:%String,TDepreMethod:%String,THold2:%String,TExtendCode:%String")
{
}

ClassMethod GetEquipCatExecute(ByRef qHandle As %Binary, VarParCatDR As %String = "") As %Status
{
	new repid, index,RowID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s RowID=0
	for  s RowID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",VarParCatDR,RowID)) quit:RowID=""  d
	.d ResetVariablesGetStatCat
	.s TRowID=RowID
	.s TCode=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",1)
	.s TDesc=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",2)
	.s TParCat=..GetParCat(VarParCatDR)
	.s TParCatDR=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",4)
	.s TRemark=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",3)
	.s TSpecialTypeDR=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",5)
    .i TSpecialTypeDR'="" s TSpecialType=$P(^DHCEQCCode("DHCEQCSpecialType",SpecialTypeDR),"^",2)
	.s TYearsNum=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",6)
	.s TInvalidFlag=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",7)
	.q:TInvalidFlag="Y"
	.s TEquipNoFlag=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",8)
	.i TEquipNoFlag="Y" s TEquipNoFlag="是"                    ;hisui-改造 add by kdf 2018-09-30 将展示的“Y”改成“是”
	.s TDepreMethod=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",9)
	.s THold2=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",10)
	.i THold2'="" s THold2=$p($g(^DHCEQCCode("DHCEQCFinanceType",THold2)),"^",2)	// MZY0030	1340074		2020-06-01
	.s TExtendCode=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",11)
	.d OutputRowGetStatCat
	Quit $$$OK
OutputRowGetStatCat
	s Data=$lb(TRow,TRowID,TCode,TDesc,TParCat,TParCatDR,TRemark,TSpecialTypeDR,TSpecialType,TYearsNum,TEquipNoFlag,TDepreMethod,THold2,TExtendCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetStatCat
	s (TRowID,TCode,TDesc,TParCat,TParCatDR,TRemark,TSpecialTypeDR,TSpecialType,TYearsNum,TEquipNoFlag,TDepreMethod,THold2,TExtendCode)=""
	quit
}

ClassMethod GetEquipCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipCatExecute ]
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

ClassMethod GetEquipCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// ##Class(web.DHCEQCEquipeCat).GetTreeNotes("","",parid,layer,preline)
ClassMethod GetTreeNotes(itmjs As %Library.String = "", itmjsex As %Library.String = "", parid, layer, preline)
{
	//CreateNode中参数意义对应为“节点ID，节点名称，是否有子节点，是否最后一个节点，层，父节点ID，”
	s ^DHCEQTempJdl("GetTreeNotes")=parid_","_layer_","_preline
	s nodes=""
	s ID=0
	f  s ID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",parid,ID))  quit:ID=""  d
	.s ECDesc=$p(^DHCEQCCode("DHCEQCEquipeCat",ID),"^",2)
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCEquipeCat",ID),"^",7)
	.q:InvalidFlag="Y"
	.s ISChildID=..HasChild(ID)
	.s ISEndID=..ISEnd(parid,ID)
	.;s nodes=nodes_",ECDesc=" ;_ECDesc_",ISChildID="_ISChildID_",ISEndID="_ISEndID
	.s nodes=nodes_##class(web.DHCEQTree).CreateNode(ID,ECDesc,ISChildID,ISEndID,layer,parid,preline)
	q nodes
}

/// ##Class(web.DHCEQCEquipeCat).GetTreeNoteIds(parid)
ClassMethod GetTreeNoteIds(parid)
{
	s nodeids=""
	s ID=0
	f  s ID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",parid,ID))  quit:ID=""  d
	.s ECDesc=$p(^DHCEQCCode("DHCEQCEquipeCat",ID),"^",2)
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCEquipeCat",ID),"^",7)
	.q:InvalidFlag="Y"
	.i nodeids'="" s nodeids=nodeids_"^"
	.s nodeids=nodeids_ID
	q nodeids
}

/// ##Class(web.DHCEQCEquipeCat).GetTreeNote(parid,layer,preline)
ClassMethod GetTreeNote(parid, layer, preline, id)
{
	//CreateNode中参数意义对应为“节点ID，节点名称，是否有子节点，是否最后一个节点，层，父节点ID，”
	s ECDesc=$p(^DHCEQCCode("DHCEQCEquipeCat",id),"^",2)
	s InvalidFlag=$p(^DHCEQCCode("DHCEQCEquipeCat",id),"^",7)
	q:InvalidFlag="Y" ""
	s ISChildID=..HasChild(id)
	s ISEndID=..ISEnd(parid,id)
	q ##class(web.DHCEQTree).CreateNode(id,ECDesc,ISChildID,ISEndID,layer,parid,preline)
}

/*s id=parid_"002"
	s nodes=nodes_##class(web.DHCEQTree).CreateNode(id,"节点"_id,1,1,layer,parid,preline)*/
/// 一个节点是否有子节点
ClassMethod HasChild(ParID)
{
	s Total=0
	s Total=..AllInvalidFlag(ParID,0)
	i Total > 0 q 1
	q 0
}

/// 是否同一级节点的最后一个节点
ClassMethod ISEnd(ParID, ID)
{
	s Total=0
	s Total=..AllInvalidFlag(ParID,ID)
	i Total > 0 q 0
	q 1
}

/// 判断一个节点后是否还有同一级的节点
ClassMethod AllInvalidFlag(ParID, ID)
{
	s RowID=ID
	s Total=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",ParID,RowID))  quit:RowID=""  d
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",7)
	.i InvalidFlag="N" s Total=Total+1
	q Total
}

/// 判断一个节点是否另一个节点的子节点，1:是,0:否
ClassMethod IsChildPar(ParentPar, ChildPar)
{
	new Flag,ParID
	s Flag=0
	s ParID=0
	f  s ParID=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",ParentPar,ParID))  quit:(ParID="")||(Flag="1")  d
	.s InvalidFlag=$p(^DHCEQCCode("DHCEQCEquipeCat",ParID),"^",7)
	.q:InvalidFlag'="N"
	.i ParID=ChildPar s Flag="1"
	.q:Flag="1"
	.s Flag=..IsChildPar(ParID,ChildPar)
	q Flag
}

/// 根据分类名称得到分类ID串，格式1^2^3,4^5
ClassMethod GetCatsID(CatName)
{
	i CatName="" q ""
	s CatName=$ZCONVERT(CatName,"U")
	s ReturnCatsID=""
	s CurrentCatID=""
	s ParID=0
	s Flag="N"
	s HasFlag="N"
	f  s ParID=$o(^DHCEQCCode("DHCEQCEquipeCat",ParID))  quit:(ParID="")  d
	.s ParName=$p(^DHCEQCCode("DHCEQCEquipeCat",ParID),"^",2)
	.s ParCode=$p(^DHCEQCCode("DHCEQCEquipeCat",ParID),"^",1)
	.s ParName=$ZCONVERT(ParName,"U")
	.s ParCode=$ZCONVERT(ParCode,"U")
	.i (ParName[CatName)||(ParCode[CatName) d
	..s HasFlag="N"
	..i ((ParName=CatName)||(ParCode=CatName))&&(Flag="N") d
	...s CurrentCatID=..GetParentCats(ParID)
	...s Flag="Y"
	...s HasFlag="Y"
	..i HasFlag="N" s ReturnCatsID=ReturnCatsID_..GetParentCats(ParID)_","
	i CurrentCatID'="" s ReturnCatsID=ReturnCatsID_CurrentCatID_","
	q $P(ReturnCatsID,",",1,$L(ReturnCatsID,",")-1)
}

ClassMethod GetParentCats(ParID)
{
	s ID=$p(^DHCEQCCode("DHCEQCEquipeCat",ParID),"^",4)
	i ID'="" s ParID=..GetParentCats(ID)_"^"_ParID
	//i ID="" q ParID
	q ParID
}

/// w ##Class(web.DHCEQCEquipeCat).GetCodeByCatID(1)
/// 取分类的代码，当前分类无代码则取父类的代码
ClassMethod GetCodeByCatID(ID)
{
	if ID="" q ""
	s Code=$p($g(^DHCEQCCode("DHCEQCEquipeCat",ID)),"^",1)
	///b
	if ((Code'="")&&(Code'=$c(0)))
	{	q Code	}
	else
	{
		s ID=$p($g(^DHCEQCCode("DHCEQCEquipeCat",ID)),"^",4)
		q ..GetCodeByCatID(ID)
	}
}

/// ;Modified by jdl 2012-3-7 JDL0120
/// ;使用年限如果分类上未定义，则获取设备类型上的定义
/// ;增加参数StatCatDR：设备类型DR
/// --------------------------------------------------
/// w ##Class(web.DHCEQCEquipeCat).GetYearsByCatID(1)
/// 取分类的使用年限，当前分类无代码则取父类的使用年限
/// ------------------------------------------------
ClassMethod GetYearsByCatID(ID, StatCatDR As %Library.String = "")
{
	n Years
	s Years=..GetYearsByCatIDOld(ID)
	i Years=""
	{
		i StatCatDR'="" s Years=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",9)
		if (Years=$c(0)) s Years=""
	}
	q Years
}

ClassMethod GetYearsByCatIDOld(ID)
{
	n Years
	if ID="" q ""
	s Years=$p($g(^DHCEQCCode("DHCEQCEquipeCat",ID)),"^",6)
	if ((Years'="")&&(Years'=$c(0)))
	{	q Years	}
	else
	{
		s ID=$p($g(^DHCEQCCode("DHCEQCEquipeCat",ID)),"^",4)
		q ..GetYearsByCatIDOld(ID)
	}
}

Query LookupEquipCat(EquipDR As %String) As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String")
{
}

ClassMethod LookupEquipCatExecute(ByRef qHandle As %Binary, val As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataLookupEquipCat
	Quit $$$OK
BuildDataLookupEquipCat
	s Code=""
	f  s Code=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",Code))  quit:Code=""  d
	.f  s rowid=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",Code,rowid))  quit:rowid=""  d
	..s TRowID = rowid
	..;s Code = $p($g(^DHCEQCCode("DHCEQCEquipeCat",rowid)),"^",1)
	..s Desc = $p($g(^DHCEQCCode("DHCEQCEquipeCat",rowid)),"^",2)
	..s ExCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",rowid)),"^",11)
	..q:(val'="")&&((Code'[val)&&(Desc'[val)&&(ExCode'[val))
	..d OutputRowLookupEquipCat
	quit
OutputRowLookupEquipCat
	s Data=$lb(TRowID,Desc,Code)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod LookupEquipCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupEquipCatExecute ]
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

ClassMethod LookupEquipCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupEquipCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQCEquipeCat).GetDepreMethodByCatID(1)
/// 取分类的折旧方法，当前分类无折旧方法则取父类的折旧方法
ClassMethod GetDepreMethodByCatID(ID)
{
	if ID="" q ""
	s DepreMethodDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",ID)),"^",9)
	if ((DepreMethodDR'="")&&(DepreMethodDR'=$c(0)))
	{	q DepreMethodDR	}
	else
	{
		s ID=$p($g(^DHCEQCCode("DHCEQCEquipeCat",ID)),"^",4)
		q ..GetDepreMethodByCatID(ID)
	}
}

/// add:zy 2011-03-23  No ZY0066
/// 取分类的所有子类
/// w ##Class(web.DHCEQCEquipeCat).GetChildIDsByCatID(2894,"")
ClassMethod GetChildIDsByCatID(ID)
{
	new ChildIDs,flag,rowid
	set ChildIDs=""
	if $order(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",ID,0))="" q ID
	set rowid=0
	set flag=0
	for  set rowid=$order(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",ID,rowid))  quit:rowid=""  d
	.set IDs=..GetChildIDsByCatID(rowid)
	.if flag=0  d
	..set IDs=ID_"^"_IDs
	..set flag=1
	.if ChildIDs="" do
	..set ChildIDs=IDs
	.else  do
	..set ChildIDs=ChildIDs_"^"_IDs
	quit ChildIDs
}

}
