/**
 * 模块:     付款管理-发票管理
 * 编写日期: 2021-05-14
 * 编写人:   yangsj
 */
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var cmbWidth 	= 100;
var cmbWidth2 	= 150;
$(function () {
    InitDict();				//初始化字典
    InitGrid();				//初始化grid
    SetDefault();			//设置默认值
    InitConditionFold();    //条件折叠
});

//条件折叠
function InitConditionFold()
{
	var $lyBody = $('#lyBody');
	$('.pha-con-more-less').toggle();
    $('.pha-con-more-less-link').toggle();
	$lyBody.layout('panel', 'north').panel('resize', { height: 90 });
    $lyBody.layout('resize');
     $('.js-pha-con-toggle .panel-header, .pha-con-more-less').on('click', function (e) {
        $('.pha-con-more-less').toggle();
        $('.pha-con-more-less-link').toggle();
        var tHeight = $('.pha-con-more-less-link').css('display') === 'block' ? 175 : 95;
        $lyBody.layout('panel', 'north').panel('resize', { height: tHeight });
        $lyBody.layout('resize');
    });
}

function InitDict(){
	//采购科室
	PHA.ComboBox('PurLoc', {
        width: cmbWidth2,
        url: PHA_STORE.GetGroupDept().url,
    });
    PHA.ComboBox('UpPurLoc', {
        width: cmbWidth2,
        url: PHA_STORE.GetGroupDept().url,
    });
    
	//货票状态
    PHA.ComboBox('InvState', {
        panelHeight: 'auto',
        width: cmbWidth2,
        data: [
            {
                RowId: "",
                Description: $g('全部'),
            },
            {
                RowId: $g('WAYBILL'),
                Description: $g('货票同到'),
            },
            {
                RowId: $g('NOTWAYBILL'),
                Description: $g('货到票未到'),
            },
        ]
    });
    //业务类型
    var BusiData = [
            {
                RowId: "",
                Description: $g('全部'),
            },
            {
                RowId: $g('G'),
                Description: $g('入库'),
            },
            {
                RowId: $g('R'),
                Description: $g('退货'),
            },
        ]
    PHA.ComboBox('BusiType', {
        panelHeight: 'auto',
        width: cmbWidth,
        data: BusiData
    });
    PHA.ComboBox('UpBusiType', {
        panelHeight: 'auto',
        width: cmbWidth,
        data: BusiData
    });
    
   //经营企业
    PHA.ComboBox('Vendor', {
        url: PHA_STORE.APCVendor().url,
        width: cmbWidth2
    });

}

function SetDefault(){
	$('#PurLoc').combobox('setValue', SessionLoc);
    $('#InvStartDate').datebox('setValue', 't-30');
    $('#InvEnDate').datebox('setValue', 't');
    $('#InvState').combobox('setValue', '');
    $('#BusiType').combobox('setValue', '');
    
}
function SetUpDiagDefault(){
	$('#UpPurLoc').combobox('setValue', SessionLoc);
	$('#UpStartDate').datebox('setValue', 't-7');
    $('#UpEndate').datebox('setValue', 't');
	$('#UpBusiType').combobox('setValue', '');
	$('#WithOutInvNoFlag').checkbox('setValue', true);
}

function InitGrid(){
	InitGridInvNo();
	InitGridBusiMain();
	InitGridBusiDetail();
	InitGridUpdateInvNoMian();
	InitGridUpdateInvNoDetail();
}

function InitGridInvNo(){
	var columns = [
        [
            // INRowId,InvNo,OriginNo,InvDate,Amt,InvState,SendFlag,VendorDesc,PurLocDesc
            { field: 'INRowId', 	title: 'INRowId', 	align: 'left',		hidden: true },
            { field: 'InvNo', 		title: '发票号',  	align: 'left',		width: 90},
            {
                field: 'OriginNo',
                title: '发票代码',
                width: 110,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'InvDate', 	title: '发票日期',  align: 'center',	width: 90},
            {
                field: 'Amt',
                title: '发票金额',
                width: 70,
                halign: 'center',
                align: 'right',
                editor: {
                    type: 'numberbox',
                    options:{precision:2}
                }
            },
            { field: 'RpAmt', 		title: '实际金额', 	align: 'right',		width: 70 },
            { field: 'InvState', 	title: '货票状态', 	align: 'center',	width: 90 ,		styler:StatuiStyler,},
            { field: 'SendFlag', 	title: '同步状态', 	align: 'center',	width: 70 ,		formatter:YNformatter},
            { field: 'PurLocDesc', 	title: '采购科室', 	align: 'left',		width: 120 },
            { field: 'VendorDesc', 	title: '经营企业', 	align: 'left',		width: 180 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.InvNoManage.Query',
            QueryName: 'QueryInvNo',
            HospId:    SessionHosp,
            ParamsJson: '{}'
            
        },
        gridSave:false,
        idField: 'INRowId',
        columns: columns,
        toolbar: '#GridInvNoBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		        var INRowId = rowData.INRowId
                QueryBusiMain(INRowId);
                QueryBusiDetail(INRowId,"");
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'OriginNo',
            });
        },
    };
    PHA.Grid('GridInvNo', dataGridOption);
}

