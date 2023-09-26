Class DHCLIS.DHCBDAgreeFormInterface Extends %RegisteredObject
{

/// Creator：      zyx
/// CreatDate：    20191224
/// Description:： 获取血型组
/// Input：        
/// Output：       
/// Output：       
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDAgreeFormInterface","QryBloodGroup","","","","","","","","","","","","","","","")	
Query QryBloodGroup(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "code,cName")
{
}

ClassMethod QryBloodGroupExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	
    S ^TMPLISBLD("QryBloodGroup")=Sessions
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationID=$p(Sessions,"^",3)
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1

	s repid=$i(^CacheTemp)
	If $g(ind)="" Set ind=1
	s LisNamespace="dhc-lisdata"
	s CurNamespace=$zu(5)
    S BBloodGroupDR=""
    F  S BBloodGroupDR=$O(^|LisNamespace|dbo.BBBloodGroupD(BBloodGroupDR)) Q:BBloodGroupDR=""  D
    .S BBBloodGroupInfo=$g(^|LisNamespace|dbo.BBBloodGroupD(BBloodGroupDR))
    .S Active=$LG(BBBloodGroupInfo,8)
    .i Active'=1 q
    .s RowID=BBloodGroupDR
    .s Code=$LG(BBBloodGroupInfo,2)
    .s CName=$LG(BBBloodGroupInfo,3)
    .d OutPut
	

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

	
OutPut
	Set RowCount=RowCount+1
	i FormRow>0,ToRow>0,FormRow>RowCount q
	i FormRow>0,ToRow>0,ToRow<RowCount q

	Set Data=$lb(Code,CName)
    set ColFields="code,cName" 
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryBloodGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBloodGroupExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBloodGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBDTransTypeExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      zyx
/// CreatDate：    20191224
/// Description:： 获取输血方式
/// Input：        
/// Output：       
/// Output：       
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDAgreeFormInterface","QryBDTransType","","","","","","","","","","","","","","","")	
Query QryBDTransType(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "code,cName")
{
}

ClassMethod QryBDTransTypeExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	
    S ^TMPLISBLD("QryBDTransType")=Sessions
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationID=$p(Sessions,"^",3)
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1

	s repid=$i(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	//定义输血方式，因lis在dll中枚举输血方式 无法通过m自动获取枚举,所以手动在m中定义
	s AgreeFormTransfusionMode("10")="异体"
	s AgreeFormTransfusionMode("20")="自体"
	s code=""
	f  s code=$o(AgreeFormTransfusionMode(code)) q:code=""  d
    .s cName=$g(AgreeFormTransfusionMode(code))
    .d OutPut   

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

	
OutPut
	Set RowCount=RowCount+1
	i FormRow>0,ToRow>0,FormRow>RowCount q
	i FormRow>0,ToRow>0,ToRow<RowCount q

	Set Data=$lb(code,cName)
    set ColFields="code,cName" 
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryBDTransTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBDTransTypeExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBDTransTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBDTransTypeExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      zyx
/// CreatDate：    20191224
/// Description:： 获取申请血产品
/// Input：        
/// Output：       
/// Output：       
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDAgreeFormInterface","QryBDReqProduct","","","","","","","","","","","","","","","")	
Query QryBDReqProduct(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod QryBDReqProductExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	
    S ^TMPLISBLD("QryBDReqProduct")=Sessions
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationID=$p(Sessions,"^",3)
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	
	s repid=$i(^CacheTemp)
	If $g(ind)="" Set ind=1

	s LisNamespace="dhc-lisdata"
	s CurNamespace=$zu(5)
    S ReqProductDR=""
    F  S ReqProductDR=$O(^|LisNamespace|dbo.BBReqProductD(ReqProductDR)) Q:ReqProductDR=""  D
    .S ReqProductInfo=$g(^|LisNamespace|dbo.BBReqProductD(ReqProductDR))
    .S Active=$LG(ReqProductInfo,11)
    .i Active'=1 q
    .s RowID=ReqProductDR
    .s Code=$LG(ReqProductInfo,2)
    .s CName=$LG(ReqProductInfo,3)
    .d OutPut 
  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

	
OutPut
	Set RowCount=RowCount+1
	i FormRow>0,ToRow>0,FormRow>RowCount q
	i FormRow>0,ToRow>0,ToRow<RowCount q

	Set Data=$lb(RowID,Code,CName)
    set ColFields="RowID,Code,CName" 
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryBDReqProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBDReqProductExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBDReqProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBDReqProductExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      zyx
/// CreatDate：    20191224
/// Description:： 获取输血目的
/// Input：        
/// Output：       
/// Output：       
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDAgreeFormInterface","QryBDTransPurpose","","","","","","","","","","","","","","","")	
Query QryBDTransPurpose(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,code,cName")
{
}

ClassMethod QryBDTransPurposeExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	
    S ^TMPLISBLD("QryBDTransPurpose")=Sessions
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationID=$p(Sessions,"^",3)
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	
	s repid=$i(^CacheTemp)
	If $g(ind)="" Set ind=1

	s LisNamespace="dhc-lisdata"
	s CurNamespace=$zu(5)
    S BBPurposeDR=""
    F  S BBPurposeDR=$O(^|LisNamespace|dbo.BBPurposeD(BBPurposeDR)) Q:BBPurposeDR=""  D
    .S BBPurposeInfo=$g(^|LisNamespace|dbo.BBPurposeD(BBPurposeDR))
    .S Active=$LG(BBPurposeInfo,5)
    .i Active'=1 q
    .s RowID=BBPurposeDR
    .s code=$LG(BBPurposeInfo,2)
    .s cName=$LG(BBPurposeInfo,3)
    .d OutPut 
  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

	
OutPut
	Set RowCount=RowCount+1
	i FormRow>0,ToRow>0,FormRow>RowCount q
	i FormRow>0,ToRow>0,ToRow<RowCount q

	Set Data=$lb(RowID,code,cName)
    set ColFields="RowID,code,cName" 
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryBDTransPurposeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBDTransPurposeExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBDTransPurposeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBDTransPurposeExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      zyx
/// CreatDate：    20191224
/// Description:： 通过就诊号及检测项目标准码获取项目最近一次检验结果
/// Input：        AdmNo就诊号, SCode标准码, Days时效
/// Output：       TestCode项目代码，TestCodeName项目名称，Result结果值，Unit单位，AbFlag异常标志，RefRanges正常值范围，AuthDate审核日期。
/// Output：       
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDAgreeFormInterface","QryBDReqProduct","","","","","","","","","","","","","","","")	
Query QryBTResultByAdmNoSCode(AdmNo, SCode, Days, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "TestCode,TestCodeName,Result,Unit,AbFlag,RefRanges,AuthDate")
{
}

ClassMethod QryBTResultByAdmNoSCodeExecute(ByRef qHandle As %Binary, AdmNo, SCode, Days, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	//记录入参
    S ^TMPLISBLD("QryBTResultByAdmNoSCode")=$lb(AdmNo, SCode, Days)
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationID=$p(Sessions,"^",3)
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1

	s repid=$i(^CacheTemp)
	If $g(ind)="" Set ind=1

	s LisNamespace="DHC-LISDATA"
	s CurNamespace=$zu(5)
	
    //初始化入参
	s SCode = $zcvt($g(SCode),"U"),AdmNo = $g(AdmNo) ,Days = $g(Days)
	s (AuthDateSign,AuthTimeSign,RetResultStr)=""
	s (TestCode,TestCodeName,Result,Unit,AbFlag,RefRanges,AuthDate)=""
	s IndexScode=##Class(LIS.Util.Common).IndexData(SCode)
	s IndexAdmNo=##Class(LIS.Util.Common).IndexData(AdmNo)
	s TestCodeDR="" 
	for {
		s TestCodeDR=$o(^dbo.BTTestCodeI("IndexSCode",IndexScode,TestCodeDR)) 
		q:(TestCodeDR="")
		s AuthDate=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",IndexAdmNo,TestCodeDR,""),-1)
		continue:'$l(AuthDate) 
		continue:AuthDate<0
		//continue:(Days>0)&&(AuthDate<(+$H-Days))
		s AuthTime=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",IndexAdmNo,TestCodeDR,AuthDate,""),-1)
		continue:'$l(AuthTime)
		continue:AuthTime<0
		s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexAdmItem",IndexAdmNo,TestCodeDR,AuthDate,AuthTime,""))
		i '$l(ResultDR) continue
		
		//时间校验
		i (Days>0) {
			s ReportAuthDate = $ZDH($e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8),3)
			s DaysDiff = ((+$h-ReportAuthDate)+(($p($h,",",2)-AuthTime)/(60*60*24)))
			i DaysDiff>Days continue
		}
		
		i $l(AuthDateSign),(AuthDateSign>AuthDate) continue
		i $l(AuthDateSign),(AuthDateSign=AuthDate),(AuthTimeSign>AuthTime) continue
		//标志为最后一次的结果时间
		s AuthDateSign=AuthDate
		s AuthTimeSign=AuthTime
		
		s ResultData=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
		s Result=$lg(ResultData,5)
		s ExtraRes=$lg(ResultData,6)
		//i $l(ExtraRes) s Result=Result_"("_ExtraRes_")"
		s Unit=$lg(ResultData,11) 
		s AbFlag=$lg(ResultData,9)
		s RefRanges=$lg(ResultData,12)  
		s ResNoes=$lg(ResultData,8)
		s VisitNumberReportDR = $lg(ResultData,2)
		s VisitNumberReportData = $g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
		s AuthUserDR = $lg(VisitNumberReportData,21)
		s AuthUserName=""
		i $l(AuthUserDR) s AuthUserName=$lg(^dbo.SYSUserD(AuthUserDR),3)
		s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
		s TestCode=$lg(TestCodeData,2)
		s TestCodeName=$lg(TestCodeData,3)
	    d OutPut 
	}
    
  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

	
OutPut
	Set RowCount=RowCount+1
	i FormRow>0,ToRow>0,FormRow>RowCount q
	i FormRow>0,ToRow>0,ToRow<RowCount q

	Set Data=$lb(TestCode,TestCodeName,Result,Unit,AbFlag,RefRanges,AuthDate)
    set ColFields="TestCode,TestCodeName,Result,Unit,AbFlag,RefRanges,AuthDate" 
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryBTResultByAdmNoSCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBTResultByAdmNoSCodeExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBTResultByAdmNoSCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBTResultByAdmNoSCodeExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CreatDate：    20191224
/// Description:： 查询患者既往史数据
/// Table：        BD_ReqForm
/// Input：        AdmNo就诊号
/// Output：       IsTransHistory,LastTransDate,IsUntowardEffect,UntowardEffectNote,IsOrganExplant
///                OrganBloodGroupDR,IsKeestExplant,KeestBloodGroupDR,IsDrugHistory,DrugList,IsPregHistory
///                Pregnancies,ChildBirths,OrganBloodGroup,KeestBloodGroup,
///                (既往史，最近输血日期，不良反应，不良反应说明，器官移植)
///                (器官移植供血者血型DR，骨髓移植,骨髓移植供血者血型DR，特殊药物，药物说明，孕产史)                  
///                (孕次，产次，"",器官移植供血者血型,骨髓移植供血者血型)
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDAgreeFormInterface","QryPastHistoryInfo","37","","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryPastHistoryInfo(AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "IsTransHistory,LastTransDate,IsUntowardEffect,UntowardEffectNote,IsOrganExplant,OrganBloodGroupDR,IsKeestExplant,KeestBloodGroupDR,IsDrugHistory,DrugList,IsPregHistory,Pregnancies,ChildBirths,OrganBloodGroup,KeestBloodGroup")
{
}

ClassMethod QryPastHistoryInfoExecute(ByRef qHandle As %Binary, AdmNo, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	s obj=##Class(LIS.Core.Patient).OpenId(AdmNo)
 	s fRegNo=obj.PatientId 
 	i $l(fRegNo) {
	 	s fReqFormDR = $o(^dbo.BDReqFormI("IndexRegNo",##Class(LIS.Util.Common).IndexData(fRegNo),""),-1)
	 	//申请单既往史
	 	b ;09
	 	i $l(fReqFormDR) {
		 	s (AddUserName,OrganBloodGroup,KeestBloodGroup,ReceiveUserName,WorkGroupName) = ""
		 	s ReqFormData = $g(^dbo.BDReqFormD(fReqFormDR))
			s AddUserDR = $lg(ReqFormData,7)
			s OrganBloodGroupDR = $lg(ReqFormData,32)
			s KeestBloodGroupDR = $lg(ReqFormData,34)
			s ReceiveUserDR = $lg(ReqFormData,70)
			s WorkGroupDR = $lg(ReqFormData,71)
			s SpeciesDR = $lg(ReqFormData,12)
			s ReqTypeDR = $lg(ReqFormData,3)
			s (ReqTypeName,ReqTypeCode)=""
			i $l(ReqTypeDR) {
				s ReqTypeCode = $lg(^dbo.BBReqTypeD(ReqTypeDR),2)
				s ReqTypeName = $lg(^dbo.BBReqTypeD(ReqTypeDR),3)
			}
			s Sex = ""
			i $l(SpeciesDR) s Sex = $lg(^dbo.BTSpeciesD(SpeciesDR),3)
			s WardDR = $lg(ReqFormData,24)
			s Ward=""
			i $l(WardDR) s Ward = $lg(^dbo.BTWardD(WardDR),3)
			i $l(Ward,"-")>1 s Ward = $p(Ward,"-",2)
			s LocationDR= $lg(ReqFormData,23)
			s Location=""
			i $l(LocationDR) s Location = $lg(^dbo.BTLocationD(LocationDR),3)
			i $l(Location,"-")>1 s Location = $p(Location,"-",2)
			i $l(AddUserDR) s AddUserName = $lg($g(^dbo.SYSUserD(AddUserDR)),3)
			i $l(OrganBloodGroupDR) s OrganBloodGroup = $lg($g(^dbo.BBBloodGroupD(OrganBloodGroupDR)),3)
			i $l(KeestBloodGroupDR) s KeestBloodGroup = $lg($g(^dbo.BBBloodGroupD(KeestBloodGroupDR)),3)
			i $l(ReceiveUserDR) s ReceiveUserName = $lg($g(^dbo.SYSUserD(ReceiveUserDR)),3)
			i $l(WorkGroupDR) s WorkGroupName = $lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)
			s CheckUserDR = $lg(ReqFormData,65)
			s CheckUserName=""
			i $l(CheckUserDR) s CheckUserName = $lg($g(^dbo.SYSUserD(CheckUserDR)),3)
			s ABODR = $lg(ReqFormData,18)
			s RHDR = $lg(ReqFormData,19)
			S (ABO,RH)=""
			i $l(ABODR) s ABO = $lg($g(^dbo.BTABOBGD(ABODR)),3)
			i $l(RHDR) s RH = $lg($g(^dbo.BTRHBGD(RHDR)),3)
			
			s RegNo= $lg(ReqFormData,8)
			s IsTransHistory=0
			s LastTransDate=""
			//查询输血史
			i $l(RegNo) {
				s IndexRegNo=##Class(LIS.Util.Common).IndexData(RegNo)
				s IssueRecordDR = ""
				for {
					s IssueRecordDR = $o(^dbo.BDIssueRecordI("IndexRegNo",IndexRegNo,IssueRecordDR),-1)
					q:IssueRecordDR=""
					s IssueRecordData = $g(^dbo.BDIssueRecordD(IssueRecordDR))
					s Status=$lg(IssueRecordData,12)
					//只取发血状态的记录
					i Status="1" {
						s IsTransHistory=1
						s IssueDate = $lg(IssueRecordData,4)
						s IssueTime = $lg(IssueRecordData,5)
						s LastTransDate=IssueDate
						//发血时间24小时计算 过滤
	#;					i (thisDate-IssueDate)>1 q
	#;					i ((thisDate-IssueDate)=1),(thisTime>IssueTime) q
	#;					i (thisDate-IssueDate)<0 q
	#;					
						s PackDR = ""
						for {
							s PackDR = $o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR))
							q:PackDR=""
							s PackData = $g(^dbo.BDPackD(PackDR))
							s PackVolume = $lg(PackData,10)
							s BloodProductDR = $lg(PackData,3)
							s BloodProductData = $g(^dbo.BBBloodProductD(BloodProductDR))
							s BloodComponentsDR = $lg(BloodProductData,10)
							s BloodComponentsData = $g(^dbo.BBBloodComponentsD(BloodComponentsDR))
							s BloodComponentsCName = $lg(BloodComponentsData,3)
							s Units = $lg(BloodProductData,15)
							
						}
						q
					}
				
				}
		 	}
			s $li(ReqFormData,27)=IsTransHistory
			s $li(ReqFormData,28)=LastTransDate
			s Data = $li(ReqFormData,27,39)_$lb(OrganBloodGroup,KeestBloodGroup)
	 		d OutPut
 		} else {
	 		b ;08
	 		//查询知情同意书的既往史信息
	 		s AgreeFormDR = $o(^dbo.BDAgreeFormI("IndexRegNo",##Class(LIS.Util.Common).IndexData(fRegNo),""),-1)
	 		i $l(AgreeFormDR) {
		 		b ;07
		 		s AgreeFormData = $g(^dbo.BDAgreeFormD(AgreeFormDR))
		 		s (AddUserName,OrganBloodGroup,KeestBloodGroup,ReceiveUserName,WorkGroupName) = ""
	 			//ChildBirths,AddUserName,OrganBloodGroup,KeestBloodGroup,ReceiveUserName,WorkGroupName,Sex,Ward,Location,ReqTypeName,ReqTypeCode,CheckUserName,ABO,RH
				s AddUserDR = $lg(AgreeFormData,6)
				i $l(AddUserDR) s AddUserName = $lg($g(^dbo.SYSUserD(AddUserDR)),3)
				s OrganBloodGroupDR = $lg(AgreeFormData,42)
				s KeestBloodGroupDR = $lg(AgreeFormData,44)
				i $l(OrganBloodGroupDR) s OrganBloodGroup = $lg($g(^dbo.BBBloodGroupD(OrganBloodGroupDR)),3)
				i $l(KeestBloodGroupDR) s KeestBloodGroup = $lg($g(^dbo.BBBloodGroupD(KeestBloodGroupDR)),3)
				s Data = $li(AgreeFormData,20,23)_$li(AgreeFormData,41,46)_$li(AgreeFormData,24,26)
	 	
	 			d OutPut
	 		}
 		}
 	}
 	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
    
OutPut
	set ColFields="IsTransHistory,LastTransDate,IsUntowardEffect,UntowardEffectNote,IsOrganExplant,OrganBloodGroupDR,IsKeestExplant,KeestBloodGroupDR,IsDrugHistory,DrugList,IsPregHistory,Pregnancies,ChildBirths,OrganBloodGroup,KeestBloodGroup"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryPastHistoryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPastHistoryInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPastHistoryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPastHistoryInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      zhangyixin
/// CreatDate：    20191224
/// Description:： 
/// Table：        dbo.BDAgreeForm
/// Input：        AdmNo,就诊号
/// Output：       知情同意书检测项目及结果
/// Return：       
/// Others：       
Query QueryAgreeFormTestItem(AgreeFormDR As %String, HospitalDR As %String, AdmNo As %String, RegNo As %String, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "IsPrompt,ResultList,Days,RowID,AgreeFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime")
{
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("DHCLIS.DHCBDAgreeFormInterface","QueryAgreeFormTestItem","10","1","11","","","","","","","","","","","","","")
ClassMethod QueryAgreeFormTestItemExecute(ByRef qHandle As %Binary, AgreeFormDR As %String, HospitalDR As %String, AdmNo As %String, RegNo As %String, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	s ^TMPLISBLD("AGRSZW")=$lb(AgreeFormDR,HospitalDR,AdmNo)
    s AgreeFormDR=$g(AgreeFormDR)
    s HospitalDR=$g(HospitalDR)
    s AdmNo=$g(AdmNo)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	i $l(AgreeFormDR) d
	.i $d(^dbo.BDAgreeFormTestItemI("IndexMaster",AgreeFormDR)) d
	..s TestItemDR="" f  s TestItemDR=$o(^dbo.BDAgreeFormTestItemI("IndexMaster",AgreeFormDR,TestItemDR)) Quit:TestItemDR=""  Do 	
	...s rowId="" f  s rowId=$o(^dbo.BDAgreeFormTestItemI("IndexMaster",AgreeFormDR,TestItemDR,rowId)) Quit:rowId=""  Do 	
	....s IsPrompt=""
	....s ResultList=""
	....s Days=""
	....s agreeItemRowID="" f  s agreeItemRowID=$o(^dbo.BBAgreeTestItemI("IndexMaster",HospitalDR,TestItemDR,agreeItemRowID)) Quit:agreeItemRowID=""  Do 
	.....s agreeItemData=	$g(^dbo.BBAgreeTestItemD(agreeItemRowID))
	.....s IsPrompt=$lg(agreeItemData,4)
	.....s ResultList=$lg(agreeItemData,5)
	.....s Days=$lg(agreeItemData,6)
	....s StrData=$g(^dbo.BDAgreeFormTestItemD(rowId))
	....s TestItemName=""
	....i $l(TestItemDR) d
	.....s TestItemName=$lg($g(^dbo.BBTestItemD(TestItemDR)),3)
	....s RowID=rowId
	....s agreeFormDR=$lg(StrData,2)
	....s TestItemDR=$lg(StrData,3)
	....s Result=$lg(StrData,4)
	....s Unit=$lg(StrData,5)
	....s RefRanges=$lg(StrData,6)
	....s SeqNum=$lg(StrData,7)
	....d OutputRow
	e  i $l(HospitalDR) d
	.s TestItemDR="" f  s TestItemDR=$o(^dbo.BBAgreeTestItemI("IndexMaster",HospitalDR,TestItemDR)) Quit:TestItemDR=""  Do 	
	..s IsPrompt=""
	..s ResultList=""
	..s Days=""
	..s agreeItemRowID="" f  s agreeItemRowID=$o(^dbo.BBAgreeTestItemI("IndexMaster",HospitalDR,TestItemDR,agreeItemRowID)) Quit:agreeItemRowID=""  Do 
	...s agreeItemData=	$g(^dbo.BBAgreeTestItemD(agreeItemRowID))
	...s IsPrompt=$lg(agreeItemData,4)
	...s ResultList=$lg(agreeItemData,5)
	...s Days=$lg(agreeItemData,6)
	..s testItemData=$g(^dbo.BBTestItemD(TestItemDR))
	..s TestItemName=$lg(testItemData,3)
	..s ScCode=$lg(testItemData,4)
	..i $l(ScCode) d
	...S ResultStr=##class(BLD.WS.BLL.DHCTCResult).GetResultBySCodeMTHD(RegNo,ScCode,Days)
	...s Result = $p(ResultStr,$c(2),1)
	...s ExtraRes = $p(ResultStr,$c(2),2)
	...s Unit = $p(ResultStr,$c(2),3)
	...s AbFlag = $p(ResultStr,$c(2),4)
	...s RefRanges = $p(ResultStr,$c(2),5)
	...s ResNoes = $p(ResultStr,$c(2),6)
	...s AuthUserName = $p(ResultStr,$c(2),7)
	...s AuthDate = $p(ResultStr,$c(2),8)
	...s AuthTime = $p(ResultStr,$c(2),9)
	...//判断状态
	...s ResultStatus=""
	...i '$l(Result) s ResultStatus=##class(BLD.WS.BLL.DHCTCResult).GetSCodeResultStatusMTHD(RegNo,ScCode,"","","",HospitalDR,"","","","","","","","",Sessions)
	...//-1未下医嘱 0下医嘱 1采集 2运送 3接收 4上机 5 审核 
	...i '$l(Result),((ResultStatus=3)!(ResultStatus=4)) s Result="检查中"
	...i '$l(Result),((ResultStatus=1)!(ResultStatus=2)) s Result="已采集"
	...s lastData=$lb(IsPrompt,ResultList,Days,RowID,agreeFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime)
 	...d OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
	
OutputRow
    Set Data=$lb(IsPrompt,ResultList,Days,RowID,agreeFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,"","","","")
    Set ColFields="IsPrompt,ResultList,Days,RowID,AgreeFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	quit
OutputRow1
    Set Data=lastData
    Set ColFields="IsPrompt,ResultList,Days,RowID,AgreeFormDR,TestItemDR,TestItemName,Result,Unit,RefRanges,SeqNum,AbFlag,AuthUserName,AuthDate,AuthTime"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	quit
}

ClassMethod QueryAgreeFormTestItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAgreeFormTestItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAgreeFormTestItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAgreeFormTestItemExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
