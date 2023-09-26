/// 名称: DHCMA.CPW.BT.PathDrugLimit
/// 描述: 不变异医嘱维护，维护的医嘱不进行变异判断。
/// 编写者：zqy
/// 编写日期: 2023-04-13
Class DHCMA.CPW.BT.NoVarOrder Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 医嘱类型（大类，子类，项）
Property BTARCType As %String(DISPLAYLIST = "Gory,Cat,Mast", VALUELIST = ",G,C,M") [ Required ];

/// 医嘱类型相关项ID  
Property BTARCID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 维度(院区 科室 路径类型 路径)
Property BTLevel As %String(DISPLAYLIST = "Hosp,Loc,Type,Path", VALUELIST = ",H,L,T,P") [ Required ];

/// 各维度下的具体类型ID（院区ID 科室ID 路径类型ID 路径ID）
Property BTLevelType As %String;

/// 处置人（指向DHCMA.CPW.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

Index IdxofARC On (BTARCType As Exact, BTARCID As Exact);

Index IdxofLType On (BTLevel As Exact, BTLevelType As Exact, BTARCType As Exact);

Index IdxofLTArc On (BTLevel As Exact, BTLevelType As Exact, BTARCType As Exact, BTARCID As Exact);

/// Creator:	  zqy 
/// CreatDate：   2023-04-18
/// Description:  获取对象
/// Table：       DHCMA.CPW.BT.NoVarOrder
/// Input：       aId :  DHCMA.CPW.BT.NoVarOrder.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.NoVarOrder).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.NoVarOrder
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.NoVarOrder).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.NoVarOrder).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2023-04-18
/// Description:  更新信息
/// Table：       DHCMA.CPW.BT.NoVarOrder
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.NoVarOrder).Update("^G^11^L^93!!1,94!!1,96!!1^9!!1","^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set ID       		= $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set ARCType			= $p(aInputStr,aSeparete,2)
	Set ARCID     		= $p(aInputStr,aSeparete,3)
	Set Level     		= $p(aInputStr,aSeparete,4)
	Set LevelType		= $p(aInputStr,aSeparete,5)
	Set ActUserID		= $p(aInputStr,aSeparete,6)
	Set ActDate   		= $p(aInputStr,aSeparete,7)
	Set ActTime   		= $p(aInputStr,aSeparete,8)
	
	Set:ActDate'="" ActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Set Len=$l(LevelType,",")
	For index=1:1:Len{
		If ID="" {                                  				//根据ID判断是添加还是修改
			Set obj=##class(DHCMA.CPW.BT.NoVarOrder).%New()
		}Else{
			Set obj=##class(DHCMA.CPW.BT.NoVarOrder).%OpenId(ID)
		}
		Quit:return=-1
		Quit:'$IsObject(obj)
		Set xLevelType=$p(LevelType,",",index)
		Continue:xLevelType=""
		Set obj.BTARCType		= ARCType      //写入数据
		Set obj.BTARCID			= ARCID
		Set obj.BTLevel			= Level
		Set obj.BTLevelType		= xLevelType	
		Set obj.BTActUserID		= ActUserID
		Set obj.BTActDate		= ActDate
		Set obj.BTActTime		= ActTime
		
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
	}
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2023-04-18
/// Description:  删除
/// Table：       DHCMA.CPW.BT.NoVarOrder
/// Input：       aId :  DHCMA.CPW.BT.NoVarOrder.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.NoVarOrder).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set sc = ##class(DHCMA.CPW.BT.NoVarOrder).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2023-04-18
/// Description:  判断医嘱项是否已维护
/// w ##class(DHCMA.CPW.BT.NoVarOrder).CheckOrd("2","2")
ClassMethod CheckOrd(aLevel As %String, aLevelType As %String, aARCType As %String, ARCID As %String) As %String
{
	New (aLevel,aLevelType,aARCType,ARCID)
	Set return=""
	Set Len=$l(aLevelType,",")
	For index=1:1:Len{
		Set xLevelType=$p(aLevelType,",",index)
		Continue:xLevelType=""
		if ($d(^DHCMA.CPW.BT.NoVarOrderI("IdxofLTArc",aLevel,xLevelType,aARCType,ARCID))){
			Set xID=$o(^DHCMA.CPW.BT.NoVarOrderI("IdxofLTArc",aLevel,xLevelType,aARCType,ARCID,""),-1)
			Set obj=..GetObjById(xID)
			Continue:'$IsObject(obj)
			//Set Level=obj.BTLevel
			if (aLevel="H"){
				Set:xLevelType'["!!" xLevelType=xLevelType_"!!1"
				Set Typeobj=##class(DHCMA.Util.EP.Hospital).GetObjByOID(xLevelType)
			}elseif (aLevel="L"){
				Set:xLevelType'["!!" xLevelType=xLevelType_"!!1"
				Set Typeobj=##class(DHCMA.Util.EP.Location).GetObjByOID(xLevelType)
			}elseif (aLevel="T"){
				Set Typeobj=##class(DHCMA.CPW.BT.PathType).GetObjById(xLevelType)
			}elseif (aLevel="P"){
				Set Typeobj=##class(DHCMA.CPW.BT.PathMast).GetObjById(xLevelType)
			}
			Continue:'$IsObject(Typeobj)
			Set:return'="" return=return_","_Typeobj.BTDesc
			Set:return="" return=Typeobj.BTDesc
		}
	}

	Quit return
}

Storage Default
{
<Data name="NoVarOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTARCMastID</Value>
</Value>
<Value name="3">
<Value>BTLevel</Value>
</Value>
<Value name="4">
<Value>BTLevelType</Value>
</Value>
<Value name="5">
<Value>BTActDate</Value>
</Value>
<Value name="6">
<Value>BTActTime</Value>
</Value>
<Value name="7">
<Value>BTActUserID</Value>
</Value>
<Value name="8">
<Value>BTARCType</Value>
</Value>
<Value name="9">
<Value>BTARCID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.NoVarOrderD</DataLocation>
<DefaultData>NoVarOrderDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.NoVarOrderD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.NoVarOrderI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.NoVarOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
