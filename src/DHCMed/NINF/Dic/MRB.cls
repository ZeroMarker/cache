/// 名称: DHCMed.NINF.Dic.MRB
/// 描述: 多重耐药菌定义
/// 编写者：wuqk
/// 编写日期: 2013-02-25
Class DHCMed.NINF.Dic.MRB Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// Code 代码
Property Code As %Library.String(TRUNCATE = 1);

/// Desc 描述
Property Description As %Library.String(TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

/// 病原体大类代码 
Property PYCategory As %String(TRUNCATE = 1);

/// 病原体子类代码 
Property PYSubCate As %String(TRUNCATE = 1);

/// 病原体
Property Pathogeny As %String(TRUNCATE = 1);

/// 根据抗生素大类定义
/// format: AntiCategory = $lb(active,count,$lb(cateid1,cateid2,cateid......))
Property AntiCategory As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 根据抗生素子类定义
/// format: AntiSubCate = $lb(active,count,$lb(subcateid1,subcateid2,subcateid......))
Property AntiSubCate As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 根据抗生素定义
/// format: Antibiotics = $lb(active,count,$lb(WHONET1,WHONET2,WHONET......))
Property Antibiotics As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 备注
Property Resume As %String(TRUNCATE = 1);

Index IndexOfCode On Code [ Unique ];

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Dic.MRB
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:Code 3:Description 4:Type 5:HospitalDr 6:Active 7:DateFrom 8:DateTo
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..Active_separete
	set return=return_..PYCategory_"!!"
	if (..PYCategory'=""){
		set objDic=##class(DHCMed.NINF.Dic.Cate).GetObjById(..PYCategory)
		if $IsObject(objDic){set return=return_objDic.Description}
	}
	set return=return_separete	
	
	set return=return_..PYSubCate_"!!"
	if (..PYSubCate'=""){
		set objDic=##class(DHCMed.NINF.Dic.Cate).GetObjById(..PYSubCate)
		if $IsObject(objDic){set return=return_objDic.Description}
	}
	set return=return_separete
	
	set return=return_..Pathogeny_"!!"
	if (..Pathogeny'=""){
		set objDic=##class(DHCMed.NINF.Dic.CateItem).GetObjById(..Pathogeny)
		if $IsObject(objDic){set return=return_objDic.Description}
	}
	set return=return_separete
	
	set return=return_..ENCodeList(..AntiCategory,"Cate")_separete
	set return=return_..ENCodeList(..AntiSubCate,"SubCate")_separete
	set return=return_..ENCodeList(..Antibiotics,"Anti")_separete
	set return=return_..Resume	
	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2013-03-08
/// Description:  将List转换为字符串
/// Input：       list:    AntiCategory =  $lb(active,count,$lb(cateid1,cateid2,cateid......))
///               type:    Cate\SubCate\Anti
/// Return：      返回obj.ToString()
///               active_$c(2)_count_$c(2)_id1_"/"_name1_","_id2_"/"_name2......
/// w ##class(DHCMed.NINF.Dic.MRB).EnCodeList(AntiCategory)
ClassMethod ENCodeList(list As %String, type) As %String
{
	new (list,type)
	set ret = ""
	quit:(list = "") ret
	//set len = $ll(list)
	set ret = $li(list,1)_$c(2)         //active
	set ret = ret_$li(list,2)_$c(2)     //count
	set data = $li(list,3)
	quit:data="" ret
	quit:data=$lb() ret
	//quit:'$lv(data) ret
	
	set len = $ll(data)                 //data
	
	set datastr=""
	for i=1:1:len {
		set d = $li(data,i)
		set n = ""
		if (d=""){}
		elseif (type="Cate")||(type="SubCate"){
			set objCate=##class(DHCMed.NINF.Dic.Cate).GetObjById(+d)
			if $IsObject(objCate){
				set n=objCate.Description
			}
		}
		elseif (type="Anti"){
			set objAnti=##class(DHCMed.NINF.Dic.CateItem).GetObjById(+d)
			if $IsObject(objAnti){
				set n=objAnti.Description
			}
		}
		set datastr = datastr_","_d_"!!"_n
		//w !,d_"/"_n_","
	}
	set:datastr'="" datastr=$e(datastr,2,$l(datastr))
	
	set ret=ret_datastr
	quit ret
}

/// Creator：     wuqk
/// CreatDate：   2013-03-08
/// Description:  将字符串转换为List
/// Input：       data:    active_$c(2)_count_$c(2)_id1_","_id2_","......
/// Return：      返回 $lb(active,count,$lb(cateid1,cateid2,cateid......))
/// w ##class(DHCMed.NINF.Dic.MRB).DECodeList(str)
ClassMethod DECodeList(str As %String) As %String
{
	new (str)
	set ret = ""
	quit:(str = "") ret
	
	//set ind = $o(^tt(""),-1)
	//set d = $i(^tt(ind))
	//set ^tt(ind,d,"1str")=str
	set active = +$p(str,$c(2),1)
	quit:active=0 ret
	set count = +$p(str,$c(2),2)
	set:count<1 count=1
	set data = $p(str,$c(2),3)
	set cate = $lb() //""
	//set:data'="" cate = $lb()
	set pos=1
	for i=1:1:$l(data,",") {
		if $p(data,",",1)'="" {
			set $li(cate,pos)=$p(data,",",i)
			set pos=pos+1
		}
	}
	set ret = $lb(active,count,cate) 
	//set ^tt(ind,d,"2ret")=ret
	quit ret
}

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  根据ID取分类对象
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       ID:    DHCMed.NINF.Dic.MRB.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Dic.MRB).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Dic.MRB
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Dic.MRB).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Dic.MRB).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  根据ID取分类信息
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       ID:    DHCMed.NINF.Dic.Cate.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Dic.MRB).GetStringById(8)
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

