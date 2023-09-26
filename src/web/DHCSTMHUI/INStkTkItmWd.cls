Import sqluser

Class web.DHCSTMHUI.INStkTkItmWd Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 批量保存实盘表记录(js调用)
/// Creator:	lxt
ClassMethod jsSave(Main As %String, ListData As %String) As %String
{
	n (Main,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,ListData)
	q RtnObj.Json()
}

/// 批量保存实盘表记录(js调用)
/// Creator:	lxt
/// Date:2012-08-31
/// Argu:
/// data - 实盘表记录数据串(记录间","分隔: 帐盘子表id^实盘表id^实盘人rowid^实盘数^实盘单位^货位^实盘窗口)
/// d ##class(web.DHCSTMHUI.INStkTkItmWd).Save("{""ScgStk"":""12"",""gUserId"":""541"",""gLocId"":""153"",""gGroupId"":""234"",""gHospId"":""2"",""LocManaGrp"":"""",""StkCatBox"":"""",""LocStkBin"":"""",""InStkTkWin"":""8"",""inst"":""82"",""InstNo"":""QXKKFWJWSMST20180801002"",""InciDesc"":""""}","[{""instw"":""82||5||2"",""insti"":""82||5"",""inclb"":""1426||1||1"",""inci"":""1426"",""code"":""W050401001"",""desc"":""阴道窥器"",""spec"":"""",""manf"":"""",""batNo"":""2016060101"",""expDate"":""2017-06- 01"",""freQty"":""2"",""uom"":""5"",""uomDesc"":""个"",""buom"":""5"",""buomDesc "":""个"",""rp"":""2"",""sp"":""2.37"",""countQty"":""4"",""countDate"":""2018-08-05"",""countTime"":""09:10:58"",""userName"":""雷亚琦"",""stkbin"":""""},{""in   stw"":""82||4||2"",""insti"":""82||4"",""inclb"":""1424||1||2"",""inci"":""1424"",""code"":""W0401000174"",""desc"":""高频电刀(双极电凝使用费)"",""spec"":"""",""manf"":""TADHHCDS-泰安东华合创大厦"",""batNo"":""2012"",""expDate"":""2020-02-02"",""freQty"":""1"",""uom"":""177"",""uomDesc"":""例"",""buom"":""177"",""buomD esc"":""例"",""rp"":""100"",""sp"":""160"",""countQty"":""2"",""countDate"":""20 18-08-05"",""countTime"":""09:10:58"",""userName"":""雷亚琦"",""stkbin"":""""}]")
ClassMethod Save(Main As %String, ListData As %String) As RtnObj
{
	n (Main,ListData)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainPJobj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"","入参错误!","",0)
	
	s pWinId=MainPJobj.%Get("InStkTkWin")
	s gUserId=MainPJobj.%Get("gUserId")
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-2,"","入参错误!","",0)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Insti=Obj.%Get("Insti")
		s Inst=$p(Insti,"||",1)
		s InstCh=$p(Insti,"||",2)
		s RowId=Obj.%Get("RowId")
		s CountQty=Obj.%Get("CountQty")
		s UomId=Obj.%Get("UomId")
		s InciId=$p(^DHCINST(Inst,"STI",InstCh),"^",18)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s PUomId=$p(^INCI(InciId,3),"^",6)
		s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
		s BUomQty=CountQty*Fac1
		s PUomQty=CountQty*Fac1/Fac2
		s Inclb=$p(^DHCINST(Inst,"STI",InstCh),"^",1)
		s StkBinStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBinByIncil($p(Inclb,"||",1,2))
		s StkBinId=$p(StkBinStr,"^",2)
		
		i RowId="" d
		.s obj=##class(User.DHCInStkTkItmWd).%New()
		.d obj.INSTWINSTIParrefSetObjectId(Insti)
		.s chw=$o(^DHCINST(Inst,"STI",InstCh,"STW",""),-1)+1
		.s obj.INSTWChildSub=chw
		.s obj.INSTWStkBinDesc=StkBinId
		.s obj.INSTWPHWDR=##class(User.DHCInStkTkWindow).%OpenId(pWinId)
		.d obj.INSTWCTUOMDRSetObjectId(UomId)
		e  d
		.s obj=##class(User.DHCInStkTkItmWd).%OpenId(RowId)
		.d obj.%Reload()
		s obj.INSTWCountDate=+$h
		s obj.INSTWCountTime=$p($h,",",2)
		d obj.INSTWCountPersonDRSetObjectId(gUserId)
		i CountQty<0 s CountQty=0	//实盘不允许负数
		s obj.INSTWCountQty=CountQty
		s obj.INSTWQtyBuom=BUomQty
		s obj.INSTWQtyPuom=PUomQty
		s sc=obj.%Save()
		i $$$ISERR(sc) d RtnObj.Err(-2,"","保存实盘信息是失败")
		q:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// 填充未录入实盘数记录的默认数(js调用)
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.INStkTkItmWd).jsSetDefaultQty("{""StkScg"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":"""",""LocManGrp"":"""",""StkCat"":"""",""LocStkBin"":"""",""InStkTkWin"":"""",""FreezeNonzero"":"""",""InciDesc"":"""",""Inst"":""23"",""InciId"":"""",""InstNo"":""MST20221103001""}","2")
ClassMethod jsSetDefaultQty(Params As %String, Flag As %String) As %String
{
	n (Params,Flag)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetDefaultQty(Params,Flag)
	q RtnObj.Json()
}

