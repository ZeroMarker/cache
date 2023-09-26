/// 系统参数
Class web.DHCREAGSysPara Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

/// Creator：      huhm
/// CreatDate：    20100507
/// Description:： 发票查询
/// Table：       
/// Input：        0:入库单,1:领用单,2:出库单,3:退货单,4:报损单,5:请领单
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod GetEpisode(Type As %String) As %String
{
	s RetValue=""
	If Type="0"{
		s Pre="RK"
		s date=$e($zd(+$h,8),1,6)
		s count=1
		i $d(^DHCREAGEPIS(Type,date))
		{
			s count=+^DHCREAGEPIS(Type,date)
		}
		s ^DHCREAGEPIS(Type,date)=count+1
		s RetValue=Pre_date_$tr($j(count,4)," ","0")
	}
	If Type="1"{
		s Pre="LY"
		s date=$e($zd(+$h,8),1,6)
		s count=1
		i $d(^DHCREAGEPIS(Type,date))
		{
			s count=+^DHCREAGEPIS(Type,date)
		}
		s ^DHCREAGEPIS(Type,date)=count+1
		s RetValue=Pre_date_$tr($j(count,4)," ","0")
	}
	If Type="2"{
		s Pre="CK"
		s date=$e($zd(+$h,8),1,6)
		s count=1
		i $d(^DHCREAGEPIS(Type,date))
		{
			s count=+^DHCREAGEPIS(Type,date)
		}
		s ^DHCREAGEPIS(Type,date)=count+1
		s RetValue=Pre_date_$tr($j(count,4)," ","0")
	}
	If Type="3"{
		s Pre="TH"
		s date=$e($zd(+$h,8),1,6)
		s count=1
		i $d(^DHCREAGEPIS(Type,date))
		{
			s count=+^DHCREAGEPIS(Type,date)
		}
		s ^DHCREAGEPIS(Type,date)=count+1
		s RetValue=Pre_date_$tr($j(count,4)," ","0")
	}
	If Type="4"{
		s Pre="BS"
		s date=$e($zd(+$h,8),1,6)
		s count=1
		i $d(^DHCREAGEPIS(Type,date))
		{
			s count=+^DHCREAGEPIS(Type,date)
		}
		s ^DHCREAGEPIS(Type,date)=count+1
		s RetValue=Pre_date_$tr($j(count,4)," ","0")
	}
	If Type="5"{
		s Pre="QL"
		s date=$e($zd(+$h,8),1,6)
		s count=1
		i $d(^DHCREAGEPIS(Type,date))
		{
			s count=+^DHCREAGEPIS(Type,date)
		}
		s ^DHCREAGEPIS(Type,date)=count+1
		s RetValue=Pre_date_$tr($j(count,4)," ","0")
	}
	//自动出库
	If Type="6"{
		s Pre="ZK"
		s date=$e($zd(+$h,8),1,6)
		s count=1
		i $d(^DHCREAGEPIS(Type,date))
		{
			s count=+^DHCREAGEPIS(Type,date)
		}
		s ^DHCREAGEPIS(Type,date)=count+1
		s RetValue=Pre_date_$tr($j(count,4)," ","0")
	}
	Quit RetValue
}

