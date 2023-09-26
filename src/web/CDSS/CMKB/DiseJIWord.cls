/// Description: 疾病关联识别词及属性表数据维护
/// Creator: 丁亚男
/// Date: 2020-12-22
Class web.CDSS.CMKB.DiseJIWord Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:获得疾病关联识别词内容
/// Table: CT.WDT.CDSS.DiseJIWords
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有疾病关联识别词表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseJIWord","GetList",182,"")
Query GetList(DiseID As %String, desc As %String) As %Query(ROWSPEC = "RowId,WordDR,WordNameF,WordName,WordType,WordGradeF,WordGrade,IsNegatCondiF,IsNegatCondi,IsNecessAndSuffiCondiF,IsNecessAndSuffiCondi,IsNecessCondiF,IsNecessCondi,IsHospRecallF,IsHospRecall,IsOutpatientRecallF,IsOutpatientRecall,IsShowF,IsShow,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, DiseID As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (DiseID="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s RowId = 0
	for
	{
		s RowId = $o(^CT.WDT.CDSS.DiseJIWordsI("DiseaseDRIndex",DiseID,RowId)) q:RowId=""
		s WordDR = $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),3)
		s WordNameF=WordDR
		s WordName =""
		s:WordDR'="" WordName = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		s WordType= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),4)
		s WordGrade= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),5)
		s WordGradeF=WordGrade
		s IsNegatCondi= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),6)
		s IsNegatCondiF=IsNegatCondi
		s IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),7)
		s IsNecessAndSuffiCondiF=IsNecessAndSuffiCondi
		s IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),8)
		s IsNecessCondiF=IsNecessCondi
		s IsHospRecall= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),9)
		s IsHospRecallF=IsHospRecall
		s IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),10)
		s IsOutpatientRecallF=IsOutpatientRecall
		s IsShow= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),11)
		s IsShowF=IsShow
		s Remarks= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(RowId)),12)	
		if ($ZCONVERT(WordName,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,WordDR,WordNameF,WordName,WordType,WordGradeF,WordGrade,IsNegatCondiF,IsNegatCondi,IsNecessAndSuffiCondiF,IsNecessAndSuffiCondi,IsNecessCondiF,IsNecessCondi,IsHospRecallF,IsHospRecall,IsOutpatientRecallF,IsOutpatientRecall,IsShowF,IsShow,Remarks)
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

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.DiseJIWords
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.ExamJoinParts).FormValidate("","1")
ClassMethod FormValidate(id As %String, DiseaseDR As %String, WordDR As %String) As %String
{
	q:(DiseaseDR="")||(WordDR="") ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.DiseJIWordsI("WordDRIndex",DiseaseDR,WordDR))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.DiseJIWordsI("WordDRIndex",DiseaseDR,WordDR,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:保存疾病关联识别词表
/// Table: CT.WDT.CDSS.DiseJIWords
/// Input: eobj 疾病关联识别词表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.DiseJIWord).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiseJIWord)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s eobj.WordDR=eobj.WordName
		s flag=..FormValidate(eobj.RowId,eobj.DiseaseDR,eobj.WordName)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DiseJIWords).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DiseJIWords).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DiseJIWord).%New()
			if $IsObject(obj.DiseaseDR)
			{
			 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
			}
			if $IsObject(obj.WordDR)
			{
			 	s bobj.WordDR = obj.WordDR.%Id()
			}
			s bobj.WordType = obj.WordType
			s bobj.WordGrade = obj.WordGrade
			s bobj.IsNegatCondi = obj.IsNegatCondi
			s bobj.IsNecessAndSuffiCondi = obj.IsNecessAndSuffiCondi
			s bobj.IsNecessCondi = obj.IsNecessCondi
			s bobj.IsHospRecall = obj.IsHospRecall
			s bobj.IsOutpatientRecall = obj.IsOutpatientRecall
			s bobj.IsShow = obj.IsShow
			s bobj.Remarks= obj.Remarks
			
		}
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		d:eobj.WordDR'="" obj.WordDRSetObjectId(eobj.WordDR)
		s obj.WordType = eobj.WordType
		s obj.WordGrade = eobj.WordGrade
		s obj.IsNegatCondi = eobj.IsNegatCondi
		s obj.IsNecessAndSuffiCondi = eobj.IsNecessAndSuffiCondi
		s obj.IsNecessCondi = eobj.IsNecessCondi
		s obj.IsHospRecall = eobj.IsHospRecall
		s obj.IsOutpatientRecall = eobj.IsOutpatientRecall
		s obj.IsShow = eobj.IsShow
		s obj.Remarks= eobj.Remarks
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存责任人、操作时间
			d ##class(web.CDSS.CMKB.DiseJProperty).AddResponUser(eobj.DiseaseDR,eobj.OperationUser)
			//保存和更新 疾病关联识别词必要条件数据
			if ((eobj.RowId="")&(eobj.IsNecessCondi=1))||((eobj.RowId'="")&&(eobj.IsNecessCondi'=bobj.IsNecessCondi))
			{
				d ##class(web.CDSS.CMKB.DiseJProperty).UpdateNumOfNConditions(eobj.DiseaseDR)
			}
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJIWord","CT.WDT.CDSS.DiseJIWords","疾病关联识别词",id,eobj.WordDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJIWord","CT.WDT.CDSS.DiseJIWords","疾病关联识别词",eobj.RowId,eobj.WordDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联识别词","web.CDSS.CMKB.DiseJIWord","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联识别词","web.CDSS.CMKB.DiseJIWord","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 丁亚男
/// CreatDate:2020-12-23
/// Description:删除疾病关联识别词表
/// Table: CT.WDT.CDSS.DiseJIWords
/// Input: id 疾病关联辅助检查检验id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DiseJIWord).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.DiseJIWords).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DiseJIWord).%New()
	if $IsObject(obj.DiseaseDR)
	{
	 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
	}
	if $IsObject(obj.WordDR)
	{
	 	s bobj.WordDR = obj.WordDR.%Id()
	}
	s bobj.WordType = obj.WordType
	s bobj.WordGrade = obj.WordGrade
	s bobj.IsNegatCondi = obj.IsNegatCondi
	s bobj.IsNecessAndSuffiCondi = obj.IsNecessAndSuffiCondi
	s bobj.IsNecessCondi = obj.IsNecessCondi
	s bobj.IsHospRecall = obj.IsHospRecall
	s bobj.IsOutpatientRecall = obj.IsOutpatientRecall
	s bobj.IsShow = obj.IsShow
	s bobj.Remarks= obj.Remarks
			
	s sc=##class(CT.WDT.CDSS.DiseJIWords).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJIWord","CT.WDT.CDSS.DiseJIWords","疾病关联识别词",id,bobj.WordDR,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联识别词","web.CDSS.CMKB.DiseJIWord","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:通过id获取疾病关联识别词内容
