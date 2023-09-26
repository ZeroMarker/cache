Class DHCWL.APP.Data.DataStorage Extends Cursor
{

Property meta As Meta [ Private ];

Property data As CacheManager [ Private ];

Property ID As %String [ Private ];

Property OSID As %String [ Private ];

Property pivot As %String [ Private ];

Property from As %String [ Private ];

Property to As %String [ Private ];

Property storageName As %String [ Private ];

ClassMethod DataStorage(meta As Meta, osid, sn) As DataStorage
{
	s ds=##class(DataStorage).%New()
	s ds.meta=meta
	s ds.OSID=osid
	s ds.pivot=0
	s ds.from=0
	s ds.to=0
	s sn=##class(DHCWL.util.StringUtil).Trim(sn)
	s ds.storageName=sn
	s ds.data=##class(CacheManager).Init(,osid,sn)
	q ds
}

Method GetSize() As %Integer [ CodeMode = expression ]
{
..data.GetCount()
}

Method GetCursor() As Cursor [ CodeMode = expression ]
{
$this
}

Method CurrentId() [ CodeMode = expression ]
{
..ID
}

Method NexId(list)
{
	s status=1
	if (..meta.GetId()=""){
		s ..ID=(+..ID)+1
	}else{
		s idDef=..meta.GetId()
		s idDefLen=$l(idDef,",")
		s id=$lb()
		f i=1:1:idDefLen {
			s idPro=$p(idDef,",",i)
			s proIndex=..meta.GetPropertyIndex(idPro)
			if ($lg(list,proIndex,"")){
				s status=0
				q
			}
			s $list(id,i)=$lg(list,proIndex+1,"")
		}
		s id=$LTS(id,"||")
		s ..ID=id
	}
	if status=0 q ""
	q ..ID
}

/// <method>MoveToFirst</mothod>直接将游标移动到数据集的开始位置。该方法会返回游标位置的对象引用。<br>
Method MoveToFirst() As Cursor
{
	s ..pivot=..from
	q $this
}

/// <method>MoveToLast</mothod>直接将游标移动到数据集的最后位置。该方法会返回游标位置的对象引用。<br>
Method MoveToLast() As Cursor
{
	s ..pivot=..to
	q $this
}

/// <method>MoveToLast</mothod>该方法的作用时将游标移动到指定的index位置处，并返回该位置的游标，若位置index非法就返回空。<br>
/// <var>index</var>数据集位置index
Method MoveTo(index) As Cursor
{
	;d ..ResetScope()
	if (..ValidateDomain(index)){
		if (..data.Data(index)){
			s ..pivot=index
			q $this
		}else{
			q ""
		}
	}
	q ""
}

/// <method>Next</mothod>迭代到下一个游标位置。该方法会返回游标位置的对象引用。<br>
Method Next() As Cursor
{
	s gess=..data.Order(1,..pivot)
	q:gess="" ""
	s ..pivot=gess
	q $this
}

Method Previous() As Cursor
{
	s gess=..data.Order(-1,..pivot)
	q:gess="" ""
	s ..pivot=gess
	q $this
}

/// <method>IsFirst</method>判定当前游标是否已经在开始数据集的位置。<br>
Method IsFirst() As %Boolean [ CodeMode = expression ]
{
..pivot=..from
}

/// <method>IsFirst</method>判定当前游标是否已经在最后一个数据集的位置。<br>
Method IsLast() As %Boolean [ CodeMode = expression ]
{
..pivot=..to
}

Method GetPivot() As %String [ CodeMode = expression ]
{
..pivot
}

/// <method>GetPivot</method>获取给定开始位置和结束位置区间内的数据行数
/// 
Method GetScopeCount(start = "", end = "") As %Integer
{
	;d ..ResetScope()
	s:start="" start=..from
	s:end="" end=..to
	s oldPivot=..GetPivot()
	s count=0
	s cur=..MoveTo(start)
	while((cur)){
		s count=count+1
		s cur=cur.Next()
		if (cur.GetPivot()=end){
			s count=count+1
			q
		}
	}
	d ..MoveTo(oldPivot)
	q count
}

/// <method>Get</mothod>该方法的作用是得到该游标位置给定property属性的属性值。若属性表示的是一个复合属性则返回Cursor引用，然后可以根据该引用进一步访问属性值。<br>
/// <var>propertyName</var>参为属性名字propertyName，若访问该属性下的复合属性的属性值则用paraProName.childProName的形式，用英文点号分割。
Method Get(propertyName As %String, index = "")
{
	
	if (..ValidateDomain(..pivot)){
		s rowData=..data.Get(..pivot)
		s colIndex=..meta.GetPropertyIndex(propertyName)
		q:colIndex=0 ""
		if (..meta.IsArray(propertyName)){
			s proArray=$lg(rowData,colIndex+1,"")
			q:index="" proArray
			q $lg(proArray,index,"")
		}
		q $lg(rowData,colIndex+1,"")
	}
	q ""
}

Method GetArraySize(propertyName As %String) As %Integer
{
	s index=..meta.GetPropertyIndex(propertyName)
	q:index=0 0
	if (..meta.IsArray(propertyName)){
		s rowList=..data.Get(..pivot)
		s proList=$lg(rowList,index+1,"")
		q $ll(proList)
	}
	q 0
}

Method GetRowList(index)
{
	if (..ValidateDomain(index)){
		s rowData=..data.Get(index)
		q rowData
		s colIndex=..meta.GetPropertyIndex(propertyName)
		q:colIndex=0 ""
		q $lg(rowData,colIndex+1,"")
	}
	q ""
}

/// <method>Set</mothod>该方法的作用是设置该游标位置给定property属性的属性值。若属性表示的是一个复合属性则返回Cursor引用，然后可以根据该引用进一步访问属性值。<br>
/// <var>property</var>参为属性名字property，若访问该属性下的复合属性的属性值则用paraProName.childProName的形式，用英文点号分割。<br>
/// <var>value</var>要设置的属性值value
Method Set(property, value, index = "") As %Status
{
	if (..ValidateDomain(..pivot)){
		if ..data.Data(..pivot){
			s rowData=..data.Get(..pivot)
			s colIndex=..meta.GetPropertyIndex(property)
			q:colIndex=0 "属性"_property_"无效"
			if (..meta.IsArray(property)&&('$lv(value))){
				s:index="" index=1
				s proArray=$lg(rowData,colIndex+1)
				s $list(proArray,index)=value
				s value=proArray
			}
			s $list(rowData,colIndex+1)=value
			d ..SetRow(rowData)
			q $$$OK
		}
	}
	q "当前游标位置无效"
}

Method SetRow(list) As %Status
{
	if (..ValidateDomain(..pivot)){
		if ..data.Data(..pivot){
			s len=..meta.GetPropertyCount()
			f i=1:1:len {
				continue:$lg(list,i+1,"")=""
				if (..meta.IsArray(..meta.GetPropertyName(i))){
					if ('$LV($lg(list,i+1,""))){
						s lb=$lb()
						s $list(lb,1)=$lg(list,i+1,"")
						s $list(list,i+1)=lb
					}
				}
			}
			d ..data.Set(list,..pivot)
			q $$$OK
		}
	}
	q "当前游标位置无效"
}

Method Insert(list)
{
	s id=..NexId(list)
	q:id="" ""
	s ..to=id
	s len=..meta.GetPropertyCount()
	f i=1:1:len {
		continue:$lg(list,i+1,"")=""
		if (..meta.IsArray(..meta.GetPropertyName(i))){
			if ('$LV($lg(list,i+1,""))){
				s lb=$lb()
				s $list(lb,1)=$lg(list,i+1,"")
				s $list(list,i+1)=lb
			}
		}
	}
	d ..data.Set(list,id)
	d ..ResetScope()
	q id
}

Method Delete(index...) As %Status
{
	s sc= ..data.PriDeleteByArrayPara($g(index))
	d ..ResetScope()
	q sc
}

Method GetMeta() As Meta
{
	q ..meta
}

Method GetScopeFrom() As %String
{
	;d ..ResetScope()
    q ..from
}

Method GetScopeTo() As %String
{
	;d ..ResetScope()
	q ..to
}

/// <method>ValidateDomain</method>检查给定位置所在的索引位置是否是合法的。
/// <var>index</var>要检查的位置
Method ValidateDomain(index = "", from = "", end = "") As %Boolean
{
	;d ..ResetScope()
	s:index="" index=..pivot
	s:from="" from=..from
	s:end="" end=..to
	s array(from)=""
	;s array(index)=""
	s array(end)=""
	q (..data.Data(index)&&($d(array(index))||(($o(array(index))'="")&&($o(array(index),-1)'=""))))
}

Method ResetScope() [ Private ]
{
	s ..from=..data.Order(1,"")
	s ..to=..data.Order(-1,"")
}

}
