/// Description：用户其他登录科室导入
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月14日
Class web.BDPExt.SSUserOtherLogonLocBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：用户其他登录科室导入保存方法
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月14日
/// Table: User.SSUserOtherLogonLoc
/// Input: eobj对象，具体包括：人事ID	姓名	科室	安全组	是否同步到指定科室(Y/N)	开始日期	结束日期  医院
ClassMethod SaveEntity(Ceobj As web.BDPExt.SSUserOtherLogonLocEntity) As %String
{
	N (Ceobj,%session)
	s result=""
	s eobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.SSUserOtherLogonLoc")
	s result= ##class(web.DHCBL.CT.SSUserOtherLogonLoc).SaveData(eobj,Ceobj.SyncRBFlag)
	q result
}

/// Creator:基础数据平台-李可凡
/// CreatDate:2020年4月20日
/// Description:清除所有用户的其他登陆科室
/// Other:d ##class(web.BDPExt.SSUserBLL).ClearData()
ClassMethod ClearData()
{
	s SSUSRRowId=0
	for  
	{	
		s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
		s sub=0
		for 
		{
			s sub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",sub)) q:sub=""
			s OTHLLRowId=SSUSRRowId_"||"_sub
			d ##class(User.SSUserOtherLogonLoc).%DeleteId(OTHLLRowId)
		}
		k ^SSU("SSUSR",SSUSRRowId,"OTHLL",0)
	}
}

}
