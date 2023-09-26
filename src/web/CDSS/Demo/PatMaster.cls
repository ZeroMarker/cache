/// Description：住院Demo-患者基础信息表
/// Table：WDT.CDSS.DEMOPatMaster
Class web.CDSS.Demo.PatMaster Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-01-30
/// Description:获得患者基础信息表内容
/// Table: WDT.CDSS.DEMOPatMaster
/// Input: 类型，医院ID，病历号，姓名，主诊断，科室，住院号
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.PatMaster","GetList","I","","","","","","")
Query GetList(type, patientdr, casenum, name, maindiag, department, admissioncount) As %Query(ROWSPEC = "RowId,PatientDR,CaseNum,AdmissionCount,Name,Sex,Age,AgeUnit,Department,MainDiag,Hospital,MainDiagType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, type, patientdr, casenum, name, maindiag, department, admissioncount) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s:patientdr'="" patientdr=$ZCONVERT(patientdr,"U") //转换成大写
 	s:casenum'="" casenum=$ZCONVERT(casenum,"U") //转换成大写
 	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
 	s:maindiag'="" maindiag=$ZCONVERT(maindiag,"U") //转换成大写
 	s:department'="" department=$ZCONVERT(department,"U") //转换成大写
 	s:admissioncount'="" admissioncount=$ZCONVERT(admissioncount,"U") //转换成大写
	s RowId = ""
	for
	{
		s RowId = $o(^WDT.CDSS.DEMOPatMasterI("TypeIndex",type,RowId),-1)
		q:RowId=""
		s PatientDR = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),3) //医院ID
		s CaseNum = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),4) //病案号
		s AdmissionCount = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),5) //住院号
		s Name = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),8) //姓名
		s PYName=""
		s:name'="" PYName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Name) 
		s Sex = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),9) //性别
		s Age = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),11) //年龄
		s AgeUnit = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),12) //年龄单位
		s Department = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),14) //科室
		s PYDepartment=""
		s:department'="" PYDepartment=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Department) 
		s MainDiag = $lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),15) //主诊断
		s PYMainDiag=""
		s:maindiag'="" PYMainDiag=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MainDiag) 
		s Hospital=$lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),30) //医院
		s MainDiagType=$lg($g(^WDT.CDSS.DEMOPatMasterD(RowId)),31) //主诊断类型
		if (($ZCONVERT(PatientDR,"U")[patientdr)||(patientdr=""))&&(($ZCONVERT(CaseNum,"U")[casenum)||(casenum=""))&&(($ZCONVERT(Name,"U")[name)||(PYName[name)||(name=""))&&(($ZCONVERT(MainDiag,"U")[maindiag)||(PYMainDiag[maindiag)||(maindiag=""))&&(($ZCONVERT(Department,"U")[department)||(PYDepartment[department)||(department=""))&&(($ZCONVERT(AdmissionCount,"U")[admissioncount)||(admissioncount="")){
	  		d OutputRow
	  	}	
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PatientDR,CaseNum,AdmissionCount,Name,Sex,Age,AgeUnit,Department,MainDiag,Hospital,MainDiagType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2021-02-01
/// Description:保存患者基础信息表
/// Table: WDT.CDSS.DEMOPatMaster
/// Input: eobj 患者基础信息表实体对象
/// others:w ##class(web.CDSS.Demo.PatMaster).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.PatMaster)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.DEMOPatMaster).%New()
			s obj.IDNO=..GetLastIDNO()
			s obj.PatientDR=..GetLastIDNO()
			s obj.CaseNum=$tr(obj.IDNO,"DM","00")
			s obj.AdmissionCount="1"
			s obj.Type="O"
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(eobj.RowId)
			
			s bobj = ##class(web.CDSSEntity.Demo.PatMaster).%New()
			s bobj.IDNO = obj.IDNO
			s bobj.Name = obj.Name
			s bobj.Sex = obj.Sex
			s bobj.Birthday = obj.Birthday
			s bobj.Age = obj.Age
			s bobj.AgeUnit = obj.AgeUnit
			s bobj.PhoneNumber = obj.PhoneNumber
			s bobj.Department = obj.Department
			s bobj.MainDiag = obj.MainDiag
			s bobj.Profession = obj.Profession
			s bobj.Address = obj.Address
			s bobj.IDCardNumber = obj.IDCardNumber
			s bobj.ContactsName = obj.ContactsName
			s bobj.ContractsPhone = obj.ContractsPhone
			s bobj.Hospital = obj.Hospital
			s bobj.MainDiagType=obj.MainDiagType
		}
		s obj.Name = eobj.Name
		s obj.Sex = eobj.Sex
		s obj.Birthday = eobj.Birthday
		s obj.Age = eobj.Age
		s obj.AgeUnit = eobj.AgeUnit
		s obj.PhoneNumber = eobj.PhoneNumber
		s obj.Department = eobj.Department
		s obj.MainDiag = eobj.MainDiag
		s obj.Profession = eobj.Profession
		s obj.Address = eobj.Address
		s obj.IDCardNumber = eobj.IDCardNumber
		s obj.ContactsName = eobj.ContactsName
		s obj.ContractsPhone = eobj.ContractsPhone
		s obj.Hospital = eobj.Hospital
		s obj.MainDiagType=eobj.MainDiagType
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			 //保存日志
		    d:eobj.RowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("WDT_CDSS.DEMOPatMaster","WDT.CDSS.DEMOPatMaster","住院Demo-患者基础信息",id,eobj.Name,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("WDT_CDSS.DEMOPatMaster","WDT.CDSS.DEMOPatMaster","住院Demo-患者基础信息",eobj.RowId,eobj.Name,"U",eobj,bobj)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("住院Demo-患者基础信息","web.CDSS.Demo.PatMaster","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("住院Demo-患者基础信息","web.CDSS.Demo.PatMaster","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
	q result
}

/// Creator：高姗姗
/// CreatDate: 2021-02-01
/// Description:代码自动生成  DM000000 代码最大值加1
/// Table：WDT.CDSS.DEMOPatMaster
/// Other: w ##class(web.CDSS.Demo.PatMaster).GetLastIDNO()
ClassMethod GetLastIDNO() As %String
{
  	s CodeLen=8    //代码长度
  	s StartCode="DM"  //代码起始字符
  	s code=""
	s StartCodeLen=$Length(StartCode)
	s preCode=""    //寻找符合规则的最大的代码

	//s preCode=$o(^WDT.CDSS.DEMOPatMasterI("IDNOIndex",""),-1)
	//add by zww 过滤处理不是DM开头的不符合规范的记录
	s tempCode=""
	for{
	    s tempCode=$o(^WDT.CDSS.DEMOPatMasterI("IDNOIndex",tempCode)) q:tempCode=""
	    s:(tempCode["DM") preCode=tempCode
	}
	
	if (preCode="")   //如果没有符合规则的代码，则生成第一个
	{
		s zeroLen=CodeLen-StartCodeLen
		s zeroStr=""
		s count=0
		for
		{
			s count=count+1
			q:count>zeroLen
			s zeroStr=zeroStr_"0"
		}
		s preCode=StartCode_zeroStr
	}
	
	s CodeNum=$p(preCode,StartCode,2)+1     //ZD后的数字+1
	s CodeNumLen=$Length(CodeNum)     //数字的长度
	s code=$e(preCode,1,CodeLen-CodeNumLen)_CodeNum  //组合
	q code
}

/// Creator：高姗姗
/// CreatDate: 2021-02-01
/// Description：数据打开方法
/// Table：WDT.CDSS.DEMOPatMaster
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.PatMaster).OpenData("10297")
ClassMethod OpenData(RowId As %String) As %String
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.Demo.PatMaster).%New()
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(RowId)
	s eobj.RowId = RowId
	s eobj.Name = pobj.Name
	s eobj.Sex = pobj.Sex
	s eobj.Birthday = pobj.Birthday
	s eobj.Age = pobj.Age
	s eobj.AgeUnit = pobj.AgeUnit
	s eobj.PhoneNumber = pobj.PhoneNumber
	s eobj.Department = pobj.Department
	s eobj.MainDiag = pobj.MainDiag
	s eobj.Profession = pobj.Profession
	s eobj.Address = pobj.Address
	s eobj.IDCardNumber = pobj.IDCardNumber
	s eobj.ContactsName = pobj.ContactsName
	s eobj.ContractsPhone = pobj.ContractsPhone
	s eobj.Hospital = pobj.Hospital
	s eobj.MainDiagType=pobj.MainDiagType
	d pobj.%Close()	
	k pobj	
	
	s str = eobj.JsonS()	
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-02-01
/// Description:入院出院状态修改
/// Input:type状态类型
/// Table：WDT.CDSS.DEMOPatMaster
/// Other: w ##class(web.CDSS.Demo.PatMaster).UpdateType()
ClassMethod UpdateType(id, type) As %String
{
	s result=""
	s obj=##class(WDT.CDSS.DEMOPatMaster).%OpenId(id)

	s obj.Type=type
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s result = "{success:'true'}" 
	}
	else{
		s result = "{success:'false'}" 
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2021-02-02
/// Description:保存前台选择患者
/// Input:id  患者id
/// Table：WDT.CDSS.DEMOPatMaster
/// Other: w ##class(web.CDSS.Demo.PatMaster).SavePatId()
ClassMethod SavePatId(id) As %String
{
	k ^TMPDHCDSSDEMO("PatMaster",%session.Data("LOGON.USERCODE"))
	s ^TMPDHCDSSDEMO("PatMaster",%session.Data("LOGON.USERCODE"))=id
	q ""
}

/// Creator：高姗姗
/// CreatDate: 2021-02-02
/// Description:获取前台选择患者
/// Table：WDT.CDSS.DEMOPatMaster
/// Other: w ##class(web.CDSS.Demo.PatMaster).GetPatId()
ClassMethod GetPatId() As %String
{
	s PatId=$g(^TMPDHCDSSDEMO("PatMaster",%session.Data("LOGON.USERCODE")))
	q PatId
}

/// Creator：高姗姗
/// CreatDate: 2021-02-02
/// Description:获取前台选择患者信息
/// Table：WDT.CDSS.DEMOPatMaster
/// Other: w ##class(web.CDSS.Demo.PatMaster).GetPatMaster()
ClassMethod GetPatMaster() As %String
{
	s result=""
	s Name="",Department="",Sex="",AgeStr="",BedNumber="",AdmissionCount=""
	s PatId=$g(^TMPDHCDSSDEMO("PatMaster",%session.Data("LOGON.USERCODE")))
	if (PatId'=""){
		
		s Name = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatId)),8) //姓名
		s Department = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatId)),14) //科室
		s Sex = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatId)),9) //性别
		s Age = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatId)),11) //年龄
		s AgeUnit = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatId)),12) //年龄单位
		s:Age'="" AgeStr=Age_AgeUnit
		s BedNumber = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatId)),6)	//床号
		s AdmissionCount = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatId)),5) //住院号
		
	}
	//姓名^科室^性别^年龄^床号^住院号
	s result=Name_"^"_Department_"^"_Sex_"^"_AgeStr_"^"_BedNumber_"^"_AdmissionCount
	q result
}

