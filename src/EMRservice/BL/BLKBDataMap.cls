Class EMRservice.BL.BLKBDataMap Extends (%RegisteredObject, %XML.Adaptor)
{

Query SelectAllKBMAP() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,OldID:%String,OldName:%String,NewID:%String,NewName:%String,MapType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_KB_SelectAllKBMAP, SqlProc ]
{
	SELECT ID,OldID,OldName,NewID,NewName,MapType
	FROM EMRmeta.KBDataMap
}

Query SelectKBCategory() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,OldID:%String,OldName:%String,NewID:%String,NewName:%String,MapType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_KB_SelectKBCategory, SqlProc ]
{
	SELECT ID,OldID,OldName,NewID,NewName,MapType
	FROM EMRmeta.KBDataMap
	WHERE MapType = 'KBCATEGORY' OR MapType = 'KBBASE'
	ORDER BY MapType
}

Query SelectKBBase() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,OldID:%String,OldName:%String,NewID:%String,NewName:%String,MapType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_KB_SelectKBBase, SqlProc ]
{
	SELECT ID,OldID,OldName,NewID,NewName,MapType
	FROM EMRmeta.KBDataMap
	WHERE MapType = 'KBBASE'
}

Query SelectKBTreeNode() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,OldID:%String,OldName:%String,NewID:%String,NewName:%String,MapType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_KB_SelectKBTree, SqlProc ]
{
	SELECT ID,OldID,OldName,NewID,NewName,MapType
	FROM EMRmeta.KBDataMap
	WHERE MapType = 'KBTREE' OR MapType = 'KBNODE'
	ORDER BY MapType
}

Query SelectKBNode() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,OldID:%String,OldName:%String,NewID:%String,NewName:%String,MapType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_KB_SelectKBNode, SqlProc ]
{
	SELECT ID,OldID,OldName,NewID,NewName,MapType
	FROM EMRmeta.KBDataMap
	WHERE MapType = 'KBNODE'
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	//s IdexCode=0
	&sql(select max(id) into :IdexCode   from EMRmeta.KBDataMap)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个数据元范畴
ClassMethod CreateKBMap(aEKBDataMap As EMRservice.entity.EKBDataMap) As %String [ WebMethod ]
{
	s strRowID =""
	s strRowID = $o(^DHCEMRM.KBDataMapI("IdxOldID"," "_aEKBDataMap.OldID," "_aEKBDataMap.MapType,strRowID))
	if (strRowID ="")
	{
		set objKBDataMap=##class(EMRmeta.KBDataMap).%New()
		s strReslt = ""
		s objKBDataMap.OldID = $case(aEKBDataMap.OldID,$c(0):"",:aEKBDataMap.OldID)
		s objKBDataMap.OldName=$case(aEKBDataMap.OldName,$c(0):"",:aEKBDataMap.OldName)
		s objKBDataMap.NewID=$case(aEKBDataMap.NewID,$c(0):"",:aEKBDataMap.NewID)
		s objKBDataMap.NewName=$case(aEKBDataMap.NewName,$c(0):"",:aEKBDataMap.NewName)
		s objKBDataMap.MapType=$case(aEKBDataMap.MapType,$c(0):"",:aEKBDataMap.MapType)

		s sc = objKBDataMap.%Save()
		if ($$$ISOK(sc))
		{
			s strReslt = objKBDataMap.%Id()
		}
		else
		{
			s strReslt = "-1"	
		}
	
	}
	else
	{
		set objKBDataMap=##class(EMRmeta.KBDataMap).%OpenId(strRowID)
		s strReslt = ""
		s objKBDataMap.OldID = $case(aEKBDataMap.OldID,$c(0):"",:aEKBDataMap.OldID)
		s objKBDataMap.OldName=$case(aEKBDataMap.OldName,$c(0):"",:aEKBDataMap.OldName)
		s objKBDataMap.NewID=$case(aEKBDataMap.NewID,$c(0):"",:aEKBDataMap.NewID)
		s objKBDataMap.NewName=$case(aEKBDataMap.NewName,$c(0):"",:aEKBDataMap.NewName)
		s objKBDataMap.MapType=$case(aEKBDataMap.MapType,$c(0):"",:aEKBDataMap.MapType)

		s sc = objKBDataMap.%Save()
		if ($$$ISOK(sc))
		{
			s strReslt = objKBDataMap.%Id()
		}
		else
		{
			s strReslt = "-1"	
		}
	}
	q strReslt
}

/// 删除一个数据元范畴
ClassMethod DeleteKBDataMapByID(aEKBDataMapID As %String) As %String [ WebMethod ]
{

	q:(aEKBDataMapID ="") "-1"
	s objKBDataMap = ##Class(EMRmeta.KBDataMap).%OpenId(aEKBDataMapID)
	q:(objKBDataMap="") "-1"
	s sc = ##class(EMRmeta.KBDataMap).%DeleteId(aEKBDataMapID)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{

		q "-1"
	}
}

/// 删除一个数据元范畴
/// d ##Class(EMRservice.BL.BLKBDataMap).test()
ClassMethod test() As %String [ WebMethod ]
{
	s objKBDataMap = ##Class(EMRservice.entity.EKBDataMap).%New()
	s objKBDataMap.OldID = "10"
	s objKBDataMap.OldName="EMR10 住院病程记录"
	s objKBDataMap.NewID="10"
	s objKBDataMap.NewName="EMR10 住院病程记录"
	s objKBDataMap.MapType="KBCATEGORY"

	d ##Class(EMRservice.BL.BLKBDataMap).CreateKBMap(objKBDataMap)
}

}
