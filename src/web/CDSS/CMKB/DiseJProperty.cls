/// Description: 疾病属性表数据维护
/// Creator: 丁亚男
/// Date: 2020-12-25
Class web.CDSS.CMKB.DiseJProperty Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2020-12-25
/// Description:保存疾病属性表
/// Table: CT.WDT.CDSS.DiseJProperty
/// Input: eobj 疾病属性表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.DiseJProperty).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiseJProperty)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")
		{
			s eobj.RowId=$o(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",eobj.DiseaseDR,0))
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DiseJProperty).%New()	
			s eobj.Status="编辑中"
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DiseJProperty).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
			if $IsObject(obj.DiseaseDR)
			{
			 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
			}
			s bobj.SexLimit = obj.SexLimit
			s bobj.PopuSex = obj.PopuSex
			s bobj.AgeLimit= obj.AgeLimit
			s bobj.AgeLimitMin = obj.AgeLimitMin
			s bobj.AgeLimitMinUnit = obj.AgeLimitMinUnit
			s bobj.IsIncludeAgeLimitMin= obj.IsIncludeAgeLimitMin
			s bobj.AgeLimitMax = obj.AgeLimitMax
			s bobj.AgeLimitMaxUnit = obj.AgeLimitMaxUnit
			s bobj.IsIncludeAgeLimitMax= obj.IsIncludeAgeLimitMax
			s bobj.PopuAge = obj.PopuAge
			s bobj.PopuAgeMin = obj.PopuAgeMin
			s bobj.PopuAgeMinUnit = obj.PopuAgeMinUnit
			s bobj.IsIncludePopuAgeMin= obj.IsIncludePopuAgeMin
			s bobj.PopuAgeMax = obj.PopuAgeMax
			s bobj.PopuAgeMaxUnit = obj.PopuAgeMaxUnit
			s bobj.IsIncludePopuAgeMax= obj.IsIncludePopuAgeMax
			s bobj.CommonDept = obj.CommonDept
			s bobj.IsEmergency = obj.IsEmergency
			s bobj.PopuNation = obj.PopuNation
			s bobj.PopuRegion= obj.PopuRegion
			s bobj.Parts = obj.Parts
			s bobj.PopuSeasonMin = obj.PopuSeasonMin
			s bobj.PopuSeasonMax = obj.PopuSeasonMax
			s bobj.AppliVersion= obj.AppliVersion
			s bobj.Remarks= obj.Remarks
			s:bobj.Status="" eobj.Status="编辑中"
			
			s bobj.NumOfNConditions = obj.NumOfNConditions
			s bobj.AgeLimitMinDays = obj.AgeLimitMinDays
			s bobj.AgeLimitMaxDays = obj.AgeLimitMaxDays
			s bobj.PopuAgeMinDays= obj.PopuAgeMinDays
			s bobj.PopuAgeMaxDays= obj.PopuAgeMaxDays
			s bobj.UpdateDate= obj.UpdateDate
			s bobj.ResponUser= obj.ResponUser
		}
		
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		s obj.SexLimit = eobj.SexLimit
		s obj.PopuSex = eobj.PopuSex
		s obj.AgeLimit= eobj.AgeLimit
		s obj.AgeLimitMin = eobj.AgeLimitMin
		s obj.AgeLimitMinUnit = eobj.AgeLimitMinUnit
		if (eobj.IsIncludeAgeLimitMin="on" )||(eobj.IsIncludeAgeLimitMin="1" )
		{
			s eobj.IsIncludeAgeLimitMin=1
		}
		else 
		{
			s eobj.IsIncludeAgeLimitMin=0
		}
		s obj.IsIncludeAgeLimitMin= eobj.IsIncludeAgeLimitMin
		s obj.AgeLimitMax = eobj.AgeLimitMax
		s obj.AgeLimitMaxUnit = eobj.AgeLimitMaxUnit
		if (eobj.IsIncludeAgeLimitMax="on" )||(eobj.IsIncludeAgeLimitMax="1" )
		{
			s eobj.IsIncludeAgeLimitMax=1
		}
		else 
		{
			s eobj.IsIncludeAgeLimitMax=0
		}
		s obj.IsIncludeAgeLimitMax= eobj.IsIncludeAgeLimitMax
		s obj.PopuAge = eobj.PopuAge
		s obj.PopuAgeMin = eobj.PopuAgeMin
		s obj.PopuAgeMinUnit = eobj.PopuAgeMinUnit
		if (eobj.IsIncludePopuAgeMin="on" )||(eobj.IsIncludePopuAgeMin="1" )
		{
			s eobj.IsIncludePopuAgeMin=1
		}
		else 
		{
			s eobj.IsIncludePopuAgeMin=0
		}
		s obj.IsIncludePopuAgeMin= eobj.IsIncludePopuAgeMin
		
		s obj.PopuAgeMax = eobj.PopuAgeMax
		s obj.PopuAgeMaxUnit = eobj.PopuAgeMaxUnit
		if (eobj.IsIncludePopuAgeMax="on" )||(eobj.IsIncludePopuAgeMax="1" )
		{
			s eobj.IsIncludePopuAgeMax=1
		}
		else 
		{
			s eobj.IsIncludePopuAgeMax=0
		}
		s obj.IsIncludePopuAgeMax= eobj.IsIncludePopuAgeMax
		
		s obj.CommonDept = eobj.CommonDepts
		s obj.IsEmergency = eobj.IsEmergency
		s obj.PopuNation = eobj.PopuNation
		s obj.PopuRegion= eobj.PopuRegion
		s obj.Parts = eobj.Partss
		s obj.PopuSeasonMin = eobj.PopuSeasonMin
		s obj.PopuSeasonMax = eobj.PopuSeasonMax
		s obj.AppliVersion= eobj.AppliVersion
		s obj.Remarks= eobj.Remarks
		s:obj.ResponUser="" obj.ResponUser=eobj.OperationUser
		s obj.Status=eobj.Status
		s eobj.UpdateDate=$ZDATETIME($H,3)						//编辑时间
		s obj.UpdateDate=eobj.UpdateDate
		s obj.AgeLimitMinDays = ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(eobj.AgeLimitMin,eobj.AgeLimitMinUnit,eobj.IsIncludeAgeLimitMin,"min")
		s obj.AgeLimitMaxDays = ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(eobj.AgeLimitMax,eobj.AgeLimitMaxUnit,eobj.IsIncludeAgeLimitMax,"max")
		s obj.PopuAgeMinDays= ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(eobj.PopuAgeMin,eobj.PopuAgeMinUnit,eobj.IsIncludePopuAgeMin,"min")
		s obj.PopuAgeMaxDays= ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(eobj.PopuAgeMax,eobj.PopuAgeMaxUnit,eobj.IsIncludePopuAgeMax,"max")
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJProperty","CT.WDT.CDSS.DiseJProperty","疾病属性",id,eobj.DiseaseDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJProperty","CT.WDT.CDSS.DiseJProperty","疾病属性",eobj.RowId,eobj.DiseaseDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病属性","web.CDSS.CMKB.DiseJProperty","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病属性","web.CDSS.CMKB.DiseJProperty","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:通过id获取疾病属性内容
/// Table: CT.WDT.CDSS.DiseJProperty
/// Input: id 疾病属性id
/// Return: 疾病属性内容
/// others:w ##class(web.CDSS.CMKB.DiseJProperty).OpenData("1")
ClassMethod OpenData(DiseID As %String, id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
	if (id ="")
	{
		s id=$o(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseID,0))
	}
	if (id'="")
	{
		s obj=##class(CT.WDT.CDSS.DiseJProperty).%OpenId(id)
		s eobj.RowId=id
		if $IsObject(obj.DiseaseDR)
		{
		 	s eobj.DiseaseDR = obj.DiseaseDR.%Id()
		}
		s eobj.SexLimit = obj.SexLimit
		s eobj.PopuSex = obj.PopuSex
		s eobj.AgeLimit= obj.AgeLimit
		s eobj.AgeLimitMin = obj.AgeLimitMin
		s eobj.AgeLimitMinUnit = obj.AgeLimitMinUnit
		s eobj.IsIncludeAgeLimitMin= obj.IsIncludeAgeLimitMin
		s eobj.AgeLimitMax = obj.AgeLimitMax
		s eobj.AgeLimitMaxUnit = obj.AgeLimitMaxUnit
		s eobj.IsIncludeAgeLimitMax= obj.IsIncludeAgeLimitMax
		s eobj.PopuAge = obj.PopuAge
		s eobj.PopuAgeMin = obj.PopuAgeMin
		s eobj.PopuAgeMinUnit = obj.PopuAgeMinUnit
		s eobj.IsIncludePopuAgeMin= obj.IsIncludePopuAgeMin
		s eobj.PopuAgeMax = obj.PopuAgeMax
		s eobj.PopuAgeMaxUnit = obj.PopuAgeMaxUnit
		s eobj.IsIncludePopuAgeMax= obj.IsIncludePopuAgeMax
		/*s CommonDeptDRs = obj.CommonDept
		s CommonDept=""
	 	if (CommonDeptDRs'="")
	 	{
		 	s DeptLen=$L(CommonDeptDRs,",")
		 	for iDept=1:1:DeptLen
		 	{
			 	s DeptDR=$p(CommonDeptDRs,",",iDept)
			 	s:CommonDept'="" CommonDept=CommonDept_","_$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
			 	s:CommonDept="" CommonDept=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
			}
		}*/
		s eobj.CommonDept=obj.CommonDept	
		s eobj.IsEmergency = obj.IsEmergency
		s eobj.PopuNation = obj.PopuNation
		s eobj.PopuRegion= obj.PopuRegion
		/*s Parts = obj.Parts
		s Part=""
	 	if (Parts'="")
	 	{
		 	s PartLen=$L(Parts,",")
		 	for iPart=1:1:PartLen
		 	{
			 	s PartsDR=$p(Parts,",",iPart)
			 	s:Part'="" Part=Parts_","_$lg($g(^WDT.CDSS.BodyParDictD(DeptDR)),3)
			 	s:Part="" Part=$lg($g(^WDT.CDSS.BodyParDictD(DeptDR)),3)
			}
		}*/
		
		s eobj.Parts = obj.Parts
		s eobj.PopuSeasonMin = obj.PopuSeasonMin
		s eobj.PopuSeasonMax = obj.PopuSeasonMax
		s eobj.AppliVersion= obj.AppliVersion
		s eobj.Remarks= obj.Remarks
		d obj.%Close()
	}
	else
	{
		s eobj.SexLimit ="无"  //性别限制默认无
		s eobj.PopuSex = "无"  //高发性别默认无
		s eobj.AgeLimit= "0"   //年龄限制默认无
		s eobj.PopuAge = "0" //高发年龄默认无	
		s eobj.IsEmergency = "0"  //危急重症默认否
		s eobj.AppliVersion= "全部" //应用版本：默认全部
	}
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Input:DiseaseRowId 诊断ID Status 状态
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJProperty).ChangeStatus(182,"上线")
ClassMethod ChangeStatus(DiseaseRowId, Opreation, OperaUser)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
	if (Opreation="提交") s eobj.Status="待审核"
	if (Opreation="上线" )
	{
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
					if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(DiagFactorName,"U"))))
					{
						s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(DiagFactorName,"U"),0))
						s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
						if (WordsState'="已上线")
						{
							s:FactorName'="" FactorName=FactorName_","_DiagFactorName
							s:FactorName="" FactorName=DiagFactorName 
						}
					}
				}
			}
		 	
		}
		if (FactorName'="")	
		{
			return "{success:'false',errorinfo:'"_FactorName_"未完成拆分，不能上线！'}" 
		}
		else
		{
			s eobj.Status="已上线"
		}	
	}
	
	
	if Opreation="不通过" s eobj.Status="审核不通过"
	if Opreation="下线" s eobj.Status="已下线"
	s eobj.DiseaseDR=DiseaseRowId
	s eobj.ReviewUser=OperaUser
	s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),3)
	if ($d(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId)))
 	{
	 	s DiseJPropertyID=$O(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId,0))
	 	
	 	s obj=##class(CT.WDT.CDSS.DiseJProperty).%OpenId(DiseJPropertyID)
	 	s bobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
	 	if $IsObject(obj.DiseaseDR)
		{
		 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
		}
	 	s bobj.Status=obj.Status
	 	s bobj.ReviewUser=obj.ReviewUser
	 	s bobj.UpdateDate=obj.UpdateDate
	 	s obj.Status=eobj.Status
	 	s obj.ReviewUser=eobj.ReviewUser
	 	s obj.UpdateDate=$zdt($h,3)
	 	Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志 描述拼接操作，在日志中读取显示
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJProperty","CT.WDT.CDSS.DiseJProperty","疾病关联属性表",DiseJPropertyID,DiseaseName_"&&"_Opreation,"U",eobj,bobj)  
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联属性表","web.CDSS.CMKB.DiseJFactor","ChangeStatus",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.DiseJProperty).%New()
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
	 	s obj.Status=eobj.Status
	 	s obj.ReviewUser=eobj.ReviewUser
	 	s obj.UpdateDate=$zdt($h,3)
	 	Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJProperty","CT.WDT.CDSS.DiseJProperty","疾病关联属性表",id,DiseaseName,"A",eobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联属性表","web.CDSS.CMKB.DiseJFactor","ChangeStatus",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-12-28
