Import sqluser

Class web.DHCST.INStkTkItmWd Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTINSTKTKINPUT";

/// 批量保存实盘表记录（方式一、四公共方法）
/// Author:zhangdongmei
/// Date:2012-08-31
/// Argu:
/// data - 实盘表记录数据串(记录间","分隔: 帐盘子表id^实盘表id^实盘人rowid^实盘数^实盘单位^货位^实盘窗口)
ClassMethod Save(ListData As %String) As %String
{
	n (ListData)
	q:ListData="" -1
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(ListData,rowDelim)
	s Err=""
	s Count=0
	f i=1:1:len  d
	.s Data=$p(ListData,rowDelim,i)
	.b //444444
	.q:Data=""
	.s Parref=$p(Data,"^",1)
	.s Rowid=$p(Data,"^",2)
	.s UserId=$p(Data,"^",3)
	.s CountQty=$p(Data,"^",4) //(对于方式一、四没有值)
	.s BUom=$p(Data,"^",5)    //(对于方式一、四为基本单位)
	.s StkBin=$p(Data,"^",6)
	.s PhaWin=$p(Data,"^",7)
	.s BQty=$p(Data,"^",8) //基本单位数量
	.s PQty=$p(Data,"^",9) //大单位数量
	.s Inci=$p(^DHCINST(+Parref,"STI",$p(Parref,"||",2)),"^",18)
	.s IncDesc=$p(^INCI(Inci,1),"^",2)
	.s BuomId=$p(^INCI(Inci,1),"^",10)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.//s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(CountUom,BuomId)
	.s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BuomId)
	.//s BuomQty=BQty
	.//s PurUomQty=PQty
	.s BQtyB=PQty*Fac2
	.i CountQty="" s CountQty=BQty+BQtyB //以基本单位 数量和 存入wd表 modify wyx 2014-12-04
	.//根据总数再重新分配大单位数量和基本单位数量
	.s PQty=CountQty\Fac2 //  整除 add wyx 2014-12-05
	.s BQty=CountQty#Fac2 // 余数
	.s Detail=UserId_"^"_CountQty_"^"_BUom_"^"_BQty_"^"_PQty_"^"_StkBin_"^"_PhaWin
	.s ret=..Update(Rowid,Parref,Detail)
	.i +ret<=0  d
	..s Err=Err_","_IncDesc
	.e  d
	..s Count=Count+1
	.
	q:Count=0 -2   				;全部保存失败
	q:Err'="" -3_":"_Err		;部分保存失败
	q 0							;保存成功
}

/// 批量保存实盘表记录（方式二单独方法）
/// Author:zhangdongmei
/// Date:2012-08-31
/// Argu:
/// data - 实盘表记录数据串(记录间","分隔: 帐盘子表id^实盘表id^实盘人rowid^实盘数^实盘单位^货位^实盘窗口)
/// w ##class(web.DHCST.INStkTkItmWd).Save2("35||8^^590^4^7^^^^")
ClassMethod Save2(ListData As %String) As %String
{
	n (ListData)
	q:ListData="" -1
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(ListData,rowDelim)
	s Err=""
	s Count=0
	f i=1:1:len  d
	.s Data=$p(ListData,rowDelim,i)
	.q:Data=""
	.s Parref=$p(Data,"^",1)
	.s Rowid=$p(Data,"^",2)
	.s UserId=$p(Data,"^",3)
	.s CountQty=$p(Data,"^",4) //(对于方式二来说此变量有值)
	.s CountUom=$p(Data,"^",5)    //(对于方式二来说此单位是录入单位)
	.s StkBin=$p(Data,"^",6)
	.s PhaWin=$p(Data,"^",7)
	.s BQty=$p(Data,"^",8) //基本单位数量
	.s PQty=$p(Data,"^",9) //大单位数量
	.s Inci=$p(^DHCINST(+Parref,"STI",$p(Parref,"||",2)),"^",18)
	.s IncDesc=$p(^INCI(Inci,1),"^",2)
	.s BuomId=$p(^INCI(Inci,1),"^",10)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.//s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(CountUom,BuomId)
	.s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(CountUom,BuomId)
	.//s BuomQty=BQty
	.//s PurUomQty=PQty
	.s CountQty=CountQty*Fac2 //以基本单位 数量 存入wd表 modify wyx 2014-12-04
	.//根据总数再重新分配大单位数量和基本单位数量
	.s PQty=CountQty\Fac2 //  整除 add wyx 2014-12-05
	.s BQty=CountQty#Fac2 // 余数
	.s Detail=UserId_"^"_CountQty_"^"_CountUom_"^"_BQty_"^"_PQty_"^"_StkBin_"^"_PhaWin
	.s ret=..Update(Rowid,Parref,Detail)
	.i +ret<=0  d
	..s Err=Err_","_IncDesc
	.e  d
	..s Count=Count+1
	.
	q:Count=0 -2   				;全部保存失败
	q:Err'="" -3_":"_Err		;部分保存失败
	q 0							;保存成功
}

/// 填充未录入实盘数记录的默认数
/// Author:zhangdongmei
/// Date:2012-09-03
/// Argu:
/// : 帐盘表id,实盘人rowid,填充标志(1:未填记录实盘数=0;2:未填记录实盘数=账盘数)
/// w ##class(web.DHCST.INStkTkItmWd).SetDefaultQty("162","13609","2","1")
ClassMethod SetDefaultQty(Inst As %String, UserId As %String, Flag As %String, InstwWin As %String) As %String
{
	n (Inst,UserId,Flag,InstwWin)
	s InstwWin=$g(InstwWin)
	q:Inst="" -1
	s Flag=+Flag
	;
	k SetDefaultQtyArr
	s Count=0
	s Err=""
	s Chl=0
	f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:Chl=""  d
	.s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)	;冻结数量为基本单位
	.s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	.//先计算已经录入的实盘数量
	.s instSub=0
	.f  s instSub=$O(^DHCINST(Inst,"STI",Chl,"STW",instSub)) q:instSub=""  d
	..s HasCountQty=+$p(^DHCINST(Inst,"STI",Chl,"STW",instSub),"^",2)
	..s SetDefaultQtyArr(Inst_"||"_Chl)=+$G(SetDefaultQtyArr(Inst_"||"_Chl))+HasCountQty
	.s Sub=0
	.f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:Sub=""  d
	..s window=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",7)
	..q:window'=InstwWin	;wanajiabin 2013-07-17 过滤实盘窗口
	..s CountQty=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2) //基本单位数量和
	..q:CountQty'=""	;已录入
	..s CountUser=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	..q:CountUser'=""	;已录入
	..
	..i Flag=1  d
	...s DefaultQty=0
	..e  i Flag=2  d
	...//s DefaultQty=FreQty
	...s DefaultQty=FreQty-$G(SetDefaultQtyArr(Inst_"||"_Chl))
	...i DefaultQty<0 s DefaultQty=0 //wyx 增加对冻结库存为负的明细变为0
	...
	..
	..s Inci=$p(^DHCINST(Inst,"STI",Chl),"^",18)
	..s IncDesc=$p(^INCI(Inci,1),"^",2)
	..s BuomId=$p(^INCI(Inci,1),"^",10)
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(FreUom,BuomId)
	..s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BuomId)
	..s PurUomQty=DefaultQty\Fac2 //  整除 add wyx 2014-12-04
	..s BuomQty=DefaultQty#Fac2 // 余数
	..//s BuomQty=DefaultQty
	..//s PurUomQty=DefaultQty/Fac2
	..//s DefaultQty=DefaultQty/Fac1
	..s DefaultQty=DefaultQty   ///wyx modify 改为存基本单位，因为涉及汇总计算不能用大单位（当帐盘单位为入库单位时）
	..s Detail=UserId_"^"_DefaultQty_"^"_FreUom_"^"_BuomQty_"^"_PurUomQty_"^^"
	..
	..s Rowid=Inst_"||"_Chl_"||"_Sub
	..s Parref=Inst_"||"_Chl
	..s ret=..Update(Rowid,Parref,Detail)
	..;b ;ret
	..i +ret<=0  d
	...s Err=Err_","_IncDesc
	..e  d
	...s Count=Count+1
	..
	.
	q:Err'="" -3_":"_Err		;部分保存失败
	q 0							;保存成功
}

/// 插入或更新实盘表记录
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///  instw - 实盘表记录rowid
///  insti -实盘表父表记录rowid(DHC_INStkTkItm)
///  data - 实盘表记录数据串("^"分隔: 实盘人rowid^实盘数^实盘单位^基本单位数量^入库单位数量^货位^实盘窗口)
///  InputQty-实盘数量（录入方式添加的参数其他可以没有）
ClassMethod Update(instw As %String, insti As %String, data As %String) As %String
{
  //s insti="22||2"
  //s data="1^1000^17^^^yui^"
  n (instw,insti,data,InputQty)
  s user=$p(data,"^",1)   //实盘人rowid
  s qty=$p(data,"^",2)  //实盘数量和（基本单位）
  s uom=$p(data,"^",3)  //　实盘单位（基本单位）
  s bQty=$p(data,"^",4)  //　基本单位数量
  s pQty=$p(data,"^",5)  //　入库单位数量
  s stkbin=$p(data,"^",6)  //　货位
  s window=$p(data,"^",7)  //　　实盘窗口
  
  i instw="" d 
  .s obj=##class(User.DHCInStkTkItmWd).%New()
  .d obj.INSTWINSTIParrefSetObjectId(insti)
  .s inst=+insti,ch=$p(insti,"||",2)
  .s chw=$o(^DHCINST(inst,"STI",ch,"STW",""),-1)+1
  .s obj.INSTWChildSub=chw
  .s obj.INSTWStkBinDesc=stkbin
  .s obj.INSTWPHWDR=##class(User.DHCInStkTkWindow).%OpenId(window,0)
  e  d
  .s obj=##class(User.DHCInStkTkItmWd).%OpenId(instw)
  .d obj.%Reload()	
  
  s obj.INSTWCountDate=+$h
  s obj.INSTWCountTime=$p($h,",",2)
  d obj.INSTWCountPersonDRSetObjectId(user)
  s obj.INSTWCountQty=qty
  d obj.INSTWCTUOMDRSetObjectId(uom)
  s obj.INSTWQtyBuom=bQty
  s obj.INSTWQtyPuom=pQty
   s sc=obj.%Save()
   //i $$$ISERR(sc) w $System.Status.DisplayError(),!
   i $$$ISERR(sc) q -1
   q obj.%Id()
}

/// 删除盘点实盘明细记录
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///   instw - 实盘表Rowid(DHC_INStktkItmWd)
/// Return:
///  0 - success
///  <0 - failure
ClassMethod Delete(instw As %String) As %String
{
  i ##class(web.DHCST.Common.AppCommon).Lock("DHCSTINSTKTK"_instw)<0 q -99
  i ..AllowDel(instw)<0 d ..uLock(instw)  q -1
  &sql(delete from dhc_instktkitmwd where %ID=:instw)
  i SQLCODE'=0 d ..uLock(instw) q -2
  d ..uLock(instw)
  q 0
}

/// 实盘表记录数据
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///   instw - 实盘表Rowid(DHC_INStktkItmWd)
/// Return:
/// 实盘表记录数据串("^"分隔)
ClassMethod Select(instw As %String) As %String
{
 n (instw)
 q:instw="" ""
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_InStkTkItmWd where %ID=:instw)
 q:SQLCODE ""
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 q result
}

/// 是否允许删除
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///   instw - 实盘表Rowid(DHC_INStktkItmWd)
/// Return:
/// 0 - 允许
/// <0 - 不允许
ClassMethod AllowDel(instw As %String) As %String
{
  s inst=+instw
  q ##class(web.DHCST.INStkTk).AllowDel(inst)
}

/// 解锁
ClassMethod uLock(instw As %String)
{
 d ##class(web.DHCST.Common.AppCommon).UnLock("DHCSTINSTKTK"_instw)	
 q
}

