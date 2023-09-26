/// Description: 辨证论治管理
/// Creator: 基础数据平台组 - 胡宜良
/// Date: 2022-02-08
Class web.CDSS.CMKB.TCMDiseSymJWords Extends %RegisteredObject
{

/// Creator：胡宜良
/// CreatDate: 2022-02-08
/// Description：获得中医疾病与识别词字典表、中医疾病关联属性表内容
/// Table:User. DHCDSSTCMDisease中医疾病字典
/// Input:DiseID 中医疾病字典表RowID
/// Output:返回所有中医疾病关联识别词表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDiseSymJWords","GetTCMDiseList","","A01.01.01","","","","","","","","","","")
Query GetTCMDiseList(Rowid As %String, DiseCode As %String, DiseDesc As %String, AVersion As %String, CDept As %String, FName As %String, SStatus As %String, SResponUser As %String, SReviewUser As %String, SUpdateDate As %String, EUpdateDate As %String, TCMSym As %String) As %Query(ROWSPEC = "DiseaseRowId,DiseaseCode,DiseaseName,AppliVersion,CommonDept,UpdateDate,ResponUser,ReviewUser,Status,WordsName,SymptomName,TCMSymDR")
{
}

ClassMethod GetTCMDiseListExecute(ByRef qHandle As %Binary, Rowid As %String, DiseCode As %String, DiseDesc As %String, AVersion As %String, CDept As %String, FName As %String, SStatus As %String, SResponUser As %String, SReviewUser As %String, SUpdateDate As %String, EUpdateDate As %String, TCMSym As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s DiseaseRowId=Rowid
 	if (DiseaseRowId'="")
 	{
	 	s DiseaseCode=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),2)
	 	s DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),3)
	 	
	 	/*s TCMSymDR=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(DiseaseRowId)),3) //证型
	 	s:TCMSymDR'="" SymptomName=$lg($g(^CT.WDT.CDSS.SymptomDictD(TCMSymDR)),3) //证型
	 	s:TCMSymDR="" SymptomName=""*/
	 	
	 	
	 	
	 	s UpdateDate=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),6) //最后操作时间为空时默认为导入时间
	 	s AppliVersion="",CommonDept="",UpdateDate="",ResponUser="",ReviewUser="",Status=""
	 	if ($d(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId)))
	 	{
		 	s TCMDiseJPropertyID=$O(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId,0)) q:TCMDiseJPropertyID=""
		 	s CommonDeptDRs=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),19)
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
			
			
		 	s AppliVersion=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),26)
		 	s UpdateDate=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),27)
		 	s ResponUser=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),28)
		 	s ReviewUser=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),29)
		 	s Status=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),30)
		 	
		}
		s:ResponUser="" ResponUser="dhcc" //责任人为空的话，默认dhcc
		s:Status="" Status="初始"
		
		
		s WordsName=""
	 	if ($d(^CT.WDT.CDSS.TCMDiseJWordsI("DiseSymDRIndex",DiseaseRowId)))
	 	{
		 	s DiseJWords=0
		 	for 
		 	{
			 	s DiseJWords=$O(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DiseaseRowId,DiseJWords)) q:DiseJWords=""
			 	s WordDR=$lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DiseJWords)),3)
			 	if (WordDR'="")
			 	{
				 	
				 	s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
					s:WordsName'="" WordsName=WordsName_","_WordsDesc
					s:WordsName="" WordsName=WordsDesc
					
				}
			}
				
		}
		if ($d(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",DiseaseRowId))>0) 
		{
			s TCMSymDR=""
			for 
			{
				s TCMSymDR=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",DiseaseRowId,TCMSymDR))
				q:TCMSymDR=""
				//b ;1
				s SymptomName=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(TCMSymDR)),3) //证型
				//b ;2	  		
				s TCMDiseJSymID=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",DiseaseRowId,TCMSymDR,0)) 
				q:TCMDiseJSymID=""
				
				if (TCMSymDR'="")
				{
					s Status=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(TCMDiseJSymID)),7)
				}
				d OutputTCMRow
			}
		}
		else{
			do OutputTCMRow
		}
	}
	else
	{
		s:DiseCode'="" DiseCode=$ZCONVERT(DiseCode,"U") //转换成大写
		s:DiseDesc'="" DiseDesc=$ZCONVERT(DiseDesc,"U") //转换成大写
		s:CDept'="" CDept=$ZCONVERT(CDept,"U") //转换成大写
		s:FName'="" FName=$ZCONVERT(FName,"U") //转换成大写
		s:SResponUser'="" SResponUser=$ZCONVERT(SResponUser,"U") //转换成大写
		s:SReviewUser'="" SReviewUser=$ZCONVERT(SReviewUser,"U") //转换成大写
		s:TCMSym'="" TCMSym=$ZCONVERT(TCMSym,"U") //转换成大写
	
			s DiseaseRowId=0
			for
			{
		 		s DiseaseRowId = $o(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId))
		 		q:DiseaseRowId=""
		 		
		 		s DiseaseCode=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),2)
		 		
		 		s DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),3)
		 		s UseFlag = $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),7)
		 		continue:UseFlag=1

		 		s SymptomName=""
		 		
		 		s UpdateDate=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(DiseaseRowId)),4) //操作时间
	 			s AppliVersion="",CommonDept="",UpdateDate="",ReviewUser="",ResponUser="",Status=""
	 			
			 	if ($d(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId)))
			 	{
				 	s TCMDiseJPropertyID=$O(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId,0)) q:TCMDiseJPropertyID=""
				 	s CommonDeptDRs=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),19)
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
				 	s AppliVersion=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),26)
				 	s UpdateDate=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),27)
				 	
				 	s ResponUser=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),28)
				 	s ReviewUser=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),29)
				 	s Status=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),30)
				 		
				}
		
				s:ResponUser="" ResponUser="dhcc" //责任人为空的话，默认dhcc
				s:Status="" Status="初始"
				s WordsName=""
				
			 	if ($d(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DiseaseRowId)))
			 	{
				 	s DiseJWords=0
				 	for 
				 	{
					 	s DiseJWords=$O(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DiseaseRowId,DiseJWords))
					 	q:DiseJWords=""
					 	s WordDR=$lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DiseJWords)),3)
					 	if (WordDR'="")
					 	{
						 	
						 	s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
							s:WordsName'="" WordsName=WordsName_","_WordsDesc
							s:WordsName="" WordsName=WordsDesc
							
						}
					}
				 	
				}
				
				s UpdateDateUDate="", UpdateDateUTime=""
				if (UpdateDate'="")
				{ 
					s UpdateDateU=$ZDTH(UpdateDate,3)
					s UpdateDateUDate=$p(UpdateDateU,",",1)
					s UpdateDateUTime=$p(UpdateDateU,",",2)
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
			  	if ($ZCONVERT(DiseaseCode,"U")[DiseCode)&&(($ZCONVERT(DiseaseName,"U")[DiseDesc)||(PINYIN[DiseDesc))&&(AppliVersion[AVersion)&&(CommonDept[CDept)&&(WordsName[FName)&&(Status[SStatus)&&($ZCONVERT(ResponUser,"U")[SResponUser)
			  	&&($ZCONVERT(ReviewUser,"U")[SReviewUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)	//过滤条件
			  	{
				  	if ($d(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",DiseaseRowId))>0) 
				  	{
					  	s TCMSymDR=""
					  	for 
				  		{
					  		s TCMSymDR=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",DiseaseRowId,TCMSymDR))
					  		q:TCMSymDR=""
					  		//b ;11
					  		s SymptomName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymDR)),3) //证型
					  		//b ;21
					  		s TCMDiseJSymID=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",DiseaseRowId,TCMSymDR,0)) //q:TCMDiseJSymID=""
					 		if (TCMSymDR'=""){
					 			s Status=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(TCMDiseJSymID)),7)
								s:Status="" Status="初始"
					 		}
					  		continue:((TCMSym'="")&&($ZCONVERT(SymptomName,"U")'[TCMSym))
					  		d OutputTCMRow
					  	}
					}
					else
					{
						if (TCMSym="")||(Rowid="")||(DiseCode="")||(DiseDesc="")||(AVersion="")||(CDept="")||(FName="")||(SStatus="")||(SResponUser="")||(SReviewUser="")||(SUpdateDate="")||(EUpdateDate="")
						{
						d OutputTCMRow
						}

					}
					
			 	}
			 	
			}
		
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTCMRow
	set Data=$lb(DiseaseRowId,DiseaseCode,DiseaseName,AppliVersion,CommonDept,UpdateDate,ResponUser,ReviewUser,Status,WordsName,SymptomName,TCMSymDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTCMDiseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetTCMDiseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTCMDiseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：胡宜良
/// CreatDate: 2022-02-08
/// Description:获得中医辩证识别词内容
/// Table: CT.WDT.CDSS.TCMDiseSymJWords
/// Input: DiseID 中医疾病字典表RowID
/// Return:返回所有中医辩证识别词表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDiseSymJWords","GetList","14","")
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
		s RowId = $o(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DiseID,RowId)) q:RowId=""
		
		s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),3)
		s WordsDescF=WordDR
		s WordsDesc =""
		s:WordDR'="" WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		s WordType= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),4)
		s WordGrade= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),5)
		s WordGradeF=WordGrade
		s IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),6)
		s IsNegatCondiF=IsNegatCondi
		s IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),7)
		s IsNecessAndSuffiCondiF=IsNecessAndSuffiCondi
		s IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),8)
		s IsNecessCondiF=IsNecessCondi
		s IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),9)
		s IsHospRecallF=IsHospRecall
		s IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),10)
		s IsOutpatientRecallF=IsOutpatientRecall
		s IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),11)
		s IsShowF=IsShow
		s Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),12)	
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
/// CreatDate: 2022-02-09
/// Description：查询 下拉框
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDiseSymJWords","GetDataForCmb1","","182","")
Query GetDataForCmb1(rowid As %String, DiseID As %String, desc As %String) As %Query(ROWSPEC = "TCMDiseSymJWordsDR:%String,WordsDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, DiseID As %String, desc As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  	s TCMDiseSymJWordsDR=rowid
  	s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(TCMDiseSymJWordsDR)),3)
	s WordsDesc =""
	s:WordDR'="" WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
  	d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s TCMDiseSymJWordsDR=""
  for{  
	  s TCMDiseSymJWordsDR=$o(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DiseID,TCMDiseSymJWordsDR)) q:TCMDiseSymJWordsDR=""  
	  s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(TCMDiseSymJWordsDR)),3)
	  s WordsDesc =""
	  s:WordDR'="" WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(WordsDesc)  
	  if (($ZCONVERT(WordsDesc,"U")[desc)||(PINYIN[desc)) {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(TCMDiseSymJWordsDR,WordsDesc)
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

/// Creator：胡宜良
/// CreatDate: 2022-02-09
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.TCMDiseSymJWords
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).FormValidate("","1","")
ClassMethod FormValidate(id As %String, TCMDiseSymDR As %String, WordDR As %String) As %String
{
	q:(TCMDiseSymDR="")||(WordDR="") ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.TCMDiseSymJWordsI("ConIndex",TCMDiseSymDR,WordDR))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.TCMDiseSymJWordsI("ConIndex",TCMDiseSymDR,WordDR,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// Creator：胡宜良
/// CreatDate: 2022-02-09
/// Description:保存中医辩证识别词表内容
/// Table: CT.WDT.CDSS.TCMDiseSymJWords
/// Input: eobj 中医辩证识别词表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).SaveData(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TCMDiseSymJWords)
{
	s $zt="ERROR"
	s result=""
	//s ^TMP("HYL")="123"
	
	if $IsObject(eobj)
	{
		//s ^TMP("HYL")=^TMP("HYL")_1
		s eobj.WordDR=eobj.WordsDesc
		s flag=..FormValidate(eobj.RowId,eobj.TCMDiseSymDR,eobj.WordsDesc)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}

		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			
			s obj=##class(CT.WDT.CDSS.TCMDiseSymJWords).%New()	
		}
		
		else  //如果RowId已赋值则修改
		{
			//s ^TMP("HYL")=^TMP("HYL")_2
			s obj=##class(CT.WDT.CDSS.TCMDiseSymJWords).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseSymJWords).%New()
			if $IsObject(obj.TCMDiseSymDR)
			{
			 	s bobj.TCMDiseSymDR = obj.TCMDiseSymDR.%Id()
			}
			if $IsObject(obj.WordDR)
			{
			 	s bobj.WordDR = obj.WordDR.%Id()
			}
			//s ^TMP("HYL")=^TMP("HYL")_3
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
		//s ^TMP("HYL")=^TMP("HYL")_4
		d:eobj.TCMDiseSymDR'="" obj.TCMDiseSymDRSetObjectId(eobj.TCMDiseSymDR)
		//s ^TMP("HYL")=^TMP("HYL")_5
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
			d ##class(web.CDSS.CMKB.TCMDiseJProperty).AddResponUser(eobj.TCMDiseSymDR,eobj.OperationUser)
			//保存和更新 中医辩证识别词必要条件数据
			if ((eobj.RowId="")&(eobj.IsNecessCondi=1))||((eobj.RowId'="")&&(eobj.IsNecessCondi'=bobj.IsNecessCondi))
			{
				d ##class(web.CDSS.CMKB.TCMDiseJProperty).UpdateNumOfNConditions(eobj.TCMDiseSymDR)
			}
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseSymJWords","CT.WDT.CDSS.TCMDiseSymJWords","中医辩证识别词",id,eobj.WordDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseSymJWords","CT.WDT.CDSS.TCMDiseSymJWords","中医辩证识别词",eobj.RowId,eobj.WordDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医辩证识别词","web.CDSS.CMKB.TCMDiseSymJWords","SaveEntity",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医辩证识别词","web.CDSS.CMKB.TCMDiseSymJWords","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：胡宜良
/// CreatDate: 2022-09-09
/// Description:保存中医辩证识别词表内容
/// Table: CT.WDT.CDSS.TCMDiseSymJWords
/// Input: RowId, TCMDiseSymDR, WordDR, WordType, WordGrade, IsNegatCondi, IsNecessAndSuffiCondi, IsNecessCondi, IsHospRecall, IsOutpatientRecall, IsShow, Remarks
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).SaveData()
ClassMethod SaveData(RowId, TCMDiseSymDR, WordDR, WordType, WordGrade, IsNegatCondi, IsNecessAndSuffiCondi, IsNecessCondi, IsHospRecall, IsOutpatientRecall, IsShow, Remarks)
{
	//b ;q
	s result=""
	s flag=..FormValidate(RowId,TCMDiseSymDR,WordDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在'}"
		}
		
		if (RowId="")	//如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseSymJWords).%New()	
		}
		else  			//如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseSymJWords).%OpenId(RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseSymJWords).%New()
			if $IsObject(obj.TCMDiseSymDR)
			{
			 	s bobj.TCMDiseSymDR = obj.TCMDiseSymDR.%Id()
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
		d obj.TCMDiseSymDRSetObjectId(TCMDiseSymDR)	
		d obj.WordDRSetObjectId(WordDR)	
		//b ;1
		//d obj.OperationGradeSetObjectId(OperationGrade)
		s obj.WordType = WordType
		s obj.WordGrade = WordGrade	
		s obj.IsNegatCondi = IsNegatCondi
		s obj.IsNecessAndSuffiCondi = IsNecessAndSuffiCondi
		s obj.IsNecessCondi = IsNecessCondi
		s obj.IsHospRecall = IsHospRecall
		s obj.IsOutpatientRecall = IsOutpatientRecall
		s obj.IsShow = IsShow
		s obj.Remarks= Remarks

		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			//保存和更新 中医辩证识别词必要条件数据
			if ((RowId="")&(IsNecessCondi=1))||((RowId'="")&&(IsNecessCondi'=IsNecessCondi))
			{
				d ##class(web.CDSS.CMKB.TCMDiseJProperty).UpdateNumOfNConditions(TCMDiseSymDR)
			}
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医辩证识别词","web.CDSS.CMKB.TCMDiseSymJWords","SaveData")
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	q result
}

/// Creator：胡宜良
/// CreatDate: 2022-02-09
/// Description:删除中医辩证识别词表内容
/// Table: CT.WDT.CDSS.TCMDiseSymJWords
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.TCMDiseSymJWords).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseSymJWords).%New()
	if $IsObject(obj.TCMDiseSymDR)
	{
	 	s bobj.TCMDiseSymDR = obj.TCMDiseSymDR.%Id()
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
			
	s sc=##class(CT.WDT.CDSS.TCMDiseSymJWords).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseSymJWords","CT.WDT.CDSS.TCMDiseSymJWords","中医辩证识别词",id,bobj.WordDR,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医辩证识别词","web.CDSS.CMKB.TCMDiseSymJWords","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：胡宜良
/// CreatDate: 2022-02-09
/// Description:通过id获取中医辩证识别词内容
/// Table: CT.WDT.CDSS.TCMDiseSymJWords
/// Input: id 中医辩证识别词id
/// Return: 中医辩证识别词内容
/// others:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseSymJWords).%New()
	s eobj.RowId= id
	s eobj.TCMDiseSymDR = $LISTGET($G(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),2)
	s eobj.WordDR= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),3)
	s eobj.WordType = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),4)
	s eobj.WordGrade = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),5)
	s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),6)
	s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),7)
	s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),8)
	s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),9)
	s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),10)
	s eobj.IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),11)
	s eobj.Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),12)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator：胡宜良
