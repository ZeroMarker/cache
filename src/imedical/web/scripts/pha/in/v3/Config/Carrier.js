/**
 * 模块:     配送企业维护
 * 编写日期: 2021-05-10
 * 编写人:   yangsj
 */
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var width 		= 250;
$(function () {
    //InitDict();
    InitGrid();
    InitHosp();
});
function InitHosp() {
    var hospComp = GenHospComp("DHC_Carrier",'', { width: 368 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        QueryCarrier();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'DHC_Carrier',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
    
}
 

function InitGrid(){
	
	var columns = [
        [
            { field: 'Rowid', 		title: 'Rowid', 		hidden: true },
            {
				title: "代码",
				field: "CarrierCode",
				width: 150,
				align: "left",
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			},
			{
				title: "名称",
				field: "CarrierDesc",
				width: 750,
				align: "left",
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}
        ],
    ];
    var dataGridOption = {
        url: $URL,
		queryParams: {
            ClassName: 	'PHA.IN.Carrier.Query',
            QueryName: 	'GetCarrier',
            HospId:		PHA_COM.Session.HOSPID,
            ParamsJson:	'{}'
        },
        idField: 'Rowid',
		singleSelect: true,
		pagination: true,
		columns: columns,
		autoRowHeight : true,
		toolbar: '#GridCarrierBar',
		allowEnd:true,
		isAutoShowPanel: true,
        editFieldSort: ['CarrierCode','CarrierDesc'],
        onClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: 'GridCarrier',
				index: index,
				field: field
			});
		},
    };
    PHA.Grid('GridCarrier', dataGridOption);
}


function Add(){
	PHA_GridEditor.Add({
		gridID: 'GridCarrier',
		field: 'CarrierCode',
		rowData: {},
		//checkRow: true, // 新增行时是否验证上一行数据
		firstRow: true  // 新增行放在最后还是最前
	}, 1);
}


function Save(){
	var CheckValue = PHA_GridEditor.CheckValues('GridCarrier')
	if (CheckValue) {
		PHA.Msg( 'alert',CheckValue);
        return;
	}
	PHA_GridEditor.End('GridCarrier');
	var gridChanges = $('#GridCarrier').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    var paramsStr=""
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var Rowid = iData.Rowid || '';
        var CarrierCode = iData.CarrierCode || '';
        var CarrierDesc = iData.CarrierDesc || '';
        if ((!CarrierCode)||(!CarrierDesc)){
	        PHA.Msg( 'alert','代码或名称不能为空！');
            return;
        }
        
        var params = [Rowid,CarrierCode, CarrierDesc].join("^")
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
     }
     
     $.cm(
        {
            ClassName:  'PHA.IN.Carrier.Save',
            MethodName: 'SaveCarrier',
            HospId:		PHA_COM.Session.HOSPID,
            paramsStr: 	paramsStr,
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '保存成功!', type: 'success' });
	            QueryCarrier();
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
            }
            
        }
    );
}

function QueryCarrier(){
	var ParamsJson = PHA.DomData('#GridCarrierBar', {
        doType: 'query',
        retType: 'Json'
    });
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $('#GridCarrier').datagrid('query', {
        HospId: PHA_COM.Session.HOSPID,
        ParamsJson: ParamsJson,
    });
	
}
