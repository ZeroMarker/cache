Import SQLUser

/// Description:报表类产品线的公共类以及公共query
/// Creator:    hulihua
/// CreateDate: 2018-07-23
/// Table:
Class web.DHCST.ReportForms.ReportCommon Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// Description：获取类组数据集用于报表放大镜
/// Creator：    hulihua
/// CreatDate：  2018-07-06
/// Table：      DHC_StkCatGroup-类组表
/// Input：      inputs-输入值, scgtype-类型(G-药品、M-材料、O-其它)
/// Output：	 类组描述、类组ID、类组代码    
/// Return：       
/// Others：
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","INCSCStkGrp","","W")
Query INCSCStkGrp(inputs As %String, scgtype As %String, HOSPID As %String = "") As websys.Query(ROWSPEC = "类组描述:%String,类组Id:%String,类组代码:%String") [ SqlProc ]
{
}

ClassMethod INCSCStkGrpExecute(ByRef qHandle As %Binary, inputs As %String, scgtype As %String, HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	if inputs'="全部" {
 	&sql(declare xxx1 cursor for SELECT SCG_Desc,SCG_Rowid,SCG_Code into :Description,:RowId,:Code FROM DHC_StkCatGroup
	 where SCG_Type =:scgtype and (%ALPHAUP(SCG_Desc) %STARTSWITH %ALPHAUP(:inputs)) order by SCG_Rowid
	 )
	&sql(open xxx1)
	f  &sql(fetch xxx1 into :Description,:RowId,:Code)  q:SQLCODE  d
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkCatGroup",RowId,HOSPID) //医院级别授权
	.q:flag="N"
	. d OutputStkGrp
	&sql(close xxx1)
	}
 	s Description="全部"
 	s RowId="全部"
 	s Code="QB"
 	d OutputStkGrp
       
 	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputStkGrp
	s Data=$lb(Description,RowId,Code)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Description：获取科室数据集用于报表放大镜
/// Creator：    hulihua
/// CreatDate：  2018-07-06
/// Table：      CT_Loc-类组表
/// Input：      loctype-科室类型(D-药房), inputs-界面输入值
/// Output：	 科室描述、科室ID    
/// Return：       
/// Others：
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","TypeLoc","E","")
Query TypeLoc(loctype As %String, inputs As %String, HOSPID As %String = "") As websys.Query(ROWSPEC = "药房名称:%String,药房ID:%String") [ SqlProc ]
{
}

