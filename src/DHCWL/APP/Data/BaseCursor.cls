Class DHCWL.APP.Data.BaseCursor Extends DHCWL.APP.Data.Cursor
{

Property pivot As %Integer [ Private ];

Property from As %Integer [ Private ];

Property end As %Integer [ Private ];

Property dataSet As DataStorage;

ClassMethod InitBaseCursor(dataSet As DataStorage, curPivot As %Integer = 1) As BaseCursor
{
	s cursor=##class(BaseCursor).%New()
	s cursor.dataSet=dataSet
	s cursor.pivot=curPivot
	d cursor.SetScope()
	q cursor
}

/// <method>MoveToFirst</mothod>直接将游标移动到数据集的开始位置。该方法会返回游标位置的对象引用。<br>
Method MoveToFirst() As Cursor
{
	if ..from s ..pivot=..from
	else  s ..pivot=..dataSet.dataCache.Order(1,"")
	q $this
}

/// <method>MoveToLast</mothod>直接将游标移动到数据集的最后位置。该方法会返回游标位置的对象引用。<br>
Method MoveToLast() As Cursor
{
	if (..end ) s ..pivot=..end
	else  s ..pivot=..dataSet.dataCache.Order(-1,"")
	q $this
}

/// <method>MoveToLast</mothod>该方法的作用时将游标移动到指定的index位置处，并返回该位置的游标，若位置index非法就返回空。<br>
/// <var>index</var>数据集位置index
Method MoveTo(index) As Cursor
{
	if (..ValidateDomain(index) ){
		s ..pivot=index
		q $this
	}else{
		s ..pivot=0
	}
	q ""
}

/// <method>Next</mothod>迭代到下一个游标位置。该方法会返回游标位置的对象引用。<br>
Method Next() As Cursor
{
	if (..ValidateDomain(..pivot+1) ) {
		s ..pivot=..pivot+1
		q $this
	}
	q ""
}

/// <method>Get</mothod>该方法的作用是得到该游标位置给定property属性的属性值。若属性表示的是一个复合属性则返回Cursor引用，然后可以根据该引用进一步访问属性值。<br>
/// <var>propertyName</var>参为属性名字propertyName，若访问该属性下的复合属性的属性值则用paraProName.childProName的形式，用英文点号分割。
Method Get(propertyName As %String)
{
	if (..ValidateDomain(..pivot) ) {
		q ..dataSet.Get(..pivot,propertyName)
	}
	q ""
}

/// <method>IsFirst</method>判定当前游标是否已经在开始数据集的位置。<br>
Method IsFirst() As %Boolean
{
	q ..pivot=..from
}

/// <method>IsFirst</method>判定当前游标是否已经在最后一个数据集的位置。<br>
Method IsLast() As %Boolean
{
	q ..pivot=..end
}

/// <method>SetScope</method>设定游标可以游动的数据集范围
/// <var>from</var>开始位置；<var>end</var>结束位置
Method SetScope(from = "", end = "") As %Status
{
	if from=0 s from=..dataSet.dataCache.Order(1,"")
	if end=0  s end=..dataSet.dataCache.Order(-1,"")
	if end>..dataSet.dataCache.Order(-1,"") s end=..dataSet.dataCache.Order(-1,"")
	if (((from>0)&&(from<=..dataSet.dataCache.Order(-1,"")))&&((end>=from)&&(end<=..dataSet.dataCache.Order(-1,"")))) {
		s ..from=from,..end=end
		q 1
	}else {
		s ..from=0,..end=0
	}
	q "位置"_from_"或"_end_"非法"
}

/// <method>GetScopeFrom</method>获取数据区间的开始区间位置
Method GetScopeFrom() As %String [ CodeMode = expression ]
{
..from
}

/// <method>GetScopeTo</method>获取数据区间的结束区间位置
Method GetScopeTo() As %String [ CodeMode = expression ]
{
..end
}

/// <method>ValidateDomain</method>检查给定位置所在的索引位置是否是合法的。
/// <var>index</var>要检查的位置
Method ValidateDomain(index) As %Boolean
{
	if ((..from<=index)&&(index<=..end)){
		q 1
	}else{
		w "游标已经出界，当前游标位置："_..pivot_" 左闭区间："_..from_" 右闭区间"_..end,!
		q 0
	}
}

/// <method>GetMeta</method>获取该数据集下的定义信息，返回Meta对象的定义
/// 
Method GetMeta() As Meta [ CodeMode = expression ]
{
..dataSet.GetMeta()
}

Method GetPivot() As %String [ CodeMode = expression ]
{
..pivot
}

}