/// Input:DiseaseRowId 诊断ID Status 状态
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJProperty).AddResponUser(8250,"Demo Group")
ClassMethod AddResponUser(DiseaseRowId, OpreationUser)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
	s eobj.DiseaseDR=DiseaseRowId
	s eobj.ResponUser=OpreationUser
	s eobj.UpdateDate=$ZDATETIME($H,3)						

	s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowId)),3)
	if ($d(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId)))
 	{
	 	s DiseJPropertyID=$O(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseRowId,0))
	 	s ResponUser=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),28)

	 	//if (ResponUser="")
	 	//{
		 	s obj=##class(CT.WDT.CDSS.DiseJProperty).%OpenId(DiseJPropertyID)
		 	s bobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
		 	if $IsObject(obj.DiseaseDR)
			{
			 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
			}
		 	s bobj.ResponUser=obj.ResponUser
		 	s bobj.UpdateDate=obj.UpdateDate
		 	s bobj.Status=obj.Status
		 	
		 	s obj.ResponUser=eobj.ResponUser
		 	//s obj.UpdateDate=$zdt($h,3)
			s obj.UpdateDate=eobj.UpdateDate
		 	s:bobj.Status="" obj.Status="编辑中"
		 	Ts
		 	s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				//保存日志
				//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("DHCDSSDiseJProperty","CT.WDT.CDSS.DiseJProperty","疾病关联属性表",DiseJPropertyID,DiseaseName,"U",eobj,bobj)
				
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联属性表","web.CDSS.CMKB.DiseJFactor","ChangeStatus",eobj)
		   		//s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
	 	//}
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.DiseJProperty).%New()
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
	 
	 	s obj.ResponUser=eobj.ResponUser
	 	s obj.UpdateDate=$zdt($h,3)
	 	s obj.Status="编辑中"
	 	Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("DHCDSSDiseJProperty","CT.WDT.CDSS.DiseJProperty","疾病关联属性表",id,DiseaseName,"A",eobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联属性表","web.CDSS.CMKB.DiseJFactor","ChangeStatus",eobj)
       		//s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-05-17
/// Description:把疾病关联属性导入知识库
/// Table:CT.WDT.CDSS.DiseJProperty
/// Input:FilePath-csv文件路径
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJProperty).ImportDiseJProperty("D:\cs.csv")
ClassMethod ImportDiseJProperty(FilePath)
{
	s file=##class(%File).%New(FilePath)
	s result=""
	d file.Open("RS")
	d file.ReadLine()
	
	while 'file.AtEnd
	{
		s str=file.ReadLine()
	    s DiseaseCode=$p(str,",",1)
	    s DiseaseCode=$Zstrip(DiseaseCode,"<>W")
	    
	    s DiseaseName=$p(str,",",2)
	    s DiseaseName=$Zstrip(DiseaseName,"<>W")
	    s DiseaseName=$tr(DiseaseName,"&","，")
	    
	    s DiseDRC=$o(^CT.WDT.CDSS.DiseaseDictI("CodeIndex"," "_$ZCONVERT(DiseaseCode,"U"),0))
		s DiseDRD=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		if (DiseDRC'=DiseDRD)||(DiseDRC="")
		{
			w !,DiseaseCode_"-"_DiseaseName_"编码名称不对应"
			continue
		}
	    s eobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
	    s eobj.DiseaseDR=DiseDRC
	    /*s SexLimit=$p(str,",",3)
	    s eobj.SexLimit = $case(SexLimit,"":"无",1:"女",2:"男")
		s PopuSex = $p(str,",",4)
		s eobj.PopuSex = $case(PopuSex,"":"无",1:"女",2:"男")
		
		s AgeLimit= $p(str,",",5)
		s eobj.AgeLimit= $case(AgeLimit,"":0,:AgeLimit)
		
		s eobj.AgeLimitMin = $p(str,",",6)
		s eobj.AgeLimitMinUnit = $p(str,",",7)
		s eobj.IsIncludeAgeLimitMin= $p(str,",",8)
		s eobj.AgeLimitMax = $p(str,",",9)
		s eobj.AgeLimitMaxUnit = $p(str,",",10)
		s eobj.IsIncludeAgeLimitMax= $p(str,",",11)
		s PopuAge =$p(str,",",12)
		s eobj.PopuAge = $case(PopuAge,"":0,:PopuAge)
		s eobj.PopuAgeMin = $p(str,",",13)
		s eobj.PopuAgeMinUnit = $p(str,",",14)
		s eobj.IsIncludePopuAgeMin= $p(str,",",15)
		s eobj.PopuAgeMax = $p(str,",",16)
		s eobj.PopuAgeMaxUnit = $p(str,",",17)
		s eobj.IsIncludePopuAgeMax= $p(str,",",18)*/
		s Deptstr=$p(str,",",3)
		//处理科室字符串
		s DeptDRstr=""
		s DeptLen=$l(Deptstr,"&")
		for iDept=1:1:DeptLen
		{
			s Dept=$p(Deptstr,"&",iDept)
			s DeptDR=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(Dept,"U"),0))
			if (DeptDR'="")
			{
				s:DeptDRstr'="" DeptDRstr=DeptDRstr_","_DeptDR
				s:DeptDRstr="" DeptDRstr=DeptDR
			}
		}
		s eobj.CommonDepts=DeptDRstr
		/*s IsEmergency = $p(str,",",20)
		s eobj.IsEmergency = $case(IsEmergency,"":0,:IsEmergency)
		s eobj.PopuNation = $p(str,",",23)
		
		s PopuRegion= $p(str,",",24)
		s PopuRegion=$tr(PopuRegion,"&",",")
		s eobj.PopuRegion= PopuRegion
		s eobj.Parts = $p(str,",",22)*/
		s result=..SaveData(eobj)
		if (result["false")&(result'["该记录已存在")
		{
			w !,DiseaseCode_"-"_DiseaseName_"没有导入成功"
		}
        k eobj
		
	}	
		
		
	q result
}

/// Creator:胡宜良
/// CreatDate:2023-04-04
/// Description：导入疾病关联科室
/// Table：CT.WDT.CDSS.DiseJProperty
/// Input：
/// Output：
/// Other: w ##class(web.CDSS.CMKB.DiseJProperty).ImportDataTXT("D:\cs.txt")
ClassMethod ImportDataTXT(path) As %String
{
	
	s savecount=0
	s nosavecount=0
	s linksavecount=0
	s updatecount=0
	s continuecount=0
	s timecontinuecount=0
	s id=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	
	s TheType=""
	s TheHosp=""
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
		
		s DiseaseCode= $p(data,$c(9),1)       //中药煎法编码
		s DiseaseName= $p(data,$c(9),2)       //中药煎法名称
		
		s DiseaseCode=$Zstrip(DiseaseCode,"<>W")
		s DiseaseName=$Zstrip(DiseaseName,"<>W")
	    s DiseaseName=$tr(DiseaseName,"&","，")
	    
	    s DiseDRC=$o(^CT.WDT.CDSS.DiseaseDictI("CodeIndex"," "_$ZCONVERT(DiseaseCode,"U"),0))
		s DiseDRD=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		if (DiseDRC'=DiseDRD)||(DiseDRC="")
		{
			w !,DiseaseCode_"-"_DiseaseName_"编码名称不对应"
			continue
		}
		s id=$o(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseDRC,0))
		
		s Deptstr= $p(data,$c(9),3)       //适用中药
	    s DeptDRstr=""
	    s DeptLen=$l(Deptstr,",")
		for iDept=1:1:DeptLen
		{
			s Dept=$p(Deptstr,",",iDept)
			s DeptDR=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(Dept,"U"),0))
			if (DeptDR'="")
			{
				s:DeptDRstr'="" DeptDRstr=DeptDRstr_","_DeptDR
				s:DeptDRstr="" DeptDRstr=DeptDR
			}
		}
		s eobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
		s eobj.RowId=id
		s eobj.DiseaseDR=DiseDRC
		
		s eobj.CommonDepts=DeptDRstr	
		if (id'="")
		{				
			s eobj.SexLimit=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),3)
			s eobj.PopuSex=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),4)
			s eobj.AgeLimit=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),5)
			s eobj.AgeLimitMin=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),6)
			s eobj.AgeLimitMinUnit=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),7)
			s eobj.IsIncludeAgeLimitMin=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),8)
			s eobj.AgeLimitMax=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),9)
			s eobj.AgeLimitMaxUnit=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),10)
			s eobj.IsIncludeAgeLimitMax=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),11)
			s eobj.PopuAge=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),12)
			s eobj.PopuAgeMin=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),13)
			s eobj.PopuAgeMinUnit=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),14)
			s eobj.IsIncludePopuAgeMin=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),15)
			s eobj.PopuAgeMax=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),16)
			s eobj.PopuAgeMaxUnit=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),17)
			s eobj.IsIncludePopuAgeMax=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),18)
			//s eobj.SexLimit=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),3)
			s eobj.IsEmergency=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),20)
			s eobj.PopuNation=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),21)
			s eobj.PopuRegion=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),22)
			s eobj.Parts=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),23)
			s eobj.PopuSeasonMin=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),24)
			s eobj.PopuSeasonMax=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),25)
			s eobj.AppliVersion=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),26)
			s eobj.UpdateDate=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),27)
			s eobj.ResponUser=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),28)
			s eobj.ReviewUser=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),29)
			s eobj.Status=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),30)
			
			s eobj.Remarks=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),31)
			s eobj.NumOfNConditions=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),32)
			s eobj.AgeLimitMinDays=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),33)
			s eobj.AgeLimitMaxDays=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),34)
			s eobj.PopuAgeMinDays=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),35)
			s eobj.PopuAgeMaxDays=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(id)),36)
		}
		s result=..SaveData(eobj)
		if ((result'["false"))
		{
			s savecount=savecount+1		
		}
		else
		{
			s nosavecount=nosavecount+1
		}
	}
	close file
    k file
	w "读取数据总共"_(num-1)_"条",!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	q "{success:'true'}"
}

