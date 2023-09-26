Class DHCEPRFS.BL.HISInfo.BLPHAInfo Extends %RegisteredObject
{

/// Desc: 判断是否需要打印处方单
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPHAInfo).CheckHasPHAToPrint()
ClassMethod CheckHasPHAToPrint(AEpisodeID As %String) As %String
{
	q ##class(PHA.FACE.OUT.Com).IsExistAdmPresc(AEpisodeID)
}

}
