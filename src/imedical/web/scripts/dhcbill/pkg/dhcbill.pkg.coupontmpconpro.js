/*
 * FileName:	dhcbill.pkg.coupontemplate.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: �Ż�ȯģ��ά��(ѡ��ģ�������Ʒ)
 */
 var ProAmt=0.00;
 var ProNum=0;
 var templateId='';
 var templateCode='';
 var saveFlag=''; //�Ƿ��Ѿ�ά������Ʒ
$(function () {
	PUBLIC_CONSTANT.SESSION.HOSPID=getParam('HOSPITAL'); //Ժ��
	
	init_CouponTmpConProDG();  // ��ʼ��grid

	// ����
	$HUI.linkbutton("#btn-trans", {
		onClick: function () {
			transClick(-1);
		}
	});
	// ɾ��
	$HUI.linkbutton("#btn-return", {
		onClick: function () {
			returnClick(-1);
		}
	});
	// ����
	$HUI.linkbutton("#btn-Save", {
		onClick: function () {
			saveClick();
		}
	});
	// ��ѯ
	$HUI.linkbutton("#btn-Find", {
		onClick: function () {
			loadWestGridData();
		}
	});
	setValueById('ProTotalAmt',parseFloat(ProAmt).toFixed(2));
	setValueById('ProTotalNum',ProNum);
	templateId=getParam('templateId'); // �Ż�ȯID
	templateCode=getParam('templateCode'); // �Ż�ȯ����
	loadEastGridData(); // �����Ѿ���ѡ�Ĳ�Ʒ
	
	init_PackageGroup(); // �ײ���
	// �ؼ��ּ���
	$('#proCode').keydown(function (e) {
		if (e.keyCode == 13) {
			loadWestGridData();
		}
	});	
});
/*
 * ��߼�¼ת�ұ�
 */
function transClick(index){
	if(index>-1){
		$('#dgWest').datagrid('selectRow',index);
	}
	var SelectedRow=$('#dgWest').datagrid('getChecked');
	var SelectedRowLen=SelectedRow.length;
	if (SelectedRowLen>0){
		for (var i=0;i<SelectedRowLen;i++){
			if(transRowChecked(SelectedRow[i])){
				var index=$('#dgWest').datagrid('getRowIndex',SelectedRow[i]);
				$('#dgWest').datagrid('deleteRow',index); 
				$('#dgEast').datagrid('appendRow',SelectedRow[i]);
				ProAmt=ProAmt+parseFloat(SelectedRow[i].PROSalesPrice);
				ProNum++
			}else{
				var index=$('#dgWest').datagrid('getRowIndex',SelectedRow[i]);
				$('#dgWest').datagrid('uncheckRow',index);		
			}
		}	
	}else{
		$.messager.alert('��ʾ','��ѡ��Ҫ�����Ĳ�Ʒ','info');
		return;
		}
	setValueById('ProTotalAmt',parseFloat(ProAmt).toFixed(2));
	setValueById('ProTotalNum',ProNum);
}
/*
 * �ұ߼�¼ת���
 */
function returnClick(index){
	if(index>-1){
		$('#dgEast').datagrid('selectRow',index);
	}
	var SelectedRow=$('#dgEast').datagrid('getChecked');
	var SelectedRowLen=SelectedRow.length;
	if (SelectedRowLen>0){
		for (var i=0;i<SelectedRowLen;i++){
			var index=$('#dgEast').datagrid('getRowIndex',SelectedRow[i]);
			$('#dgEast').datagrid('deleteRow',index); 
			if($('#dgWest').datagrid('getData').total>0) $('#dgWest').datagrid('appendRow',SelectedRow[i]);
			ProAmt=ProAmt-SelectedRow[i].PROSalesPrice;
			ProNum=ProNum-1;
		}	
	}else{
		$.messager.alert('��ʾ','��ѡ��Ҫɾ���Ĳ�Ʒ','info');
		return;
		}
	setValueById('ProTotalAmt',parseFloat(ProAmt).toFixed(2));
	setValueById('ProTotalNum',ProNum);
}
/*
 * ģ���ײ͹���ά�� datagrid
 */
