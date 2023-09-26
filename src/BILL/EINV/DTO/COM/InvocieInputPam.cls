/// 存储开票方法的所有入参信息(把扩展字符串的各个位置解析后保存到这个对象中)
Class BILL.EINV.DTO.COM.InvocieInputPam Extends %RegisteredObject
{

Property ErrMsgInfo As %String(CAPTION = "错误信息");

Property ObjUPConfig As BILL.EINV.PO.InvUpConfig(CAPTION = "服务配置信息对象");

Property ObjInvLogicPath As BILL.EINV.PO.InvLogicPath(CAPTION = "业务处理配置信息对象");

/// 本次交易 对应的交易表Dr(上次交易属于没有完成的异常交易时,这个属性才有值。例：博思的开具票据业务失败
/// 导致交易没有进行完时、博思开具业务成功但是我们更新数据失败时)
Property UpDetailDr As %String(CAPTION = "交易表Dr");

/// 原交易表Dr(前置交易Dr) 冲红电子票据 换开纸质票据 作废纸质票据等业务存在原交易
Property OriUpDetailDr As %String(CAPTION = "原交易表Dr(前置交易Dr)");

/// 原已换开纸质票据 交易表Dr (重新换开纸质票据的时候使用)
Property OriPaperUpDetailDr As %String(CAPTION = "交易表Dr");

/// +dongkf 2019 12 12 唐山中心医院开票需要 税控设备编码
Property TaxSBBM As %String(CAPTION = "税控设备编码");

/// +dongkf 2019 12 25
Property HospitalInfoMap As %ArrayOfDataTypes(CAPTION = "医院配置信息集合");

/// 走号标志 1 走号 0 不走号
Property JumpEnvNoFlg As %String(CAPTION = "走号标志");

/// 走号类型 1 第三方服务成功后走号 0 第三方服务成功前就走号
Property JumpNoType As %String(CAPTION = "走号类型");

/// add by xubaobao 2020 09 07 
/// 体检数据存储类型 1 从体检发票表取数据 0 从门诊发票表取数据(注意体检发票表有数据一定要从体检发票表取数据)
Property PEStorageType As %String(CAPTION = "体检数据存储类型");

/// ===============================================================================================================
/// 从这里开始往下 都是直接从入参获取 或者 根据入参简单计算而来
Property PayAdmType As %String(CAPTION = "票据业务类型");

Property HISPrtRowID As %String(CAPTION = "HIS发生业务ID");

Property OrgHISPrtRowID As %String(CAPTION = "原业务ID(正业务为空)");

Property PathCode As %String(CAPTION = "申请路径代码");

/// 票据模式 E-电子票据 P-纸质发票
Property IUDPrintType As %String(CAPTION = "票据模式");

/// add by xubaobao 2021 03 02 电子发票调用方式;		
/// 1：调用平台组请求，2：通过webservice请求调用，其他：http请求调用
Property RequestType As %String(CAPTION = "第三方请求方式");

/// add by guoyunlong 2022-02-25		
/// 1：是多院区，需要传院区  空或者其他不需要传院区
Property HospitalFlag As %String(CAPTION = "多院区配置");

/// 操作员ID^安全组^科室^院区
Property ExpStr As %String(CAPTION = "扩展字符串");

Property UserID As %String(CAPTION = "操作员ID");

Property GroupID As %String(CAPTION = "安全组ID");

Property CTLocID As %String(CAPTION = "科室ID");

Property HospitalID As %String(CAPTION = "院区ID");

Property AdmreasonDr As %String(CAPTION = "费别Dr");

Property UserCode As %String(CAPTION = "操作员编码");

Property UserDesc As %String(CAPTION = "操作员名称");

Property pBillBatchCode As %String(CAPTION = "纸质票据代码");

Property pBillNo As %String(CAPTION = "纸质票据号");

}
