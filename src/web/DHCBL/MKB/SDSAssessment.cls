/// Creator:高姗姗
/// CreatDate:2018-05-14
/// Description：结构化诊断推荐评估表
/// Table：User.SDSAssessment
Class web.DHCBL.MKB.SDSAssessment Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2018-12-13
/// Description：保存修改推荐评估表(一条)的内容(新版)
/// Table：User.SDSAssessment
/// Input：rowid:结构化诊断id info:诊断模板属性id#属性内容值串#诊断展示名#诊断备注
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSAssessment).SaveAssessment("781||9","5358#9448T:9453^9449T:9520^9524T:9527^9444T:9445#Z45.9(T细胞淋巴瘤,Ⅰ,E)#")
ClassMethod SaveAssessment(StructRowId, info) As %String
{
	s result=""
	
	s SDSAScore=$p(info,"^",1)
	s SDSADesc=$p(info,"^",2)
	s SDSARank=$p(info,"^",3)
	s SDSABaseDR=$p(info,"^",4)
	s SDSAValue=$p(info,"^",5)
   
    if ($d(^User.SDSAssessmentI("DiagBaseIndex",StructRowId,SDSABaseDR))){
	   	s rowid=$o(^User.SDSAssessmentI("DiagBaseIndex",StructRowId,SDSABaseDR,0))
		s obj=##class(User.SDSAssessment).%OpenId(rowid)
	}else{
		s obj=##class(User.SDSAssessment).%New()
	}	
	
	s obj.SDSADiagDR=StructRowId
	s obj.SDSAScore=SDSAScore
	s obj.SDSADesc=SDSADesc
	s obj.SDSARank=SDSARank
	d:SDSABaseDR'="" obj.SDSABaseDRSetObjectId(SDSABaseDR)
	d:SDSABaseDR="" obj.SDSABaseDRSetObjectId("")
	s obj.SDSAValue=SDSAValue
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"   
	}else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"_'}"    //返回错误信息 
	}		
	
	q result
}

/// Creator:高姗姗
/// CreatDate:2018-5-14
/// Description：保存修改推荐评估表的内容
/// Table：User.SDSAssessment
/// Input：rowid:结构化诊断id info:诊断模板属性id#属性内容值串#诊断展示名#诊断备注
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSAssessment).SaveData("781||9","5358#9448T:9453^9449T:9520^9524T:9527^9444T:9445#Z45.9(T细胞淋巴瘤,Ⅰ,E)#")
ClassMethod SaveData(StructRowId, info) As %String
{
	s result=""
	if (info'=""){
		s len=$Length(info,"*")
		for i=1:1:len{
			s assessment=$p(info,"*",i)
			s SDSAScore=$p(assessment,"^",1)
			s SDSADesc=$p(assessment,"^",2)
			s SDSARank=$p(assessment,"^",3)
			s SDSABaseDR=$p(assessment,"^",4)
			s SDSAValue=$p(assessment,"^",5)
		   
		    if ($d(^User.SDSAssessmentI("DiagBaseIndex",StructRowId,SDSABaseDR))){
			   	s rowid=$o(^User.SDSAssessmentI("DiagBaseIndex",StructRowId,SDSABaseDR,0))
				s obj=##class(User.SDSAssessment).%OpenId(rowid)
			}else{
				s obj=##class(User.SDSAssessment).%New()
			}	
			s obj.SDSADiagDR=StructRowId
			s obj.SDSAScore=SDSAScore
			s obj.SDSADesc=SDSADesc
			s obj.SDSARank=SDSARank
			d:SDSABaseDR'="" obj.SDSABaseDRSetObjectId(SDSABaseDR)
			d:SDSABaseDR="" obj.SDSABaseDRSetObjectId("")
			s obj.SDSAValue=SDSAValue
			
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				s id = obj.%Id()
				s result = result_"1"  
			}else{
				s result = result_"0"  
			}		
		}
	}
	if (result["0"){
		s result = "{success:'false'}"    //返回错误信息 
	}else{
		s result = "{success:'true'}"   
	}			
	q result
}

/// Creator:高姗姗
/// CreatDate:2018-6-6
/// Description：获取推荐评估表内容值串
/// Table：User.SDSAssessment
/// Input：结构化诊断id，评分表id
/// w ##class(web.DHCBL.MKB.SDSAssessment).GetValue("","")
ClassMethod GetValue(StructRowId, AssBaseRowId) As %String
{
	s result=""
	if (StructRowId'=""){
		if ($d(^User.SDSAssessmentI("DiagBaseIndex",StructRowId,AssBaseRowId))){
			s rowid=$o(^User.SDSAssessmentI("DiagBaseIndex",StructRowId,AssBaseRowId,0))
			s SDSAValue=$LISTGET($G(^User.SDSAssessmentD(rowid)),7)
			s result=SDSAValue
		}
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2018-6-6
/// Description：获取推荐评估表信息
/// Table：User.SDSAssessment
/// Input：结构化诊断id，评分表id
/// w ##class(web.DHCBL.MKB.SDSAssessment).GetValue("","")
ClassMethod GetInfo(StructRowId, AssBaseRowId) As %String
{
	s result=""
	if (StructRowId'=""){
		if ($d(^User.SDSAssessmentI("DiagBaseIndex",StructRowId,AssBaseRowId))){
			s rowid=$o(^User.SDSAssessmentI("DiagBaseIndex",StructRowId,AssBaseRowId,0))
			s SDSAScore=$LISTGET($G(^User.SDSAssessmentD(rowid)),2)
			s SDSADesc=$LISTGET($G(^User.SDSAssessmentD(rowid)),3)
			s SDSARank=$LISTGET($G(^User.SDSAssessmentD(rowid)),5)
			s SDSAValue=$LISTGET($G(^User.SDSAssessmentD(rowid)),7)
			s result=SDSAScore_"&%"_SDSADesc_"&%"_SDSARank_"&%"_SDSAValue
		}
	}
	q result
}

}
