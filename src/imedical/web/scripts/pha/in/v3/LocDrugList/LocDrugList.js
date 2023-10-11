//scripts/pha/in/v3/LocDrugList/LocDrugList.js
/**
 * @模块:     科室用药目录
 * @编写日期: 2020-07-01
 * @编写人:   yangsj
 */

var HosId = session['LOGON.HOSPID'];
var ComBoxWidth = 300 - 15;
var lookUpWidth = 453 - 15;
var searchBoxWidth = 392 - 15;
var ComBoxWidthLoc = 343 - 15;
var DurgToLocLeft=492 - 15
$(function () {
    InitDictBegin(); 	// 初始化不会发生变化的元素
    InitDict(); 		// 初始化会联动的元素
    InitGird(); 		// 列表初始化
    InitEvent(); 		// 绑定事件
    ImportHandler();
    InitTrans();        //panel title翻译
});

function InitTrans(){
	$('#panel2').panel('setTitle',$g('科室-医嘱项<font color=green>(已维护)</font>'));
	$('#panel3').panel('setTitle',$g('科室-医嘱项<font color=red>(未维护)</font>'));
	$('#panel4').panel('setTitle',$g('科室-处方通用名<font color=green>(已维护)</font>'));
	$('#panel5').panel('setTitle',$g('科室-处方通用名<font color=red>(未维护)</font>'));
	$('#panel6').panel('setTitle',$g('医生科室列表<font color=green>(已维护)</font>'));
	$('#panel7').panel('setTitle',$g('医生科室列表<font color=red>(未维护)</font>'));
}

//不受医院下拉框影响的控件在此初始化
function InitDictBegin() {
    PHA.ComboBox('cmbHos', {
        url: PHA_STORE.CTHosNew("PHAIN_LocDrugList").url, //CTHospital
        width: ComBoxWidth,
    });
    setTimeout('SetDefaultHos()', 100);
}

/// 延迟绑定医院
function SetDefaultHos() {
    $('#cmbHos').combobox('setValue', HosId);

    ///这俩控件如果不延迟绑定事件的话，会被其他事件覆盖，只能延迟执行，并且要把原绑定事件都复制过来。不然绑定事件只能取一个
    /// 科室-医嘱项-已维护 列表
    $('#LULocInciArcim').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LULocInciArcim').lookup('options').idField;
            $('#LULocInciArcim').lookup('setValue', rowData[idField]);
            QueryLocInciArcimGrid();
        },
    });
    $('#LULocInciArcim').on('blur', function () {
        var ArcItm = $('#LULocInciArcim').lookup('getValue') || '';
        if (ArcItm != '') return; //失去焦点事件只在删除医嘱项触发。其他刷新事件在上方onSelect时触发
        QueryLocInciArcimGrid();
    });
    /// 科室-医嘱项-未维护 列表
    $('#LULocInciArcimNo').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LULocInciArcimNo').lookup('options').idField;
            $('#LULocInciArcimNo').lookup('setValue', rowData[idField]);
            QueryLocWithOutDrugARCGrid();
        },
    });
    $('#LULocInciArcimNo').on('blur', function () {
        var ArcItm = $('#LULocInciArcimNo').lookup('getValue') || '';
        if (ArcItm != '') return; //失去焦点事件只在删除医嘱项触发。其他刷新事件在上方onSelect时触发
        QueryLocWithOutDrugARCGrid();
    });
    /// 医嘱项主列表
    $('#LUArcimAndLoc').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LUArcimAndLoc').lookup('options').idField;
            $('#LUArcimAndLoc').lookup('setValue', rowData[idField]);
            QueryDrugArcGird();
        },
    });
    $('#LUArcimAndLoc').on('blur', function () {
        var ArcItm = $('#LUArcimAndLoc').lookup('getValue') || '';
        if (ArcItm != '') return; //失去焦点事件只在删除医嘱项触发。其他刷新事件在上方onSelect时触发
        QueryDrugArcGird();
    });
    /// 处方通用名主列表
    $('#LUPHCGMain').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LUPHCGMain').lookup('options').idField;
            $('#LUPHCGMain').lookup('setValue', rowData[idField]);
            QueryDrugPHCGGird();
        },
    });
    $('#LUPHCGMain').on('blur', function () {
        var PHCG = $('#LUPHCGMain').lookup('getValue') || '';
        if (PHCG != '') return; //失去焦点事件只在删除医嘱项触发。其他刷新事件在上方onSelect时触发
        QueryDrugPHCGGird();
    });
    /// 科室-处方通用名-已维护列表
    $('#LULocPhcg').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LULocPhcg').lookup('options').idField;
            $('#LULocPhcg').lookup('setValue', rowData[idField]);
            QueryLocWithPHCGGrid();
        },
    });
    $('#LULocPhcg').on('blur', function () {
        var PHCG = $('#LULocPhcg').lookup('getValue') || '';
        if (PHCG != '') return; //失去焦点事件只在删除医嘱项触发。其他刷新事件在上方onSelect时触发
        QueryLocWithPHCGGrid();
    });
    /// 科室-处方通用名-未维护列表
    $('#LULocPhcgNo').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LULocPhcgNo').lookup('options').idField;
            $('#LULocPhcgNo').lookup('setValue', rowData[idField]);
            QueryLocWithOutPHCGGrid();
        },
    });
    $('#LULocPhcgNo').on('blur', function () {
        var PHCG = $('#LULocPhcgNo').lookup('getValue') || '';
        if (PHCG != '') return; //失去焦点事件只在删除医嘱项触发。其他刷新事件在上方onSelect时触发
        QueryLocWithOutPHCGGrid();
    });
    /// 科室-审核医生-已维护列表
    $('#TextLocDoc').searchbox({
	    searcher:function(value,name){
	    QueryLocWithDocGrid();
	    },
	    width:searchBoxWidth,
	    prompt:'医生模糊检索...'
	});
    /// 科室-审核医生-未维护列表
    $('#TextLocDocNo').searchbox({
	    searcher:function(value,name){
	    QueryLocWithOutDocGrid();
	    },
	    width:searchBoxWidth,
	    prompt:'医生模糊检索...'
	});
    
    /// 审核医生主列表
    $('#TextLocDocMain').searchbox({
	    searcher:function(value,name){
	    QueryDocGird();
	    },
	    width:DurgToLocLeft,
	    prompt:'医生模糊检索...'
	});
}

