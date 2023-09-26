Import sqluser

Class web.DHCST.Android.InStkTk Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript:查询盘点单据列表
ClassMethod jsQueryInStkTk(startDate As %String, endDate As %String, LocID As %String) As %GlobalCharacterStream
{
 	n (startDate, endDate, LocID)
 	s:startDate'="" startDate=$zdh(startDate,3)
 	s:endDate'="" endDate=$zdh(endDate,3)
 	s count = 0
 	s ListTitle="Inst^InstNo^InstDate^User"
 	s ListStream=##class(%GlobalCharacterStream).%New()
 	f dd=startDate:1:endDate d
 	.s inst = ""
 	.f  s inst=$o(^DHCINST(0,"DATE",dd,inst)) q:inst=""  d
 	..s instNo=$p(^DHCINST(inst),"^",1)   //盘点单号
 	..s instDate=$p(^DHCINST(inst),"^",2) //盘点日期
 	..s:instDate'="" instDate=$zd(instDate,3)
 	..s instLocID=$p(^DHCINST(inst),"^",5) //盘点科室
 	..q:instLocID=""
 	..q:LocID'=instLocID
 	..s userID=$p(^DHCINST(inst),"^",4) //盘点人
 	..q:userID=""
 	..s userName=$p(^SSU("SSUSR",userID),"^",2)
 	..s ListData=inst_"^"_instNo_"^"_instDate_"^"_userName
	..s count = count+1       
    ..s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	..I count=1 d
	...d ListStream.Write("{ErrCode:0,rows:[")
	...d ListStream.Write(outputjson)
	..e  d
	...d ListStream.Write(",")
	...d ListStream.Write(outputjson)
    i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
    e  d
    .s EmptyJson="{ErrCode:0,rows:[]}"
    .d ListStream.Write(EmptyJson)
    q ListStream
}

/// Descript:同一药品批次列表
ClassMethod jsQueryInStkTkBatDet(inst As %String, inclb As %String) As %GlobalCharacterStream
{
	n (inst,inclb)
	s inci=+inclb
	q ##class(web.DHCST.Android.InStkTk).QueryItmTkWd(inst,inci)
}

/// creator:yunhaibao
/// createdate:20150818
/// description:仅供pda盘点调用,按药品以方式二盘点,同一窗口批次库存累加
/// input:parref(盘点主表id)_"^"_"空"_"^"_userid_"^"_inputqty_"^"_inputuom_"^"_stkbin_"^"_phawin_"^"_inclb
/// 注意:窗口是必填的,帐盘,汇总以及调整的操作在his端进行
/// w ##class(web.DHCST.AndroidInStkTk).SaveInStkItmWd("430^25169^100^1336^^^28800||17||129")
ClassMethod SaveInStkItmWd(ListData)
{
	n (ListData)
	s $ZT="Error^DHCSTERROR"  
	q:ListData="" -1
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(ListData,rowDelim)
	s Err=""
	s Count=0
	ts
	f i=1:1:len  d
	.s Data=$p(ListData,rowDelim,i)
	.q:Data=""
	.s Parref=$p(Data,"^",1)
	.s Inclb=$p(Data,"^",8)
	.q:Parref=""
	.q:Inclb=""
	.q:'$d(^DHCINST(Parref,"STI",0,Inclb))
	.//获取子表id
	.s instkitmchild=$o(^DHCINST(Parref,"STI",0,Inclb,""),-1)
	.s instkitmrowid=Parref_"||"_instkitmchild
	.s Rowid=$p(Data,"^",2)
	.s UserId=$p(Data,"^",3)
	.s CountQty=$p(Data,"^",4) //(对于方式二来说此变量有值)
	.s CountUom=$p(Data,"^",5)    //(对于方式二来说此单位是录入单位)
	.s StkBin=$p(Data,"^",6)
	.s PhaWin=$p(Data,"^",7)
	.//q:PhaWin=""
	.s Inci=$p(^DHCINST(+instkitmrowid,"STI",$p(instkitmrowid,"||",2)),"^",18)
	.s IncDesc=$p(^INCI(Inci,1),"^",2)
	.s BuomId=$p(^INCI(Inci,1),"^",10)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(CountUom,BuomId)
	.s CountQty=CountQty*Fac2 //以基本单位 数量 存入wd表 modify wyx 2014-12-04
	.//根据总数再重新分配大单位数量和基本单位数量
	.s PQty=CountQty\Fac2 //  整除 add wyx 2014-12-05
	.s BQty=CountQty#Fac2 // 余数
	.s Detail=UserId_"^"_CountQty_"^"_CountUom_"^"_BQty_"^"_PQty_"^"_StkBin_"^"_PhaWin
	.s ret=..Update(Rowid,instkitmrowid,Detail)
	.i +ret<=0  d
	..tro
	..s Err=Err_","_IncDesc
	.e  d
	..s Count=Count+1
	i Count=0 tro  q -2			;全部保存失败
	i Err'=""  tro  q -3_":"_Err		;部分保存失败
	tc
	q 0
}

