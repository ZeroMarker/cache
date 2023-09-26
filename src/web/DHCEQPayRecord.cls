/// Modified by JDL 2011-5-17 JDL0081///
/// 重写支付记录，增加SourceType,SourceID,PlanDR,Status等信息
/// 支付记录与业务直接关联，如入库明细，并与付款计划关联，
/// 支付记录与发票的关系调整 通过DHCEQInvoiceUseMap做对照
/// ----------------------------------
/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:支付信息管理
/// --------------------------------
Class web.DHCEQPayRecord Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据发票查找支付记录
/// --------------------------------
/// Modefied by zc 2014-9-15 ZC0006
/// 添加TCheckNo
Query GetPayRecord(InvoiceDR As %String = "", SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TPayMode:%String,TPayFee:%String,TPayDate:%String,TPayNo:%String,TCustomNo:%String,Hidden:%String,TCertificateNo:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TInvoiceNos:%String,TCheckNo:%String")
{
}

ClassMethod GetPayRecordExecute(ByRef qHandle As %Binary, InvoiceDR As %String = "", SourceType As %String = "", SourceID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=0
	if (InvoiceDR'="")  d
	.for  s rowid=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice","9",InvoiceDR,rowid)) q:rowid=""  d
	..d SetValueGetPayRecord
	else  if (SourceID'="")  d
	.for  s rowid=$o(^DHCEQPayRecord(0,"Source",SourceType,SourceID,rowid)) q:rowid=""  d
	..d SetValueGetPayRecord
	
	Quit $$$OK
SetValueGetPayRecord
	d ResetVariablesGetPayRecord
	s TRowID=rowid
	s InvaildFlag=$p($g(^DHCEQPayRecord(rowid)),"^",29)  //modify By GBX   GBX0033
	q:(InvaildFlag="Y")
	s TPayMode=$p($g(^DHCEQPayRecord(rowid)),"^",2)
	s TPayFee=$p($g(^DHCEQPayRecord(rowid)),"^",3)
	s TPayDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayRecord(rowid)),"^",4),"date")
	s TPayNo=$p($g(^DHCEQPayRecord(rowid)),"^",5)
	if TPayNo'=""  d  //modify BY GBX   GBX0033
	.s TPayNo=$p($g(^DHCEQPayRequest(TPayNo)),"^",1)  //modify BY GBX  GBX0033
	s TCustomNo=$p($g(^DHCEQPayRecord(rowid)),"^",6)
	s TCertificateDR=$p($g(^DHCEQPayRecord(rowid)),"^",7)
	i TCertificateDR'=""  s TCertificateNo=$p($g(^DHCEQCertificate(TCertificateDR)),"^",2)
	s TRemark=$p($g(^DHCEQPayRecord(rowid)),"^",9)
	s THold1=$p($g(^DHCEQPayRecord(rowid)),"^",10)
	s THold2=$p($g(^DHCEQPayRecord(rowid)),"^",11)
	s THold3=$p($g(^DHCEQPayRecord(rowid)),"^",12)
	s THold4=$p($g(^DHCEQPayRecord(rowid)),"^",13)
	s THold5=$p($g(^DHCEQPayRecord(rowid)),"^",14)
	
	s TSourceType=$p($g(^DHCEQPayRecord(rowid)),"^",15)
	s TSourceID=$p($g(^DHCEQPayRecord(rowid)),"^",16)
	s TPayPlanDR=$p($g(^DHCEQPayRecord(rowid)),"^",17)
	s TStatus=$p($g(^DHCEQPayRecord(rowid)),"^",18)
	i (SourceType'="")&&(SourceType'=TSourceType) quit
	i (SourceID'="")&&(SourceID'=TSourceID) quit
	;i (PayPlanDR'="")&&(PayPlanDR'=TPayPlanDR) quit
	s TInvoiceNos=##Class(web.DHCEQInvoice).GetInvoiceInfos("9",TRowID)
	if $l(TInvoiceNos,"&")>1
	{
		s TInvoiceNos=$p(TInvoiceNos,"^",1)_"..."
	}
	else
	{
		s TInvoiceNos=$p(TInvoiceNos,"^",1)
	}
	s TCheckNo=$p($g(^DHCEQPayRecord(rowid)),"^",31)
	d OutputRowGetPayRecord
	quit
OutputRowGetPayRecord
	s Data=$lb(TRowID,TPayMode,TPayFee,TPayDate,TPayNo,TCustomNo,TCertificateDR,TCertificateNo,TRemark,THold1,THold2,THold3,THold4,THold5,TInvoiceNos,TCheckNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPayRecord
	s (TRowID,TPayMode,TPayFee,TPayDate,TPayNo,TCustomNo,TCertificateDR,TCertificateNo,TRemark,THold1,THold2,THold3,THold4,THold5,TInvoiceNos,TCheckNo)=""
	quit
}

ClassMethod GetPayRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPayRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据支付记录rowid取支付信息
/// --------------------------------
/// w ##Class(web.DHCEQPayRecord).GetOnePayRecord("1")
ClassMethod GetOnePayRecord(rowid)
{
	new result,ApproveRole
	s (result,resultex)=""
	s result=^DHCEQPayRecord(rowid)
	s resultex=resultex_"^"	;date
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")
	s resultex=resultex_"^"	;CertificateDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCertificate($p(result,"^",7))),"^",2)
	s resultex=resultex_"^"	;PayUserDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID($p(result,"^",8),"user")
	
	s resultex=resultex_"^"	;PayPlanDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPayPlan($p(result,"^",17))),"^",1)
	s resultex=resultex_"^"	;Status
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetEditStatusDisplay($p(result,"^",18))
	
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// InvoiceInfo:发票信息 发票ID^发票号^发票日期^发票金额
/// ---------------------------------
/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:修改、删除、添加支付记录
/// --------------------------------
/// w ##Class(web.DHCEQPayRecord).UpdateData("^1^34^34^19/04/2010^343^^^",0)
ClassMethod UpdateData(Val, Type, InvoiceInfo)
{
	new (Val, Type,InvoiceInfo)
	;Set $ZT="ERROR"
	s RowID=$P(Val,"^",1)	;RowID
	TSTART
	i +Type=0
	{
		s PLIST(2)=$P(Val,"^",2)	;InvoiceDR
		s PLIST(3)=$P(Val,"^",3)	;PayMode
		s PLIST(4)=$P(Val,"^",4)	;PayFee
		s PLIST(5)=##class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",5),"date")	;PayDate
		s PLIST(6)=$P(Val,"^",6)	;PayNo
		s PLIST(7)=$P(Val,"^",7)	;CustomNo
		s PLIST(8)=$P(Val,"^",8)	;CertificateDR
		s PLIST(9)=$P(Val,"^",9)	;PayUserDR
		s PLIST(10)=$P(Val,"^",10)	;Reamrk
		s PLIST(11)=$P(Val,"^",11)	;Hold1
		s PLIST(12)=$P(Val,"^",12)	;Hold2
		s PLIST(13)=$P(Val,"^",13)	;Hold3
		s PLIST(14)=$P(Val,"^",14)	;Hold4
		s PLIST(15)=$P(Val,"^",15)	;Hold5
		
		s PLIST(16)=$P(Val,"^",16)	;SourceType
		s PLIST(17)=$P(Val,"^",17)	;SourceID
		s PLIST(18)=$P(Val,"^",18)	;PayPlanDR
		
		
		if RowID=""
		{
			s PLIST(19)=0	;Status
			&SQL(insert into sqluser.DHC_EQPayRecord values :PLIST())
			s RowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQPayRecord values :PLIST() where PR_RowID=:RowID)
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		;处理发票信息
		s $P(InvoiceInfo,"^",3)=RowID
		s SQLCODE=..SaveInvoiceInfo(InvoiceInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		if (RowID'="")
		{
			&SQL(delete from sqluser.DHC_EQPayRecord where PR_RowID=:RowID)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
		;处理发票信息
		s SQLCODE=..DeleteInvoiceInfo(InvoiceInfo) //2011-10-25 DJ DJ0097
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
 	TCOMMIT
 	q SQLCODE
ERROR
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERROR"_ErrorMsg     	 //返回错误消息 ;
}

/*
/// w ##Class(web.DHCEQPayRecord).CheckPayFee(10000,52,31)
ClassMethod CheckPayFee(PayFee As %Library.String = "", InvoiceDR As %Library.String = "", PRRowID As %Library.String = "")
{
	new (PayFee, InvoiceDR,PRRowID)
	s Flag=0
	s Total=0
	s AmountFee=$p($g(^DHCEQInvoice(InvoiceDR)),"^",4)
	if $Data(^DHCEQPayRecord(0,"Invoice",InvoiceDR))'=0
	{
		s rowid=0
		for  s rowid=$o(^DHCEQPayRecord(0,"Invoice",InvoiceDR,rowid)) q:rowid=""  d
		.q:(rowid=PRRowID)&(PRRowID'="")
		.s TPayFee=$p($g(^DHCEQPayRecord(rowid)),"^",3)
		.s Total=Total+TPayFee
	}
	i AmountFee>=(PayFee+Total) s Flag=1
	q Flag
}
*/
/// Add by JDL 2011-5-18 JDL0081
/// 入参：	SourceType:付款记录对应的源类型 1:入库明细
/// 		SourceID:付款记录对应的源业务ID
/// 		PRRowID:该付款记录ID
/// 		PayFee:该付款记录支付费用
/// 返回：	1：正常
/// 		0：异常，付款金额大于入库明细金额
/// w ##Class(web.DHCEQPayRecord).CheckPayFee()
ClassMethod CheckPayFee(SourceType, SourceID, PRRowID As %Library.String = "", PayFee As %Library.String = "")
{
	n AmountFee,RowID,AllPayFee
	s ^DHCEQTemp("jdl")=SourceType_"^"_SourceID_"^"_PRRowID_"^"_PayFee
	;为空无法判断
	if (SourceType="")||(SourceID="") q 0
	if (SourceType="1")
	{
		;TOriginalFee*TQuantityNum
		s AmountFee=($p($g(^DHCEQInStockList(SourceID)),"^",7))*($p($g(^DHCEQInStockList(SourceID)),"^",8))		
	}
	;金额不大于0，不需支付记录
	if AmountFee'>0 q 0
	s RowID=0
	s AllPayFee=PayFee
	for  s RowID=$o(^DHCEQPayRecord(0,"Source",SourceType,SourceID,RowID)) q:RowID=""  d
	.q:(RowID=PRRowID)
	.s AllPayFee=AllPayFee+$p($g(^DHCEQPayRecord(RowID)),"^",3)
	
	;异常，付款金额大于入库明细金额
	i AllPayFee>AmountFee q 0
	;Modified by jdl 2011-11-23 JDL0103
	;异常，付款金额小于0
	i AllPayFee<0 q 0
	q 1
}

ClassMethod SaveInvoiceInfo(InvoiceInfo)
{
	n IUMRowID, IUMType, IUMSourceID,InvoiceDR,InvoiceNo,InvoiceDate,InvoiceAmount
	n OldInvoiceDR,CanEditFlag,OldCanEditFlag,InvoiceUsedInfo
	
	s IUMRowID=$P(InvoiceInfo,"^",1)
	s IUMType=$P(InvoiceInfo,"^",2)
	s IUMSourceID=$P(InvoiceInfo,"^",3)
	s InvoiceDR=$P(InvoiceInfo,"^",4)
	s InvoiceNo=$P(InvoiceInfo,"^",5)
	s InvoiceDate=$P(InvoiceInfo,"^",6)
	s InvoiceDate=##class(web.DHCEQCommon).TransValueFromPage(InvoiceDate,"date")
	s InvoiceAmount=$P(InvoiceInfo,"^",7)
	s ProviderDR=$P(InvoiceInfo,"^",8)
	s Remark=$P(InvoiceInfo,"^",9)    //add by mwz 20180313 需求号550746
	
	s CanEditFlag=0
	s InvoiceUsedInfo=##Class(web.DHCEQInvoice).InvoiceUsedTimes(IUMType,IUMSourceID,InvoiceDR)
	if ($p(InvoiceUsedInfo,"^",1)=0)||(($p(InvoiceUsedInfo,"^",1)=1)&&($p(InvoiceUsedInfo,"^",2)=1)) s CanEditFlag=1
	
	;检测发票信息是否正常
	s SQLCODE=##Class(web.DHCEQInvoice).CheckInvoiceNo(InvoiceDR, InvoiceNo, ProviderDR,CanEditFlag)
	i SQLCODE q SQLCODE
	
	s OldInvoiceDR=""
	;原发票是否可修改
	s OldCanEditFlag=0
	i IUMRowID'="" 
	{
		s OldInvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)	
		s InvoiceUsedInfo=##Class(web.DHCEQInvoice).InvoiceUsedTimes(IUMType,IUMSourceID,OldInvoiceDR)
		if ($p(InvoiceUsedInfo,"^",1)=0)||(($p(InvoiceUsedInfo,"^",1)=1)&&($p(InvoiceUsedInfo,"^",2)=1)) s OldCanEditFlag=1
	}
	
	k IPLIST
	k IUMPLIST
	;处理发票信息
	;发票DR为空时
	;s IPLIST(2)=InvoiceCode
	s IPLIST(3)=InvoiceNo
	s IPLIST(4)=InvoiceDate
	s IPLIST(5)=InvoiceAmount
	s IPLIST(6)=ProviderDR
	s IPLIST(11)="0"	;Status
	s IPLIST(15)=Remark    //add by mwz 20180313 需求号550746
	s IPLIST(17)="N"	;InValidFlag
	if InvoiceDR=""
	{
		;发票号不为空
		if (InvoiceNo'="")
		{
			;如果旧发票可编辑,则直接修改
			if (OldInvoiceDR'="")&&(OldCanEditFlag=1)
			{
				s InvoiceDR=OldInvoiceDR
				&SQL(update sqluser.DHC_EQInvoice values :IPLIST() where IV_RowID=:InvoiceDR)
				i SQLCODE q SQLCODE
			}
			else
			{				
				&SQL(insert into sqluser.DHC_EQInvoice values :IPLIST())
				i SQLCODE q SQLCODE
				s InvoiceDR=$G(%ROWID)
				;b "s InvoiceDR=$G(%ROWID)"				
			}
		}
	}
	else
	{
		;仅当可编辑时,更新发票信息
		if (CanEditFlag=1)
		{
			&SQL(update sqluser.DHC_EQInvoice values :IPLIST() where IV_RowID=:InvoiceDR)
			i SQLCODE q SQLCODE
		}
	}
	
	;仅当新旧发票不相同时,才需处理
	if (InvoiceDR'=OldInvoiceDR)
	{	
		;当发票为空,即应删除原发票对照信息	
		if (InvoiceDR="")
		{
			s SQLCODE=..DeleteInvoiceInfo(IUMRowID)
			i SQLCODE q SQLCODE
		}
		else
		{
			;该发票已经在业务中记录
			s OtherIUMRowID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",IUMType,InvoiceDR,IUMSourceID,0))
			i (OtherIUMRowID'="")&&(OtherIUMRowID'=IUMRowID) q -1013
			
			i IUMRowID'=""
			{
				;更新发票对照
				s IUMPLIST(3)=InvoiceDR
				&SQL(Update sqluser.DHC_EQInvoiceUseMap values :IUMPLIST() Where IUM_RowID=:IUMRowID)
				i SQLCODE q SQLCODE
			}
			else
			{
				s IUMPLIST(4)=IUMType
				s IUMPLIST(2)=IUMSourceID
				s IUMPLIST(3)=InvoiceDR
				&SQL(insert into sqluser.DHC_EQInvoiceUseMap values :IUMPLIST())
				i SQLCODE q SQLCODE
			}
			
			k IUMPLIST
			;如果是付款记录,则同时处理入库明细对照发票
			if (IUMType="9")
			{
				s ISlRowID=0
				if $p(^DHCEQPayRecord(IUMSourceID),"^",15)=1 s ISlRowID=$p(^DHCEQPayRecord(IUMSourceID),"^",16)
				i ISlRowID>0
				{
					;取入库明细发票对照
					s ISLIUMRowID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice","1",InvoiceDR,ISlRowID,0))
					;b "ISLIUMRowID"
					;已经存在
					if (ISLIUMRowID'="")
					{
						if OldInvoiceDR'=""
						{
							;此入库明细中,无其他付款记录使用该发票,删除该发票对照
							if ..CheckInvoice(IUMSourceID,OldInvoiceDR)=0
							{
								&SQL(Delete from sqluser.DHC_EQInvoiceUseMap Where IUM_Type=1 and IUM_SourceID=:ISlRowID and IUM_InvoiceDR=:OldInvoiceDR)
								i SQLCODE q SQLCODE
							}
						}
					}
					else
					{						
						if (OldInvoiceDR'="")&&(..CheckInvoice(IUMSourceID,OldInvoiceDR)=0)
						{
							s IUMPLIST(3)=InvoiceDR
							&SQL(Update sqluser.DHC_EQInvoiceUseMap values :IUMPLIST() Where IUM_Type='1' and IUM_SourceID=:ISlRowID and IUM_InvoiceDR=:OldInvoiceDR)
							i SQLCODE q SQLCODE
						}
						else
						{
							s IUMPLIST(4)="1"
							s IUMPLIST(2)=ISlRowID
							s IUMPLIST(3)=InvoiceDR
							&SQL(insert into sqluser.DHC_EQInvoiceUseMap values :IUMPLIST())
							i SQLCODE q SQLCODE
							;b "9 insert DHC_EQInvoiceUseMap"
						}						
					}					
				}
			}			
		}
		;发票未共用,可编辑时删除发票号信息
		if (OldInvoiceDR'="")&&(OldCanEditFlag=1)
		{
			&SQL(Update sqluser.DHC_EQInvoice set IV_InvalidFlag='Y' Where IV_RowID=:OldInvoiceDR and IV_Status=0)
			if SQLCODE q SQLCODE
		}
	}
	q 0
}

/// Add by JDL 2011-5-19 JDL0081
/// 删除发票信息
/// 入参：	IUMRowID:发票对照RowID
/// 			IUMType: 1:入库明细  9:付款记录
/// 			IUMSourceID:对应的业务ID 入库明细ID,付款记录ID
/// 返回:0 成功
/// 		其他 失败
ClassMethod DeleteInvoiceInfo(InvoiceInfo)
{
	n OldInvoiceDR,CanEditFlag,InvoiceUsedInfo
	n IUMRowID,IUMType, IUMSourceID,ISlRowID
	s IUMRowID=$P(InvoiceInfo,"^",1)
	if (IUMRowID="") q 0
	
	s OldInvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)	
	s IUMType=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",3)	
	s IUMSourceID=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",1)	
	 
	s CanEditFlag=0
	s InvoiceUsedInfo=##Class(web.DHCEQInvoice).InvoiceUsedTimes(IUMType,IUMSourceID,OldInvoiceDR)
	if ($p(InvoiceUsedInfo,"^",1)=0)||(($p(InvoiceUsedInfo,"^",1)=1)&&($p(InvoiceUsedInfo,"^",2)=1)) s CanEditFlag=1

	;删除相关信息
	&SQL(Delete from sqluser.DHC_EQInvoiceUseMap Where IUM_RowID=:IUMRowID)
	if SQLCODE q SQLCODE
	
	
	
	;当为付款记录时,其对应的入库明细中，只有本付款记录使用该发票时，也要删除入库明细发票对照
	if (IUMType="9")
	{
		;删除入库明细对应的发票号
		s ISlRowID=0
		if $p(^DHCEQPayRecord(IUMSourceID),"^",15)=1
		{
			s ISlRowID=$p(^DHCEQPayRecord(IUMSourceID),"^",16)			
			if (..CheckInvoice(IUMSourceID,OldInvoiceDR)=0)
			{
				&SQL(Delete from sqluser.DHC_EQInvoiceUseMap Where IUM_Type=1 and IUM_SourceID=:ISlRowID and IUM_InvoiceDR=:OldInvoiceDR)
				if SQLCODE q SQLCODE
			}
		}		
	}
	
	;发票未共用,可编辑时删除发票号信息
	if (CanEditFlag=1)
	{
		&SQL(Update sqluser.DHC_EQInvoice set IV_InvalidFlag='Y' Where IV_RowID=:OldInvoiceDR)
		if SQLCODE q SQLCODE
	}	
	q 0
}

/// Add by jdl 2011-5-19 JDL0081
/// 检测该付款记录 对应的入库明细中，是否有其他付款记录使用了该发票号
/// 入参：PRRowID:付款记录
/// 		 InvoiceID:发票ID
/// 		 IUMRowID:发票对照ID
/// 返回：0无
/// 		 1该入库明细中有其他付款记录使用了该发票
ClassMethod CheckInvoice(PRRowID, InvoiceID)
{
	if PRRowID="" q 0
	if InvoiceID="" q 0
	s ISLRowID=0
	if $p(^DHCEQPayRecord(PRRowID),"^",15)=1 s ISlRowID=$p(^DHCEQPayRecord(PRRowID),"^",16)
	i ISlRowID=0 q 0
	s Flag=0
	s SourceID=0
	f  s SourceID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice","9",InvoiceID,SourceID))  q:(SourceID="")||(Flag'=0)  d
	.if $p(^DHCEQPayRecord(SourceID),"^",15)=1  d
	..q:SourceID=PRRowID
	..if ($p(^DHCEQPayRecord(SourceID),"^",16)'=ISLRowID) s Flag=1
	q Flag
}

/************************************************************************/
/// Add By DJ 2012-02-15
Query GetPayRequest(ProviderDR, No, PStartDate, PEndDate, PayStartDate, PayEndDate, SourceTypeDR, Status, OperatorFlag, PayRecordNo, ApproveRole) As %Query(ROWSPEC = "TRowID:%String,TOperator:%String,TSourceType:%String,TNo:%String,TItem:%String,TEquip:%String,TQuantity:%String,TPrice:%String,TAmount:%String,TAmountOnway:%String,TCurAmount:%String,TPayAmount:%String,TRemainFee:%String,TInvoice:%String,TRemark:%String,TPayMode:%String,TPayDate:%String,TSourceID:%String,TPayPlanDR:%String,TPayType:%String,TAllAmount:%String,TAllAmountOnway:%String,TAllPayAmount:%String,TSourceTypeDR:%String,TJob:%String,TPlanItem:%String,TPlanDate:%String,TProvider:%String,TProviderDR:%String,TEquipType:%String,TEquipTypeDR:%String,TPayRecordNo:%String,TPayTypeDR:%String,TPayModeDR:%String,TCheckNo:%String,TRoleStep:%String,TCancelToFlow:%String,TApproveSet:%String")
{
}

ClassMethod GetPayRequestExecute(ByRef qHandle As %Binary, ProviderDR, No, PStartDate, PEndDate, PayStartDate, PayEndDate, SourceTypeDR, Status, OperatorFlag, PayRecordNo, ApproveRole) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TJob=$J
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("19")
	s PayStartDate=##Class(web.DHCEQCommon).TransValueFromPage(PayStartDate,"date")
	s PEndDate=##Class(web.DHCEQCommon).TransValueFromPage(PEndDate,"date")
	i OperatorFlag=0  d //付款申请
	.d BuildDataGetPayRequest
	e  i (OperatorFlag=2)||(OperatorFlag=3) d  //modify BY GBX  GBX0033
	.d BuildDataGetPayRequestCollect
	e  d //付款记录
	.d BuildDataGetPayRecord
	Quit $$$OK

	//modify BY GBX  GBX0033
BuildDataGetPayRequestCollect
	s StatusDR=""
	f  s StatusDR=$o(^DHCEQPayRequest(0,"Status",StatusDR)) q:StatusDR=""  d
	.q:(Status'="")&&(StatusDR'=Status)
	.s PRRowID=0
	.f  s PRRowID=$o(^DHCEQPayRequest(0,"Status",StatusDR,PRRowID))  q:PRRowID=""  d
	..d ResetVariablesGetPayRequest
	..s TRowID=PRRowID
	..q:($p($g(^DHCEQPayRequest(TRowID)),"^",18)="Y")
	..s TProviderDR=$p($g(^DHCEQPayRequest(TRowID)),"^",2)
	..q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	..i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	..s TPayRecordNo=$p($g(^DHCEQPayRequest(TRowID)),"^",1)
	..s PRCRowID=0
	..f  s PRCRowID=$o(^DHCEQPayRecord(0,"Status",StatusDR,PRCRowID))  q:PRCRowID=""  d
	...q:($p($g(^DHCEQPayRecord(PRCRowID)),"^",29)="Y")
	...s TPayRequestDR=$p($g(^DHCEQPayRecord(PRCRowID)),"^",5)
	...q:(TPayRequestDR="")
	...q:(TPayRequestDR'="")&&(TPayRequestDR'=TRowID)
	...s TPayFee=$p($g(^DHCEQPayRecord(PRCRowID)),"^",3)
	...s TCurAmount=TCurAmount+TPayFee
	..d OutputRowGetPayRequest
	quit
	

BuildDataGetPayRecord
	s StatusDR=""
	f  s StatusDR=$o(^DHCEQPayRecord(0,"Status",StatusDR)) q:StatusDR=""  d
	.q:(Status'="")&&(StatusDR'=Status)
	.s PRRowID=0
	.f  s PRRowID=$o(^DHCEQPayRecord(0,"Status",StatusDR,PRRowID))  q:PRRowID=""  d
	..d ResetVariablesGetPayRequest
	..s TRowID=PRRowID
	..s TSourceTypeDR=$p($g(^DHCEQPayRecord(TRowID)),"^",15)
	..q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	..s TPayRecordNo=$p($g(^DHCEQPayRecord(TRowID)),"^",5)
	..q:(PayRecordNo'="")&&(TPayRecordNo'=PayRecordNo)
	..s TPlanDate=$p($g(^DHCEQPayRecord(TRowID)),"^",30)
	..q:(PStartDate'="")&&(TPlanDate<PStartDate)
	..q:(PEndDate'="")&&(TPlanDate>PEndDate)
	..s TPayDate=$p($g(^DHCEQPayRecord(TRowID)),"^",4)
	..q:(PayStartDate'="")&&(TPlanDate<PayStartDate)
	..q:(PayEndDate'="")&&(TPlanDate>PayEndDate)
	..s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	..s TSourceID=$p($g(^DHCEQPayRecord(TRowID)),"^",16)
	..s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",TSourceTypeDR,TSourceID,0))
	..i PRDRowID'=""  d
	...s TAllAmount=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",4)
	...s TProviderDR=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",5)
	...q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	...i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	...s TNo=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",6)
	...q:(No'="")&&(TNo'=No)
	...s TItem=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",7)
	...s TEquipTypeDR=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",8)
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...s TQuantity=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",16)
	...s TPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",15),"")
	..s TCurAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayRecord(TRowID)),"^",3),"")
	..s TPayTypeDR=$p($g(^DHCEQPayRecord(TRowID)),"^",28)
	..s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	..s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	..s TPayDate=##Class(web.DHCEQCommon).TransValueToPage(TPayDate,"date")
	..s TPayModeDR=$p($g(^DHCEQPayRecord(TRowID)),"^",2)
	..i TPayModeDR'="" s TPayMode=$p($g(^DHCEQCCode("DHCEQCPayMode",TPayModeDR)),"^",2)
	..s TRemark=$p($g(^DHCEQPayRecord(TRowID)),"^",9)
	..s TPayPlanDR=$p($g(^DHCEQPayRecord(TRowID)),"^",17)
	..i TPayPlanDR'=""  d
	...s TPlanItem=$p($g(^DHCEQPayPlan(TPayPlanDR)),"^",1)_"("_$p($g(^DHCEQPayPlan(TPayPlanDR)),"^",9)_"%)"
	...s TAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayPlan(TPayPlanDR)),"^",10),"")
	..i TSourceTypeDR<=3  d
	...s TAmountOnway=##Class(web.DHCEQCommon).FormatNumber(..GetPayOrOnWayAmount(TPayPlanDR,TSourceTypeDR,TSourceID,0),"")
	...s TPayAmount=##Class(web.DHCEQCommon).FormatNumber(..GetPayOrOnWayAmount(TPayPlanDR,TSourceTypeDR,TSourceID,0),"")
	...s TAllAmountOnway=##Class(web.DHCEQCommon).FormatNumber(..GetAllPayOrOnWayAmount(TSourceTypeDR,TSourceID,0),"")
	...s TAllPayAmount=##Class(web.DHCEQCommon).FormatNumber(..GetAllPayOrOnWayAmount(TSourceTypeDR,TSourceID,1),"")
	..e  d
	...s TAllAmountOnway=##Class(web.DHCEQCommon).FormatNumber(..GetPayOrOnWayAmount("",TSourceTypeDR,TSourceID,0),"")
	...s TAllPayAmount=##Class(web.DHCEQCommon).FormatNumber(..GetPayOrOnWayAmount("",TSourceTypeDR,TSourceID,1),"")
	..s TRemainFee=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAllAmountOnway-TAllPayAmount,"")
	..s TInvoice=$p($g(^DHCEQPayRecord(TRowID)),"^",1)
	..i TInvoice'="" s TInvoice=$p($g(^DHCEQInvoice(TInvoice)),"^",2)
	..s TCheckNo=$p($g(^DHCEQPayRecord(TRowID)),"^",31)
	..s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,TRowID,0))
	..s CurRole=""
	..i AIRowID'=""  d
	...s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	...s TApproveRole=$p(^DHCEQApproveInfo(AIRowID),"^",7)
	..q:(CurRole'="")&&(CurRole'=ApproveRole)
	..s TRoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("19",TRowID),ApproveRole)
	..s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("19",TRowID)
	..s TCancelToFlow=$p(ApproveInfo,"^",2)
	..s TApproveSet=$p(ApproveInfo,"^",2)
	..d OutputRowGetPayRequest
	quit
BuildDataGetPayRequest
	
	//(1)采购合同
	s CTRowID=0
	f  s CTRowID=$o(^DHCEQContract(0,"Status","2",CTRowID)) q:CTRowID=""  d
	.d ResetVariablesGetPayRequest
	.q:$d(^DHCEQPayRecordDetail(0,"Status",2,CTRowID,2))
	.s ContractType=$p($g(^DHCEQContract(CTRowID)),"^",39) //合同类型 0:采购合同 1:保修合同
	.q:ContractType'=0
	.s TSourceTypeDR=2
	.q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	.s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	.s TNo=$p($g(^DHCEQContract(CTRowID)),"^",2)
	.q:(No'="")&&(TNo'=No)
	.s TProviderDR=$p($g(^DHCEQContract(CTRowID)),"^",18)
	.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	.s TItem=$p($g(^DHCEQContract(CTRowID)),"^",1)
	.s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,0))
	.s ItemDR=$p($g(^DHCEQContractList(CTLRowID)),"^",18)
	.s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
	..s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount+$p($g(^DHCEQContractList(CTLRowID)),"^",8),"")
	.s TAllAmountOnway=..GetAllPayOrOnWayAmount(2,CTRowID,0)
	.s TAllPayAmount=..GetAllPayOrOnWayAmount(2,CTRowID,1)
	.s TRemainFee=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAllAmountOnway-TAllPayAmount,"")
	.q:TRemainFee'>0
	.;q:TAllAmount=(TAllAmountOnway+TAllPayAmount)
	.s PPCount=0
	.s PPRowID=0 //存在付款计划且未付完
	.f  s PPRowID=$o(^DHCEQPayPlan(0,"Source","1",CTRowID,PPRowID)) q:PPRowID=""  d
	..s PPFlag=$p($g(^DHCEQPayPlan(PPRowID)),"^",12)
	..q:PPFlag=1
	..s PPCount=1
	..s TPlanDate=..GetPlanPayDate(PPRowID)
	..q:TPlanDate=""
	..q:(PStartDate'="")&&(TPlanDate<PStartDate)
	..q:(PEndDate'="")&&(TPlanDate>PEndDate)
	..s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	..s TPlanItem=$p($g(^DHCEQPayPlan(PPRowID)),"^",1)_"("_$p($g(^DHCEQPayPlan(PPRowID)),"^",9)_"%)"
	..s TAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayPlan(PPRowID)),"^",10),"")
	..s TAmountOnway=..GetPayOrOnWayAmount(PPRowID,"2",CTRowID,0)
	..s TPayAmount=..GetPayOrOnWayAmount(PPRowID,"2",CTRowID,1)
	..s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount-TAmountOnway-TPayAmount,"")
	..q:+TCurAmount=0
	..i TCurAmount>TRemainFee s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TRemainFee,"")
	..s TSourceID=CTRowID
	..s TPayPlanDR=PPRowID
	..s TPayTypeDR=$p($g(^DHCEQPayPlan(PPRowID)),"^",4)
	..s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	..d OutputRowGetPayRequest
	.;********************************************************************************************
	.i PPCount=0  d //无付款计划或所有付款计划都已完成
	..s TAmountOnway=##Class(web.DHCEQCommon).FormatNumber(TAllAmountOnway,"")
	..s TPayAmount=##Class(web.DHCEQCommon).FormatNumber(TAllPayAmount,"")
	..s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAmountOnway-TPayAmount,"")
	..s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"")
	..q:+TCurAmount=0
	..s TSourceID=CTRowID
	..s TPlanDate=$p($g(^DHCEQContract(CTRowID)),"^",33)
	..q:(PStartDate'="")&&(TPlanDate<PStartDate)
	..q:(PEndDate'="")&&(TPlanDate>PEndDate)
	..s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	..s TPayPlanDR=""
	..s TPayTypeDR=2
	..s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	..d OutputRowGetPayRequest
	
	//(2)验收
	s OCRCheckType=""
	f  s OCRCheckType=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType)) q:OCRCheckType=""  d
	.s OCREquipTypeDR=0
	.f  s OCREquipTypeDR=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,OCREquipTypeDR)) q:OCREquipTypeDR=""  d
	..s OCRRowID=0
	..f  s OCRRowID=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,OCREquipTypeDR,"2",OCRRowID)) q:OCRRowID=""  d
	...s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	...q:InvalidFlag="Y"
	...d ResetVariablesGetPayRequest
	...s TSourceTypeDR=3
	...q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	...s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	...s TNo=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)
	...q:(No'="")&&(TNo'=No)
	...s TProviderDR=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",5)
	...q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	...i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	...s TEquipTypeDR=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",2)
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...s OCLRowID=0
	...f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,OCLRowID)) q:OCLRowID=""  d
	....q:$d(^DHCEQPayRecordDetail(0,"Status",3,OCLRowID,2))
	....s TItem="验收["_$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",2)_"]"
	....;s TEquip=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",2)
	....s TQuantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	....s TPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17),"")
	....s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TPrice,"")
	....s TAllAmountOnway=..GetAllPayOrOnWayAmount(3,OCLRowID,0)
	....s TAllPayAmount=..GetAllPayOrOnWayAmount(3,OCLRowID,1)
	....s TRemainFee=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAllAmountOnway-TAllPayAmount,"")
	....q:TRemainFee'>0
	....;q:TAllAmount=(TAllAmountOnway+TAllPayAmount)
	....s PPCount=0
	....s PPRowID=0 //存在付款计划且未付完
	....f  s PPRowID=$o(^DHCEQPayPlan(0,"Source","2",OCRRowID,PPRowID)) q:PPRowID=""  d
	.....s PPFlag=$p($g(^DHCEQPayPlan(PPRowID)),"^",12)
	.....q:PPFlag=1
	.....s PPCount=1
	.....s TPlanDate=..GetPlanPayDate(PPRowID)
	.....q:TPlanDate=""
	.....q:(PStartDate'="")&&(TPlanDate<PStartDate)
	.....q:(PEndDate'="")&&(TPlanDate>PEndDate)
	.....s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	.....s TPlanItem=$p($g(^DHCEQPayPlan(PPRowID)),"^",1)_"("_$p($g(^DHCEQPayPlan(PPRowID)),"^",9)_"%)"
	.....s TAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayPlan(PPRowID)),"^",10),"")
	.....s TAmountOnway=..GetPayOrOnWayAmount(PPRowID,"3",OCLRowID,0)
	.....s TPayAmount=..GetPayOrOnWayAmount(PPRowID,"3",OCLRowID,1)
	.....s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount-TAmountOnway-TPayAmount,"")
	.....q:+TCurAmount=0
	.....i TCurAmount>TRemainFee s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TRemainFee,"")
	.....s TSourceID=OCLRowID
	.....s TPayPlanDR=PPRowID
	.....s TPayTypeDR=$p($g(^DHCEQPayPlan(PPRowID)),"^",4)
	.....s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	.....d OutputRowGetPayRequest
	....i PPCount=0  d //无付款计划或所有付款计划都已完成
	.....s TAmountOnway=##Class(web.DHCEQCommon).FormatNumber(TAllAmountOnway,"")
	.....s TPayAmount=##Class(web.DHCEQCommon).FormatNumber(TAllPayAmount,"")
	.....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAmountOnway-TPayAmount,"")
	.....s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"")
	.....q:+TCurAmount=0
	.....s TSourceID=OCLRowID
	.....s TPlanDate=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",23)
	.....q:(PStartDate'="")&&(TPlanDate<PStartDate)
	.....q:(PEndDate'="")&&(TPlanDate>PEndDate)
	.....s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	.....s TPayPlanDR=""
	.....s TPayTypeDR=2
	.....s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	.....d OutputRowGetPayRequest
	
	//(3)入库
	s ISEquipTypeDR=0
	f  s ISEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR)) q:ISEquipTypeDR=""  d
	.s ISStartDate=0
	.f  s ISStartDate=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR,ISStartDate)) q:ISStartDate=""  d
	..s ISRowID=0
	..f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR,ISStartDate,ISRowID)) q:ISRowID=""  d
	...s ISNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	...q:ISNo=""	//上线导入数据产生单据过滤
	...q:(No'="")&&(ISNo'=No)
	...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	...q:ISStatus'=2
	...s InvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	...q:InvalidFlag="Y"
	...d ResetVariablesGetPayRequest
	...s TSourceTypeDR=1
	...q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	...s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	...s TProviderDR=$p($g(^DHCEQInStock(ISRowID)),"^",17)
	...q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	...i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	...s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...s TPlanDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
	...q:(PStartDate'="")&&(TPlanDate<PStartDate)
	...q:(PEndDate'="")&&(TPlanDate>PEndDate)
	...s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	...s TNo=ISNo
	...s ISLRowID=0
	...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:ISLRowID=""  d
	....q:$d(^DHCEQPayRecordDetail(0,"Status",1,ISLRowID,2))
	....;s TEquip=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
	....s TItem="入库["_$p($g(^DHCEQInStockList(ISLRowID)),"^",5)_"]"
	....s TQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	....s TPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"")
	....s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TPrice,"")
	....s TAllAmountOnway=..GetAllPayOrOnWayAmount(1,ISLRowID,0)
	....s TAllPayAmount=..GetAllPayOrOnWayAmount(1,ISLRowID,1)
	....s TRemainFee=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAllAmountOnway-TAllPayAmount,"")
	....q:TRemainFee'>0
	....;q:TAllAmount=(TAllAmountOnway+TAllPayAmount)
	....s TAmountOnway=##Class(web.DHCEQCommon).FormatNumber(TAllAmountOnway,"")
	....s TPayAmount=##Class(web.DHCEQCommon).FormatNumber(TAllPayAmount,"")
	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAmountOnway-TPayAmount,"")
	....s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"")
	....s TSourceID=ISLRowID
	....s TPayPlanDR=""
	....s TPayTypeDR=2
	....s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	....d OutputRowGetPayRequest
	
	//(4)调账--
	s CAEquipTypeDR=0
	f  s CAEquipTypeDR=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR))  q:CAEquipTypeDR=""  d
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(CAEquipTypeDR)
	.s CAStartDate=0
	.f  s CAStartDate=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR,CAStartDate)) q:CAStartDate=""  d
	..s CARowID=0
	..f  s CARowID=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR,CAStartDate,CARowID))  q:CARowID=""  d
	...d ResetVariablesGetPayRequest
	...q:$d(^DHCEQPayRecordDetail(0,"Status",4,CARowID,2))
	...s CAStatus=$p($g(^DHCEQChangeAccount(CARowID)),"^",11)
	...q:CAStatus'=2
	...s TSourceTypeDR=4
	...q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	...s TNo=""
	...q:(No'="")&&(TNo'=No)
	...s EquipDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",1)
	...s TProviderDR=$p($g(^DHCEQEquip(EquipDR)),"^",25)
	...q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	...i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	...s TPlanDate=$p($g(^DHCEQChangeAccount(CARowID)),"^",22)
	...q:(PStartDate'="")&&(TPlanDate<PStartDate)
	...q:(PEndDate'="")&&(TPlanDate>PEndDate)
	...s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	...s TEquipTypeDR=CAEquipTypeDR
	...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...s TAmountOnway=..GetPayOrOnWayAmount("","4",CARowID,0)
	...s TPayAmount=..GetPayOrOnWayAmount("","4",CARowID,1)
	...s TAllAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQChangeAccount(CARowID)),"^",2),"")
	...q:TAllAmount<=0
	...q:TAllAmount=(TAmountOnway+TPayAmount)
	...s TAllAmountOnway=##Class(web.DHCEQCommon).FormatNumber(TAmountOnway,"")
	...s TAllPayAmount=##Class(web.DHCEQCommon).FormatNumber(TPayAmount,"")
	...s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	...s TItem="调账["_$p($g(^DHCEQEquip(EquipDR)),"^",1)_"]"
	...;s TEquip=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	...s TQuantity=1
	...s TPrice=##Class(web.DHCEQCommon).FormatNumber(TAllAmount,"")
	...s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount,"")
	...s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAmountOnway-TPayAmount,"")
	...s TRemainFee=##Class(web.DHCEQCommon).FormatNumber(TCurAmount,"")
	...s TSourceID=CARowID
	...s TPayTypeDR=2
	...s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	...d OutputRowGetPayRequest
	
	//(5)保养,(6)检查,(7)维修
	s MTType=0
	f  s MTType=$o(^DHCEQMaint(0,"Equip",MTType))  q:MTType=""  d
	.s MTEquipDR=0
	.f  s MTEquipDR=$o(^DHCEQMaint(0,"Equip",MTType,MTEquipDR))  q:MTEquipDR=""  d
	..s MTRowID=0
	..f  s MTRowID=$o(^DHCEQMaint(0,"Equip",MTType,MTEquipDR,MTRowID))  q:MTRowID=""  d
	...s MTStatus=$p($g(^DHCEQMaint(MTRowID)),"^",13)
	...q:MTStatus'=2
	...s InvalidFlag=$p($g(^DHCEQMaint(MTRowID)),"^",39)
	...q:InvalidFlag="Y"
	...d ResetVariablesGetPayRequest
	...s TSourceTypeDR=MTType+4
	...q:$d(^DHCEQPayRecordDetail(0,"Status",TSourceTypeDR,MTRowID,2))
	...q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	...s TNo=""
	...q:(No'="")&&(TNo'=No)
	...s TEquipTypeDR=$p($g(^DHCEQEquip(MTEquipDR)),"^",63)
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...s TProviderDR=$p($g(^DHCEQEquip(MTEquipDR)),"^",25)
	...q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	...i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	...s TPlanDate=$p($g(^DHCEQMaint(MTRowID)),"^",19)
	...q:(PStartDate'="")&&(TPlanDate<PStartDate)
	...q:(PEndDate'="")&&(TPlanDate>PEndDate)
	...s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	...s TAmountOnway=..GetPayOrOnWayAmount("",TSourceTypeDR,MTRowID,0)
	...s TPayAmount=..GetPayOrOnWayAmount("",TSourceTypeDR,MTRowID,1)
	...s TAllAmountOnway=##Class(web.DHCEQCommon).FormatNumber(TAmountOnway,"")
	...s TAllPayAmount=##Class(web.DHCEQCommon).FormatNumber(TPayAmount,"")
	...s TAllAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMaint(MTRowID)),"^",24),"")
	...q:TAllAmount<=0
	...q:TAllAmount=(TAmountOnway+TPayAmount)
	...;s TEquip=$p($g(^DHCEQEquip(MTEquipDR)),"^",1)
	...s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	...s MTSourceID=$p($g(^DHCEQMaint(MTRowID)),"^",3)
	...i MTSourceID'=""  d
	....i (MTType=1)||(MTType=2) s TItem=$p($g(^DHCEQMaintPlan(MTSourceID)),"^",1)
	....i MTType=3 s TItem="维修["_$p($g(^DHCEQEquip(MTEquipDR)),"^",1)_"]"
	...e  d
	....i MTType=1 s TItem="保养["_$p($g(^DHCEQEquip(MTEquipDR)),"^",1)_"]"
	....i MTType=2 s TItem="检查["_$p($g(^DHCEQEquip(MTEquipDR)),"^",1)_"]"
	....i MTType=3 s TItem="维修["_$p($g(^DHCEQEquip(MTEquipDR)),"^",1)_"]"
	...s TQuantity=1
	...s TPrice=##Class(web.DHCEQCommon).FormatNumber(TAllAmount,"")
	...s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount,"")
	...s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAmountOnway-TPayAmount,"")
	...s TRemainFee=##Class(web.DHCEQCommon).FormatNumber(TCurAmount,"")
	...s TSourceID=MTRowID
	...s TPayTypeDR=2
	...s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	...d OutputRowGetPayRequest
	
	//(8)保修合同
	s SCEquipDR=0
	f  s SCEquipDR=$o(^DHCEQServiceContract(0,"Equip",SCEquipDR)) q:SCEquipDR=""  d
	.s SCRowID=0
	.f  s SCRowID=$o(^DHCEQServiceContract(0,"Equip",SCEquipDR,SCRowID)) q:SCRowID=""  d
	..d ResetVariablesGetPayRequest
	..s CTRowID=$p($g(^DHCEQServiceContract(SCRowID)),"^",2)
	..q:$d(^DHCEQPayRecordDetail(0,"Status",8,CTRowID,2))
	..s TSourceTypeDR=8
	..q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	..s TNo=$p($g(^DHCEQContract(CTRowID)),"^",2)
	..q:(No'="")&&(TNo'=No)
	..s TProviderDR=$p($g(^DHCEQEquip(SCEquipDR)),"^",25)
	..q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	..i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	..s TEquipTypeDR=$p($g(^DHCEQEquip(SCEquipDR)),"^",63)
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	..i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	..s TPlanDate=$p($g(^DHCEQContract(CTRowID)),"^",11)
	..q:(PStartDate'="")&&(TPlanDate<PStartDate)
	..q:(PEndDate'="")&&(TPlanDate>PEndDate)
	..s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	..s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	..s TAmountOnway=..GetPayOrOnWayAmount("",8,CTRowID,0)
	..s TPayAmount=..GetPayOrOnWayAmount("",8,CTRowID,1)
	..s TAllAmountOnway=##Class(web.DHCEQCommon).FormatNumber(TAmountOnway,"")
	..s TAllPayAmount=##Class(web.DHCEQCommon).FormatNumber(TPayAmount,"")
	..s TAllAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(CTRowID)),"^",4),"")
	..q:TAllAmount<=0
	..q:TAllAmount=(TAmountOnway+TPayAmount)
	..;s TItem=$p($g(^DHCEQContract(CTRowID)),"^",1)
	..s TItem="保修合同["_$p($g(^DHCEQEquip(SCEquipDR)),"^",1)_"]"
	..;s TEquip=$p($g(^DHCEQEquip(SCEquipDR)),"^",1)
	..s TQuantity=1
	..s TPrice=##Class(web.DHCEQCommon).FormatNumber(TAllAmount,"")
	..s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount,"")
	..s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAmountOnway-TPayAmount,"")
	..s TRemainFee=##Class(web.DHCEQCommon).FormatNumber(TCurAmount,"")
	..s TSoueceID=CTRowID
	..s TPayTypeDR=2
	..s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	..d OutputRowGetPayRequest
	
	//(10)工程款--
	s PProviderDR=0
	f  s PProviderDR=$o(^DHCEQProject(0,"StatusProvider","2",PProviderDR))  q:PProviderDR=""  d
	.s PRowID=0
	.f  s PRowID=$o(^DHCEQProject(0,"StatusProvider","2",PProviderDR,PRowID))  q:PRowID=""  d
	..s InvalidFlag=$p($g(^DHCEQProject(PRowID)),"^",24)
	..q:InvalidFlag="Y"
	..q:$d(^DHCEQPayRecordDetail(0,"Status",10,PRowID,2))
	..d ResetVariablesGetPayRequest
	..s TNo=$p($g(^DHCEQProject(PRowID)),"^",1)
	..q:(No'="")&&(TNo'=No)
	..s TSourceTypeDR=10
	..q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	..s TProviderDR=$p($g(^DHCEQProject(PRowID)),"^",6)
	..q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	..i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	..s TEquipTypeDR=$p($g(^DHCEQProject(PRowID)),"^",25)
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	..i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	..s TPlanDate=$p($g(^DHCEQProject(PRowID)),"^",19)
	..q:(PStartDate'="")&&(TPlanDate<PStartDate)
	..q:(PEndDate'="")&&(TPlanDate>PEndDate)
	..s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	..s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	..s TAmountOnway=..GetPayOrOnWayAmount("",10,PRowID,0)
	..s TPayAmount=..GetPayOrOnWayAmount("",10,PRowID,1)
	..s TAllAmountOnway=##Class(web.DHCEQCommon).FormatNumber(TAmountOnway,"")
	..s TAllPayAmount=##Class(web.DHCEQCommon).FormatNumber(TPayAmount,"")
	..s TAllAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQProject(PRowID)),"^",7),"")
	..q:TAllAmount<=0
	..q:TAllAmount=(TAmountOnway+TPayAmount)
	..s TItem=$p($g(^DHCEQProject(PRowID)),"^",2)
	..s TQuantity=1
	..s TPrice=##Class(web.DHCEQCommon).FormatNumber(TAllAmount,"")
	..s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount,"")
	..s TCurAmount=##Class(web.DHCEQCommon).FormatNumber(TAllAmount-TAmountOnway-TPayAmount,"")
	..s TRemainFee=##Class(web.DHCEQCommon).FormatNumber(TCurAmount,"")
	..s TSoueceID=PRowID
	..s TPayTypeDR=2
	..s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	..d OutputRowGetPayRequest
	//(11)退货
	s REquipTypeDR=0
	f  s REquipTypeDR=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR)) q:REquipTypeDR=""  d
	.s RStartDate=0
	.f  s RStartDate=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR,"1",RStartDate)) q:RStartDate=""  d
	..s RRowID=0
	..f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR,"1",RStartDate,RRowID)) q:RRowID=""  d
	...s ReturnNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
	...q:(No'="")&&(ReturnNo'=No)
	...s RStatus=$p($g(^DHCEQReturn(RRowID)),"^",13)
	...q:RStatus'=2
	...s InvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
	...q:InvalidFlag="Y"
	...d ResetVariablesGetPayRequest
	...s TSourceTypeDR=11
	...q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	...s TSourceType=..GetDisplaySourceType(TSourceTypeDR)
	...s TProviderDR=$p($g(^DHCEQReturn(RRowID)),"^",3)
	...q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	...i TProviderDR'="" s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	...s TEquipTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",15)
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...s TPlanDate=RStartDate
	...q:(PStartDate'="")&&(TPlanDate<PStartDate)
	...q:(PEndDate'="")&&(TPlanDate>PEndDate)
	...s TPlanDate=##Class(web.DHCEQCommon).TransValueToPage(TPlanDate,"date")
	...s TNo=ReturnNo
	...s RLRowID=0
	...f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID)) q:RLRowID=""  d
	....q:$d(^DHCEQPayRecordDetail(0,"Status",11,RLRowID,2))
	....s RInStockListDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
	....s REQRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
	....i RInStockListDR'=""  d
	.....s TItem="退货["_$p($g(^DHCEQInStockList(RInStockListDR)),"^",5)_"]"
	....e  d
	.....s TItem="退货["_$p($g(^DHCEQEquip(REQRowID)),"^",1)_"]"
	....s TQuantity=$p($g(^DHCEQReturnList(RLRowID)),"^",5)
	....s TPrice=$p($g(^DHCEQReturnList(RLRowID)),"^",6)
	....s TAllAmount=TQuantity*TPrice
	....s TAllAmountOnway=..GetPayOrOnWayAmount("",11,RLRowID,0)
	....s TAllPayAmount=..GetPayOrOnWayAmount("",11,RLRowID,1)
	....s TRemainFee=TAllAmount-TAllAmountOnway-TAllPayAmount
	....q:TRemainFee'>0
	....;q:TAllAmount=(TAllAmountOnway+TAllPayAmount)
	....s TAmountOnway=TAllAmountOnway
	....s TPayAmount=TAllPayAmount
	....s TAmount=TAllAmount-TAmountOnway-TPayAmount
	....s TCurAmount=TAmount
	....s TSourceID=RLRowID
	....s TPayPlanDR=""
	....s TPayTypeDR=2
	....s TPayType=##Class(web.DHCEQPayPlan).GetPayTypeDisplay(TPayTypeDR)
	....d OutputRowGetPayRequest
	
	quit
