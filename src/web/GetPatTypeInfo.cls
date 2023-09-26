Class web.GetPatTypeInfo Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetPayInfo(StrDate, EndDate)
{
	s StrDate=$zdh(StrDate,3),EndDate=$zdh(EndDate,3)
	s PrtRowId="",PrtPayRowId="",PrtInsTypeDr=""
	f PrtDate=StrDate:1:EndDate  d
	.f  s PrtRowId=$o(^DHCINVPRT(0,"Date",PrtDate,PrtRowId)) q:PrtRowId=""  d
	..s PrtInsTypeDr=$p(^DHCINVPRT(PrtRowId),"^",9)
	..q:PrtInsTypeDr=""
	..s PrtInsType=$p(^PAC("ADMREA",PrtInsTypeDr),"^",2)            //查询得到患者类型
	..s PrtAcount=$p(^DHCINVPRT(PrtRowId),"^",1)                    //查询得到金额
	..q:PrtRowId=""
	..f  s PrtPayRowId=$o(^DHCINVPRT(PrtRowId,"P",PrtPayRowId)) q:PrtPayRowId=""  d
	...q:PrtPayRowId=""
	...s PrtPayModeRowId=$P(^DHCINVPRT(PrtRowId,"P",PrtPayRowId),"^",1)
	...q:PrtPayModeRowId=""
	...s PayMode=$p(^CT("CTPM",PrtPayModeRowId),"^",2)              //查询得到支付方式
	...;w !,PrtInsType_"^"_PayMode_"^"_PrtAcount
	...s TotalPay(PrtInsType,PayMode)=+$g(TotalPay(PrtInsType,PayMode))+PrtAcount
	
	s InsType="",Mode=""
	f  s InsType=$o(TotalPay(InsType)) q:InsType=""  d
	.f  s Mode=$o(TotalPay(InsType,Mode)) q:Mode=""  d
	..s TotalAcount=TotalPay(InsType,Mode)
	..w !,InsType_"^"_Mode_"^"_TotalAcount
}

//根据时间段查询患者类型、支付方式的金额

Query GetTypeAcount(StrDate, EndDate) As %Query(ROWSPEC = "InsType:%String,Cash:%String,Check:%String,ForPay:%String,Card:%String,Draft:%String,MedTreatPro:%String,PatCut:%String,Account:%String,Arrears:%String,ConAccount:%String,TotalType:%String")
{
}

