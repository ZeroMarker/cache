/// 病案编目查询V2.0
Class web.DHCWMRFPCodingQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// w ##class(web.DHCWMRFPCodingQry).Test()

ClassMethod Test()
{
	
	Set t=$c(34)
	Set l=$c(1)
	Set c2=$c(2)
	;Set arg="(<名称> LIKE "_t_"高血压"_t_")"_l
	;Set arg=arg_""_c2_"(<名称> LIKE "_t_"青光眼"_t_")AND(<疾病或手术类别> LIKE "_t_"主要诊断"_t_")"
	Set arg=c2_"(<名称> LIKE "_t_"青光眼"_t_")AND(<疾病或手术类别> LIKE "_t_"主要诊断"_t_")"
	Set Extra="(<入院情况> = 2)"
	//Set argAdm="(<出院日期> <= $zdh(""2000-1-1"",3))"
	//w ..QueryByICDName(arg,"","","")
	//Do ##class(%Library.ResultSet).RunQuery("web.DHCWMRFPCodingQry","FpQuery",arg,"","",argAdm,0)
	
	
	Set FromDate="2006-5-1"
	Set ToDate="2006-5-31"
	Do ##class(%Library.ResultSet).RunQuery("web.DHCWMRFPCodingQry","FPQueryByDate",FromDate,ToDate,arg,Extra,"","",0)
	Quit ""
}

