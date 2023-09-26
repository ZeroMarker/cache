/// 名称: DHCMA.CPW.SD.QCExpress
/// 描述: 特定(单)病种质量监测表达式
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.SD.QCExpress Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 描述
Property BTDesc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 类型
Property BTTypeDr As DHCMA.Util.BT.Dictionary;

/// 是否有效
Property BTIsActive As %Boolean;

/// 表达式
Property BTExpress As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 表达式说明
Property BTExpressTxt As %String(MAXLEN = 500, TRUNCATE = 1);

/// 表达式参数
Property BTExpressParam As %String(MAXLEN = 500, TRUNCATE = 1);

/// 校验级别（针对校验函数：Error、Warning）
Property BTLevel As %String(MAXLEN = 500, TRUNCATE = 1);

/// 代码 索引
Index IdxOfCode On BTCode [ Unique ];

/// 类型 索引
Index IdxOfType On BTTypeDr;

/// w ##class(DHCMA.CPW.SD.QCExpress).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCExpress
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCExpress).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCExpress).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCExpress).GetObjByCode("Code")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.CPW.SD.QCExpressI("IdxOfCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// w ##class(DHCMA.CPW.SD.QCExpress).Update("^daima^miaoshu ^suoxie^1^paixu^02/08/2018")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID               = $p(aInputStr,aSeparete,1)
	Set Code             = $p(aInputStr,aSeparete,2)
	Set Desc             = $p(aInputStr,aSeparete,3)
	Set TypeDr           = $p(aInputStr,aSeparete,4)
	Set IsActive         = $p(aInputStr,aSeparete,5)
	Set Express          = $p(aInputStr,aSeparete,6)
	Set ExpressParam     = $p(aInputStr,aSeparete,7)
	Set ExpressTxt       = $p(aInputStr,aSeparete,8)
	Set Level			 = $p(aInputStr,aSeparete,9)
	Set tID=$o(^DHCMA.CPW.SD.QCExpressI("IdxOfCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCExpress).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCExpress).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode        = Code
	Set obj.BTDesc        = Desc
	Set obj.BTTypeDr      = ##class(DHCMA.Util.BT.Dictionary).GetObjById(TypeDr)
	Set obj.BTIsActive    = IsActive
	Set obj.BTExpress     = Express
	Set obj.BTExpressParam= ExpressParam
	Set obj.BTExpressTxt  = ExpressTxt
	Set obj.BTLevel		  = Level
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##class(DHCMA.CPW.SD.QCExpress).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.SD.QCExpress")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.SD.QCExpress).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SD.QCExpress).ImportQCExpress("2^BaseInf^基本信息^198^1^##class(DHCMA.CPW.SDS.QCExpressSrv).ExpBaseInfo()^%EpisodeID,%ItemID^获取病人住院基本信息")
ClassMethod ImportQCExpress(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	
	Set return=0
	Quit:aInputStr="" return
	Set Code=$p(aInputStr,aSeparete,2)
	Set ID=$o(^DHCMA.CPW.SD.QCExpressI("IdxOfCode"," "_$zcvt(Code,"U"),0))		//导入时根据代码获取id，保证id不改变
	Set:ID'="" $p(aInputStr,aSeparete,1)=ID
	Set DicCode=$p(aInputStr,aSeparete,4)		
	//字典类型，默认为SDEXPType
	Set DicTypeCode="SDEXPType"
	Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByCode(DicTypeCode,DicCode)
	Quit:'$IsObject(objDic) return
	Set TypeDr   =objDic.%Id()
	Set $p(aInputStr,aSeparete,4)=TypeDr
	Set return=..Update(aInputStr,aSeparete)
	Quit return
}

Storage Default
{
<Data name="QCExpressDefaultData">
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
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTExpress</Value>
</Value>
<Value name="7">
<Value>BTExpressTxt</Value>
</Value>
<Value name="8">
<Value>BTExpressParam</Value>
</Value>
<Value name="9">
<Value>BTLevel</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCExpressD</DataLocation>
<DefaultData>QCExpressDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCExpressD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCExpressI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCExpressS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
