/**
 * ģ��:     ������ҵ��Ϣά��
 * ��д����: 2021-05-8
 * ��д��:   yangsj
 */
PHA_COM.ResizePhaColParam.auto = true;
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var width 		= 250;
$(function () {
    InitDict();
    InitDictWithHosp();
    InitGrid();
    InitHosp();
    InitEvent();
});

function InitHosp() {
    var hospComp = GenHospComp("PH_Manufacturer",'', { width: 327 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        queryPhManf();
        InitDictWithHosp();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PH_Manufacturer',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
    
/// ��ʼ���ܿذ�ť
    var btnObj = GenHospWinButton('PH_Manufacturer');
    if (!btnObj) {
        return;
    }
    
    btnObj.options().onClick = function () {
        var rowData = $('#GridPhManf').datagrid('getSelected');
        if (rowData === null) {
            return;
        }
		GenHospWin("PH_Manufacturer", rowData.PhManf, HospWinCallback, { singleSelect: false })
        //InitHospWin('ARC_ItmMast', rowData.arcimId, , { singleSelect: false });
    };
}

// �ܿش��ڹر�, �ص�, ����Ϊѡ�е�ҽԺ��������
function HospWinCallback(selRows){
	queryPhManf();
}
function InitDict(){
	var VenData=[
            {
                RowId: '',
                Description: $g('ȫ��'),
            },
            {
                RowId: 'Y',
                Description: $g('ʹ��'),
            },
            {
                RowId: 'N',
                Description: $g('ͣ��'),
            },
        ]
    //ʹ��״̬
	PHA.ComboBox('ManfState', {
        panelHeight: 'auto',
        editable: false,
        width:120,
        data: VenData
        
    });
    var VenDatai=[
            {
                RowId: 'Y',
                Description: $g('ʹ��'),
            },
            {
                RowId: 'N',
                Description: $g('ͣ��'),
            },
        ]
    PHA.ComboBox('Status', {
        panelHeight: 'auto',
        editable: false,
        data: VenDatai,
        width:width
    });
     PHA.ComboBox('AddVenStates', {
        panelHeight: 'auto',
        editable: false,
        data: VenDatai,
    });
    

}
function InitDictWithHosp(){
	//�ϼ�������ҵ
    PHA.ComboBox('ParManf', {
        url: PHA_STORE.PHManufacturer().url,
        width:width
    });
    
    PHA.ComboBox('CERTType', {
        url: PHA_STORE.CertType("Manf").url,
        panelHeight: 'auto',
        width:155
    });
}

function InitGrid(){
	InitGridPhManf();
	InitGridCert();
}

function InitGridPhManf(){
	    var columns = [
        [
            // PhManf,ManfCode,ManfName,Tel,Address,State
            { field: 'PhManf', 		title: 'RowId', 		hidden: true },
            { field: 'ManfCode', 	title: '����',  		width: 100},
            { field: 'ManfName', 	title: '����', 			width: 200},
            { field: 'Tel', 		title: '�绰', 			width: 120},
            { field: 'Address', 	title: '��ַ', 			width: 120 },
            { field: 'Status', 		title: 'ʹ��״̬', 		width: 120 ,	formatter:Stateformatter}
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.PhManf.Query',
            QueryName: 'QueryPhManf',
            HospId: PHA_COM.Session.HOSPID,
            ParamsJson: '{}'
            
        },
        idField: 'PhManf',
        columns: columns,
        toolbar: '#GridPhManfBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
	                SetBasicInfo(rowData.PhManf);
	                QueryCert(rowData.PhManf);
	            }
	        },
    };
    PHA.Grid('GridPhManf', dataGridOption);
}

function InitGridCert(){
	
	    var columns = [
        [
            // RowId,ApcCode,ApcName,Tel,Category,CategoryId,CtrlAcct,CrAvail,LstPoDate,Fax,President,ApcStatus
            {title: 'RowId',			field: 'RowId',				width:50,	hidden: true},
			{title: '֤������',			field: 'CertType',			width:100,	hidden: true}, 
			{title: '֤������',			field: 'CertTypeDesc',		width:150	}, 
			{title: '֤�����',			field: 'CertText',			width:200	}, 
			{title: 'Ч�ڿ�ʼ',			field: 'CertDateFrom',		width:100	}, 
			{title: 'Ч�ڽ�ֹ',			field: 'CertDateTo',		width:100	}, 
			{title: '��֤����',			field: 'CertIssuedDept',	width:100	}, 
			{title: '��֤����',			field: 'CertIssuedDate',	width:100	}, 
			{title: '�Ƿ���',			field: 'CertBlankedFlag',	width:80,	formatter:YNformatter}, 
			{title: '�Ƿ�����',			field: 'CertDelayFlag',		width:80,	formatter:YNformatter}, 
			{title: '������',			field: 'CertDelayDateTo',	width:100	}, 
			//{title: '�Ƿ�չʾ',			field: 'CertShowFlag',		width:80,	formatter:YNformatter}
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.Cert.Query',
            QueryName: 'QueryCertDetail',
            pOrgType: '',
            pOrgId: ''
        },
        idField: 'RowId',
        toolbar: '#GridCertBar',
        columns: columns,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {},
    };
    PHA.Grid('GridCert', dataGridOption);

}

