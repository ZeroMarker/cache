var APP_NAME = "DHCSTINSTKINPUT"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "STKTK"
var compoments = STKTK_COMPOMENTS;
$(function(){
    InitDict();             // ��ʼ�������ֵ�
    InitGridStktkDetail();  // ��ʼ��grid
    InitBtn();              // ��ʼ����ť
    //QueryStktkData();
    InitDefVal();           // ��ʼ���¼�
    CreatInputData();

})
function InitDict(){
	var locId = $("#stktkLocId").val();
	 //�����̵���
    PHA.ComboBox('manGrpId', {
	    multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        url: PHA_STORE.LocManGrp(locId).url
    });
	//����
	PHA_UX.ComboBox.StkCatGrp('stkGrpId', {
        multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		qParams: {
			LocId: locId,
			UserId: session['LOGON.USERID']
		}
	});
	//������
	PHA_UX.ComboBox.StkCat("stkCatId",{
		qParams: {
			CatGrpId: PHA_UX.Get('stkGrpId', "")
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
    
    //ҩ������
    PHA.ComboBox('inputWinId',{
		url: PHA_IN_STORE.StkTkWindow(locId).url
	});
	// ҩƷ�������
	PHA_UX.ComboGrid.INCItm('inci', {
		width: 160,
		qParams: {
			pJsonStr: {
				stkType: App_StkType,
				locId: locId,
				scgId: PHA_UX.Get('stkGrpId', '')
			}
		},
		onShowPanel:function(){},
		onHidePanel:function(){
			var grid = $('#inci').combogrid('grid');	// get datagrid object
			var rowData = grid.datagrid('getSelected');	// get the selected row
			if(typeof(rowData) == "object"){
				var inci = rowData.inci;
				var rowsData = $('#gridStktkDetail').datagrid('getData').rows;
				var rows = rowsData.length;
				var dataArr = [];
				for (var i = 0; i < rows; i++) {
					var rowData = rowsData[i];
					var inciId = rowData.inci;
					if(inci == inciId){
						PHA_GridEditor.Edit({
							gridID: "gridStktkDetail",
							index: i,
							field: "countBQty"
						});
						return ;
					}
				}
			}	
		},
	});
	/* ����ʽ */
    compoments.OrderType('orderType');
}
function InitBtn(){	
	PHA_EVENT.Bind('#btnFind', 		'click', 	function () {QueryDetail();});
    PHA_EVENT.Bind('#btnClean', 	'click', 	function () {Clean();});
    PHA_EVENT.Bind('#btnSave', 		'click', 	function () {SaveData();});
    PHA_EVENT.Bind('#btnBack', 		'click', 	function () {BackMain();});
	//���ť
    PHA_EVENT.Bind('#btnAddRows', 	'click', 	function () {AddOneRow();});
    PHA_EVENT.Bind('#btnDelRows', 	'click', 	function () {DelChkRows();});

} 
function InitDefVal(){
	$("#inputWinId").combobox("setValue", Com_WinId);  
	$("#orderType").combobox('setValue', "CODE"); 
}
function InitGridStktkDetail(){
    var gridId = 'gridStktkDetail'
    var columns = [
        [
            { field: 'spec', 		title: '���', 				align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '��λ', 				align: 'left', 	width: 80 },
            { field: 'freQty', 		title: '��������',			align: 'right',	width: 80 },
            { field: 'uomDesc', 	title: '��λ',				align: 'left',	width: 80 },
            { field: 'countBQty', 	title: 'ʵ������(����)',	align: 'right',	width: 80 ,
            	editor: PHA_GridEditor.NumberBox({
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
						if(val == "") val = 0 ;
						// ����
						var bQty = parseFloat(val);
						// ��������
						var pQty = rowData.countPQty ; //|| 0
						ChangeRecordInfo(rowIndex, rowData, bQty, pQty);
					}
				})
            },
            { field: 'bUomDesc',	title: '������λ', 			align: 'left',	width: 80 },
            { field: 'countPQty', 	title: 'ʵ������(���)',	align: 'right',	width: 80 ,
            	editor: PHA_GridEditor.NumberBox({
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
						if(val == "") val = 0 ;
						// ����
						var pQty = parseFloat(val);
						// ��������
						var bQty = rowData.countBQty ; //|| 0
						ChangeRecordInfo(rowIndex, rowData, bQty, pQty);
					}
				})
            },
            { field: 'pUomDesc',	title: '��ⵥλ', 			align: 'left',	width: 80 },
            { field: 'countQty', 	title: 'ʵ������',			align: 'right',	width: 80 },
            { field: 'difQty',		title: '��������', 			align: 'right',	width: 80 },
            { field: 'rp', 			title: '����',				align: 'right',	width: 100 , hidden: true  },
            { field: 'sp', 			title: '�ۼ�',				align: 'right',	width: 100 , hidden: true  },
            { field: 'freRpAmt', 	title: '���̽��۽��',		align: 'right',	width: 100 },
            { field: 'freSpAmt', 	title: '�����ۼ۽��',		align: 'right',	width: 100 },
            { field: 'countRpAmt', 	title: 'ʵ�̽��۽��',		align: 'right',	width: 100 },
            { field: 'countSpAmt', 	title: 'ʵ���ۼ۽��',		align: 'right',	width: 100 },
            { field: 'difRpAmt', 	title: '���۽�����',		align: 'right',	width: 100 },
            { field: 'difSpAmt', 	title: '�ۼ۽�����',		align: 'right',	width: 100 },
            { field: 'manfDesc', 	title: '������ҵ',			align: 'left',	width: 250 },
            { field: 'insuCode', 	title: '����ҽ������', 		align: 'left',	width: 100 },
            { field: 'insuName', 	title: '����ҽ������', 		align: 'left',	width: 100 },
            { field: 'bUomId', 		title: '������λ', 			align: 'left',	width: 100, hidden: true  },
            { field: 'fac', 		title: '��λת��ϵ��', 		align: 'left',	width: 100, hidden: true  }
        ]
    ];
    var frozenColumns = [
        [
        	
            { field: 'inputItmId',  title: 'inputItmId',		align: 'left',	width: 100 },
            { field: 'inciCode',    title: '����', 				align: 'left',	width: 100, sortable: true},
            { 
				field: 'inci',
				title: 'ҩƷ����',
				descField: 'inciDesc',
				width: 250,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['inciDesc'];
				},
				editor: PHA_UX.Grid.INCItm({
					type: 'lookup',
					required: true,
					onBeforeLoad: function (param, gridRowData) {
						// ��ѯ����
						param.hospId = session['LOGON.HOSPID'];
						param.pJsonStr = JSON.stringify({
							stkType: App_StkType,
							scgId: "",
							locId: $("#stktkLocId").val(),
							userId: session['LOGON.USERID'],
							notUseFlag: '',
							qtyFlag: '',
							recLocId: '',
						});
					},
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
						if((gridRowData.inputItmId != "")&&(gridRowData.inputItmId != undefined)){
							PHA.Popover({
								msg: '�����Ѿ��������̵㵥��',
								type: 'alert',
								timeout: 1000
							});
							return;
						}
						var dgOpts = $('#' + gridId).datagrid('options');
						var curEidtCell = dgOpts.curEidtCell || {};
						if (!curEidtCell.index) return;  //�����ʱ����ټ��һ�Σ���ʱ�༭��Ϊ�գ��ȹ���
						var pJson = {};
						pJson.stktkId = $("#stktkId").val();
						pJson.winId = $("#inputWinId").combobox("getValue") || ""; 
						pJson.inci = cmbRowData.inci;
						PHA.CM({
							pClassName: 'PHA.IN.STKTK.Api',
							pMethodName: 'IsExistInInput',
							pJson: JSON.stringify(pJson)
						},function(data) {
							if(data.data == "1"){
								setTimeout(function(){
									var ed = $('#' + gridId).datagrid('getEditor', {
										index: curEidtCell.index,
										field: curEidtCell.field
									});
									//if (!ed) return true;
									$(ed.target).combogrid('clear');
									$(ed.target).combogrid('setValue', '');
									$(ed.target).combogrid('setText', '');
								}, 300);
								PHA.Popover({
									msg: '�����Ѿ��������̵㵥��',
									type: 'alert',
									timeout: 1000
								});	
							}else{
								AddRows(gridRowIndex, cmbRowData);			
							}
						},function(failRet){
							PHA_COM._Alert(failRet);
							return false;
						});
					}
				})
			
			}
        ]
    ];

    var dataGridOption = {
	    gridSave: true,
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
		isCellEdit:true,
        editFieldSort: ['countBQty', 'countPQty' ],
		loadFilter:PHA.LocalFilter,
        onClickCell: function (index, field, value) {
			if(field == "inci"){
				var rowData = $('#gridStktkDetail').datagrid('getData').rows[index];
				var inputItmId = rowData.inputItmId;
				if(inputItmId != "") {
					return;
				} 
			}
            PHA_GridEditor.Edit({
                gridID: gridId,
                index: index,
                field: field
            });
        },
        onLoadSuccess: function (data) {
	       PHA_GridEditor.End(gridId);
		   $(this).datagrid('loaded');
           CalcAmt();
        },
        showFooter: true,
		rowStyler: function(index,row){
			var countQty = row.countQty || "";
			if ((countQty == "") || (countQty == null)) {
			    return; //δ�����ɫ
			}
			if (row.difQty > 0){
				return {class:'pha-datagrid-difqty-positive'} ;
			}else if(row.difQty < 0){
				return {class:'pha-datagrid-difqty-negative'} ;
			}
		}
    };
    PHA.Grid(gridId, dataGridOption);
}

