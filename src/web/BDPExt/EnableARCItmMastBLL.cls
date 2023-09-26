/// Description：BDP数据导入--批量启用医嘱项目
/// Creator：陈莹
/// CreatDate: 2020-01-29
Class web.BDPExt.EnableARCItmMastBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：批量启用医嘱项目保存接口
/// Creator：陈莹
/// CreatDate: 2020-01-29
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'ARCIMRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.EndARCItmMastBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.Entity.CT.ARCItmMast) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	s myVresult=""
	S myARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.LinkHospId)
	if myARCIMRowId=""
	{
		s myVresult=myVresult_"医嘱项 "_Ceobj.ARCIMCode_" 不存在，"
	}
	else
	{
		S Desc=$p($g(^ARCIM($p(myARCIMRowId,"||",1),$p(myARCIMRowId,"||",2),1)),"^",2)
		if (Ceobj.ARCIMDesc'=Desc)
		{
			s myVresult=myVresult_"医嘱项代码和描述不对应，"
		}
		
	}
	if myVresult'=""
	{
		 s myVresult=myVresult_"请核对数据"
		 q myVresult		 
	}
	Tstart		
	s obj=##class(User.ARCItmMast).%OpenId(myARCIMRowId)
	//s Desc=##class(web.BDP.util.String).Replace(obj.ARCIMDesc,"(停用)","")
	//set obj.ARCIMDesc=Desc  ///2020-01-28  医嘱名称去掉(停用)
	//set obj.ARCIMOrderOnItsOwn="Y"     //2020-01-28 独立医嘱标志改成Y
	s NewJsonStr="{""ARCIMRowId"":"""_myARCIMRowId_""",""ARCIMCode"":"""_Ceobj.ARCIMCode_""",""ARCIMDesc"":"""_obj.ARCIMDesc_""",""ARCIMEffDate"":"""_obj.ARCIMEffDate_""",""ARCIMEffDateTo"":"""_""_"""}"     
	s OldJsonStr="{""ARCIMRowId"":"""_myARCIMRowId_""",""ARCIMCode"":"""_Ceobj.ARCIMCode_""",""ARCIMDesc"":"""_Ceobj.ARCIMDesc_""",""ARCIMEffDate"":"""_obj.ARCIMEffDate_""",""ARCIMEffDateTo"":"""_obj.ARCIMEffDateTo_"""}"     
	if $d(%session) Do obj.ARCIMUpdateUserSetObjectId($G(%session.Data("LOGON.USERID"))) 
	Set obj.ARCIMUpdateDate=$P($h,",",1)                                            ;添加日期 ARCIM_UpdateDate
	Set obj.ARCIMUpdateTime=$p($h,",",2)                                            ;添加时间 ARCIM_UpdateTime
	Set obj.ARCIMEffDateTo=""
	if obj.ARCIMEffDate["," s obj.ARCIMEffDate=$p(obj.ARCIMEffDate,",",1)
	Set obj.ARCIMChgPostFlg="O"
	s sc=obj.%Save()
	if $$$ISOK(sc){
		Tcommit
		s ImportResult = "{success:'true',id:'"_myARCIMRowId_"'}"
		s ^TMPBDPEndData("EnableARCItmMast",myARCIMRowId)=$zd(+$h,3)
		///保存医嘱项的有效日期记录
		s flag=##class(web.DHCBL.BDP.FunLib).IsValidClassName("web.DHCBL.CT.ARCItmMastUpdInfo")
		if (flag=1)
		{
			d ##class(web.DHCBL.CT.ARCItmMastUpdInfo).SaveData(myARCIMRowId,obj.ARCIMEffDate,obj.ARCIMEffDateTo)		
		}
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("ARC_ItmMast","User.ARCItmMast","废除医嘱项目",myARCIMRowId,Ceobj.ARCIMDesc,"U",NewJsonStr,OldJsonStr)
		do obj.%Close()
	}
	else
	{
		Trollback
		s ImportResult="医嘱项更新失败:"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		
	}
		
	
	q ImportResult
}

}
