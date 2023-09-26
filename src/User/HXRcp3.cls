Class User.HXRcp3 Extends %RegisteredObject
{

/// 按床号输出病人姓名
/// createdate:2023-9-16
/// creator:黄欣然
/// d ##class(User.HXRcp3).HuangXinranCPB()
ClassMethod HuangXinranCPB()
{
	///向表中添加数据
	k ^TempB
	s ^TempB(1)="学生姓名01^1050^小单人床F"
	s ^TempB(2)="学生姓名02^1000^大单人床A"
	s ^TempB(3)="学生姓名03^1020^单人床C"
	s ^TempB(4)="学生姓名04^1030^贵单人床D"
	s ^TempB(5)="学生姓名05^1010^便宜单人床B"
	///索引
	s RowId = 0
	for
	{
		s RowId = $o(^TempB(RowId))
		q:RowId=""
		s badNo = $p($g(^TempB(RowId)),"^",2)
		s ^TempB(0,"BadNo",badNo,RowId)=""
	}
	///使用索引查询
	s code=""
	for
	{
		s code = $o(^TempB(0,"BadNo",code))
		q:code=""
		s id = $o(^TempB(0,"BadNo",code,0))
		w $p(^TempB(id),"^",1),!
	}
	q ""
}

}
