/**
 * ����:	 ��ҩ������-��¼��ҩ��
 * ��д��:	 MaYuqiang
 * ��д����: 2022-10-19
 */
var FEESELPRESCNO = gLoadPrescNo;
var FEESELCOOKTYPE = gCookTypeId;
var HERB_ADDCOOKFEE_RET = "";			// ����ֵ
var gUserId = session['LOGON.USERID'] ;	
var gLocId = session['LOGON.CTLOCID'] ;
var gGroupId = session['LOGON.GROUPID'] ;
var gHospId = session['LOGON.HOSPID'] ;
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserId +"^"+ gHospId;

$(function () {
	$('#btnRetAddCookFee').on('click', RetAddCookFee);
	$('#btnCancelAddCookFee').on("click",CancelAddCookFee);
	InitGridCookFee();
})

function InitGridCookFee(){
	var columns = [
		[	
			{
				field: 'TArcimId',
				title: 'ҽ����Id',
				align: 'center',
				hidden: true,
				width: 90
			}, {
				field: 'TArcimDesc',
				title: 'ҽ��������',
				align: 'center',
				width: 300
			}, {
				field: 'TQty',
				title: 'ҽ������',
				align: 'center',
				width: 108,
				editor:{
					type: 'numberbox',
                     options: {
                        required: true,
						tipPosition: 'bottom',
                        onChange: function(nval, oval){
                            $("#gridAddCookFee").datagrid('endEditing');
                        }
                        
                    }
				}
			}
		]
	];
	var dataGridOption = {
		//url: '',
		fit: true,
		rownumbers: false,
		columns: columns,
		nowrap:false ,
		pagination: false,
		singleSelect: true,
		fitcolumns: true,
		url: $URL,
		toolbar: '',
		queryParams: {
			ClassName: "PHA.HERB.CookFee.Query",
			QueryName: "GetCookFeeList",
            prescNo: FEESELPRESCNO,
            cookType: FEESELCOOKTYPE
		},
        onClickCell: function(rowIndex, field, value) {
			if (field == "TQty"){
                $('#gridAddCookFee').datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'TQty'
                });

            }else {
                $('#gridAddCookFee').datagrid('endEditing');
            }
        },
		onLoadSuccess: function () {
			
		}
	};
	PHA.Grid("gridAddCookFee", dataGridOption);

}


// ���ط�ҩ������Ϣ
function RetAddCookFee(){
    var rows = $("#gridAddCookFee").datagrid("getRows");
    if (rows.length == 0) {
		HERB_ADDCOOKFEE_RET = "1"	
		top.$("#PHA_HERB_V2_ADDCOOKFEE").window("destroy");	 
	    return ;
    }
    var retStr = ""
    for (var i = 0; i < rows.length; i++) {
        var arcimId = rows[i].TArcimId;
        var qty = rows[i].TQty;
        if (qty > 0){
            var arcStr = arcimId +"^"+ qty
            if (retStr == ""){
                var retStr = arcStr
            }
            else {
                var retStr = retStr +"$$"+ arcStr
            }

        }
    }
    if (retStr == "") {
		$.messager.alert('��ʾ', "δ��ȡ����Ҫ��¼��ҽ����Ϣ", 'warning');
	    return ;
    }
    var addFeeRet = tkMakeServerCall("PHA.HERB.CookFee.Biz", "AddCookFee", retStr, FEESELPRESCNO, LogonInfo);
	var addFeeArr = addFeeRet.split("^");
	var addFeeVal = addFeeArr[0];
	if (addFeeVal < 0){
		HERB_ADDCOOKFEE_RET = addFeeVal
		$.messager.alert('��ʾ', addFeeArr[1], 'warning');
		// ����ʧ��ʱ���رմ��壬�û����Լ�������
		//top.$("#PHA_HERB_V2_ADDCOOKFEE").window("destroy");
		return;
	}
	else {
		HERB_ADDCOOKFEE_RET = "1"
		$.messager.alert('��ʾ',"��ҩ�Ѳ�¼�ɹ�","info");
		top.$("#PHA_HERB_V2_ADDCOOKFEE").window("destroy");
	    return ; 
	}
}

function CancelAddCookFee(){
	HERB_ADDCOOKFEE_RET = 0 ;
	top.$("#PHA_HERB_V2_ADDCOOKFEE").window("destroy");	
	return ;
}

