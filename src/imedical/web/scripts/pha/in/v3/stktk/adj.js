/*
*Creator		zhaozhiduan
*CreatDate		20222-04-26
*Description 	���ʵ��¼�����
*
*/
var APP_NAME = "DHCSTINSTKTK"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "STKTK";
var BUIS_RANGE = "AUDIT";
var compoments = STKTK_COMPOMENTS;
PHA_COM.VAR ={
	OPER:{
		opType:""
	}
};
$(function(){
	InitDict();             // ��ʼ�������ֵ�
    InitBtn();              // ��ʼ����ť
    InitGridStktkMain();
	InitGridStktkDetail();
    InitDefVal();
	SetRequired();
	setTimeout(function () {
        PHA_COM.ResizePanel({
            layoutId: 'layout-stktk-adj',
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
		url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE, "ADJ").url,
		onLoadSuccess: function(data) {
			if(data.length > 0){
				var iData = data[0];
				$(this).combobox('setValue', iData["RowId"]);
			}
		}
	});
	
	/* ��ʱ����"����" ѡ�� ���ӳٵĻ�store��δ�������*/
	setTimeout(function(){
		if(APP_PROP.AdjWithSum != "Y") return;
		var data = $("#stktkStatus").combobox("getData")
		var sumOption = {
			"RowId" : "SUM",
			"Description" : "����"
		}
		data.push(sumOption)
		$("#stktkStatus").combobox("loadData", data)
		/* ���ػ��ܰ�ť */
	}, 500);
	
	/* ������ܻ��ܣ������ػ��ܰ�ť */
	if(APP_PROP.AdjWithSum != "Y") $('#btnDirectSum').hide();
	
	$("#qText").on('keyup', function(e){
		if (e.keyCode==13) QueryDetail();
	});
	/* ����ʽ */
    compoments.OrderType('orderType');
	
}


function InitDefVal(){
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
	var comboData=$("#stktkStatus").combobox('getData');
	if(comboData.length > 0){
		$("#stktkStatus").combobox('setValue', comboData[0].RowId);
	}
	comboData=$("#orderType").combobox('getData');
	if(comboData.length > 0){
		$("#orderType").combobox('setValue', comboData[0].RowId);
	}
}
function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 		'click', 	function () {QueryMain();});
    PHA_EVENT.Bind('#btnClean', 	'click', 	function () {Clean();});
    PHA_EVENT.Bind('#btnFindDetail','click', 	function () {QueryDetail();});
    PHA_EVENT.Bind('#btnDirectSum',	'click', 	function () {DirectSum();});
    PHA_EVENT.Bind('#btnAdj',		'click', 	function () {AdjStktk();});
    PHA_EVENT.Bind('#btnCancelAdj',	'click', 	function () {CancelAdjStktk();});
    PHA_EVENT.Bind('#btnSave',		'click', 	function () {SaveDetail();});
    
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
			{ field: 'curPbDate',   title: 'ִ������',	align: 'left',	width: 100 },
			{ field: 'curPbTime',   title: 'ִ��ʱ��',	align: 'left',	width: 80 },
			{ field: 'curPbUser', 	title: 'ִ����',	align: 'left',	width: 100 },
            { field: 'stkCatDesc',  title: '������',	align: 'left',	width: 100 },
            { field: 'noUseDesc',  	title: 'Ʒ��',		align: 'left',	width: 100 },
            { field: 'manGrpDesc',  title: '�̵���',	align: 'left',	width: 100 },
            { field: 'selManGrpDesc',title: '��/���̵���',	align: 'left',	width: 100 },
            { field: 'manDrgDesc',	title: '����ҩ',	align: 'left',	width: 100 },
            { field: 'stkBinDesc',  title: '��λ',  	align: 'right',	width: 100 },
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
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: '#gridStktkMainBar',
        exportXls: true,
        columns: columns,
		pageNumber:1,
		pageSize: 100,
        pageList: [100,300, 500, 1000], // 100��
		pagination: true,
		showPageList:false,
		showRefresh:false,
        onSelect: function(rowIndex, rowData) {
	        QueryDetail();
        },
        onLoadSuccess: function (data) {
			$('#gridStktkDetail').datagrid('clear');
            if(data.total>0){
                //$('#gridStktkMain').datagrid("selectRow",0);
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
            { field: 'stkbinDesc', 	title: '��λ', 				align: 'left', 	width: 80 	,  sortable: true},
            { field: 'freQty', 		title: '��������',			align: 'right',	width: 100 },
            { field: 'countQty', 	title: 'ʵ������',			align: 'right',	width: 100 ,
            	editor: PHA_GridEditor.ValidateBox({
	            	checkOnBlur: true,
					checkValue: function (val, checkRet) {
						if(val == "") return true ;
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = "���������֣�";
							return false;
						}
						if (nQty < 0) {
							checkRet.msg = "���������0�����֣�";
							return false;
						}
						return true;
					},
					onBlur:function(val, rowData, rowIndex){
						if(val == "") return true ;
						// ����
						var bQty = parseFloat(val);
						// ��������
						var pQty = 0;
						ChangeRecordInfo(rowIndex, rowData, bQty, pQty);
					},
					onBeforeNext: function (val, gridRowData, gridRowIndex) {
						if(val == "") return true ;
						// ����
						var bQty = parseFloat(val);
						// ��������
						var pQty = 0;
						ChangeRecordInfo(gridRowIndex, gridRowData, bQty, pQty);
					}
				})
            },
            { field: 'difQty',		title: '��������', 			align: 'right',	width: 100 },
            { field: 'inclbQty',	title: '��������', 			align: 'right',	width: 100 },
            { field: 'afterInclbQty',title: '��������', 		align: 'right',	width: 100 },
            { field: 'freRpAmt', 	title: '���̽��۽��',		align: 'right',	width: 100 },
            { field: 'freSpAmt', 	title: '�����ۼ۽��',		align: 'right',	width: 100 },
            { field: 'countRpAmt', 	title: 'ʵ�̽��۽��',		align: 'right',	width: 100 },
            { field: 'countSpAmt', 	title: 'ʵ���ۼ۽��',		align: 'right',	width: 100 },
            { field: 'difRpAmt', 	title: '���۽�����',		align: 'right',	width: 100 },
            { field: 'difSpAmt', 	title: '�ۼ۽�����',		align: 'right',	width: 100 },
            { field: 'batNo', 		title: '����',				align: 'left',	width: 100 },
            { field: 'expDate', 	title: 'Ч��',				align: 'left',	width: 100 },
            { field: 'manfDesc', 	title: '������ҵ',			align: 'left',	width: 200 },
            { field: 'insuCode', 	title: '����ҽ������', 		align: 'left',	width: 100 },
            { field: 'insuName', 	title: '����ҽ������', 		align: 'left',	width: 100 },
            { field: 'fac', 		title: '��λת��ϵ��', 		align: 'left',	width: 100, hidden: true},
			{ field: 'locdFlag', 	title: '�ѵ���', 			align: 'left',	width: 100, hidden: true}
        ]
    ];
    var frozenColumns = [
        [
        	{ field: 'stktkId',     title: 'stktkId', 			align: 'left',	width: 100, hidden: true },
        	{ field: 'stktkItmId',  title: 'stktkItmId', 		align: 'left',	width: 100, hidden: true },
        	{ field: 'inci',       	title: 'inci', 				align: 'left',	width: 100 , hidden: true },
        	{ field: 'inclb',      	title: 'inclb', 			align: 'left',	width: 100, hidden: true },
        	{ field: 'isInclbEnough',title: '������', 		align: 'left',	width: 100, sortable: true,
        		styler: function(value,row,index){
					if (value == 0){
						return 'background-color:#f1c516;color:red;';
					}
				},
				formatter: function(value,row,index){
					if (value == 0){
						return $g("��治��");
					} else {
						return "";
					}
				}
	        	
        	},
        	{ field: 'isTrans',     title: '����ҵ��', 			align: 'left',	width: 100, sortable: true,
        		styler: function(value,row,index){
					if ((value != "")&&(value != undefined)&&(value.indexOf("��")<0)){
						return 'background-color:#f1c516;color:red;';
					}
				}
				
        	},
            { field: 'inciCode',    title: '����', 				align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',  			align: 'left',  width: 200, sortable: true},
			{ field: 'uomDesc',    	title: '��λ',  			align: 'left',  width: 80, sortable: true}

        ]
    ];

    var dataGridOption = {
	    bodyCls:'table-splitline',
        fit: true,
        rownumbers: true,
		pageNumber:1,
		pageSize: 100,
        pageList: [100,300, 500, 1000], // 100��
        pagination: true,
        toolbar: '#gridStktkDetailBar',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        
        allowEnd: true,
        
        editFieldSort: ['countQty'],
		loadFilter:PHA.LocalFilter,
        onClickCell: function (index, field, value) {
			if(field=="countQty"){
                var rowData = $('#gridStktkDetail').datagrid('getData').rows[index];
				var locdFlag = rowData.locdFlag;
				if(locdFlag == "1") {
					return;
				}
				PHA_GridEditor.Edit({
					gridID: gridId,
					index: index,
					field: field
				});
            }
			if (field=="isTrans"){
				var rowData = $('#gridStktkDetail').datagrid('getData').rows[index];
				var inclb = rowData.inclb;
				if(value ==""){return;}
				OpenOperateWin({
					inci: inclb.split("||")[0],
					incil: inclb.split("||")[0] +"||"+ inclb.split("||")[1],
					inclb: inclb,
					opType: "Intr",
					inciDesc: rowData.inciDesc
				});	
			}

        },
        onLoadSuccess: function (data) {
	       PHA_GridEditor.End(gridId);
		   $(this).datagrid('loaded');
           CalcAmt();
        },
        showFooter: true,

		rowStyler: function(index,row){
			var difQty = row.difQty || "";
			if (difQty > 0){
				return {class:'pha-datagrid-difqty-positive'} ; 
			}else if(difQty < 0){
				return {class:'pha-datagrid-difqty-negative'} ;
			}
		}
    };
    PHA.Grid(gridId, dataGridOption);
}
function QueryMain(){
	var $grid = $("#gridStktkMain");
	var retJson = PHA.GetVals(["stDate","endDate","stktkLocId"],"Json");
	if(retJson[0] == undefined) {return;}
	var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#stktkLocId").combobox("getValue") || "";  
	var execFlag =  $("#adjFlag").checkbox("getValue") || "";
	var stktkStatus = $("#stktkStatus").combobox("getValue")
    if(execFlag == true){execFlag = "Y"}
    else{ execFlag = "N"}

    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stktkStatus = stktkStatus;
	pJson.execFlag = execFlag;
	pJson.adjWithSum = APP_PROP.AdjWithSum;

	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.STKTK.Api' ,
        pMethodName:'GetStktkMainList',
        pPlug:'datagrid', 
        pJson: JSON.stringify(pJson)
    }); 
}
function QueryDetail(){
	var $grid = $("#gridStktkDetail");
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("��ѡ���̵㵥�ݣ�"))
		return
	}
    var stktkId = Selected.stktkId;
    var stockFlag = $("#stockFlag").checkbox("getValue") || "";
	if(stockFlag == true) {stockFlag = "Y";}
	else{stockFlag = "";}
    var intrFlag = $("#intrFlag").checkbox("getValue") || "";
	if (intrFlag == true){intrFlag = "Y";}
	else{intrFlag = "";}
	var orderType =  $("#orderType").combobox("getValue") || ""; 
	
    var pJson = {};
    pJson.stktkId = stktkId;  
    pJson.stockFlag = stockFlag;  
    pJson.intrFlag = intrFlag;  
    pJson.qText = $("#qText").val() || '';  
    pJson.orderType = orderType;
	PHA.CM({
			pClassName: 'PHA.IN.STKTK.Api',
			pMethodName: 'GetDetailForAdj',
			pPlug:'datagrid',
			pJson: JSON.stringify(pJson)
		},function(gridData){
			$grid.datagrid('loadData', gridData);
		}
	);
    
}

