Class DHCWL.APP.Data.DataStorageManager Extends %RegisteredObject
{

//d ##class(DHCWL.APP.Data.DataStorageManager).Test()

ClassMethod Test()
{
	s meta=##class(DHCWL.APP.Data.BaseMeta).BaseMeta("Person:{Name:%String,Sex:%String,Address:{City:{Name:%String,Where},Code:%Integer}[],Mes:%String[]}")
	s dsm=##class(DataStorageManager).DataStorageManager(meta)
	d meta.SetId("Name")
	d dsm.AddIndex("NameIndex","Person.Name")
	d dsm.AddIndex("NameCodeIndex","Person.Name","Person.Address.Code")
	s cursor=dsm.GetCursor("Person")
	s array(1)="Hello",array(2)="Man",array(4)="This is test hello"
	d dsm.Insert(.array)
	s array(1)="Hello2",array(2)="Man",array(4)="This is test hello2"
	d dsm.Insert(.array)
	d cursor.Next()
	w cursor.Get("Name"),!
	w cursor.Get("Sex"),!
	s cursor=dsm.GetCursor("Person.Address")
	k array
	s array(2)="Beijing"
	d dsm.Insert(.array)
	s array(2)="10020"
	d dsm.Insert(.array)
	d cursor.Next()
	w cursor.GetPivot(),!
	w cursor.Get("Code"),!
	k array
	d cursor.MoveTo(1)
	s cursor=dsm.GetCursor("Person.Address.City")
	s array(1)="Beijing",array(2)="zhongguo"
	d dsm.Insert(.array)
	k array
	s cursor=dsm.GetCursor("Person")
	s array(1)="Hi",array(2)="Woman"
	d dsm.Insert(.array)
	w cursor.Next(),!
	w cursor.Get("Name"),!
	w cursor.Get("Sex"),!
	w cursor.Next(),!
	s cursor=dsm.GetCursor("Person.Address")
	k array
	s array(2)="10030"
	d dsm.Insert(.array)
	s array(2)="10040"
	d dsm.Insert(.array)
	;b ;00005
	s index=dsm.GetIndex("NameIndex")
	s node=""
	s node=index.Order(1,node)
	w node,!
	s node=index.Order(1,node)
	w node,!
	s index=dsm.GetIndex("NameCodeIndex")
	s node=""
	s node=index.Order(1,node)
	s node2=""
	s node2=index.Order(1,node,node2)
	w node2,!
	s node2=index.Order(1,node,node2)
	w node2,!
	s cursor=dsm.GetCursor("Person")
	d cursor.MoveTo(1)
	s cursor=dsm.GetCursor("Person.Address")
	d cursor.MoveTo(1)
	w dsm.Set("Code","10010"),!
	w cursor.GetScopeCount(),!
	s js=##class(DHCWL.APP.Data.Json).Json(dsm)
	s jo=js.GetJsonObject()
	s cursor=dsm.GetCursor("Person")
	d js.SetOnceDomain(1,3)
	f {
		q:cursor=""
		w jo.ToString()
		if 'cursor.IsLast() w ","
		w !
		s cursor=cursor.Next()
	}
	s xml=##class(DHCWL.APP.Data.XML).XML(dsm)
	s xo=xml.GetXMLObject()
	s cursor=dsm.GetCursor("Person")
	d xml.SetOnceDomain(1,3)
	f {
		q:cursor=""
		w xo.ToString()
		if 'cursor.IsLast() w ","
		w !
		s cursor=cursor.Next()
	}
	;b ;001
}

Property OSID As %String [ Private ];

Property storageName As %String [ Private ];

Property metaDefine As Meta [ MultiDimensional, Private ];

Property dataStorage As DataStorage [ MultiDimensional, Private ];

Property dataIndex As CacheManager [ MultiDimensional, Private ];

Property indexDefine [ MultiDimensional, Private ];

Property currentCursor As Cursor [ Private ];

Property currentAccessCursor As %String [ Private ];

ClassMethod DataStorageManager(meta As Meta, sn = "^temp") As DataStorageManager
{
	s dsm=##class(DataStorageManager).%New()
	s dsm.metaDefine=meta
	s fullClassName=meta.GetClassName()
	s dsm.metaDefine(fullClassName)=meta
	s osid=dsm.GetNextOSIDNode()_","_fullClassName
	s dsm.OSID=osid
	s dsm.storageName=sn
	s dsm.dataStorage(fullClassName)=##class(DataStorage).DataStorage(meta,osid,sn)
	d dsm.InitAllComplexProToStorage(meta)
	q dsm
}

Method GetCursor(property) As Cursor
{
	s len=$l(property,".")
	if len=1 {
		if $d(..dataStorage(property)) {
			s ..currentCursor=..dataStorage(property)
			s ..currentAccessCursor=property
			;d ..currentCursor.MoveToFirst()
			q ..currentCursor
		}
	}else{
		s access=property ;$p(property,".",1,len-1)
		if (($d(..dataStorage(access)))&&(..metaDefine($p(access,".",1,len-1)).IsArray($p(property,".",len)))) {
			s parentAccess=$p(property,".",1,len-1)
			s thisAccess=$p(property,".",len)
			;s parentAndChildIndex=parentAccess_"&"_thisAccess
			s parentCurId=..dataStorage(parentAccess).GetPivot()
			if (..dataStorage(parentAccess).GetMeta().IsArray(thisAccess)){
				if ($lv(..dataStorage(parentAccess).Get(thisAccess))){
					s childFirstId=$lg(..dataStorage(parentAccess).Get(thisAccess),1)
				}else{
					s childFirstId=""
				}
			}else{
				s childFirstId=..dataStorage(parentAccess).Get(thisAccess)
			}
			;s childFirstId=..dataIndex(parentAndChildIndex).Order(1,parentCurId,"")
			s ..currentAccessCursor=access
			s ..currentCursor=..dataStorage(access)
			if (+childFirstId'=0) d ..currentCursor.MoveTo(childFirstId)
			;else  d ..currentCursor.MoveToFirst()
			q ..currentCursor
		}elseif $d(..dataStorage(access)){
			s ..currentCursor=..dataStorage(property)
			s ..currentAccessCursor=property
			q ..currentCursor
		}
	}
	s ..currentAccessCursor=""
	s ..currentCursor=""
	q ..currentCursor
}

Method GetSize() As %Integer
{
	s baseClass=..metaDefine.GetClassName()
	q ..dataStorage(baseClass).GetSize()
}

Method GetMeta() As Meta
{
	q ..metaDefine
}

Method Set(property, value, index = "") As %Status
{
	s status=$$$OK
	if (..currentCursor.ValidateDomain()){
		s meta=..currentCursor.GetMeta()
		s access=meta.GetFullAccessLable()
		d ..PriFromMetaToProList(meta,.proArrayOld)
		s proLen=$l(property,".")
		if (proLen=1){
			if (+meta.GetPropertyIndex(property)=0){
				s status=property_"属性无效"
				q status
			}
			if (meta.IsArray(property)){
				if (index=""){
					s status=property_"为数组，请给出索引位置"
					q status
				}else{
					s list=..dataStorage(..currentAccessCursor).Get(property)
					s $list(list,index)=value
					d ..dataStorage(..currentAccessCursor).Set(property,list)
				}
			}else{
				d ..dataStorage(..currentAccessCursor).Set(property,value)
			}
		}else{
			s objList=..dataStorage(..currentAccessCursor).Get($p(property,".",1))
			s list=objList
			f i=1:1:proLen-1 {
				s curPostPros=$p(property,".",1,i)
				s thePro=$p(property,".",i)
				if (thePro=""){
					s status=property_"属性名字无效"
					q
				}
				s theMeta=..metaDefine(access_"."_curPostPros)
				if theMeta.IsArray(thePro){
					s status="数组，不允许赋值"
					q
				}
				s theProIndex=theMeta.GetPropertyIndex(thePro)
				if i=1 s newObjList=list
				s list=$lg(list,theProIndex,"")
				if (list=""){
					s status=curPostPros_"中的值为空"
					q
				}
			}
			q:status'=$$$OK status
			s thePro=$p(property,".",proLen)
			if (thePro=""){
				s status=property_"属性名字无效"
				q
			}
			s theProIndex=theMeta.GetPropertyIndex(thePro)
			s $list(list,theProIndex)=value
			//now start reverse set the list value
			;s newObjList=objList
			s objList=..dataStorage(..currentAccessCursor).Set($p(property,".",1),newObjList)
		}
		d ..PriFromMetaToProList(meta,.proArrayNew)
		;b ;001
		d ..PriUpdateIndex(.proArrayNew,.proArrayOld,value,,meta.GetFullAccessLable())
		q status
	}
	q "当前游标位置无效"
}

Method Insert(ByRef rowData, type = "Array") As %Integer
{
	s status=$$$OK
	s type=$zcvt(type,"U")
	if (..currentCursor){
		if (type="LIST"){
			;d ..dataStorage(..currentAccessCursor).Insert(rowData)
			s list=$lb()
			f i=1:1:$LL(rowData) {
				s $list(list,i+1)=$lg(rowData,i,"")
			}
			s rowData=list
		}elseif (type="ARRAY"){
			s meta=..dataStorage(..currentAccessCursor).GetMeta()
			s list=$lb()
			s colInd=0,ind=""
			f {
				s ind=$o(rowData(ind))
				q:ind=""
				if (+ind=0) {
					s colInd=meta.GetPropertyIndex(ind)
					s $list(list,colInd+1)=rowData(ind)
				}else{
					s $list(list,ind+1)=rowData(ind)
				}
			}
			;d ..dataStorage(..currentAccessCursor).Insert(list)
			s rowData=list
		}
		;s accessLable=..currentCursor.GetMeta().GetFullAccessLable()
		s meta=..currentCursor.GetMeta()
		s curentClassName=meta.GetClassName()
		s accessLable=meta.GetFullAccessLable()
		k proArray
		d ..PriFromMetaToProList(meta,.proArrayOld)
		s parentRowId=""
		s rowId=..dataStorage(..currentAccessCursor).Insert(rowData)
		if ((accessLable'="")&&($l(accessLable,".")>1)){
			s parentAccessLable=$p(accessLable,".",1,$l(accessLable,".")-1)
			s parentCursor=..dataStorage(parentAccessLable).GetCursor()
			s parentMeta=..dataStorage(parentAccessLable).GetMeta()
			s parentRowId=parentCursor.GetPivot()
			if (parentRowId=""){
				q "对象"_accessLable_"还没数据，请先Insert该对象数据"
			}
			s $list(rowData,1)=parentRowId_"@"_parentAccessLable
			if (parentMeta.IsArray(curentClassName)){
				s curentClassNameIndex=parentMeta.GetPropertyIndex(curentClassName)
				s curentList=..dataStorage(parentAccessLable).Get(curentClassName)
				if ((curentList="")||('$lv(curentList))) {
					;s curentList=$lb()
					;s $list(curentList,1)=rowId
					s curentList=rowId
				}else{
					s listLen=$LL(curentList)
					s $list(curentList,listLen+1)=rowId
				}
				d ..dataStorage(parentAccessLable).Set(curentClassName,curentList)
			}else{
				if (parentMeta.GetProperty(curentClassName)){
					s parentOldThisProRowId=..dataStorage(parentAccessLable).Get(curentClassName)
					if (parentOldThisProRowId'=""){
						d ..dataStorage(..currentAccessCursor).Delete(parentOldThisProRowId)
					}
				}
				
				d ..dataStorage(parentAccessLable).Set(curentClassName,rowId)
			}
		}else{
			
		}
		s oldPivot=..dataStorage(..currentAccessCursor).GetPivot()
		d ..dataStorage(..currentAccessCursor).MoveTo(rowId)
		d ..PriFromMetaToProList(meta,.proArrayNew)
		;b ;001
		if (oldPivot) {
			d ..dataStorage(..currentAccessCursor).MoveTo(oldPivot)
		}else{
			d ..dataStorage(..currentAccessCursor).MoveToFirst()
		}
		if (rowId'=""){
			d ..PriUpdateIndex(.proArrayNew,,,rowId,$g(accessLable))
			if (parentRowId'=""){
				;s tempIndexName=meta.GetParentMeta().GetFullAccessLable()_"&"_meta.GetClassName()
				;d ..dataIndex(tempIndexName).Set("",parentRowId,rowId)
				;d ..GetCursor(accessLable)
			}
			q rowId
		}
	}
	q "当前游标位置无效"
}

Method GetIndex(indexName) As CacheManager
{
	if $d(..dataIndex(indexName)) q ..dataIndex(indexName)
	q ""
}

Method AddIndex(indexName, propertyList...)
{
	q:($d(..indexDefine("Define",indexName))) "已经存在"_indexName_"索引名字的定义"
	s status=$$$OK
	k indexArray
	f i=1:1:$g(propertyList,0) {
		continue:$g(propertyList(i))=""
		s proDeep=$l(propertyList(i),".")
		s meta=..metaDefine
		f j=1+1:1:(proDeep-1) {
			s pro=$p(propertyList(i),".",j)
			s meta=meta.GetProperty(pro)
			if 'meta {
				s status=pro_"属性不存在"
				q
			}
		}
		q:status'=$$$OK
		if (meta.GetPropertyIndex($p(propertyList(i),".",proDeep))){
			s needProName=$p(propertyList(i),".",proDeep)
			if ('$d(..indexDefine("Define",indexName))) {
				s ..indexDefine("Define",indexName)=$g(propertyList(i),"")
				
			}else {
				 s ..indexDefine("Define",indexName)=..indexDefine("Define",indexName)_","_$g(propertyList(i),"")
				 
			}
			s ofClass=$p(propertyList(i),".",1,proDeep-1)
			;s indexArray(ofClass,i)=$p(propertyList(i),".",proDeep)
			s ..indexDefine("Property",indexName,propertyList(i),i)=ofClass
		}else{
			s status=$p(propertyList(i),".",proDeep)_"属性不存在"
			q
		}
		
	}
	s ..dataIndex(indexName)=##class(CacheManager).Init("*4",..OSID_":"_..metaDefine.GetClassName()_"I,"_indexName,..storageName)
	q status
}

Method InitAllComplexProToStorage(meta As Meta) [ Private ]
{
	if (meta){
		f i=1:1:meta.GetPropertyCount() {
			s proName=meta.GetPropertyName(i)
			if (meta.GetProperty(proName)){
				s fullName=meta.GetPropertyName(i)
				s tempMeta=meta.GetProperty(fullName).GetParentMeta()
				while(tempMeta){
					s fullName=tempMeta.GetClassName()_"."_fullName
					s tempMeta=tempMeta.GetParentMeta()
					
				}
				s ..metaDefine(fullName)=meta.GetProperty(proName)
				//if (meta.IsArray(proName)){
					s ..dataStorage(fullName)=##class(DataStorage).DataStorage(meta.GetProperty(meta.GetPropertyName(i)),..OSID_","_fullName,..storageName)
					/*if (meta.GetProperty(meta.GetPropertyName(i)).GetParentMeta()){
						s parentAndChildIndexName=meta.GetProperty(meta.GetPropertyName(i)).GetParentMeta().GetFullAccessLable()_"&"_meta.GetProperty(meta.GetPropertyName(i)).GetClassName()
						s ..dataIndex(parentAndChildIndexName)=##class(CacheManager).Init("*4",parentAndChildIndexName_"I")
					}*/
					
				//}
				d ..InitAllComplexProToStorage(meta.GetProperty(meta.GetPropertyName(i)))
			}
		}
	}
}

Method PriUpdateIndex(ByRef proIndexArrayNew, ByRef proIndexArrayOld = "", value = "", rowId = "", needClass) [ Private ]
{
	s status=$$$OK
	s indexName=""
	;b ;000
	m:$o(proIndexArrayOld(""))="" proIndexArrayOld=proIndexArrayNew
	;;b ;001
	f {
		s indexName=$o(..indexDefine("Define",indexName))
		q:(indexName="")||(status'=$$$OK)
		k indexDataArrayNew,indexDataArrayOld,classPostionInIndex
		s proName=""
		s indexDataArrayNew=0,indexDataArrayOld=0
		s rowIdListNew=$lb(),rowIdListOld=$lb()
		f {
			s proName=$o(..indexDefine("Property",indexName,proName))
			q:proName=""
			continue:'$d(proIndexArrayNew(proName))
			s indexCol=$o(..indexDefine("Property",indexName,proName,""))
			if (($g(proIndexArrayNew(proName))="")||($g(proIndexArrayOld(proName))="")){
				s status="索引属性值不能为空"
				q
			}
			s belongClass=$p(proName,".",1,$l(proName,".")-1)
			if (+$g(classPostionInIndex(belongClass))=0) s classPostionInIndex(belongClass)=indexCol
			if (+$g(classPostionInIndex(belongClass))>indexCol) s classPostionInIndex(belongClass)=indexCol
			s indexDataArrayOld=(+$g(indexDataArrayOld))+1
			s indexDataArrayOld(indexCol)=proIndexArrayOld(proName)
			s indexDataArrayNew=(+$g(indexDataArrayNew))+1
			s indexDataArrayNew(indexCol)=proIndexArrayNew(proName)
			
		}
		s className="",indexMaxClassLen=0
		f {
			s className=$o(classPostionInIndex(className))
			q:className=""
			if ($l(className,".")>indexMaxClassLen) s indexMaxClassLen=$l(className,".")
			s index=classPostionInIndex(className)
			s $list(rowIdListNew,index)=$g(proIndexArrayNew("$"_className,"RowId"))
			s $list(rowIdListOld,index)=$g(proIndexArrayOld("$"_className,"RowId"))
		}
		if (((+$G(indexDataArrayOld))=$l(..indexDefine("Define",indexName),","))&&(indexMaxClassLen=$l(needClass,"."))){
			f i=1:1:$LL(rowIdListNew) {
				s indexDataArrayOld=(+$g(indexDataArrayOld))+1
				s indexDataArrayOld(indexDataArrayOld)=$lg(rowIdListOld,i,"")
				s indexDataArrayNew=(+$g(indexDataArrayNew))+1
				s indexDataArrayNew(indexDataArrayNew)=$lg(rowIdListNew,i,"")
			}
			d ..dataIndex(indexName).Update(.indexDataArrayNew,.indexDataArrayOld,value)
		}
	}
}

Method PriFromMetaToProList(meta As Meta, ByRef propertyValueList)
{
	s proLen=meta.GetPropertyCount()
	s fullAccess=meta.GetFullAccessLable()
	f i=1:1:proLen {
		s proName=meta.GetPropertyName(i)
		if (meta.GetProperty(proName)){
			;d ..PriFromMetaToProList(meta.GetProperty(proName),.propertyValueList)
		}else{
			s proValue=..dataStorage(fullAccess).Get(proName)
			s propertyValueList(fullAccess_"."_proName)=proValue
		}
	}
	s propertyValueList("$"_fullAccess,"RowId")=..dataStorage(fullAccess).GetPivot()
	if (meta.GetParentMeta()){
		d ..PriFromMetaToProList(meta.GetParentMeta(),.propertyValueList)
	}
}

Method GetNextOSIDNode() As %String
{
	q +$this
}

Method %RemoveFromSaveSet() As %Status
{
	w $this_"%RemoveFromSaveSet",!
    k ^temp
	q $$$OK
}

Method %OnClose() As %Status
{
	s index=""
	f {
		s index=$o(..dataStorage(index))
		q:index=""
		;continue:..dataStorage(index)=""
		;w "index="_index,!
		d ..dataStorage(index).Delete("")
	}
	s index=""
	f {
		s index=$o(..dataIndex(index))
		q:index=""
		;continue:..dataIndex(index)=""
		;w "index="_index,!
		d ..dataIndex(index).Delete("")
	}
	;w $this_"%OnClose",!
	q $$$OK
}

}
