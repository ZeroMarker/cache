/*
 * FileName:	dhcbill.pkg.confirmation.js
 * User:		TianZJ/tangzf/DingSH
 * Date:		2019-09-23
 * Function:	
 * Description: 门诊套餐确认 该界面也可以进行灵活折扣操作
 */
  var GV={
	 editRowIndex:-1,
	 PAPMI:'',
	 deleteStr:'', 
	 FixFlag:'',
	 PRODUCTFLAG:'', // 1 表示已经进行过套餐确认
	 NoDisFag:'',
	 OrdItms:{}  ,//医嘱执行记录
	 EditIndex: undefined,
	 curRowIndex:-1,
     curRow:{},
     curVal:0.0,
     ed:{},
 };
 $(function () {
	// 初始化面板
	init_Panel();
	// 加载主界面datagrid
	init_dg();
	// 折扣原因
	///init_DiscReason();
	// 优惠券模板
	init_coupon();
	// 优惠券dg
	init_CouponProDG();
	//优惠券产品明细grid
	initCouponDetails();
	// 套餐确认明细dg
	init_ProConfirmDG();
	// 套餐产品明细datagrid
	init_ProdoctOEDetails();
	// 套餐外折扣金额事件 (只有未进行过折扣的才可以操作)
	if(GV.FixFlag!='1'){
		$("#DiscAmt").keyup(function(e){ 
			if(e.keyCode===13){
				calDatagridRate(this.value);	
			}
		
		})
		$('#DiscAmt').bind('change',function(){
				calDatagridRate(this.value);
	  		
		})
	}
});
function init_Panel(){
	// 初始化值
	setValueById('RegNo',getParam('patNo'));
	if(getParam('patNo')){
		GV.PAPMI=tkMakeServerCall("web.DHCOPCashierIF","GetPAPMIByNo",getParam('patNo'),""); 
		var Name=tkMakeServerCall("web.DHCOPCashierIF","GetPatientByRowId",GV.PAPMI,"").split('^')[2]; 
		setValueById('PatName',Name);	
	}
	//初始化折扣金额
	$('#DiscAmt').numberbox({
		precision:2,
		min:0
	})
	// 取消确认
	$HUI.linkbutton("#btn-Delete", {
		onClick: function () {
			DeleteClick();
		}
	});
	// 确认套餐
	$HUI.linkbutton("#btn-Save", {
		onClick: function () {
			loadProductOEDetails('');
			SaveClick();
		}
	});
	// 自动匹配优惠券
	$HUI.linkbutton("#btn-AutoCon", {
		onClick: function () {
			loadCouponOEDetails('');
			AutoConClick();
		}
	});
	// 取消匹配优惠券
	$HUI.linkbutton("#btn-deleteCoupon", {
		onClick: function () {
			deleteCouponClick();
		}
	});
	// 清屏
	$HUI.linkbutton("#btn-Clear", {
		onClick: function () {
			clearClick();
		}
	});
	// 灵活折扣
	$HUI.linkbutton("#btn-FlexDis", {
		onClick: function () {
			flexDisClick();
		}
	});
	// 删除折扣
	$HUI.linkbutton("#btn-dleteFlexDis", {
		onClick: function () {
			dleteFlexDisClick();
		}
	});
}
/*
 * 取消匹配优惠券
 */
function deleteCouponClick(){
	try{
		$.messager.confirm('提示','是否取消优惠券自动匹配？',function(r){
			if(r){
				$.m({
					ClassName: "BILL.PKG.BL.Coupon",
					MethodName: "UpdateCouponConfirmByOrdRowId",
					OrdStr:getParam('ordStr'),
					Guser:PUBLIC_CONSTANT.SESSION.USERID

				}, function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('提示', "取消成功", 'info',function(){
							clearClick();	
						});
					}else{
						$.messager.alert('提示', "取消失败:"+rtn, 'info',function(){
							clearClick();
						});	
					}
				});
			}
		})
	}catch(e){
		$.messager.alert('提示', "异常发生在deleteCouponClick:" + e, 'info');	
	}	
}

/*
 * 清屏
 */
function clearClick(){
	initLoadGrid();
	var GV={
		editRowIndex:-1,
		PAPMI:'',
		deleteStr:'', 
		FixFlag:'',
		PRODUCTFLAG:'' // 1 表示已经进行过套餐确认
 	};		
}
/*
 * 确认套餐
 */
function SaveClick(){
	showCounpConfirmWindow();
}
/*
 * 取消确认
 */
