/// Creator:钟荣枫
/// CreatDate:2020-12-23
/// Description：字典对照2.0 对照字典表
/// Table：CT.WDT.CDSS.ContrastDict
Class web.CDSS.IMP.ContrastDict Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2020-12-24
/// Description：查询(暂未用)  
/// Table:CT.WDT.CDSS.ContrastDict
/// Input:id, code, desc,
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ContrastDict","GetDetailList","","","")
Query GetDetailList(rowid As %String, hospital As %String, type As %String, dictcode As %String, condictid As %String) As %Query(ROWSPEC = "ID,DictCode,DictName,ContrastType,ConDictCode,ConDictName,State,HospitalDR,Remarks")
{
}

ClassMethod GetDetailListExecute(ByRef qHandle As %Binary, rowid As %String, hospital As %String, type As %String, dictid As %String, condictid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	//DictCode,DictName,ContrastType,ConDictCode,ConDictName,State,HospitalDR,Remarks
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),2)		//知识库字典代码
		s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),3)		//知识库字典描述
		s ContrastType= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),4)		//对照类型
		s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),5)		//对接方字典代码
		s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),6)		//对接方字典描述
		s State=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态（未关联/已关联/已确认/已删除）
		s HospitalDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),8)		//医院
		s Remarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),9)		//备注

		d OutputRow
	}
	else
	{
		s ID=0
		for 
		{
			//Index TypeIndex On (HospitalDR As Exact, ContrastType As Exact);
			s ID=$o(^CT.WDT.CDSS.ContrastDictD(ID))
			q:ID=""
			s ContrastType= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),4)		//对照类型
			continue:((type'="")&&(type'=ContrastType))
			s HospitalDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),8)		//医院
			continue:((hospital'="")&&(hospital'=HospitalDR))
			
			s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),2)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),3)		//知识库字典描述
			
			
			s DictID=..GetDictID(ContrastType,DictCode)	//获取CDSS字典id
			
			
			
			
			s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),5)		//对接方字典代码
			s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),6)		//对接方字典描述
			s State=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态（未关联/已关联/已确认/已删除）
			
			s HospitalDesc=""
			s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
			s Remarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),9)		//备注
			
	
		  	d OutputRow
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,DictCode,DictName,ContrastType,ConDictCode,ConDictName,State,HospitalDR,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailListExecute ]
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
/// CreatDate:2020-12-25
/// Description:获取字典表的id
/// Table: CT.WDT.CDSS.ExamDict 检查字典表,CT.WDT.CDSS.LabInspectionDict 检验字典表
/// Input: type 类型，dictcode 知识库代码
/// Return:id
/// Other:w ##class(web.CDSS.IMP.ContrastDict).GetDictID("CT.WDT.CDSS.SignInfo","cs01")
ClassMethod GetDictID(type As %String, dictcode As %String) As %String
{
	s:dictcode'="" dictcode=$ZCONVERT(dictcode,"U")  //转换成大写
	s DictID=""
	if (type="诊断")	////疾病字典表
	{
		s DictID=$o(^CT.WDT.CDSS.DiseaseDictI("CodeIndex"," "_dictcode,0))
	}
	if (type="检查")	//检查字典表
	{
		s DictID=$o(^CT.WDT.CDSS.ExamDictI("CodeIndex"," "_dictcode,0))
	}
	if (type="检验")	//检验字典表
	{
		s DictID=$o(^CT.WDT.CDSS.LabInspectionDictI("CodeIndex"," "_dictcode,0))
	}
	if (type="药品")	//药品字典表
	{
		s DictID=$o(^CT.WDT.CDSS.DrugDictI("CodeIndex"," "_dictcode,0))
	}
	if (type="手术")	//手术字典表
	{
		s DictID=$o(^CT.WDT.CDSS.OperationDictI("CodeIndex"," "_dictcode,0))
	}
	if (type="频率")	//频率字典表
	{
		s DictID=$o(^CT.WDT.CDSS.FrequencyDictI("CodeIndex"," "_dictcode,0))
	}
	if (type="护理")	//护理字典表
	{
		s DictID=$o(^CT.WDT.CDSS.NursingDictI("CodeIndex"," "_dictcode,0))
	}
	if (type="中药")	//中药字典表
	{
		s DictID=$o(^CT.WDT.CDSS.TCMMedicineI("CodeIndex"," "_dictcode,0))
	}
	if (type="中医诊断")	//中医诊断字典表
	{
		s DictID=$o(^CT.WDT.CDSS.TCMDiseaseI("CodeIndex"," "_dictcode,0))
	}
	if (type="中医证型")	//中医证型字典表
	{
		s DictID=$o(^CT.WDT.CDSS.TCMSymptomI("CodeIndex"," "_dictcode,0))
	}	
	q DictID
}

/// Creator:钟荣枫 
/// CreatDate:2020-12-24
/// Description:获取总数，对照对照数，来源
/// Input:id, code
/// Return:totalcount_","_mapcount_","_datasource
/// Other:w ##class(web.CDSS.IMP.ContrastDict).GetMatchData("15","中医证型")
ClassMethod GetMatchData(HospitalID, ContrastType) As %String
{
	s result=""
	s totalcount=0
	s mapcount=0
	s datasource=""
	
	if (ContrastType="药品")		//药品
	{
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConDrugDictI("HospStateIndex",HospitalID,State))
			q:State=""
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConDrugDictI("HospStateIndex",HospitalID,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Source=$LISTGET($G(^CT.WDT.CDSS.ConDrugDictD(RowID)),6)
				if (datasource'[Source)		//不包含
				{
					if (datasource="")	//为空
					{
						s datasource=Source
					}
					else
					{
						s datasource=datasource_"|"_Source
					}
					
				}
				
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
				s mapcount=mapcount+1
				
			}
		}
	}
	
	if (ContrastType="诊断")		//诊断
	{
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospStateIndex",HospitalID,State))
			q:State=""
			
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospStateIndex",HospitalID,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Sources=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(RowID)),4)
				s size=$l(Sources,",")
				for i=1:1:size
				{
	    			s Source=$p(Sources,";",i)
	    			q:Source=""
					if (datasource'[Source)		//不包含
					{
						if (datasource="")	//为空
						{
							s datasource=Source
						}
						else
						{
							s datasource=datasource_"|"_Source
						}
						
					}
				}
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
				s mapcount=mapcount+1
				
			}
		}
	}
	
	if (ContrastType="检查检验")		//检查检验
	{
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConExamDictI("HospStateIndex",HospitalID,State))
			q:State=""
			
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospStateIndex",HospitalID,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Source=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(RowID)),7)
				if (datasource'[Source)		//不包含
				{
					if (datasource="")	//为空
					{
						s datasource=Source
					}
					else
					{
						s datasource=datasource_"|"_Source
					}
					
				}
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
			
				s mapcount=mapcount+1
				
			}
		}
	}
	
	if (ContrastType="手术")		//手术
	{
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConOperDictI("HospStateIndex",HospitalID,State))
			q:State=""
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospStateIndex",HospitalID,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Source=$LISTGET($G(^CT.WDT.CDSS.ConOperDictD(RowID)),4)
				if (datasource'[Source)		//不包含
				{
					if (datasource="")	//为空
					{
						s datasource=Source
					}
					else
					{
						s datasource=datasource_"|"_Source
					}
					
				}
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
				s mapcount=mapcount+1
				
			}
		}
	}
	
	if (ContrastType="护理")		//护理
	{
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConNurseDictI("HospStateIndex",HospitalID,State))
			q:State=""
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConNurseDictI("HospStateIndex",HospitalID,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Source=$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(RowID)),5)
				if (datasource'[Source)		//不包含
				{
					if (datasource="")	//为空
					{
						s datasource=Source
					}
					else
					{
						s datasource=datasource_"|"_Source
					}
					
				}
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
				s mapcount=mapcount+1
				
			}
		}
	}
	if (ContrastType="中药")		//中药
	{
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConTCMDictI("HospStateIndex",HospitalID,State))
			q:State=""
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConTCMDictI("HospStateIndex",HospitalID,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Source=$LISTGET($G(^CT.WDT.CDSS.ConTCMDictD(RowID)),6)
				if (datasource'[Source)		//不包含
				{
					if (datasource="")	//为空
					{
						s datasource=Source
					}
					else
					{
						s datasource=datasource_"|"_Source
					}
					
				}
				
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
				s mapcount=mapcount+1
				
			}
		}
	}
	if (ContrastType="中医诊断")		//诊断
	{
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConCMDiseDictI("HospStateIndex",HospitalID,16,State))
			q:State=""
			
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConCMDiseDictI("HospStateIndex",HospitalID,16,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Sources=$LISTGET($G(^CT.WDT.CDSS.ConCMDiseDictD(RowID)),4)
				s size=$l(Sources,",")
				for i=1:1:size
				{
	    			s Source=$p(Sources,";",i)
	    			q:Source=""
					if (datasource'[Source)		//不包含
					{
						if (datasource="")	//为空
						{
							s datasource=Source
						}
						else
						{
							s datasource=datasource_"|"_Source
						}
						
					}
				}
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
				s mapcount=mapcount+1
				
			}
		}
	}
	if (ContrastType="中医证型")		//证型
	{
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConCMDiseDictI("HospStateIndex",HospitalID,17,State))
			q:State=""
			
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConCMDiseDictI("HospStateIndex",HospitalID,17,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Sources=$LISTGET($G(^CT.WDT.CDSS.ConCMDiseDictD(RowID)),4)
				s size=$l(Sources,",")
				for i=1:1:size
				{
	    			s Source=$p(Sources,";",i)
	    			q:Source=""
					if (datasource'[Source)		//不包含
					{
						if (datasource="")	//为空
						{
							s datasource=Source
						}
						else
						{
							s datasource=datasource_"|"_Source
						}
						
					}
				}
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
				s mapcount=mapcount+1
				
			}
		}
	}
	if (ContrastType="输血品")||(ContrastType="检验标本")||(ContrastType="频率")||(ContrastType="体征信息")||(ContrastType="用法")||(ContrastType="单位")||(ContrastType="科室")		//其他字典表
	{
		s:(ContrastType'="检验标本")&&(ContrastType'="体征信息") ContrastType=ContrastType_"字典"
		s Type=$o(^CT.WDT.CDSS.ConClassDictI("DescIndex"," "_$zconvert(ContrastType,"U"),0))
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ConOtherDictI("HospStateIndex",Type,HospitalID,State))
			q:State=""
			
			s RowID=0
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospStateIndex",Type,HospitalID,State,RowID))
				q:RowID=""
				continue:(State="已删除")	//已删除数据不计入总数
				s totalcount=totalcount+1
				s Source=$LISTGET($G(^CT.WDT.CDSS.ConOtherDictD(RowID)),5)
				if (datasource'[Source)		//不包含
				{
					if (datasource="")	//为空
					{
						s datasource=Source
					}
					else
					{
						s datasource=datasource_"|"_Source
					}
					
				}
				//状态（未关联/已关联/已确认/已删除）
				continue:((State'="已关联")&&(State'="已确认"))
				s mapcount=mapcount+1
				
			}
		}
	}
	s result=totalcount_","_mapcount_","_datasource
	q result
}

/// Creator：钟荣枫 		
/// CreatDate: 2020-12-24
/// Description：查询 字典对照表，获取
/// Table:CT.WDT.CDSS.ContrastDict
/// Input:id 
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ContrastDict","GetList","15")
Query GetList(hospid As %String) As %Query(ROWSPEC = "HospitalID,HospitalDesc,ContrastType,Totalcount,Mapcount,Source,MapRate")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	q:hospid="" ""
	s Type="药品,诊断,检查检验,手术,护理,输血品,频率,检验标本,用法,单位,科室,中药,中医诊断,中医证型"
	
	s HospitalID=0
	s HospitalID=hospid
	s HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalID)),3)
	for m=1:1:$l(Type,",")
	{
		s ContrastType=$p(Type,",",m)
		s Datastr= ..GetMatchData(HospitalID,ContrastType)
		s Totalcount=0
		s Mapcount=0
		s Source=""
		s MapRate=0
		if (Datastr'="")	//数据串不为空
		{
			s Totalcount=$p(Datastr,",",1)		//总数
			s Mapcount=$p(Datastr,",",2)		//已匹配数
			s Source=$p(Datastr,",",3)		//来源
			s:(Mapcount'=0) MapRate=Mapcount/Totalcount
		}
		d OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(HospitalID,HospitalDesc,ContrastType,Totalcount,Mapcount,Source,MapRate)
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
/// Description：删除一条对照、或者多条对照中的一条对照
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ContrastDict).DeleteDatas("44",",2621,","2621[A]氧")
ClassMethod DeleteDatas(id As %String, dictid, str) As %String
{
	s result=""
	s pobj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s eobj.ID=id
	if (pobj.DictDR[",")
	{  
		s DictDR=..ReplaceStr($Replace(","_pobj.DictDR_",",dictid,""))
		s DictCode=..ReplaceStr($Replace(","_pobj.DictCode_",",","_$p(str,"[A]",1)_",",""))
		s DictName=..ReplaceStr($Replace(","_pobj.DictName_",",","_$p(str,"[A]",2)_",",""))
		s eobj.State=pobj.State
		s eobj.DictCode=DictCode					//知识库字典代码
		s eobj.DictName=DictName					//知识库字典描述
		s eobj.DictDR=DictDR	
	}
	else
	{
		s eobj.State="未关联"
		s eobj.DictCode= pobj.ConDictCode								//知识库字典代码
		s eobj.DictName= pobj.ConDictName							//知识库字典描述
		s eobj.DictDR=""
	}
	s eobj.ContrastType= pobj.ContrastType		//对照类型
	s eobj.ConDictCode=pobj.ConDictCode			//对接方字典代码
	s eobj.ConDictName=pobj.ConDictName			//对接方字典描述
 	s:pobj.HospitalDR'="" eobj.HospitalDR = pobj.HospitalDR.%Id()	//医院
	s eobj.Remarks=pobj.Remarks		//备注
	s eobj.IntDictDR=pobj.IntDictDR		
	d pobj.%Close()
	kill pobj
	s result=..SaveEntity(eobj)
	if (result["success")		
	{
		if (eobj.State="未关联")
		{
			d ..UpdateConDictState(eobj.IntDictDR,eobj.State,eobj.ContrastType)
		}
	}
	q result
}

/// Creator:钟荣枫 
/// CreatDate:2020-12-25
/// Description:去除两端逗号
/// Table:CT.WDT.CDSS.ContrastDict
/// Input:id 
/// Return:r
/// Other:w ##class(web.CDSS.IMP.ContrastDict).ReplaceStr(",100,") 
ClassMethod ReplaceStr(id) As %String
{
	s l=$l(id)
	s m=$e(id,1)
	s:m="," a=2
	s:m'="," a=1
	s n=$e(id,$l(id))
	s:n="," b=l-1
	s:n'="," b=l
	s r=$e(id,a,b)
	q r
}

/// Creator:钟荣枫 
/// CreatDate:2020-12-25
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.ContrastDict
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.ContrastDict).FormValidate("","1","药品","YY02","JC04")
ClassMethod FormValidate(id As %String, intdictdr As %String, type As %String, dictname As %String) As %String
{
	s flag=""
	s flagc=""
	s flagd=""
	s:(intdictdr'="")&&(type'="") flagc=$d(^CT.WDT.CDSS.ContrastDictI("NameIndex",type,intdictdr,dictname))
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
		s:(intdictdr'="")&&(type'="") idc=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex",type,intdictdr,dictname,0))
		
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	
	q flag
}

/// Creator:钟荣枫 
/// CreatDate: 2020-12-25
/// Description：保存 字典对照表
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input: eobj As web.CDSSEntity.IMP.ContrastDict
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.ContrastDict, LogFlag As %String = "") As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.ID,eobj.IntDictDR,eobj.ContrastType,eobj.DictName)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.ContrastDict).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
			s bobj.ID = eobj.ID
			
			s bobj.DictCode= obj.DictCode		//知识库字典代码
			s bobj.DictName= obj.DictName		//知识库字典描述
			s bobj.ContrastType= obj.ContrastType		//对照类型
			s bobj.ConDictCode=obj.ConDictCode		//对接方字典代码
			s bobj.ConDictName=obj.ConDictName		//对接方字典描述
			s bobj.State=obj.State		//状态（未关联/已关联/已确认/已删除）
			s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//医院
			s bobj.Remarks=obj.Remarks		//备注
			s bobj.DictDR=obj.DictDR
			s bobj.IntDictDR=obj.IntDictDR
		}
		s obj.DictCode= eobj.DictCode		//知识库字典代码
		s obj.DictName= eobj.DictName		//知识库字典描述
		s obj.ContrastType= eobj.ContrastType		//对照类型
		s obj.ConDictCode=eobj.ConDictCode		//对接方字典代码
		s obj.ConDictName=eobj.ConDictName		//对接方字典描述
		s obj.State=eobj.State		//状态（未关联/已关联/已确认/已删除）
		d:eobj.HospitalDR'="" obj.HospitalDRSetObjectId(eobj.HospitalDR)		//医院
		d:eobj.HospitalDR="" obj.HospitalDRSetObjectId("")
		s obj.Remarks=eobj.Remarks		//备注
		s obj.DictDR=eobj.DictDR
		s obj.IntDictDR=eobj.IntDictDR		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			if (LogFlag="")
			{
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ContrastDict","CT.WDT.CDSS.ContrastDict","字典对照表",id,eobj.ContrastType_"-"_eobj.DictName_"-"_eobj.ConDictName,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ContrastDict","CT.WDT.CDSS.ContrastDict","字典对照表",id,eobj.ContrastType_"-"_eobj.DictName_"-"_eobj.ConDictName,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("字典对照表","web.CDSS.IMP.ContrastDict","SaveEntity",eobj)
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

/// Creator:钟荣枫 
/// CreatDate: 2020-12-25
/// Description：修改字典对照数据的状态
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input: id，state 状态
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).UpdateState(250392,"已确认","药品")
ClassMethod UpdateState(id, state, type)
{
	s result=""
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s ID=0
	for
	{
		s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",type,id,ID))	
		q:ID=""
		
		s obj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(ID)
		s bobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
		s bobj.ID = ID
	
		s bobj.DictCode= obj.DictCode		//知识库字典代码
		s bobj.DictName= obj.DictName		//知识库字典描述
		s bobj.ContrastType= obj.ContrastType		//对照类型
		s bobj.ConDictCode=obj.ConDictCode		//对接方字典代码
		s bobj.ConDictName=obj.ConDictName		//对接方字典描述
		s bobj.State=state		//状态（未关联/已关联/已确认/已删除）
		s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//医院
		s bobj.Remarks=obj.Remarks		//备注
		s bobj.DictDR=obj.DictDR
		s bobj.IntDictDR=obj.IntDictDR
		d obj.%Close()
		s result=..SaveEntity(bobj)
	}
	if (result["true")		//修改对接方字典的状态
	{
		d ..UpdateConDictState(bobj.IntDictDR,bobj.State,bobj.ContrastType)
	}
	
	q result
}

/// Creator:钟荣枫 
/// CreatDate: 2020-12-25
/// Description：修改对接方字典数据的状态
/// Table:
/// Input: type 类型,state 状态,intdictdr对接方字典id
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).UpdateConDictState(1, "已关联", "诊断")
ClassMethod UpdateConDictState(intdictdr, state, type)
{
	s result=""
	if (type="药品")
	{
		s result= ##class(web.CDSS.IMP.ConDrugDict).UpdateState(intdictdr,state)
	}
	if (type="检查检验")
	{
		s result= ##class(web.CDSS.IMP.ConExamDict).UpdateState(intdictdr,state)
	}
	if (type="护理")
	{
		s result= ##class(web.CDSS.IMP.ConNurseDict).UpdateState(intdictdr,state)	
	}
	if (type="诊断")
	{
		s result= ##class(web.CDSS.IMP.ConDiseaseDict).UpdateState(intdictdr,state)	
	}
	if (type="手术")
	{
		s result= ##class(web.CDSS.IMP.ConOperDict).UpdateState(intdictdr,state)		
	}
	if (type="输血品")
	{
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="频率")
	{
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="检验标本")
	{
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="用法")
	{
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="单位")
	{
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="科室")
	{
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="中药")
	{
		s result= ##class(web.CDSS.IMP.ConTCMDict).UpdateState(intdictdr,state)		
	}
	if (type="中医诊断")
	{
		s result= ##class(web.CDSS.IMP.ConCMDiseDict).UpdateState(intdictdr,state)		
	}
	if (type="中医证型")
	{
		s result= ##class(web.CDSS.IMP.ConCMDiseDict).UpdateState(intdictdr,state)		
	}
	q result
}

/// Creator:钟荣枫 
/// CreatDate: 2020-12-25
/// Description：取消关联
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input: id，state 状态
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).CancelMapping(1349,2,"药品")
ClassMethod CancelMapping1(id)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(id)
		
	s bobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s bobj.ID = id
	
	s bobj.DictCode= obj.ConDictCode		//知识库字典代码
	s bobj.DictName= obj.ConDictName		//知识库字典描述
	s bobj.ContrastType= obj.ContrastType		//对照类型
	s bobj.ConDictCode=obj.ConDictCode		//对接方字典代码
	s bobj.ConDictName=obj.ConDictName		//对接方字典描述
	s bobj.State="未关联"		//状态（未关联/已关联/已确认/已删除）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//医院
	s bobj.Remarks=obj.Remarks		//备注
	s bobj.DictDR=""
	s bobj.IntDictDR=obj.IntDictDR
	d obj.%Close()
	s result=..SaveEntity(bobj)	
	if (result["true")
	{
		d ..UpdateConDictState(bobj.IntDictDR,bobj.State,bobj.ContrastType)
	}
		
			
	q result
}

