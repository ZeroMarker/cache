/// 名称: web.DHCMedInfService
/// 描述: 院感对外接口
/// 编写日期: 2010-02-24
Class web.DHCMedInfService Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 43;

/// 作用:    	根据paadm查询当前患者的该次就诊是否有退回报告
///         	如果有，返回退回原因列表，否则返回空值。
/// 入参:		Paadm
/// 返回值: 	ret="":无退回报告
/// 编写者:  	刘宇辉
/// 编写日期:	2010-02-24
/// 调用方法：	d ##Class(web.DHCMedInfService).IsReturnReport(Paadm)
ClassMethod IsReturnReport(Paadm)
{
	n (Paadm)

	q:Paadm="" ""
	s rowid=0,ret=""
	
	f  s rowid=$o(^DHCMedIR(0,"PAADM",Paadm,rowid)) q:rowid=""  d
	.i $p(^DHCMedIR(rowid),"^",11)=9  d   //9为退回报告
	..s UserDr=$p(^DHCMedIR(rowid),"^",10)
	..s:UserDr'="" RepUser=$p($g(^SSU("SSUSR",UserDr)),"^",2)
	..s RepDate=$zd($p(^DHCMedIR(rowid),"^",8),3)
	..s ret=ret_" 报告人: "_RepUser_" 报告时间: "_RepDate_" 退回原因: "_$p(^DHCMedIR(rowid),"^",15)_$c(13)_$c(10)
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-07-14
/// Description:  通过paadm查询病原体与抗菌药物是否敏感
/// Table：       DHC_MedInfectionRep
/// Input：       paadm
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.Interface","QueryInfPyObjDrugByPaadm",1)
Query QueryInfPyObjDrugByPaadm(paadm As %String) As %Query(ROWSPEC = "PathogenName:%String:菌名称,DrugName:%String:抗生素,flag:%String:药敏结果")
{
}

ClassMethod QueryInfPyObjDrugByPaadmExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:paadm="" $$$OK
	Quit:'$d(^DHCMedIR(0,"PAADM",paadm)) $$$OK
	
	;w "paadm="_paadm,!
	;s Data=$lb("ObjectName","DrugName","flag")
	;s ^CacheTemp(repid,ind)=Data
 	;s ind=ind+1
	;s Data=$lb("Object:","Drug:"," flag")
	;s ^CacheTemp(repid,ind)=Data
 	;s ind=ind+1

	
	
	Set rowid=""
	For  Set rowid=$o(^DHCMedIR(0,"PAADM",paadm,rowid)) Quit:rowid=""  Do
	.Set PYSubID=""
	.For  Set PYSubID=$o(^DHCMedIR(rowid,"PY",PYSubID)) Quit:PYSubID=""  Do
	..Set DrugFlag=$p($g(^DHCMedIR(rowid,"PY",PYSubID)),"^",5)
	..;Quit:DrugFlag'="Y"		// 药敏实验标志
	..Set MIRPOSubID=""
	..For  Set MIRPOSubID=$o(^DHCMedIR(rowid,"PY",PYSubID,"O",MIRPOSubID)) Quit:MIRPOSubID=""  Do
	...Set ObjectDr=$Piece($Get(^DHCMedIR(rowid,"PY",PYSubID,"O",MIRPOSubID)),"^",1)
	...Quit:ObjectDr=""
	...Set ObjectName=$Piece($Get(^DHCMInfPD(ObjectDr)),"^",2)
	...Quit:ObjectName=""
	...Set MIRPODIDSubID=""
	...For  Set MIRPODIDSubID=$o(^DHCMedIR(rowid,"PY",PYSubID,"O",MIRPOSubID,"D",MIRPODIDSubID)) Quit:MIRPODIDSubID=""  Do
	....Set DrugDr=$Piece($Get(^DHCMedIR(rowid,"PY",PYSubID,"O",MIRPOSubID,"D",MIRPODIDSubID)),"^",1)
	....Quit:DrugDr=""
	....Set DrugName=$Piece($Get(^DHCMInfAD(DrugDr)),"^",2)
	....Quit:DrugName=""
	....Set PODFlag=$Piece($Get(^DHCMedIR(rowid,"PY",PYSubID,"O",MIRPOSubID,"D",MIRPODIDSubID)),"^",2)
	....Set flag=$Select(PODFlag="Y":"敏感",PODFlag="N":"不敏感",1:"")
	....Quit:flag=""
	....s Data=$lb(ObjectName,DrugName,flag)
 	....s ^CacheTemp(repid,ind)=Data
 	....s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryInfPyObjDrugByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInfPyObjDrugByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInfPyObjDrugByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInfPyObjDrugByPaadmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="DHCMedInfServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMedInfServiceD</DataLocation>
<DefaultData>DHCMedInfServiceDefaultData</DefaultData>
<IdLocation>^web.DHCMedInfServiceD</IdLocation>
<IndexLocation>^web.DHCMedInfServiceI</IndexLocation>
<StreamLocation>^web.DHCMedInfServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
