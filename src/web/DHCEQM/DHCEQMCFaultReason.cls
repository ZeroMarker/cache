/// --------------------------------------------
/// Created By LZY 2013-9-25 . Bug LZY0003
/// Description:在设备维护菜单下新增故障现象子菜单?实现对故障现象信息的管理?
/// --------------------------------------------
Class web.DHCEQM.DHCEQMCFaultReason Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCFaultReason", "Faultreason", "")
Query Faultreason(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String,TRow:%String")
{
}

ClassMethod FaultreasonExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 s Desc=$ZCONVERT(Desc ,"U")		//转换为大写?
 s Code=$ZCONVERT(Code ,"U")
 s Remark=$ZCONVERT(Remark ,"U")

 //s Type=$ZCONVERT(Type ,"U")
	s index=1
	s rowid=0
	s TRow=0
	d BuildDataGetFaultreason
	Quit $$$OK
BuildDataGetFaultreason
	f  s rowid=$o(^DHCEQCCode("DHCEQMCFaultReason",rowid))  quit:rowid=""  d
	.d ResetVariablesGetFaultreason
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",1) //代码	
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",2) //描述	
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",4) //无符号标志
	.//s TType=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",4) //替换内容
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.//q:($ZCONVERT(TType,"U")'[Type)&(Type'="")	
	.d OutputRowGetFaultreason
	quit
OutputRowGetFaultreason
	s TRow=TRow+1
    s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFaultreason
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod FaultreasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FaultreasonExecute ]
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

ClassMethod FaultreasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FaultreasonExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// w ##class(web.DHCEQMCFaultReason).GetDataByGroupID("3")
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
	.Set resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultReason",$Piece(result,"^",2))),"^",2) //系统类型
	s result=rowid_"^"_result_"^"_resultex
	q result
}

ClassMethod GetDataByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCFaultReason",rowid)
	q result
}

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 s PLIST(5)="Y"
 &SQL(Update SQLUSER.DHC_EQMCFaultReason Values :PLIST() where FR_RowID = :rowid) 
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
	 s PLIST(5) = "N"	//Modify DJ 2014-09-22
	 //s PLIST(5)=$p(val,"^",5)
	 //s Type=$p(val,"^",5)
	 //s PLIST(7)=$p(val,"^",7)
	 //s PLIST(8)=$p(val,"^",8)
	 //s PLIST(9)=$p(val,"^",9)
	
	 s tmpid=""
	 &SQL(select FR_RowID into :tmpid from SQLUSER.DHC_EQMCFaultReason where (FR_Code=:Code or FR_Desc=:Desc) and FR_InvalidFlag!='Y') //modified by csj 20190601 
	
	if (rowid="")
	{ //新增
		if (tmpid'="") //若已存在
		{
			s SQLCODE=-1001
		}
		else //若不存在 则插入数据
		{
			&SQL(Insert Into SQLUSER.DHC_EQMCFaultReason Values :PLIST())
		}
	}
	else
	{ //更新
		if (tmpid'="")
		{
			if (tmpid=rowid)
			{
				&SQL(Update SQLUSER.DHC_EQMCFaultReason Values :PLIST() where FR_RowID = :rowid)
			}
			else
			{
				s SQLCODE=-1001
			}
		}
		else
		{
			&SQL(Update SQLUSER.DHC_EQMCFaultReason Values :PLIST() where FR_RowID = :rowid)
		}
	}
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/// w ##class(web.DHCEQMCFaultReason).SaveGroupSysTypeData("^1^8^^^")
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

Query LookUp(para) As %SQLQuery(ROWSPEC = "Desc:%String,Hidden:%String,Code:%String")
{
	SELECT FR_Desc,
		   FR_RowID,
		   FR_Code
	FROM sqluser.DHC_EQMCFaultReason
	where FR_InvalidFlag = 'N' and FR_Desc like nvl(:para,'')||'%'
}

/// 20150112  Mozy0149
/// w ##Class(web.DHCEQCFaultReason).UpdFaultReason("01^AAA")
ClassMethod UpdFaultReason(data)
{
	n frrowid,OperMethod,code,desc
	Set frrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503002")
	if (OperMethod=0)||(desc="") Quit ""
	&SQL(Select FR_RowID Into :frrowid from SQLUSER.DHC_EQMCFaultReason Where FR_InvalidFlag='N' and FR_Desc=:desc)
	if frrowid=""
	{
		if code=""
		{
			Set frrowid=$Order(^DHCEQCCode("DHCEQMCFaultReason",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",frrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQMCFaultReason(FR_Code, FR_Desc, FR_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			Quit SQLCODE
		}
		Set frrowid=$Get(%ROWID)
	}
	Quit frrowid
}

}
