Import sqluser

/// Descript:实盘录入（按品种）相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-07
/// 
Class web.DHCST.InStkTkInput Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:根据帐盘记录生成实盘数据列表（实盘方式三）
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:盘点主表id,盘点人id
/// Output:		
/// Return：成功：0；
/// -2   ;保存失败
/// -1   ;盘点id不能为空
/// 改为单条事务,yunhaibao20151211
ClassMethod CreateStkTkInput(Inst As %String, User As %String, InputWin As %String) As %String
{
 n (Inst,User,InputWin)
 q:Inst="" -1
 s Ret=0
 s i=0
 s Inci=0
 s $ZT="Error^DHCSTERROR"
 f  s Inci=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci)) q:(Inci="")!(Ret'=0)  d
 .s UomId=$p(^INCI(Inci,1),"^",10)  ;基本单位 hulihua 2015-11-21  此处统一存基本单位，保证和大小单位录入方式一致！
 .s Chl=""
 .i InputWin'="" d
 ..s Chl=$o(^DHCINST(Inst,"STP",0,"WININCI",InputWin,Inci,0))	;修改索引,判断窗口
 .e  d
 ..&sql(select DHCSTI_ChildSub into :Chl from dhc_instktkinput where DHCSTI_Parref=:Inst and DHCSTI_INCI_DR=:Inci and DHCSTI_PHW_DR is null)
 .q:Chl'=""  ;已经生成了实盘项目
 .s Data=Inst_"^"_Inci_"^"_UomId_"^^"_User_"^"_InputWin
 .ts
 .s Rett=..Insert(Data)
 .i +Rett<=0  d
 ..tro
 ..s Ret=-2
 .q:+Rett<=0
 .tc
 q:Ret<0 Ret
 q 0
}

/// 批量保存实盘表记录
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:实盘表id^盘点主表id^药品id^单位id^实盘数^实盘人id，
/// 实盘表id^盘点主表id^药品id^单位id^实盘数^实盘人id，
/// Output:		
/// Return：成功：0；
/// -2   ;保存失败
/// -1   ;盘点id不能为空
/// 
ClassMethod Save(ListData As %String) As %String
{
	n (ListData)
	q:ListData="" -1
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(ListData,rowDelim)
	s Err=""
	;
	s Count=0
	f i=1:1:len  d
	.s Data=$p(ListData,rowDelim,i)
	.q:Data=""
	.s Parref=$p(Data,"^",2)
	.s Rowid=$p(Data,"^",1)
	.s Inci=$p(Data,"^",3)
	.s UomId=$p(^INCI(Inci,1),"^",10)  ;基本单位 hulihua 2015-11-21  此处统一存基本单位，保证和大小单位录入方式一致！
	.s PCountQty=$p(Data,"^",4)
	.s UserId=$p(Data,"^",5)
	.s InputWin=$p(Data,"^",6)
	.s BCountQty=$p(Data,"^",7)
	.s IncDesc=$p(^INCI(Inci,1),"^",2)
	.i Rowid'=""  d
	..s Detail=Rowid_"^"_UomId_"^"_PCountQty_"^"_UserId_"^"_BCountQty_"^"_Inci
	..s ret=..Update(Detail)
	..i ret'=0  d
	...s Err=Err_","_IncDesc
	..e  d
	...s Count=Count+1
	..
	.e  d
	..s Detail=Parref_"^"_Inci_"^"_UomId_"^"_PCountQty_"^"_UserId_"^"_InputWin_"^"_BCountQty
	..s ret=..Insert(Detail)
	..i +ret<=0  d
	...s Err=Err_","_IncDesc
	..e  d
	...s Count=Count+1
	.
	q:Count=0 -2   				;全部保存失败
	q:Err'="" -3_":"_Err		;部分保存失败
	q 0							;保存成功
}