function InitEvent() {
    // 当医院重新选择后，相关下拉框要重新初始化。重新初始化的方式是修改PHA_COM.Session.HOSPID的值为选中医院下拉框的值
    $('#cmbHos').combobox({
        onChange: function () {
            var hos = $('#cmbHos').combobox('getValue'); //取选中值
            PHA_COM.Session.HOSPID = hos;
            InitDict();
            queryList();
            QueryDrugArcGird();
        },
    });
    $('#cmbDocLoc').combobox({
        onChange: function () {
            queryList();
        },
    });

    $('#cmbDrugDocLoc').combobox({
        onChange: function () {
            QueryDrugWithLocGird();
        },
    });

    $('#cmbDrugDocLocNo').combobox({
        onChange: function () {
            QueryDrugWithOutLocGird();
        },
    });
    
    
    $('#tabPrt').tabs('options').onSelect = function (title, index) {
	    
    }
    
    
    //按科室维护药品/按药品维护科室 之间的切换
    $('#tabPrt').tabs('options').onSelect = function (title, index) {
        ClearGridI();
        ClearConditionI();
        var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
	    if (tabTitle == $g('按科室维护药品')) {
		    QueryLocGird();
	    }
	    if (tabTitle == $g('按药品维护科室')) {
		    QueryDrugWithOutLocGird();
	    	QueryDrugWithLocGird();
	    }
   		}
    
    //按科室维护药品 的右侧 医嘱项/处方通用名/药品属性 之间的切换
    $('#tabARCOrPHCG').tabs('options').onSelect = function (title, index) {
        ClearGridI();
        ClearConditionI();
        var tabTitle = $('#tabARCOrPHCG').tabs('getSelected').panel('options').title;
        var tabId = $('#tabARCOrPHCG').tabs('getSelected').panel('options').id;
	    if (tabId == 'tabARCLable') {
	        QueryLocWithOutDrugARCGrid();
	        QueryLocInciArcimGrid();
	    } else if (tabId =='tabPHCGeLable') {
	        QueryLocWithOutPHCGGrid();
	        QueryLocWithPHCGGrid();
	    } else if (tabId == 'tabDOCLable') {
		    QueryLocWithOutDocGrid();
		    QueryLocWithDocGrid();
	    }
     }
    $('#tabDrugArcOrPhcg').tabs('options').onSelect = function (title, index) { 
        ClearGridI();
        ClearConditionI();
        
        QueryLocWithOutDrugARCGrid();
	    QueryLocWithOutPHCGGrid();
	    QueryDrugWithOutLocGird();
	    QueryDrugWithLocGird();
	    QueryLocWithOutDocGrid();
    }
    
    
    $("#btnDownLoad").on("click", DownLoadModel);
}
//下载导入模板
function DownLoadModel(){
	
	var title={
		locDesc:"科室名称",
		ArcCode:"医嘱项代码",
		ArcDesc:"医嘱项名称",
		phcgeCode:"处方通用名代码",
		phcgeDesc:"处方通用名名称",
	}
	var data=[{locDesc:'保健科', ArcCode:"XWY000153",ArcDesc:"双唑泰泡腾片[CO*10]"}, {locDesc:'保健科', phcgeCode:"TY1918",phcgeDesc:"鬼箭羽"}]
	var fileName="科室药品目录导入模版.xlsx"
	PHA_COM.ExportFile(title, data, fileName);
	
	//window.open("../scripts/pha/in/v3/LocDrugList/科室药品目录导入模版.xlsx", "_blank");	
}

////  ----------------------------清除事件集中-----Start--------///
/// 清理所有子列表
function ClearGridI()
{
	$('#LocInciArcimGrid').datagrid('clear');
    $('#LocInciArcimGrid').datagrid('clearSelections');
    $('#LocWithOutDrugARCGrid').datagrid('clear');
    $('#LocWithOutDrugARCGrid').datagrid('clearSelections');
    $('#LocWithPHCGGrid').datagrid('clear');
    $('#LocWithPHCGGrid').datagrid('clearSelections');
    $('#LocWithOutPHCGGrid').datagrid('clear');
    $('#LocWithOutPHCGGrid').datagrid('clearSelections');
    $('#LocWithDocGrid').datagrid('clear');
    $('#LocWithDocGrid').datagrid('clearSelections');
    $('#LocWithOutDocGrid').datagrid('clear');
    $('#LocWithOutDocGrid').datagrid('clearSelections');
    $('#DrugWithLocGird').datagrid('clear');
    $('#DrugWithLocGird').datagrid('clearSelections');
    $('#DrugWithOutLocGird').datagrid('clear');
    $('#DrugWithOutLocGird').datagrid('clearSelections');
}
/// 清除所有子列表的条件
function ClearConditionI()
{
	$('#conFileBox').filebox('clear');
	$('#LULocInciArcim').lookup('setValue',"");
	$('#LULocInciArcim').lookup('setText',"");
	$('#LULocInciArcimNo').lookup('setValue',"");
	$('#LULocInciArcimNo').lookup('setText',"");
	$('#LULocPhcg').lookup('setValue',"");
	$('#LULocPhcg').lookup('setText',"");
	$('#LULocPhcgNo').lookup('setValue',"");
	$('#LULocPhcgNo').lookup('setText',"");
	
	$('#cmbDrugDocLoc').combobox('setValue',"");
	$('#cmbDrugDocLocNo').combobox('setValue',"");
	
	$('#TextLocDoc').val("");
	$('#TextLocDocNo').val("");
}
/// 清理所有主表条件和医院
function ClearMian()
{
	$('#cmbHos').combobox('setValue', HosId);
	$('#LUArcimAndLoc').lookup('setValue',"");
	$('#LUArcimAndLoc').lookup('setText',"");
	$('#LUPHCGMain').lookup('setValue',"");
	$('#LUPHCGMain').lookup('setText',"");
	$('#cmbDocLoc').combobox('setValue',"");
	$('#TextLocDocMain').val("");
}

