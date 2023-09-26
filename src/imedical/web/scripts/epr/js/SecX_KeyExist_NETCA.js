
//1.function GetUserList2()  检查证书是否插入
function getUserList2() {
    var SECUINTER_CURRENT_USER_STORE = 1;
    var SECUINTER_MY_STORE = 0;
    var SECUINTER_CERTTYPE_SIGN = 1;
    var SECUINTER_NETCA_YES = 1;
    var MyCerts = getCerts();
    if (MyCerts.Count > 0) return "@@";
    return "";
}

//2. function HashData(InData)    对传入的数据生成Hash值
function HashData(InData) {
    return hash(InData);
}