function StatuiStyler(value, row, index)
{
     switch (value) {
         case '货票同到':
             colorStyle = 'background:#a4c703;color:white;';
             break;
         case '货到票未到':
             colorStyle = 'background:#f1c516;color:white;';
             break;
         default:
             colorStyle = 'background:white;color:black;';
             break;
     }
     return colorStyle;
}

function YNformatter(value, row, index){
	if (value == 'Y') {
        return PHA_COM.Fmt.Grid.Yes.Chinese;
    } else {
        return PHA_COM.Fmt.Grid.No.Chinese;
    }
}

function InitGridBusiMain(){
	var columns = [
        [
            // INRowId,PointerMain,BusiType,BusiNo,AuditUser,AuditDate,BusiType,RpAmt
            { field: 'INRowId', 	title: 'INRowId', 		align: 'left', hidden: true },
            { field: 'PointerMain', title: '入库/退货id', 	align: 'left', hidden: true },
            { field: 'BusiType', 	title: '业务类型', 		align: 'center',	width: 80},
            { field: 'BusiNo', 		title: '业务单号',  	align: 'left',	width: 180},
            { field: 'AuditDate', 	title: '审核日期', 		align: 'left',	width: 100},
            { field: 'AuditUser', 	title: '审核人', 		align: 'left',	width: 70},
            { field: 'RpAmt', 		title: '单据金额', 		align: 'right',	width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.InvNoManage.Query',
            QueryName: 'QueryPointerMain',
            INRowId: "",
            ParamsJson:"{}"
        },
        idField: 'INRowId',
        columns: columns,
        toolbar: '#GridBusiMainBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
			        var INRowId=rowData.INRowId
			        var PointerMain = rowData.PointerMain
	                QueryBusiDetail(INRowId,PointerMain);
	            }
	        },
    };
    PHA.Grid('GridBusiMain', dataGridOption);
}

function InitGridBusiDetail(){
	var columns = [
        [
            // inciCode,inciDesc,qty,uomDesc,Rp,Sp,RpAmt,SpAmt
            //{ field: 'RowId', 	title: 'RowId', 	align: 'left',		hidden: true },
            { field: 'inciCode', 	title: '药品代码', 	align: 'left',		width: 100},
            { field: 'inciDesc', 	title: '药品名称',  align: 'left',		width: 300},
            { field: 'qty', 		title: '数量', 		align: 'right',		width: 60},
            { field: 'uomDesc', 	title: '单位', 		align: 'center',	width: 70},
            { field: 'Rp', 			title: '进价', 		align: 'right',		width: 60 },
            { field: 'Sp', 			title: '售价', 		align: 'right',		width: 60 },
            { field: 'RpAmt', 		title: '进价金额', 	align: 'right',		width: 100 },
            { field: 'SpAmt', 		title: '售价金额', 	align: 'right',		width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.InvNoManage.Query',
            QueryName: 'QueryPointerDetail',
            INRowId:   '',
            ConPointerMain:''
            
        },
        //idField: 'Rowid',
        columns: columns,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
	            }
	        },
    };
    PHA.Grid('GridBusiDetail', dataGridOption);
}

function QueryInvNo(){
	ClearGrid();
	var ParamsJson = PHA.DomData('#GridInvNoBar', {
        doType: 'query',
        retType: 'Json'
    });
    if(!ParamsJson.length) return;
    ParamsJson = JSON.stringify(ParamsJson[0]);	
    $('#GridInvNo').datagrid('query', {
        HospId: SessionHosp,
        ParamsJson: ParamsJson
    });
}

