
var rowid=document.getElementById("rowid").innerHTML;
var cat=document.getElementById("cat").innerHTML;
var ctlocdr=document.getElementById("ctlocdr").innerHTML;
//alert(rowid+"^"+cat)

	var Title=new Ext.FormPanel({
		region:'north',
		frame:true,
	  // split : true,
	  //collapsible : true,
    //  defaults: {bodyStyle:'padding:2px'},
		//html:'<div style="text-align:center;font-size:20px;height:70px;vertical-align:middle; line-height:70px;font-weight:bold">资产折旧业务明细表</div>',
		height:80,
		items:[		
			{
                        xtype:'displayfield',
                        value:'药品入库业务明细表',
                        style:'text-align:center;font-size:20px;height:70px;vertical-align:middle; line-height:70px;font-weight:bold'
                        //width:60
                    }
		]		
	});
	
 var GridDetail=new dhc.herp.Gridp({
			 region:'center',
			 width: 1130,
             height:530,
			 //style:'text-align:center;',
			//forceFit:true,
			readerModel:'remote',
			url: 'herp.acct.acctdruginvouchdetailexe.csp',
			fields:[					
					{
						id : 'storehouse',
						header : '<div style="text-align:center">药品库房</div>',
						dataIndex : 'storehouse',
						width :180,
						editable:false,
						hidden : false

					},{
						id : 'ym',
						header : '<div style="text-align:center">月份</div>',
						dataIndex : 'ym',
						width : 100,
						align : 'center',
						editable:false,
						//allowBlank:true,
						hidden : false

					},{
						id : 'project',
						header : '<div style="text-align:center">药品项目</div>',					
						width : 180,
						editable:false,
						hidden : false,
						//allowBlank:true,		
                        dataIndex : 'project'
					}, {            
						id : 'PhyQty',
						header : '<div style="text-align:center">入库数量</div>',
						width : 100,
						editable:false,
						align : 'right',
						//allowBlank : true,
						dataIndex : 'PhyQty'

				}, {
						id : 'CostAmount',
						header : '<div style="text-align:center">入库金额</div>',
						dataIndex : 'CostAmount',
						width :150,
						align : 'right',
						type:'numberField',
						editable:false,
						hidden : false

					},{
						id : 'department',
						header : '<div style="text-align:center">入库科室</div>',
						width : 250,
						editable:false,
						align : 'left',
						hidden : false,
						dataIndex : 'department'

				},{          
						id : 'Date',
						header : '<div style="text-align:center">入库日期</div>',
						width : 100,
						editable:false,
						hidden : false,
						align : 'center',
						dataIndex : 'Date'
					} , {
						id : 'SSUSRname',
						header : '<div style="text-align:center">操作员</div>',
						width : 150,
						editable:false,
						hidden : false,
						//editable : true,
						//allowBlank:true,
						dataIndex : 'SSUSRname'
						
					}]
			 
		 });
	GridDetail.load({
	    params:{
			rowid:rowid,
			cat:cat,
			ctlocdr:ctlocdr,
		    start:0,
		    limit:25
		}
	});	
	GridDetail.btnAddHide();
    GridDetail.btnSaveHide();
    GridDetail.btnResetHide();
    GridDetail.btnDeleteHide();
    GridDetail.btnPrintHide();
