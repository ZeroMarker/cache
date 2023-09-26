/// 名称: DHCMA.Util.Task.ExecuteQueue
/// 描述: 临床路径挂自动任务
/// 编写者：liuzhenhe
/// 编写日期: 2019-01-08
Class DHCMA.Util.Task.ExecuteQueue Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-08
/// Description:  同步就诊表信息DHCMA.Util.EP.Episode    
/// Input: 		  通过队列类型更新患者信息
/// Return：      异常：空、正常：处理数据条数
/// d ##Class(DHCMA.Util.Task.ExecuteQueue).AutoTask("Disch")
ClassMethod AutoTask(aType As %String) As %String
{
	New (aType)
	Set Count=0
	
	Quit:aType=""
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCMA.Task.ExecuteQueue(YY_"-"_MM,DD))
	Set ^DHCMA.Task.ExecuteQueue(YY_"-"_MM,DD,NUM,"命令")="d ##class(DHCMA.Util.Task.ExecuteQueue).AutoTask("_aType_")"
	Set ^DHCMA.Task.ExecuteQueue(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	Set $zt="Error"	
	For{
		//改写状态
		Set obj=##class(DHCMA.Util.EPx.EpisQueue).FetchTask(aType)
		Quit:'$IsObject(obj)		
		Set OID=obj.EQEpisID 
		Continue:OID=""

		;Set OID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(OID) //完整性检查
		//更新患者信息
		Set flg=##class(DHCMA.Util.EP.Episode).xSetByOID(OID)
		continue:(+flg)<1 
		Set Count=Count+1
	}
	//记录执行任务日志（成功标记）
	Set ^DHCMA.Task.ExecuteQueue(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)

	Quit Count
Error
	Set ^DHCMA.Task.ExecuteQueue(YY_"-"_MM,DD,NUM,"异常(结束)")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	Quit "Error:"_$ZError
}

}