/// Creator:胡宜良 
/// CreatDate: 2023-02-24
/// Description：取消关联，删掉对照表数据并修改对接方药品状态
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input: id，state 状态
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).CancelMapping(6271723,"药品")
ClassMethod CancelMapping(id, type)
{
	s result=""
	Tstart
	s ID=0
	for
	{
		s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",type,id,0))	
		q:ID=""
		s pobj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(ID)
		s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
		s eobj.ConDictCode=pobj.ConDictCode
		s eobj.ConDictName=pobj.ConDictName
		s eobj.ContrastType=pobj.ContrastType
		s eobj.DictCode=pobj.DictCode
		s eobj.DictDR=pobj.DictDR
		s eobj.DictName=pobj.DictName
		s:pobj.HospitalDR'="" eobj.HospitalDR = pobj.HospitalDR.%Id()
		s eobj.IntDictDR=pobj.IntDictDR
		s eobj.Remarks=pobj.Remarks
		s eobj.State=pobj.State
	
		d pobj.%Close()
		kill pobj
		s sc=##class(CT.WDT.CDSS.ContrastDict).%DeleteId(ID)
		d ..UpdateConDictState(eobj.IntDictDR,"未关联",eobj.ContrastType)
	}
	IF $$$ISOK(sc)
	{
		
		Tc
		s result="{success:'true',info:'取消关联成功！'}"
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ContrastDict","CT.WDT.CDSS.ContrastDict","字典对照",ID,eobj.ContrastType_"-"_eobj.DictCode_"-"_eobj.ConDictCode,"D",eobj)
	}
	else
	{
		Trollback
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("字典对照","CT.WDT.CDSS.ContrastDict","CancelMapping",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}

	q result
}

/// Creator:钟荣枫 
/// CreatDate: 2020-12-25
/// Description：删除关联，将状态改已删除
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input: id，remark 备注
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).DelMapping()
ClassMethod DelMapping(id, remark)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(id)
		
	s bobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s bobj.ID = id
	
	s bobj.DictCode= obj.ConDictCode		//知识库字典代码
	s bobj.DictName= obj.ConDictName		//知识库字典描述
	s bobj.ContrastType= obj.ContrastType		//对照类型
	s bobj.ConDictCode=obj.ConDictCode		//对接方字典代码
	s bobj.ConDictName=obj.ConDictName		//对接方字典描述
	s bobj.State="已删除"		//状态（未关联/已关联/已确认/已删除）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//医院
	s bobj.Remarks=remark		//备注
	s bobj.DictDR=""
	s bobj.IntDictDR=obj.IntDictDR
	d obj.%Close()
	
	s result=..SaveEntity(bobj)	
	if (result["true")
	{
		d ..UpdateConDictState(bobj.IntDictDR,bobj.State,bobj.ContrastType)
	}	
			
	q result
}