/// 清屏按钮
function clean()
{
	ClearGridI();
    ClearConditionI();
    ClearMian();
}
////  ----------------------------清除事件集中-----End--------///

function ImportHandler() {
	$("#conFileBox").filebox({
		prompt: $g('请选择文件...'),
		buttonText: $g('选择'),
		width: 250,
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	})
	$("#btnFileBox").on("click", function(){
		var filelist = $('#conFileBox').filebox("files");
		if (filelist.length == 0) {
			//alert("请先选择文件")
			PHA.Alert($g('提示'), $g("请先选择文件！"), 'warning');
			return
		}
		var file = filelist[0];
		var importData="";
		PHA_COM.ReadExcel(file,function(xlsData){
			var dataLen = xlsData.length ;
			//alert(JSON.stringify(xlsData))
			//var JSONData = JSON.stringify(xlsData) ;
			for (var num=0;num<dataLen;num++){
				var sData = xlsData[num] ;  //科室名称	医嘱项代码	医嘱项名称	处方通用名代码	处方通用名名称

				var Locdesc = sData['科室名称'] ;  
				var arcCode = sData['医嘱项代码'] ;  
				var phcGeneCode = sData['处方通用名代码'] ;  
				var data= [Locdesc,arcCode,phcGeneCode].join("^")
					importData=(importData=="")?data:importData+"##"+data ;
			}
			if ((importData=="")||(importData==null)||(importData==undefined)){
				PHA.Alert($g('提示'), $g("没有获取到需要导入药品明细信息，请注意Excel模板格式是否正确！"), 'warning');
				return ;
			}
			var importRet = tkMakeServerCall("PHA.IN.LocDrugList.Save","importData",importData)
			var RetArr = importRet.split("^");
			var RetSucc = RetArr[0];
			var RetVal = RetArr[1];
			if (RetSucc < 0) {
				PHA.Alert($g('提示'), $g("保存失败，错误信息：")+RetVal, 'warning');
			} else {				
				var msgInfo = $g("保存成功!");
				PHA.Alert($g('提示'), msgInfo, 'success');
				queryList()
				
			}
		})
		
	});
}

// 延迟调用getText方法，因为在下拉框选中事件触发时，下拉框还未给Desc赋值，此时不能用getText取值。
function EventUnite() {
    setTimeout('showTmpCombPanel()', 100);
}

/// ---------------------------所有列表查询主方法集中-------Start-------------------/////
///查询四个主列表
function queryList() {
    QueryLocGird();
    QueryDrugArcGird();
    QueryDrugPHCGGird();
    QueryDocGird();
    QueryLocWithOutDrugARCGrid();
    QueryLocWithOutPHCGGrid();
    QueryDrugWithOutLocGird();
    QueryLocWithOutDocGrid();
    
}

function QueryLocInciArcimGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    if (LDLRowId == '') return;
    var WithArc = $('#LULocInciArcim').lookup('getValue') || '';
    $('#LocInciArcimGrid').datagrid('query', {
        inputStr: LDLRowId + '^' + WithArc + '^^ARC', //+"^"+WithArc
    });
}

function QueryLocWithOutDrugARCGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    //if (LDLRowId == '') return;
    var WithOutArc = $('#LULocInciArcimNo').lookup('getValue') || '';
    $('#LocWithOutDrugARCGrid').datagrid('query', {
        inputStr: LDLRowId + '^' + WithOutArc + '^' + $('#cmbHos').combobox('getValue'),
    });
}

function QueryLocWithPHCGGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    if (LDLRowId == '') return;
    var WithPhcg = $('#LULocPhcg').lookup('getValue') || '';
    $('#LocWithPHCGGrid').datagrid('query', {
        inputStr: LDLRowId + '^^' + WithPhcg + '^PHCG',
    });
}

function QueryLocWithOutPHCGGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    //if (LDLRowId == '') return;
    var WithOutPhcg = $('#LULocPhcgNo').lookup('getValue') || '';
    $('#LocWithOutPHCGGrid').datagrid('query', {
        inputStr: LDLRowId + '^' + WithOutPhcg + '^' + $('#cmbHos').combobox('getValue'),
    });
}

