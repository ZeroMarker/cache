/// 名称:实施综合管理平台-对接方检查检验字典表
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2021-1-4
Class web.CDSS.IMP.ConExamDict Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2021-1-4
/// Description：查询 对接方检查检验字典表
/// Table:CT.WDT.CDSS.ConExamDict 对接方检查检验字典表
/// Input:id ,code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConExamDict","GetList","","","","2","1","3")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ID,ExamCode,ExamName,ExamType,SpecimenCode,SpecimenName,Source,HospitalDR,DictHospDesc,Remarks,CreateDate,CreateUser,UpdateDate,UpdateUser")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		
		s ExamCode= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),2)		//代码
		s ExamName= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		//描述
		s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),4)		//类型（检查或者检验)
		s SpecimenCode=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),5)		//样本代码
		s SpecimenName=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),6)		//样本名称
		s Source=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),7)		//来源（住院/门诊/急诊）
		s DictHospDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(ID)),8)	//所属医院
		s:HospitalDR'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),9)		//备注
		s State=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),10)		//状态（未关联/已关联/已确认/已删除）
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),11)		//创建时间（数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),12)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),13)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),14)		//修改人

		d OutputRow	
	}
	else
	{
		//ID,ExamCode,ExamName,ExamType,SpecimenCode,SpecimenName,Source,HospitalDR,DictHospDesc,Remarks,CreateDate,CreateUser,UpdateDate,UpdateUser
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.ConExamDictD(ID))
			q:ID=""
			s ExamCode= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),2)		//代码
			continue:((code'="")&&($zconvert(ExamCode,"U")'[code))
			s ExamName= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		//描述
			continue:((desc'="")&&($zconvert(ExamCode,"U")'[desc))
			s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),4)		//类型（检查或者检验)
			s SpecimenCode=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),5)		//样本代码
			s SpecimenName=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),6)		//样本名称
			s Source=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),7)		//来源（住院/门诊/急诊）
			s DictHospDesc=""
			s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(ID)),8)	//所属医院
			s:HospitalDR'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
			s Remarks=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),9)		//备注
			s State=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),10)		//状态（未关联/已关联/已确认/已删除）
			s CreateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),11)		//创建时间（数据导入或者手动新增的时间）
			s CreateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),12)		//创建人
			s UpdateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),13)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s UpdateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),14)		//修改人
			d OutputRow
		
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,ExamCode,ExamName,ExamType,SpecimenCode,SpecimenName,Source,HospitalDR,DictHospDesc,Remarks,CreateDate,CreateUser,UpdateDate,UpdateUser)
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

/// Creator：钟荣枫 		
/// CreatDate: 2021-1-4
/// Description：查询 对接方检查检验字典的对照  
/// Table:CT.WDT.CDSS.ConExamDict 对接方检查检验字典表
/// Input:examid 稽查检验id,examcode 代码，examdesc 描述，hospid 医院id，state 状态，，source 来源，dictdesc 知识库描述，remark 备注，sortmethod 排序方式
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConExamDict","GetConList","","","","","","","","","","")
Query GetConList(examid As %String, examcode As %String, examdesc As %String, type As %String, hospid As %String, state As %String, source As %String, dictdesc As %String, remark As %String, contype As %String, sortmethod) As %Query(ROWSPEC = "RowID,ExamCode,ExamName,ExamType,SpecimenCode,SpecimenName,Source,HospitalDR,DictHospDesc,ConRemarks,DictID,DictCode,DictName,ConState,HospAreaDesc,HospitalAreaDR,ConExamType")
{
}

