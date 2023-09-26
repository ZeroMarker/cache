Import sqluser

/// 入库单付款审批
Class web.DHCST.DHCINGdRecPaymentApproval Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 入库单付款审批
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///  ingr -入库单主表rowid
/// Return:
/// 0 - success
/// <0 - failure
ClassMethod SetApproval(ingr As %String) As %String
{
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")_ingr)<0 -99_"^加锁失败"
 s allow=..AllowApproval(ingr)
 i allow<0  d ..uLockIngr(ingr)  
 i allow=-3  q -100_"^"_$P(^DHCINGR(ingr),"^",1)_"已经审批过!"
 s yes="Y"
 &sql(update DHC_InGdrec set INGR_PayAllowed=:yes where INGR_Rowid=:ingr)
 i SQLCODE'=0  d ..uLockIngr(ingr)  q -1_"^"_$P(^DHCINGR(ingr),"^",1)_"审批失败!"
 d ..uLockIngr(ingr)
 q 0
}

/// 退货单付款审批
/// Author:zhwh
/// Date:2012-12-19
/// Argu:
///  ingrt -退货单主表rowid
/// Return:
/// 0 - success
/// <0 - failure
/// w ##class(web.DHCST.DHCINGdRecPaymentApproval).SetApprovalRet(238)
ClassMethod SetApprovalRet(ingrt As %String) As %String
{
 
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINGdRet).%GetParameter("AppName")_ingrt)<0 -99_"^加锁失败"
 s allow=..AllowApprovalRet(ingrt)
 i allow<0  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINGdRet).%GetParameter("AppName")_ingrt)  
 i allow=-3  q -100_"^"_$P(^INGRT(ingrt),"^",1)_"已经审批过!"
 s yes="Y"
 //&sql(update DHC_InGdRet set INGRT_PayAllowed=:yes where %ID=:ingr)
 &sql(update DHC_InGdRet set INGRT_PayAllowed=:yes where %ID=:ingrt)
 s ret=SQLCODE
 d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINGdRet).%GetParameter("AppName")_ingrt) 
 i ret'=0    q -1_"^"_$P(^INGRT(ingrt),"^",1)_"审批失败!"
 q 0
}

/// 入库单付取消款审批
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///  ingr -入库单主表rowid
/// Return:
/// 0 - success
/// <0 -failure
ClassMethod CancelApproval(ingr As %String) As %String
{
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")_ingr)<0 -99_"^加锁失败"
 i ..AllowCancelApproval(ingr)<0  d ..uLockIngr(ingr) q -100_"^"_$P(^DHCINGR(ingr),"^",1)_"已经生成付款单不能取消审批!"
 s PayAllowed=$p(^DHCINGR(ingr),"^",22)
 i PayAllowed'="Y"  q 1_"^"_$P(^DHCINGR(ingr),"^",1)_"该付款单未审批,不能取消审批!"
 &sql(update DHC_InGdrec set INGR_PayAllowed='N' where INGR_Rowid=:ingr)
 i SQLCODE'=0  d ..uLockIngr(ingr)  q -1_"^取消审批失败!"
 d ..uLockIngr(ingr)
 q 0
}

/// 退货单付取消款审批
/// Author:zhwh
/// Date:2012-12-19
/// Argu:
///  ingrt -退货单主表rowid
/// Return:
/// 0 - success
/// <0 -failure
ClassMethod CancelApprovalRet(ingrt As %String) As %String
{
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINGdRet).%GetParameter("AppName")_ingrt)<0 -99_"^加锁失败"
 i ..AllowCancelApprovalRet(ingrt)<0  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINGdRet).%GetParameter("AppName")_ingrt) q -100_"^"_$P(^INGRT(ingrt),"^",1)_"已经生成付款单不能取消审批!"
 s PayAllowed=$p(^INGRT(ingrt),"^",12)
 i PayAllowed'="Y"  q 1_"^"_$P(^INGRT(ingrt),"^",1)_"该付款单未审批,不能取消审批!"
 &sql(update DHC_InGdret set INGRT_PayAllowed=null where INGRT_Rowid=:ingrt)
 s ret=SQLCODE
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINGdRet).%GetParameter("AppName")_ingrt)
 i ret'=0  q -1_"^取消审批失败!"
 q 0
}

/// 是否可以付款审批
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
/// ingr - 入库单主表rowid
/// Return:
///  0 - success
/// <0 - failure
ClassMethod AllowApproval(ingr As %String) As %String
{
 n (ingr)
 &sql(select ingr_payallowed,ingr_auditflag into :payAllowed,:auditFlag 
   From dhc_ingdrec where %id=:ingr)
 q:SQLCODE'=0 -1   //不存在的入库单
 s payAllowed=$G(payAllowed)
 s auditFlag=$G(auditFlag)
 i auditFlag'="Y" q -2  //未审核的入库单
 i payAllowed="Y" q -3  //已经审批
 q 0
}