ClassMethod TypeLocExecute(ByRef qHandle As %Binary, loctype As %String, inputs As %String, HOSPID As %String = "") As %Status
{
	Set repid = $I(^CacheTemp)
	Set qHandle = $lb(0, repid, 0)
	Set ind = 1
 	if (inputs '= "全部") {
 		&SQL(
	 		DECLARE
			xxx CURSOR FOR
			SELECT ctloc_desc, ctloc_rowid
			INTO :desc, :rowid
			FROM ct_loc
			WHERE (%ALPHAUP(ctloc_type) %STARTSWITH %ALPHAUP (:loctype))
			  AND (%ALPHAUP(ctloc_desc) %STARTSWITH %ALPHAUP(:inputs))
		 )
		 
		&SQL(open xxx)
		for {
			&SQL(fetch xxx into :desc, :rowid) q:SQLCODE
			s locData = $g(^CTLOC(rowid))
			continue:(HOSPID '= "")&&(HOSPID '= $p(locData, "^", 22))
		    s activeDateFrom = $p(locData,"^",24)
		    continue:(activeDateFrom'="")&(activeDateFrom>+$h) 
		    s activeDateTo = $p(locData,"^",25)
		    continue:(activeDateTo'="")&(activeDateTo<+$h)
		    if ($p(locData, "^", 5) = "Y"){
			    s ward = $o(^PAWARD(0,"WARD_LocationDR",rowid,0))
				continue:($p($g(^PAWARD(+ward)), "^", 6) '= "Y")   
		 	}
			d OutputDispStatItmtmp
		}
		&SQL(close xxx)
	}
 	//s desc="全部科室"
 	//s rowid="全部"
 	//d OutputDispStatItmtmp
       
 	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputDispStatItmtmp
	s Data=$lb(desc, rowid)
	s ^CacheTemp(repid, ind) = Data	
	s ind=ind+1
	q
}

/// Description：获取类组数据集用于报表下拉树
/// d ##Class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","GetStkGrp")
Query GetStkGrp(HOSPID = "") As websys.Query(ROWSPEC = "RowID:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod GetStkGrpExecute(ByRef qHandle As %Binary, HOSPID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set rowid=0
	f  s rowid=$o(^DHCSCG(rowid)) q:+rowid=0  d
	.s scgtype=$p(^DHCSCG(rowid),"^",3)
	.q:scgtype'="G"
	.s stkgrp=$p(^DHCSCG(rowid),"^",2)
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkCatGroup",rowid,HOSPID) //医院级别授权
	.q:flag="N"
	.d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	Set Data=$lb(rowid,stkgrp)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// 科室入参查询
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","SerchLoc","")
Query SerchLoc(input As %String, HOSPID As %String = "") As websys.Query(ROWSPEC = "yflocdr:%String,LOCDesc:%String") [ SqlProc ]
{
}

ClassMethod SerchLocExecute(ByRef qHandle As %Binary, input As %String, HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	s yflocdr=""
	f  s yflocdr=$o(^CTLOC(0,"LocType","D",yflocdr))  q:yflocdr=""  d
	.s dhclocdr=$o(^DHCLOC(0,"LOC",yflocdr,""))
 	.s loctype=$s(dhclocdr'="":$p(^DHCLOC(dhclocdr),"^",5),1:"") //库房类别（"R"-"药库";"I"-"住院药房";"O"-"门诊药房";"A"-"器械材料";"G"-"总务药房";"E"-"其他";）
 	.q:loctype'="O"
 	.s locData = ^CTLOC(yflocdr)
 	.s hospDr=$p(locData,"^",22)
 	.q:(HOSPID'="")&&(hospDr'="")&&(hospDr'=HOSPID)
	.s LOCDesc=$p(locData,"^",2)
	.s dateTo = $p(locData,"^",25)
	.q:(dateTo '= "")&&(dateTo <= (+$h))
	.d outputrow
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
outputrow
	s data=$lb(yflocdr,LOCDesc)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// 多级药学分类
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","GetDHCPHCCat")
Query GetDHCPHCCat() As websys.Query(ROWSPEC = "InputData:%String,CatDesc:%String") [ SqlProc ]
{
}

ClassMethod GetDHCPHCCatExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	s outcatid=0
	f  s outcatid=$o(^DHCPHCC(outcatid))  q:outcatid=""  d
	.s catdesc=$p(^DHCPHCC(outcatid),"^",2)
	.s parcatdr=$p(^DHCPHCC(outcatid),"^",3)
	.s plevel=$p(^DHCPHCC(outcatid),"^",4)
	.s inputdata=outcatid_","_parcatdr_","_plevel
	.d outputrow
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
outputrow
	s data=$lb(inputdata,catdesc)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// 剂型
/// d ##Class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","GetJXType")
Query GetJXType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT phcf_rowid,phcf_desc FROM PHC_Form
}

/*Query GetDept() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT ctloc_rowid,ctloc_desc FROM ct_loc
}*/
/// 医生科室
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","GetDept","","E",2)
Query GetDept(input = "", ctloctype = "", HOSPID = "") As websys.Query(ROWSPEC = "CTLOC_RowID:%String,CTLOC_Desc:%String") [ SqlProc ]
{
}

ClassMethod GetDeptExecute(ByRef qHandle As %Binary, input = "", ctloctype = "", HOSPID = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s QText=$zcvt(input,"U")
	s ind=1
	s locId=0
	f  s locId=$o(^CTLOC(locId)) q:locId=""  d
	.s locData=$g(^CTLOC(locId))
	.q:locData=""
	.s locDesc=$p(locData,"^",2)
	.s conName=$zcvt($p(locData,"^",43),"U")
	.q:(QText'="")&&($zcvt(locDesc,"U")'[QText)&&(conName'[QText)
	.s tmptype=$p(locData,"^",13)
	.q:(ctloctype'="")&&(ctloctype'=tmptype)
	.s tmphos=$p(locData,"^",22)
	.q:(HOSPID'="")&&(tmphos'="")&&(HOSPID'=tmphos)
	.s dateTo = $p(locData,"^",25)
	.q:(dateTo '= "")&&(dateTo <= (+$h))
	.s Data=$lb(locId,$p($g(^CTLOC(locId)),"^",2))
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	q $$$OK
}

/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// ///////////////////上面为Query方法,下面为过程函数,请按此规则////////////////////////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// 取台帐业务中病人就诊类型
ClassMethod GetTransAdmType(intr) As %String
{
    s pointer=$p(^DHCINTR(intr),"^",9)
    s inclb=$p(^DHCINTR(intr),"^",7)
    s type=$p(^DHCINTR(intr),"^",1)
    s oeori=..GetOeoriByTans(pointer,type)
	q:oeori="" ""
	s ord=$p(oeori,"||",1)
	S chl=$p(oeori,"||",2)
	s ordept=$p(^OEORD(ord,"I",chl,7),"^",2)
    s adm=$p(^OEORD(ord),"^",1) 
    s admtype=$P(^PAADM(adm),"^",2)  		
	q $g(admtype)_"^"_$g(ordept)_"^"_$g(adm)
}

/// 获取业务金额
ClassMethod GetAmt(type, pointer, dhcintr)
{
		 s oldspamt=0 
		 q:pointer="" "^^" 
		 i type="G" {
		    s INGR=+pointer
		    s CH=$p(pointer,"||",2)
		    s sp=$p(^DHCINGR(INGR,"GRI",CH),"^",32)
		    s qty=$p(^DHCINGR(INGR,"GRI",CH),"^",4)
		    s spAmt=sp*qty
		    s rpAmt=$p(^DHCINGR(INGR,"GRI",CH),"^",31)
		 }
		 elseif type="R" {
		 s INGRT=+pointer
		    s CH=$p(pointer,"||",2)
		    s rpAmt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",4)
		    s spAmt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",9)
		    s oldspamt=(-1)*$p(^INGRT(INGRT,"DHCGRR",CH),"^",16)    
		 }
		 elseif type="T" {
		    s INIT=+pointer
		    s CH=$p(pointer,"||",2)
		    s rpAmt=(-1)*$p(^DHCINIT(INIT,"ITI",CH),"^",16)
		    s spAmt=(-1)*$p(^DHCINIT(INIT,"ITI",CH),"^",18)
		 }
		 elseif type="K" {
		    s INIT=+pointer
		    s CH=$p(pointer,"||",2)
		    s rpAmt=$p(^DHCINIT(INIT,"ITI",CH),"^",16)
		    s spAmt=$p(^DHCINIT(INIT,"ITI",CH),"^",18)
		 }
		 elseif type="P" {
		    s rpAmt=..GetRpAmt(dhcintr)
            s spAmt=$p(^DHCINTR(dhcintr),"^",8)      
		 }
		 elseif type="Y" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)      
		 }
		 elseif type="F" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)      
		 } 
		 elseif type="H" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)      
		 }
		 elseif type="S" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)      
		 }
		 elseif type="Z" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="A" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="D" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="C" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="M" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 elseif type="X" {
		    s rpAmt=..GetRpAmt(dhcintr)
		    s spAmt=$p(^DHCINTR(dhcintr),"^",8)
		 }
		 else {
		 
		 }

		 q $g(rpAmt)_"^"_$g(spAmt)_"^"_$g(oldspamt)
}

/// 取进价金额
ClassMethod GetRpAmt(dhcintr)
{
	 q:dhcintr="" 0
	 q $p($g(^DHCINTR(dhcintr)),"^",17)
	 s qty=$p(^DHCINTR(dhcintr),"^",6)
	 s inclb=$p(^DHCINTR(dhcintr),"^",7)
	 s uom=$p(^DHCINTR(dhcintr),"^",10)
	 s date=$p(^DHCINTR(dhcintr),"^",2)
	 s inci=+inclb
	 s baseUom=$p(^INCI(inci,1),"^",10)
	 ///格式化
	 S locID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	 s custStr=##class(web.DHCSTCOMMO).GetLocCust(locID)
	 s custID=$p(custStr,"^",1)
	 s hospID=$p(custStr,"^",5)
	 S catGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
	 S stkTypeDesc=$P(catGrpStr,"^",4)
	 S perv="^^^"_stkTypeDesc_"^"_$G(custID)_"^DHC"
	 //zhouyg 20141203 
     s rp=##Class(web.DHCSTPRICE).GetRp(inclb,date,uom,hospID,"")
     i uom=baseUom d
     .s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,perv,"FmtRP",2)
	 e  d
	 .s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,perv,"FmtRP",1)
	 s rpAmt=rp*qty	 
	 S rpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,hospID)
	 q rpAmt
}

