/// 名称:实施综合管理平台-对接方中药字典表
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 胡宜良
/// 编写日期:2022-08-10
Class web.CDSS.IMP.ConTCMDict Extends %RegisteredObject
{

/// Creator：胡宜良 		
/// CreatDate: 2022-08-10
/// Description：查询 对接方中药字典表
/// Table:CT.WDT.CDSS.ConTCMDict 对接方中药字典表
/// Input:id ,code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConTCMDict","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ID,TCMCode,TCMName,TCMTradeName,TCMAlias,Source,Manufacturers,TCMComposition,DosageForm,Specification,HospitalDR,Remarks,State,CreateDate,CreateUser,UpdateDate,UpdateUser,StartDate,EndDate")
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
		
		s TCMCode= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),2)			//代码
		s TCMName= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),3)			//通用名
		s TCMTradeName=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),4)		//商品名
		s TCMAlias=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),5)			//别名
		s Source=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),6)			//来源（住院/门诊/急诊）
		s Manufacturers=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),7)		//厂家
		s TCMComposition=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),8)	//成分
		s DosageForm=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),9)		//剂型
		s Specification=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),10)	//规格
		s HospitalDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConTCMDictD(ID)),11)	//所属医院
		s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),12)			//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
		s State=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),13)			//状态（未关联/已关联/已确认/已删除）
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),14)		//创建时间（中药数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),15)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),16)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),17)		//修改人
		s StartDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),18)		//开始日期
		s EndDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),19)			//结束日期
		
		d OutputRow	
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.ConTCMDictD(ID))
			q:ID=""
			s TCMCode= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),2)			//代码
			continue:((code'="")&&($zconvert(TCMCode,"U")'[code))
			s TCMName= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),3)			//通用名
			continue:((desc'="")&&($zconvert(TCMName,"U")'[desc))
			s TCMTradeName=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),4)		//商品名
			s TCMAlias=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),5)			//别名
			s Source=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),6)			//来源（住院/门诊/急诊）
			s Manufacturers=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),7)		//厂家
			s TCMComposition=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),8)	//成分
			s DosageForm=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),9)		//剂型
			s Specification=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),10)	//规格
			s HospitalDesc=""
			s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConTCMDictD(ID)),11)	//所属医院
			s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
			s Remarks=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),12)			//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
			s State=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),13)			//状态（未关联/已关联/已确认/已删除）
			s CreateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),14)		//创建时间（中药数据导入或者手动新增的时间）
			s CreateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),15)		//创建人
			s UpdateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),16)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s UpdateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),17)		//修改人
			s StartDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),18)		//开始日期
			s EndDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),19)			//结束日期
			d OutputRow
		
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,TCMCode,TCMName,TCMTradeName,TCMAlias,Source,Manufacturers,TCMComposition,DosageForm,Specification,HospitalDR,Remarks,State,CreateDate,CreateUser,UpdateDate,UpdateUser,StartDate,EndDate)
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

/// Creator：胡宜良 		
/// CreatDate: 2022-08-10
/// Description：查询 对接方中药字典的对照  
/// Table:CT.WDT.CDSS.ConTCMDict 对接方中药字典表
/// Input:drugid 中药id,TCMCode 中药代码，tcmdesc 中药通用名，TCMTradeName 商品名hospid 医院id，state 状态，manufacturers 厂家，source 来源，dictdesc 知识库描述，remark 备注，sortmethod 排序方式
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConTCMDict","GetConList","","","","","31","","","","","","Short")
Query GetConList(drugid As %String, tcmcode As %String, tcmdesc As %String, tcmtradename As %String, hospid As %String, state As %String, manufacturers As %String, source As %String, dictdesc As %String, remark As %String, sortmethod) As %Query(ROWSPEC = "RowID,TCMCode,TCMName,TCMTradeName,Source,Manufacturers,Specification,HospitalDR,HospitalDesc,ConRemarks,DictID,DictCode,DictName,ConState,HospAreaDesc,HospitalAreaDR")
{
}

