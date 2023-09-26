Import SQLUser

Class web.DHCANCCommonOrd Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod AddCommonOrd(itmjs As %Library.String = "", itm As %Library.String = "", Str As %String) As %String
{
 s retcode=..InsertCommonOrd(Str)
 s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
 q retcode
}

ClassMethod InsertCommonOrd(val As %String) As %String
{
	s ANCOCode=$p(val,"^",1)
	s ANCODesc=$p(val,"^",2)
	s ANCOType=$p(val,"^",3)
	s ANCOArcimDr=$p(val,"^",4)
	s ANCEViewCatId=$p(val,"^",5)
	//wxl
	s ANCOUomDrId=$p(val,"^",6)
	s ANCOIconDrId=$p(val,"^",7)
	s ANCOColor=$p(val,"^",8)
	s ANCOAnApply=$p(val,"^",9)
	s ANCOIcuApply=$p(val,"^",10)	
	s ANCOOptions=$p(val,"^",11)
	s itmId=$p(val,"^",12)	
	s ancoMultiValueDesc=$p(val,"^",13)	
	s ancoSortNo=$p(val,"^",14)
	s arcosId=$p(val,"^",15)
	s ancoDataType = $p(val,"^",16) //liangq 20101203
	s ancoIsContinue = $p(val,"^",17)
	s ancoAnMethodDr = $p(val,"^",18)
	s ancoMax = $p(val,"^",19)
	s ancoMin = $p(val,"^",20)
    s ANCOImpossibleMax = $p(val,"^",21) //whl 20120420
	s ANCOImpossibleMin = $p(val,"^",22)
	s ANCOMainAncoDr = $p(val,"^",23)
	s ANCODataField = $p(val,"^",24)
	s ANCODataFormat = $p(val,"^",25)
	
	s ANCOFormatField=$p(val,"^",26)
    s ANCOTemplateAncoDrID=$p(val,"^",27)
    s ANCOTemplateSubAncoDrID=$p(val,"^",28)
	q:(ANCOAnApply="Y")&(ANCOIcuApply="Y") "状态错!一个常用医嘱不能同时用于手术麻醉或重症监护!"
	s ancoStr=ANCOCode_"^"_ANCODesc_"^"_ANCOType_"^"_ANCOArcimDr_"^"_ANCEViewCatId_"^"_ANCOUomDrId_"^"_ANCOIconDrId_"^"_ANCOColor_"^"_ANCOAnApply_"^"_ANCOIcuApply_"^"_ANCOOptions_"^"_itmId_"^"_ancoMultiValueDesc_"^"_ancoSortNo_"^"_arcosId_"^"_ancoDataType_"^"_ancoIsContinue_"^"_ancoAnMethodDr_"^"_ancoMax_"^"_ancoMin_"^"_ANCOImpossibleMax_"^"_ANCOImpossibleMin_"^"_ANCOMainAncoDr_"^"_ANCODataField_"^"_ANCODataFormat_"^"_ANCOFormatField_"^"_ANCOTemplateAncoDrID_"^"_ANCOTemplateSubAncoDrID
	s retcode=0
	i ANCOAnApply="Y" d
		.s ancoId=$o(^DHCANC("ComOrd",5001),-1)
		.i ancoId>4999 s retcode="麻醉常用医嘱无插入数据空间!" q
		.s retcode=0
		.s ancoId=ancoId+1
		.s ^DHCANC("ComOrd",ancoId)=ancoStr
		.q:(ANCOType="")!(ANCOCode="")
		.s ^DHCANC("ComOrd",0,"TypeCode",ANCOType,ANCOCode,ancoId)=""
	i ANCOIcuApply="Y" d
		.&sql(INSERT INTO DHC_ANC_CommonOrd(ANCO_Code,ANCO_Desc,ANCO_Type,ANCO_Arcim_Dr,ANCO_ViewCat_Dr,ANCO_Uom_Dr,ANCO_Icon_Dr,ANCO_Color,ANCO_AnApply,ANCO_IcuApply,ANCO_Options,ANCO_ICUCIOI_Dr,ANCO_MultiValueDesc,ANCO_SortNo,ANCO_Arcos_Dr,ANCO_DataType,ANCO_IsContinue,ANCO_AnMethod_Dr,ANCO_Max,ANCO_Min,ANCO_ImpossibleMax,ANCO_ImpossibleMin,ANCO_MainAnco_Dr,ANCO_DataField,ANCO_DataFormat,ANCO_FormatField,ANCO_TemplateAnco_Dr,ANCO_TemplateSubAnco_Dr) Values (:ANCOCode,:ANCODesc,:ANCOType,:ANCOArcimDr,:ANCEViewCatId,:ANCOUomDrId,:ANCOIconDrId,:ANCOColor,:ANCOAnApply,:ANCOIcuApply,:ANCOOptions,:itmId,:ancoMultiValueDesc,:ancoSortNo,:arcosId,:ancoDataType,:ancoIsContinue,:ancoAnMethodDr,:ancoMax,:ancoMin,:ANCOImpossibleMax,:ANCOImpossibleMin,:ANCOMainAncoDr,:ANCODataField,:ANCODataFormat,:ANCOFormatField,:ANCOTemplateAncoDrID,:ANCOTemplateSubAncoDrID))
		.i SQLCODE s retcode="插入数据错! code="_SQLCODE
	q retcode
}

ClassMethod DeleteCommonOrd(itmjs As %Library.String = "", itm As %Library.String = "", ID As %String)
{
    &sql(Delete From DHC_ANC_CommonOrd Where ANCO_RowId=:ID)
    set retcode=SQLCODE
    s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
    i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
    &javascript<#(retval)#>
    quit SQLCODE
}

