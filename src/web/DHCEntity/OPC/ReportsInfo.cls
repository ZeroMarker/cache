/// 门诊的报表信息 用于数据运算
Class web.DHCEntity.OPC.ReportsInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 利益体的 数据拆分 分割符号
Parameter AvailSplitStr = "$c(1)";

/// 默认的利益代码
Parameter DefaultAvailCode = "YY";

/// 子利益体1
/// 利康药房
Parameter SubAvailCode1 = "LKYF";

/// 作废的发票信息
Property AbParkINVInfo As %String(TRUNCATE = 1);

/// 作废的发票张数
Property AbPatINVCount As %String(TRUNCATE = 1);

/// 作废票据费用总额
Property AbPatPaySum As %String(TRUNCATE = 1);

/// 作废的数量=作废的发票数+ 作废的没有打印发票的数
Property AbPatPRTCount As %String(TRUNCATE = 1);

/// 作废的舍入金额
Property AbPatRoundSum As %String(TRUNCATE = 1);

/// 作废的金额
Property AbTotSum As %String(TRUNCATE = 1);

Property CTHospitlDR As %String(TRUNCATE = 1);

/// 经济核算分类
Property ECCat As list Of ReportsSub;

/// 选择的经济分类
Property SelECCat As ReportsSub;

/// 会计科目分类
Property ACCat As list Of ReportsSub;

/// 会计科目分类
Property SelACCat As ReportsSub;

/// 操作员实际上缴金额
/// FactPatPaySum = PatPaySum + ABPaySum + RefPaySum
Property FactPatPaySum As %String(TRUNCATE = 1);

/// 操作员应该收的（患者折扣前）的金额
/// FactPatTotSum=PatTotSum+AbTotSum+RefTotSum
Property FactPatTotSum As %String(TRUNCATE = 1);

/// 操作员打印的发票金额总计
Property INVTotalSum As %String(TRUNCATE = 1);

/// 门诊项目分类
Property OPCat As list Of ReportsSub;

/// 选择的门诊分类
Property SelOPCat As ReportsSub;

/// 作废的支付模式
Property ParkPayMode As list Of ReportsPayMode;

Property SelParkPayMode As ReportsPayMode;

/// 发票张数
Property PatINVCount As %String(TRUNCATE = 1);

/// 患者的支付金额
Property PatPaySum As %String(TRUNCATE = 1);

/// 发票张数+ 不打印发票而收钱的数量,相当于工作量
Property PatPRTCount As %String(TRUNCATE = 1);

/// 患者的舍入金额
Property PatRoundSum As %String(TRUNCATE = 1);

/// 费用总额
Property PatTotSum As %String(TRUNCATE = 1);

/// 支付模式
Property PayMode As list Of ReportsPayMode;

Property SelPayMode As ReportsPayMode;

/// 红冲退费金额
Property RefPatPaySum As %String(TRUNCATE = 1);

/// 红冲的发票张数
Property RefPatINVCount As %String(TRUNCATE = 1);

/// 红冲舍入金额
Property RefPatRoundSum As %String(TRUNCATE = 1);

/// 红冲数量=红冲发票数+ 红冲没有打印发票的数
Property RefPatPRTCount As %String(TRUNCATE = 1);

/// 红冲的支付模式
Property RefPayMode As list Of ReportsPayMode;

Property SelRefPayMode As ReportsPayMode;

/// 红冲退费总额
Property RefTotSum As %String(TRUNCATE = 1);

/// 红冲的发票号码列表
Property RefundINVInfo As %String(TRUNCATE = 1);

/// 财务是否审核 Y N
Property ReportCollect As %String(TRUNCATE = 1);

/// 报表状态 N  U  C
Property ReportStatus As %String(TRUNCATE = 1);

/// 总的支付模式， 运算累加值，这个不保存，只运算，
Property TotalPayMode As list Of ReportsPayMode;

/// 总的支付模式， 运算累加值，这个不保存，只运算，不分利益体
Property TotalPayModes As ReportsPayMode;

Property SelTotalPayMode As ReportsPayMode;