/// 填充未录入实盘数记录的默认数(js调用)
/// Creator:	lxt
/// Date:2012-09-03
/// Argu:
/// : 帐盘表id,实盘人rowid,填充标志(1:未填记录实盘数=0;2:未填记录实盘数=账盘数)
ClassMethod SetDefaultQty(Params As %String, Flag As %String) As RtnObj
{
	n (Params,Flag)
	s RtnObj=##class(RtnObj).%New()
	i Flag="" q RtnObj.Err(-1,"","设置类型为空","",0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJobj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参错误!","",0)
	
	s Inst=PJobj.%Get("Inst")
	s gUserId=PJobj.%Get("gUserId")
	s pWinId=PJobj.%Get("InStkTkWin")
	
	i Inst="" q RtnObj.Err(-3,"","未选择盘点单","",0)
	s Pid=..NewPid()
	k ^TMPDHCSTM("SetDefaultQty","QtyRecord",Pid,Inst)
	k ^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst)
	
	ts
	s Chl=0
	f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:(Chl="")||(RtnObj.success'=0)  d
	.s FreezeQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	.s UomId=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	.s Sub=0
	.f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:(Sub="")||(RtnObj.success'=0)  d
	..s WinId=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",7)
	..q:WinId'=pWinId
	..
	..s CountQty=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2)
	..q:CountQty'=""
	..s CountUserId=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	..i Flag=1  d
	...s DefaultQty=0
	..e  d
	...s DefaultQty=FreezeQty
	..i DefaultQty<0 s DefaultQty=0
	..
	..s InciId=$p(^DHCINST(Inst,"STI",Chl),"^",18)
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..s PUomId=$p(^INCI(InciId,3),"^",6)
	..s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	..s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	..
	..s RowId=Inst_"||"_Chl_"||"_Sub
	..i Flag'=1 d
	...s Ret=..GetDefaultQty(RowId,Pid)
	...i +Ret<0 d RtnObj.Err(-3,"","获取默认数量失败")
	..q:RtnObj.success<0
	..i (Flag'=1)&&($d(^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst,InciId,RowId)))  d
	...s DefaultQty=$g(^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst,InciId,RowId))
	..s BUomQty=DefaultQty
	..s PUomQty=DefaultQty/Fac2
	..s DefaultQty=DefaultQty/Fac1
	..s obj=##class(User.DHCInStkTkItmWd).%OpenId(RowId)
	..d obj.%Reload()
	..s obj.INSTWCountDate=+$h
	..s obj.INSTWCountTime=$p($h,",",2)
	..d obj.INSTWCountPersonDRSetObjectId(gUserId)
	..s obj.INSTWCountQty=DefaultQty
	..s obj.INSTWQtyBuom=BUomQty
	..s obj.INSTWQtyPuom=PUomQty
	..s sc=obj.%Save()
	..i $$$ISERR(sc) d RtnObj.Err(-2,"","保存实盘信息是失败")
	..q:RtnObj.success<0
	
	i RtnObj.success<0  d
	.tro  
	.k ^TMPDHCSTM("SetDefaultQty","QtyRecord",Pid,Inst)
	.k ^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst)
	q:RtnObj.success'=0 RtnObj	
	tc
	k ^TMPDHCSTM("SetDefaultQty","QtyRecord",Pid,Inst)
	k ^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst)
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.INStkTkItmWd).GetDefaultQty("24||66||1",42607)
ClassMethod GetDefaultQty(RowId As %String, Pid As %String) As %String
{
	n (RowId,Pid)
	q:RowId="" -1
	q:Pid="" -2
	s Inst=+RowId
	s Inci=+$p(^DHCINST(Inst,"STI",$p(RowId,"||",2)),"^",1)
	q:$d(^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst,Inci,RowId)) 0
	
	s LessZeroTotals=0 //库存项下的负账盘数总和
	s ch=0
	f  s ch=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,ch)) q:+ch'>0  d
	.s freezeqty=$p($g(^DHCINST(Inst,"STI",ch)),"^",2)
	.s inclb=$p($g(^DHCINST(Inst,"STI",ch)),"^",1)
	.q:+inclb'>0
	.s incib=$p($g(^INCI(Inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3))),"^",1)
	.s expdate=$p($g(^INCI(Inci,"IB",$p(incib,"||",2))),"^",2)
	.i +expdate=0 s expdate=$zdh("9999-12-31",3)
	.s sub=""
	.f  s sub=$o(^DHCINST(Inst,"STI",ch,"STW",sub))  q:sub=""  d
	..s counterqty=$p($g(^DHCINST(Inst,"STI",ch,"STW",sub)),"^",2)
	..q:counterqty'=""
	..s rowid=Inst_"||"_ch_"||"_sub
	..i freezeqty<0 s LessZeroTotals=LessZeroTotals+freezeqty  //库存项下的负账盘数总和
	..s ^TMPDHCSTM("SetDefaultQty","QtyRecord",Pid,Inst,Inci,expdate,rowid)=freezeqty
	q:'$d(^TMPDHCSTM("SetDefaultQty","QtyRecord",Pid,Inst,Inci)) 0
	
	s Exp="",SumQty="" //按效期先后顺序对正账盘数进行累加,记录在SumQty中
	f  s Exp=$o(^TMPDHCSTM("SetDefaultQty","QtyRecord",Pid,Inst,Inci,Exp)) q:Exp=""  d
	.s InstwId=""
	.f  s InstwId=$o(^TMPDHCSTM("SetDefaultQty","QtyRecord",Pid,Inst,Inci,Exp,InstwId)) q:InstwId=""  d
	..s FreQty=$g(^TMPDHCSTM("SetDefaultQty","QtyRecord",Pid,Inst,Inci,Exp,InstwId))
	..i FreQty<=0  d
	...s ^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst,Inci,InstwId)=0
	..e  d
	...i SumQty="" s SumQty=FreQty+LessZeroTotals	//对sumQty的数值进行初始化，如果是第一次计算，则将该条账盘数与负账盘总数进行累加;
	...e  i SumQty<=0 s SumQty=FreQty+SumQty  	//如果不是第一次累加，并且是负账盘数，则将该条账盘数与上次的累加结果进行累加;
	...e  i SumQty>0  s SumQty=FreQty    		//如果累加结果已经变为正数，则将累加加过重置为该条账盘数。
	...i SumQty<=0  s ^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst,Inci,InstwId)=0
	...e  s ^TMPDHCSTM("SetDefaultQty","Result",Pid,Inst,Inci,InstwId)=SumQty
	q 0
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
  i ##class(web.DHCSTMHUI.Common.AppCommon).Lock("DHCSTINSTKTK"_instw)<0 q -99
  i ..AllowDel(instw)<0 d ..uLock(instw)  q -1
  &sql(delete from dhc_instktkitmwd where %ID=:instw)
  i SQLCODE'=0 d ..uLock(instw) q -2
  d ..uLock(instw)
  q 0
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
  q ##class(web.DHCSTMHUI.INStkTk).AllowDel(inst)
}

