/// add by HHM0027 20151022
/// 新增机组分类
Class web.DHCEQGroup Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("web.DHCEQGroup","Group","")
Query Group(Code As %String = "", Name As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,TDesc:%String,TRemark:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TFromDate:%String,TToDate:%String,TInvalidFlag:%String,THold1:%String,THold2:%String,THold3:%String")
{
}

ClassMethod GroupExecute(ByRef qHandle As %Binary, Code As %String = "", Name As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQGroup(rowid)) q:rowid=""  d 
	.d ResetVariablesGroup
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQGroup(rowid)),"^",1)
	.s TName=$p($g(^DHCEQGroup(rowid)),"^",2)
	.s TDesc=$p($g(^DHCEQGroup(rowid)),"^",3)
	.s TRemark=$p($g(^DHCEQGroup(rowid)),"^",4)
	.s TUpdateUserDR=$p($g(^DHCEQGroup(rowid)),"^",5)
	.s TUpdateDate=$p($g(^DHCEQGroup(rowid)),"^",6)
	.i TUpdateDate'="" s TUpdateDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroup(rowid)),"^",6),"date")
	.s TUpdateTime=$p($g(^DHCEQGroup(rowid)),"^",7)
	.;i TUpdateTime'="" s TUpdateTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroup(rowid)),"^",7),"time")
	.s TFromDate=$p($g(^DHCEQGroup(rowid)),"^",8)
	.i TFromDate'="" s TFromDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroup(rowid)),"^",8),"date")
	.s TToDate=$p($g(^DHCEQGroup(rowid)),"^",9)
	.i TToDate'="" s TToDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroup(rowid)),"^",9),"date")
	.s TInvalidFlag=$p($g(^DHCEQGroup(rowid)),"^",10)
	.i TInvalidFlag'="" s TInvalidFlag=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroup(rowid)),"^",10),"bool")
	.s THold1=$p($g(^DHCEQGroup(rowid)),"^",11)
	.s THold2=$p($g(^DHCEQGroup(rowid)),"^",12)
	.s THold3=$p($g(^DHCEQGroup(rowid)),"^",13)
	.d OutputRowGroup
	Quit $$$OK
OutputRowGroup
	s Data=$lb(TRowID,TCode,TName,TDesc,TRemark,TUpdateUserDR,TUpdateDate,TUpdateTime,TFromDate,TToDate,TInvalidFlag,THold1,THold2,THold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGroup
	s (TRowID,TCode,TName,TDesc,TRemark,TUpdateUserDR,TUpdateDate,TUpdateTime,TFromDate,TToDate,TInvalidFlag,THold1,THold2,THold3)=""
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

// w ##Class(web.DHCEQGroup).SaveData("^022^name2^desc3^remark3^^^^18/9/2015^11/5/2015^^^^^","")

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
	s $ZT="ERRORDeleteData"
 	s rowid=$p(val,"^",1)
 	s code=$p(val,"^",2)
 	s SQLCODE=0
 	i (+isDel=1)
 	{
	 	TSTART
	 	;&SQL(update sqluser.DHC_EQGroup set GR_InvalidFlag="Y" where GR_RowID=:rowid)
		&SQL(delete from sqluser.DHC_EQGroupList where GL_GroupDR=:rowid)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE 
	 	{
		 	TROLLBACK
		 	q rowid_"^"_SQLCODE
		}
	 	
	 	&SQL(delete from sqluser.DHC_EQGroup where GR_RowID=:rowid)
	 	i SQLCODE 
	 	{
		 	TROLLBACK
		 	q rowid_"^"_SQLCODE
		}
		TCOMMIT
	 	q rowid_"^"_SQLCODE
	}
	s PLIST(2)=$p(val,"^",2) ;code
	s PLIST(3)=$p(val,"^",3) ;name
	s PLIST(4)=$p(val,"^",4) ;desc
	s PLIST(5)=$p(val,"^",5) ;remark
	
	s PLIST(6)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) 
	s PLIST(7)=+$H  
	s PLIST(8)=$p($H,",",2)
	
	s PLIST(9)=""   ;add by kdf 2018-02-05 需求号：540461
	s PLIST(10)=""  ;add by kdf 2018-02-05 需求号：540461
	i $p(val,"^",9)'=""  s PLIST(9) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date") ;GR_FromDate
	i $p(val,"^",10)'="" s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date") ;GR_ToDate
	if PLIST(9)="" s PLIST(9)=+$H ;Add By QW20211112 BUG:QW0155 日期为空默认为当日
	if PLIST(10)="" s PLIST(10)=+$H ;Add By QW20211112 BUG:QW0155 日期为空默认为当日
	i +PLIST(9)>+PLIST(10) q ""_"^"_"开始日期大于结束日期！"      		;add by kdf 2018-02-05 需求号：540461
	i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"bool")	;GR_InvalidFlag
	
	s PLIST(12)=$p(val,"^",12) ;GR_Hold1
	s PLIST(13)=$p(val,"^",13) ;GR_Hold2
	s PLIST(14)=$p(val,"^",14) ;GR_Hold3
	
	s tmpid=0
	&SQL(select GR_RowID into:tmpid from sqluser.DHC_EQGroup where GR_Code=:code and GR_InvalidFlag!='Y')
	i ((tmpid'="")&(tmpid'=rowid)) q ""_"^"_"数据已存在！"
	i rowid=""
	{
		s PLIST(11)="N"  ;无效标志
		&SQL(insert into sqluser.DHC_EQGroup Values :PLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQGroup Values :PLIST() where GR_RowID = :rowid)
	}
	i SQLCODE q rowid_"^"_SQLCODE
	s rowid=$g(%ROWID)
	q rowid_"^"_SQLCODE
ERRORDeleteData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORDeleteData"_ErrorMsg     //返回错误消息
}

ClassMethod GetGroup(rowid)
{
	s Group=""
	s Group=$g(^DHCEQGroup(rowid))
	s Info=rowid
	s Info=Info_"^"_$p(Group,"^",1)
	s Info=Info_"^"_$p(Group,"^",2)
	s Info=Info_"^"_$p(Group,"^",3)
	s Info=Info_"^"_$p(Group,"^",4)
	s Info=Info_"^"_$p(Group,"^",5)
	s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(Group,"^",6),"date")
	s Info=Info_"^"_""  //##Class(web.DHCEQCommon).TransValueToPage($p(Group,"^",7),"time")
	s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(Group,"^",8),"date")
	s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(Group,"^",9),"date")
	s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(Group,"^",10),"bool")
	s Info=Info_"^"_$p(Group,"^",11)
	s Info=Info_"^"_$p(Group,"^",12)
	s Info=Info_"^"_$p(Group,"^",13)
	q Info
}

ClassMethod GetGroupNameByID(rowid)
{
	s Name=""
	s Name=$p($g(^DHCEQGroup(rowid)),"^",2)
	q Name
}

}
