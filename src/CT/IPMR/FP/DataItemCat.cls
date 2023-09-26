/// 名称: CT.IPMR.FP.DataItemCat
/// 描述: 编目数据项分类
/// 创建者：liyi
/// 创建日期: 2019-11-28
Class CT.IPMR.FP.DataItemCat Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property FDCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 描述
Property FDDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 数据类型 （FPDataType）
Property FDDataTypeDr As CT.IPMR.BT.Dictionary [ Required ];

/// 值域（作废）
Property FDRange As %String(MAXLEN = 500, TRUNCATE = 1);

/// 联动控制数据项分类代码
Property FDLinkCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 激活期限（HIS）（作废）
Property FDDateLimit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 编目页面是否显示代码
Property FDIsShowCode As %Boolean [ Required ];

/// 字典来源
Property FDDicType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 字典名（HIS字典为字典表名）
Property FDDicCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 代码字段
Property FDDicCodeColumn As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述字段
Property FDDicTextColumn As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效开始日期字段
Property FDDicDateFrom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效结束日期字段
Property FDDicDateTo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联动关联字段
Property FDDicLinkColumn As %String(MAXLEN = 100, TRUNCATE = 1);

/// ID字段
Property FDDicIDColumn As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否必填项
Property FDIsNecessaryItem As %Boolean [ Required ];

/// 是否可填-
Property FDIsItemChar As %Boolean [ Required ];

Index IndexFDCode On FDCode [ Unique ];

