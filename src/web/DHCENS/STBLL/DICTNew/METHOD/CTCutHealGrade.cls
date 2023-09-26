Class web.DHCENS.STBLL.DICTNew.METHOD.CTCutHealGrade Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：切口愈合等级字典信息
/// Table：ORC_BladeType
/// Input： 
/// Return：切口愈合等级字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutHealGrade).GetCTCutHealGrade("1")
ClassMethod GetCTCutHealGrade(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTCutHealGradeByID(pList)
	}
	w OutputStream.Read()
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：切口愈合等级字典信息
/// Table：ORC_BladeType
/// Input： 
/// Return：切口愈合等级信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutHealGrade).SendCTCutHealGrade("")
ClassMethod SendCTCutHealGrade(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^ORC("BLDTP",rowid)) Quit:rowid=""  d
	.;w rowid
	.do plist.SetAt(rowid,count)
	.set count=count+1
	if plist.Count()>0{
		set Instream=..GetCTCutHealGradeByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CutHealGrade",tSC)
		do tSC.OutputToDevice()
		Quit tSC.Read()
	}
	q 1
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：切口愈合等级字典信息
/// Table：ORC_BladeType
/// Input： 
/// Return：切口愈合等级信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutHealGrade).GetCTCutHealGradeByID("")
ClassMethod GetCTCutHealGradeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set cutHealGradeInfo=$g(^ORC("BLDTP",rowid))
		set cutHealGradeObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCutHealGrade).%New()
		set cutHealGradeObj.businessrowid=rowid
		set cutHealGradeObj.CTCHGCode=$p(cutHealGradeInfo,"^",1)
		set cutHealGradeObj.CTCHGDesc=$p(cutHealGradeInfo,"^",2)
		set cutHealGradeObj.CTCHGCodesystemCode="CT_CutHealGrade"
		set cutHealGradeObj.CTCHGRemarks="无"
		set cutHealGradeObj.CTCHGStatus="1"
		set cutHealGradeObj.CTCHGStartDate=$p(cutHealGradeInfo,"^",3)
		set cutHealGradeObj.CTCHGEndDate=""
		set cutHealGradeObj.CTCHGUpdateUserCode="无"
		d ListInfo.CTCutHealGrade.Insert(cutHealGradeObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCutHealGrade",.Jsonobj)
	
	//set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;w JsonString,!
	//;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	//set JsonString=$tr(JsonString,$c(13),"")
	//set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CutHealGrade",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
