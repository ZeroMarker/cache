Class DHCWL.DM.Core.MulProPhyExecutor Extends %RegisteredObject
{

/// 单个节点的最大Bit长度 最大可设置为：262104;
Parameter MAXBITRANGE = 262104;

/// 分配的最大分区号，适用于数据和索引
Parameter MAXPARTIONNUM = 6;

ClassMethod RootExecutor(procedureId, irp As InternalResolvedParser, ByRef needCmpCubeIdMap)
{
}

}
