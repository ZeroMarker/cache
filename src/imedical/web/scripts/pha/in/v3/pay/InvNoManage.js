/**
 * ģ��:     �������-��Ʊ����
 * ��д����: 2021-05-14
 * ��д��:   yangsj
 */
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var cmbWidth 	= 100;
var cmbWidth2 	= 150;
$(function () {
    InitDict();				//��ʼ���ֵ�
    InitGrid();				//��ʼ��grid
    SetDefault();			//����Ĭ��ֵ
    InitConditionFold();    //�����۵�
});

//�����۵�
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
	//�ɹ�����
	PHA.ComboBox('PurLoc', {
        width: cmbWidth2,
        url: PHA_STORE.GetGroupDept().url,
    });
    PHA.ComboBox('UpPurLoc', {
        width: cmbWidth2,
        url: PHA_STORE.GetGroupDept().url,
    });
    
	//��Ʊ״̬
    PHA.ComboBox('InvState', {
        panelHeight: 'auto',
        width: cmbWidth2,
        data: [
            {
                RowId: "",
                Description: $g('ȫ��'),
            },
            {
                RowId: $g('WAYBILL'),
                Description: $g('��Ʊͬ��'),
            },
            {
                RowId: $g('NOTWAYBILL'),
                Description: $g('����Ʊδ��'),
            },
        ]
    });
    //ҵ������
    var BusiData = [
            {
                RowId: "",
                Description: $g('ȫ��'),
            },
            {
                RowId: $g('G'),
                Description: $g('���'),
            },
            {
                RowId: $g('R'),
                Description: $g('�˻�'),
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
    
   //��Ӫ��ҵ
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
            { field: 'InvNo', 		title: '��Ʊ��',  	align: 'left',		width: 90},
            {
                field: 'OriginNo',
                title: '��Ʊ����',
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
            { field: 'InvDate', 	title: '��Ʊ����',  align: 'center',	width: 90},
            {
                field: 'Amt',
                title: '��Ʊ���',
                width: 70,
                halign: 'center',
                align: 'right',
                editor: {
                    type: 'numberbox',
                    options:{precision:2}
                }
            },
            { field: 'RpAmt', 		title: 'ʵ�ʽ��', 	align: 'right',		width: 70 },
            { field: 'InvState', 	title: '��Ʊ״̬', 	align: 'center',	width: 90 ,		styler:StatuiStyler,},
            { field: 'SendFlag', 	title: 'ͬ��״̬', 	align: 'center',	width: 70 ,		formatter:YNformatter},
            { field: 'PurLocDesc', 	title: '�ɹ�����', 	align: 'left',		width: 120 },
            { field: 'VendorDesc', 	title: '��Ӫ��ҵ', 	align: 'left',		width: 180 },
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
         case '��Ʊͬ��':
             colorStyle = 'background:#a4c703;color:white;';
             break;
         case '����Ʊδ��':
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
            { field: 'PointerMain', title: '���/�˻�id', 	align: 'left', hidden: true },
            { field: 'BusiType', 	title: 'ҵ������', 		align: 'center',	width: 80},
            { field: 'BusiNo', 		title: 'ҵ�񵥺�',  	align: 'left',	width: 180},
            { field: 'AuditDate', 	title: '�������', 		align: 'left',	width: 100},
            { field: 'AuditUser', 	title: '�����', 		align: 'left',	width: 70},
            { field: 'RpAmt', 		title: '���ݽ��', 		align: 'right',	width: 100 },
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
            { field: 'inciCode', 	title: 'ҩƷ����', 	align: 'left',		width: 100},
            { field: 'inciDesc', 	title: 'ҩƷ����',  align: 'left',		width: 300},
            { field: 'qty', 		title: '����', 		align: 'right',		width: 60},
            { field: 'uomDesc', 	title: '��λ', 		align: 'center',	width: 70},
            { field: 'Rp', 			title: '����', 		align: 'right',		width: 60 },
            { field: 'Sp', 			title: '�ۼ�', 		align: 'right',		width: 60 },
            { field: 'RpAmt', 		title: '���۽��', 	align: 'right',		width: 100 },
            { field: 'SpAmt', 		title: '�ۼ۽��', 	align: 'right',		width: 100 },
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
	$('#GridInvNo').datagrid('clearSelections');   // ���¼���ˢ�±����ѡ���¼�
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
        PHA.Msg("alert","û����Ҫ���������");
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
	            PHA.Msg('success' ,'����ɹ�!' );
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
		PHA.Msg("alert","��ѡ��һ����Ʊ��¼��")
		return;
	}
	
	PHA.Msg("alert","�ӿ���δ��ͨ��"+INRowId)
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
            { field: 'PointerMain', title: '���/�˻�id', 	align: 'left', 		hidden: true },
            { field: 'BusiType', 	title: 'ҵ������', 		align: 'center',	hidden: true},
            { field: 'BusiTypeDesc',title: 'ҵ������', 		align: 'center',	},
            { field: 'PurLocDesc',	title: '�ɹ�����', 		align: 'left',		width: 180},
            { field: 'BusiNo', 		title: 'ҵ�񵥺�',  	align: 'left',		width: 180},
            { field: 'AuditUser', 	title: '�����', 		align: 'left',		width: 90},
            { field: 'AuditDate', 	title: '�������', 		align: 'left',		width: 100}
            
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
            { field: 'BusiType', 	title: 'ҵ������', 	align: 'center',	hidden: true },
            { field: 'inciCode', 	title: 'ҩƷ����', 	align: 'left',		width: 100},
            { field: 'inciDesc', 	title: 'ҩƷ����',  align: 'left',		width: 300},
            {
                field: 'INVNo',
                title: '��Ʊ��',
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
                title: '��Ʊ����',
                width: 120,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'datebox',
                    options: {},
                },
            },
            { field: 'qty', 		title: '����', 		align: 'right',		width: 60},
            { field: 'uomDesc', 	title: '��λ', 		align: 'center',	width: 70},
            { field: 'Rp', 			title: '����', 		align: 'right',		width: 60 },
            { field: 'Sp', 			title: '�ۼ�', 		align: 'right',		width: 60 },
            { field: 'RpAmt', 		title: '���۽��', 	align: 'right',		width: 100 },
            { field: 'SpAmt', 		title: '�ۼ۽��', 	align: 'right',		width: 100 },
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
	$('#GridUpdateInvNoMian').datagrid('clearSelections');   // ���¼���ˢ�±����ѡ���¼�
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
        PHA.Msg("alert","û����Ҫ���������");
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
	        PHA.Msg("alert","��Ʊ�źͷ�Ʊ���ڱ���ͬʱ���ڣ�");
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
	            PHA.Msg('success' ,'����ɹ�!' );
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