function QueryDrugPHCGGird() {
    var HosID = $('#cmbHos').combobox('getValue') || '';
    var Phcg = $('#LUPHCGMain').lookup('getValue') || '';
    var inputStr = '' + '^' + Phcg + '^' + HosID;
    $('#DrugPHCGGird').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryDrugArcGird() {
    var HosID = $('#cmbHos').combobox('getValue') || '';
    var Arc = $('#LUArcimAndLoc').lookup('getValue') || '';
    var inputStr = '' + '^' + Arc + '^' + HosID;
    $('#DrugArcGird').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryDrugWithLocGird() {
    //var tabTitle = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').title;
    var tabId = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').id;  
    var arcimId = '',
        phcgId = '',
        pcpId = '';
    if (tabId == 'tabARCLable') {
        var gridSelect = $('#DrugArcGird').datagrid('getSelected') || '';
        if (gridSelect) arcimId = gridSelect.arcimId;
    } else if (tabId == 'tabPHCGeLable') {
        var gridSelect = $('#DrugPHCGGird').datagrid('getSelected') || '';
        if (gridSelect) phcgId = gridSelect.phcg;
    } else if (tabId == 'tabDOCeLable') {
        var gridSelect = $('#DocGird').datagrid('getSelected') || '';
        if (gridSelect) pcpId = gridSelect.pcpId;
    }
    if (arcimId == '' && phcgId == '' && pcpId == '') return;

    var DrugDocLoc = $('#cmbDrugDocLoc').combobox('getValue') || '';
    var HosID = $('#cmbHos').combobox('getValue') || '';
    var inputStr =
        HosID + '^' + arcimId + '^' + phcgId + '^' + DrugDocLoc + '^' + 'Y' + '^' + pcpId;
    $('#DrugWithLocGird').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryDrugWithOutLocGird() {
    //var tabTitle = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').title;
    var tabId = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').id;  
    var arcimId = '',
        phcgId = '',
        pcpId = '';
    if (tabId == 'tabARCLable') {
        var gridSelect = $('#DrugArcGird').datagrid('getSelected') || '';
        if (gridSelect) arcimId = gridSelect.arcimId;
    } else if (tabId == 'tabPHCGeLable') {
        var gridSelect = $('#DrugPHCGGird').datagrid('getSelected') || '';
        if (gridSelect) phcgId = gridSelect.phcg;
    } else if (tabId == 'tabDOCeLable') {
        var gridSelect = $('#DocGird').datagrid('getSelected') || '';
        if (gridSelect) pcpId = gridSelect.pcpId;
    }
    if (arcimId == '' && phcgId == '' && pcpId == '') return;

    var DrugDocLoc = $('#cmbDrugDocLocNo').combobox('getValue') || '';
    var HosID = $('#cmbHos').combobox('getValue') || '';
    var inputStr =
        HosID + '^' + arcimId + '^' + phcgId + '^' + DrugDocLoc + '^' + 'N' + '^' + pcpId;

    $('#DrugWithOutLocGird').datagrid('query', {
        inputStr: inputStr,
    });
}
function QueryLocGird() {
    $('#LocGird').datagrid('clear');
    $('#LocGird').datagrid('clearSelections');
    $('#LocGird').datagrid('query', {
        inputStr: $('#cmbHos').combobox('getValue') + '^' + $('#cmbDocLoc').combobox('getValue'),
    });
}

function QueryLocWithDocGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    if (LDLRowId == '') return;
    var HospId = $('#cmbHos').combobox('getValue');
    var LocDocQText =$('#TextLocDoc').searchbox("getValue")
    var WithFlag = 'Y';
    var inputStr = HospId + '^' + LDLRowId + '^' + LocDocQText + '^' + WithFlag;
    $('#LocWithDocGrid').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryLocWithOutDocGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    //if (LDLRowId == '') return;
    var HospId = $('#cmbHos').combobox('getValue');
    var LocDocNoQText =$('#TextLocDocNo').searchbox("getValue") 
    var WithFlag = 'N';
    var inputStr = HospId + '^' + LDLRowId + '^' + LocDocNoQText + '^' + WithFlag;
    $('#LocWithOutDocGrid').datagrid('query', {
        inputStr: inputStr,
    });
}
function QueryDocGird() {
    var LDLRowId = '';
    var HospId = $('#cmbHos').combobox('getValue');
    var LocDocMainQText =  $('#TextLocDocMain').searchbox("getValue") 
    var WithFlag = '';
    var inputStr = HospId + '^' + LDLRowId + '^' + LocDocMainQText + '^' + WithFlag;
    $('#DocGird').datagrid('query', {
        inputStr: inputStr,
    });
}

/// ---------------------------所有列表查询主方法集中-------End-------------------/////

///初始化各个列表
function InitGird() {
    InitLocGird();
    InitLocInciArcimGrid();
    InitLocWithOutDrugARCGrid();
    InitDrugArcGird();
    InitDrugWithLocGird();
    InitDrugWithOutLocGird();
    InitLocWithPHCGGrid();
    InitLocWithOutPHCGGrid();
    InitDrugPHCGGird();
    //InitLocWithDocGrid();
    //InitLocWithOutDocGrid();
    //InitDocGird();
}

////---------------------------------初始化科室列表----Start------------------////
//初始化科室列表
function InitLocGird() {
    var columns = [
        [
            // combRowid,combItmRowid,activeFlag,CtrlLevel,CombItmType,CombItmTypeVal,limitQty,combItmSign
            { field: 'LDLRowId', 	title: 'LDLRowId',	 	align: 'center', 	width: 80, 		hidden: true },
            { field: 'locCode',	 	title: $g('科室代码'), 		align: 'left', 	width: 100, 	hidden: true },
            { field: 'locDesc', 	title: $g('科室描述'), 		align: 'left', 		width: 150 },
            
            
        ],
    ];
    var frozenColumns = [
        [
            {
                field: 'deleteBut',
                title: $g('删除'),
                align: 'center',
                width: 59,
                formatter: deleteLocFormatter,
                frozencols:true	
            },{
                field: 'activeFlag',
                title: $g('可用状态'),
                align: 'center',
                width: 90,
                formatter: statusFormatter,
            }
        ]
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#LocBar',
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDLRowId',
        columns: columns,
        frozenColumns: frozenColumns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLLocList',
            inputStr: HosId,
        },
        onLoadSuccess: function (data) {
            var pageSize = $('#LocGird').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 && total <= pageSize) {
                $('#LocGird').datagrid('selectRow', 0);
            }
            $('.hisui-switchbox').switchbox();
        },
        onSelect: function (rowIndex, rowData) {
            QueryLocInciArcimGrid();
            QueryLocWithOutDrugARCGrid();
            QueryLocWithPHCGGrid();
            QueryLocWithOutPHCGGrid();
            //QueryLocWithDocGrid();
            //QueryLocWithOutDocGrid();
        },
    };
    PHA.Grid('LocGird', dataGridOption);
}

