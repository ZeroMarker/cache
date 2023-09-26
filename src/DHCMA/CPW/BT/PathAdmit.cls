/// 名称: DHCMA.CPW.BT.PathAdmit
/// 描述: 临床路径 准入标准
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathAdmit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildOrd As DHCMA.CPW.BT.PathAdmitOrds [ Cardinality = children, Inverse = Parref ];

/// 路径指针
Property BTPathDr As DHCMA.CPW.BT.PathMast [ Required ];

/// 类型（诊断、手术、中医诊断）
Property BTTypeDr As DHCMA.Util.BT.Dictionary;

/// 准入诊断ICD（格式：A01.0 或 A01.3-A09）
Property BTICD10 As %String(MAXLEN = 50, TRUNCATE = 1);

/// 准入诊断关键词
Property BTICDKeys As %String(MAXLEN = 100, TRUNCATE = 1);

/// 准入手术ICD（格式：01.2 或 02.2-02.9）
Property BTOperICD As %String(MAXLEN = 50, TRUNCATE = 1);

/// 准入手术关键词
Property BTOperKeys As %String(MAXLEN = 50, TRUNCATE = 1);

/// 中医诊断与西医诊断组合（同时符合）
Property BTIsICDAcc As %Boolean;

/// 诊断与手术组合（同时符合）
Property BTIsOperAcc As %Boolean;

