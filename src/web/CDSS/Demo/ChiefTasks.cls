Class web.CDSS.Demo.ChiefTasks Extends %RegisteredObject
{

/// Creator:wuzhe
/// CreatDate:2021-10-28
/// Description：给任务集表中存数据
/// Table:WDT.CDSS.ChiefTasks
/// Input：Task:任务集名称，IpName:导入人员名称，UpdateInfo：任务集ID^^操作时间^^操作人员
/// Output: 1:修改成功 0:保存失败/修改失败  数据ID：保存成功
/// Others: w ##class(web.CDSS.Demo.ChiefTasks).SaveChiefTasks("第二批剩余数据.xlsx","wuzhe","") 新增
/// w ##class(web.CDSS.Demo.ChiefTasks).SaveChiefTasks("第二批剩余数据.xlsx","wuzhe","")
/// 
/// w ##class(web.CDSS.Demo.ChiefTasks).SaveChiefTasks("第二批剩余数据.xlsx","wuzhe","") 修改
/// 更新信息为空时是新增，更新信息不空时是修改
ClassMethod SaveChiefTasks(Task As %String, IpName As %String, UpdateInfo As %String = "") As %String
{
	///q:Task="" ""
	s result=""
	s IPTime=+$HOROLOG ///当前日期
	
	//若更新信息不为空则为修改
	if UpdateInfo'=""
	{
		///修改数据
		s obj=##class(WDT.CDSS.ChiefTasks).%OpenId($p(UpdateInfo,"^^",1))
		s obj.OperateTime=$p(UpdateInfo,"^^",2)		                            ///操作时间
		s obj.OperateUser=$p(UpdateInfo,"^^",3)                                      ///操作人员
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
	else //新增
	{
		//重复校验，任务集名称不能重复
		s ID=""
		s ID=$o(^WDT.CDSS.ChiefTasksI("NameIdx",Task,ID))
		q:ID'="" "任务集名称不能重名"
		
		s bobj = ##class(WDT.CDSS.ChiefTasks).%New()
        s bobj.TaskName=Task		                            //任务集名称
        s bobj.ImportTime=IPTime				                //导入时间（日期）
        s bobj.ImportUser=IpName	                            //导入人员
        TS
		s sc=bobj.%Save()
		d bobj.%Close()
		If $$$ISOK(sc)
        { 
            TC
            s result=bobj.%Id() ///保存成功的数据ID
		}
		else
		{
			TRO
			s result=0
		}
	}	
	q result
}

/// Function：任务集界面Query
/// CreateDate：2021-10-28
/// Creator：wuzhe
/// Tables：WDT.CDSS.ChiefTasks
/// Input：Task:任务集名称， TimeFlag:时间标志 I:导入时间, O:操作时间;   PreDate：起始时间, PostDate：截止时间
/// Output:ID：数据ID,TaskName：任务集名称,ImportTime：导入时间,OperateTime：操作时间,IdentifyNum：识别效果的标记数量,IdentifyEvalNum：查因标记的标记数量
/// Others: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.ChiefTasks", "GetDataCTASK","测试","I","2021-11-03","2021-11-06")
/// d ##class(%ResultSet).RunQuery("web.CDSS.Demo.ChiefTasks", "GetDataCTASK","测试","I","2021-11-03","2021-11-20")
/// 
/// d ##class(%ResultSet).RunQuery("web.CDSS.Demo.ChiefTasks", "GetDataCTASK","测试","O","2021-11-12 16:41:20","")
Query GetDataCTASK(Task As %String, TimeFlag As %String, PreDate As %String, PostDate As %String) As %Query(ROWSPEC = "ID,TaskName,ImportTime,OperateTime,IdentifyNum,IdentifyEvalNum")
{
}

ClassMethod GetDataCTASKExecute(ByRef qHandle As %Binary, Task As %String, TimeFlag As %String, PreDate As %String, PostDate As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 ///I：导入时间并且起始和截止日期不为空
 s:((TimeFlag="I")&(PreDate'="")) PreDate=$zdh(PreDate,3)
 s:((TimeFlag="I")&(PostDate'="")) PostDate=$zdh(PostDate,3)
 ///O：操作时间并且起始和截止日期不为空
 s:((TimeFlag="O")&(PreDate'="")) PreDate=$zdth(PreDate,3)
 s:((TimeFlag="O")&(PostDate'="")) PostDate=$zdth(PostDate,3)
 ///w PreDate,!
 
 s TaskID=0
 for
 {
	 s TaskID=$o(^WDT.CDSS.ChiefTasksD(TaskID))
	 q:TaskID=""
	 s ID=TaskID  ///任务集ID
	 s TaskName=$lg($g(^WDT.CDSS.ChiefTasksD(ID)),2)    ///任务集名称
	 
	 s ImportTime=""
	 s ImportJungeTime=$lg($g(^WDT.CDSS.ChiefTasksD(ID)),3) ///导入时间判断变量
	 s:ImportJungeTime'="" ImportTime=$zd(ImportJungeTime,3)   ///导入时间
	 
	 s OperateTime=$lg($g(^WDT.CDSS.ChiefTasksD(ID)),5)  ///操作时间
	 s OperateJungeTime=""
	 s:OperateTime'="" OperateJungeTime=$zdth(OperateTime,3)  ///操作时间判断变量
	 
	 s FlagPreData=..ComparePreDateTime(PreDate,OperateJungeTime)  ///比较起始时间和数据操作时间 
	 s FlagPostData=..ComparePostDataTime(PostDate,OperateJungeTime) ///比较截至日期和数据操作时间
	 
	 s IdentifyNum=..GetNumberOfCI(ID)  ///获取识别效果界面的标记数量
	 s IdentifyEvalNum=..GetNumberOfCIE(ID)  ///获取查因标记界面的标记数量
	 
	 ///检索条件：任务集名称，导入时间，操作时间；任务集名称支持模糊查询 
	 ///if (TaskName[Task)&(((TimeFlag="I")&(PreDate<=ImportJungeTime))||(PreDate=""))&(((TimeFlag="I")&(PostDate>=ImportJungeTime))||(PostDate=""))&(((TimeFlag="O")&(FlagPreData=1))||(PreDate=""))&(((TimeFlag="O")&(FlagPostData=1))||(PostDate=""))
	 /*s One=0
	 if TaskName[Task 
	 {
		 s One=1
	 }
	 s Two=0
	 if (((TimeFlag="I")&(PostDate>=ImportJungeTime))||(PostDate=""))&(((TimeFlag="I")&(ImportJungeTime>=PreDate))||(PreDate=""))
	 {
		 s Two=1
	 }
	 s Three=0
	 if (TimeFlag="O")&((FlagPreData=1)||(PreDate=""))&((FlagPostData=1)||(PostDate=""))
	 {
		 s Three=1
	 }
	 
	 
	 ////输出
	 if (One=1)&(((TimeFlag="I")&(Two=1))||((TimeFlag="O")&(Three=1)))
	 {
		 d OutputRowTask
	 }*/
	 
	 
	 if (TaskName[Task)&   ( ( (((TimeFlag="I")&(PostDate>=ImportJungeTime))||(PostDate=""))   &    (((TimeFlag="I")&(ImportJungeTime>=PreDate))||(PreDate="")) )  ||   (  ((TimeFlag="O")&((FlagPreData=1)||(PreDate=""))&((FlagPostData=1)||(PostDate="")))  )  )
	 {
	 	d OutputRowTask
	 }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTask
    ///set Data=$lb(ID,TaskName,ImportTime,OperateTime,IdentifyNum,IdentifyEvalNum)
    set ^CacheTemp(repid,ind)=$lb(ID,TaskName,ImportTime,OperateTime,IdentifyNum,IdentifyEvalNum)
    Set ind=ind+1
    quit
}

ClassMethod GetDataCTASKFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataCTASKExecute ]
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

ClassMethod GetDataCTASKClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataCTASKExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:获取识别效果界面的数据标注量
/// Table: WDT.CDSS.ChiefIdentify：主诉识别表
/// Creator: wuzhe
/// CreatDate：2021-11-01
/// Input:TaskID：任务集ID
/// Output: 字符串：标注数/数据总数
/// Others:w ##class(web.CDSS.Demo.ChiefTasks).GetNumberOfCI("1")
/// 标记：问题类型不为空则为标记数据，为空则为未标记数据
ClassMethod GetNumberOfCI(TaskID) As %String
{
	s Sum=0 //总数据个数
	s Number=0 //标记的数据个数
	s ID=0
	for
	{
		s ID=$o(^WDT.CDSS.ChiefIdentifyI("TasksDRIdx",TaskID,ID))
        q:ID=""
		
		s Sum=Sum+1 
		s ProblemType=$lg($g(^WDT.CDSS.ChiefIdentifyD(ID)),7)
		s:ProblemType'="" Number=Number+1
	}
	q Number_"/"_Sum
}

/// Function:获取查因标记界面的数据标注量
/// Table: WDT.CDSS.ChiefIdentifyEval：主诉识别评测表
/// Creator: wuzhe
/// CreatDate：2021-11-01
/// Input:TaskID：任务集ID
/// Output: 字符串：标注数/数据总数
/// Others:w ##class(web.CDSS.Demo.ChiefTasks).GetNumberOfCIE("1")
ClassMethod GetNumberOfCIE(TaskID) As %String
{
	s Sum=0 //总数据个数
	s Number=0 //标记的数据个数
	s ID=0
	for
	{
		s ID=$o(^WDT.CDSS.ChiefIdentifyEvalI("TasksDRIdx",TaskID,ID))
        q:ID=""
		
		s Sum=Sum+1 
		s ProblemType=$lg($g(^WDT.CDSS.ChiefIdentifyEvalD(ID)),7)
		s:ProblemType'="" Number=Number+1
	}
	q Number_"/"_Sum
}

/// Function:  任务集的操作时间和检索框的操作 起始日期比较大小
/// Table: 
/// Creator: wuzhe
/// CreatDate：2021-11-13
/// Input: PreTime:检索框操作起始时间, DataTime：任务集的操作时间（数据的）
/// Output: 1：数据时间大于等于 起始时间  0：数据时间小于等于 起始时间
/// Others:w ##class(web.CDSS.Demo.ChiefTasks).CompareTwoOPTime("66060,60080","66060,60086")
/// , 肯定在
ClassMethod ComparePreDateTime(PreTime As %String, DataTime As %String) As %String
{
	q:(PreTime="") "1"
	q:(PreTime'="")&(DataTime="") "0"
	
	s result=0
	s OnePartPre=$p(PreTime,",",1)
	s TwoPartPre=$p(PreTime,",",2)
	
	s OnePartData=$p(DataTime,",",1)
	s TwoPartData=$p(DataTime,",",2)
	///起始日期和数据操作时间比较
	if (OnePartData>=OnePartPre)
	{
		if (OnePartData=OnePartPre)
		{
			s:TwoPartData>=TwoPartPre result=1
		}
		else
		{
			s result=1
		}
		
	}
	q result
}

/// Function:  任务集的操作时间和检索框的操作截至日期比较大小
/// Table: 
/// Creator: wuzhe
/// CreatDate：2021-11-13
/// Input: PostTime:检索框操作截至时间, DataTime：任务集的操作时间（数据的）
/// Output: 1：数据时间小于等于 截至时间  0：数据数据时间大于截至时间
/// Others:w ##class(web.CDSS.Demo.ChiefTasks).ComparePostDataTime("66060,60080","66060,60086")
/// w ##class(web.CDSS.Demo.ChiefTasks).ComparePostDataTime("66060,60088","66060,60086")
/// , 肯定在
ClassMethod ComparePostDataTime(PostTime As %String, DataTime As %String) As %String
{
	q:(PostTime="")&(DataTime'="") "0"
	q:(DataTime="") "1"
	
	s result=0
	s OnePartPost=$p(PostTime,",",1)
	s TwoPartPost=$p(PostTime,",",2)
	
	s OnePartData=$p(DataTime,",",1)
	s TwoPartData=$p(DataTime,",",2)
	
	///截至日期和数据操作时间比较
	if (OnePartPost>=OnePartData)
	{
		if (OnePartPost=OnePartData)
		{
			s:TwoPartPost>=TwoPartData result=1
		}
		else
		{
			s result=1
		}
		
	}
	q result
}

}
