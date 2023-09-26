/*
 * FileName:	dhcbill.pkg.coupontemplate.js
 * User:		tangzf
 * Date:		2019-09-20
 * Function:	
 * Description: 灵活折扣
 */
 var GV={
	 editRowIndex:-1,
 	 FixFlag:'', //是否已经进行过折扣 1已经进行过折扣
 	 deleteStr:'' // 要删除的subid
 };
 $(function () {
	//if(!getParam('patNo')||getParam('patNo')==''){return}
	init_dg(); 
	
	init_CalType();
	
	///init_DiscReason();
	
	initLoadGrid();
	
	init_Panel();


});
function init_Panel(){
	// 初始化值
	$("#RegNo").attr("readonly", true); 	
	$("#PatName").attr("readonly", true); 
	$("#TotalAmt").attr("readonly", true); 
	setValueById('RegNo',getParam('patNo'));
	if(getParam('patNo')){
		var PAPMI=tkMakeServerCall("web.DHCOPCashierIF","GetPAPMIByNo",getParam('patNo'),""); 
		var Name=tkMakeServerCall("web.DHCOPCashierIF","GetPatientByRowId",PAPMI,"").split('^')[2]; 
		setValueById('PatName',Name);	
	}

	// 初始化金额
	$("#DiscAmt").keyup(function(e){ 
		if(e.keyCode===13){
			if(getValueById('DiscRate')!=''&&getValueById('DiscRate')!=0){
				$.messager.alert('提示','折扣金额和折扣率不能同时使用','info');
				setValueById('DiscRate',0);
				setValueById('DiscAmt',0);
				setDatagridRate(0);
				return;
			}
			calDatagridRate(this.value);	
		}
	
	})
	$('#DiscAmt').bind('change',function(){
	  		if(getValueById('DiscRate')!=''&&getValueById('DiscRate')!=0){
				setValueById('DiscRate',0);
				setValueById('DiscAmt',0);
				setDatagridRate(0);
				return;
			}
			calDatagridRate(this.value);
  		
	})
	//初始化折扣
	$('#DiscRate').numberbox({
		precision:4	,
		max:1,
		min:0
	})
	$('#DiscRate').bind('change',function(){
	  		if(parseFloat(this.value)>1){
				setValueById('DiscRate',0);
				setDatagridRate(0);
				return;
			}
			if(getValueById('DiscAmt')!=''&&parseFloat(getValueById('DiscAmt'))!=0){
				setValueById('DiscRate',0);
				setValueById('DiscAmt',0);
				setDatagridRate(0);
				return;
			}
			setDatagridRate(this.value);
	})
	$("#DiscRate").keyup(function(e){ 
		if(e.keyCode===13){
			if(this.value>1){
				$.messager.alert('提示','折扣率不能大于1','info');
				setValueById('DiscRate',0);
				setDatagridRate(0);
				return;
			}
			if(getValueById('DiscAmt')!=''&&parseFloat(getValueById('DiscAmt'))!=0){
				$.messager.alert('提示','折扣金额和折扣率不能同时使用','info');
				setValueById('DiscRate',0);
				setValueById('DiscAmt',0);
				setDatagridRate(0);
				return;
			}
		setDatagridRate(this.value);	
		}	
	})
}
/*
 * 折扣原因combobox
 */
function init_DiscReason(){
	PKGLoadDicData('DiscReason','DiscountReason','','combobox');	 
}
/*
 * 平摊方式combobox
 */
