Class EMRservice.entity.EKBDataMap Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

Property OldID As %String(MAXLEN = 100, TRUNCATE = 1);

Property OldName As %String(MAXLEN = 200, TRUNCATE = 1);

Property NewID As %String(MAXLEN = 100, TRUNCATE = 1);

Property NewName As %String(MAXLEN = 200, TRUNCATE = 1);

//目录：KBCATEGORY,知识库节点：KBBASE,知识库树：KBTREE,知识库Node:KBNODE

Property MapType As %String(MAXLEN = 200, TRUNCATE = 1);

}
