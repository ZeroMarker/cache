Class EPRmeta.Parser.NMetaDataItem Extends %RegisteredObject [ ProcedureBlock ]
{

Property SessionSign As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Property Text As %String(TRUNCATE = 1);

Property Parent As NMetaDataItem;

Property SubItems As list Of NMetaDataItem;

}