ClassMethod DelComOrdAppFlag(itmjs As %Library.String = "", itm As %Library.String = "", val As %String)
{
    set ID=$p(val,"^",1)
    set ANCOAnApply=$p(val,"^",2)
    set ANCOIcuApply=$p(val,"^",3)
    i ANCOAnApply="N" d
    .&sql(Update DHC_ANC_CommonOrd set ANCO_AnApply=:ANCOAnApply Where ANCO_RowId=:ID)
    i ANCOIcuApply="N" d
    .&sql(Update DHC_ANC_CommonOrd set ANCO_IcuApply=:ANCOIcuApply Where ANCO_RowId=:ID)
    set retcode=SQLCODE
    s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
    i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
    &javascript<#(retval)#>
    quit SQLCODE
}

ClassMethod GetMasterItemoldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemoldExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMasterItemoldExecute(ByRef qHandle As %Binary, ANCOArcimDr As %String, needItemCatId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	If $g(ind)="" Set ind=1
	s ArcID=0 f  s ArcID=$o(^ARCIM(ArcID)) q:ArcID=""  d
	.s VerID=0 f  s VerID=$o(^ARCIM(ArcID,VerID)) q:VerID=""  d
	..;w !,ArcID_"^"_VerID
	..s Name=$p(^ARCIM(ArcID,VerID,1),"^",2)
	..;w !,Name
	..s ItemType=$p(^ARCIM(ArcID,VerID,1),"^",10)
	..s rowid0=ArcID_"||"_VerID
	..i ANCOArcimDr=""  d
	...i +needItemCatId=0  d
 	....d OutputRow1
 	...e  d
 	....i needItemCatId=ItemType  d
 	.....D OutputRow1
 	..e  d
 	...s AliasID=0 f  s AliasID=$o(^ARC("ALIAS",0,"ARCIM",rowid0,AliasID))  q:AliasID=""  d
 	....S Incode=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AliasID),"^",6))
 	....S ANCOArcimDr=$$ALPHAUP^SSUTIL4(ANCOArcimDr)
 	....if (ANCOArcimDr'="")&($p(Incode,ANCOArcimDr,1)'="") q  d
 	.....if +needItemCatId=""  d
    ......D OutputRow1	 
 	.....e  d
 	......i needItemCatId=ItemType  d
 	.......D OutputRow1	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow1
	set Data=$lb(Name,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMasterItemoldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemoldExecute ]
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

Query GetMasterItemold(ANCOArcimDr As %String, needItemCatId As %String) As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

