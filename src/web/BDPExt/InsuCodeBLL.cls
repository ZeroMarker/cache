/// Description：收费项国家医保编码及名称导入程序
/// Creator：杨帆
/// CreatDate: 2021-08-10
Class web.BDPExt.InsuCodeBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 保存国家医保编码
ClassMethod SaveEntity(Ceobj As web.BDPExt.InsuCodeEntity) As %String
{
	n (Ceobj,%session)
	
	s TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Ceobj.TARICode,Ceobj.LinkHospId)
	q:TARIRowId="" "找不到收费项目"
	s TARIDesc =$p($g(^DHCTARI(TARIRowId)),"^",2)   //描述
	q:TARIDesc'=Ceobj.TARIDesc "收费项目不匹配"
	
	s obj=##class(User.DHCTarItem).%OpenId(TARIRowId)
	s obj.TARIInsuCode=Ceobj.TARIInsuCode
	s obj.TARIInsuName=Ceobj.TARIInsuName
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		s id = obj.%Id()
		q "{success:'true',id:'"_id_"'}"
	}
	else
	{
		q "保存失败^"_Ceobj.TARIDesc_" "_$SYSTEM.Status.GetErrorText(sc)
	}
	q ""
}

}
