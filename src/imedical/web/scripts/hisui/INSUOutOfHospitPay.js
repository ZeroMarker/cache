///ҽ��Ժ�ⱨ����
/// INSUOutOfHospitPay.js

var Guser=session['LOGON.USERID'];
var INSUTypeObj;
var INSUType="";

function BodyLoadHandler() {
    //��ʼ������
    //iniForm(); tangzf 2019-9-3 --
	
    //����
    var obj = document.getElementById("ClearPage");
    if (obj) { obj.onclick = ClearPage_onclick; }
	/*
	//��������
	var obj=document.getElementById("Zstr12")
	if (obj){obj.onchange=AdmType_onchange;}
	*/ // tangzf 2019-9-3
    //�������
    //var obj=document.getElementById("Zstr10")
    //if (obj){obj.onchange=PatType_onchange;}
	
    //�渶
    var obj = document.getElementById("SaveINSUPay");
    if (obj) { obj.onclick = SaveINSUPay_onclick; }
	
    //����
    var obj = document.getElementById("DivideStrike")
    if (obj) { obj.onclick = DivideStrike_onclick; }
	
    //�渶(�س��¼�)
    var obj = document.getElementById("jjzfe0")
    if (obj) {
        $("#jjzfe0").on('input', function (e) {
            Jjzfe0_onkeydown();
        });
    }
	
    //���ݺ�(�س��¼�)
    var obj = document.getElementById("djlsh0")
    if (obj) {
        obj.onkeydown = Djlsh0_onkeydown;
    }
	
    //ҽ������
	/*var obj=document.getElementById("Zstr04")
	if (obj){obj.onchange=TariType_onchange;}
	*/ // tangzf 2019-9-3 
    init_Layout();
}


//*******************************
//1:��ʼ������                    *
//*******************************
function iniForm(){
	//ҽ��ͳ����
	var VerStrArea="";
	var newDicType="YAB003"+INSUType;
	var VerStrArea=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
	//if ((VerStrArea=="")||(VerStrArea=="0")) {DHCWeb_HISUIalert("����ҽ���ֵ���ά�� [YAB003]ҽ��ͳ����");return;}
	if (VerStrArea=="") {DHCWeb_HISUIalert("����ҽ���ֵ���ά�� [YAB003]ҽ��ͳ����");return;}
	var Arr1Area=VerStrArea.split("!")
	//DHCWeb_HISUIalert(Arr1Area)
	obj=document.getElementById("Zstr13")
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  for (var j=1;j<Arr1Area.length;j++){
		  //DHCWeb_HISUIalert(Arr1Area[j])
		  obj.options[j]=new Option(Arr1Area[j].split("^")[3],Arr1Area[j].split("^")[2]);	
		}	  
	}
	
	//�Ա�
	objxbie00=document.getElementById("xbie00")
	if (objxbie00){
	  objxbie00.size=1; 
	  objxbie00.multiple=false;
	  objxbie00.options[1]=new Option("��","1");
	  objxbie00.options[2]=new Option("Ů","2");
	}
	
	//����/סԺ��ˮ��
	obj=document.getElementById("zylsh0")
	if (obj){
		var NowDate=new Date().toLocaleString()
		NowDate=NowDate.replace("��","")
		NowDate=NowDate.replace("��","")
		NowDate=NowDate.replace("��","")
		NowDate=NowDate.replace(":","")
		NowDate=NowDate.replace(":","")
		NowDate=NowDate.replace(" ","")
		//DHCWeb_HISUIalert(NowDate)
		var objAdmType=document.getElementById("xbie00")
		if (objAdmType.value!=""){
			//zylsh0=objAdmType.value+NowDate+Guser tangzf20190520
			//DHCWeb_HISUIalert(zylsh0)
			obj.value=zylsh0
		}else{
			obj.value=""
		}			
		
	}
}

//����ҽ������
function TariType_onchange(Data) {
    INSUTypeObj = document.getElementById("Zstr04")
    INSUType = INSUTypeObj.value;
	
    //�������
    objAdmType = document.getElementById("Zstr12")
	
    //ҽ�����
    var VerStr = "";
    var newDicType = "AKA130" + INSUType;
    VerStr = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", newDicType);
    if (VerStr == "") { DHCWeb_HISUIalert("����ҽ���ֵ���ά�� [AKA130" + INSUType + "]ҽ�����"); return; }
    var Arr1 = VerStr.split("!")
    obj = document.getElementById("sftsbz")
    if (obj) {
        obj.size = 1;
        obj.multiple = false;
        var j = 1
        for (var i = 1; i < Arr1.length; i++) {
            if (Arr1[i].split("^")[5] == objAdmType.value) {
                obj.options[j] = new Option(Arr1[i].split("^")[3], Arr1[i].split("^")[2]);
                if (Arr1[i].split("^")[4] == "Y") { obj.selectedIndex = j }      //ȡĬ��ֵ 
                j = j + 1;
            }
        }
    }
	
    //�������
    var VerStr = "";
    var newDicType = "AKC021" + INSUType;
    VerStr = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", newDicType);
    //if ((VerStr=="")||(VerStr=="0")) {DHCWeb_HISUIalert("����ҽ���ֵ���ά�� [AKC021]�������");return;}
    if (VerStr == "") { DHCWeb_HISUIalert("����ҽ���ֵ���ά�� [AKC021]�������"); return; }
    var Arr1 = VerStr.split("!")
    objZstr10 = document.getElementById("Zstr10")
    if (objZstr10) {
        objZstr10.size = 1;
        objZstr10.multiple = false;
        for (var i = 1; i < Arr1.length; i++) {
            objZstr10.options[i] = new Option(Arr1[i].split("^")[3], Arr1[i].split("^")[2]);
        }
    }
	
    //ҽ��ͳ����
    var VerStrArea = "";
    var newDicType = "YAB003" + INSUType;
    var VerStrArea = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", newDicType);
    //if ((VerStrArea=="")||(VerStrArea=="0")) {DHCWeb_HISUIalert("����ҽ���ֵ���ά�� [YAB300]ҽ��ͳ����");return;}
    if (VerStrArea == "") { DHCWeb_HISUIalert("����ҽ���ֵ���ά�� [YAB003]ҽ��ͳ����"); return; }
    var Arr1Area = VerStrArea.split("!")
    obj = document.getElementById("Zstr13")
    if (obj) {
        obj.size = 1;
        obj.multiple = false;
        for (var j = 1; j < Arr1Area.length; j++) {
            //DHCWeb_HISUIalert(Arr1Area[j])
            obj.options[j] = new Option(Arr1Area[j].split("^")[3], Arr1Area[j].split("^")[2]);
        }
    }
	
	
	
    AdmType_onchange();
	
	
}

