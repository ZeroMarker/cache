/**
 * ģ��:     ��Ӫ��ҵ��Ϣά��
 * ��д����: 2021-04-26
 * ��д��:   yangsj
 */
PHA_COM.ResizePhaColParam.auto = false;
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var width 		= 160;
$(function () {
	InitHospCombo();		//��ȨҽԺ������
    InitDict();				//�ֵ��ʼ��
    InitDictWithHosp();  	//�ֵ��ʼ��(ҽԺ��Ȩ����)
    InitGrid();				//��ʼ��grid
});

function InitHospCombo() {
	var hospComp = GenHospComp('APC_Vendor','', { width: 273 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        InitDictWithHosp();
        queryVendor();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'APC_Vendor',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
    
    /// ��ʼ���ܿذ�ť
    var btnObj = GenHospWinButton('APC_Vendor');
    if (!btnObj) {
        return;
    }
    
    btnObj.options().onClick = function () {
        var rowData = $('#GridVendor').datagrid('getSelected');
        if (rowData === null) {
            return;
        }
		GenHospWin("APC_Vendor", rowData.Rowid, HospWinCallback, { singleSelect: false })
        //InitHospWin('ARC_ItmMast', rowData.arcimId, , { singleSelect: false });
    };
}

// �ܿش��ڹر�, �ص�, ����Ϊѡ�е�ҽԺ��������
function HospWinCallback(selRows){
	queryVendor();
}


function InitDict(){
	var VenData=[
            {
                RowId: '',
                Description: $g('ȫ��'),
            },
            {
                RowId: 'A',
                Description: $g('ʹ��'),
            },
            {
                RowId: 'S',
                Description: $g('ͣ��'),
            },
        ]
    //ʹ��״̬
	PHA.ComboBox('VenState', {
        panelHeight: 'auto',
        editable: false,
        width:120,
        data: VenData
        
    });
    var VenDatai=[
            {
                RowId: 'A',
                Description: $g('ʹ��'),
            },
            {
                RowId: 'S',
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
	//��Ӫ��ҵ����
    PHA.ComboBox('VenCat', {
        url: PHA_STORE.VendorCat().url,
        panelHeight: 'auto',
        width:120,
    });
     PHA.ComboBox('VendorCat', {
        url: PHA_STORE.VendorCat().url,
        panelHeight: 'auto',
        width:width
    });
    PHA.ComboBox('CERTType', {
        url: PHA_STORE.CertType("Vendor").url,
        panelHeight: 'auto',
        width:155
    });

}
function InitGrid(){
	InitGridVendor();
	InitGridCert();
	InitGridPerson();
}

function InitGridVendor(){
	    var columns = [
        [
            // Rowid,ApcCode,ApcName,Tel,Category,CategoryId,CtrlAcct,CrAvail,LstPoDate,Fax,President,ApcStatus
            { field: 'Rowid', 		title: 'Rowid', 		hidden: true },
            { field: 'ApcCode', 	title: '����',  		width: 100},
            { field: 'ApcName', 	title: '����', 			width: 200},
            { field: 'Tel', 		title: '�绰', 			width: 120},
            { field: 'Category', 	title: '����', 			width: 120 },
            { field: 'CtrlAcct', 	title: '�˻�', 			width: 120 },
            { field: 'CrAvail', 	title: 'ע���ʽ�', 		width: 120 },
            { field: 'LstPoDate', 	title: '��ͬ��ֹ����', 	width: 120 },
            { field: 'Fax', 		title: '����', 			width: 80 },
            { field: 'corporation', title: '����', 			width: 80 },
            { field: 'President', 	title: '�������֤',	width: 150 },
            { field: 'ApcStatus', 	title: 'ʹ��״̬', 		width: 120 ,	 formatter:Stateformatter}
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.Vendor.Query',
            QueryName: 'GetVendor',
            HospId: PHA_COM.Session.HOSPID,
            ParamsJson: '{}'
            
        },
        idField: 'Rowid',
        columns: columns,
        toolbar: '#GridVendorBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
	                SetBasicInfo(rowData.Rowid);
	                QueryCert(rowData.Rowid);
	                QueryPerson(rowData.Rowid);
	            }
	        },
    };
    PHA.Grid('GridVendor', dataGridOption);
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
        columns: columns,
        exportXls: false,
        toolbar: '#GridCertBar',
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
	                //SetBasicInfo(rowData.Rowid);
	            }
	        },
    };
    PHA.Grid('GridCert', dataGridOption);

}

