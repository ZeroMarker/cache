/*
/// Creator     zhaozhiduan
/// CreatDate   2022��03��11��
/// Description ����̵�����
*/
var APP_NAME = "DHCSTINSTKTK"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "STKTK"
var BUIS_RANGE = "CREATE";

var compoments = STKTK_COMPOMENTS;
$(function(){
    PHA_COM.SetPanel('#panel');
    InitDict();             // ��ʼ�������ֵ�
    InitGridMStktkDetail();   // ��ʼ��grid
    InitBtn();              // ��ʼ����ť
    // dialog ��ʼ��
    InitGridStktkMain();
    InitGridStktkDetail();
    SetDisable();
    SetRequired();
    setTimeout(function () {
		PHA_COM.ResizePanel({
		   layoutId: 'layout-stktk-create-diag',
		   region: 'north',
		   height: 0.5 
	   });
   }, 0);
   InitConditionFold();
})

//�����۵�
function InitConditionFold()
{
	PHA.ToggleButton("moreorless", {
        buttonTextArr: ['����', '����'],
        selectedText: '����',
        onClick: function(oldText, newText){
        }	
    });	

    $("#moreorless").popover({
        trigger: 'click',	
        placement: 'auto',
        content: 'content',
        dismissible: false,
        width: 900,
        padding: false,
        url: '#js-pha-moreorless'
    });
}

function SetRequired(){
	PHA.SetRequired($('#gridMStktkDetailBar' + ' [data-pha]'))
}
function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 		'click', 	function () {ShowDiagStktk(this);});
	PHA_EVENT.Bind('#btnSave', 		'click', 	function () {SaveStktk();});
	PHA_EVENT.Bind('#btnClean', 	'click', 	function () {Clean();});
    PHA_EVENT.Bind('#btnPreStktk', 	'click', 	function () {QueryPreStktk();});
	PHA_EVENT.Bind('#btnComplete', 	'click', 	function () {Complete();});
    PHA_EVENT.Bind('#btnCancelComp','click', 	function () {CancelComplete();});
	PHA_EVENT.Bind('#btnPrint', 	'click', 	function () {Print();});
    PHA_EVENT.Bind('#btnDelete', 	'click', 	function () {Delete();});
    // dialog ��ť
    PHA_EVENT.Bind('#btnSearch', 	'click', 	function () {QueryMain();});
	PHA_EVENT.Bind('#btnClose', 	'click', 	function () {CloseDiag();});
    PHA_EVENT.Bind('#btnSelStktk', 	'click', 	function () {SelectStktk();});

    //��ӡ����
    PHA_EVENT.Bind('#btnPrtStktk', 	'click', 	function () {PrtStktk();});
    PHA_EVENT.Bind('#btnCloseDiag', 'click', 	function () {ClosePrtDiag();});
}