/// Descript:插入实盘表记录
/// Creater:ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:盘点主表id^药品id^单位id^实盘数^实盘人id^	
/// Output:		
/// Return：成功：实盘表id；
/// -3    ;保存失败	
ClassMethod Insert(Data) As %Library.String
{
	n (Data)
	s Inst=$P(Data,"^",1)
	s IncId=$p(Data,"^",2)
	s UomId=$p(Data,"^",3)  //基本单位
	s CountDate=+$h
	s CountTime=$p($h,",",2)
	s UserId=$p(Data,"^",5)
	s InputWin=$p(Data,"^",6)
	s PCountQty=$p(Data,"^",4)
	s BCountQty=$p(Data,"^",7)
	s buom=$p(^INCI(IncId,1),"^",10)
	s puom=$p(^INCI(IncId,3),"^",6)
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	s TotalCountQty=$s((BCountQty'="")||(PCountQty'=""):+BCountQty+(+PCountQty*fac),1:"")
	s Err=0
	s Chl=+$o(^DHCINST(Inst,"STP",""),-1)+1
	&sql(insert into DHC_InStkTkInput(DHCSTI_Parref,DHCSTI_ChildSub,DHCSTI_INCI_DR,
		 DHCSTI_Uom_Dr,DHCSTI_CountQty,DHCSTI_CountUser_Dr,DHCSTI_CountDate,DHCSTI_CountTime,DHCSTI_PHW_DR,DHCSTI_QtyPuom,DHCSTI_QtyBuom) 
		 values (:Inst,:Chl,:IncId,:UomId,:TotalCountQty,:UserId,:CountDate,:CountTime,:InputWin,:PCountQty,:BCountQty))
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_InStkTkInput",Inst,SQLCODE_":"_%msg)
	.s Err=-3
	.
	q:Err'=0 -3    ;保存失败
	;
	q $p($g(%ROWID),$c(1))
}

/// Descript:更新实盘表记录
/// Creater:ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:rowid^单位id^实盘数^实盘人id
/// Output:		
/// Return：成功：0；
/// -2    ;失败	
ClassMethod Update(Data) As %Library.String
{
	n (Data)
	s Rowid=$P(Data,"^",1)
	s UomId=$p(Data,"^",2)
	s CountDate=+$h
	s CountTime=$p($h,",",2)
	s PCountQty=$p(Data,"^",3)
	s:PCountQty="" PCountQty=0
	s UserId=$p(Data,"^",4)
	s BCountQty=$p(Data,"^",5)
	s:BCountQty="" BCountQty=0
	s IncId=$p(Data,"^",6)
	s buom=$p(^INCI(IncId,1),"^",10)
	s puom=$p(^INCI(IncId,3),"^",6)
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	s TotalBCountQty=BCountQty+(PCountQty*fac)
	;
	s Err=0
	&sql(Update DHC_InStkTkInput set DHCSTI_Uom_Dr=:UomId,DHCSTI_CountQty=:TotalBCountQty,DHCSTI_QtyPuom=:PCountQty,
		DHCSTI_QtyBuom=:BCountQty,DHCSTI_CountUser_Dr=:UserId,DHCSTI_CountDate=:CountDate,DHCSTI_CountTime=:CountTime
	    where DHCSTI_Rowid=:Rowid) 
	    
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InStkTkInput",Rowid,SQLCODE_":"_%msg)
	.s Err=-2
	.
	q:Err'=0 -2    ;更新失败
	;
	q 0
}