/// 实盘数据汇总  
///    -即将实盘表中的数据，按照批次对实盘数量加以汇总（基本单位），然后更新到帐盘表中
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///  inst - 盘点主表rowid
/// Return:
///  0 - scucess
///  <0 - failure
/// w ##Class(web.DHCST.INStkTkItmWd).INStkTkWdSum(92,13609,1)
ClassMethod INStkTkWdSum(inst As %String, user As %String, inputnullsel As %String) As %String
{
	n (inst,user,inputnullsel)
	//s ^YSJTMP("actiontype") = $LB(inst,user,inputnullsel)
 	q:inst="" -1
 	s Loc=$p(^DHCINST(inst),"^",5)
 	s HospID=$p(^CTLOC(Loc),"^",22)
	//zhangdongmei,2012-09-11,加锁,错误处理
	q:##class(web.DHCST.Common.AppCommon).Lock("DHCSTINSTKTK"_inst)<0 -99
	s CompleteFlag=$p(^DHCINST(inst),"^",13)
	i CompleteFlag="Y" d ##class(web.DHCST.Common.AppCommon).UnLock("DHCSTINSTKTK"_inst) q -2    ;已经完成
	d ..PopulateInci(inst)
	s ret=0
	s ch=0
	s $ZT="Error^DHCSTERROR"
	f  s ch=$o(^DHCINST(inst,"STI",ch)) q:(ch="")!(ret<0)  d
	. s insti=inst_"||"_ch
	. s inci=$p(^DHCINST(inst,"STI",ch),"^",18)  q:inci=""   ;inci rowid
	. s buom=$p(^INCI(inci,1),"^",10) q:buom=""
	. s biqty=0
	. s freQty=+$p(^DHCINST(inst,"STI",ch),"^",2) 
	. ts
	. s biqty=..SumCountQty(insti)   //biqty = "" ,代表所有窗口均未录入数量
	. s retflag = 0
	. i (biqty = "") d
	. . i (inputnullsel=1) d  //bianshuai 2014-07-12
	. . . s biqty=freQty ; 采用帐盘数量
	. . . i freQty<0 s biqty=0 // modif by wyx 2014-01-15
	. . . //增加对wd表的控制对于没有录入的药品(所有批次均未录入，则更新为帐盘数)
	. . . s retflag=..UpINStkTkWd(insti,inputnullsel,user)
	. . e  d
	. . . s biqty=+biqty  //汇总盘点销售
	. . . //增加对wd表的控制对于没有录入的药品(所有批次均未录入，则更新为0) 
	. . . s retflag=..UpINStkTkWd(insti,inputnullsel,user)
	. i retflag'=0 tro  s ret=-102 
	. q:ret=-102
	. s rp=$P(^DHCINST(inst,"STI",ch),"^",30)
	. //s rpAmt=rp*biqty
	. s sp=$P(^DHCINST(inst,"STI",ch),"^",28)
	. //s spAmt=sp*biqty
	. //s spAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spAmt,HospID)
 	. //s rpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,HospID)	
 	. s inclb = $p(^DHCINST(inst,"STI",ch),"^",1)
 	. s rpAmt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, biqty, buom, HospID)
 	. s spAmt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, biqty, buom, HospID)
	. ;ts
	. s obj=##class(User.DHCInStkTkItm).%OpenId(insti)
	. d obj.%Reload()
	. d obj.INSTICount1PersonDRSetObjectId(user)
	. s obj.INSTICount1Qty=+biqty
	. s obj.INSTICount1Date=+$H
	. s obj.INSTICount1Time=$P($H,",",2)
	. s obj.INSTICount1SpAmt=+spAmt
	. s obj.INSTICount1RpAmt=+rpAmt
	. s varQty=obj.INSTICount1Qty-freQty
	. s obj.INSTIVariance1=varQty
	. s obj.INSTIVariance1RpAmt=obj.INSTICount1RpAmt-obj.INSTIFreezeRpAmt
	. s obj.INSTIVariance1SpAmt=obj.INSTICount1SpAmt-obj.INSTIFreezeSpAmt
	. s sc=obj.%Save()
	. i $$$ISERR(sc) tro  s ret=-5 
	. q:ret=-5 
	. s ff="1"
	. &sql(Update DHC_InStkTkItmWd set INSTW_InStkItmFlag=:ff where INSTW_INSTI_Parref=:insti)
	. i SQLCODE<0 tro  s ret= -101  q	// '=0改为<0  避免实盘方式二录入不全时SQLCODE=100造成的汇总报错
	. s operflag="Y"
	. b ;tc
	. tc
	k ^TMP($j,"STKTKINCI")
	i ret<0  d ##class(web.DHCST.Common.AppCommon).UnLock("DHCSTINSTKTK"_inst) q ret  //
	s compelete="Y"
	&sql(update DHC_instktk  set inst_stocktakecomplete=:compelete where inst_rowid =:inst)
	i SQLCODE'=0  s ret= -100
	d ##class(web.DHCST.Common.AppCommon).UnLock("DHCSTINSTKTK"_inst)
	q ret
}

/// 汇总某一项目的盘点数据
/// Author:zhwh
/// Date:2012-08-10
/// Argu:
///  insti - 
/// Return:
///  实盘总数(基本单位)
///  w ##class(web.DHCST.INStkTkItmWd).SumCountQty("92||5")
ClassMethod SumCountQty(insti As %String) As %String
{
  n (insti)
  s biqty=0
  s wch=0 
  s inst=+insti
  s ch=$p(insti,"||",2)
  s inci=+$P(^DHCINST(inst,"STI",ch),"^",1)
  s buom=$p(^INCI(inci,1),"^",10)
  s wflag=0
  f  s wch=$o(^DHCINST(inst,"STI",ch,"STW",wch)) q:wch=""  d
 . s stkwstr="",instkflag="",cuom="",cqty="",ret=""
 . 
 . s stkwstr=$G(^DHCINST(inst,"STI",ch,"STW",wch))
 . s cqty=$p(stkwstr,"^",2)
 . q:cqty=""
 . s wflag=1
 . //s cuom=+$p(stkwstr,"^",1) q:cuom=""  //实盘单位
 . s cqty=+cqty    //实盘数量
 . //s ffactor=##class(web.DHCST.Common.UtilCommon).UOMFac(cuom,buom)    q:ffactor=""
 . //s cqty=cqty*ffactor //modify by wyx 2014-01-15 wd存的实盘数已经是基本单位不用在转换
 . s biqty=biqty+cqty
 q:wflag=0 ""
 q biqty
}

/// 聚集本次盘点实盘表中的所有项目到临时global中
/// 
ClassMethod PopulateInci(inst As %String) As %String
{
 n (inst)
 s n=0 
 s ch=0
 f  s ch=$o(^DHCINST(inst,"STI",ch)) q:ch=""  d
 . s inci=$p(^(ch),"^",18)
 . s wch=0
 . f  s wch=$o(^DHCINST(inst,"STI",ch,"STW",wch)) q:wch=""  d
 . . i '$d(^TMP($j,"STKTKINCI",inci)) d
 . . . s n=n+1 
 . . . s ^TMP($j,"STKTKINCI",inci)=n
 q n
}

/// 检查某项目是否在已经实盘的列表中 
///  ^TMP($j,"STKTKINCI",inci)是已经实盘的项目
ClassMethod InWd(inci As %String) As %String
{
 q:inci="" 0
 q:$d(^TMP($j,"STKTKINCI",inci)) 1
 q 0
}

/// 根据帐盘记录生成实盘数据列表（实盘方式一）
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///   inst - 盘点主表rowid
/// Return:
///   0 - scucess
///   <0 - failure
ClassMethod CreateStkTkItmWd(inst As %String, user As %String, window As %String) As %String
{
 n (inst,user,window)
 q:inst="" -1
 s ret=0
 s i=0
 s ch=0
 f  s ch=$o(^DHCINST(inst,"STI",ch)) q:(+ch=0)!(ret<0)  d
 . s insti=inst_"||"_ch
 . s wuom=+$p(^DHCINST(inst,"STI",ch),"^",17)
 . s qty=$p(^DHCINST(inst,"STI",ch),"^",2)
 . s inclb=$p(^DHCINST(inst,"STI",ch),"^",1)
 . s inci=+inclb
 . s buom=$P(^INCI(inci,1),"^",10)
 . s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(wuom,buom)
 . s countQty=qty/fac
 . s bQty=""
 . s pQty=""
 . s stkbin=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr($p(inclb,"||",1,2),",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）add wyx 2013-11-21
 . s stkbin=$p(stkbin,":",2)
 . s data="^^"_wuom_"^^^"_stkbin_"^"_window
 . s instw=""
 . i window'="" d
 . . s instw=$o(^DHCINST("WINDOW",inst,window,ch,0))
 . e  d
 . .&sql(select INSTW_RowID into :instw from dhc_instktkitmwd where INSTW_INSTI_Parref=:insti and INSTW_PHW_DR is null)
 . q:instw'=""  ;已经生成了实盘项目
 . ts
 . s ret=##class(web.DHCST.INStkTkItmWd).Update(instw,insti,data)
 . i ret<0 tro  s ret=-2  q
 . tc
 q:ret<0 ret
 q 0
}

/// 根据帐盘记录生成实盘数据列表（实盘方式四按货位）
/// Author:wyx
/// Date:2013-11-22
/// Argu:
///   inst - 盘点主表rowid
/// Return:
///   0 - scucess
///   <0 - failure
///   yunhaibao,21051211,修改为单条事务
ClassMethod CreateStkTkItmStkBinWd(inst As %String, user As %String, window As %String) As %String
{
 n (inst,user,window)
 q:inst="" -1
 s ret=0
 s i=0
 s ch=0
 s delret=0 
 ts
 s $ZT="Error^DHCSTERROR"
 s checkflag=..CheckExist(inst,window)
 if checkflag'=0 d 
 .s delret=##class(web.DHCST.INStkTk).DeleteInstwd(inst,window)
 i delret<0 tro  s ret=-3
 q:ret=-3 ret
 tc
 f  s ch=$o(^DHCINST(inst,"STI",ch)) q:(+ch=0)!(ret<0)  d
 . s insti=inst_"||"_ch
 . s wuom=+$p(^DHCINST(inst,"STI",ch),"^",17)
 . s qty=$p(^DHCINST(inst,"STI",ch),"^",2)
 . s inclb=$p(^DHCINST(inst,"STI",ch),"^",1)
 . s inci=+inclb
 . s buom=$P(^INCI(inci,1),"^",10)
 . s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(wuom,buom)
 . s countQty=qty/fac
 . s bQty=""
 . s pQty=""
 . s stkbin=$p(^DHCINST(inst,"STI",ch),"^",27)
 . s data="^^"_wuom_"^^^"_stkbin_"^"_window //modify wyx 2014-12-05实盘汇总设置未填数量为帐盘数或为0时判断了user
 . s stknum=$l(stkbin,",")
 . f k=1:1:stknum d
 . .s stkbinch=$p(stkbin,",",k)
 . .s $p(data,"^",6)=stkbinch
 . .ts
 . .s ret=##class(web.DHCST.INStkTkItmWd).Update("",insti,data)
 . .i ret<0 tro  s ret=-2  
 . .q:ret<0
 . .tc
 q:ret<0 ret
 q 0
}

/// 根据帐盘记录生成实盘数据列表（实盘方式四按货位）(”录入批次“调用把事务转移到插入子表时启用)
/// Author:wyx
/// Date:2013-12-12
/// Argu:
///   inst - 盘点主表rowid
/// Return:
///   0 - scucess
///   <0 - failure
ClassMethod CreateStkTkItmStkBinWdInput(insti As %String, user As %String, window As %String, InputQty As %String) As %String
{
 n (insti,user,window,InputQty)
 q:insti="" -1
 s ret=0
 s i=0
 s ch=0
 s delret=0

 
 //s checkflag=..CheckExist(inst)
 //if checkflag'=0 d 
 //.s delret=##class(web.DHCST.INStkTk).DeleteInstwd(inst)
 //i delret<0 tro  s ret=-3  q
 s inst=$p(insti,"||",1)
 s ch=$p(insti,"||",2)
 s wuom=+$p(^DHCINST(inst,"STI",ch),"^",17)
 s qty=$p(^DHCINST(inst,"STI",ch),"^",2)
 s inclb=$p(^DHCINST(inst,"STI",ch),"^",1)
 s inci=+inclb
 s buom=$P(^INCI(inci,1),"^",10)
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(wuom,buom)
 s countQty=qty/fac
 s bQty=""
 s pQty=""
 //s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBinByIncil($p(inclb,"||",1,2))
 //s stkbin=$p(stkbin,"^",1)
 s stkbin=$p(^DHCINST(inst,"STI",ch),"^",27)
 s data=user_"^"_InputQty_"^"_wuom_"^^^"_stkbin_"^"_window
 s stknum=$l(stkbin,",")
 f k=1:1:stknum d
 .s stkbinch=$p(stkbin,",",k)
 .s $p(data,"^",6)=stkbinch
 .s ret=##class(web.DHCST.INStkTkItmWd).Update("",insti,data)
 .i ret<0 tro  s ret=-2  q
 q:ret<0 ret
 
 q 0
}

/// 设置盘点的实盘状态
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///   inst - 盘点主表rowid
///   stktkComp - 实盘完成标志
/// Return:
///   0 - scucess
///   <0 - failure
ClassMethod ChangeInputStatus(inst As %String, stktkComp As %String) As %String
{
 //当前盘点若已经调整，则退出
 q:inst="" -100
 q:##class(web.DHCST.Common.AppCommon).Lock("DHCSTINSTKTK"_inst)<0 -99
 &sql(select * into :PLIST() From dhc_instktk where %ID=:inst)
 i SQLCODE'=0 d ..uLock(inst) q -1
 ;
 s stocktakeAdj=PLIST(16)  //实盘完成(汇总)标志
 s complete=PLIST(14)  //帐盘完成标志
 i stocktakeAdj="Y" d ..uLock(inst) q -2  // 已经调整 
 i complete'="Y"  d ..uLock(inst) q -3  //未帐盘
 s ret=..CheckInputComplete(inst)
 q:ret'=1 -5							//实盘数未录入完毕
 &sql(update dhc_instktk set  inst_stocktakecomplete=:stktkComp where %ID=:inst)
 ;b ;-4
 i SQLCODE'=0  d ..uLock(inst) q -4  // 更新失败 
 d ..uLock(inst)
 q 0
}

/// 检测是否所有的记录都录入实盘数量
/// Author:zhangdongmei
/// Date:2012-09-03
/// Argu:
///   inst - 盘点主表rowid
/// Return:
///   0 - 存在未录入实盘数量记录
///   1 - 全部录入完毕
/// 	  -1-传入参数错误
ClassMethod CheckInputComplete(Inst As %String) As %String
{
	n (Inst)
	q:Inst="" -1
	s Flag=1
	s ExistFlag=0  ;实盘表中是否存在账盘明细对应的记录
	;
	s Chl=0
	f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:(Chl="")!(Flag=0)  d
	.s Sub=0
	.f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:(Sub="")!(Flag=0)  d
	..s CountQty=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2)
	..q:CountQty>0   ;已录入
	..s CountUser=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	..
	..i CountUser'>0 d   ;实盘数量不大于0且实盘人为空
	...s Flag=0
	...;b ;2
	..
	.
	q Flag
}

