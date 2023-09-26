/// Description: 中医疾病关联属性表数据维护
/// Creator: 胡宜良
/// Date: 2022-02-10
Class web.CDSS.CMKB.TCMDiseJProperty Extends %RegisteredObject
{

/// Creator:胡宜良
/// CreatDate:2022-02-10
/// Description:保存中医疾病关联属性表
/// Table: CT.WDT.CDSS.TCMDiseJProperty
/// Input: eobj 疾病属性表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.TCMDiseJProperty).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.TCMDiseJProperty)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")
		{
			s eobj.RowId=$o(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",eobj.TCMDiseDR,0))
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%New()	
			s eobj.Status="编辑中"
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJProperty).%New()
			if $IsObject(obj.TCMDiseDR)
			{
			 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
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
		}
		
		d:eobj.TCMDiseDR'="" obj.TCMDiseDRSetObjectId(eobj.TCMDiseDR)
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
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJProperty","CT.WDT.CDSS.TCMDiseJProperty","中医疾病属性",id,eobj.TCMDiseDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJProperty","CT.WDT.CDSS.TCMDiseJProperty","中医疾病属性",eobj.RowId,eobj.TCMDiseDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病属性","web.CDSS.CMKB.TCMDiseJProperty","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病属性","web.CDSS.CMKB.TCMDiseJProperty","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:胡宜良
/// CreatDate:2022-02-10
/// Description:通过id获取中医疾病属性内容
/// Table: CT.WDT.CDSS.TCMDiseJProperty
/// Input: id 中医疾病属性id
/// Return: 中医疾病属性内容
/// others:w ##class(web.CDSS.CMKB.TCMDiseJProperty).OpenData("1")
ClassMethod OpenData(DiseID As %String, id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJProperty).%New()
	if (id ="")
	{
		s id=$o(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseID,0))
	}
	if (id'="")
	{
		s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%OpenId(id)
		s eobj.RowId=id
		if $IsObject(obj.TCMDiseDR)
		{
		 	s eobj.TCMDiseDR = obj.TCMDiseDR.%Id()
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
			 	s:Part'="" Part=Parts_","_$lg($g(^User.DHCDSSBodyParDictD(DeptDR)),3)
			 	s:Part="" Part=$lg($g(^User.DHCDSSBodyParDictD(DeptDR)),3)
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

/// Creator:胡宜良
/// CreatDate:2022-02-10
/// Input:DiseaseRowId 诊断ID Status 状态
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJProperty).ChangeStatus(1,"上线","","")
ClassMethod ChangeStatus(DiseaseRowId, Opreation, OperaUser)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJProperty).%New()
	if (Opreation="提交") s eobj.Status="待审核"
	if (Opreation="上线" )
	{
		s WordsName=""
		if ($d(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DiseaseRowId)))
	 	{
		 	s DiseSymJWords=0
		 	for 
		 	{
			 	s DiseSymJWords=$O(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DiseaseRowId,DiseSymJWords)) q:DiseSymJWords=""
			 	s WordDR=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DiseSymJWords)),3)
			 	if (WordDR'="")
			 	{
				 	s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
					if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(WordsDesc,"U"))))
					{
						s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(WordsDesc,"U"),0))
						s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
						if (WordsState'="已上线")
						{
							s:WordsName'="" WordsName=WordsName_","_WordsDesc
							s:WordsName="" WordsName=WordsDesc 
						}
					}
				}
			}
		 	
		}
		if (WordsName'="")	
		{
			return "{success:'false',errorinfo:'"_WordsName_"未完成拆分，不能上线！'}" 
		}
		else
		{
			s eobj.Status="已上线"
		}	
	}
	
	
	if Opreation="不通过" s eobj.Status="审核不通过"
	if Opreation="下线" s eobj.Status="已下线"
	s eobj.TCMDiseDR=DiseaseRowId
	s eobj.ReviewUser=OperaUser
	s DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),3)
	if ($d(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId)))
 	{
	 	s TCMDiseJPropertyID=$O(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId,0))
	 	
	 	s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%OpenId(TCMDiseJPropertyID)
	 	s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJProperty).%New()
	 	if $IsObject(obj.TCMDiseDR)
		{
		 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
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
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJProperty","CT.WDT.CDSS.TCMDiseJProperty","中医疾病关联属性表",TCMDiseJPropertyID,DiseaseName_"&&"_Opreation,"U",eobj,bobj)  
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联属性表","web.CDSS.CMKB.TCMDiseJProperty","ChangeStatus",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%New()
		d:eobj.TCMDiseDR'="" obj.TCMDiseDRSetObjectId(eobj.TCMDiseDR)
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
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJProperty","CT.WDT.CDSS.TCMDiseJProperty","中医疾病关联属性表",id,DiseaseName,"A",eobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联属性表","web.CDSS.CMKB.TCMDiseJProperty","ChangeStatus",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2022-02-10
/// Input:DiseaseRowId 诊断ID Status 状态
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJProperty).ChangeStatus("","上线")
ClassMethod AddResponUser(DiseaseRowId, OpreationUser)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJProperty).%New()
	s eobj.TCMDiseDR=DiseaseRowId
	s eobj.ResponUser=OpreationUser
	s DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),3)
	if ($d(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId)))
 	{
	 	s TCMDiseJPropertyID=$O(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseRowId,0))
	 	s ResponUser=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(TCMDiseJPropertyID)),28)
	 	if (ResponUser="")
	 	{
		 	s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%OpenId(TCMDiseJPropertyID)
		 	s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJProperty).%New()
		 	if $IsObject(obj.TCMDiseDR)
			{
			 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
			}
		 	s bobj.ResponUser=obj.ResponUser
		 	s bobj.UpdateDate=obj.UpdateDate
		 	s bobj.Status=obj.Status
		 	
		 	s obj.ResponUser=eobj.ResponUser
		 	s obj.UpdateDate=$zdt($h,3)
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
				//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJProperty","CT.WDT.CDSS.TCMDiseJProperty","中医疾病关联属性表",TCMDiseJPropertyID,DiseaseName,"U",eobj,bobj)
				
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联属性表","web.CDSS.CMKB.TCMDiseJProperty","ChangeStatus",eobj)
		   		//s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
	 	}
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%New()
		d:eobj.TCMDiseDR'="" obj.TCMDiseDRSetObjectId(eobj.TCMDiseDR)
	 
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
			//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJProperty","CT.WDT.CDSS.TCMDiseJProperty","疾病关联属性表",id,DiseaseName,"A",eobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联属性表","web.CDSS.CMKB.TCMDiseJProperty","ChangeStatus",eobj)
       		//s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2022-02-10
