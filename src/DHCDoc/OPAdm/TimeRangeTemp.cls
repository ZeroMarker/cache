Class DHCDoc.OPAdm.TimeRangeTemp Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(DHCDoc.OPAdm.TimeRangeTemp).Update(^Tempqujian("InputJson"),2)
ClassMethod Update(InputJson, HospID = "")
{
	s ^Tempqujian("InputJson")=InputJson
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s InputObj=[].%FromJSON(InputJson)
	s retObj={"Code":0,"ID":""}
	TS
	for i=1:1:InputObj.%Size(){
		s obj=InputObj.%Get(i-1)
		s FLag=0
		if obj.ID=""{
			s TRTempObj=##class(User.DHCTRInfoTemp).%New()
			s FLag=1
		}else{
			s TRTempObj=##class(User.DHCTRInfoTemp).%OpenId(obj.ID)
		}
		s RepeatId=$o(^User.DHCTRInfoTempI("UniqueName",HospID," "_$$ALPHAUP^SSUTIL4(obj.Name),""))
		if (RepeatId'="")&&((obj.ID="")||((obj.ID'="")&&(obj.ID'=RepeatId))) {
			s retObj.Code=-1
			s retObj.Msg=obj.Name_" 模板名已存在!"
			Q
		}
		b ;dd
		s TRTempObj.Name=obj.Name
		d TRTempObj.TimeRangeDRSetObjectId(obj.TimeRangeDR)
		d TRTempObj.InsertUserDRSetObjectId(obj.InsertUserDR)
		s TRTempObj.TempListType=obj.TempListTypeID
		s TRTempObj.TempListTypeID=obj.TempListID
		s Data=obj.Data
		if $IsObject(Data) s Data=Data.%ToJSON()
		s TRTempObj.Data=Data
		d TRTempObj.HospitalDRSetObjectId(HospID)
		s sc=TRTempObj.%Save()
		if $$$ISERR(sc){
			b ;093334
			s retObj.Code=-1
			s retObj.Msg="保存失败"
			Q
		}
		if FLag=1 s retObj.ID=TRTempObj.%Id()
	}
	if +retObj.Code'=0{
		TRO
	}else{
		TC
	}
	Q retObj.%ToJSON()
}

ClassMethod Delete(ID)
{
	&SQL(DELETE FROM SQLUser.DHC_TRInfoTemp WHERE ID=:ID)
	Q SQLCODE
}

