/// Description：BDP数据导入--批量废除医嘱项目
/// Creator：陈莹
/// CreatDate: 2020-02-24
Class web.BDPExt.EndARCItmMastBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：批量废除医嘱项目保存接口
/// Creator：陈莹
/// CreatDate: 2019-02-24
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'ARCIMRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.EndARCItmMastBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.Entity.CT.ARCItmMast) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	s myVresult=""
	/*s myARCIMRowId=""
	s sub=0
	for
	{
		s sub=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCIMCode),sub)) q:sub=""
		s version=0
		for
		{
			s version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.ARCIMCode),sub,version)) q:version=""
			s Value=$p($g(^ARCIM(sub,version,1)),"^",1)
			IF (Value=Ceobj.ARCIMCode)
			{
				 S myARCIMRowId=sub_"||"_version
			}
		}
	}*/
	S myARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.LinkHospId)
	if myARCIMRowId=""
	{
		s myVresult=myVresult_"医嘱项 "_Ceobj.ARCIMCode_" 不存在，请核对数据"
	}
	else
	{
		S Desc=$p($g(^ARCIM($p(myARCIMRowId,"||",1),$p(myARCIMRowId,"||",2),1)),"^",2)
		if (Ceobj.ARCIMDesc'=Desc)
		{
			s myVresult=myVresult_"医嘱项代码和描述不对应，"
		}
		
		S DateTo=$p($g(^ARCIM($p(myARCIMRowId,"||",1),$p(myARCIMRowId,"||",2),7)),"^",1)
		if (DateTo'="")
		{
			s myVresult=myVresult_"医嘱项已经停用到"_$zd(DateTo,3)_"，不用再次停止，"
		}	
	}
	if myVresult'=""
	{
		 s myVresult=myVresult_"请核对数据"
		 q myVresult		 
	}
	
	s Ceobj.ARCIMEffDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.ARCIMEffDateTo) 
	Tstart		
	s obj=##class(User.ARCItmMast).%OpenId(myARCIMRowId)
	//set obj.ARCIMDesc=obj.ARCIMDesc_"(停用)"  ///2020-01-28  医嘱名称后面加 (停用)
	//set obj.ARCIMOrderOnItsOwn="N"     //2020-01-28 独立医嘱标志改成N
	s NewJsonStr="{""ARCIMRowId"":"""_myARCIMRowId_""",""ARCIMCode"":"""_Ceobj.ARCIMCode_""",""ARCIMDesc"":"""_obj.ARCIMDesc_""",""ARCIMEffDate"":"""_obj.ARCIMEffDate_""",""ARCIMEffDateTo"":"""_Ceobj.ARCIMEffDateTo_"""}"     
	s OldJsonStr="{""ARCIMRowId"":"""_myARCIMRowId_""",""ARCIMCode"":"""_Ceobj.ARCIMCode_""",""ARCIMDesc"":"""_Ceobj.ARCIMDesc_""",""ARCIMEffDate"":"""_obj.ARCIMEffDate_""",""ARCIMEffDateTo"":"""_obj.ARCIMEffDateTo_"""}"     
	if $d(%session) Do obj.ARCIMUpdateUserSetObjectId($G(%session.Data("LOGON.USERID"))) 
	Set obj.ARCIMUpdateDate=$P($h,",",1)                                            ;添加日期 ARCIM_UpdateDate
	Set obj.ARCIMUpdateTime=$p($h,",",2)                                            ;添加时间 ARCIM_UpdateTime
	Set obj.ARCIMEffDateTo=Ceobj.ARCIMEffDateTo
	if obj.ARCIMEffDate["," s obj.ARCIMEffDate=$p(obj.ARCIMEffDate,",",1)
	Set obj.ARCIMChgPostFlg="O"
	s sc=obj.%Save()
	if $$$ISOK(sc){
		Tcommit
		s ImportResult = "{success:'true',id:'"_myARCIMRowId_"'}"
		s ^TMPBDPEndData("ARCItmMast",myARCIMRowId)=$zd(+$h,3)
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
		s ImportResult="医嘱项结束日期更新失败:"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		
	}
		
	
	q ImportResult
}

}
