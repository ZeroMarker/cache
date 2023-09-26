/// 名称: DHCHAI.DP.BPRegister
/// 描述: 血透登记表
/// 编写者: zhoubo
/// 编写日期: 2022-10-13
Class DHCHAI.DP.BPRegister Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 血透登记ID
Property PABPRegID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// HIS就诊序号
Property PAEpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// HIS病人主索引
Property PAPatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案号
Property PAMrNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 姓名
Property PAPatName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 性别（M男、F女、O其他）
Property PAPatSex As %String(DISPLAYLIST = ",M,F,O", VALUELIST = ",M,F,O");

/// 年龄
Property PAPatAge As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊类型（O门诊、E急诊、EP急诊留观、I住院）
Property PAPatType As %String(DISPLAYLIST = ",O,E,EP,I", VALUELIST = ",O,E,EP,I");

/// 出生日期
Property PABirthday As %Date;

/// 联系电话
Property PARelTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 透析科室
Property PAAdmLoc As DHCHAI.BT.Location;

/// 透析次数（计算后的值）
Property PAHDTime As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主管医生（ID|Code|Desc）
Property PAAdmDoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主管护士（ID|Code|Desc）
Property PAAdmNurse As %String(MAXLEN = 100, TRUNCATE = 1);

/// 传染病类型 乙肝、梅毒等
Property PAEpiInfo As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病人类型 常规、临时
Property PABPPatType As %String(MAXLEN = 200, TRUNCATE = 1);

/// 诊断
Property PADiagnosis As %String(MAXLEN = 500, TRUNCATE = 1);

/// 首次透析日期
Property PAStartDate As %Date;

/// 结束透析日期
Property PAEndDate As %Date;

/// 转归日期
Property PAStatusDate As %Date;

/// 转归时间
Property PAStatusTime As %Time;

/// 登记日期
Property PARegDate As %Date;

/// 登记时间
Property PARegTime As %Time;

/// 是否有效
Property PAIsActive As %Boolean;

/// 更新日期
Property PAUpdateDate As %Date;

/// 更新时间
Property PAUpdateTime As %Time;

/// 是否完成本次血透（发生转归即完成）
Property PAIsFinish As %Boolean;

/// 就诊索引
Index IndexEpisodeDr On PAEpisodeID As Exact;

/// 登记索引
Index IndexPatientDr On PAPatientID As Exact;

/// 登记日期时间索引
Index IndexRegDateTime On (PARegDate, PARegTime);

/// 血透登记ID 索引
Index IndexBPRegID On PABPRegID [ Unique ];

/// 是否完成本次血透索引
Index IndexIsFinish On PAIsFinish As Exact;

