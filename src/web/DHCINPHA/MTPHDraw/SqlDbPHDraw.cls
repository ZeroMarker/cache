Import sqluser

/// Description:备药单操作相关(采用SQL的形式)
/// Creator:    hulihua
/// CreateDate: 2017-03-21
/// Table:      DHC_PHDraw、DHC_PHDrawInc、DHC_PHDrawOrder
Class web.DHCINPHA.MTPHDraw.SqlDbPHDraw Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Drescript:	保存请领单信息生成备药单信息（请领单界面）
/// Creator:	yaoxin
/// CreateDate:	2017-03-10
/// Input:		ApplyStr(请领单字符串),PhaLocID(发药科室ID),WardLocDr(病区科室ID),ReqType(请领类型),UserID(备药人ID)
/// Return:	    插入DHC_PHDraw，DHC_PHDrawInc，DHC_PHDrawOrder 更新DHC_InPhReq
/// w ##Class(web.DHCINPHA.MobilePHA).SavePrepareDurg("59919","102","152","1","5773")
ClassMethod SavePrepareDurg(ApplyStr As %Text, PhaLocID As %String, WardLocID As %String, DrawType As %String, UserID As %String) As %String
{
	n (ApplyStr,PhaLocID,WardLocID,DrawType,UserID)
	s ^yx("SavePrepareDurg")=$lb(ApplyStr,PhaLocID,WardLocID,DrawType,UserID)
	q:PhaLocID="" -1
	q:WardLocID="" -2
	s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocID,""))
 	q:WardId="" -3
 	q:DrawType="" -4
 	q:UserID="" -5
 	q:ApplyStr="" -6
 	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTPHDraw.SqlDbPHDraw")
	s ItmNum=..GetDispDrug(pid,ApplyStr,PhaLocID,WardLocID,DrawType)
	q:ItmNum=0 0
	s SortDr=""	//默认排序1
	i SortDr="" d
	.s SortDr=$o(^DHCPHDWSORTi("PHLoc",PhaLocID,""))
	
	s $ZT="Error^DHCSTERROR"
	tstart
	s SqlStr=PhaLocID_"^"_WardLocID_"^"_DrawType_"^"_UserID_"^"_SortDr
	s DrawID=..InsPHDraw(SqlStr)
	i DrawID<0 trollback 
	q:DrawID<0 DrawID
	
	s ErrInfo=..UpdateDHCInPhReqData(ApplyStr,DrawID)
	i ErrInfo'="" trollback 
	q:ErrInfo'="" -7
	
	s Index="",errflag=0
 	f  s Index=$o(^TMP("DHCINPHA","web.DHCINPHA.MTPHDraw.SqlDbPHDraw","GetDispDrug",pid,Index)) q:(Index="")!(errflag'=0)  d
 	.s dspQty=^(Index)
 	.s incID=$p(Index,",",1)
 	.s PackFlag=$p(Index,",",2)
 	.s uomID=$p(^INCI(incID,1),"^",10)
 	.s SqlStr=DrawID_"^"_incID_"^"_dspQty_"^"_uomID_"^"_PackFlag
 	.s DrawIncID=..InsPHDrawInc(SqlStr)
 	.i DrawIncID<0 trollback 
 	.i DrawIncID<0 d
 	..s errflag=-12
 	.s inum=0
 	.f  s inum=$o(^TMP("DHCINPHA","web.DHCINPHA.MTPHDraw.SqlDbPHDraw","GetDispDrug",pid,Index,inum)) q:(inum="")!(errflag'=0)  d
 	..s gstr=^(inum)
 	..s DspBatch=$p(gstr,"^",1)
 	..s dspQty=$p(gstr,"^",2)
 	..s PHRIRowID=$p(gstr,"^",3) //请领单子表ID
 	..s SqlStr=DrawIncID_"^"_DspBatch_"^"_dspQty_"^"_PHRIRowID
 	..s DrawOrderID=..InsPHDrawOrder(SqlStr)
 	..i DrawOrderID<0 trollback 
 	..i DrawOrderID<0 d
 	...s errflag=-13
 	tcommit
 	s KillFlag=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).KillMesFlag(PhaLocID,WardLocID)
 	i KillFlag=1 k ^DHCINPHAPID("DHCINPHA","SetMessageByAudit",PhaLocID,WardLocID)	//开始备药的时候清空病区消息
 	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTPHDraw.SqlDbPHDraw","GetDispDrug",pid)
 	q errflag_"^"_DrawID //返回DrawID
}

