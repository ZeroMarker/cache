/**
 * ģ��:     ���������󹫹����������
 * ��д����: 2022-05-10
 * ��д��:   yangsj
 * scripts/pha/in/v3/req/compoment.js
 */
 
 /* ���˵�� 
  * _options{
  * 	select   ����й�ѡ���ԡ�Ĭ�ϲ���ѡ�����Ҫ��ѡ����true����ע��grid����ʱ������ singleSelect: false,
  * 	addAnnex ����Ƿ���ӹ����С�Ĭ����ӣ��������Ҫ����봫�� false (��ʱû�ã��߹�����༭)
  * }
  */
var INRQ_COMPOMENTS = {
	CmbWidth : 160,
	LongCmbWidth: 393,
	API : 'PHA.IN.REQ.Api',
	BUSICODE : 'REQ',
	Select_Col : { 
		field: 'tSelect', 		
		checkbox: true 
	},
	Columns : {
		Main : {
			Frozen : function (_options){
				var columns = [
					{ field: 'inrqId', 		title: 'inrqId', 		hidden: true 					},
		        	{ field: 'reqNo',		title: '���󵥺�',		width: 200,		align: 'left', 
		           		styler: function(value,row,index){				
		                    return {class:"pha-grid-link" };
		                }
			        }
				]
				if (_options){
					if (_options.select) columns.unshift(INRQ_COMPOMENTS.Select_Col)
				}
			    return [columns];
			},
			Normal : function (_options){
				var columns = [
		            { field: 'recLocDesc', 	title: '�������', 		width: 120, 	align: 'left'	},
		            { field: 'proLocDesc', 	title: '��������', 		width: 120, 	align: 'left'	},
		            { field: 'creator', 	title: '������', 		width: 100, 	align: 'left'	},
		            { field: 'createDate', 	title: '��������', 		width: 100, 	align: 'left'	},
		            { field: 'createTime', 	title: '����ʱ��', 		width: 100, 	align: 'left'	},
		            { field: 'compFlag', 	title: '��ɱ�־', 		width: 70, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
		            { field: 'statusDesc', 	title: '����״̬', 		width: 120, 	align: 'left'	},
		            { field: 'remarks', 	title: '��ע', 			width: 120, 	align: 'left'	},
		            { field: 'copyFrom', 	title: '������', 		width: 200, 	align: 'left'	}
			    ]
			    if (_options){
					if (_options.select) columns.unshift(INRQ_COMPOMENTS.Select_Col)
				}
			    return [columns];
			}
		},
		Detail : {
			Frozen : function (_options){
				var columns = [
					{ field: 'inrqiId', 	title: 'inrqiId', 		hidden: true },
					{ field: 'inciCode',	title: 'ҩƷ����',		width: 100,			align: 'left' },
		            { field: 'inciDesc',	title: 'ҩƷ����',		width: 200,			align: 'left' },
		            { field: 'refuseFlag', 	title: '�ܾ�', 			width: 60, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
		            { field: 'transFlag', 	title: '��ת��', 		width: 60, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
		            { field: 'inci', 		title: 'inci', 			hidden: true }
		            
				]
				if (_options){
					if (_options.select) columns.unshift(INRQ_COMPOMENTS.Select_Col)
				}
			    return [columns];	
			},
			Normal : function (_options){
				var columns = [
					{ field: 'qty', 		title: '��������', 		width: 80, 		align: 'right'	},
					{ field: 'proLocQty', 	title: '��Ӧ�������', 	width: 80, 		align: 'right'	},
		            { field: 'recLocQty', 	title: '���󷽿��', 	width: 80, 		align: 'right'	},
		            { field: 'rp', 			title: '����', 			width: 80, 		align: 'right'	},
		            { field: 'rpAmt', 		title: '���۽��', 		width: 80, 		align: 'right'	},
		            { field: 'sp', 			title: '�ۼ�', 			width: 80, 		align: 'right'	},
		            { field: 'spAmt', 		title: '�ۼ۽��', 		width: 100, 	align: 'right'	},
		            { field: 'uomId', 		title: 'uomId', 		hidden: true 	},
		            { field: 'uomDesc', 	title: '��λ', 			width: 100, 	align: 'right'	},
		            { field: 'remark', 		title: '��ע', 			width: 100, 	align: 'left'	},
		            { field: 'inciSpec', 	title: '���', 			width: 100, 	align: 'left'	},
		            { field: 'geneName', 	title: '����ͨ����', 	width: 100, 	align: 'left'	},
		            { field: 'phcFormDesc', title: '����', 			width: 100, 	align: 'left'	},
		            { field: 'sugQty', 		title: '������������', 	width: 100, 	align: 'left'	},
		            { field: 'manfName', 	title: '������ҵ', 		width: 200, 	align: 'left'	},
		            { field: 'insuCode', 	title: '����ҽ������', 	width: 100, 	align: 'left'	},
            		{ field: 'insuDesc', 	title: '����ҽ������', 	width: 100, 	align: 'left'	}
				]
				if (_options){
					if (_options.select) columns.unshift(INRQ_COMPOMENTS.Select_Col)
				}
			    return [columns];
			}
		}
	},
	InitGridInrqStatus: function(gridId){
		var columns = [
	        [
	            { field: 'codeID', 		title: 'codeID', 	hidden: true },
	        	{ field: 'code', 		title: 'code', 		hidden: true },
	            { field: 'desc', 		title: '��������', 	width: 80, 		align: 'left'	},
	            { field: 'userName', 	title: '������', 	width: 80, 		align: 'left'	},
				{ field: 'date', 		title: '����', 		width: 100, 	align: 'left'	},
	            { field: 'time', 		title: 'ʱ��', 		width: 100, 	align: 'left'	}
	        ]
	    ];
	    var dataGridOption = {
			url: PHA.$URL,
			queryParams: {},
			singleSelect: true,
			pagination: false,
			columns: columns,
			gridSave: false,
			isCellEdit: false,
			allowEnd: true,
			isAutoShowPanel: true
		};
		PHA.Grid(gridId, dataGridOption);
	},
	
	FrToLoc : function(frLocId, toLocArr, frCallback, toCallback){
		frLocId = frLocId || '';
		if(!frLocId) return;
		toLocArr = toLocArr || [];
		var toLocArrLen = toLocArr.length;
		if(!toLocArrLen) return;
		frCallback = frCallback || '';
		toCallback = toCallback || '';
		PHA_UX.ComboBox.Loc(frLocId, {width: INRQ_COMPOMENTS.CmbWidth});
		for (i=0;i<toLocArrLen;i++){
			var toLocId = toLocArr[i]
			PHA_UX.ComboBox.Loc(toLocId, {
		        width: INRQ_COMPOMENTS.CmbWidth,
		        defValue: '',
		        qParams: {
		            proLocId: PHA_UX.Get(frLocId, session['LOGON.CTLOCID']),  // ����ʱ��̬ȡֵ,�ڶ�������ΪĬ��ֵ
		            relType: 'R'
		        },
		        onSelect:function(option){
			        if(toCallback){
				       /* ����������ҹ�ϵȷ��ת������ */
				       var recLocId = option.RowId
				       toCallback(recLocId);
			        }
		        }
		    });
		}
	},
	
	ToFrLoc :  function(toLocId, frLocId, frCallback, toCallback){
		if(!toLocId || !frLocId) return;
		PHA_UX.ComboBox.Loc(toLocId, {width: INRQ_COMPOMENTS.CmbWidth});
	    PHA_UX.ComboBox.Loc(frLocId, {
			qParams: {
				recLocId: PHA_UX.Get(toLocId, session['LOGON.CTLOCID']),  // ����ʱ��̬ȡֵ,�ڶ�������ΪĬ��ֵ
				relType: 'TR'
			}
		});
	},
	Scg : function(scgId, locId){
		if(!scgId || !locId) return;
		PHA_UX.ComboBox.StkCatGrp(scgId, {
		    width: INRQ_COMPOMENTS.CmbWidth,
		    multiple: true,
	        rowStyle:'checkbox',
			qParams: {
				LocId: PHA_UX.Get(locId, session['LOGON.CTLOCID']),
				UserId: session['LOGON.USERID']
			}
		});
	},
	StkCat : function(domId, scgIf){
		PHA_UX.ComboBox.StkCat('stkcatId', {
	        width: INRQ_COMPOMENTS.CmbWidth,
	        multiple: true,
	        rowStyle:'checkbox',
	        qParams: {
	            CatGrpId: PHA_UX.Get(scgIf)
	        }
	    });
	},
	ReqTypeId : function(domId, multiple, required){
		multiple = multiple || false;
		required = required || false;
		PHA.ComboBox(domId, {
	        panelHeight: 'auto',
	       	value: 'O',             //Ĭ�ϳ�ʼֵ
	       	required: required,
	       	multiple: multiple,
	        rowStyle: multiple ? 'checkbox' : '',
	        editable: required ? false : true,
	        width: INRQ_COMPOMENTS.CmbWidth,
	        url: PHA_IN_STORE.ReqType().url,
	    });
	},
	ReqStatus : function(domId, rangeFlag, multiple, LongWidthFlag, LongWidth){
		multiple = multiple || false;
		LongWidthFlag = LongWidthFlag || false;
		LongWidth = LongWidth || '';
		var width = INRQ_COMPOMENTS.ComWidth;
		if(LongWidth) width = LongWidth;
		else width = LongWidthFlag ? INRQ_COMPOMENTS.LongCmbWidth : INRQ_COMPOMENTS.CmbWidth
		PHA.ComboBox(domId, {
	        width: width,
	        multiple: multiple,
	        rowStyle: multiple ? 'checkbox' : '',
	        url: PHA_IN_STORE.ReqStauts(rangeFlag).url
	    });
	},
	/*����ҵ��*/
	BizRange : function(domId, multiple, LongWidthFlag, LongWidth){
		multiple = multiple || false;
		LongWidthFlag = LongWidthFlag || false;
		LongWidth = LongWidth || '';
		var width = INRQ_COMPOMENTS.ComWidth;
		if(LongWidth) width = LongWidth;
		else width = LongWidthFlag ? INRQ_COMPOMENTS.LongCmbWidth : INRQ_COMPOMENTS.CmbWidth
		PHA.ComboBox(domId, {
	        width: width,
	        multiple: multiple,
	        rowStyle: multiple ? 'checkbox' : '',
	        data: [
                { RowId: 'P,PH', Description: 'סԺ��ҩ' },
                { RowId: 'Y,YH', Description: 'סԺ��ҩ' },
                { RowId: 'F,FH', Description: '���﷢ҩ' },
                { RowId: 'H,HH', Description: '������ҩ' },
                { RowId: 'T,TC', Description: 'ת�Ƴ���' },
                { RowId: 'K,KC', Description: 'ת�����' }
            ]
	    });
	},
	/* ��ʼ�����б� */
	InitMainGrid:function(gridId, barId, clickCallback, click2Callback){
		var dataGridOption = {
			url: PHA.$URL,
			queryParams: {},
			singleSelect: true,
			pagination: true,
			columns: INRQ_COMPOMENTS.Columns.Main.Normal(),
			frozenColumns: INRQ_COMPOMENTS.Columns.Main.Frozen(),
			toolbar: barId,
			gridSave: false,
			isCellEdit: false,
			allowEnd: true,
			onClickRow: function (rowIndex, rowData) {clickCallback(rowData.inrqId)},
			onDblClickRow: function (rowIndex, rowData) {click2Callback(rowData.inrqId)},
			onClickCell: function (index, field, value) {      
				if(field == "reqNo"){
	                var rowData = $('#' + gridId).datagrid('getData').rows[index];
	                PHA_UX.BusiTimeLine({},{
	                    busiCode: INRQ_COMPOMENTS.BUSICODE,
	                    locId: session['LOGON.CTLOCID'],
	                    pointer: rowData.inrqId
	                });
	            }else{
	                PHA_UX.BusiTimeLine({},{},"close")
	            }
	        }
		};
		PHA.Grid(gridId, dataGridOption);
	},
	/* ��ʼ����ϸ�б� */
	InitDetailGrid:function(gridId){
		var dataGridOption = {
			url: PHA.$URL,
			queryParams: {},
			singleSelect: true,
			pagination: false,
			columns: INRQ_COMPOMENTS.Columns.Detail.Normal(),
			frozenColumns: INRQ_COMPOMENTS.Columns.Detail.Frozen(),
			gridSave: true,
			isCellEdit: false,
			allowEnd: true,
			isAutoShowPanel: true,
			loadFilter:PHA.localFilter,
			showFooter: true,
			onLoadSuccess: function (data) {
				PHA_COM.SumGridFooter('#' + gridId, ['rpAmt', 'spAmt']);
			},
		};
		PHA.Grid(gridId, dataGridOption);
	},
	/* ������� */
	Clear : function(gridArr, barArr){
		gridArr = gridArr || [];
		barArr = barArr || [];
		var len = gridArr.length;
		for (i=0;i<len;i++){
			var gridId = gridArr[i];
			$('#' + gridId).datagrid('loadData', []);
		}
		var len = barArr.length;
		for (i=0;i<len;i++){
			var barId = barArr[i];
			PHA.DomData(barId, {doType: 'clear'});
		}
	}
}