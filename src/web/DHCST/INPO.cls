Import sqluser

/// Descript:订单管理
/// Creater:	ZhangDongmei
/// CreateDate:	2012-07-30
Class web.DHCST.INPO Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTPO";

/// Descript:	保存/更新订单信息
/// Creater:	gwj
/// CreateDate:	2013-01-22
/// Table:IN_Purplan,IN_PurplanItm
/// Input:计划单号,科室Id,操作人Id,类组Id,
/// 明细Id^库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室,
/// 明细Id^库存项id^采购数量^单位Id^供应商Id^进价^厂商id^配送商id^请求科室
/// Output:		
/// Return：订单id：成功，
/// -1:科室或供应商为空
/// -2   ;生成订单号失败
/// -3   ;保存订单失败
/// -4   ;保存订单附加表失败
/// -9   ;保存订单备注失败
/// -99  ;加锁失败
/// -2   ;生成计划单号失败
/// -3   ;保存计划单失败
/// -4   ;未找到需更新的计划单
/// -5:保存计划单明细失败,不能生成计划单
/// -7^失败药品：部分明细保存不成功，提示不成功的药品
/// w ##class(web.DHCST.INPO).Save("6^102^590^1^N^^2013-03-25","^969^71^0^2")
ClassMethod Save(MainInfo As %String, ListData As %String, Main As %String = "") As %Library.String
{
	n (MainInfo,ListData,Main)
	s Main=$g(Main)
	tstart
 	s $ZT="Error^DHCSTERROR"						;增加错误处理
	i +Main=0 s PoId=..Insert(MainInfo)     ;保存订单主表
	e  d
	.s PoId=..Update(+Main,MainInfo) 
	//
	i +PoId<=0 trollback
	q:+PoId<=0 PoId
	//保存明细记录
	s Ret=0
	i ListData'="" s Ret=##class(web.DHCST.INPOItm).Save(PoId,ListData)
	//
	i (+Ret=-6)!(+Ret=-5) trollback
	q:(+Ret=-6)!(+Ret=-5) -5 
	tcommit    ;只要有计划单明细保存成功，则提交事务
	q:+Ret'=0 Ret   ;存在保存失败的明细
	q PoId
}

/// 取订单主表的数据
/// Author:gwj
/// Date:2013-01-24
/// Argu:
/// 		IN_Po -主表rowid
/// Return:
///  主表的数据
/// w ##class(web.DHCST.INPO).Select("884")
ClassMethod Select(PoId As %String) As %String
{
 k PLIST
 s result=""
 &sql(select * into :PLIST() from IN_Po where %ID=:PoId)
 q:SQLCODE result
 s cnt=$o(PLIST(""),-1)
 s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim() //备注分隔符
 f i=1:1:cnt d
 .i i=9 s PLIST(i)=$LTS(PLIST(i),memoDelim)  //处理一下备注字段的值
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 .
 s VenDesc=$p(^APC("APCVM",PLIST(2)),"^",3)
 s PoLoc=""
 s PoLocDesc=""
 s StkGrpId=""
 s StkType=""
 s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
 i DhcPoId'=""  d
 .s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
 .s:PoLoc'="" PoLocDesc=$p(^CTLOC(PoLoc),"^",2)	
 .s Type=$p(^DHCINPO(DhcPoId),"^",4)
 .s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
 .s:StkGrpId'="" StkType=$p(^DHCSCG(StkGrpId),"^",2)
 q result_"^"_PoLoc_"^"_PoLocDesc_"^"_StkGrpId_"^"_StkType_"^"_VenDesc
}