function AdjStktk(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("��ѡ���̵㵥�ݣ�"))
		return
	}
	var stktkStatus =  "ADJ"
    var stktkId = Selected.stktkId;

    PHA.BizPrompt({ title: '����' }, function (promptRet) {
        if (promptRet !== undefined) {
			var pJson = {};
			pJson.stktkId = stktkId;
			pJson.userId = session['LOGON.USERID'];  
			pJson.stktkStatus = stktkStatus;
			pJson.remark = promptRet;
			PHA.Loading('Show');
			PHA.CM({
				pClassName: 'PHA.IN.STKTK.Api',
				pMethodName: 'StktkAdj',
				pJson: JSON.stringify(pJson)
			},function(data) {
				PHA.Loading('Hide');
				if(PHA.Ret(data)){
					QueryMain();
				}
			},function(failRet){
				PHA_COM._Alert(failRet);
			})
		}
	})
}

/* �̵���ܣ��˲���������ִ��1.¼�뷽ʽ2¼�롣2 �����������ʵ������������ */
function DirectSum(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("��ѡ���̵㵥�ݣ�"))
		return
	}
    var stktkId = Selected.stktkId;

    PHA.BizPrompt({ title: '����' }, function (promptRet) {
        if (promptRet !== undefined) {
			var pJson = {};
			pJson.stktkId = stktkId;
			pJson.userId = session['LOGON.USERID'];  
			pJson.remark = promptRet;
			PHA.Loading('Show');
			PHA.CM({
				pClassName: 'PHA.IN.STKTK.Api',
				pMethodName: 'DirectSum',
				pJson: JSON.stringify(pJson)
			},function(data) {
				PHA.Loading('Hide');
				if(PHA.Ret(data)){
					QueryMain();
				}
			},function(failRet){
				PHA_COM._Alert(failRet);
			})
		}
	})
}

