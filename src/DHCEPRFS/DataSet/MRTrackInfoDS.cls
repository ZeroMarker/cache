/// Desc:按照示踪明细
/// Creator:yangpeng
/// CreateDate:2015-10-10
Class DHCEPRFS.DataSet.MRTrackInfoDS Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCEPRFS.BL.BLMRLog";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/MRTrackInfoDS";

Parameter QUERYNAME = "GetMRTrackInfoByEpisode";

}
