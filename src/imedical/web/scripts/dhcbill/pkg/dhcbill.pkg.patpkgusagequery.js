
/*
 * FileName:	dhcbill.pkg.patpkgusagequery.js
 * User:		LiuBingkai
 * Date:		2019-09-19
 * Function:	
 * Description: �����ײ�ʹ�������ѯ
 */

$(function (){
	
    
	 ReadCardSet();
	
	//��ѯ
    $("#BtnSearch").click(loadProdBilled);
   	//����
    $("#BtnClear").click(Clear_click); 
    
    //�ǼǺŻس�
    $("#PatientNo").keydown(function(e){ PatientNoKeydownHandler(e);});
    
   // var objPatientNo = document.getElementById("PatientNo");
	//if (objPatientNo) {
		//objPatientNo.onkeydown = PatientNoKeydownHandler;
    //}
     //���Żس�
     $("#CardNo").keydown(function(e){CardNoKeydownHandler(e);});

     //���֤�Żس�
     $("#CredNo").keydown(function(e){ CredNoKeydownHandler(e);});
  
  	initDgProdBilled();	
	
    initDgProdBilledSub();
   
     
});


//��������
function ReadCardSet()
{
    //������
	$HUI.combobox("#CardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onLoadSuccess: function () {
			var cardType = $(this).combobox("getValue");
			initReadCard(cardType);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});

$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
}

