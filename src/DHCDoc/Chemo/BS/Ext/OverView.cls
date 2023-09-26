/// CTOR: QP
/// DATE: 2022-02-17
/// DESC: 化疗总览
Class DHCDoc.Chemo.BS.Ext.OverView Extends DHCDoc.Util.RegisteredObject
{

/// CTOR: QP
/// DATE: 2022-02-17
/// DESC: 得到表格列
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.OverView).GetColumns("218||1")
ClassMethod GetColumns(PSID)
{
	s PLID=+PSID,SUB=$P(PSID,"||",2)
	s mRtn="[{""field"":""GroupDesc"",""title"":""化疗组类型"",""width"":100}"
	s mRtn=mRtn_",{""field"":""Symbol"",""title"":""组符"",""width"":50}"
	s mRtn=mRtn_",{""field"":""ArcimDesc"",""title"":""医嘱名称"",""width"":300}"
	s mRtn=mRtn_",{""field"":""UseInfo"",""title"":""用法"",""width"":200}"
	s ChemoDay=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",21)
	s ChemoDay=##class(DHCDoc.Chemo.COM.Func2).DoChemoDate(ChemoDay)
	s StartDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",3)
	i ChemoDay'="" {
		f i=1:1:$l(ChemoDay,",") {
			s CDate=$p(ChemoDay,",",i)
			s CDateNum=##class(websys.Conversions).DateHtmlToLogical(CDate)	
			s CTitle="D"_(CDateNum-StartDate+1)
			s DateFromat=##class(DHCDoc.Chemo.COM.Func2).FormatDate(CDate)
			//s CName="D"_(CDateNum-StartDate+1)_"<br>("_CDate_")"
			s CName="D"_(CDateNum-StartDate+1)_"<br>"_DateFromat
			s record="{""field"":"""_CTitle_""",""title"":"""_CName_""",""width"":60}"
			s mRtn=mRtn_","_record
		}	
	}
	s mRtn=mRtn_"]"
	q mRtn
}

/// CTOR: QP
/// DATE: 2022-02-17
/// DESC: 查询总览数据
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Ext.OverView","QryData","218||1")
Query QryData(PSID = "") As %Query(ROWSPEC = "ItemID,GroupDesc,ArcimDesc,Symbol,UseInfo,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21")
{
}

ClassMethod QryDataExecute(ByRef qHandle As %Binary, PSID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s sub=0
 	if PSID="" {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	//
	s langid=..%LanguageID()
	K ^||TEMPChemo
	s (Symbol,UseInfo,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21)=""
	S PLID=+PSID,SUB=$P(PSID,"||",2)
	s StartDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",3)
	
	s code=""
	f  s code=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SUB,code)) q:code=""  d
	.s GID=""
	.f  s GID=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SUB,code,GID)) q:GID=""  d
	..s PGDescDr=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,GID),"^",2)
	..s DefinePar=+PGDescDr,DefineSub=$p(PGDescDr,"||",2)
	..s PGDescCode=$p(^DHCDocCT("DefineData",DefinePar,"D",DefineSub),"^",1)
	..s GroupDesc=$p(^DHCDocCT("DefineData",DefinePar,"D",DefineSub),"^",2)
	..s GroupDesc=##class(User.ChemoTemplateGroup).GetTranByDesc("TPGDesc",GroupDesc,langid)
	..s count=0
	..s ID=""
	..f  s ID=$O(^BS.DOC.Chemo.PlanD(PLID,SUB,GID,ID)) Q:ID=""  D
	...s ItemID=PSID_"||"_GID_"||"_ID
	...s arcim=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,GID,ID),"^",1)
	...S ARC=+arcim,VER=$P(arcim,"||",2)
	...S ArcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	...s ArcimDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	...;用法
	...s dosageUomDesc="",freqDesc="",instrucDesc=""
	...s dosage=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,GID,ID),"^",2)
	...s dosage=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(dosage)
 	...s dosageUomDR=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,GID,ID),"^",3)
 	...i dosageUomDR'="" s dosageUomDesc=$p(^CT("UOM",dosageUomDR),"^",2)
 	...s dosageUomDesc= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",dosageUomDesc,langid)
 	...s freqDR=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,GID,ID),"^",4)
 	...i freqDR'="" s freqDesc=$p(^PHCFR(freqDR),"^",3)
 	...s freqDesc= ##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",freqDesc,langid)
 	...s instrucDR=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,GID,ID),"^",5)
 	...i instrucDR'="" s instrucDesc=$p(^PHCIN(instrucDR),"^",2)
 	...s instrucDesc= ##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrucDesc,langid)
 	...s UseInfo=freqDesc_" "_instrucDesc_" "_dosage_dosageUomDesc
	...s ShowDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,GID,ID),"^",28)
	...Q:ShowDate=""
	...s linkItem=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,GID,ID),"^",9)
	...s count=count+1
	...k DTList
	...d ..GetDTList(ShowDate,StartDate,.DTList)
	...s D1=DTList(1),D2=DTList(2),D3=DTList(3),D4=DTList(4),D5=DTList(5),D6=DTList(6)
	...s D7=DTList(7),D8=DTList(8),D9=DTList(9),D10=DTList(10),D11=DTList(11),D12=DTList(12)
	...s D13=DTList(13),D14=DTList(14),D15=DTList(15),D16=DTList(16),D17=DTList(17),D18=DTList(18)
	...s D19=DTList(19),D20=DTList(20),D21=DTList(21)
	...s OutData=$lb(ItemID,GroupDesc,ArcimDesc,Symbol,UseInfo,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21)
	...i linkItem'= "" d
	....i linkItem["." s mainLink=$p(linkItem,".",1)
	....e  s mainLink=linkItem
	....s ^||TEMPChemo(code,"CZ",mainLink,linkItem,count)=OutData
	...e  d
	....s ^||TEMPChemo(code,"NOCZ",count)=OutData
	
	// ┏   ┗
	s code=""
	f  s code=$o(^||TEMPChemo(code)) q:code=""  d
	.s count=0
	.f  s count=$o(^||TEMPChemo(code,"NOCZ",count)) q:count=""  d
	..s RowData=$g(^||TEMPChemo(code,"NOCZ",count))
	..d output1
	.s mainLink=""
	.f  s mainLink=$o(^||TEMPChemo(code,"CZ",mainLink)) q:mainLink=""  d
	..s linkItem=""
	..f  s linkItem=$o(^||TEMPChemo(code,"CZ",mainLink,linkItem)) q:linkItem=""  d
	...s count=$o(^||TEMPChemo(code,"CZ",mainLink,linkItem,""))
	...i linkItem["." s TmpBol="┗"
	...e  s TmpBol="┏"
	...s RowData=$g(^||TEMPChemo(code,"CZ",mainLink,linkItem,count))
	...s $list(RowData,4)=TmpBol
	...d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=RowData	//$lb(ItemID,GroupDesc,ArcimDesc,Symbol,UseInfo,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// CTOR: QP
/// DATE: 2022-02-17
/// DESC: 
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.OverView).GetColumns("218||1")
ClassMethod GetDTList(ShowDate, StartDate, ByRef DTList)
{
	f j=1:1:21 {
		s DTList(j)=""
	}
	Q:ShowDate="" ""
	f i=1:1:$l(ShowDate,",") {
		s CDate=$p(ShowDate,",",i)
		s CDateNum=##class(websys.Conversions).DateHtmlToLogical(CDate)	
		s CName=(CDateNum-StartDate+1)
		s DTList(CName)="√"
		
	}
	
	Q ""
}

}
