/// Description：收费项导入程序
/// Creator：陈莹
/// CreatDate: 2017-09-01
Class web.BDPExt.DHCTarItemBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：收费项导入保存接口
/// Creator：陈莹
/// CreatDate: 2017-09-01
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'TARIRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.DHCTarItemBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.DHCTarItemEntity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	s:Ceobj.TARIActiveFlag="" Ceobj.TARIActiveFlag="Y"
	s tarieobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItem")
	s tpeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItemPrice")
	///收费项目
	Tstart
	s TARISaveResult=""
	s tarieobj.LinkHospId=Ceobj.LinkHospId
	s TARISaveResult=##class(web.DHCBL.CT.DHCTarItem).SaveEntity(tarieobj)  
	s TARIRowId=##class(web.BDPExt.FunLib).GetResultRowId(TARISaveResult)
	if (TARIRowId'="")
	{		
		///收费项目价格
		s tpeobj.TPTARIParRef=TARIRowId
		s tpeobj.TPHospitalDR=Ceobj.LinkHospId
		s TPSaveResult=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(tpeobj)	
		s TPRowId=##class(web.BDPExt.FunLib).GetResultRowId(TPSaveResult)
		i (TPRowId'="")
		{
			s aliaslength=$l(Ceobj.TIAAlias,"/")
			for i=1:1:aliaslength
			{
				s tiaeobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
				s tiaeobj.TIATARIDR=TARIRowId
				s tiaeobj.TIAAlias=$p(Ceobj.TIAAlias,"/",i)	
				d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveEntity(tiaeobj)
			}
		}
		else
		{
			s ImportResult="收费项目价格:"_TPSaveResult				
		}
	}
	else
	{
		s ImportResult="收费项目:"_TARISaveResult			
	}		
	
	
	
	if (ImportResult="")
	{
		Tcommit
		s ImportResult="{success:'true',id:'"_TARIRowId_"'}" 
	}
	else
	{
		Trollback
	
	}
	
	q ImportResult
}

}
