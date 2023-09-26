Import SQLUser

Class web.DHCICUDigitalSignLog Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(web.DHCICUDigitalSignLog).InsertICUSignLog(2,3,4,5,6,7,1,9,10)
ClassMethod InsertICUSignLog(ICUDSLInfo) As %String
{
	    s ICUDSLSignDr=$p(ICUDSLInfo,$C(3),1)
		q:ICUDSLSignDr="" "签名不能为空!"
		s ICUDSLUserDr=$p(ICUDSLInfo,$C(3),2)
	    q:ICUDSLUserDr="" "用户ID不能为空!"
	    s ICUDSLADMDr=$p(ICUDSLInfo,$C(3),3)
	    q:ICUDSLADMDr="" "就诊号不能为空!"
	    s ICUDSLICUADr=$p(ICUDSLInfo,$C(3),4)
		q:ICUDSLICUADr="" "重症排班ID不能为空!"
		s ICUDSLDocumentCode=$p(ICUDSLInfo,$C(3),5)
		s ICUDSLContentHash=$p(ICUDSLInfo,$C(3),6)
		s ICUDSLIsValid=$p(ICUDSLInfo,$C(3),7)
		s ICUDSLStartDate=$p(ICUDSLInfo,$C(3),8)
		s ICUDSLStartTime=$p(ICUDSLInfo,$C(3),9)
		s ICUDSLEndDate=$p(ICUDSLInfo,$C(3),10)
		s ICUDSLEndTime=$p(ICUDSLInfo,$C(3),11)
		s ICUDSLType=$p(ICUDSLInfo,$C(3),12)
		q:ICUDSLType="" "签名类型不能为空!"
		;s ICUDSLCreateDate=$p(ICUDSLInfo,$C(3),13)
		;s ICUDSLCreateTime=$p(ICUDSLInfo,$C(3),14)
		
	    s ICUDSLStartDate=##class(web.DHCClinicCom).ConvertToDateH(ICUDSLStartDate)
	    s ICUDSLStartTime=##class(web.DHCClinicCom).ConvertToTimeH(ICUDSLStartTime)
	    
	    s ICUDSLEndDate=##class(web.DHCClinicCom).ConvertToDateH(ICUDSLEndDate)
	    s ICUDSLEndTime=##class(web.DHCClinicCom).ConvertToTimeH(ICUDSLEndTime)
	    
	    ;s ICUDSLCreateDate=##class(web.DHCClinicCom).ConvertToDateH(ICUDSLCreateDate)
	    ;s ICUDSLCreateTime=##class(web.DHCClinicCom).ConvertToTimeH(ICUDSLCreateTime)
	    s ICUDSLCreateDate=$p($h,",",1)
	    s ICUDSLCreateTime=$p($h,",",2)
	    
	    k PLIST
	    TSTART

        s PLIST(2)=ICUDSLSignDr
	    s PLIST(3)=ICUDSLUserDr
	    s PLIST(4)=ICUDSLADMDr
	    s PLIST(5)=ICUDSLICUADr
        s PLIST(6)=ICUDSLDocumentCode 
	    s PLIST(7)=ICUDSLContentHash
	    s PLIST(8)=ICUDSLIsValid 
	    s PLIST(9)=ICUDSLStartDate
	    s PLIST(10)=ICUDSLStartTime
	    s PLIST(11)=ICUDSLEndDate
	    s PLIST(12)=ICUDSLEndTime
	    s PLIST(13)=ICUDSLType
	    s PLIST(14)=ICUDSLCreateDate
	    s PLIST(15)=ICUDSLCreateTime
	    
	    
		&SQL(insert into DHC_ICU_DigitalSignLog values :PLIST())
	    i SQLCODE
	    {
		    TROLLBACK
		    q SQLCODE	
	    }
	
        TCOMMIT
	    q SQLCODE
}