/// 计算中草药处方剂数
/// w ##class(web.DHCST.ReportForms.ReportCommon).GetZCYFactor("I171220000473")
ClassMethod GetZCYFactor(prescno)
{
    ;只能计算草药处方
    q:'$d(^PAQUE1(0,"PrescNo",prescno)) 0
    s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
    q:+queid=0 0
    q:'$d(^PAQUE1(queid,"DHC")) 0
    s prescType=$p(^PAQUE1(queid,"DHC"),"^",2)
	q:prescType'=3 0
    s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
    s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
    q facotor
}

/// Description:通过台账表poniter获取对应业务的医嘱ID
/// Creator:	hulihua
/// CreateDate:	2018-06-13
/// Updator
/// Table:		DHC_INTRANS   
/// Input:		Pointer-业务指针,TransType-业务类型		
/// Output:		
/// Return：	医嘱ID 
/// Debug:		w ##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans()
ClassMethod GetOeoriByTans(Pointer As %String, TransType As %String) As %String
{
	q:Pointer="" ""
	s oeori=""
	s:TransType="P" oeori=##class(web.DHCST.LocItmTransMove).GetPHPORI(Pointer)
	s:TransType="Y" oeori=##class(web.DHCST.LocItmTransMove).GetPHYORI(Pointer)
	s:TransType="F" oeori=##class(web.DHCST.LocItmTransMove).GetORI(Pointer)
	s:(TransType="H")||(TransType="HC") oeori=##class(web.DHCST.LocItmTransMove).GetRetORI(Pointer)
	s:(TransType="PH")||(TransType="FH") oeori=##class(web.DHCST.LocItmTransMove).GetCYDispOrdItm(Pointer)
	s:(TransType="YH")||(TransType="HH")||(TransType="HHC") oeori=##class(web.DHCST.LocItmTransMove).GetCYRetOrdItm(Pointer)
	q oeori
}

