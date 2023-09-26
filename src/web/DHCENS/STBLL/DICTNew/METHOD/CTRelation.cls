Class web.DHCENS.STBLL.DICTNew.METHOD.CTRelation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：患者关系类型字典信息
/// Table：CT_Relation
/// Input： 
/// Return：患者关系类型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRelation).GetCTRelation("")
ClassMethod GetCTRelation(Input As %String) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTRelationByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：患者关系类型字典信息
/// Table：CT_Relation
/// Input： 
/// Return：患者关系类型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRelation).SendCTRelation("")
ClassMethod SendCTRelation(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("RLT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>20 d
	..set Instream=..GetCTRelationByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Relation",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTRelationByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Relation",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTRelationByID(plist)
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：患者关系类型字典信息
/// Table：CT_Relation
/// Input： 
/// Return：患者关系类型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRelation).GetCTRelationByID("")
ClassMethod GetCTRelationByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTRelation).%New()
		set Str=$g(^CT("RLT",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTRCode=$p(Str,"^",1)
		set Obj.CTRDesc=$p(Str,"^",2)
		set Obj.CTRCodesystemCode="CT_Relation"
		set Obj.CTRRemarks=""
		set Obj.CTRStatus="1"
		set Obj.CTRStartDate=$p(Str,"^",3)
		set Obj.CTREndDate=$p(Str,"^",4)
		set Obj.CTRUpdateUserCode="无"
		d ListInfo.CTRelation.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTRelation",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Relation",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