ClassMethod UpdateICUSignLog(ICUDSLInfo, SignId) As %String
{
	    s ICUDSLSignDr=$p(ICUDSLInfo,$C(3),1)
		q:ICUDSLSignDr="" "签名不能为空"
		s ICUDSLUserDr=$p(ICUDSLInfo,$C(3),2)
	    q:ICUDSLUserDr="" "用户ID不能为空"
	    s ICUDSLADMDr=$p(ICUDSLInfo,$C(3),3)
	    q:ICUDSLADMDr="" "就诊号不能为空"
	    s ICUDSLICUADr=$p(ICUDSLInfo,$C(3),4)
		q:ICUDSLICUADr="" "重症排班ID不能为空"
		s ICUDSLDocumentCode=$p(ICUDSLInfo,$C(3),5)
		s ICUDSLContentHash=$p(ICUDSLInfo,$C(3),6)
		s ICUDSLIsValid=$p(ICUDSLInfo,$C(3),7)
		s ICUDSLStartDate=$p(ICUDSLInfo,$C(3),8)
		s ICUDSLStartTime=$p(ICUDSLInfo,$C(3),9)
		s ICUDSLEndDate=$p(ICUDSLInfo,$C(3),10)
		s ICUDSLEndTime=$p(ICUDSLInfo,$C(3),11)
		s ICUDSLType=$p(ICUDSLInfo,$C(3),12)
		q:ICUDSLType="" "签名类型不能为空!"
		;s ICUDSLCreateDate=$p(ICUDSLInfo,$C(3),13)
		;s ICUDSLCreateTime=$p(ICUDSLInfo,$C(3),14)
		
	    s ICUDSLStartDate=##class(web.DHCClinicCom).ConvertToDateH(ICUDSLStartDate)
	    s ICUDSLStartTime=##class(web.DHCClinicCom).ConvertToTimeH(ICUDSLStartTime)
	    
	    s ICUDSLEndDate=##class(web.DHCClinicCom).ConvertToDateH(ICUDSLEndDate)
	    s ICUDSLEndTime=##class(web.DHCClinicCom).ConvertToTimeH(ICUDSLEndTime)
	    
	    ;s ICUDSLCreateDate=##class(web.DHCClinicCom).ConvertToDateH(ICUDSLCreateDate)
	    ;s ICUDSLCreateTime=##class(web.DHCClinicCom).ConvertToTimeH(ICUDSLCreateTime)
	    s ICUDSLCreateDate=$p($h,",",1)
	    s ICUDSLCreateTime=$p($h,",",2)
	    
	    k PLIST
	    TSTART

        s PLIST(2)=ICUDSLSignDr
	    s PLIST(3)=ICUDSLUserDr
	    s PLIST(4)=ICUDSLADMDr
	    s PLIST(5)=ICUDSLICUADr
        s PLIST(6)=ICUDSLDocumentCode 
	    s PLIST(7)=ICUDSLContentHash
	    s PLIST(8)=ICUDSLIsValid 
	    s PLIST(9)=ICUDSLStartDate
	    s PLIST(10)=ICUDSLStartTime
	    s PLIST(11)=ICUDSLEndDate
	    s PLIST(12)=ICUDSLEndTime
	    s PLIST(13)=ICUDSLType
	    s PLIST(14)=ICUDSLCreateDate
	    s PLIST(15)=ICUDSLCreateTime
	    
	    
		&SQL(insert into DHC_ICU_DigitalSignLog values :PLIST())
	    i SQLCODE
	    {
		    TROLLBACK
		    q SQLCODE	
	    }
	    s ret="0"
	    &SQL(update SQLUSER.DHC_ICU_DigitalSignLog set ICUDSL_IsValid=:ret where ICUDSL_RowId=:SignId )
	
        TCOMMIT
	    q SQLCODE
}

ClassMethod DeleteICUSignLog(SignId) As %String
{
	q:SignId="" "请选选择需要删除的记录!"
	s ret="0"
	&SQL(update SQLUSER.DHC_ICU_DigitalSignLog set ICUDSL_IsValid=:ret where ICUDSL_RowId=:SignId )
	q:SQLCODE'=0 "更新排班表出错!"
	q "0"
}