/// 标示那个操作员的报表信息
Property UserDR As %String(TRUNCATE = 1);

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
	;s mycardobj=##class(User.DHCCardRef).OpenId(1)
	;ParkPayMode
	;PayModeRefPayMode
	;RefPayMode
	
	s mySHospDR=0
	f  s mySHospDR=$o(^User.DHCSuAvailbHospitalD(mySHospDR))  q:(mySHospDR="")  d
	.s myobj=##class(User.DHCSuAvailbHospital).%OpenId(mySHospDR)
	.if $IsObject(myobj) d
	..s myParkPMObj=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	..s myPMObj=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	..s myRefPMObj=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	..s myTPMObj=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	..;s myECCat=##class(web.DHCEntity.OPC.ReportsSub).%New()
	..;s myOPCat=##class(web.DHCEntity.OPC.ReportsSub).%New()
	..;s myACCat=##class(web.DHCEntity.OPC.ReportsSub).%New()
	..
	..s myPMObj.SubAvailHospitlDR =mySHospDR
	..s myDesc=myobj.SAHDesc
	..s myPMObj.SubAvailHospitlDesc=myDesc
	..s myCode=myobj.SAHCode
	..s myPMObj.SubAvailHospitlCode=myCode
	..s myParkPMObj.SubAvailHospitlDR =mySHospDR
	..s myParkPMObj.SubAvailHospitlDesc=myDesc
	..s myParkPMObj.SubAvailHospitlCode=myCode
	..s myRefPMObj.SubAvailHospitlDR =mySHospDR
	..s myRefPMObj.SubAvailHospitlDesc=myDesc
	..s myRefPMObj.SubAvailHospitlCode=myCode
	..s myTPMObj.SubAvailHospitlDR =mySHospDR
	..s myTPMObj.SubAvailHospitlDesc=myDesc
	..s myTPMObj.SubAvailHospitlCode=myCode
	..;
	..d ..PayMode.Insert(myPMObj)
	..d ..ParkPayMode.Insert(myParkPMObj)
	..d ..RefPayMode.Insert(myRefPMObj)
	..;用来保存 不分作废，红冲，和正常的对象
	..d ..TotalPayMode.Insert(myTPMObj)
	..;d ..ECCat.Insert(myECCat)
	..;d ..ACCat.Insert(myACCat)
	..;d ..OPCat.Insert(myOPCat)
	..d myPMObj.%Close()
	..d myParkPMObj.%Close()
	..d myRefPMObj.%Close()
	..;d myECCat.%Close()
	..;d myOPCat.%Close()
	..;d myACCat.%Close()
	
	s ..TotalPayModes=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	
	i $g(initvalue)="" q $$$OK
	
	q $$$OK
}

/// 获取发票日报的信息
/// CardINVFootSum_$c(4)_myNINfo_$c(4)_myParkInfo_$c(4)_myRefInfo
/// 汇总金额   作废金额   红冲金额
Method GetCardINVInfo() As %String
{
	s myCardINVFootSum=""
	s myNINfo=""
	s myParkInfo=""
	s myRefInfo=""
	
	;s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	
	;s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	;s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	;s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	;s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum
	s myNINfo=..FactPatTotSum_"^"_..PatPRTCount_"^"_""_"^"_..PatTotSum_"^"_""_"^"
	s myNINfo=myNINfo_"^"
	
	s myParkInfo=..AbTotSum_"^"_..AbParkINVInfo_"^"_..AbPatINVCount_"^"_..AbPatPaySum_"^"_..AbPatPRTCount
	
	s myRefInfo=..RefTotSum_"^"_..RefundINVInfo_"^"_..RefPatINVCount_"^"_..RefPatPaySum_"^"_..RefPatPRTCount
	
	i '$IsObject(..PayMode) d
	.s ..PayMode=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	
	s myPayModeInfo=..PayMode.GetPayModeCharactor()
	
	q myNINfo_$c(4)_myParkInfo_$c(4)_myRefInfo_$c(4)_myPayModeInfo
}

/// /
Method GetINVInfo() As %String
{
	s myCardINVFootSum=""
	s myNINfo=""
	s myParkInfo=""
	s myRefInfo=""
	
	;s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	
	;s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	;s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	;s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	;s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum
	s myNINfo=..FactPatTotSum_"^"_..PatPRTCount_"^"_""_"^"_..PatTotSum_"^"_""_"^"
	s myNINfo=myNINfo_"^"
	
	s myParkInfo=..AbTotSum_"^"_..AbParkINVInfo_"^"_..AbPatINVCount_"^"_..AbPatPaySum_"^"_..AbPatPRTCount
	
	s myRefInfo=..RefTotSum_"^"_..RefundINVInfo_"^"_..RefPatINVCount_"^"_..RefPatPaySum_"^"_..RefPatPRTCount
	
	s myPayModeInfo=..GetTotalINVPayModeInfo()
	
	q myNINfo_$c(4)_myParkInfo_$c(4)_myRefInfo_$c(4)_myPayModeInfo
}

