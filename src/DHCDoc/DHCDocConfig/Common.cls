/// creator:王清雍
/// date:2022-03-11
/// desc:表数据insert、update、delete、获取数据行json公共方法
/// Notice:所有json属性名称为User类的Property名称
Class DHCDoc.DHCDocConfig.Common Extends DHCDoc.Util.RegisteredObject
{

/// 获取User类表名称
ClassMethod GetTableName(ClsName)
{
	s ClsObj=##class(%Dictionary.ClassDefinition).%OpenId(ClsName)
	Q ClsObj.SqlTableName
}

/// 获取User类表Rowid字段名称
ClassMethod GetSqlRowIdName(ClsName)
{
    s ClsObj=##class(%Dictionary.ClassDefinition).%OpenId(ClsName)
	s SqlRowIdName=ClsObj.SqlRowIdName
    Q:SqlRowIdName'="" SqlRowIdName
    Q:'ClsObj.Storages.Count() ""
    s Storage=ClsObj.Storages.GetAt(1)
    s SqlRowIdName=Storage.SqlRowIdName
    s:SqlRowIdName="" SqlRowIdName=ClsObj.SqlRowIdName
    s:SqlRowIdName="" SqlRowIdName="ID"
    Q SqlRowIdName
}

/// 获取User类父表关联字段属性名称
ClassMethod GetParPropName(ClsName)
{
	s propName=""
	s clsObj=##class(%Dictionary.CompiledClass).%OpenId(ClsName)
	s propCount = clsObj.Properties.Count()
	for i=1:1:propCount {
		s propObj=clsObj.Properties.GetAt(i)
		continue:propObj.Origin'=ClsName
		if propObj.Cardinality="parent"{
			s propName=propObj.Name
			Q
		}
	}
	Q propName
}

/// 获取表某行数据json
/// input:User类名、rowid
/// w ##class(DHCDoc.DHCDocConfig.Common).GetRowData("User.OEOrdItem","6||1")
/// w ##class(DHCDoc.DHCDocConfig.Common).GetRowData("User.DHCQueue","1")
/// w ##class(DHCDoc.DHCDocConfig.Common).GetRowData("User.DHCItmMast","1")
ClassMethod GetRowData(ClsName, RowID, ReturnDataType = "", IDField = "ID")
{
	s row=##class(%DynamicObject).%New()
	d row.%Set(IDField,RowID)
	s obj=$ClassMethod(ClsName,"%OpenId",RowID)
	s clsObj=##class(%Dictionary.CompiledClass).%OpenId(ClsName)
	s propCount = clsObj.Properties.Count()
	f i=1:1:propCount {
		s propObj=clsObj.Properties.GetAt(i)
		continue:propObj.Relationship
		continue:propObj.Origin'=ClsName
		s propName=propObj.Name
		s dataType=propObj.Type
		s Collection=propObj.Collection
		s val=$PROPERTY(obj,propName)
		if $IsObject(val){
			if Collection="list" s val=val.GetAt(val.Count())
			else  s val=val.%Id()
		}else{
			i dataType="%Library.Date" s val=..%ZD(val)
			e  i dataType="%Library.Time" s val=..%ZT(val) 
		}
		d row.%Set(propName,val)
	}
	Q:$ZCVT(ReturnDataType,"U")="OBJ" row
	Q row.%ToJSON()
}

/// 获取列头
/// w ##class(DHCDoc.DHCDocConfig.Common).GetGridColumns("User.DHCPatListType")
ClassMethod GetGridColumns(ClsName)
{
	s rows=[]
	s obj={"field":"ID"}
	d obj.%Set("hidden",1,"boolean")
	d rows.%Push(obj)
	s tableObj=##class(%Dictionary.CompiledClass).%OpenId(ClsName)
	s myCount = tableObj.Properties.Count()
	f i=1:1:myCount {
		s mypropobj=tableObj.Properties.GetAt(i)
		continue:mypropobj.Origin'=ClsName
		s Field=mypropobj.Name
		s Title=mypropobj.Description
		s:Title="" Title=Field
		d rows.%Push({"field":(Field),"title":(Title)})
	}
	Q [].%Push(rows).%ToJSON()
}

/// json数据转表PLIST 用于PLIST快速插入或更新
/// w ##class(DHCDoc.DHCDocConfig.Common).JsonToPLIST(.PLIST,"User.OEOrdItem",{"OEORIOEORDParRef":1,"OEORIItmMastDR":"1||1","OEORISttDat":"2022-03-15","OEORISttTim":"08:00","OEORIDepProcNotes":"测试备注"})
ClassMethod JsonToPLIST(ByRef PLIST, ClsName, JsonObj)
{
	k PLIST
	s clsObj=##class(%Dictionary.CompiledClass).%OpenId(ClsName)
	s propCount = clsObj.Properties.Count()
	for i=1:1:propCount {
		s propObj=clsObj.Properties.GetAt(i)
		continue:propObj.Origin'=ClsName
		s propName=propObj.Name
		continue:'JsonObj.%IsDefined(propName)
		s val=JsonObj.%Get(propName)
		s dataType=propObj.Type
		i dataType="%Library.Date" s val=..%ZDH(val)
		e  i dataType="%Library.Time" s val=..%ZTH(val)
		if propObj.Cardinality="parent"{
			s PLIST(0)=val
		}
		s SqlColumnNumber=propObj.SqlColumnNumber
		continue:SqlColumnNumber=""
		s PLIST(SqlColumnNumber)=val
	}
	Q 0
}

/// 将表数据直接转JSON数据 
/// 一般用于datagrid快速呈现一些基础数据表
/// w ##class(DHCDoc.DHCDocConfig.Common).TableToJSON("User.DHCPatListType")
ClassMethod TableToJSON(ClsName)
{
	s retObj={"rows":[],"total":0}
	s SttIndex="",EndIndex=""
	if $D(%request){
		s rows=$g(%request.Data("rows",1))
	   	s page=$g(%request.Data("page",1))
	   	if (rows>0)&&(page>0){
			s SttIndex=rows*(page-1)+1
			s EndIndex=rows*page
		}
	}
	s RowIdName=..GetSqlRowIdName(ClsName)
	s TableName=..GetTableName(ClsName)
	s rs=##class(%ResultSet).%New()
	s sqlStr="SELECT "_RowIdName_" FROM SQLUser."_TableName_" WHERE "_RowIdName_">0"
	d rs.Prepare(sqlStr)
	s sc=rs.Execute()
	while rs.Next(){
		s retObj.total=retObj.total+1
		continue:((SttIndex'="")&&(retObj.total<SttIndex))||((EndIndex'="")&&(retObj.total>EndIndex))
		s RowId=rs.GetDataByName(RowIdName)
		s row=..GetRowData(ClsName,RowId,"OBJ")
		d retObj.rows.%Push(row)
	}
	Q retObj.%ToJSON()
}

/// 插入或新增表数据的公共方法
/// Input:User类名、json字符串或对象、json表示Rowid字段
/// w ##class(DHCDoc.DHCDocConfig.Common).SaveData($LG(^Wqy("SaveData"),1),$LG(^Wqy("SaveData"),2),$LG(^Wqy("SaveData"),3))
/// w ##class(DHCDoc.DHCDocConfig.Common).SaveData("User.OEOrdItem",[{"OEORIOEORDParRef":1,"OEORIItmMastDR":"1||1","OEORISttDat":"2022-03-15","OEORISttTim":"08:00","OEORIDepProcNotes":"测试备注"}].%ToJSON())
ClassMethod SaveData(ClsName, InputStr, IDField = "")
{
	;s ^Wqy("SaveData")=$LB(ClsName,InputStr,IDField)
	s:IDField="" IDField="ID"
	s err=0
	if $ClassName(InputStr)'="%Library.DynamicArray"{
		s rows=##class(%DynamicArray).%FromJSON(InputStr)
	}else{
		s rows=InputStr
	}
	s clsObj=##class(%Dictionary.CompiledClass).%OpenId(ClsName)
	s ParPropName=..GetParPropName(ClsName)
	s propCount = clsObj.Properties.Count()
	TS
	for i=1:1:rows.%Size(){
		s jsonObj=rows.%Get(i-1)
		s parVal=$CASE(ParPropName,"":"",:jsonObj.%Get(ParPropName))
		s IDFieldVal=jsonObj.%Get(IDField)
		if IDFieldVal=""{
			i parVal="" s obj=$ClassMethod(ClsName,"%New")
			e  s obj=$ClassMethod(ClsName,"%New",parVal)
		}else{
			s obj=$ClassMethod(ClsName,"%OpenId",IDFieldVal)
		}
		for j=1:1:propCount {
			s propObj=clsObj.Properties.GetAt(j)
			continue:propObj.Origin'=ClsName
			s propName=propObj.Name
			continue:'jsonObj.%IsDefined(propName)
			s val=jsonObj.%Get(propName)
			s dataType=propObj.Type
			s val=jsonObj.%Get(propName)
			i $E(dataType,1)'="%"{
				s val=$ClassMethod(dataType,"%OpenId",val)
			}
			i dataType="%Library.Date" s val=..%ZDH(val)
			e  i dataType="%Library.Time" s val=..%ZTH(val)
			s Collection=propObj.Collection
			if Collection="list"{
				x ("(obj,val)d obj."_propName_".Clear() d obj."_propName_".Insert(val)",obj,val)
			}else{
				x ("(obj,val)s obj."_propName_"=val",obj,val)
			}
		}
		s sc=obj.%Save()
		if $$$ISERR(sc){
			s err=$SYSTEM.Status.GetErrorText(sc)
			Q
		}
	}
	if err TRO
	else  TC
	Q err
}

