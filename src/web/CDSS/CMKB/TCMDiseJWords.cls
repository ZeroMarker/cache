/// Description: 中医疾病关联识别词表及属性表数据维护
/// Creator: 胡宜良
/// Date: 2022-02-16
Class web.CDSS.CMKB.TCMDiseJWords Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2022-02-16
/// Description:获得中医疾病关联识别词内容
/// Table: CT.WDT.CDSS.TCMDiseJWords
/// Input: DiseID 中医疾病字典表RowID
/// Return:返回所有中医疾病关联识别词表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDiseJWords","GetList","","")
Query GetList(DiseID As %String, desc As %String) As %Query(ROWSPEC = "RowId,WordDR,WordsDescF,WordsDesc,WordType,WordGradeF,WordGrade,IsNegatCondiF,IsNegatCondi,IsNecessAndSuffiCondiF,IsNecessAndSuffiCondi,IsNecessCondiF,IsNecessCondi,IsHospRecallF,IsHospRecall,IsOutpatientRecallF,IsOutpatientRecall,IsShowF,IsShow,Remarks")
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
		s RowId = $o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DiseID,RowId)) q:RowId=""
		s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),3)
		s WordsDescF=WordDR
		s WordsDesc =""
		s:WordDR'="" WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		s WordType= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),4)
		s WordGrade= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),5)
		s WordGradeF=WordGrade
		s IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),6)
		s IsNegatCondiF=IsNegatCondi
		s IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),7)
		s IsNecessAndSuffiCondiF=IsNecessAndSuffiCondi
		s IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),8)
		s IsNecessCondiF=IsNecessCondi
		s IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),9)
		s IsHospRecallF=IsHospRecall
		s IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),10)
		s IsOutpatientRecallF=IsOutpatientRecall
		s IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),11)
		s IsShowF=IsShow
		s Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),12)	
		if ($ZCONVERT(WordsDesc,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,WordDR,WordsDescF,WordsDesc,WordType,WordGradeF,WordGrade,IsNegatCondiF,IsNegatCondi,IsNecessAndSuffiCondiF,IsNecessAndSuffiCondi,IsNecessCondiF,IsNecessCondi,IsHospRecallF,IsHospRecall,IsOutpatientRecallF,IsOutpatientRecall,IsShowF,IsShow,Remarks)
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

/// Creator：胡宜良
/// CreatDate: 2022-02-16
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.TCMDiseJWords
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJWords).FormValidate("","1","")
ClassMethod FormValidate(id As %String, TCMDiseDR As %String, WordDR As %String) As %String
{
	q:(TCMDiseDR="")||(WordDR="") ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.TCMDiseJWordsI("DiseWordIndex",TCMDiseDR,WordDR))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseWordIndex",TCMDiseDR,WordDR,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// Creator：胡宜良
