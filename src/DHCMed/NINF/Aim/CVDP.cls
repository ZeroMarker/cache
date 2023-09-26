/// 名称: DHCMed.NINF.Aim.CVDP
/// 描述: 中心静脉置管表
/// 编写者：ZGZ
/// 编写日期: 2012-04-12
Class DHCMed.NINF.Aim.CVDP Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 临床上报表ID
Property CRReportDR As %String(TRUNCATE = 1) [ Required ];

Index CRReportDR On CRReportDR [ Unique ];

/// 操作者
Property OpUserDR As %String(TRUNCATE = 1);

/// 置管日期
Property DPDate As %String(TRUNCATE = 1);

/// 置管时间
Property DPTime As %String(TRUNCATE = 1);

/// 现场核查员
Property CheckUserDR As %String(TRUNCATE = 1);

/// 导管类型
Property PipeType As %String(TRUNCATE = 1);

/// 导管长度
Property PipeLen As %String(TRUNCATE = 1);

/// CVP导管腔数
Property PipeCavities As %String(TRUNCATE = 1);

/// 是否为第一次置管
Property FirstDP As %String(TRUNCATE = 1);

/// 为左侧还是右侧置管
Property LOrRDP As %String(TRUNCATE = 1);

/// 导管安置位置
Property DPPos As %String(TRUNCATE = 1);

/// 为什么不选择锁骨下静脉
Property WhyNoSGXJM As %String(TRUNCATE = 1);

/// 留置中心静脉导管的原因
Property ReasonOfCVP As %String(TRUNCATE = 1);

/// 置管前手卫生情况
Property DPHandClear As %String(TRUNCATE = 1);

/// 使用了哪些防护工具
Property DefenceTools As %String(TRUNCATE = 1);

/// 置管时使用的皮肤消毒液
Property DPSkinDrug As %String(TRUNCATE = 1);

/// Creator：    ZGZ
/// CreatDate：   2012-04-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Aim.CVDP
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CRReportDR_separete
	set return=return_..OpUserDR _separete
	set return=return_..DPDate_separete
	set return=return_..DPTime_separete
	set return=return_..CheckUserDR_separete
	set return=return_..PipeType_separete
	set return=return_..PipeLen_separete
	set return=return_..PipeCavities_separete
	set return=return_..FirstDP_separete
	set return=return_..LOrRDP_separete
	set return=return_..DPPos_separete
	set return=return_..WhyNoSGXJM_separete
	set return=return_..ReasonOfCVP_separete
	set return=return_..DPHandClear_separete
	set return=return_..DefenceTools_separete
	set return=return_..DPSkinDrug

	quit return
}

/// Creator：     ZGZ
/// CreatDate：   2012-04-12
/// Description:  根据ID取中心静脉置管表对象
/// Table：       DHCMed.NINF.Aim.CVDP
/// Input：       ID:    DHCMed.NINF.Aim.CVDP.ID
///               separete: 指定的分隔符
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Aim.CVDP).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.CVDP
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.CVDP).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.CVDP).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ZGZ
/// CreatDate：   2012-04-12
/// Description:  根据ID取中心静脉置管表对象
/// Table：       DHCMed.NINF.Aim.CVDP
/// Input：       id: DHCMed.NINF.Aim.CVDP.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Aim.CVDP).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     ZGZ
/// CreatDate：   2012-04-12
/// Description:  更新中心静脉置管表对象
/// Table：       DHCMed.NINF.Aim.CVDP
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// d ##class(DHCMed.NINF.Aim.CVDP).Update(^2^3^4^^^^^^)
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.CVDP).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.CVDP).%OpenId(ID)
		}
	set obj.CRReportDR=$p(InStr,"^",2)
	set obj.OpUserDR  =$p(InStr,"^",3)
	set obj.DPDate =$p(InStr,"^",4)
	set obj.DPTime =$p(InStr,"^",5)
	set obj.CheckUserDR =$p(InStr,"^",6)
	set obj.PipeType =$p(InStr,"^",7)
	set obj.PipeLen =$p(InStr,"^",8)
	set obj.PipeCavities =$p(InStr,"^",9)
	set obj.FirstDP =$p(InStr,"^",10)
	set obj.LOrRDP =$p(InStr,"^",11)
	set obj.DPPos =$p(InStr,"^",12)
	set obj.WhyNoSGXJM =$p(InStr,"^",13)
	set obj.ReasonOfCVP =$p(InStr,"^",14)
	set obj.DPHandClear =$p(InStr,"^",15)
	set obj.DefenceTools =$p(InStr,"^",16)
	set obj.DPSkinDrug =$p(InStr,"^",17)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：    ZGZ