/// w ##class(DHCDoc.Diagnos.SpecLocTemp).SaveData2010("User.DHCSpecLocDiagItem","[{""ID"":""14"",""Active"":""Y"",""CatDR"":4,""Code"":""ToothMap"",""Name"":""牙位图"",""Options"":""width:1050,height:350,frameborder:0,src:'emr.ip.tool.tooth.csp'"",""Sequence"":1,""Type"":""iframe""}]")
ClassMethod SaveData2010(TableName, InputStr)
{
	TS
	s rows=##class(DHCDoc.Util.FromJSON).%FromJSON(InputStr)
	s index="" for {
		s row=rows.GetNext(.index) Q:index=""
		k ParmArr
		d ##class(DHCDoc.Util.FromJSON).OutputJson(row,.ParmArr)
		if ParmArr("ID")=""{
			s obj=$ClassMethod(TableName,"%New")
		}else{
			s obj=$ClassMethod(TableName,"%OpenId",ParmArr("ID"))
		}
		d ..SetPropertyByArr(obj,.ParmArr)
		s sc=obj.%Save()
		if $$$ISERR(sc){
			s err=-1
			Q
		}
	}
	if err TRO
	else  TC
	Q err
}

ClassMethod SetPropertyByArr(ClassObj, ParmArr) [ ProcedureBlock = 0 ]
{
	s ClassName=$ClassName(ClassObj)
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	s myCount = myobj.Properties.Count()
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		continue:mypropobj.Origin'=ClassName
		s Name=mypropobj.Name
		s val=$G(ParmArr(Name))
		s dataType=mypropobj.Type
		if dataType="%Library.Date"{
			s val=##class(websys.Conversions).DateHtmlToLogical(val)	
		}
		if $E(dataType,1)="%"{
			x "s ClassObj."_Name_"=val"
		}else{
			x "d ClassObj."_Name_"SetObjectId(val)"
		}
	}
	Q 0
}

