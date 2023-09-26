/// 串口采集数据时获取数据
Class web.DHCPE.EquipmentData Extends (%SerialObject, %XML.Adaptor)
{

//根据计算机名称、细项ID获取数据

ClassMethod GetData(ComputerName, ItemID)
{
	s value=""
	s:ComputerName'="" ComputerName=$ZCVT(ComputerName,"U")
	;"^"_$P(ResultItems,"^",1)_":"_stature_";"
	i ComputerName="" d
	.i ItemID'="" d
	..s value=$G(^DHCPEEquipmentData(ItemID))
	.q:ItemID'=""
	.s DetailID=""
	.f  s DetailID=$O(^DHCPEEquipmentData(DetailID)) q:DetailID=""  d
	..s OneValue=$G(^DHCPEEquipmentData(DetailID))
	..s value=value_"^"_DetailID_":"_OneValue_";"
	e  d
	.i ItemID'="" d
	..s value=$G(^DHCPEEquipmentData(ComputerName,ItemID))
	.q:ItemID'=""
	.s DetailID=""
	.f  s DetailID=$O(^DHCPEEquipmentData(ComputerName,DetailID)) q:DetailID=""  d
	..s OneValue=$G(^DHCPEEquipmentData(ComputerName,DetailID))
	..s value=value_"^"_DetailID_":"_OneValue_";"
	q value
	/*
	
	q:ItemID="" value
	i ComputerName="" d
	.s value=$G(^DHCPEEquipmentData(ItemID))
	.;k ^DHCPEEquipmentData(ItemID)
	e  d
	.s value=$G(^DHCPEEquipmentData(ComputerName,ItemID))
	.;k ^DHCPEEquipmentData(ComputerName,ItemID)
	q value
	*/
}

ClassMethod SaveData(ComputerName, Data)
{
	s value="",Node2=""
	s:ComputerName'="" ComputerName=$ZCVT(ComputerName,"U")
	s Split="Height:"
	i Data[(Split) d  ;每个设备输出数据格式不同
	.s Node2=""  ;对应的细项ID
	.s value=$P(Data,Split,2)
	.s value=$P(value,"<CR>",1)
	
	s Split="Weight:"
	i Data[(Split) d  ;每个设备输出数据格式不同
	.s Node2=""  ;对应的细项ID
	.s value=$P(Data,Split,2)
	.s value=$P(value,"<CR>",1)
	
	
	i Node2'="" d
	.s:ComputerName'="" ^DHCPEEquipmentData(ComputerName,Node2)=value
	.s:ComputerName="" ^DHCPEEquipmentData(Node2)=value
	
	q "OK"
}

Storage Default
{
<StreamLocation>^web.DHCPE.EquipmentDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