/// 有效标志
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofPathType On (BTPathDr, BTTypeDr);

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathAdmit
/// Input：       aId : DHCMA.CPW.BT.PathAdmit.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathAdmit
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathAdmit).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathAdmit).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathAdmit
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathAdmit).Update("^1^^J45-J46m^^^^0^0^1^^^9!!1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aUserID As %String = "") As %String
{
	New (aInputStr,aSeparete,aUserID,%session)
	Set return=0
	Quit:aInputStr="" return
	
	Set:(aUserID="")&&($d(%session)) aUserID=$g(%session.Data("DHCMA.USERID"))
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID			 = $p(aInputStr,aSeparete,1)
	Set BTPathDr     = $p(aInputStr,aSeparete,2)
	Set BTTypeDr     = $p(aInputStr,aSeparete,3)	
	Set BTICD10      = $p(aInputStr,aSeparete,4)	
	Set BTICDKeys    = $p(aInputStr,aSeparete,5)	
	Set BTOperICD    = $p(aInputStr,aSeparete,6)	
	Set BTOperKeys   = $p(aInputStr,aSeparete,7)	
	Set BTIsICDAcc   = $p(aInputStr,aSeparete,8)	
	Set BTIsOperAcc  = $p(aInputStr,aSeparete,9)
	Set BTIsActive   = +$p(aInputStr,aSeparete,10)
	Set BTActDate    = $p(aInputStr,aSeparete,11)
	Set BTActTime	 = $p(aInputStr,aSeparete,12)
	Set BTActUserID  = $p(aInputStr,aSeparete,13)
	
	
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=$p($h,",",2)
	//||(BTTypeDr="")
	Quit:(BTPathDr="") -1
	Set objPathMast = ##class(DHCMA.CPW.BT.PathMast).GetObjById(BTPathDr)
	Set objBTType   =##class(DHCMA.Util.BT.Dictionary).GetObjById(BTTypeDr)
	//||('$Isobject(objBTType))
	Quit:('$Isobject(objPathMast)) -1
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.BT.PathAdmit).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathAdmit).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTPathDr	 = objPathMast
	Set obj.BTTypeDr	 = objBTType  //对象
	Set obj.BTICD10      = $tr(BTICD10,"，",",")
	Set obj.BTICDKeys	 = $tr(BTICDKeys,"，",",")
	Set obj.BTOperICD	 = $tr(BTOperICD,"，",",")
	Set obj.BTOperKeys   = $tr(BTOperKeys,"，",",")
	Set obj.BTIsICDAcc   = BTIsICDAcc
	Set obj.BTIsOperAcc	 = BTIsOperAcc
	Set obj.BTIsActive   = BTIsActive
	Set obj.BTActDate    = BTActDate
	Set obj.BTActTime    = BTActTime
	Set obj.BTActUserID  = BTActUserID
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Do:+return>0 ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser("DHCMA.CPW.BT.PathAdmit",return,aUserID)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathAdmit
/// Input：       aId : DHCMA.CPW.BT.PathAdmit.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathAdmit).DeleteById(1)
ClassMethod DeleteById(aId As %String, aUserID As %String = "") As %String
{
	New (aId, aUserID, %session)
	
	Set:(aUserID="")&&($d(%session)) aUserID=$g(%session.Data("DHCMA.USERID"))
	Set sc = ##class(DHCMA.CPW.BT.PathAdmit).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		Do ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser("DHCMA.CPW.BT.PathAdmit",aId,aUserID)
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
		If {BTPathDr*C}=1{			// 路径指针
			Set oldVal={BTPathDr*O},newVal={BTPathDr*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTPathDr",:oldVal,:newVal) )		
		}
		If {BTTypeDr*C}=1{			// 类型（诊断、手术、中医诊断）
			Set oldVal={BTTypeDr*O},newVal={BTTypeDr*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTTypeDr",:oldVal,:newVal) )		
		}
		If {BTICD10*C}=1{			// 准入诊断ICD
			Set oldVal={BTICD10*O},newVal={BTICD10*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTICD10",:oldVal,:newVal) )		
		}
		If {BTICDKeys*C}=1{			// 准入诊断关键词
			Set oldVal={BTICDKeys*O},newVal={BTICDKeys*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTICDKeys",:oldVal,:newVal) )		
		}
		If {BTOperICD*C}=1{			// 准入手术ICD
			Set oldVal={BTOperICD*O},newVal={BTOperICD*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTOperICD",:oldVal,:newVal) )		
		}
		If {BTOperKeys*C}=1{			// 准入手术关键词
			Set oldVal={BTOperKeys*O},newVal={BTOperKeys*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTOperKeys",:oldVal,:newVal) )		
		}
		If {BTIsICDAcc*C}=1{			// 中医诊断与西医诊断组合（同时符合）
			Set oldVal={BTIsICDAcc*O},newVal={BTIsICDAcc*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTIsICDAcc",:oldVal,:newVal) )		
		}
		If {BTIsOperAcc*C}=1{			// 诊断与手术组合（同时符合）
			Set oldVal={BTIsOperAcc*O},newVal={BTIsOperAcc*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTIsOperAcc",:oldVal,:newVal) )		
		}
		If {BTIsActive*C}=1{			// 有效标志
			Set oldVal={BTIsActive*O},newVal={BTIsActive*N}
			&sql(INSERT INTO DHCMA_CPW_LOG.LogTableExt(Parref,ProperName,OldValue,NewValue) VALUES (:LogID,"BTIsActive",:oldVal,:newVal) )		
		}
	}
	
	Quit %ok
}

Storage Default
{
<Data name="PathAdmitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTPathDr</Value>
</Value>
<Value name="3">
<Value>BTTypeDr</Value>
</Value>
<Value name="4">
<Value>BTICD10</Value>
</Value>
<Value name="5">
<Value>BTICDKeys</Value>
</Value>
<Value name="6">
<Value>BTOperICD</Value>
</Value>
<Value name="7">
<Value>BTOperKeys</Value>
</Value>
<Value name="8">
<Value>BTIsICDAcc</Value>
</Value>
<Value name="9">
<Value>BTIsOperAcc</Value>
</Value>
<Value name="10">
<Value>BTIsActive</Value>
</Value>
<Value name="11">
<Value>BTActDate</Value>
</Value>
<Value name="12">
<Value>BTActTime</Value>
</Value>
<Value name="13">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathAdmitD</DataLocation>
<DefaultData>PathAdmitDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathAdmitD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathAdmitI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathAdmitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
