Class DHCWL.DM.T.Namespace Extends %Persistent
{

// Attached="NAMESPACE"

Property Parent As Namespace;

Property Type As TypeConfig [ Required ];

// 只能由字母,数字组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String(MAXLEN = 512, TRUNCATE = 1);

Property NodePath As %String(MAXLEN = 512, TRUNCATE = 0);

Index MainI On (Type, Parent, Code) [ Unique ];

Index NodePathI On (Type, NodePath);

// d ##class(DHCWL.DM.T.Namespace).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.Namespace)
	k ^DHCWL.DM.T.NamespaceD,^DHCWL.DM.T.NamespaceI
	s type=##class(TypeConfig).GetByPath("NAMESPACE:MT")
	s typeId=type.%Id()
	&sql(insert into DHCWL_DM_T.Namespace(Parent,Type,Code,Name,Description,NodePath) values(0,:typeId,'/','原型根目录','定义原型的根目录，其他都定义在该命名空间之下。','/'))
	w %ROWID,","
	s type=##class(TypeConfig).GetByPath("NAMESPACE:DI")
	s typeId=type.%Id()
	&sql(insert into DHCWL_DM_T.Namespace(Parent,Type,Code,Name,Description,NodePath) values(0,:typeId,'/','维度根目录','维度的根目录，其他都定义在该命名空间之下。','/'))
	w %ROWID,","
	s type=##class(TypeConfig).GetByPath("NAMESPACE:TH")
	s typeId=type.%Id()
	&sql(insert into DHCWL_DM_T.Namespace(Parent,Type,Code,Name,Description,NodePath) values(0,:typeId,'/','主题根目录','主题的根目录，其他都定义在该命名空间之下。','/'))
	w %ROWID,","
	s type=##class(TypeConfig).GetByPath("NAMESPACE:SE")
	s typeId=type.%Id()
	&sql(insert into DHCWL_DM_T.Namespace(Parent,Type,Code,Name,Description,NodePath) values(0,:typeId,'/','服务根目录','服务的根目录，其他都定义在该命名空间之下。','/'))
	w %ROWID,","
	
	s type=##class(TypeConfig).GetByPath("NAMESPACE:TH")
	s typeId=type.%Id()
	s parent=##class(Namespace).ThemeNamespace("/")
	s parentId=parent.%Id()
	&sql(insert into DHCWL_DM_T.Namespace(Parent,Type,Code,Name,Description) values(:parentId,:typeId,'common','公共','公共主题目录'))
	s id=%ROWID
	s ns=##class(Namespace).%OpenId(id)
	s nodePath=##class(Namespace).ComputeNodePath(ns)
	s ns.NodePath=nodePath
	d ns.%Save()
	w id,","
	
	s type=##class(TypeConfig).GetByPath("Namespace:TH")
	s typeId=type.%Id()
	s parent=##class(Namespace).ThemeNamespace("/common")
	s parentId=parent.%Id()
	&sql(insert into DHCWL_DM_T.Namespace(Parent,Type,Code,Name,Description) values(:parentId,:typeId,'test','公共测试','主题公共测试目录'))
	s id=%ROWID
	s ns=##class(Namespace).%OpenId(id)
	s nodePath=##class(Namespace).ComputeNodePath(ns)
	s ns.NodePath=nodePath
	d ns.%Save()
	w id,","
	
	
	s type=##class(TypeConfig).GetByPath("NAMESPACE:MT")
	s typeId=type.%Id()
	s parent=##class(Namespace).MetaNamespace("/")
	s parentId=parent.%Id()
	&sql(insert into DHCWL_DM_T.Namespace(Parent,Type,Code,Name,Description) values(:parentId,:typeId,'common','公共','公共原型目录'))
	s id=%ROWID
	s ns=##class(Namespace).%OpenId(id)
	s nodePath=##class(Namespace).ComputeNodePath(ns)
	s ns.NodePath=nodePath
	d ns.%Save()
	w id,","
}

// s ns=##class(DHCWL.DM.T.Namespace).GetIdByPath("ML:/")

ClassMethod GetIdByPath(path) As %String
{
	s typeCode=$p(path,":",1)
	s att="NAMESPACE"
	s typeCode=$zcvt(typeCode,"U")
	s path=$zcvt($e(path,$l(typeCode)+2,$l(path)),"U")
	q:path="" ""
	q:'$d(^DHCWL.DM.T.TypeConfigI("MainI"," "_att," "_typeCode)) ""
	s typeId=$o(^DHCWL.DM.T.TypeConfigI("MainI"," "_att," "_typeCode,""))
	s:(($l(path)>1) && ($e(path,$l(path))="/")) path=$e(path,1,$l(path)-1)
	q:(('$d(^DHCWL.DM.T.NamespaceI("NodePathI",typeId)))||('$d(^DHCWL.DM.T.NamespaceI("NodePathI",typeId," "_path)))) ""
	q $o(^DHCWL.DM.T.NamespaceI("NodePathI",typeId," "_path,""))
}

