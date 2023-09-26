/* 
 * FileName:	dhcbillmenu.taritemdetail.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	收费项目信息
 * Description: 
*/
var TarRowid="";
var WINPUBLIC_CONSTANT={
	WINSESSION:{
		WINGROUP_ROWID : session['LOGON.GROUPID'],
        WINGROUP_DESC : session['LOGON.GROUPDESC'],
        WINGUSER_ROWID : session['LOGON.USERID'],
        WINGUSER_NAME : session['LOGON.USERNAME'],
        WINGUSER_CODE : session['LOGON.USERCODE'],
		WINHOSPID : session['LOGON.HOSPID']
	},
	WINURL:{
		WINQUERY_GRID_URL : "./dhcbill.query.grid.easyuiorder.csp",
		WINQUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp",
		WINMETHOD_URL : "./dhc.method.easyui.csp"
	},
	WINCATE:{
		WINTARCATE : "",
		WINTARSUBCATE : "",
		WINSUBCATEINDEX : "",
		WINARCNUM : 3,	//query input num
		WINNUM : 2,	//comboquery input num
		WINTABLE : ""
	},
	WINMETHOD:{
		WINCLS : "DHCBILLConfig.DHCBILLFIND",
		WINCOMBOCLS : "DHCBILLConfig.DHCBILLSysType",
		WINQUERY : "FindTarPrice",
		WINCOMBOQUERY : "FindAdmReason",
		WINGETTAR : "GetTarItem",
		WININSERT : "InsertTarInfo",
		WINPRICEINSERT : "InsertTarPrice",
		WINUPDATE : "UpdateTarInfo",
		WINDELETE : ""
	}
};

$(function(){
	var selected = $('#tTarCate').datagrid('getSelected'); // 获取父窗体datagrid选择数据
	if(selected){TarRowid=selected.rowid;}
	initwinGrid();
	setTimeout('initwinLoadGrid('+TarRowid+')',10);
	if(TarRowid !== ""){
		$('#winAdd').hide();
		loadwinTarInfo(TarRowid);
		// 增加combobox维护权限
		winInitCombobox();
	}else{
		winInitCombobox();
	}
	if(BDPAutDisableFlag('winAdd')){
		$('#winAdd').hide();
	}
	if(BDPAutDisableFlag('winUpdate')){
		$('#winUpdate').hide();
	}
	if(BDPAutDisableFlag('winPriceAdd')){
		$('#winPriceAdd').hide();
	}
	if(BDPAutDisableFlag('winPriceSave')){
		$('#winPriceSave').hide();
	}
});

var EditIndex=-1;	//获取修改列
	
function initwinGrid(){
	// 初始化Columns
	var winCateColumns = [[
		{ field: 'TPPatInsType', title: '收费类型', width: 100, align: 'center', sortable: true, resizable: true,
			editor:{  
				type:'combobox',  
				options:{
					url:WINPUBLIC_CONSTANT.WINURL.WINQUERY_COMBO_URL,
					valueField:'RowID',
					textField:'READesc',
					required:true,
					onBeforeLoad:function(param){
						param.ClassName = WINPUBLIC_CONSTANT.WINMETHOD.WINCOMBOCLS;
						param.QueryName = WINPUBLIC_CONSTANT.WINMETHOD.WINCOMBOQUERY;
						param.Arg1 = "";	//项目代码
						param.Arg2 = "";	//项目名称
						param.ArgCnt = WINPUBLIC_CONSTANT.WINCATE.WINNUM;
					},
					onSelect:function(rec){
						AdmReaonDr=rec.RowID;	//获取选中的就诊类型ID
					}
				}
			}
		},
		{ field: 'TPStartDate', title: '起始日期', width: 80, align: 'center', editor: 'datebox',required: true, sortable: true, resizable: true },
		{ field: 'TPEndDate', title: '结束日期', width: 100, align: 'center', editor: 'datebox',required: true, sortable: true, resizable: true, hidden: true },
		{ field: 'TPPrice', title: '标准价格', width: 100, align: 'right', editor: 'text', sortable: true, resizable: true },
		{ field: 'TPAlterPrice1', title: '辅助价格1', width: 100, align: 'right', editor: 'text', sortable: true, resizable: true },
		{ field: 'TPAlterPrice2', title: '辅助价格2', width: 100, align: 'right', editor: 'text', sortable: true, resizable: true },
		{ field: 'TPLimitedPrice', title: '限价', width: 100, align: 'right', editor: 'text', sortable: true, resizable: true, hidden: true },
		{ field: 'TPDiscRate', title: '记账比例', width: 100, align: 'center', editor: 'text', sortable: true, resizable: true, hidden: true },
		{ field: 'TPPayorRate', title: '折扣比例', width: 100, align: 'center', editor: 'text', sortable: true, resizable: true, hidden: true },
		{ field: 'TPUpdateDate', title: '更新日期', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TPUpdateTime', title: '更新时间', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TPUpdateUser', title: '更新人', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TPHospitalDR', title: '医院', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TPRowId', title: 'TPRowId', width: 100, align: 'center', sortable: true, resizable: true, hidden: true }
	]];
	
	// 初始化DataGrid
	$('#wintTarCate').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : '',
		loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [15,50,100,200],
		columns : winCateColumns,
		toolbar : '#wintToolBar',
		onRowContextMenu : function(e, rowIndex, rowData) {
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){
			EditIndex=-1;
		}
	});
}