/// Descript: 	新增备药记录
/// Creater：	zhouyg
/// CreateDate：2016-07-28
/// Table：		DHC_PHDraw
/// Input：		SqlStr=发药科室ID^病区科室ID^备药类型(1-送药，2-取药)^创建人ID^排序规则
/// Return：	>0，记录ID;<0，错误	
ClassMethod InsPHDraw(SqlStr As %String) As %Library.String
{
	n (SqlStr)
	s Err=0
	s PHLocDr=$P(SqlStr,"^",1)
	s WardLocDr=$P(SqlStr,"^",2)
	s PHDWType=$P(SqlStr,"^",3)
	s UserCreateDr=$P(SqlStr,"^",4)
	s SortDr=$P(SqlStr,"^",5)
	q:PHLocDr="" -101
	q:WardLocDr="" -102
	q:PHDWType="" -103
	q:UserCreateDr="" -104
    s ret=##class(web.DHCST.Common.AppCommon).Lock("PHDrawNo")  
    q:ret'=0 -99
    s AppName="DHCSTPHDraw"
    s No=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,"",PHLocDr)
    i No="" d ##class(web.DHCST.Common.AppCommon).UnLock("PHDrawNo")  // 这有可能没解锁
    q:No="" -105   ;生成单号失败
	s Status=20
	s DateCreate=$P($h,",",1)
	s TimeCreate=$P($h,",",2)
	i SortDr="" d
	.s SortDr=$o(^DHCPHDWSORT(0))
	&SQL(Insert Into DHC_PHDraw (PHDW_No,PHDW_PHLoc_Dr,PHDW_WardLoc_Dr,PHDW_Type,
			PHDW_Status,PHDW_UserCreate_Dr,PHDW_DateCreate,PHDW_TimeCreate,PHDW_Sort_Dr) 
		values(:No,:PHLocDr,:WardLocDr,:PHDWType,
		:Status,:UserCreateDr,:DateCreate,:TimeCreate,:SortDr))
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHDraw",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-100
	q:SQLCODE'=0 Err
	d ##class(web.DHCST.Common.AppCommon).UnLock("PHDrawNo")
	s RetID=$p($g(%ROWID),$c(1))
	q RetID
}

/// Descript: 	新增备药药品汇总表
/// Creater：	zhouyg
/// CreateDate：2016-07-28
/// Table：		DHC_PHDrawInc
/// Input：		SqlStr=主表ID^库存项ID^数量^单位
/// Return：	>0，记录ID;<0，错误	
ClassMethod InsPHDrawInc(SqlStr As %String) As %Library.String
{
	n (SqlStr)
	s Err=0
	s Parref=$P(SqlStr,"^",1)
	s InciDr=$P(SqlStr,"^",2)
	s QtyTotal=+$P(SqlStr,"^",3)
	s UomDr=$P(SqlStr,"^",4)
	s PackFlag=$P(SqlStr,"^",5)
	q:Parref="" -201
	q:InciDr="" -202
	q:QtyTotal=0 -203
	q:UomDr="" -204
    s ChildSub=$o(^DHCPHDRAW(Parref,"INC",""),-1)+1   
	&SQL(Insert Into DHC_PHDrawInc (PHDWI_PHDW_Parref,PHDWI_ChildSub,PHDWI_Inci_Dr,PHDWI_QtyTotal,PHDWI_Uom_Dr, PHDWI_PackFlag)
		values(:Parref,:ChildSub,:InciDr,:QtyTotal,:UomDr,:PackFlag))
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHDrawInc",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-200
	q:SQLCODE'=0 Err
	s RetID=$p($g(%ROWID),$c(1))
	q RetID
}

