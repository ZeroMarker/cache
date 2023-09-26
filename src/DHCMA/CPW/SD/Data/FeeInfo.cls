/// 描述: 单病种与费用相关的数据
Class DHCMA.CPW.SD.Data.FeeInfo Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 总费用
Property Fee1 As %String;

/// 住院总费用其中自付金额
Property Fee2 As %String;

/// 一般医疗服务费
Property Fee3 As %String;

/// 一般治疗操作费
Property Fee4 As %String;

/// 护理费
Property Fee5 As %String;

/// 综合医疗服务类其他费用
Property Fee6 As %String;

/// 病理诊断费 
Property Fee7 As %String;

/// 实验室诊断费 
Property Fee8 As %String;

/// 影像学诊断费
Property Fee9 As %String;

///  临床诊断项目费
Property Fee10 As %String;

///  非手术治疗项目费
Property Fee11 As %String;

///  其中：临床物理治疗费
Property Fee12 As %String;

///  手术治疗费
Property Fee13 As %String;

///  其中：麻醉费 
Property Fee14 As %String;

/// 其中：手术费 
Property Fee15 As %String;

/// 康复费 
Property Fee16 As %String;

/// 中医治疗费 
Property Fee17 As %String;

/// 西药费
Property Fee18 As %String;

/// 其中：抗菌药物费
Property Fee19 As %String;

/// 中成药费
Property Fee20 As %String;

/// 中草药费
Property Fee21 As %String;

/// 血费
Property Fee22 As %String;

/// 白蛋白类制品费
Property Fee23 As %String;

/// 球蛋白类制品费
Property Fee24 As %String;

/// 凝血因子类制品费
Property Fee25 As %String;

/// 细胞因子类制品费
Property Fee26 As %String;

/// 检查用一次性医用材料费
Property Fee27 As %String;

/// 治疗用一次性医用材料费 
Property Fee28 As %String;

/// 手术用一次性医用材料费 
Property Fee29 As %String;

/// 其他费  
Property Fee30 As %String;

Index IdxAdm On EpisodeID As Exact;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Data.FeeInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.FeeInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.FeeInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

