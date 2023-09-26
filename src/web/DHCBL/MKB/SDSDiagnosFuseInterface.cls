/// Creator:高姗姗
/// CreatDate:2020-09-02
/// Description: 结构化诊断深度融合HIS接口
Class web.DHCBL.MKB.SDSDiagnosFuseInterface Extends %RegisteredObject
{

/****************************对接医生站**********************************************/
/// Creator：高姗姗
/// CreatDate: 2020-09-02
/// Description：查询患者诊断列表内容
/// Table：User.SDSDiagnos
/// Input：PMINo,ADMNo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosFuseInterface","GetListByPatient","0000000008","IP0000000003")
Query GetListByPatient(PMINo As %String, ADMNo As %String) As %Query(ROWSPEC = "SDSRowId,SDSTermDR,SDSValue,SDSDisplayName,SDSIcdCode,SDSIcdDesc,SDSWordDR,SDSVisitFlag,MRDiagRowId")
{
}

ClassMethod GetListByPatientExecute(ByRef qHandle As %Binary, PMINo As %String, ADMNo As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 	s PatientID=$o(^User.SDSPatMasI("PMINoIndex",PMINo,""))
 	s mradm=$o(^User.SDSAdmI("ADMNoIndex",ADMNo,""))
 	if (PatientID'=""){
	 	s SDSRowId=""
	  	for {
			s SDSRowId=$o(^User.SDSDiagnosI("PMIIndex",PatientID,SDSRowId)) q:SDSRowId=""
			s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2) //结构化诊断中心词DR
			s SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(SDSRowId),"-",2) //属性内容id串
			s SDSDisplayName=##class(web.DHCBL.MKB.SDSDiagnos).GetDiagName(SDSRowId) //结构化诊断表达式
			s SDSIcdCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5) //ICD编码
			s SDSIcdDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6) //ICD描述
			s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
			s SDSVisitFlag="false" //本次就诊标识
			s subLog=$o(^User.SDSDiagnosLogI("RefIndex",SDSRowId,""),-1) //最后一条日志
		  	s SDSAdmDR=$LISTGET($G(^User.SDSDiagnosLogD(subLog)),9) //日志就诊信息
		 	if (SDSAdmDR=mradm){
			 	s SDSVisitFlag="true"
			}
			s MRDiagRowId="" //医生站诊断id
			s linkRowId=$o(^User.SDSDiagnosLinkI("StructIndex",SDSRowId,0)) //关联表id
			s:linkRowId'="" MRDiagRowId=$LISTGET($G(^User.SDSDiagnosLinkD(linkRowId)),2) //医生站端诊断的id
			
			if (MRDiagRowId'=""){
				d OutputRow1
			}
	  	}
	}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow1
    set Data=$lb(SDSRowId,SDSTermDR,SDSValue,SDSDisplayName,SDSIcdCode,SDSIcdDesc,SDSWordDR,SDSVisitFlag,MRDiagRowId)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListByPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListByPatientExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListByPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListByPatientExecute ]
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
/// CreatDate: 2021-03-16
/// Description:根据医生站诊断id获取结构化诊断相关信息
/// Table：User.SDSDiagnosLink，User.SDSDiagnos
/// Input：就诊编号，医生站诊断id
/// Return:结构化诊断id^结构化诊断中心词id^属性内容值串^结构化诊断展示名^ICD编码^ICD描述^本次就诊标识
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetStructDiagnos(ADMNo,MRDiagRowId)
ClassMethod GetStructDiagnos(ADMNo As %String, MRDiagRowId As %String) As %String
{
	q:MRDiagRowId="" ""
	s result=""
	s SDSRowId=""
	s linkRowId=$o(^User.SDSDiagnosLinkI("DiagnosIndex",MRDiagRowId,0)) //关联表id
	s:linkRowId'="" SDSRowId=$LISTGET($G(^User.SDSDiagnosLinkD(linkRowId)),3) //结构化诊断id
	q:SDSRowId="" ""
	s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2) //结构化诊断中心词DR
	s SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(SDSRowId),"-",2) //属性内容id串
	s SDSDisplayName=##class(web.DHCBL.MKB.SDSDiagnos).GetDiagName(SDSRowId) //结构化诊断表达式
	s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),4) //补充诊断
	s SDSIcdCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5) //ICD编码
	s SDSIcdDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6) //ICD描述
	s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
	
	
	s mradm=$o(^User.SDSAdmI("ADMNoIndex",ADMNo,""))
	s SDSVisitFlag="false" //本次就诊标识
	s subLog=$o(^User.SDSDiagnosLogI("RefIndex",SDSRowId,""),-1) //最后一条日志
	s SDSAdmDR=""
  	s:subLog'="" SDSAdmDR=$LISTGET($G(^User.SDSDiagnosLogD(subLog)),9) //日志就诊信息
 	if (SDSAdmDR=mradm){
	 	s SDSVisitFlag="true"
	}
	s result=SDSRowId_"^"_SDSTermDR_"^"_SDSValue_"^"_SDSDisplayName_"^"_SDSIcdCode_"^"_SDSIcdDesc_"^"_SDSVisitFlag_"^"_SDSWordDR_"^"_SDSSupplement
	q result
}

