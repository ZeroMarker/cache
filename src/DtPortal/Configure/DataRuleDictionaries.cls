Class DtPortal.Configure.DataRuleDictionaries Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DataRuleDictionaries, StorageStrategy = DictSto ]
{

Relationship ParRef As DtPortal.Configure.DataRule [ Cardinality = parent, Inverse = ChildItem ];

/// 字典值
Property DataDictValue As %String(TRUNCATE = 1);

/// 字典描述
Property DataDictDesc As %String(TRUNCATE = 1);

// code索引

Index DataDictValueIndex On DataDictValue;

// desc索引

Index DataDictDescIndex On DataDictDesc;

/// Creator：     chengpeng
/// CreatDate：   2018-11-05
/// Description:  更新数据配置字典配置
/// Table：       DtPortal_Configure.DataRuleDictionaries
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.DataRuleDictionaries).Update("33^1^1^iMedical 8.0.01","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	set $zt="Update"
	Set return=-1
	Set:aSeparate="" aSeparate="^"
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	Set value=$p(aInput,aSeparate,3)
	Set desc=$p(aInput,aSeparate,4)
	
	set ID=ParRef_"||"_ChildSub
	
	
	
	If (ChildSub="") {
		set rowID=$o(^DtPortal.Configure.DataRuleI("Item","DataDictValueIndex"," "_value,ParRef,""))
		quit:rowID'="" 0
		set rowID=$o(^DtPortal.Configure.DataRuleI("Item","DataDictDescIndex"," "_desc,ParRef,""))
		quit:rowID'="" 0
		Set obj=##class(DtPortal.Configure.DataRuleDictionaries).%New()
	} Else {
		set isHava=0
		set rowID=""
		for
		{
			set rowID=$o(^DtPortal.Configure.DataRuleI("Item","DataDictValueIndex"," "_value,ParRef,rowID))
			quit:rowID=""
			
			set:rowID'=ChildSub isHava=1
		}
		quit:isHava=1 0
		
		set rowID=""
		for
		{
			set rowID=$o(^DtPortal.Configure.DataRuleI("Item","DataDictDescIndex"," "_desc,ParRef,rowID))
			quit:rowID=""
			
			set:rowID'=ChildSub isHava=1
		}
		quit:isHava=1 0
		Set obj=##class(DtPortal.Configure.DataRuleDictionaries).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DtPortal.Configure.DataRule).GetObjById(ParRef)
	Set obj.DataDictValue  	 = value
	Set obj.DataDictDesc     = desc
		
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=1
	}
	Do obj.%Close()
	
	Quit return
Update
	q $zt
}

/// Creator：     chengpeng
/// CreatDate：   2018-11-05
/// Description:  查询数据配置字典配置
/// Table：       DtPortal_Configure.DataRuleDictionaries
/// Input：       roleID :DtPortal.Configure.DataRule表ID
/// w ##Class(DtPortal.Configure.DataRuleDictionaries).qureyData(,,)
ClassMethod qureyData(page = 1, rows = 10, ID As %String = "") As %String
{
	 set $zt="qureyData"
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 w "{""rows"":["
	 if ID=""
	 {
		 
		 w "],""total"":"_count_"}"
		 q ""
	 }
	 set subID=""
	 for
	 {
		 set subID=$o(^DtPortal.Configure.DataRuleD(ID,"Item",subID))
		 quit:subID=""
		 
		 Set subObj=##class(DtPortal.Configure.DataRuleDictionaries).%OpenId(ID_"||"_subID)
		 continue:'$IsObject(subObj)
		 
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 set value=subObj.DataDictValue
		 set desc=subObj.DataDictDesc
	
		 w $case(count,start:"",:",")
		 w "{"
		 w """RowID"":"_""""_ID_"||"_subID_""""_","
		 w """ID"":"_""""_ID_""""_","
		 w """subID"":"_""""_subID_""""_","
		 w """value"":"_""""_value_""""_","
		 w """desc"":"_""""_desc_""""
		 w "}" 
		 
	 }
	 w "],""total"":"_count_"}"
	 q ""
qureyData
	q ""
}

/// Creator：     chengpeng
/// CreatDate：   2018-11-05
/// Description:  删除数据配置字典配置
/// Table：       DtPortal_Configure.DataRuleDictionaries
/// Input：       DtPortal.Configure.DataRuleDictionaries
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.DataRuleDictionaries).DeleteById("5||1")
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.DataRuleDictionaries).%DeleteId(ID)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2018-11-05
/// Description:  保存选项值和描述
/// Table：       DtPortal_Configure.DataRuleDictionaries
/// Input：       DtPortal.Configure.DataRuleDictionaries
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.DataRuleDictionaries).saveOption()
ClassMethod saveOption(ID, optionValueStr, optionValueDescStr) As %String
{
	New (ID,optionValueStr,optionValueDescStr)
	q:((ID="")||(optionValueStr="")||(optionValueDescStr="")) 0
	set $zt="saveOption"
	set return=1
	set subID=""
	for
	{
		set subID=$o(^DtPortal.Configure.DataRuleD(ID,"Item",subID))
		quit:subID=""
		 
		set retD= ##Class(DtPortal.Configure.DataRuleDictionaries).DeleteById(ID_"||"_subID)
	}
	for index=1:1:$l(optionValueStr,"#*")
	{
		set optionValue=$p(optionValueStr,"#*",index)
		set optionValueDesc=$p(optionValueDescStr,"#*",index)
		set data=ID_"@#"_"@#"_optionValue_"@#"_optionValueDesc
		set ret=##Class(DtPortal.Configure.DataRuleDictionaries).Update(data,"@#")
		if ret<1 set return=-1
	}
	Quit return
saveOption
	q $zt
}

/// Creator：     chengpeng
/// CreatDate：   2020-11-30
/// Description:  获取数据规则配置中的数据
/// Table：       DtPortal_Configure.DataRule
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.DataRuleDictionaries).getDataRuleByCode("HISEDITION")
ClassMethod getDataRuleByCode(code) As %String
{
	New (code)
	Set return=""
	set code=$$ALPHAUP^SSUTIL4(code)
	set ID=""
	for
	{
		set ID=$o(^DtPortal.Configure.DataRuleI("DataRuleCodeIndex"," "_code,ID))
		quit:ID=""
		
		w "["
		set index=1
		set subID=""
		for
		{
			set subID=$o(^DtPortal.Configure.DataRuleD(ID,"Item",subID))
			quit:subID=""
			
			Set subObj=##class(DtPortal.Configure.DataRuleDictionaries).%OpenId(ID_"||"_subID)
			continue:'$IsObject(subObj)
			 set DataDictValue=subObj.DataDictValue
			 set DataDictDesc=subObj.DataDictDesc
			 w:index=1 "{"
			 w:index'=1 ",{"
			 w """value"":"_""""_DataDictValue_""""_","
			 w """desc"":"_""""_DataDictDesc_""""
			 w "}" 
			 set index=2
		}
		w "]"
	}
	
	Quit return
}

Storage DictSto
{
<Data name="DataRuleDictionariesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataDictValue</Value>
</Value>
<Value name="3">
<Value>DataDictCode</Value>
</Value>
<Value name="4">
<Value>DataDictDesc</Value>
</Value>
<Value name="5">
<Value>DataDictChildSub</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Item")</DataLocation>
<DefaultData>DataRuleDictionariesDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Item")</IdLocation>
<IndexLocation>^DtPortal.Configure.DataRuleI("Item")</IndexLocation>
<StreamLocation>^DtPortal.CDRDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