/// 检索实盘记录表格数据，用于填入实盘数据(json)
/// w ##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWd(0,99,"","",params)
ClassMethod jsINStkTkItmWd(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String) As %String
{
	Set $ZT="ERRORjsDHCSTInstkTkItmWd"
	k jsINStkTkItmWdDATA
	s nullStkBin=##class(web.DHCST.INStkTk).#NullStkBin
	s qPar=Sort_"^"_Dir
	s jsSort=Sort
	s inst=$P(StrPar,"^",1)
	s ManGrp=$P(StrPar,"^",2)
	s StkGrpId=$P(StrPar,"^",3)
	s StkCatId=$P(StrPar,"^",4)
	s StkBin=$P(StrPar,"^",5)
	s PhaWindowId=$P(StrPar,"^",6)
	s InciRowid=$P(StrPar,"^",7) //add wyx 增加库存项过滤
	s result=##class(%Library.ResultSet).%New("web.DHCST.INStkTkItmWd:INStkTkItmWd")
	s sc= result.Execute(qPar,inst,ManGrp,StkGrpId,StkCatId,StkBin,PhaWindowId,InciRowid)
	i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s colNum=result.GetColumnCount()
	s end = Start+Limit
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s h=0
	While(result.Next())
	{ 
		s data=""
		f i=1:1:colNum d
		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)
		s h=h+1
		s index=1  //排序
		s instw=$p(data,"^",1)
		s instwchildsub=$p(instw,"||",3)
		s instwlen=5-$l(instwchildsub)  //补零
		s instwi=""
		f instwi=1:1:instwlen d
		.s instwchildsub=0_instwchildsub 
		s instwnum=$p(instw,"||",2)_instwchildsub  //global需纯数字排序
	    s code=$p(data,"^",5)
	    s desc=$p(data,"^",6)
	    s countQty=$p(data,"^",18)
	    s stkbin=$p(data,"^",22)
	    s spamt=$p(data,"^",23)
	    s rpamt=$p(data,"^",24)
	    s freQty=$p(data,"^",11)
		s freezespamt=$p(data,"^",30)
	    s freezerpamt=$p(data,"^",31)
	    s diffQty=$p(data,"^",32)
	    s diffspamt=$p(data,"^",33)
	    s diffrpamt=$p(data,"^",34)
	    s freQtyUom=$p(data,"^",35)
	    s firststkbindesc=$p(stkbin,",",1)
	    i jsSort="rowid" s index=instwnum
	    e  i jsSort="code" s index=code
	    e  i jsSort="desc" s index=desc
	    e  i jsSort="countQty" s index=countQty
	    e  i jsSort="stkbin" d
	    .s index=firststkbindesc
	    .i index="" s index=nullStkBin
	    e  i jsSort="spamt" s index=spamt
	    e  i jsSort="rpamt" s index=rpamt
	    e  i jsSort="freQty" s index=freQty
	    e  i jsSort="freezespamt" s index=freezespamt
	    e  i jsSort="freezerpamt" s index=freezerpamt
	    e  i jsSort="diffQty" s index=diffQty
	    e  i jsSort="diffspamt" s index=diffspamt
	    e  i jsSort="diffrpamt" s index=diffrpamt
	    i index="" s index=1
	    i desc="合计" s indexcacu=0
	    e  s indexcacu=1
		s jsINStkTkItmWdDATA(indexcacu,index,instwnum)=data
	}
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	s outputi=""
	f  s outputi=$o(jsINStkTkItmWdDATA(outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(jsINStkTkItmWdDATA(outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(jsINStkTkItmWdDATA(outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s data=jsINStkTkItmWdDATA(outputi,outputj,outputk)
	...s instw=$p(data,"^",1)
	...s insti=$p(data,"^",2)
	...s inclb=$p(data,"^",3)
	...s inci=$p(inclb,"||",1)
	...s code=$p(data,"^",5)
	...s desc=$p(data,"^",6)
	...s spec=$p(data,"^",7)
	...s manf=$p(data,"^",8)
	...s batNo=$p(data,"^",9)
	...s expDate=$p(data,"^",10)
	...//add wyx 2014-02-25 修改批号效期的显示
	...s batexpid=insti
	...s batexp=batNo_"~"_expDate
	...s freQty=$p(data,"^",11)
	...s uom=$p(data,"^",12)
	...s uomDesc=$p(data,"^",13)
	...s buom=$p(data,"^",14)
	...s buomDesc=$p(data,"^",15)
	...s rp=$p(data,"^",16)
	...s sp=$p(data,"^",17)
	...s countQty=$p(data,"^",18)
	...s countDate=$p(data,"^",19)
	...s countTime=$p(data,"^",20)
	...s userName=$p(data,"^",21)
	...s stkbin=$p(data,"^",22)
	...s spamt=$p(data,"^",23)
	...s rpamt=$p(data,"^",24)
	...s puom=$p(data,"^",25)
	...s puomdesc=$p(data,"^",26)
	...s pQty=$p(data,"^",27)  //modify wyx 2014-12-04 
	...s incifac=$p(data,"^",28)
	...s bQty=$p(data,"^",29) //modify wyx 2014-12-04 
	...s incil=+inclb_"||"_$p(inclb,"||",2)
	...s freezespamt=$p(data,"^",30)
	...s freezerpamt=$p(data,"^",31)
	...s diffQty=$p(data,"^",32)
	...s diffspamt=$p(data,"^",33)
	...s diffrpamt=$p(data,"^",34)
	...s freQtyUom=$p(data,"^",35)
	...s count=count+1
	...q:count<stpage
	...q:count>endpage
	...s instw=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instw",instw)    
	...s insti=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("insti",insti)
	...s inclb=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inclb",inclb)
	...s inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inci",inci)
	...s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
	...s desc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("desc",desc)
	...s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	...s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	...s batNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batNo",batNo)
	...s expDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("expDate",expDate)
	...s batexpid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batexpid",batexpid)
	...s batexp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batexp",batexp)
	...s freQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freQty",freQty)
	...s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uom",uom)
	...s uomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomDesc",uomDesc)
	...s buom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buom",buom)
	...s buomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buomDesc",buomDesc)
	...s rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rp",rp)
	...s sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sp",sp)
	...s countQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("countQty",countQty)
	...s countDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("countDate",countDate)
	...s countTime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("countTime",countTime)
	...s userName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("userName",userName)
	...s stkbin=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("stkbin",stkbin)
	...s spamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spamt",spamt)
	...s rpamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rpamt",rpamt)
	...s puom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("puom",puom)
	...s puomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("puomdesc",puomdesc)
	...s pcountQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pcountQty",pQty) //大单位数量
	...s bcountQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("bcountQty",bQty) //基本单位数量
	...s freezespamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freezespamt",freezespamt)
	...s freezerpamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freezerpamt",freezerpamt)
	...s diffQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diffQty",diffQty)
	...s diffspamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diffspamt",diffspamt)
	...s diffrpamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diffrpamt",diffrpamt)
	...s incifac=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incifac",incifac)
	...s freQtyUom=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("freQtyUom",freQtyUom)
	...s tmpstr=instw_insti_inclb_inci_code_desc_spec_manf_batexpid_batexp_batNo_expDate_freQty_uom_uomDesc_buom_buomDesc_rp_sp_countQty_countDate_countTime_userName_stkbin_spamt_rpamt_puom_puomdesc_pcountQty_bcountQty_freezespamt_freezerpamt_diffQty_diffspamt_diffrpamt_incifac_freQtyUom
	...s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	...s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	...s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	...i count=stpage w startString
	...i count<endpage w firstrow
	...i count=endpage w lastrow
	..
	q ""
ERRORjsDHCSTInstkTkItmWd
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 检索实盘记录表格数据，用于填入实盘数据(json)
/// w ##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWdStkBin("0","30","stkbin","ASC","159^^3^19^1,1^1^^165")
/// w ##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWdStkBin("0","30","stkbin","ASC","159^^3^19^,^1^^165")
ClassMethod jsINStkTkItmWdStkBin(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String) As %String
{
	s jsSort=Sort
	s qPar=Sort_"^"_Dir
	s inst=$P(StrPar,"^",1)
	s ManGrp=$P(StrPar,"^",2)
	s StkGrpId=$P(StrPar,"^",3)
	s StkCatId=$P(StrPar,"^",4)
	s StkBin=$P(StrPar,"^",5)
	s PhaWindowId=$P(StrPar,"^",6)
	s InciRowid=$P(StrPar,"^",7) //add wyx 增加库存项过滤
	s LocId=$P(StrPar,"^",8)
	s result=##class(%Library.ResultSet).%New("web.DHCST.INStkTkItmWd:INStkTkItmWdStkBin")
	s sc= result.Execute(qPar,inst,ManGrp,StkGrpId,StkCatId,StkBin,PhaWindowId,InciRowid,LocId)
	i $$$ISERR(sc) w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:$$$ISERR(sc) ""
	s colNum=result.GetColumnCount()
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s pid=..NewPid()	
	Set $ZT="ERRORjsINStkTkItmWdStkBin"	
	s h=0
	While(result.Next())
	{ 
		s data=""
		f i=1:1:colNum d
		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)
		s h=h+1
		s rowid=$p(data,"^",1)
		s instwchildsub=$p(rowid,"||",3)
		s instwlen=5-$l(instwchildsub)  //补零
		s instwi=""
		f instwi=1:1:instwlen d
		.s instwchildsub=0_instwchildsub 
		s instwnum=$p(rowid,"||",2)_instwchildsub  //唯一
	    s code=$p(data,"^",5)
	    s desc=$p(data,"^",6)
	    s freQty=$p(data,"^",11)
	    s countQty=$p(data,"^",18)
	    s inclb=$p(data,"^",3)
	    s incil=+inclb_"||"_$p(inclb,"||",2)
	    s stkbinstr=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","")
	    s stkbin=$p(stkbinstr,":",2)
	    s firststkbindesc=$p(stkbin,",",1)
	    s $p(data,"^",22)=stkbin 
	    s spamt=$p(data,"^",23)
	    s rpamt=$p(data,"^",24)
	    s freezespamt=$p(data,"^",30)
	    s freezerpamt=$p(data,"^",31)
	    s diffQty=$p(data,"^",32)
	    s diffspamt=$p(data,"^",33)
	    s diffrpamt=$p(data,"^",34)
	    s index=1
	   	i jsSort="instw" s index=instwnum
	    e  i jsSort="code" s index=code
	    e  i jsSort="desc" s index=desc
	    e  i jsSort="countQty" s index=countQty
	    e  i jsSort="stkbin" s index=firststkbindesc
	    e  i jsSort="spamt" s index=spamt
	    e  i jsSort="rpamt" s index=rpamt
	    e  i jsSort="freQty" s index=freQty
	    e  i jsSort="freezespamt" s index=freezespamt
	    e  i jsSort="freezerpamt" s index=freezerpamt
	    e  i jsSort="diffQty" s index=diffQty
	    e  i jsSort="diffspamt" s index=diffspamt
	    e  i jsSort="diffrpamt" s index=diffrpamt
	    i index="" s index=1
	    i desc="合计" s indexcacu=0
	    e  s indexcacu=1
		s ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdStkBin",pid,indexcacu,index,instwnum)=data

	}
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdStkBin",pid,outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdStkBin",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdStkBin",pid,outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s data=^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdStkBin",pid,outputi,outputj,outputk)
	...s instw=$p(data,"^",1)
	...s insti=$p(data,"^",2)
	...s inclb=$p(data,"^",3)
	...s code=$p(data,"^",5)
	...s desc=$p(data,"^",6)
	...s spec=$p(data,"^",7)
	...s manf=$p(data,"^",8)
	...s batNo=$p(data,"^",9)
	...s expDate=$p(data,"^",10)
	...s freQty=$p(data,"^",11)
	...s uom=$p(data,"^",12)
	...s uomDesc=$p(data,"^",13)
	...s buom=$p(data,"^",14)
	...s buomDesc=$p(data,"^",15)
	...s rp=$p(data,"^",16)
	...s sp=$p(data,"^",17)
	...s countQty=$p(data,"^",18)
	...s userName=$p(data,"^",21)
	...s stkbin=$p(data,"^",22)
	...s spamt=$p(data,"^",23)
	...s rpamt=$p(data,"^",24)
	...s puom=$p(data,"^",25)
	...s puomdesc=$p(data,"^",26)
	...s pQty=$p(data,"^",27)  //modify wyx 2014-12-04 
	...s incifac=$p(data,"^",28)
	...s bQty=$p(data,"^",29) //modify wyx 2014-12-04 
	...s freezespamt=$p(data,"^",30)
	...s freezerpamt=$p(data,"^",31)
	...s diffQty=$p(data,"^",32)
	...s diffspamt=$p(data,"^",33)
	...s diffrpamt=$p(data,"^",34)
	...s freQtyUom=$p(data,"^",35)
	...s incil=+inclb_"||"_$p(inclb,"||",2)
	...s count=count+1
	...q:count<stpage
	...q:count>endpage
	...s instw=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instw",instw)    
	...s insti=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("insti",insti)
	...s inclb=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inclb",inclb)
	...s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
	...s desc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("desc",desc)
	...s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	...s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	...s batNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batNo",batNo)
	...s expDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("expDate",expDate)
	...s freQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freQty",freQty)
	...s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uom",uom)
	...s uomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomDesc",uomDesc)
	...s buom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buom",buom)
	...s buomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buomDesc",buomDesc)
	...s rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rp",rp)
	...s sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sp",sp)
	...s countQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("countQty",countQty)
	...s userName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("userName",userName)
	...s stkbin=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("stkbin",stkbin)
	...s spamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spamt",spamt)
	...s rpamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rpamt",rpamt)
	...s puom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("puom",puom)
	...s puomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("puomdesc",puomdesc)
	...s pcountQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pcountQty",pQty) //大单位数量
	...s bcountQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("bcountQty",bQty) //基本单位数量
	...s freezespamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freezespamt",freezespamt)
	...s freezerpamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freezerpamt",freezerpamt)
	...s diffQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diffQty",diffQty)
	...s diffspamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diffspamt",diffspamt)
	...s diffrpamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diffrpamt",diffrpamt)
	...s incifac=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incifac",incifac)
	...s freQtyUom=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("freQtyUom",freQtyUom)
	...s tmpstr=instw_insti_inclb_code_desc_spec_manf_batNo_expDate_freQty_uom_uomDesc_buom_buomDesc_rp_sp_countQty_userName_stkbin_spamt_rpamt_puom_puomdesc_pcountQty_bcountQty_freezespamt_freezerpamt_diffQty_diffspamt_diffrpamt_incifac_freQtyUom
	...s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	...s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	...s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	...i count=stpage w startString
	...i count<endpage w firstrow
	...i count=endpage w lastrow
    k ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdStkBin",pid) 
	q "" 
ERRORjsINStkTkItmWdStkBin
	//遇报错,则先kill TMP
	Set Method=	"##class(web.DHCST.INCItmLoc).jsINStkTkItmWdStkBin"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdStkBin",pid)    
	q $ze
}

/// 检索实盘表记录表格数据，用于填入实盘数据(json)按批次存储
/// w ##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWdPc(0,30,"","","780^^1^^^^")
ClassMethod jsINStkTkItmWdPc(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String) As %String
{
	s qPar=Sort_"^"_Dir
	s jsSort=Sort
	s inst=$P(StrPar,"^",1)
	s ManGrp=$P(StrPar,"^",2)
	s StkGrpId=$P(StrPar,"^",3)
	s StkCatId=$P(StrPar,"^",4)
	s StkBin=$P(StrPar,"^",5)
	s PhaWindowId=$P(StrPar,"^",6)
	s InciRowid=$P(StrPar,"^",7) //add wyx 增加库存项过滤
	s result=##class(%Library.ResultSet).%New("web.DHCST.INStkTkItmWd:INStkTkItmWdStkBin")
	s sc= result.Execute(qPar,inst,ManGrp,StkGrpId,StkCatId,StkBin,PhaWindowId,InciRowid,"")
	i $$$ISERR(sc) w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:$$$ISERR(sc) ""
	s colNum=result.GetColumnCount()
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s pid=..NewPid()	
	Set $ZT="ERRORjsDHCSTInstkTkItmWdPc"	
	s h=0
	While(result.Next())
	{ 
		s data=""
		f i=1:1:colNum d
		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)
		s insti=$p(data,"^",2)  //排序 insti,按子表汇总显示
	    s code=$p(data,"^",5)
	    s desc=$p(data,"^",6)
	    s freQty=$p(data,"^",11)
	    //s stkbin=$p(data,"^",22)
	    s instiCountQty=0
	    //实盘数据取的instwd表的数
	    &SQL(SELECT sum(INSTW_CountQty) into :instiCountQty FROM DHC_InStkTkItmWd WHERE INSTW_INSTI_Parref=:insti)
	    s countQty=instiCountQty
	    s diffQty=countQty-freQty
	    s inclb=$p(data,"^",3)
	    s incil=+inclb_"||"_$p(inclb,"||",2)
	    s stkbinstr=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","")
	    s stkbin=$p(stkbinstr,":",2)
	    s $p(data,"^",22)=stkbin 
	    s index="1"
	    i jsSort="insti" s index=$p(insti,"||",2)
	    e  i jsSort="code" s index=code
	    e  i jsSort="desc" s index=desc
	    e  i jsSort="stkbin" s index=stkbin
	    e  i jsSort="freQty" s index=freQty  //冻结数就是子表
	    e  i jsSort="countQty" s index=countQty
	    e  i jsSort="diffQty" s index=diffQty
	    s $p(data,"^",18)=instiCountQty
	    i index="" s index="1"
	    i desc="合计" s indexcacu="0"
	    e  s indexcacu=1
		i '$d(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdPc",pid,indexcacu,index,insti)) d  //取明细一条信息就够了
		.s h=h+1
		.s ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdPc",pid,indexcacu,index,insti)=data

	}
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdPc",pid,outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdPc",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdPc",pid,outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s data=^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdPc",pid,outputi,outputj,outputk)
	...s insti=$p(data,"^",2)
	...s inclb=$p(data,"^",3)
	...s code=$p(data,"^",5)
	...s desc=$p(data,"^",6)
	...s spec=$p(data,"^",7)
	...s manf=$p(data,"^",8)
	...s batNo=$p(data,"^",9)
	...s expDate=$p(data,"^",10)
	...s freQty=$p(data,"^",11)
	...s uom=$p(data,"^",12)
	...s uomDesc=$p(data,"^",13)
	...s buom=$p(data,"^",14)
	...s buomDesc=$p(data,"^",15)
	...s rp=$p(data,"^",16)
	...s sp=$p(data,"^",17)
	...s countQty=$p(data,"^",18)
	...s stkbin=$p(data,"^",22)
	...s diffQty=countQty-freQty
	...i desc="合计" s diffQty="-"
	...s count=count+1
	...q:count<stpage
	...q:count>endpage
	...s insti=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("insti",insti)
	...s inclb=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inclb",inclb)
	...s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
	...s desc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("desc",desc)
	...s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	...s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	...s batNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batNo",batNo)
	...s expDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("expDate",expDate)
	...s freQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freQty",freQty)
	...s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uom",uom)
	...s uomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomDesc",uomDesc)
	...s buom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buom",buom)
	...s buomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buomDesc",buomDesc)
	...s rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rp",rp)
	...s sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sp",sp)
	...s countQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("countQty",countQty)
	...s diffQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diffQty",diffQty)
	...s stkbin=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("stkbin",stkbin)
	...s tmpstr=insti_inclb_code_desc_spec_manf_batNo_expDate_freQty_uom_uomDesc_buom_buomDesc_rp_sp_countQty_diffQty_stkbin
	...s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	...s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	...s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	...i count=stpage w startString
	...i count<endpage w firstrow
	...i count=endpage w lastrow
	k ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdPc",pid) 
	q ""

ERRORjsDHCSTInstkTkItmWdPc
	//遇报错,则先kill TMP
	Set Method=	"##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWdPc"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdPc",pid)    
	q $ze
}

/// 检索实盘表记录表格数据，用于填入实盘数据(json)按药品存储
/// w ##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWdYp(0,30,Sort,Dir,params)
ClassMethod jsINStkTkItmWdYp(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String) As %String
{
	s jsSort=Sort
	s qPar=Sort_"^"_Dir
	s inst=$P(StrPar,"^",1)
	s ManGrp=$P(StrPar,"^",2)
	s StkGrpId=$P(StrPar,"^",3)
	s StkCatId=$P(StrPar,"^",4)
	s StkBin=$P(StrPar,"^",5)
	s PhaWindowId=$P(StrPar,"^",6)
	s InciRowid=$P(StrPar,"^",7) //add wyx 增加库存项过滤
	s result=##class(%Library.ResultSet).%New("web.DHCST.INStkTkItmWd:INStkTkItmWdStkBin")
	s sc= result.Execute(qPar,inst,ManGrp,StkGrpId,StkCatId,StkBin,PhaWindowId,InciRowid,"")
	i $$$ISERR(sc) w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:$$$ISERR(sc) "" 
	s colNum=result.GetColumnCount()
	i $$$ISERR(sc) q ""
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s pid=..NewPid()
	Set $ZT="ERRORjsDHCSTInstkTkItmWdYp"
	s h=0
	While(result.Next())
	{ 
		s data=""
		f i=1:1:colNum d
		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)
		s rowid=+$p(data,"^",1)
		s inci=$p(data,"^",4)
	    s code=$p(data,"^",5)
	    s desc=$p(data,"^",6)
	    continue:desc="合计"
	    s freQty=0,countQty=0  //如下有索引
	    &SQL(SELECT sum(INSTW_CountQty) into :countQty FROM DHC_InStkTkItmWd WHERE INSTW_INSTI_Parref->INSTI_INCI_DR=:inci AND INSTW_INSTI_Parref->INSTI_INST_Parref=:rowid)
	    &SQL(SELECT sum(INSTI_FreezeQty) into :freQty FROM DHC_InStkTkItm WHERE INSTI_INST_Parref=:rowid AND INSTI_INCI_DR=:inci)
	    s diffQty=countQty-freQty
	    s $p(data,"^",11)=freQty  //帐盘数
	    s $p(data,"^",18)=countQty //实盘数
	    s inclb=$p(data,"^",3)
	    s incil=inci_"||"_$p(inclb,"||",2)
	    s stkbinstr=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","")
	    s stkbin=$p(stkbinstr,":",2)
	    s $p(data,"^",22)=stkbin 
	    s index=1
	   	i jsSort="code" s index=code
	    e  i jsSort="desc" s index=desc
	    e  i jsSort="freQty" s index=freQty  //这数量都是按药品汇总的
		e  i jsSort="countQty" s index=countQty
		e  i jsSort="diffQty" s index=diffQty
		e  i jsSort="stkbin" s index=stkbin
	    i index="" s index=1
		i '$d(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdYp",pid,index,inci)) d
		.s h=h+1
		.s ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdYp",pid,index,inci)=data
	}
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdYp",pid,outputi),orderflag) q:outputi=""  d
	.s outputj="" 
	.f  s outputj=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdYp",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s data=^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdYp",pid,outputi,outputj)
	..s insti=$p(data,"^",2)
	..s inclb=$p(data,"^",3)
	..s inci=$p(data,"^",4)
	..s incil=inci_"||"_$p(inclb,"||",2)
	..s code=$p(data,"^",5)
	..s desc=$p(data,"^",6)
	..s spec=$p(data,"^",7)
	..s manf=$p(data,"^",8)
	..s batNo=$p(data,"^",9)
	..s expDate=$p(data,"^",10)
	..s freQty=$p(data,"^",11)
	..s uom=$p(data,"^",12)
	..s uomDesc=$p(data,"^",13)
	..s buom=$p(data,"^",14)
	..s buomDesc=$p(data,"^",15)
	..s rp=$p(data,"^",16)
	..s sp=$p(data,"^",17)
	..s countQty=$p(data,"^",18)
	..s diffQty=countQty-freQty
	..s stkbinstr=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","")
	..s stkbin=$p(stkbinstr,":",2)
	..s count=count+1
	..q:count<stpage
	..q:count>endpage
	..s inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inci",inci)
	..s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
	..s desc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("desc",desc)
	..s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	..s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	..s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uom",uom)
	..s uomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomDesc",uomDesc)
	..s buom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buom",buom)
	..s buomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buomDesc",buomDesc)
	..s rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rp",rp)
	..s sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sp",sp)
	..s countQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("countQty",countQty)
	..s freQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freQty",freQty)
	..s diffQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diffQty",diffQty)
	..s stkbin=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("stkbin",stkbin)
	..s tmpstr=inci_code_desc_spec_manf_uom_uomDesc_buom_buomDesc_rp_sp_countQty_freQty_diffQty_stkbin
	..s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	..s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	..s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	..i count=stpage w startString
	..i count<endpage w firstrow
	..i count=endpage w lastrow
	k ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdYp",pid) 
	q ""
 
 
 
ERRORjsDHCSTInstkTkItmWdYp
    //遇报错,则先kill TMP
    Set Method=	"##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWdYp"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdYp",pid)    
    q ""
}

