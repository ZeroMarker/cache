/*ע�����˰��Ocx��ӡ�ſ�,��װ˰��.exe����ȷ��·���ͳ���·���Ƿ�һ�¡�
document.write("<object ID='sk' style = 'display:none' CLASSID='CLSID:003BD8F2-A6C3-48EF-9B72-ECFD8FC4D49F' CODEBASE='../addins/client/NISEC_SKSCX.OCX#version=1,0,0,1' VIEWASTEXT>");
document.write("</object>");
*/
/**
 * FileName: bill.einv.invoiceupagain.js
 * Author: ZhaoZW
 * Date: 2019-09-16
 * Description:
 */
 
 /* add  guoyunlong
 ��ע���ò�˼JS��ӡ����Ҫ�ſ��������
 1.���ò�˼JS,����˼JS�ŵ�scripts·����   --industry-proxy-app.js
 2.��װ��˼��ӡС����                     --����Ʊ�ݿͻ����ۺϹ������-v1.6.5.exe
 3.���Դ�ӡ���ô�ӡ������ӡ
 4.��Ӧ�������ɲ���ҽԺ������
 */
 /*  
 var industry = new BsIndustryApi({'appId':'CZSRMYY2711079',
        'appKey':'949d65daf18f83dfa9a2e803e3',
        'type':'medical',
        'url':'http://172.16.1.31:7520/medical-web/'});
 */
 var UserID=session['LOGON.USERID']
 var HOSPID=session['LOGON.HOSPID']
            
$(function(){
	setPageLayout(); //ҳ�沼�ֳ�ʼ��
	setElementEvent(); //ҳ���¼���ʼ��
});

