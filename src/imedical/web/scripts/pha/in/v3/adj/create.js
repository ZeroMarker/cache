/*
/// Creator     zhaozhiduan
/// CreatDate   2022��03��11��
/// Description ����������
*/
var APP_NAME = "DHCSTSTOCKADJ"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var APP_PROP_COM = PHA_COM.ParamProp("DHCSTCOMMON");
var BUIS_CODE = "ADJ";
var BUIS_RANGE = "All";
$(function(){
	PHA_COM.SetPanel('#panel');
    InitDict();             // ��ʼ�������ֵ�
    InitGridMAdjDetail();   // ��ʼ��grid
    InitBtn();              // ��ʼ����ť
    // dialog ��ʼ��
    InitGridAdjMain();
    InitGridAdjDetail();
    SetDisable();
	SetRequired();
	setTimeout(function () {
		PHA_COM.ResizePanel({
		   layoutId: 'layout-adj-create-diag',
		   region: 'north',
		   height: 0.5 
	   });
   }, 0);
    
})
function InitDefVal(){
	var locId =  $("#adjLocId").combobox("getValue") || PHA_COM.Session.CTLOCID
    $('#phLoc').combobox('setValue', locId);
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
	$('#buisProcess').combobox('reload');
}
function SetRequired(){
	PHA.SetRequired($('#gridAdjMainBar' + ' [data-pha]'))
	PHA.SetRequired($('#gridMAdjDetailBar' + ' [data-pha]'))
}
function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 'click', function () {
        ShowDiagAdj(this);
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        SaveAdj();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        Clean();
    });    
    PHA_EVENT.Bind('#btnComplete', 'click', function () {
        Complete();
    }); 
    PHA_EVENT.Bind('#btnCancelComp', 'click', function () {
        CancelComp();
    }); 
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        Print();
    }); 
    PHA_EVENT.Bind('#btnDelete', 'click', function () {
        Delete();
    }); 
    PHA_EVENT.Bind('#btnCopyAdj', 'click', function () {
        ShowDiagAdj(this);
    });
    //���ť
    PHA_EVENT.Bind('#btnAddRows', 'click', function () {
        AddOneRow();
    });
    PHA_EVENT.Bind('#btnDelRows', 'click', function () {
        DelChkRows();
    });
    
    // dialog ��ť
    PHA_EVENT.Bind('#btnSearch', 'click', function () {QueryMain();});
    PHA_EVENT.Bind('#btnClean-q', 'click', function () {CleanQ();});
    PHA_EVENT.Bind('#btnSelAdj', 'click', function () {SelectAdj();});
    PHA_EVENT.Bind('#btnDelAdj', 'click', function () {DelAdj();});
}