/// Description:把中医疾病关联属性导入知识库
/// Table:CT.WDT.CDSS.TCMDiseJProperty
/// Input:FilePath-csv文件路径
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJProperty).ImportTCMDiseJProperty("F:\基础数据平台文档\CDSS\中医疾病基本信息汇总0518.csv")
ClassMethod ImportTCMDiseJProperty(FilePath)
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
	    
	    s DiseDRC=$o(^CT.WDT.CDSS.TCMDiseaseI("CodeIndex"," "_$ZCONVERT(DiseaseCode,"U"),0))
		s DiseDRD=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		if (DiseDRC'=DiseDRD)||(DiseDRC="")
		{
			w !,DiseaseCode_"-"_DiseaseName_"编码名称不对应"
			continue
		}
	    s eobj = ##class(web.CDSSEntity.CMKB.DiseJProperty).%New()
	    s eobj.TCMDiseDR=DiseDRC
	    s SexLimit=$p(str,",",3)
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
		s eobj.IsIncludePopuAgeMax= $p(str,",",18)
		s Deptstr=$p(str,",",19)
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
		s IsEmergency = $p(str,",",20)
		s eobj.IsEmergency = $case(IsEmergency,"":0,:IsEmergency)
		s eobj.PopuNation = $p(str,",",23)
		
		s PopuRegion= $p(str,",",24)
		s PopuRegion=$tr(PopuRegion,"&",",")
		s eobj.PopuRegion= PopuRegion
		s eobj.Parts = $p(str,",",22)
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
/// CreatDate:2022-02-10
/// Description:把中医疾病关联属性表更新疾病关联识别词必要条件个数
/// Table:CT.WDT.CDSS.TCMDiseJProperty
/// Input:疾病id
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJProperty).UpdateNumOfNConditions(TCMDiseDR)
ClassMethod UpdateNumOfNConditions(TCMDiseDR)
{
	
	s result=""
	s count=0
	s WordsRowId = 0
	for
	{
		s WordsRowId = $o(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",TCMDiseDR,WordsRowId)) q:WordsRowId=""
		s IsNecessCondi= $lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(WordsRowId)),8)
		if (IsNecessCondi=1)
		{
			s count=count+1
		}
	}
	if ($d(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",TCMDiseDR)))
 	{
	 	s TCMDiseJPropertyID=$O(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",TCMDiseDR,0))
		s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%OpenId(TCMDiseJPropertyID)
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
		s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%New()
		d obj.TCMDiseDRSetObjectId(TCMDiseDR)
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

/// Creator：胡宜良
/// CreatDate: 2023-04-27
/// Description:删除中医疾病关联属性表内容
/// Table: CT.WDT.CDSS.TCMDiseJProperty
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMDiseJProperty).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.TCMDiseJProperty).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJProperty).%New()
	if $IsObject(obj.TCMDiseDR)
	{
	 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
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
			
	s sc=##class(CT.WDT.CDSS.TCMDiseJProperty).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJProperty","CT.WDT.CDSS.TCMDiseJProperty","中医疾病关联属性",id,bobj.TCMDiseDR,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联属性","web.CDSS.CMKB.TCMDiseJProperty","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