function setPageLayout(){
	//��ȡ��ǰ����
	var nowDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//���ÿ�ʼ����ֵ
	$('#IUDStDate').datebox('setValue', nowDate);
	//���ý�������ֵ
	$('#IUDEdDate').datebox('setValue', nowDate);
	$HUI.combobox('#IUDPayAdmTypeCombo',{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
		method:"GET",
		onBeforeLoad:function(param)
		{
			param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
			param.QueryName="QueryDicDataInfo"
			param.ResultSetType="array";
			param.Type="BusinessType"          //ҵ�������ֶ�Type="LogicType"
		}
		,onLoadSuccess:function(){
			if(LogicTypeLoadFlg=="0"){
				//alert("LogicTypeLoadFlg="+LogicTypeLoadFlg);
				LogicTypeLoadFlg="1";
		
				var LogicArr=$('#IUDPayAdmTypeCombo').combobox("getData");
				var AllLogicType={
					DicCode:"ALL",
					DicDesc:"ȫ��"
				};
				LogicArr.splice(0, 0, AllLogicType);             //��ָ��λ�����Ԫ��,��һ������ָ��λ��,�ڶ�������ָ��Ҫɾ����Ԫ��,���Ϊ0,��׷��
				$('#IUDPayAdmTypeCombo').combobox('loadData', LogicArr);
			}
			
			$('#IUDPayAdmTypeCombo').combobox('setValue','ALL');
		}
	});
	
	$("#EINVFlg").combobox({
		valueField:'code',
		textField:'desc',
		data:[{
			'code':'ALL',
			'desc':'ȫ��'			
		},{
			'code':'0',
			'desc':'δ��Ʊ',
			'selected':true
		},{
			'code':'1',
			'desc':'�ѿ�Ʊ'
		}]
	});

	//��ʼ��Ժ��
	$HUI.combobox('#Hosptial',{
		valueField:'HospitalDr', 
		textField:'HospitalNM',
		panelHeight:"auto",
		url:$URL,
		editable:false,
		method:"GET",
		onBeforeLoad:function(param){ 
			param.ClassName="BILL.EINV.BL.COM.InvPageInfoCtl"
			param.QueryName="QueryGetHospital"
			param.ResultSetType="array"
			param.HospDr=HOSPID              //���ݵ�¼Ժ������
		}
	});
	//$('#Hosptial').combobox('setValue','ALL');
	
	
	
	$HUI.datagrid('#tBillIUD',{
		fit:true,
		pagination:true,
		pageSize:20,
		pageList:[20,40,60],
		singleSelect:true,
		//singleSelect:false,
		selectOnCheck:false,
		checkOnSelect:false,
		striped:true,
		rownumbers:false,
		toolbar: [],
		url:$URL,
		columns:[[    
			{field:'checkbox',checkbox:true}, 
			{field:'PatRegNo',title:'�ǼǺ�',width:80},
			{field:'PatName',title:'����',width:80},
			{field:'PacAdmReasonDesc',title:'�ѱ�',width:100},
			{field:'InvprtAmount',title:'Ʊ�ݽ��',width:90, align:'right'},
			{field:'LocgicType',title:'ҵ������',width:80
				,formatter:function(value,row){
					var rtn=GetLogicTypeDesc(value);
					return rtn;
				}
			},
			{field:'SFTFFlg',title:'�շ�/�˷�',width:80
				,styler: function(value,row,index){
					var rtnStyle="";
					if(row.SFTFFlg=="�˷�"){
						rtnStyle= 'color:red;';
					}
					
					return rtnStyle
				}
			},
			{field:'EInvFlg',title:'�ϴ���־',width:150,
				styler: function(value,row,index){
					var rtnStyle="";
					if(row.EInvFlg=="1"){             //�ѿ�Ʊ������ʾ
						rtnStyle= 'background-color:#00ffff;';
					}
					
					return rtnStyle
				},
				formatter:function(index,value){
					var rtn=""
					if(value.EInvFlg=="1"){
						rtn="���ϴ�"
					}else{
						rtn="δ�ϴ�"
					}
					return rtn;
				}
				
			},
			{field:'Invprtrowid',title:'his��ƱDr',width:100},
			{field:'InitRowid',title:'hisԭ��ƱDr',width:100},
			{field:'SFDate',title:'�շ�����',width:70},
			{field:'SFTime',title:'�շ�ʱ��',width:70},
			{field:'SFUserDr',title:'�շ�ԱDr',width:100,hidden:true},
			{field:'SFUserName',title:'�շ�Ա',width:100},
			{field:'AdmLocName',title:'�������',width:100},
			{field:'AdmHospitalDr',title:'Ժ��Dr',width:100,hidden:true},
			{field:'AdmHospitalNM',title:'Ժ������',width:150},
			
			{field:'EInvCode',title:'Ʊ�ݴ���',width:100},
			{field:'EInvSeriNo',title:'Ʊ�ݺ�',width:100},
			{field:'EInvRandom',title:'У����',width:80},
			{field:'PDFUrl',title:'PDFUrl',width:100},
			{field:'BusinessDr',title:'ҵ���dr',width:100,hidden:true},
			{field:'PictureUrl',title:'��ַURL',width:200,
				formatter: function (value,row, index) {
					//alert(row.PictureUrl);
					if (value) {
							return "<a href="+ row.PictureUrl+" >" + row.PictureUrl + "</a>";
							return "<a href='javascript:;' onclick=\"printEInv(\'" + row.PictureUrl + "\')\">" + row.PictureUrl + "</a>";
					}
				}
			}
			/*
			{field:'IUDInvDr',title:'��Ʊ��ָ��'},    
			{field:'IUDCreatAmt',title:'��Ʊ���'},    
			{field:'IUDBillBatchCode',title:'����Ʊ�ݴ���'},
			{field:'IUDBillBatchNo',title:'����Ʊ�ݺ���'},
			{field:'IUDPayAdmType',title:'Ʊ������',hidden:true},
			{field:'IUDPayAdmTypeDesc',title:'Ʊ������'},
			{field:'USRName',title:'�ϴ���'},
			{field:'IUDDate',title:'�ϴ�����'},
			{field:'IUDUplodeFlag',title:'�ϴ���־'},
			{field:'IUDHospDr',title:'Ժ��ָ��'},
			{field:'IUDCreatDate',title:'��Ʊ����',hidden:true},
			{field:'IUDCreatTime',title:'��Ʊʱ��',hidden:true},
			{field:'IUDBillBatchStatus',title:'����Ʊ��״̬'},
			{field:'IUDBillisScarlet',title:'�Ƿ��ѿ���Ʊ'},
			{field:'PrintType',title:'Ʊ��ģʽ'},
			{field:'InvStyle',title:'Ʊ������'},
			{field:'PrintFlag',title:'�Ƿ��ӡֽ��Ʊ��',
			formatter: function(value){
					if(value == "0"){
						return 'δ��ӡ'
					}
					if(value == "1"){
						return '�Ѵ�ӡ'	
					}
					if(value == ""){
						return '����'	
					}
				}
        	},
			{field:'RateStatus',title:'ֽ������״̬',
			 formatter: function(value){
					if(value == "0"){
						return 'δ����'
					}
					if(value == "1"){
						return '������'	
					}
					if(value == "2"){
						return 'ʧ��'	
					}
				}
			}
			*/
		]],
		fitColumns:true
	});
}