/// 解锁
ClassMethod uLock(instw As %String)
{
 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("DHCSTINSTKTK"_instw)	
 q
}

/// 盘点完成 (js 调用)
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.INStkTkItmWd).jsCompleteWd(166,873)
ClassMethod jsCompleteWd(Inst As %String, UserId As %String) As %String
{
	n (Inst,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CompleteWd(Inst,UserId)
	q RtnObj.Json()
}

/// 实盘数据汇总  
///    -即将实盘表中的数据，按照批次对实盘数量加以汇总（基本单位），然后更新到帐盘表中
/// Creator:	lxt
/// Date:2012-08-06
/// Argu:
///  inst - 盘点主表rowid
/// Return:
///  0 - scucess
///  <0 - failure
/// w ##class(web.DHCSTMHUI.INStkTkItmWd).INStkTkWdSum(190,541)
ClassMethod CompleteWd(Inst As %String, UserId As %String) As RtnObj
{
	n (Inst,UserId)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-1,"","入参错误!","",0)
	
	s CompleteFlag=$p(^DHCINST(Inst),"^",13)
	i CompleteFlag="Y" q RtnObj.Err(-2,"","已经完成!","",0)
	
	i ..WdCheck(Inst)="N" q RtnObj.Err(-3,"","盘点单中存在未录入实盘数明细","",0)
	
	i ..sssLock("DHCSTINSTKTK"_Inst)<0  q RtnObj.Err(-99,"","加锁失败!")
	s InStkItmFlag="Y"
	ts
	s ch=0
	f  s ch=$o(^DHCINST(Inst,"STI",ch)) q:(ch="")!(RtnObj.success<0)  d
	.s Insti=Inst_"||"_ch
	.s InciId=$p(^DHCINST(Inst,"STI",ch),"^",18)  q:InciId=""
	.s BUomId=$p(^INCI(InciId,1),"^",10) q:BUomId=""
	.s FreezeQty=+$p(^DHCINST(Inst,"STI",ch),"^",2) 
	.s CountQty=..SumCountQty(Insti)
	.s Rp=$P(^DHCINST(Inst,"STI",ch),"^",30)
	.s CountRpAmt=Rp*CountQty
	.s Sp=$P(^DHCINST(Inst,"STI",ch),"^",28)
	.s CountSpAmt=Sp*CountQty
	.s obj=##class(User.DHCInStkTkItm).%OpenId(Insti)
	.d obj.%Reload()
	.
	.s varQty=CountQty-FreezeQty
	.s FreezeRpAmt=obj.INSTIFreezeRpAmt
	.s FreezeSpAmt=obj.INSTIFreezeSpAmt
	.s varRpAmt=CountRpAmt-FreezeRpAmt
	.s varSpAmt=CountSpAmt-FreezeSpAmt
	.
	.d obj.INSTICount1PersonDRSetObjectId(UserId)
	.s obj.INSTICount1Qty=+CountQty
	.s obj.INSTICount1Date=+$H
	.s obj.INSTICount1Time=$P($H,",",2)
	.s obj.INSTICount1SpAmt=+CountSpAmt
	.s obj.INSTICount1RpAmt=+CountRpAmt
	.s obj.INSTIVariance1=varQty
	.s obj.INSTIVariance1RpAmt=varRpAmt
	.s obj.INSTIVariance1SpAmt=varSpAmt
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..d RtnObj.Err(-4,"","更新实盘明细失败！")
	.q:RtnObj.success<0
	.
	.&sql(Update DHC_InStkTkItmWd set INSTW_InStkItmFlag=:InStkItmFlag where INSTW_INSTI_Parref=:Insti)
	.i SQLCODE<0 d RtnObj.Err(-5,"","更新实盘明细失败！")	// '=0改为<0  避免实盘方式二录入不全时SQLCODE=100造成的汇总报错
	.q:RtnObj.success<0
	.
	i RtnObj.success<0 d
	.tro 
	.d ..sssUnLock("DHCSTINSTKTK"_Inst)
	i RtnObj.success<0 q RtnObj
	
	&sql(update DHC_instktk  set inst_stocktakecomplete=:InStkItmFlag where inst_rowid =:Inst)
	i SQLCODE'=0  d
	.tro
	.d RtnObj.Err(-6,"","汇总错误!")
	.d ..sssUnLock("DHCSTINSTKTK"_Inst)
	i RtnObj.success<0 q RtnObj
	
	tc
	d ..sssUnLock("DHCSTINSTKTK"_Inst)
	q RtnObj
}

