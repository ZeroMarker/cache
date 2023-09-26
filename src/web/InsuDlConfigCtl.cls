Import SQLUser

/// 医保下载通用配置业务处理类
Class web.InsuDlConfigCtl Extends %RegisteredObject
{

/// Creator：      许斌斌
/// CreatDate：    2020-03-09
/// Description:： 获得配置表中医保类型
/// Table：        
/// Input：        
/// Output：       
/// 			Ind  序号
/// 			InsuCode    医保类型代码
/// 		    InsuDec    医保类型描述
/// Return：       无
/// Others：    debug：d ##class(%ResultSet).RunQuery("web.InsuDlConfigCtl","GetInsuDLConfigInfo","ZZB","User.InsuTaritemsDL")
Query GetInsuDLConfigInfo(InsuType As %String, TableCode As %String) As %Query(ROWSPEC = "id,ColProCode:%String,ColProName:%String,NotUpateFlg:%String,CompareFlg:%String,NullCheckFlg:%String,ShowIndex:%String,DataType:%String,OptionVales:%String,ExtStr1:%String,ExtStr2:%String,ExtStr3:%String,ExtStr4:%String,ExtStr5:%String,ShowIndexValue:%String")
{
}

ClassMethod GetInsuDLConfigInfoExecute(ByRef qHandle As %Binary, InsuType As %String, TableCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    if $g(InsuType)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    if $g(TableCode)=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    k ^TMPGetInsuDLConfigInfo
    k ^TMPGetInsuDLConfigInfoNew
 	set tempObj=##class(%Dictionary.CompiledClass).%OpenId(TableCode)
 	set maxShowIndex=0,j=1,lenth=0
	for i=1:1:tempObj.Properties.Count() {
		set property=tempObj.Properties.GetAt(i)
		set name=property.Name
		s id=$o(^User.InsuDLConfigI("IDataKey",InsuType,TableCode,name,""))
		if id'=""{
			s objInsuDlConfig=##class(User.InsuDLConfig).%OpenId(id)
			if $isobject(objInsuDlConfig)'=0 {
				set ColProCode=objInsuDlConfig.ColProCode
      	    	set ColProName=objInsuDlConfig.ColProName
   	        	set NotUpateFlg=objInsuDlConfig.NotUpateFlg
   	        	set CompareFlg=objInsuDlConfig.CompareFlg
   	        	set NullCheckFlg=objInsuDlConfig.NullCheckFlg
   	        	set ShowIndex=objInsuDlConfig.ShowIndex
   	        	set DataType=objInsuDlConfig.DataType
   	        	set DataType=$SELECT(DataType="String":"文本类型",DataType="Date":"日期类型",DataType="Time":"时间类型",DataType="Integer":"数字类型")
   	        	set OptionVales=objInsuDlConfig.OptionVales
   	        	set ExtStr1=objInsuDlConfig.ExtStr1
   	        	set ExtStr2=objInsuDlConfig.ExtStr2
   	        	set ExtStr3=objInsuDlConfig.ExtStr3
   	        	set ExtStr4=objInsuDlConfig.ExtStr4
   	        	set ExtStr5=objInsuDlConfig.ExtStr5
   	        	set:maxShowIndex<ShowIndex maxShowIndex=ShowIndex
   	        	set ^TMPGetInsuDLConfigInfo($j,ShowIndex)=$lb(id,ColProCode,ColProName,NotUpateFlg,CompareFlg,NullCheckFlg,ShowIndex,DataType,OptionVales,ExtStr1,ExtStr2,ExtStr3,ExtStr4,ExtStr5,ShowIndex)
			}
		}elseif name'["%" {  //过滤掉系统变量
			set ColProCode=name
			set ColProName=property.Parameters.GetAt("CAPTION")
			set DataType=$p(property.Type,".",2)
			set ^TMPGetInsuDLConfigInfoNew($j,j)=ColProCode_"^"_ColProName_"^"_DataType
			set j=j+1
		}  
		
	}
	
	set index=1,lenth=$o(^TMPGetInsuDLConfigInfoNew($j,""),-1)
	for index=1:1:lenth{  //将新添加的数据列信息存在配置表中
		set NewInfo=$g(^TMPGetInsuDLConfigInfoNew($j,index))
		set ColProCode=$p(NewInfo,"^",1)
      	set ColProName=$p(NewInfo,"^",2)
      	set Data=$p(NewInfo,"^",3)
		do SaveNewConfigInfo
	}
   	set index=""
   	for  set index=$o(^TMPGetInsuDLConfigInfo($j,index)) q:index=""  d
	.do OutputRow3
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
SaveNewConfigInfo
	s objInsuDlConfig=##class(User.InsuDLConfig).%New()
	set objInsuDlConfig.ColProCode=ColProCode
    set objInsuDlConfig.ColProName=ColProName
   	set objInsuDlConfig.NotUpateFlg="0"
   	set objInsuDlConfig.CompareFlg="0"
   	set objInsuDlConfig.NullCheckFlg="0"
   	set objInsuDlConfig.ShowIndex=maxShowIndex+index
   	set objInsuDlConfig.DataType=Data
   	set objInsuDlConfig.OptionVales=""
   	set objInsuDlConfig.ExtStr1=""
   	set objInsuDlConfig.ExtStr2=""
   	set objInsuDlConfig.ExtStr3=""
   	set objInsuDlConfig.ExtStr4=""
   	set objInsuDlConfig.ExtStr5=""
   	set objInsuDlConfig.InsuType=InsuType
   	set objInsuDlConfig.TableClsName=TableCode
   	set sc=objInsuDlConfig.%Save()
   		i $System.Status.IsError(sc) d
    .s id="0"
    e  d
    .//存储成功后添加到输出页面的
    .s id=objInsuDlConfig.%Id()
   	.set ColProCode=objInsuDlConfig.ColProCode
    .set ColProName=objInsuDlConfig.ColProName
   	.set NotUpateFlg=objInsuDlConfig.NotUpateFlg
   	.set CompareFlg=objInsuDlConfig.CompareFlg
   	.set NullCheckFlg=objInsuDlConfig.NullCheckFlg
   	.set ShowIndex=objInsuDlConfig.ShowIndex
   	.set DataType=objInsuDlConfig.DataType
    .set DataType=$SELECT(DataType="String":"文本类型",DataType="Date":"日期类型",DataType="Time":"时间类型",DataType="Integer":"数字类型")
    .set OptionVales=objInsuDlConfig.OptionVales
   	.set ExtStr1=objInsuDlConfig.ExtStr1
   	.set ExtStr2=objInsuDlConfig.ExtStr2
   	.set ExtStr3=objInsuDlConfig.ExtStr3
   	.set ExtStr4=objInsuDlConfig.ExtStr4
   	.set ExtStr5=objInsuDlConfig.ExtStr5
    .set ^TMPGetInsuDLConfigInfo($j,ShowIndex)=$lb(id,ColProCode,ColProName,NotUpateFlg,CompareFlg,NullCheckFlg,ShowIndex,DataType,OptionVales,ExtStr1,ExtStr2,ExtStr3,ExtStr4,ExtStr5,ShowIndex)