/// Creator：     liyi
/// CreatDate：   2019-11-28
/// Description:  代码取编目数据项分类值域
/// Table：       CT.IPMR.FP.DataItemCat
/// Input：       aCode : CT.IPMR.FP.DataItemCat.FDCode
/// Return：      CT.IPMR.FP.DataItemCat.FDRange
/// w ##class(CT.IPMR.FP.DataItemCat).GetRangeByCode("P01017")
ClassMethod GetRangeByCode(aCode As %String) As %String
{
	new (aCode)
	Set return="{""value"":"""_""_"""}"
	Quit:aCode="" return
	Set:aCode'["." aCode=$e(aCode,1,3)_"."_$e(aCode,4,$length(aCode))
	Set obj = ..GetObjByCode(aCode)
	Set:$Isobject(obj) return="{""value"":"""_obj.FDRange_"|"_$tr(obj.FDLinkCode,".","")_"|"_obj.FDDateLimit_"""}"
	quit return
}

/// Creator：     liyi
/// CreatDate：   2019-11-28
/// Description:  取编目数据项分类
/// Table：       CT.IPMR.FP.DataItemCat
/// Input：       aCode : CT.IPMR.FP.DataItemCat.FDCode
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.DataItemCat).GetObjByCode("P01.001")
ClassMethod GetObjByCode(aCode As %String) As CT.IPMR.FP.DataItemCat
{
	new (aCode)
	Set return=""
	Set id = $o(^CT.IPMR.FP.DataItemCatI("IndexFDCode"," "_$ZCVT(aCode,"U"),0))
	Quit:id="" return
	Set obj = ..GetObjById(id)
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-11-28
/// Description:  取编目数据项分类
/// Table：       CT.IPMR.FP.DataItemCat
/// Input：       Id : CT.IPMR.FP.DataItemCat.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.DataItemCat).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.DataItemCat
{
	new (aId)
	quit:'##class(CT.IPMR.FP.DataItemCat).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.DataItemCat).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-11-28
/// Description:  更新编目数据项分类
/// Table：       CT.IPMR.FP.DataItemCat
/// Input：       InputStr ：字典数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.DataItemCat).Update("45^P01.045^入院科别^250^^^^0^HIS^MA_IPMR_BT.Location^BLCode^BLDesc^^^^ID^1^0^158,159","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID			= $p(aInputStr,aSeparate,1)
	Set Code 		= $p(aInputStr,aSeparate,2)
	Set Desc 		= $p(aInputStr,aSeparate,3)
	Set DataTypeID	= $p(aInputStr,aSeparate,4)
	Set Range		= $p(aInputStr,aSeparate,5)
	Set LinkCode	= $p(aInputStr,aSeparate,6)
	Set DateLimit	= $p(aInputStr,aSeparate,7)
	set IsShowCode  = +$p(aInputStr,aSeparate,8)
	set DicType	 	= $p(aInputStr,aSeparate,9)
	set DicCode 	= $p(aInputStr,aSeparate,10)
	set DicCodeColumn 	= $p(aInputStr,aSeparate,11)
	set DicTextColumn 	= $p(aInputStr,aSeparate,12)
	set DicDateFrom 	= $p(aInputStr,aSeparate,13)
	set DicDateTo 		= $p(aInputStr,aSeparate,14)
	set DicLinkColumn	= $p(aInputStr,aSeparate,15)
	set DicIDColumn		= $p(aInputStr,aSeparate,16)
	set IsNecessaryItem = +$p(aInputStr,aSeparate,17)
	set IsItemChar		= +$p(aInputStr,aSeparate,18)
	set FPTypeIDs		= $p(aInputStr,aSeparate,19)
	Quit:(Code="")||(Desc="")||(DataTypeID="") return

	Set objDataType = ##class(CT.IPMR.BT.Dictionary).GetObjById(DataTypeID)
	Quit:'$IsObject(objDataType) return
	
	Set tID = $o(^CT.IPMR.FP.DataItemCatI("IndexFDCode"," "_$ZCVT(Code,"U"),0))
	Quit:(tID'="")&&(ID="") -100
	Quit:(tID'="")&&(ID'="")&&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.FP.DataItemCat).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.DataItemCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FDCode			= Code
	Set obj.FDDesc			= Desc
	Set obj.FDDataTypeDr 	= objDataType
	Set obj.FDRange			= Range
	Set obj.FDLinkCode		= LinkCode
	Set obj.FDDateLimit		= DateLimit
	Set obj.FDIsShowCode	= IsShowCode
	set obj.FDDicType	 	= DicType
	set obj.FDDicCode 		= DicCode
	set obj.FDDicCodeColumn = DicCodeColumn
	set obj.FDDicTextColumn = DicTextColumn
	set obj.FDDicDateFrom 	= DicDateFrom
	set obj.FDDicDateTo 	= DicDateTo 
	set obj.FDDicLinkColumn = DicLinkColumn 
	set obj.FDDicIDColumn   = DicIDColumn 
	set obj.FDIsNecessaryItem = IsNecessaryItem
	set obj.FDIsItemChar    = IsItemChar
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		// 自动生成编目数据项
		If (Code["P")||(Code["F")||(Code["B")||(Code["T") {	 // P:基本信息,F:费用信息,B:分娩信息,T:肿瘤信息
			Set ItemCode = Code_".01"
			Set ItemDesc = Desc
			Set ItemResume = $s(Code["P":"基本信息",Code["F":"费用信息",Code["B":"分娩信息",Code["T":"肿瘤信息")
			set Inputs = ""
			set Inputs = Inputs_"^"_FPTypeIDs
			set Inputs = Inputs_"^"_ItemCode
			set Inputs = Inputs_"^"_ItemDesc
			set Inputs = Inputs_"^"_obj.%Id()
			set Inputs = Inputs_"^"_ItemResume
			d ##class(CT.IPMR.FP.DataItem).Update(Inputs,"^")
			if objDataType.BDCode="DIC" {
				Set ItemCode = Code_".02"
				set LastNum = ##Class(MA.IPMR.SSService.CommonSrv).getLastNum(Desc)
				if LastNum="" {
					Set ItemDesc = Desc_"代码"
				}else{
					Set ItemDesc = $p(Desc,LastNum,1)_"代码"_LastNum
				}
				
				set Inputs = ""
				set Inputs = Inputs_"^"_FPTypeIDs
				set Inputs = Inputs_"^"_ItemCode
				set Inputs = Inputs_"^"_ItemDesc
				set Inputs = Inputs_"^"_obj.%Id()
				set Inputs = Inputs_"^"_ItemResume
				d ##class(CT.IPMR.FP.DataItem).Update(Inputs,"^")
				//set ExpReg="^[0-9]*$"
				//Set:$MATCH(NodeValue,aExpReg)=0 Err=1
				
			}
		}
		
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-11-28
/// Description:  删除编目数据项分类
/// Table：       CT.IPMR.FP.DataItemCat
/// Input：       Id : CT.IPMR.FP.DataItemCat.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.DataItemCat).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.DataItemCat).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FDCode</Value>
</Value>
<Value name="3">
<Value>FDDesc</Value>
</Value>
<Value name="4">
<Value>FDDataTypeDr</Value>
</Value>
<Value name="5">
<Value>FDRange</Value>
</Value>
<Value name="6">
<Value>FDLinkCode</Value>
</Value>
<Value name="7">
<Value>FDDateLimit</Value>
</Value>
<Value name="8">
<Value>FDIsShowCode</Value>
</Value>
<Value name="9">
<Value>FDDicType</Value>
</Value>
<Value name="10">
<Value>FDDicTypeCode</Value>
</Value>
<Value name="11">
<Value>FDDicCodeColumn</Value>
</Value>
<Value name="12">
<Value>FDDicTextColumn</Value>
</Value>
<Value name="13">
<Value>FDDicDateFrom</Value>
</Value>
<Value name="14">
<Value>FDDicDateTo</Value>
</Value>
<Value name="15">
<Value>DicCode</Value>
</Value>
<Value name="16">
<Value>FDDicCode</Value>
</Value>
<Value name="17">
<Value>FDDicLinkColumn</Value>
</Value>
<Value name="18">
<Value>FDDicIDColumn</Value>
</Value>
<Value name="19">
<Value>FDIsNecessaryItem</Value>
</Value>
<Value name="20">
<Value>FDIsItemChar</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.DataItemCatD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.DataItemCatD</IdLocation>
<IndexLocation>^CT.IPMR.FP.DataItemCatI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.DataItemCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
