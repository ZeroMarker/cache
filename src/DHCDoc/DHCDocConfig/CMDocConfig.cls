/// creator:谭吉善
/// date:2017-05-27
/// desc:医生站设置程序->新草药录入设置
Class DHCDoc.DHCDocConfig.CMDocConfig Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      谭吉善
/// CreatDate：    2017-05-27
/// Description:： 查询草药处方类型
Query FindCMPrescType(HospId As %String = "", IsActive As %String = "") As %Query(ROWSPEC = "Code:%String,Desc:%String,Active:%String")
{
}

ClassMethod FindCMPrescTypeExecute(ByRef qHandle As %Binary, HospId As %String = "", IsActive As %String = "") As %Status
{

	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CMDocConfig","FindCMPrescType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s Code=0
	    for {
			s Code=$O(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code))
			q:Code=""
			s Desc=$P(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code),"^",1)
			s Active=$P(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code),"^",2)
			i Active="" s Active="Y"
			continue:(IsActive'="")&&(Active'=IsActive)
			s Number=$g(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code,"Number"))
			d OutputRowFindCMPrescType
		}
	}else{
	    s Code=0
	    for {
			s Code=$O(^DHCDocConfig("CMPrescTypeList",Code))
			q:Code=""
			s Desc=$P(^DHCDocConfig("CMPrescTypeList",Code),"^",1)
			s Active=$P(^DHCDocConfig("CMPrescTypeList",Code),"^",2)
			i Active="" s Active="Y"
			continue:(IsActive'="")&&(Active'=IsActive)
			s Number=$g(^DHCDocConfig("CMPrescTypeList",Code,"Number"))
			d OutputRowFindCMPrescType
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCMPrescType
	set Data=$lb(Code,Desc,Active)
 	Set ^CacheTemp(repid,Number)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCMPrescTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCMPrescTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCMPrescTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCMPrescTypeExecute ]
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

/// --------------------------
Query FindInstrLinkOrderQty(InstrucRowId As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod FindInstrLinkOrderQtyExecute(ByRef qHandle As %Binary, InstrucRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CMDocConfig","FindInstrLinkOrderQty",15)
	s ^tan("FindInstrLinkOrderQty")=InstrucRowId
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (InstrucRowId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
    
    s ILDRowId=0
    for {
		s ILDRowId=$o(^PHCINLD(0,"Instruc",InstrucRowId,ILDRowId))
		Q:ILDRowId=""
		s ILDDosageDr=$p(^PHCINLD(ILDRowId),"^",2)
		continue:ILDDosageDr=""
		s PHCDODesc=$p(^PHCDO(ILDDosageDr),"^",3)
		
		d OutputRowFindInstrLinkOrderQty
	}
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindInstrLinkOrderQty
	set Data=$lb(ILDDosageDr,PHCDODesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInstrLinkOrderQtyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrLinkOrderQtyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInstrLinkOrderQtyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrLinkOrderQtyExecute ]
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

ClassMethod DelCMPrescType(Code As %String) As %String
{
	kill ^DHCDocConfig("CMPrescTypeList",Code)
	kill ^DHCDocConfig(Code)
	q Code
}

ClassMethod ActiveCMPrescType(Code As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		if $D(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code)){
			s Active=$P(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code),"^",2)
			i Active="" s Active="Y"
			
			s NewActive=$CASE(Active,"Y":"N",:"Y")
			s $P(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code),"^",2)=NewActive
		}
	}else{
		if $D(^DHCDocConfig("CMPrescTypeList",Code)){
			s Active=$P(^DHCDocConfig("CMPrescTypeList",Code),"^",2)
			i Active="" s Active="Y"
			
			s NewActive=$CASE(Active,"Y":"N",:"Y")
			s $P(^DHCDocConfig("CMPrescTypeList",Code),"^",2)=NewActive
		}
	}
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.CMDocConfig).SaveCMPrescType("FormulaItemCat","协定处方")
ClassMethod SaveCMPrescType(Code As %String, Desc As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		if $D(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code)){
			q "-1"
		}
		if $D(^DHCDocConfig(HospCodeNode,Code)){
			q "-2"
		}
		s ^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code)=Desc_"^Y"
		s ^DHCDocConfig(HospCodeNode,Code)=0
		s MaxNumber=0
		s Type=""
		for {
			s Type=$o(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Type))
			q:Type=""
			s Number=$g(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Type,"Number"))
			if (Number>MaxNumber){
				s MaxNumber=Number
			}
		}
		s MaxNumber=MaxNumber+1
		s ^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code,"Number")=MaxNumber
	}else{
		if $D(^DHCDocConfig("CMPrescTypeList",Code)){
			q "-1"
		}
		if $D(^DHCDocConfig(Code)){
			q "-2"
		}
		s ^DHCDocConfig("CMPrescTypeList",Code)=Desc_"^Y"
		s ^DHCDocConfig(Code)=0
		s MaxNumber=0
		s Type=""
		for {
			s Type=$o(^DHCDocConfig("CMPrescTypeList",Type))
			q:Type=""
			s Number=$g(^DHCDocConfig("CMPrescTypeList",Type,"Number"))
			if (Number>MaxNumber){
				s MaxNumber=Number
			}
		}
		s MaxNumber=MaxNumber+1
		s ^DHCDocConfig("CMPrescTypeList",Code,"Number")=MaxNumber
	}
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.CMDocConfig).GetCMPrescDetails("CNMedKLItemCat",2)
ClassMethod GetCMPrescDetails(Code As %String, HospId As %String = "") As %String
{
	n (Code,HospId,%session)
	q:Code="" "-100"
	s Sep="#"
	s OutPutStr=""
	//附加医嘱
	s CNMedAppendItem=..%GetConfig1(Code,"CNMedAppendItem",HospId) //$G(^DHCDocConfig(Code,"CNMedAppendItem"))
	s CNMedAppendItemDesc=""
	if (+CNMedAppendItem>0) s CNMedAppendItemDesc=$p(^ARCIM(+CNMedAppendItem,$p(CNMedAppendItem,"||",2),1),"^",2)
	//代煎费
	s CNMedCookModeFeeItem=..%GetConfig1(Code,"CNMedCookModeFeeItem",HospId) //$G(^DHCDocConfig(Code,"CNMedCookModeFeeItem"))
	s CNMedCookModeFeeItemDesc=""
	if (+CNMedCookModeFeeItem>0) s CNMedCookModeFeeItemDesc=$p(^ARCIM(+CNMedCookModeFeeItem,$p(CNMedCookModeFeeItem,"||",2),1),"^",2)
	//默认频次
	s CNMedDefaultFrequence=..%GetConfig1(Code,"CNMedDefaultFrequence",HospId) //$G(^DHCDocConfig(Code,"CNMedDefaultFrequence"))
	//默认用法
	s CNMedDefaultInstruction=..%GetConfig1(Code,"CNMedDefaultInstruction",HospId) //$G(^DHCDocConfig(Code,"CNMedDefaultInstruction"))
	//默认疗程
	s CNMedDefaultDuration=..%GetConfig1(Code,"CNMedDefaultDuration",HospId) //$G(^DHCDocConfig(Code,"CNMedDefaultDuration"))
	//子类
	s CNItemCat=..%GetConfig(Code,HospId) //$G(^DHCDocConfig(Code))
	//s CNItemCat=$Replace(CNItemCat,"^","")
	//默认用量
	s DefaultQtyID=..%GetConfig1(Code,"DefaultQty",HospId) //$G(^DHCDocConfig(Code,"DefaultQty"))
	//代煎接收科室
	s CNMedCookDep=..%GetConfig1(Code,"CNMedCookDep",HospId) //$G(^DHCDocConfig(Code,"CNMedCookDep"))
	//代煎接收科室
	s EPCNMedCookDep=..%GetConfig1(Code,"EPCNMedCookDep",HospId) //$G(^DHCDocConfig(Code,"EPCNMedCookDep"))
	//自动计算附加材料数量
	s CNMedAppendItemQtyCalcu=..%GetConfig1(Code,"CNMedAppendItemQtyCalcu",HospId) //$G(^DHCDocConfig(Code,"CNMedAppendItemQtyCalcu"))
	//住院自动增加代煎费
	s IPCookModeFeeNoAutoAdd=..%GetConfig1(Code,"IPCookModeFeeNoAutoAdd",HospId) //$G(^DHCDocConfig(Code,"IPCookModeFeeNoAutoAdd"))
	//是否显示明细
	s ApperFormulaItem=..%GetConfig1(Code,"ApperFormulaItem",HospId) //$G(^DHCDocConfig(Code,"ApperFormulaItem"))
	//是否打印明细
	s PrintFormulaItem=..%GetConfig1(Code,"PrintFormulaItem",HospId) //$G(^DHCDocConfig(Code,"PrintFormulaItem"))
	//默认接受科室
	s CNMedNormDefaultRefLoc=..%GetConfig1(Code,"CNMedNormKLRefLoc",HospId) //$G(^DHCDocConfig(Code,"CNMedNormKLRefLoc"))
	//住院默认接受科室
	s CNMedNormIPDefaultRefLoc=..%GetConfig1(Code,"IPCNMedNormKLRefLoc",HospId) //$G(^DHCDocConfig(Code,"IPCNMedNormKLRefLoc"))
	//禁用代煎勾选
	s NotAllowChangeCook=..%GetConfig1(Code,"NotAllowChangeCook",HospId) // $G(^DHCDocConfig(Code,"NotAllowChangeCook"))
	//住院默认处方类型
	s IPDefaultCMPrescType=..%GetConfig1(Code,"IPDefaultCMPrescType",HospId) //$G(^DHCDocConfig(Code,"IPDefaultCMPrescType"))
	//门诊默认处方类型
	s OPDefaultCMPrescType=..%GetConfig1(Code,"OPDefaultCMPrescType",HospId) //$G(^DHCDocConfig(Code,"OPDefaultCMPrescType"))
	//关联费用列表
	s CMPrescTypeLinkFeeStr=..%GetConfig1(Code,"CMPrescTypeLinkFee",HospId)
	if (CMPrescTypeLinkFeeStr'=""){
		for index=1:1:$l(CMPrescTypeLinkFeeStr,"^"){
			s ArcimRowId=$p(CMPrescTypeLinkFeeStr,"^",index)
			s ArcimDesc=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",2)
			s $p(CMPrescTypeLinkFeeStr,"^",index)=ArcimRowId_"$"_ArcimDesc
		}
	}
	//默认煎药方式
	s CNMedCookModeDefualt=..%GetConfig1(Code,"CNMedCookModeDefualt",HospId) //$g(^DHCDocConfig(Code,"CNMedCookModeDefualt"))
	if (CNMedCookModeDefualt'=""){
		if (..%GetConfig1("CookMode",CNMedCookModeDefualt,HospId)="") s CNMedCookModeDefualt=""
		//if ($G(^DHCDocConfig("CookMode",CNMedCookModeDefualt))="") s CNMedCookModeDefualt=""
	}
	//取药方式
	s TakingMedicineMethodStr=""
	s TakingMedicineMethod=..%GetConfig1(Code,"TakingMedicineMethod",HospId)
	if (TakingMedicineMethod'=""){
		s TakingMedicineMethodStr=""
		for index=1:1:$l(TakingMedicineMethod,"!"){
			s RowID=$p(TakingMedicineMethod,"!",index)
			continue:($P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),3)="N")
			if (TakingMedicineMethodStr="") s TakingMedicineMethodStr=RowID
			else  s TakingMedicineMethodStr=TakingMedicineMethodStr_"!"_RowID
		}
		}
	//1-5
	s OutPutStr="0"_Sep_CNMedAppendItem_Sep_CNMedCookModeFeeItem_Sep_CNMedDefaultFrequence_Sep_CNMedDefaultInstruction
	//6-10
	s OutPutStr=OutPutStr_Sep_CNMedDefaultDuration_Sep_CNItemCat_Sep_DefaultQtyID_Sep_CNMedCookDep_Sep_EPCNMedCookDep
	//11-15
	s OutPutStr=OutPutStr_Sep_CNMedAppendItemQtyCalcu_Sep_IPCookModeFeeNoAutoAdd_Sep_ApperFormulaItem_Sep_PrintFormulaItem_Sep_CNMedNormDefaultRefLoc
	//16-20
	s OutPutStr=OutPutStr_Sep_NotAllowChangeCook
	s OutPutStr=OutPutStr_Sep_CNMedAppendItemDesc_Sep_CNMedCookModeFeeItemDesc
	//19-21
	s OutPutStr=OutPutStr_Sep_CNMedNormIPDefaultRefLoc_Sep_IPDefaultCMPrescType_Sep_OPDefaultCMPrescType
	//22-
	s OutPutStr=OutPutStr_Sep_CMPrescTypeLinkFeeStr_Sep_CNMedCookModeDefualt_Sep_TakingMedicineMethodStr
	
	q OutPutStr
}