//自定义状态列格式-科室
function statusFormatter(value, rowData, rowIndex) {
    var LDLRowId = rowData.LDLRowId;
    var value = rowData.activeFlag;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchbox\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'是',offText:'否',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(e, obj){UpdateLocStatus(obj.value,' +
            LDLRowId +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchbox\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'是',offText:'否',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(e, obj){UpdateLocStatus(obj.value,' +
            LDLRowId +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function UpdateLocStatus(objVal,LDLRowId, Index, value) {
    if (objVal) value = 'Y';
    else value = 'N';
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'UpdateLocActive',
            LDLRowId: LDLRowId,
            ActiveFlag: value,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('修改可用状态成功'), type: 'success' });
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('修改可用状态失败！ 错误描述') + retData.desc,
                    type: 'alert',
                });
        }
    );
    
}

//自定义状态列格式-医嘱项
function statusFormatteri(value, rowData, rowIndex) {
    var LDLRowId = rowData.LDLRowId;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxi\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'是',offText:'否',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(v, e){Update(' +
            LDLRowId +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchboxi\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'是',offText:'否',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(v, e){Update(' +
            LDLRowId +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function deleteLocFormatter(value, rowData, rowIndex) {
    var LDLRowId = rowData.LDLRowId;
    return (
        '<span class="icon icon-cancel"  onclick="DeleteLDLRow(\'' +
        LDLRowId +
        '\')">&ensp;</span>'
    );
}

function AddFormatter(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="DeleteDULRow(\'' +
        DUlRowID +
        '\')">&ensp;</span>'
    );
}

function DeleteLDLRow(LDLRowId) {
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'DeleteLoc',
            LDLRowId: LDLRowId,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('删除科室成功'), type: 'success' });
                queryList();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('删除科室失败！ 错误描述') + retData.desc,
                    type: 'alert',
                });
        }
    );
}
////---------------------------------初始化科室列表----End------------------////

///-------------------------初始化科室-医嘱项-已维护---------Start------------------////
//初始化科室-医嘱项-已维护
function InitLocInciArcimGrid() {
    var columns = [
        [
            // LDLIRowid,arcCode,arcDesc
            { field: 'LDLIRowid', title: 'LDLIRowid', align: 'center', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('删除'),
                align: 'center',
                width: 60,
                formatter: deleteLocDrugFormatter,
            },
            { field: 'arcCode', title: $g('医嘱项代码'), align: 'left', width: 100 },
            { field: 'arcDesc', title: $g('医嘱项描述'), align: 'left', width: 315 },
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#LocAndArcBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDLIRowid',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItm',
            inputStr: '',
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('LocInciArcimGrid', dataGridOption);
}

function deleteLocDrugFormatter(value, rowData, rowIndex) {
    var LDLIRowid = rowData.LDLIRowid;
    return (
        '<span class="icon icon-cancel"  onclick="DeleteLDLIRow(\'' +
        LDLIRowid +
        '\')">&ensp;</span>'
    );
}
function DeleteLDLIRow(LDLIRowId) {
    //var tabTitle = $('#tabARCOrPHCG').tabs('getSelected').panel('options').title;
    var tabId = $('#tabARCOrPHCG').tabs('getSelected').panel('options').id;
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'DeleteLocDrug',
            LDLIRowId: LDLIRowId,
        },
        function (retData) {
            if (!retData) {
                if (tabId == 'tabPHCGeLable') {
                    PHA.Popover({ showType: 'show', msg: $g('删除处方通用名成功'), type: 'success' });
                    QueryLocWithPHCGGrid();
                    QueryLocWithOutPHCGGrid();
                } else if (tabId == 'tabARCLable') {
                    PHA.Popover({ showType: 'show', msg: $g('删除医嘱项成功'), type: 'success' });
                    QueryLocInciArcimGrid();
                    QueryLocWithOutDrugARCGrid();
                }
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('删除医嘱项失败！ 错误描述') + retData.desc,
                    type: 'alert',
                });
        }
    );
}

///-----------------------------初始化科室-医嘱项-已维护---------End------------------////
///-----------------------------初始化科室-药品-未维护----Start---------------------////

//初始化科室-药品-未维护
function InitLocWithOutDrugARCGrid() {
    var columns = [
        [
            // arcimId,arcimCode,arcimDesc
            { field: 'arcimId', title: 'arcimId', align: 'center', width: 80, hidden: true },
            {
                field: 'AddBut',
                title: $g('添加'),
                align: 'center',
                width: 60,
                formatter: AddArcFormatter,
            },
            { field: 'arcimCode', title: $g('医嘱项代码'), align: 'left', width: 100 },
            { field: 'arcimDesc', title: $g('医嘱项描述'), align: 'left', width: 335 },
            
        ],
    ];
    var dataGridOption = {
        //fitColumns: true,
        fit: true,
        toolbar: '#LocWithOutArcBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'arcimId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItmWithOut',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            //$('.hisui-switchboxi').switchbox();
        },
    };
    PHA.Grid('LocWithOutDrugARCGrid', dataGridOption);
}

function AddArcFormatter(value, rowData, rowIndex) {
    var arcimId = rowData.arcimId;
    var phcgId = rowData.phcg;
    if (!arcimId) arcimId = '';
    if (!phcgId) phcgId = '';
    //alert("<a href='#' onclick='AddLDLI(\""+arcimId+"\",\""+phcgId+"\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/></a>")
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddLDLI(\'' +
        arcimId +
        '\',\'' +
        phcgId +
        '\')">&ensp;</span>'
    );
}

