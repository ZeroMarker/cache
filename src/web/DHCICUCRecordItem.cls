Import SQLUser

Class web.DHCICUCRecordItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindICUCRecordItem","","","","")
Query FindICUCRecordItem(ICUCRIDesc As %String, ICUCRIViewCat As %String, ICUCRICat As %String, ICUCRICode As %String, ICUCRIDataType As %String, isActive As %String = "N") As %Query(ROWSPEC = "tRowId:%String,tICUCRICode:%String,tICUCRIDesc:%String,tICUCRIType:%String,tICUCRITypeDesc:%String,tICUCRIArcimDr:%String,tICUCRIArcim:%String,tICUCRIViewCatDr:%String,tICUCRIViewCat:%String,tICUCRIUomDr:%String,tICUCRIUom:%String,tICUCRIIconDr:%String,tICUCRIIcon:%String,tICUCRIColor:%String,tICUCRIAnApply:%String,tICUCRIIcuApply:%String,tICUCRIOptions:%String,tICUCRIICUCIOIDr:%String,tICUCRIICUCIOI:%String,tICUCRIMultiValueDesc:%String,tICUCRISortNo:%String,tICUCRIArcosDr:%String,tICUCRIArcos:%String,tICUCRIDataType:%String,tICUCRIDataTypeDesc:%String,tICUCRIIsContinue:%String,tICUCRIAnMethodDr:%String,tICUCRIMax:%String,tICUCRIMin:%String,tICUCRIImpossibleMax:%String,tICUCRIImpossibleMin:%String,tICUCRIMainICUCRIDr:%String,tICUCRIMainICUCRI:%String,tICUCRIDataField:%String,tICUCRIDataFormat:%String,tICUCRIFormat:%String,tICUCRIFormatField:%String,tICUCRITemplateICUCRIDr:%String,tICUCRITemplateICUCRI:%String,tICUCRITemplateSubICUCRIDr:%String,tICUCRITemplateSubICUCRI:%String,tICUCRISumFormat:%String,tICUCRISumFormatField:%String") [ SqlProc ]
{
}

