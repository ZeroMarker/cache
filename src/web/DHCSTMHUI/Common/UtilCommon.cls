Import sqluser

/// Descript:常用方法（公共）
Class web.DHCSTMHUI.Common.UtilCommon Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:检查字符串ListStr以delim分隔的数组里是否包含字符串SubStr
/// Creator：	Zhouyg
/// CreatDate：	2011-03-08
/// Table:		
/// Input:		ListStr-需检查的字符串,SubStr-被搜索的字符串,delim-分隔符
/// Output:
/// Return:0-不存在,其他返回数组位置
ClassMethod FindInList(ListStr, SubStr, delim) As %Library.String
{
	n (ListStr,SubStr,delim)
	s lenList=$L(ListStr,delim)
	s i=1
	s Ret=0
	f  s TmpStr=$p(ListStr,delim,i) q:(i>lenList)!(Ret'=0)  d
	.i (TmpStr'="")&(SubStr=TmpStr) s Ret=i q
	.s i=i+1
	q Ret
}

/// Descript:检查字符串ListStr以delim分隔的数组里是否包含字符串SubStr以delim分割的元素
/// Creator：	wangjiabin
/// CreatDate：	2015-05-12
/// Table:		
/// Input:		ListStr-需检查的字符串,SubStr-被搜索的字符串,delim-分隔符
/// Output:
/// Return:		0-不存在,其他返回数组位置
ClassMethod CheckInList(ListStr, SubStr, Delim) As %Library.String
{
	n (ListStr,SubStr,Delim)
	q:SubStr="" 0
	s Ret=0
	s Len=$L(SubStr,Delim)
	f i=1:1:Len q:(Ret'=0)  d
	.s Sub=$p(SubStr,Delim,i)
	.s Ret=..FindInList(ListStr,Sub,Delim)
	q Ret
}

/// Descript:	根据两个传入单位取得转换率
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		fr, to
/// Output:		Return
/// Return：	转换率
/// Others: w ##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(14,26)
ClassMethod UOMFac(fr, to)
{
	n (fr,to)
	q:fr=to 1
	q:(fr="")||(to="") 1
	s rowid=""
	s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid))
	i rowid'="" d
	.s fac=$p(^CT("CTCF",rowid),"^",3)
	.s fac=$p(fac,$c(1))
	e  d
	.s fac=1
	q fac
}

/// Creator:zdm;
/// CreatDate:2011-04-21
/// Description:取支配科室
/// Table:
/// Input:主科室rowid
/// Return:支配科室
ClassMethod GetSubLoc(leadloc) As %Library.String
{
	n (leadloc) 
	q:leadloc="" "" 
	s sublocdr=""
	s strLoc=""
	f  s sublocdr=$o(^DHCDLOC(0,"LEAD",leadloc,sublocdr)) q:sublocdr=""  d
	.s useflag=$p(^DHCDLOC(sublocdr),"^",3) 
	.q:useflag'="Y"
	.i strLoc=""  d
	..s strLoc=sublocdr
	.e  d
	..s strLoc=strLoc_"^"_sublocdr
	.
	q strLoc
}

/// Description:根据ss_user的ID找CT_Hospital的信息
/// Creator:zhouyg
/// CreatDate:2009-08-11
/// Table:ss_user,Ct_loc,Ct_Hospital
/// Input:用户ss_user表RowID
/// Return:医院ID_"^"_医院代码_"^"_医院描述
ClassMethod GetUserHosp(userid) As %Library.String
{
	N (userid)
	Q:userid="" ""
	Q:'$D(^SSU("SSUSR",userid)) ""
	S deflocdr=$P(^SSU("SSUSR",userid),"^",4)
	Q:deflocdr="" ""
	Q:'$D(^CTLOC(deflocdr)) ""
	S hospdr=$P(^CTLOC(deflocdr),"^",22)
	Q:hospdr="" ""
	Q:'$D(^CT("HOSP",hospdr)) ""
	S hospcode=$P(^CT("HOSP",hospdr),"^",1)
	S hospdesc=$P(^CT("HOSP",hospdr),"^",2)
	S retstr=hospdr_"^"_hospcode_"^"_hospdesc
	Q retstr
}

/// Description:根据科室的ID找CT_Hospital的信息
/// Table:Ct_loc,Ct_Hospital
/// Input:科室表RowID
/// Return:医院ID_"^"_医院代码_"^"_医院描述
ClassMethod GetLocHosp(locid) As %Library.String
{
	N (locid)
	Q:locid="" ""
	Q:'$D(^CTLOC(locid)) ""
	S hospdr=$P(^CTLOC(locid),"^",22)
	Q:hospdr="" ""
	Q:'$D(^CT("HOSP",hospdr)) ""
	S hospcode=$P(^CT("HOSP",hospdr),"^",1)
	S hospdesc=$P(^CT("HOSP",hospdr),"^",2)
	S retstr=hospdr_"^"_hospcode_"^"_hospdesc
	Q retstr
}

ClassMethod LocToRowID(TmpLoc, Params) As %Library.String
{
	n (TmpLoc,Params)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s LocId="",LocDesc=""
	s TmpLoc=$$ALPHAUP^SSUTIL4(TmpLoc)
	q:TmpLoc="" ""
	s RowId=""
	f RowId=$o(^CTLOC(0,"Desc",TmpLoc,RowId))  q:(RowId="")||(LocId'="")  d
	.s ret=##class(web.DHCSTMHUI.CTLOC).LocOfHosp(RowId, gHospId)
	.q:(ret'=0)
	.s LocDesc=$p(^CTLOC(RowId),"^",2)
	.s LocId=RowId
	
	q LocId_"^"_LocDesc
}

/// w ##class(web.DHCSTMHUI.Common.UtilCommon).GetLocItmGrp(3) 
/// 获取科室项目组
ClassMethod GetLocItmGrp(locdr) As %Library.String
{
	n (locdr)
	q:locdr="" ""
	q:$d(^DHCLOC(0,"LOC",locdr))=0 ""
	
	s dhclocdr=$o(^DHCLOC(0,"LOC",locdr,0))
	q:dhclocdr="" ""
	q:$d(^DHCLOC(dhclocdr))=0 ""
	
	s ligdr=$p(^DHCLOC(dhclocdr),"^",2)
	q:ligdr="" ""
	q:$d(^DHCLIG(ligdr))=0 ""
	s ligdesc=$p($g(^DHCLIG(ligdr)),"^",2)
	q ligdesc
}

/// Descript:获取科室组名称
/// Creator：zhangxiao
/// CreatDate：2013-12-09
/// Table:		
/// Input:	科室id
/// Output:
/// Return:科室组名称
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).GetLocGrpItm(3)
ClassMethod GetLocGrpItm(locdr) As %Library.String
{
	n (locdr)
	q:locdr="" ""
	q:$d(^DHCLOC(0,"LOC",locdr))=0 ""
	
	s dhclocdr=$o(^DHCLOC(0,"LOC",locdr,0))
	q:dhclocdr="" ""
	q:$d(^DHCLOC(dhclocdr))=0 ""
	
	s Slgdr=$p(^DHCLOC(dhclocdr),"^",3)
	q:Slgdr="" ""
	q:$d(^DHCSLG(Slgdr))=0 ""
	s Slgdesc=$p($g(^DHCSLG(Slgdr)),"^",2)
	q Slgdesc
}

/// Descript:根据取整比例将目标数据取整
/// Table:		
/// Input:	目标数，取整比例
/// Output:
/// Return:取整后的数
ClassMethod GetFinalQty(qty As %String, intfac As %String) As %String
{
	n (qty,intfac)
	s intfac=+intfac
	s qtyint=$p(qty,".",1)
	s qtydec=$p(qty,".",2)
	i qtydec<intfac  d
	.s finalqty=qtyint
	e  d
	.s finalqty=qtyint+1
	.
	q finalqty
}

/// 备注内容"行"之间的分隔符
/// Author:zhwh
/// Date:2012-10-25
/// Argu:
/// Return:字符
ClassMethod MemoDelim() As %Library.String
{
	q "|"
	//q $c(3)
}

/// 备注global循环取值
/// Author:lxt
/// Date:20210603
/// Argu:
/// Return:字符
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).GetREMList("^INRQ",44)
ClassMethod GetREMList(GlobalName, RowId) As %Library.String
{
	n (GlobalName,RowId)
	q:(GlobalName="")||(RowId="") ""
	q:'$d(@GlobalName@(RowId,"REM")) ""
	
	s len=@GlobalName@(RowId,"REM",0)
	s List=""
	f i=1:1:len  d
	.s tmpREM=@GlobalName@(RowId,"REM",i)
	.i List="" s List=tmpREM
	.e  s List=List_..MemoDelim()_tmpREM
	q List
}

/// Descript:返回一条record(json)
/// Creator：wxj
/// CreatDate：2022-10-16
/// Table:		
/// Input:数据串, 标题串, 分隔符
/// Output:
/// Return:记录数
/// 	w ##class(web.DHCSTMHUI.Common.UtilCommon).GetDynamicJsonStr("123^adbc^aka","A^B^C")
ClassMethod GetJsonStr(dataStr, titleStr, del = "^") As %Library.String
{
	n (dataStr,titleStr,del)
	q:dataStr="" "{}"
	q:titleStr="" "{}"
	s len=$l(dataStr,del)
	s tlen=$l(titleStr,del)
	s ReturnJson=##class(%DynamicObject).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	f i=1:1:tlen  d
	.s data=$p(dataStr,del,i)
	.
	.s CheckJsonFlag=((data'="")&&(($e(data,1)="{")||($e(data,1)="[")))
	.i CheckJsonFlag s Sc=PJObj.%FromJSON(data)
	.s isObject=(CheckJsonFlag&&(Sc=0))
	.;s isObject=($e(data,1,9)="{""RowId"":")||(($e(data,1,2)="[{"))
	.
	.s data=$tr(data,$c(13,10,0,9))   //处理$c(13,10,0,9)
	.;仅当不是object格式时进行转义
	.;当data不是object时进行转义； 当data是object时，将data从字符串转为jsonobj
	.i 'isObject d
	..i ($ISVALIDNUM(data)&&(+data=data)) d
	...s tmpVal=$s(data<0:-data,1:data)
	...s:($e(tmpVal,1)=".") data=$tr($fn(data,","),",")		;数字格式处理 .5-->0.5, -.5-->-0.5
	.else  d
	..s data=##class(%DynamicObject).%FromJSON(data)
	.
	.s title=$p(titleStr,del,i)
	.d ReturnJson.%Set(title,data)
	.
	s jsonStr=ReturnJson.%ToJSON()
	q jsonStr
}

ClassMethod Replace(data, frStr, toStr) As %Library.String
{
	n (data,frStr,toStr)
	q $Replace(data,frStr,toStr)
}

/// Description:格式化combo返回值,用于ext中Combo.setValue(***). 注:使用双引号
/// Creator:	wangjiabin
/// CreatDate：	2014-07-15
/// Input:		rowid, desc
/// Output:
/// Return:		
ClassMethod ComboStr(RowId As %String, Description As %String) As %Library.String
{
	n (RowId,Description)
	
	s Description=$Replace(Description,"\","\\")
	s Description=$Replace(Description,"""","\""")						;转义双引号,不需转义单引号
	s Description=$tr(Description,$c(13,10,0,9))
	i ($ISVALIDNUM(Description)&&(+Description=Description)) d
	.s tmpVal=$s(Description<0:-Description,1:Description)
	.s:($e(tmpVal,1)=".") Description=$tr($fn(Description,","),",")		;数字格式处理 .5-->0.5, -.5-->-0.5
	
	s str="{""RowId"":"""_RowId_""",""Description"":"""_Description_"""}"
	q str
}

/// 取当前科室的第一个被支配科室信息（比如通过实库取到暂存库）
ClassMethod GetMainLoc(loc) As %String
{
	n (loc)
	q:loc="" ""
	s locId=$o(^DHCLOC(0,"MAINLOC",loc,""))
	s locDesc=""
	s:locId'="" locDesc=$p(^CTLOC(locId),"^",2),locDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(locDesc)
	
	q locId_"^"_locDesc
}

/// 取当前科室的支配科室信息（比如通过暂存库取到实库）
ClassMethod GetMainLocInfo(DominLocId) As %String
{
	n (DominLocId)
	s LocId=..MLoc(DominLocId)
	s LocDesc=""
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
	
	q LocId_"^"_LocDesc
}

/// 取当前科室的支配科室Id（比如通过暂存库取到实库）
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).MLoc()
ClassMethod MLoc(dominloc) As %String
{
	n (dominloc)
	q:dominloc="" ""
	s dhcstCtLoc=$o(^DHCLOC(0,"LOC",dominloc,""))
	q:dhcstCtLoc="" ""
	s MainLocId=$p(^DHCLOC(dhcstCtLoc),"^",6)
	q MainLocId
}

/// Descript:	获取当前科室的被支配科室串
/// Creator:	lxt
/// CreateDate:	20201123
/// Table:		LocId
/// Input:		
/// Return：	支配科室串(用,隔开)
/// Others: w ##class(web.DHCSTMHUI.Common.UtilCommon).GetDominLoc()
ClassMethod GetDominLoc(LocId As %String) As %String
{
	n (LocId)
	s dLocs=""
	&sql(declare domiLoc cursor for
	select dhcloc_ctloc_dr From dhcst_ctloc where dhcloc_mainloc_dr = :LocId)
	&sql(open domiLoc)
	f  &sql(fetch domiLoc into :subLoc) q:SQLCODE  d
	.i dLocs="" s dLocs=subLoc
	.e  s dLocs=dLocs_","_subLoc
	&sql(close domiLoc)
	q dLocs
}

/// 获取当前科室的支领科室id(defloc),为空返回自身
ClassMethod GetLeadLoc(loc) As %String
{
	n (loc)
	q:loc="" ""
	s LeadLoc=loc
	&sql(select DLOC_Lead_DR into :LeadLoc from DHC_DefLoc where DLOC_Sub_DR=:loc)
	q LeadLoc
}

/// 获取当前科室的所支配的科室id串(defloc),^隔开,为空返回自身
ClassMethod GetLeadSubLoc(loc) As %String
{
	n (loc)
	q:loc="" ""
	s SubLocStr=loc
	&sql(declare DefSubLocCursor cursor for
		select DLOC_Sub_DR from dhc_defloc where DLOC_Lead_DR=:loc
	)
	&sql(open DefSubLocCursor)
	f  &sql(fetch DefSubLocCursor into :SubLoc) q:SQLCODE  d
	.s SubLocStr=SubLocStr_"^"_SubLoc
	&sql(close DefSubLocCursor)
	q SubLocStr
}

/// Descript:验证明细数据是否正确
/// Input:
/// Output:		
/// Return:		数据验证通过:"", 数据验证不通过:错误信息
ClassMethod CheckDetail(AppCode As %String, Inclb As %String, Qty As %String, Rp As %String, Sp As %String, UomId As %String, Type As %String = "", DirtyQty As %String = 0) As %Library.String
{
	n (AppCode,Inclb,Qty,Rp,Sp,UomId,Type,DirtyQty)
	s Loc=$$LOC^ST01(Inclb)
	s HosId=$p(^CTLOC(Loc),"^",22)
	s Inci=+Inclb
	s:Inci'="" KeyValue=$p(^INCI(Inci,1),"^",2)
	s Incicode=$p(^INCI(Inci,1),"^",1)
	s ErrInfo=""
	i +Inclb'>0  d
	.s ErrInfo=Incicode_"库存批次为空"
	q:ErrInfo'="" ErrInfo

	i +UomId'>0  d
	.s ErrInfo=Incicode_"库存单位为空"
	q:ErrInfo'="" ErrInfo

	s BUomId=$p(^INCI(Inci,1),"^",10)
	i +BUomId'>0  d
	.s ErrInfo=Incicode_"基本单位为空"
	q:ErrInfo'="" ErrInfo

	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	i +Fac=0  d
	.s ErrInfo=Incicode_"项目单位和基本单位不存在转换关系"
	q:ErrInfo'="" ErrInfo

	s:Type="A" Qty=-Qty   ;调整的时候
	s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,UomId)
	s:Type="T" AvaQty=AvaQty+DirtyQty
	s:Type="D" AvaQty=AvaQty+Qty	;报损时可用数量加上本次报损导致的占用数量
	s LeftQty=AvaQty-Qty
	i LeftQty<0  d
	.s ErrInfo=Incicode_"可用库存不足"
	q:ErrInfo'="" ErrInfo

	s currentRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HosId)
	i Rp'=currentRp  d
	.s ErrInfo=Incicode_"进价变化"
	q:ErrInfo'="" ErrInfo

	s currentSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HosId)
	//i (Sp'="")&(Sp'=currentSp)  d
	//.s ErrInfo=Incicode_"售价变化"

	q ""
}

/// w ##class(web.DHCSTMHUI.Common.UtilCommon).SendEmail("826179@qq.com","hello world","mail.dhcc.com.cn","zhangxiao","*****","zhangxiao@dhcc.com.cn","请领单")
/// Arguments:
/// Address - 接收邮箱
/// MessageText - 内容
/// SmtpServer - smtp服务器地址
/// UserName - 用户
/// Password - 授权码
/// From - 发件邮箱
/// Subject - 邮件主题
ClassMethod SendEmail(Address As %String, MessageText As %String, SmtpServer As %String, UserName As %String, Password As %String, From As %String, Subject As %String)
{
	// Create an SMTP object and connect to a server
	Set Mailer = ##class(%Net.SMTP).%New()

	// Fill in the name of your mail server
	Set Mailer.smtpserver = SmtpServer   ;smtp服务器地址

	s auth=##class(%Net.Authenticator).%New()
	s auth.UserName=UserName //用户
	s auth.Password=Password   //psd  //授权码 不是登录密码
	s Mailer.authenticator=auth

	// Create a Message object and fill in From, To, Subject
	Set Msg = ##class(%Net.MailMessage).%New()
	Set Msg.From=From
	Do Msg.To.Insert(Address)
	Set Msg.Subject =Subject
	// Add message content
	Do Msg.TextData.Write(MessageText)
	// Send the message and close objects
	Do Mailer.Send(Msg)
	Quit
}

/// Description:记录单据打印日志
/// Creator:	wangjiabin
/// CreatDate:	2017-11-25
/// Table:		DHC_MatBillPrintLog
/// Input:		Type(业务类型,有台帐的用台帐类型),Pointer(主表rowid),
/// 			AutoFlag(自动打印标记),UserId(打印人)
/// OutPut:		
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).BillPrintLog("R",506,"N",541)
ClassMethod BillPrintLog(Type, PointerStr, AutoFlag, UserId, Num = "1") As %String
{
	n (Type,PointerStr,AutoFlag,UserId,Num)
	;加锁?
	q:(Type="")||(PointerStr="") -1
	s Err=0
	ts
	;获取之前的打印数据, 对于有打印标记的,同时进行记录
	s PointerLen=$l(PointerStr,"^")
	f i=1:1:PointerLen q:Err'=0   d
	.s Pointer=$p(PointerStr,"^",i)
	.s BillInfo=$$GetBillPrintInfo(Type,Pointer)
	.s PrintNum=$p(BillInfo,"^",1)
	.s CompFlag=$p(BillInfo,"^",2)
	.s AuditFlag=$p(BillInfo,"^",3)
	.s OperNo=$p(BillInfo,"^",4)
	
	.s obj=##class(User.DHCMatBillPrintLog).%New()
	.s obj.PRTType=Type
	.s obj.PRTPointer=Pointer
	.s obj.PRTNo=OperNo
	.d obj.PRTSSUSRDRSetObjectId(UserId)
	.s obj.PRTDate=+$h
	.s obj.PRTTime=$p($h,",",2)
	.s obj.PRTMode=AutoFlag				;Y:自动打印,N:手动打印
	.s obj.PRTCompleted=CompFlag
	.s obj.PRTStatus=AuditFlag
	.s obj.PRTCount=Num+PrintNum			;本次打印次数+以前打印次数
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s Err=-10
	.q:Err<0
	i Err'=0 tro  q Err
	tc
	q Err
	
GetBillPrintInfo(Type,Pointer)
	n (Type,Pointer)
	
	s PrintCount=0
	s LastPrtId=$o(^User.DHCMatBillPrintLogI("IndexTypePointer",Type,Pointer,""),-1)
	i LastPrtId'="" d
	.s LastPrtInfo=^User.DHCMatBillPrintLogD(LastPrtId)
	.s PrintCount=$lg(LastPrtInfo,11)
	
	s MainId=$p(Pointer,"||",1),Ch=$p(Pointer,"||",2)
	s (OperNo,CompFlag,AuditFlag)=""
	i Type="G" d		//入库
	.s OperNo=$p(^DHCINGR(MainId),"^",1)
	.s CompFlag=$p(^DHCINGR(MainId),"^",12)
	.s AuditFlag=$p(^DHCINGR(MainId),"^",29)
	e  i Type="R" d		//退货
	.s OperNo=$p(^INGRT(MainId),"^",1)
	.s CompFlag=$p(^INGRT(MainId),"^",6)
	.s AuditFlag=$p(^INGRT(MainId),"^",15)
	e  i (Type="T")||(Type="K") d		//出库
	.s OperNo=$p(^DHCINIT(MainId),"^",1)
	.s CompFlag=$p(^DHCINIT(MainId),"^",12)
	.s AuditFlag=$p(^DHCINIT(MainId),"^",14)
	.
	.s InitObj=##class(User.DHCInIsTrf).%OpenId(MainId)
	.i InitObj.INITPrintFlag="Y" d
	..k InitObj
	.e  d
	..s InitObj.INITPrintFlag="Y"
	..d InitObj.%Save()
	.
	e  i Type="A" d		//调整
	.s OperNo=$p(^DHCINAD(MainId),"^",1)
	.s CompFlag=$p(^DHCINAD(MainId),"^",13)
	.s AuditFlag=$p(^DHCINAD(MainId),"^",14)
	e  i Type="D" d		//报损
	.s OperNo=$p(^DHCINSP(MainId),"^",1)
	.s CompFlag=$p(^DHCINSP(MainId),"^",12)
	.s AuditFlag=$p(^DHCINSP(MainId),"^",14)
	e  i Type="RQ"  d		//请求
	.s OperNo=$p(^INRQ(MainId),"^",1)
	.s CompFlag=$p(^INRQ(MainId),"^",8)
	.s AuditFlag=CompFlag
	e  i Type="INPP" d		//采购
	.s OperNo=$p(^INPP(MainId),"^",1)
	.s CompFlag=$p(^INPP(MainId),"^",8)
	.s AuditFlag=$p(^INPP(MainId),"^",10)
	e  i Type="PO" d		//订单
	.s OperNo=$p(^INPO(MainId),"^",1)
	.s CompFlag=$p(^INPO(MainId),"^",9)
	.s AuditFlag=$p(^INPO(MainId),"^",8)
	e  i Type="STK" d		//盘点
	.s OperNo=$p(^DHCINST(MainId),"^",1)
	.s CompFlag=$p(^DHCINST(MainId),"^",13)
	.s AuditFlag=$p(^DHCINST(MainId),"^",14)
	
	s Result=PrintCount_"^"_CompFlag_"^"_AuditFlag_"^"_OperNo
	q Result
}

/// Descript:	检查用户名,签名密码是否一致
/// Creator:	wangjiabin
/// CreatDate:	2013-06-24
/// Input:		UserId,PassWord
/// Output:		1:一致, 其他不一致
ClassMethod CheckPassword(UserId, PassWord) As %String
{
	n (UserId,PassWord)
	q:UserId="" -1
	s RealPassWord=""
	&sql(select ssusr_pin into :RealPassWord from ss_user where %id=:UserId)
	q:RealPassWord="" -2
	s EncryptPassWord=##Class(web.SSUser).Encrypt(PassWord)
	q:RealPassWord'=EncryptPassWord -3
	
	q 1
}

/// creator:	wangjiabin
/// date:		2015-06-14
/// description:根据Initials科室,有登录权限的返回人员rowid,无权限的返回""
/// input:		
/// output:		人员rowid或""
ClassMethod GetDeptUserId(LocId, Initials)
{
	n (LocId,Initials)
	s Initials=$$ALPHAUP^SSUTIL4(Initials)
	q:LocId="" ""
	q:Initials="" ""
	
	s SSUSR=$o(^SSU("SSUSR",0,"SSUSR_Initials",Initials,0))
	q:SSUSR="" ""
	
	s DefaultDept=$p(^SSU("SSUSR",SSUSR),"^",4)
	q:(DefaultDept=LocId) SSUSR		;科室一致的,返回人员id
	
	s isOK=0
	s ch=0
	f  s ch=$o(^SSU("SSUSR",SSUSR,"OTHLL",ch)) q:(ch="")!(isOK'=0)  d
	.s othllLoc=$p(^(ch),"^",1)
	.s:othllLoc=LocId isOK=1
	.q:isOK'=0
	q:isOK=0 ""
	
	q SSUSR
}

/// CreatDate:	20180125 lihui
/// Description:判断某个业务单据是否高值单
/// Input:		主表rowid,业务类型(PO,G,R,T....)
/// Return:		Y/N
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(8569,"G")
ClassMethod GetCertDocHVFlag(Rowid As %String, Type As %String) As %String
{
	n (Rowid,Type)
	q:Rowid="" ""
	q:Type="" ""
	s DocHVFlag="N"
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Rowid,"GRI",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Ingri=Rowid_"||"_Ch
	..s Inci=$p(^DHCINGR(Rowid,"GRI",Ch),"^",25)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..i HVFlag="Y" s DocHVFlag="Y" q
	..s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",Ingri)
	..i HVBarCode'="" s DocHVFlag="Y" q
	
	i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(Rowid,"DHCGRR",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Ingrti=Rowid_"||"_Ch
	..s Inclb=$p(^INGRT(Rowid,"DHCGRR",Ch),"^",6)
	..s Inci=+Inclb
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..i HVFlag="Y" s DocHVFlag="Y" q
	..s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("R",Ingrti)
	..i HVBarCode'="" s DocHVFlag="Y" q
	
	i Type="T" d
	.s Ch=0
	.f  s Ch=$o(^DHCINIT(Rowid,"ITI",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Initi=Rowid_"||"_Ch
	..s Inclb=$p(^DHCINIT(Rowid,"ITI",Ch),"^",3)
	..s Inci=+Inclb
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..i HVFlag="Y" s DocHVFlag="Y" q
	..s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("T",Initi)
	..i HVBarCode'="" s DocHVFlag="Y" q
	
	i Type="C" d
	.s Ch=0
	.f  s Ch=$o(^DHCINDS(Rowid,"DSI",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Indsi=Rowid_"||"_Ch
	..s Inclb=$p(^DHCINDS(Rowid,"DSI",Ch),"^",3)
	..s Inci=+Inclb
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..i HVFlag="Y" s DocHVFlag="Y" q
	..s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("C",Indsi)
	..i HVBarCode'="" s DocHVFlag="Y" q
	
	i Type="L" d
	.s Ch=0
	.f  s Ch=$o(^DHCINDSR(Rowid,"I",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Indsri=Rowid_"||"_Ch
	..s Inclb=$p(^DHCINDSR(Rowid,"I",Ch),"^",1)
	..s Inci=+Inclb
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..i HVFlag="Y" s DocHVFlag="Y" q
	..s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("L",Indsri)
	..i HVBarCode'="" s DocHVFlag="Y" q
	
	i Type="PO" d
	.s Ch=0
	.f  s Ch=$o(^INPO(Rowid,"POI",Ch)) q:(Ch="")||(DocHVFlag="Y")  d
	..s Inci=$p(^INPO(Rowid,"POI",Ch),"^",1)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..i HVFlag="Y" s DocHVFlag="Y" q
	
	i Type="Req" d
	.s Ch=0
	.f  s Ch=$o(^INRQ(Rowid,"RQI",Ch)) q:(Ch="")!(DocHVFlag="Y")  d
	..s Inci=$P(^INRQ(Rowid,"RQI",Ch),"^",4)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	..i HVFlag="Y" s DocHVFlag="Y" q
	
	q DocHVFlag
}

/// CreatDate:	20190110 lihui
/// Description:判断某个业务单据是否物资业务单据
/// Input:		主表rowid,业务类型(G,R,T,REQ(请求)....)
/// Return:		Y/N
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).IfMatDoc(9099,"REQ")
ClassMethod IfMatDoc(Rowid As %String, Type As %String) As %String
{
	n (Rowid,Type)
	q:Rowid="" ""
	q:Type="" ""
	s DocMatFlag=""
	i Type="G" d
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Rowid,"GRI",Ch)) q:(Ch="")||(DocHVFlag'="")  d
	..s Inci=$p(^DHCINGR(Rowid,"GRI",Ch),"^",25)
	..s type=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(+Inci,"M",0),"^",3)
	..i type="M" d
	...s DocMatFlag="Y"
	..e  d
	...s DocMatFlag="N"
	i Type="R" d
	.s Ch=0
	.f  s Ch=$o(^INGRT(Rowid,"DHCGRR",Ch)) q:(Ch="")||(DocMatFlag'="")  d
	..s Inclb=$p(^INGRT(Rowid,"DHCGRR",Ch),"^",6)
	..s Inci=+Inclb
	..s type=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(+Inci,"M",0),"^",3)
	..i type="M" d
	...s DocMatFlag="Y"
	..e  d
	...s DocMatFlag="N"
	i Type="T" d
	.s Ch=0
	.f  s Ch=$o(^DHCINIT(Rowid,"ITI",Ch)) q:(Ch="")||(DocMatFlag'="")  d
	..s Inclb=$p(^DHCINIT(Rowid,"ITI",Ch),"^",3)
	..s Inci=+Inclb
	..s type=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(+Inci,"M",0),"^",3)
	..i type="M" d
	...s DocMatFlag="Y"
	..e  d
	...s DocMatFlag="N"
	i Type="REQ" d
	.s Ch=0
	.f  s Ch=$o(^INRQ(Rowid,"RQI",Ch)) q:(Ch="")||(DocMatFlag'="")  d
	..s Inci=$p(^INRQ(Rowid,"RQI",Ch),"^",4)
	..s type=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(+Inci,"M",0),"^",3)
	..i type="M" d
	...s DocMatFlag="Y"
	..e  d
	...s DocMatFlag="N"
	q DocMatFlag
}

/// CreatDate:	20200429
/// Creator:	lxt
/// Description:返回PrintData
/// Input:		字段名，数据
/// Return:		打印数据
ClassMethod GetXmlPrintData(TitleStr, DataStr)
{
	Set PrintObj =  ##class(ext.util.JsonObject).%New()
	
	s Len=$l(TitleStr,"^")
	f i=1:1:Len d
	.s Title=$p(TitleStr,"^",i)
	.s Data=$p(DataStr,"^",i)
	.d PrintObj.Put(Title,Data)
	
	set rtn = PrintObj.GetPrintData()
	do PrintObj.%Close()
	Set PrintObj = ""
	quit rtn
}

/// 根据CSP名称获取菜单信息(json格式)
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).GetMenuInfoByCsp("dhcstmhui.ingdrec.csp")
ClassMethod GetMenuInfoByCsp(CspName As %String) As %String
{
	n (CspName)
	q:CspName="" ""
	q:CspName="dhcstmhui.menu.csp" ""
	q:CspName'["dhcstmhui." ""				;菜单约定一下,简单控制
	s (MenuId,Caption)=""
	&sql(SELECT ID, Caption into :MenuId,:Caption FROM websys.menu WHERE LinkUrl=:CspName)
	
	s Data=MenuId_"^"_Caption
	s Title="MenuId^Caption"
	s MenuInfo=..GetJsonStr(Data,Title)
	q MenuInfo
}

/// w ##class(web.DHCSTMHUI.Common.UtilCommon).ServerIP()
ClassMethod ServerIP()
{
	new
	s SERVER=$p($zu(54,13,$zu(54,0)),",")
	q SERVER
}

/// Descript:	判断科室是否库房
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		LocId
/// Input:		
/// Return：	Y:是库房;否则不是库房 
/// Others: w ##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc()
ClassMethod IfStockLoc(LocId As %String) As %String
{
	n (LocId)
	q:LocId="" "N"
	
	s LocStockType=""
	s dhcctlocid=$o(^DHCLOC(0,"LOC",LocId,""))
	s:dhcctlocid'="" LocStockType=$p(^DHCLOC(dhcctlocid),"^",5)
	q:LocStockType="" "N"
	
	q "Y"
}

/// Description: Lodop打印xml条码模板调用
/// Creator:	lxt
/// CreateDate:	2021-2-26
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).EncryptInput()
ClassMethod EncryptInput() As %String
{
	s str="<input id='InvPrintEncrypt' name='InvPrintEncrypt' type='hidden' value='"_..Encrypt()_"'>"
	s str=$tr(str,$C(13,10))
	q str
}

/// Description: Lodop打印xml条码模板调用
/// Creator:	lxt
/// CreateDate:	2021-2-26
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).Encrypt()
ClassMethod Encrypt() As %String
{
	s HISVersion=..sssHISVersion()
	
	q:HISVersion<8.4 ..sssWrap("%CSP.Page","Encrypt",$lb("web.DHCXMLIO.ReadXML"))
	q:HISVersion>=8.4 ..sssWrap("websys.Page","Encrypt",$lb("web.DHCXMLIO.ReadXML"))
	
	q ret
}

/// Description: 读卡调用
/// Creator:	lxt
/// CreateDate:	2021-03-17
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).ReadAccExpEncrypt()
ClassMethod ReadAccExpEncryptInput() As %String
{
	s str="<input id='ReadAccExpEncrypt' name='InsuPatTypeCheck' type='hidden' value='"_..ReadAccExpEncrypt()_"'>"
	s str=$tr(str,$C(13,10))
	q str
}

/// Description: 读卡调用
/// Creator:	lxt
/// CreateDate:	2021-03-17
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).ReadAccExpEncrypt()
ClassMethod ReadAccExpEncrypt() As %String
{
	s HISVersion=..sssHISVersion()
	
	q:HISVersion<8.4 ..sssWrap("%CSP.Page","Encrypt",$lb("web.UDHCAccManageCLSIF.getaccinfofromcardno"))
	q:HISVersion>=8.4 ..sssWrap("websys.Page","Encrypt",$lb("web.UDHCAccManageCLSIF.getaccinfofromcardno"))
	
	q ret
}

ClassMethod GetCardTypeEncryptInput() As %String
{
	s str="<input id='GetCardTypeEncrypt' name='GetCardTypeEncrypt' type='hidden' value='"_..GetCardTypeEncrypt()_"'>"
	s str=$tr(str,$C(13,10))
	q str
}

ClassMethod GetCardTypeEncrypt() As %String
{
	s HISVersion=..sssHISVersion()
	
	q:HISVersion<8.4 ..sssWrap("%CSP.Page","Encrypt",$lb("DHCDoc.OPDoc.PatientList.GessCardType"))
	q:HISVersion>=8.4 ..sssWrap("websys.Page","Encrypt",$lb("DHCDoc.OPDoc.PatientList.GessCardType"))
	
	q ret
}

ClassMethod ReadCardTypeEncryptInput() As %String
{
	s str="<input id='ReadCardTypeEncrypt' name='GetCardTypeEncrypt' type='hidden' value='"_..ReadCardTypeEncrypt()_"'>"
	s str=$tr(str,$C(13,10))
	q str
}

ClassMethod ReadCardTypeEncrypt() As %String
{
	s HISVersion=..sssHISVersion()
	
	q:HISVersion<8.4 ..sssWrap("%CSP.Page","Encrypt",$lb("web.UDHCOPOtherLB.ReadCardTypeDefineListBroker"))
	q:HISVersion>=8.4 ..sssWrap("websys.Page","Encrypt",$lb("web.UDHCOPOtherLB.ReadCardTypeDefineListBroker"))
	
	q ret
}

/// w ##class(web.DHCSTMHUI.Common.UtilCommon).GetCardHardJS()
ClassMethod GetCardHardJS() As %String
{
	q ..sssWrap("web.UDHCCardCommLinkRegister","GetCardHardJSFunction")
}

/// w ##class(web.DHCSTMHUI.Common.UtilCommon).EncryptPW("ab^#%123")
ClassMethod EncryptPW(Password) As %String
{
	n (Password)
	q ##Class(web.Util.Encryption).SimpleEncrypt(Password,"DHCSTM")
}

/// w ##class(web.DHCSTMHUI.Common.UtilCommon).DecryptPW("757A707972AFC4EEA1D3F268ABF7E6")
ClassMethod DecryptPW(Password As %String)
{
	n (Password)
	q ##Class(web.Util.Encryption).SimpleDecrypt(Password,"DHCSTM")
}

/// 按科室获取临床消耗标志(控制统一价低值是否消减库存)
/// w ##class(web.DHCSTMHUI.Common.UtilCommon).GetStockControl(123)
ClassMethod GetStockControl(LocId) As %String
{
	n (LocId)
	q:LocId="" "N"
	q:'$D(^CTLOC(LocId)) "N"
	
	s DHCSTLoc=$o(^DHCLOC(0,"LOC",LocId,""))
	q:DHCSTLoc="" "Y"	//未配置按Y处理
	
	s StockControlFlag=$p(^DHCLOC(DHCSTLoc),"^",16)
	s:StockControlFlag="" StockControlFlag="Y" 	//未配置按Y处理
	
	q StockControlFlag
}

}
