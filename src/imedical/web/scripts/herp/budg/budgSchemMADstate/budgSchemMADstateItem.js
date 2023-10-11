var detailitemGrid = new dhc.herp.Gridhss({
            title : '对应审批记录', 
			region : 'center',
			url : 'herp.budg.budgschemmasstateitemexe.csp',						
			fields : [
			{
						header : '序号',
						dataIndex : 'StepNO',
						editable:false,
						width : 40,
						hidden : false
					}, {
						id : 'DeptDR',
						header : '执行科室',
						dataIndex : 'DeptDR',
						width : 60,
						editable:false,
						// type:itemcbbox,
						hidden : true
//Name^Chercker^Initials
					}, {
						id : 'Name',
						header : '执行科室',
						dataIndex : 'Name',
						width : 60,
						editable:false,
						// type:itemcbbox,
						hidden : false

					}, {
						id : 'Chercker',
						header : '执行人',
						width : 60,
						editable:false,
						hidden : true,
						dataIndex : 'Chercker'

				}, {
						id : 'Initials',
						header : '执行人',
						width : 60,
						editable:false,
						dataIndex : 'Initials'

				}, {
						id : 'ChkResult',
						header : '执行结果',
						width : 60,
						editable:false,
						update:true,
						hidden : false,
						dataIndex : 'ChkResult'

				}, {
						id : 'ChkProcDesc',
						header : '执行过程描述',
						width : 80,
						editable:false,
						//allowBlank : false,
						dataIndex : 'ChkProcDesc'

					},{
						id : 'DateTime',
						header : '执行时间',
						width : 70,
						editable: false,
						dataIndex : 'DateTime'
					}
					],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					viewConfig : {
						forceFit : true
					},
					//loadMask: true,
					//atLoad: true,
					trackMouseOver: true,
					stripeRows: true
					

		});
    
    
    