/// Creator:丁亚男
/// CreatDate:2021-06-25
/// Description:把疾病关联属性表更新疾病关联诊断因子必要条件个数
/// Table:CT.WDT.CDSS.DiseJProperty
/// Input:疾病id
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJProperty).UpdateNumOfNConditions(DiseaseDR)
ClassMethod UpdateNumOfNConditions(DiseaseDR)
{
	
	s result=""
	s count=0
	s FactorRowId = 0
	for
	{
		s FactorRowId = $o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseDR,FactorRowId)) q:FactorRowId=""
		s IsNecessCondi= $lg($g(^CT.WDT.CDSS.DiseJFactorD(FactorRowId)),8)
		if (IsNecessCondi=1)
		{
			s count=count+1
		}
	}
	if ($d(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseDR)))
 	{
	 	s DiseJPropertyID=$O(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseDR,0))
		s obj=##class(CT.WDT.CDSS.DiseJProperty).%OpenId(DiseJPropertyID)
		s obj.NumOfNConditions=count
	 	Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.DiseJProperty).%New()
		d obj.DiseaseDRSetObjectId(DiseaseDR)
	 	s obj.NumOfNConditions=count
	 	s obj.UpdateDate=$zdt($h,3)
	 	s obj.Status="编辑中"
	 	Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
		}
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-06-25
/// Description:处理历史数据，疾病关联属性表更新疾病关联诊断因子必要条件个数
/// Table:CT.WDT.CDSS.DiseJProperty
/// Input:
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJProperty).UpdateHistoryData()
ClassMethod UpdateHistoryData()
{
	
	s result=""
	s count=0,falsecount=0
	s TotalNum=""
	for
	{
 		s TotalNum = $o(^CT.WDT.CDSS.DiseaseDictI("TotalIndex",TotalNum),-1) q:TotalNum=""	
		s DiseaseRowId=0
		for
		{
	 		s DiseaseRowId = $o(^CT.WDT.CDSS.DiseaseDictI("TotalIndex",TotalNum,DiseaseRowId)) q:DiseaseRowId=""
	 		s result=..UpdateNumOfNConditions(DiseaseRowId)
	 		if (result["true")
	 		{
		 		s count=count+1
		 	}
		 	else
		 	{
			 	s falsecount=falsecount+1
			}
		}
	}
	
	q "成功处理"_count_"条，失败"_falsecount_"条。"
}

/// Creator:丁亚男
/// CreatDate:2021-09-03
/// Description:处理历史数据，更新最大值最小值(天)
/// Table:CT.WDT.CDSS.DiseJProperty
/// Input:
/// Return:
/// Other:w ##class(web.CDSS.CMKB.DiseJProperty).UpdateHistoryDateData()
ClassMethod UpdateHistoryDateData()
{
	
	s result=""
	s count=0,falsecount=0
	s RowId=""
	for
	{
 		s RowId = $o(^CT.WDT.CDSS.DiseJPropertyD(RowId)) q:RowId=""
 		s obj=##class(CT.WDT.CDSS.DiseJProperty).%OpenId(RowId)
		s obj.AgeLimitMinDays = ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(obj.AgeLimitMin,obj.AgeLimitMinUnit,obj.IsIncludeAgeLimitMin,"min")
		s obj.AgeLimitMaxDays = ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(obj.AgeLimitMax,obj.AgeLimitMaxUnit,obj.IsIncludeAgeLimitMax,"max")
		s obj.PopuAgeMinDays= ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(obj.PopuAgeMin,obj.PopuAgeMinUnit,obj.IsIncludePopuAgeMin,"min")
		s obj.PopuAgeMaxDays= ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(obj.PopuAgeMax,obj.PopuAgeMaxUnit,obj.IsIncludePopuAgeMax,"max")
		Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s count=count+1
			
		}
		else
		{
			Trollback
			s falsecount=falsecount+1
		}		
		
	}
	
	q "成功处理"_count_"条，失败"_falsecount_"条。"
}