function QueryBusiMain(INRowId){
	var ParamsJson = PHA.DomData('#GridBusiMainBar', {
        doType: 'query',
        retType: 'Json'
    });
    if(!ParamsJson.length) return;
    ParamsJson = JSON.stringify(ParamsJson[0]);
	$('#GridBusiMain').datagrid('query', {
        INRowId: INRowId,
        ParamsJson: ParamsJson
    });
}
function QueryBusiDetail(INRowId,PointerMain){
	if(!INRowId) INRowId = ""
	if(!PointerMain) PointerMain = ""
	$('#GridBusiDetail').datagrid('query', {
        INRowId: INRowId,
        ConPointerMain: PointerMain
    });
}

function Clear(){
	PHA.DomData('#GridInvNoBar', {
    	 doType: 'clear',
	 });
	 SetDefault();
	 ClearGrid();
}

function ClearGrid(){
	$('#GridInvNo').datagrid('clearSelections');   // 此事件会刷新表格行选择事件
    $('#GridInvNo').datagrid('clear');
    $('#GridBusiMain').datagrid('clearSelections');   
    $('#GridBusiMain').datagrid('clear');
    $('#GridBusiDetail').datagrid('clearSelections');   
    $('#GridBusiDetail').datagrid('clear');
}

function SaveInv(){
	$('#GridInvNo').datagrid('endEditing');
    var gridChanges = $('#GridInvNo').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Msg("alert","没有需要保存的数据");
        return;
    }
    var paramsStr = '', params = '';
    // LCG ,LCGCode,LCGDesc
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var INRowId=iData.INRowId
        var OriginNo=iData.OriginNo
        var Amt=iData.Amt
        params =[INRowId,OriginNo,Amt].join("^")
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    $.cm(
        {
            ClassName: 'PHA.IN.InvNoManage.Save',
            MethodName: 'Save',
            paramsStr: paramsStr,
            HospId:SessionHosp
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Msg('success' ,'保存成功!' );
				QueryInvNo();
	            return;
            }
            else{
	            PHA.Msg('alert',retData.msg);
	            return
            }
        }
    );
}

function SendInv(){
	var gridSelect = $('#GridInvNo').datagrid('getSelected') || '';
    var INRowId = '';
    if (gridSelect) INRowId = gridSelect.INRowId;
    if (INRowId == '') {
		PHA.Msg("alert","请选择一条发票记录！")
		return;
	}
	
	PHA.Msg("alert","接口暂未接通："+INRowId)
}

function UpdateInvNo(){
	$('#diagUpdateInvNo')
    .dialog({
        iconCls: 'icon-w-edit',
        modal: true,
        onBeforeClose: function () {},
    })
    .dialog('open');
    SetUpDiagDefault();
    $('#GridUpdateInvNoMian').datagrid('clearSelections');   
    $('#GridUpdateInvNoMian').datagrid('clear');
    $('#GridUpdateInvNoDetail').datagrid('clearSelections');   
    $('#GridUpdateInvNoDetail').datagrid('clear');
}

function InitGridUpdateInvNoMian(){
	var columns = [
        [
            // INRowId,PointerMain,BusiType,BusiTypeDesc,BusiNo,AuditUser,AuditDate
            { field: 'PointerMain', title: '入库/退货id', 	align: 'left', 		hidden: true },
            { field: 'BusiType', 	title: '业务类型', 		align: 'center',	hidden: true},
            { field: 'BusiTypeDesc',title: '业务类型', 		align: 'center',	},
            { field: 'PurLocDesc',	title: '采购科室', 		align: 'left',		width: 180},
            { field: 'BusiNo', 		title: '业务单号',  	align: 'left',		width: 180},
            { field: 'AuditUser', 	title: '审核人', 		align: 'left',		width: 90},
            { field: 'AuditDate', 	title: '审核日期', 		align: 'left',		width: 100}
            
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.InvNoManage.Query',
            QueryName: 'QueryIngdMian',
            HospId:"",
            ParamsJson:"{}"
        },
        idField: 'PointerMain',
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {
	        QueryUpDetail();
	        },
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagUpdateInvNoBar',
    };
    PHA.Grid('GridUpdateInvNoMian', dataGridOption);
}