function initwinLoadGrid(TarRowid)
{
	var queryParams = new Object();
	queryParams.ClassName = WINPUBLIC_CONSTANT.WINMETHOD.WINCLS;
	queryParams.QueryName = WINPUBLIC_CONSTANT.WINMETHOD.WINQUERY;
	queryParams.Arg1 = TarRowid;	//项目代码
	queryParams.Arg2 = WINPUBLIC_CONSTANT.WINSESSION.WINHOSPID;	//医院
	queryParams.Arg3 = WINPUBLIC_CONSTANT.WINSESSION.WINGROUP_ROWID;	//用户
	queryParams.ArgCnt = WINPUBLIC_CONSTANT.WINCATE.WINARCNUM;
	loadwinDataGridStore("wintTarCate", queryParams);
}

///加载DataGrid数据
function loadwinDataGridStore(DataGridID, queryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = WINPUBLIC_CONSTANT.WINURL.WINQUERY_GRID_URL;
	jQueryGridObj.datagrid('load', queryParams);
}

function loadwinTarInfo(TarRowid)
{
	$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS,WINPUBLIC_CONSTANT.WINMETHOD.WINGETTAR,"false",function gettarinfo(value){
		if(value==""){return;}
		var tar=value.split("^");
		$('#winTxtCode').val(tar[0]);		// 项目代码
		$('#winTxtDesc').val(tar[1]);		// 项目名称
		$('#winTxtInsuDesc').val(tar[21]);	// 医保名称
		$('#winTxtOutCode').val(tar[13]);	// 外部编码
		$('#winTxtChargeDescrip').val(tar[22]);	// 收费说明
		$('#winTxtChargeReason').val(tar[23]);	// 收费依据
		$('#winComboUom').combogrid('setValue',tar[2]);		// 单位
		$('#winComboSubCate').combobox('setValue',tar[4]);		// 收费项目子类
		$('#winComboAccCate').combobox('setValue',tar[6]);		// 收费会计子类
		$('#winComboIpCate').combobox('setValue',tar[14]);		// 住院费用子类
		$('#winComboOpCate').combobox('setValue',tar[16]);		// 门诊费用子类
		$('#winComboEmcCate').combobox('setValue',tar[18]);		// 经济核算子类
		$('#winComboMrCate').combobox('setValue',tar[8]);		// 旧病案首页子类
		$('#winComboNMrCate').combobox('setValue',tar[24]);		// 新病案首页子类
		if(tar[10]=="Y"){
			$('#winCheckActive').attr("checked",true);	// 有效标志
		}else{
			$('#winCheckActive').attr("checked",false);	// 有效标志
		}
		if(tar[20]=="Y"){
			$('#winCheckSpecial').attr("checked",true);	// 特殊项目标识
		}else{
			$('#winCheckSpecial').attr("checked",false);	// 特殊项目标识
		}
		$('#winTxtYJPTBM').val(tar[26]);	// 医价平台编码
	},"","",TarRowid);
}

