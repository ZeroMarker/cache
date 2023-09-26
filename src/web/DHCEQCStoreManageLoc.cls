/// 创建:ZY  2009-07-06   BugNo.：ZY0025
/// -----------------------
Class web.DHCEQCStoreManageLoc Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:ZY  2009-07-06   BugNo.：ZY0025
/// 描述：显示库房能够管理的科室
Query StoreManageLoc(ID As %String = "", LocDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TLoc:%String,TLocDR:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod StoreManageLocExecute(ByRef qHandle As %Binary, ID As %String = "", LocDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	i LocDR'=""  d
	.s rowid=0
	.f  s rowid=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",ID,LocDR,rowid))  quit:rowid=""  d
	..d BuildDataStoreManageLoc
	e  d
	.s LocDR=0
	.f  s LocDR=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",ID,LocDR))  quit:LocDR=""  d
	..s rowid=0
	..f  s rowid=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",ID,LocDR,rowid))  quit:rowid=""  d
	...d BuildDataStoreManageLoc
	Quit $$$OK
BuildDataStoreManageLoc	
	d ResetVariablesStoreManageLoc  
	s TRowID= rowid
	s TLocDR = LocDR
	s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	s TRemark = $p($g(^DHCEQCCode("DHCEQCStoreManageLoc",rowid)),"^",3)	//
	s THold1 = $p($g(^DHCEQCCode("DHCEQCStoreManageLoc",rowid)),"^",4)	//
	s THold2 = $p($g(^DHCEQCCode("DHCEQCStoreManageLoc",rowid)),"^",5)	//
	s THold3 = $p($g(^DHCEQCCode("DHCEQCStoreManageLoc",rowid)),"^",6)	//
	s THold4 = $p($g(^DHCEQCCode("DHCEQCStoreManageLoc",rowid)),"^",7)	//
	s THold5 = $p($g(^DHCEQCCode("DHCEQCStoreManageLoc",rowid)),"^",8)	//
	d OutputRowStoreManageLoc
	quit
OutputRowStoreManageLoc
	s Data=$lb(TRowID,TLoc,TLocDR,TRemark,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesStoreManageLoc
	s (TRowID,TLoc,TLocDR,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod StoreManageLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreManageLocExecute ]
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

ClassMethod StoreManageLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreManageLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建:ZY  2009-07-06   BugNo.：ZY0025
/// 描述：显示库房明细
Query GetStoreLocList(GroupCode As %Library.String = "", LGTCode As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TStoreLoc:%String,TStoreLocDR:%String,TRow:%String")
{
}

ClassMethod GetStoreLocListExecute(ByRef qHandle As %Binary, GroupCode As %Library.String = "", LGTCode As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetStoreLocList
	Quit $$$OK
BuildDataGetStoreLocList
	f  s rowid=$o(^DHCEQCCode("DHCEQCLocGroup",rowid)) q:rowid=""  d
	.s Code=$p($g(^DHCEQCCode("DHCEQCLocGroup",rowid)),"^",1)
	.q:(GroupCode'="")&&(Code'=GroupCode)
	.s Hidden=$p($g(^DHCEQCCode("DHCEQCLocGroup",rowid)),"^",5)
	.q:Hidden="Y"
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCLocGroup",rowid)),"^",7)
	.q:InvalidFlag="Y"
	.s LGTRowID=0
	.f  s LGTRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",rowid,LGTCode,LGTRowID)) q:LGTRowID=""  d
	..s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGTRowID)),"^",5)
	..q:InvalidFlag="Y"
	..s LTLocDR=0
	..f  s LTLocDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTRowID,LTLocDR)) q:LTLocDR=""  d
	...d ResetVariablesGetStoreLocList
	...s TRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTRowID,LTLocDR,0))
	...s TStoreLocDR=LTLocDR
	...s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",LTLocDR)
	...d OutputRowGetStoreLocList
	quit
OutputRowGetStoreLocList
	s Data=$lb(TRowID,TStoreLoc,TStoreLocDR,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetStoreLocList
	s (TRowID,TStoreLoc,TStoreLocDR)=""
	quit
}

ClassMethod GetStoreLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreLocListExecute ]
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

