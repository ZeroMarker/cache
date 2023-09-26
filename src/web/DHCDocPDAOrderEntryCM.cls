Class web.DHCDocPDAOrderEntryCM Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUpDuration() As %Query(ROWSPEC = "PHCDU_RowId:%String,PHCDU_Desc:%String")
{
}

ClassMethod LookUpDurationExecute(ByRef qHandle As %Binary) As %Status
{
	//草药疗程 ##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpDuration","")
	Set repid=$I(^CacheTemp)
 	s ind=2
 	s defaultRowId=$G(^DHCDocConfig("CNMedDefaultDuration"))
    s rowId=""  f  s rowId=$O(^PHCDU(rowId))  q:rowId=""  d
    .q:rowId=0
    .q:(defaultRowId'="")&&(defaultRowId=rowId)
    .s desc2=$P(^PHCDU(rowId),"^",4)
    .q:desc2'="饮片" 
    .s desc=$P(^PHCDU(rowId),"^",3)_" "_$P(^PHCDU(rowId),"^",2)
    .d OutPutDuration
    
    i defaultRowId'="" d
    .s rowId=defaultRowId
    .s desc2=$P(^PHCDU(rowId),"^",4)
    .q:desc2'="饮片"
    .s desc=$P(^PHCDU(rowId),"^",3)_" "_$P(^PHCDU(rowId),"^",2)
    .s Data=$lb(rowId,desc)
 	.s ^CacheTemp(repid,1)=Data
 	e  d
    .s Data=$lb(0,"")
 	.s ^CacheTemp(repid,1)=Data
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutDuration
	set Data=$lb(rowId,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDurationExecute ]
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

ClassMethod LookUpDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpFrequence() As %Query(ROWSPEC = "PHCFR_RowId:%String,PHCFR_Desc:%String")
{
}

ClassMethod LookUpFrequenceExecute(ByRef qHandle As %Binary) As %Status
{
	//草药频次 ##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpFrequence","")
	Set repid=$I(^CacheTemp)
 	s ind=2
 	s defaultRowId=$G(^DHCDocConfig("CNMedDefaultFrequence"))
    s rowId=""  f  s rowId=$O(^PHCFR(rowId))  q:rowId=""  d
    .q:rowId=0
    .q:(defaultRowId'="")&&(defaultRowId=rowId)
    .s desc2=$P(^PHCFR(rowId),"^",4)
    .q:desc2'="饮片" 
    .s desc=$P(^PHCFR(rowId),"^",3)
    .d OutPutFrequence
    
    i defaultRowId'="" d
    .s rowId=defaultRowId
    .s desc2=$P(^PHCFR(rowId),"^",4)
    .q:desc2'="饮片"
    .s desc=$P(^PHCFR(rowId),"^",3)
    .s Data=$lb(rowId,desc)
 	.s ^CacheTemp(repid,1)=Data
 	e  d
    .s Data=$lb(0,"")
 	.s ^CacheTemp(repid,1)=Data
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutFrequence
	set Data=$lb(rowId,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpFrequenceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpFrequenceExecute ]
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

ClassMethod LookUpFrequenceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpFrequenceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpInstr() As %Query(ROWSPEC = "PHCIN_RowId:%String,PHCIN_Desc:%String")
{
}

ClassMethod LookUpInstrExecute(ByRef qHandle As %Binary) As %Status
{
	//草药用法 ##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpInstr","")
	Set repid=$I(^CacheTemp)
 	s ind=2
 	s defaultRowId=$G(^DHCDocConfig("CNMedDefaultInstruction"))
    s rowId=""  f  s rowId=$O(^PHCIN(rowId))  q:rowId=""  d
    .q:rowId=0
    .q:(defaultRowId'="")&&(defaultRowId=rowId)
    .s desc2=$P(^PHCIN(rowId),"^",3)
    .q:desc2'="饮片" 
    .s desc=$P(^PHCIN(rowId),"^",2)
    .d OutPutInstr
    
    i defaultRowId'="" d
    .s rowId=defaultRowId
    .s desc2=$P(^PHCIN(rowId),"^",3)
    .q:desc2'="饮片"
    .s desc=$P(^PHCIN(rowId),"^",2)
    .s Data=$lb(rowId,desc)
 	.s ^CacheTemp(repid,1)=Data
 	e  d
    .s Data=$lb(0,"")
 	.s ^CacheTemp(repid,1)=Data
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutInstr
	set Data=$lb(rowId,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpInstrExecute ]
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

ClassMethod LookUpInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpCookMode() As %Query(ROWSPEC = "Mode_Code:%String,Mode_Desc:%String")
{
}

ClassMethod LookUpCookModeExecute(ByRef qHandle As %Binary) As %Status
{
	//煎药方式  ##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpCookMode","")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s modeLen=$L(^DHCDocConfig("CNMedCookMode"),"^")
 	f i=1:1:modeLen d
 	.s cookModeStr=$P($G(^DHCDocConfig("CNMedCookMode")),"^",i)
 	.q:cookModeStr=""
 	.s code=$P(cookModeStr,$C(1),1)
 	.q:code=""
 	.s desc=$P(cookModeStr,$C(1),2)
    .d OutPutCookMode
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutCookMode
	set Data=$lb(code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpCookModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCookModeExecute ]
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

ClassMethod LookUpCookModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpCookModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpOrderPrior() As %Query(ROWSPEC = "OECPR_RowId:%String,OECPR_Desc:%String")
{
}

ClassMethod LookUpOrderPriorExecute(ByRef qHandle As %Binary) As %Status
{
	//草药医嘱优先级  ##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpOrderPrior","")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s priorLen=$L(^DHCDocConfig("CNMedPrior"),"^")
 	f i=1:1:priorLen d
 	.s rowId=$P($G(^DHCDocConfig("CNMedPrior")),"^",i)
 	.q:rowId=""
 	.s desc=$P($G(^OECPR(rowId)),"^",2)
 	.q:desc=""
    .d OutPutOrderPrior
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutOrderPrior
	set Data=$lb(rowId,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpOrderPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpOrderPriorExecute ]
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

ClassMethod LookUpOrderPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpOrderPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpCookRecLoc() As %Query(ROWSPEC = "CTLOC_RowId:%String,CTLOC_Desc:%String")
{
}

ClassMethod LookUpCookRecLocExecute(ByRef qHandle As %Binary) As %Status
{
	//代煎接收科室  ##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpCookRecLoc","")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s cookDepLen=$L(^DHCDocConfig("CNMedCookDep"),"^")
 	f i=1:1:cookDepLen d
 	.s rowId=$P($G(^DHCDocConfig("CNMedCookDep")),"^",i)
 	.q:rowId=""
 	.s desc=$P($G(^CTLOC(rowId)),"^",2)
 	.i $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
 	.q:desc=""
    .d OutPutRecLoc
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRecLoc
	set Data=$lb(rowId,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpCookRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCookRecLocExecute ]
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

ClassMethod LookUpCookRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpCookRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpItemInstr() As %Query(ROWSPEC = "Instr_Code:%String,Instr_Desc:%String")
{
}

ClassMethod LookUpItemInstrExecute(ByRef qHandle As %Binary) As %Status
{
	//草药项目的用法  即备注  ##Class(web.DHCNURPDAQUEXCUTE).GetQueryData("web.DHCDocPDAOrderEntryCM:LookUpItemInstr","")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s instrLen=$L($G(^DHCDocConfig("CNMedItemPhSpecInstr")),"^")
 	f i=1:1:instrLen d
 	.s instr=$P($G(^DHCDocConfig("CNMedItemPhSpecInstr")),"^",i)
 	.q:instr=""
 	.s code=$P(instr,$C(1),1)
 	.q:code=""
 	.s desc=$P(instr,$C(1),2)
 	.q:desc=""
    .d OutPutItemInstr
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutItemInstr
	set Data=$lb(code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpItemInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemInstrExecute ]
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

ClassMethod LookUpItemInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpItemInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetCHMItem(para As %Library.String = "") As %Library.String
{
	//取草药医嘱项目的内容 w ##Class(web.DHCDocPDAOrderEntryCM).GetCMItem("gc^100")
	n (para)
	q:(para="")||($P(para,"^")="")||($P(para,"^",2)="") ""
	s QueryName="web.DHCDocPDAOrderEntryCM:LookUpItem"
	Set rset = ##class(%ResultSet).%New(QueryName)
	Set columns = rset.GetColumnCount()

	if $L(para,"^")&(para'="")
	{
		/*Item As %String         ?
		GroupID As %String      ?
		Category As %String
		SubCategory As %String
		TYPE As %String
		LUCategoryDesc As %Library.String
		LUSubCategoryDesc As %Library.String
		EpisodeID As %Library.String
		BillingGrp As %Library.String
		BillingSubGrp As %Library.String
		DateRestriction As %Library.String
		OrdCatGrp As %Library.String
		NonFormulary As %Library.String
		Form As %Library.String
		Strength As %Library.String
		Route As %Library.String*/
		s Item=$P(para,"^",1)
		s GroupID=$P(para,"^",2)
		s CtLocId=$P(para,"^",3)
		s UserCode=$P(para,"^",4)
		s Item=Item_"^"_CtLocId_"^"_UserCode
		s sc = rset.Execute(Item,GroupID)
	}
	s QueryName=$TR(QueryName,":","&")
	s ret=$P(QueryName,"&",2)_"&"
	s i=0
	While(rset.Next()) {
		i (i=0){
			For col = 1:1:columns {
	        	if rset.GetColumnName(col)="ItemData" continue
            	s ret=ret_rset.GetColumnName(col)_"&"
			}
		}
		s coldata=""
		For col = 1:1:columns {
			if rset.GetColumnName(col)="ItemData" continue
			s coldata=coldata_rset.GetData(col)_"^"
		}

		if (i=0){
			s ret=ret_"$"_coldata_"&"
		}else{
			s ret=ret_coldata_"&"
			}
		s i=i+1
		if i>100  q  
	}
	Do rset.Close()
	s qu=$P(QueryName,"&",2)_"&"
	if ret=qu  s ret="-1"
	q ret
}

ClassMethod GetCHMDefaultPara(para As %Library.String = "") As %Library.String
{
	s retStr=""
	s defaultQty=+$G(^DHCDocConfig("CNMedDefaultQty"))
	s appendItem=$G(^DHCDocConfig("CNMedAppendItem"))
	s cookModeFee=^DHCDocConfig("CNMedCookModeFeeItem")
	s retStr=defaultQty_"^"_appendItem_"^"_cookModeFee
	q retStr
}

Query LookUpItem(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, LUCategoryDesc As %Library.String, LUSubCategoryDesc As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, DateRestriction As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,HIDDEN1:%String,HIDDEN2:%String,HIDDEN3:%String,HIDDEN4:%String,HIDDEN5:%String,HIDDEN6:%String,HIDDEN7:%String,HIDDEN8:%String,HIDDEN9:%String,HIDDEN10:%String,HIDDEN11:%String,HIDDEN12:%String,HIDDEN13:%String,HIDDEN14:%String,HIDDEN15:%String,HIDDEN16:%String,SubCategoryDesc:%String,Price:%String,BillUOM:%String,StockQty:%String,PackedQty:%String")
{
}

ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", LUCategoryDesc As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", DateRestriction As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	s index=1
	//s LogonLocID=%session.Get("LOGON.CTLOCID")
	//s LogonUserCode=%session.Get("LOGON.USERCODE")
	s Item=$P(Item,"^")
	s LogonLocID=$P(Item,"^",2)
	s LogonUserCode=$P(Item,"^",3)
	if Category'="" 
	.s CategoryID=$O(^OEC("ORCAT",0,"Desc",Category,0))
	.i CategoryID'="" s Category=CategoryID
	i SubCategory'="" d
	.s SubCategoryID=$O(^ARC("IC",0,"Desc",SubCategory,0))
	.i SubCategoryID'="" s SubCategory=SubCategoryID
	s CMSubCategory=##Class(web.DHCDocConfig).GetConfigNode("CNMedItemCat")
	if CMSubCategory'="" s CMSubCategory="^"_CMSubCategory_"^"
	if (Category'="")&(SubCategory="") d
	.i $$valordcat(GroupID,Category) d
	..s SubCategory=0 f  s SubCategory=$o(^ARC("IC",0,"OrdCat",Category,SubCategory)) q:SubCategory=""  d
	...Q:CMSubCategory'[("^"_SubCategory_"^")
	...set retval=$$open(SubCategory,Item,GroupID)
	...for  s retval=$$fetch(SubCategory,Item,GroupID) q:retval="100"  d
	.... Do OutputRow
	...set retval=$$close()
	e  d
	.set retval=$$open(SubCategory,Item,GroupID)
	.for  s retval=$$fetch(SubCategory,Item,GroupID) q:retval="100"  d
 .. Do OutputRow
	.set retval=$$close()
	Set QHandle=$lb(0,repid,0)
 Quit $$$OK
open(CATEG,TEXT,user) 
	k ^TMP($zn,$j)
	;;s ^zleon($zn,"o")=CATEG_"^"_TEXT_"^"_user
	s TEXT=$g(TEXT),CATEG=$g(CATEG)
	s TEXT1=$ZCVT(TEXT,"U")
	s TEXT=$ZCVT(TEXT,"U")
	;
	s DESC=0,ROW=0,TEXT0=TEXT 
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
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
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
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it3
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it3
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 i CMSubCategory'[("^"_subCATEG_"^") g it3
	 i '$$valord(user,subCATEG,type,ROW1) g it3
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
	 i CMSubCategory'[("^"_subCATEG_"^") g it31
	 i '$$valord(user,subCATEG,type,ROW1) g it31
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
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_BillingUOM_DR->CTUOM_Desc 
	   INTO :rowid,:desc,:code,:code1,:code2,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatcode,:ordcatid,:oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,:generic,:subcatdesc,:billuom
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:RowID)
	i 'SQLCODE d adjust1
	q SQLCODE
	;
adjust1	;
	;s cost=$p($g(cost),$c(1)) s:cost="" cost="N"
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_$p(code,$c(1))_$c(2)_$p(code1,$c(1))_$c(2)_$p(code2,$c(1))_$c(2)_$p(rice,$c(1))_$c(2)_ricedes_$c(2)_$p(cons,$c(1))_$c(2)_consdes_$c(2)_categ_$c(2)_subcat_$c(2)_$p(mealt,$c(1))_$c(2)_mealtdes_$c(2)_cost_$c(2)_inssubcat_$c(2)_prior_$c(2)_priordesc_$c(2)_$p($g(^ARC("IC",+subcat)),"^",15)_$c(2)_arcimcode
	;s PLIST=$o(PLIST(""),-1)
	s ItemPrice=0
	s StockQty=""
	s PackedQty=""
	s rowid=$p(rowid,$c(1))
	s SttDate=+$H
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, rowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	s ItemPrice=$fn($P(retPrice,"^",1),"",4)
	i (subcatcode="R")&(EpisodeID'="") d
	.s ret=##class(web.DHCDocOrderEntry).GetStockQty(EpisodeID,rowid)
	.s StockQty=$P(ret,"^",1)
	.s PackedQty=$P(ret,"^",2)
	s generic=""
	s desc=flag_desc
	s Data=$lb(desc,rowid,$p(phfreqcode,$c(1)),type,TEXT0,subcatcode,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,phuomdesc,$p(phdurrowid,$C(1)),generic,"","","",subcatdesc,ItemPrice,billuom,StockQty,PackedQty)
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
	s Data=$lb(desc,rowid,"",type,TEXT0,"",$p(ordcatid,$C(1)),"","","","","","","",OSItemIDs,"","",subcatdesc,OSPrice,"","","")
	q
	;
valord(user,subCATEG,type,ROW1) ;validate usergroup and CATEGory
	 ;1-valid,0-invalid
	 n (UserCat,user,subCATEG,type,ROW1)
	 s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	 Q:'user 1
	 i '$d(UserCat(+CATEG)) q 0
	 s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2),subcat=$p(s,"^",3)
	 Q:(subcat'="")&&(("!"_subcat_"!")'[("!"_subCATEG_"!")) 0
	 i type="ARCOS",os'="Y" Q 0
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",vis'="Y" q 0
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" Q 0
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
	do ##class(web.DHCDocOrderEntry).OpenGetAllOrderSetItem(ARCOSRowid)
	s n=0,ARCOSPrice=0
	s OSItemIDs=""
	s SttDate=+$h
	s PatType="",InsType="",PriorRowid="",InstrRowid="",LinkTo="",OEPrice=""
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
	..s ARCIMRowid=$p(s,"^",1)
 ..s ARCOSItemQty=$p(s,"^",2)
 ..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	..s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",4)
 ..s n=n+1
 ..i n=1  s OSItemIDs=ARCIMRowid_$C(14)_ARCIMDesc
 ..e  s OSItemIDs=OSItemIDs_$C(12)_ARCIMRowid_$C(14)_ARCIMDesc
 i OSItemIDs'="" s OSItemIDs=OSItemIDs_$C(4)_ARCOSPrice
 q OSItemIDs
OutputRow
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariables
	quit
}

ClassMethod LookUpItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		Set Row=^CacheTemp(repid,ind)
	}
	
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SaveOrderItemsCM(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String) As %String
{
	///审核医嘱
	i Doc="" s Doc=$P($G(^SSU("SSUSR",User)),"^",14)
	q:Doc="" "医嘱录入人非医护人员"
	s retStr=##Class(web.DHCOEOrdItem).SaveOrderItemsCM(Adm,OrdItemStr,User,Loc,Doc)
	i retStr'=0 s retStr="医嘱插入失败"
	q retStr
}

}