/// Descript:查询实盘表记录
/// Creater:ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:开始行,一页显示记录数,排序字段，排序方向,
/// 管理组^类组^库存分类^货位^实盘窗口
/// Output:		
/// Return：成功：0；
/// -2    ;失败	
/// w ##class(web.DHCST.InStkTkInput).Query("0","30","stkbin","ASC","23^^3^^1^^")
ClassMethod Query(Start As %String, Limit As %String, Sort As %String, Dir As %String, Params As %String) As %Library.String
{
	n (Start,Limit,Sort,Dir,Params)
	s ^YSJTMP("Query")=$LB(Start,Limit,Sort,Dir,Params)
	k InStkTkInputQueryDATA
	s Inst=$p(Params,"^",1)
	q:Inst="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s ManGrp=$p(Params,"^",2)
	s StkGrpId=$p(Params,"^",3)
	s StkCatId=$p(Params,"^",4)
	s StkBin=$p(Params,"^",5)
	s InputWin=$p(Params,"^",6)
	s InciRowid=$p(Params,"^",7) //add wyx 2013-11-19 增加库存项过滤
  	s Dir=$$ALPHAUP^SSUTIL4(Dir)
 	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
	s sql="select DHCSTI_Rowid rowid,"
	s sql=sql_"DHCSTI_Parref parref,"
	s sql=sql_"DHCSTI_INCI_DR inci,"
	s sql=sql_"DHCSTI_INCI_DR->inci_code code,"
	s sql=sql_"DHCSTI_INCI_DR->inci_desc descx,"
	s sql=sql_"DHCSTI_Uom_Dr uom,"
	s sql=sql_"DHCSTI_Uom_Dr->ctuom_desc uomDesc,"
	s sql=sql_"DHCSTI_CountQty countQty,"
	s sql=sql_"DHCSTI_countDate countDate,"
	s sql=sql_"DHCSTI_counttime countTime,"
	s sql=sql_"DHCSTI_CountUser_Dr->ssusr_name userName,"
	s sql=sql_"DHCSTI_QtyPuom pcountQty,"
	s sql=sql_"DHCSTI_QtyBuom bcountQty,"
	s sql=sql_"DHCSTI_PHW_DR win "
	s sql=sql_" from dhc_instktkinput"
	s sql=sql_" where DHCSTI_Parref="_Inst
	s xrs=##class(%ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:$$$ISERR(sc) ""
	s countrecords = 0
	s pid=..NewPid()
	s $zt="ErrorQuery"
	s nullStkBin=##class(web.DHCST.INStkTk).#NullStkBin
	s End = Start+Limit
	s Start=Start+1
	while (xrs.Next())
	{
		 s ret=0
		 s win=xrs.Data("win")
		 continue:win'=InputWin		;实盘窗口过滤
		 s inci=xrs.Data("inci")
		 continue:(InciRowid'="")&(InciRowid'=inci)
		 s locId=$p(^DHCINST(Inst),"^",5)
		 ;管理组过滤
		 i ManGrp'="" d
		 .s mangrp=##class(web.DHCST.Common.DrugStkCommon).ManGrp(inci,locId)
		 .i ManGrp'=mangrp s ret=-1
		 continue:ret<0
		 ;类组过滤
		 s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
		 s GrpId=$p(StkGrpInfo,"^",5)
		 continue:(StkGrpId'="")&(GrpId'=StkGrpId)
		 s Incsc=$p(^INCI(inci,2),"^",2)
		 continue:(StkCatId'="")&(Incsc'=StkCatId)
		 s incich=$o(^INCI("IL_LOC",locId,inci,""),-1)
		 s incil=inci_"||"_incich
		 s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","")
    	 s stkbinstr=$p(stkbinret,":",2)
    	 s StkBinDesc=""
    	 i StkBin'="" s StkBinDesc=$p(^INC("SB",StkBin),"^",2) 
		 continue:(StkBin'="")&($lf($lfs(stkbinstr),StkBinDesc)'>0)  //yunhaibao,20151210,取新货位,以及过滤
		 s rowid=xrs.Data("rowid")
		 s instinputnum=$p(rowid,"||",2)
		 s parref=xrs.Data("parref")	 
		 s code=xrs.Data("code")
		 s desc=xrs.Data("descx")
		 s uom=$p(^INCI(inci,1),"^",10) 
		 s uomDesc=$p(^CT("UOM",uom),"^",2)
		 s pUom=$p(^INCI(inci,3),"^",6)
	 	 s pUomdesc=$p(^CT("UOM",pUom),"^",2)
		 s bUom=$p(^INCI(inci,1),"^",10)
		 s bUomdesc=$p(^CT("UOM",bUom),"^",2)
		 s countQty=xrs.Data("countQty")
		 s countDate=xrs.Data("countDate")
		 i countDate'="" s countDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(countDate,"ST")
		 s countTime=xrs.Data("countTime")
		 i countTime'="" s countTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(countTime,"ST")
		 s userName=xrs.Data("userName")
		 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
		 s freQtyBuom=..SumFreQty(Inst,inci) 
		 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
		 s freQty=freQtyBuom  // /fac  //帐盘数,基本单位
		 s bcountQty=xrs.Data("bcountQty") 
         s pcountQty=xrs.Data("pcountQty")
		 s data=rowid_"^"_parref_"^"_inci_"^"_code_"^"_desc_"^"_spec_"^"_uom_"^"_uomDesc_"^"_countQty_"^"_countDate_"^"_countTime_"^"_userName_"^"_freQty_"^"_stkbinstr_"^"_ pcountQty_"^"_bcountQty_"^"_pUomdesc_"^"_bUomdesc_"^"_fac
		 s firstStkbindesc=$p(stkbinstr,",",1)
		 i Sort="stkbin" d
		 .s index=firstStkbindesc
		 .i index="" s index=nullStkBin
		 e  i Sort="code" s index=code
		 e  i Sort="desc" s index=desc
		 e  i Sort="freQty" s index=freQty
		 e  s index=instinputnum
		 i index="" s index=1
		 s countrecords=countrecords+1
		 s InStkTkInputQueryDATA(index,instinputnum)=data
	}
	i countrecords=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:countrecords=0 ""
	i End>countrecords s End=countrecords 
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
	s Title="rowid^parref^inci^code^desc^spec^uom^uomDesc^countQty^countDate^countTime^userName^freQty^stkbin^pcountQty^bcountQty^puomdesc^buomdesc^fac"
	s count=0
	s outputi=""
	f  s outputi=$o(InStkTkInputQueryDATA(outputi),orderflag) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(InStkTkInputQueryDATA(outputi,outputj),orderflag) q:outputj=""  d	
	..s count = count+1
	..q:count<Start
	..q:count>End
	..s outputdata=InStkTkInputQueryDATA(outputi,outputj)
	..i count=Start d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(countrecords)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w ","_retstring
	w "]}"
	q ""
ErrorQuery
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 查询盘点单中inci的账盘数(基本单位)
/// Input: inst 盘点单rowid, inci 库存项
ClassMethod SumFreQty(inst As %String, inci As %String) As %String
{
	n (inst,inci)
	q:inst="" 0
	q:inci="" 0
	s sumFreQty=0
	s ch=0
	f  s ch=$o(^DHCINST(inst,"STI1",0,"INCI",inci,ch)) q:ch=""  d
	.s freQty=$p(^DHCINST(inst,"STI",ch),"^",2)
	.s sumFreQty=sumFreQty+freQty
	.
	q sumFreQty
}

/// 查询按品种实盘盘点单中的实盘数
/// Input: inst 盘点单rowid, inci 库存项
ClassMethod SumCountQty(inst As %String, inci As %String) As %String
{
	n (inst,inci)
	q:inst="" 0
	q:inci="" 0
	s countQtyBuom=0
	s unInput=1
	s ch=0
	f  s ch=$o(^DHCINST(inst,"STP",0,inci,ch)) q:ch=""  d
	.s countQty=$p(^DHCINST(inst,"STP",ch),"^",2)
	.i countQty'="" s unInput=""
	.s countQtyBuom=countQtyBuom+countQty
	s:(countQtyBuom=0)&&(unInput=1) countQtyBuom=""
	q countQtyBuom
}

/// 实盘录入(按品种)完成, 按批次从后之前填写实盘数,多出冻结数量的部分存放在效期最近的一个批次
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:盘点主表id, 人员id, 未盘点库存项处理方式(0:默认为0, 1:默认为帐盘数)
/// Output:		
/// Return：成功：0；
/// -1   ;失败
/// wangjiabin 2013-09-25 Modified
ClassMethod CompleteInput(Inst As %String, User As %String, InputNullFlag As %String) As %String
{
	n (Inst,User,InputNullFlag)
	q:Inst="" -1
	s Loc=$p(^DHCINST(Inst),"^",5)
	s HospID=$p(^CTLOC(Loc),"^",22)
	s SelBatFlag=##Class(web.DHCSTCOMMPARA).GetSelBatRule(HospID)	//选择批次索引规则
	s Err=0
	q:##class(web.DHCST.Common.AppCommon).Lock("DHCSTINSTKTK"_Inst)<0 -99
	s Pid=..NewPid()
	s Inci=0
	s $ZT="Error^DHCSTERROR"
	s cnt=0
	f  s Inci=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci)) q:(Inci="")!(Err'=0)  d
	.s bUom=$p(^INCI(Inci,1),"^",10)
	.i '$d(^DHCINST(Inst,"STP",0,Inci)) d
	..i InputNullFlag=1 d
	...s CountQtyBuom=..SumFreQty(Inst,Inci)
	..e  d
	...s CountQtyBuom=0 //默认为0
	.e  d
	..s chl=$o(^DHCINST(Inst,"STP",0,Inci,""))
	..s InputCountQty=..SumCountQty(Inst,Inci)     //基本单位数量
	..//modify wyx 2015-01-20 
	..s CountQty1="",CountQty2="",CountQty3=""
	..i (InputCountQty="")&(InputNullFlag=1) d 
	...s CountQty1=..SumFreQty(Inst,Inci) //基本单位数量
	..e  i (InputCountQty="")&(InputNullFlag'=1) d 
	...s CountQty2=0 //默认为0
	..e  s CountQty3=InputCountQty
	..s UomId=$p(^DHCINST(Inst,"STP",chl),"^",3)
	..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,bUom)
	..i CountQty1'="" d
	...s CountQtyBuom=CountQty1
	..i CountQty2'="" d
	...s CountQtyBuom=0
	..i CountQty3'="" d
	...s CountQtyBuom=CountQty3*fac
	..//modify wyx 2015-01-20 CountQtyBuom为基本单位数量为下面的分配程序准备，dhc_instktkinput里的数量不一定是基本单位
	..q:(..IfUpdateCountQty(Inst,Inci)=1) //Modified hulihua 2015-11-23 对于填了数量的不需要更新，对于默认填的只更新第一条的总数量
	..s Rowid=Inst_"||"_chl
	..s UomId=$p(^DHCINST(Inst,"STP",chl),"^",3)
	..s UserId=$p(^DHCINST(Inst,"STP",chl),"^",6)
	..s Detail=Rowid_"^"_UomId_"^^"_UserId_"^"_CountQtyBuom_"^"_Inci
	..s ret=..Update(Detail)
	.ts
	.k ^TMP("DHCST",$ClassName(),"CompleteInput","SelBatch",Pid)
	.s Chl=""
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl),-1) q:(Chl="")!(Err'=0)  d
	..s Insti=Inst_"||"_Chl
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s Incib=$P(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s (DateAdd,TimeAdd)="0"
	..s Dhcincib=$o(^DHCINCIB(0,"INCIB",Incib,""))
    ..i Dhcincib'="" d
 	...s DateAdd=+$p(^DHCINCIB(Dhcincib),"^",10)
 	...s TimeAdd=+$p(^DHCINCIB(Dhcincib),"^",11)
	..s ExpDate=+$p(^DHCINST(Inst,"STI",Chl),"^",20)
	..i SelBatFlag=1 d
	...s Index1=+ExpDate				//有效期优先
	...s Index2=DateAdd*100000+TimeAdd
	..e  d
	...s Index1=DateAdd*100000+TimeAdd	//先进先出
	...s Index2=ExpDate
	..s ^TMP("DHCST",$ClassName(),"CompleteInput","SelBatch",Pid,Index1,Index2,Insti)=""
	.s LatelyExp=""     ;最近的效期
	.s SelInsti=""		;效期最近的帐盘明细
	.s Index1=""
	.f  s Index1=$o(^TMP("DHCST",$ClassName(),"CompleteInput","SelBatch",Pid,Index1)) q:(Index1="")!(Err'=0)  d
	..s Index2=""
	..f  s Index2=$o(^TMP("DHCST",$ClassName(),"CompleteInput","SelBatch",Pid,Index1,Index2)) q:(Index2="")!(Err'=0)  d
	...s Insti=""
	...f  s Insti=$o(^TMP("DHCST",$ClassName(),"CompleteInput","SelBatch",Pid,Index1,Index2,Insti)) q:(Insti="")!(Err'=0)  d
	....s Chl=$p(Insti,"||",2)
	....s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	....s FreezeQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	....s FreezeUomId=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	....s FreezeQtyUom=FreezeQty		;冻结数以基本单位计
	....s ExpDate=+$p(^DHCINST(Inst,"STI",Chl),"^",20)
	....s rp=$P(^DHCINST(Inst,"STI",Chl),"^",30)
	....s sp=$P(^DHCINST(Inst,"STI",Chl),"^",28)
	....
	....i LatelyExp=""  d
	.....s LatelyExp=ExpDate
	.....s SelInsti=Insti
	....e  d
	.....i ExpDate>LatelyExp  d
	......s LatelyExp=ExpDate
	......s SelInsti=Insti
	.....
	....;分配实盘数量
	....i CountQtyBuom>=FreezeQtyUom  d
	.....s InclbCountQty=FreezeQtyUom
	.....s CountQtyBuom=CountQtyBuom-FreezeQtyUom
	....e  i FreezeQtyUom>0  d
	.....s InclbCountQty=CountQtyBuom
	.....s CountQtyBuom=0
	....e  i FreezeQtyUom=0  d
	.....s InclbCountQty=0
	....i InclbCountQty<0 s InclbCountQty=0
	....//s spAmt=sp*InclbCountQty
	....//s rpAmt=rp*InclbCountQty
	....//s spAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spAmt,HospID)
 	....//s rpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,HospID)
 	....s rpAmt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(Inclb, InclbCountQty, bUom, HospID)
 	....s spAmt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(Inclb, InclbCountQty, bUom, HospID)
 	
	....s obj=##class(User.DHCInStkTkItm).%OpenId(Insti)
	....d obj.%Reload()
	....d obj.INSTICount1PersonDRSetObjectId(User)
	....s obj.INSTICount1Qty=+InclbCountQty
	....s obj.INSTICount1Date=+$H
	....s obj.INSTICount1Time=$P($H,",",2)
	....s obj.INSTICount1SpAmt=spAmt
	....s obj.INSTICount1RpAmt=rpAmt
	....//s varQty=obj.INSTICount1Qty-FreezeQty
	....s varQty=+InclbCountQty-FreezeQty
	....s obj.INSTIVariance1=varQty
	....s obj.INSTIVariance1RpAmt=obj.INSTICount1RpAmt-obj.INSTIFreezeRpAmt
	....s obj.INSTIVariance1SpAmt=obj.INSTICount1SpAmt-obj.INSTIFreezeSpAmt
	....s sc=obj.%Save()
	....s cnt=cnt+1
	....i $$$ISERR(sc) tro   s Err=-5 
	....q:Err=-5 
	.k ^TMP("DHCST",$ClassName(),"CompleteInput","SelBatch",Pid)
	.q:Err'=0
	.;多出的实盘数保存至效期最新的一个批次
	.i CountQtyBuom>0  d
	..s rp=$P(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2)),"^",30)
	..s sp=$P(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2)),"^",28)
	..s excessRpAmt=rp*CountQtyBuom
	..s excessSpAmt=sp*CountQtyBuom
	..s excessSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(excessSpAmt,HospID)
 	..s excessRpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(excessRpAmt,HospID)
	..s obj=##class(User.DHCInStkTkItm).%OpenId(SelInsti)
	..d obj.%Reload()
	..s obj.INSTICount1Qty=obj.INSTICount1Qty+CountQtyBuom
	..s obj.INSTICount1SpAmt=obj.INSTICount1SpAmt+excessSpAmt
	..s obj.INSTICount1RpAmt=obj.INSTICount1RpAmt+excessRpAmt
	..s obj.INSTIVariance1=obj.INSTIVariance1+CountQtyBuom
	..s obj.INSTIVariance1RpAmt=obj.INSTICount1RpAmt-obj.INSTIFreezeRpAmt
	..s obj.INSTIVariance1SpAmt=obj.INSTICount1SpAmt-obj.INSTIFreezeSpAmt
	..s sc=obj.%Save()
	..i $$$ISERR(sc) tro   s Err=-6 
	..q:Err=-6 
	.q:Err'=0
	.tc
	q:Err'=0 Err
	i Err<0  d ##class(web.DHCST.Common.AppCommon).UnLock("DHCSTINSTKTK"_Inst) q Err  //
	s compelete="Y"
	&sql(update DHC_instktk  set inst_stocktakecomplete=:compelete where inst_rowid =:Inst)
	i SQLCODE'=0 s Err= -100
	d ##class(web.DHCST.Common.AppCommon).UnLock("DHCSTINSTKTK"_Inst)
	q Err
}