function DeleteClick(){
	if(GV.PRODUCTFLAG!='1'){
		$.messager.alert('提示', "没要需要取消的套餐", 'info');	
		return;	
	}
	var OEORDStr=getCancleOEORDStr();
	if(OEORDStr=='out'||OEORDStr==''){
		$.messager.alert('提示', "没有需要取消的医嘱,或者勾选了套餐外的医嘱", 'info');	
		return;
	}else{
		$.messager.confirm('提示','是否取消确认过的套餐？',function(r){
			if(r){
				$.m({
					ClassName: "BILL.PKG.BL.Coupon",
					MethodName: "UpdatePatProductByOrdRowId",
					Guser:PUBLIC_CONSTANT.SESSION.USERID,
					OrdStr:OEORDStr
				}, function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('提示', "取消成功", 'info',function(){
							clearClick();	
						});
					}else{
						$.messager.alert('提示', "取消失败:"+rtn, 'info',function(){
							clearClick();
						});	
					}
				});
			}
		})		
	}	
}
/*
 * 获取要取消套餐的医嘱串
 */
function getCancleOEORDStr(){
	var OEORDStr='';
	var selectRowData=$('#dg').datagrid('getChecked');
	$.each(selectRowData,function(index, row){
		OEORDStr==''?OEORDStr=row.OEOrdRowID:OEORDStr=OEORDStr+'^'+row.OEOrdRowID;
		if(row.ProductFlag==0){ // 套餐外的不需要取消
			OEORDStr='out';
			return false;
		}
	})
	return OEORDStr;	 
}
/*
 * 套餐确认主界面 datagrid
 */
