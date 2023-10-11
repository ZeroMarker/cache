/*
*Creator		zhaozhiduan
*CreatDate		20222-04-26
*Description 	����̵��ѯ
*
*/
var APP_NAME = "DHCSTINSTKTK"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "STKTK";
var BUIS_RANGE = "ALL";
$(function(){
	InitDict();             // ��ʼ�������ֵ�
    InitBtn();              // ��ʼ����ť
    InitGridStktkMain();
	InitGridStktkDetail();
    InitDefVal();
	SetRequired();
	setTimeout(function () {
        PHA_COM.ResizePanel({
            layoutId: 'layout-stktk-itm',
            region: 'west',
            width: 0.25
        });
    }, 0);
})
function SetRequired(){
	PHA.SetRequired($('#gridStktkMainBar' + ' [data-pha]'))
}
function InitDict(){
	//ҩ������
    PHA_UX.ComboBox.Loc('stktkLocId');
	    // ״̬
	PHA.ComboBox('stktkStatus', {
		url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE, "SUM,ADJ,CANCEL").url,
		onLoadSuccess: function(data) {
			if(data.length > 0){
				var iData = data[0];
				$(this).combobox('setValue', iData["RowId"]);
			}
		},

	});
    // ҩƷ�������
	PHA_UX.ComboGrid.INCItm('inci', {
		width: 160,
		qParams: {
			pJsonStr: {
				stkType: App_StkType,
				locId: PHA_UX.Get('stktkLocId', ''),
				scgId: PHA_UX.Get('stkGrpId', '')
			}
		},
		onShowPanel:function(){},
		onHidePanel:function( ){
			var grid = $('#inci').combogrid('grid');	// get datagrid object
			var rowData = grid.datagrid('getSelected');	// get the selected row
			if(typeof(rowData) == "object"){
				var inci = rowData.inci;
				var rowsData = $('#gridStktkWdDetail').datagrid('getData').rows;
				var rows = rowsData.length;
				var dataArr = [];
				for (var i = 0; i < rows; i++) {
					var rowData = rowsData[i];
					var inciId = rowData.inci;
					if(inci == inciId){
						PHA_GridEditor.Edit({
							gridID: "gridStktkWdDetail",
							index: i,
							field: "countBQty"
						});
						return ;
					}
				}
			}
		},
	});
}
function InitDefVal(){
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
	var comboData=$("#stktkStatus").combobox('getData');
	if(comboData.length > 0){
		$("#stktkStatus").combobox('setValue', comboData[0].RowId);
	}
    $HUI.radio('input[name=' + "lossFlag" + '][value=' + "0" + ']').setValue(true);
}
function InitBtn(){
	$('#btnFind').on('click', QueryMain);
	$('#btnClean').on('click', Clean);
	$('#btnFindDetail').on('click', QueryDetail);
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
			{ field: 'curStatus',   title: '״̬',		align: 'left',	width: 80 ,
				styler: function(value,row,index){				
					return {class:"pha-grid-link" };
				}
			},
			{ field: 'curPbDate',   title: 'ִ������',	align: 'left',	width: 100 },
			{ field: 'curPbTime',   title: 'ִ��ʱ��',	align: 'left',	width: 80 },
			{ field: 'curPbUser', 	title: 'ִ����',	align: 'left',	width: 100 },
            /*{ field: 'stkCatDesc',  title: '������',	align: 'left',	width: 100 },
            { field: 'noUseDesc',  	title: 'Ʒ��',		align: 'left',	width: 100 },
            { field: 'manGrpDesc',  title: '�̵���',	align: 'left',	width: 100 },
            { field: 'selManGrpDesc',title: '��/���̵���',	align: 'left',	width: 100 },
            { field: 'manDrgDesc',	title: '����ҩ',	align: 'left',	width: 100 },
            { field: 'stkBinDesc',  title: '��λ',  	align: 'right',	width: 100 },*/
            { field: 'inputType',	title: '�̵㷽ʽ',  align: 'right',	width: 100 ,
				formatter: function (value, rowData, index) {
					if(value==1){
						return $g("������");
					}else if(value==2){
						return $g("��Ʒ��");
					}else if(value==5){
						return $g("<font color=blue>�ƶ���:</font>��Ʒ��");
					}else if(value==6){
						return $g("<font color=blue>�ƶ���:</font>������");
					}else{
						return "";
					}		
				}
			},
            { field: 'newStatusInfo',title: '������ת��Ϣ',	align: 'left',	width: 200 }
        ]
    ];
    var dataGridOption = {
	    gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: '#gridStktkMainBar',
        exportXls: false,
        columns: columns,
        url:PHA.$URL,
        queryParams:{
            pClassName:'PHA.IN.STKTK.Api' ,
            pMethodName:'GetStktkMainList',
            pPlug:'datagrid'
        },
        onSelect: function(rowIndex, rowData) {
	        QueryDetail();
        },
        onLoadSuccess: function (data) {
			$('#gridStktkDetail').datagrid('clear');
            if(data.total>0){
                //$('#gridStktkMain').datagrid("selectRow",0);
            }
			PHA_UX.BusiTimeLine({},{},"close")
        },
        onClickCell: function (index, field, value) {            
			if(field=="curStatus"){
                var rowData = $('#gridStktkMain').datagrid('getData').rows[index];
                PHA_UX.BusiTimeLine({},{
                    busiCode:BUIS_CODE,
                    locId:$("#stktkLoc").combobox("getValue") || PHA_COM.Session.CTLOCID,
                    pointer:rowData.adjId
                });
            }else{
                PHA_UX.BusiTimeLine({},{},"close")
            }
        }
    };
    PHA.Grid('gridStktkMain', dataGridOption);

}
function InitGridStktkDetail(){
	var gridId = 'gridStktkDetail'
    var columns = [
        [
            { field: 'spec', 		title: '���', 				align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '��λ', 				align: 'left', 	width: 80 },
            { field: 'freQty', 		title: '��������',			align: 'right',	width: 100 },
            { field: 'countQty', 	title: 'ʵ������',			align: 'right',	width: 100 },
            { field: 'difQty',		title: '��������', 			align: 'right',	width: 100 ,
				styler:function(value, row, index){
					var difQty = value || "";
					if (difQty > 0){
						return  {class:'pha-datagrid-difqty-positive'}; 
					}else if(difQty < 0){
						return  {class:'pha-datagrid-difqty-negative'}; 
					}
				}
			},
            { field: 'inclbQty',	title: '��������', 			align: 'right',	width: 100 },
            { field: 'freRpAmt', 	title: '���̽��۽��',		align: 'right',	width: 100 },
            { field: 'freSpAmt', 	title: '�����ۼ۽��',		align: 'right',	width: 100 },
            { field: 'countRpAmt', 	title: 'ʵ�̽��۽��',		align: 'right',	width: 100 },
            { field: 'countSpAmt', 	title: 'ʵ���ۼ۽��',		align: 'right',	width: 100 },
            { field: 'difRpAmt', 	title: '���۽�����',		align: 'right',	width: 100 },
            { field: 'difSpAmt', 	title: '�ۼ۽�����',		align: 'right',	width: 100 },
            { field: 'manfDesc', 	title: '������ҵ',			align: 'left',	width: 200 },
            { field: 'insuCode', 	title: '����ҽ������', 		align: 'left',	width: 100 },
            { field: 'insuName', 	title: '����ҽ������', 		align: 'left',	width: 100 },
            { field: 'fac', 		title: '��λת��ϵ��', 		align: 'left',	width: 100, hidden: true}
        ]
    ];
    var frozenColumns = [
        [
        	{ field: 'stktkId',     title: 'stktkId', 			align: 'left',	width: 100, hidden: true },
        	{ field: 'stktkItmId',  title: 'stktkItmId', 		align: 'left',	width: 100, hidden: true },
        	{ field: 'inci',       	title: 'inci', 				align: 'left',	width: 100, hidden: true },
        	{ field: 'inclb',      	title: 'inclb', 			align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '����', 				align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',  			align: 'left',  width: 200, sortable: true},
			{ field: 'uomDesc',    	title: '��λ',  			align: 'left',  width: 80, sortable: true}

        ]
    ];

    var dataGridOption = {
	    bodyCls:'table-splitline',
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridStktkDetailBar',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        url:PHA.$URL,
        queryParams:{
            pClassName:'PHA.IN.STKTK.Api' ,
            pMethodName:'GetDetailForQuery',
            pPlug:'datagrid',
            pJson:{}
        },
        onLoadSuccess: function (data) {
           CalcAmt();
        },
        gridSave: false,
        showFooter: true,
        data:{
	        rows:[],
	    	footer:[{inciCode:'�ϼ�'}],
	    	total:0
	    },
	    loadFilter:function(data){ //�õ����ݺ�Ϊ�ϼ��и�ֵ
	    	if(data.footer){
				data.footer[0] = [];
				data.footer[0]["inciCode"] = "�ϼ�";
	    	}
			return data;
		}
    };
    PHA.Grid(gridId, dataGridOption);
}
function QueryMain(){
	var retJson = PHA.GetVals(["stDate","endDate","stktkLocId","stktkStatus"],"Json");
	if(retJson[0] == undefined) {return;}
	var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#stktkLocId").combobox("getValue") || "";  
	var execFlag =  "Y";
	var stktkStatus = $("#stktkStatus").combobox("getValue")
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stktkStatus = stktkStatus;
	pJson.execFlag = execFlag;
    $("#gridStktkMain").datagrid('query',{
	    pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function QueryDetail(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("��ѡ���̵㵥�ݣ�"))
		return
	}
    var stktkId = Selected.stktkId;
    var lossFlag = $('input[name="lossFlag"]:checked').val() || '';
    var freQtyUnZero = $("#freQtyUnZero").checkbox("getValue") || "";
	if (freQtyUnZero == true){freQtyUnZero = "Y";}
	else{freQtyUnZero = "";}
    var countQtyUnZero = $("#countQtyUnZero").checkbox("getValue") || "";
	if (countQtyUnZero == true){countQtyUnZero = "Y";}
	else{countQtyUnZero = "";}
    var inci = $("#inci").combobox("getValue") || "";
    var pJson = {};
    pJson.stktkId = stktkId;  
    pJson.lossFlag = lossFlag;  
    pJson.freQtyUnZero = freQtyUnZero;  
    pJson.countQtyUnZero = countQtyUnZero;  
    pJson.inci = inci;  
    $("#gridStktkDetail").datagrid('query',{
	    pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function Export(){}
function Clean(){
	PHA.DomData("#qCondition", {
        doType:'clear'
    })
	$('#gridStktkMain').datagrid('clear');
    $('#gridStktkDetail').datagrid('clear');
    $('#stktkLocId').combobox('setValue', PHA_COM.Session.CTLOCID);

    $HUI.radio('input[name=' + "lossFlag" + '][value=' + "0" + ']').setValue(true);
    $('#freQtyUnZero').checkbox('setValue', false);
    $('#countQtyUnZero').checkbox('setValue', false);
    $('#inci').combobox('setValue', "");
	InitDefVal();
}
function CalcAmt(){
	var $grid = $('#gridStktkDetail');
	var rowsData = $grid.datagrid('getRows');
    var rows = rowsData.length;
    if(rows ==0) {return;}
    var dataArr = [];
    var totalFreRpAmt = 0;
    var totalFreSpAmt = 0;
    var totalCountRpAmt = 0;
    var totalCountSpAmt = 0;
    var totalDifRpAmt = 0;
    var totalDifSpAmt = 0;
    
    var rowsFooter = $grid.datagrid('getFooterRows');
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var freRpAmt = rowData.freRpAmt;
		var freSpAmt = rowData.freSpAmt;
		var countRpAmt = rowData.countRpAmt;
		var countSpAmt = rowData.countSpAmt;
		var difRpAmt = rowData.difRpAmt;
		var difSpAmt = rowData.difSpAmt;

		if (isNaN(freRpAmt)){freRpAmt = 0;}
		if (isNaN(freSpAmt)){freSpAmt = 0;}
		if (isNaN(countRpAmt)){countRpAmt = 0;}
		if (isNaN(countSpAmt)){countSpAmt = 0;}
		if (isNaN(difRpAmt)){difRpAmt = 0;}
		if (isNaN(difSpAmt)){difSpAmt = 0;}
		totalFreRpAmt = _.add(totalFreRpAmt, freRpAmt);
		totalFreSpAmt = _.add(totalFreSpAmt, freSpAmt);
		totalCountRpAmt = _.add(totalCountRpAmt, countRpAmt);
		totalCountSpAmt = _.add(totalCountSpAmt, countSpAmt);
		totalDifRpAmt = _.add(totalDifRpAmt, difRpAmt);
		totalDifSpAmt = _.add(totalDifSpAmt, difSpAmt);

    }
	rowsFooter[0]['freRpAmt'] = PHA_COM.Fmt.Grid.Number(totalFreRpAmt,"#0,000.00");
	rowsFooter[0]['freSpAmt'] = PHA_COM.Fmt.Grid.Number(totalFreSpAmt,"#0,000.00");
	rowsFooter[0]['countRpAmt'] = PHA_COM.Fmt.Grid.Number(totalCountRpAmt,"#0,000.00");
	rowsFooter[0]['countSpAmt'] = PHA_COM.Fmt.Grid.Number(totalCountSpAmt,"#0,000.00"); 
	rowsFooter[0]['difRpAmt'] = PHA_COM.Fmt.Grid.Number(totalDifRpAmt,"#0,000.00");
	rowsFooter[0]['difSpAmt'] = PHA_COM.Fmt.Grid.Number(totalDifSpAmt,"#0,000.00");
	rowsFooter[0]['inciDesc'] = $g("��") + rows +$g("����¼");
	$grid.datagrid('reloadFooter');

}

function ChangeRecordInfo(rowIndex, rowData, bQty, pQty){
	var $grid = $('#gridStktkDetail');
	var stktkItmId = rowData.stktkItmId ;
	var fac = rowData.fac ; 
	var freQty = rowData.freQty
	var countQty = _.add(bQty, pQty *fac)
	var difQty = countQty - freQty ;
	var freSpAmt = rowData.freSpAmt ; 
	var freRpAmt = rowData.freRpAmt;
	var oldCountSpAmt = rowData.countSpAmt ; 
	var oldCountRpAmt = rowData.countRpAmt ; 
	var oldDifSpAmt = rowData.difSpAmt ; 
	var oldDifRpAmt = rowData.difRpAmt ;
	var rp = rowData.rp ;
	var sp = rowData.sp ;
	var newCountSpAmt = countQty * sp ;
	var newCountRpAmt = countQty * rp ;
	var newDifSpAmt = newCountSpAmt - freSpAmt ;
	var newDifRpAmt = newCountRpAmt - freRpAmt ;
	var Data = {};
	Data.countSpAmt = newCountSpAmt
	Data.countRpAmt = newCountRpAmt
	Data.difSpAmt = newDifSpAmt
	Data.difRpAmt = newDifRpAmt
	Data.countQty = countQty
	Data.difQty = difQty
	$grid.datagrid('updateRowData', {
		index: rowIndex,
		row: Data
	});
	var rowsFooter = $grid.datagrid('getFooterRows');

	$grid.datagrid('reloadFooter');
	rowsFooter[0]['countRpAmt'] = rowsFooter[0]['countRpAmt'] - oldCountRpAmt + newCountRpAmt
	rowsFooter[0]['countSpAmt'] = rowsFooter[0]['countSpAmt'] - oldCountSpAmt + newCountSpAmt
	rowsFooter[0]['difRpAmt'] = rowsFooter[0]['difRpAmt'] - oldDifRpAmt + newDifRpAmt
	rowsFooter[0]['difSpAmt'] = rowsFooter[0]['difSpAmt'] - oldDifRpAmt + newDifRpAmt
	$grid.datagrid('reloadFooter');

	var pJson = {};
	pJson.stktkItmId = stktkItmId ;
	pJson.bQty = bQty ;
	pJson.userId = session['LOGON.USERID']; 
	pJson.countQty = countQty ;
	PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'UpdateItmForAdj',
		pJson: JSON.stringify(pJson)
	},function(data) {
		
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}