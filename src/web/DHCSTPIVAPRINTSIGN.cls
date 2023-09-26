Import SQLUser

/// 特殊类别药学分类的打印标签标识维护，table( PIVA_PrintSign)
Class web.DHCSTPIVAPRINTSIGN Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPrintSignFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintSignExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod GetPrintSignClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintSignExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetPrintSignExecute(ByRef qHandle As %Binary) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	s ppsdr="",phcscdr="",sccode="",scdesc="",sign="",phdesc=""
	S ppsdr="0"
 	F  S ppsdr=$O(^PIVAPS(ppsdr)) Q:ppsdr=""  D
 	.s (sccode,scdesc,phdesc,inci)=""	//zhouyg 20151109 添加初始化
 	.S phcscdr=$P(^PIVAPS(ppsdr),"^",1)
 	.S sign=$P(^PIVAPS(ppsdr),"^",2)
 	.i phcscdr'="" d
 	..S phcc=$p(phcscdr,"||",1) Q:phcc=""
 	..S sub=$p(phcscdr,"||",2) Q:sub=""
 	..Q:'$d(^PHCC(phcc,"SC",sub))
 	..S sccode=$p(^PHCC(phcc,"SC",sub),"^",1)
 	..S scdesc=$p(^PHCC(phcc,"SC",sub),"^",2)
 	.S phcdfdr=$p(^PIVAPS(ppsdr),"^",3)
 	.s inci=""
 	.q:+phcdfdr=0
 	.q:'$d(^PHCD(+phcdfdr,1))
 	.i phcdfdr'="" d
 	..s phdesc=$p(^PHCD(+phcdfdr,1),"^",2)
 	..s phcode=$p(^PHCD(+phcdfdr,1),"^",1)
 	..s inci=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(phcode),""))
 	.e  d
 	..s phdesc=""
	.D OutputRow
 	Q $$$OK
OutputRow
	S Data=$lb(ppsdr,phcscdr,sccode,scdesc,sign,phdesc,inci)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

Query GetPrintSign() As %Query(ROWSPEC = "TPPSDr:%String,TPhcscDr:%String,TPhcscCode:%String,TPhcscDesc:%String,TPrintSign:%String,Tphdesc:%String,Tphcdfdr:%String")
{
}

/// 保存打印标识
ClassMethod InsSign(phcscdr As %String, sign As %String, inci) As %String
{
	N (phcscdr,sign,inci)
	s ppsdr="",tmpphc=""
	i phcscdr'="" d
	.S ppsdr=$o(^PIVAPS(0,"PHCSC",phcscdr,""))
	Q:(ppsdr'="")&(phcscdr'="") -99997
	//
	i inci'="" d
	.s arc=$p(^INCI(inci,1),"^",3)
	.s phcdfdr=$p(^ARCIM(+arc,$p(arc,"||",2),1),"^",12)
	.S tmpphc=$o(^PIVAPS(0,"PHCDF",phcdfdr,""))
	Q:(tmpphc'="")&(inci'="") -99998
	&sql(Insert into PIVA_PrintSign(PPS_PHCSC_Dr,PPS_Sign,PPS_PHCDF_Dr) Values(:phcscdr,:sign,:phcdfdr)) 
	Q:SQLCODE<0 SQLCODE
	Q:SQLCODE=100 -99999
	S ppsdr=$p(%ROWID,$c(1))
	Q ppsdr
}

ClassMethod UpdSign(ppsdr As %String, sign As %String, inci) As %String
{
	N (ppsdr,sign,inci)
	s phcdfdr=""
	i inci'="" d
	.s arc=$p(^INCI(inci,1),"^",3)
	.s phcdfdr=$p(^ARCIM(+arc,$p(arc,"||",2),1),"^",12)
	&sql(Update PIVA_PrintSign Set PPS_Sign=:sign,PPS_PHCDF_Dr=:phcdfdr Where PPS_Rowid=:ppsdr)
	Q SQLCODE
}

ClassMethod DelSign(ppsdr As %String) As %String
{
	N (ppsdr)
	&sql(Delete From PIVA_PrintSign Where PPS_Rowid=:ppsdr) 
	Q SQLCODE
}

/// 是否已经存在phcscdr 1-是；0-否
ClassMethod ExistPps(phcscdr As %String) As %String
{
	N (phcscdr)
	Q:phcscdr="" -99998
	S ppsdr=$o(^PIVAPS(0,"PHCSC",phcscdr,""))
	Q:ppsdr'="" 1
	Q 0
}

/// w ##class(web.DHCSTPIVAPRINTSIGN).GetSignInfo("12")
ClassMethod GetSignInfo(ppsdr As %String)
{
	q:ppsdr="" ""
	&sql(select PPS_Sign,PPS_PHCDF_DR into :sign,:phcdfdr from PIVA_PrintSign Where PPS_Rowid=:ppsdr)
	q:SQLCODE>0 ""
	s phcdesc="",inci=""
	i (phcdfdr'="")&&($d(^PHCD(+phcdfdr))) d
	.s phcdesc=$p($g(^PHCD(+phcdfdr,1)),"^",2)
	.s phccode=$p($g(^PHCD(+phcdfdr,1)),"^",1)
	.s inci=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(phccode),""))
	s signinfo=sign_"^"_phcdesc_"^"_inci
	q signinfo
}

}