function init_dg() {
	var dgColumns = [[
			{title: 'ck', field: 'ck', checkbox: true,
				styler:function(value,row,index){
					return true;
				}
			},
			{field:'ProductFlag',title:'套餐标示',width:100,
				formatter:function(value,data,row){
					return value=='1'?'套餐内':'套餐外';
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold'
				}
			},
			{field:'FixFlag',title:'折扣标志',width:100,
				formatter:function(value,data,row){
					return value=='1'?'已折扣':'未折扣';
					 
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'NoDisFag',title:'能否打折',width:80,
				formatter:function(value,data,row){
					return value=='1'?'可':'否';
					 
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'ArcDesc',title:'医嘱名称',width:150},
			{field:'OrdPatPrice',title:'单价',width:100,align:'right'},
			{field:'PackQty',title:'数量',width:80},
			{field:'PackUOM',title:'单位',width:80},
			{field:'Amount',title:'金额',width:100,align:'right'},
			{field:'DisRate',title:'折扣率',width:150,
				editor:{
					type:'numberbox',
					options:{
						precision:4	,
						max:1,
						min:0		
					}

			}},
			{field:'Amt',title:'实收金额',width:150 ,align:'right',
				editor:{
					type:'numberbox',
					options:{
						precision:4	,
						min:0	
					}
				}
			},
			{field:'OrdPatPrice',title:'自付单价',width:150,align:'right'},
			{field:'OrdDiscPrice',title:'折扣单价',width:150,align:'right'},
			{field:'DiscReason',title:'折扣原因',width:150},
			{field:'TArcicDesc',title:'医嘱大类',width:100},
			{field:'ArcCatDesc',title:'医嘱子类',width:100},
			{field:'OEOrdRowID',title:'OEOrdRowID',width:150,hidden:true},
			{field:'FixRowId',title:'FixRowId',width:150,hidden:true},
			{field:'FixSubRowId',title:'FixSubRowId',width:150,hidden:true},
			{field:'ordCateType',title:'ordCateType',width:150,hidden:true},
		]];
	GV.OrdItms=$HUI.datagrid('#dg',{
		fit: true,
		border: false,
		striped: true,
		pagination: true,
		rownumbers: true,
		selectOnCheck: true,
		checkOnSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		singleSelect: false,
		rowStyler:function(idnex,rowData){
		
		},
		columns: dgColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			clearGlobal(); // 设置前先清空
			LoadSuccessHandle(data);
		},
		onSelect:function(index,rowData){
			//if(GV.FixFlag!='1'){ // 已经折扣过的不进行折扣
				 //datagridEditRow(index,rowData);
				 //datagridAmtEnter();
				 //datagridRateEnter();
			//}
		},
	   onClickCell: function (index, field, value) {
			   OrdEditCell(index, field, value);
		},
	   onBeginEdit: function (index, row) {
			   OrdBeginEdit(index, row);
    	},
	
		onAfterEdit:function(rowIndex, rowData, changes){
			//if(changes.DisRate){
				//setRowRate(changes.DisRate, rowIndex, rowData);
				//setValueById('DiscAmt','');

			//}else if(changes.Amt){	
				//calcRowRate(changes.Amt, rowIndex, rowData);
				//setValueById('DiscAmt','');
			//}
			//GV.editRowIndex=-1;	
			OrdAfterEdit(rowIndex, rowData, changes);
		}
		
	});
	initLoadGrid();
}
/*
 * 清屏
 */
$('#btn-Clear').bind('click', function () {
	clear_Click();
})
function clear_Click(){
	window.location.reload(true);
}
 /*
 * datagrid 开始新一行编辑并结束上一行编辑
 * index 需要编辑的行号
 */ 
function datagridEditRow(index,rowData){
	if(GV.editRowIndex!=-1){
		$('#dg').datagrid('endEdit',GV.editRowIndex);	
	}		
	GV.editRowIndex=index;
	if(rowData.ProductFlag=='1'||rowData.ordCateType=='R'){return;} // 套餐内不能编辑
	$('#dg').datagrid('beginEdit',GV.editRowIndex);	
}
/*
 * 套餐确认主界面query加载
 */
function initLoadGrid(){
    var queryParams={
		ClassName:'BILL.PKG.BL.Coupon',
		QueryName:'FindCouponCharge',
		OrdStr:getParam('ordStr'),
		AdmInsType:getParam('curInsType'),
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
		ExpStr:''
	}
	$('#dg').datagrid({
		queryParams:queryParams,
		url:$URL
	})
	$('#dg').datagrid('load');
	
	GV.OrdItms=$HUI.datagrid('#dg') //DingSH
	
}

/*
 * grid加载成功后 计算面板套餐内外金额 & 设置全局变量
 * data datagrid数据
 */
function LoadSuccessHandle(data){
		var inAmount=0; // 套餐内医嘱金额
		var outAmount=0; // 套餐外医嘱金额
		var InPashare=0; // 套餐内自负金额
		var OutPashare=0;// 套餐外字符金额
		$.each(data.rows, function (index, row) {
			if (row.ProductFlag=='1'){ // 套餐内
					inAmount=inAmount+parseFloat(row.Amount);
					InPashare=InPashare + parseFloat(row.OrdPatPrice) * parseFloat(row.PackQty);
			}else{
				outAmount=outAmount+parseFloat(row.Amount);
				OutPashare=OutPashare + parseFloat(row.OrdPatPrice) * parseFloat(row.PackQty);	
			}	
			setGlobal(row); //设置全局变量
		})
		setValueById('InTotal',parseFloat(inAmount).toFixed(2));
		setValueById('OutTotal',parseFloat(outAmount).toFixed(2));
		setValueById('OutPashare',parseFloat(OutPashare).toFixed(2));
		setValueById('InPashare',parseFloat(InPashare).toFixed(2));
	
}
/*
 * 
 * 初始化优惠券
 */
function init_coupon(){
	$("#CounNo").keyup(function(e){ 
		if(e.keyCode===13){
			checkCoupon();
		}
	})
	$('#CounNo').bind('change',function(){
		checkCoupon();
	})
				
}
/*
* 灵活折扣
*/
function flexDisClick(){
	if(GV.FixFlag=='1'){
		$.messager.alert('提示','该患者已经进行过灵活折扣','info');
		return;
	}
	if(getValueById('DiscReason')==''){
		$.messager.alert('提示','审批单号不能为空','info');
		return;
	}
	$('#dg').datagrid('acceptChanges');
		var editRows=$('#dg').datagrid('getRows');
		var OrdStr='';
		$.each(editRows, function (index, row) {
			if(row.DisRate!=''&&row.DisRate&&row.ordCateType!='R'){
				var OrdPatPrice=parseFloat(row.OrdPatPrice)*parseFloat(row.DisRate); //每条医嘱的自付单价
				var OrdDiscPrice=row.OrdPatPrice-OrdPatPrice;					// 每条医嘱的折扣单价
				var OrdInfo=row.OEOrdRowID+'^'+formatAmt(row.OrdPatPrice)+'^'+formatAmt(OrdDiscPrice)+'^'+formatAmt(OrdPatPrice)+'^'+row.DisRate+'^'+formatAmt(row.Amt)+"^"+row.PackQty;
				if(OrdStr=='') OrdStr=OrdInfo;
				else OrdStr=OrdInfo+'$'+OrdStr;
			}
		});
		///alert("OrdStr="+OrdStr);
		//return;
		if(OrdStr==''){
			$.messager.alert('提示','没有保存的医嘱','info');	
			return;
		}
		$.m({
				ClassName: "BILL.PKG.BL.Flexiblediscount",
				MethodName: "FlexiblediscountSave",
				AdmDr:getParam('myAdmstr'),
				OrdStr:OrdStr,
				OrdExcStr:'',
				Acount:getValueById('OutTotal'), 
				DiscRate:'', 
				DiscAcount:getValueById('DiscAmt'), 
				DiscReason:getValueById('DiscReason'),
				HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
				UserDr:PUBLIC_CONSTANT.SESSION.USERID
			},function(rtn){
				if(rtn.split('^')[0]==='0'){
					$.messager.alert('提示','保存成功','info',function(){
						clear_Click();	
					});
				}else{
					$.messager.alert('提示','保存失败:'+rtn.split('^')[1],'info',function(){
						clear_Click();	
					});
				}
			})		
}
/*
 * 优惠券自动匹配相关
 *
 * ---------Start----------  
 */
function AutoConClick(){
	var CoupNo = getValueById('CounNo');
	if(CoupNo==''){
		$.messager.alert('提示', "优惠券号不能为空", 'info');
		return;	
	}
	var OutPashare = getValueById('OutPashare');
	if ((OutPashare == '')||(OutPashare == 0)){
		$.messager.alert('提示', "自付金额为0，不允许打折", 'info');
		return;	
	}
	showCounpWindow(CoupNo,OutPashare);
}
function showCounpWindow(CoupNo,Total){
	$('#couponProDetails').window({
		width:1010,
		height:570,
		title:'优惠券套餐确认',
		iconCls: "icon-w-list",
	});
	$('#popCouponInfo').show();	
	loadProDetailsDG(CoupNo,Total);
}
/*
 * 初始化优惠券套餐产品dg
 */
function init_CouponProDG(){
	var dgColumns = [[
			{field:'ProCode',title:'产品编码',width:150,
				formatter:function(value, row, index){
					return "<a href='#' \
					onclick='ok_click("+JSON.stringify(row)+")'>\
					"+value+"</a>";
				}
			},
			{field:'ProDesc',title:'产品名称',width:100},
			{field:'ProPrice',title:'价格',width:120,align:'right'},
			{field:'ProSalaPrice',title:'售价',width:120,align:'right'},
			{field:'ProCreatDate',title:'创建日期',width:150},
			{field:'ProCreatTime',title:'创建时间',width:150},
			{field:'ProType',title:'产品类型',width:100},
			{field:'ProCreatUser',title:'创建人',width:100},
			{field:'ProStatus',title:'产品状态',width:100,
				styler:function(value,row,index){
					return value=='已驳回'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'ProductRowId',title:'套餐产品表RowId',width:150,hidden:true},
		]];
	$('#ProDetailsDG').datagrid({
		fit: true,
		border: false,
		striped: true,
		columns:dgColumns,
		pagination: true,
		rownumbers: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect:true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		rowStyler:function(idnex,rowData){
		},
		onDblClickRow:function(index,rowData){
			ok_click(rowData);
		},
		onSelect:function(index,rowData){
			loadCouponOEDetails(rowData.ProductRowId);	
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				loadProductOEDetails(data.rows[0].ProductRowId);
			}	
		}
		
	});	
}
/*
 * 加载优惠券套餐dg数据
 */ 
function loadProDetailsDG(CoupNo,Total){
	var queryParams={
			ClassName:'BILL.PKG.BL.Coupon',
			QueryName:'FindCouponByCode',
			ConCode:CoupNo,
			Total:Total
	}
	$('#ProDetailsDG').datagrid({
		queryParams:queryParams,
		url:$URL
	})
	$('#ProDetailsDG').datagrid('load');		
}
/*
 * 初始化优惠券套餐产品明细grid
 */ 
function initCouponDetails(CoupNo,Total){
	var dgColumns = [[
		{field:'ArcimDesc',title:'医嘱名称',width:120 },
		{field:'ItemPrice',title:'标准单价',width:90,align:'right' },
		{field:'ActualPrice',title:'实售单价',width:90,align:'right' },
		{field:'Qty',title:'数量',width:70,align:'right' },
		{field:'TotalAmt',title:'金额',width:80,align:'right' },
		{field:'SalesAmount',title:'实售金额',width:80,align:'right' },
		{field:'PRODDayNum',title:'限制天数',width:80,align:'right',hidden:true},
		{field:'PRODArcimCode',title:'医嘱编码',width:100,hidden:true},
		{field:'PRODMutex',title:'互斥标识',width:80,align:'right',hidden:true},
		{field:'ArcimRowID',title:'PRODArcimId',width:50,hidden:true},
		{field:'Rowid',title:'Rowid',width:50,hidden:true}
	]];
	$('#couponDetails').datagrid({
		headerCls:'panel-header-gray',
		fit: true,
		border: false,
		striped: true,
		rownumbers: true,
		columns: dgColumns,
		pagination: true
	});		
}
/*
 * 优惠券套餐确认
 */ 
function ok_click(rowData){
	var OrdStr=getParam('ordStr');
	var Total=getValueById('OutTotal');
	var CoupNo = getValueById('CounNo');
	if(OrdStr==''){
		$.messager.alert('提示', "医嘱串不能为空", 'info');
		return;	
	}
	if(CoupNo==''){
		$.messager.alert('提示', "优惠券号不能为空", 'info');
		return;	
	}
	if(Total==''){
		$.messager.alert('提示', "总金额不能为空", 'info');
		return;	
	}
	$.m({
		ClassName: "BILL.PKG.BL.Coupon",
		MethodName: "CounponMatching",
		CoupNo: CoupNo,
		Hosptal:PUBLIC_CONSTANT.SESSION.HOSPID,
		OrdStr:OrdStr,
		Total:Total,
		ProductRowId:rowData.ProductRowId
	}, function(rtn){
		if(rtn=='0'){
			$.messager.alert('提示', "匹配成功", 'info',function(){
				$HUI.dialog("#couponProDetails",'close');
				clear_Click();	
			});
		}else{
			$.messager.alert('提示', "匹配失败:"+rtn, 'info',function(){
				$HUI.dialog("#couponProDetails",'close');
				clear_Click();
				
			});	
		}
	});		
}

/*
 * 优惠券自动匹配相关
 *
 * ---------End----------  
 */
 /*
 * 套餐确认相关
 *
 * ---------Start----------  
 */
 function showCounpConfirmWindow(){
	$('#couponProConfirm').window({
		width:1010,
		height:570,
		title:'客户套餐确认',
		iconCls: "icon-w-list",
	});	
	$('#popPKGInfo').show();
	loadProConfirmDG();
}
/*
 * 加载套餐确认dg数据
 */ 
function loadProConfirmDG(){
	var queryParams={
			ClassName:'BILL.PKG.BL.PatientBill',
			QueryName:'FindProductInfoByPatDr',
			PatDr:GV.PAPMI,
			ProType:'Bill'
	}
	$('#ProConfirmDG').datagrid({
		queryParams:queryParams,
		url:$URL
	})
	$('#ProConfirmDG').datagrid('load');		
}
/*
 * 初始化套餐确认明细dg
 */
function init_ProConfirmDG(){
	var dgColumns = [[
			{field:'ProCode',title:'套餐编码',width:80,
				formatter:function(value, row, index){
					return "<a href='#' \
					onclick='proConfirm_click("+JSON.stringify(row)+")'>\
					"+value+"</a>";
				}
			},
			{field:'ProDesc',title:'套餐名称',width:100},
			{field:'ProRefundStandard',title:'退费标准',width:80},
			{field:'ProCreatDate',title:'创建日期',width:120},
			{field:'ProCreateTime',title:'创建时间',width:120},
			{field:'ProType',title:'套餐类型',width:100},
			{field:'Prolevel',title:'套餐等级',width:100},
			{field:'ProPrice',title:'标准价格',width:100},
			{field:'ProSalesPrice',title:'售价',width:100},
			{field:'ProStatus',title:'套餐状态',width:100},
			{field:'ProUser',title:'创建人',width:150,hidden:true},
			{field:'ProIsshare',title:'是否共享',width:150,hidden:true},
			{field:'ProContractResponsibility',title:'是否包干',width:100,hidden:true},
			{field:'Type',title:'套餐使用类型',width:150,hidden:true},
			{field:'PatProRowId',title:'套餐医嘱表dr',width:150,hidden:true},
			{field:'ProIssellseparately',title:'是否单独售卖',width:150,hidden:true},
			{field:'ProductRowId',title:'ProductRowId',width:150,hidden:true}
		]];
	$('#ProConfirmDG').datagrid({
		headerCls:'panel-header-gray',
		fit: true,
		striped: true,
		rownumbers: true,
		singleSelect:true,
		border:false,
		pagination: true,
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			proConfirm_click(rowData);
		},
		onSelect:function(index,rowData){
			loadProductOEDetails(rowData.PatProRowId);	
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				loadProductOEDetails(data.rows[0].PatProRowId);
			}	
		}
	});	
}
/*
 * 初始化套餐确认  产品明细datagrid
 */