/// ����˵��������ҵ�����ͻ�ȡҵ������
var LogicTypeLoadFlg="0";
function GetLogicTypeDesc(LogicType){
	var LogicName="";
	
	var LogicArr=$("#IUDPayAdmTypeCombo").combobox("getData");
	var LogicLen=LogicArr.length;
	var objLogic=null;
	var LogicTypeTmp="";   //ҵ�����ͱ���
	for(index=0; index<LogicLen; index++){
		objLogic=LogicArr[index];
		LogicTypeTmp=objLogic.DicCode;    //ҵ�����ͱ���
		if(LogicTypeTmp==LogicType){
			LogicName=objLogic.DicDesc;   //ҵ����������
			break;
		}
	}
	
	return LogicName;
}

function setElementEvent(){
	///��ѯ
	$('#IUDSearch').click(function(){  
        queryBillIUDInfo();
    });
    ///���� ����ѡ��ĵ���Ʊ  
	$('#IUDUploadSelected').click(function(){
		//upDataInfo();
		InvoiceMuti();
	});
    
    ///������Ʊ
	$('#IUDUpload').click(function(){
		UpLoadEInvInfo();
	});
	///��ֽ��Ʊ
    $('#IUDUploadPInv').click(function(){  
        UpLoadPInvInfo();
    });
    ///Ʊ�ݳ���
    $('#IUDCancel').click(function(){  
        InvCancel();
    });
       //��ӡ��ƱOCX
    $('#IUDPrint').click(function(){  
        //InvPrintOCX();
        EInvPrintAll();      //������ӡ
    });
    
     //add by xubaobao 2020 07 23 
    $('#rmarkNo').on('keydown', function (e){			//�ǼǺŻس��¼�
		rmarkNoKeyDown(e);
	});	
	
     //add by suhuide 2021 12 28 
    $('#CardNo').on('keydown', function (e){			//���Żس��¼�
		cardNoKeydown(e);
	});	
	
	
	///��Ʊ����
    $('#IUDReInvoice').click(function(){  
        ReInvoice();
    });
    
    //����
	$HUI.linkbutton("#readCard",{
		onClick: function () {
			readHFMagCardClick();
		}
	});
	//��ӡ��Ʊ��ϸ
    $('#IUDPrintDetails').click(function(){  
        //EInvPrintByPrt();
        InvEPrintDetails();
    });
    
    //��ӡС��
    $('#PrintDirect').click(function(){  
        PrintDirectInfo();
    });
    
    
}

//add by xubaobao 2020 07 23  ���ӿ��Ų�ѯ����
function rmarkNoKeyDown(e){

	var key = websys_getKey(e);
	if (key == 13){
		GetRegNo();
		queryBillIUDInfo();
	}
}

//�ǼǺŲ���  
function GetRegNo(){
	var RegNo=$('#rmarkNo').val();
	var PRegNoLength=10-RegNo.length;      	
	for (var i=0;i<PRegNoLength;i++){
		RegNo="0"+RegNo;			
	}
	$('#rmarkNo').val(RegNo);	
}

/**
 * ���Żس��¼�
 * @create 2021-12-28
 * @author Suhuide
 */
function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//var cardNo = getValueById("CardNo");		//HISUI��֧��getValueById()��setValueById()��������
		var cardNo = $('#CardNo').val();
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}



function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		//setValueById("CardNo", myAry[1]);
		//patientId = myAry[4];
		//setValueById("rmarkNo", myAry[5]);
		$('#CardNo').val(myAry[1]);
		patientId = myAry[4];
		$('#rmarkNo').val(myAry[5]);

		break;
	case "-200":
		$.messager.alert("��ʾ", "����Ч", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		//setValueById("CardNo", myAry[1]);
		//patientId = myAry[4];
		//setValueById("rmarkNo", myAry[5]);
		$('#CardNo').val(myAry[1]);
		patientId = myAry[4];
		$('#rmarkNo').val(myAry[5]);
		break;
	default:
	}
	
	if (patientId != "") {
		queryBillIUDInfo();
	}
}


///��ѯδ�ϴ��ɹ��ĵ��ӷ�Ʊ����
function queryBillIUDInfo(){
	var IUDStDate = $('#IUDStDate').datebox('getValue');
	var IUDEdDate = $('#IUDEdDate').datebox('getValue');
	var IUDAdmType= $('#IUDPayAdmTypeCombo').combobox('getValue');
	var Hosital=$('#Hosptial').combobox('getValue');
	var RegNo=$('#rmarkNo').val();
	var EInvFlg=$("#EINVFlg").combobox("getValue");
	var Extstr=Hosital+"^"+RegNo+"^"+EInvFlg;
	//alert(IUDStDate+"^"+IUDEdDate+"^"+IUDAdmType)
	var queryParam={
		ClassName:'BILL.EINV.BL.COM.InvPageInfoCtl',
		QueryName:'QueryInvUploadInfo',
		IUDStDate:IUDStDate,
		IUDEdDate:IUDEdDate,
		IUDAdmType:IUDAdmType,
		Extstr:Extstr
	}
	$('#tBillIUD').datagrid({
		url:$URL,
		queryParams:queryParam
	})	
	//$('#tBillIUD').datagrid('load')
	
}
///������Ʊ
function UpLoadEInvInfo()
{
	var PathCode="";
	//Invoice(PathCode);
	Invoice(PathCode);
}

