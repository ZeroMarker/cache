Class EMRservice.BL.BLNetConnect Extends %RegisteredObject
{

/// w ##Class(EMRservice.BL.BLNetConnect).GetNetConnect()
ClassMethod GetNetConnect() As %String
{
	s hostname=$zu(54,0)
	s Address=$P($zu(54,13,hostname),",",1)
	q "{'server':'"_Address_"',"_##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("NET_CONNECT")_"}"
}

}