//����渶��Ϣ
function SaveINSUPay_onclick() {
	
    //Ԥ���ֶ�1
    var obj = document.getElementById("AdmDr");
    if (obj) { var AdmDr = getValueById('AdmDr'); }
    else { var AdmDr = ""; }
	
    //Ԥ���ֶ�2
    var obj = document.getElementById("AdmInfoDr");
    if (obj) { var AdmInfoDr = getValueById('AdmInfoDr'); }
    else { var AdmInfoDr = ""; }
	
    //Ԥ���ֶ�3
    var obj = document.getElementById("DHCpblDr");
    if (obj) { var DHCpblDr = getValueById('DHCpblDr'); }
    else { var DHCpblDr = ""; }
	
    //Ԥ���ֶ�4
    var obj = document.getElementById("DhcInvPrtDr");
    if (obj) { var DhcInvPrtDr = getValueById('DhcInvPrtDr'); }
    else { var DhcInvPrtDr = ""; }
	
    //�����־
    var Flag = "I";
	
    //������Rowid
    var INSUDivideDr = "";
	
    //�ܷ���
    var obj = document.getElementById("bcbxf0");
    if (obj) {
        if (getValueById('bcbxf0') == "") {
            DHCWeb_HISUIalert("�ܷ��ò���Ϊ�գ�");
            return;
        }
        var bcbxf0 = getValueById('bcbxf0');
    }
	
    //���ݺ�
    var obj = document.getElementById("djlsh0");
    if (obj) {
        if (getValueById('bcbxf0') == "") {
            DHCWeb_HISUIalert("���ݺŲ���Ϊ�գ�");
            return;
        }
        var djlsh0 = getValueById('djlsh0');
    }
	
    //Ԥ���ֶ�5
    var obj = document.getElementById("bckbcs");
    if (obj) { var bckbcs = getValueById('bckbcs'); }
    else { var bckbcs = ""; }
	
    //Ԥ���ֶ�6
    var obj = document.getElementById("bqbm00");
    if (obj) { var bqbm00 = getValueById('bqbm00'); }
    else { var bqbm00 = ""; }
	
    //Ԥ���ֶ�7
    var obj = document.getElementById("brnl00");
    if (obj) { var brnl00 = getValueById('brnl00'); }
    else { var brnl00 = ""; }
	
    //Ԥ���ֶ�8
    var obj = document.getElementById("cardno");
    if (obj) { var cardno = getValueById('cardno'); }
    else { var cardno = ""; }
	
    //Ԥ���ֶ�9
    var obj = document.getElementById("cfxms0");
    if (obj) { var cfxms0 = getValueById('cfxms0'); }
    else { var cfxms0 = ""; }
	
    //Ԥ���ֶ�10
    var obj = document.getElementById("crbcts");
    if (obj) { var crbcts = getValueById('crbcts'); }
    else { var crbcts = ""; }
	
    //�����Ը�
    var obj = document.getElementById("grzfe0");
    if (obj) {
        if (getValueById('grzfe0') == "") {
            DHCWeb_HISUIalert("�����Ը�����Ϊ�գ�");
            return;
        }
        var grzfe0 = getValueById('grzfe0');
    }
	
    //Ԥ���ֶ�11
    var obj = document.getElementById("iDate");
    if (obj) { var iDate = getValueById('iDate'); }
    else { var iDate = ""; }
	
    //Ԥ���ֶ�12
    var obj = document.getElementById("iTime");
    if (obj) { var iTime = getValueById('iTime'); }
    else { var iTime = ""; }
	
    //���֤��
    var obj = document.getElementById("id0000");
    if (obj) {
        if (getValueById('id0000') == "") {
            DHCWeb_HISUIalert("���֤�Ų���Ϊ�գ�");
            return;
        }
        var id0000 = getValueById('id0000');
    }
	
    //�渶���
    var obj = document.getElementById("jjzfe0");
    if (obj) {
        if (getValueById('jjzfe0') == "") {
            DHCWeb_HISUIalert("�渶����Ϊ�գ�");
            return;
        }
        var jjzfe0 = getValueById('jjzfe0');
    }
	
    //Ԥ���ֶ�13
    var obj = document.getElementById("ptbcts");
    if (obj) { var ptbcts = obj.value; }
    else { var ptbcts = ""; }
	
    //Ԥ���ֶ�14
    var obj = document.getElementById("sfrq00");
    if (obj) { var sfrq00 = obj.value; }
    else { var sfrq00 = ""; }
	
    //����Ա
    var sUserDr = Guser;
	
    //Ԥ���ֶ�15
    var obj = document.getElementById("sfrxm0");
    if (obj) { var sfrxm0 = obj.value; }
    else { var sfrxm0 = ""; }
	
    //Ԥ���ֶ�16
    var obj = document.getElementById("sfsj00");
    if (obj) { var sfsj00 = obj.value; }
    else { var sfsj00 = ""; }
	
    //ҽ�����
    var obj = document.getElementById("sftsbz");
    if (obj) {
        if (getValueById('sftsbz') == "") {
            DHCWeb_HISUIalert("ҽ�������Ϊ�գ�");
            return;
        }
        var sftsbz = getValueById('sftsbz');
    }
	
    //�Ա�
    var obj = document.getElementById("xbie00");
    if (obj) {
        if (getValueById('xbie00') == "") {
            DHCWeb_HISUIalert("�Ա���Ϊ�գ�");
            return;
        }
        var xbie00 = getValueById('xbie00')
    }
	
    //����
    var obj = document.getElementById("xming0");
    if (obj) {
        obj.value = obj.value.replace('^', '');
        if (getValueById('xming0') == "") {
            DHCWeb_HISUIalert("��������Ϊ�գ�");
            return;
        }
        var xming0 = getValueById('xming0');
    }
	
    //Ԥ���ֶ�17
    var obj = document.getElementById("zhzfe0");
    if (obj) { var zhzfe0 = getValueById('zhzfe0'); }
    else { var zhzfe0 = "0.00"; }
	
    //Ԥ���ֶ�18
    var obj = document.getElementById("zyksmc");
    if (obj) { var zyksmc = obj.value; }
    else { var zyksmc = ""; }
	
    //����/סԺ��ˮ��
    var obj = document.getElementById("zylsh0");
    if (obj) {
        if (getValueById('zylsh0') == "") {
            DHCWeb_HISUIalert("����/סԺ��ˮ�Ų���Ϊ�գ�");
            return;
        }
        var zylsh0 = getValueById('zylsh0');
    }
	
    //Ԥ���ֶ�19
    var obj = document.getElementById("InsuPay1");
    if (obj) { var InsuPay1 = obj.value; }
    else { var InsuPay1 = "0.00"; }
	
    //Ԥ���ֶ�20
    var obj = document.getElementById("InsuPay2");
    if (obj) { var InsuPay2 = obj.value; }
    else { var InsuPay2 = "0.00"; }
	
    //Ԥ���ֶ�21
    var obj = document.getElementById("InsuPay3");
    if (obj) { var InsuPay3 = obj.value; }
    else { var InsuPay3 = "0.00"; }
	
    //Ԥ���ֶ�22
    var obj = document.getElementById("InsuPay4");
    if (obj) { var InsuPay4 = obj.value; }
    else { var InsuPay4 = "0.00"; }
	
    //Ԥ���ֶ�23
    var obj = document.getElementById("InsuPay5");
    if (obj) { var InsuPay5 = obj.value; }
    else { var InsuPay5 = ""; }
	
    //Ժ�ⱨ����־W
    var Zstr01 = "W";
	
    //��;�����־F�����ս��㣩
    var Zstr02 = "F";
	
    //Ԥ���ֶ�24
    var obj = document.getElementById("Zstr03");
    if (obj) { var Zstr03 = obj.value; }
    else { var Zstr03 = ""; }
	
    //ҽ������
    var obj = document.getElementById("Zstr04");
    if (obj) {
        if (getValueById('Zstr04') == "") {
            DHCWeb_HISUIalert("ҽ�����Ͳ���Ϊ�գ�");
            return;
        }
        var Zstr04 = getValueById('Zstr04');
    }
	
    //Ԥ���ֶ�25
    var obj = document.getElementById("Zstr05");
    if (obj) { var Zstr05 = obj.value; }
    else { var Zstr05 = ""; }
	
    //Ԥ���ֶ�26
    var obj = document.getElementById("Zstr06");
    if (obj) { var Zstr06 = obj.value; }
    else { var Zstr06 = ""; }
	
    //Ԥ���ֶ�27
    var obj = document.getElementById("Zstr07");
    if (obj) { var Zstr07 = obj.value; }
    else { var Zstr07 = ""; }
	
    //Ԥ���ֶ�28
    var obj = document.getElementById("Zstr08");
    if (obj) { var Zstr08 = obj.value; }
    else { var Zstr08 = ""; }
	
    //Ԥ���ֶ�29
    var obj = document.getElementById("Zstr09");
    if (obj) { var Zstr09 = obj.value; }
    else { var Zstr09 = ""; }
	
    //�������
    var obj = document.getElementById("Zstr10");
    if (obj) {
        if (getValueById('Zstr10') == "") {
            DHCWeb_HISUIalert("���������Ϊ�գ�");
            return;
        }
        var Zstr10 = getValueById('Zstr10');
    }
	
    //Ԥ���ֶ�30
    var obj = document.getElementById("InsuPay6");
    if (obj) { var InsuPay6 = obj.value; }
    else { var InsuPay6 = "0.00"; }
	
    //Ԥ���ֶ�31
    var obj = document.getElementById("InsuPay7");
    if (obj) { var InsuPay7 = obj.value; }
    else { var InsuPay7 = "0.00"; }
	
    //Ԥ���ֶ�32
    var obj = document.getElementById("InsuPay8");
    if (obj) { var InsuPay8 = obj.value; }
    else { var InsuPay8 = "0.00"; }
	
    //Ԥ���ֶ�33
    var obj = document.getElementById("InsuPay9");
    if (obj) { var InsuPay9 = obj.value; }
    else { var InsuPay9 = "0.00"; }
	
    //Ԥ���ֶ�34
    var obj = document.getElementById("InsuPay10");
    if (obj) { var InsuPay10 = obj.value; }
    else { var InsuPay10 = "0.00"; }
	
    //Ԥ���ֶ�35
    var obj = document.getElementById("Zstr11");
    if (obj) { var Zstr11 = obj.value; }
    else { var Zstr11 = ""; }
	
    //��������
    var obj = document.getElementById("Zstr12");
    if (obj) {
        if (getValueById('Zstr12') == "") {
            DHCWeb_HISUIalert("�������Ͳ���Ϊ�գ�");
            return;
        }
        var Zstr12 = getValueById('Zstr12');
    }
	
    //����
    var obj = document.getElementById("Zstr13");
    if (obj) {
        if (getValueById('Zstr13') == "") {
            DHCWeb_HISUIalert("��������Ϊ�գ�");
            return;
        }
        var Zstr13 = getValueById('Zstr13');
    }
	
    //Ԥ���ֶ�36
    var obj = document.getElementById("Zstr14");
    if (obj) { var Zstr14 = obj.value; }
    else { var Zstr14 = ""; }
	
    //Ԥ���ֶ�37
    var obj = document.getElementById("Zstr15");
    if (obj) { var Zstr15 = obj.value; }
    else { var Zstr15 = ""; }
	
    //ת��ҽԺ
    var obj = document.getElementById("Zstr16");
    if (obj) {
        var Zstr16 = obj.value;
    }
	
    //Ԥ���ֶ�38
    var obj = document.getElementById("Zstr17");
    if (obj) { var Zstr17 = obj.value; }
    else { var Zstr17 = ""; }
	
    //Ԥ���ֶ�39
    var obj = document.getElementById("Zstr18");
    if (obj) { var Zstr18 = obj.value; }
    else { var Zstr18 = ""; }
	
    //Ԥ���ֶ�40
    var obj = document.getElementById("Zstr19");
    if (obj) { var Zstr19 = obj.value; }
    else { var Zstr19 = ""; }
	
    //Ԥ���ֶ�41
    var obj = document.getElementById("Zstr20");
    if (obj) { var Zstr20 = obj.value; }
    else { var Zstr20 = ""; }
	
    //Ԥ���ֶ�42
    var obj = document.getElementById("Zstr21");
    if (obj) { var Zstr21 = obj.value; }
    else { var Zstr21 = ""; }
	
    //Ԥ���ֶ�43
    var obj = document.getElementById("Zstr22");
    if (obj) { var Zstr22 = obj.value; }
    else { var Zstr22 = ""; }
	
    //Ԥ���ֶ�44
    var obj = document.getElementById("Zstr23");
    if (obj) { var Zstr23 = obj.value; }
    else { var Zstr23 = ""; }
	
    //��ע
    var obj = document.getElementById("Zstr24");
    if (obj) { var Zstr24 = obj.value; }
    else { var Zstr24 = ""; }
	
    //Ԥ���ֶ�45
    var obj = document.getElementById("Zstr25");
    if (obj) { var Zstr25 = obj.value; }
    else { var Zstr25 = ""; }
	
    //Ԥ���ֶ�46
    var obj = document.getElementById("Zstr26");
    if (obj) { var Zstr26 = obj.value; }
    else { var Zstr26 = ""; }
	
    //Ԥ���ֶ�47
    var obj = document.getElementById("Zstr27");
    if (obj) { var Zstr27 = obj.value; }
    else { var Zstr27 = ""; }
	
    //Ԥ���ֶ�48
    var obj = document.getElementById("Zstr28");
    if (obj) { var Zstr28 = obj.value; }
    else { var Zstr28 = ""; }
	
    //Ԥ���ֶ�49
    var obj = document.getElementById("Zstr29");
    if (obj) { var Zstr29 = obj.value; }
    else { var Zstr29 = ""; }
	
    //Ԥ���ֶ�50
    var obj = document.getElementById("Zstr30");
    if (obj) { var Zstr30 = obj.value; }
    else { var Zstr30 = ""; }
	
    //Ԥ���ֶ�51
    var obj = document.getElementById("Zstr31");
    if (obj) { var Zstr31 = obj.value; }
    else { var Zstr31 = ""; }
	
    if (bcbxf0 != (jjzfe0 * 1 + grzfe0 * 1)) {
        DHCWeb_HISUIalert("�ܷ��ò����ڵ渶���+�����Ը�����¼����ȷ�Ľ�");
    } else {
        //Divide���rowid(����ʱ����,����ʱ�ش�)^Ԥ��1^Ԥ��2^Ԥ��3^Ԥ��4^����״̬(����:I,������:B,����:S)^������rowid^�ܷ���^���ݺ�^Ԥ��5^Ԥ��6^Ԥ��7^Ԥ��8^Ԥ��9^Ԥ��10^�����Ը�^Ԥ��11^Ԥ��12^���֤��^�渶���^Ԥ��13^�û�ID^Ԥ��14^Ԥ��15^Ԥ��16^ҽ�����^�Ա�^����^Ԥ��17^Ԥ��18^����/סԺ��ˮ��^Ԥ��19^Ԥ��20^Ԥ��21^Ԥ��22^Ԥ��23^Ժ�ⱨ����־^��;�����־^Ԥ��24^ҽ������^Ԥ��25^Ԥ��26^Ԥ��27^Ԥ��28^Ԥ��29^�������^Ԥ��30^Ԥ��31^Ԥ��32^Ԥ��33^Ԥ��34^Ԥ��35^��������^����^Ԥ��36^Ԥ��37^ת��ҽԺ^Ԥ��38^Ԥ��39^Ԥ��40^Ԥ��41^Ԥ��42^Ԥ��43^Ԥ��44^��ע^Ԥ��45^Ԥ��46^Ԥ��47^Ԥ��48^Ԥ��49^Ԥ��50^Ԥ��51
        var InStr = "" + "^" + AdmDr + "^" + AdmInfoDr + "^" + DHCpblDr + "^" + DhcInvPrtDr + "^" + Flag + "^" + INSUDivideDr + "^" + bcbxf0 + "^" + djlsh0 + "^" + bckbcs + "^" + bqbm00 + "^" + brnl00 + "^" + cardno + "^" + cfxms0 + "^" + crbcts + "^" + grzfe0 + "^" + iDate + "^" + iTime + "^" + id0000 + "^" + jjzfe0 + "^" + ptbcts + "^" + sUserDr + "^" + sfrq00 + "^" + sfrxm0 + "^" + sfsj00 + "^" + sftsbz + "^" + xbie00 + "^" + xming0 + "^" + zhzfe0 + "^" + zyksmc + "^" + zylsh0 + "^" + InsuPay1 + "^" + InsuPay2 + "^" + InsuPay3 + "^" + InsuPay4 + "^" + InsuPay5 + "^" + Zstr01 + "^" + Zstr02 + "^" + Zstr03 + "^" + Zstr04 + "^" + Zstr05 + "^" + Zstr06 + "^" + Zstr07 + "^" + Zstr08 + "^" + Zstr09 + "^" + Zstr10 + "^" + InsuPay6 + "^" + InsuPay7 + "^" + InsuPay8 + "^" + InsuPay9 + "^" + InsuPay10 + "^" + Zstr11 + "^" + Zstr12 + "^" + Zstr13 + "^" + Zstr14 + "^" + Zstr15 + "^" + Zstr16 + "^" + Zstr17 + "^" + Zstr18 + "^" + Zstr19 + "^" + Zstr20 + "^" + Zstr21 + "^" + Zstr22 + "^" + Zstr23 + "^" + Zstr24 + "^" + Zstr25 + "^" + Zstr26 + "^" + Zstr27 + "^" + Zstr28 + "^" + Zstr29 + "^" + Zstr30 + "^" + Zstr31;
        //DHCWeb_HISUIalert(InStr)
        var Ins = document.getElementById('SaveIDivideInfo');
        if (Ins) { var encmeth = Ins.value } else { var encmeth = '' };
        var OutStr = cspRunServerMethod(encmeth, InStr);
        if (OutStr > 0) {
            $.messager.alert('��ʾ', '�渶�ɹ�', 'info', function () {
                $('#Find').click();
		 			
            })
        } else {
            if (OutStr == -4) { DHCWeb_HISUIalert("�渶ʧ�ܣ�ϵͳ���Ѿ����ڴ�ҽ��ϵͳ�����:" + djlsh0 + ",���֤����¼�룡"); }
        }
    }
}