/// Creator:钟荣枫 
/// CreatDate: 2020-12-25
/// Description：删除关联，将状态改已删除
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input: id，remark 备注
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).DelMapping()
ClassMethod DelMapping1(id, type, remark)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	
	if (result["true")
	{
		d ..UpdateConDictState(bobj.IntDictDR,bobj.State,bobj.ContrastType)
		
	}	
			
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：批量确认
/// Table:CT.WDT.CDSS.ContrastDict
/// Input： idstr 药品id串
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ContrastDict).BatchConfirm("250392,250391","药品")
ClassMethod BatchConfirm(idstr As %String, type As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		s ID=0
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",type,ConID,0))	
			s state=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),7)
			continue:(state'="已关联")
			s re= ..UpdateState(ConID,"已确认",type)
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：批量取消
/// Table:CT.WDT.CDSS.ContrastDict
/// Input： idstr 药品id串
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ContrastDict).BatchCancel()
ClassMethod BatchCancel(idstr As %String, type As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		s ID=0
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",type,ConID,0))	
			s state=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),7)
			continue:((state'="已关联")&&(state'="已确认"))
			s re=..CancelMapping(ConID,type)
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2021-12-28
/// Description：删除某个医院下某个类型的所有项目数据以及对照数据
/// Table:
/// Input： Type 类型id，Hospital  医院id
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).DelMappingsOfType(2,31,1)
ClassMethod DelMappingsOfType(Type As %String, Hospital As %String, deldictflag As %String) As %String
{
	s result=""
	s errorflag=0
	s dicttype=$case(Type,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检验医嘱","14":"输血品","15":"中药","16":"中医诊断","17":"中医证型",:"")
	ts
	//Index HospIndex On (DictType As Exact, DictHosp As Exact);
	s DictHosp=""
	for
	{
		s DictHosp=$o(^CT.WDT.CDSS.ContrastDictI("HoapIntDictDRIndex",DictHosp))
		q:DictHosp=""
		q:errorflag=1
		continue:((Hospital'="")&&(Hospital'=DictHosp))
		s DictMapType=""
		for
		{
			s DictMapType=$o(^CT.WDT.CDSS.ContrastDictI("HoapIntDictDRIndex",DictHosp,DictMapType))
			q:DictMapType=""
			q:errorflag=1
			continue:((dicttype'="")&&(dicttype'=DictMapType))	
			s RowID=""
			for
			{
				s RowID=$o(^CT.WDT.CDSS.ContrastDictI("HoapIntDictDRIndex",DictHosp,DictMapType,RowID))
				q:RowID=""
				q:errorflag=1
				s MappingID=""
				for
				{
					s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("HoapIntDictDRIndex",DictHosp,DictMapType,RowID,MappingID))
					q:MappingID=""
					q:errorflag=1
					s re= ..DeleteData(MappingID)
					if (re["false")		//删除对照数据出错
					{
						s errorflag=1
					}
				}
				if ((errorflag'=1)&&(deldictflag'=""))	//未出错
				{
					s red=..DeleteIntData(Type,RowID)
					if (red["false") 
					{
						s errorflag=1	//删除对接方数据出错
					}
				}
			}
			
		}
		
	}
	s rex=..DeleteUnlinkedData(Type,Hospital)
	if ((rex["false")) 
	{
		s errorflag=1	//删除对接方数据出错
	}
	if (errorflag=1)	//失败
	{
		s result="false"
		tro	
	}
	else	//成功
	{
		s result="true"
		tc	
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2021-12-28
/// Description：根据id删除 字典对照表
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ContrastDict).DeleteData(1)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
		
	s pobj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s eobj.ConDictCode=pobj.ConDictCode
	s eobj.ConDictName=pobj.ConDictName
	s eobj.ContrastType=pobj.ContrastType
	s eobj.DictCode=pobj.DictCode
	s eobj.DictDR=pobj.DictDR
	s eobj.DictName=pobj.DictName
	s:pobj.HospitalDR'="" eobj.HospitalDR = pobj.HospitalDR.%Id()
	s eobj.IntDictDR=pobj.IntDictDR
	s eobj.Remarks=pobj.Remarks
	s eobj.State=pobj.State
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(CT.WDT.CDSS.ContrastDict).%DeleteId(id)
	s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex",eobj.ContrastType,eobj.IntDictDR,eobj.DictName))
	if (flag="") //该对接方数据无已关联的数据
	{
		d ..UpdateConDictState(eobj.IntDictDR,"未关联",eobj.ContrastType)
	}
	IF $$$ISOK(sc)
	{
		
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ContrastDict","CT.WDT.CDSS.ContrastDict","字典对照",id,eobj.ContrastType_"-"_eobj.DictCode_"-"_eobj.ConDictCode,"D",eobj)
	}
	else
	{
		Trollback
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("字典对照","CT.WDT.CDSS.ContrastDict","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}

	q result
}

/// Creator：阚延新
/// CreatDate: 2021-12-28
/// Description：根据id删除 对接方字典表表
/// Table:CT.WDT.CDSS.Con*Dict 对接方字典表表
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ContrastDict).DeleteIntData(1)
ClassMethod DeleteIntData(type As %String, id As %String) As %String
{
	s result=""
	if (type=1)
	{
		Tstart
		s sc=##class(CT.WDT.CDSS.ConDiseaseDict).%DeleteId(id)
	}
	if (type=2)||(type=3)||(type=13)
	{
		Tstart
		s sc=##class(CT.WDT.CDSS.ConExamDict).%DeleteId(id)
	}
	if (type=4)
	{
		Tstart
		s sc=##class(CT.WDT.CDSS.ConDrugDict).%DeleteId(id)
	}
	if (type=5)
	{
		Tstart
		s sc=##class(CT.WDT.CDSS.ConOperDict).%DeleteId(id)
	}
	if (type=6)
	{
		Tstart
		s sc=##class(CT.WDT.CDSS.ConNurseDict).%DeleteId(id)
	}
	if (type=7)||(type=8)||(type=9)||(type=10)||(type=11)||(type=12)||(type=14)
	{
		Tstart
		s sc=##class(CT.WDT.CDSS.ConOtherDict).%DeleteId(id)
	}
	if (type=15)
	{
		Tstart
		s sc=##class(CT.WDT.CDSS.ConTCMDict).%DeleteId(id)
	}
	if (type=16)||(type=17)
	{
		Tstart
		s sc=##class(CT.WDT.CDSS.ConCMDiseDict).%DeleteId(id)
	}	
	IF $$$ISOK(sc)
	{
		
		Tc
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		Trollback
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}

	q result
}

/// Creator：胡宜良
/// CreatDate: 2023-04-03
/// Description：根据类型和医院id删除 对接方字典表未关联数据
/// Table:CT.WDT.CDSS.Con*Dict 对接方字典表未关联数据
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ContrastDict).DeleteUnlinkedData(1,31)
ClassMethod DeleteUnlinkedData(type As %String, Hospital As %String) As %String
{
	s result=""
	if (type=1)
	{
		Tstart
		s result=##class(web.CDSS.IMP.ConDiseaseDict).DeleteUnlinkedData(Hospital)
	}
	if (type=2)||(type=3)||(type=13)
	{
		Tstart
		s result=##class(web.CDSS.IMP.ConExamDict).DeleteUnlinkedData(Hospital,type)
	}
	if (type=4)
	{
		Tstart
		s result=##class(web.CDSS.IMP.ConDrugDict).DeleteUnlinkedData(Hospital)
	}
	if (type=5)
	{
		Tstart
		s result=##class(web.CDSS.IMP.ConOperDict).DeleteUnlinkedData(Hospital)
	}
	if (type=6)
	{
		Tstart
		s result=##class(web.CDSS.IMP.ConNurseDict).DeleteUnlinkedData(Hospital)
	}
	if (type=7)||(type=8)||(type=9)||(type=10)||(type=11)||(type=12)||(type=14)
	{
		Tstart
		s result=##class(web.CDSS.IMP.ConOtherDict).DeleteUnlinkedData(Hospital,type)
	}
	if (type=15)
	{
		Tstart
		s result=##class(web.CDSS.IMP.ConTCMDict).DeleteUnlinkedData(Hospital)
	}
	if (type=16)||(type=17)
	{
		Tstart
		s result=##class(web.CDSS.IMP.ConCMDiseDict).DeleteUnlinkedData(Hospital,type)
	}	
	if (result["false")	//失败
	{
		tro	
	}
	else
	{
		tc
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2021-1-21
/// Description：将某个知识库的数据的对照数据删除
/// Table:CT.WDT.CDSS.ContrastDict
/// Input：type 类型 ,str 原来的代码[A]描述 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).DelMappings("药品","2621[A]氧")
ClassMethod DelMappings(type, str)
{
	s result=""
	//s type=$case(type,"药品":"药品","诊断":"1","检查":"检查检验","检验":"检查检验","手术":"手术","护理":"护理",:"")
	s dicttype=$case(type,"诊断":"1","检查":"2","检验":"3","药品":"4","手术":"5","护理":"6","频率":"7","体征":"8","检验标本":"9","用法":"10","单位":"11","科室":"12","检验医嘱":"13","输血品":"14","中药":"15","中医诊断":"16","中医证型":"17",:"")
	s type=$case(type,"检查":"检查检验","检验医嘱":"检查检验","检验":"检查检验","诊断":"诊断","药品":"药品","手术":"手术","护理":"护理","频率":"频率","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	
	q:((type="")||(str="")) "false"
	s code=$p(str,"[A]",1)
	s desc=$p(str,"[A]",2)
	q:(code="")||(desc="") "false"

	s id=##class(web.CDSS.IMP.ContrastDict).GetDictIDCodeDesc(dicttype,code,desc)
	q:id="" "false"
	//s id=","_id_","
	s errorflag=0
	TS
	s Hospital=""
	for
	{
		//Index DictNameStateIndex On (HospitalDR As Exact, ContrastType As Exact, DictName As Exact, State As Exact);
		s Hospital=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital))
		q:Hospital=""
		q:errorflag=1
		s State=""
		for
		{
			
			s State=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,type,desc,State))
			q:(State="")||(errorflag=1)
			q:errorflag=1
			s MappingID=0
			for
			{
				s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,type,desc,State,MappingID))
				q:MappingID=""
				q:errorflag=1
				
				//s re= ..DeleteDatas(MappingID,id,str)
				s re= ..DeleteData(MappingID)
				s:re["false" errorflag=1
				
			}
			
		}
			
	}
	if (errorflag=1)	//失败
	{
		tro
		s result="false"	
	}
	else
	{
		tc	
		s result="true"
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2021-1-12
/// Description：将某个知识库的数据的对照数据删除,原先的知识库数据的代码保持不变
/// Table:CT.WDT.CDSS.ContrastDict
/// Input：type 类型 ,newstr 修改后的代码[A]描述 ,id CDSS字典DR
/// Return：false，true
/// Other: w ##class(web.CDSS.IMP.ContrastDict).UpdateMappings("药品","17890[A]测试通用名","17890[A]测试通用名1")
/// Other: w ##class(web.CDSS.IMP.ContrastDict).UpdateMappings("检验医嘱","150[A]阴道分泌物常规1","150[A]阴道分泌物常规")
ClassMethod UpdateMappings(type, oldstr, newstr)
{
	s result=""
	//s dicttype=$case(type,"诊断":"1","检查":"2","检验":"3","药品":"4","手术":"5","护理":"6","频率":"7","体征":"8","检验标本":"9","用法":"10","单位":"11","科室":"12","检验医嘱":"13","输血品":"14","中药":"15","中医诊断":"16","中医证型":"17",:"")
	s ContrastType=$case(type,"检查":"检查检验","检验医嘱":"检查检验","检验":"检查检验","诊断":"诊断","药品":"药品","手术":"手术","护理":"护理","频率":"频率","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	q:((ContrastType="")||(oldstr="")||(newstr="")) "false"
	s oldcode=$p(oldstr,"[A]",1)
	s olddesc=$p(oldstr,"[A]",2)
	q:(oldcode="")||(olddesc="") "false"
	s code=$p(newstr,"[A]",1)
	s desc=$p(newstr,"[A]",2)
	q:(code="")||(desc="") "false"

	s errorflag=0
	TS
	s Hospital=""
	for
	{
		//Index DictNameStateIndex On (HospitalDR As Exact, ContrastType As Exact, DictName As Exact, State As Exact);
		s Hospital=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital))
		q:(Hospital="")||(errorflag=1)

		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,ContrastType,olddesc,State))
			q:(State="")||(errorflag=1)
			continue:(State="未关联")||(State="已删除")
			q:errorflag=1
			s MappingID=0
			for
			{
				s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,ContrastType,olddesc,State,MappingID))
				q:(MappingID="")||(errorflag=1)
			
				s obj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(MappingID)
				continue:obj.DictCode'=oldcode   //如果要修改的code不一致则跳过修改
				s bobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
				s bobj.DictCode= code		//知识库字典代码
				s bobj.DictName= desc		//知识库字典描述
				s bobj.ID = MappingID
				s bobj.ContrastType= obj.ContrastType		//对照类型
				s bobj.ConDictCode=obj.ConDictCode		//对接方字典代码
				s bobj.ConDictName=obj.ConDictName		//对接方字典描述
				s bobj.State=obj.State		//状态（未关联/已关联/已确认/已删除）
				s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s bobj.Remarks=obj.Remarks		//备注
				s bobj.DictDR=obj.DictDR
				s bobj.IntDictDR=obj.IntDictDR
				s re= ..SaveEntity(bobj)
				s:re["false" errorflag=1
			}
		}
		
	}
	if (errorflag=1)	//失败
	{
		tro
		s result="false"	
	}
	else
	{
		tc	
		s result="true"
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2021-2-27
/// Description：计算全院匹配率
/// Table:CT.WDT.CDSS.ContrastDict
/// Input：HospitalID
/// Return：rate
/// Other: w ##class(web.CDSS.IMP.ContrastDict).CountMapRate(2)
ClassMethod CountMapRate(HospitalID)
{
	s result=0
	q:HospitalID="" 0
	s HospTotalData=0
	s HospTotalMap=0
	s Type="药品,诊断,检查检验,手术,护理"
	for m=1:1:$l(Type,",")
	{
		s ContrastType=$p(Type,",",m)
		s Datastr= ..GetMatchData(HospitalID,ContrastType)
		s Totalcount=0
		s Mapcount=0
		if (Datastr'="")	//数据串不为空
		{
			s Totalcount=$p(Datastr,",",1)		//总数
			s Mapcount=$p(Datastr,",",2)		//已匹配数
			
			s HospTotalData=HospTotalData+Totalcount
			s HospTotalMap=HospTotalMap+Mapcount
		}
	}
	s:(HospTotalMap'=0) result=HospTotalMap/HospTotalData
	q result
}

/// Creator：阚延新
/// CreatDate: 2021-3-29
/// Description：导入1.0字典对照数据,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).ImportMappingDataTXT("D:/2022-03-28字典对照数据_1.txt")
ClassMethod ImportMappingDataTXT(path) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
   	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s exportfileName=time_"1.0对照数据转2.0错误.txt"
	s exportfile=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_exportfileName
	
    o exportfile:"WNS"
    u exportfile
    w "分类^所属医院^对接方项目代码^对接方项目名称^备注^知识库名称^原因" 	
	s savecount=0
	s unsavecount=0
	s unstatecount=0
	s exportnum=0
    s untypecount=0
    s indictcount=0
    s dictcount=0
    s incount=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
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
		s ContrastType1=$p(data,"^",1)	//对照类型
		s:ContrastType1="体征信息" untypecount=untypecount+1 
		continue:ContrastType1="体征信息"
		s Hospital=$p(data,"^",2)	//医院
		s IntDictDR=$p(data,"^",3)	//对接方项目DR
		s ConDictCode=$p(data,"^",4)	//对接方字典代码
		s ConDictName=$p(data,"^",5)	//对接方项目名称
		s Remarks=$p(data,"^",6)	//备注
		s State=$p(data,"^",12)		//是否关联
		s:State="否" unstatecount=unstatecount+1 
		continue:State="否"
		s DictDR=$p(data,"^",9)	//知识库DR
		s reason=""
		if (ConDictCode="")	//对接方字典代码为空
		{
			s reason="对接方字典代码为空"
		}
		
		if (ConDictName="")	//对接方字典描述为空
		{
			s reason="对接方字典描述为空"
		}
		if (DictDR="")	//CDSS字典描述为空
		{
			s reason="CDSS字典描述ID为空"
		}
		s HospitalDR=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_$zconvert(Hospital,"U"),""))
		if (HospitalDR="")	//医院错误
		{
			s reason="医院错误"
		}
		//Index DescIndex On DictClassDesc;
		s DictMapType=$o(^CT.WDT.CDSS.ConClassDictI("DescIndex"," "_$zconvert(ContrastType1,"U"),""))
		if (DictMapType="")	//类型错误
		{
			s reason="类型错误"
		}
		continue:((ConDictCode="")&&(ConDictName="")&&(DictDR="")&&(HospitalDR="")&&(DictMapType=""))
		if (reason'="")	//存在错误数据
		{
			s exportnum=exportnum+1
			w !,ContrastType1_"^"_Hospital_"^"_ConDictCode_"^"_ConDictName_"^"_Remarks_"^"_DictDR_"^"_reason
			continue
		}
		/*s DictCode=$p(data,"^",10)		//知识库代码
		s:DictCode="" dircount=dircount+1 
		continue:DictCode=""
		s DictName=$p(data,"^",11)		//知识库名称
		s:DictName="" dircount=dircount+1 
		continue:DictName=""*/
		if (ContrastType1="诊断字典")	//疾病字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DictDR)),18)	//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DictDR)),2)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DictDR)),3)		//知识库字典描述
		}
		if (ContrastType1="检查项目字典")	//检查字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.ExamDictD(DictDR)),25)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.ExamDictD(DictDR)),3)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.ExamDictD(DictDR)),4)		//知识库字典描述
		}
		if (ContrastType1="检验项目字典")	//检验字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(DictDR)),24)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(DictDR)),3)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(DictDR)),4)		//知识库字典描述
		}
		if (ContrastType1="药品字典")	//药品字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.DrugDictD(DictDR)),30)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.DrugDictD(DictDR)),3)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.DrugDictD(DictDR)),4)		//知识库字典描述
		}
		if (ContrastType1="手术操作字典")	//手术字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.OperationDictD(DictDR)),12)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.OperationDictD(DictDR)),3)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.OperationDictD(DictDR)),4)		//知识库字典描述
		}
		if (ContrastType1="护理医嘱字典")	//护理字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.NursingDictD(DictDR)),22)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.NursingDictD(DictDR)),3)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.NursingDictD(DictDR)),4)		//知识库字典描述
		}
		if (ContrastType1="频率字典")	//频率字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.FrequencyDictD(DictDR)),5)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.FrequencyDictD(DictDR)),2)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.FrequencyDictD(DictDR)),3)		//知识库字典描述
		}
		if (ContrastType1="检验标本")	//检验标本字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(DictDR)),6)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(DictDR)),2)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(DictDR)),3)		//知识库字典描述
		}
		if (ContrastType1="用法字典")	//用法字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.UsageDictD(DictDR)),5)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.UsageDictD(DictDR)),2)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.UsageDictD(DictDR)),3)		//知识库字典描述
		}
		if (ContrastType1="单位字典")	//单位字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.UnitDictD(DictDR)),4)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.UnitDictD(DictDR)),2)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.UnitDictD(DictDR)),3)		//知识库字典描述
		}
		if (ContrastType1="科室字典")	//科室字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DictDR)),7)		//知识库字典状态
			s DictCode= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DictDR)),2)		//知识库字典代码
			s DictName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DictDR)),3)		//知识库字典描述
		}
		if (ContrastType1="检验医嘱")	//检验医嘱
		{
			s DictState= $lg($g(^CT.WDT.CDSS.LabOrdersDictD(DictDR)),5)		//知识库字典状态
			s DictCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(DictDR)),2) //检验医嘱代码
		    s DictName=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(DictDR)),3) //检验医嘱名称
		}
		if (ContrastType1="输血品字典")	//输血品字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.BloodProductDictD(DictDR)),22)		//知识库字典状态
			s DictCode=$lg($g(^CT.WDT.CDSS.BloodProductDictD(DictDR)),3) //输血品字典代码
		    s DictName=$lg($g(^CT.WDT.CDSS.BloodProductDictD(DictDR)),4) //输血品字典名称
		}
		if (ContrastType1="中药字典")	//中药字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.TCMMedicineD(DictDR)),13)		//知识库字典状态
			s DictCode=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DictDR)),2) //中药字典代码
		    s DictName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DictDR)),3) //中药字典名称
		}
		if (ContrastType1="中医诊断字典")	//中医疾病字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DictDR)),7)		//知识库字典状态
			s DictCode=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DictDR)),2) //中医疾病字典代码
		    s DictName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DictDR)),3) //中医疾病字典名称
		}
		if (ContrastType1="中医证型字典")	//中医证候字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.TCMSymptomD(DictDR)),8)		//知识库字典状态
			s DictCode=$lg($g(^CT.WDT.CDSS.TCMSymptomD(DictDR)),2) //中医证型字典代码
		    s DictName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(DictDR)),3) //中医证型字典名称
		}
		if (DictState'="2")	
		{
			s reason="状态是"_DictState_",不是已审批数据"
			s dictcount=dictcount+1
			s exportnum=exportnum+1
			w !,ContrastType1_"^"_Hospital_"^"_ConDictCode_"^"_ConDictName_"^"_Remarks_"^"_DictDR_"^"_reason
			continue
		}
		if (DictCode="")||(DictName="")	
		{
			s reason="字典表数据不存在"
			s dictcount=dictcount+1
			s exportnum=exportnum+1
			w !,ContrastType1_"^"_Hospital_"^"_ConDictCode_"^"_ConDictName_"^"_Remarks_"^"_DictDR_"^"_reason
			continue
		}
		if ((ContrastType1="检查项目字典")||(ContrastType1="检验项目字典")||(ContrastType1="检验医嘱"))
		{s ContrastType="检查检验"}
		if (ContrastType1="护理医嘱字典")
		{s ContrastType="护理"}
		if (ContrastType1="手术操作字典")
		{s ContrastType="手术"}
		if (ContrastType1="药品字典")
		{s ContrastType="药品"}
		if (ContrastType1="诊断字典")
		{s ContrastType="诊断"}
		if (ContrastType1="输血品字典")
		{s ContrastType="输血品"}
		if (ContrastType1="中药字典")
		{s ContrastType="中药"}
		if (ContrastType1="频率字典")
		{s ContrastType="频率"}
		if (ContrastType1="用法字典")
		{s ContrastType="用法"}
		if (ContrastType1="科室字典")
		{s ContrastType="科室"}
		if (ContrastType1="单位字典")
		{s ContrastType="单位"}
		if (ContrastType1="检验标本")
		{s ContrastType="检验标本"}
		if (ContrastType1="中药字典")
		{s ContrastType="中药"}
		if (ContrastType1="中医诊断字典")
		{s ContrastType="中医诊断"}
		if (ContrastType1="中医证型字典")
		{s ContrastType="中医证型"}
		
		if (ContrastType="诊断")
		{
			s:Remarks="" Remarks=-100000000000000
			s RowID=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospCNIndex",HospitalDR,Remarks,ConDictCode,ConDictName,0))
		}
		if (ContrastType="手术")
		{
			s:Remarks="" Remarks=-100000000000000
			s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCNIndex",HospitalDR,ConDictCode,ConDictName,Remarks,0))
		}
		if (ContrastType="药品")
		{
			s RowID=$o(^CT.WDT.CDSS.ConDrugDictI("HospCNIndex",HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="检查检验")
		{
			if (ContrastType1="检查项目字典")
			{s ExamType="检查"}
			if (ContrastType1="检验项目字典")
			{s ExamType="检验项目"}
			if (ContrastType1="检验医嘱")
			{s ExamType="检验医嘱"}
			
			s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospCNIndex",HospitalDR,ConDictCode,ConDictName,ExamType,0))
		}
		if (ContrastType="护理")
		{
			s RowID=$o(^CT.WDT.CDSS.ConNurseDictI("HospCNIndex",HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="频率")
		{
			s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",7,HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="检验标本")
		{
			s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",9,HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="用法")
		{
			s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",10,HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="单位")
		{
			s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",11,HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="科室")
		{
			s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",12,HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="输血品")
		{
			s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",14,HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="中药")
		{
			s RowID=$o(^CT.WDT.CDSS.ConTCMDictI("HospCNIndex",15,HospitalDR,ConDictCode,ConDictName,0))
		}
		if (ContrastType="中医诊断")
		{
			s RowID=$o(^CT.WDT.CDSS.ConCMDiseDictI("HospCNIndex",HospitalDR,16,ConDictCode,ConDictName,0))
		}
		if (ContrastType="中医证型")
		{
			s RowID=$o(^CT.WDT.CDSS.ConCMDiseDictI("HospCNIndex",HospitalDR,17,ConDictCode,ConDictName,0))
		}
		if (RowID="")		//不存在
		{
			s indictcount=indictcount+1
			s exportnum=exportnum+1
			s reason="对接方字典表数据不存在"
			w !,ContrastType1_"^"_Hospital_"^"_ConDictCode_"^"_ConDictName_"^"_Remarks_"^"_DictDR_"^"_reason
			continue	
		}
		s flag=0
		s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",ContrastType,RowID,0))
		s bobj = ##class(CT.WDT.CDSS.ContrastDict).%OpenId(ConID)
		if ((","_bobj.DictName_",")[(","_DictName_","))&&(bobj.State'="未关联")&&(bobj.State'="已删除")
		{
			s reason="对照数据重复"
			s incount=incount+1	
			s exportnum=exportnum+1
			w !,ContrastType1_"^"_Hospital_"^"_ConDictCode_"^"_ConDictName_"^"_Remarks_"^"_DictDR_"^"_reason
			continue
		}
        s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
        s eobj.ID=ConID
        if (bobj.State="未关联")
        {
	        s flag=1
	        s eobj.DictCode= DictCode
	        s eobj.DictName= DictName
	        s eobj.DictDR= DictDR
	    }
	    else
	    {
		    s:(","_bobj.DictCode_",")[(","_DictCode_",") eobj.DictCode= bobj.DictCode
			s:(","_bobj.DictCode_",")'[(","_DictCode_",") eobj.DictCode= bobj.DictCode_","_DictCode
			s:(","_bobj.DictName_",")[(","_DictName_",") eobj.DictName= bobj.DictName
			s:(","_bobj.DictName_",")'[(","_DictName_",") eobj.DictName= bobj.DictName_","_DictName
			s:(","_bobj.DictDR_",")[(","_DictDR_",") eobj.DictDR= bobj.DictDR
			s:(","_bobj.DictDR_",")'[(","_DictDR_",") eobj.DictDR= bobj.DictDR_","_DictDR
		    ;s eobj.DictCode= bobj.DictCode_","_DictCode
	        ;s eobj.DictName= bobj.DictName_","_DictName
	        ;s eobj.DictDR= bobj.DictDR_","_DictDR
		}
		s eobj.ContrastType= bobj.ContrastType							//对照类型
		s eobj.IntDictDR=bobj.IntDictDR
		s eobj.ConDictCode= bobj.ConDictCode							//对接方字典代码
		s eobj.ConDictName= bobj.ConDictName							//对接方字典描述
		s eobj.State="已关联"											//状态（未关联/已关联/已确认/已删除）
		s:bobj.HospitalDR'="" eobj.HospitalDR = bobj.HospitalDR.%Id() 	//所属医院
		s eobj.Remarks=bobj.Remarks	                    				//备注
		s re=##class(web.CDSS.IMP.ContrastDict).SaveEntity(eobj)
		if (re["false")
		{
			if (re'["存在")
			{
				s unsavecount=unsavecount+1
			}
			else
			{
				s reason="对照数据重复"
				s incount=incount+1	
				s exportnum=exportnum+1
				w !,ContrastType1_"^"_Hospital_"^"_ConDictCode_"^"_ConDictName_"^"_Remarks_"^"_DictDR_"^"_reason
			}
		}
		else
		{
			s savecount=savecount+1
			if (flag=1)
			{
				d ..UpdateConDictState(RowID, "已关联", ContrastType)
			}
		}
	}		       
	c file
	c exportfile 
	     
	w "读取数据总共"_(num-1)_"条",!
	w "成功数据"_savecount,!
	w "失败数据"_unsavecount,!
	w "不是已对照的数据"_unstatecount,!
	w "对接字典表不存在:"_indictcount,!
	w "字典表不存在和状态问题:"_dictcount,!
	w "不是可接收类型"_untypecount,!
	w "导出数据:"_exportnum,!
	w "重复数据:"_incount,!
	
	q "{success:'true'}"
}

/// Creator：阚延新
/// CreatDate: 2021-3-30
/// Description：导入1.0对接方字典数据,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).ImportIndictDataTXT("D:\2022-03-28对接方字典数据.txt")
ClassMethod ImportIndictDataTXT(path) As %String
{
	s savecount=0
	s unsavecount=0
	s untypecount=0
	s unsavecount1=0
	s dircount=0
	s timecontinuecount=0
	s linksavecount=0
	s id=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
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
		
		s Code=$p(data,"	",1)			//代码
		s:Code="" dircount=dircount+1 
		continue:Code=""
		s Name=$p(data,"	",2)			//描述
		s:Name="" dircount=dircount+1
		continue:Name=""
		s ContrastType=$p(data,"	",3)	//对照类型
		s:ContrastType="" dircount=dircount+1
		continue:ContrastType=""
		s Hospital=$p(data,"	",4)		//医院
		s:Hospital="" dircount=dircount+1
		continue:Hospital=""
		s HospitalDR=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_Hospital,0))
		s:HospitalDR="" dircount=dircount+1
		continue:HospitalDR=""
		s remark=$p(data,"	",5)		//备注
		s StartDate=$p(data,$c(9),6)	//开始日期
		s EndDate=$p(data,$c(9),7)		//结束日期
		if (StartDate[":")		//带有时间
		{
			s StartDate=$p(StartDate," ",1)	
		}
		if (EndDate[":")		//带有时间
		{
			s EndDate=$p(EndDate," ",1)	
		}
		if (StartDate'="")
		{
			s:StartDate["/" StartDate=$Replace(StartDate,"/","-")
			s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
		}
		else
		{
			s StartDate=$ZDATETIME($HOROLOG,3)	
			s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
		}
		if (EndDate'="")
		{
			s:EndDate["/" EndDate=$Replace(EndDate,"/","-")
			s EndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过期
		{
			s timecontinuecount=timecontinuecount+1
			continue
		}
		if ((ContrastType'="药品字典")&(ContrastType'="手术操作字典")&(ContrastType'="护理医嘱字典")&(ContrastType'="输血品字典")&(ContrastType'="检查项目字典")&(ContrastType'="检验项目字典")&(ContrastType'="诊断字典")&(ContrastType'="检验医嘱")&(ContrastType'="频率字典")&(ContrastType'="检验标本")&(ContrastType'="单位字典")&(ContrastType'="用法字典")&(ContrastType'="科室字典")&(ContrastType'="中药字典")&(ContrastType'="中医诊断字典")&(ContrastType'="中医证型字典"))
		{
			s untypecount=untypecount+1	
		}	
		if (ContrastType="诊断字典")    //诊断
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
			s eobj.ID=""
			s eobj.DiseaseCode=Code
			s eobj.DiseaseName=Name			
			s eobj.Source="住院"			
			s eobj.ICDCode=remark
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)				
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConDiseaseDict).SaveEntity(eobj)
			if (re["false")
			{
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if ((ContrastType="检查项目字典")||(ContrastType="检验项目字典")||(ContrastType="检验医嘱"))
		{
			s:ContrastType="检查项目字典" ExamType="检查"		
			s:ContrastType="检验项目字典" ExamType="检验项目"
			s:ContrastType="检验医嘱" ExamType="检验医嘱"
			s eobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
			s eobj.ID=""
			s eobj.ExamCode=Code
			s eobj.ExamName=Name
			s eobj.ExamType=ExamType		
			s eobj.SpecimenCode=""
			s eobj.SpecimenName=""		
			s eobj.Source="住院"			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			
			s re=##class(web.CDSS.IMP.ConExamDict).SaveEntity(eobj)
			if (re["false")
			{
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="护理医嘱字典")
		{

			s eobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
			s eobj.ID=""
			s eobj.NursingCode=Code
			s eobj.NursingName=Name	
			s eobj.NursingType=""		
			s eobj.Source="住院"			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			
			s re=##class(web.CDSS.IMP.ConNurseDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	

		}
		if (ContrastType="手术操作字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOperDict).%New()
			s eobj.ID=""
			s eobj.OperationCode=Code
			s eobj.OperationName=Name			
			s eobj.Source="住院"
			s eobj.ICDCode=remark			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOperDict).SaveData(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="药品字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConDrugDict).%New()
			s eobj.ID=""
			s eobj.DrugCode=Code
			s eobj.DrugName=remark
		    s eobj.DrugTradeName=Name
		    s eobj.DrugAlias=""
			s eobj.Source="住院"
			s eobj.Manufacturers=""
			s eobj.DrugComposition=""
			s eobj.DosageForm=""
			s eobj.Specification=""			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConDrugDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="频率字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=7
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="检验标本")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=9
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="用法字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=10
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="单位字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=11
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="科室字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=12
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="输血品字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=14
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="中药字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConTCMDict).%New()
			s eobj.ID=""
			s eobj.TCMCode=Code
			s eobj.TCMName=remark
		    s eobj.TCMTradeName=Name
		    s eobj.TCMAlias=""
			s eobj.Source="住院"
			s eobj.Manufacturers=""
			s eobj.TCMComposition=""
			s eobj.DosageForm=""
			s eobj.Specification=""			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConTCMDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="中医诊断字典")    //中医诊断
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConCMDiseDict).%New()
			s eobj.ID=""
			s eobj.DiseaseCode=Code
			s eobj.DiseaseName=Name			
			s eobj.Source="住院"			
			s eobj.ICDCode=remark
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)				
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			s eobj.DiagnosisClass=16

			s re=##class(web.CDSS.IMP.ConCMDiseDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="中医证型字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConCMDiseDict).%New()
			s eobj.ID=""
			s eobj.DiseaseCode=Code
			s eobj.DiseaseName=Name			
			s eobj.Source="住院"			
			s eobj.ICDCode=remark
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)				
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			s eobj.DiagnosisClass=17

			s re=##class(web.CDSS.IMP.ConCMDiseDict).SaveEntity(eobj)
			if (re["false")
			{
				b ;
				s unsavecount=unsavecount+1	
				continue
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
	}
	w "读取数据总共"_(num-1)_"条",!
	w "保存字典:"_savecount,!
	w "保存字典失败:"_unsavecount,!
	w "自动对照:"_linksavecount,!
	w "不是可接收类型:"_untypecount,!
	w "过期数据"_timecontinuecount,!
	w "脏数据"_dircount,!

	q "{success:'true'}"
}

/// Other:w ##class(web.CDSS.IMP.ContrastDict).kglobal()
ClassMethod kglobal(flag As %String = "") As %String
{
	//清除2.0字典对照相关表global
	K ^CT.WDT.CDSS.ConDiseaseDictD
	K ^CT.WDT.CDSS.ConDiseaseDictI
	K ^CT.WDT.CDSS.ConDrugDictD
	K ^CT.WDT.CDSS.ConDrugDictI
	K ^CT.WDT.CDSS.ConExamDictD
	K ^CT.WDT.CDSS.ConExamDictI
	K ^CT.WDT.CDSS.ConNurseDictD
	K ^CT.WDT.CDSS.ConNurseDictI
	K ^CT.WDT.CDSS.ConOperDictD
	K ^CT.WDT.CDSS.ConOperDictI
	K ^CT.WDT.CDSS.ContrastDictD
	K ^CT.WDT.CDSS.ContrastDictI
	k ^CT.WDT.CDSS.ConOtherDictD
	k ^CT.WDT.CDSS.ConOtherDictI
	k ^CT.WDT.CDSS.ConDictConAreaD
	k ^CT.WDT.CDSS.ConDictConAreaI
	k ^CT.WDT.CDSS.ConTCMDictD
	k ^CT.WDT.CDSS.ConTCMDictI
	k ^CT.WDT.CDSS.ConCMDiseDictD
	k ^CT.WDT.CDSS.ConCMDiseDictI
	if (flag=1)  //清除1.0和2.0字典对照共用表global
	{
		k ^CT.WDT.CDSS.ConClassDictD
		k ^CT.WDT.CDSS.ConClassDictI
		k ^CT.WDT.CDSS.CustomerHospD
		k ^CT.WDT.CDSS.CustomerHospI
		k ^CT.WDT.CDSS.CustomerHospC
	} 	 
	q ""
}

/// Other:w ##class(web.CDSS.IMP.ContrastDict).BuildIndices()
ClassMethod BuildIndices() As %String
{
	d ##class(CT.WDT.CDSS.ConDiseaseDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConDrugDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConExamDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConNurseDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConOperDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ContrastDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConOtherDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConClassDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConDictConArea).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConTCMDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.ConCMDiseDict).%BuildIndices()
	q ""
}

/// Creator：钟荣枫 
/// CreatDate: 2020-6-16
/// Description：导入数据有问题，将对接方字典数据删除，同时删除对照数据
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).DeleteErrorDataTXT("D:/删除.txt")
ClassMethod DeleteErrorDataTXT(path)
{
	s delcount=0
	s continuecount=0
	s mapcount=0
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
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

		s DictCode=$p(data,"	",1)		//代码
		continue:DictCode=""
		s DictDesc=$p(data,"	",2)		//描述 药品商品名
		continue:DictDesc=""
		s DictTypeDesc=$p(data,"	",4)	//对接方字典分类
		s DictHospDesc="丰城市人民医院" //$p(data,"	",4)	//对接方字典医院
		s Remarks=$p(data,"	",3)	
		
		s DictType=$o(^CT.WDT.CDSS.ConClassDictI("DescIndex"," "_$ZCONVERT(DictTypeDesc,"U"),0))	
		s DictHosp=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_$ZCONVERT(DictHospDesc,"U"),0))
		if (DictHosp="")
		{
			s continuecount=continuecount+1	
			continue
		}
		if (DictType'="")
		{
			if (DictType=1)
			{
				s:Remarks="" Remarks=-100000000000000
				s RowID=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospCNIndex",DictHosp,Remarks,DictCode,DictDesc,0))
			}
			if (DictType=5)
			{
				s:Remarks="" Remarks=-100000000000000
				s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCNIndex",DictHosp,DictCode,DictDesc,Remarks,0))
			}
			if (DictType=4)
			{
				s RowID=$o(^CT.WDT.CDSS.ConDrugDictI("HospCNIndex",DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=2)
			{
				s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospCNIndex",DictHosp,DictCode,DictDesc,"检查",0))
			}
			if (DictType=3)
			{
				s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospCNIndex",DictHosp,DictCode,DictDesc,"检验项目",0))
			}
			if (DictType=13)
			{
				s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospCNIndex",DictHosp,DictCode,DictDesc,"检验医嘱",0))
			}
			if (DictType=6)
			{
				s RowID=$o(^CT.WDT.CDSS.ConNurseDictI("HospCNIndex",DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=7)
			{
				s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",7,DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=9)
			{
				s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",9,DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=10)
			{
				s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",10,DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=11)
			{
				s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",11,DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=12)
			{
				s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",12,DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=14)
			{
				s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",14,DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=15)
			{
				s RowID=$o(^CT.WDT.CDSS.ConTCMDictI("HospCNIndex",DictHosp,DictCode,DictDesc,0))
			}
			if (DictType=16)
			{
				s RowID=$o(^CT.WDT.CDSS.ConCMDiseDictD("HospCNIndex",DictHosp,16,DictCode,DictDesc,0))
			}
			if (DictType=17)
			{
				s RowID=$o(^CT.WDT.CDSS.ConCMDiseDictD("HospCNIndex",DictHosp,17,DictCode,DictDesc,0))
			}
			if (RowID="")	//不存在
			{
				s continuecount=continuecount+1
			}
			else
			{
				s ContrastType=$case(DictTypeDesc,"检查项目字典":"检查检验","检验医嘱":"检查检验","检验项目字典":"检查检验","诊断字典":"诊断","药品字典":"药品","手术操作字典":"手术","护理医嘱字典":"护理","频率字典":"频率","检验标本":"检验标本","用法字典":"用法","单位字典":"单位","科室字典":"科室","输血品字典":"输血品","中药字典":"中药","中医诊断字典":"中医诊断","中医证型字典":"中医证型",:"")	
				s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex",DictType,RowID,""))
				if (flag'="")
				{
					s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",ContrastType,RowID,""))
					q:MappingID="" 
					s mapcount=mapcount+1
					d ##class(web.CDSS.IMP.ContrastDict).DeleteData(MappingID)
					s delcount=delcount+1
					d ..DeleteIntData(DictType,RowID)
				}
				else
				{
					s delcount=delcount+1
					d ..DeleteIntData(DictType,RowID)
				}
			}		
		
		}
		else
		{
			s type=""
			for
			{
				s type=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,type))
				q:type=""
				s MappingID=""
				for
				{
					s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,type,DictCode,DictDesc,MappingID))
					q:MappingID=""
					s contrasttype=$lg($g(^CT.WDT.CDSS.ContrastDictD(MappingID)),4)
					s RowID=$lg($g(^CT.WDT.CDSS.ContrastDictD(MappingID)),11)
					if (contrasttype="诊断")
					{
						s icd=$lg($g(^CT.WDT.CDSS.ConDiseaseDictD(RowID)),5)
						continue:(icd'=Remarks)
					}
					if (contrasttype="手术")
					{
						s icd=$lg($g(^CT.WDT.CDSS.ConOperDictD(RowID)),12)
						continue:(icd'=Remarks)
					}
					s DictType=$case(type,"诊断":"1","检查检验":"2","药品":"4","手术":"5","护理":"6","频率":"7","体征":"8","检验标本":"9","用法":"10","单位":"11","科室":"12","输血品":"14","中药":"15","中医诊断":"16","中医证型":"17",:"")
					s mapcount=mapcount+1
					d ##class(web.CDSS.IMP.ContrastDict).DeleteData(MappingID)
					s delcount=delcount+1
					d ..DeleteIntData(DictType,RowID)
				}
					
				
			}
			
		}		
	}
	w "读取数据总共"_(num-1)_"条",!
	w "删除字典："_delcount,!
	w "删除对照："_mapcount,!
	w "continuecount："_continuecount,!
	q "{success:'true'}"
}

/// Creator：阚延新
/// CreatDate: 2021-5-25
/// Description：导入对接方字典数据,自动匹配,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).ImportDataTXT("D:\检查.txt")
ClassMethod ImportDataTXT(path) As %String
{
	s savecount=0
	s unsavecount=0
	s untypecount=0
	s unsavecount1=0
	s dircount=0
	s timecontinuecount=0
	s linksavecount=0
	s incount=0
	s id=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
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
		
		s Code=$p(data,"	",1)			//代码
		s Name=$p(data,"	",2)			//描述
		s Data1=$p(data,"	",3)	        //icd或者通用名
		s ContrastType="检验医嘱" 			//对照类型
		s Hospital="丰城市人民医院" 			//医院
		s HospitalDR=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_Hospital,0))
		continue:(HospitalDR="")
		s StartDate="" //$p(data,$c(9),4)	//开始日期
		s EndDate="" //$p(data,$c(9),5)	//结束日期
		s Data2=$p(data,"	",6)	        //剂型
		s Data3=$p(data,"	",7)	        //规格
		s Data4="" //$p(data,"	",8)	        //成分
		s Data5=$p(data,"	",8)	        //厂家
		if (StartDate[":")		//带有时间
		{
			s StartDate=$p(StartDate," ",1)	
		}
		if (EndDate[":")		//带有时间
		{
			s EndDate=$p(EndDate," ",1)	
		}
		if (StartDate'="")
		{
			s:StartDate["/" StartDate=$Replace(StartDate,"/","-")
			s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
		}
		else
		{
			s StartDate=$ZDATETIME($HOROLOG,3)	
			s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
		}
		if (EndDate'="")
		{
			s:EndDate["/" EndDate=$Replace(EndDate,"/","-")
			s EndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过期
		{
			s timecontinuecount=timecontinuecount+1
			continue
		}
		;w !,num
		if ((ContrastType'="门诊诊断字典")&(ContrastType'="药品字典")&(ContrastType'="手术操作字典")&(ContrastType'="护理医嘱字典")&(ContrastType'="输血品字典")&(ContrastType'="检查项目字典")&(ContrastType'="检验项目字典")&(ContrastType'="诊断字典")&(ContrastType'="检验医嘱")&(ContrastType'="中药字典")&(ContrastType'="中医诊断字典")&(ContrastType'="中医证型字典")&(ContrastType'="用法字典")&(ContrastType'="频率字典")&(ContrastType'="单位字典")&(ContrastType'="科室字典")&(ContrastType'="检验标本"))
		{s untypecount=untypecount+1	}	
		if (ContrastType="门诊诊断字典")    //门诊诊断
		{
			s ID=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospCNIndex",HospitalDR,Data1,Code,Name,0))
			if (ID'="")
			{
				s obj=##class(CT.WDT.CDSS.ConDiseaseDict).%OpenId(ID)
				s eobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
				s eobj.ID=ID
				s eobj.DiseaseCode=obj.DiseaseCode
				s eobj.DiseaseName=obj.DiseaseName
				s eobj.Source="门诊,住院"			
				s eobj.ICDCode=obj.ICDCode
				s eobj.HospitalDR= obj.HospitalDR.%Id()		
				s eobj.Remarks=obj.Remarks	
				s eobj.State=obj.State
				s eobj.CreateDate=obj.CreateDate				
				s eobj.CreateUser=obj.CreateUser					
				s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
				s eobj.UpdateUser="dhcc"
				s eobj.StartDate=obj.StartDate
				s eobj.EndDate=obj.EndDate
			}
			else
			{
				s eobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
				s eobj.ID=""
				s eobj.DiseaseCode=Code
				s eobj.DiseaseName=Name			
				s eobj.Source="门诊"			
				s eobj.ICDCode=Data1
				s eobj.HospitalDR= HospitalDR				
				s eobj.Remarks=""	
				s eobj.State="未关联"	
				s eobj.CreateDate=$ZDATETIME($HOROLOG,3)				
				s eobj.CreateUser="dhcc"				
				s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
				s eobj.UpdateUser="dhcc"
				s eobj.StartDate=StartDate
				s eobj.EndDate=EndDate
			}
			s re=##class(web.CDSS.IMP.ConDiseaseDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="诊断字典")    //诊断
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConDiseaseDict).%New()
			s eobj.ID=""
			s eobj.DiseaseCode=Code
			s eobj.DiseaseName=Name			
			s eobj.Source="住院"			
			s eobj.ICDCode=Data1
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)				
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			//s eobj.EndDate=""
			s re=##class(web.CDSS.IMP.ConDiseaseDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				   	//s eobj.EndDate="2022/08/15"
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		/*if ((ContrastType="检查项目字典")||(ContrastType="检验项目字典")||(ContrastType="检验医嘱"))
		{
			s:ContrastType="检查项目字典" ExamType="检查"		
			s:ContrastType="检验项目字典" ExamType="检验项目"
			s:ContrastType="检验医嘱" ExamType="检验医嘱"
			s eobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
			s eobj.ID=""
			s eobj.ExamCode=Code
			s eobj.ExamName=Name
			s eobj.ExamType=ExamType		
			s eobj.SpecimenCode=""
			s eobj.SpecimenName=""		
			s eobj.Source="住院"			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			
			s re=##class(web.CDSS.IMP.ConExamDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}*/
		if (ContrastType="检查项目字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
			s eobj.ID=""
			s eobj.ExamCode=Code
			s eobj.ExamName=Name
			s eobj.ExamType="检查"		
			s eobj.SpecimenCode=""
			s eobj.SpecimenName=""		
			s eobj.Source="住院"			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			s eobj.ConExamType=Data2
			
			s re=##class(web.CDSS.IMP.ConExamDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="检验项目字典")
		{
			
			s eobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
			s eobj.ID=""
			s eobj.ExamCode=Code
			s eobj.ExamName=Name
			s eobj.ExamType="检验项目"		
			s eobj.SpecimenCode=""
			s eobj.SpecimenName=""		
			s eobj.Source="住院"			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			s eobj.ConExamType=Data2
			s re=##class(web.CDSS.IMP.ConExamDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="检验医嘱")
		{
			
			s eobj = ##class(web.CDSSEntity.IMP.ConExamDict).%New()
			s eobj.ID=""
			s eobj.ExamCode=Code
			s eobj.ExamName=Name
			s eobj.ExamType="检验医嘱"		
			s eobj.SpecimenCode=""
			s eobj.SpecimenName=""		
			s eobj.Source="住院"			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			s eobj.ConExamType=Data2
			s re=##class(web.CDSS.IMP.ConExamDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="护理医嘱字典")
		{

			s eobj = ##class(web.CDSSEntity.IMP.ConNurseDict).%New()
			s eobj.ID=""
			s eobj.NursingCode=Code
			s eobj.NursingName=Name	
			s eobj.NursingType=""		
			s eobj.Source="住院"			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			
			s re=##class(web.CDSS.IMP.ConNurseDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	

		}
		if (ContrastType="手术操作字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOperDict).%New()
			s eobj.ID=""
			s eobj.OperationCode=Code
			s eobj.OperationName=Name			
			s eobj.Source="住院"
			s eobj.ICDCode=Data1			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			
			s re=##class(web.CDSS.IMP.ConOperDict).SaveData(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="药品字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConDrugDict).%New()
			s eobj.ID=""
			s eobj.DrugCode=Code
			s eobj.DrugName=Data1
		    s eobj.DrugTradeName=Name
		    s eobj.DrugAlias=""
			s eobj.Source="住院"
			s eobj.Manufacturers=Data5
			s eobj.DrugComposition=Data4
			s eobj.DosageForm=Data2
			s eobj.Specification=Data3			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConDrugDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="输血品字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=14
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="中药字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConTCMDict).%New()
			s eobj.ID=""
			s eobj.TCMCode=Code
			s eobj.TCMName=Data1
		    s eobj.TCMTradeName=Name
		    s eobj.TCMAlias=""
			s eobj.Source="住院"
			s eobj.Manufacturers=Data5
			s eobj.TCMComposition=Data4
			s eobj.DosageForm=Data2
			s eobj.Specification=Data3			
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConTCMDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="中医诊断字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConCMDiseDict).%New()
			s eobj.ID=""
			s eobj.DiseaseCode=Code
			s eobj.DiseaseName=Name			
			s eobj.Source="住院"			
			s eobj.ICDCode=Data1
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)				
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			s eobj.DiagnosisClass=16
			
			s re=##class(web.CDSS.IMP.ConCMDiseDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="中医证型字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConCMDiseDict).%New()
			s eobj.ID=""
			s eobj.DiseaseCode=Code
			s eobj.DiseaseName=Name			
			s eobj.Source="住院"			
			s eobj.ICDCode=Data1
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)				
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)		
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate
			s eobj.DiagnosisClass=17
			
			s re=##class(web.CDSS.IMP.ConCMDiseDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}	
		}
		if (ContrastType="频率字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=7
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="检验标本")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=9
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="用法字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=10
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="单位字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=11
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
		if (ContrastType="科室字典")
		{
			s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s eobj.RowID=""
			s eobj.ProDictCode=Code
			s eobj.ProDictName=Name
		    s eobj.ProDictType=12
			s eobj.Source="住院"		
			s eobj.HospitalDR= HospitalDR				
			s eobj.Remarks=""	
			s eobj.State="未关联"	
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s eobj.CreateUser="dhcc"				
			s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)			
			s eobj.UpdateUser="dhcc"
			s eobj.StartDate=StartDate
			s eobj.EndDate=EndDate

			s re=##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
			if (re["false")
			{
				if (re'["存在")
				{
					s unsavecount=unsavecount+1	
				}
				else
				{
				   	s incount=incount+1	
				}
			}
			else
			{
				s IntDictDR=$p(re,"'",6)
				s savecount=savecount+1	
				s linksavecount=linksavecount+IntDictDR
			}		
		}
	}
	w "读取数据总共"_(num-1)_"条",!
	w "保存字典:"_savecount,!
	w "保存字典失败:"_unsavecount,!
	w "重复数据:"_incount,!
	w "自动对照:"_linksavecount,!
	w "不是可接收类型:"_untypecount,!
	w "过期数据"_timecontinuecount,!
	w "脏数据"_dircount,!

	q "{success:'true'}"
}

/// Creator:阚延新
/// CreatDate: 2021-11-11
/// Description：导出所有字典已确认数据
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Other:w ##class(web.CDSS.IMP.ContrastDict).ExportConfirm()
ClassMethod ExportConfirm()
{
	s a1=##class(web.CDSS.IMP.ConDiseaseDict).ExportMapping("","","","","已确认","","","","")
	s a2=##class(web.CDSS.IMP.ConOperDict).ExportMapping("","","","已确认","","","","","")
	s a3=##class(web.CDSS.IMP.ConNurseDict).ExportMapping("","","","","已确认","","","")
	s a4=##class(web.CDSS.IMP.ConExamDict).ExportMapping("","","","","已确认","","","","")
	s a5=##class(web.CDSS.IMP.ConDrugDict).ExportMapping("","","","","已确认","","","","")
	s a6=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","","","14","已确认","","","")
	s a7=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","","","7","已确认","","","")
	s a8=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","","","9","已确认","","","")
	s a9=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","","","10","已确认","","","")
	s a10=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","","","11","已确认","","","")
	s a11=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","","","12","已确认","","","")
	s a12=##class(web.CDSS.IMP.ConTCMDict).ExportMapping("","","","","已确认","","","","")
	s a13=##class(web.CDSS.IMP.ConCMDiseDict).ExportMapping("","","","","已确认","","","","",16)
	s a14=##class(web.CDSS.IMP.ConCMDiseDict).ExportMapping("","","","","已确认","","","","",17)
	q a1_","_a2_","_a3_","_a4_","_a5_","_a6_","_a7_","_a8_","_a9_","_a10_","_a11_","_a12_","_a13_","_a14
}

/// Creator：阚延新
/// CreatDate: 2022-1-19
/// Description：导入对照关联,有的对接方字典数据可能不存在
/// Table:
/// Input： path
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).ImportMappingsTXT("D:\.txt")
ClassMethod ImportMappingsTXT(path) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
   	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s exportfileName=time_"导出错误数据2.0.txt"
	s exportfile=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_exportfileName
	
    o exportfile:"WNS"
    u exportfile
    w "分类^所属医院^对接方项目代码^对接方项目名称^备注^知识库名称^原因"   
   
   
    s exportnum=0
   
    s errorcount=0
	s savecount=0
	s nosavecount=0
	s incount=0
	s dictcount=0
	s indictcount=0
	s continuecount=0
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
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
		continue:data=""
		s IntDictCode=$p(data,"	",1)	//对接方字典代码
		
		s DictHospDesc="丰城市人民医院" //$p(data,"	",6)	//对接方字典医院
		s IntDictDesc=$p(data,"	",2)	//对接方字典描述
		s Remarks=$p(data,"	",3)	//icd
		//s DictCode=$p(data,"	",4)	//CDSS字典描述
		s DictDesc=$p(data,"	",4)	//CDSS字典描述
		
		s DictMapTypeDesc="检验医嘱" //$p(data,"	",5)	//对接方字典分类
		
		if ((DictMapTypeDesc="检查项目字典")||(DictMapTypeDesc="检验项目字典")||(DictMapTypeDesc="检验医嘱"))
		{s ContrastType="检查检验"}
		if (DictMapTypeDesc="护理医嘱字典")
		{s ContrastType="护理"}
		if (DictMapTypeDesc="手术操作字典")
		{s ContrastType="手术"}
		if (DictMapTypeDesc="药品字典")
		{s ContrastType="药品"}
		if (DictMapTypeDesc="诊断字典")
		{s ContrastType="诊断"}
		if (DictMapTypeDesc="输血品字典")
		{s ContrastType="输血品"}
		if (DictMapTypeDesc="中药字典")
		{s ContrastType="中药"}
		if (DictMapTypeDesc="中医诊断字典")
		{s ContrastType="中医诊断"}
		if (DictMapTypeDesc="中医证型字典")
		{s ContrastType="中医证型"}
		s reason=""
		if (IntDictCode="")	//对接方字典代码为空
		{
			s reason="对接方字典代码为空"
		}
		
		if (IntDictDesc="")	//对接方字典描述为空
		{
			s reason="对接方字典描述为空"
		}
		if (DictDesc="")	//CDSS字典描述为空
		{
			s reason="CDSS字典描述为空"
		}
		s DictHosp=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_$zconvert(DictHospDesc,"U"),""))
		if (DictHosp="")	//医院错误
		{
			s reason="医院错误"
		}
		s DictMapType=$o(^CT.WDT.CDSS.ConClassDictI("DescIndex"," "_$zconvert(DictMapTypeDesc,"U"),""))
		if (DictMapType="")	//类型错误
		{
			s reason="类型错误"
		}
		continue:((IntDictCode="")&&(IntDictDesc="")&&(DictDesc="")&&(DictHosp="")&&(DictMapType=""))
		if (reason'="")	//存在错误数据
		{
			s errorcount=errorcount+1
			s exportnum=exportnum+1
			w !,DictMapTypeDesc_"^"_DictHospDesc_"^"_IntDictCode_"^"_IntDictDesc_"^"_Remarks_"^"_DictDesc_"^"_reason
			continue
		}
		s DictiClassMapping=$lg($g(^CT.WDT.CDSS.ConClassDictD(DictMapType)),5)	//对照CDSS字典名
		s DictStr=##Class(web.CDSS.IMP.ContrastDict).GetDictIDCodeDesc(DictiClassMapping,"",DictDesc,1)
		s DictID=""
		s DictCode=""
		if (DictStr'="")
		{
			s DictID=$p(DictStr,"^",1)
			s DictCode=$p(DictStr,"^",2)
		}
		
		if (DictID="")	//cdss字典存在错误数据
		{
			s reason="字典表数据不存在"
			s dictcount=dictcount+1
			s exportnum=exportnum+1
			w !,DictMapTypeDesc_"^"_DictHospDesc_"^"_IntDictCode_"^"_IntDictDesc_"^"_Remarks_"^"_DictDesc_"^"_reason
			continue
		}
		if (DictMapTypeDesc="诊断字典")	//疾病字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DictID)),18)	//知识库字典状态
		}
		if (DictMapTypeDesc="检查项目字典")	//检查字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.ExamDictD(DictID)),25)		//知识库字典状态
		}
		if (DictMapTypeDesc="检验项目字典")	//检验字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(DictID)),24)		//知识库字典状态
		}
		if (DictMapTypeDesc="药品字典")	//药品字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.DrugDictD(DictID)),30)		//知识库字典状态
		}
		if (DictMapTypeDesc="手术操作字典")	//手术字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.OperationDictD(DictID)),12)		//知识库字典状态
		}
		if (DictMapTypeDesc="护理医嘱字典")	//护理字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.NursingDictD(DictID)),22)		//知识库字典状态
		}
		if (DictMapTypeDesc="频率字典")	//频率字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.FrequencyDictD(DictID)),5)		//知识库字典状态
		}
		if (DictMapTypeDesc="检验标本")	//检验标本字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(DictID)),6)		//知识库字典状态
		}
		if (DictMapTypeDesc="用法字典")	//用法字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.UsageDictD(DictID)),5)		//知识库字典状态
		}
		if (DictMapTypeDesc="单位字典")	//单位字典表
		{
			s DictState= $lg($g(^CT.WDT.CDSS.UnitDictD(DictID)),4)		//知识库字典状态
		}
		if (DictMapTypeDesc="科室字典")	//科室字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DictID)),7)		//知识库字典状态
		}
		if (DictMapTypeDesc="检验医嘱")	//检验医嘱
		{
			s DictState= $lg($g(^CT.WDT.CDSS.LabOrdersDictD(DictID)),5)		//知识库字典状态
		}
		if (DictMapTypeDesc="输血品字典")	//输血品字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.BloodProductDictD(DictID)),22)		//知识库字典状态
		}
		if (DictMapTypeDesc="中药字典")	//中药字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.TCMMedicineD(DictID)),13)		//知识库字典状态
		}
		if (DictMapTypeDesc="中医诊断字典")	//中医疾病字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DictID)),7)		//知识库字典状态
		}
		if (DictMapTypeDesc="中医证型字典")	//中医证候字典
		{
			s DictState= $lg($g(^CT.WDT.CDSS.TCMSymptomD(DictID)),8)		//知识库字典状态
		}
		if (DictState'="2")	
		{
			s reason="状态是"_DictState_",不是已审批数据"
			s dictcount=dictcount+1
			s exportnum=exportnum+1
			w !,DictMapTypeDesc_"^"_DictHospDesc_"^"_IntDictCode_"^"_IntDictDesc_"^"_Remarks_"^"_DictDesc_"^"_reason
			continue
		}
		
		if (ContrastType="诊断")
		{
			s:Remarks="" Remarks=-100000000000000
			s RowID=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospCNIndex",DictHosp,Remarks,IntDictCode,IntDictDesc,0))
		}
		if (ContrastType="手术")
		{
			s:Remarks="" Remarks=-100000000000000
			s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCNIndex",DictHosp,IntDictCode,IntDictDesc,Remarks,0))
		}
		if (ContrastType="药品")
		{
			s RowID=$o(^CT.WDT.CDSS.ConDrugDictI("HospCNIndex",DictHosp,IntDictCode,IntDictDesc,0))
		}
		if (ContrastType="检查检验")
		{
			if (DictMapTypeDesc="检查项目字典")
			{s ExamType="检查"}
			if (DictMapTypeDesc="检验项目字典")
			{s ExamType="检验项目"}
			if (DictMapTypeDesc="检验医嘱")
			{s ExamType="检验医嘱"}
			
			s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospCNIndex",DictHosp,IntDictCode,IntDictDesc,ExamType,0))
		}
		if (ContrastType="护理")
		{
			s RowID=$o(^CT.WDT.CDSS.ConNurseDictI("HospCNIndex",DictHosp,IntDictCode,IntDictDesc,0))
		}
		if (ContrastType="输血品")
		{
			s RowID=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",14,DictHosp,IntDictCode,IntDictDesc,0))
		}
		if (ContrastType="中药")
		{
			s RowID=$o(^CT.WDT.CDSS.ConTCMDictI("HospCNIndex",DictHosp,IntDictCode,IntDictDesc,0))
		}
		if (ContrastType="中医诊断")
		{
			s RowID=$o(^CT.WDT.CDSS.ConCMDiseDictI("HospCNIndex",DictHosp,16,Remarks,IntDictCode,IntDictDesc,0))
		}
		if (ContrastType="中医证型")
		{
			s RowID=$o(^CT.WDT.CDSS.ConCMDiseDictI("HospCNIndex",DictHosp,17,Remarks,IntDictCode,IntDictDesc,0))
		}		
		if (RowID="")		//不存在
		{
		
			s indictcount=indictcount+1
			s exportnum=exportnum+1
			s reason="对接方字典表数据不存在"
			w !,DictMapTypeDesc_"^"_DictHospDesc_"^"_IntDictCode_"^"_IntDictDesc_"^"_Remarks_"^"_DictDesc_"^"_reason
			continue
			
		}
		if ((DictID'="")&&(RowID'=""))
		{
			/*s flag=0
			s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",ContrastType,RowID,0))
			s bobj = ##class(CT.WDT.CDSS.ContrastDict).%OpenId(ConID)
			if ((","_bobj.DictName_",")[(","_DictDesc_","))&&(bobj.State'="已删除") //&&(bobj.State'="未关联")
			{
				s incount=incount+1	
				continue
			}
	        s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	        s eobj.ID=ConID
	        if (bobj.State="未关联")
	        {
		        s flag=1
		        s eobj.DictCode= DictCode
		        s eobj.DictName= DictDesc
		        s eobj.DictDR= DictID
		    }
		    else
		    {
				s eobj.DictCode= bobj.DictCode_","_DictCode
				s eobj.DictName= bobj.DictName_","_DictDesc
				s eobj.DictDR= bobj.DictDR_","_DictID
			}
			s eobj.ContrastType= bobj.ContrastType							//对照类型
			s eobj.IntDictDR=bobj.IntDictDR
			s eobj.ConDictCode= bobj.ConDictCode							//对接方字典代码
			s eobj.ConDictName= bobj.ConDictName							//对接方字典描述
			s eobj.State="已关联"											//状态（未关联/已关联/已确认/已删除）
			s:bobj.HospitalDR'="" eobj.HospitalDR = bobj.HospitalDR.%Id() 	//所属医院
			s eobj.Remarks=bobj.Remarks	                    				//备注
			
			*/
			//b ;0	NameIndex IntDictDesc
			//s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",ContrastType,RowID,0))
			s ConID=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex",ContrastType,IntDictDesc,RowID,0))
			if (ConID'="") 
			{
				s incount=incount+1	
				continue
			}
			s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
			s eobj.ID = ""
	
			s eobj.ContrastType= ContrastType		//对照类型
			s eobj.ConDictCode= IntDictCode							//对接方字典代码
			s eobj.ConDictName= IntDictDesc							//对接方字典描述
			s eobj.HospitalDR=DictHosp
			s eobj.Remarks=""		//备注	
			s eobj.DictCode= DictCode		//知识库字典代码
			s eobj.DictName= DictDesc		//知识库字典描述
			s eobj.State="已关联"		//状态（未关联/已关联/已确认/已删除）
			s eobj.DictDR=DictID       //知识库id
			s eobj.IntDictDR=RowID 		//对接方药品id
			
			
			s result=##class(web.CDSS.IMP.ContrastDict).SaveEntity(eobj)
			if ((result'["false"))
			{
				s savecount=savecount+1
				//同步修改对接方字典状态
				d ..UpdateConDictState(RowID, "已关联", ContrastType)
				
			}
			else
			{
				if (result'["存在")
				{
					s nosavecount=nosavecount+1
				}
				else
				{
					s incount=incount+1	
				}
			}
		}
	
		
	}
	c file
	c exportfile
	 
	w "读取数据总共"_(num-1)_"条",!
	w "保存成功："_savecount,!
	w "保存失败："_nosavecount,!
	w "已存在："_incount,!
	
	w "字典表不存在:"_dictcount,!
	w "对接字典表不存在:"_indictcount,!
	w "导出数据:"_exportnum,!
	w "错误数据:"_errorcount,!
	
	
	q "{success:'true'}"
}

/// Creator:阚延新
/// CreatDate: 2021-11-11
/// Description：导出所有字典数据
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Other:w ##class(web.CDSS.IMP.ContrastDict).ExportAll()
ClassMethod ExportAll(hosp)
{
	s a1=##class(web.CDSS.IMP.ConDiseaseDict).ExportMapping("","","",hosp,"","","","","")
	s a2=##class(web.CDSS.IMP.ConOperDict).ExportMapping("","","","","",hosp,"","","")
	s a3=##class(web.CDSS.IMP.ConNurseDict).ExportMapping("","",hosp,"","","","","")
	s a4=##class(web.CDSS.IMP.ConExamDict).ExportMapping("","",hosp,"","","","","","")
	s a5=##class(web.CDSS.IMP.ConDrugDict).ExportMapping("","","",hosp,"","","","","")
	s a6=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","",hosp,"7","","","","")
	s a7=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","",hosp,"9","","","","")
	s a8=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","",hosp,"10","","","","")
	s a9=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","",hosp,"11","","","","")
	s a10=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","",hosp,"12","","","","")
	s a11=##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","",hosp,"14","","","","")
	s a12=##class(web.CDSS.IMP.ConTCMDict).ExportMapping("","","",hosp,"","","","","")
	s a13=##class(web.CDSS.IMP.ConCMDiseDict).ExportMapping("","","",hosp,"","","","","",16)
	s a14=##class(web.CDSS.IMP.ConCMDiseDict).ExportMapping("","","",hosp,"","","","","",17)
	q a1_","_a2_","_a3_","_a4_","_a5_","_a6_","_a7_","_a8_","_a9_","_a10_","_a11_","_a12_","_a13_","_a14
}

/// Creator：阚延新
/// CreatDate: 2022-01-20
/// Description：导出对照表数据
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).ExportMapping("","","","","","已关联","46","","","")
ClassMethod ExportMapping(dictcode As %String, dictname As %String, type As %String, condictcode As %String, condictname As %String, state As %String, hosp As %String, remarks As %String, dictdr As %String, intdictdr As %String)
{
		
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"字典对照2.0结果.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"字典对照2.0结果.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\IMP\DataExport\"
		s file=Path_"scripts\bdp\CDSS\IMP\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts\bdp\CDSS\IMP\DataExport\"
		s file=Path_"scripts\bdp\CDSS\IMP\DataExport\"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	
	o file:"NWS"
	u file
	
	w "知识库字典代码	知识库字典描述	类型	对接方字典代码	对接方字典描述	状态	医院	备注	CDSS字典DR	对接方字典DR	ICD或通用名"

	
	s:dictcode'="" dictcode=$ZCONVERT(dictcode,"U") //转换成大写
	s:dictname'="" dictname=$ZCONVERT(dictname,"U") //转换成大写
	s:condictcode'="" condictcode=$ZCONVERT(condictcode,"U") //转换成大写
	s:condictname'="" condictname=$ZCONVERT(condictname,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ContrastDictD(ID))
		q:ID=""
		s DictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),2)
		continue:((dictcode'="")&&(dictcode'=DictCode))
		s DictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),3)
		continue:((dictname'="")&&(dictname'=DictName))
		s ContrastType= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),4) 
		s ConDictCode= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),5)
		continue:((condictcode'="")&&(condictcode'=ConDictCode))
		s ConDictName= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),6)
		continue:((condictname'="")&&(condictname'=ConDictName))
		s State= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),7)
		continue:((state'="")&&(state'=State))
		s HospitalDesc=""
		s HospitalDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),8)	//所属医院
		continue:((hosp'="")&&(HospitalDR'=hosp))
		s:HospitalDR'="" HospitalDesc=$LISTGET($G(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),9)
		continue:((remarks'="")&&(remarks'=Remarks))
	   	s DictDR= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),10)
	   	continue:((dictdr'="")&&(dictdr'=DictDR))
		s IntDictDR= $lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),11)
		continue:((intdictdr'="")&&(intdictdr'=IntDictDR))
		s:ContrastType="检查检验" ContrastType=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),4)
		s:ContrastType="诊断" Data=$lg($g(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),5)
		s:ContrastType="手术" Data=$lg($g(^CT.WDT.CDSS.ConOperDictD(IntDictDR)),12)
		s:ContrastType="药品" Data=$lg($g(^CT.WDT.CDSS.ConDrugDictD(IntDictDR)),4)
		s:ContrastType="中药" Data=$lg($g(^CT.WDT.CDSS.ConTCMDictD(IntDictDR)),4)
		s:ContrastType="中医诊断" Data=$lg($g(^CT.WDT.CDSS.ConTCMDictD(IntDictDR)),5)
		s:ContrastType="中医证型" Data=$lg($g(^CT.WDT.CDSS.ConTCMDictD(IntDictDR)),5)
		s Type=$case(ContrastType,"诊断":"诊断字典","检查":"检查项目字典","检验项目":"检验项目字典","药品":"药品字典","手术":"手术操作字典","护理":"护理医嘱字典","检验医嘱":"检验医嘱","输血品":"输血品字典","中药":"中药字典","中医诊断":"中医诊断字典","中医证型":"中医证型字典",:"")
		
		w !,DictCode_"	"_DictName_"	"_Type_"	"_ConDictCode_"	"_ConDictName_"	"_State_"	"_HospitalDesc_"	"_Remarks_"	"_DictDR_"	"_IntDictDR_"	"_Data

	}
	c file
	q fileName
}