/// 检查是否有未填写数量
/// Creator：lxt
/// Date:2012-08-10
/// Argu:
///  inst
/// Return:
/// Y 全部填写数量 N存在未填数量
/// 
ClassMethod WdCheck(Inst As %String) As %String
{
	n (Inst)
	s Flag="Y"
	
	s ch=0
	s ch=$o(^DHCINST(Inst,"STI",ch)) q:(ch="")!(Flag="N")  d
	.s wch=0 
	.f  s wch=$o(^DHCINST(Inst,"STI",ch,"STW",wch)) q:(wch="")!(Flag="N")  d
	..s cqty=$p(^DHCINST(Inst,"STI",ch,"STW",wch),"^",2)
	..s:cqty="" Flag="N"
	..q:Flag="N"
	
	q Flag
}

/// 汇总某一项目的盘点数据
/// Creator: lxt
/// Date:2012-08-10
/// Argu:
///  insti - 
/// Return:
///  实盘总数(基本单位)
/// 
ClassMethod SumCountQty(Insti As %String) As %String
{
	n (Insti)
	
	s SumCountQty=0
	s Inst=+Insti
	s ch=$p(Insti,"||",2)
	s InciId=+$P(^DHCINST(Inst,"STI",ch),"^",1)
	s BUomId=$p(^INCI(InciId,1),"^",10)
	s wch=0 
	f  s wch=$o(^DHCINST(Inst,"STI",ch,"STW",wch)) q:wch=""  d
	.s stkwstr=$G(^DHCINST(Inst,"STI",ch,"STW",wch))
	.s CountUomId=+$p(stkwstr,"^",1) q:CountUomId=""
	.s CountQty=+$p(stkwstr,"^",2) q:CountQty=""
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CountUomId,BUomId) q:Fac=""
	.s CountQty=CountQty*Fac
	.s SumCountQty=SumCountQty+CountQty
	
	q SumCountQty
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

/// 实盘 (js 调用)
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.INStkTkItmWd).jsCreateStkTkItmWd()
ClassMethod jsCreateStkTkItmWd(Inst As %String, UserId As %String, WinId As %String) As %String
{
	n (Inst,UserId,WinId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CreateStkTkItmWd(Inst,UserId,WinId)
	q RtnObj.Json()
}

/// 根据帐盘记录生成实盘数据列表（实盘方式一js 调用）
/// Creator:	lxt
/// Date:2012-08-06
/// Argu:
///   inst - 盘点主表rowid
/// Return:
///   0 - scucess
///   <0 - failure
ClassMethod CreateStkTkItmWd(Inst As %String, UserId As %String, WinId As %String) As RtnObj
{
	n (Inst,UserId,WinId)
	
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-1,"","入参错误!","",0)
	
	ts
	s ch=0
	f  s ch=$o(^DHCINST(Inst,"STI",ch)) q:(+ch=0)!(RtnObj.success<0)  d
	.s Insti=Inst_"||"_ch
	.s UomId=+$p(^DHCINST(Inst,"STI",ch),"^",17)
	.s Inclb=$p(^DHCINST(Inst,"STI",ch),"^",1)
	.s StkBinStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBinByIncil($p(Inclb,"||",1,2))
	.s StkBinId=$p(StkBinStr,"^",2)
	.
	.s Instw=""
	.i WinId'="" d
	..s Instw=$o(^DHCINST("WINDOW",Inst,WinId,ch,0))
	.e  d
	..&sql(select INSTW_RowID into :Instw from dhc_instktkitmwd where INSTW_INSTI_Parref=:Insti and INSTW_PHW_DR is null)
	.q:Instw'=""		;已经生成了实盘项目
	.
	.s obj=##class(User.DHCInStkTkItmWd).%New()
	.d obj.INSTWINSTIParrefSetObjectId(Insti)
	.s chw=$o(^DHCINST(Inst,"STI",ch,"STW",""),-1)+1
	.s obj.INSTWChildSub=chw
	.s obj.INSTWStkBinDesc=StkBinId
	.s obj.INSTWPHWDR=##class(User.DHCInStkTkWindow).%OpenId(WinId)
	.s obj.INSTWCountDate=+$h
	.s obj.INSTWCountTime=$p($h,",",2)
	.d obj.INSTWCountPersonDRSetObjectId(UserId)
	.d obj.INSTWCTUOMDRSetObjectId(UomId)
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d RtnObj.Err(-2,"","生成实盘数据失败") q
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
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
 q:##class(web.DHCSTMHUI.Common.AppCommon).Lock("DHCSTINSTKTK"_inst)<0 -99
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
	...
	..
	.
	q Flag
}

/// 检索帐盘表记录表格数据，用于填入实盘数据
/// Creator:	lxt
/// Date:2012-08-10
/// Argu:
///   inst -
///   ManGrp -
/// Return:
///  instw - 实盘记录rowid, inclb-批次rowid,inci-库存项目rowid,code-代码,desc-名称,spec-规格,manf-生产厂家,
///  batNo-批号,expDate-效期,freQty-帐盘数,uom-盘点单位rowid,uomDesc-单位名称,
///  buom-基本单位rowid,buomDesc-基本单位名称,rp-进价,sp-售价,countQty-实盘数量,
///  countDate-实盘日期,countTime-实盘时间,userName-盘点人
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INStkTkItmWd","jsINStkTkItmWd",^templxt("jsINStkTkItmWd"))
Query jsINStkTkItmWd(Params As %String) As Query(ROWSPEC = "RowId,Insti,Inclb,InciId,InciCode,InciDesc,Spec,ManfDesc,BatchNo,ExpDate,FreezeQty:%Float,UomId,UomDesc,BUomId,BuomDesc,Rp:%Float,Sp:%Float,CountQty:%Float,CountDate,CountTime,CountUserName,StkBinDesc,BatExp,VarianceQty:%Float,FreezeRpAmt:%Float,FreezeSpAmt:%Float,CountRpAmt:%Float,CountSpAmt:%Float,VarianceRpAmt:%Float,VarianceSpAmt:%Float")
{
}