//����
function ClearPage_onclick() {
	/*
	//���֤��
	var obj=document.getElementById("id0000");
	if (obj){ obj.value="";}
	//����
	var obj=document.getElementById("xming0");
	if (obj){ obj.value="";}
	//�ܷ���
	var obj=document.getElementById("bcbxf0");
	if (obj){ obj.value="";}
	//�渶���
	var obj=document.getElementById("jjzfe0");
	if (obj){ obj.value="";}
	//�����Ը�
	var obj=document.getElementById("grzfe0");
	if (obj){ obj.value="";}
	//ת��ҽԺ
	var obj=document.getElementById("Zstr16");
	if (obj){ obj.value="";}
	//����/סԺ��ˮ��
	var obj=document.getElementById("zylsh0");
	if (obj){ obj.value="";}
	//���ݺ�
	var obj=document.getElementById("djlsh0");
	if (obj){ obj.value="";}
	//��ע
	var obj=document.getElementById("Zstr24");
	if (obj){ obj.value="";}
	//��ʼ����
	var obj=document.getElementById("StartDate");
	if (obj){ obj.value="";}
	//��������
	var obj=document.getElementById("EndDate");
	if (obj){ obj.value="";}*/
    //Find_click();
    location.reload();
	
}
function AdmType_onchange() {
    var objAdmType = document.getElementById("Zstr12");
    var newDicType = "AKA130" + INSUType;
    var VerStr = "";
    VerStr = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", newDicType);
    if (VerStr == "") { DHCWeb_HISUIalert("����ҽ���ֵ���ά�� [AKA130]ҽ�����"); return; }
    var Arr1 = VerStr.split("!")
    obj = document.getElementById("sftsbz")
    if (obj) {
        obj.options.length = 0
        obj.size = 1;
        obj.multiple = false;
        var j = 1
        for (var i = 1; i < Arr1.length; i++) {
            if ((Arr1[i].split("^")[8] == objAdmType.value) || ((Arr1[i].split("^")[8] == "") && (objAdmType.value == "OP"))) {
                obj.options[j] = new Option(Arr1[i].split("^")[3], Arr1[i].split("^")[2]);
                if (Arr1[i].split("^")[4] == "Y") { obj.selectedIndex = j }      //ȡĬ��ֵ
                j = j + 1;
            }
        }
    }
	
    //����/סԺ��ˮ��
    obj = document.getElementById("zylsh0")
    if (obj) {
        var NowDate = new Date().toLocaleString()
        NowDate = NowDate.replace("��", "")
        NowDate = NowDate.replace("��", "")
        NowDate = NowDate.replace("��", "")
        NowDate = NowDate.replace(":", "")
        NowDate = NowDate.replace(":", "")
        NowDate = NowDate.replace(" ", "")
        //DHCWeb_HISUIalert(NowDate)
        if (objAdmType.value != "") {
            zylsh0 = objAdmType.value + NowDate + Guser
            //DHCWeb_HISUIalert(zylsh0)
            obj.value = zylsh0
        } else {
            obj.value = ""
        }
		
    }
}