function AddLDLI(arcimId, phcgId) {
    //alert(arcimId+"^"+phcgId)
    var gridSelect = $('#LocGird').datagrid('getSelected');
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;

    var DocLoc = $('#cmbDocLoc').combobox('getValue');
    if (LDLRowId == '' && DocLoc == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个科室'), type: 'alert' });
        return;
    }
    var detailTitle=$g("医嘱项")
    if (phcgId!="") detailTitle=$g("处方通用名")
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'AddLocDrug',
            Hosp:$('#cmbHos').combobox('getValue'),
            LDLRowId: LDLRowId,
            Arc: arcimId,
            Phcg: phcgId,
            DocLoc: DocLoc,
        },
        
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg:$g( '添加')+detailTitle+$g('成功'), type: 'success' });
                if (arcimId) {
                    QueryLocInciArcimGrid();
                    QueryLocWithOutDrugARCGrid();
                }
                if (phcgId) {
                    QueryLocWithPHCGGrid();
                    QueryLocWithOutPHCGGrid();
                }
                if (LDLRowId == '') {
                    $('#LocGird').datagrid('clear');
                    $('#LocGird').datagrid('clearSelections');
                    $('#LocGird').datagrid('query', {
                        inputStr:
                            $('#cmbHos').combobox('getValue') +
                            '^' +
                            $('#cmbDocLoc').combobox('getValue'),
                    });
                }
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('添加')+detailTitle+$g('失败！ 错误描述:') + retData.desc,
                    type: 'alert',
                });
        }
    );
}

///-----------------------------初始化科室-药品-未维护----End---------------------////
///------------------------------初始化医嘱列表----Start----------------------------------///

//初始化医嘱列表
function InitDrugArcGird() {
    var columns = [
        [
            // arcimId,arcimCode,arcimDesc
            { field: 'arcimId', title: 'arcimId', align: 'center', width: 80, hidden: true },
            { field: 'arcimCode', title: $g('医嘱项代码'), align: 'left', width: 100 },
            { field: 'arcimDesc', title: $g('医嘱项描述'), align: 'left', width: 369 },
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#ArcBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'arcimId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItmWithOut',
            inputStr: '^^' + HosId,
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxi').switchbox();
            var pageSize = $('#DrugArcGird').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 ) {   //&& total <= pageSize
                $('#DrugArcGird').datagrid('selectRow', 0);
            }
           
            
        },
        onSelect: function (rowIndex, rowData) {
            QueryDrugWithLocGird();
            QueryDrugWithOutLocGird();
        },
    };
    PHA.Grid('DrugArcGird', dataGridOption);
}

///------------------------------初始化医嘱列表----End----------------------------------///
///------------------------------初始处方通用名列表----Start----------------------------------///

//初始处方通用名列表
function InitDrugPHCGGird() {
    var columns = [
        [
            // phcg,phcgCode,phcgDesc
            { field: 'phcg', title: 'phcg', align: 'center', width: 80, hidden: true },
            { field: 'phcgCode', title: $g('处方通用名代码'), align: 'left', width: 150 },
            { field: 'phcgDesc', title: $g('处方通用名描述'), align: 'left', width: 319 },
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#PHCGMainBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'phcg',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItmWithOutPHCG',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxi').switchbox();
             var pageSize = $('#DrugPHCGGird').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 ) {   //&& total <= pageSize
                $('#DrugPHCGGird').datagrid('selectRow', 0);
            }
        },
        onSelect: function (rowIndex, rowData) {
            QueryDrugWithLocGird();
            QueryDrugWithOutLocGird();
        },
    };
    PHA.Grid('DrugPHCGGird', dataGridOption);
}
///------------------------------初始处方通用名列表----End----------------------------------///

//// --------------------------------初始化药品-科室-已维护-----Start-----------------------------////
//初始化药品-科室-已维护
function InitDrugWithLocGird() {
    var columns = [
        [
            // LDLIRowId,loc,loccode,locdesc
            { field: 'LDLIRowId', title: 'LDLIRowId', align: 'center', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('删除'),
                align: 'center',
                width: 50,
                formatter: deleteDrugLocFormatter,
            },
            { field: 'loc', title: '科室id', align: 'center', width: 100, hidden: true },
            { field: 'loccode', title: $g('科室代码'), align: 'left', width: 100 },
            { field: 'locdesc', title: $g('科室描述'), align: 'left', width: 140 },
            {
                field: 'Status',
                title: $g('目录状态'),
                align: 'center',
                width: 80,
                formatter: DrugLocStatusFormatter,
            },
            
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#ArcAndLocBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDLIRowId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLocByDrug',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            //$('.hisui-switchboxi').switchbox();
        },
    };
    PHA.Grid('DrugWithLocGird', dataGridOption);
}

function DrugLocStatusFormatter(value, rowData, rowIndex) {
    var Status = rowData.Status;
    if (Status == 'Y')
        return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png' border=0/>";
    else return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' border=0/>";
}

function deleteDrugLocFormatter(value, rowData, rowIndex) {
    var LDLIRowId = rowData.LDLIRowId;
    return (
        '<span class="icon icon-cancel"  onclick="DeleteArcLDLIRow(\'' +
        LDLIRowId +
        '\')">&ensp;</span>'
    );
}
function DeleteArcLDLIRow(LDLIRowId) {
    var tabTitle = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').title;
    if (tabTitle.indexOf($g('审核医生维护'))<0) {
        $.cm(
            {
                ClassName: 'PHA.IN.LocDrugList.Save',
                MethodName: 'DeleteLocDrug',
                LDLIRowId: LDLIRowId,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: $g('删除医生科室成功'), type: 'success' });
                    QueryDrugWithLocGird();
                    QueryDrugWithOutLocGird();
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('删除医生科室失败！ 错误描述') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    } else {
        $.cm(
            {
                ClassName: 'PHA.IN.LocDrugList.Save',
                MethodName: 'DeleteLocDoc',
                LDDIRowId: LDLIRowId,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: $g('删除医生科室成功'), type: 'success' });
                    QueryDrugWithLocGird();
                    QueryDrugWithOutLocGird();
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('删除医生科室失败！ 错误描述') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    }
}