ClassMethod jsINStkTkItmWdExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Inst=PJobj.%Get("Inst")
	s pLocManGrpId=PJobj.%Get("LocManGrp")
	s pStkScgId=PJobj.%Get("StkScg")
	s pStkCatId=PJobj.%Get("StkCat")
	s pStkBinId=PJobj.%Get("LocStkBin")
	s pWinId=PJobj.%Get("InStkTkWin")
	s pInciDesc=PJobj.%Get("InciDesc")
	s pFreezeNonzero=PJobj.%Get("FreezeNonzero")
	s pPInciId=PJobj.%Get("InciId")
	
	s LocId=$p(^DHCINST(Inst),"^",5)
	s HospId=..sssHospId(LocId)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",pStkScgId,HospId)
	
	s sql="select %ID RowId,"
		_"instw_insti_parref->insti_inclb_dr Inclb,"
		_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref InciId,"
		_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_code InciCode,"
		_"instw_insti_parref->insti_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_desc InciDesc,"
		_"instw_insti_parref->insti_inclb_dr->inclb_incib_dr->incib_no BatchNo,"
		_"instw_insti_parref->insti_inclb_dr->inclb_incib_dr->incib_expdate ExpDate,"
		_"instw_ctuom_dr UomId,"
		_"instw_ctuom_dr->ctuom_desc UomDesc,"
		_"instw_countqty CountQty,"
		_"instw_countDate CountDate,"
		_"instw_counttime CountTime,"
		_"instw_stkbindesc StkBinId,"
		_"instw_countperson_dr->ssusr_name CountUserName,"
		_"instw_insti_parref->insti_freezeqty FreezeQty,"
		_"instw_insti_parref->insti_sp Sp,"
		_"instw_insti_parref->insti_rp Rp,"
		_"instw_insti_parref->insti_inci_dr->inci_ctuom_dr BUomId,"
		_"instw_insti_parref->insti_inci_dr->inci_ctuom_dr->ctuom_desc BuomDesc,"
		_"instw_insti_parref->insti_inci_dr->inci_incsc_dr->incsc_desc StkCatDesc,"
		_"INSTW_PHW_DR WinId,instw_insti_parref Insti "
		_" from dhc_instktkitmwd"
		_" where instw_insti_parref->insti_inst_parref="_Inst
	
	s xrs=##class(%ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute(Inst)
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Insti=xrs.Data("Insti")
		s Inclb=xrs.Data("Inclb")
		s InciId=xrs.Data("InciId")
		continue:(pPInciId'="")&&(pPInciId'=InciId)
		
		s LocManGrpId=##class(web.DHCSTMHUI.Common.DrugStkCommon).ManGrpByIncil($p(Inclb,"||",1,2))
		continue:(pLocManGrpId'="")&&(pLocManGrpId'=LocManGrpId)
		
		s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
		s GrpId=$p(StkGrpInfo,"^",5)
		continue:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_GrpId_"^"))
		
		s StkCatId=$p(^INCI(InciId,2),"^",2)
		continue:(pStkCatId'="")&(StkCatId'=pStkCatId)
		
		s Incil=$p(Inclb,"||",1,2)
		s StkBinId=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBinByIncil(Incil),"^",2)
		continue:(pStkBinId'="")&(StkBinId'=pStkBinId)
		
		s WinId=xrs.Data("WinId")
		continue:pWinId'=WinId

		s InciCode=xrs.Data("InciCode")
		s InciDesc=xrs.Data("InciDesc")
		continue:(pInciDesc'="")&(InciDesc'[pInciDesc)
		
		s UomId=xrs.Data("UomId")
		s UomDesc=xrs.Data("UomDesc")
		s FreezeQty=xrs.Data("FreezeQty")
		continue:(pFreezeNonzero="Y")&&(FreezeQty=0)
		
		s BatchNo=xrs.Data("BatchNo")
		s ExpDate=xrs.Data("ExpDate")
		s CountQty=xrs.Data("CountQty")
		s CountDate=xrs.Data("CountDate")
		s CountTime=xrs.Data("CountTime")
		
		s (StkBinDesc)=""
		s StkBinId=xrs.Data("StkBinId")
		i StkBinId'="" s StkBinDesc=$p(^INC("SB",StkBinId),"^",2)
		s CountUserName=xrs.Data("CountUserName")
		s Sp=xrs.Data("Sp")
		s Rp=xrs.Data("Rp")
		s BUomId=xrs.Data("BUomId")
		s BuomDesc=xrs.Data("BuomDesc")
		s StkCatDesc=xrs.Data("StkCatDesc")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s ManfDesc=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s FreezeQty=FreezeQty/Fac
		s Rp=+Rp*Fac
		s Sp=+Sp*Fac
		s FreezeRpAmt=FreezeQty*Rp
		s FreezeSpAmt=FreezeQty*Sp
		s (VarianceQty,CountRpAmt,CountSpAmt,VarianceRpAmt,VarianceSpAmt)=""
		i CountQty'="" d
		.s VarianceQty=CountQty-FreezeQty
		.s CountRpAmt=CountQty*Rp
		.s CountSpAmt=CountQty*Sp
		.s VarianceRpAmt=VarianceQty*Rp
		.s VarianceSpAmt=VarianceQty*Sp
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s BatExp=BatchNo_"~"_ExpDate
		s CountDate=..DL2H(CountDate)
		s CountTime=..TL2H(CountTime)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Insti,Inclb,InciId,InciCode,InciDesc,Spec,ManfDesc,BatchNo,ExpDate,FreezeQty,UomId,UomDesc,
	BUomId,BuomDesc,Rp,Sp,CountQty,CountDate,CountTime,CountUserName,StkBinDesc,BatExp,VarianceQty,FreezeRpAmt,
	FreezeSpAmt,CountRpAmt,CountSpAmt,VarianceRpAmt,VarianceSpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 汇总实盘数据(按品种)
/// Creator: lxt
/// Date:2012-09-11
/// Argu:
/// 帐盘表id
ClassMethod Collect(Inst, Pid) As %String
{
	n (Inst,Pid)
	q:Inst="" ""
	
	s Count=0
	s Chl=0
	f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:Chl=""  d
	.s Inci=$p(^DHCINST(Inst,"STI",Chl),"^",18)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Sub=0
	.f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:Sub=""  d
	..s CountQty=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2)
	..s CountUserId=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	..s CountUomId=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",1)
	..s RowId=Inst_"||"_Chl_"||"_Sub
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CountUomId,BUomId)
	..s CountQtyBUom=CountQty*Fac    //按基本单位数量汇总
	..s Data=CountQtyBUom_"^"_RowId
	..
	..;按品种汇总实盘数量
	..i '$d(^TMPDHCSTM("InStkTk",Pid,Inci))  d
	...s ^TMPDHCSTM("InStkTk",Pid,Inci)=Data
	..e  d
	...s $p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",1)=CountQtyBUom+$p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",1)
	...s $p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",2)=RowId_","_$p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",2)
	..s Count=Count+1
	..
	.
	q Count
}

