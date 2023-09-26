/// 广州乐税信息科技有限公司(乐税)--税盘状态查询入参对象
Class BILL.EINV.DTO.LSA.EInvTaxDiscStatesQueryReq Extends %RegisteredObject
{

/// 系统标识，由乐税提供
Property appID As %String(CAPTION = "系统标识");

/// 以秒为单位的当前时间--示例：1545043005
Property time As %String(CAPTION = "当前时间");

/// appid+appkey+time组成字符串，在用MD5加密出32位长度的字符串，字符串为小写
/// 示例：e2c2d9a797df245d54f668f9deefd7b7
Property token As %String(CAPTION = "加密字符串");

Property sellName As %String(CAPTION = "销售方名称");

Property sellTaxNo As %String(CAPTION = "销售方税号");

/// 税盘分机号  N
Property sellMachineNo As %String(CAPTION = "税盘分机号");

}