function init_ProdoctOEDetails(){
	var Columns = [[
		{field:'ArcDesc',title:'医嘱项目',width:150},
		{field:'TotalAmount',title:'总金额',width:100,},
		{field:'DiscAmount',title:'折扣金额',width:100,},
		{field:'RemainingQty',title:'剩余数量',width:100,
			styler:function(value,row,index){
				return value>0?'color:green;font-weight:bold':'color:red;font-weight:bold';
			}},
		{field:'PriceperUnit',title:'单价',width:100,},
		{field:'PatshareAmount',title:'自付金额',width:150,},
		{field:'Quantity',title:'购买数量',width:100},
		{field:'PatsharePrice',title:'自付单价',width:150,},
		{field:'DiscPrice',title:'折扣单价',width:100,},
		{field:'ValidstartDate',title:'开始日期',width:150},
		{field:'ValidendDate',title:'结束日期',width:150}
		]];	
	$('#dgEast').datagrid({
		headerCls:'panel-header-gray',
		fit: true,
		border: false,
		striped: true,
		rownumbers: true,
		columns: Columns,
		pagination: true,
		onLoadSuccess: function (data) {
			
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
}
/*
 * 加载优惠券产品明细
 */ 
function loadCouponOEDetails(ProductRowId){
	var queryParams={
			ClassName:'BILL.PKG.BL.ProductDetails',
			QueryName:'QueryProductDetails',
			ProdDr:ProductRowId
	}
	$('#couponDetails').datagrid({
		queryParams:queryParams	,
		url:$URL
	})
	$('#couponDetails').datagrid('load');
}
/*
 * 加载套餐产品明细
 */ 
function loadProductOEDetails(ProductRowId){
	var queryParams={
			ClassName:'BILL.PKG.BL.PatientBill',
			QueryName:'FindPatProductOrderDetails',
			PatProRowId:ProductRowId, 
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			ExpStr:''
	}
	$('#dgEast').datagrid({
		queryParams:queryParams	,
		url:$URL
	})
	$('#dgEast').datagrid('load');
}
/*
 * 套餐确认
 * rowData 套餐确认界面的row
 */ 
function proConfirm_click(rowData){
	var editRows=$('#dg').datagrid('getRows');
	var OrdStr='';
	$.each(editRows, function (index, row) {
			var OrdInfo=row.OEOrdRowID+'^'+row.PackQty;
			if(row.FixFlag!='1'){ //已经折扣的不进行确认
				if(OrdStr=='') OrdStr=OrdInfo;
				else OrdStr=OrdStr+PUBLIC_CONSTANT.SEPARATOR.CH2+OrdInfo;
			}
	});
	if(OrdStr!=''){
		$.m({
			ClassName: "BILL.PKG.BL.Coupon",
			MethodName: "PatProMatching",
			PatProRowId: rowData.PatProRowId,
			OrdStr:OrdStr,
			Hosptal:PUBLIC_CONSTANT.SESSION.HOSPID,
			Guser:PUBLIC_CONSTANT.SESSION.USERID
		}, function(rtn){
			if(rtn.split('^')[0]=='0'){
				$.messager.alert('提示', "确认成功", 'info',function(){
					$HUI.dialog("#couponProConfirm",'close');
					clear_Click();
				});
			}else{
				$.messager.alert('提示', "确认失败:"+rtn, 'info',function(){
					$HUI.dialog("#couponProConfirm",'close');
					clear_Click();
				});	
			}
		});
	}else{
		$.messager.alert('提示', "没有符合的医嘱", 'info');		
	}		
}
 /*
 * 套餐确认相关
 *
 * ---------End----------  
 */


/*
 * 灵活折扣相关
 *
 * ---------Start----------  
 */
function init_DiscReason(){
	PKGLoadDicData('DiscReason','DiscountReason','','combobox');	 
}

/*
 * 通过面板实收金额计算datagrid折扣率
 * value 实收金额
 */
function calDatagridRate(value)
{
	var OutTotal=parseFloat($('#OutTotal').val());
	
	var NoDisAmt=GetPordOutNoDisAmt() //获取套餐外不可打折的金额合计 DingSH 
	             
    if(value<NoDisAmt)
    {
	    
	    $.messager.alert('提示','实收金额不能小于套餐外不可打折金额: '+NoDisAmt.toFixed(2),'info');	
		setDatagridRate(0);
		return;   
	}
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('提示','实收金额不能大于总金额','info');	
		setDatagridRate(0);
		return;
	}
	if ((OutTotal-NoDisAmt)==0)
	{
		 $.messager.alert('提示','没有可打折医嘱 '+NoDisAmt.toFixed(2),'info');	
		 return
		
		
	}
	
	var rate=(value-NoDisAmt)/ (OutTotal-NoDisAmt);
	rate=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}




/*
    获取套餐外不可打折金额
*/
function GetPordOutNoDisAmt()
{
	var total=0.0
	var dgObj=$('#dg').datagrid('getData');
	for(var index=0;index<dgObj.total;index++){
		if((dgObj.rows[index].NoDisFag==0)&& (dgObj.rows[index].ProductFlag!=1))
		{
		
		 var amt=dgObj.rows[index].Amount ;
		 total=total+toNumber(amt)
		 
		}
		
		
		
	}			   
	
	return total 
	
	
}
/*
 * 删除折扣
 */
function dleteFlexDisClick(){
	if(GV.FixFlag!='1'){
		$.messager.alert('提示','没有需要删除的折扣记录','info');
		return;
	}
	$.messager.confirm('提示','是否删除灵活折扣记录？',function(r){
		if(r){
			$.m({
					ClassName: "BILL.PKG.BL.Flexiblediscount",
					MethodName: "FlexiblediscountDelete",
					FixRowIdStr:GV.deleteStr,
				},function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('提示','删除成功','info',function(){
							clear_Click();	
						});
					}else{
						$.messager.alert('提示','删除失败:'+rtn.split('^')[1],'info',function(){
							clear_Click();
						});
					}
				})
				
			}		
		})				
}