/// 检索实盘记录表格数据，用于填入实盘数据(json)782^^1^^,^^^102
/// w ##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWdNoImp(0,30,"stkbin","ASC","30^^3^^,^^^320")
ClassMethod jsINStkTkItmWdNoImp(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String) As %String
{
	//s ^tmpdhy("jsINStkTkItmWdNoImp")=Start_","_Limit_","_Sort_","_Dir_","_StrPar
    s jsSort=Sort
	s qPar=Sort_"^"_Dir
	s inst=$P(StrPar,"^",1)
	s ManGrp=$P(StrPar,"^",2)
	s StkGrpId=$P(StrPar,"^",3)
	s StkCatId=$P(StrPar,"^",4)
	s StkBin=$P(StrPar,"^",5)
	s PhaWindowId=$P(StrPar,"^",6)
	s InciRowid=$P(StrPar,"^",7) //add wyx 增加库存项过滤
	s LocId=$P(StrPar,"^",8)
	s result=##class(%Library.ResultSet).%New("web.DHCST.INStkTkItmWd:INStkTkItmWdStkBin")
	s sc= result.Execute(qPar,inst,ManGrp,StkGrpId,StkCatId,StkBin,PhaWindowId,InciRowid,LocId)
	i $$$ISERR(sc) w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:$$$ISERR(sc) ""
	s colNum=result.GetColumnCount()
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s pid=..NewPid()
	Set $ZT="ERRORjsDHCSTInstkTkItmWdNoImp"
	s h=0
	While(result.Next())
	{ 
		s data=""
		f i=1:1:colNum d
		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)
		s countflag=""
		s instwd=$p(data,"^",1)
		i $l(instwd,"||")=3 d
		.s countqty=$p($g(^DHCINST(+instwd,"STI",$p(instwd,"||",2),"STW",$p(instwd,"||",3))),"^",2)
		.i countqty'="" s countflag=1
		CONTINUE:countflag'=""
		s rowid=$p(data,"^",1)
		s instwnum=$p(rowid,"||",2)_$p(rowid,"||",3)
	    s code=$p(data,"^",5)
	    s desc=$p(data,"^",6)
	    s freQty=$p(data,"^",11)
	    s stkbin=$p(data,"^",22)
		s h=h+1
		s index=1
	   	i jsSort="instw" s index=instwnum
	    e  i jsSort="code" s index=code
	    e  i jsSort="desc" s index=desc
	    e  i jsSort="stkbin" s index=stkbin
	    e  i jsSort="freQty" s index=freQty
	    i index="" s index=1
		i desc="合计" s indexcacu=0
		e  s indexcacu=1 
		s ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdNoImp",pid,indexcacu,index,h)=data

	}
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s maxrow=h
	i endpage>maxrow s endpage=maxrow    
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdNoImp",pid,outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdNoImp",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdNoImp",pid,outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s data=^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdNoImp",pid,outputi,outputj,outputk)
	...s instw=$p(data,"^",1)
	...s insti=$p(data,"^",2)
	...s inclb=$p(data,"^",3)
	...s code=$p(data,"^",5)
	...s desc=$p(data,"^",6)
	...s spec=$p(data,"^",7)
	...s manf=$p(data,"^",8)
	...s batNo=$p(data,"^",9)
	...s expDate=$p(data,"^",10)
	...s freQty=$p(data,"^",11)
	...s uom=$p(data,"^",12)
	...s uomDesc=$p(data,"^",13)
	...s buom=$p(data,"^",14)
	...s buomDesc=$p(data,"^",15)
	...s rp=$p(data,"^",16)
	...s sp=$p(data,"^",17)
	...s countQty=$p(data,"^",18)
	...s userName=$p(data,"^",21)
	...s stkbin=$p(data,"^",22)
	...s count=count+1
	...q:count<stpage
	...q:count>endpage
	...s instw=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instw",instw)    
	...s insti=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("insti",insti)
	...s inclb=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inclb",inclb)
	...s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
	...s desc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("desc",desc)
	...s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	...s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	...s batNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batNo",batNo)
	...s expDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("expDate",expDate)
	...s freQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freQty",freQty)
	...s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uom",uom)
	...s uomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomDesc",uomDesc)
	...s buom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buom",buom)
	...s buomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buomDesc",buomDesc)
	...s rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rp",rp)
	...s sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sp",sp)
	...s countQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("countQty",countQty)
	...s userName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("userName",userName)
	...s stkbin=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("stkbin",stkbin)
	...s tmpstr=instw_insti_inclb_code_desc_spec_manf_batNo_expDate_freQty_uom_uomDesc_buom_buomDesc_rp_sp_countQty_userName_stkbin
	...s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	...s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	...s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	...i count=stpage w startString
	...i count<endpage w firstrow
	...i count=endpage w lastrow
	k ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdNoImp",pid) 
	q ""