ClassMethod FpQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FpQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FpQueryExecute(ByRef qHandle As %Binary, DisSQL As %String, Extra As %String, BaseInfo As %String, AdmInfo As %String, SimpleOutput As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//set:DisSQL'="" DisSQL=" AND "_DisSQL
	quit:DisSQL="" $$$OK
	set BaseInfoCondition = ..BaseInfoFieldMapping(BaseInfo)
	set AdmInfoCondition = ..AdmFieldMapping(AdmInfo)
	set strSQL = ""
	set intCounter = 0
	set result = 0
	//w !, result _ " " _ $h
	//进行SQL查询，查询疾病
	set StoreID=..QueryByICDName(DisSQL, BaseInfoCondition, AdmInfoCondition, Extra) 

	
	
	//组织数据
	//w !, "Building Data..." _ " " _ $h
	set FPRowID=""
	For {
		set FPRowID=$o(^CacheTemp(StoreID,FPRowID))
		Quit:FPRowID=""
		set FpInfo=$g(^DHCWMRFP(FPRowID))
		set ^CacheTemp(repid,ind)=..BuildQueryData(+$p(FpInfo, "^", 1), FPRowID, SimpleOutput)
		set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod FpQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FpQueryExecute ]
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

Query FpQuery(DisSQL As %String, Extra As %String, BaseInfo As %String, AdmInfo As %String, SimpleOutput As %String) As %Query(ROWSPEC = "MainID:%String:MainID,VolID:%String:VolID,FpID:%String:FpID,MrType:%String:病案种类,MrNo:%String:病案号,RegNo:%String:登记号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,PersonalID:%String:身份证,AdmitDate:%String:住院日期,AdmitDep:%String:住院科室,DisDate:%String:出院日期,DisDep:%String:出院科室,Days:%String:住院天数,Diagnose:%String:诊断,Operation:%String:手术,RepUser:%String:录入人,RepDate:%String:录入日期,RepTime:%String:录入时间") [ SqlProc ]
{
}

ClassMethod QueryByICDName(SQLCondition, BaseInfoCondition, AdmInfoCondition, Extra)
{
	n (SQLCondition, BaseInfoCondition, AdmInfoCondition, Extra)
	
	Set ret=""
	quit:SQLCondition="" 0
	
	Set StoreID=$I(^CacheTemp)
	
	set strSqlCondition = ..GetArgPart(SQLCondition, 1, 1) //取第一个条件
	Set ExpLine1=..FieldMapping(strSqlCondition)
	
	set strSqlConditionOther = ..GetArgPart(SQLCondition, 2, 99999) //取后面的条件	
	set ExpLineOther = ..FieldMapping(strSqlConditionOther) //通过映射，把所有字段名称解析成数据库中的字段名
	;set ExpLineExtra = ..ExtraFieldMapping(Extra)	
	
	
	Set %ICD="",%ICDName="",%Result="",%ItemType="",%CloseUp="",%Operator="",%Ass1="",%Ass2="",%NarcosisDoctor="",%NarcosisType=""
	Set TypeDr=""
	For {
		Set TypeDr=$o(^DHCWMRFPICD(0,"TypeICDDr",TypeDr))
		Quit:TypeDr=""
		Set TypeCode=$p($g(^DHCWMRDIC(TypeDr)),"^",2)
		Set ICDDr=""
		For {
			Set ICDDr=$o(^DHCWMRFPICD(0,"TypeICDDr",TypeDr,ICDDr))
			Quit:ICDDr=""
			Set ICDDic=..GetICDDic(TypeCode,ICDDr)
			Set %ICD="",%ICDName="",%Result="",%ItemType="",%CloseUp=""
			Set %Operator="",%Ass1="",%Ass2="",%NarcosisDoctor="",%NarcosisType=""
			Set %Pos="",%Type="",%OpeDate="",%SubType=""			
			Set %ICD=$p(ICDDic,"^",1)
			Set %ICDName=$p(ICDDic,"^",2)
			Set result=..ProcessCompare(ExpLine1)
			Continue:result=0
			w %ICD_"======="_%ICDName,!
			Set FpICDID=""
			For {
				Set FpICDID=$o(^DHCWMRFPICD(0,"TypeICDDr",TypeDr,ICDDr,FpICDID))
				Quit:FpICDID=""
				Set fpICD=$g(^DHCWMRFPICD(FpICDID))
				Set FpRowID=$p(fpICD,"^",1)
				Set tmpResult=..ProcessSubDisOpeCompare(FpRowID,ExpLineOther)
				;w FpRowID_"   "_tmpResult,!
				Continue:tmpResult=0
				Set tmpResult=..CompareBaseInfo(FpRowID,BaseInfoCondition)
				Continue:tmpResult=0				
				Set tmpResult=..CompareAdmitInfo(FpRowID,AdmInfoCondition)
				Continue:tmpResult=0
				Set tmpResult=..CompareExtraInfo(FpRowID,Extra)
				Continue:tmpResult=0				
				Set ^CacheTemp(StoreID,FpRowID)=""
			}
			Set ret=ret+1
		}
	}
	Quit StoreID
}

ClassMethod BuildQueryData(VolumeID, FPRowID, Simple)
{
	n (VolumeID, FPRowID, Simple)
	//set $ZT="BuildQueryDataError"
	set data=$lb("")
 	set volume=$g(^DHCWMRVOL(+VolumeID))
	set main=$g(^DHCWMRMAIN(+$p(volume,"^",1)))
	set mrTypeDic=$g(^DHCWMRDIC(+$p(main,"^",1)))
 	//疾病、手术
 	set strICDID = ""
 	set strDisease = ""
 	set strOpe = ""	
 	set repUser = ""
 	set repDate = ""
 	set repTime = ""
	if (Simple=0)
	{
		set adm=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolumeID)
		set baseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain($p(volume,"^",1))
		while (1)
 		{
		 	set strICDID = $o(^DHCWMRFPICD(0, "FP", FPRowID, strICDID))
		 	quit:strICDID=""
		 	set strICD = $g(^DHCWMRFPICD(+strICDID))
		 	
		 	Set TypeCode=$p($g(^DHCWMRDIC(+$p(strICD,"^",10))),"^",2)
		 	Set ICDDr=$p(strICD,"^",2)
		 	Set strICDDic=..GetICDDic(TypeCode,ICDDr)
		 	//set strICDDx = $g(^DHCWMRICD(+$p(strICD,"^",2)))
		 	set strICDDx=""
		 	if TypeCode="D" 
		 	{
			 	//Add By LiYang 2010-08-25 疾病分类查询对照
			 	set DiseaseName=$p(strICDDic,"^",2)
			 	set strResult = $p($g(^DHCWMRDIC(+$p(strICD,"^",3))),"^",3)
			 	;b
		 		set strDisease = strDisease _ DiseaseName _ "(" _ strResult _ ")" _ ","
		 	}
		 	if TypeCode="O"
		 	{
			 	set DiseaseName=$p(strICDDic,"^",2)
			 	set strOpe = strOpe _DiseaseName
			 	Set Operator=$p(strICD,"^",4)
			 	Set OperatDate=$p(strICD,"^",13)
			 	Set CloseUp=$p(strICD,"^",9)
			 	Set Resume=$p(strICD,"^",12)
			 	
			 	Set Operator=$p($g(^SSU("SSUSR",+Operator)),"^",2)
			 	Set:OperatDate'="" OperatDate=$zd(+OperatDate,3)
			 	Set:CloseUp'="" CloseUp=$p($g(^DHCWMRDIC(+CloseUp)),"^",3)
			 	Set:Operator="" Operator=$p(Resume,"#",1)
			 	
			 	Set:strOpe'="" strOpe=strOpe_","
			 	Set strOpe=strOpe_"(手术日期:"_OperatDate_"  术者:"_Operator_" 切口:"_CloseUp_")"
			}
		}
		set fpData = $g(^DHCWMRFP(FPRowID))
		set userData = $g(^SSU("SSUSR", +$p(fpData,"^",3)))
		set repUser = $p(userData,"^",2)
		set repDate = $zd(+$p(fpData,"^",4),3)
		set repTime = $zt(+$p(fpData,"^",5),1)
		
	}else
	{
		set adm=""
		set baseInfo=""
	}
	set $li(data,1)=$p(volume,"^",1) //MrMainID
	set $li(data,2)=VolumeID //volumeID
	set $li(data,3)=FPRowID //FrontPage RowID
	set $li(data,4)=$p(mrTypeDic,"^",3) //MrTypeDesc
 	set $li(data,5)=$p(main,"^",2) //MrNo
 	set $li(data,6)=$p(baseInfo,"^",27) //RegNo
 	set $li(data,7)=$p(baseInfo,"^",2) //PatientName
 	set $li(data,8)=$p(baseInfo,"^",4) //sex
 	set $li(data,9)=""
 	set birthday = $p(baseInfo, "^", 5)	
 	set $li(data,10)=$p(baseInfo,"^",13) //Personal ID
 	set $li(data,11)=$p(adm,"^",3) //admit date
 	set $li(data,12)=$p(adm,"^",5) //admit dep
 	set $li(data,13)=$p(adm,"^",7) //discharge date
 	set $li(data,14)=$p(adm,"^",9) //discharge dep
 	set start = $p(adm,"^",3)
 	set end = $p(adm,"^",7)
 	set:(start'="")&(end'="") $li(data,15) = $zdh(end, 3) - $zdh(start, 3)
 	set:(start="")!(end="") $li(data,15) = ""
 	
 	


	set $li(data,16) = strDisease
	set $li(data,17) = strOpe
 	set:(birthday'="")&(start'="") $li(data,9)= ($zdh(start, 3) - $zdh(birthday,3))\365
 	
 	set $li(data,18)= repUser
 	set $li(data,19) = repDate
 	set $li(data,20) = repTime
 	Quit data
 
BuildQueryDataError
	set intCounter = 0
	for intCounter=1:1:13
	{
		set $li(data,intCounter)=""
	}
 	Quit data
}