ClassMethod FindANCCommonOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCCommonOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANCCommonOred","FindANCCommonOrd","","108","","N","N")
ClassMethod FindANCCommonOrdExecute(ByRef qHandle As %Binary, ANCODesc As %String = "", ANCEViewCat As %String, ANCOCat As %String = "", IcuApply As %String = "", AllApply As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	If $g(ind)="" Set ind=1
	s rowid=0
	s ^tmm(345)=ANCODesc_"^"_ANCEViewCat_"^"_ANCOCat_"^"_IcuApply_"^"_AllApply
	//i ANCOCat="" s ANCOCat="药品"
	i AllApply="" s AllApply="N"
	k ancOrdList	
	f  s rowid=$o(^DHCANC("ComOrd",rowid)) q:rowid=""  d
		.s tANCEViewCatId=$p($g(^DHCANC("ComOrd",rowid)),"^",5)
		.;w !,"|"_tANCEViewCatId_"|"
		.q:(ANCEViewCat'="")&(("|"_tANCEViewCatId_"|")'[("|"_ANCEViewCat_"|"))
		.s tAncoSortNo=$p($g(^DHCANC("ComOrd",rowid)),"^",14)
		.s ancoCode=$p(^DHCANC("ComOrd",rowid),"^",1)
		.s ancOrdList(tAncoSortNo_","_ancoCode_","_rowid)=rowid
 	s ancoNode=""
 	f  s ancoNode=$o(ancOrdList(ancoNode)) q:ancoNode=""  d
		.s rowid=ancOrdList(ancoNode)
		.s ComID=$p(^DHCANC("ComOrd",rowid),"^",1)
		.s ComDes=$p(^DHCANC("ComOrd",rowid),"^",2)
		.q:(ANCODesc'="")&(ComDes'[ANCODesc)
		.s ComCatID=$p(^DHCANC("ComOrd",rowid),"^",3)
		.//s ComCat=$SELECT(ComCatID="D":"药品",ComCatID="P":"处置",ComCatID="M":"材料",ComCatID="E":"检验",1:"")
		.s ComCat=$SELECT(ComCatID="D":"药品",ComCatID="V":"生命体征",ComCatID="E":"事件",ComCatID="T":"治疗",ComCatID="L":"检验",1:"")
		.q:((ANCOCat'="")&(ANCOCat'=ComCat))
		.;s ^tempmfc("2012")=ANCOCat_"^"_ANCOCat_"^"_ANCODesc_"^"_ANCEViewCat
		.s ComItmID=$p(^DHCANC("ComOrd",rowid),"^",4)
		.s ComItm=""
		.i ComItmID'="" do
		..f j=1:1:$l(ComItmID,"~") d
		...s SubID=$p($p(ComItmID,"~",j),"||",1)
		...s VerID=$p($p(ComItmID,"~",j),"||",2)
		...q:VerID=""
		...s ComItm=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
		.s tANCEViewCatId=$p(^DHCANC("ComOrd",rowid),"^",5)
	    .s tANCEViewCat=""
	    .f i=1:1:$l(tANCEViewCatId,"|") d
	    ..s ancvcId=$p(tANCEViewCatId,"|",i)
	    ..q:+ancvcId=0
	    ..i tANCEViewCat'="" s tANCEViewCat=tANCEViewCat_";"
	    ..s tANCEViewCat=tANCEViewCat_$p($g(^DHCANC("ViewCat",ancvcId)),"^",2)
	    .//wxl
	    .s tUomRowId=$p(^DHCANC("ComOrd",rowid),"^",6)
	    .s tUomDesc=""
	    .i +tUomRowId'=0 s tUomDesc=$p($g(^CT("UOM",tUomRowId)),"^",2)
	    .s tIconRowId=$p(^DHCANC("ComOrd",rowid),"^",7)
	    .s tIconDesc=""
	    .i +tIconRowId'=0 s tIconDesc=$p($g(^DHCANC("Icon",tIconRowId)),"^",2)
	    .s tColorDesc=$p(^DHCANC("ComOrd",rowid),"^",8)
	    .s tOptions=$p(^DHCANC("ComOrd",rowid),"^",11)
	    .s tAnApply=$p(^DHCANC("ComOrd",rowid),"^",9)	    
	    .q:(tAnApply'="Y")&(IcuApply'="Y")&(AllApply="N")
	    .s tIcuApply=$p(^DHCANC("ComOrd",rowid),"^",10)
	    .q:(tIcuApply'="Y")&(IcuApply="Y")&(AllApply="N")
	    .s tItmId=$p(^DHCANC("ComOrd",rowid),"^",12)
	    .s tItmDesc=""
            .i tItmId>0 s tItmDesc=$p($g(^MRC("OBITM",+tItmId)),"^",2)
	    .s tAncoMultiValueDesc=$p(^DHCANC("ComOrd",rowid),"^",13)
	    .s tAncoSortNo=$p(^DHCANC("ComOrd",rowid),"^",14)
	    .s arcosId=$p(^DHCANC("ComOrd",rowid),"^",15)
	    .s tArcos=$p($g(^ARCOS(+arcosId)),"^",2)
	    .s tAncoDataTypeDesc = $p(^DHCANC("ComOrd",rowid),"^",16)
	    .;s tAncoDataTypeDesc =##class(web.DHCCLCom).GetComDescByCode("DataType",ancoDataType)
	    .s tAncoIsContinue = $p(^DHCANC("ComOrd",rowid),"^",17)
		.s tAncoAnMethodDr = $p(^DHCANC("ComOrd",rowid),"^",18)
		.s tAncoMax = $p(^DHCANC("ComOrd",rowid),"^",19)
		.s tAncoMin = $p($g(^DHCANC("ComOrd",rowid)),"^",20)
		.s tANCOImpossibleMax = $p(^DHCANC("ComOrd",rowid),"^",21)
		.s tANCOImpossibleMin = $p(^DHCANC("ComOrd",rowid),"^",22)
		.s tANCOMainAncoDr = $p(^DHCANC("ComOrd",rowid),"^",23)
		.s tANCOMainAncoDrdesc = $p($g(^DHCANC("ComOrd",+tANCOMainAncoDr)),"^",2)
		.s tANCODataField  = $p(^DHCANC("ComOrd",rowid),"^",24)
		.s tANCODataFormat  = $p(^DHCANC("ComOrd",rowid),"^",25)
		.;
		.s tANCOFormatField= $p(^DHCANC("ComOrd",rowid),"^",27)
		.s tANCOTemplateAncoDrID= $p(^DHCANC("ComOrd",rowid),"^",28)
		.s tANCOTemplateAncoDr = $p($g(^DHCANC("ComOrd",+tANCOTemplateAncoDrID)),"^",2)	
		.;ADD MFC 121205模板子项
		.s ANCOTemplateSubAncoDrID= $p(^DHCANC("ComOrd",rowid),"^",29)    
        .s ANCOTemplateSubAncoDr=""
        .f j=1:1:$l(ANCOTemplateSubAncoDrID,"|") d
	    ..s SubAncoDrID=$p(ANCOTemplateSubAncoDrID,"|",j)
	    ..q:SubAncoDrID=""
	    ..i (ANCOTemplateSubAncoDr="") s ANCOTemplateSubAncoDr = $p($g(^DHCANC("ComOrd",+SubAncoDrID)),"^",2)
	    ..e  s ANCOTemplateSubAncoDr = ANCOTemplateSubAncoDr_","_$p($g(^DHCANC("ComOrd",+SubAncoDrID)),"^",2)
	    .s tANCOTemplateSubAncoDr=ANCOTemplateSubAncoDr
	    .;s ^tempmfc("2012")=ANCOTemplateSubAncoDrID_"^^^"_ANCOTemplateSubAncoDr
		.i tANCOMainAncoDr="" d
		..&sql(select * from DHC_ANC_CommonOrd where ANCO_Code=:ancoCode)
		..s retcode=SQLCODE
	 	.Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(ComID,ComDes,ComCatID,ComCat,ComItmID,ComItm,tANCEViewCat,tANCEViewCatId,rowid,tUomRowId,tUomDesc,tIconRowId,tIconDesc,tColorDesc,tOptions,tItmDesc,tAncoMultiValueDesc,tItmId,tAncoSortNo,arcosId,tArcos,ancoDataType,tAncoDataTypeDesc,tAncoIsContinue,tAncoAnMethodDr,tAncoMax,tAncoMin,tANCOImpossibleMax,tANCOImpossibleMin,tANCOMainAncoDr,tANCOMainAncoDrdesc,tANCODataField,tANCODataFormat,tANCOFormatField,tANCOTemplateAncoDrID,tANCOTemplateAncoDr,ANCOTemplateSubAncoDrID,tANCOTemplateSubAncoDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCCommonOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCCommonOrdExecute ]
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

Query FindANCCommonOrd(ANCODesc As %String = "", ANCEViewCat As %String, ANCOCat As %String, IcuApply As %String, AllApply As %String) As %Query(ROWSPEC = "ComID:%String,ComDes:%String,ComCatID:%String,ComCat:%String,ComItmID:%String,ComItm:%String,tANCEViewCat:%String,tANCEViewCatId:%String,rowid:%String,tUomRowId:%String,tUomDesc:%String,tIconRowId:%String,tIconDesc:%String,tColorDesc:%String,tOptions:%String,tItmDesc:%String,tAncoMultiValueDesc:%String,tItmId:%String,tAncoSortNo:%String,arcosId:%String,tArcos:%String,ancoDataType:%String,tAncoDataTypeDesc:%String,tAncoIsContinue:%String,tAncoAnMethodDr:%String,tAncoMax:%String,tAncoMin:%String,tANCOImpossibleMax:%String,tANCOImpossibleMin:%String,tANCOMainAncoDr:%String,tANCOMainAncoDrdesc:%String,tANCODataField:%String,tANCODataFormat:%String,tANCOFormatField:%String,tANCOTemplateAncoDrID:%String,tANCOTemplateAncoDr:%String,ANCOTemplateSubAncoDrID:%String,tANCOTemplateSubAncoDr:%String") [ SqlProc ]
{
}

ClassMethod GetFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetFlagExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	If $g(ind)="" Set ind=1
	//s Str="D^P^M^E"
	//s Str1="药品^处置^材料^检验"
	s Str="D^V^E^T^L"
	s Str1="药品^生命体征^事件^治疗^检验"
	FOR index=1:1:5  {
	s OperStatus=$p(Str1,"^",index)
    s ID=$p(Str,"^",index)
 	Do OutputRow3
 	}	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(ID,OperStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFlagExecute ]
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

Query GetFlag() As %Query(ROWSPEC = "ID:%String,OperStatus:%String")
{
}

ClassMethod GetComOrdInfo(ID As %String) As %String
{
	s ANCOCode=$p(^DHCANC("ComOrd",ID),"^",1)
	s ANCODesc=$p(^DHCANC("ComOrd",ID),"^",2)
	s ANCOCatID=$p(^DHCANC("ComOrd",ID),"^",3)
	//s ANCOCat=$SELECT(ANCOCatID="D":"药品",ANCOCatID="P":"处置",ANCOCatID="M":"材料 ",ANCOCatID="E":"检验",1:"")
	s ANCOCat=$SELECT(ANCOCatID="D":"药品",ANCOCatID="V":"生命体征",ANCOCatID="E":"事件",ANCOCatID="T":"治疗",ANCOCatID="L":"检验",1:"")
	s ANCOArcimDr=$p(^DHCANC("ComOrd",ID),"^",4)
	s ANCOArcimDrName="",ComTypeID="",ComTypeIDStr=""
	s ComTypeName="",ComTypeNameStr=""
	i ANCOArcimDr'="" d
	.f j=1:1:$l(ANCOArcimDr,"~") d
	..s SubID=$p($p(ANCOArcimDr,"~",j),"||",1)
	..s VerID=$p($p(ANCOArcimDr,"~",j),"||",2)
	..s ANCOArcimDrNameStr=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
	..s ComTypeIDStr=$p($g(^ARCIM(SubID,VerID,1)),"^",10)
	..s ComTypeNameStr=$p($g(^ARC("IC",+ComTypeIDStr)),"^",2)
	..i ANCOArcimDrName="" s ANCOArcimDrName=ANCOArcimDrNameStr
	..e  s ANCOArcimDrName=ANCOArcimDrName_"~"_ANCOArcimDrNameStr
	..i ComTypeID="" s ComTypeID=ComTypeIDStr
	..e  s ComTypeID=ComTypeID_"~"_ComTypeIDStr
	..i ComTypeName="" s ComTypeNameStr=ComTypeName
	..e  s ComTypeName=ComTypeName_"~"_ComTypeNameStr
	e  d
	.s ANCOArcimDrName=""
	s ANCEViewCatId=$p($g(^DHCANC("ComOrd",ID)),"^",5)	
	s ANCEViewCat=""
    f i=1:1:$l(ANCEViewCatId,"|") d
    .s ancvcId=$p(ANCEViewCatId,"|",i)
    .q:+ancvcId=0
    .i ANCEViewCat'="" s ANCEViewCat=ANCEViewCat_";"
    .s ANCEViewCat=ANCEViewCat_$p($g(^DHCANC("ViewCat",ancvcId)),"^",2)

	//wxl
    s ANCOUomDrId=$p(^DHCANC("ComOrd",ID),"^",6)
    s ANCOUom=$p($g(^CT("UOM",+ANCOUomDrId)),"^",2)
    s ANCOIconDrId=$p(^DHCANC("ComOrd",ID),"^",7)
    s ANCOIcon=$p($g(^DHCANC("Icon",+ANCOIconDrId)),"^",2)
    s ANCOColor=$p(^DHCANC("ComOrd",ID),"^",8)
	s ANCOOptions=$p(^DHCANC("ComOrd",ID),"^",11)
	s itmId=$p(^DHCANC("ComOrd",ID),"^",12)
	s itmDesc=$p($g(^MRC("OBITM",+itmId)),"^",2)
	s ancoMultiValueDesc=$p(^DHCANC("ComOrd",ID),"^",13)
	s ancoSortNo=$p(^DHCANC("ComOrd",ID),"^",14)
	s arcosId=$p(^DHCANC("ComOrd",ID),"^",15)
	s arcosDesc=$p($g(^ARCOS(+arcosId)),"^",2)
	//liangq 20101203
	s ancoDataType = $p(^DHCANC("ComOrd",ID),"^",16)
	s ancoIsContinue = $p(^DHCANC("ComOrd",ID),"^",17)
	s ancoAnMethodDr = $p(^DHCANC("ComOrd",ID),"^",18)
	s anMethodDesc = $p($g(^ORC("ANMET",+ancoAnMethodDr)),"^",2)
	s ancoMax = $p(^DHCANC("ComOrd",ID),"^",19)
	s ancoMin = $p(^DHCANC("ComOrd",ID),"^",20) 
	//whl 20120420
    s ANCOImpossibleMax = $p(^DHCANC("ComOrd",ID),"^",21)
	s ANCOImpossibleMin = $p(^DHCANC("ComOrd",ID),"^",22)
	s ANCOMainAncoDr = $p(^DHCANC("ComOrd",ID),"^",23)
	s ANCOMainAncoDrdesc=""
	i ANCOMainAncoDr'="" s ANCOMainAncoDrdesc = $p($g(^DHCANC("ComOrd",ANCOMainAncoDr)),"^",2)
	s ANCODataField = $p(^DHCANC("ComOrd",ID),"^",24)
	s ANCODataFormat = $p(^DHCANC("ComOrd",ID),"^",25) 
	
	s ANCOFormatField=$p(^DHCANC("ComOrd",ID),"^",27)
	
	s ANCOTemplateAncoDrID= $p(^DHCANC("ComOrd",ID),"^",28)
	s ANCOTemplateAncoDr = $p($g(^DHCANC("ComOrd",+ANCOTemplateAncoDrID)),"^",2)
    
    s ANCOTemplateSubAncoDrID= $p(^DHCANC("ComOrd",ID),"^",29)    
    s ANCOTemplateSubAncoDr=""
    f j=1:1:$l(ANCOTemplateSubAncoDrID,"|") d
	.s SubAncoDrID=$p(ANCOTemplateSubAncoDrID,"|",j)
	.q:SubAncoDrID=""
	.i (ANCOTemplateSubAncoDr="") s ANCOTemplateSubAncoDr = $p($g(^DHCANC("ComOrd",+SubAncoDrID)),"^",2)
	.e  s ANCOTemplateSubAncoDr = ANCOTemplateSubAncoDr_"|"_$p($g(^DHCANC("ComOrd",+SubAncoDrID)),"^",2)
	//s ANCOTemplateSubAncoDr = $p($g(^DHCANC("ComOrd",+ANCOTemplateSubAncoDrID)),"^",2)
	
    s Ret=ANCOCode_"^"_ANCODesc_"^"_ANCOCat_"^"_ANCOArcimDr_"^"_ANCOArcimDrName_"^"_ANCOCatID_"^"_ComTypeID_"^"_ComTypeName_"^"_$g(ANCEViewCatId)_"^"_$g(ANCEViewCat)_"^"_$g(ANCOUomDrId)_"^"_$g(ANCOUom)_"^"_$g(ANCOIconDrId)_"^"_$g(ANCOIcon)_"^"_$g(ANCOColor)_"^"_$g(ANCOOptions)_"^"_itmDesc_"^"_itmId_"^"_ancoMultiValueDesc_"^"_ancoSortNo_"^"_arcosId_"^"_arcosDesc_"^"_ancoDataType_"^"_ancoIsContinue_"^"_ancoAnMethodDr_"^"_anMethodDesc_"^"_$g(ancoMax)_"^"_$g(ancoMin)_"^"_$g(ANCOImpossibleMax)_"^"_$g(ANCOImpossibleMin)_"^"_$g(ANCOMainAncoDr)_"^"_$g(ANCODataField)_"^"_$g(ANCODataFormat)_"^"_ANCOFormatField_"^"_ANCOMainAncoDrdesc_"^"_ANCOTemplateAncoDrID_"^"_ANCOTemplateAncoDr_"^"_$g(ANCOTemplateSubAncoDrID)_"^"_$g(ANCOTemplateSubAncoDr)
    quit Ret
}

ClassMethod UpdateCommonOrd(itmjs As %Library.String = "", itm As %Library.String = "", ancoId As %String, val As %String)
{
	q:+ancoId=0 "记录RowId不对!"
    s ANCOCode=$p(val,"^",1)
	s ANCODesc=$p(val,"^",2)
    s ANCOType=$p(val,"^",3)
	s ANCOArcimDr=$p(val,"^",4)	
    s ANCEViewCatId=$p(val,"^",5)
    //wxl
    s ANCOUomDrId=$p(val,"^",6)
    s ANCOIconDrId=$p(val,"^",7)
    s ANCOColor=$p(val,"^",8)
    s ANCOAnApply=$p(val,"^",9)
    s ANCOIcuApply=$p(val,"^",10)
    s ANCOOptions=$p(val,"^",11)
    s itmId=$p(val,"^",12)
    s ancoMultiValueDesc=$p(val,"^",13)
    s ancoSortNo=$p(val,"^",14)
    s arcosId=$p(val,"^",15)
    s ancoDataType = $p(val,"^",16) //liangq 20101203
    s ^tpp(987)=ancoDataType
    ;s ancoIsContinue = $p(val,"^",17)
    ;s ancoAnMethodDr = $p(val,"^",18)
    s ancoMax = $p(val,"^",17)
    s ancoMin = $p(val,"^",18)
    
    s ANCOImpossibleMax = $p(val,"^",19) //whl 20120420
	s ANCOImpossibleMin = $p(val,"^",20)
	s ANCOMainAncoDr = $p(val,"^",21)
	s ANCODataField = $p(val,"^",22)
	s ANCODataFormat = $p(val,"^",23)
	
	s ANCOFormatField=$p(val,"^",24)
	s ANCOTemplateAncoDrID=$p(val,"^",25)
	s ANCOTemplateSubAncoDrID=$p(val,"^",26)
    i ANCOAnApply="" set ANCOAnApply=$p(^DHCANC("ComOrd",ancoId),"^",9)
    i ANCOIcuApply="" set ANCOIcuApply=$p(^DHCANC("ComOrd",ancoId),"^",10)
    s retcode=0
    i (ANCOAnApply="Y")&(ANCOIcuApply="Y") s retcode="状态错!一个常用医嘱不能同时用于手术麻醉或重症监护!"
    i (ANCOAnApply'="Y")&(ANCOIcuApply'="Y") s retcode="状态错!常用医嘱应用于手术麻醉或重症监护!"
    i retcode=0 d
    	.&sql(Update DHC_ANC_CommonOrd set ANCO_Code=:ANCOCode,ANCO_Desc=:ANCODesc,ANCO_Type=:ANCOType,ANCO_Arcim_Dr=:ANCOArcimDr,ANCO_ViewCat_Dr=:ANCEViewCatId,ANCO_Uom_Dr=:ANCOUomDrId,ANCO_Icon_Dr=:ANCOIconDrId,ANCO_Color=:ANCOColor,ANCO_AnApply=:ANCOAnApply,ANCO_IcuApply=:ANCOIcuApply,ANCO_Options=:ANCOOptions,ANCO_ICUCIOI_Dr=:itmId,ANCO_MultiValueDesc=:ancoMultiValueDesc,ANCO_SortNo=:ancoSortNo,ANCO_Arcos_Dr=:arcosId,ANCO_DataType=:ancoDataType,ANCO_IsContinue=:ancoIsContinue,ANCO_AnMethod_Dr=:ancoAnMethodDr,ANCO_Max=:ancoMax,ANCO_Min=:ancoMin,ANCO_ImpossibleMax=:ANCOImpossibleMax, ANCO_ImpossibleMin=:ANCOImpossibleMin,ANCO_MainAnco_Dr=:ANCOMainAncoDr, ANCO_DataField=:ANCODataField,ANCO_DataFormat=:ANCODataFormat,ANCO_FormatField=:ANCOFormatField ,ANCO_TemplateAnco_Dr=:ANCOTemplateAncoDrID,ANCO_TemplateSubAnco_Dr=:ANCOTemplateSubAncoDrID Where ANCO_RowId=:ancoId)
    	.s retcode=SQLCODE
    s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
    i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
    &javascript<#(retval)#>
    q retcode
}

ClassMethod GetItemTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetItemTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	If $g(ind)="" Set ind=1
	s ARCICRowId=0 f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
	.s Name=$p(^ARC("IC",ARCICRowId),"^",2)
	.s rowid0=ARCICRowId
 	.Do OutputRow4	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(Name,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetItemTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemTypeExecute ]
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

Query GetItemType() As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

Query GetMasterItem(needItemCatId As %String, arcimDesc As %String) As %Query(ROWSPEC = "arcimDesc:%String,arcimId:%String")
{
}

ClassMethod GetMasterItemExecute(ByRef qHandle As %Binary, needItemCatId As %String = "", needArcimDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i (needItemCatId="")&&(needArcimDesc="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    i (needArcimDesc'="") s needArcimDesc=$$ALPHAUP^SSUTIL4(needArcimDesc)
 	s arcimSub=0 
 	f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
	.s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
	..s arcimId=arcimSub_"||"_arcimVer
	..s aliasId="",aliasDesc=""
	..f  s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId)) q:aliasId=""  d
	    ...i aliasDesc'="" s aliasDesc=aliasDesc_"^"
	    ...s aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..q:aliasDesc=""
	..//s aliasDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	..q:(needArcimDesc'="")&(("^"_aliasDesc_"^")'[("^"_needArcimDesc))&(arcimDesc'[needArcimDesc)
	..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
	..i (+needItemCatId=0)!(+needItemCatId=itemcatDR) d OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(arcimDesc,arcimId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemExecute ]
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

ClassMethod GetMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindANCEViewCat(IcuApply As %String) As %Query(ROWSPEC = "ANCEViewCatId:%String,ANCEViewCat:%String")
{
}

ClassMethod FindANCEViewCatExecute(ByRef qHandle As %Binary, IcuApply As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ANCEViewCatId=0
	f  s ANCEViewCatId=$o(^DHCANC("ViewCat",ANCEViewCatId))  q:ANCEViewCatId=""  d
    .q:(IcuApply'="Y")&($p(^DHCANC("ViewCat",ANCEViewCatId),"^",7)'="Y") 
    .q:(IcuApply="Y")&($p(^DHCANC("ViewCat",ANCEViewCatId),"^",8)'="Y") 
    .s ANCEViewCat=$p(^DHCANC("ViewCat",ANCEViewCatId),"^",2)
    .//s ANCVTOrder=$p(^DHCANC("ViewCat",ANCEViewCatId),"^",4)
    .//i ANCVTOrder'="Y" q
	.d OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(ANCEViewCatId,ANCEViewCat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCEViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCEViewCatExecute ]
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

ClassMethod FindANCEViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCEViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//wxl

Query FindUom() As %Query(ROWSPEC = "UomDesc:%String,UomRowId:%String")
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

Query FindIcon() As %Query(ROWSPEC = "IconDesc:%String,IconRowId:%String")
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

Query FindSummaryItem() As %Query(ROWSPEC = "itmDesc:%String,itmId:%String")
{
}

ClassMethod FindSummaryItemExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s itmId=0
	f  s itmId=$o(^DHCICUC("IOItem",itmId))  q:itmId=""  d
    .s itmDesc=$p(^DHCICUC("IOItem",itmId),"^",2) //yangqin 20121025
	.d OutputRow9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(itmDesc,itmId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSummaryItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSummaryItemExecute ]
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

ClassMethod FindSummaryItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSummaryItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindObItm() As %Query(ROWSPEC = "itmDesc:%String,itmId:%String")
{
}

ClassMethod FindObItmExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s itmId=0
	f  s itmId=$o(^MRC("OBITM",itmId))  q:itmId=""  d
    .s itmDesc=$p(^MRC("OBITM",itmId),"^",2)
	.d OutputRow9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(itmDesc,itmId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindObItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindObItmExecute ]
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

ClassMethod FindObItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindObItmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCommonOrdList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   ANCO_Code As Code,
	   ANCO_Desc As Description,
	   ANCO_ViewCat_Dr As CategoryId,
	   ANCO_Icon_Dr As IconId,
	   ANCO_Color As Color,
	   ANCO_Options As DataOptions,
	   ANCO_SortNo As SortNo,
	   ANCO_DataType As DataType,
	   ANCO_DataField As DataField,
	   ANCO_DataFormat As DataFormat,
	   ANCO_FormatField As DataFormatField,
	   ANCO_Max As MaxWarningValue,
	   ANCO_Min As MinWarningValue,
	   ANCO_ImpossibleMax As ImpossibleMax,
	   ANCO_ImpossibleMin As ImpossibleMin,
	   ANCO_MainAnco_Dr As MainItemId,
	   ANCO_TemplateAnco_Dr As TemplateItemId,
	   ANCO_ICUCIOI_Dr As SummaryItemId,
	   ANCO_TemplateSubAnco_Dr As TemplateSubAncoId
	   FROM DHC_ANC_CommonOrd Where ANCO_IcuApply='Y'
}

Query GetANCommonOrdList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   ANCO_Code As Code,
	   ANCO_Desc As Description,
	   ANCO_ViewCat_Dr As SubCategoryId,
	   ANCO_Icon_Dr As IconId,
	   ANCO_Color As Color,
	   ANCO_Options As Options,
	   ANCO_SortNo As SortNo,
	   ANCO_DataType As DataType,
	   ANCO_DataField As DataField,
	   ANCO_DataFormat As DataFormat,
	   ANCO_FormatField As DataFormatField,
	   ANCO_Max As MaxWarningValue,
	   ANCO_Min As MinWarningValue,
	   ANCO_ImpossibleMax As ImpossibleMax,
	   ANCO_ImpossibleMin As ImpossibleMin,
	   ANCO_MainAnco_Dr As MainItemId,
	   ANCO_TemplateAnco_Dr As TemplateItemId,
	   ANCO_ICUCIOI_Dr As SummaryItemId,
	   ANCO_TemplateSubAnco_Dr As TemplateSubAncoId,
	   ANCO_Type As ItemType,
	   ANCO_ARCIM_Dr As ArcimId,
	   ANCO_SortNo As SeqNo
	   FROM DHC_ANC_CommonOrd Where ANCO_AnApply='Y'
}

Query FindDataField() As %Query(ROWSPEC = "DataField:%String,rowid:%String")
{
}

ClassMethod FindDataFieldExecute(ByRef qHandle As %Binary) As %Status
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

ClassMethod FindDataFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDataFieldExecute ]
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

ClassMethod FindDataFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDataFieldFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindAncoMain(IcuApply As %String, AllApply As %String) As %Query(ROWSPEC = "ancodesc:%String,ancoCode:%String,rowid:%String")
{
}

ClassMethod FindAncoMainExecute(ByRef qHandle As %Binary, IcuApply As %String = "", AllApply As %String = "") As %Status
{
   
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s rowid=0
	i AllApply="" s AllApply="N"
	i IcuApply="" s IcuApply="Y"
	f  s rowid=$o(^DHCANC("ComOrd",rowid)) q:rowid=""  d
	.;s tANCEViewCatId=$p($g(^DHCANC("ComOrd",rowid)),"^",5)  &(ancoMainAncoDr'="")
	.;q:(ANCEViewCat'="")&(("|"_tANCEViewCatId_"|")'[("|"_ANCEViewCat_"|"))
	.s ancoMainAncoDr=$p(^DHCANC("ComOrd",rowid),"^",23)
    .s tAnApply=$p(^DHCANC("ComOrd",rowid),"^",9)
    .q:(tAnApply'="Y")&(IcuApply'="Y")&(AllApply="N")
    .s tIcuApply=$p(^DHCANC("ComOrd",rowid),"^",10)
    .q:(tIcuApply'="Y")&(IcuApply="Y")&(AllApply="N")
    .s ancoCode=$p(^DHCANC("ComOrd",rowid),"^",1)
	.s ancodesc=$p(^DHCANC("ComOrd",rowid),"^",2)
 	.Do OutputRow12
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow12
	set Data=$lb(ancodesc,ancoCode,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAncoMainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAncoMainExecute ]
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

ClassMethod FindAncoMainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAncoMainFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindSubAncoMain(IcuAncStr As %String = "", IcuSubAncStr As %String = "", IcuApply As %String, AllApply As %String) As %Query(ROWSPEC = "ancodesc:%String,ancoCode:%String,rowid:%String")
{
}

ClassMethod FindSubAncoMainExecute(ByRef qHandle As %Binary, IcuAncStr As %String = "", IcuSubAncStr As %String = "", IcuApply As %String = "", AllApply As %String = "") As %Status
{
   
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s rowid=0
	s AncStr=IcuSubAncStr
	i AllApply="" s AllApply="N"
	i IcuApply="" s IcuApply="Y"	
	f  s rowid=$o(^DHCANC("ComOrd",rowid)) q:rowid=""  d
	.;q:(IcuAncStr'="")&(IcuAncStr'=$p(^DHCANC("ComOrd",rowid),"^",28))
	.q:(IcuAncStr'="")&(IcuAncStr'=$p(^DHCANC("ComOrd",rowid),"^",23))
	.;s tANCEViewCatId=$p($g(^DHCANC("ComOrd",rowid)),"^",5)  &(ancoMainAncoDr'="")
	.;q:(ANCEViewCat'="")&(("|"_tANCEViewCatId_"|")'[("|"_ANCEViewCat_"|"))
	.;s ancoMainAncoDr=$p(^DHCANC("ComOrd",rowid),"^",23)
    .s tAnApply=$p(^DHCANC("ComOrd",rowid),"^",9)
    .q:(tAnApply'="Y")&(IcuApply'="Y")&(AllApply="N")
    .s tIcuApply=$p(^DHCANC("ComOrd",rowid),"^",10)
    .q:(tIcuApply'="Y")&(IcuApply="Y")&(AllApply="N")
    .s ancoCode=$p(^DHCANC("ComOrd",rowid),"^",1)
	.s ancodesc=$p(^DHCANC("ComOrd",rowid),"^",2)
	.i ((AncStr'="")&((AncStr=ancoCode)!(ancodesc[AncStr)!(rowid=AncStr))) Do OutputRow12
	.i (AncStr="") Do OutputRow12
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow12
	set Data=$lb(ancodesc,ancoCode,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindSubAncoMainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSubAncoMainExecute ]
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

ClassMethod FindSubAncoMainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSubAncoMainFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetHisMasterItem() As %Query(ROWSPEC = "ComOrdId:%String,arcimDesc:%String,arcimId:%String")
{
}

ClassMethod GetHisMasterItemExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ComOrdCode=""
 	f  s ComOrdCode=$o(^DHCANC("ComOrd",0,"TypeCode","D",ComOrdCode)) q:ComOrdCode=""  d
 	.s ComOrdId=0
 	.f  s ComOrdId=$o(^DHCANC("ComOrd",0,"TypeCode","D",ComOrdCode,ComOrdId)) q:ComOrdId=""  d
 	..//s ComOrdDesc=$p(^DHCANC("ComOrd",ComOrdId),"^",2)
 	..s arcimIdlist=$p(^DHCANC("ComOrd",ComOrdId),"^",4)
 	..i (arcimIdlist="") d
 	...s arcimDesc=""
 	...s arcimId=""
 	...d OutputHisRow
 	..s arcimIdlen=$l(arcimIdlist,"~")
 	..f num=1:1:arcimIdlen  d
 	...s arcimId=$p(arcimIdlist,"~",num)
 	...s arcimSub=+arcimId
 	...s arcimVer=$p(arcimId,"||",2)
 	...q:+arcimSub=0
 	...i ('$d(^ARCIM(arcimSub,arcimVer,1))) d
 	....s arcimDesc=""
 	....d OutputHisRow
 	...q:'$d(^ARCIM(arcimSub,arcimVer,1))
 	...s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
 	...q:(($h>+$g(^ARCIM(arcimSub,arcimVer,7)))&&(+$g(^ARCIM(arcimSub,arcimVer,7))>0))
 	...d OutputHisRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputHisRow
	set Data=$lb(ComOrdId,arcimDesc,arcimId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetHisMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHisMasterItemExecute ]
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

ClassMethod GetHisMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHisMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetEventItem(CategoryIdstr As %String) As %Query(ROWSPEC = "ComOrdId:%String,ComOrdCode:%String,ComOrdDesc:%String,ComOrdCatId:%String,ComEventCat:%String")
{
}

ClassMethod GetEventItemExecute(ByRef qHandle As %Binary, CategoryIdstr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ComOrdCode=""
 	f  s ComOrdCode=$o(^DHCANC("ComOrd",0,"TypeCode","E",ComOrdCode)) q:ComOrdCode=""  d
 	.s ComOrdId=0
 	.f  s ComOrdId=$o(^DHCANC("ComOrd",0,"TypeCode","E",ComOrdCode,ComOrdId)) q:ComOrdId=""  d
 	..q:$p(^DHCANC("ComOrd",ComOrdId),"^",9)'="Y"
 	..s ComOrdDesc=$p(^DHCANC("ComOrd",ComOrdId),"^",2)
 	..s ComOrdCatId=$p(^DHCANC("ComOrd",ComOrdId),"^",5)
 	..s ComOrdCatIdlen=$l(ComOrdCatId,"|")
 	..f j=1:1:ComOrdCatIdlen d
 	...s CatId=$p(ComOrdCatId,"|",j)
 	...f num=1:1:$l(CategoryIdstr,"^") d
 	....i CatId=$p(CategoryIdstr,"^",num) d
 	.....s ComOrdCatId=CatId
 	...;s ComOrdCatCode=$p(^DHCANC("ViewCat",CatId),"^",1)
 	...;i Categorystr[ComOrdCatCode  d
 	...;.s ComOrdCatId=CatId
 	..s ComEventCat=$p(^DHCANC("ComOrd",ComOrdId),"^",14)
 	..d OutputEventRow
 	..
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEventRow
	set Data=$lb(ComOrdId,ComOrdCode,ComOrdDesc,ComOrdCatId,ComEventCat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEventItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEventItemExecute ]
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

ClassMethod GetEventItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEventItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetEventCat() As %Query(ROWSPEC = "ComEventCat:%String,ComEvCatDesc:%String")
{
}

ClassMethod GetEventCatExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ComOrdCode="",ComEventCatstr=""
 	f  s ComOrdCode=$o(^DHCANC("ComOrd",0,"TypeCode","E",ComOrdCode)) q:ComOrdCode=""  d
 	.s ComOrdId=0
 	.f  s ComOrdId=$o(^DHCANC("ComOrd",0,"TypeCode","E",ComOrdCode,ComOrdId)) q:ComOrdId=""  d
 	..s ComEventCat=$p(^DHCANC("ComOrd",ComOrdId),"^",14)
 	..q:ComEventCatstr[ComEventCat
 	..s ComEventCatstr=ComEventCatstr_"^"_ComEventCat
 	..i (ComEventCat="EC001") d
 	...s ComEvCatDesc="关键事件"
 	...d OutputEvCatRow
 	..i (ComEventCat="EC002") d
 	...s ComEvCatDesc="麻醉事件"
 	...d OutputEvCatRow
 	..i (ComEventCat="EC003") d
 	...s ComEvCatDesc="手术事件"
 	...d OutputEvCatRow
 	..i (ComEventCat="EC004") d
 	...s ComEvCatDesc="手术关键操作"
 	...d OutputEvCatRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEvCatRow
	set Data=$lb(ComEventCat,ComEvCatDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEventCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEventCatExecute ]
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

ClassMethod GetEventCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEventCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