ClassMethod GetConListExecute(ByRef qHandle As %Binary, examid As %String, examcode As %String, examdesc As %String, type As %String, hospid As %String, state As %String, source As %String, dictdesc As %String, remark As %String, contype As %String, sortmethod) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:examcode'="" examcode=$ZCONVERT(examcode,"U") //转换成大写
	s:examdesc'="" examdesc=$ZCONVERT(examdesc,"U") //转换成大写
	s:dictdesc'="" dictdesc=$ZCONVERT(dictdesc,"U") //转换成大写
	//s:contype'="" contype=$ZCONVERT(contype,"U") //转换成大写
	
	//RowID,ExamCode,ExamName,ExamType,SpecimenCode,SpecimenName,Source,HospitalDR,DictHospDesc,Remarks,DictCode,DictName,ConState
	if (examid'="") //根据rowid返回该条记录
	{
		s ID=examid
				
		s HospAreaDR="",HospAreaDesc="",HospitalAreaDR=""
		for
		{
			s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","检查检验",ID,HospAreaDR))
			
			q:HospAreaDR=""
			s ParRef=$p(HospAreaDR,"||",1)
			s ChildSub=$p(HospAreaDR,"||",2)
			if (HospAreaDesc="")
			{
				s HospAreaDesc= $lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),3)		//院区名称
			}
			else
			{
				s HospAreaDesc=HospAreaDesc_"/"_$lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),3)		//院区名称
			}
			s HospitalAreaDR=HospAreaDR
		}
		
		s ExamCode= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),2)		//代码
		s ExamName= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		//描述
		s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),4)		//类型（检查或者检验)
		s SpecimenCode=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),5)		//样本代码
		s SpecimenName=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),6)		//样本名称
		s Source=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),7)		//来源（住院/门诊/急诊）
		s DictHospDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(ID)),8)	//所属医院
		s:HospitalDR'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),9)		//备注 {非检查检验项目/检查检验项目不明确/规则、治疗方案、详情等未涉及项目}
		s State=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),10)		//状态（未关联/已关联/已确认/已删除）
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),11)		//创建时间（数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),12)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),13)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),14)		//修改人
		s ConExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),17)     //客户类型
		
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,0))
		s DictNameStr="",DictCodeStr="",DictIDStr="" //知识库描述串、知识库代码串、ID串
		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

		if (haveState'="")  //如果有对照
		{
			//走对照表，找对接的知识库id、代码、描述
			s ContrastState=""
			for
			{
				s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,ContrastState))
				q:ContrastState=""
				
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,ContrastState,ConID))
					q:ConID=""
					
					s DictID=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)		//知识库字典ID
					s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
					s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
					//知识库描述串
					if (DictNameStr=""){
						s DictNameStr=DictName
					}
					else{
						s DictNameStr=DictNameStr_","_DictName
					}
					//知识库ID串
					if (DictIDStr=""){
						s DictIDStr=DictID
					}
					else{
						s DictIDStr=DictIDStr_","_DictID
					}	
					//知识库代码串
					if (DictCodeStr=""){
						s DictCodeStr=DictCode
					}
					else{
						s DictCodeStr=DictCodeStr_","_DictCode
					}		
					
					s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
					s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
					s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
					
				}				
			} 

		}
		s DictName=DictNameStr,DictCode=DictCodeStr,DictID=DictIDStr   //给需要输出的字段：知识库字典ID、代码、描述重新赋值，多个的话拼串
		d OutputConList
	
	}
	else
	{
		k ^TempDataHandle
		if (hospid'="")
		{
			if (sortmethod="Short")
			{
				s CreateTime=""
				for
				{
					s CreateTime=$o(^CT.WDT.CDSS.ConExamDictI("CreateDateIndex",hospid,CreateTime),-1)
					q:CreateTime=""
					s ID=0
					for 
					{
						s ID=$o(^CT.WDT.CDSS.ConExamDictI("CreateDateIndex",hospid,CreateTime,ID))
						q:ID=""
						s ExamCode= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),2)		//代码
						s ExamName= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		//通用名
						s length=$l(ExamName)
						s ^TempDataHandle("Short",length,ID)=ID
					}
				}
				s num=0
				s le=0
				for
				{
					s le=$o(^TempDataHandle("Short",le))
					q:le=""
					s ExamID=0
					for
					{
						s ExamID=$o(^TempDataHandle("Short",le,ExamID))
						q:ExamID=""
						s num=num+1
						s ^TempDataHandle("Handle",num)=ExamID
					}
				}
				
			}
			
			elseif (sortmethod="UpdateTime")
			{
				s num=0
				s UpdateTime=""
				for
				{
					s UpdateTime=$o(^CT.WDT.CDSS.ConExamDictI("UpdateDateIndex",hospid,UpdateTime),-1)
					q:UpdateTime=""
					s ID=0
					for
					{
						s ID=$o(^CT.WDT.CDSS.ConExamDictI("UpdateDateIndex",hospid,UpdateTime,ID))
						q:ID=""
						s num=num+1
						s ^TempDataHandle("Handle",num)=ID
					}
				}
		
			}
			else
			{
				s num=0
				s CreateTime=""
				for
				{
					s CreateTime=$o(^CT.WDT.CDSS.ConExamDictI("CreateDateIndex",hospid,CreateTime),-1)
					q:CreateTime=""
					s ID=0
					for 
					{
						s ID=$o(^CT.WDT.CDSS.ConExamDictI("CreateDateIndex",hospid,CreateTime,ID))
						q:ID=""
						s num=num+1
						s ^TempDataHandle("Handle",num)=ID
					}
				}
			}
			}
			s Number=0
			for 
			{
				s Number=$o(^TempDataHandle("Handle",Number))
				q:Number=""
				s ID=^TempDataHandle("Handle",Number)
				
				s HospAreaDR="",HospAreaDesc="",HospitalAreaDR="",HospitalAreaDRStr=""
				for
				{
					s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","检查检验",ID,HospAreaDR))
					q:HospAreaDR=""
					s ParRef=$p(HospAreaDR,"||",1)
					s ChildSub=$p(HospAreaDR,"||",2)
					if (HospAreaDesc="")
					{
						s HospAreaDesc= $lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),3)		//院区名称
					}
					else
					{
						s HospAreaDesc=HospAreaDesc_","_$lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),3)		//院区名称
					}
					if (HospitalAreaDRStr=""){
						s HospitalAreaDRStr=HospAreaDR
					}
					else{
						s HospitalAreaDRStr=HospitalAreaDRStr_","_HospAreaDR
					}
					s HospitalAreaDR=HospitalAreaDRStr
					//s HospitalAreaDR=HospAreaDR
				}				s ExamCode= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),2)		//代码
				continue:((examcode'="")&&($ZCONVERT(ExamCode,"U")'[examcode))
				
				s ExamName= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		//描述
				continue:((examdesc'="")&&($ZCONVERT(ExamName,"U")'[examdesc))
				s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),4)		//类型（检查或者检验)
				continue:((type'="")&&(ExamType'=type))
				
				s SpecimenCode=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),5)		//样本代码
				s SpecimenName=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),6)		//样本名称
				s Source=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),7)		//来源（住院/门诊/急诊）
				continue:((source'="")&&(Source'=source))
				s DictHospDesc=""
				s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(ID)),8)	//所属医院
				continue:((hospid'="")&&(HospitalDR'=hospid))
				s:HospitalDR'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
				//s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","检查检验",ID,0))
	        	//continue:(ConID="")
				s Remarks=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),9)		//备注 {非检查检验项目/检查检验项目不明确/规则、治疗方案、详情等未涉及项目}
				
				
				s State=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),10)		//状态（未关联/已关联/已确认/已删除）
				if (state="")	//默认不显示 已删除
				{
					continue:(State="已删除")
				}
				else
				{
					continue:(State'=state)
				}
				s CreateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),11)		//创建时间（数据导入或者手动新增的时间）
				s CreateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),12)		//创建人
				s UpdateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),13)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
				s UpdateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),14)		//修改人
				s ConExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),17)     //客户类型
				continue:((contype'="")&&(ConExamType'=contype))
				s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,0))
				s DictNameStr="",DictCodeStr="",DictIDStr="" //知识库描述串、知识库代码串、ID串
				s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

				if (haveState'="")  //如果有对照
				{
					//走对照表，找对接的知识库id、代码、描述
					s ContrastState=""
					for
					{
						s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,ContrastState))
						q:ContrastState=""
						
						s ConID=0
						for
						{
							s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,ContrastState,ConID))
							q:ConID=""
							
							s DictID=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)		//知识库字典ID
							s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
							s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
							//知识库描述串
							if (DictNameStr=""){
								s DictNameStr=DictName
							}
							else{
								s DictNameStr=DictNameStr_","_DictName
							}
							//知识库ID串
							if (DictIDStr=""){
								s DictIDStr=DictID
							}
							else{
								s DictIDStr=DictIDStr_","_DictID
							}	
							//知识库代码串
							if (DictCodeStr=""){
								s DictCodeStr=DictCode
							}
							else{
								s DictCodeStr=DictCodeStr_","_DictCode
							}		
								
							
							continue:((dictdesc'="")&&($ZCONVERT(DictName,"U")'[dictdesc)) 
							
							s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
							s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
							s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
							continue:((remark'="")&&(ConRemarks'=remark))
						}				
					} 
				}
				s DictName=DictNameStr,DictCode=DictCodeStr,DictID=DictIDStr   //给需要输出的字段：知识库字典ID、代码、描述重新赋值，多个的话拼串
				if (($ZCONVERT(DictName,"U")[dictdesc))&(ConRemarks[remark)  //满足条件则输出
				{
					d OutputConList
				}
					
			}
							
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
OutputConList
	    set Data=$lb(RowID,ExamCode,ExamName,ExamType,SpecimenCode,SpecimenName,Source,HospitalDR,DictHospDesc,ConRemarks,DictID,DictCode,DictName,ConState,HospAreaDesc,HospitalAreaDR,ConExamType)
	    set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	    quit
}

