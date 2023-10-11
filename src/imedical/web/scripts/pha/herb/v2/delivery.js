/**
 * ����:	 ��ҩ����-��ҩ����
 * ��д��:	 MaYuqiang
 * ��д����: 2021-11-24
 */

var ComboWidth = 160 ;
var gUserId = session['LOGON.USERID'] ;	
var gLocId = session['LOGON.CTLOCID'] ;
var SELPRESCNO = gLoadPrescNo ;		// ����ѡ��Ĵ�����
var SELPRESCFORM = gLoadPrescForm ;	// ����ѡ��Ĵ�������
var SELPAPMI = gPapmi ;				// ����ѡ��Ļ���papmi
var HERB_DELIVERY_RET = "";			// ����ֵ
var FYFlag = tkMakeServerCall("PHA.HERB.Com.Data","GetPrescFYInfo",gLoadPrescNo)
$(function () {
	InitDict();
	InitGridDyAddress();
	InitBaseInfo("");
	ReLoadDeliveryWin();
	$('#btnSaveDelivery').on("click",SaveDelivery);
	$('#btnCancelDelivery').on("click",CancelDelivery);
})
 
function InitDict(){
	PHA.DateBox("deliveryDate", {});
	/* ��ʼ��ʡ */
	PHA.ComboBox("conProvince", {
		url: PHA_STORE.Province().url,
		width:ComboWidth
	});
	/* ��ʼ���� */
	PHA.ComboBox("conCity", {
		url: PHA_STORE.City("").url,
		width:ComboWidth,
		mode:"remote"
	});
	/* ��ʼ������ */
	PHA.ComboBox("conCityArea", {
		url: PHA_STORE.CityArea("").url,
		width:ComboWidth
	});
	/* ��ʼ��ȡҩ��ʽ */
	PHA.ComboBox("prescTakeMode", {
		url: PHA_HERB_STORE.PrescTakeMode(gLoadPrescForm,gLocId).url,
		width:ComboWidth
	});
	/* ��ʼ����ҩʱ�� */
	PHA.ComboBox("conDeliveryPeriod", {
		data: [{
			RowId: "1",
			Description: $g("ȫ��")
		}, {
			RowId: "2",
			Description: $g("����")
		}, {
			RowId: "3",
			Description: $g("����")
		}, {
			RowId: "4",
			Description: $g("����")
		}],
		panelHeight: "auto",
		width:ComboWidth
	});
	/* ��ʼ���෽���� */
	PHA.ComboBox("conTaboo", {
		data: [{
			RowId: "0",
			Description: $g("��")
		}, {
			RowId: "1",
			Description: $g("�ɾ�")
		}, {
			RowId: "2",
			Description: $g("����")
		}, {
			RowId: "3",
			Description: $g("�ɾ�,��")
		}],
		panelHeight: "auto",
		width:ComboWidth
	});
	/* ��ʼ����װ���� */
	PHA.ComboBox("conPackMaterial", {
		data: [{
			RowId: "1",
			Description: $g("��װ")
		}, {
			RowId: "2",
			Description: $g("����Ĥ")
		}],
		panelHeight: "auto",
		width:ComboWidth
	});	
	
	$("#conProvince").combobox({
		onChange:function(){
			$('#conCityArea').combobox('clear');
			var provId = $("#conProvince").combobox("getValue");
			PHA.ComboBox("conCity", {
				url: PHA_STORE.City(provId).url
			});
		}
	});
	
	$("#conCity").combobox({
		onChange:function(){
			var cityId = $("#conCity").combobox("getValue");
			PHA.ComboBox("conCityArea", {
				url: PHA_STORE.CityArea(cityId).url
			});

		}
	});
	/* ȡҩ��ʽΪ�����ʱ�ռ���ַĬ���Ǳ�Ժ��ҩ���� */
	$("#prescTakeMode").combobox({
		onHidePanel:function(){
			var takeModeId = $("#prescTakeMode").combobox("getValue");
			var takeModeDesc = $("#prescTakeMode").combobox("getText");
			/* ������ǰȡҩ��ʽ */
			var curTakeModeStr = tkMakeServerCall("PHA.HERB.Com.Method", "GetPostType", SELPRESCNO);
			var curTakeModeDesc = curTakeModeStr.split("^")[2];
			var curTakeModeId = curTakeModeStr.split("^")[0];
			if (FYFlag !== ""){
				if ((curTakeModeDesc == "")||(curTakeModeDesc == "��ȡ����")){
					if ((takeModeDesc !=="")&&(takeModeDesc !=="��ȡ����")){
						$.messager.alert('��ʾ', "�˴����Ѿ���ҩ����ǰȡҩ��ʽΪ���ա����ߡ���ȡ���䡱ʱ�����޸�Ϊ����ȡҩ��ʽ", 'warning');
						if((curTakeModeId == 0)||(curTakeModeId == "")){
							$('#prescTakeMode').combobox('clear');
						}
						else {
							$("#prescTakeMode").combobox("setValue",curTakeModeId);
						}
						return;	
					}	
				}
				else {
					if ((takeModeDesc == "")||(takeModeDesc == "��ȡ����")){
						$.messager.alert('��ʾ', "�˴����Ѿ���ҩ����ǰȡҩ��ʽ��Ϊ���ա����ߡ���ȡ���䡱ʱ�����޸�Ϊ����ȡ���䡱", 'warning');
						$("#prescTakeMode").combobox("setValue",curTakeModeId);
						return;	
					}	
				}
			}
			else {
				if ((curTakeModeDesc == "")&&(takeModeDesc == "��ȡ����")){
					$.messager.alert('��ʾ', "��ǰ����ȡҩ��ʽΪ���ա�ʱ�����޸�Ϊ����ȡ���䡱", 'warning');
					$('#prescTakeMode').combobox('clear');
					return;	
				}
			}
			
			if (takeModeDesc.indexOf("�����") > -1){
				InitNotPostAddress();
			}
			else {
				InitBaseInfo("Y");
			}

		}
	});
}


