Class DHCWL.APP.Data.XML Extends (Reader, %RegisteredObject)
{

Property onceFrom As %String [ Private ];

Property onceTo As %String [ Private ];

Property dataStorage As DataStorageManager [ Private ];

Property xmlObject As XMLObject [ Private ];

ClassMethod XML(dataStorage As DataStorageManager) As XML
{
	q:dataStorage="" ""
	s xml=##class(XML).%New()
	s xml.dataStorage=dataStorage
	s xml.onceFrom=""
	s xml.onceTo=""
	q:dataStorage.GetMeta()="" ""
	s cursor=dataStorage.GetCursor(dataStorage.GetMeta().GetClassName())
	s xml.xmlObject=##class(XMLObject).Create(cursor,dataStorage)
	q xml
}

/// <method>SetDomain</method>定义Reader的数据区间，对Loader到的数据，默认是按照载人的顺序依次排列的，若设置了排序依据就按照该语句的区间范围。
/// <var>from</var>数据区域的开始坐标,<var>to</var>数据区域的结束坐标<br>
Method SetDomain(from As %String = "", to As %String = "")
{
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	if from="" s from=cursor.GetScopeFrom()
	if to="" s to=cursor.GetScopeTo()
	d cursor.SetScope(from,to)
	;b ;00
	q $$$OK
}

/// <method>GetDomainFrom</method>取得Reader的开始区间。（说明：区间的开始和结束都用闭区间表示）<br>
/// 
Method GetDomainFrom() As %String
{
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	q cursor.GetScopeFrom()
}

/// <method>GetDomainTo</method>取得Reader的结束区间。（说明：区间的开始和结束都用闭区间表示）<br>
/// 
Method GetDomainTo() As %String
{
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	q cursor.GetScopeTo()
}

/// <method>SetOnceDomain</method>定义Reader一次数据的数据区间，对Loader到的数据，默认是按照载人的顺序依次排列的，若设置了排序依据就按照该语句的区间范围。
/// <var>from</var>数据区域的开始坐标,<var>to</var>数据区域的结束坐标<br>
Method SetOnceDomain(onceFrom As %String = "", onceTo As %String = "")
{
	s:onceFrom="" onceFrom=..GetDomainFrom()
	s:onceTo="" onceTo=..GetDomainTo()
	if onceTo>..GetDomainTo() s onceTo=..GetDomainTo()
	if ((onceFrom>=..GetDomainFrom())&&(onceTo<=..GetDomainTo())){
		s ..onceFrom=onceFrom
		s ..onceTo=onceTo
		s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
		d cursor.MoveTo(onceFrom)
	}else{
		w "一次位置设定值无效",!
	}
}

/// <method>GetOnceDomainFrom</method>取得Reader一次数据的开始区间。（说明：区间的开始和结束都用闭区间表示）<br>
/// 
Method GetOnceDomainFrom() As %String [ CodeMode = expression ]
{
..onceFrom
}

/// <method>GetOnceDomainTo</method>取得Reader一次数据的结束区间。（说明：区间的开始和结束都用闭区间表示）<br>
/// 
Method GetOnceDomainTo() As %String [ CodeMode = expression ]
{
..onceTo
}

/// <method>GetDomainCount</method>获取Reader数据域表示的条数
Method GetDomainCount() As %Integer
{
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	s oldPivot=cursor.GetPivot()
	d cursor.MoveTo(..GetDomainFrom())
	s count=0
	s count=0
	while(cursor){
		s count=count+1
		s cursor=cursor.Next()
	}
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	d cursor.MoveTo(oldPivot)
	q count
}

/// <method>GetOnceDomainCount</method>获取Reader一次获取数据域表示的条数
Method GetOnceDomainCount() As %Integer
{
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	s oldPivot=cursor.GetPivot()
	d cursor.MoveTo(..GetOnceDomainFrom())
	s count=0
	while(cursor){
		s count=count+1
		s cursor=cursor.Next()
	}
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	d cursor.MoveTo(oldPivot)
	q count
}

Method OnceNext() As Cursor
{
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	s pivot=cursor.GetPivot()
	;b ;001
	if (cursor.ValidateDomain(pivot,..onceFrom,..onceTo)){
		s cursor=cursor.Next()
		q:cursor="" ""
		s pivot=cursor.GetPivot()
		if (cursor.ValidateDomain(pivot,..onceFrom,..onceTo)){
			q cursor
		}
	}
	q ""
}

Method IsOnceLast() As %Boolean
{
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	s pivot=cursor.GetPivot()
	q pivot=..onceTo
}

/// <method>GetResult</method>设置好Reader的区间范围后就可以通过GetResult方法获取不同格式的数据了，<br>具体什么格式的数据分别使用其具体的子类Json，ReaderResultSet等来表示。<br>该方法的返回值是一个对象的引用，该引用值为Json，ReaderResultSet等格式的对象。
/// 
Method GetResult() As %ObjectHandle
{
	q $this
}

Method GetXMLObject() As XMLObject
{
	q ..xmlObject
	if ((cursor.GetPivot()<=..onceTo)){
		 q ##class(XMLObject).Create(cursor,..dataStorage)
	}
	q ""
}

Method GetXMLStream(onceFrom As %String = "", onceTo As %String = "", rootElementName, ByRef stream As %Library.FileBinaryStream) As %Status
{
	if onceFrom="" s onceFrom=..GetOnceDomainFrom()
	if onceTo="" s onceTo=..GetOnceDomainTo()
	s cursor=..dataStorage.GetCursor(..dataStorage.GetMeta().GetClassName())
	q:cursor="" "还没有配置数据源"
	s oldPivot=cursor.GetPivot()
	s cursor2=cursor.MoveTo(onceFrom)
	if (cursor2){
		s writer=##class(%XML.Writer).%New()
		s writer.Charset="UTF-8"
		s sc= writer.OutputToStream(.stream)
		s sc= writer.StartDocument()
		s sc=writer.RootElement(rootElementName)
		while(cursor2){
			d ..xmlObject.ToStream(.writer)
			q:cursor2.GetPivot()=onceTo
			s cursor2=cursor2.Next()
		}
		s sc=writer.EndRootElement()
    	d writer.EndDocument()
    	d writer.%Close()
	}
    d cursor.MoveTo(oldPivot)
}

}
