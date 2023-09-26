Class web.CDSS.Demo.ChiefIdentify Extends %RegisteredObject
{

/// Creator:wuzhe
/// CreatDate:2021-09-16
/// Description：导入Excel的数据，前端一条一条传过来
/// Table: 无数据：没有数据  无诊断：没有诊断  无主诉：没有主诉  NLP不能识别：NLP不能识别主诉
/// Input：DiagAndChief：诊断^^^^主诉^^^^任务集的ID，ImportUser：导入人员
/// Output: 情况一 无数据：没有数据
/// 情况二  无诊断：没有诊断  
/// 情况三  无主诉：没有主诉  
/// 情况四  NLP不能识别：NLP不能识别主诉 
/// 情况五  True：保存成功
/// 情况六  保存失败：诊断##主诉##保存失败  
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).ImportDataOneByOne("2型糖尿病足病^^^^发现血糖升高14年，左足第二趾发绀、疼痛20+天^^^^4","wz")
ClassMethod ImportDataOneByOne(DiagAndChief As %String, ImportUser As %String) As %String
{
	q:DiagAndChief="" "无数据" ///"无数据"
	s Result=""
	
	s Diagnosis=$p(DiagAndChief,"^^^^",1)  ///诊断
	q:Diagnosis="" "无诊断" ///"无诊断"
	s ChiefInfo=$p(DiagAndChief,"^^^^",2)  ///主诉
	q:ChiefInfo="" "无主诉" ///"无主诉"
	s TaskID=$p(DiagAndChief,"^^^^",3)  ///任务集ID
	
    ///过NLP
	s ChiefToNLP=##class(web.CDSS.Demo.ChiefIdentify).ChiefPassNlp(ChiefInfo)
	q:ChiefToNLP="NLP不能识别" Diagnosis_"##"_ChiefInfo_"##NLP不能识别"
	
	///w Diagnosis,ChiefInfo,ChiefToNLP,ImportUser,!
	///保存到主诉识别表中
	s result=..SaveChiefIdentify(Diagnosis,ChiefInfo,ChiefToNLP,ImportUser,TaskID,"","","")
	s:result="1" Result="True"
	s:result="0" Result=Diagnosis_"##"_ChiefInfo_"##保存失败"
	
	q Result
}

