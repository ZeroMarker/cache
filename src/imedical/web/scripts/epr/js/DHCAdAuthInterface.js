/**! 
*@desc: ͨ��jsȥͬ������dthealth/web/addins/client/AdAuth/Handler.ashx,��֤ad�ʺ�
*@param: username {string} ad�û���
*@param: psw {string} ad�û�����
*@return: ����ֵ ״̬��^������Ϣ
*״̬��  		    ������Ϣ
*0 ��ʾ��֤ͨ�� 	ss_user��SSUSRInitials�ֶ�ֵ
*-1 ��ʾ��֤ʧ��    AD��������
*-2	��ʾ��֤ʧ��    AD���糬ʱ
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
				return  "-1^AD��������" ;
			}
		}catch(e){
			return  "-2^AD���糬ʱ" ;
		}	
	}
	return "-1^AD��������" ;
}