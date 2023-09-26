Class User.NewClass124 Extends %RegisteredObject
{

ClassMethod jiasihanCPB()
{
    //初始化数据
    k ^TempB
    S ^TempB(1)="学生姓名01^1050^小单人床F"
    S ^TempB(2)="学生姓名02^1000^大单人床A"
    S ^TempB(3)="学生姓名03^1020^单人床C"
    S ^TempB(4)="学生姓名04^1030^贵单人床D"
    S ^TempB(5)="学生姓名05^1010^便宜单人床B"
   
    s rowID=0
    for{
        s rowID=$o(^TempB(rowID))
        q:rowID=""
        s badNo=$p($g(^TempB(rowID)),"^",2)
        s ^TempB(0,"BadNo",badNo,rowID)=""
    }
    //根据索引找到id，并输出名称
    s code=""
    for{
        s code=$o(^TempB(0,"BadNo",code))
        q:code=""
        s id=$o(^TempB(0,"BadNo",code,0))
        w $p(^TempB(id),"^",1),!
    }
}

}
