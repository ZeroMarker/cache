/**
 * @模块:     煎药室-患者领药(领药流程之后不需走装箱操作)
 * @编写日期: 2021-02-17
 * @编写人:   MaYuqiang
 */
var decCode = "FF";	// 煎药流程标识
var locId = session['LOGON.CTLOCID'];
var opUser = session['LOGON.USERID'];
var queryFlag = ""
$(function () {
	InitDict();
	InitGridPrescList();
	// 处方号回车事件
	$("#txtPrescNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo = $.trim($("#txtPrescNo").val());
			if (prescNo != "") {
				Query("Y");
			}
		}
	})
	// 登记号回车事件
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				Query("Y");
			}
		}
	});
	// 卡号回车事件
	$("#txtCardNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardNo = $.trim($("#txtCardNo").val());
			if (cardNo != "") {
				BtnReadCardHandler();
			}
		}
	})
	
	$('#readCard').on('click', BtnReadCardHandler) ;
	
});

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	if(ComPropData.PrescView=="Y") { 
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//显示处方预览panel
	};
	PHA.ComboBox("cmbDecLoc", {
		width: '120',
		url: PHA_DEC_STORE.DecLoc().url,
		onLoadSuccess: function() {
			$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		}  
	});
	PHA.ComboBox("cmbPhaLoc", {
		width: '120',
		url: PHA_DEC_STORE.Pharmacy("").url,
		onLoadSuccess: function() {
			$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		}
	});
	
	// 就诊类型
    PHA.ComboBox('cmbAdmType', {
        width: '155',
        data: [
            { RowId: 'O', Description: $g('门诊') },
            { RowId: 'I', Description: $g('住院') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	//卡类型
	PHA.ComboBox("cmbCardType", {
		width: '110',
		url: PHA_DEC_STORE.CardType("").url,
		onLoadSuccess: function(data) {
			var data = $("#cmbCardType").combobox("getData")
			$.each(data, function(key, val){
				var defaultflag = val.RowId.split("^")[8];
				if(defaultflag=="Y"){
					$("#cmbCardType").combobox("setValue", val.RowId);
				}
			})	
		} 
	});
	//设置默认值
	$.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.OUTDISP", 
		AppCode:""
		}, function(AppPropData){
			$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
			$('#timeStart').timespinner('setValue', "00:00:00");
			$('#timeEnd').timespinner('setValue', "23:59:59");
		});
}
/**
 * 初始化扫码发放处方列表
 * @method InitGridPrescList
 */
function InitGridPrescList() {
	var columns = [[ 
		{
			field:'pdCheck',
			checkbox: true	
		},
		{
			field:'curProDesc', 	
			title:'当前流程',	
			align:'left', 
			width: 70, 
			styler:function(value,row,index){
				if (row.curProDesc == "打签") {
                	return 'background-color:#a849cb;color:white;';
                    }
                else if (row.curProDesc == "发放") {
					return 'background-color:#6557d3;color:white;';
                }
                else {
	                
	            }
			}
		},
		{
			field:'dispNum',	
			title:'发放付数',		
			align:'right', 
			width: 80
		},
		{	field:'pdpmId',		
			title:'pdpmId',		
			hidden:'true',	
			width: 50
		},
		{
			field:'patNo',		
			title:'登记号',		
			align:'left', 
			width: 100
		}, 
		{
			field:'patName',	
			title:'患者姓名',	
			align:'left', 
			width: 80
		}, 
		{
			field:'prescNo', 	
			title:'处方号',	  	
			align:'left', 
			width: 130
		},
		{
			field: 'dispedNum',	
			title: '已发放付数',	
			align: 'right', 
			width: 90
		},
		{
			field: 'toDispNum',	
			title: '待发放付数',	
			align: 'right', 
			width: 90
		},
		{
			field:'preFacTor',	
			title:'总付数',		
			align:'right', 
			width: 60
		}, 
		{
			field:'deptLocDesc', 	
			title:'科室',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'decTypeDesc', 	
			title:'煎药类型', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'收方时间', 	
			align:'left', 
			width: 160
		},
		{
			field:'preCount',	
			title:'味数',		
			align:'right', 
			width: 45
		}, 
		{
			field:'preForm',	
			title:'处方剂型',	
			align:'left', 
			width: 80
		}, 
		{
			field:'preEmFlag',	
			title:'是否加急',	
			align:'left', 
			width: 65
		}, 
		{
			field:'phaLocDesc',	
			title:'调剂科室',	
			align:'left', 
			width: 100
		}, 
		{
			field:'operUserName',	
			title:'调剂人',		
			align:'left', 
			width: 80
		},
		{
			field:'operDate',	
			title:'调剂时间',	
			align:'left', 
			width: 160
		},
		{
			field:'cookCost',	
			title:'煎药费',		
			align:'left', 
			width: 150,
			nowrap:false
		},
		{
			field:'allDispFlag',	
			title:'全部发放标志',		
			align:'left', 
			width: 150,
			hidden:true
		}
	]];
	var dataGridOption = {
		url: $URL,
		toolbar: "#gridPatReveiveBar",
		columns: columns,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false,
		rownumbers: true,		
		queryParams: {
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryPatPrescList",
			pJsonStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescNo = rowData.prescNo;
			ColPrescView(prescNo);
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "dispNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'dispNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function(data) {
			if(data.rows.length==0){ 
				if (queryFlag != ""){
					PHA.Popover({showType: "show", msg: "未检索到待领取的处方信息，请核实后重试！", type: 'alert'});
				}
				return; 
			}
			var row = data.rows[0];
			var prescNo = row.prescNo;
			ColPrescView(prescNo);
			$('#gridPrescList').datagrid('selectAll');
			//var dataTotal = $("#gridPrescList").datagrid("getData").total ;
		}
	};
	PHA.Grid("gridPrescList", dataGridOption);
}

/**
 * 扫码发放：查询待发放数据
 * @method Query
 */
function Query(flag){
	var patNo =  $('#txtPatNo').val();
	var cardNo = $('#txtCardNo').val() ;
	if ((cardNo !=="")&&(patNo == "")){
		return ;
	}
	var prescNo = $('#txtPrescNo').val() ;
	if ((patNo == "")&&(cardNo == "")&&(prescNo == "")){
		PHA.Popover({ showType: "show",	msg: "处方号、登记号、卡号至少填写一个才可以检索处方信息！", type: 'alert'});
		return;
	}
	queryFlag = flag
	$('#gridPrescList').datagrid('uncheckAll');
	ColPrescView("");
	var pJson = GetParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}

/**
 * 获取扫码发放界面元素值
 * @method GetQueryParamsJson
 */
function GetParamsJson() {
    return {
		startDate : $("#dateStart").datebox('getValue')||'' ,
		endDate : $("#dateEnd").datebox('getValue')||'' ,
		startTime : $('#timeStart').timespinner('getValue')||'' ,
		endTime : $('#timeEnd').timespinner('getValue')||'' ,
		prescNo : $('#txtPrescNo').val(),
		patNo : $('#txtPatNo').val(),
		phaLocId : $('#cmbPhaLoc').combobox("getValue")||'' ,
		decLocId : $('#cmbDecLoc').combobox("getValue")||'' ,
		admType : $('#cmbAdmType').combobox("getValue")||'' ,
		logonLocId : locId

    };
}

//读卡
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtPatNo"
	}
	PHA_COM.ReadCard(readcardoptions, QueryByCardNo("Y")) ; 
	
}