ClassMethod GetTypeAcountExecute(ByRef qHandle As %Binary, StrDate, EndDate) As %Status
{
	 Set repid=$I(^CacheTemp)
     s ind=1
     i StrDate="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
     i EndDate="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
       
     k ^TMP($j)
     //s StrDate=$zdh(StrDate,4),EndDate=$zdh(EndDate,4)
   	 s PrtRowId="",PrtPayRowId="",PrtInsTypeDr=""
 	 f PrtDate=StrDate:1:EndDate  d
	 .f  s PrtRowId=$o(^DHCINVPRT(0,"Date",PrtDate,PrtRowId)) q:PrtRowId=""  d
	 ..s PrtInsTypeDr=$p(^DHCINVPRT(PrtRowId),"^",9)
	 ..q:PrtInsTypeDr=""
	 ..s PrtInsType=$p(^PAC("ADMREA",PrtInsTypeDr),"^",2)            //查询得到患者类型
	 ..s PrtAcount=$p(^DHCINVPRT(PrtRowId),"^",1)                    //查询得到金额
	 ..q:PrtRowId=""
	 ..f  s PrtPayRowId=$o(^DHCINVPRT(PrtRowId,"P",PrtPayRowId)) q:PrtPayRowId=""  d
	 ...q:PrtPayRowId=""
	 ...s PrtPayModeRowId=$P(^DHCINVPRT(PrtRowId,"P",PrtPayRowId),"^",1)
	 ...q:PrtPayModeRowId=""
	 ...s PayMode=$p(^CT("CTPM",PrtPayModeRowId),"^",2)              //查询得到支付方式
	 ...;w !,PrtInsType_"^"_PayMode_"^"_PrtAcount
	 ...s TotalPayByMode(PrtInsType,PayMode)=+$g(TotalPayByMode(PrtInsType,PayMode))+PrtAcount   //按支付方式求金额
	 ...;s TotalPayByType(PayMode,PrtInsType)=+$g(TotalPayByType(PayMode,PrtInsType))+PrtAcount   //按患者类型求金额
	  
	 //生成临时Global存储金额	 
	 s InsType="",Mode="",TotalAcount=""                           
	 f  s InsType=$o(TotalPayByMode(InsType)) q:InsType=""  d
	 .s ^TMP($j,InsType)="^^^^^^^^^^"
	 .f  s Mode=$o(TotalPayByMode(InsType,Mode)) q:Mode=""  d
	 ..s TotalAcount=TotalPayByMode(InsType,Mode)
	 ..s Code=$case(Mode,"现金":1,"支票":2,"预交金":3,"银行卡":4,"汇票":5,"医保基金支付":6,"病种差价":7,"记账":8,"欠费":9,"合同单位记账":10)
	 ..s $p(^TMP($j,InsType),"^",Code)=TotalAcount
     
     //按患者类型输出金额及总金额
     s RowId="",InsType=""
     f  s InsType=$o(^TMP($J,InsType)) q:InsType=""  d
     .f Flag=1:1:10 d
     ..s Cash=$p(^TMP($j,InsType),"^",1)
     ..s Check=$p(^TMP($j,InsType),"^",2)
     ..s ForPay=$p(^TMP($j,InsType),"^",3)
     ..s Card=$p(^TMP($j,InsType),"^",4)
     ..s Draft=$p(^TMP($j,InsType),"^",5)
     ..s MedTreatPro=$p(^TMP($j,InsType),"^",6)
     ..s PatCut=$p(^TMP($j,InsType),"^",7)
     ..s Account=$p(^TMP($j,InsType),"^",8)
     ..s Arrears=$p(^TMP($j,InsType),"^",9)
     ..s ConAccount=$p(^TMP($j,InsType),"^",10)
     ..s TotalType=+$G(Cash)+$G(Check)+$G(ForPay)+$G(Card)+$G(Draft)+$G(MedTreatPro)+$G(PatCut)+$G(Account)+$G(Arrears)+$G(ConAccount)     

     .Do OutputRow
     Set qHandle=$lb(0,repid,0)
     Quit $$$OK
OutputRow
	set Data=$lb(InsType,Cash,Check,ForPay,Card,Draft,MedTreatPro,PatCut,Account,Arrears,ConAccount,TotalType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTypeAcountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeAcountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTypeAcountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeAcountExecute ]
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

//查询制表人信息

Query GetUser() As %Query(ROWSPEC = "UserName:%String,UserIni:%String")
{
}

ClassMethod GetUserExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    
    s RowId=""
    f  s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
    .s UserName=$p(^SSU("SSUSR",RowId),"^",2)
    .s UserIni=$p(^SSU("SSUSR",RowId),"^",1)
    
    .Do OutputRow
     Set qHandle=$lb(0,repid,0)
     Quit $$$OK
OutputRow
	set Data=$lb(UserName,UserIni)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserExecute ]
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

ClassMethod GetDate(EndDate)
{
	s StaticDate=EndDate
	s Date=$p($h,",",1)
	s MadeDate=$zd(Date,4)
	s Time=$p($h,",",2)
	s MadeTime=$zt(Time,1)
	;w !,StaticDate_"^"_MadeDate_"^"_MadeTime
	q StaticDate_"^"_MadeDate_"^"_MadeTime
}

Storage Default
{
<Data name="GetPatTypeInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.GetPatTypeInfoD</DataLocation>
<DefaultData>GetPatTypeInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.GetPatTypeInfoD</IdLocation>
<IndexLocation>^web.GetPatTypeInfoI</IndexLocation>
<StreamLocation>^web.GetPatTypeInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
