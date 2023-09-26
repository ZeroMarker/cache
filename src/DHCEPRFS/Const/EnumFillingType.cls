Class DHCEPRFS.Const.EnumFillingType Extends %RegisteredObject
{

/// 病历正常归档
Parameter Archive = "A";

/// 病历封存
Parameter SealUp = "S";

/// 病历中途打印
Parameter MidwayPrint = "M";

ClassMethod Archive()
{
	quit ..#Archive
}

ClassMethod SealUp()
{
	quit ..#SealUp
}

ClassMethod MidwayPrint()
{
	quit ..#MidwayPrint
}

}
