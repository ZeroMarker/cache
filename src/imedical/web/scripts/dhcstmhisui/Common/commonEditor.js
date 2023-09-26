// 名称: 物资combogrid Editor
// 描述: 公共editor
// 编写者：XuChao
// 编写日期: 2018.04.27
InciEditor=function(HandlerParams,SelectRow){
	var cbg=null; //combogrid this;
	function LoadData(q,obj){
		var BarCodeInfo=$.cm({
			ClassName: 'web.DHCSTMHUI.DHCUDI',
			MethodName: 'UDIInfo',
			Code:q,
			Params:JSON.stringify(addSessionParams(HandlerParams()))
		},false);
		if(BarCodeInfo.Inci){
			var _options=jQuery.extend(true,{},{BarCode:BarCodeInfo.InciBarCode},addSessionParams(HandlerParams()));
			var Params=JSON.stringify(_options)
			$.cm({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetPhaOrderItemInfo',
				StrParam:Params,
				page:1,
				rows:1,
				q:""
			},function(jsonData){
				if(jsonData.rows.length==0){return};
				obj.combogrid("setValue",jsonData.rows[0].InciDesc);
				obj.combogrid('hidePanel');
				///"OrgBarCode^InciBarCode^Inci^Incib^BatchNo^ExpDate^ProduceDate^SerialNo"
				var row=jQuery.extend(true,{},jsonData.rows[0],BarCodeInfo);
				SelectRow(row);
				});
			}
		else{
			var queryParams = new Object();
			queryParams.ClassName ='web.DHCSTMHUI.Util.DrugUtil';
			queryParams.MethodName ='GetPhaOrderItemInfo';
			queryParams.q=q;
			var opts = obj.combogrid("grid").datagrid("options");
			opts.url = $URL;
			obj.combogrid("grid").datagrid('load', queryParams);
			obj.combogrid("setValue",q);
		}
	};
	return {
		type:'combogrid',
		options:{
			url:$URL,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetPhaOrderItemInfo',
				StrParam:''
			},
			EnterFun: LoadData,		//回车时,优先判断是否执行的方法
			required: true,
			//delay: 500,
			panelHeight: Math.max(200, $(window).height() * 0.5),		//使用window高度的1/2,这样不管是向下显示还是向上显示,都有足够的空间.
			panelWidth : 850,
			mode: 'remote',
			idField : "InciDr",
			textField : "InciDesc",
			pagination : true,//是否分页
			rownumbers: true,//序号
			collapsible: false,//是否可折叠的
			fit: true,  //自动大小
			pageSize: 20,//每页显示的记录条数，默认为10
			pageList: [10,15,20],//可以设置每页记录条数的列表
			columns:[[
				{field:'InciCode',title:'代码',width:120},
				{field:'InciDesc',title:'名称',width:150},
	 			{field:'InciDr',title:'InciDr',width:60,hidden:true},
				{field:'Spec',title:'规格',width:100},
				{field:'Model',title:'型号',width:100},
				{field:'Brand',title:'品牌',width:100},
				{field:'Manfdr',title:'厂商Id',width:100,hidden:true},
				{field:'ManfName',title:'厂商',width:60},
				{field:'HVFlag',title:'高值',width:40},
				{field:'InciItem',title:'InciItem',width:60,hidden:true},
				{field:'PUomDr',title:'入库单位Id',width:100,hidden:true},
				{field:'PUomDesc',title:'入库单位',width:60},
				{field:'PRp',title:'进价（入库单位）',width:100},
				{field:'PSp',title:'售价（入库单位）',width:60},
				{field:'PUomQty',title:'数量（入库单位）',width:100},
				{field:'BUomDr',title:'基本单位Id',width:100,hidden:true},
				{field:'BUomDesc',title:'基本单位',width:60},
				{field:'BRp',title:'进价（基本单位）',width:100},
				{field:'BSp',title:'售价（基本单位）',width:60},
				{field:'BUomQty',title:'数量（基本单位）',width:100},
				{field:'BillUomDr',title:'计价单位Id',width:100,hidden:true},
				{field:'BillUomDesc',title:'计价单位',width:60},
				{field:'BillRp',title:'进价（计价单位）',width:100},
				{field:'BillSp',title:'售价（计价单位）',width:60},
				{field:'BillUomQty',title:'数量（计价单位）',width:100},
				{field:'NotUseFlag',title:'不可用标志',width:60,formatter:function(value){
				if(value==0)
				return '否';
				else
				return '是';}
				},
				{field:'ProvLoc',title:'供货科室',width:100},
				{field:'Remarks',title:'备注',width:60},
				{field:'ARCDesc',title:'医嘱名称',width:100},
				{field:'ZeroStkFlag',title:'零库存标志',width:60},
				{field:'PbRp',title:'招标进价',width:100},
				{field:'CertNo',title:'注册证号',width:100},
				{field:'CertExpDate',title:'注册证效期',width:60},
				{field:'ReqPuomQty',width:60,hidden:true},
				{field:'ProvLocId',width:60,hidden:true},
				{field:'PFac',width:60,hidden:true},
				{field:'BatchReq',width:60,hidden:true},
				{field:'ExpReq',width:60,hidden:true}
			]],
			onClickRow:function(index, row){
				cbg.combogrid("setValue",row.InciDesc);
				SelectRow(row);
			},
			onShowPanel:function(){
				cbg = $(this);
			},
			onBeforeLoad:function(param){
				if(isEmpty(param.q)){return false};
				var Params=JSON.stringify(addSessionParams(HandlerParams()))
				param.StrParam=Params;
			},
			onLoadSuccess: function(data){
				if(data.rows.length > 0){
					$(this).combogrid('grid').datagrid('selectRow', 0);
				}
			},
			keyHandler:{
				up: function () {
					//取得选中行
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						//取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						//向上移动到第一行为止
						if (index > 0) {
							$(this).combogrid('grid').datagrid('selectRow', index - 1);
						}else{
							var rows = $(this).combogrid('grid').datagrid('getRows');
							$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
						}
					} else {
						var rows = $(this).combogrid('grid').datagrid('getRows');
						if(rows.length>0){
							$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
						}
					}
				},
				down: function () {
					//取得选中行
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						//取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						//向下移动到当页最后一行为止
						if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
							$(this).combogrid('grid').datagrid('selectRow', index + 1);
						}else{
							$(this).combogrid('grid').datagrid('selectRow', 0);
						}
					} else {
						var rows = $(this).combogrid('grid').datagrid('getRows');
						if(rows.length>0){
							$(this).combogrid('grid').datagrid('selectRow', 0);
						}
					}
				},
				left: function () {
					return false;
				},
				right: function () {
					return false;
				},
				enter: function () {
					//文本框的内容为选中行的的字段内容
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						$(this).combogrid("setValue",selected.InciDesc);
						$(this).combogrid('hidePanel');
						SelectRow(selected);
					}
				},
				query: function(q){
					$(this).combogrid('grid').datagrid('clearSelections');
					if(!isEmpty($(this).combogrid('options')['EnterFun'])){
						//配置了EnterFun函数的,不进行自动加载
						return false;
					}
					
					var object=new Object();
					object=$(this);
					if (this.AutoSearchTimeOut) {
						window.clearTimeout(this.AutoSearchTimeOut)
						this.AutoSearchTimeOut=window.setTimeout(function(){ LoadData(q,object);},400);
					}else{
						this.AutoSearchTimeOut=window.setTimeout(function(){ LoadData(q,object);},400);
					}
					$(this).combogrid("setValue",q);
				}
			}
		}
	}
}