/**
 * ��ʼ��������ʱ���źͶ�����ť�ı仯
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			disableById("btn-readCard");
			$("#cardNo").attr("readOnly", false);
			focusById("cardNo");
		} else {
			enableById("btn-readCard");
			setValueById("cardNo", "");
			$("#cardNo").attr("readOnly", true);
			focusById("btn-readCard");
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
}

/**
 * ����
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").linkbutton("options").disabled) {
		return;
	}
	try {
		var cardType = getValueById("cardType");
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
			setValueById("CardNo", myAry[1]);
			setValueById("PatientNo", myAry[5]);
			setValueById("patientId",myAry[4]);
			getPatDetail(myAry[4]);
			break;
		case "-200":
			$.messager.alert("��ʾ", "����Ч", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("CardNo", myAry[1]);
			setValueById("PatientNo", myAry[5]);
			setValueById("patientId",myAry[4]);
			getPatDetail(myAry[4]);
			break;
		default:
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
}


//��ʼ���ͻ��ײ�������
function initDgProdBilled(){
	
	
	var Columns = [[
		   
			{field:'ProDesc',title:'�ײ�����',width:180},
			{field:'ProCreatDate',title:'��������',width:100,sortable:true},
			{field:'ProPrice',title:'��׼���',width:100},
			{field:'ProSalesPrice',title:'�ۼ�',width:100},
			{field:'ProRefundStandard',title:'�˷ѱ�׼',width:100,sortable:true},
			{field:'ProIssellseparately',title:'�Ƿ��������',width:100},
			{field:'ProIsshare',title:'�Ƿ���',width:100,sortable:true},
			{field:'ProCreateTime',title:'����ʱ��',width:100,sortable:true},
			{field:'ProType',title:'�ײ�����',width:100,sortable:true},
			{field:'Prolevel',title:'�ײ͵ȼ�',width:100},
			 {field:'ProCode',title:'�ײͱ���',width:80},
			{field:'ProUser',title:'������',width:100,sortable:true},
			{field:'PatProRowId',title:'�ͻ��ײͱ�Dr',width:100,hidden:true}
			
		
	]];
	
	
	
	$('#dgProdBilled').datagrid({
		fit: true,
		striped: true,
		title: '�ײͲ�Ʒ',
		iconCls: 'icon-paper-table',
		headerCls: 'panel-header-gray',
		rownumbers: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		onBeforeLoad:function(param){
			//param.ResultSetType = 'array';
		},
		columns: Columns,
		onLoadSuccess: function (data) {
			
		},
		onSelect:function(rowIndex, rowData){
			//alert("PatProRowId="+rowData.PatProRowId)
			setValueById("PatProRowId",rowData.PatProRowId)
			loadProdBilledSub();
			}
		
		
	});	
	
	
	
}


//���¼��ؿͻ��ײ�������
function loadProdBilled(){
	$('#dgProdBilled').datagrid({
		url:$URL,
		queryParams:{
			ClassName:"BILL.PKG.BL.PatientBill",
			QueryName:"FindProductInfoByPatDr",
            PatDr:getValueById("patientId"),
	    	pageSize:20	 
		}
	})
}

//��ʼ���ͻ��ײ�ҽ����ϸ��ʹ�����
function initDgProdBilledSub() {
	var Columns = [[
		{field:'ArcDesc',title:'ҽ����Ŀ',width:180},
		{field:'TotalAmount',title:'�ܽ��',width:150,},
		{field:'DiscAmount',title:'�ۿ۽��',width:150,},
		{field:'PatshareAmount',title:'�Ը����',width:150,},
		{field:'Quantity',title:'��������',width:100,align:'center'},
		{field:'RemainingQty',title:'ʣ������',width:100,align:'center'},
		{field:'PriceperUnit',title:'����',width:100,},
		{field:'PatsharePrice',title:'�Ը�����',width:150,},
		{field:'DiscPrice',title:'�ۿ۵���',width:100,},
		{field:'ValidstartDate',title:'��ʼ����',width:150,align:'center'},
		{field:'ValidendDate',title:'��������',width:150,align:'center'}
	]];
	$('#dgProdBilledSub').datagrid({
	    url: $URL,
	    fit:true,
		striped: true,
		title: '�ײͲ�Ʒ��ϸ',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		onBeforeLoad:function(param){
			//param.ResultSetType = 'array';
		},
		columns: Columns,
		rowStyler:function(index,row){
			 if(row.RemainingQty ==0)
			 {
			  return 'color:red;'
			 }
			 },
		onLoadSuccess: function (data) {
			
		}
	});		
}

 
//���¼��ؿͻ��ײ�ҽ����ϸ��ʹ�����
function loadProdBilledSub(){
	
	//alert("hh="+getValueById("PatProRowId"))
	$('#dgProdBilledSub').datagrid({
		url:$URL,
		queryParams:{
			ClassName:"BILL.PKG.BL.PatientBill",
			QueryName:"FindPatProductOrderDetails",
            PatProRowId:getValueById("PatProRowId"),
            HospDr:session['LOGON.HOSPID'],
            PatSta:"",
            ExpStr:"",
	    	pageSize:20	 
		}
	})
}






//�ǼǺŻس�������
function PatientNoKeydownHandler(e){
	

	var key = websys_getKey(e);
	
	if (key == 13) 
	{
        getPatInfo();
	}
		
	      
}

function getPatInfo() {
	var patientNo = getValueById("PatientNo");
	if (patientNo) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: patientNo
		}, function(patientNo) {
			setValueById("PatientNo", patientNo);
			var expStr = "";
			$.m({
				ClassName: "web.DHCOPCashierIF",
				MethodName: "GetPAPMIByNo",
				PAPMINo: patientNo,
				ExpStr: expStr
			}, function(papmi) {
				if (!papmi) {
					
					$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
					focusById("PatientNo");
				}else {
					setValueById("patientId", papmi);
					getPatDetail(papmi);
				}
			});
		});
	}
}


function getPatDetail(patientId)
{
	
	$.m({
		ClassName: 'web.DHCOPCashierIF',
		MethodName: 'GetPatientByRowId',
		PAPMI: patientId,
		ExpStr: ""
	}, function (rtn) {
		if (rtn != '') {
			//alert("rtn="+rtn)
			SetPatInfo(rtn);
			loadProdBilled();
		} else {
			//$('.patInfoItem').html("��ȡ������Ϣʧ�ܡ�");
		}
	});
	
	
	}




//���Żس�������
function CardNoKeydownHandler(e){
		try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById("CardNo");
			if (!cardNo) {
				return;
			}
			var cardType = getValueById("CardType");
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split("^");
			var cardTypeDR = cardTypeAry[0];
			var cardAccountRelation = cardTypeAry[24];
			var securityNo = "";
			var myRtn = "";
			if((cardAccountRelation == "CA") || (cardAccountRelation == "CL")){
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, securityNo, "");
			}else {
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
			}
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("CardNo", myAry[1]);
				setValueById("PatientNo", myAry[5]);
				setValueById("patientId",myAry[4]);
				getPatDetail(myAry[4]);
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("��ʾ", "����Ч", "info", function () {
						focusById("CardNo");
					});
				}, 10);
				break;
			case "-201":
				setValueById("CardNo", myAry[1]);
				setValueById("PatientNo", myAry[5]);
				setValueById("patientId",myAry[4]);
				getPatDetail(myAry[4]);
				break;
			default:
			}
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
		 
   }
	     

//֤���Żس�������
function CredNoKeydownHandler(e){
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);

	//var PatientID = websys_getSrcElement(e);
	DOPInfo_ReadInfoType = 0;
	if (key == 13) {
	    var CredNo= DHCWebD_GetObjValue("CredNo");
		$.cm({
			ClassName:"web.DHCBL.Patient.DHCPatient",
			QueryName:"SelectByPAPERID",
			SPAPERID:CredNo,
			SPAPERName:"",
			SPAPMINo:"",
			CardNo:""
		},function(Data){
			if(Data.rows.length==0)
			{
				alert("δ�ҵ��û��ߣ����ʵ֤���ţ���");
				ClearData();
				return ;
			}
			ClearData();
			
	    	var ArrList=tkMakeServerCall("web.DHCDocOrderEntry","GetPatientByNo",Data.rows[0].TPAPMINo); //ͨ���ǼǺŷ��ػ��߻�����Ϣ��
        	SetPatInfoValue(ArrList)//�������
			DHCWebD_SetObjValueA("CredNo",Data.rows[0].TPAPERID);
   		})	
	}	
}
//����
function Clear_click(){
	ClearData();	
}
//�������
function ClearData(){
	DHCWebD_SetObjValueA("PatId","");	
	DHCWebD_SetObjValueA("PatientNo","");
	DHCWebD_SetObjValueA("Name","");
	DHCWebD_SetObjValueA("Sex","");
	DHCWebD_SetObjValueA("CardNo","");
	DHCWebD_SetObjValueA("GovernNo","");
	DHCWebD_SetObjValueA("CredNo","");
	DHCWebD_SetObjValueA("PatBillId","");
	DHCWebD_SetObjValueA("OrderDetails","");
	DHCWebD_SetObjValueA("OrderId","");
	
	
}
//����������������
function SetPatInfo(InData){
	aData=InData.split("^")
	setValueById("Name",aData[2]);
	setValueById("Sex",aData[3]);
	setValueById("GovernNo",aData[18]);
	//setValueById("CredNo",aData[30]);
}