///��ֽ��Ʊ
function UpLoadPInvInfo()
{
	var PathCode="PInvoice" ;
	Invoice(PathCode);
	
}
/*
//��Ʊ����
function Invoice(PathCode)
{
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("��ѡ��һ����¼�������뿪Ʊ!");
		return ;
	}
	//�Ѿ����߳ɹ��Ĳ��������ظ����߷�Ʊ
	if(row.EInvFlg=="1")
	{
		alert("�÷�Ʊ�ѿ��߷�Ʊ,�������ظ����ߣ�");
		return ;
	}
	
	var	dataStr=row.LocgicType+"^"+row.Invprtrowid+"^"+row.InitRowid+"^"+PathCode
	alert(dataStr);
	var rtn=$cm({
				ClassName:"BILL.EINV.BL.COM.InvPageInfoCtl",
				MethodName:"DealData",
				dataStr:dataStr
	},false);
	if (rtn=="0")
	{
		alert("���߳ɹ�")
		///���߳ɹ�������Ū������һ������
		UpDateInvInfo(dataStr);
	}else{
		alert("����ʧ��")
		}				
}*/

/// ����˵����һ�ο�һ��Ʊ
function Invoice(PathCode){
	$('#IUDUpload').attr("disabled",true)     //���ð�ť
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("��ѡ��һ����¼�������뿪Ʊ!");
		return ;
	}
	//�Ѿ����߳ɹ��Ĳ��������ظ����߷�Ʊ
	if(row.EInvFlg=="1")
	{
		alert("�÷�Ʊ�ѿ��߷�Ʊ,�������ظ����ߣ�");
		return ;
	}
	
	var ErrMsg="";
	var AllRecsArr=[];
	AllRecsArr.push(row);
	InvoiceDo(AllRecsArr, 0, ErrMsg, PathCode);
}

/// ����˵����һ���Կ�����Ʊ
function InvoiceMuti(){
	var rows = $('#tBillIUD').datagrid('getChecked');
	if(rows.length>0){
		var PathCodeTmp="";
		var ErrMsgTmp="";
		InvoiceDo(rows, 0, ErrMsgTmp, PathCodeTmp);   �����Ʊ
	}else{
		alert("��ѡ��һ����¼!");
	}
}

/// ����˵������Ʊ���ߺ�̨��������
function InvoiceDo(CheckedRecs, i, ErrMsg, PathCode){
	
	var ErrMsgTmp="";
	var NextIndex=0;
	var AllRecLen=CheckedRecs.length;   //���ο�Ʊ��Ŀ
	var nowInvRecInfo=CheckedRecs[i];   //��ǰƱ�ݼ�¼
	var InvRecIndex=$('#tBillIUD').datagrid('getRowIndex', nowInvRecInfo);   //��ǰƱ������������
	
	var	dataStr=nowInvRecInfo.LocgicType+"|"+nowInvRecInfo.Invprtrowid+"|"+nowInvRecInfo.InitRowid+"|"+PathCode
	
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvPageInfoCtl",
		MethodName:"InvocieBill",
		dataStr:dataStr,
		Index:InvRecIndex
	},function(data){
		if(data.status>=0){
			$('#tBillIUD').datagrid('updateRow',{
				index:data.DataIndex,
				row:data.TradeData
			});	
		}else{
			ErrMsgTmp="��["+(InvRecIndex+1)+"]��Ʊ���ϴ�ʧ��:"+data.info;
			if(ErrMsg==""){
				ErrMsg=ErrMsgTmp;
			}else{
				ErrMsg=ErrMsg+"\n"+ErrMsgTmp;
			}
		}
		$('#IUDUpload').attr("disabled",false)    //�������
		NextIndex=i+1;    //��һ������¼
		if(NextIndex<AllRecLen){
			InvoiceDo(CheckedRecs, NextIndex, ErrMsg, PathCode)
		}else{
			if(ErrMsg!=""){
				alert(ErrMsg);
			}else{
				alert("���ϴ��ɹ�!");
			}
		}
		
	});
}



///Ʊ�ݳ���������������Ʊ���ݣ�HIS����Ҫ�˷ѣ�
function InvCancel()
{
  var PathCode="InvalidInvSvr" ;
  $.messager.confirm("ȷ��", "�Ƿ�����Ʊ?", function (r) {
				if (r) {
				   Invoice(PathCode);
				}
  });
 	
	
}