/// 是否可以付款审批
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
///    ingrt - 退货单主表rowid
/// Return:
///  0 - success
/// <0 - failure
/// w ##class(web.DHCST.DHCINGdRecPaymentApproval).AllowApprovalRet(238)
ClassMethod AllowApprovalRet(ingrt As %String) As %String
{
  //n (ingr) 
  n (ingrt)
 &sql(select ingrt_payallowed,ingrt_auditflag into :payAllowed,:auditFlag 
   From dhc_ingdret where %id=:ingrt)
 q:SQLCODE'=0 -1   //不存在的退货单
 s payAllowed=$G(payAllowed)
 s auditFlag=$G(auditFlag)
 i auditFlag'="Y" q -2  //未审核的退货单
 i payAllowed="Y" q -3  //已经审批
 q 0
}

/// 是否可以取消付款审批
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
/// ingr - 入库单主表rowid
/// Return:
///  0 - success
/// <0 - failure
ClassMethod AllowCancelApproval(ingr As %String) As %String
{
 n (ingr)
 q:..IngrPayed(ingr,"G")>0 -1  //已制付款单时,禁止取消付款审批
 q 0
}

/// 是否可以取消付款审批
/// Author:zhwh
/// Date:2012-12-19
/// Argu:
///   ingrt - 退货单主表rowid
/// Return:
///  0 - success
/// <0 - failure
ClassMethod AllowCancelApprovalRet(ingrt As %String) As %String
{
 n (ingrt)
 q:..IngrPayed(ingrt,"R")>0 -1  //已制付款单时,禁止取消付款审批
 q 0
}

/// 入库单解锁
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
/// ingr - 入库单主表rowid
/// Return:
///  0 - success
/// <0 - failure
ClassMethod uLockIngr(ingr As %String)
{
 d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")_ingr)
 q
}

/// 查看入库单是否有明细记录已经制付款单
/// Author:zhwh
/// Date:2012-08-27
/// Argu:
/// ingr  - 入库/退货单主表rowid
/// Return:
/// 0 - 未制付款单
/// >0 - 已制付款单
ClassMethod IngrPayed(ingr As %String, type As %String) As %String
{
 n (ingr,type)
 s ret=0

 //入库
 i type="G" d
 .s ch=0
 .f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:(ch="")!(ret>0)  d
 ..s ingri=ingr_"||"_ch
 ..s pay=$O(^DHCPAY(0,"TYPEGR",type,ingri,""))
 ..i pay>0 s ret=1
 ..  
 
 //退货
 i type="R" d
 .s ingrt=ingr
 .s ch=0
 .f  s ch=$o(^INGRT(ingrt,"DHCGRR",ch)) q:(ch="")!(ret>0)  d
 ..s ingrti=ingrt_"||"_ch
 ..s pay=$O(^DHCPAY(0,"TYPEGR",type,ingrti,""))
 ..i pay>0 s ret=1
 ..  
 
 q ret
}