function QueryStktkData(){
	var stktkId = $("#stktkId").val();
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
			$("#stktkNo").val(data[0].stktkNo);
			QueryDetail();
		}else{
			PHA_COM._Alert(failRet);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}
function QueryDetail(){
	var $grid = $("#gridStktkDetail");
	var stktkId = $("#stktkId").val();
	var manGrpId = $("#manGrpId").combobox("getValue") || "";  
	var stkGrpId = $("#stkGrpId").combobox("getValue") || "";  
	var stkCatId = $("#stkCatId").combobox("getValue") || "";  
	var stkbinId = $("#stkbinId").combobox("getValue") || "";  
	var stkWinId = $("#inputWinId").combobox("getValue") || "";  
	var orderType =  $("#orderType").combobox("getValue") || ""; 
	var pJson = {};
    pJson.stktkId = stktkId;  
    pJson.manGrpId = manGrpId;
    pJson.stkGrpId = stkGrpId;
	pJson.stkCatId = stkCatId;
	pJson.stkbinId = stkbinId;
	pJson.stkWinId = stkWinId;
	pJson.orderType = orderType;
	PHA.CM({
			pClassName: 'PHA.IN.STKTK.Api',
			pMethodName: 'GetInputDetailData',
			pPlug:'datagrid',
			pJson: JSON.stringify(pJson)
		},function(gridData){
			$grid.datagrid('loadData', gridData);
		}
	);

}
function SaveData(){
	var gridId = "gridStktkDetail"
	PHA_GridEditor.End(gridId);
	var pJson = {};
	pJson.stktkId = $('#stktkId').val();
	pJson.userId = session['LOGON.USERID'];  
	pJson.winId = $("#inputWinId").combobox("getValue") || ""; 
	var $grid = $('#' + gridId);
    var rowsData = $grid.datagrid('getChanges');
    var rows = rowsData.length;
    var dataArr = [];
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var inputItmId = rowData.inputItmId;
		var bQty = rowData.countBQty;
		var pQty = rowData.countPQty;
		var fac = rowData.fac;
		var countQty = _.safecalc('add', bQty, _.safecalc('multiply', pQty, fac));  //rowData.countQty;
		var iJson = {
			inci :rowData.inci,
			inputItmId : inputItmId,
	  		bQty : bQty,
            pQty : pQty,
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
		pMethodName: 'SaveInputStktk',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			QueryStktkData();
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 

}
function Clean()
{
	PHA.ClearVals(["manGrpId","stkGrpId","stkCatId","stkbinId","inputWinId","inci"])
	$('#gridStktkDetail').datagrid('clear');
	InitDefVal();
}
function CalcAmt(){
	PHA_COM.SumGridFooter('#gridStktkDetail' , ['freRpAmt', 'freSpAmt', 'countRpAmt', 'countSpAmt', 'difRpAmt', 'difSpAmt']);
}

/// �����̵�����
function CreatInputData(){
	var stktkId = $("#stktkId").val();
	var pJson = {};
    pJson.stktkId = stktkId; 
    pJson.userId =  session['LOGON.USERID']; 
    pJson.stkWinId =  $("#inputWinId").combobox("getValue") || ""; 
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'CreatInputStktk',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			QueryStktkData()
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}

function ChangeRecordInfo(rowIndex, rowData, bQty, pQty){
	var $grid = $('#gridStktkDetail');
	var inputItmId = rowData.inputItmId || "";
	var emptyFlag = ((bQty == "")&&(pQty == "")) ? true : false ;
	bQty = bQty || 0;
	pQty = pQty || 0;
	var fac = rowData.fac; 
	var freQty = rowData.freQty;
	var countQty = _.safecalc('add', bQty, _.safecalc('multiply', pQty, fac)); 
	var difQty = _.safecalc('add', countQty,  _.safecalc('multiply', freQty, -1)); 
	var freSpAmt = rowData.freSpAmt; 
	var freRpAmt = rowData.freRpAmt;
	var rp = rowData.rp;
	var sp = rowData.sp;
	var newCountSpAmt = _.safecalc('multiply', countQty, sp);;
	var newCountRpAmt = _.safecalc('multiply', countQty, rp);;
	var newDifSpAmt = _.safecalc('add', newCountSpAmt, _.safecalc('multiply', freSpAmt, -1));
	var newDifRpAmt = _.safecalc('add', newCountRpAmt, _.safecalc('multiply', freRpAmt, -1));  
	var Data = {}
	Data.countSpAmt = newCountSpAmt;
	Data.countRpAmt = newCountRpAmt;
	Data.difSpAmt = newDifSpAmt;
	Data.difRpAmt = newDifRpAmt;
	Data.countQty = emptyFlag ? '' : countQty;
	Data.difQty = difQty;
	$grid.datagrid('updateRowData', {
		index: rowIndex,
		row: Data
	});
	
	var pJson = {};
	pJson.stktkId = $('#stktkId').val();
	pJson.inci = rowData.inci
	pJson.inputItmId = inputItmId ;
	pJson.bQty = emptyFlag ? '' : bQty ;
	pJson.pQty = emptyFlag ? '' : pQty ;
	pJson.userId = session['LOGON.USERID']; 
	pJson.winId = $("#inputWinId").combobox("getValue") || ""; 
	pJson.countQty = emptyFlag ? '' : countQty ;
	PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'UpdateInputStktk',
		pJson: JSON.stringify(pJson)
	},function(data) {
		if((inputItmId == "")||(inputItmId == undefined)){
			var updRowData = {}
			updRowData.inputItmId = data.data
			$grid.datagrid('updateRowData', {
				index: rowIndex,
				row: updRowData
			});
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	});
	CalcAmt();
}