function InitGridDyAddress() {
	var columns = [[
        { field: "provinceId", 	title: 'provinceId',width: 80, hidden:true},
        { field: "provinceDesc",title: 'ʡ',		width: 100 },
        { field: 'cityId', 		title: 'cityId', 	width: 100, hidden:true},
        { field: "cityDesc", 	title: '��', 		width: 150 },
        { field: "areaId", 		title: 'areaId',	width: 80, 	hidden:true},
        { field: "areaDesc", 	title: '��/��',		width: 120 },
        { field: 'address', 	title: '��ϸ��ַ', 	width: 150},
        { field: 'receiver', 	title: '�ռ���', 	width: 80},
        { field: "phoneNo", 	title: '��ϵ�绰' ,	width: 120},
        { field: "phdaId", 		title: '��ַid',	width: 80, 	hidden:true }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.HERB.Logistics.Query',
            QueryName: 'GetPatAddressList',
			papmi: SELPAPMI
        },      
        columns: columns,
        toolbar: [],
        border: false ,
        isTopZindex:true ,
        bodyCls:'panel-header-gray',
        onClickRow:function(rowIndex,rowData){
	        ClearDeliveryInfo();
	    	var provinceId = rowData.provinceId ;
	    	var cityId = rowData.cityId||'';
	    	var areaId = rowData.areaId||'';
	    	var address = rowData.address||'';
	    	var receiver = rowData.receiver||'';
	    	var phoneNo = rowData.phoneNo||'';
	    	if ((provinceId!=="")&&(provinceId!=="0")){
	    		$('#conProvince').combobox('select',provinceId);
	    	}
	    	if ((cityId !== "")&&(cityId !== "0")){
	        	$('#conCity').combobox('select',cityId);
	    	}
	    	if ((areaId !== "")&&(areaId !== "0")){
	        	$('#conCityArea').combobox('select',areaId);
	    	}
	    	$('#conAddressDetail').val(address)
	    	$('#conReceiveUser').val(receiver)
	    	$('#conPhoneNo').val(phoneNo)
		}   
    };
	PHA.Grid("gridDeliveryAddress", dataGridOption);
}