function QueryByCardNo(Flag){
	var cardNo = $('#txtCardNo').val();
	var patNo = $('#txtPatNo').val();
	if ((patNo == "")&&(cardNo == "")){
		PHA.Popover({ showType: "show",	msg: "未获取到卡号信息，请重试！", type: 'alert'});
		return;
	}
	
	setTimeout(function(){
		Query("Y") ; 
	},0)	
	
}

/**
 * 确认发放
 * @method dispPresc
 */
function Disp() {
	var checkedData = $("#gridPrescList").datagrid("getChecked");
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "请先勾选需要发放的处方！", type: 'alert'});
		return;
	}
	var prescNoStr = "";
	for(var i in checkedData){
		var prescNo = checkedData[i].prescNo;
		var dispNum = checkedData[i].dispNum;
		var toDispNum = checkedData[i].toDispNum;
		if (dispNum > toDispNum){
			PHA.Popover({ showType: "show",	msg: "发放付数不能大于待发放付数", type: 'error'	});
			return ;
		}
		if ((dispNum == "")||(dispNum.length == 0)){
			PHA.Popover({ showType: "show",	msg: "发放付数不能小于等于0", type: 'error'	});
			return ;
		}
		if (dispNum <= 0){
			PHA.Popover({ showType: "show",	msg: "发放付数不能小于等于0", type: 'error'	});
			return ;
		}
		var dispNumStr = dispNum.split(".")
		if (dispNumStr[0] !== dispNum){
			PHA.Popover({ showType: "show",	msg: "发放付数不能是小数", type: 'error' });
			return ;		
		}
		var dispStr = prescNo + "," + dispNum
		prescNoStr = prescNoStr == "" ? dispStr : prescNoStr +"!!"+ dispStr;
	}
	if(!prescNoStr) return;
	var remark = "患者领药"
	var params = prescNoStr +"^"+ decCode +"^"+ opUser +"^"+ "" +"^"+ locId +"^"+ remark;
	console.log("params:"+params)
	$cm({
		ClassName: "PHA.DEC.DecDisp.OperTab",
		MethodName: "SaveDispPstBatch",
		params: params,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({ showType: "show",	msg: retData, type: 'error'	});
		}else{
			PHA.Popover({ showType: "show",	msg: "发放成功！", type: 'success' });
			Query("");
			ColPrescView("");
		}

	});	
	
}

/**
 * 已发放查询界面清屏
 * @method Clear
 */
function Clear(){
	$.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.OUTDISP", 
		AppCode:""
		}, function(AppPropData){
			$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
			$('#timeStart').timespinner('setValue', "00:00:00");
			$('#timeEnd').timespinner('setValue', "23:59:59");
			$("#txtPrescNo").focus();
		});
		
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	if(ComPropData.PrescView=="Y") { 
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//显示处方预览panel
	}
	queryFlag = ""
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
	$('#txtPrescNo').val("");
	$('#txtPatNo').val("");
	$('#txtCardNo').val("");
	$('#cmbAdmType').combobox("setValue","") ,
	$('#gridPrescList').datagrid('uncheckAll');
	$('#gridPrescList').datagrid('clear');
	ColPrescView("");
}

/**
 * 处方预览
 * @method PrescView
 */
function ColPrescView(prescNo){
	var phartype = "O";
	DEC_PRESC.Presc("divPreLayout", {
		PrescNo: prescNo, 
		AdmType: phartype,
		CY: "Y"
	}); 
}


