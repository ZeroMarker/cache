/// Description: 结构化病历字典
/// Creator: 石萧伟
/// Date: 2023-03-02
Class web.CDSS.CMKB.StructEMRDict Extends %RegisteredObject
{

/// Creator:shixiaowei
/// CreatDate:2023-03-02
/// Description:获取字典表内容
/// Table: CT_WDT_CDSS.StructEMRDict
/// Input:
/// Return:返回所有字典表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.StructEMRDict","GetList","","","","","","","","")
Query GetList(rowid, dia As %String, tcm As %String, loc As %String, state As %String, starttime As %String, endtime As %String, operuser As %String) As %Query(ROWSPEC = "RowId,DiseaseDR,DiseaseName,TCMSymptomDR,TCMSymptomName,LocDR,LocName,ClinicalSymptoms,TCMTreatment,TCMPrescription,NoMedicineTreat,UseFlag,UpdateUser,UpdateDate,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, dia As %String, tcm As %String, loc As %String, state As %String, starttime As %String, endtime As %String, operuser As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
 	s RowId=rowid
 	s DiseaseDR=$lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),2)
 	s DiseaseName = ""
 	s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseDR)),3) //疾病
 	
	s TCMSymptomDR=$lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),3)
	s TCMSymptomName = ""
	s:TCMSymptomDR'="" TCMSymptomName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymptomDR)),3) //证候
	
	s LocDR = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),4)
	s LocName = ""
	s:LocDR'="" LocName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3) //科室
	
	s ClinicalSymptoms = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),5)
	s TCMTreatment  = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),6)
	s TCMPrescription = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),7)
	s NoMedicineTreat = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),8)
	s UseFlag = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),9)
	s UpdateUser = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),10)
	s UpdateDate = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),11)
	s Remarks = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),12)

	d OutputRow
 }
 else
 {
	s:dia'="" dia=$ZCONVERT(dia,"U") //转换成大写 
	s:tcm'="" tcm=$ZCONVERT(tcm,"U") //转换成大写 
	s:loc'="" loc=$ZCONVERT(loc,"U") //转换成大写 
	s:operuser'="" operuser=$ZCONVERT(operuser,"U") //转换成大写 
	s date=""
	for
	{
		s date=$o(^CT.WDT.CDSS.StructEMRDictI("DateIndex",date),-1) q:date=""
		s RowId=""
		for
		{
			s RowId=$o(^CT.WDT.CDSS.StructEMRDictI("DateIndex",date,RowId),-1) q:RowId="" 
		 	s DiseaseDR=$lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),2)
		 	s DiseaseName = ""
		 	s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseDR)),3) //疾病
		 	
			s TCMSymptomDR=$lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),3)
			s TCMSymptomName = ""
			s:TCMSymptomDR'="" TCMSymptomName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymptomDR)),3) //证候
			
			s LocDR = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),4)
			s LocName = ""
			s:LocDR'="" LocName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3) //科室
			
			s ClinicalSymptoms = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),5)
			s TCMTreatment  = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),6)
			s TCMPrescription = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),7)
			s NoMedicineTreat = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),8)
			s UseFlag = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),9)
			s:UseFlag="" UseFlag=0
			if (state=""){
				continue:(UseFlag=1)			
			}
			else{
				continue:((state'="")&&(UseFlag'=state))
			}
			s UpdateUser = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),10)
			continue:((operuser'="")&&($ZCONVERT(UpdateUser,"U")'[operuser))
			s UpdateDate = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),11)
			s Remarks = $lg($g(^CT.WDT.CDSS.StructEMRDictD(RowId)),12)
			continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
	    	continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
			
			if (($ZCONVERT(DiseaseName,"U")[dia)&($ZCONVERT(DiseaseName,"U")[dia)&($ZCONVERT(TCMSymptomName,"U")[tcm)&($ZCONVERT(TCMSymptomName,"U")[tcm)&($ZCONVERT(LocName,"U")[loc)&($ZCONVERT(LocName,"U")[loc)) 
			{
				d OutputRow
			}
		}
	}	
}

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RowId,DiseaseDR,DiseaseName,TCMSymptomDR,TCMSymptomName,LocDR,LocName,ClinicalSymptoms,TCMTreatment,TCMPrescription,NoMedicineTreat,UseFlag,UpdateUser,UpdateDate,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Creator：shixiaowei
/// CreatDate: 2022-03-02
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.StructEMRDict).SaveData()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.StructEMRDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.StructEMRDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			
			s obj=##class(CT.WDT.CDSS.StructEMRDict).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.StructEMRDict).%New() 
			if $IsObject(obj.DiseaseDR)
			{
			 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
			}
			if $IsObject(obj.TCMSymptomDR)
			{
			 	s bobj.TCMSymptomDR = obj.TCMSymptomDR.%Id()
			}
			if $IsObject(obj.LocDR)
			{
			 	s bobj.LocDR = obj.LocDR.%Id()
			}
			s bobj.ClinicalSymptoms = obj.ClinicalSymptoms
			s bobj.TCMTreatment = obj.TCMTreatment
			s bobj.TCMPrescription = obj.TCMPrescription
			s bobj.NoMedicineTreat = obj.NoMedicineTreat
			s bobj.UseFlag = obj.UseFlag
			s bobj.UpdateUser =obj.UpdateUser 
			s bobj.UpdateDate = obj.UpdateDate
			s bobj.Remarks = obj.Remarks
		}
		s eobj.UpdateUser="dhcc"
		if ($d(%session))
		{
			s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))
		}
		s eobj.UpdateDate=$zdt($h,3)
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		d:eobj.TCMSymptomDR'="" obj.TCMSymptomDRSetObjectId(eobj.TCMSymptomDR)
		d:eobj.LocDR'="" obj.LocDRSetObjectId(eobj.LocDR)
		
		s obj.ClinicalSymptoms = eobj.ClinicalSymptoms
		s obj.TCMTreatment = eobj.TCMTreatment
		s obj.TCMPrescription = eobj.TCMPrescription
		s obj.NoMedicineTreat = eobj.NoMedicineTreat
		s obj.UseFlag = eobj.UseFlag
		s obj.UpdateUser =eobj.UpdateUser 
		s obj.UpdateDate = eobj.UpdateDate
		s obj.Remarks = eobj.Remarks
		
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.StructEMRDict","CT.WDT.CDSS.StructEMRDict","结构化病历",id,eobj.ClinicalSymptoms,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.StructEMRDict","CT.WDT.CDSS.StructEMRDict","结构化病历",eobj.RowId,eobj.ClinicalSymptoms,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("结构化病历","web.CDSS.CMKB.StructEMRDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("结构化病历","web.CDSS.CMKB.StructEMRDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：shixiaowei
/// CreatDate: 2023-03-02
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.StructEMRDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.StructEMRDict).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.StructEMRDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.StructEMRDict).%New() 
	if $IsObject(obj.DiseaseDR)
	{
	 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
	}
	if $IsObject(obj.TCMSymptomDR)
	{
	 	s bobj.TCMSymptomDR = obj.TCMSymptomDR.%Id()
	}
	if $IsObject(obj.LocDR)
	{
	 	s bobj.LocDR = obj.LocDR.%Id()
	}
	s bobj.ClinicalSymptoms = obj.ClinicalSymptoms
	s bobj.TCMTreatment = obj.TCMTreatment
	s bobj.TCMPrescription = obj.TCMPrescription
	s bobj.NoMedicineTreat = obj.NoMedicineTreat
	s bobj.UseFlag = obj.UseFlag
	s bobj.UpdateUser =obj.UpdateUser 
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.Remarks = obj.Remarks
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator：shixiaowei
/// CreatDate: 2023-03-02
/// Description:状态修改
/// Input:id useflag(0编辑中,1已删除,2已审核)
/// Table：CT.WDT.CDSS.StructEMRDict
/// Other: w ##class(web.CDSS.CMKB.StructEMRDict).UpdateUseFlag(1,1)
ClassMethod UpdateUseFlag(RowId, Operation) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.StructEMRDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.StructEMRDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.StructEMRDict).%New()
	s bobj.UseFlag=obj.UseFlag
	
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.UpdateUser=obj.UpdateUser
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.UpdateDate=eobj.UpdateDate
 	s obj.UpdateUser=eobj.UpdateUser
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.StructEMRDict","CT.WDT.CDSS.StructEMRDict","结构化病历",RowId,obj.ClinicalSymptoms_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator：shixiaowei
/// CreatDate: 2023-03-02
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.StructEMRDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.StructEMRDict).ChangeStatusBack("")
ClassMethod ChangeStatusBack(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)

			s flag=..UpdateUseFlag(id,"驳回")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
		q result
}