/// Creator：阚延新
/// CreatDate: 2022-2-18
/// Description：根据对接方字典描述 获取知识库字典描述
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input：desc 
/// Return：diectname
/// Other: w ##class(web.CDSS.IMP.ContrastDict).GetDiectName("普通胰岛素注射液[400IU:10ml][口腔]","31","","1","")
ClassMethod GetDiectName(desc As %String, hosp As %String = "", type As %String = "", hisLocID As %String = "", source As %String = "") As %String
{
	s:hosp="" hosp= ##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	q:((desc="")||(hosp="")) ""
	s typeid=""  //对接方字典分类表id 
	if (type'="")  //如果入参数据类型不为空
	{	
		//如果入参是标准的类型名称，则通过对接方字典分类表的名称索引取id			
		s typeid=$case(type,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征信息","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检查检验","14":"输血品","15":"中药","16":"中医诊断","17":"中医证型",:"")
		//如果入参不是标准的类型名称,则单独处理
		s:typeid="" typeid=$case(type,"诊断":"诊断","药品":"药品","药物":"药品","手术":"手术","检查":"检查检验","检验":"检查检验","体征":"体征信息","检验医嘱":"检查检验","输血":"输血品","护理":"护理","频率":"频率","体征信息":"体征信息","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	 	//s:typeid="" typeid=$case(type,"诊断字典":"诊断","药品字典":"药品","药物":"药品","手术操作字典":"手术","检查":"检查检验","检查项目字典":"检查检验",:"")
	}
	s HospAreaDR=""
	if (hisLocID'="")		//由his科室id得到所属院区
	{
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("DeptIDIndex"," "_$zconvert(hisLocID,"U"),""))
		if (DeptID'="")
		{
			s HospAreaDR=$LISTGET($G(^CF.WDT.CDSS.DeptDictD(DeptID)),10)		//院区id
		}
	}
	s dictname=""
	s dictnameStr=""
	if (typeid="")	//传的类型为空
	{
		s typeDR=""
		for 
		{
			s typeDR=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp,typeDR))
			q:((typeDR="")||(dictname'=""))
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp,typeDR,desc,ID))
				q:ID=""
				s state=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态
				continue:((state="已删除")||(state="未关联"))
				if (HospAreaDR'="")
				{
					s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
					if (IntDictDR'="")
					{
						s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeDR,IntDictDR,""))
						if (HospArea'="")
						{
							s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeDR,IntDictDR,HospAreaDR,""))
							continue:ConDictConAreaID=""
						}

					}
				}
				if ((source'="")&&(typeDR="诊断"))
				{
					s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
					s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
					continue:Source'[source
				}
				s dictname=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),3)	//CDSS字典描述
				//知识库描述串
				if (dictnameStr=""){
					s dictnameStr=dictname
				}
				else{
					s dictnameStr=dictnameStr_"&%"_dictname
				}
				s dictname=dictnameStr
			}
		}
	} 
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp,typeid,desc,ID))
			q:ID=""
			s state=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态
			continue:((state="已删除")||(state="未关联"))
			if (HospAreaDR'="")
			{
				s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
				if (IntDictDR'="")
				{
					s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeid,IntDictDR,""))
					if (HospArea'="")
					{
						s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeid,IntDictDR,HospAreaDR,""))
						continue:ConDictConAreaID=""
					}
				}
			}
			if ((source'="")&&(typeid="诊断"))
			{
				s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
				s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
				continue:Source'[source
			}
			s dictname=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),3)	//CDSS字典描述		
			//知识库描述串
			if (dictnameStr=""){
				s dictnameStr=dictname
			}
			else{
				s dictnameStr=dictnameStr_"&%"_dictname
			}
			s dictname=dictnameStr	
		}	
	}
	s:dictname="" dictname=desc
	q dictname
}