function ChangeRecordInfoOld(rowIndex, rowData, bQty, pQty){
	var $grid = $('#gridStktkDetail');
	var inputItmId = rowData.inputItmId || "";
	var fac = rowData.fac; 
	var freQty = rowData.freQty;
	var countQty = _.add(bQty, pQty * fac);
	var difQty = countQty - freQty;
	var freSpAmt = rowData.freSpAmt; 
	var freRpAmt = rowData.freRpAmt;
	var oldCountSpAmt = rowData.countSpAmt; 
	var oldCountRpAmt = rowData.countRpAmt; 
	var oldDifSpAmt = rowData.difSpAmt; 
	var oldDifRpAmt = rowData.difRpAmt;
	var rp = rowData.rp;
	var sp = rowData.sp;
	var newCountSpAmt = countQty * sp;
	var newCountRpAmt = countQty * rp;
	var newDifSpAmt = newCountSpAmt - freSpAmt;
	var newDifRpAmt = newCountRpAmt - freRpAmt;
	var Data = {}
	Data.countSpAmt = newCountSpAmt;
	Data.countRpAmt = newCountRpAmt;
	Data.difSpAmt = newDifSpAmt;
	Data.difRpAmt = newDifRpAmt;
	Data.countQty = countQty;
	Data.difQty = difQty;
	$grid.datagrid('updateRowData', {
		index: rowIndex,
		row: Data
	});
	
	var rowsFooter = $grid.datagrid('getFooterRows');
	var oldTatolRpAmt = parseFloat(rowsFooter[0]['countRpAmt'].replace(/[��|,]/g,""));
	var oldTatolSpAmt = parseFloat(rowsFooter[0]['countSpAmt'].replace(/[��|,]/g,""));
	var oldDifRpAmt = parseFloat(rowsFooter[0]['difRpAmt'].replace(/[��|,]/g,""));
	var oldDifSpAmt = parseFloat(rowsFooter[0]['difSpAmt'].replace(/[��|,]/g,""));
	rowsFooter[0]['countRpAmt'] = "��" + PHA_COM.Fmt.Grid.Number(oldTatolRpAmt - oldCountRpAmt + newCountRpAmt, "#0,000.00");
	rowsFooter[0]['countSpAmt'] = "��" + PHA_COM.Fmt.Grid.Number(oldTatolSpAmt - oldCountSpAmt + newCountSpAmt, "#0,000.00");
	rowsFooter[0]['difRpAmt'] = "��" + PHA_COM.Fmt.Grid.Number(oldDifRpAmt - oldDifRpAmt + newDifRpAmt, "#0,000.00");
	rowsFooter[0]['difSpAmt'] = "��" + PHA_COM.Fmt.Grid.Number(oldDifSpAmt - oldDifRpAmt + newDifRpAmt, "#0,000.00");
	$grid.datagrid('reloadFooter');

	var pJson = {};
	pJson.stktkId = $('#stktkId').val();
	pJson.inci = rowData.inci
	pJson.inputItmId = inputItmId ;
	pJson.bQty = bQty ;
	pJson.pQty = pQty ;
	pJson.userId = session['LOGON.USERID']; 
	pJson.winId = $("#inputWinId").combobox("getValue") || ""; 
	pJson.countQty = countQty ;
	PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'UpdateInputStktk',
		pJson: JSON.stringify(pJson)
	},function(data) {
		if(inputItmId == ""){
			if(data.msg == "")
			var updRowData = {}
			updRowData.inputItmId = data.data
			$grid.datagrid('updateRowData', {
				index: rowIndex,
				row: updRowData
			});
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	});
}