ClassMethod GetFormatObjById(aId As %String) As DHCMA.CPW.SD.Data.FeeInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Data.FeeInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Data.FeeInfo).%OpenId(aId)
	//数据格式处理
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-05-20
/// Description:  更新费用记录
/// Table：       DHCMA.CPW.SD.Data.FeeInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.FeeInfo).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set EpisodeID= $p(aInputStr,aSeparete,1)
	Set Fee1	= $p(aInputStr,aSeparete,2)
	Set Fee2	= $p(aInputStr,aSeparete,3)
	Set Fee3	= $p(aInputStr,aSeparete,4)
	Set Fee4	= $p(aInputStr,aSeparete,5)
	Set Fee5	= $p(aInputStr,aSeparete,6)
	Set Fee6	= $p(aInputStr,aSeparete,7)
	Set Fee7	= $p(aInputStr,aSeparete,8)
	Set Fee8	= $p(aInputStr,aSeparete,9)
	Set Fee9	= $p(aInputStr,aSeparete,10)
	Set Fee10	= $p(aInputStr,aSeparete,11)
	Set Fee11	= $p(aInputStr,aSeparete,12)
	Set Fee12	= $p(aInputStr,aSeparete,13)
	Set Fee13	= $p(aInputStr,aSeparete,14)
	Set Fee14	= $p(aInputStr,aSeparete,15)
	Set Fee15	= $p(aInputStr,aSeparete,16)
	Set Fee16	= $p(aInputStr,aSeparete,17)
	Set Fee17	= $p(aInputStr,aSeparete,18)
	Set Fee18	= $p(aInputStr,aSeparete,19)
	Set Fee19	= $p(aInputStr,aSeparete,20)
	Set Fee20	= $p(aInputStr,aSeparete,21)
	Set Fee21	= $p(aInputStr,aSeparete,22)
	Set Fee22	= $p(aInputStr,aSeparete,23)
	Set Fee23	= $p(aInputStr,aSeparete,24)
	Set Fee24	= $p(aInputStr,aSeparete,25)
	Set Fee25	= $p(aInputStr,aSeparete,26)
	Set Fee26	= $p(aInputStr,aSeparete,27)
	Set Fee27	= $p(aInputStr,aSeparete,28)
	Set Fee28	= $p(aInputStr,aSeparete,29)
	Set Fee29	= $p(aInputStr,aSeparete,30)
	Set Fee30	= $p(aInputStr,aSeparete,31)
	Quit:(EpisodeID="") return
	Set ID=$o(^DHCMA.CPW.SD.Data.FeeInfoI("IdxAdm",EpisodeID,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Data.FeeInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.FeeInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	//写入数据
	Set obj.EpisodeID	=EpisodeID	
	Set obj.Fee1	= Fee1
	Set obj.Fee2	= Fee2
	Set obj.Fee3	= Fee3
	Set obj.Fee4	= Fee4
	Set obj.Fee5	= Fee5
	Set obj.Fee6	= Fee6
	Set obj.Fee7	= Fee7
	Set obj.Fee8	= Fee8
	Set obj.Fee9	= Fee9
	Set obj.Fee10	= Fee10
	Set obj.Fee11	= Fee11
	Set obj.Fee12	= Fee12
	Set obj.Fee13	= Fee13
	Set obj.Fee14	= Fee14
	Set obj.Fee15	= Fee15
	Set obj.Fee16	= Fee16
	Set obj.Fee17	= Fee17
	Set obj.Fee18	= Fee18
	Set obj.Fee19	= Fee19
	Set obj.Fee20	= Fee20
	Set obj.Fee21	= Fee21
	Set obj.Fee22	= Fee22
	Set obj.Fee23	= Fee23
	Set obj.Fee24	= Fee24
	Set obj.Fee25	= Fee25
	Set obj.Fee26	= Fee26
	Set obj.Fee27	= Fee27
	Set obj.Fee28	= Fee28
	Set obj.Fee29	= Fee29
	Set obj.Fee30	= Fee30      
	//检查Save是否成功
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

/// Description:  删除费用
/// Table：       DHCMA.CPW.SD.Data.FeeInfo
/// Input：       aId :  DHCMA.CPW.SD.Data.FeeInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.FeeInfo).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Data.FeeInfo).%DeleteId(aId)
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
<Data name="FeeInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>Fee1</Value>
</Value>
<Value name="4">
<Value>Fee2</Value>
</Value>
<Value name="5">
<Value>Fee3</Value>
</Value>
<Value name="6">
<Value>Fee4</Value>
</Value>
<Value name="7">
<Value>Fee5</Value>
</Value>
<Value name="8">
<Value>Fee6</Value>
</Value>
<Value name="9">
<Value>Fee7</Value>
</Value>
<Value name="10">
<Value>Fee8</Value>
</Value>
<Value name="11">
<Value>Fee9</Value>
</Value>
<Value name="12">
<Value>Fee10</Value>
</Value>
<Value name="13">
<Value>Fee11</Value>
</Value>
<Value name="14">
<Value>Fee12</Value>
</Value>
<Value name="15">
<Value>Fee13</Value>
</Value>
<Value name="16">
<Value>Fee14</Value>
</Value>
<Value name="17">
<Value>Fee15</Value>
</Value>
<Value name="18">
<Value>Fee16</Value>
</Value>
<Value name="19">
<Value>Fee17</Value>
</Value>
<Value name="20">
<Value>Fee18</Value>
</Value>
<Value name="21">
<Value>Fee19</Value>
</Value>
<Value name="22">
<Value>Fee20</Value>
</Value>
<Value name="23">
<Value>Fee21</Value>
</Value>
<Value name="24">
<Value>Fee22</Value>
</Value>
<Value name="25">
<Value>Fee23</Value>
</Value>
<Value name="26">
<Value>Fee24</Value>
</Value>
<Value name="27">
<Value>Fee25</Value>
</Value>
<Value name="28">
<Value>Fee26</Value>
</Value>
<Value name="29">
<Value>Fee27</Value>
</Value>
<Value name="30">
<Value>Fee28</Value>
</Value>
<Value name="31">
<Value>Fee29</Value>
</Value>
<Value name="32">
<Value>Fee30</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.FeeInfoD</DataLocation>
<DefaultData>FeeInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.FeeInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.FeeInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.FeeInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
