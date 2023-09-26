/*
 * FileName:	dhcbill.pkg.coupontemplate.js
 * User:		tangzf
 * Date:		2019-09-20
 * Function:	
 * Description: ����ۿ�
 */
 var GV={
	 editRowIndex:-1,
 	 FixFlag:'', //�Ƿ��Ѿ����й��ۿ� 1�Ѿ����й��ۿ�
 	 deleteStr:'' // Ҫɾ����subid
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
	// ��ʼ��ֵ
	$("#RegNo").attr("readonly", true); 	
	$("#PatName").attr("readonly", true); 
	$("#TotalAmt").attr("readonly", true); 
	setValueById('RegNo',getParam('patNo'));
	if(getParam('patNo')){
		var PAPMI=tkMakeServerCall("web.DHCOPCashierIF","GetPAPMIByNo",getParam('patNo'),""); 
		var Name=tkMakeServerCall("web.DHCOPCashierIF","GetPatientByRowId",PAPMI,"").split('^')[2]; 
		setValueById('PatName',Name);	
	}

	// ��ʼ�����
	$("#DiscAmt").keyup(function(e){ 
		if(e.keyCode===13){
			if(getValueById('DiscRate')!=''&&getValueById('DiscRate')!=0){
				$.messager.alert('��ʾ','�ۿ۽����ۿ��ʲ���ͬʱʹ��','info');
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
	//��ʼ���ۿ�
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
				$.messager.alert('��ʾ','�ۿ��ʲ��ܴ���1','info');
				setValueById('DiscRate',0);
				setDatagridRate(0);
				return;
			}
			if(getValueById('DiscAmt')!=''&&parseFloat(getValueById('DiscAmt'))!=0){
				$.messager.alert('��ʾ','�ۿ۽����ۿ��ʲ���ͬʱʹ��','info');
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
 * �ۿ�ԭ��combobox
 */
function init_DiscReason(){
	PKGLoadDicData('DiscReason','DiscountReason','','combobox');	 
}
/*
 * ƽ̯��ʽcombobox
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
			init_ArcCat(); // ҽ������	
		}
	})	 
}
/*
 * ����ۿ�datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'FixFlag',title:'�ۿ۱�־',width:100,
				formatter:function(value,data,row){
					return value=='1'?'���ۿ�':'δ�ۿ�';
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'ArcDesc',title:'ҽ������',width:200},
			{field:'OrdPatPrice',title:'����',width:100,align:'right'},
			{field:'PackQty',title:'����',width:120},
			{field:'PackUOM',title:'��λ',width:100},
			{field:'Amount',title:'���',width:100,align:'right'},
			{field:'DisRate',title:'�ۿ���',width:150,
				editor:{
					type:'numberbox',
					options:{
						precision:4	,
						max:1,
						min:0		
					}

			}},
			{field:'Amt',title:'ʵ�ս��',width:150 ,align:'right',
				editor:{
					type:'numberbox',
					options:{
						precision:4	,
						min:0	
					}
				}
			},
			{field:'DisReason',title:'�ۿ�ԭ��',width:150},
			{field:'OrdPatPrice',title:'�Ը�����',width:150,align:'right'},
			{field:'OrdDiscPrice',title:'�ۿ۵���',width:150,align:'right'},
			{field:'TArcicDesc',title:'ҽ������',width:150},
			{field:'ArcCatDesc',title:'ҽ������',width:150},
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
			clearGlobal(); // ����ǰ�����
			LoadSuccessHandle(data);
			if(GV.FixFlag=='1'){
				disableElement(); //�Ѿ������ۿ�	
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
 * ����ۿ�grid
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
 * ����
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
	        {field:'ordcatid',title:'����ID',width:60},  
	        {field:'ordcat',title:'��������',width:100}
	    ]],
	    onSelect:function(index,rowData){

		    
		},
		fitColumns: true
	});	
}
/*
 * ����
 */
$('#btn-Clear').bind('click', function () {
	clear_Click();
})
function clear_Click(){
	window.location.reload(true);
}
/*
 * ɾ������ۿ�
 */
$('#btn-Delete').bind('click', function () {
	try{
		if(GV.FixFlag!='1'){
			$.messager.alert('��ʾ','��δ���й�����ۿ�','info')
			return;
		}
		$.messager.confirm('��ʾ','�Ƿ�ɾ������ۿۼ�¼��',function(r){
			if(r){
				$.m({
					ClassName: "BILL.PKG.BL.Flexiblediscount",
					MethodName: "FlexiblediscountDelete",
					FixRowIdStr:GV.deleteStr,
				},function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('��ʾ','ɾ���ɹ�','info',function(){
							clear_Click();	
						});
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��:'+rtn.split('^')[1],'info');
					}
				})
			}		
		})
	}catch(e){
		$.messager.alert('��ʾ�쳣������dhcbill.pkg.coupontemplate.js.#btn-Delete:',e,'info');	
	}				
})
/*
 * ��������ۿ�
 */
$('#btn-Save').bind('click', function () {
	try{
		if(GV.FixFlag=='1'){
			$.messager.alert('��ʾ','�Ѿ����й�����ۿ�','info')
			return;
		}
		if(getValueById('DiscReason')==''){
			$.messager.alert('��ʾ','�ۿ�ԭ����Ϊ��','info');	
			return;
		}
		$('#dg').datagrid('acceptChanges');
		var editRows=$('#dg').datagrid('getRows');
		var OrdStr='';
		$.each(editRows, function (index, row) {
			if(row.DisRate!=''&&row.DisRate){
				var OrdPatPrice=parseFloat(row.OrdPatPrice)*parseFloat(row.DisRate); //ÿ��ҽ�����Ը�����
				alert("OrdPatPrice="+OrdPatPrice)
				var OrdDiscPrice=row.OrdPatPrice-OrdPatPrice;					// ÿ��ҽ�����ۿ۵���
				if(!row.Amt){
					row.Amt=0; //����дʵ�ս��ʱҪ��0	
				}
				var OrdInfo=row.OEOrdRowID+'^'+row.OrdPatPrice+'^'+OrdDiscPrice+'^'+OrdPatPrice+'^'+row.DisRate+'^'+formatAmt(row.Amt)+"^"+row.PackQty;
				if(OrdStr=='') OrdStr=OrdInfo;
				else OrdStr=OrdInfo+'$'+OrdStr;
			}
		});
		if(OrdStr==''){
			$.messager.alert('��ʾ','û�б����ҽ��','info');	
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
					$.messager.alert('��ʾ','����ɹ�','info',function(){
						clear_Click();	
					});
				}else{
					$.messager.alert('��ʾ','����ʧ��:'+rtn.split('^')[1],'info');
				}
			})
	}catch(e){
		$.messager.alert('��ʾ',e,'info');	
	}

});
/*
 * ���� ҽ���ܽ�� & ����ȫ�ֱ���
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
 * datagrid�ۿ۱����༭��س��¼�
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
 * datagridʵ�ս��༭��س��¼�
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
 * ����ʵ�ս����㵥��ҽ���ۿ���
 * amt ����ҽ��ʵ�ս��
 */
function calcRowRate(amt, index, rowData){
	var amt=parseFloat(amt);
	var OERDAmt=rowData.Amount;
	if(OERDAmt<amt){
		$.messager.alert('��ʾ','��д���ܴ���ҽ�����','info');
			HISUIDataGrid.setFieldValue('Amt', 0, index, 'dg');	
			HISUIDataGrid.setFieldValue('DisRate', 0, index, 'dg');
		}else{
			var rate=amt/parseFloat(OERDAmt);
			HISUIDataGrid.setFieldValue('DisRate',parseFloat(rate).toFixed(4), index, 'dg');
		}
}
/*
 * ���ݵ���ҽ���ۿ��ʼ���ʵ�ս��
 * rate ����ҽ���ۿ���
 */
function setRowRate(rate,index,rowData){
	var amt=rowData.Amount * rate;
	HISUIDataGrid.setFieldValue('OutDiscAmt', rate, index, 'dg');	
	HISUIDataGrid.setFieldValue('Amt', parseFloat(amt).toFixed(2), index, 'dg');	
	$('#dg').datagrid('endEdit', GV.editRowIndex);
}

/*
 * ��дdatagrid�ۿ���
 * rate : �ۿ���
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
 * ͨ�����ʵ�ս�����datagrid�ۿ���
 * value ʵ�ս��
 */
function calDatagridRate(value){
	var OutTotal=parseFloat($('#TotalAmt').val());
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('��ʾ','ʵ�ս��ܴ����ܽ��','info');	
		setDatagridRate(0);
		return;
	}
	var rate=value/OutTotal;
	value=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}
 /*
 * datagrid ��ʼ��һ�б༭��������һ�б༭
 * index ��Ҫ�༭���к�
 */ 
