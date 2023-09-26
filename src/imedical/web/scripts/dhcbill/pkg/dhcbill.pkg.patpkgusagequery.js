
/*
 * FileName:	dhcbill.pkg.patpkgusagequery.js
 * User:		LiuBingkai
 * Date:		2019-09-19
 * Function:	
 * Description: 患者套餐使用情况查询
 */

$(function (){
	
    
	 ReadCardSet();
	
	//查询
    $("#BtnSearch").click(loadProdBilled);
   	//清屏
    $("#BtnClear").click(Clear_click); 
    
    //登记号回车
    $("#PatientNo").keydown(function(e){ PatientNoKeydownHandler(e);});
    
   // var objPatientNo = document.getElementById("PatientNo");
	//if (objPatientNo) {
		//objPatientNo.onkeydown = PatientNoKeydownHandler;
    //}
     //卡号回车
     $("#CardNo").keydown(function(e){CardNoKeydownHandler(e);});

     //身份证号回车
     $("#CredNo").keydown(function(e){ CredNoKeydownHandler(e);});
  
  	initDgProdBilled();	
	
    initDgProdBilledSub();
   
     
});


//读卡设置
function ReadCardSet()
{
    //卡类型
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
 * 初始化卡类型时卡号和读卡按钮的变化
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
 * 读卡
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
			$.messager.alert("提示", "卡无效", "info", function () {
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


//初始化客户套餐名数据
function initDgProdBilled(){
	
	
	var Columns = [[
		   
			{field:'ProDesc',title:'套餐名称',width:180},
			{field:'ProCreatDate',title:'购买日期',width:100,sortable:true},
			{field:'ProPrice',title:'标准金额',width:100},
			{field:'ProSalesPrice',title:'售价',width:100},
			{field:'ProRefundStandard',title:'退费标准',width:100,sortable:true},
			{field:'ProIssellseparately',title:'是否独立售卖',width:100},
			{field:'ProIsshare',title:'是否共享',width:100,sortable:true},
			{field:'ProCreateTime',title:'购买时间',width:100,sortable:true},
			{field:'ProType',title:'套餐类型',width:100,sortable:true},
			{field:'Prolevel',title:'套餐等级',width:100},
			 {field:'ProCode',title:'套餐编码',width:80},
			{field:'ProUser',title:'经办人',width:100,sortable:true},
			{field:'PatProRowId',title:'客户套餐表Dr',width:100,hidden:true}
			
		
	]];
	
	
	
	$('#dgProdBilled').datagrid({
		fit: true,
		striped: true,
		title: '套餐产品',
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


//重新加载客户套餐名数据
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

//初始化客户套餐医嘱明细和使用情况
function initDgProdBilledSub() {
	var Columns = [[
		{field:'ArcDesc',title:'医嘱项目',width:180},
		{field:'TotalAmount',title:'总金额',width:150,},
		{field:'DiscAmount',title:'折扣金额',width:150,},
		{field:'PatshareAmount',title:'自付金额',width:150,},
		{field:'Quantity',title:'购买数量',width:100,align:'center'},
		{field:'RemainingQty',title:'剩余数量',width:100,align:'center'},
		{field:'PriceperUnit',title:'单价',width:100,},
		{field:'PatsharePrice',title:'自付单价',width:150,},
		{field:'DiscPrice',title:'折扣单价',width:100,},
		{field:'ValidstartDate',title:'开始日期',width:150,align:'center'},
		{field:'ValidendDate',title:'结束日期',width:150,align:'center'}
	]];
	$('#dgProdBilledSub').datagrid({
	    url: $URL,
	    fit:true,
		striped: true,
		title: '套餐产品明细',
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

 
//重新加载客户套餐医嘱明细和使用情况
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






//登记号回车处理函数
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
					
					$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
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
			//$('.patInfoItem').html("获取病人信息失败。");
		}
	});
	
	
	}




//卡号回车处理函数
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
					$.messager.alert("提示", "卡无效", "info", function () {
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
	     

//证件号回车处理函数
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
				alert("未找到该患者，请核实证件号！！");
				ClearData();
				return ;
			}
			ClearData();
			
	    	var ArrList=tkMakeServerCall("web.DHCDocOrderEntry","GetPatientByNo",Data.rows[0].TPAPMINo); //通过登记号返回患者基本信息串
        	SetPatInfoValue(ArrList)//填充数据
			DHCWebD_SetObjValueA("CredNo",Data.rows[0].TPAPERID);
   		})	
	}	
}
//清屏
function Clear_click(){
	ClearData();	
}
//清除数据
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
//根据数组设置数据
function SetPatInfo(InData){
	aData=InData.split("^")
	setValueById("Name",aData[2]);
	setValueById("Sex",aData[3]);
	setValueById("GovernNo",aData[18]);
	//setValueById("CredNo",aData[30]);
}