function InitGridUpdateInvNoDetail(){
	var columns = [
        [
            // Pointeri,BusiType,inciCode,inciDesc,qty,uomDesc,Rp,Sp,RpAmt,SpAmt,INVNo,INVNoDate
            { field: 'Pointeri', 	title: 'Pointeri', 	align: 'left',		hidden: true },
            { field: 'BusiType', 	title: '业务类型', 	align: 'center',	hidden: true },
            { field: 'inciCode', 	title: '药品代码', 	align: 'left',		width: 100},
            { field: 'inciDesc', 	title: '药品名称',  align: 'left',		width: 300},
            {
                field: 'INVNo',
                title: '发票号',
                width: 100,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {},
                },
            },
            {
                field: 'INVNoDate',
                title: '发票日期',
                width: 120,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'datebox',
                    options: {},
                },
            },
            { field: 'qty', 		title: '数量', 		align: 'right',		width: 60},
            { field: 'uomDesc', 	title: '单位', 		align: 'center',	width: 70},
            { field: 'Rp', 			title: '进价', 		align: 'right',		width: 60 },
            { field: 'Sp', 			title: '售价', 		align: 'right',		width: 60 },
            { field: 'RpAmt', 		title: '进价金额', 	align: 'right',		width: 100 },
            { field: 'SpAmt', 		title: '售价金额', 	align: 'right',		width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.InvNoManage.Query',
            QueryName: 'QueryIngdDetail',
            INGD	 : "",
	        BusiType : "",
	        WithOutInvNoFlag : ""
        },
        idField: 'Pointeri',
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'INVNo',
            });
        },
        toolbar: '#diagUpdateInvNoDetailBar',
    };
    PHA.Grid('GridUpdateInvNoDetail', dataGridOption);
}

function QueryUpMain(){
	ClearGridi();
	var ParamsJson = PHA.DomData('#diagUpdateInvNoBar', {
        doType: 'query',
        retType: 'Json'
    });
    if(!ParamsJson.length) return;
    ParamsJson = JSON.stringify(ParamsJson[0]);	
    $('#GridUpdateInvNoMian').datagrid('query', {
        HospId: SessionHosp,
        ParamsJson: ParamsJson
    });
}

function ClearGridi(){
	$('#GridUpdateInvNoMian').datagrid('clearSelections');   // 此事件会刷新表格行选择事件
    $('#GridUpdateInvNoMian').datagrid('clear');
    $('#GridUpdateInvNoDetail').datagrid('clearSelections');   
    $('#GridUpdateInvNoDetail').datagrid('clear');
}

function QueryUpDetail(){
	var INGD = "",BusiType = ""
    var gridSelect = $('#GridUpdateInvNoMian').datagrid('getSelected') || '';
    if (gridSelect) {
	    INGD = gridSelect.PointerMain;
	    BusiType = gridSelect.BusiType;
    }
    
    if ((!INGD)||(!BusiType)) return;
    var WithOutInvNoFlag = $('#WithOutInvNoFlag').is(':checked') ? 'Y' : 'N';
    $('#GridUpdateInvNoDetail').datagrid('query', {
        INGD	 : INGD,
        BusiType : BusiType,
        WithOutInvNoFlag:WithOutInvNoFlag
    });
}

function UpdateInv(){
	$('#GridUpdateInvNoDetail').datagrid('endEditing');
    var gridChanges = $('#GridUpdateInvNoDetail').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Msg("alert","没有需要保存的数据");
        return;
    }
    var paramsStr = '', params = '';
    // Pointeri,BusiType,inciCode,inciDesc,qty,uomDesc,Rp,Sp,RpAmt,SpAmt,INVNo,INVNoDate
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var Pointeri=iData.Pointeri
        var BusiType=iData.BusiType
        var INVNo=iData.INVNo
        var INVNoDate=iData.INVNoDate
        if((INVNo==""&&INVNoDate!="")||(INVNo!=""&&INVNoDate=="")){
	        PHA.Msg("alert","发票号和发票日期必须同时存在！");
        	return;
        }
        params =[Pointeri,BusiType,INVNo,INVNoDate].join("^")
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    $.cm(
        {
            ClassName: 'PHA.IN.InvNoManage.Save',
            MethodName: 'UpdateInvNo',
            paramsStr: paramsStr,
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Msg('success' ,'保存成功!' );
				QueryUpDetail();
	            return;
            }
            else{
	            PHA.Msg('alert',retData.msg);
	            return
            }
        }
    );

}
