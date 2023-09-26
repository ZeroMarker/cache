/// CTOR: QP
/// DATE: 2021-03-20
/// DESC: 化疗方案打印
Class DHCDoc.Chemo.BS.Ext.Print Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-03-20
/// DESC: XML打印-获取元数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Print).GetPWPrintData("911||1")
ClassMethod GetPWPrintData(PSID, EpisodeID = "", PatientID = "", SelectDate = "") As %String
{
	q:(PSID="") ""
	s PLID=+PSID,SUB=$P(PSID,"||",2)
	i PatientID=""  {
		s PatientID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",1)	
		s EpisodeID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",6)	
		
	}
	;病人信息
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
	s SexDR=$p(^PAPER(PatientID,"ALL"),"^",7)
	s BirthDay=$p(^PAPER(PatientID,"ALL"),"^",6)
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	s BirthDay=##class(websys.Conversions).DateLogicalToHtml(BirthDay)
	s Sex=""
	i SexDR'="" s Sex=$P(^CT("SEX",SexDR),"^",2)
	;化疗方案信息
	s PLName=$p(^BS.DOC.Chemo.PlanD(PLID),"^",2)
	s TPID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",3)
	s PLTitle=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",13)
	s PLTitle=##class(DHCDoc.Chemo.COM.Func2).FilterToHtml(PLTitle,1)
	s MainDrug=##class(DHCDoc.Chemo.BS.Apply).GetMainDrug(PSID,"CUR",1)
	s MainDrug=##class(DHCDoc.Chemo.COM.Func2).FilterToHtml(MainDrug,1)
	s Stage=$P(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",1)
	s StartDate=$P(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",3)
	s StartDate=##class(websys.Conversions).DateLogicalToHtml(StartDate)
	s ChemoDate=$P(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",21)
	s ChemoDate=..GetDayNum(StartDate,ChemoDate)
	s NeedLoc="",NeedDoc=""
	i SelectDate'="" {
		s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(SelectDate,PSID)	
		i PDID'="" {
			s NeedLoc=$P(^BS.DOC.Chemo.PlanDateD(PDID),"^",30)
			s NeedDoc=$P(^BS.DOC.Chemo.PlanDateD(PDID),"^",29)
			i NeedDoc'="" s NeedDoc=$P(^SSU("SSUSR",NeedDoc),"^",2)
			i NeedLoc'="" s NeedLoc=$P(^CTLOC(NeedLoc),"^",2)
		}
	}
	;
	s printObj = ##class(ext.util.JsonObject).%New()
	d printObj.Put("PatName",PatName)
	d printObj.Put("BirthDay",BirthDay)
	d printObj.Put("PatNo",PatNo)
	d printObj.Put("Sex",Sex)
	;
	d printObj.Put("PLName",PLName)
	d printObj.Put("PLTitle",PLTitle)
	d printObj.Put("MainDrug",MainDrug)
	d printObj.Put("NeedLoc",NeedLoc)
	d printObj.Put("NeedDoc",NeedDoc)
	d printObj.Put("Stage",Stage)
	d printObj.Put("StartDate",StartDate)
	d printObj.Put("ChemoDate",ChemoDate)
	
	
	s mRtn = printObj.GetPrintData()
	do printObj.%Close()
	set printObj = ""
	quit mRtn
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-06-11
/// DESC: XML打印-获取元数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Print).SetPWColumsName("seqno,PatWorkType,PatName,PatSex,PatAge,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,BCRemarkUser,FindDate")
ClassMethod SetPWColumsName(mList) As %String
{
	//seqno,GroupType,LinkSymbol,arcimDesc,ShowDate,formula,
	//BSAUnit,dosage,dosageUomDesc,instrucDesc,freqDesc,note,qty,uomDesc,mainDrug
	s Len=$l(mList,",")
	s outList=$lb("")
	f i=1:1:Len {
		s column=$p(mList,",",i)
		i column="seqno" s column="序号"
		e  i column="GroupType" s column="组类型"
		e  i column="LinkSymbol" s column="组"
		e  i column="arcimDesc" s column="医嘱"
		e  i column="ShowDate" s column="日期"
		e  i column="formula" s column="计算公式"
		e  i column="BSAUnit" s column="A/B/W"
		e  i column="dosage" s column="剂量"
		e  i column="dosageUomDesc" s column="剂量单位"
		e  i column="instrucDesc" s column="用法"
		e  i column="freqDesc" s column="频次"
		e  i column="note" s column="备注"
		e  i column="qty" s column="数量"
		e  i column="uomDesc" s column="数量单位"
		e  i column="remark" s column="附加说明"
		e  i column="mainDrug" s column="是否主药"
		e  s column=""
		s $list(outList,i)=column	//"<font style='font-weight:bold;'>"_column_"</font>"
	}	
	Q outList
}

/// CTOR: QP
/// DATE: 2019-02-13
/// DESC: 打印列表
/// IN  : 
/// OUT : 
/// TABL: 
/// INDE: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Ext.Print","QryChemoList","911||1","","352","1509","12213^28^4^2^undefined^20")
Query QryChemoList(PSID As %String, SelectDate = "", PatientID = "", EpisodeID = "", SessionStr = "") As %Library.Query(ROWSPEC = "seqno,GroupType,LinkSymbol,arcimDesc,ShowDate,formula,BSAUnit,dosage,dosageUomDesc,instrucDesc,freqDesc,note,qty,uomDesc,remark")
{
}

ClassMethod QryChemoListExecute(ByRef qHandle As %Library.Binary, PSID As %String, SelectDate = "", PatientID = "", EpisodeID = "", SessionStr = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//查询所有
	s SelectDate=""
	s ^QP("QryChemoList")=$LB(PSID,SelectDate,PatientID,EpisodeID,SessionStr)
	s rs=##class(%Library.ResultSet).%New("DHCDoc.Chemo.BS.Item:QryAllItem")
	d rs.Execute(PSID,SelectDate,PatientID,EpisodeID,SessionStr)
	
	//s FindDate=##class(websys.Conversions).DateLogicalToHtml(FindDate)
	s mList="seqno,GroupType,LinkSymbol,arcimDesc,ShowDate,formula,BSAUnit,dosage,dosageUomDesc,instrucDesc,freqDesc,note,qty,uomDesc,remark"
	s OutputList=..SetPWColumsName(mList)
	d OutputRow1
	if rs.QueryIsValid() {
		s seqno=0
		s columns=rs.GetColumnCount()
		while rs.Next() {
			// seqno,GroupType,LinkSymbol,arcimDesc,ShowDate,formula,BSAUnit,
			// dosage,dosageUomDesc,instrucDesc,freqDesc,note,qty,uomDesc,remark,mainDrug
			s (GroupType,LinkSymbol,arcimDesc,ShowDate,formula,BSAUnit,dosage,dosageUomDesc,instrucDesc,freqDesc,note,qty,uomDesc,remark)=""
			for i=1:1:columns {
				s colName = rs.GetColumnHeader(i)
				i colName="qty" {
					 s qty=rs.GetData(i)
				}
				i colName="uomDesc" s uomDesc=rs.GetData(i)
				i colName="GroupType" s GroupType=rs.GetData(i)
				i colName="LinkSymbol" s LinkSymbol=rs.GetData(i)
				i colName="arcimDesc" s arcimDesc=rs.GetData(i)
				i colName="ShowDate" s ShowDate=rs.GetData(i)
				i colName="formula" s formula=rs.GetData(i)
				i colName="BSAUnit" s BSAUnit=rs.GetData(i)
				i colName="dosage" s dosage=rs.GetData(i)
				i colName="dosageUomDesc" s dosageUomDesc=rs.GetData(i)
				i colName="instrucDesc" s instrucDesc=rs.GetData(i)
				i colName="freqDesc" s freqDesc=rs.GetData(i)
				i colName="remark" s remark=rs.GetData(i)
				i colName="note" s note=rs.GetData(i)
				i colName="mainDrug" s mainDrug=rs.GetData(i)
				
			}
			s seqno=seqno+1
			s OutputList=$lb(seqno,GroupType,LinkSymbol,arcimDesc,ShowDate,formula,BSAUnit,dosage,dosageUomDesc,instrucDesc,freqDesc,note,qty,uomDesc,remark)
			d OutputRow1
		}
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryChemoListFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryChemoListExecute ]
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

ClassMethod QryChemoListClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryChemoListFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-03-20
/// DESC: 将日期转换成DayNum
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Print).GetDayNum()
ClassMethod GetDayNum(StartDate, ChemoDate) As %String
{
	s mRtn=""
	Q:(StartDate="")||(ChemoDate="") mRtn
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	f i=1:1:$l(ChemoDate,",") {
		s date=$p(ChemoDate,",",i)	
		s date=##class(websys.Conversions).DateHtmlToLogical(date)
		s rc=date-StartDate+1
		s rc="Day"_rc
		i mRtn="" s mRtn=rc
		e  s mRtn=mRtn_","_rc
	}
	
	Q mRtn
}

}