function PatType_onchange() {
    var objAdmType = document.getElementById("Zstr12")
    var objZstr10 = document.getElementById("Zstr10")
    if (objZstr10.value == "") {
        var objsftsbz = document.getElementById("sftsbz")
        DHCC_ClearList("sftsbz");
        if (objsftsbz) {
            objsftsbz.size = 1;
            objsftsbz.multiple = false;
            objsftsbz.options[0] = new Option("", "");
        }
    } else {
        var DicType = objAdmType.value + objZstr10.value;
        var VerStr = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", DicType);
        if ((VerStr == "") || (VerStr == "0")) { DHCWeb_HISUIalert("����ҽ���ֵ���ά�� ҽ�����"); return; }
        var Arr1 = VerStr.split("!")
        var objsftsbz = document.getElementById("sftsbz")
        DHCC_ClearList("sftsbz");
        if (objsftsbz) {
            objsftsbz.size = 1;
            objsftsbz.multiple = false;
            for (var k = 1; k < Arr1.length; k++) {
                objsftsbz.options[k] = new Option(Arr1[k].split("^")[3], Arr1[k].split("^")[2]);
            }
        }
    }
}

function SelectRowHandler(index, RowData) {
    if (index > -1) {
        //DHCWeb_HISUIalert("��ѡ����ǵ�"+selectedRowObj.rowIndex+"��");
		
        //��ȡѡ��ĵ�ǰ�е�TRowID���ı�ֵ
        //var obj=document.getElementById("TRowIDz"+selectedRowObj.rowIndex);
        var TRowID = RowData.TRowID;
        //DHCWeb_HISUIalert(TRowID)
        //��ȡѡ��ĵ�ǰ�е�Tdjlsh0���ı�ֵ
        //var objTdjlsh0=document.getElementById("Tdjlsh0z"+selectedRowObj.rowIndex);
        var Tdjlsh0 = RowData.Tdjlsh0; //objTdjlsh0.innerText;
        //DHCWeb_HISUIalert(Tdjlsh0)
        //��ȡѡ��ĵ�ǰ�е�TFlag���ı�ֵ
        //var objTFlag=document.getElementById("TFlagz"+selectedRowObj.rowIndex);
        var FlagHidden = RowData.TFlag;
        //DHCWeb_HISUIalert(FlagHidden)
        //��ֵ���ر���RowID
        //var objRowID=document.getElementById("RowID");
        //objRowID.value=TRowID;
        setValueById('RowID', TRowID);
        //��ֵ���ر���INSUDjlshHidden
        //var objINSUDjlshHidden=document.getElementById("INSUDjlshHidden");
        //objINSUDjlshHidden.value=Tdjlsh0;
        setValueById('INSUDjlshHidden', Tdjlsh0);
        //��ֵ���ر���FlagHidden
        //var objFlagHidden=document.getElementById("FlagHidden");
        //objFlagHidden.value=FlagHidden;
        setValueById('FlagHidden', FlagHidden);
		
        //��ȡѡ��ĵ�ǰ�е��ı�ֵ�����渳ֵ
		/* tangzf 2019-9-3
		
		document.getElementById("djlsh0").value=document.getElementById("Tdjlsh0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("zylsh0").value=document.getElementById("Tzylsh0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("xming0").value=document.getElementById("Txming0z"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("xbie00").value=document.getElementById("Txbie00z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("id0000").value=document.getElementById("Tid0000z"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("Zstr13").value=document.getElementById("TZstr13z"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("Zstr12").value=document.getElementById("TZstr12z"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("sftsbz").value=document.getElementById("Tsftsbzz"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("Zstr10").value=document.getElementById("TZstr10z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("Zstr16").value=document.getElementById("TZstr16z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("bcbxf0").value=document.getElementById("Tbcbxf0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("jjzfe0").value=document.getElementById("Tjjzfe0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("grzfe0").value=document.getElementById("Tgrzfe0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("Zstr24").value=document.getElementById("TZstr24z"+selectedRowObj.rowIndex).innerText;
		*/
        setValueById('Zstr04', RowData.TZstr04);
        setValueById('djlsh0', RowData.Tdjlsh0);
        setValueById('zylsh0', RowData.Tzylsh0);
        setValueById('xming0', RowData.Txming0);
        setValueById('xbie00', RowData.Tbie00);
        setValueById('id0000', RowData.Tid0000);
        setValueById('Zstr13', RowData.TZstr13);
        setValueById('Zstr12', RowData.TZstr12);
        setValueById('sftsbz', RowData.Tsftsbz);
        setValueById('Zstr10', RowData.TZstr10);
        setValueById('Zstr16', RowData.TZstr16);
        setValueById('bcbxf0', RowData.Tbcbxf0);
        setValueById('jjzfe0', RowData.Tjjzfe0);
        setValueById('grzfe0', RowData.Tgrzfe0);
        setValueById('Zstr24', RowData.TZstr24);
		
    } else {
        //��ֵ���ر���RowID
        //var objRowID=document.getElementById("RowID");
        //objRowID.value="";
        setValueById('RowID', '');
        //��ֵ���ر���INSUDjlshHidden
        //var objINSUDjlshHidden=document.getElementById("INSUDjlshHidden");
        //objINSUDjlshHidden.value="";
        setValueById('INSUDjlshHidden', '');
        //��ֵ���ر���FlagHidden
        //var objFlagHidden=document.getElementById("FlagHidden");
        //objFlagHidden.value="";
        setValueById('FlagHidden', '');
    }
}

