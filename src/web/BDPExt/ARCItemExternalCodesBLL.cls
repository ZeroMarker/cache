Class web.BDPExt.ARCItemExternalCodesBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 检验外部代码
/// chenying
ClassMethod SaveEntity(Ceobj As web.BDPExt.ARCItemExternalCodesEntity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""	
	///默认值
	s eobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCItemExternalCodes")
	///医嘱项
	s eobj.EXTParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.LinkHospId)
	s SaveResult=##class(web.DHCBL.CT.ARCItemExternalCodes).SaveEntity(eobj)  
	q SaveResult
}

/// Creator:陈莹
/// CreatDate:20170330
/// Description:清除医嘱项 外部代码关联
/// d ##class(web.BDPExt.ARCItemExternalCodesBLL).ClearData()
ClassMethod ClearData() As %String
{
	n
	s sub=0
	for 
	{
		s sub=$o(^ARCIM(sub)) q:sub=""
		
		s vesion=0
		for 
		{
			s vesion=$o(^ARCIM(sub,vesion)) q:vesion=""
			s extsub=0
			for
			{
				s extsub=$o(^ARCIM(sub,vesion,"EXT",extsub)) q:extsub=""
				s RowId=sub_"||"_vesion_"||"_extsub
				d ##class(User.ARCItemExternalCodes).%DeleteId(RowId)
			}
			k ^ARCIM(sub,vesion,"EXT",0)
		}
		
	}
	q 1
}

}