/// 取台帐业务中的医生科室
ClassMethod GetTransDocLoc(intr) As %String
{
	s orditm=..GetTransOrdItem(intr)
	q:orditm="" "不详"
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s doclocdr=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
    q doclocdr
}

/// 获取台帐中的医嘱ID
ClassMethod GetTransOrdItem(intr) As %String
{
	s orditm=""
	s type=$p(^DHCINTR(intr),"^",1)
	s pointer=$p(^DHCINTR(intr),"^",9) 
	i type="P" d
	.q:'$d(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",7)
	i type="Y" d
	.q:'$d(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",1)
	i type="F" d
	.q:'$d(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)),"^",5)
	i type="H" d
	.q:'$d(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)),"^",2)
	q orditm
}

/// 取台帐业务中的病区科室
ClassMethod GetTransWardDr(intr) As %String
{
	//7.0
	s wardlocdr=""
    s pointer=$p(^DHCINTR(intr),"^",9)
    s inclb=$p(^DHCINTR(intr),"^",7)
    s type=$p(^DHCINTR(intr),"^",1)
    i type="P" d
    .q:'$d(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",7)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S phalocdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    .s doclocdr=$p($g(^OEORD(ord,"I",itm,7)),"^",2)   
    .i ##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phalocdr,doclocdr)=1 S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
    .e  d
    ..s warddr=$p(^DHCPHAC(+pointer),"^",4)
    ..q:warddr=""
    ..s wardlocdr=$p(^PAWARD(warddr),"^",5) 
	i type="Y" d
	.q:'$d(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",1)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S dodis=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",13)
	.S phalocdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
    .s doclocdr=$p($g(^OEORD(ord,"I",itm,7)),"^",2)   
    .i ##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phalocdr,doclocdr)=1 S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)
    .e  d
    ..s wardlocdr=$p(^DHCOEDISQTY(dodis),"^",22)	
	i type="F" d
	.q:'$d(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)),"^",5)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)	
	i type="H" d
	.q:'$d(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)),"^",2)
	.s ord=$p(orditm,"||",1)
    .S itm=$p(orditm,"||",2)
	.S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)	
	q wardlocdr
}

