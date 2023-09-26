Class web.DHCEQ.RM.SCShareItemCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 资源项目分类
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.SCShareItemCat","GetShareItemCat","")
Query GetShareItemCat(Code As %String = "", Desc As %String = "", ShareType As %String = "", HospitalDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TShareType:%String,TCode:%String,TDesc:%String,THospital:%String,TRemark:%String,THospitalDR:%String,TShareTypeDR:%String")
{
}

ClassMethod GetShareItemCatExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ShareType As %String = "", HospitalDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Desc=$ZCONVERT(Desc ,"U")
 	Set Code=$ZCONVERT(Code ,"U")  //Modefied by zc0094 2021-01-13 代码转化
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQSCShareItemCat(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesShareItemCat
	.Set TRowID = rowid
	.s TShareTypeDR=$Piece($Get(^DHCEQSCShareItemCat(TRowID)),"^",1)
	.s TShareType=$CASE(TShareTypeDR,"1":"设备","":"")
	.Set TCode=$Piece($Get(^DHCEQSCShareItemCat(TRowID)),"^",2) //代码
	.Set TDesc=$Piece($Get(^DHCEQSCShareItemCat(TRowID)),"^",3) //描述
	.s THospitalDR=$Piece($Get(^DHCEQSCShareItemCat(TRowID)),"^",5)
	.q:(HospitalDR'="")&&(THospitalDR'=HospitalDR)
	.i THospitalDR'="" s THospital=$Piece($Get(^CT("HOSP",THospitalDR)),"^",2)
	.s TRemark=$Piece($Get(^DHCEQSCShareItemCat(TRowID)),"^",6)
	.Set TInvalidFlag=$Piece($Get(^DHCEQSCShareItemCat(TRowID)),"^",7) //无符号标志
	.Quit:TInvalidFlag="Y"
	.Quit:($ZCONVERT(TCode,"U")'[Code)&&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&&(Desc'="")
	.Do OutputRowGetShareItemCat
	Quit $$$OK
OutputRowGetShareItemCat
   	Set Data=$lb(TRowID,TShareType,TCode,TDesc,THospital,TRemark,THospitalDR,TShareTypeDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesShareItemCat
	Set (TRowID,TShareType,TCode,TDesc,THospital,TRemark,THospitalDR,TShareTypeDR)=""
	Quit
}

ClassMethod GetShareItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShareItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetShareItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShareItemCatExecute ]
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

ClassMethod SaveDataCat(Data, DelIs)
{
	s $ZT="ERRORShareItemCat"
	k PLIST,RowID
	
	TSTART
	if DelIs=1
	{
		s RowID=Data
		&SQL(Update SQLUSER.DHC_EQSCShareItemCat set SIC_InvalidFlag='Y' where SIC_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
		s RowID = JsonData.SICRowID
		s Code = JsonData.SICCode
		
		&SQL(Select SIC_RowID Into :SICRowID from SQLUSER.DHC_EQSCShareItemCat Where SIC_InvalidFlag='N' and SIC_Code=:Code)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSCShareItemCat",JsonData,.PLIST)
		s PLIST(8)="N" //无效标志处理
		if (SICRowID="")||(SICRowID=RowID)
		{
			if RowID'=""
		    {
				&SQL(Update SQLUSER.DHC_EQSCShareItemCat Values :PLIST() where SIC_RowID = :RowID)
			}
			else
			{
				&SQL(insert into SQLUSER.DHC_EQSCShareItemCat Values :PLIST())
			}
		}
		else
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
		}
		s RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORShareItemCat
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 资源项目
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.SCShareItemCat","GetShareItem","","","","","","","","1084","")
Query GetShareItem(ShareType As %String = "", Code As %String = "", Desc As %String = "", ShareItemCatDR As %String = "", HospitalDR As %String = "", WashFlag As %String = "", InspectFlag As %String = "", ItemDR As %String = "", ModelDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TShareType:%String,TCode:%String,TDesc:%String,TShareItemCat:%String,THospital:%String,TWashFlag:%String,TInspectFlag:%String,TRemark:%String,THospitalDR:%String,TShareItemCatDR:%String,TWashFlagDR:%String,TInspectFlagDR:%String,TShareTypeDR:%String")
{
}

ClassMethod GetShareItemExecute(ByRef qHandle As %Binary, ShareType As %String = "", Code As %String = "", Desc As %String = "", ShareItemCatDR As %String = "", HospitalDR As %String = "", WashFlag As %String = "", InspectFlag As %String = "", ItemDR As %String = "", ModelDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Desc=$ZCONVERT(Desc ,"U")
	Set Code=$ZCONVERT(Code ,"U")    //Modefied by zc0107 2021-11-14 将代码转化成大写
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQSCShareItem(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesShareItem
	.Set TRowID = rowid
	.s TShareTypeDR=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",1)
	.q:(ShareType'="")&&(TShareTypeDR'=ShareType)	 //Modefied by zc0107 2021-11-14 条件过滤
	.s TShareType=$CASE(TShareTypeDR,"1":"设备","":"")
	.Set TCode=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",2) //代码
	.Set TDesc=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",3) //描述
	.q:($ZCONVERT(TCode,"U")'[Code)&&(Code'="")	//Modefied by zc0107 2021-11-14 条件过滤
	.q:($ZCONVERT(TDesc,"U")'[Desc)&&(Desc'="")		//Modefied by zc0107 2021-11-14 条件过滤	
	.s TShareItemCatDR=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",4)	;MZY0111	2414721		2022-01-14
	.q:(ShareItemCatDR'="")&&(TShareItemCatDR'=ShareItemCatDR)		//Modefied by zc0107 2021-11-14 条件过滤
	.i TShareItemCatDR'="" s TShareItemCat=$Piece($Get(^DHCEQSCShareItemCat(TShareItemCatDR)),"^",3) 
	.s THospitalDR=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",5)
	.q:(THospitalDR'="")&&(##Class(web.DHCEQCommon).CheckHOSLimit(THospitalDR)=0) ;Add by QW20200507
	.q:(HospitalDR'="")&&(THospitalDR'=HospitalDR)
	.i THospitalDR'="" s THospital=$Piece($Get(^CT("HOSP",THospitalDR)),"^",2)
	.s TWashFlagDR=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",6)
	.s TWashFlag=$CASE(TWashFlagDR,"Y":"是","N":"否","":"")
	.s TInspectFlagDR=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",7)
	.s TInspectFlag=$CASE(TInspectFlagDR,"Y":"是","N":"否","":"")
	.s TRemark=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",8)
	.Set TInvalidFlag=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",9) //无符号标志
	.Quit:TInvalidFlag="Y"
	.Quit:($ZCONVERT(TCode,"U")'[Code)&&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&&(Desc'="")
	.;Modify by zx 2020-05-18 Bug ZX0088
	.q:(##Class(web.DHCEQ.RM.SCShareItemCat).CheckShareItemList(TRowID,ItemDR,ModelDR))'=0
	.Do OutputRowGetShareItem
	Quit $$$OK
OutputRowGetShareItem
   	Set Data=$lb(TRowID,TShareType,TCode,TDesc,TShareItemCat,THospital,TWashFlag,TInspectFlag,TRemark,THospitalDR,TShareItemCatDR,TWashFlagDR,TInspectFlagDR,TShareTypeDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesShareItem
	Set (TRowID,TShareType,TCode,TDesc,TShareItemCat,THospital,TWashFlag,TInspectFlag,TRemark,THospitalDR,TShareItemCatDR,TWashFlagDR,TInspectFlagDR,TShareTypeDR)=""
	Quit
}

ClassMethod GetShareItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShareItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetShareItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShareItemExecute ]
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

ClassMethod SaveDataItem(Data, DelIs)
{
	s $ZT="ERRORShareItem"
	k PLIST,RowID
	
	TSTART
	if DelIs=1
	{
		s RowID=Data
		&SQL(Update SQLUSER.DHC_EQSCShareItem set SI_InvalidFlag='Y' where SI_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
		s RowID = JsonData.SIRowID
		s Code = JsonData.SICode
		s WashFlag=JsonData.SIWashFlag
		s InspectFlag=JsonData.SIInspectFlag
		&SQL(Select SI_RowID Into :SIRowID from SQLUSER.DHC_EQSCShareItem Where SI_InvalidFlag='N' and SI_Code=:Code)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSCShareItem",JsonData,.PLIST)
		if (WashFlag="true")
		{
			s PLIST(7)="Y"	
		}else{
				s PLIST(7)="N"
			}
		if (InspectFlag="true")
		{
			s PLIST(8)="Y"	
		}else{
				s PLIST(8)="N"
			}
		s PLIST(10)="N" //无效标志处理
		if (SIRowID="")||(SIRowID=RowID)
		{
			if RowID'=""
		    {
				&SQL(Update SQLUSER.DHC_EQSCShareItem Values :PLIST() where SI_RowID = :RowID)
			}
			else
			{
				&SQL(insert into SQLUSER.DHC_EQSCShareItem Values :PLIST())
			}
		}
		else
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
		}
		s RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORShareItem
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 资源项目明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.SCShareItemCat","GetShareItemList","")                  
Query GetShareItemList(ShareItemDR As %String = "", ItemDR As %String = "", Name As %String = "", ModelDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TShareItem:%String,TItem:%String,TName:%String,TModel:%String,TShareItemDR:%String,TItemDR:%String,TModelDR:%String")
{
}

ClassMethod GetShareItemListExecute(ByRef qHandle As %Binary, ShareItemDR As %String = "", ItemDR As %String = "", Name As %String = "", ModelDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Name=$ZCONVERT(Name ,"U")
	Set index=1
	Set rowid=0
	q:ShareItemDR=""  /// modify hly 20200521
	For  Set rowid=$Order(^DHCEQSCShareItemList(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesShareItemList
	.Set TRowID = rowid
	.Set TInvalidFlag=$Piece($Get(^DHCEQSCShareItemList(TRowID)),"^",5) 
	.Quit:TInvalidFlag="Y"
	.s TShareItemDR=$Piece($Get(^DHCEQSCShareItemList(TRowID)),"^",1)
	.q:(ShareItemDR'=TShareItemDR)
	.i TShareItemDR'="" s TShareItem=$Piece($Get(^DHCEQSCShareItem(TShareItemDR)),"^",3)
	.Set TItemDR=$Piece($Get(^DHCEQSCShareItemList(TRowID)),"^",2)
	.q:(ItemDR'="")&&(ItemDR'=TItemDR) 
	.i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.Set TName=$Piece($Get(^DHCEQSCShareItemList(TRowID)),"^",3)
	.q:(Name'="")&&($ZCONVERT(TName,"U")'[Name) 
	.s TModelDR=$Piece($Get(^DHCEQSCShareItemList(TRowID)),"^",4)
	.q:(ModelDR'="")&&(ModelDR'=TModelDR)
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.Do OutputRowGetShareItemList
	Quit $$$OK
OutputRowGetShareItemList
   	Set Data=$lb(TRowID,TShareItem,TItem,TName,TModel,TShareItemDR,TItemDR,TModelDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesShareItemList
	Set (TRowID,TShareItem,TItem,TName,TModel,TShareItemDR,TItemDR,TModelDR)=""
	Quit
}

ClassMethod GetShareItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShareItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetShareItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShareItemListExecute ]
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

/// modify hly 20200521
/// 添加新参数：SILShareItemDR（资源项目的RowID）
ClassMethod SaveDataItemList(Data, DelIs, SILShareItemDR)
{
	s $ZT="ERRORShareItemList"
	k PLIST,RowID
	
	TSTART
	if DelIs=1
	{
		s RowID=Data
		&SQL(Update SQLUSER.DHC_EQSCShareItemList set SIL_InvalidFlag='Y' where SIL_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
		s RowID = JsonData.SILRowID
		s Name = JsonData.SILName
		
		&SQL(Select SIL_RowID Into :SILRowID from SQLUSER.DHC_EQSCShareItemList Where SIL_InvalidFlag='N' and SIL_Name=:Name)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSCShareItemList",JsonData,.PLIST)
		s PLIST(2)=SILShareItemDR //add hly 20200521
		s PLIST(6)="N" //无效标志处理
		if (SILRowID="")||(SILRowID=RowID)
		{
			if RowID'=""
		    {
				&SQL(Update SQLUSER.DHC_EQSCShareItemList Values :PLIST() where SIL_RowID = :RowID)
			}
			else
			{
				&SQL(insert into SQLUSER.DHC_EQSCShareItemList Values :PLIST())
			}
		}
		else
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
		}
		s RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORShareItemList
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Creator：      ZC
/// CreatDate：    2020-05-15
/// Description:   价格定义中来源为设备项时取资源项目明细中的设备项
/// Input：        Desc:描述 
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.SCShareItemCat","GetResourceItem","")
Query GetResourceItem(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String")
{
}

ClassMethod GetResourceItemExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	d ##Class(web.DHCEQCommon).KillTempGlobal("GetResourceItem")
	Set rowid=0
	For  Set rowid=$Order(^DHCEQSCShareItemList(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesResourceItem
	.q:$Piece($Get(^DHCEQSCShareItem($Piece($Get(^DHCEQSCShareItemList(rowid)),"^",1))),"^",9)="Y"
	.Quit:$Piece($Get(^DHCEQSCShareItemList(rowid)),"^",5)="Y"
	.Set TItemDR=$Piece($Get(^DHCEQSCShareItemList(rowid)),"^",2)
	.q:TItemDR=""
	.;q:$d(^DHCEQTemp("GetResourceItem",+$H,$J,TItemDR))
	.s THospitalDR=$Piece($Get(^DHCEQSCShareItem($Piece($Get(^DHCEQSCShareItemList(rowid)),"^",1))),"^",5)
	.q:(THospitalDR'="")&&(##Class(web.DHCEQCommon).CheckHOSLimit(THospitalDR)=0) ;Add by QW20200507
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",3),"","",2)'=0  //Modefied by zc0094 2021-1-14 修正检索不到简易设备项
	.Set TName=$Piece($Get(^DHCEQSCShareItemList(rowid)),"^",3)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",2)
	.q:(Desc'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Desc,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Desc,"U")))
	.;s ^DHCEQTemp("GetResourceItem",+$H,$J,TItemDR)=""
	.s TRowID=TItemDR
	.Do OutputRowGetResourceItem
	Quit $$$OK
OutputRowGetResourceItem
   	Set Data=$lb(TRowID,TName,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesResourceItem
	Set (TRowID,TName,TCode,THospitalDR)=""
	Quit
}

ClassMethod GetResourceItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResourceItemExecute ]
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

ClassMethod GetResourceItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourceItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Modify by zx 2020-05-18 Bug ZX0088
/// w ##Class(web.DHCEQ.RM.SCShareItemCat).CheckShareItemList("1","1084","")
ClassMethod CheckShareItemList(CurShareItemDR As %String = "", ItemDR As %String = "", ModelDR As %String = "")
{
	i (ItemDR="")&&(ModelDR="") q 0
	i CurShareItemDR="" q 1
	s Flag=1
	s ShareItemListDR=0
	f  s ShareItemListDR=$o(^DHCEQSCShareItemList(0,"ShareItem",CurShareItemDR,ShareItemListDR)) q:(ShareItemListDR="")||(Flag=0)  d
	.s TItemDR=$P($G(^DHCEQSCShareItemList(ShareItemListDR)),"^",2)
	.s TModelDR=$P($G(^DHCEQSCShareItemList(ShareItemListDR)),"^",4)
	.//Modify by zx 2020-06-29 BUG ZX0095
	.i TModelDR'="" d
	..i (ItemDR=TItemDR)&&(ModelDR=TModelDR) s Flag=Flag-1
	.e  d
	..i ItemDR=TItemDR s Flag=Flag-1
	
	q Flag
}

}
