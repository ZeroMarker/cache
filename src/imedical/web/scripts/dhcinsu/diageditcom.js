/**
* FillName: diageditcom.js
* Description: ҽ�����ά������ 
* Creator: HanZH
* Date: 2023-02-08
*/
//��ں���
var GV = {
	HospDr:session['LOGON.HOSPID'] ,  //Ժ��ID
	USERID:session['LOGON.USERID'] ,  //����ԱID
	GROUPID:session['LOGON.GROUPID'], //��ȫ��id
}
$.extend($.fn.validatebox.defaults.rules, {
	checkZfblMaxAmt: {    
	    validator: function(value) {
		    return (value >=0)&&(value<=1);
		},
		message: "����ֵ����С��0����1"
	}
});

GetjsonQueryUrl();

$(function(){
	initLayout();	//��ʼ�����
	initEvent();	//��ʼ���¼�
});

function initLayout(){
	clearDiag();
	var Rq = INSUGetRequest();
	var Rowid = Rq["Rowid"] ||"";
	var AllowUpdateFlag = Rq["AllowUpdateFlag"]; // �Ƿ������޸ı�־
	HospDr = Rq["HospId"];
	InitHiTypeCmb();	// ��ʼ��ҽ������
	InitHisVer();		// ��ʼ��Ժ�ڰ汾��
	GlobalInsuType=Rq["HiType"]; //
	$('#HiType').combobox('select',GlobalInsuType);		// �޸����ҽ�����ʹ���
	if(Rowid!=""){
		disableById("HiType") ; //����������򲻽���	�ڴ˴��ɸ��������� ������ҽ�����ֶ����ĵ�  ��Ŀ
	}else{
		$('#btnU').linkbutton({text:'����',iconCls:'icon-w-add'});
	}
	if(AllowUpdateFlag == 'N'){
		$('#btnU').hide();//ҽ����϶��ս������ӹ����Ĳ������޸�	
	}
	$.m({
		ClassName: "web.INSUDiagnosis",
		MethodName: "GetDiagnosisById",
		type: "GET",
		RowId: Rowid
	},function (rtn) {
			if (rtn.split("^")[0] != "-1") {
				//alert("rtn="+rtn)
				var AryD = rtn.split("^");
				InsuType = AryD[1];
				loadDiagnosis(rtn); // 
			}
		});
	 disableById("Date");
	 disableById("Time");
	 disableById("UserDr");
	 disableById("ADDIP");
}
 
//��ʼ���¼�
function initEvent(){
	$("#btnU").click(function () {	
		SaveDiag();		//���±���ҽ�����
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
}

//��ʼ��ҽ������
function InitHiTypeCmb(){
	//��ʼ��HiType
	// $HUI.combobox("#HiType", {
	// 	url: $URL,
	// 	editable: false,
	// 	valueField: 'cCode',
	// 	textField: 'cDesc',
	// 	panelHeight: 100,
	// 	method: "GET",
	// 	//data:comboJson.rows,
	// 	onBeforeLoad: function (param) {
	// 		param.ClassName = "web.INSUDicDataCom"
	// 		param.QueryName = "QueryDic1"
	//         param.Type = 'TariType';
	//         param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID  
	// 	},
	// 	loadFilter: function (data) {
	// 		for (var i in data) {
	// 			if (data[i].cDesc == "ȫ��") {
	// 				data.splice(i, 1);
	// 			}
	// 		}
	// 		return data;
	// 	},
	// 	onLoadSuccess: function (data) {
	// 	},
	// 	onSelect: function (rec) {
	// 		// tangzf 2019-8-9 ����ҽ��Ŀ¼ �л�ҽ������ʱ  ����combobox----------
	// 		// tangzf 2019-8-9 ����ҽ��Ŀ¼ �л�ҽ������ʱ  ����combobox----------	 
	// 	}			 			 
	// });
	var diccombox=$('#HiType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
        rownumbers:true,
        url:$URL,
        onBeforeLoad:function(param){
	        param.ClassName = 'web.INSUDicDataCom';
	        param.QueryName = 'QueryDic1';
	        param.Type = 'TariType';
	        param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;    
	    },
        fit: true,
        pagination: false,
	    columns:[[   
	        {field:'cCode',title:'����',width:60},  
	        {field:'cDesc',title:'����',width:100}  
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    diccombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
			Initjcbzbz();	//��ʼ�����Ʒ�ʽ
		}
	}); 
}

//��ʼ���汾
function InitHisVer(){
	$('#HisVer').combobox({
		valueField: 'VersionCode',
		textField: 'VersionName',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			console.log(param)
			param.ClassName = 'web.DHCINSUPortUse';
			param.QueryName = 'GetBDVersionDic';
			param.rowid = '';
			param.code = '';
			param.desc = '';
			param.type='User.MRCICDDx';
			param.IsInsuFlag='Y';
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
			Query();
		}
	});	
	
}

//��ʼ�����Ʒ�ʽ
function Initjcbzbz(){
	var jcbzbzcombox=$('#jcbzbz').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
        rownumbers:true,
        url:$URL,
        onBeforeLoad:function(param){
	        param.ClassName = 'web.INSUDicDataCom';
	        param.QueryName = 'QueryDic1';
	        param.Type = 'trt_type'+$('#HiType').combogrid("getValue");
	        param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;    
	    },
        fit: true,
        pagination: false,
	    columns:[[   
	        {field:'cCode',title:'����',width:60},  
	        {field:'cDesc',title:'����',width:100}  
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    //jcbzbzcombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
		}
		
	}); 
}