function init_CouponTmpConProDG() {
	var dgColumns = [[
			{field:'PROCode',title:'��Ʒ����',width:100},
			{field:'PROName',title:'��Ʒ����',width:120 },
			{field:'PROSalesPrice',title:'�ۼ�',width:90,align:'right' ,
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}	
			},
			{field:'PROPrice',title:'��׼����',width:90,align:'right' ,
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}},
			{field:'PROMimuamout',title:'����ۼ�',width:90,align:'right' ,
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}},
			{field:'PROStartDate',title:'��Ч����',width:150},
			{field:'PROLevel',title:'�ײ͵ȼ�',width:120},
			{field:'Rowid',title:'Rowid',width:150,hidden:true},
			{field:'NewFlag',title:'NewFlag',width:150,hidden:true}
		]];
	$('#dgWest').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		onBeforeLoad:function(param){

		},
		frozenColumns: [[{title: 'ck', field: 'ck', checkbox: true}]],
		columns: dgColumns,
		onLoadSuccess: function (data) {
			EditIndex = -1;
		},
		onDblClickRow:function(rowIndex, rowData){
			transClick(rowIndex);	
		}
	});
	$('#dgEast').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		frozenColumns: [[{title: 'ck', field: 'ck', checkbox: true}]],
		columns: dgColumns,
		onDblClickRow:function(rowIndex, rowData){
			returnClick(rowIndex);	
		},
		onLoadSuccess:function(data){
			calProAmt(data);
		}
	});
}
function saveClick(){
	try{
		rtn=tkMakeServerCall('BILL.PKG.BL.CouponTemplate','CheckCouponTemplateSend',templateId);
		if(rtn!='0'){
			$.messager.alert('��ʾ','���Ż�ȯ�Ѿ����й�����,�����޸���Ŀ,ֻ���޸��Ż�ȯ״̬��','info');	
			return;	
		}
		var inStr='';
		var SelectedRow=$('#dgEast').datagrid('getRows');
		var SelectedRowLen=SelectedRow.length;
		var ExpStr=PUBLIC_CONSTANT.SESSION.USERID;
		if (SelectedRowLen>0){
			for (var i=0;i<SelectedRowLen;i++){
				if (inStr=='')inStr=SelectedRow[i].Rowid;
				else inStr=inStr+"^"+SelectedRow[i].Rowid;

			}
			$.m({
				ClassName: "BILL.PKG.BL.CouponTemplate",
				MethodName: "CouponTmpConProSave",
				CTPRowId:templateId,
				RowIdStr:inStr,
				ExpStr:ExpStr
			}, function (rtn) {
				if(rtn==0){
					$.messager.alert('��ʾ','����ɹ�','info',function(){
						websys_showModal('close');
					});	
				}else{
					$.messager.alert('��ʾ','����ʧ��'+rtn,'info');	
				}
			});
		}else{
			$.messager.alert('��ʾ','û��Ҫ���������','info');		
		}
	}catch(e){
		$.messager.alert('��ʾ','�����쳣��'+e,'info');	
	}	
}
/*
 * �ײͲ�Ʒ
 */
function init_PackageGroup(){
		$HUI.combobox('#PackageGroup',{
			valueField:'Id',
			textField:'Desc',
			url:$URL,
			defaultFilter:4,
			onSelect:function(data){
				loadWestGridData();		
			},
			onBeforeLoad:function(param){
				param.ClassName='BILL.PKG.BL.PackageGroup';
				param.QueryName='QueryPackageGroup';
				param.ResultSetType='Array';
				param.KeyWords='';
				param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
			}	
		})	
}
function loadWestGridData(){
	var queryParams={
			ClassName:'BILL.PKG.BL.Product',
			QueryName:'QueryProduct',
			KeyWords:getValueById('proCode'),
			Status:'',
			PkgDr:getValueById('PackageGroup'),
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			StDate:'',
			EdDate:'',
			UserDr:'',
			PLevel:'',
			IsIndependentpricing:'',
			Isshare:'',
			Type:''	,
			PdType:'Coupon' 
	}
	$('#dgWest').datagrid({
		queryParams:queryParams,
		url:$URL
	})
	$('#dgWest').datagrid('load');		
}
function loadEastGridData(){
	var queryParams={
			ClassName:'BILL.PKG.BL.CouponTemplate',
			QueryName:'FindCouponProductByCode',
			CTPCode:templateCode,
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	}
	$('#dgEast').datagrid({
		queryParams:queryParams	,
		url:$URL

	})
	$('#dgEast').datagrid('load');		
}
function calProAmt(data){
	ProNum=0;
	ProAmt=0;
	if (data.total>0){
		saveFlag="Y";
		$.each(data.rows, function (index, row) {
			ProAmt=ProAmt+parseFloat(row.PROSalesPrice);
			ProNum=ProNum+1;
		});	
	}
	setValueById('ProTotalAmt',parseFloat(ProAmt).toFixed(2));
	setValueById('ProTotalNum',ProNum);
}
//�Ѿ�ѡ��ҽ���Ƿ������ͬҽ��
function transRowChecked(Row) {

    var SelectedRow = $('#dgEast').datagrid('getRows');
    if (SelectedRow !=null)
    {
    var SelectedRowLen = SelectedRow.length;
    var Flag = true
    
    var ExistInfo = ""
    if (SelectedRowLen > 0) {
        for (var i = 0; i < SelectedRowLen; i++) {
            if (Row.Rowid == SelectedRow[i].Rowid) {
                ExistInfo = ExistInfo + "<br>" + SelectedRow[i].PROName
                Flag = false
            }
        }

        if (!Flag) {
            $.messager.alert('��ʾ', '�Ѿ�������ͬ�Ĳ�Ʒ' + ExistInfo, 'error');

        }
    }
    }
    return Flag
}