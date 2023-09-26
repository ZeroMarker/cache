/// 常用词组、短语、关键字、特殊符号维护
/// 创建者：zhufei
/// 创建时间：2014-02-18
Class DHCMed.DP.Base.ActWards Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类（DHCMed.SS.Dictionary 定义 "DPDicWordCategory"）
Property APCategory As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = AP_Category ];

/// 词组、短语、关键字、特殊符号
Property APWords As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AP_Words ];

/// 属性（过滤、包含）（DHCMed.SS.Dictionary 定义 "DPDicWordProperty"）
Property APActType As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = AP_ActType ];

/// 标注1
Property APText1 As %String [ SqlColumnNumber = 5, SqlFieldName = AP_Text1 ];

/// 标注2
Property APText2 As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AP_Text2 ];

/// 标注3
Property APText3 As %String [ SqlColumnNumber = 7, SqlFieldName = AP_Text3 ];

/// 标注4
Property APText4 As %String [ SqlColumnNumber = 8, SqlFieldName = AP_Text4 ];

/// 是否有效
Property APIsActive As %Boolean [ SqlColumnNumber = 9, SqlFieldName = AP_IsActive ];

/// 备注
Property APResume As %String [ SqlColumnNumber = 10, SqlFieldName = AP_Resume ];

/// 词组、短语、关键字、特殊符号索引
Index IndexCategTypeWards On (APCategory As Exact, APActType As Exact, APIsActive As Exact, APWords As Exact);

/// 词组、短语、关键字、特殊符号索引
Index IndexCategory On APCategory As Exact;

/// Creator：     zhufei
/// CreatDate：   2014-02-18
/// Description:  获取词组、短语数据对象
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       DHCMed.DP.Base.ActWards.ID
/// Return：      Object
/// w ##class(DHCMed.DP.Base.ActWards).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Base.ActWards
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Base.ActWards).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Base.ActWards).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-02-18
/// Description:  更新词组、短语数据
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Base.ActWards).Update("^LIS-PY^木糖氧化亚种^PRO-0^^^^^1^","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Base.ActWards).%New()
	} else {
		set obj=##class(DHCMed.DP.Base.ActWards).%OpenId(ID)
	}
	
	set obj.APCategory=$p(InStr,separete,2)
	set obj.APWords=$p(InStr,separete,3)
	set obj.APActType=$p(InStr,separete,4)
	set obj.APText1=$p(InStr,separete,5)
	set obj.APText2=$p(InStr,separete,6)
	set obj.APText3=$p(InStr,separete,7)
	set obj.APText4=$p(InStr,separete,8)
	set obj.APIsActive=+$p(InStr,separete,9)
	set obj.APResume=$p(InStr,separete,10)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     zhufei