function init_CalType(){
	$('#CalType').combobox({
		valueField: 'RowID',
		textField: 'READesc',
		url: $URL,
		editable:false,
		onBeforeLoad:function(param){
			param.ClassName = 'DHCBILLConfig.DHCBILLSysType';
			param.QueryName = 'FindAdmReason';
			param.ResultSetType = 'array';
			param.Code = '';
			param.Desc = '';
		},
		onSelect:function(data){
			init_ArcCat(); // 医嘱分类	
		}
	})	 
}
/*
 * 灵活折扣datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'FixFlag',title:'折扣标志',width:100,
				formatter:function(value,data,row){
					return value=='1'?'已折扣':'未折扣';
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'ArcDesc',title:'医嘱名称',width:200},
			{field:'OrdPatPrice',title:'单价',width:100,align:'right'},
			{field:'PackQty',title:'数量',width:120},
			{field:'PackUOM',title:'单位',width:100},
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
			{field:'DisReason',title:'折扣原因',width:150},
			{field:'OrdPatPrice',title:'自付单价',width:150,align:'right'},
			{field:'OrdDiscPrice',title:'折扣单价',width:150,align:'right'},
			{field:'TArcicDesc',title:'医嘱大类',width:150},
			{field:'ArcCatDesc',title:'医嘱子类',width:150},
			{field:'OEOrdRowID',title:'OEOrdRowID',width:150,hidden:true},
			{field:'FixRowId',title:'FixRowId',width:150,hidden:true},
			{field:'FixSubRowId',title:'FixSubRowId',width:150,hidden:true},
		]];
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		pagination: true,
		rownumbers: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect:true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		rowStyler:function(idnex,rowData){
		
		},
		columns: dgColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			clearGlobal(); // 设置前先清空
			LoadSuccessHandle(data);
			if(GV.FixFlag=='1'){
				disableElement(); //已经进行折扣	
			}
		},
		onSelect:function(index,rowData){
			if(GV.FixFlag=='1'){
				return;	
			}
			datagridEditRow(index);
			datagridAmtEnter();
			datagridRateEnter();
		},
		onAfterEdit:function(rowIndex, rowData, changes){
			if(changes.DisRate){
				setRowRate(changes.DisRate, rowIndex, rowData);
				setValueById('DiscAmt','');
				setValueById('DiscRate','');
			}else if(changes.Amt){	
				calcRowRate(changes.Amt, rowIndex, rowData);
				setValueById('DiscAmt','');
				setValueById('DiscRate','');
				}
			
			GV.editRowIndex=-1;
		}
	});
}
/*
 * 灵活折扣grid
 */
function initLoadGrid(){
	var queryParams={
			ClassName:'BILL.PKG.BL.Flexiblediscount',
			QueryName:'FindFlexiblediscountByAdmStr',
			OrdStr:getParam('ordStr'),
			AdmInsType:getParam('curInsType'),
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			ExpStr:''
			
	}
	loadDataGridStore('dg',queryParams);
}
/*
 * 分类
 */
function init_ArcCat(){
	$('#CalClass').combogrid({  
	    panelWidth:350,   
	    editable:false,
	    panelHeight:260,  
	    idField:'ordcatid',   
	    textField:'ordcat', 
      	fit: true,
     	pagination: false,
      	url:$URL,
      	singleSelect: true,
      	multiple: true,
      	onBeforeLoad:function(param){
			param.ResultSetType = 'array';
			param.ClassName='web.UDHCJFORDCHK';
			param.QueryName='ordcatlookup';
			param.desc='';
		},
	    columns:[[   
	        {field:'ordcatid',title:'分类ID',width:60},  
	        {field:'ordcat',title:'分类描述',width:100}
	    ]],
	    onSelect:function(index,rowData){

		    
		},
		fitColumns: true
	});	
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
 * 删除灵活折扣
 */
$('#btn-Delete').bind('click', function () {
	try{
		if(GV.FixFlag!='1'){
			$.messager.alert('提示','还未进行过灵活折扣','info')
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
						$.messager.alert('提示','删除失败:'+rtn.split('^')[1],'info');
					}
				})
			}		
		})
	}catch(e){
		$.messager.alert('提示异常发生在dhcbill.pkg.coupontemplate.js.#btn-Delete:',e,'info');	
	}				
})
/*
 * 保存灵活折扣
 */
