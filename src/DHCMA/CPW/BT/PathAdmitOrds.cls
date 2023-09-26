Class DHCMA.CPW.BT.PathAdmitOrds Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathAdmit [ Cardinality = parent, Inverse = ChildOrd ];

/// ORC/MRC的id
Property OrdMORcID As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 诊断ICD
Property OrdIcd As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 诊断(M)/手术(O)
Property OrdType As %String(DISPLAYLIST = "MDIAG,OPER,", VALUELIST = ",M,O");

Index IdxofParrType On (Parref, OrdType);

/// Creator：     zqy
/// CreatDate：   2022-3-29
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathAdmitOrds
/// Input：       aId : DHCMA.CPW.BT.PathAdmit.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathAdmitOrds
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathAdmitOrds).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathAdmitOrds).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2022-3-29
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathAdmitOrds
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathAdmitOrds).Update("18^^4878,5766,^F01.100,G43.801,")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aUserID As %String = "") As %String
{
	New (aInputStr,aSeparete,aUserID,%session)
	Set return=0
	Quit:aInputStr="" return
	
	Set:(aUserID="")&&($d(%session)) aUserID=$g(%session.Data("DHCMA.USERID"))
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		 = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set:ChildSub["||" ChildSub= $p(ChildSub,"||",2)
	Set OrdMORcID    = $p(aInputStr,aSeparete,3)
	Set OrdIcd       = $p(aInputStr,aSeparete,4)
	Set OrdType      = $p(aInputStr,aSeparete,5)
	
	Quit:(Parref="") -1
	Set objPathAdmit = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(Parref)
	Quit:'$Isobject(objPathAdmit) -1
	If $d(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," "_OrdType)) {
		Set ChildSub=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," "_OrdType,0))
	}
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.BT.PathAdmitOrds).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.BT.PathAdmitOrds).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objPathAdmit  //对象
	Set obj.OrdMORcID	 = OrdMORcID  
	Set obj.OrdIcd  	 = OrdIcd
	Set obj.OrdType  	 = OrdType
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=$p(obj.%Id(),"||",2)
	}
	Do obj.%Close()
	
	Do:+return>0 ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser("DHCMA.CPW.BT.PathAdmitOrds",obj.%Id(),aUserID)
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-3-28
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathAdmitOrds
/// Input：       aId : DHCMA.CPW.BT.PathAdmitOrds.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathAdmitOrds).DeleteById("1||1")
ClassMethod DeleteById(aId As %String, aUserID As %String = "") As %String
{
	New (aId,aUserID,%session)
	
	Set:(aUserID="")&&($d(%session)) aUserID=$g(%session.Data("DHCMA.USERID"))
	Set sc = ##class(DHCMA.CPW.BT.PathAdmitOrds).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		Do ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser("DHCMA.CPW.BT.PathAdmitOrds",aId,aUserID)
	}
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-07-18
/// Description:  使用触发器记录日志
Trigger LogTrigger [ Event = INSERT/UPDATE/DELETE, Foreach = row/object ]
{
	//get row id of inserted row
	New id,className,tableName,operType,OrdMastID,Date,Time,UserID
	
	Set id = {%%ID}
	Set className={%%CLASSNAMEQ}
	Set tableName={%%TABLENAME}
	Set operType={%%OPERATION}
	Set operType=$case(operType,"INSERT":"I","UPDATE":"U","DELETE":"D")
	Set Date=+$h
	Set Time=$p($h,",",2)
	Set UserID=""
	
	Set strUpdate="^"_className_"^"_tableName_"^"_operType_"^"_id_"^"_Date_"^"_Time_"^"_UserID
	Set LogID=##class(DHCMA.CPW.LOG.LogTable).Update(strUpdate,"^")
	
	If (+LogID>0)&&((operType="U")||(operType="D")) {		//增加不用记录
		If {OrdMORcID*C}=1{			// ORC或MRC的id
			Set oldVal={OrdMORcID*O},newVal={OrdMORcID*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdMORcID",:oldVal,:newVal) )		
		}
		If {OrdIcd*C}=1{			// 诊断ICD
			Set oldVal={OrdIcd*O},newVal={OrdIcd*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdIcd",:oldVal,:newVal) )		
		}
		If {OrdType*C}=1{			// 诊断(M)或手术(O)
			Set oldVal={OrdType*O},newVal={OrdType*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"OrdType",:oldVal,:newVal) )		
		}

	}
	
	Quit %ok
}

Storage Default
{
<Data name="PathAdmitOrdsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrdMORcID</Value>
</Value>
<Value name="3">
<Value>OrdIcd</Value>
</Value>
<Value name="4">
<Value>OrdType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ORD")</DataLocation>
<DefaultData>PathAdmitOrdsDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ORD")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathAdmit("ORD")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathAdmitOrdsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
