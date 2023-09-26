/// 项目数据来源 标准化配置
Class DHCMA.CPW.SD.QCItemDataConfig Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 质控项目
Property QCItem As DHCMA.CPW.SD.QCEntityItem;

/// 项目值域字典(待定)
Property QCItemDic As DHCMA.CPW.SD.Dictionary;

/// 数据源 
Property DataSource As DHCMA.Util.BT.Dictionary [ Required ];

/// 取值字典(数据源对应表格字段)
Property SourceField As %String;

/// 关联标准字典
Property StandDic As DHCMA.CPW.SD.Stand.Dic;

/// 关联标准字典子项
Property StandDicSub As DHCMA.CPW.SD.Stand.Dicsub;

/// 采集时机
Property GetValTime As DHCMA.Util.BT.Dictionary;

/// 结果值运算Exp
Property CalExp As %String;

/// 格式转换
Property DataFormat As %String;

Index IdxItemDic On QCItemDic As Exact;

Index IdxItem On QCItem As Exact;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCItemDataConfig
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCItemDataConfig).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCItemDataConfig).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-04-13
/// Description:  更新数据源配置
/// Table：       DHCMA.CPW.SD.QCItemDataConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.QCItemDataConfig).update("^^^45^LItemVal^104^104||340^32^^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ^tmpzhz426=aInputStr
	Set ID          	= $p(aInputStr,aSeparete,1)
	Set QCItemId      	= $p(aInputStr,aSeparete,2)
	Set QCItemDicId		= $p(aInputStr,aSeparete,3)
	Set SourceId        = $p(aInputStr,aSeparete,4)
	Set SourceField     = $p(aInputStr,aSeparete,5)
	Set DicId          	= $p(aInputStr,aSeparete,6)
	Set DicSubId      	= $p(aInputStr,aSeparete,7)
	Set GetValTimeId	= $p(aInputStr,aSeparete,8)
	Set CalExp			= $p(aInputStr,aSeparete,9)
	Set DataFormat		= $p(aInputStr,aSeparete,10)	
	Quit:(QCItemId="")&&(QCItemDicId="") return
	Quit:(SourceId="") return
	Set DataSource=##class(DHCMA.Util.BT.Dictionary).GetObjById(SourceId)
	Set StandDic=##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(DicId)
	Set StandDicSub=##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(DicSubId)
	Set QCItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(QCItemId)
	Set QCItemDic=##class(DHCMA.CPW.SD.Dictionary).GetObjById(QCItemDicId)
	Set GetValTime=##class(DHCMA.Util.BT.Dictionary).GetObjById(GetValTimeId)
	If (ID=""){
		If (QCItemDicId'="") {
			Set ID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItemDic",QCItemDicId,0))
		}else{
			Set ID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",QCItemId,0))	
		}	
	}
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.QCItemDataConfig).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCItemDataConfig).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据          
	Set obj.QCItem    	= QCItem       
	Set obj.QCItemDic	= QCItemDic	 
	Set obj.DataSource	= DataSource    
	Set obj.SourceField	= SourceField  
	Set obj.StandDic	= StandDic       
	Set obj.StandDicSub	= StandDicSub    
	Set obj.GetValTime	= GetValTime   
	Set obj.CalExp		= CalExp	 
	Set obj.DataFormat	= DataFormat
	
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set ^tmpzhz4262=sc
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zgz
/// CreatDate：   2021-04-13
/// Description:  删除项目数据源配置
/// Table：       DHCMA.CPW.SD.QCItemDataConfig
/// Input：       aId :  DHCMA.CPW.SD.QCItemDataConfig.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.QCItemDataConfig).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCItemDataConfig).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="QCItemDataConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QCItem</Value>
</Value>
<Value name="3">
<Value>QCItemDic</Value>
</Value>
<Value name="4">
<Value>GetValType</Value>
</Value>
<Value name="5">
<Value>DataSource</Value>
</Value>
<Value name="6">
<Value>SourceField</Value>
</Value>
<Value name="7">
<Value>StandDic</Value>
</Value>
<Value name="8">
<Value>StandDicSub</Value>
</Value>
<Value name="9">
<Value>GetValTime</Value>
</Value>
<Value name="10">
<Value>CalExp</Value>
</Value>
<Value name="11">
<Value>DataFormat</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCItemDataConfigD</DataLocation>
<DefaultData>QCItemDataConfigDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCItemDataConfigD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCItemDataConfigI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCItemDataConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
