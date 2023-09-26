/// 名称:实施综合管理平台-对接方护理字典表
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-12-25
Class web.CDSS.IMP.ConNurseDict Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2020-12-25
/// Description：查询 对接方护理字典表
/// Table:CT.WDT.CDSS.ConNurseDict 对接方护理字典表
/// Input:rowid , code 代码, desc 描述, hospid 医院
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConNurseDict","GetList","","","","2","1","3")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ID,NursingCode,NursingName,NursingType,Source,HospitalDR,HospitalDesc,Remarks,State,CreateDate,CreateUser,UpdateDate,UpdateUser")
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
		
		s NursingCode= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),2)		//代码
		s NursingName= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),3)		//描述
		s NursingType=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),4)		//类型（护理/治疗/处置）
		
		s Source=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),5)		//来源（住院/门诊/急诊）
		s HospitalDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(ID)),6)	//所属医院
		s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),7)		//备注
		s State=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),8)		//状态（未关联/已关联/已确认/已删除）
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),9)		//创建时间（数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),10)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),11)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),12)		//修改人
	
		d OutputRow	
	}
	else
	{
		s ID=0
		for 
		{
			//ID,NursingCode,NursingName,NursingType,Source,HospitalDR,HospitalDesc,Remarks,State,CreateDate,CreateUser,UpdateDate,UpdateUser
			s ID=$o(^CT.WDT.CDSS.ConNurseDictD(ID))
			q:ID=""
			s NursingCode= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),2)		//代码
			continue:((code'="")&&($zconvert(NursingCode,"U")'[code))
			s NursingName= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),3)		//描述
			continue:((desc'="")&&($zconvert(NursingName,"U")'[desc))
			s NursingType=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),4)		//类型（护理/治疗/处置）
			
			s Source=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),5)		//来源（住院/门诊/急诊）
			s HospitalDesc=""
			s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(ID)),6)	//所属医院
			s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
			s Remarks=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),7)		//备注
			s State=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),8)		//状态（未关联/已关联/已确认/已删除）
			s CreateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),9)		//创建时间（数据导入或者手动新增的时间）
			s CreateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),10)		//创建人
			s UpdateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),11)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s UpdateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),12)		//修改人
			d OutputRow
		
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,NursingCode,NursingName,NursingType,Source,HospitalDR,HospitalDesc,Remarks,State,CreateDate,CreateUser,UpdateDate,UpdateUser)
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
/// CreatDate: 2020-12-25
/// Description：查询 对接方护理字典的对照  
/// Table:CT.WDT.CDSS.ConNurseDict 对接方护理字典表
/// Input:nursingid 护理id,NursingCode 护理代码，nursingdesc 护理描述，hospid 医院id，type 类型，state 状态，source 来源，dictdesc 知识库描述，remark 备注，sortmethod 排序方式
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConNurseDict","GetConList","","","","31","","","","","","","CreateTime")
Query GetConList(nursingid As %String, nursingcode As %String, nursingdesc As %String, hospid As %String, type As %String, state As %String, source As %String, dictdesc As %String, remark As %String, sortmethod) As %Query(ROWSPEC = "RowID,NursingCode,NursingName,NursingType,Source,HospitalDR,HospitalDesc,ConRemarks,DictID,DictCode,DictName,ConState,HospAreaDesc,HospitalAreaDR")
{
}

