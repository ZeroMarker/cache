/// 内涵质控类
Class EPRservice.Quality.EmrCheckRule.NLPCheck Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:	门诊.缺某章节
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		AElementID 	元素
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck001(13439440,"1060|1104\8306|3577","10851|10821")
ClassMethod MNLPCheck001(AEpisodeID As %String, AChartTemplate As %String, AElementID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElementID="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElementID,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	s ElementData=$tr(ElementData,"-—空无同上，。,.; ")
	s:(ElementData="") ret=-1
   	
   	q ret
}

/// Desc:	门诊.主诉不简明扼要
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		AElementID 	主诉
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck002()
ClassMethod MNLPCheck002(AEpisodeID As %String, AChartTemplate As %String, AElementID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElementID="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElementID,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	s:($l(ElementData)>30) ret=-1
   	
   	q ret
}

/// Desc:	门诊.主诉欠准确
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		Azs 		主诉
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck003(154909906,10299,"",10300,"",1)
ClassMethod MNLPCheck003(AEpisodeID As %String, AChartTemplate As %String, Azs As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(Azs="")||(AChartTemplate="")||(UniqueKey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s zsElement=$p(Azs,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s zs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,zsElement,"")
	q:(zs="") ret
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s zsStr=##Class(EMRservice.BL.CDSSService).ConvertPython(zs,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s zsobj={}.%FromJSON(zsStr)

	
	s flag=0,flagdetail=0,ageflag=0,errInfo=""
	for i=1:1:zsobj.%Size()
   	{
	   	s zstype = zsobj.%Get(i-1)."type"
	   	s:((zstype["symptom")||(zstype["disease")||(zstype["sign")) flag=1
	   	continue:(flag=0)
	   	s happentime=zsobj.%Get(i-1)."happen_time"."name"
	   	s lasttime=zsobj.%Get(i-1)."last_time"."name"
	   	s:(happentime'="")||(lasttime'="") flagdetail=1
	   	q:(flag=1)&&(flagdetail=1)
   	}
   	s:((zs["天")||(zs["小时")||(zs["周")||(zs["分")||(zs["月")||(zs["年")||(zs["日")||(zs["出生后")) flagdetail=1
   	s:($match(zs,".*C[0-9][0-9]?.*")) flagdetail=1
   	s:(flag=0) errInfo=errInfo_"#"_"-症状未描述"
   	s:((flag=1)&&(flagdetail=0)) errInfo=errInfo_"#"_"-时间未描述"
   	s:(errInfo'="") ret="-1"_errInfo
   	
   	q ret
}

/// Desc:	门诊.现病史
///     	现病史未描述症状部位     规则：结构化  主诉有症状部位的现病史也需要包含症状部位
/// 		现病史与主诉不相关       规则：结构化  主诉有的症状现病史必须有
/// 		现病史未描述发病时间	 规则：结构化  主诉有症状的现病史必须有发病时间
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		Azs 		主诉
/// 		Axbs 		现病史
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck003(154909906,10299,"",10300,"",1)
ClassMethod MNLPCheck004(AEpisodeID As %String, AChartTemplate As %String, Azs As %String, Axbs As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(Azs="")||(Axbs="")||(AChartTemplate="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret

	s zsElement=$p(Azs,"|",$p(InstanceIDStr,"^",2))
	s xbsElement=$p(Axbs,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s zs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,zsElement,"")
	s xbs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,xbsElement,"")
	q:(zs="")||(xbs="") "1"
	//检查nlp服务是否异常
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s zsStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(zs,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"	
	s xbsStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(xbs,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	q:((zsStr="")||(xbsStr="")) "1"
	s zsobj={}.%FromJSON(zsStr)
	s xbsobj={}.%FromJSON(xbsStr)
	
	s errInfo="",flag="",timeflag="",positionflag="",symptom=""

	for i=1:1:zsobj.%Size()
   	{
	   	s zstype = zsobj.%Get(i-1)."type"
	   	s:((zstype["symptom")||(zstype["disease")||(zstype["sign")) flag=1
	   	continue:(flag=0)
	   	s:(zstype["sympotom") symptom=zsobj.%Get(i-1)."name"
	   	s happentime=zsobj.%Get(i-1)."happen_time"."name"
	   	s lasttime=zsobj.%Get(i-1)."last_time"."name"
	   	s:(happentime'="")||(lasttime'="") timeflag=1
	   	s zsposition= zsobj.%Get(i-1)."position"."name"
	   	s:(zsposition'="") positionflag=1
	   	q:(flag=1)&&(timeflag=1)&&(positionflag=1)
   	}
    q:(flag="") ret
    
	s xbsflag="",xbstimeflag="",xbspositionflag="",symptomflag=""
	for i=1:1:xbsobj.%Size()
   	{
    	s type= xbsobj.%Get(i-1)."type"
    	s xbsname= xbsobj.%Get(i-1)."name" 
		//s xbscore=xbsobj.%Get(i-1)."core"
		//s:(xbscore'="") xbsname=zscore
		s:(type["symptom") xbssymptom=xbsname
		//主诉有的症状现病史必须有
		s:(xbssymptom[symptom)||(symptom[xbssymptom) symptomflag=1
		s xbsposition= xbsobj.%Get(i-1)."position"."name"
		//主诉有症状部位的现病史也需要包含症状部位
		s:(xbsposition'="") xbspositionflag=1
		//s xbssymptom= xbsobj.%Get(i-1)."symptom"."name"
		s xbslasttime= xbsobj.%Get(i-1)."last_time"."name"
		s xbshappentime= xbsobj.%Get(i-1)."happen_time"."name"
		//主诉有症状的现病史必须有发病时间
		s:((xbshappentime'="")||(xbslasttime'="")) xbstimeflag=1
	    q:symptomflag&&xbspositionflag&&xbstimeflag
   	}
   	s:((xbs["天")||(xbs["小时")||(xbs["周")||(xbs["分")||(xbs["月")||(xbs["年")||(xbs["日")||(xbs["出生后")) xbstimeflag=1
   	s:($l(xbs,"-")>2) xbstimeflag=1
   	s:(symptomflag="")&&(symptom'="") errInfo=errInfo_"#与主诉不相关"
   	s:(xbspositionflag="")&&(positionflag=1) errInfo=errInfo_"#未描述症状部位"
   	s:(xbstimeflag="")&&(flag=1) errInfo=errInfo_"#未描述发病时间"
   	s:(errInfo'="") ret="-1"_errInfo //_"@"_InstanceID
   	
   	q ret
}

/// Desc:	门诊.查体记录不准确或有遗漏
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		AElemrnt 	查体
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck005(154909906,10299,"",10300,"",1)
ClassMethod MNLPCheck005(AEpisodeID As %String, AChartTemplate As %String, AElemrnt As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElemrnt="")||(AChartTemplate="")||(UniqueKey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElemrnt,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s Elementobj={}.%FromJSON(ElementStr)

	
	s flag=0
	for i=1:1:Elementobj.%Size()
   	{
	   	s type = Elementobj.%Get(i-1)."type"
	   	s:((type["symptom")||(type["sign")||(type["ris_result")||(type["Ris")||(type["Lis")) flag=1
	   	continue:(flag=0)
	   	q:(flag=1)
   	}
   	s:(flag=0) ret=-1
   	
   	q ret
}

/// Desc:	门诊.处理无实质内容
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		AElemrnt 	处理
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck006(154909906,10299,"",10300,"",1)
ClassMethod MNLPCheck006(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, UniqueKey As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AElement="")||(AChartTemplate="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	q:(ElementData1="") "-1"
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
	s Str = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
	
	s flag=0
	for i=1:1:Elementobj.%Size()
   	{
	   	s type = Elementobj.%Get(i-1)."type"
	   	s:((type["Ris")||(type["Lis")||(type["Drug")||(type["operation")) flag=1
	   	q:(flag=1)
   	}
   	s:(flag=0) ret=-1
	q ret
}

/// Desc:	门诊.签名
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		AElementID 	元素
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck007(154909906,10299,"",10300,"",1)
ClassMethod MNLPCheck007(AEpisodeID As %String, AChartTemplate As %String, AElementID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElementID="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElementID,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	s ElementData=$tr(ElementData,"：",":")
	s ElementData=$p(ElementData,":",2)
	s:(ElementData="") ret=-1
   	
   	q ret
}

/// Desc:	门诊初诊病历.现病史有“同前”字段
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		AElementID 	元素
/// 		ADesc		不能包含的文字
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck008(EpisodeID,"门诊初诊ChartTemplate","现病史code","同前")
ClassMethod MNLPCheck008(AEpisodeID As %String, AChartTemplate As %String, AElementID As %String, ADesc As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElementID="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElementID,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	for j=1:1:$l(ADesc,"\") 
	{	
		s:(ElementData[$p(ADesc,"\",j)) ret=-1 //包含任意一个就提示
		q:ret=-1
	}
   	
   	q ret
}

/// Desc:	门诊初诊病历.诊断是高血压的，病历中未体现血压值
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		AElementID 	元素
/// 		ADiag		疾病
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).MNLPCheck009(EpisodeID,"门诊初诊ChartTemplate","现病史code",UniqueKey)
ClassMethod MNLPCheck009(AEpisodeID As %String, AChartTemplate As %String, AElementID As %String, ADiag As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AChartTemplate="")||(ADiag="") ret
	
	s flag=0
	s result = ##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	d result.Execute(AEpisodeID)
	while result.%Next()
	{
		s DiagnosType=result.Data("DiagnosType")		
		s DiagnosICDDesc=result.Data("DiagnosICDDesc")
		continue:(DiagnosICDDesc'[ADiag)
		s flag=1		
	}
	q:(flag=0) ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElementID,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s SignStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	q:(SignStr="") "1"
	s Signobj={}.%FromJSON(SignStr)
	s ret=-1
	s signFlag=0,info=""
	for i=1:1:Signobj.%Size()
   	{
    	s type= Signobj.%Get(i-1)."type"
    	if (type["sign")
    	{
	    	s signname=Signobj.%Get(i-1)."sign_name"."name"
			s:((signname["血压")||(signname["BP")||(signname["收缩压/舒张压")) ret=1	    	
	    }
	    q:(ret=1)
   	}
	
	q ret
}

/// Desc:	入院记录主诉描述错误
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		Azs 		主诉
/// 		Aage		年龄
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck001(51074340,"390|281\1264|738\1298|756\1300|757","2561|6862|6308|5754",56,1)
ClassMethod NLPCheck001(AEpisodeID As %String, AChartTemplate As %String, Azs As %String, Aage As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(Azs="")||(AChartTemplate="")||(UniqueKey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s zsElement=$p(Azs,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s zs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,zsElement,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(zsElement)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s zsStr=##Class(EMRservice.BL.CDSSService).ConvertPython(zs,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s zsobj={}.%FromJSON(zsStr)

	
	s flag=0,flagdetail=0,ageflag=0,errInfo=""
	for i=1:1:zsobj.%Size()
	{
	   	s zstype = zsobj.%Get(i-1)."type"
	   	s:((zstype["symptom")||(zstype["disease")||(zstype["epidemic")||(zstype["sign")||(zstype["generalstatus")||(zstype["ris_result")||(zstype["operation")||(zstype["manipulation")||(zstype["menstrualhistory")||(zstype["Lis")) flag=1
	   	continue:(flag=0)
	   	s happentime=zsobj.%Get(i-1)."happen_time"."name"
	   	s lasttime=zsobj.%Get(i-1)."last_time"."name"
	   	if ((happentime["年")||(lasttime["年"))
	   	{
        	s happentime=$tr($p(happentime,"年",1),"+-","")
        	s lasttime=$tr($p(lasttime,"年",1),"+-","")
	   	continue:((lasttime>1000)||(happentime>1000))
	   	s:(happentime>Aage)||(lasttime>Aage) ageflag=1
	   	}
	   	s:(happentime'="")||(lasttime'="") flagdetail=1
	   	q:(flag=1)&&(flagdetail=1)
	}
	//s:((zs["体检")||(zs["检查")) flag=1  
	s:((zs["天")||(zs["小时")||(zs["周")||(zs["分")||(zs["月")||(zs["年")||(zs["日")||(zs["出生后")) flagdetail=1
	s:((zs["化疗")&&(zs["次")) flagdetail=1
	s:((zs["I")||(zs["Ⅰ")||(zs["Ⅱ")||(zs["Ⅲ")||(zs["Ⅳ")||(zs["Ⅴ")) flagdetail=1 
	s:($match(zs,".*C[0-9][0-9]?.*")) flagdetail=1
	s:(flag=0) errInfo=errInfo_"#"_"-症状未描述"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
   	
	s:((flag=1)&&(flagdetail=0)) errInfo=errInfo_"#"_"-时间未描述"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	s:ageflag errInfo=errInfo_"#"_"-时间大于年龄"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	s:(errInfo'="") ret="-1"_errInfo
   	
	q ret
}

ClassMethod ANLPCheck001(AEpisodeID As %String, AChartTemplate As %String, AElements As %String, CYDateTime As %String, Desc As %String, UniqueKey As %String)
{
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s AElement=$p(AElements,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s errorinfo=""
	for j=1:1:$l(AElement,"^")
	{
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElement,"^",j),"")
		q:($g(^CacheTempResponseFlag(UniqueKey))=0)
		s Str=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0)
		s obj={}.%FromJSON(Str)
		s flag=0
		for i=1:1:obj.%Size()
		{
			s ahappentime=obj.%Get(i-1)."happen_time"."name"
			continue:(ahappentime["前")||(ahappentime="")
	   		s happentime=$tr(ahappentime,"年月日","--")
	   		s happentime=$tr(happentime,".","-")
	   		if ($e(happentime,*)="-")
	   		{
		   		s happentime=$e(happentime,1,*-1)
		   		s:($l(happentime,"-")<2) happentime=happentime_"-01-01"
	   			s:($l(happentime,"-")<3) happentime=happentime_"-01"
		   	}
	   		if (CYDateTime'="")
	   		{
		   		s CYDateTime=$p(CYDateTime," ",1)
		   		s gap=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(CYDateTime,happentime)
		   		s:(gap<0) flag=11
		   		q:(flag=11)
		   	}
		   	else
		   	{
		   		s gap=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(+$h,happentime)
		   		s:(gap<0) flag=12
		   		q:(flag=12)
			}
		}
		s:(flag=11) errorinfo=errorinfo_"-"_$p(Desc,"^",j)_"中的发生时间不应大于出院时间"
		s:(flag=12) errorinfo=errorinfo_"-"_$p(Desc,"^",j)_"中的发生时间不应大于当前时间"
	}
	q:(errorinfo="") 1
	q "-1#"_errorinfo_"@"_InstanceID
}

/// Desc:	入院记录 主诉与现病史不符 部位 时间
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		Azs			主诉code（入院记录）
/// 		Axbs		现病史code（入院记录）
/// 		Uniquekey	进程号,直接写UniqueKey即可	
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck002(EpisodeID,{RYChartTemplate},"2561|6862|6308|5754","2562|6863|6309|5755",UniqueKey)
ClassMethod NLPCheck002(AEpisodeID As %String, AChartTemplate As %String, Azs As %String, Axbs As %String, Uniquekey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(Azs="")||(Axbs="")||(AChartTemplate="")||(Uniquekey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s zsElement=$p(Azs,"|",$p(InstanceIDStr,"^",2))
	s xbsElement=$p(Axbs,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s zs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,zsElement,"")
	s xbs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,xbsElement,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(xbsElement)
	q:(zs="")||(xbs="") "1"
	//检查nlp服务是否异常
	q:($g(^CacheTempResponseFlag(Uniquekey))=0) "1"
	s zsStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(zs,Uniquekey)
	q:($g(^CacheTempResponseFlag(Uniquekey))=0) "1"	
	s xbsStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(xbs,Uniquekey)
	q:($g(^CacheTempResponseFlag(Uniquekey))=0) "1"
	q:((zsStr="")||(xbsStr="")) "1"
	s zsobj={}.%FromJSON(zsStr)
	s xbsobj={}.%FromJSON(xbsStr)
	
	s errInfo="",flag=""

	s zstype= xbsobj.%Get(0)."type"
	s zsname= zsobj.%Get(0)."name" 
	s zscore=zsobj.%Get(0)."core"
	s:(zscore'="") zsname=zscore
	s zsposition= zsobj.%Get(0)."position"."name"
	s zssymptom= zsobj.%Get(0)."symptom"."name"
	s zslasttime= zsobj.%Get(0)."last_time"."name"
	s zshappentime= zsobj.%Get(0)."happen_time"."name"
	s zslasttime=$tr(zslasttime,"前余","")
	s zshappentime=$tr(zshappentime,"前余","")

	s xbsltimeInfo="",xbshtimeInfo="",xbspositionInfo=""
	for i=1:1:xbsobj.%Size()
   	{
    	s type= xbsobj.%Get(i-1)."type"
    	s xbsname= xbsobj.%Get(i-1)."name" 
		s xbscore=xbsobj.%Get(i-1)."core"
		s:(xbscore'="") xbsname=zscore
		s xbsposition= xbsobj.%Get(i-1)."position"."name"
		s xbssymptom= xbsobj.%Get(i-1)."symptom"."name"
		s xbslasttime= xbsobj.%Get(i-1)."last_time"."name"
		s xbshappentime= xbsobj.%Get(i-1)."happen_time"."name"
		s xbslasttime=$tr(xbslasttime,"前余","")
		s xbshappentime=$tr(xbshappentime,"前余","")
		if (zstype["symptom")
		{
		if (..format(zssymptom)=..format(xbssymptom))&&(zstype=type)
		{
			s:(zslasttime'="")&&((xbslasttime'="")||(xbshappentime'=""))&&(xbslasttime'=zslasttime)&&(xbshappentime'=zslasttime) errInfo=errInfo_"-症状时间"
		   	s:(zshappentime'="")&&((xbslasttime'="")||(xbshappentime'=""))&&(xbslasttime'=zshappentime)&&(xbshappentime'=zshappentime) errInfo=errInfo_"-症状时间"
			s:(xbsposition'[zsposition) errInfo=errInfo_"-症状部位"
			s:(errInfo="") flag=1
		}
		q:(errInfo'="")
		}
		elseif ((type[$tr(zstype,"+-?",""))&&(xbsname=zsname))
		{
			s:(zslasttime'="")&&((xbslasttime'="")||(xbshappentime'=""))&&(xbslasttime'=zslasttime)&&(xbshappentime'=zslasttime) errInfo=errInfo_"-症状时间"
			s:(zshappentime'="")&&((xbslasttime'="")||(xbshappentime'=""))&&(xbslasttime'=zshappentime)&&(xbshappentime'=zshappentime) errInfo=errInfo_"-症状时间"
			s:(zsposition'="")&&(xbsposition'[zsposition) errInfo=errInfo_"-症状部位"
			s:(errInfo="") flag=1
		}
    	q:(flag=1)
   	}
   	s:(errInfo'="") ret="-1#"_errInfo_"@"_InstanceID_$c(0)_ElementCode_$c(0)
   	
   	q ret
}

/// Desc:	入院记录起病缓急描述不清
/// Input:	EpisodeID	就诊号
/// 		AChartTemplate
/// 		Element1	现病史
/// Output:	ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck003(55006175,"390|281\1264|738\1298|756\1300|757","2562|6863|6309|5755")
ClassMethod NLPCheck003(EpisodeID As %String, AChartTemplate As %String, Element1 As %String) As %String
{
	s ret=1
	q:(EpisodeID="")||(AChartTemplate="")||(Element1="") ret
	s InstanceIDStr=..GetInstanceIDStr(EpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(Element1,"|",$p(InstanceIDStr,"^",2))
	q:(Element=0) ret
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,Element,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element)
    q:((ElementData1["立即")||(ElementData1["出生后")||(ElementData1["平素")||(ElementData1["一直")||(ElementData1["自觉")||(ElementData1["复诊")||(ElementData1["再次")||(ElementData1["医院")||(ElementData1["出现")||(ElementData1["复查")||(ElementData1["术后")||(ElementData1["发现")||(ElementData1["自觉")||(ElementData1["突发")||(ElementData1["突然")||(ElementData1["感")||(ElementData1["偶")||(ElementData1["体检")||(ElementData1["检查")||(ElementData1["发生")||(ElementData1["致")||(ElementData1["扪及")||(ElementData1["无意")||(ElementData1["自诉")||(ElementData1["患者诉")) 1
	q "-1#"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
}

/// Desc:	入院记录 未描述发病后到入院前,在院内、外接受检查与治疗的详细经过及效果或欠缺
/// Input:	EpisodeID	就诊号
/// 		AChartTemplate
/// 		Element1	现病史
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck004(151289661,10300)
ClassMethod NLPCheck004(EpisodeID As %String, AChartTemplate As %String, Element1 As %String) As %String
{
	s ret=1
	q:(EpisodeID="")||(AChartTemplate="")||(Element1="") ret

	s InstanceIDStr=..GetInstanceIDStr(EpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(Element1,"|",$p(InstanceIDStr,"^",2))
	q:(Element=0) ret
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ret=-1
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,Element,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element)
	s:((ElementData1["门诊")||(ElementData1["院外")||(ElementData1["急诊")||(ElementData1["医院")||(ElementData1["我院")||(ElementData1["我科")||(ElementData1["入院前")||(ElementData1["当地行相关检查")||(ElementData1["外院")) ret=1
	s:(ret="-1") ret="-1#@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	入院记录 既往史
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		Ajws 		既往史	
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck005(54708858,"390|281\1264|738\1298|756\1300|757","2563|6864|6310|5756",1)
ClassMethod NLPCheck005(AEpisodeID As %String, AChartTemplate As %String, Ajws As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(Ajws="")||(AChartTemplate="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s jwsElement=$p(Ajws,"|",$p(InstanceIDStr,"^",2))
	q:(jwsElement=0) ret
	s InstanceID=$p(InstanceIDStr,"^",1)
	s jws=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,jwsElement,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(jwsElement)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s jwsStr=##Class(EMRservice.BL.CDSSService).ConvertPython(jws,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s jwsobj={}.%FromJSON(jwsStr)

	s info=""
	s Err=..IsType(AEpisodeID,"disease/epidemic","",jwsobj,UniqueKey)
	s:(Err["-1")&&(jws'["无特殊病史") info=info_"#-未描述既往疾病史"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	s Err1=..IsType(AEpisodeID,"epidemic","",jwsobj,UniqueKey)
	s Err=..IsTypeInfectious(AEpisodeID,"",jwsobj,UniqueKey)
	s:(Err1["-1")&&(Err["-1")&&(jws'["传染") info=info_"#-未描述既往传染病史"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	s Err=..IsType(AEpisodeID,"blood_transfusion_history","",jwsobj,UniqueKey)
	s:(Err["-1")&&((jws["输注")||(jws["输血")||(jws["血液")||(jws["红细胞")||(jws["血浆")||(jws["血小板")) Err=1
	s:(Err["-1") info=info_"#-未描述既往输血史"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	s Err=..IsType(AEpisodeID,"operation\traumatismhistory","",jwsobj,UniqueKey)
	s:(Err["-1") info=info_"#-未描述既往手术外伤史"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	//s Err=..IsType(AEpisodeID,"personalhistory","",jwsobj,UniqueKey)
	//s:(Err["-1") info=info_"#-未描述个人史"_"@"_InstanceIDStr
	s:(jws'["接种")&&(jws'["疫苗") info=info_"#-未描述既往预防接种史"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	s Err=..IsType(AEpisodeID,"allergyhistory","",jwsobj,UniqueKey)
	s:(Err["-1")&&(jws["过敏") Err=1
	s:(Err["-1") info=info_"#-未描述既往食物或药物过敏史"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	s:(info'="") ret="-1"
	
	q ret_info
}

/// Desc:	是否包含传染病史
/// Input:	AEpisodeID	就诊号	
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck006(140047880,10301,"",1)
ClassMethod IsTypeInfectious(AEpisodeID As %String, AElement As %String, AElementObj As %Library.DynamicArray, UniqueKey As %String) As %String
{
	s ret=0
	
	q:(AEpisodeID="")||(UniqueKey="") ret
	if (AElementObj'="")
	{
		s ElementObj=AElementObj
	}else{
		s Element=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
		s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(Element,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
		s ElementObj={}.%FromJSON(ElementStr)
	}

	s ret="-1"
	for i=1:1:ElementObj.%Size()
   	{
	   	s type=""
    	s type= ElementObj.%Get(i-1)."type"
    	continue:(type'["disease")
    	s name= ElementObj.%Get(i-1)."name" 
    	s InfectiousFlag=..IsInfectious(name)
    	s:(InfectiousFlag=1) ret=1
    	q:(ret=1)
   	}
   	
   	q ret
}

/// Desc:	是否包含输血史
/// Input:	AEpisodeID	就诊号	
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck007(140047880,10301,"",1)
ClassMethod IsTypeBlood(AEpisodeID As %String, AElement As %String, AElementObj As %Library.DynamicArray, UniqueKey As %String) As %String
{
	s ret=0
	
	q:(AEpisodeID="")||(UniqueKey="") ret
	if (AElementObj'="")
	{
		s ElementObj=AElementObj
	}else{
		s Element=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
		s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(Element,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
		s ElementObj={}.%FromJSON(ElementStr)
	}

	s ret="-1"
	for i=1:1:ElementObj.%Size()
   	{
	   	s type=""
    	s type= ElementObj.%Get(i-1)."type"
    	continue:(type'["operation")&&(type'["manipulation")
    	s name= ElementObj.%Get(i-1)."name"
    	s:(name["输血") ret=1
    	q:(ret=1) 
   	}
   	
   	q ret
}

/// Desc:	入院记录体格检查中生命体征不完整
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		ASign		入院记录-生命体征（体格检查内）
/// 		Uniquekey	进程号,直接写Uniquekey即可
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck006(EpisodeID,{RYChartTemplate},"2731|7017|6478|5924",UniqueKey)
ClassMethod NLPCheck006(AEpisodeID As %String, AChartTemplate As %String, ASign As %String, Uniquekey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(ASign="")||(AChartTemplate="")||(Uniquekey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s SignElement=$p(ASign,"|",$p(InstanceIDStr,"^",2))
	q:(SignElement=0) ret
	s InstanceID=$p(InstanceIDStr,"^",1)
	s Sign=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,SignElement,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(SignElement)
	s Sign=$tr(Sign,$c(10),"")
	q:(Sign="") "1"
	q:($g(^CacheTempResponseFlag(Uniquekey))=0) "1"
	s SignStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(Sign,Uniquekey)
	q:($g(^CacheTempResponseFlag(Uniquekey))=0) "1"
	q:(SignStr="") "1"
	s Signobj={}.%FromJSON(SignStr)
	q:($system.Status.IsError(Signobj)) "1"

	s signNameStr="/"
	s signFlag=0,info=""
	for i=1:1:Signobj.%Size()
   	{
    	s type= Signobj.%Get(i-1)."type"
    	if (type["sign")
    	{
	    	s signname=Signobj.%Get(i-1)."sign_name"."name"
	    	s Heartvalue=Signobj.%Get(i-1)."sign_value"
	    	s:(Heartvalue'="") signNameStr=signNameStr_signname_"/"
	    	if (signname="收缩压/舒张压")
	    	{
		    	s ssValue=Heartvalue.%Get(0)."name"
		    	s szValue=Heartvalue.%Get(1)."name"
		    	s:(ssValue<szValue) info=info_"-收缩压小于舒张压"
		    }
	    }
   	}
   	s:((signNameStr'["/脉搏/")&&(signNameStr'["/P/")) info=info_"-无脉搏"
   	s:((signNameStr'["/体温/")&&(signNameStr'["/T/")) info=info_"-无体温"
   	s:((signNameStr'["/呼吸/")&&(signNameStr'["/R/")) info=info_"-无呼吸"
   	s:((signNameStr'["/血压/")&&(signNameStr'["/BP/")&&(signNameStr'["/收缩压/舒张压/")) info=info_"-无血压"
   	//s:((signNameStr'["/心率/")&&(signNameStr'["/HR/")) info=info_"-无心率"
   	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)	
	
   	q ret
}

/// Desc:	本文内存描述冲突
/// 	---	入院记录现病史中一般情况描述“二便可”或者‘大小便可’，与（腹泻 拉稀 拉血 便血 便秘）等相矛盾（二便指大小便）
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	现病史
/// 		AElement2	体格检查
/// 		AText1		描述（正描述1\正描述2\...|反描述1\反描述2\...）
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck007(54962317,"390|281\1264|738\1298|756\1300|757","2562|6863|6309|5755","2562|6863|6309|5755","二便可\大小便可\大小便正常|腹泻\拉稀\拉血\便血\便秘")
ClassMethod NLPCheck007(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, AText As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AText="") ret	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s Element2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s AText1=$p(AText,"|",1)
	s AText2=$p(AText,"|",2)
	s ElementDate1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
	q:(ElementDate1="") "1"
	s ElementDate2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
	q:(ElementDate2="") "1"
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element2)
	
	s flag1a=0,flag2a=0,flag1b=0,flag2b=0,Desc=""
	for i=1:1:$l(AText1,"\")
	{
		s aText=$p(AText1,"\",i)
		s:(ElementDate1[aText) flag1a=1
        	//s:(ElementDate2[aText) flag2a=1
	}
	if (flag1a)
	{
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
		s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementDate2,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
		s ElementObj={}.%FromJSON(ElementStr)
		for i=1:1:ElementObj.%Size()
		{
		    s type= ElementObj.%Get(i-1)."type"
		    s name= ElementObj.%Get(i-1)."name"
		    continue:(type'="+symptom")
		    for j=1:1:$l(AText2,"\")
		    {
		        s bText=$p(AText2,"\",j)
		        //s:(ElementDate2[bText) flag1b=1
		        s:(name[bText) flag2b=1
		        s Desc=bText
		    }
		}
	}
	s:((flag1a=1)&&(flag2b=1)) ret="-1#"_"@"_InstanceID_$c(0)_ElementCode_$c(0)_Desc
	q ret
}

/// Desc:   入院记录 过敏史描述情况与病案首页不符
/// Input:  AEpisodeID  就诊号 
///         AChartTemplate    入院记录ChartTemplate
///         AElement    既往史
///         AChartTemplate1	病案首页ChartTemplate
///         AElement1   病案首页过敏史
///         UniqueKey   进程号
/// Output: ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck008(54922496,"390|281\1264|738\1298|756\1300|757",1504,"2563|6864|6310|5756",1)
ClassMethod NLPCheck008(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, AChartTemplate1 As %String, AElement1 As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement="")||(AChartTemplate="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret
	s Element=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s Element1=$p(AElement1,"|",$p(InstanceIDStr1,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s InstanceID1=$p(InstanceIDStr1,"^",1)
	s ElementDes=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,InstanceID)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementDes,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj={}.%FromJSON(ElementStr)

    s ElementID1 =  ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,InstanceID1) 
    
    s isOK = 0
    s responses=""
    for i=1:1:ElementObj.%Size()
    {
        s ppp="",type="",name="",happentime="",lasttime=""
        s type= ElementObj.%Get(i-1)."type"
        s name= ElementObj.%Get(i-1)."name"
        s core=ElementObj.%Get(i-1)."core"
        continue:(core'["药物")
        continue:(type'["allergyhistory")
        if ((type["+")&&(ElementID1["无"))
        {
            s ret=-1
        }
        q
    }
    
    s:(ret="-1") ret="-1#"_"@"_InstanceID
    q ret
}

/// Desc:   入院记录 手术史矛盾
/// Input:  AEpisodeID  就诊号
///         AChartTemplate
///         AElement    既往史 
///         UniqueKey   进程号
/// Output: ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck009(54926851,"390|281\1264|738\1298|756\1300|757","2563|6864|6310|5756",1)
ClassMethod NLPCheck009(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement="")||(AChartTemplate="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	q:(Element=0) ret
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element)
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementDes=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	q:((ElementDes["无其他")||(ElementDes["无其它")||(ElementDes["否认其他")||(ElementDes["否认其它")) "1"
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementDes,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj={}.%FromJSON(ElementStr)
	
	s Age=##Class(EPRservice.Quality.DataGather.AdmInfo).GetAge(AEpisodeID)
	s flag1=0,flag2=0,Desc=""
	
	for i=1:1:ElementObj.%Size()
    {
	    s type= ElementObj.%Get(i-1)."type"
	
	    continue:(type'["operation")
	    s name= ElementObj.%Get(i-1)."name"
	    s Desc=name
        continue:((name["血")||(name["透析")||(name["穿刺")||(name["放疗")||(name["化疗")||(name["输注"))
		continue:(Age<18)&&((name["剖宫产")||(name["剖腹产"))
	    s:(type["+") flag1=1
	    s:(type["-") flag2=1
	    q:(flag1=1)&&(flag2=1)
	}
	
	s:(flag1=1)&&(flag2=1) ret="-1#@"_InstanceID_$c(0)_ElementCode_$c(0)_Desc
	q ret
}

/// Desc:   入院记录 婚育史 （男性年龄>=22岁，女性年龄>=20）
/// Input:  AEpisodeID  就诊号
///         AChartTemplate
///         AElement    婚育史 
///         Agender {HISPatSex}性别
///         UniqueKey   进程号
/// Output: ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck010(55160328,"390|281\1264|738\1298|756\1300|757","2678|6970|6425|5871","女",1)
ClassMethod NLPCheck010(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, Agender As %String, UniqueKey As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AElement="")||(AChartTemplate="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1 =##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	q:(ElementData1="") 1
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj={}.%FromJSON(ElementStr)
	s singleFlag=0,marrigeFlag=0,releticeFlag=0,pregnancyFlag=0,divorceFlag=0,deathFlag=0
	for i=1:1:ElementObj.%Size()
	{
    	s type= ElementObj.%Get(i-1)."type"
    	s:(type["pregnancy&birth") pregnancyFlag=1
    	s name= ElementObj.%Get(i-1)."name"
    	s:(name="未婚") singleFlag=1	
        s:(name="已婚")||(name="结婚")||(name="再婚") marrigeFlag=1
    	s:((name="离异")||(name="离婚")) divorceFlag=1
    	s:((name="无离异")||(name="无离婚")) divorceFlag=0
    	s:(name="丧偶") deathFlag=1
    	s:(name="无丧偶") deathFlag=0
    	s relativeobj= ElementObj.%Get(i-1)."relative"	
    	continue:(relativeobj="")
    	for j=1:1:relativeobj.%Size()
    	{
	     	s relative= relativeobj.%Get(j-1)."name"
	     	s:(relative["配偶")||(relative["妻")||(relative["夫")||(relative["爱人") releticeFlag=1
	    }
	}
	q:singleFlag 1
	s:(singleFlag+marrigeFlag+divorceFlag+deathFlag<1) info=info_"-无婚姻状况"
	if (divorceFlag||deathFlag)
	{
		s:(('pregnancyFlag)&&(Agender["女")) info=info_"-无孕产史"
	}elseif (marrigeFlag){
		s:(('pregnancyFlag)&&(Agender["女")) info=info_"-无孕产史"
		s:'releticeFlag info=info_"-无配偶健康状况"
	}
	
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	
	q ret
}

/// Desc:   入院记录 未描述家族史
/// Input:  AEpisodeID  就诊号
///         AChartTemplate
///         AElement    家族史 
///         Aage        年龄
///         UniqueKey   进程号
/// Output: ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck011(55031605,"390|281\1264|738\1298|756\1300|757","2707|6993|6454|5900",1,1)
ClassMethod NLPCheck011(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, Aage As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement="")||(AChartTemplate="")||(Aage="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s Element=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(Element,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj={}.%FromJSON(ElementStr)
	
	s info=""
	s sisterFlag=0
	s parentsFlag=0
	s diseaseFlag=0
	s familyFlag=0
	s:(Aage>80) parentsFlag=1
	s:(Element["家人健康状况")||(Element["家庭成员健康状况") parentsFlag=1,sisterFlag=1
	s:(Element["遗传") familyFlag=1
	s:((Element["父")||(Element["母")||(Element["双亲")) parentsFlag=1
    	s:(Element["姐")||(Element["妹")||(Element["兄")||(Element["弟")||(Element["哥")||(Element["独生")||(Element["独子")||(Element["独女") sisterFlag=1
	
     for i=1:1:ElementObj.%Size()
   	{
	   	s type=""
    	s type= ElementObj.%Get(i-1)."type"
    	s disease= ElementObj.%Get(i-1)."disease"
    	s:(disease'="") diseaseFlag=1
    	s:(type["disease") diseaseFlag=1
    	s sectionType=ElementObj.%Get(i-1)."section_type"
    	s objrelative= ElementObj.%Get(i-1)."relative"
    	if (objrelative'="")&&(sectionType="家族史")
    	{
	    	for j=1:1:objrelative.%Size()
	    	{
		    	s relative=objrelative.%Get(j-1).name
                	s:(relative["姐")||(relative["妹")||(relative["兄")||(relative["弟")||(relative["哥")||(relative["独生")||(relative["独子")||(relative["独女") sisterFlag=1
		    	s:(relative["父")||(relative["母")||(relative["双亲") parentsFlag=1
	    	}	
	    }
   	}
    //s:(sisterFlag=0) info=info_"-无兄弟姐妹健康状况"
    s:(parentsFlag=0) info=info_"-无父母健康状况"
    s:(diseaseFlag=0)&&(familyFlag=0) info=info_"-家族是否有类似疾病"
    //s:(familyFlag=0) info=info_"-是否有家族遗传倾向疾病"
    s:(info'="") ret="-1"_"#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
    q ret
}

/// Desc:	入院记录 月经史 （年龄>14岁女性）
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement 	月经史
/// 		Aage	年龄
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck012(54965437,"390|281\1264|738\1298|756\1300|757","2669||6416|5862",50,1)
ClassMethod NLPCheck012(EpisodeID As %String, AChartTemplate As %String, AElement As %String, Aage As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(AElement="")||(AChartTemplate="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(EpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s info=""
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	s Desc=""
	if (ElementData1'="")
	{
		s:((ElementData1["14岁;29;5;50")&&(50>(+Aage))) info=info_"-绝经年龄不符"
		s Desc="14岁;29;5;50"
	}
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj={}.%FromJSON(ElementStr)
	for i=1:1:ElementObj.%Size()
	{
		q:(info'="")
		s type=""
		s type= ElementObj.%Get(i-1)."type"
		continue:(type'["menstrualhistory")
		s menstrualtype=ElementObj.%Get(i-1)."menstrual_type"."name"
		continue:(menstrualtype'="绝经")
		s menstrualage=ElementObj.%Get(i-1)."menstrual_age"."name"
		s menstrualage=$tr(menstrualage,"岁","")
		s:(menstrualage>(+Aage)) info=info_"-绝经年龄不符"
		s Desc=menstrualage
	}
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)_Desc
	q ret
}

/// Desc:	既往有手术史患者查体时应对皮肤疤痕有描述，或者皮肤有手术疤痕但未记录既往手术史
/// Input:	AEpisodeID 就诊号
/// 		AChartTemplate
/// 		AOperation  入院记录-手术史（既往史内）
///         	Axbs        入院记录-现病史
/// 		ASkin       皮肤粘膜（体格检查内）
/// 		Uniquekey	进程号，直接写Uniquekey即可	
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck013(55043855,"390|281|49\1264|738\1298|756\1300|757","2563|6864|6310|5756","2562|6863|6309|5755","2766|7052|6513|5959",1)
ClassMethod NLPCheck013(AEpisodeID As %String, AChartTemplate As %String, AOperation As %String, Axbs As %String, ASkin As %String, Uniquekey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AOperation="")||(ASkin="")||(AChartTemplate="")||(Uniquekey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s OperationID=$p(AOperation,"|",$p(InstanceIDStr,"^",2))
    	s xbsID=$p(Axbs,"|",$p(InstanceIDStr,"^",2))
	s SkinID=$p(ASkin,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s Operation=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,OperationID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(OperationID)
	s Skin=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,SkinID,"")
	q:(Operation="")||(Skin="") "1"
	//检查nlp服务是否异常
	q:($g(^CacheTempResponseFlag(Uniquekey))=0) "1"
	s OperationStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(Operation,Uniquekey)
	q:($g(^CacheTempResponseFlag(Uniquekey))=0) "1"	
	s SkinStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(Skin,Uniquekey)
	q:($g(^CacheTempResponseFlag(Uniquekey))=0) "1"
	q:((OperationStr="")||(SkinStr="")) "1"
	s Operationobj={}.%FromJSON(OperationStr)
	s Skinobj={}.%FromJSON(SkinStr)
		
	s OpeFlag=0,Desc=""
    for i=1:1:Operationobj.%Size()
   	{
    	s type= Operationobj.%Get(i-1)."type"
        s context=Operationobj.%Get(i-1)."context"
        continue:(context["详见")
    	if (type["operation")
    	{
	    	s OpeFlag=$tr(type,"operation","")
            	q:(OpeFlag="+")
		}
		s operation=Operationobj.%Get(i-1)."operation"  //其他实体带手术属性的也算手术
		s:(type["+")&&(operation'="") OpeFlag="+"
        q:(OpeFlag="+")
   	}
   	
   	s SkinFlag=0
    for j=1:1:Skinobj.%Size()
   	{
        s signvalue= Skinobj.%Get(j-1).name
        s Desc=signvalue
        s type= Skinobj.%Get(j-1)."type"
        if (type["sign")&&((signvalue["疤痕")||(signvalue["瘢痕"))
    	{
            s:(signvalue["手术") SkinFlag=$e(type,1,1)
	    }
    	q:(SkinFlag'=0)
   	}
	if ((SkinFlag="+")&&(OpeFlag'="+"))
	{
		s xbs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,xbsID,"")
		q:($g(^CacheTempResponseFlag(Uniquekey))=0) 1
		s xbsStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(xbs,Uniquekey)
		q:($g(^CacheTempResponseFlag(Uniquekey))=0) 1
		q:(xbsStr="") 1
		s xbsobj={}.%FromJSON(xbsStr)
		for i=1:1:xbsobj.%Size()
		{
		    s type= xbsobj.%Get(i-1)."type"
		    s context=xbsobj.%Get(i-1)."context"
            
		    if (type["operation")
		    {
		        s OpeFlag=$tr(type,"operation","")
		        q:(OpeFlag="+")
		    }
		    q:(OpeFlag="+")
		}
	}
   	//s:(OpeFlag="+")&&(SkinFlag=0) ret=-1_"#@"_InstanceID
   	s:(SkinFlag="+")&&(OpeFlag'="+") ret=-1_"#@"_InstanceID_$c(0)_ElementCode_$c(0)_Desc
	
   	q ret
}

/// Desc:	入院记录.体格检查
/// Input:	AEpisodeID	就诊号	
/// 		AChartTemplate		
/// 		AElement 	体格检查
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck014(140004280,"1")
ClassMethod NLPCheck014(AEpisodeID As %String, AChartTemplate As %String, AElement As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s errInfo=""
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	q:(ElementData1="") 1
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	//以下情况按照医院模板调整
	s section = $p(ElementData1,"一般情况：",2),section = $p(section,"皮肤黏膜：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少一般情况"
	s section = $p(ElementData1,"皮肤黏膜：",2),section = $p(section,"淋 巴 结：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少皮肤黏膜"
	s section = $p(ElementData1,"淋 巴 结：",2),section = $p(section,"头颅五官：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少淋巴结"
	s section = $p(ElementData1,"头颅五官：",2),section = $p(section,"颈部：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少头颅五官"
	s section = $p(ElementData1,"颈部：",2),section = $p(section,"胸部：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少颈部"
	s section = $p(ElementData1,"胸部：",2),section = $p(section,"肺部：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少胸部"
	s section = $p(ElementData1,"肺部：",2),section = $p(section,"心脏：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少肺部"
	s section = $p(ElementData1,"心脏：",2),section = $p(section,"腹部：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少心脏"
	s section = $p(ElementData1,"腹部：",2),section = $p(section,"肛门及外生殖器：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少腹部"
	s section = $p(ElementData1,"肛门及外生殖器：",2),section = $p(section,"脊柱四肢：",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少肛门及外生殖器"
	s section = $p(ElementData1,"脊柱四肢：",2),section = $p(section,"神经系统",1),section=$tr(section," "),section=$tr(section,$c(10))
	s:(section="") errInfo=errInfo_"-缺少脊柱四肢"

	q:(errInfo="") 1
	s errInfo=-1_"#"_errInfo_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	
	q errInfo
}

/// Desc:	入院记录.专科体格检查
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement	专科体格检查 	
/// 		UniqueKey		
/// Output:	ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck015(55099391,"390|281\1264|738\1298|756\1300|757","3073|7359|6820|6266",1)
ClassMethod NLPCheck015(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, UniqueKey As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AElement="")||(AChartTemplate="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	q:(ElementID=0) ret
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	s ElementData1=$tr(ElementData1,"专 科 情 况",""),ElementData1=$tr(ElementData1,$c(10),""),ElementData1=$tr(ElementData1," 同上:：","")
    	q:(ElementData1="") "-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
	s Str = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
	s:(Str="") info="-无实质性内容"
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	首次病程病历特点未归纳或完全复制现病史
/// 		包括阳性发现和具有鉴别诊断意义的阴性症状和体征等。不能完全复制现病史
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		Abltd		病历特点code（首次病程）
/// 		Axbs		现病史code（入院记录）	
/// 		Asimilarity	重复率 0.95
/// 		Uniquekey	进程号,直接写UniqueKey即可	
/// 	如果单独使用条目配Abltd、Axbs即可,Abltdobj为空,如果减少调用次数Abltd、Axbs、Abltdobj都要传（文本内容用于查重复率）
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck016(EpisodeID,"392|4",8925,{RYChartTemplate},"2562|6863|6309|5755","1",UniqueKey)
ClassMethod NLPCheck016(AEpisodeID As %String, AChartTemplate As %String, Abltd As %String, BChartTemplate As %String, Axbs As %String, Asimilarity As %String, UniqueKey As %String) As %String
{
	s ret=0,errInfo=""
	q:(AEpisodeID="")||(Abltd="")||(AChartTemplate="")||(UniqueKey="") ret

	s BInstanceIDStr=..GetInstanceIDStr(AEpisodeID,BChartTemplate)
	s AInstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(AInstanceIDStr="") ret
	s bltdID=$p(Abltd,"|",$p(AInstanceIDStr,"^",2))
	s xbsID=$p(Axbs,"|",$p(BInstanceIDStr,"^",2))
	s InstanceID=$p(AInstanceIDStr,"^",1)
	s bltd=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,bltdID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(bltdID)
	s xbs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,xbsID,"")
	
	s startFlag=0,signFlag=0,symptomFlag=0 

	s similarity = ..GetTextSimilarity(bltd,xbs)
	s:(similarity>=Asimilarity) errInfo=errInfo_"-复制现病史过多"
	
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s signStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(bltd,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"	
 
	s signobj={}.%FromJSON(signStr)	
	for i=1:1:signobj.%Size()
	{
		s type=signobj.%Get(i-1)."type"
		s:(type["sign") signFlag=1
		s:(type["symptom")||(type["Accompony") symptomFlag=1
		q:(signFlag&&symptomFlag)
	}
	s:('signFlag)&&('symptomFlag) errInfo=errInfo_"-无体征或症状"
	
	s:(errInfo'="") ret="-1#"_errInfo_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	
	q ret
}

/// Desc:	术后首次病程记录 描述不清
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		Asj	手术时间
/// 		Assfs	手术方式
/// 		Amzfs	麻醉方式
/// 		Ajyjg	简要经过
/// 		Azd		术中诊断
/// 	 	Ashcs	术后处理措施
/// 		Azysx	术后注意事项
/// 		AElement	章节	
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck017(55031203,"392|17",9206,0,9206,9222,9225,9231,0,1)
ClassMethod NLPCheck017(AEpisodeID As %String, AChartTemplate As %String, Asj As %String, Assfs As %String, Amzfs As %String, Ajyjg As %String, Azd As %String, Ashcs As %String, Azysx As %String, UniqueKey As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s sjElementID=$p(Asj,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ssfsElementID=$p(Assfs,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s mzfsElementID=$p(Amzfs,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s jyjgElementID=$p(Ajyjg,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s zdElementID=$p(Azd,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s shcsElementID=$p(Ashcs,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s zysxElementID=$p(Azysx,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(sjElementID)
        s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s sj=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,sjElementID,InstanceID)
		s:(sj="") info=info_"-无手术时间"
		s ssfs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ssfsElementID,InstanceID)
		s:(ssfs="") info=info_"-无手术方式"
		s mzfs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,mzfsElementID,InstanceID)
		s:((mzfs'["麻")&&(mzfs'["阻滞")) info=info_"-无麻醉方式"
		
		s jyjgFlag=0
		s jyjg=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,jyjgElementID,InstanceID)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s jyjgStr=##Class(EMRservice.BL.CDSSService).ConvertPython(jyjg,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s jyjgObj={}.%FromJSON(jyjgStr)
		for i=1:1:jyjgObj.%Size()
	   	{
	    	s type=jyjgObj.%Get(i-1)."type"
	    	continue:(type="")
	    	s jyjgFlag=1
	    	q:(jyjgFlag=1)
	   	}
	   	s:(jyjgFlag=0) info=info_"-无简要经过"
	   	
	   	s zd=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,zdElementID,InstanceID)
		s:(zd="") info=info_"-无术中诊断"
		s shcs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,shcsElementID,InstanceID)
		s:(shcs="") info=info_"-无术后处理措施"
		s zysx=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,zysxElementID,InstanceID)
		s:(zysx="") info=info_"-无术后注意事项"
		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)	
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck017A(EpisodeID,"116|854","12927",UniqueKey)
ClassMethod NLPCheck017A(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, UniqueKey As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s AElementID=$p(AElement,"|",$p($p(InstanceIDStr,"\",j),"^",2))		
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(AElementID)
        s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,InstanceID)
		s timeFlag=0
		if (ElementData[":")
		{
		s time=$e(ElementData,($find(ElementData,":")-3),($find(ElementData,":")+1))	
		s:($p(time,":",1)<25)&&($p(time,":",1)<61) timeFlag=1
		}
		s:($l(ElementData,"-")>2) timeFlag=1
		s:(timeFlag=0) info=info_"-无手术时间"
	
		s:((ElementData'["麻")&&(ElementData'["阻滞")) info=info_"-无麻醉方式"
		
		s jyjgFlag=1	   	
	   	s:((ElementData'["术中见")&&(ElementData'["消毒")&&(ElementData'["予")&&(ElementData'["镜下见")&&(ElementData'["套扎")&&(ElementData'["涂抹")&&(ElementData'["退镜")&&(ElementData'["无法通过")&&(ElementData'["插入")&&(ElementData'["注入")&&(ElementData'["刺入")&&(ElementData'["进镜")&&(ElementData'["到达")&&(ElementData'["进针")&&(ElementData'["拔出")&&(ElementData1'["穿入")&&(ElementData'["穿出")&&(ElementData'["定位")&&(ElementData'["消毒铺巾")&&(ElementData'["浸润麻醉")&&(ElementData'["置入")&&(ElementData'["提插")&&(ElementData'["刺入")&&(ElementData'["切取")&&(ElementData'["取出")&&(ElementData'["拔除")&&(ElementData'["拨出")&&(ElementData'["灌注")&&(ElementData'["注射")) jyjgFlag=0
		if (jyjgFlag=0)
		{
			continue:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData,UniqueKey)
		continue:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s ElementObj ={}.%FromJSON(ElementStr)
		s errinfo=""
		
		s flag=..IsType(AEpisodeID,"operation_position","",ElementObj,UniqueKey)	
		s:(flag=1) jyjgFlag=1
		}
		s:(jyjgFlag=0) info=info_"-无简要经过"	   	
		s:((ElementData'["告知")&&(ElementData'["观察")&&(ElementData'["继续")&&(ElementData'["进食")&&(ElementData'["禁饮")&&(ElementData'["注意")&&(ElementData'["嘱")&&(ElementData'["密切观察")&&(ElementData'["建议")) info=info_"-未描述术后注意事项"
		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)	
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	入院记录.体格检查.体温与皮肤描述不一致
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AValue		正常体温 37
///         	ASign1      生命体征
///         	ASign2      皮肤粘膜
/// 		Uniquekey	进程号,直接写UniqueKey即可	
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck018(EpisodeID,{RYChartTemplate},"37.3","2731|7017|6478|5924","2766|7052|6513|5959",UniqueKey)
ClassMethod NLPCheck018(AEpisodeID As %String, AChartTemplate As %String, AValue As %String, ASign1 As %String, ASign2 As %String, UniqueKey As %String) As %String
{
	s ret=0
    	q:(AEpisodeID="")||(AValue="")||(ASign1="")||(ASign2="")||(AChartTemplate="")||(UniqueKey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s SignElement1=$p(ASign1,"|",$p(InstanceIDStr,"^",2))
    	s SignElement2=$p(ASign2,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s Sign1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,SignElement1,"")
	q:(Sign1="") "1"
    	s Sign2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,SignElement2,"")
    	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(SignElement2)
    	q:(Sign2="") "1"
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s SignStr1 = ##Class(EMRservice.BL.CDSSService).ConvertPython(Sign1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	q:(SignStr1="") "1"
	s Signobj1={}.%FromJSON(SignStr1)
	
	s value="",SkinFlag=0
	for i=1:1:Signobj1.%Size()
   	{
    	s type= Signobj1.%Get(i-1)."type"
    	if (type["sign")
    	{
	    	s signname=Signobj1.%Get(i-1)."sign_name"."name"
	    	q:(signname'="体温")&&(signname'="T") 
	    	s value=Signobj1.%Get(i-1)."sign_value"."name"
	    }
	    q:(value'="")
   	}
   	
	s:(value>AValue)&&(..IncludeAny(Sign2,"体温正常\皮肤温度正常")) ret=-1
	s:(value<=AValue)&&(..IncludeAny(Sign2,"温度过高\体温过高")) ret=-1
	s:(value>AValue)&&(SkinFlag=1) ret=-1
	s:(ret="-1") ret="-1#"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
   	q ret
}

/// Desc:	入院记录.病史陈述者
/// Input:	AEpisodeID	就诊号
/// 		AElement1	病史陈述者
/// 		AElement2	陈述者和患者的关系
/// 		Axbs		现病史
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck019(55026021,"390|281\1264|738\1298|756\1300|757","2540|6841|6287|5733",1,"2562|6863|6309|5755")
ClassMethod NLPCheck019(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, Axbs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AChartTemplate="")||(Axbs="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element1ID=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s Element2ID=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s xbsElement=$p(Axbs,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1ID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element1ID)
	q:(ElementData1="") ret
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2ID,"")
	s person="",ralative="",info=""
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	s PatientID = $p(objPaAdm,"^",1)
	s Name = $p($g(^PAPER(+PatientID,"ALL")),"^",1)
	s:(ElementData1=Name)||(ElementData1="本人")||(ElementData1="患者")||(ElementData1="患者本人") person=1
	s:(ElementData2["本人")||(ElementData2["患者") ralative=1
	s:((person=1)&&(ralative'=1)&&(ElementData2'="")) info=info_"-陈述者关系错误"
	
	s ageFlag=0
	s age=##Class(EPRservice.Quality.DataGather.AdmInfo).GetAge(AEpisodeID)
	s:(age<8)&&(person=1) ageFlag=1
	s Err=..contentConflict(AEpisodeID,xbsElement,"昏迷\神志不清\感觉性失语\痴呆\意识丧失\无意识",Element1ID,"本人\患者本人\患者姓名","","家属")
	s:(Err["-1")||(ageFlag=1) info=info_"-无完全民事行为能力的患者填为病史陈述者"  
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	
   	q ret
}

/// Desc:	AB文本描述冲突
/// 		---	无完全民事行为能力的患者填为病史陈述者（包含家属不判断）
/// Input:	AEpisodeID	就诊号
/// 		AElement1	A文本code
/// 		AText1		A冲突描述（描述1\描述1\...）
/// 		AElement2	B文本code
/// 		AText2		B冲突描述（描述1\描述1\...）
/// 		AExText		B包含此文本就不判断
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).Intension005(153991972,10300,"昏迷\神志不清\感觉性失语\痴呆\意识丧失\无意识",11169,"本人\患者本人\患者姓名")
ClassMethod contentConflict(AEpisodeID As %String, AElement1 As %String, AText1 As %String, AElement2 As %String, AText2 As %String, AText3 As %String, AExText As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AText1="")||(AElement2="") ret	
	s AElementDate1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s AElementDate2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:((AElementDate1="")||(AElementDate2="")) "1"
	q:(AElementDate2[AExText)&&(AExText'="") ret
	if (AText2["患者姓名")
	{
		s objPaAdm = $g(^PAADM(+AEpisodeID))
		s PatientID = $p(objPaAdm,"^",1)
		s Name = $p($g(^PAPER(+PatientID,"ALL")),"^",1)
		s AText2=$replace(AText2,"患者姓名",Name)
	}
	
	s flag=0,Desc=""
	for i=1:1:$l(AText1,"\")
	{
		s Text1=$p(AText1,"\",i)
		s:(AElementDate1[Text1) flag=1
		q:(flag=1)
	}
	q:(flag=0) "1"
	
	//不应包含，找到一个就错
	for j=1:1:$l(AText2,"\")
	{
		s Text2=$p(AText2,"\",j)
		q:(Text2="")
		s:(AElementDate2[Text2) ret=-1
		s Desc=Text2
		q:(ret=-1)
	}
	
	s flag1=0
	//应包含，找到一个就对
	for m=1:1:$l(AText3,"\")
	{
		s Text3=$p(AText3,"\",m)
		q:(Text3="")
		s:(AElementDate2[Text3) flag1=1
		q:(flag1=1)
	}
	s:(AText3'="")&&(flag1=0) ret=-1_$c(0)_Desc

	q ret
}

/// Desc:	首次病程记录 诊疗计划不全面、不具体
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	诊疗计划
/// 		UniqueKey
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck020(53411039,"392|4",8935,1)
ClassMethod NLPCheck020(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement1="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	q:(ElementData1["护理")||(ElementData1["监护")||(ElementData1["限期手术")||(ElementData1["注射")||(ElementData1["吸氧")||(ElementData1["辅查")||(ElementData1["辅助检查")||(ElementData1["予")||(ElementData1["治疗")||(ElementData1["监测")||(ElementData1["检查")||(ElementData1["关注")||(ElementData1["复查") 1
    q:((ElementData1["行")&&(ElementData1["术"))||((ElementData1["择期")&&((ElementData1["手术")||(ElementData1["化疗")))||((ElementData1["完善")&&(ElementData1["指标")) 1
    s flag=0
    q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	q:(ElementStr="") "1"
	s Elementobj={}.%FromJSON(ElementStr)	
	for i=1:1:Elementobj.%Size()
	{
		s type=Elementobj.%Get(i-1)."type"
		continue:((type'["Drug")&&(type'["operation")&&(type'["manipulation")&&(type'["Ris")&&(type'["Lis"))
		s flag=1
		q:(flag=1)
	}
	
    s:(flag=0) ret="-1#"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
    
    q ret
}

/// Desc:	日常病程无实质内容
/// Input:	AEpisodeID	就诊号
/// 		AValue		正常体温
/// 		AElement1	日常病程内容章节
/// 		Uniquekey	进程号,直接写Uniquekey即可	
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck021(153092623,11850,1)
ClassMethod NLPCheck021(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, UniqueKey As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
			s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
			s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
			s HappenDateTime = $zd($p(objInstanceData.HappenDate," ",1),3)_" "_$zt($e(objInstanceData.HappenTime,1,5),1)
			s info=""
			s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
			s Content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
			s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
			s:(Content="") info=info_"#"_HappenDateTime_"无内容"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
			continue:(Content="")
			q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
			s SignStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(Content,UniqueKey)
			q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
			s:(SignStr="") info=info_"#"_HappenDateTime_"-无实质性内容"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
			continue:(SignStr="")
	}
	s:(info'="") ret="-1"_info

	q ret
}

/// Des:入院记录.现病史.缺一般情况描述或描述不全面
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement	现病史
/// 		Uniquekey	进程号,直接写Uniquekey即可	
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck022(54845484,"390|281\1264|738\1298|756\1300|757","2562|6863|6309|5755",1)
ClassMethod NLPCheck022(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement="")||(UniqueKey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s des=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	q:((des["发病以来")||(des["起病以来")||(des["患病以来")) 1
	s ret=..IsType(AEpisodeID,"generalstatus",ElementID,"",UniqueKey)
	s:(ret="-1") ret="-1#"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	日常病程 重要检查结果未在病程记录中体现 CT MRI
/// Input:	AEpisodeID	就诊号
/// 		AElement1	内容章节
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck023(153247784,11850,1,"检查CT\检查MRI")
ClassMethod NLPCheck023(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, ARCCode As %String) As %String
{

	s ret=0,Info="",Content="",nameInfo=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="")||(ARCCode) ret
	s DrugInfo=""
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	s InstanceIDStr=InstanceIDStr
	
	//CT MRI
	//根据就诊号返回ct\MRI项目的信息：名称^2021-01-02 00:01:10\名称^2021-01-02 00:01:10,多个CT用“\”隔开
	s CTInfo=##class(EPRservice.Quality.DataGather.AdmInfo).GetLisInfoByARCCodeEpisodeID(AEpisodeID,ARCCode)
	for i=1:1:$l(CTInfo,"\")
	{
	s CTflag=0
	s ctInfo=$p(CTInfo,"\",i)
	continue:ctInfo=""
	s ctDesc=$p(ctInfo,"^",1)
	s ctTime=$zdh($p($p(ctInfo,"^",2)," ",1),3)
	continue:(ctTime="")
		for j=1:1:$l(InstanceIDStr,"\")
		{
			s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
			continue:InstanceID=""
			s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
			s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
			s dataTime=$p(objInstanceData.HappenDate," ",1)
			//continue:((dataTime<ctTime)||(dataTime-ctTime>3))  若要求时间在三天内放开此段
			continue:(dataTime<ctTime)
			s HappenDateTime = $zd($p(objInstanceData.HappenDate," ",1),3)_" "_$zt($e(objInstanceData.HappenTime,1,5),1)
			s Content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
			continue:(Content'[ctDesc)
			s CTflag=1
			q
			
		}
	s:(CTflag=0) Info=Info_"#"_ctInfo
	//s:(CTflag=1) Info=Info_"----"_ctInfo
	}
	
	s:(Info'="") ret="-1"_$tr(Info,"^"," ")
	q ret
}

/// Desc:	危急值记录.危急值报告对检查结果异常未做处理
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		Element1	危急值内容
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck024(55168886,"392|529\392|537","9098|9111",1)
ClassMethod NLPCheck024(AEpisodeID As %String, AChartTemplate As %String, Element1 As %String, UniqueKey As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(Element1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
        s flag=0
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
        s ElementID=$p(Element1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s Title=objInstanceData1.Title
		continue:(Title'["危急值")
		s Data1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
    	s:((Data1["考虑")||(Data1["检查")||(Data1["继续")||(Data1["会诊")||(Data1["出院")||(Data1["嘱")||(Data1["拟")||(Data1["暂无")||(Data1["完善")||(Data1["处理")||(Data1["观察")||(Data1["密切")||(Data1["密观")||(Data1["遵执")||(Data1["暂不")||(Data1["复查")||(Data1["加强")||(Data1["继续")||(Data1["持续")||(Data1["治疗")||(Data1["予")||(Data1["故")||(Data1["调整")||(Data1["加用")||(Data1["加用")) flag=1
        if (flag=0)  
        { 
            q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
            s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(Data1,UniqueKey)
            q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
            continue:(ElementStr="")
            s Elementobj={}.%FromJSON(ElementStr)   
            for i=1:1:Elementobj.%Size()
            {
                s type=Elementobj.%Get(i-1)."type"
                continue:((type'["Drug")&&(type'["operation")&&(type'["manipulation"))
                s flag=1
                q:(flag=1)
            }
        }
   		s:(flag=0) info=info_"#"_HappenDateTime1_"@"_InstanceID_$c(0)_ElementCode_$c(0) 
	}
	s:(info'="") ret=-1
	
	q ret_info
}

/// Desc:	危急值记录.危急值报告未处理相应危急值
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate		
/// 		Element1	危急值内容
/// Output:	ret<0 违反规则  接口 
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck025(153762314,"",11863)
ClassMethod NLPCheck025(AEpisodeID As %String, AChartTemplate As %String, AElement As %String) As %String
{
	s result = "0",errInfo = "",count = 0,CreateDate="",CreatDateTime=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement="") result
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate,"危急值")
	q:(InstanceIDStr="") result
	
	
	s checkDateTime=$p($h," ",1)_" "_$p($h," ",2)	
	s NowDateTime = $case("","":$zd(+$h,3)_" "_$zt($p($h,",",2),2),:"")
	
	s DateTimes=""
	//危急值记录接口
	s rset = ##Class(%ResultSet).%New("web.DHCAntCVService:GetReportDetails")
	s sc = rset.Execute(AEpisodeID)
	While rset.Next()
	{
		s CVDate = rset.Get("repDate")
		s CVTime = rset.Get("repTime")
		s DateTime=CVDate_" "_CVTime
		s CVResult=rset.Get("repResult")
		continue:($tr($p(CVResult,"参考范围：",2)," ","")="")
		s:(DateTimes'="") DateTimes=DateTimes_"\"_DateTime_"||"_CVResult
		s:(DateTimes="") DateTimes=DateTime_"||"_CVResult
	}
	q:(DateTimes="") result
	
	s timeList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(DateTimes,"\")
	s ConditionCount=$listlength(timeList)
	s info=""
	
	s result=1
	s ErrDes=""
	for ind = 1:1:$listlength(timeList)
     { 
       s flag=0
	   s tempDateTime = $listget(timeList,ind)
	   s TempDateTime=$p(tempDateTime,"||",1)
       s Des=$p(tempDateTime,"||",2)
       s ErrDes=Des
	   s TempDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(TempDateTime)
	   s tempDate=$p(TempDateTime," ",1)
	   s tempTime=$p(TempDateTime," ",2)
		for j=1:1:$l(InstanceIDStr,"\")
		{
			s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
				s ElementID=$p(AElement,"|",$p($p(InstanceIDStr,"\",j),"^",2))
			s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
			s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
			s Title=objInstanceData1.Title
			continue:(Title'["危急值")
			s RecordDateTime=$zd(objInstanceData1.HappenDate,3)_" "_$zt(objInstanceData1.HappenTime,1)		

			s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(RecordDateTime,TempDateTime)
			s time=##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(TempDateTime)
			continue:(+tempGap<-1)

			s wjzjl=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
			s wjzjl=$REPLACE(wjzjl,"/l","/L")  //单位大小写处理
			s wjzjl=$tr(wjzjl," ×^*","")  //特殊符号处理
			s Des=$p($p(Des,"：",3),"(",1)       //截取结果			
			s Des=$tr(Des," ^><","")	//特殊符号处理
			s ADes=$tr(Des,"秒","s")     //单位处理
			s ADes=$replace(ADes,".0","") //20.0 == 20  这种情况
			s BDes=$replace(Des,".00","") //20.00 == 20  这种情况
			s CDes=$replace(Des,"0","")  //20.10 == 20.1  这种情况
			s:((wjzjl[Des)||(wjzjl[ADes)||(wjzjl[BDes)||(wjzjl[CDes)) flag=1  //处理后有一种匹配上即可
			q:(flag=1)
		}
		s:(flag=0) info=info_"#"_time_ErrDes
		s:(info'="") result=-1
	 }
	s:(info="") result=1
	q result_info
}

// Desc:   危急值记录.危急值报告未处理相应危急值

/// Input:  AEpisodeID  就诊号
///         ATitles     "质控结构id|危急值"
///         Element1    危急值内容
/// Output: ret<0 违反规则  接口 
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck025A(54777957,"392|529\392|537","9098|9111",1)
ClassMethod NLPCheck025A(AEpisodeID As %String, AChartTemplate As %String, AValue As %String) As %String
{

    s ret=0,Info="",flag=0
    q:(AEpisodeID="")||(AChartTemplate="")||(AValue="") ret
    s DrugInfo=""
    s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
    
	//根据就诊号返回危急值的信息：危急值内容^2021-01-02 00:01:10\危急值内容^2021-01-02 00:01:10,多个危急值用“\”隔开
    s DateTimeInfos=##class(EPRservice.Quality.DataGather.AdmInfo).GetCVInfoByEpisodeID(AEpisodeID)

    for i=1:1:$l(DateTimeInfos,"\\\")
    {
        s info=""
        s DateTimeInfo=$p(DateTimeInfos,"\\\",i)
        s Time=$p(DateTimeInfo,"^^^",2)
        s ContentInfo=$p(DateTimeInfo,"^^^",1)
        s flag=0
        for j=1:1:$l(InstanceIDStr,"\")
        {
            s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
            s ElementID=$p(AValue,"|",$p($p(InstanceIDStr,"\",j),"^",2))
            s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
            s dataTime=$zd($p(objInstanceData.HappenDate," ",1),3)_" "_$zt(objInstanceData.HappenTime,1)
            s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dataTime,Time)
            
            continue:(+tempGap<-1)            
            s wjzjl=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
            
            s:(wjzjl[ContentInfo) flag=1  
            
            q:(flag=1)  
        }
        s:(flag=0) Info=Info_"#"_Time_" "_ContentInfo
    }
    
    s:(Info'="") ret="-1"_$tr(Info,"^","")
    q ret
}

/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).GetCriticalValueByEpisodeID(54777957)
ClassMethod GetCriticalValueByEpisodeID(AEpisodeID As %String)
{
    s ret="",DateTimes=""
    q:(AEpisodeID="") ret
    s LabNo=""
    for
    {
        s LabNo=$o(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIDLabNo"," "_AEpisodeID,LabNo))
        q:(LabNo="")
        s Valueid=""
        for{
            s Valueid=$o(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIDLabNo"," "_AEpisodeID,LabNo,Valueid))   
            q:(Valueid="")
            s valueobj=##class(EMRinstance.Events.CriticalValue).%OpenId(Valueid)
            s Content=valueobj.Content
            s CriticalValueDate=$zd(valueobj.CriticalValueDate,3)
            s CriticalValueTime=$zt(valueobj.CriticalValueTime,1)
            for i=2:1:$l("项目:")
            {
                s result=$p($p(Content,"结果:",i),",单位",1)
                s:(result[" ") result=$p(result," ",2)
                s:(result["，") result=$p(result,"，",1)
                s content=$p($p(Content,"项目:",i),",",1)_":"_result
                
            s:(DateTimes'="") DateTimes=DateTimes_"\"_CriticalValueDate_" "_CriticalValueTime_"|"_content
            s:(DateTimes="") DateTimes=CriticalValueDate_" "_CriticalValueTime_"|"_content
            }
        }
    }   
    s:(DateTimes'="") ret=DateTimes
    q ret
}

/// Desc:	内容相似度过高
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		Element1	
/// 		Similarity	相似度0.95
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck026(54692718,"392|537","9111","0.5")
ClassMethod NLPCheck026(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, Similarity As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement="")||(Similarity="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	s errorInfo = ""
	for i=1:1:$l(InstanceIDStr,"\")-1
	{
		s InstanceID1=$p($p(InstanceIDStr,"\",i),"^",1)
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		continue:(+$h-objInstanceData1.HappenDate)>30
		for j=i+1:1:$l(InstanceIDStr,"\")
		{
			s InstanceID2=$p($p(InstanceIDStr,"\",j),"^",1)
			s objInstanceData2 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID2)
			continue:(+$h-objInstanceData2.HappenDate)>30
			s ElementID1=$p(AElement,"|",$p($p(InstanceIDStr,"\",i),"^",2))
			s ElementID2=$p(AElement,"|",$p($p(InstanceIDStr,"\",j),"^",2))
			s text1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID1)
			s text2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,InstanceID2)
			s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID2)
			s similarity =..GetTextSimilarity(text1,text2) /// ..test1(text1,text2)
	
			if ((similarity>Similarity)||(similarity=Similarity))
			{
				s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
				s HappenDateTime2 = $zd($p(objInstanceData2.HappenDate," ",1),3)_" "_$zt($e(objInstanceData2.HappenTime,1,5),1)
				s errorInfo=errorInfo_"#-"_HappenDateTime1_"与"_HappenDateTime2_"@"_InstanceID1_$c(0)_ElementCode_$c(0)
			}
		}
	}
	
	q:(errorInfo="") 1
	q:(errorInfo'="") "-1"_errorInfo
}

/// Desc:	首次查房
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement2	病历特点
/// 		AElement3	入院诊断
/// 		AElement4	诊断依据及鉴别
/// 		AElement5	诊疗计划
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck027(152773486,"11891","11892","11893",11896,11897)
ClassMethod NLPCheck027(AEpisodeID As %String, AChartTemplate As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, AElement5 As %String, UniqueKey As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement2="")||(AElement3="")||(AElement4="")||(AElement5="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element2ID=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s Element3ID=$p(AElement3,"|",$p(InstanceIDStr,"^",2))
	s Element4ID=$p(AElement4,"|",$p(InstanceIDStr,"^",2))
	s Element5ID=$p(AElement5,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	
	s ElementDate2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2ID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element2ID)
	s tzflag=0
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr1 = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementDate2,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	q:(ElementStr1="") "1"
	s Elementobj1={}.%FromJSON(ElementStr1)	
	for J=1:1:Elementobj1.%Size()
	{
		s type=Elementobj1.%Get(J-1)."type"
		s:(type["sign") tzflag=1
		q:(tzflag=1)
	}
	s:(tzflag=0) info=info_"-无体征"
	
	s ElementDate3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element3ID,"")
	s:(ElementDate3="") info=info_"-无入院诊断"
	s ElementDate4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element4ID,"")
	s:('..IncludeAny(ElementDate4,"支持\证实\可见\提示\因\查体\检查\诊断成立\依据\故诊断\明确\可诊断\故考虑\需考虑")) info=info_"-无诊断依据"
	s:('..IncludeAny(ElementDate4,"鉴别\明确\排除")) info=info_"-无鉴别诊断分析"
	//诊疗计划
	s ElementDate5=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element5ID,"")
	s jhflag=0
	s:(..IncludeAny(ElementDate5,"护理\监护\注射\吸氧\辅查\辅助检查\予\治疗\监测\检查\关注\复查\诊疗计划\查房后\指示\拟\处理\建议\出院")) jhflag=1
	if (jhflag=0)
	{
	    q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
		s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementDate5,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
		q:(ElementStr="") "1"
		s Elementobj={}.%FromJSON(ElementStr)	
		for i=1:1:Elementobj.%Size()
		{
			s type=Elementobj.%Get(i-1)."type"
			continue:(type'["Drug")&&(type'["operation")&&(type'["Ris")&&(type'["Lis")
			s jhflag=1
			q:(jhflag=1)
		}
	}
	s:(jhflag=0) info=info_"-无诊疗计划"
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	上级医师查房记录
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	章节
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck028(55133147,"392|537\392|6","9111|1759")
ClassMethod NLPCheck028(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret

	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s Title=objInstanceData1.Title
		s Data1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
		s:((Data1'["建议")&&(Data1'["上级查房意见")&&(Data1'["予")&&(Data1'["考虑")&&(Data1'["计划")&&(Data1'["故")&&(Data1'["指示")&&(Data1'["指出")&&(Data1'["查房示")&&(Data1'["查房后")&&(Data1'["意见")&&(Data1'["治疗")&&(Data1'["出院")&&(Data1'["示")&&(Data1'["行")&&(Data1'["嘱")&&(Data1'["继续")&&(Data1'["拟")&&(Data1'["复查")&&(Data1'["择期手术")&&(Data1'["明日手术")&&(Data1'["会诊")&&(Data1'["处理：")&&(Data1'["训练")&&(Data1'["告知")&&(Data1'["监控")&&(Data1'["完善")&&(Data1'["加强")) info=info_"-无诊疗意见"
		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
		
		
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	抢救记录.描述不清（一坨）
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	章节
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck029(EpisodeID,"11910")
ClassMethod NLPCheck029(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, UniqueKey As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s timeFlag=0
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
		s ElementData1=$tr(ElementData1,"：",":")
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)

		if (ElementData1[":")
		{
		s time=$e(ElementData1,($find(ElementData1,":")-3),($find(ElementData1,":")+1))	
		s:($p(time,":",1)<25)&&($p(time,":",1)<61) timeFlag=1
		}
		s:($l(ElementData1,"-")>2) timeFlag=1
		s:(timeFlag=0) info=info_"-无抢救时间"
		s qjjg=0
        	s jgStr="成功\失败\死亡\无效\好转\缓解\顺利\抢救有效\密切\观察\密观\不适\关注\心跳停止\改善\安返\恢复\出院"
		for i=1:1:$l(jgStr,"\")
		{
			s jg=$p(jgStr,"\",i)
			s:(ElementData1[jg) qjjg=1
			
			q:(qjjg=1)		
		}
		if (qjjg=0)
		{
		    q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
			s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
			q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
			q:(ElementStr="") 
			s Elementobj={}.%FromJSON(ElementStr)	
			for i=1:1:Elementobj.%Size()
			{
				s type=Elementobj.%Get(i-1)."type"
				s:(type["+normalsign")||(type["emergency_result") qjjg=1
				q:(qjjg=1)
			}
		}
		s:(qjjg=0) info=info_"-无抢救结果"
		s csFlag=0
		s:((ElementData1["予")||(ElementData1["故")||(ElementData1["拒绝")||(ElementData1["输入")||(ElementData1["输注")||(ElementData1["心电监护")||(ElementData1["呼吸机")||(ElementData1["插管")) csFlag=1
		s:(csFlag=0) info=info_"-无抢救措施"
		s:((ElementData1["当班护士")||(ElementData1["在班护士")) info=info_"-参加抢救的医务人员姓名及专业技术职称不具体" 
		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
		
	}

	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:   抢救记录.描述不清（模板结构化）
/// Input:  AEpisodeID  就诊号
///         AChartTemplate
///         AElement1   抢救时间
///         AElement2   参加抢救的医务人员姓名及专业技术职称不具体
///         AElement3   抢救措施
///         AElement4   抢救结果
///         UniqueKey
/// Output: ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck029A(55368566,"392|317\392|558\392|537","9146|9126|9111","9149|9129|9111","9150|9130|9111","9151|9131|9111",1)
ClassMethod NLPCheck029A(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, UniqueKey As %String) As %String
{
    s ret=0,Info=""
    q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
    s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate,"抢救")
    q:(InstanceIDStr="") ret
    
    for j=1:1:$l(InstanceIDStr,"\")
    {
        s info=""
        s timeFlag=0
        s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
        s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
        s ElementID2=$p(AElement2,"|",$p($p(InstanceIDStr,"\",j),"^",2))
        s ElementID3=$p(AElement3,"|",$p($p(InstanceIDStr,"\",j),"^",2))
        s ElementID4=$p(AElement4,"|",$p($p(InstanceIDStr,"\",j),"^",2))
        s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
        s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
        
        s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID)
        s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1)
	s:('..IncludeDateTime(ElementData1)) info=info_"-无抢救时间"
        
        s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,InstanceID)
         s:(ElementData2="")||(..IncludeAny(ElementData2,"当班护士\在班护士"))||('..IncludeProfessionalTitle(ElementData2)) info=info_"-参加抢救的医务人员姓名及专业技术职称不具体"
    
        s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID3,InstanceID)
        s csFlag=0
        s:((ElementData3["予")||(ElementData3["治疗")||(ElementData3["故")||(ElementData3["拒绝")||(ElementData3["输入")||(ElementData3["输注")||(ElementData3["心电监护")||(ElementData3["呼吸机")||(ElementData3["插管")||(ElementData3["光疗")) csFlag=1
        if (csFlag=0)
        {
            q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
            s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData3,UniqueKey)
            q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
            q:(ElementStr="") 
            s Elementobj={}.%FromJSON(ElementStr)   
            for i=1:1:Elementobj.%Size()
            {
                s type=Elementobj.%Get(i-1)."type"
                s:(type["Drug")||(type["treatment") csFlag=1
                q:(csFlag=1)
            }
        }
        s:(csFlag=0) info=info_"-无抢救措施"
        
        s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID4,InstanceID)
        s qjjg=0
        s jgStr="成功\失败\死亡\无效\好转\缓解\顺利\抢救有效\密切\观察\密观\监测\不适\关注\心跳停止\改善\安全\安返\结果\出院"
        for i=1:1:$l(jgStr,"\")
        {
            s jg=$p(jgStr,"\",i)
            s:(ElementData4[jg) qjjg=1
            q:(qjjg=1)      
        }
         if (qjjg=0)
        {
            q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
            s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData4,UniqueKey)
            q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
            q:(ElementStr="") 
            s Elementobj={}.%FromJSON(ElementStr)   
            for i=1:1:Elementobj.%Size()
            {
                s type=Elementobj.%Get(i-1)."type"
                s:(type="+normalsign")||(type["emergency_result") qjjg=1 
                q:(qjjg=1)
            }
        }
	s:(qjjg=0) info=info_"-无抢救结果"
    s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
        
       
    }

    s:(Info'="") ret="-1"_Info
    q ret
}

/// Desc:	抢救记录 抢救用药
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	章节
/// 		UniqueKey
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck030(55133147,"392|317\392|558\392|537","9150|9130|9111",1)
ClassMethod NLPCheck030(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, UniqueKey As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		S Instanceobj = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDate = Instanceobj.HappenDate
		s HappenTime = Instanceobj.HappenTime
		continue:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
		continue:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s ElementObj ={}.%FromJSON(ElementStr)
		s errinfo=""
		
		for i=1:1:ElementObj.%Size()
		{
    		s type= ElementObj.%Get(i-1)."type"
    		continue:(type'["Drug")
    		s name = ElementObj.%Get(i-1)."name"
    		
    		continue:(ElementData1["暂停"_name)||(ElementData1["停止"_name)
    		s LSresult = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
			d LSresult.Execute(AEpisodeID,"","","","","","","","N")
			s flag=0
			while(LSresult.%Next())
			{
				s YZDrugName = LSresult.Data("ArcimDesc")
				s:((name["0.9%氯化钠")&&(YZDrugName["生理盐水"))||((name["生理盐水")&&(YZDrugName["0.9%氯化钠")) flag=1
				s:(YZDrugName[name) flag = 1
				q:(flag=1)	
			}
			continue:(flag=1)
			s CQresult = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
			d CQresult.Execute(AEpisodeID,"","","","","","","","S")
			while(CQresult.%Next())
			{
				s YZDrugName = CQresult.Data("ArcimDesc")
				s:((name["0.9%氯化钠")&&(YZDrugName["生理盐水"))||((name["生理盐水")&&(YZDrugName["0.9%氯化钠")) flag=1
				s:(YZDrugName[name) flag = 1
				q:(flag=1)
			}
			continue:(flag=1)
			s errinfo=errinfo_"-"_name
		}
		s:(errinfo'="") Info=Info_"#"_$zd(HappenDate,3)_" "_$zt(HappenTime,2)_"医嘱没有"_errinfo
	}

	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	疑难病例讨论记录描述不清
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	讨论日期
/// 		AElement2	主持人
/// 		AElement3	参加人员
/// 		AElement4	病情摘要
/// 		AElement5	总结
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck031(55043796,"392|7",9167,0,9167,9176,9184)
ClassMethod NLPCheck031(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, AElement5 As %String, AElement6 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="")||(AElement2="")||(AElement3="")||(AElement4="")||(AElement5="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementID2=$p(AElement2,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementID3=$p(AElement3,"|",$p($p(InstanceIDStr,"\",j),"^",2))
       		s ElementID4=$p(AElement4,"|",$p($p(InstanceIDStr,"\",j),"^",2))
        	s ElementID5=$p(AElement5,"|",$p($p(InstanceIDStr,"\",j),"^",2))
        	s ElementID6=$p(AElement6,"|",$p($p(InstanceIDStr,"\",j),"^",2))
	    	s objInstanceData1=##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	    	s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1)
		s:(ElementData1'["年")&&(ElementData1'["-") info=info_"-没有讨论日期"
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,InstanceID)
		s:(ElementData2="") info=info_"-没有主持人姓名及职务"
		if (ElementData2'="")
		{ 
			if (ElementData2'["、")&&(ElementData2'[",")&&(ElementData2'[",")
			{
				s name=ElementData2
				s:((name'["教授")&&(name'["主任")&&(name'["院长")) info=info_"-没有主持人职务(主任及以上)"
			}
			else 
			{
				s flag=0
				s ElementData2=$tr(ElementData2,"、","\"),ElementData2=$tr(ElementData2,",","\"),ElementData2=$tr(ElementData2,",","\")
				for i=1:1:$l(ElementData2,"\")
				{
					s name=$p(ElementData2,"\",i)
					s:((name'["教授")&&(name'["主任")&&(name'["院长")) flag=1
					//s:((name'["教授")&&(name'["主任")&&(name'["医师")&&(name'["护士")&&(name'["研究生")&&(name'["院长")&&(name'["规培生")&&(name'["实习")) flag=1
					q:(flag=1)
				}
				s:(flag=1) info=info_"-没有主持人职务(主任及以上)"
			}
		}
        	s ElementData3 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID3,InstanceID)
		s:(ElementData3="") info=info_"-没有参加人员姓名及职务"
		if (ElementData3'="")
		{
		if (ElementData3'["、")&&(ElementData3'[",")&&(ElementData3'[",")
		{
			
			s name=ElementData3
			s:((name'["教授")&&(name'["教师")&&(name'["主任")&&(name'["讲师")&&(name'["医师")&&(name'["护士")&&(name'["研究生")&&(name'["院长")&&(name'["规培生")&&(name'["实习")&&(name'["住院总")&&(name'["全体")&&(name'["研究员")&&(name'["研究员")&&(name'["部长")) info=info_"-没有参加人员职务"
			
		}
		else 
		{
			s flag=0
            		s ElementData3=$tr(ElementData3,",","\"),ElementData3=$tr(ElementData3,"，","\")
			for i=1:1:$l(ElementData3,"\")
			{
				s name=$p(ElementData3,"\",i)
				q:(name="")
                		s:((name'["教授")&&(name'["教师")&&(name'["主任")&&(name'["讲师")&&(name'["医师")&&(name'["护士")&&(name'["研究生")&&(name'["院长")&&(name'["规培生")&&(name'["实习")&&(name'["住院总")&&(name'["全体")&&(name'["研究员")&&(name'["医疗组")&&(name'["医生")&&(name'["部长")) flag=1
				q:(flag=1)	
			}
            		s:(flag=1) info=info_"-缺少参加人员职务"
		}
		}
	
       		s ElementData4 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID4,InstanceID)
		s:(ElementData4="") info=info_"-没有讨论意见"
		s ElementData5 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID5,InstanceID)
		s:(ElementData5="") info=info_"-没有病情摘要"
        	s ElementData6 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID6,InstanceID)
		s:(ElementData6="") info=info_"-没有总结"
		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	有创诊疗操作记录描述不清
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	文本内容
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck032(EpisodeID,"392|195",9195)
ClassMethod NLPCheck032(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
        s objInstanceData1=##class(EMRinstance.InstanceData).%OpenId(InstanceID)
        s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s outFlag=0
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
		if ((ElementData1["外出")||(ElementData1["步入")||(ElementData1["PICC")||(ElementData1["CVC")||(ElementData1["超声")||(ElementData1["镜"))
		{
			s outFlag=1	
		}
        	s timeFlag=..IncludeDateTime(ElementData1)
        	s:(timeFlag'=1) info=info_"-无操作时间"
		s:((outFlag=0)&&(ElementData1'["术中见")&&(ElementData1'["消毒")&&(ElementData1'["予")&&(ElementData1'["镜下见")&&(ElementData1'["套扎")&&(ElementData1'["涂抹")&&(ElementData1'["退镜")&&(ElementData1'["无法通过")&&(ElementData1'["插入")&&(ElementData1'["注入")&&(ElementData1'["刺入")&&(ElementData1'["进镜")&&(ElementData1'["到达")&&(ElementData1'["进针")&&(ElementData1'["拔出")&&(ElementData1'["穿入")&&(ElementData1'["穿出")&&(ElementData1'["定位")&&(ElementData1'["消毒铺巾")&&(ElementData1'["浸润麻醉")&&(ElementData1'["置入")&&(ElementData1'["提插")&&(ElementData1'["刺入")&&(ElementData1'["切取")&&(ElementData1'["取出")&&(ElementData1'["拔除")&&(ElementData1'["拨出")&&(ElementData1'["灌注")&&(ElementData1'["注射")) info=info_"-无操作步骤"
		s:((ElementData1'["顺利")&&(ElementData1'["平稳")&&(ElementData1'["再次出现")&&(ElementData1'["失败")&&(ElementData1'["成功")&&(ElementData1'["患者未诉")&&(ElementData1'["诉")&&(ElementData1'["不适")&&(ElementData1'["患者无")&&(ElementData1'["无特殊异常")&&(ElementData1'["安返病房")&&(ElementData1'["好转")&&(ElementData1'["密切")&&(ElementData1'["观察")&&(ElementData1'["关注")&&(ElementData1'["密观")&&(ElementData1'["不良反应")) info=info_"-未描述是否顺利及不良反应"
		//s:((ElementData1'["患者未诉")&&(ElementData1'["诉")&&(ElementData1'["不适")) info=info_"-未描述有无不良反应"
		s:((ElementData1'["告知")&&(ElementData1'["进食")&&(ElementData1'["禁饮")&&(ElementData1'["注意")&&(ElementData1'["嘱")&&(ElementData1'["嘱家属")&&(ElementData1'["密切观察")&&(ElementData1'["建议")) info=info_"-未描述术后注意事项"
		if (outFlag=1)
		{
			s:((ElementData1'["病房")&&(ElementData1'["转回")&&(ElementData1'["送")&&(ElementData1'["返")&&(ElementData1'["安返")&&(ElementData1'["恢复室")&&(ElementData1'["麻醉复苏室")&&(ElementData1'["ICU")) info=info_"-无返回病房时情况"
		}
        	s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	
	}
	
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	输血前九项检查 
/// Input:	AEpisodeID	就诊号		
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck033(55208055)
ClassMethod NLPCheck033(AEpisodeID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="") ret
	//输血时间接口 
    	s SXDateTime = ..GetFirstBloodTime(AEpisodeID)
	q:(SXDateTime="") 1
	//输血前九项检查医嘱项
	s JCDateTime = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(EpisodeID,"6146||1","1\6")
	s:(JCDateTime="") ret=-1
	s tempGap=1
	s:(JCDateTime'="") tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(SXDateTime,JCDateTime)
	s:(tempGap<0) ret=-1
	q ret
}

ClassMethod GetFirstBloodTime(AEpisodeID As %String) As %String
{
    s ret=""
    q:(AEpisodeID="") ret
    s rowid=""
    for{
        s rowid=$o(^Nur.BloodBagReciveI("PatInfo"," "_AEpisodeID,rowid))
        q:(rowid="")
        s BloodObj=##class(Nur.BloodBagRecive).%OpenId(rowid)
        s Date=BloodObj.TransStartDate
        continue:(Date="")
        S Time=BloodObj.TransStartTime  
        s ret=$zd(Date,3)_" "_$zt(Time,1)
        q:(ret'="")
    }
    q ret
}

/// Desc:   术后首次病程记录.未描述是否安返病房
/// Input:  AEpisodeID  就诊号
///         AChartTemplate
///         AElement1   文本内容
/// Output: ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck034(55016265,"392|17",9231)
ClassMethod NLPCheck034(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s flag=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)

		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
        s:((ElementData["病房")||(ElementData["死亡")||(ElementData["转回")||(ElementData["送")||(ElementData["返")||(ElementData["安返")||(ElementData["恢复室")||(ElementData["麻醉复苏室")||(ElementData["ICU")) flag=1
	
		s:(flag'=1) Info=Info_"#"_HappenDateTime1_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	}
	
	s:(Info'="") ret="-1"_Info
	
	q ret
}

/// Desc:	手术记录 基本信息
/// Input:	AEpisodeID	就诊号
/// 		AElement1	
/// Output:	ret<0 违反规则11965
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck035(153428537,11965,11975,11976,11977,11967,11969,11972,11973,11968,11970,11971)
ClassMethod NLPCheck035(AEpisodeID As %String, AChartTemplate As %String, Axm As %String, Axb As %String, Anl As %String, Acwh As %String, Ays As %String, Asslx As %String, Asslb As %String, Assrq As %String, StartDateTime As %String, EndDateTime As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s RY = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegTime1(AEpisodeID)
	s CY = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime2(AEpisodeID)
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s xmElementID=$p(Axm,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s xbElementID=$p(Axb,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s nlElementID=$p(Anl,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s cwhElementID=$p(Acwh,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ysElementID=$p(Ays,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s sslxElementID=$p(Asslx,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s sslbElementID=$p(Asslb,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ssrqElementID=$p(Assrq,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s StartElementID=$p(StartDateTime,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s EndElementID=$p(EndDateTime,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(xmElementID)
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s info=""
		s xm=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,xmElementID,InstanceID)
		s:(xm="") info=info_"-姓名"
		s xb=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,xbElementID,InstanceID)
		s:(xb="") info=info_"-性别"
		s nl=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,nlElementID,InstanceID)
		s:(nl="") info=info_"-年龄"
		s cwh=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,cwhElementID,InstanceID)
		s:(cwh="") info=info_"-床号"
	    s ys=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ysElementID,InstanceID)
        s:(ys="")&&(ysElementID'="") info=info_"-主管医师"
        s sslx=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,sslxElementID,InstanceID)
        s:(sslx="")&&(sslxElementID'="") info=info_"-手术类型"
        s sslb=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,sslbElementID,InstanceID)
        s:(sslb="")&&(sslbElementID'="") info=info_"-手术类别"
		s ssrq=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ssrqElementID,InstanceID)
		s:(ssrq="")&&(ssrqElementID'="") info=info_"-手术日期"
		s SD = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,StartElementID,InstanceID)
		s:(SD="")&&(StartElementID'="") info = info_"-无开始时间"
		s ED = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,EndElementID,InstanceID)
		s:(ED="")&&(EndElementID'="") info = info_"-无结束时间"
		if (SD'="")&&(ED'="")
		{
			s result =##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(SD,ED)
			s:(result>=0) info=info_"-开始时间大于结束时间"
			s result1 =##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(SD,RY)
			s:(result1<=0) info=info_"-开始时间小于入院时间"
			s result2 = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ED,RY)
			s:(result2<=0) info=info_"-结束时间小于入院时间"
			if (CY'="")
			{
				s result3=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(SD,CY)
				s:(result3>=0) info=info_"-开始时间大于出院时间"
				s result4=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ED,CY)
				s:(result4>=0) info=info_"-结束时间大于出院时间"
			}
		}
		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	手术记录 内容描述不清
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		Asqzd	术前诊断
/// 		Assmc	手术名称
/// 		Amz		麻醉方法
/// 		Assjg	手术经过
/// 		Asscl	手中出现的情况及处理
/// 		Aszzd	术中诊断
/// 		AElement1	讨论日期
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck036(55190402,"434|314\451|318","9256|9355","9274|9376","9314|9416","9325|9427","9324|9426","9321|9423")
ClassMethod NLPCheck036(AEpisodeID As %String, AChartTemplate As %String, Asqzd As %String, Assmc As %String, Amz As %String, Assjg As %String, Asscl As %String, Aszzd As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret

	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s sqzdElementID=$p(Asqzd,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ssmcElementID=$p(Assmc,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s mzElementID=$p(Amz,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ssjgElementID=$p(Assjg,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ssclElementID=$p(Asscl,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s szzdElementID=$p(Aszzd,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(sqzdElementID)
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s sqzd=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,sqzdElementID,InstanceID)
		s:(sqzd="") info=info_"-术前诊断"
		s ssmc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ssmcElementID,InstanceID)
		s:(ssmc="") info=info_"-手术名称"
		s mz=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,mzElementID,InstanceID)
		s:((mz'["麻")&&(mz'["阻滞")) info=info_"-麻醉方法"
		s ssjg=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ssjgElementID,InstanceID)
		s:(ssjg="") info=info_"-手术经过"
		s sscl=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ssclElementID,InstanceID)
		s:(sscl="") info=info_"-手中出现的情况及处理"
		s szzd=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,szzdElementID,InstanceID)
		s:(szzd="") info=info_"-术中诊断"

		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	术前小结 描述不清
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck037(EpisodeID,12050,12051,12054,12055,12056,12059,12062,12065)
ClassMethod NLPCheck037(AEpisodeID As %String, AChartTemplate As %String, Ajybq As %String, Asqzd As %String, Azdyj As %String, Asszz As %String, Assmc As %String, Amzfs As %String, Assrq As %String, Azysx As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s jybqElementID=$p(Ajybq,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s sqzdElementID=$p(Asqzd,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s zdyjElementID=$p(Azdyj,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s sszzElementID=$p(Asszz,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ssmcElementID=$p(Assmc,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s mzfsElementID=$p(Amzfs,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ssrqElementID=$p(Assrq,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s zysxElementID=$p(Azysx,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(jybqElementID)
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)

		s jybq=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,jybqElementID,InstanceID)
		s:(jybq="")&&(jybqElementID'="") info=info_"-简要病情"
		s sqzd=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,sqzdElementID,InstanceID)
		s:(sqzd="") info=info_"-术前诊断"
		s zdyj=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,zdyjElementID,InstanceID)
		s:(zdyj="") info=info_"-诊断依据"
		s sszz=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,sszzElementID,InstanceID)
		s:(sszz="") info=info_"-手术指征"
		s ssmc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ssmcElementID,InstanceID)
		s:(ssmc="") info=info_"-拟施手术名称和方式"
		s mzfs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,mzfsElementID,InstanceID)
		s:(mzfs="") info=info_"-拟施麻醉方式"
		s ssrq=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ssrqElementID,InstanceID)
		s:(ssrq="") info=info_"-拟手术日期"
		s zysx=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,zysxElementID,InstanceID)
		s:(zysx="") info=info_"-注意事项"
		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)	
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	手术记录 签名 
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	术者
/// 		AElement2	手术记录签名
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck038(EpisodeID,"434|314\451|318","9299|9401","9327|9429")
ClassMethod NLPCheck038(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementID2=$p(AElement2,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)

		s Data1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID)
		s Data2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID2)
		s Data1=$p(Data1,"、",1)
        s:(Data2'[Data1) info="-不是主刀医生"
        s:(Data2="") info="-未签名"  
        s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	出院记录.出院诊断填写错误
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	出院诊断章节
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck039(54800098,"426|24","9043")
ClassMethod NLPCheck039(AEpisodeID As %String, AChartTemplate As %String, AElement As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	q:(ElementData1="") "-1#-出院记录出院诊断未填"
	s ElementData1=$tr(ElementData1,$c(10)," ")
	s ElementData1=$tr(ElementData1,"。","")
	
	s DiagnosStr="",info=""
	
	s num=0
	s mradm=$p(^PAADM(AEpisodeID),"^",61)
	
	s result = ##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	d result.Execute(mradm)
	while result.%Next()
	{
		s DiagnosType=result.Data("DiagnosType")
		continue:(DiagnosType'="出院诊断")
		s DiagnosICDDesc=result.Data("DiagnosNotes")
		s MainDiagFlag=result.Data("MainDiagFlag")
		s DiagnosICDDesc=..filterBrackets(DiagnosICDDesc)
		if (MainDiagFlag="是") 
		{
			s MainDiag=$tr(DiagnosICDDesc," ","")
			s writeMainDiag=$tr(..filterBrackets(..GetInfoAround(ElementData1,"1.","2."))," ","")	
			s:(writeMainDiag'=MainDiag) info=info_"-主要诊断错误"
			
		}else{
			s:($tr(ElementData1," ","")'[$tr(DiagnosICDDesc," ","")) info=info_"-遗漏"_DiagnosICDDesc

		}
		s:(DiagnosStr'="")&&(MainDiagFlag="否") DiagnosStr=DiagnosStr_" "_num_"."_DiagnosICDDesc
		s:(DiagnosStr="")&&(MainDiagFlag="否") DiagnosStr=num_"."_DiagnosICDDesc
		
		s num=num+1
	}

	q:(num=0) "-1#-未下出院诊断@"_InstanceID_$c(0)_ElementCode_$c(0)
	s:(ElementData1[((num+1)_".")) info=info_"-比所下的诊断多"
   	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
   	
	q ret
}

/// Desc:	出院记录.无出院医嘱或出院医嘱不全
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement	出院医嘱章节
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck040(54962351,"426|24","9046")
ClassMethod NLPCheck040(AEpisodeID As %String, AChartTemplate As %String, AElement As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
	d result.Execute(AEpisodeID,"","","","","","","","O")
	s medinfo=""
	//出院带药为基准,医嘱的包含简写不能识别
	while result.%Next()
	{
		s flag=0
		s Medicine=result.Data("ArcimDesc")
		s Mdname=$p($p(Medicine,"[",1),"(",1)
		s:(Mdname["钙片") Mdname=$replace(Mdname,"钙片","")
		s Mdname=$tr(Mdname,"片","")
		s:(Mdname["胶囊") Mdname=$replace(Mdname,"胶囊","")
		s:(Mdname["颗粒") Mdname=$replace(Mdname,"颗粒","")
		s:(Mdname["冲剂") Mdname=$replace(Mdname,"冲剂","")
		s AMdname=$p($p(Medicine,"〔",1),"(",1)
		s medinfo=medinfo_","_AMdname
		s:((ElementData1'[Mdname)&&(ElementData1'[AMdname)) flag=1
		s:(flag=1) info=info_","_Medicine
	}
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	
	q ret
}

/// Desc:	出院记录 缺项或内容不全
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	入院时间
/// 		AElement2	出院时间
/// 		AElement3	入院诊断
/// 		AElement4	诊疗经过
/// 		AElement5	出院情况
/// 		AElement6	出院诊断
/// 		AElement7	出院医嘱
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck041(55053899,"426|24",9031,9027,9039,9042,0,9043,9046)
ClassMethod NLPCheck041(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, AElement5 As %String, AElement6 As %String, AElement7 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s ElementID2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s ElementID3=$p(AElement3,"|",$p(InstanceIDStr,"^",2))
	s ElementID4=$p(AElement4,"|",$p(InstanceIDStr,"^",2))
	s ElementID5=$p(AElement5,"|",$p(InstanceIDStr,"^",2))
	s ElementID6=$p(AElement6,"|",$p(InstanceIDStr,"^",2))
	s ElementID7=$p(AElement7,"|",$p(InstanceIDStr,"^",2))
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1)
	s InstanceID=$p(InstanceIDStr,"^",1)
	s info=""
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,"")
	s ElementData1=$tr(ElementData1," ","")
	s:(ElementData1="") info=info_"-入院时间"
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,"")
	s ElementData2=$tr(ElementData2," ","")
	s:(ElementData2="") info=info_"-出院时间"
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID3,"")
	s ElementData3=$tr(ElementData3," ","")
	s:(ElementData3="") info=info_"-入院诊断"
	s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID4,"")
	s ElementData4=$tr(ElementData4," ","")
	s:(ElementData4="") info=info_"-诊疗经过"
	s ElementData5=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID5,"")
	s ElementData5=$tr(ElementData5," ","")
	s:(ElementData5="") info=info_"-出院情况"
	s ElementData6=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID6,"")
	s ElementData6=$tr(ElementData6," ","")
	s:(ElementData6="") info=info_"-出院诊断"
	s ElementData7=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID7,"")
	s ElementData7=$tr(ElementData7," ","")
	s:(ElementData7="") info=info_"-出院医嘱"
	
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	出院记录 治疗经过不详细
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	治疗经过章节
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck042(54941668,"426|24",9042)
ClassMethod NLPCheck042(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	
	s info="",csFlag=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	s:(ElementData1'["予")&&(ElementData1'["术")&&(ElementData1'["植入")&&(ElementData1'["造影")&&(ElementData1'["化疗")&&(ElementData1'["放疗")&&(ElementData1'["免疫治疗")&&(ElementData1'["透析")&&(ElementData1'["视频脑电")&&(ElementData1'["暂不处理")&&(ElementData1'["注射")&&(ElementData1'["日行")&&(ElementData1'["后行")&&(ElementData1'["拒绝") csFlag=0
	if (csFlag=0)
	{
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s ElementStr = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		q:(ElementStr="") 
		s Elementobj={}.%FromJSON(ElementStr)   
		for i=1:1:Elementobj.%Size()
		{
			s type=Elementobj.%Get(i-1)."type"
			s:(type["Drug")||(type["treatment") csFlag=1
			q:(csFlag=1)
		}
	}
	s:(csFlag=0) info=info_"-无治疗措施"
	//s:(ElementData1'["好转")&&(ElementData1'["改善")&&(ElementData1'["缓解")&&(ElementData1'["稳定")&&(ElementData1'["拒绝")&&(ElementData1'["出院")&&(ElementData1'["恢复良好") info=info_"-无治疗效果"
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	出院记录 出院带药不正确
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement	出院带药章节
/// 		UniqueKey
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck043(EpisodeID,"426|24",9046,UniqueKey)
ClassMethod NLPCheck043(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s json = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s Json ={}.%FromJSON(json)
	s Info=""
	for i=1:1:Json.%Size()
	{
		s info=""
		s type = Json.%Get(i-1)."type"
		continue:(type'["Drug")
		s drugname = Json.%Get(i-1)."name"
		s usage = Json.%Get(i-1)."usage"
		s:(usage="") info=info_"无服药方式,"
		s dosage = Json.%Get(i-1)."dosage"
		s:(dosage="") info=info_"无服药剂量,"
		s frequency = Json.%Get(i-1)."frequency"
		s:(frequency="") info=info_"无服药频次,"
		s:(info'="") Info=Info_"-"_drugname_":"_info
	}
	s:(Info'="") ret="-1#"_Info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	
	q ret
}

/// Desc:	死亡记录 描述不清
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement	
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck044(EpisodeID,10549,10562,10563,10566,10567,10568)
ClassMethod NLPCheck044(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, AElement5 As %String, AElement6 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s ElementID2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s ElementID3=$p(AElement3,"|",$p(InstanceIDStr,"^",2))
	s ElementID4=$p(AElement4,"|",$p(InstanceIDStr,"^",2))
	s ElementID5=$p(AElement5,"|",$p(InstanceIDStr,"^",2))
	s ElementID6=$p(AElement6,"|",$p(InstanceIDStr,"^",2))
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
	s InstanceID=$p(InstanceIDStr,"^",1)
	s info=""
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementData=$tr(ElementData," ","")
	s:(ElementData="") info=info_"-死亡时间"
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,"")
	s ElementData2=$tr(ElementData2," ","")
	s:(ElementData2="") info=info_"-入院情况"
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID3,"")
	s ElementData3=$tr(ElementData3," ","")
	s:(ElementData3="") info=info_"-入院诊断"
	s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID4,"")
	s ElementData4=$tr(ElementData4," ","")
	s:(ElementData4="") info=info_"-住院诊疗与抢救过程"
	s ElementData5=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID5,"")
	s ElementData5=$tr(ElementData5," ","")
	s:(ElementData5="") info=info_"-死亡原因"
	s ElementData6=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID6,"")
	s ElementData6=$tr(ElementData6," ","")
	s:(ElementData6="") info=info_"-死亡诊断"
	
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	死亡病例讨论记录 描述不清
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement	基本信息章节
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck045(154353574,12084,12091,12094,12097,12100,12103)
ClassMethod NLPCheck045(AEpisodeID As %String, AChartTemplate As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, AElement5 As %String, AElement6 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	s ElementID2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s ElementID3=$p(AElement3,"|",$p(InstanceIDStr,"^",2))
	s ElementID4=$p(AElement4,"|",$p(InstanceIDStr,"^",2))
	s ElementID5=$p(AElement5,"|",$p(InstanceIDStr,"^",2))
	s ElementID6=$p(AElement6,"|",$p(InstanceIDStr,"^",2))
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID2)
	s InstanceID=$p(InstanceIDStr,"^",1)
	s info=""
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,"")
	s:(ElementData2="") info=info_"-讨论时间"
	if (ElementData2'="")
	{
       	 	s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)	
		s result1 =##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ElementData2,HappenDateTime1)
		s:(result1>0) info=info_"-讨论时间大于标题时间"
	}
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID3,"")
	s ElementData3=$tr(ElementData3," ","")
	s:(ElementData3="") info=info_"-主持人"
	s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID4,"")
	s ElementData4=$tr(ElementData4," ","")
	s:(ElementData4="") info=info_"-参加人员"
	s ElementData5=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID5,"")
	s ElementData5=$tr(ElementData5," ","")
	s:(ElementData5="") info=info_"-病情摘要"
	s ElementData6=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID6,"")
	s ElementData6=$tr(ElementData6," ","")
	s:(ElementData6="") info=info_"-总结意见"
	
	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	病程记录标题时间应在入院时间和出院时间之内
/// Input:	AEpisodeID	就诊号
/// 		ChartItemID
/// 		RYDateTime	入院时间
/// 		CYDateTime	出院时间
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck046(54967307,392,"2021-05-28 15:27:00","65924 31549")
ClassMethod NLPCheck046(AEpisodeID As %String, ChartItemID As %String, RYDateTime As %String, CYDateTime As %String, ADay As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(ChartItemID="")||(RYDateTime="")||(CYDateTime="") ret
	s TheRecord = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ChartItemID,""))
	q:(TheRecord="") 1
	s errinfo=""
	s InstanceDataID=""
	for
	{
		s info=""
		s InstanceDataID=$o(^DHCEMRI.InstanceDataI("IdxECRecord",TheRecord,InstanceDataID))
		q:(InstanceDataID="")
		s obj=##class(EMRinstance.InstanceData).%OpenId(TheRecord_"||"_InstanceDataID)
		continue:(obj.Status'="Save")
		s timeGap1=##class(EPRservice.Quality.CommonHelper).GetDateTimeGap(obj.HappenDate_" "_obj.HappenTime,RYDateTime)
		s:(timeGap1<0) info=info_"日期小于入院日期"
		continue:(CYDateTime="")||(obj.Title["抢救记录")
		s timeGap2=##class(EPRservice.Quality.CommonHelper).GetDateTimeGap(obj.HappenDate_" "_obj.HappenTime,CYDateTime)
		s:(timeGap2>0)&&(ADay="") info=info_"日期大于出院日期"
		s:(timeGap2>(ADay*24))&&(ADay'="") info=info_"日期大于出院日期+"_ADay
		s:(info'="") errinfo=errinfo_"#"_$zd(obj.HappenDate,3)_obj.Title_info_"@"_TheRecord_"||"_InstanceDataID
	}
	q:(errinfo="") 1
	q -1_errinfo
}

/// Desc:	术前讨论 描述不清
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement	章节	
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck047(EpisodeID,12183,12184,12185)
ClassMethod NLPCheck047(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementID2=$p(AElement2,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementID3=$p(AElement3,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1)
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)

		s info=""
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID)
		s ElementData1=$tr(ElementData1," ","")
		s:(ElementData1="") info=info_"-讨论地点"
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,InstanceID)
		s ElementData2=$tr(ElementData2," ","")
		s:(ElementData2="") info=info_"-参加讨论者"
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID3,InstanceID)
		s ElementData3=$tr(ElementData3," ","")
		s:(ElementData3="") info=info_"-讨论结论"
		s:(info'="") Info=Info_"#"_HappenDateTime1_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)	
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	内容相似度过高
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate1
/// 		AElement1	内容1	
/// 		AChartTemplate2
/// 		AElement2	内容2
/// 		Similarity	相似度 0.95
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck048(EpisodeID,{RYChartTemplate},"2562|6863|6309|5755","392|8","9545","0.99")
ClassMethod NLPCheck048(AEpisodeID As %String, AChartTemplate1 As %String, AElement1 As %String, AChartTemplate2 As %String, AElement2 As %String, Similarity As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AElement1="")||(AElement2="")||(AChartTemplate2="")||(Similarity="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret
	s InstanceIDStr2=..GetInstanceIDStr(AEpisodeID,AChartTemplate2)
	q:(InstanceIDStr2="") ret
	s errorInfo = ""
	
	for i=1:1:$l(InstanceIDStr1,"\")
	{
		s InstanceID1=$p($p(InstanceIDStr1,"\",i),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr1,"\",i),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		for j=i:1:$l(InstanceIDStr2,"\")
		{
			s InstanceID2=$p($p(InstanceIDStr2,"\",j),"^",1)
			s ElementID2=$p(AElement2,"|",$p($p(InstanceIDStr2,"\",j),"^",2))
			s objInstanceData2 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID2)
			s text1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID1)
			s text2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,InstanceID2)
			s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID2)
			s similarity =..GetTextSimilarity(text1,text2) 
	
			if ((similarity>Similarity)||(similarity=Similarity))
			{
				s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
				s HappenDateTime2 = $zd($p(objInstanceData2.HappenDate," ",1),3)_" "_$zt($e(objInstanceData2.HappenTime,1,5),1)
				s errorInfo=errorInfo_"#-"_HappenDateTime2_"@"_InstanceID2_$c(0)_ElementCode_$c(0)
			}
			
		}
	}
	
	q:(errorInfo="") 1
	q:(errorInfo'="") "-1"_errorInfo
}

/// Desc:	入院记录.请核查初步诊断中的次要诊断是否遗漏疾病
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate1
/// 		AElement1	既往史	
/// 		AElement2	初步诊断
/// 		UniqueKey	
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck048(EpisodeID,{RYChartTemplate},"2562|6863|6309|5755","392|8","9545","0.99")
ClassMethod NLPCheck049(AEpisodeID As %String, AChartTemplate1 As %String, AElement1 As %String, AElement2 As %String, UniqueKey As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AElement1="")||(AElement2="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr="") ret
	s Element1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s Element2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element1)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s strjws = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s objjws={}.%FromJSON(strjws)

	s ret=1
	for i=1:1:objjws.%Size()
   	{
    	s type= objjws.%Get(i-1)."type"
    	continue:(type'="+disease")
    	s lasttime=objjws.%Get(i-1)."last_time"
    	continue:(lasttime="")
    	s name=objjws.%Get(i-1)."name"
		s name=$replace(name,"病史","")
    	continue:(ElementData2[name)
    	s:(info'="") info=info_"-"_name
    	s:(info="") info=name
   	}
   	s:(info'="") ret="-1#"_info_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	入院记录 初步诊断不含房颤，体格检查心率应等于脉搏
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate		
/// 		AElement1	入院记录-初步诊断
/// 		AElement2	入院记录-体格检查-生命体征
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck001(154909906,10299,"",10300,"",1)
ClassMethod NLPCheck050(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AChartTemplate="")||(UniqueKey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s ElementID2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,"")
	q:(ElementData1["房颤")||(ElementData1["房室颤动") ret
	s ElementData=""
	for j=1:1:$l(ElementID2,"\")
	{
	s ElementData=ElementData_##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementID2,"\",j),"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode($p(ElementID2,"\",j))
	}
	s ElementData=$tr(ElementData,$c(10),"")
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s Signobj={}.%FromJSON(ElementStr)

	s Pulsvalue="",Heartvalue=""
	for i=1:1:Signobj.%Size()
   	{
    	s type= Signobj.%Get(i-1)."type"
    	s signname= Signobj.%Get(i-1)."sign_name"."name"
    	if ((type["sign")&&((signname="脉搏")||(signname="P")))
    	{
	    	s Pulsvalue=Signobj.%Get(i-1)."sign_value"."name"
	    }
	    if ((type["sign")&&(signname="心率")||(signname="HR"))
    	{
	    	s Heartvalue=Signobj.%Get(i-1)."sign_value"."name"
	    }
	    q:((Pulsvalue'="")&&(Heartvalue'=""))
   	}
   	
	s:(Pulsvalue'="")&&(Heartvalue'="")&&(Pulsvalue'=Heartvalue) ret=-1
   	s:(ret="-1") ret="-1#@"_InstanceID_$c(0)_ElementCode_$c(0)_Heartvalue
   	q ret
}

/// Desc:	A含则B含(同一模板)
/// 		ChartTemplate模板中，AElement1包含AText时，AElement2不应包含BText1，AElement2应包含BText2
/// 		入院记录 诊断含肺部感染/肺炎，体格检查肺部应含啰音描述（气泡音、水泡音）
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate ChartTemplate
/// 		AElement1	诊断
/// 		AText		A含某描述（描述1\描述1\...）
/// 		AElement2	体格检查
/// 		BText1		B不应包含描述（描述1\描述1\...）
/// 		BText2		B应包含描述（描述1\描述1\...）
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLP).NLPCheck051(EpisodeID,{ChartTemplate},"初步诊断code","肺部感染\肺炎","体格检查code","","啰音\气泡音\水泡音")
ClassMethod NLPCheck051(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AText As %String, AElement2 As %String, BText1 As %String, BText2 As %String) As %String
{
	
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="")||(AElement2="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s ElementID2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID2)
	s InstanceID=$p(InstanceIDStr,"^",1)
	
	s retflag=..contentConflict(AEpisodeID,ElementID1,AText,ElementID2,BText1,BText2)
	s:(retflag["-1") ret="-1#@"_InstanceID_$c(0)_ElementCode_$c(0)_$p(retflag,$c(0),2)
	q ret
}

/// Desc:	病案首页 离院方式与出院记录不符
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate1 出院记录ChartTemplate
/// 		AElement1	诊疗计划
/// 		AChartTemplate2 首页ChartTemplate（定位在首页）
/// 		AElement2	首页离院方式
/// 		UniqueKey
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLP).NLPCheck050(151814225,10611,1,1,1)
ClassMethod NLPCheck052(AEpisodeID As %String, AChartTemplate1 As %String, AElement1 As %String, AChartTemplate2 As %String, AElement2 As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate1="")||(AElement1="")||(AChartTemplate2="")||(AElement2="")||(UniqueKey="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s InstanceIDStr2=..GetInstanceIDStr(AEpisodeID,AChartTemplate2)
	q:(InstanceIDStr2="") ret
	s ElementID2=$p(AElement2,"|",$p(InstanceIDStr2,"^",2))
	s InstanceID=$p(InstanceIDStr2,"^",1)
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,"")
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s json = ##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s Json ={}.%FromJSON(json)

	for i=1:1:Json.%Size()
	{
		s type = Json.%Get(i-1)."type"
		continue:(type'["leaving_mode")
		s name = Json.%Get(i-1)."name"
		s:(ElementData2'=name) ret=-1
		q:(ret=-1)
	}
	s:(ret=-1) ret=ret_"#@"_InstanceID
	q ret
}

/// Desc:	病案首页.检验报告提示的疾病未加入诊断
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	病案首页诊断描述id
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck053(156429991,”10052\10063\10064\10065\10066\10067\10068\10069\10070\10071\10072\10073”)
ClassMethod NLPCheck053(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s Jia="",Xhdb="",Zxlxb=""
	s LisInfo=##class(EPRservice.Quality.DataGather.AdmInfo).GetLisInfoByEpisodeID(AEpisodeID)
	for i=1:1:$l(LisInfo,"\")
	{
		s Lis=$p(LisInfo,"\",i)
		s ItemDesc=$p(Lis,"^",1)
		s ItemResult=$p(Lis,"^",2)
		s:(ItemDesc["钾") Jia=ItemResult,JiaInfo=ItemDesc_ItemResult
		s:(ItemDesc["血红蛋白") Xhdb=ItemResult,XhdbInfo=ItemDesc_ItemResult
		s:(ItemDesc["粒细胞")&&(ItemDesc["中性") Zxlxb=ItemResult,ZxlxbInfo=ItemDesc_ItemResult
	}
	s dataStr=""
	for j=1:1:$l(ElementID,"\")
	{
		s elementid=$p(ElementID,"\",j)
		s data=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,elementid,"")
		q:(data="")
		s datastr= dataStr_"\"_data
		
	}
	s:(Jia'="")&&(Jia>5.5)&&(datastr'["高钾血症") info=info_"#-"_JiaInfo_"建议诊断："_"高钾血症"_"@"_InstanceID
	s:(Jia'="")&&(Jia<3.5)&&(datastr'["低钾血症") info=info_"#-"_JiaInfo_"建议诊断："_"低钾血症"_"@"_InstanceID
	s:(Xhdb'="")&&(Xhdb>90)&&(Xhdb<100)&&(datastr'["轻度贫血") info=info_"#-"_XhdbInfo_"建议诊断："_"轻度贫血"_"@"_InstanceID
	s:(Xhdb'="")&&(Xhdb>60)&&(Xhdb<90)&&(datastr'["中度贫血") info=info_"#-"_XhdbInfo_"建议诊断："_"中度贫血"_"@"_InstanceID
	s:(Xhdb'="")&&(Xhdb>30)&&(Xhdb<59)&&(datastr'["重度贫血") info=info_"#-"_XhdbInfo_"建议诊断："_"重度贫血"_"@"_InstanceID
	s:(Xhdb'="")&&(Xhdb<30)&&(datastr'["极重度贫血") info=info_"#-"_XhdbInfo_"建议诊断："_"极重度贫血"_"@"_InstanceID
	s:(Zxlxb'="")&&(Zxlxb<0.5)&&(datastr'["粒细胞缺乏") info=info_"#-"_ZxlxbInfo_"建议诊断："_"粒细胞缺乏"_"@"_InstanceID
	s:(info'="") ret="-1"_info
	
	q ret
}

/// Desc:	病案首页.检验报告提示的疾病未加入诊断
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	病案首页诊断描述id
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck053A(390,"640|592","11280\11150\11173")
ClassMethod NLPCheck053A(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	
	s dataStr="\"
	for j=1:1:$l(ElementID,"\")
	{
		s elementid=$p(ElementID,"\",j)
		s data=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,elementid,"")
		q:(data="")
		s dataStr= dataStr_data_"\"		
	}
	s mCurrRow = $g(^PAADM(AEpisodeID))
	s PAPMIDR = $p($g(mCurrRow),"^",1)
	s RegNo=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
	// cdss诊断推荐
	s CDSSDiag=##class(web.CDSS.Public.MethodForWebservice).CallMethod("web.CDSS.IdentifyWords.GetPatientIW[A]GetRecomDisease[A]"_AEpisodeID_"^"_RegNo_"^1^住院^1^医生^1^信息科^1")
	s Obj ={}.%FromJSON(CDSSDiag)
	s ResultObj=Obj."InterfaceValue"
	q:(ResultObj="") ret
	for i=0:1:ResultObj.%Size()-1
	{
    	s ItemName = ResultObj.%Get(i)."ItemName"
    	//s ItemDesc = ResultObj.%Get(i)."ItemDesc"
    	s:(dataStr'[("\"_ItemName_"\")) info=info_"#-"_"建议诊断："_ItemName_"@"_InstanceID
	}

	s:(info'="") ret="-1"_$tr(info,"^","")
	
	q ret
}

/// Desc:	病案首页.饮食类医嘱包含糖尿病饮食，糖尿病未加入诊断
/// Input:	AEpisodeID	就诊号
/// 		AElement	糖尿病医嘱时间
/// 		AElement1	病案首页诊断描述id
/// 		AValue		诊断要包含的文字 (此条为"糖尿病")
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck054(156930469,"2021-08-10 00:12:23","","10052\10063\10064\10065\10066\10067\10068\10069\10070\10071\10072\10073","糖尿病")
ClassMethod NLPCheck054(AEpisodeID As %String, AElement As %String, AChartTemplate As %String, AElement1 As %String, AValue As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AElement1="") ret
	q:(AElement="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s flag=0
	for j=1:1:$l(ElementID1,"\")
	{
		s elementid=$p(ElementID1,"\",j)
		s data=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,elementid,"")
		continue:(data="")
		s:(data[AValue) flag=1
		q:(flag=1)
	}
	
	s:(flag=0) ret="-1#@"_InstanceID
	q ret
}

/// Desc:	病案首页.检查报告提示的疾病未加入诊断
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	病案首页诊断描述id
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck055()
ClassMethod NLPCheck055(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AElement1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s sgxdmbk="",qdmxz="",xqjy="",xbjy="",dnjs="",sngjs="",jdmxz="",zdmxz=""
	
	s ExamDesc = ##class(EPRservice.Quality.DataGather.AdmInfo).GetLisResultByEpisodeID(AEpisodeID)
	s:(ExamDesc["锁骨下动脉斑块") sgxdmbk=1
	s:(ExamDesc["髂动脉狭窄") qdmxz=1
	s:(ExamDesc["胸腔积液") xqjy=1
	s:(ExamDesc["心包积液") xbjy=1
	s:(ExamDesc["胆囊结石") dnjs=1
	s:(ExamDesc["输尿管结石") sngjs=1
	s:(ExamDesc["颈动脉狭窄") jdmxz=1
	s:(ExamDesc["椎动脉狭窄") zdmxz=1
	
	s str=0
	for j=1:1:$l(ElementID1,"\")
	{
		s elementid=$p(ElementID1,"\",j)
		s data=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,elementid,"")
		q:(data="")
		s str=str_"\"_data
	}
	s:(sgxdmbk=1)&&(str'["锁骨下动脉斑块") info=info_"#建议诊断："_"锁骨下动脉斑块"_"@"_InstanceID
	s:(qdmxz=1)&&(str'["髂动脉狭窄") info=info_"#建议诊断："_"髂动脉狭窄"_"@"_InstanceID
	s:(xqjy=1)&&(str'["胸腔积液") info=info_"#建议诊断："_"胸腔积液"_"@"_InstanceID
	s:(xbjy=1)&&(str'["心包积液") info=info_"#建议诊断："_"心包积液"_"@"_InstanceID
	s:(dnjs=1)&&(str'["胆囊结石") info=info_"#建议诊断："_"胆囊结石"_"@"_InstanceID
	s:(sngjs=1)&&(str'["输尿管结石") info=info_"#建议诊断："_"输尿管结石"_"@"_InstanceID
	s:(sngjs=1)&&(str'["颈动脉狭窄") info=info_"#建议诊断："_"颈动脉狭窄"_"@"_InstanceID
	s:(sngjs=1)&&(str'["椎动脉狭窄") info=info_"#建议诊断："_"椎动脉狭窄"_"@"_InstanceID
	s:(info'="") ret="-1"_info
	q ret
}

/// Desc:	病案首页多元素对比
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	A文本code（code1\code2\...）
/// 		AText1		A若包含描述（描述1\描述1\...）
/// 		AElement2	B文本code（code1\code2\...）若是A本身对比写"SAME"
/// 		AText2		B不应包含描述（描述1\描述1\...）
/// 		AText3		B应包含描述（描述1\描述1\...）
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck056(EpisodeID,{ChartTemplate},{手术名称code},"会阴裂伤缝合术",{首页诊断code},"会阴裂伤",1)
/// 	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck056(EpisodeID,{ChartTemplate},{手术名称code},"有创连续动脉血压监测","SAME","动脉插管","")
/// 	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck056(EpisodeID,{ChartTemplate},{手术名称code},"有创连续静脉血压监测","SAME","静脉插管","")
/// 		##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck056(EpisodeID,{ChartTemplate},{手术名称code},"盆腔粘连松解术\腹腔粘连松解术",{首页诊断code},"盆腔炎\盆腔粘连","")
ClassMethod NLPCheck056(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AText1 As %String, AElement2 As %String, AText2 As %String, AReverse As %String = "") As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret	
	s InstanceID=$p(InstanceIDStr,"^",1)
	
	s ElementID1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s ElementID2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s ElementData1="",ElementData2=""
	for i=1:1:$l(ElementID1,"\")
	{
		s ElementData1=ElementData1_"|"_##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementID1,"\",i),"")
		
	}
	if (AElement2="SAME")
	{
		s ElementData2=ElementData1
	}else{
		for j=1:1:$l(ElementID2,"\")
		{
			s ElementData2=ElementData2_"|"_##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementID2,"\",j),"")
			
		}
	}
	
	s flag=0
	for i=1:1:$l(AText1,"\")
	{
		s Text1=$p(AText1,"\",i)
		s:(ElementData1[Text1) flag=1
		q:(flag=1)
	}
	q:(flag=0) "1"
	
	s flag1=0
	//应包含，找到一个就对
	for m=1:1:$l(AText2,"\")
	{
		s Text2=$p(AText2,"\",m)
		q:(Text2="")
		s:(ElementData2[Text2) flag1=1
		q:(flag1=1)
	}
	
	s:(flag=1)&&(flag1=0) ret=-1
	s:(flag=0)&&(flag1=1)&&(AReverse=1) ret=-1
	
	s:(ret=-1) ret="-1#@"_InstanceID
	q ret
}

/// Desc:	会诊记录.未记录会诊意见 
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	内容章节	
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck057(21295661,"334|270","12076")
ClassMethod NLPCheck057(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{

	s ret=0,Info="",Content="",nameInfo=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s DrugInfo=""
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	s InstanceIDStr=InstanceIDStr
	
	s HZInfo=##Class(EPRservice.Quality.DataGather.AdmInfo).GetPatConsInfoByEpisodeID(AEpisodeID)
	for i=1:1:$l(HZInfo,"\")
	{
	s flag=0
	s info=$p(HZInfo,"\",i)
	s Time=$zdh($p($p(info,"^",1)," ",1),3)
	s timeInfo=$p(info,"^",1)
	s Desc=$p(info,"^",2)
	s LocDesc=$p(info,"^",3)
	s Desc=$tr(Desc,$c(10),""),Desc=$tr(Desc," ，。！",""),Desc=$replace(Desc,"谢邀",""),Desc=$replace(Desc,"谢谢",""),Desc=$replace(Desc,"病史敬阅",""),Desc=$replace(Desc,"病史同前","")
	// 若有处理关键字，截取有效内容匹配	
	s:(Desc["处理：") Desc=$p(Desc,"处理：",2) 
	s:(Desc["处置：") Desc=$p(Desc,"处置：",2) 
	s:(Desc["建议：") Desc=$p(Desc,"建议：",2)
	continue:(Time="")
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		continue:(InstanceID="")
		s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s dataTime=$p(objInstanceData.HappenDate," ",1)
		//continue:((dataTime<ctTime)||(dataTime-ctTime>3))
		//continue:(dataTime<Time)
		s HappenDateTime = $zd($p(objInstanceData.HappenDate," ",1),3)_" "_$zt($e(objInstanceData.HappenTime,1,5),1)
		s Content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s Content=$tr(Content,$c(10),""),Content=$tr(Content," ，。！",""),Content=$replace(Content,"病史敬阅",""),Content=$replace(Content,"谢邀",""),Content=$replace(Content,"谢谢","")
		
		s:(Content[Desc) flag=1
		if flag=0
		{
			s similar=..GetTextSimilarity(Desc,Content)
			s:(similar>0.5) flag=1				
		}
		q:flag=1
		
	}
	s:(flag=0) Info=Info_"#"_timeInfo_LocDesc_"会诊"
	}
	
	
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	病程记录.未记录病理结果 
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	内容章节	
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck058(21304330,"334|270","12076")
ClassMethod NLPCheck058(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{

	s ret=0,Info="",Content="",nameInfo=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
	s DrugInfo=""
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	s InstanceIDStr=InstanceIDStr
	
	//病理结果  接口：病理项目1^2022-01-01 01:00:00\病理项目2^2022-01-02 01:00:00
	s CTInfo=##class(EPRservice.Quality.DataGather.AdmInfo).GetPACSInfoByEpisodeID(AEpisodeID,"PIS")
	for i=1:1:$l(CTInfo,"\")
	{
		s CTflag=0
		s ctInfo=$p(CTInfo,"\",i)
		continue:(ctInfo="")
		s ctTime=$zdh($p($p(ctInfo,"^",2)," ",1),3)
		s ctName=$p(ctInfo,"^",1)
		continue:(ctTime="")
		for j=1:1:$l(InstanceIDStr,"\")
		{
			s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
			s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
			s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
			s dataTime=$p(objInstanceData.HappenDate," ",1)
			//continue:((dataTime<ctTime)||(dataTime-ctTime>3))			
			continue:(dataTime-ctTime<-1)
			s HappenDateTime = $zd($p(objInstanceData.HappenDate," ",1),3)_" "_$zt($e(objInstanceData.HappenTime,1,5),1)
			s Content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
			continue:(Content'[ctName)&&(Content'["病理结果")			
			s CTflag=1
			q		
		}
		s:(CTflag=0) Info=Info_"#-"_ctInfo	
	}
	
	s:(Info'="") ret="-1"_$tr(Info,"^","")
	q ret
}

/// Desc:	查房记录.标题医生和签名医生不一致 
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate1		查房记录
/// 		AElement1			签名
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck059(21728911,"334|270","12079")
ClassMethod NLPCheck059(AEpisodeID As %String, AChartTemplate1 As %String, AElement1 As %String) As %String
{
	s ret=0,Info="",info=""
	q:(AEpisodeID="")||(AChartTemplate1="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1,"查房记录")
	q:(InstanceIDStr1="") ret

	for j=1:1:$l(InstanceIDStr1,"\")
	{
		s InstanceID=$p($p(InstanceIDStr1,"\",j),"^",1)
		s ElementID1A=$p(AElement1,"|",$p($p(InstanceIDStr1,"\",j),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s Title=objInstanceData1.Title
		s:(Title["    ") Title=$p(Title,"    ",2) 
		s:(Title["代") Title=$p(Title,"代",1)
		s Name=""
		s:(Title["住院") Name=$p(Title,"住院",1)
		s:(Title["副主治") Name=$p(Title,"副主治",1)
		s:(Title["主治")&&(Title'["副主治") Name=$p(Title,"主治",1)
		s:(Title["副主任") Name=$p(Title,"副主任",1)
		s:(Title["主任")&&(Title'["副主任") Name=$p(Title,"主任",1)
		s:(Title["科主任") Name=$p(Title,"科主任",1)
		continue:(Name="")
		s Data1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1A,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1A)
	    s:(Data1'[Name) Info=Info_"#"_HappenDateTime1_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	入院记录.男性不能出现月经相关信息 
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	内容章节 入院记录1现病史^入院记录1既往史^入院记录1体格检查|入院记录2现病史^入院记录2既往史^入院记录2体格检查
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck060(EpisodeID,"879|96\7907|3223\7973|3318","10028^10029^10052|11799^11809^11829|11566^11587^11638",UniqueKey)
ClassMethod NLPCheck060(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, UniqueKey As %String) As %String
{

	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="")||(UniqueKey="") ret
	s sex=##Class(EPRservice.Quality.DataGather.AdmInfo).GetSex(AEpisodeID)
	q:(sex'="男") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)	
	
	for i=1:1:$l(Element,"^")
	{
		s element=$p(Element,"^",i)
		s flag=..IsType(AEpisodeID,"menstrualhistory",element,"",UniqueKey)
		s:flag=1 ret=-1
	}
	
	q ret
}

/// Desc:	女性不能出现男性特有体征描述
/// 		男性不能出现女性特有体征描述
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate	检测病历的ChartTemplateid
/// 		AElement1		需检测的章节  11019^18111^18181|18181^12828^19271
/// 		ASex			性别过滤
/// 		ADesc			不能包含的描述
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck061(EpisodeID,{ChartTemplateRY},"AElement1","男","阴道\外阴\会阴\阴蒂\阴唇\阴裂\处女膜\子宫\输卵管\宫颈\卵巢")
/// 		w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck061(EpisodeID,{ChartTemplateRY},"AElement1","女","阴茎\包皮\阴囊\精囊\前列腺\睾丸")
ClassMethod NLPCheck061(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, ASex As %String, ADesc As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(ASex="")||(ADesc="") ret
	s Sex=##Class(EPRservice.Quality.DataGather.AdmInfo).GetSex(AEpisodeID)
	q:(Sex'=ASex) ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		for m=1:1:$l(ElementID1,"\")
		{
			s element=$p(ElementID1,"\",m)
			s Data=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,element,InstanceID)
			s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(element)
			for i=1:1:$l(ADesc,"\")
			{
				if (Data[$p(ADesc,"\",i)) 
				{
					s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
					s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
					s Info=Info_"#"_$p(ADesc,"\",i)_"@"_InstanceID_$c(0)_ElementCode_$c(0)_$p(ADesc,"\",i)
				}
			}
		}
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	病案首页.入院病情选择错误 
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate	病案首页ChartTemplateid
/// 		AElement1		出院诊断疾病编码 11110\11182\29182
/// 		AElement2		入院病情 11110\11182\29182
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck062(EpisodeID,{ChartTemplateRY},"出院诊断编码code11110^11182^29182","入院病情code11110^11182^29182")
ClassMethod NLPCheck062(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="")||(AElement2="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s DieaCodes = ##class(EPRservice.Quality.DataGather.AdmInfo).GetMRDiagnosDesc(AEpisodeID,"2")
	s StatuCodes = ##class(EPRservice.Quality.DataGather.AdmInfo).GetMRDiagnosDesc(AEpisodeID,"3")
	s ListDieaCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(DieaCodes,"\")
	s ListStatuCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(StatuCodes,"\")
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))	
		s ElementID2=$p(AElement2,"|",$p($p(InstanceIDStr,"\",j),"^",2))		
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		for i=1:1:$l(ElementID1,"\")
		{
			s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementID1,"\",i),InstanceID)
			s:($listlength(ListDieaCodes) > 0) Location=$listfind(ListDieaCodes,ElementData1)
			continue:(Location=0)
			s Status=$listget(ListStatuCodes,Location)
			s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementID2,"\",i),InstanceID)
			s:((Status'=3)&&(ElementData2'="临床未确定")&&(Status'=0)) Info=Info_"#"_ElementData1_"@"_InstanceID
			s:((Status=3)&&(ElementData2'="有")) Info=Info_"#"_ElementData1_"@"_InstanceID
			s:((Status=0)&&(ElementData2'="情况不明")&&(ElementData2'="无")) Info=Info_"#"_ElementData1_"@"_InstanceID
		}		
	}
	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	缺疑难病例讨论记录（MDT）
/// 	患者进行MDT会诊，会诊开始日期后5天内未出现疑难病例讨论病历，即判为缺陷 
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate	病案首页ChartTemplateid
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck063(EpisodeID,{ChartTemplateRY})
ClassMethod NLPCheck063(AEpisodeID As %String, AChartTemplate As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	s MDTInfo=##class(EPRservice.Quality.DataGather.AdmInfo).GetPatMDTConsInfoByEpisodeID(AEpisodeID)
	q:(MDTInfo="") ret
	
	for i=1:1:$l(MDTInfo,"\")
	{
		s MDTinfo=$p(MDTInfo,"\",i)
		s MDTData=$zdh($p($p(MDTinfo,"^",1)," ",1),3)
		s MDTDesc=$p(MDTinfo,"^",2)
		s flag=0
		for j=1:1:$l(InstanceIDStr,"\")
		{
			s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
			continue:InstanceID=""
			s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
			s HappenDate = $p(objInstanceData1.HappenDate," ",1)
			s:(HappenDate-MDTData>-1)&&(HappenDate-MDTData<6) flag=1			
			q:flag=1
		}
		s:(flag=0) info=info_"#"_$p(MDTinfo,"^",1)_" "_MDTDesc
	}
	s:(info'="") ret=-1
	q ret_info
}

/// Desc:	术后首次病程记录的手术方式与实际不符
/// 		后首次病程记录“手术日期”与《手术记录》一致，但手术方式不一致时，即为缺陷
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	手术记录ChartTemplateid
/// 		AElement1A		手术日期
/// 		AElement1B		手术方式
/// 		AChartTemplate2	术后首次病程记录ChartTemplateid
/// 		AElement2A		手术日期
/// 		AElement2B		手术方式
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck064(16261839,"885|107",11331,11326,"881|1892",11291,12121)
ClassMethod NLPCheck064(AEpisodeID As %String, AChartTemplate1 As %String, AElement1A As %String, AElement1B As %String, AChartTemplate2 As %String, AElement2A As %String, AElement2B As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AChartTemplate2="")||(AElement1A="")||(AElement1B="")||(AElement2A="")||(AElement2B="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret
	s InstanceIDStr2=..GetInstanceIDStr(AEpisodeID,AChartTemplate2)
	q:(InstanceIDStr2="") ret

	s opeDesc="",opeDate=""
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)
		s ElementID1A=$p(AElement1A,"|",$p($p(InstanceIDStr1,"\",I),"^",2))
		s ElementID1B=$p(AElement1B,"|",$p($p(InstanceIDStr1,"\",I),"^",2))				
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s dateTime=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1A,InstanceID1)
		s date=$p(dateTime," ",1)
		continue:(date="")
		s opeDate=opeDate_$LB(date)
		s opeDesc=opeDesc_$LB(##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1B,InstanceID1))
	
	}
	
	q:($listlength(opeDate)=0) ret
	
	for j=1:1:$l(InstanceIDStr2,"\")
	{
		s InstanceID2=$p($p(InstanceIDStr2,"\",j),"^",1)
		s ElementID2A=$p(AElement2A,"|",$p($p(InstanceIDStr2,"\",j),"^",2))
		s ElementID2B=$p(AElement2B,"|",$p($p(InstanceIDStr2,"\",j),"^",2))				
		s objInstanceData2 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID2)
		s HappenDateTime2 = $zd($p(objInstanceData2.HappenDate," ",1),3)_" "_$zt($e(objInstanceData2.HappenTime,1,5),1)
		s temDate=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2A,InstanceID2)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID2A)
		s opsite=$listfind(opeDate,temDate)
		if (opsite>0)
		{
			s temDesc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2B,InstanceID2)
			s desc=$listget(opeDesc,opsite)
			s:(temDesc'=desc) Info=Info_"#"_temDate_"@"_InstanceID2_$c(0)_ElementCode_$c(0)
		}
		
	}
	
	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	术后首次病程记录“术中探查情况”书写不规范
/// 		术中探查情况，出现“详细见手术记录”，“详见手术记录”，“同手术记录”、“见手术记录”4类敏感词之一或字数少于15个字判定为缺陷
/// Input:		AEpisodeID	就诊号
/// 		AChartTemplate	病案首页ChartTemplateid
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck065(16261839,"881|1892","12117","详细见手术记录\详见手术记录\同手术记录\见手术记录",15)
ClassMethod NLPCheck065(AEpisodeID As %String, AChartTemplate1 As %String, AElement1 As %String, AErrDesc As %String, ANum As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AElement1="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret

	s flag=0
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr1,"\",I),"^",2))			
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s Content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID1)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1)
		for j=1:1:$l(AErrDesc,"\")
		{
			s:(Content[$p(AErrDesc,"\",j)) flag=1
			q:flag=1
		}
		s:(flag=1)&&($l(Content<ANum)) Info=Info_"#"_"@"_InstanceID1_$c(0)_ElementCode_$c(0)
	}

	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	病案首页.有创呼吸机使用时间大于等于96小时必须在手术操作栏增加：96.7201呼吸机治疗【大于等于96小时】
/// 		病案首页.有创呼吸机使用时间小于96小时大于0必须在手术操作栏增加：96.7101呼吸机治疗【小于96小时】
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	首页ChartTemplate
/// 		AElement		有创呼吸机使用时间
/// 		AMin			下限
/// 		AMax			上限 
/// 		AElements		手术操作编码  code1\code2
/// 		AText			需包含的手术编码
/// 		AExtText		排除的内容
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).NLPCheck066(EpisodeID,"有创呼吸机使用时间code",96,"","手术操作编码code","96.7201")
/// 		w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).NLPCheck066(EpisodeID,"有创呼吸机使用时间code",0,96,"手术操作编码code","96.7101")
ClassMethod NLPCheck066(AEpisodeID As %String, AElement As %String, AMin As %String, AMax As %String, AElements As %String, AText As %String, AExtText As %String = "") As %String
{
	s ret=0   
	q:(AEpisodeID="")||(AElement="")||(AElements="") ret
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	s ElementData=$tr(ElementData,"-—","")
	q:(ElementData=AExtText) ret
	q:(ElementData="") ret
	
	q:(AMin'="")&&(ElementData<AMin) ret
	q:(AMax'="")&&(ElementData>=AMax) ret
	
	s flag=0
	for i=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",i)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s:(ElementData1[AText) flag=1
		q:(flag=1)
	}
	
	s:(flag=0) ret=-1
	q ret
}

ClassMethod NLPCheck066A(AEpisodeID As %String, AElementDay As %String, AElementHour As %String, AMin As %String, AMax As %String, AElements As %String, AText As %String) As %String
{
	s ret=0   
	q:(AEpisodeID="")||(AElementDay="")||(AElements="") ret
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementDay,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementHour,"")
	s Hour=24*(+ElementData1)+ElementData2
	
	q:(Hour=0) ret
	
	q:(AMin'="")&&(Hour<AMin) ret
	q:(AMax'="")&&(Hour>=AMax) ret
	
	s flag=0
	for i=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",i)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s:(ElementData1[AText) flag=1
		q:(flag=1)
	}
	
	s:(flag=0) ret=-1
	q ret
}

/// Creator:	    qy
/// Create Date:	20220620
/// Desc:	VTE处置记录中危险等级与处置不匹配
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate	
/// 		AElementID 	元素
/// Output:	ret<0 违反
/// Debug: ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck067(EpisodeID,"ChartTemplate","内容code")
ClassMethod NLPCheck067(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String) As %String
{
	s ret=0,Info="",info=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate,"VTE评估处置记录")
	q:(InstanceIDStr="") ret
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s flag=0
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))

		s Data=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1)
		s Data=$tr(Data," ","")
		if (Data["Caprini评分")
		{
			if (Data["风险等级为低危")
			{
				if (Data["无机械预防禁忌症")
				{
					s:(Data["予机械") flag=1
				}elseif (Data["有机械预防禁忌症")
				{
					s:(Data["予基本") flag=1	
				}
			}elseif (Data["风险等级为中危")
			{
				if (Data["出血风险为低危")
				{
					s:(Data["予药物预防") flag=1
				}elseif (Data["出血风险为高危")
				{
					if (Data["无机械预防禁忌症")
					{
						s:(Data["予机械") flag=1
					}elseif (Data["有机械预防禁忌症")
					{
						s:(Data["予基本") flag=1	
					}	
				}
			}elseif (Data["风险等级为高危")
			{
				if (Data["出血风险为低危")
				{
					if (Data["无机械预防禁忌症")
					{
						s:(Data["予药物预防") flag=1
						s:(Data["机械、药物预防") flag=1 
					}
					
				}elseif (Data["出血风险为高危")
				{
					if (Data["无机械预防禁忌症")
					{
						s:(Data["予机械") flag=1
					}elseif (Data["有机械预防禁忌症")
					{
						s:(Data["予基本") flag=1	
					}	
				}
			}
		}elseif (Data["Padua评分")
		{
			if (Data["风险等级为低危")
			{
				s:(Data["予基本") flag=1	
			}elseif (Data["风险等级为高危")
			{
				if (Data["出血风险为低危")
				{
					s:(Data["予药物预防") flag=1
				}elseif (Data["出血风险为高危")
				{
					if (Data["无机械预防禁忌症")
					{
						s:(Data["予机械") flag=1
					}elseif (Data["有机械预防禁忌症")
					{
						s:(Data["予基本") flag=1	
					}	
				}
			}
		}
		

		if (flag=0)
		{
			s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
	    	s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
	        s Info=Info_"#"_HappenDateTime1_"@"_InstanceID_$c(0)_ElementCode_$c(0)
		}
	}
	
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:	术前讨论及术前小结“术前准备”记录不正确--冰冻病理同意书/留置胃管/留置尿管/禁食水/术中备血/皮试（个性化条目，看模板是否有这些空）
/// 		（1）有“冰冻切片检查与诊断”医嘱，术前讨论的“冰冻病理检查同意书”选择了“不需要”时，判为缺陷
/// 			（2）有“下胃管”医嘱，术前讨论的“留置胃管”选择了“不需要”时，判为缺陷
/// 			（3）有“下尿管（含导尿包）”医嘱，术前讨论的“留置尿管”选择了“不需要”时，判为缺陷
/// 			（4）有“术前禁食禁水”医嘱，术前讨论的“禁食水”选择了“不需要”时，判为缺陷
/// 			（5）有“备血”医嘱，术前讨论的“术中备血”选择了“不需要”时，判为缺陷
/// 			（6）有“皮试”医嘱，术前讨论的“皮试”选择了“不需要”时，判为缺陷
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate	术前讨论及术前小结ChartTemplate
/// 		AOrderTimes		对应医嘱时间  2022-01-01 09:00:00\2022-01-02 09:02:00
/// 		AElements		术前准备的 冰冻病理同意书\留置胃管\留置尿管\禁食水\术中备血\皮试 元素
/// 		AErrDesc		错误描述
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).NLPCheck068(EpisodeID,"术前小结ChartTemplate","冰冻切片检查与诊断医嘱时间接口","是否需要冰冻病理检查同意书code","不需要")
ClassMethod NLPCheck068(AEpisodeID As %String, AChartTemplate As %String, AOrderTimes As %String, AElements As %String, AErrDesc As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElements="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	for i=1:1:$l(InstanceIDStr,"\")
	{
		s InstanceID=$p($p(InstanceIDStr,"\",i),"^",1)
		s ElementID=$p(AElements,"|",$p($p(InstanceIDStr,"\",i),"^",2))				
		s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime = $zd($p(objInstanceData.HappenDate," ",1),3)_" "_$zt($e(objInstanceData.HappenTime,1,5),1)
		continue:(AOrderTimes'[($zd($p(objInstanceData.HappenDate," ",1)-1,3)))		
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
		continue:(ElementData1="")
		s:(AErrDesc[ElementData1) Info=Info_"#"_HappenDateTime_"@"_InstanceID_$c(0)_ElementCode_$c(0)		
	}
	
	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	前讨论及小结记录的内容与手术申请单不一致（乙级）--手术级别/拟主刀医生
/// 		以术前讨论及小结记录“手术日期”定位“手术申请列表”的患者
/// 		（1）手术级别若不一致时，判定为缺陷
/// 		（2）拟主刀医生若不一致时，判定为缺陷
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	前讨论及小结记录ChartTemplateid
/// 		AElement1A		手术日期
/// 		AElement1B		拟主刀医生
/// 		AElement1C		手术级别
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck069(EpisodeID,"前讨论及小结记录ChartTemplateid","手术日期code","拟主刀医生code","手术级别code")
ClassMethod NLPCheck069(AEpisodeID As %String, AChartTemplate1 As %String, AElement1A As %String, AElement1B As %String, AElement1C As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AElement1A="")||(AElement1B="")||(AElement1C="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret

	s opePerson="",opeDate="",opeLevel=""
	// 入参：就诊号
	// 出参：第一次手术信息||第二手术信息||第三次手术信息....
	// 手术日期^麻醉医生^麻醉方法^主刀医生^手术部位^手术名称^非计划再次手术标志^手术开始时间^手术结束时间^出血量^特殊情况“急救”^手术级别
	s Interface=##Class(web.NFYYMethod).GetOperationsInfos(AEpisodeID)
	for j=1:1:$l(Interface,"||")
	{
		s info=$p(Interface,"||",j)
		s opePerson=opePerson_$lb($p(info,"^",4))
		s opeLevel=opeLevel_$lb($p(info,"^",12))
		s opeDate=opeDate_$lb($p(info,"^",1))
	}
	q:($listlength(opeDate)=0) ret
	
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s info=""
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)
		s ElementID1A=$p(AElement1A,"|",$p($p(InstanceIDStr1,"\",I),"^",2))
		s ElementID1B=$p(AElement1B,"|",$p($p(InstanceIDStr1,"\",I),"^",2))
		s ElementID1C=$p(AElement1C,"|",$p($p(InstanceIDStr1,"\",I),"^",2))				
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s dateTime=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1A,InstanceID1)
		s dateTime=$tr(dateTime,"年","-")
		s dateTime=$tr(dateTime,"月","-")
		s dateTime=$tr(dateTime,"日","")
		s date=$p(dateTime," ",1)
		s opsite=$listfind(opeDate,date)
		if (opsite>0)
		{
			s Person=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1B,InstanceID1)
			s desc=$listget(opePerson,opsite)
			s:(Person'[desc) info=info_"-主刀医师"
			s Level=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1C,InstanceID1)
			s desc=$listget(opeLevel,opsite)
			s:(Level'[desc) info=info_"-手术级别"
		}
		s:(info'="") Info=Info_"#"_info_"@"_InstanceID1
	}
	
	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	术前讨论及小结的临床TNM分期未完成
/// 		《术前讨论及小结》“主要诊断”出现“肺、肝、肠、胃、乳腺”其中一个+“癌、恶性肿瘤”其中一个时：若（1）临床分期选择了“不适用”或（2）“：”后无内容或内容为“-”，即判为缺陷
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	术前讨论及术前小结ChartTemplate
/// 		AElement1		主要诊断
/// 		AElement2		TNM分期
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).NLPCheck070(EpisodeID,"术前讨论及术前小结ChartTemplate","主要诊断code","TNM分期code")
ClassMethod NLPCheck070(AEpisodeID As %String, AChartTemplate1 As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AElement1="")||(AElement2="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr="") ret
		
	for i=1:1:$l(InstanceIDStr,"\")
	{
		s flag=0
		s InstanceID=$p($p(InstanceIDStr,"\",i),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",i),"^",2))	
		s ElementID2=$p(AElement2,"|",$p($p(InstanceIDStr,"\",i),"^",2))				
		s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime = $zd($p(objInstanceData.HappenDate," ",1),3)_" "_$zt($e(objInstanceData.HappenTime,1,5),1)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID)
		s:((ElementData1["肺")||(ElementData1["肝")||(ElementData1["肠")||(ElementData1["胃")||(ElementData1["乳腺"))&&((ElementData1["癌")||(ElementData1["恶性肿瘤")) flag=1
		continue:(flag=0)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID2)
		s:(ElementData2["不适用")||(ElementData2["-") Info=Info_"#"_HappenDateTime_"@"_InstanceID_$c(0)_ElementCode_$c(0)	
			
	}
	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	入院记录.诊断出现"L00-L.54或L80-L99"，体格检查皮肤粘膜需描述皮肤颜色、皮疹、皮下出血、水肿
/// 		入院记录.诊断出现"J00-J99"，体格检查胸部需描述胸部外形、胸壁压痛、是否肺脏及胸膜检查、呼吸音、啰音、胸膜摩擦音
/// 		入院记录.诊断出现"I00-I52"，体格检查心脏需描述心律、杂音、心包摩擦音、周围血管征
/// 		入院记录.诊断出现"GOO-G99或I60-I69"，体格检查神经需描述浅反射、深反射、病理反射、脑膜刺激征
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	入院记录ChartTemplateid
/// 		AElementID1		体格检查相应检查的章节
/// 		ICDCode			诊断编码字母
/// 		ICDRange		诊断范围
/// 		Descs			检查的关键字及项目
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLP).NLPCheck071(EpisodeID,{ChartTemplateRY},"皮肤粘膜code","L\L","00-54\80-99","颜色|白|红|黄|发绀|色素\皮疹|疹\皮下出血|瘀点|紫癜|瘀斑|血肿\水肿")
/// 	w ##class(EPRservice.Quality.EmrCheckRule.NLP).NLPCheck071(EpisodeID,{ChartTemplateRY},"胸部code","J","00-99","外形|桶状胸|扁平胸|佝偻病\胸壁压痛\肺脏及胸膜检查\呼吸音\啰音\心包摩擦音")
/// 	w ##class(EPRservice.Quality.EmrCheckRule.NLP).NLPCheck071(EpisodeID,{ChartTemplateRY},"心脏code","I","00-52","心律|齐\杂音\心包摩擦音\周围血管征|阴性|枪击音|Duroziez双重音|毛细血管搏动征")
/// 	w ##class(EPRservice.Quality.EmrCheckRule.NLP).NLPCheck071(EpisodeID,{ChartTemplateRY},"神经code","G\I","00-99\60-69","浅反射\深反射\病理反射\脑膜刺激征")
ClassMethod NLPCheck071(AEpisodeID As %String, AChartTemplate1 As %String, AElementID1 As %String, ICDCode As %String, ICDRange As %String, Descs As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AElementID1="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret	
	
	s flag=0 //是否有相应诊断
	s result = ##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	d result.Execute(AEpisodeID)
	while result.%Next()
	{
		s DiagnosType=result.Data("DiagnosType")		
		continue:(DiagnosType'="初步诊断")
		s MRCIDCode=result.Data("MRCIDCode")
		for j=1:1:$l(ICDCode,"\")
		{
			s code=($p(ICDCode,"\",j))
			continue:(code="")	
			continue:(MRCIDCode'[code)
			s range=$tr(MRCIDCode,code,"")
			s Range=$p(ICDRange,"\",j)
			continue:(range<$P(Range,"-",1))||(range>$P(Range,"-",2))
			s flag=1
			q:(flag)
		}
		q:(flag)
	}
	q:(flag=0) ret
	
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s info=""
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)	
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s ElementID1=$p(AElementID1,"|",$p($p(InstanceIDStr1,"\",I),"^",2))	

		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID1)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1)
		s ContentFlag=1 //是否包含所有检查点描述
		for m=1:1:$l(Descs,"\")  
		{
			//每个项目都要描述到
			s ItemDescs=$p(Descs,"\",m)
			s ItemFlag=0
			for n=1:1:$l(ItemDescs,"|")
			{
				//每个项目内部的关键词触发一个就算
				s ItemDesc=$p(ItemDescs,"|",n)
				s:(ElementData1[ItemDesc) ItemFlag=1
				q:ItemFlag
			}
			s:(ItemFlag=0) info=info_"-"_$p(ItemDescs,"|",1)  //默认第一个描述是提示的标准描述
		}
		s:(info'="") Info=Info_"#"_info_"@"_InstanceID1_$c(0)_ElementCode_$c(0)
	}

	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	入院记录.初步诊断主要诊断为冠心病，现病史必须含有胸闷或者胸痛症状
/// 		入院记录.初步诊断主要诊断为冠心病，体格检查必须描述心界、心率、心律、心音、心脏杂音、心包摩擦音
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate	入院记录ChartTemplateid
/// 		ADiagnos		疾病名称
/// 		AElementID		需检查的章节code  现病史、体格检查
/// 			ADesc			需描述的内容 
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck072(EpisodeID,{ChartTemplateRY},"冠心病",{XBScode},"胸闷|胸痛")
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck072(EpisodeID,{ChartTemplateRY},"冠心病",{XBScode},"心界\心率\心律\心音\心脏杂音\心包摩擦音")
ClassMethod NLPCheck072(AEpisodeID As %String, AChartTemplate As %String, ADiagnos As %String, AElementID As %String, ADesc As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElementID="") ret
	
	s flag=0
	s result = ##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	d result.Execute(AEpisodeID)
	while result.%Next()
	{
		s DiagnosType=result.Data("DiagnosType")		
		continue:(DiagnosType'="初步诊断")
		s MainDiagFlag=result.Data("MainDiagFlag")
		continue:(MainDiagFlag'="是")
		s DiagnosICDDesc=result.Data("DiagnosICDDesc")
		continue:(DiagnosICDDesc'[ADiagnos)
		s flag=1		
	}
	q:(flag=0) ret 
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	s ret=1,descFlag=0
	for I=1:1:$l(InstanceIDStr,"\")
	{
		s InstanceID=$p($p(InstanceIDStr,"\",I),"^",1)	
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s ElementID=$p(AElementID,"|",$p(InstanceIDStr,"^",2))
		s Content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
		//每项都要描述
		for iDesc=1:1:$l(ADesc,"\")
		{
			s descItem=$p(ADesc,"\",iDesc)
			s itemFlag=0 // 每项里面不同描述，写一个就算
			for idescItem=1:1:$l(descItem,"|")
			{
				s:(Content[($p(descItem,"|",idescItem))) itemFlag=1
				q:(itemFlag=1)
			}
			s:(itemFlag=1) descFlag=1
			q:descFlag=0	
		}
		s:(descFlag=0) Info="#@"_InstanceID_$c(0)_ElementCode_$c(0)	
	}

	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	入院记录.肠鸣音大于10次/分，肠鸣音不能为正常
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate	入院记录ChartTemplateid
/// 		AElementID		体格检查-腹部
/// 		UniqueKey			 
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck073(EpisodeID,{ChartTemplateRY},{FBcode},UniqueKey)
ClassMethod NLPCheck073(AEpisodeID As %String, AChartTemplate As %String, AElementID As %String, UniqueKey As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElementID="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	s ret=1
	for I=1:1:$l(InstanceIDStr,"\")
	{
		s InstanceID=$p($p(InstanceIDStr,"\",I),"^",1)	
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s ElementID=$p(AElementID,"|",$p(InstanceIDStr,"^",2))
		s Content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(Content,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) 
		s Signobj={}.%FromJSON(ElementStr)

		s signFlag="",signStatus=""
		for i=1:1:Signobj.%Size()
	   	{
	    	s type= Signobj.%Get(i-1)."type"
	    	continue:(type'["sign")
	    	s signname= Signobj.%Get(i-1)."sign"."name"
	    	continue:(signname'="肠鸣音")
	    	s signvalue= Signobj.%Get(i-1)."sign_value"."name"
	    	s:(signvalue="正常") signStatus=1
	    	s:((+signvalue)>10) signFlag=1
	   	}
	   	s:(signFlag=1)&&(signStatus=1) ret=-1_"#@"_InstanceID_$c(0)_ElementCode_$c(0) 	
	}

	q ret
}

/// Desc:	术前讨论.主刀医生未参与术前讨论
/// 		手术日期同一天的手术记录和术前讨论，手术记录的“主刀医生”未出现在术前讨论的“参加讨论人员”中，即为缺陷
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	手术记录ChartTemplateid
/// 		AElement1A		手术日期
/// 		AElement1B		主刀医生
/// 		AChartTemplate2	术前讨论ChartTemplateid
/// 		AElement2A		手术日期
/// 		AElement2B		主刀医生
/// 		AElement2C		参加讨论人员
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck074(EpisodeID,"手术记录ChartTemplate","手术日期code","主刀医生code","术前讨论ChartTemplate","手术日期code","主刀医生code","参加讨论人员code")
ClassMethod NLPCheck074(AEpisodeID As %String, AChartTemplate1 As %String, AElement1A As %String, AElement1B As %String, AChartTemplate2 As %String, AElement2A As %String, AElement2B As %String, AElement2C As %String = "") As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AChartTemplate2="")||(AElement1A="")||(AElement1B="")||(AElement2A="")||(AElement2B="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret
	s InstanceIDStr2=..GetInstanceIDStr(AEpisodeID,AChartTemplate2)
	q:(InstanceIDStr2="") ret

	s opeDesc="",opeDate="",ret=1
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)
		s ElementID1A=$p(AElement1A,"|",$p($p(InstanceIDStr1,"\",I),"^",2))
		s ElementID1B=$p(AElement1B,"|",$p($p(InstanceIDStr1,"\",I),"^",2))				
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s dateTime=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1A,InstanceID1)
		s date=$p(dateTime," ",1)
		continue:(date="")
		s opeDate=opeDate_$LB(date)
		s opeDesc=opeDesc_$LB(##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1B,InstanceID1))
	
	}
	
	q:($listlength(opeDate)=0) ret
	
	for j=1:1:$l(InstanceIDStr2,"\")
	{
		s InstanceID2=$p($p(InstanceIDStr2,"\",j),"^",1)
		s ElementID2A=$p(AElement2A,"|",$p($p(InstanceIDStr2,"\",j),"^",2))
		s ElementID2B=$p(AElement2B,"|",$p($p(InstanceIDStr2,"\",j),"^",2))	
		s ElementID2C=$p(AElement2C,"|",$p($p(InstanceIDStr2,"\",j),"^",2))				
		s objInstanceData2 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID2)
		s HappenDateTime2 = $zd($p(objInstanceData2.HappenDate," ",1),3)_" "_$zt($e(objInstanceData2.HappenTime,1,5),1)
		s temDate=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2A,InstanceID2)
		s opsite=$listfind(opeDate,temDate)
		if (opsite>0)
		{
			s temDesc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2B,InstanceID2)
			s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID2B)
			s desc=$listget(opeDesc,opsite)
			s temDesc3=""
			s:(ElementID2C'="") temDesc3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2C,InstanceID2)
			s:(temDesc'[desc)&&(temDesc3'[desc) Info=Info_"#"_temDate_"@"_InstanceID2_$c(0)_ElementCode_$c(0)  //主刀医师或者参与人员有一个写即可
		}
		
	}
	
	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	手术记录.术中冰冻病理结果记录不准确
/// 		术后首次病程记录.术中快速冰冻病理记录不准确
/// 		手术当日（定位手术日期）30小时内，出现“冰冻切片检查与诊断”结果，《手术记录》术中冰冻病理结果填写了“无”，即为缺陷
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	手术记录ChartTemplateid
/// 		AElement1		手术日期
/// 		AElement2		术中冰冻病理结果
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck075(EpisodeID,"ChartTemplateid","手术日期code","术中冰冻病理结果code")
ClassMethod NLPCheck075(AEpisodeID As %String, AChartTemplate1 As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AElement1="")||(AElement2="") ret
	// 冰冻切片检查与诊断时间接口
	//input: 就诊号
	//output: 名称^2021-01-02 00:01:10\名称^2021-01-02 00:01:10
	s Results=##class(web.NFYYMethod).GetBDBLInfobyAdm(AEpisodeID)
	q:(Results="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret
	
	s ret=1
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)	
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s OpeDate=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,InstanceID1)
		s timeFlag=0,ErrFlag=0
		for m=1:1:$l(Results,"\")
		{
			s Result=$p(Results,"\",m)
			s Date=$p(Result,"^",2)
			s gap=##class(EPRservice.Quality.CommonHelper).GetDateTimeGap(Date,OpeDate)			
			s:(gap>0)&&(gap<30) timeFlag=1 //术后30小时内
			continue:(timeFlag=0)
			s content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,InstanceID1)
			s:(content="无") ErrFlag=1
			q:(ErrFlag=1)
		}
		s:(ErrFlag=1) Info=Info_"#"_HappenDateTime1_"@"_InstanceID1
	}

	s:(Info'="") ret=-1_Info
	q ret
}

/// Des:	首次病程记录.性别描述和患者不符
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement	病历特点 等  用^分割多个元素
/// 		Uniquekey	进程号,直接写Uniquekey即可	
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck076(EpisodeID,{SCChartTemplate},"病历特点code",UniqueKey)
ClassMethod NLPCheck076(AEpisodeID As %String, AChartTemplate As %String, AElement As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement="")||(UniqueKey="") ret

	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s ElementID=$p(AElement,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s Gender=##Class(EPRservice.Quality.DataGather.AdmInfo).GetSex(AEpisodeID)
	for m=1:1:$l(ElementID,"^")
	{
		s data=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementID,"^",m),"")
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode($p(ElementID,"^",m))
	}
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s Str=##Class(EMRservice.BL.CDSSService).ConvertPython(data,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s obj={}.%FromJSON(Str)

	s Desc=""
	for i=1:1:obj.%Size()
	{
	   	s type = obj.%Get(i-1)."type"
	   	continue:(type'="gender")
	   	s gender=obj.%Get(i-1)."name"
	   	continue:(Gender=gender)
	   	s Desc=gender
	   	s ret=-1
	   	q:(ret=-1)
	}
	s:(ret="-1") ret="-1#"_"@"_InstanceID_$c(0)_ElementCode_$c(0)_Desc
	q ret
}

/// Desc:	抢救记录.抢救记录的记录者未参与抢救
/// 		《抢救记录》的记录者签名未出现抢救人员名单里，判定为缺陷
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	抢救记录ChartTemplateid
/// 		ASign			签名单元 若多个用^隔开
/// 		APeople			抢救人员
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck077(EpisodeID,{ChartTemplate},"签名code","抢救人员code")
ClassMethod NLPCheck077(AEpisodeID As %String, AChartTemplate1 As %String, ASign As %String, APeople As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(ASign="")||(APeople="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret	
	
	s ret=1
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s info=""
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)	
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s Sign=$p(ASign,"|",$p($p(InstanceIDStr1,"\",I),"^",2))	
		s People=$p(APeople,"|",$p($p(InstanceIDStr1,"\",I),"^",2))
		s PeopleData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,People,InstanceID1)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(People)
		for j=1:1:$l(Sign,"^")
		{
			s SignData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(Sign,"^",j),InstanceID1)	
			s SignData=$p(SignData,"/",1)			
			s:(PeopleData'[SignData) ret=-1
		}
		continue:(ret=1)
		
		s Info=Info_"#"_HappenDateTime1_"@"_InstanceID1_$c(0)_ElementCode_$c(0)
	}

	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	抢救记录.主持抢救的医师未审核签名
/// 		《抢救记录》中参加抢救人员的第一个人姓名未出现在”参加抢救的最高职称者“和”记录者签名“中1个，判定为缺陷
/// Input:	AEpisodeID		就诊号
/// 		AChartTemplate1	抢救记录ChartTemplateid
/// 		ASign			签名单元 多个用^隔开
/// 		APeople			抢救人员
/// Output:	ret<0 违反规则
/// Debug:	w ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck078(EpisodeID,{ChartTemplate},"签名code","抢救人员code")
ClassMethod NLPCheck078(AEpisodeID As %String, AChartTemplate1 As %String, ASign As %String, APeople As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(ASign="")||(APeople="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret	
	
	s ret=1
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s info=""
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)	
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s Sign=$p(ASign,"|",$p($p(InstanceIDStr1,"\",I),"^",2))	
		s People=$p(APeople,"|",$p($p(InstanceIDStr1,"\",I),"^",2))
		s PeopleData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,People,InstanceID1)
		s firstPeopleData=$p(PeopleData,"、",1)		
		s flag=0
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode($p(Sign,"^",1))
		for j=1:1:$l(Sign,"^")
		{
			s SignData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(Sign,"^",j),InstanceID1)
			s:(SignData[firstPeopleData) flag=1
			q:flag=1
		}
		continue:(flag=1)
		s Info=Info_"#"_"@"_InstanceID1_$c(0)_ElementCode_$c(0)
	}

	s:(Info'="") ret=-1_Info
	q ret
}

/// Desc:	病程记录.细菌培养结果未记录
/// 		病程记录.抗菌药物使用情况未记录
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElement1	内容章节
/// 		AInfo		接口 需要记录的信息（细菌培养名称1^2022-01-01 00:00:00\细菌培养名称2^2022-02-01 00:00:00）
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck079(EpisodeID,{ChartTemplate},"内容code",{细菌培养结果接口})
ClassMethod NLPCheck079(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AInfo As %String) As %String
{

	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="") ret
	s DrugInfo=""
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(AInfo="") ret
	s ret=1

	for i=1:1:$l(AInfo,"\")
	{
	s flag=0
	s aInfo=$p(AInfo,"\",i)
	s Name=$p(aInfo,"^",1)
	s Date=$p($p(aInfo,"^",2)," ",1)
	s Time=$p($p(aInfo,"^",2)," ",2)	
	continue:(Date="")
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s dataTime=$p(objInstanceData.HappenDate," ",1)
		continue:((dataTime<$zdh(Date,3))||(dataTime-$zdh(Date,3)>3))
		//continue:(dataTime<ctTime)
		s HappenDateTime = $zd($p(objInstanceData.HappenDate," ",1),3)_" "_$zt($e(objInstanceData.HappenTime,1,5),1)
		s Content=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,InstanceID)
		continue:(Content'[Name)
		s flag=1
		q			
	}
	
	s:(flag=0) Info=Info_"#-"_Name_Date_" "_Time
	}
	
	s:(Info'="") ret="-1"_$tr(Info,"^"," ")
	q ret
}

/// Desc:	上级医师首次查房.鉴别诊断不能完全包含首程鉴别诊断
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate1 上级医师首次查房
/// 		AElement1		鉴别诊断
/// 		AChartTemplate2	首程
/// 		AElement2		鉴别诊断
/// Output:	ret<0 违反规则
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck080(EpisodeID,"66|316","11592","66|4","14149")
ClassMethod NLPCheck080(AEpisodeID As %String, AChartTemplate1 As %String, AElement1 As %String, AChartTemplate2 As %String, AElement2 As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate1="")||(AChartTemplate2="")||(AElement1="")||(AElement2="") ret
	s InstanceIDStr1=..GetInstanceIDStr(AEpisodeID,AChartTemplate1)
	q:(InstanceIDStr1="") ret
	s InstanceIDStr2=..GetInstanceIDStr(AEpisodeID,AChartTemplate2)
	q:(InstanceIDStr2="") ret

	s ret=1
	for I=1:1:$l(InstanceIDStr1,"\")
	{
		s InstanceID1=$p($p(InstanceIDStr1,"\",I),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr1,"\",I),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID1)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s Data1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,InstanceID1)
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(ElementID1)
		s Data1=$tr(Data1," ","")
		s Data1=$tr(Data1,$c(10),"")
		q	
	}	
	q:(Data1="") ret
	
	for j=1:1:$l(InstanceIDStr2,"\")
	{
		s InstanceID2=$p($p(InstanceIDStr2,"\",j),"^",1)
		s ElementID2=$p(AElement2,"|",$p($p(InstanceIDStr2,"\",j),"^",2))
		s objInstanceData2 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID2)
		s HappenDateTime2 = $zd($p(objInstanceData2.HappenDate," ",1),3)_" "_$zt($e(objInstanceData2.HappenTime,1,5),1)
		s Data2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,InstanceID2)
		s Data2=$tr(Data2," ","")
		s Data2=$tr(Data2,$c(10),"")
		q
	}
	
	s:(Data1[Data2) ret="-1#"_"@"_InstanceID1_$c(0)_ElementCode_$c(0)
	
	q ret
}

/// Desc:   入院记录.婚姻状态与婚育史婚姻状态不一致
/// Input:  AEpisodeID  就诊号
///         AChartTemplate
///         AElement1    婚育史 
/// 		AElement2	婚姻
///         UniqueKey   进程号
/// Output: ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck081(EpisodeID,{ChartTemplateRY},{HYScode},{HYZKcode},UniqueKey)
ClassMethod NLPCheck081(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, UniqueKey As %String) As %String
{
	s ret=0,info=""
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AChartTemplate="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s Element2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementData1 =##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element)
    q:(ElementData1="") 1
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj={}.%FromJSON(ElementStr)
	s singleFlag=0,marrigeFlag=0,releticeFlag=0,pregnancyFlag=0,divorceFlag=0,deathFlag=0
	for i=1:1:ElementObj.%Size()
	{
    	s type= ElementObj.%Get(i-1)."type"
    	continue:(type'["marriagehistory")
    	s name= ElementObj.%Get(i-1)."name"
    	s:(name="未婚") singleFlag=1	
        s:(name="已婚")||(name="结婚")||(name="再婚")||(name="婚育") marrigeFlag=1
    	s:((name="离异")||(name="离婚")) divorceFlag=1
    	s:((name="无离异")||(name="无离婚")) divorceFlag=0
    	s:(name="丧偶")||(name="已故") deathFlag=1
    	s:(name="无丧偶") deathFlag=0
    	
	}
	s ElementData2 =##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr2=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementData2,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj2={}.%FromJSON(ElementStr2)
	s singleFlag2=0,marrigeFlag2=0,releticeFlag2=0,pregnancyFlag2=0,divorceFlag2=0,deathFlag2=0
	for i=1:1:ElementObj2.%Size()
	{
    	s type= ElementObj2.%Get(i-1)."type"
    	continue:(type'["marriagehistory") 
    	s name= ElementObj2.%Get(i-1)."name"
    	s:(name="未婚") singleFlag2=1	
        s:(name="已婚")||(name="结婚")||(name="再婚")||(name="婚育") marrigeFlag2=1
    	s:((name="离异")||(name="离婚")) divorceFlag2=1
    	s:((name="无离异")||(name="无离婚")) divorceFlag2=0
    	s:(name="丧偶")||(name="已故") deathFlag2=1
    	s:(name="无丧偶") deathFlag2=0
    	
	}
	s:(marrigeFlag2=1)&&(marrigeFlag'=1) ret=-1
	s:(divorceFlag2=1)&&(divorceFlag'=1) ret=-1
	s:(deathFlag2=1)&&(deathFlag'=1) ret=-1
	s:(singleFlag2=1)&&(singleFlag'=1) ret=-1
	
	s:(ret="-1") ret="-1#"_"@"_InstanceID_$c(0)_ElementCode_$c(0)
	
	q ret
}

/// Des:	性别与病历内容不符
/// Input:	AEpisodeID	就诊号	
/// 		AChartTemplate	格式（ChartItemID1|TemplateID1\ChartItemID2|TemplateID2...）
/// 		AElement1		需要检测的章节
/// 		UniqueKey	
/// Output:	ret<0 违反
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck082(534,"622|580","11366\11367\11368\11398\11424\11453\11460\11505\11516\11541\11554\11557\11600\11619\11626\11632\11645\11648\11683\11686\11689\11716\11765\11766\11767\11770")
ClassMethod NLPCheck082(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, UniqueKey As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElement1="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	
	s Gender=##Class(EPRservice.Quality.DataGather.AdmInfo).GetSex(AEpisodeID)
	
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info="",Data=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementID1=$p(AElement1,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		for i=1:1:$l(ElementID1,"\")
		{
			s Data=Data_##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementID1,"\",i),InstanceID)
		}
		s CDSSCheck=##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).CDSSCheckGender(Gender,Data,UniqueKey)
		for m=1:1:$l(CDSSCheck,"^")
		{
			s info=$p(CDSSCheck,"&",m)
			continue:(info="")
			s Info=Info_"#"_"-"_$p(info,"^",1)_"@"_InstanceID_$c(0)_""_$c(0)_$p(info,"^",2)
		}
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

/// Desc:   入院记录.既往史中传染病史和诊断矛盾
/// Input:  AEpisodeID  就诊号
///         AChartTemplate
///         AElement1    既往史 
///         AElement1    初步诊断 
///         AElement1    类型 
///         UniqueKey   进程号
/// Output: ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck083(54926851,"390|281\1264|738\1298|756\1300|757","2563|6864|6310|5756",1)
ClassMethod NLPCheck083(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, AType As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AChartTemplate="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s Element2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	q:(Element1=0) ret
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementDes1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr1=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementDes1,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj1={}.%FromJSON(ElementStr1)
	s ElementDes2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element2)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementStr2=##Class(EMRservice.BL.CDSSService).ConvertPython(ElementDes2,UniqueKey)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s ElementObj2={}.%FromJSON(ElementStr2)
	
	s flag1=0,flag2=0
	
	for i=1:1:ElementObj1.%Size()
    	{
	    s type= ElementObj1.%Get(i-1)."type"
	    continue:(type'[AType)
	    s flag1=$e(type,1,1)
	    q
	}
	
	for i=1:1:ElementObj2.%Size()
    	{
	    s type= ElementObj2.%Get(i-1)."type"
	    continue:(type'[AType)
	    s flag2=$e(type,1,1)
	    q
	}
	
	s:(flag1="-")&&(flag2="+") ret="-1#@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:   入院记录.主诉不能导出第一诊断
/// Input:  AEpisodeID  就诊号
///         AChartTemplate
///         AElement1    主诉
///         AElement2    初步诊断 
///         UniqueKey   进程号
/// Output: ret<0 违反
/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck084(54926851,"622|580","11366",11767,UniqueKey)
ClassMethod NLPCheck084(AEpisodeID As %String, AChartTemplate As %String, AElement1 As %String, AElement2 As %String, UniqueKey As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AChartTemplate="")||(UniqueKey="") ret
	
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	s Element1=$p(AElement1,"|",$p(InstanceIDStr,"^",2))
	s Element2=$p(AElement2,"|",$p(InstanceIDStr,"^",2))
	q:(Element1=0) ret
	s InstanceID=$p(InstanceIDStr,"^",1)
	s ElementDes1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
	s ElementDes2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
	s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementSCode(Element2)
	///获取第一个诊断，取第一行诊断
	s FirstDiag=$p(ElementDes2,$c(10),2)
	s:(FirstDiag["、") FirstDiag=$p(FirstDiag,"、",2)
	s:(FirstDiag[".") FirstDiag=$p(FirstDiag,".",2)
	// 判断第一诊断是否是现有已经达标的诊断
	s ExistFlag=..isDiagEffective("\"_FirstDiag_"\")
	q:'ExistFlag 0
	// 调用CDSS接口
	s str=##class(EMRservice.BL.CDSSService).GetCDSSDiagBySymptom(ElementDes1)
	q:(str="") 0
	// 检查第一诊断是否在推荐的范围内
	s isflag=..IsSuspectedDisease(str,FirstDiag)
	s:isflag ret=1
	s:'isflag ret="-1#@"_InstanceID_$c(0)_ElementCode_$c(0)
	q ret
}

/// Desc:	手术记录.未描述出血量
/// Input:	AEpisodeID	就诊号
/// 		AChartTemplate
/// 		AElementIDs	需要检查的章节	
/// 		ADesc	需包含的关键字
/// Output:	ret<0 违反规则
/// Debug:	w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).NLPCheck085(EpisodeID,"141|71","12683\12684","出血")
ClassMethod NLPCheck085(AEpisodeID As %String, AChartTemplate As %String, AElementIDs As %String, ADesc As %String) As %String
{
	s ret=0,Info=""
	q:(AEpisodeID="")||(AChartTemplate="")||(AElementIDs="") ret
	s InstanceIDStr=..GetInstanceIDStr(AEpisodeID,AChartTemplate)
	q:(InstanceIDStr="") ret
	for j=1:1:$l(InstanceIDStr,"\")
	{
		s info=""
		s InstanceID=$p($p(InstanceIDStr,"\",j),"^",1)
		s ElementIDs=$p(AElementIDs,"|",$p($p(InstanceIDStr,"\",j),"^",2))
		s objInstanceData1 = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s HappenDateTime1 = $zd($p(objInstanceData1.HappenDate," ",1),3)_" "_$zt($e(objInstanceData1.HappenTime,1,5),1)
		s info="",Data=""
		for i=1:1:$l(ElementIDs,"\")
		{
		s Data=Data_##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(ElementIDs,"\",i),InstanceID)
		}
		continue:..IncludeAny(Data,ADesc)
		
		s Info=Info_"#"_HappenDateTime1_"@"_InstanceID
	}
	s:(Info'="") ret="-1"_Info
	q ret
}

ClassMethod isDiagEffective(FirstDiag As %String)
{
	s ZDElements="\冠状动脉粥样硬化性心脏病\不稳定型心绞痛\急性心肌梗死\急性冠脉综合征\急性非ST段抬高型心肌梗死\缺血性心肌病\冠状动脉粥样硬化\急性前壁心肌梗死\阵发性室上性心动过速\多发性结肠息肉\胃息肉\结肠息肉\急性重症胰腺炎\肝硬化伴食管胃底静脉曲张破裂出血\消化道出血\胃溃疡伴出血\急性胰腺炎\肝硬化失代偿期\肝恶性肿瘤\大面积脑梗死\后循环缺血\"
	s ZDElements=ZDElements_"腔隙性脑梗死\脑干梗死\短暂性脑缺血发作\肾积水伴输尿管结石\前列腺增生\输尿管结石伴有积水和感染\肾结石\肾积水伴肾结石\输尿管结石\膀胱恶性肿瘤\肾积水伴肾输尿管结石\前列腺恶性肿瘤\腰椎间盘突出\腰椎椎管狭窄\骨质疏松伴有病理性骨折\脊髓型颈椎病\腰椎滑脱\混合型颈椎病\神经根型颈椎病\腰椎骨折\"
	s ZDElements=ZDElements_"系统性红斑狼疮，累及器官或系统\老年性白内障\并发性白内障\代谢性白内障\孔源性视网膜脱离\黄斑水肿\玻璃体积血\老年性黄斑变性\胆囊结石伴慢性胆囊炎\胆囊结石伴有急性胆囊炎\胆囊结石伴胆囊炎\梗阻性黄疸\胆囊结石\胆总管结石\2型糖尿病性周围神经病\甲状腺毒症伴有弥漫性甲状腺肿\2型糖尿病性肾病\甲状腺功能障碍性突眼\毒性弥漫性甲状腺肿\"
	s ZDElements=ZDElements_"2型糖尿病足病\2型糖尿病伴血糖控制不佳\尿毒症\慢性肾脏病5期\肾病综合征\慢性肾衰竭\肾病综合征伴微小病变性肾小球肾炎\膜性肾病\"
	s ZDElements=ZDElements_"下肢静脉曲张\下肢动脉硬化闭塞症\下肢深静脉血栓形成\人工动静脉瘘狭窄\肢体血管瘤\胸主动脉夹层\下肢静脉曲张伴有溃疡\人工动静脉瘘血栓形成\直肠恶性肿瘤\乙状结肠恶性肿瘤\结肠肝曲恶性肿瘤\单侧腹股沟斜疝\胃窦恶性肿瘤\急性化脓性阑尾炎\肠梗阻\不完全性肠梗阻\高血压脑出血\基底节出血\创伤性闭合性硬膜外血肿\创伤性慢性硬膜下血肿\脑积水\慢性硬膜下血肿\创伤性蛛网膜下出血\甲状腺恶性肿瘤\结节性甲状腺肿\甲状腺良性肿瘤\甲状腺结节\胃穿孔\慢性鼻窦炎\中耳胆脂瘤\特发性突聋\食管内异物\鼻中隔偏曲\慢性化脓性中耳炎\鼻骨骨折\慢性分泌性中耳炎\先天性耳前瘘管\"
	s ZDElements=ZDElements_"子宫平滑肌瘤\卵巢良性肿瘤\宫颈恶性肿瘤\子宫内膜恶性肿瘤\异常子宫出血\子宫腺肌病\寻常性银屑病\银屑病\手术后恶性肿瘤化学治疗\乳房良性肿瘤\恶性肿瘤术后靶向治疗\乳房肿块\慢加急性肝衰竭\乙型肝炎后肝硬化失代偿期\慢性重度乙型病毒性肝炎\慢性乙型病毒性肝炎\慢性肝衰竭\肝恶性肿瘤\食管胃底静脉曲张破裂出血\肝功能不全\乙型肝炎肝硬化\多发性面骨骨折\"
	q:(ZDElements[FirstDiag) 1
	q 0
}

/// Debug:  ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).IsSuspectedDisease("{}","1")
ClassMethod IsSuspectedDisease(ADiseaseStr As %String, ADiseaseDesc As %String)
{
	s flag=0
	s obj={}.%FromJSON(ADiseaseStr)
	s SuspectedDisease=obj."SuspectedDisease"
	for i=1:1:SuspectedDisease.%Size()
    {
	    s DiseaseName= SuspectedDisease.%Get(i-1)."DiseaseName"
		s:(DiseaseName=ADiseaseDesc) flag=1
		q:flag
	}
	q flag
}

/// Desc:	cdss性别质控结果
/// Input:	AGender	性别
/// 		AData	文本
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).CDSSCheckGender("女","前列腺炎，前列腺炎，前列腺炎，前列腺炎，前列腺炎")
ClassMethod CDSSCheckGender(AGender As %String, AData As %String, UniqueKey As %String)
{
	s ret=""
	q:(AData="")||(AGender="") ret
	
	s CheckJson=##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).CDSSFormat(AGender,AData,UniqueKey)
	s CheckGenderResult=##Class(EMRservice.BL.CDSSService).CDSSCheck(CheckJson,UniqueKey)	
	q:(CheckGenderResult="") ret
	
	s Obj={}.%FromJSON(CheckGenderResult)
	s ResultObj=Obj."Result"
	q:(ResultObj="") ret
	for i=0:1:ResultObj.%Size()-1
	{
    	s InterfaceName= ResultObj.%Get(i)."InterfaceName"
    	s InterfaceValueList=ResultObj.%Get(i)."InterfaceValue"
    	for j=0:1:InterfaceValueList.%Size()-1
		{
			s WarningTip= InterfaceValueList.%Get(j)."WarningTip"
			s OrderStr=InterfaceValueList.%Get(j)."OrderStr"
			s:(ret'="") ret=ret_"&"_WarningTip_"^"_$replace(OrderStr,"[^]","")
			s:(ret="") ret=WarningTip_"^"_$replace(OrderStr,"[^]","")
		}
	}
	
	q ret
}

/// Desc:	cdss服务入参格式化
/// Input:	AGender	性别
/// 		AData	文本
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).CDSSFormat("女","前列腺炎,胸腔积液")
ClassMethod CDSSFormat(AGender As %String, AData As %String, UniqueKey As %String)
{
	s ret=""
	q:(AData="")||(AGender="") ret
	
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"
	s nlpData=##Class(EMRservice.BL.CDSSService).ConvertPython(AData)
	q:($g(^CacheTempResponseFlag(UniqueKey))=0) "1"

	s Result={}
	
	s GroupInfoObj={}
	d GroupInfoObj.%Set("Name","emr")
	d Result.%Set("GroupInfo",GroupInfoObj)
	
	d Result.%Set("Type","RecordGender")
	
	s PatientInfoObj={}
	d PatientInfoObj.%Set("Gender",AGender)
	d Result.%Set("PatientInfo",PatientInfoObj)
	
	s LabList=[],DiagnosisList=[],OrderEntry=[]
	s ElementObj={}.%FromJSON(nlpData)
	for i=1:1:ElementObj.%Size()
	{
    	s type= ElementObj.%Get(i-1)."type"
	    if (type["disease")
    	{
	    	s name= ElementObj.%Get(i-1)."name"
	    	s core= ElementObj.%Get(i-1)."core"
	    	s DiagnosisName=$s(core'="":core,1:name)
			s DiagnosisListObj={}
			d DiagnosisListObj.%Set("DiagnosisName",DiagnosisName)
			d DiagnosisList.%Push(DiagnosisListObj)
	    }elseif (type["operation")
    	{
	    	s name= ElementObj.%Get(i-1)."name"
	    	s core= ElementObj.%Get(i-1)."core"
	    	s OperationName=$s(core'="":core,1:name)
			s OrderEntryObj={}
			d OrderEntryObj.%Set("OrderType","手术")
			d OrderEntryObj.%Set("OrderContent",OperationName)
			d OrderEntry.%Push(OrderEntryObj)
	    }elseif (type["Drug")
    	{
	    	s name= ElementObj.%Get(i-1)."name"
	    	s core= ElementObj.%Get(i-1)."core"
	    	s DrugName=$s(core'="":core,1:name)
			s OrderEntryObj={}
			d OrderEntryObj.%Set("OrderType","药品")
			d OrderEntryObj.%Set("OrderContent",DrugName)
			d OrderEntry.%Push(OrderEntryObj)
	    }elseif (type["Ris")
    	{
	    	s name= ElementObj.%Get(i-1)."name"
	    	s core= ElementObj.%Get(i-1)."core"
	    	s Name=$s(core'="":core,1:name)
			s OrderEntryObj={}
			d OrderEntryObj.%Set("OrderType","检查")
			d OrderEntryObj.%Set("OrderContent",Name)
			d OrderEntry.%Push(OrderEntryObj)
	    }elseif (type["Lis")
    	{
	    	s name= ElementObj.%Get(i-1)."name"
	    	s core= ElementObj.%Get(i-1)."core"
	    	s Name=$s(core'="":core,1:name)
			s OrderEntryObj={}
			d OrderEntryObj.%Set("OrderType","检验")
			d OrderEntryObj.%Set("OrderContent",Name)
			d OrderEntry.%Push(OrderEntryObj)
	    }
	}
	d Result.%Set("OrderEntry",OrderEntry)
	d Result.%Set("DiagnosisList",DiagnosisList)
	s ret=Result.%ToJSON()

	q ret
}

/// Desc:	是否包含。。实体
/// Input:	AEpisodeID	就诊号	
/// 		UniqueKey	进程号
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).IsType(EpisodeID,"generalstatus",10300,"",UniqueKey)
ClassMethod IsType(AEpisodeID As %String, AType As %String, AElement As %String, AElementObj As %Library.DynamicArray, UniqueKey As %String) As %String
{
	s ret=0
	
	q:(AEpisodeID="")||(UniqueKey="") ret
	if (AElementObj'="")
	{
		s ElementObj=AElementObj
	}else{
		
		s Element=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) ret
		s ElementStr=##Class(EMRservice.BL.CDSSService).ConvertPython(Element,UniqueKey)
		q:($g(^CacheTempResponseFlag(UniqueKey))=0) ret
		s ElementObj={}.%FromJSON(ElementStr)
	}

	s ret="-1"
	for i=1:1:ElementObj.%Size()
   	{
	   	s type=""
    	s type= ElementObj.%Get(i-1)."type"
    	s type=$tr(type,"+-?","")
    	continue:(AType'[type)
    	s ret=1
    	q:(ret=1)
   	}
   	
   	q ret
}

/// ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).IsInfectious(140047880,58,55)
ClassMethod IsInfectious(AValue As %String) As %String
{
	s ret=""
	q:AValue="" ret
	s AValue=$tr(AValue,"病史","")
    s AValue=$tr(AValue,"病","")
	//s values="肺炎/结核/肺结核/疟疾"
	s values="传染/鼠疫/霍乱/传染性非典型肺炎/艾滋病/病毒性肝炎/脊髓灰质炎/人感染致病性禽流感/甲型H1N1流感/麻疹/流行性出雪热/狂犬病/流行性乙型脑炎/登革热/碳疽/细菌性和阿米巴性痢疾/肺结核/伤寒和副伤寒/流行性脑脊髓膜/百日咳/白喉/新生破伤风/猩红热/布鲁氏菌病/淋病/钩端螺旋体病/雪吸虫病/疟疾流行性感冒/流感/流行性腮腺炎/风疹/急性出血性结膜炎/麻风病/斑诊伤寒/黑热病/包虫病/丝虫病除霍乱/细菌性和阿米巴性痢疾/感染性腹泻病/手足口病/艾滋病/乙型肝炎/乙肝/乙型病毒性肝炎/丙肝/丙型肝炎/肺炎/结核/肺结核/肝炎/疟疾/梅毒"
	for i=1:1:$l(values,"/")
	{
		s value = $p(values,"/",i)
		continue:(AValue'[value) 
		s ret=1
		quit
	}
	q ret
}

ClassMethod filterBrackets(content As %String) As %String
{
	s ret=0
	q:(content="") ret
	
	if (content["(")
		{ 
			s positon1=$find(content,"(")
			s content=$e(content,1,positon1-2)
		}
		if (content["（")
		{ 
			s positon1=$find(content,"（")
			s content=$e(content,1,positon1-2)
		}
	q content
}

ClassMethod GetInfoAround(AData As %String, Before As %String, After As %String) As %String
{
	s ret=""
	q:(AData="")||(Before="")||(After="") ret
	q ($p($p(AData,Before,2),After,1))
}

ClassMethod format(AValue As %String) As %String
{
	s ret=""
	q:AValue="" ret
	s values="疼/痛/疼痛/隐痛"
	for i=1:1:$l(values,"/")
	{
		s value = $p(values,"/",i)
		s:(AValue=value) ret=values
		q:ret=values
	}
	q ret
}

/// Des:	获取病历instanceid方法
/// Input:	AEpisodeID	就诊号	
/// 		AChartTemplate	格式（ChartItemID1|TemplateID1\ChartItemID2|TemplateID2...）
/// 		ATitle		包含的标题
/// 		Aversion	版本>=此版本的检查
/// Output:	ret<0 违反
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.NLPCheck).GetInstanceIDStr(154225229,"")
ClassMethod GetInstanceIDStr(AEpisodeID As %String, AChartTemplate As %String, ATitle As %String = "", Aversion As %String = "") As %String
{
	s InstanceIDStr=""
	for i=1:1:$l(AChartTemplate,"\")
	{
		s ChartItemID=$p($p(AChartTemplate,"\",i),"|",1)
		s TemplateID=$p($p(AChartTemplate,"\",i),"|",2)
		s TheRecord = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ChartItemID,""))
		continue:(TheRecord="")
		s InstanceDataID=""
		for
		{
			s InstanceDataID = $o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",TheRecord,TemplateID," SAVE",InstanceDataID))
			q:(InstanceDataID="")
	            if (ATitle'="")||(Aversion'="")
	            {
	                s InstanceObj=##class(EMRinstance.InstanceData).%OpenId(TheRecord_"||"_InstanceDataID)
	                s Title=InstanceObj.Title
	                continue:(Title'[ATitle)
	                continue:(Aversion'="")&&(Aversion>=InstanceObj.TemplateVersion)
	            }
			s:(InstanceIDStr'="") InstanceIDStr = InstanceIDStr_"\"_TheRecord_"||"_InstanceDataID_"^"_i
			s:(InstanceIDStr="") InstanceIDStr = TheRecord_"||"_InstanceDataID_"^"_i
		}
	}
	q InstanceIDStr
}

ClassMethod GetTextSimilarity(text1 As %String, text2 As %String) As %String
{
	 k ^Temp("String")
	 s text1 = ..filter(text1)
	 s text2 = ..filter(text2)
	 Set ret = ##class(%Library.ArrayOfDataTypes).%New()
	 for i=1:1:$l(text1)
	 {
		 s char = ret.GetAt($e(text1,i))
		 if (char'="")
		 {
			 s ^Temp("String","1",$e(text1,i)) = $g(^Temp("String","1",$e(text1,i))) + 1
			 d ret.SetAt($g(^Temp("String","1",$e(text1,i)))_" "_$g(^Temp("String","2",$e(text1,i))),$e(text1,i))
		 }
		 else
		 {
			 s ^Temp("String","1",$e(text1,i)) = 1
			 s ^Temp("String","2",$e(text1,i)) = 0
			 d ret.SetAt($g(^Temp("String","1",$e(text1,i)))_" "_$g(^Temp("String","2",$e(text1,i))),$e(text1,i))
		 }
	 }
	
	 for j=1:1:$l(text2)
	 {
		 s char = ret.GetAt($e(text2,j))
		 if (char'="")
		 {
			 s ^Temp("String","2",$e(text2,j)) = $g(^Temp("String","2",$e(text2,j))) + 1
			 d ret.SetAt($g(^Temp("String","1",$e(text2,j)))_" "_$g(^Temp("String","2",$e(text2,j))),$e(text2,j))
		 }
		 else
		 {
			 s ^Temp("String","1",$e(text2,j)) = 0
			 s ^Temp("String","2",$e(text2,j)) = 1
			 d ret.SetAt($g(^Temp("String","1",$e(text2,j)))_" "_$g(^Temp("String","2",$e(text2,j))),$e(text2,j))
		 }
	 }
	 s dividend = 0
	 s divisor1 = 0
	 s divisor2 = 0
	 s key = ""
	 for
	 {
		 s key = ret.Next(key)
		 q:(key="")
		 s value = ret.GetAt(key)
		 s dividend = dividend + ($p(value," ",1) * $p(value," ",2))
		 s divisor1 = divisor1 + ($p(value," ",1) * $p(value," ",1))
		 s divisor2 = divisor2 + ($p(value," ",2) * $p(value," ",2))
	 }
	 q:(divisor2=0)||(divisor1=0) 0
	 s Similarity = dividend / ((divisor1 *divisor2) ** 0.5)
	 k ^Temp("String")
	 q Similarity
}

ClassMethod filter(text As %String) As %String
{
    	s SpecialString = ",\.\，\。\?\？\:\：\“\”\!\！\;\；\、\·\~\(\)\（\）\/\<\>\《\》\-\—\="
	for i=1:1:$l(SpecialString,"\")
	{
		s text = $tr(text,$p(SpecialString,"\",i))
	}
	s text = $tr(text," ")
	s text = $tr(text,"\")
	s text = $tr(text,$c(10))
	q text
}

/// Des:排除入院记录部分条目不判断的特殊病人
/// Output:0 正常患者 1 特殊患者
/// ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).AdmExcludePerson(EpisodeID)
ClassMethod AdmExcludePerson(AEpisodeID As %String) As %String
{
    	s ret=1
	q:(AEpisodeID="") ret
	//供捐者
	s MainDiagnosInfo = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(AEpisodeID)
	s MainDiagnos=$p(MainDiagnosInfo,"^",2)
    	s:($e(MainDiagnos,1,3)="Z52") ret=0
	//临床试验受试者
	s:(MainDiagnosInfo["受试者") ret=0
	q ret
}

/// Des:是否包含日期或时间
/// Output:
/// ##class(EPRservice.Quality.EmrCheckRule.NLPCheck).IncludeDateTime(EpisodeID)
ClassMethod IncludeDateTime(AText As %String, AType As %String = "") As %String
{
	s ret=""
	q:(AText="") ret
	s Text=AText
	s DateFlag=0,TimeFlag=0
	s:(Text["年")&&(Text["月")&&(Text["日") DateFlag=1
	if ($l(Text,"-")>2)
    {
    s date=$e(Text,($find(Text,"-")-5),($find(Text,"-")+1)) 
    s:($p(date,"-",1)>1000)&&($p(date,"-",2)<13)&&($p(date,"-",2)>0) DateFlag=1
    }
    s:(Text["时")&&(Text["分") TimeFlag=1
	s Text=$tr(Text,"：",":")
    if (Text[":")
    {
    s time=$e(Text,($find(Text,":")-3),($find(Text,":")+1)) 
    s:($p(time,":",1)>0)&&($p(time,":",1)<25)&&($p(time,":",2)<61)&&($p(time,":",2)>0) TimeFlag=1
    } 
    s:(AType="Date") ret=DateFlag
    s:(AType="Time") ret=TimeFlag
    s:(AType="") ret=DateFlag||TimeFlag
    q ret
}

/// Desc:	是否包含任意一个元素
/// Input:	AText		文本
/// 		AElements	元素
/// Output:	1 包含  0 不包含 “” 不符合条件
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).IncludeAny("wedsw2fsd","3\2")
ClassMethod IncludeAny(AText As %String, AElements As %String) As %String
{
	s ret=""
	q:(AText="")||(AElements="") ret
	s ret=0
	for I=1:1:$L(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s:(AText[Element) ret=1
		q:(ret=1)
	}
	q ret
}

/// Desc:	是否包含专业技术职称
/// Input:	AText		文本
/// 		AElements	元素
/// Output:	1 包含  0 不包含 “” 不符合条件
/// Debug:  w ##Class(EPRservice.Quality.EmrCheckRule.NLPCheck).IncludeProfessionalTitle("HH部长")
ClassMethod IncludeProfessionalTitle(AText As %String) As %String
{
	s ret=""
	q:(AText="") ret
	s Text=AText
	if ('..IncludeAny(Text,"、\，\,"))
	{ 
		s ret=0
		s name=Text
		s:(..IncludeAny(name,"教授\教师\主任\讲师\医师\护士\研究生\院长\规培生\实习\住院总\全体\研究员\部长")) ret=1
		
	}
	else 
	{
		s ret=1
        	s Text=$tr(Text,"、，,","\")
		for i=1:1:$l(Text,"\")
		{
			s name=$p(Text,"\",i)
			q:(name="")
            s:('..IncludeAny(name,"教授\教师\主任\讲师\医师\护士\研究生\院长\规培生\实习\住院总\全体\研究员\部长")) ret=0
			q:(ret=-1)	
		}
		
	}	
	q ret
}

}
