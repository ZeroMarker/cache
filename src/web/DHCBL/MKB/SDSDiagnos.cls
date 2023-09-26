/// Creator:高姗姗
/// CreatDate:2019-07-16
/// Description：插件版结构化诊断录入
/// Table：User.SDSDiagnos
Class web.DHCBL.MKB.SDSDiagnos Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2019-07-16
/// Description：查询诊断列表内容
/// Table：User.SDSDiagnos
/// Input：mradm,rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnos","GetList","5","1","")
Query GetList(PatientID As %String, mradm As %String, rowid As %String) As %Query(ROWSPEC = "SDSRowId,SDSTermDR,SDSDisplayName,SDSSupplement,SDSOpenDate,SDSIcdCode,SDSIcdDesc,SDSSequence,SDSWordDR,SDSWordDesc,SDSMainDiagFlag,SDSTagDR,SDSTag,RefFlag,IcdRowId,SDSLevel,SDSOnsetDate,SDSTypeDR,SDSTypeDesc,SDSStatusDR,SDSStatusDesc,DiagTypeId,DiagStatusId,UserName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, PatientID As %String, mradm As %String, rowid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 if (PatientID'=""){
	 d ..GetColumnList(PatientID,mradm)
	 if (rowid'="") //根据rowid返回该条记录
	 {
		  s SDSRowId=rowid
		  s flag=$$EachRowDiag(mradm,SDSRowId)
		  d OutputRow
	 }
	 else
	 {	 
	 	 s tagSeq="重要诊断^主要诊断^长效诊断^当前诊断^其他诊断"
	 	 s tagLen=$Length(tagSeq,"^")
	 	 for i=1:1:tagLen{
		 	  s tag=$p(tagSeq,"^",i)
		 	  s seq=""
			  for{
				  s seq=$o(^TMPSDSDIAGNOS($zn,$j,"ColumnSeqList",PatientID,tag,seq),-1)
				  q:seq=""  
				  s SDSRowId=""
				  for{  
				  	  s SDSRowId=$o(^TMPSDSDIAGNOS($zn,$j,"ColumnSeqList",PatientID,tag,seq,SDSRowId))
					  q:SDSRowId=""  
					  s flag=$$EachRowDiag(mradm,SDSRowId)
					  d OutputRow
				  }
			  }
		 }
	 }
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 }
EachRowDiag(mradm, SDSRowId)
	s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2)
	s SDSDisplayName=..GetDiagName(SDSRowId)
	s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),4)
	s SDSIcdCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5)
	s SDSIcdDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6)
	s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
	s SDSWordDesc=""
	s version=..GetWordVersion()
	if (version["ICD"){ //取自各版本icd对照
		s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBICDContrastD(SDSWordDR)),3)
	}else{ //取自数据处理工厂
		s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBStructuredDataD(SDSWordDR)),2)
	}
	s SDSOpenDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),8)
	s:SDSOpenDate'="" SDSOpenDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOpenDate)
	  
	s SDSSequence=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),9)
	s SDSMainDiagFlag=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),10)
	s SDSTag=""
	s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
	s:SDSTagDR'="" SDSTag=..GetTagText(SDSTagDR)
	s SDSLevel=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),12)
	s SDSOnsetDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),13)
	s:SDSOnsetDate'="" SDSOnsetDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOnsetDate)
	s SDSTypeDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),14)
	s:SDSTypeDR'="" SDSTypeDesc=$listGet($g(^User.MKBTermD(SDSTypeDR)),3)
	s:SDSTypeDR="" SDSTypeDesc=""
	s SDSStatusDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),15)
	s:SDSStatusDR'="" SDSStatusDesc=$listGet($g(^User.MKBTermD(SDSStatusDR)),3)
	s:SDSStatusDR="" SDSStatusDesc=""
	
	if ((SDSDisplayName'="")&(SDSLevel'="")&(SDSLevel>1)){
	    s SpaceHTML=""
	    for i=1:1:SDSLevel{
		  s SpaceHTML=SpaceHTML_"&nbsp;&nbsp;"	  
	    }
	    s SDSDisplayName=SpaceHTML_SDSDisplayName
    }
	
	s RefFlag=""
	if (mradm'=""){
		if ($d(^User.SDSDiagnosLinkI("AdmStructIndex",mradm,SDSRowId))){ //被引用
			s RefFlag="Y"
		}
	}
	
	s UserName="" //操作用户
	s SDSUpdateUserDR=""
	s LogRowId=$o(^User.SDSDiagnosLogI("OperateTypeIndex","A",SDSRowId,0))
	s:LogRowId'="" SDSUpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(LogRowId)),2)
	s:SDSUpdateUserDR'="" UserName=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("U",SDSUpdateUserDR)
		
	
	s IcdRowId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(SDSIcdCode,SDSIcdDesc) //ICD代码表RowId，引用诊断需要
	s DiagTypeId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetTypeIdByDesc(SDSTypeDesc) //医生站诊断类型表id，引用诊断需要
	s DiagStatusId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetStatusIdByDesc(SDSStatusDesc) //医生站诊断状态表id，引用诊断需要
	s flag=1
	q flag
	
