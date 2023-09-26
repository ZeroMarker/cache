/// Created By HZY 2012-03-15 
/// Desc:拒绝记录
/// --------------------------------------------------------
Class web.DHCEQRefuseRecord Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 每次执行'拒绝'操作后,都插入一条新的纪录.
ClassMethod UpdateRefuseRecord(SourceType, SourceID, val)
{
	//val=RefuseRecordDR_"^"_RefuseReason_"^"_RefuseRemark_"^"_CurRole_"^"_RoleStep
	k PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s rowid=$p(val,"^",1)		//RR_RowID
	
	s PLIST(2)=SourceType		//RR_SourceType
	s PLIST(3)=SourceID			//RR_SourceID
	s PLIST(4)=$p(val,"^",2)	//RR_RefuseReason
	s PLIST(5)=$p(val,"^",3)	//RR_Remark
	s PLIST(6)=User				//RR_RefuseUserDR
	s PLIST(7)=+$H				//RR_RefuseDate	
	s PLIST(8)=$P($H,",",2)		//RR_RefuseTime
	s PLIST(9)=$p(val,"^",4)	//RR_RoleDR
	s PLIST(10)=$p(val,"^",5)	//RR_FlowStep
	s PLIST(11)=$p(val,"^",6)	//RR_Hold1
	s PLIST(12)=$p(val,"^",7)	//RR_Hold2
	s PLIST(13)=$p(val,"^",8)	//RR_Hold3
	
	&SQL(Insert Into SQLUSER.DHC_EQRefuseRecord Values :PLIST())
	//&SQL(Update SQLUSER.DHC_EQRefuseRecord Values :PLIST() Where RR_RowID=:rowid)
	s ID=$g(%ROWID)
	q SQLCODE_"^"_ID
}

/// w ##Class(web.DHCEQRefuseRecord).GetOneRefuseRecord("20","13","")
ClassMethod GetOneRefuseRecord(SourceType, SourceID, rowid)
{
	new result,resultEx,RowID
	s (result,resultEx,RowID)=""
	s RowID=rowid
	if ((RowID="")&&(SourceType'="")&&(SourceID'=""))
	{
		s RowID=$o(^DHCEQRefuseRecord("0","Source",SourceType,SourceID,""),-1)
	}
	elseif ((RowID="")&&((SourceType="")||(SourceID="")))
	{
		q -2001
	}
	if (RowID="")
	{
		q ""
	}
	s result=^DHCEQRefuseRecord(RowID)
	s resultEX=resultEx_"^"		//RR_RefuseUserDR
	if $p(result,"^",5)'=""
	{
		s resultEx=resultEx_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",5))
	}
	s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")
	s resultEX=resultEx_"^"		//RR_RoleDR
	if $p(result,"^",8)'=""
	{
		s resultEx=resultEx_$p($g(^DHCEQCCode("DHCEQCApproveRole",$p(result,"^",8))),"^",2)
	}
	q RowID_"^"_result_resultEx
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQRefuseRecord","GetRefuseRecord","")
Query GetRefuseRecord(SourceType As %String = "", SourceID As %String = "", RowID As %String = "", RefuseUserDR As %String = "", RoleDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TRefuseReason:%String,TRemark:%String,TRefuseUserDR:%String,TRefuseUser:%String,TRefuseDate:%String,TRefuseTime:%String,TRoleDR:%String,TRole:%String,TFlowStep:%String,THold1:%String,THold2:%String,THold3:%String")
{
}

ClassMethod GetRefuseRecordExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", RowID As %String = "", RefuseUserDR As %String = "", RoleDR As %String = "") As %Status
{
	new repid,index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i RowID="" s RowID=0
	if RowID'=0
	{
		d BuildDataGetRefuseRecordInfo
	}
	else
	{
		if ((SourceType'="")&&(SourceID'=""))
		{
			f  s RowID=$o(^DHCEQRefuseRecord("0","Source",SourceType,SourceID,RowID))  quit:RowID=""  d
			.d BuildDataGetRefuseRecordInfo
		}
		else
		{
			f  s RowID=$o(^DHCEQRefuseRecord(RowID))  quit:RowID=""  d
			.d BuildDataGetRefuseRecordInfo
		}
	}
	Quit $$$OK
BuildDataGetRefuseRecordInfo
	d ResetVariablesGetRefuseRecordInfo
	s TRowID=RowID
	s TSourceType=$p($g(^DHCEQRefuseRecord(RowID)),"^",1)
	q:(SourceType'="")&&(SourceType'=TSourceType)
	s TSourceType=..GetSourceTypeDesc(TSourceType)
	s TSourceID=$p($g(^DHCEQRefuseRecord(RowID)),"^",2)
	q:(SourceID'="")&&(SourceID'=TSourceID)
	s TRefuseUserDR=$p($g(^DHCEQRefuseRecord(RowID)),"^",5)
	q:(RefuseUserDR'="")&&(RefuseUserDR'=TRefuseUserDR)
	i TRefuseUserDR'="" s TRefuseUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRefuseUserDR)
	s TRoleDR=$p($g(^DHCEQRefuseRecord(RowID)),"^",8)
	q:(RoleDR'="")&&(RoleDR'=TRoleDR)
	i TRoleDR'="" s TRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TRoleDR)
	s TRefuseReason=$p($g(^DHCEQRefuseRecord(RowID)),"^",3)
	s TRemark=$p($g(^DHCEQRefuseRecord(RowID)),"^",4)
	s TRefuseDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQRefuseRecord(RowID)),"^",6),"date")
	s TRefuseTime=$p($g(^DHCEQRefuseRecord(RowID)),"^",7)
	s TFlowStep=$p($g(^DHCEQRefuseRecord(RowID)),"^",9)
	s THold1=$p($g(^DHCEQRefuseRecord(RowID)),"^",10)
	s THold2=$p($g(^DHCEQRefuseRecord(RowID)),"^",11)
	s THold3=$p($g(^DHCEQRefuseRecord(RowID)),"^",12)
	d OutputRowGetRefuseRecordInfo
	quit
OutputRowGetRefuseRecordInfo
   	s Data=$lb(TRowID,TSourceType,TSourceID,TRefuseReason,TRemark,TRefuseUserDR,TRefuseUser,TRefuseDate,TRefuseTime,TRoleDR,TRole,TFlowStep,THold1,THold2,THold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRefuseRecordInfo
	s (TRowID,TSourceType,TSourceID,TRefuseReason,TRemark,TRefuseUserDR,TRefuseUser,TRefuseDate,TRefuseTime,TRoleDR,TRole,TFlowStep,THold1,THold2,THold3)=""
	quit
}

ClassMethod GetRefuseRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRefuseRecordExecute ]
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

ClassMethod GetRefuseRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRefuseRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSourceTypeDesc(ID)
{
	i ID="0" q "无"
	i ID="1" q "研究课题"
	i ID="2" q "安装调试验收"
	i ID="3" q "入库"
	i ID="4" q "转移"
	i ID="5" q "减少"
	i ID="6" q "维修"
	i ID="7" q "保养"
	i ID="8" q "检查"
	i ID="9" q "报废"
	i ID="10" q "折旧"
	i ID="11" q "使用"
	i ID="12" q "设备调帐"
	i ID="13" q "采购申请"
	i ID="14" q "采购计划"
	i ID="15" q "采购招标"
	i ID="16" q "采购合同"
	i ID="17" q "开箱验收"	
	q "未定义"
}

}