//����
function DivideStrike_onclick() {
    //�����ر�������ȡ��ֵ����TRowID
    var objRowID = document.getElementById("RowID");
    var TRowID = getValueById('RowID');
    //�����ر�������ȡ��ֵ����INSUDjlshHidden
    var objINSUDjlshHidden = document.getElementById("INSUDjlshHidden");
    var Tdjlsh0 = getValueById('INSUDjlshHidden');
    //�����ر�������ȡ��ֵ����TFlagHidden
    var objFlagHidden = document.getElementById("FlagHidden");
    var TFlagHidden = getValueById('FlagHidden');
	
    if ((TRowID == "") || (Tdjlsh0 == "") || (TFlagHidden == "")) { DHCWeb_HISUIalert("��ѡ��Ҫ���ϵļ�¼��"); return; }
	
    if (TFlagHidden != "��������") {
        DHCWeb_HISUIalert("�����������ѳ����ķ��ã�������ѡ��");
        return;
    }

    //�û�ID^���ݺ�^Divide���rowid(����ʱ�ش�)^����״̬(����:I,������:B,����:S)
    var InStr = Guser + "^" + Tdjlsh0 + "^" + TRowID + "^S"
    //DHCWeb_HISUIalert(InStr)
    var Ins = document.getElementById('StrikeDivideInfo');
    if (Ins) { var encmeth = Ins.value } else { var encmeth = '' };
    var OutStr = cspRunServerMethod(encmeth, InStr);
    if (OutStr > 0) {
        $.messager.alert('��ʾ', '���ϳɹ���', 'info', function () {
            $('#Find').click();
        })
    } else {
        if (OutStr == -5) { DHCWeb_HISUIalert("����ʧ�ܣ�ϵͳ�б����ҽ��ϵͳ�������ҳ����ʾ�Ľ���Ų�ͬ������ʧ�ܣ�"); }
    }
}

