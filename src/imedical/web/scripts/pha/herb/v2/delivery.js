/**
 * 名称:	 草药管理-草药配送
 * 编写人:	 MaYuqiang
 * 编写日期: 2021-11-24
 */

var ComboWidth = 160 ;
var gUserId = session['LOGON.USERID'] ;	
var gLocId = session['LOGON.CTLOCID'] ;
var SELPRESCNO = gLoadPrescNo ;		// 界面选择的处方号
var SELPRESCFORM = gLoadPrescForm ;	// 界面选择的处方剂型
var SELPAPMI = gPapmi ;				// 界面选择的患者papmi
var HERB_DELIVERY_RET = "";			// 返回值
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
	/* 初始化省 */
	PHA.ComboBox("conProvince", {
		url: PHA_STORE.Province().url,
		width:ComboWidth
	});
	/* 初始化市 */
	PHA.ComboBox("conCity", {
		url: PHA_STORE.City("").url,
		width:ComboWidth,
		mode:"remote"
	});
	/* 初始化区县 */
	PHA.ComboBox("conCityArea", {
		url: PHA_STORE.CityArea("").url,
		width:ComboWidth
	});
	/* 初始化取药方式 */
	PHA.ComboBox("prescTakeMode", {
		url: PHA_HERB_STORE.PrescTakeMode(gLoadPrescForm,gLocId).url,
		width:ComboWidth
	});
	/* 初始化送药时段 */
	PHA.ComboBox("conDeliveryPeriod", {
		data: [{
			RowId: "1",
			Description: $g("全天")
		}, {
			RowId: "2",
			Description: $g("上午")
		}, {
			RowId: "3",
			Description: $g("下午")
		}, {
			RowId: "4",
			Description: $g("晚上")
		}],
		panelHeight: "auto",
		width:ComboWidth
	});
	/* 初始化膏方禁忌 */
	PHA.ComboBox("conTaboo", {
		data: [{
			RowId: "0",
			Description: $g("无")
		}, {
			RowId: "1",
			Description: $g("忌酒")
		}, {
			RowId: "2",
			Description: $g("忌糖")
		}, {
			RowId: "3",
			Description: $g("忌酒,糖")
		}],
		panelHeight: "auto",
		width:ComboWidth
	});
	/* 初始化包装材料 */
	PHA.ComboBox("conPackMaterial", {
		data: [{
			RowId: "1",
			Description: $g("罐装")
		}, {
			RowId: "2",
			Description: $g("复合膜")
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
	/* 取药方式为不快递时收件地址默认是本院发药科室 */
	$("#prescTakeMode").combobox({
		onHidePanel:function(){
			var takeModeId = $("#prescTakeMode").combobox("getValue");
			var takeModeDesc = $("#prescTakeMode").combobox("getText");
			/* 处方当前取药方式 */
			var curTakeModeStr = tkMakeServerCall("PHA.HERB.Com.Method", "GetPostType", SELPRESCNO);
			var curTakeModeDesc = curTakeModeStr.split("^")[2];
			var curTakeModeId = curTakeModeStr.split("^")[0];
			if (FYFlag !== ""){
				if ((curTakeModeDesc == "")||(curTakeModeDesc == "现取现配")){
					if ((takeModeDesc !=="")&&(takeModeDesc !=="现取现配")){
						$.messager.alert('提示', "此处方已经发药：当前取药方式为“空”或者“现取现配”时不能修改为其他取药方式", 'warning');
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
					if ((takeModeDesc == "")||(takeModeDesc == "现取现配")){
						$.messager.alert('提示', "此处方已经发药：当前取药方式不为“空”或者“现取现配”时不能修改为“现取现配”", 'warning');
						$("#prescTakeMode").combobox("setValue",curTakeModeId);
						return;	
					}	
				}
			}
			else {
				if ((curTakeModeDesc == "")&&(takeModeDesc == "现取现配")){
					$.messager.alert('提示', "当前处方取药方式为“空”时无需修改为“现取现配”", 'warning');
					$('#prescTakeMode').combobox('clear');
					return;	
				}
			}
			
			if (takeModeDesc.indexOf("不快递") > -1){
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
        { field: "provinceDesc",title: '省',		width: 100 },
        { field: 'cityId', 		title: 'cityId', 	width: 100, hidden:true},
        { field: "cityDesc", 	title: '市', 		width: 150 },
        { field: "areaId", 		title: 'areaId',	width: 80, 	hidden:true},
        { field: "areaDesc", 	title: '区/县',		width: 120 },
        { field: 'address', 	title: '详细地址', 	width: 150},
        { field: 'receiver', 	title: '收件人', 	width: 80},
        { field: "phoneNo", 	title: '联系电话' ,	width: 120},
        { field: "phdaId", 		title: '地址id',	width: 80, 	hidden:true }
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
		if ((takeModeDesc.indexOf("不快递") > -1)&&(InitFlag == "")){
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

// 取药方式为不快递时初始化收件地址信息
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

/* 保存配送信息 */
function SaveDelivery(){
	var prescTakeMode = $('#prescTakeMode').combobox("getValue");
	/* 现取现配的处方直接走发药程序 */
	/*
	20230125 修改为现取现配的也需要记录取药方式
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
			$.messager.alert('提示', retArr[1], 'warning');
			// 保存地址以及配送信息失败时不关闭窗体，用户可以继续操作
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

/* 获取收货地址信息 */
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

/* 获取包装信息，以及其他配送信息 */
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
