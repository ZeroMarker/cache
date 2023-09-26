/// 名称: DHCMA.CPW.BT.PathWebCreate
/// 描述: web页面创建路径日志表
/// 编写者：zqy
/// 编写日期: 2022-9-6
Class DHCMA.CPW.BT.PathWebCreate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 表单
Property PathFormDr As DHCMA.CPW.BT.PathForm;

/// 创建状态（临时T、完成C）
Property BTStatus As %String(DISPLAYLIST = "TMP,CLOSE", VALUELIST = ",T,C");

/// 创建科室ID（指向DHCMA.Util.EP.Location.OID）
Property BTCreLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 创建用户ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTCreUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 创建日期
Property BTCreDate As %Date;

/// 创建时间
Property BTCreTime As %Time;

Index IdxofLoc On BTCreLocID;

Index IdxofPathForm On PathFormDr;

/// Creator：     zqy
/// CreatDate：   2022-9-6
/// Description:  根据ID取web页面路径日志信息
/// Table：       DHCMA.CPW.BT.PathWebCreate
/// Input：       aId :  DHCMA.CPW.BT.PathWebCreate.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathWebCreate).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathWebCreate
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathWebCreate).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathWebCreate).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2022-9-6
/// Description:  删除web页面路径日志信息
/// Table：       DHCMA.CPW.BT.PathWebCreate
/// Input：       aId :  DHCMA.CPW.BT.PathWebCreate.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathWebCreate).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	//Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.PathWebCreate")
	//Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.BT.PathWebCreate).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zwy
/// CreatDate：   2022-9-6
/// Description:  更新web页面路径日志信息
/// Table：       DHCMA.CPW.BT.PathWebCreate
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathWebCreate).Update("")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID      	    = 	$p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set PathFormDr     	= 	$p(aInputStr,aSeparete,2)
	Set Status    		= 	$p(aInputStr,aSeparete,3)
	Set CreLocID  		= 	$p(aInputStr,aSeparete,4)
	Set CreUserID  		= 	$p(aInputStr,aSeparete,5)
	Set CreDate 		= 	$p(aInputStr,aSeparete,6)
	Set CreTime 		= 	$p(aInputStr,aSeparete,7)
	
	Set objPathForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(PathFormDr)
	Quit:'$IsObject(objPathForm) return
	
	Set:CreDate["-" CreDate=$zdh(ActDate,3)
	Set:CreDate="" CreDate=+$h
	Set:CreTime[":" CreTime=$zth(ActTime,1)
	Set:CreTime="" CreTime=$p($h,",",2)

	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.PathWebCreate).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathWebCreate).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.PathFormDr    	= objPathForm      //写入数据
	Set obj.BTStatus    	= Status
	Set obj.BTCreLocID		= CreLocID
	Set obj.BTCreUserID 	= CreUserID
	Set obj.BTCreDate	= CreDate 
	Set obj.BTCreTime	= CreTime
	
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

/// w ##class(DHCMA.CPW.BT.PathWebCreate).ComPleteForm(1)
ClassMethod ComPleteForm(aPathFormDr As %String) As %String
{
	New (aPathFormDr)
	Set return=""
	Quit:aPathFormDr="" return
	Set xID=$o(^DHCMA.CPW.BT.PathWebCreateI("IdxofPathForm",aPathFormDr,""),-1)
	Set obj=##class(DHCMA.CPW.BT.PathWebCreate).GetObjById(xID)
	b ;1
	Quit:'$IsObject(obj) return
	
	Set obj.BTStatus="C"
	
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

Storage Default
{
<Data name="PathWebCreateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PathFormDr</Value>
</Value>
<Value name="3">
<Value>BTStatus</Value>
</Value>
<Value name="4">
<Value>BTCreLocID</Value>
</Value>
<Value name="5">
<Value>BTCreUserID</Value>
</Value>
<Value name="6">
<Value>BTCreDate</Value>
</Value>
<Value name="7">
<Value>BTCreTime</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathWebCreateD</DataLocation>
<DefaultData>PathWebCreateDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathWebCreateD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathWebCreateI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathWebCreateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