/*
Query GetICUSignLog(icuaId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID As Id,
	   ICUDSL_Sign_Dr As SignDr,
	   ICUDSL_User_Dr As UserDr,
	   ICUDSL_ADM_Dr As AdmDr,
	   ICUDSL_ICUA_Dr As IcuaDr,
	   ICUDSL_DocumentCode As DocumentCode,
	   ICUDSL_ContentHash As ContentHash,
	   ICUDSL_IsValid As IsValid,
	   ICUDSL_StartDate As StartDate,
	   ICUDSL_StartTime As StartTime,
	   ICUDSL_EndDate As EndDate,
	   ICUDSL_EndTime As EndTime,
	   ICUDSL_Type As Type,
	   ICUDSL_CreateDate As CreateDate,
	   ICUDSL_CreateTime As CreateTime FROM DHC_ICU_DigitalSignLog WHERE ICUDSL_ICUA_Dr=:icuaId
}
*/
Query GetICUSignLog(icuaId) As %Query(ROWSPEC = "Id,SignDr,UserDr,UserDesc,AdmDr,IcuaDr,DocumentCode,ContentHash,IsValid,StartDate,StartTime,EndDate,EndTime,Type,CreateDate,CreateTime")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUDigitalSignLog","GetICUSignLog","28")
ClassMethod GetICUSignLogExecute(ByRef qHandle As %Binary, icuaId) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	k ^TempSort("GetICUSignLog")
 	
 	q:icuaId="" "重症排班Id不能为空"
 	i ($d(^DHCICUDigitalSignLog(0,"ICUADocCode"))=0) Set qHandle=$lb(0,repid,0) Quit $$$OK
	    
		s DocumentCode=""
		f  s DocumentCode=$o(^DHCICUDigitalSignLog(0,"ICUADocCode",icuaId,DocumentCode)) q:DocumentCode=""  d
		.s CASignId=""
		.f  s CASignId=$o(^DHCICUDigitalSignLog(0,"ICUADocCode",icuaId,DocumentCode,CASignId)) q:CASignId=""  d
		..s SignDr=$li(^DHCICUDigitalSignLog(CASignId),1)
		..s UserDr=$li(^DHCICUDigitalSignLog(CASignId),2)
		..s UserInfo=##class(web.DHCICUCom).GetUserTypeName(UserDr)
		..s UserDesc=$p(UserInfo,"^",2)
		..s AdmDr=$li(^DHCICUDigitalSignLog(CASignId),3)
		..s IcuaDr=$li(^DHCICUDigitalSignLog(CASignId),4)
		..q:IcuaDr'=icuaId
		..s DocumentCode=$li(^DHCICUDigitalSignLog(CASignId),5)
		..s ContentHash=$li(^DHCICUDigitalSignLog(CASignId),6)
		..s IsValid=$li(^DHCICUDigitalSignLog(CASignId),7)
		..q:IsValid=0
		..s StartDateH=$li(^DHCICUDigitalSignLog(CASignId),8)
		..s StartDate=##class(web.DHCClinicCom).ConvertToDate(StartDateH)
		..s StartTimeH=$li(^DHCICUDigitalSignLog(CASignId),9)
		..s StartTime=##class(web.DHCClinicCom).ConvertToTime(StartTimeH)
		..s EndDate=$li(^DHCICUDigitalSignLog(CASignId),10)
		..s EndDate=##class(web.DHCClinicCom).ConvertToDate(EndDate)
		..s EndTime=$li(^DHCICUDigitalSignLog(CASignId),11)
		..s EndTime=##class(web.DHCClinicCom).ConvertToTime(EndTime)
		..s Type=$li(^DHCICUDigitalSignLog(CASignId),12)
		..s CreateDate=$li(^DHCICUDigitalSignLog(CASignId),13)
		..s CreateDate=##class(web.DHCClinicCom).ConvertToDate(CreateDate)
		..s CreateTime=$li(^DHCICUDigitalSignLog(CASignId),14)
		..s CreateTime=##class(web.DHCClinicCom).ConvertToTime(CreateTime)
		..s ^TempSort("GetICUSignLog",StartDateH,StartTimeH,CASignId)=$lb(CASignId,SignDr,UserDr,UserDesc,AdmDr,IcuaDr,DocumentCode,ContentHash,IsValid,StartDate,StartTime,EndDate,EndTime,Type,CreateDate,CreateTime)
		
		s StartDateH="",StartTimeH="",CASignId=""
		f  s StartDateH=$o(^TempSort("GetICUSignLog",StartDateH)) q:StartDateH=""  d
		.f  s StartTimeH=$o(^TempSort("GetICUSignLog",StartDateH,StartTimeH)) q:StartTimeH=""  d
		..f  s CASignId=$o(^TempSort("GetICUSignLog",StartDateH,StartTimeH,CASignId)) q:CASignId=""  d
		...d outrow
		
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
		
