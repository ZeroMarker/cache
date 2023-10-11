/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.09.07
 *	Description	����ҩ��--����ѯ��
 *	JS			scripts/pha/op/v4/query.price.js
 */
var COMPOMENTS ={};
$(function () {
	PHA_COM.SetPanel('#qcondPanel');
	COMPOMENTS = OP_COMPOMENTS;
	InitGridDrug();	//	�����б�
	InitDict();				// ��ʼ������
	InitEvent();			//	��ť�¼�
	Clean();				//	������ʼ����ѯ����
})
function InitEvent(){
	PHA_EVENT.Bind('#btnAdd', 			'click', function () {AddDrugRow();});
	//��� toolbar
	PHA_EVENT.Bind('#btnDelete', 		'click', function () {DelDrugRow();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	//���Żس��¼�
	$('#qty').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var qty = $.trim($("#qty").val());
			if (qty!=""){
				var qty = parseFloat(qty);
				if(isNaN(qty)){
					PHAOP_COM._Msg('error', "����ȷ����������");
					return;
				}
				if (qty <= 0) {
					PHAOP_COM._Msg('error', "���������0�����֣�");
					return false;
				}
			}
			AddDrugRow();
		}
	});
}
function InitDict(){
	// ҩƷ�������
	PHA_UX.ComboBox.INCItm('inci', {
		blurValidValue:true,
		width:391
	});
}
function InitGridDrug(){
	var normalCol = [[
        {title: ("ҩƷId"),			field: 'inci',			width:150,		align:'left',		hidden:true},
        {title: ("ҩƷ����"),		field: 'inciCode',		width:150,		align:'left'},
        {title: ("ҩƷ����"),		field: 'inciDesc',		width:300,		align:'left'}, 
        {title: $g("����")+"<a style='color:red'>("+$g("�ɱ༭")+")</a>",			field: 'qty',			width:120,		align:'right',
        	editor: PHA_GridEditor.NumberBox({
            	required: false,
            	checkOnBlur: true,
				checkValue: function (val, checkRet) {
					if (val == "") {return true;}
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
					
					var qty = parseFloat(val);
					if((isNaN(qty))||(qty == "")||(qty == undefined)){qty =0}
					var sp  = rowData.sp ;
					var spAmt = _.multiply(sp, qty);
					$("#gridDrug").datagrid('updateRowData', {
						index: rowIndex,
						row: {spAmt:spAmt}
					});
					PHA_COM.SumGridFooter('#gridDrug' , ['spAmt']);
				},onBeforeNext: function (val, rowData, rowIndex) {
					var qty = parseFloat(val);
					if((isNaN(qty))||(qty == "")||(qty == undefined)){qty =0}
					var sp  = rowData.sp ;
					var spAmt = _.multiply(sp, qty);
					$("#gridDrug").datagrid('updateRowData', {
						index: rowIndex,
						row: {spAmt:spAmt}
					});
					PHA_COM.SumGridFooter('#gridDrug' , ['spAmt']);
				}
			})
        },
        {title: ("��λ"),			field: 'pUomDesc',		width:120,		algin:'left'},
        {title: ("���"),			field: 'spec',			width:150,		align:'left'},
        {title: ("�ۼ�"),			field: 'sp',			width:80,		align:'right'},
        {title: ("�ۼ۽��"),		field: 'spAmt',			width:90,		align:'right'}, 
        {title: ("������ҵ"),		field: 'manfDesc',		width:250,		align:'left'}, 
        {title: ("ҽ������"),		field: 'insutype',		width:80,		align:'left',		hidden:true}	]];
	COMPOMENTS.ComomGrid("gridDrug",{
		pagination: false,
		toolbar : '#gridDrugBar',
		columns: normalCol,
		fitColumns:false,
		showFooter: true,

		onLoadSuccess: function (data) {
            PHA_COM.SumGridFooter('#gridDrug' , ['spAmt']);
        },
        onClickCell: function (index, field, value) {
            PHA_GridEditor.Edit({
                gridID: "gridDrug",
                index: index,
                field: field,
				forceEnd: true
            });
        }
	})
}
function GetParams(){
	var qty = $("#qty").val();
	if (qty!=""){
		var qty = parseFloat(qty);
		if(isNaN(qty)){
			PHAOP_COM._Msg('error', "����ȷ����������");
			return;
		}
		if (qty <= 0) {
			PHAOP_COM._Msg('error', "���������0�����֣�");
			return false;
		}
	}
	var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
	if(retJson[0] == undefined) {return false;}
	var pJson = {};
	pJson = retJson[0];
	pJson.locId = PHAOP_COM.LogonData.LocId;
	return pJson;
}
// ��ѯҩƷ
function AddDrugRow(){
	var inci = $("#inci").combobox("getValue") ||""
	if( inci== ""){
		PHAOP_COM._Alert("����¼��ҩƷ");
		return;
	}
	var $grid =  $("#gridDrug");
	var pJson = GetParams();
	if(pJson==false){return;}
    PHA.CM({
		pClassName: 'PHA.OP.Pricing.Api',
		pMethodName: 'GetDrugInfo',
		pPlug:'datagrid',
		pJson: JSON.stringify(pJson)
	},function(gridData){
		if(gridData.rows[0].inci == "") {
			PHAOP_COM._Alert("�Ҳ������ҩƷ��Ϣ");
			return;
		}
		PHA_GridEditor.Add({
			gridID: 'gridDrug',
			field: 'qty',
			rowData: gridData.rows[0],
			checkRow: true
		});
		PHA_COM.SumGridFooter('#gridDrug' , ['spAmt']);
	}); 
}
// ɾ��
function DelDrugRow(){
	var $grid = $('#gridDrug')
	var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHAOP_COM._Msg('error', "��ѡ��ҩƷ���ݣ�");
		return false;
    }
    var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
	$grid.datagrid('deleteRow', rowIndex);
	PHA_COM.SumGridFooter('#gridDrug' , ['spAmt']);
}
// ����
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridDrug').datagrid('clear');
}