$('#winAdd').bind('click', function(){
	var TarCode=$('#winTxtCode').val();
	var TarDesc=$('#winTxtDesc').val();
	var TarInsuName=$('#winTxtInsuDesc').val();
	var TarExtCode=$('#winTxtOutCode').val();
	var TarEngName=$('#winTxtChargeDescrip').val();
	var TarChargeBasis=$('#winTxtChargeReason').val();
	var TarUom=$('#winComboUom').combogrid('getValue');
	var TarSubCate=$('#winComboSubCate').combobox('getValue');
	var TarAccCate=$('#winComboAccCate').combobox('getValue');
	var TarIpCate=$('#winComboIpCate').combobox('getValue');
	var TarOpCate=$('#winComboOpCate').combobox('getValue');
	var TarEmcCate=$('#winComboEmcCate').combobox('getValue');
	var TarMrCate=$('#winComboMrCate').combobox('getValue');
	var TarNMrCate=$('#winComboNMrCate').combobox('getValue');
	var TarActvFlag=$('#winCheckActive').prop("checked");
	var TarSpecialFlag=$('#winCheckSpecial').prop("checked");
	if(TarActvFlag==true){TarActvFlag="Y";}
	else{TarActvFlag="N";}
	if(TarSpecialFlag==true){TarSpecialFlag="Y";}
	else{TarSpecialFlag="N";}
	var TarExpYJPTBM=$('#winTxtYJPTBM').val();
	var TarAvailDateTime="",TarExpirationDateTime="";
	//if($('#winTxtAvailDateTime')) {TarAvailDateTime=$('#winTxtAvailDateTime').datetimebox('getValue');}
	//if($('#winTxtExpirationDateTime')) {TarExpirationDateTime=$('#winTxtExpirationDateTime').datetimebox('getValue');}
	var TarInfo=""+"^"+TarCode+"^"+TarDesc+"^"+TarInsuName+"^"+TarUom+"^"+TarExtCode+"^"+TarActvFlag;
	var TarInfo=TarInfo+"^"+TarEngName+"^"+TarSpecialFlag+"^"+TarChargeBasis+"^"+TarIpCate+"^"+TarOpCate;
	var TarInfo=TarInfo+"^"+TarEmcCate+"^"+TarMrCate+"^"+TarNMrCate+"^"+TarAccCate+"^"+TarSubCate;
	var TarInfo=TarInfo+"^"+TarAvailDateTime+"^"+TarExpirationDateTime+"^"+TarExpYJPTBM;

	$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS,WINPUBLIC_CONSTANT.WINMETHOD.WININSERT,"false",function updatetarinfo(value){
		var str=value.split("^");
		if(str[0]==0){
			$.messager.alert('消息',"收费项信息添加成功!");
			$('#winAdd').hide();
			TarRowid=str[1];
			loadwinTarInfo(TarRowid);
		}else{
			$.messager.alert('消息',"收费项信息添加失败,错误代码:"+value);
		}
	},"","",TarInfo,WINPUBLIC_CONSTANT.WINSESSION.WINGUSER_ROWID,"");
});

$('#winUpdate').bind('click', function(){
	if(TarRowid==""){
		$.messager.alert('消息',"收费项目ID为空,不能修改!");
		return;
	}
	var TarCode=$('#winTxtCode').val();
	var TarDesc=$('#winTxtDesc').val();
	var TarInsuName=$('#winTxtInsuDesc').val();
	var TarExtCode=$('#winTxtOutCode').val();
	var TarEngName=$('#winTxtChargeDescrip').val();
	var TarChargeBasis=$('#winTxtChargeReason').val();
	var TarUom=$('#winComboUom').combobox('getValue');
	var TarSubCate=$('#winComboSubCate').combobox('getValue');
	var TarAccCate=$('#winComboAccCate').combobox('getValue');
	var TarIpCate=$('#winComboIpCate').combobox('getValue');
	var TarOpCate=$('#winComboOpCate').combobox('getValue');
	var TarEmcCate=$('#winComboEmcCate').combobox('getValue');
	var TarMrCate=$('#winComboMrCate').combobox('getValue');
	var TarNMrCate=$('#winComboNMrCate').combobox('getValue');
	var TarActvFlag=$('#winCheckActive').prop("checked");
	var TarSpecialFlag=$('#winCheckSpecial').prop("checked");
	if(TarActvFlag==true){TarActvFlag="Y";}
	else{TarActvFlag="N";}
	if(TarSpecialFlag==true){TarSpecialFlag="Y";}
	else{TarSpecialFlag="N";}
	var TarExpYJPTBM=$('#winTxtYJPTBM').val();
	var TarAvailDateTime="",TarExpirationDateTime="";
	//if($('#winTxtAvailDateTime')) {TarAvailDateTime=$('#winTxtAvailDateTime').datetimebox('getValue');}
	//if($('#winTxtExpirationDateTime')) {TarExpirationDateTime=$('#winTxtExpirationDateTime').datetimebox('getValue');}
	var TarInfo=TarRowid+"^"+TarCode+"^"+TarDesc+"^"+TarInsuName+"^"+TarUom+"^"+TarExtCode+"^"+TarActvFlag;
	var TarInfo=TarInfo+"^"+TarEngName+"^"+TarSpecialFlag+"^"+TarChargeBasis+"^"+TarIpCate+"^"+TarOpCate;
	var TarInfo=TarInfo+"^"+TarEmcCate+"^"+TarMrCate+"^"+TarNMrCate+"^"+TarAccCate+"^"+TarSubCate;
	var TarInfo=TarInfo+"^"+TarAvailDateTime+"^"+TarExpirationDateTime+"^"+TarExpYJPTBM;

	$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS,WINPUBLIC_CONSTANT.WINMETHOD.WINUPDATE,"false",function updatetarinfo(value){
		if(value==0){
			$.messager.alert('消息',"收费项信息修改成功!");
			loadwinTarInfo(TarRowid);
		}else{
			$.messager.alert('消息',"收费项信息修改失败,错误代码:"+value);
		}
	},"","",TarInfo,WINPUBLIC_CONSTANT.WINSESSION.WINGUSER_ROWID,"");
});