/*
//��ӡ����˰�ص������ؼ���ӡ�ķſ�
//���ص�����˰�ش�ӡ�������ã�sInputInfoĿǰд���������б䶯�޸�
function SetParameter(){
		var sInputInfo = "<?xml version=\"1.0\" encoding=\"gbk\"?>\r\n<business id=\"20001\" comment=\"��������\">\r\n<body yylxdm=\"1\">\r\n<servletip>10.30.2.172</servletip>\r\n<servletport>8080</servletport>\r\n<keypwd>88888888</keypwd>\r\n</body>\r\n</business>";
		try
		    {
		ret = sk.Operate(sInputInfo);
		//alert(ret);
		    }
		catch(e)
		    {
		alert(e.message + ",errno:" + e.number);
		    }	
}

///Ʊ�ݴ�ӡOCX
function InvPrintOCX()
{
 //alert("��ӡֽ��Ʊ��");
 var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("��ѡ��һ����¼�������뿪Ʊ!");
		return ;
	}
	var prtRowIdStr=row.Invprtrowid+"#"+"R";
	
	oppatInvPrintOCX(prtRowIdStr)   //  ��ӡ��ƱOCX
		
}

*/

function InvPrintOCX()
{
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("��ѡ��һ����¼�������뿪Ʊ!");
		return ;
	}
	
	var LocgicType=row.LocgicType
	if((LocgicType=="REG")||(LocgicType=="OP")){
		var moduleId="140601"			//����Ʊ��������룿����������Ŀʵ���޸Ĵ��룬�ֵ�����ȡ���ã���
	}
	else if(LocgicType=="IP"){
		var moduleId="140602"
	}
	
	var billBatchCode=row.EInvCode;
	var billNo=row.EInvSeriNo;
	var random=row.EInvRandom;
	
	//var moduleId="140402";     //����Ʊ���������
    //alert("��ӡ��ʼ="+billBatchCode+"!"+billNo+"!"+random+"!"+moduleId)
    var param = {
		'billBatchCode':billBatchCode,
		'billNo':billNo,
		'random':random,
		'moduleId':moduleId 
	}
	industry.printElectBill(param, '1.0', false).then(function (data) {
		   alert("data="+data)
           if(data&&data.result!='S0000'){
                alert(data.message)
            }
    console.log("success")
       }).fail(function (data) {
            console.log( data)
        });
}

/// ��������Ʊ
/// add by xubaobao 2020 09 08 
function ReInvoice()
{
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("��ѡ��һ����¼�������뻻����Ʊ!");
		return ;
	}
		
	//������������
	var PayAdmType=row.LocgicType;
	var HISPrtRowID=row.Invprtrowid;
	var OrgHISPrtRowID=row.InitRowid;
	var PathCode="InvalidInvSvr";
	var ExpStr="";    
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"InvocieBill",
		PayAdmType:PayAdmType,
		HISPrtRowID:HISPrtRowID,
		OrgHISPrtRowID:OrgHISPrtRowID,
		PathCode:PathCode,
		ExpStr:ExpStr
		},function(rtn){
			if(rtn.split("^")[0] != "0"){
				$.messager.alert("��ʾ","��Ʊ�ݳ��ʧ��,����ԭ��:"+rtn.split("^")[1]);
			}else{
				InvocieBill(PayAdmType,HISPrtRowID)
			}
	});
}

/// ������Ʊ
/// add by xubaobao 2020 09 08 
function InvocieBill(PayAdmType,HISPrtRowID){
	
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"InvocieBill",
		PayAdmType:PayAdmType,
		HISPrtRowID:HISPrtRowID,
		OrgHISPrtRowID:"",
		PathCode:"",
		ExpStr:""
	},function(rtn){
		if(rtn.split("^")[0] != "0"){
			$.messager.alert("��ʾ","������Ʊʧ��,����ԭ��:"+rtn.split("^")[1]);
		}else{
			$.messager.alert("��ʾ","����Ʊ�����ɹ�");
		}
	});
	
}

// add by xubaobao 2020 05 27
// ��ӡ���ŷ�Ʊ
function EInvPrintAll()
{
	var rows = $('#tBillIUD').datagrid('getChecked');
	if(rows.length>0){
		var PathCodeTmp="";
		var ErrMsgTmp="";
		EInvPrintDo(rows, 0, ErrMsgTmp, PathCodeTmp);   //�����ӡ
	}else{
		alert("��ѡ��һ����¼!");
	}
}