//ҽ�����ά��������ֵ
function loadDiagnosis(InData) {
	var AryD = InData.split("^");
	setTimeout(function () {
			setValueById("Rowid", AryD[0]);             //01  Rowid
			setValueById("HiType", AryD[1]);            //02 ҽ������
			setValueById("bzbm", AryD[2]);     			//03 ��ϴ���
		}, 300);
	setValueById("bzmc", AryD[3]);                   	//04 ������� 
	setValueById("srrj", AryD[4]);                      //05 ������ 
	setValueById("srrj2", AryD[5]);                		//06 ������2
	setValueById("jcbzbz", AryD[6]);                	//07 ���Ʒ�ʽ
	setValueById("Cate", AryD[7]);                  	//08 ��������
	setValueById("SubCate", AryD[8]);                   //09 ����������
	setValueById("Date", AryD[9]);                   	//10 ��������
	setValueById("Time", AryD[10]);                  	//11 ����ʱ��
	setValueById("UserDr", AryD[11]);                   //12 ����Ա
	setValueById("ADDIP", AryD[12]);                    //13 ����IP
	setValueById("ActiveDate", AryD[13]);               //14 ��Ч����                   
	setValueById("Unique", AryD[14]);            		//15 ����Ψһ��
	setValueById("INDISXString01", AryD[15]);           //16 Ԥ����1
	setValueById("INDISXString02", AryD[16]);           //17 Ԥ����2
	setValueById("INDISXString03", AryD[17]);           //18 Ԥ����3
	setValueById("INDISXString04", AryD[18]);           //19 Ԥ����4
	setValueById("INDISXString05", AryD[19]);           //20 Ԥ����5
	setValueById("INDISXString06", AryD[20]);           //21 Ԥ����6
	setValueById("INDISXString07", AryD[21]);           //22 Ԥ����7
	setValueById("INDISXString08", AryD[22]);           //23 Ԥ����8
	setValueById("HisVer", AryD[23]);                   //24 Ժ�ڰ汾��
	setValueById("ExpiryDate", AryD[24]);          		//25 ʧЧ����
	setValueById("HospId", AryD[25]);                   //26 Ժ��ָ��
}	