// s ns=##class(DHCWL.DM.T.Namespace).GetByPath("ML:/")

ClassMethod GetByPath(path) As Namespace
{
	q ##class(Namespace).%OpenId(..GetIdByPath(path))
}

ClassMethod CreateNamespace(path) As Namespace
{
	s path=##class(DHCWL.DM.Util.StringUtil).Trim(path)
	s obj=..GetByPath(path)
	q:obj'="" obj
	s len=$l(path)
	s code="",pp=""
	s status=$$$OK
	s typeCode=$p(path,":",1)_":"
	s typeEndInd=$l(typeCode)+1
	s type=##class(TypeConfig).GetByPath("NAMESPACE:"_$p(path,":",1))
	s pobj=..GetByPath(typeCode_"/")
	s path=$e(path,typeEndInd,len)
	s len=$l(path,"/")
	if pobj=""{
		s obj=##class(Namespace).%New()
		s obj.Code="/"
		s obj.Type=type
		s obj.Name="根目录"
		s obj.Description="类型："_type.Name_"的根目录"
		s obj.Parent=""
		s obj.NodePath="/"
		s status=obj.%Save()
		if status'=$$$OK{
			Do DisplayError^%apiOBJ(status)
			q
		}
	}
	s ptcode=typeCode_"/"
	f i=1:1:len{
		s pcode=$p(path,"/",i)
		continue:pcode=""
		s ptcode=ptcode_pcode
		s obj=..GetByPath(ptcode)
		if obj=""{
			s obj=##class(Namespace).%New()
			s obj.Code=pcode
			s obj.Type=type
			s obj.Name=pcode
			s obj.Description=pcode
			s obj.Parent=pobj
			s obj.NodePath=..ComputeNodePath(obj)
			s status=obj.%Save()
			if status'=$$$OK{
				Do DisplayError^%apiOBJ(status)
				q
			}
		}
		s pobj=obj
	}
	q:status'=$$$OK ""
	q obj
	f i=len:-1:1{
	  if $e(path,i)="/" {
			s code=$e(path,i+1,len)
			s pp=$e(path,1,i)
			s ppObj=..GetByPath(pp)
			q:ppObj'=""
	  }
	}
	q:(code="") ""
	s obj=##class(Namespace).%New()
	s obj.Code=code
	s obj.Parent=ppObj
	s obj.Type=##class(TypeConfig).GetByPath("NAMESPACE:"_$p(pp,":"))
	d obj.%Save()
	s obj.NodePath=..ComputeNodePath(obj)
	d obj.%Save()
	q obj
}

// s ns=##class(DHCWL.DM.T.Namespace).MetaNamespace("/common")

ClassMethod MetaNamespace(path) As Namespace
{
	q ..GetByPath("MT:"_path)
}

ClassMethod DimNamespace(path) As Namespace
{
	q ..GetByPath("DI:"_path)
}

ClassMethod ThemeNamespace(path) As Namespace
{
	q ..GetByPath("TH:"_path)
}

ClassMethod ServiceNamespace(path) As Namespace
{
	q ..GetByPath("SE:"_path)
}

/*
 s ns=##class(DHCWL.DM.T.Namespace).%OpenId(7)
 w ##class(DHCWL.DM.T.Namespace).ComputeNodePath(ns)
  
 */
ClassMethod ComputeNodePath(ns As Namespace) As %String
{
	s path=ns.Code
	s par=ns.Parent
	while(par'=""){
		if par.Code="/" s path=par.Code_path 
		else  s path=par.Code_"/"_path
		s par=par.Parent
	}
	q path
}

Method IsRoot() As %Boolean
{
	i ..Code="/" q 1 
	else  q 0
}

Method GetPath() As %String
{
	i ..IsRoot() q "/"
	q ..NodePath_"/"
}

Storage Default
{
<Data name="NamespaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Parent</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>NodePath</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.NamespaceD</DataLocation>
<DefaultData>NamespaceDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.NamespaceD</IdLocation>
<IndexLocation>^DHCWL.DM.T.NamespaceI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.NamespaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