/// Creator：高姗姗
/// CreatDate: 2021-04-30
/// Description:获取患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOPatMaster
/// Other: w ##class(web.CDSS.Demo.PatMaster).GetPatMasterJson("1024")
ClassMethod GetPatMasterJson(id) As %String
{
	s PatJson={}
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(id)
	
    s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	s Name =pobj.Name //患者姓名
	s UserID ="" //医生ID 
	s UserName ="" //医生姓名
	s DeptCode ="" //科室编码
	s DeptName =pobj.Department //科室名称
	s HospCode ="" //医院编码
	s HospName =pobj.Hospital //医院名称
	s PageSource ="1" //数据来源 1 住院电子病历  2 住院医生站 3 门诊电子病历 4门诊医生站 5 手术 6 检查 7 检验 8 护理
	s Sex =pobj.Sex //性别
	s Age =pobj.Age //年龄
	s Profession =pobj.Profession //职业
	s Nation ="" //名族
	s Marriage =pobj.Marriage //婚姻
	s BloodGroup ="" //血型
	s Country ="" //国籍
	s Birthplace =pobj.BirthPlace //籍贯
	s CurrentAddress =pobj.Address //现住址
	s PhoneNumber =pobj.PhoneNumber //电话
	d PatJson.%Set("IDNO",IDNO)
	d PatJson.%Set("PatientDR",PatientDR)
	d PatJson.%Set("VisitID",VisitID)
	d PatJson.%Set("VisitType",VisitType)
	d PatJson.%Set("Name",Name)
	if ($d(%session))
	{
		d PatJson.%Set("UserID",$g(%session.Data("LOGON.USERID")))
		d PatJson.%Set("UserName",$g(%session.Data("LOGON.USERNAME")))	
		d PatJson.%Set("DeptCode",$g(%session.Data("LOGON.CTLOCID")))
		d PatJson.%Set("DeptName",$g(%session.Data("LOGON.CTLOCDESC")))
	}
	d PatJson.%Set("HospCode",HospCode)
	d PatJson.%Set("HospName",HospName)
	d PatJson.%Set("PageSource",PageSource)
	/* //最新版接口文档无需传以下内容
	d PatJson.%Set("Sex",Sex)
	d PatJson.%Set("Age",Age)
	d PatJson.%Set("Profession",Profession)
	d PatJson.%Set("Nation",Nation)
	d PatJson.%Set("Marriage",Marriage)
	d PatJson.%Set("BloodGroup",BloodGroup)
	d PatJson.%Set("Country",Country)
	d PatJson.%Set("Birthplace",Birthplace)
	d PatJson.%Set("CurrentAddress",CurrentAddress)
	d PatJson.%Set("PhoneNumber",PhoneNumber)*/
	q PatJson.%ToJSON()
}