OutputRow
    set Data=$lb(SDSRowId,SDSTermDR,SDSDisplayName,SDSSupplement,SDSOpenDate,SDSIcdCode,SDSIcdDesc,SDSSequence,SDSWordDR,SDSWordDesc,SDSMainDiagFlag,SDSTagDR,SDSTag,RefFlag,IcdRowId,SDSLevel,SDSOnsetDate,SDSTypeDR,SDSTypeDesc,SDSStatusDR,SDSStatusDesc,DiagTypeId,DiagStatusId,UserName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
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

/// Creator：高姗姗
/// CreatDate: 2019-09-10
/// Description:获取诊断表行数据
/// Table：User.SDSDiagnos
/// Input：SDSRowId
/// Other: d ##class(web.DHCBL.MKB.SDSDiagnos).GetDiagRow(1)
ClassMethod GetDiagRow(mradm, SDSRowId) As %String
{
	s result=""
	s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2)
	s SDSDisplayName=..GetDiagName(SDSRowId)
	s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),4)
	s SDSIcdCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5)
	s SDSIcdDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6)
	s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
	s SDSWordDesc=""
	s version=..GetWordVersion()
	if (version["ICD"){ //取自各版本icd对照
		s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBICDContrastD(SDSWordDR)),3)
	}else{ //取自数据处理工厂
		s:SDSWordDR'="" SDSWordDesc=$listGet($g(^User.MKBStructuredDataD(SDSWordDR)),2)
	}
	s SDSOpenDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),8)
	s:SDSOpenDate'="" SDSOpenDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOpenDate)
	  
	s SDSSequence=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),9)
	s SDSMainDiagFlag=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),10)
	s SDSTag=""
	s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
	s:SDSTagDR'="" SDSTag=..GetTagText(SDSTagDR)
	s SDSLevel=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),12)
	s SDSOnsetDate=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),13)
	s:SDSOnsetDate'="" SDSOnsetDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOnsetDate)
	s SDSTypeDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),14)
	s:SDSTypeDR'="" SDSTypeDesc=$listGet($g(^User.MKBTermD(SDSTypeDR)),3)
	s:SDSTypeDR="" SDSTypeDesc=""
	s SDSStatusDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),15)
	s:SDSStatusDR'="" SDSStatusDesc=$listGet($g(^User.MKBTermD(SDSStatusDR)),3)
	s:SDSStatusDR="" SDSStatusDesc=""
	
	if ((SDSDisplayName'="")&(SDSLevel'="")&(SDSLevel>1)){
	    s SpaceHTML=""
	    for i=1:1:SDSLevel{
		  s SpaceHTML=SpaceHTML_"&nbsp;&nbsp;"	  
	    }
	    s SDSDisplayName=SpaceHTML_SDSDisplayName
    }
	
	s RefFlag=""
	if (mradm'=""){
		if ($d(^User.SDSDiagnosLinkI("AdmStructIndex",mradm,SDSRowId))){ //被引用
			s RefFlag="Y"
		}
	}
	
	s UserName="" //操作用户
	s SDSUpdateUserDR=""
	s LogRowId=$o(^User.SDSDiagnosLogI("OperateTypeIndex","A",SDSRowId,0))
	s:LogRowId'="" SDSUpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(LogRowId)),2)
	s:SDSUpdateUserDR'="" UserName=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetUserLocDesc("U",SDSUpdateUserDR)
		
	
	s IcdRowId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(SDSIcdCode,SDSIcdDesc) //ICD代码表RowId，引用诊断需要
	s DiagTypeId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetTypeIdByDesc(SDSTypeDesc) //医生站诊断类型表id，引用诊断需要
	s DiagStatusId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetStatusIdByDesc(SDSStatusDesc) //医生站诊断状态表id，引用诊断需要
	s result=SDSTermDR_"^"_SDSDisplayName_"^"_SDSSupplement_"^"_SDSIcdCode_"^"_SDSIcdDesc_"^"_SDSWordDR_"^"_SDSWordDesc_"^"_SDSOpenDate_"^"_SDSSequence_"^"_SDSMainDiagFlag_"^"_SDSTagDR_"^"_SDSTag_"^"_RefFlag_"^"_IcdRowId_"^"_SDSLevel_"^"_SDSOnsetDate_"^"_SDSTypeDR_"^"_SDSTypeDesc_"^"_SDSStatusDR_"^"_SDSStatusDesc_"^"_DiagTypeId_"^"_DiagStatusId_"^"_UserName
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-09-10
/// Description:诊断列表排序，设置临时global
/// Table：User.SDSDiagnos
/// Input：PatientID
/// Other: d ##class(web.DHCBL.MKB.SDSDiagnos).GetColumnList(5,1)
ClassMethod GetColumnList(PatientID, mradm) As %String
{
  k ^TMPSDSDIAGNOS($zn,$j,"ColumnList",PatientID)
  k ^TMPSDSDIAGNOS($zn,$j,"ColumnSeqList",PatientID)
  s SDSRowId=""
  for {
		  s SDSRowId=$o(^User.SDSDiagnosI("PMIIndex",PatientID,SDSRowId)) q:SDSRowId=""
		  ;原诊断标记信息
		  s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
		  s SDSTag=..GetTagText(SDSTagDR)
		  
		  ;非本次就诊清除当前诊断
		  if ($d(^User.SDSDiagnosLogI("RefIndex",SDSRowId))){
			  s subLog=$o(^User.SDSDiagnosLogI("RefIndex",SDSRowId,""),-1) //最后一条日志
			  s SDSAdmDR=$LISTGET($G(^User.SDSDiagnosLogD(subLog)),9) //日志就诊信息
			  if (SDSAdmDR'=mradm){
			  	if (SDSTag["当前诊断"){
				  	s newTagDR=..GetSubTag(SDSTagDR,"当前诊断")
					s $LIST(^User.SDSDiagnosD(SDSRowId),11)=newTagDR
				}
			  }
		  }
		  ;新诊断标记信息
		  s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
		  s SDSTag=..GetTagText(SDSTagDR)
		  
		  ;continue:(SDSTag["封闭") 
		  if (SDSTag["重要诊断"){
			  s SDSTagFlag="重要诊断"
		  }elseif (SDSTag["主要诊断"){
			  s SDSTagFlag="主要诊断"
		  }elseif (SDSTag["当前诊断"){
			  s SDSTagFlag="当前诊断"	
		  }elseif (SDSTag["长效"){
			  s SDSTagFlag="长效诊断"	
		  }else{
			  s SDSTagFlag="其他诊断"	
		  }
		  s SDSSequence=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),9)
		  if (SDSSequence=""){
			  s SDSSequence="0"
		  }
		  s ^TMPSDSDIAGNOS($zn,$j,"ColumnSeqList",PatientID,SDSTagFlag,SDSSequence,SDSRowId)=""  
		  s ^TMPSDSDIAGNOS($zn,$j,"ColumnList",PatientID,SDSTagFlag,SDSRowId)=""  
	}
	q 1
}

/// Creator：高姗姗
/// CreatDate: 2019-10-24
/// Description：查询知识库术语诊断类型，根据标识获取，诊断类型标识需配置到当前医院的诊断类型术语集
/// Table：User.MKBTerm
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnos","GetTypeForCmb1","","MR","","")
Query GetTypeForCmb1(rowid As %String, type As %String, scene As %String, desc As %String) As %Query(ROWSPEC = "MKBTRowId:%String,MKBTDesc:%String")
{
}

ClassMethod GetTypeForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, type As %String, scene As %String, desc As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  	s MKBTRowId=rowid
  	s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
  	s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
  	d OutputRowCmbType
 }
 else
 {
	s base=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiaType")
 	if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
	{
		s TypeSourse=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSTypeDataSourse")
		s TypeLen=$Length(TypeSourse,",")
		for i=1:1:TypeLen{
			s MKBTRowId=$p(TypeSourse,",",i)
			continue:MKBTRowId=""
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			if (type="MR"){ //医生站引用下
				if ((scene'="")&&(scene'="I")){ //出院诊断,入院诊断只用于住院患者.
					continue:((MKBTDesc="出院诊断")||(MKBTDesc="入院诊断"))	
				}
				if ((scene'="")&&(scene="I")){  //门诊诊断只用于门诊患者.
					continue:(MKBTDesc="门诊诊断")
				}
			}
			s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
			s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
			s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
			s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")	
			i ((MKBTDescU[desc)||(MKBTPYCodeU[desc))  //条件
			{
				d OutputRowCmbType
			}
		}
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmbType
    set Data=$lb(MKBTRowId,MKBTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTypeForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetTypeForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2019-10-24
/// Description：查询知识库术语诊断类型，根据标识获取，诊断类型标识需配置到当前医院的诊断类型术语集
/// Table：User.MKBTerm
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnos","GetStatusForCmb1","","")
Query GetStatusForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBTRowId:%String,MKBTDesc:%String")
{
}

ClassMethod GetStatusForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  	s MKBTRowId=rowid
  	s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
  	s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
  	d OutputRowCmbStatus
 }
 else
 {
	s base=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiaState")
	
 	if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
	{
		s StatusSourse=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSStateDataSourse")
		s StatusLen=$Length(StatusSourse,",")
		for i=1:1:StatusLen
		{
			s MKBTRowId=$p(StatusSourse,",",i)
			continue:MKBTRowId=""
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
			s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
			s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
			s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")	
			i ((MKBTDescU[desc)||(MKBTPYCodeU[desc))  //条件
			{
				d OutputRowCmbStatus
			}
		}
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmbStatus
    set Data=$lb(MKBTRowId,MKBTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetStatusForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatusForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetStatusForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatusForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2019-09-17
/// Description：诊断重复验证方法
/// Input：id, value
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.MKB.SDSDiagnos).ValidateDiagnos("1","","14679")
ClassMethod ValidateDiagnos(PatientID As %String, id As %String, TermDR As %String) As %String
{
	s:id="undefined" id=""
	s rowid="",name="",date=""
	s flag=0
	s flagT=$d(^User.SDSDiagnosI("PMITermIndex",PatientID,TermDR))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagT>0)){
			s flag=1  //返回重复标志
			s rowid=$o(^User.SDSDiagnosI("PMITermIndex",PatientID,TermDR,""),-1)
			s name=..GetDiagName(rowid)
			s SDSOpenDate=$LISTGET($G(^User.SDSDiagnosD(rowid)),8)
			s:SDSOpenDate'="" date = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(SDSOpenDate)
		}
		else { 
			s flag=0 //返回不重复标志
		}
	}
	/*else //如果不为空，修改时的重复判断
	{
		//修改时，结构化诊断不允许修改，无需判断重复
  		s idT=$o(^User.SDSDiagnosI("PMITermIndex",PatientID,TermDR,0))
  		if ((idT'="")&(idT'=id)&(flagT>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
  		s flag=0
		
	}*/
	q flag_"^"_rowid_"^"_name_"^"_date
}

/// Creator：高姗姗
/// CreatDate: 2019-09-27
/// Description：测试保存方法
/// w ##class(web.DHCBL.MKB.SDSDiagnos).TestSave()
ClassMethod TestSave() As %String
{
	s eobj=##class(web.Entity.MKB.SDSDiagnos).%New()
	s eobj.SDSRowId=""
	s eobj.SDSIcdCode="H26.900"
	s eobj.SDSIcdDesc="白内障"
	s eobj.SDSMainDiagFlag="N"
	s eobj.SDSOpenDate="2019-11-14"
	s eobj.SDSOnsetDate="2019-11-14"
	s eobj.SDSLevel="1"
	s eobj.SDSTermDR="14818"
	s eobj.SDSValue=""
	s eobj.SDSSupplement=""
	s eobj.SDSWordDR="29833"
	s eobj.SDSSequence="1"
	s eobj.SDSTagDR="65662,65674"
	s eobj.SDSPMIDR="140"
	s eobj.SDSAdmDR="1"
	s res=..SaveEntity(eobj)
	q res
}

/// Creator：高姗姗
/// CreatDate: 2019-07-23
/// Description：保存诊断内容
/// Table：User.SDSDiagnos
/// Input：web.Entity.MKB.SDSDiagnos 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.MKB.SDSDiagnos) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		s:eobj.SDSSequence="" eobj.SDSSequence=..GetLastSequence(eobj.SDSPMIDR)+1
		s SDSTag=..GetTagText(eobj.SDSTagDR)
		if ((SDSTag["重要诊断")||(SDSTag["主要诊断")||(SDSTag["长效")){
			if (SDSTag'["当前诊断"){
				s eobj.SDSTagDR=eobj.SDSTagDR_","_..GetTermIdByDesc("当前诊断")
			}
		}
		//设置主诊断时清除原主诊断
		if (eobj.SDSMainDiagFlag="Y"){
			s id=""
			for {
				s id=$o(^User.SDSDiagnosI("PMIMainIndex",eobj.SDSPMIDR,"Y",id))
				q:id=""
				s objOld=##class(User.SDSDiagnos).%OpenId(id)
				s objOld.SDSMainDiagFlag="N"
				s scOld=objOld.%Save()
				d objOld.%Close()	 	
			}
		}
		//设置主要诊断时，清除原主要诊断
		if (SDSTag["主要诊断"){
			d ..RemoveTag(eobj.SDSPMIDR,"主要诊断")
		}	
		
		s eobj.SDSOpenDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SDSOpenDate) 
		s eobj.SDSOnsetDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.SDSOnsetDate) 
		
		if (eobj.SDSRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.SDSDiagnos).%New()
			
			s SDSTagAdd=..GetTagText(eobj.SDSTagDR)
			;新增诊断时，开立日期为当天自动标记当前诊断；开立日期非当天自动标记整理
			if ((SDSTagAdd'["当前诊断")&&(eobj.SDSOpenDate=+$H)){
				s:eobj.SDSTagDR'="" eobj.SDSTagDR=eobj.SDSTagDR_","_..GetTermIdByDesc("当前诊断")
				s:eobj.SDSTagDR="" eobj.SDSTagDR=..GetTermIdByDesc("当前诊断")
			}
			if ((SDSTagAdd'["整理")&&(eobj.SDSOpenDate'=+$H)){
				s:eobj.SDSTagDR'="" eobj.SDSTagDR=eobj.SDSTagDR_","_..GetTermIdByDesc("整理")
				s:eobj.SDSTagDR="" eobj.SDSTagDR=..GetTermIdByDesc("整理")
			}
		}else{
			s obj=##class(User.SDSDiagnos).%OpenId(eobj.SDSRowId)
			s bobj=##class(web.Entity.MKB.SDSDiagnos).%New()
			s bobj.SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(eobj.SDSRowId),"-",2)	
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
		}
		
		d:eobj.SDSTermDR'="" obj.SDSTermDRSetObjectId(eobj.SDSTermDR)
		d:eobj.SDSTermDR="" obj.SDSTermDRSetObjectId("")
		s obj.SDSWordDR=eobj.SDSWordDR
		d:eobj.SDSPMIDR'="" obj.SDSPMIDRSetObjectId(eobj.SDSPMIDR)
		d:eobj.SDSPMIDR="" obj.SDSPMIDRSetObjectId("")
		s eobj.SDSSupplement=##class(web.DHCBL.BDP.FunLib).Util(eobj.SDSSupplement)
		s obj.SDSSupplement=eobj.SDSSupplement
		s obj.SDSOpenDate=eobj.SDSOpenDate
		s obj.SDSIcdCode=eobj.SDSIcdCode
		s obj.SDSIcdDesc=eobj.SDSIcdDesc
		s obj.SDSSequence=eobj.SDSSequence
		s obj.SDSMainDiagFlag=eobj.SDSMainDiagFlag
		s obj.SDSTagDR=eobj.SDSTagDR
		s obj.SDSLevel=eobj.SDSLevel
		s obj.SDSOnsetDate=eobj.SDSOnsetDate
		d:eobj.SDSTypeDR'="" obj.SDSTypeDRSetObjectId(eobj.SDSTypeDR)
		d:eobj.SDSTypeDR="" obj.SDSTypeDRSetObjectId("")
		d:eobj.SDSStatusDR'="" obj.SDSStatusDRSetObjectId(eobj.SDSStatusDR)
		d:eobj.SDSStatusDR="" obj.SDSStatusDRSetObjectId("")

		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			s id = obj.%Id()
			//设置主诊断时自动标记主要诊断
			if (eobj.SDSMainDiagFlag="Y"){
				if ('$d(^TMPSDSDIAGNOS($zn,$j,"ColumnList",eobj.SDSPMIDR,"主要诊断",id))){
					s mainDiagTagDr=..GetTermIdByDesc("主要诊断")
					d ..SaveTag(id,eobj.SDSPMIDR,eobj.SDSAdmDR,mainDiagTagDr)
				}
			}
			
			//设置主要诊断时自动修改主诊断
			if (SDSTag["主要诊断"){
				if ('$d(^User.SDSDiagnosI("PMIMainIndex",eobj.SDSPMIDR,"Y",id))){
					d ..SaveMainDiagFlag(id,eobj.SDSPMIDR,eobj.SDSAdmDR,"Y")
				}
			}
			
			//维护子表属性
			s resultChild=##class(web.DHCBL.MKB.SDSDiagnosProperty).SaveData(id,eobj.SDSValue)

			//新增维护引用表
			if (eobj.SDSRowId=""){
				s:eobj.SDSTermDR'="" resultRefTerm=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"T",eobj.SDSTermDR)
				s version=..GetWordVersion()
				if (version["ICD"){ //取自各版本icd对照
					s:eobj.SDSWordDR'="" resultRefWord=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"ICDX",eobj.SDSWordDR)
				}else{ //取自数据处理工厂
					s:eobj.SDSWordDR'="" resultRefWord=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"SD",eobj.SDSWordDR)
				}
				s:eobj.SDSTypeDR'="" resultRefType=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"T",eobj.SDSTypeDR)
				s:eobj.SDSStatusDR'="" resultRefStatus=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"T",eobj.SDSStatusDR)
			}else{ //诊断类型、诊断状态修改维护引用表
				//s refTypeId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("SDS",id,"T",bobj.SDSTypeDR)
				//s resultRefType=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refTypeId, "SDS",id,"T",eobj.SDSTypeDR)
				//s refStatusId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("SDS",id,"T",bobj.SDSStatusDR)
				//s resultRefStatus=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refStatusId, "SDS",id,"T",eobj.SDSStatusDR)
			}
			//维护子表日志
			if (eobj.SDSRowId="") {
				s newValue="{""SDSTermDR"":"""_eobj.SDSTermDR_""",""SDSValue"":"""_eobj.SDSValue_""",""SDSSupplement"":"""_eobj.SDSSupplement_""",""SDSWordDR"":"""_eobj.SDSWordDR_""",""SDSIcdCode"":"""_eobj.SDSIcdCode_""",""SDSIcdDesc"":"""_eobj.SDSIcdDesc_""",""SDSMainDiagFlag"":"""_eobj.SDSMainDiagFlag_""",""SDSTagDR"":"""_eobj.SDSTagDR_"""}"
				d:eobj.SDSAdmDR'="" ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(id,"A","",newValue,eobj.SDSAdmDR) 
			}else{
				s logSub=$o(^User.SDSDiagnosLogI("RefIndex",id,""),-1)
				s:logSub'="" SDSUpdateUserDR=$LISTGET($G(^User.SDSDiagnosLogD(logSub)),2)
				s:logSub="" SDSUpdateUserDR=""
				
				//属性有变;操作人有变
				if ((eobj.SDSValue'=bobj.SDSValue)||(($Get(%session.Data("LOGON.USERID"))'=SDSUpdateUserDR)&&(SDSUpdateUserDR'=""))){
					//清除整理标记
		  			if (SDSTag["整理"){
			  			s eobj.SDSTagDR=..GetSubTag(eobj.SDSTagDR,"整理")
						s $LIST(^User.SDSDiagnosD(id),11)=eobj.SDSTagDR
			  		}

					s oldValue="{""SDSTermDR"":"""_bobj.SDSTermDR_""",""SDSValue"":"""_bobj.SDSValue_""",""SDSSupplement"":"""_bobj.SDSSupplement_""",""SDSWordDR"":"""_bobj.SDSWordDR_""",""SDSIcdCode"":"""_bobj.SDSIcdCode_""",""SDSIcdDesc"":"""_bobj.SDSIcdDesc_""",""SDSMainDiagFlag"":"""_bobj.SDSMainDiagFlag_""",""SDSTagDR"":"""_bobj.SDSTagDR_"""}"
					s newValue="{""SDSTermDR"":"""_eobj.SDSTermDR_""",""SDSValue"":"""_eobj.SDSValue_""",""SDSSupplement"":"""_eobj.SDSSupplement_""",""SDSWordDR"":"""_eobj.SDSWordDR_""",""SDSIcdCode"":"""_eobj.SDSIcdCode_""",""SDSIcdDesc"":"""_eobj.SDSIcdDesc_""",""SDSMainDiagFlag"":"""_eobj.SDSMainDiagFlag_""",""SDSTagDR"":"""_eobj.SDSTagDR_"""}"
					d ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(id,"U",oldValue,newValue,eobj.SDSAdmDR) //子表日志
				}
			}
			
			Tc
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			/*s LogDepRowid=$Get(%session.Data("LOGON.CTLOCID")) //登录科室
			s MRAdmNo=$LISTGET($G(^User.SDSAdmD(eobj.SDSADMDR)),2) //就诊号
			s ICDCode=eobj.SDSIcdCode //ICD代码
			s UserRowid=$Get(%session.Data("LOGON.USERID")) //登录用户
			if (##class(web.DHCBL.MKB.SDSDiagnosInterface).GetICDRowId(ICDCode)'=""){
				s MRDIADesc=eobj.SDSSupplement
			}else{
				s MRDIADesc=..GetDiagName(id)
			}

			if (eobj.SDSRowId="") {
				s scDiagnos=##class(web.DHCBL.MKB.SDSDiagnosInterface).InsertDiagnos(LogDepRowid,MRAdmNo,ICDCode,UserRowid,MRDIADesc_"#1",eobj.SDSMainDiagFlag) //标版
				if ($p(scDiagnos,"^",1)=0){ //标版
					s MRDiagnosRowid=$p(scDiagnos,"^",2) //标版
					//保存到关联表
					s scLink=##class(web.DHCBL.MKB.SDSDiagnosLink).SaveLink(MRDiagnosRowid,id)
					if (scLink["true"){
						Tc
						;d ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(id,"A","",eobj.SDSValue) //子表日志
						s result = "{success:'true',id:'"_id_"',MRDiagRowId:'"_MRDiagnosRowid_"',ICDCode:'"_ICDCode_"'}" //返回RowId
					}else{
						Trollback
						s result = "{success:'false',errorinfo:'关联表保存失败'}"   //返回错误信息
					}
				}else{
					Trollback
					s result = "{success:'false',errorinfo:'医生站端诊断同步失败'}"   //返回错误信息
				}
				
			}else{ //同步医生站修改主诊断
				s linkrowid=$o(^User.SDSDiagnosLinkI("StructIndex",eobj.SDSRowId,0)) //关联表id
				s MRDiagnosRowid=$LISTGET($G(^User.SDSDiagnosLinkD(linkrowid)),2) //医生站端诊断的id
				s scDiagnos=##class(web.DHCBL.MKB.SDSDiagnosInterface).UpdateDiagnos(MRDiagnosRowid,UserRowid,eobj.SDSMainDiagFlag)
				Tc
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
			}*/
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}	
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-10-25
/// Description:诊断类型实时保存
/// Table：User.SDSDiagnos
/// Input：rowid, typedr
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).SaveDiagType("161","Y")
ClassMethod SaveDiagType(rowid, typedr) As %String
{

	s obj=##class(User.SDSDiagnos).%OpenId(rowid)
	
	s bobj=##class(web.Entity.MKB.SDSDiagnos).%New()
	s:obj.SDSTypeDR'="" bobj.SDSTypeDR=obj.SDSTypeDR.%Id()
	s:obj.SDSTypeDR="" bobj.SDSTypeDR=""
	
	d:typedr'="" obj.SDSTypeDRSetObjectId(typedr)
	d:typedr="" obj.SDSTypeDRSetObjectId("")
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		s id = obj.%Id()
		
		if (bobj.SDSTypeDR=""){
			if (typedr'=""){ //从无到有，增加到引用表
				s resultRefType=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"T",typedr)
			}	
		}else{ //修改引用表
			s refTypeId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("SDS",id,"T",bobj.SDSTypeDR)
			s resultRefType=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refTypeId, "SDS",id,"T",typedr)
		}
		
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-10-25
/// Description:诊断类型实时保存
/// Table：User.SDSDiagnos
/// Input：rowid, typedr
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).SaveDiagStatus("161","Y")
ClassMethod SaveDiagStatus(rowid, statusdr) As %String
{
	s obj=##class(User.SDSDiagnos).%OpenId(rowid)

	s bobj=##class(web.Entity.MKB.SDSDiagnos).%New()
	s:obj.SDSStatusDR'="" bobj.SDSStatusDR=obj.SDSStatusDR.%Id()
	s:obj.SDSStatusDR="" bobj.SDSStatusDR=""
	
	d:statusdr'="" obj.SDSStatusDRSetObjectId(statusdr)
	d:statusdr="" obj.SDSStatusDRSetObjectId("")
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		s id = obj.%Id()
		
		if (bobj.SDSStatusDR=""){
			if (statusdr'=""){ //从无到有，增加到引用表
				s resultRefStatus=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDS",id,"T",statusdr)
			}	
		}else{ //修改引用表
			s refStatusId=##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("SDS",id,"T",bobj.SDSStatusDR)
			s resultRefStatus=##class(web.DHCBL.MKB.MKBReference).SaveDataById(refStatusId, "SDS",id,"T",statusdr)
		}
	
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-09-02
/// Description:主诊断实时保存
/// Table：User.SDSDiagnos
/// Input：
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).SaveMainDiagFlag("161","Y")
ClassMethod SaveMainDiagFlag(rowid, PatientID, mradm, mainDiagFlag) As %String
{
	//设置主诊断时，清除原主诊断
	if (mainDiagFlag="Y"){
		s id=""
		for {
			s id=$o(^User.SDSDiagnosI("PMIMainIndex",PatientID,"Y",id))
			q:id=""
			s objOld=##class(User.SDSDiagnos).%OpenId(id)
			s objOld.SDSMainDiagFlag="N"
			s scOld=objOld.%Save()
			d objOld.%Close()	 	
		}
	}
	
	s obj=##class(User.SDSDiagnos).%OpenId(rowid)
	s obj.SDSMainDiagFlag=mainDiagFlag
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		s id = obj.%Id()
		
		//设置主诊断时自动标记主要诊断
		if ('$d(^TMPSDSDIAGNOS($zn,$j,"ColumnList",PatientID,"主要诊断",id))){
			s mainDiagTagDr=..GetTermIdByDesc("主要诊断")
			d ..SaveTag(id,PatientID,mradm,mainDiagTagDr)
		}
		
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-09-06
/// Description:诊断标记保存方法
/// Table：User.SDSDiagnos
/// Input：
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).SaveTag("49","1","65674,65662")
ClassMethod SaveTag(rowid, PatientID, mradm, SDSTagDR) As %String
{
	s SDSTag=..GetTagText(SDSTagDR)
	
	//设置主要诊断时，清除原主要诊断
	if (SDSTag["主要诊断"){
		d ..RemoveTag(PatientID,"主要诊断")
	}
	
	if ((SDSTag["重要诊断")||(SDSTag["主要诊断")||(SDSTag["长效")){
		if (SDSTag'["当前诊断"){
			s SDSTagDR=SDSTagDR_","_..GetTermIdByDesc("当前诊断")
		}
	}
	
	s obj=##class(User.SDSDiagnos).%OpenId(rowid)
	s bobj=##class(web.Entity.MKB.SDSDiagnos).%New()
	s bobj.SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(rowid),"-",2) 	
	s:obj.SDSTermDR'="" bobj.SDSTermDR=obj.SDSTermDR.%Id() 
	s:obj.SDSTermDR="" bobj.SDSTermDR=""
	s bobj.SDSSupplement=obj.SDSSupplement 
	s bobj.SDSIcdCode=obj.SDSIcdCode
	s bobj.SDSIcdDesc=obj.SDSIcdDesc
	s bobj.SDSWordDR=obj.SDSWordDR 
	s bobj.SDSMainDiagFlag=obj.SDSMainDiagFlag
	s bobj.SDSTagDR=obj.SDSTagDR 
			
	s obj.SDSTagDR=SDSTagDR
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		s id = obj.%Id()
		//设置主要诊断时自动修改主诊断
		if ('$d(^User.SDSDiagnosI("PMIMainIndex",PatientID,"Y",id))){
			if (SDSTag["主要诊断"){
				d ..SaveMainDiagFlag(id,PatientID,mradm,"Y")
			}
		}
		
		//诊断标记有变
		if (SDSTagDR'=bobj.SDSTagDR){
			
			//清除整理标记
  			if (SDSTag["整理"){
	  			s SDSTagDR=..GetSubTag(SDSTagDR,"整理")
				s $LIST(^User.SDSDiagnosD(id),11)=SDSTagDR
	  		}

			s oldValue="{""SDSTermDR"":"""_bobj.SDSTermDR_""",""SDSValue"":"""_bobj.SDSValue_""",""SDSSupplement"":"""_bobj.SDSSupplement_""",""SDSWordDR"":"""_bobj.SDSWordDR_""",""SDSIcdCode"":"""_bobj.SDSIcdCode_""",""SDSIcdDesc"":"""_bobj.SDSIcdDesc_""",""SDSMainDiagFlag"":"""_bobj.SDSMainDiagFlag_""",""SDSTagDR"":"""_bobj.SDSTagDR_"""}"
			s newValue="{""SDSTermDR"":"""_bobj.SDSTermDR_""",""SDSValue"":"""_bobj.SDSValue_""",""SDSSupplement"":"""_bobj.SDSSupplement_""",""SDSWordDR"":"""_bobj.SDSWordDR_""",""SDSIcdCode"":"""_bobj.SDSIcdCode_""",""SDSIcdDesc"":"""_bobj.SDSIcdDesc_""",""SDSMainDiagFlag"":"""_bobj.SDSMainDiagFlag_""",""SDSTagDR"":"""_SDSTagDR_"""}"
			d ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(id,"U",oldValue,newValue,mradm) //子表日志
		}
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-10-10
/// Description:获取移除某个标记后的标记值
/// Table：User.SDSDiagnos
/// Input：SDSTagDR，标记描述
/// Other: d ##class(web.DHCBL.MKB.SDSDiagnos).GetSubTag("","")
ClassMethod GetSubTag(SDSTagDR, text) As %String
{
	s newTagDR=""
  	s len=$Length(SDSTagDR,",")
	for i=1:1:len{
		s tagid=$p(SDSTagDR,",",i)
		continue:(tagid=..GetTermIdByDesc(text))
		if (newTagDR=""){
			s newTagDR=tagid	
		}else{
			s newTagDR=newTagDR_","_tagid
		}
	}
	q newTagDR
}

/// Creator：高姗姗
/// CreatDate: 2019-09-11
/// Description:去除当前病人的主要诊断标记（移除标记）
/// Table：User.SDSDiagnos
/// Input：PatientID，tag
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).RemoveTag("1","主要诊断")
ClassMethod RemoveTag(PatientID As %String, tag As %String) As %String
{
  	 s result=""
  	 if ($d(^TMPSDSDIAGNOS($zn,$j,"ColumnList",PatientID,tag))){
		  s termid=..GetTermIdByDesc(tag)
		  s SDSRowId=""
		  for{  
		  	  s SDSRowId=$o(^TMPSDSDIAGNOS($zn,$j,"ColumnList",PatientID,tag,SDSRowId))
			  q:SDSRowId=""  
			  s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
			  s TagDR=""
			  s tagLen=$Length(SDSTagDR,",")
			  for i=1:1:tagLen{
			  	  s tagid=$p(SDSTagDR,",",i)
			  	  continue:tagid=termid
			  	  if (TagDR=""){
				  	  s TagDR=tagid
				  }else{
					  s TagDR=TagDR_","_tagid
				  }
			  }
	  		  s obj=##class(User.SDSDiagnos).%OpenId(SDSRowId)
	  		  s obj.SDSTagDR=TagDR
	  		  s sc=obj.%Save()
			  d obj.%Close()
			  IF $$$ISOK(sc) {
			   s result=result_"^1"
			  }
			  else 
			  {
			     s result=result_"^0"
			  }
		  }
		 
		  IF (result["0") {
			 s result= "{success:'false',info:'修改失败'}" 
		  }
		  else 
		  {
		     s result="{success:'true',info:'修改成功！'}"
		  }
  	 }
 	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-10-18
/// Description:诊断日期保存方法
/// Table：User.SDSDiagnos
/// Input：
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).SaveDate("49","1","65674,65662")
ClassMethod SaveDate(rowid, OnsetDate) As %String
{
	s OnsetDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(OnsetDate) 
	s obj=##class(User.SDSDiagnos).%OpenId(rowid)
	s obj.SDSOnsetDate=OnsetDate
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2019-10-18
/// Description：保存移动的级别
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).SaveLevel("","")
ClassMethod SaveLevel(rowid, direction) As %String
{
	s result=""
	s obj=##class(User.SDSDiagnos).%OpenId(rowid)
	s bLevel=obj.SDSLevel
	if (bLevel'=""){
		if (direction="left"){
			if (bLevel>1){
				s obj.SDSLevel=bLevel-1
			}
		}else{
			s obj.SDSLevel=bLevel+1
		}
	}
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s id=obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}
	else
	{
		s result = "{success:'false'}"  //返回错误信息
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-09-03
/// Description:引用诊断方法(弃用)
/// Table：User.SDSDiagnos
/// Input：diagIdStr
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).SaveRefData("5","1","1")
ClassMethod SaveRefData(diagIdStr, PatientID, mradm) As %String
{
	s result=""
	s return=""
	s LogDepRowid=$Get(%session.Data("LOGON.CTLOCID")) //登录科室
	s UserRowid=$Get(%session.Data("LOGON.USERID")) //登录用户
	s MRAdmNo=$LISTGET($G(^User.SDSAdmD(mradm)),2) //就诊号  
	s diagIdLen=$Length(diagIdStr,"^")
	Ts
	for i=1:1:diagIdLen{
		s SDSRowId=$p(diagIdStr,"^",i)
		s SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(SDSRowId),"-",2)	
		
		s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),2)
		s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),4)
		s ICDCode=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),5) //ICD代码
		s ICDDesc=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),6) //ICD描述
		s SDSWordDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),7)
		s SDSMainDiagFlag=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),10)
		s SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
		
		s ICDRowId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetICDRowId(ICDCode)
		/*if (ICDRowId'=""){
			s MRDIADesc=SDSSupplement
		}else{
			s MRDIADesc=..GetDiagName(SDSRowId)
		}*/
		s MRDIADesc=..GetDiagName(SDSRowId)

		s scDiagnos=##class(web.DHCBL.MKB.SDSDiagnosInterface).InsertDiagnos(LogDepRowid,MRAdmNo,ICDCode,UserRowid,MRDIADesc_"#1",SDSMainDiagFlag) //标版
		if ($p(scDiagnos,"^",1)=0){ //标版
			s MRDiagRowId=$p(scDiagnos,"^",2) //标版
			//保存到关联表
			s scLink=##class(web.DHCBL.MKB.SDSDiagnosLink).SaveLink(MRDiagRowId,SDSRowId,mradm)
			if (scLink["true"){
				
				s SDSTag=..GetTagText(SDSTagDR)
				//清除整理标记
	  			if (SDSTag["整理"){
		  			s SDSTagDR=..GetSubTag(SDSTagDR,"整理")
					s $LIST(^User.SDSDiagnosD(SDSRowId),11)=SDSTagDR
		  		}
				//标记当前诊断
				if (SDSTag'["当前诊断"){
					if (SDSTagDR=""){
						s SDSTagDR=..GetTermIdByDesc("当前诊断")
					}else{
						s SDSTagDR=SDSTagDR_","_..GetTermIdByDesc("当前诊断")
					}
					d ..SaveTag(SDSRowId, PatientID, mradm, SDSTagDR)
				}
				
				//维护子表日志：引用
				s newValue="{""SDSTermDR"":"""_SDSTermDR_""",""SDSValue"":"""_SDSValue_""",""SDSSupplement"":"""_SDSSupplement_""",""SDSWordDR"":"""_SDSWordDR_""",""SDSIcdCode"":"""_ICDCode_""",""SDSIcdDesc"":"""_ICDDesc_""",""SDSMainDiagFlag"":"""_SDSMainDiagFlag_""",""SDSTagDR"":"""_SDSTagDR_"""}"
				d ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(SDSRowId,"R","",newValue,mradm) 
				
				s resSave = "{success:'true',id:'"_SDSRowId_"'}" //返回RowId
			}else{
				s resSave = "{success:'false',errorinfo:'关联表保存失败'}"   //返回错误信息
			}
		}else{
			s resSave = "{success:'false',errorinfo:'医生站端诊断同步失败'}"   //返回错误信息
		}
		
		if (resSave["false"){
			Trollback
			s result=result_"^false"
		}else{
			s result=result_"^true"
			if (return=""){
				s return=MRDiagRowId_$c(1)_ICDRowId
			}else{
				s return=return_"^"_MRDiagRowId_$c(1)_ICDRowId	
			}
		}
	}
	
	if (result["false"){
		s result="{success:'false',info:'保存失败！'}"
	}else{
		Tc
		s result="{success:'true',info:'"_return_"'}"
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-07-17
/// Description:删除方法
/// Table：User.SDSDiagnos
/// Input：RowId
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).DeleteData("10","")
ClassMethod DeleteData(id, mradm) As %String
{
  	s result=""

	Ts	
	s obj=##class(User.SDSDiagnos).%OpenId(id)
	s bobj=##class(web.Entity.MKB.SDSDiagnos).%New()
	s bobj.SDSValue=$p(##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr(id),"-",2)	
	s:obj.SDSTermDR'="" bobj.SDSTermDR=obj.SDSTermDR.%Id()
	s:obj.SDSTermDR="" bobj.SDSTermDR=""
	s bobj.SDSSupplement=obj.SDSSupplement
	s bobj.SDSIcdCode=obj.SDSIcdCode
	s bobj.SDSIcdDesc=obj.SDSIcdDesc
	s bobj.SDSWordDR=obj.SDSWordDR
	s bobj.SDSMainDiagFlag=obj.SDSMainDiagFlag
	s bobj.SDSTagDR=obj.SDSTagDR  
	;增加删除日志
	s oldValue="{""SDSTermDR"":"""_bobj.SDSTermDR_""",""SDSValue"":"""_bobj.SDSValue_""",""SDSSupplement"":"""_bobj.SDSSupplement_""",""SDSWordDR"":"""_bobj.SDSWordDR_""",""SDSIcdCode"":"""_bobj.SDSIcdCode_""",""SDSIcdDesc"":"""_bobj.SDSIcdDesc_""",""SDSMainDiagFlag"":"""_bobj.SDSMainDiagFlag_""",""SDSTagDR"":"""_bobj.SDSTagDR_"""}"			
	s resLog = ##class(web.DHCBL.MKB.SDSDiagnosLog).SaveLog(id,"D",oldValue,"",mradm) //子表日志
	;s resLog=##class(web.DHCBL.MKB.SDSDiagnosDelLog).SaveData(id)
	
	s childIds="" //子表id串
	s sub=""
	for {
		s sub=$o(^User.SDSDiagnosD(id,"ChildProperty",sub)) q:sub=""
		if (childIds=""){
			s childIds=id_"||"_sub
		}else{
			s childIds=childIds_"^"_id_"||"_sub
		}
	}
	  
	s sc=##class(User.SDSDiagnos).%DeleteId(id)
	IF $$$ISOK(sc) {
		 //删除引用表
		if (childIds'=""){
			s childLen=$Length(childIds,"^")
			for i=1:1:childLen{
				s childId=$p(childIds,"^",i)
				s resultDelChildRef=##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SDSP",childId)
			}
		}
		s resultDelRef = ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SDS",id)
		  
		//删除关联表
		if $d(^User.SDSDiagnosLinkI("StructIndex",id)){
			s resultDelLink=""
			s linkrowid=""
			for {
			  	s linkrowid=$o(^User.SDSDiagnosLinkI("StructIndex",id,linkrowid)) q:linkrowid=""
			  	s sclink=##class(User.SDSDiagnosLink).%DeleteId(linkrowid)
			  	if $$$ISOK(sclink)
				{
					s resultDelLink=resultDelLink_"^true"	
				}
				else
				{
					s resultDelLink=resultDelLink_"^false"	
				}
			}
			if (resultDelLink["false"){
				Trollback
				s result= "{success:'false',info:'关联表删除失败'}"  //返回错误信息
			} 
			else{
				Tc
				s result="{success:'true',info:'删除成功！'}"
			}
		}else{
			Tc
	  		s result="{success:'true',info:'删除成功！'}"
		}
	}
	else 
	{
	   s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	}
 	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-07-17
/// Description:多选删除方法
/// Table：User.SDSDiagnos
/// Input：diagIdStr
/// Return:成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).DeleteAll("11")
ClassMethod DeleteAll(diagIdStr, mradm) As %String
{
	s result=""
	s diagLen=$Length(diagIdStr,"^")
	for i=1:1:diagLen{
		s diagId=$p(diagIdStr,"^",i)
		s ret=..DeleteData(diagId,mradm)
		if (ret["false"){
			s result=result_"^false"
		}else{
			s result=result_"^true"
		}
	}
	if (result["false"){
		s result="{success:'false',info:'删除失败！'}"
	}else{
		s result="{success:'true',info:'删除成功！'}"
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-07-16
/// Description:根据诊断及子表id获取展示名
/// Table：User.SDSDiagnos
/// Input：结构化诊断id
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetDiagName("5")
ClassMethod GetDiagName(parref As %String) As %String
{
	
	s result=""
	//生成属性(含起始节点)及属性内容的临时global
	k ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChildNode",parref)
	s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(parref)),2) //术语id
	q:SDSTermDR="" ""
	d ..GetPropertyByNode(SDSTermDR)
	s rowid=""
	for { 
	 	s rowid=$o(^User.SDSDiagnosD(parref,"ChildProperty",rowid)) q:rowid=""
	 	s SDSPropertyDR=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",rowid)),2)
	 	continue:'$d(^User.MKBTermPropertyD(SDSPropertyDR))
	 	s SDSProDetail=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",rowid)),3)
	 	s SDSFlag=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",rowid)),4)
	 	if (SDSFlag="D"){
		 	continue:'$d(^User.MKBTermProDetailD(SDSProDetail))
		}else{
			continue:'$d(^User.MKBTermD(SDSProDetail))
		}
		s DetailNode=..GetDetailNode(SDSTermDR,SDSProDetail)
		s:DetailNode'="" DetailTitleNode=$LISTGET($G(^User.MKBTermProDetailD(DetailNode)),4)  //诊断模板定义的起始节点
		s:DetailNode="" DetailTitleNode=""
		if (DetailTitleNode'=""){
			continue:'$d(^TEMPPROPERTYNODE($zn,$j,"Sequence",SDSTermDR,DetailTitleNode))
			s seq=$g(^TEMPPROPERTYNODE($zn,$j,"Sequence",SDSTermDR,DetailTitleNode))
			s ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChildNode",parref,seq,rowid,SDSFlag,DetailTitleNode,SDSProDetail)=""
		}else{
			continue:'$d(^TEMPPROPERTYNODE($zn,$j,"Sequence",SDSTermDR,SDSPropertyDR))
			s seq=$g(^TEMPPROPERTYNODE($zn,$j,"Sequence",SDSTermDR,SDSPropertyDR))
			s ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChildNode",parref,seq,rowid,SDSFlag,SDSPropertyDR,SDSProDetail)=""
		}
	}
	s seq=""
	for{
		s seq=$o(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChildNode",parref,seq)) q:seq=""
		s rowid=""
		for{
			s rowid=$o(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChildNode",parref,seq,rowid)) q:rowid=""
			s flag=""
			for {
				s flag=$o(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChildNode",parref,seq,rowid,flag)) q:flag=""
				s keyid=""
				for {
					s keyid=$o(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChildNode",parref,seq,rowid,flag,keyid)) q:keyid=""
					s detailItm=""
					s detailid=""
					for{
						s detailid=$o(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChildNode",parref,seq,rowid,flag,keyid,detailid)) q:detailid=""
						//单个属性多选以顿号分隔
						if (flag="D"){
							if ($d(^TEMPPROPERTYNODE($zn,$j,"PropertyNode",SDSTermDR,keyid))){
								s propertyid=$g(^TEMPPROPERTYNODE($zn,$j,"PropertyNode",SDSTermDR,keyid))
							}else{
								s propertyid=keyid
							}
							//获取属性常用名别名
							s detailDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(detailid,propertyid,"展示名") 
							s:detailDesc="" detailDesc=$listGet($g(^User.MKBTermProDetailD(detailid)),3)
							
							if (detailItm=""){
								s detailItm=detailDesc
							}else{
								s detailItm=detailItm_"、"_detailDesc
							}
						}else{
							//s detailDesc=$listGet($g(^User.MKBTermD(detailid)),3)
							//获取术语常用名，常用名为空则取中心词
							s detailDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(detailid) 
							if (detailItm=""){
								s detailItm=detailDesc
							}else{
								s detailItm=detailItm_"、"_detailDesc
							}
						}	
					}
					//其他结构化描述加括号
					if ($d(^TEMPPROPERTYNODE($zn,$j,"PropertyNode",SDSTermDR,keyid))){
						if ($listGet($g(^User.MKBTermProDetailD(keyid)),3)="其他结构化描述"){
							s detailItm="("_detailItm_")"
						}
					}
					//多个属性以逗号分隔
					if (result=""){
						s result=detailItm	
					}else{
						s result=result_"，"_detailItm	
					}
				}
			}
		}
	}
	//增加补充诊断，加括号
	s SDSSupplement=$LISTGET($G(^User.SDSDiagnosD(parref)),4)
	s SDSSupplement=##class(web.DHCBL.BDP.FunLib).EvalJSON(SDSSupplement)
	if (SDSSupplement'=""){
		s:result'="" result=result_",("_SDSSupplement_")"
		s:result="" result="("_SDSSupplement_")"
	}
	
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(SDSTermDR)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s comDesc=$p(strCom,"&%",1) //诊断常用名
	s:comDesc="" comDesc=$listGet($g(^User.MKBTermD(SDSTermDR)),3) //诊断中心词
	if (result'=""){
		s result=comDesc_"["_result_"]"	
	}else{
		s result=comDesc
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2019-07-25
/// Description:获取诊断常用名(中心词)
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnos).GetTermName(7)
ClassMethod GetTermName(TermDr) As %String
{
  	s MKBTDesc=$listGet($g(^User.MKBTermD(TermDr)),3)  //中心词
  	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(TermDr)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s comDesc=$p(strCom,"&%",1) //常用名
	s:comDesc="" comDesc=MKBTDesc
	s MKBTDesc=	comDesc_"("_MKBTDesc_")"
	s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
	q MKBTDesc
}

/// Creator:高姗姗
/// CreatDate:2019-07-16
/// Description：生成临时global，通过诊断模板中属性内容起始节点id获取属性id
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetPropertyByNode(14870)
ClassMethod GetPropertyByNode(dia) As %String
{
	q:dia="" ""
	k ^TEMPPROPERTYNODE($zn,$j,"PropertyNode",dia)
	k ^TEMPPROPERTYNODE($zn,$j,"ChoiceType",dia)
	k ^TEMPPROPERTYNODE($zn,$j,"Sequence",dia)
	s proId=$o(^User.MKBTermPropertyI("FlagIndex",dia," DT",0)) //诊断模板的属性ID 直接根据标识来获取    
	if (proId'="")
	{
		s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0)) //属性内容的id
		if (proDetailId'="")
		{
			s proDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)   //属性内容
			if (proDetailDesc'="")
			{
				s argsLen=$Length(proDetailDesc,",")
			    for i=1:1:argsLen   
			    {     
			        s argstr=$p(proDetailDesc,",",i)  
			        s catRowId=$p(argstr,"&",1)  //术语属性id 或者术语id 
			        s showType=$p(argstr,"&",2) //展示类型
			        s treeNode=$p(argstr,"&",3) //定义起始节点
			        s:treeNode="undefined" treeNode=""
			        s choiceType=$p(argstr,"&",4)  //单选多选
			        s:choiceType="" choiceType="S"  //默认单选
			        if (treeNode'=""){
				        s ^TEMPPROPERTYNODE($zn,$j,"PropertyNode",dia,treeNode)=catRowId
				        s ^TEMPPROPERTYNODE($zn,$j,"ChoiceType",dia,treeNode)=choiceType
				        s ^TEMPPROPERTYNODE($zn,$j,"Sequence",dia,treeNode)=i
				    }else{
					    s ^TEMPPROPERTYNODE($zn,$j,"ChoiceType",dia,catRowId)=choiceType
					    s ^TEMPPROPERTYNODE($zn,$j,"Sequence",dia,catRowId)=i
					}
			    }
			}
		}	
	}
	q 1
}

/// Creator:高姗姗
/// CreatDate:2019-07-16
/// Description:获取属性在诊断模板定义的起始节点的下一级，如淋巴瘤属性病理的非霍奇金
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetDetailNode("14679","318723")
ClassMethod GetDetailNode(dia, detailid) As %String
{
	s LastLevel=$LISTGET($G(^User.MKBTermProDetailD(detailid)),4)
	if (LastLevel'=""){
		if ('$d(^TEMPPROPERTYNODE($zn,$j,"PropertyNode",dia,LastLevel))){
			s detailid=..GetDetailNode(dia,LastLevel)
		}
	}
	q detailid
}

/// Creator:高姗姗
/// CreatDate:2018-08-01
/// Description：根据标识获取属性id
/// Input: termid术语id，desc属性描述
/// return:属性id
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnos).GetPropertyIdByFlag("14870","DT")
ClassMethod GetPropertyIdByFlag(termid As %String, flag As %String) As %String
{
	q:termid="" ""
	s propertyid=""
	s propertyid=$o(^User.MKBTermPropertyI("FlagIndex",termid," "_flag,0))
	q propertyid
}

/// Creator:高姗姗
/// CreatDate:2018-4-17
/// Description：根据属性id获取诊断模板中的展示格式
/// Table：User.SDSDiagnos
/// Input：属性id
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetShowType("4994")
ClassMethod GetShowType(property) As %String
{
	k ^TMPMKBSHOWTYPE($zn,$j)
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
	s MKBTPDDesc=""
	s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
	if (MKBTPDDesc'="")
	{
        s argsLen=$Length(MKBTPDDesc,",")
        for i=1:1:argsLen  
        { 
          s argstr=$p(MKBTPDDesc,",",i)
          s MKBTPRowId=$p(argstr,"&",1)
          s MKBTPShowType=$p(argstr,"&",2)  //展示格式
          s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
          s ^TMPMKBSHOWTYPE($zn,$j,MKBTPRowId)=MKBTPShowType
        }
	}
	q 1
}

/// Creator:高姗姗
/// CreatDate:2018-4-16
/// Description：获取结构化诊断已选属性的信息
/// Table：User.SDSDiagnos
/// Input：parref 结构化诊断id
/// Return：术语属性内容值串
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetData("843")
ClassMethod GetData(parref) As %String
{
	
	s result=""
	s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(parref)),2) //诊断id
	q:SDSTermDR="" ""
	s ProTempId=..GetPropertyIdByFlag(SDSTermDR,"DT")
	q:ProTempId="" ""
	d ..GetShowType(ProTempId)
	
	s TreeCheckedIdStr=""
	s ComboCheckedIdStr=""
	s RadioCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
	s GridCheckedIdStr=""
	s sub=""
	for { 
	 	s sub=$o(^User.SDSDiagnosD(parref,"ChildProperty",sub)) q:sub=""
	 	s PropertyDR=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",sub)),2)
	 	continue:'$d(^User.MKBTermPropertyD(PropertyDR))
	 	s ProDetail=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",sub)),3)
	 	s Flag=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",sub)),4)
	 	if (Flag="D"){
		 	continue:'$d(^User.MKBTermProDetailD(ProDetail))
		}else{
			continue:'$d(^User.MKBTermD(ProDetail))
		}
	 	if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="T"){
		 	if (TreeCheckedIdStr=""){
				s TreeCheckedIdStr=ProDetail
			}else{
				s TreeCheckedIdStr=TreeCheckedIdStr_"&"_ProDetail
			}
		}
		if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="C"){
			if (ComboCheckedIdStr=""){
				s ComboCheckedIdStr=ProDetail
			}else{
				s ComboCheckedIdStr=ComboCheckedIdStr_"&"_ProDetail
			}
		}
		if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="CB"){
			if (RadioCheckedIdStr=""){
				s RadioCheckedIdStr=ProDetail
			}else{
				s RadioCheckedIdStr=RadioCheckedIdStr_"&"_ProDetail
			}
		}
		if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="CG"){
			if (CheckBoxCheckedIdStr=""){
				s CheckBoxCheckedIdStr=ProDetail
			}else{
				s CheckBoxCheckedIdStr=CheckBoxCheckedIdStr_"&"_ProDetail
			}
		}
		if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="G"){
			if (GridCheckedIdStr=""){
				s GridCheckedIdStr=ProDetail
			}else{
				s GridCheckedIdStr=GridCheckedIdStr_"&"_ProDetail
			}
		}
	}
	s result=TreeCheckedIdStr_"^"_ComboCheckedIdStr_"^"_RadioCheckedIdStr_"^"_CheckBoxCheckedIdStr_"^"_GridCheckedIdStr
	q result
}

/// Creator:高姗姗
/// CreatDate:2019-7-30
/// Description：获取结构化诊断已选属性的信息
/// Table：User.SDSDiagnos
/// Input：termid value
/// Return：术语属性内容值串
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetDataByValue("","")
ClassMethod GetDataByValue(termid, value) As %String
{
	q:termid="" ""
	s result=""
	s ProTempId=..GetPropertyIdByFlag(termid,"DT")
	q:ProTempId="" ""
	d ..GetShowType(ProTempId)
	
	s TreeCheckedIdStr=""
	s ComboCheckedIdStr=""
	s RadioCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
	s GridCheckedIdStr=""
	if (value'=""){
		s PropertyLen=$Length(value,",")
		for i=1:1:PropertyLen{
			s Property=$p(value,",",i)
			s PropertyDR=$p(Property,":",1)
			continue:'$d(^User.MKBTermPropertyD(PropertyDR))
			s ProDetail=$p(Property,":",2)
			s ProDetail=$tr(ProDetail,"S","")
			s ProDetail=$tr(ProDetail,"*","&")

			if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="T"){
			 	if (TreeCheckedIdStr=""){
					s TreeCheckedIdStr=ProDetail
				}else{
					s TreeCheckedIdStr=TreeCheckedIdStr_"&"_ProDetail
				}
			}
			if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="C"){
				if (ComboCheckedIdStr=""){
					s ComboCheckedIdStr=ProDetail
				}else{
					s ComboCheckedIdStr=ComboCheckedIdStr_"&"_ProDetail
				}
			}
			if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="CB"){
				if (RadioCheckedIdStr=""){
					s RadioCheckedIdStr=ProDetail
				}else{
					s RadioCheckedIdStr=RadioCheckedIdStr_"&"_ProDetail
				}
			}
			if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="CG"){
				if (CheckBoxCheckedIdStr=""){
					s CheckBoxCheckedIdStr=ProDetail
				}else{
					s CheckBoxCheckedIdStr=CheckBoxCheckedIdStr_"&"_ProDetail
				}
			}
			if ($g(^TMPMKBSHOWTYPE($zn,$j,PropertyDR))="G"){
				if (GridCheckedIdStr=""){
					s GridCheckedIdStr=ProDetail
				}else{
					s GridCheckedIdStr=GridCheckedIdStr_"&"_ProDetail
				}
			}
		}
	}
	
	s result=TreeCheckedIdStr_"^"_ComboCheckedIdStr_"^"_RadioCheckedIdStr_"^"_CheckBoxCheckedIdStr_"^"_GridCheckedIdStr
	q result
}

/// Creator:高姗姗
/// CreatDate:2019-07-18
/// Description：保存诊断列表拖拽的顺序
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).SaveDragOrder("233&%234&%224&%223&%212&%211&%210&%209&%208&%207&%206&%205&%204&%203&%199&%198&%186&%185&%183&%181")
ClassMethod SaveDragOrder(order, seq) As %String
{
	s result=""
	Ts
	s argsLen=$Length(order,"&%")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"&%",i)
		//选中行的顺序
		s obj=##class(User.SDSDiagnos).%OpenId(rowid)
		//s obj.SDSSequence=i+seq-1  //正序保存
		s obj.SDSSequence=argsLen+seq-i //倒序保存
		s sc=obj.%Save()
		
		d obj.%Close()
		If $$$ISOK(sc)
		{
			
		}
		else
		{
			s result = "{success:'false'}"  //返回错误信息
		}
	}
	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"

	}
	else
	{
		Tc
		s result = "{success:'true',info:'保存成功'}"
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-07-18
/// Description:根据表达式获取短语及短语关联ICD
/// Table：User.MKBStructuredData
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetWordICD("14870","","")
ClassMethod GetWordICD(TermDR As %String, Value As %String, Supplement As %String, WordDR As %String = "", Type As %String = "") As %String
{
	s result=""
	q:TermDR="" ""
	s param=TermDR
	if (Value'=""){
		s param=param_"-"_Value
	}
	//根据诊断表达式获取诊断短语
	s version=..GetWordVersion()
	s SDSWordDR="",SDSWordDesc="",SDSIcdCode="",SDSIcdDesc="",ICDRowId=""
	
	if (version["ICD"){ //取自各版本icd对照
		if (WordDR'=""){
			s SDSWordDRStr=WordDR  //直接选择诊断短语(系统对照好的结构化诊断)，未手动勾选其他属性时，确定短语作为ICD
		}else{
			s SDSWordDRStr=##class(web.DHCBL.MKB.MKBICDContrastInterface).GetDiagViaStruct(version,param)
		}
		if (SDSWordDRStr'=""){
			s WordLen=$Length(SDSWordDRStr,",")
			for i=1:1:WordLen{
				s SDSWordDR=$p(SDSWordDRStr,",",i)
				s SDSWordDesc=$LISTGET($G(^User.MKBICDContrastD(SDSWordDR)),3) 
				s SDSIcdCode=$LISTGET($G(^User.MKBICDContrastD(SDSWordDR)),4)_$LISTGET($G(^User.MKBICDContrastD(SDSWordDR)),5) 
				s SDSIcdDesc=$LISTGET($G(^User.MKBICDContrastD(SDSWordDR)),3)
				s ICDRowId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(SDSIcdCode,SDSIcdDesc,Type)
				q:(ICDRowId'="")
			}	
		}
	}else{ //取自数据处理工厂
		if (WordDR'=""){
			s SDSWordDRStr=WordDR //直接选择诊断短语(系统对照好的结构化诊断)，未手动勾选其他属性时，确定短语作为ICD
		}else{
			s SDSWordDRStr=##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDiagViaStruct(version,param) //GetDiagViaStructSort
		}
		if (SDSWordDRStr'=""){
			s WordLen=$Length(SDSWordDRStr,",")
			for i=1:1:WordLen{
				s SDSWordDR=$p(SDSWordDRStr,",",i)
				s SDSWordDesc=$LISTGET($G(^User.MKBStructuredDataD(SDSWordDR)),2) 
				s SDSIcdCode=$LISTGET($G(^User.MKBStructuredDataD(SDSWordDR)),20) 
				s SDSIcdDesc=$LISTGET($G(^User.MKBStructuredDataD(SDSWordDR)),21)
				s ICDRowId=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(SDSIcdCode,SDSIcdDesc,Type)
				q:(ICDRowId'="")
			}	
		}
	}
	s DisplayName=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(Value,TermDR)
	if (Supplement'=""){
		s DisplayName=$p(DisplayName,"]",1)
		s DisplayName=DisplayName_",("_Supplement_")]"
	}
	//多语言改造
	s DisplayName=##class(websys.Translation).Get("diagnosentry.v8.csp",DisplayName)
	s Supplement=##class(websys.Translation).Get("diagnosentry.v8.csp",Supplement)
	s SDSWordDesc=##class(websys.Translation).Get("diagnosentry.v8.csp",SDSWordDesc)
	s SDSIcdDesc=##class(websys.Translation).Get("diagnosentry.v8.csp",SDSIcdDesc)
	s result=TermDR_"^"_DisplayName_"^"_Value_"^"_Supplement_"^"_SDSWordDR_"^"_SDSWordDesc_"^"_SDSIcdCode_"^"_SDSIcdDesc_"^"_ICDRowId
	q result
}

/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description:顺序自动生成  获取顺序最大值
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnos).GetLastSequence(1)
ClassMethod GetLastSequence(PatientID) As %String
{
  	s LastSequence=0
	s Sequence=0
  	for{
	  s Sequence=$o(^User.SDSDiagnosI("PMISeqIndex",PatientID,Sequence)) q:Sequence="" 
	  s LastSequence=Sequence
  	}
	q LastSequence
}

/// Creator：高姗姗
/// CreatDate: 2019-07-16
/// Description:根据his icd id获取相应的ICD10代码信息及描述信息
/// Table：User.MRCICDDx
/// Input：his icd id
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetICDData("10")
ClassMethod GetICDData(ICDId As %String) As %String
{
	s result=""
	q:ICDId="" ""
	s ICDCode=$p($g(^MRC("ID",ICDId)),"^",4)
	s ICDDesc=$p($g(^MRC("ID",ICDId)),"^",2)
	s result=ICDCode_"^"_ICDDesc
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-07-17
/// Description:获取临床实用诊断菜单id
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetMenuId()
ClassMethod GetMenuId(flag) As %String
{
	s:flag'="" flag=$ZCONVERT(flag,"U")
	s menuid=""
	s baseId=$o(^User.MKBTermBaseI("FlagIndex"," "_flag,0))
    s MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(baseId)),2)
	s:MKBTBCode'="" menuid=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM."_$ZCONVERT(MKBTBCode,"U"),0))
	q menuid
}

/// Creator:高姗姗
/// CreatDate:2019-09-09
/// Description：获取术语id
/// Input: desc术语描述
/// return:术语id
/// Other:w ##class(web.DHCBL.MKB.SDSDiagnos).GetTermIdByDesc("当前诊断")
ClassMethod GetTermIdByDesc(desc As %String) As %String
{
	s TermDr=""
	s baseid=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiagMark")
	s:baseid'="" TermDr=$o(^User.MKBTermI("DescIndex",baseid," "_desc,0))
	q TermDr
}

/// Creator：高姗姗
/// CreatDate: 2019-07-17
/// Description：查询诊断个人科室模板频次内容
/// Table：User.BDPDataFrequency
/// Input：UserId,LocId
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnos","GetList","460","")
Query GetTempFreqList(UserId As %String, LocId As %String, desc As %String) As %Query(ROWSPEC = "Desc,Freq,DataReference")
{
}

ClassMethod GetTempFreqListExecute(ByRef qHandle As %Binary, UserId As %String, LocId As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (UserId'=""){
	//个人模板
	s freq=""
	for{
		s freq=$o(^User.BDPDataFrequencyI("TableLocUserFreqIdx"," USER.SDSSTRUCTDIAGNOS",LocId,UserId,freq),-1)
		q:freq=""
		s RowId=""
		for{
			s RowId=$o(^User.BDPDataFrequencyI("TableLocUserFreqIdx"," USER.SDSSTRUCTDIAGNOS",LocId,UserId,freq,RowId))
			q:RowId=""
			s Desc=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
			s DataReference=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3   
			s Freq=$listget($g(^User.BDPDataFrequencyD(RowId)),5)
			
			s PINYIN=""
			s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			if (($ZCONVERT(Desc,"U")[$ZCONVERT(desc,"U"))||(PINYIN[$ZCONVERT(desc,"U")))
			{
				d OutputRowTempFreq
			}
		}	
	}
	
 }else{
	//科室模板 
	s freq=""
	 for{
		s freq=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSSTRUCTDIAGNOS",LocId,freq),-1)	
		q:freq=""
		s RowId=""
		for{
			s RowId=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSSTRUCTDIAGNOS",LocId,freq,RowId))	
			q:RowId=""
			s Desc=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
			s DataReference=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3   
			s Freq=$listget($g(^User.BDPDataFrequencyD(RowId)),5)
			
			s PINYIN=""
			s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			if (($ZCONVERT(Desc,"U")[$ZCONVERT(desc,"U"))||(PINYIN[$ZCONVERT(desc,"U")))
			{
				d OutputRowTempFreq
			}
		} 
	 }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTempFreq
    set Data=$lb(Desc,Freq,DataReference)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTempFreqListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempFreqListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetTempFreqListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempFreqListExecute ]
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
/// CreatDate: 2019-09-04
/// Description：获取诊断标记列表
/// Table：User.MKBTerm
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnos","GetTagList","","")
Query GetTagList(desc As %String, parentid As %String) As %Query(ROWSPEC = "id,text")
{
}

ClassMethod GetTagListExecute(ByRef qHandle As %Binary, desc As %String, parentid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 	;先取频次表数据
 	k ^TMPTAGFREQ($zn,$j,"TagRowId")
 	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 	
 	if $d(%session) s LocID = $Get(%session.Data("LOGON.CTLOCID"))
 	;s LocID="95"
	s BDPDAFFrequency=""
	for
	{
		s BDPDAFFrequency=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSTAG",LocID,BDPDAFFrequency),-1) q:BDPDAFFrequency="" 
		s RowId=""
		for
		{
			s RowId=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSTAG",LocID,BDPDAFFrequency,RowId),-1) q:RowId="" 
			s text=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
			s id=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
			s root=$p(id,"#",1)
			s tagid=$p(id,"#",2)
			s ^TMPTAGFREQ($zn,$j,"TagRowId",tagid)=""
			s PINYIN=$listGet($g(^User.MKBTermD(tagid)),6)  //检索码
			
			//s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(text)  
			if ((($ZCONVERT(text,"U")[desc)||(PINYIN[desc)||(desc=""))&((root=parentid)||(parentid=""))){
				d OutputRowTag
			}		
		}
	}
 	
 	;再取诊断标记中频次以外数据
	s baseTag=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiagMark")
	s rowid=""
	for
	{
		s rowid=$o(^User.MKBTermI("BaseIndex",baseTag,rowid)) q:rowid="" 

		s text=$LISTGET($G(^User.MKBTermD(rowid)),3)          
		s LastLevel=$LISTGET($G(^User.MKBTermD(rowid)),5)
		continue:(LastLevel="") //去除根节点
		continue:($d(^TMPTAGFREQ($zn,$j,"TagRowId",rowid))) //去除频次表已有节点
		s root=..GetTagRoot(rowid)
		s id=root_"#"_rowid //根节点id#节点id
		s PINYIN=$listGet($g(^User.MKBTermD(rowid)),6)  //检索码
		
		//s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(text)  
		if ((($ZCONVERT(text,"U")[desc)||(PINYIN[desc)||(desc=""))&((root=parentid)||(parentid=""))){
			d OutputRowTag
		}
		
	}

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTag
    set Data=$lb(id,text)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTagListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTagListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetTagListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTagListExecute ]
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

/// Creator:高姗姗
/// CreatDate:2019-09-04
/// Description:获取已选标记的根节点
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetTagRoot(65674)
ClassMethod GetTagRoot(tagid) As %String
{
	s LastLevel=$LISTGET($G(^User.MKBTermD(tagid)),5)
	i LastLevel'="" d
	.s tagid=..GetTagRoot(LastLevel)
	q tagid
}

/// Creator:高姗姗
/// CreatDate: 2019-09-04
/// Description：获取已选标记列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnos","GetSelTag")
Query GetSelTag(SDSRowId) As %Query(ROWSPEC = "index, titleid, title, id, text")
{
}

ClassMethod GetSelTagExecute(ByRef qHandle As %Binary, SDSRowId As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (SDSRowId'=""){
	 k ^TMPSELTAG($zn,$j,"SelTag")
	 s baseTag=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiagMark")
	 s SDSTagDR=""
	 s:SDSRowId'="" SDSTagDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),11)
	 if (SDSTagDR'=""){
		s tagLen=$Length(SDSTagDR,",")
		for i=1:1:tagLen
		{
			s id=$p(SDSTagDR,",",i)
			s text=$listGet($g(^User.MKBTermD(id)),3)
			s titleid=..GetTagRoot(id)
			s title=$listGet($g(^User.MKBTermD(titleid)),3)
			s ^TMPSELTAG($zn,$j,"SelTag",title)=""
			s index=$listGet($g(^User.MKBTermD(titleid)),8)  //顺序
			d OutputRowSelTag
		}	 
	 }
	 s titleid=""
	 for
	 {
		 s titleid=$o(^User.MKBTermI("ParentIndex",baseTag,-100000000000000,titleid)) q:titleid=""
		 s title=$listGet($g(^User.MKBTermD(titleid)),3)
		 continue:$d(^TMPSELTAG($zn,$j,"SelTag",title))
		 s index=$listGet($g(^User.MKBTermD(titleid)),8)  //顺序
		 s id=""
		 s text=""
		 
		 d OutputRowSelTag
	 } 
 }

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowSelTag
    set Data=$lb(index,titleid, title, id, text)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSelTagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelTagExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetSelTagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelTagExecute ]
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

/// Creator:高姗姗
/// CreatDate:2019-09-05
/// Description:提供标记模板信息
/// return：标记模板信息Json拼串
/// w ##class(web.DHCBL.MKB.SDSDiagnos).GetTagTemplate()
ClassMethod GetTagTemplate() As %String
{
	s modeJsonInfo=""	
	s baseTag=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiagMark")
	s parentcatdr=-100000000000000
	s mySeq=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",baseTag,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",baseTag,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s MKBTDesc=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
			s MKBTDesc=$tr(MKBTDesc,"""","")
			s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s PropertyId=$o(^User.MKBTermPropertyI("DescIndex",myRowID," 单选多选配置",0)) //属性id
			s DetailId=$o(^User.MKBTermProDetailI("ProIdx",PropertyId,0))
			s choiceType="" 
			s:DetailId'="" choiceType=$LISTGET($G(^User.MKBTermProDetailD(DetailId)),3)
			s str="{""catRowId"": """_myRowID_""",""catDesc"": """_MKBTDesc_""",""choiceType"": """_choiceType_"""}"
		    i modeJsonInfo="" s modeJsonInfo=str
			e  s modeJsonInfo=modeJsonInfo_","_str
		}
	}
	s:modeJsonInfo'="" modeJsonInfo="["_modeJsonInfo_"]"
	q modeJsonInfo
}

/// Creator：高姗姗
/// CreatDate: 2019-09-06
/// Description:根据诊断标记的id串获取相应的描述信息
/// Table：User.SDSDiagnos
/// Input：TagDr
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetTagText("10,12")
ClassMethod GetTagText(TagDr As %String) As %String
{
	q:TagDr="" ""
    s TagText=""
	s len=$Length(TagDr,",")
	for i=1:1:len{
		s Tagid=$p(TagDr,",",i)
		s Tag=$listGet($g(^User.MKBTermD(Tagid)),3)
		if (TagText=""){
			s TagText=Tag
		}else{
			s TagText=TagText_","_Tag	
		}
	} 
	q TagText
}

/// Creator：高姗姗
/// CreatDate: 2019-08-15
/// Description:获取诊断短语来源，数据处理工厂或各版本icd对照
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion()
ClassMethod GetWordVersion() As %String
{
	s version=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSDataSource")
	q version
}

/// Creator：高姗姗
/// CreatDate: 2019-10-22
/// Description:根据知识库平台配置，获取是否允许录入非标诊断
/// Return: Y/N
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetMKBNSFlag()
ClassMethod GetMKBNSFlag() As %String
{
	s flag="Y" //默认允许录入非标诊断
	s flag=##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSNonstandardICD")
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2019-10-11
/// Description:根据诊断短语描述获取当前患者诊断列表的id
/// Table：User.SDSDiagnos
/// Input：诊断短语描述，多个以^分隔
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetIdByWordDesc(5,"淋巴瘤")
ClassMethod GetIdByWordDesc(PatientID As %String, wordDesc As %String) As %String
{
	q:wordDesc="" ""
	s result=""
	s wordVersion=##class(web.DHCBL.MKB.SDSDiagnos).GetWordVersion() //获取诊断短语数据来源
	if (wordVersion["ICD"){ //取自各版本icd对照
		s wordDr=$p(##class(web.DHCBL.MKB.MKBICDContrastInterface).GetSameDiag(wordVersion,wordDesc),"^",1)
	}else{ //取自数据处理工厂
		s wordDr=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",wordVersion," "_wordDesc,0))
	}
	s:wordDr'="" result=$o(^User.SDSDiagnosI("PMIWordIndex",PatientID,wordDr,0))
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-10-25
/// Description:获取诊断默认信息 Type默认诊断类型 Status默认诊断状态
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetDefaultInfo("Status","")
ClassMethod GetDefaultInfo(flag, desc) As %String
{
	q:desc="" ""
	s result=""
	if (flag="Type"){ //诊断类型
		s baseType=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiaType")
		if (baseType'=""){
			s result=$o(^User.MKBTermI("DescIndex",baseType," "_desc,0))
		}
	}
	if (flag="Status"){ //诊断状态
		s baseStatus=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("DiaState")
		if (baseStatus'=""){
			s result=$o(^User.MKBTermI("DescIndex",baseStatus," "_desc,0))
		}
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2019-11-18
/// Description:根据诊断类型获取诊断列表中本次就诊的诊断id串
/// Table：User.SDSDiagnos
/// Input：诊断类型（医生站诊断类型代码）
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetIdsByTypeDesc(5,1,"初步诊断")
ClassMethod GetIdsByTypeCode(PatientID As %String, mradm As %String, TypeCode As %String) As %String
{
	q:TypeCode="" ""
	s result=""
	s SDSRowId=""
	for{
		s SDSRowId=$o(^User.SDSDiagnosI("PMIIndex",PatientID,SDSRowId))	 q:SDSRowId=""
		if ($d(^User.SDSDiagnosLinkI("AdmStructIndex",mradm,SDSRowId))){ //被引用
			s SDSTypeDR=$LISTGET($G(^User.SDSDiagnosD(SDSRowId)),14)
			s:SDSTypeDR'="" SDSTypeDesc=$listGet($g(^User.MKBTermD(SDSTypeDR)),3)
			s:SDSTypeDR="" SDSTypeDesc=""
			s TypeDesc=##class(web.DHCBL.MKB.SDSDiagnosInterface).GetTypeDescByCode(TypeCode) //根据医生站诊断类型代码获取描述
			continue:(SDSTypeDesc'=TypeDesc)
			if (result=""){
				s result=SDSRowId
			}else{
				s result=result_"^"_SDSRowId	
			}
		}
	}
	q result
}

}
