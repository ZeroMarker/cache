Class web.DHCQCSTATTCXSD Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20120630
/// Description:： 计算一个批次质控物的靶值标准差
/// Table：        DHCQC_TestCode:质控项目,CT_TestCode:项目表,DHCQC_MachineQC:质控连接,DHCQC_ItemValue:质控项目结果
/// Input：        MatCode:质控物,LotCode:质控批号,TCCode:项目代码,epis:流水号,CurDate:当前日期
/// Output：       质控物的靶值标准差.
/// Return：       
/// Others：       
/// d ##class(web.DHCQCSTATTCXSD).TCSTATXSD("CA1500","CA1500","A1130","2","2013-12-2")
ClassMethod TCSTATXSD(MatCode As %String, LotCode As %String, TCCode As %String, epis As %String, QCDate As %String) As %String
{
  //Set MatCode="BDXC600",LotCode="1234567",QCDate="2013-1-16",TCCode="B2430",epis="902"
  Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),QCDate=$Get(QCDate)
  Set TCCode=$Get(TCCode),epis=$Get(epis)
  If QCDate="" Do  Set QCDate=+$H
  Else  Set QCDate=$ZDH(QCDate,3)
  Set Ret=""
  If MatCode="" Quit ""
  If LotCode="" Quit ""
  If TCCode="" Quit ""
  If epis="" Quit ""
  Set MachineCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
  //增加月份统计功能
  Set CurDate=$ZD(QCDate,3)
  If MachineCode="" Quit ""
  Set Ret=##class(web.DHCQCAccTotal).AccTCTotal(MachineCode,MatCode,LotCode,CurDate,TCCode,epis)
  //批号使用日期判断
  Set (LotStartDate,LotEndDate,CurLotFlag)=""
  If $Data(^DHCQCLOT(MatCode,LotCode)) Do
  .Set str=$Get(^DHCQCLOT(MatCode,LotCode))
  .Set StartDate=$Piece(str,"^",3)
  .Set EndDate=$Piece(str,"^",4)
  .Set CurLotFlag=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)
  If StartDate="" Quit ""
  If EndDate="" Quit ""
  If QCDate<StartDate Quit ""
  If QCDate>EndDate Quit ""
  //If CurLotFlag'="Y" Quit ""
  //取此项目的小数点位
  Set MatLotRowId=MatCode_"||"_LotCode
  //Set TCDecimal=0
  //Set TCLevel=##class(web.DHCQCMaterialQuery).MatLotLevelNo(MachineCode,MatCode,LotCode,epis,$ZD(QCDate,3))
  //If TCLevel="" Set TCLevel=##class(web.DHCQCMaterialQuery).MatLotLevelNoEpis(MachineCode,MatCode,LotCode,epis,$ZD(QCDate,3))
  //If TCLevel="" Quit ""
  Set TCLevel=epis
  If $Data(^DHCQCTC(MatLotRowId,TCCode,TCLevel)) Do
  .Set TCDecimal=$Piece($Get(^DHCQCTC(MatLotRowId,TCCode,TCLevel)),"^",8)
  //项目结果之和,SD定义。
  Set TCTotalResult="",TCCALResult="",TCCALSD="",TCCALCV="",TCNum=""
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
  ......Set TCResult=$Piece(OrdData,"^",3)
  ......Set ParRef=$Piece(OrdData,"^",6)
  ......Set TestRemoveData=$Piece($Get(OrdData),"^",12)
  ......If TestRemoveData=2 Quit
  ......If $Length(MatCode),MatCode'=$Piece(ParRef,"||",1) Quit
  ......If $Length(LotCode),LotCode'=$Piece(ParRef,"||",2) Quit
  ......If $Length(TCLevel),TCLevel'=$Piece(ParRef,"||",3) Quit
  ......Set TestRuleResult=$Piece($Get(OrdData),"^",16)
  ......//If TestRuleResult="R" Quit  //失控数据不纳入统计SD范畴
  ......Set TCTotalResult=TCTotalResult+TCResult
  ......Set TCNum=TCNum+1
  ......Set ^TMP("TCSTATXSD",$Job,TCCode,TCNum)=TCResult
  If TCNum>1 Do
  .Set TCCALResult=$Tr($FNUMBER(TCTotalResult/TCNum,",",TCDecimal),",")
  .Set TCEquData="",TCCALCV=""
  .//计算SD
  .Set CurNum="" For  Set CurNum=$Order(^TMP("TCSTATXSD",$Job,TCCode,CurNum)) Quit:CurNum=""  Do
  ..Set CurResult=$Get(^TMP("TCSTATXSD",$Job,TCCode,CurNum))
  ..Set TCEquData=TCEquData+((TCCALResult-CurResult)*(TCCALResult-CurResult))
  .Set TCCALSD=$Tr($FNUMBER($ZSQR(TCEquData/(TCNum)),",",TCDecimal),",")
  .If TCCALResult>0 Set TCCALCV=$FNUMBER((TCCALSD/TCCALResult)*100,",",TCDecimal)
  .Kill ^TMP("TCSTATXSD",$Job)
  .&SQL(UPDATE lab.DHCQC_TestCode Set DTCL_CALCMean=:TCCALResult,DTCL_CALCSD=:TCCALSD,DQCI_CalcCV=:TCCALCV,
   DTAT_AC_TCSum=:TCNum,DTAT_AC_TCMean=:TCCALResult,DTAT_AC_SD=:TCCALSD 
   WHERE DQCI_ParRef=:MatLotRowId And DQCI_TestCode_DR=:TCCode And DQCI_DisplaySequence=:TCLevel)
  .Set Ret=SQLCODE
  Quit Ret
}

