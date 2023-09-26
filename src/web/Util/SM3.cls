/// 提供HMAC-SM3算法 与 SM3密码杂凑算法
/// 入参可用流或者字符串
/// 包含中文无需转UTF8,程序会进行UTF8编码
/// @author: ligao
Class web.Util.SM3 Extends %RegisteredObject
{

/// HMAC-SM3算法
/// w ##class(PHA.Encry.SM3Util).HMAC("key","text")
ClassMethod HMAC(key As %Stream.GlobalCharacter, text As %Stream.GlobalCharacter)
{
}

/// SM3密码杂凑算法
/// 入参 text比较长时用流,如果包含中文需要转UTF8
/// w ##class(PHA.COM.Encryption.SM3).Hash("abc")
ClassMethod Hash(text As %Stream.GlobalCharacter)
{
}

ClassMethod HashByte(bitstr As %Stream.GlobalCharacter)
{
}

/// w ##class(PHA.COM.Encryption.SM3).Padding("1",.B)
ClassMethod Padding(stream As %Stream.GlobalCharacter, Output B)
{
}

/// 压缩函数
ClassMethod CF(Vi, Bi)
{
}

/// 扩展函数
ClassMethod Ext(Bi, Output W, Output WW)
{
}

ClassMethod FF(j, X, Y, Z)
{
}

ClassMethod GG(j, X, Y, Z)
{
}

ClassMethod FFa(X, Y, Z)
{
}

ClassMethod FFb(X, Y, Z)
{
}

ClassMethod GGa(X, Y, Z)
{
}

ClassMethod GGb(X, Y, Z)
{
}

ClassMethod P0(X)
{
}

ClassMethod P1(X)
{
}

ClassMethod XOR3(X, Y, Z)
{
}

/// w ##class(PHA.COM.Encryption.SM3).XOR("1010","0101")
ClassMethod XOR(X, Y)
{
}

/// w ##class(PHA.COM.Encryption.SM3).AND("1010","0101")
ClassMethod AND(X, Y)
{
}

/// w ##class(PHA.COM.Encryption.SM3).OR("1010","0101")
ClassMethod OR(X, Y)
{
}

/// w ##class(PHA.COM.Encryption.SM3).NotXAndY("1010","0101")
ClassMethod NotXAndY(X, Y)
{
}

/// w ##class(PHA.COM.Encryption.SM3).ROL("1234567890",10)
ClassMethod ROL(X, n)
{
}

/// w ##class(PHA.COM.Encryption.SM3).T(32)
ClassMethod T(j)
{
}

ClassMethod Mod232(X, Y)
{
}

ClassMethod UTF8(data)
{
}

/// w ##class(PHA.Encry.SM3).Bit2Dec("1111111")
ClassMethod Bit2Dec(BitStr)
{
}

/// w ##class(PHA.Encry.SM3).Dec2Bit("15")
ClassMethod Dec2Bit(D)
{
}

ClassMethod Bit2Str(BitStr)
{
}

ClassMethod Str2Bit(str)
{
}

ClassMethod Hex2Str(hexStr)
{
}

ClassMethod Str2Hex(str)
{
}

/// w ##class(PHA.COM.Encryption.SM3).Str2Dec("1111111")
ClassMethod Str2Dec(str)
{
}

/// w ##class(PHA.COM.Encryption.SM3).Dec2Str("15")
ClassMethod Dec2Str(DecSum)
{
}

/// 一个字转带正负号的整数
/// w ##class(PHA.COM.Encryption.SM3).BitStr2SignDec("1111111")
ClassMethod Word2SignDec(BitStr)
{
}

ClassMethod KeyPadding(key As %Stream.GlobalCharacter)
{
}

ClassMethod IPad()
{
}

ClassMethod OPad()
{
}

}