ClassMethod GetStoreLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创建:ZY  2009-07-06   BugNo.：ZY0025
/// 描述：增删改操作
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
		
	 k PLIST,rowid
	 s rowid=$p(val,"^",1)
	 if (+isDel=1)
	 {
	 	&SQL(Delete From SQLUser.DHC_EQCStoreManageLoc where LML_RowID = :rowid)
	 	if SQLCODE  q SQLCODE
 		q rowid
	 }
	 s PLIST(2) = $p(val,"^",2)	;类型
	 s StoreLocDR= $p(val,"^",2)
	 s PLIST(3) = $p(val,"^",3)	;科室id
	 s LocDR=$p(val,"^",3)
	 s PLIST(4) = $p(val,"^",4)	;remark
	 s PLIST(5) = $p(val,"^",5) ;Hold1
	 s PLIST(6) = $p(val,"^",6) ;Hold2
	 s PLIST(7) = $p(val,"^",7) ;Hold3
	 s PLIST(8) = $p(val,"^",8) ;Hold4
	 s PLIST(9) = $p(val,"^",9) ;Hold5
	 s Flag=##class(web.DHCEQCommon).GetSysInfo("990013") //科室是否属于唯一库房, 0:否 1:是
	 //判断重复记录
	 if (Flag=0)
	 {
		 s Find=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",StoreLocDR,LocDR,0))
		 if (rowid="")
		 {
			 if (Find'="")
			 {
				 q "^此科室已在该库房管理范围内!"
			 }
			 else
			 {
				 &SQL(Insert Into SQLUSER.DHC_EQCStoreManageLoc Values :PLIST())
			 }
		 }
		 else
		 {
			 if (Find'="")&&(rowid'=Find)
			 {
				 q "^此科室已在该库房管理范围内!"
			 }
			 else
			 {
				 &SQL(Update SQLUSER.DHC_EQCStoreManageLoc Values :PLIST() where LML_RowID = :rowid)
			 }
		 }
	 }
	 else
	 {
		 s FindStoreLoc=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",LocDR,0))
		 s Find=""
		 i FindStoreLoc'=""
		 {
			 s FindStoreDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",FindStoreLoc)
			 i (FindStoreLoc'=StoreLocDR) q "^此科室已在["_FindStoreDesc_"]库房中存在!"
			 s Find=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",LocDR,FindStoreLoc,0))
		 }
		 if (rowid="")
		 {
			 if (FindStoreLoc'="")
			 {
				 q "^此科室已在["_FindStoreDesc_"]库房中存在!"
			 }
			 else
			 {
				 &SQL(Insert Into SQLUSER.DHC_EQCStoreManageLoc Values :PLIST())
			 }
		 }
		 else
		 {
			 if (Find'="")&&(Find'=rowid)
			 {
				 q "^此科室已在["_FindStoreDesc_"]库房中存在!"
			 }
			 else
			 {
				 &SQL(Update SQLUSER.DHC_EQCStoreManageLoc Values :PLIST() where LML_RowID = :rowid)
			 }
		 }
	 }
	 if SQLCODE  q SQLCODE
	 Set ID=$g(%ROWID)
	 q ID
}

/// 创建:ZY  2009-07-06   BugNo.：ZY0025
/// 描述：根据id取数据
ClassMethod GetDataByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCStoreManageLoc",rowid)
	s resultex=resultex_"^"
	i $p(result,"^",1)'=""  d 
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",1))
	s resultex=resultex_"^"
	i $p(result,"^",2)'=""  d 
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s result=result_"^"_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 检测科室是否为相应的类型
/// Type: 为0：判断Loc2是否为Loc1库房管理的科室，用于判断是否可分配或可退库等情况
/// 		 为1：判断Loc1和Loc2是否为同一库房管理的科室，用于判断是否允许直接调配等情况
/// 返回：0为非
/// 		 1为是
ClassMethod CheckManageLoc(Type, Loc1, Loc2)
{
	n (Type,Loc1,Loc2)		//Modify DJ 2015-08-19	DJ0157
	if (Type="")||(Loc1="")||(Loc2="") q 0
	//i $D(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc"))=0 q 1  //单院区的时候不需要库房管理科室的设置,把这个节点清空,不影响正常业务.
	i ##class(web.DHCEQCommon).GetSysInfo("990033")'="1" q 1		//单院区的时候不需要库房管理科室的设置改为用系统参数判断 Add By DJ 2015-08-20 DJ0157
	s Flag=0
	if (Type=0)
	{
		s RowID=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",Loc1,Loc2,0))
		i RowID'="" s Flag=1
	}
	elseif  (Type=1)
	{
		s StoreLocDR=0
		f  s StoreLocDR=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",Loc1,StoreLocDR)) q:((StoreLocDR="")||(Flag=1))  d
		.s RowID=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",StoreLocDR,Loc2,0))
		.i RowID'="" s Flag=1		
	}
	q Flag
}

}
