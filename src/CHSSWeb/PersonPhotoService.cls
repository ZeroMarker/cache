Class CHSSWeb.PersonPhotoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2010-03-22
/// Description:检索个人照片列表
/// Table：PersonPhoto
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod List(PersonRowId As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set PersonRowId=$G(PersonRowId)
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set PhotoRowId = 0
      Set tmp = ""
      
      For  Set PhotoRowId=$O(^CHSS.PersonPhotoI("PersonRowIdIndex",PersonRowId,PhotoRowId)) q:PhotoRowId=""  d
      .
      
      .s tempPersonPhtot=##class(CHSS.PersonPhoto).%OpenId(PhotoRowId)
      .
      ./// 照片信息
      .s ElerlyGrade = tempElerlyBaseInfo.ElerlyGrade
      .s LifeSupport = tempElerlyBaseInfo.LifeSupport
      .set Nursing = tempElerlyBaseInfo.Nursing
      
      .set EyesightName = ""
      .set Eyesight = ""
      .i tempElerlyBaseInfo.Eyesight '= "" d
      ..s Eyesight = tempElerlyBaseInfo.Eyesight.%Id()
      ..s EyesightName = tempElerlyBaseInfo.Eyesight.Description

      .set ToothDeformityName = ""
      .set ToothDeformity = ""
      .i tempElerlyBaseInfo.ToothDeformity '= "" d
      ..s ToothDeformity = tempElerlyBaseInfo.ToothDeformity.%Id()
      ..s ToothDeformityName = tempElerlyBaseInfo.ToothDeformity.Description

      .s Informant = tempElerlyBaseInfo.Informant
      .s Inquirer = tempElerlyBaseInfo.Inquirer
      .s Recorder = tempElerlyBaseInfo.Recorder

      .set DateOfSign = tempElerlyBaseInfo.DateOfSign
      .i DateOfSign '= "" d
      ..s DateOfSign = $zd(DateOfSign,3)

      .set DateOfInquire = tempElerlyBaseInfo.DateOfInquire
      .i DateOfInquire '= "" d
      ..s DateOfInquire = $zd(DateOfInquire,3)

      .set DateOfRecord = tempElerlyBaseInfo.DateOfRecord
      .i DateOfRecord '= "" d
      ..s DateOfRecord = $zd(DateOfRecord,3)

      
      
      .Set tmp = ElerlyRowId_"^"_ElerlyGrade_"^"_LifeSupport_"^"_Nursing_"^"_Eyesight_"^"_EyesightName_"^"_ToothDeformity_"^"_ToothDeformityName_"^"_Informant_"^"_Inquirer_"^"_Recorder_"^"_DateOfSign_"^"_DateOfInquire_"^"_DateOfRecord

      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("ElerlyRowId^ElerlyGrade^LifeSupport^Nursing^Eyesight^EyesightName^ToothDeformity^ToothDeformityName^Informant^Inquirer^Recorder^DateOfSign^DateOfInquire^DateOfRecord",count)
      k json
      
      Quit resultString
}

/// Creator: wangbo
/// CreatDate：2010-03-22
/// Description:返回个人当前照片路径
/// Table：PersonPhoto
/// Input: PersonRowId
/// Output：
/// Return：
/// Others：
ClassMethod GetPeronPhotoUrl(PersonRowId As %String) As %String
{
	;s PersonRowId = 26
    s PersonRowId=$G(PersonRowId)
    q:(PersonRowId = "") ""
	s PhotoRowId = ""
	s PhotoUrl = ""
    
	&SQL(select PhotoRowId into :PhotoRowId from CHSS.PersonPhoto where bCurrentPhoto = 'true' and PersonRowId = :PersonRowId )
	q:(PhotoRowId = "") ""
	
	;返回PersonPhoto主键
	q PhotoRowId
	
	;返回照片信息
	s PersonPhoto = ##Class(CHSS.PersonPhoto).%OpenId(PhotoRowId)
    s oid=PersonPhoto.Photo.%Oid()
    s PhotoUrl = oid
    q PhotoUrl
}

/// Creator: wangbo
/// CreatDate：2010-08-13
/// Description:返回个人当前照片
/// Table：PersonPhoto
/// Input: PersonRowId
/// Output：
/// Return：
/// Others：
ClassMethod GetPersonPhotoInfo(PersonRowId As %String) As %String
{
	;s PersonRowId = 26
    s PersonRowId=$G(PersonRowId)
    q:(PersonRowId = "") ""
	s PhotoRowId = ""
	S resultString = ""
    S json = ##class(Code.JsonObj).%New()
    s tmp = ""
	&SQL(select PhotoRowId into :PhotoRowId from CHSS.PersonPhoto where bCurrentPhoto = 'true' and PersonRowId = :PersonRowId )
	q:(PhotoRowId = "") ""
	s PersonPhoto = ##Class(CHSS.PersonPhoto).%OpenId(PhotoRowId)
    s oid=PersonPhoto.Photo.%Oid()
    ;#(..Encrypt(oid))#
    s tmp = PhotoRowId_"^"_oid
    d json.InsertRowData(tmp)
    s resultString = json.getJsonData("PhotoRowId^Photo",1)
    k json
    Quit resultString
}

Storage Default
{
<Data name="PersonPhotoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonPhotoServiceD</DataLocation>
<DefaultData>PersonPhotoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonPhotoServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PersonPhotoServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonPhotoServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
