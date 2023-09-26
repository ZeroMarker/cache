/// 名称: DHCWL.CheckFunData.CheckFunQuery
/// 描述: 标准值取数查询
/// 编写者：ans
/// 编写日期:2015-07-30
/// 
Class DHCWL.CheckFunData.CheckFunQuery Extends %Persistent
{

/// Creater:  ans
/// CreatDate:2015-07-30
/// Description:    1)查询一个方案中所有指标的标准值；
/// 				2)查询一个方案中某一个指标的所有对象的标准值；
/// 				3)查询一个方案中某一个指标某一个对象的标准值。
/// 				4)查询一个方案中一个对象在所有指标的标准值。
/// 				
/// Table: 		DHCWL_CheckFun.DHCWLCheckSet  DHCWL_CheckFun.DHCWLSetKpiRe DHCWL_CheckFun.DHCWLCheckKPI DHCWL_CheckFun.DHCWLStandardValSet DHCWL_CheckFun.DHCWLExceptValSet    
/// InPut:  	setCode:方案编码 date:查询日期,(格式:日-YYYYMMDD,月-YYYYMM,季-YYYYQ1, 年-YYYYY即 2015Y) kpiCode:考核指标Code:可以为空 obID:考核对象ID  可以为空 ,objType:对象属性，传入格式：dimPro1^dimPro2 可以为空 为空取默认属性
/// OutPut:     setId:方案Id,setCode:方案Code,setDesc:方案描述,kpiId:指标Id,kpiCode:指标Code,kpiDesc:指标描述,objId:对象id,objDesc:对象描述,value:值
/// Exe:        do ##class(DHCWL.CheckFunData.CheckFunQuery).test1()
/// Other:    do ##class(DHCWL.CheckFunData.CodeTypeItemQuery).GetObjItem(setId)
/// d ##class(%ResultSet).RunQuery("DHCWL.CheckFunData.CheckFunQuery","QueryBySetId","test2","201503","","","LocDesc^LocCodde")  
Query QueryBySetId(setCode As %String, date As %String, kpiCode As %String = "", obID As %String = "", obType As %String) As %Query(ROWSPEC = "setId:%String,setCode:%String,setDesc:%String,kpiId:%String,mkpiCode:%String,kpiDesc:%String,objId:%String,objDesc:%String,value:%Double") [ SqlProc ]
{
}

ClassMethod QueryBySetIdExecute(ByRef qHandle As %Binary, setCode As %String, date As %String, kpiCode As %String = "", obID As %String = "", obType As %String) As %Status
{
	 set repid=$I(^CacheTemp)
	 if $g(ind)="" Set ind=1
	 set qHandle=$lb(0,repid,0)
	 q:setCode="" $$$OK
	 q:date="" $$$OK
	 //q:obType="" $$$OK
	 k ^TEMPDHCWL($j)
	 s setCode=$zconvert(setCode,"U")
	 s setId=$o(^DHCWL.CheckFun.CheckSetI("Code",setCode,""))
	 q:setId="" $$$OK
	 s kpId=""
	 i kpiCode'="" d
	 .s kpiCode=$zconvert(kpiCode,"U")
	 .s kpId=$o(^DHCWL.CheckFun.CheckKPII("Code",kpiCode,""))
	 ;modify by ans if obType is null default property
	 i obType'="" s mobType=obType
	 e  d
	 .s dimId=$list(^DHCWL.CheckFun.CheckSetD(setId),5)
	 .s dimProId=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimId,"Y",""))
	 .s dimProCode=$list(^DHCWL.MKPI.DimPropertyD(dimProId),3)
	 .s mobType=dimProCode
	 //q:kpId="" $$$OK
	 do ##class(DHCWL.CheckFunData.CodeTypeItemQuery).GetObjItem(setId,mobType)
	 s kpiId="" f  s kpiId=$o(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId)) q:kpiId=""  d
	 .s mDate=""
	 .i $d(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId," "_date)) d
	 ..s mDate=" "_$g(date)
	 .e  d
	 ..s sDate=" "_date
	 ..s sDate=$o(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,sDate),-1)
	 ..i sDate'="" s mDate=$g(sDate)
	 ..;b ;0001
	 .q:mDate=""
	 .s ^TEMPDHCWL($j,"kpiDate",kpiId)=$g(mDate)
	 s kpiId="" f  s kpiId=$o(^TEMPDHCWL($j,"kpiDate",kpiId)) q:kpiId=""  d
	 .s mDate=$g(^TEMPDHCWL($j,"kpiDate",kpiId))
	 .s stId=""  f  s stId=$o(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,mDate,stId)) q:stId=""  d
	 ..s value=$list(^DHCWL.CheckFun.StandardValSetD(stId),4)
	 ..s objId="" f  s objId=$o(^TEMPDHCWL("objId",objId)) q:objId=""  d
	 ...s ^TEMPDHCWL($j,"value",setId,kpiId,objId)=$g(value)
	 ..s excId="" f  s excId=$o(^DHCWL.CheckFun.ExceptValSetI("Stand",stId,excId)) q:excId=""  d
	 ...s mObjId=$list(^DHCWL.CheckFun.ExceptValSetD(excId),3)
	 ...s excValue=$list(^DHCWL.CheckFun.ExceptValSetD(excId),4)
	 ...s ^TEMPDHCWL($j,"value",setId,kpiId,mObjId)=$g(excValue)
	 s setId="" f  s setId=$o(^TEMPDHCWL($j,"value",setId)) q:setId=""  d
	 .s setDesc=$list(^DHCWL.CheckFun.CheckSetD(setId),3)
	 .
	 .s kpiId="" f  s kpiId=$o(^TEMPDHCWL($j,"value",setId,kpiId)) q:kpiId=""  d
	 ..s kpiDesc=$list(^DHCWL.CheckFun.CheckKPID(kpiId),3)
	 ..s mkpiCode=$list(^DHCWL.CheckFun.CheckKPID(kpiId),2)
	 ..s objId="" f  s objId=$o(^TEMPDHCWL($j,"value",setId,kpiId,objId)) q:objId=""  d
	 ...s objDesc=$g(^TEMPDHCWL("objId",objId)) 
	 ...s value=$g(^TEMPDHCWL($j,"value",setId,kpiId,objId))
	 ...q:(obID'="")&&(obID'=objId)
	 ...q:(kpId'="")&&(kpId'=kpiId)
     ...d OutputRow1
     k ^TEMPDHCWL($j)
     k ^TEMPDHCWL("objId")
	 Quit $$$OK
OutputRow1
     s data=$lb(setId,setCode,setDesc,kpiId,mkpiCode,kpiDesc,objId,objDesc,value)
     Set ^CacheTemp(repid,ind)=data
     Set ind=ind+1
     quit
}

ClassMethod QueryBySetIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBySetIdExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryBySetIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBySetIdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
}
  Else 
{
	Set Row=^CacheTemp(repid,ind)
	}
 //Save Qhandle
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod test1()
{
	d ##class(%ResultSet).RunQuery("DHCWL.CheckFunData.CheckFunQuery","QueryBySetId","test9","201501","","","LocDesc^LocCode")
}

Storage Default
{
<Data name="CheckFunQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CheckF9DFF.CheckFunQueryD</DataLocation>
<DefaultData>CheckFunQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CheckF9DFF.CheckFunQueryD</IdLocation>
<IndexLocation>^DHCWL.CheckF9DFF.CheckFunQueryI</IndexLocation>
<StreamLocation>^DHCWL.CheckF9DFF.CheckFunQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
