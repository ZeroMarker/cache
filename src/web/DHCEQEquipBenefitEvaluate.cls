Class web.DHCEQEquipBenefitEvaluate Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQEquipBenefitEvaluate where EBE_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //EquipDR
 s EquipDR=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //Year
 s Year=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //Material
 s PLIST(5)=$P(val,"^",5) //OperatorCount
 s PLIST(6)=$P(val,"^",6) //MedicalItem
 s PLIST(7)=$P(val,"^",7) //YearRunTime
 s PLIST(8)=$P(val,"^",8) //FeeOfEmployee
 s PLIST(9)=$P(val,"^",9) //UsePerMonthNum
 s PLIST(10)=$P(val,"^",10) //WorkLoadPerMonthNum
 s PLIST(11)=$P(val,"^",11) //ReclaimYearsNum
 s PLIST(12)=$P(val,"^",12) //UseRate
 s PLIST(13)=$P(val,"^",13) //GoodRate
 s PLIST(14)=$P(val,"^",14) //YearIncomeFee
 s PLIST(15)=$P(val,"^",15) //CostFee
 s PLIST(16)=$P(val,"^",16) //YearMaintFee
 s PLIST(17)=$P(val,"^",17) //ClinicEffect
 s PLIST(18)=$P(val,"^",18) //ResoureState
 s PLIST(19)=$P(val,"^",19) //WaterPerMonthNum
 s PLIST(20)=$P(val,"^",20) //ElectricityPerMonthNum
 s PLIST(21)=$P(val,"^",21) //ComeIncreaseRate
 s PLIST(22)=$P(val,"^",22) //OutIncreaseRate
 s PLIST(23)=$P(val,"^",23) //Hold1
 s PLIST(24)=$P(val,"^",24) //Hold2
 s PLIST(25)=$P(val,"^",25) //Hold3
 s PLIST(26)=$P(val,"^",26) //Hold4
 s PLIST(27)=$P(val,"^",27) //Hold5

 s RowidFind=""
 i (rowid="")  //新增按钮操作
 {
	 //检测当前记录是否已经存在
	 &SQL(select EBE_RowID into :RowidFind from SQLUSER.DHC_EQEquipBenefitEvaluate where EBE_Year=:Year and EBE_EquipDR=:EquipDR)
	 i (RowidFind="") //当前记录为新记录,否则已经存在
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQEquipBenefitEvaluate Values :PLIST())
	 }
 }
 else  //更新按钮操作
 {
	 &SQL(select EBE_RowID into :RowidFind from SQLUSER.DHC_EQEquipBenefitEvaluate where EBE_Year=:Year and EBE_EquipDR=:EquipDR)

	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQEquipBenefitEvaluate Values :PLIST() where EBE_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQEquipBenefitEvaluate Values :PLIST() where EBE_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

//d ##class(%ResultSet).RunQuery("web.DHCEQEquipBenefitEvaluate","GetBenefitEvaluate")

Query GetBenefitEvaluate(Year As %String = "", EquipDR As %String = "", YearIncomeFee As %String = "", WorkLoadPerMonthNum As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TYear:%String,TMaterial:%String,TOperatorCount:%String,TMedicalItem:%String,TYearRunTime:%String,TFeeOfEmployee:%String,TUsePerMonthNum:%String,TWorkLoadPerMonthNum:%String,TReclaimYearsNum:%String,TUseRate:%String,TGoodRate:%String,TYearIncomeFee:%String,TCostFee:%String,TYearMaintFee:%String,TClinicEffect:%String,TResoureState:%String,TWaterPerMonthNum:%String,TElectricityPerMonthNum:%String,TComeIncreaseRate:%String,TOutIncreaseRate:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetBenefitEvaluateExecute(ByRef qHandle As %Binary, Year As %String = "", EquipDR As %String = "", YearIncomeFee As %String = "", WorkLoadPerMonthNum As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBenefitEvaluate
	Quit $$$OK
BuildDataGetBenefitEvaluate
	f  s rowid=$o(^DHCEQEquipBenefitEvaluate(rowid)) q:rowid=""  d
	.d ResetVariablesGetBenefitEvaluate
	.s TRowID=rowid
	.s TEquipDR=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",1)
	.q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	.i TEquipDR'="" d
	..s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TYear=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",2)
	.s TMaterial=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",3)
	.s TOperatorCount=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",4)
	.s TMedicalItem=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",5)
	.s TYearRunTime=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",6)
	.s TFeeOfEmployee=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",7)
	.s TUsePerMonthNum=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",8)
	.s TWorkLoadPerMonthNum=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",9)
	.s TReclaimYearsNum=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",10)
	.s TUseRate=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",11)
	.s TGoodRate=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",12)
	.s TYearIncomeFee=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",13)
	.s TCostFee=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",14)
	.s TYearMaintFee=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",15)
	.s TClinicEffect=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",16)
	.s TResoureState=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",17)
	.s TWaterPerMonthNum=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",18)
	.s TElectricityPerMonthNum=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",19)
	.s TComeIncreaseRate=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",20)
	.s TOutIncreaseRate=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",21)
	.s THold1=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",22)
	.s THold2=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",23)
	.s THold3=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",24)
	.s THold4=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",25)
	.s THold5=$p($g(^DHCEQEquipBenefitEvaluate(rowid)),"^",26)
	.d OutputRowGetBenefitEvaluate
	quit
OutputRowGetBenefitEvaluate
	s Data=$lb(TRowID,TEquipDR,TEquipName,TEquipNo,TYear,TMaterial,TOperatorCount,TMedicalItem,TYearRunTime,TFeeOfEmployee,TUsePerMonthNum,TWorkLoadPerMonthNum,TReclaimYearsNum,TUseRate,TGoodRate,TYearIncomeFee,TCostFee,TYearMaintFee,TClinicEffect,TResoureState,TWaterPerMonthNum,TElectricityPerMonthNum,TComeIncreaseRate,TOutIncreaseRate,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBenefitEvaluate
	s (TRowID,TEquipDR,TEquipName,TEquipNo,TYear,TMaterial,TOperatorCount,TMedicalItem,TYearRunTime,TFeeOfEmployee,TUsePerMonthNum,TWorkLoadPerMonthNum,TReclaimYearsNum,TUseRate,TGoodRate,TYearIncomeFee,TCostFee,TYearMaintFee,TClinicEffect,TResoureState,TWaterPerMonthNum,TElectricityPerMonthNum,TComeIncreaseRate,TOutIncreaseRate,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetBenefitEvaluateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitEvaluateExecute ]
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

ClassMethod GetBenefitEvaluateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitEvaluateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQEquipBenefitEvaluate(rowid))
	s resultex=resultex_"^"
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	.s resultex=resultex_"^"_$p($g(^DHCEQEquip($p(result,"^",1))),"^",71)
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

Storage Default
{
<Data name="DHCEQEquipBenefitEvaluateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQEquipBenefitEvaluateD</DataLocation>
<DefaultData>DHCEQEquipBenefitEvaluateDefaultData</DefaultData>
<IdLocation>^web.DHCEQEquipBenefitEvaluateD</IdLocation>
<IndexLocation>^web.DHCEQEquipBenefitEvaluateI</IndexLocation>
<StreamLocation>^web.DHCEQEquipBenefitEvaluateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
