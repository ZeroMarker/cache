/// Description: 文献高级检索
/// Creator: 赵文伟
/// Date: 2022-08-04
Class web.CDSS.CMKB.AdvancedSearchDocu Extends %RegisteredObject
{

/// Creator:赵文伟
/// CreatDate: 2022-08-08
/// Description：获取科室数据
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Output: {"text":"内科","id":"1"},{"text":"心脏内科","id":"2"}
/// Other: w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetDepartJsonOld() 
ClassMethod GetDepartJsonOld() As %String
{
	s ID=""
	s DeptJson=""
	for 
	{	
		s ID=$o(^CT.WDT.CDSS.DiseaseDeptDictD(ID)) q:ID=""
		s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),3)       //科室名称
		continue:((DeptName="胸心外科")||(DeptName="泌尿外科")||(DeptName="烧伤和整形外科"))	//过滤包含关系重复科室
		if ($length(DeptName)>5){
			s DeptName = $e(DeptName,1,5)
		} 
		
		if (DeptJson=""){
			s DeptJson="["_"{""text"":"""_DeptName_""",""id"":"""_ID_"""}"
		} else{
			s DeptJson=DeptJson_","_"{""text"":"""_DeptName_""",""id"":"""_ID_"""}"
		}
	}
	s DeptJson=DeptJson_"]"
	s DeptJson=$replace(DeptJson,"""text""","text")
	s DeptJson=$replace(DeptJson,"""id""","id")
	//s DeptJson = [].%FromJSON(DeptJson)
	//q DeptJson.%ToJSON()
	q DeptJson
}

/// Creator:赵文伟
/// CreatDate: 2023-01-29
/// Description：获取科室数据[只取一级科室数据]
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Output: {"text":"内科","id":"1"},{"text":"心脏内科","id":"2"}
/// Other: w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetDepartJson() 
ClassMethod GetDepartJson() As %String
{
	s ID=""
	s DeptJson=""
	for 
	{	
		s ID=$o(^CT.WDT.CDSS.DiseaseDeptDictD(ID)) q:ID=""
		s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),3)       //科室名称
		s FatherDR= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),4)       //父级
		continue:(FatherDR'="")		//过滤字节点
		//continue:((DeptName="胸心外科")||(DeptName="泌尿外科")||(DeptName="烧伤和整形外科"))	//过滤包含关系重复科室
		if ($length(DeptName)>5){
			s DeptName = $e(DeptName,1,5)
		} 
		
		if (DeptJson=""){
			s DeptJson="["_"{""text"":"""_DeptName_""",""id"":"""_ID_"""}"
		} else{
			s DeptJson=DeptJson_","_"{""text"":"""_DeptName_""",""id"":"""_ID_"""}"
		}
	}
	s DeptJson=DeptJson_"]"
	s DeptJson=$replace(DeptJson,"""text""","text")
	s DeptJson=$replace(DeptJson,"""id""","id")
	//s DeptJson = [].%FromJSON(DeptJson)
	//q DeptJson.%ToJSON()
	q DeptJson
}

/// Creator:赵文伟
/// CreatDate: 2022-08-08
/// Description：返回年份下拉框数据
/// Table:
/// Output: [{text:"2022年",id:"2022"},...]
/// Other: w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetYearJson()
ClassMethod GetYearJson() As %String
{
	s date = $ZDATE($HOROLOG,3)
	s endYear = $p(date,"-",1)
	s yearJson=""
	s startYear = ""
	for i=1900:1:endYear{
		//s startYear=i
		s UnitYear = i_"年"
		if (yearJson=""){
			s yearJson="{""text"":"""_UnitYear_""",""id"":"""_i_"""}"_"]"
		} else{
			s yearJson="{""text"":"""_UnitYear_""",""id"":"""_i_"""}"_","_yearJson
		}
	}
	s yearJson="["_yearJson
	s yearJson=$replace(yearJson,"""text""","text")
	s yearJson=$replace(yearJson,"""id""","id")
	q yearJson
}

/// Creator:赵文伟
/// CreatDate: 2022-08-08
/// Description：返回年份下拉框数据,取库中数据
/// Table: CT.WDT.CDSS.DocuManage
/// Output: [{text:"2022年",id:""},...]
/// Other: w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetDocuYearJson()
ClassMethod GetDocuYearJson() As %String
{
	s yearJson = ""
	s year ={}
	s date=""
	for{
		s date=$o(^CT.WDT.CDSS.DocuManageI("DocuMonthIndex",date),-1) q:date=""
		s RowId=""
		for{
			s RowId = $o(^CT.WDT.CDSS.DocuManageI("DocuMonthIndex",date,RowId),-1) q:RowId=""
			s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10) //发布年月
			if (DocuMonth="") continue
			s DocuYearT = $e(DocuMonth,1,4)
			s DocuYear = $e(DocuMonth,1,4)_"年"
			s flag = year.%Get(DocuYear)
			if (flag=""){
				d year.%Set(DocuYear,DocuYear)
				if (yearJson=""){
					s yearJson="{""text"":"""_DocuYear_""",""id"":"""_DocuYearT_"""}"
				} else{
					s yearJson=yearJson_","_"{""text"":"""_DocuYear_""",""id"":"""_DocuYearT_"""}"
				}
			}
		}
	}
	
	s yearJson=yearJson_"]"
	s yearJsonS="["_"{""text"":"""_"不限"_""",""id"":"""_"0"_"""},"_yearJson
	s yearJsonE="["_"{""text"":"""_"至今"_""",""id"":"""_"1"_"""},"_yearJson
	//s yearJsonS=$replace(yearJsonS,"""text""","text")
	//s yearJsonS=$replace(yearJsonS,"""id""","id")
	//s yearJsonE=$replace(yearJsonE,"""text""","text")
	//s yearJsonE=$replace(yearJsonE,"""id""","id")
	
	q yearJsonS_"^"_yearJsonE
}

/// Creator:赵文伟
/// CreatDate: 2022-08-09
/// Description：返回文献出处数据
/// Table: CT.WDT.CDSS.DocuManage
/// Output: [{text:"",id:""},...]
/// Other: w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetDocuSourceJson()
ClassMethod GetDocuSourceJson() As %String
{
	s sourceJson = ""
	s source ={}
	s RowId=""
	for{
	 	s RowId = $o(^CT.WDT.CDSS.DocuManageD(RowId)) q:RowId=""
		s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9) //文献出处
		continue:DocuSource=""
		s DocuSource=$replace(DocuSource,"""","'")
		s flag = source.%Get(DocuSource)
		if (flag=""){
			d source.%Set(DocuSource,DocuSource)
			if (sourceJson=""){
				s sourceJson="["_"{""text"":"""_DocuSource_""",""id"":"""_RowId_"""}"
			} else{
				s sourceJson=sourceJson_","_"{""text"":"""_DocuSource_""",""id"":"""_RowId_"""}"
			}
		}
	}
	s sourceJson=sourceJson_"]"
	s sourceJson=$replace(sourceJson,"""text""","text")
	s sourceJson=$replace(sourceJson,"""id""","id")
	q sourceJson
}

// [类型](科室)(年月)机构,出处。若有信息缺少，则不显示该信息。

// 	var resultSet=[{id:1,name:'近视防治指南',info:'[临床指南](呼吸科)(2022-02)《中国急救医学》2022年2月第26卷第4期'},{id:2,name:'尖锐湿疣的治疗新进展',info:'[临床指南](呼吸科)(2022-02)《中国急救医学》2022年2月第26卷第4期'},{id:3,name:'甲状腺疾病的治疗新进展',info:'[临床指南](呼吸科)(2022-02)《中国急救医学》2022年2月第26卷第4期'}]

/// Creator:赵文伟
/// CreatDate: 2022-08-09
/// Description：返回文献检索结果
/// Table: CT.WDT.CDSS.DocuManage，CT.WDT.CDSS.DiseaseDeptDict
/// Input:Id, Desc, EngDesc, Disease, Dept, StartDate, EndDate, KeyWords, Institution, Month, Source, Type
/// Output: desc^info   [类型](科室)(年月)机构,出处。
/// Other: w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetDocuResultJson("","内镜下胃息肉 临床","","","","","","","")
/// Other: w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetDocuResultJson("","","","儿科","","","","","")
ClassMethod GetDocuResultJson(Id, Desc, Disease, Dept, StartDate, EndDate, Institution, Source, Type) As %String
{
	if (Id'=""){
		s DocuJson="["
	 	s RowId=Id
	 	s DocuCode = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),2)		//文献代码
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3)		//中文文献名称 
		s DocuEngDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),4)	//英文文献名称
		s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5)		//文献路径 .pdf
		s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),6) //关键词
		s DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),7)		//类型
		s DocuInstitutionDr = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构DR
		s:DocuInstitutionDr="" DocuInstitution=""
		s:DocuInstitutionDr'="" DocuInstitution=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),3)	//发布机构
		s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9)	//文献出处
		s DocuSource=$replace(DocuSource,"""","'")
		s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10)	//发布年月
		s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
		s DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),12)	//状态
		
		//关联诊断条件
		s JoinWords=""
		s WordsDR=""
		for {			//取识别条件数据
			s WordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,WordsDR)) q:WordsDR=""
			
			s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			if (JoinWords=""){
				s JoinWords=WordsDesc
			}else{
				s JoinWords=JoinWords_",<br>"_WordsDesc
			}
		}
		s JoinWordsDR=""
		s WordsDR=""
		for {			//取识别条件为空，诊断条件不为空的数据
			s JoinWordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,-100000000000000,JoinWordsDR)) q:JoinWordsDR=""
			s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(JoinWordsDR)),6) //诊断指向，诊断类型识别词
			s WordsDesc=""
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			
			if (JoinWords=""){
				s JoinWords=WordsDesc
			}else{
				s JoinWords=JoinWords_",<br>"_WordsDesc
			}
		}
		
		//关联科室
		s JoinDept=""
		s DeptDR=""
		for{
			s DeptDR=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
			s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
			if (JoinDept=""){
				s JoinDept=DeptName
			}else{
				s JoinDept=JoinDept_","_DeptName
			}	
		}
		s:DocuType'="" DocuType="["_DocuType_"]"
		s:JoinDept'="" JoinDept="("_JoinDept_")"
		s:DocuMonth'="" DocuMonth="("_DocuMonth_")"
		//s:DocuInstitution'="" DocuInstitution="《"_DocuInstitution_"》"
		s:DocuInstitution'="" DocuInstitution="发布机构："_DocuInstitution_" "
			  
		//s DocuInfo="["_DocuType_"]("_JoinDept_")("_DocuMonth_")《"_DocuInstitution_"》"_DocuSource
		s DocuInfo=DocuType_JoinDept_DocuMonth_DocuInstitution_DocuSource
		s DocuJson=DocuJson_"{""id"":"""_RowId_""",""name"":"""_DocuDesc_""",""info"":"""_DocuInfo_"""}"_"]"
	}else{
	 	s:Desc'="" Desc=$ZCONVERT(Desc,"U") //转换成大写
	 	s:Institution'="" Institution=$ZCONVERT(Institution,"U") //转换成大写
	 	s:Source'="" Source=$ZCONVERT(Source,"U") //转换成大写
	 	s:Disease'="" Disease="<"_Disease_">"
	 	
		s DocuJson="["
		s count=0
		s RowId=""
		for
		{
			
			s RowId = $o(^CT.WDT.CDSS.DocuManageD(RowId),-1) q:RowId=""
			s DocuCode = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),2)		//文献代码
			s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3)		//中文文献名称
			s DocuDesc=$replace(DocuDesc,"""","'")
			
			s DocuEngDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),4)	//英文文献名称
			s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),5)		//文献路径
			s DocuKeyWords = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),6) //关键词
			s DocuType = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),7)		//类型
			continue:DocuType=""	//过滤类型为空的数据
			s DocuInstitutionDr = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),8) //发布机构DR
			s:DocuInstitutionDr="" DocuInstitution=""
			s:DocuInstitutionDr'="" DocuInstitution=$lg($g(^CT.WDT.CDSS.DocuAgencyD(DocuInstitutionDr)),3)	//发布机构
			
			s DocuSource = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),9)	//指南出处
			s DocuSource=$replace(DocuSource,"""","'")
			s DocuMonth = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),10)	//发布年月
			s DocuAssociation = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),11) //关联文献
			s DocuState = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),12)	//状态
			
			
			//文献名检索匹配 中文文献名称+英文文献名称+关键词
			s DocuDescSearch=DocuDesc_DocuEngDesc_DocuKeyWords
			//关键词检索
			if (Desc'=""){
				s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DocuDescSearch)
				s Desc=$replace(Desc," ","^")
				s DescLen=$l(Desc,"^")
				s flag=1
				if (DescLen>1){ //空格分隔多个关键词检索
					for n=1:1:DescLen{
						s DescT=$p(Desc,"^",n)
						if '(($ZCONVERT(DocuDescSearch,"U")[DescT)||(PINYINDesc[DescT)) {	//关键词子项不匹配
							s flag=0
							q
						}
					}
					continue:(flag=0)	//多个关键词都不匹配
				}else{			//单个关键词检索
					
					if '(($ZCONVERT(DocuDescSearch,"U")[Desc)||(PINYINDesc[Desc)) {		//不匹配
					
						continue
					}
				}
			}
			
			//发布年份检索
			s DocuMonthT=""
			s:DocuMonth'="" DocuMonthT = $e(DocuMonth,1,4)	//截取年份
			if (StartDate'="")&&(EndDate'=""){
				continue:(DocuMonth="")
				//StartDate=0开始年份不限   EndDate=1结束年份为至今
				if (StartDate'=0)&&(EndDate'=1){	
					continue:((StartDate>DocuMonthT)||(EndDate<DocuMonthT))	
				} elseif((StartDate=0)&&(EndDate'=1)) {
					continue:(EndDate<DocuMonthT)
				} elseif((StartDate'=0)&&(EndDate=1)) {
					continue:(StartDate>DocuMonthT)
				}
			}

			//关联诊断条件
			s JoinWords="",WordsStr=""
			s WordsDR=""
			for {			//取识别条件数据
				s WordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,WordsDR)) q:WordsDR=""
				
				s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
				s WordsStr=WordsStr_"<"_WordsDesc_">"
				if (JoinWords=""){
					s JoinWords=WordsDesc
				}else{
					s JoinWords=JoinWords_","_WordsDesc
				}	
			}
			s JoinWordsDR=""
			s WordsDR=""
			for {			//取识别条件为空，诊断条件不为空的数据
				s JoinWordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",RowId,-100000000000000,JoinWordsDR)) q:JoinWordsDR=""
				s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(JoinWordsDR)),6) //诊断指向，诊断类型识别词
				s WordsDesc=""
				s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
				s WordsStr=WordsStr_"<"_WordsDesc_">"
				if (JoinWords=""){
					s JoinWords=WordsDesc
				}else{
					s JoinWords=JoinWords_","_WordsDesc
				}	
			}
			
			//关联科室
			s JoinDept="",DeptStr=""
			s DeptDR=""
			for{
				s DeptDR=$o(^CT.WDT.CDSS.DocuJoinDeptI("DocuDeptIndex",RowId,DeptDR)) q:DeptDR=""
				s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
				if ($length(DeptName)>5){
					s DeptName = $e(DeptName,1,5)
				}
				if (JoinDept=""){
					s JoinDept=DeptName
				}else{
					s JoinDept=JoinDept_","_DeptName
				}	
			}
			continue:(JoinDept="")
			//根据一级科室同时检索自身及其所有子集科室对应的文献
			if (Dept'=""){		//父级集合不为空
				s len=$l(Dept,"^")
				s qflag=0
				for j=1:1:len{
					s FathDept=$p(Dept,"^",j)	//父级科室每一项
					s DeptClan=""
					s DeptClan=..GetChildren(FathDept)	//取父级及其所有子集科室
					
					s lendept=$l(JoinDept,",")
					
					for i=1:1:lendept{
						s dept=$p(JoinDept,",",i)	//当前遍历文献中的科室每一项
						s slen=$l(DeptClan,",")
						for n=1:1:slen{
							s sDept=$p(DeptClan,",",n)	//父子集中的科室每一项
							if (sDept=dept) {
								s qflag=1
								continue
							}
						}
						continue:(qflag=1)	//已匹配退出循环
					}
					continue:(qflag=1)	//已匹配退出循环
				}
				continue:(qflag=0)	//无匹配项遍历下层循环
			}
			
			//发布机构
			if (Institution'=""){
				continue:('($ZCONVERT(DocuInstitution,"U")[Institution))
			}
			
			if ((Type[DocuType)||(Type=""))&&(($ZCONVERT(DocuSource,"U")[Source)||(Source=""))&&((WordsStr[Disease)||(Disease="")){
				s:DocuType'="" DocuType="["_DocuType_"]"
			  	s:JoinDept'="" JoinDept="("_JoinDept_")"
			  	s:DocuMonth'="" DocuMonth="("_DocuMonth_")"
			  	//s:DocuInstitution'="" DocuInstitution="《"_DocuInstitution_"》"
			  	s:DocuInstitution'="" DocuInstitution="发布机构："_DocuInstitution_" "
			  
		  		//s DocuInfo="["_DocuType_"]("_JoinDept_")("_DocuMonth_")《"_DocuInstitution_"》"_DocuSource
		  		s DocuInfo=DocuType_JoinDept_DocuMonth_DocuInstitution_DocuSource
		  		if count>0 s DocuJson=DocuJson_","
		  		s count=count+1
		  		if count>1000 q	//限制展示1000条记录
			  	s DocuJson=DocuJson_"{""id"":"""_RowId_""",""name"":"""_DocuDesc_""",""info"":"""_DocuInfo_""",""institution"":"""_DocuInstitution_""",""source"":"""_DocuSource_"""}"
		  	}
		}
		s DocuJson=DocuJson_"]"
	}
	q DocuJson
}

/// Creator：赵文伟
/// CreatDate: 2023-01-29
/// Description：根据检索科室取所有子节点[返回自身及所有子节点]
/// Input:DocuDR
/// return:
/// w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetChildren("内科")
ClassMethod GetChildren(dept As %String) As %String
{
	s clan=""
	if ($d(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_dept))){
		s FatherDR=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(dept,"U"),0))
		s RowId=""
		for
		{
			s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",FatherDR,RowId))
			q:RowId=""
			s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),3)		//名称
			s:clan="" clan=dept_","_DeptName
			s:clan'="" clan=clan_","_DeptName
		}
	}
	q clan
}

/// Creator：赵文伟
/// CreatDate: 2022-08-17
/// Description：获取文献摘要及关联诊断
/// Input:DocuDR
/// return:
/// w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetAbstract("18440")
ClassMethod GetAbstract(DocuDR As %String) As %String
{
	s RowId=""
	s RowId=$o(^CT.WDT.CDSS.DocuDetailI("DocuIndex",DocuDR,RowId))
	s Content=""
	s:RowId'="" Content=$lg($g(^CT.WDT.CDSS.DocuDetailD(RowId)),4)

	//关联诊断
	s JoinWords=""
	s WordsDR=""
	for {			//取识别条件数据
		s WordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",DocuDR,WordsDR)) q:WordsDR=""
		
		s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
		if (JoinWords=""){
			s JoinWords=WordsDesc
		}else{
			s JoinWords=JoinWords_","_WordsDesc
		}
	}
	s JoinWordsDR=""
	s WordsDR=""
	for {			//取识别条件为空，诊断条件不为空的数据
		s JoinWordsDR=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",DocuDR,-100000000000000,JoinWordsDR)) q:JoinWordsDR=""
		
		s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(JoinWordsDR)),6) //诊断指向，诊断类型识别词
		s WordsDesc=""
		s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			
		if (JoinWords=""){
			s JoinWords=WordsDesc
		}else{
			s JoinWords=JoinWords_","_WordsDesc
		}
	}
	
    q JoinWords_"^"_Content
}

/// Creator：赵文伟
/// CreatDate: 2022-08-17
/// Description：获取文献路径
/// Input:DocuDR
/// return:
/// w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetDocuPath("14969")
ClassMethod GetDocuPath(DocuDR As %String) As %String
{
	if (DocuDR="") q ""
	s DocuPath=""
	s DocuPath = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),5) //文献路径
	q DocuPath
}

/// Creator：赵文伟
/// CreatDate: 2022-08-29
/// Description：获取文献管理中存在的关联诊断【取匹配度最高的五条不重复的数据,作为关联诊断的下拉框数据】
/// Input:DocuDR
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.AdvancedSearchDocu","GetJoinDia","糖尿病")
Query GetJoinDia(q) As %Query(ROWSPEC = "RowId,WordsDesc")
{
}

ClassMethod GetJoinDiaExecute(ByRef qHandle As %Binary, q) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (q'=""){
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	 	s wordsStr={}
	 	s count=0
	 	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	 	s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DocuJoinDiseaseD(ID)) q:ID=""
			s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(ID)),6) //诊断指向
			s WordsDesc=""
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			s length=$l(WordsDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s num=0
		s le=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le)) q:le=""
			s DID=0
			for
			{
				s DID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,DID)) q:DID=""
				s num=num+1
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",num)=DID
			}
		}	
		s Number=0
		for
		{
			s Number=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number)) q:Number=""
			s RowId=^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number)
			s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),6) //诊断指向
			s WordsDesc=""
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			if (WordsDesc[q){
				s flag=wordsStr.%Get(WordsDesc)
	 			if (flag=""){	//如果不存在
		 			d wordsStr.%Set(WordsDesc,WordsDesc)
		 			s count=count+1
		 			if (count<6){
			 			d OutputRow
			 		} else{
				 		q
				 	}
	 			}
			}
		}    
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,WordsDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetJoinDiaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJoinDiaExecute ]
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

ClassMethod GetJoinDiaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJoinDiaExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：石萧伟
/// CreatDate: 2020-12-28
/// Description：获取文献管理中存在的关联诊断【取匹配度最高的五条不重复的数据,作为关联诊断的下拉框数据】webservice调用
/// Input: property-属性id
/// Other:w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetJoinDiaVue("肺")
ClassMethod GetJoinDiaVue(q As %String) As %String
{
	Set repid=$I(^CacheTemp)
 	if (q'=""){
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	 	s wordsStr={}
	 	s count=0
	 	k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
	 	s ID=0
	 	s result="{""rows"":["
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DocuJoinDiseaseD(ID)) q:ID=""
			s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(ID)),6) //诊断指向
			s WordsDesc=""
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			s length=$l(WordsDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s num=0
		s le=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le)) q:le=""
			s DID=0
			for
			{
				s DID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,DID)) q:DID=""
				s num=num+1
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",num)=DID
			}
		}	
		s Number=0
		for
		{
			s Number=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number)) q:Number=""
			s RowId=^TempDataHandle($ZNAME,repid,$JOB,"Handle",Number)
			s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),6) //诊断指向
			s WordsDesc=""
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			if (WordsDesc[q){
				s flag=wordsStr.%Get(WordsDesc)
	 			if (flag=""){	//如果不存在
		 			d wordsStr.%Set(WordsDesc,WordsDesc)
		 			s count=count+1
		 			if (count<6){//RowId,WordsDesc
		 				if count>1 s result=result_","
			 			s result=result_"{""id"":"""_RowId_""",""text"":"""_WordsDesc_"""}"  
			 		}
	 			}
			}
		}  
		s result=result_"], ""total"":"_count_"}"  
		return result
	}else{
		q "{""rows"":[], ""total"":0}"
	}
}

/// Creator：石萧伟
/// CreatDate: 2020-12-28
/// Description：查询文献发布机构webservice调用
/// Input: property-属性id
/// Other:w ##class(web.CDSS.CMKB.AdvancedSearchDocu).GetDocuAgencyVue("")
ClassMethod GetDocuAgencyVue(desc As %String) As %String
{
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s result="{""rows"":["
	s Id=""
	for{  
		s Id=$o(^CT.WDT.CDSS.DocuAgencyD(Id)) q:Id=""  
		s AgencyDesc = $lg($g(^CT.WDT.CDSS.DocuAgencyD(Id)),3) //发布机构名称
		s PINYINDesc=""
		s:desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(AgencyDesc)  

		if (($ZCONVERT(AgencyDesc,"U")[desc)) {
			s ArrAgency($l(AgencyDesc),Id)=""
		}
	}
	//按名称长度排序
	s len=""
	s count=0
	for{
		s len=$o(ArrAgency(len)) q:len=""
		s RowId=""
		for {
			s RowId=$o(ArrAgency(len,RowId),-1) q:RowId=""
			s AgencyDesc = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),3) //发布机构名称
			s count=count+1
			if (count<971){
							if count>1 s result=result_","
			s result=result_"{""id"":"""_RowId_""",""text"":"""_AgencyDesc_"""}"  

			}
		}	
	}
	s result=result_"], ""total"":"_count_"}" 
	q result
}

}
