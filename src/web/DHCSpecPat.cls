Class web.DHCSpecPat Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 患者查询
Query FindPatList(SttDate As %String, EndDate As %String, PatName As %String, PatIDCard As %String, PatListType As %String = "") As %Query(ROWSPEC = "TSPRowId:%String:ID,TPatName:%String:患者姓名,TPatIDCard:%String:身份证号,TPatNote:%String:备注,TPatListTypeId:%String:患者类型ID,TPatListType:%String:患者类型描述,TStDate:%String:开始日期,TEndDate:%String:结束日期,TCreateUser:%String:创建人,TUpdateUser:%String:更新人")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCSpecPat","FindPatList","","","","","")
ClassMethod FindPatListExecute(ByRef qHandle As %Binary, SttDate As %String, EndDate As %String, PatName As %String, PatIDCard As %String, PatListType As %String = "") As %Status
{
	s ^lj("FindPatList")=SttDate_","_EndDate_","_PatName_","_PatIDCard_","_PatListType
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	if SttDate'="" s SttDate=..%ZDH(SttDate)
	if EndDate'="" s EndDate=..%ZDH(EndDate)
	set PatName=$$ALPHAUP^SSUTIL4(PatName)
	set PatIDCard=$$ALPHAUP^SSUTIL4(PatIDCard)
	s SPRowId=0 for {
		s SPRowId=$o(^DHCSP(SPRowId))
		q:SPRowId=""
		s SPName=$p($g(^DHCSP(SPRowId)),"^",1)
		s SPNamePY=""
		i SPName'="" s SPNamePY=##class(web.DHCINSUPort).GetCNCODE(SPName,"4","")
		continue:(PatName'="")&&((SPName'="")&&(SPName'[PatName))&&((SPNamePY'="")&&(SPNamePY'[PatName))
		s SPCredNo=$p($g(^DHCSP(SPRowId)),"^",2)
		continue:(PatIDCard'="")&&(PatIDCard'=SPCredNo)
		s SPNote=$p($g(^DHCSP(SPRowId)),"^",3)
		s SPTypeDr=$p($g(^DHCSP(SPRowId)),"^",4)
		continue:(PatListType'="")&&(PatListType'=SPTypeDr)
		s SPType=$p($g(^DHCPatType(SPTypeDr)),"^",2)
		s SPStDate=$p($g(^DHCSP(SPRowId)),"^",5)
		continue:(SttDate'="")&&(SttDate>SPStDate)
		s SPStDate=..%ZD(SPStDate) //$zd(SPStDate,3)
		s SPEndDate=$p($g(^DHCSP(SPRowId)),"^",6)
		continue:(EndDate'="")&&(SPEndDate'="")&&(EndDate<SPEndDate)
		i SPEndDate'="" s SPEndDate=..%ZD(SPEndDate) //$zd(SPEndDate,3)
		s SPCreateUser=""
		s SPCreateUserDR=$p($g(^DHCSP(SPRowId)),"^",7)
		i SPCreateUserDR'="" s SPCreateUser=$p($g(^SSU("SSUSR",SPCreateUserDR)),"^",2)
		s SPSPUpdateUser=""
		s SPSPUpdateUserDR=$p($g(^DHCSP(SPRowId)),"^",10)
		i SPSPUpdateUserDR'="" s SPSPUpdateUser=$p($g(^SSU("SSUSR",SPSPUpdateUserDR)),"^",2)
		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(SPRowId,SPName,SPCredNo,SPNote,SPTypeDr,SPType,SPStDate,SPEndDate,SPCreateUser,SPSPUpdateUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod FindPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCSpecPat).InsertPatList("R","","642102198003200063","沙海燕")
ClassMethod InsertPatList(PatName As %String, PatIDCard As %String, PatNote As %String, PatListType As %String, SttDate As %String, EndDate As %String, UserID As %String, InSPRowId As %String) As %String
{
	s ExistSPRowId=""
	// 增加身份证的有效性校验
	s flag=##class(DHCDoc.Util.Base).CheckIdCardNo(PatIDCard,.ErrMsg)
	q:flag'="Y" ErrMsg
	s PatName=$$ALPHAUP^SSUTIL4(PatName)
	if (InSPRowId = "") {
		s SPRowId=0
		for{
			s SPRowId=$o(^DHCSP("0","CredNo",PatIDCard,SPRowId)) 
			Q:SPRowId=""
			s SPStDate=$p($g(^DHCSP(SPRowId)),"^",5)
			continue:(SPStDate>(+$h))
			s SPEndDate=$p($g(^DHCSP(SPRowId)),"^",6)
			continue:(SPEndDate'="")&&(SPEndDate<=(+$h))
			s SPTypeDr=$p($g(^DHCSP(SPRowId)),"^",4)
			continue:SPTypeDr'=PatListType
			s ExistSPRowId=SPRowId
			Q
		}
	}
	Q:ExistSPRowId'="" "身份证号："_PatIDCard_" 患者类型："_$p(^DHCPatType(PatListType),"^",2)_" 已存在有效记录！"
	i SttDate'="" s SttDate=..%ZDH(SttDate)
	e  s SttDate=..%SysDate()
	i EndDate'="" s EndDate=..%ZDH(EndDate)
	if (SttDate'="")&&(EndDate'="")&&(SttDate>EndDate) {
		Q "有效开始日期不能大于有效截止日期！"
	}
	if (InSPRowId = "") {
		s object=##class(User.DHCSpecPat).%New()
	} else {
		s object=##class(User.DHCSpecPat).%OpenId(InSPRowId)
	}
	s object.DHCSPName=PatName
	s object.DHCSPCredNo=PatIDCard
	s object.DHCSPNote=PatNote
	d object.DHCSPTypeDRSetObjectId(PatListType)
	s object.DHCSPStDate=SttDate
	s object.DHCSPEndDate=EndDate
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	i (InSPRowId'="") { 
		d object.DHCSPUpdateUserDRSetObjectId(UserID)
		s object.DHCSPUpdateDate =..%SysDate()
		s object.DHCSPUpdateTime=..%SysTime()
	} else {
		d object.DHCSPCreateUserDRSetObjectId(UserID)
		s object.DHCSPCreateDate=..%SysDate()
		s object.DHCSPCreateTime=..%SysTime()
	}
	Set sc=object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q 100
	}
	d object.%Close()
	Q 0
}

/// w ##class(web.DHCSpecPat).UpdatePatList("","")
ClassMethod UpdatePatList(SPRowId As %String, UserID As %String) As %String
{
	q:SPRowId="" "-1"
	Set object=##class(User.DHCSpecPat).%OpenId(SPRowId)
	s EndDate=object.DHCSPEndDate
	if ((EndDate'="")&&(object.DHCSPEndDate<=..%SysDate())){
		d object.%Close()
		q "该记录已经是无效记录!"
	}
	s object.DHCSPEndDate=..%SysDate()-1
	if (object.DHCSPStDate > object.DHCSPEndDate) {
		s object.DHCSPStDate = ..%SysDate()-1
	}
	d object.DHCSPUpdateUserDRSetObjectId(UserID)
	s object.DHCSPUpdateDate=..%SysDate()
	s object.DHCSPUpdateTime=..%SysTime()
	Set sc=object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q 100
	}
	d object.%Close()
	Q 0
}

/// w ##class(web.DHCSpecPat).DeletePatList("","")
ClassMethod DeletePatList(SPRowId As %String) As %String
{
	q:SPRowId="" "-1"
	&SQL(Delete From SQLUser.DHC_SpecPat Where DHCSP_RowID=:SPRowId)
	Q SQLCODE
}

/// 根据患者ID查询患者所属特殊患者类型
ClassMethod GetSpecPatTypeByPat(PatientId As %String) As %String
{
	Q:PatientId="" ""
	s CredNo=$p(^PAPER(PatientId,"ALL"),"^",9) //身份证号
	s Name=$p(^PAPER(PatientId,"ALL"),"^",1) 
	Q ..GetSpecPatTypeByCredNo(CredNo,Name,PatientId)
}

/// 根据身份证号查询患者所属类型
/// w ##class(web.DHCSpecPat).GetSpecPatTypeByCredNo("310106199003077108","lv-浮沉")
ClassMethod GetSpecPatTypeByCredNo(CredNo As %String, Name As %String = "", PatientID As %String = "") As %String
{
	q:(CredNo="")||(PatientID="") ""
	s PatType="",PatTypeExeResult=""
	s SPRowId=0 for{
		s SPRowId=$o(^DHCSP("0","CredNo",CredNo,SPRowId)) 
		q:SPRowId=""
		s SPName=$p($g(^DHCSP(SPRowId)),"^",1)
		continue:(Name'="")&&(SPName'="")&&(Name'=SPName)
		s SPStDate=$p($g(^DHCSP(SPRowId)),"^",5)
		continue:(SPStDate>(+$h))
		s SPEndDate=$p($g(^DHCSP(SPRowId)),"^",6)
		continue:(SPEndDate'="")&&(SPEndDate<(+$h))
		s SPTypeDr=$p($g(^DHCSP(SPRowId)),"^",4)
		if (SPTypeDr'="")&&($d(^DHCPatType(SPTypeDr))) {
			s ExecuteCode=$P(^DHCPatType(SPTypeDr),"^",3)
			i ExecuteCode'="" {
				s Expression=$tr(ExecuteCode,"&","""")
				s Expression="s PatTypeExeResult="_Expression
				X Expression
			}
		}
		i PatType="" s PatType=SPType_";"_PatTypeExeResult
		e  s PatType=PatType_","_SPType_";"_PatTypeExeResult
	}
	q PatType
}

/// 查询患者类型
Query FindPatListType() As %Query(ROWSPEC = "Code:%String,Desc:%String,RowId:%String,ExecCode:%String")
{
}

/// User.DHCPatListType.cls
/// d ##class(%ResultSet).RunQuery("web.DHCSpecPat","FindPatListType")
ClassMethod FindPatListTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s Rowid=0 for {
		s Rowid=$o(^DHCPatType(Rowid))
		q:Rowid=""
		s Code=$p($g(^DHCPatType(Rowid)),"^",1)
		s Desc=$p($g(^DHCPatType(Rowid)),"^",2)
		s ExecCode=$p($g(^DHCPatType(Rowid)),"^",3)
		s Data=$lb(Code,Desc,Rowid,ExecCode)
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindPatListTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatListTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPatListTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatListTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 患者类型插入
/// w ##class(web.DHCSpecPat).InsertPatListType("","App","预约")
ClassMethod InsertPatListType(RowID As %String, Code As %String, Desc As %String, ExecuteCode As %String) As %String
{
	q:(Code="")||(Desc="") ""
	s rtn=""
	if (RowID=""){
		&SQL(insert into SQLUser.DHC_PatListType(DHC_PatTypeCode,DHC_PatTypeDesc,DHC_PatTypeExecCode) Values(:Code,:Desc,:ExecuteCode))
		s rtn=SQLCODE
	}else{
		&SQL(Update SQLUser.DHC_PatListType set DHC_PatTypeCode=:Code,DHC_PatTypeDesc=:Desc,DHC_PatTypeExecCode=:ExecuteCode where DHC_PatTypeRowID=:RowID)
		s rtn=SQLCODE
	}
	q rtn
}

/// 患者类型删除
/// w ##class(web.DHCSpecPat).DeletePatListType("","App","预约")
ClassMethod DeletePatListType(RowID As %String) As %String
{
	q:RowID="" ""
	&SQL(Delete From SQLUser.DHC_PatListType where DHC_PatTypeRowID=:RowID)
	Q SQLCODE
}

/// 导入数据
/// w ##class(web.DHCSpecPat).InsertTmpData("1")
ClassMethod InsertImpData(mListData As %String, UserID As %String) As %String
{
	s $zt="InsertImpDataErr"
	s PatName=$p(mListData,"^",1)
    s PatIDCard=$p(mListData,"^",2)
	s flag=##class(DHCDoc.Util.Base).CheckIdCardNo(PatIDCard,.ErrMsg)
	Q:flag'="Y" ErrMsg
	s PatNote=$p(mListData,"^",3)
    s PatListTypeDesc=$p(mListData,"^",4)
    s PatListTypeDesc=$$ALPHAUP^SSUTIL4(PatListTypeDesc)
    Q:PatListTypeDesc="" "患者类型不能为空"
 	s PatListTypeDr=""
	s TypeRowid=0 for {
		s TypeRowid=$o(^DHCPatType(TypeRowid))
		Q:TypeRowid=""
		s TypeDesc=$p($g(^DHCPatType(TypeRowid)),"^",2)
		continue:TypeDesc'=PatListTypeDesc
		s PatListTypeDr=TypeRowid
	}
    Q:PatListTypeDr="" "患者类型不存在"
		s rtn=##class(web.DHCSpecPat).InsertPatList(PatName,PatIDCard,PatNote,PatListTypeDr,"","",UserID,"")
	Q rtn
InsertImpDataErr
	s $zt=""
	Q "导入异常:"_$ze
}

/// desc:	特殊患者数据导入前校验
/// debug:	w ##class(web.DHCSpecPat).CheckBeforeImport("邢毅扬^610115201010205507^测试数据^特殊患者^2022-07-15")
ClassMethod CheckBeforeImport(excelRow, sessionStr)
{
	s ret = "0"
	s patName = $p(excelRow, "^", 1)
	s patIdCard = $p(excelRow, "^", 2)
	s specTypeDesc = $p(excelRow, "^", 3)
	s remark = $p(excelRow, "^", 4)
	s sttDate = $p(excelRow, "^", 5)
	
	s patName = $$ALPHAUP^SSUTIL4(patName)
	q:patName="" "-1^患者姓名为空"
	if (patIdCard = "") {
		q "-1^身份证号为空"
	} else {
		s vaildFlag = ##class(DHCDoc.Util.Base).CheckIdCardNo(patIdCard, .ErrMsg)
		q:vaildFlag="N" "-1^身份证号无效："_ErrMsg
	}
	s specTypeDesc=$$ALPHAUP^SSUTIL4(specTypeDesc)
    q:specTypeDesc="" "-1^患者类型为空"
 	s specTypeId = ""
	s mSpecTypeId=0 
	for {
		s mSpecTypeId=$o(^DHCPatType(mSpecTypeId))
		q:specTypeId'=""
		q:mSpecTypeId=""
		s mSpecTypeDesc = $p($g(^DHCPatType(mSpecTypeId)), "^", 2)
		continue:mSpecTypeDesc'=specTypeDesc
		s specTypeId = mSpecTypeId
	}
    q:specTypeId="" "-1^患者类型不存在，请参考类型设置中的患者类型"
    
    // 增加数据重复维护校验
    s existSpecPatId = ""
	s specPatId = 0
	for{
		s specPatId=$o(^DHCSP("0","CredNo",patIdCard,specPatId)) 
		q:existSpecPatId'=""
		q:specPatId=""
		s specSttDate = $p($g(^DHCSP(specPatId)), "^", 5)
		// 不应该判断开始日期
		// continue:(specSttDate>(+$h))
		s specEndDate = $p($g(^DHCSP(specPatId)), "^", 6)
		continue:(specEndDate'="")&&(specEndDate <= (+$h))
		s mSpecTypeId=$p($g(^DHCSP(specPatId)), "^", 4)
		continue:mSpecTypeId'=specTypeId
		s existSpecPatId=specTypeId
	}
	if (existSpecPatId '= "") {
		q "身份证号："_patIdCard_"，患者类型："_specTypeDesc_"，已存在有效记录，可查询修改！"
	}
	
    if (sttDate '= "") {
	    s regexp = "^[1-9]\d{3}-((0[1-9])|(1[0-2]))-(([0][1-9])|([1|2]\d)|3[0-1])"
		s matchFlag = $match(sttDate, regexp)
		q:('matchFlag) "-1^开始日期格式不正确"
	    try {
		    s mSttDate = ..%ZDH(sttDate)
	    } catch {
		    s ret = "-1^日期格式不正确"
	    }
    }
    q ret
}

/// desc:	特殊患者数据导入
/// debug:	w ##class(web.DHCSpecPat).InsertTmpData("1")
/// input:	sessionStr 	userId^groupId^ctlocId^hospId^wardId^langId^loginId
ClassMethod ImportData(mListData As %String, sessionStr As %String) As %String
{
	s $zt="ImportDataErr"
	s UserID = $p(sessionStr, "^", 1)
	s PatName=$p(mListData,"^",1)
    s PatIDCard=$p(mListData,"^",2)
    s PatListTypeDesc=$p(mListData,"^",3)
	s PatNote=$p(mListData,"^",4)
    s SttDate=$p(mListData,"^",5)
    s PatListTypeDesc=$$ALPHAUP^SSUTIL4(PatListTypeDesc)
 	s PatListTypeDr=""
	s TypeRowid=0 for {
		s TypeRowid=$o(^DHCPatType(TypeRowid))
		Q:TypeRowid=""
		s TypeDesc=$p($g(^DHCPatType(TypeRowid)),"^",2)
		continue:TypeDesc'=PatListTypeDesc
		s PatListTypeDr=TypeRowid
	}
	s rtn=##class(web.DHCSpecPat).InsertPatList(PatName,PatIDCard,PatNote,PatListTypeDr,SttDate,"",UserID,"")
	if (rtn '= 0) {
		q "201^"_rtn
	} else {
		q rtn
	}
ImportDataErr
	s $zt=""
	Q "401^导入异常:"_$ze
}

/// desc:	获取特殊患者数据导入模板的方法
/// debug:	d ##class(%ResultSet).RunQuery("web.DHCSpecPat","ImportDataTemplate")
Query ImportDataTemplate() As %SQLQuery(ROWSPEC = "PatName:%String:患者姓名, IdCardNo:%String:身份证号, SpecTypeDesc:%String:患者类型, Remark:%String:备注, SttDate:%String:开始日期(yyyy-MM-dd)")
{
	SELECT TOP 1 DHCSP_Name, DHCSP_CredNo, DHCSP_Type_DR -> DHC_PatTypeDesc, DHCSP_Note, CONVERT(VARCHAR(10),DHCSP_StDate,120)
	FROM SQLUSER.DHC_SpecPat WHERE DHCSP_RowID > 0
}

}