/// /获取 PayMode, ParkPayMode, RefPayMode 支付模式的累加额
Method GetTotalINVPayModeInfo() As %String
{
	s myStr=""
	
	s myCount=..TotalPayMode.Count()
	s myFind=0
	f myIdx=1:1:myCount  d
	.s ..SelTotalPayMode=..TotalPayMode.GetAt(myIdx)
	.i myStr="" d
	..s myStr=..SelTotalPayMode.GetPayModeCharactor()
	.e  d
	..s myStr=myStr_..#AvailSplitStr_..SelTotalPayMode.GetPayModeCharactor()
	
	q myStr
}

Method PutPayModeOld(PayModeCode As %String, PRTFlag As %String, PaySum As %String, PayNum As %String, BillStr As %String) As %String
{
	;PayMode  支付模式代码
	;PRTFlag  发票状态 Normal, Abort, Refund
	;PaySum   支付模式金额
	;PayNum   此支付模式数量
	;结算 的账单的RowID串  使用这个来统一标准
	
	;正常票据数量
	if (PRTFlag="N") d
	.i '$IsObject(..PayMode) d
	..s ..PayMode=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	.d ..PayMode.PutPayMode(PayModeCode, PaySum, PayNum)
	
	;红冲票据数量
	i (PRTFlag="S") d
	.i '$IsObject(..ParkPayMode) d
	..s ..ParkPayMode=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	.d ..ParkPayMode.PutPayMode(PayModeCode, PaySum, PayNum)
	
	; 作废票据数量
	i (PRTFlag="A") d
	.i '$IsObject(..RefPayMode) d
	..s ..RefPayMode=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	.d ..RefPayMode.PutPayMode(PayModeCode, PaySum, PayNum)
	
	q ""
}

/// //先选择 利益单位，然后赋值
Method PutCardINVPayMode(PayModeCode As %String, PRTFlag As %String, PaySum As %String, PayNum As %String) As %String
{
	;^User.DHCSuAvailbHospitalI("SAHCodeIndex"," YY",2)=
	s mySubHospDR = ##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	q:(mySubHospDR="")
	
	d ..SetSelectPayMode(mySubHospDR)
	i mySubHospDR="" d
	. b
	d ..PutSelectPayMode(PayModeCode, PRTFlag, PaySum,PayNum)
	
	;科目分类设置
	;##class(web.DHCEntity.OPC.ReportsSub).GetCardINVSubCat()
	d ..SetCardAccountCat(PaySum, mySubHospDR)
	q 0
}

