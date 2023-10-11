/**
 * ģ��:     ����ά��
 * ��д����: 2021-05-19
 * ��д��:   yangsj
 */
PHA_COM.ResizePhaColParam.auto = false;
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
    var hospComp = GenHospComp("DHC_STOrigin",'', { width: 358 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        QueryOrigin();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'DHC_STOrigin',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
    
    /// ��ʼ���ܿذ�ť
    var btnObj = GenHospWinButton('DHC_STOrigin');
    if (!btnObj) {
        return;
    }
    
    btnObj.options().onClick = function () {
        var rowData = $('#GridOrigin').datagrid('getSelected');
        if (rowData === null) {
            return;
        }
		GenHospWin("DHC_STOrigin", rowData.OrigId, HospWinCallback, { singleSelect: false })
        //InitHospWin('ARC_ItmMast', rowData.arcimId, , { singleSelect: false });
    };
}

// �ܿش��ڹر�, �ص�, ����Ϊѡ�е�ҽԺ��������
function HospWinCallback(selRows){
	QueryOrigin();
}
 
function InitGrid(){
	
	var columns = [
        [	// OrigId,OriginCode,OriginDesc,OriginAlias
            { field: 'OrigId', 		title: 'OrigId', 		hidden: true },
            {
				title: "����",
				field: "OriginCode",
				width: 150,
				align: "left",
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			},
			{
				title: "����",
				field: "OriginDesc",
				width: 280,
				align: "left",
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			},
			{
				title: "����",
				field: "OriginAlias",
				width: 600,
				align: "left",
				editor: PHA_GridEditor.ValidateBox({
				})
			}
        ],
    ];
    var dataGridOption = {
        url: $URL,
		queryParams: {
            ClassName: 	'PHA.IN.Origin.Query',
            QueryName: 	'GetOrigin',
            HospId:		PHA_COM.Session.HOSPID,
            ParamsJson:	'{}'
        },
        idField: 'OrigId',
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: '#GridOriginBar',
		allowEnd:true,
		isAutoShowPanel: true,
        editFieldSort: ['OriginCode','OriginDesc','OriginAlias'],
        onClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: 'GridOrigin',
				index: index,
				field: field
			});
		},
    };
    PHA.Grid('GridOrigin', dataGridOption);
}


function Add(){
	PHA_GridEditor.Add({
		gridID: 'GridOrigin',
		field: 'OriginCode',
		rowData: {},
		//checkRow: true, // ������ʱ�Ƿ���֤��һ������
		firstRow: true  // �����з����������ǰ
	}, 1);
}


function Save(){
	PHA_GridEditor.End('GridOrigin');
	var gridChanges = $('#GridOrigin').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    var paramsStr=""
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var OrigId = iData.OrigId || '';
        var OriginCode = iData.OriginCode || '';
        var OriginDesc = iData.OriginDesc || '';
        var OriginAlias = iData.OriginAlias || '';
        if ((!OriginCode)||(!OriginDesc)){
	        PHA.Msg( 'alert',$g('��������Ʋ���Ϊ�գ�'));
            return;
        }
        
        var params = [OrigId, OriginCode, OriginDesc, OriginAlias].join("^")
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
     }
     $.cm(
        {
            ClassName:  'PHA.IN.Origin.Save',
            MethodName: 'SaveOrigin',
            HospId:		PHA_COM.Session.HOSPID,
            paramsStr: 	paramsStr,
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
	            QueryOrigin();
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
            }
            
        }
    );
}

function QueryOrigin(){
	var ParamsJson = PHA.DomData('#GridOriginBar', {
        doType: 'query',
        retType: 'Json'
    });
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $('#GridOrigin').datagrid('query', {
        HospId: PHA_COM.Session.HOSPID,
        ParamsJson: ParamsJson,
    });
	
}
