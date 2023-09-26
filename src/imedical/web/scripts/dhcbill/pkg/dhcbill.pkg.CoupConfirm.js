/*
 * FileName:	dhcbill.pkg.CoupConfirm.js
 * User:		TianZJ
 * Date:		2019-09-29
 * Function:	
 * Description: 优惠券套餐明细确认
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
				{field:'ProCode',title:'产品编码',width:150},
				{field:'ProDesc',title:'产品名称',width:150},
				{field:'ProPrice',title:'标准金额',width:150},
				{field:'ProSalaPrice',title:'销售金额',width:150},
				{field:'ProStatus',title:'产品状态',width:150},
				{field:'ProCreatDate',title:'创建日期',width:150},
				
				{field:'ProCreatTime',title:'创建时间',width:150},
				{field:'ProCreatUser',title:'创建人',width:150},
				{field:'ProType',title:'产品类型',width:150}
				
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