/// CreatDate: 2022-02-09
/// Description:根据疾病ID获取该疾病的中医辩证识别词、中医疾病关联属性内容的日志 生成临时global
/// Input: DiseID 疾病ID
/// Return: 是否成功 
/// others:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).CreateTEMPLogGlobal("1257")
ClassMethod CreateTEMPLogGlobal(DiseID As %String)
{
	s str="sucess"	
	k ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog")
	//中医辩证识别词的日志
	s SymWordID="",ClassName="CT.WDT.CDSS.TCMDiseSymJWords"
    for
    {
    	s SymWordID=$o(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DiseID,SymWordID)) q:SymWordID="" 
		s ID="",ClassName="CT.WDT.CDSS.TCMDiseSymJWords"
		
	    for
	    {
	    	
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,SymWordID,ID)) q:ID=""
	    	
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
          	
          	s ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"        
	    }
    }
    
    //中医疾病识别词的日志
	s WordID="",ClassName="CT.WDT.CDSS.TCMDiseJWords"
    for
    {
    	s WordID=$o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DiseID,WordID)) q:WordID="" 
		s ID="",ClassName="CT.WDT.CDSS.TCMDiseJWords"
	    for
	    {
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,WordID,ID)) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
          	s ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"
	    }
    }
    //中医疾病关联属性的日志
	s PropertyID="",ClassName="CT.WDT.CDSS.TCMDiseJProperty"
	for
	{
		s PropertyID = $o(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseID,PropertyID)) q:PropertyID=""
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
	          	s ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_Opreation
	        }
         	else
         	{
          		s ^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^编辑"
         	}
	    }
    }
    //中医疾病关联属性的日志
	s TCMDisJSID="",ClassName="CT.WDT.CDSS.TCMDiseJSym"
	for
	{
		s TCMDisJSID = $o(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",DiseID,TCMDisJSID)) q:TCMDisJSID=""
		s ID=""
	    for
	    {
	    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,TCMDisJSID,ID)) q:ID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),13)   //新增对象描述
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
/// CreatDate: 2022-02-09
/// Description:获得中医疾病与中医辩证识别词表、中医疾病关联属性表内容的日志
/// Table: CT.WDT.CDSS.TCMDisease,CT.WDT.CDSS.TCMDiseSymJWords,CT.WDT.CDSS.TCMDiseJProperty
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有中医疾病与中医辩证识别词表、中医疾病关联属性表内容的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDiseSymJWords","GetDiseLogList","1257")
Query GetDiseLogList(DiseID As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetDiseLogListExecute(ByRef qHandle As %Binary, DiseID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (DiseID'="") s str=##class(web.CDSS.CMKB.TCMDiseSymJWords).CreateTEMPLogGlobal(DiseID)
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
		    	b ;1
		    	s Opreation=$P(^TEMPTCMDiseLog($ZNAME,$JOB,"DiseLog",UpdateDateID,UpdateTimeID),"^",3)
		    	b ;2
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
/// CreatDate: 2022-02-09
/// Description:把中医辩证识别词导入知识库
/// Table:CT.WDT.CDSS.TCMDiseSymJWords、CT.WDT.CDSS.IdentifyWords
/// Input:FilePath-csv文件路径
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).ImportTCMDiseSymJWords("D:\Works\TCMDiseSymJWords.csv")
ClassMethod ImportTCMDiseSymJWords(FilePath)
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
	    
	    s WordsDesc=$p(str,",",2) 
	    s WordsDesc=$Zstrip(WordsDesc,"<>W")
	    s WordType=$p(str,",",10)
	    s WordGrade = $p(str,",",3)
	    
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
		
		s TCMDiseSymDR=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		if (TCMDiseSymDR="")
		{
			w !,DiseaseName_","_WordsDesc_"没有导入成功"
		}
		continue:TCMDiseSymDR=""
		
		s WordDR=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(WordsDesc,"U"),0))
		if (WordDR="")
		{
			s Wordsobj=##class(CT.WDT.CDSS.IdentifyWords).%New()
			s dataid = $o(^CT.WDT.CDSS.IdentifyWordsD(""),-1)
			if (dataid="")
			{
				s Wordsobj.WordsCode=1
			}
			else
			{
				s code = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(dataid)),2)
			    s Wordsobj.WordsCode = code+1
			}
				
       		s Wordsobj.WordsDesc = WordsDesc
			s Wordsobj.WordType = WordType
			s Wordsobj.UseFlag = 0
			s Wordsobj.CreateDate = $ZDATETIME($h,3)
			s Wordsobj.CreateUserID = "dhcc"
			
       		s Wordssc=Wordsobj.%Save()
			d Wordsobj.%Close()
        	
			
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(Wordssc)_"'}"  //返回错误信息
				w !,DiseaseName_","_WordsDesc_"识别词没有导入成功"
			
			k Wordsobj
		}
		continue:WordDR=""
		
		s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseSymJWords).%New()
		s eobj.TCMDiseSymDR = TCMDiseSymDR
		s eobj.WordDR = WordDR
		s eobj.WordsDesc= WordDR
		s eobj.WordType = WordType
		s eobj.WordGrade = WordGrade
		s eobj.IsNegatCondi = IsNegatCondi
		s eobj.IsNecessAndSuffiCondi = IsNecessAndSuffiCondi
		s eobj.IsNecessCondi = IsNecessCondi
		s eobj.IsHospRecall = IsHospRecall
		s eobj.IsOutpatientRecall = IsOutpatientRecall
		s eobj.IsShow = IsShow
		
			
		s result=..SaveData(eobj)
		if (result["false")&(result'["该记录已存在")
		{
			
			w !,DiseaseName_","_WordsDesc_"中医疾病关联识别词没有导入成功"
		}
		else
		{
			s count=count+1
		}
	
        k eobj
	}
	q "导入疾病关联识别词"_count_"条！"
}