/// Description: 转换入参,当为IRIS数据库时,润乾首次查询入参可能为$c(0)
/// ##class(web.DHCST.ReportForms.ReportCommon).FmtInput()
ClassMethod FmtInput(FVal)
{
	q:FVal=$c(0) ""
	q FVal
}

/// 获取库存属性
ClassMethod GetPulanType(inci)
{
	//n (inci)
	q:inci="" ""
	s infoId=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:infoId="" ""
	s purPlanType=$p(^DHCITMINFO(infoId),"^",84)
	i purPlanType="TG" s purPlanType="托管"
	i purPlanType="FTG" s purPlanType="非托管"
	i purPlanType="DM" s purPlanType="代买"
	
	q $g(purPlanType)
}

/// Creator：     王武龙
/// CreatDate：   2017-5-16
/// Description:：取开单科室
/// Table：       
/// Input：       业务类型,指针    
ClassMethod GetDept(trType, pointDr)
{
	
    s deptDesc=""
    
	q:pointDr="" "^^^" 
	i trType="F" {
		 s oeoRi=$p($g(^DHCPHDI(+pointDr,"PHDI",$P(pointDr,"||",2))),"^",5) 
		 if oeoRi'="" {
		 	s dept=$p(^OEORD(+oeoRi,"I",$p(oeoRi,"||",2),1),"^",3) 
		 	s deptDesc=$p(^CTLOC(dept),"^",2)
		 } 

		 
	}

	elseif trType="P"{
		 s oeoRi=$p($g(^DHCPHAC($p(pointDr,"||",1),"I",$p(pointDr,"||",2))),"^",7)
		 if oeoRi'="" {
		 	s dept=$p(^OEORD(+oeoRi,"I",$p(oeoRi,"||",2),1),"^",3) 
		 	s deptDesc=$p(^CTLOC(dept),"^",2) 
		 }	 
	}
	elseif trType="Y"{
		 s oeoRi=$p($g(^PHARET(+pointDr,"I",$p(pointDr,"||",2))),"^",1)
		 if oeoRi'="" {
		 	s dept=$p(^OEORD(+oeoRi,"I",$p(oeoRi,"||",2),1),"^",3) 
		 	s deptDesc=$p(^CTLOC(dept),"^",2) 
		 }	 
	}
		elseif trType="H"{
		 s oeoRi=$p($g(^DHCPHRTI(+pointDr,"RTI",$p(pointDr,"||",2))),"^",2)
		 if oeoRi'="" {
		 	s dept=$p(^OEORD(+oeoRi,"I",$p(oeoRi,"||",2),1),"^",3) 
		 	s deptDesc=$p(^CTLOC(dept),"^",2) 
		 }	 
	}

	
	
	
    i $f(deptDesc,"-") s deptDesc=$p(deptDesc,"-",2)
	q deptDesc
}

/// 取住院药房集合
ClassMethod GetPhaLocStr(HOSPID = "") As %String
{
  
    s ret=""
    s ctlocdr=""
	f  s ctlocdr=$o(^DHCPL(0,"Loc",ctlocdr)) q:ctlocdr=""  d
	.q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(ctlocdr),"^",22)) //按院区过滤
	.i ret="" d
	..s ret=ctlocdr
	.e  d
	..s ret=ret_"^"_ctlocdr
	q ret
}

/// 取门诊药房集合
/// W ##class(web.DHCST.ReportForms.ReportCommon).GetOutLocStr(2)
ClassMethod GetOutLocStr(HOSPID = "") As %String
{
  
    s ret=""
    s phloc=""
	f  s phloc=$o(^DHCPHLOC(phloc)) q:phloc=""  d
	.s tmploc=$P(^DHCPHLOC(phloc),"^",1)
	.q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	.i ret="" d
	..s ret=$p(^DHCPHLOC(phloc),"^",1)
	.e  d
	..s ret=ret_"^"_$p(^DHCPHLOC(phloc),"^",1)
	q ret
}