/// Creator：阚延新
/// CreatDate: 2022-2-18
/// Description：根据对接方字典代码 获取知识库字典描述
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input：desc 
/// Return：diectname
/// Other: w ##class(web.CDSS.IMP.ContrastDict).GetDiectNameByCode("A00.000","9","","","")
ClassMethod GetDiectNameByCode(code As %String, hosp As %String = "", type As %String = "", hisLocID As %String = "", source As %String = "") As %String
{
	s:hosp="" hosp= ##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	q:((code="")||(hosp="")) ""
	s typeid=""  //对接方字典分类表id 
	if (type'="")  //如果入参数据类型不为空
	{	
		//如果入参是标准的类型名称，则通过对接方字典分类表的名称索引取id			
		s typeid=$case(type,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征信息","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检查检验","14":"输血品","15":"中药","16":"中医诊断","17":"中医证型",:"")
		//如果入参不是标准的类型名称,则单独处理
		s:typeid="" typeid=$case(type,"诊断":"诊断","药品":"药品","药物":"药品","手术":"手术","检查":"检查检验","检验":"检查检验","体征":"体征信息","检验医嘱":"检查检验","输血":"输血品","护理":"护理","频率":"频率","体征信息":"体征信息","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	}
	s HospAreaDR=""
	if (hisLocID'="")		//由his科室id得到所属院区
	{
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("DeptIDIndex"," "_$zconvert(hisLocID,"U"),""))
		if (DeptID'="")
		{
			s HospAreaDR=$LISTGET($G(^CF.WDT.CDSS.DeptDictD(DeptID)),10)		//院区id
		}
	}
	s dictcode=""
	if (typeid="")	//传的类型为空
	{
		s typeDR=""
		for 
		{
			s typeDR=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCodeIndex",hosp,typeDR))
			q:((typeDR="")||(dictcode'=""))
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCodeIndex",hosp,typeDR,code,ID))
				q:((ID="")||(dictcode'=""))
				s state=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态
				continue:((state="已删除")||(state="未关联"))
				if (HospAreaDR'="")
				{
					s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
					if (IntDictDR'="")
					{
						s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeDR,IntDictDR,""))
						if (HospArea'="")
						{
							s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeDR,IntDictDR,HospAreaDR,""))
							continue:ConDictConAreaID=""
						}

					}
				}
				if ((source'="")&&(typeDR="诊断"))
				{
					s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
					s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
					continue:Source'[source
				}
				s dictcode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),3)	//CDSS字典描述
			}
		}
	} 
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCodeIndex",hosp,typeid,code,ID))
			q:((ID="")||(dictcode'=""))
			s state=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态
			continue:((state="已删除")||(state="未关联"))
			if (HospAreaDR'="")
			{
				s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
				if (IntDictDR'="")
				{
					s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeid,IntDictDR,""))
					if (HospArea'="")
					{
						s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeid,IntDictDR,HospAreaDR,""))
						continue:ConDictConAreaID=""
					}

				}	
			}
			if ((source'="")&&(typeid="诊断"))
			{
				s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
				s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
				continue:Source'[source
			}
			s dictcode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),3)	//CDSS字典描述			
		}	
	}
	s:dictcode["," dictcode=$P(dictcode,",",1)
	q dictcode
}

/// Creator：阚延新
/// CreatDate: 2022-2-18
/// Description：根据字典表描述和医院代码，获取对照好的代码
/// Input： desc,type
/// Return：indictcode
/// Other: w ##class(web.CDSS.IMP.ContrastDict).GetMatchCode("胸部MRI,胸部MRI增强","")
ClassMethod GetMatchCode(desc As %String, type As %String = "", hisLocID As %String = "", source As %String = "") As %String
{
	q:desc="" ""
	s hosp=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	q:hosp="" ""
	
	s typeid=""  //对接方字典分类表id 
	if (type'="")  //如果入参数据类型不为空
	{	
		//如果入参是标准的类型名称，则通过对接方字典分类表的名称索引取id			
		s typeid=$case(type,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征信息","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检查检验","14":"输血品","15":"中药","16":"中医诊断","17":"中医证型",:"")
		//如果入参不是标准的类型名称,则单独处理
		s:typeid="" typeid=$case(type,"诊断":"诊断","药品":"药品","药物":"药品","手术":"手术","检查":"检查检验","检验":"检查检验","体征":"体征信息","检验医嘱":"检查检验","输血":"输血品","护理":"护理","频率":"频率","体征信息":"体征信息","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	}
	s HospAreaDR=""
	if (hisLocID'="")		//由his科室id得到所属院区
	{
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("DeptIDIndex"," "_$zconvert(hisLocID,"U"),""))
		if (DeptID'="")
		{
			s HospAreaDR=$LISTGET($G(^CF.WDT.CDSS.DeptDictD(DeptID)),10)		//院区id
		}
	}
	s dictcode=""
	if (typeid="")	//传的类型为空
	{
		s typeDR=""
		for 
		{
			s typeDR=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeDR))
			q:((typeDR="")||(dictcode'=""))
			s DictDesc=""
			for
			{
				s DictDesc=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeDR,DictDesc))
				q:DictDesc=""
				s descs=","_desc_","
				s DictDescs=","_DictDesc_","
				CONTINUE:DictDescs'[descs
				s state=""
				for
				{
					s state=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeDR,DictDesc,state))
					q:((state="")||(dictcode'=""))
					continue:((state="已删除")||(state="未关联"))
					s ID=0
					for 
					{
						s ID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeDR,DictDesc,state,ID))
						q:((ID="")||(dictcode'=""))
						if (HospAreaDR'="")
						{
							s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
							if (IntDictDR'="")
							{
								s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeDR,IntDictDR,""))
								if (HospArea'="")
								{
									s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeDR,IntDictDR,HospAreaDR,""))
									continue:ConDictConAreaID=""
								}
							}
						}
						if ((source'="")&&(typeDR="诊断"))
						{
							s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
							s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
							continue:Source'[source
						}
						s dictcode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),5)	//CDSS字典描述
					}
				}
			}
		}
	} 
	else
	{
		s DictDesc=""
		for
		{
			s DictDesc=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeid,DictDesc))
			q:DictDesc=""
			s descs=","_desc_","
			s DictDescs=","_DictDesc_","
			CONTINUE:DictDescs'[descs
			s state=""
			for
			{
				s state=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeid,DictDesc,state))
				q:((state="")||(dictcode'=""))
				continue:((state="已删除")||(state="未关联"))
				s ID=0
				for 
				{
					s ID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeid,DictDesc,state,ID))
					q:((ID="")||(dictcode'=""))
					if (HospAreaDR'="")
					{
						s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
						if (IntDictDR'="")
						{
							s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeid,IntDictDR,""))
							if (HospArea'="")
							{
								s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeid,IntDictDR,HospAreaDR,""))
								continue:ConDictConAreaID=""
							}
						}
					}
					if ((source'="")&&(typeid="诊断"))
					{
						s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
						s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
						continue:Source'[source
					}
					s dictcode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),5)	//CDSS字典描述			
				}	
			}
		}
	}
	s:dictcode["," dictcode=$P(dictcode,",",1)
	q dictcode
}

/// Creator：阚延新
/// CreatDate: 2022-2-18
/// Description：根据字典表描述和医院代码，获取对照好的代码, 如果是诊断或者手术，返回备注中的ICD
/// Input： desc,type
/// Return：indictcode
/// Other: w ##class(web.CDSS.IMP.ContrastDict).GetMatchCodeOrICD("甲硝唑栓","")
ClassMethod GetMatchCodeOrICD(desc As %String, type As %String = "", hisLocID As %String = "", source As %String = "") As %String
{
	q:desc="" ""
	s hosp=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	q:hosp="" ""
	s typeid=""  //对接方字典分类表id 
	if (type'="")  //如果入参数据类型不为空
	{	
		//如果入参是标准的类型名称，则通过对接方字典分类表的名称索引取id			
		s typeid=$case(type,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征信息","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检查检验","14":"输血品","15":"中药","16":"中医诊断","17":"中医证型",:"")
		//如果入参不是标准的类型名称,则单独处理
		s:typeid="" typeid=$case(type,"诊断":"诊断","药品":"药品","药物":"药品","手术":"手术","检查":"检查检验","检验":"检查检验","体征":"体征信息","检验医嘱":"检查检验","输血":"输血品","护理":"护理","频率":"频率","体征信息":"体征信息","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	}
	s HospAreaDR=""
	if (hisLocID'="")		//由his科室id得到所属院区
	{
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("DeptIDIndex"," "_$zconvert(hisLocID,"U"),""))
		if (DeptID'="")
		{
			s HospAreaDR=$LISTGET($G(^CF.WDT.CDSS.DeptDictD(DeptID)),10)		//院区id
		}
	}
	s dictcode=""
	if (typeid="")	//传的类型为空
	{
		s typeDR=""
		for 
		{
			s typeDR=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeDR))
			q:((typeDR="")||(dictcode'=""))
			s DictDesc=""
			for
			{
				s DictDesc=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeDR,DictDesc))
				q:DictDesc=""
				s descs=","_desc_","
				s DictDescs=","_DictDesc_","
				CONTINUE:DictDescs'[descs
				s state=""
				for
				{
					s state=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeDR,DictDesc,state))
					q:((state="")||(dictcode'=""))
					continue:((state="已删除")||(state="未关联"))
					s ID=0
					for 
					{
						s ID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeDR,DictDesc,state,ID))
						q:((ID="")||(dictcode'=""))
						s intdictdr=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)		//对接方字典DR
						s remarks=""
						if (typeDR="诊断")
						{
							s remarks=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(intdictdr)),5)
						}
						if (typeDR="手术")
						{
							s remarks=$LISTGET($G(^CT.WDT.CDSS.ConOperDictD(intdictdr)),12)
						}
						if (HospAreaDR'="")
						{
							s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeDR,intdictdr,""))
							if (HospArea'="")
							{
								s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeDR,intdictdr,HospAreaDR,""))
								continue:ConDictConAreaID=""
							}
						}
						if ((source'="")&&(typeDR="诊断"))
						{
							s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
							s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
							continue:Source'[source
						}
						s:remarks="" dictcode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),5)	//CDSS字典描述
						s:remarks'="" dictcode=remarks
					}
				}
			}
		}
	} 
	else
	{
		s DictDesc=""
		for
		{
			s DictDesc=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeid,DictDesc))
			q:DictDesc=""
			s descs=","_desc_","
			s DictDescs=","_DictDesc_","
			CONTINUE:DictDescs'[descs
			s state=""
			for
			{
				s state=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeid,DictDesc,state))
				q:((state="")||(dictcode'=""))
				continue:((state="已删除")||(state="未关联"))
				s ID=0
				for 
				{
					s ID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,typeid,DictDesc,state,ID))
					q:((ID="")||(dictcode'=""))
					s intdictdr=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)		//对接方字典DR
					s remarks=""
					if (typeid="诊断")
					{
						s remarks=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(intdictdr)),5)
					}
					if (typeid="手术")
					{
						s remarks=$LISTGET($G(^CT.WDT.CDSS.ConOperDictD(intdictdr)),12)
					}
					if (HospAreaDR'="")
					{
						s HospArea=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",typeid,intdictdr,""))
						if (HospArea'="")
						{
							s ConDictConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",typeid,intdictdr,HospAreaDR,""))
							continue:ConDictConAreaID=""
						}
					}
					if ((source'="")&&(typeid="诊断"))
					{
						s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
						s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
						continue:Source'[source
					}
					s:remarks="" dictcode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),5)	//CDSS字典描述
					s:remarks'="" dictcode=remarks
				}	
			}
		}
		
	}
	s:dictcode["," dictcode=$P(dictcode,",",1)
	q dictcode
}

/// Creator：阚延新
/// CreatDate: 2022-2-18
/// Description：根据知识库描述和类型，获取对接方数据的描述.  有对照的药品都返回知识库名，没对照的返回空。其他类型如果1对1就返回医院的名称 ，如果1对多返回知识库名，没有对照返回空
/// desc 知识库描述，type 数据类型,codeFlag-代码标识，如果代码标识不为空，则返回描述+代码，如果为空则只返回描述,hisLocID-科室id，如果不为空，则只返回本院区的数据，source-门诊/急诊/住院,如果不为空，则只返回该来源的数据
/// Other: w ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName("超声引导下定位","",1,"","")
ClassMethod GetProjectDataName(desc As %String, type As %String = "", codeFlag As %String = "", hisLocID As %String = "", source As %String = "") As %String
{
	q:desc="" ""
	s Hospital=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	//s Hospital=101
	q:Hospital="" ""
	s typeid=""  //对接方字典分类表id
	if (type'="")  //如果入参数据类型不为空
	{	
		//如果入参是标准的类型名称，则通过对接方字典分类表的名称索引取id			
		s typeid=$case(type,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征信息","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检查检验","14":"输血品","15":"中药","16":"中医诊断","17":"中医证型",:"")
		//如果入参不是标准的类型名称,则单独处理
		s:typeid="" typeid=$case(type,"诊断":"诊断","药品":"药品","药物":"药品","手术":"手术","检查":"检查检验","检验":"检查检验","体征":"体征信息","检验医嘱":"检查检验","输血":"输血品","护理":"护理","频率":"频率","体征信息":"体征信息","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	}
	s HospAreaDR=""
	if (hisLocID'="")		//由his科室id得到所属院区
	{
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("DeptIDIndex"," "_$zconvert(hisLocID,"U"),""))
		if (DeptID'="")
		{
			s HospAreaDR=$LISTGET($G(^CF.WDT.CDSS.DeptDictD(DeptID)),10)		//院区id
		}
	}
	s result=""
	s ConDictCode="",ConDictName="",DictCode="" ,ConType=""
	if (typeid="")	//类型为空
	{
		s count=0
		s ContrastType=""
		for
		{
			s ContrastType=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,ContrastType))
			q:(ContrastType="")||(count>0)
			s State=""
			for
			{
				s State=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,ContrastType,desc,State))
				q:State=""
				continue:(State="未关联")||(State="已删除")
				s MappingID=0
				for
				{
					s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,ContrastType,desc,State,MappingID))
					q:MappingID=""
					s DictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),2)
					s ConDictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),5)  //对接方字典代码
					s ConDictName=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),6)  //对接方字典描述
					s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),11) //对接方字典ID
					
					
					if (HospAreaDR'="")  //院区不为空
					{  
						continue:IntDictDR=""  
				  		if '($d(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",ContrastType,IntDictDR,HospAreaDR)))  //不属于该院区则不输出
						{
							continue
						}
					}
					if ((source'="")&&(ContrastType="诊断"))  //来源（住院/门诊/急诊）不为空
					{
						continue:IntDictDR=""  
						s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
						if (Source'[source)   // 不属于该来源的数据不输出
						{  
							continue
						}
					}
					
					s count=count+1
					s ConType=ContrastType

				}	
			}
			
		}
	}
	else  //类型不为空
	{
		s count=0
		s ContrastType=typeid,ConType=typeid
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,ContrastType,desc,State))
			q:State=""
			continue:(State="未关联")||(State="已删除")
			s MappingID=0
			for
			{
				s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",Hospital,ContrastType,desc,State,MappingID))
				q:MappingID=""
				s DictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),2)
				s ConDictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),5)
				s ConDictName=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),6)
				s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),11) //对接方字典ID
				if (HospAreaDR'="")  //院区不为空
				{  
					continue:IntDictDR=""  
			  		if '($d(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",ContrastType,IntDictDR,HospAreaDR)))  //不属于该院区则不输出
					{
						continue
					}
				}
				if ((source'="")&&(ContrastType="诊断"))  //来源（住院/门诊/急诊）不为空
				{
					continue:IntDictDR=""  
					s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
					if (Source'[source)   // 不属于该来源的数据不输出
					{  
						continue
					}
				}
				s count=count+1
			}	
		}
	}
	
	if (count=1)
	{
		if (codeFlag="")
		{
			s result=ConDictName
		}
		else
		{
		
			s result=ConDictCode_"&%"_ConDictName
		}
	}
	elseif (count>1)
	{
		if (codeFlag="")
		{
			s result=desc
		}
		else
		{
		
			s result=DictCode_"&%"_desc
		}
	}
	else
	{
		s result=""
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2022-2-18
/// Description：根据知识库描述和类型，获取对接方数据的所有代码和描述
/// Table:desc 知识库描述，type 数据类型,codeFlag-代码标识，如果代码标识不为空，则返回描述+代码，如果为空则只返回描述
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).GetAllProjectDataName("空腹血糖","检验项目","","",1)
ClassMethod GetAllProjectDataName(desc As %String, type As %String = "", hisLocID As %String = "", source As %String = "", JsonFlag As %String = "") As %String
{
	s result=""
	s resultjson=[]
	q:desc="" ""
	s hosp=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	q:hosp="" ""
	s typeid=""  //对接方字典分类表id 
	if (type'="")  //如果入参数据类型不为空
	{	
		//如果入参是标准的类型名称，则通过对接方字典分类表的名称索引取id			
		s typeid=$case(type,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征信息","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检查检验","14":"输血品","15":"中药","16":"中医诊断","17":"中医证型",:"")
		//如果入参不是标准的类型名称,则单独处理
		s:typeid="" typeid=$case(type,"诊断":"诊断","药品":"药品","药物":"药品","手术":"手术","检查":"检查检验","检验":"检查检验","检验项目":"检查检验","体征":"体征信息","检验医嘱":"检查检验","输血":"输血品","护理":"护理","频率":"频率","体征信息":"体征信息","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	}
	s HospAreaDR=""
	if (hisLocID'="")		//由his科室id得到所属院区
	{
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("DeptIDIndex"," "_$zconvert(hisLocID,"U"),""))
		if (DeptID'="")
		{
			s HospAreaDR=$LISTGET($G(^CF.WDT.CDSS.DeptDictD(DeptID)),10)		//院区id
		}
	}
	s IntDictDesc="",IntDictCode=""
	if (typeid="")	//传的类型为空
	{
		s count=0
		s ContrastType=""
		for
		{
			s ContrastType=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,ContrastType))
			q:(ContrastType="")||(count>0)
			s State=""
			for
			{
				s State=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,ContrastType,desc,State))
				q:State=""
				continue:(State="未关联")||(State="已删除")
				s MappingID=0
				for
				{
					s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,ContrastType,desc,State,MappingID))
					q:MappingID=""
					s DictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),2)
					s ConDictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),5)  //对接方字典代码
					s ConDictName=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),6)  //对接方字典描述
					s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),11) //对接方字典ID
					
					
					if (HospAreaDR'="")  //院区不为空
					{  
						continue:IntDictDR=""  
				  		if '($d(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",ContrastType,IntDictDR,HospAreaDR)))  //不属于该院区则不输出
						{
							continue
						}
					}
					
					if ((source'="")&&(typedr="诊断"))
					{
						s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),11)
						s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
						continue:(Source'[source)
					}
					s IntDictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),5)	//对接方字典代码
					s IntDictDesc=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),6)	//对接方描述  	 
					
					s OneDictItem = {}
					d OneDictItem.%Set("ItemName",IntDictDesc)
					d OneDictItem.%Set("ItemCode",IntDictCode)
					d resultjson.%Push(OneDictItem)		
				
					if (result="")
					{
						s result=IntDictCode_"^"_IntDictDesc
					}
					else
					{
						s result=result_","_IntDictCode_"^"_IntDictDesc
					}
					
				}
			}
		}
	}


	else
	{
		s count=0
		s ContrastType=typeid
		s State=""
		for
		{
			s State=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,ContrastType,desc,State))
			q:State=""
			continue:(State="未关联")||(State="已删除")
			s MappingID=0
			for
			{
				s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("DictNameStateIndex",hosp,ContrastType,desc,State,MappingID))
				q:MappingID=""
				s DictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),2)
				s ConDictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),5)
				s ConDictName=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),6)
				s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),11) //对接方字典ID
				if (typeid="检查检验")
				{
					continue:IntDictDR=""   //如果对接方字典ID为空，无法判断类型，则不输出
					s ConExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),17)  //项目类型
					if (ConExamType'="")  
					{
						continue:ConExamType'=type
					}
					else 
					{
						s KnoType=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),4)  //知识库类型
						continue:KnoType'=type
					}
					
				}

				if (HospAreaDR'="")  //院区不为空
				{  
					continue:IntDictDR=""  
			  		if '($d(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",ContrastType,IntDictDR,HospAreaDR)))  //不属于该院区则不输出
					{
						continue
					}
				}
				
				if ((source'="")&&(typeid="诊断"))
				{
					s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),11)
					s Source=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(IntDictDR)),4)
					continue:(Source'[source)
				}
				s IntDictCode=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),5)	//对接方字典代码
				s IntDictDesc=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),6)	//对接方描述  	 
				if (result="")
				{
					s result=IntDictCode_"^"_IntDictDesc
				}
				else
				{
					s result=result_","_IntDictCode_"^"_IntDictDesc
				}
				s OneDictItem = {}
				d OneDictItem.%Set("ItemName",IntDictDesc)
				d OneDictItem.%Set("ItemCode",IntDictCode)
				d resultjson.%Push(OneDictItem)	
			}
		}
		
	}
	if (JsonFlag'="")
	{
		q resultjson.%ToJSON()	
	}
	else
	{
		q result
	}
}