OutputRow3
		//需要输出的列
	set Data=^TMPGetInsuDLConfigInfo($j,index)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod GetInsuDLConfigInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInsuDLConfigInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInsuDLConfigInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInsuDLConfigInfoExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(web.InsuDlConfigCtl).updateInsuDlConfigCtl("ExtStr2","0",2)

/// Creator：      许斌斌
/// CreatDate：    2020-03-09
/// Description:： 按照字段和值更新配置表数据
/// Table：        
/// Input：     field：字段名     value：更新的值    InsuDLConfigRowid：配置变rowid
/// Output：       
/// 			
/// Return：       无
/// Others：    debug：d ##class(%ResultSet).RunQuery("web.InsuDlConfigCtl","GetInsuDLConfigInfo","ZZB","INSUDiagnoseDown")
ClassMethod updateInsuDlConfigCtl(field As %String, value As %String, InsuDLConfigRowid)
{
	
	s $ZT="SaveEx"
	
	q:$g(InsuDLConfigRowid)="" "-1"
	i (InsuDLConfigRowid'="") d			;Rowid获取数据，比较
	.s objInsuDLConfig=##class(User.InsuDLConfig).%OpenId(InsuDLConfigRowid)
	q:$isobject(objInsuDLConfig)=0 "-1"
	s ^TMPINSU("updateInsuDlConfigCtl")=field_"^"_value_"^"_InsuDLConfigRowid
	
	s RtnFlg="99"
	s flag="0"
	if (field="NotUpateFlg") d
	.set objInsuDLConfig.NotUpateFlg=value
	else  if (field="CompareFlg") d
	.set objInsuDLConfig.CompareFlg=value
	else  if (field="NullCheckFlg") d
	.set objInsuDLConfig.NullCheckFlg=value
	else  if (field="ShowIndex") d
	.set objInsuDLConfig.ShowIndex=value
	else  if (field="OptionVales") d
	.set objInsuDLConfig.OptionVales=value
	else  if (field="ExtStr1") d
	.set objInsuDLConfig.ExtStr1=value
	else  if (field="ExtStr2") d
	.set objInsuDLConfig.ExtStr2=value
	else  if (field="ExtStr3") d
	.set objInsuDLConfig.ExtStr3=value
	else  if (field="ExtStr4") d
	.set objInsuDLConfig.ExtStr4=value
	else  if (field="DataType") d
	.set DataType=$SELECT(value="文本类型":"String",value="日期类型":"Date",value="时间类型":"Time",value="数字类型":"Integer")
	.set objInsuDLConfig.DataType=DataType
	; test code start==================

	
    s state=objInsuDLConfig.%Save()
   
    i $System.Status.IsError(state) d
	.s flag="-101"
	e  d
	.s flag=InsuDLConfigRowid
	q flag
	
	
SaveEx
   s $ZT=""
   q "-1^"_$ze
}

/// Creator：      许斌斌
/// CreatDate：    2020-03-09
/// Description:： 按照字段和值更新配置表数据
/// Table：        
/// Input：     exp：字段名！更新的值     InsuDLConfigRowid：配置变rowid
/// Output：       
/// 			
/// Return：       无
/// Others：    debug：d ##class(%ResultSet).RunQuery("web.InsuDlConfigCtl","GetInsuDLConfigInfo","ZZB","INSUDiagnoseDown")
ClassMethod updateInsuDlConfig(exp As %String, InsuDLConfigRowid)
{
	set len=$L(exp,"^")
	set i=1
	for i=1:1:len d
	.set info=$p(exp,"^",i)
	.set field=$p(info,"!",1)
	.set value=$p(info,"!",2)
	.set flag=..updateInsuDlConfigCtl(field,value,InsuDLConfigRowid)
	.q:flag'=0
}

/// Creator：      许斌斌
/// CreatDate：    2020-03-09
/// Description:： 按照字段和值更新配置表数据
/// Table：        
/// Input：     exp：字段名^新的值^老的值   
/// 			
/// Return：       字段的描述  新的值  老的值 \\n
/// Others：    debug：w ##class(web.InsuDlConfigCtl).getInsuTarItemDlDesc("INTIMzfbl1^0.1^.1|INTIMzfbl2^0.1^.1|INTIMzfbl3^0.1^.1|")
ClassMethod getInsuTarItemDlDesc(exp As %String)
{
	set rtn=""
	if $g(exp)="" q ""
	set len=$L(exp,"|") 
	set i=1
	for i=1:1:len d
	.set idInfo=$p(exp,"|",i)
	.set TarItemField=$p(idInfo,"^",1)
	.set NewInfo=$p(idInfo,"^",2)
	.set oldInfo=$p(idInfo,"^",3)
	.q:$g(TarItemField)=""
	.set name=$g(^TMPINSUTar($j,TarItemField)) //查找对应字段的i
	.if $g(name)="" set rtn=rtn_" "_idInfo
	.q:$g(name)=""
	.if rtn=""  set rtn=name_" 新的值："_NewInfo_" 老的值："_oldInfo_"<br/>"
	.else  set rtn=rtn_name_" 新的值："_NewInfo_" 老的值："_oldInfo_"<br/>"
	q rtn
}

/// Creator：      许斌斌
/// CreatDate：    2020-03-09
/// Description:： 获得医保目录下载表的字段描述
/// Table：        
/// Input：        
/// 			
/// Return：      
/// Others：    debug：w ##class(web.InsuDlConfigCtl).getInsuTarItemDlDesc("INTIMtjdm^1^2|INTIMbzjg^^0|INTIMsjjg^^0|INTIMzgxj^^99999|INTIMzfbl1^0^.1|INTIMzfbl2^0^.1|INTIMzfbl3^0^.1|")
ClassMethod getInsuTarItemDlAllDesc()
{
	set tempObj=##class(%Dictionary.CompiledClass).%OpenId("User.InsuTaritemsDL")
	for i=1:1:tempObj.Properties.Count() {
		set property=tempObj.Properties.GetAt(i)
		set name=property.Name
		set ColProName=property.Parameters.GetAt("CAPTION")
		set ^TMPINSUTar($j,name)=ColProName //	用临时global去存数据
	}
}

/// Creator：      许斌斌
/// CreatDate：    2020-03-09
/// Description:： 按照字段和值更新配置表数据
/// Table：        
/// Input：     exp：字段名^新的值^老的值   
/// 			
/// Return：       字段的描述  新的值  老的值 \\n
/// Others：    debug：w ##class(web.InsuDlConfigCtl).getInsuTarItemDlDesc("INTIMtjdm^1^2|INTIMbzjg^^0|INTIMsjjg^^0|INTIMzgxj^^99999|INTIMzfbl1^0^.1|INTIMzfbl2^0^.1|INTIMzfbl3^0^.1|")
ClassMethod getInsuTarItemDlDescTwo(exp As %String)
{
	set rtn=""
	set tempObj=##class(%Dictionary.CompiledClass).%OpenId("User.InsuTaritemsDL")
	if $isobject(tempObj)=0 q 0 //判断该对象是否存在
	if $g(exp)="" q ""
	set len=$L(exp,"|") 
	set i=1
	for i=1:1:len d
	.set idInfo=$p(exp,"|",i)
	.set TarItemField=$p(idInfo,"^",1)
	.set NewInfo=$p(idInfo,"^",2)
	.set oldInfo=$p(idInfo,"^",3)
	.set objId=tempObj.Properties.FindObjectId("User.InsuTaritemsDL||"_TarItemField) //查找对应字段的id
	.set:$g(objId)="" rtn=rtn_" "_TarItemField
	.q:$g(objId)=""
	.set property=tempObj.Properties.GetAt(objId)  // 获得对应列字段的对象
	.set name=property.Parameters.GetAt("CAPTION")  //获得对应字段的描述
	.if rtn=""  set rtn=name_" 新的值："_NewInfo_" 老的值："_oldInfo_"&#13;"
	.else  set rtn=rtn_name_" 新的值："_NewInfo_" 老的值："_oldInfo_"&#13;"
	q rtn
}

}