/// 删除表数据
/// Input:User类名,rowid
ClassMethod DeleteData(ClsName, ID)
{
	s sc=$ClassMethod(ClsName,"%Delete",$LB(ID))
	Q:$$$ISERR(sc) -1
	Q 0
}

Query QueryPropDisplay(ClsName, PropName, langid = "") As %Query(ROWSPEC = "id,text")
{
}

/// 获取表字段DISPLAY选项
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Common","QueryPropDisplay","User.DHCItmConflict","ITCLongConflictType")
ClassMethod QueryPropDisplayExecute(ByRef qHandle As %Binary, ClsName, PropName, langid = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	if langid="" s langid=..%LanguageID()
	s clsObj=##class(%Dictionary.CompiledClass).%OpenId(ClsName)
	s propCount = clsObj.Properties.Count()
	for i=1:1:propCount {
		s propObj=clsObj.Properties.GetAt(i)
		continue:(propObj.Name'=PropName)
		s Parameters=propObj.Parameters
		s DisplayStr=Parameters.GetAt("DISPLAYLIST")
		s ValueStr=Parameters.GetAt("VALUELIST")
		for j=1:1:$L(ValueStr,","){
			s id=$P(ValueStr,",",j)
			s text=$P(DisplayStr,",",j)
			s text=..%Translate("",text,langid)
			d rows.%Push($LB(id,text))
		}
		Q
	}
	Quit $$$OK
}

ClassMethod QueryPropDisplayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPropDisplayExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod StrToList(Str, Sep, ByRef PLIST)
{
	s Len=$L(Str,Sep)
	for i=1:1:Len{
		s val=$P(Str,Sep,i)
		continue:val=""
		s PLIST(val)=val
	}
	Q 0
}

ClassMethod ListToStr(ByRef PLIST, Sep)
{
	s Str=""
	s val="" for{
		s val=$O(PLIST(val)) Q:val=""
		i Str="" s Str=val
		e  s Str=Str_Sep_val
	}
	Q Str
}

Query QueryHospital() As %Query(ROWSPEC = "id,text,code")
{
}

ClassMethod QueryHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s rs=##class(%ResultSet).%New("web.DHCBL.CT.CTHospital:GetDataForCmb1")
	if rs.QueryIsValid(){
		d rs.Execute("","","","","")
		while rs.Next(){
			s id=rs.GetDataByName("HOSPRowId")
			s DateFrom=$P(^CT("HOSP",id),"^",9)
			continue:(DateFrom="")||(DateFrom>+$H)
			s DateTo=$P(^CT("HOSP",id),"^",10)
			continue:(DateTo'="")&&(DateTo<=+$H)
			s code=rs.GetDataByName("HOSPCode")
			s text=rs.GetDataByName("HOSPDesc")
			d rows.%Push($LB(id,text,code))
		}
	}
	Quit $$$OK
}

ClassMethod QueryHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHospitalExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryLoc(HospID = "", LocTypeStr = "", AdmTypeStr = "") As %Query(ROWSPEC = "id,text,alias")
{
}

/// Description:查询科室
/// Input:院区ID, LocTypeStr(查询指定科室类型串:E^W^D^OP^OR), AdmTypeStr(查询指定访问类型串:O^E^I)
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Common","QueryLoc","","")
ClassMethod QueryLocExecute(ByRef qHandle As %Binary, HospID = "", LocTypeStr = "", AdmTypeStr = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	if (HospID'=""){
		s id=0 for{
			s id=$O(^CTLOC(0,"Hosp",HospID,id)) Q:id=""
			d OneLoc
		}
	}else{
		s id=0 for{
			s id=$O(^CTLOC(id)) Q:id=""
			d OneLoc
		}
	}
	Quit $$$OK
OneLoc
	s DateTo=$P(^CTLOC(id),"^",25)
	Q:(DateTo'="")&&(DateTo<=+$H)
	if LocTypeStr'=""{
		s LocType=$P(^CTLOC(id),"^",13)
		Q:("^"_LocTypeStr_"^")'[("^"_LocType_"^")
	}
	if AdmTypeStr'=""{
		s Find=0 
		for i=1:1:$L(AdmTypeStr,"^"){
			s AdmType=$P(AdmTypeStr,"^",i)
			continue:AdmType=""
			if $D(^PAC("ADMLOC",0,"AdmType",AdmType,id)){
				s Find=1
				Q
			}
		}
		Q:'Find
	}
	s text=$P(^CTLOC(id),"^",2)
	s alias=$P(^CTLOC(id),"^",43)
	d rows.%Push($LB(id,text,alias))
	Q
}

