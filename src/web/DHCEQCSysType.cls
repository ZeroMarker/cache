Import SQLUser

/// --------------------------------------------
/// Created By HZY 2011-7-21 . Bug HZY0002
/// Description:在代码维护菜单下新增系统类型子菜单，实现对系统类型信息的管理。
/// --------------------------------------------
Class web.DHCEQCSysType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,Hidden:%String,Code:%String")
{
	SELECT ST_Desc,
		   ST_RowID,
		   ST_Code
	FROM sqluser.DHC_EQCSysType
	where ST_InvalidFlag = 'N' and ST_Desc like nvl(:para,'')||'%'
}

/// w ##class(web.DHCEQCSysType).SaveGroupSysTypeData("^1^8^^^")
ClassMethod SaveGroupSysTypeData(val As %Library.String = "")
{
	 k PLIST
	 new rowid ,SQLCODE,tmpid
	 s rowid=$p(val,"^",1)	
	 s PLIST(1) = $p(val,"^",1)
	 s PLIST(2) = $p(val,"^",2)	
	 s GroupDR = $p(val,"^",2)
	 s PLIST(3) = $p(val,"^",3)
	 s SysTypeDR= $p(val,"^",3)
	 s PLIST(4) = $p(val,"^",4)
	 s PLIST(5) = $p(val,"^",5)
	 s PLIST(6) = $p(val,"^",6)
	
	 s tmpid=""
	 &SQL(select GST_RowID into :tmpid from SQLUSER.DHC_EQCGroupSysType where GST_GroupDR=:GroupDR )
	 if tmpid=""
	 {
		&SQL(Insert Into SQLUSER.DHC_EQCGroupSysType Values :PLIST())	 
	 }
	 else
	 {
		&SQL(Update SQLUSER.DHC_EQCGroupSysType Values :PLIST() where GST_RowID = :rowid) 			 
	 }
	 
	 if SQLCODE  q SQLCODE
	 Set ID=$g(%ROWID)
	 q ID
}

/// w ##class(web.DHCEQCSysType).GetDataByGroupID("3")
ClassMethod GetDataByGroupID(GroupID As %Library.String = "")
{
	new rowid,resultex
	s (rowid,resultex)=""
	s rowid= $order(^DHCEQCCode("DHCEQCGroupSysType",0,"GroupDR",GroupID,0))
	i rowid="" q ""
	s result=$g(^DHCEQCCode("DHCEQCGroupSysType",rowid))
	If $Piece(result,"^",1)'=""  Do   ;GroupDR
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("grp",$Piece(result,"^",1)) //安全组
	s resultex="^"
	If $Piece(result,"^",2)'=""  Do   ;SysTypeDR
	.Set resultex=resultex_$p($g(^DHCEQCCode("DHCEQCSysType",$Piece(result,"^",2))),"^",2) //系统类型
	s result=rowid_"^"_result_"^"_resultex
	q result
}

Query SysType(Code As %String = "", Desc As %String = "", ReplaceContent As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TReplaceContent:%String,TInvalidFlage:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,TRow:%String")
{
}

ClassMethod SysTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ReplaceContent As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")		//转换为大写。
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")
 	s ReplaceContent=$ZCONVERT(ReplaceContent ,"U")
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetSysType
	Quit $$$OK
BuildDataGetSysType
	f  s rowid=$o(^DHCEQCCode("DHCEQCSysType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetSysType
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCSysType",rowid)),"^",1) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCSysType",rowid)),"^",2) //描述
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCSysType",rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCSysType",rowid)),"^",4) //无符号标志
	.s TReplaceContent=$p($g(^DHCEQCCode("DHCEQCSysType",rowid)),"^",5) //替换内容
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.q:($ZCONVERT(TReplaceContent,"U")'[ReplaceContent)&(ReplaceContent'="")
	.s THold1=$p($g(^DHCEQCCode("DHCEQCSysType",rowid)),"^",6)
	.s THold2=$p($g(^DHCEQCCode("DHCEQCSysType",rowid)),"^",7)
	.s THold3=$p($g(^DHCEQCCode("DHCEQCSysType",rowid)),"^",8)
	.d OutputRowGetSysType
	quit
OutputRowGetSysType
   s Data=$lb(TRowID,TCode,TDesc,TReplaceContent,TInvalidFlag,TRemark,THold1,THold2,THold3,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetSysType
	s (TRowID,TCode,TDesc,TReplaceContent,TInvalidFlag,TRemark,THold1,THold2,THold3)=""
	quit
}

ClassMethod SysTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SysTypeExecute ]
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

ClassMethod SysTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SysTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	s PLIST(5)="Y"
 	&SQL(Update SQLUSER.DHC_EQCSysType Values :PLIST() where ST_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
 else
 {
	 s PLIST(2) = $p(val,"^",2)	
	 s Code= $p(val,"^",2)
	 s PLIST(3) = $p(val,"^",3)
	 s Desc= $p(val,"^",3)
	 s PLIST(4) = $p(val,"^",4)
	 s Remark =$p(val,"^",4)
	 s PLIST(5) = "N"
	 s PLIST(6)=$p(val,"^",6)
	 s ReplaceContent=$p(val,"^",6)
	 s PLIST(7)=$p(val,"^",7)
	 s PLIST(8)=$p(val,"^",8)
	 s PLIST(9)=$p(val,"^",9)
	
	 s tmpid=""
	  &SQL(select ST_RowID into :tmpid from DHC_EQCSysType where ST_Code=:Code and ST_Desc=:Desc and ST_InvalidFlag='N')
	
	if (rowid="")
	{ //新增
		if (tmpid'="") //若已存在
		{
			s SQLCODE=-1001
		}
		else //若不存在 则插入数据
		{
			&SQL(Insert Into SQLUSER.DHC_EQCSysType Values :PLIST())
		}
	}
	else
	{ //更新
		if (tmpid'="")
		{
			if (tmpid=rowid)
			{
				&SQL(Update SQLUSER.DHC_EQCSysType Values :PLIST() where ST_RowID = :rowid)
			}
			else
			{
				s SQLCODE=-1001
			}
		}
		else
		{
			&SQL(Update SQLUSER.DHC_EQCSysType Values :PLIST() where ST_RowID = :rowid)
		}
	}
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetDataByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCSysType",rowid)
	q result
}

}