OutputRowGetPayRequest
	s Data=$lb(TRowID,TOperator,TSourceType,TNo,TItem,TEquip,TQuantity,TPrice,TAmount,TAmountOnway,TCurAmount,TPayAmount,TRemainFee,TInvoice,TRemark,TPayMode,TPayDate,TSourceID,TPayPlanDR,TPayType,TAllAmount,TAllAmountOnway,TAllPayAmount,TSourceTypeDR,TJob,TPlanItem,TPlanDate,TProvider,TProviderDR,TEquipType,TEquipTypeDR,TPayRecordNo,TPayTypeDR,TPayModeDR,TCheckNo,TRoleStep,TCancelToFlow,TApproveSet)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPayRequest
	s (TRowID,TOperator,TSourceType,TNo,TItem,TEquip,TQuantity,TPrice,TAmount,TAmountOnway,TCurAmount,TPayAmount,TRemainFee,TInvoice,TRemark,TPayMode,TPayDate,TSourceID,TPayPlanDR,TPayType,TAllAmount,TAllAmountOnway,TAllPayAmount,TSourceTypeDR,TPlanItem,TPlanDate,TProvider,TProviderDR,TEquipType,TEquipTypeDR,TPayRecordNo,TPayTypeDR,TPayModeDR,TCheckNo,TRoleStep,TCancelToFlow,TApproveSet)=""
	quit
}