ClassMethod NewPid()
{
	q $i(^DHCSTPID("InStkTkInput"))
}

/// Description:判断是否更新DHC_InStkTkInput里面的数量
/// Creator:	hulihua
/// CreateDate:	2015-11-23
/// Table:      DHC_InStkTkInput
/// Input:		inst 盘点单rowid, inci 库存项
/// Output:		
/// Return：    1-不需要，0-需要
/// w ##class(web.DHCST.InStkTkInput).IfUpdateCountQty("702","74")
/// w ##class(web.DHCST.InStkTkInput).IfUpdateCountQty("702","8651")
ClassMethod IfUpdateCountQty(inst As %String, inci As %String) As %String
{
	n (inst,inci)
	q:inst="" 1
	q:inci="" 1
	s Flag=0
	s ch=0
	f  s ch=$o(^DHCINST(inst,"STP",0,inci,ch)) q:(ch="")||(Flag=1)  d
	.s countQty=$p(^DHCINST(inst,"STP",ch),"^",2)
	.s:countQty'="" Flag=1
	q Flag
}

/// 检索盘点帐盘表明细
/// Author:zhwh
/// Date:2012-08-02
/// Argu:
/// qPar  -查询参数
/// Inst -盘点主表rowid
/// d ##class(%ResultSet).RunQuery("web.DHCST.InStkTkInput","DHCSTInStkTkTotal",5)
Query DHCSTInStkTkTotal(Inst As %String) As websys.Query(ROWSPEC = "rowid,parref,inci,code,desc,spec,uom,uomDesc,countQty,countDate,countTime,userName,freQty,stkbinstr, pcountQty,bcountQty,pUomdesc,bUomdesc,fac,freQtyWithUom,HospDescIO,LocDescIO") [ SqlProc ]
{
}

