/**
 * bind 病案复印装订
 * 
 * CREATED BY WHui 2021-12-01
 */

// 页面全局变量对象
var globalObj = {
    
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

//初始化
function Init(){
	var tdateFrom	= Common_GetDate(-7,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#dfDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
    Common_ComboToMrType("cboMrType",ServerObj.MrClass);
    InitgridReqList();
};
	
//事件初始化
function InitEvent(){
    $('#btnBind').click(function(){
		openBindView();
	});
	// 病案号|登记号|条码
    $('#txtNumber').bind('keyup', function(event) {                 
    　　if (event.keyCode == "13") {
            loadgridReqList();
    　　}
    });
    $('#btnQry').click(function(){
		loadgridReqList();
	});
};

 // 初始化待装订(登记状态)申请记录表格
 function InitgridReqList(){
	var columns = [[
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'DisLocDesc',title:'出院科室',width:100,align:'left'},
		{field:'DisDate',title:'出院日期',width:100,align:'left'},
		{field:'ClientName',title:'申请人',width:80,align:'left'},
		{field:'ClientRelationDesc',title:'与患者关系',width:100,align:'left'},
		{field:'IdentityCode',title:'证件号',width:180,align:'left'},
		{field:'RegDate',title:'登记日期',width:100,align:'left'},
		{field:'RegTime',title:'登记时间',width:80,align:'left'},
		{field:'LatestStatusDesc',title:'申请状态',width:80,align:'left'},
		{field:'Telephone',title:'联系电话',width:100,align:'left'},
		{field:'ContentDesc',title:'复印内容',width:180,align:'left'},
		{field:'PurposeIDDesc',title:'复印目的',width:100,align:'left'},
		{field:'CopyNum',title:'复印份数',width:80,align:'left'}
	]];
	var gridReqList =$HUI.datagrid("#gridReqList",{
		fit: true,
		//title: "",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.CopyRequestSrv",
			QueryName:"QryReqList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aDateFrom:'',
			aDateTo:'',
			aMrTypeID:'',
			aStatusCode: '',
            aNumber:'',
			aCopyReqID:''
	    },
		columns:columns
	});
	return gridReqList;
}

function loadgridReqList(){
    var Number = $('#txtNumber').val();
    $("#gridReqList").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.CopyRequestSrv",
        QueryName:"QryReqList",
        aHospID:$('#cboHospital').combobox('getValue'),
		aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
		aDateFrom:$('#dfDateFrom').datebox('getValue'),
		aDateTo:$('#dfDateTo').datebox('getValue'),
        aStatusCode: ServerObj.ReqStatus,
        aNumber:Number,
        aCopyReqID:''
	})
	$('#gridReqList').datagrid('unselectAll');
	$('#txtNumber').val('');
}

/**
 * 装订模块
 */

function openBindView(){
    var selectData=$('#gridReqList').datagrid('getSelections');
    if (selectData.length==0){
		$.messager.popover({msg: '请选择需操作的记录！',type: 'alert',timeout: 1000});
		return false;
	}
    var _title = "复印装订",_icon="icon-w-edit";
    $('#CopyBindDialog').css('display','block');
    var CopyRegisterDialog = $HUI.dialog('#CopyBindDialog',{
        title: _title,
		iconCls: _icon,
		closable: true,
        modal: true,
        minimizable:false,
		maximizable:false,
		collapsible:false,
        onBeforeOpen: function(){
            Common_ComboToDic("cboRelation","RelationType",1,'');
            Common_ComboToDic("cboCertificate","Certificate",1,'');
			// 给基本信息赋值
			setCopyInfo(selectData[0]);
            // 加载复印装订列表
            loadBindVols(selectData[0].CopyReqID);
        },
        onClose: function(){
            // 清空复印装订界面
            clearCopyBind();
        },
		buttons:[{
			text:'装订',
            iconCls:'icon-w-save',
            handler:function(){
                CopyBind();
            }
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				closeView();
			}	
		}]
    });

}

// 加载待装订卷
function loadBindVols(aReqId){
    var columns = [[
    	{field:'DisLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DisDate',title:'出院日期',width:120,align:'left'},
        {field:'ContentDesc',title:'复印内容',width:150,align:'left',showTip:true,tipWidth:200},
        {field:'PurposeIDDesc',title:'复印目的',width:150,align:'left',showTip:true,tipWidth:200},
        {field:'CopyNum',title:'复印份数',width:100,align:'left'},
        {field:'PagesNum',title:'每份页数',width:100,align:'left'},
        {field:'PagesSum',title:'总页数',width:100,align:'left'}
	]];

    var gridBindVols = $HUI.datagrid("#gridBindVols",{
		fit: true,
		title:'病案信息',
		headerCls:'panel-header-gray',
        iconCls:'icon-paper',
		rownumbers: true,
		singleSelect: true,
		autoRowHeight: false,
		loadMsg: '数据加载中...',
		fitColumns: true,
        url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.CopyRequestSrv",
			QueryName:"QryReqList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
			aDateFrom:'',
			aDateTo:'',
			aStatusCode: ServerObj.ReqStatus,
            aNumber:'',
			aCopyReqID:aReqId
	    },
        columns: columns,
        onBeforeLoad:function(param){
            $('#nbPagesNum').numberbox({
                onChange:function(value){
                    changeSelRowData();
                }
            })
        },
        onLoadSuccess: function(data){
            if (data.total>0) {
                $('#gridBindVols').datagrid('selectRow',0);
            }
        },
		onSelect: function(rowIndex, rowData){
			$('#nbPagesNum').numberbox('setValue',rowData.PagesNum);
			$("#txtPagesSum").val(rowData.PagesSum);
			$("#txtTotalCost").val(rowData.TotalCost);
        },
		onUnselect: function(rowIndex, rowData){
		}
	});
}

