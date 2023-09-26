/// 试剂信息
Class web.DHCREAGReagent Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 117;

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, code As %String, name As %String, syn As %String, visible As %String, packageSize As %String, unit As %String, groupType As %String, supplier As %String, manufact As %String) As %Status
{
	s code=$g(code),name=$g(name),syn=$g(syn),visible=$g(visible),packageSize=$g(packageSize)
	s unit=$g(unit),groupType=$g(groupType),supplier=$g(supplier),manufact=$g(manufact)
	s ^TMP($zn,"para")=code_","_name_","_syn_","_visible_","_packageSize
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s seq="" f  s seq=$o(^lab.DHCCTReagentI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTReagentI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTReagentD(id))
	..s uCode=$li(str,2)
	..s code1=" "_code
	..s code2=" "_uCode
	..i $l(code),code2'[code1 q
	..s uName=$li(str,3)
	..s name1=" "_name
	..s name2=" "_uName
	..i $l(name),name2'[name1  q
	..///规格
	..s packDr="" //$li(str,4)
	..s packName=$li(str,4)
	..//i $l(packageSize),packDr'=packageSize q
	..//i $l(packDr),$d(^lab.DHCCTPackageSizeD(packDr)) s packName=$li(^lab.DHCCTPackageSizeD(packDr),3)
	..///单位
	..s unitDr=$li(str,5)
	..s unitName=""
	..i $l(unit),unitDr'=unit q
	..i $l(unitDr),$d(^lab.DHCCTUnitD(unitDr)) s unitName=$li(^lab.DHCCTUnitD(unitDr),3)
	..///类别
	..s typeDr=$li(str,6)
	..s typeName=""
	..i $l(groupType),groupType'=typeDr q
	..i $l(typeDr),$d(^lab.DHCCTGroupTypeD(typeDr)) s typeName=$li(^lab.DHCCTGroupTypeD(typeDr),3)
	..///供应商
	..//s supplierDr=$li(str,13)
	..//s supplierName=""
	..//i $l(supplier),supplier'=supplierDr q
	..//i $l(supplierDr),$d(^lab.DHCCTSupplierD(supplierDr)) s supplierName=$li(^lab.DHCCTSupplierD(supplierDr),3)
	..///厂商
	..s manuDr=$li(str,14)
	..s manuName=""
	..i $l(manufact),manufact'=manuDr q
	..i $l(manuDr),$d(^lab.DHCCTManufacturerD(manuDr)) s manuName=$li(^lab.DHCCTManufacturerD(manuDr),3)
	..s InPrice=$li(str,8)
	..s OutPrice=$li(str,9)
	..s uMix=$li(str,15)
	..s uMax=$li(str,16)
	..s uDays=$li(str,22)
	..i uDays="0" s uDays=""
	..s uRemark=$li(str,17)
	..s uSeq=$li(str,18)
	..s uSyn=$li(str,20)
	..s syn1=" "_syn
	..s syn2=" "_uSyn
	..i $l(syn),syn2'[syn1 q
	..s uVis=$li(str,19)
	..//i $e(visible)'=$e(uVis) q
	..i $l(visible),visible="No",uVis'="Y" q
	..s BarCode=$li(str,21)
	..s PackVol=$li(str,23)
	..s VolUnit=$li(str,24)
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(uCode,uName,packName,unitName,typeName,InPrice,OutPrice,manuName,uMix,uMax,uDays,BarCode,uRemark,uSyn,uSeq,packDr,unitDr,typeDr,manuDr,uVis,PackVol,VolUnit)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      huhm
/// CreatDate：    20100423
/// Description:： 试剂查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(code As %String, name As %String, syn As %String, visible As %String, packageSize As %String, unit As %String, groupType As %String, supplier As %String, manufact As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,PackageSize:%String,Unit:%String,GroupType:%String,InPrice:%String,OutPrice:%String,Manufacturer:%String,MixQuantity:%String,MaxQuantity:%String,WarnDays:%String,BarCode:%String,Remarks:%String,Synonym:%String,Sequence:%String,PackageDr:%String,UnitDr:%String,TypeDr:%String,ManuDr:%String,Visible:%String,PackageVol:%String,VolUnit:%String")
{
}

ClassMethod GetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataExecute(ByRef qHandle As %Binary, syn As %String) As %Status
{
	s syn=$g(syn),name=syn
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s seq="" f  s seq=$o(^lab.DHCCTReagentI("SequenceIndex",seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTReagentI("SequenceIndex",seq,id)) q:id=""  d
	..s str=$g(^lab.DHCCTReagentD(id))
	..s uVis=$li(str,19)
	..i uVis'="Y" q
	..s uCode=$li(str,2)
	..s uName=$li(str,3)
	..s name1=" "_name
	..s name2=" "_uName
	..i $l(name),name2'[name1 q
	..s uSyn=$li(str,20)
	..s syn1=" "_syn
	..s syn2=" "_uSyn
	..i $l(syn),syn2'[syn1 q
	..///规格
	..s packDr="" //$li(str,4)
	..s packName=$li(str,4)
	..//i $l(packDr),$d(^lab.DHCCTPackageSizeD(packDr)) s packName=$li(^lab.DHCCTPackageSizeD(packDr),3)
	..///单位
	..s unitDr=$li(str,5)
	..s unitName=""
	..i $l(unitDr),$d(^lab.DHCCTUnitD(unitDr)) s unitName=$li(^lab.DHCCTUnitD(unitDr),3)
	..///类别
	..s typeDr=$li(str,6)
	..s typeName=""
	..i $l(typeDr),$d(^lab.DHCCTGroupTypeD(typeDr)) s typeName=$li(^lab.DHCCTGroupTypeD(typeDr),3)
	..///厂商
	..s ManuDr=$li(str,14)
	..s ManuName=""
	..i $l(ManuDr),$d(^lab.DHCCTManufacturerD(ManuDr)) s ManuName=$li(^lab.DHCCTManufacturerD(ManuDr),3)
	..s InPrice=$li(str,8)
	..s OutPrice=$li(str,9)
	..d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(uCode,uSyn_" "_uName,packName,unitName,typeName,ManuName,InPrice,OutPrice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      huhm
/// CreatDate：    20100429
/// Description:： 供应商快速查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetData(syn As %String) As %Query(ROWSPEC = "code:%String,name:%String,packagesize:%String,unit:%String,group:%String,ManuName:%String,InPrice:%String,OutPrice:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100511
/// Description:： 查询试剂信息
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod SelectReagent(Code As %String) As %String
{
	n (Code)
	s RetValue=""
	i '$l(Code) Quit RetValue
	i '$d(^lab.DHCCTReagentD(Code)) Quit RetValue
	s str=$g(^lab.DHCCTReagentD(Code))
	s (PackName,UnitName,Group,SuppName,ManuName)=""
	s ReagName=$li(str,3)
	s PackDr="" //$li(str,4)
	s PackName=$li(str,4)
	//i $l(PackDr),$d(^lab.DHCCTPackageSizeD(PackDr)) s PackName=$li(^lab.DHCCTPackageSizeD(PackDr),3)
	s UnitDr=$li(str,5)
	i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	s GroupDr=$li(str,6)
	i $l(GroupDr),$d(^lab.DHCCTGroupTypeD(GroupDr)) s Group=$li(^lab.DHCCTGroupTypeD(GroupDr),3)
	s BatchNo=$li(str,7)
	s InPrice=$li(str,8)
	s OutPrice=$li(str,9)
	s RegisterNo=$li(str,10)
	s LicenceNo=$li(str,11)
	s RegisterDate=$li(str,12)
	s SupplierDR=$li(str,13)
	i $l(SupplierDR),$d(^lab.DHCCTSupplierD(SupplierDR)) s SuppName=$li(^lab.DHCCTSupplierD(SupplierDR),3)
	s ManuDr=$li(str,14)
	i $l(ManuDr),$d(^lab.DHCCTManufacturerD(ManuDr)) s ManuName=$li(^lab.DHCCTManufacturerD(ManuDr),3)
	s Mix=$li(str,15)
	s Max=$li(str,16)
	s Remark=$li(str,17)
	s Sequence=$li(str,18)
	s Visible=$li(str,19)
	s Synonym=$li(str,20)
	s Barcode=$li(str,21)
	s WarnDays=$li(str,22)
	s Volumn=+$li(str,23)
	i Volumn=0 s Volumn=1
	s VolUnit=$li(str,24)
	//s RetValue=$lb("",Code,ReagName,PackName,UnitName,Group,$li(str,7,12),SuppName,ManuName,$li(str,15,21),PackDr,UnitDr,GroupDr,SupplierDR,ManuDr)
	s RetValue=Code_$c(2)_ReagName_$c(2)_PackName_$c(2)_UnitName_$c(2)_Group
	s RetValue=RetValue_$c(2)_+$li(str,7)_$c(2)_+$li(str,8)_$c(2)_$li(str,9)_$c(2)_$li(str,10)_$c(2)_$li(str,11)_$c(2)_$li(str,12)
	s RetValue=RetValue_$c(2)_SuppName_$c(2)_ManuName_$c(2)_$li(str,15)_$c(2)_$li(str,16)_$c(2)_$li(str,17)_$c(2)_$li(str,18)_$c(2)_$li(str,19)_$c(2)_$li(str,20)_$c(2)_$li(str,21)
	s RetValue=RetValue_$c(2)_PackDr_$c(2)_UnitDr_$c(2)_GroupDr_$c(2)_SupplierDR_$c(2)_ManuDr_$c(2)_WarnDays_$c(2)_Volumn_$c(2)_VolUnit
	Quit RetValue
}

/// Creator：      huhm
/// CreatDate：    20101221
/// Description:： 试剂是否使用
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod UsedFlag(ReagCode As %String) As %String
{
	//^lab.DHCREAGStockInItemsI("LotNoIndex","R01"
	s RetValue=0
	i '$l(ReagCode) q 0
	i $d(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagCode)) s RetValue=1
	i RetValue q RetValue
	//^lab.DHCREAGStockInRegItemsI("LotNoIndex"
	i $d(^lab.DHCREAGStockInRegItemsI("LotNoIndex",ReagCode)) s RetValue=1
	q RetValue
}

}
