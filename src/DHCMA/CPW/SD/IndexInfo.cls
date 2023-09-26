Class DHCMA.CPW.SD.IndexInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildItem As DHCMA.CPW.SD.IndexItem [ Cardinality = children, Inverse = Parref ];

/// 病种字典ID
Property entityid As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 父指标ID
Property parentid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 是否根节点指标（1,0）	0代表末级
Property headertype As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 指标字段code
Property field As %String(MAXLEN = 50, TRUNCATE = 1);

/// 指标描述desc
Property title As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 指标计算表达式
Property indexExp As %String(MAXLEN = 100, TRUNCATE = 1);

/// 序号
Property sort As %String(MAXLEN = 50, TRUNCATE = 1);

/// 有效标志
Property active As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 合计指标0,明细指标1
Property type As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 节点类型 索引
Index IdxOfEType On (entityid, headertype, sort);

/// 父节点 索引
Index IdxOfEParref On (entityid, parentid, sort);

/// 指标字段 索引
Index IdxOfETypeField On (entityid, type, field);

/// w ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(1)
ClassMethod GetObjById(Id As %String) As DHCMA.CPW.SD.IndexInfo
{
	New (Id)
	Quit:'##class(DHCMA.CPW.SD.IndexInfo).%ExistsId(Id) ""
	Set obj=##Class(DHCMA.CPW.SD.IndexInfo).%OpenId(Id)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.IndexInfo).Update("^t^4^^0^field1^^1^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Set ^zqy=$lb(aInputStr)
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID				= $p(aInputStr,aSeparete,1)
	Set title			= $p(aInputStr,aSeparete,2)	
	Set entityid		= $p(aInputStr,aSeparete,3)
	Set parentid 		= $p(aInputStr,aSeparete,4)
	Set Headertype		= $p(aInputStr,aSeparete,5)
	Set Field        	= $p(aInputStr,aSeparete,6)
	Set Sort         	= $p(aInputStr,aSeparete,7)
	Set IsActive        = $p(aInputStr,aSeparete,8)
	Set type        	= $p(aInputStr,aSeparete,9)
	if (ID="")&&(Headertype ="0")&&($d(^DHCMA.CPW.SD.IndexInfoI("IdxOfETypeField"," "_entityid," "_type," "_$zcvt(Field,"U")))){
		Quit "-777"
	}
	If ID="" {	
		Set obj=##class(DHCMA.CPW.SD.IndexInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.IndexInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set:parentid="" parentid=obj.%Id()
	Set obj.title    			= title	
	Set obj.entityid        	= entityid
	Set obj.parentid        	= parentid
	Set obj.headertype        	= Headertype	
	Set obj.field				= Field
	Set obj.sort				= Sort
	Set obj.active    			= IsActive
	Set obj.type    			= type
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		If (parentid=""){
			Set Tobj=##class(DHCMA.CPW.SD.IndexInfo).%OpenId(return)
			Set obj.parentid =return
			Set sc=Tobj.%Save()
			Do Tobj.%Close()
		}
		
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##class(DHCMA.CPW.SD.IndexInfo).ImpUpdate("WS008^0^1^基础信息^^^^1^1")
ClassMethod ImpUpdate(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	//s ^tmpzgz55=aInputStr_"*"_$h
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set entityid		= $p(aInputStr,aSeparete,1)
	Set type			= $p(aInputStr,aSeparete,2)
	Set headertype      = $p(aInputStr,aSeparete,3)
	Set title			= $p(aInputStr,aSeparete,4)
	Set field			= $p(aInputStr,aSeparete,5)
	Set parentid 		= $p(aInputStr,aSeparete,6)
	Set indexExp       	= $p(aInputStr,aSeparete,7)
	Set sort			= $p(aInputStr,aSeparete,8)	
	Set active			= $p(aInputStr,aSeparete,9)
	Quit:entityid="" return
	Set entityidObj=##class(DHCMA.CPW.SD.QCEntity).GetObjByCode(entityid)
	Quit:'$IsObject(entityidObj) return 
	Set entityid=entityidObj.%Id()
	Set:((headertype=0)&&(title=parentid)) parentid=""
	Set ID=##class(DHCMA.CPW.SD.IndexInfo).GetObjByTitle(entityid,title,headertype,type)
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.IndexInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.IndexInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	if ((headertype=0)&&(title'=parentid)){
		Set parentid=##class(DHCMA.CPW.SD.IndexInfo).GetObjByTitle(entityid,parentid,1,type)	
	}
	Set obj.entityid        	= entityid
	Set obj.type    			= type
	Set obj.headertype        	= headertype	
	Set obj.title    			= title	
	Set obj.field				= field
	Set obj.parentid        	= parentid
	Set obj.indexExp			= indexExp
	Set obj.sort				= sort
	Set obj.active    			= active
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		If (parentid=""){
			Set Tobj=##class(DHCMA.CPW.SD.IndexInfo).%OpenId(return)
			Set obj.parentid =return
			Set sc=Tobj.%Save()
			Do Tobj.%Close()
		}
		
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##class(DHCMA.CPW.SD.IndexInfo).GetObjByTitle("31","月份",0,0)
ClassMethod GetObjByTitle(aEntity, atitle, headertype, type As %String) As %String
{
	New (aEntity,atitle,headertype,type)
	Set return=""
	Quit:atitle="" return
	Set xSort=""
	For{
		Set xSort   = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," "_headertype,xSort))
		Quit:xSort=""
		Set xParentid=""
		For {
			Set xParentid   = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," "_headertype,xSort,xParentid))
			Quit:xParentid=""
			Set obj=..GetObjById(xParentid)
			Set title=obj.title
			Continue:atitle'=title
			Continue:type'=obj.type
			Set return=xParentid
		}
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SD.IndexInfo)UpIndexExp("7^(""A""=""n"")&&(""B""[""g,d"")")
ClassMethod UpIndexExp(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Set ^zqy111=$lb(aInputStr)
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID				= $p(aInputStr,aSeparete,1)
	Set IndexExp		= $p(aInputStr,aSeparete,2)	
	Quit:ID=""
	Set obj=##class(DHCMA.CPW.SD.IndexInfo).%OpenId(ID)
	Set obj.indexExp			= IndexExp
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

/// w ##class(DHCMA.CPW.SD.IndexInfo).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set obj=##class(DHCMA.CPW.SD.IndexInfo).GetObjById(aId)
	Quit:'$IsObject(obj)
	Set headertype = obj.headertype
	Set aEntity    = obj.entityid
	if (headertype=0){
		Set sc = ##class(DHCMA.CPW.SD.IndexInfo).%DeleteId(aId)
		If $system.Status.IsError(sc) {            //检查删除是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		} Else {
			Set return=0
		}
	}else{
		Set sort=""
		For{
			Set sort   = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEParref"," "_aEntity," "_aId,sort))
			Quit:sort=""
			Set xParentid=""
			For {
				Set xParentid   = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEParref"," "_aEntity," "_aId,sort,xParentid))
				Quit:xParentid=""
				Set sc = ##class(DHCMA.CPW.SD.IndexInfo).%DeleteId(xParentid)
				If $system.Status.IsError(sc) {            //检查删除是否成功
			   		Do $system.OBJ.DisplayError(sc) 
			   		Set return=-1
				} Else {
					Set return=0
				}
			}
		}
	}
	Quit return
}

Storage Default
{
<Data name="IndexInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>entityid</Value>
</Value>
<Value name="3">
<Value>parentid</Value>
</Value>
<Value name="4">
<Value>headertype</Value>
</Value>
<Value name="5">
<Value>field</Value>
</Value>
<Value name="6">
<Value>title</Value>
</Value>
<Value name="7">
<Value>sort</Value>
</Value>
<Value name="8">
<Value>active</Value>
</Value>
<Value name="9">
<Value>indexExp</Value>
</Value>
<Value name="10">
<Value>type</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.IndexInfoD</DataLocation>
<DefaultData>IndexInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.IndexInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.IndexInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.IndexInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
