/// Description：BDP数据导入--批量废除收费项目
/// Creator：陈莹
/// CreatDate: 2020-02-24
Class web.BDPExt.EndDHCTarItemBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：批量废除收费项目保存接口
/// Creator：陈莹
/// CreatDate: 2019-02-24
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'TARIRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.EndDHCTarItemBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.Entity.CT.DHCTarItem) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	s TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Ceobj.TARICode,Ceobj.LinkHospId)
	//s TARIRowId=$o(^DHCTARI(0,"Code",Ceobj.TARICode,0)) 
	s myVresult=""
	if (TARIRowId="")
	{
		s myVresult=myVresult_"收费项 "_Ceobj.TARICode_" 不存在，"
	}
	else
	{
		
		S Desc=$p($g(^DHCTARI(TARIRowId)),"^",2)
		if (Ceobj.TARIDesc'=Desc)
		{
			s myVresult=myVresult_"收费项代码和描述不对应，"
		}
	}
	if myVresult'=""
	{
		 s myVresult=myVresult_"请核对数据"
		 q myVresult		 
	}
	
	s Ceobj.TARIEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Ceobj.TARIEndDate) 
	s Ceobj.TARIActiveFlag="N"
	Tstart		
	s obj=##class(User.DHCTarItem).%OpenId(TARIRowId)
	//set obj.TARIDesc=obj.TARIDesc_"(停用)"  ///2020-01-28  医嘱名称后面加 (停用)
	s NewJsonStr="{""TARIRowId"":"""_TARIRowId_""",""TARICode"":"""_Ceobj.TARICode_""",""TARIDesc"":"""_obj.TARIDesc_""",""TARIEndDate"":"""_Ceobj.TARIEndDate_""",""TARIActiveFlag"":"""_Ceobj.TARIActiveFlag_"""}"     
	s OldJsonStr="{""TARIRowId"":"""_TARIRowId_""",""TARICode"":"""_Ceobj.TARICode_""",""TARIDesc"":"""_Ceobj.TARIDesc_""",""TARIEndDate"":"""_obj.TARIEndDate_""",""TARIActiveFlag"":"""_obj.TARIActiveFlag_"""}"     
	s obj.TARIActiveFlag=Ceobj.TARIActiveFlag
	if (obj.TARIEndDate="")||(obj.TARIEndDate>Ceobj.TARIEndDate) s obj.TARIEndDate=Ceobj.TARIEndDate
	s sc=obj.%Save()
	if $$$ISOK(sc){
	
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_TarItem","User.DHCTarItem","废除收费项目",TARIRowId,Ceobj.TARIDesc,"U",NewJsonStr,OldJsonStr)
		do obj.%Close()
		s ^TMPBDPEndData("DHCTarItem",TARIRowId)=$zd(+$h,3)
		s dateunvflag=0,flag=0
		s OLTStartDate=0
		for
		{
			s OLTStartDate=$o(^DHCOLT(0,"TAR",TARIRowId,OLTStartDate)) Quit:OLTStartDate=""
			s OLTRowId=0
			for
			{
				s OLTRowId=$o(^DHCOLT(0,"TAR",TARIRowId,OLTStartDate,OLTRowId)) Quit:OLTRowId=""
				s EndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
				if (EndDate="")
				{
					if (Ceobj.TARIEndDate<OLTStartDate)
					{
						s dateunvflag=1
					}
					else
					{
						s linkobj=##class(User.DHCOrderLinkTar).%OpenId(OLTRowId)
						s NewJsonStr="{""OLTRowId"":"""_OLTRowId_""",""OLTARCIMDR"":"""_$p($g(^DHCOLT(OLTRowId)),"^",1)_""",""OLTTariffDR"":"""_$p($g(^DHCOLT(OLTRowId)),"^",2)_""",""OLTQty"":"""_$p($g(^DHCOLT(OLTRowId)),"^",3)_""",""OLTStartDate"":"""_OLTStartDate_""",""OLTEndDate"":"""_Ceobj.TARIEndDate_"""}"     
						s OldJsonStr="{""OLTRowId"":"""_OLTRowId_""",""OLTARCIMDR"":"""_$p($g(^DHCOLT(OLTRowId)),"^",1)_""",""OLTTariffDR"":"""_$p($g(^DHCOLT(OLTRowId)),"^",2)_""",""OLTQty"":"""_$p($g(^DHCOLT(OLTRowId)),"^",3)_""",""OLTStartDate"":"""_OLTStartDate_""",""OLTEndDate"":"""_linkobj.OLTEndDate_"""}"     
						s linkobj.OLTEndDate=Ceobj.TARIEndDate
						s sc=linkobj.%Save()
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_OrderLinkTar","User.DHCOrderLinkTar","废除收费项目与医嘱的对照关系",OLTRowId,Ceobj.TARIDesc,"U",NewJsonStr,OldJsonStr)						
						s ^TMPBDPEndData("DHCOrderLinkTar",OLTRowId)=$zd(+$h,3)
					}
				}
				else
				{
					if (EndDate>Ceobj.TARIEndDate) s dateunvflag=1
				}
			}
		}
		
		if dateunvflag=1
		{
			Trollback
			s ImportResult="该收费项与医嘱项的对照关系不满足该结束日期，"
		}
		else
		{
			Tcommit
			s ImportResult = "{success:'true',id:'"_TARIRowId_"'}"
		}
		
	}
	else
	{
		Trollback
		s ImportResult="收费项结束日期更新失败："_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	
	}
	q ImportResult
}

}
