Class DHCDoc.Interface.Outside.GDHealthCardService.Parameter Extends %RegisteredObject
{

// 应用唯一识别码

/// Parameter appId = "cbfb97d7c44043e48b8b543c5ea77d83";
/// Parameter appId = "60C90F3B796B41878B8D9C393E2B6329";
Parameter appId = "d1f6b2d4dae44469a5e463e0668af11b";

/// 机构唯一识别码 
/// Parameter orgCode = "4400A006208000140";
/// Parameter orgCode = "KGA00020100000014";
Parameter orgCode = "4400A006204000396";

/// 机构应用备案号
/// Parameter appCordNo = "4403A0022APPB0217";
/// Parameter appCordNo = "1301A0002QTHX0001";
Parameter appCordNo = "4400A0062APPB0178";

/// 秘钥密码 
/// Parameter key = "a5e663b7a6584c939761333e37dc78b4";
/// Parameter key = "F2D8D966CD3D47788449C19D5EF2081";
/// Parameter key = "F2D8D966CD3D47788449C19D5EF2081B";
Parameter key = "8f5545f611fe4c9182da0bf2f6026771";

/// 版本号 "V2.0.0";
Parameter version = "V2.0.0";

/// 测试ip http://58.62.175.49:8098/api/do
/// 192.168.200.75 前置机
/// Parameter Server = "58.62.175.49";
Parameter Server = "192.168.200.75";

/// 测试端口
Parameter Port = 8098;

/// 测试地址
Parameter Link = "/api/";

/// 数据签名模式 SM3
Parameter signMode = "SM3";

/// 数据加密模式
/// SM4/ECB/ZeroBytePadding
/// SM4/ECB/Pkcs5Padding
Parameter encryptMode = "SM4/ECB/ZeroBytePadding";

/// 识读终端编码 需传输在卡管系统中注册过的设备码
Parameter terminalCode = "AHSSLYY020001";

/// Parameter terminalCode;

}
