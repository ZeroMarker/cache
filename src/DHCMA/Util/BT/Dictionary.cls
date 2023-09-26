/// 名称: DHCMA.Util.BT.Dictionary
/// 描述: 系统字典表
/// 编写者：zhufei    
/// 编写日期: 2018-07-31
Class DHCMA.Util.BT.Dictionary Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 字典分类  
Property BTTypeDr As DHCMA.Util.BT.DicType [ Required ];

/// 排序码
Property BTIndNo As %Integer;

/// 有效标志
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 字典分类 + 代码 索引
Index IdxofTypeDrCode On (BTTypeDr, BTCode) [ Unique ];

/// 字典分类 + 名称 索引
Index IdxofTypeDrDesc On (BTTypeDr, BTDesc);

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据ID取系统字典信息
/// Table：       DHCMA.Util.BT.Dictionary
/// Input：       aId :  DHCMA.Util.BT.Dictionary.ID
/// Return：      返回obj
/// zw ##class(DHCMA.Util.BT.Dictionary).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.Dictionary
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.Dictionary).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.Dictionary).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-16
/// Description:  根据分类和代码取系统字典信息
/// Table：       DHCMA.Util.BT.Dictionary
/// Input：       DHCMA.Util.BT.Dictionary.BTTypeDr,BTCode
/// Return：      返回obj
/// zw ##class(DHCMA.Util.BT.Dictionary).GetObjByCode("CPWFormItemType","A")
ClassMethod GetObjByCode(aTypeCode As %String, aCode As %String) As DHCMA.Util.BT.Dictionary
{
	New (aTypeCode,aCode)
	Quit:(aTypeCode="")&&(aCode="") ""
	Set objType=##class(DHCMA.Util.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) ""
	Set TypeDr=objType.%Id()
	Set ID=$o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",TypeDr," "_$zcvt(aCode,"U"),0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     mayanpeng
/// CreatDate：   2019-02-19
/// Description:  根据ID取系统字典Code
/// Table：       DHCMA.Util.BT.Dictionary
/// Input：       aId :  DHCMA.Util.BT.Dictionary.ID
/// Return：      返回DHCMA.Util.BT.Dictionary.BTCode
/// w ##class(DHCMA.Util.BT.Dictionary).GetCodeById(1)
ClassMethod GetCodeById(aId As %String) As %String
{
	New (aId)
	Set obj=##class(DHCMA.Util.BT.Dictionary).GetObjById(aId)
	Quit:'$IsObject(obj) ""
	Set Code=obj.BTCode
	Quit Code
}

/// Creator：     蒋朋朋
/// CreatDate：   2019-03-11
/// Description:  通过描述取字典ID
/// Table：       DHCMA.Util.BT.Dictionary
/// Input：       aDicCode:字典类型代码, aDesc : 字典描述
/// Return：      
/// w ##class(DHCMA.Util.BT.Dictionary).GetDicIDByDesc("COPGender","男")
ClassMethod GetDicIDByDesc(aDicCode As %String, aDesc As %String) As %String
{
	New (aDicCode,aDesc)
	Set return=""
	Quit:(aDicCode="")||(aDesc="") return
	
	Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc(aDicCode,aDesc)
	Quit:'$IsObject(objDic) return
	
	Set return=objDic.%Id()
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-30
/// Description:  删除系统字典信息
/// Table：       DHCMA.Util.BT.Dictionary
/// Input：       aId :  DHCMA.Util.BT.Dictionary.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.Dictionary).DeleteById(3)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.Util.BT.Dictionary")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMA.Util.BT.Dictionary).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		//数据院区关联处理 add by yankai20210803
		If aHospID'=""{
			Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
			If (ret="Y")||(ret=1){
				Do ##class(DHCMA.Util.IO.MultiHospInterface).DelAllDataHospRelRecs("DHCMA_Util_BT.Dictionary",aId,aHospID)
			}
		}
		
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-30
/// Description:  更新系统字典信息
/// Table：       DHCMA.Util.BT.Dictionary
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.Dictionary).Update("2^2^测试23^1^90^1^2018-09-10^16:32:57^118","^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	  
	Set ID       = $p(aInputStr,aSeparete,1)       //获取数据（表的字段）
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set TypeDr   = $p(aInputStr,aSeparete,4)
	Set IndNo	 = +$p(aInputStr,aSeparete,5)
	Set IsActive = +$p(aInputStr,aSeparete,6)
	Set ActDate  = $p(aInputStr,aSeparete,7)
	Set ActTime  = $p(aInputStr,aSeparete,8)
	Set ActUserID= $p(aInputStr,aSeparete,9)
	Quit:(Code="")||(Desc="")||(TypeDr="") return
	
	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set objType=##class(DHCMA.Util.BT.DicType).GetObjById(TypeDr)
	Quit:'$IsObject(objType) return
	Set tID=$o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",TypeDr," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {                                  
		Set obj=##class(DHCMA.Util.BT.Dictionary).%New()
	}Else{
		Set obj=##class(DHCMA.Util.BT.Dictionary).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTTypeDr   = ##class(DHCMA.Util.BT.DicType).GetObjById(TypeDr)
	Set obj.BTIndNo    = IndNo
	Set obj.BTIsActive = IsActive
	Set obj.BTActDate  = ActDate
	Set obj.BTActTime  = ActTime
	Set obj.BTActUserID= ActUserID
	
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	//数据院区关联处理 add by yankai20210803
	If (+return>0)&&(aHospID'=""){
		Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
		If (ret="Y")||(ret=1){
			Do ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_Util_BT.Dictionary",return,aHospID)	
		}
	}
	
	Quit return
}

/// s a=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("SDType","文本")
ClassMethod GetObjByPCodeItemDesc(PCode As %String, Alias As %String) As DHCMA.Util.BT.Dictionary
{
	n (PCode,Alias)
	Set return=""
	Set DicTypeObj=##class(DHCMA.Util.BT.DicType).GetObjByCode(PCode)
	Quit:'$IsObject(DicTypeObj) return
	Set DicId=DicTypeObj.%Id()
	Set ItemID=$o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrDesc",DicId," "_Alias,""),-1)
	Set ItemObj=##class(DHCMA.Util.BT.Dictionary).GetObjById(ItemID)
	Quit:'$IsObject(ItemObj) return
	Quit ItemObj
}

Storage Default
{
<Data name="DictionaryDefaultData">
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
<Value>BTIndNo</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.BT.DictionaryD</DataLocation>
<DefaultData>DictionaryDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.BT.DictionaryD</IdLocation>
<IndexLocation>^DHCMA.Util.BT.DictionaryI</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.DictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