/// Creator:wuzhe
/// CreatDate:2021-09-10
/// Description：导入Excel的数据，前端一次传一个诊断和这个诊断所有的主诉
/// Table: 
/// Input：DiagAndChief：诊断和主诉 诊断^^^^主诉1^^^^主诉2, ImportUser：导入人员
/// Output: 情况一 无数据：没有数据
/// 情况二  无诊断：没有诊断  
/// 情况三  无主诉：没有主诉  
/// 情况四  全部数据保存成功：诊断##导入成功的数据个数
/// 情况五  有没保存成功的数据：诊断##导入成功的数据个数##未保存主诉1##未保存主诉2  ...
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).ImportDataNew(^tmpdiag,"")
/// w ##class(web.CDSS.Demo.ChiefIdentify).ImportDataNew("胃息肉^^^^腹痛10天^^^^肚子疼2天","")
ClassMethod ImportDataNew(DiagAndChief As %String, ImportUser As %String) As %String
{
	//w $now(),!
	q:DiagAndChief="" "无数据" ///"无数据"
	
	s Result=0 ///记录保存的数据个数
	s NoSaveChief=""  ///记录不能保存的主诉
	s Diagnosis=$p(DiagAndChief,"^^^^",1)
	q:Diagnosis="" "无诊断" ///"无诊断"
	
	s LenChief=$l(DiagAndChief,"^^^^")
	q:LenChief<2 "无主诉" ///"无主诉"
	
	k ^TMP("WZ")
	for i=2:1:LenChief
	{
		s ChiefInfo=$p(DiagAndChief,"^^^^",i)
		continue:ChiefInfo=""
        ///过NLP
		s ChiefToNLP=##class(web.CDSS.Demo.ChiefIdentify).ChiefPassNlp(ChiefInfo)
		
	    ///w Diagnosis,ChiefInfo,ChiefToNLP,ImportUser,!
		///保存到主诉识别表中
		s result=..SaveChiefIdentify(Diagnosis,ChiefInfo,ChiefToNLP,ImportUser,"","")
		s:result="1" Result=Result+1
		s:result="1" ^TMP("WZ")=Diagnosis_"^^"_Result
		s:(result="0")&(NoSaveChief'="") NoSaveChief=NoSaveChief_"##"_ChiefInfo
		s:(result="0")&(NoSaveChief="") NoSaveChief=ChiefInfo
		
		///s ^TMP("WZ")=Diagnosis_"^^"_(i-1)
	}
	s Result=Diagnosis_"##"_Result
	s:NoSaveChief'="" Result=Result_"##"_NoSaveChief
	
	q Result
}

/// Creator:wuzhe
/// CreatDate:2021-08-19
/// Description：导入Excel的数据,自己读取Excel
/// Table: 
/// Input：FilePathAndName:excel文件的路径和名称，ImportUser：导入人员名称
/// Output: 情况1 文件名和路径为空
/// 情况2 True：导入成功
/// Others: w ##class(web.CDSS.Demo.ChiefIdentify).ImportData("E:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\20210908152544第二批ZSFirstZDResultDetail1.csv","丁亚男")
ClassMethod ImportData(FilePathAndName As %String, ImportUser As %String) As %String
{
	///s ^TMP("FWK")=FilePathAndName
	q:FilePathAndName="" "文件名和路径为空"
#;	q FilePathAndName
    ///打开Excel并读取内容
	s file=##class(%File).%New(FilePathAndName)
	d file.Open("RS")
	while 'file.AtEnd
	{
		s DataString=file.ReadLine()
		continue:DataString=""
		s Diagnosis=$p(DataString,",",1)
		continue:Diagnosis="诊断"
		s ChiefInfo=$p(DataString,",",2)
		
		///过NLP
		s ChiefToNLP=##class(web.CDSS.Demo.ChiefIdentify).ChiefPassNlp(ChiefInfo)
		continue:ChiefToNLP="NLP不能识别"
		///w Diagnosis,ChiefInfo,ChiefToNLP,ImportUser,!
		///保存
		s result=..SaveChiefIdentify(Diagnosis,ChiefInfo,ChiefToNLP,ImportUser,"","")	
	}
	q "True"
	//q "{""name"":""True""}"
}

/// Creator:wuzhe
/// CreatDate:2021-08-10
/// Description：主诉过NLP并整合
/// Input：Chief：主诉
/// Output: 情况1  ""  代表 没主诉
/// 情况2 NLP不能识别 识别结果为"[]"/error，联系管理员 
/// 情况3 只有一条识别效果   实体类型:实体,formal:归一词内容,core:上位词内容
/// 情况4 多条识别效果   实体1类型:实体1,formal:实体1归一词内容,core:实体1上位词内容，实体2类型:实体2,formal:实体2归一词内容,core:实体2上位词内容.......
/// Others：w ##class(web.CDSS.Demo.ChiefIdentify).ChiefPassNlp("腹痛")
/// w ##class(web.CDSS.Demo.ChiefIdentify).ChiefPassNlp("诊断为类风湿性关节10+年，加重3+天")
ClassMethod ChiefPassNlp(Chief As %String) As %String
{
	q:Chief="" ""
	s result=""
	///##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("CDSSldy2020070701")
	s NLPString=##class(web.CDSS.MachineLearning.NLPProcessingData).GetStructedDataAPI(Chief)
	///w NLPString,!
	q:NLPString="[]" "NLP不能识别"
	q:($e(NLPString,1)="{")&($e(NLPString,$l(NLPString))="}") "NLP不能识别"
	s NLPArray=[].%FromJSON(NLPString)
	
	for i=0:1:NLPArray.%Size()-1
	{
		s ItemJson=NLPArray.%Get(i)
		s type=ItemJson.%Get("type") ///实体类型
		s name=ItemJson.%Get("name") ///实体
		if (ItemJson.%IsDefined("formal"))&&(ItemJson.%Get("formal")'=ItemJson.%Get("name"))
		{
			s formal=ItemJson.%Get("formal") ///归一词
		}
		else
		{
			s formal=""
		}
		
		if (ItemJson.%IsDefined("core"))&&(ItemJson.%Get("core")'=ItemJson.%Get("name"))
		{
			s core=ItemJson.%Get("core") ///上位词
		}
		else
		{
			s core=""
		}
		
		if result=""
		{
			s result=type_":"_name_","_"formal"_":"_formal_","_"core"_":"_core
		}
		else
		{
			s result=result_"，"_type_":"_name_","_"formal"_":"_formal_","_"core"_":"_core
		}
	}
	q result
}

/// Creator:wuzhe
/// CreatDate:2021-08-10
/// Description：给主诉识别表中存数据
/// Table: WDT.CDSS.ChiefIdentify
/// Input：Diag:诊断, ThiefInfo:主诉, InfoStr:过NLP后的识别效果，ImportName：导入人员,TaskID：任务集ID，Problem：问题类型，Sign：标记内容，DataID：数据ID
/// Output: 0：保存失败 1：保存成功
/// Others：w ##class(web.CDSS.Demo.ChiefIdentify).SaveChiefIdentify("咳嗽","纳差10+天","+symptom:纳差,formal:食欲减退,core:食欲不振","李白","1","","","")
/// w ##class(web.CDSS.Demo.ChiefIdentify).SaveChiefIdentify("麻疹","皮肤痒","+symptom:痒,formal:痒,core:无","李白","未识别定语","皮肤应该识别出来","1","","")
/// s TimeNow=$ZDATETIME(+$HOROLOG,3)  ///$H：当前日期和时间，+$H：当前日期 $zd $zdt
/// s IPTime=$p(TimeNow,",",1)
ClassMethod SaveChiefIdentify(Diag As %String, ThiefInfo As %String, InfoStr As %String, ImportName As %String, TaskID As %String, Problem As %String, Sign As %String, DataID As %String) As %String
{
	q:Diag="" "0"
	q:ThiefInfo="" "0"
	q:TaskID="" "0"
	s result=""
	s IPTime=+$HOROLOG
	s OPTime=$ZDATETIME($HOROLOG,3)
	
	///传DataID则为修改数据
	if DataID'=""
	{
		///s OPUser="libai"
		s OPUser=$g(%session.Data("LOGON.USERNAME"))
		///修改数据
		s obj=##class(WDT.CDSS.ChiefIdentify).%OpenId(DataID)
		s obj.ProblemType=Problem		                            ///问题类型
		s obj.TagContent=Sign                                       ///标记内容
    	s obj.OperateUser=OPUser							        ///操作人员
	    s obj.OperateTime=OPTime                                   ///操作时间
	    TS
	    s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
        { 
            TC
            s TaskDR=$lg($g(^WDT.CDSS.ChiefIdentifyD(DataID)),11)
            ///修改数据成功时，将操作时间同步到相关联的任务集的操作时间
            s saveresult=##class(web.CDSS.Demo.ChiefTasks).SaveChiefTasks("","",TaskDR_"^^"_OPTime_"^^"_OPUser)
            s result=1
		}
		else
		{
			TRO
			s result=0
		}    
	}
	else
	{
		s Importeor=ImportName
		///s Importeor="wuzhe"
		///s Importeor=$g(%session.Data("LOGON.USERNAME"))
		
		s bobj = ##class(WDT.CDSS.ChiefIdentify).%New()
        s bobj.Diagnosis=Diag		                            //诊断
        s bobj.ChiefCompInfo=ThiefInfo							//主诉
        s bobj.NLPRecognition=""""_InfoStr_""""				    //识别效果
        s bobj.ImportTime=IPTime				                //导入时间（日期）
        s bobj.ImportUser=Importeor	                            //导入人员
        d bobj.TasksDRSetObjectId(TaskID)                       //关联任务集ID
        TS
		s sc=bobj.%Save()
		d bobj.%Close()
		If $$$ISOK(sc)
        { 
            TC
            s result=1
		}
		else
		{
			TRO
			s result=0
		}
	}
		
	q result
}

/// Function：识别效果界面Query
/// CreateDate：2021-08-18
/// Creator：wuzhe
/// Tables：WDT.CDSS.ChiefIdentify
/// Input：Diag：诊断, Chief：主诉，Problem：问题类型， OpName：操作人员，PreDate：操作起始日期，PostDate：操作截止日期，TaskID：任务集ID
/// Output: ID：数据ID，Diagnosis：诊断,ChiefCompInfo：主诉,NLPRecognition：主诉过NLP效果,ProblemType：问题类型,TagContent：标记内容,OperateUser：操作人员,OperateTime：操作时间
/// Others: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.ChiefIdentify", "GetDataList","胃息肉","2021-09-08","2021-09-21","","","","")
Query GetDataList(Diag As %String, Chief As %String, Problem As %String, OpName As %String, PreDate As %String, PostDate As %String, TaskID As %String) As %Query(ROWSPEC = "ID,Diagnosis,ChiefCompInfo,NLPRecognition,ProblemType,TagContent,OperateUser,OperateTime")
{
}

ClassMethod GetDataListExecute(ByRef qHandle As %Binary, Diag As %String, Chief As %String, Problem As %String, OpName As %String, PreDate As %String, PostDate As %String, TaskID As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //处理操作起始日期和截止日期
 s:PreDate["-" PreDate=$zdh(PreDate,3)
 s:PostDate["-" PostDate=$zdh(PostDate,3)
 
 s ID=0
 for
 {
	 s ID=$o(^WDT.CDSS.ChiefIdentifyI("TasksDRIdx",TaskID,ID))
     q:ID=""
     
	 s Diagnosis=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),2)    ///诊断
	 s ChiefCompInfo=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),3)    ///主诉
	 s ProblemType=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),7)    ///问题类型
	 s ImportTime=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),5) ///导入时间
	 s OperateUser=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),10)    ///操作人员
	 s OperateTime=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),9)    ///操作时间
	 s TaskNumber=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),11) ///任务集ID
	 
	 s OperateTimeJunge=""
	 s:OperateTime'="" OperateTimeJunge=$zdh($p(OperateTime," ",1),3)
	 
	 //诊断、主诉、问题类型、操作人员、操作时间；诊断和主诉，操作人员支持模糊查询，其它精确查询，操作日期为Date类型
	 if ((Diagnosis[Diag)||(Diag=""))&((ChiefCompInfo[Chief)||(Chief=""))&((Problem=ProblemType)||(Problem=""))&(OperateUser[OpName)&(((OperateTimeJunge'="")&(OperateTimeJunge>=PreDate))||(PreDate=""))&(((OperateTimeJunge'="")&(OperateTimeJunge<=PostDate))||(PostDate=""))
	 {
	 	s NLPRecognition=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),4)    ///主诉识别效果
	 	s TagContent=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),8) ///标记内容
	 	
	 	d OutputRowCI
	 }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCI
    ///set Data=$lb(ID,Diagnosis,ChiefCompInfo,NLPRecognition,ProblemType,TagContent,OperateUser,OperateTime)
    set ^CacheTemp(repid,ind)=$lb(ID,Diagnosis,ChiefCompInfo,NLPRecognition,ProblemType,TagContent,OperateUser,OperateTime)
    Set ind=ind+1
    quit
}

