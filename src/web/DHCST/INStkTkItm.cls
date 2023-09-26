Import sqluser

Class web.DHCST.INStkTkItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入或更新一条明细记录
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  insti - 盘点明细记录RowId
///  inst-  盘点主记录RowId
///  inclb - 库存批次RowId
///  sbDescStr-符合条件的货位串 add wyx 2013-11-21
/// Return:
///   0 -success
///    <0  -failure
ClassMethod Update(insti As %String, inst As %String, inclb As %String, sbDescStr As %String) As %String
{
 n (insti,inst,inclb,sbDescStr)
 s inci=+inclb
 s incil=$p(inclb,"||",1,2)
 s incib=$p(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
 s batNo=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)
 s expDate=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2)
 s code=$P($G(^INCI(inci,1)),"^",1)
 s desc=$P($G(^INCI(inci,1)),"^",2)
 s buom=$P($G(^INCI(inci,1)),"^",10)
 s uom=buom
 //s qty=$p(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",2)  //clbObj.INCLBPhyQty
 s qty=##CLASS(web.DHCSTSTKQTY).CurQtyINCLB(inclb)  //LiangQiang  小单位
 s loc=$$LOC^ST01(inclb)
 s hospid=$p(^CTLOC(loc),"^",22)
 s barcode=$P($G(^INCI(inci,3)),"^",9)
 
 ;
 s err=0
 i insti="" d
 .i inst="" s err=-100 q
 .s obj=##class(User.DHCInStkTkItm).%New(inst)
 .d obj.INSTIINSTParrefSetObjectId(inst)
 .
 e  d
 .s obj=##class(User.DHCInStkTkItm).%OpenId(insti)
 .d obj.%Reload()
 .
 q:err<0 err
 ;
 
 s pFreezeUom=$p(^DHCINST(inst),"^",17)
 //i pFreezeUom="1" s uom=$p(^INCI(inci,3),"^",6)  //入库单位
 
 s obj.INSTIFreezeDate=+$h
 s obj.INSTIFreezeTime=$p($h,",",2)
 s obj.INSTIFreezeQty=qty
 d obj.INSTICTUOMDRSetObjectId(uom)
 d obj.INSTIINCLBDRSetObjectId(inclb)
 d obj.INSTICTLOCDRSetObjectId(loc)
 s obj.INSTIBatchNo=batNo
 s obj.INSTIExpiryDate=expDate
 d obj.INSTIINCIDRSetObjectId(inci)
 s obj.INSTIStockCode=code
 s obj.INSTIStockDesc=desc
 s obj.INSTIStockBarCode=barcode
 //s sbDesc=""
 //&sql(select incil_incsb_dr->incsb_desc into :sbDesc from INC_ItmLoc where %id=:incil)
 //s obj.INSTIStkBinDesc=sbDesc
 //取用新的科室货位表存如符合条件的货位描述(可多货位)
 s obj.INSTIStkBinDesc=sbDescStr
 
 //zdm,2013-02-04,写入价格及金额信息
 //s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,+$h,uom,hospid)
 //s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,hospid)
 s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,hospid,"G","")
 s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,hospid,"G",+$h,"")
 //s freezespamt=qty*sp
 //s freezerpamt=qty*rp
 //s freezespamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(freezespamt,hospid)
 //s freezerpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(freezerpamt,hospid)
 s freezerpamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, qty, uom, hospid)
 s freezespamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, qty, uom, hospid)
 
 s obj.INSTIFreezeRpAmt=freezerpamt
 s obj.INSTIFreezeSpAmt=freezespamt
 s obj.INSTIRp=rp
 s obj.INSTISp=sp
 s sc=obj.%Save()
 ;b ;1
 i $$$ISERR(sc) w $System.Status.DisplayError(sc)
 i $$$ISERR(sc) q -1
 q 0
}