/// ����˵������Ʊ��ӡ
function EInvPrintDo(CheckedRecs, i, ErrMsg, PathCode){
	
	var ErrMsgTmp="";
	var NextIndex=0;
	var AllRecLen=CheckedRecs.length;   //���ο�Ʊ��Ŀ
	var nowInvRecInfo=CheckedRecs[i];   //��ǰƱ�ݼ�¼
	var InvRecIndex=$('#tBillIUD').datagrid('getRowIndex', nowInvRecInfo);   //��ǰƱ������������
	var LocgicType=nowInvRecInfo.LocgicType
	var billBatchCode=nowInvRecInfo.EInvCode;
	var billNo=nowInvRecInfo.EInvSeriNo;
	var random=nowInvRecInfo.EInvRandom;
	var HISPrtRowID=nowInvRecInfo.Invprtrowid;
	var PDFUrl=nowInvRecInfo.PDFUrl;
	//1.δ���ߵ��ӷ�Ʊ�������ӡ
	if(nowInvRecInfo.EInvFlg!="1")
	{
		alert("δ���ߵ��ӷ�Ʊ�������ӡ���ӷ�Ʊ��");
		return ;
	}
	if((billBatchCode=="")||(billNo==""))
	{
		alert("��ӡ���ӷ�Ʊ,Ʊ�ݴ��롢Ʊ�ݺ��벻��Ϊ��");
		return ;
	}
	////2.�������ã���Ʊ�Ƿ��ӡ���ӷ�Ʊ��Ĭ�ϲ���ӡ add 2022-06-21
	var rtn=$m({
				ClassName:"BILL.EINV.BL.COM.InvPageInfoCtl",
				MethodName:"GetInvInfoByIDAndType",
				PayAdmType:LocgicType,
				HISPrtRowID:HISPrtRowID
	},false);
	if(rtn.split("&")[4]!="N"){
		alert("����������Ʊ�ݣ��������ӡ!")
		return ;
	}
	///��ӡ��������  add 2022-04-08
	$m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetEINVDicByCodeAndInd",
		DicType:"Einv_ProCode_Case",
		DicCode:"Print_Num_Config",                     
		ind:"5"
	},function(rtn){                      
		///��ȡ��ǰ�Ѿ���ӡ����
		var PrintNum=GetPrintNum(billBatchCode,billNo)
		if((PrintNum>=rtn)&&(rtn!=0)){
			alert("��ӡ�����Ѿ��������ô�ӡ�������������ӡ!")
			return ;
			}
		
	});
	////????��һ������,��˼����֧��(���ִ�ӡ��1-JS��ӡ��2-�����ӡ)
	///w ##class(BILL.EINV.BL.EInvoiceLogic).PrintElectBilllList("IP","23682")
	///##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCateBS_ConFlag",5)
	
	$m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetEINVDicByCodeAndInd",
		DicType:"Einv_ProCode_Case",
		DicCode:"PrintBS_Config",                     
		ind:"5"
	},function(rtn){                      //0����JS��ӡ��1,����exe��ӡ,2�����������Ҵ�ӡ-PDF��ӡ
		if((rtn== "1")){
			///����exe��ӡ  --��˼
			PrintByBSExeNew(billBatchCode,billNo,random)
		}else if(rtn== "0"){
			//����JS��ʽ��ӡ   --��˼
			PrintByBSJS(LocgicType,billBatchCode,billNo,random)
			//PrintByBSExe(LocgicType,HISPrtRowID);
		}else if(rtn== "2"){
			//������ӡ  PDF��ӡ
		    PrintPDFUrl(PDFUrl)
		}
	});
	NextIndex=i+1;    //��һ������¼
	if(NextIndex<AllRecLen){
		EInvPrintDo(CheckedRecs, NextIndex, ErrMsg, PathCode)
	}		
}

////���ܣ�ͨ����˼JS��ӡ
///input�� LocgicType     --ҵ�����ͣ�REG��OP��IP...��
///        billBatchCode  --Ʊ�ݴ���
///        billNo         --Ʊ�ݺ���
///        random         --Ʊ��У����
function PrintByBSJS(LocgicType,billBatchCode,billNo,random)
{
	var billCode=$.m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetEINVDicByCodeAndInd",
		DicType:"BusinessTypeConBillCode",
		DicCode:LocgicType, 
		ind:"5"});
	if((LocgicType=="REG")||(LocgicType=="OP")){
		var moduleId=billCode  ;"140601"			//����Ʊ���������  ��������ͨ������ȡ
	}
	else if(LocgicType=="IP"){
		var moduleId=billCode  ;"140602"
	}
	var param = {
		'billBatchCode':billBatchCode,
		'billNo':billNo,
		'random':random,
		'moduleId':moduleId 
	}
	industry.printElectBill(param, '1.0', false).then(function (data) {
           if(data&&data.result!='S0000'){
                alert(data.message)
           }
   		   console.log("success")
      	   }).fail(function (data) {
            console.log( data)
    });
    ///�����ӡ����
    SavePrintNum(billBatchCode,billNo,UserID)
}