/// 取待审批入库单的供应商列表记录数据串(json)
/// Author:zhwh
/// Date:2012-08-31
/// Argu:
///  Start
///  Limit
///  qStr-查询参数串(科室rowid^起始日期^截止日期^供应商rowid^包含退货包^含赠品入库^包含无发票^包含批示))
/// Return:
///  供应商列表记录数据串(json)
/// w ##class(web.DHCST.DHCINGdRecPaymentApproval).jsVendorList("0","20","165^02/11/2020^29/12/2020^27^Y^N^^^","RowId","desc")
ClassMethod jsVendorList(Start As %String, Limit As %String, qStr As %String, Sort = "", Dir = "") As %String
{
 n (Start, Limit, qStr,Sort,Dir)
 //s ^YSJTMP("jsVendorList")=$LB(Start, Limit, qStr,Sort,Dir)
 s $zt="ErrorjsVendorList"
 s EmptyJson=##class(web.DHCSTEXTCOMMON).GetNoJson()  
 s Loc=$p(qStr,"^",1)  //科室rowid
 s HospId=$p(^CTLOC(Loc),"^",22)
 s StartDate=$p(qStr,"^",2)  //起始日期
 s EndDate=$p(qStr,"^",3)  //截止日期
 s Vendor=$p(qStr,"^",4)   //供应商rowid
 s IncludeRet=$p(qStr,"^",5) //包含退货
 s IncludeGift=$p(qStr,"^",6) // 包含赠品
 s IncludeNoInv=$p(qStr,"^",7) // 包含"无发票"N查找无发票 Y查找有发票
 s IncludeApproved=$p(qStr,"^",8) //包含"已审批"
 s INVNnmber=$p(qStr,"^",9)        //发票号  
 s result=##class(%ResultSet).%New("web.DHCST.DHCINGdRecPaymentApproval:SetRecApproval")
 s sc=result.Execute(Loc,StartDate, EndDate,Vendor,IncludeRet,IncludeGift,IncludeNoInv,IncludeApproved,INVNnmber)
 i $$$ISERR(sc) q EmptyJson
 s colNameStr="vendor^vendorName^rpAmt^toPayAmt^payedAmt^toDashAmt"
 k jsVendorListDATAOUTPUT
 k jsVendorListDATA
 s countrecords = 0
 s resultString = ""
 s end = Start+Limit
 s Start=Start+1  //开始行
 While(result.Next())
 { 
	  s ret=""
	  s vendor=result.Data("vendor")   //使供应商记录唯一化
	  s ingr=result.Data("ingr")
	  s type=result.Data("type")
	  s vendorName=result.Data("vendorName")  
	  s rpAmt=result.Data("rpAmt")  
	  s toPayAmt=result.Data("rpAmt")  
	  s payedAmt=result.Data("payedAmt")
	  s typePointer=result.Data("typePointer")
	  i type="R" s payedAmt=(-1)*payedAmt 
	  s toDashAmt=0
  
	  i $d(jsVendorListDATA(vendor)) d
	  .i '$d(jsVendorListDATA(vendor,"typePointer",typePointer)) d
	  ..s $p(jsVendorListDATA(vendor),"^",3)=$p(jsVendorListDATA(vendor),"^",3)+rpAmt
	  ..s $p(jsVendorListDATA(vendor),"^",4)=$p(jsVendorListDATA(vendor),"^",4)+rpAmt
	  ..s $p(jsVendorListDATA(vendor),"^",5)=$p(jsVendorListDATA(vendor),"^",5)+payedAmt
	  e  d
	  .s ret=vendor_"^"_vendorName_"^"_rpAmt_"^"_toPayAmt_"^"_payedAmt_"^"_toDashAmt
	  .s jsVendorListDATA(vendor)=ret
	  .s jsVendorListDATA(vendor,"typePointer",typePointer)=""
	  .s countrecords=countrecords+1
 }
 q:countrecords=0 EmptyJson
 s sortNum=$lf($lfs(colNameStr,"^"),Sort)
 s sortAsNum=""
 i (Sort["Qty")||(Sort["Amt")||(Sort["Sp")||(Sort["Rp") s sortAsNum="Y"
 s orderDir=1
 i $zcvt(Dir,"U")="DESC" s orderDir=-1
 // 由此排序
 s count=0
 s vendor=""
 f  s vendor=$o(jsVendorListDATA(vendor)) q:vendor=""  d
 .s Data=jsVendorListDATA(vendor)
 .i +sortNum=0 s index="1" 
 .e  d
 ..s index=$p(Data,"^",sortNum)
 ..i sortAsNum="Y" s index=+index
 .i index="" s index="ZZZZZZ"
 .s count=count+1
 .s jsVendorListDATAOUTPUT(index,count)=jsVendorListDATA(vendor)
 s countRecords=0
 s index=""
 f  s index=$o(jsVendorListDATAOUTPUT(index),orderDir) q:(index="")  d
 .s indexCnt=""
 .f  s indexCnt=$o(jsVendorListDATAOUTPUT(index,indexCnt),orderDir) q:(indexCnt="")  d
 ..s outputdata=jsVendorListDATAOUTPUT(index,indexCnt)
 ..s $P(outputdata,"^",3) = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt($P(outputdata,"^",3),HospId)
 ..s $P(outputdata,"^",4) = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt($P(outputdata,"^",3),HospId)
 ..s $P(outputdata,"^",5) = ##Class(web.DHCST.Common.AppCommon).FormatRpAmt($P(outputdata,"^",4),HospId)
 ..s countRecords = countRecords+1
 ..q:countRecords<Start
 ..q:countRecords>end
 ..i countRecords=Start d
 ...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(count)
 ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
 ...w retstring
 ..e  d
 ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
 ...w ","_retstring
 q:countRecords=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 w "]}"
 Q ""
ErrorjsVendorList
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 待审核入库单记录数据串(json)
/// Author:zhwh
/// Date:2012-08-31
/// Argu:
///  Start
///  Limit
///  qStr-查询参数串(科室rowid^起始日期^截止日期^供应商rowid^包含退货^含赠品入库^包含无发票^包含批示))
/// Return：
///  入库单记录数据串(json)
/// w ##class(web.DHCST.DHCINGdRecPaymentApproval).jsDHCINGdRecList("0","20","257^19/01/2020^19/01/2020^27^Y^N^^^","gdNo","ASC")
ClassMethod jsDHCINGdRecList(Start As %String, Limit As %String, qStr As %String, Sort = "", Dir = "")
{
	//s ^YSJTMP("jsDHCINGdRecList")=$LB(Start , Limit , qStr, Sort, Dir )
	s pid=..NewPid()
	s $zt="ErrorjsDHCINGdRecList"
	s EmptyJson=##class(web.DHCSTEXTCOMMON).GetNoJson()  
	s Loc=$p(qStr,"^",1)           //科室rowid
	s StartDate=$p(qStr,"^",2)     //起始日期
	s EndDate=$p(qStr,"^",3)       //截止日期
	s Vendor=$p(qStr,"^",4)          //供应商rowid
	s IncludeRet=$p(qStr,"^",5)      //包含退货
	s IncludeGift=$p(qStr,"^",6)     // 包含赠品
	s IncludeNoInv=$p(qStr,"^",7)    // 包含"无发票"N查找无发票 Y查找有发票   ""全部查出
	s IncludeApproved=$p(qStr,"^",8)  //包含"已审批"
	s INVNnmber=$p(qStr,"^",9)        //发票号 
	s result=##class(%ResultSet).%New("web.DHCST.DHCINGdRecPaymentApproval:SetRecApproval")
	s sc=result.Execute(Loc,StartDate, EndDate,Vendor,IncludeRet,IncludeGift,IncludeNoInv,IncludeApproved,INVNnmber)
	i $$$ISERR(sc) q EmptyJson
 	s RS=result
	s endRow = Start+Limit 	// 结束行
	s startRow=Start+1  	// 开始行
	s pid=##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
	k ^||TMP("DHCST",$ClassName(),pid)
	// 标题
	s dirOrder=1,sortNum="",isNum="",isCHN=""
	i $zcvt(Dir,"U")="DESC" s dirOrder=-1
	s colNameStr=""
	s colNum=RS.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=RS.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"^"_colName
	.i $zcvt(colName,"U")=$zcvt(Sort,"U") s sortNum=i
	s countRecords=0
	k jsDHCINGdRecList
	While(RS.Next())
	{ 
		s typePointer=result.Data("typePointer")
		// 去重
		continue:$d(jsDHCINGdRecList(typePointer)) //使入库\退货记录唯一化
		s jsDHCINGdRecList(typePointer)=""
		s sortVal=""
		s ret=""
		f i=1:1:colNum d
		.s colVal=RS.%GetData(i)
		.i ret="" s ret=colVal
		.e   s ret=ret_"^"_colVal
		.i i=sortNum s sortVal=colVal
		i sortVal="" s sortVal="ZZZZZZ"
		s countRecords=countRecords+1  //可做索引用
		s ^||TMP("DHCST",$ClassName(),pid,sortVal,countRecords)=ret
	}
	q:countRecords=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s sortIndex="",count=0
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),pid,sortIndex),dirOrder) q:sortIndex=""  d
	.s indexCnt=""
	.f  s indexCnt=$o(^||TMP("DHCST",$ClassName(),pid,sortIndex,indexCnt),dirOrder) q:indexCnt=""  d
	..s tmpData=^||TMP("DHCST",$ClassName(),pid,sortIndex,indexCnt)
	..s count = count+1
	..q:count<startRow
	..q:count>endRow
	..i count=startRow d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(countRecords)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmpData,colNameStr)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmpData,colNameStr)
	...w ","_retstring
	k ^||TMP("DHCST",$ClassName(),pid)
	i count=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:count=0 ""
	w "]}"
	q ""
ErrorjsDHCINGdRecList
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 查找检索待审批的供应商列表
/// Author:zhwh
/// Date:2012-08-31
/// Argu:
///  Loc-科室rowid
///  StartDate-起始日期
///  EndDate-截止日期
///  Vendor-供应商rowid
///  IncludeRet-包括退货Y/N，
///  IncludeGift-包括赠品入库Y/N，
///  IncludeNoInv-包括无发票Y/N，
///  IncludeApproved-包括已审批Y/N，
/// Return:
///  供应商RowId，供应商名称，入库进价金额，应付款金额，已付款金额，冲账金额
Query SetRecApproval(Loc As %String, StartDate As %String, EndDate As %String, Vendor As %String, IncludeRet As %String, IncludeGift As %String, IncludeNoInv As %String, IncludeApproved As %String, INVNnmber As %String) As %Query(ROWSPEC = "ingr:%String,gdNo:%String,vendor:%String,vendorName:%String,createDate:%String,createTime:%String,createUserName:%String,gdDate:%String,gdTime:%String,gdAuditUserName:%String,rpAmt:%String,spAmt:%String,payedAmt:%String,gift:%String,type:%String,payAllowed:%String,payOverFlag:%String,typePointer")
{
}

ClassMethod SetRecApprovalExecute(ByRef qHandle As %Binary, Loc As %String, StartDate As %String, EndDate As %String, Vendor As %String, IncludeRet As %String, IncludeGift As %String, IncludeNoInv As %String, IncludeApproved As %String, INVNnmber As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Loc="" $$$OK
 s HospId=$P(^CTLOC(Loc),"^",22)
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 //检索入库数据
 s sql="select ingri_ingr_parref ingr,"
 s sql=sql_"ingri_ingr_parref->ingr_no gdNo,"
 s sql=sql_"ingri_ingr_parref->ingr_apcvm_dr vendor,"
 s sql=sql_"ingri_ingr_parref->ingr_apcvm_dr->apcvm_name vendorName,"
 s sql=sql_"ingri_ingr_parref->ingr_createdate createDate,"
 s sql=sql_"ingri_ingr_parref->ingr_createtime createTime,"
 s sql=sql_"ingri_ingr_parref->ingr_createuser->ssusr_name createUserName,"
 s sql=sql_"ingri_ingr_parref->ingr_date gdDate,"
 s sql=sql_"ingri_ingr_parref->ingr_time gdTime,"
 s sql=sql_"ingri_ingr_parref->ingr_ssusr_dr->ssusr_name gdAuditUserName,"
 s sql=sql_"ingri_ingr_parref->ingr_giftflag gift,"
 s sql=sql_"ingri_ingr_parref->ingr_payallowed payAllowed,"
 s sql=sql_"initm_invno invNo"
 s sql=sql_" From dhc_ingdrecitm"
 s sql=sql_" where ingri_ingr_parref->ingr_date between "_StartDate_" and "_EndDate
 s sql=sql_" and ingri_ingr_parref->ingr_loc_dr="_Loc
 s sql=sql_" and ingri_ingr_parref->ingr_giftflag!="_"'Y'"
 i Vendor'="" d
 .s sql=sql_" and ingri_ingr_parref->ingr_apcvm_dr="_Vendor
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) d $System.Status.DisplayError(sc)
 i $$$ISERR(sc) q $$$OK
 
 while (xrs.Next())
 {
    s payAllowed=xrs.Data("payAllowed")   //付款审批标志
    i payAllowed="" s payAllowed="N"  //为空表示"未审批"
    
    s gift=xrs.Data("gift")
    s invNo=xrs.Data("invNo")
    
    //i IncludeGift'="Y" continue:gift="Y"
    
    i IncludeApproved="N" continue:payAllowed="Y"    
    i IncludeApproved="Y" continue:payAllowed'="Y"
    i IncludeNoInv="N" continue:invNo'=""    
    i IncludeNoInv="Y" continue:invNo=""
    i INVNnmber'="" continue:invNo'=INVNnmber  //20130620
    s type="G"
    s ingr=xrs.Data("ingr")
    s gdNo=xrs.Data("gdNo")
    s vendor=+xrs.Data("vendor")
    s vendorName=xrs.Data("vendorName")
    s createDate=xrs.Data("createDate")
    s createTime=xrs.Data("createTime")
    s createUserName=xrs.Data("createUserName")
    i createDate'="" s createDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(createDate,"ST")
    i createTime'="" s createTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(createTime,"ST")
    s gdDate=xrs.Data("gdDate")
    i gdDate'="" s gdDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(gdDate,"ST")
    s gdTime=xrs.Data("gdTime")
    i gdTime'="" s gdTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(gdTime,"ST")
    s gdAuditUserName=xrs.Data("gdAuditUserName")
    s typePointer=ingr_"||"_type
    //i $G(XAmt(typePointer)) d
    //.s rpAmt=$p(XAmt(typePointer),"^",1)
    //.s spAmt=$p(XAmt(typePointer),"^",2)
    //.s payedAmt=$p(XAmt(typePointer),"^",3)
    i $G(XAmt(typePointer)) continue
    e  d
    .s gdAmt=##class(web.DHCST.DHCINGdRecInv).GetRecAmt(ingr)
    .s rpAmt=$p(gdAmt,"^",1)   //进价总金额
    .s spAmt= $p(gdAmt,"^",2)  //售价总金额
    .s payedAmt= ##class(web.DHCST.DHCINGdRecInv).PayedAmt(ingr,"Y")  //已付款总金额
    s gdAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(gdAmt,HospId)
    s rpAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,HospId)
    s spAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(spAmt,HospId)
    s payedAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(payedAmt,HospId)
    s gift=xrs.Data("gift")   //赠品入库标志
    s XAmt(typePointer)=rpAmt_"^"_spAmt_"^"_payedAmt
    s payOverFlag="N"
    i (payedAmt'="")&&(payedAmt>=rpAmt) s payOverFlag="Y"
    d OutPutRow
 }
 d xrs.Close()
 k XAmt
 i IncludeRet'="Y"  q $$$OK
 //检索退货数据
 s sql="select ingrti_ingrt_parref ingr,"
 s sql=sql_"ingrti_ingrt_parref->ingrt_no gdNo,"
 s sql=sql_" ingrti_ingrt_parref->ingrt_apcvm_dr vendor,"
 s sql=sql_" ingrti_ingrt_parref->ingrt_apcvm_dr->apcvm_name vendorName,"
 s sql=sql_" ingrti_ingrt_parref->ingrt_date createDate,"
 s sql=sql_" ingrti_ingrt_parref->ingrt_time createTime,"
 s sql=sql_" ingrti_ingrt_parref->ingrt_ssusr_dr->ssusr_name createUserName,"
 s sql=sql_" ingrti_ingrt_parref->ingrt_auditdate gdDate ,"
 s sql=sql_" ingrti_ingrt_parref->ingrt_audittime gdTime,"
 s sql=sql_"ingrti_ingrt_parref->INGRT_SSUSR_Audit_DR->ssusr_name gdAuditUserName,"
 s sql=sql_"'N' gift,"
 s sql=sql_" ingrti_ingrt_parref->ingrt_payallowed payAllowed,"
 s sql=sql_" ingrti_invno invNo"
 s sql=sql_" From dhc_ingrtitm"
 s sql=sql_" where ingrti_ingrt_parref->ingrt_auditdate between  "_StartDate_" and "_EndDate
 s sql=sql_" and  ingrti_ingrt_parref->ingrt_ctloc_Dr= "_Loc
 i Vendor'="" d
 .s sql=sql_" and ingrti_ingrt_parref->ingrt_apcvm_dr="_Vendor
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) d $System.Status.DisplayError(sc)
 i $$$ISERR(sc) q $$$OK
 while (xrs.Next())
 {  
    s payAllowed=xrs.Data("payAllowed") //付款审批标志
    i payAllowed="" s payAllowed="N"  //为空表示"未审批"
    s gift=xrs.Data("gift")
    s invNo=xrs.Data("invNo")
    i IncludeGift'="Y" continue:gift="Y"
    i IncludeNoInv="Y"  continue:invNo=""
    i IncludeNoInv="N" continue:invNo'="" 
    i IncludeApproved="N" continue:payAllowed="Y"
    i IncludeApproved="Y" continue:payAllowed'="Y"
    i INVNnmber'="" continue:invNo'=INVNnmber //20130620
    
    s type="R"
    s ingrt=xrs.Data("ingr")  //退货rowid
    s retNo=xrs.Data("gdNo")
    s vendor=+xrs.Data("vendor")
    s vendorName=xrs.Data("vendorName")
    
    s createDate=xrs.Data("createDate")
    s createTime=xrs.Data("createTime")
    s createUserName=xrs.Data("createUserName")
    i createDate'="" s createDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(createDate,"ST")
    i createTime'="" s createTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(createTime,"ST")
    s retDate=xrs.Data("gdDate")
    i retDate'="" s retDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retDate,"ST")
    s retTime=xrs.Data("gdTime")
    //i retTime'="" s retTime=$zt(gdTime)
    i retTime'="" s retTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(retTime,"ST")
    s retAuditUserName=xrs.Data("gdAuditUserName")
    s typePointer=ingrt_"||"_type
    //i $G(XAmt(typePointer)) d
    //.s rpAmt=$p(XAmt(typePointer),"^",1)
    //.s spAmt=$p(XAmt(typePointer),"^",2)
    //.s payedAmt=$p(XAmt(typePointer),"^",3)
    i $G(XAmt(typePointer)) continue
    e  d
    .s retAmt=##class(web.DHCST.DHCINGdRecInv).GetRetAmt(ingrt)
    .s rpAmt=$p(retAmt,"^",1)   //进价总金额
    .s spAmt= $p(retAmt,"^",2)  //售价总金额
    .s payedAmt= ##class(web.DHCST.DHCINGdRecInv).PayedAmtRet(ingrt,"Y")  //退货记录已付款总金额
    s retAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(retAmt,HospId)
    s rpAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,HospId)
    s spAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(spAmt,HospId)
    s payedAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(payedAmt,HospId)
    s gift=xrs.Data("gift")   //赠品入库标志
    s XAmt(typePointer)=rpAmt_"^"_spAmt_"^"_payedAmt
    s payOverFlag="N"
    i (payedAmt'="")&&(payedAmt+rpAmt=0) s payOverFlag="Y"
    d OutPutRowRet
 } 
 
 Quit $$$OK