/// 插入或更新表IN_PO
/// Author:zhwh
/// Date:2012-10-29
/// Argu:INPO
/// 
ClassMethod Update(INPO As %String, ListData As %String) As %Library.String
{
 n (INPO,ListData)
 //插入
 i INPO="" q ..Insert(ListData)	  
 //更新
 s AppName=..%GetParameter("AppName")
 q:##class(web.DHCST.Common.AppCommon).Lock(AppName_INPO)<0 -99
 
 //以下更新
	s VendorId=$p(ListData,"^",1)  //供应商rowid
	s LocId=$p(ListData,"^",2)  //科室rowid
	s UserId=$p(ListData,"^",3)   //用户rowid
	s StkGrpId=$p(ListData,"^",4)  //类组rowid
	s CmpFlag=$p(ListData,"^",5)   //完成标志(Y,N)
	s Remarks=$p(ListData,"^",6) //备注
	s NeedDate=$p(ListData,"^",7)  //要求到货日
	i NeedDate'="" s NeedDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(NeedDate)
	s AuditFlag=$p(ListData,"^",8)  //审核标志(Y,N)	
	i VendorId="" d ..ULock(INPO) q -1
	i LocId="" d ..ULock(INPO) q -1
	;
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	s Type=..sssCode()
	s resultString=0
	s AppName=..%GetParameter("AppName")
	;
	;b ;1
	;s PoNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
	;b ;2
	;q:PoNo="" -2   ;生成订单号失败
	;
	tstart
	s $ZT="Error^DHCSTERROR"
	s Err=0
	&sql(update IN_Po set INPO_APCVM_DR=:VendorId,INPO_Date=:CreateDate,INPO_SSUSR_DR=:UserId,
	INPO_Approved=:AuditFlag,INPO_Completed=:CmpFlag,INPO_DateNeeded=:NeedDate where %ID=:INPO)
	i SQLCODE'=0  d
	.;b ;3
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:IN_Po",VendorId,SQLCODE_":"_%msg)
	.s Err=-3
	.d ..ULock(INPO)
	.
	i Err'=0 trollback
	q:Err'=0 -3    ;保存订单失败
	s PoId=$p($g(%ROWID),$c(1))
	;
	
	//更新备注信息(zhwh,2012-10-29)
	s Err=..SetRemarks(PoId,Remarks)
	i Err<0 d 
	.d ..ULock(INPO)
	.trollback
	.
	q:Err'=0 -9
	//
	;更新订单附加表
	&sql(update DHC_InPo set PO_CTLOC_DR=:LocId,PO_SCG_DR=:StkGrpId,PO_StkType=:Type
	 where PO_INPO_DR=:PoId)
	i SQLCODE'=0  d
	.;b ;4
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_InPo",VendorId,SQLCODE_":"_%msg)
	.s Err=-4
	.d ..ULock(INPO) 
	i Err'=0 trollback
	q:Err'=0 -4    ;保存订单附加表失败
	tcommit
	;
	d ..ULock(INPO) 
	q PoId
}