ClassMethod GetPayRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRequestExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPayRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2012-02-28
/// 获取付款计划对应计划付款日期
ClassMethod GetPlanPayDate(PPID)
{
	n (PPID)
	i PPID="" q ""
	s PPDateType=$p($g(^DHCEQPayPlan(PPID)),"^",5)  //1:确定日期 2:相对验收日期 3:相对入库日期
	s PlanPayDate=$p($g(^DHCEQPayPlan(PPID)),"^",6)
	i PPDateType=1 q PlanPayDate
	s PPSourceType=$p($g(^DHCEQPayPlan(PPID)),"^",2) //1:合同付款计划 2:验收付款计划
	s PPSourceID=$p($g(^DHCEQPayPlan(PPID)),"^",3)
	s PeriodNum=$p($g(^DHCEQPayPlan(PPID)),"^",7)
	s PeriodUnit=$p($g(^DHCEQPayPlan(PPID)),"^",8) //1:年 2:月 3:日
	i PeriodUnit=1 s PeriodUnit="YYYY"
	i PeriodUnit=2 s PeriodUnit="M"
	i PeriodUnit=3 s PeriodUnit="D"
	s PlanPayDate=""
	i PPSourceType=1 //合同付款计划
	{
		s CTRowID=PPSourceID
		s CTLRowID=0
		f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID))  q:(CTLRowID="")||(PlanPayDate'="")  d
		.s OCLRowID=0
		.f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",1,CTLRowID,OCLRowID))  q:(OCLRowID="")||(PlanPayDate'="")  d
		..s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
		..s OCRStatus=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",20)
		..q:OCRStatus'=2
		..s OCRInvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
		..q:OCRInvalidFlag="Y"
		..s OCRDate=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",26)
		..s OCRDate=##Class(web.DHCEQCommon).TransValueToPage(OCRDate,"date")
		..i PPDateType=2  d  //相对验收日期
		...s PlanPayDate=##Class(web.DHCEQCommon).DateAdd(PeriodUnit,PeriodNum,OCRDate)
		...s PlanPayDate=##Class(web.DHCEQCommon).TransValueFromPage(PlanPayDate,"date")
		..q:PlanPayDate'=""
		..s ISLRowID=0
		..f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:(ISLRowID="")||(PlanPayDate'="")  d
		...s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
		...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
		...q:ISStatus'=2
		...s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
		...q:ISInvalidFlag="Y"
		...s ISDate=$p($g(^DHCEQInStock(ISRowID)),"^",7)
		...s ISDate=##Class(web.DHCEQCommon).TransValueToPage(ISDate,"date")
		...i PPDateType=3  d //相对入库日期
		....s PlanPayDate=##Class(web.DHCEQCommon).DateAdd(PeriodUnit,PeriodNum,ISDate)
		....s PlanPayDate=##Class(web.DHCEQCommon).TransValueFromPage(PlanPayDate,"date")
	}
	i PPSourceType=2 //验收付款计划
	{
		s OCRRowID=PPSourceID
		s OCRDate=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",26)
		s OCRDate=##Class(web.DHCEQCommon).TransValueToPage(OCRDate,"date")
		i PPDateType=2  d
		.s PlanPayDate=##Class(web.DHCEQCommon).DateAdd(PeriodUnit,PeriodNum,OCRDate)
		.s PlanPayDate=##Class(web.DHCEQCommon).TransValueFromPage(PlanPayDate,"date")
		e  d
		.s OCLRowID=0
		.f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,OCLRowID)) q:(OCLRowID="")||(PlanPayDate'="")  d
		..s ISLRowID=0
		..f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:(ISLRowID="")||(PlanPayDate'="")  d
		...s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
		...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
		...q:ISStatus'=2
		...s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
		...q:ISInvalidFlag="Y"
		...s ISDate=$p($g(^DHCEQInStock(ISRowID)),"^",7)
		...s ISDate=##Class(web.DHCEQCommon).TransValueToPage(ISDate,"date")
		...i PPDateType=3  d //相对入库日期
		....s PlanPayDate=##Class(web.DHCEQCommon).DateAdd(PeriodUnit,PeriodNum,ISDate)
		....s PlanPayDate=##Class(web.DHCEQCommon).TransValueFromPage(PlanPayDate,"date")
	}
	q PlanPayDate
}

