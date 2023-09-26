$(document).ready(function() {
	

 		$('#dataTable').dhccTable({
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMNurExe&MethodName=getExeOrders',
		    columns:[{
				title:'登记号',
				field:''    
			},{
				title:'时段',
				field:''  
			},{
				title:'就诊号',
				field:''  
			},{
				title:'病人姓名',
				field:''  
			},{
				title:'顺序号',
				field:''  
			},{
				title:'号别',
				field:''  
			},{
				title:'病人类型',
				field:''  
			},{
				title:'就诊科室',
				field:''  
			}]
		});
})	