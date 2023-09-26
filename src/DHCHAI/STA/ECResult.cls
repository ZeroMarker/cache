/// 名称: DHCHAI.STA.ECResult
/// 描述: 统计数据结果
/// 编写者：jiangpengpeng
/// 编写日期: 2018-06-12
Class DHCHAI.STA.ECResult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 院区	    
Property ECHospID As %String;

/// 科室	    
Property ECLocID As %String;

/// 数据类型	
Property ECTypeDr As DHCHAI.STA.ECType;

/// 统计指标	
Property ECTargetDr As DHCHAI.STA.ECTarget;

/// 结果值	
Property ECValue As %String;

/// 时间标记
Property ECTime As %String;

/// 时间节点(暂时不用)
Property ECYear As %String;

/// 更新日期	
Property ECUpdateD As %Date;

/// 更新时间	
Property ECUpdateT As %Time;

Index IndexTarTypeLocTime On (ECTargetDr, ECTypeDr, ECLocID As Exact, ECTime As Exact);

Index IndexLocTypeTimeTar On (ECLocID As Exact, ECTypeDr, ECTime As Exact, ECTargetDr);

Index IdxofLocTypeT On (ECHospID As Exact, ECLocID As Exact, ECTypeDr, ECTargetDr, ECTime As Exact);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  根据ID取统计结果
/// Table：       DHCHAI.STA.ECResult
/// Input：       aId : DHCHAI.STA.ECResult
/// Return：      返回obj
/// w ##class(DHCHAI.STA.ECResult).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.STA.ECResult
{
	New (aId)
	Quit:'##class(DHCHAI.STA.ECResult).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.STA.ECResult).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  更新统计结果信息
/// Table：       DHCHAI.STA.ECResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.STA.ECResult).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID      	= $p(aInputStr,aSeparete,1)
	Set ECHospID    = $p(aInputStr,aSeparete,2)
	Set ECLocID     = $p(aInputStr,aSeparete,3)
	Set ECTypeDr 	= $p(aInputStr,aSeparete,4)
	Set ECTargetDr 	= $p(aInputStr,aSeparete,5)
	Set ECValue    	= $p(aInputStr,aSeparete,6)
	Set ECTime  	= $p(aInputStr,aSeparete,7)
	Set ECYear  	= $p(aInputStr,aSeparete,8)
	Set ECUpdateD  	= +$H
	Set ECUpdateT  	= $p($H,",",2)
	
	Quit:(ECTypeDr="")||(ECTargetDr="") return
	
	Set tID=$o(^DHCHAI.STA.ECResultI("IndexTarTypeLocTime",ECTargetDr,ECTypeDr,ECLocID,ECTime,""))
	Set:(tID'="")&&(ID'=tID) ID=tID
	
	If ID="" {
		Set obj=##class(DHCHAI.STA.ECResult).%New()
	}Else{
		Set obj=##class(DHCHAI.STA.ECResult).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ECHospID   = ECHospID
	Set obj.ECLocID    = ECLocID
	Set obj.ECTypeDr   = ##class(DHCHAI.STA.ECType).GetObjById(ECTypeDr)
	Set obj.ECTargetDr = ##class(DHCHAI.STA.ECTarget).GetObjById(ECTargetDr)
	Set obj.ECValue    = ECValue
	Set obj.ECTime     = ECTime
	Set obj.ECYear	   = ECYear
	Set obj.ECUpdateD  = ECUpdateD
	Set obj.ECUpdateT  = ECUpdateT
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  删除统计结果信息
/// Table：       DHCHAI.STA.ECResult
/// Input：       aId : DHCHAI.STA.ECResult.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.STA.ECResult).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.STA.ECResult).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCHAI.STA.ECResult).ClearData("2018-02","DataMonth","INFOper")
ClassMethod ClearData(aMonth As %String, aType As %String, aTarget As %String) As %String
{
	New (aMonth,aType,aTarget)
	Quit:(aMonth="")||(aType="")||(aTarget="") ""
	
	Set DateFrom=$zdh(aMonth_"-01",3)
	Set DateTo=$zdh($e($zd(DateFrom+31,3),1,7)_"-01",3)-1
	Set objType=##class(DHCHAI.STA.ECType).GetObjByCode(aType)
	Quit:'$IsObject(objType) ""
	Set TypeDr=objType.%Id()
	Set objTarget=##class(DHCHAI.STA.ECTarget).GetObjByCode(aTarget)
	Quit:'$IsObject(objTarget) ""
	Set TargetDr=objTarget.%Id()
	
	Set xHospID=""
	For {
		Set xHospID=$o(^DHCHAI.STA.ECResultI("IdxofLocTypeT",xHospID))
		Quit:xHospID=""
		
		Set xLocID=""
		For {
			Set xLocID=$o(^DHCHAI.STA.ECResultI("IdxofLocTypeT",xHospID,xLocID))
			Quit:xLocID=""
			
			Set xType=""
			For {
				Set xType=$o(^DHCHAI.STA.ECResultI("IdxofLocTypeT",xHospID,xLocID,xType))
				Quit:xType=""
				Continue:(aType'="")&&(TypeDr'=xType)
				
				Set xTarget=""
				For {
					Set xTarget=$o(^DHCHAI.STA.ECResultI("IdxofLocTypeT",xHospID,xLocID,xType,xTarget))
					Quit:xTarget=""
					Continue:(aTarget'="")&&(TargetDr'=xTarget)
					
					Set xTime=DateFrom-1
					For {
						Set xTime=$o(^DHCHAI.STA.ECResultI("IdxofLocTypeT",xHospID,xLocID,xType,xTarget,xTime))
						Quit:xTime=""
						Quit:xTime>DateTo
						
						Set ID=$o(^DHCHAI.STA.ECResultI("IdxofLocTypeT",xHospID,xLocID,xType,xTarget,xTime,""))
						Continue:ID=""
						
						Set ret=##class(DHCHAI.STA.ECResult).DeleteById(ID)
						
						//w ret,!
					}
				}
			}
		}
	}
	Quit "OK"
}

Storage Default
{
<Data name="ECResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECHospID</Value>
</Value>
<Value name="3">
<Value>ECLocID</Value>
</Value>
<Value name="4">
<Value>ECTypeDr</Value>
</Value>
<Value name="5">
<Value>ECTargetDr</Value>
</Value>
<Value name="6">
<Value>ECValue</Value>
</Value>
<Value name="7">
<Value>ECTime</Value>
</Value>
<Value name="8">
<Value>ECUpdateD</Value>
</Value>
<Value name="9">
<Value>ECUpdateT</Value>
</Value>
<Value name="10">
<Value>ECYear</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.STA.ECResultD</DataLocation>
<DefaultData>ECResultDefaultData</DefaultData>
<IdLocation>^DHCHAI.STA.ECResultD</IdLocation>
<IndexLocation>^DHCHAI.STA.ECResultI</IndexLocation>
<StreamLocation>^DHCHAI.STA.ECResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