ClassMethod GetDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataListExecute ]
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

ClassMethod GetDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator:wuzhe
/// CreatDate:2021-08-10
/// Description：从主诉识别表中获取数据
/// Table: WDT.CDSS.ChiefIdentify：主诉识别表
/// Input：Info：诊断名称^^^^任务集ID
/// Output: 诊断"##"主诉1"##"主诉1过NLP识别效果"##"导入时间"##"导入人员"##"任务集ID，诊断"##"主诉2"##"主诉2过NLP识别效果"##"导入时间"##"导入人员"##"任务集ID，..........
/// Others：w ##class(web.CDSS.Demo.ChiefIdentify).GetDataChiefIdentify("胃息肉^^^^1")
ClassMethod GetDataChiefIdentify(Info As %String) As %String
{
	q:Info="" ""
	s Diag=$p(Info,"^^^^",1)
	s Task=$p(Info,"^^^^",2)
	//s TimeNow=+$h ///当天的日期进行限制（只取当天的，即为本次导入数据）
	s AllStr=""
	s ID=0
	for
	{
		s ID=$o(^WDT.CDSS.ChiefIdentifyI("DiaTaskIdx"," "_$ZCONVERT(Diag,"U"),Task,ID))
		q:ID=""
		s ImportTime=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),5)    ///导入时间
		//continue:TimeNow'=ImportTime
		s Diagnosis=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),2)    ///诊断
		s ChiefCompInfo=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),3)    ///主诉
		s NLPRecognition=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),4)    ///主诉识别效果
		s NLPRecognition=$replace(NLPRecognition,"""","")  ///把 " 替换成空
		s ImportUser=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),6)    ///导入人员
		s TaskID=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),11)    ///任务集ID
		
		if NLPRecognition=""
		{
			s NLPRecognition="无法识别主诉"
		}
		
		if AllStr=""
		{
			s AllStr=Diagnosis_"##"_ChiefCompInfo_"##"_NLPRecognition_"##"_ImportTime_"##"_ImportUser_"##"_TaskID
		}
		else
		{
			s AllStr=AllStr_"***"_Diagnosis_"##"_ChiefCompInfo_"##"_NLPRecognition_"##"_ImportTime_"##"_ImportUser_"##"_TaskID
		}
	}
	q AllStr
}

/// Creator: wuzhe
/// CreatDate: 2021-05-20
/// Function:提取疾病关联的诊断因子（疾病字典表） CT.WDT.CDSS.DiseaseDict表的DiseaseName字段-适用1.0
/// Table: CT.WDT.CDSS.DiseaseDict 疾病字典表   User.DHCDSSDiseJoinFactor 疾病关联诊断因子表 User.DHCDSSDiagFactorDict 诊断因子字典表
/// 参考：web.CDSS.DiagDecision.RecomSusDiagData   web.CDSS.CMKB.DiseaseDict
/// Input: DiseaseName：疾病名称 
/// Ouput: "":疾病名称为空/疾病没有关联的诊断因子
///        字符串：诊断因子1##诊断因子2##诊断因子3 .....
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseNameAndInfo("冠状动脉粥样硬化性心脏病")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseNameAndInfo("下肢三度烧伤")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseNameAndInfo("你好")
ClassMethod GetDiseaseNameAndInfo(DiseaseName As %String) As %String
{
	q:DiseaseName="" ""
	s DiagFactorList=""

	s ID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
	q:ID="" ""
	     
	s JoinID=0
	for
	{
		s JoinID=$o(^User.DHCDSSDiseJoinFactorI("DiseaseDRIndex",ID,JoinID))
		q:JoinID=""
			 
		s FactorID=$lg($g(^User.DHCDSSDiseJoinFactorD(JoinID)),5)		 
		s DiagFactorName=$lg($g(^User.DHCDSSDiagFactorDictD(FactorID)),3)
		if DiagFactorList=""
		{
			s DiagFactorList=DiagFactorName    
		}
		else
		{
			s DiagFactorList=DiagFactorList_"##"_DiagFactorName
		}
	}    
	return DiagFactorList
}

/// Creator:wuzhe
/// CreatDate:2021-08-10
/// Description：给主诉识别评测表中存数据
/// Table:
/// Input：Diag：诊断, ThiefInfo：主诉, Recognie：识别效果, Number：频次, WhetherFactor：是否诊断因子,IPTime：导入时间,IPUser：导入人员,Problem：问题类型,Solute：解决方案,TaskID：任务集ID,DataID：数据ID
/// Output: 1:保存成功 0:保存失败
/// w ##class(web.CDSS.Demo.ChiefIdentify).SaveChiefIdentifyEval("胃息肉","腹痛10+天","腹痛","1","0","65997","杨继鸿","","")   Time As %TimeStamp
ClassMethod SaveChiefIdentifyEval(Diag As %String, ThiefInfo As %String, Recognie As %String, Number As %Integer, WhetherFactor As %Integer, IPTime As %String, IPUser As %String, Problem As %String, Solute As %String, TaskID As %String, DataID As %String) As %String
{
	q:Diag="" ""
	//万一出现，问题类型没选择，填了解决方案（操作人员大意），排除这种情况，不进行保存
	//q:((Problem="")&(Solute'="")) "问题类型为空不保存"
	s result=""
	
	//如果问题类型是空肯定是新增,如果问题类型非空则是修改数据
	if Problem=""
	{
		s obj = ##class(WDT.CDSS.ChiefIdentifyEval).%New()
        s obj.Diagnosis=Diag		                                //诊断
        s obj.ChiefCompInfo=ThiefInfo							    //主诉
        s obj.Recognition=Recognie						            //识别效果
        s obj.Frequency=Number				                        //识别效果的频次
        s obj.FactorFlag=WhetherFactor	                            //是否诊断因子
        s obj.ImportTime=IPTime				                    //导入时间
        s obj.ImportUser=IPUser	                                //导入人员
        d obj.TasksDRSetObjectId(TaskID)                           ///任务集ID
        
        TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
        { 
            TC
            s result=1
		}
		else
		{
			TRO
			s result=0
		}
	}
	else
	{
	    //s OPUser="libai"
		s OPUser=$g(%session.Data("LOGON.USERNAME"))
		s OPTime=$ZDATETIME($HOROLOG,3)
			
		///修改数据
		
		s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(DataID)
		s obj.ProblemType=Problem		                            ///问题类型
		s obj.Solution=Solute                                       ///解决方案
		s obj.OperateUser=OPUser							        ///操作人员
		s obj.OperateTime=OPTime                                    ///操作时间
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
		    TC
		    s TaskDR=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(DataID)),13)
		    //更新任务集的操作时间
	        s saveresult=##class(web.CDSS.Demo.ChiefTasks).SaveChiefTasks("","",TaskDR_"^^"_OPTime_"^^"_OPUser)
		    s result=1
		}
		else
		{
			TRO
		    s result=0
	    }
	}
	q result
}

/// Function：查因标记界面Query
/// CreateDate：2021-08-18
/// Creator：wuzhe
/// Tables：WDT.CDSS.ChiefIdentifyEval
/// Input：Diag：诊断，NLPRecognition：主诉识别效果,Problem：问题类型, OpName：操作人员, PreDate：操作起始时间, PostDate：操作截止时间，PreFrequence：频次下限 ,PostFrequence：频次上限，TaskID：任务集ID
/// Output: ID:数据ID,Diagnosis:诊断,Recognition:主诉识别效果,Frequency:频次,ProblemType:问题类型,Solution:解决方案,OperateTime;操作时间,OperateUser:操作人员
/// Others: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.ChiefIdentify", "GetDataCIE","","","","","","","","","1")
/// /// d ##class(%ResultSet).RunQuery("web.CDSS.Demo.ChiefIdentify", "GetDataCIE","腰椎","","","D","","","","","1")
Query GetDataCIE(Diag As %String, NLPRecognition As %String, Problem As %String, OpName As %String, PreDate As %String, PostDate As %String, PreFrequence As %String, PostFrequence As %String, TaskID As %String) As %Query(ROWSPEC = "ID,Diagnosis,Recognition,Frequency,ProblemType,Solution,OperateTime,OperateUser,ChiefCompInfo")
{
}

ClassMethod GetDataCIEExecute(ByRef qHandle As %Binary, Diag As %String, NLPRecognition As %String, Problem As %String, OpName As %String, PreDate As %String, PostDate As %String, PreFrequence As %String, PostFrequence As %String, TaskID As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //处理操作起始日期和操作截止日期
 s:PreDate["-" PreDate=$zdh(PreDate,3)
 s:PostDate["-" PostDate=$zdh(PostDate,3)
 
 s ID=0
 for
 {
	 s ID=$o(^WDT.CDSS.ChiefIdentifyEvalI("TasksDRIdx",TaskID,ID))
	 q:ID=""
	 s Diagnosis=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),2)    ///诊断
	 s Recognition=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),4)    ///主诉识别效果
	 s Frequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),5)		///频次
	 continue:Frequency<=0
	 s ProblemType=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),7)     ///问题类型
	 ///s ImportTime=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),9)      ///导入时间
	 ///s ImportTimeJunge=""
	 ///s:ImportTime'="" ImportTimeJunge=$zdh($p(ImportTime," ",1),3)
	 
	 s OperateTime=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),11)    ///操作时间
	 s OperateUser=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),12)    ///操作人员
	 s OperateTimeJunge=""
	 s:OperateTime'="" OperateTimeJunge=$zdh($p(OperateTime," ",1),3)

	 if (ProblemType="ED")
	 {
	 	s ChiefCompInfo=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),3)
	 }else{
		s ChiefCompInfo="" 
	 }
	 
	 
	 //支持诊断、识别效果、频次、问题种类、操作人员、操作时间；诊断和识别效果，操作人员是模糊查询，频次需要支持多选（范围）
	 ///if ((TxtContent=Diagnosis)||(WhetherHasChief=1)||(TxtContent=ProblemType)||(TxtContent=OperateUser)||(TxtContent=""))&(((ImportTimeJunge'="")&(ImportTimeJunge>=PreDate))||((OperateTimeJunge'="")&(OperateTimeJunge>=PreDate))||(PreDate=""))&(((ImportTimeJunge'="")&(ImportTime<=PostDate))||((OperateTimeJunge'="")&(OperateTimeJunge<=PostDate))||(PostDate=""))
	 if (Diagnosis[Diag)&(Recognition[NLPRecognition)&((Problem="")||(ProblemType=Problem))&(OperateUser[OpName)&(((OperateTimeJunge'="")&(OperateTimeJunge>=PreDate))||(PreDate=""))&(((OperateTimeJunge'="")&(OperateTimeJunge<=PostDate))||(PostDate=""))&((Frequency>=PreFrequence)||(PreFrequence=""))&((Frequency<=PostFrequence)||(PostFrequence=""))
	 {
	 	s Solution=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),8)    ///处理内容
	 	
	 	d OutputRowCIE
	 }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCIE
    ///set Data=$lb(ID,Diagnosis,ChiefCompInfo,Recognition,ImportTime,ImportUser,ProblemType,OperateTime,OperateUser)
    set ^CacheTemp(repid,ind)=$lb(ID,Diagnosis,Recognition,Frequency,ProblemType,Solution,OperateTime,OperateUser,ChiefCompInfo)
    Set ind=ind+1
    quit
}

ClassMethod GetDataCIEFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataCIEExecute ]
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

ClassMethod GetDataCIEClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataCIEExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator:wuzhe
/// CreatDate:2021-08-10
/// Description：给诊断命中率统计表中新增数据/修改数据（时间限制为当天）
/// Table:WDT.CDSS.ChiefDiaHitRate
/// Input：Diag：诊断, Range：命中范围，HitNumber：命中率，IpTime：导入时间，IpUser；导入人员，TaskID：任务集ID
/// Output: 1：保存成功 0：保存失败
/// 
/// 更新按钮 新增数据/修改数据（时间限制为当天）
/// w ##class(web.CDSS.Demo.ChiefIdentify).SaveChiefDiaHitRate("阑尾炎","所有","0.3","66057","wuzhe","1")
/// w ##class(web.CDSS.Demo.ChiefIdentify).SaveChiefDiaHitRate("阑尾炎","所有","0.8","66057","wuzhe","1")
ClassMethod SaveChiefDiaHitRate(Diag As %String, Range As %String, HitNumber As %String, IpTime As %String, IpUser As %String, TaskID As %String) As %String
{
	///q Diag_" "_Range_" "_HitNumber_" "_IpTime_" "_IpUser_" "_TaskID
	s result=""
	s (ID,HitPast)=""
	s UpTime=+$HOROLOG
	
	///诊断+命中范围+更新时间+任务集ID
	s ID=$o(^WDT.CDSS.ChiefDiaHitRateI("DisHitUpdateTaskIdx"," "_$ZCONVERT(Diag,"U")," "_Range,UpTime,TaskID,0))
	s:ID'="" HitPast=$lg($g(^WDT.CDSS.ChiefDiaHitRateD(ID)),4)
	
	if ID=""  //新增数据
	{
		s obj = ##class(WDT.CDSS.ChiefDiaHitRate).%New()
	    s obj.Diagnosis=Diag		                                //诊断
	    ///s obj.ChiefCompInfo=ThiefInfo							//主诉
	    s obj.DiaHitRate=HitNumber						            //命中率
	    s obj.HitRange=Range				                        //命中范围
	    s obj.ImportTime=IpTime                                     //数据导入时间
	    s obj.ImportUser=IpUser	                                    //数据导入人员
	    s obj.UpdateTime=UpTime                                     //更新时间
	    d obj.TasksDRSetObjectId(TaskID)                            //任务集ID
	    TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
	    { 
	        TC
	        s result=1
		}
		else
		{
			TRO
			s result=0
		}
	}
	elseif (ID'="")&(HitPast'=HitNumber)&(HitPast'="")  //修改数据
	{
		///修改数据
		s obj=##class(WDT.CDSS.ChiefDiaHitRate).%OpenId(ID)
		
		s obj.DiaHitRate=HitNumber //修改命中率
	    TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
	    { 
	        TC
	        s result=1
		}
		else
		{
			TRO
			s result=0
		}
		
	}
	q result
}

/// Function：命中率统计界面Query
/// CreateDate：2021-08-18
/// Creator：wuzhe
/// Tables：WDT.CDSS.ChiefDiaHitRate
/// Input：Diag：诊断,UpDTime：更新命中率时间, hitRange: 命中范围，TaskID：任务集ID
/// Output:ID：数据ID,Diagnosis：诊断,HitRange：命中范围,PastHitRate：更新时间的命中率,DiaHitRate：本次命中率,Effect：效果（命中率是否有提升）
/// Others:
/// d ##class(%ResultSet).RunQuery("web.CDSS.Demo.ChiefIdentify", "GetDataCDHR","","2021-11-09","","1")
/// d ##class(%ResultSet).RunQuery("web.CDSS.Demo.ChiefIdentify", "GetDataCDHR","","","","1")
/// 
/// 四个字段的索引然后 更新时间是“-1” 找出最新的一条的ID和命中率 任务集ID+诊断+范围+更新时间的索引 诊断和范围不为空
Query GetDataCDHR(Diag As %String, UpDTime As %String, hitRange As %String, TaskID As %String) As %Query(ROWSPEC = "ID,Diagnosis,HitRange,PastHitRate,DiaHitRate,Effect")
{
}

ClassMethod GetDataCDHRExecute(ByRef qHandle As %Binary, Diag As %String, UpDTime As %String, hitRange As %String, TaskID As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s HasDiagnosis={} //要展示的诊断的命中率数据
 //处理更新时间
 s:UpDTime["-" UpDTime=$zdh(UpDTime,3)
 
 s RID=0
 for
 {
	 s RID=$o(^WDT.CDSS.ChiefDiaHitRateI("TasksDRIdx",TaskID,RID))
	 q:RID=""
	 s Dia=$lg($g(^WDT.CDSS.ChiefDiaHitRateD(RID)),2)    ///诊断
	 s HitR=$lg($g(^WDT.CDSS.ChiefDiaHitRateD(RID)),5)    ///命中范围
	 
	 ///按诊断,命中范围 查询，诊断支持模糊查询
	 if (Dia[Diag)&((hitRange=HitR)||(hitRange=""))
	 {
		 s DiaHit=$lg($g(^WDT.CDSS.ChiefDiaHitRateD(RID)),4)    ///本次命中率
		 d HasDiagnosis.%Set(Dia_"##"_HitR,RID_"##"_DiaHit) 	
	 }
 }
 
 s HasDiagIterator=HasDiagnosis.%GetIterator()     //迭代器
 while HasDiagIterator.%GetNext(.key,.value) //循环迭代器
 {
	 s ID=$p(value,"##",1)  //数据ID
	 s Diagnosis=$p(key,"##",1)    ///诊断
	 s HitRange=$p(key,"##",2)    ///命中范围
	 s DiaHitRate=$p(value,"##",2) ///命中率
	 
	 s PastHitRate=""
	 s:UpDTime'="" PastHitRate=..GetRateByPastTime(Diagnosis,HitRange,UpDTime,TaskID) ///更新时间的命中率 加上任务集ID
		 	
	 s Effect=""
	 s:UpDTime'="" Effect=DiaHitRate-PastHitRate
	 d OutputRowCDHR
 }
 
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCDHR
    ///set Data=$lb(ID,Diagnosis,HitRange,PastHitRate,DiaHitRate,Effect)
    set ^CacheTemp(repid,ind)=$lb(ID,Diagnosis,HitRange,PastHitRate,DiaHitRate,Effect)
    Set ind=ind+1
    quit
}

ClassMethod GetDataCDHRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataCDHRExecute ]
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

ClassMethod GetDataCDHRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataCDHRExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator:wuzhe
/// CreatDate:2021-08-25
/// Description：通过诊断，命中范围和更新时间找到数据的命中率
/// Table：WDT.CDSS.ChiefDiaHitRate
/// Input：Diag：诊断, Range：命中范围, PostIPTime：更新时间  TaskID：任务集ID
/// Output: result： 命中率/""    "":空就是没找到符合条件的数据
/// Others：w ##class(web.CDSS.Demo.ChiefIdentify).GetRateByPastTime("阑尾炎","所有","66057","1")     加上任务集ID
ClassMethod GetRateByPastTime(Diag As %String, Range As %String, UpDTime As %String, TaskID As %String) As %String
{
	s result=""
	q:Diag="" ""
	q:Range="" ""
	q:UpDTime="" ""
	s ID=$o(^WDT.CDSS.ChiefDiaHitRateI("DisHitUpdateTaskIdx"," "_$ZCONVERT(Diag,"U")," "_Range,UpDTime,TaskID,0))
	q:ID="" ""
		
	s DiaHitRate=$lg($g(^WDT.CDSS.ChiefDiaHitRateD(ID)),4)    ///命中率
	s result=DiaHitRate
	
	q result
}

/// Creator: wuzhe
/// CreatDate:2021-09-11
/// Function:获取疾病关联的诊断因子    提取CT.WDT.CDSS.DiseaseDict表的DiseaseName字段（疾病字典表）-适用1.0
/// Table: CT.WDT.CDSS.DiseaseDict 疾病字典表   ^CT.WDT.CDSS.DiseaseDictD  User.DHCDSSDiseJoinFactor 疾病关联诊断因子表  ^User.DHCDSSDiseJoinFactorD  User.DHCDSSDiagFactorDict 诊断因子字典表  ^User.DHCDSSDiagFactorDictD
/// 参考：web.CDSS.DiagDecision.RecomSusDiagData   web.CDSS.CMKB.DiseaseDict
/// Input：DiseaseIn：诊断名称
/// Output: "":疾病名称为空/疾病没有关联的诊断因子/疾病字典表中没有这个诊断  
///         字符串：诊断因子1##诊断因子2##诊断因子3 ..... 
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseLinkFactor("下肢三度烧伤")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseLinkFactor("你好")
ClassMethod GetDiseaseLinkFactor(DiseaseName As %String) As %String
{
	q:DiseaseName="" ""
	s DiagFactorList=""
	
	s ID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0)) //疾病字典
	s:ID="" ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",DiseaseName,0)) //通用别名表
	q:ID="" ""

	s JoinID=0
	for
	{
		s JoinID=$o(^User.DHCDSSDiseJoinFactorI("DiseaseDRIndex",ID,JoinID)) //疾病关联诊断因子1.0
		q:JoinID=""
		 
		s FactorID=$lg($g(^User.DHCDSSDiseJoinFactorD(JoinID)),5) //诊断因子字典1.0
		s DiagFactorName=$lg($g(^User.DHCDSSDiagFactorDictD(FactorID)),3)
		if DiagFactorList=""
		{
			s DiagFactorList=DiagFactorName    
		}
		else
		{
			s DiagFactorList=DiagFactorList_"##"_DiagFactorName
		}
	}    
	
	q DiagFactorList
}

/// Creator: wuzhe
/// CreatDate:2021-09-17
/// Function: 获取临时global的值，^TMP("WZ")：这一个诊断中目前导入数据的个数
/// Table: 
/// Input：无入参
/// Output: 临时global的值
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).GetTempGlobalValue("你好")
ClassMethod GetTempGlobalValue(Value As %String) As %String
{
	s result=^TMP("WZ")
	q result
}

/// Function:得到诊断的ID
/// Table: CT.WDT.CDSS.DiseaseDict：疾病字典表
/// Creator: wuzhe
/// CreatDate：2021-09-24
/// Input:Diag：诊断的名称   
/// Output: 能找到：诊断^ID     找不到：诊断^0
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("急性胃肠炎")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("急性肠胃炎")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("阑尾炎")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("腹胀")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("胃食管反流")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("胃食管反流病")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("天气好")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("系统性红斑狼疮")
/// 若诊断编码中包括R则不是诊断，不包含R的都是诊断
/// 
/// 用别名通用表，表里面可以根据疾病别名找到疾病ID 
/// 部位进行测试 w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseID("二腹肌三角")
ClassMethod GetDiseaseID(Diag As %String) As %String
{
	q:Diag="" ""
	s Result=""
	
	s DisDictID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Diag,"U"),0))
	if DisDictID=""
	{
		///一个别名不会对应多个诊断（已经确认）
		s DisID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",Diag,0))
		//s DisID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.BodyPartsDict",Diag,DisID))  //部位别名进行测试，暂无疾病别名数据
		
		q:DisID="" Diag_"^0"
		s Result=Diag_"^"_DisID
		
		///适用于一个别名对应多个诊断的情况
		/*s DisID=0
		for
		{
			s DisID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",Diag,DisID))
			//s DisID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.BodyPartsDict",Diag,DisID))  //部位别名进行测试，暂无疾病别名数据
		
			q:DisID=""
			s:Result="" Result=Diag_"^"_DisID
			s:Result'="" Result=Result_"***"_Diag_"^"_DisID
		}*/
		
	}
	else
	{
		s Result=Diag_"^"_DisDictID
	}
	
	q Result
}

/// Function:获取所有的更新时间
/// Table: WDT.CDSS.ChiefDiaHitRate：诊断命中率统计表
/// Creator: wuzhe
/// CreatDate：2021-09-30
/// Input: TaskID：任务集ID
/// Output: 时间1,时间2,..../时间1    "":没有更新时间/任务集ID为空 
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).GetPastIPTime("1")
/// 加上任务集ID+更新时间的索引
ClassMethod GetPastIPTime(TaskID As %String) As %String
{
	q:TaskID="" ""
	s AllPastTime=""
	s ID=0
	
	s Updatetime=""
	for
	{
		s Updatetime=$o(^WDT.CDSS.ChiefDiaHitRateI("TaskUpdateIdx",TaskID,Updatetime)) ///只输出不重复的更新时间
		q:Updatetime=""
		
		s UpdatetimeNew=$zd(Updatetime,3)
		if AllPastTime=""
		{
			s AllPastTime=UpdatetimeNew
		}
		else
		{
			s AllPastTime=AllPastTime_","_UpdatetimeNew
		}
	}
	q AllPastTime
}

/// Creator:wuzhe
/// CreatDate:2021-11-06
/// Description：从主诉识别表中获取数据
/// Table:WDT.CDSS.ChiefIdentify
/// Input：Diag：诊断名称,TaskID：任务集ID
/// Output: "":没数据   主诉##导入时间##导入人员    主诉1##导入时间##导入人员***主诉2##导入时间##导入人员
/// Others：w ##class(web.CDSS.Demo.ChiefIdentify).GetDataChiefIdentifyUpData("咳嗽","1")
ClassMethod GetDataChiefIdentifyUpData(Diag As %String, TaskID As %String) As %String
{
	q:Diag="" ""
	s AllStr=""
	s ID=0
	for
	{
		s ID=$o(^WDT.CDSS.ChiefIdentifyI("DiaTaskIdx"," "_$ZCONVERT(Diag,"U"),TaskID,ID))
		q:ID=""
		
		s ChiefCompInfo=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),3)    ///主诉
		s ImportTime=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),5)    ///导入时间
		s ImportUser=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),6)    ///导入人员
		s ProblemType=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),7)   ///问题类型
		
		if AllStr=""
		{
			s AllStr=ChiefCompInfo_"##"_ImportTime_"##"_ImportUser_"##"_ProblemType
		}
		else
		{
			s AllStr=AllStr_"***"_ChiefCompInfo_"##"_ImportTime_"##"_ImportUser_"##"_ProblemType
		}
	}
	q AllStr
}

/// Creator:wuzhe
/// CreatDate:2022-02-09
/// Description：查因标记界面更新识别效果的频次（去除识别效果界面的 “书写错误” 和 “诊断与主诉不相关数据”）
/// Table:WDT.CDSS.ChiefIdentify    WDT.CDSS.ChiefIdentifyEval
/// Input：Diag：诊断名称,TaskID：任务集ID
/// Output: 0:没数据/找到数据个数和修改数据个数不一致   1:更新成功    识别效果界面未标注完   已更新数据，不可进行二次更新
/// Others：w ##class(web.CDSS.Demo.ChiefIdentify).UpDataFrequence("7")
/// w ##class(web.CDSS.Demo.ChiefIdentify).UpDataFrequence("10")
/// 只允许更新一次，更新多次没作用，反而会过多减少频次
ClassMethod UpDataFrequence(TaskID As %String) As %String
{
	q:(TaskID="") 0
	
	s PlanNum=##class(web.CDSS.Demo.ChiefTasks).GetNumberOfCI(TaskID)
	q:($p(PlanNum,"/",1)'=$p(PlanNum,"/",2)) "识别效果界面未标注完"
	
	s WhetherUpdate=$lg($g(^CT.WDT.CDSS.ChiefTasksD(TaskID)),7)
	q:WhetherUpdate=1 "已更新数据，不可进行二次更新"
	
	s (ID,num,result,savenum)=0  //num：找到需要修改的识别效果个数 savenum：修改成功数据个数
	
	for
	{
		s ID=$o(^WDT.CDSS.ChiefIdentifyI("TasksDRIdx",TaskID,ID))
		q:ID=""
		
		s Diagnosis=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),2)    ///诊断
		s ChiefCompInfo=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),3)   ///主诉
		s NLPRecognition=$replace($lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),4),"""","")    ///识别效果
		s ProblemType=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),7)    ///问题类型
		s TagContent=$replace($lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),8),"""","")    ///标记内容
	    continue:(ProblemType'="主诉与诊断不相关")&(ProblemType'="书写错误")
	    
	    if (ProblemType="主诉与诊断不相关")
	    {
			if NLPRecognition["，"
		    {
			    for m=1:1:$l(NLPRecognition,"，")
				{
					s Recognition=$p($p($p(NLPRecognition,"，",m),",",1),":",2)
					continue:Recognition=""
					s ReID=$o(^WDT.CDSS.ChiefIdentifyEvalI("DiaRecognitionTaskIdx",Diagnosis,Recognition,TaskID,0))
					continue:ReID=""
					s UpFrequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ReID)),5)-1    ///频次
					s num=num+1
					
					///修改数据频次
					s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(ReID)
					s obj.Frequency=UpFrequency		                            ///频次
					
					TS
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
					    TC
					    s savenum=savenum+1
					}
					else
					{
						TRO
				    }
				}
			}
			else
			{
				s Recognition=$p($p(NLPRecognition,",",1),":",2)
				continue:Recognition=""
				s ReID=$o(^WDT.CDSS.ChiefIdentifyEvalI("DiaRecognitionTaskIdx",Diagnosis,Recognition,TaskID,0))
				continue:ReID=""
				s UpFrequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ReID)),5)-1    ///频次
				s num=num+1
				
				///修改数据频次
				s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(ReID)
				s obj.Frequency=UpFrequency		                            ///频次
				
				TS
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
				    TC
				    s savenum=savenum+1
				}
				else
				{
					TRO
			    }
			}
		}
		elseif(ProblemType="书写错误")
		{
			if TagContent["，"
		    {
			    for m=1:1:$l(TagContent,"，")
				{
					s Recognition=$p($p(TagContent,"，",m),"应为",1)
					continue:Recognition=""
					s ReID=$o(^WDT.CDSS.ChiefIdentifyEvalI("DiaRecognitionTaskIdx",Diagnosis,Recognition,TaskID,0))
					continue:ReID=""
					s UpFrequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ReID)),5)-1    ///频次
					s num=num+1
					
					///修改数据频次
					s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(ReID)
					s obj.Frequency=UpFrequency		                            ///频次
					
					TS
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
					    TC
					    s savenum=savenum+1
					}
					else
					{
						TRO
				    }	
				}
			}
			else
			{
				s Recognition=$p(TagContent,"应为",1)
				continue:Recognition=""
				s ReID=$o(^WDT.CDSS.ChiefIdentifyEvalI("DiaRecognitionTaskIdx",Diagnosis,Recognition,TaskID,0))
				continue:ReID=""
				s UpFrequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ReID)),5)-1    ///频次
				s num=num+1
				
				///修改数据频次
				s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(ReID)
				s obj.Frequency=UpFrequency		                            ///频次
				
				TS
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
				    TC
				    s savenum=savenum+1
				}
				else
				{
					TRO
			    }
			}
		}  
	}
	
	if (num=savenum)
	{
		///修改数据是否更新
		s obj=##class(CT.WDT.CDSS.ChiefTasks).%OpenId(TaskID)
		s obj.WhetherUpdate=1		                            ///是否更新（书写错误，主诉与诊断不相关数据）
		
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
		    TC
		    s result=1
		}
		else
		{
			TRO
	    }
	}
	
	q result
}

/// Creator:wuzhe
/// CreatDate:2022-02-14
/// Description：查因标记界面更新识别效果的频次（去除识别效果界面的 “书写错误” 和 “诊断与主诉不相关数据”）
/// Table:WDT.CDSS.ChiefIdentify    WDT.CDSS.ChiefIdentifyEval
/// Input：Diag：诊断名称,TaskID：任务集ID
/// Output: 0:没数据/找到数据个数和修改数据个数不一致   1:更新成功    识别效果界面未标注完   已更新数据，不可进行二次更新
/// Others：w ##class(web.CDSS.Demo.ChiefIdentify).UpDataFrequenceNew("1")
ClassMethod UpDataFrequenceNew(TaskID As %String) As %String
{
	q:(TaskID="") 0
	
	s PlanNum=##class(web.CDSS.Demo.ChiefTasks).GetNumberOfCI(TaskID)
	q:($p(PlanNum,"/",1)'=$p(PlanNum,"/",2)) "识别效果界面未标注完"
	
	s WhetherUpdate=$lg($g(^CT.WDT.CDSS.ChiefTasksD(TaskID)),7)
	s WhetherUpdate=0
	q:WhetherUpdate=1 "已更新数据，不可进行二次更新"
	
	s (ID,num,result,savenum)=0  //num：找到需要修改的识别效果个数 savenum：修改成功数据个数
	
	for
	{
		s ID=$o(^WDT.CDSS.ChiefIdentifyI("TasksDRIdx",TaskID,ID))
		q:ID=""
		
		s Diagnosis=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),2)    ///诊断
		s ChiefCompInfo=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),3)   ///主诉
		s NLPRecognition=$replace($lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),4),"""","")    ///识别效果
		s ProblemType=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),7)    ///问题类型
		s TagContent=$replace($lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),8),"""","")    ///标记内容
	    continue:(ProblemType'="主诉与诊断不相关")&(ProblemType'="书写错误")
	    
	    if (ProblemType="主诉与诊断不相关")
	    {
			if NLPRecognition["，"
		    {
			    for m=1:1:$l(NLPRecognition,"，")
				{
					s Recognition=$p($p($p(NLPRecognition,"，",m),",",1),":",2)
					continue:Recognition=""
					s ReID=$o(^WDT.CDSS.ChiefIdentifyEvalI("DiaRecognitionTaskIdx",Diagnosis,Recognition,TaskID,0))
					continue:ReID=""
					s UpFrequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ReID)),5)-1    ///频次
					s num=num+1
					
					///修改数据频次
					s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(ReID)
					s obj.Frequency=UpFrequency		                            ///频次
					
					TS
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
					    TC
					    s savenum=savenum+1
					}
					else
					{
						TRO
				    }
				}
			}
			else
			{
				s Recognition=$p($p(NLPRecognition,",",1),":",2)
				continue:Recognition=""
				s ReID=$o(^WDT.CDSS.ChiefIdentifyEvalI("DiaRecognitionTaskIdx",Diagnosis,Recognition,TaskID,0))
				continue:ReID=""
				s UpFrequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ReID)),5)-1    ///频次
				s num=num+1
				
				///修改数据频次
				s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(ReID)
				s obj.Frequency=UpFrequency		                            ///频次
				
				TS
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
				    TC
				    s savenum=savenum+1
				}
				else
				{
					TRO
			    }
			}
		}
		elseif(ProblemType="书写错误")
		{
			if TagContent["，"
		    {
			    for m=1:1:$l(TagContent,"，")
				{
					s Recognition=$p($p(TagContent,"，",m),"应为",1)
					continue:Recognition=""
					s ReID=$o(^WDT.CDSS.ChiefIdentifyEvalI("DiaRecognitionTaskIdx",Diagnosis,Recognition,TaskID,0))
					continue:ReID=""
					s UpFrequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ReID)),5)-1    ///频次
					s num=num+1
					
					///修改数据频次
					s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(ReID)
					s obj.Frequency=UpFrequency		                            ///频次
					
					TS
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
					    TC
					    s savenum=savenum+1
					}
					else
					{
						TRO
				    }
				}
			}
			else
			{
				s Recognition=$p(TagContent,"应为",1)
				continue:Recognition=""
				s ReID=$o(^WDT.CDSS.ChiefIdentifyEvalI("DiaRecognitionTaskIdx",Diagnosis,Recognition,TaskID,0))
				continue:ReID=""
				s UpFrequency=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ReID)),5)-1    ///频次
				s num=num+1
				
				///修改数据频次
				s obj=##class(WDT.CDSS.ChiefIdentifyEval).%OpenId(ReID)
				s obj.Frequency=UpFrequency		                            ///频次
				
				TS
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
				    TC
				    s savenum=savenum+1
				}
				else
				{
					TRO
			    }
			}
		}
	}
	
	if (num=savenum)
	{
		///修改数据是否更新
		s obj=##class(CT.WDT.CDSS.ChiefTasks).%OpenId(TaskID)
		s obj.WhetherUpdate=1		                            ///是否更新（书写错误，主诉与诊断不相关数据）
		
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
		    TC
		    s result=1
		}
		else
		{
			TRO
	    }
	}
	//w num,!
	
	q result
}

/// Function:找疾病名称(入参：诊断名称/别名/非诊断名称非别名)
/// Table: CT.WDT.CDSS.DiseaseDict：疾病字典表  
/// Creator: wuzhe
/// CreatDate：2022-03-03
/// Input:Diag：诊断的名称   
/// Output: 是别名/是诊断：原诊断名称  不是别名&不是诊断：入参
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseNameByAlia("急性胃肠炎")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseNameByAlia("特发性突聋")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseNameByAlia("创伤性蛛网膜下腔出血")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseNameByAlia("慢性分泌性中耳炎")
/// w ##class(web.CDSS.Demo.ChiefIdentify).GetDiseaseNameByAlia("no")
ClassMethod GetDiseaseNameByAlia(Diag As %String) As %String
{
	q:Diag="" ""
	s Result=""
	s DisDictID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Diag,"U"),0)) //疾病字典
	if DisDictID=""
	{
		///一个别名不会对应多个诊断（已经确认）
		s DisDictID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",Diag,0)) //别名通用名
		q:DisDictID="" Diag
		s Result=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisDictID)),3)
	}
	else
	{
		s Result=Diag
	}
	q Result
}

/// Creator:wuzhe
/// CreatDate:2022-01-14
/// Description：字符串某个位置插入字符
/// Table: 
/// Input：Context：要插入的母体字符串   Data：插入的内容  location：位置
/// Output: 字符串
/// w ##class(web.CDSS.Demo.ChiefIdentify).InsertString("能能","虎崽仔","30")
ClassMethod InsertString(Context As %String, Data As %String, location As %String) As %String
{
    q:Data="" Context
    q:Context="" Data
    s result=""
    
    s:location>$l(Context) location=$l(Context)+1
    s:location<$l(Context) location=1
    
    for m=1:1:$l(Context)+1
	{
		if (m=location)
		{
			s:result'="" result=result_Data
			s:result="" result=Data
		}
		if (m<=$l(Context))
		{
			s:result'="" result=result_$e(Context,m)
			s:result="" result=$e(Context,m)
		}
	}
	q result
}

/// Function:判断是否是诊断，并输出知识库诊断名称
/// Table: CT.WDT.CDSS.DiseaseDict：疾病字典表  
/// Creator: wuzhe
/// CreatDate：2022-03-18
/// Input:Context：字符串  
/// Output: ""
/// Others:w ##class(web.CDSS.Demo.ChiefIdentify).JudgeWhetherDisease("")
ClassMethod JudgeWhetherDisease(Context As %String) As %String
{
	///打开Excel并读取内容
	s file=##class(%File).%New("D:\yangjihong\内涵质控诊断.csv")
	d file.Open("RS")
	//d file.ReadLine() //读Excel的第一行
	
	
	///创建Excel并写内容
	/*s Path="D:\yangjihong\内涵质控诊断对照.csv"
	s filew=##class(%File).%New(Path)  ///创建file对象
	d filew.Open("NWS")      ///打开文件模式
	d filew.WriteLine("内涵质控诊断名称,知识库对照名称,是否一致")*/
	
	while 'file.AtEnd
	{
		s DataString=file.ReadLine()
		continue:DataString=""
		s Disease=$p(DataString,",",1)
		continue:Disease=""
		
		s OurDisease="" //对照名称
		s DisDictID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Disease,"U"),0)) //疾病字典
		if DisDictID=""
		{
			///一个别名不会对应多个诊断
			s DisDictID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",Disease,0)) //别名通用名
			s:DisDictID="" OurDisease="无此诊断"
			s:DisDictID'="" OurDisease=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisDictID)),3) //别名找到的诊断名称赋值对照名称
		}
		else
		{
			s OurDisease=Disease
		}
		
		s:OurDisease=Disease whether=""
		s:OurDisease'=Disease whether="不一致"
	    //d filew.WriteLine(Disease_","_OurDisease_","_whether)
		w Disease_"   知识库诊断:   "_OurDisease_"     "_whether,!
	}
	/*s sc=filew.%Save()
	d filew.Close()*/
	d file.Close()
	
	q ""
}

}
