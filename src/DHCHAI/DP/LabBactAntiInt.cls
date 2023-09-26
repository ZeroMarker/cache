/// 名称: DHCHAI.DP.LabBactAntiInt
/// 描述: 细菌天然耐药数据
/// 编写者：pylian
/// 编写日期: 2021-03-22
Class DHCHAI.DP.LabBactAntiInt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 标准细菌名称
Property BTBactDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 标准细菌
Property BTBactDr As DHCHAI.DP.LabBacteria;

/// 细菌天然耐药名称
Property BTAntiDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 标准细菌天然耐药
Property BTAntiDr As DHCHAI.DP.LabAntibiotic;

/// 有效标志
Property BTIsActive As %Boolean;

/// 备注
Property BTNote As %String(MAXLEN = 100, TRUNCATE = 1);

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 索引
Index IndexBactAntDesc On (BTBactDesc As Exact, BTAntiDesc As Exact);

/// 索引
Index IndexBactAntDr On (BTBactDr As Exact, BTAntiDr As Exact);

/// Creator：     pylian
/// CreatDate：   2021-03-22
/// Description:  根据ID取细菌天然耐药
/// Table：       DHCHAI.DP.LabBactAntiInt
/// Input：       ID:    DHCHAI.DP.LabBactAntiInt.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabBactAntiInt).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabBactAntiInt
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabBactAntiInt).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabBactAntiInt).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-03-22
/// Description:  更新细菌天然耐药
/// Table：       DHCHAI.DP.LabBactAntiInt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabBactAntiInt).Update("^粘质沙雷菌粘质亚种^814^氨苄西林^9^1^CLSI","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(aInputStr,aSeparete,1)
	Set BactDesc	= $p(aInputStr,aSeparete,2)
	Set BactDr	    = $p(aInputStr,aSeparete,3)
	Set AntDesc		= $p(aInputStr,aSeparete,4)
	Set AntDr	    = $p(aInputStr,aSeparete,5)
	Set IsActive	= +$p(aInputStr,aSeparete,6)
	Set Note	    = $p(aInputStr,aSeparete,7)
	Set ActDate		= $p(aInputStr,aSeparete,8)
	Set ActTime		= $p(aInputStr,aSeparete,9)
	Quit:(BactDr="")||(BactDesc="")||(AntDr="")||(AntDesc="") return

	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set objAnt = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(AntDr)
	Quit:'$IsObject(objAnt) return
	Set objBact = ##class(DHCHAI.DP.LabBacteria).GetObjById(BactDr)
	Quit:'$IsObject(objBact) return
	
	//细菌名称+抗生素名称 唯一性
	Set tID =$o(^CT.MA.HAI.DP.LabBactAntiIntI("IndexBactAntDesc",BactDesc,AntDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -2
	If ID="" {
		Set obj=##class(DHCHAI.DP.LabBactAntiInt).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabBactAntiInt).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTBactDesc	= BactDesc
	Set obj.BTBactDr	= objBact	
	Set obj.BTAntiDesc	= AntDesc	
	Set obj.BTAntiDr	= objAnt	
	Set obj.BTIsActive	= IsActive
	Set obj.BTNote   	= Note
	Set obj.BTActDate	= ActDate	
	Set obj.BTActTime	= ActTime	
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-03-22
/// Description:  删除细菌天然耐药
/// Table：       DHCHAI.DP.LabBactAntiInt
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.LabBactAntiInt")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.LabBactAntiInt).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2021-03-22
/// Description:  细菌天然耐药
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(DHCHAI.DP.LabBactAntiInt).ImportBactAnt("粘质沙雷菌粘质亚种^氨苄西林^CLSI","^")
ClassMethod ImportBactAnt(aInStr As %String, aSeparate As %String) As %String
{
	New (aInStr,aSeparate)
	Set return = ""
	Quit:(aInStr="")||(aSeparate="") return
	
	Set BactDr = ""
	Set BactDesc	= $p(aInStr,aSeparate,1)
	Quit:(BactDesc="") return
	Set objBact     = ##class(DHCHAI.DP.LabBacteria).GetObjByCodeDesc("",BactDesc)
	Set:$isobject(objBact) BactDr = objBact.%Id()
	
	Set AntDr = ""
	Set AntDesc	= $p(aInStr,aSeparate,2)
	Quit:(AntDesc="") return
	Set objAnt    = ##class(DHCHAI.DP.LabAntibiotic).GetObjByCodeDesc("",AntDesc)
	Set:$isobject(objAnt) AntDr = objAnt.%Id()
	
	Set ID=$o(^CT.MA.HAI.DP.LabBactAntiIntI("IndexBactAntDesc",BactDesc,AntDesc,0)) 
	Set InStr=""
	Set $p(InStr,aSeparate,1)=ID
	Set $p(InStr,aSeparate,2)=BactDesc
	Set $p(InStr,aSeparate,3)=BactDr
	Set $p(InStr,aSeparate,4)=AntDesc
	Set $p(InStr,aSeparate,5)=AntDr
	Set $p(InStr,aSeparate,6)=1
	Set $p(InStr,aSeparate,7)=$p(aInStr,aSeparate,3)

	Set return = ..Update(InStr,aSeparate)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTBactDesc</Value>
</Value>
<Value name="3">
<Value>BTBactDr</Value>
</Value>
<Value name="4">
<Value>BTAntiDesc</Value>
</Value>
<Value name="5">
<Value>BTAntiDr</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTNote</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.DP.LabBactAntiIntD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.DP.LabBactAntiIntD</IdLocation>
<IndexLocation>^CT.MA.HAI.DP.LabBactAntiIntI</IndexLocation>
<StreamLocation>^CT.MA.HAI.DP.LabBactAntiIntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