outrow
    //set Data=$lb(CASignId,SignDr,UserDr,UserDesc,AdmDr,IcuaDr,DocumentCode,ContentHash,IsValid,StartDate,StartTime,EndDate,EndTime,Type,CreateDate,CreateTime)
    set Data=^TempSort("GetICUSignLog",StartDateH,StartTimeH,CASignId)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetICUSignLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICUSignLogExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetICUSignLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICUSignLogExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// w ##class(web.DHCICUDigitalSignLog).FindICUSignLog("5")
ClassMethod FindICUSignLog(ICUDSLICUADr) As %String
{
		q:ICUDSLICUADr="" "重症排班Id不能为空"
		s ICUDSLDocumentCode=""
		;b ;
		f  s ICUDSLDocumentCode=$o(^DHCICUDigitalSignLog(0,"ICUADocCode",ICUDSLICUADr,ICUDSLDocumentCode)) q:ICUDSLDocumentCode=""  d
		.s CASignId=""
		.;b ;w ICUDSLDocumentCode
		.f  s CASignId=$o(^DHCICUDigitalSignLog(0,"ICUADocCode",ICUDSLICUADr,ICUDSLDocumentCode,CASignId)) q:CASignId=""  d
		..;b ;w CASignId
		..s ICUDSLSignDr=$li(^DHCICUDigitalSignLog(CASignId),1)
		..s ICUDSLUserDr=$li(^DHCICUDigitalSignLog(CASignId),2)
		
		s ret=ICUDSLICUADr_"^"_ICUDSLSignDr_"^"_ICUDSLUserDr
		q ret
}

ClassMethod GetStartTime(icuaId) As %String
{
	q:icuaId="" ""
 	q:(($d(^DHCICUDigitalSignLog(0,"ICUADocCode"))=0)||($d(^DHCICUDigitalSignLog(0,"ICUADocCode",icuaId))=0)) ""
	   
		
		s DocumentCode=""
		;b ;
		f  s DocumentCode=$o(^DHCICUDigitalSignLog(0,"ICUADocCode",icuaId,DocumentCode)) q:DocumentCode=""  d
		.s CASignId=""
		.;b ;w ICUDSLDocumentCode
		.s CASignId=$o(^DHCICUDigitalSignLog(0,"ICUADocCode",icuaId,DocumentCode,CASignId),-1)
		.b ;w CASignId
		.s EndDate=$li(^DHCICUDigitalSignLog(CASignId),10)
		.s EndDate=##class(web.DHCClinicCom).ConvertToDate(EndDate)
		.s EndTime=$li(^DHCICUDigitalSignLog(CASignId),11)
		.s EndTime=##class(web.DHCClinicCom).ConvertToTime(EndTime) 
		s ret=EndDate_" "_EndTime
		q ret
}

/// w ##class(web.DHCICUDigitalSignLog).GetUserType(383)
ClassMethod GetUserType(locId) As %String
{
	q:locId=""
	
	s ret=""
	s rowId=""
	f  s rowId=$o(^DHCICUSet("ICURecord","LocId",locId,rowId)) q:rowId=""  d
	.s code=$p(^DHCICUSet("ICURecord","LocId",locId,rowId),"^",1)
	.s desc=$p(^DHCICUSet("ICURecord","LocId",locId,rowId),"^",2)
	.i ret="" d
	..s ret=desc
	.e  d
	..s ret=ret_"^"_desc
	
	q ret
}

