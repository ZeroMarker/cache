Class User.NewClass4 Extends %Persistent
{

/// 获取学生选课数据(query)
/// 夏双玲
/// d ##class(%ResultSet).RunQuery("User.NewClass4" ,"GetStuCrsList","")
Query GetStuCrsList(RowId As %String) As %Query(ROWSPEC = "DHCStParRef:%String,CourseNum:%String,Score:%String,")
{
}

ClassMethod GetStuCrsListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
     s repid=$I(^CacheTemp)
     s ind=1
     if (RowId="")
     {
         s RowId=0
         for
         {
            s RowId=$o(^User.DHCStudentD(RowId)) q:RowId=""
            s CourseNum=0
            for
            {
                s CourseNum=$o(^User.DHCStudentD(RowId,"ChildStudentCourse",CourseNum))  
                q:CourseNum=""
                s Score=$lg(^User.DHCStudentD(RowId,"ChildStudentCourse",CourseNum),2)
                d OutPutRow
            }
        }
    }
    else 
    {
        s CourseNum=0
            for
            {
                s CourseNum=$o(^User.DHCStudentD(RowId,"ChildStudentCourse",CourseNum)) q:CourseNum=""
                s Score=$lg(^User.DHCStudentD(RowId,"ChildStudentCourse",CourseNum),2)
                d OutPutRow
            }
    }
    
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
OutPutRow
        Set Data=$lb(RowId,CourseNum,Score)
        set ^CacheTemp(repid,ind)=Data
        set ind=ind+1
        quit
}

ClassMethod GetStuCrsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStuCrsListExecute ]
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

ClassMethod GetStuCrsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStuCrsListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 父子表插入数据
/// w ##class(User.NewClass4).SaveData("0003","xs",1,"2021-10-21",2,"98")
ClassMethod SaveData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String, CourseNum As %String, Score As %String)
{
    s result=""
    q:StCode="" "StCode为空"
    q:StName="" "StName为空"
    q:CourseNum="" "CourseNum为空"
    q:Score="" "Score为空"
    s:StDob'="" StDob=$zdh(StDob,3)
     s Stu =##class(User.DHCStudentz).%New()
    s Stu.StCode=StCode
    s Stu.StName=StName
    d Stu.StSexDRSetObjectId(StSexDR)
    s Stu.StDob=StDob
    TSTART
    s res=Stu.%Save()
    if (res=1)
    {
        s DHCStParRef=Stu.%Id()
        s StuCrs=##class(User.DHCStudentCoursex).%New()
        d StuCrs.DHCStParRefSetObjectId(DHCStParRef)
        d StuCrs.CourseNumSetObjectId(CourseNum)
        s StuCrs.Score=Score
        s ress=StuCrs.%Save()
        if (ress=1)
        {
            TCOMMIT
            s result="插入成功"    
        }
        else
        {
            TROLLBACK
            s result="插入失败"_$System.OBJ.DisplayError(ress)
        }
    }
    else 
    {
        TROLLBACK
        s result="插入失败"_$System.OBJ.DisplayError(res)
        
    }
    d Stu.%Close()
    d StuCrs.%Close()
    q result
}

Storage Default
{
<Data name="NewClass4DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.NewClass4D</DataLocation>
<DefaultData>NewClass4DefaultData</DefaultData>
<IdLocation>^User.NewClass4D</IdLocation>
<IndexLocation>^User.NewClass4I</IndexLocation>
<StreamLocation>^User.NewClass4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
