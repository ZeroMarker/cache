/// Description: 疾病关联诊断因子及属性表数据维护
/// Creator: 丁亚男
/// Date: 2020-12-22
Class web.CDSS.CMKB.DiseJFactor Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2020-12-22
/// Description:获得疾病与诊断因子表、诊断属性表内容
/// Table: CT.WDT.CDSS.DiseaseDict,CT.WDT.CDSS.DiseJFactor,CT.WDT.CDSS.DiseJProperty
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有疾病关联诊断因子表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseJFactor","GetDiseList","","","","","","","","","","","")
Query GetDiseList(Rowid As %String, DiseCode As %String, DiseDesc As %String, AVersion As %String, CDept As %String, FName As %String, SStatus As %String, SResponUser As %String, SReviewUser As %String, SUpdateDate As %String, EUpdateDate As %String, RareFlag As %String) As %Query(ROWSPEC = "DiseaseRowId,DiseaseCode,DiseaseName,AppliVersion,CommonDept,UpdateDate,ResponUser,ReviewUser,Status,FactorName,RareDiseaseFlag")
{
}

ClassMethod GetDiseListExecute(ByRef qHandle As %Binary, Rowid As %String, DiseCode As %String, DiseDesc As %String, AVersion As %String, CDept As %String, FName As %String, SStatus As %String, SResponUser As %String, SReviewUser As %String, SUpdateDate As %String, EUpdateDate As %String, RareFlag As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s DiseaseRowId=Rowid
 	if (DiseaseRowId'="")
 	{
	 	s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),2)
	 	s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),3)
	 	s RareDiseaseFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),19) //罕见病标记
	 	s UpdateDate=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),20) //最后操作时间为空时默认为导入时间
	 	
	 	s AppliVersion="",CommonDept="",UpdateDate="",ResponUser="",ReviewUser="",Status=""
	 	if ($d(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId)))
	 	{
		 	s DiseJPropertyID=$O(^CT.WDT.CDSS.DiseJPropertyI("DiseDRDateIndex",DiseaseRowId,UpdateDate,0)) q:DiseJPropertyID=""
		 	s CommonDeptDRs=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),19)
		 	if (CommonDeptDRs'="")
		 	{
			 	s DeptLen=$L(CommonDeptDRs,",")
			 	for iDept=1:1:DeptLen
			 	{
				 	s DeptDR=$p(CommonDeptDRs,",",iDept)
				 	s:CommonDept'="" CommonDept=CommonDept_","_$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				 	s:CommonDept="" CommonDept=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				}
			}
		 	s AppliVersion=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),26)
		 	s UpdateDate=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),27)
		 	s ResponUser=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),28)
		 	s ReviewseUr=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),29)
		 	s Status=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),30)
		 	
		}
		s:ResponUser="" ResponUser="毛庆荣" //责任人为空的话，默认毛庆荣
		s:Status="" Status="初始"
		s FactorName=""
	 	if ($d(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId)))
	 	{
		 	s DiseJFactor=0
		 	for 
		 	{
			 	s DiseJFactor=$O(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId,DiseJFactor)) q:DiseJFactor=""
			 	s FactorDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactor)),3)
			 	if (FactorDR'="")
			 	{
				 	s DiagFactorName=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
					s:FactorName'="" FactorName=FactorName_","_DiagFactorName
					s:FactorName="" FactorName=DiagFactorName
				}
			}
		 	
		}
		do OutputRowDise
	}
	else
	{
		s:DiseCode'="" DiseCode=$ZCONVERT(DiseCode,"U") //转换成大写
		s:DiseDesc'="" DiseDesc=$ZCONVERT(DiseDesc,"U") //转换成大写
		s:CDept'="" CDept=$ZCONVERT(CDept,"U") //转换成大写
		s:FName'="" FName=$ZCONVERT(FName,"U") //转换成大写
		s:SResponUser'="" SResponUser=$ZCONVERT(SResponUser,"U") //转换成大写
		s:SReviewUser'="" SReviewUser=$ZCONVERT(SReviewUser,"U") //转换成大写
	 	s TotalNum=""
		for
		{
	 		s TotalNum = $o(^CT.WDT.CDSS.DiseaseDictI("TotalIndex",TotalNum),-1) q:TotalNum=""	
			s DiseaseRowId=0
			for
			{
		 		s DiseaseRowId = $o(^CT.WDT.CDSS.DiseaseDictI("TotalIndex",TotalNum,DiseaseRowId)) q:DiseaseRowId=""
		 		s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),2)
		 		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),3)
		 		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),18)
		 		continue:UseFlag=1
		 		s RareDiseaseFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),19) //罕见病标记
		 		s:RareDiseaseFlag="" RareDiseaseFlag="N" //罕见病标记
		 		s UpdateDate=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),20) //最后操作时间为空时默认为导入时间
	 			s AppliVersion="",CommonDept="",UpdateDate="",ReviewUser="",ResponUser="",Status=""
			 	if ($d(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId)))
			 	{
				 	s DiseJPropertyID=$O(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId,0)) q:DiseJPropertyID=""
				 	s CommonDeptDRs=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),19)
				 	if (CommonDeptDRs'="")
				 	{
					 	s DeptLen=$L(CommonDeptDRs,",")
					 	for iDept=1:1:DeptLen
					 	{
						 	s DeptDR=$p(CommonDeptDRs,",",iDept)
						 	s:CommonDept'="" CommonDept=CommonDept_","_$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
						 	s:CommonDept="" CommonDept=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
						}
					}
				 	s AppliVersion=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),26)
				 	s UpdateDate=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),27)
				 	s ResponUser=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),28)
				 	s ReviewUser=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),29)
				 	s Status=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),30)
				 		
				}
				s:ResponUser="" ResponUser="毛庆荣" //责任人为空的话，默认毛庆荣
				s:Status="" Status="初始"
				s FactorName=""
			 	if ($d(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId)))
			 	{
				 	s DiseJFactor=0
				 	for 
				 	{
					 	s DiseJFactor=$O(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId,DiseJFactor)) q:DiseJFactor=""
					 	s FactorDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactor)),3)
					 	if (FactorDR'="")
					 	{
						 	s DiagFactorName=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
							s:FactorName'="" FactorName=FactorName_","_DiagFactorName
							s:FactorName="" FactorName=DiagFactorName
						}
					}
				 	
				}
				
				s UpdateDateUDate="", UpdateDateUTime=""
				if (UpdateDate'="")
				{ 
					s UpdateDateU=$ZDTH(UpdateDate,3)
					s UpdateDateUDate=$p(UpdateDateU,",",1)
					s UpdateDateUTime=$p(UpdateDateU,",",2)
					b ;1
				}	
				
				s SUpdateDateFlag=1
				if (SUpdateDate'="")
				{
					s SUpdateDateU=$ZDTH(SUpdateDate,3)
					s SUpdateDateUDate=$p(SUpdateDateU,",",1)
					s SUpdateDateUTime=$p(SUpdateDateU,",",2)
					if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
					{
						s SUpdateDateFlag=0	
					}
				}
				s EUpdateDateFlag=1
				if (EUpdateDate'="")
				{
					s EUpdateDateU=$ZDTH(EUpdateDate,3)
					s EUpdateDateUDate=$p(EUpdateDateU,",",1)
					s EUpdateDateUTime=$p(EUpdateDateU,",",2)
					if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
					{
						s EUpdateDateFlag=0	
					}
				}
				
				
		 		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiseaseName)
			  	if ($ZCONVERT(DiseaseCode,"U")[DiseCode)&&(($ZCONVERT(DiseaseName,"U")[DiseDesc)||(PINYIN[DiseDesc))&&(AppliVersion[AVersion)&&(CommonDept[CDept)&&(FactorName[FName)&&(Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)
			  	&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)&&(RareDiseaseFlag[RareFlag)	//过滤条件
			  	{
			  		d OutputRowDise
			 	}
			}
		}
		
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDise
	set Data=$lb(DiseaseRowId,DiseaseCode,DiseaseName,AppliVersion,CommonDept,UpdateDate,ResponUser,ReviewUser,Status,FactorName,RareDiseaseFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDiseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetDiseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:获得疾病关联诊断因子内容
/// Table: CT.WDT.CDSS.DiseJFactor
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有疾病关联诊断因子表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseJFactor","GetList",182,"")
Query GetList(DiseID As %String, desc As %String) As %Query(ROWSPEC = "RowId,FactorDR,DiagFactorNameF,DiagFactorName,FactorType,FactorGradeF,FactorGrade,IsNegatCondiF,IsNegatCondi,IsNecessAndSuffiCondiF,IsNecessAndSuffiCondi,IsNecessCondiF,IsNecessCondi,IsHospRecallF,IsHospRecall,IsOutpatientRecallF,IsOutpatientRecall,IsShowF,IsShow,Remarks")
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
		s RowId = $o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseID,RowId)) q:RowId=""
		s FactorDR = $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),3)
		s DiagFactorNameF=FactorDR
		s DiagFactorName =""
		s:FactorDR'="" DiagFactorName = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
		s FactorType= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),4)
		s FactorGrade= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),5)
		s FactorGradeF=FactorGrade
		s IsNegatCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),6)
		s IsNegatCondiF=IsNegatCondi
		s IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),7)
		s IsNecessAndSuffiCondiF=IsNecessAndSuffiCondi
		s IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),8)
		s IsNecessCondiF=IsNecessCondi
		s IsHospRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),9)
		s IsHospRecallF=IsHospRecall
		s IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),10)
		s IsOutpatientRecallF=IsOutpatientRecall
		s IsShow= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),11)
		s IsShowF=IsShow
		s Remarks= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),12)	
		if ($ZCONVERT(DiagFactorName,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,FactorDR,DiagFactorNameF,DiagFactorName,FactorType,FactorGradeF,FactorGrade,IsNegatCondiF,IsNegatCondi,IsNecessAndSuffiCondiF,IsNecessAndSuffiCondi,IsNecessCondiF,IsNecessCondi,IsHospRecallF,IsHospRecall,IsOutpatientRecallF,IsOutpatientRecall,IsShowF,IsShow,Remarks)
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

/// Creator：丁亚男
/// CreatDate: 2020-12-23
/// Description：查询 诊断指定诊断下的诊断因子
/// Table：CT.WDT.CDSS.DiagFactorBase
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseJFactor","GetDataForCmb1","","182","")
Query GetDataForCmb1(rowid As %String, DiseID As %String, desc As %String) As %Query(ROWSPEC = "DiseJFactorDR:%String,DiagFactorName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, DiseID As %String, desc As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  	s DiseJFactorDR=rowid
  	s FactorDR = $lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactorDR)),3)
	s DiagFactorName =""
	s:FactorDR'="" DiagFactorName = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
  	d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s DiseJFactorDR=""
  for{  
	  s DiseJFactorDR=$o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseID,DiseJFactorDR)) q:DiseJFactorDR=""  
	  s FactorDR = $lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactorDR)),3)
	  s DiagFactorName =""
	  s:FactorDR'="" DiagFactorName = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiagFactorName)  
	  if (($ZCONVERT(DiagFactorName,"U")[desc)||(PINYIN[desc)) {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DiseJFactorDR,DiagFactorName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.DiseJFactor
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.ExamJoinParts).FormValidate("","1")
ClassMethod FormValidate(id As %String, DiseaseDR As %String, FactorDR As %String) As %String
{
	q:(DiseaseDR="")||(FactorDR="") ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.DiseJFactorI("FactorDRIndex",DiseaseDR,FactorDR))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.DiseJFactorI("FactorDRIndex",DiseaseDR,FactorDR,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:保存疾病关联诊断因子表
/// Table: CT.WDT.CDSS.DiseJFactor
/// Input: eobj 疾病关联诊断因子表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.DiseJFactor).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiseJFactor)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s eobj.FactorDR=eobj.DiagFactorName
		s flag=..FormValidate(eobj.RowId,eobj.DiseaseDR,eobj.DiagFactorName)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DiseJFactor).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DiseJFactor).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DiseJFactor).%New()
			if $IsObject(obj.DiseaseDR)
			{
			 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
			}
			if $IsObject(obj.FactorDR)
			{
			 	s bobj.FactorDR = obj.FactorDR.%Id()
			}
			s bobj.FactorType = obj.FactorType
			s bobj.FactorGrade = obj.FactorGrade
			s bobj.IsNegatCondi = obj.IsNegatCondi
			s bobj.IsNecessAndSuffiCondi = obj.IsNecessAndSuffiCondi
			s bobj.IsNecessCondi = obj.IsNecessCondi
			s bobj.IsHospRecall = obj.IsHospRecall
			s bobj.IsOutpatientRecall = obj.IsOutpatientRecall
			s bobj.IsShow = obj.IsShow
			s bobj.Remarks= obj.Remarks
			
		}
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		d:eobj.FactorDR'="" obj.FactorDRSetObjectId(eobj.FactorDR)
		s obj.FactorType = eobj.FactorType
		s obj.FactorGrade = eobj.FactorGrade
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
			//保存和更新 疾病关联诊断因子必要条件数据
			if ((eobj.RowId="")&(eobj.IsNecessCondi=1))||((eobj.RowId'="")&&(eobj.IsNecessCondi'=bobj.IsNecessCondi))
			{
				d ##class(web.CDSS.CMKB.DiseJProperty).UpdateNumOfNConditions(eobj.DiseaseDR)
			}
			
			//保存日志
			s DiseaseNameFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(eobj.DiseaseDR)),3)
			s DiagFactorNameFlag = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(eobj.FactorDR)),3)
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJFactor","CT.WDT.CDSS.DiseJFactor","疾病关联诊断因子",id,DiseaseNameFlag_"-"_DiagFactorNameFlag,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJFactor","CT.WDT.CDSS.DiseJFactor","疾病关联诊断因子",eobj.RowId,DiseaseNameFlag_"-"_DiagFactorNameFlag,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联诊断因子","web.CDSS.CMKB.DiseJFactor","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联诊断因子","web.CDSS.CMKB.DiseJFactor","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 丁亚男
/// CreatDate:2020-12-23
/// Description:删除疾病关联诊断因子表
/// Table: CT.WDT.CDSS.DiseJFactor
/// Input: id 疾病关联辅助检查检验id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DiseJFactor).DeleteData("28885")
ClassMethod DeleteData(id As %String, DiseaseDR As %String = "")
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.DiseJFactor).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DiseJFactor).%New()
	if $IsObject(obj.DiseaseDR)
	{
	 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
	}
	if $IsObject(obj.FactorDR)
	{
	 	s bobj.FactorDR = obj.FactorDR.%Id()
	}
	s bobj.FactorType = obj.FactorType
	s bobj.FactorGrade = obj.FactorGrade
	s bobj.IsNegatCondi = obj.IsNegatCondi
	s bobj.IsNecessAndSuffiCondi = obj.IsNecessAndSuffiCondi
	s bobj.IsNecessCondi = obj.IsNecessCondi
	s bobj.IsHospRecall = obj.IsHospRecall
	s bobj.IsOutpatientRecall = obj.IsOutpatientRecall
	s bobj.IsShow = obj.IsShow
	s bobj.Remarks= obj.Remarks
			
	s sc=##class(CT.WDT.CDSS.DiseJFactor).%DeleteId(id)
	if $$$ISOK(sc)
	{
		
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		//b ;01
		if (DiseaseDR'="")
		{
			s DiseaseNameFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
		}else{
			s DiseaseNameFlag=$lg($g(^CT.WDT.CDSS.DiseaseDictD(bobj.DiseaseDR)),3)
			}
		s DiagFactorNameFlag = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(bobj.FactorDR)),3)
		//b ;02
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJFactor","CT.WDT.CDSS.DiseJFactor","疾病关联诊断因子",id,DiseaseNameFlag_"-"_DiagFactorNameFlag,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联诊断因子","web.CDSS.CMKB.DiseJFactor","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:通过id获取疾病关联诊断因子内容
/// Table: CT.WDT.CDSS.DiseJFactor
/// Input: id 疾病关联诊断因子id
/// Return: 疾病关联诊断因子内容
/// others:w ##class(web.CDSS.CMKB.DiseJFactor).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DiseJFactor).%New()
	s eobj.RowId= id
	s eobj.DiseaseDR = $LISTGET($G(^CT.WDT.CDSS.DiseJFactorD(id)),2)
	s eobj.FactorDR= $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),3)
	s eobj.FactorType = $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),4)
	s eobj.FactorGrade = $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),5)
	s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),6)
	s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),7)
	s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),8)
	s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),9)
	s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),10)
	s eobj.IsShow= $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),11)
	s eobj.Remarks= $lg($g(^CT.WDT.CDSS.DiseJFactorD(id)),12)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-12-29