/// CreatDate: 2022-02-16
/// Description:保存中医疾病关联识别词表
/// Table: CT.WDT.CDSS.TCMDiseJWords
/// Input: eobj 中医疾病关联识别词表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.TCMDiseJWords).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.TCMDiseJWords)
{
	s $zt="ERROR"
	s result=""

	if $IsObject(eobj)
	{

		s eobj.WordDR=eobj.WordsDesc

		s flag=..FormValidate(eobj.RowId,eobj.TCMDiseDR,eobj.WordsDesc)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseJWords).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseJWords).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJWords).%New()
			if $IsObject(obj.TCMDiseDR)
			{
			 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
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
		d:eobj.TCMDiseDR'="" obj.TCMDiseDRSetObjectId(eobj.TCMDiseDR)
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
			d ##class(web.CDSS.CMKB.TCMDiseJProperty).AddResponUser(eobj.TCMDiseDR,eobj.OperationUser)
			//保存和更新 中医疾病关联识别词必要条件数据
			if ((eobj.RowId="")&(eobj.IsNecessCondi=1))||((eobj.RowId'="")&&(eobj.IsNecessCondi'=bobj.IsNecessCondi))
			{
				d ##class(web.CDSS.CMKB.TCMDiseJProperty).UpdateNumOfNConditions(eobj.TCMDiseDR)
			}
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJWords","CT.WDT.CDSS.TCMDiseJWords","中医疾病关联识别词",id,eobj.WordDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJWords","CT.WDT.CDSS.TCMDiseJWords","中医疾病关联识别词",eobj.RowId,eobj.WordDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联识别词","web.CDSS.CMKB.TCMDiseJWords","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联识别词","web.CDSS.CMKB.TCMDiseJWords","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 胡宜良
/// CreatDate: 2022-02-16
/// Description:删除中医疾病关联识别词表
/// Table: CT.WDT.CDSS.TCMDiseJWords
/// Input: id 疾病关联辅助检查检验id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMDiseJWords).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.TCMDiseJWords).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJWords).%New()
	if $IsObject(obj.TCMDiseDR)
	{
	 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
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
			
	s sc=##class(CT.WDT.CDSS.TCMDiseJWords).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJWords","CT.WDT.CDSS.TCMDiseJWords","中医疾病关联识别词",id,bobj.WordDR,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联识别词","web.CDSS.CMKB.TCMDiseJWords","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：胡宜良
/// CreatDate: 2022-02-16
/// Description:通过id获取中医疾病关联识别词内容
/// Table: CT.WDT.CDSS.TCMDiseJWords
/// Input: id 中医疾病关联识别词id
/// Return: 中医疾病关联识别词内容
/// others:w ##class(web.CDSS.CMKB.TCMDiseJWords).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJWords).%New()
	s eobj.RowId= id
	s eobj.TCMDiseDR = $LISTGET($G(^CT.WDT.CDSS.TCMDiseJWordsD(id)),2)
	s eobj.WordDR= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),3)
	s eobj.WordType = $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),4)
	s eobj.WordGrade = $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),5)
	s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),6)
	s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),7)
	s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),8)
	s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),9)
	s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),10)
	s eobj.IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),11)
	s eobj.Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(id)),12)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator：胡宜良
/// CreatDate:2022-02-16
/// Description:根据疾病ID获取该疾病的疾病与识别词表、识别词组合表、诊断属性表内容的日志 生成临时global
/// Input: DiseID 疾病ID
/// Return: 是否成功 
/// others:w ##class(web.CDSS.CMKB.TCMDiseJWords).CreateTEMPLogGlobal("182")
ClassMethod CreateTEMPLogGlobal(DiseID As %String)
{
	s str="sucess"	
	k ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog")
	//中医疾病关联识别词的日志
	s WordID="",ClassName="CT.WDT.CDSS.TCMDiseJWords"
    for
    {
    	s WordID=$o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseaseDRIndex",DiseID,WordID)) q:WordID="" 
		s ID="",ClassName="CT.WDT.CDSS.TCMDiseJWords"
	    for
	    {
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("CNameObReferIndex",ClassName,WordID,ID)) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),6)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"
	    }
    }
    
    //疾病关联诊断属性的日志
	s PropertyID="",ClassName="CT.WDT.CDSS.TCMDiseJProperty"
	for
	{
		s PropertyID = $o(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseID,PropertyID)) q:PropertyID=""
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
	          	s ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_Opreation
	        }
         	else
         	{
          		s ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"
         	}
	    }
    }
	q str
}

/// Creator：胡宜良
/// CreatDate:2022-02-16
/// Description:获得疾病与识别词表、识别词组合表、诊断属性表内容的日志
/// Table: User.DHCDSSDiseaseDict,CT.WDT.CDSS.TCMDiseJWords,CT.WDT.CDSS.TCMDiseJProperty
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有疾病与识别词表、识别词组合表、诊断属性表内容的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDiseJWords","GetDiseLogList","418")
Query GetDiseLogList(DiseID As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetDiseLogListExecute(ByRef qHandle As %Binary, DiseID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (DiseID'="") s str=##class(web.CDSS.CMKB.TCMDiseJWords).CreateTEMPLogGlobal(DiseID)
 	if (str="sucess")
 	{
	 	s UpdateDateID=""
		for
		{
			s UpdateDateID = $o(^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDateID),-1) q:UpdateDateID=""
			s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDateID)
			s UpdateTimeID=""
		    for
		    {
		    	s UpdateTimeID=$o(^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDateID,UpdateTimeID),-1) q:UpdateTimeID=""
		    	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTimeID) 
		    	s LogID=$P(^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDateID,UpdateTimeID),"^",1)
		    	s UpdateUserName=$P(^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDateID,UpdateTimeID),"^",2)
		    	s Opreation=$P(^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDateID,UpdateTimeID),"^",3)
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