/// w ##Class(DHCDoc.DHCDocConfig.CMDocConfig).SaveCMPrescDetails("CNMedKLItemCat","##46#42#41#16^79^84#13###0#0#0#0#310#1##1#1")
ClassMethod SaveCMPrescDetails(PrescTypeCode As %String, DetailsInfo As %String, HospId As %String = "") As %String
{
	s ^tan("SaveCMPrescDetails")=PrescTypeCode_","_DetailsInfo
	q:PrescTypeCode="" "-100^无效的处方类型代码"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s CNMedAppendItem=$P(DetailsInfo,"#",1)
	s CNMedCookModeFeeItem=$P(DetailsInfo,"#",2)
	s CNMedDefaultFrequence=$P(DetailsInfo,"#",3)
	s CNMedDefaultInstruction=$P(DetailsInfo,"#",4)
	s CNMedDefaultDuration=$P(DetailsInfo,"#",5)
	
	s CNItemCat=$P(DetailsInfo,"#",6)
	s DefaultQtyID=$P(DetailsInfo,"#",7)
	s CNMedCookDep=$P(DetailsInfo,"#",8)
	s EPCNMedCookDep=$P(DetailsInfo,"#",9)
	s CNMedAppendItemQtyCalcu=$P(DetailsInfo,"#",10)
	
	s IPCookModeFeeNoAutoAdd=$P(DetailsInfo,"#",11)
	s ApperFormulaItem=$P(DetailsInfo,"#",12)
	s PrintFormulaItem=$P(DetailsInfo,"#",13)
	s CNMedNormDefaultRefLoc=$P(DetailsInfo,"#",14)
	s NotAllowChangeCook=$P(DetailsInfo,"#",15)
	s CNMedNormIPDefaultRefLoc=$P(DetailsInfo,"#",16)
	s IPDefaultCMPrescType=$P(DetailsInfo,"#",17)
	s OPDefaultCMPrescType=$P(DetailsInfo,"#",18)
	s CMPrescTypeLinkFeeStr=$P(DetailsInfo,"#",19)
	s CNMedCookModeDefualt=$P(DetailsInfo,"#",20)
	s TakingMedicineMethod=$P(DetailsInfo,"#",21)
	s ErrMsg=""
	if (IPDefaultCMPrescType="1")||(OPDefaultCMPrescType="1"){
		if (HospCodeNode'=""){
			s Code=0
		    for {
				s Code=$O(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code))
				q:Code=""
				s Desc=$P($G(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Code)),"^",1)
				if (PrescTypeCode=Code){continue}
				if (IPDefaultCMPrescType="1")&&($G(^DHCDocConfig(HospCodeNode,Code,"IPDefaultCMPrescType"))=1){
					s ErrMsg=Desc_"已置默认住院处方类型"
				}
				if (OPDefaultCMPrescType="1")&&($G(^DHCDocConfig(HospCodeNode,Code,"OPDefaultCMPrescType"))=1){
					s ErrMsg=Desc_"已置默认门诊处方类型"
				}
			}
		}else{
			s Code=0
		    for {
				s Code=$O(^DHCDocConfig("CMPrescTypeList",Code))
				q:Code=""
				s Desc=$P($G(^DHCDocConfig("CMPrescTypeList",Code)),"^",1)
				if (PrescTypeCode=Code){continue}
				if (IPDefaultCMPrescType="1")&&($G(^DHCDocConfig(Code,"IPDefaultCMPrescType"))=1){
					s ErrMsg=Desc_"已置默认住院处方类型"
				}
				if (OPDefaultCMPrescType="1")&&($G(^DHCDocConfig(Code,"OPDefaultCMPrescType"))=1){
					s ErrMsg=Desc_"已置默认门诊处方类型"
				}
			}
		}
	}
	q:(ErrMsg'="") "-100^"_ErrMsg
	//附加医嘱
	if (CNMedAppendItem["||")||(CNMedAppendItem=""){
		d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedAppendItem",CNMedAppendItem,HospId)
		//s ^DHCDocConfig(PrescTypeCode,"CNMedAppendItem")=CNMedAppendItem
	}
	//代煎费
	if (CNMedCookModeFeeItem["||")||(CNMedCookModeFeeItem=""){
		d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedCookModeFeeItem",CNMedCookModeFeeItem,HospId)
		//s ^DHCDocConfig(PrescTypeCode,"CNMedCookModeFeeItem")=CNMedCookModeFeeItem
	}
	//默认频次
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedDefaultFrequence",CNMedDefaultFrequence,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"CNMedDefaultFrequence")=CNMedDefaultFrequence
	//默认用法
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedDefaultInstruction",CNMedDefaultInstruction,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"CNMedDefaultInstruction")=CNMedDefaultInstruction
	//默认疗程
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedDefaultDuration",CNMedDefaultDuration,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"CNMedDefaultDuration")=CNMedDefaultDuration
	//子类
	d ##class(web.DHCDocConfig).SaveConfig2(PrescTypeCode,CNItemCat,HospId)
	//s ^DHCDocConfig(PrescTypeCode)=CNItemCat
	//默认用量
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"DefaultQty",DefaultQtyID,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"DefaultQty")=DefaultQtyID
	//代煎接收科室
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedCookDep",CNMedCookDep,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"CNMedCookDep")=CNMedCookDep
	//代煎接收科室
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"EPCNMedCookDep",EPCNMedCookDep,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"EPCNMedCookDep")=EPCNMedCookDep
	//自动计算附加材料数量
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedAppendItemQtyCalcu",CNMedAppendItemQtyCalcu,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"CNMedAppendItemQtyCalcu")=CNMedAppendItemQtyCalcu
	//住院自动增加代煎费
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"IPCookModeFeeNoAutoAdd",IPCookModeFeeNoAutoAdd,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"IPCookModeFeeNoAutoAdd")=IPCookModeFeeNoAutoAdd
	//是否显示明细
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"ApperFormulaItem",ApperFormulaItem,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"ApperFormulaItem")=ApperFormulaItem
	//是否打印明细
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"PrintFormulaItem",PrintFormulaItem,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"PrintFormulaItem")=PrintFormulaItem
	//默认接受科室
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedNormKLRefLoc",CNMedNormDefaultRefLoc,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"CNMedNormKLRefLoc")=CNMedNormDefaultRefLoc
	//禁用代煎勾选
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"NotAllowChangeCook",NotAllowChangeCook,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"NotAllowChangeCook")=NotAllowChangeCook
	//住院默认接受科室
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"IPCNMedNormKLRefLoc",CNMedNormIPDefaultRefLoc,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"IPCNMedNormKLRefLoc")=CNMedNormIPDefaultRefLoc
	//住院默认处方类型
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"IPDefaultCMPrescType",IPDefaultCMPrescType,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"IPDefaultCMPrescType")=IPDefaultCMPrescType
	//门诊默认处方类型
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"OPDefaultCMPrescType",OPDefaultCMPrescType,HospId)
	//s ^DHCDocConfig(PrescTypeCode,"OPDefaultCMPrescType")=OPDefaultCMPrescType
	//保存处方类型绑定费用列表
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CMPrescTypeLinkFee",CMPrescTypeLinkFeeStr,HospId)
	//保存默认的煎药方式
	//s ^DHCDocConfig(PrescTypeCode,"CNMedCookModeDefualt")=CNMedCookModeDefualt
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"CNMedCookModeDefualt",CNMedCookModeDefualt,HospId)
	//保存取药方式
	d ##class(web.DHCDocConfig).SaveConfig1(PrescTypeCode,"TakingMedicineMethod",TakingMedicineMethod,HospId)
	q 0
}

