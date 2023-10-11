/**
 * 模块:     生产企业信息维护
 * 编写日期: 2021-05-8
 * 编写人:   yangsj
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
    
/// 初始化管控按钮
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

// 管控窗口关闭, 回调, 参数为选中的医院的行数据
function HospWinCallback(selRows){
	queryPhManf();
}
function InitDict(){
	var VenData=[
            {
                RowId: '',
                Description: $g('全部'),
            },
            {
                RowId: 'Y',
                Description: $g('使用'),
            },
            {
                RowId: 'N',
                Description: $g('停用'),
            },
        ]
    //使用状态
	PHA.ComboBox('ManfState', {
        panelHeight: 'auto',
        editable: false,
        width:120,
        data: VenData
        
    });
    var VenDatai=[
            {
                RowId: 'Y',
                Description: $g('使用'),
            },
            {
                RowId: 'N',
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
	//上级生产企业
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
            { field: 'ManfCode', 	title: '代码',  		width: 100},
            { field: 'ManfName', 	title: '名称', 			width: 200},
            { field: 'Tel', 		title: '电话', 			width: 120},
            { field: 'Address', 	title: '地址', 			width: 120 },
            { field: 'Status', 		title: '使用状态', 		width: 120 ,	formatter:Stateformatter}
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
	            PHA.Msg('success' ,'保存成功!' );
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
	    PHA.Msg('alert' ,"请选择一条资质信息！");
	    return;
    }
    ShowCertWin(CertId)
}

function ShowCertWin(CertId){
	var PhManf = ""
    var gridSelect = $('#GridPhManf').datagrid('getSelected') || '';
    if (gridSelect) PhManf = gridSelect.PhManf;
    if (!PhManf){
	    PHA.Msg('alert' ,"请选择一个生产企业！");
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
    else{
	    $('#CERTDelayFlag').checkbox("setValue",true)  //重复赋值刷新change事件
	    $('#CERTDelayFlag').checkbox("setValue",false)
    }
    
}

function SaveCert()
{
	var PhManfId = ""
    var gridSelect = $('#GridPhManf').datagrid('getSelected') || '';
    if (gridSelect) PhManfId = gridSelect.PhManf;
    if (!PhManfId){
	    PHA.Popover({ showType: 'show', msg: $g("请选择一个经营企业！"), type: 'alert' });
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
	            PHA.Popover({ showType: 'show', msg: '保存成功!', type: 'success' });
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
        return '<font color="#21ba45">'+$g("使用")+'</font>';
    } 
    else {
        return '<font color="#f16e57">'+$g("停用")+'</font>';
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