/// Descript:	插入订单主信息
/// Creater:	gwj
/// CreateDate:	2013-01-22
/// Table:IN_Po
/// Input:供应商RowId^科室RowId^制单人^类组^完成标志^备注^要求到货日
/// Output:		
/// Return：成功:rowid
/// -1:科室或供应商为空
/// -2   ;生成订单号失败
/// -3   ;保存订单失败
/// -4   ;保存订单附加表失败
/// -9   ;保存订单备注失败
/// w ##class(web.DHCST.INPO).Insert("653^102^590^1^N^^2016-04-18")
ClassMethod Insert(ListData As %String) As %Library.String
{
	n (ListData)
	s VendorId=$p(ListData,"^",1)  //供应商rowid
	s LocId=$p(ListData,"^",2)  //科室rowid
	s UserId=$p(ListData,"^",3)   //用户rowid
	s StkGrpId=$p(ListData,"^",4)  //类组rowid
	s CmpFlag=$p(ListData,"^",5)   //完成标志(Y,N)
	s Remarks=$p(ListData,"^",6)  //备注
	s NeedDate=$p(ListData,"^",7)  //要求到货日
	s AuditFlag=$p(ListData,"^",8)  //审核标志(Y,N)	
	s HDCMInpoId=$p(ListData,"^",9) //医共体子医院订单id
	i AuditFlag'="Y" s AuditFlag="N"
	i NeedDate'="" S NeedDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(NeedDate)
	q:LocId="" -1
	q:VendorId="" -1
	;
	s PoDate=+$h
	s PoTime=$p($h,",",2)
	s Type=..sssCode()
	s CompFlag="N"  
	s resultString=0
	s AppName=..%GetParameter("AppName")
	s PoNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
	q:PoNo="" -2   ;生成订单号失败
	s Err=0
	&sql(insert into IN_Po(INPO_APCVM_DR,INPO_Date,INPO_SSUSR_DR,
	INPO_DateNeeded,INPO_Completed,INPO_CTCUR_DR,INPO_DHCMId) 
	values (:VendorId,:PoDate,:UserId,:NeedDate,:AuditFlag,1,:HDCMInpoId))
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:IN_Po",VendorId,SQLCODE_":"_%msg)
	.s Err=-3
	q:Err'=0 -3    ;保存订单失败
	s PoId=$p($g(%ROWID),$c(1))	
	//保存备注信息(zhwh,2012-10-29)
	s Err=..SetRemarks(PoId,Remarks)
	q:Err'=0 -9
	&SQL(update IN_Po set INPO_No=:PoNo where IN_PO=:PoId)
	;保存订单附加表
	&sql(insert into DHC_InPo(PO_INPO_DR,PO_CTLOC_DR,PO_SCG_DR,PO_StkType) 
	values (:PoId,:LocId,:StkGrpId,:Type))
	i SQLCODE'=0  d
	.;b ;4
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_InPo",VendorId,SQLCODE_":"_%msg)
	.s Err=-4
	q:Err'=0 -4    ;保存订单附加表失败
	q PoId
}