ClassMethod DHCSTInStkTkTotalExecute(ByRef qHandle As %Binary, Inst As %String) As %Status
{
 

 //&SQL(UPDATE DHC_LocGroup SET LG_LOCGROUPCODE=:Inst)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Inst="" $$$OK
 
 // HospDescIO,LocDescIO
 s loc=$P(^DHCINST(Inst),"^",5)
 s LocDescIO=$P(^CTLOC(loc),"^",2)
 s HospDescIO=$P(^CTLOC(loc),"^",22)
 s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
 
	k InStkTkInputQueryDATA
	s sql="select DHCSTI_Rowid rowid,"
	s sql=sql_"DHCSTI_Parref parref,"
	s sql=sql_"DHCSTI_INCI_DR inci,"
	s sql=sql_"DHCSTI_INCI_DR->inci_code code,"
	s sql=sql_"DHCSTI_INCI_DR->inci_desc descx,"
	s sql=sql_"DHCSTI_Uom_Dr uom,"
	s sql=sql_"DHCSTI_Uom_Dr->ctuom_desc uomDesc,"
	s sql=sql_"DHCSTI_CountQty countQty,"
	s sql=sql_"DHCSTI_countDate countDate,"
	s sql=sql_"DHCSTI_counttime countTime,"
	s sql=sql_"DHCSTI_CountUser_Dr->ssusr_name userName,"
	s sql=sql_"DHCSTI_QtyPuom pcountQty,"
	s sql=sql_"DHCSTI_QtyBuom bcountQty,"
	s sql=sql_"DHCSTI_PHW_DR win "
	s sql=sql_" from dhc_instktkinput"
	s sql=sql_" where DHCSTI_Parref="_Inst
	s xrs=##class(%ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	q:$$$ISERR(sc) $$$OK
	
	s countrecords = 0
	s nullStkBin=##class(web.DHCST.INStkTk).#NullStkBin
	while (xrs.Next())
	{
		 s ret=0
		 s win=xrs.Data("win")
		 s inci=xrs.Data("inci")
		 s locId=$p(^DHCINST(Inst),"^",5)
		 s incich=$o(^INCI("IL_LOC",locId,inci,""),-1)
		 s incil=inci_"||"_incich
		 s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","")
    	 s stkbinstr=$p(stkbinret,":",2)
		 s rowid=xrs.Data("rowid")
		 s instinputnum=$p(rowid,"||",2)
		 s parref=xrs.Data("parref")	 
		 s code=xrs.Data("code")
		 s desc=xrs.Data("descx")
		 s uom=$p(^INCI(inci,1),"^",10) 
		 s uomDesc=$p(^CT("UOM",uom),"^",2)
		 s pUom=$p(^INCI(inci,3),"^",6)
	 	 s pUomdesc=$p(^CT("UOM",pUom),"^",2)
		 s bUom=$p(^INCI(inci,1),"^",10)
		 s bUomdesc=$p(^CT("UOM",bUom),"^",2)
		 s countQty=xrs.Data("countQty")
		 s countDate=xrs.Data("countDate")
		 i countDate'="" s countDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(countDate,"ST")
		 s countTime=xrs.Data("countTime")
		 i countTime'="" s countTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(countTime,"ST")
		 s userName=xrs.Data("userName")
		 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
		 s freQtyBuom=##Class(web.DHCST.InStkTkInput).SumFreQty(Inst,inci) 
		 s freQtyWithUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(inci,freQtyBuom)
		 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
		 s freQty=freQtyBuom  // /fac  //帐盘数,基本单位
		 s bcountQty=xrs.Data("bcountQty") 
         s pcountQty=xrs.Data("pcountQty")
		 //s data=rowid_"^"_parref_"^"_inci_"^"_code_"^"_desc_"^"_spec_"^"_uom_"^"_uomDesc_"^"_countQty_"^"_countDate_"^"_countTime_"^"_userName_"^"_freQty_"^"_stkbinstr_"^"_ pcountQty_"^"_bcountQty_"^"_pUomdesc_"^"_bUomdesc_"^"_fac
		 s data=$LB(rowid,parref,inci,code,desc,spec,uom,uomDesc,countQty,countDate,countTime,userName,freQty,stkbinstr, pcountQty,bcountQty,pUomdesc,bUomdesc,fac,freQtyWithUom,HospDescIO,LocDescIO)
		 s firstStkbindesc=$p(stkbinstr,",",1)
		 s index=firstStkbindesc
		 s index="" s index=nullStkBin
		 s countrecords=countrecords+1
		 s InStkTkInputQueryDATA(index,instinputnum)=data
	}
	i countrecords=0 q $$$OK
	
    s num=0
	s outputi=""
	f  s outputi=$o(InStkTkInputQueryDATA(outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(InStkTkInputQueryDATA(outputi,outputj)) q:outputj=""  d	
	..s num=num+1
	..s outputdata=InStkTkInputQueryDATA(outputi,outputj)
	..s $list(outputdata,1)=num
	..d OutPutRoww
 
   Quit $$$OK
OutPutRoww
 s Data=outputdata
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// w ##class(web.DHCST.InStkTkInput).SetInputDefaultQty("291","12359","2","")
ClassMethod SetInputDefaultQty(Inst, UserId, Flag, InstwWin)
{
	n (Inst,UserId,Flag,InstwWin)
	//s ^zouxtmp("SetInputDefaultQty")=$lb(Inst, UserId, Flag, InstwWin)
	q:Inst="" -1
	s Count=0
	s Err=""
	s chl=""
	f  s chl=$o(^DHCINST(Inst,"STP",chl)) q:chl=""  d
	.s chlData=$g(^DHCINST(Inst,"STP",chl))
	.q:chlData=""
	.s phwDr=$p(chlData,"^",7)
	.q:phwDr'=InstwWin   //窗口不同
	.s Inci=$p(chlData,"^",1)
	.s countQty=$p(chlData,"^",2)
	.q:countQty'=""
	.s bUom=$p(^INCI(Inci,1),"^",10)
	.s pUom=$p(^INCI(Inci,3),"^",6)
	.s IncDesc=$p(^INCI(Inci,1),"^",2)
	.s countPQty="",countBQty=""
	.i Flag=2 d  //设置未填数等于账盘数
	..s freQty=..SumFreQty(Inst,Inci) //账盘基本单位数量
	..s UomId=$p(chlData,"^",3)
	..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,bUom)
	..s PBFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
	..s countPQty=freQty\PBFac
	..s countBQty=freQty#PBFac
	.e  i ((Flag=0)||(Flag=1)) s countPQty=0,countBQty=0
	.q:(countPQty="")&(countBQty="")
	.s Rowid=Inst_"||"_chl
	.s Detail=Rowid_"^"_bUom_"^"_countPQty_"^"_UserId_"^"_countBQty_"^"_Inci
	.s ret=..Update(Detail)
	.i +ret<0  d
	..s Err=Err_","_IncDesc
	.e  d
	..s Count=Count+1
	q:Err'="" -3_":"_Err		;部分保存失败
	q 0
}

}
