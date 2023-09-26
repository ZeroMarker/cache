/// Desc:收藏夹目录逻辑类
Class EMRservice.BL.BLFavCatalog Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       添加目录
/// Creator:    Candy
/// CreateDate: 2014-11-19
/// Input:      AParentID 父目录
///             ACataLogName 病例名称
///             AFavUserID用户ID
/// Output:     result  0保存失败 否则返回RowID
/// Debug:      w ##Class(EMRservice.BL.BLFavCatalog).CreateFavCatalog("0","随诊",0,"Private")
ClassMethod CreateFavCatalog(AParentID As %String, ACataLogName As %String, AFavUserID As %String, AType As %String = "Private") As %String
{
	s result = "0"
	q:((ACataLogName = "")||(AParentID = "")||(AFavUserID = "")) result
	s rowId = $o(^DHCEMRF.FavCatalogI("IdxUserCataLogName"," "_AFavUserID," "_AParentID," "_$zcvt(ACataLogName,"U"),""))	
	if (rowId = "")
	{
		s objFavCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%New()
		q:(objFavCatalog = "") result
	}
	else
	{
		s objFavCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%OpenId(rowId)
		q:(objFavCatalog = "") result
	}
	s objFavCatalog.CataLogName = ACataLogName
	s objFavCatalog.ParentID = AParentID
	s objFavCatalog.FavUserID = AFavUserID
	s objFavCatalog.Type = AType	
	s sc = objFavCatalog.%Save()
	Tstart
	if ($$$ISOK(sc))
	{
		s objFavCatalog.Sequence = objFavCatalog.%Id()
		if ($$$ISOK(objFavCatalog.%Save()))
		{
		 	s result = objFavCatalog.%Id()
		 	TCOMMIT
		}
		else
		{
			Trollback
		}
	}
	q result
}