/// 改变处方类型的顺序
ClassMethod ChangeNumberCMPrescType(TypeCode, UPDown, HospId As %String = "")
{
	q:TypeCode="" ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		if (UPDown="Up"){
			s OldNumber=$g(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",TypeCode,"Number"))
			s NewNumber=OldNumber-1
		}else{
			s OldNumber=$g(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",TypeCode,"Number"))
			s NewNumber=OldNumber+1
		}
		s Type=""
		for {
			s Type=$o(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Type))
			q:Type=""
			s Number=$g(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Type,"Number"))
			if (Number=NewNumber){
				s ^DHCDocConfig(HospCodeNode,"CMPrescTypeList",Type,"Number")=OldNumber
				s ^DHCDocConfig(HospCodeNode,"CMPrescTypeList",TypeCode,"Number")=NewNumber
			}
		}
	}else{
		if (UPDown="Up"){
			s OldNumber=$g(^DHCDocConfig("CMPrescTypeList",TypeCode,"Number"))
			s NewNumber=OldNumber-1
		}else{
			s OldNumber=$g(^DHCDocConfig("CMPrescTypeList",TypeCode,"Number"))
			s NewNumber=OldNumber+1
		}
		s Type=""
		for {
			s Type=$o(^DHCDocConfig("CMPrescTypeList",Type))
			q:Type=""
			s Number=$g(^DHCDocConfig("CMPrescTypeList",Type,"Number"))
			if (Number=NewNumber){
				s ^DHCDocConfig("CMPrescTypeList",Type,"Number")=OldNumber
				s ^DHCDocConfig("CMPrescTypeList",TypeCode,"Number")=NewNumber
			}
		}
	}
	q 0
}

