Class web.DHCMRDiagnosNew Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 新版诊断录入所用方法

// 查询本次诊断列表

Query DiagnosList(MRADMID As %String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", LogonCTLocRowId As %String = "") As %Query(ROWSPEC = "DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate:%String,DiagStat:%String,DiagnosLeavel:%String,DiagnosCat:%String,MRDIAMRDIADR:%String,NCDCode:%String,NCDInfo:%String,DiagPRowId:%String")
{
}

ClassMethod DiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DiagnosListExecute(ByRef qHandle As %Binary, MRADMID As %String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", LogonCTLocRowId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCMRDiagnosNew","DiagnosList","634",,,63)
	s ^tmptan("DiagnosListExecute")=MRADMID_","_ICDType_","_DiagnosTypeCode_","_LogonCTLocRowId
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if MRADMID="" {  
	    d ResetVariables1
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",$J)
	
	s defaultDiagnosTypeID=""
	if DiagnosTypeCode'="" {
		s defaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code",DiagnosTypeCode,0))
	}
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s DiagPRowId=$o(^MRi("DIAGP",Rowid,""))
	.i DiagPRowId'="" s Desc=..GetDiagFormateDesc(DiagPRowId)
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S MRdiagnosNoteDr=""
	.S MRdiagnosNoteDesc=""
	.s MRdiagnosNoteSubRowid=""
	.S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	.if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
	.Q:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
	.I MRdiagnosNoteSubRowid'="" Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
	.S MRDiagnosDate=obj.Data("MRDIADate")
	.s MRdiagnosTime=obj.Data("MRDIATime")
	.s MRAddLocDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
	.s MRDIAMRDIADR=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",15)
	.;Q:(LogonCTLocRowId'=MRAddLocDr)&&(ICDType'="All")&&(LogonCTLocRowId'="")
	.I MRDiagnosDate'="" Set MRDiagnosDate=..%ZD(MRDiagnosDate) //$zd(MRDiagnosDate,3)
	.I MRdiagnosTime'="" Set MRdiagnosTime=..%ZT(MRdiagnosTime,3)
	.s BillFlag1="" 
	.s BillFlag3=""
	.s DiagnosCat=""
	.i CodeRowid'="" d
	..s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
	..s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
	..
	..i BillFlag3'="Y" d
	...s DiagnosCat="西医"
	..else  if (BillFlag3="Y")&&(BillFlag1'="Y") d
	...s DiagnosCat="中医"
	..else  d
	...s DiagnosCat="证候"
	.e  d
	..s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
	..i Questionnaire=1 d
	...s DiagnosCat="西医"
	..else  if (Questionnaire=2) d
	...s DiagnosCat="中医"
	..else  if (Questionnaire=3) d
	...s DiagnosCat="证候"
	.Q:(ICDType="1")&&(BillFlag3'="Y")
	.;Q:(ICDType="0")&&(BillFlag3="Y")
	.;Q:(ICDType="1")&&((BillFlag3'="Y")||(BillFlag1="Y"))
	.;Q:(ICDType="2")&&((BillFlag3'="Y")||(BillFlag1'="Y"))
	.
	.//Q:(ICDType'="1")&&(BillFlag3="Y")
	.s MainDiagFlag=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
	.i MainDiagFlag="Y" s MainDiagFlag=" (主)"
	.e  s MainDiagFlag=""
	.//i MainDiagFlag'="" s MRDiagnosTypeDesc=MRDiagnosTypeDesc_MainDiagFlag
	.s MRDesc=obj.Data("MRDIADesc")
	.if (MRDesc'="")&&($$$ISOK($LV(MRDesc))) s MRDesc=$ListToString(MRDesc,"、")
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
	.s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
	.s:DIAOnsetDate'="" DIAOnsetDate=..%ZD(DIAOnsetDate) //$zd(DIAOnsetDate,3) //取发病日期
	.if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
	.if DiagnosNumber="" s DiagnosNumber=$g(^MR(3,"DIA",0))+1
	.;tanjishan 慢病
	.s NCDCode=$p($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DHC")),"^",10)
	.s NCDDesc=..GetNCDDesc(NCDCode)
	.;end
	.;描述有反斜杠会影响前台
	.s MRDesc=$replace(MRDesc,"\","")
	.s banlkSpace="" f i=1:1:(+DiagnosLeavel-1) s banlkSpace=banlkSpace_"&nbsp&nbsp&nbsp&nbsp" ;根椐级别加空格
    .s Desc=banlkSpace_Desc
	.i MainDiagFlag'="" s Desc=Desc_MainDiagFlag
	.s Desc=##class(web.DHCDocUtil).EvalJSON(Desc)
	.s TempArr("FindDiagnos",$j,DiagnosNumber,$P(Rowid,"||",2))=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_MRDIAMRDIADR_"^"_NCDCode_"^"_NCDDesc_"^"_DiagPRowId
	d obj.Close()
	
	//按顺序输出设置
	s TempDia=""
	s DiagnosNumber=0  f  {
		s DiagnosNumber=$O(TempArr("FindDiagnos",$j,DiagnosNumber)) 
		Q:DiagnosNumber=""  d
		s Temprowid=0 f {
			s Temprowid=$O(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid))
			q:Temprowid=""
			s DiagnosDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",1)
			s DiagnosValue=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",2)
			s DiagnosCodeRowid=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",3)
			s DiagnosMRDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",4)
			s DiagnosICDCode=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",5)
			s DiagnosType=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",6)
			s DiagnosNote=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",7)
			s DiagnosDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",8)
			s DiagnosOnsetDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",13)
			s DiagnosLeavel=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",11)
			s DiagStat=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",10)
			s DiagnosCat=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",14)
			s MRDIAMRDIADR=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",15)
			
			s NCDCode=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",16)
			s NCDDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",17)
			s DiagPRowId=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",18)
			Do OutputRow1
		}
	}
	k TempArr("FindDiagnos",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate
 //ICD描述 诊断表ID ICD诊断ID 诊断注释 ICDCode 诊断类型 诊断注释 日期 发病日期
OutputRow1
	set Data=$lb(DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,DiagnosCat,MRDIAMRDIADR,NCDCode,NCDDesc,DiagPRowId)  //
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit
ResetVariables1
	set (DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosNote,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,DiagnosCat,MRDIAMRDIADR,NCDCode,NCDDesc,DiagPRowId)=""
	quit
}

ClassMethod GetDiagPropertyShow(DiagPRowId As %String) As %String
{
	s DiagBaseCatPDr=$p($g(^MR("DIAGP",DiagPRowId)),"^",2)
	Q:DiagBaseCatPDr="" ""
	s DKBBCDiaDr=$p($g(^DKBBASCAT(DiagBaseCatPDr)),"^",5)
	Q:DKBBCDiaDr="" ""  //诊断术语表DKB_Diagnosis ID
	s DiagPropertyShow=##class(web.DHCBL.MKB.DKBBaseCat).GetDoctorInfo(DKBBCDiaDr)
	Q DiagPropertyShow
}

// w ##class(web.DHCMRDiagnosNew).GetDiagFormateDesc(1,14703,"1894"_$c(1)_"T^1895"_$c(1)_"C")

// , DKBBCRowId As %String, ChildPropertyIdStr As %String

ClassMethod GetDiagFormateDesc(DiagPRowId As %String) As %String
{
	s DKBBCDiaDr=##class(web.DHCMRDiagnos).GetDKBDiagRowId(DiagPRowId) //诊断术语Id
	Q:DKBBCDiaDr="" "" 
	s DKBDicRowId=$o(^TKBTRECOMi(0,"Tre","C",DKBBCDiaDr,"")) //$o(^DKBDGSCOM(0,"Dia",DKBBCDiaDr,"C","")) //诊断术语对应常用名ID
	Q:DKBDicRowId="" ""
	s DKBDicDesc=$p($g(^TKBTRECOM(DKBDicRowId)),"^",3) //$p($g(^DKBDGSCOM(DKBDicRowId)),"^",3) //常用名描述
	s DiagnosDisPlayName=$p($g(^MR("DIAGP",DiagPRowId)),"^",10)
	if (DiagnosDisPlayName'="") s DKBDicDesc=DiagnosDisPlayName
	s Rtn=##class(web.DHCBL.MKB.TKBTremExtend).GetDoctorInfoStr(DKBBCDiaDr)
	q:Rtn="" ""
	s ChildPropertyIdStr=$p(Rtn,"^",3)
	Q:ChildPropertyIdStr="" DKBDicDesc
	s PropertyDesc=""
	s TreeCheckedIdStr=$p($g(^MR("DIAGP",DiagPRowId)),"^",3)
	s ComboCheckedIdStr=$p($g(^MR("DIAGP",DiagPRowId)),"^",4)
	s RadioCheckedIdStr=$p($g(^MR("DIAGP",DiagPRowId)),"^",7)
	s CheckBoxCheckedIdStr=$p($g(^MR("DIAGP",DiagPRowId)),"^",8)
	s DiagDisplayNameStr=""
	For i=1:1:$l(ChildPropertyIdStr,$c(1)){
		s OneChildPropertyStr=$p(ChildPropertyIdStr,$c(1),i)
		s OneChildPropertyId=$p(OneChildPropertyStr,$c(2),1)
		s OnechildDesc=$p(OneChildPropertyStr,$c(2),2)
		s OneChildType=$p(OneChildPropertyStr,$c(2),3)
		s OneshowType=$p(OneChildPropertyStr,$c(2),4)
		s DiagDiplayFlag=$p(OneChildPropertyStr,$c(2),5)
		continue:DiagDiplayFlag="Y"
		i DiagDisplayNameStr="" s DiagDisplayNameStr=OnechildDesc
		e  s DiagDisplayNameStr=DiagDisplayNameStr_","_OnechildDesc
		if (OneChildType="S"){
			if (OneshowType="T") s SourseTreeIds=##class(web.DHCBL.MKB.TKBTrem).GetSourseTreeIds("", OneChildPropertyId)
			else  s DocSourseIds=##class(web.DHCBL.MKB.TKBTrem).GetDocSourseIds(OneChildPropertyId)
			s TKBTEDATSOU=$p(^TKBTREEXT(OneChildPropertyId),"^",4)
			if (OneshowType="T")&&(TreeCheckedIdStr'=""){
				s onePropertyDesc=""
				for k=1:1:$l(TreeCheckedIdStr,"$"){
					s oneId=$p(TreeCheckedIdStr,"$",k)
					continue:oneId=""
					if ($d(^TKBTREMi(0,"Base",TKBTEDATSOU,oneId))&&(("^"_SourseTreeIds_"^")[("^"_oneId_"^"))){
						s desc=$p(^TKBTREM(oneId),"^",2)
						s parentNodeId=$p(^TKBTREM(oneId),"^",4)
						if (parentNodeId="") { s del="," }
						else {
							s del="."
						}
						if (onePropertyDesc="") s onePropertyDesc=desc
						else  s onePropertyDesc=onePropertyDesc_del_desc
					}
				}
				if (PropertyDesc="") s PropertyDesc=onePropertyDesc
				else  s PropertyDesc=PropertyDesc_","_onePropertyDesc
			}
			if (OneshowType="C")&&(ComboCheckedIdStr'=""){
				for k=1:1:$l(ComboCheckedIdStr,"$"){
					s oneId=$p(ComboCheckedIdStr,"$",k)
					continue:oneId=""
					if ($d(^TKBTREMi(0,"Base",TKBTEDATSOU,oneId))&&(("^"_DocSourseIds_"^")[("^"_oneId_"^"))){
						s desc=$p(^TKBTREM(oneId),"^",2)
						if (PropertyDesc="") s PropertyDesc=desc
						else  s PropertyDesc=PropertyDesc_","_desc
					}
				}
			}
			if (OneshowType="CB")&&(RadioCheckedIdStr'=""){
				for k=1:1:$l(RadioCheckedIdStr,"$"){
					s oneId=$p(RadioCheckedIdStr,"$",k)
					continue:oneId=""
					if ($d(^TKBTREMi(0,"Base",TKBTEDATSOU,oneId))&&(("^"_DocSourseIds_"^")[("^"_oneId_"^"))){
						s desc=$p(^TKBTREM(oneId),"^",2)
						if (PropertyDesc="") s PropertyDesc=desc
						else  s PropertyDesc=PropertyDesc_","_desc
					}
				}
			}
			if (OneshowType="CG")&&(CheckBoxCheckedIdStr'=""){
				for k=1:1:$l(CheckBoxCheckedIdStr,"$"){
					s oneId=$p(CheckBoxCheckedIdStr,"$",k)
					continue:oneId=""
					if ($d(^TKBTREMi(0,"Base",TKBTEDATSOU,oneId))&&(("^"_DocSourseIds_"^")[("^"_oneId_"^"))){
						s desc=$p(^TKBTREM(oneId),"^",2)
						if (PropertyDesc="") s PropertyDesc=desc
						else  s PropertyDesc=PropertyDesc_","_desc
					}
				}
			}
		}else{
			s TKBTDRowId=""
			for {
				s TKBTDRowId=$o(^TKBTREEXTDTLi(0,"Ext",OneChildPropertyId,TKBTDRowId))
				Q:TKBTDRowId=""
				s TKBTDDesc=$p(^TKBTREEXTDTL(TKBTDRowId),"^",2)
				if (OneshowType="T"){
					s parentNodeId=$p(^TKBTREEXTDTL(TKBTDRowId),"^",3)
					if (parentNodeId="") s del=","
					e  s del="."
					if (("$"_TreeCheckedIdStr_"$")[("$"_TKBTDRowId_"$")){
						if (PropertyDesc="") s PropertyDesc=TKBTDDesc
						else  s PropertyDesc=PropertyDesc_del_TKBTDDesc
					}
				}
				if (OneshowType="C"){
					if (("$"_ComboCheckedIdStr_"$")[("$"_TKBTDRowId_"$")){
						if (PropertyDesc="") s PropertyDesc=TKBTDDesc
						else  s PropertyDesc=PropertyDesc_","_TKBTDDesc
					}
				}
				if (OneshowType="CB"){
					if (("$"_RadioCheckedIdStr_"$")[("$"_TKBTDRowId_"$")){
						if (PropertyDesc="") s PropertyDesc=TKBTDDesc
						else  s PropertyDesc=PropertyDesc_","_TKBTDDesc
					}
				}
				if (OneshowType="CG"){
					if (("$"_CheckBoxCheckedIdStr_"$")[("$"_TKBTDRowId_"$")){
						if (PropertyDesc="") s PropertyDesc=TKBTDDesc
						else  s PropertyDesc=PropertyDesc_","_TKBTDDesc
					}
				}
			}
		}
	}
	Q:PropertyDesc'="" DKBDicDesc_"("_PropertyDesc_")"
	//如果诊断没有选择相应的属性，则把模板引用属性列表展示处理
	if (PropertyDesc=""){
		Q DKBDicDesc_"("_DiagDisplayNameStr_")"
	}
	Q DKBDicDesc
}

ClassMethod DiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosListExecute ]
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

// 查询诊断模板列表

Query DiagTemplateList(USERID As %String) As %Query(ROWSPEC = "DHCDIAMASRowid,DHCDIADESC")
{
}

ClassMethod DiagTemplateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagTemplateListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DiagTemplateListExecute(ByRef qHandle As %Binary, USERID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","DiagTemplateList")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if USERID="" {  
	    d ResetVariables2
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s PrivateListStr=##class(web.DHCDocDiagnosNew).GetPrivateList(USERID)
	s PrivateListStr=$p(PrivateListStr,$c(2),1)
	For i=1:1:$l(PrivateListStr,$c(1)) d
	.s OnePrivateListStr=$p(PrivateListStr,$c(1),i)
	.s DHCDIAMASRowid=$p(OnePrivateListStr,"^",1)
	.s DHCDIADESC=$p(OnePrivateListStr,"^",2)
	.Do OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DHCDIAMASRowid,DHCDIADESC)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables2
	set (DHCDIAMASRowid,DHCDIADESC)=""
	quit
}

ClassMethod DiagTemplateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagTemplateListExecute ]
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

// 查询诊断模板明细列表

Query DiagTemplateDetailList(MASTERDR As %String) As %Query(ROWSPEC = "DHCMRDiaICDICDDR,DHCMRDiaICDICDDesc")
{
}

ClassMethod DiagTemplateDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagTemplateDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DiagTemplateDetailListExecute(ByRef qHandle As %Binary, MASTERDR As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","DiagTemplateDetailList",17)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if MASTERDR="" {  
	    d ResetVariables3
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	For i=1:1:5 d
	.s ICDStr=##class(web.DHCDocDiagnosNew).GetICD(MASTERDR,i)
	.q:ICDStr=""
	.For j=1:1:$l(ICDStr,$c(1)) d
	..s OneICDStr=$p(ICDStr,$c(1),j)
	..s DHCMRDiaICDICDDR=$p(OneICDStr,"^",1)
	..s DHCMRDiaICDICDDesc=$p(OneICDStr,"^",2)
	..s DHCMRDiaICDICDDesc=##class(web.DHCDocUtil).EvalJSON(DHCMRDiaICDICDDesc)
	..Do OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(DHCMRDiaICDICDDR,DHCMRDiaICDICDDesc)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables3
	set (DHCMRDiaICDICDDR,DHCMRDiaICDICDDesc)=""
	quit
}

ClassMethod DiagTemplateDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagTemplateDetailListExecute ]
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

/// 查询诊断类型
Query GetDiagnosTypeList(AdmType As %String = "", defaultMRDiagType As %String = "", mradm As %String = "") As %Query(ROWSPEC = "DTYPRowid:%String,DTYPDesc:%String,selected:%Boolean")
{
}

ClassMethod GetDiagnosTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDiagnosTypeListExecute(ByRef qHandle As %Binary, AdmType As %String = "", defaultMRDiagType As %String = "", mradm As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","GetDiagnosTypeList",)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s IPDedfaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code","M",0))
	s OPDedfaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code","OP",0))
	s IPEntryDiagTypeID=$o(^MRC("DTYP",0,"Code","C008",0))
    s DiagnosTypeStr=##class(web.DHCDocDiagnosNew).GetDiagnosType(AdmType)
    For i=1:1:$l(DiagnosTypeStr,"^") d
    .s OneDiagnosTypeStr=$p(DiagnosTypeStr,"^",i)
    .s DTYPRowid=$p(OneDiagnosTypeStr,$c(1),1)
    .s DTYPDesc=$p(OneDiagnosTypeStr,$c(1),2)
    .s selected=0
    .s MRDiagnoseCount=1
    .i mradm'="" s MRDiagnoseCount=##class(web.DHCDocOrderEntry).GetMRDiagnoseCount(mradm)
    .if (AdmType="I")&&(DTYPRowid=IPDedfaultDiagnosTypeID) s selected=1
    .e  i (DTYPRowid=OPDedfaultDiagnosTypeID) s selected=1
    .i (AdmType="I")&&(MRDiagnoseCount=0)&&(DTYPRowid=IPEntryDiagTypeID) s selected=1
    .i (defaultMRDiagType'="") d
    ..i (DTYPRowid=defaultMRDiagType) s selected=1
    ..e  s selected=0
	.Do OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(DTYPRowid,DTYPDesc,selected)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables4
	set (DTYPRowid,DTYPDesc,selected)=""
	quit
}

ClassMethod GetDiagnosTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosTypeListExecute ]
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

/// Creator：    宋春莉
/// CreatDate：  2015-09-10
/// Description：根据PA_ADM表RowID获取住院患者的门急诊诊断(可能有多个)
/// Table：      PA_ADM,MR_Diagnos,MRC_ICDDx
/// Input：      EpisodeID
/// Return：     MRDIAICDCodeDR(指向MRC_ICDDx),MRDiagnos
/// Debug:		 w ##class(web.DHCDocDiagnosNew).GetMRDiagnosByEpisodeID(EpisodeID)
ClassMethod GetMRDiagnosByEpisodeID(EpisodeID)
{
	q:+EpisodeID=0 ""
	s MRDiagnos=""
	s INDiaType=$O(^MRC("DTYP",0,"Code","C008",0)) ;入院诊断
	s mradmId=$P(^PAADM(+EpisodeID),"^",61)
	s mrdiaSub=0
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
	.s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
	.q:MRDIAICDCodeDR=""
	.s TYPMRCDiagTyp=$p(^MR(mradmId,"DIA",mrdiaSub,"TYP",1),"^",1)
	.q:TYPMRCDiagTyp'=INDiaType
	.i MRDiagnos="" d
	..s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	.e  d
	..s MRDiagnos=MRDiagnos_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	q MRDiagnos
}

// 添加到诊断模板

ClassMethod PrivateSaveNew(USERID As %String, selValue As %String, DiagnosStr As %String, ListNum As %String) As %String
{
   &sql(select count(DHCMRDiaICD_ListIndex) into :MaxListIndex from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_ListNum=:ListNum and DHCMRDiaICD_MASTERDR=:selValue and DHCMRDiaICD_ListNum='1')
   s MaxListIndex=MaxListIndex+1
   Q:DiagnosStr=""
   for i=1:1:$L(DiagnosStr,"^") d
   .Set IcdRowid=$P(DiagnosStr,"^",i)
   .&sql(insert into SQLUSER.DHC_MRDiagnosICD set DHCMRDiaICD_MASTERDR=:selValue,DHCMRDiaICD_ICDDR=:IcdRowid,DHCMRDiaICD_ListNum=:ListNum,DHCMRDiaICD_ListIndex=:MaxListIndex)
   Q SQLCODE
}

// 获取单病种信息

Query GetPAADMSingleDisInfoList(EpisodeID As %String) As %Query(ROWSPEC = "DTYPRowid:%String,DTYPDesc:%String,selected:%Boolean")
{
}

ClassMethod GetPAADMSingleDisInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAADMSingleDisInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPAADMSingleDisInfoListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","GetPAADMSingleDisInfoList",)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s SingleDisSub=""
	f  s SingleDisSub=$o(^PAADM(EpisodeID,"PLN",SingleDisSub),-1) q:SingleDisSub=""  d
	.q:+SingleDisSub=0 
	.s SingleDis=$g(^PAADM(EpisodeID,"PLN",SingleDisSub))
	.Do OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(DTYPRowid,DTYPDesc,selected)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables4
	set (DTYPRowid,DTYPDesc,selected)=""
	quit
}

ClassMethod GetPAADMSingleDisInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAADMSingleDisInfoListExecute ]
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

ClassMethod UpdateNCDCode(MRDiagnosRowid As %String, NCDCode As %String) As %String
{
	s $p(^MR(+MRDiagnosRowid,"DIA",$p(MRDiagnosRowid,"||",2),"DHC"),"^",10)=NCDCode
	q ""
}

ClassMethod GetNCDDesc(NCDCode As %String) As %String
{
	q:NCDCode="" ""
	s NCDDesc=""
	s NCDRowid=0
	for {
		s NCDRowid=$O(^DHCINDID("0","IType","JSSZMZBZ",NCDRowid))
		q:NCDRowid=""
		s str=$g(^DHCINDID(NCDRowid))
		s TNCDCode=$P(str,"^",2)
		s TNCDDesc=$P(str,"^",3)
		s TNCDAlise=$P(str,"^",6)
		//s NCDDesc=NCDAlise_" "_NCDDesc
		continue:(TNCDCode'=NCDCode)
		s NCDDesc=TNCDDesc
	}
	q NCDDesc
}

ClassMethod GetNCDStr(AdmRowId As %String) As %String
{
	s MRADMID=$P(^PAADM(AdmRowId),"^",61)
	s NCDDescList=""
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Rowid=obj.Data("ID")
	.s NCDCode=$p($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DHC")),"^",10)
	.s NCDDesc=..GetNCDDesc(NCDCode)
	.q:NCDDesc=""
	.i NCDDescList="" d
	..s NCDDescList=NCDDesc
	.e  d
	..s NCDDescList=NCDDescList_" "_NCDDesc
	q NCDDescList
}

/// 查询慢病类型
Query GetNCDList(Desc As %String = "") As %Query(ROWSPEC = "NCDRowid:%String,NCDDesc:%String,NCDCode:%String")
{
}

ClassMethod GetNCDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNCDListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetNCDListExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCMRDiagnosNew","GetNCDList","")
	s:Desc'="" ^tan("GetNCDList")=Desc
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Desc=$zcvt(Desc,"U")
	d ResetVariables12
	d OutputRow12
	s NCDRowid=0
	for {
		s NCDRowid=$O(^DHCINDID("0","IType","JSSZMZBZ",NCDRowid))
		q:NCDRowid=""
		s str=$g(^DHCINDID(NCDRowid))
		s NCDCode=$P(str,"^",2)
		s NCDDesc=$P(str,"^",3)
		s NCDAlise=$P(str,"^",6)
		//s NCDDesc=NCDAlise_" "_NCDDesc
		continue:(NCDDesc'[Desc)&&(NCDAlise'[Desc)
		d OutputRow12
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow12
	set Data=$lb(NCDRowid,NCDDesc,NCDCode)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables12
	set (NCDRowid,NCDDesc,NCDCode)=""
	quit
}

ClassMethod GetNCDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNCDListExecute ]
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

}