/// Desc:       删除目录节点
/// Creator:    Lina
/// CreateDate: 2016-03-16
/// Input:      AParentID 父目录
///             ACataLogName 病例名称
///             AFavUserID用户ID
/// Output:     result  0保存失败 否则返回RowID
/// Debug:      w ##Class(EMRservice.BL.BLFavCatalog).DelFavCatalog(17)
ClassMethod DelFavCatalog(rowID As %String) As %String
{
	s result = "0"
	q:(rowID = "") result
	s sc = ##Class(EMRinstance.Favorites.FavCatalog).%DeleteId(rowID)
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       修改目录名称及位置
/// Creator:    Candy
/// CreateDate: 2014-11-19
/// Input:      AID 目录ID
///             ACataLogName 病例名称
///             AParentID 父目录
/// Output:     result 1 保存成功 0保存失败
/// Debug:      w ##Class(EMRservice.BL.BLFavCatalog).UpdateFavCatalog(1,"冠心病")
ClassMethod UpdateFavCatalog(AID As %String, ACataLogName As %String)
{
	s result = "0"
	q:((AID = "")||(ACataLogName = "")) result
	s objFavCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%OpenId(AID)
	q:(objFavCatalog = "")
	s objFavCatalog.CataLogName = ACataLogName
	s sc = objFavCatalog.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       共享目录、子目录及目录下病历
/// Creator:    Candy
/// CreateDate: 2014-11-19
/// Input:      AID 目录ID
///             AType  Share/Private
/// Output:     result 0 失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLFavCatalog).ShareFavCatalog(1,1,"Share")
ClassMethod ShareFavCatalog(AFavUserID As %String, AID As %String, AType As %String) As %String
{
	s result = "0"
	q:(AID = "") result
	s objFavCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%OpenId(AID)
	q:(objFavCatalog = "") result
	s objFavCatalog.Type = AType
	Tstart
	s sc = objFavCatalog.%Save()
	if ($$$ISOK(sc)) 
	{
		s scInfo = ##Class(EMRservice.BL.BLFavInformation).ShareInfoByCatalogID(AFavUserID,AID,AType)
		if (scInfo '= "1")
		{
			Trollback
			q
		}
		s scChild = ..ShareCatalogByParentID(AFavUserID,AID,AType)
		if (scChild '= "1")
		{
			Trollback
			q
		}
		Tcommit
		s result = "1"
	}
	q result
}

/// Desc: 设置子目录下所有节点为共享文件
ClassMethod ShareCatalogByParentID(AFavUserID As %String, AParentID As %String, AType As %String) As %String
{
	s result = "0"
	q:((AFavUserID = "")||(AParentID = "")) result
	s seq = "",result = "1"
	Tstart
	for
	{
		s seq = $o(^DHCEMRF.FavCatalogI("IdxUserSequence",AFavUserID," "_AParentID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRF.FavCatalogI("IdxUserSequence",AFavUserID," "_AParentID,seq,rowId))
			q:(rowId = "")
			s objFavCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%OpenId(rowId)
			continue:(objFavCatalog = "")	
			s objFavCatalog.Type = AType
			s sc = objFavCatalog.%Save()
			if ($$$ISOK(sc))
			{
				s scInfo = ##Class(EMRservice.BL.BLFavInformation).ShareInfoByCatalogID(AFavUserID,rowId,AType)
				s:(scInfo = 0) result = "0"
			}
			else
			{
				s result = "0"
			}
			q:(result = "0")
			d ..ShareCatalogByParentID(AFavUserID,rowId,AType)
		}
		q:(result = "0")
	}
	if (result = "0")
	{
		Trollback
	}
	else
	{
		Tcommit
	}
	q result
}

/// Desc:      设置共享目录的上级目录为共享
/// Creaotr:   Candy
/// Createdate:2014-12-23
ClassMethod setParentShare(AID As %String)
{
	s result = "0"
	q:(AID = "") result
	s objFavCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%OpenId(AID)
	s objFavCatalog.Type = "Share"
	if (objFavCatalog.ParentID '= 0)
	{
		s tmpResult = ..setParentShare(objFavCatalog.ParentID)
		q:(tmpResult = "0") result
	}
	s sc = objFavCatalog.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       调序
/// Creator:    Candy
/// CreateDate: 2014-11-19
/// Input:      APreID 
///            ANextID
/// Output:     result
ClassMethod SwapSequence(APreID As %String, ANextID As %String) As %String
{
	s result = "0"
	q:((APreID = "")||(ANextID = "")) result
	s objPreFavCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%OpenId(APreID)
	q:(objPreFavCatalog = "")
	s objNextFavCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%OpenId(ANextID)
	q:(objNextFavCatalog = "")
	s tempSequence = objPreFavCatalog.Sequence
	s objPreFavCatalog.Sequence = objNextFavCatalog.Sequence
	s objNextFavCatalog.Sequence = tempSequence
	Tstart
	s scPre = objPreFavCatalog.%Save()
	if ($$$ISOK(scPre))
	{
		s scNext = objNextFavCatalog.%Save()
		if ($$$ISOK(scNext))
		{
			TCOMMIT
			s result = "1"
		}
		else
		{
			Trollback
		}
	}
	q result
}

/// Desc:       取目录
/// Ceator:     Candy
/// CreateDate: 2014-11-24
/// Input:      AFavUserID 收藏用户ID
///             AParentID  父节点
/// Output:     目录树结构
/// Debug:      w ##Class(EMRservice.BL.BLFavCatalog).GetFavCatalog(1,0,"Share")
ClassMethod GetFavCatalog(AFavUserID As %String, AParentID As %String, AType As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:((AFavUserID = "")||(AParentID = "")) json
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s userIds = "0^"_AFavUserID
	for i=1:1:$l(userIds,"^")
	{
		s userId = $p(userIds,"^",i)
		s seq = ""
		for
		{
			s seq = $o(^DHCEMRF.FavCatalogI("IdxUserSequence",userId," "_AParentID,seq))
			q:(seq = "")
			s rowId = $o(^DHCEMRF.FavCatalogI("IdxUserSequence",userId," "_AParentID,seq,""))
			continue:(rowId = "")
			s objCatalog = ##Class(EMRinstance.Favorites.FavCatalog).%OpenId(rowId)
			continue:(objCatalog = "")
			continue:((AType = "Share")&&(objCatalog.Type '= "Share"))
			s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.Favorites.FavCatalog","CataLogName",objCatalog.CataLogName,langid)
			d:(json.Size '= 0) json.Write(",")
			d json.Write("{")
			d json.Write("""id"":"""_rowId_"""")
			d json.Write(",""text"":"""_name_"""")
			d json.Write(",""attributes"":{")
			d json.Write("""Parent"":"""_AParentID_"""")
			d json.Write(",""favUserId"":"""_AFavUserID_"""")
			d json.Write(",""type"":""Catalog""")
			d json.Write("}")
			s tempJson = ..GetFavCatalog(AFavUserID,rowId,AType)
			if (tempJson.Size '= 0)
			{
				d json.Write(",""children"":[")
				d json.CopyFrom(tempJson)
				d json.Write("]")
			}
			d json.Write("}")
		}		
	}

	q json
}

/// Debug: d ##Class(EMRservice.BL.BLFavCatalog).InitCatalog()
ClassMethod InitCatalog()
{
	s names = "科研,教学,随诊,文章,VIP,其他"
	for i=1:1:$l(names,",")
	{
		s name = $p(names,",",i)
		d ..CreateFavCatalog(0,name,0,"Private")
	}
}

}
