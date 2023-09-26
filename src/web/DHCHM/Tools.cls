/// 名称: web.DHCHM.Tools
/// 描述: HM简单工具使用
/// 编写者：wrz
/// 编写日期: 2010-09-17
Class web.DHCHM.Tools Extends web.DHCHM.Abstract [ Not ProcedureBlock ]
{

//字符替换

//##class(web.DHCHM.Tools).Replace(expression,find,replacewith)

ClassMethod Replace(expression As %String, find As %String, replacewith As %String) As %String [ Language = basic ]
{
	return Replace(expression,find,replacewith)
}

//去除两端的空格

//##class(web.DHCHM.Tools).Trim(expression)

ClassMethod Trim(expression As %String) As %String [ Language = basic ]
{
	return Trim(expression)
}

//给字符增加单引号

//##class(web.DHCHM.Tools).AddSQM(expression)

ClassMethod AddSQM(str)
{
	s str=..Replace(str,$c(13),"\r")
	s str=..Replace(str,$c(10),"\n")
	s str=..Replace(str,"'","\'")
	q "'"_str_"'"
}

//w ##class(web.DHCHM.Tools).ChangeToArrStr("1^2%3^4","%","^")

ClassMethod ChangeToArrStr(Str, char1, char2)
{
	s arrStr="["
	s i=$L(Str,char1)
	f j=1:1:i d
	.s oneStr=$p(Str,char1,j)
	.s id=##class(web.DHCHM.Tools).AddSQM($p(oneStr,char2,1))
	.s desc=##class(web.DHCHM.Tools).AddSQM($p(oneStr,char2,2))
	.i arrStr="[" d
	..s arrStr=arrStr_"["_id_","_desc_"]"
	.e  d
	..s arrStr=arrStr_",["_id_","_desc_"]"
	s arrStr=arrStr_"]"
	q arrStr
}

//根据类名得到类的属性

//w ##class(web.DHCHM.Tools).GetPros("User.DHCHMCHumanClass","")

ClassMethod GetPros(clsName, name As %String = "") As %String
{
	n (clsName,name)
	q:clsName="User.SSUser" "SSUSRName"
	q:clsName="User.CTLoc" "CTLOCDesc"
	q:clsName="User.CTHospital" "HOSPDesc"
	q:##class(%Library.ClassDefinition).%ExistsId(clsName)=0 ""
	s rStr=""
	s clsDef=##class(%Library.ClassDefinition).%OpenId(clsName)
	s clsProList=clsDef.Properties
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proName=clsPro.Name
		continue:proName["%"
		continue:clsPro.Cardinality="children"
		;continue:clsPro.Cardinality="parent"
		continue:((name'="")&&((proName'["Desc")&&(proName'["Name")))
		i rStr="" d
		.s rStr=proName
		e  d
		.s rStr=rStr_"^"_proName
	}
	d clsDef.%Close()
	q rStr
}

//根据类名、query名，创建query

//w ##class(web.DHCHM.Tools).CreateQuery("User.DHCHMOQMedicalTips","MedicalTips")

ClassMethod CreateQuery(clsName, queryName, paras As %String = "")
{
	
	n (clsName,queryName,paras)
	set (rowspec,gblInfo,setdata)=""
	d ..GetRowSpec(clsName,.rowspec,.gblInfo,.setdata)
	s rowspec="ID:%String:ID"_rowspec
	s resetData=$E(setdata,2,$l(setdata))
	s setdata="ID"_setdata
	set gblname=clsName_"D"
	///生成接口
	set tmp="Query "_queryName_"("_paras_") As %Query(ROWSPEC = "_""""_rowspec_""""_")"_$c(13)_$c(10)
	set tmp=tmp_"{"_$c(13)_$c(10)
	set tmp=tmp_"}"_$c(13)_$c(10)
	set tmp=tmp_$c(13)_$c(10)
	///生成执行实体	
	set tmp=tmp_"ClassMethod "_queryName_"Execute(ByRef qHandle As %Binary"
	i paras'="" d
	.s tmp=tmp_","_" "_paras
	s tmp=tmp_") As %Status"_$c(13)_$c(10)
	s tmp=tmp_"{"_$c(13)_$c(10)
	
	set tmp=tmp_" 	new repid, index,ID"_$c(13)_$c(10)
	set tmp=tmp_"	Set repid=$I(^CacheTemp)"_$c(13)_$c(10)
	set tmp=tmp_" 	Set qHandle=$lb(0,repid,0)"_$c(13)_$c(10)
	set tmp=tmp_"	s index=1"_$c(13)_$c(10)
	set tmp=tmp_"	s ID=0"_$c(13)_$c(10)
	set tmp=tmp_"	f  s ID=$o(^"_gblname_"(ID))  quit:ID="_""""""_"  d"_$c(13)_$c(10)
	
	set tmp=tmp_"	.d BuildData"_queryName_$c(13)_$c(10)
	set tmp=tmp_"	Quit $$$OK"_$c(13)_$c(10)
	
	set tmp=tmp_"BuildData"_queryName_$c(13)_$c(10)
	set tmp=tmp_"	d ResetVariables"_queryName_$c(13)_$c(10)
	set tmp=tmp_gblInfo
	set tmp=tmp_"	d OutputRow"_queryName_$c(13)_$c(10)
	set tmp=tmp_"	quit"_$c(13)_$c(10)
	
	set tmp=tmp_"OutputRow"_queryName_$c(13)_$c(10)
	set tmp=tmp_"	s Data=$lb("_setdata_")"_$c(13)_$c(10)
	set tmp=tmp_"	Set ^CacheTemp(repid,index)=Data"_$c(13)_$c(10)
	set tmp=tmp_"	Set index=index+1"_$c(13)_$c(10)
	set tmp=tmp_"	quit"_$c(13)_$c(10)
	
	set tmp=tmp_"ResetVariables"_queryName_$c(13)_$c(10)
	set tmp=tmp_"	s ("_resetData_")="""""_$c(13)_$c(10)
	set tmp=tmp_"	quit"_$c(13)_$c(10)	
	
	
	set tmp=tmp_"}"_$c(13)_$c(10)
	set tmp=tmp_$c(13)_$c(10)
	///生成Fetch
	set tmp=tmp_"ClassMethod "_queryName_"Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = "_queryName_"Execute ]"_$c(13)_$c(10)
	set tmp=tmp_"{"_$c(13)_$c(10)	
	set tmp=tmp_"	Set AtEnd=$LIST(qHandle,1)"_$c(13)_$c(10)
	set tmp=tmp_" 	Set repid=$LIST(qHandle,2)"_$c(13)_$c(10)
	set tmp=tmp_" 	Set ind=$LIST(qHandle,3)"_$c(13)_$c(10)
	set tmp=tmp_" 	Set ind=$o(^CacheTemp(repid,ind))"_$c(13)_$c(10)
	set tmp=tmp_" 	If ind="""" {"_$c(13)_$c(10)
	set tmp=tmp_" 		Set AtEnd=1"_$c(13)_$c(10)
	set tmp=tmp_" 		Set Row="""""_$c(13)_$c(10)
	set tmp=tmp_" 		}"_$c(13)_$c(10)
	set tmp=tmp_" 	Else      {"_$c(13)_$c(10)
	set tmp=tmp_" 		Set Row=^CacheTemp(repid,ind)"_$c(13)_$c(10)
	set tmp=tmp_" 		}"_$c(13)_$c(10)
	set tmp=tmp_"	s qHandle=$lb(AtEnd,repid,ind)"_$c(13)_$c(10)
	set tmp=tmp_"	Quit $$$OK"_$c(13)_$c(10)
	set tmp=tmp_"}"_$c(13)_$c(10)
	set tmp=tmp_$c(13)_$c(10)
	///生成Close
	set tmp=tmp_"ClassMethod "_queryName_"Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = "_queryName_"Execute ]"_$c(13)_$c(10)
	set tmp=tmp_"{"_$c(13)_$c(10)	
	set tmp=tmp_"	Set repid=$LIST(qHandle,2)"_$c(13)_$c(10)
	set tmp=tmp_" 	Kill ^CacheTemp(repid)"_$c(13)_$c(10)
	set tmp=tmp_" 	Quit $$$OK"_$c(13)_$c(10)	
	set tmp=tmp_"}"_$c(13)_$c(10)
	//set tmp=tmp_$c(13)_$c(10)

	d ..WriteFile("C:\DHCHM\Query\"_clsName_"_"_queryName_".txt",tmp,1)
	Quit "" //tmp
}

//w ##class(web.DHCHM.Tools).GetRowSpec("User.DHCHMOBaseInfo",rowSpec,gblInfo,setData)

ClassMethod GetRowSpec(clsName As %String, rowSpec As %String, gblInfo As %String, setData As %String)
{
	
	n (clsName,rowSpec,gblInfo,setData)
	s (rowSpec,gblInfo,setData)=""
	s clsDef=##class(%Library.ClassDefinition).%OpenId(clsName)
	s clsProList=clsDef.Properties
	s gblInfo=gblInfo_"	s obj=##class("_clsName_").%OpenId(ID)"_$c(13)_$c(10)
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proName=clsPro.Name
		continue:proName["%"
		continue:clsPro.Cardinality="children"
		continue:clsPro.Cardinality="parent"
		s rowSpec=rowSpec_","_proName_":%String:"_proName
		s setData=setData_","_proName
		s childPro=""
		s cls=clsPro.Type
		i cls["%" d
		.i cls="%Date" d
		..s gblInfo=gblInfo_"	s "_proName_" = ..TransDateToPage(obj."_proName_",3)"_$c(13)_$c(10)
		.e  d
		..s gblInfo=gblInfo_"	s "_proName_" = obj."_proName_$c(13)_$c(10)
		e  d
		.s childPro=..GetPros(cls,"Desc")
		.s gblInfo=gblInfo_"	i $ISOBJECT(obj."_proName_") d"_$c(13)_$c(10)
		.s gblInfo=gblInfo_"	.s "_proName_" = obj."_proName_".%Id()"_$c(13)_$c(10)
		.s gblInfo=gblInfo_"	.i "_proName_" '= """" d"_$c(13)_$c(10)
		.s gblInfo=gblInfo_"	..s "_childPro_"=obj."_proName_"."_childPro_$c(13)_$c(10)
		
		i childPro'="" s rowSpec=rowSpec_","_childPro_":%String:"_childPro
		i childPro'="" s setData=setData_","_childPro
	}
}

//写文件

ClassMethod WriteFile(fileName As %String, content As %String, isNew As %String = "0")
{
	new results,opentype
	///If ##class(%File).Exists(fileName) Write "It exists",!
	Set file=##class(%File).%New(fileName)
	set opentype="WS"
	if (isNew=1) set opentype="WSN"
	Do file.Open(opentype)
	set results = file.Write(content)
	if (results'=1) d ##class(%File).Delete(fileName)
	d file.Close()
	q results
}

//读文件

//d ##class(web.DHCHM.Tools).ReadFile("F:\Setting.txt")

ClassMethod ReadFile(fileName As %String)
{
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=fileName
	While 'stream.AtEnd {
	Set line=stream.ReadLine()
	w line,!
	}
}

//d ##class(web.DHCHM.Tools).RebuildIndex("User.DHCHMOQEvaluation")

ClassMethod RebuildIndex(userName)
{
	d $ZOBJCLASSMETHOD(userName,"%BuildIndices")
	//d ##class(User.DHCHMOEvaluationRecord).%BuildIndices()
}

//登记号补零

ClassMethod RegNoMask(RegNo)
{
	s length=0
	s sID=$O(^User.DHCHMCSettingI("SCodeIndex"," 90010002",0))
	i sID'="" d
	.s obj=##class(User.DHCHMCSetting).GetObj(sID)
	.s length=+obj.SValue
	i length=0 s length=10
	s ZeroStr=$E("00000000000000000000000000",1,length)
	s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
	q RegNo
}

//清除健康管理数据

//d ##class(web.DHCHM.Tools).DHCHMInit("Y")

ClassMethod DHCHMInit(DeleteBaseCode As %String = "N")
{
	
	//select * from DHC_HM_CSetting order by S_Code,STypeCode
	//d ##class(User.DHCHMCSetting).SaveData("","70010001^^评估问卷记录DHC_HM_OQEQuestion^^7001^","SCode^SOrder^SRemark^STable^STypeCode^SValue")
	//d ##class(User.DHCHMCSetting).SaveData(157,"Y","SValue")
	/*
	k ^User.DHCHMCSettingD
	k ^User.DHCHMCSettingI
	k ^User.DHCHMCSettingS
	*/
	i DeleteBaseCode="Y" {
		k ^User.DHCHMCCodeTableD
		k ^User.DHCHMCCodeTableI
		k ^User.DHCHMCCodeTableS
		
		k ^User.DHCHMCPlainnessD
		k ^User.DHCHMCPlainnessI
		k ^User.DHCHMCPlainnessS
		
		k ^User.DHCHMCClassLevelD
		k ^User.DHCHMCClassLevelI
		k ^User.DHCHMCClassLevelS
		
		k ^User.DHCHMCHumanClassD
		k ^User.DHCHMCHumanClassI
		k ^User.DHCHMCHumanClassS
		
		k ^User.DHCHMCQuestionsDetailD
		k ^User.DHCHMCQuestionsDetailI
		k ^User.DHCHMCQuestionsDetailS
		k ^User.DHCHMCQuestionsDetailC("QDOptions")
		k ^User.DHCHMCQDOptionsI
		k ^User.DHCHMCQDOptionsS
		
		k ^User.DHCHMCEvaluationDetailD
		k ^User.DHCHMCEvaluationDetailI
		k ^User.DHCHMCEvaluationDetailS
	
		k ^User.DHCHMCQuestionnaireD
		k ^User.DHCHMCQuestionnaireI
		k ^User.DHCHMCQuestionnaireS
		k ^User.DHCHMCQuestionnaireC("QSubject")
		k ^User.DHCHMCQuestionSubjectI
		k ^User.DHCHMCQuestionSubjectS
		k ^User.DHCHMCQuestionSubjectC("QSDLink")
		k ^User.DHCHMCSDLinkI
		k ^User.DHCHMCSDLinkS
		k ^User.DHCHMCQuestionnaireC("QEDLink")
		k ^User.DHCHMCQEDLinkI
		k ^User.DHCHMCQEDLinkS
	
		k ^User.DHCHMCServiceClassD
		k ^User.DHCHMCServiceClassI
		k ^User.DHCHMCServiceClassS
		k ^User.DHCHMCServiceClassC("DHCHMCSCQLink")
		k ^User.DHCHMCSCQLinkI
		k ^User.DHCHMCSCQLinkS
		
		k ^User.DHCHMCMedicalTipsD
		k ^User.DHCHMCMedicalTipsI
		k ^User.DHCHMCMedicalTipsS
	
		k ^User.DHCHMCMedicalStandardsD
		k ^User.DHCHMCMedicalStandardsI
		k ^User.DHCHMCMedicalStandardsS
		
		k ^User.DHCHMCMagazineD
		k ^User.DHCHMCMagazineI
		k ^User.DHCHMCMagazineS
		
		k ^User.DHCHMCExpressionD
		k ^User.DHCHMCExpressionI
		k ^User.DHCHMCExpressionS
	
		k ^User.DHCHMCAliasD
		k ^User.DHCHMCAliasI
		k ^User.DHCHMCAliasS
	}
	k ^User.DHCHMOBaseInfoD
	k ^User.DHCHMOBaseInfoI
	k ^User.DHCHMOBaseInfoS
	
	//编码设置为初始值
	s id=$O(^User.DHCHMCSettingI("SCodeIndex"," 90010001",0))
	I id'="" D
	.d ##class(User.DHCHMCSetting).SaveData(id,"0","SValue")
	
	k ^User.DHCHMOEvaluationRecordD
	k ^User.DHCHMOEvaluationRecordI
	k ^User.DHCHMOEvaluationRecordS
	k ^User.DHCHMOQEQuestionD
	k ^User.DHCHMOQEQuestionI
	k ^User.DHCHMOQEQuestionS
	k ^User.DHCHMOQEQuestionC("DHCHMOQResult")
	k ^User.DHCHMOQResultI
	k ^User.DHCHMOQResultS
	k ^User.DHCHMOQEQuestionC("DHCHMOQEvaluation")
	k ^User.DHCHMOQEvaluationI
	k ^User.DHCHMOQEvaluationS
	k ^User.DHCHMOQEQuestionC("DHCHMOQMedicalTips")
	k ^User.DHCHMOQMedicalTipsI
	k ^User.DHCHMOQMedicalTipsS
	
	k ^User.DHCHMOUserMessageD
	k ^User.DHCHMOUserMessageI
	k ^User.DHCHMOUserMessageS
	
	k ^User.DHCHMOUserLogD
	k ^User.DHCHMOUserLogI
	k ^User.DHCHMOUserLogS
	
	
	k ^User.DHCHMOMagazineSendDetailD
	k ^User.DHCHMOMagazineSendDetailI
	k ^User.DHCHMOMagazineSendDetailS
	k ^User.DHCHMOMagazineSendMainD
	k ^User.DHCHMOMagazineSendMainI
	k ^User.DHCHMOMagazineSendMainS
	
	k ^User.DHCHMOMessageSendDetailD
	k ^User.DHCHMOMessageSendDetailI
	k ^User.DHCHMOMessageSendDetailS
	k ^User.DHCHMOMessageSendMainD
	k ^User.DHCHMOMessageSendMainI
	k ^User.DHCHMOMessageSendMainS
}

//d ##class(web.DHCHM.Tools).SaveSetting("","10031010^^中医体质级别^^1003^")

//d ##class(web.DHCHM.Tools).SaveSetting("151","5")

ClassMethod SaveSetting(ID, value)
{
	//s proStr="SCode^SOrder^SRemark^STable^STypeCode^SValue"
	s proStr="SOrder"
	w ##class(User.DHCHMCSetting).SaveData(ID,value,proStr)
}

//d ##class(web.DHCHM.Tools).CopyOption()

ClassMethod CopyOption()
{
	f j=50:1:78  d
	.s toCode="zy030"_j
	.d ..CopyOption2("zy03001",toCode)
}

ClassMethod CopyOption2(source, to)
{
	s source=$ZCVT(source,"U")
	s to=$ZCVT(to,"U")
	s sourceID=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_source,0))
	q:sourceID="" source_"源不存在"
	s toID=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_to,0))
	q:toID="" to_"目标不存在"
	//s obj=##class(User.DHCHMCQDOptions).GetObj(sourceID)
	s SQLCODE=0
	s Flag=0
	s sub=0
	f  s sub=$O(^User.DHCHMCQuestionsDetailD(sourceID,"QDOptions",sub)) q:(sub="")||(Flag<0)  d
	.s sourceOID=sourceID_"||"_sub
	.s obj=##class(User.DHCHMCQDOptions).GetObj(sourceOID)
	.s propertieStr="QDOParRef^QDODesc^QDOOrder^QDOClass^QDOSex^QDOActive^QDODefault^QDONote"
	.s valueStr=toID_"^"_obj.QDODesc_"^"_obj.QDOOrder_"^"_obj.QDOClass_"^"_obj.QDOSex_"^"_obj.QDOActive_"^"_obj.QDODefault_"^"_obj.QDONote
	.s rstr=##class(User.DHCHMCQDOptions).SaveData("",valueStr,propertieStr)
	.s Flag=+rstr
	q:Flag<0 to_"保存错误,错误号:"_SQLCODE
}

ClassMethod Test()
{
	
	
	s i=10
	f j=1:1:i
	{
		w j,!
		i j=4 goto Err
	}
	q "Over"
Err
	q "Err"
}

Storage Default
{
<Data name="ToolsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCHM.ToolsD</DataLocation>
<DefaultData>ToolsDefaultData</DefaultData>
<IdLocation>^web.DHCHM.ToolsD</IdLocation>
<IndexLocation>^web.DHCHM.ToolsI</IndexLocation>
<StreamLocation>^web.DHCHM.ToolsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
