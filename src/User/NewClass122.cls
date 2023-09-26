Class User.NewClass122 Extends %RegisteredObject
{

/// d ##class(User.NewClass122).jiasihanCPB(3)
ClassMethod jiasihanCPB(n As %String = "")
{
    s dateTime=$h
    s date=+dateTime
    s Time=$p(dateTime, ",",2)
    //将时间转换成秒的形式
    s time = n*60*60
    s ALLTime = Time + time
    //判断n的情况
    while(ALLTime > (60*60*23))
    {
    s ALLTime= ALLTime-(60*60*24)
    s date= date + 1
    } 
    while(ALLTime<0)
    {
        s ALLTime=ALLTime + (60*60*24)
        s date=date -1
    }
    s ALLTime = $zt(ALLTime)
    s Date = $zd(date,3)
    quit Date_" "_ALLTime
}

}