/// Creator：胡宜良
/// CreatDate:2022-02-16
/// Description:把疾病关联识别词转移到中医疾病关联识别词表
/// Table:CT.WDT.CDSS.TCMDiseSymJWords、CT.WDT.CDSS.TCMDiseJWords
/// Input:
/// Return:转移多少条数据
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJWords).TransferDataToDJI()
ClassMethod TransferDataToDJI()
{
	s count=0,fcount=0
	s DJFRowID=0
	for
	{
		s DJFRowID=$o(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)) q:DJFRowID=""
		
		s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),3)
		s WordsDesc =""
		s:WordDR'="" WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		s WordDR=$O(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(WordsDesc,"U"),""))
		s TCMDiseDR = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),2)
		continue:(TCMDiseDR="")||(WordDR="")
		s eobj=##class(web.CDSSEntity.CMKB.TCMDiseJWords).%New()
		s eobj.TCMDiseDR=TCMDiseDR
		s eobj.WordDR=WordDR
		s eobj.WordsDesc=WordDR
		s eobj.WordType= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),4)
		s eobj.WordGrade= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),5)
		s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),6)
		s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),7)
		s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),8)
		s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),9)
		s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),10)
		s eobj.IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),11)
		s eobj.Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DJFRowID)),12)	
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

/// Creator：胡宜良
/// CreatDate: 2022-02-22
/// Description:复制疾病的证型到其他疾病
/// Table:CT.WDT.CDSS.TCMDiseSymJWords
/// Input:CopyDisease --复制的疾病名称 ToDisease--复制到的疾病名称
/// Return: 是否复制成功及提示
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJWords).CopySymToOther()
ClassMethod CopySymToOther(CopyDiseaseID, ToDisease)
{
	if (CopyDiseaseID="") q "{success:'false',errorinfo:'复制疾病为空'}"
	if (ToDisease="") q "{success:'false',errorinfo:'需要复制的疾病为空'}"
	
	s result="{success:'true',errorinfo:'复制成功！'}",info=""
	
	//复制证型
	s RowId = 0
	for
	{
		s RowId = $o(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",CopyDiseaseID,RowId)) q:RowId=""
		s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),3)
		s WordsDesc=""
		s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		if ('$d(^CT.WDT.CDSS.TCMDiseSymJWordsI("WordIndex",ToDisease,WordDR)))
		{
			s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseSymJWords).%New()
			s eobj.DiseaseDR = ToDisease
			s eobj.WordDR = WordDR
			s eobj.WordsDesc= WordDR
			s eobj.WordsType= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),4)
			s eobj.WordGrade= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),5)
			s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),6)
			s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),7)
			s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),8)
			s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),9)
			s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),10)
			s eobj.IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),11)
			s eobj.Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),12)
			s Wordsresult=##class(web.CDSS.CMKB.TCMDiseSymJWords).SaveData(eobj)
			if (Wordsresult["false")
			{
				if (Wordsresult'["记录已经存在")
				{
					s:info'="" info=info_","_WordsDesc
					s:info="" info=WordsDesc
				}
				
			}
			k eobj
		}
	}
	s:info'="" result="{success:'false',errorinfo:'"_info_"没有复制成功'}"
	q result
}

