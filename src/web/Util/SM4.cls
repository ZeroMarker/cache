/// 官方文档:https://www.sca.gov.cn/sca/c100061/201611/1002423/files/330480f731f64e1ea75138211ea0dc27.pdf
/// SM4分组加密/解密:..GroupEncrypt/GroupDecrypt
/// SM4只定义了分组密码算法，未定义分组加密模式和填充规则，不同的加密模式和填充规则会得到不同密文
/// 分组加密模式有：ECB、CBC、PCBC等
/// 明文不足128字节整数倍需要填充，填充算法有多种：PKCS7、PKCS5、Zero、ISO 10126、ANSI X9.23等
/// 
/// 使用ECB模式,PKCS7填充明文,0x00填充密钥，加密：w ##class(PHA.Encry.SM4).Encrypt("key","text")
/// 使用ECB模式,PKCS7填充明文,0x00填充密钥，解密：w ##class(PHA.Encry.SM4).Decrypt("key","caacwesVgGyFIGpveJZUAA==")
/// 
/// 官方文档实例一：w ##class(PHA.Encry.SM4).Exp1()
/// 官方文档实例二,太耗时未验证：w ##class(PHA.Encry.SM4).Exp2() 
/// author: ligao
Class web.Util.SM4 Extends %RegisteredObject
{

/// 加密
/// 入参：	key - 密钥
/// 		text - 明文
/// 		retType - 返回类型 Base64 - Base64串，Hex - 16进制串
/// 使用ECB模式,PKCS7填充明文,0x00填充密钥
/// w ##class(PHA.Encry.SM4).Encrypt("key","text")
/// w ##class(PHA.Encry.SM4).Encrypt("key","text","Hex")
ClassMethod Encrypt(key As %String, text As %String, retType As %String = "BASE64")
{
}

/// 
/// w ##class(PHA.Encry.SM4).Decrypt("key","caacwesVgGyFIGpveJZUAA==")
ClassMethod Decrypt(key As %String, text As %String, textType As %String = "BASE64")
{
}

/// 官方文档实例一： 对一组明文用密钥加密一次
/// 密文应为：681edf34d206965e86b3e94f536e4246
/// w ##class(PHA.Encry.SM4).Exp1()
ClassMethod Exp1()
{
}

/// 官方文档实例二： 利用相同加密密钥对一组明文反复加密 1000000 次
/// 太耗时，未验证
/// 密文应为：595298c7c6fd271f0402f804c33d3f66
/// w ##class(PHA.Encry.SM4).Exp2()
ClassMethod Exp2()
{
}

/// SM4分组加密
/// 入参:MK - 128比特密钥，GT - 128比特分组明文 
/// 返回值:128比特字符串
ClassMethod GroupEncrypt(MK, GT)
{
}

/// SM4分组解密
ClassMethod GroupDecrypt(MK, GT)
{
}

/// 将16字节字符串，拆成4个4字节字符串
ClassMethod SplitWord(AAAA, ByRef A)
{
}

/// 轮函数 F
/// 本算法采用非线性迭代结构，以字为单位进行加密运算，称一次迭代运算为一轮变换。
/// 入参都是四个字节
ClassMethod F(Xi, Xi1, Xi2, Xi3, rki)
{
}

/// 合成置换 T
/// 是一个可逆变换，由非线性变换 τ 和线性变换 L 复合而成	
/// 非线性变换 τ 的输出是线性变换 L 的输入
ClassMethod T(A)
{
}

/// 非线性变换 τ
/// τ 由 4 个并行的 S 盒构成。
/// 入参A是4字节，
ClassMethod τ(A)
{
}

/// 线性变换 L
/// B异或(B循环左移2位)异或(B循环左移10位)异或(B循环左移18位)异或(B循环左移24位)
ClassMethod L(B)
{
}

/// 入参一个字符,ascii码范围[00,ff]
/// 返回一个字符
/// w $zh($a(##class(PHA.Encry.SM4).Sbox($c($zh("ef"_"H")))))
ClassMethod Sbox(Char)
{
}

/// 反序变换 R
/// A0,A1,A2,A3 -> A3,A2,A1,A0
/// 每个入参长度4字节
/// 返回16字节
/// w ##class(PHA.Encry.SM4)R("0123456789ABCDEF")
ClassMethod R(A0, A1, A2, A3)
{
}

/// 密钥扩展算法
ClassMethod RK(MK, ByRef rk)
{
}

/// T2变换与加密算法轮函数中的 T 基本相同，只将其中的线性变换 L 修改为以下L2
ClassMethod T2(A)
{
}

/// 线性变换
ClassMethod L2(B)
{
}

/// 固定参数CKi
/// i的范围[0,31]
/// 返回4个字节
/// w ##class(PHA.COM.Encryption.SM3).Str2Hex(##class(PHA.Encry.SM4).CKi(0))
ClassMethod CKi(i)
{
}

/// 返回一个字节
/// w ##class(PHA.Encry.SM4).ckij(##class(PHA.Encry.SM4).ckij($c($zh("ef"_"H")))))
ClassMethod ckij(i, j)
{
}

ClassMethod Hex2Str(hexStr)
{
}

ClassMethod Str2Hex(str)
{
}

/// 无符号比特串转十进制数（循环左移使用）
/// w ##class(PHA.Encry.SM4).Bit2Dec("1111111")
ClassMethod Bit2Dec(BitStr)
{
}

/// 十进制数转无符号比特串（循环左移使用）
/// w ##class(PHA.Encry.SM4).Dec2Bit("15")
ClassMethod Dec2Bit(D)
{
}

/// 比特串转字符串（循环左移使用）
ClassMethod Bit2Str(BitStr)
{
}

/// 字符串转比特串（循环左移使用）
ClassMethod Str2Bit(str)
{
}

/// 循环左移
/// w ##class(PHA.Encry.SM4).ROL("1234567890",10)
ClassMethod ROL(X, n)
{
}

/// 异或
/// w ##class(PHA.Encry.SM4).XOR("1010","0101")
ClassMethod XOR(X, Y)
{
}

/// 明文填充分组
ClassMethod PaddingGroup(text, ByRef group)
{
}

/// 密钥填充
ClassMethod KeyPadding(key)
{
}

/// 密文分组
ClassMethod CipherTextGroup(text, ByRef group)
{
}

}