ClassMethod GetConListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetConListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConListExecute ]
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

/// Creator:钟荣枫 
/// CreatDate:2021-1-4
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.ConExamDict 对接方检查检验字典表
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.ConExamDict).FormValidate("","4","盆底超声检查","检查",1)
ClassMethod FormValidate(id As %String, code As %String, name As %String, type As %String, hosp As %String) As %String
{
	s flag=""
	s flagc=""
	s:((hosp'="")&&(name'="")&&(type'="")) flagc=$d(^CT.WDT.CDSS.ConExamDictI("HospCNIndex",hosp,code,name,type))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:((hosp'="")&&(name'="")&&(type'="")) idc=$o(^CT.WDT.CDSS.ConExamDictI("HospCNIndex",hosp,code,name,type,0))
		if (idc'="")&(idc'=id)&(flagc>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator:钟荣枫 
/// CreatDate: 2021-1-4
/// Description：对接方检查检验字典表
/// Table:CT.WDT.CDSS.ConExamDict 对接方检查检验字典表
/// Input: eobj As web.CDSSEntity.IMP.ConExamDict
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConExamDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.ConExamDict, LogFlag As %String = "") As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.Source="" eobj.Source="住院"
		s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	    s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	    s:eobj.ExamCode="" eobj.ExamCode=..getFactorCode()	  
		s flag=..FormValidate(eobj.ID,eobj.ExamCode,eobj.ExamName,eobj.ExamType,eobj.HospitalDR)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.ConExamDict).%New()
	        s:eobj.CreateDate="" eobj.CreateDate=$ZDATETIME($HOROLOG,3)
	        s:eobj.CreateUser="" eobj.CreateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	        s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	        s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.ConExamDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
			s bobj.ID = eobj.ID
			
			s bobj.ExamCode= obj.ExamCode		//代码
			s bobj.ExamName=obj.ExamName		//描述
			s bobj.ExamType=obj.ExamType	//类型（检查或者检验)
			s bobj.SpecimenCode=obj.SpecimenCode		//样本代码
			s bobj.SpecimenName=obj.SpecimenName	//样本名称
			s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
			s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
			s bobj.Remarks=obj.Remarks		//备注 {非检查检验项目/检查检验项目不明确/规则、治疗方案、详情等未涉及项目}
			s bobj.State=obj.State		//状态（未关联/已关联/已确认/已删除）
			s bobj.CreateDate=obj.CreateDate		//创建时间（数据导入或者手动新增的时间）
			s bobj.CreateUser=obj.CreateUser		//创建人
			s bobj.UpdateDate=obj.UpdateDate		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s bobj.UpdateUser=obj.UpdateUser		//修改人
			s bobj.StartDate=obj.StartDate
			s bobj.EndDate=obj.EndDate	
			s bobj.ConExamType=obj.ConExamType	
		
		}
		s obj.ExamCode= eobj.ExamCode		//代码
		s obj.ExamName=eobj.ExamName		//描述
		s obj.ExamType=eobj.ExamType	//类型（检查或者检验)
		s obj.SpecimenCode=eobj.SpecimenCode		//样本代码
		s obj.SpecimenName=eobj.SpecimenName	//样本名称
		s obj.Source=eobj.Source		//来源（住院/门诊/急诊）
		d:eobj.HospitalDR'="" obj.HospitalDRSetObjectId(eobj.HospitalDR)		//所属医院
		d:eobj.HospitalDR="" obj.HospitalDRSetObjectId("")
		s obj.Remarks=eobj.Remarks		//备注 {非检查检验项目/检查检验项目不明确/规则、治疗方案、详情等未涉及项目}
		s obj.State=eobj.State		//状态（未关联/已关联/已确认/已删除）
		s obj.CreateDate=eobj.CreateDate		//创建时间（数据导入或者手动新增的时间）
		s obj.CreateUser=eobj.CreateUser		//创建人
		s obj.UpdateDate=eobj.UpdateDate		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s obj.UpdateUser=eobj.UpdateUser		//修改人
		s obj.StartDate=eobj.StartDate
		s obj.EndDate=eobj.EndDate	
		s obj.ConExamType=eobj.ConExamType
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			if (eobj.ID="")
			{
				s count= ..AutoMatch(eobj.HospitalDR,id)	//自动匹配	
				s count=$p(count,"'",4)
				s result = "{success:'true',id:'"_id_"',count:'"_count_"'}"
				if (eobj.HospitalAreaDR'="")
				{
					s areatotal=$l(eobj.HospitalAreaDR,",")
					for areai=1:1:areatotal
					{
						s areaID=$p(eobj.HospitalAreaDR,",",areai)
						s resultx=##class(web.CDSS.IMP.ConDictConArea).SaveData("",eobj.ExamType,id,areaID)
						if (resultx["false")
						{
							q
						}
					}
				}
			}
			if (LogFlag="")
			{
			s DictHospDescFlag=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(eobj.HospitalDR)),3)
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConExamDict","CT.WDT.CDSS.ConExamDict","对接方检查检验字典表",id,DictHospDescFlag_"-"_eobj.ExamName,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConExamDict","CT.WDT.CDSS.ConExamDict","对接方检查检验字典表",id,DictHospDescFlag_"-"_eobj.ExamName,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方检查检验字典表","web.CDSS.IMP.ConExamDict","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：阚延新
/// Description：得到新增数据的code
/// Table:CT.WDT.CDSS.ConExamDict对接方检查检验对照表
/// Input：id
/// Other: w ##class(web.CDSS.IMP.ConExamDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.ConExamDictD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s result = dataid+1
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：修改对接方检查检验字典表的状态
/// Table:CT.WDT.CDSS.ConExamDict
/// Input： id, state 状态
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConExamDict).UpdateState("","")
ClassMethod UpdateState(id, state)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConExamDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
	s bobj.ID = id
	
	s bobj.ExamCode= obj.ExamCode		//代码
	s bobj.ExamName=obj.ExamName		//描述
	s bobj.ExamType=obj.ExamType	//类型（检查或者检验)
	s bobj.SpecimenCode=obj.SpecimenCode		//样本代码
	s bobj.SpecimenName=obj.SpecimenName	//样本名称
	s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
	s bobj.Remarks=obj.Remarks		//备注 {非检查检验项目/检查检验项目不明确/规则、治疗方案、详情等未涉及项目}
	s bobj.State=state		//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=obj.CreateDate		//创建时间（数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		//修改人	
	s bobj.ConExamType=obj.ConExamType
	
	s result= ..SaveEntity(bobj)
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：导出导入模板
/// Table:CT.WDT.CDSS.ConExamDict
/// Input： 
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConExamDict).ExportTemplate()
ClassMethod ExportTemplate()
{
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"对接方检查检验字典表导入模板.csv"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\IMP\DataExport\"
		s file=Path_"scripts\bdp\CDSS\IMP\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/IMP/DataExport/"
		s file=Path_"scripts/bdp/CDSS/IMP/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	
	d file.Open("NWS")
	d file.Write("检查代码,"_"检查名,"_"类型,"_"样本代码,"_"样本名称,"_"来源,"_"备注,"_"医院")
	d file.WriteLine()
	
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：自动匹配
/// Table:CT.WDT.CDSS.ConExamDict
/// Input： hosp 医院id, id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConExamDict).AutoMatch(hosp)
ClassMethod AutoMatch(hosp As %String, id As %String = "")
{
	q:(hosp="") "{success:'false',errorinfo:'自动匹配失败，传入的医院为空！'}"
	s result=""
	s linksavecount=0
	s unlinksavecount=0
	
	//生成检查检验检索索引(名称或别名中包含括号或者-的数据处理后生成到一个临时global里，用于后面的匹配)
	d ##class(web.CDSS.IMP.ConExamDict).CreateExamIndex()
	d ##class(web.CDSS.IMP.ConExamDict).CreateLabInsIndex()
	d ##class(web.CDSS.IMP.ConExamDict).CreateLabOrdIndex()
	
	//遍历所有未关联的检查检验
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConExamDictI("HospStateIndex",hosp,"未关联",ID))
		q:ID=""
		
		continue:((id'="")&&(id'=ID))
		
		s TrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","检查检验",ID,0)) //当前数据在对照表中的ID
		s DictCode= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),2)		//代码
		//s DictDesc= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		
		s DictName=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		//通用名		
		s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),4)		//类型（检查或者检验)
		q:ExamType=""
		//0 从已确认数据中找名称相同的数据
		s ExamID=$o(^CT.WDT.CDSS.ConExamDictI("StateDescIndex","已确认",DictName,ExamType,0))
		s ConIDFlag=0
		s:ExamID'="" ConIDFlag=$d(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","检查检验",ExamID))
		if (ConIDFlag>0)  //如果有已确认的名称相同的数据，则跟该数据对照同样的知识库数据
		{
			s DictDRStr=""
			s ConID=0
			for
			{
				s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","检查检验",ExamID,ConID))
				q:ConID=""
				s DictDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)  //对照的知识库字典ID
				s:DictDRStr'="" DictDRStr=DictDRStr_","
				s DictDRStr=DictDRStr_DictDR
				
			}
			//调用关联方法保存对照数据
			s result=..BatchMapping(ID,DictDRStr,"","",ExamType)
			if (result["false")
			{
				s unlinksavecount=unlinksavecount+1
			}
			else
			{
				s linksavecount=linksavecount+1
			}
		}
		else
		{
			//-----------------------------------自动匹配-----------------------------------------------------------------------------
			//his名处理符号：去除空格；全角转半角；小括号-中文；逗号-中文；中括号-英文；去除<>及其中内容；去除%及前面数字														
			s DictNameNew=##class(web.CDSS.IMP.ContrastDict).DealBracketBeforeCon(DictName)	  
			//1 his名和知识库名和别名匹配
			s RowID=..FindDictIdByName(DictNameNew,ExamType)
			/*/2 his通用名和知识库名和别名匹配
			if (RowID="")&&(DictDesc'="")
			{
				//his通用名处理符号：去除空格；全角转半角；小括号-中文；逗号-中文；中括号-英文；去除<>及其中内容；去除%及前面数字		
				s DictDescNew=##class(web.CDSS.IMP.ContrastDict).DealBracketBeforeCon(DictDesc)	  
				s RowID=..FindDictIdByName(DictDescNew)
			}*/
			
			if (RowID="")
			{
				s DictNameNoBracket=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(DictNameNew)
				if (DictNameNoBracket'="")
				{
					if (DictNameNoBracket'=DictNameNew)
					{
						//3 忽略对接方名括号 "()"、"[]"、"（）"、"【】" 跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNoBracket, ExamType)
					}
					//4 忽略知识库名称和别名中的括号"()"、"[]"、"（）"、"【】" 进行匹配
					if (ExamType="检查")	
					{		
						if (RowID="")&($d(^TEMPCDSSCON("ExamIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("ExamIndex",1,$zconvert(DictNameNoBracket,"U"),0))
						}
					}
					if (ExamType="检验项目")
					{
						if (RowID="")&($d(^TEMPCDSSCON("LabInsIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabInsIndex",1,$zconvert(DictNameNoBracket,"U"),0))
						}
					}
					if (ExamType="检验医嘱")
					{
						if (RowID="")&($d(^TEMPCDSSCON("LabOrdIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabOrdIndex",1,$zconvert(DictNameNoBracket,"U"),0))
						}
					}
				}
			}
			
			if (RowID="")
			{
				s DictNameNoBracketinside=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(DictNameNew)
				if (DictNameNoBracketinside'="")
				{
					if (DictNameNoBracketinside'=DictNameNew)
					{
						//5 忽略对接方名括号 "()"、"[]"、"（）"、"【】" 及内容跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNoBracketinside, ExamType)
					}
					//6 忽略知识库名称和别名中的括号"()"、"[]"、"（）"、"【】"及内容 进行匹配
					if (ExamType="检查")
					{	
						if (RowID="")&($d(^TEMPCDSSCON("ExamIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("ExamIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
						}
					}
					if (ExamType="检验项目")
					{	
						if (RowID="")&($d(^TEMPCDSSCON("LabInsIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabInsIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
						}
					}
					if (ExamType="检验医嘱")
					{	
						if (RowID="")&($d(^TEMPCDSSCON("LabOrdIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabOrdIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
						}
					}
				}
			}
			
			if (RowID="")
			{
				s DictNameNOMinus=$Replace(DictNameNew,"-","")
				if (DictNameNOMinus'="")
				{
					if (DictNameNOMinus'=DictNameNew)
					{
						//7 忽略对接方 - 跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNOMinus, ExamType)
					}
					//8 忽略知识库名称和别名中的 -  进行匹配
					if (ExamType="检查")
					{
						if (RowID="")&($d(^TEMPCDSSCON("ExamIndex",3))>0)
						{
							s RowID=$o(^TEMPCDSSCON("ExamIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
					if (ExamType="检验项目")
					{
						if (RowID="")&($d(^TEMPCDSSCON("LabInsIndex",3))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabInsIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
					if (ExamType="检验医嘱")
					{
						if (RowID="")&($d(^TEMPCDSSCON("LabOrdIndex",3))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabOrdIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
				}
			}
			if (RowID'="")
			{
				//调用关联方法保存对照数据
				s result=..BatchMapping(ID,RowID,"","",ExamType)
				if (result["false")
				{
					s unlinksavecount=unlinksavecount+1
				}
				else
				{
					s linksavecount=linksavecount+1
				}		
			}
			else
			{
				s unlinksavecount=unlinksavecount+1
			}

	  	}
	  	
	}
	
	s result="{success:'true',linksavecount:'"_linksavecount_"',unlinksavecount:'"_unlinksavecount_"'}"
	k ^TEMPCDSSCON("LabInsIndex")
	k ^TEMPCDSSCON("ExamIndex")
	k ^TEMPCDSSCON("LabOrdIndex")
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：建立关联
/// Table:CT.WDT.CDSS.ConExamDict
/// Input： hisid 项目检查检验id，dictid 检查检验知识库id，remark-备注
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConExamDict).Mapping(430285,"652","","检查")
ClassMethod Mapping(hisid As %String, dictid As %String, remark As %String = "", type As %String)
{
	q:(hisid="")||(dictid="") "false"  //项目检查检验id或东华检查检验id为空则输出错误信息
	s result=""
	s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s eobj.ID = ""
	s eobj.ContrastType= "检查检验"		//对照类型
	s eobj.ConDictCode=$lg($g(^CT.WDT.CDSS.ConExamDictD(hisid)),2)	//对接方字典代码
	s eobj.ConDictName=$lg($g(^CT.WDT.CDSS.ConExamDictD(hisid)),3)		//对接方字典描述
	s eobj.HospitalDR =$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(hisid)),8)	//医院
	s eobj.Remarks=remark		//备注	
	if (type="检验医嘱")
	{
		s eobj.DictCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(dictid)),2)
		s eobj.DictName=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(dictid)),3)
	}
	if (type="检验项目")
	{
		s eobj.DictCode=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(dictid)),3)
		s eobj.DictName=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(dictid)),4)
	}
	if (type="检查")
	{
		s eobj.DictCode=$lg($g(^CT.WDT.CDSS.ExamDictD(dictid)),3)
		s eobj.DictName=$lg($g(^CT.WDT.CDSS.ExamDictD(dictid)),4)	
	}		
	q:(eobj.ConDictCode="")||(eobj.ConDictName="")||(eobj.DictCode="")||(eobj.DictName="")||(eobj.HospitalDR="") "false"	//对照表中的必填字段有一个为空就输出错误信息，不能对照
	s eobj.State="已关联"		//状态（未关联/已关联/已确认/已删除）
	s eobj.DictDR=dictid       //知识库id
	s eobj.IntDictDR=hisid 		//对接方检查检验id	
	s linkresult=##class(web.CDSS.IMP.ContrastDict).SaveEntity(eobj)
	if (linkresult["false")		//保存失败
	{
		s result="false"	
	}
	else	//保存成功
	{
		s result="true"	
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：批量关联
/// Table:CT.WDT.CDSS.ConExamDict
/// Input：HisID-项目检查检验字典id，DictIDStr 东华检查检验id串（用,分开），remark-备注，hospareaDR-院区id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConExamDict).BatchMapping(430284,"251,123","","31||9","检验医嘱")
ClassMethod BatchMapping(HisID As %String, DictIDStr As %String, remark As %String, hospareaDR As %String, type As %String)
{
	q:(HisID="")||(DictIDStr)="" "{success:'false',errorinfo:'传入的项目数据id或者东华知识id为空！'}"
	s result=""
	s HospAreaDR=""
	
	TS	
	//先删除原来的对照
	s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex","检查检验",HisID,""))
	if ((flag'=""))
	{
		s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"检查检验")
	}
	//s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,DictType)
	if (result'["false")
	{
		//再重新保存对照数据
		s DictTotal=$l(DictIDStr,",")
		for DictLen=1:1:DictTotal
		{
			s dictid=$p(DictIDStr,",",DictLen)
			s result=..Mapping(HisID,dictid,remark,type)
			if (result["false")
			{
				q
			}
		}
	}
	//把对接方检查检验字典的数据改为已关联的状态
	if (result'["false")
	{	
		s result=..UpdateState(HisID,"已关联")
	}
	//保存对接方字典关联院区
	if (result'["false")&&((hospareaDR="")||(hospareaDR["||"))  //如果传入的院区为空 或是正确的格式才保存对接方字典关联院区 ，如果不是正确的格式则不需要处理该表数据
	{

		//找到这个检查检验关联的院区（有多个的用英文,拼接）
		s HospAreaDRStr=""
		s HospAreaID=0
		for
		{
			s HospAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","检查检验",HisID,HospAreaID))
			q:HospAreaID=""
			s:HospAreaDRStr'="" HospAreaDRStr=HospAreaDRStr_","
			s HospAreaDRStr=HospAreaDRStr_HospAreaID
		}

		if (HospAreaDRStr'=hospareaDR)  //如果原来关联的院区和传入的院区数据不一致
		{
			s result=##class(web.CDSS.IMP.ConDictConArea).DelHospArea("检查检验",HisID)  //先删除之前的关联院区
			//重新关联院区，否则对接方关联院区表会有冗余数据
			if (hospareaDR'="")&&(result'["false")
			{
				s areatotal=$l(hospareaDR,",")
				for areai=1:1:areatotal
				{
					s areaID=$p(hospareaDR,",",areai)
					s result=##class(web.CDSS.IMP.ConDictConArea).SaveData("",type,HisID,areaID)
					if (result["false")
					{
						q
					}
				}
			}
		}
	}
	if (result["false")
	{
		tro
		s result="{success:'false',errorinfo:'关联失败！'}"
	}
	else
	{
		tc	
		s result="{success:'true',saveid:'"_HisID_"'}"	
	}		
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.ConExamDict
/// Input：examcode 代码，examdesc 描述，hospid 医院id，state 状态，，source 来源，dictdesc 知识库描述，remark 备注，sortmethod 排序方式
/// Return：fileName
/// Other: w ##class(web.CDSS.IMP.ConExamDict).ExportMapping()
ClassMethod ExportMapping(examcode As %String, examdesc As %String, hospid As %String, type As %String, state As %String, source As %String, dictdesc As %String, remark As %String, contype As %String)
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"检查检验字典对照结果.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"检查检验字典对照结果.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\IMP\DataExport\"
		s file=Path_"scripts\bdp\CDSS\IMP\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/IMP/DataExport/"
		s file=Path_"scripts/bdp/CDSS/IMP/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	
	o file:"NWS"
	u file
	
	w "来源	客户检查代码	客户检查名	客户类型	样本代码	样本名称	类型	东华检查名	状态	类型	医院	备注"
			
	s:examcode'="" examcode=$ZCONVERT(examcode,"U") //转换成大写
	s:examdesc'="" examdesc=$ZCONVERT(examdesc,"U") //转换成大写
	s:dictdesc'="" dictdesc=$ZCONVERT(dictdesc,"U") //转换成大写
	s:contype'="" contype=$ZCONVERT(contype,"U") //转换成大写
	
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConExamDictD(ID))
		q:ID=""
		s ExamCode= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),2)		//代码
		continue:((examcode'="")&&($ZCONVERT(ExamCode,"U")'[examcode))
		
		s ExamName= $lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),3)		//描述
		continue:((examdesc'="")&&($ZCONVERT(ExamName,"U")'[examdesc))
		s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),4)		//类型（检查或者检验)
		continue:((type'="")&&(ExamType'=type))
		
		s SpecimenCode=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),5)		//样本代码
		s SpecimenName=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),6)		//样本名称
		s Source=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),7)		//来源（住院/门诊/急诊）
		s DictHospDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(ID)),8)	//所属医院
		continue:((hospid'="")&&(HospitalDR'=hospid))
		s:HospitalDR'="" DictHospDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),9)		//备注 {非检查检验项目/检查检验项目不明确/规则、治疗方案、详情等未涉及项目}
		
		
		s State=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),10)		//状态（未关联/已关联/已确认/已删除）
		if (state="")	//默认不显示 已删除
		{
			continue:(State="已删除")
		}
		else
		{
			continue:(State'=state)
		}
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),11)		//创建时间（数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),12)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),13)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),14)		//修改人
		s ConExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(ID)),17)		//客户类型
		continue:((contype'="")&&($ZCONVERT(ConExamType,"U")'[contype))
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,0))
		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注
		if (haveState'="")
		{
			s ConState=""
			for
			{
				s ConState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,ConState))
				q:ConState=""
				if (state="已删除"){
					continue:(ConState'=state)			
				}
				else{
					continue:(ConState="已删除")
					continue:((state'="")&&(ConState'=state))
				}
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"检查检验",ID,ConState,ConID))
					q:ConID=""
					s RowID=ConID
					s DictCodes= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
					s DictNames= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述	
					
					s size=$l(DictCodes,",")
					for i=1:1:size
					{
    					s DictCode=$p(DictCodes,",",i)
    					s DictName=$p(DictNames,",",i)
    					continue:((dictdesc'="")&&($ZCONVERT(DictName,"U")'[dictdesc)) 
						s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
						s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
						s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
						continue:((remark'="")&&($ZCONVERT(ConRemarks,"U")'[remark))
						w !,Source_"	"_ExamCode_"	"_ExamName_"	"_ConExamType_"	"_SpecimenCode_"	"_SpecimenName_"	"_ExamType_"	"_DictName_"	"_ConState_"	"_"检查检验	"_DictHospDesc_"	"_ConRemarks
					}
				}
			} 
		}
		else
		{
			w !,Source_"	"_ExamCode_"	"_ExamName_"	"_ConExamType_"	"_SpecimenCode_"	"_SpecimenName_"	"_ExamType_"	"_DictName_"	"_ConState_"	"_"检查检验	"_DictHospDesc_"	"_ConRemarks
			
		}
	}
		
	c file
	q fileName
}

/// Creator：钟荣枫 
/// CreatDate: 2020-11-20
/// Description：批量导入对接方检查检验
/// Table:CT.WDT.CDSS.ConExamDict
/// Input： dataStr,hospid
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConExamDict).SaveImportData("")
ClassMethod SaveImportData(dataStr, hosp)
{
	//"检查代码,"_"检查名,"_"类型,"_"样本代码,"_"样本描述,"_"来源,"_"备注,"_"医院"
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)	
		
	s ExamCode=$p(dataStr,"[next]",1)	//代码
	s:ExamCode="" ExamCode=..getFactorCode()
	s ExamName=$p(dataStr,"[next]",2)	//描述
	q:ExamName="" "false" 
	s StartDate=$p(dataStr,"[next]",3)
	s EndDate=$p(dataStr,"[next]",4)
	s Source=$p(dataStr,"[next]",5)
	q:Source="" "false" 
	s Remarks=$p(dataStr,"[next]",6)
	s SpecimenCode=$p(dataStr,"[next]",7)
	s SpecimenName=$p(dataStr,"[next]",8)
	s ExamType=$p(dataStr,"[next]",9)	//类型（检查或者检验项目或者检验医嘱)
	q:((ExamType'="检查")&&(ExamType'="检验项目")&&(ExamType'="检验医嘱")) "false"

	s bobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
	s bobj.ID = ""
	s bobj.ExamCode= ExamCode				//代码
	s bobj.ExamName=ExamName				//描述
	s bobj.ExamType=ExamType				//类型（检查或者检验项目或者检验医嘱)
	s bobj.SpecimenCode=SpecimenCode		//样本代码
	s bobj.SpecimenName=SpecimenName		//样本名称
	s bobj.Source=Source					//来源（住院/门诊/急诊）
	s bobj.HospitalDR =hosp					//所属医院
	s bobj.Remarks=Remarks					//备注 {非检查检验项目/检查检验项目不明确/规则、治疗方案、详情等未涉及项目}
	s bobj.State="未关联"					//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=$ZDATETIME($HOROLOG,3)					//创建时间（数据导入或者手动新增的时间）
	s bobj.CreateUser=$g(%session.Data("LOGON.USERNAME"))		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)					//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		//修改人
	s bobj.StartDate=StartDate
	s bobj.EndDate=EndDate	
	s bobj.ConExamType=ConExamType
	
	s re=..SaveEntity(bobj)
	if (re["true")
	{
		s result="true"	
	}
	else
	{
		s result="false"
	}
	
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-11-20
/// Description：获取最近一次新增数据时间
/// Table:CT.WDT.CDSS.ConExamDict
/// Input： hospid 医院id
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConExamDict).GetLastTime(hospid)
ClassMethod GetLastTime1(hosp)
{
	s lasttime=""	
	s CreateTime=0
	for
	{
		s CreateTime=$o(^CT.WDT.CDSS.ConExamDictI("CreateDateIndex",hosp,CreateTime))
		q:CreateTime=""
		s lasttime=CreateTime
	}
	
	q lasttime
}

ClassMethod GetLastTime(hosp)
{
	s lasttime=""
	
	if ($d(^CT.WDT.CDSS.ConExamDictI("CreateDateIndex",hosp)))
	{
		s lasttime=$o(^CT.WDT.CDSS.ConExamDictI("CreateDateIndex",hosp,""),-1)
	}	
	q lasttime
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：检查检验匹配    
/// Input： Desc
/// Return：ID 检查、检验项目、检验医嘱表ID
/// 测试数据：安立泽片,APC片,Ara-C,金石漱口水[125ml*1]
/// w ##class(web.CDSS.IMP.ConExamDict).ExamProcessing("Graves病")
ClassMethod ExamProcessing(Desc As %String, ExamType As %String)
{
	q:Desc="" ""
	s ID=0
	for 
	{
		if (ExamType="检查")			//检查
		{
			s ID=$o(^CT.WDT.CDSS.ExamDictD(ID))
			q:ID=""
			s state=$lg($g(^CT.WDT.CDSS.ExamDictD(ID)),25)  //知识库数据不是可对照状态
			continue:(state'=2)
			s Name=$zconvert($lg($g(^CT.WDT.CDSS.ExamDictD(ID)),4),"U")  
			s AliasName=$zconvert($lg($g(^CT.WDT.CDSS.ExamDictD(ID)),24),"U")
		}
		if (ExamType="检验项目")		//检验项目
		{
			s ID=$o(^CT.WDT.CDSS.LabInspectionDictD(ID))
			q:ID=""
			s state=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),24)  //知识库数据不是可对照状态
			continue:(state'=2)
			s Name=$zconvert($lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),4),"U")  
			s AliasName=$zconvert($lg($g(^CT.WDT.CDSS.LabInspectionDictD(ID)),23),"U")
		}
		if (ExamType="检验医嘱")		//检验医嘱
		{
			s ID=$o(^CT.WDT.CDSS.LabOrdersDictD(ID))
			q:ID=""
			s state=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),5)  //知识库数据不是可对照状态
			continue:(state'=2)
			s Name=$zconvert($lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),3),"U")  
			s AliasName=$zconvert($lg($g(^CT.WDT.CDSS.LabOrdersDictD(ID)),4),"U")
		}
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s AliasName=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(AliasName)
		s flag=0 
		if (AliasName'="")
		{
			for m=1:1:$l(AliasName,",")
			{
				s AliasDesc=$p(AliasName,",",m)
				if (Desc=AliasDesc)
				{
					s flag=1
				}
			}
		}
		q:flag=1
		q:Desc=$Replace(Name,"-","")
		q:$Replace(Desc,"-","")=$Replace(Name,"-","")
		q:$Replace(Desc,"-","")=Name
		q:Desc=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Desc)=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Desc)=Name
		q:Desc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Desc)=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Desc)=Name
	}
	q ID
}