/// Add By DJ 2012-02-16
/// 描述:付款来源类型解析
ClassMethod GetDisplaySourceType(value)
{
	i value="" q ""
	i +value=1 q "入库明细"
	i +value=2 q "合同"
	i +value=3 q "验收单"
	i +value=4 q "调账"
	i +value=5 q "保养"
	i +value=6 q "检查"
	i +value=7 q "维修"
	i +value=8 q "保修合同"
	i +value=10 q "工程款"
	i +value=11	q "退货"
	
	q "未定义"
}

ClassMethod SourceTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>"_..GetDisplaySourceType(1)_"</option>"
	w "<option value=2>"_..GetDisplaySourceType(2)_"</option>"
	w "<option value=3>"_..GetDisplaySourceType(3)_"</option>"
	w "<option value=4>"_..GetDisplaySourceType(4)_"</option>"
	w "<option value=5>"_..GetDisplaySourceType(5)_"</option>"
	w "<option value=6>"_..GetDisplaySourceType(6)_"</option>"
	w "<option value=7>"_..GetDisplaySourceType(7)_"</option>"
	w "<option value=8>"_..GetDisplaySourceType(8)_"</option>"
	w "<option value=10>"_..GetDisplaySourceType(10)_"</option>"
	w "<option value=11>"_..GetDisplaySourceType(11)_"</option>"
	w "</select>",!
}