function InitBaseInfo(InitFlag){
	var prescnoInfo = tkMakeServerCall("PHA.HERB.Logistics.Query","GetPrescInfoStr",SELPRESCNO);
	var mainInfo = prescnoInfo.split("^")
	var phplId = mainInfo[2];
	$("#deliveryPrescNo").val(SELPRESCNO);
	if (phplId == "0"){
		ClearDeliveryInfo();
		var receiver = mainInfo[0];
		var phoneNo = mainInfo[1];
		$("#deliveryDate").datebox("setValue", 't+1');	
		$("#conReceiveUser").val(receiver);
		$("#conPhoneNo").val(phoneNo);
		var postTypeStr = tkMakeServerCall("PHA.HERB.Com.Method","GetPostType",SELPRESCNO);
		var prescTakeMode = postTypeStr.split("^")[0]
		var takeModeDesc = postTypeStr.split("^")[2]
		//console.log("prescTakeMode:"+prescTakeMode+" takeModeDesc:"+takeModeDesc+" InitFlag:"+InitFlag)
		if ((takeModeDesc.indexOf("�����") > -1)&&(InitFlag == "")){
				InitNotPostAddress();
		}
		if ((prescTakeMode !== "0")&&(InitFlag == "")){
			$("#prescTakeMode").combobox("setValue",prescTakeMode);
		}
	}
	else {
		var DeliveryData = tkMakeServerCall("PHA.HERB.Logistics.Query","GetLogisticsInfo",SELPRESCNO)	
		var DeliveryOBJ = JSON.parse(DeliveryData);
		var prescTakeMode = DeliveryOBJ.prescTakeMode;
		var provienceId = DeliveryOBJ.ProvinceId;
		var cityId = DeliveryOBJ.CityId;
		var cityAreaId = DeliveryOBJ.CityAreaId;
		var addressDetail = DeliveryOBJ.AddressDetail;
		var deliveryDate = DeliveryOBJ.DeliveryDate;
		var deliveryPeriod = DeliveryOBJ.DeliveryPeriod;
		var receiveUser = DeliveryOBJ.ReceiveUser;
		var phoneNo = DeliveryOBJ.PhoneNo;
		var taboo = DeliveryOBJ.Taboo;
		var packMaterial = DeliveryOBJ.PackMaterial;
		var processFlag = DeliveryOBJ.ProcessFlag;
		var deliveryNote = DeliveryOBJ.DeliveryNote;
		if ((prescTakeMode !== "0")&&(InitFlag == "")){
			$("#prescTakeMode").combobox("setValue",prescTakeMode);
		}
		if (provienceId !== "0"){
			$("#conProvince").combobox("setValue",provienceId);
		}
		if (cityId !== "0"){
			$("#conCity").combobox("setValue",cityId);
		}
		if (cityAreaId !== "0"){
			$("#conCityArea").combobox("setValue",cityAreaId);
		}
		$("#conAddressDetail").val(addressDetail);
		$("#deliveryDate").datebox("setValue", deliveryDate);
		if (deliveryPeriod !== "0"){	
			$("#conDeliveryPeriod").combobox("setValue",deliveryPeriod);
		}
		$("#conReceiveUser").val(receiveUser);
		$("#conPhoneNo").val(phoneNo);
		if (taboo != ""){
			$("#conTaboo").combobox("setValue",taboo);
		}
		if (packMaterial !== "0"){
			$("#conPackMaterial").combobox("setValue",packMaterial);
		}
		if (processFlag == "Y"){
			$("#chkProcessFlag").checkbox("check",true)
		}
		else {
			$('#chkProcessFlag').checkbox("uncheck",true) ;		
		}
		$("#conDeliveryNote").val(deliveryNote);
		
	}
	
}