/// CreatDate：   2014-02-18
/// Description:  删除词组、短语数据
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       DHCMed.DP.Base.ActWards.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Base.ActWards).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-02-27
/// Description:  检查值是否包含相关词组、短语
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       DHCMed.DP.Base.ActWards.ID
/// Return：      return="":不包含  return'="":返回词组列表
/// w ##Class(DHCMed.DP.Base.ActWards).Check1("EMR-PN","见异常分泌物AAA")
ClassMethod Check1(aCategory As %String, aDataValue As %String) As %List
{
	New (aCategory,aDataValue)
	Set return=""
	Quit:(aCategory="")||(aDataValue="") return
	
	Set $ZT="Check1Err"
	
	Set xWord=""
	For {
		Set xWord=$o(^DHCMed.DP.Base.ActWardsI("IndexCategTypeWards",aCategory,"PRO-0","1",xWord),-1)
		Quit:xWord=""
		
		Set tmpValue=""
		For indWord=1:1:$l(aDataValue,xWord) {
			Set tmpValue=tmpValue_$p(aDataValue,xWord,indWord)
		}
		Set aDataValue=tmpValue
	}
	
	Set xWord=""
	For {
		Set xWord=$o(^DHCMed.DP.Base.ActWardsI("IndexCategTypeWards",aCategory,"PRO-1","1",xWord))
		Quit:xWord=""
		
		Set ID=$o(^DHCMed.DP.Base.ActWardsI("IndexCategTypeWards",aCategory,"PRO-1","1",xWord,0))
		Set obj=..GetObjById(ID)
		Continue:'$IsObject(obj)
		Set Words=obj.APWords
		Set Text1=obj.APText1
		Set Text2=obj.APText2
		Set Text3=obj.APText3
		Set Text4=obj.APText4
		
		Set tmpWord=""
		If aDataValue[Words {
			Set tmpWord=Words
			If Text1'="" {
				If aDataValue[Text1 {
					Set tmpWord=tmpWord_" "_Text1
				} Else {
					Set tmpWord=""
				}
			}
			Continue:tmpWord=""
			If Text2'="" {
				If aDataValue[Text2 {
					Set tmpWord=tmpWord_" "_Text2
				} Else {
					Set tmpWord=""
				}
			}
			Continue:tmpWord=""
			If Text3'="" {
				If aDataValue[Text3 {
					Set tmpWord=tmpWord_" "_Text3
				} Else {
					Set tmpWord=""
				}
			}
			Continue:tmpWord=""
			If Text4'="" {
				If aDataValue[Text4 {
					Set tmpWord=tmpWord_" "_Text4
				} Else {
					Set tmpWord=""
				}
			}
			Continue:tmpWord=""
			Set return=return_$lb(tmpWord)
		}
	}
	
	Quit return
	
Check1Err
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2014-02-27
/// Description:  检查值是否过滤相关词组、短语
/// Table：       DHCMed.DP.Base.ActWards
/// Input：       DHCMed.DP.Base.ActWards.ID
/// Return：      return="":不包含  return'="":返回词组列表
/// w ##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY","普通培养无细菌生长")
ClassMethod Check0(aCategory As %String, aDataValue As %String) As %List
{
	New (aCategory,aDataValue)
	Set return=""
	Quit:(aCategory="")||(aDataValue="") return
	
	Set $ZT="Check0Err"
	
	Set xWord=""
	For {
		Set xWord=$o(^DHCMed.DP.Base.ActWardsI("IndexCategTypeWards",aCategory,"PRO-1","1",xWord),-1)
		Quit:xWord=""
		
		Set tmpValue=""
		For indWord=1:1:$l(aDataValue,xWord) {
			Set tmpValue=tmpValue_$p(aDataValue,xWord,indWord)
		}
		Set aDataValue=tmpValue
	}
	
	Set xWord=""
	For {
		Set xWord=$o(^DHCMed.DP.Base.ActWardsI("IndexCategTypeWards",aCategory,"PRO-0","1",xWord))
		Quit:xWord=""
		
		Set ID=$o(^DHCMed.DP.Base.ActWardsI("IndexCategTypeWards",aCategory,"PRO-0","1",xWord,0))
		Set obj=..GetObjById(ID)
		Continue:'$IsObject(obj)
		Set Words=obj.APWords
		Set Text1=obj.APText1
		Set Text2=obj.APText2
		Set Text3=obj.APText3
		Set Text4=obj.APText4
		
		Set tmpWord=""
		If aDataValue[Words {
			Set tmpWord=Words
			If Text1'="" {
				If aDataValue[Text1 {
					Set tmpWord=tmpWord_" "_Text1
				} Else {
					Set tmpWord=""
				}
			}
			Continue:tmpWord=""
			If Text2'="" {
				If aDataValue[Text2 {
					Set tmpWord=tmpWord_" "_Text2
				} Else {
					Set tmpWord=""
				}
			}
			Continue:tmpWord=""
			If Text3'="" {
				If aDataValue[Text3 {
					Set tmpWord=tmpWord_" "_Text3
				} Else {
					Set tmpWord=""
				}
			}
			Continue:tmpWord=""
			If Text4'="" {
				If aDataValue[Text4 {
					Set tmpWord=tmpWord_" "_Text4
				} Else {
					Set tmpWord=""
				}
			}
			Continue:tmpWord=""
			Set return=return_$lb(tmpWord)
		}
	}
	
	Quit return
	
Check0Err
	Quit ""
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>APCategory</Value>
</Value>
<Value name="3">
<Value>APWords</Value>
</Value>
<Value name="4">
<Value>APActType</Value>
</Value>
<Value name="5">
<Value>APText1</Value>
</Value>
<Value name="6">
<Value>APText2</Value>
</Value>
<Value name="7">
<Value>APText3</Value>
</Value>
<Value name="8">
<Value>APText4</Value>
</Value>
<Value name="9">
<Value>APIsActive</Value>
</Value>
<Value name="10">
<Value>APResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Base.ActWardsD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Base.ActWardsD</IdLocation>
<IndexLocation>^DHCMed.DP.Base.ActWardsI</IndexLocation>
<StreamLocation>^DHCMed.DP.Base.ActWardsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