function InitGridPerson(){
	    var columns = [
        [
            // Rowid,ApcCode,ApcName,Tel,Category,CategoryId,CtrlAcct,CrAvail,LstPoDate,Fax,President,ApcStatus
        {title: 'RowId',			field: 'RowId',				width:50,			hidden: true		}, 
		{title: '��Ա����',			field: 'PersonType',		width:100,			hidden:true		},
		{title: '����',				field: 'PersonName',		width:100		}, 
		{title: '���֤',			field: 'PersonCard',		width:150		}, 
		{title: '�ֻ�',				field: 'PersonCarrTel',		width:100		}, 
		{title: '�绰',				field: 'PersonTel',			width:100		}, 
		{title: '����',				field: 'PersonEmail',		width:150		}, 
		{title: '����',				field: 'PersonFax',			width:100		}, 
		{title: '��Ȩ�鿪ʼЧ��',	field: 'PersonStartDate',	width:110		}, 
		{title: '��Ȩ���ֹЧ��',	field: 'PersonEndDate',		width:110		}, 
		//{title: '�Ƿ�չʾ',			field: 'PersonShowFlag',	width:80,		formatter:YNformatter}
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.ApcAndManfPerson.Query',
            QueryName: 'QueryPersonDetail',
            pOrgType: '',
            pOrgId: ''
            
        },
        idField: 'RowId',
        columns: columns,
        toolbar: '#GridPersonBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
	                //SetBasicInfo(rowData.Rowid);
	            }
	        },
    };
    PHA.Grid('GridPerson', dataGridOption);
}


function queryVendor(){
	ClearDetailInfo();
	var ParamsJson = PHA.DomData('#GridVendorBar', {
        doType: 'query',
        retType: 'Json'
    });
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $('#GridVendor').datagrid('query', {
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
        pOrgType : "Vendor",
        pOrgId   : ApcVen,
    });
}


function QueryPerson(ApcVen)
{
	$('#GridPerson').datagrid('clearSelections');   
    $('#GridPerson').datagrid('clear');
	if (!ApcVen) return;
    $('#GridPerson').datagrid('query', {
        pOrgType: "Vendor",
        pOrgId: ApcVen,
    });
}
function SetBasicInfo(RowId){
	if (!RowId) return;
	$.cm(
        {
            ClassName: 'PHA.IN.Vendor.Query',
            MethodName: 'Select',
            Vendor: RowId,
        },
        function (retData) {
	        PHA.DomData('#basicInfo', {
	        	doType: 'clear',
    		});
            PHA.SetVals([retData]);
        }
    );
}


function AddApc(){
	var ParamsJson = PHA.DomData('#diagAddWin', {
        doType: 'clear'
    });
    $("#AddVenStates").combobox("setValue","A")
	$('#diagAddWin')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
}

function SaveAddApc(){
	var ParamsJson = PHA.DomData('#diagAddWin', {
        doType: 'query',
        retType: 'Json'
    });
    var JsonArrLen = ParamsJson.length
    if(JsonArrLen == 0) return;
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $.cm(
        {
            ClassName: 'PHA.IN.Vendor.Save',
            MethodName: 'SaveAddApc',
            ParamsJson: ParamsJson,
            HospId:PHA_COM.Session.HOSPID
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
	            $('#diagAddWin').dialog('close');
	            queryVendor();
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
	            return
            }
        }
    );
}