ClassMethod GetConListExecute(ByRef qHandle As %Binary, nursingid As %String, nursingcode As %String, nursingdesc As %String, hospid As %String, type As %String, state As %String, source As %String, dictdesc As %String, remark As %String, sortmethod) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	//来源、客户护理医嘱、客户护理ID、关联状态、东华护理名称、类型
	s:nursingcode'="" nursingcode=$ZCONVERT(nursingcode,"U") //转换成大写
	s:nursingdesc'="" nursingdesc=$ZCONVERT(nursingdesc,"U") //转换成大写
	s:dictdesc'="" dictdesc=$ZCONVERT(dictdesc,"U") //转换成大写
	s:remark'="" remark=$ZCONVERT(remark,"U") //转换成大写
	
	if (nursingid'="") //根据rowid返回该条记录
	{
		s ID=nursingid
		//03-09
		s HospAreaDR="",HospAreaDesc="",HospitalAreaDR=""
		for
		{
			s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","护理",ID,HospAreaDR))
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
		
		s NursingCode= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),2)		//代码
		s NursingName= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),3)		//描述
		s NursingType=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),4)		//类型（护理/治疗/处置）
		
		s Source=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),5)		//来源（住院/门诊/急诊）
		s HospitalDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(ID)),6)	//所属医院
		s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),7)		//备注
		s State=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),8)		//状态（未关联/已关联/已确认/已删除）
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),9)		//创建时间（数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),10)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),11)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),12)		//修改人
		
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,0))
		/*if (haveState'="")
		{
				
			s ConState=""
			for
			{
				s ConState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ConState))
				q:ConState=""
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ConState,ConID))
					q:ConID=""
					s RowID=ConID
					if (ConState="未关联")
					{
						s DictID= ""		//知识库字典ID
						s DictCode= ""		//知识库字典代码
						s DictName= ""		//知识库字典描述
					}
					else
					{
						s DictID=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)		//知识库字典ID
						s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
						s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
					}
										
					s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
					s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
					//s ConState=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),7)		//状态（已关联/已确认/已删除）
					
					
					s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
					d OutputRow2
				}
			}	
		}
		else
		{
			s RowID=ID
			s DictCode= ""		//知识库字典代码
			s DictName= ""		//知识库字典描述
			s ConState=""
			d OutputRow2
		} */
		//03-09
		if (haveState'="")  //如果有对照
		{
			//走对照表，找对接的知识库id、代码、描述
			s ContrastState=""
			for
			{
				s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ContrastState))
				q:ContrastState=""
				
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ContrastState,ConID))
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
					s CreateTime=$o(^CT.WDT.CDSS.ConNurseDictI("CreateDateIndex",hospid,CreateTime),-1)
					q:CreateTime=""
					s ID=0
					for 
					{
						s ID=$o(^CT.WDT.CDSS.ConNurseDictI("CreateDateIndex",hospid,CreateTime,ID))
						q:ID=""
						s NursingCode= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),2)		//代码
						s NursingName= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),3)		//描述
						s length=$l(NursingName)
						s ^TempDataHandle("Short",length,ID)=ID
					}
				}
				s num=0
				s le=0
				for
				{
					s le=$o(^TempDataHandle("Short",le))
					q:le=""
					s NursingID=0
					for
					{
						s NursingID=$o(^TempDataHandle("Short",le,NursingID))
						q:NursingID=""
						s num=num+1
						s ^TempDataHandle("Handle",num)=NursingID
					}
				}
				
			}
			
			elseif (sortmethod="UpdateTime")
			{
				s num=0
				s UpdateTime=""
				for
				{
					s UpdateTime=$o(^CT.WDT.CDSS.ConNurseDictI("UpdateDateIndex",hospid,UpdateTime),-1)
					q:UpdateTime=""
					s ID=0
					for
					{
						s ID=$o(^CT.WDT.CDSS.ConNurseDictI("UpdateDateIndex",hospid,UpdateTime,ID))
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
					s CreateTime=$o(^CT.WDT.CDSS.ConNurseDictI("CreateDateIndex",hospid,CreateTime),-1)
					q:CreateTime=""
					s ID=0
					for 
					{
						s ID=$o(^CT.WDT.CDSS.ConNurseDictI("CreateDateIndex",hospid,CreateTime,ID))
						q:ID=""
						s num=num+1
						s ^TempDataHandle("Handle",num)=ID
					}
				}
			}
			
			//RowID,NursingCode,NursingName,NursingType,Source,HospitalDR,HospitalDesc,Remarks,DictCode,DictName,ConState
			s Number=0
			for 
			{
				s Number=$o(^TempDataHandle("Handle",Number))
				q:Number=""
				s ID=^TempDataHandle("Handle",Number)
				s HospAreaDR="",HospAreaDesc="",HospitalAreaDR="",HospitalAreaDRStr=""
				for
				{
					s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","护理",ID,HospAreaDR))
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
				}
				s NursingCode= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),2)		//代码
				continue:((nursingcode'="")&&($ZCONVERT(NursingCode,"U")'[nursingcode))
				s NursingName= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),3)		//描述
				continue:((nursingdesc'="")&&($ZCONVERT(NursingName,"U")'[nursingdesc))
				s NursingType=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),4)		//类型（护理/治疗/处置）
				continue:((type'="")&&(NursingType'=type))
				
				s Source=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),5)		//来源（住院/门诊/急诊）
				continue:((source'="")&&(Source'=source))
				s HospitalDesc=""
				s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(ID)),6)	//所属医院
				continue:((hospid'="")&&(HospitalDR'=hospid))
				s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
				;s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","护理",ID,0))
	        	;continue:(ConID="")
	        	s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
				s Remarks=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),7)		//备注
				
				s State=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),8)		//状态（未关联/已关联/已确认/已删除）
				if (state="")	//默认不显示 已删除
				{
					continue:(State="已删除")
				}
				else
				{
					continue:(State'=state)
				}
				s CreateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),9)		//创建时间（数据导入或者手动新增的时间）
				s CreateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),10)		//创建人
				s UpdateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),11)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
				s UpdateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),12)		//修改人
			
				s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,0))
				s DictNameStr="",DictCodeStr="",DictIDStr="" //知识库描述串、知识库代码串、ID串
				s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注
				//03-09
				if (haveState'="")  //如果有对照
				{
					//走对照表，找对接的知识库id、代码、描述
					s ContrastState=""
					for
					{
						s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ContrastState))
						q:ContrastState=""
							
						s ConID=0
						for
						{
							s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ContrastState,ConID))
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
			/*if (haveState'="")
			{
				s ConState=""
				for
				{
					s ConState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ConState))
					q:ConState=""
					if (state="")	//默认不显示 已删除
					{
						continue:(ConState="已删除")
					}
					else
					{
						continue:(ConState'=state)
					}
					s ConID=0
					for
					{
						s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ConState,ConID))
						q:ConID=""
						s RowID=ConID
						if ((ConState="未关联")||((ConState="已删除")&&(State="已删除")))
						{
							s DictID= ""		//知识库字典ID
							s DictCode= ""		//知识库字典代码
							s DictName= ""		//知识库字典描述
						}
						else
						{
							s DictID=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)		//知识库字典ID
							s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
							s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
						}
						continue:((dictdesc'="")&&($ZCONVERT(DictName,"U")'[dictdesc)) 
						
						s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
						s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
						//s ConState=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),7)		//状态（已关联/已确认/已删除）
						
						
						s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
						continue:((remark'="")&&($ZCONVERT(ConRemarks,"U")'[remark))
						d OutputRow2
					}
					
				} 
			}
			else
			{
				s RowID=ID
				s DictCode= ""		//知识库字典代码
				s DictName= ""		//知识库字典描述
				s ConState=""
				d OutputRow2
			}*/
		
		}
	}
}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputConList
    set Data=$lb(RowID,NursingCode,NursingName,NursingType,Source,HospitalDR,HospitalDesc,ConRemarks,DictID,DictCode,DictName,ConState,HospAreaDesc,HospitalAreaDR)
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

