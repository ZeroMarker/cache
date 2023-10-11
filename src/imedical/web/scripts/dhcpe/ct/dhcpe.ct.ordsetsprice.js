// dhcpe.ct.ordsetsprice.js

var editIndex = undefined;

$(function() {
	InitDefValue();
	InitItemPriceList();
	
	$("#BSavePrice").click(function() {
		BSavePrice_Click();
	});
	
	$("#BBackPrice").click(function() {
		BBackPrice_Click();
	});
	
	$("#IsItemPricing").click(function() {
		ToggleItemPricing();
	});
});

function InitDefValue() {
	var AmtData = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOrdSetsAmountNew",ARCOSRowId:$("#OrdSetsId").val(),Type:"B",LocID:session['LOGON.CTLOCID'],HospID:session['LOGON.HOSPID']}, false);
	$("#OSAmount").numberbox("setValue",AmtData.Amount);   // 套餐原价
	$("#OSPrice").numberbox("setValue",AmtData.ARCOSPrice);   // 套餐定价
	if (AmtData.ItemPriceFlag == "2") {
		// 0 则无   1 套餐定价   2 项目定价
		$("#IsItemPricing").checkbox("setValue",true);
	} else {
		$("#IsItemPricing").checkbox("setValue",false);
	}
	ToggleItemPricing();
}

function InitItemPriceList() {
	$HUI.datagrid("#OrderSetsItem", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.OrderSets",
			QueryName:"SearchPEOSDetailPrice",
			ARCOSRowid:$("#OrdSetsId").val(),
			QueryFlag:"1",
			Type:"B",
			LocID:session['LOGON.CTLOCID'],
			HospID:session['LOGON.HOSPID']
		},		
		columns:[[
			{field:'ARCOSItemRowid', title:'ARCOSItemRowid', hidden:true},  // 项目明细ID
			{field:'ARCIMRowid', title:'ARCIMRowid', hidden:true},  // ARCIM
			{field:'ITMSerialNo', title:'ITMSerialNo', hidden:true},  //
			
			{field:'NO', title:'序号', align:'center'},
			{field:'ARCIMDesc', title:'名称', width:300},
			{field:'ARCOSItemQty', title:'数量', align:'center'},
			{field:'ItemORPrice', title:'原价', align:'center'},
			{field:'ItmPrice', title:'价格', width:100, align:'right',
				formatter: function(value,rowData,rowIndex) {
					return parseFloat(value).toFixed(2);
				},
				editor:{
					type:'numberbox',
					options:{
						min:0,
						precision:2
					}
				}
			}
		]],
		tatle:"套餐项目明细",
		striped:true, // 条纹化
		rownumbers:true,
		pagination:true,
		pageSize:50,
		pageList:[50,100],
		fitColumns:true,
		fit:true,
		border:false,
		singleSelect:true,
		onLoadSuccess: function (data) {
		},
		onClickRow: function (rowIndex, rowData) {  // 选择行事件 
			onEditRow(rowIndex);
		}
	});
}

function onEditRow(index){
	if ($("#IsItemPricing").checkbox("getValue")) {
		if (editIndex != index) {
			if (endEditing()) {
				$('#OrderSetsItem').datagrid('selectRow', index).datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#OrderSetsItem').datagrid('selectRow', editIndex);
			}
		}
	}
}

