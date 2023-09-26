Class web.DHCEntity.PCA.GetPatAccListRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(MAXLEN = 256, TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property PapmiRowid As %String(TRUNCATE = 1);

Property PatName As %String(TRUNCATE = 1);

Property PatAge As %String(TRUNCATE = 1);

Property PatSex As %String(TRUNCATE = 1);

/// PatType	社会地位表指针
Property PatType As %String(TRUNCATE = 1);

Property AccMRowID As %String(TRUNCATE = 1);

Property AccMOCDate As %String(TRUNCATE = 1);

Property AccMOCTime As %String(TRUNCATE = 1);

Property AccMBalance As %String(TRUNCATE = 1);

Property AccMDepPrice As %String(TRUNCATE = 1);

Property AccMAccStatus As %String(TRUNCATE = 1);

Property AccList As list Of web.DHCEntity.PCA.AccListDetail;

}
