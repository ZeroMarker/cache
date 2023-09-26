Class web.DHCDocOrderEntryCM Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod FindPrePrescInUse(EpisodeID As %String, InstrRowId As %String) As %String
{
	;s ^zhou("FindPrePrescInUse")=EpisodeID_","_InstrRowId
	;w ##Class(web.DHCDocOrderEntryCM).FindPrePrescInUse(360837)
	s Find=0
	Q:InstrRowId="" Find
	;内服,外用的用法设置.在护士站配置
	s NFInstrStr=$G(^DHCCLSet("Alert","Instr",0))
	s WYInstrStr=$G(^DHCCLSet("Alert","Instr",1))
	s InstrRowId="^"_InstrRowId_"^"
	i (NFInstrStr[InstrRowId) s FindMode=1
	i (WYInstrStr[InstrRowId) s FindMode=2

	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	s RowId=$O(^PAQUE1(0,"QUE1_PAADM_DR",+EpisodeID,0))
	While (RowId'="") {
		i $d(^PAQUE1(RowId,"DHC")) {
			s StartDate=$P(^PAQUE1(RowId,"DHC"),"^",6)
			s DurationDR=$P(^PAQUE1(RowId,"DHC"),"^",10)
			s DurationFactor=0
			if DurationDR'="" s DurationFactor=$P(^PHCDU(DurationDR),"^",2)
			if (StartDate+DurationFactor)-1>=..%SysDate() {
				s InstructionDR=$P(^PAQUE1(RowId,"DHC"),"^",11)
				i InstructionDR'="" {
					s PrescNo=$P(^PAQUE1(RowId),"^",14)
					;如果处方停止后就不用再判断
					s itemsub=$O(^OEORD(0,"PrescNo",PrescNo,OrderRowid,0))
					s StautsRowid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13)
					s StautsCode=$P($G(^OEC("OSTAT",StautsRowid)),"^",1)
					i StautsCode'="D" {
						b ;
						s InstructionDR="^"_InstructionDR_"^"
						if (NFInstrStr[InstructionDR)&&(FindMode=1) {
							s Find=1
							Quit
						}
						if (WYInstrStr[InstructionDR)&&(FindMode=2) {
							s Find=2
							Quit
						}
					}
				}
			}
		}
		s RowId=$O(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,RowId))
	}
	Q Find
}

ClassMethod GetBeforeDay(n) As %String
{
 s dd=..%SysDate()+n
 quit $zd(dd,4)
}

ClassMethod GetCNMedCookRecloc(AdmType As %String = "", LogonHospID As %String = "", PrescTypeCode As %String = "", CMOrderOpenForAllHosp As %String = "") As %String
{
	 n (AdmType,LogonHospID,PrescTypeCode,CMOrderOpenForAllHosp)
	 s ret=""
	 i AdmType="E" {
			s RecLocStr=..%GetConfig1(PrescTypeCode,"EPCNMedCookDep",LogonHospID)
	 }else{
			s RecLocStr=..%GetConfig1(PrescTypeCode,"CNMedCookDep",LogonHospID)
	 }
		i RecLocStr'="" {
			s RecLocCount=$LENGTH(RecLocStr,"^")
		    F i=1:1:RecLocCount {
			    S RecLocRowid=$P(RecLocStr,"^",i)
			    s RecLocHospitalID=$P(^CTLOC(RecLocRowid),"^",22)
		        continue:(RecLocHospitalID'=LogonHospID)&&(CMOrderOpenForAllHosp'="1")
			    s RecLocDesc=##class(web.DHCDocOrderCommon).GetLocDesc(RecLocRowid)
			    i ret=""  s ret=RecLocRowid_$C(1)_RecLocDesc_$C(1)_"Y"
			    e  s ret=ret_$C(2)_RecLocRowid_$C(1)_RecLocDesc_$C(1)_"N"
		    }
		}
	 Q ret
}

ClassMethod GetCNPrescItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCNPrescItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetCNPrescItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, PrescNo As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s OrderName1="", PackQty1="",DoseQty1="",DoseUOM1="", Price1="", PhSpecInstr1="", ItemID1="", OrderItemID1=""
 s OrderName2="", PackQty2="",DoseQty2="",DoseUOM2="", Price2="", PhSpecInstr2="", ItemID2="", OrderItemID2=""
 s OrderName3="", PackQty3="",DoseQty3="",DoseUOM3="", Price3="", PhSpecInstr3="", ItemID3="", OrderItemID3=""
 s OrderName4="", PackQty4="",DoseQty4="",DoseUOM4="", Price4="", PhSpecInstr4="", ItemID4="", OrderItemID4=""
 do ResetVariables1
 Do OutputRow1 	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow1
	set Data=$lb(OrderName1,Price1, DoseQty1, DoseUOM1, PhSpecInstr1, PackQty1,ItemID1, OrderItemID1,OrderName2,Price2, DoseQty2, DoseUOM2, PhSpecInstr2,PackQty2, ItemID2, OrderItemID2,OrderName3, Price3, DoseQty3, DoseUOM3, PhSpecInstr3,PackQty3, ItemID3, OrderItemID3,OrderName4,Price4, DoseQty4,DoseUOM4,PhSpecInstr4,PackQty4, ItemID4, OrderItemID4)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	Quit
ResetVariables1
	set (OrderName1,Price1, DoseQty1, DoseUOM1, PhSpecInstr1, PackQty1,ItemID1, OrderItemID1,OrderName2,Price2, DoseQty2, DoseUOM2, PhSpecInstr2,PackQty2, ItemID2, OrderItemID2,OrderName3, Price3, DoseQty3, DoseUOM3, PhSpecInstr3,PackQty3, ItemID3, OrderItemID3,OrderName4,Price4, DoseQty4,DoseUOM4,PhSpecInstr4,PackQty4, ItemID4, OrderItemID4)=""
	quit
}

ClassMethod GetCNPrescItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCNPrescItemsExecute ]
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