/// Description:根据疾病ID获取该疾病的疾病与诊断因子表、诊断因子组合表、诊断属性表内容的日志 生成临时global
/// Input: DiseID 疾病ID
/// Return: 是否成功 
/// others:w ##class(web.CDSS.CMKB.DiseJFactor).CreateTEMPLogGlobal("182")
ClassMethod CreateTEMPLogGlobal(DiseID As %String)
{
	s str="sucess"	
	k ^TEMPDiseLog
	//疾病关联诊断因子的日志
	s FactorID="",ClassName="CT.WDT.CDSS.DiseJFactor"
    for
    {
    	s FactorID=$o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseID,FactorID)) q:FactorID="" 
		s ID="",ClassName="CT.WDT.CDSS.DiseJFactor"
	    for
	    {
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,FactorID,ID)) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
          	s ^TEMPDiseLog("DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"
	    }
    }
    //疾病关联诊断因子组合的日志
	s FactorCombID="",ClassName="CT.WDT.CDSS.DiseJFactorComb"
	for
	{
		s FactorCombID = $o(^CT.WDT.CDSS.DiseJFactorCombI("DiseaseDRIndex",DiseID,FactorCombID)) q:FactorCombID=""
		s ID=""
	    for
	    {
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,FactorCombID,ID),-1) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
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
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,PropertyID,ID)) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),13)   //新增对象描述
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
/// Description:获得疾病与诊断因子表、诊断因子组合表、诊断属性表内容的日志
/// Table: CT.WDT.CDSS.DiseaseDict,CT.WDT.CDSS.DiseJFactor,CT.WDT.CDSS.DiseJProperty
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有疾病与诊断因子表、诊断因子组合表、诊断属性表内容的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseJFactor","GetDiseLogList","8250")
Query GetDiseLogList(DiseID As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetDiseLogListExecute(ByRef qHandle As %Binary, DiseID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (DiseID'="") s str=##class(web.CDSS.CMKB.DiseJFactor).CreateTEMPLogGlobal(DiseID)
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
/// CreatDate:2021-01-20
/// Description:把疾病关联诊断因子导入知识库
/// Table:CT.WDT.CDSS.DiseJFactor、CT.WDT.CDSS.DiagFactorBase
/// Input:FilePath-csv文件路径
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJFactor).ImportDiseJFactor("F:\基础数据平台文档\CDSS\诊断因子新增-0726.csv")
ClassMethod ImportDiseJFactor(FilePath)
{
	s file=##class(%File).%New(FilePath)
	s result=""
	d file.Open("RS")
	d file.ReadLine()
	s count=0
	while 'file.AtEnd
	{
		s str=file.ReadLine()
	    s DiseaseName=$p(str,",",1)
	    s DiseaseName=$Zstrip(DiseaseName,"<>W")
	    
	    s DiagFactorName=$p(str,",",2) 
	    s DiagFactorName=$Zstrip(DiagFactorName,"<>W")
	    s FactorType=$p(str,",",10)
	    s FactorGrade = $p(str,",",3)
	    
	    if ($p(str,",",4)="")
	    {
		    s IsNegatCondi=0
		}
		else
		{
			s IsNegatCondi= $p(str,",",4)
		}
		if ($p(str,",",5)="")
	    {
		    s IsNecessAndSuffiCondi=0
		}
		else
		{
			s IsNecessAndSuffiCondi= $p(str,",",5)
		}
		if ($p(str,",",6)="")
	    {
		    s IsNecessCondi=0
		}
		else
		{
			s IsNecessCondi= $p(str,",",6)
		}
		
		if ($p(str,",",8)="")
	    {
		    s IsHospRecall=0
		}
		else
		{
			s IsHospRecall= $p(str,",",8)
		}
		if ($p(str,",",7)="")
	    {
		    s IsOutpatientRecall=0
		}
		else
		{
			s IsOutpatientRecall= $p(str,",",7)
		}
		if ($p(str,",",9)="")
	    {
		    s IsShow=0
		}
		else
		{
			s IsShow= $p(str,",",9)
		}
		
		//s Remarks= $p(str,",",9)
	
		s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		if (DiseaseDR="")
		{
			w !,DiseaseName_","_DiagFactorName_"没有导入成功"
		}
		continue:DiseaseDR=""
		
		s FactorDR=$o(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_$ZCONVERT(DiagFactorName,"U"),0))
		if (FactorDR="")
		{
			s Factorobj=##class(CT.WDT.CDSS.DiagFactorBase).%New()
			s dataid = $o(^CT.WDT.CDSS.DiagFactorBaseD(""),-1)
			if (dataid="")
			{
				s Factorobj.DiagFactorCode=1
			}
			else
			{
				s code = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(dataid)),2)
			    s Factorobj.DiagFactorCode = code+1
			}
				
       		s Factorobj.DiagFactorName = DiagFactorName
			s Factorobj.DiagFactorClass = FactorType
			s Factorobj.UseFlag = 0
			s Factorobj.CreateDate = $ZDATETIME($h,3)
			s Factorobj.CreateUserID = "dhcc"
			
       		s Factorsc=Factorobj.%Save()
			d Factorobj.%Close()
        	if $$$ISOK(Factorsc)
			{
				s FactorDR= Factorobj.%Id()
				if ('$d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(DiagFactorName,"U"))))
				{
					s Wordsobj=##class(CT.WDT.CDSS.IdentifyWords).%New() 
					s Wordsobj.WordsCode = ##class(web.CDSS.CMKB.IdentifyWords).GetLastCode()
					s Wordsobj.WordsDesc = DiagFactorName 
					s Wordsobj.UpdateDate = $zdt($h,3)
					s Wordssc=Wordsobj.%Save()
					d Wordsobj.%Close()
		        	if $$$ISOK(Wordssc)
					{
						
					}
					else
					{
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(Wordssc)_"'}"  //返回错误信息
						w !,DiseaseName_","_DiagFactorName_"识别词没有导入成功"
					}
					k Wordsobj
				}
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(Factorsc)_"'}"  //返回错误信息
				w !,DiseaseName_","_DiagFactorName_"诊断因子没有导入成功"
			}
			k Factorobj
		}
		continue:FactorDR=""
		
		s eobj = ##class(web.CDSSEntity.CMKB.DiseJFactor).%New()
		s eobj.DiseaseDR = DiseaseDR
		s eobj.FactorDR = FactorDR
		s eobj.DiagFactorName= FactorDR
		s eobj.FactorType = FactorType
		s eobj.FactorGrade = FactorGrade
		s eobj.IsNegatCondi = IsNegatCondi
		s eobj.IsNecessAndSuffiCondi = IsNecessAndSuffiCondi
		s eobj.IsNecessCondi = IsNecessCondi
		s eobj.IsHospRecall = IsHospRecall
		s eobj.IsOutpatientRecall = IsOutpatientRecall
		s eobj.IsShow = IsShow
		
			
		s result=..SaveData(eobj)
		if (result["false")&(result'["该记录已存在")
		{
			b ;11
			w !,DiseaseName_","_DiagFactorName_"疾病关联诊断因子没有导入成功"
		}
		else
		{
			s count=count+1
		}
	
        k eobj
	}
	q "导入疾病关联诊断因子"_count_"条！"
}

/// Creator:丁亚男
/// CreatDate:2021-06-25
/// Description:把疾病关联诊断因子2.0数据同步1.0
/// Table:CT.WDT.CDSS.DiseJFactor、CT.WDT.CDSS.DiagFactorBase
/// Input:
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJFactor).SynchroData()
ClassMethod SynchroData()
{
	s deletecount=0,addcount=0
	s DiseaseRowId=0
	for
	{
		s DiseaseRowId = $o(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)) q:DiseaseRowId=""
		//遍历1.0的疾病关联诊断因子
		s DiagFactorDR = 0
		for
		{
			s DiagFactorDR = $o(^CT.WDT.CDSS.DiseJoinFactorI("DiseFacorIndex",DiseaseRowId,DiagFactorDR)) q:DiagFactorDR=""
			s DiseJFRowId = 0
			for
			{
				s DiseJFRowId = $o(^CT.WDT.CDSS.DiseJoinFactorI("DiseFacorIndex",DiseaseRowId,DiagFactorDR,DiseJFRowId)) q:DiseJFRowId=""
				s DiseJFDesc = $lg($g(^CT.WDT.CDSS.DiagFactorDictD(DiagFactorDR)),3)
				s FactorDR=""
				s:DiseJFDesc'="" FactorDR=$o(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_$ZCONVERT(DiseJFDesc,"U"),0)) 
				if (FactorDR="")
				{
					s deletefactorres=##class(web.CDSS.CMKB.DiseJoinFactor).DeleteData(DiseJFRowId)  //2.0不存在的数据删除
					if (deletefactorres["true")
					{
						s deletecount=deletecount+1
					}
				}
				else
				{
					if ('$d(^CT.WDT.CDSS.DiseJFactorI("FactorDRIndex",DiseaseRowId,FactorDR)))
					{
						s deleteres=##class(web.CDSS.CMKB.DiseJoinFactor).DeleteData(DiseJFRowId)  //2.0不存在的数据删除
						if (deleteres["true")
						{
							s deletecount=deletecount+1
						}
					}
				}
			}
		}
		
		//遍历2.0的疾病关联诊断因子  判断在1.0中是否存在，不存在则在关联临床表现和关联诊断因子增加一条
	 	if ($d(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId)))
	 	{
		 	s DiseJFactor=0
		 	for 
		 	{
			 	s DiseJFactor=$O(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId,DiseJFactor)) q:DiseJFactor=""
			 	s FactorDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactor)),3)
			 	if (FactorDR'="")
			 	{
				 	s DiagFactorName=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
				 	if '$d(^CT.WDT.CDSS.DiseJoinSymptomI("SymNameIndex",DiseaseRowId,DiagFactorName))
				 	{
					 	s FactorGrade= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactor)),5)
						s IsNegatCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactor)),6)
						
						s IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactor)),8)
							
						
						s eobj = ##class(web.CDSSEntity.CMKB.DiseJoinSymptom).%New()
						s eobj.DiseaseDR = DiseaseRowId
						s eobj.SymptomName=DiagFactorName
						
						s eobj.SymptomTime="CDD01504"
						s eobj.DiagFactorType=0
						if IsNegatCondi=1
						{
							s eobj.DiagFactorWeights=""
							s eobj.DiagFactorGrade ="CDD00904"
						}
						else
						{
							s eobj.DiagFactorWeights=$CASE(FactorGrade,1:0.2,2:0.4,3:0.6,4:0.8,1:0.2,:"")
						 	s eobj.DiagFactorGrade =$CASE(FactorGrade,1:"CDD00904",2:"CDD00903",3:"CDD00903",4:"CDD00902",1:"CDD00901",:"CDD00904")
						}
						s sysres=##class(web.CDSS.CMKB.DiseJoinSymptom).SaveData(eobj)
						if (sysres["true")
						{
							s addcount=addcount+1
						}
					}
				}
				
				
				
		 	}
	 	}
	}
	q "删除1.0版本的疾病关联诊断因子"_deletecount_"条！新增1.0版本疾病关联诊断因子"_addcount_"条！"
}

