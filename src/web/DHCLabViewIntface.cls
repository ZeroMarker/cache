Class web.DHCLabViewIntface Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 名称: 结果视图
/// 描述: 
/// 编写者: 
/// 编写日期: 2013-01-14
/// 查询  select * from web.DHC_Lis_Info
Query LisResultInfo() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DHC_Lis_Info ]
{
	select VISTD_ParRef->VISTS_ParRef->EPVIS_DebtorNumber_DR as PatientID,
	   VISTD_ParRef->VISTS_ParRef->EPVIS_Surname as Name,
	   VISTD_ParRef->VISTS_ParRef->EPVIS_DateOfBirth as BirthDate,
	   VISTD_ParRef->VISTS_TherapeutDosage as SampleID,
	   VISTD_ParRef->VISTS_DateOfCollection as SamplingDate,
	   VISTD_ParRef->VISTS_DateOfAuthorisation as TestDate,
	   VISTD_ParRef->VISTS_ParRef->EPVIS_DoctorCode_DR as DoctorID,
	   VISTD_TestData as TestResult,
	   VISTD_TestCode_DR as TestID,
	   VISTD_Comments as Remark,
	   VISTD_ParRef->VISTS_ParRef as BarCode from lab.EP_VisitTestSetData
}

/// d ##class(%ResultSet).RunQuery("web.DHCLabViewIntface","QryLabOrderList","0000000017","","")
/// 名称: 存储过程
/// 描述: 获取医嘱列表
/// 编写者: liuzf
/// 编写日期: 2014-05-24
/// 入参：CardNo 卡号/登记号  SttDate,EndDate:就诊开始日期-结束日期
/// 查询  call web.DHCLabViewIntface_QryLabOrderList("0000000017","","")
ClassMethod QryLabOrderListExecute(ByRef qHandle As %Binary, CardNo As %String, SttDate As %String, EndDate As %String) As %Status
{
  	Set repid=$I(^CacheTemp)
  	Set ind=1

 	s CardNo=$g(CardNo),SttDate=$g(SttDate),EndDate=$g(EndDate)
 	i '$l(CardNo) q 0
 	i $l(SttDate) s SttDate=$zdh(SttDate,3)
 	i $l(EndDate) s EndDate=$zdh(EndDate,3)

    i $l(CardNo)>11 s Debtor=$$GetPatIdbyCardid(CardNo)
    e  s Debtor=$tr($j($g(CardNo),8)," ","0")
  	s PatId=$o(^PAPERi("PAPMI_PatNo",Debtor,""))
  	i '$l(PatId) q 0

  f admType="E","O" d  //"I",住院不显示
  .s type=""
  .s adm="" f  s adm=$o(^PAPERdr(PatId,"ADM",admType,adm),-1) q:adm=""  d
  ..//i $p($g(^PAADM(adm)),"^",20)'="A" q
  ..s admDate=$p($g(^PAADM(adm)),"^",6)
  ..s admTime=$p($g(^PAADM(adm)),"^",7)
  ..i $l(SttDate),admDate<SttDate Quit
  ..i $l(EndDate),admDate>EndDate Quit
  ..d QueryByAdm
  
  	Set qHandle=$lb(0,repid,0)
  	Quit $$$OK
  	
QueryByAdm	
   Set OrdId="" For  Set OrdId=$o(^OEORD(0,"Adm",adm,OrdId)) Quit:OrdId=""  Do
   .//找所有医嘱RowId  OrdId||SubId
   .Set SubId="" For  Set SubId=$o(^OEORD(OrdId,"I",SubId)) Quit:SubId=""  Do
   ..Set OrdRowId=OrdId_"||"_SubId
   ..Set OrdStr1=$Get(^OEORD(OrdId,"I",SubId,1))
   .. If '$Length(OrdStr1) Quit
   ..Set OrdStr3=$Get(^OEORD(OrdId,"I",SubId,3))
   ..//判断是否执行，执行即退出
   ..Set OrdExc=$Piece($Get(^OEORD(OrdId,"I",SubId,1)),"^",13)
   ..Set StatusDesc="核实"
   ..If OrdExc=6 Quit  //执行
   ..If OrdExc=4 Quit  //"停止" 
   ..//条码号
   ..Set LabEpisode=$Piece(OrdStr3,"^",20)
   ..If LabEpisode="" Quit
   ..s ItmMastDr=$p(OrdStr1,"^",2)
   ..//判断是否为检验医嘱
   ..Set ItmType=$$IsLabTS(ItmMastDr)
   ..If ItmType=0 Quit
   ..//判断是否缴费
   ..Set BilledFlag=$Piece(OrdStr3,"^",5)
   ..If type="O",BilledFlag'="P" Quit ///"未收费"
   ..//开单科室
   ..Set LocName=""
   ..Set LocCode=$Piece(OrdStr1,"^",3)
   ..If $Length(LocCode) Set LocName=$Piece($Get(^CTLOC(LocCode)),"^",2)
   ..if LocName["-" s LocName=$p(LocName,"-",2)
   ..//取出医嘱项的RowID
   ..Set ItmMastDr=$Piece(OrdStr1,"^",2)
   ..//医嘱优先级别
   ..Set PriorityName=""
   ..Set PriorityDR=$Piece(OrdStr1,"^",8)
   ..//If $Length(PriorityDR) Set PriorityName=$Piece($Get(^OECPR(PriorityDR)),"^",2)
   ..If PriorityDR=2 Set PriorityName=0
   ..If PriorityDR=3 Set PriorityName=1
   ..Set OrdName=""
   ..If $Length(ItmMastDr),$Data(^ARCIM($p(ItmMastDr,"||",1),$p(ItmMastDr,"||",2),1)) Do
   ...//医嘱名称,为医嘱缩写名称
   ...Set OrdName=$p($Get(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
   ..//^ARCIM(1,1,"EXT",1)
   ..Set ItmCosDr=$Piece(OrdStr3,"^",10)
   ..//取检验医嘱代码
   ..Set OrdIntCode="",DepName="",DepCode="",SampCode="",SampName=""
   ..//
   ..Set OrdIntCode=$$GetItemTSCode(ItmMastDr,ItmCosDr)
   ..If '$Length($TR(OrdIntCode," ")) Quit
   ..//If $Length(DeptRowId),DeptRowId'=DepCode Quit
   ..//
   ..If $Length(OrdIntCode) Set DepCode=$E(OrdIntCode,0,1)
   ..//检验科室
   ..If $Length(DepCode) Set DepName=$Piece($Get(^TTAB("DEP",DepCode)),"\",1)
   ..//标本代码，信息
   ..Set SampCode=""
   ..If $Data(^OEORD($p(OrdRowId,"||",1),"I",$p(OrdRowId,"||",2),"SPEC",1)) Set SampCode=$Piece($Get(^OEORD($p(OrdRowId,"||",1),"I",$p(OrdRowId,"||",2),"SPEC",1)),"^",1)
   ..If $Length(SampCode) Set SampName=$Piece($Get(^TTAB("SPEC",SampCode)),"\",1)
   ..//
   ..//如果没有维护的医嘱，即退出
   ..//If '$Data(^DHCCOLLBLOOD("TS",OrdIntCode)) Quit
   ..If $Length(OrdIntCode),$Data(^DHCCOLLBLOOD("TS",OrdIntCode)),$Get(^DHCCOLLBLOOD("TS",OrdIntCode))'=1 Quit
   ..//标本容器添加。
   ..Set ConCode="",ConName="0"
   ..If $Length(SampCode) Set ConCode=$Order(^TTAB("TS",OrdIntCode,"SC",""))
   ..If $Length(ConCode),$Data(^DHCCOLLBLOOD("CON",ConCode)) Set ConName=$Get(^DHCCOLLBLOOD("CON",ConCode))
   ..//申请时间,日期
   ..Set ReqTime=""
   ..Set ReqTime=$Piece(OrdStr1,"^",17)
   ..If $Length(ReqTime) Set ReqTime=$zt(ReqTime,2)
   ..Set ReqDate=""
   ..Set ReqDate=$Piece(OrdStr3,"^",7)
   ..If $Length(ReqDate) Set ReqDate=$zd(ReqDate,3)
   ..Set CurDate=$zd($Piece($H,",",1),3)
   ..//取标本信息
   ..Set OrdIntInf=""
   ..//
   ..If $Length(OrdIntCode) Set OrdIntInf=$Piece($Get(^TTAB("TS",OrdIntCode)),"\",33)
   ..Set ^TMP($ZN,$J,LabEpisode,OrdIntCode)=LocName_"^"_DepName_"^"_SampName_"^"_ConName_"^"_OrdIntInf_"^"_OrdName_"^"_StatusDesc
   //合并医嘱，同一条码号的标本自动合并
   Set Num=0
   Set Episode="" For  Set Episode=$Order(^TMP($ZN,$J,Episode)) Quit:Episode=""  Do
   .Set (TSCode,TSName,TSStr)="",SendFlag=1
   .Set ts="" For  Set ts=$Order(^TMP($ZN,$J,Episode,ts)) Quit:ts=""  Do
   ..Set TSStr=$Get(^TMP($ZN,$J,Episode,ts))
   ..Set TSCode=TSCode_ts_","
   ..If TSName="" Set TSName=$Piece(TSStr,"^",6)
   ..e  s TSName=TSName_" "_$Piece(TSStr,"^",6)
   ..i $d(^DHCCOLLBLOOD("TS",ts)) s SendFlag=0
   ..If $Piece(TSStr,"^",7)'="核实" Quit
   .If TSName="" Quit
   .Set $Piece(TSStr,"^",6)=TSName
   .Set $Piece(TSStr,"^",7)="核实"
   .Set PrnNum=1 ;打印条码数量
   .Set Send=0
   .If $p(TSStr,"^",3)["血" Set Send=1
   .If SendFlag=0 Set Send=0  //是否上传
   .d OutputRow
   q 0
  	
OutputRow
  set Data=$lb(Num,LocName,DepName,SampName,ConName,OrdIntInf,OrdName,StatusDesc,Episode,TSCode,PrnNum,Send)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  quit

GetPatIdbyCardid(CardId)
  s CardId=$g(CardId)
  s CardId=$$ALPHAUP^SSUTIL4(CardId)
  s regNo=CardId
  ;通过卡号取登记号和ADM号
  i $d(^DHCCARDi("CF",0,"CardNo",CardId)) d
   .s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardId,""))
   .s ActiveFlag=$p(^DHCCARD("CF",CardRowid),"^",10)
   .q:ActiveFlag'="N"
   .s papmiId=$p(^DHCCARD("CF",CardRowid),"^",4)
   .s regNo=$p(^DHCCARD("CF",CardRowid),"^",6)
  q regNo
  
    ///是否为检验医嘱
IsLabTS(ItemMast)
	Set ItemMast=$Get(ItemMast)
	Set RtnValue="0"
	Set ItmCat=$Piece(^ARCIM(+ItemMast,$Piece(ItemMast,"||",2),1),"^",10)
	If $Length(ItmCat),$Data(^ARC("IC",ItmCat)) Do
    .i $Piece(^ARC("IC",ItmCat),"^",7)="L" s RtnValue="1"
	Quit RtnValue

GetItemTSCode(ArcimRowId,ArcosId)
 s ArcimRowId=$g(ArcimRowId),ArcosId=$g(ArcosId)
 s arcimID=$p(ArcimRowId,"||",1),SubID=$p(ArcimRowId,"||",2)
 s ts=""
 If $l(ArcosId),$Data(^ARCOS(ArcosId)) Set ts=$Piece(^ARCOS(ArcosId),"^",11)
 i $l(ts) q ts
 i '$l(arcimID) q ""
 i '$l(SubID) q ""
 s seq=+$g(^ARCIM(arcimID,SubID,"EXT",0))
 i seq=1 s ts=$p(^ARCIM(arcimID,SubID,"EXT",seq),"^",4)
 i $l(ts) q ts
 s ExeCodeList=""
 //s ExeCodeList="R,S,Q,P,"  ///积水潭回龙观接受科室
 s ord="" f  s ord=$o(^ARCIM(arcimID,SubID,"EXT",ord)) q:ord=""!$l(ts)  d
 .s ExtCode=$p(^ARCIM(arcimID,SubID,"EXT",ord),"^",4)
 .i ExeCodeList[$e(ExtCode,1) s ts=ExtCode
 q ts
   
GetPatient(Debtor)
    Set PAPERId=$Order(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(Debtor),""))
	If PAPERId="" Quit ""
	//取姓名，性别，出生年月
	Set Name=$Piece($Get(^PAPER(PAPERId,"ALL")),"^",1)
	Set SexCode=$Piece($Get(^PAPER(PAPERId,"ALL")),"^",7)
	Set SexName=0
	Set SexName=$Piece($Get(^CT("SEX",SexCode)),"^",2)
	Set Dob=$Piece($Get(^PAPER(PAPERId,"ALL")),"^",6)
	Set Age=$$age(Dob)_"岁"
	If $Length(Dob) Set Dob=$ZD(Dob,3)
	Set RetVal=Debtor_"^"_Name_"^"_SexName_"^"_Dob_"^"_Age
	Quit RetVal

age(dob) ;get age in days
 s days=$h-dob i days>365 q days\365
 q days/1000
}

ClassMethod QryLabOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabOrderListExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

ClassMethod QryLabOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabOrderListExecute ]
{
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {				// if there are no more rows, finish fetching
   	 Set AtEnd=1
   	 Set Row=""
  }
  Else      {			
  	 Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

Query QryLabOrderList(Labno As %String, SttDate As %String, EndDate As %String) As %Query(ROWSPEC = "Num,LocName,DepName,SampName,ConName,OrdIntInf,OrdName,StatusDesc,Episode,TSCode,PrnNum,Send") [ SqlProc, SqlViewName = DHC_LIS_Order ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCLabViewIntface","QueryLisInfo",100151)
/// 名称: 存储过程
/// 描述: 
/// 编写者: 
/// 编写日期: 2013-01-14
/// 查询  call web.DHCLabViewIntface_QueryLisInfo(100151)
ClassMethod QueryLisInfoExecute(ByRef qHandle As %Binary, Labno As %String) As %Status
{
  	Set repid=$I(^CacheTemp)
  	Set ind=1
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	Set WebNS=$ZUTIL(5)
 	s Labno=$g(Labno)
 	i '$l(Labno) q 0
 	
 	s gName=$p(^TEPI(Labno),"\",1)
    s sName=$p(^TEPI(Labno),"\",2)
    s PatName=gName_" "_sName
    i gName=sName s PatName=gName
    s Debtor=$p(^TEPI(Labno),"\",18) ;登记号
    s BirthDate=$p(^TEPI(Labno),"\",4)
    i $l(BirthDate) s BirthDate=$zd(BirthDate,3)
	s (ColDate,RecDate,DoctorName,DoctorCode,TestResult,Location,TestID,TSMemo)=""
	
    s loccode=$p(^TEPI(Labno),"\",36) 
    i loccode'="",$d(^TTAB("USLOC",loccode)) s Location=$p($g(^TTAB("USLOC",loccode)),"\",1)

    s docName=""					;医生
    s DoctorCode=$p(^TEPI(Labno),"\",13)
    i DoctorCode'="",$d(^TTAB("DR",DoctorCode)) s DoctorName=$p(^TTAB("DR",DoctorCode),"\",1)
    i $l(DoctorName,"(") s DoctorName=$p(DoctorName,"(",1)  
	
    Do OutputRow

  	Set qHandle=$lb(0,repid,0)
  	Quit $$$OK
OutputRow
  set Data=$lb(Labno,Debtor,PatName,BirthDate,ColDate,RecDate,DoctorName,DoctorCode,TestResult,Location,TestID,TSMemo)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  quit
}

ClassMethod QueryLisInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLisInfoExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

ClassMethod QueryLisInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLisInfoExecute ]
{
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {				// if there are no more rows, finish fetching
   	 Set AtEnd=1
   	 Set Row=""
  }
  Else      {			
  	 Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

Query QueryLisInfo(Labno As %String) As %Query(ROWSPEC = "Labno,Debtor,PatName,BirthDate,ColDate,TestDate,DoctorName,DoctorCode,TestResult,Location,TestID,TSMemo") [ SqlProc, SqlViewName = DHC_LIS_Info1 ]
{
}

}