ClassMethod GetConListExecute(ByRef qHandle As %Binary, drugid As %String, tcmcode As %String, tcmdesc As %String, tcmtradename As %String, hospid As %String, state As %String, manufacturers As %String, source As %String, dictdesc As %String, remark As %String, sortmethod) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:tcmcode'="" tcmcode=$ZCONVERT(tcmcode,"U") //转换成大写
	s:tcmdesc'="" tcmdesc=$ZCONVERT(tcmdesc,"U") //转换成大写
	s:tcmtradename'="" tcmtradename=$ZCONVERT(tcmtradename,"U") //转换成大写
	s:dictdesc'="" dictdesc=$ZCONVERT(dictdesc,"U") //转换成大写
	s:manufacturers'="" manufacturers=$ZCONVERT(manufacturers,"U") //转换成大写
	
	if (drugid'="") //根据rowid返回该条记录
	{
		s ID=drugid
		s HospAreaDR="",HospAreaDesc="",HospitalAreaDR="",HospitalAreaDRStr=""
		for
		{
			s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","中药",ID,HospAreaDR))
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
		s TCMCode= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),2)		//代码
		s TCMName= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),3)		//通用名
		s TCMTradeName=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),4)		//商品名
		s Source=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),6)		//来源（住院/门诊/急诊）
		s Manufacturers=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),7)		//厂家
		s Specification=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),10)		//规格
		s HospitalDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConTCMDictD(ID)),11)	//所属医院
		s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),12)		//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
		s State=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),13)		//状态（未关联/已关联/已确认/已删除）
		
		
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),14)		//创建时间（中药数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),15)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),16)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),17)		//修改人
		
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,0))
		s DictNameStr="",DictCodeStr="",DictIDStr="" //知识库描述串、知识库代码串、ID串
		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

		if (haveState'="")  //如果有对照
		{
			//走对照表，找对接的知识库id、代码、描述
			s ContrastState=""
			for
			{
				s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,ContrastState))
				q:ContrastState=""
				
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,ContrastState,ConID))
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
		//RowID,TCMCode,TCMName,TCMTradeName,Source,Manufacturers,Specification,HospitalDR,HospitalDesc,Remarks,DictCode,DictName,ConState
		if (sortmethod="Short")
		{
			s num=0
			s CreateTime=""
			for
			{
				s CreateTime=$o(^CT.WDT.CDSS.ConTCMDictI("CreateDateIndex",hospid,CreateTime),-1)
				q:CreateTime=""
				s ID=0
				for 
				{
					s ID=$o(^CT.WDT.CDSS.ConTCMDictI("CreateDateIndex",hospid,CreateTime,ID))
					q:ID=""
					s TCMCode= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),2)		//代码
					s TCMName= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),3)		//通用名
					s length=$l(TCMName)
					s ^TempDataHandle("Short",length,ID)=ID
				}
			}
			s num=0
			s le=0
			for
			{
				s le=$o(^TempDataHandle("Short",le))
				q:le=""
				s DrugID=0
				for
				{
					s DrugID=$o(^TempDataHandle("Short",le,DrugID))
					q:DrugID=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=DrugID
				}
			}
			
		}
		elseif (sortmethod="UpdateTime")	//按修改日期排序
		{
			s num=0
			s UpdateTime=""
			for
				{
					s UpdateTime=$o(^CT.WDT.CDSS.ConTCMDictI("UpdateDateIndex",hospid,UpdateTime),-1)
					q:UpdateTime=""
					s ID=0
					for
					{
						s ID=$o(^CT.WDT.CDSS.ConTCMDictI("UpdateDateIndex",hospid,UpdateTime,ID))
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
				s CreateTime=$o(^CT.WDT.CDSS.ConTCMDictI("CreateDateIndex",hospid,CreateTime),-1)
				q:CreateTime=""
				s ID=0
				for 
				{
					s ID=$o(^CT.WDT.CDSS.ConTCMDictI("CreateDateIndex",hospid,CreateTime,ID))
					q:ID=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=ID
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
				s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","中药",ID,HospAreaDR))
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
			s TCMCode= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),2)		//代码
			continue:((tcmcode'="")&&($ZCONVERT(TCMCode,"U")'[tcmcode))
			s TCMName= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),3)		//通用名
			continue:((tcmdesc'="")&&($ZCONVERT(TCMName,"U")'[tcmdesc))
			s TCMTradeName=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),4)		//商品名
			continue:((tcmtradename'="")&&($ZCONVERT(TCMTradeName,"U")'[tcmtradename))
			s TCMAlias=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),5)		//别名
			s Source=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),6)		//来源（住院/门诊/急诊）
			continue:((source'="")&&($ZCONVERT(Source,"U")'[source))
			s Manufacturers=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),7)		//厂家
			continue:((manufacturers'="")&&($ZCONVERT(Manufacturers,"U")'[manufacturers))
			s TCMComposition=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),8)		//成分
			s DosageForm=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),9)		//剂型
			s Specification=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),10)		//规格
			s HospitalDesc=""
			s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConTCMDictD(ID)),11)	//所属医院
			continue:((hospid'="")&&(HospitalDR'=hospid))
			//s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","中药",ID,0))
        	//continue:(ConID="")
			s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
			s Remarks=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),12)		//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
			s State=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),13)		//状态（未关联/已关联/已确认/已删除）
			if (state="")	//默认不显示 已删除
			{
				continue:(State="已删除")
			}
			else
			{
				continue:(State'=state)
			}
			s CreateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),14)		//创建时间（中药数据导入或者手动新增的时间）
			s CreateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),15)		//创建人
			s UpdateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),16)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s UpdateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),17)		//修改人
			s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,0))
			s DictNameStr="",DictCodeStr="",DictIDStr="" //知识库描述串、知识库代码串、ID串
			s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

			if (haveState'="")  //如果有对照
				{
					//走对照表，找对接的知识库id、代码、描述
					s ContrastState=""
					for
					{
						s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,ContrastState))
						q:ContrastState=""
						
						s ConID=0
						for
						{
							s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,ContrastState,ConID))
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
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputConList
    set Data=$lb(RowID,TCMCode,TCMName,TCMTradeName,Source,Manufacturers,Specification,HospitalDR,HospitalDesc,ConRemarks,DictID,DictCode,DictName,ConState,HospAreaDesc,HospitalAreaDR)
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

