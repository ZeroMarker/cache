/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.09.07
 *	Description	门诊药房--处方询价
 *	JS			scripts/pha/op/v4/query.price.js
 */
var COMPOMENTS ={};
$(function () {
	PHA_COM.SetPanel('#qcondPanel');
	COMPOMENTS = OP_COMPOMENTS;
	InitGridDrug();	//	处方列表
	InitDict();				// 初始化下拉
	InitEvent();			//	按钮事件
	Clean();				//	包含初始化查询条件
})
function InitEvent(){
	PHA_EVENT.Bind('#btnAdd', 			'click', function () {AddDrugRow();});
	//表格 toolbar
	PHA_EVENT.Bind('#btnDelete', 		'click', function () {DelDrugRow();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	//卡号回车事件
	$('#qty').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var qty = $.trim($("#qty").val());
			if (qty!=""){
				var qty = parseFloat(qty);
				if(isNaN(qty)){
					PHAOP_COM._Msg('error', "请正确输入数量！");
					return;
				}
				if (qty <= 0) {
					PHAOP_COM._Msg('error', "请输入大于0的数字！");
					return false;
				}
			}
			AddDrugRow();
		}
	});
}
function InitDict(){
	// 药品下拉表格
	PHA_UX.ComboBox.INCItm('inci', {
		blurValidValue:true,
		width:391
	});
}
function InitGridDrug(){
	var normalCol = [[
        {title: ("药品Id"),			field: 'inci',			width:150,		align:'left',		hidden:true},
        {title: ("药品代码"),		field: 'inciCode',		width:150,		align:'left'},
        {title: ("药品名称"),		field: 'inciDesc',		width:300,		align:'left'}, 
        {title: $g("数量")+"<a style='color:red'>("+$g("可编辑")+")</a>",			field: 'qty',			width:120,		align:'right',
        	editor: PHA_GridEditor.NumberBox({
            	required: false,
            	checkOnBlur: true,
				checkValue: function (val, checkRet) {
					if (val == "") {return true;}
					var nQty = parseFloat(val);					
					if (isNaN(nQty)) {
						checkRet.msg = "请输入数字！";
						return false;
					}
					if (nQty <= 0) {
						checkRet.msg = "请输入大于0的数字！";
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
        {title: ("单位"),			field: 'pUomDesc',		width:120,		algin:'left'},
        {title: ("规格"),			field: 'spec',			width:150,		align:'left'},
        {title: ("售价"),			field: 'sp',			width:80,		align:'right'},
        {title: ("售价金额"),		field: 'spAmt',			width:90,		align:'right'}, 
        {title: ("生产企业"),		field: 'manfDesc',		width:250,		align:'left'}, 
        {title: ("医保类型"),		field: 'insutype',		width:80,		align:'left',		hidden:true}	]];
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
			PHAOP_COM._Msg('error', "请正确输入数量！");
			return;
		}
		if (qty <= 0) {
			PHAOP_COM._Msg('error', "请输入大于0的数字！");
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
// 查询药品
function AddDrugRow(){
	var inci = $("#inci").combobox("getValue") ||""
	if( inci== ""){
		PHAOP_COM._Alert("请先录入药品");
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
			PHAOP_COM._Alert("找不到相关药品信息");
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
// 删除
function DelDrugRow(){
	var $grid = $('#gridDrug')
	var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHAOP_COM._Msg('error', "请选择药品数据！");
		return false;
    }
    var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
	$grid.datagrid('deleteRow', rowIndex);
	PHA_COM.SumGridFooter('#gridDrug' , ['spAmt']);
}
// 清屏
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridDrug').datagrid('clear');
}