/// Creator：高姗姗
/// CreatDate: 2020-10-20
/// Description:根据诊断中心词id及属性内容id串获取结构化诊断表达式展示名
/// Table：User.SDSDiagnos
/// Input：诊断中心词id，属性内容id串
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetDisplayName(SDSTermDR,SDSValue,SDSSupplement)
ClassMethod GetDisplayName(SDSTermDR As %String, SDSValue As %String, SDSSupplement As %String = "") As %String
{
	s result=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(SDSValue,SDSTermDR)
	s SDSSupplement=##class(web.DHCBL.BDP.FunLib).EvalJSON(SDSSupplement)
	if ((result'="")&&(SDSSupplement'="")){
		if (result["]"){
			s result=$p(result,"]",1)_",("_SDSSupplement_")]"	
		}else{
			s result=result_"[("_SDSSupplement_")]"
		}
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2020-09-03
/// Description:结构化诊断同步保存
/// Table：User.SDSDiagnos
/// Input：MRDiagRowId医生站诊断id, PMINo患者登记号, ADMNo就诊号, TermDR术语指向, SDSValue属性内容值串, Supplement备注, Cat分类, MainFlag主诊断, Type诊断类型, Status诊断状态, Level级别, Sequence序号, OpenDate诊断日期, OnsetDate发病日期
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).SaveStructDiagnos()
ClassMethod SaveStructDiagnos(MRDiagRowId, PMINo, ADMNo, TermDR, SDSValue, Supplement, Cat, MainFlag, Type, Status, Level, Sequence, OpenDate, OnsetDate, WordDR = "") As %String
{
	s PatientID=##class(web.DHCBL.MKB.SDSPatMas).SaveData(PMINo)
	s mradm=##class(web.DHCBL.MKB.SDSAdm).SaveData(PatientID,ADMNo)
	s SDSRowId=""
	s linkRowId=$o(^User.SDSDiagnosLinkI("DiagnosIndex",MRDiagRowId,0)) //关联表id
	s:linkRowId'="" SDSRowId=$LISTGET($G(^User.SDSDiagnosLinkD(linkRowId)),3) //结构化诊断ID
	if (SDSRowId=""){ //新增
		s obj=##class(User.SDSDiagnos).%New()
	}else{ //修改
		s obj=##class(User.SDSDiagnos).%OpenId(SDSRowId)
		s bobj=##class(web.Entity.MKB.SDSDiagnos).%New()
		s bobj.SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(SDSRowId),"-",2)	
		s:obj.SDSTermDR'="" bobj.SDSTermDR=obj.SDSTermDR.%Id()
		s:obj.SDSTermDR="" bobj.SDSTermDR=""
		s bobj.SDSSupplement=obj.SDSSupplement
		s bobj.SDSIcdCode=obj.SDSIcdCode
		s bobj.SDSIcdDesc=obj.SDSIcdDesc
		s bobj.SDSWordDR=obj.SDSWordDR
		s bobj.SDSMainDiagFlag=obj.SDSMainDiagFlag
		s bobj.SDSTagDR=obj.SDSTagDR
		s:obj.SDSTypeDR'="" bobj.SDSTypeDR=obj.SDSTypeDR.%Id()
		s:obj.SDSTypeDR="" bobj.SDSTypeDR=""
		s:obj.SDSStatusDR'="" bobj.SDSStatusDR=obj.SDSStatusDR.%Id()
		s:obj.SDSStatusDR="" bobj.SDSStatusDR=""
		s bobj.SDSCat=obj.SDSCat
	}
	
	d:TermDR'="" obj.SDSTermDRSetObjectId(TermDR)
	d:TermDR="" obj.SDSTermDRSetObjectId("")
	d:PatientID'="" obj.SDSPMIDRSetObjectId(PatientID)
	d:PatientID="" obj.SDSPMIDRSetObjectId("")
	s Supplement=##class(web.DHCBL.BDP.FunLib).Util(Supplement)
	s obj.SDSSupplement=Supplement
	s obj.SDSOpenDate=OpenDate
	s obj.SDSSequence=Sequence
	s obj.SDSMainDiagFlag=MainFlag
	s obj.SDSLevel=Level
	s obj.SDSOnsetDate=OnsetDate
	s SDSTypeDR=..GetDiagType(Type)
	d:SDSTypeDR'="" obj.SDSTypeDRSetObjectId(SDSTypeDR)
	d:SDSTypeDR="" obj.SDSTypeDRSetObjectId("")
	s SDSStatusDR=..GetDiagStatus(Status)
	d:SDSStatusDR'="" obj.SDSStatusDRSetObjectId(SDSStatusDR)
	d:SDSStatusDR="" obj.SDSStatusDRSetObjectId("")
	s obj.SDSCat=Cat
	
	s resWordICD=##class(web.DHCBL.MKB.SDSDiagnos).GetWordICD(TermDR,SDSValue,Supplement,WordDR,Cat)
	s SDSWordDR=$p(resWordICD,"^",5)
	s SDSIcdCode=$p(resWordICD,"^",7)
	s SDSIcdDesc=$p(resWordICD,"^",8)
	s obj.SDSWordDR=SDSWordDR
	s obj.SDSIcdCode=SDSIcdCode
	s obj.SDSIcdDesc=SDSIcdDesc
	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		s id = obj.%Id()
		
		//维护子表属性
		s resultChild=##class(web.DHCBL.MKB.SDSDiagnosProperty).SaveData(id,SDSValue)

		//新增维护引用表
		if (SDSRowId=""){
			s:TermDR'="" resultRefTerm=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"T",TermDR)
			s version=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
			if (version["ICD"){ //取自各版本icd对照
				s:SDSWordDR'="" resultRefWord=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"ICDX",SDSWordDR)
			}else{ //取自数据处理工厂
				s:SDSWordDR'="" resultRefWord=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"SD",SDSWordDR)
			}
			s:SDSTypeDR'="" resultRefType=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"T",SDSTypeDR)
			s:SDSStatusDR'="" resultRefStatus=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"T",SDSStatusDR)
		}else{ //诊断类型、诊断状态修改维护引用表
			s refTypeId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("SDS",id,"T",bobj.SDSTypeDR)
			s resultRefType=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refTypeId, "SDS",id,"T",SDSTypeDR)
			s refStatusId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("SDS",id,"T",bobj.SDSStatusDR)
			s resultRefStatus=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refStatusId, "SDS",id,"T",SDSStatusDR)
		}
		
		//维护子表日志
		s SDSDiagnosLog=""
		if (SDSRowId="") {
			s newValue="{""SDSTermDR"":"""_TermDR_""",""SDSValue"":"""_SDSValue_""",""SDSSupplement"":"""_Supplement_""",""SDSWordDR"":"""_SDSWordDR_""",""SDSIcdCode"":"""_SDSIcdCode_""",""SDSIcdDesc"":"""_SDSIcdDesc_""",""SDSMainDiagFlag"":"""_MainFlag_"""}"
			d:mradm'="" ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(id,"A","",newValue,mradm)
			
			//子表日志返回给医生站
			s SDSDiagnosLog=..GetLog(TermDR,"",SDSValue) 
		}else{
			s logSub=$o(^User.SDSDiagnosLogI("RefIndex",id,""),-1)
			s:logSub'="" SDSUpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(logSub)),2)
			s:logSub="" SDSUpdateUserDR=""
			//属性有变;操作人有变
			if ((SDSValue'=bobj.SDSValue)||(($Get(%session.Data("LOGON.USERID"))'=SDSUpdateUserDR)&&(SDSUpdateUserDR'=""))){
				s oldValue="{""SDSTermDR"":"""_bobj.SDSTermDR_""",""SDSValue"":"""_bobj.SDSValue_""",""SDSSupplement"":"""_bobj.SDSSupplement_""",""SDSWordDR"":"""_bobj.SDSWordDR_""",""SDSIcdCode"":"""_bobj.SDSIcdCode_""",""SDSIcdDesc"":"""_bobj.SDSIcdDesc_""",""SDSMainDiagFlag"":"""_bobj.SDSMainDiagFlag_"""}"
				s newValue="{""SDSTermDR"":"""_TermDR_""",""SDSValue"":"""_SDSValue_""",""SDSSupplement"":"""_Supplement_""",""SDSWordDR"":"""_SDSWordDR_""",""SDSIcdCode"":"""_SDSIcdCode_""",""SDSIcdDesc"":"""_SDSIcdDesc_""",""SDSMainDiagFlag"":"""_MainFlag_"""}"
				d ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(id,"U",oldValue,newValue,mradm) //子表日志
				
				//子表日志返回给医生站
				s SDSDiagnosLog=..GetLog(TermDR,bobj.SDSValue,SDSValue) 
			}
		}
		
		//保存到关联表
		s scLink=##class(web.DHCBL.MKB.SDSDiagnosLink).SaveLink(MRDiagRowId,id,mradm)
		
		Tc
		s result="{""success"":""true"",""SDSDiagnosLog"":"""_SDSDiagnosLog_"""}"
	}else{
		Trollback
		//s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s result = "{""success"":""false""}" 
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2020-09-03
/// Description:根据id删除,本次就诊一对一关系时，同步删除诊断及关联关系，一对多关系时，仅删关联关系
/// Table:User.SDSDiagnos,User.SDSDiagnosLink
/// Input：ADMNo就诊号 MRDiagnosRowid医生端诊断表id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).DeleteStructDiagnos(ADMNo,DiagItemRowStr)
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

/// Creator：高姗姗
/// CreatDate: 2021-07-12
/// Description:获取结构化诊断当次日志
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetLog("14947","6030:329344","6030:329343")
ClassMethod GetLog(TermDR, OldValue, NewValue) As %String
{
  q:TermDR="" ""
  d ..GetLogContent(TermDR, OldValue, NewValue)
	  	      
  s key=""
  s content=""
  for{
      s key=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse",key)) q:key=""
      if ($g(^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseFlag",key))="D"){
	      s keyDesc=$LISTGET($G(^User.MKBTermProDetailD(key)),3)
	  }else{
		  s keyDesc=$LISTGET($G(^User.MKBTermPropertyD(key)),3)
	  }
	  
	  ;属性内容值及描述
	  s oldValue=$p(^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse",key),"&%",1)
	  s oldValueDesc=""
	  if (oldValue'=""){
		  s oldValueLen=$Length(oldValue,"*")
		  for i=1:1:oldValueLen{
			  s oneoldValue=$p(oldValue,"*",i)
			  if (oneoldValue["S"){
				  s oneoldValueDesc=$listGet($g(^User.MKBTermD($p(oneoldValue,"S",2))),3)
			  }else{
				  s oneoldValueDesc=$LISTGET($G(^User.MKBTermProDetailD(oneoldValue)),3)
			  }
			  if (oldValueDesc=""){
				  s oldValueDesc=oneoldValueDesc
			  }else{
				  s oldValueDesc=oldValueDesc_","_oneoldValueDesc 
			  }
		  }
	  }
	  s newValue=$p(^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse",key),"&%",2)
	  s newValueDesc=""
	  if (newValue'=""){
		  s newValueLen=$Length(newValue,"*")
		  for i=1:1:newValueLen{
			  s onenewValue=$p(newValue,"*",i)
			  if (onenewValue["S"){
				  s onenewValueDesc=$listGet($g(^User.MKBTermD($p(onenewValue,"S",2))),3)
			  }else{
				  s onenewValueDesc=$LISTGET($G(^User.MKBTermProDetailD(onenewValue)),3)
			  }
			  if (newValueDesc=""){
				 s newValueDesc=onenewValueDesc 
			  }else{
				 s newValueDesc=newValueDesc_","_onenewValueDesc 
			  } 
		  }
	  }
	  if (content=""){
		  s content=keyDesc_":"_oldValueDesc_"->"_newValueDesc
	  }else{
		  s content=content_"&%"_keyDesc_":"_oldValueDesc_"->"_newValueDesc
	  } 
  }
  //未保存属性情况下显示诊断名
  if (content=""){
	  s MKBTRowId=$g(^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse"))
	  s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3) 
	  s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)
	  s strCom=$p(strComAndAlisa,"[A]",1)
	  s comDesc=$p(strCom,"&%",1) //诊断常用名
	  s content=MKBTDesc
	  s:comDesc'="" content=comDesc_"("_MKBTDesc_")" //常用名(中心词)
	  s:comDesc="" content=MKBTDesc_"("_MKBTDesc_")" //中心词(中心词)
  }
  q content
}

/// Creator：高姗姗
/// CreatDate: 2021-07-12
/// Description：获取结构化诊断历史记录内容
/// Table：User.SDSDiagnosLog
/// Input：SDSTermDR, SDSOldValue, SDSNewValue
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosLog).GetLogContent()
ClassMethod GetLogContent(SDSTermDR, SDSOldValue, SDSNewValue) As %String
{
 	//生成属性(含起始节点)及属性内容的临时global
   k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse")
   k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeOld")
   k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeNew")
   k ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseFlag")

   q:SDSTermDR="" ""
   d ##Class(web.DHCBL.MKB.SDSDiagnos).GetPropertyByNode(SDSTermDR)

   if (SDSOldValue'=""){
	  s len=$Length(SDSOldValue,",")
	  for i=1:1:len{
	  	 s OldVal=$p(SDSOldValue,",",i)
		 s key = $p(OldVal,":",1)
		 s value = $p(OldVal,":",2)
		 s detailLen=$Length(value,"*")
		 for j=1:1:detailLen{
			 s DetailTitleNode=""
			 s detailid=$p(value,"*",j)
			 if (detailid'["S"){
			    s DetailNode=##Class(web.DHCBL.MKB.SDSDiagnos).GetDetailNode(SDSTermDR,detailid)
		  	  	s:DetailNode'="" DetailTitleNode=$LISTGET($G(^User.MKBTermProDetailD(DetailNode)),4)  //诊断模板定义的起始节点
		  		s:DetailNode="" DetailTitleNode=""	
			 }
			 //生成含起始节点临时global
			 if (DetailTitleNode'=""){
				s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeOld",DetailTitleNode,detailid)=""	
				s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseFlag",DetailTitleNode)="D"  
			 }else{
				s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeOld",key,detailid)=""  
				s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseFlag",key)=""  
			 }
		  	}
	    }
	    s pro=""
	    for {
		    s pro=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeOld",pro)) q:pro=""
		    s detailItmOld=""
		    s detailid=""
		    for {
			    s detailid=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeOld",pro,detailid)) q:detailid=""
			    if (detailItmOld=""){
				    s detailItmOld=detailid
				}else{
					s detailItmOld=detailItmOld_"*"_detailid
				}
			    
			}
			s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse",pro)=detailItmOld
		}
    }
  	 if (SDSNewValue'=""){
	  	s len=$Length(SDSNewValue,",")
	 	for i=1:1:len{
	  		s NewVal=$p(SDSNewValue,",",i)
			s key = $p(NewVal,":",1)
			s value = $p(NewVal,":",2)
			s detailLen=$Length(value,"*")
		 	for j=1:1:detailLen{
			 	s DetailTitleNode=""
			 	s detailid=$p(value,"*",j)
			 	if (detailid'["S"){
			    	s DetailNode=##Class(web.DHCBL.MKB.SDSDiagnos).GetDetailNode(SDSTermDR,detailid)
			    	
		  	  		s:DetailNode'="" DetailTitleNode=$LISTGET($G(^User.MKBTermProDetailD(DetailNode)),4)  //诊断模板定义的起始节点
		  			s:DetailNode="" DetailTitleNode=""	
		  			
			 	}

			 	//生成含起始节点临时global
			 	if (DetailTitleNode'=""){
					s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeNew",DetailTitleNode,detailid)=""	
					s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseFlag",DetailTitleNode)="D"    
				}else{
					s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeNew",key,detailid)=""
					s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseFlag",key)=""    
			 	}
			  
		  	}
	    }
	    s pro=""
	    for {
		    s pro=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeNew",pro)) q:pro=""
		    s detailItmNew=""
		    s detailid=""
		    for {
			    s detailid=$o(^TMPSTRUCTDIAGNOSLOG($zn,$j,"FuseNodeNew",pro,detailid)) q:detailid=""
			    if (detailItmNew=""){
				    s detailItmNew=detailid
				}else{
					s detailItmNew=detailItmNew_"*"_detailid
				}
			}
			s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse",pro)=$g(^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse",pro))_"&%"_detailItmNew
		}
	  }

  //未保存属性情况下显示诊断名
  if ((SDSOldValue="")&(SDSNewValue="")){
	  s ^TMPSTRUCTDIAGNOSLOG($zn,$j,"Fuse")=SDSTermDR
  }

  q 1
}

/// Creator：高姗姗
/// CreatDate: 2020-09-03
/// Description:获取结构化诊断类型id
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetDiagType("测试")
ClassMethod GetDiagType(desc) As %String
{
	s resid=""
	s base=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiaType")
	if (base'=""){
		s resid=$o(^User.MKBTermI("DescIndex",base," "_$ZCONVERT(desc,"U"),0))
		if (resid=""){
			s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
			s eobj.MKBTRowId=""
			s eobj.MKBTDesc=desc
			s eobj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(desc)
			s eobj.MKBTNote=""
			s eobj.MKBTBaseDR=base
			s rtn=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
			if (rtn["true"){
				s resid=$e(rtn,21,*-2)
			}
		}
	}
	q resid
}

/// Creator：高姗姗
/// CreatDate: 2020-09-03
/// Description:获取结构化诊断状态id
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetDiagStatus("测试1")
ClassMethod GetDiagStatus(desc) As %String
{
	s resid=""
	s base=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiaState")
	if (base'=""){
		s resid=$o(^User.MKBTermI("DescIndex",base," "_$ZCONVERT(desc,"U"),0))
		if (resid=""){
			s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
			s eobj.MKBTRowId=""
			s eobj.MKBTDesc=desc
			s eobj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(desc)
			s eobj.MKBTNote=""
			s eobj.MKBTBaseDR=base
			s rtn=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
			if (rtn["true"){
				s resid=$e(rtn,21,*-2)
			}
		}
	}
	q resid
}

/****************************对接DRG**********************************************/
/// Creator：高姗姗
/// CreatDate: 2021-11-04
/// Description：调用DRGs接口获取DRGs分组信息
/// Input：就诊号，患者登记号，主诊断描述，其他诊断描述串
/// Return：DRGs分组信息
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetDrgInfo("IP0000000212","0000000376")
ClassMethod GetDrgInfo(EpisodeID As %String, PatientID As %String, DiagInfo As %String, SDSParam As %String = "", Type As %String = "")
{
	q:(EpisodeID="")||(PatientID="") ""
	;s EpisodeID=$o(^PAADMi("No",$ZCONVERT(ADMNo,"U"),0))
	;s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCONVERT(PMINo,"U"),0))
	s patid=$p($g(^PAADM(EpisodeID)),"^",1)
	s ADMNo=$p($g(^PAADM(EpisodeID)),"^",81) //就诊编号
	s PMINo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1) //登记编号
	//8.3.1版
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID) //年龄
	s AGE=$p(PatAge,"岁",1)
	s InPatDays=##class(web.DHCDoc.OP.AjaxInterface).GetInPatAdmDays(EpisodeID) //住院天数
	
	s PatSex=""
	s PatSexDr=$p(^PAPER(patid,"ALL"),"^",7) 
	i PatSexDr'="" s PatSex=$p($g(^CT("SEX",PatSexDr)),"^","2") //性别
	s:PatSex="男" PatSex="1"
 	s:PatSex="女" PatSex="2"
	s amount=$p(##Class(web.DHCBillInterface).IGetDepAndBalnace(EpisodeID),"^",3) //住院费用 
	
	s DisChargeDate=+$p($g(^PAADM(EpisodeID)),"^",59) ;结算日期
	s IsDeceased=##Class(web.PAPerson).CheckDeceased(patid) ;死亡标志
	s:DisChargeDate=0 DisChargeDate=+$H
	
	s outtype=""
	if (DisChargeDate>0){s outtype=1} ;医嘱出院
	if (IsDeceased="Y"){s outtype=5} ;死亡出院
	
	;诊断
	s MainDiagCode="",MainDiagName=""
	s DiagList=##class(%DynamicArray).%New()  //其他诊断集合
	if (DiagInfo'=""){ //前台获取诊断录入列表里的诊断,避免之前录入的非结构化诊断获取不到
		s DiagLen=$Length(DiagInfo,"&")
		for i=1:1:DiagLen{
			s Diag=$p(DiagInfo,"&",i)
			s DiagDesc=$p(Diag,"^",1)
			s DiagCode=$p(Diag,"^",2)
			s MainDiagFlag=$p(Diag,"^",3) //是或否
			s EditFlag=$p(Diag,"^",4) //是或空
			if (EditFlag="是"){ //正在编辑的行通过结构化诊断勾选的属性获取ICD
				s SDSIcdCode="",SDSIcdDesc=""
				s version=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
				s SDSWordDRStr=##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDiagViaStruct(version,SDSParam) //GetDiagViaStructSort
				if (SDSWordDRStr'=""){
					s WordLen=$Length(SDSWordDRStr,",")
					for j=1:1:WordLen{
						s SDSWordDR=$p(SDSWordDRStr,",",j)
						s SDSWordDesc=$LISTGET($G(^User.MKBStructuredDataD(SDSWordDR)),2) 
						s SDSIcdCode=$LISTGET($G(^User.MKBStructuredDataD(SDSWordDR)),20) 
						s SDSIcdDesc=$LISTGET($G(^User.MKBStructuredDataD(SDSWordDR)),21)
						s ICDRowId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(SDSIcdCode,SDSIcdDesc,Type)
						q:(ICDRowId'="")
					}	
				}	
				s:SDSIcdCode'="" DiagCode=SDSIcdCode
				s:SDSIcdDesc'="" DiagDesc=SDSIcdDesc
			}
			if (MainDiagFlag="是") //主诊断
		 	{ 
			 	s MainDiagCode=DiagCode
			 	s MainDiagName=DiagDesc
			}
			else //其他诊断
			{
				s dia={}
				d dia.%Set("CODE",DiagCode)
				d dia.%Set("DESC",DiagDesc)
				d DiagList.%Push(dia)
			}
		}
	}else{ //后台获取结构化诊断表里的诊断
		s PatientID=$o(^User.SDSPatMasI("PMINoIndex",PMINo,""))
		if (PatientID'=""){
		 	s mradm=$o(^User.SDSAdmI("ADMNoIndex",ADMNo,""))
			s DiagId=""
			for {
				s DiagId=$o(^User.SDSDiagnosI("PMIIndex",PatientID,DiagId))	q:DiagId=""
				s subLog=$o(^User.SDSDiagnosLogI("RefIndex",DiagId,""),-1) //最后一条日志
				s SDSAdmDR=$LISTGET($G(^User.SDSDiagnosLogD(subLog)),9) //日志就诊信息
				s SDSIcdCode=$LISTGET($G(^User.SDSDiagnosD(DiagId)),5) //ICD编码
				s SDSIcdDesc=$LISTGET($G(^User.SDSDiagnosD(DiagId)),6) //ICD描述
				s SDSMainDiagFlag=$LISTGET($G(^User.SDSDiagnosD(DiagId)),10) //主诊断 Y/N
			 	if (SDSAdmDR=mradm){ //本次就诊
				 	if (SDSMainDiagFlag="Y") //主诊断
				 	{ 
					 	s MainDiagCode=SDSIcdCode
					 	s MainDiagName=SDSIcdDesc
					}
					else //其他诊断
					{
						s dia={}
						d dia.%Set("CODE",SDSIcdCode)
						d dia.%Set("DESC",SDSIcdDesc)
						d DiagList.%Push(dia)
					}
				}
			}
		}
	}
	
	s jsonparam={}
	d jsonparam.%Set("CASE_ID",ADMNo) ;就诊号
	d jsonparam.%Set("AGE",AGE) ;年龄	
	d jsonparam.%Set("TOTAL_EXPENSE",amount) ;费用	
	d jsonparam.%Set("ACCTUAL_DAYS",InPatDays) ;入院天数	
	d jsonparam.%Set("SF0108",outtype) ;离院方式编码：1.医嘱离院 2.医嘱转院 3.医嘱转社区卫生服务机构/乡镇卫生院4.非医嘱离院 5.死亡 9.其他
	d jsonparam.%Set("SF0100",-1) ;新生儿年龄天，空传-1，整数
	d jsonparam.%Set("SF0102",-1) ;新生儿体重克，空传-1，整数
	d jsonparam.%Set("SF0104",-1) ;呼吸机使用时间小时，空传-1，整数
	d jsonparam.%Set("ICU",-1) ;ICU小时数，空传-1，整数
	d jsonparam.%Set("CRRT",-1) ;血液净化小时数，空传-1，整数
	d jsonparam.%Set("PDT",-1) ;透析次数，空传-1，整数
	d jsonparam.%Set("DISEASE_CODE",MainDiagCode) ;主诊断
	d jsonparam.%Set("DISEASE_NAME",MainDiagName) ;主诊断描述
	d jsonparam.%Set("GENDER",PatSex) ;性别,1男，2女
	
	d jsonparam.%Set("DIAGS_CODE",DiagList) ;其他诊断
	
	; 手术
	s OperList = ##class(%DynamicArray).%New()
	s OperationInfo=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetOperationInfo(ADMNo)
	if (OperationInfo'=""){
		s operLen=$Length(OperationInfo,",")
		for i=1:1:operLen{
			s operInfo=$p(OperationInfo,",",i)
			s operCode=$p(operInfo,"|",1)
			s operDesc=$p(operInfo,"|",2)
			s oper={}
			d oper.%Set("CODE",operCode)
			d oper.%Set("DESC",operDesc)
			d OperList.%Push(oper)
		}
	}
	d jsonparam.%Set("OPERS_CODE",OperList) ;手术
	
	//可不传
	;d jsonparam.%Set("STD_YEAR","2020") ;标杆年份
	;d jsonparam.%Set("PAY_TYPE","01") ;支付类型
	
	s jsonstr=jsonparam.%ToJSON()
	;w jsonstr
	
	; 调用Drg接口 要求诊断及手术编码为国家临床2.0版（河南驻马店为国家临床2.0）
	s rtndrgsjosn = ##class(web.DHCDRGs.Interface.PreGroupWebService).drgInfoForDoctor(jsonstr)
	
	; 将结果转换为动态对象
	s rtnjson=##class(%DynamicObject).%New()
	s rtnjson=rtnjson.%FromJSON(rtndrgsjosn)
	
	s resultcode=rtnjson.%Get("result_code") ;状态码
	
	s result=""
	if resultcode'=0  {
		s result = rtnjson.%Get("result_message")  ;失败提示
	}
	else{
		s resultMesag=rtnjson.%Get("result_message")
		s DRGCODE=resultMesag.%Get("DRG_CODE")  ; DRG病组编码，如果为空则表示未入组
		s DRGDESC=resultMesag.%Get("DRG_DESC")  ;DRG病组名称
		s DRGWEIGHT=resultMesag.%Get("DRG_WEIGHT")  ;DRG病组权重
		s DRGRATE=resultMesag.%Get("DRG_RATE")  ;DRG病组费率
		s DRGSTDFEE=resultMesag.%Get("DRG_STDFEE")  ;DRG病组支付标准
		s AVGDAYS=resultMesag.%Get("AVG_DAYS")  ;平均住院日
		s AVGFEE=resultMesag.%Get("AVG_FEE")  ;次均费用
		s HTML=resultMesag.%Get("HTML")  
		s DETAILURL=resultMesag.%Get("DETAIL_URL")
		if (DRGDESC="未入组"){
			s result="未入组&^"
		}else{
			s result=HTML_"&^"_DETAILURL
		}
	}
	/*if (ADMNo="IP0000000212"){
		s result="冠状动脉粥样硬化，不伴合并症与伴随病(FS25)<br>病组权重：0.61<br>次均费用：9642.33<br>平均住院日：7.08 &^https://www.baidu.com/"
	}
	else{
		s result="高血压(FS25)<br>病组权重：0.61<br>次均费用：9642.33<br>平均住院日：7.08 &^https://www.hao123.com/"
	}*/
	q result
}

}