/*Query QueryTemp(TRRowid = "") As %SQLQuery
{
	SELECT ID,Name,TimeRangeDR,TimeRangeDR->TR_Desc AS TimeRange,Data,InsertUserDR,InsertUserDR->SSUSR_Name AS InsertUser, 
	TO_CHAR(InsertDate,'YYYY-MM-DD') As InsertDate,TO_CHAR(InsertTime,'HH24:MI') As InsertTime,
	TO_CHAR(TimeRangeDR->TR_StartTime,'HH24:MI') AS SttTime,TO_CHAR(TimeRangeDR->TR_EndTime,'HH24:MI') AS EndTime
	FROM SQLUser.DHC_TRInfoTemp
	WHERE (TimeRangeDR=:TRRowid OR :TRRowid IS NULL)
}*/
/// do ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.TimeRangeTemp","QueryTemp",1,2,100,55,1540)
ClassMethod QueryTempExecute(ByRef qHandle As %Binary, TRRowid = "", HospID As %String = "", SumLoad As %String = "", LocID As %String = "", DocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^Tempscl("QueryTempExecute")=TRRowid_","_HospID_","_SumLoad_","_LocID_","_DocID
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s UserID=""
	if DocID'="" s UserID=$O(^SSU("SSUSR",0,"CTPCP",DocID,"0"))
	s ID=0
	for {
		s ID=$o(^User.DHCTRInfoTempD(ID)) Q:ID=""
		s HospDR=$lg(^User.DHCTRInfoTempD(ID),10)
		continue:HospID'=HospDR
		s Name=$lg(^User.DHCTRInfoTempD(ID),8)
		s TimeRangeDR=$lg(^User.DHCTRInfoTempD(ID),3)
		continue:(TRRowid'="")&&(TimeRangeDR'=TRRowid)
		continue:(TimeRangeDR="")
		s TimeRange=$p(^DHCTimeRange(TimeRangeDR),"^",2)
		continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_TimeRange",TimeRangeDR,HospID)
		s Data=$lg(^User.DHCTRInfoTempD(ID),9)
		s Load=0
		if (Data'="") {
			k TimeTangeCongeriesArr
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(Data,.TimeTangeCongeriesArr)
			s TimeRangeId=0
			for {
				s TimeRangeId=$o(TimeTangeCongeriesArr(TimeRangeId)) Q:TimeRangeId=""
				s Load=Load+$g(TimeTangeCongeriesArr(TimeRangeId,"Load"))
			}
		}
		continue:(SumLoad'="")&&(Load'=SumLoad)
		s InsertUserDR=$lg(^User.DHCTRInfoTempD(ID),5)
		s InsertUser=$p(^SSU("SSUSR",InsertUserDR),"^",2)
		s InsertDate=$lg(^User.DHCTRInfoTempD(ID),6)
		s InsertDate=..%ZD(InsertDate)
		s InsertTime=$lg(^User.DHCTRInfoTempD(ID),7)
		s InsertTime=..%ZT(InsertTime,1)
		s SttTime=$p(^DHCTimeRange(TimeRangeDR),"^",3)
		s SttTime=..%ZT(SttTime,1)
		s EndTime=$p(^DHCTimeRange(TimeRangeDR),"^",4)
		s EndTime=..%ZT(EndTime,1)
		s TempListTypeID="",TempListType="",TempListDesc="",TempListID=""
		s TempListTypeID=$lg(^User.DHCTRInfoTempD(ID),11)
		if (TempListTypeID'=""){
			if (TempListTypeID="HOSP"){
				s TempListType="全院"
				s TempListID=$lg(^User.DHCTRInfoTempD(ID),12)
				continue:(HospID'="")&&(TempListID'=HospID)
				if (TempListID'="") s TempListDesc=$P($g(^CT("HOSP",TempListID)),"^",2)
			}elseif(TempListTypeID="LOC"){
				s TempListType="科室"
				s TempListID=$lg(^User.DHCTRInfoTempD(ID),12)
				continue:(LocID'="")&&(TempListID'=LocID)
				if (TempListID'="") d
				.s TempListDesc=$p($g(^CTLOC(TempListID)),"^",2)
				.s TempListDesc=$TR(TempListDesc,"-")
			}elseif (TempListTypeID="USER"){
				s TempListType="用户"
				s TempListID=$lg(^User.DHCTRInfoTempD(ID),12)
				continue:(DocID'="")&&(TempListID'=DocID)
				if (TempListID'="") s TempListDesc=$P($g(^CTPCP(TempListID,1)),"^",2)
			}
		}
		s NameExpend=Name
		if (TempListDesc'="") s NameExpend=Name_"--"_TempListDesc
		set Data=$lb(ID,Name,TimeRangeDR,TimeRange,Data,InsertUserDR,InsertUser,InsertDate,InsertTime,SttTime,EndTime,Load,TempListTypeID,TempListType,TempListDesc,TempListID,NameExpend)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryTempFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTempExecute ]
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

ClassMethod QueryTempClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTempExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryTemp(TRRowid As %String = "", HospID As %String = "", SumLoad As %String = "", LocID As %String = "", DocID As %String = "") As %Query(ROWSPEC = "ID:%String,Name:%String,TimeRangeDR:%String,TimeRange:%String,Data:%String,InsertUserDR:%String,InsertUser:%String,InsertDate:%String,InsertTime:%String,SttTime:%String,EndTime:%String,Load:%String,TempListTypeID:%String,TempListType:%String,TempListDesc:%String,TempListID:%String,NameExpend:%String ")
{
}

/// do ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.TimeRangeTemp","QueryTempList","USER","",2,1)
Query QueryTempList(Type As %String = "", Desc As %String = "", HospID As %String = "", UserID As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String,Alias:%String")
{
}

ClassMethod QueryTempListExecute(ByRef qHandle As %Binary, Type As %String = "", Desc As %String = "", HospID As %String = "", UserID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^Tempscl("QueryTempList")=Type_","_Desc_","_HospID_","_UserID
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s Desc=$ZCVT(Desc,"U")
	if (Type="HOSP"){
		set ID=HospID
		s Code=$P(^CT("HOSP",HospID),"^",1)
		s Name=$P(^CT("HOSP",HospID),"^",2)
		set Data=$lb(ID,Name,Code)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}elseif (Type="LOC"){
		s AdmType=""
		Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
		do rset.Execute(UserID,AdmType,"",HospID)
		Set columns = rset.GetColumnCount()
		set row=0
		While (rset.Next()) {
			s ID=rset.GetData(1)
			s rowid=rset.GetData(1)
			s Name=$p($g(^CTLOC(rowid)),"^",2)
			s Name=$ZCVT(Name,"U")
			s CTCode=$p($g(^CTLOC(rowid)),"^",1)
			s CTContactNameTem=""
			i $L(Name,"-")>1 s CTContactNameTem=$P(Name,"-",1) s Name=$P(Name,"-",2,$L(Name,"-"))
			s Name=$TR(Name,"-")
			;用作放助记码的地方
			s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
			s CTContactName=$ZCVT(CTContactName,"U")
			i CTContactName="" s CTContactName=CTContactNameTem
			s QuitFlag=0
			if (Desc'="")&&((Name'[(Desc))&&(CTContactName'[(Desc))) s QuitFlag=1
			if (UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,rowid)) s QuitFlag=1
			
			if QuitFlag=0 {
				set Data=$lb(ID,Name,CTContactName)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}elseif (Type="USER"){
		s DocID=0
		for {
			s DocID=$O(^CTPCP(DocID))
			q:DocID=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_CareProv",DocID,HospID)
	  		continue:showflag="N"
			s DocActive=$P(^CTPCP(DocID,1),"^",9)
			continue:DocActive'="Y"
			s Name=$P(^CTPCP(DocID,1),"^",2)
			s Code=$P(^CTPCP(DocID,1),"^",1)
			s OtherName=$P(^CTPCP(DocID,3),"^",28)
			continue:(Desc'="")&(Name'[Desc)&(Code'[Desc)
			s ID=DocID
			set Data=$lb(ID,Name,OtherName)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			}
		/*s USRRowId=""
		f  s USRRowId=$o(^SSU("SSUSR",USRRowId)) q:USRRowId=""  d
		.s SSUSRHospitalDR=$p($g(^SSU("SSUSR",USRRowId)),"^",98)
		.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",USRRowId,HospID)
		.s USRActive=$p(^SSU("SSUSR",USRRowId),"^",19)
		.q:USRActive'="Y"
		.s USRName=$p(^SSU("SSUSR",USRRowId),"^",2)
		.s USRInitials=$p(^SSU("SSUSR",USRRowId),"^",1)
		.q:(Desc'="")&(USRName'[Desc)&(USRInitials'[Desc)
		.s Name=USRName
		.s ID=USRRowId
		.set Data=$lb(ID,Name)
		.Set ^CacheTemp(repid,ind)=Data
		.Set ind=ind+1	*/
		}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryTempListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTempListExecute ]
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

ClassMethod QueryTempListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTempListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
