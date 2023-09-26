Class web.DHCENS.STBLL.EMPI.METHOD.PatTransAdm Extends (%RegisteredObject, %XML.Adaptor)
{

/// 服务编码	T0014
/// 服务名称	转科信息
/// 服务所在类	web.DHCENS.STBLL.EMPI.METHOD.PatTransAdm
/// 方法名称	TransDept
/// 方法入参  就诊号^转入时间^转入科室代码^转入医生代码^转入病区代码^转入房间代码^转入床位代码^转出时间^转出科室代码^转出医生代码^转出病区代码^转出房间代码^转出床位代码^标示（01转科、02转床、03首次分床、04换医生）^主管医生代码^管床护士代码                                                  
/// 		  1      2        3            4            5            6            7            8        9            10           11           12           13           14                                 15       16
/// test: w ##class(web.DHCENS.STBLL.EMPI.METHOD.PatTransAdm).TransDept("15^2016-06-22 20:56:00^100101B^005611^100102H^产科05^0004床^2016-06-22 20:56:00^100102M^006270^100502H^产科09^0013床")
ClassMethod TransDept(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PatTransAdm).%New()
	
	if Input=""{
		d body.CreateCards.Insert(Obj)
		set request.body=body
		do request.XMLExportToStream(.stream)
		quit stream
	}
	
	set Obj.PAADMVisitNumber=$p(Input,"^",1)
	set patId=$p(^PAADM(Obj.PAADMVisitNumber),"^",1)
	set Obj.PATPatientID=$p($g(^PAPER(patId,"PAT",1)),"^",1)	
	set Obj.PAADMTStartDate=$p($p(Input,"^",8)," ",1) 
	set Obj.PAADMTStartTime=$p($p(Input,"^",8)," ",2) 

	set Obj.PAADMTOrigDocCode=$p(Input,"^",10)
	set Obj.PAADMTOrigDeptCode=$p(Input,"^",9)
	set Obj.PAADMTOrigWardCode=$p(Input,"^",11)
	if Obj.PAADMTOrigWardCode'="" {
		s OrigRowid=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(Obj.PAADMTOrigWardCode),""))
		s:OrigRowid'="" Obj.PAADMTOrigWardDesc=$p(^PAWARD(OrigRowid),"^",2)	
	}
	
	set Obj.PAADMTOrigRoomCode=$p(Input,"^",12)  
	set Obj.PAADMTOrigBedCode=$p(Input,"^",13)
	set Obj.PAADMTEndDate=$p($p(Input,"^",2)," ",1) 
	set Obj.PAADMTEndTime=$p($p(Input,"^",2)," ",2) 
	set Obj.PAADMTTargDocCode=$p(Input,"^",4)
	
	set Obj.PAADMTTargDeptCode=$p(Input,"^",3)
	set Obj.PAADMTTargWardCode=$p(Input,"^",5)
	if Obj.PAADMTTargWardCode'="" {
		s TargRowid=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(Obj.PAADMTTargWardCode),""))
		s:TargRowid'="" Obj.PAADMTTargWardDesc=$p(^PAWARD(TargRowid),"^",2)	
	}
	set Obj.PAADMTTargRoomCode=$p(Input,"^",6)
	set Obj.PAADMTTargBedCode=$p(Input,"^",7)
	set Obj.PAADMTState=$p(Input,"^",14)    //01转科、02转床、03首次分床、04换医生
	set Obj.UpdateUserCode="demo"
	set Obj.UpdateDate=$ZD(+$H,3)
	set Obj.UpdateTime=$ZT($P($H,",",2))
	set Obj.PAADMDocCode=$p(Input,"^",15)
	set Obj.PAADMNurseCode=$p(Input,"^",16)
	set body.PatTransAdms=Obj
	set request.body=body
	
	d request.XMLExportToStream(.stream)
	
	Quit stream
	
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