function UpdateApc(){
	var ParamsJson = PHA.DomData('#basicInfo', {
        doType: 'query',
        retType: 'Json'
    });
    var JsonArrLen = ParamsJson.length
    if(JsonArrLen == 0) return;
    var ApcRowId = ""
    var gridSelect = $('#GridVendor').datagrid('getSelected') || '';
    if (gridSelect) ApcRowId = gridSelect.Rowid;
    if (!ApcRowId){
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ����Ӫ��ҵ��"), type: 'alert' });
	    return;
    }
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $.cm(
        {
            ClassName: 'PHA.IN.Vendor.Save',
            MethodName: 'UpdateApc',
            ParamsJson: ParamsJson,
            HospId:PHA_COM.Session.HOSPID,
            ApcRowId:ApcRowId
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
	            SetBasicInfo(ApcRowId);
	            return;
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
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
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ��������Ϣ��"), type: 'alert' });
	    return;
    }
    ShowCertWin(CertId)
}

function ShowCertWin(CertId){
	var ApcRowId = ""
    var gridSelect = $('#GridVendor').datagrid('getSelected') || '';
    if (gridSelect) ApcRowId = gridSelect.Rowid;
    if (!ApcRowId){
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ����Ӫ��ҵ��"), type: 'alert' });
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
}

function SaveCert()
{
	var ApcRowId = ""
    var gridSelect = $('#GridVendor').datagrid('getSelected') || '';
    if (gridSelect) ApcRowId = gridSelect.Rowid;
    if (!ApcRowId){
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ����Ӫ��ҵ��"), type: 'alert' });
	    return;
    }
    var ParamsJson = PHA.DomData('#diagAddCert', {
        doType: 'query',
        retType: 'Json'
    });
    var JsonArrLen = ParamsJson.length
    if(JsonArrLen == 0) return;
    var ParamsJson = ParamsJson[0]
    // ��֤ ���ڱ�־ ����������
    var CERTDelayFlag = ParamsJson.CERTDelayFlag
    var CERTDelayDateTo = ParamsJson.CERTDelayDateTo
    if((!CERTDelayFlag)&&(CERTDelayDateTo!="")){
	    PHA.Popover({ showType: 'show', msg: $g("δ��ѡ���ڱ�־����ά���������ڣ�"), type: 'alert' });
	    return;
    }
    if((CERTDelayFlag)&&(CERTDelayDateTo=="")){
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ���ڱ�־��ά���������ڣ�"), type: 'alert' });
	    return;
    }
    var ParamsJson = JSON.stringify(ParamsJson);
    $.cm(
        {
            ClassName: 'PHA.IN.Cert.Save',  
            MethodName: 'SaveCert',
            pOrgId: ApcRowId,
            pOrgType:"Vendor",
            ParamsJson:ParamsJson
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
	            $('#diagAddCert').dialog('close');
	            QueryCert(ApcRowId);
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
	            return
            }
        }
    );
}

function AddPerson(){
	ShowPersonWin("")
}

function UpdatePerson(){
	var PersonId=""
	var gridSelect = $('#GridPerson').datagrid('getSelected') || '';
    if (gridSelect) PersonId = gridSelect.RowId;
    if (!PersonId){
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ����Ա��Ϣ��"), type: 'alert' });
	    return;
    }
    ShowPersonWin(PersonId)
}

function ShowPersonWin(PersonId){
	var ApcRowId = ""
    var gridSelect = $('#GridVendor').datagrid('getSelected') || '';
    if (gridSelect) ApcRowId = gridSelect.Rowid;
    if (!ApcRowId){
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ����Ӫ��ҵ��"), type: 'alert' });
	    return;
    }
    var iconCls = 'icon-w-edit'
    var title = "��Ա��Ϣ-�༭"
    if (!PersonId) {
	    iconCls = 'icon-w-add'
	    title   = "��Ա��Ϣ-����"
    }
	$('#diagAddPerson')
    .dialog({
	    title: title,
        iconCls: iconCls,
        modal: true,
        onBeforeClose: function () {},
    })
    .dialog('open');
    PHA.DomData('#diagAddPerson', {
    	doType: 'clear'
	});
    if(PersonId){
	    $.cm(
        {
            ClassName: 'PHA.IN.ApcAndManfPerson.Query',  
            MethodName: 'Select',
            PersonId: PersonId,
        },
        function (retData) {
			PHA.SetVals([retData]);
        }
    );
    }
}

function SavePerson()
{
	var ApcRowId = ""
    var gridSelect = $('#GridVendor').datagrid('getSelected') || '';
    if (gridSelect) ApcRowId = gridSelect.Rowid;
    if (!ApcRowId){
	    PHA.Popover({ showType: 'show', msg: $g("��ѡ��һ����Ӫ��ҵ��"), type: 'alert' });
	    return;
    }
    var ParamsJson = PHA.DomData('#diagAddPerson', {
        doType: 'query',
        retType: 'Json'
    });
    var JsonArrLen = ParamsJson.length
    if(JsonArrLen == 0) return;
    var ParamsJson = JSON.stringify(ParamsJson[0]);
    $.cm(
        {
            ClassName: 'PHA.IN.ApcAndManfPerson.Save',  
            MethodName: 'SavePerson',
            OrgId: ApcRowId,
            OrgType:"Vendor",
            ParamsJson:ParamsJson
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
	            $('#diagAddPerson').dialog('close');
	            QueryPerson(ApcRowId);
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
	if (value == 'A') {
        return '<font color="#21ba45">'+$g("ʹ��")+'</font>';
    } 
    else if (value == 'S'){
        return '<font color="#f16e57">'+$g("ͣ��")+'</font>';
    } 
    else {
	    return value;
    }
}

function ClearDetailInfo(){
	 PHA.DomData('#basicInfo', {
    	 doType: 'clear',
	 });
	 $('#GridCert').datagrid('clearSelections');   
     $('#GridCert').datagrid('clear');
     $('#GridPerson').datagrid('clearSelections');   
     $('#GridPerson').datagrid('clear');
}