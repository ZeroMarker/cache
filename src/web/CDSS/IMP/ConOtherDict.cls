/// 名称:实施综合管理平台-对接方其他字典表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-10-26
Class web.CDSS.IMP.ConOtherDict Extends %RegisteredObject
{

/// Creator：阚延新		
/// CreatDate: 2021-10-27
/// Description：查询 对接方检查检验字典的对照  
/// Table:CT.WDT.CDSS.ConOtherDict 对接方检查检验字典表
/// Input:id 稽查检验id,code 代码，drugdesc 描述，hospid 医院id，state 状态，，source 来源，dictdesc 知识库描述，remark 备注，sortmethod 排序方式
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.ConOtherDict","GetList","","","","12","","","","","","CreateTime")
Query GetList(id As %String, code As %String, desc As %String, type As %String, hospid As %String, state As %String, source As %String, dictdesc As %String, remark As %String, sortmethod As %String) As %Query(ROWSPEC = "RowID,Code,Name,Type,Source,HospitalDR,DictHospDesc,ConRemarks,DictID,DictCode,DictName,ConState,HospAreaDesc,HospitalAreaDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String, type As %String, hospid As %String, state As %String, source As %String, dictdesc As %String, remark As %String, sortmethod) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:dictdesc'="" dictdesc=$ZCONVERT(dictdesc,"U") //转换成大写
	
	//RowID,code,bloodName,bloodType,SpecimenCode,SpecimenName,Source,HospitalDR,DictHospDesc,Remarks,DictCode,DictName,ConState
	if (id'="") //根据rowid返回该条记录
	{
		s ID=id
				
		s Code= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),2)			//代码
		s Name= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),3)			//描述
		s Type=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),4)			//类型
		s:Type'="" TypeDesc=$lg($g(^CT.WDT.CDSS.ConClassDictD(Type)),3)
		s DictType=Type
		s Source=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),5)			//来源（住院/门诊/急诊）
		s DictHospDesc=""
		s HospitalDR=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),6)		//所属医院
		s:HospitalDR'="" DictHospDesc=$lg($g(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),7)			//备注 
		s State=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),8)			//状态（未关联/已关联/已确认/已删除）
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),9)		//创建时间（数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),10)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),11)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),12)		//修改人
		
		s HospAreaDR="",HospAreaDesc="",HospitalAreaDR=""
		for
		{
			s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",DictType,ID,HospAreaDR))
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
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,"输血品",ID,0))
		if (haveState'="")	//有对照数据
		{
			//走对照表，找对接的知识库id、代码、描述
			s ContrastState=""
			for
			{
				s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,DictType,ID,ContrastState))
				q:ContrastState=""
				
				s ConID=0
				for
				{
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,DictType,ID,ContrastState,ConID))
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
			s num=0
			s CreateTime=""
			for
			{
				s CreateTime=$o(^CT.WDT.CDSS.ConOtherDictI("CreateDateIndex",type,hospid,CreateTime),-1)
				q:CreateTime=""
				s ID=0
				for 
				{
					s ID=$o(^CT.WDT.CDSS.ConOtherDictI("CreateDateIndex",type,hospid,CreateTime,ID))
					q:ID=""
					s Code= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),2)		//代码
					s Name= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),3)		//通用名
					s length=$l(Name)
					s ^TempDataHandle("Short",length,ID)=ID
				}
			}
			
			s num=0
			s le=0
			for
			{
				s le=$o(^TempDataHandle("Short",le))
				q:le=""
				s OtherID=0
				for
				{
					s OtherID=$o(^TempDataHandle("Short",le,OtherID))
					q:OtherID=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=OtherID
				}
			}
		}
		
		elseif (sortmethod="UpdateTime")
		{
			s num=0
			s UpdateTime=""
			for
			{
				s UpdateTime=$o(^CT.WDT.CDSS.ConOtherDictI("UpdateDateIndex",type,hospid,UpdateTime),-1)
				q:UpdateTime=""
				s ID=0
				for
				{
					s ID=$o(^CT.WDT.CDSS.ConOtherDictI("UpdateDateIndex",type,hospid,UpdateTime,ID))
					q:ID=""
					s num=num+1
					s ^TempDataHandle("Handle",num)=ID
				}
			}
			

		}
		else //按创建日期排序
		{
			s num=0
			s CreateTime=""
			for
			{
				s CreateTime=$o(^CT.WDT.CDSS.ConOtherDictI("CreateDateIndex",type,hospid,CreateTime),-1)
				q:CreateTime=""
				s ID=0
				for 
				{
				s ID=$o(^CT.WDT.CDSS.ConOtherDictI("CreateDateIndex",type,hospid,CreateTime,ID))
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
			
			s Code= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),2)			//代码
			continue:((code'="")&&($ZCONVERT(Code,"U")'[code))
			s Name= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),3)			//描述
			continue:((desc'="")&&($ZCONVERT(Name,"U")'[desc))
			s Type=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),4)			//类型
			continue:((type'="")&&(Type'=type))
			s Source=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),5)			//来源（住院/门诊/急诊）
			continue:((source'="")&&(Source'=source))
			s DictHospDesc=""
			s HospitalDR=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),6)		//所属医院
			continue:((hospid'="")&&(HospitalDR'=hospid))
			s:HospitalDR'="" DictHospDesc=$lg($g(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
			s Remarks=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),7)			//备注 
			s State=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),8)			//状态（未关联/已关联/已确认/已删除）
			if (state="")	//默认不显示 已删除
			{
				continue:(State="已删除")
			}
			else
			{
				continue:(State'=state)
			}
			s CreateDate=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),9)		//创建时间（数据导入或者手动新增的时间）
			s CreateUser=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),10)		//创建人
			s UpdateDate=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),11)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
			s UpdateUser=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),12)		//修改人
			s DictType=$lg($g(^CT.WDT.CDSS.ConClassDictD(type)),3)	//分类
			s DictType=$p(DictType,"字典",1)
			s HospAreaDR="",HospAreaDesc="",HospitalAreaDR="",HospitalAreaDRStr=""
			for
			{
				s HospAreaDR=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",DictType,ID,HospAreaDR))
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
			s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,DictType,ID,0))
			s DictNameStr="",DictCodeStr="",DictIDStr="" //知识库描述串、知识库代码串、ID串
			s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注

			if (haveState'="")
			{
				//DictType
				s ContrastState=""
				for
				{
					s ContrastState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,DictType,ID,ContrastState))
					q:ContrastState=""
					
					s ConID=0
					for
					{
						s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,DictType,ID,ContrastState,ConID))
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
    set Data=$lb(RowID,Code,Name,Type,Source,HospitalDR,DictHospDesc,ConRemarks,DictID,DictCode,DictName,ConState,HospAreaDesc,HospitalAreaDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConListExecute ]
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