/*/// Creator：钟荣枫 
/// CreatDate: 2020-12-25
/// Description:删除限制
/// Input：id 
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.IMP.ConNurseDict).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
    s flag=0
    
	s NursingCode= $lg($g(^CT.WDT.CDSS.ConNurseDictD(id)),2)		//代码
	s NursingName= $lg($g(^CT.WDT.CDSS.ConNurseDictD(id)),3)		//描述
	s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(id)),6)
	
	s State=""
	for
	{
		s State=$o(^CT.WDT.CDSS.ContrastDictI("ConNameStateIndex",HospitalDR,"护理",NursingName,State))
		q:State=""
		s HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s myInfo=myInfo_"<字典对照表:"_HospitalDesc_"-护理>"
		
	}	
	
	if myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-25
/// Description：根据id删除 对接方护理字典表
/// Table:CT.WDT.CDSS.ConNurseDict 对接方护理字典表
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).DeleteData(1)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	
	s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
	
		s pobj=##class(CT.WDT.CDSS.ConNurseDict).%OpenId(id)
		s eobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
		
		s eobj.NursingCode= pobj.NursingCode		//代码
		s eobj.NursingName= pobj.NursingName		//描述
		s eobj.NursingType=pobj.NursingType		//类型（护理/治疗/处置）
		
		s eobj.Source=pobj.Source		//来源（住院/门诊/急诊）
		s eobj.HospitalDR=pobj.HospitalDR	//所属医院
		s eobj.Remarks=pobj.Remarks		//备注
		s eobj.State=pobj.State		//状态（未关联/已关联/已确认/已删除）
		s eobj.CreateDate=pobj.CreateDate		//创建时间（数据导入或者手动新增的时间）
		s eobj.CreateUser=pobj.CreateUser		//创建人
		s eobj.UpdateDate=pobj.UpdateDate	//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s eobj.UpdateUser=pobj.UpdateUser		//修改人
				
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(CT.WDT.CDSS.ConNurseDict).%DeleteId(id)
		IF $$$ISOK(sc)	//删除成功
		{
			
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("DHCDSSConNurseDict","CT.WDT.CDSS.ConNurseDict","对接方护理字典表",id,eobj.HospitalDR_"-"_eobj.NursingCode,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方护理字典表","web.CDSS.IMP.ConNurseDict","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
    }
	q result
}*/
/// Creator:钟荣枫 
/// CreatDate:2020-12-25
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.ConNurseDict 对接方护理字典表
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.ConNurseDict).FormValidate("26274","I21.103","5","37")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hosp As %String) As %String
{
	s flag=""
	s flagc=""
	s flagd=""
	s:((code'="")&&(hosp'="")&&(desc'="")) flagc=$d(^CT.WDT.CDSS.ConNurseDictI("HospCNIndex",hosp,code,desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0))
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
		s idd=""
		s:((code'="")&&(hosp'="")&&(desc'="")) idc=$o(^CT.WDT.CDSS.ConNurseDictI("HospCNIndex",hosp,code,desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// w ##class(web.CDSS.IMP.ConNurseDict).TestSave()
ClassMethod TestSave() As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
	S eobj.ID=""
	S eobj.NursingCode="11A"
	S eobj.NursingName="测试11"
	s eobj.Source="住院"
	s eobj.NursingType="护理"
	s eobj.HospitalAreaDR="31||9"
	s eobj.State="未关联"
	s eobj.HospitalDR="31"
	s result=..SaveEntity(eobj,"")
	
	q result
}

/// Creator:钟荣枫 
/// CreatDate: 2020-12-25
/// Description：对接方护理字典表
/// Table:CT.WDT.CDSS.ConNurseDict 对接方护理字典表
/// Input: eobj As web.CDSSEntity.IMP.ConNurseDict
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConNurseDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.ConNurseDict, LogFlag As %String = "") As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.Source="" eobj.Source="住院"
		s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	    s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	    s:eobj.NursingCode="" eobj.NursingCode=..getFactorCode()    
		s flag=..FormValidate(eobj.ID,eobj.NursingCode,eobj.NursingName,eobj.HospitalDR)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.ConNurseDict).%New()
	        s:eobj.CreateDate="" eobj.CreateDate=$ZDATETIME($HOROLOG,3)
	        s:eobj.CreateUser="" eobj.CreateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	        //s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	        //s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.ConNurseDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
			s bobj.ID = eobj.ID
			
			s bobj.NursingCode= obj.NursingCode		//代码
			s bobj.NursingName= obj.NursingName		//描述
			s bobj.NursingType=obj.NursingType		//类型（护理/治疗/处置）
			
			s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
			s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
			s bobj.Remarks=obj.Remarks		//备注
			s bobj.State=obj.State		//状态（未关联/已关联/已确认/已删除）
			s bobj.CreateDate=obj.CreateDate		//创建时间（数据导入或者手动新增的时间）
			s bobj.CreateUser=obj.CreateUser		//创建人
			s bobj.UpdateDate=obj.UpdateDate	//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s bobj.UpdateUser=obj.UpdateUser		//修改人
			s bobj.StartDate=obj.StartDate
			s bobj.EndDate=obj.EndDate
		}
		
		s obj.NursingCode= eobj.NursingCode		//代码
		s obj.NursingName= eobj.NursingName		//描述
		s obj.NursingType=eobj.NursingType		//类型（护理/治疗/处置）
		
		s obj.Source=eobj.Source		//来源（住院/门诊/急诊）
		d:eobj.HospitalDR'="" obj.HospitalDRSetObjectId(eobj.HospitalDR)		//所属医院
		d:eobj.HospitalDR="" obj.HospitalDRSetObjectId("")
		s obj.Remarks=eobj.Remarks		//备注
		s obj.State=eobj.State		//状态（未关联/已关联/已确认/已删除）
		s obj.CreateDate=eobj.CreateDate		//创建时间（数据导入或者手动新增的时间）
		s obj.CreateUser=eobj.CreateUser		//创建人
		s obj.UpdateDate=eobj.UpdateDate	//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s obj.UpdateUser=eobj.UpdateUser		//修改人
		s obj.StartDate=eobj.StartDate
		s obj.EndDate=eobj.EndDate
			
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
				
				if (eobj.HospitalAreaDR'="") //03-09
				{
					s areatotal=$l(eobj.HospitalAreaDR,",")
					for areai=1:1:areatotal
					{
						s areaID=$p(eobj.HospitalAreaDR,",",areai)
						s resultx=##class(web.CDSS.IMP.ConDictConArea).SaveData("","护理",id,areaID)
						if (resultx["false")
						{
							q
						}
					}
					//d ##class(web.CDSS.IMP.ConDictConArea).SaveData("","护理",id,eobj.HospitalAreaDR)
				
				}
			}
			
			if (LogFlag="")
			{
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConNurseDict","CT.WDT.CDSS.ConNurseDict","对接方护理字典表",id,eobj.NursingName,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConNurseDict","CT.WDT.CDSS.ConNurseDict","对接方护理字典表",id,eobj.NursingName,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方护理字典表","web.CDSS.IMP.ConNurseDict","SaveEntity",eobj)
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
/// Table:CT.WDT.CDSS.ConNurseDict对接方护理对照表
/// Input：id
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.ConNurseDictD(""),-1)
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
/// Description：修改对接方护理字典表的状态
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input： id, state 状态
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).UpdateState("","")
ClassMethod UpdateState(id, state)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConNurseDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
	s bobj.ID = id
	
	s bobj.NursingCode= obj.NursingCode		//代码
	s bobj.NursingName= obj.NursingName		//描述
	s bobj.NursingType=obj.NursingType		//类型（护理/治疗/处置）
	
	s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
	s bobj.Remarks=obj.Remarks		//备注
	s bobj.State=state		//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=obj.CreateDate		//创建时间（数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		//修改人
	
	s result= ..SaveEntity(bobj)
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：导出导入模板
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input： 
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).ExportTemplate()
ClassMethod ExportTemplate()
{
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="对接方护理字典表导入模板.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName
	s file=##class(%File).%New(P)*/
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"对接方护理字典表导入模板.csv"		
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
	d file.Write("护理代码,"_"护理描述,"_"类型,"_"来源,"_"备注,"_"医院")
	d file.WriteLine()
	
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：自动匹配
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input： hosp 医院id, id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).AutoMatch(hosp)
ClassMethod AutoMatch(hosp As %String, id As %String = "")
{
	q:(hosp="") "{success:'false',errorinfo:'自动匹配失败，传入的医院为空！'}"
	s result=""
	s linksavecount=0
	s unlinksavecount=0
	
	//生成护理检索索引(名称或别名中包含括号或者-的数据处理后生成到一个临时global里，用于后面的匹配)
	d ##class(web.CDSS.IMP.ConNurseDict).CreateNurseIndex()
	
	//遍历所有未关联的护理
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConNurseDictI("HospStateIndex",hosp,"未关联",ID))
		q:ID=""
		continue:((id'="")&&(id'=ID))
		s TrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","护理",ID,0)) //当前数据在对照表中的ID
		s DictCode= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),2)		//代码
		s DictName= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),3)		//通用名
		//s DictName=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),4)		//商品名		
		
		//0 从已确认数据中找名称相同的数据
		s NurseID=$o(^CT.WDT.CDSS.ConNurseDictI("StateDescIndex","已确认",DictName,0))
		s ConIDFlag=0
		s:NurseID'="" ConIDFlag=$d(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","护理",NurseID))
		if (ConIDFlag>0)  //如果有已确认的名称相同的数据，则跟该数据对照同样的知识库数据
		{
			s DictDRStr=""
			s ConID=0
			for
			{
				s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","护理",NurseID,ConID))
				q:ConID=""
				s DictDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)  //对照的知识库字典ID
				s:DictDRStr'="" DictDRStr=DictDRStr_","
				s DictDRStr=DictDRStr_DictDR
				
			}
			//调用关联方法保存对照数据
			s result=..BatchMapping(ID,DictDRStr,"",1)
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
			//his商品名处理符号：去除空格；全角转半角；小括号-中文；逗号-中文；中括号-英文；去除<>及其中内容；去除%及前面数字														
			s DictNameNew=##class(web.CDSS.IMP.ContrastDict).DealBracketBeforeCon(DictName)	  
			//1 his商品名和知识库名和别名匹配
			s RowID=..FindDictIdByName(DictNameNew)
			
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
						//3 忽略对接方商品名括号 "()"、"[]"、"（）"、"【】" 跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNoBracket)
					}
					//4 忽略知识库名称和别名中的括号"()"、"[]"、"（）"、"【】" 进行匹配
					if (RowID="")&($d(^TEMPCDSSCON("NurseIndex",1))>0)
					{
						s RowID=$o(^TEMPCDSSCON("NurseIndex",1,$zconvert(DictNameNoBracket,"U"),0))
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
						//5 忽略对接方商品名括号 "()"、"[]"、"（）"、"【】" 及内容跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNoBracketinside)
					}
					//6 忽略知识库名称和别名中的括号"()"、"[]"、"（）"、"【】"及内容 进行匹配
					if (RowID="")&($d(^TEMPCDSSCON("NurseIndex",2))>0)
					{
						s RowID=$o(^TEMPCDSSCON("NurseIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
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
						s RowID=..FindDictIdByName(DictNameNOMinus)
					}
					//8 忽略知识库名称和别名中的 -  进行匹配
					if (RowID="")&($d(^TEMPCDSSCON("NurseIndex",3))>0)
					{
						s RowID=$o(^TEMPCDSSCON("NurseIndex",3,$zconvert(DictNameNOMinus,"U"),0))
					}
				}
			}
			if (RowID'="")
			{
				//调用关联方法保存对照数据
				s result=..BatchMapping(ID,RowID,"",1)
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
	k ^TEMPCDSSCON("NurseIndex")
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：建立关联
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input： hisid 项目护理id，dictid 护理知识库id，remark-备注
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConNursingDict).Mapping(1,7356,"")
ClassMethod Mapping(hisid As %String, dictid As %String, remark As %String = "")
{
	q:(hisid="")||(dictid="") "false"  //项目护理id或东华护理id为空则输出错误信息
	s result=""
	s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s eobj.ID = ""
	s eobj.ContrastType= "护理"		//对照类型
	s eobj.ConDictCode=$lg($g(^CT.WDT.CDSS.ConNurseDictD(hisid)),2)	//对接方字典代码
	s eobj.ConDictName=$lg($g(^CT.WDT.CDSS.ConNurseDictD(hisid)),3)		//对接方字典描述
	s eobj.HospitalDR =$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(hisid)),6)	//医院
	s eobj.Remarks=remark		//备注	
	s eobj.DictCode= $lg($g(^CT.WDT.CDSS.NursingDictD(dictid)),3)		//知识库字典代码
	s eobj.DictName= $lg($g(^CT.WDT.CDSS.NursingDictD(dictid)),4)		//知识库字典描述
	q:(eobj.ConDictCode="")||(eobj.ConDictName="")||(eobj.DictCode="")||(eobj.DictName="")||(eobj.HospitalDR="") "false"	//对照表中的必填字段有一个为空就输出错误信息，不能对照
	s eobj.State="已关联"		//状态（未关联/已关联/已确认/已删除）
	s eobj.DictDR=dictid       //知识库id
	s eobj.IntDictDR=hisid 		//对接方护理id	
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
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input：HisID-项目护理字典id，DictIDStr 东华护理id串（用,分开），remark-备注，hospareaDR-院区id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConNursingDict).BatchMapping(250391,00001111,"测试商品名1228111","胃散,乙醇","","101||14")
ClassMethod BatchMapping(HisID As %String, DictIDStr As %String, remark As %String, hospareaDR As %String)
{
	q:(HisID="")||(DictIDStr)="" "{success:'false',errorinfo:'传入的项目数据id或者东华知识id为空！'}"
	s result=""
	TS	
	//先删除原来的对照
	s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex","护理",HisID,""))
	if ((flag'=""))
	{
		s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"护理")
	}
	//s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"护理")
	if (result'["false")
	{
		//再重新保存对照数据
		s DictTotal=$l(DictIDStr,",")
		for DictLen=1:1:DictTotal
		{
			s dictid=$p(DictIDStr,",",DictLen)
			s result=..Mapping(HisID,dictid,remark)
			if (result["false")
			{
				q
			}
		}
	}
	//把对接方护理字典的数据改为已关联的状态
	if (result'["false")
	{
		s result=..UpdateState(HisID,"已关联")
	}
	//保存对接方字典关联院区 
	if (result'["false")&&((hospareaDR="")||(hospareaDR["||"))  //如果传入的院区为空 或是正确的格式才保存对接方字典关联院区 ，如果不是正确的格式则不需要处理该表数据
	{

		//找到这个护理关联的院区（有多个的用英文,拼接）
		s HospAreaDRStr=""
		s HospAreaID=0
		for
		{
			s HospAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","护理",HisID,HospAreaID))
			q:HospAreaID=""
			s:HospAreaDRStr'="" HospAreaDRStr=HospAreaDRStr_","
			s HospAreaDRStr=HospAreaDRStr_HospAreaID
		}

		if (HospAreaDRStr'=hospareaDR)  //如果原来关联的院区和传入的院区数据不一致
		{
			s result=##class(web.CDSS.IMP.ConDictConArea).DelHospArea("护理",HisID)  //先删除之前的关联院区
			//重新关联院区，否则对接方关联院区表会有冗余数据
			if (hospareaDR'="")&&(result'["false")
			{
				s areatotal=$l(hospareaDR,",")
				for areai=1:1:areatotal
				{
					s areaID=$p(hospareaDR,",",areai)
					s result=##class(web.CDSS.IMP.ConDictConArea).SaveData("","护理",HisID,areaID)
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
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).ExportMapping("","","38","","","","","")
ClassMethod ExportMapping(nursingcode As %String, nursingdesc As %String, hospid As %String, type As %String, state As %String, source As %String, dictdesc As %String, remark As %String)
{
	//s ^TMP("hl1")=hospid_","_type	
	/*s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"护理字典对照结果.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName*/
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"护理字典对照结果.txt"		
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
	
	w "来源	客户护理代码	客户护理名称	类型	东华护理名称	状态	类型	医院	备注"
	
	s:nursingcode'="" nursingcode=$ZCONVERT(nursingcode,"U") //转换成大写
	s:nursingdesc'="" nursingdesc=$ZCONVERT(nursingdesc,"U") //转换成大写
	s:dictdesc'="" dictdesc=$ZCONVERT(dictdesc,"U") //转换成大写
	s:remark'="" remark=$ZCONVERT(remark,"U") //转换成大写
	
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConNurseDictD(ID))
		q:ID=""
		s NursingCode= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),2)		//代码
		continue:((nursingcode'="")&&($ZCONVERT(NursingCode,"U")'[nursingcode))
		s NursingName= $lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),3)		//描述
		continue:((nursingdesc'="")&&($ZCONVERT(NursingName,"U")'[nursingdesc))
		s NursingType=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),4)		//类型（护理/治疗/处置）
		continue:((type'="")&&(NursingType'=type))
		
		s Source=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),5)		//来源（住院/门诊/急诊）
		continue:((source'="")&&(Source'=source))
		s HospitalDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(ID)),6)	//所属医院
		continue:((hospid'="")&&(HospitalDR'=hospid))
		s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),7)		//备注
		
		s State=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),8)		//状态（未关联/已关联/已确认/已删除）
		if (state="")	//默认不显示 已删除
		{
			continue:(State="已删除")
		}
		else
		{
			continue:(State'=state)
		}
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),9)		//创建时间（数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),10)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),11)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConNurseDictD(ID)),12)		//修改人
			
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,0))
		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注
		
		if (haveState'="")
		{
			s ConState=""
			for
			{
				s ConState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ConState))
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
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"护理",ID,ConState,ConID))
					q:ConID=""
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
						w !,Source_"	"_NursingCode_"	"_NursingName_"	"_NursingType_"	"_DictName_"	"_ConState_"	"_"护理	"_HospitalDesc_"	"_ConRemarks
					}
				}
			} 
		}
		else
		{
			w !,Source_"	"_NursingCode_"	"_NursingName_"	"_NursingType_"	"_DictName_"	"_ConState_"	"_"护理	"_HospitalDesc_"	"_ConRemarks
		}
	}
		
	c file
	q fileName
}

