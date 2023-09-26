Import sqluser

Class web.DHCSTMHUI.DHCINScrap Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTINSCRAPM";

/// Descript:	保存/更新报损单信息
/// Creater:	qsx
/// CreateDate:	2012-08-28
/// Table:DHCINScrap,DHC_INSpItm
/// 	Input:报损单主表rowid,报损人^报损科室^完成标志^报损原因^类组^备注,
/// 	明细id^库存项RowId^批号^效期^生产厂家RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期,
/// 	明细id^库存项RowId^批号^效期^生产厂家RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期,
/// Output:		
/// "{""ScgStk"":""1"",""gUserId"":""5140"",""gLocId"":""8"",""gGroupId"":""98"",""gHospId"":""2"",""SupLoc"":""8"",""Complate"":"""",""Date"":"""",""User"":"""",""INScrapReason"":""4"",""RowId"":"""",""ScrapNo"":"""",""Time"":"""",""Remark"":""""}","[{""Inclb"":""2777||2||1"",""InciCode"":""GZ00012"",""InciDesc"":""涤纶补片[10*20]"",""Incil"":""2777||2"",""BatExp"":""2018051612~"",""Manf"":""北京佰仁思"",""Qty"":""1"",""PurUomId"":""2"",""PurUomDesc"":""片"",""Sp"":""960"",""Rp"":""960"",""AvaQty"":""40"",""InclbQty"": ""40"",""HVBarCode"":""""}]"
/// w ##class(web.DHCSTMHUI.DHCINScrap).Save("{""SupLoc"":""8"",""gUserId"":""5140"",""gLocId"":""8"",""gGroupId"":""98"",""gHospId"":""2"",""Date"":""2018-11-08"",""ScgStk"":""1"",""User"":"""",""INScrapReason"":""4"",""Complate"":"""",""RowId"":"""",""InsComp"":"""",""ScrapNo"":"""",""Time"":"""",""Remark"":""""}","[{""HVBarCode"":""YL20181017001"",""Inclb"":""2766||4||2"",""Qty"":1,""PurUomId"":""2"",""Rp"":""1000"",""Sp"":""1200"",""AvaQty"":""1""}]")
ClassMethod Save(MainInfo As %String, ListData As %String) As %Library.String
{
	n (MainInfo,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	i RtnObj.success<0 q RtnObj.Json()
	tstart
	s RtnObj=..Update(MainInfo)		;增加或更新报损主表信息
	i RtnObj.success<0 tro  q RtnObj.Json()
	s InscrapId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.DHCINScrapItm).Save(InscrapId,ListData)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tcommit
	s RtnObj.rowid=InscrapId
	q RtnObj.Json()
}