/// 汇总实盘数据(按品种)--根据dhc_instktkinput汇总
/// Creator: lxt
/// Date:2013-09-25
/// Argu:
/// 帐盘表id
ClassMethod CollectInput(Inst, Pid) As %String
{
	n (Inst,Pid)
	q:Inst="" ""
	
	s Count=0
	s Chl=0
	f  s Chl=$o(^DHCINST(Inst,"STP",Chl)) q:Chl=""  d
	.s Inci=$p(^(Chl),"^",1)
	.s CountQty=+$p(^(Chl),"^",2)
	.s CountUomId=$p(^(Chl),"^",3)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.
	.s RowId=Inst_"||"_Chl
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CountUomId,BUomId)
	.s CountQtyBUom=CountQty*Fac    //按基本单位数量汇总
	.s Data=CountQtyBUom_"^"_RowId
	.
	.;按品种汇总实盘数量
	.i '$d(^TMPDHCSTM("InStkTk",Pid,Inci))  d
	..s ^TMPDHCSTM("InStkTk",Pid,Inci)=Data
	.e  d
	..s $p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",1)=CountQtyBUom+$p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",1)
	..s $p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",2)=RowId_","_$p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",2)
	.s Count=Count+1
	q Count
}

/// 汇总实盘数据(按高值条码)--根据dhc_instktkitm汇总
/// Creator: lxt
/// Date:	2015-07-15
/// Argu:	帐盘表id
ClassMethod CollectItm(Inst, Pid) As %String
{
	n (Inst,Pid)
	q:Inst="" ""
	
	s Count=0
	s Chl=0
	f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:Chl=""  d
	.s Inci=$p(^(Chl),"^",18)
	.s CountQty=+$p(^(Chl),"^",5)	;基本单位
	.
	.s RowId=Inst_"||"_Chl
	.s Data=CountQty_"^"_RowId
	.
	.;按品种汇总实盘数量
	.i '$d(^TMPDHCSTM("InStkTk",Pid,Inci))  d
	..s ^TMPDHCSTM("InStkTk",Pid,Inci)=Data
	.e  d
	..s $p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",1)=CountQty+$p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",1)
	..s $p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",2)=RowId_","_$p(^TMPDHCSTM("InStkTk",Pid,Inci),"^",2)
	.s Count=Count+1
	.
	q Count
}

/// 汇总实盘数据(按品种)
/// Creator: lxt
/// Date:2012-09-11
/// Argu:
/// 开始记录行，一页显示记录数,排序字段，排序方向，帐盘表id
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INStkTkItmWd","CollectItmCountQty",165)
Query CollectItmCountQty(Inst As %String) As Query(ROWSPEC = "Inst,InciId,InciCode,InciDesc,Spec,FreezeQty:%Float,CountQty:%Float,RowId,LastRp:%Float") [ SqlProc ]
{
}