/// Creator：胡宜良
/// CreatDate: 2022-02-22
/// Description:复制疾病的识别词到其他疾病
/// Table:CT.WDT.CDSS.TCMDiseJWords
/// Input:CopyDisease --复制的疾病名称 ToDisease--复制到的疾病名称
/// Return: 是否复制成功及提示
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJWords).CopyWordsToOther(3,16)
ClassMethod CopyWordsToOther(CopyDiseaseID, ToDisease)
{
	if (CopyDiseaseID="") q "{success:'false',errorinfo:'复制疾病为空'}"
	if (ToDisease="") q "{success:'false',errorinfo:'需要复制的疾病为空'}"
	
	s result="{success:'true',errorinfo:'复制成功！'}",info=""
	
	//复制识别词
	s RowId = 0
	for
	{
		s RowId = $o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",CopyDiseaseID,RowId)) q:RowId=""
		s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),3)
		s WordsDesc=""
		s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		if ('$d(^CT.WDT.CDSS.TCMDiseJWordsI("WordIndex",ToDisease,WordDR)))
		{
			s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJWords).%New()
			s eobj.TCMDiseDR = ToDisease
			s eobj.WordDR = WordDR
			s eobj.WordsDesc= WordDR
			s eobj.WordType= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),4)
			s eobj.WordGrade= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),5)
			s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),6)
			s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),7)
			s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),8)
			s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),9)
			s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),10)
			s eobj.IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(RowId)),11)
			s eobj.Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),12)
			s Wordsresult=##class(web.CDSS.CMKB.TCMDiseJWords).SaveData(eobj)
			if (Wordsresult["false")
			{
				if (Wordsresult'["记录已经存在")
				{
					s:info'="" info=info_","_WordsDesc
					s:info="" info=WordsDesc
				}
				
			}
			k eobj
		}
	}
	s:info'="" result="{success:'false',errorinfo:'"_info_"没有复制成功'}"
	q result
}