/// Creator：胡宜良
/// CreatDate: 2023-04-27
/// Description:删除疾病关联属性表内容
/// Table: CT.WDT.CDSS.DiseJProperty
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DiseJProperty).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.DiseJProperty).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
	if $IsObject(obj.DiseaseDR)
	{
	 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
	}
	s bobj.SexLimit = obj.SexLimit
	s bobj.PopuSex = obj.PopuSex
	s bobj.AgeLimit= obj.AgeLimit
	s bobj.AgeLimitMin = obj.AgeLimitMin
	s bobj.AgeLimitMinUnit = obj.AgeLimitMinUnit
	s bobj.IsIncludeAgeLimitMin= obj.IsIncludeAgeLimitMin
	s bobj.AgeLimitMax = obj.AgeLimitMax
	s bobj.AgeLimitMaxUnit = obj.AgeLimitMaxUnit
	s bobj.IsIncludeAgeLimitMax= obj.IsIncludeAgeLimitMax
	s bobj.PopuAge = obj.PopuAge
	s bobj.PopuAgeMin = obj.PopuAgeMin
	s bobj.PopuAgeMinUnit = obj.PopuAgeMinUnit
	s bobj.IsIncludePopuAgeMin= obj.IsIncludePopuAgeMin
	s bobj.PopuAgeMax = obj.PopuAgeMax
	s bobj.PopuAgeMaxUnit = obj.PopuAgeMaxUnit
	s bobj.IsIncludePopuAgeMax= obj.IsIncludePopuAgeMax
	s bobj.CommonDept = obj.CommonDept
	s bobj.IsEmergency = obj.IsEmergency
	s bobj.PopuNation = obj.PopuNation
	s bobj.PopuRegion= obj.PopuRegion
	s bobj.Parts = obj.Parts
	s bobj.PopuSeasonMin = obj.PopuSeasonMin
	s bobj.PopuSeasonMax = obj.PopuSeasonMax
	s bobj.AppliVersion= obj.AppliVersion
	s bobj.Remarks= obj.Remarks
	s bobj.Status= obj.Status
	
	s bobj.NumOfNConditions = obj.NumOfNConditions
	s bobj.AgeLimitMinDays = obj.AgeLimitMinDays
	s bobj.AgeLimitMaxDays = obj.AgeLimitMaxDays
	s bobj.PopuAgeMinDays= obj.PopuAgeMinDays
	s bobj.PopuAgeMaxDays= obj.PopuAgeMaxDays
			
	s sc=##class(CT.WDT.CDSS.DiseJProperty).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJProperty","CT.WDT.CDSS.DiseJProperty","疾病关联属性",id,bobj.DiseaseDR,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联属性","web.CDSS.CMKB.DiseJProperty","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
