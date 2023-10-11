/**
* Description: ���CAǩ��
* FileName: dhcpe.cacommon.js
* Creator: wangguoying
* Date: 2022-10-11
*/
var $PECA = {
    enable: true,   //�Ƿ��������CAǩ��
    modeCodeArr: ["PEResult", "PEStationCommit", "PEReportAudit", "PEReportAudit"], //ǩ��ģ�����  �ֱ��Ӧ���ҵ�����PESaveCASign��SignTypeλ������ 0��ҽ��¼�� 1�������ύ  2������  3������
    option: {
        logonType: "",     // UKEY|PHONE|FACE|SOUND|"" ��ʱ��������ǩ����ʽ�����������̶���
        singleLogon: 0,     //0-������ҳǩǩ����1-����ǩ����ʽ
        forceOpen: ""    //1-ǿ��ÿ�ζ�����ǩ������  ���գ���ȡ����
        //isHeaderMenuOpen:true, //�Ƿ���ͷ�˵���ǩ������. Ĭ�� true
        //SignUserCode:txtUser, //����ǩ���� HIS���ţ���У��֤���û��� HIS����. Ĭ�Ͽ�
        //signUserType:"", // Ĭ�Ͽգ���ʾǩ���û��뵱ǰ HIS�û�һ�¡�ALLʱ����֤�û���֤��
        //notLoadCAJs:1, //��¼�ɹ��󣬲���ͷ�˵����� CA
        //loc:deptDesc, //���� id��������Ĭ�ϵ�ǰ��¼����
        //groupDesc:groupDesc, //��ȫ��������Ĭ�ϵ�ǰ��¼��ȫ��
        //caInSelfWindow:1 //�û���¼���л����ҹ��ܣ� ҵ���鲻��
    }
}

/**
* [CAǩ��]
* @param    {[String]}    SignType    [0��ҽ��¼�� 1�������ύ  2������  3������]
* @param    {[String]}    ExpStr    [ҽ��¼�룺ҽ��ID  �����ύ������ID%վ��ID  ����/���󣺾���ID]
* @param    {[String]}    Data    [Ҫǩ��������] 
* @param    {[Function]}    CallFunc    [�ص�����]   
* @param    {[Object]}    CallParamObj    [�ص��������]   
* @Author wangguoying
* @Date 2022-10-11
*/
$PECA.CASign = function (SignType, ExpStr, Data, CallFunc, CallParamObj) {
    if (!this.enable) return CallFunc(CallParamObj);
    var opts = this.option;
    opts.modelCode = this.modeCodeArr[SignType];
    dhcsys_getcacert({
	    modelCode:opts.modelCode, /*ǩ��ģ���д���*/
        callback: function (certn) {
            if (certn.IsSucc) {
                if (certn.ContainerName == "") {
                    CallFunc(CallParamObj);
                } else {
                    if ("object" == typeof certn) {
                        $PECA.Save(certn, SignType, ExpStr, Data, CallFunc, CallParamObj);
                    }
                }
            } else {
                alert("ǩ��ʧ�ܣ�");
                return false;
            }
        }
    }, opts.logonType, opts.singleLogon, opts.forceOpen);
}

/**
* [����ǩ������]
* @param    {[Object]}    certn    CAǩ�����ض���
* @param    {[String]}    SignType    [0��ҽ��¼�� 1�������ύ  2������  3������]
* @param    {[String]}    ExpStr    [ҽ��¼�룺ҽ��ID  �����ύ������ID%վ��ID  ����/���󣺾���ID]
* @param    {[String]}    Data    [Ҫǩ��������] 
* @param    {[Function]}    CallFunc    [�ص�����]   
* @param    {[Object]}    CallParamObj    [�ص��������]     
* @Author wangguoying
* @Date 2022-10-11
*/
$PECA.Save = function (certn, SignType, ExpStr, Data, CallFunc, CallParamObj) {
    var toSignData = Data != "" ? Data : tkMakeServerCall("web.DHCPE.CA.Main", "GetSignData", SignType, ExpStr);
    var hashData = certn.ca_key.HashData(toSignData);
    var signData = certn.ca_key.SignedData(hashData, certn.ContainerName);
    ExpStr = SignType+"^"+session["LOGON.USERID"]+"^"+ ExpStr; 
    var saveRtn = tkMakeServerCall("web.DHCPE.CA.Main", "SaveCASign", hashData, certn.CAUserCertCode, certn.ContainerName, signData, ExpStr, certn.CACertNo);
    if (saveRtn.split("^")[0] == "1") {
        CallFunc(CallParamObj);
    } else {
        alert("����ǩ������ʧ�ܣ�");
        return false;
    }
}
