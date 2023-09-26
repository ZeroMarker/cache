Class web.DHCENS.STBLL.EMPI.METHOD.PAAllergy Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—10-09
/// Description：获取过敏记录信息
/// Table：
/// Input：过敏记录rowid
/// Return：过敏记录信息集合
/// Others: 
/// w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAllergy).PAAllergyInfo("22||1")
ClassMethod PAAllergyInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set allergyInfo=$g(^PAPER(+Input,"ALG",$p(Input,"||",2)))
	Quit:allergyInfo="" request
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAllergy).%New()
	set AllTypeDR=$p(allergyInfo,"^",29)
	if AllTypeDR'="" {
		set AllTypeInfo=^MRC("AT",AllTypeDR)
		set Obj.PAALLCategoryCode=$p(AllTypeInfo,"^",1)
	}
	set patRowId=+Input
	set Obj.PAALLAllergyID=Input
	set Obj.PAALLPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)	
	set Obj.PAALLReactionDesc=$p(allergyInfo,"^",6)
	set Obj.PAALLSeverityCode=""
	set PHCGEDR=$p(allergyInfo,"^",4)
	set sourceDesc=""
	if PHCGEDR'="" {
		set sourceDesc=$p($g(^PHCGE("GE",PHCGEDR)),"^",2)
	}
	set TypeDR=$p(allergyInfo,"^",9)
	if TypeDR'="" {
		set sourceDesc=$p($g(^PAC("ALG",TypeDR)),"^",2)
	}
	set PHCDMDR=$p(allergyInfo,"^",27)
	if PHCDMDR'="" {
		set sourceDesc=$p($g(^PHCD(PHCDMDR,1)),"^",2)
	}
	set Obj.PAALLSourceDesc=sourceDesc
	set updateDate=$p(allergyInfo,"^",23)
	set:updateDate'="" Obj.PAALLUpdateDate=$zd(updateDate,3)
	set updateTime=$p(allergyInfo,"^",24)
	set:updateTime'="" Obj.PAALLUpdateTime=$zt(updateDate,1)
	set Obj.PAALLUpdateUserCode=$p($g(^SSU("SSUSR",$p(allergyInfo,"^",16))),"^",1)
	set Obj.PAALLVisitNumber=""
	set Obj.PAALLStatus=""
	set Obj.PAALLDate=""
	set body.PAAllergys=Obj
	set request.body=body
	
	d request.XMLExportToStream(.stream)
	q stream
	
	
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