ERRORjsDHCSTInstkTkItmWdNoImp
	//遇报错,则先kill TMP
	Set Method=	"##class(web.DHCST.INStkTkItmWd).jsINStkTkItmWdNoImp"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","INStkTkItmWd","jsINStkTkItmWdNoImp",pid)    
	q $ze
}

/// 检索帐盘表记录表格数据，用于填入实盘数据
/// Author:zhwh
/// Date:2012-08-10
/// Argu:
///   qPar  -查询参数(排序列^排序方向)
///   inst -
///   ManGrp -
/// Return:
///  instw - 实盘记录rowid, inclb-批次rowid,inci-库存项目rowid,code-代码,desc-名称,spec-规格,manf-厂家,
///  batNo-批号,expDate-效期,freQty-帐盘数,uom-盘点单位rowid,uomDesc-单位名称,
///  buom-基本单位rowid,buomDesc-基本单位名称,rp-进价,sp-售价,countQty-实盘数量,
///  countDate-实盘日期,countTime-实盘时间,userName-盘点人
Query INStkTkItmWd(qPar As %String, inst As %String, ManGrp As %String, StkGrpId As %String, StkCatId As %String, StkBin As %String, PhaWindowId As %String, InciRowid As %String) As %Query(ROWSPEC = "instw:%String,insti:%String,inclb:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,batNo:%String,expDate:%String,freQty:%String,uom:%String,uomDesc:%String,buom:%String,buomDesc:%String,rp:%String,sp:%String,countQty:%String,countDate:%String,countTime:%String,userName:%String,stkbin:%String,spamt:%String,rpamt:%String,puom:%String,puomdesc:%String,pQty:%String,incifac:%String,bQty:%String,freezespamt,freezerpamt,diffQty,diffspamt,diffrpamt,freQtyUom")
{
}

ClassMethod INStkTkItmWdExecute(ByRef qHandle As %Binary, qPar As %String, inst As %String, ManGrp As %String, StkGrpId As %String, StkCatId As %String, StkBin As %String, PhaWindowId As %String, InciRowid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
  s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 s Loc=$p(^DHCINST(inst),"^",5)
 s HospID=$p(^CTLOC(Loc),"^",22)
 s spamttotal=0,rpamttotal=0,freezespamttotal=0,freezerpamttotal=0
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="STKBIN" orderFieldName="sbDesc"
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="descx"
 s:Sort="CAT" orderFieldName="cat"

  s sql="select %ID instw,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr inclb,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref inci,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_code code,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_desc descx,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incib_dr->incib_no batNo,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incib_dr->incib_expdate expDate,"
  s sql=sql_"instw_ctuom_dr uom,"
  s sql=sql_"instw_ctuom_dr->ctuom_desc uomDesc,"
  s sql=sql_"instw_countqty countQty,"
  s sql=sql_"INSTW_QtyBuom bQty,"
  s sql=sql_"INSTW_QtyPuom pQty,"
  s sql=sql_"instw_countDate countDate,"
  s sql=sql_"instw_counttime countTime,"
  s sql=sql_"instw_stkbindesc sbDesc,"
  s sql=sql_"instw_countperson_dr->ssusr_name userName,"
  s sql=sql_"instw_insti_parref->insti_freezeqty freQty,"
  s sql=sql_"instw_insti_parref->insti_sp sp,"
  s sql=sql_"instw_insti_parref->insti_rp rp,"
  s sql=sql_"instw_insti_parref->insti_inci_dr->inci_ctuom_dr buom,"
  s sql=sql_"instw_insti_parref->insti_inci_dr->inci_ctuom_dr->ctuom_desc buomDesc,"
  s sql=sql_"instw_insti_parref->insti_inci_dr->inci_incsc_dr->incsc_desc cat,"
  s sql=sql_"INSTW_PHW_DR PhaWin,instw_insti_parref insti "
  s sql=sql_" from dhc_instktkitmwd"
  s sql=sql_" where instw_insti_parref->insti_inst_parref="_inst
 
  i orderFieldName'="" d
  .s sql=sql_" Order by "_orderFieldName_" "_Dir 
  s xrs=##class(%ResultSet).%New()
  d xrs.Prepare(sql)
  s sc=xrs.Execute(inst)
  i $$$ISERR(sc) q $$$OK
  
  while (xrs.Next())
  {
	 s ret=0
	 s inclb=xrs.Data("inclb")
	 s inci=xrs.Data("inci")
	 continue:(InciRowid'="")&(inci'=InciRowid)
	 ;管理组过滤
	 i ManGrp'="" d
	 .s mangrp=##class(web.DHCST.Common.DrugStkCommon).ManGrpByIncil($p(inclb,"||",1,2))
	 .i ManGrp'=mangrp s ret=-1
	 continue:ret<0
	 ;类组过滤
	 s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	 s GrpId=$p(StkGrpInfo,"^",5)
	 continue:(StkGrpId'="")&(GrpId'=StkGrpId)
	 s Incsc=$p(^INCI(inci,2),"^",2)
	 continue:(StkCatId'="")&(Incsc'=StkCatId)
	 s incil=$p(inclb,"||",1,2)
	 //s Incsb=$p(##class(web.DHCST.Common.DrugStkCommon).GetStkBinByIncil(incil),"^",2)
	 //wyx 2014-02-24 修改为最新的取货位方法
	  //取新科室货位表过滤货位 add wyx 2013-11-21 //改为取新的科室货位表DHCIncItmLocBin（可多货位）
    s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    s Incsb=$p(stkbinret,":",2)
    s StkBinTmp=""
    i StkBin'="" s StkBinTmp=$p(^INC("SB",StkBin),"^",2)
	 continue:(StkBinTmp'="")&(Incsb'[StkBinTmp)
	 s phaWin=xrs.Data("PhaWin")
	 continue:phaWin'=PhaWindowId	;对于实盘窗口为空的,也要过滤
	 ;continue:(PhaWindowId'="")&(phaWin'=PhaWindowId)
	 s instw=xrs.Data("instw")
	 s insti=xrs.Data("insti")	 
	 s code=xrs.Data("code")
	 s desc=xrs.Data("descx")
	 s uom=xrs.Data("uom")
	 s uomDesc=xrs.Data("uomDesc")
	 s freQty=xrs.Data("freQty")
	 s freQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(inci,freQty)
	 s batNo=xrs.Data("batNo")
	 s expDate=xrs.Data("expDate")
	 s:expDate'="" expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
	 s countQty=xrs.Data("countQty")
	 s countDate=xrs.Data("countDate")
	 i countDate'="" s countDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(countDate,"ST")
	 s countTime=xrs.Data("countTime")
	 i countTime'="" s countTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(countTime,"ST")
	 s bQty=xrs.Data("bQty") //基本单位数量 add wyx 2014-12-04
	 s pQty=xrs.Data("pQty") //大单位数量 add wyx 2014-12-04
	 //s stkbin=xrs.Data("sbDesc")
     s stkbin=Incsb
	 s userName=xrs.Data("userName")
	 s sp=xrs.Data("sp")
	 s rp=xrs.Data("rp")
	 s buom=xrs.Data("buom")
	 s buomDesc=xrs.Data("buomDesc")
     s cat=xrs.Data("cat")
	 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	 s manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
	 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)  //实盘后台按基本单位存,该算法没用
	 s tmpdiffQty=countQty-freQty  //差异数量
	 s diffQty=tmpdiffQty/fac
	 s tmpfreQty=freQty
	 s tmpcountQty=countQty
	 s freQty=freQty/fac
	 s countQty=countQty/fac //add wyx 2014-01-15 wd表实盘数存入基本单位数量转化为与帐盘数相同
	 s rp=+rp*fac
	 s sp=+sp*fac
	 //s spamt=sp*(+countQty)
     //s rpamt=rp*(+countQty)
     //s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospID)
 	 //s rpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamt,HospID)
 	 s rpamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, +countQty, uom, HospID)
 	 s spamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, +countQty, uom, HospID)	
 	 
     //s freezerpamt=rp*(+freQty)
     //s freezespamt=sp*(+freQty)
     //s freezespamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(freezespamt,HospID)
 	 //s freezerpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(freezerpamt,HospID)	
 	 s freezerpamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, +freQty, uom, HospID)
 	 s freezespamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, +freQty, uom, HospID)	
 	 
     s diffspamt=spamt-freezespamt
     s diffrpamt=rpamt-freezerpamt
	 s adjQty=countQty-freQty
	 s spamttotal=spamttotal+spamt
	 s rpamttotal=rpamttotal+rpamt
	 s freezespamttotal=freezespamttotal+freezespamt
	 s freezerpamttotal=freezerpamttotal+freezerpamt
	 ;------入库单位的实数
	 s puom=$p(^INCI(inci,3),"^",6)
	 s puomdesc=$p(^CT("UOM",puom),"^",2)
	 s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	 s incifac=fac2/fac
	 d OutPutRow
  }
	s (instw,insti,inclb,inci,code,desc,spec,manf,batNo,expDate,freQty,uom,uomDesc,buom,buomDesc,rp,sp,countQty,countDate,countTime,userName,stkbin,spamt,rpamt,puom,puomdesc,pQty,incifac,bQty,freezespamt,freezerpamt,diffQty,diffspamt,diffrpamt,freQtyUom)="-"
	s desc="合计"
	s spamt=spamttotal
	s rpamt=rpamttotal
	s freezespamt=freezespamttotal
	s freezerpamt=freezerpamttotal
	s diffspamt=spamttotal-freezespamttotal
	s diffrpamt=rpamttotal-freezerpamttotal
	d OutPutRow
	
 Quit $$$OK