// ȡҩ��ʽΪ�����ʱ��ʼ���ռ���ַ��Ϣ
function InitNotPostAddress(){
	ClearDeliveryInfo();
	var hospAddressJson = tkMakeServerCall("PHA.HERB.Com.Method", "GetHospAddressInfo", gLocId);
	var hospAddressObj = JSON.parse(hospAddressJson);
	var hospProvId = hospAddressObj.HospProvId;
	var hospCityId = hospAddressObj.HospCityId;
	var hospAreaId = hospAddressObj.HospAreaId;
	var hospAddress = hospAddressObj.HospAddress;
	var receiver = hospAddressObj.ReceiveUser;
	var phoneNo = hospAddressObj.PhoneNo;
	if ((hospProvId!=="")&&(hospProvId!=="0")){
		$('#conProvince').combobox('select',hospProvId);
	}
	if ((hospCityId !== "")&&(hospCityId !== "0")){
    	$('#conCity').combobox('select',hospCityId);
	}
	if ((hospAreaId !== "")&&(hospAreaId !== "0")){
    	$('#conCityArea').combobox('select',hospAreaId);
	}
	$('#conAddressDetail').val(hospAddress)
	$('#conReceiveUser').val(receiver)
	$('#conPhoneNo').val(phoneNo)
}

function ReLoadDeliveryWin(){
	
}

function ClearDeliveryInfo(){
	$('#conProvince').combobox('clear');
	$('#conCity').combobox('clear');
	$('#conCityArea').combobox('clear');
	$('#conAddressDetail').val('');
	$('#conReceiveUser').val('');
	$('#conPhoneNo').val('');
}

/* ����������Ϣ */
function SaveDelivery(){
	var prescTakeMode = $('#prescTakeMode').combobox("getValue");
	/* ��ȡ����Ĵ���ֱ���߷�ҩ���� */
	/*
	20230125 �޸�Ϊ��ȡ�����Ҳ��Ҫ��¼ȡҩ��ʽ
	if ((prescTakeMode == "1")||(prescTakeMode == "")){
		HERB_DELIVERY_RET = "1"	
		top.$("#PHA_HERB_V2_DELIVERY").window("close");	 
	    return ;
	}
	*/
	var addressJson = GetDeliveryJson() ;
	var packageJson = GetPackageJson() ;
	$.m({
		ClassName: "PHA.HERB.Logistics.Save",
		MethodName: "SaveLogistics",
		pPrescNo: SELPRESCNO,
        pAddressJson: JSON.stringify(addressJson) ,
        pPackageJson: JSON.stringify(packageJson) 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			HERB_DELIVERY_RET = retData
			$.messager.alert('��ʾ', retArr[1], 'warning');
			// �����ַ�Լ�������Ϣʧ��ʱ���رմ��壬�û����Լ�������
			//top.$("#PHA_HERB_V2_DELIVERY").window("close");	 
			return ;
        }
        else {
	        HERB_DELIVERY_RET = "1"
	    	top.$("#PHA_HERB_V2_DELIVERY").window("close");	 
	    	return ; 
	    }
	});
	
	
}

/* ��ȡ�ջ���ַ��Ϣ */
function GetDeliveryJson(){
	return {
        provinceId: $("#conProvince").combobox("getValue")||'',
        cityId: $("#conCity").combobox("getValue")||'',
		cityAreaId: $("#conCityArea").combobox("getValue")||'',
		address: $("#conAddressDetail").val()||'',
		receiver: $("#conReceiveUser").val()||'',
		phoneNo: $("#conPhoneNo").val()||''
    };
}

/* ��ȡ��װ��Ϣ���Լ�����������Ϣ */
function GetPackageJson(){
	var isprocess = "N";
	if( $("#chkProcessFlag").is(':checked') ){
		isprocess = "Y";
	}
	return {
        toDeliverDate: $("#deliveryDate").datebox('getValue')||'' ,
		deliveryPeriod: $('#conDeliveryPeriod').combobox("getValue")||'',
		taboo: $('#conTaboo').combobox("getValue")||'',
		packMaterial: $("#conPackMaterial").combobox("getValue")||'',
		isProcess: isprocess,
		deliveryNote: $("#conDeliveryNote").val()||'',
		prescTakeMode: $("#prescTakeMode").combobox("getValue")||'',
		sendUserId: gUserId,
		phaLocId: gLocId
    };
}

function CancelDelivery(){
	HERB_DELIVERY_RET = 0 ;
	top.$("#PHA_HERB_V2_DELIVERY").window("close");	
	return ;
}