function datagridEditRow(index){
	if(GV.editRowIndex!=-1){
		$('#dg').datagrid('endEdit',GV.editRowIndex);	
	}		
	GV.editRowIndex=index;
	$('#dg').datagrid('beginEdit',GV.editRowIndex);	
}
 /*
 * ����(�Ѿ��ۿ۵�)
 */ 
function disableElement(){
	$.messager.alert('��ʾ','�Ѿ����й��ۿ�','info');
	$("#DiscRate").attr("disabled", true); 	
	$("#DiscAmt").attr("disabled", true); 	
}
/*
 * ���ȫ�ֱ���
 */ 
function clearGlobal(){
	 GV.deleteStr='';
	 GV.FixFlag='';
	 editRowIndex='-1';
}
/*
 * ����ȫ�ֱ���
 * productValue : �ײ���/���Ʒ��־
 * flexibleValue �� ����ۿ۱�־
 */ 
function setGlobal(row){
	if(row.FixFlag=='1') {
		if(GV.deleteStr==''){
			GV.deleteStr=row.FixSubRowId;
			GV.FixFlag='1';	
		}else{
			GV.deleteStr=GV.deleteStr+'^'+row.FixSubRowId; //�˴�ƴ������ ɾ������ۿ�ʱ�ٴ�ѭ��grid
		}
	}
}
