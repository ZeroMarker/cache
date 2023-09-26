//ȫ�ֱ�������
var GET_SIGN_SCRIPT          = 1;   //��ȡ�ʼ�ͼƬ
var GET_SIGN_FINGERPRINT     = 2;   //��ȡָ��ͼƬ
var GET_SIGN_CERT            = 3;   //��ȡ�¼�֤��
var GET_SIGN_TIMESTAMP       = 4;   //��ȡʱ���
var GET_CERT_SIGNER          = 5;   //��ȡǩ����
var GET_SIGN_TIME            = 6;   //��ȡǩ��ʱ��
var GET_TS_PLAINDATA         = 7;   //��ȡʱ���ԭ��
var GET_SIGN_PHOTO           = 8;   //��ȡǩ��ʱ�������Ƭ

//���ƶ�������ǩ��
function Sign(plaintext, user, cardtype, cardNo)
{
    var idCard =
    {
        Type: cardtype,
        Number: cardNo
    }
    
    var signinfo =
    {
        Signer:user,
        IDCard:idCard
    }
    var inputjson = $.toJSON(signinfo);
    var signvalue = "";
    
    try
    {
        var signvalue = anysign.sign_data(inputjson, plaintext);
    }
    catch(err)
    {
        return 67;
    }
    
    if(signvalue == "")
    {
        var lastError = anysign.getLastError();
        
        return lastError;
    }
    else
    {
        return signvalue;
    }
    
}

function VerifySignature(plaintext, signaturejson)
{
    var signtime = "";
    var verifyStr = "";
    var plaintext;
    
    var ret = anysign.verify_sign_value(signaturejson,plaintext);
    if(ret == 0)
    {
        return ret;
    }
    else
    {
        var lastError = anysign.getLastError();
        return lastError;
    }
}

//�ƶ���ǩ��������ǩ����Ϣ
function pushSignInfo(DocName, DocID, UserName, UserID, DoctorName, DoctorID, plaintext, pdfPath)
{
    var signinfo =
    {
        DocName : DocName.split("-")[0],//�ַ������ĵ�����
        DocID : DocID,//�ַ������ĵ���ţ�ҵ��Ψһ���
        UserName : UserName,//�ַ�������������
        UserID : UserID,//�ַ���������ID
        DoctorName : DoctorName,//�ַ�����ҽ������
        DoctorID : DoctorID,//�ַ�����ҽ��ID
        UserData : plaintext//�ַ�������������
    }
    var inputjson = $.toJSON(signinfo);
    
    var pushret = "";
    try
    {
        var ba64path = anysign.Base64Encode(pdfPath,"GBK");
        var pdfsha1 = anysign.hash_file(ba64path , 1);
        if (pdfsha1==DocName.split("-")[1])
        {
            pushret = mobilesign.AnySignUploadPdf(inputjson, pdfPath);
        }
        //pushret = mobilesign.AnySignUploadPdf(inputjson, pdfPath);
    }
    catch(err)
    {
        return 67;
    }
    
    return pushret;
}

function getMobileSignStatus(DocName, DocID, UserName, UserID, DoctorName, DoctorID, plaintext)
{
    var signinfo =
    {
        DocName : DocName,
        DocID : DocID,
        UserName : UserName,
        UserID : UserID,
        DoctorName : DoctorName,
        DoctorID : DoctorID,
        UserData : plaintext
    }
    var inputjson = $.toJSON(signinfo);
    
    var signvalue = "";
    try
    {
        var signvalue = mobilesign.AnySignUpdatePdfsStatus(inputjson, 1);
        signvalue = anysign.Base64Decode(signvalue);
    }
    catch(err)
    {
        return 67;
    }
    
    if(signvalue == "")
    {
        //var lastError = anysign.getLastError();
        var lastError = mobilesign.AnySignGetLastError()
        return lastError;
    }
    else
    {
        var delret = deletePDF(inputjson);
        if(delret == 0)
        {
            //alert("ɾ��PDF�ɹ�");
            return signvalue
        }
        else
        {
            alert("��ѯǩ��״̬���󣬴����� = " + delret);
            return 1000;
        }
    }
}