ClassMethod QueryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryGroup(HospID = "") As %Query(ROWSPEC = "id,text,alias")
{
}

/// Description:查询安全组
/// Input:院区ID
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Common","QueryGroup",2)
ClassMethod QueryGroupExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s id=0 for{
		s id=$O(^SSU("SSGRP",id)) Q:id=""
		continue:(HospID'="")&&(##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",id,HospID)="N")
		s text=$P(^SSU("SSGRP",id),"^",1)
		continue:text["停用"
		continue:($P(^SSU("SSGRP",id),"^",151)="N")
		s alias=##class(ext.util.String).ToChineseSpell(text)
		d rows.%Push($LB(id,text,alias))
	}
	Quit $$$OK
}

ClassMethod QueryGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGroupExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod SaveMulDocConfig(InputStr, HospID = "")
{
	Q:(InputStr="") "-1^参数不能为空"
	if $ClassName(InputStr)'="%Library.DynamicObject"{
		s InputObj=##class(%DynamicObject).%FromJSON(InputStr)
	}else{
		s InputObj=InputStr
	}
	s Iterator=InputObj.%GetIterator()
	while Iterator.%GetNext(.Node,.Value){
		s rtn=##class(web.DHCDocConfig).SaveConfig2(Node,Value,HospID)
	}
	Q 0
}