/// Creator：      huhm
/// CreatDate：    20100818
/// Description:： 取得系统默认值
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod GetDefaultParam(code As %String) As %String
{
	s RetStr=""
	//^lab.DHCCTSYSParameterD(1)=<<$LB("","1","2","","","","","","")>>
	s (ExpDays,InvoiceLen,WarnDays)=0
	s (InvoiceChar,TempPath)=""
	s (AuthByPwd,DePrintRequest)="N"
	s (StkInRecords,StkTransRecords,StkOutTrans)=0
	i $d(^lab.DHCCTSYSParameterD(code)) d
	.s ExpDays=+$li(^lab.DHCCTSYSParameterD(code),3)
	.s InvoiceLen=+$li(^lab.DHCCTSYSParameterD(code),4)
	.s InvoiceChar=$li(^lab.DHCCTSYSParameterD(code),5)
	.s WarnDays=+$li(^lab.DHCCTSYSParameterD(code),6)
	.s TempPath=$li(^lab.DHCCTSYSParameterD(code),7)
	.s AuthByPwd=$li(^lab.DHCCTSYSParameterD(code),8)
	.s DePrintRequest=$li(^lab.DHCCTSYSParameterD(code),9)
	.s StkInRecords=$li(^lab.DHCCTSYSParameterD(code),10)
	.s StkTransRecords=$li(^lab.DHCCTSYSParameterD(code),11)
	.s StkOutTrans=$li(^lab.DHCCTSYSParameterD(code),12)
	i '$l(AuthByPwd) s AuthByPwd="N"
	i '$l(DePrintRequest) s DePrintRequest="N"
	i '$l(StkInRecords) s StkInRecords=0
	i '$l(StkTransRecords) s StkTransRecords=0
	i '$l(StkOutTrans) s StkOutTrans=0
	s RetStr=ExpDays_$c(2)_InvoiceLen_$c(2)_InvoiceChar_$c(2)_WarnDays_$c(2)_TempPath_$c(2)_AuthByPwd
	s RetStr=RetStr_$c(2)_DePrintRequest_$c(2)_StkInRecords_$c(2)_StkTransRecords_$c(2)_StkOutTrans
	q RetStr
}

/// Creator：      huhm
/// CreatDate：    20100818
/// Description:： 保存有效期参数
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod SaveExpirePara(code As %String, WarnDays As %String, AddMonths As %String) As %String
{
	s WarnDays=+$g(WarnDays),AddMonths=+$g(AddMonths)
    i $d(^lab.DHCCTSYSParameterD(code)) d
	.&sql(update lab.DHCCTSYSParameter set WarnDays=:WarnDays,ExpDays=:AddMonths where ID=:code)
	e  d
	.&sql(insert into lab.DHCCTSYSParameter(WarnDays,ExpDays) values(:WarnDays,:AddMonths))
	q SQLCODE
}

/// Creator：      huhm
/// CreatDate：    20100818
/// Description:： 保存发票参数
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod SaveInvoicePara(code As %String, InvLen As %String, InvChar As %String) As %String
{
	s InvLen=+$g(InvLen),InvChar=$g(InvChar)
    i $d(^lab.DHCCTSYSParameterD(code)) d
	.&sql(update lab.DHCCTSYSParameter set InvoiceLen=:InvLen,InvoiceChar=:InvChar where ID=:code)
	e  d
	.&sql(insert into lab.DHCCTSYSParameter(InvoiceLen,InvoiceChar) values(:InvLen,:InvChar))
	q SQLCODE
}

/// Creator：      huhm
/// CreatDate：    20100818
/// Description:： 保存发票参数
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod SaveTempPath(code As %String, path As %String) As %String
{
	s path=$g(path)
    i $d(^lab.DHCCTSYSParameterD(code)) d
	.&sql(update lab.DHCCTSYSParameter set TempPath=:path where ID=:code)
	e  d
	.&sql(insert into lab.DHCCTSYSParameter(Code,TempPath) values(:code,:path))
	q SQLCODE
}

/// Creator：      huhm
/// CreatDate：    20100820
/// Description:： 保存打印参数
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod SavePrint(code As %String, InSum As %String, TransSum As %String, OutSum As %String) As %String
{
	n (code,InSum,TransSum,OutSum)
	s code=$g(code),InSum=$g(InSum),TransSum=$g(TransSum),OutSum=$g(OutSum)
    i $d(^lab.DHCCTSYSParameterD(code)) d
	.&sql(update lab.DHCCTSYSParameter set StkInPrnRecords=:InSum,StkTransPrnRecords=:TransSum,StkOutPrnRecords=:OutSum where ID=:code)
	e  d
	.&sql(insert into lab.DHCCTSYSParameter(StkInPrnRecords,StkTransPrnRecords,StkOutPrnRecords) values(:InSum,:TransSum,:OutSum))
	q SQLCODE
}

}