OutPutRow
 s Data=$lb(instw,insti,inclb,inci,code,desc,spec,manf,batNo,expDate,freQty,uom,uomDesc,buom,buomDesc,rp,sp,countQty,countDate,countTime,userName,stkbin,spamt,rpamt,puom,puomdesc,pQty,incifac,bQty,freezespamt,freezerpamt,diffQty,diffspamt,diffrpamt,freQtyUom)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod INStkTkItmWdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = INStkTkItmWdExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod INStkTkItmWdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = INStkTkItmWdExecute ]
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

/// 检索帐盘表记录表格数据，用于填入实盘数据(方式四查询)
/// Author:zhwh
/// Date:2012-08-10
/// Argu:
///   qPar  -查询参数(排序列^排序方向)
///   inst -
///   ManGrp -
/// Return:
///  instw - 实盘记录rowid, inclb-批次rowid,inci-库存项目rowid,code-代码,desc-名称,spec-规格,manf-厂家,
///  batNo-批号,expDate-效期,freQty-帐盘数,uom-盘点单位rowid,uomDesc-单位名称,
///  buom-基本单位rowid,buomDesc-基本单位名称,rp-进价,sp-售价,countQty-实盘数量,
///  countDate-实盘日期,countTime-实盘时间,userName-盘点人
Query INStkTkItmWdStkBin(qPar As %String, inst As %String, ManGrp As %String, StkGrpId As %String, StkCatId As %String, StkBin As %String, PhaWindowId As %String, InciRowid As %String, LocId As %String) As %Query(ROWSPEC = "instw:%String,insti:%String,inclb:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,batNo:%String,expDate:%String,freQty:%String,uom:%String,uomDesc:%String,buom:%String,buomDesc:%String,rp:%String,sp:%String,countQty:%String,countDate:%String,countTime:%String,userName:%String,stkbin:%String,spamt:%String,rpamt:%String,puom:%String,puomdesc:%String,pQty:%String,incifac:%String,bQty:%String,freezespamt As %String,freezerpamt As %String,diffQty As %String,diffspamt As %String,diffrpamt As %String,freQtyUom")
{
}

ClassMethod INStkTkItmWdStkBinExecute(ByRef qHandle As %Binary, qPar As %String, inst As %String, ManGrp As %String, StkGrpId As %String, StkCatId As %String, StkBin As %String, PhaWindowId As %String, InciRowid As %String, LocId As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 s Loc=$p(^DHCINST(inst),"^",5)
 s HospID=$p(^CTLOC(Loc),"^",22)
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
  s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 s spamttotal=0,rpamttotal=0,freezespamttotal=0,freezerpamttotal=0
 s pFrStkBin=$p(StkBin,",",1)
 s pToStkBin=$p(StkBin,",",2)
 s sbDescStr=""
 i pFrStkBin'="",pToStkBin'="" d
 .s sbDescStr=##class(web.DHCST.INStkTk).GetStkBinScope(LocId,pFrStkBin,pToStkBin)  // 实盘四查询货位
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="STKBIN" orderFieldName="sbDesc"
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="descx"
 s:Sort="CAT" orderFieldName="cat"

  s sql="select %ID instw,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr inclb,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref inci,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_code code,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_desc descx,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incib_dr->incib_no batNo,"
  s sql=sql_"instw_insti_parref->insti_inclb_dr->inclb_incib_dr->incib_expdate expDate,"
  s sql=sql_"instw_ctuom_dr uom,"
  s sql=sql_"instw_ctuom_dr->ctuom_desc uomDesc,"
  s sql=sql_"instw_countqty countQty,"
  s sql=sql_"INSTW_QtyBuom bQty,"
  s sql=sql_"INSTW_QtyPuom pQty,"
  s sql=sql_"instw_countDate countDate,"
  s sql=sql_"instw_counttime countTime,"
  s sql=sql_"instw_stkbindesc sbDesc,"
  s sql=sql_"instw_countperson_dr->ssusr_name userName,"
  s sql=sql_"instw_insti_parref->insti_freezeqty freQty,"
  s sql=sql_"instw_insti_parref->insti_sp sp,"
  s sql=sql_"instw_insti_parref->insti_rp rp,"
  s sql=sql_"instw_insti_parref->insti_inci_dr->inci_ctuom_dr buom,"
  s sql=sql_"instw_insti_parref->insti_inci_dr->inci_ctuom_dr->ctuom_desc buomDesc,"
  s sql=sql_"instw_insti_parref->insti_inci_dr->inci_incsc_dr->incsc_desc cat,"
  s sql=sql_"INSTW_PHW_DR PhaWin,instw_insti_parref insti "
  s sql=sql_" from dhc_instktkitmwd"
  s sql=sql_" where instw_insti_parref->insti_inst_parref="_inst
 
  i orderFieldName'="" d
  .s sql=sql_" Order by "_orderFieldName_" "_Dir
  s xrs=##class(%ResultSet).%New()
  d xrs.Prepare(sql)
  s sc=xrs.Execute(inst)
  i $$$ISERR(sc) q $$$OK
  
  while (xrs.Next())
  {
	 s ret=0
	 s inclb=xrs.Data("inclb")
	 s inci=xrs.Data("inci")
	 continue:(InciRowid'="")&(inci'=InciRowid)
	 ;管理组过滤
	 i ManGrp'="" d
	 .s mangrp=##class(web.DHCST.Common.DrugStkCommon).ManGrpByIncil($p(inclb,"||",1,2))
	 .i ManGrp'=mangrp s ret=-1
	 continue:ret<0
	 ;类组过滤
	 s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	 s GrpId=$p(StkGrpInfo,"^",5)
	 continue:(StkGrpId'="")&(GrpId'=StkGrpId)
	 s Incsc=$p(^INCI(inci,2),"^",2)
	 continue:(StkCatId'="")&(Incsc'=StkCatId)
	 s incil=$p(inclb,"||",1,2)
	 s stkbin=$p(##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","",""),":",2)
	 //i stkbin="" s stkbin="空"  //过滤货位
	 //continue:(sbDescStr'="")&(sbDescStr '[("^"_stkbin_"^"))
	 continue:(sbDescStr'="")&&(##class(web.DHCST.INStkTkItmWd).CheckStkBinStrIfWith(sbDescStr,stkbin)'="Y")
	 //continue:(StkBin'="")&(stkbin'=StkBin)
	 s phaWin=xrs.Data("PhaWin")
	 continue:phaWin'=PhaWindowId	;对于实盘窗口为空的,也要过滤
	 ;continue:(PhaWindowId'="")&(phaWin'=PhaWindowId)
	 s instw=xrs.Data("instw")
	 s insti=xrs.Data("insti")	 
	 s code=xrs.Data("code")
	
	 
	 s desc=xrs.Data("descx")
	 s uom=xrs.Data("uom")
	 s uomDesc=xrs.Data("uomDesc")
	 s freQty=xrs.Data("freQty")
	 s freQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(inci,freQty)
	 s batNo=xrs.Data("batNo")
	 s expDate=xrs.Data("expDate")
	 s:expDate'="" expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
	 s countQty=xrs.Data("countQty")
	 s countDate=xrs.Data("countDate")
	 i countDate'="" s countDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(countDate,"ST")
	 s countTime=xrs.Data("countTime")
	 i countTime'="" s countTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(countTime,"ST")
	 s bQty=xrs.Data("bQty") //基本单位数量 add wyx 2014-12-04
	 s pQty=xrs.Data("pQty") //大单位数量 add wyx 2014-12-04
	 
	 s userName=xrs.Data("userName")
	 s sp=xrs.Data("sp")
	 s rp=xrs.Data("rp")
	 s buom=xrs.Data("buom")
	 s buomDesc=xrs.Data("buomDesc")
     s cat=xrs.Data("cat")
	 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	 s manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
	 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)	 
	 s tmpfreQty=freQty
	 s tmpcountQty=countQty
	 s tmpdiffQty=tmpcountQty-tmpfreQty 
	 s freQty=freQty/fac
	 s countQty=countQty/fac //add wyx 2014-01-15 wd表实盘数存入基本单位数量转化为与帐盘数相同
	 s rp=+rp*fac
	 s sp=+sp*fac
	 s diffQty=tmpdiffQty/fac	 
	 //s spamt=sp*(+countQty)
     //s rpamt=rp*(+countQty)
     //s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospID)
 	 //s rpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamt,HospID)	
 	 s rpamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, +countQty, uom, HospID)
 	 s spamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, +countQty, uom, HospID)

	 s spamttotal=spamttotal+spamt
	 s rpamttotal=rpamttotal+rpamt
	 ;------入库单位的实数
	 s puom=$p(^INCI(inci,3),"^",6)
	 s puomdesc=$p(^CT("UOM",puom),"^",2)
	 s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	 //s pcountQty=tmpcountQty/fac2
	 s incifac=fac2/fac
	 //s freezerpamt=+rp*(+freQty)
     //s freezespamt=+sp*(+freQty)
     //s freezespamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(freezespamt,HospID)
 	 //s freezerpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(freezerpamt,HospID)	
 	 s freezerpamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, +freQty, uom, HospID)
 	 s freezespamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, +freQty, uom, HospID)
 	 
     s diffspamt=spamt-freezespamt
     s diffrpamt=rpamt-freezerpamt
	 s freezespamttotal=freezespamttotal+freezespamt
	 s freezerpamttotal=freezerpamttotal+freezerpamt 
	 d OutPutRowStkBin
  }
 	s (instw,insti,inclb,inci,code,desc,spec,manf,batNo,expDate,freQty,uom,uomDesc,buom,buomDesc,rp,sp,countQty,countDate,countTime,userName,stkbin,spamt,rpamt,puom,puomdesc,pQty,incifac,bQty,freezespamt,freezerpamt,diffQty,diffspamt,diffrpamt,freQtyUom)="-"
	s desc="合计"
	s spamt=spamttotal
	s rpamt=rpamttotal
	s freezespamt=freezespamttotal
	s freezerpamt=freezerpamttotal
	s diffspamt=spamt-freezespamt
	s diffrpamt=rpamt-freezerpamt
	d OutPutRow

 Quit $$$OK
OutPutRowStkBin
 s Data=$lb(instw,insti,inclb,inci,code,desc,spec,manf,batNo,expDate,freQty,uom,uomDesc,buom,buomDesc,rp,sp,countQty,countDate,countTime,userName,stkbin,spamt,rpamt,puom,puomdesc,pQty,incifac,bQty,freezespamt,freezerpamt,diffQty,diffspamt,diffrpamt,freQtyUom)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod INStkTkItmWdStkBinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = INStkTkItmWdStkBinExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod INStkTkItmWdStkBinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = INStkTkItmWdStkBinExecute ]
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

/// 汇总实盘数据(按批次)
/// Author:zhangdongmei
/// Date:2012-09-11
/// Argu:
/// 帐盘表id
ClassMethod Collect(Inst) As %String
{
	n (Inst)
	q:Inst="" ""
	s Pid=..NewPid()
	k ^TMPDHCST("InStkTk",Pid)
	s Loc=$p(^DHCINST(Inst),"^",5)
 	s HospID=$p(^CTLOC(Loc),"^",22)
	;
	s Count=0
	s Chl=0
	f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:Chl=""  d
	.s Inci=$p(^DHCINST(Inst,"STI",Chl),"^",18)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)	;itm账盘数量
	.s Sub=0
	.s CountQtyBUom=""
	.f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:Sub=""  d
	..s CountQty=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2) //(基本单位数量和)  
	..s CountUser=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)  
	..s CountUom=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",1) //(对于方式二来说此单位是录入单位，方式一、四为基本单位)
	..s CountDate=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",4)
	..s:CountDate'="" CountDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CountDate,"ST")
	..s CountTime=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",5)
	..s:CountTime'="" CountTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CountTime,"ST")
	..i CountQtyBUom="" s CountQtyBUom=CountQty   
	..e  s CountQtyBUom=CountQtyBUom+CountQty
	.s Rowid=Inst_"||"_Chl
	.//i CountQtyBUom="" s CountQtyBUom=FreQty //兼容方式2，wd没有录入的显示为itm表的数量
	.i CountQtyBUom="" s CountQtyBUom=0 //yunhaibao20170720,和上边哪种方式适合看情况
	.s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	.s Rp=$p(^DHCINST(Inst,"STI",Chl),"^",30) //yunhaibao20170711
	.s FreRpAmt=Rp*FreQty
	.s CountRpAmt=CountQtyBUom*Rp
	.s FreRpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(FreRpAmt,HospID)
	.s CountRpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(CountRpAmt,HospID)
	.s Data=CountQtyBUom_"^"_Rowid_"^"_FreRpAmt_"^"_CountRpAmt
	./// 按品种汇总实盘数量
	.i '$d(^TMPDHCST("InStkTk",Pid,Inci))  d
	..s ^TMPDHCST("InStkTk",Pid,Inci)=Data
	.e  d
	..s $p(^TMPDHCST("InStkTk",Pid,Inci),"^",1)=CountQtyBUom+$p(^TMPDHCST("InStkTk",Pid,Inci),"^",1)
	..s $p(^TMPDHCST("InStkTk",Pid,Inci),"^",2)=Rowid_","_$p(^TMPDHCST("InStkTk",Pid,Inci),"^",2)
	..s $p(^TMPDHCST("InStkTk",Pid,Inci),"^",3)=FreRpAmt+$p(^TMPDHCST("InStkTk",Pid,Inci),"^",3)
	..s $p(^TMPDHCST("InStkTk",Pid,Inci),"^",4)=CountRpAmt+$p(^TMPDHCST("InStkTk",Pid,Inci),"^",4)
	q Pid
}