ClassMethod CollectItmCountQtyExecute(ByRef qHandle As %Binary, Inst As %String) As %Status
{
	n (qHandle,Inst)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s LocId=$p(^DHCINST(Inst),"^",5)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s InputType=##class(web.DHCSTMHUI.INStkTk).CheckItmWd(Inst)
	
	s Num=0
	s Pid=..NewPid()
	k ^TMPDHCSTM("InStkTk",Pid)
	i InputType=2 d
	.s Num=..CollectInput(Inst,Pid)
	e  i InputType=1 d
	.s Num=..Collect(Inst,Pid)
	e  i InputType=3 d
	.s Num=..CollectItm(Inst,Pid)
	q:+Num=0 $$$OK
	
	s Count=0
	s InciId=""
	f  s InciId=$o(^TMPDHCSTM("InStkTk",Pid,InciId)) q:InciId=""  d
	.s Data=^TMPDHCSTM("InStkTk",Pid,InciId)
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s PUomId=$p(^INCI(InciId,3),"^",6)
	.s:PUomId'="" PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	.s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	.s CountQty=$p(Data,"^",1)
	.s RowId=$p(Data,"^",2)
	.s FreezeQty=..GetItmFreezeQty(Inst,InciId)
	.s CountQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(InciId,CountQty)
	.s FreezeQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(InciId,FreezeQty)
	.s LastRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(InciId,PUomId,HospId)
	.s Count=Count+1
	.d OutPutCollectItmCountQtyRow
	
	k ^TMPDHCSTM("InStkTk",Pid)
	Quit $$$OK
	
OutPutCollectItmCountQtyRow
	s Data=$lb(Inst,InciId,InciCode,InciDesc,Spec,FreezeQty,CountQty,RowId,LastRp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 计算某药品的帐盘数量
/// Creator: lxt
/// Date:2012-09-12
/// Argu:
/// 帐盘表id,库存项id
ClassMethod GetItmFreezeQty(Inst As %String, Inci As %String) As %String
{
	n (Inst,Inci)
	s Qty=0
	q:Inst="" Qty
	q:Inci="" Qty

	s Chl=""
	f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	.s FreezeQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	.s Qty=Qty+FreezeQty
	.
	q Qty
}

/// 查询某药品的实盘明细(按帐盘批次汇总)
/// Creator :lxt
/// Date:2012-09-12
/// Argu:
/// 帐盘表id,库存项id
/// w ##class(web.DHCSTMHUI.INStkTkItmWd).QueryItmTkWd(165,8)
ClassMethod QueryItmTkWd(Inst As %String, Inci As %String) As %String
{
	n (Inst,Inci)
	q:Inst="" ""
	q:Inci="" ""
	
	s Pid=..NewPid()
	k ^TMPDHCSTM("InStkTkItm",Pid)
	
	s InputType=##class(web.DHCSTMHUI.INStkTk).CheckItmWd(Inst)
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s Count=0
	i InputType=1 d
	.s Chl=0
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	..s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	..s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	..s FreUomDesc=""
	..s:FreUom'="" FreUomDesc=$p(^CT("UOM",FreUom),"^",2)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(FreUom,BUomId)
	..s FreQty=FreQty/Fac
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..s Insti=Inst_"||"_Chl
	..s Sub=0
	..f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:Sub=""  d
	...s CountQty=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2)
	...s CountUser=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	...s CountUom=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",1)
	...s CountDate=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",4)
	...s CountTime=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",5)
	...s Rowid=Inst_"||"_Chl_"||"_Sub
	...s FacCountUom=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CountUom,BUomId)
	...s CountQtyUom=CountQty*FacCountUom/Fac
	...
	...;按帐盘批次汇总实盘数量
	...i '$d(^TMPDHCSTM("InStkTkItm",Pid,Insti))  d
	....s ^TMPDHCSTM("InStkTkItm",Pid,Insti)=CountQtyUom
	...e  d
	....s ^TMPDHCSTM("InStkTkItm",Pid,Insti)=CountQtyUom+^TMPDHCSTM("InStkTkItm",Pid,Insti)
	...
	..q:'$d(^TMPDHCSTM("InStkTkItm",Pid,Insti))	//2014-07-01 过滤未录入ItmWd孙表的记录
	..s Count=Count+1
	..s CountQty=^TMPDHCSTM("InStkTkItm",Pid,Insti)
	..s Data=Insti_"^"_Inclb_"^"_BatNo_"^"_ExpDate_"^"_FreUomDesc_"^"_FreQty_"^"_CountQty
	..d json.InsertRowData(Data)
	.
	.k ^TMPDHCSTM("InStkTkItm",Pid)
	.d json.getJsonData("Insti^Inclb^BatNo^ExpDate^FreezeUomDesc^FreezeQty:number^CountQty:number",Count)

	i InputType=2 d
	.s ch=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,0))
	.s FreUom=$p(^DHCINST(Inst,"STI",ch),"^",17)
	.s FreUomDesc=""
	.s:FreUom'="" FreUomDesc=$p(^CT("UOM",FreUom),"^",2)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(FreUom,BUomId)
	.
	.s FreQty=..GetItmFreezeQty(Inst,Inci)
	.s FreQty=FreQty/Fac
	.s CountQty=##class(web.DHCSTMHUI.InStkTkInput).SumCountQty(Inst,Inci)
	.s CountQty=CountQty/Fac
	.s Data=FreUomDesc_"^"_FreQty_"^"_CountQty
	.d json.InsertRowData(Data)
	.d json.getJsonData("FreezeUomDesc^FreezeQty:number^CountQty:number",1)
	
	i InputType=3 d
	.s Chl=0
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	..s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	..s CountQty=$p(^DHCINST(Inst,"STI",Chl),"^",5)
	..q:CountQty=""			//过滤未实盘的明细
	..s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	..s FreUomDesc=""
	..s:FreUom'="" FreUomDesc=$p(^CT("UOM",FreUom),"^",2)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(FreUom,BUomId)
	..s FreQty=FreQty/Fac
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..s Insti=Inst_"||"_Chl
	..s Count=Count+1
	..s Data=Insti_"^"_Inclb_"^"_BatNo_"^"_ExpDate_"^"_FreUomDesc_"^"_FreQty_"^"_CountQty
	..d json.InsertRowData(Data)
	.
	.k ^TMPDHCST("InStkTkItm",Pid)
	.d json.getJsonData("Insti^Inclb^BatNo^ExpDate^FreezeUomDesc^FreezeQty:number^CountQty:number",Count)
	
	k json
	q ""
}

