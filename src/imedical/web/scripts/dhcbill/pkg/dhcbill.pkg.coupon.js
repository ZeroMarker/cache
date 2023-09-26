/*
 * FileName:	dhcbill.pkg.coupon.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: 优惠券发放
 */
 $(function () {

	init_East();
	
	init_westGrid();
	
	$HUI.linkbutton("#btn-Send", {
		onClick: function () {
			sendClick();
		}
	});
	// 张数numberbox 
	$('#sendNum').keydown(function (e) {
		if (e.keyCode == 13) {
			setNo(this.value);
		}
	});	
	$('#sendNum').bind('change ',function(){
		setNo(this.value);	
	});	
	// 张数numberbox 
	setValueById('startDate',getDefStDate(-31));
	setValueById('endDate',getDefStDate(0));
	init_couponCombobox();
});
// 初始化east grid
function init_East(){
	$HUI.datagrid("#dgEast", {
		border: false,
		fit: true,
		singleSelect: true,
		bodyCls: 'panel-header-gray',
		rownumbers: true,
		pagination: true,
		data:[],
		columns: [[
			{field:'CPNCtDesc',title:'优惠券模板',width:150},
			{field:'CPNCustName',title:'客户姓名',width:150 },
			{field:'CPNNo',title:'券号',width:150},
			{field:'CPNStatus',title:'状态',width:150,
				styler:function(value,row,index){
					return value=='有效'?'color:green;font-weight:bold':'color:red;font-weight:bold'
				}
			
			},
			{field:'CPNCreatDate',title:'创建日期',width:150},
			{field:'CPNCreatTime',title:'创建时间',width:150},
			{field:'CPNServname',title:'客服姓名',width:150},
			{field:'CPNUpdateDate',title:'消费日期',width:150},
			{field:'CPNUpdateTime',title:'消费时间',width:150}

			]],
		onLoadSuccess:function(data){
			checkNo(data);		
		}
	})
}
// 发放

function sendClick(){
	checkRepeatNo();
}
function saveInfo(){
	var startNo=getValueById('startNo');
	var endNo=getValueById('endNo');
	var patName=getValueById('PAName');
	var UserName=PUBLIC_CONSTANT.SESSION.USERNAME;
	var creatUserDr=PUBLIC_CONSTANT.SESSION.USERID;
	var note=getValueById('Note');
	var AdmType='OP';
	var ExpStr=patName+'^'+UserName+'^'+creatUserDr+'^'+note+'^'+AdmType+'^'+PUBLIC_CONSTANT.SESSION.HOSPID
	if(startNo==''||endNo==''){	
		return;
	}
	$.m({
			ClassName: "BILL.PKG.BL.Coupon",
			MethodName: "Couponissuance",
			CounCode:getValueById('couponCode'),
			StrNo:startNo,
			EntNo:endNo,
			ExpStr:ExpStr,
		}, function (rtn) {
			if(rtn=='0'){
				$.messager.alert('提示','发放成功','info');	
				loadEastDatagrid();
			}else{
				$.messager.alert('提示','发放失败','info');		
			}
	});	
}