Method SetCardAccountCat(PaySum As %String, SubHospDR As %String) As %Status
{
	s mySubjectType="AC"
	s SubHospDR=SubHospDR
	
	s ItmACSubCat=##class(web.DHCEntity.OPC.ReportsSub).GetCardINVSubCat()
	q:(ItmACSubCat="")
	s ItmACSubCatDesc=$p(^DHCTarC("AC",ItmACSubCat),"^",2)
	S ItmACCat=$p(^DHCTarC("AC",ItmACSubCat),"^",3)
	q:$g(ItmACCat)=""
	s ACCatDesc=$p(^DHCTarC("TAC",ItmACCat),"^",2)
	s myCount=..ACCat.Count()
	s myFFlag=0
	f myIdx=1:1:myCount q:(+myFFlag)  d
	.s ..SelACCat=..ACCat.GetAt(myIdx)
	.q:(..SelACCat.SubAvailHospitlDR'=SubHospDR)
	.q:(..SelACCat.TarSubjectType'=mySubjectType)
	.q:(..SelACCat.CatDR'=ItmACCat)
	.q:(..SelACCat.SubCatDR'=ItmACSubCat)
	.s myFFlag=1
	
	i 'myFFlag d
	.s myACCat=##class(web.DHCEntity.OPC.ReportsSub).%New()
	.s myACCat.TarSubjectType = mySubjectType
	.s myACCat.SubAvailHospitlCode = ""
	.s myACCat.SubAvailHospitlDR = SubHospDR
	.s myACCat.SubAvailHospitlDesc=""
	.s myACCat.SubCatDesc=ItmACSubCatDesc
	.s myACCat.SubCatDR=ItmACSubCat
	.s myACCat.CatDR=ItmACCat
	.d ..ACCat.Insert(myACCat)
	.s ..SelACCat=myACCat
	.d myACCat.%Close()
	s ..SelACCat.Acount=..SelACCat.Acount+PaySum
	
	
	q $$$OK
}

/// /优先划定钱的归属
Method PutPayModeByPRTRowID(INVRowID As %String, PRTFlag As %String, BillStr As %String) As %Status
{
	;INVRowID, PRTFlag, BillStr
	s mySubHospDR=""
	s myPMCode=""
	s PayModeCode=""
	
	s myBillRowID=0
	s myLen=$l(BillStr,"^")
	s myINVSubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	for I=1:1:myLen  q:(mySubHospDR'="")  d
	.s myBillRowID=$p(BillStr,"^", I)
	.q:(myBillRowID="")
	.;^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
	.s myPBSub=0
	.f  s myPBSub=$o(^DHCPB(myBillRowID, "O",myPBSub))  q:((myPBSub="")!(mySubHospDR'=""))  d
	..q:($d(^DHCPB(myBillRowID, "O",myPBSub))=10)
	..s myOEORIDR=$p(^DHCPB(myBillRowID, "O",myPBSub),"^", 4)
	..;^OEORD(myOEORIDR,"I",mySub, 3)
	..;下面加入条件, 根据条件  选择 医院的分类
	..s myRecDepDR=$p(^OEORD(+myOEORIDR,"I",$p(myOEORIDR,"||",2), 3),"^",6)			;OEORI_RecDep_DR_
	..s mySubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetSubHospByRecDep(myRecDepDR)
	..i mySubHospDR'="" d
	...s myINVSubHospDR=mySubHospDR
	..d ..SetSelectPayMode(myINVSubHospDR)
	..d ..SetOutPatientCat(myBillRowID, mySubHospDR)
	..;会计子类
	..d ..SetAccountCat(myBillRowID, mySubHospDR)
	
	i myINVSubHospDR="" d
	.b	;myINVSubHospDR
	d ..SetSelectPayMode(myINVSubHospDR)
	
	s myPaySub=0
	
	;设置支付模式的金额,不设数量
	f  s myPaySub=$o(^DHCINVPRT(INVRowID,"P",myPaySub)) q:((myPaySub=""))  d
	.s myPMDR=$p(^DHCINVPRT(INVRowID,"P",myPaySub),"^",1)
	.s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s myCurPaySum=$p(^DHCINVPRT(INVRowID,"P",myPaySub),"^",3)		;PayMode
	.d ..PutSelectPayMode(myPMCode, PRTFlag, myCurPaySum,0)
	.i PayModeCode="" d
	..s PayModeCode=myPMCode
	
			;;;
	;设置发票数量
	d ..PutSelectPayMode(PayModeCode, PRTFlag, 0, 1)
	
	q $$$OK
}

Method PutPayMode(PayModeCode As %String, PRTFlag As %String, PaySum As %String, PayNum As %String, BillStr As %String) As %String
{
	;PayMode  支付模式代码
	;PRTFlag  发票状态 Normal, Abort, Refund
	;PaySum   支付模式金额
	;PayNum   此支付模式数量
	;结算 的账单的RowID串  使用这个来统一标准  这个串  是一张发票形成的串
	
	;BillStr
	
	s myBillRowID=0
	s myLen=$l(BillStr,"^")
	s myINVSubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	
	for I=1:1:myLen  d
	.s myBillRowID=$p(BillStr,"^", I)
	.q:(myBillRowID="")
	.;^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
	.s myPBSub=0
	.f  s myPBSub=$o(^DHCPB(myBillRowID, "O",myPBSub))  q:(myPBSub="")  d
	..q:($d(^DHCPB(myBillRowID, "O",myPBSub))=10)
	..s myOEORIDR=$p(^DHCPB(myBillRowID, "O",myPBSub),"^", 4)
	..;^OEORD(myOEORIDR,"I",mySub, 3)
	..;下面加入条件, 根据条件  选择 医院的分类
	..s myRecDepDR=$p(^OEORD(+myOEORIDR,"I",$p(myOEORIDR,"||",2), 3),"^",6)			;OEORI_RecDep_DR_
	..s mySubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetSubHospByRecDep(myRecDepDR)
	..i mySubHospDR'="" d
	...s myINVSubHospDR=mySubHospDR
	..;设置当前的选择 支付模式
	..d ..SetSelectPayMode(mySubHospDR)
	..s myOrdPatPaySum=$p(^DHCPB(myBillRowID,"O",myPBSub),"^", 11)
	..d ..PutSelectPayMode(PayModeCode, PRTFlag, myOrdPatPaySum,0)
	..;求取计费项的RowID和子分类
	..;在计算时,一定获取 应付款
	..;门诊子类
	..d ..SetOutPatientCat(myBillRowID, mySubHospDR)
	..;会计子类
	..d ..SetAccountCat(myBillRowID, mySubHospDR)
	
	i myINVSubHospDR'="" d
	.d ..SetSelectPayMode(myINVSubHospDR)
	.d ..PutSelectPayMode(PayModeCode, PRTFlag, 0,PayNum)
	
	q ""
}

/// 会计子类
Method SetAccountCat(Bill As %String, SubHospDR As %String) As %String [ Private ]
{
	;放到SelSub
	s mySubjectType="AC"
	
	s Ord=0
	f  s Ord=$o(^DHCPB(Bill,"O",Ord))  q:(Ord="")  d
	.S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	..;b DHC_TarOutpatCate	  DHC_TarOC
	..S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	..S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	..S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	..S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	..S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	..S ItmACSubCat=$p(^DHCTARI(ItmDr),"^",5)		;TARI_AcctCate
	..q:$g(ItmACSubCat)=""
	..s ItmACSubCatDesc=$p(^DHCTarC("AC",ItmACSubCat),"^",2)
	..S ItmACCat=$p(^DHCTarC("AC",ItmACSubCat),"^",3)
	..q:$g(ItmACCat)=""
	..s ACCatDesc=$p(^DHCTarC("TAC",ItmACCat),"^",2)
	..s myCount=..ACCat.Count()
	..s myFFlag=0
	..f myIdx=1:1:myCount q:(+myFFlag)  d
	...s ..SelACCat=..ACCat.GetAt(myIdx)
	...q:(..SelACCat.SubAvailHospitlDR'=SubHospDR)
	...q:(..SelACCat.TarSubjectType'=mySubjectType)
	...q:(..SelACCat.CatDR'=ItmACCat)
	...q:(..SelACCat.SubCatDR'=ItmACSubCat)
	...s myFFlag=1
	..i 'myFFlag d
	...s myACCat=##class(web.DHCEntity.OPC.ReportsSub).%New()
	...s myACCat.TarSubjectType = mySubjectType
	...s myACCat.SubAvailHospitlCode = ""
	...s myACCat.SubAvailHospitlDR = SubHospDR
	...s myACCat.SubAvailHospitlDesc=""
	...s myACCat.SubCatDesc=ItmACSubCatDesc
	...s myACCat.SubCatDR=ItmACSubCat
	...s myACCat.CatDR=ItmACCat
	...d ..ACCat.Insert(myACCat)
	...s ..SelACCat=myACCat
	...d myACCat.%Close()
	..s ..SelACCat.Acount=..SelACCat.Acount+TotalAmount
	
	q 0
}

/// 设置门诊子类
Method SetOutPatientCat(Bill As %String, SubHospDR As %String) As %String [ Private ]
{
	s mySubjectType="OP"
	
	s Ord=0
	f  s Ord=$o(^DHCPB(Bill,"O",Ord))  q:(Ord="")  d
	.S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	..;b DHC_TarOutpatCate	  DHC_TarOC
	..S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	..S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	..S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	..S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	..S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	..S ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	..q:$g(ItmOPSubCat)=""
	..s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	..S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	..q:$g(ItmOPCat)=""
	..s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	..s myCount=..OPCat.Count()
	..s myFFlag=0
	..f myIdx=1:1:myCount q:(+myFFlag)  d
	...s ..SelOPCat=..OPCat.GetAt(myIdx)
	...q:(..SelOPCat.SubAvailHospitlDR'=SubHospDR)
	...q:(..SelOPCat.TarSubjectType'=mySubjectType)
	...q:(..SelOPCat.CatDR'=ItmOPCat)
	...q:(..SelOPCat.SubCatDR'=ItmOPSubCat)
	...s myFFlag=1
	..i 'myFFlag d
	...s myOPCat=##class(web.DHCEntity.OPC.ReportsSub).%New()
	...s myOPCat.TarSubjectType = mySubjectType
	...s myOPCat.SubAvailHospitlCode = ""
	...s myOPCat.SubAvailHospitlDR = SubHospDR
	...s myOPCat.SubAvailHospitlDesc=""
	...s myOPCat.SubCatDesc=ItmOPSubCatDesc
	...s myOPCat.SubCatDR=ItmOPSubCat
	...s myOPCat.CatDR=ItmOPCat
	...d ..OPCat.Insert(myOPCat)
	...s ..SelOPCat=myOPCat
	...d myOPCat.%Close()
	..s ..SelOPCat.Acount=..SelOPCat.Acount+TotalAmount
	
	q 0
}

/// 设置当前的利益单位
Method SetSelectPayMode(SubHospDR) As %String
{
	s myCount=..PayMode.Count()
	s myFind=0
	f myIdx=1:1:myCount q:(+myFind)  d
	.s mySubHospDR=..PayMode.GetAt(myIdx).SubAvailHospitlDR
	.i mySubHospDR=SubHospDR d
	..s myFind=1
	..s ..SelPayMode=..PayMode.GetAt(myIdx)
	..s ..SelParkPayMode=..ParkPayMode.GetAt(myIdx)
	..s ..SelRefPayMode=..RefPayMode.GetAt(myIdx)
	..s ..SelTotalPayMode=..TotalPayMode.GetAt(myIdx)
	..;s ..SelECCat=..ECCat.GetAt(myIdx)
	..;s ..SelOPCat=..OPCat.GetAt(myIdx)
	
	q 0
}

Method PutSelectPayMode(PayModeCode As %String, PRTFlag As %String, PaySum As %String, PayNum As %String) As %String [ Private ]
{
	
	d ..SelTotalPayMode.PutPayMode(PayModeCode, PaySum, PayNum)
	i '$IsObject(..TotalPayModes) d
	.s ..TotalPayModes=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	
	d ..TotalPayModes.PutPayMode(PayModeCode, PaySum, PayNum)
	
	if (PRTFlag="N") d
	.d ..SelPayMode.PutPayMode(PayModeCode, PaySum, PayNum)
	
	i (PRTFlag="S") d
	.d ..SelParkPayMode.PutPayMode(PayModeCode, PaySum, PayNum)
	
	i (PRTFlag="A") d
	.d ..SelRefPayMode.PutPayMode(PayModeCode, PaySum, PayNum)
}

/// 可以把多个PayMode, ParkPayMode, RefPayMode
/// + - * /  到本对象中
/// 
Method Calculate(OperSign As %String, OperatedObj As %ObjectHandle) As %Status
{
	;被操作对象  OperatedObj
	; 自己计算
	d ..CalculateSelf(OperSign, OperatedObj)
	
	;计算科目
	d ..CalculateCat(OperSign, OperatedObj)
	
	;计算 PayMode
	s myCount=OperatedObj.PayMode.Count()
	
	f myIdx=1:1:myCount  d
	.s mySubHospDR=OperatedObj.PayMode.GetAt(myIdx).SubAvailHospitlDR
	.d ..SetSelectPayMode(mySubHospDR)
	.d OperatedObj.SetSelectPayMode(mySubHospDR)
	.;b	;;
	.
	.d ..SelTotalPayMode.CalculateSelf(OperSign, OperatedObj.SelTotalPayMode)
	.d ..SelPayMode.CalculateSelf(OperSign, OperatedObj.SelPayMode)
	.d ..SelParkPayMode.CalculateSelf(OperSign, OperatedObj.SelParkPayMode)
	.d ..TotalPayModes.CalculateSelf(OperSign, OperatedObj.SelTotalPayMode)
	
	q $$$OK
}

/// + - * /  到本对象中
/// 计算 门诊、会计等科目的累加
Method CalculateCat(OperSign As %String, OperatedObj As %ObjectHandle) As %Status
{
	;会计科目累加
	s myCount=OperatedObj.ACCat.Count()
	s myCurCount=..ACCat.Count()
	s myFFlag=0
	
	f myIdx=1:1:myCount  d
	.s mySelCat=OperatedObj.ACCat.GetAt(myIdx)
	.s ItmOPCat=mySelCat.CatDR
	.s SubHospDR=mySelCat.SubAvailHospitlDR
	.s mySubjectType=mySelCat.TarSubjectType
	.s ItmOPSubCat=mySelCat.SubCatDR
	.s ItmOPSubCatDesc=$p(^DHCTarC("AC",ItmOPSubCat),"^",2)
	.f myCurIdx=1:1:myCurCount q:(+myFFlag)  d
	..s myCurCat=..ACCat.GetAt(myCurIdx)
	..s ..SelACCat=..ACCat.GetAt(myCurIdx)
	..q:(mySelCat.SubAvailHospitlDR'=myCurCat.SubAvailHospitlDR)
	..q:(mySelCat.TarSubjectType'=myCurCat.TarSubjectType)
	..q:(mySelCat.CatDR'=myCurCat.CatDR)
	..q:(mySelCat.SubCatDR'=myCurCat.SubCatDR)
	..s myFFlag=1
	.i 'myFFlag d
	..s myACCat=##class(web.DHCEntity.OPC.ReportsSub).%New()
	..s myACCat.TarSubjectType = mySubjectType
	..s myACCat.SubAvailHospitlCode = ""
	..s myACCat.SubAvailHospitlDR = SubHospDR
	..s myACCat.SubAvailHospitlDesc=""
	..s myACCat.SubCatDesc=ItmOPSubCatDesc
	..s myACCat.SubCatDR=ItmOPSubCat
	..s myACCat.CatDR=ItmOPCat
	..d ..ACCat.Insert(myACCat)
	..s ..SelACCat=myACCat
	..d myACCat.%Close()
	.s ..SelACCat.Acount=..SelACCat.Acount+mySelCat.Acount
	
	;门诊科目累加
	s myCount=OperatedObj.OPCat.Count()
	s myCurCount=..OPCat.Count()
	s myFFlag=0
	
	f myIdx=1:1:myCount  d
	.s mySelCat=OperatedObj.OPCat.GetAt(myIdx)
	.s ItmOPCat=mySelCat.CatDR
	.s SubHospDR=mySelCat.SubAvailHospitlDR
	.s mySubjectType=mySelCat.TarSubjectType
	.s ItmOPSubCat=mySelCat.SubCatDR
	.s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	.f myCurIdx=1:1:myCurCount q:(+myFFlag)  d
	..s myCurCat=..OPCat.GetAt(myCurIdx)
	..s ..SelOPCat=..OPCat.GetAt(myCurIdx)
	..q:(mySelCat.SubAvailHospitlDR'=myCurCat.SubAvailHospitlDR)
	..q:(mySelCat.TarSubjectType'=myCurCat.TarSubjectType)
	..q:(mySelCat.CatDR'=myCurCat.CatDR)
	..q:(mySelCat.SubCatDR'=myCurCat.SubCatDR)
	..s myFFlag=1
	.i 'myFFlag d
	..s myOPCat=##class(web.DHCEntity.OPC.ReportsSub).%New()
	..s myOPCat.TarSubjectType = mySubjectType
	..s myOPCat.SubAvailHospitlCode = ""
	..s myOPCat.SubAvailHospitlDR = SubHospDR
	..s myOPCat.SubAvailHospitlDesc=""
	..s myOPCat.SubCatDesc=ItmOPSubCatDesc
	..s myOPCat.SubCatDR=ItmOPSubCat
	..s myOPCat.CatDR=ItmOPCat
	..d ..OPCat.Insert(myOPCat)
	..s ..SelOPCat=myOPCat
	..d myOPCat.%Close()
	.s ..SelOPCat.Acount=..SelOPCat.Acount+mySelCat.Acount
	
	
	Quit $$$OK
}

Method CalculateSelf(OperSign As %String, OperatedObj As %ObjectHandle) As %Status
{
	i (OperSign="+"){
	s ..AbParkINVInfo=..AbParkINVInfo_" "_OperatedObj.AbParkINVInfo
	s ..AbPatINVCount =+..AbPatINVCount+OperatedObj.AbPatINVCount
	s ..AbPatPaySum = + ..AbPatPaySum + OperatedObj.AbPatPaySum
	s ..AbPatPRTCount =+..AbPatPRTCount + OperatedObj.AbPatPRTCount
	s ..AbPatRoundSum = ++..AbPatRoundSum+OperatedObj.AbPatRoundSum
	s ..AbTotSum = + ..AbTotSum + OperatedObj.AbTotSum
	s ..FactPatPaySum =+..FactPatPaySum+OperatedObj.FactPatPaySum
	s ..FactPatTotSum = +..FactPatTotSum+OperatedObj.FactPatTotSum

	s ..PatINVCount =+..PatINVCount + OperatedObj.PatINVCount

	s ..PatPaySum = +..PatPaySum + OperatedObj.PatPaySum

	s ..PatPRTCount =+..PatPRTCount+OperatedObj.PatPRTCount
	s ..PatRoundSum =+..PatRoundSum+OperatedObj.PatRoundSum
	s ..PatTotSum = + ..PatTotSum + OperatedObj.PatTotSum
	s ..RefPatPaySum =..RefPatPaySum + OperatedObj.RefPatPaySum

	s ..RefPatINVCount =+..RefPatINVCount + OperatedObj.RefPatINVCount
	s ..RefPatRoundSum = + ..RefPatRoundSum + OperatedObj.RefPatRoundSum
	s ..RefPatPRTCount = + ..RefPatPRTCount + OperatedObj.RefPatPRTCount

	s ..RefTotSum=+..RefTotSum + OperatedObj.RefTotSum
	s ..INVTotalSum=..INVTotalSum+OperatedObj.INVTotalSum

	s ..RefundINVInfo =..RefundINVInfo _"  "_OperatedObj.RefundINVInfo
	}elseif(OperSign="-"){
	}
	q $$$OK
}

Method ReadReportByRowID(ReportRowID As %String) As %Status
{
	;
	q:(ReportRowID="") $$$OK
	
	s myReportObj=##class(User.DHCINVPRTReports).%OpenId(ReportRowID)
	s ..CTHospitlDR=myReportObj.HISHospitalDR
	s ..PatINVCount=myReportObj.HisNum
	s ..UserDR=myReportObj.HISUser
	s ..ReportStatus=myReportObj.HISReportStatus
	s ..ReportCollect=myReportObj.HISCollect
	
	s myDefaultSubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	s myCount=myReportObj.ChildDHCINVPRTReportsPaymode.Count()
	
	for i=1:1:myCount  d
	.s myPMObj = myReportObj.ChildDHCINVPRTReportsPaymode.GetAt(i)
	.s mySubHospDR=myPMObj.HisPaySubAvailHospitlDR
	.
	.i mySubHospDR'="" d
	..s mySubHospDR=myDefaultSubHospDR
	.d ..SetSelectPayMode(mySubHospDR)
	.;b	;myINVSubHospDR
	.s myPMDR=myPMObj.HisPayPaymode.%Id()
	.s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.;s myCurPaySum=$p(^DHCINVPRT(INVRowID,"P",myPaySub),"^",3)		;PayMode
	.;Normal
	.s myCurPaySum = myPMObj.HisPayAcount
	.s myCurINVNum = myPMObj.HisPaynum
	.d ..PutSelectPayMode(myPMCode, "N", myCurPaySum,myCurINVNum)
	.;Strike
	.s myCurPaySum = +myPMObj.HisPayStrikRefSum
	.s myCurINVNum = myPMObj.HisPayStrikRefNum
	.d ..PutSelectPayMode(myPMCode, "S", myCurPaySum,myCurINVNum)
	.;Abort
	.s myCurPaySum = +myPMObj.HisPayRefundsum
	.s myCurINVNum = myPMObj.HisPayRefund
	.d ..PutSelectPayMode(myPMCode, "S", myCurPaySum,myCurINVNum)
	.
	.;Card PayMode
	.;
	.;Normal
	.s myCurPaySum = myPMObj.HisPayLogINVSum
	.s myCurINVNum = myPMObj.HisPayLogINVNum
	.d ..PutSelectPayMode(myPMCode, "N", myCurPaySum,myCurINVNum)
	.;Strike
	.s myCurPaySum = +myPMObj.HisPayLStrikINVSum
	.s myCurINVNum = myPMObj.HisPayLStrikINVNum
	.d ..PutSelectPayMode(myPMCode, "S", myCurPaySum,myCurINVNum)
	.;Abort
	.s myCurPaySum = +myPMObj.HisPayLParkINVSum
	.s myCurINVNum = myPMObj.HisPayLParkINVNum
	.d ..PutSelectPayMode(myPMCode, "S", myCurPaySum,myCurINVNum)
	
	;;; Sub Trans
	;;; Account Cat
	/// 经济核算分类
	;Property ECCat As ReportsSub [ Collection = list ];
	/// 选择的经济分类
	;Property SelECCat As ReportsSub;
	s myCount=myReportObj.ChildDHCINVPRTReportsSub.Count()
	for i=1:1:myCount  d
	.s mySubObj=myReportObj.ChildDHCINVPRTReportsSub.GetAt(i)
	.s mySubjectType=mySubObj.HisSubTarSubjectType
	.s SubHospDR=mySubObj.HisSubSubAvailHospitlDR
	.s ItmACSubCat=mySubObj.HisSubSubCatDR
	.s ItmACCat=mySubObj.HisSubCatDR
	.s myCatObj=##class(web.DHCEntity.OPC.ReportsSub).%New()
	.s myCatObj.TarSubjectType = mySubjectType
	.s myCatObj.SubAvailHospitlCode = ""
	.s myCatObj.SubAvailHospitlDR = SubHospDR
	.s myCatObj.SubAvailHospitlDesc=""
	.s myCatObj.SubCatDR=ItmACSubCat
	.s myCatObj.CatDR=ItmACCat
	.s myCatObj.Acount=mySubObj.HisSubAcount
	.;,OP,MRC,IP,EC,AC
	.i mySubjectType="AC" d
	..s ItmACSubCatDesc=$p(^DHCTarC("AC",ItmACSubCat),"^",2)
	..s myCatObj.SubCatDesc=ItmACSubCatDesc
	..d ..ACCat.Insert(myCatObj)
	..s ..SelACCat=myCatObj
	.i mySubjectType="OP" d
	..s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmACSubCat),"^",2)
	..s myCatObj.SubCatDesc=ItmOPSubCatDesc
	..d ..OPCat.Insert(myCatObj)
	..s ..SelOPCat=myCatObj
	.i mySubjectType="EC" d
	..d ..ECCat.Insert(myCatObj)
	..s ..SelECCat=myCatObj
	.d myCatObj.%Close()
	.d mySubObj.%Close()
	
	
	
	q $$$OK
}

}
