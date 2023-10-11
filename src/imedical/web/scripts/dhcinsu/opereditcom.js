/*
* FileName:	opereditcom.js
* User:		Hanzh 
* Date:		2021-12-03	
* Description: ҽ������ά������
*/
var GUser=session['LOGON.USERID'];
var HospDr='';
var GlobalInsuType = '';
$.extend($.fn.validatebox.defaults.rules, {
	checkZfblMaxAmt: {    
	    validator: function(value) {
		    return (value >=0)&&(value<=1);
		},
		message: "����ֵ����С��0����1"
	}
});

$(function () {
	initLayout();
	initEvent();
	init_HisVer();  // �汾 +20230115 HanZH
	
});		

function initLayout(){
	clearOperItm();
	var Rq = INSUGetRequest();
	var Rowid = Rq["Rowid"] ||"";
	
	var AllowUpdateFlag = Rq["AllowUpdateFlag"]; // �Ƿ������޸ı�־
	    HospDr = Rq["HospId"];
 	//// tangzf 2019-8-9 add new insuitmes start-----------------
	 InitHiTypeCmb(); // ��ʼ��ҽ������
	 GlobalInsuType=Rq["HiType"]; //
	 $('#HiType').combobox('select',GlobalInsuType);
	//disableById("HiType");
	InitUsedStd();	// ʹ�ñ��
	InitValiFlag();	// ��Ч��־
	if(Rowid!=""){
		disableById("HiType") ; //����������򲻽���	�ڴ˴��ɸ��������� ������ҽ�����ֶ����ĵ�  ��Ŀ
	}else{
		$('#btnU').linkbutton({text:'����',iconCls:'icon-w-add'});
	}
	if(AllowUpdateFlag == 'N'){
		$('#btnU').hide();//ҽ��Ŀ¼���ս������ӹ����Ĳ������޸�	
	}
	$.m({
		ClassName: "INSU.MI.DTO.OPRNOPRTLIST",
		MethodName: "GetOPRNOPRTLISTById",
		type: "GET",
		RowId: Rowid
	},function (rtn) {
			if (rtn.split("^")[0] != "-1") {
				//alert("rtn="+rtn)
				var AryD = rtn.split("^");
				InsuType = AryD[2];
				loadOperItm(rtn); // 
			}
		});
	// tangzf 2019-8-9 add new insuitmes end -----------------
	 disableById("HisCrterId");
	 disableById("HisCrteDate");
	 disableById("HisCrteTIme");
	 disableById("HisUpdtId");
	 disableById("HisUpdtDate");
	 disableById("HisUpdtTime");
	 disableById("HisBatch");
	 disableById("VerName");
	 disableById("Ver");
	 disableById("Rid");
	 disableById("OprnStdListId");
	 disableById("CrteTime");
	 disableById("UpdtTime");
}	
function initEvent(){
	$("#btnU").click(function () {	
		UpdateOperItm();		
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
	}		
//ҽ����Ŀ���ƻس��¼�
/*$("#lxmmc").keyup(function(e) { lxmmc_onkeyup(e);});  

$('.textbox').blur(function (e){
	        try
	        {
			  INSUcheckText(this.value); 
	        }
	        catch(ex)
	        {
		        e.target.value="";
			    e.target.focus(); 
		     }
			
	});
});	
*/

//ҽ����Ŀ���ƻس��¼�
/*
function lxmmc_onkeyup(e){	
	if (e.keyCode==13)
	{
	$.m({
		ClassName: "web.DHCINSUPort",
		MethodName: "GetCNCODE",
		type: "GET",
		HANZIS:getValueById("lxmmc"),
		FLAG: "4",
		SPLIT: ""
	},function (rtn)
	{	
		setValueById("lxmrj", rtn);	
		});
    }
    else{
	    if (getValueById("lxmmc")==""){setValueById("lxmrj", "")}
	    }
	
		
}*/
/*
 * ��������
 */
function checkData() {
	var rtn = true;
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		rtn = false;
		$.messager.alert('��ʾ', '������֤ʧ��' , 'error');
	}
	return rtn;
}
//��ʼ��HiType
function InitHiTypeCmb() {
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
		}
		
	}); 
}