OutPutRow
 s Data=$lb(ingr,gdNo,vendor,vendorName,createDate,createTime,createUserName,gdDate,gdTime,gdAuditUserName,rpAmt,spAmt,payedAmt,gift,type,payAllowed,payOverFlag,typePointer)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
OutPutRowRet
 s Data=$lb(ingrt,retNo,vendor,vendorName,createDate,createTime,createUserName,retDate,retTime,retAuditUserName,(-1)*rpAmt,(-1)*spAmt,(-1)*payedAmt,gift,type,payAllowed,payOverFlag,typePointer)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod SetRecApprovalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SetRecApprovalExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SetRecApprovalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SetRecApprovalExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 取入库单或者退货单的明细数据(json)
/// 
/// Author:zhwh
/// Date:2012-12-18
/// Argu:
///  Start
///  Limit
///  RecRet -入库/退货单rowid
///  Type - 类型(入库/退货)
/// Return:
///  明细数据(json)
/// w ##class(web.DHCST.DHCINGdRecPaymentApproval).jsRecRetItm("0","20","592","G")
ClassMethod jsRecRetItm(Start As %String, Limit As %String, RecRet As %String, Type As %String) As %String
{
 //s ^YSJTMP("jsRecRetItm")=$lb(Start,Limit,RecRet,Type)
 s HospId=""
 i $d(%session) s HospId=$g(%session.Data("LOGON.HOSPID"))
 s $zt="ErrorjsRecRetItm"
 s colNameStr="RowId^IncId^IncCode^IncDesc^Spec^Manf^Qty^Uom^BatchNo^ExpDate^Rp^RpAmt^Sp^SpAmt^InvNo^InvDate^InvMoney^SxNo^TypePointer"
 s resultString = ""
 s count=0
 s countrecord=0
 s end=Start+Limit
 s Start=Start+1
 s typelen=$l(Type,"#")
 f i=1:1:typelen d
 .s Typei=$p(Type,"#",i)
 .s RecRowId=$p(RecRet,"#",i)
 .i Typei="G" d
 ..s RecSub=""
 ..f  s RecSub=$o(^DHCINGR(RecRowId,"GRI",RecSub)) q:RecSub=""  d
 ...s RecData=^DHCINGR(RecRowId,"GRI",RecSub)
 ...s RowId=RecRowId_"||"_RecSub
 ...q:RowId=""
 ...s BatchNo=$p(RecData,"^",13)
 ...s IngrUomId=$p(RecData,"^",10)
 ...s Uom=$p($g(^CT("UOM",IngrUomId)),"^",2)
 ...s ExpDate=$p(RecData,"^",9)
 ...i ExpDate'=""  s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 ...s Inclb=$p(RecData,"^",1)
 ...s IncId=$p(RecData,"^",25)
 ...s IncCode=$p(^INCI(IncId,1),"^",1)
 ...s IncDesc=$p(^INCI(IncId,1),"^",2)
 ...s Inpoi=$p(RecData,"^",17)
 ...s Margin=$p(RecData,"^",18)
 ...s Qty=$p(RecData,"^",4)
 ...s Remarks=+$p(RecData,"REM","^",1)
 ...s InvMoney=$p(RecData,"^",26)
 ...s InvNo=$p(RecData,"^",27)
 ...s PayNo=$p(RecData,"^",28)
 ...s ManfId=$p(RecData,"^",29)
 ...s Manf=$s(+ManfId'=0:$p($g(^PHMNF(ManfId)),"^",2),1:"")
 ...s Rp=$p(RecData,"^",30)
 ...s RpAmt=$p(RecData,"^",31)
 ...s Sp=$p(RecData,"^",32)
 ...s SpAmt=$p(RecData,"^",50)
 ...s Rp=##Class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,1,"G","",IncId)
 ...s Sp=##Class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,1,"G","",IncId)
 ...s RpAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
 ...s SpAmt=##Class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
 ...s InvDate=$p(RecData,"^",34)
 ...s:+InvDate'=0 InvDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(InvDate,"ST")
 ...s BatRp=$p(RecData,"^",35)
 ...s QualityNo=$p(RecData,"^",37)
 ...s SxNo=$p(RecData,"^",38)
 ...s Remark=$p(RecData,"^",44)     ;摘要
 ...s NewSp=$p(RecData,"^",45)
 ...s NewSpAmt=$p(RecData,"^",46)
 ...s MtDr=$p(RecData,"^",47)      ;定价类型
 ...s:MtDr'="" MtDesc=$p(^DHCINMT(MtDr),"^",2)
 ...s PubBL=$p(RecData,"^",48)         ;招标轮次
 ...s:PubBL'="" PubDesc=$p(^DHCPBLIST(PubBL),"^",2)     
 ...s CheckPort=$p(RecData,"^",41)      ;检测口岸
 ...s CheckRepNo=$p(RecData,"^",39)    ;检测报告
 ...s CheckRepDate=$p(RecData,"^",40)    ;报告日期
 ...s AdmNo=$p(RecData,"^",42)                  ;注册证号
 ...s AdmExpdate=$p(RecData,"^",43)        ;注册证有效期
 ...i AdmExpdate'="" s AdmExpdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdmExpdate,"ST")
 ...s CheckPack=$p(RecData,"^",23)          ;包装合格
 ...s BUomId=$p(^INCI(IncId,1),"^",10)
 ...s PurUomId=$p(^INCI(IncId,3),"^",6)
 ...s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
 ...s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
 ...s ctlocdr=$p(RecData,"^",3)
 ...s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(ctlocdr,IncId)
 ...s stkbin=$p(stkbin,"^",1)                      ;库位码
 ...s goodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(IncId)	;商品名
 ...s TypePointer=RowId_"||G"
 ...d ##Class(PHA.COM.Number).AddZero(.Qty,.Rp,.RpAmt,.Sp,.SpAmt,.InvMoney)
 ...s ret=RowId_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_Spec_"^"_Manf_"^"_Qty_"^"_Uom_"^"_BatchNo_"^"_ExpDate_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt_"^"_InvNo_"^"_InvDate_"^"_InvMoney_"^"_SxNo_"^"_TypePointer
 ...s tmp=ret
 ...s count=count+1
 ...q:count<Start
 ...q:count>end 
 ...i count=Start d
 ....w "{rows:["
 ....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmp,colNameStr)
 ....w retstring
 ...e  d
 ....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmp,colNameStr)
 ....w ","_retstring 
 ...s countrecord=countrecord+1 
 
 .i Typei="R" d
 ..s RecSub=""
 ..f  s RecSub=$o(^INGRT(RecRowId,"DHCGRR",RecSub)) q:RecSub=""  d
 ...s RecData=^INGRT(RecRowId,"DHCGRR",RecSub)
 ...s RowId=RecRowId_"||"_RecSub //rowid
 ...s ingri=$p(RecData,"^",1) q:ingri=""
 ...s inclb=$p(RecData,"^",6)
 ...s IncId=+inclb
 ...s IncCode=$p($g(^INCI(IncId,1)),"^",1)
 ...s IncDesc=$p($g(^INCI(IncId,1)),"^",2)
 ...s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
 ...s IngriRowId=$p(RecData,"^",1)
 ...s ManfId=$p(^DHCINGR(+IngriRowId,"GRI",$P(IngriRowId,"||",2)),"^",29)
 ...s Manf=$s(+ManfId'=0:$p($g(^PHMNF(ManfId)),"^",2),1:"")
 ...s Qty=$p(RecData,"^",2)
 ...s UomDr=$p(RecData,"^",3)
 ...s Uom=$p($g(^CT("UOM",UomDr)),"^",2)
 ...s Rp=$p(RecData,"^",7)
 ...s RpAmt=$p(RecData,"^",4)
 ...s Sp=$p(RecData,"^",8)
 ...s SpAmt=$p(RecData,"^",9)
 
 ...s Rp=##Class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,1,"G","",IncId)
 ...s Sp=##Class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,1,"G","",IncId)
 ...s RpAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
 ...s SpAmt=##Class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
 
 ...s InvNo=$p(RecData,"^",12)
 ...s InvDate=$p(RecData,"^",14)
 ...s:+InvDate'=0 InvDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(InvDate,"ST")
 ...s InvMoney=$p(RecData,"^",13)
 ...s SxNo=$p(RecData,"^",18)
 ...s oldSp=$p(RecData,"^",15)
 ...s oldSpAmt=$p(RecData,"^",16)
 ...s retReasonDr=$p(RecData,"^",5)
 ...s retReason=$p(^INC("RET",retReasonDr),"^",2)
 ...s aspAmt=$p(RecData,"^",17)
 ...s inclbObj=##class(User.INCItmLcBt).%OpenId(inclb,0)
 ...s BatchNo=inclbObj.INCLBINCIBDR.INCIBNo
 ...s ExpDate=inclbObj.INCLBINCIBDR.INCIBExpDate
 ...i ExpDate'="" s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 ...s stkqty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,UomDr)   ;当前可用库存
 ...s TypePointer=RowId_"||R"
 ...d ##Class(PHA.COM.Number).AddZero(.Qty,.Rp,.RpAmt,.Sp,.SpAmt,.InvMoney)
 ...s ret=RowId_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_Spec_"^"_Manf_"^"_Qty_"^"_Uom_"^"_BatchNo_"^"_ExpDate_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt_"^"_InvNo_"^"_InvDate_"^"_InvMoney_"^"_SxNo_"^"_TypePointer
 ...s tmp=ret
 ...s count=count+1
 ...q:count<Start
 ...q:count>end 
 ...i count=Start d
 ....w "{rows:["
 ....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmp,colNameStr)
 ....w retstring
 ...e  d
 ....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmp,colNameStr)
 ....w ","_retstring 
 ...s countrecord=countrecord+1  
  
 i countrecord>0  d
 .w "],results:"_count_"}"
 e  d
 .w ##class(web.DHCSTEXTCOMMON).GetNoJson()
 q ""
 
ErrorjsRecRetItm
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("web.DHCST.DHCINGdRecPaymentApproval"))
}

}
