/// portal数据规则配置实体类
Class DtPortal.Configure.DataRule Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DataRule_ID, SqlTableName = DataRule, StorageStrategy = DataRuleSto ]
{

Relationship ChildItem As DtPortal.Configure.DataRuleDictionaries [ Cardinality = children, Inverse = ParRef ];

/// 数据规则配置code
Property DataRuleCode As %String(TRUNCATE = 1);

/// 数据规则配置desc
Property DataRuleDesc As %String(TRUNCATE = 1);

/// 数据规则配置分类(系统版本:1 日期范围 2 取值范围 3 其他 other)
Property DataRuleType As %String;

/// 数据规则配置使用角色(存角色code,多个角色用|分割)
Property DataRuleRole As %Text(MAXLEN = 500, TRUNCATE = 1);

/// 数据规则配置类型 (直接赋值 1  单选 2  多选 3)
Property DataRuleValeType As %String(TRUNCATE = 1);

/// 数据规则配置值
Property DataRuleValue As %String(TRUNCATE = 1);

/// 数据规则配置备注
Property DataRuleRemarks As %Text(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property DataRuleUpdate As %Date;

/// 更新时间
Property DataRuleUpTime As %Time;

// code索引

Index DataRuleCodeIndex On DataRuleCode;

// desc索引

Index DataRuleDescIndex On DataRuleDesc;

/// Creator：     chengpeng
/// CreatDate：   2018-11-05
/// Description:  取角色配置
/// Table：       DtPortal_Configure.DataRule
/// Input：       DtPortal.Configure.DataRule
/// Return：      返回obj
/// w ##class(DtPortal.Configure.DataRule).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DtPortal.Configure.DataRule
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.DataRule).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  更新数据配置
/// Table：       DtPortal_Configure.DataRule
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败33??HISEDITION??HIS版本号??2??2????Y
/// w ##Class(DtPortal.Configure.DataRule).Update("32@$11@$22结构ID@$other@$DOCTOR|DIRECTORDOCTOR|MEDICALDEPARTMENT|NURSEHEAD|OUTPATIENTDEPARTMENT@$1@$52@$select ID from emrmeta.emrtemplatecategory where categorytype='TempCate' AND CategoryName='病案首页'@$52@$","@$")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	s ^cheng("DtPortal.Configure.DataRule")=aInput_"____"_aSeparate
	///set $zt="Update"
	Set return=-1
	Set:aSeparate="" aSeparate="^"
	Set ID=$p(aInput,aSeparate,1)					//主表 ID,新增为""
	set code=$p(aInput,aSeparate,2)
	set code=$$ALPHAUP^SSUTIL4(code)				//code
	set desc=$p(aInput,aSeparate,3)
	set desc=$$ALPHAUP^SSUTIL4(desc)				//描述
	set type=$p(aInput,aSeparate,4)					//配置分类
	set role=$p(aInput,aSeparate,5)					//关联角色	
	set valueType=$p(aInput,aSeparate,6)			//值类型
	set value=$p(aInput,aSeparate,7)				//值	
	set Remarks=$p(aInput,aSeparate,8)				//备注
	set optionValueStr=$p(aInput,aSeparate,9)		//选项值串
	set optionValueDescStr=$p(aInput,aSeparate,10)	//选项值描述串
	set value=$tr(value,"^",$c(9813))
	set Remarks=$tr(Remarks,$c(10),"/")
	set value=$tr(value,$c(10),"/")
	set Remarks=$tr(Remarks,"^",$c(9813))
	If ID="" {
		set rowID=$o(^DtPortal.Configure.DataRuleI("DataRuleCodeIndex"," "_code,""))
		quit:rowID'="" 0
		set rowID=$o(^DtPortal.Configure.DataRuleI("DataRuleDescIndex"," "_desc,""))
		quit:rowID'="" 0
		Set obj=##class(DtPortal.Configure.DataRule).%New()	
	} Else {
		set isHava=0
		set rowID=""
		for
		{
			set rowID=$o(^DtPortal.Configure.DataRuleI("DataRuleCodeIndex"," "_code,rowID))
			quit:rowID=""
			
			set:rowID'=ID isHava=1
		}
		quit:isHava=1 0
		
		set rowID=""
		for
		{
			set rowID=$o(^DtPortal.Configure.DataRuleI("DataRuleDescIndex"," "_desc,rowID))
			quit:rowID=""
			
			set:rowID'=ID isHava=1
		}
		quit:isHava=1 0
		Set obj=##class(DtPortal.Configure.DataRule).%OpenId(ID)
		
	}
	Set obj.DataRuleCode       	= code
	Set obj.DataRuleDesc       	= desc
	Set obj.DataRuleType       	= type
	Set obj.DataRuleRole       	= role
	Set obj.DataRuleValeType    = valueType
	Set obj.DataRuleValue       = value
	Set obj.DataRuleRemarks   	= Remarks
	Set obj.DataRuleUpdate     	= $p($h,",",1)
	Set obj.DataRuleUpTime     	= $p($h,",",2)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		set ret=##Class(DtPortal.Configure.DataRuleDictionaries).saveOption(return,optionValueStr,optionValueDescStr)
	}
	Do obj.%Close()
	
	Quit return