//���±���ҽ�����
function SaveDiag(){
	var InStr = BuildDiagsStr();
	var savecode=tkMakeServerCall("web.INSUDiagnosis","SaveDiag",InStr)
	// if (savecode>0){
	// 	$.messager.alert('��ʾ','����ҽ����ϳɹ�');
	// }
	// else{
	// 	$.messager.alert("��ʾ","����ҽ�����ʧ��!rtn="+savecode, 'error');	
	// }
	var rtnArr = savecode.split("!");
	
	if (rtnArr[0]>0){
		if(rtnArr.length>1){
			$.messager.alert('��ʾ',"Rowid="+rtnArr);
		}
		else{
			$.messager.alert('��ʾ','����ҽ����ϳɹ�');
		}
	}
	else{
		$.messager.alert("��ʾ","����ҽ�����ʧ��!rtn="+savecode, 'error');	
	}
}

//��֯���±��������Ϣ��
function BuildDiagsStr() {
	var ADDIP = GetLocalIPAddress();
	//+20230214 HanZH	ҽ�����Ͳ���Ϊ��
	var HiType=$('#HiType').combogrid("getValue");
	if(HiType==""){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return "-1";	
	}
	//+20230209 HanZH	Ժ�ڰ汾�Ų���Ϊ��
	var HisVer=getValueById("HisVer");
	if(HisVer==""){
		$.messager.alert('��ʾ','Ժ�ڰ汾�Ų���Ϊ��','info');
		return "-1";	
	}

	var InStr = getValueById("Rowid");							//01  Rowid
	InStr = InStr + "^" + HiType;								//02 ҽ������
	InStr = InStr + "^" + getValueById("bzbm");					//03 ��ϴ���
	InStr = InStr + "^" + getValueById("bzmc");					//04 �������
	InStr = InStr + "^" + getValueById("srrj");					//05 ������ 
	InStr = InStr + "^" + getValueById("srrj2");                //06 ������2
	InStr = InStr + "^" + getValueById("jcbzbz");               //07 ���Ʒ�ʽ
	InStr = InStr + "^" + getValueById("Cate");                 //08 ��������
	InStr = InStr + "^" + getValueById("SubCate");              //09 ����������
	InStr = InStr + "^" + ""; 					                //10 ��������
	InStr = InStr + "^" + "";			   				        //11 ����ʱ��
	InStr = InStr + "^" + GV.USERID;           				    //12 ����Ա
	InStr = InStr + "^" + ADDIP;               	 				//13 ����IP                   
	InStr = InStr + "^" + getValueById("ActiveDate");           //14 ��Ч����
	InStr = InStr + "^" + getValueById("Unique");             	//15 ����Ψһ��
	InStr = InStr + "^" + getValueById("INDISXString01");       //16 Ԥ����1
	InStr = InStr + "^" + getValueById("INDISXString02");       //17 Ԥ����2
	InStr = InStr + "^" + getValueById("INDISXString03");       //18 Ԥ����3
	InStr = InStr + "^" + getValueById("INDISXString04");       //19 Ԥ����4
	InStr = InStr + "^" + getValueById("INDISXString05");       //20 Ԥ����5
	InStr = InStr + "^" + getValueById("INDISXString06");       //21 Ԥ����6
	InStr = InStr + "^" + getValueById("INDISXString07");       //22 Ԥ����7
	InStr = InStr + "^" + getValueById("INDISXString08");       //23 Ԥ����8
	InStr = InStr + "^" + HisVer;      					       	//24 Ժ�ڰ汾��
	InStr = InStr + "^" + getValueById("ExpiryDate");      		//25 ʧЧ����
	InStr = InStr + "^" + getValueById("HospId");               //26 Ժ��ָ��

	return InStr;
}

function GetLocalIPAddress()  
{  
    var obj = null;  
    var rslt = "";  
    try  
    {  
		//-------Zhan 20190521-------->
		if("undefined" != typeof ClientIPAddress){
			rslt=ClientIPAddress		
		}
		if(rslt!=""){return rslt};
		//<---------------------------//
        obj = new ActiveXObject("rcbdyctl.Setting");  
        rslt = obj.GetIPAddress;  
      	rslt=rslt.split(";")[0]
        obj = null;  
    }  
    catch(e)  
    {  
        //alert("�쳣��rcbdyctl.dll��̬��δע�ᣬ����ע��!")
        rslt="";
    } 
    return rslt
}

//���ҽ�����ά��
function clearDiag() {
	
	$("#Diag").form("clear");
	
}
 