/// Add By DJ 2012-02-16
/// 描述:获取已付款金额或在途付款金额
ClassMethod GetPayOrOnWayAmount(PPID, vSourceType, vSourceID, Type)
{
	s Amount=0
	s rowid=0
	f  s rowid=$o(^DHCEQPayRecord(0,"Source",vSourceType,vSourceID,rowid)) q:rowid=""  d
	.s InvalidFlag=$p($g(^DHCEQPayRecord(rowid)),"^",29)
	.q:InvalidFlag="Y"
	.s PRStatus=$p($g(^DHCEQPayRecord(rowid)),"^",18)
	.q:PRStatus=3
	.s PRPlanDR=$p($g(^DHCEQPayRecord(rowid)),"^",17)
	.q:(PPID'="")&&(PRPlanDR'=PPID)
	.s PRFee=$p($g(^DHCEQPayRecord(rowid)),"^",3)
	.i (Type="") s Amount=Amount+PRFee
	.i (Type=1)&&(PRStatus=2) s Amount=Amount+PRFee
	.i (Type=0)&&(PRStatus'=2) s Amount=Amount+PRFee
	q ##Class(web.DHCEQCommon).FormatNumber(Amount,"")
}

/// Add By DJ 2012-02-27
/// 获取验收,入库,合同已付款总金额及在途总金额
ClassMethod GetAllPayOrOnWayAmount(SourceType, SourceID, Type)
{
	n (SourceType,SourceID,Type)
	s (TAllAmount,HTAmountOnway,HTPayAmount,TAllAmountOnway,TAllPayAmount)=0
	//入库
	i SourceType=1
	{
		s ISLRowID=SourceID
		k ^DHCEQTemp("PayRecord",$J)
		s (DiffAmountOnway,DiffPayAmount,RKAmountOnway,RKPayAmount)=0
		s ISLSourceType=$p($g(^DHCEQInStockList(ISLRowID)),"^",18)
		s ISLSourceID=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
		i ISLSourceType=2  d  //入库明细来自验收单
		.s OCLRowID=ISLSourceID
		.s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
		.s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
		.s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
		.i OCLSourceType=1  d  //验收单来自合同
		..s CTRowID=$p($g(^DHCEQContractList(OCLSourceID)),"^",1)
		..s CTLRowID=0
		..f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^0^0^"_$p($g(^DHCEQContractList(CTLRowID)),"^",8)
		...s OCLRowID=0
		...f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source","1",CTLRowID,OCLRowID))  q:OCLRowID=""  d
		....s TQuantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
		....s TPrice=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17)
		....s TAllAmount=TQuantity*TPrice
		....s RKAmountOnway=..GetPayOrOnWayAmount("","3",OCLRowID,0)
		....s RKPayAmount=..GetPayOrOnWayAmount("","3",OCLRowID,1)
		....i (RKAmountOnway+RKPayAmount)=TAllAmount  d
		.....s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		....e  d
		.....s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		....s ISLRowID=0
		....f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:ISLRowID=""  d
		.....s RKAmountOnway=RKAmountOnway+..GetPayOrOnWayAmount("","1",ISLRowID,0)
		.....s RKPayAmount=RKPayAmount+..GetPayOrOnWayAmount("","1",ISLRowID,1)
		.....i (RKAmountOnway+RKPayAmount)=TAllAmount  d
		......s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		.....e  d
		......s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		/************处理合同付款入库单分摊问题,并统计出在途和已付中未分摊部分***********************/
		s CTLRowID=0
		f  s CTLRowID=$o(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID))  q:CTLRowID=""  d
		.s Flag=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",1)
		.q:Flag=1
		.s AmountOnwayByHT=..GetHTAllotByCTL(CTLRowID,0)
		.s PayAmountByHT=..GetHTAllotByCTL(CTLRowID,1)
		.s RKAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s RKPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.s TAllAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",4)
		.i (RKAmountOnway+RKPayAmount+PayAmountByHT)>=TAllAmount  d
		..s DiffPayAmount=DiffPayAmount+RKAmountOnway+RKPayAmount+PayAmountByHT-TAllAmount
		..s RKPayAmount=TAllAmount-RKAmountOnway
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		.e  d
		..s RKPayAmount=RKPayAmount+PayAmountByHT
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		.s RKAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s RKPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.i (RKAmountOnway+RKPayAmount+AmountOnwayByHT)>=TAllAmount  d
		..s DiffAmountOnway=DiffAmountOnway+RKAmountOnway+RKPayAmount+AmountOnwayByHT-TAllAmount
		..s RKAmountOnway=TAllAmount-RKPayAmount
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		.e  d
		..s RKAmountOnway=RKAmountOnway+AmountOnwayByHT
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		/*********按照入库记录的顺序分摊未分摊的已付款和在途付款部分************************/
		s CTLRowID=0
		f  s CTLRowID=$o(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID))  q:CTLRowID=""  d
		.s Flag=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",1)
		.q:Flag=1
		.s RKAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s RKPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.s TAllAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",4)
		.i DiffPayAmount'=0  d
		..i (RKAmountOnway+RKPayAmount+DiffPayAmount)>=TAllAmount  d
		...s DiffPayAmount=RKAmountOnway+RKPayAmount+DiffPayAmount-TAllAmount
		...s RKPayAmount=TAllAmount-RKAmountOnway
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		..e  d
		...s RKPayAmount=RKPayAmount+DiffPayAmount
		...s DiffPayAmount=0
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		.s RKAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s RKPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.i DiffAmountOnway'=0  d
		..i (RKAmountOnway+RKPayAmount+DiffAmountOnway)>=TAllAmount  d
		...s DiffAmountOnway=RKAmountOnway+RKPayAmount+DiffAmountOnway-TAllAmount
		...s RKAmountOnway=TAllAmount-RKPayAmount
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		..e  d
		...s RKAmountOnway=RKAmountOnway+DiffAmountOnway
		...s DiffAmountOnway=0
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_RKAmountOnway_"^"_RKPayAmount_"^"_TAllAmount
		/***********************输出结果***************************************/
		i ISLSourceType=2  d  //入库明细来自验收单
		.s OCLRowID=ISLSourceID
		.s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
		.s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
		.s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
		.i OCLSourceType=1  d  //验收单来自合同
		..s CTLRowID=OCLSourceID
		..s TAllAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		..s TAllPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.e  d
		..s TAllAmountOnway=..GetPayOrOnWayAmount("","3",OCLRowID,0)+..GetPayOrOnWayAmount("","1",SourceID,0)
		..s TAllPayAmount=..GetPayOrOnWayAmount("","3",OCLRowID,1)+..GetPayOrOnWayAmount("","1",SourceID,1)
		e  d
		.s TAllAmountOnway=..GetPayOrOnWayAmount("","1",SourceID,0)
		.s TAllPayAmount=..GetPayOrOnWayAmount("","1",SourceID,1)
	}
	//合同
	i SourceType=2
	{
		s CTRowID=SourceID
		s CTLRowID=0 //合同对应验收及入库明细付款记录
		f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
		.s TAllAmount=TAllAmount+$p($g(^DHCEQContractList(CTLRowID)),"^",8)
		.s OCLRowID=0
		.f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source","1",CTLRowID,OCLRowID))  q:OCLRowID=""  d
		..s HTAmountOnway=HTAmountOnway+..GetPayOrOnWayAmount("","3",OCLRowID,0)
		..s HTPayAmount=HTPayAmount+..GetPayOrOnWayAmount("","3",OCLRowID,1)
		..s ISLRowID=0
		..f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:ISLRowID=""  d
		...s HTAmountOnway=HTAmountOnway+..GetPayOrOnWayAmount("","1",ISLRowID,0)
		...s HTPayAmount=HTPayAmount+..GetPayOrOnWayAmount("","1",ISLRowID,1)
		s TAllAmountOnway=HTAmountOnway+..GetPayOrOnWayAmount("","2",CTRowID,0)
		s TAllPayAmount=HTPayAmount+..GetPayOrOnWayAmount("","2",CTRowID,1)
	}
	//验收
	i SourceType=3
	{
		s OCLRowID=SourceID
		k ^DHCEQTemp("PayRecord",$J)
		s (DiffAmountOnway,DiffPayAmount,YSAmountOnway,YSPayAmount)=0
		s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
		s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
		i OCLSourceType=1  d  //验收单来自合同
		.s CTRowID=$p($g(^DHCEQContractList(OCLSourceID)),"^",1)
		.s CTLRowID=0
		.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^0^0"_$p($g(^DHCEQContractList(CTLRowID)),"^",8)
		..s OCLRowID=0
		..f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source","1",CTLRowID,OCLRowID))  q:OCLRowID=""  d
		...s TQuantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
		...s TPrice=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17)
		...s TAllAmount=TQuantity*TPrice
		...s YSAmountOnway=..GetPayOrOnWayAmount("","3",OCLRowID,0)
		...s YSPayAmount=..GetPayOrOnWayAmount("","3",OCLRowID,1)
		...i (YSAmountOnway+YSPayAmount)=TAllAmount  d
		....s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		...e  d
		....s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		...s ISLRowID=0
		...f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:ISLRowID=""  d
		....s YSAmountOnway=YSAmountOnway+..GetPayOrOnWayAmount("","1",ISLRowID,0)
		....s YSPayAmount=YSPayAmount+..GetPayOrOnWayAmount("","1",ISLRowID,1)
		...i (YSAmountOnway+YSPayAmount)=TAllAmount  d
		....s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		...e  d
		....s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		/************处理合同付款验收单分摊问题,并统计出在途和已付中未分摊部分***********************/
		s CTLRowID=0
		f  s CTLRowID=$o(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID))  q:CTLRowID=""  d
		.s Flag=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",1)
		.q:Flag=1
		.s AmountOnwayByHT=..GetHTAllotByCTL(CTLRowID,0)
		.s PayAmountByHT=..GetHTAllotByCTL(CTLRowID,1)
		.s YSAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s YSPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.s TAllAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",4)
		.i (YSAmountOnway+YSPayAmount+PayAmountByHT)>=TAllAmount  d
		..s DiffPayAmount=DiffPayAmount+YSAmountOnway+YSPayAmount+PayAmountByHT-TAllAmount
		..s YSPayAmount=TAllAmount-YSAmountOnway
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		.e  d
		..s YSPayAmount=YSPayAmount+PayAmountByHT
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		.s YSAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s YSPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.i (YSAmountOnway+YSPayAmount+AmountOnwayByHT)>=TAllAmount  d
		..s DiffAmountOnway=DiffAmountOnway+YSAmountOnway+YSPayAmount+AmountOnwayByHT-TAllAmount
		..s YSAmountOnway=TAllAmount-YSPayAmount
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		.e  d
		..s YSAmountOnway=YSAmountOnway+AmountOnwayByHT
		..s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		/*********按照验收记录的顺序分摊未分摊的已付款和在途付款部分************************/
		s CTLRowID=0
		f  s CTLRowID=$o(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID))  q:CTLRowID=""  d
		.s Flag=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",1)
		.q:Flag=1
		.s YSAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s YSPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.s TAllAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",4)
		.i DiffPayAmount'=0  d
		..i (YSAmountOnway+YSPayAmount+DiffPayAmount)>=TAllAmount  d
		...s DiffPayAmount=YSAmountOnway+YSPayAmount+DiffPayAmount-TAllAmount
		...s YSPayAmount=TAllAmount-YSAmountOnway
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		..e  d
		...s YSPayAmount=YSPayAmount+DiffPayAmount
		...s DiffPayAmount=0
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		.s YSAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s YSPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		.i DiffAmountOnway'=0  d
		..i (YSAmountOnway+YSPayAmount+DiffAmountOnway)>=TAllAmount  d
		...s DiffAmountOnway=YSAmountOnway+YSPayAmount+DiffAmountOnway-TAllAmount
		...s YSAmountOnway=TAllAmount-YSPayAmount
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="1^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		..e  d
		...s YSAmountOnway=YSAmountOnway+DiffAmountOnway
		...s DiffAmountOnway=0
		...s ^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)="0^"_YSAmountOnway_"^"_YSPayAmount_"^"_TAllAmount
		/*****************************************************************************************/
		i OCLSourceType=1  d
		.s CTLRowID=OCLSourceID
		.s TAllAmountOnway=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",2)
		.s TAllPayAmount=$p($g(^DHCEQTemp("PayRecord",$J,SourceType,CTLRowID)),"^",3)
		e  d
		.s ISLRowID=0	//验收单对应入库明细付款记录
		.f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:ISLRowID=""  d
		..s YSAmountOnway=YSAmountOnway+..GetPayOrOnWayAmount("","1",ISLRowID,0)
		..s YSPayAmount=YSPayAmount+..GetPayOrOnWayAmount("","1",ISLRowID,1)
		.s TAllAmountOnway=YSAmountOnway+..GetPayOrOnWayAmount("","3",OCLRowID,0)
		.s TAllPayAmount=YSPayAmount+..GetPayOrOnWayAmount("","3",OCLRowID,1)
	}
	i Type=0 q ##Class(web.DHCEQCommon).FormatNumber(TAllAmountOnway,"")
	i Type=1 q ##Class(web.DHCEQCommon).FormatNumber(TAllPayAmount,"")
	q ##Class(web.DHCEQCommon).FormatNumber(TAllAmountOnway+TAllPayAmount,"")
}