function BackMain(){
	var url = "pha.in.v3.stktk.input.csp";
	if ('undefined'!==typeof websys_getMWToken){
		url += "?MWToken="+websys_getMWToken();
	}
	window.location.href=url;
}

function AddOneRow(){
    PHA_GridEditor.Add({
        gridID: 'gridStktkDetail',
        field: 'inci',
        rowData: {},
        checkRow: true, // ������ʱ�Ƿ���֤��һ������
        firstRow: false // �����з����������ǰ
    }, 1);
}
function AddRows(rowIndex, cmbData){
	
	var $grid = $('#gridStktkDetail')
	var rowsData =  $grid.datagrid('getRows');
	var rowData = rowsData[rowIndex];
	if((rowData.inputItmId != "")&&(rowData.inputItmId != undefined)){
		PHA.Popover({
            msg: '�����Ѿ��������̵㵥��',
            type: 'alert',
            timeout: 1000
        });
		return;
	}
	var iAddData = {};
	iAddData.inci = cmbData.inci;
	iAddData.inciCode = cmbData.inciCode;
	iAddData.inciDesc = cmbData.inciDesc;
	iAddData.spec = cmbData.inciSpec; 
	iAddData.stkbinDesc = cmbData.stkBin;
	iAddData.insuCode = cmbData.insuCode;
	iAddData.insuName = cmbData.insuName;
	iAddData.manfDesc = cmbData.manfName;
	
	iAddData.freQty = cmbData.bQty;		//������
	iAddData.uomDesc = cmbData.bUomDesc; //��������λ

	iAddData.bUomDesc = cmbData.bUomDesc;
	iAddData.pUomDesc = cmbData.pUomDesc;
	iAddData.difQty = _.add(0,  -iAddData.freQty);
	iAddData.rp = _.divide(cmbData.pRp, cmbData.pFac);
	iAddData.sp = _.divide(cmbData.pSp, cmbData.pFac);
	iAddData.freRpAmt = _.multiply(cmbData.pQty,  cmbData.pRp);
	iAddData.freSpAmt = _.multiply(cmbData.pQty,  cmbData.pSp);
	iAddData.countSpAmt = 0 ; 
	iAddData.countRpAmt = 0 ; 
	iAddData.difRpAmt = _.add(0,  -iAddData.freRpAmt);
	iAddData.difSpAmt = _.add(0,  -iAddData.freSpAmt);
	iAddData.fac = cmbData.pFac
	$grid.datagrid('updateRowData', {
		index: rowIndex,
		row: iAddData
	});
	PHA_GridEditor.Edit({
		gridID : "gridStktkDetail",
		index : rowIndex,
		field : 'countBQty'
	});	
	
}
function DelChkRows(){
	var $grid = $('#gridStktkDetail')
	var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ������',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var inputItmId = gridSelect.inputItmId || '';
    if(inputItmId!==""){
		PHA.Popover({
            msg: '�ѱ��浽�̵��¼��������ɾ����',
            type: 'alert',
            timeout: 1000
        });
        return;
	}
   	var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
	$grid.datagrid('deleteRow', rowIndex);
}