/*
 * datagrid折扣比例编辑框回车事件
 */
/*function datagridRateEnter(){
	$('td[field="DisRate"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		if(this.value>1) this.value=1;
	  		$('#dg').datagrid('endEdit',GV.editRowIndex);
  		}
	})
	$('td[field="DisRate"] .datagrid-editable-input').bind('change',function(){
	  		if(this.value>1) this.value=1;
	  		$('#dg').datagrid('endEdit',GV.editRowIndex);
  		
	})
}*/

/*
 * datagrid实收金额编辑框回车事件
 */
/*function datagridAmtEnter(){
	$('td[field="Amt"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		//calcRowRate(this.value);
	  		$('#dg').datagrid('endEdit',GV.editRowIndex);
  		}
	})
	$('td[field="Amt"] .datagrid-editable-input').bind('change',function(){
	  		$('#dg').datagrid('endEdit',GV.editRowIndex);
  		
	})
}*/
/*
 * 根据实收金额计算单条医嘱折扣率
 * amt 单条医嘱实收金额
 */
function calcRowRate(amt, index, rowData){
	var amt=parseFloat(amt);
	var OERDAmt=rowData.Amount;
	if(OERDAmt<amt){
		$.messager.alert('提示','填写金额不能大于医嘱金额','info');
			HISUIDataGrid.setFieldValue('Amt', 0, index, 'dg');	
			HISUIDataGrid.setFieldValue('DisRate', 0, index, 'dg');
		}else{
			var rate=amt/parseFloat(OERDAmt);
			HISUIDataGrid.setFieldValue('DisRate',parseFloat(rate).toFixed(4), index, 'dg');
		}
}
/*
 * 根据单条医嘱折扣率计算实收金额
 * rate 单条医嘱折扣率
 */
