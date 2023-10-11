/**
 * 模块:     经营企业信息维护
 * 编写日期: 2021-04-26
 * 编写人:   yangsj
 */
PHA_COM.ResizePhaColParam.auto = false;
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var width 		= 160;
$(function () {
	InitHospCombo();		//授权医院下拉框
    InitDict();				//字典初始化
    InitDictWithHosp();  	//字典初始化(医院授权控制)
    InitGrid();				//初始化grid
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
    
    /// 初始化管控按钮
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

// 管控窗口关闭, 回调, 参数为选中的医院的行数据
function HospWinCallback(selRows){
	queryVendor();
}


function InitDict(){
	var VenData=[
            {
                RowId: '',
                Description: $g('全部'),
            },
            {
                RowId: 'A',
                Description: $g('使用'),
            },
            {
                RowId: 'S',
                Description: $g('停用'),
            },
        ]
    //使用状态
	PHA.ComboBox('VenState', {
        panelHeight: 'auto',
        editable: false,
        width:120,
        data: VenData
        
    });
    var VenDatai=[
            {
                RowId: 'A',
                Description: $g('使用'),
            },
            {
                RowId: 'S',
                Description: $g('停用'),
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
	//经营企业分类
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
            { field: 'ApcCode', 	title: '代码',  		width: 100},
            { field: 'ApcName', 	title: '名称', 			width: 200},
            { field: 'Tel', 		title: '电话', 			width: 120},
            { field: 'Category', 	title: '分类', 			width: 120 },
            { field: 'CtrlAcct', 	title: '账户', 			width: 120 },
            { field: 'CrAvail', 	title: '注册资金', 		width: 120 },
            { field: 'LstPoDate', 	title: '合同截止日期', 	width: 120 },
            { field: 'Fax', 		title: '传真', 			width: 80 },
            { field: 'corporation', title: '法人', 			width: 80 },
            { field: 'President', 	title: '法人身份证',	width: 150 },
            { field: 'ApcStatus', 	title: '使用状态', 		width: 120 ,	 formatter:Stateformatter}
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
			{title: '证件类型',			field: 'CertType',			width:100,	hidden: true}, 
			{title: '证件类型',			field: 'CertTypeDesc',		width:150	}, 
			{title: '证件编号',			field: 'CertText',			width:200	}, 
			{title: '效期开始',			field: 'CertDateFrom',		width:100	}, 
			{title: '效期截止',			field: 'CertDateTo',		width:100	}, 
			{title: '发证机关',			field: 'CertIssuedDept',	width:100	}, 
			{title: '发证日期',			field: 'CertIssuedDate',	width:100	}, 
			{title: '是否长期',			field: 'CertBlankedFlag',	width:80,	formatter:YNformatter}, 
			{title: '是否延期',			field: 'CertDelayFlag',		width:80,	formatter:YNformatter}, 
			{title: '延期至',			field: 'CertDelayDateTo',	width:100	}, 
			//{title: '是否展示',			field: 'CertShowFlag',		width:80,	formatter:YNformatter}
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
		{title: '人员类型',			field: 'PersonType',		width:100,			hidden:true		},
		{title: '姓名',				field: 'PersonName',		width:100		}, 
		{title: '身份证',			field: 'PersonCard',		width:150		}, 
		{title: '手机',				field: 'PersonCarrTel',		width:100		}, 
		{title: '电话',				field: 'PersonTel',			width:100		}, 
		{title: '邮箱',				field: 'PersonEmail',		width:150		}, 
		{title: '传真',				field: 'PersonFax',			width:100		}, 
		{title: '授权书开始效期',	field: 'PersonStartDate',	width:110		}, 
		{title: '授权书截止效期',	field: 'PersonEndDate',		width:110		}, 
		//{title: '是否展示',			field: 'PersonShowFlag',	width:80,		formatter:YNformatter}
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
	            PHA.Popover({ showType: 'show', msg: '保存成功!', type: 'success' });
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
	    PHA.Popover({ showType: 'show', msg: $g("请选择一个经营企业！"), type: 'alert' });
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
	            PHA.Popover({ showType: 'show', msg: '保存成功!', type: 'success' });
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
	    PHA.Popover({ showType: 'show', msg: $g("请选择一条资质信息！"), type: 'alert' });
	    return;
    }
    ShowCertWin(CertId)
}

function ShowCertWin(CertId){
	var ApcRowId = ""
    var gridSelect = $('#GridVendor').datagrid('getSelected') || '';
    if (gridSelect) ApcRowId = gridSelect.Rowid;
    if (!ApcRowId){
	    PHA.Popover({ showType: 'show', msg: $g("请选择一个经营企业！"), type: 'alert' });
	    return;
    }
    var iconCls = 'icon-w-edit'
    var title = "资质编辑"
    if (!CertId) {
	    iconCls = 'icon-w-add'
	    title   = "资质新增"
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
	    PHA.Popover({ showType: 'show', msg: $g("请选择一个经营企业！"), type: 'alert' });
	    return;
    }
    var ParamsJson = PHA.DomData('#diagAddCert', {
        doType: 'query',
        retType: 'Json'
    });
    var JsonArrLen = ParamsJson.length
    if(JsonArrLen == 0) return;
    var ParamsJson = ParamsJson[0]
    // 验证 延期标志 和延期日期
    var CERTDelayFlag = ParamsJson.CERTDelayFlag
    var CERTDelayDateTo = ParamsJson.CERTDelayDateTo
    if((!CERTDelayFlag)&&(CERTDelayDateTo!="")){
	    PHA.Popover({ showType: 'show', msg: $g("未勾选延期标志不能维护延期日期！"), type: 'alert' });
	    return;
    }
    if((CERTDelayFlag)&&(CERTDelayDateTo=="")){
	    PHA.Popover({ showType: 'show', msg: $g("勾选延期标志请维护延期日期！"), type: 'alert' });
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
	            PHA.Popover({ showType: 'show', msg: '保存成功!', type: 'success' });
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
	    PHA.Popover({ showType: 'show', msg: $g("请选择一条人员信息！"), type: 'alert' });
	    return;
    }
    ShowPersonWin(PersonId)
}

function ShowPersonWin(PersonId){
	var ApcRowId = ""
    var gridSelect = $('#GridVendor').datagrid('getSelected') || '';
    if (gridSelect) ApcRowId = gridSelect.Rowid;
    if (!ApcRowId){
	    PHA.Popover({ showType: 'show', msg: $g("请选择一个经营企业！"), type: 'alert' });
	    return;
    }
    var iconCls = 'icon-w-edit'
    var title = "人员信息-编辑"
    if (!PersonId) {
	    iconCls = 'icon-w-add'
	    title   = "人员信息-新增"
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
	    PHA.Popover({ showType: 'show', msg: $g("请选择一个经营企业！"), type: 'alert' });
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
	            PHA.Popover({ showType: 'show', msg: '保存成功!', type: 'success' });
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
        return '<font color="#21ba45">'+$g("使用")+'</font>';
    } 
    else if (value == 'S'){
        return '<font color="#f16e57">'+$g("停用")+'</font>';
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