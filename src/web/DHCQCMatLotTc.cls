Class web.DHCQCMatLotTc Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod MatLotQueryTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MatLotQueryTCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCQCMatLotTc","MatLotQueryTC","CA1500","CA1500","A1130|","3|2|1|","AC1500")
ClassMethod MatLotQueryTCExecute(ByRef qHandle As %Binary, MatCode As %String, LotCode As %String, TCode As %String, QCLevel As %String, MachCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),TCCode=$Get(TCCode),MachCode=$g(MachCode)
	Set LotParRef1=MatCode_"||"_LotCode
	Set (TCCode,TCName,QCID,setupX,setupSD,calX,calSD,calCV,iNum)=""
	Set Num=0
	//If $Data(^DHCQCTC(LotParRef)) Do
	//没有建索引，速度是否会慢？
	s LotParRef="" f  s LotParRef=$Order(^DHCQCTC(LotParRef)) q:LotParRef=""  d
	.i $l(MatCode),$l(LotCode),LotParRef'=LotParRef1 q
	.//不是此仪器的退出
	.i $l(MachCode),$p($g(^DHCQCMAT($p(LotParRef,"||",1))),"^",3)'=MachCode q 
	.Set TCCode="" For  Set TCCode=$Order(^DHCQCTC(LotParRef,TCCode)) Quit:TCCode=""  Do
	..If $Length(TCode),TCode'[TCCode Quit
	..Set Seq="" For  Set Seq=$Order(^DHCQCTC(LotParRef,TCCode,Seq)) Quit:Seq=""  Do
	...Set str=$Get(^DHCQCTC(LotParRef,TCCode,Seq))
	...If $Length(QCLevel),QCLevel'[Seq Quit
	...Set Visible=$Piece(str,"^",3)
	...If Visible="false" Quit
	...Set Decimal=$Piece(str,"^",8)
	...If Decimal="" Set Decimal=2
	...Set setupX=$Piece(str,"^",6)
	...If setupX="0" Set setupX=""
	...If setupX'="" Set setupX=$FN(setupX,",",Decimal)
	...Set setupSD=$Piece(str,"^",7)
	...If setupSD="0.0" Set setupSD=""
	...If setupSD'="" Set setupSD=$FN(setupSD,",",Decimal)
	...Set calX=$Piece(str,"^",9)
	...If calX="0.0" Set calX=""
	...If calX'="" Set calX=$FN(calX,",",Decimal)
	...Set calSD=$Piece(str,"^",10)
	...If calSD="0.0" Set calSD=""
	...If calSD'="" Set calSD=$FN(calSD,",",Decimal)
	...Set calCV=$Piece(str,"^",11)
	...If calCV="0.0" Set calCV=""
	...If calCV'="" Set calCV=$FN(calCV,",",Decimal)
	...Set Num=Num+1
	...Set QCID=Seq
	...Set TCName=$Piece(^TTAB("TC",TCCode),"\",1)
	...//增加质控个数
	...Set iNum=$Piece(str,"^",14)
	...i iNum=0 s iNum="",calX="",calSD="",calCV=""
	...Do OutTCXSD
	If Num<1 Do OutTCXSD
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutTCXSD
	set Data=$lb(TCCode,TCName,QCID,setupX,setupSD,calX,calSD,calCV,iNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod MatLotQueryTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MatLotQueryTCExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else     
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20130315
/// Description:： 按照质控物批次查询项目设置的基本信息.
/// Table：        DHCQC_Lot,DHCQC_Material,DHCQC_TestCode
/// Input：        MatCode:质控物代码，LotCode:批号,TCode：所有的项目,
/// Output：       项目浓度设置信息
/// Return：       
/// Others：       Autstorage:MeanType是否使用上月计算值为设定标准差             
Query MatLotQueryTC(MatCode As %String, LotCode As %String, TCode As %String, QCLevel = "", MachCode = "") As %Query(ROWSPEC = "TCCode:%String,TCName:%String,QCID:%String,setupX:%String,setupSD:%String,calX:%String,calSD:%String,calCV:%String,iNum:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20140624
/// Description： 按照日期，时间及相关条件查询统计质控批次信息汇总
/// Table：        DHCQC_Lot,DHCQC_Material,DHCQC_TestCode
/// Input：        MatCode:质控物代码，LotCode:批号,TCode：所有的项目,QCLevel:浓度,StartDate:开始日期,EndDate:结束日期,PointType:排除点,失控点
/// Output：       项目浓度设置信息
/// Return：       
/// Others：       Autstorage:MeanType是否使用上月计算值为设定标准差             
Query MatLotQuery(MatCode1 As %String, LotCode1 As %String, TCode As %String, QCLevel As %String, StartDate As %String, EndDate As %String, PointType As %String, MachCode = "") As %Query(ROWSPEC = "TCCode:%String,TCName:%String,QCID:%String,setupX:%String,setupSD:%String,calX:%String,calSD:%String,calCV:%String,iNum:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……"AXE2100||AXE2100"
/// d ##class(%ResultSet).RunQuery("web.DHCQCMatLotTc ","MatLotQuery","CA1500","CA1500","","3|2|1|","2014-03-01","2014-03-31","True^True")
ClassMethod MatLotQueryExecute(ByRef qHandle As %Binary, MatCode1 As %String, LotCode1 As %String, TCode As %String, QCLevel As %String, StartDate As %String, EndDate As %String, PointType As %String, MachCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MatCode1=$Get(MatCode1),LotCode1=$Get(LotCode1),TCCode=$Get(TCCode),MachCode=$g(MachCode)
	Set LotParRef1=MatCode1_"||"_LotCode1
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	Set (TCCode,TCName,QCID,setupX,setupSD,calX,calSD,calCV,iNum)=""
	Set Num=0
	//If $Data(^DHCQCTC(LotParRef)) Do
	s LotParRef="" f  s LotParRef=$Order(^DHCQCTC(LotParRef)) Quit:LotParRef=""  Do
	.i ($l(LotParRef1)>2),(LotParRef1'=LotParRef) q
	.i $l(MachCode),$p($g(^DHCQCMAT($p(LotParRef,"||",1))),"^",3)'=MachCode q 
	.Set TCCode="" For  Set TCCode=$Order(^DHCQCTC(LotParRef,TCCode)) Quit:TCCode=""  Do
	..If $Length(TCode),TCode'[TCCode Quit
	..Set Seq="" For  Set Seq=$Order(^DHCQCTC(LotParRef,TCCode,Seq)) Quit:Seq=""  Do
	...Set str=$Get(^DHCQCTC(LotParRef,TCCode,Seq))
	...If $Length(QCLevel),QCLevel'[Seq Quit
	...Set Visible=$Piece(str,"^",3)
	...If Visible="N" Quit
	...Set Decimal=$Piece(str,"^",8)
	...If Decimal="" Set Decimal=2
	...Set setupX=$Piece(str,"^",6)
	...If setupX="0" Set setupX=""
	...If setupX'="" Set setupX=$FN(setupX,",",Decimal)
	...Set setupSD=$Piece(str,"^",7)
	...If setupSD="0.0" Set setupSD=""
	...If setupSD'="" Set setupSD=$FN(setupSD,",",Decimal)
	...s MatCode=$p(LotParRef,"||",1),LotCode=$p(LotParRef,"||",2)
	...//通过临时计算取值
	...s Ret=..CalTCStatXSD(MatCode,LotCode,TCCode,Seq,StartDate,EndDate,PointType)
	...Set calX=$Piece(Ret,"^",1)
	...If calX'="" Set calX=$FN(calX,",",Decimal)
	...Set calSD=$Piece(Ret,"^",2)
	...If calSD'="" Set calSD=$FN(calSD,",",Decimal)
	...Set calCV=$Piece(Ret,"^",3)
	...If calCV'="" Set calCV=$FN(calCV,",",Decimal)
	...Set Num=Num+1
	...Set QCID=Seq
	...Set TCName=$Piece(^TTAB("TC",TCCode),"\",1)
	...//增加质控个数
	...Set iNum=$Piece(Ret,"^",4)
	...i iNum=0 s iNum="",calX="",calSD="",calCV=""
	...Do OutTCXSD1
	If Num<1 Do OutTCXSD1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutTCXSD1
	set Data=$lb(TCCode,TCName,QCID,setupX,setupSD,calX,calSD,calCV,iNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod MatLotQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MatLotQueryExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else     
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MatLotQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MatLotQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20131119
/// Description:： 计算一段时间内批次质控物的靶值标准差
/// Table：        DHCQC_TestCode:质控项目,CT_TestCode:项目表,DHCQC_MachineQC:质控连接,DHCQC_ItemValue:质控项目结果
/// Input：        MatCode:质控物,LotCode:质控批号,TCCode:项目代码,epis:流水号,StartDate:开始日期，EndDate:结束日期
/// Output：       质控物的靶值标准差.
/// Return：       
/// Others：       
/// d ##class(web.DHCQCMatLotTc).CalTCStatXSD("CA1500","CA1500","A0490","1","2014-03-01","2014-03-01","True^True")
ClassMethod CalTCStatXSD(MatCode As %String, LotCode As %String, TCCode As %String, epis As %String, StartDate As %String, EndDate As %String, PointType As %String) As %String
{
  Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
  Set TCCode=$Get(TCCode),epis=$Get(epis),PointType=$g(PointType)
  Set Ret=""
  If MatCode="" Quit ""
  If LotCode="" Quit ""
  If TCCode="" Quit ""
  If epis="" Quit ""
  //---增加排除点,失控点控制----
  s ClearPoint=$p(PointType,"^",1)
  s OutPoint=$p(PointType,"^",2)
  //----------------------------
  Set MachineCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
  If MachineCode="" Quit ""
  Kill ^TMP("TCSTATXSD",$Job)
  //批号使用日期判断
  Set (LotStartDate,LotEndDate,CurLotFlag)=""
  If $Data(^DHCQCLOT(MatCode,LotCode)) Do
  .Set str=$Get(^DHCQCLOT(MatCode,LotCode))
  .Set CurLotFlag=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)
  //取此项目的小数点位
  Set MatLotRowId=MatCode_"||"_LotCode
  Set TCLevel=epis
  If $Data(^DHCQCTC(MatLotRowId,TCCode,TCLevel)) Do
  .Set TCDecimal=$Piece($Get(^DHCQCTC(MatLotRowId,TCCode,TCLevel)),"^",8)
  //项目结果之和,SD定义。
  Set TCTotalResult=0,TCCALResult=0,TCCALSD="",TCCALCV="",TCNum=0
  //查询当前批号内的数据。由于没有保存批号和质控物到业务表。只能通过条件判断。
  If $Data(^DHCQCIVi(MachineCode)) Do
  .Set CurDate="" For  Set CurDate=$Order(^DHCQCIVi(MachineCode,CurDate)) Quit:CurDate=""  Do
  ..If CurDate<StartDate Quit
  ..If CurDate>EndDate Quit 
  ..Set CurEpis="" For  Set CurEpis=$Order(^DHCQCIVi(MachineCode,CurDate,CurEpis)) Quit:CurEpis=""  Do
  ...Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,CurEpis,CurTCCode)) Quit:CurTCCode=""  Do
  ....If CurTCCode'=TCCode Quit 
  ....Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachineCode,CurDate,CurEpis,CurTCCode,OrdId)) Quit:OrdId=""  Do
  .....Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,CurEpis,CurTCCode,OrdId,RowId)) Quit:RowId=""  Do
  ......Set OrdData=$Get(^DHCQCIV(RowId,CurDate,OrdId))
  ......Set TCResult=$tR($Piece(OrdData,"^",3),",")
  ......Set ParRef=$Piece(OrdData,"^",6)
  ......Set TestRemoveData=$Piece($Get(OrdData),"^",12)
  ......//---排除点控制-------
  ......If (TestRemoveData=2) Quit
  ......If (TestRemoveData=1),(ClearPoint="True") Quit   
  ......//---失控点控制-------
  ......Set QCRul=$Piece(OrdData,"^",15)
  ......Set QCRulStatus=$Piece(OrdData,"^",16)
  ......i (OutPoint="True"),QCRulStatus="R" q   //必须是失控数据，排除警告数据
  ......//---------------------
  ......If $Length(MatCode),MatCode'=$Piece(ParRef,"||",1) Quit
  ......If $Length(LotCode),LotCode'=$Piece(ParRef,"||",2) Quit
  ......If $Length(TCLevel),TCLevel'=$Piece(ParRef,"||",3) Quit
  ......Set TCTotalResult=TCTotalResult+TCResult
  ......Set TCNum=TCNum+1
  ......Set ^TMP("TCSTATXSD",$Job,TCCode,TCNum)=TCResult
  Set TCCALResult="0.0000001",TCCALSD="0.0000001",TCCALCV="0.0000001"
  If TCNum>1 Do
  .Set TCCALResult=$Tr($FNUMBER(TCTotalResult/TCNum,",",TCDecimal),",")
  .Set TCEquData=0
  .//计算SD
  .Set CurNum="" For  Set CurNum=$Order(^TMP("TCSTATXSD",$Job,TCCode,CurNum)) Quit:CurNum=""  Do
  ..Set CurResult=$tR($Get(^TMP("TCSTATXSD",$Job,TCCode,CurNum)),",")
  ..Set TCEquData=TCEquData+((TCCALResult-CurResult)*(TCCALResult-CurResult))
  .Set TCCALSD=$FNUMBER($ZSQR(TCEquData/(TCNum-1)),",",TCDecimal)
  .If TCCALResult>0 Set TCCALCV=$FNUMBER((TCCALSD/TCCALResult)*100,",",TCDecimal)
  Kill ^TMP("TCSTATXSD",$Job)
  Set Ret=$Tr(TCCALResult,",")_"^"_$Tr(TCCALSD,",")_"^"_TCCALCV_"^"_TCNum
  Quit Ret
}

Storage Default
{
<Data name="DHCQCMatLotTcDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCMatLotTcD</DataLocation>
<DefaultData>DHCQCMatLotTcDefaultData</DefaultData>
<IdLocation>^web.DHCQCMatLotTcD</IdLocation>
<IndexLocation>^web.DHCQCMatLotTcI</IndexLocation>
<StreamLocation>^web.DHCQCMatLotTcS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