/// CreatDate：   2012-04-12
/// Description:  删除中心静脉置管表对象
/// Table：       DHCMed.NINF.Aim.CVDP
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Aim.CVDP).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// w ##class(DHCMed.NINF.Aim.CVDP).UpdateDataFromEPR("56")
ClassMethod UpdateDataFromEPR(CRReportDR As %String) As %String
{
	n (CRReportDR)
	
	s ret=-1
	q:(CRReportDR="") ret
	s RepID=""
	i $d(^DHCMed.NINF.Aim.CVDPI("CRReportDR"," "_CRReportDR)) d
	.s RepID=$o(^DHCMed.NINF.Aim.CVDPI("CRReportDR"," "_CRReportDR,""),-1)
	
	s objCRReport=##class(DHCMed.CR.Report).%OpenId(CRReportDR)
	q:'$IsObject(objCRReport)
	s EpisodeID=objCRReport.EpisodeID
	s InstanceDataID=objCRReport.InstanceID
	q:(EpisodeID="")||(InstanceDataID="") ret
	
	
	s tmp = RepID
	s tmp = tmp _ "^" _ CRReportDR	
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"操作者S0003#TYPE:Simple#TID:657#TVER:0#SCODE:S0003#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"置管日期及时间D0004#TYPE:Simple#TID:657#TVER:0#SCODE:D0004#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"现场核查员S0005#TYPE:Simple#TID:657#TVER:0#SCODE:S0005#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"导管的类型M0006#TYPE:Simple#TID:657#TVER:0#SCODE:M0006#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"导管长度S0007#TYPE:Simple#TID:657#TVER:0#SCODE:S0007#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"选择中心静脉导管腔数M0008#TYPE:Simple#TID:657#TVER:0#SCODE:M0008#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"这是病人第一次安置中心静脉置管吗M0009#TYPE:Simple#TID:657#TVER:0#SCODE:M0009#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"置管位置是病人左侧还是右侧M0010#TYPE:Simple#TID:657#TVER:0#SCODE:M0010#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"导管安置的部位是M0011#TYPE:Simple#TID:657#TVER:0#SCODE:M0011#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"为什么不选择锁骨下静脉M0012#TYPE:Simple#TID:657#TVER:0#SCODE:M0012#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"留置中心静脉导管的指针是什么M0013#TYPE:Simple#TID:657#TVER:0#SCODE:M0013#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"置管前是否进行了手卫生M0014#TYPE:Simple#TID:657#TVER:0#SCODE:M0014#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"使用下列哪些防护用品M0015#TYPE:Simple#TID:657#TVER:0#SCODE:M0015#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"置管时使用下列哪种皮肤消毒剂M0016#TYPE:Simple#TID:657#TVER:0#SCODE:M0016#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"其他1S0017#TYPE:Simple#TID:657#TVER:0#SCODE:S0017#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"其他2S0021#TYPE:Simple#TID:657#TVER:0#SCODE:S0021#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"其他3S0018#TYPE:Simple#TID:657#TVER:0#SCODE:S0018#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"其他4S0019#TYPE:Simple#TID:657#TVER:0#SCODE:S0019#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"其他5S0020#TYPE:Simple#TID:657#TVER:0#SCODE:S0020#VTYPE:V",InstanceDataID)
	s ret=..Update(tmp)
	
	q ret
}

ClassMethod GetDataFromEPR(EpisodeID As %String, ItemPara As %String, InstanceDataID As %String) As %String
{
	n (EpisodeID, ItemPara ,InstanceDataID)
	
	s ret=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, ItemPara ,InstanceDataID)
	
	q ret
}

Storage Default
{
<Data name="CVDPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckUserDR</Value>
</Value>
<Value name="3">
<Value>DPDate</Value>
</Value>
<Value name="4">
<Value>DPHandClear</Value>
</Value>
<Value name="5">
<Value>DPPos</Value>
</Value>
<Value name="6">
<Value>DPSkinDrug</Value>
</Value>
<Value name="7">
<Value>DPTime</Value>
</Value>
<Value name="8">
<Value>DefenceTools</Value>
</Value>
<Value name="9">
<Value>FirstDP</Value>
</Value>
<Value name="10">
<Value>LOrRDP</Value>
</Value>
<Value name="11">
<Value>OpUserDR</Value>
</Value>
<Value name="12">
<Value>PaadmDR</Value>
</Value>
<Value name="13">
<Value>PipeLen</Value>
</Value>
<Value name="14">
<Value>PipeType</Value>
</Value>
<Value name="15">
<Value>ReasonOfCVP</Value>
</Value>
<Value name="16">
<Value>WhyNoSGXJM</Value>
</Value>
<Value name="17">
<Value>InstanceDataID</Value>
</Value>
<Value name="18">
<Value>PipeCavities</Value>
</Value>
<Value name="19">
<Value>CRReportDR</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.CVDPD</DataLocation>
<DefaultData>CVDPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.CVDPD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.CVDPI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.CVDPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
