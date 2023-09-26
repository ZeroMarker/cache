Class DHCDoc.DHCDocConfig.Items Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 查询医嘱大类
Query GetCategoryList(HospId As %String = "") As %Query(ROWSPEC = "ORCATRowId:%String,ORCATDesc:%String")
{
}

ClassMethod GetCategoryListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetCategoryList")
	Set repid=$I(^CacheTemp)
    Set ind=1 
    s ORCATRowId=0 f  s ORCATRowId=$o(^OEC("ORCAT",ORCATRowId)) q:ORCATRowId=""  d
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("OEC_OrderCategory",ORCATRowId,HospId)="N"
    .s ORCATDesc=$p(^OEC("ORCAT",ORCATRowId),"^",2)
	.Do OutputRowGetCategoryList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCategoryList
	set Data=$lb($g(ORCATRowId),$g(ORCATDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCategoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCategoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryListExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 根据医嘱大类查询医嘱子类
Query GetOrdCategoryList(ORCATRowId As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String")
{
}

ClassMethod GetOrdCategoryListExecute(ByRef qHandle As %Binary, ORCATRowId As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetOrdCategoryList")
	Set repid=$I(^CacheTemp)
    Set ind=1  
    s ARCICRowId=0 f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
    .s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
    .s ARCICOrdCatDR=$p(^ARC("IC",ARCICRowId),"^",8)
    .q:(ORCATRowId'="")&&(ARCICOrdCatDR'=ORCATRowId)
	.Do OutputRowGetOrdCategoryList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetOrdCategoryList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetOrdCategoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdCategoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdCategoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdCategoryListExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 查询医嘱项
Query GetItemList(Item As %String = "", ARCICRowId As %String = "", HospId As %String = "", ORCATRowId As %String = "") As %Query(ROWSPEC = "ARCIMRowID:%String,ARCIMDesc:%String,ARCIMType:%String,ARCICDesc:%String,ORCATDesc:%String")
{
}

ClassMethod GetItemListExecute(ByRef qHandle As %Binary, Item As %String = "", ARCICRowId As %String = "", HospId As %String = "", ORCATRowId As %String = "") As %Status
{
	s ^tmpscl("GetItemList")=Item_","_ARCICRowId
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetItemList","","",5,"")
	Set repid=$I(^CacheTemp)
    Set ind=1  
    if (Item'="")||(ARCICRowId'="")||(ORCATRowId'=""){
		k ^TempARCIMRowIDStr("GetItemList",$j) 
		//#dim rs As %ResultSet
		s rs1= 	##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
		s GroupID=%session.Data("LOGON.GROUPID") 
		d rs1.Execute(Item,GroupID,ORCATRowId,ARCICRowId,"","","","","","",%session.Data("LOGON.USERID"),"","",""_$c(3)_HospId,"","^1")
		while(rs1.Next()){
			s ARCIMDesc=rs1.GetData(1)
			s ARCIMRowID = rs1.GetData(2)
			s ARCIMType=rs1.GetData(4)
			continue:ARCIMRowID=""
			//continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowID,HospId)="N"
			continue:$d(^TempARCIMRowIDStr("GetItemList",$j,ARCIMRowID))
			s ^TempARCIMRowIDStr("GetItemList",$j,ARCIMRowID)=1
	        if (ARCIMType="ARCIM"){
		        s ARCIMType1="医嘱项"
		        s ARCIMItemCatDR=$p($g(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1)),"^",10)
		    }elseif(ARCIMType="ARCOS"){
			    s ARCIMType1="医嘱套"
			    s ARCIMItemCatDR=$p(^ARCOS(ARCIMRowID),"^",9)
			}
			s ARCICDesc=$p(^ARC("IC",ARCIMItemCatDR),"^",2)
			s ARCICOrdCatDR=$p(^ARC("IC",ARCIMItemCatDR),"^",8)
	        s ORCATDesc=$p(^OEC("ORCAT",ARCICOrdCatDR),"^",2)
			d OutputRowGetItemList
		}
		k ^TempARCIMRowIDStr("GetItemList",$j)
		d rs1.%Close()
    }else{
	    s ARCIMType1="医嘱项"
		s ARCIMRowID=0
		for{
			s ARCIMRowID=$o(^DHCItmMastAdd("0","ARCIM",HospId,ARCIMRowID))
			q:(ARCIMRowID="")
			//continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowID,HospId)="N"
			s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1)),"^",2)
		    s ARCIMItemCatDR=$p($g(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1)),"^",10)
		    s ARCICDesc=$p(^ARC("IC",ARCIMItemCatDR),"^",2)
			s ARCICOrdCatDR=$p(^ARC("IC",ARCIMItemCatDR),"^",8)
	        s ORCATDesc=$p(^OEC("ORCAT",ARCICOrdCatDR),"^",2)
			d OutputRowGetItemList
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetItemList
	set Data=$lb($g(ARCIMRowID),$g(ARCIMDesc),$g(ARCIMType1),$g(ARCICDesc),$g(ORCATDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemListExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 根据医嘱项查询绑定的医嘱项目
Query GetAppendItemList(ARCIMRowId As %String, HospId As %String = "") As %Query(ROWSPEC = "DHCIARowid:%String,AddItmDR:%String,AddItmDesc:%String,DHCIAQty:%String,DHCIALoc:%String,DHCIALocId:%String,DHCIARecLoc:%String,DHCIARecLocId:%String,DHCIAInstrId:%String,DHCIAInstr:%String,Dose:%String,DoseUomDR:%String,DoseUom:%String,SPECCode:%String,SPECDesc:%String,CalByBindOrdQty:%String,LimitMaxAge:%String,LimitSamllAge:%String,LimitAdmType:%String")
{
}

ClassMethod GetAppendItemListExecute(ByRef qHandle As %Binary, ARCIMRowId As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetAppendItemList",312)
	Set repid=$I(^CacheTemp)
    Set ind=1  
    if (ARCIMRowId=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
    s DHCIARowid=0  f  s DHCIARowid=$o(^DHCItmMastAdd("0","ARCIM",HospId,ARCIMRowId,DHCIARowid)) q:DHCIARowid=""  d
    .s AddItmDR=$p(^DHCItmMastAdd(DHCIARowid),"^",2)
    .//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",AddItmDR,HospId)="N"
    .s AddItmDesc=$p(^ARCIM(+AddItmDR,$p(AddItmDR,"||",2),1),"^",2)
    .s DHCIAQty=$p(^DHCItmMastAdd(DHCIARowid),"^",3)
    .s LocId=$p(^DHCItmMastAdd(DHCIARowid),"^",4)
    .s RecLocId=$p(^DHCItmMastAdd(DHCIARowid),"^",5)
    .s DHCIAInstrId=$p(^DHCItmMastAdd(DHCIARowid),"^",6)
    .s DHCIAInstr=""
    .i DHCIAInstrId'="" s DHCIAInstr=$p($g(^PHCIN(DHCIAInstrId)),"^",2)
    .s LocDesc=""
    .if LocId'="" do
    ..s LocDesc=$p(^CTLOC(LocId),"^",2)
    .s RecLocDesc=""
    .if RecLocId'="" do
    ..s RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
    .s DHCIADoseQty=$p(^DHCItmMastAdd(DHCIARowid),"^",8)
    .s DoseUom=""
    .s DHCIADoseUomDR=$p(^DHCItmMastAdd(DHCIARowid),"^",9)
    .if (DHCIADoseUomDR'="") s DoseUom=$p($g(^CT("UOM",DHCIADoseUomDR)),"^",2)
    .s DHCIASpecCode=$p(^DHCItmMastAdd(DHCIARowid),"^",10)
    .s SPECDesc=""
    .s OrderLabSpec=##class(web.DHCDocOrderCommon).GetLabSpec(AddItmDR,HospId)
	.for i=1:1:$L(OrderLabSpec,$C(2)) d
    ..s ArrData=$p(OrderLabSpec,$C(2),i)
    ..s SPECCode = $p(ArrData,$C(3),1)
    ..if (DHCIASpecCode=SPECCode) s SPECDesc = $p(ArrData,$C(3),2) Q
	.s CalByBindOrdQty=$p(^DHCItmMastAdd(DHCIARowid),"^",11)
	.s LimitMaxAge=$p(^DHCItmMastAdd(DHCIARowid),"^",12)
	.s LimitSamllAge=$p(^DHCItmMastAdd(DHCIARowid),"^",13)
	.s LimitAdmType=$p(^DHCItmMastAdd(DHCIARowid),"^",14)
	.s LimitAdmType=$replace(LimitAdmType,"O","门诊")
	.s LimitAdmType=$replace(LimitAdmType,"I","住院")
	.s LimitAdmType=$replace(LimitAdmType,"E","急诊")
	.s LimitAdmType=$replace(LimitAdmType,"H","体检")
	.s LimitAdmType=$replace(LimitAdmType,"N","新生儿")
    .d OutputRowGetAppendItemList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAppendItemList
	set Data=$lb($g(DHCIARowid),$g(AddItmDR),$g(AddItmDesc),$g(DHCIAQty),LocDesc,LocId,RecLocDesc,RecLocId,DHCIAInstrId,DHCIAInstr,DHCIADoseQty,DHCIADoseUomDR,$g(DoseUom),DHCIASpecCode,$g(SPECDesc),CalByBindOrdQty,LimitMaxAge,LimitSamllAge,LimitAdmType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAppendItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendItemListExecute ]
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

/// w ##class(DHCDoc.DHCDocConfig.Items).saveAppendItem("","74||1","3738||1","1","","","","^^^N^50^3^O,I","2") 
ClassMethod saveAppendItem(Rowid As %String = "", ARCIMRowID As %String = "", AddARCIMRowID As %String = "", OrdQty As %String = "", LocId As %String = "", RecLocId As %String = "", DHCIAInstrId As %String = "", ExpStr As %String = "", HospId As %String = "") As %String
{
	S ^tempsaveAppendItem=$lb(Rowid , ARCIMRowID , AddARCIMRowID , OrdQty , LocId , RecLocId , DHCIAInstrId , ExpStr , HospId)
	S HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s arcimcode=""
	&sql(select ARCIM_Code into :arcimcode from SQLUSER.arc_itmmast where ARCIM_RowId=:AddARCIMRowID)
	q:arcimcode="" "-2"
	s find=..FindAppendItem(Rowid,ARCIMRowID,AddARCIMRowID,LocId,HospId)
	if (find'=""){
		Quit -1	
	}
	s Dose=$p(ExpStr,"^",1)
	s DoseUomDR=$p(ExpStr,"^",2)
	s SPECCode=$p(ExpStr,"^",3)
	s CalByBindOrdQty=$p(ExpStr,"^",4)
	s LimitMaxAge=$p(ExpStr,"^",5)
	s LimitSamllAge=$p(ExpStr,"^",6)
	s LimitAdmType=$p(ExpStr,"^",7)
	s LimitAdmType=$replace(LimitAdmType,"门诊","O")
	s LimitAdmType=$replace(LimitAdmType,"住院","I")
	s LimitAdmType=$replace(LimitAdmType,"急诊","E")
	s LimitAdmType=$replace(LimitAdmType,"体检","H")
	s LimitAdmType=$replace(LimitAdmType,"新生儿","N")
	if (Rowid=""){
		&sql(insert into SQLUSER.DHC_ItmAdd (DHCIA_Itm_DR,DHCIA_AddItm_DR,DHCIA_Qty,DHCIA_Loc_DR,
		DHCIA_RecLoc_DR,DHCIA_Instr_DR,DHCIA_Hosp_DR,
		DHCIA_DoseQty,DHCIA_DoseUom_DR,DHCIA_SpecCode,DHCIA_CalByBindOrdQty,DHCIA_LimitMaxAge,
		DHCIA_LimitSmallAge,DHCIA_LimitAdmType)values 
			(:ARCIMRowID,:AddARCIMRowID,:OrdQty,:LocId,:RecLocId,:DHCIAInstrId,:HospId,
			:Dose,:DoseUomDR,:SPECCode,
			:CalByBindOrdQty,:LimitMaxAge,:LimitSamllAge,:LimitAdmType))
	}else{
		&sql(update SQLUSER.DHC_ItmAdd set DHCIA_AddItm_DR=:AddARCIMRowID,DHCIA_Qty=:OrdQty,
		DHCIA_Loc_DR=:LocId,DHCIA_RecLoc_DR=:RecLocId,DHCIA_Instr_DR=:DHCIAInstrId,DHCIA_DoseQty=:Dose,
		DHCIA_DoseUom_DR=:DoseUomDR,DHCIA_SpecCode=:SPECCode,
		DHCIA_CalByBindOrdQty=:CalByBindOrdQty ,DHCIA_LimitMaxAge=:LimitMaxAge,
		DHCIA_LimitSmallAge=:LimitSamllAge,DHCIA_LimitAdmType=:LimitAdmType
		where DHCIA_Rowid=:Rowid )
	}
	q SQLCODE
}

ClassMethod deleteAppendItem(Rowid As %String) As %String
{
	&sql(delete SQLUSER.DHC_ItmAdd where DHCIA_Rowid=:Rowid)
	q SQLCODE
}

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->附加医嘱设定 根据医嘱项查询别名
Query GetAliasByArcim(ARCIMRowId As %String) As %Query(ROWSPEC = "ALIASRowId:%String,ALIASText:%String,selected")
{
}

ClassMethod GetAliasByArcimExecute(ByRef qHandle As %Binary, ARCIMRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Items","GetAliasByArcim",312)
	Set repid=$I(^CacheTemp)
    Set ind=1  
    if ($l(ARCIMRowId,"||")=2) d
    .s ALIASRowId=0 f  s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId)) q:ALIASRowId=""  d
    ..d GetAlias(ALIASRowId)
    else  d
    .s ALIASRowId=0 f  s ALIASRowId=$o(^ARC("ALIAS",0,"ARCOS",ARCIMRowId,ALIASRowId)) q:ALIASRowId=""  d
    ..d GetAlias(ALIASRowId)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAliasByArcim
	set Data=$lb($g(ALIASRowId),$g(ALIASText),selected)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
GetAlias(ALIASRowId)
   s ALIASText=$p(^ARC("ALIAS",ALIASRowId),"^",6)
   s ALIASDateFrom=$p(^ARC("ALIAS",ALIASRowId),"^",12)
   s ALIASDateTo=$p(^ARC("ALIAS",ALIASRowId),"^",13)
   q:(ALIASDateFrom'="")&&(ALIASDateFrom>+$h)
   q:(ALIASDateTo'="")&&(ALIASDateTo<=..%SysDate())
   s selected=0
   Do OutputRowGetAliasByArcim
}

ClassMethod GetAliasByArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasByArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAliasByArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasByArcimExecute ]
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

ClassMethod FindAppendItem(Rowid As %String, ArcimId As %String, AddArcimId As %String, LocId As %String, HospId As %String)
{
	s DHCIARowid=""
	s Id=0
	for  s Id=$o(^DHCItmMastAdd("0","ARCIM",HospId,ArcimId,Id)) Quit:Id=""  do
	.s AddArcimRowid=$p(^DHCItmMastAdd(Id),"^",2)
	.s LocRowid=$p(^DHCItmMastAdd(Id),"^",4)
	.s RecLocRowid=$p(^DHCItmMastAdd(Id),"^",5)
	.Quit:(Id=Rowid)&&(Rowid'="")
	.if (AddArcimId=AddArcimRowid)&&(LocRowid=LocId) s DHCIARowid=Id  //||(LocRowid="")
	
	Quit DHCIARowid
}

/// @附加医嘱设定(按医嘱),绑定医嘱指定了科室，则按照指定科室医嘱产生，未指定的则按未指定科室产生绑定医嘱
/// @ArcimId 医嘱项ID UserLoc开单科室ID
/// return 绑定医嘱串
/// w ##class(DHCDoc.DHCDocConfig.Items).GetItmAddItem("1811||1","")
ClassMethod GetItmAddItem(ARCIMRowid As %String, UserLoc As %String, OrderOpenForAllHosp As %String = "", HospId As %String = "", Adm As %String = "") As %String
{
	  i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	  s UserLocAppendItemStr="",AllLocAppendItemStr=""
	  s DHCIARowid=0
	  For {
			s DHCIARowid=$o(^DHCItmMastAdd("0","ARCIM",HospId,ARCIMRowid,DHCIARowid)) q:DHCIARowid=""
			s DHCIAAddItmDR=$p(^DHCItmMastAdd(DHCIARowid) ,"^",2)
			//continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",DHCIAAddItmDR,HospId)="N"
			s DHCIAQty=$p(^DHCItmMastAdd(DHCIARowid) ,"^",3)
			i (+DHCIAQty=0) s DHCIAQty=1
			s DHCIALocId=$p(^DHCItmMastAdd(DHCIARowid) ,"^",4)
			s DHCIARecLocId=$p(^DHCItmMastAdd(DHCIARowid) ,"^",5)
			s DHCIAInstrId=$p(^DHCItmMastAdd(DHCIARowid) ,"^",6)
			s DHCIADoseQty=$p(^DHCItmMastAdd(DHCIARowid),"^",8)
		    s DHCIADoseUomDR=$p(^DHCItmMastAdd(DHCIARowid),"^",9)
		    s DHCIASpecCode=$p(^DHCItmMastAdd(DHCIARowid),"^",10)
			s CalByBindOrdQty=$p(^DHCItmMastAdd(DHCIARowid),"^",11)
			if (Adm'=""){
				s PatDr=$p($g(^PAADM(Adm)),"^",1)
				Set Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatDr,Adm,HospId)
				if (Age["岁"){s Age=$P(Age,"岁",1)}else{s Age=0}
				s LimitMaxAge=$p(^DHCItmMastAdd(DHCIARowid),"^",12)
				s LimitSamllAge=$p(^DHCItmMastAdd(DHCIARowid),"^",13)
				s LimitAdmType=$p(^DHCItmMastAdd(DHCIARowid),"^",14)
				if (LimitMaxAge'="")&&(Age>LimitMaxAge) continue
				if (LimitSamllAge'="")&&(Age<LimitSamllAge) continue
				Set PAAdmType=$P($g(^PAADM(Adm)),"^",2)
				if (LimitAdmType'="")&&(LimitAdmType[PAAdmType) continue
				}
			s oneInfo=DHCIAAddItmDR_$C(1)_DHCIAQty_$c(1)_DHCIARecLocId_$C(1)_DHCIAInstrId_$C(1)_OrderOpenForAllHosp_$C(1)_""_$C(1)_DHCIADoseQty_$C(1)_DHCIADoseUomDR_$C(1)_DHCIASpecCode_$C(1)_"IT"
			s $P(oneInfo,$C(1),13)=CalByBindOrdQty
			if (DHCIALocId=UserLoc){
				i UserLocAppendItemStr="" s UserLocAppendItemStr=oneInfo
				e  s UserLocAppendItemStr=UserLocAppendItemStr_"^"_oneInfo
			}else{
				if (DHCIALocId=""){
					i AllLocAppendItemStr="" s AllLocAppendItemStr=oneInfo
					e  s AllLocAppendItemStr=AllLocAppendItemStr_"^"_oneInfo
				}
			}
	   }
	   Q:UserLocAppendItemStr'="" UserLocAppendItemStr
	   Q AllLocAppendItemStr
}

Query FindItem(Alias As %String, HospId As %String = "") As websys.Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String")
{
}

ClassMethod FindItemExecute(ByRef qHandle As %Binary, Alias As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (Alias=""){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	Set rs2=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.ArcItemConfig:FindAllItem")
	d rs2.Execute(Alias,"","","","","","",HospId)
	while(rs2.Next()){
		s ArcimID = rs2.GetData(1)
		continue:ArcimID=""
		s ArcimDesc=rs2.GetData(2)
		continue:##class(web.DHCDocOrderCommon).IsCNMedItem(ArcimID)=1
		d OutputRowFindItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindItem
	Set Data=$lb(ArcimID,ArcimDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

Query FindSpecList(ArcimRowid As %String, HospId As %String = "") As websys.Query(ROWSPEC = "SPECCode:%String,SPECDesc:%String,SPECdefault:%String")
{
}

ClassMethod FindSpecListExecute(ByRef qHandle As %Binary, ArcimRowid As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (ArcimRowid="") {
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s OrderLabSpec=##class(web.DHCDocOrderCommon).GetLabSpec(ArcimRowid,HospId)
	for i=1:1:$L(OrderLabSpec,$C(2)){
        s ArrData=$p(OrderLabSpec,$C(2),i)
        continue:ArrData=""
        s SPECCode = $p(ArrData,$C(3),1)
        s SPECDesc = $p(ArrData,$C(3),2)
         s default = $p(ArrData,$C(3),5)
        d OutputSpecList
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSpecList
	Set Data=$lb(SPECCode,SPECDesc,default)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

}