/// w ##class(web.DHCICUDigitalSignLog).SetUserType()
ClassMethod SetUserType() As %String
{
	s ^DHCICUSet("ICURecord","LocId",40,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",40,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",40,3)="3^小夜班"     //危重症内部科护理病区
	s ^DHCICUSet("ICURecord","LocId",40,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",40,5)="5^护士长"
	
	/*
	s ^DHCICUSet("ICURecord","LocId",262,1)="1^早班"
	s ^DHCICUSet("ICURecord","LocId",262,2)="2^小夜班"
	s ^DHCICUSet("ICURecord","LocId",262,3)="3^大夜班"
	s ^DHCICUSet("ICURecord","LocId",262,4)="4^主班"
	s ^DHCICUSet("ICURecord","LocId",262,5)="5^白班"          //心外
	s ^DHCICUSet("ICURecord","LocId",262,6)="6^夜班"
	s ^DHCICUSet("ICURecord","LocId",262,7)="7^晚班"
	s ^DHCICUSet("ICURecord","LocId",262,8)="8^两头班"
	s ^DHCICUSet("ICURecord","LocId",262,9)="9^中班"
	s ^DHCICUSet("ICURecord","LocId",262,10)="10^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",1035,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",1035,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",1035,3)="3^小夜班"     //二病区
	s ^DHCICUSet("ICURecord","LocId",1035,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",1035,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",225,1)="1^早班"
	s ^DHCICUSet("ICURecord","LocId",225,2)="2^白班"
	s ^DHCICUSet("ICURecord","LocId",225,3)="3^夜班"
	s ^DHCICUSet("ICURecord","LocId",225,4)="4^小夜班"     //脑科
	s ^DHCICUSet("ICURecord","LocId",225,5)="5^大夜班"
	s ^DHCICUSet("ICURecord","LocId",225,6)="6^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",294,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",294,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",294,3)="3^小夜班"      //一病区
	s ^DHCICUSet("ICURecord","LocId",294,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",294,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",451,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",451,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",451,3)="3^小夜班"      //东区
	s ^DHCICUSet("ICURecord","LocId",451,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",451,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",494,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",494,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",494,3)="3^小夜班"      //黄岛
	s ^DHCICUSet("ICURecord","LocId",494,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",494,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",264,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",264,2)="2^小夜班"
	s ^DHCICUSet("ICURecord","LocId",264,3)="3^大夜班"
	s ^DHCICUSet("ICURecord","LocId",264,4)="4^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",582,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",582,2)="2^小夜班"
	s ^DHCICUSet("ICURecord","LocId",582,3)="3^大夜班"
	s ^DHCICUSet("ICURecord","LocId",582,4)="4^护士长"
	
	//s ^DHCICUSet("ICURecord","LocId",582,5) = "5^夜班"  
	
	s ^DHCICUSet("ICURecord","LocId",1376,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",1376,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",1376,3)="3^小夜班"      //器官移植中心病区
	s ^DHCICUSet("ICURecord","LocId",1376,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",1376,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",1634,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",1634,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",1634,3)="3^小夜班"      //黄岛二病区
	s ^DHCICUSet("ICURecord","LocId",1634,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",1634,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",1640,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",1640,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",1640,3)="3^小夜班"      //黄岛儿科二病区
	s ^DHCICUSet("ICURecord","LocId",1640,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",1640,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",383,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",383,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",383,3)="3^小夜班"      //东区新生儿病区
	s ^DHCICUSet("ICURecord","LocId",383,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",383,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",1525,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",1525,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",1525,3)="3^小夜班"      //黄岛心血管外科
	s ^DHCICUSet("ICURecord","LocId",1525,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",1525,5)="5^护士长"
	
	s ^DHCICUSet("ICURecord","LocId",1785,1)="1^白班"
	s ^DHCICUSet("ICURecord","LocId",1785,2)="2^夜班"
	s ^DHCICUSet("ICURecord","LocId",1785,3)="3^小夜班"      //急诊
	s ^DHCICUSet("ICURecord","LocId",1785,4)="4^大夜班"
	s ^DHCICUSet("ICURecord","LocId",1785,5)="5^护士长"
	*/
	
	q 0
}

}
