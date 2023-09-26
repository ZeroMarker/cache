/// 名称: DHCMA.CPW.KB.PathBase
/// 描述: 知识库-国家路径字典库（公有数据）
/// 编写者：yankai
/// 编写日期: 2022-05-11
Class DHCMA.CPW.KB.PathBase Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 变异描述分析
Relationship ChildVarRsn As DHCMA.CPW.KB.PathVarRsn [ Cardinality = children, Inverse = Parref ];

/// 路径阶段
Relationship ChildStg As DHCMA.CPW.KB.PathStage [ Cardinality = children, Inverse = Parref ];

/// 路径代码（发布年份+四位序号+两位分型） 
Property PBCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 路径名称
Property PBDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 专科类型（存类型描述）
Property PBType As %String [ Required ];

/// 病种名称
Property PBDiseEtyName As %String;

/// 是否手术路径
Property PBIsOper As %Boolean;

/// 有效标志/是否启用 
Property PBIsActive As %Boolean;

/// 发布类型（General:常规版；County:县医院版）
Property PBPubType As %String(DISPLAYLIST = "General,County", VALUELIST = ",G,C");

/// 发布年份
Property PBPubYear As %String;

/// 准入诊断ICD（格式：A01.0 或 A01.3-A09）
Property PBICD10 As %String(MAXLEN = 50, TRUNCATE = 1);

/// 准入诊断关键词
Property PBICDKeys As %String(MAXLEN = 100, TRUNCATE = 1);

/// 准入手术ICD（格式：01.2 或 02.2-02.9）
Property PBOperICD As %String(MAXLEN = 50, TRUNCATE = 1);

/// 准入手术关键词
Property PBOperKeys As %String(MAXLEN = 50, TRUNCATE = 1);

/// 适用对象
Property PBSuitInfo As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 进入路径标准
Property PBInPathStd As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 参考时间
Property PBPathTime As %String;

/// 参考时间单位（D:天,T:次,W:周,MTH:月）
Property PBPathTimeUnit As %String(DISPLAYLIST = "Day,Time,Week,Month", VALUELIST = ",D,T,W,MTH");

/// 就诊类型（住院路径：In，门诊路径：Out)
Property PBAdmType As %String(DISPLAYLIST = "Out,In", VALUELIST = ",O,I");

/// pdf文件存储路径
Property PBPDFPath As %String(MAXLEN = 500, TRUNCATE = 1);

/// 操作日期
Property PBActDate As %Date;

/// 操作时间
Property PBActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property PBActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofCode On PBCode [ Unique ];

Index IdxofType On PBType;

Index IdxofPubType On PBPubType;

Index IdxofPubYear On PBPubYear;