/// Creator:胡宜良 
/// CreatDate:2022-08-10
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.ConTCMDict 对接方中药字典表
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.ConTCMDict).FormValidate("26274","I21.103","5","37")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hosp As %String) As %String
{
	s flag=""
	s flagc=""
	s flagd=""
	s:((code'="")&&(desc'="")&&(hosp'="")) flagc=$d(^CT.WDT.CDSS.ConTCMDictI("HospCNIndex",hosp,code,desc))
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
		s:((code'="")&&(desc'="")&&(hosp'="")) idc=$o(^CT.WDT.CDSS.ConTCMDictI("HospCNIndex",hosp,code,desc,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:胡宜良 
/// CreatDate: 2022-08-10
/// Description：对接方中药字典表
/// Table:CT.WDT.CDSS.ConTCMDict 对接方中药字典表
/// Input: eobj As web.CDSSEntity.IMP.ConTCMDict
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConTCMDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.ConTCMDict, LogFlag As %String = "") As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.Source="" eobj.Source="住院"
		s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	    s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	    s:eobj.TCMCode="" eobj.TCMCode=..getFactorCode()	   
		s flag=..FormValidate(eobj.ID,eobj.TCMCode,eobj.TCMTradeName,eobj.HospitalDR)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.ConTCMDict).%New()
	        s:eobj.CreateDate="" eobj.CreateDate=$ZDATETIME($HOROLOG,3)
	        s:eobj.CreateUser="" eobj.CreateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.ConTCMDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.ConTCMDict).%New()
			s bobj.ID = eobj.ID
			
			s bobj.TCMCode= obj.TCMCode		//代码
			s bobj.TCMName= obj.TCMName		//通用名
			s bobj.TCMTradeName=obj.TCMTradeName		//商品名
			s bobj.TCMAlias=obj.TCMAlias		//别名
			s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
			s bobj.Manufacturers=obj.Manufacturers		//厂家
			s bobj.TCMComposition=obj.TCMComposition		//成分
			s bobj.DosageForm=obj.DosageForm		//剂型
			s bobj.Specification=obj.Specification		//规格
			s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
			s bobj.Remarks=obj.Remarks	//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
			s bobj.State=obj.State		//状态（未关联/已关联/已确认/已删除）
			
			s bobj.CreateDate=obj.CreateDate		//创建时间（中药数据导入或者手动新增的时间）
			s bobj.CreateUser=obj.CreateUser		//创建人
			s bobj.UpdateDate=obj.UpdateDate		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s bobj.UpdateUser=obj.UpdateUser		//修改人
			s bobj.StartDate=obj.StartDate			//医嘱开始时间
			s bobj.EndDate=obj.EndDate				//医嘱开始时间
	
		}
		
		s obj.TCMCode= eobj.TCMCode		//代码
		s obj.TCMName= eobj.TCMName		//通用名
		s obj.TCMTradeName=eobj.TCMTradeName		//商品名
		s obj.TCMAlias=eobj.TCMAlias		//别名
		s obj.Source=eobj.Source		//来源（住院/门诊/急诊）
		s obj.Manufacturers=eobj.Manufacturers		//厂家
		s obj.TCMComposition=eobj.TCMComposition		//成分
		s obj.DosageForm=eobj.DosageForm		//剂型
		s obj.Specification=eobj.Specification		//规格
		d:eobj.HospitalDR'="" obj.HospitalDRSetObjectId(eobj.HospitalDR)		//所属医院
		d:eobj.HospitalDR="" obj.HospitalDRSetObjectId("")
		
		s obj.Remarks=eobj.Remarks	//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
		s obj.State=eobj.State		//状态（未关联/已关联/已确认/已删除）

		s obj.CreateDate=eobj.CreateDate		//创建时间（中药数据导入或者手动新增的时间）
		s obj.CreateUser=eobj.CreateUser		//创建人
		s obj.UpdateDate=eobj.UpdateDate		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s obj.UpdateUser=eobj.UpdateUser		//修改人
		s obj.StartDate=eobj.StartDate			//医嘱开始时间
		s obj.EndDate=eobj.EndDate				//医嘱开始时间
			
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
						s resultx=##class(web.CDSS.IMP.ConDictConArea).SaveData("","中药",id,areaID)
						if (resultx["false")
						{
							q
						}
					}
					//d ##class(web.CDSS.IMP.ConDictConArea).SaveData("","中药",id,eobj.HospitalAreaDR)
				}
			}
			if (LogFlag="")
			{
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConTCMDict","CT.WDT.CDSS.ConTCMDict","对接方中药字典表",id,eobj.TCMName,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConTCMDict","CT.WDT.CDSS.ConTCMDict","对接方中药字典表",id,eobj.TCMName,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方中药字典表","web.CDSS.IMP.ConTCMDict","SaveEntity",eobj)
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

/// Creator：胡宜良
/// Description：得到新增数据的code
/// Table:CT.WDT.CDSS.ConTCMDict对接方诊断对照表
/// Input：id
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.ConTCMDictD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s result = dataid+1
	}
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2022-08-10
/// Description：修改对接方中药字典表的状态
/// Table:CT.WDT.CDSS.ConTCMDict
/// Input： id, state 状态
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).UpdateState("","")
ClassMethod UpdateState(id, state)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConTCMDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.IMP.ConTCMDict).%New()
	s bobj.ID = id
	
	s bobj.TCMCode= obj.TCMCode		//代码
	s bobj.TCMName= obj.TCMName		//通用名
	s bobj.TCMTradeName=obj.TCMTradeName		//商品名
	s bobj.TCMAlias=obj.TCMAlias		//别名
	s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
	s bobj.Manufacturers=obj.Manufacturers		//厂家
	s bobj.TCMComposition=obj.TCMComposition		//成分
	s bobj.DosageForm=obj.DosageForm		//剂型
	s bobj.Specification=obj.Specification		//规格
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
	s bobj.Remarks=obj.Remarks	//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
	s bobj.State=state		//状态（未关联/已关联/已确认/已删除）
	
	        
	s bobj.CreateDate=obj.CreateDate		//创建时间（中药数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		//修改人
	s bobj.StartDate=obj.StartDate
	s bobj.EndDate=obj.EndDate
	
	s result= ..SaveEntity(bobj)
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2022-08-10
/// Description：导出导入模板
/// Table:CT.WDT.CDSS.ConTCMDict
/// Input： 
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).ExportTemplate()
ClassMethod ExportTemplate()
{
		
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="对接方中药字典表导入模板.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName
	s file=##class(%File).%New(P)*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"对接方中药字典表导入模板.csv"		
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
	d file.Write("中药代码,"_"中药通用名,"_"客户商品名,"_"规格,"_"厂家,"_"来源,"_"备注,"_"医院")
	d file.WriteLine()
	
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator：胡宜良 
/// CreatDate: 2022-08-10
/// Description：自动匹配
/// Table:CT.WDT.CDSS.ConTCMDict
/// Input： hosp 医院id, id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).AutoMatch(hosp)
ClassMethod AutoMatch(hosp As %String, id As %String = "")
{
	q:(hosp="") "{success:'false',errorinfo:'自动匹配失败，传入的医院为空！'}"
	s result=""
	s linksavecount=0
	s unlinksavecount=0
	
	//生成中药检索索引(名称或别名中包含括号或者-的数据处理后生成到一个临时global里，用于后面的匹配)
	d ##class(web.CDSS.IMP.ConTCMDict).CreateTCMIndex()
	
	//遍历所有未关联的中药
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConTCMDictI("HospStateIndex",hosp,"未关联",ID))
		q:ID=""
		continue:((id'="")&&(id'=ID))
		s TrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","中药",ID,0)) //当前数据在对照表中的ID
		s DictCode= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),2)		//代码
		s DictDesc= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),3)		//通用名
		s DictName=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),4)		//商品名		
		
		 //0 从已确认数据中找名称相同的数据
		s DrugID=$o(^CT.WDT.CDSS.ConTCMDictI("StateDescIndex","已确认",DictName,0))
		s ConIDFlag=0
		s:DrugID'="" ConIDFlag=$d(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","中药",DrugID))
		if (ConIDFlag>0)  //如果有已确认的名称相同的数据，则跟该数据对照同样的知识库数据
		{
			s DictDRStr=""
			s ConID=0
			for
			{
				s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex","中药",DrugID,ConID))
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
			
			//2 his通用名和知识库名和别名匹配
			if (RowID="")&&(DictDesc'="")
			{
				//his通用名处理符号：去除空格；全角转半角；小括号-中文；逗号-中文；中括号-英文；去除<>及其中内容；去除%及前面数字		
				s DictDescNew=##class(web.CDSS.IMP.ContrastDict).DealBracketBeforeCon(DictDesc)	  
				s RowID=..FindDictIdByName(DictDescNew)
			}
			
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
					if (RowID="")&($d(^TEMPCDSSCON("TCMIndex",1))>0)
					{
						s RowID=$o(^TEMPCDSSCON("TCMIndex",1,$zconvert(DictNameNoBracket,"U"),0))
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
					if (RowID="")&($d(^TEMPCDSSCON("TCMIndex",2))>0)
					{
						s RowID=$o(^TEMPCDSSCON("TCMIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
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
					if (RowID="")&($d(^TEMPCDSSCON("TCMIndex",3))>0)
					{
						s RowID=$o(^TEMPCDSSCON("TCMIndex",3,$zconvert(DictNameNOMinus,"U"),0))
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
	k ^TEMPCDSSCON("TCMIndex")
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：建立关联
/// Table:CT.WDT.CDSS.ConTCMDict
/// Input： hisid 项目中药id，dictid 中药知识库id，remark-备注
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).Mapping(1,7356,"")
ClassMethod Mapping(hisid As %String, dictid As %String, remark As %String = "")
{
	q:(hisid="")||(dictid="") "false"  //项目中药id或东华中药id为空则输出错误信息
	s result=""
	s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s eobj.ID = ""
	s eobj.ContrastType= "中药"		//对照类型
	s eobj.ConDictCode=$lg($g(^CT.WDT.CDSS.ConTCMDictD(hisid)),2)	//对接方字典代码
	s eobj.ConDictName=$lg($g(^CT.WDT.CDSS.ConTCMDictD(hisid)),4)		//对接方字典描述
	s eobj.HospitalDR =$LISTGET($G(^CT.WDT.CDSS.ConTCMDictD(hisid)),11)	//医院
	s eobj.Remarks=remark		//备注	
	s eobj.DictCode= $lg($g(^CT.WDT.CDSS.TCMMedicineD(dictid)),2)		//知识库字典代码
	s eobj.DictName= $lg($g(^CT.WDT.CDSS.TCMMedicineD(dictid)),3)		//知识库字典描述
	q:(eobj.ConDictCode="")||(eobj.ConDictName="")||(eobj.DictCode="")||(eobj.DictName="")||(eobj.HospitalDR="") "false"	//对照表中的必填字段有一个为空就输出错误信息，不能对照
	s eobj.State="已关联"		//状态（未关联/已关联/已确认/已删除）
	s eobj.DictDR=dictid       //知识库id
	s eobj.IntDictDR=hisid 		//对接方中药id	
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
/// Table:CT.WDT.CDSS.ConTCMDict
/// Input：HisID-项目中药字典id，DictIDStr 东华中药id串（用,分开），remark-备注，hospareaDR-院区id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).BatchMapping(250391,00001111,"测试商品名1228111","胃散,乙醇","","101||14")
ClassMethod BatchMapping(HisID As %String, DictIDStr As %String, remark As %String, hospareaDR As %String)
{
	q:(HisID="")||(DictIDStr)="" "{success:'false',errorinfo:'传入的项目数据id或者东华知识id为空！'}"
	s result=""
	TS	
	//先删除原来的对照
	s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex","中药",HisID,""))
	if ((flag'=""))
	{
		s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,"中药")
	}
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
	//把对接方中药字典的数据改为已关联的状态
	if (result'["false")
	{
		s result=..UpdateState(HisID,"已关联")
	}
	//保存对接方字典关联院区
	if (result'["false")&&((hospareaDR="")||(hospareaDR["||"))  //如果传入的院区为空 或是正确的格式才保存对接方字典关联院区 ，如果不是正确的格式则不需要处理该表数据
	{

		//找到这个中药关联的院区（有多个的用英文,拼接）
		s HospAreaDRStr=""
		s HospAreaID=0
		for
		{
			s HospAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex","中药",HisID,HospAreaID))
			q:HospAreaID=""
			s:HospAreaDRStr'="" HospAreaDRStr=HospAreaDRStr_","
			s HospAreaDRStr=HospAreaDRStr_HospAreaID
		}

		if (HospAreaDRStr'=hospareaDR)  //如果原来关联的院区和传入的院区数据不一致
		{
			s result=##class(web.CDSS.IMP.ConDictConArea).DelHospArea("中药",HisID)  //先删除之前的关联院区
			//重新关联院区，否则对接方关联院区表会有冗余数据
			if (hospareaDR'="")&&(result'["false")
			{
				s areatotal=$l(hospareaDR,",")
				for areai=1:1:areatotal
				{
					s areaID=$p(hospareaDR,",",areai)
					s result=##class(web.CDSS.IMP.ConDictConArea).SaveData("","中药",HisID,areaID)
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

/// Creator：胡宜良 
/// CreatDate: 2022-08-10
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.ConTCMDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).ExportMapping()
ClassMethod ExportMapping(tcmcode As %String, tcmdesc As %String, tcmtradename As %String, hospid As %String, state As %String, manufacturers As %String, source As %String, dictdesc As %String, remark As %String)
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"中药字典对照结果.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"中药字典对照结果.txt"		
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
	
	w "来源	客户中药代码	客户通用名	客户商品名	规格包装	厂家	类型	东华通用名	状态	医院	备注"

	
	s:tcmcode'="" tcmcode=$ZCONVERT(tcmcode,"U") //转换成大写
	s:tcmdesc'="" tcmdesc=$ZCONVERT(tcmdesc,"U") //转换成大写
	s:tcmtradename'="" tcmtradename=$ZCONVERT(tcmtradename,"U") //转换成大写
	s:dictdesc'="" dictdesc=$ZCONVERT(dictdesc,"U") //转换成大写
	s:manufacturers'="" manufacturers=$ZCONVERT(manufacturers,"U") //转换成大写
	
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConTCMDictD(ID))
		q:ID=""
		s TCMCode= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),2)		//代码
		continue:((tcmcode'="")&&($ZCONVERT(TCMCode,"U")'[tcmcode))
		s TCMName= $lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),3)		//通用名
		
		continue:((tcmdesc'="")&&($ZCONVERT(TCMName,"U")'[tcmdesc))
		s TCMTradeName=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),4)		//商品名
		continue:((tcmtradename'="")&&($ZCONVERT(TCMTradeName,"U")'[tcmtradename))
		s TCMAlias=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),5)		//别名
		s Source=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),6)		//来源（住院/门诊/急诊）
		continue:((source'="")&&($ZCONVERT(Source,"U")'[source))
		s Manufacturers=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),7)		//厂家
		continue:((manufacturers'="")&&($ZCONVERT(Manufacturers,"U")'[manufacturers))
		s TCMComposition=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),8)		//成分
		s DosageForm=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),9)		//剂型
		s Specification=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),10)		//规格
		s HospitalDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ConTCMDictD(ID)),11)	//所属医院
		continue:((hospid'="")&&(HospitalDR'=hospid))
		
		s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),12)		//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
		s State=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),13)		//状态（未关联/已关联/已确认/已删除）
		if (state="")	//默认不显示 已删除
		{
			continue:(State="已删除")
		}
		else
		{
			continue:(State'=state)
		}
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),14)		//创建时间（中药数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),15)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),16)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConTCMDictD(ID)),17)		//修改人
		
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,0))
		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

		if (haveState'="")
		{
			s ConState=""
			for
			{
				s ConState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,ConState))
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
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"中药",ID,ConState,ConID))
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
						continue:((remark'="")&&(ConRemarks'=remark))
						w !,Source_"	"_TCMCode_"	"_TCMName_"	"_TCMTradeName_"	"_Specification_"	"_Manufacturers_"	"_"中药	"_DictName_"	"_ConState_"	"_HospitalDesc_"	"_ConRemarks
					}	
				}	
			} 
		}
		else
		{
			w !,Source_"	"_TCMCode_"	"_TCMName_"	"_TCMTradeName_"	"_Specification_"	"_Manufacturers_"	"_"中药	"_DictName_"	"_ConState_"	"_HospitalDesc_"	"_ConRemarks
		}			
	}
	c file
	q fileName
}