ClassMethod GetHTAllotByCTL(vCTLRowID, Type)
{
	n (vCTLRowID,Type)
	i vCTLRowID="" q 0
	s (HTAmount,AmountOnway,PayAmount)=0
	s CTRowID=$p($g(^DHCEQContractList(vCTLRowID)),"^",1)
	s TAllAmount=$p($g(^DHCEQContractList(vCTLRowID)),"^",8)
	s CTLRowID=0
	f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
	.s MaxRowID=CTLRowID
	.s HTAmount=HTAmount+$p($g(^DHCEQContractList(CTLRowID)),"^",8)
	s HTAmountOnway=..GetPayOrOnWayAmount("","2",CTRowID,0)
	s HTPayAmount=..GetPayOrOnWayAmount("","2",CTRowID,1)
	i vCTLRowID'=MaxRowID  d //检测是否合同明细最后一条记录
	.s CTLAmountOnway=##Class(web.DHCEQCommon).FormatNumber((TAllAmount/HTAmount)*HTAmountOnway,"")
	.s CTLPayAmount=##Class(web.DHCEQCommon).FormatNumber((TAllAmount/HTAmount)*HTPayAmount,"")
	e  d
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
	..q:CTLRowID=MaxRowID
	..s CTLAmount=$p($g(^DHCEQContractList(CTLRowID)),"^",8)
	..s AmountOnway=AmountOnway+##Class(web.DHCEQCommon).FormatNumber((CTLAmount/HTAmount)*HTAmountOnway,"")
	..s PayAmount=PayAmount+##Class(web.DHCEQCommon).FormatNumber((CTLAmount/HTAmount)*HTPayAmount,"")
	.s CTLAmountOnway=HTAmountOnway-AmountOnway
	.s CTLPayAmount=HTPayAmount-PayAmount
	i Type=0 q CTLAmountOnway
	i Type=1 q CTLPayAmount
}

// modify BY GBX   GBX0033

ClassMethod SavePayRecord(val, PRQRowID)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PLIST, PRDLIST
	s RowID=$p(val,"^",1)
	s SourceTypeDR=$p(val,"^",2)
	s SourceID=$p(val,"^",3)
	s PlanID=$p(val,"^",4)
	s CurPayAmount=$p(val,"^",5)
	s InvoiceNo=$p(val,"^",6)
	s PayModeDR=$p(val,"^",7)
	s Remark=$p(val,"^",8)
	s PayType=$p(val,"^",9)	
	s PlanDate=$p(val,"^",10)
	s PlanDate=##Class(web.DHCEQCommon).TransValueFromPage(PlanDate,"date")
	s AllAmount=$p(val,"^",11)
	s ProviderDR=$p(val,"^",12)
	s No=$p(val,"^",13)
	s Item=$p(val,"^",14)
	s EquipTypeDR=$p(val,"^",15)
	s Price=$p(val,"^",16)
	s Num=$p(val,"^",17)
	s CheckNo=$p(val,"^",18)
	//执行保存代码
	s PLIST(3)=PayModeDR
	s PLIST(4)=CurPayAmount
	s PLIST(5)=+$H
	s PLIST(9)=User
	s PLIST(10)=Remark
	s PLIST(16)=SourceTypeDR
	s PLIST(17)=SourceID
	s PLIST(18)=PlanID
	s PLIST(19)="0"
	s PLIST(29)=PayType
	s PLIST(30)="N"
	s PLIST(31)=PlanDate
	s PLIST(32)=CheckNo
	s PRDLIST(2)=SourceTypeDR
	s PRDLIST(3)=SourceID
	s PRDLIST(5)=AllAmount
	s PRDLIST(6)=ProviderDR
	s PRDLIST(7)=No
	s PRDLIST(8)=Item
	s PRDLIST(9)=EquipTypeDR
	s PRDLIST(16)=Price
	s PRDLIST(17)=Num
	//检测付款金额是否正确
	i SourceTypeDR<=3 //验收，入库，合同
	{
		s TAllAmountOnway=..GetAllPayOrOnWayAmount(SourceTypeDR,SourceID,0)
		s TAllPayAmount=..GetAllPayOrOnWayAmount(SourceTypeDR,SourceID,1)
	}
	else
	{
		s TAllAmountOnway=..GetPayOrOnWayAmount("",SourceTypeDR,SourceID,0)
		s TAllPayAmount=..GetPayOrOnWayAmount("",SourceTypeDR,SourceID,1)
	}
	s RemainFee=AllAmount-TAllAmountOnway-TAllPayAmount
	i RowID'="" s RemainFee=RemainFee+$p($g(^DHCEQPayRecord(RowID)),"^",3)
	i RemainFee<CurPayAmount q "-1^最大付款金额"_RemainFee
	TSTART
	i RowID=""
	{
		s PLIST(6)=PRQRowID  //modify BY GBX  GBX0033
		&SQL(Insert Into SQLUSER.DHC_EQPayRecord values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q "-1^"_SQLCODE
		}
		s RowID=$G(%ROWID)
		s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",SourceTypeDR,SourceID,0))
		i PRDRowID=""
		{
			s PRDLIST(4)=0
			s PRDLIST(10)=0
			&SQL(Insert Into SQLUSER.DHC_EQPayRecordDetail values :PRDLIST())
		}
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQPayRecord values :PLIST() Where PR_RowID=:RowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q "-1^"_SQLCODE
	}
	i InvoiceNo'="" //存储发票
	{
		s InvoiceDR=..SaveInvoice(9,RowID,InvoiceNo)
		i InvoiceDR<0
		{
			TROLLBACK
			q "-1^"_InvoiceDR
		}
		;&SQL(Update SQLUSER.DHC_EQPayRecord Set PR_InvoiceDR=:InvoiceDR Where PR_RowID=:RowID)		Mozy0242	2020-01-02	1150896		表结构调整
	}
	i SQLCODE
	{
		TROLLBACK
		q "-1^"_SQLCODE
	}
	&SQL(Update SQLUSER.DHC_EQPayRecordDetail values :PRDLIST() Where PRD_SourceType=:SourceTypeDR and PRD_SourceID=:SourceID)
	i SQLCODE
	{
		TROLLBACK
		q "-1^"_SQLCODE
	}
	TCOMMIT
	q RowID
}