//// --------------------------------初始化药品-科室-已维护-----END-----------------------------////

//// --------------------------------初始化药品-科室-未维护-----Start-----------------------------////

//初始化药品-科室-未维护
function InitDrugWithOutLocGird() {
    var columns = [
        [
            // ,loc,locdesc
            //{field:'combItmRowid',	title:'DULCRowIdi',	align:'center', width: 80,hidden:true},
            { field: 'loc', title: 'loc', align: 'center', width: 100, hidden: true },
            {
                field: 'deleteBut',
                title: $g('添加'),
                align: 'center',
                width: 50,
                formatter: AddLocBYDrugFormatter,
            },
            { field: 'loccode', title: $g('科室代码'), align: 'left', width: 100 },
            { field: 'locdesc', title: $g('科室描述'), align: 'left', width: 220 },
            
        ],
    ];
    var dataGridOption = {
        //fitColumns: true,
        fit: true,
        toolbar: '#ArcWithOutLocBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'loc',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLocByDrug',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            //$('.hisui-switchboxi').switchbox();
        },
    };
    PHA.Grid('DrugWithOutLocGird', dataGridOption);
}

function AddLocBYDrugFormatter(value, rowData, rowIndex) {
    var loc = rowData.loc;
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddLocBYDrug(\'' +
        loc +
        '\')">&ensp;</span>'
    );

}

function AddLocBYDrug(loc) {
    //var tabTitle = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').title;
    var tabId = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').id;
    var arcimId = '',
        phcgId = '',
        pcpId = '';
    if (tabId == 'tabARCLable') {
        var gridSelect = $('#DrugArcGird').datagrid('getSelected') || '';
        if (gridSelect) arcimId = gridSelect.arcimId;
    } else if (tabId == 'tabPHCGeLable') {
        var gridSelect = $('#DrugPHCGGird').datagrid('getSelected') || '';
        if (gridSelect) phcgId = gridSelect.phcg;
    } else if (tabId == 'tabDOCLable') {
        var gridSelect = $('#DocGird').datagrid('getSelected') || '';
        if (gridSelect) pcpId = gridSelect.pcpId;
    }

    if (arcimId == '' && phcgId == '' && pcpId == '') {
        PHA.Popover({
            showType: 'show',
            msg: $g('请选择一个医嘱项/处方通用名/审核医生！'),
            type: 'alert',
        });
        return;
    }
    if (tabId != 'tabDOCLable') {
        $.cm(
            {
                ClassName: 'PHA.IN.LocDrugList.Save',
                MethodName: 'AddLocDrug',
                Hosp:$('#cmbHos').combobox('getValue'),
                LDLRowId: '',
                Arc: arcimId,
                Phcg: phcgId,
                DocLoc: loc,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('添加医生科室成功'),
                        type: 'success',
                    });
                    QueryDrugWithLocGird();
                    QueryDrugWithOutLocGird();
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('添加医生科室失败！ 错误描述:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    } else {
        $.cm(
            {
                ClassName: 'PHA.IN.LocDrugList.Save',
                MethodName: 'AddLocDoc',
                LDLRowId: '',
                CTCP: pcpId,
                DocLoc: loc,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: $g('添加医生科室成功'), type: 'success' });
                    QueryDrugWithLocGird();
                    QueryDrugWithOutLocGird();
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('添加医生科室失败！ 错误描述:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    }
}

//// --------------------------------初始化药品-科室-未维护-----END-----------------------------////

function deleteFormatteri(value, rowData, rowIndex) {
    var combRowid = rowData.combRowid;
    var CombName = rowData.CombName;
    if (CombName){  
        return (
			'<span class="icon icon-cancel"  onclick="DeleteCombi(\'' +
			combRowid +
            '\',\'' +
            CombName +
			'\')">&ensp;</span>'
		);
    }
    else return value;
}

//初始化科室-处方通用名-已维护
function InitLocWithPHCGGrid() {
    var columns = [
        [
            // LDLIRowid,arcCode,arcDesc
            { field: 'LDLIRowid', title: 'LDLIRowid', align: 'center', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('删除'),
                align: 'center',
                width: 60,
                formatter: deleteLocDrugFormatter,
            },
            { field: 'phcgCode', title: $g('处方通用名代码'), align: 'left', width: 150 },
            { field: 'phcgDesc', title: $g('处方通用名描述'), align: 'left', width: 265 },
            
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#LocInciPhcgBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDLIRowid',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItm',
            inputStr: '',
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('LocWithPHCGGrid', dataGridOption);
}

//初始化科室-处方通用名-未维护
function InitLocWithOutPHCGGrid() {
    var columns = [
        [
            // LDLIRowid,arcCode,arcDesc
            { field: 'phcg', title: 'phcg', align: 'center', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: '添加',
                align: 'center',
                width: 60,
                formatter: addLocPhcgFormatter,
            },
            { field: 'phcgCode', title: $g('处方通用名代码'), align: 'left', width: 150 },
            { field: 'phcgDesc', title: $g('处方通用名描述'), align: 'left', width: 285 },
            
        ],
    ];
    var dataGridOption = {
        //fitColumns: true,
        fit: true,
        toolbar: '#LocInciPhcgNoBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'phcg',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItmWithOutPHCG',
            inputStr: '',
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('LocWithOutPHCGGrid', dataGridOption);
}

function addLocPhcgFormatter(value, rowData, rowIndex) {
    var arcimId = rowData.arcimId;
    var phcgId = rowData.phcg;
    if (!arcimId) arcimId = '';
    if (!phcgId) phcgId = '';
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddLDLI(\'' +
        arcimId +
        '\',\'' +
        phcgId +
        '\')">&ensp;</span>'
    );
}

///-------------------------科室-审核医生(已维护)-------Start------------------------------------///
function InitLocWithDocGrid() {
    var columns = [
        [
            // LDDIRowId,pcpId,userCode,userName
            { field: 'LDDIRowId', title: 'LDDIRowId', align: 'center', width: 80, hidden: true },
            {
                field: 'DeleteBut',
                title: $g('删除'),
                align: 'center',
                width: 80,
                formatter: DeleteLocDocFormatter,
            },
            { field: 'userCode', title: $g('医生工号'), align: 'left', width: 140 },
            { field: 'userName', title: $g('医生名称'), align: 'left', width: 150 },
            
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#TextLocDocBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDDIRowId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryDocInLoc',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
	     
	        },
    };
    PHA.Grid('LocWithDocGrid', dataGridOption);
}

function DeleteLocDocFormatter(value, rowData, rowIndex) {
    var LDDIRowId = rowData.LDDIRowId;
    if (LDDIRowId){
        return (
			'<span class="icon icon-cancel"  onclick="DeleteLocDoc(\'' +
			LDDIRowId +
			'\')">&ensp;</span>'
		);
    }
    else return value;
}
function DeleteLocDoc(LDDIRowId) {
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'DeleteLocDoc',
            LDDIRowId: LDDIRowId,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('删除审核医生成功'), type: 'success' });
                QueryLocWithDocGrid();
                QueryLocWithOutDocGrid();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('删除审核医生失败！ 错误描述') + retData.desc,
                    type: 'alert',
                });
        }
    );
}