ClassMethod GetOrderPrior(EpisodeType As %String = "", Type As %String = "") As %String
{
	s ret=""
	s CMPriorStr=..%GetConfig("CNMedPrior")
	Q:CMPriorStr="" ret
	s Count=$LENGTH(CMPriorStr,"^")
	For i = 1:1:Count {
		s PriorRowid=$P(CMPriorStr,"^",i)
		s PriorDesc=$P(^OECPR(PriorRowid),"^",2)
		s PriorCode=$P(^OECPR(PriorRowid),"^",1)
		if (EpisodeType="O")&&(PriorCode'="NORM") continue
		if (Type="JSON"){
			i ret="" s ret = "{"_"'id':'"_PriorRowid_"',"_"'text':'"_PriorDesc_"'}"
			e  s ret = ret_",{"_"'id':'"_PriorRowid_"',"_"'text':'"_PriorDesc_"'}"
		}else{
			i ret="" s ret=PriorRowid_$C(1)_PriorDesc_$C(1)_PriorCode
			e  s ret=ret_$C(2)_PriorRowid_$C(1)_PriorDesc_$C(1)_PriorCode
		}
	}
	Q:Type="JSON" "["_ret_"]"
	Q ret
}

ClassMethod GetStartDate(PaadmRowid As %String) As %String
{
 i PaadmRowid="" q 100
 s AdmDate=$P(^PAADM(PaadmRowid),"^",6)
 q $zd(AdmDate,4)
}

ClassMethod LookUpBrokerDuration(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpDuration")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpBrokerFrequence(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpFrequence")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpBrokerInstr(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpInstr")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", LUCategoryDesc As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", RelocID As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
	New repid, index
	///do ResetVariables
	s ^zhou("LookUpItemCM")=""""_Item_""","""_GroupID_""","""_Category_""","""_SubCategory_""","""_TYPE_""","""_LUCategoryDesc_""","""_LUSubCategoryDesc_""","""_EpisodeID_""","""_BillingGrp_""","""_BillingSubGrp_""","""_RelocID_""","""_OrdCatGrp_""","""_NonFormulary_""","""_Form_""","""_Strength_""","""_Route_""""
	;d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntryCM","LookUpItem","gc","29","","","0","CNMedItemCat","","","","","","","","","","")
	Set repid=$I(^CacheTemp)
	s index=1,Num=0
	kill ^||tmpLookUpCMItem,^||tmpCMItemArr
	s CurLogonDep=$p(Form,$c(3),1)
	s CurLogonHosp=$p(Form,$c(3),2)
	i CurLogonDep'="" {
		s LogonLocID=CurLogonDep
	}else {
		s LogonLocID=%session.Get("LOGON.CTLOCID")
	}
	i CurLogonHosp="" s CurLogonHosp=$p(^CTLOC(LogonLocID),"^",22)
	s LogonHospDr=CurLogonHosp
	//s LogonLocID=%session.Get("LOGON.CTLOCID")
	s LogonUserCode=%session.Get("LOGON.USERCODE")
	s UserRowId=%session.Get("LOGON.USERID")
	//s LogonHospDr=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_LogonHospDr
	s CurLogonDep=LogonLocID
	Set langid=..%LanguageID()
	s AdmReason="",EpisodeType="",EpLoc=""
	i EpisodeID'="" {
		s AdmReason=$p($G(^PAADM(EpisodeID,1)),"^",7)
		s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
		s EpLoc=##class(web.DHCDocOrderCommon).GetEpLoc(EpisodeID,"")
	}
	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",LogonHospDr)
	s Item=##class(web.DHCOPCommonFunLib).Trim(Item)
	if (Item=""){
		Set QHandle=$lb(0,repid,0)
 		Quit $$$OK
	}
	;精确或者模糊查询
	s len1=$l(Item)
	s findmode=0
	if ($e(Item,$l(Item))=".")||($e(Item,$l(Item))="。"){
		s findmode=1
		s Item=$e(Item,1,len1-1)
	}
	if Category'="" 
	.s Category=$$ALPHAUP^SSUTIL4(Category)
	.s CategoryID=$O(^OEC("ORCAT",0,"Desc",Category,0))
	.i CategoryID'="" s Category=CategoryID
	i SubCategory'="" d
	.s SubCategory=$$ALPHAUP^SSUTIL4(SubCategory)
	.s SubCategoryID=$O(^ARC("IC",0,"Desc",SubCategory,0))
	.i SubCategoryID'="" s SubCategory=SubCategoryID
	s CMSubCategory=..%GetConfig("CNMedItemCat",LogonHospDr)
	s CMKLSubCategory=..%GetConfig("CNMedKLItemCat",LogonHospDr)
	if (LUCategoryDesc="ALL"){
		s CMSubCategory=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr(LogonHospDr)
		s CMSubCategory="^"_CMSubCategory_"^"
	}else{
		s CMSubCategory=..%GetConfig(LUCategoryDesc,LogonHospDr)
		s CMSubCategory="^"_CMSubCategory_"^"
		if (CMSubCategory=""){
			//这一段其实可以不加，为了防止有些地方的程序没有做处方类型响应的修改
			if LUCategoryDesc'=1 {
				s CMSubCategory="^"_CMSubCategory_"^"
			}else{
				s CMSubCategory="^"_CMKLSubCategory_"^"
			}
			if $D(^DHCDocConfig(HospCodeNode,"CNMedNormKL")),LUCategoryDesc'="ALL" {
				Set RecLoc=$o(^DHCDocConfig(HospCodeNode,"CNMedNormKL",LUCategoryDesc+1,0))
		    	Set CNMedNormKLCat=^DHCDocConfig(HospCodeNode,"CNMedNormKL",LUCategoryDesc+1,RecLoc)
		    	i CNMedNormKLCat'="" s CMSubCategory="^"_CNMedNormKLCat_"^"
			}
		}
	}
	;不显示零库存项目
	s NotDisplayZeroStockCMItem=..%GetConfig("NotDisplayZeroStockCMItem",LogonHospDr)
	s FormulaItemCat=..%GetConfig("FormulaItemCat",LogonHospDr)
	s CMSubCategory=CMSubCategory_FormulaItemCat_"^"
	if (Category'="")&(SubCategory="") d
	.i $$valordcat(GroupID,Category) d
	..s SubCategory=0 f  s SubCategory=$o(^ARC("IC",0,"OrdCat",Category,SubCategory)) q:SubCategory=""  d
	...set retval=$$open(SubCategory,Item,GroupID)
	...for  s retval=$$fetch(SubCategory,Item,GroupID) q:retval="100"  d
	.... Q:(type="ARCIM")&&(NotDisplayZeroStockCMItem="1")&&((+$p(StockQty,"("))=0)
	.... //Do OutputRow
	.... do RecordSortTmpData
	...set retval=$$close()
	e  d
	.set retval=$$open(SubCategory,Item,GroupID)
	.for  s retval=$$fetch(SubCategory,Item,GroupID) q:retval="100"  d
	.. Q:(type="ARCIM")&&(NotDisplayZeroStockCMItem="1")&&((+$p(StockQty,"("))=0)&&(EpisodeID'="")
    .. //Do OutputRow
    .. do RecordSortTmpData
	.set retval=$$close()
	;代码表数据使用次数排序
	s RecordCount=""
	for {
		s RecordCount=$o(^||tmpLookUpCMItem(RecordCount),-1) Quit:RecordCount=""
		s Num=0
		for {
			s Num=$o(^||tmpLookUpCMItem(RecordCount,Num)) Quit:(Num="")
			s id=0
			for {
				s id=$o(^||tmpLookUpCMItem(RecordCount,Num,id)) Quit:(id="")
				s Data=^||tmpLookUpCMItem(RecordCount,Num,id)
				do OutputRow
			}
		}
	}
 Set QHandle=$lb(0,repid,0)
 Quit $$$OK
RecordSortTmpData
	Set OutRecordId=$lg(Data,2)
	quit:$d(^||tmpCMItemArr(OutRecordId)) 
	Set Num=Num+1
	if OutRecordId["||"{
		s TableName="User.ARCItmMast"
	}else{
		s TableName="User.ARCOrdSets"	
	}
	Set RecordCount=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount(TableName,OutRecordId,UserRowId,"U")
	Set ^||tmpLookUpCMItem(RecordCount,Num,OutRecordId)=Data
	Set ^||tmpCMItemArr(OutRecordId)=1
	quit
open(CATEG,TEXT,user) 
	k ^TMP($zn,$j)
	;;s ^zleon($zn,"o")=CATEG_"^"_TEXT_"^"_user
	s TEXT=$g(TEXT),CATEG=$g(CATEG)
	s TEXT1=$ZCVT(TEXT,"U")
	s TEXT=$ZCVT(TEXT,"U")
	;
	s DESC=0,ROW=0 //,TEXT0=TEXT 
	i findmode=0 s TEXT0=TEXT
	e  s TEXT0=0 
	i TEXT,TEXT=+TEXT s TEXT0=TEXT_$c(1)
	s:TEXT0="" TEXT0=0
	;build list of categories for user
	k UserCat
	s ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  d
	.s s=^(ord)
	.s sssubcat=$p(s,"^",5)
	.if '$d(UserCat(+s)) d
	..s UserCat(+s)=$p(s,"^",3,4)_"^"_sssubcat
	.e  d
	..s UserCat(+s)=UserCat(+s)_"!"_sssubcat
	;decide which index to use
	s SubScr=$$subscr(CATEG)
	q 0
fetch(CATEG,TEXT,user) 
	 s TEXT=$g(TEXT),CATEG=$g(CATEG)
	 s TEXT1=$ZCVT(TEXT,"U")
	 s TEXT=$ZCVT(TEXT,"U")
	 s SubScr=$g(SubScr),DESC=$g(DESC),ROW=$g(ROW),TEXT0=$g(TEXT0)
	 k PLIST 
	 i CATEG="" g it3
	 i CATEG'="" g it31
it1 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,TEXT0)),DESC=""
it2 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it1 ;q 100
	 i findmode=0,$l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT g it1
	 i $ZCVT(TEXT0,"U")'[TEXT g it1 ;q 100
	 ;i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 ;i TEXT'=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC)),ROW=""
	 g:DESC="" it1
it3 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it1
	 s ROW=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW))
	 g:ROW="" it2
	 s ind=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,""))
	 g:ind="" it3
	 s str=$g(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2),genflag=$p(str,"^",3)
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",Route="" g it3
	 ;i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it3
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 i (CMSubCategory'[("^"_subCATEG_"^"))&&(type="ARCIM") g it3
	 i '$$valord(user,subCATEG,type,ROW1) g it3
	 i type="ARCIM",##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ROW1,DefHospId)="N" g it3
	 i type="ARCIM",$$valrow(ROW1) g it3
	 i type="ARCOS",$$valarcos(ROW1) g it3
	 i type="ARCOS",$$checkoslimit(ROW1) g it3
	 i $d(^TMP($zn,$j,type_"^"_ROW1)) g it3
	 s ^TMP($zn,$j,type_"^"_ROW1)=""
	 s flag=$s(TEXT0=DESC:"",ROW=ROW1:"",$g(^ARC("ALIAS",ROW))'="":$P($G(^ARC("ALIAS",ROW)),"^",6)_"-",type["ARCIM":$p($g(^ARCIM(+ROW1,1,8)),"^",21)_"-",1:"")
	 ;i type="ARCIM",flag="" d
	 i type="ARCIM" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 i type="ARCIM",genflag d
	 .s flag=$p($g(^ARCIM(+ROW1,1,"GEN",genflag)),"^",2)_"-"
	 i type["ARCIM" s err=$$selectarcim(ROW1) g:err it3 s desc=flag_desc q "ARCIM"
	 i type["ARCOS" s err=$$selectarcos(ROW1) g:err it3 s desc=flag_desc q "ARCOS"
	 q 0
 ;
it11 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0)),DESC=""
it21 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it11 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC)),ROW=""
	 g:DESC="" it11
