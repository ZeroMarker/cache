Include CT.NUR.MNIS.H8D5P.Macro

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
Class CT.NUR.MNIS.H8D5P.Base Extends %RegisteredObject [ Abstract, Not ProcedureBlock, System = 1 ]
{

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod ClassName(ByRef className = "") As %String
{
	n (className) i (className="") { s className=$classname() } elseif ('##class(%Library.ClassDefinition).%ExistsId(className)) { s className="" } q className
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod TableName(ByRef tableName = "", ByRef idName = "", ByRef className = "") As %String
{
	n (tableName,idName,className) i (tableName'="")&&(className="") { s className=tableName } else {} d ..ClassName(.className) s tableName="",class=##class(%Library.ClassDefinition).%OpenId(className) i ($isobject(class)) { i (class.SqlTableName'="") { s tableName=class.SqlTableName } elseif (class.ClassType="persistent") { s l=$l(className,".") i (l'>2) { s tableName=className } else { s tableName=$replace($p(className,".",1,l-1),".","_")_"."_$p(className,".",l) } } i (class.SqlRowIdName'="") { s idName=class.SqlRowIdName } elseif (tableName'="") { s idName="id" } d class.%Close() } q tableName
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod DataLocation(className = "", ByRef subscripts, recursive = "") As %String
{
	n (className,subscripts,recursive) s dl="" i (recursive'>0) { k subscripts i (className="") { s className=$classname() } else {} s dl="^"_className_"D" } else {} s class=##class(%Library.ClassDefinition).%OpenId(className) i ($isobject(class)) { s storages=class.Storages /*%Library.StorageDefinition*/i ($isobject(storages)) { s storage=storages.GetAt(1) i ($isobject(storage)) { s dl=storage.DataLocation i ($e(dl,1,10)="{%%PARENT}") { s j=$o(subscripts(""),-1),subscript=$e(dl,12,$l(dl)-1),subscripts($i(j))=subscript,parent=..GetParent(.type,"",className),dl=..DataLocation(type,.subscripts,$i(recursive)) } elseif ($e(dl,"^",1)="^") { i ($l(dl)=($l(className)+2)) {} elseif ($l(dl)=($l(className)+1)) {} else {} d ..ArrayReverse(.subscripts) } else {} } else {} } else {} d class.%Close() } else {} q dl
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetProperties(ByRef properties, ByRef relationships, className = "") As %Integer
{
	n (properties,relationships,className) d ..ClassName(.className) k p,r,properties,relationships s (i,j,l)=0,class=##class(%Library.ClassDefinition).%OpenId(className) i ($isobject(class)) { s valueList=class.Properties,l=$s($isobject(valueList):valueList.Count(),1:0) while ($i(i)'>l) { /*%Library.PropertyDefinition*/s property=valueList.GetAt(i),name=property.SequenceNumber,value=property.Name,type=property.Type,cardinality=property.Cardinality,inverse=property.Inverse,description=property.Description i (name="") { s name=j+1 } else {} i (cardinality="") { s p(name)=value,p(name,"type")=type i (description'="") { s p(name,"description")=description } else {} } else { s r(name)=value,r(name,"type")=type,r(name,"cardinality")=cardinality,r("inverse")=inverse i (description'="") { s r(name,"description")=description } else {} } s j=$i(j) } s name="" while(1) { s name=$o(p(name)) i (name="") { q } else {} m properties($i(p))=p(name) } s name="" while(1) { s name=$o(r(name)) i (name="") { q } else {} m relationships($i(r))=r(name) } d class.%Close() } else {} q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetParent(ByRef type = "", ByRef depth = "", className = "") As %String
{
	n (type,depth,className) d ..ClassName(.className) s (parent,type)="",depth=1,(i,l)=0,class=##class(%Library.ClassDefinition).%OpenId(className) i ($isobject(class)) { s valueList=class.Properties,l=$s($isobject(valueList):valueList.Count(),1:0) while ($i(i)'>l) { /*%Library.PropertyDefinition*/s property=valueList.GetAt(i),value=property.Name,cardinality=property.Cardinality i (cardinality="parent") { s parent=value,type=property.Type,depth=$i(depth) d ..GetParent(.t,.d,type) i (t'="") { s depth=depth+d-1 } else {} q } else {} } d class.%Close() } else {} q parent
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod ArrayReverse(ByRef array) As %Integer
{
	n (array) m l=array k array s k=0,j="" while(1) { s j=$o(l(j),-1) i (j="") { q } else { m m=l(j) s n=$o(m("")) i (n'="") { d ..ArrayReverse(.m) m array($i(k))=m } else { s array($i(k))=$g(m) } k m,l(j) } } m array=l q k
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod IsNumeric(type = "") As %Boolean
{
	n (type) q (type="%Numeric")||(type="%Library.Numeric")||(type="%Integer")||(type="%Library.Integer")||(type="%Decimal")||(type="%Library.Decimal")||(type="%Float")||(type="%Library.Float")||(type="%Double")||(type="%Library.Double")||(type="%Double")||(type="%Library.Double")||(type="%BigInt")||(type="%Library.BigInt")||(type="%SmallInt")||(type="%Library.SmallInt")
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod SetProperty(object = "", type = "", name = "", value = "") As %ObjectHandle
{
	n (object,type,name,value) i (type="%String")||(type="%Library.String") { s $zobjproperty(object,name)=value } elseif (type="%Boolean")||(type="%Library.Boolean") { s $zobjproperty(object,name)=$s(value="true":1,value="false":0,value=1:1,value=0:0,1:"") } elseif (..IsNumeric(type)) { s $zobjproperty(object,name)=value } elseif (type="%Date")||(type="%Library.Date") { s $zobjproperty(object,name)=##class(websys.Conversions).DateHTMLToLogical(value) } elseif (type="%Time")||(type="%Library.Time") { s $zobjproperty(object,name)=##class(websys.Conversions).TimeHTMLToLogical(value) } else { i ($isobject(value)) { s value=value.%Id() } else {} s x="d object."_name_"SetObjectId("""_value_""")" x x } q object
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod AjustifyDynamicValue(ByRef value = "", type = "") As %String
{
	n (value,type) i (value="")||(value="null") { s value="null" } else { i (type="%String")||(type="%Library.String") { s value="'"_$replace(value,"'","''")_"'" } elseif (type="%Boolean")||(type="%Library.Boolean") { s value=$s(value="true":1,value="false":0,value=1:1,value=0:0,1:"") } elseif (..IsNumeric(type)) {} elseif (type="%Date")||(type="%Library.Date") { s value=##class(websys.Conversions).DateHTMLToLogical(value) } elseif (type="%Time")||(type="%Library.Time") { s value=##class(websys.Conversions).TimeHTMLToLogical(value) } else { i ($isobject(value)) { s value=value.%Id() } else {} i (value="") { s value="null" } else { i (+value'=value) { s value="'"_value_"'" } else {} } } } q value
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod AjustifyIdParameter(ByRef listBuild = "") As %String
{
	n (listBuild) i ($lv(listBuild)>0) { s str="",i=0,j=$s(listBuild=$lb():0,1:$ll(listBuild)) while($i(i)'>j) { s $p(str,"||",i)=$lg(listBuild,i) } s listBuild=str } q listBuild
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod AjustifyValueParameter(ByRef listBuild = "", count = "") As %String
{
	n (listBuild,count) i ($lv(listBuild)>0) { s ll=$ll(listBuild) i (ll=count) { s lb=$lb(""),i=0 while($i(i)'>count) { s $li(lb,i+1)=$lg(listBuild,i) } s listBuild=lb } elseif (ll<count) { s lb=$lb(""),i=0,j=1 i ($lg(listBuild,1)="") { s j=0,count=count+1 } else { } while($i(i)'>ll) { s $li(lb,i+j)=$lg(listBuild,i) } s i=ll while($i(i)'>count) { s $li(lb,i+j)="" } s listBuild=lb } elseif (ll>count) { s lb=$lb(""),i=0,j=1 i ($lg(listBuild,1)="") { s j=0,count=count+1 } else {} while($i(i)'>count) { s $li(lb,i+j)=$lg(listBuild,i) } s listBuild=lb } else {} } else {} q listBuild
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod Save(listBuild = "", idorObject = "", className = "") As %String
{
	n (listBuild,idorObject,className) i ($isobject(idorObject)) { s object=idorObject i (className="") { s className=object.%ClassName(1) } else {} } else { s id=..AjustifyIdParameter(idorObject),parent=..GetParent("",.depth,className) d ..ClassName(.className) i (id="") { s x="s object=##class("_className_").%New()" } else { i ($l(id,"||")<depth) { s x="s object=##class("_className_").%New() d object."_parent_"SetObjectId("""_id_""")" } else { s x="s object=##class("_className_").%OpenId("""_id_""")" } } x x } s (i,j)=0 i ($isobject(object)) { d ..GetProperties(.properties,"",className) s count=$o(properties(""),-1) d ..AjustifyValueParameter(.listBuild,count) while (1) { s i=$o(properties(i)) i (i="") { q } else {} s name=properties(i),type=$g(properties(i,"type")),value=$lg(listBuild,i+1) d ..SetProperty(object,type,name,value) } s save=object.%Save() i ($$$ISOK(save)) { s j=object.%Id() } else { s j=save } d object.%Close() } else {} q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   w ##class(CT.NUR.MNIS.H8D5P.Base).Update($lb("","value","accordion"),"3||1","CT.NUR.MNIS.H8D5P.Entry")
ClassMethod Update(listBuild = "", id = "", className = "") As %String
{
	n (listBuild,id,className) s (names,values)="",id=..AjustifyIdParameter(id) d ..ClassName(.className) d ..GetProperties(.properties,"",className) s i=0,count=$o(properties(""),-1) d ..AjustifyValueParameter(.listBuild,count) while ($i(i)'>count) { s name=properties(i),type=$g(properties(i,"type")),value=$lg(listBuild,i+1) i (i>1) { s names=names_",",values=values_"," } else {} s names=names_name,values=values_..AjustifyDynamicValue(value,type) } s sql="update "_..TableName(className,.idName)_" ("_names_") values ("_values_") where "_idName_"='"_id_"'",resultSet=##class(%Library.ResultSet).%New() d resultSet.Prepare(sql) d resultSet.Execute() s save=resultSet.%SQLCODE i ('$$$ISOK(save)) { s j=resultSet.%ROWID } else { s j=save } d resultSet.Close() q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   w ##class(CT.NUR.MNIS.H8D5P.Base).Update($lb("","value","accordion"),"3||1","CT.NUR.MNIS.H8D5P.Entry")
ClassMethod UpdateField(i = "", value = "", id = "", className = "") As %String
{
	n (i,value,id,className) d ..ClassName(.className) d ..GetProperties(.properties,"",className) s count=$o(properties(""),-1) i (i'>count) { s name=properties(i),type=$g(properties(i,"type")),names=name,values=..AjustifyDynamicValue(value,type),sql="update "_..TableName(className,.idName)_" ("_names_") values ("_values_") where "_idName_"='"_id_"'",resultSet=##class(%Library.ResultSet).%New() d resultSet.Prepare(sql) d resultSet.Execute() s save=resultSet.%SQLCODE i ('$$$ISOK(save)) { s j=resultSet.%ROWID } else { s j=save } d resultSet.Close() } else { s j=-100 }  q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   w ##class(CT.NUR.MNIS.H8D5P.Base).Insert($lb("","value","accordion"),"3||1","CT.NUR.MNIS.H8D5P.Entry")
ClassMethod Insert(listBuild = "", id = "", className = "") As %String
{
	n (listBuild,id,className) s (names,values)="",id=..AjustifyIdParameter(id) d ..ClassName(.className) d ..GetProperties(.properties,"",className) s i=0,count=$o(properties(""),-1),parent=..GetParent(.type,.depth,className) d ..AjustifyValueParameter(.listBuild,count) i (depth>1) { s count=$i(count),properties(count)=parent,properties(count,"type")=type,$li(listBuild,count+1)=$p(id,"||",1,depth-1) } else {} while ($i(i)'>count) { s name=properties(i),type=$g(properties(i,"type")),value=$lg(listBuild,i+1) i (i>1) { s names=names_",",values=values_"," } else {} s names=names_name,values=values_..AjustifyDynamicValue(value,type) } s sql="insert into "_..TableName(className)_" ("_names_") values ("_values_")",resultSet=##class(%Library.ResultSet).%New() d resultSet.Prepare(sql) d resultSet.Execute() s save=resultSet.%SQLCODE i ('$$$ISOK(save)) { s j=resultSet.%ROWID } else { s j=save b } d resultSet.Close() q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   zw ##class(CT.NUR.MNIS.H8D5P.Base).Select("","3||1","CT.NUR.MNIS.H8D5P.Entry")
ClassMethod Select(ByRef listBuild = "", id = "", className = "") As %String
{
	n (listBuild,id,className) s (listBuild,names)="",id=..AjustifyIdParameter(id) d ..ClassName(.className) d ..GetProperties(.properties,"",className) s i=0,count=$o(properties(""),-1) while ($i(i)'>count) { s name=properties(i) i (i>1) { s names=names_"," } else {} s names=names_name } s sql="select "_names_" from "_..TableName(className,.idName)_" where "_idName_"='"_id_"'",resultSet=##class(%Library.ResultSet).%New() d resultSet.Prepare(sql) d resultSet.Execute() s save=resultSet.%SQLCODE i ('$$$ISOK(save)) { d resultSet.Next() s i=0,listBuild=$lb("") while ($i(i)'>count) { s $li(listBuild,i+1)=resultSet.GetData(i) } } else { } d resultSet.Close() q listBuild
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   zw ##class(CT.NUR.MNIS.H8D5P.Base).Delete("3||1","CT.NUR.MNIS.H8D5P.Entry")
ClassMethod Delete(id = "", className = "") As %String
{
	n (id,className) s id=..AjustifyIdParameter(id) d ..ClassName(.className) s sql="delete from "_..TableName(className,.idName)_" where "_idName_"='"_id_"'",resultSet=##class(%Library.ResultSet).%New() d resultSet.Prepare(sql) d resultSet.Execute() s delete=SQLCODE i (delete=0) { s j=id } elseif (delete=100) { s j=0 } else { s j=delete } d resultSet.Close() q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod Prepare(sql = "") As %Boolean
{
	n (sql) s j=0,handle=$p(sql," ",1),resultSet=##class(%Library.ResultSet).%New() d resultSet.Prepare(sql) d resultSet.Execute() s result=resultSet.SQLCODE i (handle="select") { i (result=0)&&(resultSet.Next()) { s j=1 } else {} } d resultSet.Close() q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod PrepareIds(ByRef array, sql = "") As %Integer
{
	n (array,sql) k array s j=0,handle=$p(sql," ",1),resultSet=##class(%Library.ResultSet).%New() i (handle="select") { d resultSet.Prepare(sql) d resultSet.Execute() s result=resultSet.SQLCODE i (result=0) { while(resultSet.Next()) { s array($i(j))=resultSet.GetData(1) } } else {} } d resultSet.Close() q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod PrepareSelect(ByRef array, sql = "") As %Integer
{
	n (array,sql) k array s j=0,handle=$p(sql," ",1),resultSet=##class(%Library.ResultSet).%New() i (handle="select") { s rest=$e(sql,8,$l(sql)),names=$p(rest," ",1),l=$l(names,",") d resultSet.Prepare(sql) d resultSet.Execute() s result=resultSet.SQLCODE i (result=0) { while(resultSet.Next()) { s lb=$lb(),i=0 while ($i(i)'>l) { s $li(lb,i)=resultSet.GetData(i) } s array($i(j))=lb } } else {} } d resultSet.Close() q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod SaveProperty(object = "", name = "", value = "", className = "") As %String
{
	n (object,type,name,className) s j=object,k=0 i ($isvalidnum(object)) { s x="s object=##class("_className_").%OpenId(object)",k=1 x x } else {} i ($isobject(object)) { d ..ClassName(.className) d ..GetProperties(.properties,"",className) s i=0,count=$o(properties(""),-1),type="" while ($i(i)'>count) { s a=properties(i),b=$g(properties(i,"type")) i (a=name) { s type=b,i=count } else {} } d ..SetProperty(object,type,name,value) s j=object.%Save() i (k) { d object.%Close() } else {} } else {} q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetProperty(object = "", type = "", name = "") As %String
{
	n (object,type,name) s value=$zobjproperty(object,name) i (type="%String")||(type="%Library.String") {} elseif (..IsNumeric(type)) {} elseif (type="%Date")||(type="%Library.Date") {} elseif (type="%Time")||(type="%Library.Time") {} else { i ($isobject(value)) { s value=value.%Id() } else {} } q value
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetValues(ByRef values, id = "", className = "") As %Integer
{
	n (values,id,className) k values s id=..AjustifyIdParameter(id),x="s object=##class("_className_").%OpenId(id)",j=0 x x i ($isobject(object)) { d ..ClassName(.className) d ..GetProperties(.properties,"",className) s i=0,count=$o(properties(""),-1) while ($i(i)'>count) { s name=properties(i),type=$g(properties(i,"type")),value=..GetProperty(object,type,name),values(name)=value } d object.%Close() } else {} q j
}

/// Creator：      EH
/// CreatDate：    2022-06-21
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod CollectIds(ByRef array, className = "", parentId = "", global = "", prescript = "", ByRef subscripts, index = "") As %Integer
{
	n (array,className,parentId,global,prescript,subscripts,index) i (global="") { k array,subscripts s global=..DataLocation(className,.subscripts,"") } else {} i (prescript'="") { s prescript=prescript_"," } else {} i (index>0) { s node=$p(parentId,"||",index),prescript=prescript_node_",",subscript=$g(subscripts(index)) i (subscript'="") { s prescript=prescript_subscript_"," } else {} } else {} s close=$o(subscripts(""),-1),i=0 while (1) { s x="s i=$o("_global_"("_prescript_"i))" x x i (i="") { q } else { s x="s d=$d("_global_"("_prescript_"i))" x x i ((d=1)||(d=11))&&(index'<close) { s j=$o(array(""),-1),id=parentId i (id'="") { s id=id_"||" } else {} s id=id_i,array($i(j))=id } elseif (d=10)||(d=11){ s nextId=parentId i (nextId'="") { s nextId=nextId_"||" } else {} s nextId=nextId_i d ..CollectIds(.array,"",nextId,global,prescript,.subscripts,index+1) } } } q +$o(array(""),-1)
}

/// Creator：      EH
/// CreatDate：    2022-06-28
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetParameters(ByRef parameters, description As %Integer = 0, className = "") As %Integer
{
	n (parameters,description,className) d ..ClassName(.className) k p,parameters s (i,j)=0,class=##class(%Library.ClassDefinition).%OpenId(className) i ($isobject(class)) { s valueList=class.Parameters,l=$s($isobject(valueList):valueList.Count(),1:0) while ($i(i)'>l) { /*%Library.PropertyDefinition*/s property=valueList.GetAt(i),name=property.SequenceNumber,value=property.Name,default=property.Default,title=property.Description i (name="") { s name=j+1 } else {} i '((description=1)&&(title="")) { s p(name)=value,p(name,"description")=title,p(name,"default")=default } else {} s j=$i(j) } s name="" while(1) { s name=$o(p(name)) i (name="") { q } else {} m parameters($i(p))=p(name) } d class.%Close() } else {} q j
}

/// Creator：      EH
/// CreatDate：    2022-06-28
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetMethodParameters(ByRef parameters, methodName = "") As %Integer
{
	n (parameters,methodName) k parameters s (i,j)=0 i (##class(%Library.QueryDefinition).%ExistsId(methodName)) { s method=##class(%Library.QueryDefinition).%OpenId(methodName) i (method.FormalSpec="") { s method=##class(%Library.MethodDefinition).%OpenId(methodName) } else {} } else { s method=##class(%Library.MethodDefinition).%OpenId(methodName) } i ($isobject(method)) { s formalSpec=method.FormalSpec,l=$l(formalSpec),(byrefFrom,nameFrom,nameTo,typeFrom,typeTo,defaultFrom,defaultTo,f)=0 while ($i(i)'>l) { s c=$e(formalSpec,i) i (c="&") { s byrefFrom=i } elseif (nameFrom=0) { s nameFrom=i } elseif (c=":") { s nameTo=i-1,typeFrom=i+1 } elseif (c="=") { i (typeFrom=0) { s nameTo=i-1 } else { s typeTo=i-1 } s defaultFrom=i+1 } elseif (c=",") { i (defaultFrom'=0) { s defaultTo=i-1 } elseif (typeFrom'=0) { s typeTo=i-1 } else { s nameTo=i-1 } s f=1 } elseif (c="""")&&(defaultFrom'=0) { while (($i(i)'>l)&&(defaultTo=0)) { s c=$e(formalSpec,i),n=$s(i<l:$e(formalSpec,i+1),1:"") i (c="""")&&(n="""") { s i=$i(i) } elseif (c="""")&&((n=",")||(n="")) { s defaultTo=i,f=1 } else {} } } elseif (i=l) { i (typeFrom=0) { s nameTo=i } else { s typeTo=i } s f=1 } else {} i (f=1) { s byref=$s(byrefFrom'=0:$e(formalSpec,byrefFrom,byrefFrom),1:""),name=$s(nameTo'=0:$e(formalSpec,nameFrom,nameTo),1:""),type=$s(typeTo'=0:$e(formalSpec,typeFrom,typeTo),1:""),default=$s(defaultTo'=0:$e(formalSpec,defaultFrom,defaultTo),1:""),j=$i(j) s parameters(j)=name,parameters(j,"byref")=byref,parameters(j,"type")=type,parameters(j,"default")=default s (byrefFrom,nameFrom,nameTo,typeFrom,typeTo,defaultFrom,defaultTo,f)=0 } } d method.%Close() } else {} q j
}

/// Creator：      EH
/// CreatDate：    2022-06-28
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetQueryParameters(ByRef parameters, methodName = "") As %Integer
{
	n (parameters,methodName) k parameters s j=0 i (##class(%Library.QueryDefinition).%ExistsId(methodName)) { s method=##class(%Library.QueryDefinition).%OpenId(methodName),formalSpec=method.FormalSpec d method.%Close() i (formalSpec'="") { s j=..GetMethodParameters(.parameters,methodName) } else {} } else {} q j
}

/// Creator：      EH
/// CreatDate：    2022-06-28
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetQueryColumns(ByRef columns, queryName = "") As %Integer
{
	n (columns,queryName) k columns s i=0,rset=##class(%ResultSet).%New(queryName),l=$s($isobject(rset):rset.GetColumnCount(),1:0) while ($i(i)'>l) { s name=rset.GetColumnName(i) s columns(i)=name } d rset.Close() q l
}

/// Creator：      EH
/// CreatDate：    2022-06-28
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod EscapeRequestParameter(parameter = "") As %String
{
	n (parameter) s table="elementescape10020spacepair elementescape10021exclamationmarkpair!elementescape10022doublequotespair""elementescape10023poundpair#elementescape10024dollarpair$elementescape10025percentpair%elementescape10026ampersandpair&elementescape10027singlequotepair'elementescape10028openbracketpair(elementescape10029closebracketpair)elementescape1002Aasteriskpair*elementescape1002Bpluspair+elementescape1002Ccommapair,elementescape1002Dminuspair-elementescape1002Estoppair.elementescape1002Fslashpair\elementescape1003Acolonpair:elementescape1003Bsemicolonpair;elementescape1003Clessthanpair<elementescape1003Dequalpair=elementescape1003Egreaterthanpair>elementescape1003Fquestionmarkpair?elementescape10040atpair@elementescape1005Bopensquarebracketpair[elementescape1005Cbackslashpair/elementescape1005Dclosesquarebracketpair]elementescape1005Ecaretpair^elementescape1005Funderlinepair_elementescape10060opensinglequotepair`elementescape1007Bopenbracepair{elementescape1007Cverticallinepair|elementescape1007Dclosebracepair}elementescape1007Etildepair~" s l=$l(table,"element"),i=1 while($i(i)'>l) { s element=$p(table,"element",i),escape=$p(element,"pair",1),char=$p(element,"pair",2) i (parameter[escape) { s parameter=$replace(parameter,escape,char) } else {} } q parameter
}

/// Creator：      EH
/// CreatDate：    2022-06-28
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod GetSuper(className = "", recursive = "") As %String
{
	n (className,recursive) s j="" k supers i (recursive'>0) { i (className="") { s className=$classname() } else {} } else {} s class=##class(%Library.ClassDefinition).%OpenId(className) i ($isobject(class)) { s super=class.Super,l=$s(super'="":$l(super,","),1:0),i=0 d class.%Close() while ($i(i)'>l) { s su=$p(super,",",i),supers(su)="" i (recursive) { s next=..GetSuper(su,recursive+1),o=$s(next'="":$l(next,","),1:0) while ($i(p)'>o) { s q=$p(next,",",p),supers(q)="" } } } s q=$o(supers("")) while (q'="") { i (j'="") { s j=j_"," } else {} s j=j_q,q=$o(supers(q)) } } else {} q j
}

/// Creator：      EH
/// CreatDate：    2022-06-28
/// Description:   
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod FilterRequest(className = "", methodName = "") As %Boolean
{
	n (className,methodName) s j=0 i (methodName="Save")||(methodName="Select")||(methodName="Insert")||(methodName="Update")||(methodName="Delete")||(methodName="Prepare") { s supers=..GetSuper(className,1) i ((","_supers_",")[",CT.NUR.MNIS.H8D5P.Base,") { s j=1 } else {} } q j
}

}