/// 汇总实盘数据(按品种)--根据dhc_instktkinput汇总
/// Author:wangjiabin
/// Date:2013-09-25
/// Argu:
/// 帐盘表id
ClassMethod CollectInput(Inst) As %String
{
	n (Inst)
	q:Inst="" ""
	s Pid=..NewPid()
	k ^TMPDHCST("InStkTk",Pid)
	;
	s Count=0
	s Chl=0
	f  s Chl=$o(^DHCINST(Inst,"STP",Chl)) q:Chl=""  d
	.s Inci=$p(^(Chl),"^",1)
	.s CountQty=+$p(^(Chl),"^",2)
	.s CountUom=$p(^(Chl),"^",3)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Rowid=Inst_"||"_Chl
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(CountUom,BUomId)
	.s CountQtyBUom=CountQty*Fac    //按基本单位数量汇总
	.s InstRpAmtStr=..CacuInputAmt(Inst,Inci,CountQtyBUom)
	.s FreRpAmt=$p(InstRpAmtStr,"^",1)
	.s CountRpAmt=$p(InstRpAmtStr,"^",2)
	.s Data=CountQtyBUom_"^"_Rowid_"^"_FreRpAmt_"^"_CountRpAmt
	.;按品种汇总实盘数量
	.i '$d(^TMPDHCST("InStkTk",Pid,Inci))  d
	..s ^TMPDHCST("InStkTk",Pid,Inci)=Data
	.e  d
	..s $p(^TMPDHCST("InStkTk",Pid,Inci),"^",1)=CountQtyBUom+$p(^TMPDHCST("InStkTk",Pid,Inci),"^",1)
	..s $p(^TMPDHCST("InStkTk",Pid,Inci),"^",2)=Rowid_","_$p(^TMPDHCST("InStkTk",Pid,Inci),"^",2)
	..s $p(^TMPDHCST("InStkTk",Pid,Inci),"^",3)=FreRpAmt+$p(^TMPDHCST("InStkTk",Pid,Inci),"^",3)
	..s $p(^TMPDHCST("InStkTk",Pid,Inci),"^",4)=CountRpAmt+$p(^TMPDHCST("InStkTk",Pid,Inci),"^",4)
	q Pid
}

/// 汇总实盘数据
/// Author:zhangdongmei
/// Date:2012-09-11
/// Argu:
/// 开始记录行，一页显示记录数,排序字段，排序方向，帐盘表id
/// w ##class(web.DHCST.INStkTkItmWd).CollectItmCountQty("0","30","Rowid","ASC","19")
ClassMethod CollectItmCountQty(Start As %String, Limit As %String, Sort As %String, Dir As %String, Inst) As %String
{
	n (Start,Limit,Sort,Dir,Inst)
	k CollectItmCountQtyDATA
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	s inputType=##class(web.DHCST.INStkTk).CheckItmWd(Inst)
	i inputType=2 d
	.s Pid=..CollectInput(Inst)
	i inputType=1 d
	.s Pid=..Collect(Inst)
	i $g(Pid)="" w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:$g(Pid)="" ""
	s $zt="ErrorCollectItmCountQty"
	s End=Start+Limit
	s Start=Start+1
	s CountRecords=0
	s Inci=""
	f  s Inci=$o(^TMPDHCST("InStkTk",Pid,Inci)) q:Inci=""  d
	.s Data=^TMPDHCST("InStkTk",Pid,Inci)
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	.s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	.s CountQty=$p(Data,"^",1)
	.s Rowid=$p(Data,"^",2)  // 按第一个rowId或最后一个都可以
	.s FreezeRpAmt=$p(Data,"^",3)
	.s CountRpAmt=$p(Data,"^",4)
	.s FreezeQty=..GetItmFreezeQty(Inst,Inci)
	.s CountQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,CountQty)
	.s FreezeQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,FreezeQty)
	.s CountRecords=CountRecords+1
	.s Index=1
	.i Sort="InciCode" s Index=InciCode
	.e  i Sort="InciDesc" s Index=InciDesc
	.e  i Sort="FreezeQty" s Index=FreezeQty
	.e  i Sort="CountQty" s Index=CountQty
	.e  i Sort="Rowid" d
	..s firstRowId=$p(Rowid,",",1)
	..s Index=$j(+firstRowId,6)_"||"_$j($p(firstRowId,"||",2),6)
	.i Index="" s Index="1"
	.s Data=Rowid_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_spec_"^"_PurUomDesc_"^"_FreezeQtyUom_"^"_CountQtyUom_"^"_FreezeQty_"^"_CountQty_"^"_FreezeRpAmt_"^"_CountRpAmt
	.s CollectItmCountQtyDATA(Index,CountRecords)=Data
	i CountRecords=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:CountRecords=0 ""
	i End>CountRecords s End=CountRecords
	s Title="Rowid^Inci^InciCode^InciDesc^Spec^PurUomDesc^FreezeQty^CountQty^FreezeBQty^CountBQty^FreezeRpAmt^CountRpAmt"
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s Count=0
	s outputi=""
	f  s outputi=$o(CollectItmCountQtyDATA(outputi),orderflag) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(CollectItmCountQtyDATA(outputi,outputj),orderflag) q:outputj=""  d
	..s Count = Count+1
	..q:Count<Start
	..q:Count>End
	..s outputdata=CollectItmCountQtyDATA(outputi,outputj)
	..i Count=Start d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(CountRecords)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w ","_retstring
	w "]}"
	k ^TMPDHCST("InStkTk",Pid)
	q ""
ErrorCollectItmCountQty
	i $d(pid) k ^TMPDHCST("InStkTk",Pid)
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 计算某药品的帐盘数量
/// Author:zhangdongmei
/// Date:2012-09-12
/// Argu:
/// 帐盘表id,库存项id
ClassMethod GetItmFreezeQty(Inst As %String, Inci As %String) As %String
{
	n (Inst,Inci)
	q:Inst="" 0
	q:Inci="" 0
	;
	s Qty=0
	s Chl=""
	f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	.s FreezeQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	.s Qty=Qty+FreezeQty
	q Qty
}

/// 查询某药品的实盘明细(按帐盘批次汇总)
/// Author:zhangdongmei
/// Date:2012-09-12
/// Argu:
/// 帐盘表id,库存项id
ClassMethod QueryItmTkWd(Inst As %String, Inci As %String) As %String
{
	n (Inst,Inci)
	q:Inst="" ""
	q:Inci="" ""
	s Pid=..NewPid()
	s inputType=##class(web.DHCST.INStkTk).CheckItmWd(Inst)
	k ^TMPDHCST("InStkTkItm",Pid)
	s json=##class(Code.JsonObj).%New()
	s Count=0
	i inputType=1 d
	.s Chl=0
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	..s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	..s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	..s:FreUom'="" FreUomDesc=$p(^CT("UOM",FreUom),"^",2)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	..s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(FreUom,BUomId)
	..s FreQty=FreQty/Fac
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
	..s Insti=Inst_"||"_Chl
	..s Sub=0
	..f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:Sub=""  d
	...s CountQty=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2)
	...s CountUser=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	...s CountUom=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",1)
	...s CountDate=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",4)
	...s CountTime=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",5)
	...s Rowid=Inst_"||"_Chl_"||"_Sub
	...s FacCountUom=##class(web.DHCST.Common.UtilCommon).UOMFac(CountUom,BUomId)
	...//s CountQtyUom=CountQty*FacCountUom/Fac
	...
	...//s CountQty=CountQty/FacCountUom
	...s CountQtyUom=CountQty //add wyx 2014-01-15 实盘数量已改为存基本单位数量，此处不用再转化
	...;按帐盘批次汇总实盘数量
	...i '$d(^TMPDHCST("InStkTkItm",Pid,Insti))  d
	....s ^TMPDHCST("InStkTkItm",Pid,Insti)=CountQtyUom
	...e  d
	....s ^TMPDHCST("InStkTkItm",Pid,Insti)=CountQtyUom+^TMPDHCST("InStkTkItm",Pid,Insti)
	...
	..//q:'$d(^TMPDHCST("InStkTkItm",Pid,Insti))
	..s Count=Count+1
	..s Data=Insti_"^"_Inclb_"^"_BatNo_"^"_ExpDate_"^"_$g(FreUomDesc)_"^"_FreQty_"^"_$g(^TMPDHCST("InStkTkItm",Pid,Insti))
	..d json.InsertRowData(Data)
	.
	.k ^TMPDHCST("InStkTkItm",Pid)
	.s ResultString=json.getJsonData("Insti^Inclb^BatNo^ExpDate^FreUomDesc^FreQty^CountQty",Count)

	i inputType=2 d
	.s ch=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,0))
	.s FreUom=$p(^DHCINST(Inst,"STI",ch),"^",17)
	.s:FreUom'="" FreUomDesc=$p(^CT("UOM",FreUom),"^",2)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(FreUom,BUomId)
	.
	.s FreQty=..GetItmFreezeQty(Inst,Inci)
	.s FreQty=FreQty/Fac
	.s CountQty=##class(web.DHCST.InStkTkInput).SumCountQty(Inst,Inci)
	.s CountQty=CountQty/Fac
	.s Data=$g(FreUomDesc)_"^"_FreQty_"^"_CountQty
	.d json.InsertRowData(Data)
	.s ResultString=json.getJsonData("FreUomDesc^FreQty^CountQty",1)
	
	k json
	q ResultString
}

/// 查询某药品的实盘明细
/// Author:zhangdongmei
/// Date:2012-09-12
/// Argu:
/// 帐盘表id,库存项id
/// w ##class(web.DHCST.INStkTkItmWd).QueryItmTkWdDetail(788,668)
ClassMethod QueryItmTkWdDetail(Inst As %String, Inci As %String) As %String
{
	n (Inst,Inci)
	q:Inst="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:Inci="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s Count=0
	s inputType=##class(web.DHCST.INStkTk).CheckItmWd(Inst)
	i inputType=1 d
	.s Title="Rowid^Inclb^BatNo^ExpDate^CountUom^CountQty^CountDate^CountTime^CountUserName"
	.s Chl=0
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	..s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	..s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	..s:FreUom'="" FreUomDesc=$p(^CT("UOM",FreUom),"^",2)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	..s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(FreUom,BUomId)
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
	..s Insti=Inst_"||"_Chl
	..s Sub=0
	..f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:Sub=""  d
	...s CountQty=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2)
	...s CountUser=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	...s:CountUser'="" CountUserName=$p(^SSU("SSUSR",CountUser),"^",2)
	...s CountUom=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",1)
	...s:CountUom'="" CountUomDesc=$p(^CT("UOM",CountUom),"^",2)
	...s CountDate=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",4)
	...s CountTime=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",5)
	...s:CountDate'="" CountDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CountDate,"ST")
	...s:CountTime'="" CountTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CountTime,"ST")
	...s Rowid=Inst_"||"_Chl_"||"_Sub
	...s FacCountUom=##class(web.DHCST.Common.UtilCommon).UOMFac(CountUom,BUomId)
	...s CountQty=CountQty/FacCountUom
	...s CountQtyUom=CountQty //add wyx 2014-01-15 实盘数量已改为存基本单位数量，此处不用再转化
	...s Count=Count+1
	...s Data=Rowid_"^"_Inclb_"^"_BatNo_"^"_ExpDate_"^"_$g(CountUomDesc)_"^"_CountQty_"^"_CountDate_"^"_CountTime_"^"_$g(CountUserName)
	...i Count=1 d
	....w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(0)
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
	....w retstring
	...e  d
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
	....w ","_retstring 
	i inputType=2 d
	.s Title="CountUom^CountQty^CountDate^CountTime^CountUserName"
	.s ch=0
	.f  s ch=$o(^DHCINST(Inst,"STP",0,Inci,ch)) q:ch=""  d
	..s tmpData=^DHCINST(Inst,"STP",ch)
	..s CountQty=$p(tmpData,"^",2)
	..s CountUom=$p(tmpData,"^",3)
	..s:CountUom'="" CountUomDesc=$p(^CT("UOM",CountUom),"^",2)
	..s CountDate=$p(tmpData,"^",4)
	..s:CountDate'="" CountDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CountDate,"ST")
	..s CountTime=$p(tmpData,"^",5)
	..s:CountTime'="" CountTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CountTime,"ST")
	..s CountUser=$p(tmpData,"^",6)
	..s:CountUser'="" CountUserName=$p(^SSU("SSUSR",CountUser),"^",2)
	..s Count=Count+1
	..s Data=$g(CountUomDesc)_"^"_CountQty_"^"_CountDate_"^"_CountTime_"^"_$g(CountUserName)
	..i Count=1 d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(0)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
	...w ","_retstring 
	i Count>0 w "]}"
	q:Count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q ""
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("INStkTkItmWd"))
}

/// 查询盘点单是否有实盘数据
/// Author:zhwh
/// Date:2013-11-25
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///   记录数据串
ClassMethod CheckExist(inst As %String, phawindow) As %String
{
 n (inst,phawindow)
 q:inst="" ""
 k PLIST
 s cnt=0
 s result=""
 i phawindow="" d
 .&sql(select * into :PLIST() from DHC_InStkTkItmWd where INSTW_INSTI_Parref->INSTI_INST_Parref=:inst and INSTW_PHW_DR IS NULL)
 e  d
 .&sql(select * into :PLIST() from DHC_InStkTkItmWd where INSTW_INSTI_Parref->INSTI_INST_Parref=:inst and INSTW_PHW_DR=:phawindow)
 q:SQLCODE cnt
 s cnt=$o(PLIST(""),-1)
 q cnt
}