//����ʹ�ñ��
function InitUsedStd() {
	$HUI.combobox("#UsedStd", {
		editable: false,
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: '1', text: '��' }
			, { id: '0', text: '��' }
	 
		]
	}
	);
}
//������Ч��־
function InitValiFlag() {
	$HUI.combobox("#ValiFlag", {
		editable: false,
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: '1', text: '��' }
			, { id: '0', text: '��' }
		]
	}
	);
}
//ҽ������ά��������ֵ
function loadOperItm(InData) {
	var AryD = InData.split("^");
	setTimeout(function () {
			setValueById("Rowid", AryD[0]);             //01  Rowid
			setValueById("HospId", AryD[1]);            //02 ҽԺID
			setValueById("HiType", AryD[2]);            //03 ҽ������
			setValueById("OprnStdListId", AryD[3]);     //04 ������׼Ŀ¼ID
		}, 300);
	setValueById("Cpr", AryD[4]);                       //05 �� 
	setValueById("CprCodeScp", AryD[5]);                //06 �´��뷶Χ
	setValueById("Cprname", AryD[6]);                  //07 ������
	setValueById("CGyCode", AryD[7]);                  //08 ��Ŀ����
	setValueById("CgyName", AryD[8]);                   //09 ��Ŀ����
	setValueById("SorCode", AryD[9]);                  //10 ��Ŀ����
	setValueById("SorName", AryD[10]);                  //11 ��Ŀ����
	setValueById("DtlsCode", AryD[11]);                  //12 ϸĿ����
	setValueById("DtlsName", AryD[12]);                 //13 ϸĿ����                   
	setValueById("OprnOprtCode", AryD[13]);             //14 ������������
	setValueById("OprnOprtName", AryD[14]);              //15 ������������
	setValueById("UsedStd", AryD[15]);                  //16 ʹ�ñ��
	setValueById("RtlOprnOprtCode", AryD[16]);          //17 �ű��������������
	setValueById("RtlOprnOprtName", AryD[17]);          //18 �ű��������������
	setValueById("ClncOprnOprtCode", AryD[18]);         //19 �ٴ���������������
	setValueById("ClncOprnName", AryD[19]);             //20 �ٴ���������������
	setValueById("Memo", AryD[20]);                      //21 ��ע
	setValueById("ValiFlag", AryD[21]);                 //22 ��Ч��־
	setValueById("Rid", AryD[22]);                      //23 ����Ψһ��¼��
	setValueById("CrteTime", AryD[23]);                 //24  ���ݴ���ʱ��
	setValueById("UpdtTime", AryD[24]);                 //25 ���ݸ���ʱ��
	setValueById("Ver", AryD[25]);                      //26 �汾��
	setValueById("VerName", AryD[26]);                  //27 �汾����
	setValueById("HisBatch", AryD[27]);                 //28 HIS��������
	setValueById("HisCrterId", AryD[28]);               //29 HIS������
	setValueById("HisCrteDate", AryD[29]);              //30 HIS�������� 
	setValueById("HisCrteTIme", AryD[30]);              //31 HIS����ʱ��
	setValueById("HisUpdtId", AryD[31]);                //32 HIS������ID
	setValueById("HisUpdtDate", AryD[32]);              //33 HIS��������
	setValueById("HisUpdtTime", AryD[33]);              //33 HIS����ʱ��
	setValueById("HisVer", AryD[34]);                 	//34 �汾	+20230115 HanZH
	
}	
//����ҽ������
function UpdateOperItm() {
	var InStr = BuildOperItmFromEdStr();
	//if (InStr == "-1" || !checkData()) return "-1";
	if (InStr == "-1" ) return "-1";
	$.m({
		ClassName: "INSU.MI.DTO.OPRNOPRTLIST",
		MethodName: "CheckOPRNOPRTLIST",
		type: "GET",
		HospId: HospDr,
		HiType: GlobalInsuType,
		Code: getValueById('OprnOprtCode'),
		Desc: getValueById('OprnOprtName'),
		HisBatch: getValueById('HisBatch'),
		Ver: getValueById('Ver'),
		HisVer: getValueById('HisVer')
	}, function (rtn) {
		/*if ((rtn > 0) & ((rtn.split("^")).pop() != getValueById("Rowid"))) {
			$.messager.alert("��ʾ", "����ͬ��������Ŀ,��������", 'info');
			return "-1";
		}
		else {
			$.m({
				ClassName: "INSU.MI.DTO.OPRNOPRTLIST",
				MethodName: "SaveInsuOper",
				type: "GET",
				Instring: InStr
			}, function (srtn) {
				if (srtn == "0") { $.messager.alert("��ʾ", "���³ɹ�", 'info',function(){
					websys_showModal('close');	
				});}
				else { $.messager.alert("��ʾ", "����ʧ��,Err=" + srtn, 'info');}
			});
		} */
		$.m({
			ClassName: "INSU.MI.DTO.OPRNOPRTLIST",
			MethodName: "SaveInsuOper",
			type: "GET",
			Instring: InStr
		}, function (srtn) {
			// if (srtn >"0") {$.messager.alert("��ʾ", "���³ɹ�,Rowid=" + srtn, 'info',function(){
			// 			websys_showModal('close');	
			// });}
			// else{ $.messager.alert("��ʾ", "����ʧ��,Err=" + srtn, 'info');}
			var srtnArr = srtn.split("!");
			if (srtnArr[0] >"0") {
				if(srtnArr.length>1){
					$.messager.alert('��ʾ',"Rowid="+srtnArr, 'info',function(){
						websys_showModal('close');	
					});
				}
				else{
					$.messager.alert("��ʾ", "���³ɹ�,Rowid=" + srtn, 'info',function(){
						websys_showModal('close');	
					});
				}
			}
			else { 
				$.messager.alert("��ʾ", "����ʧ��,Err=" + srtn, 'info');	
			}
			
		});
	});		 
}

