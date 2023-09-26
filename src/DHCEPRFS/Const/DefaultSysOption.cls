Class DHCEPRFS.Const.DefaultSysOption Extends %RegisteredObject
{

/// 默认的最大错误生成次数	
Parameter ErrorMaxCreateCount = 5;

ClassMethod ErrorMaxCreateCount()
{
	quit ..#ErrorMaxCreateCount
}

}
