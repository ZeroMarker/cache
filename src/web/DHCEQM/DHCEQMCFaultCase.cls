Class web.DHCEQM.DHCEQMCFaultCase Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// add By HHM 20150904 HHM0006

// 添加控制，不允许输入与已有数值相同的字段

// 返回值添加："^UpdateMsg"、"^DeleteMsg"、"^DeleteMsg"字段

ClassMethod SaveData(val, isDel As %Library.String = "")
{
	k PLIST,RowID
    s RowID=$p(val,"^",1)
	//s RowID=""
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)="N"
	i (+isDel=1)
	{
		&SQL(update SQLUSER.DHC_EQMCFaultCase set FC_InvalidFlag='Y' where FC_RowID=:RowID) 
	}
	else
	{
		s Code=$p(val,"^",2)
		s Desc=$p(val,"^",3)
		s SQLCODE=0
		s tmpRowID=""
		&SQL(select FC_RowID into:tmpRowID from SQLUSER.DHC_EQMCFaultCase where (FC_Code=:Code or FC_Desc=:Desc) and FC_InvalidFlag!='Y') //modified by csj 20190601
		if ((tmpRowID'="")&(tmpRowID'=RowID)) q -3001
	  	if RowID=""
	  	{
	    	&SQL(insert into SQLUSER.DHC_EQMCFaultCase values:PLIST())
	  	}
	  	else 
	  	{
	     	&SQL(update SQLUSER.DHC_EQMCFaultCase values:PLIST() where FC_RowID=:RowID)
	  	}
	}
	if SQLCODE q SQLCODE
	s ID=$g(%ROWID)
	q ID
}

Query FaultCase(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String,TRow:%String")
{
}

ClassMethod FaultCaseExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")

	s index=1
	s rowid=0
	s TRow=0
	//s TJob=$j
	
	d BuildDataGetFaultCase
	
	//d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQMCFaultCase.FaultCase",TJob,index-1)
	
	Quit $$$OK
BuildDataGetFaultCase
	f  s rowid=$o(^DHCEQCCode("DHCEQMCFaultCase",rowid))  quit:rowid=""  d
	.d ResetVariablesGetFaultCase
	.s LTRowID = rowid	//rowid
	.s LTCode=$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",1) //代码
	.s LTDesc=$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",2) //描述
	.s LTRemark=$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",3) //备注
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",4) //无符号标志
	.q:LTInvalidFlag="Y"
	.q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(LTRemark,"U")'[Remark)&(Remark'="")
	.d OutputRowGetFaultCase
	quit
OutputRowGetFaultCase
	s TRow=TRow+1
   	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFaultCase
	s (LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag)=""
	quit
}

ClassMethod FaultCaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FaultCaseExecute ]
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

ClassMethod FaultCaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FaultCaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCFaultCase",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",1)
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",4) //
	q resultex
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
SELECT FC_Desc,
	   FC_RowID,
	   FC_Code
FROM sqluser.DHC_EQMCFaultCase
where FC_InvalidFlag = 'N' and FC_Desc like nvl(:para,'')||'%'
}

/// 创建:ZC 2015-02-02  ZC0019
/// 目的:系统自动录入故障现象
/// 描述:检测故障现象表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:故障现象
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQM.DHCEQMCFaultCase).UpdFaultCase("ddddddddddd")
ClassMethod UpdFaultCase(data)
{
	n fcrowid,FaultCaseOperMethod,FaultCase,code,desc
	s fcrowid=""
	s code=$ZCONVERT($p(data,"^",1),"U")
	s desc=$ZCONVERT($p(data,"^",2),"U")
	s SQLCODE=0
	s FaultCaseOperMethod=##class(web.DHCEQCommon).GetSysInfo("503004")
	if (FaultCaseOperMethod=0)||(desc="") q ""
	&SQL(Select FC_RowID Into:fcrowid from SQLUSER.DHC_EQMCFaultCase Where FC_InvalidFlag='N' and FC_Desc=:desc)
	if fcrowid="" //新增当前故障现象
	{
		&SQL(Insert Into SQLUSER.DHC_EQMCFaultCase (FC_Code,FC_Desc,FC_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			q SQLCODE
		}
		s fcrowid=$G(%ROWID)
	}
	q fcrowid
}

}