/// Creator:胡宜良
/// CreatDate: 2023-02-23
/// Description：删除关联，将状态改已删除
/// Table:CT.WDT.CDSS.ConExamDict 对接方检查检验字典表
/// Input: id，remark 备注
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConExamDict).DelMapping()
ClassMethod DelMapping(id, remark)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConExamDict).%OpenId(id)
		
	s bobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
	s bobj.ID = id
	
	s bobj.ExamCode= obj.ExamCode		//代码
	s bobj.ExamName=obj.ExamName		//描述
	s bobj.ExamType=obj.ExamType	//类型（检查或者检验)
	s bobj.SpecimenCode=obj.SpecimenCode		//样本代码
	s bobj.SpecimenName=obj.SpecimenName	//样本名称
	s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
	s bobj.Remarks=obj.Remarks		//备注 {非检查检验项目/检查检验项目不明确/规则、治疗方案、详情等未涉及项目}
	s bobj.State="已删除"		//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=obj.CreateDate		//创建时间（数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		//修改人	
	s bobj.Remarks=remark
	s bobj.ConExamType=obj.ConExamType
	d obj.%Close()
	
	s result=..SaveEntity(bobj)		
			
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2023-03-15
/// Description：生成检查检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("ExamIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConExamDict).CreateExamIndex()
ClassMethod CreateExamIndex()
{
	k ^TEMPCDSSCON("ExamIndex")
	s ExamID=0
	for 
	{
		s ExamID=$o(^CT.WDT.CDSS.ExamDictD(ExamID))
		q:ExamID=""
		s state=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamID)),25)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamID)),4)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("ExamIndex",1,NewName,ExamID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("ExamIndex",2,NewName,ExamID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("ExamIndex",3,NewName,ExamID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.ExamDictD(ExamID)),24)	
		s flag=0 
		if (AliasName'="")
		{
			s AliasName=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(AliasName)
			s AliasName=$zconvert(AliasName,"U")
			for m=1:1:$l(AliasName,",")
			{
				s AliasDesc=$p(AliasName,",",m)
				continue:AliasDesc=""
				
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("ExamIndex",1,NewAliasDesc,ExamID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("ExamIndex",2,NewAliasDesc,ExamID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("ExamIndex",3,NewAliasDesc,ExamID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：谷雪萍
/// CreatDate: 2023-03-15
/// Description：生成检验项目检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("ExamIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConExamDict).CreateLabInsIndex()
ClassMethod CreateLabInsIndex()
{
	k ^TEMPCDSSCON("LabInsIndex")
	s LabInsID=0
	for 
	{
		s LabInsID=$o(^CT.WDT.CDSS.LabInspectionDictD(LabInsID))
		q:LabInsID=""
		s state=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabInsID)),24)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabInsID)),4)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabInsIndex",1,NewName,LabInsID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabInsIndex",2,NewName,LabInsID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabInsIndex",3,NewName,LabInsID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabInsID)),23)	
		s flag=0 
		if (AliasName'="")
		{
			s AliasName=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(AliasName)
			s AliasName=$zconvert(AliasName,"U")
			for m=1:1:$l(AliasName,",")
			{
				s AliasDesc=$p(AliasName,",",m)
				continue:AliasDesc=""
				
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("LabInsIndex",1,NewAliasDesc,LabInsID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("LabInsIndex",2,NewAliasDesc,LabInsID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("LabInsIndex",3,NewAliasDesc,LabInsID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：谷雪萍
/// CreatDate: 2023-03-15
/// Description：生成检验医嘱检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("ExamIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConExamDict).CreateLabOrdIndex()
ClassMethod CreateLabOrdIndex()
{
	k ^TEMPCDSSCON("LabOrdIndex")
	s LabOrdID=0
	for 
	{
		s LabOrdID=$o(^CT.WDT.CDSS.LabInspectionDictD(LabOrdID))
		q:LabOrdID=""
		s state=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabOrdID)),5)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabOrdID)),3)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabOrdIndex",1,NewName,LabOrdID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabOrdIndex",2,NewName,LabOrdID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabOrdIndex",3,NewName,LabOrdID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(LabOrdID)),4)	
		s flag=0 
		if (AliasName'="")
		{
			s AliasName=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(AliasName)
			s AliasName=$zconvert(AliasName,"U")
			for m=1:1:$l(AliasName,",")
			{
				s AliasDesc=$p(AliasName,",",m)
				continue:AliasDesc=""
				
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("LabOrdIndex",1,NewAliasDesc,LabOrdID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("LabOrdIndex",2,NewAliasDesc,LabOrdID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("LabOrdIndex",3,NewAliasDesc,LabOrdID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-14
/// Description：通过名称找知识库字典ID
/// Table:CT.WDT.CDSS.ExamDict\CT.WDT.CDSS.TCMDisease\CT.WDT.CDSS.Alias
/// Input： DictName-检查检验名称
/// Return：RowID—检查检验字典ID
/// Other: w ##class(web.CDSS.IMP.ConExamDict).FindDictIdByName("安立泽片")
ClassMethod FindDictIdByName(DictName, type)
{
	q:DictName="" ""
	if (type="检查")
	{
		s RowID=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.ExamDictD(RowID)),25)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.ExamDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.ExamDictD(RowID)),25)
				s:flag'=2 RowID=""
			}
				
		}
	}
	if (type="检验项目")
	{
		s RowID=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RowID)),24)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabInspectionDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RowID)),24)
				s:flag'=2 RowID=""
			}
				
		}
	}
	if (type="检验医嘱")
	{
		s RowID=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RowID)),5)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabOrdersDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RowID)),5)
				s:flag'=2 RowID=""
			}
				
		}
	}
	q RowID
}

