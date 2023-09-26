/// --------------------------------------------
/// Created By LZY 2013-9-25 . Bug LZY0001
/// Description:在设备维护菜单下新增维修方式子菜单?实现对维修方式信息的管理?
/// --------------------------------------------
Class web.DHCEQM.DHCEQMCMaintMode Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEQMCMaintMode).GetDataByGroupID("3")
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
	.Set resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCMaintMode",$Piece(result,"^",2))),"^",2) //系统类型
	s result=rowid_"^"_result_"^"_resultex
	q result
}

ClassMethod GetDataByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCMaintMode",rowid)
	s result=result_"^"_$CASE($p(result,"^",4),"1":"保养用","2":"检查用","3":"维修用","":"")	// Mozy0252	826989		2020-3-3
	q result
}

ClassMethod MaintModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod MaintModeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Type As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)

 s Desc=$ZCONVERT(Desc ,"U")		//转换为大写?
 s Code=$ZCONVERT(Code ,"U")
 s Remark=$ZCONVERT(Remark ,"U")
 s Type=$ZCONVERT(Type ,"U")	

	s index=1
	s rowid=0
	s TRow=1
	d BuildDataGetMaintMode
	Quit $$$OK
BuildDataGetMaintMode
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintMode",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintMode
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",1) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",2) //描述
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",5) //无符号标志
	.s TType=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",4) //替换内容
	.s TTypeDesc=$CASE(TType,"1":"保养用","2":"检查用","3":"维修用","":"")	// Mozy0252	826989		2020-3-3
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.q:($ZCONVERT(TType,"U")'[Type)&(Type'="")	
	.d OutputRowGetMaintMode
	quit
OutputRowGetMaintMode
 	s Data=$lb(TRowID,TCode,TDesc,TType,TInvalidFlag,TRemark,TRow,TTypeDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetMaintMode
	s (TRowID,TCode,TDesc,TType,TInvalidFlag,TRemark,TTypeDesc)=""
	quit
}

ClassMethod MaintModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintModeExecute ]
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

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 s PLIST(6)="Y"
 &SQL(Update SQLUSER.DHC_EQMCMaintMode Values :PLIST() where MM_RowID = :rowid) 
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
	 s PLIST(6) = "N"		//Modify DJ 2014-09-23
	 s PLIST(5)=$p(val,"^",5)	//Modify DJ 2014-09-23
	 //s Type=$p(val,"^",5)
	 
	 //s PLIST(7)=$p(val,"^",7)
	 //s PLIST(8)=$p(val,"^",8)
	 //s PLIST(9)=$p(val,"^",9)
	
	 s tmpid=""
	  &SQL(select MM_RowID into :tmpid from SQLUSER.DHC_EQMCMaintMode where MM_Code=:Code and MM_Desc=:Desc and MM_InvalidFlag='N')
	
	if (rowid="")
	{ //新增
		if (tmpid'="") //若已存在
		{
			s SQLCODE=-1001
		}
		else //若不存在 则插入数据
		{
			&SQL(Insert Into SQLUSER.DHC_EQMCMaintMode Values :PLIST())
		}
	}
	else
	{ //更新
		if (tmpid'="")
		{
			if (tmpid=rowid)
			{
				&SQL(Update SQLUSER.DHC_EQMCMaintMode Values :PLIST() where MM_RowID = :rowid)
			}
			else
			{
				s SQLCODE=-1001
			}
		}
		else
		{
			&SQL(Update SQLUSER.DHC_EQMCMaintMode Values :PLIST() where MM_RowID = :rowid)
		}
	}
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/// w ##class(web.DHCEQMCMaintMode).SaveGroupSysTypeData("^1^8^^^")
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

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,Hidden:%String,Code:%String")
{
	SELECT MM_Desc,
		   MM_RowID,
		   MM_Code
	FROM sqluser.DHC_EQMCMaintMode
	where MM_InvalidFlag = 'N' and MM_Desc like nvl(:para,'')||'%'
}

/// do ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCMaintMode", "MaintMode", "")
/// modified by czf 406181 增加TRow并输出
Query MaintMode(Code As %String = "", Desc As %String = "", Type As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TType:%String,TInvalidFlage:%String,TRemark:%String,TRow:%String,TTypeDesc:%String")
{
}

/// Creator：      Mozy
/// CreatDate：    2020-3-3			826989
/// Description:   维修保养类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCMaintMode","TypeList")
Query TypeList() As %Query(ROWSPEC = "TDesc:%String:类型名称,TRowID:%String,TCode:%String:代码")
{
}

ClassMethod TypeListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=1
	s Code="01"
	s Desc="保养用"
	d OutputRowTypeList
	s rowid=2
	s Code="02"
	s Desc="检查用"
	d OutputRowTypeList
	s rowid=3
	s Code="03"
	s Desc="维修用"
	d OutputRowTypeList
	
	Quit $$$OK
OutputRowTypeList
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod TypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TypeListExecute ]
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

ClassMethod TypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