function BuildOperItmFromEdStr() {
	//+20230214 HanZH	ҽ�����Ͳ���Ϊ��
	if($('#HiType').combogrid("getValue")==""){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return "-1";	
	}
	var UpdtUserId="",CrtUserId=GUser;
	if (getValueById("Rowid")>0){
		   UpdtUserId=GUser;
		   CrtUserId=""
		}
	var InStr = getValueById("Rowid");                              //01  Rowid
	InStr = InStr + "^" + HospDr;                                   //02 ҽԺID
	//InStr = InStr + "^" + getValueById("HiType");                 //03 ҽ������
	InStr = InStr + "^" + $('#HiType').combogrid("getValue");       //03 ҽ������
	InStr = InStr + "^" + getValueById("OprnStdListId");            //04 ������׼Ŀ¼ID
	InStr = InStr + "^" + getValueById("Cpr");                      //05 �� 
	InStr = InStr + "^" + getValueById("CprCodeScp");               //06 �´��뷶Χ
	InStr = InStr + "^" + getValueById("Cprname");                  //07 ������
	InStr = InStr + "^" + getValueById("CGyCode");                  //08 ��Ŀ����
	InStr = InStr + "^" + getValueById("CgyName");                  //09 ��Ŀ����
	InStr = InStr + "^" + getValueById("SorCode");                  //10 ��Ŀ����
	InStr = InStr + "^" + getValueById("SorName");                  //11 ��Ŀ����
	InStr = InStr + "^" + getValueById("DtlsCode");                 //12 ϸĿ����
	InStr = InStr + "^" + getValueById("DtlsName");                 //13 ϸĿ����                   
	InStr = InStr + "^" + getValueById("OprnOprtCode");             //14 ������������
	InStr = InStr + "^" + getValueById("OprnOprtName");             //15 ������������
	InStr = InStr + "^" + getValueById("UsedStd");                  //16 ʹ�ñ��
	InStr = InStr + "^" + getValueById("RtlOprnOprtCode");          //17 �ű��������������
	InStr = InStr + "^" + getValueById("RtlOprnOprtName");          //18 �ű��������������
	InStr = InStr + "^" + getValueById("ClncOprnOprtCode");         //19 �ٴ���������������
	InStr = InStr + "^" + getValueById("ClncOprnName");             //20 �ٴ���������������
	InStr = InStr + "^" + getValueById("Memo");                     //21 ��ע
	InStr = InStr + "^" + getValueById("ValiFlag");                 //22 ��Ч��־
	InStr = InStr + "^" + getValueById("Rid");                      //23 ����Ψһ��¼��
	InStr = InStr + "^" + getValueById("CrteTime");                 //24  ���ݴ���ʱ��
	InStr = InStr + "^" + getValueById("UpdtTime");                 //25 ���ݸ���ʱ��
	InStr = InStr + "^" + getValueById("Ver");                      //26 �汾��
	InStr = InStr + "^" + getValueById("VerName");                  //27 �汾����
	InStr = InStr + "^" + getValueById("HisBatch");                 //28 HIS��������
	InStr = InStr + "^" + CrtUserId                                 //29 HIS������
	InStr = InStr + "^" + "";                                       //30 HIS�������� 
	InStr = InStr + "^" + "";                                       //31 HIS����ʱ��
	InStr = InStr + "^" + UpdtUserId;                               //32 HIS������ID
	InStr = InStr + "^" +"";                                        //33 HIS��������
	InStr = InStr + "^" +"";                                        //34 HIS����ʱ��
	//+20230117 HanZH
	var HisVer=getValueById("HisVer");
	if(HisVer==""){
		$.messager.alert('��ʾ','�汾����Ϊ��','info');
		return "-1";	
	}
	InStr = InStr + "^" + HisVer;                 					//35 �汾
	return InStr;

}

//���ҽ��Ŀ¼ά��
function clearOperItm() {
	
	$("#InItmEPl").form("clear");
	
}	
/*
 *�汾
 */
 function init_HisVer(){	
	//�����б�
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
	      	param.type='User.ORCOperation';
	      	param.IsInsuFlag='Y';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {		
		}
	});		
}