$('#winPriceAdd').bind('click', function(){
	if(TarRowid==""){
		$.messager.alert('消息',"收费项目ID为空,不能添加价格,请先添加收费项目!");
		return;
	}
	lastIndex = $('#wintTarCate').datagrid('getRows').length-1;  
	$('#wintTarCate').datagrid('selectRow', lastIndex);
	var selected = $('#wintTarCate').datagrid('getSelected');
	if (selected){
		if((selected.TPRowId == "")||(selected.TPRowId == "undefined")||(typeof(selected.TPRowId) == "undefined")){
			$.messager.alert('消息',"不能同时添加多条!");
			return;
		}
	}
	$('#wintTarCate').datagrid('appendRow',{
		TPPatInsType : '',
		TPStartDate : '',
		TPEndDate : '',
		TPPrice : '',
		TPAlterPrice1 : '',
		TPAlterPrice2 : '',
		TPLimitedPrice : '',
		TPDiscRate : '',
		TPPayorRate : ''
	});
	lastIndex = $('#wintTarCate').datagrid('getRows').length-1;
	$('#wintTarCate').datagrid('selectRow', lastIndex);
	$('#wintTarCate').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#winPriceSave').bind('click', function(){
	if(TarRowid==""){
		$.messager.alert('消息',"收费项目ID为空,不能保存价格,请先添加收费项目!");
		return;
	}
	$('#wintTarCate').datagrid('acceptChanges');
	$('#wintTarCate').datagrid('selectRow',EditIndex);
	var selected = $('#wintTarCate').datagrid('getSelected');
	if (selected){
		// selected.rowid为undefined，说明是新建项目，调用保存接口
		if((selected.TPRowId == "")||(selected.TPRowId == "undefined")||(typeof(selected.TPRowId) == "undefined")){
			var PriceStr=TarRowid+"^"+selected.TPPatInsType+"^"+selected.TPStartDate+"^"+selected.TPEndDate;
			var PriceStr=PriceStr+"^"+selected.TPPrice+"^"+selected.TPAlterPrice1+"^"+selected.TPAlterPrice2;
			var PriceStr=PriceStr+"^"+selected.TPLimitedPrice+"^"+selected.TPDiscRate+"^"+selected.TPPayorRate;
			if((typeof(selected.TPPatInsType) == "undefined") || (typeof(selected.TPStartDate) == "undefined") || (selected.TPPatInsType == "") || (selected.TPStartDate == "")){
				$.messager.alert('消息',"数据为空,不允许添加!");
				EditIndex=-1;
				initwinLoadGrid(TarRowid);
				return;
			}
			$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS,WINPUBLIC_CONSTANT.WINMETHOD.WINPRICEINSERT,"false",function insertprice(value){
				if(value.split("^")[0]=="0"){
					$.messager.alert('消息',"保存成功!");
					TPRowid=value.split("^")[1];
				}else{$.messager.alert('消息',"保存失败,错误代码:"+value);}
				EditIndex=-1;
				initwinLoadGrid(TarRowid);
			},"","",PriceStr,WINPUBLIC_CONSTANT.WINSESSION.WINGUSER_ROWID,WINPUBLIC_CONSTANT.WINSESSION.WINHOSPID);
		}
	}
});

$('#winFind').bind('click', function(){
	EditIndex=-1;
	initwinLoadGrid(TarRowid);
});

function winInitCombobox()
{
	if(BDPAutDisableFlag('winComboSubCate')){
		$('#winComboSubCate').combobox({disabled: true});
	}
	if(BDPAutDisableFlag('winComboAccCate')){
		$('#winComboAccCate').combobox({disabled: true});
	}
	if(BDPAutDisableFlag('winComboIpCate')){
		$('#winComboIpCate').combobox({disabled: true});
	}
	if(BDPAutDisableFlag('winComboOpCate')){
		$('#winComboOpCate').combobox({disabled: true});
	}
	if(BDPAutDisableFlag('winComboEmcCate')){
		$('#winComboEmcCate').combobox({disabled: true});
	}
	if(BDPAutDisableFlag('winComboMrCate')){
		$('#winComboMrCate').combobox({disabled: true});
	}
	if(BDPAutDisableFlag('winComboNMrCate')){
		$('#winComboNMrCate').combobox({disabled: true});
	}
}