/// Descript:	插入订单主信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-07-30
/// Table:IN_Po
/// Input:供应商RowId^科室RowId^制单人^类组^完成标志^审核标志
/// Output:		
/// Return：成功:rowid
/// -1:科室或供应商为空
/// -2   ;生成订单号失败
/// -3   ;保存订单失败
/// -4   ;保存订单附加表失败
/// Description:	查询订单
/// Creator:zhangdongmei
/// Create Date:2012-07-31
/// Input:开始行,一页显示记录数,排序字段,排序方向,
/// 开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)^药品id
/// Output:		
/// Return：订单主表id^订单号^供应商^订购科室^订单状态^订单日期
/// w ##class(web.DHCST.INPO).Query("0","100","","","2013-03-18^2013-03-25^^^102^N^Y^^")
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
	n (StrParam,Start,Limit,Sort,Dir)
	//s ^zdm("web.DHCST.DHCINGdRec.Query")=Start_","_Limit_","_Sort_","_Dir_","_StrParam
	q:StrParam="" ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	s StartDate=$p(StrParam,"^",1)  //开始日期
	s EndDate=$p(StrParam,"^",2)   //^截止日期
	s No=$p(StrParam,"^",3)  //订单号
	s VendorId=$p(StrParam,"^",4)  //供应商id
	s LocId=$p(StrParam,"^",5)  //科室id
	s CompleteFlag=$p(StrParam,"^",6)  //完成标志
	s AuditFlag=$p(StrParam,"^",7)  //审核标志
	s Status=$p(StrParam,"^",8)  //订单状态
	s IncId=$p(StrParam,"^",9)  //订单状态
	q:StartDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	q:EndDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	q:LocId="" ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s pid=..NewPid()
	s $zt="ErrorQuery"
 	s result = ##class(%Library.ResultSet).%New()
 	s sqlStr = "select IN_PO as Rowid,INPO_No,INPO_APCVM_DR,INPO_APCVM_DR->APCVM_Name as Vendor,"_
	"INPO_Date,INPO_Completed,INPO_Approved,INPO_MianDHCMId from IN_PO "_
	" where (INPO_Date between "_StartDate_" and "_EndDate_")"
    s OrderField="Rowid"
    s:Sort="PoNo" OrderField="INPO_No"
    s:Sort="Vendor" OrderField="Vendor"
    s:Sort="PoDate" OrderField="INPO_Date"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s sqlStr=sqlStr_" order by "_OrderField_" "_Dir
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s Start=Start+1
	While(result.Next())
	{
		s PoId = result.Data("Rowid")
		s PoNo = result.Data("INPO_No")
		s Vendor = result.Data("Vendor")
		s VenId=result.Data("INPO_APCVM_DR")
		s PoDate=result.Data("INPO_Date")
		s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
		CONTINUE:DhcPoId=""
		s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
		s:PoLoc'="" PoLocDesc=$p(^CTLOC(PoLoc),"^",2)	
		s Type=$p(^DHCINPO(DhcPoId),"^",4)
		s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
		s PurUserId=$p(^INPO(PoId),"^",7)
		s CmpFlag=result.Data("INPO_Completed")
		s Approveed=result.Data("INPO_Approved")
		CONTINUE:($$ChkInci(IncId,PoId)=0)&(IncId'="")
		CONTINUE:(Type'=..sssCode())
		CONTINUE:(LocId'="")&(PoLoc'=LocId)
		CONTINUE:(No'="")&(PoNo'=No)
		CONTINUE:(VendorId'="")&(VenId'=VendorId)
		CONTINUE:(CompleteFlag'="")&(CmpFlag'=CompleteFlag)
		;CONTINUE:(AuditFlag'="")&(Approveed'=AuditFlag)
		s PoStatus=..GetPoStatus(PoId)
		CONTINUE:(Status'="")&('$f(Status,PoStatus))
		;
  		s:PoDate'="" PoDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PoDate,"ST")
		s VendorTel=$p($g(^APC("APCVM",VenId)),"^",7)
		s MianDHCMId=result.Data("INPO_MianDHCMId")
		s SendHDCMFlag=""
		i MianDHCMId'="" s SendHDCMFlag="Y"
		s Data=PoId_"^"_PoNo_"^"_Vendor_"^"_$g(PoLocDesc)_"^"_PoStatus_"^"_PoDate_"^"_VenId_"^"_PurUserId_"^"_StkGrpId_"^"_CmpFlag_"^"_VendorTel_"^"_SendHDCMFlag
		s count = count+1	
		s ^TMP("DHCST","INPO","Query",pid,count)=Data
	}
 	s Title="PoId^PoNo^Vendor^PoLoc^PoStatus^PoDate^VenId^PurUserId^StkGrpId^CmpFlag^VendorTel^SendHDCMFlag"
	i end>count s end=count
	s countrecords=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","INPO","Query",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","INPO","Query",pid,outputi)
	.s countrecords = countrecords+1
	.q:countrecords<Start
	.q:countrecords>end
	.i countrecords=Start d
	..w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(count)
	..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	..w retstring
	.e  d
	..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	..w ","_retstring
	i count=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:count=0 ""
	w "]}"
	k ^TMP("DHCST","INPO","Query",pid)
	Q ""
ErrorQuery
	k ^TMP("DHCST","INPO","Query",pid)
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
ChkInci(inci,inpp)
 ;检查某订单中是否包含某库存项
 ;return : 0 - 否 1 -是
 ;
 n (inci,inpp)
 s ch=0
 s ok=0
 f  s ch=$o(^INPO(inpp,"POI",ch)) q:(ch="")!(ok>0)  d
 .i $p(^INPO(inpp,"POI",ch),"^",1)=inci  s ok=1
 q ok
}

