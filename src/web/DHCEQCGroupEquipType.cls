Import SQLUser

Class web.DHCEQCGroupEquipType Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 58;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

// 安全组访问类组

Parameter SQLCODE = "GET_RowID";

Parameter SQLDESCRIPTION = "GET_RowID";

Parameter SQLROWID = "GET_RowID";

ClassMethod GroupEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupEquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GroupEquipTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetGroupEquipType
	Quit $$$OK
BuildDataGetGroupEquipType
	f  s rowid=$o(^DHCEQCCode("DHCEQCGroupEquipType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetGroupEquipType
	.s LROWID=rowid	//rowid
	.s LGroup=$p(^DHCEQCCode("DHCEQCGroupEquipType",rowid),"^",1)
	.i LGroup'="" s LTGroup=$p(^SSU("SSGRP",LGroup),"^",1)
	.s LTEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCGroupEquipType",rowid)),"^",2) //
	.i LTEquipTypeDR'="" s LTEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",LTEquipTypeDR)),"^",2) //
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCGroupEquipType",rowid)),"^",3)
	.//q:LTInvalidFlag="Y"
	.d OutputGroupEquipType
	quit
OutputGroupEquipType
   s Data=$lb(LTGroup,LGroup,LROWID,LTEquipTypeDR,LTEquipType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupEquipType
	s (LTGroup,LGroup,LROWID,LTEquipTypeDR,LTEquipType)=""
	quit
}

ClassMethod GroupEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupEquipTypeExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQCGroupEquipType","GroupEquipType")
Query GroupEquipType() As %Query(ROWSPEC = "TGroup:%String,TGroupDR:%String,TRowID:%String,TEquipTypeDR:%String,TEquipType:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCUOM",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p(^DHCEQCCode("DHCEQCGroupEquipType",rowid),"^",1)
	s resultex=resultex_"^"	//
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p(^SSU("SSGRP",$p(^DHCEQCCode("DHCEQCGroupEquipType",rowid),"^",1)),"^",1)
	s resultex=resultex_"^"	//
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCGroupEquipType",rowid)),"^",2)
	s resultex=resultex_"^"	//
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p($g(^DHCEQCCode("DHCEQCGroupEquipType",rowid)),"^",2))),"^",2)
	q resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String = "", Codetable As %Library.String = "", isDel As %Library.String = "", DefaultFlag)
{
 k PLIST,rowid
  s PLIST(2) = RowID	;安全组
  s PLIST(3) = Codetable	;代码
  s PLIST(4) = DefaultFlag
  i (+isDel=1)
 {
  &SQL(select GET_RowID into :Rowid from DHC_EQCGroupEquipType where GET_GroupDR=:RowID and GET_EquipTypeDR=:Codetable)
 	if (Rowid="")
 	{
 	&SQL(Insert Into SQLUSER.DHC_EQCGroupEquipType Values :PLIST())
 	}
 	else
 	{
	 	&SQL(update SQLUSER.DHC_EQCGroupEquipType Values :PLIST() where GET_RowID=:Rowid)
 	}
 }
 i (+isDel=2)
 {
	 &SQL(select GET_RowID into :Rowid from DHC_EQCGroupEquipType where GET_GroupDR=:RowID and GET_EquipTypeDR=:Codetable)
 	if (Rowid'="")
 	{
	 	&SQL(Delete From SQLUSER.DHC_EQCGroupEquipType where GET_RowID = :Rowid)
 		q Rowid
 	}
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod CodetableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodetableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CodetableExecute(ByRef qHandle As %Binary, RowID As %String) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	n TRowID,TDesc,TDefaultFlag,TSelected,GETRowID
	s TRowID=0
	f  s TRowID=$o(^DHCEQCCode("DHCEQCEquipType",TRowID))  quit:TRowID=""  d
	.s (TSelected,TDefaultFlag)=""
	.;Modified by jdl 2011-12-20 JDL0106
	.q:$p(^DHCEQCCode("DHCEQCEquipType",TRowID),"^",4)="Y"
	.s TDesc=$p(^DHCEQCCode("DHCEQCEquipType",TRowID),"^",2)
	.s GETRowID=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",RowID,TRowID,0))
	.i GETRowID'=""  d
	..s TSelected="Y"
	..s TDefaultFlag=$p(^DHCEQCCode("DHCEQCGroupEquipType",GETRowID),"^",3)
	.i TDefaultFlag'="" s TDefaultFlag=##Class(web.DHCEQCommon).TransValueToPage(TDefaultFlag,"bool")	//Add By DJ 2016-12-05
	.d OutputCodetable
	Quit $$$OK
OutputCodetable
	s TRow=TRow+1
   	s Data=$lb(TDesc,TRowID,TSelected,TDefaultFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod CodetableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CodetableExecute ]
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

Query Codetable(RowID As %String) As %Query(ROWSPEC = "TCodetable:%String,TROWID:%String,TPutIn:%String,TDefaultFlag:%String,TRow:%String")
{
}

/// Modefied by zc 2015-07-23 zc0027
/// 描述：限定管理
/// Modefied by zc 2015-07-30 zc0027
/// 描述：添加输出列accessflag
/// d ##class(%ResultSet).RunQuery("web.DHCEQCGroupEquipType","GetGroupEquipType","","","")
Query GetGroupEquipType(Group As %String = "") As %Query(ROWSPEC = "rowid:%String,groupdr:%String,group:%String,equiptypedr:%String,equiptype:%String,defaultflag:%String,accessflag:%String")
{
}

ClassMethod GetGroupEquipTypeExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s erowid=0
	f  s erowid=$o(^DHCEQCCode("DHCEQCEquipType",erowid))  quit:erowid=""  d
	.d ResetVariablesGroupEquipType
	.q:($p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",4)="Y")
	.s groupdr=Group
	.s group=$p(^SSU("SSGRP",Group),"^",1)
	.s equiptypedr=erowid
	.s equiptype=$p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",2)
	.i $D(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",Group,erowid)) d
	..s rowid=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",Group,erowid,0))
	.i rowid="" d
	..s defaultflag="N"
	..s accessflag="N"
	.e  d
	..s defaultflag=$p($g(^DHCEQCCode("DHCEQCGroupEquipType",rowid)),"^",3) 
	..s accessflag="Y"
	.d OutputRowGetGroupEquipType
	Quit $$$OK
OutputRowGetGroupEquipType
	set Data=$lb(rowid,groupdr,group,equiptypedr,equiptype,defaultflag,accessflag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGroupEquipType
	Set (rowid,groupdr,group,equiptypedr,equiptype,defaultflag,accessflag)=""
	Quit
}

ClassMethod GetGroupEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupEquipTypeExecute ]
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

ClassMethod GetGroupEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupEquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// w ##Class(SaveGroupEquipType).SaveGroupEquipType("") 

/// Modefied by zc 2015-07-30 zc0027
/// 描述：修改保存方法
ClassMethod SaveGroupEquipType(PTData)
{
	k PLIST
	s PLIST(1)=$p($G(PTData),"^",1)
	s PLIST(2)=$p($G(PTData),"^",2)
	s PLIST(3)=$p($G(PTData),"^",3)
	s PLIST(4)=$p($G(PTData),"^",4)
	s PLIST(5)=$p($G(PTData),"^",5)
	i (PLIST(5)'="Y")	//Y：安全组允许访问类组
	{
		i (PLIST(1)'="") 
		{
			&SQL(delete from SQLUser.DHC_EQCGroupEquipType  where GET_RowID=:PLIST(1))
		}
		else
		{
			q ""
		}
	}
	else
	{
		i (PLIST(1)'="") 
		{	
			s GETRowID=PLIST(1)
			k PLIST(1)
			&SQL(update  SQLUser.DHC_EQCGroupEquipType Values :PLIST() where GET_RowID=:GETRowID)
		}
		else  
		{	
			k PLIST(1)
			&SQL(insert into sqluser.DHC_EQCGroupEquipType values :PLIST())
		}
	}
	if SQLCODE  q SQLCODE
	q $g(%ROWID)
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCGroupEquipType","Group")
Query Group(Group As %String = "") As %Query(ROWSPEC = "rowid:%String,group:%String")
{
}

ClassMethod GroupExecute(ByRef qHandle As %Binary, Group As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s growid=0
	d BuildDataGetGroup
	Quit $$$OK
BuildDataGetGroup 
	f  s growid=$o(^SSU("SSGRP",growid))  quit:growid=""  d
	.d ResetVariablesGetGroup
	.s rowid=growid	//rowid
	.s group=$p(^SSU("SSGRP",growid),"^",1)
	.q:(Group'="")&&(group'[Group)
	.d OutputGroup
	quit
OutputGroup
   s Data=$lb(rowid,group)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroup
	s (rowid,group)=""
	quit
}

ClassMethod GroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupExecute ]
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

ClassMethod GroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
