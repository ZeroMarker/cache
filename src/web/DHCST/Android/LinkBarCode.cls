Import sqluser

Class web.DHCST.Android.LinkBarCode Extends %RegisteredObject
{

/// creator:yunhaibao
/// createdate:20160224
/// description:安徽省立pda关联大包装以及中包装条码用
/// input:大包装条码,小包装条码,数量,单位^(以^分隔单条记录),科室
/// output:上期金额^本期金额^出库金额
/// w ##class(web.DHCST.Android.LinkBarCode).LinkBarCode("987414997","yunhaibao11,50,^yunhaibao21,60,","113")
ClassMethod LinkBarCode(packlabel, linklabelstr, locrowid)
{
	q:packlabel="" -1 //条码没空
	q:locrowid="" -2 //科室为空
	q:'$d(^DHCINBP(0,"BarCode",packlabel)) -3  //条码不存在 	
	s inbprowid=$o(^DHCINBP(0,"BarCode",packlabel,""))
	s inbpincibdr=$p(^DHCINBP(inbprowid),"^",1)
	s error=0
	ts
	s linklen=$l(linklabelstr,"^")
	s i=""
	f i=1:1:linklen d
	.s linklabelinfo=$p(linklabelstr,"^",i)
	.s linklabel=$p(linklabelinfo,",",1)
	.i linklabel="" s error=-4 //关联条码为空 
	.s linkqty=+$p(linklabelinfo,",",2)
	.s linkuomdr=$p(linklabelinfo,",",3) //id还是描述,默认入库单位?
	.i linkuomdr="" s linkuomdr=$p(^INCI(+inbpincibdr,3),"^",6)
	.i $d(^DHCINBP(0,"ParBar",linklabel)) s error=-5 //存在父条码中
	.i $d(^DHCINBP(0,"BarCode",linklabel)) s error=-6 //存在子条码中
	.s parqty=$p(^DHCINBP(inbprowid),"^",4)
	.s newparqty=parqty-linkqty //拆分后数量
	.i newparqty<0 s error=-7 //包装数量不足
	.q:error'=0
	.&SQL(INSERT INTO DHC_IncBatPack (INBP_INCIB_Dr,INBP_BarCode,INBP_Uom_dr,INBP_Qty,INBP_ParBarCode,INBP_Loc_Dr,INBP_PrintFlag)values
	(:inbpincibdr,:linklabel,:linkuomdr,:linkqty,:packlabel,:locrowid,1))
	.i SQLCODE'=0 tro  s error=SQLCODE 
	.s $p(^DHCINBP(inbprowid),"^",4)=$p(^DHCINBP(inbprowid),"^",4)-linkqty
	i error'=0 tro
	q:error'=0 error
	tc
	q error
}

/// 删除关联条码
/// w ##class(web.DHCST.Android.LinkBarCode).DeleteLinkLabel("yunhaibao2^yunhaibao4")
ClassMethod DeleteLinkLabel(linklabelstr)
{
	s error=0
	q:linklabelstr="" -1
	ts
	s linklen=$l(linklabelstr,"^")
	s i=""
	f i=1:1:linklen d
	.s linklabel=$p(linklabelstr,"^",i)
	.i linklabel="" s error=-2 //关联条码为空 
	.q:linklabel=""
	.i '$d(^DHCINBP(0,"BarCode",linklabel)) s error=-3
	.q:error'=0
	.s linkbprowid=$o(^DHCINBP(0,"BarCode",linklabel,""),-1)
	.s parlabel=$p(^DHCINBP(linkbprowid),"^",5) //父条码
	.s linkqty=$p(^DHCINBP(linkbprowid),"^",4)
	.s inbprowid=$o(^DHCINBP(0,"BarCode",parlabel,""),-1)
	.&SQL(DELETE FROM DHC_IncBatPack WHERE INBP_ROWID=:linkbprowid)
	.i SQLCODE'=0 s error=SQLCODE
	.q:error'=0
	.s $p(^DHCINBP(inbprowid),"^",4)=$p(^DHCINBP(inbprowid),"^",4)+linkqty
	i error'=0 tro 
	q:error'=0 error
	tc
	q error
}

}