/// Descript: 	新增备药药品医嘱明细表
/// Creater：	zhouyg
/// CreateDate：2016-07-28
/// Table：		DHC_PHDrawOrder
/// Input：		SqlStr=DHC_PHDrawInc表ID^DHC_OEDispensing表ID^数量
/// Return：	>0，记录ID;<0，错误	
ClassMethod InsPHDrawOrder(SqlStr As %String) As %Library.String
{
	n (SqlStr)
	s Err=0
	s Parref=$P(SqlStr,"^",1)
	s dspBatchDr=$P(SqlStr,"^",2)
	s dspBatQty=+$P(SqlStr,"^",3)
	s PHRIRowID=$P(SqlStr,"^",4)
	q:Parref="" -301
	q:dspBatchDr="" -302
	q:dspBatQty=0 -303
	s dwID=$p(Parref,"||",1)
	s dwIncSub=$p(Parref,"||",2)
	s RefFlag="N"
	
    s dwOrderSub=$o(^DHCPHDRAW(dwID,"INC",dwIncSub,"ORDER",""),-1)+1 
	&SQL(Insert Into DHC_PHDrawOrder (PHDWO_PHDWI_Parref,PHDWO_ChildSub,PHDWO_DspBatch_Dr,PHDWO_Qty,PHDWO_RefFlag,PHDWO_PHRI_Dr)
		values(:Parref,:dwOrderSub,:dspBatchDr,:dspBatQty,:RefFlag,:PHRIRowID))
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHDrawOrder",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-300
	q:SQLCODE'=0 Err
	s RetID=$p($g(%ROWID),$c(1))
	q RetID
}

/// Drescript:	生成备药单时更新请领单主表
/// Creator:	yaoxin
/// CreateDate:	2017-03-10
/// Input:		ApplyStr(请领单字符串),DrawID(备药单主表ID)
/// Return:	    更新DHC_InPhReq字段，PHR_Draw_Dr(备药单主表ID)，PHR_Status(20药房备药中)
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetApplicationInfo","","114","1")
ClassMethod UpdateDHCInPhReqData(ApplyStr As %Text, DrawID As %String)
{
	q:ApplyStr="" -201
	
	q:DrawID=0 -203
	s Err=""
	s ApplyNum=$l(ApplyStr,",")
 	f index=1:1:ApplyNum d
 	.s ApplyId=$p(ApplyStr,",",index)
	.&SQL(Update DHC_InPhReq set PHR_Draw_Dr=:DrawID,PHR_Status='20' where PHR_RowID=:ApplyId)
	.i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InPhReq",ApplyStr,SQLCODE_":"_$g(%msg))
    ..s Err=-200
	.q:SQLCODE'=0 
	q Err
}

/// Descript: 	根据请领单字符串取待发药明细
/// Input：		药房科室ID,病区科室ID(CT_Loc)
/// Output:		汇总药品ID,药品描述,药品数量
/// Editor:		yaoxin
/// EditDate:	2017-03-10
ClassMethod GetDispDrug(pid As %String, ApplyStr As %Text, PhaLocID As %String, WardLocID As %String, DrawType As %String) As %String
{
	n (pid,ApplyStr,PhaLocID,WardLocID,DrawType)
	q:PhaLocID="" -1
	q:WardLocID="" -2
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTPHDraw.SqlDbPHDraw","GetDispDrug",pid)
 	s inum=0
 	s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocID,""))
 	q:WardId="" -3
 	
 	s ApplyNum=$l(ApplyStr,",")
 
 	f index=1:1:ApplyNum d
 	.s ApplyId=$p(ApplyStr,",",index)
 	.q:ApplyId=""
 	.s ApplySatue=$p(^DHCINPHREQ(ApplyId),"^",8)
 	.q:ApplySatue'="10"
 	.s PHRIChildSub=0
 	.f  s PHRIChildSub=$o(^DHCINPHREQ(ApplyId,"I",PHRIChildSub)) q:(PHRIChildSub="")  d
 	..s dspId=$p(^DHCINPHREQ(ApplyId,"I",PHRIChildSub),"^",1)
 	..s InPhReqDr=ApplyId_"||"_PHRIChildSub
 	..s Flag=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDispFlag(dspId,InPhReqDr)
 	..q:Flag=0
 	..s OrdItmRowid=$p(^DHCOEDISQTY(dspId),"^",1)	;OE_OrdItem表指针
 	..s Ord=$p(OrdItmRowid,"||",1)
    ..s Chl=$p(OrdItmRowid,"||",2)
    ..q:(Ord="")||(Chl="")
    ..;判断是否是整包装（西药）
    ..s DspQty=$p(^DHCOEDISQTY(dspId),"^",5)
    ..s DspUomDr=$p(^DHCOEDISQTY(dspId),"^",6)
    ..s DspCh=$o(^DHCOEDISQTY(dspId,"I",""),-1)
    ..S DspInci=$p(^DHCOEDISQTY(dspId,"I",DspCh),"^",5)
    ..S BUomId=$p(^INCI(DspInci,1),"^",10)
    ..S PurUomId=$p(^INCI(DspInci,3),"^",6)
    ..s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(DspUomDr,BUomId)
    ..s DspBQty=DspQty*Fac1
    ..s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    ..s DspQty=DspBQty#Fac2						;取余
	..s PackFlag=$s(DspQty=0:1,1:0) 			;整散标志（1-整包装，0-散包装）
	..;
    ..s PHRIRowID=ApplyId_"||"_PHRIChildSub
    ..s dspSubId=0
 	..f  s dspSubId=$o(^DHCOEDISQTY(dspId,"I",dspSubId)) q:dspSubId=""  d
 	...s dspbatch=dspId_"||"_dspSubId
 	...s inci=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",5)
 	...s dspQty=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",2)
 	...s Index=inci_","_PackFlag 
    ...s inum=inum+1
 	...s ^TMP("DHCINPHA","web.DHCINPHA.MTPHDraw.SqlDbPHDraw","GetDispDrug",pid,Index)=$g(^TMP("DHCINPHA","web.DHCINPHA.MTPHDraw.SqlDbPHDraw","GetDispDrug",pid,Index))+dspQty
 	...s ^TMP("DHCINPHA","web.DHCINPHA.MTPHDraw.SqlDbPHDraw","GetDispDrug",pid,Index,inum)=dspbatch_"^"_dspQty_"^"_PHRIRowID
	..
	.
	q inum
}

