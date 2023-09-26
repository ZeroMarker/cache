/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description: 结构化诊断对接HIS接口
Class web.DHCBL.MKB.SDSDiagnosInterface Extends %RegisteredObject
{

/****************************医生站诊断录入接口***********************************************************/
/// Creator：医生站-袁磊
/// Description：插入诊断
/// Input：登录科室、mradm、诊断代码、登录Userid、备注、主诊断
/// Output:seccess:0^MRDiagnosRowid    failure:Order^错误信息
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).InsertDiagnos(LogDepRowid,MRAdmNo,ICDCode,UserRowid,MRDIADesc,MainDiagFlag)
ClassMethod InsertDiagnos(LogDepRowid As %String, MRAdmNo As %String, ICDCode As %String, UserRowid As %String, MRDIADesc As %String, MainDiagFlag As %String) As %String
{
	;MRDIADesc:Desc#Type 1:西医，2：中医，3症性
	s:MRAdmNo'="" MRAdmNo=$ZCONVERT(MRAdmNo,"U")
	s:ICDCode'="" ICDCode=$$ALPHAUP^SSUTIL4(ICDCode) //转换成大写
	s EpisodeID=$o(^PAADMi("No",MRAdmNo,0))
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	s ICDCodeRowid=..GetICDRowId(ICDCode)
	s MRDiagTypeId=$o(^MRC("DTYP",0,"Code",$$ALPHAUP^SSUTIL4("PRE"),""))
	s ret=##class(web.DHCMRDiagnos).InsertMRDiagnos(LogDepRowid, MRAdmRowid, ICDCodeRowid, UserRowid, MRDIADesc, MRDiagTypeId, "", "", "", "", "", "QZ", "1", "", MainDiagFlag) //标版
	if ($p(ret,"^",1)=0){ //标版
		d ##class(web.DHCMRDiagnos).UpdateOnsetDate($p(ret,"^",2),$zd(+$h,3))
	}
	q ret
}

/// Creator：医生站-袁磊
/// Description：修改诊断
/// Input:MRDiagnosRowid,修改人id,主诊断
/// Output:seccess 0  failure 1
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).UpdateDiagnos(MRDiagnosRowid,MRDiagnosUpdateUser,MainDiagFlag)
ClassMethod UpdateDiagnos(MRDiagnosRowid As %String, MRDiagnosUpdateUser As %String, MainDiagFlag As %String = "")
{
	s Date=+$h
	s Time=$p($h,",",2)
	&SQL(UPDATE SQLUser.MR_Diagnos SET MRDIA_UpdateUser_DR=:MRDiagnosUpdateUser,MRDIA_UpdateDate=:Date,MRDIA_UpdateTime=:Time,MRDIA_MainDiagFlag=:MainDiagFlag where MRDIA_RowId=:MRDiagnosRowid)
	q SQLCODE
}

/// Creator：医生站-袁磊
/// Description：删除诊断
/// input:MRDiagnosRowid
/// output:seccess:0  failure: Discharged/病人已出院  Timeout/不能删病人以前诊断  Orther/删除失败
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).DeleteDiagnos(MRDiagnosRowid)
ClassMethod DeleteDiagnos(MRDiagnosRowid As %String)
{
	s ret=##class(web.DHCMRDiagnos).DeleteMRDiagnos(MRDiagnosRowid)
	q ret
}

/// Creator：高姗姗
/// Description：获取用户、科室描述
/// input:type:U/L  rowid
/// output:用户/科室描述
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("","")
ClassMethod GetUserLocDesc(type As %String, rowid As %String) As %String
{
	s rowid=$tr(rowid," ","")
	q:rowid="" ""
	s result=""
	if (type="U"){ //获取用户描述
		s result=$p($g(^SSU("SSUSR",rowid)),"^",2)
	}
	if (type="L"){ //获取科室描述
		s result=$p($g(^CTLOC(rowid)),"^",2)
	}
	q result
}

/// Creator：高姗姗
/// Description：获取icdid
/// input:ICDCode
/// output:ICDCodeRowid
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetICDRowId("A01.000")
ClassMethod GetICDRowId(ICDCode As %String) As %String
{
	s ICDCodeRowid=""
	s:ICDCode'="" ICDCode=$$ALPHAUP^SSUTIL4(ICDCode)
	;s ICDCodeRowid=$o(^MRC("ID",0,"Code",ICDCode,0)) //根据代码获取
	//根据ICD10代码获取MRCIDICD9CMCode
	s MRCIDRowId=0
	for
	{
		s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:MRCIDRowId=""
		s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)
		s MRCIDICD9CMCodeU=$$ALPHAUP^SSUTIL4(MRCIDICD9CMCode)
		if (MRCIDICD9CMCodeU=ICDCode){
			s ICDCodeRowid=MRCIDRowId
			q
		}
	}
	q ICDCodeRowid
}

/// Creator：高姗姗
/// Description：获取icdid,根据描述
/// input:ICDDesc
/// output:ICDRowId
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetICDRowIdByDesc("骨伤科病")
ClassMethod GetICDRowIdByDesc(ICDDesc As %String) As %String
{
	q:ICDDesc="" ""
	s ICDRowId="",ICD9CMCode=""
	s:ICDDesc'="" ICDDesc=$$ALPHAUP^SSUTIL4(ICDDesc)
	s ICDRowId=$o(^MRC("ID",0,"Desc",ICDDesc,""),-1)
	s:ICDRowId'="" ICD9CMCode=$p($g(^MRC("ID",ICDRowId)),"^",4)
	q ICDRowId_"^"_ICD9CMCode
}