function endEditing(){
	if (editIndex == undefined) { return true; }
	if ($('#OrderSetsItem').datagrid('validateRow', editIndex)){
		//var ed = $('#OrderSetsItem').datagrid('getEditor', {index:editIndex, field:'ItmPrice'});
		//var val = $(ed.target).numberbox('getValue');
		//$('#OrderSetsItem').datagrid('getRows')[editIndex]['ItmPrice'] = feetypename;
		$('#OrderSetsItem').datagrid('endEdit', editIndex);
		
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function BSavePrice_Click() {
	if (editIndex != undefined) endEditing();
	var AmtData = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOrdSetsAmountNew", ARCOSRowId:$("#OrdSetsId").val(),Type:"B",LocID:session['LOGON.CTLOCID'],HospID:session['LOGON.HOSPID']}, false);
					
	if (AmtData.Amount <= 0) {
		$.messager.alert("提示","医嘱套原价格为零，不需要定价！","info");
		$('#OrderSetsItem').datagrid("reload");
		return false;
	}
	
	if ($("#IsItemPricing").checkbox("getValue")) {
		if (AmtData.ItemPriceFlag == "1") {
			$.messager.confirm("项目定价", "已有套餐定价，进行项目定价会将套餐定价更新，是否继续?", function (r) {
				if (r) {
					SaveOSPrice("Items");
					//$.messager.popover({ msg: "点击了确定", type: 'info' });
				}
			});
		} else {
			SaveOSPrice("Items");
		}
	} else {
		if (AmtData.ItemPriceFlag == "2") {
			$.messager.confirm("套餐定价", "已有定价，进行套餐定价会将项目价格按比例更新，是否继续?", function (r) {
				if (r) {
					SaveOSPrice("Sets");
				}
			});
		} else {
			SaveOSPrice("Sets");
		}
	}
}

function SaveOSPrice(Type) {
	var Flag = false, InStr = "", date;
	if (Type == "Sets") {
		if ($("#OSDate").val() != "") { date = $("#OSDate").val(); }
		else { $.messager.alert("提示","当前日期为空，请刷新界面","info"); return false; }

		if ($("#OSAmount").numberbox('getValue') != "") { ARCOSAmount = $("#OSAmount").numberbox('getValue'); }
		
		if (($("#OSAmt").val() == "") && (($("#OSDiscount").val() == ""))) {
			$.messager.alert("提示","请输入 销售定价 或 销售折扣.","info");
			return false;
		} else {
			if ($("#OSAmt").val() != "") {
				Flag = Price_change("Amt");
			} else {
				Flag = Price_change("Dis");
			}
		}
		if (!Flag) return false;
		
		if ($("#OSAmt").val() != "") { Price = $("#OSAmt").val(); } 
			
		var MoneyF = /(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/;
		if (($("#OSAmt").val() != "") && (!MoneyF.test(Price))) {
			$.messager.alert("提示","请输入正确金额.","info");
			return false;
		}
		
		// 拿到折扣算每个项目金额
		var TotalItemAmt = 0;
		var ItemDiscount = $("#OSDiscount").val();  
		var rowArr = $('#OrderSetsItem').datagrid("getData").rows;
		var InStrArr = [], itemIndex = -1;
		for(var x = 0, arrLen = rowArr.length; x < arrLen; x++) {
			var arcim = rowArr[x].ARCIMRowid;
			var arcimDesc = rowArr[x].ARCIMDesc;
			var itmRowId = rowArr[x].ARCOSItemRowid;
			var itmPrice = (rowArr[x].ItemORPrice * Number(ItemDiscount) / 100).toFixed(2);
			if (itemIndex == -1 && Number(itmPrice) != 0) itemIndex = x;
			
			TotalItemAmt = TotalItemAmt + Number(itmPrice);
			InStrArr.push(itmRowId + "^" + itmPrice);
		}
		
		if (itemIndex != -1 && TotalItemAmt != Price) {
			var disItemPrice = (Number(InStrArr[itemIndex].split("^")[1]) - (TotalItemAmt - Price)).toFixed(2);
			InStrArr[itemIndex] = InStrArr[itemIndex].split("^")[0] + "^" + disItemPrice;
		}
		InStr = InStrArr.join("@");
	} else if (Type == "Items") {
		var rowArr = $('#OrderSetsItem').datagrid("getData").rows;
		var InStr = "";
		for(var x = 0, arrLen = rowArr.length; x < arrLen; x++) {
			var arcim = rowArr[x].ARCIMRowid;
			var arcimDesc = rowArr[x].ARCIMDesc;
			var itmRowId = rowArr[x].ARCOSItemRowid;
			var itmPrice = rowArr[x].ItmPrice;
			if (InStr == "") InStr = itmRowId + "^" + itmPrice;
			else InStr = InStr + "@" + itmRowId + "^" + itmPrice;
		}
	}
	// console.log(InStr);
	if (InStr != "") {
		$.m({  // var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,Date,Date,Price,"");
			ClassName:"web.DHCPE.CT.OrderSets",
			MethodName:"HandleItemPrice",
			InString:InStr,
			Type:Type,
			LocID:session['LOGON.CTLOCID'],
			HospID:session['LOGON.HOSPID']
		}, function(rtn) {
			if (rtn == "0") {
				$.messager.alert("提示","套餐价格更新成功！","info");
				InitDefValue();
				$("#OrderSetsItem").datagrid("reload");
				//var OSExData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
				/*
				$("#OrderSetsList").datagrid("updateRow", {
					index: SelRowIndex,
					row:{
						OSExPrice:Price+"元", // OSExData.OSExPrice,  // 价格
					}
				});
				InitToolbarForARCOSPrice(ARCOSRowid);
				$("#OrderSetsPriceWin").window("close");
				*/
			} else {
				$.messager.alert("提示","套餐价格更新失败！"+rtn,"info");
			}
		});
	}
}

function BBackPrice_Click() {
	$.messager.confirm("提示", "是否还原套餐价格？", function (r){
		if (r) {
			$.m({  // var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,"","","","");
				ClassName:"web.DHCPE.CT.OrderSets",
				MethodName:"UpdateARCOSPriceNew",
				ARCOSRowid:$("#OrdSetsId").val(),
				DateFrom:"",
				DateTo:"",
				Price:""
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.alert("提示","套餐价格还原成功！","info");
					$("#OrderSetsItem").datagrid("reload");
					
					InitDefValue();
					//InitToolbarForARCOSPrice(ARCOSRowid);
				} else {
					$.messager.alert("提示","套餐价格还原失败！"+rtn,"info");
				}
			});	
			ClearPrice();
		}
	});
}

function Price_change(type) {
	var Price = "", Discount = "";
	var userId = session["LOGON.USERID"];
	if ($("#OSAmount").numberbox('getValue') > 0) {
		var ARCOSAmount = $("#OSAmount").numberbox('getValue');
		
		if (type == "Amt") {
			if ($("#OSAmt").val() != "") {
				Price = $("#OSAmt").val();
			}
			if (isNaN(Price)) {
				$.messager.alert("提示","请输入正确价格！","info");
				$("#OSAmt").val("");		
				return false;
			}
			$("#OSDiscount").val("");
			Discount = (Price / ARCOSAmount * 100).toFixed(2);
			$("#OSDiscount").val(Discount);
		} else {	
			if ($("#OSDiscount").val() != "") {
				Discount = $("#OSDiscount").val();
			}
			if (isNaN(Discount)) {
				$.messager.alert("提示","请输入正确折扣！","info");
				$("#OSDiscount").val("");
				return false;
			}
			$("#OSAmt").val("");
			Price = (Discount / 100 * ARCOSAmount ).toFixed(2);
			$("#OSAmt").val(Price);			
		}
		
		var Dflag = UserDiscount(userId,Discount);
		if (Dflag == 0) { ClearPrice();return false; }
		
	} else {
		$.messager.alert("提示","医嘱套原价格为零，不需要定价！","info");
		return false;
	}
	return true;
}

function UserDiscount(userId,Discount) {
	var DFLimit = $.m({ClassName:"web.DHCPE.CT.ChargeLimit", MethodName:"GetOPChargeLimitInfo", UserId:userId, LocID:$("#LocList").val()}, false);
	var DFLimit = DFLimit.split("^")[3];
	// var DFLimit = $.m({ClassName:"web.DHCPE.ChargeLimit", MethodName:"DFLimit", UserId:userId}, false);
	// DFLimit=tkMakeServerCall("web.DHCPE.ChargeLimit","DFLimit",userId);   // 取UserId的最大折扣率
	
	if (DFLimit==0) {
		ClearPrice();
		$.messager.alert("提示", "没有打折权限", "info");
	    return 0;
	}
	if (+DFLimit>+Discount) {
		ClearPrice();
		$.messager.alert("提示", "权限不足,您的折扣权限为:"+DFLimit+"%", "info");
		return 0;
	}
	return 1;
}

function ClearPrice() {
	$("#OSAmt").numberbox("setValue","");
	$("#OSDiscount").numberbox("setValue","");
	//$("#OSAmt").val("");
	//$("#OSDiscount").val("");
}

function ToggleItemPricing() {
	if ($("#IsItemPricing").checkbox("getValue")) {
		$("#OSAmt").val("");
		$("#OSDiscount").val("");
		$("#OSAmt").attr("disabled","disabled");
		$("#OSDiscount").attr("disabled","disabled");
	} else {
		$("#OSAmt").removeAttr("disabled");
		$("#OSDiscount").removeAttr("disabled");
	}
}