/// Creator：     yankai
/// CreatDate：   2022-05-11
/// Description:  根据ID取临床路径字典字典信息
/// Table：       DHCMA.CPW.KB.PathBase
/// Input：       aId :  DHCMA.CPW.KB.PathBase.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.KB.PathBase).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.KB.PathBase
{
	New (aId)
	Quit:'##class(DHCMA.CPW.KB.PathBase).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.KB.PathBase).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-05-11
/// Description:  更新路径字典库信息
/// Table：       DHCMA.CPW.KB.PathBase
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathBase).Update("^t3^评估字典^0^0^0^0^1^2018-02-03^8:00^8")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=-1
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID      	    = 	$p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set Code     		= 	$p(aInputStr,aSeparete,2)
	Set Desc    		= 	$p(aInputStr,aSeparete,3)
	Set Type  			= 	$p(aInputStr,aSeparete,4)
	Set DiseEty  		= 	$p(aInputStr,aSeparete,5)
	Set IsOper			=	+$p(aInputStr,aSeparete,6)
	Set IsActive    	=  	+$p(aInputStr,aSeparete,7)
	Set PubType 		= 	$p(aInputStr,aSeparete,8)
	Set PubYear			= 	$p(aInputStr,aSeparete,9)
	Set ICD10			= 	$p(aInputStr,aSeparete,10)
	Set ICDKeys			= 	$p(aInputStr,aSeparete,11)
	Set OperICD			= 	$p(aInputStr,aSeparete,12)
	Set OperKeys		= 	$p(aInputStr,aSeparete,13)
	Set SuitInfo		= 	$p(aInputStr,aSeparete,14)
	Set InPathStd		= 	$p(aInputStr,aSeparete,15)
	Set PathTime		= 	$p(aInputStr,aSeparete,16)
	Set PathTimeUnit	= 	$p(aInputStr,aSeparete,17)
	Set:PathTimeUnit="" PBPathTimeUnit="D"
	Set AdmType			= 	$p(aInputStr,aSeparete,18)
	Set:AdmType="" AdmType="I"
	Set PDFPath			= 	$p(aInputStr,aSeparete,19)
	Set ActDate			= 	$p(aInputStr,aSeparete,20)
	Set:ActDate="" ActDate = +$h
	Set ActTime			= 	$p(aInputStr,aSeparete,21) 
	Set:ActTime="" ActTime = $p($h,",",2)
	Set ActUserID 		= 	$p(aInputStr,aSeparete,22)

	Set tID=$o(^CT.MA.CPW.KB.PathBaseI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                //根据代码找ID,如果id对不上号 返回-2（这是因为code唯一，应该是更新时遇到code id不对等）
	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.KB.PathBase).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.KB.PathBase).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.PBCode    		= Code      //写入数据
	Set obj.PBDesc    		= Desc
	Set obj.PBType			= Type
	Set obj.PBDiseEtyName 	= DiseEty
	Set obj.PBIsOper		= IsOper
	Set obj.PBIsActive		= IsActive
	Set obj.PBPubType 		= PubType
	Set obj.PBPubYear 		= PubYear
	Set obj.PBSuitInfo		= SuitInfo
	Set obj.PBInPathStd		= InPathStd
	Set obj.PBPathTime		= PathTime
	Set obj.PBPathTimeUnit	= PathTimeUnit
	Set obj.PBAdmType		= AdmType
	Set obj.PBPDFPath		= PDFPath
	Set obj.PBActDate   	= ActDate
	Set obj.PBActTime   	= ActTime
	Set obj.PBActUserID 	= ActUserID
	Set obj.PBICD10			= ICD10
	Set obj.PBICDKeys		= ICDKeys
	Set obj.PBOperICD		= OperICD
	Set obj.PBOperKeys		= OperKeys
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

/// Creator：     yankai
/// CreatDate：   2022-05-11
/// Description:  删除路径字典库信息
/// Table：       DHCMA.CPW.KB.PathBase
/// Input：       aId :  DHCMA.CPW.KB.PathBase.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathBase).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.KB.PathBase")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.KB.PathBase).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-19
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.CPW.KB.PathBase
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.KB.PathBase).CheckPTCode("t3")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^CT.MA.CPW.KB.PathBaseI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^CT.MA.CPW.KB.PathBaseI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

Storage Default
{
<Data name="PathBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PBCode</Value>
</Value>
<Value name="3">
<Value>PBDesc</Value>
</Value>
<Value name="4">
<Value>PBTypeDr</Value>
</Value>
<Value name="5">
<Value>PBDiseEtyName</Value>
</Value>
<Value name="6">
<Value>PBIsOper</Value>
</Value>
<Value name="7">
<Value>PBIsActive</Value>
</Value>
<Value name="8">
<Value>PBPubType</Value>
</Value>
<Value name="9">
<Value>PBPubYear</Value>
</Value>
<Value name="10">
<Value>PBSuitInfo</Value>
</Value>
<Value name="11">
<Value>PBInPathStd</Value>
</Value>
<Value name="12">
<Value>PBPDFPath</Value>
</Value>
<Value name="13">
<Value>PBActDate</Value>
</Value>
<Value name="14">
<Value>PBActTime</Value>
</Value>
<Value name="15">
<Value>PBActUserID</Value>
</Value>
<Value name="16">
<Value>PBICD10</Value>
</Value>
<Value name="17">
<Value>PBICDKeys</Value>
</Value>
<Value name="18">
<Value>PBOperICD</Value>
</Value>
<Value name="19">
<Value>PBOperKeys</Value>
</Value>
<Value name="20">
<Value>PBType</Value>
</Value>
<Value name="21">
<Value>PBPathTime</Value>
</Value>
<Value name="22">
<Value>PBPathTimeUnit</Value>
</Value>
<Value name="23">
<Value>PBAdmType</Value>
</Value>
</Data>
<DataLocation>^CT.MA.CPW.KB.PathBaseD</DataLocation>
<DefaultData>PathBaseDefaultData</DefaultData>
<IdLocation>^CT.MA.CPW.KB.PathBaseD</IdLocation>
<IndexLocation>^CT.MA.CPW.KB.PathBaseI</IndexLocation>
<StreamLocation>^CT.MA.CPW.KB.PathBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