function queryPhManf(){
	ClearDetailInfo();
	var ParamsJson = PHA.DomData('#GridPhManfBar', {
        doType: 'query',
        retType: 'Json'
    });
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $('#GridPhManf').datagrid('query', {
        HospId: PHA_COM.Session.HOSPID,
        ParamsJson: ParamsJson,
    });
}

function QueryCert(ApcVen)
{
	$('#GridCert').datagrid('clearSelections');   
    $('#GridCert').datagrid('clear');
	if (!ApcVen) return;
    $('#GridCert').datagrid('query', {
        pOrgType : "Manf",
        pOrgId   : ApcVen,
    });
}


function SetBasicInfo(RowId){
	if (!RowId) return;
	$.cm(
        {
            ClassName: 'PHA.IN.PhManf.Query',
            MethodName: 'SelectPhManf',
            PhManf: RowId,
        },
        function (retData) {
	        PHA.DomData('#basicInfo', {
	        	doType: 'clear',
    		});
            PHA.SetVals([retData]);
        }
    );
}

function AddPhManf(){
	PHA.DomData('#basicInfo', {
    	doType: 'clear',
	});
	$('#Status').combobox("setValue","Y")
}

function SavePhManf(){
	var ParamsJson = PHA.DomData('#basicInfo', {
        doType: 'query',
        retType: 'Json'
    });
    var JsonArrLen = ParamsJson.length
    if(JsonArrLen == 0) return;
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $.cm(
        {
            ClassName: 'PHA.IN.PhManf.Save',
            MethodName: 'Save',
            ParamsJson: ParamsJson,
            HospId:PHA_COM.Session.HOSPID
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Msg('success' ,'����ɹ�!' );
	            PHA.DomData('#basicInfo', {
			    	doType: 'clear',
				});
				queryPhManf();
	            SetBasicInfo(retData.code);
	            return;
            }
            else{
	            PHA.Msg('alert',retData.msg);
	            return
            }
        }
    );
}

function AddCert(){
	ShowCertWin("")
}

function UpdateCert(){
	var CertId=""
	var gridSelect = $('#GridCert').datagrid('getSelected') || '';
    if (gridSelect) CertId = gridSelect.RowId;
    if (!CertId){
	    PHA.Msg('alert' ,"��ѡ��һ��������Ϣ��");
	    return;
    }
    ShowCertWin(CertId)
}

function ShowCertWin(CertId){
	var PhManf = ""
    var gridSelect = $('#GridPhManf').datagrid('getSelected') || '';
    if (gridSelect) PhManf = gridSelect.PhManf;
    if (!PhManf){
	    PHA.Msg('alert' ,"��ѡ��һ��������ҵ��");
	    return;
    }
    var iconCls = 'icon-w-edit'
    var title = "���ʱ༭"
    if (!CertId) {
	    iconCls = 'icon-w-add'
	    title   = "��������"
    }
	$('#diagAddCert')
    .dialog({
	    title: title,
        iconCls: iconCls,
        modal: true,
        onBeforeClose: function () {},
    })
    .dialog('open');
    PHA.DomData('#diagAddCert', {
    	doType: 'clear'
	});
    if(CertId){
	    $.cm(
        {
            ClassName: 'PHA.IN.Cert.Query',  
            MethodName: 'Select',
            CertId: CertId,
        },
        function (retData) {
			PHA.SetVals([retData]);
        }
    );
    }
    else{
	    $('#CERTDelayFlag').checkbox("setValue",true)  //�ظ���ֵˢ��change�¼�
	    $('#CERTDelayFlag').checkbox("setValue",false)
    }
    
}

function SaveCert()
{
	var PhManfId = ""
    var gridSelect = $('#GridPhManf').datagrid('getSelected') || '';
    if (gridSelect) PhManfId = gridSelect.PhManf;
    if (!PhManfId){
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ����Ӫ��ҵ��"), type: 'alert' });
	    return;
    }
    var ParamsJson = PHA.DomData('#diagAddCert', {
        doType: 'query',
        retType: 'Json'
    });
    var ss = $('#CERTType').combobox('getValue') || '';
    if(!ParamsJson.length) return;
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $.cm(
        {
            ClassName: 'PHA.IN.Cert.Save',  
            MethodName: 'SaveCert',
            pOrgId: PhManfId,
            pOrgType:"Manf",
            ParamsJson:ParamsJson
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
	            $('#diagAddCert').dialog('close');
	            QueryCert(PhManfId);
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
	            return
            }
        }
    );
}




function YNformatter(value, row, index){
	if (value == 'Y') {
        return PHA_COM.Fmt.Grid.Yes.Chinese;
    } else {
        return PHA_COM.Fmt.Grid.No.Chinese;
    }
}

function Stateformatter(value, row, index){
	if (value == 'Y') {
        return '<font color="#21ba45">'+$g("ʹ��")+'</font>';
    } 
    else {
        return '<font color="#f16e57">'+$g("ͣ��")+'</font>';
    } 
}

function ClearDetailInfo(){
	 PHA.DomData('#basicInfo', {
    	 doType: 'clear',
	 });
	 $('#GridCert').datagrid('clearSelections');   
     $('#GridCert').datagrid('clear');
}

function InitEvent(){
	 $('#CERTDelayFlag').checkbox({
        onCheckChange: function (e,value) {
            if(value){
	            $('#CERTDelayDateTo').datebox("enable",true)
            }
            else{
	            $('#CERTDelayDateTo').datebox("clear")
	            $('#CERTDelayDateTo').datebox("disable",true)
            }
        },
    });
}

