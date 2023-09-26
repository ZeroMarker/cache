Class EMRservice.entity.EAgreeDocIDList Extends (%RegisteredObject, %XML.Adaptor)
{

/// 目录id,或DocIDs(docid^docid)
Property DocID As %String;

/// 是否显示目录
Property ShowCategory As %String;

/// 父类ID
Property NodeData As list Of EMRservice.entity.EAgreeDocIDList;

}