ClassMethod FindICUCRecordItemExecute(ByRef qHandle As %Binary, ICUCRIDesc As %String = "", ICUCViewCat As %String, ICUCRICat As %String = "", ICUCRICode As %String = "", ICUCRIDataType As %String = "", isActive As %String = "N") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tRowId=0
	k icucItemList
	f  s tRowId=$o(^DHCICUC("RecordItem",tRowId))  q:tRowId=""  d
	.s tICUCRIViewCatDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",5)
	.;q:(ICUCViewCat'="")&(("|"_tICUCRIViewCatDr_"|")'[("|"_ICUCViewCat_"|"))
	.s tICUCRISortNo=$p($g(^DHCICUC("RecordItem",tRowId)),"^",14)
	.s tICUCRICode=$p($g(^DHCICUC("RecordItem",tRowId)),"^",1)
	.s icucItemList(tICUCRISortNo_","_tICUCRICode_","_tRowId)=tRowId
	s icuciNode=""
 	f  s icuciNode=$o(icucItemList(icuciNode)) q:icuciNode=""  d
	.s tRowId=icucItemList(icuciNode)
	.s tICUCRICode=$p($g(^DHCICUC("RecordItem",tRowId)),"^",1)
	.q:(ICUCRICode'="")&(tICUCRICode'[ICUCRICode)
	.s tICUCRIDesc=$p($g(^DHCICUC("RecordItem",tRowId)),"^",2)
	.q:(ICUCRIDesc'="")&(tICUCRIDesc'[ICUCRIDesc)
	.s tICUCRIType=$p($g(^DHCICUC("RecordItem",tRowId)),"^",3)
	.s tICUCRITypeDesc=""
	.i tICUCRIType="D" s tICUCRITypeDesc="药品"
	.i tICUCRIType="V" s tICUCRITypeDesc="生命体征"
	.i tICUCRIType="E" s tICUCRITypeDesc="事件"
	.i tICUCRIType="T" s tICUCRITypeDesc="治疗"
	.i tICUCRIType="L" s tICUCRITypeDesc="检验"
	.q:(ICUCRICat'="")&(ICUCRICat'=tICUCRITypeDesc)
	.s tICUCRIArcimDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",4)
	.s tICUCRIArcim=""
	.i tICUCRIArcimDr'="" do
	..f j=1:1:$l(tICUCRIArcimDr,"~") d
	...s SubID=$p($p(tICUCRIArcimDr,"~",j),"||",1)
	...s VerID=$p($p(tICUCRIArcimDr,"~",j),"||",2)
	...q:VerID=""
	...s tICUCRIArcim=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
	.s tICUCRIViewCatDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",5)
	.s tICUCRIViewCat=""
    .f i=1:1:$l(tICUCRIViewCatDr,"|") d
    ..s icucvcId=$p(tICUCRIViewCatDr,"|",i)
    ..q:+icucvcId=0
    ..i tICUCRIViewCat'="" s tICUCRIViewCat=tICUCRIViewCat_";"
    ..s tICUCRIViewCat=tICUCRIViewCat_$p($g(^DHCICUC("ViewCat",icucvcId)),"^",2)
    .q:(ICUCViewCat'="")&(tICUCRIViewCat'[ICUCViewCat)
	.s tICUCRIUomDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",6)
	.s tICUCRIUom=""
    .i +tICUCRIUomDr'=0 s tICUCRIUom=$p($g(^CT("UOM",tICUCRIUomDr)),"^",2)
	.s tICUCRIIconDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",7)
	.s tICUCRIIcon=""
    .i +tICUCRIIconDr'=0 s tICUCRIIcon=$p($g(^DHCANC("Icon",tICUCRIIconDr)),"^",2)
	.s tICUCRIColor=$p($g(^DHCICUC("RecordItem",tRowId)),"^",8)
	.s tICUCRIAnApply=$p($g(^DHCICUC("RecordItem",tRowId)),"^",9)
	.q:tICUCRIAnApply="Y"	;重症麻醉分开，不再显示麻醉项目
	.s tICUCRIIcuApply=$p($g(^DHCICUC("RecordItem",tRowId)),"^",10)
	.q:(tICUCRIIcuApply="N")&(isActive="N")
	.q:(tICUCRIIcuApply="Y")&(isActive="Y")
	.s tICUCRIOptions=$p($g(^DHCICUC("RecordItem",tRowId)),"^",11)
	.s tICUCRIICUCIOIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",12)
    .s tICUCRIICUCIOI=""
    .i tICUCRIICUCIOIDr>0 s tICUCRIICUCIOI=$p($g(^DHCICUC("IOItem",tICUCRIICUCIOIDr)),"^",2) ;$p($g(^DHCICUC("IOItem",tICUCRIICUCIOIDr)),"^",2)
	.s tICUCRIMultiValueDesc=$p($g(^DHCICUC("RecordItem",tRowId)),"^",13)
	.s tICUCRISortNo=$p($g(^DHCICUC("RecordItem",tRowId)),"^",14)
	.s tICUCRIArcosDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",15)
	.s tICUCRIArcos=$p($g(^ARCOS(+tICUCRIArcosDr)),"^",2)
	.s tICUCRIDataType=$p($g(^DHCICUC("RecordItem",tRowId)),"^",16)
	.q:(ICUCRIDataType'="")&&(ICUCRIDataType'=tICUCRIDataType)
	.s tICUCRIDataTypeDesc =##class(web.DHCCLCom).GetComDescByCode("DataType",tICUCRIDataType)
	.s tICUCRIIsContinue=$p($g(^DHCICUC("RecordItem",tRowId)),"^",17)
	.s tICUCRIAnMethodDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",18)
	.s tICUCRIMax=$p($g(^DHCICUC("RecordItem",tRowId)),"^",19)
	.s tICUCRIMin=$p($g(^DHCICUC("RecordItem",tRowId)),"^",20)
	.s tICUCRIImpossibleMax=$p($g(^DHCICUC("RecordItem",tRowId)),"^",21)
	.s tICUCRIImpossibleMin=$p($g(^DHCICUC("RecordItem",tRowId)),"^",22)
	.s tICUCRIMainICUCRIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",23)
	.s tICUCRIMainICUCRI = $p($g(^DHCICUC("RecordItem",+tICUCRIMainICUCRIDr)),"^",2)
	.s tICUCRIDataField=$p($g(^DHCICUC("RecordItem",tRowId)),"^",24)
	.s tICUCRIDataFormat=$p($g(^DHCICUC("RecordItem",tRowId)),"^",25)
	.s tICUCRIFormat=$p($g(^DHCICUC("RecordItem",tRowId)),"^",26)
	.s tICUCRIFormatField=$p($g(^DHCICUC("RecordItem",tRowId)),"^",27)
	.s tICUCRITemplateICUCRIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",28)
	.s tICUCRITemplateICUCRI= $p($g(^DHCICUC("RecordItem",+tICUCRITemplateICUCRIDr)),"^",2)
	.s tICUCRITemplateSubICUCRIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",29)
	.s tICUCRITemplateSubICUCRI=""
	.f i=1:1:$l(tICUCRITemplateSubICUCRIDr,"|") d
	..s TempSubId=$p(tICUCRITemplateSubICUCRIDr,"|",i)
	..q:TempSubId=""
	..i tICUCRITemplateSubICUCRI'="" s tICUCRITemplateSubICUCRI=tICUCRITemplateSubICUCRI_";"
	..s tICUCRITemplateSubICUCRI=tICUCRITemplateSubICUCRI_$p($g(^DHCICUC("RecordItem",TempSubId)),"^",2)
	.;s tICUCRITemplateSubICUCRI= $p($g(^DHCICUC("RecordItem",+tICUCRITemplateSubICUCRIDr)),"^",2)
	.s tICUCRISumFormat=$p($g(^DHCICUC("RecordItem",tRowId)),"^",30)
	.s tICUCRISumFormatField=$p($g(^DHCICUC("RecordItem",tRowId)),"^",31)
	.i tICUCRIMainICUCRIDr="" d
	..&sql(select * from DHC_ICUC_RecordItem where ICUCRI_Code=:tICUCRICode)
	..s retcode=SQLCODE
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tRowId,tICUCRICode,tICUCRIDesc,tICUCRIType,tICUCRITypeDesc,tICUCRIArcimDr,tICUCRIArcim,tICUCRIViewCatDr,tICUCRIViewCat,tICUCRIUomDr,tICUCRIUom,tICUCRIIconDr,tICUCRIIcon,tICUCRIColor,tICUCRIAnApply,tICUCRIIcuApply,tICUCRIOptions,tICUCRIICUCIOIDr,tICUCRIICUCIOI,tICUCRIMultiValueDesc,tICUCRISortNo,tICUCRIArcosDr,tICUCRIArcos,tICUCRIDataType,tICUCRIDataTypeDesc,tICUCRIIsContinue,tICUCRIAnMethodDr,tICUCRIMax,tICUCRIMin,tICUCRIImpossibleMax,tICUCRIImpossibleMin,tICUCRIMainICUCRIDr,tICUCRIMainICUCRI,tICUCRIDataField,tICUCRIDataFormat,tICUCRIFormat,tICUCRIFormatField,tICUCRITemplateICUCRIDr,tICUCRITemplateICUCRI,tICUCRITemplateSubICUCRIDr,tICUCRITemplateSubICUCRI,tICUCRISumFormat,tICUCRISumFormatField)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCRecordItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCRecordItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindICUCRecordItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCRecordItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCICUCRecordItem).InsertDHCICUCRItem("1","2","D","4","5","6","7","8","N","Y","11","12","13","14","15","DT","Y","18","19","20","21","22","23","24","25","26","27","28","29","30","31")
/// 插入数据
ClassMethod InsertDHCICUCRItem(ICUCRICode As %String, ICUCRIDesc As %String, ICUCRIType As %String, ICUCRIArcimDr As %String, ICUCRIViewCatDr As %String, ICUCRIUomDr As %String, ICUCRIIconDr As %String, ICUCRIColor As %String, ICUCRIAnApply As %String, ICUCRIIcuApply As %String, ICUCRIOptions As %String, ICUCRIICUCIOIDr As %String, ICUCRIMultiValueDesc As %String, ICUCRISortNo As %String, ICUCRIArcosDr As %String, ICUCRIDataType As %String, ICUCRIIsContinue As %String, ICUCRIAnMethodDr As %String, ICUCRIMax As %String, ICUCRIMin As %String, ICUCRIImpossibleMax As %String, ICUCRIImpossibleMin As %String, ICUCRIMainICUCRIDr As %String, ICUCRIDataField As %String, ICUCRIDataFormat As %String, ICUCRIFormat As %String, ICUCRIFormatField As %String, ICUCRITemplateICUCRIDr As %String, ICUCRITemplateSubICUCRIDr As %String, ICUCRISumFormat As %String, ICUCRISumFormatField As %String)
{
    s ^TEMPWHL("InsertDHCICUCRItem",ICUCRICode)=ICUCRICode_"^"_ICUCRIDesc_"^"_ICUCRIType_"^"_ICUCRIArcimDr_"^"_ICUCRIViewCatDr_"^"_ICUCRIUomDr_"^"_ICUCRIIconDr_"^"_ICUCRIColor_"^"_ICUCRIAnApply_"^"_ICUCRIIcuApply_"^"_ICUCRIOptions_"^"_ICUCRIICUCIOIDr_"^"_ICUCRIMultiValueDesc_"^"_ICUCRISortNo_"^"_ICUCRIArcosDr_"^"_ICUCRIDataType_"^"_ICUCRIIsContinue_"^"_ICUCRIAnMethodDr_"^"_ICUCRIMax_"^"_ICUCRIMin_"^"_ICUCRIImpossibleMax_"^"_ICUCRIImpossibleMin_"^"_ICUCRIMainICUCRIDr_"^"_ICUCRIDataField_"^"_ICUCRIDataFormat_"^"_ICUCRIFormat_"^"_ICUCRIFormatField_"^"_ICUCRITemplateICUCRIDr_"^"_ICUCRITemplateSubICUCRIDr _"^"_ICUCRISumFormat_"^"_ICUCRISumFormatField

	// Code为能重复
	q:$d(^DHCICUC("RecordItem",0,"Code",ICUCRICode)) "代码重复,存在已激活或未激活记录"
	k PLIST
	TSTART
	s PLIST(2)=ICUCRICode
	s PLIST(3)=ICUCRIDesc
	s PLIST(4)=ICUCRIType
	s PLIST(5)=ICUCRIArcimDr
	s PLIST(6)=ICUCRIViewCatDr
	s PLIST(7)=ICUCRIUomDr
	s PLIST(8)=ICUCRIIconDr
	s PLIST(9)=ICUCRIColor
	//if (ICUCRIAnApply="") s PLIST(10)="N"  //默认为ICU Anapply值为N
	//else  s PLIST(10)=ICUCRIAnApply        
	//s PLIST(10)=ICUCRIAnApply //ypz 141229
	if (ICUCRIIcuApply="") s PLIST(11)="Y"  //默认为ICU Icuapply值为Y
	else  s PLIST(11)=ICUCRIIcuApply
	s PLIST(12)=ICUCRIOptions
	s PLIST(13)=ICUCRIICUCIOIDr
	s PLIST(14)=ICUCRIMultiValueDesc
	s PLIST(15)=ICUCRISortNo
	s PLIST(16)=ICUCRIArcosDr
	s PLIST(17)=ICUCRIDataType
	s PLIST(18)=ICUCRIIsContinue
	s PLIST(19)=ICUCRIAnMethodDr
	s PLIST(20)=ICUCRIMax
	s PLIST(21)=ICUCRIMin
	s PLIST(22)=ICUCRIImpossibleMax
	s PLIST(23)=ICUCRIImpossibleMin
	s PLIST(24)=ICUCRIMainICUCRIDr
	s PLIST(25)=ICUCRIDataField
	s PLIST(26)=ICUCRIDataFormat
	s PLIST(27)=ICUCRIFormat
	s PLIST(28)=ICUCRIFormatField
	s PLIST(29)=ICUCRITemplateICUCRIDr
	s PLIST(30)=ICUCRITemplateSubICUCRIDr
	s PLIST(31)=ICUCRISumFormat
	s PLIST(32)=ICUCRISumFormatField
	//q:(ICUCRIAnApply="Y")&(ICUCRIIcuApply="Y") "状态错!一个常用医嘱不能同时用于手术麻醉或重症监护!"

	&SQL(insert into DHC_ICUC_RecordItem Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCICUCRecordItem).UpdateDHCICUCRItem("1","2","2","D","4","5","6","7","8","Y","Y","11","12","13","14","14","DT","Y","18","19","20","21","22","23","24","25","26","27","28","29","30","31")
ClassMethod UpdateDHCICUCRItem(ICUCRIRowId As %String, ICUCRICode As %String, ICUCRIDesc As %String, ICUCRIType As %String, ICUCRIArcimDr As %String, ICUCRIViewCatDr As %String, ICUCRIUomDr As %String, ICUCRIIconDr As %String, ICUCRIColor As %String, ICUCRIAnApply As %String, ICUCRIIcuApply As %String, ICUCRIOptions As %String, ICUCRIICUCIOIDr As %String, ICUCRIMultiValueDesc As %String, ICUCRISortNo As %String, ICUCRIArcosDr As %String, ICUCRIDataType As %String, ICUCRIIsContinue As %String, ICUCRIAnMethodDr As %String, ICUCRIMax As %String, ICUCRIMin As %String, ICUCRIImpossibleMax As %String, ICUCRIImpossibleMin As %String, ICUCRIMainICUCRIDr As %String, ICUCRIDataField As %String, ICUCRIDataFormat As %String, ICUCRIFormat As %String, ICUCRIFormatField As %String, ICUCRITemplateICUCRIDr As %String, ICUCRITemplateSubICUCRIDr As %String, ICUCRISumFormat As %String, ICUCRISumFormatField As %String)
{
	q:+ICUCRIRowId=0 "记录RowId不对!"
	// Code为能重复
	s id=""
	s id=$O(^DHCICUC("RecordItem",0,"Code",ICUCRICode,id))
	q:((id'=ICUCRIRowId)&&(id'="")) "Code Repeated"
	k PLIST
	TSTART
	s PLIST(2)=ICUCRICode
	s PLIST(3)=ICUCRIDesc
	s PLIST(4)=ICUCRIType
	s PLIST(5)=ICUCRIArcimDr
	s PLIST(6)=ICUCRIViewCatDr
	s PLIST(7)=ICUCRIUomDr
	s PLIST(8)=ICUCRIIconDr
	b
	s PLIST(9)=ICUCRIColor
	//if (ICUCRIAnApply="") s PLIST(10)="N"  //默认为ICU Anapply值为N
	//else  s PLIST(10)=ICUCRIAnApply
	//s PLIST(10)=ICUCRIAnApply //ypz 141229
	if (ICUCRIIcuApply="") s PLIST(11)="Y"  //默认为ICU Icuapply值为Y
	else  s PLIST(11)=ICUCRIIcuApply
	s PLIST(12)=ICUCRIOptions
	s PLIST(13)=ICUCRIICUCIOIDr
	s PLIST(14)=ICUCRIMultiValueDesc
	s PLIST(15)=ICUCRISortNo
	s PLIST(16)=ICUCRIArcosDr
	s PLIST(17)=ICUCRIDataType
	s PLIST(18)=ICUCRIIsContinue
	s PLIST(19)=ICUCRIAnMethodDr
	s PLIST(20)=ICUCRIMax
	s PLIST(21)=ICUCRIMin
	s PLIST(22)=ICUCRIImpossibleMax
	s PLIST(23)=ICUCRIImpossibleMin
	s PLIST(24)=ICUCRIMainICUCRIDr
	s PLIST(25)=ICUCRIDataField
	s PLIST(26)=ICUCRIDataFormat
	s PLIST(27)=ICUCRIFormat
	s PLIST(28)=ICUCRIFormatField
	s PLIST(29)=ICUCRITemplateICUCRIDr
	s PLIST(30)=ICUCRITemplateSubICUCRIDr
	s PLIST(31)=ICUCRISumFormat
	s PLIST(32)=ICUCRISumFormatField
	//i PLIST(9)="" s PLIST(9)=$p(^DHCICUC("RecordItem",tRowId),"^",9)
	//i PLIST(10)="" s PLIST(10)=$p(^DHCICUC("RecordItem",tRowId),"^",10)
	//s retcode=""
	//i (PLIST(9)="Y")&(PLIST(10)="Y") s retcode="状态错!一个常用医嘱不能同时用于手术麻醉或重症监护!"
    //i (PLIST(9)'="Y")&(PLIST(10)'="Y") s retcode="状态错!常用医嘱应用于手术麻醉或重症监护!"	
	&SQL(update DHC_ICUC_RecordItem Values :PLIST() where ICUCRI_RowId=:ICUCRIRowId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod DeleteDHCICUCRItem(ICUCRIRowId As %String)
{
	i ICUCRIRowId'="" d
	.&sql(Update DHC_ICUC_RecordItem set ICUCRI_ICUApply='N' Where ICUCRI_RowId=:ICUCRIRowId)
	.//&SQL(delete from DHC_ICUC_RecordItem where ICUCRI_RowId=:ICUCRIRowId)
	q SQLCODE
}

// 激活删除项目

ClassMethod ActiveDHCICUCRItem(ICUCRIRowId As %String)
{
	s tICUCRIIcuApply=$p($g(^DHCICUC("RecordItem",ICUCRIRowId)),"^",10)
	q:tICUCRIIcuApply="Y" "已激活状态无需操作"
	
	i ICUCRIRowId'="" d
	.&sql(Update DHC_ICUC_RecordItem set ICUCRI_ICUApply='Y' Where ICUCRI_RowId=:ICUCRIRowId)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindICUCRIType")
/// 类型
Query FindICUCRIType() As %Query(ROWSPEC = "Desc:%String,Id:%String") [ SqlProc ]
{
}

ClassMethod FindICUCRITypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="D",Desc="药品"
	d OutputRow1
	s Id="V",Desc="生命体征"
	d OutputRow1
	s Id="E",Desc="事件"
	d OutputRow1
	s Id="T",Desc="治疗"
	d OutputRow1
	s Id="L",Desc="检验"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCRITypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCRITypeExecute ]
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

ClassMethod FindICUCRITypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCRITypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindICUCRIViewCat","")
/// 显示分类
Query FindICUCRIViewCat(ICUCRIIcuApply As %String) As %Query(ROWSPEC = "ICUCRIVCCode:%String,ICUCRIVCDesc:%String,ICUCRIVCId:%String") [ SqlProc ]
{
}

ClassMethod FindICUCRIViewCatExecute(ByRef qHandle As %Binary, ICUCRIIcuApply As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ICUCRIVCId=0
	f  s ICUCRIVCId=$o(^DHCICUC("ViewCat",ICUCRIVCId))  q:ICUCRIVCId=""  d
	.q:(ICUCRIIcuApply'="Y")&($p(^DHCICUC("ViewCat",ICUCRIVCId),"^",7)'="Y") 
    .q:(ICUCRIIcuApply="Y")&($p(^DHCICUC("ViewCat",ICUCRIVCId),"^",8)'="Y") 
	.s ICUCRIVCCode=$p($g(^DHCICUC("ViewCat",ICUCRIVCId)),"^",1)
    .s ICUCRIVCDesc=$p($g(^DHCICUC("ViewCat",ICUCRIVCId)),"^",2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(ICUCRIVCCode,ICUCRIVCDesc,ICUCRIVCId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCRIViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCRIViewCatExecute ]
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

ClassMethod FindICUCRIViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCRIViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 单位 d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindUom")
Query FindUom() As %Query(ROWSPEC = "UomDesc:%String,UomRowId:%String") [ SqlProc ]
{
}

ClassMethod FindUomExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s UomRowId=0
	f  s UomRowId=$o(^CT("UOM",UomRowId))  q:UomRowId=""  d
    .s UomDesc=$p(^CT("UOM",UomRowId),"^",2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(UomDesc,UomRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindUomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUomExecute ]
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

ClassMethod FindUomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 图标 d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindIcon")
Query FindIcon() As %Query(ROWSPEC = "IconDesc:%String,IconRowId:%String") [ SqlProc ]
{
}

ClassMethod FindIconExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s IconRowId=0
	f  s IconRowId=$o(^DHCANC("Icon",IconRowId))  q:IconRowId=""  d
    .s IconDesc=$p(^DHCANC("Icon",IconRowId),"^",2)
	.d OutputRow8
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(IconDesc,IconRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindIconFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIconExecute ]
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

ClassMethod FindIconClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIconExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindICUCRIAnApply")
Query FindICUCRIAnApply() As %Query(ROWSPEC = "Desc:%String,Id:%String") [ SqlProc ]
{
}

ClassMethod FindICUCRIAnApplyExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="Y",Desc="Yes"
	d OutputRow1
	s Id="N",Desc="No"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCRIAnApplyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCRIAnApplyExecute ]
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

ClassMethod FindICUCRIAnApplyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCRIAnApplyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindICUCRIDataType")
/// 数据类型
Query FindICUCRIDataType() As %Query(ROWSPEC = "Desc:%String,Id:%String") [ SqlProc ]
{
}

ClassMethod FindICUCRIDataTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="N",Desc="数值"
	d OutputRow1
	s Id="S",Desc="字符串"
	d OutputRow1
	s Id="C",Desc="单选"
	d OutputRow1
	s Id="M",Desc="多选"
	d OutputRow1
	s Id="I",Desc="图标"
	d OutputRow1
	s Id="D",Desc="日期"
	d OutputRow1
	s Id="DT",Desc="时间"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCRIDataTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCRIDataTypeExecute ]
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

ClassMethod FindICUCRIDataTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCRIDataTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 模版
/// d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindIcucMain")
Query FindIcucMain(IcuMainDesc As %String, IcuApply As %String, AllApply As %String) As %Query(ROWSPEC = "IcucDesc:%String,IcucCode:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod FindIcucMainExecute(ByRef qHandle As %Binary, IcuMainDesc As %String = "", IcuApply As %String = "", AllApply As %String = "") As %Status
{
   
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s rowid=0
	i AllApply="" s AllApply="N"
	i IcuApply="" s IcuApply="Y"
	f  s rowid=$o(^DHCICUC("RecordItem",rowid)) q:rowid=""  d
	.;s tANCEViewCatId=$p($g(^DHCICUC("RecordItem",rowid)),"^",5)  &(ancoMainAncoDr'="")
	.;q:(ANCEViewCat'="")&(("|"_tANCEViewCatId_"|")'[("|"_ANCEViewCat_"|"))
	.s ancoMainAncoDr=$p(^DHCICUC("RecordItem",rowid),"^",23)
    .s tAnApply=$p(^DHCICUC("RecordItem",rowid),"^",9)
    .//q:(tAnApply'="Y")&(IcuApply'="Y")&(AllApply="N")
    .s tIcuApply=$p(^DHCICUC("RecordItem",rowid),"^",10)
    .q:(tIcuApply'="Y")&(IcuApply="Y")&(AllApply="N")
    .s IcucCode=$p(^DHCICUC("RecordItem",rowid),"^",1)
	.s IcucDesc=$p(^DHCICUC("RecordItem",rowid),"^",2)
	.q:(IcuMainDesc'="")&(IcucDesc'[IcuMainDesc)
 	.Do OutputRow12
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow12
	set Data=$lb(IcucDesc,IcucCode,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindIcucMainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcucMainExecute ]
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

ClassMethod FindIcucMainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcucMainFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 模版子项
Query FindIcucSubAncoMain(IcuAncStr As %String = "", IcuSubAncStr As %String = "", IcuApply As %String, AllApply As %String) As %Query(ROWSPEC = "icucdesc:%String,icucCode:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod FindIcucSubAncoMainExecute(ByRef qHandle As %Binary, IcuAncStr As %String = "", IcuSubAncStr As %String = "", IcuApply As %String = "", AllApply As %String = "") As %Status
{
   
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s rowid=0
	s AncStr=IcuSubAncStr
	i AllApply="" s AllApply="N"
	i IcuApply="" s IcuApply="Y"	
	f  s rowid=$o(^DHCICUC("RecordItem",rowid)) q:rowid=""  d
	.;q:(IcuAncStr'="")&(IcuAncStr'=$p(^DHCANC("ComOrd",rowid),"^",28))
	.q:(IcuAncStr'="")&(IcuAncStr'=$p(^DHCICUC("RecordItem",rowid),"^",23))
	.;s tANCEViewCatId=$p($g(^DHCANC("ComOrd",rowid)),"^",5)  &(ancoMainAncoDr'="")
	.;q:(ANCEViewCat'="")&(("|"_tANCEViewCatId_"|")'[("|"_ANCEViewCat_"|"))
	.;s ancoMainAncoDr=$p(^DHCANC("ComOrd",rowid),"^",23)
    .s tAnApply=$p(^DHCICUC("RecordItem",rowid),"^",9)
    .//q:(tAnApply'="Y")&(IcuApply'="Y")&(AllApply="N")
    .s tIcuApply=$p(^DHCICUC("RecordItem",rowid),"^",10)
    .q:(tIcuApply'="Y")&(IcuApply="Y")&(AllApply="N")
    .s icucCode=$p(^DHCICUC("RecordItem",rowid),"^",1)
	.s icucdesc=$p(^DHCICUC("RecordItem",rowid),"^",2)
	.i ((AncStr'="")&((AncStr=icucCode)!(icucdesc[AncStr)!(rowid=AncStr))) Do OutputRow12
	.i (AncStr="") Do OutputRow12
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow12
	set Data=$lb(icucdesc,icucCode,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindIcucSubAncoMainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcucSubAncoMainExecute ]
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

ClassMethod FindIcucSubAncoMainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcucSubAncoMainFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*Query FindIOI() As %Query(ROWSPEC = "IOIDesc:%String,IOIRowId:%String")
{
}

ClassMethod FindIOIExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s IOIRowId=0
	f  s IOIRowId=$o(^MRC("OBITM",IOIRowId))  q:IOIRowId=""  d
    .s IOIDesc=$p($g(^MRC("OBITM",IOIRowId)),"^",2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(IOIDesc,IOIRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindIOIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIOIExecute ]
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

ClassMethod FindIOIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIOIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}*/
/// 观察项 d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindIOI")
/// 医嘱套 d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindArcos")
Query FindArcos() As %Query(ROWSPEC = "ArcosDesc:%String,ArcosRowId:%String") [ SqlProc ]
{
}

ClassMethod FindArcosExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ArcosRowId=0
	f  s ArcosRowId=$o(^ARCOS(ArcosRowId))  q:ArcosRowId=""  d
    .s ArcosDesc=$p($g(^ARCOS(+ArcosRowId)),"^",2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(ArcosDesc,ArcosRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindArcosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcosExecute ]
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

ClassMethod FindArcosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 格式字段

Query FindIcuDataField() As %Query(ROWSPEC = "DataField:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod FindIcuDataFieldExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCANC("DataField","ComOrd",rowid))  q:rowid=""  d
    .s DataField=^DHCANC("DataField","ComOrd",rowid)
	.d OutputRow10
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow10
	set Data=$lb(DataField,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindIcuDataFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuDataFieldExecute ]
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

ClassMethod FindIcuDataFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuDataFieldFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","GetICUCRecordItemList")

Query GetICUCRecordItemList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   ICUCRI_Code As Code,
	   ICUCRI_Desc As Description,
	   ICUCRI_ViewCat_Dr As CategoryId,
	   ICUCRI_Icon_Dr As IconId,
	   ICUCRI_Color As Color,
	   ICUCRI_Options As DataOptions,
	   ICUCRI_SortNo As SortNo,
	   ICUCRI_Type As Type,
	   ICUCRI_DataType As DataType,
	   ICUCRI_DataField As DataField,
	   ICUCRI_DataFormat As DataFormat,
	   ICUCRI_FormatField As DataFormatField,
	   ICUCRI_Max As MaxWarningValue,
	   ICUCRI_Min As MinWarningValue,
	   ICUCRI_ImpossibleMax As ImpossibleMax,
	   ICUCRI_ImpossibleMin As ImpossibleMin,
	   ICUCRI_MainICUCRI_Dr As MainItemId,
	   ICUCRI_TemplateICUCRI_Dr As TemplateItemId,
	   ICUCRI_ICUCIOI_Dr As SummaryItemId,
	   ICUCRI_TemplateSubIcucri_Dr As TemplateSubAncoId,
	   ICUCRI_SumFormat As SummaryFormat,
	   ICUCRI_SumFormatField As SummaryFormatField
	   FROM DHC_ICUC_RecordItem Where ICUCRI_IcuApply='Y'
}

/// 重症前台用：名称、显示分类从科室模板取
/// d ##class(%ResultSet).RunQuery("web.DHCICUCRecordItem","FindICUCRecordItem2","1")
Query FindICUCRecordItem2(icuaId = "", ICUCRIDesc As %String = "", ICUCRIViewCat As %String = "", ICUCRICat As %String = "", AnApply As %String = "", AllApply As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,CategoryId:%String,IconId:%String,Color:%String,DataOptions:%String,SortNo:%String,Type:%String,DataType:%String,DataField:%String,DataFormat:%String,DataFormatField:%String,MaxWarningValue:%String,MinWarningValue:%String,ImpossibleMax:%String,ImpossibleMin:%String,MainItemId:%String,TemplateItemId:%String,SummaryItemId:%String,TemplateSubAncoId:%String,SummaryFormat:%String,SummaryFormatField,CriticalMax:%String,CriticalMin:%String") [ SqlProc ]
{
}

ClassMethod FindICUCRecordItem2Execute(ByRef qHandle As %Binary, icuaId = "", ICUCRIDesc As %String = "", ICUCViewCat As %String = "", ICUCRICat As %String = "", AnApply As %String = "N", AllApply As %String = "N") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i icuaId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s tRowId=0,tCtlocId="",deptTempId=""
	// 查找icuaId对应的科室
	s episodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	s bedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s papmiId=$p($g(^PAADM(episodeID)),"^",1)
	i bedId'="" d
	.s wardId=$p(bedId,"||",1)
	.s tCtlocId=$p(^PAWARD(+wardId),"^",5)
	// 查找科室模板ID
	s deptTempId=$O(^DHCICUPara(0,"Ctloc",tCtlocId,deptTempId))
	// 建立索引
	s tempRowId="",sub="",tName=""
	
	f  s tempRowId=$O(^DHCICUPara(deptTempId,"I",tempRowId)) q:(tempRowId="")  d
	.s recordItemId=$p($g(^DHCICUPara(deptTempId,"I",tempRowId)),"^",4)
	.;q:recordItemId'=tRowId
	.f  s sub=$O(^DHCICUPara(deptTempId,"I",tempRowId,"D",sub)) q:(sub="")  d
	..s itemStr=$g(^DHCICUPara(deptTempId,"I",tempRowId,"D",sub))
	..;b "xx"
	..s typeDr=$p(itemStr,"^",1)
	..i typeDr'="" d
	...i $d(^DHCICUC("Property",typeDr)) s type=$LIST(^DHCICUC("Property",typeDr),1)
	..s enable=$p(itemStr,"^",2)
	..q:((type'="IsTemplate")||(enable'="true"))
	..s isTemplate=1
	..s tName=$p($g(^DHCICUPara(deptTempId,"I",tempRowId)),"^",14)
	..s viewCatDr=$p($g(^DHCICUPara(deptTempId,"I",tempRowId)),"^",11)
	..s TempRecordItem(recordItemId)=tName
	..s TempRecordItem(recordItemId,"ViewCatDr")=viewCatDr
	
	k icucItemList
	f  s tRowId=$o(^DHCICUC("RecordItem",tRowId))  q:tRowId=""  d
	.s tICUCRIViewCatDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",5)
	.
	.s tICUCRISortNo=$p($g(^DHCICUC("RecordItem",tRowId)),"^",14)
	.s tICUCRICode=$p($g(^DHCICUC("RecordItem",tRowId)),"^",1)
	.s icucItemList(tICUCRISortNo_","_tICUCRICode_","_tRowId)=tRowId
	s icuciNode=""
 	f  s icuciNode=$o(icucItemList(icuciNode)) q:icuciNode=""  d
	.s tRowId=icucItemList(icuciNode)
	.s tICUCRICode=$p($g(^DHCICUC("RecordItem",tRowId)),"^",1)
	.s tICUCRIDesc=$p($g(^DHCICUC("RecordItem",tRowId)),"^",2)
	.q:(ICUCRIDesc'="")&(tICUCRIDesc'[ICUCRIDesc)
	.s tICUCRIType=$p($g(^DHCICUC("RecordItem",tRowId)),"^",3)
	.s tICUCRITypeDesc=""
	.i tICUCRIType="D" s tICUCRITypeDesc="药品"
	.i tICUCRIType="V" s tICUCRITypeDesc="生命体征"
	.i tICUCRIType="E" s tICUCRITypeDesc="事件"
	.i tICUCRIType="T" s tICUCRITypeDesc="治疗"
	.i tICUCRIType="L" s tICUCRITypeDesc="检验"
	.q:(ICUCRICat'="")&(ICUCRICat'=tICUCRITypeDesc)
	.s tICUCRIArcimDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",4)
	.s tICUCRIArcim=""
	.i tICUCRIArcimDr'="" do
	..f j=1:1:$l(tICUCRIArcimDr,"~") d
	...s SubID=$p($p(tICUCRIArcimDr,"~",j),"||",1)
	...s VerID=$p($p(tICUCRIArcimDr,"~",j),"||",2)
	...q:VerID=""
	...s tICUCRIArcim=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
	.s tICUCRIViewCatDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",5)
	.s tICUCRIViewCat=""
    .f i=1:1:$l(tICUCRIViewCatDr,"|") d
    ..s icucvcId=$p(tICUCRIViewCatDr,"|",i)
    ..q:+icucvcId=0
    ..i tICUCRIViewCat'="" s tICUCRIViewCat=tICUCRIViewCat_";"
    ..s tICUCRIViewCat=tICUCRIViewCat_$p($g(^DHCICUC("ViewCat",icucvcId)),"^",2)
    .q:(ICUCViewCat'="")&(tICUCRIViewCat'[ICUCViewCat)
	.s tICUCRIUomDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",6)
	.s tICUCRIUom=""
    .i +tICUCRIUomDr'=0 s tICUCRIUom=$p($g(^CT("UOM",tICUCRIUomDr)),"^",2)
	.s tICUCRIIconDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",7)
	.s tICUCRIIcon=""
    .i +tICUCRIIconDr'=0 s tICUCRIIcon=$p($g(^DHCANC("Icon",tICUCRIIconDr)),"^",2)
	.s tICUCRIColor=$p($g(^DHCICUC("RecordItem",tRowId)),"^",8)
	.s tICUCRIAnApply=$p($g(^DHCICUC("RecordItem",tRowId)),"^",9)
	.//q:(tICUCRIAnApply'="Y")&(AnApply="Y")&(AllApply="N")
	.s tICUCRIIcuApply=$p($g(^DHCICUC("RecordItem",tRowId)),"^",10)
	.q:(tICUCRIIcuApply'="Y")&(AllApply="N")  //&(AnApply'="Y")
	.s tICUCRIOptions=$p($g(^DHCICUC("RecordItem",tRowId)),"^",11)
	.s tICUCRIICUCIOIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",12)
    .s tICUCRIICUCIOI=""
    .i tICUCRIICUCIOIDr>0 s tICUCRIICUCIOI=$p($g(^DHCICUC("IOItem",tICUCRIICUCIOIDr)),"^",2) ;$p($g(^DHCICUC("IOItem",tICUCRIICUCIOIDr)),"^",2)
	.i tICUCRIICUCIOIDr>0 d
    ..&sql(SELECT ICUCIOI_RowId into :tICUCRIICUCIOIDr FROM DHC_ICUC_IOItem WHERE ICUCIOI_Ctloc_Dr=:tCtlocId AND ICUCIOI_ComOrd_Dr=:tRowId)
	.s tICUCRIMultiValueDesc=$p($g(^DHCICUC("RecordItem",tRowId)),"^",13)
	.s tICUCRISortNo=$p($g(^DHCICUC("RecordItem",tRowId)),"^",14)
	.s tICUCRIArcosDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",15)
	.s tICUCRIArcos=$p($g(^ARCOS(+tICUCRIArcosDr)),"^",2)
	.s tICUCRIDataType=$p($g(^DHCICUC("RecordItem",tRowId)),"^",16)
	.s tICUCRIDataTypeDesc =##class(web.DHCCLCom).GetComDescByCode("DataType",tICUCRIDataType)
	.s tICUCRIIsContinue=$p($g(^DHCICUC("RecordItem",tRowId)),"^",17)
	.s tICUCRIAnMethodDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",18)
	.s tICUCRIMax=$p($g(^DHCICUC("RecordItem",tRowId)),"^",19)
	.s tICUCRIMin=$p($g(^DHCICUC("RecordItem",tRowId)),"^",20)
	.s tICUCRIImpossibleMax=$p($g(^DHCICUC("RecordItem",tRowId)),"^",21)
	.s tICUCRIImpossibleMin=$p($g(^DHCICUC("RecordItem",tRowId)),"^",22)
	.s tICUCRIMainICUCRIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",23)
	.s tICUCRIMainICUCRI = $p($g(^DHCICUC("RecordItem",+tICUCRIMainICUCRIDr)),"^",2)
	.s tICUCRIDataField=$p($g(^DHCICUC("RecordItem",tRowId)),"^",24)
	.s tICUCRIDataFormat=$p($g(^DHCICUC("RecordItem",tRowId)),"^",25)
	.s tICUCRIFormat=$p($g(^DHCICUC("RecordItem",tRowId)),"^",26)
	.s tICUCRIFormatField=$p($g(^DHCICUC("RecordItem",tRowId)),"^",27)
	.s tICUCRITemplateICUCRIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",28)
	.s tICUCRITemplateICUCRI= $p($g(^DHCICUC("RecordItem",+tICUCRITemplateICUCRIDr)),"^",2)
	.s tICUCRITemplateSubICUCRIDr=$p($g(^DHCICUC("RecordItem",tRowId)),"^",29)
	.s tICUCRITemplateSubICUCRI=""
	.f i=1:1:$l(tICUCRITemplateSubICUCRIDr,"|") d
	..s TempSubId=$p(tICUCRITemplateSubICUCRIDr,"|",i)
	..q:TempSubId=""
	..i tICUCRITemplateSubICUCRI'="" s tICUCRITemplateSubICUCRI=tICUCRITemplateSubICUCRI_";"
	..s tICUCRITemplateSubICUCRI=tICUCRITemplateSubICUCRI_$p($g(^DHCICUC("RecordItem",TempSubId)),"^",2)
	.s CriticalMax=$p($g(^DHCICUC("RecordItem",tRowId)),"^",32)
	.s CriticalMin=$p($g(^DHCICUC("RecordItem",tRowId)),"^",33)
	.s tICUCRISumFormat=$p($g(^DHCICUC("RecordItem",tRowId)),"^",30)
	.s tICUCRISumFormatField=$p($g(^DHCICUC("RecordItem",tRowId)),"^",31)
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	
	Quit $$$OK
OutputRow2	
	s tName=$g(TempRecordItem(tRowId))
	i tName'="" s tICUCRIDesc=tName
	s tViewCatDr=$g(TempRecordItem(tRowId,"ViewCatDr"))
	i tViewCatDr'="" s tICUCRIViewCatDr=tViewCatDr
	i tICUCRIMainICUCRIDr="" s tICUCRIMainICUCRIDr="0"
	;i "5374^5376^5377^5378^5016"[tRowId  s tICUCRIViewCatDr=252
	set Data=$lb(tRowId,tICUCRICode,tICUCRIDesc,tICUCRIViewCatDr,tICUCRIIconDr,tICUCRIColor,tICUCRIOptions,tICUCRISortNo,tICUCRIType,tICUCRIDataType,tICUCRIDataField,tICUCRIDataFormat,tICUCRIFormatField,tICUCRIMax,tICUCRIMin,tICUCRIImpossibleMax,tICUCRIImpossibleMin,tICUCRIMainICUCRIDr,tICUCRITemplateICUCRIDr,tICUCRIICUCIOIDr,tICUCRITemplateSubICUCRIDr,tICUCRISumFormat,tICUCRISumFormatField,CriticalMax,CriticalMin)
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCRecordItem2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCRecordItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindICUCRecordItem2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCRecordItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetId(code)
{
	// w ##class(User.DHCICUCRecordItem).GetId(code)
	s recordItemId=""
	&sql(SELECT ICUCRI_RowId into :recordItemId FROM DHC_ICUC_RecordItem WHERE ICUCRI_Code=:code)
	q recordItemId
}

}