///  instw - 实盘表记录rowid
///  insti -实盘表父表记录rowid(DHC_INStkTkItm)
///  data - 实盘表记录数据串("^"分隔: 实盘人rowid^实盘数^实盘单位^基本单位数量^入库单位数量^货位^实盘窗口)
///  InputQty-实盘数量（录入方式添加的参数其他可以没有）
///  w ##class(web.DHCST.PDAINStk).Update("415||1217||1","","25169^0^1505^0^0^^")
ClassMethod Update(instw As %String, insti As %String, data As %String) As %String
{
  n (instw,insti,data,InputQty)
  s user=$p(data,"^",1)   //实盘人rowid
  s qty=$p(data,"^",2)  //实盘数量和（基本单位）
  s uom=$p(data,"^",3)  //　实盘单位（基本单位）
  s bQty=$p(data,"^",4)  //　基本单位数量
  s pQty=$p(data,"^",5)  //　入库单位数量
  s stkbin=$p(data,"^",6)  //　货位
  s window=+$p(data,"^",7)  //　　实盘窗口
  //重新获取instw
  i $d(^DHCINST("WINDOW",+insti,window,$p(insti,"||",2))) d
  .s instwid=$o(^DHCINST("WINDOW",+insti,window,$p(insti,"||",2),""))
  .s instw=insti_"||"_instwid
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
  s obj.INSTWCountQty=obj.INSTWCountQty+qty
  d obj.INSTWCTUOMDRSetObjectId(uom)
  s obj.INSTWQtyBuom=obj.INSTWQtyBuom+bQty
  s obj.INSTWQtyPuom=obj.INSTWQtyPuom+pQty
  s sc=obj.%Save()
  i $$$ISERR(sc) w $System.Status.DisplayError(sc),!
  i $$$ISERR(sc) q -1
  q obj.%Id()
}

/// 查询某药品的实盘明细(按帐盘批次汇总)
/// Author:zhangdongmei
/// Date:2012-09-12
/// Argu:
/// 帐盘表id,库存项id
/// 新增查询药品实盘明细(按照账盘品种汇总)
ClassMethod QueryItmTkWd(Inst As %String, Inci As %String) As %String
{
	n (Inst,Inci)
	q:Inst="" ""
	q:Inci="" ""
	s Pid=##class(web.DHCST.INStkTkItmWd).NewPid()
	s json=##class(Code.JsonObj).%New()
	s Count=0
	s ResultString=""
	s inputType=##class(web.DHCST.INStkTk).CheckItmWd(Inst)
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
	..s PFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s FreQtyUom=FreQty/PFac
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=$zd(ExpDate,3)
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
	...s CountQtyUom=CountQty*FacCountUom/PFac
	...;按帐盘批次汇总实盘数量
	...i '$d(^TMPDHCST("InStkTkItm",Pid,Insti))  d
	....s ^TMPDHCST("InStkTkItm",Pid,Insti)=CountQtyUom
	...e  d
	....s ^TMPDHCST("InStkTkItm",Pid,Insti)=CountQtyUom+^TMPDHCST("InStkTkItm",Pid,Insti)
	..q:$g(^TMPDHCST("InStkTkItm",Pid,Insti))=""
	..s Count=Count+1
	..s Data=Insti_"^"_Inclb_"^"_BatNo_"^"_ExpDate_"^"_$g(PurUomDesc)_"^"_FreQty_"^"_^TMPDHCST("InStkTkItm",Pid,Insti)
	..
	..d json.InsertRowData(Data)
	.
	.s ResultString=json.getJsonData("Insti^Inclb^BatNo^ExpDate^FreUomDesc^FreQty^CountQty",Count)
	i inputType=2 d
	.s ch=0
	.f  s ch=$o(^DHCINST(Inst,"STP",0,Inci,ch)) q:ch=""  d
	..s tmpData=^DHCINST(Inst,"STP",ch)
	..s CountQty=$p(tmpData,"^",2)
	..s CountUom=$p(tmpData,"^",3)
	..s:CountUom'="" CountUomDesc=$p(^CT("UOM",CountUom),"^",2)
	..s CountDate=$p(tmpData,"^",4)
	..s:CountDate'="" CountDate=$zd(CountDate,3)
	..s CountTime=$p(tmpData,"^",5)
	..s:CountTime'="" CountTime=$zt(CountTime)
	..s CountUser=$p(tmpData,"^",6)
	..s:CountUser'="" CountUserName=$p(^SSU("SSUSR",CountUser),"^",2)
	..s FreQty=##class(web.DHCST.INStkTkItmWd).GetItmFreezeQty(Inst,Inci)
	..s FreezeQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,FreQty)
	..s Count=Count+1
	..s Data=$g(CountUomDesc)_"^"_CountQty_"^"_CountDate_"^"_CountTime_"^"_$g(CountUserName)_"^"_FreezeQtyUom
	..d json.InsertRowData(Data)
	.
	.s ResultString=json.getJsonData("FreUomDesc^CountQty^CountDate^CountTime^CountUserName^FreQty",Count)
	
	k json
	k ^TMPDHCST("InStkTkItm",Pid)
	q ResultString
}

}