/// Creator:丁亚男
/// CreatDate:2021-06-25
/// Description:复制疾病的诊断因子到其他疾病
/// Table:CT.WDT.CDSS.DiseJoinFactor
/// Input:CopyDisease --复制的疾病名称 ToDisease--复制到的疾病名称
/// Return: 是否复制成功及提示
/// Other:w ##class(web.CDSS.CMKB.DiseJFactor).CopyFactorToOther()
ClassMethod CopyFactorToOther(CopyDiseaseID, ToDisease)
{
	if (CopyDiseaseID="") q "{success:'false',errorinfo:'复制疾病为空'}"
	if (ToDisease="") q "{success:'false',errorinfo:'需要复制的疾病为空'}"
	
	s result="{success:'true',errorinfo:'复制成功！'}",info=""
	
	//复制诊断因子
	s RowId = 0
	for
	{
		s RowId = $o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",CopyDiseaseID,RowId)) q:RowId=""
		s FactorDR = $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),3)
		s DiagFactorName=""
		s DiagFactorName=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
		if ('$d(^CT.WDT.CDSS.DiseJFactorI("FactorDRIndex",ToDisease,FactorDR)))
		{
			s eobj = ##class(web.CDSSEntity.CMKB.DiseJFactor).%New()
			s eobj.DiseaseDR = ToDisease
			s eobj.FactorDR = FactorDR
			s eobj.DiagFactorName= FactorDR
			s eobj.FactorType= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),4)
			s eobj.FactorGrade= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),5)
			s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),6)
			s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),7)
			s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),8)
			s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),9)
			s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),10)
			s eobj.IsShow= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),11)
			s eobj.Remarks= $lg($g(^CT.WDT.CDSS.DiseJFactorD(RowId)),12)
			s Factorresult=##class(web.CDSS.CMKB.DiseJFactor).SaveData(eobj)
			if (Factorresult["false")
			{
				if (Factorresult'["记录已经存在")
				{
					s:info'="" info=info_","_DiagFactorName
					s:info="" info=DiagFactorName
				}
				
			}
			k eobj
		}
	}
	s:info'="" result="{success:'false',errorinfo:'"_info_"没有复制成功'}"
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-07-05
/// Description:把疾病关联诊断因子整理数据删除
/// Table:CT.WDT.CDSS.DiseJFactor、CT.WDT.CDSS.DiagFactorBase
/// Input:FilePath-csv文件路径
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJFactor).delDiseJFactor("F:\基础数据平台文档\CDSS\诊断因子导入数据-删除.csv")
ClassMethod delDiseJFactor(FilePath)
{
	s file=##class(%File).%New(FilePath)
	s result=""
	d file.Open("RS")
	d file.ReadLine()
	s count=0
	while 'file.AtEnd
	{
		s str=file.ReadLine()
	    s DiseaseName=$p(str,",",1)
	    s DiseaseName=$Zstrip(DiseaseName,"<>W")
	    
	    s DiagFactorName=$p(str,",",2) 
	    s DiagFactorName=$Zstrip(DiagFactorName,"<>W")
	    
	
		s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		if (DiseaseDR="")
		{
			w !,DiseaseName_"没有删除成功"
		}
		continue:DiseaseDR=""
		
		s FactorDR=$o(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_$ZCONVERT(DiagFactorName,"U"),0))
		if (FactorDR="")
		{
			w !,DiagFactorName_"没有删除成功"
		}
		continue:FactorDR=""
		
		s JFactorID=$o(^CT.WDT.CDSS.DiseJFactorI("FactorDRIndex",DiseaseDR,FactorDR,0))
  		
  		if (JFactorID'="")
  		{
	  		s result=..DeleteData(JFactorID)
			if (result["false")
			{
				w !,DiseaseName_","_DiagFactorName_"疾病关联诊断因子没有删除成功"
			}
			else
			{
				s count=count+1
			}
	  	}
  				
		
	}
	q "删除疾病关联诊断因子"_count_"条！"
}

/// Creator:丁亚男
/// CreatDate:2022-01-26
/// Description:疑似诊断不同状态的数据统计
/// Table:CT.WDT.CDSS.DiseaseDict,CT.WDT.CDSS.DiseJProperty
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.DiseJFactor).CountData()
ClassMethod CountData()
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	s DiseaseRowId=0
	for
	{
 		s DiseaseRowId = $o(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)) q:DiseaseRowId=""
 		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),18)
 		continue:UseFlag=1
	 	if ($d(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId)))
	 	{
		 	s DiseJPropertyID=$O(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId,0)) q:DiseJPropertyID=""
		 	s Status=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),30)
		 	//（初始、编辑中、待审核、审核不通过、已上线、已下线，默认初始）
		 	if (Status="初始")||(Status="编辑中")||(Status="审核不通过")
		 	{
			 	s Totalcount=Totalcount+1
			 	if ($d(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId))||$d(^CT.WDT.CDSS.DiseJIWordsI("DiseaseDRIndex",DiseaseRowId)))
			 	{
			 		s Editcount=Editcount+1	
			 	}
			}
			elseif (Status="已上线")
			{
				s Totalcount=Totalcount+1
			 	s Reviewedcount=Reviewedcount+1		
			}
			elseif (Status="待审核")
			{
				s Totalcount=Totalcount+1
			 	s Tobereviewedcount=Tobereviewedcount+1		
			}
				
		}
	}
	q Totalcount_"^"_Editcount_"^"_Reviewedcount_"^"_Tobereviewedcount
}