/// 查询某药品的实盘明细
/// Creator :lxt
/// Date:2012-09-12
/// Argu:
/// 帐盘表id,库存项id
ClassMethod QueryItmTkWdDetail(Inst As %String, Inci As %String) As %String
{
	n (Inst,Inci)
	q:Inst="" ""
	q:Inci="" ""
	
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s Count=0
	s InputType=##class(web.DHCSTMHUI.INStkTk).CheckItmWd(Inst)
	i InputType=1 d
	.s Chl=0
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	..s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	..s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	..s:FreUom'="" FreUomDesc=$p(^CT("UOM",FreUom),"^",2)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s PUomId=$p(^INCI(Inci,3),"^",6)
	..s:PUomId'="" PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(FreUom,BUomId)
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..s Insti=Inst_"||"_Chl
	..s Sub=0
	..f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STW",Sub)) q:Sub=""  d
	...s CountQty=+$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",2)
	...s CountUserId=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",3)
	...s CountUserName=""
	...s:CountUserId'="" CountUserName=$p(^SSU("SSUSR",CountUserId),"^",2)
	...s CountUom=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",1)
	...s CountUomDesc=""
	...s:CountUom'="" CountUomDesc=$p(^CT("UOM",CountUom),"^",2)
	...s CountDate=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",4)
	...s CountTime=$p(^DHCINST(Inst,"STI",Chl,"STW",Sub),"^",5)
	...s:CountDate'="" CountDate=..DL2H(CountDate)
	...s:CountTime'="" CountTime=..TL2H(CountTime)
	...s RowId=Inst_"||"_Chl_"||"_Sub
	...s FacCountUom=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CountUom,BUomId)
	...s CountQtyUom=CountQty*FacCountUom/Fac
	...s Count=Count+1
	...
	...s Data=RowId_"^"_Inclb_"^"_BatNo_"^"_ExpDate_"^"_CountUomDesc_"^"_CountQty_"^"_CountDate_"^"_CountTime_"^"_CountUserName
	...d json.InsertRowData(Data)
	.
	.d json.getJsonData("RowId^Inclb^BatNo^ExpDate^CountUom^CountQty:number^CountDate^CountTime^CountUserName",Count)
 
	i InputType=2 d
	.s ch=0
	.f  s ch=$o(^DHCINST(Inst,"STP",0,Inci,ch)) q:ch=""  d
	..s tmpData=^DHCINST(Inst,"STP",ch)
	..s CountQty=$p(tmpData,"^",2)
	..s CountUom=$p(tmpData,"^",3)
	..s CountUomDesc=""
	..s:CountUom'="" CountUomDesc=$p(^CT("UOM",CountUom),"^",2)
	..s CountDate=$p(tmpData,"^",4)
	..s:CountDate'="" CountDate=..DL2H(CountDate)
	..s CountTime=$p(tmpData,"^",5)
	..s:CountTime'="" CountTime=..TL2H(CountTime)
	..s CountUserId=$p(tmpData,"^",6)
	..s CountUserName=""
	..s:CountUserId'="" CountUserName=$p(^SSU("SSUSR",CountUserId),"^",2)
	..
	..s Count=Count+1
	..s Data=CountUomDesc_"^"_CountQty_"^"_CountDate_"^"_CountTime_"^"_CountUserName
	..d json.InsertRowData(Data)
	.
	.d json.getJsonData("CountUom^CountQty:number^CountDate^CountTime^CountUserName",Count)
	
	i InputType=3 d
	.s Chl=0
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	..s FreQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	..s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	..s FreUomDesc=""
	..s:FreUom'="" FreUomDesc=$p($g(^CT("UOM",FreUom)),"^",2)
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..s Insti=Inst_"||"_Chl
	..s Sub=0
	..f  s Sub=$o(^DHCINST(Inst,"STI",Chl,"STIT",Sub)) q:Sub=""  d
	...s INStkTkFlag=$p(^DHCINST(Inst,"STI",Chl,"STIT",Sub),"^",2)
	...q:INStkTkFlag'="Y"		;未盘点条码过滤
	...s CountQty=1
	...s CountUser=$p(^DHCINST(Inst,"STI",Chl,"STIT",Sub),"^",5)
	...s CountUserName=""
	...s:CountUser'="" CountUserName=$p(^SSU("SSUSR",CountUser),"^",2)
	...s CountDate=$p(^DHCINST(Inst,"STI",Chl,"STIT",Sub),"^",3)
	...s CountTime=$p(^DHCINST(Inst,"STI",Chl,"STIT",Sub),"^",4)
	...s:CountDate'="" CountDate=..DL2H(CountDate)
	...s:CountTime'="" CountTime=..TL2H(CountTime)
	...s RowId=Inst_"||"_Chl_"||"_Sub
	...
	...s Count=Count+1
	...s Data=RowId_"^"_Inclb_"^"_BatNo_"^"_ExpDate_"^"_FreUomDesc_"^"_CountQty_"^"_CountDate_"^"_CountTime_"^"_CountUserName
	...d json.InsertRowData(Data)
	.
	.d json.getJsonData("RowId^Inclb^BatNo^ExpDate^CountUom^CountQty:number^CountDate^CountTime^CountUserName",Count)
	
	k json
	q ""
}

/// 盘点取消汇总 (js 调用)
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.INStkTkItmWd).jsStkCancelComplete(166)
ClassMethod jsStkCancelComplete(Inst As %String) As %String
{
	n (Inst)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..StkCancelComplete(Inst)
	q RtnObj.Json()
}

/// Descript:	盘点取消汇总
/// CreateDate: 2014-07-01
/// Input:		盘点id    
ClassMethod StkCancelComplete(Inst As %String) As RtnObj
{
	n (Inst)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-1,"","入参错误!","",0)
	
	i ($d(^DHCINST(Inst))=0)!($d(^DHCINST(Inst))=10) q RtnObj.Err(-2,"","没有需要取消汇总的盘点单","",0)
	
	s AdjComp=$p(^DHCINST(Inst),"^",14)
	i AdjComp="Y" q RtnObj.Err(-3,"","盘点已调整","",0)
	
	s StktkFlag=$p(^DHCINST(Inst),"^",13)
	i StktkFlag'="Y" q RtnObj.Err(-4,"","该记录没有汇总","",0)
	
	s Complete="N"
	s Err=0
	&sql(update DHC_InStkTk set inst_stocktakecomplete=:Complete where INST_RowId=:Inst)
	i SQLCODE'=0  d
	.d RtnObj.Err(-5,"","取消完成错误")
	
	q RtnObj
}

}