function InitDict(){
	//ҩ������
    PHA_UX.ComboBox.Loc('stktkLocId',{});
    
	//����
	PHA_UX.ComboBox.StkCatGrp('stkGrpId', {
        multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('stktkLocId', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	//������
	PHA_UX.ComboBox.StkCat("stkCatId",{
        multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		qParams: {
			CatGrpId: PHA_UX.Get('stkGrpId')
		}
	});
	var locId = $("#stktkLocId").combobox("getValue") || PHA_COM.Session.CTLOCID
   
    // �����̵���
    PHA_UX.ComboBox.StkTkGrp('manGrpId', {
	    multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		qParams: {
			Loc: PHA_UX.Get('stktkLocId', session['LOGON.CTLOCID']),
		}
	});
     //��ʼ��λ
    PHA_UX.ComboBox.StkBinRacks('stkbinId', {
        multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        qParams: {
            LocId: PHA_UX.Get('stktkLocId',session['LOGON.CTLOCID']) ,
        }
    });
    //����ҩ��־
    var comboData=[
    	{RowId:"",Description:$g("ȫ��")},
		{RowId:"Y",Description:$g("������ҩ")},
    	{RowId:"N",Description:$g("�ǹ���ҩ")}
	];
	PHA.ComboBox('manDrgFlag', {
	    valueField:'RowId',
		textField:'Description',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        data:comboData
    });
    //������ҩƷ
    var comboData=[
    	{RowId:"0",Description:$g("������Ʒ��")},
		{RowId:"1",Description:$g("��������Ʒ��")},
		{RowId:"2",Description:$g("����������Ʒ��")}

	];
	PHA.ComboBox('noUseFlag', {
	    valueField:'RowId',
		textField:'Description',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        data:comboData
    });
    //���ο��
    var comboData=[
    	{RowId:"",Description:$g("ȫ��")},
		{RowId:"Y",Description:$g("��������")},
    	{RowId:"N",Description:$g("������")}
	];
	PHA.ComboBox('inclbQtyFlag', {
	    valueField:'RowId',
		textField:'Description',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        data:comboData
    });
     //���ο��
    var comboData=[
    	{RowId:"Y",Description:$g("ѡ���̵���")},
		{RowId:"N",Description:$g("��ѡ���̵���")}
	];
	PHA.ComboBox('selManGrp', {
	    valueField:'RowId',
		textField:'Description',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        data:comboData
    });
    PHA.ComboBox('stktkStatus', {
	    valueField:'RowId',
		textField:'Description',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE).url,
        onLoadSuccess: function(data) {
			if(data.length > 0){
				var iData = data[0];
				$(this).combobox('setValue', iData["RowId"]);
			}
		},

    });
    /* ��Ϣչʾ�� */
	$('#infoArea').phabanner({
	    title: $g('ѡ�񵥾ݺ�, ��ʾ��ϸ��Ϣ')
	});
    // dialog ҩ������
    //ҩ������
    PHA_UX.ComboBox.Loc('phLoc');
	InitDefVal();

    //��ӡ����
    //��ʼ��λ
	PHA_UX.ComboBox.StkBinRacks('prtStkbin', {
        multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        qParams: {
            LocId: PHA_UX.Get('phLoc',session['LOGON.CTLOCID']) ,
        }
    }) ;
    /* ����ʽ */
    compoments.OrderType('orderType');
        
}
function InitDefVal(){
	$("#manDrgFlag").combobox("setValue", "");
	$("#noUseFlag").combobox("setValue", "0");
	$("#inclbQtyFlag").combobox("setValue", "");  
	$("#selManGrp").combobox("setValue", "Y");    
   
}

function InitGridMStktkDetail(){
    var gridId = 'gridMStktkDetail'
    var columns = [
        [
            { field: 'spec', 		title: '���', 			align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '��λ', 			align: 'left', 	width: 80 },
            { field: 'pFreQty', 	title: '�̵�����',		align: 'right',	width: 80},
            { field: 'pUomDesc',	title: '��λ', 			align: 'left',	width: 80 },
            { field: 'batNo', 		title: '����',			align: 'left',	width: 100 },
            { field: 'expDate', 	title: 'Ч��',			align: 'left',	width: 80 },
            { field: 'pRp', 		title: '����(���)',	align: 'right',	width: 100 },
            { field: 'pSp', 		title: '�ۼ�(���)',	align: 'right',	width: 100 },
            { field: 'freRpAmt', 	title: '���۽��',		align: 'right',	width: 100 },
            { field: 'freSpAmt', 	title: '�ۼ۽��',		align: 'right',	width: 100 },
            { field: 'manfDesc', 	title: '������ҵ',		align: 'left',	width: 250 },
            { field: 'insuCode', 	title: '����ҽ������', 	align: 'left',	width: 100 },
            { field: 'insuName', 	title: '����ҽ������', 	align: 'left',	width: 100 }
        ]
    ];
    var frozenColumns = [
        [
        	{ field: 'inci',       	title: 'inci', 			align: 'left',	width: 100, hidden: true },
        	{ field: 'inclb',       title: 'inclb', 		align: 'left',	width: 100, hidden: true },
            { field: 'stktkItmId',  title: 'stktkItmId',	align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '����', 			align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',  		align: 'left',  width: 300, sortable: true}
        ]
    ];

    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: true,
        pageNumber:1,
        pageSize: 100,
        pageList: [100,300, 500, 1000], // 100��
        
        toolbar: '#gridMStktkDetailBar',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        loadFilter:PHA.LocalFilter,
        onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
            CalcAmt();
        },
        showFooter: true,
        
    };
    PHA.Grid(gridId, dataGridOption);
	
	
}
function InitGridStktkMain(){
    var columns = [
        [
            { field: 'stktkId',		title: '����id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'stktkNo',		title: '����',		align: 'left',	width: 160 },
            { field: 'stktkLocId',  title: '����id',	align: 'left',	width: 100,	hidden: true  },
            { field: 'stktkLocDesc',title: '����',		align: 'left',	width: 100 },
            { field: 'stktkDate',   title: '�Ƶ�����',  align: 'left',	width: 100 },
            { field: 'stktkTime',   title: '�Ƶ�ʱ��',  align: 'left',	width: 100 },
            //{ field: 'stkGrpId',  	title: '����',		align: 'left',	width: 100,	hidden: true   },
            //{ field: 'stkGrpDesc',  title: '����',		align: 'left',	width: 100 },
            { field: 'curStatus',   title: '״̬',		align: 'left',	width: 80 },
            { field: 'curPbDate',   title: '״̬��������',	align: 'left',	width: 100 },
            { field: 'curPbTime',   title: '״̬����ʱ��',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	title: '״̬������',	align: 'left',	width: 100 },
            { field: 'stkCatDesc',  title: '������',	align: 'left',	width: 100 },
            { field: 'noUseDesc',  title: 'Ʒ��',		align: 'left',	width: 100 },
            { field: 'manGrpDesc',  title: '�̵���',	align: 'left',	width: 100 },
            { field: 'selManGrpDesc',title: '��/���̵���',	align: 'left',	width: 100 },
            { field: 'manDrgDesc',	title: '����ҩ',	align: 'left',	width: 100 },
            { field: 'stkBinDesc',  title: '��λ',  	align: 'right',	width: 100 },
            { field: 'newStatusInfo',title: '������ת��Ϣ',	align: 'left',	width: 200 }
        ]
    ];
    var dataGridOption = {
	    gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridStktkMainBar',
        exportXls: false,
        columns: columns,
        onSelect: function(rowIndex, rowData) {
            QueryDetail()
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                SelectStktk()
            }
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridStktkMain').datagrid("selectRow",0);
            }else{
                $('#gridStktkDetail').datagrid('clear');
	        }
        }
        
    };
    PHA.Grid('gridStktkMain', dataGridOption);
}
function InitGridStktkDetail(){
    var columns = [
        [
            { field: 'spec',        title: '���',			align: 'left',  width: 80 },
            { field: 'stkbinDesc',  title: '��λ',			align: 'left',  width: 80 },
            { field: 'pFreQty', 	title: '�̵�����',		align: 'right',	width: 80},
            { field: 'pUomDesc',	title: '��λ', 			align: 'left',	width: 80 },
            { field: 'batNo',       title: '����',			align: 'left',  width: 100 },
            { field: 'expDate',     title: 'Ч��',			align: 'left',  width: 100 },
            { field: 'pRp',         title: '����(���)',	align: 'right', width: 100 },
            { field: 'pSp',         title: '�ۼ�(���)',	align: 'right', width: 100 },
            { field: 'freRpAmt', 	title: '���۽��',		align: 'right', width: 100 },
            { field: 'freSpAmt',    title: '�ۼ۽��',		align: 'right', width: 100 },
            { field: 'manfDesc',    title: '������ҵ',      align: 'left',  width: 250 },
            { field: 'insuCode',    title: '����ҽ������',	align: 'left',  width: 100 },
            { field: 'insuName',    title: '����ҽ������',	align: 'left',  width: 100 }
        ]
    ];
    var frozenColumns = [
        [
            { field: 'inclb',       title: 'inclb',         align: 'left',  width: 100, hidden: true },
            { field: 'stktkItmId',  title: 'stktkItmId',    align: 'left',  width: 100, hidden: true },
            { field: 'inciCode',    title: '����',			align: 'left',  width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',			align: 'left',  width: 300, sortable: true}
        ]
    ]
    var dataGridOption = {
	    gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: [],
        exportXls: false,
        columns: columns,
        frozenColumns: frozenColumns
    };
    PHA.Grid('gridStktkDetail', dataGridOption);

}
function ShowDiagStktk(btnOpt){
	$('#diagFindStktk').dialog({
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            modal: true
    }).dialog('open');
    $('#gridStktkMain').datagrid('clear');
    $('#gridStktkDetail').datagrid('clear');
    
    var locId =  $("#stktkLocId").combobox("getValue") || PHA_COM.Session.CTLOCID
    $('#phLoc').combobox('setValue', locId);
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
}
function CheckIfCompleted(){
    var tipFlag = APP_PROP.IfCompleted;
    if(tipFlag != "Y" ) return true; 
    var locId = $("#stktkLocId").combobox("getValue") || "";
    var pJson= {
        locId :locId
    }
    var retVal = PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'CheckIfCompleted',
		pJson: JSON.stringify(pJson)
	},false)
    if(retVal.data != ""){
        PHA.Msg("info", $g("����δ��ɵ��ݣ���鿴��")+ "<span>" + retVal.data +"</span>")
        return false;
    }else{
        return true;
    }
    
    
}
function SaveStktk(){
    if(CheckIfCompleted() != true ){return;}
	var retJson = PHA.GetVals(["stktkLocId","stkGrpId","stkbinId","noUseFlag","stkCatId","manDrgFlag","inclbQtyFlag","manGrpId","selManGrp"],"Json")
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID'];  
	PHA.Loading("Show");
    PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'SaveData',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetStktkMainInfo(data.data);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 

}
function Clean()
{
    PHA.DomData("#qCondition", {
        doType:'clear'
    })
    PHA.DomData("#js-pha-moreorless", {
        doType:'clear'
    })
    
    $('#gridMStktkDetail').datagrid('clear');
    PHA.SetVals([{ 
		stktkLocId  : session['LOGON.CTLOCID'],
	}]);
    $('#infoArea').phabanner('loadData', []);
    SetDisable();
    InitDefVal();
}
function Complete(){	
	var pJson = {}
	var stktkId = $('#stktkId').val();
	if (stktkId == ""){
		PHA.Msg("info", "��ѡ���̵㵥�ݺ���ɣ�")
		return;
	}
	pJson.stktkId = stktkId;
    pJson.compFlag = "Y";
	pJson.userId = session['LOGON.USERID'];  
	PHA.Loading('Show')
	PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'SetComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetStktkMainInfo(stktkId);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})  	

}
function CancelComplete(){
    PHA.Loading('Show')
    var pJson = {}
    var stktkId = $('#stktkId').val();
    pJson.stktkId = stktkId;
    pJson.compFlag = "N";
    pJson.userId = session['LOGON.USERID'];
    PHA.CM({
        pClassName: 'PHA.IN.STKTK.Api',
        pMethodName: 'CancelComplete',
        pJson: JSON.stringify(pJson)
    },function(data) {
        PHA.Loading("Hide");
        if(PHA.Ret(data)){
            GetStktkMainInfo(stktkId);;
        }
    },function(failRet){
        PHA_COM._Alert(failRet);
    }) 
    
}
function PrtStktk(){
    var stktkId = $('#stktkId').val();
    var printFlag = $('input[name="printModel"]:checked').val() || '';
    var stkbinIdStr =  $("#prtStkbin").combobox("getValues").join(",");
    var orderType = $("#orderType").combobox("getValue");
    
    var othJson = {}
    othJson.stkbinId = stkbinIdStr; 
    othJson.orderType = orderType;
    $('#diagPrintModel').dialog('close');    
    PrintStktk(stktkId, printFlag, othJson);
}
function ClosePrtDiag(){
    $('#diagPrintModel').dialog('close');
}
function Print(){
	var stktkId = $('#stktkId').val();
	if (stktkId == ""){
		PHA.Msg("info", "��ѡ���̵㵥�ݺ��ӡ��")
		return;
	}
	$('#diagPrintModel').dialog('open');
	$("#orderType").combobox('setValue', 'CODE');
}
function Delete(){
	// ɾ��ȷ��
    var stktkId = $('#stktkId').val();
    if (stktkId == ""){
        $('#gridMStktkDetail').datagrid('clear');
            return;
    }
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ�����̵㵥?", function () {
	    var pJson = {}	
        PHA.Loading('Show')
		pJson.stktkId = stktkId
		PHA.CM({
			pClassName: 'PHA.IN.STKTK.Api',
			pMethodName: 'Delete',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			if(PHA.Ret(data)){
				Clean();
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) ;
	}); 
}
function QueryMain(){
    var $grid = $("#gridStktkMain");
    $('#gridStktkDetail').datagrid('clear');
    var retJson = PHA.GetVals(["stDate","endDate","phLoc"],"Json");
	if(retJson[0] == undefined) {return;}
    var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#phLoc").combobox("getValue") || "";  
    var stktkStatus = $("#stktkStatus").combobox("getValues").join(",");
    if(stktkStatus == ""){
		var comboData=$("#stktkStatus").combobox('getData');
		for(var i = 0; i < comboData.length; i++){
			if(stktkStatus == "") {stktkStatus=comboData[i].RowId;}
			else{stktkStatus=stktkStatus + "," + comboData[i].RowId;}
		}
	}    
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stktkStatus = stktkStatus;
    pJson.execFlag = "Y"
    
    $grid.datagrid('options').url = PHA.$URL;
	$grid.datagrid('query',{
		pClassName:'PHA.IN.STKTK.Api' ,
        pMethodName:'GetStktkMainList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    });  
    
    
}
function QueryDetail(){
    var  $grid = $("#gridStktkDetail");
    var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var stktkId = Selected.stktkId;
    var pJson = {};
    pJson.stktkId = stktkId;    
    $grid.datagrid('options').url = PHA.$URL;
	$grid.datagrid('query',{
		pClassName:'PHA.IN.STKTK.Api' ,
        pMethodName:'GetStktkDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    });  
   
}

function QueryPreStktk(){
    var $grid = $("#gridMStktkDetail");
    $('#stktkId').val("");
	var retJson = PHA.GetVals(["stktkLocId","stkGrpId","stkbinId","noUseFlag","stkCatId","manDrgFlag","inclbQtyFlag","manGrpId","selManGrp"],"Json")

    $grid.datagrid('clear');
    $('#infoArea').phabanner('loadData', []);
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID']; 
    PHA.CM({
            pClassName: 'PHA.IN.STKTK.Api',
            pMethodName: 'GetPreStktkDetail',
            pPlug:'datagrid',
            pJson: JSON.stringify(pJson)
        },function(data){
            $grid.datagrid('loadData', data);
            SetDisable();
        }
    );

}
function SelectStktk(){
    var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var stktkId = Selected.stktkId;
    CloseDiag();
	GetStktkMainInfo(stktkId);
	
   
}
// ��ȡ����������
function GetStktkMainInfo(stktkId)
{
    var $grid = $("#gridMStktkDetail");
	var pJson = {};
    pJson.stktkId = stktkId; 
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'GetStktkMainInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
            var locId = data[0].locId || '' ;
            var locDesc = data[0].locDesc || '' ;
            data[0].locId = {
                RowId: locId,
                Description:locDesc,
                Select: false
            }
            var stkGrpId = data[0].stkGrpId || '' ;
            var stkGrpDesc = data[0].stkGrpDesc || '' ;
            /*data[0].stkGrpId = {
                RowId: stkGrpId.split(','),
                Description:stkGrpDesc,
                Select: false
            }*/
            data[0].stktkLocId = {
                RowId: data[0].stktkLocId,
                Description:data[0].stktkLocDesc,
                Select: false
            }
			PHA.SetVals(data,"#qCondition");
			SetDisable();
            SetInfoArea(data);
            PHA.CM({
                    pClassName: 'PHA.IN.STKTK.Api',
                    pMethodName: 'GetStktkDetail',
                    pPlug:'datagrid',
                    pJson: JSON.stringify(pJson)
                },function(gridData){
                    $grid.datagrid('loadData', gridData);
                }
            );
		}else{
			PHA_COM._Alert(failRet);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}

function CloseDiag(){
    $('#diagFindStktk').dialog('close');
}

// ��ť������
function SetDisable(flag)
{	if(flag == undefined){
		var flag = $("#compFlag").checkbox("getValue");
	}
	var stktkId = $('#stktkId').val() || "";
	if(stktkId == ""){
		$("#stktkLocId").combobox('enable'); 
	}else{
		$("#stktkLocId").combobox('disable'); 
	}
    PHA_COM.ControlOperation({
		'#btnCancelComp': {
			disabled : flag != true,
			hide: flag != true
		},
		'#btnComplete': {
			disabled : flag == true,
			hide: flag == true
		},
		'#btnDelete': {
			disabled : flag == true
		},
		'#btnSave': {
			disabled : (stktkId != "")
		},
		'#btnPrint': {
			disabled : (stktkId == "")
		}
	});

}


function CalcAmt(){
    PHA_COM.SumGridFooter('#gridMStktkDetail' , ['freRpAmt', 'freSpAmt']);
}
function SetInfoArea(retData){
	var dataArr = [
	  {
	    info: retData[0].stktkNo ,
	    append: '/'
	  },
	  {
	    prepend: $g("�Ƶ�") + ":" ,
	    info: retData[0].userName + ' ' + retData[0].stktkDate+ ' ' + retData[0].stktkTime,
	    append: '/'
	  },
	  {
	    info:retData[0].compFlag == "Y" ? $g("�������"): $g("δ�������"),
	    labelClass: retData[0].compFlag == "Y" ? 'info' : 'danger'
	  }
	];
	
	$('#infoArea').phabanner('loadData', dataArr);

}