// 名称: 物资combogrid Editor
// 描述: 公共editor Inclb
// 编写者：XuChao
// 编写日期: 2018.05.30
InclbEditor=function(HandlerParams,SelectRow){
	var cbg=null; //combogrid this;
	function LoadData(q,obj){
		var queryParams = new Object();
		queryParams.ClassName ='web.DHCSTMHUI.DHCINGdRet';
		queryParams.QueryName ='GdRecItmToRet';
		queryParams.q=q;
		var opts = obj.combogrid("grid").datagrid("options");
		opts.url = $URL;
		obj.combogrid("grid").datagrid('load', queryParams);
	};
	return {
		type:'combogrid',
		options:{
			url:$URL,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				QueryName: 'GdRecItmToRet',
				Params:''
			},
			//required: true,
			delay: 500,
			panelHeight: Math.max(260, $(window).height() * 0.5),
			panelWidth : 850,
			mode: 'remote',
			idField : "Ingri",
			textField : "Description",
			pagination : true,//是否分页
			rownumbers: true,//序号
			collapsible: false,//是否可折叠的
			fit: true,  //自动大小
			pageSize: 10,//每页显示的记录条数，默认为10
			pageList: [10,15],//可以设置每页记录条数的列表
			columns:[[
				{field:'Code',title:'代码',width:120},
				{field:'Description',title:'名称',width:150},
				{field:'Inci',title:'Inci',width:60,hidden:true},
				{field:'ManfName',title:'厂商',width:120},
				{field:'BatNo',title:'批号',width:100},
				{field:'ExpDate',title:'效期',width:100},
				{field:'Ingri',title:'Ingri',width:60,hidden:true},
				{field:'Inclb',title:'Inclb',width:100,hidden:true},
				{field:'RecQty',title:'入库数量',width:60},
				{field:'IDate',title:'入库时间',width:100},
				{field:'StkQty',title:'库存数量',width:100},
				{field:'Uom',title:'单位Id',width:100,hidden:true},
				{field:'UomDesc',title:'单位',width:60},
				{field:'Rp',title:'进价',width:100},
				{field:'Sp',title:'售价',width:60},
				{field:'InvNo',title:'发票号',width:100},
				{field:'InvDate',title:'发票日期',width:60},
				{field:'InvAmt',title:'发票金额',width:100},
				{field:'VendorDesc',title:'供应商',width:100},
				{field:'ConFac',title:'转换系数',width:100},
				{field:'SpecDesc',title:'具体规格',width:100}
			]],
			onClickRow:function(index, row){
				cbg.combogrid("setValue",row.InciDesc);
				SelectRow(row);
			},
			onShowPanel:function(){
				cbg = $(this);
			},
			onBeforeLoad:function(param){
				var Params=JSON.stringify(addSessionParams(HandlerParams()))
				param.Params=Params;
			},
			keyHandler:{
				up: function () {
					//取得选中行
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						//取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						//向上移动到第一行为止
						if (index > 0) {
							$(this).combogrid('grid').datagrid('selectRow', index - 1);
						}else{
							var rows = $(this).combogrid('grid').datagrid('getRows');
							$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
						}
					} else {
						var rows = $(this).combogrid('grid').datagrid('getRows');
						$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
					}
				 },
				down: function () {
					//取得选中行
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						//取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						//向下移动到当页最后一行为止
						if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
							$(this).combogrid('grid').datagrid('selectRow', index + 1);
						}else{
							$(this).combogrid('grid').datagrid('selectRow', 0);
						}
					} else {
						$(this).combogrid('grid').datagrid('selectRow', 0);
					}
				},
				left: function () {
					return false;
				},
				right: function () {
					return false;
				},
				enter: function () {
				  //文本框的内容为选中行的的字段内容
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						$(this).combogrid("setValue",selected.InciDesc);
						SelectRow(selected);
					}
					//选中后让下拉表格消失
					$(this).combogrid('hidePanel');
					$(this).focus();
				},
				 query:function(q){
					var object=new Object();
					object=$(this)
					if (this.AutoSearchTimeOut) {
						window.clearTimeout(this.AutoSearchTimeOut)
						this.AutoSearchTimeOut=window.setTimeout(function(){ LoadData(q,object);},400);
					}else{
						this.AutoSearchTimeOut=window.setTimeout(function(){ LoadData(q,object);},400);
					}
					$(this).combogrid("setValue",q);
				}
			}
		}
	}
}
/*
 * Incilookup的配置
 * @HandlerParams  列表参数
 * @_this 自身Id
 * @change InciId
 * 使用示例代码
 *$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
 */
var InciLookUpOp=function(HandlerParams,_this,change){
	$(_this).on('input',function(e){
		$(change).val("");
	});
	return {
		url:$URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam:''
		},
		mode:'remote',
		idField:'InciDr',
		textField:'InciDesc',
		valueType: 'text',		//2020-06-04 考虑到原有模式,按text取值
		fitColumns: true,
		columnsLoader:function(){
			return [[
				{field:'InciCode',title:'物资代码',width:100},
				{field:'InciDesc',title:'物资名称',width:180},
				{field:'Spec',title:'规格',width:100},
				{field:'InciDr',title:'ID',width:50}
			]];
		},
		pagination:true,
		panelWidth:430,
		onBeforeLoad:function(param){
			var Params=JSON.stringify(addSessionParams(HandlerParams()))
			param.StrParam=Params;
		},
		onSelect:function(index, row){
			$(change).val(row.InciDr);
		}
	}
}