function setRowRate(rate,index,rowData){
	var amt=rowData.Amount * rate;
	HISUIDataGrid.setFieldValue('DiscAmt', rate, index, 'dg');	
	HISUIDataGrid.setFieldValue('Amt', parseFloat(amt).toFixed(2), index, 'dg');	
	$('#dg').datagrid('endEdit', GV.editRowIndex);
}

/*
 * 填写datagrid折扣率
 * rate : 折扣率
 */
function setDatagridRate(rate){
	var eachRowobj=$('#dg').datagrid('getData');
	for(var index=0;index<eachRowobj.total;index++){
		rate=parseFloat(rate).toFixed(4);
		if((eachRowobj.rows[index].ProductFlag!=1))
		{
		 
		 
		 
		if  (eachRowobj.rows[index].NoDisFag==1)
		 {
		  var amt=eachRowobj.rows[index].Amount * rate;
		  HISUIDataGrid.setFieldValue('Amt',parseFloat(amt).toFixed(4), index, 'dg');
		  HISUIDataGrid.setFieldValue('DisRate', parseFloat(rate).toFixed(4), index, 'dg');
		 
		 }
		 else
		 {
		  var amt=eachRowobj.rows[index].Amount ;	 
		  HISUIDataGrid.setFieldValue('Amt',parseFloat(amt).toFixed(4), index, 'dg');
		  HISUIDataGrid.setFieldValue('DisRate', (1).toFixed(4), index, 'dg');
			 
		 }
		
		
		  
		
		}
	}	
}
/*
 * 计算datagrid折扣率
 * value 实收金额
 * 根据实收金额和套餐外医嘱金额计算折扣率
 */