/// Descript:取盘点实盘界面参数配置属性
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：实盘方式四录入
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    ;s ^zdm("GetParamProp")=GroupId_"^"_LocId_"^"_UserId
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.INStkTkItmWd).%GetParameter("AppName")
    s EntryBat=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"EntryBat",Param)

    
    s Data1=EntryBat
    //s Data2=MarginWarning_"^"_AllowInputRpAmt_"^"_PurchaserNotNull_"^"_ImpTypeNotNull_"^"_ValidateMaxSp_"^"_DefaStartDate_"^"_DefaEndDate
    q Data1
}

ClassMethod InsStTkInput(IncLocBt As %String, Qty As %String, InputUom As %String, RowidM As %String, user As %String, window As %String) As %Library.String
{
 n (IncLocBt,Qty,InputUom,RowidM,user,window)
 q:RowidM="" "-1"
 q:IncLocBt="" "-2"
 k PLIST
 s InstItmdr=""
 &sql(select INSTI_RowId into :InstItmdr from DHC_InStkTkItm where INSTI_INST_Parref=:RowidM and INSTI_INCLB_DR=:IncLocBt)
 q:SQLCODE<0 "-3"
 q:InstItmdr'="" "-4"
 s incil=+IncLocBt_"||"_$p(IncLocBt,"||",2)
 //取新科室货位表过滤货位 add wyx 2013-11-21 //改为取新的科室货位表DHCIncItmLocBin（可多货位）
 s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
 s stkbinstr=$p(stkbinret,":",2)
 ts
 s $ZT="Error^DHCSTERROR"
 s insti=##class(web.DHCST.INStkTkItm).UpdateInput("",RowidM,IncLocBt,stkbinstr)
 q:insti="" "-5"
 s pFreezeUom=$p(^DHCINST(RowidM),"^",17)
 s Inci=+IncLocBt
 s BuomId=$p(^INCI(Inci,1),"^",10)
 s PurUomId=$p(^INCI(Inci,3),"^",6)
 s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BuomId)
 i (pFreezeUom="1")&(InputUom=BuomId) s Qty=Qty/Fac        //帐盘类型为入库单位
 e  i (pFreezeUom'="1")&(InputUom=PurUomId) s Qty=Qty*Fac  //帐盘类型为基本单位
 s ret=##class(web.DHCST.INStkTkItmWd).CreateStkTkItmStkBinWdInput(insti,user,window,Qty)	
 tc  //提交
 q ret
}

/// Descript:	盘点取消汇总
/// Creater:    zhaozhiduan
/// CreateDate: 2014-07-01
/// Input:		盘点id    
ClassMethod StkCancelComplete(Inst As %String) As %Library.String
{
	q:Inst="" -1
 	q:($d(^DHCINST(Inst))=0)!($d(^DHCINST(Inst))=10) -2
 	s adjcomp=$p(^DHCINST(Inst),"^",14)
 	q:adjcomp="Y" -3
	s CompleteFlag=$p(^DHCINST(Inst),"^",13)
	q:CompleteFlag'="Y" -4
	// 判断是否部分调整
	q:..CheckStkIfApartAdj(Inst)=1 -5
	s Complete="N"
    s Err=0
    &sql(update DHC_InStkTk set inst_stocktakecomplete=:Complete where INST_RowId=:Inst)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("StkCancelComplete:DHC_InStkTk",Inst,SQLCODE_":"_%msg)
    .s Err=-5   ;操作失败
    q Err
}

/// Descript:	盘点单是否部分调整
/// Creater:    yangsj
/// CreateDate: 2019-12-18
/// Input:		盘点id  
/// Output:     1 部分调整  "" 其他
/// w ##class(web.DHCST.INStkTkItmWd).CheckStkIfApartAdj(5)
ClassMethod CheckStkIfApartAdj(Inst)
{
	q:Inst="" ""
	s flag=""
	s chl=""
	f  s chl=$o(^DHCINST(Inst,"STI",chl)) q:(chl="")||(flag=1)  d
	.s inadi=$P(^DHCINST(Inst,"STI",chl),"^",22)
 	.i (inadi'="")&&($d(^DHCINTR(0,"TypePointer","A",inadi)))  s flag=1 q
 	
 	q flag
}

/// Descript:	根据选择更新User.DHCInStkTkItmWd表
/// Creater:    wyx
/// CreateDate: 2014-12-05
/// Input:	   inputnullsel=1 未填为帐盘数其他为0
ClassMethod UpINStkTkWd(insti As %String, inputnullsel As %String, UserId) As %Library.String
{
   	
   	n (insti,inputnullsel,UserId)
	s Chl=0
	s Err=""
	s Inst=+insti
	s Chl=$p(insti,"||",2)
	//f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:Chl=""  d
	i 1=1  d  //避免破坏下方循环结构，默认套一层 2021-03-31
	.s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)	;冻结数量为基本单位
	.s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	.s Sub=0
	.f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:Sub=""  d
	..//s window=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",7)
	..//q:window'=InstwWin	;wanajiabin 2013-07-17 过滤实盘窗口
	..s CountQty=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2) //基本单位数量和
	..q:CountQty'=""	;已录入
	..;b ;2
	..s CountUser=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	..q:CountUser'=""	;已录入
	..i inputnullsel=1  d //默认为帐盘
	...s DefaultQty=FreQty
	...i DefaultQty<0 s DefaultQty=0 //wyx 增加对冻结库存为负的明细变为0
	..e  d
	...s DefaultQty=0
	..s Inci=$p(^DHCINST(Inst,"STI",Chl),"^",18)
	..s IncDesc=$p(^INCI(Inci,1),"^",2)
	..s BuomId=$p(^INCI(Inci,1),"^",10)
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(FreUom,BuomId)
	..s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BuomId)
	..s PurUomQty=DefaultQty\Fac2 //  整除 add wyx 2014-12-04
	..s BuomQty=DefaultQty#Fac2 // 余数
	..//s BuomQty=DefaultQty
	..//s PurUomQty=DefaultQty/Fac2
	..//s DefaultQty=DefaultQty/Fac1
	..s DefaultQty=DefaultQty   ///wyx modify 改为存基本单位，因为涉及汇总计算不能用大单位（当帐盘单位为入库单位时）
	..s Detail=UserId_"^"_DefaultQty_"^"_FreUom_"^"_BuomQty_"^"_PurUomQty_"^^"
	..s Rowid=Inst_"||"_Chl_"||"_Sub
	..s Parref=Inst_"||"_Chl
	..q:Rowid=""
	..s ret=..Update(Rowid,"",Detail)
    ..i +ret<=0  d
	...s Err=Err_","_IncDesc
    q:Err'="" -3_":"_Err		;部分保存失败
	q 0
}

/// creator:yunhaibao
/// createdate:20151123
/// description:盘点方式一,行信息修改后,后台计算数据更新前台,后台计算精准灵活
/// input:instwid,实盘入库单位数量,实盘基本单位数量
/// output:基本单位总数^进价合计^售价合计^数量差异(基本单位)^进价差额^售价差额
ClassMethod CacuInstwData(instwd, pqty, bqty)
{
	n (instwd,bqty,pqty)
	s inst=+instwd
	s Loc=$p(^DHCINST(inst),"^",5)
 	s HospID=$p(^CTLOC(Loc),"^",22)
	s bqty=+bqty
	s pqty=+pqty
	s retstring="^^^^^"
	q:+instwd="0" retstring
	q:$p(instwd,"||",2)="" retstring
	q:'$d(^DHCINST(+instwd,"STI",$p(instwd,"||",2))) retstring
	//s inci=+$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",1)
	s inclb = +$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",1)
	s inci = +inclb
	q:inci=0 retstring
	s buom=$p(^INCI(inci,1),"^",10)
	s puom=$p(^INCI(inci,3),"^",6)
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	s bcountqty=pqty*fac+bqty  //基本单位总数
	//s rp=+$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",30)
	//s sp=+$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",28)
	//s rpamt=rp*bcountqty  //实盘进价金额
	//s spamt=sp*bcountqty	 //实盘售价金额
	//s rpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamt,HospID)
	//s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospID)
	s rpamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, bcountqty, buom, HospID)
 	s spamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, bcountqty, buom, HospID)
	
	s freezeqty=+$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",2)
	s diffqty=bcountqty-freezeqty
	//s diffrpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt((diffqty*rp),HospID)
	//s diffspamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt((diffqty*sp),HospID)
	s diffrpamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, diffqty, buom, HospID)
 	s diffspamt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, diffqty, buom, HospID)
	
	s retstring=bcountqty_"^"_rpamt_"^"_spamt_"^"_diffqty_"^"_diffrpamt_"^"_diffspamt
	q retstring
}

/// creator:yunhaibao
/// createdate:20160229
/// description:添加批次到盘点单,并更新录入实盘的数据
/// input:盘点单id,批次id
/// output:>0存在
/// w ##class(web.DHCST.INStkTkItmWd).InsertNewInclbToInStk(860,"","533||5||4",10,10,580)
ClassMethod InsertNewInclbToInStk(Inst, InstWindow, Inclb, pqty, bqty, userid)
{
	n (Inst,InstWindow,Inclb,pqty,bqty,userid)
	q:Inclb="" -1
	q:Inst="" -2
	q:'$d(^DHCINST(Inst,"STI",0)) -3
	q:$d(^DHCINST(Inst,"STI",0,Inclb)) -4 
	s error=0
	ts
	s insti=##class(web.DHCST.INStkTkItm).Update("",Inst,Inclb,"") //插入子表
    i insti="" s error=-11
    i error<0 tro
    q:error<0 insti
    s buomid=$p(^INCI(+Inclb,1),"^",10)
    s instich=$o(^DHCINST(Inst,"STI",0,Inclb,""),-1)
    s insti=Inst_"||"_instich
    s instilist=insti_"^"_"^"_userid_"^"_""_"^"_buomid_"^"_""_"^"_InstWindow_"^"_bqty_"^"_pqty
    s instiw=##class(web.DHCST.INStkTkItmWd).Save(instilist)
    i +instiw'=0 s error=instiw
    i +error'=0 tro
    q:+error'=0 error
    tc
    q 0
}

/// creator:	 yunhaibao
/// createdate:	 20160229
/// description: 按品种录入,实盘汇总显示的进售价金额(需计算批次)
/// input:		
/// w ##class(web.DHCST.INStkTkItmWd).CacuInputAmt(32,534,1231)
ClassMethod CacuInputAmt(instId, incId, bQty)
{
	n (instId,incId,bQty)
	q:+incId=0 ""
	s Loc=$p(^DHCINST(instId),"^",5)
 	s HospID=$p(^CTLOC(Loc),"^",22)
	s lastExp="",selInsti="",tmpCountQty=bQty,inclbCountQty=0,freRpAmt=0,countRpAmt=0
	s instCh=0
	f  s instCh=$o(^DHCINST(instId,"STI1",0,"INCI",incId,instCh)) q:instCh=""  d
	.s instChData=^DHCINST(instId,"STI",instCh)
	.s freQty=$p(instChData,"^",2)
	.s inclb=$p(instChData,"^",1)
	.s expDate=$p(instChData,"^",20)
	.s rp=$p(instChData,"^",30)
	.i lastExp="" d
	..s lastExp=expDate
	..s selInsti=instId_"||"_instCh
	.e  d
	..i expDate>lastExp d
	...s lastExp=expDate
	...s selInsti=instId_"||"_instCh
	.i tmpCountQty>freQty d
	..s inclbCountQty=freQty
	..s tmpCountQty=tmpCountQty-inclbCountQty // 明细账盘数小于实盘总数
	.e  i freQty>0 d
	..s inclbCountQty=tmpCountQty
	..s tmpCountQty=0
	.e  i freQty=0 d
	..s inclbCountQty=0
	.i inclbCountQty<0 s inclbCountQty=0
	.s freRpAmt=freRpAmt+##class(web.DHCST.Common.AppCommon).FormatRpAmt((freQty*rp),HospID)
	.s countRpAmt=countRpAmt+##class(web.DHCST.Common.AppCommon).FormatRpAmt((inclbCountQty*rp),HospID)	
	i tmpCountQty>0 d
	.s rp=$p(^DHCINST(+selInsti,"STI",$p(selInsti,"||",2)),"^",30)
	.s countRpAmt=countRpAmt+##class(web.DHCST.Common.AppCommon).FormatRpAmt((tmpCountQty*rp),HospID)	
	q freRpAmt_"^"_countRpAmt
}

/// Description:判断货位段是否包含药品货位串中的一个
/// Creator:2021-01-08 yansg
/// input:sbDescStr货位段: ^01^02^03^; stkbin 药品货位：01,02
/// Output:Y/N
/// w ##class(web.DHCST.INStkTkItmWd).CheckStkBinStrIfWith("^01^02^03^","01")
ClassMethod CheckStkBinStrIfWith(sbDescStr, stkbin)
{
	s WithFlag="N"
	s len=$l(stkbin,",")
	f i=1:1:len q:WithFlag="Y"  d
	.s tmpStkbini=$P(stkbin,",",i)
	.i sbDescStr[("^"_tmpStkbini_"^") s WithFlag="Y" q
	
	q WithFlag
}

}
