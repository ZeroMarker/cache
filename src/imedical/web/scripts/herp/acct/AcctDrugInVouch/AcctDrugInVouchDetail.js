
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
		//html:'<div style="text-align:center;font-size:20px;height:70px;vertical-align:middle; line-height:70px;font-weight:bold">�ʲ��۾�ҵ����ϸ��</div>',
		height:80,
		items:[		
			{
                        xtype:'displayfield',
                        value:'ҩƷ���ҵ����ϸ��',
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
						header : '<div style="text-align:center">ҩƷ�ⷿ</div>',
						dataIndex : 'storehouse',
						width :180,
						editable:false,
						hidden : false

					},{
						id : 'ym',
						header : '<div style="text-align:center">�·�</div>',
						dataIndex : 'ym',
						width : 100,
						align : 'center',
						editable:false,
						//allowBlank:true,
						hidden : false

					},{
						id : 'project',
						header : '<div style="text-align:center">ҩƷ��Ŀ</div>',					
						width : 180,
						editable:false,
						hidden : false,
						//allowBlank:true,		
                        dataIndex : 'project'
					}, {            
						id : 'PhyQty',
						header : '<div style="text-align:center">�������</div>',
						width : 100,
						editable:false,
						align : 'right',
						//allowBlank : true,
						dataIndex : 'PhyQty'

				}, {
						id : 'CostAmount',
						header : '<div style="text-align:center">�����</div>',
						dataIndex : 'CostAmount',
						width :150,
						align : 'right',
						type:'numberField',
						editable:false,
						hidden : false

					},{
						id : 'department',
						header : '<div style="text-align:center">������</div>',
						width : 250,
						editable:false,
						align : 'left',
						hidden : false,
						dataIndex : 'department'

				},{          
						id : 'Date',
						header : '<div style="text-align:center">�������</div>',
						width : 100,
						editable:false,
						hidden : false,
						align : 'center',
						dataIndex : 'Date'
					} , {
						id : 'SSUSRname',
						header : '<div style="text-align:center">����Ա</div>',
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
