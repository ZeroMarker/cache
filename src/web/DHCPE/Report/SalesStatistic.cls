Import SQLUser

/// 创建时间		：2007.07.03
/// 创建人			：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			:
/// 主要功能		:
/// 主要功能		：
/// 最后修改时间	：
/// 最后修改人		：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.Report.SalesStatistic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 112;

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.SalesStatistic","SalesStatistic","","","",+$H)
Query SalesStatistic(SalesDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Query(ROWSPEC = "SS_SalesName:%String, SS_Amount:%String")
{
}

ClassMethod SalesStatisticExecute(ByRef qHandle As %Binary, SalesDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Status
{
 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
 	

 	if ((""=SalesDR) && (""=DateBegin) && (""=DateEnd)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	
 	k ^SSTMP

	s PIADMSalesDR=0
	f  s PIADMSalesDR=$O(^DHCPEPreIADM(0,"Sales",PIADMSalesDR)) q:PIADMSalesDR=""  d
	.
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0,"Sales",PIADMSalesDR,PIADMRowId)) q:PIADMRowId=""  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADMRowId)          //add 2009-07-07 
  	..q:LocFlag=1
	..// DHC_PE_StationSummarize.{ SS_UpdateDate }
	..s SSUpdateDate=$P($G(^DHCPESS(SSRowId,1)),"^",3)
	..Q:(""'=DateBegin)&(+DateBegin>SSUpdateDate)
	..Q:(""'=DateEnd)&(+DateEnd<SSUpdateDate)
	..
	..// DHC_PE_StationSummarize.{ SS_UpdateUser_DR }
	..s SSUpdateUserDR=$P($G(^DHCPESS(SSRowId,1)),"^",4)
	..Q:(""'=DocDR)&(DocDR'=SSUpdateUserDR)
	..Q:(""=SSUpdateUserDR)
	..
	..// DHC_PE_StationSummarize.{ SS_ST_DR }
	..s STRowId=$P($G(^DHCPESS(SSRowId,1)),"^",2)
	..Q:(""'=STDR)&(STDR'=STRowId)
	..
	..s ^DWATMP("Doctor", SSUpdateUserDR,STRowId)=+$G(^DWATMP("Doctor",SSUpdateUserDR,STRowId))+1
	..s ^DWATMP("Doctor", SSUpdateUserDR)=+$G(^DWATMP("Doctor",SSUpdateUserDR))+1
	..s ^DWATMP("Station",STRowId, SSUpdateUserDR)=+$G(^DWATMP("Station",STRowId, SSUpdateUserDR))+1
	..s ^DWATMP("Tatal")=+$G(^DWATMP("Tatal"))+1
	
	s SSRowId=0
	f  s SSRowId=$O(^DWATMP("Doctor", SSRowId)) q:SSRowId=""  d
	.s STDR=0
	.// SS_User.{ SSUSR_Initials }
	.s DocCode=$P($G(^SSU("SSUSR",SSRowId)),"^",1)
	.// SS_User.{ SSUSR_Name }
	.s DocName=$P($G(^SSU("SSUSR",SSRowId)),"^",2)
	.// 检验
	.s:(""=DocName) DocName=$p($g(^[namespaceLab]SSU("SSUSR",1,SSRowId)),"^",2)
	.s:(""=DocName) DocName="("_SSRowId_")"
	.
	.//Q:(""=DocName) //过滤掉用户名为空得
	.f  s STDR=$O(^DWATMP("Doctor", SSRowId, STDR)) q:STDR=""  d
	..s STDesc=$P($G(^DHCPEST(STDR)),"^",2)
	..s Amount=+$G(^DWATMP("Doctor", SSRowId, STDR))
	..s Data=$LB(STDR, STDesc, SSRowId,DocCode,DocName,Amount)
    ..d SalesStatisticOut
    ..//s SSRowId=""
    ..s DocName=""
    .
    .//s STDR=""
    .s STDesc="合计:"
    .s DocName=""
    .s Amount=+$G(^DWATMP("Doctor", SSRowId))
    .s Data=$LB(STDR, STDesc, SSRowId,DocCode,DocName,Amount)
    .//d SalesStatisticOut
	
    s STDR=""
    s STDesc=""
    s SSRowId=""
    s DocCode=""
    s DocName="总计:"
    s Amount=+$G(^DWATMP("Tatal"))
    s Data=$LB(STDR, STDesc, SSRowId,DocCode,DocName,Amount)
    //d SalesStatisticOut
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SalesStatisticOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SalesStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SalesStatisticExecute ]
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

ClassMethod SalesStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SalesStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query SearchUSER(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "SSUSR_Initials:%String,SSUSR_Name:%String, SSUSR_RowId:%String")
{
	select SSUSR_Initials, SSUSR_Name, SSUSR_RowId
	from SS_USER
	where SSUSR_Name %STARTSWITH :Desc
}

}