/// 设置当前医院病案编目所用诊断和手术字典的数据来源
/// 诊断字典的数据来源
/// ^DHCWMRICDSetting("D")
/// 0：取DHC_WMR_ICDDx
/// 1：取MRC_ICDDx
/// 
/// 手术字典的数据来源
/// ^DHCWMRICDSetting("O")
/// 0：取DHC_WMR_ICDDx
/// 1：取ORC_Operation
ClassMethod GetICDDic(TypeCode, ICDDr)
{
	n (TypeCode,ICDDr)
	Set ConfigCode=+$g(^DHCWMRICDSetting(TypeCode))
	Set ret=""
	;b
	if (ConfigCode=0) {
		Set data=$g(^DHCWMRICD(+ICDDr))
		Set ret=$p(data,"^",1)_"^"_$p(data,"^",3)
	}
	else {
		if (TypeCode="D") {
			Set data=$g(^MRC("ID",+ICDDr))
			Set ret=$p(data,"^",4)_"^"_$p(data,"^",2)
		}
		if (TypeCode="O") {
			Set data=$g(^ORC("OPER",+ICDDr))
			Set ret=$p(data,"^",1)_"^"_$p(data,"^",2)			
		}
	}
	Quit ret
}

ClassMethod ProcessSubDisOpeCompare(FpRowID, Condition)
{
	n (FpRowID, Condition)
	Set %ICD="",%ICDName="",%Result="",%ItemType="",%CloseUp=""
	Set %Operator="",%Ass1="",%Ass2="",%NarcosisDoctor="",%NarcosisType=""
	Set %Pos="",%Type="",%OpeDate="",%SubType=""

	set ConditionItem = ""
	set intCounter = 0
	Set ConditionCnt=0
	
	quit:Condition="" 1
	
	for intCounter=1:1:$l(Condition,$c(1))
	{
		set ConditionItem = $p(Condition, $c(1), intCounter)
		Continue:ConditionItem=""
		Set ConditionCnt=ConditionCnt+1	
		Set ResultArry(intCounter)=0
	}
	
	Set i=1
	set tmpFpICD = ""
	For	{
		set tmpFpICD=$o(^DHCWMRFPICD(0,"FP",FpRowID,tmpFpICD))
		quit:tmpFpICD=""
		set tmp=..GetFPICD(tmpFpICD)
		Set %ICD(i)=%ICD
		Set %ICDName(i)=%ICDName
		Set %Result(i)=%Result
		Set %ItemType(i)=%ItemType
		Set %CloseUp(i)=%CloseUp
		Set %Operator(i)=%Operator
		Set %Ass1(i)=%Ass1
		Set %Ass2(i)=%Ass2
		Set %NarcosisDoctor(i)=%NarcosisDoctor
		Set %NarcosisType(i)=%NarcosisType
		Set %Pos(i)=%Pos
		Set %Type(i)=%Type
		Set %OpeDate(i)=%OpeDate
		Set %SubType(i)=%SubType
		Set i=i+1
	}
	
	for intCounter=1:1:$l(Condition,$c(1))
	{
		set ConditionItem = $p(Condition, $c(1), intCounter)
		Continue:ConditionItem=""
		
		set flag = $p(ConditionItem, $c(2), 1)
		set ConditionItem = $p(ConditionItem, $c(2), 2)
		Set Cnt=0
		Set i=0
		For {
			Set i=$o(%ICD(i))
			Quit:i=""
			Set %ICD=%ICD(i)
			Set %ICDName =%ICDName(i)
			Set %Result=%Result(i)
			Set %ItemType=%ItemType(i)
			Set %CloseUp=%CloseUp(i)
			Set %Operator=%Operator(i)
			Set %Ass1=%Ass1(i)
			Set %Ass2=%Ass2(i)
			Set %NarcosisDoctor=%NarcosisDoctor(i)
			Set %NarcosisType=%NarcosisType(i)
			Set %Pos=%Pos(i)
			Set %Type=%Type(i)
			Set %OpeDate=%OpeDate(i)
			Set %SubType=%SubType(i)
			;w %ICD_" "_%ICDName,!
			set ret=..ProcessCompare(ConditionItem)
			Set:ret>0 Cnt=Cnt+1
		}
		Set:((Cnt>0)&&(flag="")) ResultArry(intCounter)=1
		Set:((Cnt'>0)&&(flag="-")) ResultArry(intCounter)=1	
	}	
	//Step 1
	Set result=0
	Set i=""
	For {
		Set i=$o(ResultArry(i))
		Quit:i=""
		Set:ResultArry(i)=1 result=result+1
		;Kill ResultArry(i)
	}
	Set ret=(result=ConditionCnt)
	;w ret_"   "_ConditionCnt,!
	quit ret
}

ClassMethod FieldMapping(Exp)
{
	n (Exp)
	set Exp = ..ReplaceString(Exp, "%", "")
	Set Exp=..ReplaceString(Exp,"<ICD>","%ICD")
	Set Exp=..ReplaceString(Exp,"<名称>","%ICDName")
	Set Exp=..ReplaceString(Exp,"<疾病转归>","%Result")
	Set Exp=..ReplaceString(Exp,"<类别>","%Type")
	Set Exp=..ReplaceString(Exp,"<切口愈合>","%CloseUp")
	Set Exp=..ReplaceString(Exp,"<术者>","%Operator")
	Set Exp=..ReplaceString(Exp,"<一助>","%Ass1")
	Set Exp=..ReplaceString(Exp,"<二助>","%Ass2")
	Set Exp=..ReplaceString(Exp,"<麻醉医师>","%NarcosisDoctor")
	Set Exp=..ReplaceString(Exp,"<麻醉类型>","%NarcosisType")
	Set Exp=..ReplaceString(Exp,"<手术日期>","%OpeDate")
	Set Exp=..ReplaceString(Exp,"<疾病或手术类别>","%SubType")
	Set Exp=..ReplaceString(Exp,"<位置>","%Pos")
	
	set Exp = ..ReplaceString(Exp, "LIKE", "[")
	set Exp = ..ReplaceString(Exp, ">=", "'<")
	set Exp = ..ReplaceString(Exp, "<=", "'>")
	set Exp = ..ReplaceString(Exp, "=", "=")
	set Exp = ..ReplaceString(Exp, ">", ">")
	set Exp = ..ReplaceString(Exp, "<", "<")
	set Exp = ..ReplaceString(Exp, "<>", "'=")
	set Exp = ..ReplaceString(Exp, "AND", "&")
	set Exp = ..ReplaceString(Exp, "OR", "!")	
	
	Quit Exp
}

/// 获取疾病诊断的字符串（全都是描述）
ClassMethod GetFPICD(RowID)
{
	Set %ICD="",%ICDName="",%Result="",%ItemType="",%CloseUp=""
	Set %Operator="",%Ass1="",%Ass2="",%NarcosisDoctor="",%NarcosisType=""
	Set %Pos="",%Type="",%OpeDate="",%SubType=""
	set strData=RowID_"^"_$g(^DHCWMRFPICD(+RowID))
	Set ICDDr=$p(strData,"^",3)
	set Type = $g(^DHCWMRDIC(+$p(strData,"^",15)))
	set %ItemType=$p($g(^DHCWMRDIC(+$p(strData,"^",11))),"^",2)
	Set ICD=..GetICDDic(%ItemType,ICDDr)
	Set %ICD=$p(ICD,"^",1)
	Set %ICDName=$p(ICD,"^",2)
	if (%ItemType="D")
	{
		set %Result=$p($g(^DHCWMRDIC(+$p(strData, "^", 4))),"^",3)
	}else{
		set:+$p(strData,"^",5)'=0 %Operator=##class(web.DHCMedBaseCtl).GetLogUserInfo(+$p(strData, "^", 5))
		set:+$p(strData,"^",6)'=0 %Ass1=##class(web.DHCMedBaseCtl).GetLogUserInfo(+$p(strData, "^", 6))
		set:+$p(strData,"^",7)'=0 %Ass2=##class(web.DHCMedBaseCtl).GetLogUserInfo(+$p(strData, "^", 7))
		set:+$p(strData,"^",9)'=0 %NarcosisDoctor=##class(web.DHCMedBaseCtl).GetLogUserInfo(+$p(strData, "^", 9))
		set %NarcosisType=$p($g(^DHCWMRDIC(+$p(strData, "^", 8))),"^",3)	
		set %CloseUp=$p($g(^DHCWMRDIC(+$p(strData, "^", 10))),"^",3)	
	}
	Set %Pos=$p(strData,"^",12)
	Set %Type=$s(%ItemType="D":"诊断",1:"手术")
	Set:$p(strData,"^",14)'="" %OpeDate=$zd($p(strData,"^",14),3)
	Set %SubType=$p(Type,"^",3)
	
	
	set strResume = $p(strData,"^",13)
	set:%Operator="" %Operator=$p(strResume,"#",1)  		//历史数据中的术者
	set:%NarcosisDoctor="" %NarcosisDoctor=$p(strResume,"#",2) 	//历史数据中的麻醉医师
	set:%Ass1="" %Ass1=$p(strResume,"#",3)  		//历史数据中的助手1
	set:%Ass2="" %Ass2=$p(strResume,"#",4)		//历史数据中的助手2	
	
	Quit 1
}

ClassMethod CompareExtraInfo(FPRowID, ConditionExp)
{
	n (FPRowID, ConditionExp)
	set $ZT="CompareExtraInfoError"
	set RowID = ""
	set strData = ""
	set strDic = ""
	set strValue = ""
	set strFieldName = ""
	set strExp = ""
	quit:ConditionExp="" 1
	s CompareResult=0
	//Modified By LiYang 2009-09-18 修改附加项目检索程序结构
	s ConditionExp=..ExtraFieldMapping(ConditionExp)
	set ConditionExp = ..ReplaceString("CompareResult=(1 = 1)&&"_ConditionExp,"FPRowID",FPRowID)	
	s ^CacheTemp1($ZN,"LastExp")= ConditionExp
	/*do
	{
		set RowID = $o(^DHCWMRFPE(0, "FP" ,FPRowID, RowID))
		if (RowID '= "")
		{
			set strData = $g(^DHCWMRFPE(+RowID))
			set strDic = $g(^DHCWMRFPIDIC(+$p(strData, "^", 2)))
			set strValue = $p(strData, "^", 3)
			set strFieldName = $p(strDic, "^", 4)
			if ((strFieldName'="")&(strValue'=""))
			{
				set strExp = strFieldName _ "=" _ $c(34) _	strValue _ $c(34)
				set @strExp
			}
		}
	}while(RowID '= "")
	*/
	set @ConditionExp	
	quit CompareResult // Modified By LiYang 2009-09-18 返回比较值
CompareExtraInfoError
	set ^CacheTemp1($ZN,"CheckInfoErrExp")=ConditionExp
	set ^CacheTemp1($ZN,"CheckInfoErr")=$ZERROR
	w !,$ZERROR
	quit 0
}

ClassMethod CompareBaseInfo(FpRowID, BaseInfoCondition)
{
	n (FpRowID,BaseInfoCondition)
	Set ret=1
	Quit:BaseInfoCondition="" ret
	Set %PatientName="",%PinYin="",%Sex="",%Birthday="",%Age="",%Wedlock=""
	Set %Vocation="",%City="",%County="",%Nation="",%Nationality="",%PersonalID=""
	Set %Company="",%CompanyTel="",%CompanyZip="",%HomeAddr="",%HomeTel=""
	Set %HomeZip="",%ReName="",%Relative="",%ReTel="",%ReAddr=""
	set FpData = $g(^DHCWMRFP(+FpRowID))
	set VolID = $p(FpData, "^", 1)
	set VolData = $g(^DHCWMRVOL(+VolID))
	set MainID = $p(VolData, "^", 1)
	
	set sBaseInfo = ##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+MainID)
	Set %PatientName=$p(sBaseInfo,"^",2)
	Set %PinYin=$p(sBaseInfo,"^",3)
	Set %Sex=$p(sBaseInfo,"^",4)
	Set %Birthday=$zd(+$p(sBaseInfo,"^",5),3)
	Set %Age=$p(sBaseInfo,"^",6)
	Set %Wedlock=$p(sBaseInfo,"^",7)
	Set %Vocation=$p(sBaseInfo,"^",8)
	Set %City=$p(sBaseInfo,"^",9)
	Set %County=$p(sBaseInfo,"^",10)
	Set %Nation=$p(sBaseInfo,"^",11)
	Set %Nationality=$p(sBaseInfo,"^",12)
	Set %PersonalID=$p(sBaseInfo,"^",13)
	Set %Company=$p(sBaseInfo,"^",14)
	Set %CompanyTel=$p(sBaseInfo,"^",15)
	Set %CompanyZip=$p(sBaseInfo,"^",16)
	Set %HomeAddr=$p(sBaseInfo,"^",17)
	Set %HomeTel=$p(sBaseInfo,"^",18)
	Set %HomeZip=$p(sBaseInfo,"^",19)
	Set %ReName=$p(sBaseInfo,"^",21)
	Set %Relative=$p(sBaseInfo,"^",20)
	Set %ReTel=$p(sBaseInfo,"^",22)
	Set %ReAddr=$p(sBaseInfo,"^",23)

	set ret=..ProcessCompare(BaseInfoCondition)		
	Quit ret
}

/// 筛选病人疾病信息以及就诊信息
ClassMethod CompareAdmitInfo(FpRowID, AdmInfoCondition)
{
	n (FpRowID,AdmInfoCondition)
	Set ret=1
	quit:(FpRowID="")&(AdmInfoCondition="") ret

	Set %AdmitDate="",%AdmitDep="",%DisDate="",%DisDep="",%Days=""
	
	set FpData = $g(^DHCWMRFP(+FpRowID))
	set VolID = $p(FpData, "^", 1)
	set VolData = $g(^DHCWMRVOL(+VolID))
	//set MainID = $p(VolData, "^", 1)
	Set AdmData=..GetAdmitInfoString(+VolID)
	set ret=..ProcessCompare(AdmInfoCondition)
	//AdmitDate_"^"_AdmitDep_"^"_DisDate_"^"_DisDep_"^"_Days
	Set %AdmitDate=0
	Set:$p(AdmData,"^",1)'="" %AdmitDate=$zdh($p(AdmData,"^",1),3)
	Set %AdmitDep=$p(AdmData,"^",2)
	Set %DisDate=0
	Set:$p(AdmData,"^",3)'="" %DisDate=$zdh($p(AdmData,"^",3),3)
	Set %DisDep=$p(AdmData,"^",4)
	Set %Days=$p(AdmData,"^",5)
	
	set ret=..ProcessCompare(AdmInfoCondition)
	quit ret
}

ClassMethod GetArgPart(Arg, From, To)
{
	n (Arg, From, To)
	set ret = ""
	set intCounter = 0
	for intCounter=From:1:To
	{
		quit:intCounter>$l(Arg,$c(1))
		set:ret'="" ret = ret _ $c(1)
		set ret = ret _ $p(Arg, $c(1), intCounter) 
	}
	quit ret
}

/// 字符替换
ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// 比较函数，用来对生成的数据进行自定义数据测试
ClassMethod ProcessCompare(ConditionExp)
{
	//set $ZT="Error"
	//n (str, ConditionExp)
	quit:(ConditionExp="") 1
	set ConditionExp = "CompareResult="_ConditionExp	
	set @ConditionExp
	//w !, CompareResult
	quit CompareResult
Error
	set ^CacheTemp1($ZN,"CheckInfoErr")=$ZERROR
	set ^CacheTemp1($ZN,"CheckInfoErrExp")=ConditionExp
	quit 0
}

ClassMethod ExtraFieldMapping(Exp)
{
	n (Exp)
	s id=0 f  s id=$o(^DHCWMRFPIDIC(id)) q:id=""  d
	.s s=$g(^DHCWMRFPIDIC(id))
	.s TempItemName="<"_$p(s,"^",1)_">"
	.s Exp = ..ReplaceString(Exp,TempItemName, "##class(web.DHCWMRFPCodingQry).GetTempItemValue(FPRowID,"_id_")")

	set Exp = ..ReplaceString(Exp, "%", "")
	set Exp = ..ReplaceString(Exp, "LIKE", "[")
	set Exp = ..ReplaceString(Exp, ">=", "'<")
	set Exp = ..ReplaceString(Exp, "<=", "'>")
	set Exp = ..ReplaceString(Exp, "=", "=")
	set Exp = ..ReplaceString(Exp, ">", ">")
	set Exp = ..ReplaceString(Exp, "<", "<")
	set Exp = ..ReplaceString(Exp, "<>", "'=")
	set Exp = ..ReplaceString(Exp, "AND", "&")
	set Exp = ..ReplaceString(Exp, "OR", "!")
	set Exp = ..ReplaceString(Exp, "'", $c(34))
	
	quit Exp
}

ClassMethod GetAdmitInfoString(VolID)
{
	n (VolID)
	set VolInfo = $g(^DHCWMRVOL(VolID))

	quit:VolInfo="" ""
	set PaadmID = $p(VolInfo, "^", 2)
	set HisAdmID = $p(VolInfo, "^", 3)	
	set VolAdmID = ""
	set LastAdmID = ""
	if (PaadmID '= "")
	{
		set strAdm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(PaadmID)
		set LastChildSub = $o(^DHCWMRVOL(VolID, "ADM", ""),-1)
		set LastAdmID =  +$g(^DHCWMRVOL(VolID, "ADM", LastChildSub))
		set strLastAdm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(LastAdmID)
		set AdmitDate = $p(strAdm, "^", 4)
		set AdmitDep =  $p(strAdm, "^", 9) //Modified By LiYang 2010-02-24 修复Bug：取就诊科室与显示科室字段不统一
		set DisDate = $p(strLastAdm, "^", 12)
		set DisDep = $p(strAdm, "^", 9) //Modified By LiYang 2010-02-24 修复Bug：取就诊科室与显示科室字段不统一
	}
	else
	{
		set strAdm = $g(^DHCWMRHISADM(HisAdmID))
		set AdmitDate = $p(strAdm, "^", 2)
		set AdmitDep = $p(strAdm, "^", 4)
		set DisDate = $p(strAdm, "^", 6)
		set DisDep = $p(strAdm, "^", 8)	
		set:AdmitDate'="" AdmitDate	= $zd(AdmitDate, 3)
		set:DisDate'="" DisDate = $zd(DisDate, 3)
	}

	if (AdmitDate'="")&(DisDate'="")
	{
		set Days = $zdh(DisDate, 3) - $zdh(AdmitDate, 3)
	}
	else
	{
		set Days = 0
	}
	quit AdmitDate_"^"_AdmitDep_"^"_DisDate_"^"_DisDep_"^"_Days
}

ClassMethod BaseInfoFieldMapping(Exp)
{
	n (Exp)
	set Exp = ..ReplaceString(Exp, "%", "")
	
	set Exp=..ReplaceString(Exp,"<病人姓名>","%PatientName")
	set Exp=..ReplaceString(Exp,"<拼音>","%PinYin")
	set Exp=..ReplaceString(Exp,"<性别>","%Sex")
	set Exp=..ReplaceString(Exp,"<生日>","%Birthday")
	set Exp=..ReplaceString(Exp,"<年龄>","%Age")
	set Exp=..ReplaceString(Exp,"<婚姻>","%Wedlock")
	set Exp=..ReplaceString(Exp,"<职业>","%Vocation")
	set Exp=..ReplaceString(Exp,"<出生市>","%City")
	set Exp=..ReplaceString(Exp,"<出生县>","%County")
	set Exp=..ReplaceString(Exp,"<民族>","%Nation")
	set Exp=..ReplaceString(Exp,"<国籍>","%Nationality")
	set Exp=..ReplaceString(Exp,"<身份证号>","%PersonalID")
	set Exp=..ReplaceString(Exp,"<工作单位>","%Company")
	set Exp=..ReplaceString(Exp,"<工作单位电话>","%CompanyTel")
	set Exp=..ReplaceString(Exp,"<工作单位邮编>","%CompanyZip")
	set Exp=..ReplaceString(Exp,"<家庭住址>","%HomeAddr")
	set Exp=..ReplaceString(Exp,"<家庭电话>","%HomeTel")
	set Exp=..ReplaceString(Exp,"<家庭邮编>","%HomeZip")
	set Exp=..ReplaceString(Exp,"<与联系人关系>","%ReName")
	set Exp=..ReplaceString(Exp,"<联系人>","%Relative")
	set Exp=..ReplaceString(Exp,"<联系人电话>","%ReTel")
	set Exp=..ReplaceString(Exp,"<联系人地址>","%ReAddr")
	

	set Exp = ..ReplaceString(Exp, "LIKE", "[")
	set Exp = ..ReplaceString(Exp, ">=", "'<")
	set Exp = ..ReplaceString(Exp, "<=", "'>")
	set Exp = ..ReplaceString(Exp, "=", "=")
	set Exp = ..ReplaceString(Exp, ">", ">")
	set Exp = ..ReplaceString(Exp, "<", "<")
	set Exp = ..ReplaceString(Exp, "<>", "'=")
	set Exp = ..ReplaceString(Exp, "AND", "&")
	set Exp = ..ReplaceString(Exp, "OR", "!")
	
	quit Exp
}

/// 将就诊信息和数据库字段对应起来
ClassMethod AdmFieldMapping(Exp)
{
	n (Exp)
	set Exp = ..ReplaceString(Exp, "%", "")
	
	set Exp = ..ReplaceString(Exp, "<住院日期>", "%AdmitDate") //Modified by LiYang 2009-09-18 日期处理问题
	//set Exp = ..ReplaceString(Exp, "<住院日期>", "$tr($p(str, "_ $c(34) _ "^" _ $c(34) _ ", 1),""-"","""")")
	set Exp = ..ReplaceString(Exp, "<住院科室>", "%AdmitDep")
	set Exp = ..ReplaceString(Exp, "<出院日期>", "%DisDate") //Modified by LiYang 2009-09-18 日期处理问题
	//set Exp = ..ReplaceString(Exp, "<出院日期>", "$tr($p(str, "_ $c(34) _ "^" _ $c(34) _ ", 3),""-"","""")")
	set Exp = ..ReplaceString(Exp, "<出院科室>", "%DisDep")
	set Exp = ..ReplaceString(Exp, "<住院天数>", "%Days")	
	
	set Exp = ..ReplaceString(Exp, "LIKE", "[")
	set Exp = ..ReplaceString(Exp, ">=", "'<")
	set Exp = ..ReplaceString(Exp, "<=", "'>")
	set Exp = ..ReplaceString(Exp, "=", "=")
	set Exp = ..ReplaceString(Exp, ">", ">")
	set Exp = ..ReplaceString(Exp, "<", "<")
	set Exp = ..ReplaceString(Exp, "<>", "'=")
	set Exp = ..ReplaceString(Exp, "AND", "&")
	set Exp = ..ReplaceString(Exp, "OR", "!")
	
	quit Exp
}

Query FPQueryByDate(FromDate As %String, ToDate As %String, ICDInfo As %String, ExtraInfo As %String, AdmitInfo As %String, BaseInfo As %String, SimpleOutput As %String) As %Query(ROWSPEC = "MainID:%String:MainID,VolID:%String:VolID,FpID:%String:FpID,MrType:%String:病案种类,MrNo:%String:病案号,RegNo:%String:登记号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,PersonalID:%String:身份证,AdmitDate:%String:住院日期,AdmitDep:%String:住院科室,DisDate:%String:出院日期,DisDep:%String:出院科室,Days:%String:住院天数,Diagnose:%String:诊断,Operation:%String:手术,RepUser:%String:录入人,RepDate:%String:录入日期,RepTime:%String:录入时间") [ SqlProc ]
{
}

ClassMethod FPQueryByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FPQueryByDateExecute ]
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

ClassMethod FPQueryByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, ICDInfo As %String, ExtraInfo As %String, AdmitInfo As %String, BaseInfo As %String, SimpleOutput As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(FromDate="")||(ToDate="") $$$OK
	set:FromDate["-" FromDate = $zdh(FromDate, 3)
	set:ToDate["-" ToDate = $zdh(ToDate, 3)
	Set StoreID=..QueryByDate(FromDate, ToDate, ICDInfo, BaseInfo, AdmitInfo, ExtraInfo)
	
	//组织数据
	//w !, "Building Data..." _ " " _ $h
	set FPRowID = ""
	For {
		Set FPRowID=$o(^CacheTemp(StoreID, FPRowID))
		Quit:FPRowID=""
		set FpInfo = $g(^DHCWMRFP(FPRowID))
		Continue:FpInfo=""
		set ^CacheTemp(repid,ind)=..BuildQueryData(+$p(FpInfo, "^", 1), FPRowID, SimpleOutput)
		set ind = ind + 1		
	}
	Kill ^CacheTemp(StoreID)
	Quit $$$OK
}

ClassMethod FPQueryByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FPQueryByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryByDate(FromDate, ToDate, ICDCondition, BaseInfoCondition, AdmInfoCondition, ExtraCondition)
{
	n (FromDate, ToDate, ICDCondition, DateType, BaseInfoCondition, AdmInfoCondition, ExtraCondition)
	Set StoreID=$I(^CacheTemp)
	;b //a
	set ICDCondition = ..FieldMapping(ICDCondition)
	;b //b
	set BaseInfoCondition = ..BaseInfoFieldMapping(BaseInfoCondition)
	set AdmInfoCondition = ..AdmFieldMapping(AdmInfoCondition)
	set ExtraCondition = ..ExtraFieldMapping(ExtraCondition)
	
	set tmpDate =FromDate-1
	for {
		Set tmpDate=$o(^DHCWMRFP(0,"OutDate",tmpDate))
		Quit:((tmpDate="")!(tmpDate>ToDate))
		w "Date:"_$zd(tmpDate,3),!
		Set FpRowID=""
		for {
			Set FpRowID=$o(^DHCWMRFP(0,"OutDate",tmpDate,FpRowID))
			Quit:FpRowID=""
			set tmpResult = ..ProcessSubDisOpeCompare(FpRowID,ICDCondition) //把每个疾病、手术信息都拿出来比一比
			Continue:tmpResult=0
			Set tmpResult=..CompareBaseInfo(FpRowID,BaseInfoCondition)
			Continue:tmpResult=0				
			Set tmpResult=..CompareAdmitInfo(FpRowID,AdmInfoCondition)
			Continue:tmpResult=0
			Set tmpResult=..CompareExtraInfo(FpRowID,ExtraCondition)
			Continue:tmpResult=0			
			Set ^CacheTemp(StoreID,FpRowID)=""
		}
	}
 	quit StoreID
}

ClassMethod GetPatientBaseInfoByMainID(MainID) As %String
{
		quit ##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainID)
}

ClassMethod GetPatientAdmInfo(VolID) As %String
{
		quit ##class(web.DHCWMRFPCodingQry).GetAdmitInfoString(VolID)
}

ClassMethod GetICDInfo(FrontPageID, ICDType) As %String
{
	set ICDRowID = ""
	set ret = ""
	set strData = "" 
	set ICDTypeData = ##class(web.DHCWMRDictionaryCtl).QueryByTypeCode("ICDType", ICDType)
	set ICDTypeDr = $p(ICDTypeData, "^", 1)
	Set %ICD="",%ICDName="",%Result="",%ItemType="",%CloseUp=""
	Set %Operator="",%Ass1="",%Ass2="",%NarcosisDoctor="",%NarcosisType=""
	Set %Pos="",%Type="",%OpeDate="",%SubType=""		

	while (1)
	{
		set ICDRowID = $o(^DHCWMRFPICD(0,"FP", FrontPageID, ICDRowID))
		quit:ICDRowID=""
		set strData = $g(^DHCWMRFPICD(ICDRowID))
		if ($p(strData, "^", 10) = ICDTypeDr)
		{
			set:ret'="" ret=ret_$c(1)
			Set t=..GetFPICD(ICDRowID)
			Set ICD=""
			Set $p(ICD,"^",3)=%ICD
			Set $p(ICD,"^",4)=%ICDName
			Set $p(ICD,"^",5)=%Result
			Set $p(ICD,"^",6)=%Operator
			Set $p(ICD,"^",7)=%Ass1
			Set $p(ICD,"^",8)=%Ass2
			Set $p(ICD,"^",9)=%NarcosisType
			Set $p(ICD,"^",10)=%NarcosisDoctor
			Set $p(ICD,"^",11)=%CloseUp
			Set $p(ICD,"^",12)=%Result
			Set $p(ICD,"^",13)=%Result
			Set $p(ICD,"^",14)=%Result
			Set $p(ICD,"^",15)=%OpeDate
			Set $p(ICD,"^",16)=%SubType
			set ret = ret_ICD
		}
	}
	quit ret
}

ClassMethod GetTempItemValue(FpRowID, ItemType) As %String
{
	n (FpRowID,ItemType)
	s id=$o(^DHCWMRFPE(0,"FPTempID",+ItemType,+FpRowID,""))
	q:id="" ""
	s ret=$p($g(^DHCWMRFPE(id)),"^",3)
	q ret
}

ClassMethod GetExtraInfo(FpRowID) As %String
{
	q:FpRowID="" ""
	s ret=""
	// ^DHCWMRFPE(0,"FP",{FrontPageDr},{RowId})
	s rowid="" f  s rowid=$o(^DHCWMRFPE(0,"FP",+FpRowID,rowid)) q:rowid=""  d
	.s extra=$g(^DHCWMRFPE(rowid))
	.q:extra=""
	.s templateID=$p(extra,"^",2)
	.s value=$p(extra,"^",3)
	.s template=$g(^DHCWMRFPIDIC(+templateID))
	.s templateTitle=$p(template,"^",1)
	.s:ret'="" ret=ret_$c(1)
	.s ret=ret_templateTitle_"^"_value
	q ret
}

/// 查询查询列表信息
/// 1-逻辑运算符 2-关系 3-疾病手术字段 4-就诊字段 5-附加字段 6-患者基本信息字段
/// do ##class(%Library.ResultSet).RunQuery("web.DHCWMRFPCodingQry","QryFieldList",4)
Query QryFieldList(Type As %String) As %Query(ROWSPEC = "Desc:%String") [ SqlProc ]
{
}

ClassMethod QryFieldListExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	if (Type=1) {
		Set ^CacheTemp(repid,1)=$lb(" = ")
		Set ^CacheTemp(repid,2)=$lb(" > ")
		Set ^CacheTemp(repid,3)=$lb(" < ")
		Set ^CacheTemp(repid,4)=$lb(" LIKE ")
	}
	if (Type=2) {
		Set ^CacheTemp(repid,1)=$lb(" OR ")
		Set ^CacheTemp(repid,2)=$lb(" AND ")
	}	
	if (Type=3) {
		Set ^CacheTemp(repid,1)=$lb("<ICD>")
		Set ^CacheTemp(repid,2)=$lb("<名称>")
		Set ^CacheTemp(repid,3)=$lb("<疾病转归>")
		Set ^CacheTemp(repid,4)=$lb("<类别>")
		Set ^CacheTemp(repid,5)=$lb("<切口愈合>")
		Set ^CacheTemp(repid,6)=$lb("<术者>")
		Set ^CacheTemp(repid,7)=$lb("<一助>")
		Set ^CacheTemp(repid,8)=$lb("<二助>")
		Set ^CacheTemp(repid,9)=$lb("<麻醉医师>")
		Set ^CacheTemp(repid,10)=$lb("<麻醉类型>")
		Set ^CacheTemp(repid,11)=$lb("<手术日期>")
		Set ^CacheTemp(repid,12)=$lb("<疾病或手术类别>")
		Set ^CacheTemp(repid,13)=$lb("<位置>")
	}	
	if (Type=4) {
		Set ^CacheTemp(repid,1)=$lb("<住院日期>")
		Set ^CacheTemp(repid,2)=$lb("<住院科室>")
		Set ^CacheTemp(repid,3)=$lb("<出院日期>")
		Set ^CacheTemp(repid,4)=$lb("<出院科室>")
		Set ^CacheTemp(repid,5)=$lb("<住院天数>")
	}	
	if (Type=5) {
	}	
	if (Type=6) {
		Set ^CacheTemp(repid,1)=$lb("<病人姓名>")
		Set ^CacheTemp(repid,2)=$lb("<拼音>")
		Set ^CacheTemp(repid,3)=$lb("<性别>")
		Set ^CacheTemp(repid,4)=$lb("<生日>")
		Set ^CacheTemp(repid,5)=$lb("<年龄>")
		Set ^CacheTemp(repid,6)=$lb("<婚姻>")
		Set ^CacheTemp(repid,7)=$lb("<职业>")
		Set ^CacheTemp(repid,8)=$lb("<出生市>")
		Set ^CacheTemp(repid,9)=$lb("<出生县>")
		Set ^CacheTemp(repid,10)=$lb("<民族>")
		Set ^CacheTemp(repid,11)=$lb("<国籍>")
		Set ^CacheTemp(repid,12)=$lb("<身份证号>")
		Set ^CacheTemp(repid,13)=$lb("<工作单位>")
		Set ^CacheTemp(repid,14)=$lb("<工作单位电话>")
		Set ^CacheTemp(repid,15)=$lb("<工作单位邮编>")
		Set ^CacheTemp(repid,16)=$lb("<家庭住址>")
		Set ^CacheTemp(repid,17)=$lb("<家庭电话>")
		Set ^CacheTemp(repid,18)=$lb("<家庭邮编>")
		Set ^CacheTemp(repid,19)=$lb("<与联系人关系>")
		Set ^CacheTemp(repid,20)=$lb("<联系人>")
		Set ^CacheTemp(repid,21)=$lb("<联系人电话>")
		Set ^CacheTemp(repid,22)=$lb("<联系人地址>")
	}		
	Quit $$$OK
}

ClassMethod QryFieldListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFieldListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryFieldListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFieldListExecute ]
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

ClassMethod GetHeader() As %String
{
	Quit "MainID,VolID,FpID,病案种类,病案号,登记号,姓名,性别,年龄,身份证,住院日期,住院科室,出院日期,出院科室,住院天数,诊断,手术,录入人,录入日期,录入时间"
}

/// 创建者：王成山
/// 日期：2013-05-02
/// 描述：将表达式中的日期转化为数字
/// Debug:w ##Class(web.DHCWMRFPCodingQry).ConvertDateToInt(Exp)
ClassMethod ConvertDateToInt(DateStr As %String)
{
	New (DateStr)
	Set DateInt=""
	Set:DateStr["-" DateInt=$zdh(DateStr,3)
	Set:DateStr["/" DateInt=$zdh(DateStr,4)
	Set DateInt=+DateInt
	Quit DateInt
}

}
