/// 名称: DHCHAI.DP.PhraseMap
/// 描述: 常用短语对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.PhraseMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 短语代码
Property BTCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 短语名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 短语分类
Property BTTypeDr As DHCHAI.DP.PhraseType [ Required ];

/// 标准名称
Property BTMapDicDr As DHCHAI.BT.Dictionary;

/// 子系统代码
Property BTSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码+短语分类+短语代码索引
Index IndexTypeCode On (BTSCode As Exact, BTTypeDr, BTCode As Exact);

/// 子系统代码+短语分类+短语名称索引
Index IndexTypeDesc On (BTSCode As Exact, BTTypeDr, BTDesc As Exact);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取常用短语对照
/// Table：       DHCHAI.DP.PhraseMap
/// Input：       ID:    DHCHAI.DP.PhraseMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.PhraseMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.PhraseMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.PhraseMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.PhraseMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码取常用短语对照
/// Table：       DHCHAI.DP.PhraseMap
/// Input：       aScode：子系统代码
/// 			      aTypeID:    分类
/// 			  aCode:    短语代码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.PhraseMap).GetObjByCode("","","")
ClassMethod GetObjByCode(aScode As %String, aTypeID As %String, aCode As %String) As DHCHAI.DP.PhraseMap
{
	New (aScode,aTypeID,aCode)
	Set return=""
	Quit:(aScode="")||(aTypeID="")||(aCode="") return
	
	Set id = $o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",aScode,aTypeID,aCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-28
/// Description:  根据子系统代码、短语分类代码、短语名称取标准结果分类信息
/// Table：       DHCHAI.DP.PhraseMap
/// Input：       aScode：子系统代码
/// 			  aTypeCode: 分类代码
/// 			  aDesc:    短语名称
/// Return：      返回String
/// w ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing","甲级愈合")
ClassMethod GetMapValueByPhrase(aScode As %String, aTypeCode As %String, aDesc As %String) As %String
{
	New (aScode,aTypeCode,aDesc)
	Set return=""
	Quit:(aScode="")||(aTypeCode="")||(aDesc="") return
	
	Set TypeID=$o(^DHCHAI.DP.PhraseTypeI("IndexCode"," "_$zcvt(aTypeCode,"U"),0))
	Quit:TypeID="" return
	Set ID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeDesc",aScode,TypeID,aDesc,0))
	Quit:ID="" return
	
	Set MapData=$g(^DHCHAI.DP.PhraseMapD(ID))
	Set BTIsActive=$li(MapData,7)
	Quit:BTIsActive'=1 return
	Set BTMapDicDr=$li(MapData,5)
	Quit:BTMapDicDr="" return
	Set DicData=$g(^DHCHAI.BT.DictionaryD(BTMapDicDr))
	Quit:DicData="" return
	Set return=BTMapDicDr_"^"_$li(DicData,2)_"^"_$li(DicData,3)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-15
/// Description:  根据代码取标准结果分类
/// Table：       DHCHAI.DP.PhraseMap
/// Input：       aScode：子系统代码
/// 			  aTypeCode: 分类代码
/// 			  aCode:    值代码
/// Return：      返回String
/// w ##class(DHCHAI.DP.PhraseMap).GetMapValue("LIS01","LABTestRstSen","R")
ClassMethod GetMapValue(aScode As %String, aTypeCode As %String, aCode As %String) As %String
{
	New (aScode,aTypeCode,aCode)
	Set return=""
	Quit:(aScode="")||(aTypeCode="")||(aCode="") return
	set:$l(aCode)>100 aCode=$e(aCode,1,100)
	
	Set TypeID=$o(^DHCHAI.DP.PhraseTypeI("IndexCode"," "_$zcvt(aTypeCode,"U"),0))
	Quit:TypeID="" return
	Set ID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",aScode,TypeID,aCode,0))
	Quit:ID="" return
	Set MapData=$g(^DHCHAI.DP.PhraseMapD(ID))
	Quit:MapData="" return
	Quit:$li(MapData,7)'=1 return
	Set MapDicDr=$li(MapData,5)
	Quit:MapDicDr="" return
	Set return=$li($g(^DHCHAI.BT.DictionaryD(MapDicDr)),2)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新常用短语对照
/// Table：       DHCHAI.DP.PhraseMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.PhraseMap).Update("^ZQ^择期^1^^NIS^1^2017-02-07^14:00:00^系统自动")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		= $p(InStr,aSeparete,1)
	Set Code   	= $p(InStr,aSeparete,2)
	Set Desc   	= $p(InStr,aSeparete,3)
	Set TypeDr  = $p(InStr,aSeparete,4)
	Set MapDicDr= $p(InStr,aSeparete,5)
	Set SCode  	= $p(InStr,aSeparete,6)
	Set IsActive= +$p(InStr,aSeparete,7)
	Set ActDate = $p(InStr,aSeparete,8)
	Set ActTime = $p(InStr,aSeparete,9)
	Set ActUser	= $p(InStr,aSeparete,10)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	//修复bug484040，执行自动任务后同步手术相关常用短语中有特殊字符，导致报错
	Set Code = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Code) //去掉特殊字符  
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	Quit:(Code="")||(Desc="")||(TypeDr="")||(SCode="")||(IsActive="") return
	
	//子系统代码+短语分类+短语代码 唯一性
	Set tID =$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",SCode,TypeDr,Code,0)) 
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objType = ##class(DHCHAI.DP.PhraseType).GetObjById(TypeDr)
	Set objMapDic = ##class(DHCHAI.BT.Dictionary).GetObjById(MapDicDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.PhraseMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.PhraseMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTDesc		= Desc
	Set obj.BTTypeDr	= objType
	Set obj.BTMapDicDr	= objMapDic
	Set obj.BTSCode		= SCode
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUser	= ActUser
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除常用短语对照
/// Table：       DHCHAI.DP.PhraseMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.PhraseMap).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2017-08-17
/// Description:  导入常用短语对照
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(DHCHAI.DP.PhraseMap).ImportPhraseMap("^N^数值^检验结果分类^数值^LIS01^1","^")
ClassMethod ImportPhraseMap(aInStr As %String, aSeparate As %String) As %String
{
	New (aInStr,aSeparate)
	Set return = ""
	Quit:(aInStr="")||(aSeparate="") return
	
	Set TypeDr = "",DicType=""
	Set TypeDesc	= $p(aInStr,aSeparate,4)
	Set objType     = ##class(DHCHAI.DP.PhraseType).GetObjByCodeDesc("",TypeDesc)
	Set:$isobject(objType) TypeDr = objType.%Id()
	Set $p(aInStr,aSeparate,4) = TypeDr
	Set:$isobject(objType) DicType = objType.BTDicType

	Set MapDicDr = ""
	Set MapDicDesc = $p(aInStr,aSeparate,5)
	Set objDic  = ##class(DHCHAI.BT.Dictionary).GetObjByDesc(DicType,MapDicDesc)
	Set:$isobject(objDic) MapDicDr = objDic.%Id()
	Set $p(aInStr,aSeparate,5) = MapDicDr 
	Set return = ..Update(aInStr,aSeparate)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTTypeDr</Value>
</Value>
<Value name="5">
<Value>BTMapDicDr</Value>
</Value>
<Value name="6">
<Value>BTSCode</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.PhraseMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.PhraseMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.PhraseMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.PhraseMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