/// w ##Class(web.DHCEQPayRecord).SubmitData(val)
ClassMethod SubmitData(val, CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "", isAudit As %Library.String = "0")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s RowID=$p(val,"^",1)
	s PLIST(19)="1"
	s PLIST(20)=User
	s PLIST(21)=Date
	s PLIST(22)=Time
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("19")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfo(2)=ApproveType
	s AppInfo(3)=RowID
	s AppInfo(4)=ApproveSet
	s AppInfo(5)=NextRole
	s AppInfo(6)=NextStep
	s AppInfo(7)=""			;ApproveStatus  当前审核步骤
	s AppInfo(8)=""			;ApproveRoleDR	
	s AppInfo(9)="1"		;Status
	
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		s AuditFlag=1
		s PLIST(19)="2"		;Status
		s PLIST(23)=User	;AuditUserDR
		s PLIST(24)=Date	;AuditDate
		s PLIST(25)=Time	;AuditTime
		s AppInfo(9)="2"		;Status
	}
	
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))	
	TSTART
	i isAudit="1"
	{
		;编辑要修改的字段
		i editFieldsInfo'=""
		{
			s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
		;执行当前角色要执行的动作
		s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
		i Actions'=""
		{
			s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
	}
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"19",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}
	if ApproveInfoID=""
 	{
	 	&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())		
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)		
 	}
 	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQPayRecord values :PLIST() where PR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//检测该业务单对应付款记录是否都已经全部付款完成
	i AuditFlag=1
	{
		s SourceTypeDR=$p($g(^DHCEQPayRecord(RowID)),"^",15)
		s SourceID=$p($g(^DHCEQPayRecord(RowID)),"^",16)
		s SQLCODE=..CheckPayFinish(RowID,SourceTypeDR,SourceID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q RowID
}

ClassMethod CheckPayFinish(PRRowID, SourceTypeDR, SourceID)
{
	n (PRRowID, SourceTypeDR, SourceID)
	s (SQLCODE,HTAmount)=0
	i PRRowID=""  d
	.i SourceTypeDR=1  d //入库
	..s AllAmount=$p($g(^DHCEQInStockList(SourceID)),"^",7)*$p($g(^DHCEQInStockList(SourceID)),"^",8)
	.i SourceTypeDR=2  d //合同
	..s CTRowID=SourceID
	..s CTLRowID=0
	..f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
	...s AllAmount=AllAmount+$p($g(^DHCEQContractList(CTLRowID)),"^",8)
	.i SourceTypeDR=3  d //验收
	..s AllAmount=$p($g(^DHCEQOpenCheckList(SourceID)),"^",16)*$p($g(^DHCEQOpenCheckList(SourceID)),"^",17)
	i (SourceTypeDR>3)||(PRRowID'="")  d
	.s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",SourceTypeDR,SourceID,0))
	.s AllAmount=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",4)
	
	i SourceTypeDR<=3  d  //验收,入库,合同
	.s TAllPayAmount=..GetAllPayOrOnWayAmount(SourceTypeDR,SourceID,1)
	e  d
	.s TAllPayAmount=..GetPayOrOnWayAmount("",SourceTypeDR,SourceID,1)
	
	i AllAmount=TAllPayAmount  d  //全部付款完成
	.;***************************************************************************************************
	.i SourceTypeDR=1  d //入库
	..s ISLRowID=SourceID
	..s ISLSourceType=$p($g(^DHCEQInStockList(ISLRowID)),"^",18)
	..s ISLSourceID=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
	..i ISLSourceType=2  d //入库来自验收
	...s OCLRowID=ISLSourceID
	...s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	...i $d(^DHCEQPayRecordDetail(0,"SourceID",3,OCLRowID))  d
	....&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=2 Where PRD_SourceType=3 and PRD_SourceID=:OCLRowID)
	...e  d
	....&SQL(Insert Into SQLUSER.DHC_EQPayRecordDetail(PRD_SourceType,PRD_SourceID,PRD_PayNum,PRD_Status) Values(3,:OCLRowID,0,2))
	...i SQLCODE q:SQLCODE
	...&SQL(Update SQLUSER.DHC_EQPayPlan Set PP_PayFlag=1 Where PP_SourceType=2 and PP_SourceID=:OCRRowID)
	...i SQLCODE=100 s SQLCODE=0
	...i SQLCODE q:SQLCODE
	...s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	...s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	...i OCLSourceType=1  d //验收来自合同
	....s CTLRowID=OCLSourceID
	....s CTRowID=$p($g(^DHCEQContractList(CTLRowID)),"^",1)
	....s CTLRowID=0
	....f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
	.....s HTAmount=HTAmount+$p($g(^DHCEQContractList(CTLRowID)),"^",8)
	....s TAllPayAmount=..GetAllPayOrOnWayAmount(2,CTRowID,1)
	....i HTAmount=TAllPayAmount  d  //合同付款完成
	.....i $d(^DHCEQPayRecordDetail(0,"SourceID",2,CTRowID))  d
	......&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=2 Where PRD_SourceType=2 and PRD_SourceID=:CTRowID)
	.....e  d
	......&SQL(Insert Into SQLUSER.DHC_EQPayRecordDetail(PRD_SourceType,PRD_SourceID,PRD_PayNum,PRD_Status) Values(2,:CTRowID,0,2))
	.....i SQLCODE q:SQLCODE
	.....&SQL(Update SQLUSER.DHC_EQPayPlan Set PP_PayFlag=1 Where PP_SourceType=1 and PP_SourceID=:CTRowID)
	.....i SQLCODE=100 s SQLCODE=0
	.;*************************************************************************************************************
	.i SourceTypeDR=2  d //合同
	..s CTRowID=SourceID
	..&SQL(Update SQLUSER.DHC_EQPayPlan Set PP_PayFlag=1 Where PP_SourceType=1 and PP_SourceID=:CTRowID)
	..i SQLCODE=100 s SQLCODE=0
	..i SQLCODE q:SQLCODE
	..s CTLRowID=0
	..f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:(CTLRowID="")||(SQLCODE'=0)  d
	...s OCLRowID=0 //合同对应验收单
	...f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source","1",CTLRowID,OCLRowID))  q:(OCLRowID="")||(SQLCODE'=0)  d
	....s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	....&SQL(Update SQLUSER.DHC_EQPayPlan Set PP_PayFlag=1 Where PP_SourceType=2 and PP_SourceID=:OCRRowID)
	....i SQLCODE=100 s SQLCODE=0
	....i SQLCODE q:SQLCODE
	....i $d(^DHCEQPayRecordDetail(0,"SourceID",3,OCLRowID))  d
	.....&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=2 Where PRD_SourceType=3 and PRD_SourceID=:OCLRowID)
	....e  d
	.....&SQL(Insert Into SQLUSER.DHC_EQPayRecordDetail(PRD_SourceType,PRD_SourceID,PRD_PayNum,PRD_Status) Values(3,:OCLRowID,0,2))
	....i SQLCODE q:SQLCODE
	....s ISLRowID=0 //验收单对应入库单
	....f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:(ISLRowID="")||(SQLCODE'=0)  d
	.....i $d(^DHCEQPayRecordDetail(0,"SourceID",1,ISLRowID))  d
	......&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=2 Where PRD_SourceType=1 and PRD_SourceID=:ISLRowID)
	.....e  d
	......&SQL(Insert Into SQLUSER.DHC_EQPayRecordDetail(PRD_SourceType,PRD_SourceID,PRD_PayNum,PRD_Status) Values(1,:ISLRowID,0,2))
	.;*************************************************************************************************************
	.i SourceTypeDR=3  d //验收
	..s OCLRowID=SourceID
	..s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	..&SQL(Update SQLUSER.DHC_EQPayPlan Set PP_PayFlag=1 Where PP_SourceType=2 and PP_SourceID=:OCRRowID)
	..i SQLCODE=100 s SQLCODE=0
	..i SQLCODE q:SQLCODE
	..s ISLRowID=0  //验收单对应入库单
	..f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:(ISLRowID="")||(SQLCODE'=0)  d
	...i $d(^DHCEQPayRecordDetail(0,"SourceID",1,ISLRowID))  d
	....&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=2 Where PRD_SourceType=1 and PRD_SourceID=:ISLRowID)
	...e  d
	....&SQL(Insert Into SQLUSER.DHC_EQPayRecordDetail(PRD_SourceType,PRD_SourceID,PRD_PayNum,PRD_Status) Values(1,:ISLRowID,0,2))
	..i SQLCODE q:SQLCODE
	..s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	..s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	..i OCLSourceType=1  d //验收来自合同
	...s CTLRowID=OCLSourceID
	...s CTRowID=$p($g(^DHCEQContractList(CTLRowID)),"^",1)
	...s CTLRowID=0
	...f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
	....s HTAmount=HTAmount+$p($g(^DHCEQContractList(CTLRowID)),"^",8)
	...s TAllPayAmount=..GetAllPayOrOnWayAmount(2,CTRowID,1)
	...i HTAmount=TAllPayAmount  d  //合同付款完成
	....i $d(^DHCEQPayRecordDetail(0,"SourceID",2,CTRowID))  d
	.....&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=2 Where PRD_SourceType=2 and PRD_SourceID=:CTRowID)
	....e  d
	.....&SQL(Insert Into SQLUSER.DHC_EQPayRecordDetail(PRD_SourceType,PRD_SourceID,PRD_PayNum,PRD_Status) Values(2,:CTRowID,0,2))
	....i SQLCODE q:SQLCODE
	....&SQL(Update SQLUSER.DHC_EQPayPlan Set PP_PayFlag=1 Where PP_SourceType=1 and PP_SourceID=:CTRowID)
	....i SQLCODE=100 s SQLCODE=0
	.;*************************************************************************************************************
	.i SQLCODE q:SQLCODE
	.i $d(^DHCEQPayRecordDetail(0,"SourceID",SourceTypeDR,SourceID))  d
	..i PRRowID="" d
	...&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=2 Where PRD_SourceType=:SourceTypeDR and PRD_SourceID=:SourceID)
	..e  d
	...&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=2,PRD_PayNum=PRD_PayNum+1 Where PRD_SourceType=:SourceTypeDR and PRD_SourceID=:SourceID)
	.e  d
	..&SQL(Insert Into SQLUSER.DHC_EQPayRecordDetail(PRD_SourceType,PRD_SourceID,PRD_PayNum,PRD_Status) Values(:SourceTypeDR,:SourceID,0,2))
	e  d  //部分付款完成
	.i PRRowID'=""  d
	..s PPRowID=$p($g(^DHCEQPayRecord(PRRowID)),"^",17)
	..i PPRowID'="" s PPAmount=$p($g(^DHCEQPayPlan(PPRowID)),"^",10)
	..i ((SourceTypeDR=2)||(SourceTypeDR=3))&&(PPRowID'="")  d //合同,验收对应计划
	...s PayAmount=..GetPayOrOnWayAmount(PPRowID,SourceTypeDR,SourceID,1)
	...i PPAmount=PayAmount  d
	....&SQL(Update SQLUSER.DHC_EQPayPlan Set PP_PayFlag=1 Where PP_RowID=:PPRowID)
	...e  d
	....&SQL(Update SQLUSER.DHC_EQPayPlan Set PP_PayFlag=2 Where PP_RowID=:PPRowID)
	..i SQLCODE q:SQLCODE
	..&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status=1 Where PRD_SourceType=:SourceTypeDR and PRD_SourceID=:SourceID)
	q SQLCODE
}

