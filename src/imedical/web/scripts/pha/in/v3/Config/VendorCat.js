/**
 * ģ��:     ��Ӫ��ҵ����ά��
 * ��д����: 2021-04-26
 * ��д��:   yangsj
 */
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
$(function () {
    InitGrid();
    InitHospCombo();
});

function InitHospCombo() {
	var hospComp = GenHospComp('APC_VendCat','', { width: 315 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        QueryVendorCat();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'APC_VendCat',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
    
    /// ��ʼ���ܿذ�ť
    var btnObj = GenHospWinButton('APC_VendCat');
    if (!btnObj) {
        return;
    }
    
    btnObj.options().onClick = function () {
        var rowData = $('#GridVendorCat').datagrid('getSelected');
        if (rowData === null) {
            return;
        }
		GenHospWin("APC_VendCat", rowData.Rowid, HospWinCallback, { singleSelect: false })
        //InitHospWin('ARC_ItmMast', rowData.arcimId, , { singleSelect: false });
    };
}
// �ܿش��ڹر�, �ص�, ����Ϊѡ�е�ҽԺ��������
function HospWinCallback(selRows){
	
}

function InitGrid(){
	
	var columns = [
        [
            { field: 'Rowid', 		title: 'Rowid', 		hidden: true },
            {
				title: "����",
				field: "APCVCCode",
				width: 140,
				align: "left",
				editor: PHA_GridEditor.ValidateBox({
					//required: true
				})
			},
			{
				title: "����",
				field: "APCVCDesc",
				width: 800,
				align: "APCVCDesc",
				editor: PHA_GridEditor.ValidateBox({
					//required: true
				})
			},
        ],
    ];
    var dataGridOption = {
        url: $URL,
		queryParams: {
            ClassName: 'PHA.IN.VendorCat.Query',
            QueryName: 'GetVendorCat',
            HospId:PHA_COM.Session.HOSPID
        },
        idField: 'Rowid',
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: '#GridVendorCatBar',
		allowEnd:true,
		isAutoShowPanel: true,
        editFieldSort: ['APCVCCode','APCVCDesc'],
        onClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: 'GridVendorCat',
				index: index,
				field: field
			});
		},
    };
    PHA.Grid('GridVendorCat', dataGridOption);
}

function Add(){
	PHA_GridEditor.Add({
		gridID: 'GridVendorCat',
		field: 'APCVCCode',
		rowData: {},
		//checkRow: true, // ������ʱ�Ƿ���֤��һ������
		firstRow: false  // �����з����������ǰ
	}, 1);
}
function Save(){
	PHA_GridEditor.End('GridVendorCat');
	var gridChanges = $('#GridVendorCat').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    var paramsStr=""
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var Rowid = iData.Rowid || '';
        var APCVCCode = iData.APCVCCode || '';
        var APCVCDesc = iData.APCVCDesc || '';
        if ((!APCVCCode)||(!APCVCDesc)){
	        PHA.Popover({ showType: 'show', msg: $g('��������Ʋ���Ϊ�գ�'), type: 'alert' });
            return;
        }
        
        var params = [Rowid,APCVCCode, APCVCDesc].join("^")
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
     }
     //alert(paramsStr)
     $.cm(
        {
            ClassName: 'PHA.IN.VendorCat.Save',
            MethodName: 'SaveVendorCat',
            HospId:PHA_COM.Session.HOSPID,
            paramsStr: paramsStr
            
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
            }
            QueryVendorCat();
        }
    );
     
	
}

function QueryVendorCat(){
	$('#GridVendorCat').datagrid('clearSelections');  
    $('#GridVendorCat').datagrid('clear');
	$('#GridVendorCat').datagrid('query', {
		HospId : PHA_COM.Session.HOSPID
		});
}
function Delete(){
	var APCVC = ""
	var gridSelect = $('#GridVendorCat').datagrid('getSelected') || '';
    if (gridSelect) APCVC = gridSelect.Rowid;
    else {
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ����Ӫ��ҵ����!!��"), type: 'alert' });
	    return;
    }
    if (!APCVC){
	    var rowIndex = $('#GridVendorCat').datagrid('getRowIndex', gridSelect);
        $('#GridVendorCat').datagrid('deleteRow', rowIndex);
    }
    else{
	    $.cm(
        {
            ClassName:  'PHA.IN.VendorCat.Save',
            MethodName: 'DeleteVendorCat',
            APCVC:	    APCVC
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: 'ɾ���ɹ�!', type: 'success' });
	            QueryVendorCat();
	            return;
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
	            return;
            }
            
        }
    );
    }
}