/// Creator：阚延新
/// CreatDate: 2022-01-24
/// Description：导入对接方字典关联院区数据,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:CT.WDT.CDSS.ConDictConArea
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ContrastDict).ImportDRTXT("")
ClassMethod ImportDRTXT(path) As %String
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
		s DictCode=$p(data,$c(9),1)    		//对接方代码
		continue:DictCode=""
		s DictDesc=$p(data,$c(9),2)    		//对接方描述
		continue:DictDesc=""
		s DictHospAreaDescs=$p(data,$c(9),3)	//所属分院区
		s DictHospDesc="苏州科技城医院" 	//对接方字典医院		
		s size=$l(DictHospAreaDescs,"/")
   		for i=1:1:size
    	{
	    	s DictHospAreaDesc=$p(DictHospAreaDescs,"/",i)
	    	b:DictHospAreaDesc=""
	    	s DictHosp=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_$zconvert(DictHospDesc,"U"),""))
			if (DictHosp="")		//医院错误
			{
				s hospcount=hospcount+1
				continue
			}	
			s DictHospArea=$o(^CT.WDT.CDSS.CustomerHospAreaI("DescIndex",DictHosp,DictHospAreaDesc,0))
			if (DictHospArea="")	//院区错误
			{
				s hospareacount=hospareacount+1
				continue
			}
			s HospAreaID=DictHosp_"||"_DictHospArea
			s DictType=0
			for
			{
				s DictType=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,DictType))
				q:DictType=""
				s ConID=""
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictCDIndex",DictHosp,DictType,DictCode,DictDesc,ConID))
					q:ConID=""
					s IntType=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),4)			//对照类型
					s IntID=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),11)		//对接方字典DR
					s eobj = ##class(web.CDSSEntity.IMP.ConDictConArea).%New()
					s eobj.ConDictType=IntType
					s eobj.InterDictDR=IntID
					s eobj.HospAreaDR=HospAreaID
					s result=..SaveConDictArea(eobj)
					if ((result'["false"))
					{	
						s savecount=savecount+1
						
					}
					else
					{
						if (result'["存在")
						{
							s unsavecount=unsavecount+1
						}
						else
						{
						   	s incount=incount+1	
						}	
					}
				}
			}
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

ClassMethod IntConAreaValidate(id As %String, type As %String, intid As %String, hosp As %String) As %String
{
	s flag="",flagc=""
	s:((intid'="")&&(type'="")&&(hosp'="")) flagc=$d(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",type,intid,hosp))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		
		s:((intid'="")&&(type'="")&&(hosp'="")) idc=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",type,intid,hosp,0))
		
	
		if ((idc'="")&(idc'=id)&(flagc>0)) 	//返回重复标志
		{
			s flag=1  
		}
		else  	//返回不重复标志
		{
			s flag=0 
		}
	}
	q flag
}

/// Creator:阚延新
/// CreatDate: 2022-02-22
/// Description：保存 对接方字典关联院区表
/// Input: 
/// Table:CT.WDT.CDSS.ConDictConArea
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).SaveConDictArea("")
ClassMethod SaveConDictArea(eobj As web.CDSSEntity.IMP.ConDictConArea) As %String
{
	s result=""	
	if $IsObject(eobj)
	{	
		s flag=..IntConAreaValidate(eobj.ID,eobj.ConDictType,eobj.InterDictDR,eobj.HospAreaDR)
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.ConDictConArea).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.ConDictConArea).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.ConDictConArea).%New()
			s bobj.ID = eobj.ID
			s bobj.ConDictType = obj.ConDictType
			s bobj.InterDictDR = obj.InterDictDR
			s:obj.HospAreaDR'="" bobj.HospAreaDR = obj.HospAreaDR.%Id()				
		}
		s obj.ConDictType=eobj.ConDictType
		s obj.InterDictDR=eobj.InterDictDR
		d obj.HospAreaDRSetObjectId(eobj.HospAreaDR)
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS_ConDictConArea","CT.WDT.CDSS.ConDictConArea","对接方字典关联院区V2.0",id,eobj.InterDictDR,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS_ConDictConArea","CT.WDT.CDSS.ConDictConArea","对接方字典关联院区V2.0",id,eobj.InterDictDR,"A",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方字典关联院区表","CT.WDT.CDSS.ConDictConArea","SaveIntConArea",eobj)
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

/// Creator:阚延新
/// CreatDate: 2022-02-22
/// Description：删除 对接方字典关联院区表
/// Input: 
/// Table:CT.WDT.CDSS.ConDictConArea
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ContrastDict).DeleteConArea("","")
ClassMethod DeleteConArea(id) As %String
{
	s result=""
	s pobj = ##class(CT.WDT.CDSS.ConDictConArea).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.IMP.ConDictConArea).%New()
	s eobj.ConDictType = pobj.ConDictType
	s eobj.InterDictDR = pobj.InterDictDR
	s:pobj.HospAreaDR'="" eobj.HospAreaDR = pobj.HospAreaDR.%Id()	
	d pobj.%Close()
	kill pobj
	TS
	s sc=##class(CT.WDT.CDSS.ConDictConArea).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConDictConArea","CT.WDT.CDSS.ConDictConArea","对接方字典关联院区V2.0",id,eobj.InterDictDR_"-"_eobj.HospAreaDR,"D",eobj)
	}
	else
	{
		Trollback
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方字典关联院区V2.0","web.CDSS.IMP.ContrastDict","DeleteConArea",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：阚延新
/// CreatDate: 2022-3-3
/// Description：根据对接方字典描述获取对照好的知识库描述
/// Input： desc
/// Return：desc
/// Other: w ##class(web.CDSS.IMP.ContrastDict).GetDictDesc("")
ClassMethod GetDictDesc(desc As %String) As %String
{
	q:desc="" ""
	s DiceDesc=""
	s hosp=0
	for 
	{
		s hosp=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp))
		q:((hosp="")||(DiceDesc'=""))
		s type=""
		for
		{
			s type=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp,type))
			q:((type="")||(DiceDesc'=""))
			s ID=""
			for
			{
				s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp,type,desc,ID))
				q:((ID="")||(DiceDesc'=""))
				s state=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态
				continue:(state'="已确认")
				s DiceDesc=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),3)		//知识库字典描述
			}
		}
		
	}
	q DiceDesc
}

