Class web.DHCEQPrescriptionList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s SQLCODE=0
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		&SQL(Delete From sqluser.DHC_EQPrescriptionList where PL_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s PrescriptionDR=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s FromActionDR=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	i $p(val,"^",7)'=""  s PLIST(7)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"bool")
	i $p(val,"^",8)'=""  s PLIST(8)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"bool")
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)
	s PLIST(11)=$p(val,"^",11)
	s PLIST(12)=$p(val,"^",12)
	s PLIST(13)=$p(val,"^",13)
	
	s Find=""
	i FromActionDR'=""  d
	.&SQL(Select PL_RowID Into :Find From SQLUSER.DHC_EQPrescriptionList Where PL_PrescriptionDR=:PrescriptionDR and PL_FromAction=:FromActionDR)
	e  d
	.&SQL(Select PL_RowID Into :Find From SQLUSER.DHC_EQPrescriptionList Where PL_PrescriptionDR=:PrescriptionDR and PL_FromAction is null)
	i (Find'="")	//重复记录判断
	{
		i ((rowid="")||(Find'=rowid)) q -1001
	}
	
	if rowid=""
	{
		&SQL(Insert Into sqluser.DHC_EQPrescriptionList Values :PLIST())
		i SQLCODE q SQLCODE
		s ID=$G(%ROWID)
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQPrescriptionList Values :PLIST() where PL_RowID = :rowid)
		i SQLCODE q SQLCODE
		s ID=rowid
	}
	
	q ID
}

/// 需求号730075，modified by kdf 2018-10-26 增加输出列序号TRow的显示
Query PrescriptionList(PRowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TFromAction:%String,TTimeNum:%String,TTimeUnit:%String,TAlarmNum:%String,TActiveTimeFlag:%String,TActivePreFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod PrescriptionListExecute(ByRef qHandle As %Binary, PRowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i PRowID="" Quit $$$OK
 	
	s index=1
	s PLRowID=0
	f  s PLRowID=$o(^DHCEQPrescriptionList(0,"Prescription",PRowID,PLRowID)) quit:PLRowID=""  d
	.d ResetVariablesGetPrescriptionList
	.s TRowID=PLRowID
	.s TFromActionDR=$p($g(^DHCEQPrescriptionList(TRowID)),"^",2)
	.i TFromActionDR'="" s TFromAction=$p($g(^DHCEQCCode("DHCEQCAction",TFromActionDR)),"^",2)
	.i TFromActionDR=0 s TFromAction="提交"
	.s TTimeNum=$p($g(^DHCEQPrescriptionList(TRowID)),"^",3)
	.s TTimeUnitDR=$p($g(^DHCEQPrescriptionList(TRowID)),"^",4)
	.i TTimeUnitDR'="" s TTimeUnit=$p($g(^DHCEQCCode("DHCEQCCycleUnit",TTimeUnitDR)),"^",2)
	.s TAlarmNum=$p($g(^DHCEQPrescriptionList(TRowID)),"^",5)
	.s TActiveTimeFlag=$p($g(^DHCEQPrescriptionList(TRowID)),"^",6)
	.i TActiveTimeFlag'="" s TActiveTimeFlag=##class(web.DHCEQCommon).TransValueToPage(TActiveTimeFlag,"bool")
	.S TActivePreFlag=$p($g(^DHCEQPrescriptionList(TRowID)),"^",7)
	.i TActivePreFlag'="" s TActivePreFlag=##class(web.DHCEQCommon).TransValueToPage(TActivePreFlag,"bool")
	.s THold1=$p($g(^DHCEQPrescriptionList(TRowID)),"^",8)
	.s THold2=$p($g(^DHCEQPrescriptionList(TRowID)),"^",9)
	.s THold3=$p($g(^DHCEQPrescriptionList(TRowID)),"^",10)
	.s THold4=$p($g(^DHCEQPrescriptionList(TRowID)),"^",11)
	.s THold5=$p($g(^DHCEQPrescriptionList(TRowID)),"^",12)
	.s TRow=index     ;需求号730075，modified by kdf 2018-10-26 
	.d OutputRowGetPrescriptionList
	Quit $$$OK
OutputRowGetPrescriptionList
	s Data=$lb(TRowID,TFromAction,TTimeNum,TTimeUnit,TAlarmNum,TActiveTimeFlag,TActivePreFlag,THold1,THold2,THold3,THold4,THold5,TRow) ;需求号730075，modified by kdf 2018-10-26 
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPrescriptionList
	s (TRowID,TFromAction,TTimeNum,TTimeUnit,TAlarmNum,TActiveTimeFlag,TActivePreFlag,THold1,THold2,THold3,THold4,THold5,TRow)=""  ;需求号730075，modified by kdf 2018-10-26 
	quit
}

ClassMethod PrescriptionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrescriptionListExecute ]
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

ClassMethod PrescriptionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrescriptionListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetPrescriptionListByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQPrescriptionList(rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",2)'=""  d
	.i $p(result,"^",2)="0"  d
	..s resultex=resultex_"提交"
	.e  d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAction",$p(result,"^",2))),"^",2) //开始动作
	s resultex=resultex_"^"	//2
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCycleUnit",$p(result,"^",4))),"^",2) //单位
	s resultex=resultex_"^"	//3
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"bool")	//激活时效标识
	s resultex=resultex_"^"	//4
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"bool")	//是否优先标识
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_"^"_resultex
}

}