/// Creator:阚延新
/// CreatDate: 2022-01-24
/// Description：保存 对接方字典关联院区表
/// Input: 
/// Table:CT.WDT.CDSS.InterDictConArea
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.InterfaceDict).SaveIntConArea("")
ClassMethod SaveSymDise(eobj As web.CDSSEntity.CMKB.TCMDiseJWords) As %String
{
	s result=""	
	if $IsObject(eobj)
	{	
		s flag=0 //..IntConAreaValidate(eobj.ID,eobj.InterDictDR,eobj.HospAreaDR)
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.TCMDiseJWords).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseJWords).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJWords).%New()
			s bobj.RowId=eobj.RowId
			s:obj.TCMDiseDR'="" bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
			s:obj.WordDR'="" bobj.WordDR = obj.WordDR.%Id()			
		}
		d obj.TCMDiseDRSetObjectId(eobj.TCMDiseDR)
		d obj.WordDRSetObjectId(eobj.WordDR)
		Ts
		s sc=obj.%Save()
		b ;k
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			;d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_WDT_CDSS_InterDictConArea","CT.WDT.CDSS.InterDictConArea","对接方字典关联院区表",id,eobj.InterDictDR,"A",eobj)
			;d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_WDT_CDSS_InterDictConArea","CT.WDT.CDSS.InterDictConArea","对接方字典关联院区表",id,eobj.InterDictDR,"A",eobj,bobj)
			
		}
		else
		{
			Trollback
			;s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("对接方字典关联院区表","CT.WDT.CDSS.InterDictConArea","SaveIntConArea",eobj)
			;s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:胡宜良 
/// CreatDate: 2022-02-25
/// Description：保存 中医辩证识别词表
/// Input: 
/// Table:CT.WDT.CDSS.TCMDiseSymJWords
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJWords).SaveSymDise("")
ClassMethod SaveSymDise2(eobj As web.CDSSEntity.CMKB.TCMDiseJWords) As %String
{
	s result=""	
	//s ^TMP("HYL")=""
	if $IsObject(eobj)
	{	
		s flag=0 //s flag=..FormValidate(eobj.RowId,eobj.TCMDiseDR,eobj.WordDR)
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
	    //s obj=##class(CT.WDT.CDSS.TCMDiseJWords).%New()
		if (eobj.RowId="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.TCMDiseJWords).%New()
		}
		else	//修改
		{
			//s ^TMP("HYL")=^TMP("HYL")_1
			s obj=##class(CT.WDT.CDSS.TCMDiseJWords).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJWords).%New()
			s bobj.RowId = eobj.RowId
			s:obj.TCMDiseDR'="" bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
			s:obj.WordDR'="" bobj.WordDR = obj.WordDR.%Id()
			//s bobj.WordType = eobj.WordType
			s bobj.WordGrade = eobj.WordGrade
			s bobj.IsNegatCondi = eobj.IsNegatCondi
			s bobj.IsNecessAndSuffiCondi = eobj.IsNecessAndSuffiCondi
			s bobj.IsNecessCondi = eobj.IsNecessCondi
			s bobj.IsHospRecall = eobj.IsHospRecall
			s bobj.IsOutpatientRecall = eobj.IsOutpatientRecall
			s bobj.IsShow = eobj.IsShow
			//s ^TMP("HYL")=^TMP("HYL")_2
							
		}
		d obj.TCMDiseDRSetObjectId(eobj.TCMDiseDR)
		d obj.WordDRSetObjectId(eobj.WordDR)
		//s ^TMP("HYL")=^TMP("HYL")_3
		//s obj.WordType = eobj.WordType
		s obj.WordGrade = eobj.WordGrade
		s obj.IsNegatCondi = eobj.IsNegatCondi
		s obj.IsNecessAndSuffiCondi = eobj.IsNecessAndSuffiCondi
		s obj.IsNecessCondi = eobj.IsNecessCondi
		s obj.IsHospRecall = eobj.IsHospRecall
		s obj.IsOutpatientRecall = eobj.IsOutpatientRecall
		s obj.IsShow = eobj.IsShow
		//s ^TMP("HYL")=^TMP("HYL")_4		
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJWords","CT.WDT.CDSS.TCMDiseJWords","中医疾病关联识别词",id,eobj.WordDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJWords","CT.WDT.CDSS.TCMDiseJWords","中医疾病关联识别词",eobj.RowId,eobj.WordDR,"U",eobj,bobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联识别词","web.CDSS.CMKB.TCMDiseJWords","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2022-02-25
/// Description：辨证论治导入编码和中医疾病名称
/// Table：CT.WDT.CDSS.TCMDiseJWords中医疾病字典
/// Input：
/// Output：
/// Other: w ##class(web.CDSS.CMKB.TCMDiseJWords).ImportSymDataTXT1("D:\SymDise.txt")
ClassMethod ImportSymDataTXT1(path) As %String
{
	s savecount=0
	s unsavecount=0
	s incount=0
	s hospareacount=0
	s hospcount=0
	s id=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	
	s TheMarkFlag=""
	
	s num=0
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		s DiseaseCode= $p(data,$c(9),1)       //中医疾病编码
		continue:DiseaseCode=""
		s DiseaseName= $p(data,$c(9),2)       //中医疾病名称
		continue:DiseaseName=""
		s WordsDesc= $p(data,$c(9),4)         //疾病识别词
        s WordGrade= $p(data,$c(9),5)         //疾病识别词等级
        s IsNegatCondi= $p(data,$c(9),6)
        s IsNecessAndSuffiCondi= $p(data,$c(9),7)
        s IsNecessCondi= $p(data,$c(9),8)
        s IsHospRecall= $p(data,$c(9),9)
   		s IsOutpatientRecall= $p(data,$c(9),10)
   		s IsShow= $p(data,$c(9),11)
		s TCMDiseDR=$o(^CT.WDT.CDSS.TCMDiseaseI("DiseSymDRIndex",DiseaseCode,DiseaseName))
		s WordDR=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex",WordsDesc))
		//b
	    
	    
		s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJWords).%New()
		s eobj.RowId = ""
		s eobj.TCMDiseDR = TCMDiseDR
		s eobj.WordDR = WordDR
		//s obj.DiseaseName = eobj.DiseaseName
		//s eobj.WordType = WordType
		s eobj.WordGrade = WordGrade
		s eobj.IsNegatCondi = IsNegatCondi
		s eobj.IsNecessAndSuffiCondi = IsNecessAndSuffiCondi
		s eobj.IsNecessCondi = IsNegatCondi
		s eobj.IsHospRecall = IsHospRecall
		s eobj.IsOutpatientRecall = IsOutpatientRecall
		s eobj.IsShow = IsShow
		
	    s result=..SaveSymDise2(eobj)
	    if ((result'["false"))
		{
			s savecount=savecount+1		
		}
		else
		{
			s unsavecount=unsavecount+1
		}
		
	}
	close file
    k file
	w "读取数据总共"_(num-1)_"条",!
	w "savecount："_savecount,!
	w "unsavecount："_unsavecount,!
	w "incount："_incount,!
	w "hospcount："_hospcount,!
	w "hospareacount："_hospareacount,!
	q "{success:'true'}"
}

}
