Class EMRservice.entity.EViewEMRDoc Extends (%RegisteredObject, %XML.Adaptor)
{

//EMR中文本ID

Property InstanceDataID As %String(TRUNCATE = 1);

//EMR中文本ID

Property DocID As %String(TRUNCATE = 1);

//EMR中文本名称

Property DocName As %String(TRUNCATE = 1);

//与此文档关联的上级文档节点名称

Property FatherDocName As %String(TRUNCATE = 1);

//模板ID

Property TemplateID As %String(TRUNCATE = 1);

//模板版本ID

Property TemplateVersionID As %String(TRUNCATE = 1);

//就诊号

Property VisitNumber As %String(TRUNCATE = 1);

//患者ID

Property PatientID As %String(TRUNCATE = 1);

//患者住院号

Property MRN As %String(TRUNCATE = 1);

//患者姓名

Property PatientName As %String(TRUNCATE = 1);

//文本中包含的数据项集合，把所有数据项封装成一个XML数据项；数据项中包含的属性有名称， ID, 和值，如注释例；

//<root><Item ItemID=“” ItemName=“” ItemValue=“”></Item><Item>###</Item><Item>###</Item></root>

Property ItemValueSet As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

//模板最后更新日期时间

Property LastUpdateDateTime As %String;

}