/// Descript:	删除订单信息
/// Creater:	gwj
/// CreateDate:	2013-01-25
/// Table:IN_Po
/// Input:rowid
/// Output:		
/// Return：0,成功,
ClassMethod Delete(Rowid As %String) As %Library.String
{
	n (Rowid)
 	;
 	;不能为空项
 	q:Rowid="" ""
 	s CompFlag=$p(^INPO(+Rowid),"^",9)
 	q:CompFlag="Y" -1   	;订单已经完成，不能删除
 	tstart
 	s $ZT="Error^DHCSTERROR"						;增加错误处理
 	s Err=0
 	&sql(Delete From IN_Po where IN_PO=:Rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:IN_Po",Rowid,SQLCODE_":"_%msg)
 	.s Err=-3
 	.
 	i Err'=0 trollback
 	q:Err'=0 -3   ;删除订单主表失败
 	&sql(Delete From DHC_InPo where PO_INPO_DR=:Rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_InPo",Rowid,SQLCODE_":"_%msg)
 	.s Err=-4
 	i Err'=0 trollback
 	q:Err'=0 -4   ;删除订单附加表失败
 	tcommit
 	q 0
}

/// Descript:取订单状态
/// Creater:zhangdongmei
/// CreateDate:2012-07-31
/// Input:订单主表id
/// Output:		
/// Return：订单状态：0:未入库，1:部分入库，2:全部入库
ClassMethod GetPoStatus(PoId As %String) As %String
{
	n (PoId)
	s Ingr=$o(^DHCINGR(0,"PO",PoId,0))
	q:Ingr="" 0
	s Flag=2   ;初始化为全部入库
	s Chl=0
	s PoiQtyTotal=0 //订单的全部药品金额
	s num=0 //订单品种数
	f  s Chl=$o(^INPO(PoId,"POI",Chl))  q:Chl=""  d
	.s PoiQty=$p(^INPO(PoId,"POI",Chl),"^",7)
	.s PoiQtyTotal=PoiQtyTotal+PoiQty
	.s num=num+1
	.
	s Flag=$$CheckInpoArrival(PoId,PoiQtyTotal,num)
	
	q Flag
CheckInpoArrival(PoId,PoiQtyTotal,num)
	n (PoId,PoiQtyTotal,num)
	s ingriQtySum=0
	s ingr=""
	s ingriNum=0
       f  s ingr=$o(^DHCINGR(0,"PO",PoId,ingr)) q:ingr=""  d
	.s ch=""
	.f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:ch=""  d
	..s ingriQty=$p(^DHCINGR(ingr,"GRI",ch),"^",4)
	..s ingriQtySum=ingriQtySum+ingriQty
	..s ingriNum=ingriNum+1
	..
	q:(ingriQtySum=0)&&(ingriNum=0) 0
	q:(ingriQtySum<PoiQtyTotal)||(ingriNum<num) 1

	q 2
}

/// 设置备注信息
/// Author:zhwh
/// Date:2012-10-29
/// Argu:
///  po -订单主表rowid
///  remarks -　备注内容串
/// Return:
///  0 - success
///  <0 - failure
ClassMethod SetRemarks(po As %String, remarks As %String) As %String
{
  n (po,remarks)
  s po=+po
  i po'>0 q -1
  
  i ##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_po)<0 q -99
  s obj=##class(User.INPO).%OpenId(po) 
  d obj.%Reload()
  d obj.INPORemarks.Clear()
  s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()
  f i=1:1:$l(remarks,memoDelim) d
  .s rem1=$p(remarks,memoDelim,i)
  .d obj.INPORemarks.Insert(rem1)
  .
  s ret= obj.%Save()
  d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_po)
  i $$$ISERR(ret) q -2
  ;
  q 0
}

/// 订单解锁操作
/// Author:zhwh
/// Date:2012-10-29
/// Argu:
///  inpo - 订单rowid
/// 
ClassMethod ULock(inpo As %String)
{
 n (inpo)
 q:inpo=""
 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_inpo)
 q
}

/// 设置订单状态
/// Author:zhwh
/// Date:2012-10-29
/// Argu:
///  inpo - 订单rowid
///  completed - 完成标志(Y,N)
/// Return:
///   0 -success
///   <0 - failure
ClassMethod SetComplete(inpo As %String, completed As %String, user As %String) As %String
{
 n (inpo,completed,user)
 q:inpo="" -1
 q:"YN"'[completed -10  //状态值不合法
 q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_inpo)<0 -99
 s ingr=$O(^DHCINGR(0,"PO",inpo,""))
 i +ingr>0 d ..ULock(inpo) q -2  //该订单已经转入库,禁止修改状态
 &sql(update in_po set inpo_completed=:completed,inpo_usercompleted=:completed,inpo_usercompleted_dr=:user where %ID=:inpo)	
 i SQLCODE'=0 d ..ULock(inpo) q -3
 d ..ULock(inpo)
 q 0
}

