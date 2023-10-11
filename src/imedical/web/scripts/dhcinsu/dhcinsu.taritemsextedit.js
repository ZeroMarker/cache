/*
* FileName:	dhcinsu.taritemsextedit.js
* User:		DingSH 
* Date:		2023-02-17	
* Description: ҽ��Ŀ¼��չ��Ϣά������
*/
var GV = {
      UserId:session['LOGON.USERID'],
      HospId:"",
      HiType:"",
      InsuCode:"",
      InsuDesc:""
}
$.extend($.fn.validatebox.defaults.rules, {
	checkSelfPayProp: {    
	    validator: function(value) {
		    return (value >=0)&&(value<=1);
		},
		message: "�Ը�����ֻ��>=0��<=1"
	}
});
$(function(){
	setPageLayout();    //����ҳ�沼��
	setElementEvent();  //����Ԫ���¼�
	
});
//����ҳ�沼��
function setPageLayout(){
   var flag =  InitGV();
   if (flag){
     InitHiTypeCmb();
     GetTaritemsExt();
   }
    
}
//��ʼ��ȫ�ֱ���
function InitGV() {
    var Rq = INSUGetRequest();
    if(Rq){
        GV.HospId = Rq["HospId"];
        GV.HiType = Rq["HiType"];
        GV.InsuCode = Rq["InsuCode"];
        GV.InsuDesc = Rq["InsuDesc"];
         return true ;
    }
	return false;
}
//����Ԫ���¼�
function setElementEvent(){
    $("#btnU").click(function () {	
		SaveTaritemsExt();		
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
}

//���ݱ���Ȼ�ȡҽ��Ŀ¼��չ��Ϣ 
function GetTaritemsExt(){
	$m({
		ClassName:"INSU.MI.BL.TarItemsExt",
		MethodName:"GetTarItemsExtByInsuCode",
		InsuCode:GV.InsuCode,
		InsuDesc:"",
		HospId:GV.HospId,
		HiType:GV.HiType,
		HiGrp:"",
		MedType:""
	},function(txtData){
		InitTaritemsExt(txtData);
	});
}
//��ʼ������Ԫ������
function InitTaritemsExt(InData)
{
  //alert("InData"+InData)
  if (InData == ""){
	setValueById("ExtRowid","");
	setValueById("InsuCode",GV.InsuCode);
	setValueById("InsuDesc",GV.InsuDesc);
	setValueById("HiType",GV.HiType);
	return true;
  }
  var InDataArr =  InData.split("^")
   // 01-05��Rowid SPT ҽ��Ŀ¼���� SPT ҽ��Ŀ¼���� SPT ҽ������ SPT �����־ SPT
   setValueById("ExtRowid",InDataArr[0]);
   setValueById("InsuCode",InDataArr[1]);
   setValueById("InsuDesc",InDataArr[2]);
   setValueById("HiType",InDataArr[3]);
   setValueById("SpFlag",InDataArr[4]);
  // 06-10���������� SPT ҽ����Ⱥ SPT �Ը����� SPT ҽ����� SPT ��������˵�� SPT
   setValueById("XzType",InDataArr[5]);
   setValueById("HiGrp",InDataArr[6]);
   setValueById("SelfPayProp",InDataArr[7]);
   setValueById("MedType",InDataArr[8]);
   setValueById("LmtCondDscr",InDataArr[9]);
  // 11-15���������� SPT ��Ч���� SPT ��Ч��־ SPT ������ SPT �������� SPT 
   setValueById("BegnDate",InDataArr[10]);
   setValueById("EndDate",InDataArr[11]);
   setValueById("ValidFlag",InDataArr[12]);
   setValueById("CrterId",InDataArr[13]);
   setValueById("CrteDate",InDataArr[14]);
  //16-20������ʱ�� SPT ������ SPT �������� SPT ����ʱ�� SPT ҽԺID SPT ���������� SPT����������
   setValueById("CrteTime",InDataArr[15]);
   setValueById("UpdtId",InDataArr[16]);
   setValueById("UpdtDate",InDataArr[17]);
   setValueById("UpdtTime",InDataArr[18]);
   setValueById("HospId",InDataArr[19]);
   setValueById("CrterName",InDataArr[20]);
   setValueById("UpdterName",InDataArr[21]);
   return true ;
}
//���ݱ���Ȼ�ȡҽ��Ŀ¼��չ��Ϣ 
function SaveTaritemsExt(){
   var InStr = BulidTaritemsExt();
	$m({
		ClassName:"INSU.MI.BL.TarItemsExt",
		MethodName:"Save",
		InData:InStr
	},function(rtnData){
		if (+rtnData>0){
			$.messager.alert("��ܰ��ʾ", "����ɹ�", 'success');
			setValueById("ExtRowid",+rtnData);
		}else{
			$.messager.alert("������ʾ", "����ʧ��"+rtnData, 'error');
		}
	});
}
//��֯ҽ��Ŀ¼��չ��Ϣ��
function BulidTaritemsExt(){
	
	 // 01-05��Rowid SPT ҽ��Ŀ¼���� SPT ҽ��Ŀ¼���� SPT ҽ������ SPT �����־ SPT
     var InStr = getValueById("ExtRowid");
	 InStr=InStr+"^"+getValueById("InsuCode");
	 InStr=InStr+"^"+getValueById("InsuDesc");
	 InStr=InStr+"^"+getValueById("HiType");
	 InStr=InStr+"^"+getValueById("SpFlag");
    // 06-10���������� SPT ҽ����Ⱥ SPT �Ը����� SPT ҽ����� SPT ��������˵�� SPT
     InStr=InStr+"^"+getValueById("XzType");
     InStr=InStr+"^"+getValueById("HiGrp");
     InStr=InStr+"^"+getValueById("SelfPayProp");
     InStr=InStr+"^"+getValueById("MedType");
     InStr=InStr+"^"+getValueById("LmtCondDscr");
    // 11-16���������� SPT ��Ч���� SPT ��Ч��־ SPT ������ SPT �������� SPT ����ʱ�� SPT 
     InStr=InStr+"^"+getValueById("BegnDate");
     InStr=InStr+"^"+getValueById("EndDate");
     InStr=InStr+"^"+getValueById("ValidFlag");
	 if (getValueById("ExtRowid")>0) {
      InStr=InStr+"^"+getValueById("CrterId");
      InStr=InStr+"^"+getValueById("CrteDate");
	  InStr=InStr+"^"+getValueById("CrteTime");
	 }else{
		InStr=InStr+"^"+GV.UserId+"^^";
	 }
    // 17-20�������� SPT �������� SPT ����ʱ�� SPT ҽԺID
	 if (getValueById("ExtRowid")>0){
		InStr=InStr+"^"+GV.UserId+"^^";
	 }else{
		InStr=InStr+"^^^"+"";
	 }
	 InStr=InStr+"^"+GV.HospId;
	 return InStr ;
}


//��ʼ��ҽ������
function InitHiTypeCmb() {
	$HUI.combobox("#HiType", {
		url: $URL,
		editable: false,
		valueField: 'cCode',
		textField: 'cDesc',
		panelHeight: 100,
		method: "GET",
		onBeforeLoad: function (param) {
			param.ClassName = "web.INSUDicDataCom"
			param.QueryName = "QueryDic"
			param.ResultSetType = "array";
			param.Type = "TariType"
			param.Code = ""
		},
		loadFilter: function (data) {
			for (var i in data) {
				if (data[i].cDesc == "ȫ��") {
					data.splice(i, 1);
				}
			}
			return data;
		},
		onLoadSuccess: function (data) {
            setValueById('HiType',GV.HiType)
		}		 
	});
}