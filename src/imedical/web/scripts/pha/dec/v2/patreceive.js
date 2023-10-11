/**
 * @ģ��:     ��ҩ��-������ҩ(��ҩ����֮������װ�����)
 * @��д����: 2021-02-17
 * @��д��:   MaYuqiang
 */
var decCode = "FF";	// ��ҩ���̱�ʶ
var locId = session['LOGON.CTLOCID'];
var opUser = session['LOGON.USERID'];
var queryFlag = ""
$(function () {
	InitDict();
	InitGridPrescList();
	// �����Żس��¼�
	$("#txtPrescNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo = $.trim($("#txtPrescNo").val());
			if (prescNo != "") {
				Query("Y");
			}
		}
	})
	// �ǼǺŻس��¼�
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				Query("Y");
			}
		}
	});
	// ���Żس��¼�
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
 * ��ʼ�����
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
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//��ʾ����Ԥ��panel
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
	
	// ��������
    PHA.ComboBox('cmbAdmType', {
        width: '155',
        data: [
            { RowId: 'O', Description: $g('����') },
            { RowId: 'I', Description: $g('סԺ') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	//������
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
	//����Ĭ��ֵ
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
 * ��ʼ��ɨ�뷢�Ŵ����б�
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
			title:'��ǰ����',	
			align:'left', 
			width: 70, 
			styler:function(value,row,index){
				if (row.curProDesc == "��ǩ") {
                	return 'background-color:#a849cb;color:white;';
                    }
                else if (row.curProDesc == "����") {
					return 'background-color:#6557d3;color:white;';
                }
                else {
	                
	            }
			}
		},
		{
			field:'dispNum',	
			title:'���Ÿ���',		
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
			title:'�ǼǺ�',		
			align:'left', 
			width: 100
		}, 
		{
			field:'patName',	
			title:'��������',	
			align:'left', 
			width: 80
		}, 
		{
			field:'prescNo', 	
			title:'������',	  	
			align:'left', 
			width: 130
		},
		{
			field: 'dispedNum',	
			title: '�ѷ��Ÿ���',	
			align: 'right', 
			width: 90
		},
		{
			field: 'toDispNum',	
			title: '�����Ÿ���',	
			align: 'right', 
			width: 90
		},
		{
			field:'preFacTor',	
			title:'�ܸ���',		
			align:'right', 
			width: 60
		}, 
		{
			field:'deptLocDesc', 	
			title:'����',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'decTypeDesc', 	
			title:'��ҩ����', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'�շ�ʱ��', 	
			align:'left', 
			width: 160
		},
		{
			field:'preCount',	
			title:'ζ��',		
			align:'right', 
			width: 45
		}, 
		{
			field:'preForm',	
			title:'��������',	
			align:'left', 
			width: 80
		}, 
		{
			field:'preEmFlag',	
			title:'�Ƿ�Ӽ�',	
			align:'left', 
			width: 65
		}, 
		{
			field:'phaLocDesc',	
			title:'��������',	
			align:'left', 
			width: 100
		}, 
		{
			field:'operUserName',	
			title:'������',		
			align:'left', 
			width: 80
		},
		{
			field:'operDate',	
			title:'����ʱ��',	
			align:'left', 
			width: 160
		},
		{
			field:'cookCost',	
			title:'��ҩ��',		
			align:'left', 
			width: 150,
			nowrap:false
		},
		{
			field:'allDispFlag',	
			title:'ȫ�����ű�־',		
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
					PHA.Popover({showType: "show", msg: "δ����������ȡ�Ĵ�����Ϣ�����ʵ�����ԣ�", type: 'alert'});
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
 * ɨ�뷢�ţ���ѯ����������
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
		PHA.Popover({ showType: "show",	msg: "�����š��ǼǺš�����������дһ���ſ��Լ���������Ϣ��", type: 'alert'});
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
 * ��ȡɨ�뷢�Ž���Ԫ��ֵ
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

//����
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
		PHA.Popover({ showType: "show",	msg: "δ��ȡ��������Ϣ�������ԣ�", type: 'alert'});
		return;
	}
	
	setTimeout(function(){
		Query("Y") ; 
	},0)	
	
}

/**
 * ȷ�Ϸ���
 * @method dispPresc
 */
function Disp() {
	var checkedData = $("#gridPrescList").datagrid("getChecked");
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "���ȹ�ѡ��Ҫ���ŵĴ�����", type: 'alert'});
		return;
	}
	var prescNoStr = "";
	for(var i in checkedData){
		var prescNo = checkedData[i].prescNo;
		var dispNum = checkedData[i].dispNum;
		var toDispNum = checkedData[i].toDispNum;
		if (dispNum > toDispNum){
			PHA.Popover({ showType: "show",	msg: "���Ÿ������ܴ��ڴ����Ÿ���", type: 'error'	});
			return ;
		}
		if ((dispNum == "")||(dispNum.length == 0)){
			PHA.Popover({ showType: "show",	msg: "���Ÿ�������С�ڵ���0", type: 'error'	});
			return ;
		}
		if (dispNum <= 0){
			PHA.Popover({ showType: "show",	msg: "���Ÿ�������С�ڵ���0", type: 'error'	});
			return ;
		}
		var dispNumStr = dispNum.split(".")
		if (dispNumStr[0] !== dispNum){
			PHA.Popover({ showType: "show",	msg: "���Ÿ���������С��", type: 'error' });
			return ;		
		}
		var dispStr = prescNo + "," + dispNum
		prescNoStr = prescNoStr == "" ? dispStr : prescNoStr +"!!"+ dispStr;
	}
	if(!prescNoStr) return;
	var remark = "������ҩ"
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
			PHA.Popover({ showType: "show",	msg: "���ųɹ���", type: 'success' });
			Query("");
			ColPrescView("");
		}

	});	
	
}

/**
 * �ѷ��Ų�ѯ��������
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
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//��ʾ����Ԥ��panel
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
 * ����Ԥ��
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