///-------------------------科室-审核医生(已维护)-------End------------------------------------///

///-------------------------科室-审核医生(未维护)-------Start------------------------------------///
function InitLocWithOutDocGrid() {
    var columns = [
        [
            // LDDLRowId,pcpId,userCode,userName
            { field: 'pcpId', title: 'lddiId', align: 'center', width: 80, hidden: true },
            {
                field: 'AddBut',
                title: $g('添加'),
                align: 'center',
                width: 80,
                formatter: addLocDocFormatter,
            },
            { field: 'userCode', title: $g('医生工号'), align: 'left', width: 150 },
            { field: 'userName', title: $g('医生名称'), align: 'left', width: 150 },
            
        ],
    ];
    var dataGridOption = {
        //fitColumns: true,
        fit: true,
        toolbar: '#TextLocDocNoBar',
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'pcpId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryDocInLoc',
            inputStr: '',
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('LocWithOutDocGrid', dataGridOption);
}

function addLocDocFormatter(value, rowData, rowIndex) {
    var pcpId = rowData.pcpId;
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddLocDoc(\'' +
        pcpId +
        '\')">&ensp;</span>'
    );
}

function AddLocDoc(pcpId) {
    var gridSelect = $('#LocGird').datagrid('getSelected');
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;

    var DocLoc = $('#cmbDocLoc').combobox('getValue');
    if (LDLRowId == '' && DocLoc == '') {
        PHA.Popover({ showType: 'show', msg: $g('请选择一个科室'), type: 'alert' });
        return;
    }

    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'AddLocDoc',
            LDLRowId: LDLRowId,
            CTCP: pcpId,
            DocLoc: DocLoc,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('添加审核医生成功'), type: 'success' });
                if (LDLRowId == '') {
                    $('#LocGird').datagrid('clear');
                    $('#LocGird').datagrid('clearSelections');
                    $('#LocGird').datagrid('query', {
                        inputStr:
                            $('#cmbHos').combobox('getValue') +
                            '^' +
                            $('#cmbDocLoc').combobox('getValue'),
                    });
                }
                QueryLocWithDocGrid();
                QueryLocWithOutDocGrid();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('添加审核医生失败！ 错误描述:') + retData.desc,
                    type: 'alert',
                });
        }
    );
}

///-------------------------科室-审核医生(未维护)-------End------------------------------------///

///-------------------------审核医生主列表-------Start------------------------------------///
function InitDocGird() {
    var columns = [
        [
            // LDDLRowId,pcpId,userCode,userName
            { field: 'pcpId', title: 'lddiId', align: 'center', width: 80, hidden: true },
            { field: 'userCode', title: $g('医生工号'), align: 'left', width: 150 },
            { field: 'userName', title: $g('医生名称'), align: 'left', width: 285 },
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#TextLocDocMainBar',
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'pcpId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryDocInLoc',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
	        var pageSize = $('#DocGird').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 ) {  //&& total <= pageSize
                $('#DocGird').datagrid('selectRow', 0);
            }
	        
	        },
        onSelect: function (rowIndex, rowData) {
            QueryDrugWithLocGird();
            QueryDrugWithOutLocGird();
        },
    };
    PHA.Grid('DocGird', dataGridOption);
}

///-------------------------审核医生主列表-------End------------------------------------///

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
    //医嘱项lookup
    var opts = $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: lookUpWidth,
    });

    PHA.LookUp('LULocInciArcim', opts);
    PHA.LookUp('LULocInciArcimNo', opts);
    PHA.LookUp('LUArcimAndLoc', $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: DurgToLocLeft,
    }));  

    var opts = $.extend({}, PHA_STORE.PHCGeneric('Y'), {
        width: lookUpWidth,
    });
    PHA.LookUp('LULocPhcg', opts);
    PHA.LookUp('LULocPhcgNo', opts);
    PHA.LookUp('LUPHCGMain', $.extend({}, PHA_STORE.PHCGeneric('Y'), {
        width: DurgToLocLeft,
    }));

    //医生科室
    PHA.ComboBox('cmbDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: ComBoxWidthLoc,
    });
    //医生科室
    PHA.ComboBox('cmbDrugDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: searchBoxWidth,
    });
    //医生科室
    PHA.ComboBox('cmbDrugDocLocNo', {
        url: PHA_STORE.DocLoc().url,
        width: searchBoxWidth,
    });
}