// 初始化 west grid
function init_westGrid(){
	var dgColumns = [[
			{field:'PROCode',title:'产品编码',width:100},
			{field:'PROName',title:'产品名称',width:120 },
			{field:'PROSalesPrice',title:'售价',width:90,align:'right' ,
				formatter:function(value){
					return formatAmt(value);	
				}
			},
			{field:'PROPrice',title:'标准价格',width:90,align:'right',
				formatter:function(value){
					return formatAmt(value);	
				}},
			{field:'PROMimuamout',title:'最低售价',width:90,align:'right',
				formatter:function(value){
					return formatAmt(value);	
				}
			},
			{field:'PROStartDate',title:'生效日期',width:150},
			{field:'PROLevel',title:'套餐等级',width:120},
			{field:'Rowid',title:'Rowid',width:150,hidden:true}
		]];
	$('#ProTable').datagrid({
		fit:true,
		headerCls:'panel-header-gray',
		//fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data:[],
		onBeforeLoad:function(param){
		},
		columns: dgColumns,
		onLoadSuccess: function (data) {
			cal_CouponAmt(data);
		},
		onDblClickRow:function(rowIndex, rowData){
			//transClick(rowIndex)	
		}
	});
			
	
}
// 加载west grid
function LoadProDatagrid(){
	var queryParams={
			ClassName:'BILL.PKG.BL.CouponTemplate',
			QueryName:'FindCouponProductByCode',
			CTPCode:getValueById('couponCode'),
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	}
	$('#ProTable').datagrid({
		queryParams:queryParams,
		url: $URL
	})
	$('#ProTable').datagrid('reload');	
}
// 计算总金额
function cal_CouponAmt(data){
	var tmpAmt=0
	if(data.total<1){
		setValueById('totalAmt',parseFloat(tmpAmt).toFixed(2));
		return;
	}
	$.each(data.rows, function (index, row) {
		tmpAmt=tmpAmt+parseFloat(row.PROSalesPrice);
	});
	setValueById('totalAmt',parseFloat(tmpAmt).toFixed(2));
}
// 初始化优惠券下拉框
function init_couponCombobox(){
	$('#couponCode').combobox({
		method: 'GET',
		valueField: 'Code',
		textField: 'Desc',
		onBeforeLoad:function(param){
			param.ResultSetType='array';
		},
		onSelect: function (record) {
			setValueById('coupon',record.Code);
			LoadProDatagrid();
			loadEastDatagrid();
		},
		onChange: function (newValue, oldValue) {
		}		
	})	
	loadCouponTemplate();
}
// 加载 Eastgrid
function loadEastDatagrid(){
	var queryParams={
			ClassName:'BILL.PKG.BL.Coupon',
			QueryName:'FindCoupon',
			ConRowId:'',
			ConCode:getValueById('couponCode'),
			StDate:'',
			EntDate:'',
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			
	}
	$('#dgEast').datagrid({
		queryParams:queryParams	,
		url: $URL
	})
	$('#dgEast').datagrid('reload');	
}
// 默认开始号码为上次发的末尾号
function checkNo(data){
	var couponCode=getValueById('couponCode')
	var StartNo='0';
	$.each(data.rows, function (index, row) {
		var no=row.CPNNo.split(couponCode)[1]
		if(StartNo==0) StartNo=no;
		if(StartNo<no) StartNo=no;
	});	
	setValueById('startNo',parseFloat(StartNo)+1);
}
// 根据数量和开始号码 计算结束号码
function setNo(num){
	var startNo=getValueById('startNo');
	if(startNo==""){
		$.messager.alert('提示','开始号码不能为空','info');	
		return;
	}
	var endNo=parseFloat(startNo)+parseFloat(num);
	setValueById('endNo',endNo);
	
}
// 判断是否重复号码
function checkRepeatNo(){
	var startNo=getValueById('startNo');
	var endNo=getValueById('endNo');
	if(getValueById('couponCode')==''){
		$.messager.alert('提示','请先选择优惠券有模板','info');
		return ;
	}
	var leftDGData=$('#ProTable').datagrid('getData');
	if(leftDGData.rows.length<1){
		$.messager.alert('提示','优惠券模板未维护套餐产品','info');
		return ;
	}
	if(startNo==''||endNo==''){
		$.messager.alert('提示','开始号码或结束号码不能为空','info');
		return ;
	}
	$.m({
			ClassName: "BILL.PKG.BL.Coupon",
			MethodName: "CouponissuanceNo",
			CounCode:getValueById('couponCode'),
			StrNo:startNo,
			EntNo:endNo
		}, function (rtn) {
			if(rtn!='0'){
				$.messager.alert('提示','号段中存在重复号码'+rtn,'info');
				return ;
			}else{
				saveInfo(); // 不重复才能进行发放
			}
	});
	
}
// 加载优惠券模板combogrid
function loadCouponTemplate(){
	$('#couponCode').combobox('clear')
	var inStr="&CTPDesc="+'';
	var inStr=inStr+"&CTPCode="+'';
	var inStr= inStr+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID;
	var inStr=inStr+"&StDate="+getValueById('startDate');
	var inStr= inStr+"&EntDate="+getValueById('endDate');
	var inStr=inStr+"&Flag="+1;
	var url = $URL + "?ClassName=BILL.PKG.BL.CouponTemplate&QueryName=FindCouponTemplate&ResultSetType=array" +inStr;
	$('#couponCode').combobox('reload',url);	
}
// 院区combogrid选择事件
function selectHospCombHandle(){
	loadCouponTemplate();
	LoadProDatagrid();
	loadEastDatagrid();
}