/// Descript:	确认完成某报损单
/// Creater:	gwj
/// CreateDate:	2012-09-03
/// Table:DHC_INScrap
/// Input:rowid
/// Output:		
/// Return：0,成功,
/// -1   	;报损单已经完成
/// -3   ;操作失败
/// -99:加锁控制失败
/// 
ClassMethod SetComplete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Inscrap=PJObj.%Get("RowId")
	i Inscrap="" d RtnObj.Err(-1,"","Inscrap不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s User=PJObj.%Get("gUserId")
	s Group=PJObj.%Get("gGroupId")
	
	s LockName=..%GetParameter("AppName")_Inscrap
	i ..sssLock(LockName)<0  d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s CompFlag=$p(^DHCINSP(Inscrap),"^",12)
	i CompFlag="Y" d ..sssUnLock(LockName) d RtnObj.Err(-1,"","报损单已经完成！","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	s Flag="Y"
	&sql(Update DHC_INScrap set INSCP_Completed=:Flag where INSCP_RowID=:Inscrap)
	i SQLCODE tro  d ..sssUnLock(LockName) d RtnObj.Err(-3,"","更新失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	tc
	d ..sssUnLock(LockName)
	s RtnObj.rowid=Inscrap
	q RtnObj.Json()
}

/// Descript:	取消完成某报损单
/// Creater:	gwj
/// CreateDate:	2012-09-03
/// Table:DHC_INScrap
/// Input:rowid
/// Output:		
ClassMethod CancelComplete(Inscrap As %String) As %Library.String
{
	n (Inscrap)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i Inscrap="" s Sc=RtnObj.Err(-1,"","Inscrap不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s LockName=..%GetParameter("AppName")_Inscrap
	i ..sssLock(LockName)<0 s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s CompFlag=$p(^DHCINSP(Inscrap),"^",12)
	i CompFlag'="Y" d ..sssUnLock(LockName) d RtnObj.Err(-1,"","报损单尚未完成！","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s AuditFlag=$p(^DHCINSP(Inscrap),"^",14)
	i AuditFlag="Y"  d ..sssUnLock(LockName) d RtnObj.Err(-2,"","报损单已经审核,不能取消完成！","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s Flag="N"
	&sql(Update DHC_INScrap set INSCP_Completed=:Flag where INSCP_RowID=:Inscrap)
	i SQLCODE tro  d ..sssUnLock(LockName) d RtnObj.Err(-3,"","更新标志失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	tc
	d ..sssUnLock(LockName)
	s RtnObj.rowid=Inscrap
	q RtnObj.Json()
}

/// 插入或更新一条报损单主表记录
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  inscrap - 报损单主表rowid
///  Data - 主表数据串   
/// w ##class(web.DHCSTMHUI.DHCINScrap).Update("{""ScgStk"":""1"",""gUserId"":""5140"",""gLocId"":""8"",""gGroupId"":""98"",""gHospId"":""2"",""SupLoc"":""8"",""Complate"":"""",""Date"":""18/07/2018"",""User"":""5140"",""INScrapReason"":""4"",""RowId"":""36"",""ScrapNo"":""ZYMZ009YLMSC20180718001"",""Time"":""18:00"",""Remark"":""""}")
ClassMethod Update(MainInfo As %String) As RtnObj
{
	n (MainInfo)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 d RtnObj.Err(-1,"","Update入参解析失败!")
	q:RtnObj.success<0 RtnObj
	s Inscrap=PJObj.%Get("RowId")
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("gLocId")
	s Loc=PJObj.%Get("SupLoc")				//科室rowid
	s InscrapComp=PJObj.%Get("Complate")	//完成标志
	s Reason=PJObj.%Get("INScrapReason")	//报损原因
	i Reason="" d RtnObj.Err(-4,"","报损原因为空!","",0)
	q:RtnObj.success<0 RtnObj
	
	s Scg=PJObj.%Get("ScgStk")				//库存类组rowid
	s Remark=PJObj.%Get("Remark")			//备注
	s ScrapNo=PJObj.%Get("ScrapNo")			//报损单号
	s StkType=..sssCode()
	s Date=+$h
	s Time=$p($h,",",2)
	i UserId="" q RtnObj.Err(-1,"","制单人为空!","",0)
	i Loc="" q RtnObj.Err(-2,"","科室为空!","",0)
	
	i Inscrap'="" d
	.s ChkFlag=$p(^DHCINSP(Inscrap),"^",14)
	.i ChkFlag="Y" d RtnObj.Err(-5,"","单据已审核!不允许修改!","",0) q
	.s CompFlag=$p(^DHCINSP(Inscrap),"^",12)
	.i CompFlag="Y" d RtnObj.Err(-3,"","单据已完成!请取消完成!","",0) q
	q:RtnObj.success<0 RtnObj
	
	s AppName=..%GetParameter("AppName")
	
	i Inscrap="" d
	.s ScrapNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,Scg,Loc)  //报损单号
	.i (ScrapNo<0)||(ScrapNo="") d
	..d RtnObj.Err(-2,"","单号生成失败:"_ScrapNo)
	.q:RtnObj.success<0
	.
	.s Obj=##class(User.DHCINScrap).%New()
	.s Obj.INSCPNO=ScrapNo
	.d Obj.INSCPCTLOCDRSetObjectId(Loc)
	.d Obj.INSCPSSUSRDRSetObjectId(UserId)
	.s Obj.INSCPStkType=StkType
	.s Obj.INSCPDate=Date
	.s Obj.INSCPTime=Time
	e  d
	.s LocRet=..sssLock(AppName_Inscrap)
	.i LocRet<0 d RtnObj.Err(-10,"","加锁失败!") q
	.s Obj=##class(User.DHCINScrap).%OpenId(Inscrap)
	i RtnObj.success<0 q RtnObj
	
	d Obj.INSCPReasonSetObjectId(Reason)
	d Obj.INSCPSCGDRSetObjectId(Scg)
	s Obj.INSCPCompleted=InscrapComp
	s Obj.INSCPRemarks=Remark
	s Sc=Obj.%Save()
	i Inscrap'="" d ..sssUnLock(AppName_Inscrap)
	i $$$ISERR(Sc) q RtnObj.Err(-1,"","库存报损单保存失败:"_Sc)
	
	s RtnObj.rowid=Obj.%Id()
	q RtnObj
}

/// 根据RowId取得一条报损单主表记录
/// Author: gwj
/// Date:2012-08-30
/// Argu: 
///  inscrp - 报损单主表
/// Return:
///  记录数据串
/// w ##class(web.DHCSTMHUI.DHCINScrap).Select(82)
ClassMethod Select(Inscrap As %String) As %String
{
	n (Inscrap)
	q:+Inscrap=0 ""
	s Data=""
	s NO=$p(^DHCINSP(Inscrap),"^",1)
	s Date=$p(^DHCINSP(Inscrap),"^",2)
	s Date=..DL2H(Date)
	s Time=$p(^DHCINSP(Inscrap),"^",3)
	s Time=..TL2H(Time)
	s InscrapReason=$p(^DHCINSP(Inscrap),"^",4)
	s ReasonDesc=$p(^DHCSTREASON("SCRAP",InscrapReason),"^",2)
	s InscrapLoc=$p(^DHCINSP(Inscrap),"^",5)
	s LocDesc=""
	s:InscrapLoc'="" LocDesc=$p(^CTLOC(InscrapLoc),"^",2)
	s InscrapUserId=$p(^DHCINSP(Inscrap),"^",6)
	s InscrapUser=$s(InscrapUserId'="":$p(^SSU("SSUSR",InscrapUserId),"^",2),1:"")
	s ChkDate=$p(^DHCINSP(Inscrap),"^",7)
	s ChkTime=$p(^DHCINSP(Inscrap),"^",8)
	s ChkUsrId=$p(^DHCINSP(Inscrap),"^",9)
	s:ChkUsrId'="" ChkUser=$p(^SSU("SSUSR",ChkUsrId),"^",2)
	s InscrapStat=$p(^DHCINSP(Inscrap),"^",10)
	s Remark=$p(^DHCINSP(Inscrap),"^",11)
	s Completed=$p(^DHCINSP(Inscrap),"^",12)
	i Completed="" s Completed="N"
	s StkGrp=""
	s InscrapScg=$p(^DHCINSP(Inscrap),"^",13)
	s:InscrapScg'="" StkGrp=$p(^DHCSCG(InscrapScg),"^",2)
	s ChkFlag=$p(^DHCINSP(Inscrap),"^",14)
	s StkType=$p(^DHCINSP(Inscrap),"^",15)
	s InsComp=Completed
	s Data=Inscrap_"^"_NO_"^"_Date_"^"_Time_"^"_InscrapReason
		_"^"_InscrapLoc_"^"_InscrapUserId_"^"_InscrapUser_"^"_ChkDate_"^"_ChkTime_"^"_Remark
		_"^"_Completed_"^"_ChkFlag_"^"_StkType_"^"_InscrapScg_"^"_InsComp
	s Title="RowId^ScrapNo^Date^Time^INScrapReason"
		_"^SupLoc^UserId^User^ChkDate^ChkTime^Remark"
		_"^Complate^Audit^StkType^ScgStk^InsComp"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// 执行删除
/// Author: zhwh
/// Date:2012-07-23
/// Argu: 
///  inscrp - 报损单主表
/// w ##class(web.DHCSTMHUI.DHCINScrap).Delete(9)
ClassMethod Delete(Inscrap As %String) As %String
{
	n (Inscrap)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i Inscrap="" d RtnObj.Err(-1,"","入参不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s LockName=..%GetParameter("AppName")_Inscrap
	i ..sssLock(LockName)<0  d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	//检查是否允许
	s Obj=##class(User.DHCINScrap).%OpenId(Inscrap)
	s Comp=Obj.INSCPCompleted
	i Comp="Y" d RtnObj.Err(-1,"","单据已完成!需取消完成","",0)
	i RtnObj.success'=0 d ..sssUnLock(LockName) q RtnObj.Json()
	s ChkFlag=Obj.INSCPChkFlag
	i ChkFlag="Y" d RtnObj.Err(-2,"","单据已审核,不允许删除!","",0)
	i RtnObj.success'=0 d ..sssUnLock(LockName) q RtnObj.Json()
	
	ts
	s RtnObj=..HandleDirtyQty(Inscrap,0)
	i RtnObj.success<0 tro  d ..sssUnLock(LockName) q RtnObj.Json()
	;先删除相关的高值跟踪信息
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).DelByPointer("D",+Inscrap)
	i RtnObj.success<0 tro  d ..sssUnLock(LockName) q RtnObj.Json()
	&sql(delete from dhc_inscrap where %ID=:Inscrap)
	i SQLCODE'=0  d RtnObj.Err(-4,"","处理DHC_Inscrap表删除失败!","",0)
	i RtnObj.success<0 tro  d ..sssUnLock(LockName) q RtnObj.Json()
	tc
	d ..sssUnLock(LockName)
	q RtnObj.Json()
}

/// 审核报损单
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  inscrp - 报损单主表rowid
///  user - 审核人
///  Loc - 科室rowid
/// Return:
/// 0 -success
/// <0  - failure
/// "{""Inscrap"":""12"",""gUserId"":""5140"",""gLocId"":""8"",""gGroupId"":""98"",""gHospId"":""2""}"
/// w ##class(web.DHCSTMHUI.DHCINScrap).Audit("{""Inscrap"":""53"",""gUserId"":""5140"",""gLocId"":""8"",""gGroupId"":""98"",""gHospId"":""2""}")
ClassMethod Audit(Params As %String) As %String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJobj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success<0 RtnObj.Json()
	s Inscrap=PJobj.%Get("Inscrap")
	i Inscrap="" d RtnObj.Err(-1,"","Inscrap不能为空!","",0).Json()
	q:RtnObj.success<0 RtnObj.Json()
	s User=PJobj.%Get("gUserId")
	i User="" d RtnObj.Err(-2,"","User不能为空!","",0)
	q:RtnObj.success<0 RtnObj.Json()
	s LocId=PJobj.%Get("gLocId")
	s GroupId=PJobj.%Get("gGroupId")
	s AuditFlag=$p(^DHCINSP(Inscrap),"^",14)
	i AuditFlag="Y" d RtnObj.Err(-3,"","报损单已经审核","",0)
	q:RtnObj.success<0 RtnObj.Json()
	;增加数据验证
	s RtnObj=..CheckDataValid(Inscrap)
	q:RtnObj.success<0 RtnObj.Json()
	
	s LockName=..%GetParameter("AppName")_Inscrap
	i ..sssLock(LockName)<0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success<0 RtnObj.Json()
	ts
	//设置状态
	s Sdate=$p($h,",",1)
	s Stime=$p($h,",",2)
	s AuditFlag="Y"
	s Obj=##class(User.DHCINScrap).%OpenId(Inscrap)
	s Obj.INSCPChkDate=Sdate
	s Obj.INSCPChkTime=Stime
	s Obj.INSCPChkFlag=AuditFlag
	d Obj.INSCPChkUSRDRSetObjectId(User)
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) d ..sssUnLock(LockName) tro  q RtnObj.Err(-101,"","状态修改失败!")
	//处理库存和台账
	s TrType="D"
	s TrNo=$p(^DHCINSP(Inscrap),"^",1)
	s Csub="0" f  s Csub=$o(^DHCINSP(Inscrap,"I",Csub)) q:(Csub="")!(RtnObj.success<0)  d
	.s Inclb=$p(^DHCINSP(Inscrap,"I",Csub),"^",1)
	.s Uom=$p(^DHCINSP(Inscrap,"I",Csub),"^",2)
	.s Qty=$p(^DHCINSP(Inscrap,"I",Csub),"^",3)
	.s Rp=$p(^DHCINSP(Inscrap,"I",Csub),"^",4)
	.s RpAmt=$p(^DHCINSP(Inscrap,"I",Csub),"^",5)
	.s Sp=$p(^DHCINSP(Inscrap,"I",Csub),"^",8)
	.s SpAmt=$p(^DHCINSP(Inscrap,"I",Csub),"^",9)
	.s Pointer=Inscrap_"||"_Csub
	.s Trans=TrType
	.s Trans=Trans_"^"_TrNo
	.s Trans=Trans_"^"_Inclb
	.s Trans=Trans_"^"_-Qty
	.s Trans=Trans_"^"_Uom
	.s Trans=Trans_"^"_+Sp
	.s Trans=Trans_"^"_User
	.s Trans=Trans_"^"_Pointer
	.s Trans=Trans_"^"_+Rp
	.s Trans=Trans_"^"_-RpAmt
	.s Trans=Trans_"^"_-SpAmt
	.
	.s Inci=+Inclb
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s Buom=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,Buom)
	.s Bqty=Qty*Fac   //换算成基本单位的数量
	.s NowQty=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",2)
	.i NowQty<Qty d RtnObj.Err(-104,"",InciCode_"可用库存数量小于业务数量!","",0) q
	.s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,-Bqty)
	.i Ret<0 d RtnObj.Err(-102,"","库存处理失败!") q
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(Trans)
	.i RtnObj.success'=0 d RtnObj.Err(-103,"","插入台账失败!") q
	.s RtnObj=##class(web.DHCSTMHUI.DHCINScrapItm).HandleItmDirtyQty(Pointer,0)
	.i RtnObj.success'=0 d RtnObj.Err(-105,"","清除占用失败!") q
	
	d ..sssUnLock(LockName)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// 检索主信息
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///   StartDate  -起始日期
///   EndDate -截止日期
///   Loc -科室RowId
///   CompleteFlag-状态=
///   AuditFlag - ，完成标志
/// 	d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINScrap","DHCINSpM","{""SupLoc"":""326"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""StartDate"":""2020-03-12"",""EndDate"":""2020-03-19"",""Complate"":"""",""HvFlag"":""Y""}")
Query DHCINSpM(Params As %String) As Query(ROWSPEC = "RowId,No,Date,Time,User,UserName,Loc,LocDesc,ChkDate,ChkTime,ChkUser,ChkUserName,Completed,ChkFlag ,StkType,Scg,ScgDesc,Reason,ReasonDesc,Remark,RpAmt:%Float,SpAmt:%Float")
{
}

ClassMethod DHCINSpMExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")	//起始日期
	s EndDate=PJobj.%Get("EndDate")		//截止日期
	s pComp=PJobj.%Get("Complate")			//完成的
	s pLocAudited=PJobj.%Get("Audit")		//已审核
	s pScg=PJobj.%Get("gGroupId")
	s pUserId=PJobj.%Get("gUserId")
	s gHospId=PJobj.%Get("gHospId")
	s pLocId=PJobj.%Get("SupLoc")
	i pLocAudited="Y" s pComp="Y"
	s pHvFlag=PJobj.%Get("HvFlag")
	s HospId=..sssHospId(pLocId)
	s:HospId="" HospId=gHospId
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(pUserId,..sssCode(),pLocId,pScg,HospId)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s sql=" select %ID Inscrap,"
	s sql=sql_"inscp_no xNo,"
	s sql=sql_"inscp_date d,"
	s sql=sql_"inscp_time t,"
	s sql=sql_"inscp_ssusr_dr xUser,"
	s sql=sql_"inscp_ssusr_dr->ssusr_name UserName,"
	s sql=sql_"inscp_ctloc_dr Loc,"
	s sql=sql_"inscp_ctloc_dr->ctloc_desc LocDesc,"
	s sql=sql_"inscp_chkdate ChkDate,"
	s sql=sql_"inscp_chktime ChkTime,"
	s sql=sql_"inscp_chkusr_dr ChkUser,"
	s sql=sql_"inscp_chkusr_dr->ssusr_name ChkUserName,"
	s sql=sql_"nvl(inscp_completed,'N') Completed,"
	s sql=sql_"nvl(inscp_chkflag,'N') ChkFlag,"
	s sql=sql_"inscp_stktype StkType,"
	s sql=sql_"inscp_scg_dr Scg,"
	s sql=sql_"inscp_scg_dr->scg_desc ScgDesc,"
	s sql=sql_"inscp_reason Reason,"
	s sql=sql_"inscp_reason->reason_scrapdesc ReasonDesc,"
	s sql=sql_"INSCP_Remarks Remark"
	s sql=sql_" From dhc_inscrap"
	s sql=sql_" where INSCP_Date between "_StartDate_" And "_EndDate
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("Inscrap")
		s HvFlag=##class(web.DHCSTMHUI.DHCINScrap).CheckDataHvFlag(RowId)
		continue:(pHvFlag'="")&&(pHvFlag'=HvFlag)
		s No=xrs.Data("xNo")
		s Date=xrs.Data("d")
		i Date'="" s Date=..DL2H(Date)
		s Time=xrs.Data("t")
		i Time'="" s Time=..TL2H(Time)
		s User=xrs.Data("xUser")
		s UserName=xrs.Data("UserName")
		s Loc=xrs.Data("Loc")
		continue:Loc'=pLocId
		s LocDesc=xrs.Data("LocDesc")
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		s ChkDate=xrs.Data("ChkDate")
		i ChkDate'="" s ChkDate=..DL2H(ChkDate)
		s ChkTime=xrs.Data("ChkTime")
		i ChkTime'="" s ChkTime=..TL2H(ChkTime)
		s ChkUser=xrs.Data("ChkUser")
		s ChkUserName=xrs.Data("ChkUserName")
		s Completed=xrs.Data("Completed")
		i Completed="" s Completed="N"
		continue:(pComp'="")&&(pComp'=Completed)
		s ChkFlag =xrs.Data("ChkFlag")
		i pLocAudited'="" continue:pLocAudited'=ChkFlag

		s StkType=xrs.Data("StkType")
		continue:StkType'=..sssCode()
		s Scg=xrs.Data("Scg")
		s ScgDesc=xrs.Data("ScgDesc")
		s Reason=xrs.Data("Reason")
		s ReasonDesc=xrs.Data("ReasonDesc")

		s Remark=xrs.Data("Remark")
		&sql(select sum(INSPI_RpAmt),sum(INSPI_SpAmt) into :RpAmt,:SpAmt from DHC_INSpItm
			where INSPI_Parref=:RowId)
		d OutPutRow
	} 
	Quit $$$OK

OutPutRow
	s Data=$lb(RowId,No,Date,Time,User,UserName,Loc,LocDesc,ChkDate,ChkTime,ChkUser,ChkUserName,Completed,ChkFlag ,StkType,Scg,ScgDesc,Reason,ReasonDesc,Remark,RpAmt,SpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:验证数据是否正确
/// Creater:ZhangDongmei
/// CreateDate: 2012-10-19
/// Input:退货主表id
/// Output:     
/// Return：数据验证通过:0
/// 数据验证不通过:DHC_StkSysErrorRecord rowid
/// w ##class(web.DHCSTMHUI.DHCINScrap).CheckDataValid(53)
ClassMethod CheckDataValid(Inscrap) As RtnObj
{
	n (Inscrap)
	s RtnObj=##class(RtnObj).%New()
	q:Inscrap="" RtnObj
	s AppCode=..%GetParameter("AppName")
	s KeyValue=$p(^DHCINSP(Inscrap),"^",1)   ;单号
	
	s Loc=$p(^DHCINSP(Inscrap),"^",5)
	q:Loc="" RtnObj.Err(-41,"","报损科室不能为空","",0)
	
	s Chl=0
	f  s Chl=$o(^DHCINSP(Inscrap,"I",Chl)) q:(Chl="")!(RtnObj.success'=0)  d
	.s Inclb=$p(^DHCINSP(Inscrap,"I",Chl),"^",1)
	.s Qty=$p(^DHCINSP(Inscrap,"I",Chl),"^",3)
	.s PurUomId=$p(^DHCINSP(Inscrap,"I",Chl),"^",2)
	.s Rp=$p(^DHCINSP(Inscrap,"I",Chl),"^",4)
	.s Sp=$p(^DHCINSP(Inscrap,"I",Chl),"^",8)
	.s Ret=##class(web.DHCSTMHUI.Common.UtilCommon).CheckDetail(AppCode,Inclb,Qty,Rp,Sp,PurUomId,"D")
	.i Ret'=""  d RtnObj.Err(-42,"",Ret)
	.q:RtnObj.success'=0
	
	q RtnObj
}

/// Descript:验证是否是高值
/// Creater:qiushengxin
/// CreateDate: 2020-03-19
/// Input:报损主表id
/// Output:     
/// Return：数据验证通过:0
/// w ##class(web.DHCSTMHUI.DHCINScrap).CheckDataHvFlag(53)
ClassMethod CheckDataHvFlag(Inscrap) As %Library.String
{
	n (Inscrap)
	s HvFlag="N"
	q:Inscrap="" HvFlag
	s Chl=0
	f  s Chl=$o(^DHCINSP(Inscrap,"I",Chl)) q:(Chl="")  d
	.s Inclb=$p(^DHCINSP(Inscrap,"I",Chl),"^",1)
	.s Inci=$p(Inclb,"||",1)
	.q:Inci=""
	.s HighValueFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.s:HighValueFlag="Y" HvFlag="Y"
	.q:HvFlag="Y"
	q HvFlag
}

/// Description:处理占用数量(整单)
/// CreateDate:	2020-03-19
/// Input:		报损单rowid, 
ClassMethod HandleDirtyQty(Inscp As %String, Sign As %String) As RtnObj
{
	n (Inscp,Sign)
	s RtnObj=##class(RtnObj).%New()
	s Ch=0
	f  s Ch=$o(^DHCINSP(Inscp,"I",Ch))  q:(Ch="")||(RtnObj.success<0)  d
	.s Inscpi=Inscp_"||"_Ch
	.s RtnObj=##class(web.DHCSTMHUI.DHCINScrapItm).HandleItmDirtyQty(Inscpi,Sign)
	q RtnObj
}

}
