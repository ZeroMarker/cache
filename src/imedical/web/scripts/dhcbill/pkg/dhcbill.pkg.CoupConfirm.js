/*
 * FileName:	dhcbill.pkg.CoupConfirm.js
 * User:		TianZJ
 * Date:		2019-09-29
 * Function:	
 * Description: �Ż�ȯ�ײ���ϸȷ��
 */
 $(function () {
	init_URL();
	init_Datagrid();
});
function init_URL(){
	 setValueById('CounNo', getParam('CoupNo'));
	 setValueById('Total', getParam('Total'));
}
function init_Datagrid(){
	$HUI.datagrid("#CounProduct", {
			border: false,
			fit: true,
			singleSelect: true,
			rownumbers: true,
			pagination: true,
			url:$URL,
			columns: [[
				{field:'ProCode',title:'��Ʒ����',width:150},
				{field:'ProDesc',title:'��Ʒ����',width:150},
				{field:'ProPrice',title:'��׼���',width:150},
				{field:'ProSalaPrice',title:'���۽��',width:150},
				{field:'ProStatus',title:'��Ʒ״̬',width:150},
				{field:'ProCreatDate',title:'��������',width:150},
				
				{field:'ProCreatTime',title:'����ʱ��',width:150},
				{field:'ProCreatUser',title:'������',width:150},
				{field:'ProType',title:'��Ʒ����',width:150}
				
				]],
			onLoadSuccess:function(data){
				//checkNo(data);		
			},
			onBeforeLoad:function(param){
	            param.ClassName = 'BILL.PKG.BL.Coupon';
	            param.QueryName = 'FindCouponByCode';
	            param.ConCode = getParam('CounNo');
	            param.Total = getParam('Total');
            },
            onLoadError:function(e){
	            alert('e'+e)
	            }
		});	
}