function Jjzfe0_onkeydown() {
    var obj = document.getElementById("bcbxf0");
    var Total = obj.value;
    if (Total == "") {
        DHCWeb_HISUIalert("���������ܽ�");
        setValueById("bcbxf0", '');

    }
    if (isNaN(Total)) {
        DHCWeb_HISUIalert("��������ȷ���ܽ�");
        setValueById("bcbxf0", '');
    } else {
        if (Total * 1 < 0) {
            DHCWeb_HISUIalert("�ܽ���С��0��");
            setValueById("bcbxf0", '');
        } else {
            obj = document.getElementById("jjzfe0");
            var jjzfe0 = obj.value;
            if (jjzfe0 == "") {
                DHCWeb_HISUIalert("��������渶��");
                setValueById("jjzfe0", '');
            }
            if (isNaN(jjzfe0)) {
                DHCWeb_HISUIalert("��������ȷ�ĵ渶��");
                setValueById("jjzfe0", '');
                setValueById("grzfe0", '');
            } else {
                if (jjzfe0 * 1 < 0) {
                    DHCWeb_HISUIalert("�渶����С��0��");
                    setValueById("grzfe0", '');
                    setValueById("jjzfe0", '');
                } else {
                    if (Total * 1 < jjzfe0 * 1) {
                        DHCWeb_HISUIalert("�ܽ���С�ڵ渶��");
                        setValueById("grzfe0", '');
                        setValueById("jjzfe0", '');
                    }
                    else {
                        obj = document.getElementById("grzfe0");
                        obj.value = (Total * 1 - jjzfe0 * 1);//.toFixed(2);
                    }
                }

            }

        }
    }
}

