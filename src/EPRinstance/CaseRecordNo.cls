/// 病案号，它由四部分构成：病案室出院科室+出院年份+主诊断ICD码+疾病顺序号
/// add on 2007/11/01, by houjian@dhcc.com.cn, for 安徽省立
Class EPRinstance.CaseRecordNo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock ]
{

/// 病人登记号
Property EpisodeID;

/// 病案室出院科室
Property BADisDept;

/// 出院年份
Property DisYear;

/// 主诊断ICD码
Property DiagICDCode;

/// 疾病顺序号
Property DiseaseNo;

/// 该病案号有效状态; T为有效，F为无效
Property ValidStatus;

Index IdxEpisodeID On (EpisodeID, ValidStatus);

Index IdxMain On (BADisDept, DisYear, DiagICDCode, DiseaseNo, ValidStatus);

///  检查病人某次就诊的病案是否保存过
///  0 未保存， 非0 已保存
ClassMethod CheckInstanceExist(argEpisodeID As %String) As %Integer
{
 new Result
 &sql(SELECT Count(EpisodeID)
 into :Result 
 FROM EPRinstance.CaseRecordNo
 WHERE EpisodeID=:argEpisodeID And ValidStatus='T')
 if Result=""
 {s Result = 0 }
 QUIT Result
}

/*
ClassMethod CheckInstanceExist(argEpisodeId As %String) As %Integer
{
	q:($d(argEpisodeId)=0||argEpisodeId="") 0
	
	s episodeId=" "_argEpisodeId
	s validStatus=" "_"T"
		
    s rowId=""
    s rowId=$O(^EPRinstance.CaseRecordNoI("IdxEpisodeID",episodeId,validStatus,rowId))
    if rowId=""{
	    q 0
	}
	else{
		q rowId
	}     
}
*/
/// w ##class(EPRinstance.CaseRecordNo).CheckInstanceExist(101)
/// 检查要添加的病案号是否有效(跳号的病案号亦不可再使用)
/// 若病案号已经使用，无效；若未使用，有效
/// 返回值：  1 有效；0 无效
/// modified on 2007-12-8, by houjian@dhcc.com.cn
/// 检查要添加的病案号是否有效，跳号的病案号也可使用
/// 若病案号已经使用且ValidStatus为T，无效；其他情况，有效
ClassMethod CheckNewInstanceValid(argBADisDept As %String, argDisYear As %String, argDiagICDCode As %String, argDiseaseNo As %String) As %Integer
{
 s isValid=0
 
 quit:argDiseaseNo<1 isValid
  
 new countId
 &sql(SELECT Count(ID)
 into :countId
 FROM EPRinstance.CaseRecordNo
 WHERE BADisDept=:argBADisDept And DisYear=:argDisYear And DiagICDCode=:argDiagICDCode And DiseaseNo=:argDiseaseNo And ValidStatus='T')
 if countId=0 {s isValid = 1}
 QUIT isValid
}

/// Purpose:分配新的疾病顺序号
/// 根据 病案室出院科室+出院年份+主诊断ICD码 判断该类型的病案是否为首例,
/// 如果为首例,疾病顺序号返回一个提示:"请输入首次疾病顺序号"
/// 如果不是首例,疾病顺序号依次累加 1
/// 
/// modified on 2007-12-07, by houjian@dhcc.com.cn
/// 当不是首例的时候，首先检查该类型病案是否有跳号的，
/// 若有则使用其中最小的顺序号，若无则疾病顺序号依次累加1
ClassMethod AssignNewDiseaseNo(argBADisDept As %String, argDisYear As %String, argDiagICDCode As %String) As %Integer
{
 s Result=""
 
 new maxDiseaseNo
 &sql(SELECT Max(DiseaseNo)
 into :maxDiseaseNo 
 FROM EPRinstance.CaseRecordNo
 WHERE BADisDept=:argBADisDept And DisYear=:argDisYear And DiagICDCode=:argDiagICDCode)
 
 ///首次病历
 if maxDiseaseNo=""{
	 s Result = "请输入首次疾病顺序号"
	 q Result 
 }
  
 ///非首次病历，看是否有跳号 
 new minCancelDisNo
 &sql(SELECT Min(DiseaseNo)
 into :minCancelDisNo 
 FROM EPRinstance.CaseRecordNo
 WHERE BADisDept=:argBADisDept And DisYear=:argDisYear And DiagICDCode=:argDiagICDCode And ValidStatus='F')

 ///无跳号	
 if minCancelDisNo = ""{
     s Result = maxDiseaseNo + 1	 
 } ///有跳号
 else{
	 s Result = minCancelDisNo
 }
 QUIT Result
}

ClassMethod GetInstanceInfo(argEpisodeID As %String) As %String
{
 s Result=""
 new CountID
 new badisdept, disyear, diagicdcode, diseaseno
 &sql(SELECT Count(ID),BADisDept, DisYear, DiagICDCode, DiseaseNo
 into :CountID, :badisdept, :disyear, :diagicdcode, :diseaseno 
 FROM EPRinstance.CaseRecordNo
 WHERE EpisodeID=:argEpisodeID And ValidStatus='T')
 if CountID=1 {
	 s Result = badisdept_"^"_disyear_"^"_diagicdcode_"^"_diseaseno
 } 
 QUIT Result
}

/// 插入新的病案号
/// modified on 2007-12-8, by houjian@dhcc.com.cn
/// 插入病案号时，先检测该病案使用的是：新生成的病案号，还是曾经跳号的病案号
/// 若是新生成的，插入一条新记录
/// 若是曾跳号的，启用之
ClassMethod InsertInstance(argEpisodeID As %String, argBADisDept As %String, argDisYear As %String, argDiagICDCode As %String, argDiseaseNo As %String) As %String
{
 s repealedId=""
 &sql(SELECT ID
 into :repealedId
 FROM EPRinstance.CaseRecordNo
 WHERE BADisDept=:argBADisDept And DisYear=:argDisYear And DiagICDCode=:argDiagICDCode And DiseaseNo=:argDiseaseNo And ValidStatus='F')
 
 ///非跳号的病案号，插入新记录
 if repealedId=""{
	 &sql(INSERT into EPRinstance.CaseRecordNo
          (EpisodeID, BADisDept, DisYear, DiagICDCode, DiseaseNo, ValidStatus)
          VALUES (:argEpisodeID,:argBADisDept,:argDisYear,:argDiagICDCode,:argDiseaseNo,'T'))
 }
 else{  ///跳号的病案号，更新之作为新病案的病案号
	 &sql(UPDATE EPRinstance.CaseRecordNo
          SET EpisodeID=:argEpisodeID,ValidStatus='T'
          WHERE ID=:repealedId)
 }
}

/// 更新病案号：首先使旧的病案号不可用，然后插入一条新的病案号
/// modified on 2007-12-08, by houjian@dhcc.com.nc
/// 更新病案：首先使该病案的旧病案号不可用，然后为该病案配置一条新的病案号
ClassMethod UpdateInstance(argEpisodeID As %String, argBADisDept As %String, argDisYear As %String, argDiagICDCode As %String, argDiseaseNo As %String) As %String
{
 &sql(UPDATE EPRinstance.CaseRecordNo
 SET ValidStatus='F'
 WHERE EpisodeID=:argEpisodeID And ValidStatus='T')
 
 ///&sql(INSERT into EPRinstance.CaseRecordNo
 ///(EpisodeID, BADisDept, DisYear, DiagICDCode, DiseaseNo, ValidStatus)
 ///VALUES (:argEpisodeID,:argBADisDept,:argDisYear,:argDiagICDCode,:argDiseaseNo,"T"))
 
 do ..InsertInstance(argEpisodeID, argBADisDept, argDisYear, argDiagICDCode, argDiseaseNo)
}

/// 取得前端页面保存的病案号数据，检查其是否合法，并做相应的插入或更新动作
ClassMethod CaseRecordNoService(argEpisodeID As %String, argTemplateId As %String, argItemBADisDept As %String, argItemDisYear As %String, argItemDiagICDCode As %String, argItemDiseaseNo As %String) As %String
{
 set disDept="", disYear="", diagICDCode="" ,diseaseNo=""
 
 &sql(select DataValue
	 into :disDept
	 from EPRinstance.ISimple
	 where EpisodeID = :argEpisodeID And TemplateID = :argTemplateId And SimpleItemCode = :argItemBADisDept )
	 
 &sql(select DataValue
	 into :disYear
     from EPRinstance.ISimple
     where EpisodeID = :argEpisodeID And TemplateID = :argTemplateId And SimpleItemCode = :argItemDisYear )
	
 &sql(select DataValue
	 into :diagICDCode
     from EPRinstance.ISimple
	 where EpisodeID = :argEpisodeID And TemplateID = :argTemplateId And SimpleItemCode = :argItemDiagICDCode )    
     
 &sql(select DataValue
	 into :diseaseNo
	 from EPRinstance.ISimple
	 where EpisodeID = :argEpisodeID And TemplateID = :argTemplateId And SimpleItemCode = :argItemDiseaseNo )
 
 /// make sure that fresh Case-Record-No is legal
	 set IsLegal=..CheckNewInstanceValid(disDept, disYear, diagICDCode, diseaseNo)
	 quit:(IsLegal=0) "0"
      
 /// check whether Case-Record have been saved before,
 /// if not saved, save the fresh Case-Record-No,
 /// if saved, annul old Case-Record-No, then save the fresh one.
 set IsExist=..CheckInstanceExist(argEpisodeID)
 if (IsExist=0){
     do ..InsertInstance(argEpisodeID,disDept, disYear, diagICDCode, diseaseNo)    
 } 
 else {
     do ..UpdateInstance(argEpisodeID,disDept, disYear, diagICDCode, diseaseNo) 
 }  
 
 quit "1"
}

Storage Default
{
<Data name="CaseRecordNoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DigICDCode</Value>
</Value>
<Value name="3">
<Value>DisDept</Value>
</Value>
<Value name="4">
<Value>DisYear</Value>
</Value>
<Value name="5">
<Value>DiseaseNo</Value>
</Value>
<Value name="6">
<Value>EpisodeID</Value>
</Value>
<Value name="7">
<Value>DisDeptBA</Value>
</Value>
<Value name="8">
<Value>ValidStatus</Value>
</Value>
<Value name="9">
<Value>BADisDept</Value>
</Value>
<Value name="10">
<Value>DiagICDCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.CaseRecordNoD</DataLocation>
<DefaultData>CaseRecordNoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.CaseRecordNoD</IdLocation>
<IndexLocation>^DHCEPRI.CaseRecordNoI</IndexLocation>
<StreamLocation>^DHCEPRI.CaseRecordNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