/// Table: CT.WDT.CDSS.DiseJIWords
/// Input: id 疾病关联识别词id
/// Return: 疾病关联识别词内容
/// others:w ##class(web.CDSS.CMKB.DiseJIWord).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DiseJIWord).%New()
	s eobj.RowId= id
	s eobj.DiseaseDR = $LISTGET($G(^CT.WDT.CDSS.DiseJIWordsD(id)),2)
	s eobj.WordDR= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),3)
	s eobj.WordType = $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),4)
	s eobj.WordGrade = $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),5)
	s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),6)
	s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),7)
	s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),8)
	s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),9)
	s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),10)
	s eobj.IsShow= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),11)
	s eobj.Remarks= $lg($g(^CT.WDT.CDSS.DiseJIWordsD(id)),12)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-12-29
/// Description:根据疾病ID获取该疾病的疾病与识别词表、识别词组合表、诊断属性表内容的日志 生成临时global
/// Input: DiseID 疾病ID
/// Return: 是否成功 
/// others:w ##class(web.CDSS.CMKB.DiseJIWord).CreateTEMPLogGlobal("182")
ClassMethod CreateTEMPLogGlobal(DiseID As %String)
{
	s str="sucess"	
	k ^TEMPDiseLog
	//疾病关联识别词的日志
	s WordID="",ClassName="CT.WDT.CDSS.DiseJIWords"
    for
    {
    	s WordID=$o(^CT.WDT.CDSS.DiseJIWordsI("DiseaseDRIndex",DiseID,WordID)) q:WordID="" 
		s ID="",ClassName="CT.WDT.CDSS.DiseJIWords"
	    for
	    {
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("CNameObReferIndex",ClassName,WordID,ID)) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),6)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s ^TEMPDiseLog("DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"
	    }
    }
    //疾病关联识别词组合的日志
	s WordCombID="",ClassName="CT.CT.WDT.CDSS.DiseJFactorComb"
	for
	{
		s WordCombID = $o(^CT.CT.WDT.CDSS.DiseJFactorCombI("DiseaseDRIndex",DiseID,WordCombID)) q:WordCombID=""
		s ID=""
	    for
	    {
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("CNameObReferIndex",ClassName,WordCombID,ID),-1) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),6)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s ^TEMPDiseLog("DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"
	    }
    }
    
    //疾病关联诊断属性的日志
	s PropertyID="",ClassName="CT.WDT.CDSS.DiseJProperty"
	for
	{
		s PropertyID = $o(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseID,PropertyID)) q:PropertyID=""
		s ID=""
	    for
	    {
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("CNameObReferIndex",ClassName,PropertyID,ID)) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),6)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),12)   //新增对象描述
          	if (ObjectDesc["&&")
          	{
	          	s Opreation=$p(ObjectDesc,"&&",2)
	          	s ^TEMPDiseLog("DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_Opreation
	        }
         	else
         	{
          		s ^TEMPDiseLog("DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"
         	}
	    }
    }
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-12-29
/// Description:获得疾病与识别词表、识别词组合表、诊断属性表内容的日志
/// Table: WDT.CDSS.DiseaseDict,CT.WDT.CDSS.DiseJIWords,CT.WDT.CDSS.DiseJProperty
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有疾病与识别词表、识别词组合表、诊断属性表内容的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseJIWord","GetDiseLogList","418")
Query GetDiseLogList(DiseID As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetDiseLogListExecute(ByRef qHandle As %Binary, DiseID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (DiseID'="") s str=##class(web.CDSS.CMKB.DiseJIWord).CreateTEMPLogGlobal(DiseID)
 	if (str="sucess")
 	{
	 	s UpdateDateID=""
		for
		{
			s UpdateDateID = $o(^TEMPDiseLog("DiseLog",UpdateDateID),-1) q:UpdateDateID=""
			s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDateID)
			s UpdateTimeID=""
		    for
		    {
		    	s UpdateTimeID=$o(^TEMPDiseLog("DiseLog",UpdateDateID,UpdateTimeID),-1) q:UpdateTimeID=""
		    	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTimeID) 
		    	s LogID=$P(^TEMPDiseLog("DiseLog",UpdateDateID,UpdateTimeID),"^",1)
		    	s UpdateUserName=$P(^TEMPDiseLog("DiseLog",UpdateDateID,UpdateTimeID),"^",2)
		    	s Opreation=$P(^TEMPDiseLog("DiseLog",UpdateDateID,UpdateTimeID),"^",3)
		    	d OutputRowLog
		    }
	    }
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDiseLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetDiseLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:丁亚男
/// CreatDate:2021-11-03
/// Description:把疾病关联诊断因子转移到疾病关联识别词表
/// Table:CT.WDT.CDSS.DiseJFactor、CT.WDT.CDSS.DiseJIWords
/// Input:
/// Return:转移多少条数据
/// Other:w ##class(web.CDSS.CMKB.DiseJIWord).TransferDataToDJI()
ClassMethod TransferDataToDJI()
{
	s count=0,fcount=0
	s DJFRowID=0
	for
	{
		s DJFRowID=$o(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)) q:DJFRowID=""
		
		s FactorDR = $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),3)
		s DiagFactorName =""
		s:FactorDR'="" DiagFactorName = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
		s WordDR=$O(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(DiagFactorName,"U"),""))
		s DiseaseDR = $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),2)
		continue:(DiseaseDR="")||(WordDR="")
		s eobj=##class(web.CDSSEntity.CMKB.DiseJIWord).%New()
		s eobj.DiseaseDR=DiseaseDR
		s eobj.WordDR=WordDR
		s eobj.WordName=WordDR
		s eobj.WordType= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),4)
		s eobj.WordGrade= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),5)
		s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),6)
		s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),7)
		s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),8)
		s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),9)
		s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),10)
		s eobj.IsShow= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),11)
		s eobj.Remarks= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),12)	
		s result=..SaveData(eobj)
		
		if (result["true")||(result["已存在")
		{
			s count=count+1
		}
		else
		{
			s fcount=fcount+1
		}
	}
	q count_"条转移成功！"_fcount_"条转移失败！"
}