it31 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it11
	 s ROW=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW))
	 g:ROW="" it21
	 s ind=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,""))
	 g:ind="" it21
	 s str=$g(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2)
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it31
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 i (CMSubCategory'[("^"_subCATEG_"^"))&&(type="ARCIM") g it31
	 i '$$valord(user,subCATEG,type,ROW1) g it31
	 i type="ARCIM",##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ROW1,DefHospId)="N" g it31
	 i type="ARCIM",$$valrow(ROW1) g it31
	 i type="ARCOS",$$valarcos(ROW1) g it31
	 i type="ARCOS",$$checkoslimit(ROW1) g it31
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it31
	 s flag=$s(TEXT0=DESC:"",1:$P($G(^ARC("ALIAS",ROW)),"^",6)_"-")
	 i type="ARCIM",flag="" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 s err=0
	 i type["ARCIM" s err=$$selectarcim(ROW1) 
	 i type["ARCOS" s err=$$selectarcos(ROW1)
	 g:err it31 
	 ;s $p(PLIST(1),$c(2),2)=flag_$p(PLIST(1),$c(2),2) 
	 i $l(type),ROW1,$d(^TMP($zn,$j,type,ROW1_"^"_desc)) g it31
	 i $l(type),ROW1 s ^TMP($zn,$j,type,ROW1_"^"_desc)=""
	 i type="ARCIM" q "ARCIM"
	 i type="ARCOS" q "ARCOS"
	 q 0
close() k UserCat,TEXT,TEXT0
	 k ^TMP($zn,$j)
	 q 0
selectarcim(RowID)	k PLIST
	&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef,ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR,ARCIM_RiceType_DR->RIC_Desc,ARCIM_ConsultDept,ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,ARCIM_MealType_DR,ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering,ARCIM_InsSubCat_DR,ARCIM_DefPriority_DR,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code,ARCIM_ItemCat_DR->ARCIC_OrderType,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			$LIST(ARCIM_OEMessage),ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_PHCDF_DR->PHCDF_CTUOM_DR->CTUOM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCDU_DR,
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc
	   INTO :rowid,:desc,:code,:code1,:code2,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatcode,:ordcatid,:oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,:generic,:subcatdesc
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:RowID)
	i 'SQLCODE d adjust1
	q SQLCODE
	;
adjust1	;
	;s cost=$p($g(cost),$c(1)) s:cost="" cost="N"
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_$p(code,$c(1))_$c(2)_$p(code1,$c(1))_$c(2)_$p(code2,$c(1))_$c(2)_$p(rice,$c(1))_$c(2)_ricedes_$c(2)_$p(cons,$c(1))_$c(2)_consdes_$c(2)_categ_$c(2)_subcat_$c(2)_$p(mealt,$c(1))_$c(2)_mealtdes_$c(2)_cost_$c(2)_inssubcat_$c(2)_prior_$c(2)_priordesc_$c(2)_$p($g(^ARC("IC",+subcat)),"^",15)_$c(2)_arcimcode
	;s PLIST=$o(PLIST(""),-1)
	s billuomDr=""
	s Phcdf=$P($g(^ARCIM(+rowid,$P(rowid,"||",2),1)),"^",12)
	if (Phcdf'=""){
		s billuomDr=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
		if (billuomDr'="") s billuom=$p(^CT("UOM",billuomDr),"^",2)
		;剂型
		s FormDesc=""
	  	s FormRowid=$p($g(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),1)),"^",1)
	  	i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
	  	s FormDesc=##class(User.PHCForm).GetTranByDesc("PHCFDesc",FormDesc,langid)
	}
	s ItemPrice=0
	s StockQty=""
	s PackedQty=""
	s rowid=$p(rowid,$c(1))
	s SttDate=..%SysDate()
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	//获取医嘱默认接收科室。查看默认接收科室的库存情况
	s RecLocStr=""
	s:EpisodeID'="" RecLocStr=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,rowid)
	s DefaultRecLoc=$$GetDefalocID(RecLocStr) //默认接收科室ID
	s:RelocID'="" DefaultRecLoc=RelocID
	s CurLogonHosp=$p($g(^CTLOC(LogonLocID)),"^",22)
	s ExpStrIn="^^^"_DefaultRecLoc_"^"_CurLogonHosp
	s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, rowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,"",billuomDr,ExpStrIn)
	s ItemPrice=$fn($P(retPrice,"^",1),"",4)
	s firstInicID=""
	i (subcatcode="R")&(EpisodeID'="") d
	.s ret=##class(web.DHCDocOrderEntry).GetStockQty(EpisodeID,rowid)
	.s StockQty=$P(ret,"^",1)
	.s PackedQty=$P(ret,"^",2)
	.i DefaultRecLoc'="" d
	..;调用药房接口返回 返回当前库存数^可用库存数^医嘱占用数^库存业务占用数 ，全部为基本单位数量
	..s AdmType=$p(^PAADM(EpisodeID),"^",2)
	..s Rtnstr=##Class(web.DHCSTINTERFACE).GetIncilQtyList(rowid,DefaultRecLoc,AdmType)
	..s StockQty=$P(Rtnstr,"^",9)
	..s PackedQty=((+$P(Rtnstr,"^",12)))
	..s firstInicID=$P(Rtnstr,"^",1)
	///显示药学项的单位和第一个库存项的单位，转换系数,价格除以转换系数，库存乘以转换系数
	
	if (Phcdf'="")&&(firstInicID'=""){
		//存在一个医嘱项对应多个库存项,此处取药房返回的库存项信息的第一条库存记录
		s UomID=$p(^INCI(firstInicID,1),"^",10)
		s FindConFac=##class(web.DHCSTINTERFACE).UOMFac(UomID,billuomDr)
		s ItemPrice=ItemPrice/FindConFac
		s ItemPrice=$fn(ItemPrice,"",4)
		s StockQty=StockQty*FindConFac
		s PackedQty=PackedQty*FindConFac
	}
	s billuomDR=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(rowid,EpisodeType)
	s billuom=##class(web.DHCDocOrderCommon).GetUOMDesc(billuomDR)
	s generic=""
	s desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",desc,langid)
	s desc=flag_desc
	s subcatdesc= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",subcatdesc,langid)
	//国家医保编码
	s InsuNationCode=""
	s InsuNationName=""
	s NowDate=..%ZD(+$H)
	s InsuNationCode=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,CurLogonHosp,NowDate,13)
	s InsuNationName=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,CurLogonHosp,NowDate,14)
	//s InstrStr=##class(web.DHCINSUPort).ArcimLinkInsuList(rowid,AdmReason,CurLogonHosp,NowDate)
	
	;医保组从2010.3.3号起统一到了web.DHCINSUPort里面了
	//s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(rowid,AdmReason,CurLogonHosp)
	;医保类别(甲,乙,丁等)
	s InsurClass=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,CurLogonHosp,NowDate,6)
    i InsurClass["-" s InsurClass=""
	s DrugIconStr=##Class(DHCDoc.Interface.Inside.Invoke).GetDrugIconsByArcim(rowid,CurLogonHosp)
	
	s Data=$lb(desc,rowid,$p(phfreqcode,$c(1)),type,TEXT0,subcatcode,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,phuomdesc,$p(phdurrowid,$C(1)),generic,"","","",subcatdesc,ItemPrice,billuom,StockQty,PackedQty,$g(FormDesc),InsuNationCode,InsuNationName,InsurClass,DrugIconStr)
	q
selectarcos(RowID)	k PLIST
	&SQL(SELECT ARCOS_RowId,ARCOS_Desc,ARCOS_LabTrakTestSet,ARCOS_DefPriority_DR,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR->ARCIC_Desc
	       INTO :rowid,:desc,:code,:prior,:durrowid,:freqcode,:ordcatid,:subcatdesc
	       FROM SQLUser.ARC_OrdSets WHERE ARCOS_RowId=:RowID)
	;&SQL(SELECT ARCOS_Desc FROM ARC_OrdSets)
	i 'SQLCODE d adjust2
	q SQLCODE
adjust2	;
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_code_$c(2)_$p($g(prior),$c(1))_$c(1)_$p($g(^OECPR(+$g(prior))),"^",2)
	;s PLIST=$o(PLIST(""),-1)
	s rowid=$p(rowid,$C(1),1)
	s retval=$$getOSItemIDs(rowid)
	s OSItemIDs=$p(retval,$C(4),1)
	s OSPrice=$fn($p(retval,$C(4),2),"",4)
	s desc=flag_desc
	s StockQty=""
	s Data=$lb(desc,rowid,"",type,TEXT0,"",$p(ordcatid,$C(1)),"","","","","","","",OSItemIDs,"","",subcatdesc,OSPrice,"","","","")
	q
	;
valord(user,subCATEG,type,ROW1) ;validate usergroup and CATEGory
	 ;1-valid,0-invalid
	 n (UserCat,user,subCATEG,type,ROW1,EpisodeType,EpLoc,UserRowId,CurLogonDep,LUCategoryDesc,Route,LogonHospDr,DefHospId)
	 s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	 Q:'user 1
	 i '$d(UserCat(+CATEG)) q 0
	 s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2),subcat=$p(s,"^",3)
	 Q:(subcat'="")&&(("!"_subcat_"!")'[("!"_subCATEG_"!")) 0
	 i type="ARCOS",os'="Y" Q 0
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",vis'="Y" q 0
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",Route="" Q 0
	 s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserRowId)
	 i type="ARCIM"{
	 	s AllowArcItemValue=##class(DHCDoc.DHCDocConfig.PrescriptSet).CheckForAllowArcItem(DoctorID,ROW1,LogonHospDr,"CM")
	 	if (AllowArcItemValue=0) Q 0
	 }
	 ;lxz 修改门诊、住院、急诊用药医嘱项设置应用
	 ;s RestrictIP=$p($g(^ARCIM(+ROW1,1,10)),"^",13)
	 ;s RestrictOP=$p($g(^ARCIM(+ROW1,1,10)),"^",14)
	 ;if (RestrictIP'="Y")!(RestrictOP'="Y") {
	 ;	if (RestrictIP="Y")&&(EpisodeType'="I") Q 0
	 ;	if (RestrictOP="Y")&&(EpisodeType'="O") Q 0
	 ;}
	 ;根据科室,医生,职称判断医嘱项的可开的权限
	 if type="ARCIM" {
		s Restrict=##class(web.DHCDocOrderCommon).CheckArcimType(ROW1,"",EpisodeType)
	 	if Restrict'="" Q 0
	 	s ItemAuth=##class(web.DHCDocOrderCommon).CheckArcimAuthorize(ROW1,CurLogonDep,UserRowId)
	 	i ItemAuth=0 Q 1
	 	s ItmHosipital=$$CheckArcimHosipital(ROW1,DefHospId)
	 	if 'ItmHosipital Q 0
	 
	 	;判断设否有医嘱项可开权限
	 	s IncludeContinueFlag=0
	 	s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  d
	 	.s s=$p($g(^SSU("SSGRP",+user,"SSORD",ord)),"^",1)
	 	.q:(s-CATEG)
	 	.s subItemCat=$p($g(^SSU("SSGRP",+user,"SSORD",ord)),"^",5)
	 	.q:(subItemCat'="")&&(subItemCat-subCATEG)
	 	.s Itm=0 f  s Itm=$o(^SSU("SSGRP",+user,"SSORD",ord,"ITM",Itm)) q:Itm=""  q:IncludeContinueFlag  d
	 	..s ItmData=$g(^SSU("SSGRP",+user,"SSORD",ord,"ITM",Itm))
	 	..s ItmId=$p(ItmData,"^",1)
	 	..q:ItmId=""
	 	..s ItmNeedAuth=$p(ItmData,"^",2)
	 	..s ItmType=$p(ItmData,"^",3)
	 	..i ItmType="I" d
	 	...i ItmId'=(+ROW1_"||1") s found=1
	 	...e  s IncludeContinueFlag=1,found=0
	 	..e  d
	 	...i ItmId=(+ROW1_"||1") s found=1
	 	//s ^TMPgry("ARCIM",ROW1)=found_","_IncludeContinueFlag_","_user_","_UserRowId_","_CurLogonDep
	 	i found=1 Q 0
	 }
	 if type="ARCOS" {
		s find=0
	 	s FavRowid=0
	 	;s ^TMPgry("ARCOS",ROW1)=ROW1_","_UserRowId_","_CurLogonDep
	 	for {
		 	s FavRowid=$O(^DHCFavItems(0,"ItemRowid",+ROW1,FavRowid)) q:FavRowid=""
		 	;医嘱套使用院区,非本院区不可见
		 	s FavUseHospDr=$p($g(^DHCFavItems(FavRowid)),"^",11)
		 	i (FavUseHospDr'=LogonHospDr) s find=1 Q	 
		 	;个人医嘱套,只对个人可见
		 	s FavUserDr=$p($g(^DHCFavItems(FavRowid)),"^",2)
		 	i (FavUserDr'="")&(UserRowId'=FavUserDr) s find=1 Q
		 	;科室医嘱套,只对科室可见
		 	s FavDepDr=$p($g(^DHCFavItems(FavRowid)),"^",4)
		 	i (FavDepDr'="")&(CurLogonDep'=FavDepDr) s find=1 Q
	 	}
	 	s ItmHosipital=$$CheckArcosHosipital(ROW1,LogonHospDr)
	 	if 'ItmHosipital s find=1
	 	
	 	if find=1 Q 0
	 	s ARCOSPrescType=##Class(web.UDHCFavItemNew).GetARCOSPrescType(ROW1,LogonHospDr)
		Q:(ARCOSPrescType="Other") 0
	 	
	 	;判断设否有医嘱套可开权限
	 	s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  d
	 	.s s=$p($g(^SSU("SSGRP",+user,"SSORD",ord)),"^",1)
	 	.q:(s-CATEG)
	 	.s subItemCat=$p($g(^SSU("SSGRP",+user,"SSORD",ord)),"^",5)
	 	.q:(subItemCat'="")&&(subItemCat-subCATEG)
	 	.s Itm=0 f  s Itm=$o(^SSU("SSGRP",+user,"SSORD",ord,"ITM",Itm)) q:Itm=""  d
	 	..s ItmData=$g(^SSU("SSGRP",+user,"SSORD",ord,"ITM",Itm))
	 	..s ItmId=$p(ItmData,"^",1)
	 	..q:ItmId=""
	 	..s ItmNeedAuth=$p(ItmData,"^",2)
	 	..s ItmType=$p(ItmData,"^",3)
	 	..i ItmType="I" d
	 	...i ItmId'=+ROW1 s found=1
	 	..e  d
	 	...i ItmId=+ROW1 s found=1
	 	i found=1 Q 0
	 } 
	 Q 1
	 ;
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
valordcat(user,CATEG)
	 ;1-valid,0-invalid
	 s found=0
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
 ;        
ALPHAUP(val,remove)
 s %trans(1)="abcdefghijklmnopqrstuvwxyz !,""#$%&'()*+-./:;<=>@[\]^_`{|},~",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
UP(val,remove) 
 s %trans(1)="abcdefghijklmnopqrstuvwxyz",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 q 0
valarcos(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
checkos(arcos,user) ;check if user is allowed to order os
	 ;0-yes,61-no
	 n (arcos,user)
	 s grp=$p($g(^SSU("SSUSR",+user)),"^",5)
	 s ord=0 f  s ord=$o(^SSU("SSGRP",+grp,"SSORD",ord)) q:ord=""  s s=^(ord),UserCat(+s)=$p(s,"^",3,4)
	 s err=$$getall^MVBARCOI(arcos_"^ALL")
	 s found=0,ind=0
	 f  s ind=$o(PLIST(ind)) q:ind=""  q:found  d
	 .s arcim=$p(PLIST(ind),$c(2))
	 .s subcat=$p($g(^ARCIM(+arcim,1,1)),"^",10)
	 .s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	 .i '$d(UserCat(+orcat)) s found=61
	 q found
checkoslimit(row)  ;validate if arcos is active 0-active,1-not active
	s arcoscode=$p($g(^ARCOS(row)),"^",1)
	s arcoscodelen=$l(arcoscode,"-")
	Q:arcoscodelen'=3 0
	Q:(LogonUserCode="")||(LogonLocID="") 0
	Q:'$D(^CTLOC(LogonLocID)) 0
	s loccode=$p($g(^CTLOC(LogonLocID)),"^",1)
	s LogonLocGroupID=$p($g(^CTLOC(LogonLocID)),"^",19)
	s LogonLocGroupCode=$P($G(^RBC("DEP",LogonLocGroupID)),"^",1) 
	s arcoslimittype=$P($g(^ARCOS(row)),"-",1)
	s arcoslimitcode=$P($g(^ARCOS(row)),"-",2)
	Q:(arcoslimittype="U")&&(arcoslimitcode=LogonUserCode) 0
	;Q:(arcoslimittype="L")&&(arcoslimitcode=loccode) 0
	Q:(arcoslimittype="L")&&(arcoslimitcode=LogonLocGroupCode) 0
	
	
	
	Q 1 

subscr(subCATEG) ;decide which index to use
	n (subCATEG,UserCat)
	;if order subcategory is blank, index can be :
	; Desc - all order items, order sets
	; DescI - all order items,no order sets
	; DescVI - visible order items, no order sets
	; DescVIOS - visible order items, order sets
	;if order subcategory is not blank, index can be :
	; OrderCat-Desc - all order items, order sets
	; OrderCat-DescI - all order items,no order sets
	; OrderCat-DescVI - visible order items, no order sets
	; OrderCat-DescVIOS - visible order items, order sets
	;
	;
	s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	s subscr="NoItems"
	i CATEG,'$d(UserCat(+CATEG)) q subscr
	i CATEG d  q subscr
	.s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	.i vis="Y",os="Y" s subscr="OrderCat-Desc"
	.i vis'="Y",os="Y" s subscr="OrderCat-DescVIOS"
	.i vis="Y",os'="Y" s subscr="OrderCat-DescI"
	.i vis'="Y",os'="Y" s subscr="OrderCat-DescVI"
	;
	;check what are settings of all order categories
	s vis="N",os="N"
	s cat="" f  s cat=$o(UserCat(cat)) q:cat=""  s s=UserCat(cat) d
	.i $p(s,"^")="Y" s vis="Y"
	.i $p(s,"^",2)="Y" s os="Y"
	i vis="Y",os="Y" s subscr="Desc"
	i vis'="Y",os="Y" s subscr="DescVIOS"
	i vis="Y",os'="Y" s subscr="DescI"
	i vis'="Y",os'="Y" s subscr="DescVI"
	q subscr
getOSItemIDs(ARCOSRowid)
	s CurLogonHosp=$p($g(^CTLOC(LogonLocID)),"^",22)
	s ExpStrIn="^^^^"_CurLogonHosp
	do ##class(web.DHCDocOrderEntry).OpenGetAllOrderSetItem(ARCOSRowid)
	s n=0,ARCOSPrice=0
	s OSItemIDs=""
	s SttDate=..%SysDate()
	s PatType="",InsType="",PriorRowid="",InstrRowid="",LinkTo="",OEPrice=""
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
	..s ARCIMRowid=$p(s,"^",1)
 	..s ARCOSItemQty=$p(s,"^",2)
 	..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	..s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,"","",ExpStrIn)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",4)
 ..s n=n+1
 ..i n=1  s OSItemIDs=ARCIMRowid_$C(14)_ARCIMDesc
 ..e  s OSItemIDs=OSItemIDs_$C(12)_ARCIMRowid_$C(14)_ARCIMDesc
 i OSItemIDs'="" s OSItemIDs=OSItemIDs_$C(4)_ARCOSPrice
 q OSItemIDs
OutputRow
	;w Data,!
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariables
	///set (repid)=0
	quit
CheckArcimHosipital(ROW1,CTLocHosi)
	;医院医嘱项目可用性
	s HosipitalStr=##class(web.DHCDocOrderEntry).ArcimCanUserHosipital(ROW1)
	Q:((CTLocHosi="")||(HosipitalStr="")) 1
	Q:("^"_HosipitalStr_"^")'[("^"_CTLocHosi_"^") 0
	Q 1
CheckArcosHosipital(ROW1,CTLocHosi)
	;医院医嘱套项目可用性
	s HosipitalStr=##class(web.DHCDocOrderEntry).ArcosCanUserHosipital(+ROW1)
	Q:((CTLocHosi="")||(HosipitalStr="")) 1
	Q:("^"_HosipitalStr_"^")'[("^"_CTLocHosi_"^") 0
	Q 1
GetDefalocID(RecLocStr)
	s DeLocID=""
	s RecLocCount=$L(RecLocStr,$C(2))
	F iLoc=1:1:RecLocCount {
		S oneRecLocStr=$P(RecLocStr,$C(2),iLoc)
		s ReclocRowId=$P(oneRecLocStr,$C(1),1)
		if iLoc=1 s DeLocID=ReclocRowId
		s Defaut=$P(oneRecLocStr,$C(1),3)
		if (Defaut="Y") s DeLocID=ReclocRowId
		
	}
	Q DeLocID
}

ClassMethod LookUpItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetCNPrescItems(EpisodeID As %String, PrescNo As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Name1:%String,Price1:%String,OrderQty1:%String,DoseUOM1:%String,PhSpecInstr1:%String,PackQty1:%String,ItemID1:%String,OrderItemID1:%String,Name2:%String,Price2:%String,OrderQty2:%String,DoseUOM2:%String,PhSpecInstr2:%String,PackQty2:%String,ItemID2:%String,OrderItemID2:%String,Name3:%String,Price3:%String,OrderQty3:%String,DoseUOM3:%String,PhSpecInstr3:%String,PackQty3:%String,ItemID3:%String,OrderItemID3:%String,Name4:%String,Price4:%String,OrderQty4:%String,DoseUOM4:%String,PhSpecInstr4:%String,PackQty4:%String,ItemID4:%String,OrderItemID4:%String")
{
}

Query LookUpDuration(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "HIDDEN:%String,CTPCPDesc,CTPCPCode,HIDDEN:%String")
{
	SELECT PHCDU_Rowid,PHCDU_Desc1, PHCDU_Code, PHCDU_Factor
	FROM SQLUser.PHC_Duration
	WHERE   ((PHCDU_Desc1  %STARTSWITH  :desc) or (PHCDU_Factor=:desc)) and (PHCDU_Desc2='饮片') 
	and ((PHCDU_DateFrom is null) or (PHCDU_DateFrom <>'' and PHCDU_DateFrom <= +$h))
	and ((PHCDU_DateTo is null) or (PHCDU_DateTo <>'' and PHCDU_DateTo >= +$h))
	ORDER BY PHCDU_Factor
}

Query LookUpFrequence(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "CTPCPDesc,CTPCPCode,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
	SELECT PHCFR_Desc1, PHCFR_Code, PHCFR_Factor,PHCFR_Days,PHCFR_Rowid
	FROM SQLUser.PHC_Freq
	WHERE  (PHCFR_Code=:desc or PHCFR_Desc1  %STARTSWITH  :desc) and (%ALPHAUP PHCFR_Desc2='饮片') and (PHCFR_ActiveFlag="Y")
	ORDER   BY PHCFR_Code
}

Query LookUpInstr(desc As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "HIDDEN:%String,Desc:%String,Code:%String")
{
	SELECT PHCIN_RowId,PHCIN_Desc1,PHCIN_Code FROM SQLUser.PHC_Instruc 
	WHERE (PHCIN_Desc1 %STARTSWITH :desc or PHCIN_Code=:desc) and (PHCIN_Desc2='饮片') and (PHCIN_ActiveFlag <> 'N')
	ORDER BY PHCIN_Code
}

Query LookUpItem(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, LUCategoryDesc As %Library.String, LUSubCategoryDesc As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, RelocID As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String:名称,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,SubCategoryDesc:%String:子类,Price:%String:价格,BillUOM:%String:单位,StockQty:%String:库存,PackedQty:%String:打包数,FormDesc:%String:剂型,InsuNationCode:%String:国家医保编码,InsuNationName:%String:国家医保名称,InsurClass:%String:医保类别,DrugIconStr:%String:药品图标")
{
}

/// Creater	lxz 
/// Desc	找Arcin草药的基本单位^药学项表 合理用药需要传入的参数
/// w ##class(web.DHCDocOrderEntryCM).GetCMUomAndDrgForm()
ClassMethod GetCMUomAndDrgForm(ArcimID As %String = "") As %String
{
	Q:ArcimID=""""
	s DrgID=""
	s OrderPackUOM=""
	s DrgFormRowid=##Class(web.DHCDocOrderEntry).GetDrgForm(ArcimID)
	s ARCIMBillingUOM=$P($G(^ARCIM(+ArcimID,$P(ArcimID,"||",2),8)),"^",14) 
	if ARCIMBillingUOM'="" d
	.s OrderPackUOM=$P(^CT("UOM",ARCIMBillingUOM),"^",2)
	Q ARCIMBillingUOM_"^"_DrgFormRowid
}

/// 取膏方加工相关的处方限定规则
/// w ##class(web.DHCDocOrderEntryCM).GetPrescBound("CNMedItemCat")
ClassMethod GetPrescBound(PrescTypeCode As %String = "", CurLogonHosp As %String = "") As %String
{
	q:PrescTypeCode="" ""
	s PrescTypePrescBound=..%GetConfig1("PrescTypePrescBound",PrescTypeCode,CurLogonHosp)
	q:PrescTypePrescBound="" ""
	//s UomRowid=$p(PrescTypePrescBound,"^",1)
	//s UomDesc=$ZCVT($p($g(^CT("UOM",UomRowid)),"^",1),"U")
	//s PrescTypePrescBound=UomDesc_"^"_$p(PrescTypePrescBound,"^",2,5)
	q PrescTypePrescBound
}

/// 判断医嘱项是否在有效期内
ClassMethod CheckArcimActiveDate(ArcimRowid As %String) As %String
{
	q:ArcimRowid="" "-1^医嘱项不能为空"
	s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2)
	s datefrom=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+ArcimRowid,1,7)),"^",1)
	 
	 i datefrom>+$h q "-1^"_ArcimDesc_"医嘱项还没有到生效日期"
	 i dateto,dateto<+$h q "-1^"_ArcimDesc_"医嘱项已经过期"
	 q 0
}

ClassMethod CheckConflict(EpisodeID As %String, ArcimRowid As %String, CurLogonHosp As %String = "") As %String
{
	s prescNo=""
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	Q:OrderRowid="" "N"
	s ConflictItems=##class(web.DHCDocConfig).GetConflict(ArcimRowid,CurLogonHosp)
	Q:ConflictItems="" "N"
	s ConflictItems="^"_ConflictItems_"^" 
	Set langid=..%LanguageID()
	s ConflictInfo=""
	s find="N"
	s ARCIMDesc=""
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d //!(find="Y")
	.s sttdate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	.s OrdPriorityDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",8)              ;医嘱优先级
	.q:OrdPriorityDR=""
	.//s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(OrdPriorityDR)
	.//q:ISLongOrderPrior'=1
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.//停互斥医嘱时，当天执行记录全部停止
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
    .s ItemCatRowId=+$p($g(^ARCIM(+$g(itemrowid),1,1)),"^",10)
    .s StopAllExecItemCat=..%GetConfig("StopAllExecItemCat",CurLogonHosp) //$g(^DHCDocConfig("StopAllExecItemCat"))
    .//s StopAllExecFlag=0
    .//i ("^"_StopAllExecItemCat_"^")[("^"_ItemCatRowId_"^") s StopAllExecFlag=1
    .//i itemsub="209" b //12
    .//Q:($g(statcode)="D")&&(StopAllExecFlag'=1)
    .//Q:($g(statcode)="I")||($g(statcode)="U")
    .//------end--------------
	.Q:(statcode'="V")
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.i itemrowid'="" d
	..i ConflictItems[("^"_itemrowid_"^") d
	...s find="Y"
	...s ARCIMDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(itemrowid,langid)
	...i ARCIMDesc="" d
	....s ARCIMDesc=$p($g(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1)),"^",2)
	....s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	...s prescNo=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",14)
	...i ConflictInfo="" s ConflictInfo= ##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","与处方【")_prescNo_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","】中的【")_ARCIMDesc_"】" //"与处方"+prescNo+"中的"+ConflictItemDesc+"互斥!
	...e  s ConflictInfo=ConflictInfo_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",",与处方【")_prescNo_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","】中的【")_ARCIMDesc_"】"
	.//Q:find="Y"
	Q find_"^"_ConflictInfo //ARCIMDesc_"^"_prescNo
}

/// 生阿胶 白附子
/// w ##class(web.DHCDocOrderEntryCM).GetCMLimitInfo("2671||1","2691||1")
ClassMethod GetCMLimitInfo(ARCIMRowId As %String, ARCIMRowIdNextALL As %String) As %String
{
	s ^tempscl("GetCMLimitInfo")=ARCIMRowId_","_ARCIMRowIdNextALL
	;自己互斥自己不起作用
	;如果传入的是主ID先验证主表,主表维护的对应的互斥 User.DHCItmMast
	Q:(ARCIMRowId="")||(ARCIMRowIdNextALL="") ""
	s GenericDr=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),8)),"^",20)
	Q:GenericDr="" ""
	//q:ITCRowID="" ""
	Set langid=..%LanguageID()
	s GenericDrNextALL=""
	for i=1:1:$L(ARCIMRowIdNextALL,"^"){
		s myARCIMRowId=$P(ARCIMRowIdNextALL,"^",i)
		continue:(myARCIMRowId="")
		s myGenericDr=$p($g(^ARCIM(+myARCIMRowId,$p(myARCIMRowId,"||",2),8)),"^",20)
		if (GenericDrNextALL="") s GenericDrNextALL=myGenericDr
		e  s GenericDrNextALL=GenericDrNextALL_"^"_myGenericDr
	}
	s ITCGenericALL=""
	s CMLimitInfo=""
	s SameGenericArcimMain=0
	for {
		s SameGenericArcimMain=$O(^ARCIM(0,"Gener",GenericDr,SameGenericArcimMain))
		q:(SameGenericArcimMain="")
		s SameGenericArcimSub=$O(^ARCIM(0,"Gener",GenericDr,SameGenericArcimMain,0))
		s ITCRowID=$o(^DHCItmMast("0","ARCIM",SameGenericArcimMain_"||"_SameGenericArcimSub,""),-1)
		if (ITCRowID'=""){
			s ITCSub=0 
			for{
				s ITCSub=$o(^DHCItmMast(ITCRowID,"CF",ITCSub))
				q:ITCSub=""
				s ITCConflictItmDR=$p($g(^DHCItmMast(ITCRowID,"CF",ITCSub)),"^",1)
				continue:ITCConflictItmDR=""
				s ITCGenericDr=$p($g(^ARCIM(+ITCConflictItmDR,$p(ITCConflictItmDR,"||",2),8)),"^",20)
				s ITCConflictType=$p($g(^DHCItmMast(ITCRowID,"CF",ITCSub)),"^",2)
				if (ITCConflictType="R")||(ITCConflictType="F"){
					continue:("^"_GenericDrNextALL_"^")'[("^"_ITCGenericDr_"^")
				}else{
					continue:("^"_ARCIMRowIdNextALL_"^")'[("^"_ITCConflictItmDR_"^")
				}
				continue:("^"_ITCGenericALL_"^")[("^"_ITCGenericDr_"^")
				i ITCGenericALL="" s ITCGenericALL=ITCGenericDr
				e  s ITCGenericALL=ITCGenericALL_"^"_ITCGenericDr
				s ConflictItmDesc=$p($g(^PHCGE("GE",ITCGenericDr)),"^",2)
				Set ConflictItmDesc= ##class(User.PHCGeneric).GetTranByDesc("PHCGEName",ConflictItmDesc,langid)
				i ITCConflictType="R" s ITCConflictType="反"
				i ITCConflictType="F" s ITCConflictType="畏"
				s ITCConflictType=##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",ITCConflictType)
				i CMLimitInfo="" s CMLimitInfo=ITCConflictType_ConflictItmDesc
				e  s CMLimitInfo=CMLimitInfo_" "_ITCConflictType_ConflictItmDesc
			}
		}
	}
	;如果传入ID在其他医嘱项目子表中 User.DHCItmConflict (可能一个项目包含在多个子表中)
	s ITCGenericALL="",OtherCMLimitInfo=""
	s SameGenericArcimMain=0
	for {
		s SameGenericArcimMain=$O(^ARCIM(0,"Gener",GenericDr,SameGenericArcimMain))
		q:(SameGenericArcimMain="")
		s SameGenericArcimSub=$O(^ARCIM(0,"Gener",GenericDr,SameGenericArcimMain,0))
		s SameGenericARCIMRowId=SameGenericArcimMain_"||"_SameGenericArcimSub
		s ITCRowID=""
		for{
			s ITCRowID=$o(^DHCItmMast("0","CFARCIM",SameGenericARCIMRowId,ITCRowID))
			q:ITCRowID=""
			s MainArcimRowid=$p(^DHCItmMast(ITCRowID),"^",1)
			s MainGenericDr=$p($g(^ARCIM(+MainArcimRowid,$p(MainArcimRowid,"||",2),8)),"^",20)
			if (("^"_ARCIMRowIdNextALL_"^")'[("^"_MainArcimRowid_"^"))&&(("^"_GenericDrNextALL_"^")'[("^"_MainGenericDr_"^")){
				continue
			}
			s ITCSub=0,SameItemType=""
			for{
				s ITCSub=$o(^DHCItmMast(ITCRowID,"CF",ITCSub))
				q:ITCSub=""
				s ITCConflictItmDR=$p($g(^DHCItmMast(ITCRowID,"CF",ITCSub)),"^",1)
				s ITCConflictType=$p($g(^DHCItmMast(ITCRowID,"CF",ITCSub)),"^",2)
				s ITCGenericDr=$p($g(^ARCIM(+ITCConflictItmDR,$p(ITCConflictItmDR,"||",2),8)),"^",20)
				if (ITCConflictType="R")||(ITCConflictType="F"){
					continue:("^"_ITCGenericDr_"^")'[("^"_GenericDr_"^")
				}else{
					continue:("^"_ITCConflictItmDR_"^")'[("^"_ARCIMRowId_"^")
				}
				continue:("^"_ITCGenericALL_"^")[("^"_ITCGenericDr_"^")
				i ITCGenericALL="" s ITCGenericALL=ITCGenericDr
				e  s ITCGenericALL=ITCGenericALL_"^"_ITCGenericDr
				s ConflictItmDesc=$p($g(^PHCGE("GE",ITCGenericDr)),"^",2)
				i ITCConflictType="R" s ITCConflictType="反"
				i ITCConflictType="F" s ITCConflictType="畏"
				s ITCConflictType=##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",ITCConflictType)
				if (ITCConflictItmDR=ARCIMRowId){
					s SameItemType=ITCConflictType
					continue
				}
				s MainConflictItmDesc=$p($g(^PHCGE("GE",MainGenericDr)),"^",2)
				Set MainConflictItmDesc= ##class(User.PHCGeneric).GetTranByDesc("PHCGEName",MainConflictItmDesc,langid)
				i OtherCMLimitInfo="" s OtherCMLimitInfo=ITCConflictType_MainConflictItmDesc
				e  s OtherCMLimitInfo=OtherCMLimitInfo_" "_ITCConflictType_MainConflictItmDesc
			}
			if (SameItemType'=""){
				s MainConflictItmDesc=$p($g(^PHCGE("GE",MainGenericDr)),"^",2)
				Set MainConflictItmDesc= ##class(User.PHCGeneric).GetTranByDesc("PHCGEName",MainConflictItmDesc,langid)
				i OtherCMLimitInfo="" s OtherCMLimitInfo=SameItemType_MainConflictItmDesc
				e  s OtherCMLimitInfo=OtherCMLimitInfo_" "_SameItemType_MainConflictItmDesc
			}
		}
	}
	q:OtherCMLimitInfo=CMLimitInfo CMLimitInfo
	q CMLimitInfo_" "_OtherCMLimitInfo
}

ClassMethod GetInstrucLinkDosage(InstrucRowId As %String) As %String
{
	set DosageStr=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.CMDocConfig:FindInstrLinkOrderQty")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(InstrucRowId)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s DefaultQtyID=rset.GetData(1)
			s DefaultQty=rset.GetData(2)
			if (DosageStr="") {
				s DosageStr=DefaultQtyID_$C(1)_DefaultQty
			}else{
				s DosageStr=DosageStr_$C(2)_DefaultQtyID_$C(1)_DefaultQty
			}
		}
	}
	q DosageStr
	/*
	Q:InstrucRowId="" ""
	s ILDRowId=$o(^PHCINLD(0,"Instruc",InstrucRowId,""))
	Q:ILDRowId=""
	s ILDDosageDr=$p(^PHCINLD(ILDRowId),"^",2)
	Q:ILDDosageDr="" ""
	s PHCDOQty=$p(^PHCDO(ILDDosageDr),"^",6)
	Q:PHCDOQty="" ""
	s PHCDOCTUOMDR=$p(^PHCDO(ILDDosageDr),"^",5)
	if (PHCDOCTUOMDR'=""){
		s CTUOMDesc=$p(^CT("UOM",PHCDOCTUOMDR),"^",2)
		s PHCDOQty=PHCDOQty_""_CTUOMDesc
	}
	Q PHCDOQty
	*/
}

ClassMethod GetPatIDByInMedNo(PatMed As %String) As %String
{
	q:PatMed="" ""
	//set PersonRowId =##Class(web.DHCWMRService).IGetPatientIDByMrNo(PatMed)
	s PersonRowId=##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(PatMed,"")
	q:PersonRowId="" ""
	s PatNo=$p($g(^PAPER(PersonRowId,"PAT",1)),"^",1)
	q PersonRowId_"^"_PatNo
}

/// modify:guorongyong
/// date:20170908
/// desc:是否协定处方项目
/// input:ARCIMRowid 医嘱项RowId
/// output:1 是协定处方,0 不是协定处方
/// w ##class(web.DHCDocOrderEntryCM).IsPrecompoundedARCIM("22938||1")
ClassMethod IsPrecompoundedARCIM(ARCIMRowid As %String, CurLogonHosp As %String = "") As %String
{
	n (ARCIMRowid,CurLogonHosp,%session)
	s ret=0
	Q:+ARCIMRowid="0" ret
	
	s FormulaItemCat=..%GetConfig("FormulaItemCat",CurLogonHosp)
	s ARCIMItemCatDR=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",10)
	i ("^"_FormulaItemCat_"^")[("^"_ARCIMItemCatDR_"^") {
		s ret=1
	}
	
	Q ret
}

/// modify:guorongyong
/// date:20170907
/// desc:草药一个医嘱项对多个库存项目
/// w ##class(web.DHCDocOrderEntryCM).GetINCI("479||1",99,.INCIArray)
ClassMethod GetINCI(ARCIMsub As %String, recLoc As %String, ByRef INCIArray As %Library.ArrayOfDataTypes, AdmType As %String) As %String
{
	n (ARCIMsub,recLoc,INCIArray,AdmType)
	s ^tmpgry("GetINCI")=ARCIMsub_","_recLoc
	s ARCIMsub=$p(ARCIMsub,$c(1),1)
	s INCIrowStr=##Class(web.DHCSTINTERFACE).GetIncilQtyList(ARCIMsub,recLoc,AdmType)
	;库存项ID^库存项代码^库存项名称^规格^住院单位id^住院单位描述^门诊单位ID^门诊单位描述^当前库存数^可用库存数^医嘱占用数^库存业务占用数 $c(2) 库存项2
	;数量都是基本单位对应的数量
	for i=1:1:$l(INCIrowStr,$c(2)) {
		s oneINCIrowInfo=$p(INCIrowStr,$c(2),i)
		continue:oneINCIrowInfo=""
		s INCIrow=$p(oneINCIrowInfo,"^",1)
		s INCIArray(INCIrow)=oneINCIrowInfo
	}
	q 0
}

/// modify:guorongyong
/// date:20170908
/// desc:得到协议处方项目的
/// input:
/// output：组合数1，组合数2，..._$C(2)_MaxStockQtyINICrow_"!"_Qty_"@"_MaxStockQtyINICrow_"!"_Qty_..._$C(2)_邻近最小值_$C(2)_邻近最大值,为空则为未获取到数据
/// w ##class(web.DHCDocOrderEntryCM).GetINCIPackCombStr("710","576||1","96",10)
ClassMethod GetINCIPackCombStr(EpisodeID As %String, ARCIM As %String, recLoc As %String, Sum As %String, TakingMedicine As %String = "Y") As %String
{
	n (EpisodeID,ARCIM,recLoc,Sum,TakingMedicine,%session)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s ret=""
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s INCIrowStr=##Class(web.DHCSTINTERFACE).GetIncilQtyList(ARCIM,recLoc,AdmType,TakingMedicine)
	;b	;INCIrowStr
	Kill CombAry,CombAryINCI
	s Count=0
	for i=1:1:$l(INCIrowStr,$c(2)) {
		s oneINCIrowInfo=$p(INCIrowStr,$c(2),i)
		continue:oneINCIrowInfo=""
		s INCIrow=$p(oneINCIrowInfo,"^",1)
		s IPUomDR=$p(oneINCIrowInfo,"^",5)
		s OPUomDR=$p(oneINCIrowInfo,"^",7)
		;可用库存数
		s AvailStockQty=$p(oneINCIrowInfo,"^",10)
		;开医嘱时不考虑库存数
		continue:AvailStockQty'>0
		i AdmType'="I" {
			s ConFac=##class(web.DHCDocOrderEntry).GetOPConFac(ARCIM,INCIrow,AdmType,AdmHospitalId)
		}else{
			s ConFac=##class(web.DHCDocOrderEntry).GetIPConFac(ARCIM,INCIrow,AdmType,AdmHospitalId)
		}
		;CombAryINCI用于处理：如果多个库存项转换系数一样，取可用库存最大的
		i ConFac'=0 {
			/*i '$d(CombAryINCI(ConFac)) {
				s Count=Count+1
				s CombAry(Count)=ConFac
			}*/
			s CombAryINCI(ConFac,INCIrow)=AvailStockQty
		}
	}
	s ConFac=0
	for {
	    s ConFac=$O(CombAryINCI(ConFac)) Q:ConFac=""
	    s Count=Count+1
	    s CombAry(Count)=ConFac
	}
	s AvailResultList=""
	;由于饮片可能开出小于小数 所以这里需要对饮片单独处理
	s ARCIMDesc=$p($g(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",2)
	s AllowEntryDecimalItemCat=$p($g(^ARCIM(+ARCIM,$p(ARCIM,"||",2),"DHC")),"^",29)
	s CheckSum=Sum\1		//整数位
	s DecimalNum=Sum#1		//小数位
	
	;s CheckSum=2.1
	;b ;2222
	s Flag=..CheckSums(.CombAry,CheckSum,.AvailResultList)
	Q:Flag=0 ret
    ;b ;得到库存项数组
    Kill INCIArray
    d ##class(web.DHCDocOrderEntryCM).GetINCI(ARCIM,recLoc,.INCIArray,AdmType)
    ;找组合数,算法需优化
	s ListLen=$ll(AvailResultList)
	s i=ListLen
	while (i>=1){
    //for i=1:1:ListLen {
	    s oneComb=$list(AvailResultList,i)
	    s oneConFac=$p(oneComb,"*",1)
	    s times=$p(oneComb,"*",2)
	    
	    s INICrow=0,MaxStockQtyINICrow=0
	    for {
	    	s INICrow=$O(CombAryINCI(oneConFac,INICrow)) Q:INICrow=""
	    	;根据库存项判断库存数
	    	i $d(INCIArray(INICrow)) {
		    	s AvailStockQty=$p(INCIArray(INICrow),"^",10)
		    	;i MaxStockQtyINICrow<AvailStockQty s MaxStockQtyINICrow=INICrow
		    	s MaxStockQtyINICrow=INICrow
	    	}	
	    }
		;s MaxStockQty=oneConFac*times
	    ;此处的times是住院/门诊发药单位的数量 以前转换药学基本单位 180410以后转换库存单位
	    s FindDispUomId=""
	    i AdmType'="I" {
			s FindDispUomId=$p($g(^INCI(MaxStockQtyINICrow,1)),"^",12) 
		}else{
			s FindDispUomId=$p($g(^INCI(MaxStockQtyINICrow,1)),"^",13)
		}
		s FindBaseUomId=$p($g(^INCI(MaxStockQtyINICrow,1)),"^",10)
		s FindConFac=##class(web.DHCSTINTERFACE).UOMFac(FindDispUomId,FindBaseUomId)
		i (+FindConFac=0) s FindConFac=1
	    s MaxStockQty=FindConFac*times //times 
	    if (DecimalNum>0)&&(i=1){
			//s MaxStockQty=(FindConFac*times)/100 //times/100 
			s MaxStockQty=MaxStockQty+DecimalNum
		}
	    i ret="" s ret=MaxStockQtyINICrow_"!"_MaxStockQty
	    e  s ret=ret_"@"_MaxStockQtyINICrow_"!"_MaxStockQty 
	    s i=i-1
    }
    Q ret
}

/// modify:guorongyong
/// date:20170908
/// desc:草药一个医嘱项对多个库存项目，根据医嘱项和数量计算是否符合库存项数量组合(用库存项住院/门诊最小发药单位 与 药学项基本单位换算)
/// input:
/// output：组合数1，组合数2，..._$C(2)_MaxStockQtyINICrow_"!"_Qty_"@"_MaxStockQtyINICrow_"!"_Qty_..._$C(2)_邻近最小值_$C(2)_邻近最大值,为空则为未获取到数据
/// output1(协定处方项目):""_$C(2)_MaxStockQtyINICrow_"!"_Qty_"@"_MaxStockQtyINICrow_"!"_Qty_..._$C(2)_""_$C(2)_"",为空则为未获取到数据
/// w ##class(web.DHCDocOrderEntryCM).CheckINCIPackSum(35,"4481||1",245,"")
ClassMethod CheckINCIPackSum(EpisodeID As %String, ARCIM As %String, recLoc As %String, Sum As %String, CurLogonHosp As %String = "", TakingMedicineMethod As %String = "") As %String
{
	n (EpisodeID,ARCIM,recLoc,Sum,CurLogonHosp,TakingMedicineMethod,%session)
	s CurLogonHosp=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	//s Index=$I(^scl("CheckINCIPackSum"))
	//s ^tmpgry("CheckINCIPackSum",Index)=EpisodeID_","_ARCIM_","_recLoc_","_Sum_","_CurLogonHosp
	s ret=""
	Q:ARCIM="" ret 
	s Sum=$fn(Sum,"",2)
	s Subscript=$p(ARCIM,"||",1)
	s Version=$p(ARCIM,"||",2)
	s TakingMedicine="Y" //取药方式可以不判断库存
	if (TakingMedicineMethod'=""){
		s ToStock=$P(^DHCDocConfig("TakingMedicineMethod",TakingMedicineMethod),$c(1),4)
		if ((ToStock="N")||(ToStock=""))  s TakingMedicine="N"
	}
	s PrecompoundedARCIM=..IsPrecompoundedARCIM(ARCIM,CurLogonHosp)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s INCIrowStr=##Class(web.DHCSTINTERFACE).GetIncilQtyList(ARCIM,recLoc,AdmType,TakingMedicine)
	Q:INCIrowStr="" ret
	s AvailStock=0
	for i=1:1:$l(INCIrowStr,$c(2)) {
		s oneINCIrowInfo=$p(INCIrowStr,$c(2),i)
		continue:oneINCIrowInfo=""
		;可用库存数
		s AvailStockQty=$p(oneINCIrowInfo,"^",10)
		;开医嘱时不考虑库存数
		if AvailStockQty>0  s AvailStock=1
	}
	q:AvailStock=0 ret
	b ;--新疆中医版的协定处方程序，标板暂不采纳，tanjishan
	if 0 {
		b ;按协议包装对应的项目计算库存项目的组合数
		s AllPrecompoundedCombStr=""
		s DepId=0
		for {
			s DepId=$O(^ARCIM(Subscript,Version,"DEPEND",DepId)) q:DepId=""
			s DEPARCIMDR=$p(^ARCIM(Subscript,Version,"DEPEND",DepId),"^",3)
			continue:DEPARCIMDR=""
			s DEPDateFrom=$p(^ARCIM(Subscript,Version,"DEPEND",DepId),"^",1)
			continue:(DEPDateFrom'="")&&(DEPDateFrom>+$h)
			s DEPDateTo=$p(^ARCIM(Subscript,Version,"DEPEND",DepId),"^",2)
			continue:(DEPDateTo'="")&&(DEPDateTo<+$h)
			s DEPDoseQty=$p(^ARCIM(Subscript,Version,"DEPEND",DepId),"^",7)
			s DEPUnitDR=$p(^ARCIM(Subscript,Version,"DEPEND",DepId),"^",8)
			s INCIPackCombStr=..GetINCIPackCombStr(EpisodeID,DEPARCIMDR,recLoc,DEPDoseQty,TakingMedicine)
			i INCIPackCombStr="" {
				quit
			}else{
				i AllPrecompoundedCombStr="" s AllPrecompoundedCombStr=INCIPackCombStr
				e  s AllPrecompoundedCombStr=AllPrecompoundedCombStr_"@"_INCIPackCombStr
			}
		}
		Q ""_$C(2)_AllPrecompoundedCombStr_$C(2)_""_$C(2)_""
	}
	s AllowEntryDecimalItemCat=$p($g(^ARCIM(+ARCIM,$p(ARCIM,"||",2),"DHC")),"^",29)
	s INCIPackCombStr=..GetINCIPackCombStr(EpisodeID,ARCIM,recLoc,Sum,TakingMedicine)
	s ret=INCIPackCombStr
    i ret="" {
		;找最邻近的小数值,用于建议
	    s tmpSum=Sum,minNear=0
	    while (minNear=0) {
			if (AllowEntryDecimalItemCat="Y"){
				s tmpSum=tmpSum-0.1
			}else{
				s tmpSum=tmpSum-1
			}
	        
	        if (tmpSum<0) {
	            s minNear=-1
	            continue
	        }
	        s tmpAvailResultList=""
	        ;b ;if (..CheckSums(.CombAry,tmpSum,.tmpAvailResultList)'=0) s minNear=tmpSum quit
	        if (..GetINCIPackCombStr(EpisodeID,ARCIM,recLoc,tmpSum,TakingMedicine)'="") {
		        s minNear=tmpSum quit
		    }else{
			   //continue 
			}
	    }
	    if (minNear=-1) s minNear="0"
	    ;找最邻近的大数值,用于建议
	    s tmpSum=Sum,maxNear=0
	    while (maxNear=0) {
	        
			if (AllowEntryDecimalItemCat="Y"){
				s tmpSum=tmpSum+0.1
			}else{
				s tmpSum=tmpSum+1
			}
	        ;b ;if (..CheckSums(.CombAry,tmpSum,.tmpAvailResultList)'=0) s maxNear=tmpSum quit
	        if (..GetINCIPackCombStr(EpisodeID,ARCIM,recLoc,tmpSum,TakingMedicine)'="") {
		        s maxNear=tmpSum quit
		    }else{
			   //continue 
			}
	    }
	    if ((maxNear#1)>0)||((minNear#1)>0){
		 	if (AllowEntryDecimalItemCat'="Y") {
			 	s maxNear=maxNear\1+$s(maxNear#1:1,1:0)
			 	s minNear=minNear\1+$s(minNear#1:1,1:0)
			}
		}
	    s ret=ret_$c(2)_minNear_$C(2)_maxNear
    }
    ;获取可用的库存包装
    s INICConFacStr=""
    s Count=0
    for {
    	s Count=$O(CombAry(Count)) Q:Count=""
    	i INICConFacStr="" s INICConFacStr=CombAry(Count)
    	e  s INICConFacStr=INICConFacStr_","_CombAry(Count)
    }
    i ret'="" s ret=INICConFacStr_$C(2)_ret
    
    ;ret: INICConFacStr_$C(2)_MaxStockQtyINICrow_"!"_Qty_"@"_MaxStockQtyINICrow_"!"_Qty_..._$C(2)_minNear_$C(2)_maxNear
	Q ret
}

/// modify:guorongyong
/// date:20170908
/// desc:判断一个数是不是由几个系数组合而来
/// input: 需要计算的组合数数组,总额
/// output：1 成功 0
/// w ##class(web.DHCDocOrderEntryCM).CheckSums(.NumArray, 13)
ClassMethod CheckSums(NumArray, Sum, AvailResultList)
{
	n (NumArray, Sum,AvailResultList,%session)
    s flag = 0,ResultList=""
    s ArrayLen=$o(NumArray(""),-1)
    if (ArrayLen = 1) {
        if ((Sum#NumArray(ArrayLen)) = 0) {
	        s $list(ResultList,$ll(ResultList)+1)=NumArray(ArrayLen)_"*"_(Sum/NumArray(ArrayLen))
            s flag = 1
        }
    } else {
        s flag = ..CheckSum(Sum, .NumArray, 1, .ResultList, Sum)
    }
    ;得到实际组合数
    for j=1:1:$ll(ResultList) {
	    s oneResult=$List(ResultList,j)
	    s ExecStr="s oneResultValue="_oneResult
	    x ExecStr
		;只有在Sum=0时，oneResultValue才等于0？这个判断针对可以录入小数的0.2这种存在问题，暂时屏蔽？-tanjishan20210720
        if (oneResultValue=0)&&(Sum'=0) continue
        s $List(AvailResultList,$ll(AvailResultList)+1)=oneResult
    }
    q AvailResultList
}

ClassMethod CheckSum(Sum, NumArray, j, ResultList, Sum1)
{
	n (Sum, NumArray, j, ResultList, Sum1 ,%session)
    s str = ""
    s NumArrayLen=$o(NumArray(""),-1)
    if ((j+1) > NumArrayLen) {
        q 0
    }
    if (Sum <= 0) {
        q -1
    }
    s num1 = NumArray(j)
    s num2 = NumArray(j + 1)
    s n1 = 0
    s i = 0
    s flag = 0
    while (1) {
        if (num1 <= 0) {
            QUIT
        }
        if (num2 <= 0) {
            QUIT
        }
        if (Sum <= 0) {
            QUIT
        }
        s n1 = Sum - (num1 * i)
        if (n1 < 0) {
            QUIT
        }
        s n2 = n1 # num2
        if (n2 = 0) {
	        if (n1=Sum) {
		        ;说明num2可以直接被Sum整除
		        s $List(ResultList,$ll(ResultList)+1)=num2_"*"_(n1/num2)
	        }else{
		        ;在递归过程中肯定如果进入此过程,ResultList肯定是首次赋值，也不可能进第二次
                s $List(ResultList,$ll(ResultList)+1)=num1_"*"_i
                s $List(ResultList,$ll(ResultList)+1)=num2_"*"_(n1/num2)
	        }
            s flag=1
            QUIT
        } else {
            s flag = ..CheckSum(n1, .NumArray, j + 1, .ResultList, Sum1)
        }
        if (flag = 1) {
	        ;此处一定是递归后的ResultList赋值,所以一定是第二次赋值
	        s $List(ResultList,$ll(ResultList)+1)=num1_"*"_i
            QUIT
        }
        s i = i + 1
    }
    QUIT flag
}

/// 根据医嘱项ID获取草药备注
/// w ##class(web.DHCDocOrderEntryCM).GetARCIMPhSpecInstr("15||1")
ClassMethod GetARCIMPhSpecInstr(ARCIMRowId As %String) As %String
{
	Q:ARCIMRowId="" ""
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowId)
	Q:DrgFormRowid="" ""
	s PhSpecInstr=$p($g(^PHCD(+DrgFormRowid,"DF",$p(DrgFormRowid,"||",2),"DHC")),"^",7)
	Q:PhSpecInstr="" ""
	s PhSpecInstrALL=""
	s InstrLen=$l(PhSpecInstr,",")
	f Seq=1:1:InstrLen {
		s PhSpecInstrID=$p(PhSpecInstr,",",Seq)
		continue:PhSpecInstrID=""
		i PhSpecInstrID="1" s PhSpecInstrDesc="先煎"
		i PhSpecInstrID="2" s PhSpecInstrDesc="后下"
		i PhSpecInstrID="3" s PhSpecInstrDesc="冲服"
		i PhSpecInstrID="4" s PhSpecInstrDesc="烊化"
		i PhSpecInstrID="5" s PhSpecInstrDesc="包煎"
		i PhSpecInstrID="6" s PhSpecInstrDesc="另泡兑"
		i PhSpecInstrID="7" s PhSpecInstrDesc="煎水"
		i PhSpecInstrID="8" s PhSpecInstrDesc="泡饮"
		i PhSpecInstrALL="" s PhSpecInstrALL=PhSpecInstrID_$c(1)_PhSpecInstrDesc
		e  s PhSpecInstrALL=PhSpecInstrALL_"^"_PhSpecInstrID_$c(1)_PhSpecInstrDesc
	}
	Q PhSpecInstrALL
}

/// w ##Class(web.DHCDocOrderEntryCM).AutoConvertPrescForm(1,"4798||1^10^^1^1","CNMedItemCat",245)
ClassMethod AutoConvertPrescForm(EpisodeID As %String, OrderItemStr As %String, PrescTypeCode As %String, OrderRecDepRowid As %String, CurLogonHosp As %String = "") As %String
{
	s ^tempqujian("AutoConvertPrescForm")=EpisodeID_","_OrderItemStr_","_PrescTypeCode_","_OrderRecDepRowid
	if (OrderItemStr=""){
		q ""
	}
	s CurLogonHosp=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s AllowEntryDecimalItemCat=##Class(web.DHCDocOrderCommon).GetAllowEntryDecimalItemCat(EpisodeID,CurLogonHosp)
	s ErrInfo=""
	s ConvertOrderItemStr=""
	s JsonData=""
	Set langid=..%LanguageID()
	f i=1:1:$L(OrderItemStr,$C(1)){
		s OneOrderItem=$P(OrderItemStr,$C(1),i)
		s OrderARCIMRowid=$P(OneOrderItem,"^",1)
		s OrderDoseQty=$P(OneOrderItem,"^",2)
		s OrderPhSpecInstr=$P(OneOrderItem,"^",3)
		s Row=$P(OneOrderItem,"^",4)
		s ColName=$P(OneOrderItem,"^",5)
		
		s OrderName=$p(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",2)
		s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
		s retVal=##class(web.DHCST.PhcConvert).GetPhcConvertByArcim(OrderARCIMRowid,OrderDoseQty,PrescTypeCode,CurLogonHosp)
		if ($p(retVal,"^",1)<0){
			if (ErrInfo=""){
				s ErrInfo=OrderName_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","转换失败,"_$p(retVal,"^",2))
			}elseif (ErrInfo'=""){
				s ErrInfo=ErrInfo_";"_OrderName_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","转换失败,"_$p(retVal,"^",2))
			}
			s ConvertOneOrd="^"_"^"_"^"_Row_"^"_ColName
			if (ConvertOrderItemStr=""){
				s ConvertOrderItemStr=ConvertOneOrd
			}else{
				s ConvertOrderItemStr=ConvertOrderItemStr_$C(1)_ConvertOneOrd
			}
		}else{
			if (retVal["!!"){
				if (JsonData=""){s JsonData="[{text:'只能选择一种进行转换',type:'chapter',items:["_"{text:'"_OrderName_"',type:'section',items:["}
				else {s JsonData=JsonData_",{text:'"_OrderName_"',type:'section',items:["}
				s listJsonDate=""
				for j=1:1:$L(retVal,"!!"){
					s retValstr=$P(retVal,"!!",j)
					s NewOrderARCIMRowid=$P(retValstr,"^",1)
					s NewOrderDoseQty=$P(retValstr,"^",2)
					s ItemCatRowid=$p($g(^ARCIM(+NewOrderARCIMRowid,$p(NewOrderARCIMRowid,"||",2),1)),"^",10)
    				if ("^"_AllowEntryDecimalItemCat_"^")'[("^"_ItemCatRowid_"^"){
	    				if ((NewOrderDoseQty#1)>0){
		    				s NewOrderDoseQty=NewOrderDoseQty\1+$s(NewOrderDoseQty#1:1,1:0)
		    			}
	    			}
					s NumStr=##Class(web.DHCDocOrderEntryCM).CheckINCIPackSum(EpisodeID,NewOrderARCIMRowid, OrderRecDepRowid,NewOrderDoseQty,CurLogonHosp)
					if (NumStr'=""){
						s INICrowInfo=$P(NumStr,$C(2),2)
						s minNear=$P(NumStr,$C(2),3)
						s maxNear=$P(NumStr,$C(2),4)
						if (INICrowInfo=""){
							//s NewOrderDoseQty=maxNear
						}
					}
					s ConvertOneOrd=NewOrderARCIMRowid_"^"_NewOrderDoseQty_"^"_OrderPhSpecInstr_"^"_Row_"^"_ColName
					s NewOrderName=$p(^ARCIM(+NewOrderARCIMRowid,$P(NewOrderARCIMRowid,"||",2),1),"^",2)
					s NewOrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",NewOrderName,langid)
					s id=+NewOrderARCIMRowid_"-"_Row_"-"_ColName
					if listJsonDate="" s listJsonDate="{text:'"_NewOrderName_"',id:'"_id_"',value:'"_ConvertOneOrd_"'}"
					else  s listJsonDate=listJsonDate_",{text:'"_NewOrderName_"',id:'"_id_"',value:'"_ConvertOneOrd_"'}"
				}
				s JsonData=JsonData_listJsonDate_"]}"
			}else{
				s NewOrderARCIMRowid=$P(retVal,"^",1)
				s NewOrderDoseQty=$P(retVal,"^",2)
				s ItemCatRowid=$p($g(^ARCIM(+NewOrderARCIMRowid,$p(NewOrderARCIMRowid,"||",2),1)),"^",10)
				if ("^"_AllowEntryDecimalItemCat_"^")'[("^"_ItemCatRowid_"^"){
    				if ((NewOrderDoseQty#1)>0){
	    				s NewOrderDoseQty=NewOrderDoseQty\1+$s(NewOrderDoseQty#1:1,1:0)
	    			}
    			}
				//验证是否满足库存项最小公约数
				s NumStr=##Class(web.DHCDocOrderEntryCM).CheckINCIPackSum(EpisodeID,NewOrderARCIMRowid, OrderRecDepRowid,NewOrderDoseQty,CurLogonHosp)
				if (NumStr'=""){
					s INICrowInfo=$P(NumStr,$C(2),2)
					s minNear=$P(NumStr,$C(2),3)
					s maxNear=$P(NumStr,$C(2),4)
					if (INICrowInfo=""){
						//s NewOrderDoseQty=maxNear
					}
				}
				s ConvertOneOrd=NewOrderARCIMRowid_"^"_NewOrderDoseQty_"^"_OrderPhSpecInstr_"^"_Row_"^"_ColName
				if (ConvertOrderItemStr=""){
					s ConvertOrderItemStr=ConvertOneOrd
				}else{
					s ConvertOrderItemStr=ConvertOrderItemStr_$C(1)_ConvertOneOrd
				}
			}
		}
	}
	if JsonData'="" s JsonData=JsonData_"]}]" q ErrInfo_$C(2)_ConvertOrderItemStr_$C(3)_JsonData
	else  q ErrInfo_$C(2)_ConvertOrderItemStr
}

/// 根据处方号获取是否加急
/// w ##class(web.DHCDocOrderEntryCM).GetPrescEmergency("O190624000023")
ClassMethod GetPrescEmergency(PrescNo As %String) As %String
{
	q:PrescNo="" ""
	s QUE1RowID=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	s PrescEmergency=$P($g(^PAQUE1(QUE1RowID,"DHC")),"^",22)
	Q PrescEmergency
}

}