/// Creator：     zhoubo
/// CreatDate：   2022-10-13
/// Description:  根据Id取血透登记表信息
/// Table：       DHCHAI.DP.BPRegister
/// Input：       aId : DHCHAI.DP.BPRegister
/// Return：      返回obj
/// w ##class(DHCHAI.DP.BPRegister).GetObjById("11")
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.BPRegister
{
	New (aId)
	Quit:'##class(DHCHAI.DP.BPRegister).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.BPRegister).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-13
/// Description:  更新血透登记表信息
/// Table：       DHCHAI.DP.BPRegister
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.BPRegister).Update("1^121^72^21^100030^Lisa03^F^25岁^I^2001-01-01^18428302646^23^3^1|11|张医生^2|11|张护士^乙肝^常规^血管堵塞^2022-10-01^^^^2022-10-01^12:12:12^1^^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	 = $p(InStr,aSeparete,1)
	Set PABPRegID	 = $p(InStr,aSeparete,2)
	Set PAEpisodeID  = $p(InStr,aSeparete,3)
	Set PAPatientID	 = $p(InStr,aSeparete,4)
	Set PAMrNo		 = $p(InStr,aSeparete,5)
	Set PAPatName	 = $p(InStr,aSeparete,6)
	Set PAPatSex	 = $p(InStr,aSeparete,7)
	Set PAPatAge	 = $p(InStr,aSeparete,8)
	Set PAPatType	 = $p(InStr,aSeparete,9)
	Set PABirthday	 = $p(InStr,aSeparete,10)
	Set PARelTel	 = $p(InStr,aSeparete,11)
	Set PAAdmLoc	 = $p(InStr,aSeparete,12)
	Set PAHDTime     = $p(InStr,aSeparete,13)
	Set PAAdmDoc	 = $p(InStr,aSeparete,14)
	Set PAAdmNurse	 = $p(InStr,aSeparete,15)
	Set PAEpiInfo    = $p(InStr,aSeparete,16)
	Set PABPPatType  = $p(InStr,aSeparete,17)
	Set PADiagnosis  = $p(InStr,aSeparete,18)
	Set PAStartDate  = $p(InStr,aSeparete,19)
	Set PAEndDate    = $p(InStr,aSeparete,20)
	Set PAStatusDate = $p(InStr,aSeparete,21)
	Set PAStatusTime = $p(InStr,aSeparete,22)
	Set PARegDate    = $p(InStr,aSeparete,23)
	Set PARegTime    = $p(InStr,aSeparete,24)
	Set PAIsActive   = +$p(InStr,aSeparete,25)
	Set PAUpdateDate = $p(InStr,aSeparete,26)
	Set PAUpdateTime = $p(InStr,aSeparete,27)
	
	Set PAIsFinish=0
	Set:PAStatusDate'="" PAIsFinish   = 1  // 患者发生转归即透析完成
	Set:PABPPatType="临时" PAIsFinish = 1  // 临时插管患者
	Set:PABirthday["-" PABirthday = $zdh(PABirthday,3)
	Set:PAStartDate["-" PAStartDate = $zdh(PAStartDate,3)
	Set:PAEndDate["-" PAEndDate = $zdh(PAEndDate,3)
	Set:PAStatusDate["-" PAStatusDate = $zdh(PAStatusDate,3)
	Set:PARegDate["-" PARegDate = $zdh(PARegDate,3)
	Set:PAStatusTime[":" PAStatusTime = $zth(PAStatusTime,1)
	Set:PARegTime[":" PARegTime = $zth(PARegTime,1)
	
	Set PAPatSex  = $s(PAPatSex="男":"M",PAPatSex="女":"F",1:"")
	Set PAPatType = $s(PAPatType="门诊":"O",PAPatType="急诊":"E",PAPatType="急诊留观":"EP",PAPatType="住院":"I",1:"")
	Set:PAAdmDoc'["|" PAAdmDoc="|"_PAAdmDoc_"|"_PAAdmDoc
	Set:PAAdmNurse'["|" PAAdmNurse="|"_PAAdmNurse_"|"_PAAdmNurse
	Quit:(PABPRegID="")||(PAPatName="") return
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(PAAdmLoc)
	//血透登记录索引码 唯一性
	Set tID=$o(^MA.HAI.DP.BPRegisterI("IndexBPRegID"," "_PABPRegID,0))
	If (ID'=""){
		Quit:(tID'="")&(ID'=tID) -100
	}Else{
		Set ID = tID
	}
	if ID="" {
		Set obj=##class(DHCHAI.DP.BPRegister).%New()
	}else{
		Set obj=##class(DHCHAI.DP.BPRegister).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PABPRegID	 = PABPRegID	 
	Set obj.PAEpisodeID  = PAEpisodeID  
	Set obj.PAPatientID	 = PAPatientID	 
	Set obj.PAMrNo		 = PAMrNo		 
	Set obj.PAPatName	 = PAPatName	 
	Set obj.PAPatSex	 = PAPatSex	 
	Set obj.PAPatAge	 = PAPatAge	 
	Set obj.PAPatType	 = PAPatType	 
	Set obj.PABirthday	 = PABirthday	 
	Set obj.PARelTel	 = PARelTel	 
	Set obj.PAAdmLoc	 = objLoc
	Set obj.PAHDTime     = PAHDTime	
	Set obj.PAAdmDoc	 = PAAdmDoc	 
	Set obj.PAAdmNurse	 = PAAdmNurse	 
	Set obj.PAEpiInfo    = PAEpiInfo    
	Set obj.PABPPatType  = PABPPatType  
	Set obj.PADiagnosis  = PADiagnosis  
	Set obj.PAStartDate  = PAStartDate  
	Set obj.PAEndDate    = PAEndDate    
	Set obj.PAStatusDate = PAStatusDate 
	Set obj.PAStatusTime = PAStatusTime 
	Set obj.PARegDate    = PARegDate    
	Set obj.PARegTime    = PARegTime    
	Set obj.PAIsActive   = PAIsActive 
	Set obj.PAUpdateDate = +$h
	Set obj.PAUpdateTime = $p($h,",",2)
	Set obj.PAIsFinish   = PAIsFinish
	
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

/// Creator：     zhoubo
/// CreatDate：   2022-10-13
/// Description:  删除血透登记表信息
/// Table：       DHCHAI.DP.BPRegister
/// Input：       aId : DHCHAI.DP.BPRegister.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.BPRegister).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.BPRegister).%DeleteId(aId)
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
<Data name="BPRegisterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PABPRegID</Value>
</Value>
<Value name="3">
<Value>PAEpisodeID</Value>
</Value>
<Value name="4">
<Value>PAPatientID</Value>
</Value>
<Value name="5">
<Value>PAMrNo</Value>
</Value>
<Value name="6">
<Value>PAPatName</Value>
</Value>
<Value name="7">
<Value>PAPatSex</Value>
</Value>
<Value name="8">
<Value>PAPatAge</Value>
</Value>
<Value name="9">
<Value>PAPatType</Value>
</Value>
<Value name="10">
<Value>PABirthday</Value>
</Value>
<Value name="11">
<Value>PARelTel</Value>
</Value>
<Value name="12">
<Value>PAAdmLoc</Value>
</Value>
<Value name="13">
<Value>PAHDTime</Value>
</Value>
<Value name="14">
<Value>PAAdmDoc</Value>
</Value>
<Value name="15">
<Value>PAAdmNurse</Value>
</Value>
<Value name="16">
<Value>PAEpiInfo</Value>
</Value>
<Value name="17">
<Value>PABPPatType</Value>
</Value>
<Value name="18">
<Value>PADiagnosis</Value>
</Value>
<Value name="19">
<Value>PAStartDate</Value>
</Value>
<Value name="20">
<Value>PAEndDate</Value>
</Value>
<Value name="21">
<Value>PAStatusDate</Value>
</Value>
<Value name="22">
<Value>PAStatusTime</Value>
</Value>
<Value name="23">
<Value>PARegDate</Value>
</Value>
<Value name="24">
<Value>PARegTime</Value>
</Value>
<Value name="25">
<Value>PAIsActive</Value>
</Value>
<Value name="26">
<Value>PAUpdateDate</Value>
</Value>
<Value name="27">
<Value>PAUpdateTime</Value>
</Value>
<Value name="28">
<Value>PAIsFinish</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.DP.BPRegisterD</DataLocation>
<DefaultData>BPRegisterDefaultData</DefaultData>
<IdLocation>^MA.HAI.DP.BPRegisterD</IdLocation>
<IndexLocation>^MA.HAI.DP.BPRegisterI</IndexLocation>
<StreamLocation>^MA.HAI.DP.BPRegisterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