/// w ##class(DHCDoc.DHCDocConfig.Common).GetMulDocConfig1(["SupplementMode","OrderLimit","NoFreeGcp"].%ToJSON(),28,2)
ClassMethod GetMulDocConfig(NodeStr, HospID = "")
{
	s retObj={}
	if $ClassName(NodeStr)'="%Library.DynamicArray"{
		s NodeArr=[].%FromJSON(NodeStr)
	}else{
		s NodeArr=NodeStr
	}
	s len=NodeArr.%Size()
	for i=1:1:len{
		s Node=NodeArr.%Get(i-1)
		s Value=..%GetConfig(Node,HospID)
		d retObj.%Set(Node,Value)
	}
	Q retObj.%ToJSON()
}

/// w ##class(DHCDoc.DHCDocConfig.Common).SaveMulDocConfig1({"SupplementMode":1}.%ToJSON(),28,2)
ClassMethod SaveMulDocConfig1(InputStr, SubNode, HospID = "")
{
	Q:(InputStr="")||(SubNode="") "-1^参数不能为空"
	if $ClassName(InputStr)'="%Library.DynamicObject"{
		s InputObj=##class(%DynamicObject).%FromJSON(InputStr)
	}else{
		s InputObj=InputStr
	}
	s Iterator=InputObj.%GetIterator()
	while Iterator.%GetNext(.Node,.Value){
		s rtn=##class(web.DHCDocConfig).SaveConfig1(Node,SubNode,Value,HospID)
	}
	Q 0
}

/// w ##class(DHCDoc.DHCDocConfig.Common).GetMulDocConfig1(["SupplementMode","OrderLimit","NoFreeGcp"].%ToJSON(),28,2)
ClassMethod GetMulDocConfig1(NodeStr, SubNode, HospID = "")
{
	s retObj={}
	if $ClassName(NodeStr)'="%Library.DynamicArray"{
		s NodeArr=[].%FromJSON(NodeStr)
	}else{
		s NodeArr=NodeStr
	}
	s len=NodeArr.%Size()
	for i=1:1:len{
		s Node=NodeArr.%Get(i-1)
		s Value=..%GetConfig1(Node,SubNode,HospID)
		d retObj.%Set(Node,Value)
	}
	Q retObj.%ToJSON()
}

ClassMethod SaveMulDocConfig2(InputStr, Node1, Node2, HospID = "")
{
	Q:(InputStr="")||(Node1="")||(Node2="") "-1^参数不能为空"
	if $ClassName(InputStr)'="%Library.DynamicObject"{
		s InputObj=##class(%DynamicArray).%FromJSON(InputStr)
	}else{
		s InputObj=InputStr
	}
	s Iterator=InputObj.%GetIterator()
	while Iterator.%GetNext(.Node,.Value){
		d ##class(web.DHCDocConfig).SetConfigNode3(Node1,Node2,Node,HospID,Value)
	}
	Q 0
}

ClassMethod GetMulDocConfig2(NodeStr, Node1, Node2, HospID = "")
{
	s retObj={}
	if $ClassName(NodeStr)'="%Library.DynamicArray"{
		s NodeArr=[].%FromJSON(NodeStr)
	}else{
		s NodeArr=NodeStr
	}
	s len=NodeArr.%Size()
	for i=1:1:len{
		s Node=NodeArr.%Get(i-1)
		s Value=##class(web.DHCDocConfig).GetConfigNode3(Node1, Node2,Node,HospID)
		d retObj.%Set(Node,Value)
	}
	Q retObj.%ToJSON()
}

}
