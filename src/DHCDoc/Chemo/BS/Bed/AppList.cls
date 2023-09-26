/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 化疗预约一览表
Class DHCDoc.Chemo.BS.Bed.AppList Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 查询
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Bed.AppList","QryAppList","2022-07-05","","",2)
Query QryAppList(SelectDate = "", InType = "", IsTitle = "", InHosp = "") As %Query(ROWSPEC = "TypeDesc,patName,age,sex,BedNum,PatientNum,PatientTel,EditUser,Drug1,Drug2,Drug3,Drug4,Drug5,Drug6,PLName,bid,PatientID,EpisodeID") [ SqlProc ]
{
}

ClassMethod QryAppListExecute(ByRef qHandle As %Binary, SelectDate = "", InType = "", IsTitle = "", InHosp = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Bed.AppList","QryAppList","2020-12-25")
	s ^QP("hh")=$lb(SelectDate , IsTitle )
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i SelectDate="" {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	//s OtherColumns=..GetOtherColumns()
	i IsTitle=1 {
		d outTitle
	}
	s langid=..%LanguageID()
 	//s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
 	s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
 	s DisplayDate=##class(websys.Conversions).DateLogicalToHtml(SelectDate)
 	s type=""
	f  s type=$o(^BS.DOC.Chemo.BedI("HospChemoDateBType",InHosp,SelectDate,type)) q:type=""  d
	.q:(InType'="")&&(type'=InType)
	.s bid=""
	.f  s bid=$o(^BS.DOC.Chemo.BedI("HospChemoDateBType",InHosp,SelectDate,type,bid)) q:bid=""  d
	..s (Drug1,Drug2,Drug3,Drug4,Drug5,Drug6)=""
	..k MList
	..s PatientID=$P(^BS.DOC.Chemo.BedD(bid),"^",2)
	..q:PatientID=""
	..s BedNum=$P(^BS.DOC.Chemo.BedD(bid),"^",7)
	..s PlanDR=$P(^BS.DOC.Chemo.BedD(bid),"^",10)
	..Q:PlanDR=""	;没有化疗方案退出
	..s PLName=$P(^BS.DOC.Chemo.PlanD(PlanDR),"^",2)
	..s PLName=##class(User.ChemoTemplate).GetTranByDesc("TPName",PLName,langid)
	..;s BedNum=##class(DHCDoc.Chemo.BS.Bed.Manage).GetBedNo(BedNum)
	..s AdmID=$P(^BS.DOC.Chemo.BedD(bid),"^",3)
	..s CType=$P(^BS.DOC.Chemo.BedD(bid),"^",4)
	..s TypeDesc=..GetTypeDesc(CType)
	..s TypeDesc=DisplayDate_" "_TypeDesc
	..s Address=$P(^BS.DOC.Chemo.BedD(bid),"^",5)
	..s EditUser=$P(^BS.DOC.Chemo.BedD(bid),"^",9)
	..i EditUser'="" s EditUser=$p(^SSU("SSUSR",EditUser),"^",2)
	..s EditUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",EditUser,langid)
	..s patName=$p(^PAPER(PatientID,"ALL"),"^",1)
	..s PatientNum=$P(^PAPER(PatientID,"PAT",1),"^",1)
	..s PatientTel=$P(^PAPER(PatientID,"PER",1),"^",11)		
	..s age=##class(web.DHCSTKUTIL).GetAge(PatientID)
	..s EpisodeID=##class(DHCDoc.Chemo.BS.Bed.Manage).GetLastAdm(PatientID)
 	..s patSex=$p(^PAPER(PatientID,"ALL"),"^",7)
 	..s sex=$p(^CT("SEX",patSex),"^",2)
 	..s sex= ##class(User.CTSex).GetTranByDesc("CTSEXDesc",sex,langid)
 	..s DrugList=$P(^BS.DOC.Chemo.BedD(bid),"^",6)
 	..i DrugList'="" d
 	..s Drug1=..GetChemoDrugList(PlanDR,SelectDate,InHosp)
 	..s ListData=$lb(TypeDesc,patName,age,sex,BedNum,PatientNum,PatientTel,EditUser,Drug1,Drug2,Drug3,Drug4,Drug5,Drug6,PLName,bid,PatientID,EpisodeID)
 	..d output1
 	
 	/*
 	..f j=1:1:$L(OtherColumns,",") d
 	...s arcim=$p(OtherColumns,",",j)
 	...s ARC=+arcim,VER=$P(arcim,"||",2)
 	...s val=..InArray(DrugList,arcim)
 	...s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	...s arcimCode=$p(^ARCIM(ARC,VER,1),"^",1)
	...s listLen=$ll(ListData)
	...s $list(ListData,(listLen+1))=val
	..s listLen=$ll(ListData)
	..s $list(ListData,(listLen+1))=bid
	..s $list(ListData,(listLen+2))=PatientID
 	..d output1
 	*/
 	
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

outTitle
	s (bid,PatientID)=""
	s patName="姓名",age="年龄",sex="性别",TypeDesc="时间"
	s BedNum="床号",PatientNum="病人ID",PatientTel="患者电话",EditUser="录入人"
	s Drug1="药品1",Drug2="药品2",Drug3="药品3"
	s Drug4="药品4",Drug5="药品5",Drug6="药品6"
	//s X04290=..GetArcimDescByCode("04290")
	
	s ListData=$lb(TypeDesc,patName,age,sex,BedNum,PatientNum,PatientTel,EditUser,bid,PatientID,EpisodeID,Drug1,Drug2,Drug3,Drug4,Drug5,Drug6)
	d output1
	Quit
	
output1
	Set Data=ListData	//$lb(bid,PatientID,patName,age,sex,TypeDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryAppListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAppListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAppListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAppListExecute ]
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
/// DATE: 2020-12-23
/// DESC: 得到其他固定列
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetOtherColumns("code")
ClassMethod GetOtherColumns(flag = "")
{
	s mRtn="",mRtnCode=""
	s id=""
	f  s id=$o(^CF.DOC.Chemo.DrugDicD(id)) q:id=""  d
	.s arcim=$p(^CF.DOC.Chemo.DrugDicD(id),"^",1)
	.s active=$p(^CF.DOC.Chemo.DrugDicD(id),"^",3)
	.q:active'=1
	.s ARC=+arcim,VER=$P(arcim,"||",2)
 	.s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	.s arcimCode=$p(^ARCIM(ARC,VER,1),"^",1)
	.s record=arcimCode
	.i mRtn="" s mRtn=arcim
	.e  s mRtn=mRtn_","_arcim
	.i mRtnCode="" s mRtnCode=arcimCode
	.e  s mRtnCode=mRtnCode_","_arcimCode
	i flag="code" {
		Q mRtnCode
	} else {
		Q mRtn
	}
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 得到其他固定列
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetColumns()
ClassMethod GetColumns()
{
	//
	s mRtn="{""field"":""TypeDesc"",""title"":""时间"",""width"":""170""}"_$C(1)
			_"{""field"":""patName"",""title"":""姓名"",""width"":""100""}"_$C(1)
			_"{""field"":""age"",""title"":""年龄"",""width"":""100""}"_$C(1)
			_"{""field"":""sex"",""title"":""性别"",""width"":""100""}"_$C(1)
			_"{""field"":""BedNum"",""title"":""床号"",""width"":""100""}"_$C(1)
			_"{""field"":""PatientNum"",""title"":""病人ID"",""width"":""100""}"_$C(1)
			_"{""field"":""PatientTel"",""title"":""患者电话"",""width"":""150""}"_$C(1)
			_"{""field"":""EditUser"",""title"":""录入人"",""width"":""150""}"_$C(1)
			_"{""field"":""PLName"",""title"":""化疗方案"",""width"":""150""}"_$C(1)
			_"{""field"":""Drug1"",""title"":""药品"",""width"":""600""}"_$C(1)
			//_"{""field"":""Drug2"",""title"":""药品2"",""width"":""150""}"_$C(1)
			//_"{""field"":""Drug3"",""title"":""药品3"",""width"":""150""}"_$C(1)
			//_"{""field"":""Drug4"",""title"":""药品4"",""width"":""150""}"_$C(1)
			//_"{""field"":""Drug5"",""title"":""药品5"",""width"":""150""}"_$C(1)
			//_"{""field"":""Drug6"",""title"":""药品6"",""width"":""150""}"_$C(1)
			
			_"{""field"":""bid"",""title"":""bid"",""width"":""100"",""hidden"":""true""}"
	/*
	s id=""
	f  s id=$o(^CF.DOC.Chemo.DrugDicD(id)) q:id=""  d
	.s arcim=$p(^CF.DOC.Chemo.DrugDicD(id),"^",1)
	.s active=$p(^CF.DOC.Chemo.DrugDicD(id),"^",3)
	.q:active'=1
	.s ARC=+arcim,VER=$P(arcim,"||",2)
 	.s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	.s arcimCode=$p(^ARCIM(ARC,VER,1),"^",1)
	.s record="{""field"":"""_arcimCode_""",""title"":"""_arcimDesc_""",""width"":""250""}"
	.s mRtn=mRtn_$C(1)_record
	*/
	
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 得到其他固定列
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetColumns()
ClassMethod GetTypeDesc(Type)
{
	//
	s mRtn=""
	i Type="A" s mRtn=##class(websys.Translation).Get("chemo.bs.bed.appoint.csp","上午(AM)")
	i Type="P" s mRtn=##class(websys.Translation).Get("chemo.bs.bed.appoint.csp","下午(PM)")
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).InArray("I")
ClassMethod InArray(kssarray As %String, docId As %String) As %String
{
	q:kssarray="" 0
	s rtn=0,data=""
	s multiLen=$l(kssarray,",")
	f len=1:1:multiLen {
		s data=$p(kssarray,",",len)
		q:data="" 
		i data=docId{
			s rtn=1	
			q
		}
		
	}
	q rtn
}

/// CTOR: QP
/// DATE: 2020-12-16
/// DESC: XML打印-获取元数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetPWPrintData("2020-12-26")
ClassMethod GetPWPrintData(SelectDate As %String) As %String
{
	//n (LocId,FindDate,FindBCType)
	
	s printObj = ##class(ext.util.JsonObject).%New()
	do printObj.Put("CDate",SelectDate)
	s mRtn = printObj.GetPrintData()
	do printObj.%Close()
	S printObj = ""
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 得到其他固定列
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetArcimDescByCode("GZ00001")
ClassMethod GetArcimDescByCode(code)
{
	s mRtn=""
	s code=$zcvt(code,"U")
	q:code="" mRtn
	q:'$d(^ARCIM(0,"Code",code)) mRtn
	s ver=$o(^ARCIM(0,"Code",code,""))
	Q:ver="" mRtn
	s ch=$o(^ARCIM(0,"Code",code,ver,""))
	Q:ch="" mRtn
	s mRtn=$p(^ARCIM(ver,ch,1),"^",2)
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 设置药品列的值
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetArcimDescByCode("GZ00001")
ClassMethod SetDrugColumn(j, val, ByRef D1, ByRef D2, ByRef D3, ByRef D4, ByRef D5, ByRef D6)
{
	i j=1 s D1=val
	e  i j=2 s D2=val
	e  i j=3 s D3=val
	e  i j=4 s D4=val
	e  i j=5 s D5=val
	e  i j=6 s D6=val
	e  Q 1
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 设置药品列的值
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetArcimDescByCode("GZ00001")
ClassMethod GetChemoDrugSimpleName(arcim)
{
	s mRtn=""
	Q:arcim="" mRtn
	s DID=$O(^CF.DOC.Chemo.DrugDicI("Arcim",arcim,""))
	Q:DID="" mRtn
	s mRtn=$P(^CF.DOC.Chemo.DrugDicD(DID),"^",4)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 得到总工有多少行
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetChemoRowList("2021-05-11","A")
ClassMethod GetChemoRowList(SelectDate As %String = "", InType = "")
{
	
	s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	s mRtn="{"
	s rset=##Class(%ResultSet).%New("DHCDoc.Chemo.BS.Bed.AppList:QryAppList")
	s total=0
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(SelectDate,InType)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s total=total+1
			s rc=""
			For i=1:1:columns  {
				//
				s cval=rset.GetData(i)
				i rc="" s rc=cval
				e  s rc=rc_"^"_cval
			}
			i total=1 s item=""""_total_""":"""_rc_""""
			e  s item=","""_total_""":"""_rc_""""
			s mRtn=mRtn_item
		}

	}
	s mRtn=mRtn_",""length"":"""_total_""""
	s mRtn=mRtn_"}"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-05-23
/// DESC: 根据化疗日期得到所有化疗药品
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetChemoDrugList(20,"2021-05-10")
ClassMethod GetChemoDrugList(PlanDR, ChemoDate, InHosp = "")
{
	s mRtn=""
	Q:(PlanDR="")||(ChemoDate="") mRtn
	s langid=..%LanguageID()
	s ChemoDate=##class(websys.Conversions).DateHtmlToLogical(ChemoDate)
	s num=0
	s SID=""
	f  s SID=$O(^BS.DOC.Chemo.PlanD(PlanDR,SID)) Q:SID=""  D
	.s startDate=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID),"^",3)
	.s endDate=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID),"^",4)
	.s showDate=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID),"^",21)
	.q:showDate=""
	.q:(startDate>ChemoDate)||(endDate<ChemoDate)
	.s tempFlag=##class(DHCDoc.Chemo.COM.Func2).ContainDate(showDate,ChemoDate)
	.q:tempFlag'=1
	.s GID=""
	.f  s GID=$O(^BS.DOC.Chemo.PlanD(PlanDR,SID,GID)) Q:GID=""  D
	..s ID=""
	..f  s ID=$O(^BS.DOC.Chemo.PlanD(PlanDR,SID,GID,ID)) Q:ID=""  D
	...s arcim=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID,GID,ID),"^",1)
	...s showDate=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID,GID,ID),"^",28)
	...s tempFlag=##class(DHCDoc.Chemo.COM.Func2).ContainDate(showDate,ChemoDate)
	...q:tempFlag'=1
	...s ARC=+arcim,VER=$P(arcim,"||",2)
	...s arcimDesc=##class(DHCDoc.Chemo.CFG.DrugDic).GetDrugSimpleName(arcim,InHosp)
	...i arcimDesc="" s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	...s arcimDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcimDesc,langid)
	...s arcimCode=$p(^ARCIM(ARC,VER,1),"^",1) 
	...i mRtn="" s mRtn=arcimDesc
	...e  s mRtn=mRtn_","_arcimDesc
	
	q mRtn
}

}