// 装订
function CopyBind(){
	var data = $('#gridBindVols').datagrid('getData').rows;
	var flg = chkBindData(data);
	if (flg!='') {
		$.messager.popover({msg: flg,type: 'error'});
		return
	} else {
		var strResult = '';
		for (var index = 0; index < data.length; index++) {
			var row = data[index];
			var temStr = row.CopyReqID + '^' +
						 row.CopyReqVolID + '^' +
						 row.VolCopyID + '^' +
						 row.CopyNum + '^' +
						 row.PagesNum + '^' +
						 row.PagesSum + '^' +
						 '' + '^' +			// 单价
						 '' + '^'			// 总费用
			if (strResult=='') {
				strResult = temStr
			} else {
				strResult = strResult + '!' +temStr
			}
		}
		var StatusStr = 'Bind' + '^' +		// 申请表操作状态
						Logon.UserID
		var flg = $m({
			ClassName:"MA.IPMR.SSService.CopyRequestSrv",
			MethodName:"SaveBindReg",
			aStr:strResult,
			aStatusStr:StatusStr,
		},false);
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误", flg.split('^')[1], 'error');
			return;
		}else{
			$.messager.popover({msg: '装订成功',type:'success',timeout: 1000});
			closeView();
			loadgridReqList();
		}
	}
}

// 关闭装订窗口
function closeView(){
	clearCopyBind();
    $('#CopyBindDialog').window("close");
}

// 清空复印装订界面
function clearCopyBind(){
	clearCopyInfo();
    clearEditPart();
	clearBindVols();
}

// 清空编辑区
function clearEditPart(){
    $('#nbPagesNum').numberbox('setValue','');
    $("#txtPagesSum").val('');
    $("#txtTotalCost").val('');
}

// 清空复印基本信息
function clearCopyInfo(){
	$("#txtClientName").val('');
	$("#cboRelation").combobox('setValue','');
    $("#cboCertificate").combobox('setValue','');
    $("#txtIDCode").val('');
    $("#txtTel").val('');
    $("#txtAddress").val('');
    $("#txtResume").val('');
}

// 清空待装订卷表格
function clearBindVols(){
	$("#gridBindVols").datagrid('load',{"rows":[],"total":0});
}

// 打开装订界面，给基本信息赋值
function setCopyInfo(data){
	$('#txtClientName').val(data.ClientName);
	$("#cboRelation").combobox('setValue',data.ClientRelationID);
	$("#cboCertificate").combobox('setValue',data.CertificateID);
	$("#txtIDCode").val(data.IdentityCode);
	$("#txtTel").val(data.Telephone);
    $("#txtAddress").val(data.Address);
    $("#txtResume").val(data.Resume);
}

// 当没份页数改变时，改变总页数等信息
function changeSelRowData(){
    var selectData=$('#gridBindVols').datagrid('getSelections');
    if (selectData.length==0){
		$.messager.popover({msg: '请选择需操作的记录！',type: 'alert',timeout: 1000});
		return false;
	}
    
    var CopyNum     = parseInt(selectData[0].CopyNum);          // 选中卷复印份数
    var PagesNum    = $('#nbPagesNum').numberbox('getValue');   // 每份页数
    var PagesSum    = PagesNum * CopyNum;							// 选中卷复印总页数
    
    $("#txtPagesSum").val(PagesSum);
    
	// 1、选中行原来值
	var rowdata = selectData[0];
	var tIndex  = $('#gridBindVols').datagrid('getRowIndex',rowdata);

	// 2、根据编辑区域的值改变row值
	rowdata.PagesNum = PagesNum;
	rowdata.PagesSum = PagesSum;

	// 3、将改变后的值更新到选中行
	$('#gridBindVols').datagrid('updateRow',{
		index: tIndex,
		row: rowdata
	});
	// 4、取消选中
	// $('#gridBindVols').datagrid('unselectRow',tIndex);
}

// 检验装订数据
function chkBindData(data){
	var err='';
	for (let index = 0; index < data.length; index++) {
		var row = data[index];
		if (row.PagesNum==='') {
			err='页数为空!'
		}
	}
	return err;
}