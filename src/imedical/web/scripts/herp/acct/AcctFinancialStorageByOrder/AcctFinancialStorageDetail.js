//��ȡ����Ĳ���
var mainid=document.getElementById("mid").innerHTML;
var typeID=document.getElementById("typeID").innerHTML;
var code=document.getElementById("code").innerHTML;
//alert(mainid+"^"+typeID);

	var Title=new Ext.FormPanel({
		//title:'�ʲ������ϸ',
		region:'north',
		frame:true,
	  // split : true,
	  //collapsible : true,
      //  defaults: {bodyStyle:'padding:2px'},
		height:80,
		items:[
			
			{
                        xtype:'displayfield',
                        value:'�ʲ����ҵ����ϸ��',
                        style:'text-align:center;font-size:20px;height:70px;vertical-align:middle; line-height:70px;font-weight:bold'
                        //width:60
            }
		]
		
		
	});
	
 var GridDetail=new dhc.herp.Gridp({
			 //title:'�ʲ��۾���ϸ',
			 region:'center',
			 width: 1130,
             height:530,
			 atLoad:true, 
			 //style:'text-align:center;',
			//forceFit:true,
			readerModel:'remote',
			url: 'herp.acct.acctfinancialstoragedetailexe.csp',
			fields:[
					
					{
						id : 'EquipName',
						header : '<div style="text-align:center">�豸����</div>',
						dataIndex : 'EquipName',
						width :180,
						editable:false,
						hidden : false

					}, 
					{
						id : 'EquipTypeDR',
						header : '<div style="text-align:center">�豸����ID</div>',
						dataIndex : 'EquipTypeDR',
						width : 180,
						editable:false,
						//allowBlank:true,
						hidden : true

					},
					{
						id : 'EquipType',
						header : '<div style="text-align:center">�豸����</div>',					
						width : 180,
						editable:false,
						hidden : false,
						//allowBlank:true,		
                        dataIndex : 'EquipType'
					}, {
						id : 'StatCat',
						header : '<div style="text-align:center">�豸����</div>',
						width : 180,
						editable:false,
						//allowBlank : true,
						dataIndex : 'StatCat'

				}, {
						id : 'Code',
						header : '<div style="text-align:center">��Ӧ�̱���</div>',
						dataIndex : 'Code',
						width :180,
						editable:false,
						hidden : true

					},{
						id : 'Loc',
						header : '<div style="text-align:center">������Ӧ��</div>',
						width : 250,
						editable:false,
						align : 'left',
						hidden : false,
						dataIndex : 'Loc'

				},
				 {
						id : 'Amount',
						header : '<div style="text-align:center">�����</div>',
						width : 150,
						editable:false,
						hidden : false,
						align : 'right',
						dataIndex : 'Amount'
					} , {
						id : 'Remark',
						header : '<div style="text-align:center">��ע</div>',
						width : 280,
						//editable : true,
						//allowBlank:true,
						dataIndex : 'Remark'
						
					}]
			 
		 });
	GridDetail.load({
	    params:{
			Mainid:mainid,
			EtypeID:typeID,
			code:code,
		    start:0,
		    limit:25
		    }
		    });	
	GridDetail.btnAddHide();
    GridDetail.btnSaveHide();
    GridDetail.btnResetHide();
    GridDetail.btnDeleteHide();
    GridDetail.btnPrintHide();