/// Creator：丁亚男
/// CreatDate:2022-11-1
/// Description：导出疾病字典表及属性表数据
/// Other:w ##class(web.CDSS.CMKB.DiseJFactor).ExportDatatoTXT()
ClassMethod ExportDatatoTXT()
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"疾病关联诊断因子数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	o file:"NWS"
	u file
	w "疾病编码	疾病名称	科室	诊断因子	状态"
	//d file.WriteLine()
	
	s DiseaseRowId=0
	for
	{
 		s DiseaseRowId = $o(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)) q:DiseaseRowId=""
 		s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),2)
 		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),3)
		s CommonDept="",Status=""
	 	if ($d(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId)))
	 	{
		 	s DiseJPropertyID=$O(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId,0)) q:DiseJPropertyID=""
		 	s CommonDeptDRs=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),19)
		 	if (CommonDeptDRs'="")
		 	{
			 	s DeptLen=$L(CommonDeptDRs,",")
			 	for iDept=1:1:DeptLen
			 	{
				 	s DeptDR=$p(CommonDeptDRs,",",iDept)
				 	s:CommonDept'="" CommonDept=CommonDept_","_$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				 	s:CommonDept="" CommonDept=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				}
			}
		 	
		 	s Status=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),30)
		 		
		}
		s:Status="" Status="初始"
		s FactorName=""
	 	if ($d(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId)))
	 	{
		 	s DiseJFactor=0
		 	for 
		 	{
			 	s DiseJFactor=$O(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowId,DiseJFactor)) q:DiseJFactor=""
			 	s FactorDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFactor)),3)
			 	if (FactorDR'="")
			 	{
				 	s DiagFactorName=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
					s:FactorName'="" FactorName=FactorName_","_DiagFactorName
					s:FactorName="" FactorName=DiagFactorName
				}
			}
		 	
		}	 	
	 		
		w !,DiseaseCode_"	"_DiseaseName_"	"_CommonDept_"	"_FactorName_"	"_Status
			
	}
	c file
	q fileName
}

}