/// Creator:阚延新
/// CreatDate: 2021-10-28
/// Description：保存对接方其他字典表
/// Table:CT.WDT.CDSS.ConOtherDict 对接方其他字典表
/// Input: eobj As web.CDSSEntity.IMP.ConOtherDict
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConOtherDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.ConOtherDict, LogFlag As %String = "") As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.Source="" eobj.Source="住院"
		s:eobj.UpdateDate="" eobj.UpdateDate=$ZDATETIME($HOROLOG,3)
	    s:eobj.UpdateUser="" eobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
	    s:eobj.ProDictCode="" eobj.ProDictCode=..getFactorCode()	
		s flag=..FormValidate(eobj.RowID,eobj.ProDictCode,eobj.ProDictName,eobj.HospitalDR,eobj.ProDictType)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.ConOtherDict).%New()
	        s:eobj.CreateDate="" eobj.CreateDate=$ZDATETIME($HOROLOG,3)
	        s:eobj.CreateUser="" eobj.CreateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))
		}else	//修改
		{
			s obj=##class(CT.WDT.CDSS.ConOtherDict).%OpenId(eobj.RowID)
			s bobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
			s bobj.RowID = eobj.RowID
			s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id()		//医院
			s bobj.ProDictCode=obj.ProDictCode			
			s bobj.ProDictName=obj.ProDictName				
			s bobj.Source=obj.Source				
			s:obj.ProDictType'="" bobj.ProDictType = obj.ProDictType.%Id() 	//类型
			s bobj.Remarks=obj.Remarks			
			s bobj.State=obj.State				
			s bobj.CreateDate=obj.CreateDate				
			s bobj.CreateUser=obj.CreateUser					
			s bobj.UpdateDate=obj.UpdateDate				
			s bobj.UpdateUser=obj.UpdateUser
			s bobj.StartDate=obj.StartDate
			s bobj.EndDate=obj.EndDate
		}
		d:eobj.HospitalDR'="" obj.HospitalDRSetObjectId(eobj.HospitalDR)		//所属医院
		d:eobj.HospitalDR="" obj.HospitalDRSetObjectId("")	
		d:eobj.ProDictType'="" obj.ProDictTypeSetObjectId(eobj.ProDictType)		//所属类型
		d:eobj.ProDictType="" obj.ProDictTypeSetObjectId("")		
		s obj.ProDictCode=eobj.ProDictCode			
		s obj.ProDictName=eobj.ProDictName				
        s obj.Source=eobj.Source					  	
		s obj.Remarks=eobj.Remarks	//备注
		s obj.State=eobj.State		//状态（未关联/已关联/已确认/已删除）					
		s obj.CreateDate=eobj.CreateDate	
		s obj.CreateUser=eobj.CreateUser				
		s obj.UpdateDate=eobj.UpdateDate
		s obj.UpdateUser=eobj.UpdateUser
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
			if (eobj.RowID="")
			{
				s count= ..AutoMatch(eobj.HospitalDR,id,eobj.ProDictType)	//自动匹配	
				s count=$p(count,"'",4)
				s result = "{success:'true',id:'"_id_"',count:'"_count_"'}"	
				if (eobj.HospitalAreaDR'="")
				{
					s areatotal=$l(eobj.HospitalAreaDR,",")
					for areai=1:1:areatotal
					{
						s areaID=$p(eobj.HospitalAreaDR,",",areai)
						s resultx=##class(web.CDSS.IMP.ConDictConArea).SaveData("",eobj.ProDictType,id,areaID)
						if (resultx["false")
						{
							q
						}
					}
					//d ##class(web.CDSS.IMP.ConDictConArea).SaveData("",eobj.ProDictType,id,eobj.HospitalAreaDR)
				}
			}
			if (LogFlag="")
			{
			d:eobj.RowID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConOtherDict","CT.WDT.CDSS.ConOtherDict","对接方其他字典表",id,eobj.ProDictType_"-"_eobj.ProDictName,"A",eobj)
		    d:eobj.RowID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConOtherDict","CT.WDT.CDSS.ConOtherDict","对接方其他字典表",id,eobj.ProDictType_"-"_eobj.ProDictName,"U",eobj,bobj)
			}
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方其他字典表","web.CDSS.IMP.ConOtherDict","SaveEntity",eobj)
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
/// Table:CT.WDT.CDSS.ConOtherDict对接方其他对照表
/// Input：id
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).getFactorCode()
ClassMethod getFactorCode() As %String
{
    s dataid = $o(^CT.WDT.CDSS.ConOtherDictD(""),-1)
    s result=""
	if (dataid=""){
		s result=1
	}else{
		s result = dataid+1
	}
	q result
}

/// Creator:阚延新
/// CreatDate:2021-1-4
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.ConOtherDict 对接方其他字典表
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.ConOtherDict).FormValidate("","","","1")
ClassMethod FormValidate(id As %String, code As %String, name As %String, hosp As %String, type As %String) As %String
{
	s flag=""
	s flagc=""
	s:((hosp'="")&&(name'="")) flagc=$d(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",type,hosp,code,name))
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
		s:((hosp'="")&&(name'="")) idc=$o(^CT.WDT.CDSS.ConOtherDictI("HospCNIndex",type,hosp,code,name,0))
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

/// Creator：阚延新
/// CreatDate: 2020-12-29
/// Description：自动匹配
/// Table:CT.WDT.CDSS.ConOtherDict 对接方其他字典表
/// Input： hosp 医院id, id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).AutoMatch(31,"156511",7)
ClassMethod AutoMatch(hosp As %String, id As %String = "", type As %String)
{
	q:(hosp="") "{success:'false',errorinfo:'自动匹配失败，传入的医院为空！'}"
	q:(type="") "{success:'false',errorinfo:'自动匹配失败，传入的类型为空！'}"
	s result=""
	s linksavecount=0
	s unlinksavecount=0
	
	s DictType= $lg($g(^CT.WDT.CDSS.ConClassDictD(type)),3)		//分类
	s DictType=$p(DictType,"字典",1)
	//生成其他检索索引(名称或别名中包含括号或者-的数据处理后生成到一个临时global里，用于后面的匹配)
	if (type=7)
	{
		d ##class(web.CDSS.IMP.ConOtherDict).CreateFreIndex()
	}
	if (type=9)
	{
		d ##class(web.CDSS.IMP.ConOtherDict).CreateLabIndex()
	}
	if (type=10)
	{
		d ##class(web.CDSS.IMP.ConOtherDict).CreateUsageIndex()
	}
	if (type=11)
	{
		d ##class(web.CDSS.IMP.ConOtherDict).CreateUnitIndex()
	}
	if (type=12)
	{
		d ##class(web.CDSS.IMP.ConOtherDict).CreateDeptIndex()
	}
	if (type=14)
	{
		d ##class(web.CDSS.IMP.ConOtherDict).CreateBloodIndex()
	}
	//遍历所有未关联的其他
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConOtherDictI("HospStateIndex",type,hosp,"未关联",ID))
		q:ID=""
		
		continue:((id'="")&&(id'=ID))
		
		s TrastID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",DictType,ID,0)) //当前数据在对照表中的ID
		s DictCode= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),2)		//代码
		//s DictDesc= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),3)		
		s DictName=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),3)		//通用名		
		
		//0 从已确认数据中找名称相同的数据
		s OtherID=$o(^CT.WDT.CDSS.ConOtherDictI("StateDescIndex",type,"已确认",DictName,0))
		s ConIDFlag=0
		s:OtherID'="" ConIDFlag=$d(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",DictType,OtherID))
		if (ConIDFlag>0)  //如果有已确认的名称相同的数据，则跟该数据对照同样的知识库数据
		{
			s DictDRStr=""
			s ConID=0
			for
			{
				s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntDictDRIndex",DictType,OtherID,ConID))
				q:ConID=""
				s DictDR=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),10)  //对照的知识库字典ID
				s:DictDRStr'="" DictDRStr=DictDRStr_","
				s DictDRStr=DictDRStr_DictDR
				
			}
			//调用关联方法保存对照数据
			s result=..BatchMapping(ID,DictDRStr,"",1,type)
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
			//his名称处理符号：去除空格；全角转半角；小括号-中文；逗号-中文；中括号-英文；去除<>及其中内容；去除%及前面数字														
			s DictNameNew=##class(web.CDSS.IMP.ContrastDict).DealBracketBeforeCon(DictName)	  
			//1 his名称和知识库名和别名匹配
			
			s RowID=..FindDictIdByName(DictNameNew, type)
			
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
						//3 忽略对接方名称括号 "()"、"[]"、"（）"、"【】" 跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNoBracket, type)
					}
					//4 忽略知识库名称和别名中的括号"()"、"[]"、"（）"、"【】" 进行匹配
					if (type=7)
					{		
						if (RowID="")&($d(^TEMPCDSSCON("FreIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("FreIndex",1,$zconvert(DictNameNoBracket,"U"),0))
						}
					}
					if (type=9)
					{
						if (RowID="")&($d(^TEMPCDSSCON("LabIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabIndex",1,$zconvert(DictNameNoBracket,"U"),0))
						}
					}
					if (type=10)
					{
						if (RowID="")&($d(^TEMPCDSSCON("UsageIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("UsageIndex",1,$zconvert(DictNameNoBracket,"U"),0))
						}
					}
					if (type=11)
					{
						if (RowID="")&($d(^TEMPCDSSCON("UnitIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("UnitIndex",1,$zconvert(DictNameNoBracket,"U"),0))
						}
					}
					if (type=12)
					{
						if (RowID="")&($d(^TEMPCDSSCON("DeptIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("DeptIndex",1,$zconvert(DictNameNoBracket,"U"),0))
						}
					}
					if (type=14)
					{
						
						if (RowID="")&($d(^TEMPCDSSCON("BloodIndex",1))>0)
						{
							s RowID=$o(^TEMPCDSSCON("BloodIndex",1,$zconvert(DictNameNoBracket,"U"),0))
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
						//5 忽略对接方名称括号 "()"、"[]"、"（）"、"【】" 及内容跟知识库名称和别名匹配
						s RowID=..FindDictIdByName(DictNameNoBracketinside, type)
					}
					//6 忽略知识库名称和别名中的括号"()"、"[]"、"（）"、"【】"及内容 进行匹配
					if (type=7)
					{	
						if (RowID="")&($d(^TEMPCDSSCON("FreIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("FreIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
						}
					}
					if (type=9)
					{	
						if (RowID="")&($d(^TEMPCDSSCON("LabIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
						}
					}
					if (type=10)
					{	
						if (RowID="")&($d(^TEMPCDSSCON("UsageIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("UsageIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
						}
					}
					if (type=11)
					{	
						if (RowID="")&($d(^TEMPCDSSCON("UnitIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("UnitIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
						}
					}
					if (type=12)
					{	
						if (RowID="")&($d(^TEMPCDSSCON("DeptIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("DeptIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
						}
					}
					if (type=14)
					{	
						if (RowID="")&($d(^TEMPCDSSCON("BloodIndex",2))>0)
						{
							s RowID=$o(^TEMPCDSSCON("BloodIndex",2,$zconvert(DictNameNoBracketinside,"U"),0))
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
						s RowID=..FindDictIdByName(DictNameNOMinus, type)
					}
					//8 忽略知识库名称和别名中的 -  进行匹配
					if (type=7)
					{
						if (RowID="")&($d(^TEMPCDSSCON("FreIndex",3))>0)
						{
							
							s RowID=$o(^TEMPCDSSCON("FreIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
					if (type=9)
					{
						if (RowID="")&($d(^TEMPCDSSCON("LabIndex",3))>0)
						{
							s RowID=$o(^TEMPCDSSCON("LabIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
					if (type=10)
					{
						if (RowID="")&($d(^TEMPCDSSCON("UsageIndex",3))>0)
						{
							s RowID=$o(^TEMPCDSSCON("UsageIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
					if (type=11)
					{
						if (RowID="")&($d(^TEMPCDSSCON("UnitIndex",3))>0)
						{
							s RowID=$o(^TEMPCDSSCON("UnitIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
					if (type=12)
					{
						if (RowID="")&($d(^TEMPCDSSCON("DeptIndex",3))>0)
						{
							s RowID=$o(^TEMPCDSSCON("DeptIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
					if (type=14)
					{
						if (RowID="")&($d(^TEMPCDSSCON("BloodIndex",3))>0)
						{
							s RowID=$o(^TEMPCDSSCON("BloodIndex",3,$zconvert(DictNameNOMinus,"U"),0))
						}
					}
				}
			}
			if (RowID'="")
			{
				//调用关联方法保存对照数据
				s result=..BatchMapping(ID,RowID,"",1,type)
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
	k ^TEMPCDSSCON("FreIndex")
	k ^TEMPCDSSCON("LabIndex")
	k ^TEMPCDSSCON("UsageIndex")
	k ^TEMPCDSSCON("UnitIndex")
	k ^TEMPCDSSCON("DeptIndex")
	k ^TEMPCDSSCON("BloodIndex")

	q result
}

/// Creator:阚延新
/// CreatDate: 2020-12-30
/// Description：更改对接方其他字典表的状态
/// Table:CT.WDT.CDSS.ConOtherDict 对接方其他字典表
/// Input: id
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConOtherDict).UpdateState(id,"")
ClassMethod UpdateState(id, state) As %String
{
	s result=""
	s obj=##class(CT.WDT.CDSS.ConOtherDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
    s bobj.RowID = id
	s bobj.ProDictCode= obj.ProDictCode								//代码
	s bobj.ProDictName= obj.ProDictName								//名称
	s:obj.ProDictType'="" bobj.ProDictType = obj.ProDictType.%Id() 	//类型
	s bobj.Source=obj.Source										//来源（住院/门诊/急诊）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id() 	//所属医院
	s bobj.Remarks=obj.Remarks	                                	//备注
	s bobj.State=state		                                    	//状态（未关联/已关联/已确认/已删除）        
	s bobj.CreateDate=obj.CreateDate		                     	//创建时间（药品数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		                     	//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		             	//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser="dhcc" //$g(%session.Data("LOGON.USERNAME"))	//修改人	
	s result= ..SaveEntity(bobj)
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-12-28
/// Description：建立关联
/// Table:CT.WDT.CDSS.ConOtherDict
/// Input： hisid 项目其他id，dictid 其他知识库id，remark-备注
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).Mapping(1,7356,"")
ClassMethod Mapping(hisid As %String, dictid As %String, remark As %String = "", type As %String)
{
	q:(hisid="")||(dictid="") "false"  //项目其他id或东华其他id为空则输出错误信息
	s result=""
	s eobj = ##class(web.CDSSEntity.IMP.ContrastDict).%New()
	s eobj.ID = ""
	s eobj.ContrastType= type		//对照类型
	s eobj.ConDictCode=$lg($g(^CT.WDT.CDSS.ConOtherDictD(hisid)),2)	//对接方字典代码
	s eobj.ConDictName=$lg($g(^CT.WDT.CDSS.ConOtherDictD(hisid)),3)		//对接方字典描述
	s eobj.HospitalDR =$LISTGET($G(^CT.WDT.CDSS.ConOtherDictD(hisid)),6)	//医院
	s eobj.Remarks=remark		//备注	
	if (type="频率")
	{
		s eobj.DictCode=$lg($g(^CT.WDT.CDSS.FrequencyDictD(dictid)),2)
		s eobj.DictName=$lg($g(^CT.WDT.CDSS.FrequencyDictD(dictid)),3)
	}
	if (type="体征信息")
	{
		s eobj.DictCode=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(dictid)),3)
		s eobj.DictName=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(dictid)),4)
	}
	if (type="检验标本")
	{
		s eobj.DictCode= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(dictid)),2)
		s eobj.DictName= $lg($g(^CT.WDT.CDSS.LabSpecimenDictD(dictid)),3)	
	}
	if (type="用法")
	{
		s eobj.DictCode= $lg($g(^CT.WDT.CDSS.UsageDictD(dictid)),2)
		s eobj.DictName= $lg($g(^CT.WDT.CDSS.UsageDictD(dictid)),3)	
	}
	if (type="单位")
	{
		s eobj.DictCode= $lg($g(^CT.WDT.CDSS.UnitDictD(dictid)),2)
		s eobj.DictName= $lg($g(^CT.WDT.CDSS.UnitDictD(dictid)),3)	
	}
	if (type="科室")
	{
		s eobj.DictCode= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(dictid)),2)
		s eobj.DictName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(dictid)),3)	
	}
	if (type="输血品")
	{
		s eobj.DictCode=$lg($g(^CT.WDT.CDSS.BloodProductDictD(dictid)),3)
		s eobj.DictName=$lg($g(^CT.WDT.CDSS.BloodProductDictD(dictid)),4)
	}
			
	q:(eobj.ConDictCode="")||(eobj.ConDictName="")||(eobj.DictCode="")||(eobj.DictName="")||(eobj.HospitalDR="") "false"	//对照表中的必填字段有一个为空就输出错误信息，不能对照
	s eobj.State="已关联"		//状态（未关联/已关联/已确认/已删除）
	s eobj.DictDR=dictid       //知识库id
	s eobj.IntDictDR=hisid 		//对接方其他id	
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
/// Table:CT.WDT.CDSS.ConOtherDict
/// Input：HisID-项目其他字典id，DictIDStr 东华其他id串（用,分开），remark-备注，hospareaDR-院区id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).BatchMapping(250391,00001111,"测试名称1228111","胃散,乙醇","","101||14")
ClassMethod BatchMapping(HisID As %String, DictIDStr As %String, remark As %String, hospareaDR As %String, type As %String)
{
	q:(HisID="")||(DictIDStr)="" "{success:'false',errorinfo:'传入的项目数据id或者东华知识id为空！'}"
	s result=""
	s HospAreaDR=""
	s DictType= $lg($g(^CT.WDT.CDSS.ConClassDictD(type)),3)	//分类
	s DictType=$p(DictType,"字典",1)
	
	TS	
	//先删除原来的对照
	s flag=$o(^CT.WDT.CDSS.ContrastDictI("NameIndex",DictType,HisID,""))
	if ((flag'=""))
	{
		s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,DictType)
	}
	//s result=##class(web.CDSS.IMP.ContrastDict).CancelMapping(HisID,DictType)
	if (result'["false")
	{
		//再重新保存对照数据
		s DictTotal=$l(DictIDStr,",")
		for DictLen=1:1:DictTotal
		{
			s dictid=$p(DictIDStr,",",DictLen)
			s result=..Mapping(HisID,dictid,remark,DictType)
			if (result["false")
			{
				q
			}
		}
	}
	//把对接方其他字典的数据改为已关联的状态
	if (result'["false")
	{
		s result=..UpdateState(HisID,"已关联")
	}
	//保存对接方字典关联院区
	if (result'["false")&&((hospareaDR="")||(hospareaDR["||"))  //如果传入的院区为空 或是正确的格式才保存对接方字典关联院区 ，如果不是正确的格式则不需要处理该表数据
	{

		//找到这个其他字典关联的院区（有多个的用英文,拼接）
		s HospAreaDRStr=""
		s HospAreaID=0
		for
		{
			s HospAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",DictType,HisID,HospAreaID))
			q:HospAreaID=""
			s:HospAreaDRStr'="" HospAreaDRStr=HospAreaDRStr_","
			s HospAreaDRStr=HospAreaDRStr_HospAreaID
		}

		if (HospAreaDRStr'=hospareaDR)  //如果原来关联的院区和传入的院区数据不一致
		{
			s result=##class(web.CDSS.IMP.ConDictConArea).DelHospArea(DictType,HisID)  //先删除之前的关联院区
			//重新关联院区，否则对接方关联院区表会有冗余数据
			if (hospareaDR'="")&&(result'["false")
			{
				s areatotal=$l(hospareaDR,",")
				for areai=1:1:areatotal
				{
					s areaID=$p(hospareaDR,",",areai)
					s result=##class(web.CDSS.IMP.ConDictConArea).SaveData("",DictType,HisID,areaID)
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

/// Creator：阚延新
/// CreatDate: 2021-10-29
/// Description：导出当前的查询内容
/// Table:CT.WDT.CDSS.ConOtherDict 对接方其他字典表
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).ExportMapping("","","","","","","","")
ClassMethod ExportMapping(code As %String, name As %String, hospid As %String, type As %String, state As %String, source As %String, dhcname As %String, remark As %String)
{
	q:type="" ""
	s DictType=$lg($g(^CT.WDT.CDSS.ConClassDictD(type)),3)	//分类
	s DictType=$p(DictType,"字典",1)
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_DictType_"字典对照结果.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\IMP\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_DictType_"字典对照结果.txt"		
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
	
	w "来源	客户代码	客户名	东华名	状态	备注	类型	医院"

	
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s:dhcname'="" dhcname=$ZCONVERT(dhcname,"U") //转换成大写
	s:remark'="" remark=$ZCONVERT(remark,"U") //转换成大写
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.ConOtherDictD(ID))
		q:ID=""
		s Code= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),2)			//代码
		continue:((code'="")&&($ZCONVERT(Code,"U")'[code))
		s Name= $lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),3)			//描述
		continue:((name'="")&&($ZCONVERT(Name,"U")'[name))
		s Type=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),4)			//类型
		continue:((type'="")&&(Type'=type))
		s Source=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),5)			//来源（住院/门诊/急诊）
		continue:((source'="")&&(Source'=source))
		s DictHospDesc=""
		s HospitalDR=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),6)		//所属医院
		continue:((hospid'="")&&(HospitalDR'=hospid))
		s:HospitalDR'="" DictHospDesc=$lg($g(^CT.WDT.CDSS.CustomerHospD(HospitalDR)),3)
		s Remarks=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),7)			//备注 
		s State=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),8)			//状态（未关联/已关联/已确认/已删除）
		if (state="")	//默认不显示 已删除
		{
			continue:(State="已删除")
		}
		else
		{
			continue:(State'=state)
		}
		s CreateDate=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),9)		//创建时间（数据导入或者手动新增的时间）
		s CreateUser=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),10)		//创建人
		s UpdateDate=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),11)		//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s UpdateUser=$lg($g(^CT.WDT.CDSS.ConOtherDictD(ID)),12)		//修改人
		s haveState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,DictType,ID,0))
		s DictType=$lg($g(^CT.WDT.CDSS.ConClassDictD(type)),3)	//分类
		s DictType=$p(DictType,"字典",1)
		s HospAreaDR="",HospAreaDesc="",HospitalAreaDR="",HospitalAreaDRStr=""
		s RowID=ID,DictID="",DictCode= "",DictName= "",ConState=State,ConRemarks=""  //需要输出的字段：对接方字典id，知识库字典ID、代码、描述、对照状态（改为输出字典的状态）、对照备注
		
		if (haveState'="")
		{
			s ConState=""
			for
			{
				s ConState=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,DictType,ID,ConState))
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
					s ConID=$o(^CT.WDT.CDSS.ContrastDictI("IntStateIndex",HospitalDR,DictType,ID,ConState,ConID))
					q:ConID=""
					s RowID=ConID
					s DictCodes= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),2)		//知识库字典代码
					s DictNames= $lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),3)		//知识库字典描述
						
					s size=$l(DictCodes,",")
					for i=1:1:size
					{
    					s DictCode=$p(DictCodes,",",i)
    					s DictName=$p(DictNames,",",i)
						continue:((dhcname'="")&&($ZCONVERT(DictName,"U")'[dhcname)) 
						s ConDictCode=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),5)		//对接方字典代码
						s ConDictName=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),6)		//对接方字典描述
						s ConRemarks=$lg($g(^CT.WDT.CDSS.ContrastDictD(ConID)),9)		//备注
						continue:((remark'="")&&(ConRemarks'=remark))
						w !,Source_"	"_Code_"	"_Name_"	"_DictName_"	"_ConState_"	"_ConRemarks_"	"_DictType_"	"_DictHospDesc
					}
				}
			} 
		}
		else
		{
			w !,Source_"	"_Code_"	"_Name_"	"_DictName_"	"_ConState_"	"_ConRemarks_"	"_DictType_"	"_DictHospDesc
		}				
	}
	c file
	q fileName
}

/// Creator：阚延新
/// CreatDate: 2021-1-7
/// Description：获取最近一次新增数据时间
/// Table:CT.WDT.CDSS.ConOtherDict
/// Input： hospid 医院id
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).GetLastTime(hospid)
ClassMethod GetLastTime1(hosp, type)
{
	s lasttime=""	
	s CreateTime=0
	for
	{
		s CreateTime=$o(^CT.WDT.CDSS.ConOtherDictI("CreateDateIndex",type,hosp,CreateTime))
		q:CreateTime=""
		s lasttime=CreateTime
	}
	
	q lasttime
}

ClassMethod GetLastTime(hosp, type)
{
	s lasttime=""
	
	if ($d(^CT.WDT.CDSS.ConOtherDictI("CreateDateIndex",hosp,type)))
	{
		s lasttime=$o(^CT.WDT.CDSS.ConOtherDictI("CreateDateIndex",hosp,type,""),-1)
	}	
	q lasttime
}

/// Creator：阚延新
/// CreatDate: 2021-10-29
/// Description：批量导入对接方诊断
/// Table:User.DHCDSSConDiseaseDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).SaveImportData("22[next]肺结核(显微镜检证实)[next]A15.000x001[next]门诊[next][next]山大二院[next]")
ClassMethod SaveImportData(dataStr, hosp, type)
{
	q:(hosp=""||type="") "false"
	s result=""
	s dataStr=$tr(dataStr," ","")
	s dataStr=##class(web.DHCBL.BDP.FunLib).EvalJSONB(dataStr)		
	
	s OtherCode=$p(dataStr,"[next]",1)
	s:OtherCode="" OtherCode=..getFactorCode()
	s OtherName=$p(dataStr,"[next]",2)
	q:OtherName="" "false" 
	s Source=$p(dataStr,"[next]",3)
	s StartDate=$p(dataStr,"[next]",4)
	s EndDate=$p(dataStr,"[next]",5)
	s Remark=$p(dataStr,"[next]",6)
	//不限制医院和类型导入的相关代码
	/*s TypeDesc=$p(dataStr,"[next]",7)
	s:TypeDesc="" TypeDR=type
	s:TypeDesc'="" TypeDR=$o(^CT.WDT.CDSS.ConClassDictI("DescIndex"," "_$zconvert(TypeDesc,"U"),0))
	s HospitalDesc=$p(dataStr,"[next]",8) 
	s:HospitalDesc="" HospitalDR=hosp
	s:HospitalDesc'="" HospitalDR=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_$zconvert(HospitalDesc,"U"),0))
	q:TypeDR="" "false" 
	q:HospitalDR="" "false" */
	s bobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
	s bobj.RowID = ""
	s bobj.ProDictCode= OtherCode								//客户诊断代码
	s bobj.ProDictName= OtherName								//客户诊断名
	s bobj.ProDictType= type                                    //类型（除了药品、诊断、检验、检查、手术、护理以外的其他类型）
	s bobj.Source=Source										//来源（住院/门诊/急诊）
	s bobj.HospitalDR =hosp										//所属医院
	s bobj.State="未关联"										//状态（未关联/已关联/已确认/已删除）
	s bobj.Remarks=Remark
	s bobj.CreateDate=$ZDATETIME($HOROLOG,3)					//创建时间（药品数据导入或者手动新增的时间）
	s bobj.CreateUser=$g(%session.Data("LOGON.USERNAME"))		//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)					//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
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

/// Creator：阚延新
/// Description：根据TypeID返回字典表名称
/// Table:CT.WDT.CDSS.ConOtherDict对接方其他对照表
/// Input：id
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).getFactorDesc(id)
ClassMethod getFactorDesc(id) As %String
{
    s desc = $lg($g(^CT.WDT.CDSS.ConClassDictD(id)),3)
    s desc =$p(desc,"字典",1)

	q desc
}

/// Creator：阚延新
/// Description：根据TypeID返回字典表英文，DR，名称字段名
/// Table:CT.WDT.CDSS.ConOtherDict对接方其他对照表
/// Input：id
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).getFactorDr(id)
ClassMethod getFactorDr(id) As %String
{
	s:id="7" result="FrequencyDict,FrequencyDR,FrequencyName"
	s:id="9" result="LabSpecimenDict,LabSpecimenDR,SpecimenName"
	s:id="10" result="UsageDict,UsageDR,UsageName"
	s:id="11" result="UnitDict,UnitID,UnitDesc"
	s:id="12" result="DeptLevel,DeptDR,DeptName"
	s:id="14" result="BloodProductDictDetail,BPDR,BPName"
	s:id="15" result="TCMMedicine,MedicineDR,MedicineName"
	s:id="16" result="TCMDisease,TCMDiseDR,DiseaseName"
	s:id="17" result="TCMSymptom,TCMSympDR,SymptomName"
	q result
}

/// Creator:胡宜良
/// CreatDate: 2023-02-23
/// Description：删除关联，将状态改已删除
/// Table:CT.WDT.CDSS.ConOtherDict 对接方其他对照表
/// Input: id，remark 备注
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConOtherDict).DelMapping()
ClassMethod DelMapping(id, remark)
{
	q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	s obj=##class(CT.WDT.CDSS.ConOtherDict).%OpenId(id)
		
	s bobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
	 s bobj.RowID = id
	s bobj.ProDictCode= obj.ProDictCode								//代码
	s bobj.ProDictName= obj.ProDictName								//名称
	s:obj.ProDictType'="" bobj.ProDictType = obj.ProDictType.%Id() 	//类型
	s bobj.Source=obj.Source										//来源（住院/门诊/急诊）
	s:obj.HospitalDR'="" bobj.HospitalDR = obj.HospitalDR.%Id() 	//所属医院
	s bobj.Remarks=remark	                                	//备注
	s bobj.State="已删除"		                                    	//状态（未关联/已关联/已确认/已删除）        
	s bobj.CreateDate=obj.CreateDate		                     	//创建时间（药品数据导入或者手动新增的时间）
	s bobj.CreateUser=obj.CreateUser		                     	//创建人
	s bobj.UpdateDate=$ZDATETIME($HOROLOG,3)		             	//修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
	s bobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))	//修改人	
	d obj.%Close()
	
	s result=..SaveEntity(bobj)		
			
	q result
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("FreIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConOtherDict).CreateFreIndex()
ClassMethod CreateFreIndex()
{
	k ^TEMPCDSSCON("FreIndex")
	s OtherID=0
	for 
	{
		s OtherID=$o(^CT.WDT.CDSS.FrequencyDictD(OtherID))
		q:OtherID=""
		s state=$lg($g(^CT.WDT.CDSS.FrequencyDictD(OtherID)),5)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.FrequencyDictD(OtherID)),3)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("FreIndex",1,NewName,OtherID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("FreIndex",2,NewName,OtherID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("FreIndex",3,NewName,OtherID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.FrequencyDictD(OtherID)),9)	
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
					s ^TEMPCDSSCON("FreIndex",1,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("FreIndex",2,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("FreIndex",3,NewAliasDesc,OtherID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成其他检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("LabIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConOtherDict).CreateLabIndex()
ClassMethod CreateLabIndex()
{
	k ^TEMPCDSSCON("LabIndex")
	s OtherID=0
	for 
	{
		s OtherID=$o(^CT.WDT.CDSS.LabSpecimenDictD(OtherID))
		q:OtherID=""
		s state=$lg($g(^CT.WDT.CDSS.LabSpecimenDictD(OtherID)),6)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.LabSpecimenDictD(OtherID)),3)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabIndex",1,NewName,OtherID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabIndex",2,NewName,OtherID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("LabIndex",3,NewName,OtherID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.LabSpecimenDictD(OtherID)),14)	
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
					s ^TEMPCDSSCON("LabIndex",1,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("LabIndex",2,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("LabIndex",3,NewAliasDesc,OtherID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("UsageIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConOtherDict).CreateUsageIndex()
ClassMethod CreateUsageIndex()
{
	k ^TEMPCDSSCON("UsageIndex")
	s OtherID=0
	for 
	{
		s OtherID=$o(^CT.WDT.CDSS.UsageDictD(OtherID))
		q:OtherID=""
		s state=$lg($g(^CT.WDT.CDSS.UsageDictD(OtherID)),5)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.UsageDictD(OtherID)),3)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("UsageIndex",1,NewName,OtherID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("UsageIndex",2,NewName,OtherID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("UsageIndex",3,NewName,OtherID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.UsageDictD(OtherID)),9)	
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
					s ^TEMPCDSSCON("UsageIndex",1,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("UsageIndex",2,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("UsageIndex",3,NewAliasDesc,OtherID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("UnitIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConOtherDict).CreateUnitIndex()
ClassMethod CreateUnitIndex()
{
	k ^TEMPCDSSCON("UnitIndex")
	s OtherID=0
	for 
	{
		s OtherID=$o(^CT.WDT.CDSS.UnitDictD(OtherID))
		q:OtherID=""
		s state=$lg($g(^CT.WDT.CDSS.UnitDictD(OtherID)),4)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.UnitDictD(OtherID)),3)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("UnitIndex",1,NewName,OtherID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("UnitIndex",2,NewName,OtherID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("UnitIndex",3,NewName,OtherID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.UnitDictD(OtherID)),8)	
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
					s ^TEMPCDSSCON("UnitIndex",1,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("UnitIndex",2,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("UnitIndex",3,NewAliasDesc,OtherID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("DeptIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConOtherDict).CreateDeptIndex()
ClassMethod CreateDeptIndex()
{
	k ^TEMPCDSSCON("DeptIndex")
	s OtherID=0
	for 
	{
		s OtherID=$o(^CT.WDT.CDSS.DiseaseDeptDictD(OtherID))
		q:OtherID=""
		s state=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(OtherID)),7)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(OtherID)),3)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("DeptIndex",1,NewName,OtherID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("DeptIndex",2,NewName,OtherID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("DeptIndex",3,NewName,OtherID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(OtherID)),11)	
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
					s ^TEMPCDSSCON("DeptIndex",1,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("DeptIndex",2,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("DeptIndex",3,NewAliasDesc,OtherID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-15
/// Description：生成检索索引(名称或别名中包含括号或者-的)  ^TEMPCDSSCON("BloodIndex") 
/// Input： 
/// Return：""
/// w ##class(web.CDSS.IMP.ConOtherDict).CreateBloodIndex()
ClassMethod CreateBloodIndex()
{
	k ^TEMPCDSSCON("BloodIndex")
	s OtherID=0
	for 
	{
		s OtherID=$o(^CT.WDT.CDSS.BloodProductDictD(OtherID))
		q:OtherID=""
		s state=$lg($g(^CT.WDT.CDSS.BloodProductDictD(OtherID)),22)  
		continue:(state'=2)  //知识库数据不是已审核状态则跳过
		s Name=$lg($g(^CT.WDT.CDSS.BloodProductDictD(OtherID)),4)
		s Name=##class(web.CDSS.IMP.ContrastDict).RemoveSpace(Name)
		s Name=$zconvert(Name,"U")
		continue:Name=""
		
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracket(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("BloodIndex",1,NewName,OtherID)=""
		}
		s NewName=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(Name)
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("BloodIndex",2,NewName,OtherID)=""
		}
		s NewName=$Replace(Name,"-","")
		if (NewName'="")&&(NewName'=Name)
		{
			s ^TEMPCDSSCON("BloodIndex",3,NewName,OtherID)=""
		}
		s AliasName=$lg($g(^CT.WDT.CDSS.BloodProductDictD(OtherID)),24)	
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
					s ^TEMPCDSSCON("BloodIndex",1,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=##class(web.CDSS.IMP.ContrastDict).RemoveBracketinside(AliasDesc)
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("BloodIndex",2,NewAliasDesc,OtherID)=""
				}
				s NewAliasDesc=$Replace(AliasDesc,"-","")
				if (NewAliasDesc'="")&&(NewAliasDesc'=AliasDesc)
				{
					s ^TEMPCDSSCON("BloodIndex",3,NewAliasDesc,OtherID)=""
				}
			}
		}
	}
	q ""
}

/// Creator：胡宜良
/// CreatDate: 2023-03-14
/// Description：通过名称找知识库字典ID
/// Table:CT.WDT.CDSS.Alias
/// Input： DictName-其他名称
/// Return：RowID—其他字典ID
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).FindDictIdByName("g",11)
ClassMethod FindDictIdByName(DictName, type)
{
	q:DictName="" ""
	if (type=7)
	{
		s RowID=$o(^CT.WDT.CDSS.FrequencyDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.FrequencyDictD(RowID)),5)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.FrequencyDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.FrequencyDictD(RowID)),5)
				s:flag'=2 RowID=""
			}
				
		}
	}
	if (type=9)
	{
		s RowID=$o(^CT.WDT.CDSS.LabSpecimenDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.LabSpecimenDictD(RowID)),6)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.LabSpecimenDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.LabSpecimenDictD(RowID)),6)
				s:flag'=2 RowID=""
			}
				
		}
	}
	if (type=10)
	{
		s RowID=$o(^CT.WDT.CDSS.UsageDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.UsageDictD(RowID)),5)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.UsageDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.UsageDictD(RowID)),5)
				s:flag'=2 RowID=""
			}
				
		}
	}
	if (type=11)
	{
		s RowID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.UnitDictD(RowID)),4)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.UnitDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.UnitDictD(RowID)),4)
				s:flag'=2 RowID=""
			}
				
		}
	}
	if (type=12)
	{
		s RowID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowID)),7)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DiseaseDeptDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowID)),7)
				s:flag'=2 RowID=""
			}
				
		}
	}
	if (type=14)
	{
		s RowID=$o(^CT.WDT.CDSS.BloodProductDictI("NameIndex"," "_$zconvert(DictName,"U"),0)) 	 //通过名称匹配		
		if (RowID'="")	//判断是否已审核
		{
			s flag=$lg($g(^CT.WDT.CDSS.BloodProductDictD(RowID)),22)
			s:flag'=2 RowID=""
		}
		if (RowID="")
		{
			s RowID=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.BloodProductDict"," "_$zconvert(DictName,"U"),0)) //通过别名匹配
			if (RowID'="") //判断是否已审核
			{
				s flag=$lg($g(^CT.WDT.CDSS.BloodProductDictD(RowID)),22)
				s:flag'=2 RowID=""
			}
				
		}
	}
	
	q RowID
}

/// Creator：胡宜良	
/// CreatDate: 2023-04-03
/// Description：删除 对接方其他字典表未关联数据
/// Table:CT.WDT.CDSS.ConOtherDict 对接方其他字典表未关联数据
/// Input：hosp 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.ConOtherDict).DeleteUnlinkedData(31,9)
ClassMethod DeleteUnlinkedData(hosp As %String, type As %String) As %String
{
	s result="" 
	s id=0 
	for
	{
		s id=$o(^CT.WDT.CDSS.ConOtherDictI("HospStateIndex",type,hosp,"未关联",id))
		q:id=""
			
		s pobj = ##class(CT.WDT.CDSS.ConOtherDict).%OpenId(id)
		s eobj = ##class(web.CDSSEntity.IMP.ConOtherDict).%New()
		
		s eobj.ProDictCode= pobj.ProDictCode							//代码
		s eobj.ProDictName= pobj.ProDictName							//名称
		s:pobj.ProDictType'="" eobj.ProDictType = pobj.ProDictType.%Id() //所属医院
		s eobj.Source=pobj.Source									//来源（住院/门诊/急诊）
		s:pobj.HospitalDR'="" eobj.HospitalDR = pobj.HospitalDR.%Id() //所属医院
		s eobj.Remarks=pobj.Remarks	                                //备注
		s eobj.State=pobj.State		                                    //状态（未关联/已关联/已确认/已删除）
		s eobj.CreateDate=pobj.CreateDate		                     //创建时间（诊断数据导入或者手动新增的时间）
		s eobj.CreateUser=pobj.CreateUser		                     //创建人
		s eobj.UpdateDate=pobj.UpdateDate		             //修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
		s eobj.UpdateUser=pobj.UpdateUser		 //修改人
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(CT.WDT.CDSS.ConOtherDict).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ConOtherDict","CT.WDT.CDSS.ConOtherDict","对接方其他字典表",id,eobj.HospitalDR_"-"_eobj.ProDictCode_"-"_eobj.ProDictName,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("对接方其他字典表","web.CDSS.IMP.ConOtherDict","DeleteUnlinkedData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

}