/// Creator：胡宜良
/// CreatDate: 2022-02-16
/// Description:复制疾病的识别词到其他疾病
/// Table:CT.WDT.CDSS.TCMDiseSymJWords
/// Input:CopyDisease --复制的疾病名称 ToDisease--复制到的疾病名称
/// Return: 是否复制成功及提示
/// Other:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).CopyWordsToOther(3,16)
ClassMethod CopyWordsToOther(CopyDiseaseID, ToDisease)
{
	if (CopyDiseaseID="") q "{success:'false',errorinfo:'复制疾病为空'}"
	if (ToDisease="") q "{success:'false',errorinfo:'需要复制的疾病为空'}"
	
	s result="{success:'true',errorinfo:'复制成功！'}",info=""
	
	//复制识别词
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
			s eobj.TCMDiseSymDR = ToDisease
			s eobj.WordDR = WordDR
			s eobj.WordsDesc= WordDR
			s eobj.WordType= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),4)
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
/// Description:复制疾病的证型到其他疾病
/// Table:CT.WDT.CDSS.TCMDiseSymJWords
/// Input:CopyDisease --复制的疾病名称 ToDisease--复制到的疾病名称
/// Return: 是否复制成功及提示
/// Other:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).CopySymToOther(3,15)
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
			s eobj.TCMDiseSymDR = ToDisease
			s eobj.WordDR = WordDR
			s eobj.WordsDesc= WordDR
			s eobj.WordType= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(RowId)),4)
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
/// CreatDate:2022-02-22
/// Description:把疾病关联识别词转移到中医疾病关联辩证识别词表
/// Table:CT.WDT.CDSS.TCMDiseSymJWords、CT.WDT.CDSS.TCMDiseSymJWords
/// Input:DiseID 疾病的ID
/// Return:成功转移多少条数据
/// Other:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).TransferSingleDataToDJS("1257","733")
ClassMethod TransferSingleDataToDJS(DiseID, TCMSymDR)
{
	if (DiseID="")
	{
		q "请选中一条疾病！"
	}
	s count=0,fcount=0
	s DJFRowID=0
	
	for
	{
		s DJFRowID=$o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DiseID,DJFRowID)) q:DJFRowID=""
		
		s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),3)
		s WordsDesc =""
		s:WordDR'="" WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		b ;1
		s WordDR=$O(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,"中医识别条件",""))
		b ;2
		continue:(WordDR="")
		s WordsType=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),4)
		continue:(WordsType'="中医识别条件")
		s eobj=##class(web.CDSSEntity.CMKB.TCMDiseSymJWords).%New()
		s eobj.TCMDiseSymDR=TCMSymDR
		s eobj.WordDR=WordDR
		s eobj.WordsDesc=WordDR
		
		s eobj.WordType= "中医识别条件"
		s eobj.WordGrade= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),5)
		s eobj.IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),6)
		s eobj.IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),7)
		s eobj.IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),8)
		s eobj.IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),9)
		s eobj.IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),10)
		s eobj.IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),11)
		s eobj.Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),12)
			
		s result=..SaveData("",eobj.TCMDiseSymDR,eobj.WordDR,eobj.WordType,eobj.WordGrade,eobj.IsNegatCondi,eobj.IsNecessAndSuffiCondi,eobj.IsNecessCondi,eobj.IsHospRecall,eobj.IsOutpatientRecall,eobj.IsShow,eobj.Remarks)
		//s result=..SaveEntity(eobj)
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