ClassMethod DeletePayRecord(val)
{
	k PLIST
	s PRRowID=$p(val,"^",1)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s SourceType=$p($g(^DHCEQPayRecord(PRRowID)),"^",15)
	s SourceID=$p($g(^DHCEQPayRecord(PRRowID)),"^",16)
	s InvoiceDR=$p($g(^DHCEQPayRecord(PRRowID)),"^",1)
	s SQLCODE=0
	TSTART
	//删除发票
	i InvoiceDR'=""  d
	.s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",9,InvoiceDR,SourceID,0))
	.i IUMRowID'=""  d //删除发票对应业务单关系
	..&SQL(Delete From SQLUSER.DHC_EQInvoiceUseMap Where IUM_RowID=:IUMRowID)
	..i SQLCODE q:SQLCODE
	..s Find=$o(^DHCEQInvoiceUseMap(0,"Invoice",InvoiceDR,0))
	..i Find=""  d //无其他业务单对应时删除发票
	...&SQL(Update SQLUSER.DHC_EQInvoice Set IV_InvalidFlag='Y' Where IV_RowID=:InvoiceDR)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//删除DHCEQPayRecord
	s PLIST(19)="3"
	s PLIST(26)=User
	s PLIST(27)=Date
	s PLIST(28)=Time
	s PLIST(30)="Y"
	&SQL(Update SQLUSER.DHC_EQPayRecord values :PLIST() Where PR_RowID=:PRRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q PRRowID
}

ClassMethod CancelSubmit(val)
{
	Set $ZT="ERRORCancel"
	k PLIST,AppInfo
	s RowID=$P(val,"^",1)
	s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("19",RowID)
	i ApproveInfo'="" s CancelToFlowDR=$P(ApproveInfo,"^",8)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s PLIST(19) = "0"
	s PLIST(26) = User //$p(val,"^",5)	;MakerDR
 	s PLIST(27) = Date
 	s PLIST(28) = Time
	TSTART
	if (CancelToFlowDR'="")
	{
		s PLIST(19)="1"
	 	s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
	 	s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s AppInfo(5)=ApproveRoleDR
		s AppInfo(6)=Step
	}
	else
	{
		s AppInfo(5)=""
		s AppInfo(6)=""
	}
	s AppInfo(7)=""
	s AppInfo(8)=""
	s AppInfo(9)=""	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("19")
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))		
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQPayRecord values :PLIST() where PR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

ClassMethod SaveInvoice(SourceType, SourceID, InvoiceNo)
{
	n (SourceType,SourceID,InvoiceNo)
	i InvoiceNo="" q ""
	k PLIST
	s SQLCODE=0
	s ProviderDR=""
	i SourceType=9  //付款
	{
		s PRRowID=SourceID
		s PRSourceType=$p($g(^DHCEQPayRecord(PRRowID)),"^",15)
		s PRSourceID=$p($g(^DHCEQPayRecord(PRRowID)),"^",16)
		s InvoiceDR=$p($g(^DHCEQPayRecord(PRRowID)),"^",1)
		s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",PRSourceType,PRSourceID,0))
		s ProviderDR=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",5)
	}
	s ID=0
	s IVRowID=0
	f  s IVRowID=$o(^DHCEQInvoice(0,"InvoiceNo",InvoiceNo,IVRowID))  q:(IVRowID="")||(ID'=0)  d
	.s IVProvider=$p($g(^DHCEQInvoice(IVRowID)),"^",5)
	.q:(ProviderDR'="")&&(IVProvider'=ProviderDR)
	.i (ProviderDR'="") s ID=IVRowID
	.i (IVProvider="") s ID=IVRowID
	i ID=0 //发票不存在时新增
	{
		s PLIST(3)=InvoiceNo
		s PLIST(6)=ProviderDR
		s PLIST(11)="0"
		s PLIST(17)="N"
		&SQL(Insert Into SQLUSER.DHC_EQInvoice Values :PLIST())
		s ID=$G(%ROWID)
	}
	i SQLCODE q SQLCODE
	i InvoiceDR'=""
	{
		i InvoiceDR'=ID //发票号码发生变更
		{
			s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",SourceType,InvoiceDR,SourceID,0))
			&SQL(Update SQLUSER.DHC_EQInvoiceUseMap Set IUM_InvoiceDR=:ID Where IUM_RowID=:IUMRowID)
		}
	}
	i SQLCODE q SQLCODE
	s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",SourceType,ID,SourceID,0))
	i IUMRowID="" //发票对应业务关系不存在
	{
		&SQL(Insert Into SQLUSER.DHC_EQInvoiceUseMap(IUM_Type,IUM_SourceID,IUM_InvoiceDR) Values(:SourceType,:SourceID,:ID))
	}
	i SQLCODE q SQLCODE
	q ID
}

ClassMethod DeleteInvoice(SourceType, SourceID, InvoiceDR)
{
	n (SourceType,SourceID,InvoiceDR)
	s SQLCODE=0
	s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",SourceType,InvoiceDR,SourceID,0)) //删除发票业务关联关系
	i IUMRowID'=""
	{
		&SQL(Delete From SQLUSER.DHC_EQInvoiceUseMap Where IUM_RowID=:IUMRowID)
	}
	i SQLCODE q SQLCODE
	i '$d(^DHCEQInvoiceUseMap(0,"Invoice",InvoiceDR))  //发票无任何业务关联时删除
	{
		&SQL(Update SQLUSER.DHC_EQInvoice Set IV_InvalidFlag='Y' Where IV_RowID=:InvoiceDR)
	}
	q SQLCODE
}

/************************************************************************/
/// 2014-7-18 HZY HZY0056
/// ##class(web.DHCEQPayRecord).GetPayNo("1",TInStockListDR) 
ClassMethod GetPayNo(SourceType, SourceID)
{
	n PayNos,PRRowID,payNo
	s PayNos=""
	i ((""=SourceType)||(""=SourceID))
	{
		q ""	
	}else{
		s PRRowID=0
		f  s PRRowID=$o(^DHCEQPayRecord(0,"Source",SourceType,SourceID,PRRowID)) q:(""=PRRowID)  d
		.q:("Y"=$p($g(^DHCEQPayRecord(PRRowID)),"^",29))	//InvalidFlag
		.s payNo=$p($g(^DHCEQPayRecord(PRRowID)),"^",5)
		.i ""=PayNos d
		..s PayNos=payNo
		.e  d
		..s PayNos=PayNos_","_payNo
	}
	q PayNos
}

// modify BY GBX  GBX0033

ClassMethod KillTempGloble(Job)
{
	i Job="" d
	.s Job=$j
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("PayRequestInfo",0,User,Job)
	k ^DHCEQTemp("PayRequestCollect",0,User,Job)
}

// add BY GBX 2015-2-2 14:52:59  GBX0033

// 汇总更新的付款信息

// d ##Class(web.DHCEQPayRecord).GetPayRequestInfo()

ClassMethod GetPayRequestInfo(val, Job, Num)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s ProviderDR=$p(val,"^",12)
	q:(ProviderDR="")
	s EquipTypeDR=$p(val,"^",15)
	q:(EquipTypeDR="")
	s ^DHCEQTemp("PayRequestInfo",0,User,Job,Num)=val
	i $d(^DHCEQTemp("PayRequestCollect",0,User,Job,ProviderDR,EquipTypeDR))  d
	.s ^DHCEQTemp("PayRequestCollect",0,User,Job,ProviderDR,EquipTypeDR)=$g(^DHCEQTemp("PayRequestCollect",0,User,Job,ProviderDR,EquipTypeDR))_"^"_Num
	e  d
	.s ^DHCEQTemp("PayRequestCollect",0,User,Job,ProviderDR,EquipTypeDR)=Num
}

// add by GBX 2015-2-2 15:39:15 存储供应商汇总付款单  GBX0033

// d ##Class(web.DHCEQPayRecord).SavePayRequest(3008)

ClassMethod SavePayRequest(Job)
{
	if Job="" q "-1"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s PRQRowID=0
	;s (EquipTypeIDs,RowID)=""
	s SQLCODE=0
	TSTART
	s ProviderDR=0
	f  s ProviderDR=$o(^DHCEQTemp("PayRequestCollect",0,User,Job,ProviderDR)) q:(ProviderDR="")||(SQLCODE'=0)  d
	.s (EquipTypeIDs,RowID,Nums,Len,CurNum,Info)=""
	.s EquipTypeID=0
	.f  s EquipTypeID=$o(^DHCEQTemp("PayRequestCollect",0,User,Job,ProviderDR,EquipTypeID)) q:(EquipTypeID="")||(SQLCODE'=0)  d
	..s EquipTypeIDs=EquipTypeIDs_","_EquipTypeID
	.d savepayrequest
	.q:SQLCODE'=0
	.s PRQRowID=ID
	.s EquipTypeID=0
	.f  s EquipTypeID=$o(^DHCEQTemp("PayRequestCollect",0,User,Job,ProviderDR,EquipTypeID)) q:(EquipTypeID="")||(SQLCODE'=0)  d
	..s Nums= $g(^DHCEQTemp("PayRequestCollect",0,User,Job,ProviderDR,EquipTypeID))
	..s Len=$l(Nums,"^")
	..f i=1:1:Len  d
	...q:SQLCODE'=0
	...s CurNum=$p(Nums,"^",i)
	...s Info=$g(^DHCEQTemp("PayRequestInfo",0,User,Job,CurNum))
	...s Result=..SavePayRecord(Info,PRQRowID)
	...s Result=$p(Result,"^",1)
	...i Result=-1  d
	....s SQLCODE=Result
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
 	q PRQRowID
savepayrequest
	k PRTLIST
	s RowID=""
	s ID=""
	s PRTLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQPayRecord",+$H)
	s PRTLIST(3)=ProviderDR
	s PRTLIST(4)=EquipTypeIDs
	s PRTLIST(5)="0"
	s PRTLIST(7)=User
	s PRTLIST(8)=Date
	s PRTLIST(9)=Time
	&SQL(Insert Into SQLUSER.DHC_EQPayRequest values :PRTLIST())
	s ID=$G(%ROWID)
	i SQLCODE
	{
		q SQLCODE
	}
	quit
}

ClassMethod SubmitRequest(val, CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "", isAudit As %Library.String = "0")
{
	
	k PLIST
	k PRLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s RowID=$p(val,"^",1)
	
	s PLIST(5)="1"
	s PLIST(10)=User
	s PLIST(11)=Date
	s PLIST(12)=Time
	
	s PRLIST(19)="1"
	s PRLIST(20)=User
	s PRLIST(21)=Date
	s PRLIST(22)=Time
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("19")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfo(2)=ApproveType
	s AppInfo(3)=RowID
	s AppInfo(4)=ApproveSet
	s AppInfo(5)=NextRole
	s AppInfo(6)=NextStep
	s AppInfo(7)=""			;ApproveStatus  当前审核步骤
	s AppInfo(8)=""			;ApproveRoleDR	
	s AppInfo(9)="1"		;Status
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		s AuditFlag=1
		s PLIST(5)="2"		;Status
		s PLIST(16)=User	;AuditUserDR
		s PLIST(17)=Date	;AuditDate
		s PLIST(18)=Time	;AuditTime
		s AppInfo(9)="2"		;Status
		
		s PRLIST(19)="2"		;Status
		s PRLIST(23)=User	;AuditUserDR
		s PRLIST(24)=Date	;AuditDate
		s PRLIST(25)=Time	;AuditTime
	}
	
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))	
	TSTART
	i isAudit="1"
	{
		;编辑要修改的字段
		i editFieldsInfo'=""
		{
			s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
		;执行当前角色要执行的动作
		s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
		i Actions'=""
		{
			s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
	}
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"19")
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}
	if ApproveInfoID=""
 	{
	 	&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())		
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)		
 	}
 	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQPayRequest values :PLIST() where PR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//Mozy0242	2020-01-02	1150896		表结构调整
	&SQL(update sqluser.DHC_EQPayRecord values :PRLIST() where PR_PayRequestDR=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//检测该业务单对应付款记录是否都已经全部付款完成
	i AuditFlag=1
	{
		s (PayRecordIDs,Len,PayRecordID)=""
		s PayRecordIDs=..GetRequestInfo(RowID)
		s Len=$L(PayRecordIDs,",")
		f i=1:1:Len  d
		.s PayRecordID=$p(PayRecordIDs,",",i)
		.s SourceTypeDR=$p($g(^DHCEQPayRecord(PayRecordID)),"^",15)
		.s SourceID=$p($g(^DHCEQPayRecord(PayRecordID)),"^",16)
		.s SQLCODE=..CheckPayFinish(PayRecordID,SourceTypeDR,SourceID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q RowID
}

// 取消提交

ClassMethod CancelRequestSubmit(val)
{
	
	;Set $ZT="ERRORCancel"
	k PLIST,AppInfo,PRList
	s RowID=$P(val,"^",1)
	s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("19",RowID)
	i ApproveInfo'="" s CancelToFlowDR=$P(ApproveInfo,"^",8)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	
	s PLIST(19) = "0"
	s PLIST(26) = User //$p(val,"^",5)	;MakerDR
 	s PLIST(27) = Date
 	s PLIST(28) = Time
	
	s PRLIST(5) = "0"
	s PRLIST(13) = User
 	s PRLIST(14) = Date
 	s PRLIST(15) = Time
 	
	TSTART
	if (CancelToFlowDR'="")
	{
		s PLIST(19)="1"
	 	s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
	 	s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s AppInfo(5)=ApproveRoleDR
		s AppInfo(6)=Step
	}
	else
	{
		s AppInfo(5)=""
		s AppInfo(6)=""
	}
	s AppInfo(7)=""
	s AppInfo(8)=""
	s AppInfo(9)=""	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("19")
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))		
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQPayRequest values :PRLIST() where PR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//Mozy0242	2020-01-02	1150896		表结构调整
	&SQL(update sqluser.DHC_EQPayRecord values :PLIST() where PR_PayRequestDR=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
}

// 删除操作  GBX0033

// add BY GBX 2015-2-3 21:18:27

ClassMethod DeletePayRequest(val)
{
	k PLIST
	s PRRowID=$p(val,"^",1)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s SQLCODE=0
	TSTART
	
	s PRLIST(5) = "3"
	s PRLIST(13) = User
 	s PRLIST(14) = Date
 	s PRLIST(15) = Time
	s PRLIST(19)="Y"
	&SQL(Update SQLUSER.DHC_EQPayRequest values :PRLIST() Where PR_RowID=:PRRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//删除明细单和发票信息
	s (PayRecordIDs,Len,PayRecordID)=""
	s PayRecordIDs=..GetRequestInfo(PRRowID)
	s Len=$L(PayRecordIDs,",")
	f i=1:1:Len  d
	.s PayRecordID=$p(PayRecordIDs,",",i)
	.s SQLCODE=..DeletePayRecord(PayRecordID)
	i (SQLCODE<0)
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q PRRowID
}

// 获取总单下所有明细单ID 

// modify BY:GBX 2015年2月3日21:17:54 GBX0033

ClassMethod GetRequestInfo(RowID)
{
	s PayRequestIDs=""
	s PRCRowID=0
	f  s PRCRowID=$o(^DHCEQPayRecord(PRCRowID))  q:PRCRowID=""  d
	.q:($p($g(^DHCEQPayRecord(PRCRowID)),"^",29)="Y")
	.q:($p($g(^DHCEQPayRecord(PRCRowID)),"^",18)=3)
	.s TPayRequestDR=$p($g(^DHCEQPayRecord(PRCRowID)),"^",5)
	.q:(TPayRequestDR="")
	.q:(TPayRequestDR'="")&&(TPayRequestDR'=RowID)
	.i PayRequestIDs'="" d
	..s PayRequestIDs=PayRequestIDs_","_PRCRowID
	.e  d
	..s PayRequestIDs=PRCRowID
	q PayRequestIDs
}

/*************************************************************************/
Storage Default
{
<Data name="DHCEQPayRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQPayRecordD</DataLocation>
<DefaultData>DHCEQPayRecordDefaultData</DefaultData>
<IdLocation>^web.DHCEQPayRecordD</IdLocation>
<IndexLocation>^web.DHCEQPayRecordI</IndexLocation>
<StreamLocation>^web.DHCEQPayRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