/// Creator:阚延新
/// CreatDate:2022-03-30
/// Description：获取字典对照2.0数据 保存到临时global
/// Input：
/// Return:1
/// w ##class(web.CDSS.IMP.ContrastDict).GetDiaConDataToTempGlobal()
ClassMethod GetDiaConDataToTempGlobal(hospid As %String = "") As %String
{
	k ^MTEMPContrastDictD
	k ^MTEMPConDiseaseDictD
	k ^MTEMPConDrugDictD
	k ^MTEMPConNurseDictD
	k ^MTEMPConOperDictD
	k ^MTEMPConExamDictD
	k ^MTEMPConOtherDictD	
	k ^MTEMPConInterfaceClassDictD	
	k ^MTEMPConTCMDictD
	k ^MTEMPConCMDiseDictD
	k ^MTEMPConCustomerHospD
	k ^MTEMPConCustomerHospC
	k ^MTEMPConLabOrderConItemD
	
	s ^MTEMPContrastDictD=$g(^CT.WDT.CDSS.ContrastDictD)
	s ^MTEMPConDiseaseDictD=$g(^CT.WDT.CDSS.ConDiseaseDictD)
	s ^MTEMPConDrugDictD=$g(^CT.WDT.CDSS.ConDrugDictD)
	s ^MTEMPConNurseDictD=$g(^CT.WDT.CDSS.ConNurseDictD)
	s ^MTEMPConOperDictD=$g(^CT.WDT.CDSS.ConOperDictD)
	s ^MTEMPConExamDictD=$g(^CT.WDT.CDSS.ConExamDictD)
	s ^MTEMPConOtherDictD=$g(^CT.WDT.CDSS.ConOtherDictD)
	s ^MTEMPConInterfaceClassDictD=$g(^CT.WDT.CDSS.ConClassDictD)
	s ^MTEMPConTCMDictD=$g(^CT.WDT.CDSS.ConTCMDictD)
	s ^MTEMPConCMDiseDictD=$g(^CT.WDT.CDSS.ConCMDiseDictD)
	s ^MTEMPConCustomerHospD=$g(^CT.WDT.CDSS.CustomerHospD)
	s ^MTEMPConCustomerHospC("ChildExt")=$g(^CT.WDT.CDSS.CustomerHospC("ChildExt"))
  	
    
    //遍历检验医嘱和检验项目关联表
    s flag=##class(web.DHCBL.BDP.FunLib).IsValidClassName("CT.WDT.CDSS.LabOrderConItem")
	if (flag=1)
	{
		s ^MTEMPConLabOrderConItemD=$g(^CT.WDT.CDSS.LabOrderConItemD)
		s LabOrderConRowId=0
		for
		{  
			s LabOrderConRowId=$o(^CT.WDT.CDSS.LabOrderConItemD(LabOrderConRowId)) 
			q:LabOrderConRowId=""  
			s ^MTEMPConLabOrderConItemD(LabOrderConRowId)=^CT.WDT.CDSS.LabOrderConItemD(LabOrderConRowId)
			
		}
	}
	//遍历分类表
	s ClassRowId=0
	for
	{  
		s ClassRowId=$o(^CT.WDT.CDSS.ConClassDictD(ClassRowId)) 
		q:ClassRowId=""  
		s ^MTEMPConInterfaceClassDictD(ClassRowId)=^CT.WDT.CDSS.ConClassDictD(ClassRowId)
		
	}
	//遍历对接方字典表
	s ConDiseaseRowId=0
	for
	{  
		s ConDiseaseRowId=$o(^CT.WDT.CDSS.ConDiseaseDictD(ConDiseaseRowId)) 
		q:ConDiseaseRowId=""  
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConDiseaseDictD(ConDiseaseRowId)),6)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPConDiseaseDictD(ConDiseaseRowId)=^CT.WDT.CDSS.ConDiseaseDictD(ConDiseaseRowId)	
	}
	s ConDrugRowId=0
	for
	{  
		s ConDrugRowId=$o(^CT.WDT.CDSS.ConDrugDictD(ConDrugRowId)) 
		q:ConDrugRowId=""  
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConDrugDictD(ConDrugRowId)),11)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPConDrugDictD(ConDrugRowId)=^CT.WDT.CDSS.ConDrugDictD(ConDrugRowId)	
	}
	s ConNurseRowId=0
	for
	{  
		s ConNurseRowId=$o(^CT.WDT.CDSS.ConNurseDictD(ConNurseRowId)) 
		q:ConNurseRowId=""  
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConNurseDictD(ConNurseRowId)),6)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPConNurseDictD(ConNurseRowId)=^CT.WDT.CDSS.ConNurseDictD(ConNurseRowId)	
	}
	s ConOperRowId=0
	for
	{  
		s ConOperRowId=$o(^CT.WDT.CDSS.ConOperDictD(ConOperRowId)) 
		q:ConOperRowId=""  
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConOperDictD(ConOperRowId)),5)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPConOperDictD(ConOperRowId)=^CT.WDT.CDSS.ConOperDictD(ConOperRowId)	
	}
	s ConExamRowId=0
	for
	{  
		s ConExamRowId=$o(^CT.WDT.CDSS.ConExamDictD(ConExamRowId)) 
		q:ConExamRowId=""  
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(ConExamRowId)),8)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPConExamDictD(ConExamRowId)=^CT.WDT.CDSS.ConExamDictD(ConExamRowId)	
	}
	s ConOtherRowId=0
	for
	{  
		s ConOtherRowId=$o(^CT.WDT.CDSS.ConOtherDictD(ConOtherRowId)) 
		q:ConOtherRowId=""  
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConOtherDictD(ConOtherRowId)),6)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPConOtherDictD(ConOtherRowId)=^CT.WDT.CDSS.ConOtherDictD(ConOtherRowId)	
	}
	s ConTCMRowId=0
	for
	{  
		s ConTCMRowId=$o(^CT.WDT.CDSS.ConTCMDictD(ConTCMRowId)) 
		q:ConTCMRowId=""  
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConTCMDictD(ConTCMRowId)),11)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPConTCMDictD(ConTCMRowId)=^CT.WDT.CDSS.ConTCMDictD(ConTCMRowId)	
	}
	s ConCMiseRowId=0
	for
	{  
		s ConCMiseRowId=$o(^CT.WDT.CDSS.ConCMDiseDictD(ConCMiseRowId)) 
		q:ConCMiseRowId=""  
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ConCMDiseDictD(ConCMiseRowId)),6)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPConCMDiseDictD(ConCMiseRowId)=^CT.WDT.CDSS.ConCMDiseDictD(ConCMiseRowId)	
	}
    //遍历字典对照表
	s ContrastRowId=0
	for{    
		s ContrastRowId=$o(^CT.WDT.CDSS.ContrastDictD(ContrastRowId)) 
		q:ContrastRowId="" 
		s DictHosp=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ContrastRowId)),8)	//所属医院
		continue:((DictHosp'=hospid)&&(hospid'=""))
		s ^MTEMPContrastDictD(ContrastRowId)=^CT.WDT.CDSS.ContrastDictD(ContrastRowId)
	}
	//遍历医院字典表
	s CustomerHospRowId=0    
	s ^MTEMPConCustomerHospD(hospid)=^CT.WDT.CDSS.CustomerHospD(hospid)
	s CustomerHospRowId=hospid
	//医院院区子表
	s CustomerHospChildsub=0
	for 
	{
		S CustomerHospChildsub=$o(^CT.WDT.CDSS.CustomerHospD(CustomerHospRowId,"ChildExt",CustomerHospChildsub)) q:CustomerHospChildsub=""
		s ^MTEMPConCustomerHospD(CustomerHospRowId,"ChildExt",CustomerHospChildsub)=^CT.WDT.CDSS.CustomerHospD(CustomerHospRowId,"ChildExt",CustomerHospChildsub)
		q
	}
	
	
	q "success"
}

/// Creator:阚延新
/// CreatDate:2022-03-30
/// Description：获取临时global的数据保存到知识库表里
/// Input：
/// Return:1
/// w ##class(web.CDSS.IMP.ContrastDict).GetTempGlobalToMKBTable()
ClassMethod GetTempGlobalToMKBTable() As %String
{
	b ;确定库是否正确？？？确定的话输 g 不确定输 q	
	b ;确定要更字典对照数据吗？确定的话输 g 不确定输 q
	k ^CT.WDT.CDSS.ContrastDictD
	k ^CT.WDT.CDSS.ContrastDictI
	k ^CT.WDT.CDSS.ConDiseaseDictD
	k ^CT.WDT.CDSS.ConDiseaseDictI
	k ^CT.WDT.CDSS.ConDrugDictD
	k ^CT.WDT.CDSS.ConDrugDictI
	k ^CT.WDT.CDSS.ConNurseDictD
	k ^CT.WDT.CDSS.ConNurseDictI
	k ^CT.WDT.CDSS.ConOperDictD
	k ^CT.WDT.CDSS.ConOperDictI
	k ^CT.WDT.CDSS.ConExamDictD
	k ^CT.WDT.CDSS.ConExamDictI
	k ^CT.WDT.CDSS.ConOtherDictD
	k ^CT.WDT.CDSS.ConOtherDictI
	k ^CT.WDT.CDSS.ConClassDictD
	k ^CT.WDT.CDSS.ConClassDictI
	k ^CT.WDT.CDSS.ConTCMDictD
	k ^CT.WDT.CDSS.ConTCMDictI
	k ^CT.WDT.CDSS.ConCMDiseDictD
	k ^CT.WDT.CDSS.ConCMDiseDictI
	k ^CT.WDT.CDSS.CustomerHospD
	k ^CT.WDT.CDSS.CustomerHospI
	k ^CT.WDT.CDSS.CustomerHospC
	k ^CT.WDT.CDSS.CustomerHospAreaI	
    s flag=##class(web.DHCBL.BDP.FunLib).IsValidClassName("CT.WDT.CDSS.LabOrderConItem")
	if (flag=1)
	{
		k ^CT.WDT.CDSS.LabOrderConItemD
		k ^CT.WDT.CDSS.LabOrderConItemI
		//遍历his检验医嘱和检验项目关联表
		if ($d(^MTEMPConLabOrderConItemD)>0)
		{
			s ^CT.WDT.CDSS.LabOrderConItemD=^MTEMPConLabOrderConItemD
			s ConItemRowId=0
			for
			{  
				s ConItemRowId=$o(^MTEMPConLabOrderConItemD(ConItemRowId)) 
				q:ConItemRowId=""  
				s ^CT.WDT.CDSS.LabOrderConItemD(ConItemRowId)=^MTEMPConLabOrderConItemD(ConItemRowId)
			}
			k ^MTEMPConLabOrderConItemD
			d ##class(CT.WDT.CDSS.LabOrderConItem).%BuildIndices()
	}
		
	}
	//把临时global赋值给正式的global
	//遍历分类表
	if ($d(^MTEMPConInterfaceClassDictD)>0)
	{
		s ^CT.WDT.CDSS.ConClassDictD=^MTEMPConInterfaceClassDictD
		s ClassRowId=0
		for
		{  
			s ClassRowId=$o(^MTEMPConInterfaceClassDictD(ClassRowId)) 
			q:ClassRowId=""  
			s ^CT.WDT.CDSS.ConClassDictD(ClassRowId)=^MTEMPConInterfaceClassDictD(ClassRowId)
		}
		k ^MTEMPConInterfaceClassDictD
		d ##class(CT.WDT.CDSS.ConClassDict).%BuildIndices()
	}
	
	
	//遍历对接方字典表
	if ($d(^MTEMPConDiseaseDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ConDiseaseDictD=^MTEMPConDiseaseDictD
		s ConDiseaseRowId=0
		for
		{  
			s ConDiseaseRowId=$o(^MTEMPConDiseaseDictD(ConDiseaseRowId)) 
			q:ConDiseaseRowId=""  
			s ^CT.WDT.CDSS.ConDiseaseDictD(ConDiseaseRowId)=^MTEMPConDiseaseDictD(ConDiseaseRowId)	
		}
		k ^MTEMPConDiseaseDictD
		d ##class(CT.WDT.CDSS.ConDiseaseDict).%BuildIndices()
	}
	if ($d(^MTEMPConDrugDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ConDrugDictD=^MTEMPConDrugDictD
		s ConDrugRowId=0
		for
		{  
			s ConDrugRowId=$o(^MTEMPConDrugDictD(ConDrugRowId)) 
			q:ConDrugRowId=""  
			s ^CT.WDT.CDSS.ConDrugDictD(ConDrugRowId)=^MTEMPConDrugDictD(ConDrugRowId)	
		}
		k ^MTEMPConDrugDictD
		d ##class(CT.WDT.CDSS.ConDrugDict).%BuildIndices()
	}
	if ($d(^MTEMPConNurseDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ConNurseDictD=^MTEMPConNurseDictD
		s ConNurseRowId=0
		for
		{  
			s ConNurseRowId=$o(^MTEMPConNurseDictD(ConNurseRowId)) 
			q:ConNurseRowId=""  
			s ^CT.WDT.CDSS.ConNurseDictD(ConNurseRowId)=^MTEMPConNurseDictD(ConNurseRowId)	
		}
		k ^MTEMPConNurseDictD
		d ##class(CT.WDT.CDSS.ConNurseDict).%BuildIndices()
	}
	if ($d(^MTEMPConOperDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ConOperDictD=^MTEMPConOperDictD
		s ConOperRowId=0
		for
		{  
			s ConOperRowId=$o(^MTEMPConOperDictD(ConOperRowId)) 
			q:ConOperRowId=""  
			s ^CT.WDT.CDSS.ConOperDictD(ConOperRowId)=^MTEMPConOperDictD(ConOperRowId)	
		}
		k ^MTEMPConOperDictD
		d ##class(CT.WDT.CDSS.ConOperDict).%BuildIndices()
	}
	if ($d(^MTEMPConExamDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ConExamDictD=^MTEMPConExamDictD
		s ConExamRowId=0
		for
		{  
			s ConExamRowId=$o(^MTEMPConExamDictD(ConExamRowId)) 
			q:ConExamRowId=""  
			s ^CT.WDT.CDSS.ConExamDictD(ConExamRowId)=^MTEMPConExamDictD(ConExamRowId)	
		}
		k ^MTEMPConExamDictD
		d ##class(CT.WDT.CDSS.ConExamDict).%BuildIndices()
	}
	if ($d(^MTEMPConOtherDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ConOtherDictD=^MTEMPConOtherDictD
		s ConOtherRowId=0
		for
		{  
			s ConOtherRowId=$o(^MTEMPConOtherDictD(ConOtherRowId)) 
			q:ConOtherRowId=""  
			s ^CT.WDT.CDSS.ConOtherDictD(ConOtherRowId)=^MTEMPConOtherDictD(ConOtherRowId)	
		}
		k ^MTEMPConOtherDictD
		d ##class(CT.WDT.CDSS.ConOtherDict).%BuildIndices()
	}
	if ($d(^MTEMPConTCMDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ConTCMDictD=^MTEMPConTCMDictD
		s ConTCMRowId=0
		for
		{  
			s ConTCMRowId=$o(^MTEMPConTCMDictD(ConTCMRowId)) 
			q:ConTCMRowId=""  
			s ^CT.WDT.CDSS.ConTCMDictD(ConTCMRowId)=^MTEMPConTCMDictD(ConTCMRowId)	
		}
		k ^MTEMPConTCMDictD
		d ##class(CT.WDT.CDSS.ConTCMDict).%BuildIndices()
	}
	if ($d(^MTEMPConCMDiseDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ConCMDiseDictD=^MTEMPConCMDiseDictD
		s ConCMiseRowId=0
		for
		{  
			s ConCMiseRowId=$o(^MTEMPConCMDiseDictD(ConCMiseRowId)) 
			q:ConCMiseRowId=""  
			s ^CT.WDT.CDSS.ConCMDiseDictD(ConCMiseRowId)=^MTEMPConCMDiseDictD(ConCMiseRowId)	
		}
		k ^MTEMPConCMDiseDictD
		d ##class(CT.WDT.CDSS.ConCMDiseDict).%BuildIndices()
	}
	
	//遍历对照字典表
	if ($d(^MTEMPContrastDictD)>0)
	{
		
		s ^CT.WDT.CDSS.ContrastDictD=^MTEMPContrastDictD
		s ContrastRowId=0
		for{    
			s ContrastRowId=$o(^MTEMPContrastDictD(ContrastRowId)) 
			q:ContrastRowId="" 
			s ^CT.WDT.CDSS.ContrastDictD(ContrastRowId)=^MTEMPContrastDictD(ContrastRowId)
		}
		k ^MTEMPContrastDictD
		d ##class(CT.WDT.CDSS.ContrastDict).%BuildIndices()
	}
	//遍历院区及院区子表表
	if (($d(^MTEMPConCustomerHospD)>0)&($d(^MTEMPConCustomerHospC)>0))
	{
		
		s ^CT.WDT.CDSS.CustomerHospD=^MTEMPConCustomerHospD
		s ^CT.WDT.CDSS.CustomerHospC("ChildExt")=^MTEMPConCustomerHospC("ChildExt")
		s CustomerHospRowId=0
		for{    
			s CustomerHospRowId=$o(^MTEMPConCustomerHospD(CustomerHospRowId)) q:CustomerHospRowId="" 
			s ^CT.WDT.CDSS.CustomerHospD(CustomerHospRowId)=^MTEMPConCustomerHospD(CustomerHospRowId)
			s CustomerHospChildsub=0    
			for   
			{
				S CustomerHospChildsub=$o(^MTEMPConCustomerHospD(CustomerHospRowId,"ChildExt",CustomerHospChildsub)) q:CustomerHospChildsub=""
				s ^CT.WDT.CDSS.CustomerHospD(CustomerHospRowId,"ChildExt",CustomerHospChildsub)=^MTEMPConCustomerHospD(CustomerHospRowId,"ChildExt",CustomerHospChildsub)
			}
		}
		k ^MTEMPConCustomerHospD
		k ^MTEMPConCustomerHospC
		d ##class(CT.WDT.CDSS.CustomerHosp).%BuildIndices()
		d ##class(CT.WDT.CDSS.CustomerHospArea).%BuildIndices()
	}
    q "success"
}

/// Creator：阚延新
/// CreatDate:2022-3-31
/// Description:导出字典对照2.0的global
/// Input:path
/// Others：d ##class(web.CDSS.IMP.ContrastDict).ExportCDSSMappingGlobal("D:\MappingGlobal\")
ClassMethod ExportCDSSMappingGlobal(filePath)
{
	k MList
	k MIdx
	//对接方字典表
	s MList($i(MList))= "CT.WDT.CDSS.ConDiseaseDictD.GBL" 
	s MList($i(MList))= "CT.WDT.CDSS.ConDrugDictD.GBL"  
	s MList($i(MList))= "CT.WDT.CDSS.ConOperDictD.GBL"  
	s MList($i(MList))= "CT.WDT.CDSS.ConNurseDictD.GBL"  
	s MList($i(MList))= "CT.WDT.CDSS.ConExamDictD.GBL"  
	s MList($i(MList))= "CT.WDT.CDSS.ConOtherDictD.GBL"   
	s MList($i(MList))= "CT.WDT.CDSS.ConTCMDictD.GBL"
	s MList($i(MList))= "CT.WDT.CDSS.ConCMDiseDictD.GBL"
	//对接方字典分类表 
	s MList($i(MList))= "CT.WDT.CDSS.ConClassDictD.GBL"  
	
	//字典对照 
	s MList($i(MList))= "CT.WDT.CDSS.ContrastDictD.GBL" 
	
	//医院 
	s MList($i(MList))= "CT.WDT.CDSS.CustomerHospD.GBL"
	s MList($i(MList))= "CT.WDT.CDSS.CustomerHospI.GBL"
	//医院院区
	s MList($i(MList))= "CT.WDT.CDSS.CustomerHospC.GBL"
	 
	//对接方字典关联院区表
	s MList($i(MList))= "CT.WDT.CDSS.ConDictConAreaD.GBL"
	
	//HIS检验医嘱和检验项目关联表
	s MList($i(MList))= "^CT.WDT.CDSS.LabOrderConItemD.GBL"	 
	
	//把所有GBL拼起来
	s items = ""
	for {
		s MIdx = $i(MIdx)
		q:(MIdx>$g(MList))
		s:items'="" items=items_","_MList(MIdx)
		s:items="" items=MList(MIdx)
	}
	s time = $zdt($h,3)
	s time=$p(time,":",1)
	s filename = filePath_"MappingDataV2_"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	//删除十天前的备份
	/*
	s time = $zd(+$H-10,3)
	w time,!
	s filename = filePath_"MappingData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
	*/
}

/// Creator：阚延新
/// CreatDate:2022-4-2
/// Description:删除重复对照数据
/// Input:path
/// Others：w ##class(web.CDSS.IMP.ContrastDict).DelRepeatContrast()
ClassMethod DelRepeatContrast()
{
	s result=""
	s errorflag=0
	TS
	s Hospital=""
	for
	{
		s Hospital=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",Hospital))
		q:Hospital=""
		q:errorflag=1
		s Type=""
		for
		{
			s Type=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",Hospital,Type))
			q:Type=""
			q:errorflag=1
			s DictDR=""
			for
			{
				s DictDR=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",Hospital,Type,DictDR))
				q:DictDR=""
				continue:DictDR'[","
				q:errorflag=1
				s MappingID=0
				for
				{
					s MappingID=$o(^CT.WDT.CDSS.ContrastDictI("DictDRIndex",Hospital,Type,DictDR,MappingID))
					q:MappingID=""
					q:errorflag=1
					s obj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(MappingID)
					s name=..ArrayDeduplication(..Toarray(obj.DictName))
					s code=..ArrayDeduplication(..Toarray(obj.DictCode))
					s dr=..ArrayDeduplication(..Toarray(obj.DictDR))
					if ((name.%Size()'=code.%Size())||(code.%Size()'=dr.%Size()))
					{
						w "/// "_MappingID_" ///"
						s errorflag=1
						q
					}
					s name=..Tostring(name)
					s code=..Tostring(code)
					s dr=..Tostring(dr)
					s bobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
					s bobj.DictCode= code		//知识库字典代码
					s bobj.DictName= name		//知识库字典描述		
					s bobj.ID = MappingID
					s bobj.ContrastType= obj.ContrastType		//对照类型
					s bobj.ConDictCode=obj.ConDictCode		//对接方字典代码
					s bobj.ConDictName=obj.ConDictName		//对接方字典描述
					s bobj.State=obj.State		//状态（未关联/已关联/已确认/已删除）
					s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//医院
					s bobj.Remarks=obj.Remarks		//备注
					s bobj.DictDR=dr
					s bobj.IntDictDR=obj.IntDictDR
				
					s re= ..SaveEntity(bobj)
					s:re["false" errorflag=1
				}
			}	
		}	
	}

	if (errorflag=1)	//失败
	{
		tro
		s result="false"	
	}
	else
	{
		tc	
		s result="true"
	}
	q result
}

/// Others：w ##class(web.CDSS.IMP.ContrastDict).ArrayDeduplication(["护理","检查","护理"])
/// Others：w ##class(web.CDSS.IMP.ContrastDict).ArrayDeduplication([12,121,12])
/// Others：w ##class(web.CDSS.IMP.ContrastDict).ArrayDeduplication(["cd001","cd002","cd001"])
ClassMethod ArrayDeduplication(array As %Library.DynamicArray)
{
	s DedArray=[]
	s DedObject={}
	for i=0:1:array.%Size()-1
	{
		continue:DedObject.%IsDefined(array.%Get(i))
		d DedObject.%Set(array.%Get(i),"")
		d DedArray.%Push(array.%Get(i))
	}
	q DedArray
}

/// Others：w ##class(web.CDSS.IMP.ContrastDict).Toarray("护理,检查,护理")
ClassMethod Toarray(strs As %String)
{
	s array=[]
	s size=$l(strs,",")
    for i=1:1:size
    {
	    s str=$p(strs,",",i)
		d array.%Push(str)
    }
    q array
}

/// Others：w ##class(web.CDSS.IMP.ContrastDict).Tostring(["护理","检查","护理"])
ClassMethod Tostring(arr As %Library.DynamicArray)
{
	s str=""
    for i=0:1:arr.%Size()-1
    {
	    if (str="")
	    {
		    s str=arr.%Get(i)
		}
		else
		{
			s str=str_","_arr.%Get(i)
		}	
    }
    q str
}

/// Other:w ##class(web.CDSS.IMP.ContrastDict).UpdateConDictEndDate(1, "已关联", "诊断")
ClassMethod UpdateConDictEndDate(intdictdr, state, type)
{
	s result=""
	if (type="药品")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConDrugDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConDrugDict).UpdateState(intdictdr,state)
	}
	if (type="检查检验")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConExamDict).UpdateState(intdictdr,state)
	}
	if (type="护理")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConNurseDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConNurseDict).UpdateState(intdictdr,state)	
	}
	if (type="诊断")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConDiseaseDictI("HospCNIndex",hosp,icd,name,0))
		s result= ##class(web.CDSS.IMP.ConDiseaseDict).UpdateState(intdictdr,state)	
	}
	if (type="手术")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConOperDict).UpdateState(intdictdr,state)		
	}
	if (type="输血品")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="频率")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="检验标本")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="用法")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="单位")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="科室")
	{
		//s RowID=$o(^CT.WDT.CDSS.ConOperDictI("HospCodeIndex",hosp,code,0))
		s result= ##class(web.CDSS.IMP.ConOtherDict).UpdateState(intdictdr,state)		
	}
	if (type="中药")
	{
		s result= ##class(web.CDSS.IMP.ConTCMDict).UpdateState(intdictdr,state)		
	}
	if (type="中医诊断")
	{
		s result= ##class(web.CDSS.IMP.ConCMDiseDict).UpdateState(intdictdr,state)		
	}
	if (type="中医证型")
	{
		s result= ##class(web.CDSS.IMP.ConCMDiseDict).UpdateState(intdictdr,state)		
	}
	q result
}

