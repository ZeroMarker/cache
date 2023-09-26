/// 名称: DHCHAI.IR.CCWarnLine
/// 描述: 爆发预警阀值表()的业务封装，定义常用属性和方法
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CCWarnLine Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 发热人数阀值	CW_ItemNum1  %Float
Property CWItemNum1 As %Float;

/// 便常规送检阀值	CW_ItemNum2
Property CWItemNum2 As %Float;

/// 泌尿道插管阀值	CW_ItemNum3
Property CWItemNum3 As %Float;

/// 呼吸机使用阀值	CW_ItemNum4
Property CWItemNum4 As %Float;

/// 中心静脉置管阀值	CW_ItemNum5
Property CWItemNum5 As %Float;

/// 同种同源菌阀值	CW_ItemNum6
Property CWItemNum6 As %Float;

/// 同科同感染部位阀值	CW_ItemNum7
Property CWItemNum7 As %Float;

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  将对象格式化为字符串
/// Table：       DHCHAI.IR.CCWarnLine
/// Input：       aSeparete:指定的分隔符 
/// Return：      返回各属性值，按照aSeparete分隔
///               1 RowId 2 CWItemNum1 3 CWItemNum2 4 CWItemNum3 5 CWItemNum4 6 CWItemNum5 7 CWItemNum6 8 CWItemNum7
Method ToString(aSeparete As %String) As %String
{
	if $g(aSeparete)=""{
		set aSeparete=..#SEPARATE
		} 
    set return=..%Id()_aSeparete_..CWItemNum1_aSeparete_..CWItemNum2_aSeparete_..CWItemNum3_aSeparete_..CWItemNum4_aSeparete_..CWItemNum5_aSeparete_..CWItemNum6_aSeparete_..CWItemNum7
	quit return
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据RowId取信息
/// Table：       DHCHAI.IR.CCWarnLine
/// Input：       RowID    DHCHAI.IR.CCWarnLine
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(RowId As %String) As DHCHAI.IR.CCWarnLine
{
	new (RowId)
	set return=""
	quit:RowId="" return
	quit:'$d(^DHCHAI.IR.CCWarnLineD(+RowId)) return
	set obj=##Class(DHCHAI.IR.CCWarnLine).%OpenId(+RowId)
	quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据RowId医院信息
/// Table：       DHCHAI.IR.CCWarnLine
/// Input：       rowid:    DHCHAI.IR.CCWarnLine
///               aSeparete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCHAI.IR.CCWarnLine).GetStringById(1)
ClassMethod GetStringById(rowId As %String, aSeparete As %String) As %String
{
	new (rowId,aSeparete)
	set return=""
	set obj=..GetObjById(rowId)
	if $IsObject(obj){
		set return=obj.ToString($g(aSeparete))
	}	
	quit return
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新
/// Table：       DHCHAI.IR.CCWarnLine
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1 RowId 2 CIEpisodeDr 3 CIMsgType 4 CIMsgDate 5 CIMsgTime 6 CIMsgUserDr 7 CCIOpinion 
/// w ##class(DHCHAI.IR.CCWarnLine).Update("^1^1^1^1^2017-01-16^11:33^1^处置意见^1^2017-01-17^11:43^1^反馈意见","")
ClassMethod Update(InStr As %String, aSeparete As %String) As %String
{
	 
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID=$p(InStr,aSeparete,1)
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCWarnLine).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCWarnLine).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.CWItemNum1=+$p(InStr,aSeparete,2)
	Set obj.CWItemNum2=+$p(InStr,aSeparete,3)
	set obj.CWItemNum3=+$p(InStr,aSeparete,4)
	set obj.CWItemNum4 =+$p(InStr,aSeparete,5)
	set obj.CWItemNum5 =+$p(InStr,aSeparete,6)
	set obj.CWItemNum6 =+$p(InStr,aSeparete,7)
	set obj.CWItemNum7 =+$p(InStr,aSeparete,8)
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

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除
/// Table：       DHCHAI.IR.CCWarnLine
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCHAI.IR.CCWarnLine).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="CCWarnLineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CWItemNum1</Value>
</Value>
<Value name="3">
<Value>CWItemNum2</Value>
</Value>
<Value name="4">
<Value>CWItemNum3</Value>
</Value>
<Value name="5">
<Value>CWItemNum4</Value>
</Value>
<Value name="6">
<Value>CWItemNum5</Value>
</Value>
<Value name="7">
<Value>CWItemNum6</Value>
</Value>
<Value name="8">
<Value>CWItemNum7</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCWarnLineD</DataLocation>
<DefaultData>CCWarnLineDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCWarnLineD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCWarnLineI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCWarnLineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
