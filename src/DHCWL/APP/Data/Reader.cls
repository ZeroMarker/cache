Class DHCWL.APP.Data.Reader [ Abstract ]
{

/// <method>SetDomain</method>定义Reader的数据区间，对Loader到的数据，默认是按照载人的顺序依次排列的，若设置了排序依据就按照该语句的区间范围。
/// <var>from</var>数据区域的开始坐标,<var>to</var>数据区域的结束坐标<br>
Method SetDomain(from As %String, to As %String)
{
}

/// <method>GetDomainFrom</method>取得Reader的开始区间。（说明：区间的开始和结束都用闭区间表示）<br>
/// 
Method GetDomainFrom() As %String
{
}

/// <method>GetDomainTo</method>取得Reader的结束区间。（说明：区间的开始和结束都用闭区间表示）<br>
/// 
Method GetDomainTo() As %String
{
}

/// <method>SetOnceDomain</method>定义Reader一次数据的数据区间，对Loader到的数据，默认是按照载人的顺序依次排列的，若设置了排序依据就按照该语句的区间范围。
/// <var>from</var>数据区域的开始坐标,<var>to</var>数据区域的结束坐标<br>
Method SetOnceDomain(from As %String, to As %String)
{
}

/// <method>GetOnceDomainFrom</method>取得Reader一次数据的开始区间。（说明：区间的开始和结束都用闭区间表示）<br>
/// 
Method GetOnceDomainFrom() As %String
{
}

/// <method>GetOnceDomainTo</method>取得Reader一次数据的结束区间。（说明：区间的开始和结束都用闭区间表示）<br>
/// 
Method GetOnceDomainTo() As %String
{
}

/// <method>GetDomainCount</method>获取Reader数据域表示的条数
Method GetDomainCount() As %Integer
{
}

/// <method>GetOnceDomainCount</method>获取Reader一次获取数据域表示的条数
Method GetOnceDomainCount() As %Integer
{
}

/// <method>GetResult</method>设置好Reader的区间范围后就可以通过GetResult方法获取不同格式的数据了，<br>具体什么格式的数据分别使用其具体的子类Json，ReaderResultSet等来表示。<br>该方法的返回值是一个对象的引用，该引用值为Json，ReaderResultSet等格式的对象。
/// 
Method GetResult() As %ObjectHandle
{
}

}