/// Descript: 	拒绝发药(备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-16
/// Table：		Update:DHC_PHDrawOrder，Insert:DHC_STDRUGREFUSE
/// Input：		DrawIncId(备药单子表),DrawOrderID(备药单孙表),LocId(发药科室ID),RefReasonId(拒绝发药原因ID),UserId(操作人ID)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).RefuseReason(" ","7||1||2","94","56","11")
/// d ##Class(web.DHCINPHA.MobilePHA).RefuseReason("7||1"," ","94","56","11")
ClassMethod RefuseReason(DrawIncId As %String, DrawOrderID As %String, LocId As %String, RefReasonId As %String, UserId As %String) As %String
{
	n (DrawIncId,DrawOrderID,LocId,RefReasonId,UserId)
	s Error=0
	s $ZT="Error^DHCSTERROR"
	tstart
	i DrawIncId'=" " d
	.s PHDWRowID=$p(DrawIncId,"||",1)
	.s PHDrawIncSub=$p(DrawIncId,"||",2)
	.s PHDrawOrderSub=""
	.f  s PHDrawOrderSub=$o(^DHCPHDRAW(PHDWRowID,"INC",PHDrawIncSub,"ORDER",PHDrawOrderSub))  q:(PHDrawOrderSub="")||(Error<0)  d
	..s PHDWORefFlag=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDrawIncSub,"ORDER",PHDrawOrderSub),"^",3)
	..q:PHDWORefFlag="Y"
	..s PHDWOStopFlag=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDrawIncSub,"ORDER",PHDrawOrderSub),"^",4)
	..q:PHDWOStopFlag="Y"
	..s PHDWODspBatchDr=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDrawIncSub,"ORDER",PHDrawOrderSub),"^",1) //医嘱打包表ID
	..s PHDWODspDr=+PHDWODspBatchDr
	..s STDFOEDIDR=$p(^DHCOEDISQTY(PHDWODspDr),"^",1) //医嘱明细表ID
	..s DrawOrderIDNow=DrawIncId_"||"_PHDrawOrderSub
	..s Error=..UpdatePHDrawOrderRefFlag(DrawOrderIDNow)
	..i Error<0 trollback 
	..q:Error<0
	..s SqlStr=STDFOEDIDR_"^"_LocId_"^"_UserId_"^"_RefReasonId_"^"_PHDWODspDr
	..s Error=..InsSTDRUGREFUSE(SqlStr)
	..i Error<0 trollback 
	..q:Error<0
	..s Error=..UpdateDispensingConfirmFlag(PHDWODspDr)
	..i Error<0 trollback 
	.
	q:Error<0 Error
	i DrawOrderID'=" " d
	.s Error=..UpdatePHDrawOrderRefFlag(DrawOrderID)
	.i Error<0 trollback 
	.s PHDWRowID=$p(DrawOrderID,"||",1)
	.s PHDrawIncSub=$p(DrawOrderID,"||",2)
	.s PHDrawOrderSub=$p(DrawOrderID,"||",3)
	.s PHDWODspBatchDr=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDrawIncSub,"ORDER",PHDrawOrderSub),"^",1)
	.s PHDWODspDr=+PHDWODspBatchDr
	.s STDFOEDIDR=$p(^DHCOEDISQTY(PHDWODspDr),"^",1)
	.s SqlStr=STDFOEDIDR_"^"_LocId_"^"_UserId_"^"_RefReasonId_"^"_PHDWODspDr
	.s Error=..InsSTDRUGREFUSE(SqlStr)
	.i Error<0 trollback 
	.s Error=..UpdateDispensingConfirmFlag(PHDWODspDr)
	.i Error<0 trollback 
	q:Error<0 Error
	tcommit
	q Error
}

