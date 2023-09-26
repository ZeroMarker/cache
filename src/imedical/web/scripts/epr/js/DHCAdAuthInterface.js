/**! 
*@desc: 通过js去同步访问dthealth/web/addins/client/AdAuth/Handler.ashx,认证ad帐号
*@param: username {string} ad用户名
*@param: psw {string} ad用户密码
*@return: 返回值 状态码^返回信息
*状态码  		    返回信息
*0 表示验证通过 	ss_user表SSUSRInitials字段值
*-1 表示验证失败    AD网络问题
*-2	表示验证失败    AD网络超时
*/
if("undefined" == typeof DHCAdAuthInterface){
	DHCAdAuthInterface = {};
}
DHCAdAuthInterface.AdAuth = function (username,psw){
	var AuthRet = "";
	var ADErrMsgObj = {};
	var url = '/dthealth/web/addins/client/AdAuth/Handler.ashx';
	var xhr = cspFindXMLHttp();
	xhr.open("POST", url ,false);
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xhr.send('userName='+username+'&password='+psw+"&timestamp="+new Date());
	if(xhr.readyState == 4){			
		try{
			if(xhr.status >= 200 && xhr.status < 300){
				AuthRet = xhr.responseText;
				authErrCode = AuthRet.split("^")[0];
				authErrInfo = AuthRet.split("^")[1];
				if (authErrCode == "0") {
					return "0^"+authErrInfo;
				}else{
					return 	authErrCode+authErrInfo;			
				}
			}else{
				return  "-1^AD网络问题" ;
			}
		}catch(e){
			return  "-2^AD网络超时" ;
		}	
	}
	return "-1^AD网络问题" ;
}