/// 插入或更新一条明细记录
/// Author:zhwh  modify by wyx ("录入批次"调用返回帐盘子表rowid)
/// Date:2012-08-01
/// Argu:
///  insti - 盘点明细记录RowId
///  inst-  盘点主记录RowId
///  inclb - 库存批次RowId
///  sbDescStr-符合条件的货位串 add wyx 2013-11-21
/// Return: 帐盘子表rowid
ClassMethod UpdateInput(insti As %String, inst As %String, inclb As %String, sbDescStr As %String) As %String
{
 n (insti,inst,inclb,sbDescStr)
 s inci=+inclb
 s incil=$p(inclb,"||",1,2)
 s incib=$p(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
 s batNo=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)
 s expDate=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2)
 s code=$P($G(^INCI(inci,1)),"^",1)
 s desc=$P($G(^INCI(inci,1)),"^",2)
 s buom=$P($G(^INCI(inci,1)),"^",10)
 s uom=buom
 //s qty=$p(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",2)  //clbObj.INCLBPhyQty
 s qty=##CLASS(web.DHCSTSTKQTY).CurQtyINCLB(inclb)  //LiangQiang  小单位
 
 s loc=$$LOC^ST01(inclb)
 s hospid=$p(^CTLOC(loc),"^",22)
 s barcode=$P($G(^INCI(inci,3)),"^",9)
 s err=0
 i insti="" d
 .i inst="" s err=-100 q
 .s obj=##class(User.DHCInStkTkItm).%New(inst)
 .d obj.INSTIINSTParrefSetObjectId(inst)
 .
 e  d
 .s obj=##class(User.DHCInStkTkItm).%OpenId(insti)
 .d obj.%Reload()
 .
 q:err<0 err
 ;
 
 s pFreezeUom=$p(^DHCINST(inst),"^",17)
 //i pFreezeUom="1" s uom=$p(^INCI(inci,3),"^",6)  //入库单位   LiangQiang 默认小单位
 
 s obj.INSTIFreezeDate=+$h
 s obj.INSTIFreezeTime=$p($h,",",2)
 s obj.INSTIFreezeQty=qty
 d obj.INSTICTUOMDRSetObjectId(uom)
 d obj.INSTIINCLBDRSetObjectId(inclb)
 d obj.INSTICTLOCDRSetObjectId(loc)
 s obj.INSTIBatchNo=batNo
 s obj.INSTIExpiryDate=expDate
 d obj.INSTIINCIDRSetObjectId(inci)
 s obj.INSTIStockCode=code
 s obj.INSTIStockDesc=desc
 s obj.INSTIStockBarCode=barcode
 //s sbDesc=""
 //&sql(select incil_incsb_dr->incsb_desc into :sbDesc from INC_ItmLoc where %id=:incil)
 //s obj.INSTIStkBinDesc=sbDesc
 //取用新的科室货位表存如符合条件的货位描述(可多货位)
 s obj.INSTIStkBinDesc=sbDescStr
 //zdm,2013-02-04,写入价格及金额信息
 //s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,+$h,uom,hospid)
 //s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,hospid)
 s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,hospid,"G","")
 s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,hospid,"G",+$h,"")
 s freezespamt=qty*sp
 s freezerpamt=qty*rp
 s freezespamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(freezespamt,hospid)
 s freezerpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(freezerpamt,hospid)
 s obj.INSTIFreezeRpAmt=freezerpamt
 s obj.INSTIFreezeSpAmt=freezespamt
 s obj.INSTIRp=rp
 s obj.INSTISp=sp
 s sc=obj.%Save()
 ;b ;1
 i $$$ISERR(sc) w $System.Status.DisplayError(sc)
 i $$$ISERR(sc) q -1
 q obj.%Id()
}

/// 删除一条子表记录
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  inst - 盘点子表记录rowid
/// Return：
///    0 - success
///    <0 -failure
ClassMethod Delete(insti As %String) As %String
{
 s inst=+insti
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.INStkTk).%GetParameter("AppName")_inst)<0 -99  //锁定 
 q:..AllowDel(insti)<0 q -2
 s err=0
 &sql(delete from dhc_instktkitm where %id=:insti)
 i SQLCODE'=0 s err=-3
 d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.INStkTk).%GetParameter("AppName")_inst)  //解锁
 q err
}

/// 判断记录是否允许删除
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  insti - 子表记录rowid
/// Return：
///   记录数据串
ClassMethod AllowDel(insti As %String) As %String
{
 n (insti)
 s inst=+insti
 q ##class(web.DHCST.INStkTk).AllowDel(inst)
}

/// 取一条记录的数据串(属性之间用"^"分隔)
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  insti - 子表记录rowid
/// Return：
///   记录数据串
ClassMethod Select(insti As %String) As %String
{
 n (insti)
 q:insti="" ""
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_InStkTkItm where %ID=:insti)
 q:SQLCODE ""
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 q result
}

