Class web.DHCPE.Report.PreFind Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod SerchPreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchPreExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.PreFind","SerchPre","","")
ClassMethod SerchPreExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "") As %Status
{
	//w "条件为空、默认半月的数据"
	//PREREGED              预约完成
	//CANCELPREREG          取消预约
	//ARRIVED               到达
	//REGISTERED            登记 
	//PREREG                预约
	//CANCELPE              取消体检
	w "<font color=red>逗号后的为团体人数信息、括号内为已经到达的人数</font>"
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Total=0,TotalArrived=0
 	s (TNum1Total,TNum2Total,TNum3Total,TNum4Total,TNum5Total,TNum6Total,TNumTotalTotal)=0
 	s (GTNum1Total,GTNum2Total,GTNum3Total,GTNum4Total,GTNum5Total,GTNum6Total,GTNumTotalTotal)=0
 	s (TNumArrived1Total,TNumArrived2Total,TNumArrived3Total,TNumArrived4Total,TNumArrived5Total,TNumArrived6Total,TNumTotalArrivedTotal)=0
 	s (GTNumArrived1Total,GTNumArrived2Total,GTNumArrived3Total,GTNumArrived4Total,GTNumArrived5Total,GTNumArrived6Total,GTNumTotalArrivedTotal)=0
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
 	
 	i BeginDate="" s BeginDate=+$H
 	i EndDate="" s EndDate=BeginDate+15  //默认为开始日期后十五天的
 	s BeginDate=BeginDate-1
 	s StartTime=3600*8   //8点开始
 	s SplitTime=3600     //一个时间的间隔
 	f  s BeginDate=$o(^DHCPEPreIADM(0,"BookDateTime",BeginDate)) q:(BeginDate="")||(BeginDate>EndDate)  d
 	.s (TNum1,TNum2,TNum3,TNum4,TNum5,TNum6,TNumTotal)=0
 	.s (GTNum1,GTNum2,GTNum3,GTNum4,GTNum5,GTNum6,GTNumTotal)=0
 	.s (TNumArrived1,TNumArrived2,TNumArrived3,TNumArrived4,TNumArrived5,TNumArrived6,TNumTotalArrived)=0
 	.s (GTNumArrived1,GTNumArrived2,GTNumArrived3,GTNumArrived4,GTNumArrived5,GTNumArrived6,GTNumTotalArrived)=0
 	.s TDate=##class(websys.Conversions).DateLogicalToHtml(BeginDate)_"("_..GetWeek(BeginDate)_")"
 	.s Date2=0
 	.f  s Date2=$o(^DHCPEPreIADM(0,"BookDateTime",BeginDate,Date2)) q:Date2=""  d
 	..s Time=0
 	..f  s Time=$o(^DHCPEPreIADM(0,"BookDateTime",BeginDate,Date2,Time)) q:Time=""  d
 	...s Count=$p((((Time-StartTime)/SplitTime)+1),".",1)+1
 	...s PreIADM=0
 	...f  s PreIADM=$o(^DHCPEPreIADM(0,"BookDateTime",BeginDate,Date2,Time,PreIADM)) q:PreIADM=""  d
 	....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM)          //add 2009-07-07 
  	....q:LocFlag=1
 	
 	....s Status=$p($G(^DHCPEPreIADM(PreIADM)),"^",8)
 	....q:(Status="CANCELPE")||(Status="CANCELPREREG")
 	....s GID=$p($G(^DHCPEPreIADM(PreIADM)),"^",2)
 	....i Count=1 d
 	.....s TNum1=TNum1+1
 	.....i GID'="" s GTNum1=GTNum1+1
 	.....i Status="ARRIVED" d
 	......s TNumArrived1=TNumArrived1+1
 	......i GID'="" s GTNumArrived1=GTNumArrived1+1
	....i Count=2 d
 	.....s TNum2=TNum2+1
 	.....i GID'="" s GTNum2=GTNum2+1
 	.....i Status="ARRIVED" d
 	......s TNumArrived2=TNumArrived2+1	
 	......i GID'="" s GTNumArrived2=GTNumArrived2+1	
	....i Count=3 d
 	.....s TNum3=TNum3+1
 	.....i GID'="" s GTNum3=GTNum3+1
 	.....i Status="ARRIVED" d
 	......s TNumArrived3=TNumArrived3+1
 	......i GID'="" s GTNumArrived3=GTNumArrived3+1	
	....i Count=4 d
 	.....s TNum4=TNum4+1
 	.....i GID'="" s GTNum4=GTNum4+1
 	.....i Status="ARRIVED" d
 	......s TNumArrived4=TNumArrived4+1
 	......i GID'="" s GTNumArrived4=GTNumArrived4+1	
	....i Count=5 d
 	.....s TNum5=TNum5+1
 	.....i GID'="" s GTNum5=GTNum5+1
 	.....i Status="ARRIVED" d
 	......s TNumArrived5=TNumArrived5+1
 	......i GID'="" s GTNumArrived5=GTNumArrived5+1	
	....i Count>5 d
 	.....s TNum6=TNum6+1
 	.....i GID'="" s GTNum6=GTNum6+1
 	.....i Status="ARRIVED" d
 	......s TNumArrived6=TNumArrived6+1
 	......i GID'="" s GTNumArrived6=GTNumArrived6+1	
	.s TNumTotal=TNum1+TNum2+TNum3+TNum4+TNum5+TNum6
	.s GTNumTotal=GTNum1+GTNum2+GTNum3+GTNum4+GTNum5+GTNum6
	.q:TNumTotal=0  //没有不显示
	.s TNumTotalArrived=TNumArrived1+TNumArrived2+TNumArrived3+TNumArrived4+TNumArrived5+TNumArrived6
	.s GTNumTotalArrived=GTNumArrived1+GTNumArrived2+GTNumArrived3+GTNumArrived4+GTNumArrived5+GTNumArrived6
	.s TNum1Total=TNum1Total+TNum1
	.s GTNum1Total=GTNum1Total+GTNum1
	.s TNum2Total=TNum2Total+TNum2
	.s GTNum2Total=GTNum2Total+GTNum2
	.s TNum3Total=TNum3Total+TNum3
	.s GTNum3Total=GTNum3Total+GTNum3
	.s TNum4Total=TNum4Total+TNum4
	.s GTNum4Total=GTNum4Total+GTNum4
	.s TNum5Total=TNum5Total+TNum5
	.s GTNum5Total=GTNum5Total+GTNum5
	.s TNum6Total=TNum6Total+TNum6
	.s GTNum6Total=GTNum6Total+GTNum6
	.s TNumTotalTotal=TNumTotalTotal+TNumTotal
	.s GTNumTotalTotal=GTNumTotalTotal+GTNumTotal
	.s TNumArrived1Total=TNumArrived1Total+TNumArrived1
	.s GTNumArrived1Total=GTNumArrived1Total+GTNumArrived1
	.s TNumArrived2Total=TNumArrived2Total+TNumArrived2
	.s GTNumArrived2Total=GTNumArrived2Total+GTNumArrived2
	.s TNumArrived3Total=TNumArrived3Total+TNumArrived3
	.s GTNumArrived3Total=GTNumArrived3Total+GTNumArrived3
	.s TNumArrived4Total=TNumArrived4Total+TNumArrived4
	.s GTNumArrived4Total=GTNumArrived4Total+GTNumArrived4
	.s TNumArrived5Total=TNumArrived5Total+TNumArrived5
	.s GTNumArrived5Total=GTNumArrived5Total+GTNumArrived5
	.s TNumArrived6Total=TNumArrived6Total+TNumArrived6
	.s GTNumArrived6Total=GTNumArrived6Total+GTNumArrived6
	.s TNumTotalArrivedTotal=TNumTotalArrivedTotal+TNumTotalArrived
	.s GTNumTotalArrivedTotal=GTNumTotalArrivedTotal+GTNumTotalArrived
	.s TNum1=..ChangeNum(TNum1,TNumArrived1)
	.s GTNum1=..ChangeNum(GTNum1,GTNumArrived1)
	.i +GTNum1'=0 s TNum1=TNum1_","_GTNum1
	.s TNum2=..ChangeNum(TNum2,TNumArrived2)
	.s GTNum2=..ChangeNum(GTNum2,GTNumArrived2)
	.i +GTNum2'=0 s TNum2=TNum2_","_GTNum2
	.s TNum3=..ChangeNum(TNum3,TNumArrived3)
	.s GTNum3=..ChangeNum(GTNum3,GTNumArrived3)
	.i +GTNum3'=0 s TNum3=TNum3_","_GTNum3
	.s TNum4=..ChangeNum(TNum4,TNumArrived4)
	.s GTNum4=..ChangeNum(GTNum4,GTNumArrived4)
	.i +GTNum4'=0 s TNum4=TNum4_","_GTNum4
	.s TNum5=..ChangeNum(TNum5,TNumArrived5)
	.s GTNum5=..ChangeNum(GTNum5,GTNumArrived5)
	.i +GTNum5'=0 s TNum5=TNum5_","_GTNum5
	.s TNum6=..ChangeNum(TNum6,TNumArrived6)
	.s GTNum6=..ChangeNum(GTNum6,GTNumArrived6)
	.i +GTNum6'=0 s TNum6=TNum6_","_GTNum6
	.s TNumTotal=..ChangeNum(TNumTotal,TNumTotalArrived)
	.s GTNumTotal=..ChangeNum(GTNumTotal,GTNumTotalArrived)
	.i +GTNumTotal'=0 s TNumTotal=TNumTotal_","_GTNumTotal
	.d FindBuild
	s TDate="总计"
	s TNum1=..ChangeNum(TNum1Total,TNumArrived1Total)
	s GTNum1=..ChangeNum(GTNum1Total,GTNumArrived1Total)
	i +GTNum1'=0 s TNum1=TNum1_","_GTNum1
	s TNum2=..ChangeNum(TNum2Total,TNumArrived2Total)
	s GTNum2=..ChangeNum(GTNum2Total,GTNumArrived2Total)
	i +GTNum2'=0 s TNum2=TNum2_","_GTNum2
	s TNum3=..ChangeNum(TNum3Total,TNumArrived3Total)
	s GTNum3=..ChangeNum(GTNum3Total,GTNumArrived3Total)
	i +GTNum3'=0 s TNum3=TNum3_","_GTNum3
	s TNum4=..ChangeNum(TNum4Total,TNumArrived4Total)
	s GTNum4=..ChangeNum(GTNum4Total,GTNumArrived4Total)
	i +GTNum4'=0 s TNum4=TNum4_","_GTNum4
	s TNum5=..ChangeNum(TNum5Total,TNumArrived5Total)
	s GTNum5=..ChangeNum(GTNum5Total,GTNumArrived5Total)
	i +GTNum5'=0 s TNum5=TNum5_","_GTNum5
	s TNum6=..ChangeNum(TNum6Total,TNumArrived6Total)
	s GTNum6=..ChangeNum(GTNum6Total,GTNumArrived6Total)
	i +GTNum6'=0 s TNum6=TNum6_","_GTNum6
	s TNumTotal=..ChangeNum(TNumTotalTotal,TNumTotalArrivedTotal)
	s GTNumTotal=..ChangeNum(GTNumTotalTotal,GTNumTotalArrivedTotal)
	i +GTNumTotal'=0 s TNumTotal=TNumTotal_","_GTNumTotal
	s BeginDate=""
	i (TNum1="") s TNum1=0
	i (TNum2="") s TNum2=0
	i (TNum3="") s TNum3=0
	i (TNum4="") s TNum4=0
	i (TNum5="") s TNum5=0
	i (TNum6="") s TNum6=0
    i (TNumTotal="") s TNumTotal=0
    ;d FindBuild
	 w "<br><font color = blue size=1 >总计:"_TNumTotal_"人. 8点前:"_TNum1_"人，8----9点:"_TNum2_"人，9----10点:"_TNum3_"人，10----11点:"_TNum4_"人，11----12点:"_TNum5_"人，12点后:"_TNum6_"人</font>"
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(TDate,TNum1,TNum2,TNum3,TNum4,TNum5,TNum6,TNumTotal,BeginDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchPreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchPreExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query SerchPre(BeginDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TDate:%String,TNum1:%String,TNum2:%String,TNum3:%String,TNum4:%String,TNum5:%String,TNum6:%String,TNumTotal:%String,TBeginDate:%String")
{
}

ClassMethod GetWeek(Date)
{
	s Week=$ZD(Date,11)
	s:Week="Thu" Week="星期四"
	s:Week="Fri" Week="星期五"
	s:Week="Sat" Week="星期六"
	s:Week="Sun" Week="星期日"
	s:Week="Wed" Week="星期三"
	s:Week="Tue" Week="星期二"
	s:Week="Mon" Week="星期一"
	q Week
}

ClassMethod ChangeNum(Num1, Num2)
{
	i Num1=0 q ""
	i Num2'=0 s Num1=Num1_"("_Num2_")"
	q Num1
}

ClassMethod SerchPreByTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchPreByTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SerchPreByTimeExecute(ByRef qHandle As %Binary, Date As %String = "", Count As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	i Date=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i Date'="" s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
 	s ind=1
 	s StartTime=3600*8   //8点开始
 	s SplitTime=3600     //一个时间的间隔
 	i Count=""  d
 	.s BeginTime=0
 	.s EndTime=3600*24
 	e  i Count=1 d
 	.s BeginTime=0
 	.s EndTime=StartTime
 	e  i Count=6 d
 	.s BeginTime=StartTime+((Count-2)*SplitTime)
 	.s EndTime=3600*24
 	e  d
 	.s BeginTime=StartTime+((Count-2)*SplitTime)
 	.s EndTime=StartTime+((Count-1)*SplitTime)
 	s Date2=0
 	f  s Date2=$o(^DHCPEPreIADM(0,"BookDateTime",Date,Date2)) q:Date2=""  d
 	.s Time=BeginTime-1
 	.f  s Time=$o(^DHCPEPreIADM(0,"BookDateTime",Date,Date2,Time)) q:(Time="")||(Time>EndTime)  d
 	..s PreIADM=0
 	..f  s PreIADM=$o(^DHCPEPreIADM(0,"BookDateTime",Date,Date2,Time,PreIADM)) q:PreIADM=""  d
 	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM)          //add 2009-07-07 
  	...q:LocFlag=1
 	
 	...s Status=$p($G(^DHCPEPreIADM(PreIADM)),"^",8)
 	...q:(Status="CANCELPE")||(Status="CANCELPREREG")
 	...s (TRegNo,TName,TSex,TAge,TGroup,TStatus,TBeginDate,TEndDate,TTime,TPreIADMID)=""
 	...s TPreIADMID=PreIADM
 	...s Str=$G(^DHCPEPreIADM(PreIADM))
 	...s PIBI=$p(Str,"^",1)
 	...s CurData=$G(^DHCPEPreIBI(PIBI))
 	...s TRegNo=$p(CurData,"^",1)
	...
	...//	PIBI_Name	姓名
	...S TName=$p(CurData,"^",2)
	...
	...//	PIBI_Sex_DR	性别
	...s TSex=$p(CurData,"^",3)
	...i (""'=TSex)  d  		//CT_Sex	CTSEX_Desc
	....s TSex=$p($G(^CT("SEX",TSex)),"^",2)
	...
	...//	PIBI_DOB	生日
	...;s TAge=$p(CurData,"^",4)
	...;i TAge'="" s TAge=+##class(web.DHCLCNUREXCUTE).CalAge(TAge,+$H)
	...s TAge=""
	...S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",TRegNo,0))
	...i PAPMIRowId'="" s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
 	...s TGroup=$p(Str,"^",2)
 	...i TGroup'="" s TGroup=##Class(web.DHCPE.PreGTeam).GetGAdmDesc(TGroup)
 	...s TStatus=##Class(web.DHCPE.PreCommon).TransStatus(Status)
 	...s TBeginDate=$p(Str,"^",4)
 	...i TBeginDate'="" s TBeginDate=##class(websys.Conversions).DateLogicalToHtml(TBeginDate)
 	...s TEndDate=$p(Str,"^",5)
 	...i TEndDate'="" s TEndDate=##class(websys.Conversions).DateLogicalToHtml(TEndDate)
 	...s TTime=$p(Str,"^",6)
 	...i TTime'="" s TTime=$ZT(TTime)
 	...d BuildList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildList      
	set Data=$lb(TRegNo,TName,TSex,TAge,TGroup,TStatus,TBeginDate,TEndDate,TTime,TPreIADMID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchPreByTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchPreByTimeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query SerchPreByTime(Date As %String = "", Count As %String = "") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TGroup:%String,TStatus:%String,TBeginDate:%String,TEndDate:%String,TTime:%String,TPreIADMID:%String")
{
}

Storage Default
{
<Data name="PreFindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.PreFindD</DataLocation>
<DefaultData>PreFindDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCP.PreFindD</IdLocation>
<IndexLocation>^web.DHCP.PreFindI</IndexLocation>
<StreamLocation>^web.DHCP.PreFindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage NewStorage1
{
<Type>%CustomStorage</Type>
}

}