/// Creator:丁亚男
/// CreatDate:2021-12-21
/// Description:把疾病关联诊断因子转移到疾病关联识别词表
/// Table:CT.WDT.CDSS.DiseJFactor、CT.WDT.CDSS.DiseJIWords
/// Input:DiseID 疾病的ID
/// Return:成功转移多少条数据
/// Other:w ##class(web.CDSS.CMKB.DiseJIWord).TransferSingleDataToDJI(6936)
ClassMethod TransferSingleDataToDJI(DiseID)
{
	if (DiseID="")
	{
		q "请选中一条疾病！"
	}
	s count=0,fcount=0
	s DJFRowID=0
	for
	{
		s DJFRowID=$o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseID,DJFRowID)) q:DJFRowID=""
		s FactorDR = $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),3)
		s DiagFactorName =""
		s:FactorDR'="" DiagFactorName = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
		s WordDR=$O(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(DiagFactorName,"U"),""))
		continue:(WordDR="")
		s eobj=##class(web.CDSSEntity.CMKB.DiseJIWord).%New()
		s eobj.DiseaseDR=DiseID
		s eobj.WordDR=WordDR
		s eobj.WordName=WordDR
		s eobj.WordType= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),4)
		s eobj.WordGrade= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),5)
		s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),6)
		s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),7)
		s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),8)
		s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),9)
		s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),10)
		s eobj.IsShow= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),11)
		s eobj.Remarks= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DJFRowID)),12)	
		s result=..SaveData(eobj)
		
		if (result["true")||(result["已存在")
		{
			s count=count+1
		}
		else
		{
			s fcount=fcount+1
		}
	}
	s result=count_"条转移成功！"_fcount_"条转移失败！"
	q result
}

}