ClassMethod QCTCSTATClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QCTCSTATExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCSTATTCXSD","QCTCSTAT","ACA530","ACA530-1","A0490")
ClassMethod QCTCSTATExecute(ByRef qHandle As %Binary, MatCode As %String, LotCode As %String, TCCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),TCCode=$Get(TCCode)
	Set LotParRef=MatCode_"||"_LotCode
	If $Data(^DHCQCTC(LotParRef)) Do
	.If $Data(^DHCQCTC(LotParRef,TCCode)) Do
	..Set Seq="" For  Set Seq=$Order(^DHCQCTC(LotParRef,TCCode,Seq)) Quit:Seq=""  Do
	...Set str=$Get(^DHCQCTC(LotParRef,TCCode,Seq))
	...Set Visible=$Piece(str,"^",3)
	...If Visible="N" Quit
	...Set Dilutes=$Piece(str,"^",2)
	...Set TargetDesc=$Piece(str,"^",5)
	...Set TargetValue=$Piece(str,"^",6)
	...If TargetValue="0" Set TargetValue=""
	...Set TargetSD=$Piece(str,"^",7)
	...If TargetSD="0.0" Set TargetSD=""
	...Set Decimal=$Piece(str,"^",8)
	...Set CALCMean=$Piece(str,"^",9)
	...If CALCMean="0.0" Set CALCMean=""
	...Set CALCSD=$Piece(str,"^",10)
	...If CALCSD="0.0" Set CALCSD=""
	...Set CalcCV=$Piece(str,"^",11)
	...If CalcCV="0.0" Set CalcCV=""
	...//AutstFlag:MeanType
	...Set Autstorage=$Piece(str,"^",12)
	...Set Comments=$Piece(str,"^",13)
	...Set ACTCSum =$Piece(str,"^",14)
	...If ACTCSum="0" Set ACTCSum=""
	...Set ACTCMean =$Piece(str,"^",15)
	...If ACTCMean="0.0" Set ACTCMean=""
	...Set ACSD=$Piece(str,"^",16)
	...If ACSD="0.0" Set ACSD=""
	...Set RowId=MatCode_"||"_LotCode_"||"_TCCode_"||"_Seq
	...Do OutTCXSD
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutTCXSD
	set Data=$lb(Seq,Dilutes,TargetDesc,TargetValue,TargetSD,Decimal,CALCMean,CALCSD,CalcCV,Autstorage,Comments,ACTCSum,ACTCMean,ACSD,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QCTCSTATFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QCTCSTATExecute ]
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
/// CreatDate：    20101102
/// Description:： 按照批次，项目信息查询此项目的统计信息。
/// Table：        DHCQC_AccTotal
/// Input：        LotParRef:质控批号,MatCode:质控物代码，TCCode：项目代码
/// Output：       项目浓度设置信息
/// Return：       
/// Others：       Autstorage:MeanType是否使用上月计算值为设定标准差             
Query QCTCSTAT(MachineCode As %String, MatCode As %String, LotCode As %String, StartDate As %String, EndDate As %String, TCCode As %String) As %Query(ROWSPEC = "Seq:%String,Dilutes:%String,TargetDesc:%String,TargetValue:%String,TargetSD:%String,Decimal:%String,CALCMean:%String,CALCSD:%String,CalcCV:%String,Autstorage:%String,Comments:%String,ACTCSum:%String,ACTCMean:%String,ACSD:%String,RowId:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCQCSTATTCXSDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCSTATTCXSDD</DataLocation>
<DefaultData>DHCQCSTATTCXSDDefaultData</DefaultData>
<IdLocation>^web.DHCQCSTATTCXSDD</IdLocation>
<IndexLocation>^web.DHCQCSTATTCXSDI</IndexLocation>
<StreamLocation>^web.DHCQCSTATTCXSDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