/// Creator：shixiaowei
/// CreatDate: 2023-03-02
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.StructEMRDict).ChangeStatusPass("")
ClassMethod ChangeStatusPass(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)

			s flag=..UpdateUseFlag(id,"通过")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
		q result
}

/// Creator：shixiaowei
/// CreatDate: 2023-03-02
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.StructEMRDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.StructEMRDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.StructEMRDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.StructEMRDict).%New() 
	if $IsObject(obj.DiseaseDR)
	{
	 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
	}
	if $IsObject(obj.TCMSymptomDR)
	{
	 	s bobj.TCMSymptomDR = obj.TCMSymptomDR.%Id()
	}
	if $IsObject(obj.LocDR)
	{
	 	s bobj.LocDR = obj.LocDR.%Id()
	}
	s bobj.ClinicalSymptoms = obj.ClinicalSymptoms
	s bobj.TCMTreatment = obj.TCMTreatment
	s bobj.TCMPrescription = obj.TCMPrescription
	s bobj.NoMedicineTreat = obj.NoMedicineTreat
	s bobj.UseFlag = obj.UseFlag
	s bobj.UpdateUser =obj.UpdateUser 
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.Remarks = obj.Remarks
		
	s sc=##class(CT.WDT.CDSS.StructEMRDict).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.StructEMRDict","CT.WDT.CDSS.StructEMRDict","结构化病历",id,bobj.ClinicalSymptoms,"D",bobj)
		//同步删除别名通用表中数据 
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("结构化病历","web.CDSS.CMKB.StructEMRDict","DeleteData",bobj)
	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：ldy