/// Creator：钟荣枫 
/// CreatDate: 2020-11-20
/// Description：批量导入对接方护理
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).SaveImportData("5[next]氢氧化钠[next]氢氧化钠[next][next][next]门诊[next]山大二院 [next]")
ClassMethod SaveImportData(dataStr, hosp)
{
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		

	s NursingCode=$p(dataStr,"[next]",1)
	s:NursingCode="" NursingCode=..getFactorCode()
	s NursingName=$p(dataStr,"[next]",2)
	q:NursingName="" "false" 
	s StartDate=$p(dataStr,"[next]",3)
	s EndDate=$p(dataStr,"[next]",4)
	s Source=$p(dataStr,"[next]",5)
	q:Source="" "false" 
	s Remarks=$p(dataStr,"[next]",6)
	s NursingType=$p(dataStr,"[next]",7)
	q:((NursingType'="护理")&&(NursingType'="治疗")&&(NursingType'="处置")) "false" 
	
	s bobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
	s bobj.ID = ""
	s bobj.NursingCode= NursingCode		//代码
	s bobj.NursingName= NursingName		//描述
	s bobj.NursingType=NursingType		//类型（护理/治疗/处置）
	s bobj.Source=Source				//来源（住院/门诊/急诊）
	s bobj.HospitalDR =hosp				//所属医院
	s bobj.Remarks=Remarks				//备注
	s bobj.State="未关联"				//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=$ZDATETIME($HOROLOG,3)					//创建时间（数据导入或者手动新增的时间）
	s bobj.CreateUser=$g(%session.Data("LOGON.USERNAME"))		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)					//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		//修改人
	s bobj.StartDate=StartDate
	s bobj.EndDate=EndDate
	s re=..SaveEntity(bobj)
	if (re["true")	//保存成功
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
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input： hospid 医院id
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).GetLastTime(hospid)
ClassMethod GetLastTime1(hosp)
{
	s lasttime=""	
	s CreateTime=0
	for
	{
		s CreateTime=$o(^CT.WDT.CDSS.ConNurseDictI("CreateDateIndex",hosp,CreateTime))
		q:CreateTime=""
		s lasttime=CreateTime
	}
	
	q lasttime
}

ClassMethod GetLastTime(hosp)
{
	s lasttime=""
	
	if ($d(^CT.WDT.CDSS.ConNurseDictI("CreateDateIndex",hosp)))
	{
		s lasttime=$o(^CT.WDT.CDSS.ConNurseDictI("CreateDateIndex",hosp,""),-1)
	}	
	q lasttime
}

/// Creator：钟荣枫 
/// CreatDate: 2020-11-20
/// Description：批量导入对接方护理
/// Table:CT.WDT.CDSS.ConNurseDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).ImportData(path)
ClassMethod ImportData(path)
{
	//("护理代码,"_"护理描述,"_"类型,"_"来源,"_"备注,"_"医院")
	s readcount=0
	s savecount=0
	s nosavecount=0
	s samecount=0
	Ts
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s NursingCode=$p(str,",",1)
		s NursingName=$p(str,",",2)
		continue:NursingName="" 
		s NursingType=$p(str,",",3)
		continue:((NursingType'="护理")&&(NursingType'="治疗")&&(NursingType'="处置"))  
		s Source=$p(str,",",4)
		s Remarks=$p(str,",",5)
		s HospitalDesc=$p(str,",",6)
		s HospitalDR="" 
		if (HospitalDesc'="")
		{
			s HospitalDR=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_$zconvert(HospitalDesc,"U"),0))
			
		}
		continue:HospitalDR="" 
	
	
		s NursingCode=$Zstrip(NursingCode,"<>W")
		s NursingName=$zstrip(NursingName,"<>W")
		s Source=$zstrip(Source,"<>W")
		s Remarks=$zstrip(Remarks,"<>W")
		s readcount=readcount+1
		s flag=..FormValidate("",NursingCode,NursingName,HospitalDR)
		if (flag=1)		//判断重复
		{
			s samecount = samecount+1
		}
		else
		{
			s bobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
			s bobj.ID = ""
			
			s bobj.NursingCode= NursingCode		//代码
			s bobj.NursingName= NursingName		//描述
			s bobj.NursingType=NursingType		//类型（护理/治疗/处置）
			
			s bobj.Source=Source		//来源（住院/门诊/急诊）
			s bobj.HospitalDR =HospitalDR	//所属医院
			s bobj.Remarks=Remarks		//备注
			s bobj.State="未关联"		//状态（未关联/已关联/已确认/已删除）
			s bobj.CreateDate=$ZDATETIME($HOROLOG,3)		//创建时间（数据导入或者手动新增的时间）
			s bobj.CreateUser=$g(%session.Data("LOGON.USERNAME"))		//创建人
			s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		//修改人
			
			s re=..SaveEntity(bobj)
			if (re["true")	//保存成功
			{
				s savecount=savecount+1	
			}
			else
			{
				s nosavecount=nosavecount+1	
			}
		}

	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount："_nosavecount,!
	w "重复:"_samecount,!
	
	q "{success:'true'}"
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：护理匹配    
/// Input： Desc
/// Return：NurseID 护理表ID
/// w ##class(web.CDSS.IMP.ConNurseDict).NurseProcessing("Graves病")
ClassMethod NurseProcessing(Desc As %String)
{
	q:Desc="" ""
	s Desc = $ZCONVERT(Desc,"U")
	
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.NursingDictD(ID))
		q:ID=""
		s state=$lg($g(^CT.WDT.CDSS.NursingDictD(ID)),22)  //知识库数据不是可对照状态
		continue:(state'=2)
		s Name=$zconvert($lg($g(^CT.WDT.CDSS.NursingDictD(ID)),4),"U") 	 	
		s AliasName=$zconvert($lg($g(^CT.WDT.CDSS.NursingDictD(ID)),23),"U")
		
		
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
		s Desc1=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Desc)
		s Name1=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		q:##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Desc)=Name
	}
	q ID
}

/// Creator:ZWW
/// CreatDate: 2023-03-09
/// Description：删除关联，将状态改已删除
/// Table:CT.WDT.CDSS.ConNurseDict 对接方护理字典表
/// Input: id，remark 备注
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConNurseDict).DelMapping()
ClassMethod DelMapping(id, remark)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConNurseDict).%OpenId(id)
		
	s bobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
	s bobj.ID = id
		
	s bobj.NursingCode= obj.NursingCode		//代码
	s bobj.NursingName= obj.NursingName		//描述
	s bobj.NursingType=obj.NursingType		//类型（护理/治疗/处置）
	s bobj.Source=obj.Source				//来源（住院/门诊/急诊）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
	s bobj.Remarks=remark					//备注
	s bobj.State="已删除"					//状态（未关联/已关联/已确认/已删除）
	s bobj.CreateDate=obj.CreateDate		//创建时间（数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)				//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))	//修改人
	s bobj.StartDate=obj.StartDate
	s bobj.EndDate=obj.EndDate
	
	d obj.%Close()
	s result=..SaveEntity(bobj)		
			
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2023-03-15
/// Description：生成护理检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("NurseIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConNurseDict).CreateNurseIndex()
ClassMethod CreateNurseIndex()
{
	k ^TEMPCDSSCON("NurseIndex")
	s NurseID=0
	for 
	{
		s NurseID=$o(^CT.WDT.CDSS.NursingDictD(NurseID))
		q:NurseID=""
		s state=$lg($g(^CT.WDT.CDSS.NursingDictD(NurseID)),22)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.NursingDictD(NurseID)),4)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("NurseIndex",1,NewName,NurseID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("NurseIndex",2,NewName,NurseID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("NurseIndex",3,NewName,NurseID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.NursingDictD(NurseID)),23)	
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
					s ^TEMPCDSSCON("NurseIndex",1,NewAliasDesc,NurseID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("NurseIndex",2,NewAliasDesc,NurseID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("NurseIndex",3,NewAliasDesc,NurseID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：谷雪萍
/// CreatDate: 2023-03-14
/// Description：通过名称找知识库字典ID
/// Table:CT.WDT.CDSS.NursingDict\CT.WDT.CDSS.Alias
/// Input： DictName-护理名称
/// Return：RowID—护理字典ID
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).FindDictIdByName("安立泽片")
ClassMethod FindDictIdByName(DictName)
{
	q:DictName="" ""
	s RowID=$o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
	if (RowID'="")	//判断是否已审核
	{
		s flag=$lg($g(^CT.WDT.CDSS.NursingDictD(RowID)),22)
		s:flag'=2 RowID=""
	}
	if (RowID="")
	{
		s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.NursingDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
		if (RowID'="") //判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.NursingDictD(RowID)),22)
			s:flag'=2 RowID=""
		}
			
	}
	q RowID
}

/// Creator：胡宜良	
/// CreatDate: 2023-04-03
/// Description：删除 对接方护理字典表未关联数据
/// Table:CT.WDT.CDSS.ConNurseDict 对接方护理字典表未关联数据
/// Input：hosp 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ConNurseDict).DeleteUnlinkedData(31)
ClassMethod DeleteUnlinkedData(hosp As %String) As %String
{
	s result="" 
	s id=0 
	for
	{
		s id=$o(^CT.WDT.CDSS.ConNurseDictI("HospStateIndex",hosp,"未关联",id))
		q:id=""
			
		s pobj = ##class(CT.WDT.CDSS.ConNurseDict).%OpenId(id)
		s eobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
		
		s eobj.NursingCode= pobj.NursingCode							//代码
		s eobj.NursingName= pobj.NursingName							//名称
		s eobj.NursingType=pobj.NursingType									//ICD
		s eobj.Source=pobj.Source									//来源（住院/门诊/急诊）
		s:pobj.HospitalDR'="" eobj.HospitalDR = pobj.HospitalDR.%Id() //所属医院
		s eobj.Remarks=pobj.Remarks	                                //备注
		s eobj.State=pobj.State		                                    //状态（未关联/已关联/已确认/已删除）
		s eobj.CreateDate=pobj.CreateDate		                     //创建时间（诊断数据导入或者手动新增的时间）
		s eobj.CreateUser=pobj.CreateUser		                     //创建人
		s eobj.UpdateDate=pobj.UpdateDate		             //修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s eobj.UpdateUser=pobj.UpdateUser		 //修改人
		s eobj.StartDate=pobj.StartDate
		s eobj.EndDate=pobj.EndDate
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(CT.WDT.CDSS.ConNurseDict).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ConNurseDict","CT.WDT.CDSS.ConNurseDict","对接方护理字典表",id,eobj.HospitalDR_"-"_eobj.NursingCode_"-"_eobj.NursingName,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("对接方护理字典表","web.CDSS.IMP.ConNurseDict","DeleteUnlinkedData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

}
