/// 类名：web.DHCENS.Util.Common
/// 描述：基础方法服务
/// 编写者：WuXianPu
/// 编写日期：2012-05-14
Class web.DHCENS.Util.Common Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—05-14
/// Description：字符串替换
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.Util.Common).ReplaceStr("")
ClassMethod ReplaceStr(inStr As %String, idStr As %String, ass As %String) As %String(MAXLEN=32767)
{
	s retStr=""
	s len=$l(inStr,idStr)
	f i=1:1:len
	{
		i i'=len d
		.s retStr=retStr_$p(inStr,idStr,i)_ass
		e  d
		.s retStr=retStr_$p(inStr,idStr,i)
	}
	q retStr
}

/// Creator：WuXianPu
/// CreatDate：2010-12-18
/// Description：去掉字符串中某种类型的字符
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(DHCENS.BBS.Method.Common).DeleteChar("farfaf","")
ClassMethod DeleteChar(Input As %String, Char As %String) As %String
{
   s len=$l(Input,Char)	
   s Output=""
   f i=1:1:len d
   .s str=$p(Input,Char,i)
   .s Output=Output_str
   q Output
}

/// Creator：WuXianPu
/// CreatDate：2012—05-14
/// Description：通过医嘱号得到病人Rowid^登记号^就诊号
/// Table：
/// Input： 
/// Return：病人Rowid^登记号^就诊号
/// Others: w ##class(web.DHCENS.Util.Common).GetPatNoByOrderID("")
ClassMethod GetPatNoByOrderID(OrderID As %String) As %String
{
	q:OrderID="" ""
	s adm=$p($g(^OEORD(+OrderID)),"^",1)
	s RegisterNo=""
	i (adm'="")
	{
		s patId=$p(^PAADM(adm),"^",1)
		s RegisterNo=$p($g(^PAPER(patId,"PAT",1)),"^",1)
	}
	s Ret=patId_"^"_RegisterNo_"^"_adm
	q Ret
}

/// Creator：WuXianPu
/// CreatDate：2012—05-14
/// Description：通过住院号(病案号)得到病人登记号
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.Util.Common).GetPatNoByInNo("")
ClassMethod GetPatNoByInNo(InNo As %String) As %String
{
	q:InNo="" ""
	s InNo=InNo_"Z"
	s PaPatDr=""
	s PaPatDr=$o(^PAPERi("Medicare",InNo,PaPatDr),-1)
	s RegisterNo=""
	i (PaPatDr'="")
	{
		s RegisterNo=$p($g(^PAPER(PaPatDr,"PAT",1)),"^",1)
	}
	q RegisterNo
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：检查卡是否有效
/// Table：
/// Input： 
/// Return：通过就诊卡号获取患者Rowid
/// Others: w ##class(web.DHCENS.Util.Common).GetPatRowidByCardNo("")
ClassMethod GetPatRowidByCardNo(CardNo As %String, CardType As %String) As %String
{
	set PatRowid = ""
	set RegNo = ..GetRegNoByCardNo(CardNo,CardType)
	if (RegNo '= "")
	{
		set:$d(^PAPERi("PAPMI_PatNo",RegNo)) PatRowid=$O(^PAPERi("PAPMI_PatNo",RegNo,""))	    
	}
	
	Q PatRowid
}

/// Creator：WuXianPu
/// CreatDate：2012—05-14
/// Description： 通过就诊卡号得到病人登记号 
/// Table：
/// Input： 
/// Return:
/// Others: w ##class(web.DHCENS.Util.Common).GetPatNoByInNo("")
ClassMethod GetRegNoByCardNo(CardNo As %String, CardType As %String) As %String
{
	s RegisterNo=""
	q:CardNo="" ""
	s CardRowid="",rowid=""
	f  s rowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,rowid)) q:rowid=""   d
	.s CardFlag=$p($g(^DHCCARD("CF",rowid)),"^",10)
	.s TypeId=$p($g(^DHCCARD("CF",rowid)),"^",16)
	.s TypeCode=$p($g(^DHCCARDTYPEDef(TypeId)),"^",1)
	.q:TypeCode'=CardType
	.s CardRowid=rowid
	.q:CardFlag'="N" 
	if (CardRowid'="")
	{
		s RegisterNo=$p($g(^DHCCARD("CF",CardRowid)),"^",6)
	}
	q RegisterNo
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：检查卡是否有效
/// Table：
/// Input： 
/// Return：根据卡号和卡类型查找病人ID(调用其他组方法)
/// Others: w ##class(web.DHCENS.Util.Common).GetPatIdByCardNo("")
ClassMethod GetPatIdByCardNo(CardNo As %String, CardType As %String) As %String
{
	q:CardNo="" ""
	s ExpStr=""_$C(2)_CardType_$C(2)_"PatInfo"
	s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,"",ExpStr)
	s myACFlag=$P(ret,"^",1)
	Q:(myACFlag="-200") ""   
	s PatId=$p(ret,"^",8)
	q PatId
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：通过用户代码取用户Rowid
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.Util.Common).GetUserDrByUserCode("")
ClassMethod GetUserDrByUserCode(UserCode As %String) As %String
{
	q:UserCode="" ""
	s UserCode=$ZCVT(UserCode,"U")
	s RowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
    q RowId
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：根据病人rowid取得病人年龄(包括岁、月、天)
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.BLL.Lis.Method.PatInfo).GetAgeByPatid("")
ClassMethod GetAgeByPatid(Patid As %String)
{
	s DOB=$P(^PAPER(Patid,"ALL"),"^",6)	
	s EstAgeMonth=$P(^PAPER(Patid,"ALL"),"^",16)
    s EstAgeYear=$P(^PAPER(Patid,"ALL"),"^",15)
 	s EstAgeTmStmp=$P(^PAPER(Patid,"ALL"),"^",17)
 	
 	s AgeStr=$$CalAge^at182(DOB,+$H,EstAgeMonth,EstAgeYear,EstAgeTmStmp)
 	
 	s Year=$P(AgeStr,"|",12)
 	s Month=$P(AgeStr,"|",13)
 	s Day=$P(AgeStr,"|",14)
 	
 	if (Year >=2)
 	{
	    Q Year_"岁"	
 	}
 	elseif ((Year = 0)&&(Month <=3))
 	{
	 	Q ($h-DOB)_"天"
 	}
 	else
 	{
	 	Q (Year * 12 + Month)_"月"	 	
 	}
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：根据科院区室取得所属院区
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.BLL.Lis.Method.PatInfo).GetHospitalByCtLoc("")
ClassMethod GetHospitalByCtLoc(CtLocDr As %String) As %String
{
	q:CtLocDr="" ""
	
	s Hospital=""
	s HospitalDr=$p($g(^CTLOC(CtLocDr)),"^",22)
	i (HospitalDr'="")
	{
		s Hospital=$p($g(^CT("HOSP",HospitalDr)),"^",1)_"^"_$p($g(^CT("HOSP",HospitalDr)),"^",2)
	}
	q Hospital
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：获得某月的最大天数
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(DHCENS.Common.Common).GetMonthDays("2")
ClassMethod GetMonthDays(Month As %String) As %String
{
	s Days="0"
	q:(+Month<1)!(+Month>12) "0"
	i (+Month=2) d
	.s Days="28"
	else  i (+Month=1)!(+Month=3)!(+Month=5)!(+Month=7)!(+Month=8)!(+Month=10)!(+Month=12)  d
	.s Days="31"
	else  i (+Month=4)!(+Month=6)!(+Month=9)!(+Month=11)  d
	.s Days="30"
	q Days
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：把病案号补足8位
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(DHCENS.Common.Common).TransMedicare("2344")
ClassMethod TransMedicare(Medicare As %String) As %String
{
	s Medi=Medicare
	s Len=$l(Medi)
	i Len<8 
	{
		f i=1:1:8-Len
		{
			s Medi="0"_Medi
		}
	}
	s Medicare=Medi
	q Medicare
}

/// Creator：WuXianPu
/// CreatDate：2010-12-18
/// Description：转换外部检验系统代码为医嘱代码
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(DHCENS.BBS.Method.Common).ChangeLisCode("")
ClassMethod ChangeLisCode(LisCode As %String)
{
	set ArcCode=""
	q:LisCode="" ""
	s ExtCode=$O(^TTAB("SY",LisCode,"TS",""))
	if (ExtCode'="")
	{
		s ArcSub=$O(^ARCIM(0,"ExtCode",ExtCode,""))
		if (ArcSub'="")
		{
		    s ArcVer=$O(^ARCIM(0,"ExtCode",ExtCode,ArcSub,""))
		    if (ArcVer'="")
		   {
		       s ArcCode=$P(^ARCIM(ArcSub,ArcVer,1),"^",1)
		   }
		}
	}
	
	Q ArcCode
}

/// Creator：wuxianpu
/// CreatDate：2010-12-18
/// Description：取得医嘱套下的医嘱项
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(DHCENS.BBS.Method.Common).GetItemCodeBySet("")
ClassMethod GetItemCodeBySet(SetCode As %String) As %String
{
	s ItemCode=""
	q:SetCode="" ItemCode
	s Arcos=""
	f  s Arcos=$O(^ARCOS(0,"Code",SetCode,Arcos)) q:Arcos=""  d
	.s DateSub=""
	.f  s DateSub=$O(^ARCOS(Arcos,"DATE",DateSub)) q:DateSub=""  d
	..s ItemSub=""
	..f  s ItemSub=$O(^ARCOS(Arcos,"DATE",DateSub,"ITM",ItemSub)) q:ItemSub=""  d
	...s ArcItemDr=$P($g(^ARCOS(Arcos,"DATE",DateSub,"ITM",ItemSub)),"^",1)
	...q:ArcItemDr=""
	...q:'$f(ArcItemDr,"||")
	...i ItemCode="" do
	....s ItemCode=$P($g(^ARCIM(+ArcItemDr,$P(ArcItemDr,"||",2),1)),"^",1)
	...e  do
	....s ItemCode=ItemCode_"#"_$P($g(^ARCIM(+ArcItemDr,$P(ArcItemDr,"||",2),1)),"^",1)
	Q ItemCode
}

/// Creator：wuxianpu
/// CreatDate：2010-12-18
/// Description：取同一条码下的医嘱
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(DHCENS.BBS.Method.Common).GetOrdIdsByLabNo("")
ClassMethod GetOrdIdsByLabNo(LabNo As %String) As %String
{
	q:LabNo="" ""
	s RowID=""
	s MainRowID="" f  s MainRowID=$o(^OEORD(0,"EpisNo",LabNo,MainRowID)) q:MainRowID=""  d
	.s Childsub="" f  s Childsub=$o(^OEORD(0,"EpisNo",LabNo,MainRowID,Childsub)) q:Childsub=""  d
	..i RowID="" d
	...s RowID=MainRowID_"||"_Childsub
	..e  d
	...s RowID=MainRowID_"||"_Childsub_"#"_RowID	
	q RowID
}

/// Creator：WuXinaPu
/// CreatDate：2010-12-18
/// Description： 插入医嘱项
/// Table：
/// Input： 就诊号^医嘱项代码^数量^开单科室^开单医生^录入者^接受科室^医嘱费用类型
/// Return：rowid 插入成功后的医嘱Rowid,如果失败，返回 -1^提示信息
/// Others: w ##class(DHCENS.BBS.Method.Common).AddOrderItem("")
ClassMethod AddOrderItem(ordinfo As %String) As %String
{
	set $zt="ErrorMsg"
	set rowid = -1
	set admNo = $P(ordinfo,"^",1)             //就诊号
	set arcimCode = $P(ordinfo,"^",2)         //医嘱项代码
	set qty = $P(ordinfo,"^",3)               //数量
	set ordDept = $P($P(ordinfo,"^",4),"@",1) //开单科室代码
	set doc = $ZCVT($tr($P($P(ordinfo,"^",5),"@",1),"-",""),"U")     //开单医生代码
	set user = $ZCVT($tr($P($P(ordinfo,"^",6),"@",1),"-",""),"U")    //录入者代码
	set recDept = $P($P(ordinfo,"^",7),"@",1) //接受科室代码
	set BBExtCode=$P(ordinfo,"^",8)

	if ('$D(^ARCIM(0,"Code",arcimCode)))
	{
		Q "-1^医嘱项代码无效"
	}
		
	set sub = $O(^ARCIM(0,"Code",arcimCode,""))
	set ver = $O(^ARCIM(0,"Code",arcimCode,sub,""))
	set itemMast = sub_"||"_ver //医嘱项Rowid
	if (('$D(^CTLOC(0,"Code",ordDept)))||('$D(^CTLOC(0,"Code",recDept))))
	{
		Q "-1^科室代码无效"
	}
	
	set ordDeptDr = $O(^CTLOC(0,"Code",ordDept,""))
	set recDeptDr = $O(^CTLOC(0,"Code",recDept,""))
	
	/*对于补录的医嘱，一般由操作人员直接录入，所以医生的DR仍从ss_user里面查找*/
	
	
	set doc=$$ALPHAUP^SSUTIL4(doc)
	set user=$$ALPHAUP^SSUTIL4(user)
	if (('$D(^SSU("SSUSR",0,"SSUSR_Initials",doc)))||('$D(^SSU("SSUSR",0,"SSUSR_Initials",user))))
	{
	    Q "-1^人员代码无效"	
	}
	// ^CTPCP(0,"Code",$$ALPHAUP({CTPCP_Code}),{CTPCP_RowId})
	set docDr = $O(^SSU("SSUSR",0,"SSUSR_Initials",doc,""))
	set userDr = $O(^SSU("SSUSR",0,"SSUSR_Initials",user,""))
	
	set itemStr = itemMast_"^"_qty_"^"_recDeptDr_"^^^"_BBExtCode_"^"
	set res = ##class(web.DHCOPCashier).CashierInsertOrdItem(admNo,itemStr,userDr,ordDeptDr,docDr,"")
	
	if ($F(res,"0^"))
	{
		set rowid = $P(res,"^",2)
	}
	
	Q rowid
ErrorMsg
	tro
	q "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2010-12-18
/// Description： 停止医嘱
/// Table：
/// Input： rowid,录入者
/// Return：0^成功， -1^提示信息
/// Others: w ##class(DHCENS.BBS.Method.Common).StopOrder("")
ClassMethod StopOrder(OrdItmRowId As %String, UserCode As %String) As %String
{
	set $zt="ErrorMsg"
	q:UserCode="" "-1^操作员代码不能为空"
	set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	set UserRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""),-1)
	q:UserRowId="" "-1^操作员代码"_UserCode_"不存在"
	set retStr=##class(web.DHCOEOrdItem).Stop(OrdItmRowId,UserRowId)
	q retStr	
ErrorMsg
    tro
    q "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：通过医嘱项目指针得到医嘱大类
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.Util.Common).GetOrdCateByArmid(1,1)
ClassMethod GetOrdCateByArmid(ArmSub As %Integer, ArmVer As %Integer) As %String
{
	s OrderCate=""
	s ItemCatDr=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",10)
	i (ItemCatDr'="")
	{
		s OrderCateDr=$p($g(^ARC("IC",ItemCatDr)),"^",8)	
		i (OrderCateDr'="")
		{
			s OrderCate=$p($g(^OEC("ORCAT",OrderCateDr)),"^",1)_"^"_$p($g(^OEC("ORCAT",OrderCateDr)),"^",2)
		}
	}
	Quit OrderCate
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：通过医嘱项目指针得到医嘱子类
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.Util.Common).GetOrdCateByArmid(1,1)
ClassMethod GetOrdSubCateByArmid(ArmSub As %Integer, ArmVer As %Integer) As %String
{
	s OrdSubCate=""
	s ItemCatDr=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",10)
	
	i (ItemCatDr'="")
	{
		
		s OrdSubCate=$p($g(^ARC("IC",ItemCatDr)),"^",1)_"^"_$p($g(^ARC("IC",ItemCatDr)),"^",2)
		
	}
	
	Quit OrdSubCate
}

/// Creator：WuXianPu
/// CreatDate：2012—05-07
/// Description：根据医嘱号查询医嘱大类
/// Table：
/// Input：医嘱号
/// Return：
/// Others：w ##class(web.DHCENS.Util.Common).GetOrderCategoryBy(医嘱号)
ClassMethod GetOrderCategoryBy(OrderID As %String) As %String
{
	s OrderCate=""
	s ArcimID=$p($g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1)),"^",2)
	i (ArcimID'="")
	{
		s ItemCatDr=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",10)
		i (ItemCatDr'="")
		{
			s OrderCateDr=$p($g(^ARC("IC",ItemCatDr)),"^",8)
			
			i (OrderCateDr'="")
			{
				s OrderCate=$p($g(^OEC("ORCAT",OrderCateDr)),"^",2)
			}
		}
	
	}
	q OrderCate
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：根据医嘱号取得医嘱子类
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.Util.Common).GetOrderItemCatByOrderID("")
ClassMethod GetOrderItemCatByOrderID(OrderID As %String) As %String
{
	q:OrderID="" ""
	
	s ItemCat=""
	
	s ArcimID=$p($g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1)),"^",2)
	i (ArcimID'="")
	{
		s ItemCatDr=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",10)
		;s ItemCat=$p($g(^ARC("IC",ItemCatDr)),"^",2)
		i (ItemCatDr'="")
		{
			s ItemCat=$p($g(^ARC("IC",ItemCatDr)),"^",1)_"^"_$p($g(^ARC("IC",ItemCatDr)),"^",2)
			
		}
	}
	q ItemCat
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：保存医嘱结果状态(医嘱号)
/// Table：
/// Input： eOrdItem 医嘱RowID,flag 结果标志,UserDr 操作员,Date 操作日期时间 YYYY-MM-DD ,
/// Return：出参：0^错误信息      0：成功 非零失败
/// Others: w ##class(web.DHCENS.Util.Common).SaveOrdItemResultFlag("")
ClassMethod SaveOrdItemResultFlag(input As %String) As %String
{
	Set $ZTrap = "SendMessageET"
	Set OeOrdItem=$p(input,"^",1)
	Set flag=$p(input,"^",2)
	Set UserDr=$p(input,"^",3)
	Set CDate=$p(input,"^",4)	
	Set CTime=$p(input,"^",5)
	TSTART
	Set flag=$$ALPHAUP^SSUTIL4(flag)
	Set ResStatDR=$o(^OEC("RESST",0,"Code",flag,""),-1)
	Kill PLIST
	Set PLIST(0)=OeOrdItem  
	Set PLIST(3)=ResStatDR 
	Set PLIST(5)=UserDr    
	Set PLIST(7)=CDate
    Set PLIST(9)=CTime
    &sql( INSERT INTO SQLUSER.OE_OrdResult VALUES :PLIST())
	;更新结果标志
	If SQLCODE TROLLBACK  Quit SQLCODE
	&sql(Update SQLUSER.OE_OrdItem set OEORI_ResultFlag=:flag where OEORI_RowId=:OeOrdItem)
	
    If SQLCODE TROLLBACK  Quit SQLCODE
    TCOMMIT
    Quit SQLCODE

SendMessageET
	tro
	s retStr="-1^"_$ze
	q retStr
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：保存医嘱结果状态(通过条码号)
/// Table：
/// Input： eOrdItem 医嘱RowID,flag 结果标志,UserDr 操作员,Date 操作日期时间 YYYY-MM-DD ,
/// Return：出参：0^错误信息      0：成功 非零失败
/// Others: w ##class(web.DHCENS.Util.Common).SaveOrdItemResultFlagByLabNo("")
ClassMethod SaveOrdItemResultFlagByLabNo(input As %String) As %String
{
	s $ZTrap = "SendMessageET"
	s labNo=$p(input,"^",1)
	s flag=$p(input,"^",2)
	s UserDr=$p(input,"^",3)
	s CDate=$p(input,"^",4)	
	s CTime=$p(input,"^",5)
	s rowids="",tmpflag=0
	s oeordId="" f  s oeordId=$O(^OEORD(0,"EpisNo",labNo,oeordId)) q:oeordId=""  d
	.s oeoriSub="" f  s oeoriSub=$O(^OEORD(0,"EpisNo",labNo,oeordId,oeoriSub)) q:oeoriSub=""  d
	..s oeoriId=oeordId_"||"_oeoriSub
	..i rowids="" d
	...s rowids=oeoriId
	..e  d
	...s rowids=oeoriId_"^"_rowids
	f i=1:1:$l(rowids,"^")
	{
		s tmpStr=$p(rowids,"^",i)_"^"_flag_"^"_UserDr_"^"_CDate_"^"_CTime
		s tmpflag=..SaveOrdItemResultFlag(tmpStr)
		q:$p(tmpflag,"^",1)'=0
	}
    Quit tmpflag

SendMessageET
	tro
	s retStr="-1^"_$ze
	q retStr
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：按医嘱号执行医嘱
/// Table：
/// Input： OrdRowId 医嘱RowID,StatusDr 结果标志,ExeUser 操作员
/// Return：出参：0^错误信息      0：成功 非零失败
/// Others: w ##class(web.DHCENS.Util.Common).UpdateOrdStabyRowId("")
ClassMethod UpdateOrdStabyRowId(OrdRowId As %String, StatusDr As %String, ExeUser As %String) As %String
{
	&SQL(update SQLUser.OE_OrdItem Set OEORI_ItemStat_DR=:StatusDr where OEORI_RowId=:OrdRowId)
	q:SQLCODE'=0
	s tmpDate=+$h
	s tmpTime=$p($h,",",2)
	&SQL(insert into SQLUser.OE_OrdStatus (ST_ParRef,ST_Date,ST_Time,ST_Status_DR,ST_User_DR) values(:OrdRowId,:tmpDate,:tmpTime,:StatusDr,:ExeUser))
	q SQLCODE
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：根据状态编码得到状态指针
/// Table：
/// Input： OrderStatus 结果标志
/// Return：出参：0^状态信息      1：医嘱状态不能为空 非零失败
/// Others: w ##class(web.DHCENS.Util.Common).OrderStatusDr("")
ClassMethod OrderStatusDr(OrderStatus As %String) As %String
{
	Q:OrderStatus="" "-1^医嘱状态不能为空"
	set OrderStatusDr=""
	set RESSTRowId=""  f RESSTRowId=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(OrderStatus),RESSTRowId)) q:RESSTRowId=""  d
	.set OrderStatusDr=RESSTRowId
	Quit "0^"_OrderStatusDr
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：输出错误信息
/// Table：
/// Input： 函数名称
/// Return：字符串形式
/// Others: w ##class(web.DHCENS.Util.Common).ErrorDeal("")
ClassMethod ErrorDealString(Function As %String) As %String
{
	Set ErrorString="<Response><"_Function_"Return><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></"_Function_"Return></Response>"
    Quit ErrorString
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：置采血时间//平台组接口
/// Table：
/// Input： labNo:标本号,userId:采血人,specCollDate:采集日期(2011-08-17,17/08/2011),specCollTime:采集时间(18:00:00),clearFlag:撤消标志(Y)
/// Return：字符串形式
/// w ##class(web.DHCENS.Util.Common).UpdateSpecCollTime("","","","","")
ClassMethod UpdateSpecCollTime(labNo, userId, specCollDate = "", specCollTime = "", clearFlag = "") As %String
{
	q:$g(labNo)="" "-1^标本号不能为空!"
	q:$g(userId)="" "-1^操作员不能为空!"
	s err=0
	s oeordId="" f  s oeordId=$O(^OEORD(0,"EpisNo",labNo,oeordId)) q:oeordId=""  d
	.s oeoriSub="" f  s oeoriSub=$O(^OEORD(0,"EpisNo",labNo,oeordId,oeoriSub)) q:oeoriSub=""  d
	..s oeoriId=oeordId_"||"_oeoriSub
	..s itemStatDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	..q:itemStatDR=""
	..s itemStatCode=$P($G(^OEC("OSTAT",itemStatDR)),"^",1)
	..i itemStatCode="D"	//停止医嘱退出
	..s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	..i oeoreSub="" d
   	...k PLIST
    ...s PLIST(0)=oeoriId
    ...s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate
    ...s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime
    ...s PLIST(41)=0
    ...s PLIST(43)="TB"
    ...&sql(insert into SQLUSER.OE_OrdExec Values PLIST())
    ...i SQLCODE s err="执行记录插入有误!" q
    ...s oeoreId=$g(%ROWID)
    ..e  d
    ...s oeoreId=oeoriId_"||"_oeoreSub
    ..i err'=0 q
    ..i ($p(oeoreId,"||",1)="")!($p(oeoreId,"||",2)="")!($p(oeoreId,"||",3)="") q
    ..i specCollDate="" s curDate=+$h
    ..e  d
    ...i specCollDate["-" s curDate=$ZDH(specCollDate,3)
    ...i specCollDate["/" s curDate=$ZDH(specCollDate,4)
    ..i specCollTime="" s curTime=$p($h,",",2)
    ..e  d
    ...s curTime=$ZTH(specCollTime)
    ..i clearFlag="Y" s userId="",curDate="",curTime=""
    ..s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    ..i dhcoreId'="" d
    ...&sql(update SQLUSER.DHC_OE_OrdExec set DHCORE_SpecCollUser=:userId,DHCORE_SpecCollDate=:curDate,DHCORE_SpecCollTime=:curTime where DHCORE_RowId=:dhcoreId)
    ..e  d
    ...&sql(insert into SQLUSER.DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_SpecCollUser,DHCORE_SpecCollDate,DHCORE_SpecCollTime) Values(:oeoreId,:userId,:curDate,:curTime))
    ..s err=SQLCODE
	q err
}

//----------------------------------用处未知------------------------------------------------------------------------------------------------------

/// 得到标本接受时间
/// ordID为医嘱ID，flag标本状态
/// 
ClassMethod GetRuturnTime(ordID As %String, flag As %String) As %String
{
	s RESSTRowId=$o(^OEC("RESST",0,"Code",flag,""))
	s FirstOrdID=$p(ordID,"||",1)
	s LastID=$p(ordID,"||",2)
	set (i,ReceDate,ReceTime)=""
	f  set i=$O(^OEORD(FirstOrdID,"I",LastID,"RES",i)) q:i=""  d
	.s Values=$p($g(^OEORD(FirstOrdID,"I",LastID,"RES",i)),"^",2)
	.i RESSTRowId=Values d
	..s ReceDate=$p($g(^OEORD(FirstOrdID,"I",LastID,"RES",i)),"^",4)
	..s ReceTime=$p($g(^OEORD(FirstOrdID,"I",LastID,"RES",i)),"^",5)
	
	i (ReceDate'="") & (ReceTime'="") d
	.s ReceDate=$zd(ReceDate,3)
	.s ReceTime=$zt(ReceTime,2)
	e 
	.s ReceTime=""
	.s ReceDate=""
	q ReceDate_"^"_ReceTime
}

}
