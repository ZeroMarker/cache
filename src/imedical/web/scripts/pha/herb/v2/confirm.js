/**
 * @ģ��:     �����ҩ������ҩȷ��
 * @��д����: 2020-11-12
 * @��д��:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var ProDictCode = "CheckDisp"
$(function () {
	InitGridPrescList();
	InitSetDefVal();
	$('#btnConfirm').on('click', Confirm);
	$('#btnClearScreen').on('click', Clear);
	
	//�����Żس��¼�
	$('#txtPrescNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo=$.trim($("#txtPrescNo").val());
			if (prescNo!=""){
				QueryConfirmPreList();
			}	
		}
	});
	//�ǼǺŻس��¼�
	$('#txtBarCode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txtBarCode").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryConfirmPreList();
			}	
		}
	});
	
	//���Żس��¼�
	$('#txtCardNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txtCardNo").val());
			if (cardno!=""){
				BtnReadCardHandler();
			}
			SetFocus();	
		}
	});
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	
});

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	//��������
	$("#dateColStart").datebox("setValue", '2020-10-12');
	$("#dateColEnd").datebox("setValue", '2020-10-30');
	$('#txtUserCode').val('');
	$('#txtPrescNo').val('');
	$('#txtBarCode').val('');
	$('#txtCardno').val('');
	
}
	
	/**
 * ��ʼ�������б�
 * @method InitGridOutPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	{
				field:'pdCheck',	
				checkbox: true 
			}, {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 80,
				hidden:true
			}, {
				field: 'TPrescInfo',
				title: '������Ϣ',
				align: 'left',
				width: 1700
			}, {
				field: 'TOrdInfo',
				title: 'ҩƷ��Ϣ',
				align: 'left',
				width: 100,
				hidden:true
			}, {
				field: 'TPhbdId',
				title: '��ҩҵ���Id',
				align: 'left',
				width: 70,
				hidden:true
			}
			
		]
	];
	
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:false ,
		pagination: false,
		singleSelect: false,
		toolbar: "#gridPrescListBar",
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Confirm.Query",
			QueryName: "GetPrescList",
		},
		onClickRow: function (rowIndex, rowData) {
			$("#gridPrescList").datagrid("expandRow",rowIndex);
		},
		groupField:'TPrescNo',
		view: detailview,
		detailFormatter:function(rowIndex, rowData){
			var ordInfo = rowData.TOrdInfo ;
			var ordInfoData = ordInfo.split("&&")
			var num = 0
			var detailHtml = '<div style="padding-top:0px">';
			for (num = 0;num<ordInfoData.length;num++){
				var ordDetailInfo = ordInfoData[num] ;
				var ordDetailData = ordDetailInfo.split("^")
				var inciDesc = ordDetailData[0] ;
				var qty = ordDetailData[1] ;
				var remark = ordDetailData[2] ;
				
				detailHtml += '<div class="herb">';
					detailHtml += '<div class="herb-name">' + inciDesc + '</div>';
					detailHtml += '<div class="herb-remark">' + remark + '</div>';
					detailHtml += '<div class="herb-qty">' + qty + '</div>';
				detailHtml += '</div>'	;				
			}
			detailHtml += '</div>'
			return detailHtml;
			
		},
		/*
		onExpandRow:function(rowIndex, rowData){
			alert(rowIndex)
		},*/
		onLoadSuccess:function(data){
			var row = $("#gridPrescList").datagrid("getRows");
			for (var r = 0; r < row.length; r++)
			{
				$("#gridPrescList").datagrid("expandRow",r);
			}	
		}
	};
	PHA.Grid("gridPrescList", dataGridOption);
}

/**
 * ��ѯ����
 * @method QueryConfirmPreList
 */
function QueryConfirmPreList() {
	$('#gridPrescList').datagrid('clear');
	PrescView("") ;
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});	 
}

/**
 * ��ѯ������JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
    return {
        startDate: $("#dateColStart").datebox('getValue'),
        endDate: $("#dateColEnd").datebox('getValue'),
        loc: gLocId,
        patNo: $('#txtBarCode').val(),
		prescNo: $('#txtPrescNo').val(),
        confirmFlag: ($('#chk-confirm').checkbox('getValue')==true?'Y':'N')     
    };
}


/*
 * ��ҩ������ҩȷ��
 * @method Confirm
 */
function Confirm(){
	var gridSelect = $("#gridPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫȷ�ϵĴ���!","info");
		return;
	}	
	var phbdId = gridSelect.TPhbdId ;
	var UserCode = $('#txtUserCode').val() ;
	var params = phbdId + tmpSplit + UserCode ;
	
	$.m({
		ClassName: "PHA.HERB.Confirm.Save",
		MethodName: "Confirm",
		param: params 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		QueryConfirmPreList();
	});
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#gridPrescList').datagrid('clear');
	$('#chk-confirm').checkbox("uncheck",true) ;
}

//��������
window.onload=function(){
	setTimeout("QueryConfirmPreList()",500);
}