function getSignCount(signvalue)
{
    return anysign.get_count_signature(signvalue)
}

function getScatterSign(signvalue,signindex)
{
    return anysign.get_index_signature(signvalue,signindex);
}

function deletePDF(inputjson)
{
    var delret = mobilesign.AnySignDeletePdfs(inputjson);
    return delret;
}

//function getSignInfo(signvalue, infotype, plaintext,infoindex)
function getSignInfo(signvalue, infotype, plaintext)
{
    if(infotype == "1")
    {
        var scriptimage = anysign.get_sign_script(signvalue, 1);
        if(scriptimage == "")
        {
            //alert("��ȡ�ʼ�ͼƬʧ��");
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        
        return scriptimage;
    }
    
    if(infotype == "2")
    {
        var fingerimage = anysign.get_sign_fingerprint(signvalue, 2);
        if(fingerimage == "")
        {
            var lastError = anysign.getLastError();
            
            //alert("��ȡָ��ͼƬʧ��");
            return lastError;
        }
        
        return fingerimage;
    }
    
    if(infotype == "3")
    {
        //�¼�֤��
        var signCert = anysign.get_sign_cert(signvalue);
        if(signCert != "")
        {
            return signCert;
        }
        else
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
    }
    
    if(infotype == "4")
    {
        var tsvalue = anysign.get_ts_value(signvalue);
        if(tsvalue == "")
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        return tsvalue;
    }
    
    if(infotype == "5")
    {
        var csvalue = anysign.get_cert_signer(signvalue);
        if(csvalue == "")
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        return csvalue
    }
    
    if(infotype == "6")
    {
        var signtime = anysign.get_sign_time(signvalue);
        if(signtime == "")
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        return signtime;
    }
    
    if(infotype == "7")
    {
        var tsplaindata = anysign.get_ts_plaindata(signvalue, plaintext);
        if(tsplaindata == "")
        {
            var lastError = anysign.getLastError();
            
            return lastError;
        }
        return tsplaindata;
    }
    
     if(infotype == "8")
    {
        var photoCount = anysign.get_count_sign_photo(signvalue);
        //var signvalue = signRet3;
        if(photoCount>0)
        {
            var patphoto = anysign.get_sign_photo(signvalue, 0);
            if(patphoto == "")
            {
                var lastError = anysign.getLastError();
                
                return lastError;
            }
            return patphoto;
        }
    }
}

function errorInfo(errCode)
{
    var errInfo = "";
    
    switch(errCode)
    {
        case 0  :
            errInfo = '��������';
            break;
        case 1  :
            errInfo = '����jsonΪ��';
            break;
        case 2  :
            errInfo = '����json����ʧ��';
            break;
        case 3  :
            errInfo = 'IDCard����ʧ��';
            break;
        case 4  :
            errInfo = 'IDCard����object';
            break;
        case 5  :
            errInfo = '֤�����Ͳ����ַ���';
            break;
        case 6  :
            errInfo = '֤�����벻���ַ���';
            break;
        case 7  :
            errInfo = 'ָ��ͼƬ����Ϊ��';
            break;
        case 8  :
            errInfo = '��д�켣ͼƬΪ��';
            break;
        case 9  :
            errInfo = 'DeviceIDΪ��';
            break;
        case 10 :
            errInfo = '��ȡ��дͼƬʧ��';
            break;
        case 11 :
            errInfo = '��ȡָ��ͼƬʧ��';
            break;
        case 12 :
            errInfo = '���ܺ�BIO_FEATURE����Ϊ��';
            break;
        case 13 :
            errInfo = '����BIO_FEATURE����ʧ��';
            break;
        case 14 :
            errInfo = 'ǩ���˲����ַ���';
            break;
        case 15 :
            errInfo = 'init_XTXʧ��';
            break;
        case 16 :
            errInfo = '��ȡ��ǩ��ֵΪ��';
            break;
        case 17 :
            errInfo = '��ȡǩ��ֵʧ��';
            break;
        case 18 :
            errInfo = '����֤��ʧ��';
            break;
        case 19 :
            errInfo = 'ʱ���Ϊ��';
            break;
        case 20 :
            errInfo = '����ʱ���ʧ��';
            break;
        case 21 :
            errInfo = '�򿪰�ȫǩ����ʧ�ܣ�����ǩ�����Ƿ�����������';
            break;
        case 22 :
            errInfo = '�¼�֤��Ϊ��';
            break;
        case 23 :
            errInfo = '֤����������Ϊ��';
            break;
        case 24 :
            errInfo = 'Init AnySignClientʧ��';
            break;
        case 25 :
            errInfo = '��д�켣����Ϊ��';
            break;
        case 26 :
            errInfo = 'ǩ��������Ϊ��';
            break;
        case 27 :
            errInfo = '�Գƽ���ʧ��';
            break;
        case 28 :
            errInfo = '�Գƽ��ܷ�������Ϊ��';
            break;
        case 29 :
            errInfo = '����BioFeatureʧ��';
            break;
        case 30 :
            errInfo = '�����ǩ����Ϊ��';
            break;
        case 31 :
            errInfo = '�����ԭ��Ϊ��';
            break;
        case 32 :
            errInfo = '���������ǩ�������ݸ�ʽ����';
            break;
        case 33 :
            errInfo = 'ǩ��ֵ��֤ʧ��';
            break;
        case 34 :
            errInfo = '��ȡ֤����������ʧ��';
            break;
        case 35 :
            errInfo = 'ʹ�ò�֧�ֵ�ͼƬ��ʽ';
            break;
        case 36 :
            errInfo = '���ñʼ���Ⱥ���ɫʧ��';
            break;
        case 37 :
            errInfo = '����signDeviceʧ��';
            break;
        case 38 :
            errInfo = 'showdialogʧ��';
            break;
        case 39 :
            errInfo = '��ȡ��дָ����Ϣʧ��';
            break;
        case 40 :
            errInfo = '����adaptor����ʧ��';
            break;
        case 41 :
            errInfo = '����֤������ʧ��';
            break;
        case 42 :
            errInfo = '����֤������ʧ��';
            break;
        case 43 :
            errInfo = '����ǩ��������ʧ��';
            break;
        case 44 :
            errInfo = '����ԭ������ʧ��';
            break;
        case 45 :
            errInfo = '����crypto����ʧ��';
            break;
        case 46 :
            errInfo = '����֤�������ʽjsonʧ��';
            break;
        case 47 :
            errInfo = '��ȡ֤������ʧ��';
            break;
        case 48 :
            errInfo = 'ǩ������EventCertΪ��';
            break;
        case 49 :
            errInfo = 'ǩ������TSValueΪ��';
            break;
        case 50 :
            errInfo = '�����ǩ���㷨������Ч����';
            break;
        case 51 :
            errInfo = '��ȡǩ����������ָ��ͼƬΪ��';
            break;
        case 52 :
            errInfo = '��ȡǩ������д�켣ͼƬΪ��';
            break;
        case 53 :
            errInfo = '����Biofeature��ϣʧ��';
            break;
        case 54 :
            errInfo = 'Biofeatur��ϣֵΪ��';
            break;
        case 55 :
            errInfo = '����bio_hashʧ��';
            break;
        case 56 :
            errInfo = '��ȡ֤����BIO_HASHʧ��';
            break;
        case 57 :
            errInfo = '����֤��BIO_HASH����Ϊ��';
            break;
        case 58 :
            errInfo = '�Ƚ�֤��BIO_HASHʧ��';
            break;
        case 59 :
            errInfo = 'û�м�⵽ǩ���豸';
            break;
        case 60 :
            errInfo = 'ǩ���豸���ǰ�ȫǩ����,��ǰֻ֧�ְ�ȫǩ����';
            break;
        case 61 :
            errInfo = '�û�ȡ��ǩ��';
            break;
        case 62 :
            errInfo = '��ȡ֤��ǩ����ʧ��';
            break;
        case 63 :
            errInfo = '��ȡ֤��ǩ����Ϊ��';
            break;
        case 64 :
            errInfo = '֤�����Ͳ���ȷ';
            break;
        case 65 :
            errInfo = '�������json����json object';
            break;
        case 66 :
            errInfo = 'ǩ��ʱ������Ϊ��';
            break;
        case 67 :
            errInfo = "����ͻ��˻����Ƿ�װ��";
            break;
        //case 67:
        //    errInfo = "����ǩ�����ʧ��";
        //    break;
        case 68:
            errInfo = "�����ǩ�����Ϊ��";
            break;
        case 69:
            errInfo = "����sign_begin�ӿ�ʧ��";
            break;
        case 70:
            errInfo = "������ļ���Ϊ��";
            break;
        case 71:
            errInfo = "base64����ʧ��";
            break;
        case 72:
            errInfo = "������ļ�̫���޷�ǩ��������֤��";
            break;
        case 73:
            errInfo = "δ����ǩ��������";
            break;
        case 74:
            errInfo = "δ����ǩ����֤����Ϣ";
            break;
        case 75:
            errInfo = "�����ʱ���ǩ��ֵΪ��";
            break;
        case 76:
            errInfo = "�����ʱ���ԭ��Ϊ��";
            break;
        case 77:
            errInfo = "��ʽ��ʱ���ʱ��ʧ��";
            break;
        case 78:
            errInfo = "��֤ʱ���ǩ��ʧ��";
            break;
        case 79:
            errInfo = "��ȡ�ļ�����ʧ��";
            break;
        case 80:
            errInfo = "��֤֤����Ч��ʧ��";
            break;
        case 81:
            errInfo = "��ȡʱ���ԭ��Ϊ��";
            break;
        case 82:
            errInfo = "��ͼ��������ŷ�������";
            break;
        case 83:
            errInfo = "��ͼ����и�ʽת����������";
            break;
        case 84:
            errInfo = "δ������չ��";
            break;
        case 85:
            errInfo = "��֧�ֵ���չ���ͺ�";
            break;
        case 86:
            errInfo = "����֤���еĹ�ϣֵʧ��";
            break;
        case 87:
            errInfo = "�Ƚ�֤���еĹ�ϣ����д�ʼ���ϣʧ��";
            break;
        case 88:
            errInfo = "����ǩ���Ի����Ȳ���ȷ";
            break;
        case 89:
            errInfo = "����ǩ����������ʧ��";
            break;
        case 90:
            errInfo = "��ȡ��Ƭʧ��";
            break;
        case 91:
            errInfo = "��ȡ��Ƶʧ��";
            break;
        case 92:
            errInfo = "������ͷʧ��";
            break;
        case 93:
            errInfo = "����ʧ��";
            break;
        case 94:
            errInfo = "��Ƭ�洢·������";
            break;
        case 95:
            errInfo = "¼���洢·������";
            break;
        case 96:
            errInfo = "¼��洢·������";
            break;
        case 97:
            errInfo = "����˷�ʧ��";
            break;
        case 98:
            errInfo = "δ�ҵ�������xvid";
            break;
        case 99:
            errInfo = "ǩ����δ��";
            break;
        case 100:
            errInfo = "ǩ�����Ѿ���";
            break;
        case 101:
            errInfo = "����ǩ����ʧ��";
            break;
        case 102:
            errInfo = "ǩ����������δ����";
            break;
        case 103:
            errInfo = "ǩ�������������";
            break;
        case 104:
            errInfo = "ǩ���屻�Ƴ�";
            break;
        case 105:
            errInfo = "ȱ��֤����Ϣ";
            break;
        case 1000:
            errInfo = "���ĵ�δǩ��";
            break;
        case 10051:
            errInfo = "û���ڷ�������ѯ��ǩ����Ϣ���������ɴ�ǩ�ĵ�";
            break;
        default:
            errInfo = "δ֪����" + errCode;
            break;
    }
    
    return errInfo;
}