/// Creator:钟荣枫 
/// CreatDate:2020-6-16
/// Description:获取字典表的id
/// Table: CT.WDT.CDSS.ExamDict 检查字典表,CT.WDT.CDSS.LabInspectionDict 检验字典表
/// Input: type 类型，dictcode 知识库代码
/// Return:id
/// Other:w ##class(web.CDSS.IMP.ContrastDict).GetDictIDCodeDesc("CT.WDT.CDSS.TCMDisease","","感冒")
ClassMethod GetDictIDCodeDesc(type As %String, dictcode As %String, dictdesc As %String, alldataflag As %String = "", drugflag As %String = "") As %String
{
	s:dictcode'="" dictcode=$ZCONVERT(dictcode,"U")  //转换成大写
	s:dictdesc'="" dictdesc=$ZCONVERT(dictdesc,"U")  //转换成大写
	q:((dictcode="")&&(dictdesc="")) ""
	s DictCode=""
	s DictDesc=""
	s DictID=""
	if ((type="CT.WDT.CDSS.DiseaseDict")||(type=1))	////疾病字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.DiseaseDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DictID)),3)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.ExamDict")||(type=2))	//检查字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.ExamDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.ExamDictD(DictID)),3)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.ExamDictD(DictID)),4)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.LabInspectionDict")||(type=3))	//检验字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.LabInspectionDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(DictID)),3)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.LabInspectionDictD(DictID)),4)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.DrugDict")||(type=4))	//药品字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.DrugDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			if (drugflag'="")	//在全部状态中取
			{
				s DictCode= $lg($g(^CT.WDT.CDSS.DrugDictD(DictID)),3)		//知识库字典代码
				s DictDesc= $lg($g(^CT.WDT.CDSS.DrugDictD(DictID)),4)		//知识库字典描述
			}
			else		//只取已审核
			{
				s MaintainFlag= $lg($g(^CT.WDT.CDSS.DrugDictD(DictID)),30)		//状态
				if (MaintainFlag=2)
				{
					s DictCode= $lg($g(^CT.WDT.CDSS.DrugDictD(DictID)),3)		//知识库字典代码
					s DictDesc= $lg($g(^CT.WDT.CDSS.DrugDictD(DictID)),4)		//知识库字典描述
				}
			}
		}
	}
	if ((type="CT.WDT.CDSS.OperationDict")||(type=5))	//手术字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.OperationDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.OperationDictD(DictID)),3)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.OperationDictD(DictID)),4)		//知识库字典描述
		}
	}
	
	if ((type="CT.WDT.CDSS.NursingDict")||(type=6))	//护理字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.NursingDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.NursingDictD(DictID)),3)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.NursingDictD(DictID)),4)		//知识库字典描述
		}

	}
	if ((type="CT.WDT.CDSS.FrequencyDict")||(type=7))	//频率字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.FrequencyDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.FrequencyDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.FrequencyDictD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.FrequencyDictD(DictID)),3)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.SignInfo")||(type=8))	//体征信息表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex","CT.WDT.CDSS.SignInfo",dictcode,0))
		}
		else
		{
			//Index TableNameFiledIndex On (TableName As Exact, TableFieldDesc As Exact);
			s DictID=$o(^CT.WDT.CDSS.DataTableDictI("TableNameFiledIndex","CT.WDT.CDSS.SignInfo",dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode=$listGet($g(^CT.WDT.CDSS.DataTableDictD(DictID)),6) //字段名称
			s DictDesc=$listGet($g(^CT.WDT.CDSS.DataTableDictD(DictID)),12) //字段描述
		}
	}
	if ((type="CT.WDT.CDSS.LabSpecimenDict")||(type=9))	//检验标本字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.LabSpecimenDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.LabSpecimenDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(DictID)),3)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.UsageDict")||(type=10))	//用法字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.UsageDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.UsageDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.UsageDictD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.UsageDictD(DictID)),3)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.UnitDict")||(type=11))	//单位字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.UnitDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			//Index DescIndex On UnitDesc;
			s DictID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.UnitDictD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.UnitDictD(DictID)),3)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.DiseaseDeptDict")||(type=12))	//科室字典
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DictID)),3)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.LabOrdersDict")||(type=13))	//检验医嘱
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.LabOrdersDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(DictID)),2) //检验医嘱代码
        		s DictDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(DictID)),3) //检验医嘱名称
		}
	}
	if ((type="CT.WDT.CDSS.BloodProductDict")||(type=14))	//输血品字典表
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.BloodProductDictI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.BloodProductDictI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.BloodProductDictD(DictID)),3)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.BloodProductDictD(DictID)),4)		//知识库字典描述
		}
	}		
	if ((type="CT.WDT.CDSS.TCMMedicine")||(type=15))	//中药字典
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.TCMMedicineI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.TCMMedicineD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.TCMMedicineD(DictID)),3)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.TCMDisease")||(type=16))	//中医诊断字典
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.TCMDiseaseI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.TCMDiseaseD(DictID)),3)		//知识库字典描述
		}
	}
	if ((type="CT.WDT.CDSS.TCMSymptom")||(type=17))	//中医证型字典
	{
		if (dictcode'="")
		{
			s DictID=$o(^CT.WDT.CDSS.TCMSymptomI("CodeIndex"," "_dictcode,0))
		}
		else
		{
			s DictID=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_dictdesc,0))
		}
		if (DictID'="")		//存在
		{
			s DictCode= $lg($g(^CT.WDT.CDSS.TCMSymptomD(DictID)),2)		//知识库字典代码
			s DictDesc= $lg($g(^CT.WDT.CDSS.TCMSymptomD(DictID)),3)		//知识库字典描述
		}
	}		
	if (alldataflag'="")	//输出全部信息，id+代码+描述
	{
		q DictID_"^"_DictCode_"^"_DictDesc
	}	
	else
	{
		q DictID
	}
}

/// Creator:胡宜良
/// CreatDate:2023-2-6
/// Description:分开已关联的数据为单条保存,并删除原数据
/// Table: CT.WDT.CDSS.ContrastDict 
/// Input:
/// Return:
/// Other:w ##class(web.CDSS.IMP.ContrastDict).Dataprocessing()
ClassMethod Dataprocessing()
{
	s result=""
	s ID=0
	TS
	for
	{
		s ID=$o(^CT.WDT.CDSS.ContrastDictD(ID))
		q:(ID="")||(result["false")
		s DictDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),10)
		s DictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),3)
		s DictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ID)),2)
		s total=$l(DictDR,",")
		if (total>1)  //如果对照数据中包含逗号，即原来的1对多的数据，则拆开存，再把这条原对照数据删掉
		{
			for m=1:1:total   //1对多的数据，拆开存
			{
				s name=$p(DictName,",",m)
				s code=$p(DictCode,",",m)
				s dr=$p(DictDR,",",m)
				s obj=##class(CT.WDT.CDSS.ContrastDict).%OpenId(ID)
				s bobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
				s bobj.DictCode= code		//知识库字典代码
				s bobj.DictName= name		//知识库字典描述		
				s bobj.ID = "" //ID
				s bobj.ContrastType= obj.ContrastType		//对照类型
				s bobj.ConDictCode=obj.ConDictCode		//对接方字典代码
				s bobj.ConDictName=obj.ConDictName		//对接方字典描述
				s bobj.State=obj.State		//状态（未关联/已关联/已确认/已删除）
				s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()	//医院
				s bobj.Remarks=obj.Remarks		//备注
				s bobj.DictDR=dr
				s bobj.IntDictDR=obj.IntDictDR
			
				s result= ..SaveEntity(bobj)
				if (result["false"){
					q
				}
				
			}
			if (result'["false")
			{
				s result=..DeleteData(ID)  //删掉原对照数据
			}
			
		}
	}
	if (result["false")
	{
		tro	
	}
	else
	{
		tc
		s result="true"
	}
	q result
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：空格处理方法1  去除前后空格
/// Input： Desc
/// Return：NewDesc
/// Other: w ##class(web.CDSS.IMP.ContrastDict).RemoveSpace()
ClassMethod RemoveSpace(Desc As %String)
{
	s NewDesc = $Zstrip(Desc,"<>W")
	q NewDesc
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：处理方法2  处理"(" 左括号前后空格
/// Input： Desc
/// Return：NewDesc/Desc
/// Other: w ##class(web.CDSS.IMP.ContrastDict).RemoveSpaceleft()
ClassMethod RemoveSpaceleft(Desc As %String)
{
    if (Desc["(")
    {
	    s leftStr= $p(Desc,"(",1)
	    s rightStr = $p(Desc,"(",2)
	    s leftStr= $Zstrip(leftStr,"<>W")
	    s rightStr = $Zstrip(rightStr,"<>W")
	    s NewDesc = leftStr_"("_rightStr
	    q NewDesc
	}
	else
	{
		q Desc
	}
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：处理方法3  处理")" 右括号前后空格
/// Input： Desc
/// Return：NewDesc/Desc
/// Other: w ##class(web.CDSS.IMP.ContrastDict).RemoveSpaceright()
ClassMethod RemoveSpaceright(Desc As %String)
{
	if (Desc[")")
    {
	    s leftStr= $p(Desc,")",1)
	    s rightStr = $p(Desc,")",2)
	    s leftStr= $Zstrip(leftStr,"<>W")
	    s rightStr = $Zstrip(rightStr,"<>W")
	    s NewDesc = leftStr_")"_rightStr
	    q NewDesc
	}
	else
	{
		q Desc
	}
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：处理方法4  删除"()"及"（）"其中内容
/// Input： Desc
/// Return：NewDesc
/// Other: w ##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside("多维片（7）")
ClassMethod RemoveBracketinside(Desc As %String)
{
	s NewDesc=Desc
	if (NewDesc["(")
    {
	    s leftStr= $p(NewDesc,"(",1)
	    s rightStr = $p(NewDesc,"(",2)
	    s rightStr1 = $p(rightStr,")",1)
	    s rightStr2 = $p(rightStr,")",2)
	    s NewDesc = leftStr_rightStr2
	}
	if (NewDesc["（")
    {
	    s leftStr= $p(NewDesc,"（",1)
	    s rightStr = $p(NewDesc,"（",2)
	    s rightStr1 = $p(rightStr,"）",1)
	    s rightStr2 = $p(rightStr,"）",2)
	    s NewDesc = leftStr_rightStr2
	}
	if (NewDesc["[")
    {
	    s leftStr= $p(NewDesc,"[",1)
	    s rightStr = $p(NewDesc,"[",2)
	    s rightStr1 = $p(rightStr,"]",1)
	    s rightStr2 = $p(rightStr,"]",2)
	    s NewDesc = leftStr_rightStr2
	}
	if (NewDesc["【")
    {
	    s leftStr= $p(NewDesc,"【",1)
	    s rightStr = $p(NewDesc,"【",2)
	    s rightStr1 = $p(rightStr,"】",1)
	    s rightStr2 = $p(rightStr,"】",2)
	    s NewDesc = leftStr_rightStr2
	}
	q NewDesc
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：处理方法5  删除"()"及"[]" "（）""【】"
/// Input： Desc
/// Return：NewDesc
/// Other: w ##class(web.CDSS.IMP.ContrastDict).RemoveBracket()
ClassMethod RemoveBracket(Desc As %String)
{
	s DictName=$Replace(Desc,"(","")
	s DictName=$Replace(DictName,")","")
	s DictName=$Replace(DictName,"[","")
	s DictName=$Replace(DictName,"]","")
	s DictName=$Replace(DictName,"（","")
	s DictName=$Replace(DictName,"）","")
	s DictName=$Replace(DictName,"【","")
	s DictName=$Replace(DictName,"】","")
	q DictName
}

/// w ##class(web.CDSS.IMP.ContrastDict).SpaceHandleMethod6("")
/// 处理方法6  遍历字符串根据ASCII获取英文内容    停用
ClassMethod SpaceHandleMethod6(Desc As %String)
{
	
	s i=0
	s str=""
	for
	{
		s i=i+1
		s asc=$A(Desc,i)
		q:(asc=-1)
		if ((asc>=65)&&(asc<=90)||(asc>=97)&&(asc<=112))
		{
			if (str="")
			{
				s str=$E(Desc,i)
			}
			else
			{
				s str=str_$E(Desc,i)
			}
		}	
	}
	q str
}

/// Creator：胡宜良 
/// CreatDate: 2023-02-24
/// Description：处理方法7  遍历字符串去除末尾数字    
/// Input： Desc
/// Return：str
/// Other: w ##class(web.CDSS.IMP.ContrastDict).RemoveEndDigits("abc11")
ClassMethod RemoveEndDigits(Desc As %String)
{
	
	s i=$l(Desc)
	s str=""
	for
	{
		s asc=$A(Desc,i)
		q:(asc=-1)

		if ((asc>=48)&&(asc<=57))
		{
			if (str="")
			{
				s str=$e(Desc,1,*-1)
			}
			else
			{
				s str=$e(str,1,*-1)
			}
		}
		else
		{
			q
		}
		s i=i-1	
	}
	q str
}

/// Creator：谷雪萍 
/// CreatDate: 2023-03-15
/// Description：在对照之前先处理项目数据的符号：去除空格；全角转半角；小括号-中文；逗号-中文；中括号-英文；去除<>及其中内容；去除%及前面数字	
/// Input： Desc
/// Return：DictNameNew-处理符号后的数据
/// Other: w ##class(web.CDSS.IMP.ContrastDict).DealBracketBeforeCon(" abc【】（）#11<aa>123% ")
ClassMethod DealBracketBeforeCon(Desc As %String)
{
	s DictNameNew=Desc									
	s DictNameNew=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(DictNameNew)   //去空格
	s DictNameNew=##class(web.CDSS.IMP.ContrastDict).RemoveSpaceleft(DictNameNew)   //去左括号空格
	s DictNameNew=##class(web.CDSS.IMP.ContrastDict).RemoveSpaceright(DictNameNew)  //去右括号空格
	s DictNameNew = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(DictNameNew,0)   	//全角转半角
	
	// 基础字典库名称符号统一：小括号-中文；逗号-中文；中括号-英文 ,把项目名称也处理成相同的符号再来匹配
	s DictNameNew=$Replace(DictNameNew,",","，")
	s DictNameNew=$Replace(DictNameNew,"(","（")
	s DictNameNew=$Replace(DictNameNew,")","）")
	s DictNameNew=$Replace(DictNameNew,"【","[")
	s DictNameNew=$Replace(DictNameNew,"】","]")
	s DictNameNew=$Replace(DictNameNew,"#","")
	if (DictNameNew["<")														//去除<>及其中内容
	{
		s leftStr= $p(DictNameNew,"<",1)
		s rightStr = $p(DictNameNew,"<",2)
		s rightStr1 = $p(rightStr,">",1)
		s rightStr2 = $p(rightStr,">",2)
		s DictNameNew = leftStr_rightStr2
	}
	if (DictNameNew["%")														//去除%及前面数字
	{
		s leftStr= $p(DictNameNew,"%",1)
		s leftStr1=##class(web.CDSS.IMP.ContrastDict).RemoveEndDigits(leftStr)
		s rightStr = $p(DictNameNew,"%",2)
		s DictNameNew = leftStr1_rightStr
	}
	q DictNameNew
}

/// Creator：胡宜良
/// CreatDate: 2023-4-24
/// Description：根据对接方字典描述和客户类型 获取知识库字典描述和知识库类型,若没有对照返回原名称类型
/// Table:CT.WDT.CDSS.ContrastDict 字典对照表
/// Input：desc ,type
/// Return：dictname,DictType
/// Other: w ##class(web.CDSS.IMP.ContrastDict).GetDiectNameType("血液透析","","其他")
ClassMethod GetDiectNameType(desc As %String, hosp As %String = "", type As %String) As %String
{
	s:hosp="" hosp= ##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")  //医院id
	q:((desc="")||(hosp="")) ""
	s typeid=""  //对接方字典分类表id 
	
	if (type'="")  //如果入参数据类型不为空
	{	
		//如果入参不是标准的类型名称,则单独处理
		s:typeid="" typeid=$case(type,"药品":"药品","手术":"手术","检查":"检查检验","检验项目":"检查检验","检验医嘱":"检查检验","护理":"护理","其他":"其他",:"")
	}
	s result=""
	s dictname="",DictType=""
	if (typeid="其他")||(typeid="")
	{
		s typeDR=""
		for 
		{
			s typeDR=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp,typeDR))
			q:typeDR=""			
			continue:typeDR="诊断"
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp,typeDR,desc,ID))
				q:ID=""
				s state=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态
				continue:((state="已删除")||(state="未关联"))
				s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
				s dictname=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),3)	//CDSS字典描述
				s ContrastType=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),4)
				s DictType=ContrastType
				if (ContrastType="检查检验")
				{
					continue:IntDictDR=""   //如果对接方字典ID为空，无法判断类型，则不输出
					s KnoType=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),4)  //知识库类型
					s DictType=KnoType
				}
				if (result="")
				{
					s result=dictname_"^"_DictType
				}
				else
				{
					if ((result["手术")&&(DictType="护理")) 
					{
						s result=dictname_"^"_DictType
						continue
					}
					s result=result_","_dictname_"^"_DictType

				}	
			}
		}
	}
	
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",hosp,typeid,desc,ID))
			q:ID=""
			s state=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),7)		//状态
			continue:((state="已删除")||(state="未关联"))
			s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),11)
			s dictname=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),3)	//CDSS字典描述	
			s ContrastType=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(ID)),4)
			s DictType=ContrastType

			if (ContrastType="检查检验")
			{
				continue:IntDictDR=""   //如果对接方字典ID为空，无法判断类型，则不输出
				s KnoType=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),4)  //知识库类型
				s DictType=KnoType
				s ConExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),17)  //项目类型
				if (ConExamType'="")  
				{
					continue:ConExamType'=type
				}
				else 
				{
					continue:KnoType'=type
				}
			}
			if (result="")
			{
				s result=dictname_"^"_DictType
			}
			else
			{
				s result=result_","_dictname_"^"_DictType
			}	
		}	
	}
	s:result="" result=desc_"^"_type  //没有对照返回原来的类型
	q result
}

/// test
/// d ##class(web.CDSS.IMP.ContrastDict).UPDATEmethod()
ClassMethod UPDATEmethod()
{
	//修改已确认
	&sql(UPDATE CT_WDT_CDSS.ConDrugDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31 )
	&sql(UPDATE CT_WDT_CDSS.ConCMDiseDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31)
	&sql(UPDATE CT_WDT_CDSS.ConDiseaseDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31)
	&sql(UPDATE CT_WDT_CDSS.ConExamDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31)
	&sql(UPDATE CT_WDT_CDSS.ConNurseDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31)
	&sql(UPDATE CT_WDT_CDSS.ConOperDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31)
	&sql(UPDATE CT_WDT_CDSS.ConOtherDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31)
	&sql(UPDATE CT_WDT_CDSS.ConTCMDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31)
	
	&sql(UPDATE CT_WDT_CDSS.ContrastDict  SET State=replace(State,"已关联","已确认") WHERE HospitalDR=31)
}

/// 检查检验异常数据处理
/// d ##class(web.CDSS.IMP.ContrastDict).ExamDataDeal()
ClassMethod ExamDataDeal()
{
	s result=""
	s MappingID=0,errordata=0,dealdata=0
	TS
	for
	{
		s MappingID=$o(^CT.WDT.CDSS.ContrastDictD(MappingID))
		q:MappingID="" 
		s state=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),7)		//状态
		continue:((state="已删除")||(state="未关联"))
		s IntDictDR=$LISTGET($G(^CT.WDT.CDSS.ContrastDictD(MappingID)),11)
		s ContrastType= $lg($g(^CT.WDT.CDSS.ContrastDictD(MappingID)),4)
		continue:(ContrastType'="检查检验")
		s Examstate=$lg($g(^CT.WDT.CDSS.ConExamDictD(IntDictDR)),10)
		 
		if (state="已关联")&(Examstate="未关联")
		{
			s errordata=errordata+1
			s result=##class(web.CDSS.IMP.ConExamDict).UpdateState(IntDictDR,"已关联")
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