/// Creator：高姗姗
/// CreatDate: 2021-10-28
/// Description:同步患者临床信息表
/// Table：WDT.CDSS.DEMOPatMaster
/// Other: w ##class(web.CDSS.Demo.PatMaster).SyncData()
ClassMethod SyncData() As %String
{
	s PatDR = ""
	for
	{
		s PatDR = $o(^WDT.CDSS.DEMOPatMasterD(PatDR))
		q:PatDR=""
		s IDNO = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),2)
		s PatientDR = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),3) //医院ID
		s CaseNum = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),4) //病案号
		s AdmissionCount = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),5) //住院号
		s Name = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),8) //姓名
		s Sex = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),9) //性别
		s Birthday = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),10)
		s Age = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),11) //年龄
		s AgeUnit = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),12) //年龄单位
		s Department = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),14) //科室
		s MainDiag = $lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),15) //主诊断
		s Hospital=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),30) //医院
		s RowId=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",PatDR,"")) //入院记录Id
		if (RowId'=""){
			s robj = ##class(WDT.CDSS.DEMOAdmRec).%OpenId(RowId)
			s ChiefCompSum = robj.ChiefCompSum
			s CurrentMedHisSum = robj.CurrentMedHisSum
			s PastDiagnosisSum = robj.PastDiagnosisSum
			s AllergyHisSum = robj.AllergyHisSum
			s PersonalHisSum = robj.PersonalHisSum
			s MarryHisSum = robj.MarryHisSum
			s MenstrualHisSum = robj.MenstrualHisSum
			s FamilyHisSum = robj.FamilyHisSum
			s PhysicalExamSum = robj.PhysicalExamSum
			s SpecExamSum = robj.SpecExamSum
			s AssisExam = robj.AssisExam
			s CurrentTreatMedication = robj.CurrentTreatMedication
			s PreliminaryDiag = robj.PreliminaryDiag
			s ConfirmDiag = robj.ConfirmDiag
			s ComplementaryDiag = robj.ComplementaryDiag
			s DiagnosisCorrecting = robj.DiagnosisCorrecting
			s DoctorSign = robj.DoctorSign
			s RecordTime = robj.RecordTime
			
			
			;同步CDSS临床信息表
			;(1)web.CDSS.PatientView.HISPatVisitSign#SaveData
			s VisitDR=PatDR
			s eobj = ##class(web.CDSSEntity.PatientView.HISPatVisitSign).%New()
			s eobj.HISPatVisitDR = VisitDR
            s eobj.ObsDate = ""
            s eobj.ObsItemCode = ""
            s eobj.ObsItemValue= "&%&%&%&%&%&%"
            s scVisitSign=##class(web.CDSS.PatientView.HISPatVisitSign).SaveData(eobj)
            w "scVisitSign:"_scVisitSign_"    "
            
            ;(2)web.CDSS.MachineLearning.ParseMode#ParsePatientModel
            s JSONData={}
            d JSONData.%Set("IDNO",IDNO)
            d JSONData.%Set("PatientDR",PatientDR)
            d JSONData.%Set("UserID","13925")
            d JSONData.%Set("UserName","高姗姗")
            d JSONData.%Set("CTLocID","")
            d JSONData.%Set("CTLocDesc",Department)
            d JSONData.%Set("VisitID","1")
            d JSONData.%Set("VisitType","3")
            s childrenParent=[]
            s childrenClass={}
            d childrenClass.%Set("DataClass","DHCDSSSignInfo")
            s children=[]
            s JsonChildren={}
            d JsonChildren.%Set("MeasureDate",$ZDATETIME($h,3))
            d JsonChildren.%Set("BodyTemperature","")
            d JsonChildren.%Set("BloodPressure","")
            d JsonChildren.%Set("DiastolicBlood","")
            d JsonChildren.%Set("SystolicBlood","")
            d JsonChildren.%Set("Pulse","")
            d JsonChildren.%Set("BreathFeature","")
            d JsonChildren.%Set("HeartRate","")
            d JsonChildren.%Set("OxygenSaturation","")
            d JsonChildren.%Set("Pupil","")
            d JsonChildren.%Set("CornealReflex","")
            d JsonChildren.%Set("Height","")
            d JsonChildren.%Set("Weight","")
            d children.%Push(JsonChildren)
            d childrenClass.%Set("children",children)
            d childrenParent.%Push(childrenClass)
            d JSONData.%Set("children",childrenParent)
            s json=JSONData.%ToJSON() 
            s resParseMode=##class(web.CDSS.MachineLearning.ParseMode).ParsePatientModel(json)
            w "resParseMode:"_resParseMode_"    "
            
            ;(3)web.CDSS.MachineLearning.InteractiveInterface#DHCHisInterface
            s record={}
            d record.%Set("IDNO",IDNO)
            d record.%Set("PatientDR",PatientDR)
            d record.%Set("VisitID","1")
            d record.%Set("VisitType","3")
            d record.%Set("Name",Name)
            d record.%Set("UserID","13925")
            d record.%Set("UserName","高姗姗")
            d record.%Set("DeptCode","")
            d record.%Set("DeptName",Department)
            d record.%Set("HospCode","")
            d record.%Set("HospName",Hospital)
            s PatientInfo={}
            if (Sex = "女") {
	            s Gender = 0
	        } elseif (Sex = "男") {
	            s Gender = 1
	        } else{ 
	            s Gender = 2
	        }
            d PatientInfo.%Set("Gender",Gender)
            d PatientInfo.%Set("BirthDate",Birthday)
            d PatientInfo.%Set("PregnancyStatus",0)
            d record.%Set("PatientInfo",PatientInfo)
            s ProgressNoteList={}
            d ProgressNoteList.%Set("ProgressId",##class(web.CDSS.Demo.PatMaster).GetLastIDNO()_1)
            d ProgressNoteList.%Set("ProgressType",0)
            d ProgressNoteList.%Set("ProgressTempleateID",##class(web.CDSS.Demo.PatMaster).GetLastIDNO()_1)
            d ProgressNoteList.%Set("ProgressTemplateName","")
            d ProgressNoteList.%Set("MsgType",2)
            d ProgressNoteList.%Set("Message","")
            s MessageList=[]
            s MessageArr("1","主诉")=ChiefCompSum
            s MessageArr("2","现病史")=CurrentMedHisSum
            s MessageArr("3","既往史")=PastDiagnosisSum
            s MessageArr("4","个人史")=PersonalHisSum
            s MessageArr("5","婚育史")=MarryHisSum
            s MessageArr("6","过敏史")=AllergyHisSum
            s MessageArr("7","家族史")=FamilyHisSum
            s MessageArr("8","月经史")=MenstrualHisSum
            s MessageArr("9","体格检查")=PhysicalExamSum
            s MessageArr("10","专科检查")=SpecExamSum
            s MessageArr("11","初步诊断")=PreliminaryDiag
            s MessageArr("12","确诊诊断")=ConfirmDiag
            s MessageArr("13","补充诊断")=ComplementaryDiag
            s MessageArr("14","修正诊断")=DiagnosisCorrecting
            
            s idNum=""
            for {
	        	s idNum=$o(MessageArr(idNum)) q:idNum=""
	        	s key=$o(MessageArr(idNum,""))
	        	s value=$g(MessageArr(idNum,key))
	        	s message={}
	        	d message.%Set("key",key)  
	        	d message.%Set("value",value)    
	        	d MessageList.%Push(message)
	        }
            d ProgressNoteList.%Set("MessageList",MessageList)
            d ProgressNoteList.%Set("DoctorId","13925")
            d ProgressNoteList.%Set("DoctorName","高姗姗")
            d ProgressNoteList.%Set("CreateDeptCode","")
            d ProgressNoteList.%Set("CreateDeptName",Department)
            d ProgressNoteList.%Set("RecordTime",$ZDATETIME($h,3))
           	d record.%Set("ProgressNoteList",ProgressNoteList)
           	s jsonRecord=record.%ToJSON()
           	s scHis=##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisInterface("SAVE_MEDICAL_RECORD_INFORMATION",jsonRecord)
			w "scHis:"_scHis,!
			
		}
	}
	q "over"
}

}
