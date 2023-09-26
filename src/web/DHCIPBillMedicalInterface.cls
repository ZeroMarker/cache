Import SQLUser

Class web.DHCIPBillMedicalInterface Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator:黄杰
/// time:2015-08-27
/// function:向病案收费发票表、发票明细表和集中打印发票表插入值以及退费操作
/// Table：DHC_InvprtMedical DHC_InvprtMedicalSub DHC_AccPayInvMedical
ClassMethod InsertMedical(PrtInfo, PrtsubInfo, HospID As %String = "")
{
	
	;w ##class(web.DHCIPBillMedicalInterface).InsertMedical("531^20^1^639^P^1","10^10$11^1$12^2")
	//发票表中插入信息
	Set $ZT="ERROR"	   //设置一个异常	       
	TSTART			   //开始事务	
		
	kill PLIST
	set PRTINVPrintFlag=$p(PrtInfo,"^",5)
	set PRTUser = $p(PrtInfo,"^",4)
	set GroupDr = $p(PrtInfo,"^",7)
	//判断是否打印发票 ,票据打印标志不明确：如果打印，插入发票号并且更新当前发票号，如果打印，发票号字段为空
	if PRTINVPrintFlag="P" do
	.set str=##class(web.udhcOPBill).ReadReceiptNO(PRTUser) //调用门诊显示当前发票号方法传入发票号
	.set PLIST(4)=$p(str,"^",2)   		//PRT_inv
	.set rcpno=$p(str,"^",2)+1
	.set rtn=##class(web.udhcOPBill).UpdateReceipNO(PRTUser,rcpno,GroupDr,"F",1) //更新当前发票号
	
	set PLIST(2)=$p(PrtInfo,"^",1)   	//PRT_PAPMI_DR
	set PLIST(3)=$p(PrtInfo,"^",2)    	//PRT_Acount
	set PLIST(5)=+$h    				//PRT_Date
	set PLIST(6)=$p($h,",",2)    		//PRT_Time
	set PLIST(7)="N"    				//PRT_Flag
	set PLIST(8)=$p(PrtInfo,"^",3)		//PRT_PayMode_Dr
	//set PLIST(14)=""					//PRT_PatType
	set PLIST(15)=$p(PrtInfo,"^",4)     //PRT_Usr
	//set PLIST(16)=""					//PRT_SocialStatus
	set PLIST(17)=PRTINVPrintFlag     	//PRT_INVPrintFlag
	//set PLIST(22)=""					//PRT_InsType_DR
	set PLIST(35)=$p(PrtInfo,"^",6)   	//PRT_UserLoc_dr
	//set PLIST(35)=""		//PRT_Medical_DR
	
			
	s rtn=..InvprtMedicalInsert()
	s err=$p(rtn,"^",1)
	s PrtRowID=$p(rtn,"^",2)

	//发票明细表中插入信息
	if err=0 d
	.s number=$L(PrtsubInfo,"$")
	.for i=1:1:number  do  quit:err'=0
	..set Info=$p(PrtsubInfo,"$",i)
	..set PRTSubItmDr=$p(Info,"^",1)
	..set PRTSubPrice=##class(web.UDHCJFPRICE).GetItmPrice(PRTSubItmDr,+$h,"","","",HospID,"")
	..set PRTSubPrice=$p(PRTSubPrice,"^",4)
	..set PRTSubQty=$p(Info,"^",2)
	..set PRTSubAcount=PRTSubPrice*PRTSubQty
	
	..kill PLIST
	..set PLIST(0)=PrtRowID
	..set PLIST(3)=PRTSubItmDr
	..set PLIST(4)=PRTSubPrice
	..set PLIST(5)=PRTSubQty
	..set PLIST(6)=PRTSubAcount
	..s rtn=..InvprtMedicalSubInsert()
	..s err=rtn
	
	if err=0 do
	.TCOMMIT		//没有发生异常，提交事务
	else  do
	.TROLLBACK
	       
	quit PrtRowID	          

ERROR				//发生异常时执行
	Set ErrorMsg=$ZE
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg
}