$('#btn-Save').bind('click', function () {
	try{
		if(GV.FixFlag=='1'){
			$.messager.alert('提示','已经进行过灵活折扣','info')
			return;
		}
		if(getValueById('DiscReason')==''){
			$.messager.alert('提示','折扣原因不能为空','info');	
			return;
		}
		$('#dg').datagrid('acceptChanges');
		var editRows=$('#dg').datagrid('getRows');
		var OrdStr='';
		$.each(editRows, function (index, row) {
			if(row.DisRate!=''&&row.DisRate){
				var OrdPatPrice=parseFloat(row.OrdPatPrice)*parseFloat(row.DisRate); //每条医嘱的自付单价
				alert("OrdPatPrice="+OrdPatPrice)
				var OrdDiscPrice=row.OrdPatPrice-OrdPatPrice;					// 每条医嘱的折扣单价
				if(!row.Amt){
					row.Amt=0; //不填写实收金额时要求传0	
				}
				var OrdInfo=row.OEOrdRowID+'^'+row.OrdPatPrice+'^'+OrdDiscPrice+'^'+OrdPatPrice+'^'+row.DisRate+'^'+formatAmt(row.Amt)+"^"+row.PackQty;
				if(OrdStr=='') OrdStr=OrdInfo;
				else OrdStr=OrdInfo+'$'+OrdStr;
			}
		});
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
				Acount:getValueById('TotalAmt'), 
				DiscRate:getValueById('DiscRate'), 
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
					$.messager.alert('提示','保存失败:'+rtn.split('^')[1],'info');
				}
			})
	}catch(e){
		$.messager.alert('提示',e,'info');	
	}

});
/*
 * 计算 医嘱总金额 & 设置全局变量
 */
function LoadSuccessHandle(Rowobj){
	var amt=0;
	$.each(Rowobj.rows, function (index, row) {
			amt = parseFloat(amt) + parseFloat(row.Amount);
			setGlobal(row);
		});
	setValueById('TotalAmt',parseFloat(amt).toFixed(2));
}

/*
 * datagrid折扣比例编辑框回车事件
 */
function datagridRateEnter(){
	$('td[field="DisRate"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		if(this.value>1) this.value=1;
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
  		}
	})
	$('td[field="DisRate"] .datagrid-editable-input').bind('change',function(){
	  		if(this.value>1) this.value=1;
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
  		
	})
}
/*
 * datagrid实收金额编辑框回车事件
 */
function datagridAmtEnter(){
	$('td[field="Amt"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
  		}
	})
	$('td[field="Amt"] .datagrid-editable-input').bind('change',function(){
	  		//$('#dg').datagrid('endEdit',GV.editRowIndex);
  		
	})
}
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
	HISUIDataGrid.setFieldValue('OutDiscAmt', rate, index, 'dg');	
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
		HISUIDataGrid.setFieldValue('DisRate', parseFloat(rate).toFixed(4), index, 'dg');
		var amt=eachRowobj.rows[index].Amount * rate;
		HISUIDataGrid.setFieldValue('Amt',parseFloat(amt).toFixed(4), index, 'dg');
	}	
}
/*
 * 通过面板实收金额计算datagrid折扣率
 * value 实收金额
 */
function calDatagridRate(value){
	var OutTotal=parseFloat($('#TotalAmt').val());
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('提示','实收金额不能大于总金额','info');	
		setDatagridRate(0);
		return;
	}
	var rate=value/OutTotal;
	value=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}
 /*
 * datagrid 开始新一行编辑并结束上一行编辑
 * index 需要编辑的行号
 */ 
function datagridEditRow(index){
	if(GV.editRowIndex!=-1){
		$('#dg').datagrid('endEdit',GV.editRowIndex);	
	}		
	GV.editRowIndex=index;
	$('#dg').datagrid('beginEdit',GV.editRowIndex);	
}
 /*
 * 禁用(已经折扣的)
 */ 
function disableElement(){
	$.messager.alert('提示','已经进行过折扣','info');
	$("#DiscRate").attr("disabled", true); 	
	$("#DiscAmt").attr("disabled", true); 	
}
/*
 * 清空全局变量
 */ 
function clearGlobal(){
	 GV.deleteStr='';
	 GV.FixFlag='';
	 editRowIndex='-1';
}
/*
 * 设置全局变量
 * productValue : 套餐内/外产品标志
 * flexibleValue ： 灵活折扣标志
 */ 
function setGlobal(row){
	if(row.FixFlag=='1') {
		if(GV.deleteStr==''){
			GV.deleteStr=row.FixSubRowId;
			GV.FixFlag='1';	
		}else{
			GV.deleteStr=GV.deleteStr+'^'+row.FixSubRowId; //此处拼串避免 删除灵活折扣时再次循环grid
		}
	}
}