/// Creator：胡宜良 
/// CreatDate: 2022-08-10
/// Description：批量导入对接方中药
/// Table:CT.WDT.CDSS.ConTCMDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).SaveImportData("5[next]氢氧化钠[next]氢氧化钠[next][next][next]门诊[next]山大二院 [next]")
ClassMethod SaveImportData(dataStr, hosp)
{
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		
	
	s TCMCode=$p(dataStr,"[next]",1)
	s:TCMCode="" TCMCode=..getFactorCode()
	s TCMName=$p(dataStr,"[next]",2)
	q:TCMName="" "false" 
	s TCMTradeName=$p(dataStr,"[next]",3)
	s StartDate=$p(dataStr,"[next]",4)
	s EndDate=$p(dataStr,"[next]",5)
	s Source=$p(dataStr,"[next]",6)
	q:Source="" "false" 
	s Remarks=$p(dataStr,"[next]",7)
	s Specification=$p(dataStr,"[next]",8)
	s Manufacturers=$p(dataStr,"[next]",9)
	s DosageForm=$p(dataStr,"[next]",10)

	s bobj = ##class(web.CDSSEntity.IMP.ConTCMDict).%New()
	s bobj.ID = ""
	
	s bobj.TCMCode= TCMCode				//代码
	s bobj.TCMName= TCMName				//通用名
	s bobj.TCMTradeName=TCMTradeName		//商品名
	s bobj.Source=Source					//来源（住院/门诊/急诊）
	s bobj.Manufacturers=Manufacturers		//厂家
	s bobj.Specification=Specification		//规格
	s bobj.DosageForm=DosageForm			//剂型
	s bobj.HospitalDR =hosp					//所属医院
	s bobj.State="未关联"					//状态（未关联/已关联/已确认/已删除）
	s bobj.Remarks=Remarks
	
	s bobj.CreateDate=$ZDATETIME($HOROLOG,3)		//创建时间（中药数据导入或者手动新增的时间）
	s bobj.CreateUser=$g(%session.Data("LOGON.USERNAME"))		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))		//修改人
	s bobj.StartDate=StartDate
	s bobj.EndDate=EndDate
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