ClassMethod InsertAcc(PrtRowID)
{
	;w ##class(web.DHCIPBillMedicalInterface).InsertAcc("68")

	kill PLIST	
	set PLIST(2)=$p(AccInfo,"^",1) 		//API_Amount
	set PLIST(3)=$p(AccInfo,"^",2) 		//API_Flag
	set PLIST(4)=+$h    				//API_Date
	set PLIST(5)=$p($h,",",2)    		//API_Time
	set PLIST(6)=$p(AccInfo,"^",3) 		//API_PUser_DR
	set PLIST(7)=$p(AccInfo,"^",4) 		//API_InvNo
	set PLIST(11)=$p(AccInfo,"^",5) 	//API_PayINV_DR
	set PLIST(12)=$p(AccInfo,"^",6) 	//API_PAPMI_DR
			
	&sql(INSERT INTO DHC_AccPayInvMedical Values PLIST())
	
	quit SQLCODE
}

ClassMethod Refund(inv, user)
{
	
	;w ##class(web.DHCIPBillMedicalInterface).Refund("2960","457")
	;退费操作
	Set $ZT="ERROR1"	   //设置一个异常	       
	TSTART			   	   //开始事务
	
	//根据inv获取病案发票表的Rowid
	set PRTRowid=""
	set PRTRowid=$o(^DHCINVPRTMEDICAL(0,"INV",inv,PRTRowid))
	
	kill PLIST
	set PLIST(7)="S"
	
	set rtn=..InvprtMedicalUpdate(PRTRowid)
	set err=rtn
	if err=0 do
	.kill PLIST
	.&sql(SELECT * INTO PLIST() FROM DHC_InvprtMedical WHERE PRT_RowId= :PRTRowid)
	.set PLIST(3)=-PLIST(3)			//PRT_Acount
	.set PLIST(4)=""				//PRT_inv
	.set PLIST(5)=+$h    			//PRT_Date
	.set PLIST(6)=$p($h,",",2)    	//PRT_Time
	.set PLIST(7)="S"				//PRT_Flag
	.set PLIST(13)=PRTRowid			//PRT_initInv_DR
	.set PLIST(15)=user			
	set rtn=..InvprtMedicalInsert()
	set err=$p(rtn,"^",1)
	set prtrowid=$p(rtn,"^",2)
	
	
	if err=0 do
	.kill PLIST
	.set PRTSub="0"
	.for  set PRTSub=$o(^DHCINVPRTMEDICAL(PRTRowid,"P",PRTSub))  quit:PRTSub=""  do
	..kill PLIST	
	..&sql(SELECT * INTO PLIST() FROM DHC_InvprtMedicalSub WHERE PRTSub_Prt_Parref= :PRTRowid AND PRTSub_ChildSub= :PRTSub)
	..set PLIST(0)=prtrowid
	..set PLIST(5)=-PLIST(5)
	..set PLIST(6)=-PLIST(6)
	..set rtn=..InvprtMedicalSubInsert()
	..set err=rtn	
	
	
	if err=0 do
	.TCOMMIT		//没有发生异常，提交事务
	else  do
	.TROLLBACK
			       
	quit err	          

ERROR1				//发生异常时执行
	Set ErrorMsg=$ZE
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg
}

ClassMethod InvprtMedicalSelect(RowId, ByRef PLIST)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_InvprtMedical WHERE PRT_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
 
	q SQLCODE
}

ClassMethod InvprtMedicalSubSelect(RowId, ByRef PLIST)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_InvprtMedicalSub  WHERE PRTSub_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
 
	q SQLCODE
}

ClassMethod InvprtMedicalInsert()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_InvprtMedical Values PLIST())
	d ..tc()
	;
	i 'SQLCODE q SQLCODE_"^"_$g(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod InvprtMedicalSubInsert()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_InvprtMedicalSub Values PLIST())
	d ..tc()
	;
	i 'SQLCODE q ..InvprtMedicalSubSelect(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod InvprtMedicalUpdate(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_InvprtMedical VALUES PLIST() WHERE PRT_RowId= :RowId)
	d ..tc()
	;
	i 'SQLCODE q ..InvprtMedicalSelect(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod tb()
{
   n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
    n SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