function CancelAdjStktk(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", "��ѡ���̵㵥�ݣ�")
		return
	}
	var stktkStatus = "ADJ";
    var stktkId = Selected.stktkId;
   
    PHA.BizPrompt({ title: '����' }, function (promptRet) {
        if (promptRet !== undefined) {
			var pJson = {};
			pJson.stktkId = stktkId;
			pJson.userId = session['LOGON.USERID'];  
			pJson.stktkStatus = stktkStatus;
			pJson.remark = promptRet;
			PHA.Loading('Show')
			PHA.CM({
				pClassName: 'PHA.IN.STKTK.Api',
				pMethodName: 'CancelStktkAdj',
				pJson: JSON.stringify(pJson)
			},function(data) {
				PHA.Loading('Hide');
				if(PHA.Ret(data)){
					QueryMain();
				}
			},function(failRet){
				PHA_COM._Alert(failRet);
			})
		}
	})
}
function SaveDetail(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("��ѡ���̵㵥�ݣ�"))
		return
	}
    var stktkId = Selected.stktkId;
    var pJson = {};
    pJson.stktkId = stktkId;
	pJson.userId = session['LOGON.USERID']; 
	var gridId = "gridStktkDetail"
	var $grid = $('#' + gridId);
    var rowsData = $grid.datagrid('getChanges');
    var rows = rowsData.length;
    var dataArr = [];
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var stktkItmId = rowData.stktkItmId;
		var countQty = rowData.countQty;
		var iJson = {
			stktkItmId : stktkItmId,
            countQty : countQty
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
       PHA.Msg('error', $g("û����Ҫ���������"));
       return;
    }
	pJson.rows = dataArr;
	
    PHA.Loading("Show");
    PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'SaveItmForAdj',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			QueryDetail();
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}
function Export(){}
function Clean(){
	PHA.DomData("#qCondition", {
        doType:'clear'
    })
	PHA.DomData("#gridStktkDetailBar", {
        doType:'clear'
    })
	$('#gridStktkMain').datagrid('clear');
    $('#gridStktkDetail').datagrid('clear');
    $('#stktkLocId').combobox('setValue', PHA_COM.Session.CTLOCID);
	InitDefVal();
}
function CalcAmt(){
	PHA_COM.SumGridFooter('#gridStktkDetail' , ['freRpAmt', 'freSpAmt','countRpAmt','countSpAmt','difRpAmt','difSpAmt']);
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
	rowsFooter[0]['difSpAmt'] = rowsFooter[0]['difSpAmt'] - oldDifSpAmt + newDifSpAmt
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