/// Creator：胡宜良 
/// CreatDate: 2022-08-10
/// Description：获取最近一次新增数据时间
/// Table:CT.WDT.CDSS.ConTCMDict
/// Input： hospid 医院id
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).GetLastTime(hospid)
ClassMethod GetLastTime1(hosp)
{
	s lasttime=""	
	s CreateTime=0
	for
	{
		s CreateTime=$o(^CT.WDT.CDSS.ConTCMDictI("CreateDateIndex",hosp,CreateTime))
		q:CreateTime=""
		s lasttime=CreateTime
	}
	
	q lasttime
}

ClassMethod GetLastTime(hosp)
{
	s lasttime=""
	
	if ($d(^CT.WDT.CDSS.ConTCMDictI("CreateDateIndex",hosp)))
	{
		s lasttime=$o(^CT.WDT.CDSS.ConTCMDictI("CreateDateIndex",hosp,""),-1)
	}	
	q lasttime
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：中药匹配    
/// Input： Desc
/// Return：DrugID 中药表ID
/// w ##class(web.CDSS.IMP.ConTCMDict).DrugProcessing("青果")
ClassMethod DrugProcessing(Desc As %String)
{
	q:Desc="" ""
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.TCMMedicineD(ID))
		q:ID=""
		s state=$lg($g(^CT.WDT.CDSS.TCMMedicineD(ID)),13)  //知识库数据不是可对照状态
		continue:(state'=2)
		s Name=$zconvert($lg($g(^CT.WDT.CDSS.TCMMedicineD(ID)),3),"U") 	 	
		s AliasName=$zconvert($lg($g(^CT.WDT.CDSS.TCMMedicineD(ID)),4),"U")
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
/// Table:CT.WDT.CDSS.ConTCMDict 对接方中药字典表
/// Input: id，remark 备注
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConTCMDict).DelMapping(1733,"cs")
ClassMethod DelMapping(id, remark)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConTCMDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.IMP.ConTCMDict).%New()	
	s bobj.ID=id
	s bobj.TCMCode= obj.TCMCode		//代码
	s bobj.TCMName= obj.TCMName		//通用名
	s bobj.TCMTradeName=obj.TCMTradeName		//商品名
	s bobj.TCMAlias=obj.TCMAlias		//别名
	s bobj.Source=obj.Source		//来源（住院/门诊/急诊）
	s bobj.Manufacturers=obj.Manufacturers		//厂家
	s bobj.TCMComposition=obj.TCMComposition		//成分
	s bobj.DosageForm=obj.DosageForm		//剂型
	s bobj.Specification=obj.Specification		//规格
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//所属医院
	s bobj.Remarks=remark	//备注（医院自制中药/药监局未报批中药/非中药/原料药/中药名称不明确/中药饮片/耗材）
	s bobj.State="已删除"		//状态（未关联/已关联/已确认/已删除）
	
	        
	s bobj.CreateDate=obj.CreateDate		//创建时间（中药数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))		//修改人
	s bobj.StartDate=obj.StartDate
	s bobj.EndDate=obj.EndDate
	
	d obj.%Close()
	
	s result=..SaveEntity(bobj)		
			
	q result
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成中药检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("TCMIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConTCMDict).CreateTCMIndex()
ClassMethod CreateTCMIndex()
{
	k ^TEMPCDSSCON("TCMIndex")
	s DrugID=0
	for 
	{
		s DrugID=$o(^CT.WDT.CDSS.TCMMedicineD(DrugID))
		q:DrugID=""
		s state=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugID)),13)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugID)),3)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("TCMIndex",1,NewName,DrugID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("TCMIndex",2,NewName,DrugID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("TCMIndex",3,NewName,DrugID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugID)),4)	
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
					s ^TEMPCDSSCON("TCMIndex",1,NewAliasDesc,DrugID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("TCMIndex",2,NewAliasDesc,DrugID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("TCMIndex",3,NewAliasDesc,DrugID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-14
/// Description：通过名称找知识库字典ID
/// Table:CT.WDT.CDSS.TCMMedicine\CT.WDT.CDSS.Alias
/// Input： DictName-中药名称
/// Return：RowID—中药字典ID
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).FindDictIdByName("安立泽片")
ClassMethod FindDictIdByName(DictName)
{
	q:DictName="" ""
	s RowID=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
	if (RowID'="")	//判断是否已审核
	{
		s flag=$lg($g(^CT.WDT.CDSS.TCMMedicineD(RowID)),13)
		s:flag'=2 RowID=""
	}
	if (RowID="")
	{
		s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TCMMedicine"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
		if (RowID'="") //判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.TCMMedicineD(RowID)),13)
			s:flag'=2 RowID=""
		}
			
	}
	q RowID
}

/// Creator：胡宜良	
/// CreatDate: 2023-04-03
/// Description：删除 对接方中药字典表未关联数据
/// Table:CT.WDT.CDSS.ConTCMDict 对接方中药字典表未关联数据
/// Input：hosp 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ConTCMDict).DeleteUnlinkedData(31)
ClassMethod DeleteUnlinkedData(hosp As %String) As %String
{
	s result="" 
	s id=0 
	for
	{
		s id=$o(^CT.WDT.CDSS.ConTCMDictI("HospStateIndex",hosp,"未关联",id))
		q:id=""
			
		s pobj = ##class(CT.WDT.CDSS.ConTCMDict).%OpenId(id)
		s eobj = ##class(web.CDSSEntity.IMP.ConTCMDict).%New()
		
		s eobj.TCMCode= pobj.TCMCode							//代码
		s eobj.TCMName= pobj.TCMName							//名称
		s eobj.TCMTradeName=pobj.TCMTradeName									//ICD
		s eobj.Source=pobj.Source									//来源（住院/门诊/急诊）
		s:pobj.HospitalDR'="" eobj.HospitalDR = pobj.HospitalDR.%Id() //所属医院
		s eobj.Manufacturers=pobj.Manufacturers		//厂家
		s eobj.TCMComposition=pobj.TCMComposition		//成分
		s eobj.DosageForm=pobj.DosageForm		//剂型
		s eobj.Specification=pobj.Specification		//规格
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
		s sc=##class(CT.WDT.CDSS.ConTCMDict).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ConTCMDict","CT.WDT.CDSS.ConTCMDict","对接方中药字典表",id,eobj.HospitalDR_"-"_eobj.TCMCode_"-"_eobj.TCMName,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("对接方中药字典表","web.CDSS.IMP.ConTCMDict","DeleteUnlinkedData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

}