function calDatagridRateOld(value){
	var OutTotal=parseFloat($('#OutTotal').val());
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('提示','实收金额不能大于套餐外医嘱金额','info');	
		setDatagridRate(0);
		return;
	}
	var rate=value/OutTotal;
	value=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}
/*
 * 灵活折扣相关
 *
 * ---------End----------  
 */
/*
 * 清空全局变量
 */ 
function clearGlobal(){
	 GV.deleteStr='';
	 GV.FixFlag='';
	 PRODUCTFLAG='';
	 editRowIndex='';
}
/*
 * 设置全局变量
 * productValue : 套餐内/外产品标志
 * flexibleValue ： 灵活折扣标志
 */ 
function setGlobal(row){
	(row.ProductFlag=='1')?GV.PRODUCTFLAG='1':true; //已经确认的不再进行确认
	if(row.FixFlag=='1') {
		if(GV.deleteStr==''){
			GV.deleteStr=row.FixSubRowId;
			GV.FixFlag='1';	
		}else{
			GV.deleteStr=GV.deleteStr+'^'+row.FixSubRowId; //此处拼串避免 删除灵活折扣时再次循环grid
		}
	}
}
/*
 * 校验优惠券是否存在
 */ 
function checkCoupon(){
	$.m({
		ClassName: "BILL.PKG.BL.Coupon",
		MethodName: "GetCouponInfo",
		CouponNo:getValueById('CounNo'),
		},function(rtn){
		switch(rtn){
		case '1': 
			AutoConClick();
			break;
		case '0' : 
			$.messager.alert('提示','优惠券已使用','info',function(){
				setValueById('CounNo','');	
			});
			break;
		case '-1' : 
			$.messager.alert('提示','优惠券不存在','info',function(){
				setValueById('CounNo','');	
			});
			break;
		default:		
	   }
	})		
}


