/// 名称: DHCMed.INFService.InterfaceIn
/// 描述 提供给外部的接口
/// 编写者：ChenJB
/// 编写日期: 2010-09-20
Class DHCMed.INFService.InterfaceIn Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-09-13
/// Description:  查询报告状态信息
/// Table：       接口
/// Input：       报告ID ： 报告ID
/// output:       符合条件的项            
/// Return：      报告存在返回 报告状态  报告不存在 返回空        
///               0 --删除 1 --待审 2-- 已审 3--订正 9-- 退回 10 -- 被订
/// w ##class(DHCMed.INFService.InterfaceIn).GetReportStatus("1","51104")
ClassMethod GetReportStatus(TypeCode As %String = "", Paadm As %String = "") As %String
{
     n (TypeCode,Paadm)
     s ret=""
     q:(TypeCode="")!(Paadm="") ret 
     //^DHCMed.INF.ReportI("TypePaadm"," 1",51104,7)
     s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
     q:'$d(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,Paadm)) ret
     s rowid=""
     f  s rowid=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,Paadm,rowid)) q:(rowid="")!(ret'="")  d
     .s RepObj=##class(DHCMed.INF.Report).GetObjById(rowid)
     .q:'$IsObject(RepObj)
     .s ret=RepObj.StatusDr
     q ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-11-16
/// Description:  查询就诊的所有报告类型
/// Table：       接口
/// Input：       Paadm ： 就诊ID
/// output:       符合条件的项            
/// Return：      报告信息        
///               0 --删除 1 --待审 2-- 已审 3--订正 9-- 退回 10 -- 被订
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InterfaceIn","QryRepsByPaadm","51104")
Query QryRepsByPaadm(TypeCode As %String = "", EpisodeID As %String = "") As %Query(ROWSPEC = "rowid:%String,typeCode:%String,typeDesc:%String,paadm:%String,patName:%String,patLoc:%String,RepLoc:%String,patID:%String,statusDesc:%String,RepDate:%String,RepTime:%String,RepUser:%String,repLocID:%String,repStaDr:%String")
{
}

ClassMethod QryRepsByPaadmExecute(ByRef qHandle As %Binary, TypeCode As %String = "", EpisodeID As %String = "") As %Status
{

	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(EpisodeID="") $$$OK 
    //^DHCMed.INF.ReportI("TypePaadm"," 1",51104,7)
    //s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s TypeCodeIdx=""
    f  s TypeCodeIdx=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx)) q:TypeCodeIdx=""  d
    .s rowid=""
    .q:(TypeCode'="")&((" "_TypeCode)'=TypeCodeIdx)
    .f  s rowid=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,EpisodeID,rowid)) q:(rowid="")  d
    ..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s repStaDr=objCls.StatusDr
	..//q:(Sstatus'="")&(Sstatus'[repStaDr)
	..s typeCode=objCls.Type
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(typeCode,"InfectionType")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..s typeDesc=""
	..i $IsObject(objDic)  d
	...s typeDesc=objDic.Description
	...k objDic
	..s paadm=objCls.PaadmDR
	..s patName=""
	..s patLoc=""
	..s repLoc=""
	..s patID=""
	..s userID=objCls.UserDR
	..s RepUser=""
	..i userID'="" d
	...s objUser=##class(DHCMed.Base.SSUser).GetObjById(userID)
	...s:$IsObject(objUser) RepUser=objUser.Name
	..s statusDesc=""
	..s RepDate=objCls.RepDate
	..s RepTime=objCls.RepTime
	..s:+RepDate'=0 RepDate=$zd(+RepDate,3)
	..s:+RepTime'=0 RepTime=$zt(+RepTime,1)
	..i repStaDr'="" d
	...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(repStaDr,"InfectionReportStatus")
	...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	...s:$IsObject(objDic) statusDesc=objDic.Description
	..s objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..i $IsObject(objPaadm)  d
	...s patLoc=objPaadm.Department
	...s patID=objPaadm.PatientID
	...s objPat=##class(DHCMed.Base.Patient).GetObjById(patID)
	...i $IsObject(objPat)  d
	....s patName=objPat.PatientName
	....k objPat
	...k objPaadm
	..s repLocID=objCls.CtLoc
	..//q:(cLoc'="")&(cLoc'=repLocID)
	..s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(repLocID)
	..i $IsObject(objLoc) d
	...s repLoc=objLoc.Descs
	...k objLoc
	..s Data=$lb(rowid,typeCode,typeDesc,paadm,patName,patLoc,repLoc,patID,statusDesc,RepDate,RepTime,RepUser,repLocID,repStaDr)
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1

	Quit $$$OK
}

