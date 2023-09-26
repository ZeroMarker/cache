/// 监控虚拟机
/// 创建者：李阳
/// 创建日期：2010-09-12
/// 监控中心虚拟机
/// 创建者：李阳
/// 创建日期：2010-09-12
Class DHCMed.CCService.System.VM Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 处理函数
/// SubjectID：监控主题ID
/// 监控的PAADM 列表
/// SubjectItmIDList:选中的监控项目ID列表
ClassMethod Process(SubjectID, paadmStoreRepid, SubjectItmIDList)
{
		n (SubjectID, paadmStoreRepid, SubjectItmIDList)
		//=====读取配置=======
		s objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		;s arryRuleItem=##class(DHCMed.CC.SubjectItm).GetItmListBySubjectID(SubjectID) //监控项目列表
		//-----读取监控项目列表-----
		s arryRuleItem=..LoadRuleItem(SubjectID,SubjectItmIDList) //modified by LiYang 2010-10-21 
		
		s result=##class(DHCMed.CCService.System.ExpEvaluation).CompileExpression(arryRuleItem) //编译表达式
		i $li(result,1)="Error"  d
		.s objSubject=""
		.k objSubject
		.d arryRuleItem.Clear()
		.d arryRuleItem.%Close()
		.s arryRuleItem=""
		.k arryRuleItem
		q:$li(result,1)="Error" result
		
		s %CurrProcessHandle=$li(result,2)
		s %GlobalVarArry=##class(%Library.ArrayOfObjects).%New() //公共变量列表
		;b //编译好表达式啦~~~
		
		
		s arryStartConfig=##class(DHCMed.CC.SubjectVMStartConfig).GetConfigBySubject(SubjectID,"S") //启动配置
		s arryEveyPatientConfig=##class(DHCMed.CC.SubjectVMStartConfig).GetConfigBySubject(SubjectID,"L") //每个paadm的加载项
		
		//=====初始化配置====
		f initConfigCnt=1:1:arryStartConfig.Count()  d
		.s objConfig=arryStartConfig.GetAt(initConfigCnt)
		.d objConfig.%Close()
		.s retValue=..RunConfigExpression(objConfig.Expression)
		.i (retValue="OK")&&(objConfig.VarName'="")  d
		..s exp="s "_objConfig.VarName_"=ret"
		..x exp
		..d %GlobalVarArry.SetAt(ret,objConfig.VarName)
		.e  d
		..;w "配置加载错误，表达式："_objConfig.Expression_"  返回值："_retValue,!
		.s ret=""
		.s objConfig=""		
		
		
		s %TotalScore=0 //得分情况
		s %TotalFireItmCnt=0 //触发项目计数
		s %TotalFireItmType=0 //触发项目类别计数
		s %DetailList=$lb("")
		s ret=""
		s PatNum="" f  s PatNum=$o(^CacheTemp(paadmStoreRepid,PatNum)) q:PatNum=""  d
		.s %PAADM=$g(^CacheTemp(paadmStoreRepid,PatNum))
		.s %EpisodeID=%PAADM //Modified By LiYang 2011-07-11  许多类库内的名字已经不统一了，只能再立一个名字
		.f j=1:1:arryEveyPatientConfig.Count()  d
		..s objConfig=arryEveyPatientConfig.GetAt(j)
		..s retValue=##class(DHCMed.CCService.System.MethodRunner).RunExpression(objConfig.Expression)
		..i (retValue="OK")&&(objConfig.VarName'="")  d
		..s exp="s "_objConfig.VarName_"=RunExpressionResult"
		..;d %GlobalVarArry.SetAt(RunExpressionResult,objConfig.VarName)
		..x exp
		..s objConfig=""
		.s ret=..ExamPaadm(arryRuleItem)
		.;b //处理完一个病人
		.;**********处理结果信息！！！！
		.;垃圾回收
		.f j=1:1:arryEveyPatientConfig.Count()  d
		..s objConfig=arryEveyPatientConfig.GetAt(j)
		..i objConfig.VarName'=""  d
		...s exp="s "_objConfig.VarName_"="_$c(34)_$c(34)
		...x exp
		..s exp="k "_objConfig.VarName
		..d %GlobalVarArry.RemoveAt(objConfig.VarName)
		..x exp
		..s objConfig=""
		s objSubject=""
		k objSubject
		s ret=""
		
		
		
		//====================
		
		//释放公共变量列表
		d %GlobalVarArry.Clear()
		d %GlobalVarArry.%Close()
		s %GlobalVarArry=""
		k %GlobalVarArry
		
		//释放配置
		d arryRuleItem.Clear()
		s arryRuleItem=""
		k arryRuleItem
		f i=1:1:arryStartConfig.Count()  d
		.s objConfig=arryStartConfig.GetAt(i)
		.i objConfig.VarName'=""  d
		..s exp="s "_objConfig.VarName_"="_$c(34)_$c(34)
		..x exp
		..s exp="k "_objConfig.VarName
		..x exp
		.s objConfig=""
		d arryStartConfig.Clear()
		s arryStartConfig=""
		k arryStartConfig
		
		q $lb("OK",%CurrProcessHandle)
}

ClassMethod RunConfigExpression(exp)
{
		SET $ZTRAP="RunConfigExpressionERR"
		s exp="s ret="_exp
		x exp
		;w "处理表达式...",!
		q "OK"
	
RunConfigExpressionERR
	s ret=""
	q $ZError
}

/// 读取监控虚拟机的监控项目列表
/// 创建者：李阳
/// 创建日期：2010-10-21
/// 返回值：监控项目列表
/// 逻辑：
/// 1.只指定了主题ID，读取主题下所有监控项目
/// 2.指定了主题ID和项目ID，
ClassMethod LoadRuleItem(SubjectID As %String, SubjectItmList As %String) As %Library.ListOfObjects
{
	n (SubjectID, SubjectItmList)
	//指定主题ID
	i SubjectID'=""  d
	.s objArry=##class(DHCMed.CC.SubjectItm).GetItmListBySubjectID(SubjectID)
	.d objArry.%Close()
	//指定了主题ID和项目列表
	//i ((SubjectID'="")&&(SubjectItmList=""))  d
	//.s SubjectItmIDList="*"_SubjectItmIDList_"*"
	//.f i=arryRuleItem.Count():-1:1  d
	//..s obj=arryRuleItem.GetAt(i)
	//..s id="*"_obj.%Id()_"*"
	//..i ((SubjectItmIDList[id)&&(SubjectItmIDList'=""))  d
	//...d arryRuleItem.RemoveAt(i)
	//只指定了项目列表
	i (SubjectItmList'="")  d
	.s objArry=##class(%Library.ListOfObjects).%New()
	.f i=1:1:$l(SubjectItmList,"/")  d
	..s rowid=$p(SubjectItmList,"/",i)
	..q:rowid=""
	..s obj=##class(DHCMed.CC.SubjectItm).GetObjById(rowid)
	..d obj.%Close()
	..d objArry.Insert(obj)
	.d objArry.%Close()
	q objArry
}

/// 处理每个Paadm
ClassMethod ExamPaadm(arryRuleItem)
{
	;n (arryRuleItem, %PAADM, %Adm, %CurrProcessHandle)
	s ItmCnt=arryRuleItem.Count()
	s %ExtraData=$lb("")
	s %ExtraDataCnt=0
	s %ErrorData=$lb("")
	s %ErrorDataCnt=0
	
	s TotalScore=0   //合计分数
	s FireCnt=0 	 //触发项目记录
	s FireTypeCnt=0  //触发项目种类数量
	f i=1:1:ItmCnt  d
	.s objItm=arryRuleItem.GetAt(i)
	.s expression=$g(^CacheTemp(%CurrProcessHandle,"CC.CompiledExpression",objItm.ItemDic))
	.s %ExtraData=$lb("")
	.s %ExtraDataCnt=0
	.s %ErrorData=$lb("")
	.s %ErrorDataCnt=0
	.s result=##class(DHCMed.CCService.System.MethodRunner).RunExpression(expression)
	.i (($li(result,1)="OK")&&($ll(%ErrorData)=1))  d //Modified by LiYang 2011-09-28如果错误信息不为空，也要跳到错误处理中
	..i $li(result,2)  d //当监控表达式的返回值为true时
	...;b
	...s startPos=$o(^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"Detail",objItm.ItemDic,""),-1)
	...s %ExtraDataCnt=$ll(%ExtraData)
	...s intExtraCnt=0
	...f j=1:1:%ExtraDataCnt  d
	....s tmpData=$lg(%ExtraData,j)
	....s:tmpData'="" ^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"Detail",objItm.ItemDic,j+startPos)=tmpData
	....s:tmpData'="" intExtraCnt=intExtraCnt+1
	...i objItm.MultiTimes  d //add by LiYang 2010-10-19 增加多次扣分支持
	....s TotalScore=TotalScore+objItm.Score*intExtraCnt //是最后输出数量的计数
	...e  d
	....s TotalScore=TotalScore+objItm.Score
	...s FireCnt=FireCnt+1	
	..s %ExtraData=$lb("")
	..s %ExtraDataCnt=0
	.e  d
	..;s %ErrorDataCnt=%ErrorDataCnt+1
	..s cnt=$o(^CacheTemp(%CurrProcessHandle,"Error",%PAADM,""),-1)+1
	..s tmpErrorData=""
	..s tmpList=""
	..f i=1:1:$ll(%ErrorData)  d
	...s:$lg(%ErrorData,i)'="" tmpErrorData=tmpErrorData_$lg(%ErrorData,i)_";"
	..s objItmDic=##class(DHCMed.CC.ItemDic).GetObjById(objItm.ItemDic)
	..s $p(tmpList,$c(1),1)=objItmDic.IDCode //引起错误的字典项目代码
	..s $p(tmpList,$c(1),2)=objItmDic.IDDesc //引起错误的字典项目名称
	..s $p(tmpList,$c(1),3)=objItmDic.IDExpression //错误表达式
	..s $p(tmpList,$c(1),4)=$lg(result,2) //错误返回值
	..s $p(tmpList,$c(1),5)=tmpErrorData //错误详细信息
	..s ^CacheTemp(%CurrProcessHandle,"Error",%PAADM,cnt)=tmpList
	..s %ErrorData=$lb("")
	..s %ErrorDataCnt=0
	.;k ^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"Detail",objItm.ItemDic)
	
	
	s rowid="" f  s rowid=$o(^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"Detail",rowid)) q:rowid=""  d
	.s objItm=##class(DHCMed.CC.ItemDic).%OpenId(rowid)
	.d objItm.%Close()
	.s ^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,rowid)=objItm.IDDesc
	.s ^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"type",objItm.IDSubCatDr)=$g(^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"type",objItm.IDSubCatDr))+1
	.s objItm=""
	.k objItm
	
	s typeDr="" f  s typeDr=$o(^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"type",typeDr)) q:typeDr=""  d
	.s FireTypeCnt=FireTypeCnt+1
	
	s ^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM)=TotalScore_"^"_FireCnt_"^"_FireTypeCnt
	
	;b //"在ExamPaadm中的断点"
	q "OK"
}

/// 为库函数提供记录额外信息的函数，如果库函数输出内容过多会导致%ExtraData内容超长
/// 参数Contents As %String
/// 返回值：纪录内容在Global中的节点号
ClassMethod RecordDetail(Contents As %String) As %Integer
{
	n (%CurrProcessHandle,%PAADM,objItm,Contents)
	s startPos=$o(^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"Detail",objItm.ItemDic,""),-1)
	s ^CacheTemp(%CurrProcessHandle,"Paadm",%PAADM,"Detail",objItm.ItemDic,startPos+1)=Contents
	q startPos+1
}

ClassMethod Test()
{
		//w ##class(DHCMed.CCService.System.VM).Test()
		k ^CacheTemp
		s result=##class(DHCMed.CCService.System.VM).Process(3,$lb("50729"))
		f i=1:1:$ll(result)  d
		.;w $li(result,i),!
		q ""
}

}
