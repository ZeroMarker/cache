/*
/// Creator     zhaozhiduan
/// CreatDate   2022��03��11��
/// Description ��汨�𽨵�
*/
var APP_NAME = "DHCSTINSCRAP"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var APP_PROP_COM = PHA_COM.ParamProp("DHCSTCOMMON");
var BUIS_CODE = "SCRAP";
var BUIS_RANGE = "All";
$(function(){
	PHA_COM.SetPanel('#panel');
    InitDict();             // ��ʼ�������ֵ�
    InitGridMScrapDetail();   // ��ʼ��grid
    InitBtn();              // ��ʼ����ť
    // dialog ��ʼ��
    InitGridScrapMain();
    InitGridScrapDetail();
    SetDisable();
	SetRequired();
	setTimeout(function () {
		PHA_COM.ResizePanel({
		   layoutId: 'layout-scrap-create-diag',
		   region: 'north',
		   height: 0.5 
	   });
   }, 0);
	
})
function InitDefVal(){
	var locId =  $("#scrapLocId").combobox("getValue") || PHA_COM.Session.CTLOCID
    $('#phLoc').combobox('setValue', locId);
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
	$('#buisProcess').combobox('reload');
}
function SetRequired(){
	PHA.SetRequired($('#gridScrapMainBar' + ' [data-pha]'))
	PHA.SetRequired($('#gridMScrapDetailBar' + ' [data-pha]'))
}
function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 		'click', function () {ShowDiagScrap(this);});
	PHA_EVENT.Bind('#btnSave', 		'click', function () {SaveScrap();});
	PHA_EVENT.Bind('#btnClean', 	'click', function () {Clean();});

	PHA_EVENT.Bind('#btnComplete', 	'click', function () {Complete();});
	PHA_EVENT.Bind('#btnCancelComp','click', function () {CancelComp();});
	PHA_EVENT.Bind('#btnPrint', 	'click', function () {Print();});
    PHA_EVENT.Bind('#btnDelete', 	'click', function () {Delete();});
	PHA_EVENT.Bind('#btnCopyScrap', 'click', function () {ShowDiagScrap(this);});

    //���ť
    PHA_EVENT.Bind('#btnAddRows', 	'click', function () {AddOneRow();});
	PHA_EVENT.Bind('#btnDelRows', 	'click', function () {DelChkRows();});
    // dialog ��ť
    PHA_EVENT.Bind('#btnSearch', 	'click', function () {QueryMain();});
	PHA_EVENT.Bind('#btnCleanQ', 	'click', function () {CleanQ();});
    PHA_EVENT.Bind('#btnSelScrap', 	'click', function () {SelectScrap();});
	PHA_EVENT.Bind('#btnDelScrap', 	'click', function () {DelScrap();});
	
}