/// Creator：胡宜良
/// CreatDate:2022-02-22
/// Description:辨证论治不同状态的数据统计
/// Table:User.DHCDSSDiseaseDict,User.DHCDSSDiseJProperty
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.TCMDiseSymJWords).CountData()
ClassMethod CountData()
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	s DiseaseRowId=0
	for
	{
 		s DiseaseRowId = $o(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)) q:DiseaseRowId=""
 		s UseFlag = $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),7)
 		continue:UseFlag=1
	 	if ($d(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId)))
	 	{
		 	s TCMDiseJPropertyID=$O(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId,0)) q:TCMDiseJPropertyID=""
		 	s Status=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),30)
		 	//（初始、编辑中、待审核、审核不通过、已上线、已下线，默认初始）
		 	if (Status="初始")||(Status="编辑中")||(Status="审核不通过")
		 	{
			 	s Totalcount=Totalcount+1
			 	if ($d(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DiseaseRowId))||$d(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DiseaseRowId)))
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

/// 辩证识别词异常数据处理
/// d ##class(web.CDSS.CMKB.TCMDiseSymJWords).DataDeal()
ClassMethod DataDeal()
{
	s result=""
	s ID=0,errordata=0,dealdata=0
	TS
	for
	{
		s ID=$o(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID))
		q:ID=""
		s TCMDiseSymDR= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),2)
		s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),3)
		
		s WordsDesc =""
		s:WordDR'="" WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		s IdWordType=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),4)
		s WordType= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),4)
		s WordGrade=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),5)
		s IsNegatCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(id)),6)
		s IsNecessAndSuffiCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),7)
		s IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),8)
		s IsHospRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),9)
		s IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),10)
		s IsShow= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),11)
		s Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(ID)),12) 
		if (IdWordType'="中医识别条件")||(WordType="") //&(WordType="未关联")
		{
			s errordata=errordata+1
			s WordDR=$O(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,"中医识别条件",""))
			s:WordDR'="" result=..SaveData(ID,TCMDiseSymDR,WordDR,"中医识别条件",WordGrade,IsNegatCondi,IsNecessAndSuffiCondi,IsNecessCondi,IsHospRecall,IsOutpatientRecall,IsShow,Remarks)
			if (result'["false")
			{
				s dealdata=dealdata+1
			}
		}
		
	}
	w "异常数据:"_errordata,!
	w "处理数据:"_dealdata,!
	
	q "{success:'true'}"
}

}