Query FindTakingMedicineMethod(Code As %String, HospId As %String = "") As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String")
{
}

ClassMethod FindTakingMedicineMethodExecute(ByRef qHandle As %Binary, Code As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.CMDocConfig","FindTakingMedicineMethod","")
	Set repid=$I(^CacheTemp)
    Set ind=1
   if ((Code="")||(HospId="")){
	   Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	   } 
    s TakingMedicineMethod=..%GetConfig1(Code,"TakingMedicineMethod",HospId)
    if (TakingMedicineMethod'=""){
	    for i=1:1:$L(TakingMedicineMethod,"!"){
		    s RowID=$P(TakingMedicineMethod,"!",i)
		     continue:($P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),3)="N")
			s Code=$P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),1)
			s Desc=$P(^DHCDocConfig("TakingMedicineMethod",RowID),$c(1),2)
			s Desc=##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",Desc)
		    set Data=$lb($g(RowID),$g(Code),$g(Desc))
		    Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		    }
	    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindTakingMedicineMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTakingMedicineMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTakingMedicineMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTakingMedicineMethodExecute ]
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

/// d ##class(DHCDoc.DHCDocConfig.CMDocConfig).GetCatPrescTypeList(.CatList,2)
ClassMethod GetCatPrescTypeList(ByRef CatList, CurLogonHosp = "")
{
	k CatList
	s CurLogonHosp=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	s HospNode="HospDr_"_CurLogonHosp
	s PrescTypeCode=0 for{
		s PrescTypeCode=$O(^DHCDocConfig(HospNode,"CMPrescTypeList",PrescTypeCode)) Q:PrescTypeCode=""
		s PrescTypeActive=$P(^DHCDocConfig(HospNode,"CMPrescTypeList",PrescTypeCode),"^",2)
		continue:(PrescTypeActive="N")
		s PrescTypeItemCat=..%GetConfig(PrescTypeCode,CurLogonHosp)
		for i=1:1:$L(PrescTypeItemCat,"^"){
			s ItemCat=$P(PrescTypeItemCat,"^",i)
			continue:ItemCat=""
			s CatList(ItemCat,PrescTypeCode)=""
		}
	}
	Q 0
}

}
