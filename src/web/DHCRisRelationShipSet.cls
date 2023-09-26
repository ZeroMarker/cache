Import SQLUser

Class web.DHCRisRelationShipSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCRisRelationShipSet","QueryExamGroup","")
/// 查询名称：QueryExamGroup
/// 功能：查询检查项目组
/// 参数：itmMastDr^itemcatDR
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-12
/// d ##class(%ResultSet).RunQuery("web.DHCRisRelationShipSet","QueryExamGroup","")
Query QueryExamGroup(param As %String) As %Query(ROWSPEC = "Rowid:%String,GroupName:%String,GroupCode:%String,ItemMastDesc:%String,ItemMastDR:%String,ItemCatDesc:%String,ItemCatDr:%String,relationShip:%String")
{
}

ClassMethod QueryExamGroupExecute(ByRef qHandle As %Binary, param As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryExamGroup")=param
 s (itmMastDrIn,itemCatDrIn)=""
 s itmMastDrIn=$p($g(param),"^",1)
 s itemCatDrIn=$p($g(param),"^",2)
 s groupDr=0 f  s groupDr=$o(^DHCRBExamGroup(groupDr)) q:(groupDr="")  d
 .s (groupName,groupCode,itmMastDesc,itmMastDr,itemCatDesc,itemCatDr,relationShip,relationShipCode)=""
 .s groupName=$p($g(^DHCRBExamGroup(groupDr)),"^",1)
 .s groupCode=$p($g(^DHCRBExamGroup(groupDr)),"^",2)
 .s itmMastDr=$p($g(^DHCRBExamGroup(groupDr)),"^",3)
 .s itemCatDr=$p($g(^DHCRBExamGroup(groupDr)),"^",4)
 .q:((itmMastDrIn'="")&(itmMastDrIn'=itmMastDr))
 .q:((itemCatDrIn'="")&(itemCatDrIn'=itemCatDr))
 .s relationShipCode=$p($g(^DHCRBExamGroup(groupDr)),"^",5)
 .i relationShipCode="in"  d 
 ..s relationShip="包含"
 .else  if relationShipCode="out"  d
 ..s relationShip="不包含"
 .i itmMastDr'="" d
 ..s itmMastDesc=$p($g(^ARCIM($p(itmMastDr,"||",1),$p(itmMastDr,"||",2),1)),"^",2)
 .i itemCatDr'="" d
 ..s itemCatDesc=$p($g(^ARC("IC",itemCatDr)),"^",2)
 .Do QueryExamGroup
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryExamGroup
 set Data=$lb(groupDr,groupName,groupCode,itmMastDesc,itmMastDr,itemCatDesc,itemCatDr,relationShip)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryExamGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamGroupExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryExamGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamGroupExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryItemCatByName
/// 功能：查询检查子类
/// 参数：名字
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-12
/// d ##class(%ResultSet).RunQuery("web.DHCRisRelationShipSet","QueryItemCatByName","")
Query QueryItemCatByName(Name As %String) As %Query(ROWSPEC = "itemCatDr:%String,catDesc:%String,catCode:%String")
{
}

ClassMethod QueryItemCatByNameExecute(ByRef qHandle As %Binary, Name As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryItemCatByName")=Name
 s (itemCatDr,catDesc,catCode)=""
 f  s itemCatDr=$o(^ARC("IC",itemCatDr)) q:(itemCatDr="")  d
 .s catDesc=$p($g(^ARC("IC",itemCatDr)),"^",2)
 .s catCode=$p($g(^ARC("IC",itemCatDr)),"^",1)
 .i ((Name="")||(catDesc[Name)) d
 ..Do QueryItemCatByName
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryItemCatByName
 set Data=$lb(itemCatDr,catDesc,catCode)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryItemCatByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemCatByNameExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryItemCatByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemCatByNameExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// code :  "D"--delte  "A"--add  "M"--modify

//d ##class(web.DHCRisRelationShipSet).OperatetExamGroup(^DHCRisTemp("InsertExamGroup"))

ClassMethod OperatetExamGroup(Info As %String, Code As %String) As %String
{
 s ^DHCRisTemp("InsertExamGroup")=Info_"*"_Code
 s SQLCODE="100"
 s egRowid=$p(Info,"^",1)
 s name=$p(Info,"^",2)
 s id=$p(Info,"^",3)
 s itmMastDr=$p(Info,"^",4)
 s itemCatDr=$p(Info,"^",5)
 s relastionShip=$p(Info,"^",6)
 
 if ( Code = "A")
 {
 	if (itmMastDr'=""||itemCatDr'="")
 	{
 		&sql(insert into  DHCRB_ExamGroup(DREG_GroupName,DREG_GroupCode,DREG_ItmMast_DR,DREG_ItemCat_DR,DREG_RelationOfChildTable) 
 	      values (:name,:id,:itmMastDr,:itemCatDr,:relastionShip ))
 	}
 }
 elseif( Code= "M")
 {
	 if (egRowid '="")
	 {
		if (itmMastDr'=""||itemCatDr'="")
 		{
 			&sql(update  DHCRB_ExamGroup(DREG_GroupName,DREG_GroupCode,DREG_ItmMast_DR,DREG_ItemCat_DR,DREG_RelationOfChildTable) 
 	      		values (:name,:id,:itmMastDr,:itemCatDr,:relastionShip ) where DREG_RowID=:egRowid )
 		}
	 }
	 
 }
 elseif (Code= "D")
 {
	 if (egRowid '="")
	 {
		 &sql(delete from DHCRB_ExamGroup where DREG_RowID=:egRowid)
	 }
	 
 }
 q SQLCODE
}

/// 查询名称：QueryExamGroup
/// 功能：查询检查项目组子表
/// 参数：itmMastDr^itemcatDR
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-12
/// d ##class(%ResultSet).RunQuery("web.DHCRisRelationShipSet","QueryExamGroupItem","")
/// //(ROWSPEC = "Rowid:%String,GroupName:%String,GroupCode:%String,ItemMastDesc:%String,ItemMastDR:%String,ItemCatDesc:%String,ItemCatDr:%String,relationShip:%String")
Query QueryExamGroupItem(groupDR As %String) As %Query(ROWSPEC = "Rowid:%String,ItemMastDesc:%String,ItemMastDR:%String")
{
}

ClassMethod QueryExamGroupItemExecute(ByRef qHandle As %Binary, groupDR As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryExamGroupItem")=groupDR
 if (groupDR '="")
 {
 s itemSub="" f  s itemSub=$o(^DHCRBExamGroup(0,"ExamItem",groupDR,itemSub))  q:(itemSub="")  d
 .s (itemDR,groupName,groupCode,itmMastDesc,itmMastDr,itemCatDesc,itemCatDr,relationShip,relationShipCode)=""
 .s itemDR=groupDR_"||"_itemSub
 .s groupName=$p($g(^DHCRBExamGroup(groupDR)),"^",1)
 .s groupCode=$p($g(^DHCRBExamGroup(groupDR)),"^",2)
 .;s itmMastDr=$p($g(^DHCRBExamGroup(groupDr)),"^",3)
 .s itemCatDr=$p($g(^DHCRBExamGroup(groupDR)),"^",4)
 .i itemCatDr'="" d
 ..s itemCatDesc=$p($g(^ARC("IC",itemCatDr)),"^",2)
 .s relationShipCode=$p($g(^DHCRBExamGroup(groupDR)),"^",5)
 .i relationShipCode="in"  d 
 ..s relationShip="包含"
 .else  if relationShipCode="out"  d
 ..s relationShip="不包含"
 .s itmMastDr=$p($g(^DHCRBExamGroup(0,"ExamItem",groupDR,itemSub)),"^",1)
 .i itmMastDr'="" d
 ..s itmMastDesc=$p($g(^ARCIM($p(itmMastDr,"||",1),$p(itmMastDr,"||",2),1)),"^",2)
 .Do QueryExamGroupItem
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryExamGroupItem
 set Data=$lb(itemDR,itmMastDesc,itmMastDr)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryExamGroupItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamGroupItemExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryExamGroupItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamGroupItemExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryOrdItemInCat
/// 功能：查询医嘱子类下的符合规则的检查项目
/// 参数：
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-15
/// d ##class(%ResultSet).RunQuery("web.DHCRisRelationShipSet","QueryOrdItemInCat","")
Query QueryOrdItemInCat(ItemDesc As %String, itemCatDr As %String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,ItemRowID:%String")
{
}

ClassMethod QueryOrdItemInCatExecute(ByRef qHandle As %Binary, ItemDesc As %String, itemCatDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s index=1
	s ^DHCRisTemp("QueryOrdItemCSExamItem")=ItemDesc_"^"_itemCatDr
	if ( itemCatDr'="")
	{
	s ItemDesc=$g(ItemDesc)
	s ItemDesc=$ZCONVERT(ItemDesc,"U")
	s arcimSubscript="" f  s arcimSubscript=$o(^ARCIM(0,"ARCIC_DR",itemCatDr,arcimSubscript)) q:(arcimSubscript="")  d
	.s arcimVersion="" f  s arcimVersion=$o(^ARCIM(0,"ARCIC_DR",itemCatDr,arcimSubscript,arcimVersion)) q:(arcimVersion="")  d
	..s (arcimDesc,arcimRowid)=""
	..s (aliasDesc)=""
	..s arcimRowid=arcimSubscript_"||"_arcimVersion
	..s arcimDesc=$p($g(^ARCIM(arcimSubscript,arcimVersion,1)),"^",2)
	..i ItemDesc="" d
	...do QueryOrdItemInCat
	..else  d
	...if ( arcimDesc[ItemDesc) d
	....do QueryOrdItemInCat
	...else  d
	....s isInclusive=0
	....s aliasDr="" f  s aliasDr=$o(^ARC("ALIAS",0,"ARCIM",arcimRowid,aliasDr)) q:(aliasDr="")  d
	.....q:(isInclusive=1)
	.....s aliasDesc=$p(^ARC("ALIAS",aliasDr),"^",6)
	.....s aliasDesc=$ZCONVERT(aliasDesc,"U")
	.....if (($e((aliasDesc),1,$l(ItemDesc)))[ItemDesc) s isInclusive=1
	....i isInclusive=1 d
	.....do QueryOrdItemInCat
	}
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
QueryOrdItemInCat
	set Data=$lb(arcimDesc,arcimRowid)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod QueryOrdItemInCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdItemInCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOrdItemInCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdItemInCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// code :  "D"--delte  "A"--add  "M"--modify

//d ##class(web.DHCRisRelationShipSet).OperatetExamGroupItem()

ClassMethod OperatetExamGroupItem(Info As %String, Code As %String) As %String
{
 s ^DHCRisTemp("OperatetExamGroupItem")=Info_"*"_Code
 s SQLCODE="100"
 s egitemRowid=$p(Info,"^",1)
 s egRowid=$p(Info,"^",2)
 s itmMastDr=$p(Info,"^",3)
 
 if ( Code = "A")
 {
 	if ((itmMastDr'="")&&(egRowid'=""))
 	{
 		&sql(insert into DHCRB_ExamGroupItem(DHCRB_ExamGroup,DREGI_ItmMast_DR) values(:egRowid,:itmMastDr))
 	}
 }
 elseif( Code= "M")
 {
	 if (egitemRowid '="")
	 {
		if (itmMastDr'="")
 		{
 			&sql(update DHCRB_ExamGroupItem(DREGI_ItmMast_DR) values(:itmMastDr) where DHCRB_ExamGroupItem=:egitemRowid )
 		}
	 }
	 
 }
 elseif (Code= "D")
 {
	 if (egitemRowid '="")
	 {
		 &sql(delete from DHCRB_ExamGroupItem where DHCRB_ExamGroupItem=:egitemRowid)
	 }
	 
 }
 q SQLCODE
}

/**************************************
          下面是关系的查询
***************************************/
/// 查询名称：QueryRelationShip
/// 功能：查询检查项目组
/// 参数：
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-12
/// d ##class(%ResultSet).RunQuery("web.DHCRisRelationShipSet","QueryRelationShip","")
Query QueryRelationShip(param As %String) As %Query(ROWSPEC = "Rowid:%String,RelationShipName:%String,RelationShipType:%String,TypeCode:%String,IsCompulsory:%String,DetectionTime:%String")
{
}

ClassMethod QueryRelationShipExecute(ByRef qHandle As %Binary, param As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryRelationShip")=param
 s relationShipDr=0 f  s relationShipDr=$o(^DHCRBRelationShip(relationShipDr)) q:(relationShipDr="")  d
 .;w !,relationShipDr
 .s (desc,type,isCompulsory,detctionTime,typeCode)=""
 .s desc=$p($g(^DHCRBRelationShip(relationShipDr)),"^",1)
 .s typeCode=$p($g(^DHCRBRelationShip(relationShipDr)),"^",2)
 .s type=..getTypeDesc(typeCode)
 .s isCompulsory=$p($g(^DHCRBRelationShip(relationShipDr)),"^",3)
 .s detectionTime=$p($g(^DHCRBRelationShip(relationShipDr)),"^",4)
 .Do QueryRelationShip
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryRelationShip
 set Data=$lb(relationShipDr,desc,type,typeCode,isCompulsory,detectionTime)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryRelationShipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRelationShipExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryRelationShipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRelationShipExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// code :  "D"--delte  "A"--add  "M"--modify

//d ##class(web.DHCRisRelationShipSet).OperatetRelationShip()

ClassMethod OperatetRelationShip(Info As %String, Code As %String) As %String
{
 s ^DHCRisTemp("OperatetRelationShip")=Info_"*"_Code
 s SQLCODE="100"
 s rsDr=$p(Info,"^",1)
 s desc=$p(Info,"^",2)
 s type=$p(Info,"^",3)
 s isCompulsory=$p(Info,"^",4)
 s detectionTime=$p(Info,"^",5)
 
 if ( Code = "A")
 {
	 //rejection | sequence
 	if (type'="")
 	{
 		&sql(insert into DHCRB_RelationShip(DRRS_Name,DRRS_Type,DRRS_IsCompulsory,DRRS_DetectionTime) 
 		values (:desc,:type,:isCompulsory,:detectionTime))
 	}
 }
 elseif( Code= "M")
 {
	 if (rsDr '="")
	 {
		if (type'="")
 		{
 			&sql(update  DHCRB_RelationShip(DRRS_Name,DRRS_Type,DRRS_IsCompulsory,DRRS_DetectionTime) 
 		values (:desc,:type,:isCompulsory,:detectionTime) where DRRS_RowID=:rsDr )
 		}
	 }
	 
 }
 elseif (Code= "D")
 {
	 if (rsDr '="")
	 {
		 &sql(delete from DHCRB_RelationShip where  DRRS_RowID=:rsDr)
	 }
	 
 }
 q SQLCODE
}

/// 查询名称：QueryRelationShipItem
/// 功能：查询检查项目组
/// 参数：relationShipDr
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-12
/// d ##class(%ResultSet).RunQuery("web.DHCRisRelationShipSet","QueryRelationShipItem","")
Query QueryRelationShipItem(relationShipDr As %String) As %Query(ROWSPEC = "ShipItemDr:%String,ExamGroupDesc:%String,ExamGroupCode:%String,ExamGroupDr:%String,SequenceNumber:%String,MinimumTime:%String,MaxmumTime:%String")
{
}

ClassMethod QueryRelationShipItemExecute(ByRef qHandle As %Binary, relationShipDr As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryRelationShipItem")=relationShipDr
 if ( relationShipDr'="")
 {
 s childsub=0 f  s childsub=$o(^DHCRBRelationShip(0,"RelationShipItem",relationShipDr,childsub)) q:(childsub="")  d
 .s (ExamGroupDesc,ExamGroupCode,ExamGroupDr,SequenceNumber,MinimumTime,MaxmumTime)=""
 .s ShipItemDr=relationShipDr_"||"_childsub
 .s ExamGroupDr=$p($g(^DHCRBRelationShip(0,"RelationShipItem",relationShipDr,childsub)),"^",1)
 .s SequenceNumber=$p($g(^DHCRBRelationShip(0,"RelationShipItem",relationShipDr,childsub)),"^",2)
 .s MinimumTime=$p($g(^DHCRBRelationShip(0,"RelationShipItem",relationShipDr,childsub)),"^",3)
 .s MaxmumTime=$p($g(^DHCRBRelationShip(0,"RelationShipItem",relationShipDr,childsub)),"^",4)
 .if (ExamGroupDr'="") d
 ..s ExamGroupDesc=$p($g(^DHCRBExamGroup(ExamGroupDr)),"^",1)
 ..s ExamGroupCode=$p($g(^DHCRBExamGroup(ExamGroupDr)),"^",2)
 .Do QueryRelationShipItem
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryRelationShipItem
 set Data=$lb(ShipItemDr,ExamGroupDesc,ExamGroupCode,ExamGroupDr,SequenceNumber,MinimumTime,MaxmumTime)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryRelationShipItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRelationShipItemExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryRelationShipItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRelationShipItemExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// code :  "D"--delte  "A"--add  "M"--modify

//d ##class(web.DHCRisRelationShipSet).OperatetRelationShipItem()

ClassMethod OperatetRelationShipItem(Info As %String, Code As %String) As %String
{
 s ^DHCRisTemp("OperatetRelationShip")=Info_"*"_Code
 s SQLCODE="100"
 s shipItemDr=$p(Info,"^",1)
 s shipDr=$p(Info,"^",2)
 s groupDr=$p(Info,"^",3)
 s sequenceNumber=$p(Info,"^",4)
 s minimumTime=$p(Info,"^",5)
 s maxmumTime=$p(Info,"^",6)
 
 if ( Code = "A")
 {
	 //rejection | sequence
 	if (shipDr'="")
 	{
 		&sql(insert into DHCRB_RelationShipItem(DHCRB_RelationShip,DRRSI_ExamGroup_DR,DRRSI_SequenceNumber,DRRSI_MinimumTimeInterval,DRRSI_MaxmumTimeInterval)
 		values(:shipDr,:groupDr,:sequenceNumber,:minimumTime,:maxmumTime))
 	}
 }
 elseif( Code= "M")
 {
	 if (shipItemDr '="")
	 {
		if (groupDr'="")
 		{
 			&sql(update  DHCRB_RelationShipItem(DRRSI_ExamGroup_DR,DRRSI_SequenceNumber,DRRSI_MinimumTimeInterval,DRRSI_MaxmumTimeInterval)
 		      values(:groupDr,:sequenceNumber,:minimumTime,:maxmumTime) where DHCRB_RelationShipItem=:shipItemDr )
 		}
	 }
	 
 }
 elseif (Code= "D")
 {
	 if (shipItemDr '="")
	 {
		 &sql(delete from DHCRB_RelationShipItem where DHCRB_RelationShipItem=:shipItemDr)
	 }
	 
 }
 q SQLCODE
}

/// do ##class(web.DHCRisRelationShipSet).GetRelationShipTypeList()
ClassMethod GetRelationShipTypeList() As %String
{
	s ret="rejection"_$c(1)_"排斥"_"^"_"sequence"_$c(1)_"顺序"
	q ret
}

/// do ##class(web.DHCRisRelationShipSet).GetYesNoList()
ClassMethod GetYesNoList() As %String
{
	s ret="Y"_$c(1)_"Y"_"^"_"N"_$c(1)_"N"
	q ret
}

/// do ##class(web.DHCRisRelationShipSet).getTypeDesc()
ClassMethod getTypeDesc(code As %String) As %String
{
	s ret=""
	if ( code="rejection")
	{
		s ret="排斥"
	}
	elseif ( code="sequence")
	{
		s ret="顺序"
	}
	q ret
}

}