function InitDict(){
	//ҩ������
    PHA_UX.ComboBox.Loc('adjLocId');
    
	//����
	PHA_UX.ComboBox.StkCatGrp('stkGrpId', {
		panelHeight: 'auto',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('adjLocId', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
     //������ԭ��
    PHA.ComboBox('reasonId', {
		panelHeight: 'auto',
        url: PHA_IN_STORE.ReasonForAdj().url
    });
    
    // dialog ҩ������
    //ҩ������
    PHA_UX.ComboBox.Loc('phLoc');
	//����
	PHA_UX.ComboBox.StkCatGrp('inStkGroup', {
		panelHeight: 'auto',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('phLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
    //������ԭ��
    PHA.ComboBox('adjReason', {
		panelHeight: 'auto',
        url: PHA_IN_STORE.ReasonForAdj().url
    });
	/* ��Ϣչʾ�� */
	$('#infoArea').phabanner({
	    title: $g('ѡ�񵥾ݺ�, ��ʾ��ϸ��Ϣ')
	});
}

function InitAdjStatus(flag){
	//ҵ������
	PHA.ComboBox('buisProcess', {
		multiple:true,
		editor:false,
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
						if((desc.indexOf($g("����")) < 0)&&(desc.indexOf($g("���")) < 0 )) continue;
					}else if(flag == 2){	 //����
						if(desc.indexOf($g("����")) < 0) continue;
					}
                    displayData.push(iData);
                }
                return displayData;				
			}
        }
    });

}
function InitGridMAdjDetail(){
    var gridId = 'gridMAdjDetail'
    var columns = [
        [
            { field: 'spec', 		title: '���', 			align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '��λ', 			align: 'left', 	width: 80 },
            { field: 'qty', 		title: '��������',		align: 'right',	width: 80,
            	editor: PHA_GridEditor.NumberBox({
					required: true,
					precision: GetDecimals(APP_PROP_COM.FmtSQ),
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
						if (nQty == 0) {
							checkRet.msg = "�������0�����֣�";
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
            { field: 'resultQty', 		title: '��������',		align: 'right',	width: 80,
            	editor: PHA_GridEditor.NumberBox({
					checkOnBlur: true,
					precision: GetDecimals(APP_PROP_COM.FmtSQ),
					checkValue: function (val, checkRet) {
						if (val != "") {
							var nQty = parseFloat(val);
							if (nQty < 0) {
								checkRet.msg = "�������0�����֣�";
								return false;
							}
						}
						return true;
					},
					onBlur:function(val, rowData, rowIndex){
						var resultQty = parseFloat(val);
						var inclbQty = rowData.inclbQty;
						ChangeQtyByResultQty(rowIndex, resultQty, inclbQty);
					},
					onBeforeNext: function (val, gridRowData, gridRowIndex) {
						var resultQty = parseFloat(val);
						var inclbQty = gridRowData.inclbQty;
						ChangeQtyByResultQty(rowIndex, resultQty, inclbQty);
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
            { field: 'avaQty', 		title: '���ÿ��',		align: 'right',	width: 100},
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
            { field: 'adjItmId',    title: 'adjItmId',		align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '����', 			align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',  align: 'left',    width: 300, sortable: true,
                editor: PHA_UX.Grid.INCItmBatWin({
					onBeforeLoad: function(param, gridRowData){
						param.hospId = session['LOGON.HOSPID'];
						param.pJsonStr = JSON.stringify({
							stkType: App_StkType,
							scgId: $("#stkGrpId").combobox("getValues").join(",") || "", 
							locId: $("#adjLocId").combobox("getValue") || "",
							userId: session['LOGON.USERID'],
							notUseFlag: '',
							qtyFlag: '',
							reqLocId: ''
						});
					},
					onBeforeNext: function (winData, gridRowData, gridRowIndex) {
						if (winData.action == 'close') {
							return true;
						}
						var nData = winData.north;
						var cData = winData.center;
						
					},
					onClickSure: function(winData){
						var nData = winData.north;
						var cDataRows = winData.center;
						AddRows(nData, cDataRows);
					}
				},{
					inputType: 'ADJ'
				})
            }
        ]
    ];

    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: '#gridMAdjDetailBar',
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
            pClassName:'PHA.IN.ADJ.Api' ,
            pMethodName:'GetAdjDetail',
            pPlug:'datagrid',
            pJson:"{}"
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
function InitGridAdjMain(){
    var columns = [
        [
            { field: 'adjId',       title: '����id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'adjNo',       title: '����',		align: 'left',	width: 160,
				styler: function(value,row,index){				
					return {class:"pha-grid-link" };
				}
			},
            { field: 'adjLoc',      title: '����',		align: 'left',	width: 100,	hidden: true  },
            { field: 'adjDate',     title: '�Ƶ�����',  align: 'left',	width: 80 },
            { field: 'adjTime',     title: '�Ƶ�ʱ��',  align: 'left',	width: 80 },
            { field: 'rpAmt',       title: '���۽��',  align: 'right',	width: 80},
            { field: 'spAmt',       title: '�ۼ۽��',  align: 'right',	width: 80},
            { field: 'reasonId',  	title: '����ԭ��',  align: 'left',	width: 100,	hidden: true   },
            { field: 'reasonDesc',  title: '����ԭ��',  align: 'left',	width: 100 },
            { field: 'remarks',     title: '��ע',		align: 'left',	width: 100 },
            { field: 'curStatus',   title: '״̬',		align: 'left',	width: 80 },
            { field: 'curPbDate',   title: '״̬��������',	align: 'left',	width: 100 },
            { field: 'curPbTime',   title: '״̬����ʱ��',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	title: '״̬������',	align: 'left',	width: 100 },
            { field: 'newStatusInfo',title: '������ת��Ϣ',	align: 'left',	width: 200 },
            { field: 'copyInfo',    title: '������',	align: 'left',	width: 120 }
			
        ]
    ];
    var dataGridOption = {
	    gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridAdjMainBar',
        exportXls: false,
        columns: columns,
        onSelect: function(rowIndex, rowData) {

            QueryDetail()
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                SelectAdj()
            }
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridAdjMain').datagrid("selectRow",0);
            }else{
	        	$('#gridAdjDetail').datagrid('clear');
	        }
        },
        onClickCell: function (index, field, value) {      
			if(field=="adjNo"){
                var rowData = $('#gridAdjMain').datagrid('getData').rows[index];
                PHA_UX.BusiTimeLine({},{
                    busiCode:BUIS_CODE,
                    locId:$("#adjLocId").combobox("getValue") || PHA_COM.Session.CTLOCID,
                    pointer:rowData.adjId,
                    No:value
                });
            }else{
                PHA_UX.BusiTimeLine({},{},"close")
            }
        }
        
    };
    PHA.Grid('gridAdjMain', dataGridOption);
}
function InitGridAdjDetail(){
    var columns = [
        [
            { field: 'spec',        title: '���',			align: 'left',  width: 80 },
            { field: 'stkbinDesc',  title: '��λ',			align: 'left',  width: 80 },
            { field: 'qty',         title: '��������',		align: 'right', width: 100 },
            { field: 'resultQty', 	title: '��������',		align: 'right',	width: 100 },
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
            { field: 'inclb',       title: 'inclb',         align: 'left',  width: 100},
            { field: 'adjItmId',    title: 'adjItmId',      align: 'left',  width: 100},
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
        frozenColumns: frozenColumns,
        showFooter: true,
        onLoadSuccess: function (data) {
            PHA_COM.SumGridFooter('#gridAdjDetail' , ['rpAmt', 'spAmt']);
         }
    };
    PHA.Grid('gridAdjDetail', dataGridOption);

}
function ShowDiagAdj(btnOpt){
	var isFind = btnOpt.id.indexOf("Find") >-1 ? true : false;
    $('#diagFindAdj').dialog({
            title: btnOpt.text,
            iconCls: isFind ? 'icon-w-list' : 'icon-w-copy',
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            modal: true
    }).dialog('open');
    if(isFind == true){
	 	var htmlStr = $('#btnSelAdj')[0].innerHTML;
	 	$('#btnSelAdj')[0].innerHTML=htmlStr.replace($g("����"), $g("ѡȡ"));
		$('#btnDelAdj').show();
	 	InitAdjStatus(1);
	}else{
		var htmlStr = $('#btnSelAdj')[0].innerHTML;
	 	$('#btnSelAdj')[0].innerHTML=htmlStr.replace($g("ѡȡ"), $g("����"))
		$('#btnDelAdj').hide();
	 	InitAdjStatus(2);
	}
    $('#gridAdjMain').datagrid('clear');
    $('#gridAdjDetail').datagrid('clear');
	InitDefVal();
}
function ValidateEditGrid(){
	var val = true
	var msg = "";
	var gridId = "gridMAdjDetail"
	var $grid = $('#' + gridId);
	PHA_GridEditor.GridFinalDone("#gridMAdjDetail", 'inclb');
	var rows = $grid.datagrid('getRows');
	if (rows.length ==0) {
		PHA.Msg('error', "��ϸû�����ݣ�");
		return false;
	}
	var editRow = 0
	try{
		msg = PHA_GridEditor.CheckValues(gridId);
		if(msg != ""){
			throw msg;
		}
		msg = PHA_GridEditor.CheckDistinct({ gridID : gridId,	fields : ["inclb"]});
		if(msg != ""){
			throw msg;
		}
		
		var rowsData = $grid.datagrid('getRows');
		var rows = rowsData.length;
		if (rows == 0) {
			throw 'û����Ҫ����������';
		}
		for (var i = 0; i < rows; i++) {
			var rowData = rowsData[i];
			var inclb = rowData.inclb;
			if(inclb == ""){
				continue;
			} 
			var qty = rowData.qty;
			var fac = rowData.fac;
			var uomId = rowData.uomId;
			var bUomId = rowData.bUomId;
			var inclbQty = rowData.inclbQty;
			if ((qty=='')||(parseFloat(qty)==0)){
				editRow = i;
				throw $g("��") +"<span>"+ (i + 1)+"</span>" + $g("��,������������Ϊ��!");
					
			} 
			if ((parseFloat(qty) < 0) && (Math.abs(qty) > parseFloat(inclbQty))){
				editRow = i ;
				throw $g("��") +"<span>"+ (i + 1)+"</span>" + $g("��,��������Ϊ����ʱ���ܳ������ο��!");		
			} 
			var bQty = qty;
			
			if(APP_PROP.StockAllowDecimal != "Y"){
				if(bUomId != uomId)
				{
					bQty =_.multiply(qty, fac);
				}else{
					bQty = qty;
				}
				if (parseInt(bQty, 10) != bQty){	
					editRow = i ;
					throw $g("��") +"<span>"+ (i + 1)+"</span>" + $g("��, ������������С�������ܵ�������˶Կ��������ã�������������Ϊ������λ�Ƿ�����С��!");
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
		if (editRow >= 0){
			PHA_GridEditor.Edit({
				gridID : gridId,
				index : editRow,
				field : 'qty'
			});
		}
		return val;
	}
}
function SaveAdj(){
	var gridId = "gridMAdjDetail"
	PHA_GridEditor.End(gridId);
	if( ValidateEditGrid() ===false){return;}
	PHA_GridEditor.End(gridId);
	
	var retJson = PHA.GetVals(["adjId","adjLocId","reasonId","remarks"],"Json");
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
		var adjItmId = rowData.adjItmId
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		var uomId = rowData.uomId;
		var resultQty = rowData.resultQty;
		
		var iJson = {
			adjItmId :adjItmId,
	  		inclb : inclb,
            uomId : uomId,
            qty   : qty,
            resultQty : resultQty       
        };
        dataArr.push(iJson);
    }
    
	pJson.rows = dataArr;
	PHA.Loading("Show");
    PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'SaveData',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetAdjMainInfo(data.data);
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
    $('#gridMAdjDetail').datagrid('clear');
    $('#adjLocId').combobox('setValue', PHA_COM.Session.CTLOCID);
	$('#infoArea').phabanner('loadData', []);
    SetDisable();
}
function CleanQ()
{
    PHA.DomData("#winQCondition", {
        doType:'clear'
    })
    $('#gridAdjMain').datagrid('clear');
	$('#gridAdjDetail').datagrid('clear');
	InitDefVal();
}
function Complete(){
	var gridId = "gridMAdjDetail"
	PHA_GridEditor.End(gridId);
	if( ValidateEditGrid() ===false){return;}
	var retJson = PHA.GetVals(["adjId","adjLocId","reasonId","remarks"],"Json");
	if(retJson[0] == undefined) {return;}
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID'];  
	var $grid = $('#' + gridId);
    //var rowsData = $grid.datagrid('getRows');
	var rowsData = $grid.datagrid('getChanges');
    var rows = rowsData.length;
    var dataArr = [];
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var adjItmId = rowData.adjItmId
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		var uomId = rowData.uomId;
		var iJson = {
			adjItmId :adjItmId,
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
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'SaveComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetAdjMainInfo(data.data);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})  	

}
function CancelComp(){
	PHA.Loading('Show')
	var pJson = {}
	var adjId = $('#adjId').val();
	pJson.adjId = adjId;
	pJson.compFlag = "N";
	pJson.userId =  session['LOGON.USERID'];
	PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'CancelComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetAdjMainInfo(adjId);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}
function Print(){
	var adjId = $('#adjId').val();
	if (adjId == ""){
		PHA.Msg("info", "��ѡ��������ݺ��ӡ��")
		return;
	}
	PrintAdj(adjId);
}
function DelAdj(){
	var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var adjId = Selected.adjId;
	var pJson = {}
	pJson.adjId = adjId
	// ɾ��ȷ��
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ���õ�����?", function () {	  
		PHA.Loading('Show')
		PHA.CM({
			pClassName: 'PHA.IN.ADJ.Api',
			pMethodName: 'Delete',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			if(PHA.Ret(data)){
				QueryMain();
				var adjId = $('#adjId').val();
				if(adjId!=""){Clean();}
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) 
	});
}
function Delete(){
	var adjId = $('#adjId').val() || "";
	var rowsNum = $("#gridMAdjDetail").datagrid("getRows");
	if(rowsNum <= 0){
		Clean();
		return;
	}
	// ɾ��ȷ��
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ���õ�����?", function () {	
	    var pJson = {}
		if (adjId == ""){
			$('#gridMAdjDetail').datagrid('clear');
			 $('#reasonId').combobox('setValue', '');
			 return;
		}
		PHA.Loading('Show')
		pJson.adjId = adjId
		PHA.CM({
			pClassName: 'PHA.IN.ADJ.Api',
			pMethodName: 'Delete',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			if(PHA.Ret(data)){
				Clean();
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) 
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
        gridID: 'gridMAdjDetail',
        field: 'inciDesc',
        rowData: {},
        checkRow: true, // ������ʱ�Ƿ���֤��һ������
        firstRow: false // �����з����������ǰ
    }, 1);
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
		
		iAddData.inclb = iRowData.inclb;
		iAddData.inclbQty = iRowData.inclbQty;  
		iAddData.avaQty = iRowData.avaQty;  
		
		iAddData.expDate = iRowData.expDate;
		iAddData.batNo = iRowData.batNo;
		iAddData.manfDesc = iRowData.manfName;
		iAddData.uomDesc = iRowData.pUomDesc;
		iAddData.uomId = iRowData.pUomId;
		iAddData.rp = iRowData.pRp;
		iAddData.sp = iRowData.pSp;
		iAddData.qty = iRowData.inputQty;
		iAddData.resultQty = iRowData.resultQty;
		if(iRowData.resultQty != ""){
			iAddData.qty = _.safecalc('add', iAddData.resultQty, _.safecalc('multiply', -1, iRowData.inclbQty))
		}
		iAddData.fac = iRowData.pFac;
		iAddData.bUomId = iRowData.bUomId;
		
		if (i == 0) {
			var selRow = $('#gridMAdjDetail').datagrid('getSelected');
			if (selRow && (selRow.inclb == '' || typeof selRow.inclb == 'undefined')) {
				var rowIndex = $('#gridMAdjDetail').datagrid('options').editIndex;
				$('#gridMAdjDetail').datagrid('updateRowData', {
					index: rowIndex,
					row: iAddData
				});
				ChangeRecordInfo(rowIndex, iRowData.inclb, iRowData.inputQty, iRowData.pUomId);
				continue;
			}
		}
		PHA_GridEditor.Add({
			gridID: 'gridMAdjDetail',
			field: '',
			rowData: iAddData
		});
		var curRowIndex = $('#gridMAdjDetail').datagrid("getRows").length - 1;
		ChangeRecordInfo(curRowIndex, iRowData.inclb, iRowData.inputQty, iRowData.pUomId);
	
	}
	setTimeout(function(){AddOneRow()},200)
}
function DelChkRows(){
	// Ҫɾ����ID
	var $grid = $('#gridMAdjDetail');
	var checkedRows = $grid.datagrid('getChecked');
	if (checkedRows.length === 0) {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ��������!",
			type: "alert"
		});
		return;
	}
	var pJson = {};
	var adjItmArr = [];
	for (const rowData of checkedRows) {
		var adjItmId = rowData.adjItmId || '';
		if (adjItmId !== '') {
			adjItmArr.push({ adjItmId: adjItmId });
		}
	}
	pJson.rows = adjItmArr;
	// ɾ��ȷ��
	PHA.Confirm("ɾ����ʾ",$g("�Ƿ�ȷ��ɾ��") + "<span>" + checkedRows.length + "</span>" + $g("��¼��?"), function () {
		PHA.Loading('Show')
		PHA.CM({
			pClassName: 'PHA.IN.ADJ.Api',
			pMethodName: 'DeleteItms',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			var rows = $grid.datagrid('getRows');
			for (const chkit of checkedRows) {
				var rowIndex = rows.indexOf(chkit);
				$('#gridMAdjDetail').datagrid('deleteRow', rowIndex);
			}
			
			var adjId = $('#adjId').val();
			var pJson = {adjId :adjId}
			PHA.CM(
		        {
		            pClassName : 'PHA.IN.ADJ.Api',  
		            pMethodName: 'GetAdjMainInfo',
		            pJson	   : JSON.stringify(pJson),
		        },
		        function (retData) {
					if(retData[0]&&retData[0].noItmFlag){
						PHA.Confirm('��ʾ', '��ϸ�Ѿ�û�м�¼�����Ƿ�ͬʱɾ���˵��ݣ�', function () {
							PHA.Loading('Show')						
								PHA.CM({
									pClassName: 'PHA.IN.ADJ.Api',
									pMethodName: 'Delete',
									pJson: JSON.stringify(pJson)
								},function(data) {
									PHA.Loading("Hide");
									if(PHA.Ret(data)){
										QueryMain();
										var adjId = $('#adjId').val();
										if(adjId!=""){Clean();}
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
}
function QueryMain(){
	var $grid =  $("#gridAdjMain");
	$('#gridAdjDetail').datagrid('clear');
    var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#phLoc").combobox("getValue") || "";  
    var stkGroup = $("#inStkGroup").combobox("getValues").join(",") || "";  
    var adjRea = $("#adjReason").combobox("getValue") || "";  
    var adjStatus = $("#buisProcess").combobox("getValues").join(",");
    if(adjStatus == ""){
		var comboData=$("#buisProcess").combobox('getData');
		for(var i = 0; i < comboData.length; i++){
			if(adjStatus == "") {adjStatus=comboData[i].RowId;}
			else{adjStatus=adjStatus + "," + comboData[i].RowId;}
		}
	}
    var instFlag = "N";
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stkGroup = stkGroup;
    pJson.adjRea = adjRea;
    pJson.adjStatus = adjStatus;
    pJson.instFlag = instFlag;
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.ADJ.Api' ,
        pMethodName:'GetAdjMainList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    });
}
function QueryDetail(){
	var $grid = $("#gridAdjDetail")
    var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var adjId = Selected.adjId;
    var pJson = {};
    pJson.adjId = adjId;   
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.ADJ.Api' ,
        pMethodName:'GetAdjDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
    
}
function SelectAdj(){
    var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var adjId = Selected.adjId;
    Close();
    var copyFlag = $('#btnSelAdj')[0].innerText.indexOf($g("����")) > -1 ? true : false;
    
    if(copyFlag == true){
		CopyAdj(adjId)
	}else{
  		GetAdjMainInfo(adjId);
  		$("#stkGrpId").combobox("setValues","");  
	}
}
// ��ȡ����������
function GetAdjMainInfo(adjId)
{
	var pJson = {};
    pJson.adjId = adjId; 
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'GetAdjMainInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			var locId = data[0].adjLocId || '' ;
            var locDesc = data[0].adjLocDesc || '' ;
            data[0].adjLocId = {
                RowId: locId,
                Description:locDesc,
                Select: false
            }
			PHA.SetVals(data, "#qCondition");
			SetDisable();
			SetInfoArea(data);
			$("#gridMAdjDetail").datagrid('query',{
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


function Close(){
    $('#diagFindAdj').dialog('close');
}

// ��ť������
function SetDisable(flag)
{	if(flag == undefined){
		var flag = $("#compFlag").checkbox("getValue");
	}
	var adjId = $('#adjId').val() || "";
	if(adjId == ""){
		$("#adjLocId").combobox('enable'); 
	}else{
		$("#adjLocId").combobox('disable'); 
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
			disabled : adjId == ""
		}
	});
}

function ChangeQtyByResultQty(rowIndex, resultQty, inclbQty){
	if ((resultQty == "")||(isNaN(resultQty))||resultQty==undefined) return;
	var qty = _.safecalc('add', resultQty, _.safecalc('multiply', -1, inclbQty))
	var data = {
		'qty' : qty
	}
	$('#gridMAdjDetail').datagrid('updateRowData', {
		index: rowIndex,
		row: data
	});
	CalcAmt();
}


function ChangeRecordInfo(rowIndex, inclb, qty, uomId){

	var pJson = {};
	pJson.inclb = inclb ;
	pJson.qty = qty ;
	pJson.uomId = uomId ;
	PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'ChangeRecordInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		$('#gridMAdjDetail').datagrid('updateRowData', {
			index: rowIndex,
			row: data
		});
		CalcAmt();
		
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}

function CalcAmt(){
	PHA_COM.SumGridFooter('#gridMAdjDetail' , ['rpAmt', 'spAmt']);
}
// ��ȡ���Ƶĵ�������Ϣ
function CopyAdj(adjId){

	var pJson = {};
    pJson.adjId = adjId; 
    pJson.userId = session['LOGON.USERID'];  
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'CopyAdj',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			GetAdjMainInfo(data.data);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}

function SetInfoArea(retData){
	var dataArr = [
	  {
	    info: retData[0].adjNo ,
	    append: '/'
	  },
	  {
	    prepend: $g("�Ƶ�")+":",
	    info: retData[0].adjUserName + ' ' + retData[0].adjDate+ ' ' + retData[0].adjTime,
	    append: '/'
	  },
	  {
	    info:retData[0].compFlag == "Y" ? $g("���"): $g("δ���"),
	    labelClass: retData[0].compFlag == "Y" ? 'info' : 'danger'
	  }
	];
	
	$('#infoArea').phabanner('loadData', dataArr);
}

function GetDecimals(fmt){
	var decimals = 2; // Ĭ����λ
	if (fmt.indexOf('.') < 0) return GetDecimals;
	var decimalsStr = fmt.split('.')[1];
	return decimalsStr.length;

}
