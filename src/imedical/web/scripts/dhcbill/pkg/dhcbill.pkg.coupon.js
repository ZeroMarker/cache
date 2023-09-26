/*
 * FileName:	dhcbill.pkg.coupon.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: �Ż�ȯ����
 */
 $(function () {

	init_East();
	
	init_westGrid();
	
	$HUI.linkbutton("#btn-Send", {
		onClick: function () {
			sendClick();
		}
	});
	// ����numberbox 
	$('#sendNum').keydown(function (e) {
		if (e.keyCode == 13) {
			setNo(this.value);
		}
	});	
	$('#sendNum').bind('change ',function(){
		setNo(this.value);	
	});	
	// ����numberbox 
	setValueById('startDate',getDefStDate(-31));
	setValueById('endDate',getDefStDate(0));
	init_couponCombobox();
});
// ��ʼ��east grid
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
			{field:'CPNCtDesc',title:'�Ż�ȯģ��',width:150},
			{field:'CPNCustName',title:'�ͻ�����',width:150 },
			{field:'CPNNo',title:'ȯ��',width:150},
			{field:'CPNStatus',title:'״̬',width:150,
				styler:function(value,row,index){
					return value=='��Ч'?'color:green;font-weight:bold':'color:red;font-weight:bold'
				}
			
			},
			{field:'CPNCreatDate',title:'��������',width:150},
			{field:'CPNCreatTime',title:'����ʱ��',width:150},
			{field:'CPNServname',title:'�ͷ�����',width:150},
			{field:'CPNUpdateDate',title:'��������',width:150},
			{field:'CPNUpdateTime',title:'����ʱ��',width:150}

			]],
		onLoadSuccess:function(data){
			checkNo(data);		
		}
	})
}
// ����

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
				$.messager.alert('��ʾ','���ųɹ�','info');	
				loadEastDatagrid();
			}else{
				$.messager.alert('��ʾ','����ʧ��','info');		
			}
	});	
}

// ��ʼ�� west grid
function init_westGrid(){
	var dgColumns = [[
			{field:'PROCode',title:'��Ʒ����',width:100},
			{field:'PROName',title:'��Ʒ����',width:120 },
			{field:'PROSalesPrice',title:'�ۼ�',width:90,align:'right' ,
				formatter:function(value){
					return formatAmt(value);	
				}
			},
			{field:'PROPrice',title:'��׼�۸�',width:90,align:'right',
				formatter:function(value){
					return formatAmt(value);	
				}},
			{field:'PROMimuamout',title:'����ۼ�',width:90,align:'right',
				formatter:function(value){
					return formatAmt(value);	
				}
			},
			{field:'PROStartDate',title:'��Ч����',width:150},
			{field:'PROLevel',title:'�ײ͵ȼ�',width:120},
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
// ����west grid
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
// �����ܽ��
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
// ��ʼ���Ż�ȯ������
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
// ���� Eastgrid
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
// Ĭ�Ͽ�ʼ����Ϊ�ϴη���ĩβ��
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
// ���������Ϳ�ʼ���� �����������
function setNo(num){
	var startNo=getValueById('startNo');
	if(startNo==""){
		$.messager.alert('��ʾ','��ʼ���벻��Ϊ��','info');	
		return;
	}
	var endNo=parseFloat(startNo)+parseFloat(num);
	setValueById('endNo',endNo);
	
}
// �ж��Ƿ��ظ�����
function checkRepeatNo(){
	var startNo=getValueById('startNo');
	var endNo=getValueById('endNo');
	if(getValueById('couponCode')==''){
		$.messager.alert('��ʾ','����ѡ���Ż�ȯ��ģ��','info');
		return ;
	}
	var leftDGData=$('#ProTable').datagrid('getData');
	if(leftDGData.rows.length<1){
		$.messager.alert('��ʾ','�Ż�ȯģ��δά���ײͲ�Ʒ','info');
		return ;
	}
	if(startNo==''||endNo==''){
		$.messager.alert('��ʾ','��ʼ�����������벻��Ϊ��','info');
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
				$.messager.alert('��ʾ','�Ŷ��д����ظ�����'+rtn,'info');
				return ;
			}else{
				saveInfo(); // ���ظ����ܽ��з���
			}
	});
	
}
// �����Ż�ȯģ��combogrid
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
// Ժ��combogridѡ���¼�
function selectHospCombHandle(){
	loadCouponTemplate();
	LoadProDatagrid();
	loadEastDatagrid();
}