/// Creator：胡宜良	
/// CreatDate: 2023-04-03
/// Description：删除 对接方检查检验字典表未关联数据
/// Table:CT.WDT.CDSS.ConExamDict 对接方检查检验字典表未关联数据
/// Input：hosp 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ConExamDict).DeleteUnlinkedData(31,2)
ClassMethod DeleteUnlinkedData(hosp As %String, type As %String) As %String
{
	s result="" 
	s:type=2 examtype="检查"
	s:type=3 examtype="检验项目"
	s:type=13 examtype="检验医嘱"
	s id=0 
	for
	{
		s id=$o(^CT.WDT.CDSS.ConExamDictI("HospTypeStateIndex",hosp,examtype,"未关联",id))
		q:id=""	
		s pobj = ##class(CT.WDT.CDSS.ConExamDict).%OpenId(id)
		s eobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
		
		s eobj.ExamCode= pobj.ExamCode							//代码
		s eobj.ExamName= pobj.ExamName							//名称
		s eobj.ExamType=pobj.ExamType
		s eobj.SpecimenCode=pobj.SpecimenCode
		s eobj.SpecimenName=pobj.SpecimenName									//ICD
		s eobj.Source=pobj.Source									//来源（住院/门诊/急诊）
		s:pobj.HospitalDR'="" eobj.HospitalDR = pobj.HospitalDR.%Id() //所属医院

		s eobj.Remarks=pobj.Remarks	                                //备注
		s eobj.State=pobj.State		                                    //状态（未关联/已关联/已确认/已删除）
		s eobj.CreateDate=pobj.CreateDate		                     //创建时间（诊断数据导入或者手动新增的时间）
		s eobj.CreateUser=pobj.CreateUser		                     //创建人
		s eobj.UpdateDate=pobj.UpdateDate		             //修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s eobj.UpdateUser=pobj.UpdateUser		 //修改人
		s eobj.ConExamType=pobj.ConExamType
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(CT.WDT.CDSS.ConExamDict).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ConExamDict","CT.WDT.CDSS.ConExamDict","对接方检查检验字典表",id,eobj.HospitalDR_"-"_eobj.ExamCode_"-"_eobj.ExamName_"-"_eobj.ExamType,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("对接方检查检验字典表","web.CDSS.IMP.ConExamDict","DeleteUnlinkedData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

}