///Update
///	q $zt
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  删除数据配置
/// Table：       DtPortal_Configure.DataRule
/// Input：       DtPortal.Configure.DataRule
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.DataRule).DeleteById(3)
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.DataRule).%DeleteId(+ID)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  查询数据配置
/// Table：       DtPortal_Configure.DataRule
/// Input：       DtPortal.Configure.DataRule
/// w ##Class(DtPortal.Configure.DataRule).qureyData(,,)
ClassMethod qureyData(page = 1, rows = 10, code = "", desc = "", type = "", role = "") As %String
{
	 new (page,rows,code,desc,type,role)
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 w "{""rows"":["
	 set code=$$ALPHAUP^SSUTIL4(code)
	 set desc=$$ALPHAUP^SSUTIL4(desc)
	 set arole="|"_role_"|"
	 set rowID=0
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.DataRuleD(rowID))
		 quit:rowID=""
		 
		 set dataList=^DtPortal.Configure.DataRuleD(rowID)
		 set Datacode=$Li(dataList,2)
		 set Datadesc=$Li(dataList,3)
		 set Datatype=$Li(dataList,4)
		 set valuetype=$Li(dataList,5)
		 set value=$Li(dataList,6)
		 set Remarks=$Li(dataList,7)
		 set roleDesc=$Li(dataList,10)
		
		 continue:((code'="")&&(Datacode'[code))
		 continue:((desc'="")&&(Datadesc'[desc))
		 continue:((type'="")&&(Datatype'=type))
		 
		 set value=$tr(value,$c(9813),"^")
		 set Remarks=$tr(Remarks,$c(9813),"^")
		 set Remarks=$tr(Remarks,"""","^")
		 set Remarks=$tr(Remarks,$c(10),"")
		 set Remarks=$tr(Remarks,$c(9),"")
		 
		 set typeDesc=""
		 set:Datatype=1 typeDesc="系统版本"
		 set:Datatype=2 typeDesc="时间范围"
		 set:Datatype=3 typeDesc="数值范围"
		 set:Datatype="other" typeDesc="其他"
		 
		 set aroleStr="|"_roleDesc_"|"
		 continue:((role'="")&&(role'="ALL")&&(aroleStr'[arole))
	
		 set valueTypeDesc=""
		 set:valuetype=1 valueTypeDesc="数值"
		 set:valuetype=2 valueTypeDesc="单选"
		 set:valuetype=3 valueTypeDesc="多选"
		 
		 set valueDesc=""
		 set optionValue=""
		 set optionDesc=""
		 set subID=""
		
		 set valueStr="^"_value_"^"
		 for
		 {
			 set subID=$o(^DtPortal.Configure.DataRuleD(rowID,"Item",subID))
			 quit:subID=""
			 
			 Set subObj=##class(DtPortal.Configure.DataRuleDictionaries).%OpenId(rowID_"||"_subID)
		 	 continue:'$IsObject(subObj)
			 set OPvalue=subObj.DataDictValue
		 	 set OPdesc=subObj.DataDictDesc
		 	 set OPvalueStr="^"_OPvalue_"^"
		 	
		 	 set:optionValue'="" optionValue=optionValue_"#*"_OPvalue
		 	 set:optionValue="" optionValue=OPvalue
		 	 
		 	 set:optionDesc'="" optionDesc=optionDesc_"#*"_OPdesc
		 	 set:optionDesc="" optionDesc=OPdesc
		 	 continue:valueStr'[OPvalueStr
		 	 set:valueDesc'="" valueDesc=valueDesc_"^"_OPdesc
		 	 set:valueDesc="" valueDesc=OPdesc
		 }
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 w $case(count,start:"",:",")
		 w "{"
		 w """ID"":"_""""_rowID_""""_","
		 w """code"":"_""""_Datacode_""""_","
		 w """desc"":"_""""_Datadesc_""""_","
		 w """type"":"_""""_Datatype_""""_","
		 w """roleDesc"":"_""""_roleDesc_""""_","
		 w """typeDesc"":"_""""_typeDesc_""""_","
		 w """valueType"":"_""""_valuetype_""""_","
		 w """valueTypeDesc"":"_""""_valueTypeDesc_""""_","
		 w """value"":"_""""_value_""""_","
		 w """valueDesc"":"_""""_valueDesc_""""_","
		 w """Remarks"":"_""""_Remarks_""""_","
		 w """optionValue"":"_""""_optionValue_""""_","
		 w """optionDesc"":"_""""_optionDesc_""""
		 w "}" 
		 
	 }
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  查询角色
/// Table：       DtPortal_Configure.RoleGroup
/// Input：       DtPortal.Configure.RoleGroup
/// w ##Class(DtPortal.Configure.DataRule).qureyRole()
ClassMethod qureyRole() As %String
{
	
	 w "["
	  w "{"
	 w """RoleCode"":"_""""_"ALL"_""""_","
	 w """RoleDesc"":"_""""_"全部"_""""
	 w "}"
	 w ",{"
	 w """RoleCode"":"_""""_"通用"_""""_","
	 w """RoleDesc"":"_""""_"通用"_""""
	 w "}"
	 set rowID=""
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.RoleGroupD(rowID))
		 quit:rowID=""
		 
		 set obj=##class(DtPortal.Configure.RoleGroup).GetObjById(rowID)
		 continue:'$IsObject(obj)
		
		 set PortalID=obj.PortalID
		 set RoleCode=obj.RoleCode
		 set RoleDesc=obj.RoleDesc
		 set RoleCode=$$ALPHAUP^SSUTIL4(RoleCode)
		 set RoleIsActive=obj.RoleIsActive
		 w ",{"
		 w """RoleCode"":"_""""_RoleDesc_""""_","
		 w """RoleDesc"":"_""""_RoleDesc_""""
		 w "}" 
		 
		 
	 }
	 w "]"
	 q ""
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  查询数据配置
/// Table：       DtPortal_Configure.DataRule
/// Input：       DtPortal.Configure.DataRule
/// w ##Class(DtPortal.Configure.DataRule).qureyData2(,,"会诊")
ClassMethod qureyData2(page = 1, rows = 10, q = "") As %String
{
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 set q=$$ALPHAUP^SSUTIL4(q)
	 w "{""rows"":["
	 set rowID=0
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.DataRuleD(rowID))
		 quit:rowID=""
		 
		 set dataList=^DtPortal.Configure.DataRuleD(rowID)
		 
		 set Datacode=$Li(dataList,2)
		 set Datadesc=$Li(dataList,3)
		 set type=$Li(dataList,4)
		 set value=$Li(dataList,5)
		 set Remarks=$Li(dataList,6)
		 set IsActive=$Li(dataList,7)

		 continue:(q'="")&&(Datacode'[q)&&(Datadesc'[q)
		 set value=$tr(value,$c(9813),"^")
		 set Remarks=$tr(Remarks,$c(9813),"^")
		 set Remarks=$tr(Remarks,"""","^")
		 set Remarks=$tr(Remarks,$c(10),"")
		 set Remarks=$tr(Remarks,$c(9),"")
		 set typeDesc=""
		 set:type=1 typeDesc="数值"
		 set:type=2 typeDesc="单选"
		 set:type=3 typeDesc="多选"
		 
		 set valueDesc=""
		 set optionValue=""
		 set optionDesc=""
		 set subID=""
		 for
		 {
			 set subID=$o(^DtPortal.Configure.DataRuleD(rowID,"Item",subID))
			 quit:subID=""
			 
			 Set subObj=##class(DtPortal.Configure.DataRuleDictionaries).%OpenId(rowID_"||"_subID)
		 	 continue:'$IsObject(subObj)
			 set OPvalue=subObj.DataDictValue
		 	 set OPdesc=subObj.DataDictDesc
		 	 
		 	 set:optionValue'="" optionValue=optionValue_"^"_OPvalue
		 	 set:optionValue="" optionValue=OPvalue
		 	 
		 	 set:optionDesc'="" optionDesc=optionDesc_"^"_OPdesc
		 	 set:optionDesc="" optionDesc=OPdesc
		 	 set:value=OPvalue valueDesc=OPdesc
		 }
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 w $case(count,start:"",:",")
		 w "{"
		 w """ID"":"_""""_rowID_""""_","
		 w """code"":"_""""_Datacode_""""_","
		 w """desc"":"_""""_Datadesc_""""_","
		 w """type"":"_""""_type_""""_","
		 w """typeDesc"":"_""""_typeDesc_""""_","
		 w """value"":"_""""_value_""""_","
		 w """valueDesc"":"_""""_valueDesc_""""_","
		 w """Remarks"":"_""""_Remarks_""""_","
		 w """optionValue"":"_""""_optionValue_""""_","
		 w """optionDesc"":"_""""_optionDesc_""""_","
		 w """IsActive"":"_""""_IsActive_""""
		 w "}" 
		 
	 }
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：     程鹏
/// CreatDate：   2018-09-26
/// Description:  导出全部数据
/// w ##Class(DtPortal.Configure.DataRule).locIndexExp()
ClassMethod locIndexExp() As %String
{
	
	 w "["
	 set isFirst=1,isHaveRole=0
	 set rowID=""
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.DataRuleD(rowID))
		 quit:rowID=""
		 
		 set obj=##class(DtPortal.Configure.DataRule).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 
		 set DataRuleCode=obj.DataRuleCode
		 set DataRuleDesc=obj.DataRuleDesc
		 set DataRuleType=obj.DataRuleType
		 set DataRuleRole=obj.DataRuleRole
		 set DataRuleValeType=obj.DataRuleValeType
		 set DataRuleValue=obj.DataRuleValue
		 set DataRuleRemarks=obj.DataRuleRemarks
		 
		 set DataRuleValue=$tr(DataRuleValue,$c(9813),"^")
		 set DataRuleRemarks=$tr(DataRuleRemarks,$c(9813),"^")
		 set DataRuleRemarks=$tr(DataRuleRemarks,"""","^")
		 set DataRuleRemarks=$tr(DataRuleRemarks,$c(10),"")
		 set DataRuleRemarks=$tr(DataRuleRemarks,$c(9),"")
		 
		 set:DataRuleType=1 DataRuleTypeDesc="系统版本"
		 set:DataRuleType=2 DataRuleTypeDesc="时间范围"
		 set:DataRuleType=3 DataRuleTypeDesc="数值范围"
		 set:DataRuleType="other" DataRuleTypeDesc="其他"
		 
		 set DataRuleValeTypeDesc=""
		 set:DataRuleValeType=1 DataRuleValeTypeDesc="数值"
		 set:DataRuleValeType=2 DataRuleValeTypeDesc="单选"
		 set:DataRuleValeType=3 DataRuleValeTypeDesc="多选"
		 
		 set DataRuleValueDesc=""
		
		 set subID=""
		 for
		 {
			 set subID=$o(^DtPortal.Configure.DataRuleD(rowID,"Item",subID))
			 quit:subID=""
			 
			 Set subObj=##class(DtPortal.Configure.DataRuleDictionaries).%OpenId(rowID_"||"_subID)
		 	 continue:'$IsObject(subObj)
			 set OPvalue=subObj.DataDictValue
		 	 set OPdesc=subObj.DataDictDesc
		 	 
		 	 set:DataRuleValue=OPvalue DataRuleValueDesc=OPdesc
		 }
		 
		 w:isFirst'=1 ","
		 w "{"
		 w """DataRuleCode"":"_""""_DataRuleCode_""""_","
		 w """DataRuleDesc"":"_""""_DataRuleDesc_""""_","
		 w """DataRuleType"":"_""""_DataRuleType_""""_","
		 w """DataRuleTypeDesc"":"_""""_DataRuleTypeDesc_""""_","
		 w """DataRuleRole"":"_""""_DataRuleRole_""""_","
		 w """DataRuleRole"":"_""""_DataRuleRole_""""_","
		 w """DataRuleValeType"":"_""""_DataRuleValeType_""""_","
		 w """DataRuleValeTypeDesc"":"_""""_DataRuleValeTypeDesc_""""_","
		 w """DataRuleValue"":"_""""_DataRuleValue_""""_","
		 w """DataRuleValueDesc"":"_""""_DataRuleValueDesc_""""_","
		 w """DataRuleRemarks"":"_""""_DataRuleRemarks_""""_","
		 w """subData"":["
		 
		 set isFirst=isFirst+1
		 
		 set isSubFirst=1
		 set subID=""
		 for
		 {
			 set subID=$o(^DtPortal.Configure.DataRuleD(rowID,"Item",subID))
			 quit:subID=""
			 
			 Set subObj=##class(DtPortal.Configure.DataRuleDictionaries).%OpenId(rowID_"||"_subID)
			 continue:'$IsObject(subObj)
			 
			 set DataDictValue=subObj.DataDictValue
			 set DataDictDesc=subObj.DataDictDesc
		
			 w:isSubFirst'=1 ","
			 w "{"
			 w """DataRuleCode"":"_""""_DataRuleCode_""""_","
			 w """DataRuleDesc"":"_""""_DataRuleDesc_""""_","
			 w """DataDictValue"":"_""""_DataDictValue_""""_","
			 w """DataDictDesc"":"_""""_DataDictDesc_""""
			 w "}" 
			 set isSubFirst=2
		 }
		 w "]}" 
		
	 }
	 
	 
	 w "]"
	q ""
}

/// Creator：     程鹏
/// CreatDate：   2018-09-26
/// Description:  导入数据
/// w ##Class(DtPortal.Configure.DataRule).locIndexInport("^13149^Doctor^医生^Y*^13501^DirectorDoctor^科主任^Y*^13147^NurseDepartment^护理部^Y*^13502^MedicalDepartment^医务部^Y*^13504^NurseHead^护士长^Y*^19701^OutpatientDepartment^门诊部^Y*^10165^User^普通用户^Y*^15526^CEO^院长^Y*^1066908^IPD^住院部^Y*^13503^Nurse^护士^Y(%)Doctor^医生^29^住院医师*DirectorDoctor^科主任^30^住院医师(主任)*NurseDepartment^护理部^69^护理部*NurseDepartment^护理部^117^护理部主任")
ClassMethod locIndexInport(inpotData) As %String
{
	set length=$l(inpotData,"*")
	quit:length=0 """"_0_"^"_"数据为空！！！"_""""
	
	k ^DtPortal.Configure.DataRuleD
	k ^DtPortal.Configure.DataRuleI
	
	set roleData=$p(inpotData,"(%)",1)
	set subRoleData=$p(inpotData,"(%)",2)

	set return="",isOk=0,ErrStr="",subIsOK=0,subErrStr=""
	for index=1:1:$l(roleData,"(*)")
	{
		set dataStr=$p(roleData,"(*)",index)
		continue:dataStr=""
		set dataStr=$tr(dataStr,"^",$c(9813))
		set dataStr=$tr(dataStr,$c(10),"/")

		s ret=..Update(dataStr,"(@)")
		set ^cheng("DataRule",index)=dataStr
		set roleDesc=$p(dataStr,"(@)",4)
		
		set:((ret=-1)&&(ErrStr'="")) ErrStr=ErrStr_"/"_roleDesc_"保存失败"
		set:((ret=-1)&&(ErrStr="")) ErrStr=roleDesc_"保存失败"
		
		set:((ret=0)&&(ErrStr'="")) ErrStr=ErrStr_"/"_roleDesc_"已存在"
		set:((ret=0)&&(ErrStr="")) ErrStr=roleDesc_"已存在"
		
		set:ret>0 isOk=+isOk+1
		
	}
	
	if subRoleData'=""
	{
		for index=1:1:$l(subRoleData,"(*)")
		{
			set dataStr=$p(subRoleData,"(*)",index)
			continue:dataStr=""
			
			set code=$p(dataStr,"(@)",1)
			set desc=$p(dataStr,"(@)",2)
			set DataDictValue=$p(dataStr,"(@)",3)
			set DataDictDesc=$p(dataStr,"(@)",4)
			
			set code=$$ALPHAUP^SSUTIL4(code)
			
			set rowID=$o(^DtPortal.Configure.DataRuleI("DataRuleCodeIndex"," "_code,""))
			if rowID="" 
			{
				set:subErrStr'="" subErrStr=subErrStr_"/"_DataDictDesc_"保存失败"_desc_"不存在"
				set:subErrStr'="" subErrStr=DataDictDesc_"保存失败"_desc_"不存在"
				continue
			}
			
			
			set subStrSave=rowID_"^^"_DataDictValue_"^"_DataDictDesc
			
			set subStr=##Class(DtPortal.Configure.DataRuleDictionaries).Update(subStrSave,"^")
			
			set:((subStr=-1)&&(subErrStr'="")) subErrStr=subErrStr_"/"_RoleDesc_groupDesc_"保存失败"
			set:((subStr=-1)&&(subErrStr="")) subErrStr=RoleDesc_groupDesc_"保存失败"
			
			set:((subStr=0)&&(subErrStr'="")) subErrStr=subErrStr_"/"_RoleDesc_groupDesc_"已存在"
			set:((subStr=0)&&(subErrStr="")) subErrStr=RoleDesc_groupDesc_"已存在"
			
			set:subStr>0 subIsOK=+subIsOK+1
			
		}
	}
	set return=""""_isOk_"^"_ErrStr_"^"_subIsOK_"^"_subErrStr_""""
	q return
}

Storage DataRuleSto
{
<Data name="DataRuleData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataRuleCode</Value>
</Value>
<Value name="3">
<Value>DataRuleDesc</Value>
</Value>
<Value name="4">
<Value>DataRuleType</Value>
</Value>
<Value name="5">
<Value>DataRuleValeType</Value>
</Value>
<Value name="6">
<Value>DataRuleValue</Value>
</Value>
<Value name="7">
<Value>DataRuleRemarks</Value>
</Value>
<Value name="8">
<Value>DataRuleUpdate</Value>
</Value>
<Value name="9">
<Value>DataRuleUpTime</Value>
</Value>
<Value name="10">
<Value>DataRuleRole</Value>
</Value>
</Data>
<DataLocation>^DtPortal.Configure.DataRuleD</DataLocation>
<DefaultData>DataRuleData</DefaultData>
<IdLocation>^DtPortal.Configure.DataRuleD</IdLocation>
<IndexLocation>^DtPortal.Configure.DataRuleI</IndexLocation>
<StreamLocation>^DtPortal.Configure.DataRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