function Djlsh0_onkeydown() {
    if (window.event.keyCode == 13) {
        $('#Find').click();
    }
}
function init_Layout() {
    $('td.i-tableborder>table').css("border-spacing", "0px 8px"); // �м��
    $('#cStartDate').css('margin-left', '4px'); // ��߿����
    init_INSUType(); //ҽ������
    init_AdmType(); // ��������
    init_Sex(); // �Ա�
    setValueById('StartDate', getDefStDate(0)); // ��ʼ����
    setValueById('EndDate', getDefStDate(0)); // ��������	
	
    $('#tINSUOutOfHospitPay').datagrid({
        frozenColumns: [[
            {
                field: 'Txming0',
                title: '����',
            }, {
                field: 'Tzylsh0',
                title: '��ˮ��',
            },
        ]],
        onLoadSuccess: function (data) {
            $('.datagrid-sort-icon').text(''); // ����� ���ֺͽ���Ҷ���
            $('.datagrid-view2').find('td[field=Tzylsh0]').hide();
            $('.datagrid-view2').find('td[field=Txming0]').hide();
        }
    });
    $('#grzfe0').attr('readonly', true);
    $('#bcbxf0').css('color', 'red');
    $('#jjzfe0').css('color', 'red');
    $('#grzfe0').css('color', 'red');	
}
function init_INSUType() {
    //ҽ������
	
    $("#Zstr04").combobox({
        valueField: 'cCode',
        textField: 'cDesc',
        url: $URL,
        fit: true,
        loadFilter: function (data) {
            data.splice(data.length - 1, 1) // ��query���ص� ȫ�� ȥ��
            return data;
        },
        onBeforeLoad: function (param) {
            param.ResultSetType = 'Array';
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic';
            param.Type = 'DLLType';
            param.Code = '';
        },
        onSelect: function (Data) {
            //TariType_onchange(Data);
            init_YLLB(); //ҽ�����
            init_DYLB(); // �������
            init_States(); // ͳ����
        },
        onLoadSuccess: function (data) {
            if (data.length == 0) {
                DHCWeb_HISUIDHCWeb_HISUIalert("����ҽ���ֵ���ά�� [DLLType]");
            }
        }		
    })
}
// ҽ�����
function init_YLLB() {
    $("#sftsbz").combobox({
        valueField: 'cCode',
        textField: 'cDesc',
        url: $URL,
        fit: true,
        loadFilter: function (data) {
            data.splice(data.length - 1, 1) // ��query���ص� ȫ�� ȥ��
            return data;
        },
        onBeforeLoad: function (param) {
            param.ResultSetType = 'Array';
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic';
            param.Type = 'AKA130' + getValueById('Zstr04');
            param.Code = '';
        },
        onSelect: function (Data) {
        },
        onLoadError: function (e) {
        },
        onLoadSuccess: function (data) {
            if (data.length == 0) {
                DHCWeb_HISUIDHCWeb_HISUIalert("����ҽ���ֵ���ά�� [AKA130" + getValueById('Zstr04') + "]ҽ�����");
            }
        }
    })
	
}
// �������
function init_AdmType() {
    $HUI.combobox("#Zstr12", {
        valueField: 'id',
        textField: 'text',
        data: [{
            "id": 'OP',
            "text": "����",
        }, {
            "id": 'IP',
            "text": "סԺ"
        }],
        onSelect: function (Data) {
            var rtn = tkMakeServerCall('web.INSUOutOfHospitalCtl', 'Buildzylsh0ByDateUser', Data.id, Guser);
            setValueById('zylsh0', rtn);
        },
    })
}
// �Ա�
function init_Sex() {
    $HUI.combobox("#xbie00", {
        valueField: 'id',
        textField: 'text',
        data: [{
            "id": '1',
            "text": "��",
            selected: true
        }, {
            "id": '2',
            "text": "Ů"
        }],
    })	
}
function init_DYLB() {
    //�������
    $("#Zstr10").combobox({
        valueField: 'cCode',
        textField: 'cDesc',
        url: $URL,
        fit: true,
        loadFilter: function (data) {
            data.splice(data.length - 1, 1) // ��query���ص� ȫ�� ȥ��
            return data;
        },
        onBeforeLoad: function (param) {
            param.ResultSetType = 'Array';
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic';
            param.Type = 'AKC021' + getValueById('Zstr04');
            param.Code = '';
        },
        onSelect: function (Data) {
        },
        onLoadError: function (e) {
        },
        onLoadSuccess: function (data) {
            if (data.length == 0) {
                DHCWeb_HISUIDHCWeb_HISUIalert("����ҽ���ֵ���ά�� [AKC021" + getValueById('Zstr04') + "]�������");
            }
        }
    })
}
function init_States() {
    // ͳ����
    $("#Zstr13").combobox({
        valueField: 'cCode',
        textField: 'cDesc',
        url: $URL,
        fit: true,
        loadFilter: function (data) {
            data.splice(data.length - 1, 1) // ��query���ص� ȫ�� ȥ��
            return data;
        },
        onBeforeLoad: function (param) {
            param.ResultSetType = 'Array';
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic';
            param.Type = 'YAB003' + getValueById('Zstr04');
            param.Code = '';
        },
        onSelect: function (Data) {
        },
        onLoadError: function (e) {
        },
        onLoadSuccess: function (data) {
            if (data.length == 0) {
                DHCWeb_HISUIDHCWeb_HISUIalert("����ҽ���ֵ���ά�� [YAB003" + getValueById('Zstr04') + "]�������");
            }
        }
    })
}
document.body.onload = BodyLoadHandler;