/// 取盘点明细记录数据串(json)
/// Author:zhwh
/// Date:2012-08-03
/// Return:
/// 明细记录数据串(json)
/// yunhaibao20151123,首行添加合计,修改为write形式
/// yangsj 2020-10-16 增加TMPMianInfo入参用来零时生成盘点单，用完即删
/// w ##class(web.DHCST.INStkTkItm).jsDHCSTInStkTkItm("0","30","rowid","ASC","","","165^13609^1^^3^^N^N^N^^^N^N")
ClassMethod jsDHCSTInStkTkItm(Start As %String, Limit As %String, Sort As %String, Dir As %String, Inst As %String, Others As %String, TMPMianInfo As %String = "") As %String
{
	i TMPMianInfo'="" s Inst=##class(web.DHCST.INStkTk).CreateInStktk(TMPMianInfo,"Y")
	q:+Inst<0 ""
	k jsDHCSTInStkTkItmDATA
	s qPar=Sort_"^"_Dir
	s jsSort=Sort	
	s result=##class(%Library.ResultSet).%New("web.DHCST.INStkTkItm:DHCSTInStkTkItm")	
	s sc=result.Execute(qPar,Inst,Others,"","")
	//删除临时盘点数据
	i TMPMianInfo'="" d
	. &SQL(DELETE FROM DHC_InStkTk WHERE INST_RowId =:Inst)
	
	i $$$ISERR(sc) w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:$$$ISERR(sc) ""
	i Limit=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:Limit=0 ""
	s pid=..NewPid()
	s $zt="ErrorjsDHCSTInStkTkItm"
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s End = Start+Limit
	s Start=Start+1
	s countrecords=0
	s sumfreezeSpAmt=0
	s sumfreezeRpAmt=0
	s sumcountSpAmt=0
	s sumcountRpAmt=0
	s sumvarianceSpAmt=0
	s sumvarianceRpAmt=0
	k listInci
	s inciCount=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i i=1 s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1
		//预留排序,以防order by不准确的问题
		//rowid,inclb,inci,code,desc,spec,manf,barcode,freQty:%Numeric,freDate,freTime,countQty,countDate,countTime,countPerson,countPersonName,variance,remark,status,uom,uomDesc,batchNo,expDate,adjFlag,sbDesc,inadi,sp,rp,freezeSpAmt,freezeRpAmt,countSpAmt,countRpAmt,varianceSpAmt,varianceRpAmt,trueQty,purUom,purUomDesc,purFreQty
		s rowid=$p(ret,"^",1)
		s instnum=$p(rowid,"||",2)
		s inci=$p(ret,"^",3)
		i '$d(listInci(inci))  d
		.s listInci(inci)=inci
		.s inciCount=inciCount+1
		s incicode=$p(ret,"^",4)
		s incidesc=$p(ret,"^",5)
		s freQty=$p(ret,"^",9)
		s countQty=$p(ret,"^",12)
		s freezeSpAmt=$p(ret,"^",29)
		s freezeRpAmt=$p(ret,"^",30)
		s countSpAmt=$p(ret,"^",31)
		s countRpAmt=$p(ret,"^",32)
		s varianceSpAmt=$p(ret,"^",33)
		s varianceRpAmt=$p(ret,"^",34)
		s sbdesc=$p(ret,"^",25)
		s expdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical($p(ret,"^",23))
		s firststkbindesc=$p(sbdesc,",",1)
		
		s sumfreezeSpAmt=sumfreezeSpAmt+freezeSpAmt
		s sumfreezeRpAmt=sumfreezeRpAmt+freezeRpAmt
		s sumcountSpAmt=sumcountSpAmt+countSpAmt
		s sumcountRpAmt=sumcountRpAmt+countRpAmt
		s sumvarianceSpAmt=sumvarianceSpAmt+varianceSpAmt
		s sumvarianceRpAmt=sumvarianceRpAmt+varianceRpAmt
		s index=1
		i jsSort="sbDesc" s index=firststkbindesc
		e  i jsSort="code" s index=incicode
		e  i jsSort="desc" s index=incidesc
		e  i jsSort="freQty" s index=freQty
		e  i jsSort="countQty" s index=countQty
		e  i jsSort="freezeSpAmt" s index=freezeSpAmt
		e  i jsSort="freezeRpAmt" s index=freezeRpAmt
		e  i jsSort="countSpAmt" s index=countSpAmt
		e  i jsSort="countRpAmt" s index=countRpAmt
		e  i jsSort="varianceSpAmt" s index=varianceSpAmt
		e  i jsSort="varianceRpAmt" s index=varianceRpAmt
		e  i jsSort="rowid" s index=$p(rowid,"||",2)
		e  i jsSort="expDate" s index=expdate
		i index="" s index=1
		s jsDHCSTInStkTkItmDATA(1,index,instnum)=ret
	}
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	i countrecords=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:countrecords=0 ""
	//合计
	s countrecords=countrecords+1
	s sumstring=""
	s $p(sumstring,"^",$l(colNameStr,"^"))=""
	s $p(sumstring,"^",1)="合    计"
	s $p(sumstring,"^",4)="合    计"
	s $p(sumstring,"^",5)="品种数:"_inciCount
	s $p(sumstring,"^",29)=sumfreezeSpAmt
	s $p(sumstring,"^",30)=sumfreezeRpAmt
	s $p(sumstring,"^",31)=sumcountSpAmt
	s $p(sumstring,"^",32)=sumcountRpAmt
	s $p(sumstring,"^",33)=sumvarianceSpAmt
	s $p(sumstring,"^",34)=sumvarianceRpAmt 
	s jsDHCSTInStkTkItmDATA(0,0,countrecords)=sumstring
	i End>countrecords s End=countrecords 
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s count=0
	s outputi=""
	f  s outputi=$o(jsDHCSTInStkTkItmDATA(outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(jsDHCSTInStkTkItmDATA(outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(jsDHCSTInStkTkItmDATA(outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s count = count+1
	...q:count<Start
	...q:count>End
	...s outputdata=jsDHCSTInStkTkItmDATA(outputi,outputj,outputk)
	...i count=Start d
	....w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(countrecords)
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
	....w retstring
	...e  d
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
	....w ","_retstring
	w "]}"
	
	
	
	q ""
ErrorjsDHCSTInStkTkItm
 	s Error=$$Error^DHCSTERROR()
 	q Error
}

/// 检索盘点帐盘表明细
/// Author:zhwh
/// Date:2012-08-02
/// Argu:
/// qPar  -查询参数
/// Inst -盘点主表rowid
/// w ##class(%ResultSet).RunQuery("web.DHCST.INStkTkItm","DHCSTInStkTkItm","desc^ASC","822","0","11:11:11","11:22:22")
Query DHCSTInStkTkItm(qPar As %String = "", Inst As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "rowid:%String,inclb:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,barcode:%String,freQty:%Numeric,freDate:%String,freTime:%String,countQty:%Numeric,countDate:%String,countTime:%String,countPerson:%String,countPersonName:%String,variance:%Numeric,remark:%String,status:%String,uom:%String,uomDesc:%String,batchNo:%String,expDate:%String,adjFlag:%String,sbDesc:%String,inadi:%String,sp:%Numeric,rp:%Numeric,freezeSpAmt:%Numeric,freezeRpAmt:%Numeric,countSpAmt:%Numeric,countRpAmt:%Numeric,varianceSpAmt:%Numeric,varianceRpAmt:%Numeric,trueQty:%Numeric,purUom:%String,purUomDesc:%String,purFreQty:%Numeric,curqty:%String,afterqty:%String,avaqty,statusi,HospDescIO,LocDescIO") [ SqlProc ]
{
}

ClassMethod DHCSTInStkTkItmExecute(ByRef qHandle As %Binary, qPar As %String = "", Inst As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Inst="" $$$OK
 
 // HospDescIO,LocDescIO
 s loc=$P(^DHCINST(Inst),"^",5)
 s LocDescIO=$P(^CTLOC(loc),"^",2)
 s HospDescIO=$P(^CTLOC(loc),"^",22)
 s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
 
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 s statFlag=$p(Others,"^",1)  	;0:全部,1:仅盘盈,2:仅盘亏,3:仅无损益,4:仅有损益
 s incid=$p(Others,"^",2)     	;库存项id
 s freZeroFlag=$p(Others,"^",3) ; 账盘为0  
 s couZeroFlag=$p(Others,"^",4) ; 实盘为0
 s failAdj=$p(Others,"^",5) 	; 明细未调整成功
 s avaLessAdj=$p(Others,"^",6) 	; 可用库存小于调整数
 
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"  //代码
 s:Sort="DESC" orderFieldName="descx"  //描述
 s:Sort="SBDESC" orderFieldName="sbDesc"  //货位
 i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
 i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
 s sql="select %id rowid,"
 s sql=sql_"insti_inclb_dr inclb,"
 s sql=sql_"insti_freezeqty freQty,"
 s sql=sql_"insti_freezedate freDate,"
 s sql=sql_"insti_freezetime freTime,"
 s sql=sql_"insti_count1qty countQty,"
 s sql=sql_"insti_count1date countDate,"
 s sql=sql_"insti_count1time countTime,"
 s sql=sql_"insti_count1person_dr countPerson,"
 s sql=sql_"insti_count1person_dr->ssusr_name countPersonName,"
 s sql=sql_"insti_variance1 variance,"
 s sql=sql_"insti_remarks remark,"
 s sql=sql_"insti_status status,"
 s sql=sql_"insti_ctuom_dr uom,"
 s sql=sql_"insti_ctuom_dr->ctuom_desc uomDesc,"
 s sql=sql_"insti_batchNo batchNo,"
 s sql=sql_"insti_expirydate expDate,"
 s sql=sql_"insti_stockcode code,"
 s sql=sql_"insti_stockdesc descx,"
 s sql=sql_"insti_stockbarcode barcode,"
 s sql=sql_"insti_locdflag adjFlag,"
 s sql=sql_"insti_stkbindesc sbDesc,"
 s sql=sql_"INSTI_Sp Sp,"
 s sql=sql_"INSTI_FreezeSpAmt FreezeSpAmt,"
 s sql=sql_"INSTI_Rp Rp,"
 s sql=sql_"INSTI_FreezeRpAmt FreezeRpAmt,"
 s sql=sql_"INSTI_Count1SpAmt Count1SpAmt,"
 s sql=sql_"INSTI_Count1RpAmt Count1RpAmt,"
 s sql=sql_"INSTI_Variance1SpAmt Variance1SpAmt,"
 s sql=sql_"INSTI_Variance1RpAmt Variance1RpAmt,"
 s sql=sql_"insti_inadi_dr inadi"
 s sql=sql_" from dhc_instktkitm"
 s sql=sql_" where insti_inst_parref="_Inst

 i orderFieldName'="" d
 .s sql=sql_" order by "_orderFieldName_" "_Dir

 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 i $$$ISERR(sc) w $System.Status.DisplayError()
 
 while (xrs.Next() )
 {
	s quitFlag=""
	s rowid=xrs.Data("rowid")
	s inclb=xrs.Data("inclb")
	s inci=+inclb
	continue:(incid'="")&(inci'=incid)
	s scgInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	s stkType=$p(scgInfo,"^",3)
	continue:(stkType'="")&(stkType'=..sssCode())
	s code=xrs.Data("code")
	s desc=xrs.Data("descx")
	s barcode=xrs.Data("barcode")
	s freQty=xrs.Data("freQty")
	s freDate=xrs.Data("freDate")
	s freTime=xrs.Data("freTime")
    //continue:(freTime<StartTime)&&(StartTime'="")&&(freDate=StartDate) //已经按id查询了,这没意义,yunhaibao20160201
    //continue:(freTime>EndTime)&&(EndTime'="")&&(freDate=EndDate)
	s countQty=xrs.Data("countQty")
	s countDate=xrs.Data("countDate")
	s countTime=xrs.Data("countTime")
	s countPerson=xrs.Data("countPerson")
	s countPersonName=xrs.Data("countPersonName")
	s variance=xrs.Data("variance")
	continue:(statFlag=1)&(variance<=0)
	continue:(statFlag=2)&(variance>=0)
	continue:(statFlag=3)&(variance'=0)
	continue:(statFlag=4)&(variance=0)
	continue:(freZeroFlag="Y")&&(+freQty=0)
	continue:(couZeroFlag="Y")&&(+countQty=0)
	s remark=xrs.Data("remark")
	s status=xrs.Data("status")
	s uom=xrs.Data("uom")
	s uomDesc=xrs.Data("uomDesc")
	s bUom=$p(^INCI(inci,1),"^",10)
	s puruom=$p(^INCI(inci,3),"^",6)  //入库单位 wyx add 2014-04-28
	s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,bUom)
    s purfreqty=freQty/Fac2  //入库单位数量 wyx add 2014-04-28
    s puruomdesc=$p(^CT("UOM",puruom),"^",2) //入库单位desc wyx add 2014-04-28
	s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,bUom)
	s buom=$p(^INCI(inci,1),"^",10)
    s loc=$$LOC^ST01(inclb)
    s hospid=$p(^CTLOC(loc),"^",22)
    s StkType = "G"
	s countQty=countQty/Fac
	s variance=variance/Fac
	s batchNo=xrs.Data("batchNo")
	s expDate=xrs.Data("expDate")
	s adjFlag=xrs.Data("adjFlag")
	s incil=inci_"||"_$p(inclb,"||",2)
	s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）add wyx 2013-11-21
    s stkbinstr=$p(stkbinret,":",2)
	s sbDesc=stkbinstr
	s sp=xrs.Data("Sp")
	s freezeSpAmt=xrs.Data("FreezeSpAmt")
	s rp=xrs.Data("Rp")
	s freezeRpAmt=xrs.Data("FreezeRpAmt")
	s countSpAmt=xrs.Data("Count1SpAmt")
	s countRpAmt=xrs.Data("Count1RpAmt")
	s varianceSpAmt=xrs.Data("Variance1SpAmt")
	s varianceRpAmt=xrs.Data("Variance1RpAmt")
	s freezeRpAmt = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt(freezeRpAmt,hospid)
	s countRpAmt = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt(countRpAmt,hospid)
	s varianceRpAmt = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt(varianceRpAmt,hospid)
	s freezeSpAmt = ##Class(web.DHCST.Common.AppCommon).FormatSpAmt(freezeSpAmt,hospid)
	s countSpAmt = ##Class(web.DHCST.Common.AppCommon).FormatSpAmt(countSpAmt,hospid)
	s varianceSpAmt = ##Class(web.DHCST.Common.AppCommon).FormatSpAmt(varianceSpAmt,hospid)
	
	s inadi=xrs.Data("inadi")
	s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	s manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
	i expDate'="" d
	.i +expDate'=expDate s expDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(expDate)
	.s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
	s:countDate'="" countDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(countDate,"ST")
	s:countTime'="" countTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(countTime,"ST")
	s:freDate'="" freDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(freDate,"ST")
	s:freTime'="" freTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(freTime,"ST")
	s trueQty=""
	s inclbqty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
	s dirtyqty=$p(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",3)
	s avaqty=inclbqty-dirtyqty
	s afterqty=inclbqty+variance
 	continue:(avaLessAdj="Y")&&((avaqty+variance)>=0)
 	s statusi=""
 	i (inadi'="")&&($d(^DHCINTR(0,"TypePointer","A",inadi)))  s statusi="已调整"
	i failAdj="Y" d
	.i (inadi'="")&&($d(^DHCINTR(0,"TypePointer","A",inadi))) s quitFlag=1
	continue:quitFlag'=""
 	d OutPutRow
}
 
 Quit $$$OK
OutPutRow
 s Data=$lb(rowid,inclb,inci,code,desc,spec,manf,barcode,freQty,freDate,freTime,countQty,countDate,countTime,countPerson,countPersonName,variance,remark,status,uom,uomDesc,batchNo,expDate,adjFlag,sbDesc,inadi,sp,rp,freezeSpAmt,freezeRpAmt,countSpAmt,countRpAmt,varianceSpAmt,varianceRpAmt,trueQty,puruom,puruomdesc,purfreqty,inclbqty,afterqty,avaqty,statusi,HospDescIO,LocDescIO)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCSTInStkTkItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCSTInStkTkItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCSTInStkTkItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCSTInStkTkItmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 检索盘点帐盘表明细(按货位)
/// Author:wyx
/// Date:2013-11-22
/// Argu:
/// qPar  -查询参数
/// Inst -盘点主表rowid
/// 
Query DHCSTInStkTkItmStkBin(qPar As %String = "", Inst As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "rowid:%String,inclb:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,barcode:%String,freQty:%Numeric,freDate:%String,freTime:%String,countQty:%Numeric,countDate:%String,countTime:%String,countPerson:%String,countPersonName:%String,variance:%Numeric,remark:%String,status:%String,uom:%String,uomDesc:%String,batchNo:%String,expDate:%String,adjFlag:%String,sbDesc:%String,inadi:%String,sp:%Numeric,rp:%Numeric,freezeSpAmt:%Numeric,freezeRpAmt:%Numeric,countSpAmt:%Numeric,countRpAmt:%Numeric,varianceSpAmt:%Numeric,varianceRpAmt:%Numeric,trueQty:%Numeric,purUom:%String,purUomDesc:%String,purFreQty,HospDescIO,LocDescIO") [ SqlProc ]
{
}

ClassMethod DHCSTInStkTkItmStkBinExecute(ByRef qHandle As %Binary, qPar As %String = "", Inst As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Inst="" $$$OK
 
 // HospDescIO,LocDescIO
 s loc=$P(^DHCINST(Inst),"^",5)
 s LocDescIO=$P(^CTLOC(loc),"^",2)
 s HospDescIO=$P(^CTLOC(loc),"^",22)
 s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
  
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 s statFlag=$p(Others,"^",1)  ;0:全部,1:仅盘盈,2:仅盘亏,3:仅无损益,4:仅有损益
 s incid=$p(Others,"^",2)     ;库存项id
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"  //代码
 s:Sort="DESC" orderFieldName="descx"  //描述
 s:Sort="SBDESC" orderFieldName="sbDesc"  //货位
 //s:Sort="" orderFieldName=""
 i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
 i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
 s sql="select %id rowid,"
 s sql=sql_"insti_inclb_dr inclb,"
 s sql=sql_"insti_freezeqty freQty,"
 s sql=sql_"insti_freezedate freDate,"
 s sql=sql_"insti_freezetime freTime,"
 s sql=sql_"insti_count1qty countQty,"
 s sql=sql_"insti_count1date countDate,"
 s sql=sql_"insti_count1time countTime,"
 s sql=sql_"insti_count1person_dr countPerson,"
 s sql=sql_"insti_count1person_dr->ssusr_name countPersonName,"
 s sql=sql_"insti_variance1 variance,"
 s sql=sql_"insti_remarks remark,"
 s sql=sql_"insti_status status,"
 s sql=sql_"insti_ctuom_dr uom,"
 s sql=sql_"insti_ctuom_dr->ctuom_desc uomDesc,"
 s sql=sql_"insti_batchNo batchNo,"
 s sql=sql_"insti_expirydate expDate,"
 s sql=sql_"insti_stockcode code,"
 s sql=sql_"insti_stockdesc descx,"
 s sql=sql_"insti_stockbarcode barcode,"
 s sql=sql_"insti_locdflag adjFlag,"
 s sql=sql_"insti_stkbindesc sbDesc,"
 s sql=sql_"INSTI_Sp Sp,"
 s sql=sql_"INSTI_FreezeSpAmt FreezeSpAmt,"
 s sql=sql_"INSTI_Rp Rp,"
 s sql=sql_"INSTI_FreezeRpAmt FreezeRpAmt,"
 s sql=sql_"INSTI_Count1SpAmt Count1SpAmt,"
 s sql=sql_"INSTI_Count1RpAmt Count1RpAmt,"
 s sql=sql_"INSTI_Variance1SpAmt Variance1SpAmt,"
 s sql=sql_"INSTI_Variance1RpAmt Variance1RpAmt,"
 s sql=sql_"insti_inadi_dr inadi"
 s sql=sql_" from dhc_instktkitm"
 s sql=sql_" where insti_inst_parref="_Inst

 i orderFieldName'="" d
 .s sql=sql_" order by "_orderFieldName_" "_Dir

 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 i $$$ISERR(sc) w $System.Status.DisplayError()
 s pid=..NewPid()
 while (xrs.Next() )
 {
	s rowid=xrs.Data("rowid")
	s inclb=xrs.Data("inclb")
	s inci=+inclb
	continue:(incid'="")&(inci'=incid)
	s scgInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	s stkType=$p(scgInfo,"^",3)
	continue:(stkType'="")&(stkType'=..sssCode())
	s code=xrs.Data("code")
	s desc=xrs.Data("descx")
	s barcode=xrs.Data("barcode")
	s freQty=xrs.Data("freQty")
	s freDate=xrs.Data("freDate")
	s freTime=xrs.Data("freTime")
    continue:(freTime<StartTime)&&(StartTime'="")&&(freDate=StartDate)
    continue:(freTime>EndTime)&&(EndTime'="")&&(freDate=EndDate)
	s countQty=xrs.Data("countQty")
	s countDate=xrs.Data("countDate")
	s countTime=xrs.Data("countTime")
	s countPerson=xrs.Data("countPerson")
	s countPersonName=xrs.Data("countPersonName")
	s variance=xrs.Data("variance")
	continue:(statFlag=1)&(variance<=0)
	continue:(statFlag=2)&(variance>=0)
	continue:(statFlag=3)&(variance'=0)
	continue:(statFlag=4)&(variance=0)
	s remark=xrs.Data("remark")
	s status=xrs.Data("status")
#;	s uom=$p(^INCI(inci,1),"^",10) ;xrs.Data("uom")
#;	s uomDesc=$p(^CT("UOM",uom),"^",2) ;xrs.Data("uomDesc")
	s uom=xrs.Data("uom")
	s uomDesc=xrs.Data("uomDesc")
	s bUom=$p(^INCI(inci,1),"^",10)
	s puruom=$p(^INCI(inci,3),"^",6)  //入库单位 wyx add 2014-04-28
	s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,bUom)
       s purfreqty=freQty/Fac2  //入库单位数量 wyx add 2014-04-28
       s puruomdesc=$p(^CT("UOM",puruom),"^",2) //入库单位desc wyx add 2014-04-28
	s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,bUom)
	s freQty=freQty/Fac		;按帐盘单位显示
	s countQty=countQty/Fac
	s variance=variance/Fac
	
	s batchNo=xrs.Data("batchNo")
	s expDate=xrs.Data("expDate")
	s adjFlag=xrs.Data("adjFlag")
	s sbDesc=xrs.Data("sbDesc")
	
	s incil=inci_"||"_$p(inclb,"||",2)
	//s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）add wyx 2013-11-21
	//s stkchkflag=$p(stkbinret,":",1)
      //s stkbinstr=$p(stkbinret,":",2)
	//s sbDesc=stkbinstr
	if sbDesc="" s sbDesc=xrs.Data("sbDesc")
	s sp=xrs.Data("Sp")
	s freezeSpAmt=xrs.Data("FreezeSpAmt")
	s rp=xrs.Data("Rp")
	s freezeRpAmt=xrs.Data("FreezeRpAmt")
	s countSpAmt=xrs.Data("Count1SpAmt")
	s countRpAmt=xrs.Data("Count1RpAmt")
	s varianceSpAmt=xrs.Data("Variance1SpAmt")
	s varianceRpAmt=xrs.Data("Variance1RpAmt")
	s inadi=xrs.Data("inadi")
	s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	s manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
	s:expDate'="" expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
	i expDate'="" d
	.i +expDate'=expDate s expDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(expDate)
	.s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
	s:countTime'="" countTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(countTime,"ST")
	s:freDate'="" freDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(freDate,"St")
	s:freTime'="" freTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(freTime,"ST")
	s trueQty=""
	s ^TMPDHCSTSTKITMSTKBINPID("DHCST","INStkTkItm","StkBin",pid,"index",rowid)=rowid_"^"_inclb_"^"_inci_"^"_code_"^"_desc_"^"_spec_"^"_manf_"^"_barcode_"^"_freQty_"^"_freDate_"^"_freTime_"^"_countQty_"^"_countDate_"^"_countTime_"^"_countPerson_"^"_countPersonName_"^"_variance_"^"_remark_"^"_status_"^"_uom_"^"_uomDesc_"^"_batchNo_"^"_expDate_"^"_adjFlag_"^"_sbDesc_"^"_inadi_"^"_sp_"^"_rp_"^"_freezeSpAmt_"^"_freezeRpAmt_"^"_countSpAmt_"^"_countRpAmt_"^"_varianceSpAmt_"^"_varianceRpAmt_"^"_puruom_"^"_puruomdesc_"^"_purfreqty
 	//d OutPutRowSB
	}
 s rownum=""
 f  s rownum=$o(^TMPDHCSTSTKITMSTKBINPID("DHCST","INStkTkItm","StkBin",pid,"index",rownum)) q:rownum=""  d
 .s data=^TMPDHCSTSTKITMSTKBINPID("DHCST","INStkTkItm","StkBin",pid,"index",rownum)
 .s stkbinstr=$p(data,"^",25)
 .s stknum=$LENGTH(stkbinstr,",")
 .f k=1:1:stknum   d
 ..s stkbin=$p(stkbinstr,",",k)
 ..s rowid=$p(data,"^",1)
 ..s inclb=$p(data,"^",2)
 ..s inci=$p(data,"^",3)
 ..s code=$p(data,"^",4)
 ..s desc=$p(data,"^",5)
 ..s spec=$p(data,"^",6)
 ..s manf=$p(data,"^",7)
 ..s barcode=$p(data,"^",8)
 ..s freQty=$p(data,"^",9)
 ..s freDate=$p(data,"^",10)
 ..s freTime=$p(data,"^",11)
 ..s countQty=$p(data,"^",12)
 ..s countDate=$p(data,"^",13)
 ..s countTime=$p(data,"^",14)
 ..s countPerson=$p(data,"^",15)
 ..s countPersonName=$p(data,"^",16)
 ..s variance=$p(data,"^",17)
 ..s remark=$p(data,"^",18)
 ..s status=$p(data,"^",19)
 ..s uom=$p(data,"^",20)
 ..s uomDesc=$p(data,"^",21)
 ..s batchNo=$p(data,"^",22)
 ..s expDate=$p(data,"^",23)
 ..s adjFlag=$p(data,"^",24)
 ..s sbDesc=stkbin
 ..s inadi=$p(data,"^",26)
 ..s sp=$p(data,"^",27)
 ..s rp=$p(data,"^",28)
 ..s freezeSpAmt=$p(data,"^",29)
 ..s freezeRpAmt=$p(data,"^",30)
 ..s countSpAmt=$p(data,"^",31)
 ..s countRpAmt=$p(data,"^",32)
 ..s varianceSpAmt=$p(data,"^",33)
 ..s varianceRpAmt=$p(data,"^",34)
 ..s puruom=$p(data,"^",35)
 ..s puruomdesc=$p(data,"^",36)
 ..s purfreqty=$p(data,"^",37)
 ..d OutPutRowSB
 k ^TMPDHCSTSTKITMSTKBINPID("DHCST","INStkTkItm","StkBin",pid)
 Quit $$$OK
OutPutRowSB
 s Data=$lb(rowid,inclb,inci,code,desc,spec,manf,barcode,freQty,freDate,freTime,countQty,countDate,countTime,countPerson,countPersonName,variance,remark,status,uom,uomDesc,batchNo,expDate,adjFlag,sbDesc,inadi,sp,rp,freezeSpAmt,freezeRpAmt,countSpAmt,countRpAmt,varianceSpAmt,varianceRpAmt,trueQty,puruom,puruomdesc,purfreqty,HospDescIO,LocDescIO)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCSTInStkTkItmStkBinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCSTInStkTkItmStkBinExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCSTInStkTkItmStkBinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCSTInStkTkItmStkBinExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 检查并设置某科室的所有库存批次的“活动”状态属性
/// （从当前活动状态=Y的批次中查找）
/// 该科室的库存批次的活动状态由Y->N的条件:
///   1.该批次库存为0且最近的盘点周期内没有发生任何业务。
/// 以下情况不可状态设置为"N"
///   1.该批次库存>0
///   2.本盘点周期内发生过业务
/// 
/// Author:zhwh
/// Date:2012-08-02
/// Argu:
///  Loc -科室rowid
/// Return：
///   0- sucess
///   <0 - failure
ClassMethod SetLcBtNonActive(Loc As %String) As %String
{
  n (Loc)
  s inci=0
  f  s inci=$o(^INCI("IL_LOC",Loc,inci)) q:inci=""  d
  .s ch=$O(^INCI("IL_LOC",Loc,inci,""))
  .s lbCh=0
  .f  s lbch=$O(^INCI(inci,"IL",ch,"LB",lbCh)) q:lbCh=""  d
  ..s inclb=inci_"||"_ch_"||"_lbCh
  .
  q 0
}

ClassMethod NewPid() As %String
{
  	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

}
