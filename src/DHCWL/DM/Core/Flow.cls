/// Creator：      lihaihong
/// CreatDate：    20170602
/// Description：   Flow表示将CQL数据转换成流便于编程的抽象接口，该流的源头（from）是已知的一个CQL，流向（to）为目标CQL
///                有了Flow之后我们就可以使用CQL来编程，是CQL变活，通过M语言控制CQL。可以完成流的Map、Filter操作。
///                Flow操作完成后调用Finish方法形成新的CQL结果集后续可以再用CQL语法对它进行计算。
Class DHCWL.DM.Core.Flow Extends %RegisteredObject
{

/// Creator：      lihaihong
/// CreatDate：    20170602
/// Description:：   流数据转换及其过滤处理函数，使流的数据从fromData转换成toData
/// Input：          fromData表示流源头的数据，为一个数组，数组下标是源的维度或者度量名字该下标的值为维度或者度量的值。
/// Output：         toData表示流数据被转换后的数据，格式也是一个数组，下标是目标数据的维度或者度量名字，下标的值为维度或者度量的值。
/// Return：         布尔值，true表示保留该条流数据，否则丢弃。
Method Flowing(ByRef fromData, ByRef toData) As %Boolean
{
}

/// Creator：      lihaihong
/// CreatDate：    20170602
/// Description:：   通知流数据已经流完，可以做一些清理性的工作
/// Input：          无
/// Output：         无
/// Return：         无
Method Finish()
{
}

}
