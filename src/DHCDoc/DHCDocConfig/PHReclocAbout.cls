Class DHCDoc.DHCDocConfig.PHReclocAbout Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PHReclocAbout","GetItemCatExtConfig","")
Query GetItemCatExtConfig(PHRecloc As %String, HospId As %String) As websys.Query(ROWSPEC = "ItemCatDr:%String,ItemCatDesc:%String,NormSplitPackQty:%String,EMAutoCreatONEOrd:%String,EnableIPDispensingMode:%String")
{
}

ClassMethod GetItemCatExtConfigExecute(ByRef qHandle As %Binary, PHRecloc As %String, HospId As %String) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 1
	if (+PHRecloc=0){
		set qHandle = $lb(0,repid,0)
		Q $$$OK
	}
	s ItemCatDr=0
	for {
		
		s ItemCatDr=$O(^ARC("IC",ItemCatDr))
		q:(ItemCatDr="")
		s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
		continue:(OrderType'="R")
		continue:(##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ItemCatDr,HospId)="N")
		s ItemCatDesc=$P(^ARC("IC",ItemCatDr),"^",2)
		s Value=$G(^CTLOC(PHRecloc,"Doc","PHReclocAbout",ItemCatDr))
		;临时医嘱拆分整包装发药
		s NormSplitPackQty=$P(Value,"^",1)
		s NormSplitPackQty=##Class(DHCDoc.DHCDocConfig.LocExt).FormatValue(NormSplitPackQty)
		;急诊虚拟长期医嘱自动计算插入取药医嘱
		s EMAutoCreatONEOrd=$P(Value,"^",2)
		s EMAutoCreatONEOrd=##Class(DHCDoc.DHCDocConfig.LocExt).FormatValue(EMAutoCreatONEOrd)
		;启用住院发药模式
		s EnableIPDispensingMode=$P(Value,"^",3)
		s EnableIPDispensingMode=##Class(DHCDoc.DHCDocConfig.LocExt).FormatValue(EnableIPDispensingMode)
		d OutPutGetItemCatExtConfig
	}
	
	
	set qHandle = $lb(0,repid,0)
	Q $$$OK
OutPutGetItemCatExtConfig
	Set ^CacheTemp(repid,ind)=$LB(ItemCatDr,ItemCatDesc,NormSplitPackQty,EMAutoCreatONEOrd,EnableIPDispensingMode)
	Set ind=ind+1
	quit
}

ClassMethod SetPHReclocAboutItemCatExtValue(PHRecloc As %String, ItemCatDr As %String, DHCFieldNumStr As %String, ValStr As %String) As %String
{
	if (+PHRecloc=0)||(+ItemCatDr=0){
		q -100
	}
   For i=1:1:$l(DHCFieldNumStr,"^") d
   .s DHCFieldNum=$p(DHCFieldNumStr,"^",i)
   .s Val=$p(ValStr,"^",i)
   .s $P(^CTLOC(PHRecloc,"Doc","PHReclocAbout",ItemCatDr),"^",DHCFieldNum)=Val
   q 0
}

ClassMethod GetPHRecLocAboutFieldValue(PHRecloc As %String, ItemCatDr As %String, DHCFieldNum As %String) As %String
{
	q:(+PHRecloc=0)||(+ItemCatDr=0)||(+DHCFieldNum=0) 0
	
	s Str=$G(^CTLOC(PHRecloc,"Doc","PHReclocAbout",ItemCatDr))
	s Value=+$P(Str,"^",DHCFieldNum)
	
	q Value
}

/// 获取配置为Y的接受科室列表
ClassMethod GetPHRecLocListByField(ItemCatDr As %String, DHCFieldNum As %String) As %String
{
	s PHRecLocList=""
	q:(+ItemCatDr=0)||(+DHCFieldNum=0) ""
	
	s PHRecloc=""
	for {
		s PHRecloc=$O(^CTLOC(PHRecloc))
		q:(PHRecloc="")
		s Str=$G(^CTLOC(PHRecloc,"Doc","PHReclocAbout",ItemCatDr))
		s Value=+$P(Str,"^",DHCFieldNum)
		if (Value="1"){
			if (PHRecLocList=""){
				s PHRecLocList=PHRecloc
			}else{
				s PHRecLocList=PHRecLocList_"^"_PHRecloc
			}
		}
		
	}
	q PHRecLocList
}

}