function InitDict(){
	//ҩ������
    PHA_UX.ComboBox.Loc('scrapLocId');
    
	//����
	PHA_UX.ComboBox.StkCatGrp('stkGrpId', {
		panelHeight:'auto',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('scrapLocId', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
     //��汨��ԭ��
    PHA.ComboBox('reasonId', {
		panelHeight:'auto',
        url: PHA_IN_STORE.ReasonForScrap().url
    });
    
    // dialog ҩ������
    //ҩ������
    PHA_UX.ComboBox.Loc('phLoc');
	//����
	PHA_UX.ComboBox.StkCatGrp('inStkGroup', {
		panelHeight:'auto',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('phLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
    //��汨��ԭ��
    PHA.ComboBox('scrapReason', {
		panelHeight:'auto',
        url: PHA_IN_STORE.ReasonForScrap().url
    });
	 /* ��Ϣչʾ�� */
	$('#infoArea').phabanner({
	    title: $g('ѡ�񵥾ݺ�, ��ʾ��ϸ��Ϣ')
	});
}
function InitScrapStatus(flag)
{
	//ҵ������
	PHA.ComboBox('buisProcess', {
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		panelHeight:'auto',
		selectOnNavigation:false,
        url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE).url,
        onLoadSuccess: function(data) {
			if(data.length > 0){
				var defVals = [];
				for(var i = 0; i <data.length; i++) {
					var iData = data[i];
					var code = iData["RowId"]
					defVals.push(code)
				}
				$(this).combobox('setValues',defVals);
			}
		},
        loadFilter:function(data){
            if(data.length > 0){
                var displayData = []
				for(var i = 0; i <data.length; i++) {
                    var iData = data[i];
                    var desc = iData["Description"]
                    if(flag == 1){
						if((desc.indexOf("����") < 0)&&(desc.indexOf("���") < 0 )) continue;
					}else if(flag == 2){	 //����
						if(desc.indexOf("����") < 0) continue;
					}
                    displayData.push(iData);
                }
                return displayData;				
			}
        }
    });
}
function InitGridMScrapDetail(){
    var gridId = 'gridMScrapDetail'
    var columns = [
        [
            { field: 'spec', 		title: '���', 			align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '��λ', 			align: 'left', 	width: 80 },
            { field: 'qty', 		title: '��������',		align: 'right',	width: 80,
            	editor: PHA_GridEditor.NumberBox({
	            	required: true,
	            	checkOnBlur: true,
					checkValue: function (val, checkRet) {
						if (val == "") {
							checkRet.msg = "����Ϊ�գ�"
							return false;
						}
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = "���������֣�";
							return false;
						}
						if (nQty <= 0) {
							checkRet.msg = "���������0�����֣�";
							return false;
						}
						return true;
					},
					onBlur:function(val, rowData, rowIndex){
						var qty = parseFloat(val);;
						var inclb = rowData.inclb;
						var uomId = rowData.uomId
						ChangeRecordInfo(rowIndex, inclb, qty, uomId);
					},
					onBeforeNext: function (val, gridRowData, gridRowIndex) {
						// ����
						var qty = parseFloat(val);
						// ��������
						var uomId = gridRowData.uomId;
						var inclb = gridRowData.inclb;
						ChangeRecordInfo(gridRowIndex, inclb, qty, uomId);
					}
				})
            
            },
            { field: 'uomId',		title: '��λ', 			align: 'left',	width: 80 ,
            	descField: 'uomDesc',
            	formatter: function (value, rowData, index) {
					return rowData['uomDesc'];
				},
				editor: PHA_UX.Grid.INCItmUom({
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
						// ��������
						var uomId, oldUomId
						if (cmbRowData) {
							uomId = cmbRowData.RowId;
							oldUomId = gridRowData.uomId ;
						}
						if(uomId != oldUomId){
							var qty = gridRowData.qty;
							var inclb = gridRowData.inclb;
							var inci = gridRowData.inci;
							ChangeRecordInfo(gridRowIndex, inclb, qty, uomId);
							
						}
						return true;
					}
				})
            },
            { field: 'inclbQty', 	title: '���ο��',		align: 'right',	width: 100},
            { field: 'batNo', 		title: '����',			align: 'left',	width: 100 },
            { field: 'expDate', 	title: 'Ч��',			align: 'left',	width: 80 },
            { field: 'rp', 			title: '����',			align: 'right',	width: 100 },
            { field: 'sp', 			title: '�ۼ�',			align: 'right',	width: 100 },
            { field: 'rpAmt', 		title: '���۽��',		align: 'right',	width: 100 },
            { field: 'spAmt', 		title: '�ۼ۽��',		align: 'right',	width: 100 },
            { field: 'manfDesc', 	title: '������ҵ',		align: 'left',	width: 250 },
            { field: 'insuCode', 	title: '����ҽ������', 	align: 'left',	width: 100 },
            { field: 'insuName', 	title: '����ҽ������', 	align: 'left',	width: 100 },
            { field: 'bUomId', 		title: '������λ', 		align: 'left',	width: 100, hidden: true  },
            { field: 'fac', 		title: '��λת��ϵ��', 	align: 'left',	width: 100, hidden: true  }
        ]
    ];
    var frozenColumns = [
        [
			{ field: 'Select',checkbox: true},
        	{ field: 'inci',       	title: 'inci', 			align: 'left',	width: 100, hidden: true },
        	{ field: 'inclb',       title: 'inclb', 		align: 'left',	width: 100, hidden: true },
            { field: 'scrapItmId',  title: 'scrapItmId',	align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '����', 			align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',  align: 'left',    width: 300, sortable: true,
                editor: PHA_UX.Grid.INCItmBatWin({
					onBeforeLoad: function(param, gridRowData){
						param.hospId = session['LOGON.HOSPID'];
						param.pJsonStr = JSON.stringify({
							stkType: App_StkType,
							scgId: $("#stkGrpId").combobox("getValues").join(",") || "", 
							locId: $("#scrapLocId").combobox("getValue") || "",
							userId: session['LOGON.USERID'],
							notUseFlag: '',
							qtyFlag: '1',
							reqLocId: ''
						});
					},
					onBeforeNext: function (winData, gridRowData, gridRowIndex) {
						if (winData.action == 'close') {
							return true;
						}
						var nData = winData.north;
						var cData = winData.center;
						return true;
					},
					onClickSure: function(winData){
						var nData = winData.north;
						var cDataRows = winData.center;
						AddRows(nData, cDataRows);
					}
				},{
					inputType: 'SCRAP'
				})
            }
        ]
    ];

    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: '#gridMScrapDetailBar',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        isAutoShowPanel: false,
		shiftCheck: true,
        singleSelect: true,
        checkOnSelect: false, // ��������, Ӧ���������빴ѡ�ֿ�, ���ǹ�ѡ����Ҫ�ֳܷ���Ϣ
        selectOnCheck: false,
        editFieldSort: ['inciDesc', 'qty', 'uomId'],
        url:PHA.$URL,
        queryParams:{
            pClassName:'PHA.IN.SCRAP.Api' ,
            pMethodName:'GetScrapDetail',
            pPlug:'datagrid',
            pJson:'{}'
        },
        onClickCell: function (index, field, value) {
            PHA_GridEditor.Edit({
                gridID: gridId,
                index: index,
                field: field,
				forceEnd: true
			});
			var inciCode = $('#' + gridId).datagrid('getRow', index).inciCode
			if( inciCode != "" && inciCode != undefined){
				let target = $('#' + gridId).datagrid('getEditor', { index: index, field: 'inciDesc' }).target;
            	$(target).lookup('disable');
				$(target).unbind();
			}
        },
        onLoadSuccess: function (data) {
           PHA_GridEditor.End(gridId);
           CalcAmt();
        },
        onBeforeEdit:function(){
	    	var compStatus = $("#compFlag").checkbox("getValue");
    		if(compStatus != true){
	    		return true;
	    	}else{
		    	return false;
		    }
	    },
        showFooter: true,
		onNextCell: function(index, field, value, isLastRow, isLastCol) {
			if (isLastRow && isLastCol) {
				AddOneRow();
			}
		}
    };
    PHA.Grid(gridId, dataGridOption);
	
	
}
function InitGridScrapMain(){
    var columns = [
        [
            { field: 'scrapId',		title: '����id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'scrapNo',		title: '����',		align: 'left',	width: 160,
				styler: function(value,row,index){				
					return {class:"pha-grid-link" };
				}	
			},
            { field: 'scrapLoc',    title: '����',		align: 'left',	width: 100,	hidden: true  },
            { field: 'scrapDate',   title: '�Ƶ�����',  align: 'left',	width: 80 },
            { field: 'scrapTime',   title: '�Ƶ�ʱ��',  align: 'left',	width: 80 },
            { field: 'rpAmt',       title: '���۽��',  align: 'right',	width: 80 },
            { field: 'spAmt',       title: '�ۼ۽��',  align: 'right',	width: 80 },
            { field: 'reasonId',  	title: '����ԭ��',  align: 'left',	width: 100,	hidden: true   },
            { field: 'reasonDesc',  title: '����ԭ��',  align: 'left',	width: 100 },
            { field: 'remarks',		title: '��ע',		align: 'left',	width: 100 },
            { field: 'curStatus',   title: '״̬',		align: 'left',	width: 80 },
            { field: 'curPbDate',   title: '״̬��������',	align: 'left',	width: 100 },
            { field: 'curPbTime',   title: '״̬����ʱ��',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	title: '״̬������',	align: 'left',	width: 100 },
            { field: 'newStatusInfo',title: '������ת��Ϣ',	align: 'left',	width: 200 },
            { field: 'copyInfo',    title: '������',	align: 'left',	width: 120 }
        ]
    ];
    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridScrapMainBar',
        exportXls: false,
        columns: columns,
        onSelect: function(rowIndex, rowData) {
            QueryDetail()
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                SelectScrap()
            }
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridScrapMain').datagrid("selectRow",0);
            }else{
	        	$('#gridScrapDetail').datagrid('clear');
	        }
        },
		onClickCell: function (index, field, value) {            
			if(field=="scrapNo"){
                var rowData = $('#gridScrapMain').datagrid('getData').rows[index];
                PHA_UX.BusiTimeLine({},{
                    busiCode:BUIS_CODE,
                    locId:$("#scrapLocId").combobox("getValue") || PHA_COM.Session.CTLOCID,
                    pointer:rowData.scrapId,
                    No:value
                });
            }else{
                PHA_UX.BusiTimeLine({},{},"close")
            }
        }
        
    };
    PHA.Grid('gridScrapMain', dataGridOption);
}
function InitGridScrapDetail(){
    var columns = [
        [
            { field: 'spec',        title: '���',			align: 'left',  width: 80 },
            { field: 'stkbinDesc',  title: '��λ',			align: 'left',  width: 80 },
            { field: 'qty',         title: '��������',		align: 'right', width: 100 },
            { field: 'uomDesc',     title: '��λ',			align: 'left',  width: 100 },
            { field: 'inclbQty',    title: '���ο��',		align: 'right', width: 100 },
            { field: 'batNo',       title: '����',			align: 'left',  width: 100 },
            { field: 'expDate',     title: 'Ч��',			align: 'left',  width: 100 },
            { field: 'rp',          title: '����',			align: 'right', width: 100 },
            { field: 'sp',          title: '�ۼ�',			align: 'right', width: 100 },
            { field: 'rpAmt',       title: '���۽��',		align: 'right', width: 100 },
            { field: 'spAmt',       title: '�ۼ۽��',		align: 'right', width: 100 },
            { field: 'manfDesc',    title: '������ҵ',      align: 'left',  width: 250 },
            { field: 'insuCode',    title: '����ҽ������',	align: 'left',  width: 100 },
            { field: 'insuName',    title: '����ҽ������',	align: 'left',  width: 100 }
        ]
    ];
    var frozenColumns = [
        [
            { field: 'inclb',       title: 'inclb',         align: 'left',  width: 100, hidden: true },
            { field: 'scrapItmId',  title: 'scrapItmId',    align: 'left',  width: 100, hidden: true },
            { field: 'inciCode',    title: '����',			align: 'left',  width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',			align: 'left',  width: 300, sortable: true}
        ]
    ]
    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: [],
        exportXls: false,
        columns: columns,
        frozenColumns: frozenColumns,
		showFooter: true,
        onLoadSuccess: function (data) {
            PHA_COM.SumGridFooter('#gridScrapDetail' , ['rpAmt', 'spAmt']);
         }
    };
    PHA.Grid('gridScrapDetail', dataGridOption);

}
function ShowDiagScrap(btnOpt){
	var isFind = btnOpt.id.indexOf('Find') > -1 ? true : false;
    $('#diagFindScrap').dialog({
            title: btnOpt.text,
            iconCls: isFind ? 'icon-w-list' : 'icon-w-copy',
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            modal: true
    }).dialog('open');
    if(isFind == true){
		 $('#btnSelScrap').linkbutton({text: 'ѡȡ'})
		 $('#btnDelScrap').show();
	 	InitScrapStatus(1);
	}else{
		$('#btnSelScrap').linkbutton({text: '����'})
		$('#btnDelScrap').hide();
		InitScrapStatus(2);
	}
    $('#gridScrapMain').datagrid('clear');
    $('#gridScrapDetail').datagrid('clear');
    InitDefVal();
}
function ValidateEditGrid(){
	var val = true
	var msg = "";
	var gridId = "gridMScrapDetail";
	var $grid = $('#' + gridId);
	PHA_GridEditor.GridFinalDone("#gridMScrapDetail", 'inclb');
	var rows = $grid.datagrid('getRows');
	if (rows.length == 0) {
		PHA.Msg('error', $g("��ϸû�����ݣ�"));
		return false;
	}
	var editRow = 0;
	try{
		var chkRetStr = PHA_GridEditor.CheckValues(gridId);
		if(chkRetStr != ""){
			throw chkRetStr;
		}
		var chkRetStr = PHA_GridEditor.CheckDistinct({gridID : gridId,fields : ["inclb"]});
		if(chkRetStr != ""){
			throw  chkRetStr;
		}
		
		var rowsData = $grid.datagrid('getRows');
		var rows = rowsData.length;
		for (var i = 0; i < rows; i++) {
			var rowData = rowsData[i];
			var inclb = rowData.inclb;
			if(inclb == ""){
				continue;
			} 
			var qty = rowData.qty;
			var fac = rowData.fac;
			var uomId = rowData.uomId;
			var buomId = rowData.bUomId;
			var inclbQty = rowData.inclbQty;
			if ((qty == '')||(parseFloat(qty) <= 0)){
				editRow =  i + 1;
				throw $g("��" + (i + 1) + "��,���������������0!");
			} 
			if (parseFloat(qty) > parseFloat(inclbQty)){
				editRow =  i + 1;
				throw $g("��" + (i + 1) + "��,�����������ܳ������ο��!!");	
			} 
			var bQty;
			if(APP_PROP.StockAllowDecimal != "Y"){
				if(buomId != uomId)
				{
					bQty = Math.imul(qty, fac);
				}else{
					bQty = qty;
				}
				if (parseInt(bQty, 10) != bQty){
					editRow =  i + 1;
					throw $g("��" + (i + 1) + "��, ������������С�������ܱ�����˶Կ�汨�����ã�������������Ϊ������λ�Ƿ�����С��!");
				}	
			}
		}
	}catch(error){
		val = false;
        if(typeof msg === 'string') msg = error;
		if(typeof msg === 'object') msg = error.message;
	}finally{
		if (msg !== '' && typeof msg === 'string') {
			PHA.Popover({
                msg: msg,
                type: 'error'
            });
		}
		if (editRow>0){
			PHA_GridEditor.Edit({
				gridID : gridId,
				index : editRow,
				field : 'qty'
			});
		}
		return val;
	}
}
function SaveScrap(){
	var gridId = "gridMScrapDetail"
	PHA_GridEditor.End(gridId);
	if( ValidateEditGrid() ===false){return;}

	var retJson = PHA.GetVals(["scrapId","scrapLocId","reasonId","compFlag","remarks"],"Json")
	if(retJson[0] == undefined) {return;}
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID'];  
	var $grid = $('#' + gridId);
	var rowsData = $grid.datagrid('getChanges');
    var rows = rowsData.length;
    var dataArr = [];
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var scrapItmId = rowData.scrapItmId;
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		var uomId = rowData.uomId;
		var iJson = {
			scrapItmId : scrapItmId,
	  		inclb : inclb,
            uomId : uomId,
            qty : qty         
        };
        dataArr.push(iJson);
    }
   
	pJson.rows = dataArr;
	PHA.Loading("Show");
    PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'SaveData',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetScrapMainInfo(data.data);
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
    $('#gridMScrapDetail').datagrid('clear');
    $('#scrapLocId').combobox('setValue', PHA_COM.Session.CTLOCID);
	$('#infoArea').phabanner('loadData', []);
    SetDisable();
}
function CleanQ()
{
    PHA.DomData("#winQCondition", {
        doType:'clear'
    })
    $('#gridScrapMain').datagrid('clear');
	$('#gridScrapDetail').datagrid('clear');
	InitDefVal();
}
function Complete(){
	var gridId = "gridMScrapDetail"
	PHA_GridEditor.End(gridId);
	if( ValidateEditGrid() ===false){return;}
	
	
	var retJson = PHA.GetVals(["scrapId","scrapLocId","reasonId","compFlag","remarks"],"Json")
	if(retJson[0] == undefined) {return;}
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID'];  
	var $grid = $('#' + gridId);
	var rowsData = $grid.datagrid('getChanges');
    var rows = rowsData.length;
    var dataArr = [];
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var scrapItmId = rowData.scrapItmId;
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		var uomId = rowData.uomId;
		var iJson = {
			scrapItmId : scrapItmId,
	  		inclb : inclb,
            uomId : uomId,
            qty : qty         
        };
        dataArr.push(iJson);
    }
	pJson.rows = dataArr;
	pJson.compFlag = "Y";
	PHA.Loading('Show')
	PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'SaveComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetScrapMainInfo(data.data);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})  	

}
function CancelComp(){
	PHA.Loading('Show')
	var pJson = {}
	var scrapId = $('#scrapId').val();
	pJson.scrapId = scrapId;
	pJson.compFlag = "N";
	pJson.userId = session['LOGON.USERID'];
	PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'CancelComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetScrapMainInfo(scrapId);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}
function Print(){
	var scrapId = $('#scrapId').val();
	if (scrapId == ""){
		PHA.Msg("info", $g("��ѡ���𵥾ݺ��ӡ��"))
		return;
	}
	PrintScrap(scrapId);
}
function DelScrap(){
	var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var scrapId = Selected.scrapId;
	var pJson = {}
	pJson.scrapId = scrapId
	PHA.Confirm($g("ɾ����ʾ"), $g("�Ƿ�ȷ��ɾ���ñ���?"), function () {
		PHA.Loading('Show')	
		PHA.CM({
			pClassName: 'PHA.IN.SCRAP.Api',
			pMethodName: 'Delete',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			if(PHA.Ret(data)){
				QueryMain();
				var scrapId = $('#scrapId').val();
				if(scrapId!=""){Clean();}
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) ;
	}); 
}
function Delete(){
	var scrapId = $('#scrapId').val();
	var rowsNum = $("#gridMScrapDetail").datagrid("getRows");
	if(rowsNum <= 0){
		Clean();
		return;
	}
	// ɾ��ȷ��
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ���ñ���?", function () {
	    var pJson = {}
		
		if (scrapId == ""){
			$('#gridMScrapDetail').datagrid('clear');
			 $('#reasonId').combobox('setValue', '');
			 return;
		}
		PHA.Loading('Show')
		pJson.scrapId = scrapId
		PHA.CM({
			pClassName: 'PHA.IN.SCRAP.Api',
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
function AddOneRow(){
	if(APP_PROP_COM.StkCatSet == "N"){
		var stkGroup = $("#stkGrpId").combobox("getValues").join(",") || "";
		if(stkGroup == ""){
			PHA.Popover({
				msg: "���飬����Ϊ��",
				type: "alert"
			});
			return;
		}  
	}
    PHA_GridEditor.Add({
        gridID: 'gridMScrapDetail',
        field: 'inciDesc',
        rowData: {},
        checkRow: true, // ������ʱ�Ƿ���֤��һ������
        firstRow: false // �����з����������ǰ
    }, 1);
	SetDisable();
}
function AddRows(nData, rowsData){
	for (var i = 0; i < rowsData.length; i++) {
		var iRowData = rowsData[i];
		var iAddData = {};
		iAddData.inci = nData.inci;
		iAddData.inciCode = nData.inciCode;
		iAddData.inciDesc = nData.inciDesc;
		iAddData.spec = nData.inciSpec;
		iAddData.stkbinDesc = nData.stkBin;
		iAddData.insuCode = nData.insuCode;
		iAddData.insuName = nData.insuName;
		iAddData.bUomId = iRowData.bUomId;
		iAddData.fac = iRowData.pFac;

		iAddData.inclb = iRowData.inclb;
		iAddData.inclbQty = iRowData.inclbQty;
		iAddData.expDate = iRowData.expDate;
		iAddData.batNo = iRowData.batNo;
		iAddData.manfDesc = iRowData.manfName;
		iAddData.uomDesc = iRowData.pUomDesc;
		iAddData.uomId = iRowData.pUomId;
		iAddData.rp = iRowData.pRp;
		iAddData.sp = iRowData.pSp;
		iAddData.qty = iRowData.inputQty;

		
		if (i == 0) {
			var selRow = $('#gridMScrapDetail').datagrid('getSelected');
			if (selRow && (selRow.inclb == '' || typeof selRow.inclb == 'undefined')) {
				var rowIndex = $('#gridMScrapDetail').datagrid('options').editIndex;
				$('#gridMScrapDetail').datagrid('updateRow', {
					index: rowIndex,
					row: iAddData
				});
				ChangeRecordInfo(rowIndex, iRowData.inclb, iRowData.inputQty, iRowData.pUomId);
				continue;
			}
		}
		PHA_GridEditor.Add({
			gridID: 'gridMScrapDetail',
			field: '',
			rowData: iAddData
		});
		var curRowIndex = $('#gridMScrapDetail').datagrid("getRows").length - 1;
		ChangeRecordInfo(curRowIndex, iRowData.inclb, iRowData.inputQty, iRowData.pUomId);
	}
	//setTimeout(function(){AddOneRow()},200)
}
function DelChkRows(){
	// Ҫɾ����ID
	var $grid = $('#gridMScrapDetail');
	var checkedRows = $grid.datagrid('getChecked');
	if (checkedRows.length === 0) {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ��������!",
			type: "alert"
		});
		return;
	}
	var pJson = {};
	var scrapItmArr = [];
	for (const rowData of checkedRows) {
		var scrapItmId = rowData.scrapItmId || '';
		if (scrapItmId !== '') {
			scrapItmArr.push({ scrapItmId: scrapItmId });
		}
	}
	pJson.rows = scrapItmArr;
	// ɾ��ȷ��
	PHA.Confirm("ɾ����ʾ",$g("�Ƿ�ȷ��ɾ��") +"<span>" + checkedRows.length + "</span>" + $g("��¼��?"), function () {
		PHA.Loading('Show')
		PHA.CM({
			pClassName: 'PHA.IN.SCRAP.Api',
			pMethodName: 'DeleteItms',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			var rows = $grid.datagrid('getRows');
			for (var j=0;j<checkedRows.length;j++) {
				var tmprowData = checkedRows[j]
				var rowIndex = rows.indexOf(tmprowData);
				$grid.datagrid('deleteRow', rowIndex);
			}
			
			var scrapId = $('#scrapId').val();
			var pJson = {scrapId :scrapId}
			PHA.CM(
		        {
		            pClassName : 'PHA.IN.SCRAP.Api',  
		            pMethodName: 'GetScrapMainInfo',
		            pJson	   : JSON.stringify(pJson),
		        },
		        function (retData) {
					if(retData[0]&&retData[0].noItmFlag){
						PHA.Confirm('��ʾ', '��ϸ�Ѿ�û�м�¼�����Ƿ�ͬʱɾ���˵��ݣ�', function () {
							PHA.Loading('Show')						
								PHA.CM({
									pClassName: 'PHA.IN.SCRAP.Api',
									pMethodName: 'Delete',
									pJson: JSON.stringify(pJson)
								},function(data) {
									PHA.Loading("Hide");
									if(PHA.Ret(data)){
										var scrapId = $('#scrapId').val();
										if(scrapId!=""){Clean();}
									}
								},function(failRet){
									PHA_COM._Alert(failRet);
								})
					   });   
			       }
			       else{
				       PHA.Msg('success', 'ɾ���ɹ�');
				       CalcAmt();
			       }
		        }
		    )
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) 
	});
	SetDisable();

}
function QueryMain(){
    var $grid = $("#gridScrapMain");
	var retJson = PHA.GetVals(["stDate","endDate","phLoc"],"Json");
	if(retJson[0] == undefined) {return;}
	$('#gridScrapDetail').datagrid('clear');
    var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#phLoc").combobox("getValue") || "";  
    var stkGroup = $("#inStkGroup").combobox("getValues").join(",") || "";  
    var scrapRea = $("#scrapReason").combobox("getValue") || "";  
    var scrapStatus = $("#buisProcess").combobox("getValues").join(",");
    if(scrapStatus == ""){
		var comboData=$("#buisProcess").combobox('getData');
		for(var i = 0; i < comboData.length; i++){
			if(scrapStatus == "") {scrapStatus=comboData[i].RowId;}
			else{scrapStatus=scrapStatus + "," + comboData[i].RowId;}
		}
	}    
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stkGroup = stkGroup;
    pJson.scrapRea = scrapRea;
    pJson.scrapStatus = scrapStatus;

	$grid.datagrid('options').url = PHA.$URL;
	$grid.datagrid('query',{
		pClassName:'PHA.IN.SCRAP.Api' ,
		pMethodName:'GetScrapMainList',
		pPlug:'datagrid',
		pJson: JSON.stringify(pJson)
	}); 

}
function QueryDetail(){
	var $grid = $("#gridScrapDetail")
    var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var scrapId = Selected.scrapId;
    var pJson = {};
    pJson.scrapId = scrapId;    
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.SCRAP.Api' ,
        pMethodName:'GetScrapDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function SelectScrap(){
    var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var scrapId = Selected.scrapId;
    CloseDiag();
    var copyFlag = $('#btnSelScrap')[0].innerText.indexOf($g("����")) > -1 ? true : false;
    if(copyFlag == true){
		CopyScrap(scrapId)
	}else{
  		GetScrapMainInfo(scrapId);
  		$("#stkGrpId").combobox("setValues","");  
	}
   
}
// ��ȡ����������
function GetScrapMainInfo(scrapId)
{
	var pJson = {};
    pJson.scrapId = scrapId; 
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'GetScrapMainInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			var locId = data[0].scrapLocId || '' ;
            var locDesc = data[0].scrapLocDesc || '' ;
            data[0].scrapLocId = {
                RowId: locId,
                Description:locDesc,
                Select: false
            }
			PHA.SetVals(data, "#qCondition");
			SetDisable()
			SetInfoArea(data)
			$("#gridMScrapDetail").datagrid('query',{
				pPlug:'datagrid',
		        pJson: JSON.stringify(pJson)
		    });
		}else{
			PHA_COM._Alert(failRet);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}

function CloseDiag(){
    $('#diagFindScrap').dialog('close');
}

// ��ť������
function SetDisable(flag)
{	if(flag == undefined){
		var flag = $("#compFlag").checkbox("getValue");
	}
	var scrapId = $('#scrapId').val() || "";
	var $grid = $('#gridMScrapDetail' );
	var rowsData = $grid.datagrid('getRows');
	var rows = rowsData.length;
	if((scrapId == "")&&(rows == 0)){
		$("#scrapLocId").combobox('enable'); 
	}else{
		$("#scrapLocId").combobox('disable'); 
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
		'#btnAddRows': {
			disabled : flag == true
		},
		'#btnDelRows': {
			disabled : flag == true
		},
		'#btnSave': {
			disabled : flag == true
		},
		'#btnPrint': {
			disabled : scrapId == ""
		}
	});

	
}
function ChangeRecordInfo(rowIndex, inclb, qty, uomId){

	var pJson = {};
	pJson.inclb = inclb ;
	pJson.qty = qty ;
	pJson.uomId = uomId ;
	PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'ChangeRecordInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		$('#gridMScrapDetail').datagrid('updateRowData', {
			index: rowIndex,
			row: data
		});
		CalcAmt();
		
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}

function CalcAmt(){
	PHA_COM.SumGridFooter('#gridMScrapDetail' , ['rpAmt', 'spAmt']);
}

// ��ȡ���Ƶı�����Ϣ
function CopyScrap(scrapId){

	var pJson = {};
    pJson.scrapId = scrapId; 
    pJson.userId = session['LOGON.USERID'];  
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'CopyScrap',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			GetScrapMainInfo(data.data);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}

function SetInfoArea(retData){
	var dataArr = [
	  {
	    info: retData[0].scrapNo ,
	    append: '/'
	  },
	  {
	    prepend: $g("�Ƶ�")+":" ,
	    info: retData[0].scrapUserName + ' ' + retData[0].scrapDate+ ' ' + retData[0].scrapTime,
	    append: '/'
	  },
	  {
	    info:retData[0].compFlag == "Y" ? $g("���"): $g("δ���"),
	    labelClass: retData[0].compFlag == "Y" ? 'info' : 'danger'
	  }
	];
	
	$('#infoArea').phabanner('loadData', dataArr);

}