/**
* 医嘱记录单元格编辑
*/
function OrdEditCell(index, field, value) {
	GV.OrdItms.selectRow(index);   //选中设定行
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.OrdItms.editCell({
			index: index,
			field: field
		});
		var ed = GV.OrdItms.getEditor({
				index: index,
				field: field
			});
		if (ed) {
			$(ed.target).focus().select();
		}
		GV.EditIndex = index;
	}
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if (GV.OrdItms.validateRow(GV.EditIndex)) {
		GV.OrdItms.endEdit(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}


/**
* 单元格是否可编辑
* true: 可编辑, false: 不可编辑 ,,
*/
function isCellAllowedEdit(index, field, value) {
	var row = GV.OrdItms.getRows()[index];
	if ((field != "DisRate") && (field != "Amt")) {
	
			return false;
		
	}
	
	if((row.NoDisFag==0)||(row.NoDisFag=="否")){
		return false
		}
	if(row.ProductFlag=='1'||row.ordCateType=='R')	{
		
			return false
		}
	return true;
}

/**
*开始编辑
*/
function OrdBeginEdit(index, row)
 {
     RowDisRateEnter(index, row);
     RowAmtEnter(index, row);
     
}

/**
* 结束编辑
*/
function OrdAfterEdit(index, rowData, changes) {
	GV.OrdItms.endEdit(index);
	GV.EditIndex = undefined;
	//CalcSalesAmt();
}


/**
*数值转换
*/	
function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}

/**
*单元格-根据折扣率计算实收金额
*/
function RowDisRateEnter(index, row)
{
	var ed = GV.OrdItms.getEditor({index: index, field: "DisRate"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowDisRateEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowDisRateEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowDisRateEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var Amount=toNumber(row.Amount)
	 if (newVal=="") return ;
	 if (toNumber(newVal) > 1)
             {
               $.messager.alert('提示', '填写折扣率不能大于 1', 'error',function() {
	           $(ed.target).numberbox("setValue", 1);
				GV.OrdItms.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	              var SalesAmount = toNumber(newVal) *  Amount 
		        	if (Amount <SalesAmount)
		       		 {
			        
			          	 $.messager.alert('提示', '实收金额不能大于医嘱金额：'+Amount, 'error',function() {
			              $(ed.target).numberbox("setValue", 1);
			              GV.OrdItms.endEdit(index);
				          GV.EditIndex = undefined;
				          //calcRowOrdExAmt(index)
			             
			            });
			         }
			         else
			         {
				         
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('Amt', SalesAmount.toFixed(2), index, 'dg');
				         GV.OrdItms.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
				         
				     }
	             }
	
}



/**
*单元格-根据实收金额计算折扣率
*/
function RowAmtEnter(index, row)
{
	var ed = GV.OrdItms.getEditor({index: index, field: "Amt"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowAmtEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowAmtEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowAmtEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var Amount=toNumber(row.Amount)
	if (newVal=="") return ;
	 if (toNumber(newVal) > Amount)
             {
               $.messager.alert('提示', '填写实收金额不能大于医嘱金额', 'error',function() {
	           $(ed.target).numberbox("setValue", Amount);
				GV.OrdItms.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	                     var DisRate = toNumber(newVal) / Amount 
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('DisRate', DisRate.toFixed(4), index, 'dg');
				         GV.OrdItms.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
	             }
	
}