ClassMethod QryRepsByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepsByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepsByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepsByPaadmExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator：     ChenJB
/// CreatDate：   2010-11-11
/// Description:  院感数据导出路径
/// Table：       接口
/// Input：       
/// output:                   
/// Return：              
///               
/// w ##class(DHCMed.INFService.InterfaceIn).GetExportPath()
ClassMethod GetExportPath() As %String
{
     n
     s ret=""
     //$ZCVT(TypeCode,"U")
     s ret=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("InfExportPath","")
     s:ret="" ret="C:\\"
     q ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-11-11
/// Description:  院感数据导出
/// Table：       接口
/// Input：       
/// output:                   
/// Return：              
///               
/// w ##class(DHCMed.INFService.InterfaceIn).GetExportData(1,51104,"")
ClassMethod GetExportData(Type As %String, Paadm As %String, InfRepDr As %String = "") As %String
{
	n (Type,Paadm,InfRepDr)
	s str=""
	q:Paadm="" str	
	s JIndex=$zd(+$h,3)_" "_$zt($p($h,",",2),1)    //val: 2010-11-12 09:11:26
	k ^DHCMed.InfExport(JIndex,Paadm)
	s retProc=..ProcessInfDataByPaadm(JIndex,Type,Paadm,InfRepDr)
	q:retProc=0 ""
	
	s $p(str,$c(2),1)=..GetInfectionData(JIndex,Paadm,"文件保存路径")
	s $p(str,$c(2),2)=..GetInfectionData(JIndex,Paadm,"接口数据错误提示")
	s $p(str,$c(2),3)=..GetInfectionData(JIndex,Paadm,"病人基本信息")
	/*
	set $p(str,$c(2),4)=$$GetInfectionData(JIndex,Paadm,"基础疾病")
	set $p(str,$c(2),5)=$$GetInfectionData(JIndex,Paadm,"手术情况")
	set $p(str,$c(2),6)=$$GetInfectionData(JIndex,Paadm,"易感因素")
	set $p(str,$c(2),7)=$$GetInfectionData(JIndex,Paadm,"侵害性操作")
	set $p(str,$c(2),8)=$$GetInfectionData(JIndex,Paadm,"感染部位详细情况")
	set $p(str,$c(2),9)=$$GetInfectionData(JIndex,Paadm,"检测标本详细情况")
	set $p(str,$c(2),10)=$$GetInfectionData(JIndex,Paadm,"标本检测出的病原体详细情况")
	set $p(str,$c(2),11)=$$GetInfectionData(JIndex,Paadm,"药敏试验结果")
	set $p(str,$c(2),12)=$$GetInfectionData(JIndex,Paadm,"抗菌药物使用情况")
	set $p(str,$c(2),13)=$$GetInfectionData(JIndex,Paadm,"感染部位相关的侵害性操作")
	
	set $p(str,$c(2),14)=$$GetInfectionData(JIndex,Paadm,"ICU病人基本情况")
	set $p(str,$c(2),15)=$$GetInfectionData(JIndex,Paadm,"ICU的疾病诊断")
	set $p(str,$c(2),16)=$$GetInfectionData(JIndex,Paadm,"中心静脉插管情况")
	*/
	//kill:$$GetInfectionData(JIndex,Paadm,"接口数据错误提示")="" ^DHCMedInfExport(JIndex,Paadm)
	quit str
}

/// 处理需要导出的数据,数据暂时存在Global中
/// 如果一个文件多条记录,$c(1)分割,这样再到前台去处理
/// 哪些文件是必须的,哪些字段是必须的,需要在这里做判断
/// 字段格式 严格按照借口要求
/// 字段之间用$c(9)分割
ClassMethod ProcessInfDataByPaadm(JIndex As %String, Type As %String, Paadm As %String, InfRepDr As %String) As %String
{
	n (JIndex,Type,Paadm,InfRepDr)
	s ret=""
	s:InfRepDr="" RepRowid=##class(DHCMed.INFService.InfReportSrv).GetReportID(Paadm,Type)
	s:InfRepDr'="" RepRowid=InfRepDr
	q:+RepRowid=0 ret
	s objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	q:'$IsObject(objPaadm) ret
	s Papmi=objPaadm.PatientID
	s objPatient=##class(DHCMed.Base.Patient).GetObjById(Papmi)
	q:'$IsObject(objPatient) ret
	s RegNo=objPatient.PapmiNo
	s PatName=objPatient.PatientName
    s ^DHCMed.InfExport(JIndex,Paadm,"登记号",RegNo)=""
    s:PatName'="" ^DHCMed.InfExport(JIndex,Paadm,"病人姓名",PatName)=""
    s tmpFolderName=RegNo_"-"_PatName_"-"_Paadm
    //病人基本信息，不允许为空
    s xPatientBaseInfo=..xGetPatientBaseInfo(RepRowid)
    d:$p(xPatientBaseInfo,$c(3),1)="" ..xInfoDataErr(JIndex,Paadm,"病人基本信息为空;")
    s:$p(xPatientBaseInfo,$c(3),1)'="" ^DHCMed.InfExport(JIndex,Paadm,"病人基本信息")=$p(xPatientBaseInfo,$c(3),1)
    d:$p(xPatientBaseInfo,$c(3),2)'="" ..xInfoDataErr(JIndex,Paadm,"病人基本信息:"_$p(xPatientBaseInfo,$c(3),2))
    //疾病诊断(多条诊断,$c(1)分割)，允许为空
    //存在问题：
    //基础疾病取的是HIS中的诊断，上传需要ICD10代码
    //如果各家医院要求上传，那就去对诊断库ICD10代码/替换诊断库/做对照
    //现在此项默认为空
    //s xBaseDiagnose=$$xGetBaseDiagnose(RepRowid)
    //d:$p(xBaseDiagnose,$c(3),1)="" xInfoDataErr(JIndex,Paadm,"基础疾病为空;")
    //s:$p(xBaseDiagnose,$c(3),1)'="" ^DHCMedInfExport(JIndex,Paadm,"基础疾病")=$p(xBaseDiagnose,$c(3),1)
    //d:$p(xBaseDiagnose,$c(3),2)'="" xInfoDataErr(JIndex,Paadm,"基础疾病:"_$p(xBaseDiagnose,$c(3),2))
	
	//文件保存路径，不允许为空
    //s ^DHCMed.InfExport(JIndex,Paadm,"文件夹名称",tmpFolderName)="Y"
    s xFilePath=..GetExportPath()_tmpFolderName
    d:xFilePath="" ..xInfoDataErr(JIndex,Paadm,"文件保存路径为空;")
    s:xFilePath'="" ^DHCMed.InfExport(JIndex,Paadm,"文件保存路径")=xFilePath
	q 1
}

ClassMethod GetInfectionData(JIndex As %String, Paadm As %String, DataCell As %String) As %String
{
	n (JIndex,Paadm,DataCell)
    s ret=""
    q:(Paadm="")!(DataCell="") ret
    s ret=$g(^DHCMed.InfExport(JIndex,Paadm,DataCell))
    q ret
}

ClassMethod xInfoDataErr(JIndex As %String, Paadm As %String, Info As %String) As %String
{
	n (JIndex,Paadm,Info)
	s ret=""
    q:Info=""
    s tmp=$g(^DHCMed.InfExport(JIndex,Paadm,"接口数据错误提示"))
    i tmp="" s ^DHCMed.InfExport(JIndex,Paadm,"接口数据错误提示")=Info
    e  s ^DHCMed.InfExport(JIndex,Paadm,"接口数据错误提示")=tmp_$c(1)_Info
    q ret
}

ClassMethod xGetPatientBaseInfo(RepRowid As %String) As %String
{
	n (RepRowid,objPaadm,objPatient)
	s strExp="",strErr="",ret=""
	s objRep=##class(DHCMed.INF.Report).GetObjById(RepRowid)
	// 取Summ 
	q:'$IsObject(objRep) ""
	s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",RepRowid,""),-1)
	q:sumID="" ret
	s objRepSum=##class(DHCMed.INF.Summary).GetObjById(sumID)
	q:'$IsObject(objRepSum) ret
	s:+objRep.RepDate=0 strErr=strErr_"调查表时间为空; "
    s $p(strExp, $c(9), 1)=$zd(objRep.RepDate,3)             //1调查表时间（发生院内感染的时间）***----我用的是报告日期
	//CtLoc
	s TrakLocID=objRep.CtLoc
	s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(TrakLocID)
	s LocID=$o(^DHCMed.INF.InfLocContrastI("CtlocDR",TrakLocID,""))
	s DicLocDesc="",LocDesc=""
	s:$IsObject(objLoc) LocDesc=objLoc.Descs
	i +LocID>0 d
	.s obj=##class(DHCMed.INF.InfLocContrast).%OpenId(LocID)
	.//标准科室表rowid
	.s objDicLoc=##class(DHCMed.INF.InfLocDic).GetObjById(obj.InflocDR)
	.s:$IsObject(objDicLoc) DicLocDesc=objDicLoc.Description	// 标准科室描述
	s:DicLocDesc="" strErr=strErr_"感染科别为空; "
    s $p(strExp, $c(9), 2) = DicLocDesc              //2感染科别***
    s $p(strExp, $c(9), 3) = LocDesc                 //3院内科别
    s:+objRep.RepDate=0 strErr=strErr_"调查表登记日期为空; "
    s $p(strExp, $c(9), 4) = $zd(objRep.RepDate,3)           //4调查表登记日期***
    
    s objUser=##class(DHCMed.Base.SSUser).GetObjById(objRep.UserDR)
    s:'$IsObject(objUser) strErr=strErr_"调查者为空; "
    s $p(strExp, $c(9), 5) = objUser.Name                //5调查者***
    
    s:objPatient.InPatMrNo="" strErr=strErr_"病历号为空; "
    s $p(strExp, $c(9), 6) = objPatient.InPatMrNo          //6病历号***
    s cnt=..CountDischargeTime(objPaadm.AdmRowID)
    s:+cnt=0 strErr=strErr_"本月住院次数 0; "
	s $p(strExp, $c(9), 7) = +cnt                       //7本月住院次数（本院转入该科室的次数）***
	
	s:objPatient.PatientName="" strErr=strErr_"患者姓名为空; "
 	s $p(strExp, $c(9), 8) = objPatient.PatientName           //8姓名***
 	
 	s:objPatient.Sex="" strErr=strErr_"性别为空; "
 	s $p(strExp, $c(9), 9) = objPatient.Sex               //9性别***
 	
 	s:objPatient.AgeDay="" strErr=strErr_"年龄为空; "
 	s $p(strExp, $c(9), 10) = objPatient.AgeDay          //10年龄***
 	s $p(strExp, $c(9), 11) = objPaadm.Bed             //11床位号
 	
 	s:objPaadm.AdmitDate="" strErr=strErr_"入院日期为空; "
 	s $p(strExp, $c(9), 12) = objPaadm.AdmitDate              //12入院日期***
 	
 	s $p(strExp, $c(9), 13) = objPaadm.DisDate             //13出院日期
	s $p(strExp, $c(9), 14) = 1                                 //14医院感染
	s $p(strExp, $c(9), 15) = 0                                 //15漏报病人
	s $p(strExp, $c(9), 16) = 1                                 //16调查方式 1、前瞻；2、回顾
 	s $p(strExp, $c(9), 17) = (objRepSum.ICUFlag'=0)         //17 ICU检测
 	
 	s:objRepSum.LapseTo="" strErr=strErr_"疾病转归为空; "
 	s $p(strExp, $c(9), 18) = objRepSum.LapseTo                //18疾病转归***
 	
 	s:objRepSum.DeathConnection=3 objRepSum.DeathConnection=0
 	s $p(strExp, $c(9), 19) = objRepSum.DeathConnection                //19与死亡关系
 	s $p(strExp, $c(9), 20) = objRepSum.Analysis                                //20感染性疾病病程
 	s $p(strExp, $c(9), 21) = objRepSum.Treatment                                //21感染疾病诊断依据
 	s $p(strExp, $c(9), 22) = (objRepSum.ICUFlag'=0)         //22是否转入过ICU
 	s $p(strExp, $c(9), 23) = $d(^DHCMed.INF.RepOPRI("InfRepDr",RepRowid))    //23手术
 	s $p(strExp, $c(9), 24) = $d(^DHCMed.INF.PathogenyI("InfRepDr",RepRowid))  //24病原学检测
 	s $p(strExp, $c(9), 25) = $d(^DHCMed.INF.RepDrugI("InfRepDr",RepRowid))     //25使用抗生素使用
 	s $p(strExp, $c(9), 26) = (objRepSum.DrugEffect = "Y")        //26不良反应
 	s $p(strExp, $c(9), 27) = (objRepSum.DblInfFlag = "Y")        //27二重感染	
 	s:strErr'="" strExp=strExp_$c(3)_strErr
    q strExp
}

ClassMethod CountDischargeTime(Paadm As %String) As %String
{
	new (Paadm,objPaadm,objPatient)
	set RegNo = objPatient.PapmiNo
	set strDep = objPaadm.DepartmentID
	set strDisDate = objPaadm.AdmitDate      // 取出院日期
	set strDisDate = $e(strDisDate,1,7)
	set admList = ..GetAdmsByPatNo(RegNo, "I")
	set intCounter = 0
	set intCnt = 0
	for intCounter=1:1:$l(admList, $c(1))
	{
		set paadmNo = $p(admList, $c(1), intCounter)
		continue:paadmNo=""
		set objTmpPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(paadmNo)
		set tmpDate = objTmpPaadm.AdmitDate
		set tmpDate = $extract(tmpDate, 1, 7)
		set tmpDep = objTmpPaadm.DepartmentID
		set:(tmpDep=strDep)&&(tmpDate=strDisDate) intCnt=intCnt+1
	}
	quit intCnt
}

ClassMethod GetAdmsByPatNo(PatNo As %String, AdmType As %String) As %String
{
   n (PatNo,AdmType)
   ;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
   ;Add by wuqk 2008-04-25
   s PAPMI=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
   q:(PAPMI="")!(AdmType="") ""
   q:'$d(^PAPERdr(PAPMI,"ADM",AdmType)) ""
   s sPaadm=""
   s paadm=""
   f  s paadm=$o(^PAPERdr(PAPMI,"ADM",AdmType,paadm)) q:paadm=""  d
   .s sPaadm=sPaadm_$g(paadm)_$c(1)
   q sPaadm
}

ClassMethod xGetPathogenInfoCnt(RepRowid As %String) As %String
{
	n (RepRowid)
	s ret=""
	
	q ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-11-23
/// Description:  查询报告信息
/// Table：       接口
/// Input：       类型 ： TypeCode  就诊号： Paadm
/// output:       符合条件的项            
/// Return：      报告存在返回 串 报告不存在 返回空        
///               0 --删除 1 --待审 2-- 已审 3--订正 9-- 退回 10 -- 被订
/// w ##class(DHCMed.INFService.InterfaceIn).GetReportInfoForM("2","51104")
ClassMethod GetReportInfoForM(TypeCode As %String = "", Paadm As %String = "") As %String
{
     n (TypeCode,Paadm)
     s ret=""
     q:(TypeCode="")!(Paadm="") ret 
     //^DHCMed.INF.ReportI("TypePaadm"," 1",51104,7)
     s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
     q:'$d(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,Paadm)) ret
     s rowid=""
     s rowid=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,Paadm,rowid),-1)
     s objRep=##class(DHCMed.INF.Report).GetObjById(rowid)
     q:'$IsObject(objRep) ret
	 s tmpRowid=""
     s tmpRowid=$o(^DHCMed.INF.ICUInfoI("InfRepDr",rowid,tmpRowid),-1)
     s objCls=##class(DHCMed.INF.ICUInfo).GetObjById(tmpRowid)
     q:'$IsObject(objCls) ret
	 //q:(Sstatus'="")&(Sstatus'[repStaDr)
	 s InfBeICUCode=objCls.InfBeICUCode
     s InBeICUDate=objCls.InBeICUDate
     s InfICUCode=objCls.InfICUCode
     s InICUDate=objCls.InICUDate
     s InICUTime=objCls.InICUTime
     s InICULoc=objCls.InICULoc
     s OutICUDate=objCls.OutICUDate
     s OutICUTime=objCls.OutICUTime
     s OutICULoc=objCls.OutICULoc
     s OutStatus=objCls.OutStatus
     s OutHStatus=objCls.OutHStatus
     s OutDeviceCode=objCls.OutDeviceCode
     s ResumeText=objCls.ResumeText
     s:+InBeICUDate'=0 InBeICUDate=$zd(+InBeICUDate,3)
     s:+InICUDate'=0 InICUDate=$zd(+InICUDate,3)
     s:+InICUTime'=0 InICUTime=$zt(+InICUTime,1)
     s:+OutICUDate'=0 OutICUDate=$zd(+OutICUDate,3)
     s:+OutICUTime'=0 OutICUTime=$zt(+OutICUTime,1)
     s (InfBeICUCodeDesc,InfICUCodeDesc,InICULocDesc,OutDeviceCodeDesc,OutICULocDesc)=""
     i InICULoc'="" d
     .s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(InICULoc)
     .q:'$IsObject(objTmp)
     .s InICULocDesc=objTmp.Descs
     i OutICULoc'="" d
     .s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(OutICULoc)
     .q:'$IsObject(objTmp)
     .s OutICULocDesc=objTmp.Descs
     i InfBeICUCode'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfBeICUCode,"InfICUCode")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s InfBeICUCodeDesc=objDic.Description
     .k objDic
     i InfICUCode'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfICUCode,"InfICUCode")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s InfICUCodeDesc=objDic.Description
     .k objDic
     i OutDeviceCode'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OutDeviceCode,"OutDeviceCode")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s OutDeviceCodeDesc=objDic.Description
     .k objDic
     s ret=tmpRowid
     s ret=ret_"^"_InICUDate
     s ret=ret_"^"_InICULocDesc
     s ret=ret_"^"_InfICUCodeDesc
     s ret=ret_"^"_OutICUDate
     s ret=ret_"^"_OutICULocDesc
     s ret=ret_"^"_OutDeviceCodeDesc
     s ret=ret_"^"_ResumeText
     s rowid=""
     k objCls
     s rowid=$o(^DHCMed.INF.ICUDeviceInfoI("InfRepICU",tmpRowid,rowid),-1)
     s objCls=##class(DHCMed.INF.ICUDeviceInfo).%OpenId(rowid)
	 q:'rowid="" ret
	 s (DeviceType,DeviceTypeDesc,PipeType,PipeTypeDesc,CavityType,CavityTypeDesc,PipeBody,PipeBodyDesc)=""
	 s (PipePlace,PipePlaceDesc,DoPipeDate,DoPipeTime,UnPipeDate,UnPipeTime,WholeSyptom,WholeSyptomDesc)=""
	 s (PartSyptom,PartSyptomDesc,UserType,UserTypeDesc,DoUserDr,DoUserDrDesc,InfectionPos,InfectionPosDesc,ICUInfDate,InfICUType,InfICUTypeDesc)=""
	 s DeviceType=objCls.DeviceType
	 s PipeType=objCls.PipeType
	 s CavityType=objCls.CavityType
	 s PipeBody=objCls.PipeBody
	 s PipePlace=objCls.PipePlace
	 s DoPipeDate=objCls.DoPipeDate
	 s DoPipeTime=objCls.DoPipeTime
	 s UnPipeDate=objCls.UnPipeDate
	 s UnPipeTime=objCls.UnPipeTime
	 s WholeSyptom=objCls.WholeSyptom
	 s PartSyptom=objCls.PartSyptom
	 s UserType=objCls.UserType
	 s DoUserDr=objCls.DoUserDr
	 s InfectionPos=objCls.InfectionPos
	 s ICUInfDate=objCls.ICUInfDate
	 s InfICUType=objCls.InfICUType
	 s:+DoPipeDate'=0 DoPipeDate=$zd(DoPipeDate,3)
	 s:+DoPipeTime'=0 DoPipeTime=$zt(DoPipeTime,1)
	 s:+UnPipeDate'=0 UnPipeDate=$zd(UnPipeDate,3)
	 s:+UnPipeTime'=0 UnPipeTime=$zt(UnPipeTime,1)
	 s:+ICUInfDate'=0 ICUInfDate=$zd(ICUInfDate,3)
	 i InfectionPos'="" d
     .s objPos=##class(DHCMed.INF.InfPosition).GetObjById(InfectionPos)
     .q:'$IsObject(objPos)
     .s InfectionPosDesc=objPos.InfPosition
     .k objPos
	 i DoUserDr'="" d
     .s objUser=##class(DHCMed.Base.SSUser).GetObjById(DoUserDr)
     .q:'$IsObject(objUser)
     .s DoUserDrDesc=objUser.Name
     .k objUser
	 i DeviceType'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DeviceType,"DeviceType")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s DeviceTypeDesc=objDic.Description
     .k objDic
     i PipeType'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeType,"PipeType")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s PipeTypeDesc=objDic.Description
     .k objDic
     i PipeBody'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeBody,"PipeBody")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s PipeBodyDesc=objDic.Description
     .k objDic
     i CavityType'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CavityType,"CavityType")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s CavityTypeDesc=objDic.Description
     .k objDic
     i PipePlace'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipePlace,"PipePlace")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s PipePlaceDesc=objDic.Description
     .k objDic
     i WholeSyptom'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(WholeSyptom,"WholeSyptom")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s WholeSyptomDesc=objDic.Description
     .k objDic
     i PartSyptom'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PartSyptom,"PartSyptom")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s PartSyptomDesc=objDic.Description
     .k objDic
     i UserType'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(UserType,"UserType")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s UserTypeDesc=objDic.Description
     .k objDic
     i InfICUType'="" d
     .s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfICUType,"InfICUType")
     .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
     .q:'$IsObject(objDic)
     .s InfICUTypeDesc=objDic.Description
     .k objDic
     s ret=ret_"^"_DeviceTypeDesc
     s ret=ret_"^"_PipeTypeDesc
     s ret=ret_"^"_CavityTypeDesc
     s ret=ret_"^"_DoPipeDate
     s ret=ret_"^"_PipeBodyDesc
     s ret=ret_"^"_UnPipeDate
     s ret=ret_"^"_WholeSyptomDesc
     s ret=ret_"^"_PartSyptomDesc
	 q ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-11-23
/// Description:  查询报告信息
/// Table：       接口
/// Input：       类型 ： TypeCode  就诊号： Paadm
/// output:       符合条件的项            
/// Return：      报告存在返回 串 报告不存在 返回空        
///               0 --删除 1 --待审 2-- 已审 3--订正 9-- 退回 10 -- 被订
/// w ##class(DHCMed.INFService.InterfaceIn).GetReportInfo("1","51104")
ClassMethod GetReportInfo(TypeCode As %String = "", Paadm As %String = "") As %String
{
    n (TypeCode,Paadm)
    s ret=""
    q:(Paadm="") ret
    s TypeCodeIdx=""
    f  s TypeCodeIdx=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx)) q:TypeCodeIdx=""  d
    .s rowid=""
    .q:(TypeCode'="")&((" "_TypeCode)'=TypeCodeIdx)
    .f  s rowid=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,Paadm,rowid)) q:(rowid="")  d
    ..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s repStaDr=objCls.StatusDr
	..//q:(Sstatus'="")&(Sstatus'[repStaDr)
	..s typeCode=objCls.Type
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(typeCode,"InfectionType")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..s typeDesc=""
	..i $IsObject(objDic)  d
	...s typeDesc=objDic.Description
	...k objDic
	..s paadm=objCls.PaadmDR
	..s patName=""
	..s patLoc=""
	..s repLoc=""
	..s patID=""
	..s userID=objCls.UserDR
	..s RepUser=""
	..i userID'="" d
	...s objUser=##class(DHCMed.Base.SSUser).GetObjById(userID)
	...s:$IsObject(objUser) RepUser=objUser.Name
	..s statusDesc=""
	..s RepDate=objCls.RepDate
	..s RepTime=objCls.RepTime
	..s:+RepDate'=0 RepDate=$zd(+RepDate,3)
	..s:+RepTime'=0 RepTime=$zt(+RepTime,1)
	..i repStaDr'="" d
	...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(repStaDr,"InfectionReportStatus")
	...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	...s:$IsObject(objDic) statusDesc=objDic.Description
	..s objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..i $IsObject(objPaadm)  d
	...s patLoc=objPaadm.Department
	...s patID=objPaadm.PatientID
	...s objPat=##class(DHCMed.Base.Patient).GetObjById(patID)
	...i $IsObject(objPat)  d
	....s patName=objPat.PatientName
	....k objPat
	...k objPaadm
	..s repLocID=objCls.CtLoc
	..//q:(cLoc'="")&(cLoc'=repLocID)
	..s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(repLocID)
	..i $IsObject(objLoc) d
	...s repLoc=objLoc.Descs
	...k objLoc
	..s:ret="" ret="报告时间:"_RepDate_" "_RepTime_";报告人:"_RepUser_";报告状态:"_statusDesc
	..s:ret'="" ret=ret_$c(3)_"报告时间:"_RepDate_" "_RepTime_";报告人:"_RepUser_";报告状态:"_statusDesc
	..//s Data=$lb(rowid,typeCode,typeDesc,paadm,patName,patLoc,repLoc,patID,statusDesc,RepDate,RepTime,RepUser,repLocID,repStaDr)
    q ret
}

}