///ͨ����˼���exe��ӡ
/// LocgicType       --ҵ������
/// PrtRowid         --��ƱID
function PrintByBSExe(LocgicType,PrtRowid){
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"PrintElectBill",
		PayAdmType:LocgicType,
		HISPrtRowID:PrtRowid,                     
	},function(rtn){                      
		if(rtn!= "-1"){
			HttpGet(rtn)
		}	
	});
}

///ͨ����˼���exe��ӡ
/// billBatchCode  --Ʊ�ݴ���
/// billNo         --Ʊ�ݺ���
/// random         --У����
function PrintByBSExeNew(billBatchCode,billNo,random){
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"PrintElectBillNew",
		BillBatchCode:billBatchCode,
		BillNo:billNo,
		Random:random                  
	},function(rtn){                      
		if(rtn!= "-1"){
		   HttpGet(rtn)
           ///�����ӡ����
           SavePrintNum(billBatchCode,billNo,UserID)
		}	
	});
}

///ͨ����˼���exe��ӡ
/// LocgicType       --ҵ������
/// PrtRowid         --��ƱID
function PrintDetailsByBSExe(LocgicType,PrtRowid){
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"PrintElectBilllList",
		PayAdmType:LocgicType,
		HISPrtRowID:PrtRowid,                     
	},function(rtn){                      
		if (rtn!="-1"){
			HttpGet(rtn)	
			}
		
	});
}

