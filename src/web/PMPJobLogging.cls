Class web.PMPJobLogging Extends %RegisteredObject
{

/// creater:YANLIU
/// createrdate:2014/10/14
/// description:输出PMPJobLogging表内的记录日期、记录时间、记录者、记录内容、问题描述、附件上传、解决方案、解决日期、解决时间；
/// output:Date,Time,User,Content,Desc,Solution,SolutionDate,SolutionTime；
/// d ##class(%ResultSet).RunQuery("web.PMPJobLogging","PMPJobLogging","2014-10-10","2014-11-24")
Query PMPJobLogging(StDate As %String, EndDate As %String) As %Query(ROWSPEC = "Date1:%String,Time:%String,Content:%String,Desc:%String,Solution:%String,SolutionDate:%String,SolutionTime:%String,Rowid:%String,User:%String")
{
}

ClassMethod PMPJobLoggingExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0) ///以上三行为固定格式；
    f Date=StDate:1:EndDate d 
    .s JLGRowID=1
	.f  s JLGRowID=$o(^PMPJobLogi("JLG_Date",Date,JLGRowID))  q:JLGRowID=""  d
	..s Date1=$p($g(^PMPJobLogging(JLGRowID)),"^",2)        ///取记录日期
	..s Date1=$zd(Date1,3)
	..s Time=$p($g(^PMPJobLogging(JLGRowID)),"^",14)        ///取记录时间 
	..s Time=$zt(Time)
	..s Desc=$p(^PMPJobLogging(JLGRowID),"^",3)         ///取记录描述 
	..s UserDR=$p(^PMPJobLogging(JLGRowID),"^",15)       ///取与ss_user关联的字段userDR
	..s User=""
	..b ;1111
	..i UserDR'="" s User=$p(^SSU("SSUSR",UserDR),"^",2)            ///取ss_user中的用户名
	..b ;222
	..s Content=$p(^PMPJobLogging(JLGRowID),"^",1)      ///取记录内容
	..s Solution=$p($g(^PMPJobLogging(JLGRowID)),"^",7)     ///取解决方案
	..;s UploadDR=$p($g(^PMPJobLog(JLGRowID)),"^",1)    ///取与附件表关联字段UploadDR
	..s SolutionDate=$p($g(^PMPJobLogging(JLGRowID)),"^",5) ///取问题解决日期
	..s SolutionTime=$p($g(^PMPJobLogging(JLGRowID)),"^",6) ///取问题解决时间
    ..s TYPE=$p($g(^PMPJobLogging(JLGRowID)),"^",8) 
    ..Q:TYPE="N"
	..s Rowid=JLGRowID
    ..d Build100         
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build100
	set Data=$lb(Date1,Time,Content,Desc,Solution,SolutionDate,SolutionTime,Rowid,User)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMPJobLoggingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMPJobLoggingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 
 	Quit $$$OK
}

ClassMethod PMPJobLoggingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMPJobLoggingExecute ]
{
		Set AtEnd=$LIST(qHandle,1)
 	    Set repid=$LIST(qHandle,2)
 	    Set ind=$LIST(qHandle,3)
 	    Set ind=$o(^CacheTemp(repid,ind))
 	    If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	             }
 	  Else      
 	  {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	   }
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//*************************增加******************************//

ClassMethod insertJobLogging(Desc As %String, User As %String, Content As %String, Solution As %String, fujian As %String = "") As %String
{
	s ret=""
	s ^zzp("111111")=Desc_"^"_User_"^"_Content_"^"_Solution
	set Date = +$h
	set Time = $p($h,",",2)
	i fujian="" s type="N" 
	I fujian'="" S type="Y"
	&sql(insert into sqluser.PMP_JobLogging (JLG_Date,JLG_Time,JLG_User,JLG_Content,JLG_Desc,JLG_Solution,JLG_DR) values (:Date,:Time,:User,:Content,:Desc,:Solution,:type))
    s ret="1"
    q ret
}

//*************************删除******************************//

ClassMethod deleteJobLogging(Rowid As %String) As %String
{
	
	if (Rowid '="") {
		set object=##class(User.PMPJobLogging).%OpenId(Rowid)
		set object.JLGStandby1="N"
		set sc=object.%Save()
 		quit object.%Id()
		}
}

//*************************更新******************************//

ClassMethod UpdateJobLogging(Rowid As %String, Content As %String, Desc As %String, Solution As %String, Userid As %String) As %String
{
	if (Rowid '="") {
		set object=##class(User.PMPJobLogging).%OpenId(Rowid)
	    set object.JLGUser = Userid
		set object.JLGContent = Content
		set object.JLGDesc = Desc
		set object.JLGSolution = Solution
		set sc=object.%Save()
 		quit object.%Id()
	}
}

/// 单个附件
ClassMethod single(input As %String) As %String
{
	s ret=""
	q:input=""
	f ii=1:1:$l(input,"\")  d
	.i ret="" s ret=$p(input,"\",1)
	.i (ret'="")&(ii'="1") s ret=ret_"\\"_$p(input,"\",ii)
	q ret
}

//s bbb=##class(web.PMP.PMPImprovementList).EscapingChangechang("E:\Foxmail地址簿_20140707.csv||E:\崔丹_人民医院HIS系统录入信息汇总20140707.doc")

/// 多个附件
ClassMethod Multiple(input As %String) As %String
{
	s ret=""
	q:input=""
	f jj=1:1:($l(input,"||")) d
	.s str=$p(input,"||",jj)
	.s ret1=""
	.f ii=1:1:$l(str,"\")  d
	..i ret1="" s ret1=$p(str,"\",1)
	..i (ret1'="")&(ii'="1") s ret1=ret1_"\\"_$p(str,"\",ii)
	..i ii=$l(str,"\")  d
	...i ret'="" s ret=ret_"||"_ret1
	...i ret="" s ret=ret1
	q ret
}

//s bbb=##class(web.PMPJobLogging).selectPMPIImprovementAdjunct("6","Improvement")

ClassMethod selectPMPIImprovementAdjunct(Improve As %String, Affiliation As %String) As %String
{
	s ret=""
	
	q:(Improve="")||(Affiliation="")
	s rowid="" f  s rowid=$o(^PMPImproveAdjuncti("Improve",Improve,Affiliation,rowid)) q:rowid=""  d
	.s IPAJLocation=$p(^PMPImprovementAdjunct(rowid),"^",3)
	.s IPAJName=$p(^PMPImprovementAdjunct(rowid),"^",4)
	.s Location=""
	.f ii=1:1:$l(IPAJLocation,"\")  d
	..i Location="" s Location=$p(IPAJLocation,"\",1)
	..I (Location'="")&(ii'="1") s Location=Location_"\\"_$p(IPAJLocation,"\",ii)
	.i ret'="" s ret=ret_"^"_Location_","_IPAJName
	.i ret="" s ret=Location_","_IPAJName
	Q ret
}

}
