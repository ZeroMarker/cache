/*
 * FileName:	dhcbill.pkg.coupontemplate.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: 优惠券模板维护
 */
 var GV={
	 editRowIndex:-1
}
 $(function () {
	init_dg(); 

	// 鼠标悬浮框dg
	init_ProductDg();
	
	setValueById('SearchCtpStartDate',getDefStDate(-31));
	setValueById('SearchCtpEndDate',getDefStDate(31));
	PKGLoadDicData('SearchCtpStatus','CouponTemplate','','combobox');
	
	init_addTemplateDialog();
	$('#SearchCtpCode').keydown(function (e) {
		var key = websys_getKey(e);
			if (key == 13) {
				initLoadGrid();
			}
	})
});
/*
 * 优惠券模板维护界面datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'Code',title:'优惠券代码',width:150},
			{field:'Desc',title:'优惠券名称',width:150 },
			{field:'VisStrDate',title:'有效开始日期',width:150},
			{field:'VisEntDate',title:'有效结束日期',width:220},
			{field:'CTPFlag',title:'状态',width:150,
				styler:function(value,row,index){
					return value=='有效'?'color:green;font-weight:bold':'color:red;font-weight:bold'
				},
				editor:{
					type:'combobox',
					options:{
						valueField:'Code',
						textField:'Desc',
						url:$URL,
						editable:false,
						onBeforeLoad:function(param){
							param.ClassName='BILL.PKG.BL.Dictionaries';
							param.QueryName='QueryDic';
							param.ResultSetType='Array';
							param.DictType='CouponTemplate';
							param.DicCode='';
							param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
						}		
		
					}		
				}
			},
			{field:'CreatDate',title:'创建日期',width:150},
			{field:'CreatTime',title:'创建时间',width:120},
			{field:'CreatUser',title:'创建人',width:150},
			{field:'Hospital',title:'院区',width:150},
			{field:'CTPInstruc',title:'产品说明',width:150,hidden:true },
			{field:'CTPRowId',title:'CTPRowId',width:150,hidden:true },
		]];
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		data:[],
		columns: dgColumns,
		frozenColumns: [[
							{
								title: '产品信息', field: 'ProductInfo', width:100,align:'center',
								formatter:function(value, row, index){
									return "<a href='#' onmouseover='showProPanel("+JSON.stringify(row)+")' onMouseOut='closeProPanel()' \
									onclick='showProWindow("+JSON.stringify(row)+")'><img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/template.png ' border=0/>\
									</a>";
								}
							}
						]],
		onLoadSuccess: function (data) {
			GV.editRowIndex = -1;
		},
		onSelect:function(index,row){
			datagridEditRow(index);
		}
	});
}
/*
* 加载dg
*/
function initLoadGrid(){
	var queryParams={
		ClassName:'BILL.PKG.BL.CouponTemplate',
		QueryName:'FindCouponTemplate',
		KeyCode:getValueById('SearchCtpCode'),
		StDate:getValueById('SearchCtpStartDate'),
		EntDate:getValueById('SearchCtpEndDate'),
		Flag:getValueById('SearchCtpStatus'),
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore('dg',queryParams);	
}
/*
 * 查找
 */
$('#BtnFind').bind('click', function () {
	initLoadGrid();
});
/*
 * 清屏
 */
$('#BtnClear').bind('click', function () {
	window.location.reload(true);	
})
/*
 * 新增模板信息
 */
$('#BtnAdd').bind('click', function () {
		//
	$('#CouponTemplateWin').show(); 
	$HUI.dialog("#CouponTemplateWin",{
			title:"优惠券模板维护",
			height:460,
			width:770,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	$('#CtpStatus').combobox('select','1');

});
/*
 * 修改模板信息
 */
$('#BtnUpdate').bind('click', function () {
	if(GV.editRowIndex=='-1'){
		$.messager.alert('提示','请先选择要修改的数据','info');
		return;
	}else{
		$('#dg').datagrid('acceptChanges');
		var selected = $('#dg').datagrid('getSelected');
		var RowId=selected.CTPRowId;
		var Guser=PUBLIC_CONSTANT.SESSION.USERID;
		var Status=selected.CTPFlag;
		if(isNaN(Status)){
			$.messager.alert('提示','没有要修改的数据','info');
			return;
		}
		$.m({
			ClassName: "BILL.PKG.BL.CouponTemplate",
			MethodName: "CouponTmpConProUpdate",
			RowId: RowId,
			Status:Status,
			Guser:Guser
			}, function(rtn){
				if(rtn.split('^')[0]=='0'){
					$.messager.alert('提示', "修改成功", 'info');
					initLoadGrid();	
				}else{
					$.messager.alert('提示', "修改失败，错误代码：" + rtn.split('^')[1], 'error');	
			}
	});
	}
});
/*
 * 模板信息弹窗中的保存
 */
$('#PanelBtnSave').bind('click', function () {
	var CtpCode=getValueById('CtpCode');
	if(CtpCode==''){
			$.messager.alert('提示', "优惠券代码不能为空", 'info');	
			return;
	}
	
	var CtpDesc="^"+getValueById('CtpDesc');
	if(getValueById('CtpDesc')==''){
			$.messager.alert('提示', "优惠券描述不能为空", 'info');	
			return;
	}
	var CtpValidStartDate="^"+getValueById('CtpValidStartDate');
	var CtpValidEndDate="^"+getValueById('CtpValidEndDate');
	var CtpStatus="^"+getValueById('CtpStatus');
	if(getValueById('CtpStatus')==''){
			$.messager.alert('提示', "优惠券状态不能为空", 'info');	
			return;
	}
	var rtn=tkMakeServerCall('BILL.PKG.BL.CouponTemplate','CheckCouponTemplateRepeat',CtpCode);
	if(rtn!=0){
		$.messager.alert('提示', "优惠券代码已经存在", 'info');	
		return
	}
	var CtpCreateDate="^"+'';
	var CtpCreateTime="^"+'';
	var CtpCreateuser="^"+PUBLIC_CONSTANT.SESSION.USERID;
	var CtpUpdateDate="^"+'';
	var CtpUodateTime="^"+'';
	var CtpUpdateuser="^"+'';
	var CtpHospitalid="^"+PUBLIC_CONSTANT.SESSION.HOSPID;
	var CtpMark="^"+getValueById('CtpMark');
	var CtpInstruc="^"+getValueById('CtpInstruc');
	var CtpHospTel="^"+getValueById('CtpHospTel');
	var CtpHospAdr="^"+getValueById('CtpHospAdr');
	var CtpHospTra="^"+getValueById('CtpHospTra');
	var CtpExt01="^"+getValueById('CtpExt01');
	var CtpExt02="^"+getValueById('CtpExt02');
	var CtpExt03="^"+getValueById('CtpExt03');
	// Rowid^优惠券代码^优惠券名称^创建日期^创建时间^修改日期^修改时间^创建人^修改人^备注^医院ID^有效开始日期^有效结束日期^状态^使用说明^电话^地址^院训^扩展01^扩展02^扩展03
	var Instring="^"+CtpCode+CtpDesc+CtpCreateDate+CtpCreateTime;
	Instring = Instring+CtpUpdateDate+CtpUodateTime+CtpCreateuser +CtpUpdateuser+CtpMark+CtpHospitalid+CtpValidStartDate+CtpValidEndDate+CtpStatus;
	Instring=Instring+CtpInstruc+CtpHospTel+CtpHospAdr+CtpHospTra+CtpExt01+CtpExt02+CtpExt03;
	$.m({
		ClassName: "BILL.PKG.BL.CouponTemplate",
		MethodName: "Save",
		InStr: Instring,
	}, function(rtn){
		if(rtn.split('^')[0]=='0'){
			$.messager.alert('提示', "保存成功", 'info');	
		}else{
			$.messager.alert('提示', "保存失败，错误代码：" + rtn.split('^')[1], 'error');	
		}
		$HUI.dialog("#CouponTemplateWin",'close');
		setValueById('SearchCtpCode',CtpCode);
		initLoadGrid();
	});
	
	
		
});

/*
 * 优惠券模板产品维护弹窗 (div)
 */
function showProWindow(rowData){
	var url = "dhcbill.pkg.coupontmpconpro.csp?templateId="+rowData.CTPRowId+'&templateCode='+rowData.Code+'&HOSPITAL='+PUBLIC_CONSTANT.SESSION.HOSPID;
	websys_showModal({
		url: url,
		title: "优惠券模板产品维护",
		iconCls: "icon-w-edit",
		width: "80%",
		height: "75%",
	});	
}
/*
 * 鼠标悬浮显示产品信息
 * ---------Start----------  
 */
function showProPanel(rowData){
	return;
	$('#ProInfo').window({
		width:710,
		height:670,
		title:'套餐简介',
		iconCls: "icon-w-list",
	})
	add_ProTableData(rowData); //产品列表 
	setValueById('mouseCtpDesc',rowData.Desc);
	setValueById('mouseCtpCode',rowData.Code);
	
	
}
function init_ProductDg(){
	var dgColumns = [[
			{field:'PROCode',title:'产品编码',width:100},
			{field:'PROName',title:'产品名称',width:120 },
			{field:'PROSalesPrice',title:'售价',width:90,align:'right',
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}},
			{field:'PROPrice',title:'标准定价',width:90,align:'right',
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}},
			{field:'PROMimuamout',title:'最低售价',width:90,align:'right',
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}},
			{field:'PROStartDate',title:'生效日期',width:100},
			{field:'PROLevel',title:'等级',width:50},
			{field:'Rowid',title:'Rowid',width:150,hidden:true}
		]];
	$('#ProTable').datagrid({
		height:540,
		title:'产品信息',
		headerCls:'panel-header-gray',
		border: true,
		striped: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		rownumbers: true,
		columns: dgColumns,
		onLoadSuccess: function (data) {
			calProAmt(data);	
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
		
}
function add_ProTableData(rowData){			
	var queryParams={
			ClassName:'BILL.PKG.BL.CouponTemplate',
			QueryName:'FindCouponProductByCode',
			CTPCode:rowData.Code,
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore('ProTable',queryParams);
}
function closeProPanel(){
	//$('#ProInfo').window('close');
}
/*
 * 鼠标悬浮显示产品信息
 *
 * ---------End----------  
 */
function INSUCheckStr(InArgStr,InArgName,specialKey) {
    try {
	    if(!specialKey){specialKey="\^\'\"";}
	    if(!InArgName){InArgName="输入框";}
        var ErrMsg="";
		var isFlag="";
		for (var i = 0; i < InArgStr.length; i++) {
      		if(specialKey.indexOf(InArgStr.substr(i, 1))>=0)
      		{
	      	isFlag="1";
	   		} 
   	 	} 
    	if (isFlag=="1") {
	    	ErrMsg="【"+InArgName+"】"+"不允许有"+"\^" +"  "+"\'"+"  "+"\""+" 等字符" ;
	    	$.messager.alert('提示',ErrMsg,'info');
	    	return ErrMsg;
    	}else{
	    	return '';	
	    }
    } catch (error) {
        $.messager.alert('提示','dhcbill.pkg.coupontemplate.js中方法:INSUCheckStr()发生错误:' + error,'info');
    }
    
}
/*
 * 计算鼠标悬浮框总金额
 */
function calProAmt(data){
	var ProAmt=0
	if (data.total>0){
		$.each(data.rows, function (index, row) {
			ProAmt=ProAmt+parseFloat(row.PROSalesPrice);
		});	
	}
	setValueById('mouseCtpPrice',parseFloat(ProAmt).toFixed(2));
}
/*
 * 新增维护信息dialog弹窗
 */
function init_addTemplateDialog()
{
	setValueById('CtpValidStartDate',getDefStDate(0));
	setValueById('CtpValidEndDate',getDefStDate(31));
	// 优惠券状态combobox
	PKGLoadDicData('CtpStatus','CouponTemplate','','combobox');
	//特殊字符验证
	$('#CouponTemplatePan .textbox').blur(function (e) {
			var rtn=INSUCheckStr(this.value);
			if(rtn!=''){
				this.value='';
			}
	});		
}
 /*
 * datagrid 开始新一行编辑并结束上一行编辑
 * index 需要编辑的行号
 */ 
function datagridEditRow(index){
	var tmpEditRowIndex=GV.editRowIndex;
	if(GV.editRowIndex!=-1){
		$('#dg').datagrid('endEdit',GV.editRowIndex);	
	}
	if(tmpEditRowIndex!=index){	// 重复选中取消编辑	
		GV.editRowIndex=index;
		$('#dg').datagrid('beginEdit',GV.editRowIndex);	
	}	
}
// 院区combogrid选择事件
function selectHospCombHandle(){
	initLoadGrid();
}