/// //================报表整理====yangsj====2019-10-31======Start==================/////////
/// 科室入参查询(带医院) 2019-11-07 yangsj
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","SerchDispLoc","","")
Query SerchDispLoc(input As %String = "", HOSP As %String = "") As websys.Query(ROWSPEC = "ctloc:%String,ctlocdesc:%String") [ SqlProc ]
{
}

ClassMethod SerchDispLocExecute(ByRef qHandle As %Binary, input As %String = "", HOSP As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	s yflocdr=""
	f  s yflocdr=$o(^CTLOC(0,"LocType","D",yflocdr))  q:yflocdr=""  d
	.s dhclocdr=$o(^DHCLOC(0,"LOC",yflocdr,""))
	.s hopsid=$P(^CTLOC(yflocdr),"^",22)
	.q:(HOSP'="")&&(HOSP'=hopsid)
 	.s loctype=$s(dhclocdr'="":$p(^DHCLOC(dhclocdr),"^",5),1:"") //库房类别（"R"-"药库";"I"-"住院药房";"O"-"门诊药房";"A"-"器械材料";"G"-"总务药房";"E"-"其他";）
 	.//q:loctype'="I"
	.s LOCDesc=$p(^CTLOC(yflocdr),"^",2)
	.q:(input'="")&&(input'=LOCDesc)
	.d outputrow
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
outputrow
	s data=$lb(yflocdr,LOCDesc)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// //================报表整理====yangsj====2019-10-31======End==================/////////
/// Decription:住院退药原因
/// Creator:yangsj
/// CreateDate:2020-06-09
/// Input:
/// Output:
/// Table:
/// Debugger:
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.ReportCommon","SerchPhaRetReason","")
Query SerchPhaRetReason(HOSPID As %String = "") As websys.Query(ROWSPEC = "RowId:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod SerchPhaRetReasonExecute(ByRef qHandle As %Binary, HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	
	s reasonId=""
	f  s reasonId=$O(^BLC("RFR",reasonId)) q:reasonId=""  d
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("BLC_ReasonForRefund",reasonId,HOSPID) //医院级别授权
    .q:(HOSPID'="")&&(flag="N")
    .s desc=$P(^BLC("RFR",reasonId),"^",2)
	.d outputrow
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
outputrow
	s data=$lb(reasonId,desc)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// Creator		zhaozhiduan
/// CreatDate	2021.09.07
/// Description	根据业务id和类型，获取处方号
/// Input		业务id、业务类型
/// Output		处方号
/// d ##class(web.DHCST.ReportForms.ReportCommon).GetPrescNo()
ClassMethod GetPrescNo(pointer, type)
{
	s prescNo=""
	i (type="F") {
		s prescNo=$p($g(^DHCPHDISP(+pointer,2)),"^",1)
	} elseif ((type="H")||(type="HC")){
		s phdItmId=$p($g(^DHCPHRTI(+pointer,"RTI",$p(pointer,"||",2))),"^",7)
		q:(phdItmId = "") ""
		s prescNo=$p($g(^DHCPHDISP(+phdItmId,2)),"^",1)
	} elseif (type="P"){
		s prescNo=$p($G(^DHCPHAC(+pointer,"I",$p(pointer,"||",2))),"^",5)
	} elseif (type="Y"){
		s ordItmId=$p($G(^PHARET(+pointer,"I",$p(pointer,"||",2))),"^",1)
		q:ordItmId="" ""
		s prescNo=$p(^OEORD(+ordItmId,"I",$p(ordItmId,"||",2),1),"^",14)
	} elseif ((type="FH")||(type="PH")){
		s prescNo=$lg(^BS.PHA.HERB.DISPEND(+pointer),4)
	} elseif ((type="HH")||(type="YH"))||(type="HHC") {
		s prescNo=$lg(^BS.PHA.HERB.RETURND(+pointer),6)
	}
	q prescNo
}

/// 判断台账业务类型是门诊还是住院
/// 如果急诊和门诊分开统计的话再用就诊类型
ClassMethod GetDispBizType(type)
{
	q:(type = "") ""
	q $case(type,
		"P": "I",
		"Y": "I",
		"PH": "I",
		"YH": "I",
		: "O"
	)
}

}