/// CreatDate: 2023-03-02
/// Description:根据疾病和症候返回对应的数据
/// Table: CT.WDT.CDSS.StructEMRDict
/// Input: 
/// Return:
/// others:w ##class(web.CDSS.CMKB.StructEMRDict).GetEMRData("DM000821^DM000821^1^住院^13984^李得原^183^信息部^1^咳嗽")
ClassMethod GetEMRData(PatientInfo As %String) As %String
{
	k DuplicateArray
	s Result={"ClinicalSymptoms":[],"TCMTreatment":[],"TCMPrescription":[],"NoMedicineTreat":[]}
	s IDNO=$p(PatientInfo,"^",1)
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitId=$p(PatientInfo,"^",3)
	s VisitType=$p(PatientInfo,"^",4)
	if (IDNO="")||(PatientDR="")||(VisitId="")
	{
		q Result.%ToJSON()
	}
	
	if $l(PatientInfo,"^")=10
	{
		s DiseaseFlag=$p(PatientInfo,"^",*)
		s PatientInfo=$replace(PatientInfo,"^"_DiseaseFlag,"")
		if DiseaseFlag=""
		{
			q Result.%ToJSON()
		}
		if '$d(^WDT.CDSS.DiagnosisInfoI("IDNODiagnosisNameIndex",IDNO,DiseaseFlag))
		{
			q Result.%ToJSON()
		}
	}
	else
	{
		q Result.%ToJSON()
	}

	s DisInfoRowid=$o(^WDT.CDSS.DiagnosisInfoI("IDNODiagnosisNameIndex",IDNO,DiseaseFlag,0))

	//s DiseaseName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DisInfoRowid)),9)
	//s DiseaseRowid = $o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",DiseaseName,""))
	s DiagDesc=DiseaseFlag
	s DiagDictRowid=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",DiagDesc,""))
	q:DiagDictRowid="" Result.%ToJSON()
	//s MainDiag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DisInfoRowid)),13) //是否主诊断
	//q:MainDiag'=0 Result.%ToJSON()
	s DiagClass=$lg($g(^WDT.CDSS.DiagnosisInfoD(DisInfoRowid)),18) //诊断类型
	q:DiagClass'="中医" Result.%ToJSON()
	s Sequence=$lg($g(^WDT.CDSS.DiagnosisInfoD(DisInfoRowid)),7) //顺序号
	s NextSequence=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitId,VisitType,Sequence))
	q:NextSequence="" Result.%ToJSON()
	s NextRowid=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitId,VisitType,NextSequence,0))
	q:NextRowid="" Result.%ToJSON()
	s NextDiagClass=$lg($g(^WDT.CDSS.DiagnosisInfoD(NextRowid)),18) //诊断类型
	q:NextDiagClass'="证型" Result.%ToJSON()
	s TCMSymptom=$lg($g(^WDT.CDSS.DiagnosisInfoD(NextRowid)),9)
	s NextTCMRowid=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$zconvert(TCMSymptom,"U"),0))
	q:NextTCMRowid=""

	s Rowid=0
	for
	{
		s Rowid=$o(^CT.WDT.CDSS.StructEMRDictI("DiaSymIndex",DiagDictRowid,NextTCMRowid,Rowid)) 
		q:Rowid=""
		
		s ClinicalSymptoms=$lg($g(^CT.WDT.CDSS.StructEMRDictD(Rowid)),5)
		if ClinicalSymptoms'=""
		{
			s Temp={}
			d Temp.%Set("DiagName",DiagDesc)
			d Temp.%Set("TCMSymptom",TCMSymptom)
			d Temp.%Set("Content",ClinicalSymptoms)
			d Result.%Get("ClinicalSymptoms").%Push(Temp)
		}
		s TCMTreatment=$lg($g(^CT.WDT.CDSS.StructEMRDictD(Rowid)),6)
		if TCMTreatment'=""
		{
			s Temp={}
			d Temp.%Set("DiagName",DiagDesc)
			d Temp.%Set("TCMSymptom",TCMSymptom)
			d Temp.%Set("Content",TCMTreatment)
			d Result.%Get("TCMTreatment").%Push(Temp)
		}
		s TCMPrescription=$lg($g(^CT.WDT.CDSS.StructEMRDictD(Rowid)),7)
		if TCMPrescription'=""
		{
			s Temp={}
			d Temp.%Set("DiagName",DiagDesc)
			d Temp.%Set("TCMSymptom",TCMSymptom)
			d Temp.%Set("Content",TCMPrescription)
			d Result.%Get("TCMPrescription").%Push(Temp)
		}
		s NoMedicineTreat=$lg($g(^CT.WDT.CDSS.StructEMRDictD(Rowid)),8)
		if NoMedicineTreat'=""
		{
			s Temp={}
			d Temp.%Set("DiagName",DiagDesc)
			d Temp.%Set("TCMSymptom",TCMSymptom)
			d Temp.%Set("Content",NoMedicineTreat)
			d Result.%Get("NoMedicineTreat").%Push(Temp)
		}
	}
	
	q Result.%ToJSON()
}

/// Creator:shixiaowei
/// CreatDate:2023-03-06
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.StructEMRDict","GetLogList","20")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Operation")
{
}

ClassMethod GetLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.StructEMRDict",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	if (ObjectDesc["&&")
          	{
	          	s Operation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Operation="编辑"
         	}
         	d OutputRowLog
	    }
	    
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Operation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogListExecute ]
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

ClassMethod GetLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