/// Creator：高姗姗
/// Description：获取icdid,根据编码+描述+医院Id
/// input:IcdCode,ICDDesc,ICDType^ClinicType
/// output:ICDRowId
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId("C85.900","非霍奇金淋巴瘤")
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId("M95910/3","非霍奇金淋巴瘤","1")
ClassMethod GetHISICDRowId(IcdCode As %String, ICDDesc As %String, Type As %String = "") As %String
{
	q:ICDDesc="" ""
	s ICDType=$p(Type,"^",1) //ICDType 0-西医 1-中医 2-证型
	s ClinicType=$p(Type,"^",2) //ClinicType O-门诊 E-急诊 I-住院 H-体检 N-新生儿
	s ICDDescU=$$ALPHAUP^SSUTIL4(ICDDesc) //转换成大写
	s ICDRowId=""
	s HospId=$G(%session.Data("LOGON.HOSPID"))
	s IsValidMethodName=##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.DHCBL.BDP.BDPMappingHOSP","GetHospShowDataFlag") //判断类方法是否存在
	s Id=""
	for {
		s Id=$o(^MRC("ID",0,"Desc",ICDDescU,Id)) q:Id=""
		s MRCIDDesc=$p($g(^MRC("ID",Id)),"^",2) //描述
		s MRCIDICD9CMCode=$p($g(^MRC("ID",Id)),"^",4) //编码
		s MRCIDDateActiveFrom=$p($g(^MRC("ID",Id)),"^",6) //开始日期
		s MRCIDDateActiveTo=$p($g(^MRC("ID",Id)),"^",7) //结束日期
		s NowDate=$p($h,",",1)
		continue:(MRCIDDesc'=ICDDesc)
		continue:(MRCIDICD9CMCode'=IcdCode)
		continue:((MRCIDDateActiveFrom'="")&&(NowDate<MRCIDDateActiveFrom))
		continue:((MRCIDDateActiveTo'="")&&(NowDate>MRCIDDateActiveTo))
		if (IsValidMethodName=1){
			s HospShowDataFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("MRC_ICDDx",Id,HospId,"") //判断医院授权
			continue:(HospShowDataFlag="N") 
		}
		
		s MRCIDBillFlag3=$p($g(^MRC("ID",Id)),"^",15) //中医诊断标志
		s MRCIDBillFlag1=$P($G(^MRC("ID",Id)),"^",13)  //中医证型
		continue:(ICDType="0")&&(MRCIDBillFlag3="Y")
		continue:(ICDType="1")&&((MRCIDBillFlag3'="Y")||(MRCIDBillFlag1="Y"))
		continue:(ICDType="2")&&((MRCIDBillFlag3'="Y")||(MRCIDBillFlag1'="Y"))
		s MRCIDMetastaticSite=$p($g(^MRC("ID",Id)),"^",40) //肿瘤形态学编码标志  
		s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",Id)),"^",41) //损伤中毒外部原因标志
		continue:(MRCIDMetastaticSite="Y")||(MRCIDInjuryPoisoningCode="Y")
		
		if (ClinicType'=""){
			s MRCIDClinicType=$p($g(^MRC("ID",Id)),"^",47)
			continue:((MRCIDClinicType'="")&&(MRCIDClinicType'=ClinicType))
		}
		
		/*
		//西南医大-住院取注释为1的ICD
		s MRCIDLongDescription=$p($g(^MRC("ID",Id)),"^",36) //注释
		if $d(^PAC("ADMLOC",0,"AdmType","I",$Get(%session.Data("LOGON.CTLOCID")))){
			continue:(MRCIDLongDescription'=1)
		}*/
		
		s ICDRowId=Id
	}
	q ICDRowId
}

/// Creator：高姗姗
/// Description：获取诊断类型id,根据描述
/// input:TypeDesc
/// output:TypeRowId
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetTypeIdByDesc("入院诊断")
ClassMethod GetTypeIdByDesc(TypeDesc As %String) As %String
{
	q:TypeDesc="" ""
	s TypeRowId=""
	s:TypeDesc'="" TypeDesc=$$ALPHAUP^SSUTIL4(TypeDesc)
	s TypeRowId=$o(^MRC("DTYP",0,"Desc",TypeDesc,0))
	q TypeRowId
}

/// Creator：高姗姗
/// Description：获取诊断状态id,根据描述
/// input:StatusDesc
/// output:StatusRowId
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetStatusIdByDesc("待诊")
ClassMethod GetStatusIdByDesc(StatusDesc As %String) As %String
{
	q:StatusDesc="" ""
	s StatusRowId=""
	s:StatusDesc'="" StatusDesc=$$ALPHAUP^SSUTIL4(StatusDesc)
	s StatusRowId=$o(^MRC("DSTAT",0,"Desc",StatusDesc,0))
	q StatusRowId
}

/// Creator：高姗姗
/// Description：获取诊断类型描述,根据代码
/// input:TypeCode
/// output:TypeDesc
/// w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetTypeDescByCode("DIS")
ClassMethod GetTypeDescByCode(TypeCode As %String) As %String
{
	q:TypeCode="" ""
	s TypeRowId=""
	s TypeDesc=""
	s:TypeCode'="" TypeCode=$$ALPHAUP^SSUTIL4(TypeCode)
	s TypeRowId=$o(^MRC("DTYP",0,"Code",TypeCode,0))
	s:TypeRowId'="" TypeDesc=$p($g(^MRC("DTYP",TypeRowId)),"^",2)
	q TypeDesc
}

/// Creator:高姗姗
/// CreatDate:2019-10-11
/// Description:根据描述判断数据处理工厂是否存在此诊断
/// Table:User.MKBStructuredData
/// Input：诊断短语描述,多个以^分隔
/// Return:有存在即返回true，全部不存在返回false
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetStructDiagnosExists("糖尿病^淋巴瘤")
ClassMethod GetStructDiagnosExists(wordDesc As %String) As %String
{
	s result=""
	s wordVersion=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion() //获取诊断短语数据来源
	s len=$Length(wordDesc,"^")
	for i=1:1:len{
		s desc=$p(wordDesc,"^",i)
		if (wordVersion["ICD"){ //取自各版本icd对照
			s sameDiag=##class(web.DHCBL.MKB.MKBICDContrastInterface).GetSameDiag(wordVersion,desc)
		}else{ //取自数据处理工厂
			s sameDiag=##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetSameDiag(wordVersion,desc)
		}
		
		if (sameDiag=""){
			s result=result_"^false"
		}else{
			s result=result_"^true"	
		}
	}
	if (result["true"){
		s result="true"	
	}else{
		s result="false"	
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-10-12
/// Description:引用诊断方法
/// Table：User.SDSDiagnos
/// Input：患者登记号，就诊号，医生站标识，引用场景，诊断串医生站诊断id^结构化诊断id，多个以&分隔
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosInterface).SaveStructDiagnosRef("0000000008$IP0000000003$4||162^11&4||161^11")
ClassMethod SaveStructDiagnosRef(MRInfo As %String) As %String
{
	s result=""
	s PMINo=$p(MRInfo,"$",1) 
	s ADMNo=$p(MRInfo,"$",2) 
	s type=$p(MRInfo,"$",3) 
	s scene=$p(MRInfo,"$",4) 
	s diagStr=$p(MRInfo,"$",5) 
	s PatientID=$o(^User.SDSPatMasI("PMINoIndex",PMINo,0))
	s mradm=$o(^User.SDSAdmI("ADMNoIndex",ADMNo,0))
	s diagLen=$Length(diagStr,"&")
	for i=1:1:diagLen{
		s diagInfo=$p(diagStr,"&",i)
		s MRDiagRowId=$p(diagInfo,"^",1)
		s SDSRowId=$p(diagInfo,"^",2)
		
		s SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(SDSRowId),"-",2)	
		s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2)
		s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),4)
		s ICDCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5) //ICD代码
		s ICDDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6) //ICD描述
		s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
		s SDSMainDiagFlag=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),10)
		s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)

		//保存到关联表
		s scLink=##class(web.DHCBL.MKB.SDSDiagnosLink).SaveLink(MRDiagRowId,SDSRowId,mradm)
		if (scLink["true"){
			
			s SDSTag=##class(web.DHCBL.MKB.SDSDiagnos).GetTagText(SDSTagDR)
			//清除整理标记
			if (SDSTag["整理"){
	  			s SDSTagDR=##class(web.DHCBL.MKB.SDSDiagnos).GetSubTag(SDSTagDR,"整理")
				s $LIST(^User.SDSDiagnosD(SDSRowId),11)=SDSTagDR
	  		}
			//标记当前诊断
			if (SDSTag'["当前诊断"){
				if (SDSTagDR=""){
					s SDSTagDR=##class(web.DHCBL.MKB.SDSDiagnos).GetTermIdByDesc("当前诊断")
				}else{
					s SDSTagDR=SDSTagDR_","_##class(web.DHCBL.MKB.SDSDiagnos).GetTermIdByDesc("当前诊断")
				}
				d ##class(web.DHCBL.MKB.SDSDiagnos).SaveTag(SDSRowId, PatientID, mradm, SDSTagDR)
			}
			
			//维护子表日志：引用
			s newValue="{""SDSTermDR"":"""_SDSTermDR_""",""SDSValue"":"""_SDSValue_""",""SDSSupplement"":"""_SDSSupplement_""",""SDSWordDR"":"""_SDSWordDR_""",""SDSIcdCode"":"""_ICDCode_""",""SDSIcdDesc"":"""_ICDDesc_""",""SDSMainDiagFlag"":"""_SDSMainDiagFlag_""",""SDSTagDR"":"""_SDSTagDR_"""}"
			d ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(SDSRowId,"R","",newValue,mradm,type,scene) 
			
			s resSave = "{success:'true',id:'"_SDSRowId_"'}" //返回RowId
		}else{
			s resSave = "{success:'false',errorinfo:'关联表保存失败'}"   //返回错误信息
		}
	}
	if (result["false"){
		s result="false"	
	}else{
		s result="true"	
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2019-10-12
/// Description:根据id删除,本次就诊一对一关系时，同步删除诊断及关联关系，一对多关系时，仅删关联关系
/// Table:User.SDSDiagnos,User.SDSDiagnosLink
/// Input：ADMNo就诊号 MRDiagnosRowid医生端诊断表id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosInterface).DeleteStructDiagnos("IP0000000003","4||162")
ClassMethod DeleteStructDiagnos(ADMNo As %String, DiagItemRowStr As %String) As %String
{
	s result=""
	s mradm=$o(^User.SDSAdmI("ADMNoIndex",ADMNo,0)) //结构化就诊索引
	s DiagLen=$Length(DiagItemRowStr,"^")
	for i=1:1:DiagLen{
		s MRDiagnosRowid=$p(DiagItemRowStr,"^",i)
		//医生站端诊断删除时同时删除关联表;所有关联删除后，再删除结构化诊断
		if $d(^User.SDSDiagnosLinkI("DiagnosIndex",MRDiagnosRowid)){
			s linkrowid=$o(^User.SDSDiagnosLinkI("DiagnosIndex",MRDiagnosRowid,0)) //关联表id
			s rowid=$LISTGET($G(^User.SDSDiagnosLinkD(linkrowid)),3) //结构化诊断的id
			s sclink=##class(User.SDSDiagnosLink).%DeleteId(linkrowid)
			if '$$$ISOK(sclink)
			{
				s result=result_"^false"	
			}
			else
			{
				if $d(^User.SDSDiagnosLinkI("StructIndex",rowid)){ //一对多关系时仅删除关联关系即成功
					s result=result_"^true"
				}else{ 
					s subLog=$o(^User.SDSDiagnosLogI("OperateTypeIndex","A",rowid,0)) //结构化诊断新增日志id
					if (subLog'=""){
						s mradmLog=$LISTGET($G(^User.SDSDiagnosLogD(subLog)),9) //新增日志中的就诊索引
						if (mradmLog=mradm){ //仅剩一对一关系时，判断结构化诊断为本次就诊新增的即可同步删除
							s resDel=##class(web.DHCBL.MKB.SDSDiagnos).DeleteData(rowid,mradm)
							if (resDel["false"){
								s result=result_"^false"	
							}else{
								s result=result_"^true"	
							}
						}
					}
				}
			}
		}
	}
	if (result["false"){
		s result="false"	
	}else{
		s result="true"	
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2020-01-19
/// Description:根据医生站诊断表rowid获取结构化诊断展示名
/// Input:MRDiagnosRowid医生端诊断表id
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetStructDiagnosName()
ClassMethod GetStructDiagnosName(MRDiagnosRowid) As %String
{
	q:MRDiagnosRowid="" ""
	s name=""
	if ($d(^User.SDSDiagnosLinkI("DiagnosIndex",MRDiagnosRowid))){
		s linkrowid=$o(^User.SDSDiagnosLinkI("DiagnosIndex",MRDiagnosRowid,0)) //关联表id
		s rowid=$LISTGET($G(^User.SDSDiagnosLinkD(linkrowid)),3) //结构化诊断的id
		if ($d(^User.SDSDiagnosD(rowid))){
			s name=##class(web.DHCBL.MKB.SDSDiagnos).GetDiagName(rowid)
		}
	}
	q name
}

/// Creator:高姗姗
/// CreatDate:2022-02-25
/// Description:数据处理工厂诊断性别年龄限制判断
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosInterface).CheckDiagRequire()
ClassMethod CheckDiagRequire(EpisodeID, WordId) As %String
{
	q:((EpisodeID="")||(WordId="")) ""
	
	//性别限制  参考##class(web.DHCMRDiagnos).CheckDiagRequireSex(1,11)
	s PatSex="",PatSexDesc="",DiagsexDesc=""
    s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
    s PatSex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
    s:PatSex'="" PatSexDesc=$p(^CT("SEX",PatSex),"^",2)
    s DiagsexDr=$lg($g(^User.MKBStructuredDataD(WordId)),35)
    s:DiagsexDr'="" DiagsexDesc=$p($g(^CT("SEX",DiagsexDr)),"^",2)
    s:DiagsexDr="" DiagsexDesc=""
    q:(DiagsexDesc'="")&&(PatSexDesc'="")&&(PatSexDesc'=DiagsexDesc) "该病人性别为："_PatSexDesc_","_"诊断约束性别为："_DiagsexDesc_","_"请重新选择诊断！"
    
	//年龄限制 参考##class(web.DHCMRDiagnos).CheckDiagRequireAge(1,11)
	//s PAPMIAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PAPMIAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
	i PAPMIAge'["岁" d
	.s Dob=$P(^PAPER(PatientID,"ALL"),"^",6)
	.s PAPMIAge=($H-Dob)/365
	e  s PAPMIAge=$p(PAPMIAge,"岁")
	s DiagAgeFrom=$lg($g(^User.MKBStructuredDataD(WordId)),37)
	s DiagAgeTo=$lg($g(^User.MKBStructuredDataD(WordId)),38)
	q:(DiagAgeFrom'="")&&(DiagAgeTo'="")&&((PAPMIAge>DiagAgeTo)||(PAPMIAge<DiagAgeFrom)) "该诊断限制年龄是"_DiagAgeFrom_"到"_DiagAgeTo_""
	q:(DiagAgeFrom'="")&&(DiagAgeTo="")&&(PAPMIAge<DiagAgeFrom) "该诊断限制年龄是"_DiagAgeFrom_"以上"
	q:(DiagAgeFrom="")&&(DiagAgeTo'="")&&(PAPMIAge>DiagAgeTo) "该诊断限制年龄是"_DiagAgeTo_"以下"
	q ""
}

/********************************电子病历EMR接口***************************************************************/
/// Creator：高姗姗
/// CreatDate: 2019-11-15
/// Description：根据诊断id查询诊断列表内容
/// Table：User.SDSDiagnos
/// Input：id
/// Return: 诊断表达式描述,补充诊断,ICD编码,ICD描述,诊断短语描述,开立日期,是否主诊断,ICD码表rowid,顺序,级别,发病日期,诊断类型,诊断状态
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosInterface","GetDiagListById","436")
Query GetDiagListById(id As %String) As %Query(ROWSPEC = "SDSDisplayName,SDSSupplement,SDSOpenDate,SDSIcdCode,SDSIcdDesc,SDSWordDesc,SDSMainDiagFlag,IcdRowId,SDSSequence,SDSLevel,SDSOnsetDate,SDSTypeDesc,SDSStatusDesc,UserName")
{
}

ClassMethod GetDiagListByIdExecute(ByRef qHandle As %Binary, id As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1

 if (id'="") //根据rowid返回该条记录
 {
	  s resRow=##class(web.DHCBL.MKB.SDSDiagnos).GetDiagRow("",id)
	  s SDSDisplayName=$p(resRow,"^",2) //诊断表达式描述
	  s SDSDisplayName=$tr(SDSDisplayName,"&nbsp;","")
	  s SDSSupplement=$p(resRow,"^",3) //补充诊断
	  s SDSIcdCode=$p(resRow,"^",4) //ICD编码
	  s SDSIcdDesc=$p(resRow,"^",5) //ICD描述
	  s SDSWordDesc=$p(resRow,"^",7) //诊断短语描述
	  s SDSOpenDate=$p(resRow,"^",8) //开立日期
	  s SDSSequence=$p(resRow,"^",9) //顺序
	  s SDSMainDiagFlag=$p(resRow,"^",10) //是否主诊断
	  s IcdRowId=$p(resRow,"^",14) //ICD码表rowid
	  s SDSLevel=$p(resRow,"^",15) //级别
	  s SDSOnsetDate=$p(resRow,"^",16) //发病日期
	  s SDSTypeDesc=$p(resRow,"^",18) //诊断类型 
	  s SDSStatusDesc=$p(resRow,"^",20) //诊断状态
	  s UserName=$p(resRow,"^",23) //开立医生
	  d OutputRowDiagListById
 }

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowDiagListById
    set Data=$lb(SDSDisplayName,SDSSupplement,SDSOpenDate,SDSIcdCode,SDSIcdDesc,SDSWordDesc,SDSMainDiagFlag,IcdRowId,SDSSequence,SDSLevel,SDSOnsetDate,SDSTypeDesc,SDSStatusDesc,UserName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiagListByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagListByIdExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDiagListByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagListByIdExecute ]
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

/// Creator：高姗姗
/// CreatDate: 2019-11-20
/// Description：根据就诊号查询诊断列表内容
/// Table：User.SDSDiagnos
/// Input：ADMNo
/// Return; 诊断表达式描述,补充诊断,ICD编码,ICD描述,诊断短语描述,开立日期,是否主诊断,ICD码表rowid,顺序,级别,发病日期,诊断类型,诊断状态
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosInterface","GetDiagListByAdm","IP0000000003")
Query GetDiagListByAdm(ADMNo As %String) As %Query(ROWSPEC = "SDSDisplayName,SDSSupplement,SDSOpenDate,SDSIcdCode,SDSIcdDesc,SDSWordDesc,SDSMainDiagFlag,IcdRowId,SDSSequence,SDSLevel,SDSOnsetDate,SDSTypeDesc,SDSStatusDesc,UserName")
{
}

ClassMethod GetDiagListByAdmExecute(ByRef qHandle As %Binary, ADMNo As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s mradm=$o(^User.SDSAdmI("ADMNoIndex",ADMNo,0))
 s PatientID=$LISTGET($G(^User.SDSAdmD(mradm)),3)
 Set rs=##Class(%ResultSet).%New("web.DHCBL.MKB.SDSDiagnos:GetList")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(PatientID,mradm,"")
		 If 'Status Quit
		 While rs.Next() {
			 s RefFlag=rs.Data("RefFlag") //引用标识
			 continue:(RefFlag'="Y")
			 s SDSDisplayName=rs.Data("SDSDisplayName") //诊断表达式描述
			 s SDSDisplayName=$tr(SDSDisplayName,"&nbsp;","")
			 s SDSSupplement=rs.Data("SDSSupplement") //补充诊断
			 s SDSOpenDate=rs.Data("SDSOpenDate") //开立日期
			 s SDSIcdCode=rs.Data("SDSIcdCode") //ICD编码
			 s SDSIcdDesc=rs.Data("SDSIcdDesc") //ICD描述
			 s SDSWordDesc=rs.Data("SDSWordDesc") //诊断短语描述
			 s SDSMainDiagFlag=rs.Data("SDSMainDiagFlag") //是否主诊断
			 s IcdRowId=rs.Data("IcdRowId") //ICD码表rowid
			 s SDSSequence=rs.Data("SDSSequence") //顺序
			 s SDSLevel=rs.Data("SDSLevel") //级别
			 s SDSOnsetDate=rs.Data("SDSOnsetDate") //发病日期
			 s SDSTypeDesc=rs.Data("SDSTypeDesc") //诊断类型
			 s SDSStatusDesc=rs.Data("SDSStatusDesc") //诊断状态
			 s UserName=rs.Data("UserName") //开立医生

			 d OutputRowDiagListByAdm
		 }
	}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowDiagListByAdm
    set Data=$lb(SDSDisplayName,SDSSupplement,SDSOpenDate,SDSIcdCode,SDSIcdDesc,SDSWordDesc,SDSMainDiagFlag,IcdRowId,SDSSequence,SDSLevel,SDSOnsetDate,SDSTypeDesc,SDSStatusDesc,UserName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiagListByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagListByAdmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDiagListByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagListByAdmExecute ]
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

/********************************DRGs接口***************************************************************/
/// Creator：高姗姗
/// CreatDate: 2019-08-13
/// Description：获取患者信息
/// Input：就诊号、患者登记号
/// Return：年龄^性别^住院天数^住院费用
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetPatientInfo("IP0000000003","0000000008")
ClassMethod GetPatientInfo(ADMNo As %String, PMINo As %String) As %String
{
	s result=""
	s EpisodeID=$o(^PAADMi("No",$ZCONVERT(ADMNo,"U"),0))
	s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCONVERT(PMINo,"U"),0))
	//8.3.1版
	;s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID) //年龄
	;s InPatDays=##class(web.DHCDoc.OP.AjaxInterface).GetInPatAdmDays(EpisodeID) //住院天数
	
	//安贞版
	s PatAge=##class(web.DHCDocMainOrderInterface).GetPatientAge(PatientID,EpisodeID) //年龄
	s PatAge=$p(PatAge,"岁",1)
	s admInfo=##Class(web.DHCIPBillCheckAdmFee).GetAdmBedInfo(EpisodeID) 
	s InPatDays=$p(admInfo,"^",12) //住院天数
	
	s PatSex=""
	s PatSexDr=$p(^PAPER(PatientID,"ALL"),"^",7) 
	i PatSexDr'="" s PatSex=$p($g(^CT("SEX",PatSexDr)),"^","2") //性别
	s amount=$p(##Class(web.DHCBillInterface).IGetDepAndBalnace(EpisodeID),"^",3) //住院费用 
	
	s result=PatAge_"^"_PatSex_"^"_InPatDays_"^"_amount
	q result
}

/// Creator：临床-丁延丽
/// CreatDate: 2019-08-14
/// Description：根据就诊号获取患者的icd手术操作代码及描述
/// Input：就诊号
/// Return：手术1icd|手术1名称,手术2icd|手术2名称,...
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetOperationInfo("IP0000000003")
/// 参考 ##class(web.DHCANAdaptor).GetOperCodeByAdmId(4)
ClassMethod GetOperationInfo(ADMNo)
{
	s EpisodeID=$o(^PAADMi("No",$ZCONVERT(ADMNo,"U"),0))
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s opaId="",retStr=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",mradm,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:(opaStatus="C")!(opaStatus="D")!(opaStatus="A")
		.s anSub=$p($p(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s opSub=0 f  s opSub=$O(^OR(mradm,"ANA",anSub,"OP",opSub)) q:(opSub="")  d
			..s opdes=""
			..s opdr=$P(^OR(mradm,"ANA",anSub,"OP",opSub),"^",6)       		;ANAOP_Type_DR     ；手术名称
			..q:opdr=""
			..i +opdr'=0  d 
				...s opdes=$P($g(^ORC("OPER",+opdr)),"^",2)
				...s opicd9code=$P($g(^ORC("OPER",+opdr)),"^",14) 
			..i retStr'="" s retStr=retStr_","_opicd9code_"|"_opdes
			..e  s retStr=opicd9code_"|"_opdes
	q retStr
}

/// Creator：张云越
/// CreatDate: 2019-08-13
/// Description：获取北京临床6.01版ICD编码 本地描述->北京描述->北京编码；本地描述->国际描述->北京编码
/// Input：关联ICD描述
/// Return：北京临床6.01版ICD编码
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetPekingDiagICD("急性心肌梗死")
ClassMethod GetPekingDiagICD(desc As %String) As %String
{
	q:desc="" ""
	s Desc=$zconvert(desc,"U")
	s MKBICD=""
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Desc,MKBICDRowid))
		q:MKBICDRowid=""
		s Type=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		if Type["A"
		{
			s MKBICD=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
		}
	}
	if MKBICD=""
	{
		s NationBase=$o(^User.MKBTermBaseI("DescIndex"," "_$Zconvert("国家临床2.0-疾病分类与代码","U"),0))
		s PekingBase=$o(^User.MKBTermBaseI("DescIndex"," "_$Zconvert("北京临床-ICD10V6.01","U"),0))
		
		s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 国家临床2.0TO北京临床6.01",0))
		s MKBKLMFNRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 国家临床2.0名称",0))
		s MKBKLMFPRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 北京临床6.01名称",0))
		s NationField=MKBKLMBRowid_"||"_MKBKLMFNRowid
		s PekingField=MKBKLMBRowid_"||"_MKBKLMFPRowid
		s MKBKLRow=0
		for
		{
			s MKBKLRow=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowid,MKBKLRow))    //遍历行
			q:MKBKLRow=""
			s ValueRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLRow,NationField,0))   //值rowid
			s Value=$lg($g(^User.MKBKLMappingDetailD(ValueRowid)),2)                        //值
			s MKBDesc=$lg($g(^User.MKBTermD(Value)),3)
			if MKBDesc=desc
			{
				s PekingValueRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLRow,PekingField,0))   //值rowid
				s PekingValue=$lg($g(^User.MKBKLMappingDetailD(PekingValueRowid)),2)                        //值
				s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",PekingValue," ICD编码",0))
				s MKBTermProDelRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
				s MKBICD=$lg($g(^User.MKBTermProDetailD(MKBTermProDelRowid)),3)
				q
			}
		}
	}
	q MKBICD
}

/// Creator：高姗姗
/// CreatDate: 2019-08-14
/// Description：获取北京临床ICD9编码 本地描述->北京描述->北京编码；
/// Input：手术描述
/// Return：北京临床版手术编码
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetPekingOperICD("颈部血管治疗性超声")
ClassMethod GetPekingOperICD(desc As %String) As %String
{
	q:desc="" ""
	s:desc'="" desc=$zconvert(desc,"U")
	s MKBICD=""
	s baseid=##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc("北京临床-ICD9手术分类临床版")
	q:baseid="" ""
	s termid=$o(^User.MKBTermI("DescIndex",baseid," "_desc,0))
	q:termid="" ""
	s propertyid=$o(^User.MKBTermPropertyI("DescIndex",termid," ICD9编码",0))
	q:propertyid="" ""
	s detailid=$o(^User.MKBTermProDetailI("ProIdx",propertyid,0))
	q:detailid="" ""
	s MKBICD=$LISTGET($G(^User.MKBTermProDetailD(detailid)),3)
	q MKBICD
}

/// Creator：陈代雷
/// CreatDate: 2019-08-13
/// Description：根据代码获取DRG相关数据
/// Input：DRG代码
/// Return：DRG代码&^诊断相关组&^权重&^风险级别&^平均住院日%^例均费用
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetDRGsInfo("AA19")
ClassMethod GetDRGsInfo(DRGCode As %String) As %String
{
	s baseid=##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc("DRGs分组")
	q:baseid="" ""
	s TermRowId=$o(^User.MKBTermI("CodeIndex",baseid," "_$Zconvert(DRGCode,"U"),0))  //通过DRG代码获取对应相关组的rowid
 	q:TermRowId="" ""
 	s WeightProRowId=$o(^User.MKBTermPropertyI("DescIndex",TermRowId," 权重",0))  //获取属性表中权重的rowid
 	s WeightValueRowId=$o(^User.MKBTermProDetailI("ProIdx",WeightProRowId,0))         //获得属性值表中权重值的rowid
 	s RiskProRowId=$o(^User.MKBTermPropertyI("DescIndex",TermRowId," 风险级别",0))      //获取属性表中风险级别的rowid
 	s RiskValueRowId=$o(^User.MKBTermProDetailI("ProIdx",RiskProRowId,0))            //获得属性值表中风险级别值的rowid
 	s HDayProRowId=$o(^User.MKBTermPropertyI("DescIndex",TermRowId," 平均住院日",0)) 
 	s HDayValueRowId=$o(^User.MKBTermProDetailI("ProIdx",HDayProRowId,0))
 	s AvgCostProRowId=$o(^User.MKBTermPropertyI("DescIndex",TermRowId," 例均费用",0))
 	s AvgCostValueRowId=$o(^User.MKBTermProDetailI("ProIdx",AvgCostProRowId,0))
 	s SDSDRG=$lg($g(^User.MKBTermD(TermRowId)),3)        //获取相关组值
 	s SDSWeight=$lg($g(^User.MKBTermProDetailD(WeightValueRowId)),3)  //获取权重属性值
	s SDSRiskLevel=$lg($g(^User.MKBTermProDetailD(RiskValueRowId)),3)
 	s SDSAvgHospitalDay=$lg($g(^User.MKBTermProDetailD(HDayValueRowId)),3)
 	s SDSAvgCost=$lg($g(^User.MKBTermProDetailD(AvgCostValueRowId)),3)
 	q DRGCode_"&^"_SDSDRG_"&^"_SDSWeight_"&^"_SDSRiskLevel_"&^"_SDSAvgHospitalDay_"&^"_SDSAvgCost
}

/// Creator：陈代雷
/// CreatDate: 2019-08-13
/// Description：查询诊断DRGs分组详细信息
/// Input：DRG代码
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosInterface","GetDRGsDetail","AA19")
Query GetDRGsDetail(DRGCode As %String) As %Query(ROWSPEC = "Name,Value")
{
}

ClassMethod GetDRGsDetailExecute(ByRef qHandle As %Binary, DRGCode As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s baseid=##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc("DRGs分组")
 	s TermRowId=$o(^User.MKBTermI("CodeIndex",baseid," "_$Zconvert(DRGCode,"U"),0))  //通过DRG代码获取对应相关组的rowid
 	if (TermRowId'=""){
	 	s Seq=""
		for
		{
			s Seq=$o(^User.MKBTermPropertyI("SeqIndex",TermRowId,Seq))
		    q:Seq=""  
			s ProRowId=""
	 		for
	 		{
			 	s ProRowId=$o(^User.MKBTermPropertyI("SeqIndex",TermRowId,Seq,ProRowId))   //获得属性的RowId
			 	q:ProRowId=""
		 		s Name=$lg($g(^User.MKBTermPropertyD(ProRowId)),3)
		 		s DetailRowId=$o(^User.MKBTermProDetailI("ProIdx",ProRowId,0))
		 		s Value=$lg($g(^User.MKBTermProDetailD(DetailRowId)),3)
		 		d OutputRowDetail
	 		}
		}
	} 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDetail
	set Data=$lb(Name,Value)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDRGsDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDRGsDetailExecute ]
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

ClassMethod GetDRGsDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDRGsDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*//调用分组器版
ClassMethod GetDrgsGroup(ADMNo As %String, PMINo As %String, mainDiag As %String, otherDiag As %String) As %String
{
	;s ^TMPGSS("drgstr")=ADMNo_","_PMINo_","_mainDiag_","_otherDiag
	s result=""
	//获取患者信息
 	s patientInfo=..GetPatientInfo(ADMNo, PMINo)
 	s AGE=$p($p(patientInfo,"^",1),"岁",1) //年龄
 	s GENDER=$p(patientInfo,"^",2) //性别
 	s ACCTUALDAYS=$p(patientInfo,"^",3) //住院天数
 	s TOTALEXPENSE=$p(patientInfo,"^",4) //住院费用
 	
 	//获取主诊断北京版ICD码
 	s mainDiagCode=..GetPekingDiagICD(mainDiag) 
 	//获取其他诊断北京版ICD码
 	s otherDiagCode=""
 	s otherDiagLen=$Length(otherDiag,"^")
 	for i=1:1:otherDiagLen{
		s diagDesc=$p(otherDiag,"^",i)
		s diagCode=..GetPekingDiagICD(diagDesc)
		if (otherDiagCode=""){
			s otherDiagCode=""""_diagCode_""""
		}else{
			s otherDiagCode=otherDiagCode_","_""""_diagCode_""""
		}
	}
	s otherDiagCode="["_otherDiagCode_"]"
	
	//获取手术北京版ICD码
	s operscode=""
	s operStr=..GetOperationInfo(ADMNo)
	s operLen=$Length(operStr,",")
	for j=1:1:operLen{
		s operInfo=$p(operStr,",",j)
		s operDesc=$p(operInfo,"|",2)
		s operCode=..GetPekingOperICD(operDesc)
		if (operscode=""){
			s operscode=operCode
		}else{
			s operscode=operscode_","_operCode
		}
	}
 	;s operscode="[00.61009]"
 	s operscode="["_operscode_"]"
 	
 	//调用DRGs分组器返回分组信息
	Set httprequest=##class(%Net.HttpRequest).%New()
    set httprequest.Server="localhost"
    set httprequest.Port=3001
    Do httprequest.InsertFormData("DISEASE_CODE",mainDiagCode)
    Do httprequest.InsertFormData("AGE",AGE)
    Do httprequest.InsertFormData("GENDER",GENDER)
    Do httprequest.InsertFormData("SF0100","-1")
    Do httprequest.InsertFormData("SF0102","-1")
    Do httprequest.InsertFormData("SF0104","-1")
    Do httprequest.InsertFormData("SF0108","-1")
    Do httprequest.InsertFormData("ACCTUAL_DAYS",ACCTUALDAYS)
    Do httprequest.InsertFormData("TOTAL_EXPENSE",TOTALEXPENSE)
    Do httprequest.InsertFormData("diags_code",otherDiagCode) //['I10xx05']
    Do httprequest.InsertFormData("opers_code",operscode) //['43.99003','40.3 001']
    set tSc = httprequest.Post("http://localhost:3001/comp_drg")
    s resDrgs=httprequest.HttpResponse.Data.Read()
    
    //DRGs返回JSON转对象获取drg代码信息
    s drg=""
    if (resDrgs'=""){
		s scFromJSON= ##class(ext.util.JsonObject).FromJSON(resDrgs)
		s drg=scFromJSON.GetValue("drg")
	}
    if ((drg="0000")||(drg="9999")||($e(drg,*-1,*)="QY")){ //未入组
		s drg=""    
	}
	//返回诊断相关组信息
	if (drg'=""){
		s result=..GetDRGsInfo(drg)	
	}
    q result
}*/

// 调用统一webservice接口版

/// Creator：高姗姗
/// CreatDate: 2020-02-14
/// Description：获取调用Drgs接口所需入参
/// Input：就诊号，患者登记号，主诊断描述，其他诊断描述串
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetDrgsParam("IP0000000086","0000000162","淋巴瘤","")
ClassMethod GetDrgsParam(ADMNo As %String, PMINo As %String, mainDiag As %String, otherDiag As %String) As %String
{
	s param=""
	//获取患者信息
 	s patientInfo=..GetPatientInfo(ADMNo, PMINo)
 	s AGE=$p($p(patientInfo,"^",1),"岁",1) //年龄
 	s GENDER=$p(patientInfo,"^",2) //性别
 	s:GENDER="男" GENDER="1"
 	s:GENDER="女" GENDER="2"
 	s ACCTUALDAYS=$p(patientInfo,"^",3) //住院天数
 	s TOTALEXPENSE=$p(patientInfo,"^",4) //住院费用
 	
 	//获取主诊断北京版ICD码
 	s mainDiagCode=..GetPekingDiagICD(mainDiag) 
 	//获取其他诊断北京版ICD码
 	s otherDiagStr=""
 	if (otherDiag'=""){
	 	s otherDiagLen=$Length(otherDiag,"^")
	 	for i=1:1:otherDiagLen{
			s diagDesc=$p(otherDiag,"^",i)
			s diagCode=..GetPekingDiagICD(diagDesc)
			if (otherDiagStr=""){
				s otherDiagStr="{""CODE"":"""_diagCode_""",""DESC"":"""_diagDesc_"""}"
			}else{
				s otherDiagStr=otherDiagStr_",{""CODE"":"""_diagCode_""",""DESC"":"""_diagDesc_"""}"
			}
		}
	}
	s otherDiagStr="["_otherDiagStr_"]"

	//获取手术北京版ICD码
	s operscode=""
	s operStr=..GetOperationInfo(ADMNo)
	if (operStr'=""){
		s operLen=$Length(operStr,",")
		for j=1:1:operLen{
			s operInfo=$p(operStr,",",j)
			s operDesc=$p(operInfo,"|",2)
			s operCode=..GetPekingOperICD(operDesc)
			if (operscode=""){
				s operscode="{""CODE"":"""_operCode_""",""DESC"":"""_operDesc_"""}"
			}else{
				s operscode=operscode_",{""CODE"":"""_operCode_""",""DESC"":"""_operDesc_"""}"
			}
		}
	}
 	s operscode="["_operscode_"]"
 	s param="{""CASE_ID"":"""_ADMNo_""",""AGE"":"""_AGE_""",""TOTAL_EXPENSE"":"""_TOTALEXPENSE_""",""ACCTUAL_DAYS"":"""_ACCTUALDAYS_""",""SF0108"":""9"",""SF0100"":""0"",""DISEASE_CODE"":"""_mainDiagCode_""",""DISEASE_NAME"":"""_mainDiag_""",""GENDER"":"""_GENDER_""",""DIAGS_CODE"":"_otherDiagStr_",""OPERS_CODE"":"_operscode_"}"
	q param
}

/// Creator：高姗姗
/// CreatDate: 2019-08-13
/// Description：调用DRGs接口获取DRGs分组信息
/// Input：就诊号，患者登记号，主诊断描述，其他诊断描述串
/// Return：DRGs分组信息：DRG代码&^诊断相关组&^权重&^风险级别&^平均住院日%^例均费用
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosInterface).GetDrgsGroup("IP0000000086","0000000162","淋巴瘤","")
ClassMethod GetDrgsGroup(ADMNo As %String, PMINo As %String, mainDiag As %String, otherDiag As %String) As %String
{
	;s ^TMPGSS("drgstr")=ADMNo_","_PMINo_","_mainDiag_","_otherDiag
	s result=""
 	s param=..GetDrgsParam(ADMNo, PMINo, mainDiag, otherDiag)
	//调用DRGs统一对外webservice接口返回分组信息
	try{
		s objService=##class(web.DHCBL.MKB.MrDataExportServiceImplPort).%New()
		s resService=objService.drgInfoForDoctor(param)
		//DRG代码&^诊断相关组&^权重&^风险级别&^平均住院日%^例均费用
		s objDRG=[].%FromJSON(resService) 
		if (objDRG."result_code"=0){
			s DRGCODE=objDRG."result_message"."DRG_CODE"
			s DRGDESC=objDRG."result_message"."DRG_DESC"
			q:DRGDESC="未入组"
			s ASWEIGHT=objDRG."result_message"."AS_WEIGHT"
			s ASRISKLEVEL=objDRG."result_message"."AS_RISK_LEVEL"
			s ASAVGDAYS=objDRG."result_message"."AS_AVG_DAYS"
			s ASAVGFEE=objDRG."result_message"."AS_AVG_FEE"
			s result=DRGCODE_"&^"_DRGDESC_"&^"_ASWEIGHT_"&^"_ASRISKLEVEL_"&^"_ASAVGDAYS_"&^"_ASAVGFEE
    	}
    }
	catch myvar{
		//s resError = myvar.Name
		s result=""
	}
    q result
}

}