/**
 * ����
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#readCard").hasClass("l-btn-disabled")) {
		return;
	}
	try {
		
		//var cardType = getValueById("cardType");
		var cardType= $('#cardType').combobox("getValue");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			//setValueById("cardNo", myAry[1]);
			$('#cardNo').val(myAry[1])
			//setValueById("rmarkNo", myAry[5]);
			$('#rmarkNo').val(myAry[5])
			queryBillIUDInfo();
			break;
		case "-200":
			$.messager.alert("��ʾ", "����Ч", "info", function () {
				focusById("readCard");
			});
			break;
		case "-201":
			//setValueById("cardNo", myAry[1]);
			$('#cardNo').val(myAry[1])
			//setValueById("rmarkNo", myAry[5]);
			$('#rmarkNo').val(myAry[5])
			break;
		default:
		}
	} catch (e) {
	}
}
///��ӡ���ӷ�Ʊ��ϸ
function InvEPrintDetails(){
	var rows = $('#tBillIUD').datagrid('getChecked');
	if(rows==null){
		alert("��ѡ��һ����¼���ӡ!");
		return ;
	}
	//alert(rows[0].LocgicType+"&"+rows[0].Invprtrowid)
	
	var PayAdmType=rows[0].LocgicType
	var HISPrtRowID=rows[0].Invprtrowid	
	PrintDetailsByBSExe(PayAdmType,HISPrtRowID)
		
}

function printElectBillListSet(billBatchCode,billNo,random,PageNum) {
	var InputPam=billBatchCode+"^"+billNo+"^"+random;
	var PageNum="0"
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetElectBilllListTotal",
		InputPam:InputPam
		},function(rtn){
        if (rtn!="0")
        {   
        //alert("PageNum:"+rtn)
        	PageNum=rtn;
        	
	    }else 
	    {
		   $.messager.show({title:'��ʾ',msg:'��ȡ����Ʊ����ϸ��ҳ��ʧ�ܣ�',timeout:1000,showType:'slide'});
		}
	});	
	
	var param = {
    	'billBatchCode': billBatchCode,
        'billNo': billNo,
        'random': random,
        'total': PageNum,
        'pageNoBgn':1,
        'pageNoEnd':PageNum
    }
    industry.printElectBillList(param, '1.0', false).then(function (data) {
        if(data&&data.result!='S0000'){
           alert(data.message)
        }
        console.log("success")
        }).fail(function (data) {
            console.log( data)
        });
}

function findPatKeyDowncardNo(e){
	var key = websys_getKey(e);
	if (key == 13) {
		GetRegNoByCardNo();
	}
}

function GetRegNoByCardNo(){
	var CardNo=$('#cardNo').val();
	$.m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetRegNoByCardNo",
		CardNo:CardNo
		},function(rtn){
       		$('#rmarkNo').val(rtn);
       		if(rtn!=""){
				queryBillIUDInfo();
       		}
	});	
}

function HttpGet(URL)
{
	try{
	   var httpRequest; 
       if(window.XMLHttpRequest){    
          httpRequest=new XMLHttpRequest();  // ��IE���������xmlhttprequest���󴴽�
       }else if(window.ActiveXObject){    
          httpRequest=new ActiveXObject("Microsoft.XMLHTTP");  // IE�������activexobject���󴴽�
       }
	   //var httpRequest = new XMLHttpRequest();//��һ������������Ķ���
        httpRequest.open('GET', URL, true);//�ڶ�����������  ���������д��url��  ps:"./Ptest.php?name=test&nameone=testone"
        httpRequest.send();//����������������  ���������д��URL��
        httpRequest.onreadystatechange = function () {
            if (httpRequest.readyState == 4 && httpRequest.status == 200) {
               var jsonData = httpRequest.responseText;//��ȡ������˷��ص�����
               //var JsonObj=jsonData.parseJSON();
               var JsonObj=JSON.parse(jsonData)
               var Database64=JsonObj.data;
               var Data=atob(Database64)     //����Base64   //���Ļ�������룬�˴�ֻ�÷���Codeֵ
               //var DataObj=Data.parseJSON();
               var DataObj=JSON.parse(Data)
               var result=DataObj.result
               console.log( "result"+result );
               if (result=="S0000"){
	               return 0;
	           }else{
		           return -1;   
		       }
            }else{
	           return -1; 
	        }
        }; 
	}catch (e){
		alert("�����쳣"+e.message)
	}

}

///�����ӡ����
function SavePrintNum(IUDBillBatchCode,IUDBillBatchNo,UserId)
{
	$.m({
		ClassName:"BILL.EINV.BL.COM.InvUpDetailsCtl",
		MethodName:"UPDatePrintNumByEinvCode",
		IUDBillBatchCode:IUDBillBatchCode,
		IUDBillBatchNo:IUDBillBatchNo,
		UserId:UserId
		},function(rtn){
       		if(rtn.split("^")[0]!="0"){
				$.messager.show({title:'��ʾ',msg:rtn.split("^")[1],timeout:1000,showType:'slide'});
       		}
	   });	
}

///��ȡ��ӡ����
///w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetPrintNumByEinvCode("123","456")
function GetPrintNum(IUDBillBatchCode,IUDBillBatchNo)  
{
	var PrintNumStr=$.m({
		              ClassName:"BILL.EINV.BL.COM.InvUpDetailsCtl",
		              MethodName:"GetPrintNumByEinvCode",
		              IUDBillBatchCode:IUDBillBatchCode,
		              IUDBillBatchNo:IUDBillBatchNo
	    });
	   if (PrintNumStr.split("^")[0]>=0)
	   {
		   return PrintNumStr.split("^")[0];
	   }else{
		   
           return 0
	   }	
}

function printEInv(url){
	//window.open(url);
	var objShell=new ActiveXObject("WScript.Shell");
	objShell.Run("cmd.exe /c start chrome "+url,0,true);
}

///��ӡС��
///��ӡС��
function PrintDirectInfo()
{
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("��ѡ��һ����¼���ӡС��!");
		return ;
	}
	var billBatchCode=row.EInvCode;
	var billNo=row.EInvSeriNo;
	var random=row.EInvRandom;
	var LocgicType=row.LocgicType
	var HISPrtRowID=row.Invprtrowid;
	
	//����Һ�
	if((LocgicType=="OP")||(LocgicType=="REG")||(LocgicType=="IP")){
	      InvPrintDirect(LocgicType,HISPrtRowID)
	//���	
	}else if(LocgicType=="PE"){
		
		
	}
	
	
	
}

///ͨ��CLODOP��ӡ���������ص�PDFURL
///ʹ�����·�����Ҫ���
///     1.ȷ��csp�����CLODOP�Ѿ�����--do ##class(web.DHCXMLPConfig).LODOPInit(1) 
///     2.ȷ��ϵͳ����CLODOP��4.0���ϰ汾
function PrintPDFUrl(PDFUrl)
{
	var LODOP=getLodop();
	if(LODOP){
		LODOP.PRINT_INIT(""); /*����ϴδ�ӡԪ��*/
		/*
		1---��(��)���ӡ���̶�ֽ�ţ� 
        2---�����ӡ���̶�ֽ�ţ�  
        3---��(��)���ӡ����ȹ̶����߶Ȱ���ӡ���ݵĸ߶�����Ӧ��
        0(������)----��ӡ�����ɲ���������ѡ��򰴴�ӡ��ȱʡ���ã�
		*/
		LODOP.SET_PRINT_PAGESIZE(2,0,0,"A4")  //
		LODOP.ADD_PRINT_PDF(0,0,"100%","100%",PDFUrl)
		LODOP.PREVIEW();  //Ԥ����ӡ
		//LODOP.PRINT();    //ֱ�Ӵ�ӡ
		
	}
	
}


