/// 检验结果信息
Class DHCMA.CPW.SD.Data.LisItemInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 患者送检信息
Property LisInfoDr As DHCMA.CPW.SD.Data.LisInfo;

/// 检验项目代码
Property LItemCode As %String;

/// 检验项目描述
Property LItemDesc As %String;

/// 检验项目结果-输出
Property LItemVal As %String(MAXLEN = 500);

/// 结果说明(备注)
Property LabResNoes As %String(MAXLEN = 500, TRUNCATE = 1);

/// 异常标记-输出
Property LabAbFlag As %String(MAXLEN = 100, TRUNCATE = 1);

Index IdxItemCode On (LisInfoDr As Exact, LItemCode);

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Data.LisItemInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.LisItemInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.LisItemInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-04-12
/// Description:  更新检验结果
/// Table：       DHCMA.CPW.SD.Data.LisItemInfo
/// Input：       各属性列表 默认^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.LisItemInfo).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set LisInfoDr		= $p(aInputStr,aSeparete,1)
	Set LItemCode		= $p(aInputStr,aSeparete,2)					
	Set LItemVal		= $p(aInputStr,aSeparete,3)
	Set LabResNoes		= $p(aInputStr,aSeparete,4)
	Set LabAbFlag		= $p(aInputStr,aSeparete,5)
	Set LItemDesc		= $p(aInputStr,aSeparete,6)
	Quit:(LisInfoDr="") return
	Set ID=$o(^DHCMA.CPW.SD.Data.LisItemInfoI("IdxItemCode",LisInfoDr,LItemCode,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Data.LisItemInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.LisItemInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.LisInfoDr	= ##class(DHCMA.CPW.SD.Data.LisInfo).GetObjById(LisInfoDr)				
	Set obj.LItemCode	= LItemCode	
	Set obj.LItemVal	= LItemVal
	Set obj.LabResNoes	= LabResNoes
	Set obj.LabAbFlag	= LabAbFlag
	Set obj.LItemDesc	= LItemDesc
	//检验Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Description:  删除项检验记录
/// Table：       DHCMA.CPW.SD.Data.LisItemInfo
/// Input：       aId :  DHCMA.CPW.SD.Data.LisItemInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.LisItemInfo).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Data.LisItemInfo).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检验删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="LisItemInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LisInfoDr</Value>
</Value>
<Value name="3">
<Value>LItemCode</Value>
</Value>
<Value name="4">
<Value>LItemVal</Value>
</Value>
<Value name="5">
<Value>LabResNoes</Value>
</Value>
<Value name="6">
<Value>LabAbFlag</Value>
</Value>
<Value name="7">
<Value>LItemDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.LisItemInfoD</DataLocation>
<DefaultData>LisItemInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.LisItemInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.LisItemInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.LisItemInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