/// Creator：     wuqk
/// CreatDate：   2013-02-25
/// Description:  更新分类
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Code 3:Description 4:Type 5:HospitalDr 6:Active 7:DateFrom 8:DateTo
/// w ##class(DHCMed.NINF.Dic.MRB).Update("^EpdemicType^传染病类别^SYS^^1^^^^EPD","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	Set ID=$p(InStr,separete,1)
	Set Code=$p(InStr,separete,2)
	Set Desc=$p(InStr,separete,3)
	Set IsActive=$p(InStr,separete,4)
	Set PYCategory=$p(InStr,separete,5)
	Set:(+PYCategory)<1 PYCategory=""
	Set PYSubCate=$p(InStr,separete,6)
	Set:(+PYSubCate)<1 PYSubCate=""
	Set PathogenyID=$p(InStr,separete,7)
	Set:(+PathogenyID)<1 PathogenyID=""
	Set AntiCategory=$p(InStr,separete,8)
	Set AntiSubCate=$p(InStr,separete,9)
	Set AntiCode=$p(InStr,separete,10)
	Set Resume=$p(InStr,separete,11)
	
	//=====Modified By LiYang 2014-11-02 FixBug:3821 医院感染管理-全院综合性监测-基础数据维护-系统字典维护-系统字典-多重耐药菌-代码重复更新提示“SyntaxError:无效字符”
	Set tID=$o(^DHCMed.NINFDi("MRB",0,"IndexOfCode"," "_$ZCVT(Code,"U"),""))
	Quit:(tID'=ID) -2
	//=====
	
	If ID="" {
		Set obj=##class(DHCMed.NINF.Dic.MRB).%New()
	}Else{
		Set obj=##class(DHCMed.NINF.Dic.MRB).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Code=Code
	Set obj.Description=Desc
	Set obj.Active=IsActive
	Set obj.PYCategory = PYCategory
	Set obj.PYSubCate = PYSubCate
	Set obj.Pathogeny = PathogenyID
	Set obj.AntiCategory = ..DECodeList(AntiCategory)
	Set obj.AntiSubCate = ..DECodeList(AntiSubCate)
	Set obj.Antibiotics = ..DECodeList(AntiCode)
	Set obj.Resume = Resume
	
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

/// Creator：     zhufei
/// CreatDate：   2013-04-12
/// D ##class(%ResultSet).RunQuery("DHCMed.NINF.Dic.MRB","QueryAll")
Query QueryAll() As %Query(ROWSPEC = "ID:%String,Active:%String,Code:%String,Description:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary, DicType As %String, IsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	set id = ""
 	for {
		set id=$o(^DHCMed.NINFD("MRB",id))
		quit:id=""
		
		set obj=..GetObjById(id)
		if $IsObject(obj) {
		 	set Active=obj.Active
		 	set Code=obj.Code
		 	set Description=obj.Description
		 	set Resume=obj.Resume
		 	set Data=$lb(id,Active,Code,Description,Resume)
		 	set ^CacheTemp(repid,ind)=Data
		 	set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="MRBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>PYCategory</Value>
</Value>
<Value name="6">
<Value>PYSubCate</Value>
</Value>
<Value name="7">
<Value>Pathogeny</Value>
</Value>
<Value name="8">
<Value>AntiCategory</Value>
</Value>
<Value name="9">
<Value>AntiSubCate</Value>
</Value>
<Value name="10">
<Value>Antibiotics</Value>
</Value>
<Value name="11">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("MRB")</DataLocation>
<DefaultData>MRBDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("MRB")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("MRB",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.MRBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
