Class DHCENS.Method.BaseMethod Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 字符串替换 
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

/*
/// 字符串转换
ClassMethod ReplaceStr(CurChar As %String(MAXLEN=32767), ChaChar As %String(MAXLEN=32767), ByChar As %String(MAXLEN=32767)) As %String(MAXLEN=32767)
{
    ///CurChar：传入字符串
    ///ChaChar：需要转化的字符
    ///ByChar：转化成某字符
	Set CurChar=$Get(CurChar),ChaChar=$Get(ChaChar),ByChar=$Get(ByChar)
    Set AllChar=""
    Set Length=""
    Set Length=$Length(CurChar,ChaChar)
    For i=1:1:Length {
	    
	  	Set TmpChar=$p(CurChar,ChaChar,i)
	  	if (Length=1)
	  	{
			Set AllChar=AllChar_TmpChar
	  	}
	  	else
	  	{
		  	if (i=Length)
		  	{
			  	Set AllChar=AllChar_TmpChar
			}
		  	else
		  	{
			  	Set AllChar=AllChar_TmpChar_ByChar
			  	}
		 }
	  	
    }
    Quit AllChar
}
*/
/// 通过医嘱号得到病人登记号
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
	q RegisterNo
}

/// 通过卡号得到病人登记号
ClassMethod GetPatNoByCardNo(CardNo As %String) As %String
{
	s RegisterNo=""
	q:CardNo="" ""
	s rowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""))
	if (rowid'="")
	{
		s RegisterNo=$p($g(^DHCCARD("CF",rowid)),"^",6)
	}
	q RegisterNo
}

/// 通过医嘱号得到医嘱状态
ClassMethod GetOrderStatus(OrdID As %String) As %String
{
	q:OrdID="" ""
	s ItemStatDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",13)
	s OrderStatus=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)_"@"_$p($g(^OEC("OSTAT",ItemStatDr)),"^",2)
	q OrderStatus
}

/// 查询医嘱的收费情况
ClassMethod GetOrderBillStatus(OrdID As %String) As %String
{
	q:OrdID="" ""
	s ItemStatDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",13)
	s OrderStatus=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
	
	s BillStatus=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",5)
	
	if ((BillStatus="P")&&((OrderStatus="V")||(OrderStatus="E")))
	{
		s flag="P"
	}
	else
	{
		s flag="N"
	}
	q flag
}

/// 取病人诊断
ClassMethod GetMRAdmDiagnosis(paadm As %String) As %String
{
	Quit:$g(paadm)="" ""
	Set MRAdm=$P(^PAADM(paadm),"^",61)
	Quit:$g(MRAdm)="" ""
	Set DiagStr=""
	Set Diag=0
	For  Set Diag=$O(^MR(MRAdm,"DIA",Diag)) Quit:(Diag="")!(DiagStr'="")  Do
	.Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
	.Quit:$g(DiagID)=""
	.Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
	.If DiagDesc["-" Set DiagDesc=$P(DiagDesc,"_",2)
	.If DiagStr="" Set DiagStr=DiagDesc
	.Else  Set DiagStr=DiagStr_","_DiagDesc
	Quit DiagStr
}

ClassMethod OrderStatusDr(Code As %String) As %String
{
	q:Code="" ""
	s RowId=$o(^OEC("OSTAT",0,"Code",Code,""))
	q RowId
}

ClassMethod GetUserDrByUserCode(UserCode As %String) As %String
{
	q:UserCode="" ""
	s UserCode=$ZCVT(UserCode,"U")
	s RowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,"")) 
    q RowId
}

/// 按医嘱号执行医嘱
ClassMethod UpdateOrdStabyRowId(OrdRowId As %String, StatusDr As %String, ExeUser As %String) As %String
{
	&SQL(update SQLUser.OE_OrdItem Set OEORI_ItemStat_DR=:StatusDr where OEORI_RowId=:OrdRowId)
	q:SQLCODE'=0
	s tmpDate=+$h
	s tmpTime=$p($h,",",2)
	&SQL(insert into SQLUser.OE_OrdStatus (ST_ParRef,ST_Date,ST_Time,ST_Status_DR,ST_User_DR) values(:OrdRowId,:tmpDate,:tmpTime,:StatusDr,:ExeUser))
	q SQLCODE
}

ClassMethod GetOrderCateBy(OrderID As %String) As %String
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

/// 根据病人rowid取得病人年龄(包括年、月、日)
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
 	
 	Quit Year_"年"_Month_"月"_Day_"日"
}

}