/// Descript: 	插入拒发原因表
/// Creator：	yaoxin
/// CreateDate：2017-03-16
/// Table：		DHC_PHDrawOrder
/// Input：		SqlStr=医嘱明细表ID^发药科室ID^操作人ID^拒绝发药原因ID^医嘱打包表ID
/// Return：	>0，成功;<0，错误	
ClassMethod InsSTDRUGREFUSE(SqlStr As %String) As %Library.String
{
	n (SqlStr)
	s Err=0
	s STDFOEDIDR=$P(SqlStr,"^",1)
	s LocId=$P(SqlStr,"^",2)
	s UserId=$P(SqlStr,"^",3)
	s RefReasonId=$P(SqlStr,"^",4)
	s PHDWODspDr=$P(SqlStr,"^",5)
	
	s STDFDATE=$p($h,",",1)
	s STDFTIME=$p($h,",",2)
	
	q:STDFOEDIDR="" -201
	q:LocId="" -202
	q:UserId="" -203
	q:RefReasonId="" -204
	q:PHDWODspDr="" -205
   
    
	&SQL(Insert Into DHC_STDRUGREFUSE (STDF_OEDI_DR,STDF_LOC_DR,STDF_DATE,STDF_TIME,STDF_USER_DR,STDF_RefReason_DR,STDF_DODIS_DR)
		values(:STDFOEDIDR,:LocId,:STDFDATE,:STDFTIME,:UserId,:RefReasonId,:PHDWODspDr))
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_STDRUGREFUSE",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0 
	q Err
}

/// Descript: 	更新备药孙表拒绝发药标志
/// Creator：	yaoxin
/// CreateDate：2017-03-16
/// Table：		DHC_PHDrawOrder
/// Input：		SqlStr=孙表ID
/// Return：	>0，成功;<0，错误	
ClassMethod UpdatePHDrawOrderRefFlag(SqlStr As %String) As %Library.String
{
	n (SqlStr)
	s Err=0
	q:SqlStr="" -201
	s DrawOrderID=SqlStr
	&SQL(Update DHC_PHDrawOrder set PHDWO_RefFlag='Y' where PHDWO_RowID=:DrawOrderID)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHDrawOrder",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	
	q Err
}

/// Descript: 	更新医嘱打包表护士审核为未审核
/// Creator：	yaoxin
/// CreateDate：2017-12-12
/// Table：		DHC_OEDispensing
/// Input：		SqlStr=DSP_RowId
/// Return：	>0，成功;<0，错误	
/// w ##class(web.DHCINPHA.MTPHDraw.SqlDbPHDraw).UpdateDispensingConfirmFlag("6346")
ClassMethod UpdateDispensingConfirmFlag(SqlStr As %String) As %Library.String
{
	n (SqlStr)
	s Err=0
	q:SqlStr="" -201
	s DrawOrderID=SqlStr
	&SQL(Update DHC_OEDispensing set DSP_ConfirmFlag=null,DSP_ConfirmUser=null,DSP_DateConfirm=null,DSP_TimeConfirm=null where DSP_RowId=:DrawOrderID)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_OEDispensing",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	
	q Err
}

/// Descript: 	切换备药单排序规则(备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-16
/// Table：		DHC_PHDraw
/// Input：		DrawId(备药主表ID),SortId(排序序号)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdatePHDrawSort("7","2")
ClassMethod UpdatePHDrawSort(DrawId As %String, SortId As %String) As %Library.String
{
	n (DrawId,SortId)
	s Err=0
	q:DrawId="" -201
	q:SortId="" -202
	s SqlStr=DrawId_"^"_SortId
	&SQL(Update DHC_PHDraw set PHDW_Sort_Dr=:SortId where PHDW_RowID=:DrawId)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHDraw",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

}
