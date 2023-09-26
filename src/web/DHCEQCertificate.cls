/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:凭证信息管理
/// --------------------------------
Class web.DHCEQCertificate Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据凭证号查询
/// --------------------------------
Query GetCertificate(Certificate) As %Query(ROWSPEC = "TNo:%String,Hidden:%String,TCode:%String,TDate:%String,TCertificateFee:%String")
{
}

ClassMethod GetCertificateExecute(ByRef qHandle As %Binary, Certificate) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Certificate=$ZCONVERT(Certificate,"U")
	d BuildDataGetCertificate
	Quit $$$OK
BuildDataGetCertificate
	s rowid=0
	f  s rowid=$o(^DHCEQCertificate(rowid)) q:rowid=""  d
	.d ResetVariablesGetCertificate
	.s TRowID=rowid
	.s TType=$p($g(^DHCEQCertificate(rowid)),"^",1)
	.s TNo=$p($g(^DHCEQCertificate(rowid)),"^",2)
	.q:(Certificate'="")&($ZCONVERT(TNo,"U")'[Certificate)
	.s TDate=$p($g(^DHCEQCertificate(rowid)),"^",3)
	.i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	.s TCertificateFee=$p($g(^DHCEQCertificate(rowid)),"^",5)
	.d OutputRowGetCertificate
	quit
OutputRowGetCertificate
	s Data=$lb(TNo,TRowID,TCode,TDate,TCertificateFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCertificate
	s (TRowID,TCode,TNo,TDate,TCertificateFee)=""
	quit
}

ClassMethod GetCertificateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCertificateExecute ]
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

ClassMethod GetCertificateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCertificateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据凭证rowid取凭证信息
/// --------------------------------
/// w ##Class(web.DHCEQInvoice).GetOneInvoiceInfo("1")
ClassMethod GetOneCertificateByID(rowid)
{
	new result,ApproveRole
	s (result,resultex)=""
	s result=^DHCEQCertificate(rowid)
	s resultex=resultex_"^"	;date
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"date")
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:修改、删除、添加凭证
/// --------------------------------
/// w ##Class(web.DHCEQCertificate).SaveDate("8^^8888^21/04/2010^1^2000^",0)
ClassMethod SaveDate(Val, Type)
{
	new (Val, Type)
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERROR"
	s RowID=$P(Val,"^",1)	;InvoiceNoDR
	TSTART
	i +Type=0
	{
		s PLIST(2)=$P(Val,"^",2)	;Type
		s PLIST(3)=$P(Val,"^",3)	;No
		s PLIST(4)=##Class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",4),"date")	;Date
		s PLIST(5)=$P(Val,"^",5)	;UserDR
		s PLIST(6)=$P(Val,"^",6)	;Fee
		s PLIST(7)=$P(Val,"^",7)	;Remark
		b //
		if RowID=""
		{
			&SQL(insert into sqluser.DHC_EQCertificate values :PLIST())
			s RowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQCertificate values :PLIST() where C_RowID=:RowID)
		}
		b //
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		&SQL(Delete from sqluser.DHC_EQCertificate  where C_RowID=:RowID)
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

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据凭证取相关联的支付信息
/// --------------------------------
Query GetPayRecordByCert(RowID) As %Query(ROWSPEC = "TRowID:%String,TInvoiceDR:%String,TInvoiceNo:%String,TPayFee:%String,TPayNo:%String")
{
}

ClassMethod GetPayRecordByCertExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	d BuildDataGetPayRecordByCert
	Quit $$$OK
BuildDataGetPayRecordByCert
	q:RowID=""
	s PRRowID=0
	for  s PRRowID=$o(^DHCEQPayRecord(0,"Certificate",RowID,PRRowID)) q:PRRowID=""  d
	.d ResetVariablesGetPayRecordByCert
	.s TRowID=PRRowID
	.s TInvoiceDR=$p($g(^DHCEQPayRecord(PRRowID)),"^",1)
	.i TInvoiceDR'="" s TInvoiceNo=$p($g(^DHCEQInvoice(TInvoiceDR)),"^",2)
	.s TPayFee=$p($g(^DHCEQPayRecord(PRRowID)),"^",3)
	.s TPayNo=$p($g(^DHCEQPayRecord(PRRowID)),"^",5)
	.d OutputRowGetPayRecordByCert
	quit
OutputRowGetPayRecordByCert
	s Data=$lb(TRowID,TInvoiceDR,TInvoiceNo,TPayFee,TPayNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPayRecordByCert
	s (TRowID,TInvoiceDR,TInvoiceNo,TPayFee,TPayNo)=""
	quit
}

ClassMethod GetPayRecordByCertFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRecordByCertExecute ]
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

ClassMethod GetPayRecordByCertClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRecordByCertExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据凭证号查询与当前凭证相关联的支付信息有几条,一条时可以直接修改信息
/// --------------------------------
/// w ##Class(web.DHCEQCertificate).CheckCertificateNo("3455")
ClassMethod CheckCertificateNo(CertificateNo)
{
	new (CertificateNo)
	s Flag=0
	s RowID=""
	s CertificateNo=$ZCONVERT(CertificateNo,"U")
	&SQL(select COUNT(C_RowID) into :Total from sqluser.DHC_EQCertificate where C_CertificateNo=:CertificateNo)
	if Total=1
	{
		&SQL(select C_RowID into :RowID from sqluser.DHC_EQCertificate where C_CertificateNo=:CertificateNo)
		if RowID'="" s Flag=1
	}
	q Flag_"^"_RowID
}

/// 创建:ZY 2009-10-26  zy0013
/// 目的:系统自动录入凭证号
/// 描述:检测凭证号表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:凭证号
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQCertificate).UpdCertificate("ddddddddddd")
ClassMethod UpdCertificate(data)
{
	n cfrowid,CertificateOperMethod,Certificate,date,user
	s cfrowid=""
	s date=$h
	s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s SQLCODE=0
	s CertificateOperMethod=2
	;##class(web.DHCEQCommon).GetSysInfo("201005")
	if (CertificateOperMethod=0)||(data="") q ""
	&SQL(Select C_RowID Into:cfrowid from SQLUSER.DHC_EQCertificate Where C_CertificateNo=:desc)
	if cfrowid="" //新增当前凭证号
	{
		;Modified by JDL 2012-3-20 JDL0124
		&SQL(Insert Into SQLUSER.DHC_EQCertificate(C_CertificateNo,C_CertificateDate,C_CertificateUserDR) Values(:data,:date,:user))
		if SQLCODE
		{
			q SQLCODE
		}
		s cfrowid=$G(%ROWID)
	}
	q cfrowid
}

Storage Default
{
<Data name="DHCEQCertificateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCertificateD</DataLocation>
<DefaultData>DHCEQCertificateDefaultData</DefaultData>
<IdLocation>^web.DHCEQCertificateD</IdLocation>
<IndexLocation>^web.DHCEQCertificateI</IndexLocation>
<StreamLocation>^web.DHCEQCertificateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