/// Descript:根据药品id取药品信息
/// Creater:	gwj
/// CreateDate:	2013-01-25
/// Table:
/// Input:库存项id,安全组id^科室id^用户id
/// Output:		
/// Return：产地id^产地名称^配送商id^配送商名称^入库单位id
/// ^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
/// w ##class(web.DHCST.INPO).GetItmInfo(534,274)
ClassMethod GetItmInfo(IncId As %String, Params As %String) As %Library.String
{
	n (IncId,Params)
	s GroupId=$p(Params,"^",1)
	s LocId=$p(Params,"^",2)
	s UserId=$p(Params,"^",3)
	s HospId=""
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s ParamStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	;
	s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigManf(IncId,##class(web.DHCST.INPO).%GetParameter("AppName"),ParamStr)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfDesc=$p(ManfInfo,"^",2)
	;
	s CarrierInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigCarrier(IncId,##class(web.DHCST.INPO).%GetParameter("AppName"),ParamStr)
	s CarrierId=$p(CarrierInfo,"^",1)
	s CarrierDesc=$p(CarrierInfo,"^",2)
	s BUomId=$p(^INCI(IncId,1),"^",10)
	s PurUomId=$p(^INCI(IncId,3),"^",6)
	s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	s Confac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	s Rp=##class(web.DHCST.Common.PriceCommon).GetConfigRp(IncId,PurUomId,##class(web.DHCST.INPO).%GetParameter("AppName"),ParamStr)
	//s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,HospId)
	s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,HospId,"G","")
	s StkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(IncId,LocId,PurUomId,+$h)
	s QtyInfo=##class(web.DHCST.Common.DrugStkCommon).GetItmLocMNRQtyUO(IncId,LocId,PurUomId)
	s MinQty=$p(QtyInfo,"^",1)
	s MaxQty=$p(QtyInfo,"^",2)
	s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
	s GeneInfo=##class(web.DHCST.Common.DrugInfoCommon).GetGene(IncId)
	s Gene=$p(GeneInfo,"^",2)
	s GoodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(IncId)
	s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(IncId)
	s Form=$p(FormInfo,"^",1)
	s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(IncId)
    s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
	;w $L(Form),!
	s Data1=ManfId_"^"_ManfDesc_"^"_CarrierId_"^"_CarrierDesc_"^"_PurUomId_"^"_$g(PurUomDesc)   //6
	s Data2=Rp_"^"_Sp_"^"_StkQty_"^"_MaxQty_"^"_MinQty_"^"_Gene_"^"_GoodName_"^"_Form_"^"_Spec_"^"_BUomId_"^"_Confac  //17
	s Data3=freeDrugFlag
	q Data1_"^"_Data2_"^"_Data3
}

/// 以json格式返回订单主表信息串
/// Author:zhwh
/// Date:2013-03-26
/// Arguments:
///  po - 订单主表信息
ClassMethod jsSelect(po As %String) As %String
{
 n (po)
 s sql="select *,"
 s sql=sql_"inpo_ssusr_dr->ssusr_name userName," 
 s sql=sql_"inpo_usercompleted_dr->ssusr_name completeUserName,"
 s sql=sql_"inpo_apcvm_dr->apcvm_name vendorName"
 s sql=sql_" from IN_PO where %ID="_po 
 //w sql,!
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 s colNameStr=""
 s count=0
 s resultString=""
 s colNum=xrs.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=xrs.GetColumnName(i)  //(xrs.GetColumnName(i),"_")
 .e  s colNameStr=colNameStr_"^"_xrs.GetColumnName(i)
 s json = ##class(Code.JsonObj).%New()
 while (xrs.Next())
 {
	s ret=""
	f i=1:1:colNum d
	.s df=xrs.%GetData(i)
	. 
	.i xrs.GetColumnName(i)="INPO_Date",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
	.i xrs.GetColumnName(i)="INPO_TransDate",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
	.i xrs.GetColumnName(i)="INPO_TransTime",df'="" s df=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(df,"ST")
	.i xrs.GetColumnName(i)="INPO_DateNeeded",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
	.i xrs.GetColumnName(i)="INPO_Remarks" d
	..s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()
	..s df=$lts(df,memoDelim)
	..
	.
	.i ret="" s ret=df
	.e   s ret=ret_"^"_df

	s DhcPoId=$o(^DHCINPO(0,"INPO",po,0))
	i DhcPoId'=""  d
	.s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
	.s:PoLoc'="" PoLocDesc=$p(^CTLOC(PoLoc),"^",2)	
	.s Type=$p(^DHCINPO(DhcPoId),"^",4)
	.s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
	.s:StkGrpId'="" StkGrpDesc=$p(^DHCSCG(StkGrpId),"^",2)
	s PoLoc=$g(PoLoc)
	s PoLocDesc=$g(PoLocDesc)
	s Type=$G(Type)
	s StkGrpId=$g(StkGrpId)
	s StkGrpDesc=$g(StkGrpDesc)   
	s ret=ret_"^"_PoLoc_"^"_PoLocDesc_"^"_Type_"^"_StkGrpId_"^"_StkGrpDesc
	
	s tmp=ret
	s count = count+1
	d json.InsertRowData(tmp)
 }
 
 s colNameStr=colNameStr_"^PoLoc^PoLocDesc^Type^StkGrpId^StkGrpDesc"
 s resultString = json.getJsonData(colNameStr,count)
 k json
 d xrs.Close()
 q resultString
}

/// 取订单主表的数据
/// Author:zhangxiao
/// Date:2013-06-24
/// Argu:
/// 		IN_Po -主表rowid
/// Return:
///  主表的数据
/// w ##class(web.DHCST.INPO).SelectMain("294")
ClassMethod SelectMain(PoId As %String) As %String
{
 k PLIST
 s result=""
 &sql(select * into :PLIST() from IN_Po where %ID=:PoId)
 q:SQLCODE result
 s cnt= 28 ///$o(PLIST(""),-1)  //避免后面因字段增加造成数据后移，固定取值位数
 s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim() //备注分隔符
 f i=1:1:cnt d
 .i i=9 s PLIST(i)=$LTS(PLIST(i),memoDelim)  //处理一下备注字段的值
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 .
 i PLIST(3)'="" d
 .s VenDesc=$p(^APC("APCVM",PLIST(3)),"^",3)
 i PLIST(8)'="" d
 .s user=$p(^SSU("SSUSR",PLIST(8)),"^",2)
 i (PLIST(4)'="")&&(PLIST(4)'["-") d
 .s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PLIST(4),"ST")
 
 s PoLoc=""
 s PoLocDesc=""
 s StkGrpId=""
 s StkType=""
 s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
 i DhcPoId'=""  d
 .s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
 .s:PoLoc'="" PoLocDesc=$p(^CTLOC(PoLoc),"^",2)	
 .s Type=$p(^DHCINPO(DhcPoId),"^",4)
 .s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
 .s:StkGrpId'="" StkType=$p(^DHCSCG(StkGrpId),"^",2)
 q result_"^"_PoLoc_"^"_PoLocDesc_"^"_StkGrpId_"^"_StkType_"^"_VenDesc_"^"_user_"^"_date
}

/// 取订单表的医共体子院主院订单id
/// Output:1 子院订单不为空  2 住院订单不为空
/// w ##Class(web.DHCST.INPO).GetMainINPoId(218)
ClassMethod GetMainINPoId(INPo)
{
	q:INPo="" ""
	s subINPO=$P(^INPO(INPo),"^",25)
	q:subINPO'="" 1
	s MainINPo=$P(^INPO(INPo),"^",26)
	q:MainINPo'="" 2
	q ""
}

ClassMethod NewPid()
{
  q $i(^DHCST("web.DHCST.INPO"))
}

}
