Class BILL.EINV.DTO.STGLA.EInvStatesLocalQryRes Extends %RegisteredObject
{

Property ID As %String(CAPTION = "开票数据ID");

Property METHOD As %String(CAPTION = "类型");

Property LX As %String(CAPTION = "类型");

Property DWID As %String(CAPTION = "单位ID");

Property DWBM As %String(CAPTION = "单位编码");

Property YWLSH As %String(CAPTION = "业务流水号");

Property CJSJ As %String(CAPTION = "创建时间");

Property GXSJ As %String(CAPTION = "更新时间");

Property KPDBM As %String(CAPTION = "开票点编码");

Property KPDMC As %String(CAPTION = "开票点名称");

Property YWRQ As %String(CAPTION = "业务日期");

Property PJDM As %String(CAPTION = "票据代码");

Property PJHM As %String(CAPTION = "票据号码");

Property DZ1 As %String(CAPTION = "票据二维码地址");

Property DZ2 As %String(CAPTION = "票据下载地址");

Property DZ4 As %String(CAPTION = "财政票据地址");

Property TYPE As %String(CAPTION = "状态");

Property MSG As %String(CAPTION = "财政返回");

Property JG As %String(CAPTION = "开票结果");

Property XZTYPE As %String(CAPTION = "下载状态");

Property SFHC As %String(CAPTION = "是否已红冲");

Property SFHK As %String(CAPTION = "是否已换开");

Property SFZF As %String(CAPTION = "是否已作废");

Property HCYY As %String(CAPTION = "红冲原因");

Property YPJDM As %String(CAPTION = "原电子票据代码");

Property YPJHM As %String(CAPTION = "原电子票据号码");

Property ZZPJDM As %String(CAPTION = "纸质票据代码");

Property ZZPJHM As %String(CAPTION = "纸质票据号码");

Property HKTYPE As %String(CAPTION = "换开状态");

Property HKJG As %String(CAPTION = "换开结果");

Property HKZZPJDM As %String(CAPTION = "换开纸质票据代码");

Property HKZZPJHM As %String(CAPTION = "换开纸质票据号码");

Property HKSJ As %String(CAPTION = "换开时间");

Property ZFTYPE As %String(CAPTION = "作废状态");

Property ZFYY As %String(CAPTION = "作废原因");

Property ZFJG As %String(CAPTION = "作废结果");

Property ZFZZPJDM As %String(CAPTION = "作废纸质票据代码");

Property ZFZZPJHM As %String(CAPTION = "换开纸质票据号码");

Property ZFSJ As %String(CAPTION = "作废时间");

Property HKZF As BILL.EINV.DTO.STGLA.HKZFInfo(CAPTION = "换开及作废明细信息");

}
