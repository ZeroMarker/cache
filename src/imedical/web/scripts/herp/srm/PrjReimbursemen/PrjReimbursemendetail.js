	userid = session['LOGON.USERID'];
var projUrl2 = 'herp.srm.PrjReimbursemendetailexe.csp';

//////////////// ��Ӱ�ť  ////////////////
var addButton = new Ext.Toolbar.Button({
	text: '����',
    //tooltip:'���',        
    iconCls: 'edit_add',
	handler:function(){
	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;

		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '����ѡ��һ����Ŀ!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		}
		
	 var projDr=selectedRow[0].data['rowid'];      // ��ĿID
	 var Username=selectedRow[0].data['username']; // ������
	 var projName=selectedRow[0].data['name'];     // ��Ŀ����
	 //var deptdr=selectedRow[0].data['deptdr'];     // ����ID
	 //var deptname=selectedRow[0].data['deptname']; // ��������
	 var year=selectedRow[0].data['year'];
	 //,deptdr,deptname
	 AddFun(itemDetail,projDr,projName,userid,Username,year);
	 }
});

//�޸�
var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls: 'pencil',
					handler : function() {
						var selectedRow = itemGrid.getSelectionModel().getSelections();
						var len = selectedRow.length;

						if (len < 1) {
							Ext.Msg.show({
										title : 'ע��',
										msg : '����ѡ��һ����Ŀ!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.WARNING
									});
								return;
							}						
						var selectedRow1 = itemDetail.getSelectionModel().getSelections();
											

						var len1 = selectedRow1.length;

						if (len1 < 1) {
							Ext.Msg.show({
										title : 'ע��',
										msg : '����ѡ������!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.WARNING
									});
								return;
							}
        				var BillState = selectedRow1[0].data['BillState'];
        				if(BillState=="���ύ")
       					 {
        					Ext.Msg.show({
								title : '',
								msg : '���뵥���ύ���������޸�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
							return;
        				  }else{applynofun(itemDetail);}
					}
				});


//ɾ��
var delButton = new Ext.Toolbar.Button({
		text : 'ɾ��',
		//tooltip : 'ɾ��',
		iconCls: 'edit_remove',
		handler : function() {
		var selectedRow = itemGrid.getSelectionModel().getSelections();
		var len = selectedRow.length;

		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '����ѡ��һ����Ŀ!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
				return;
			}			
        var selectedRow1 = itemDetail.getSelectionModel().getSelections();		
		var len1 = selectedRow1.length;

		if (len1 < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫɾ���ı�����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		}
        var BillState = selectedRow1[0].data['BillState'];	
        if(BillState=="���ύ")
        {
	        
        	Ext.Msg.show({
						title : '',
						msg : '���뵥���ύ��������ɾ��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
        }
        var rowid = selectedRow1[0].data['rowid'];	

	    Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������Ŀ��', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var rowIndex = itemGrid.getSelectionModel().lastActive;//�к�
			var projdr=selectedRow[0].data['rowid'];
			//alert("rowid:"+rowid+";userid:"+userid);
			Ext.Ajax.request({
				url: projUrl2+'?action=Del&rowid='+rowid,
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : 'ɾ���ɹ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
		//alert(url);
		itemGrid.load({params:{start:0, limit:25,userid:userid}});
		var d = new Ext.util.DelayedTask(function(){  
                itemGrid.getSelectionModel().selectRow(rowIndex);
            });  
            d.delay(1000); 
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
		
		}
	});
			}
});

  var SubmitButton = new Ext.Toolbar.Button({
   	        text : '�ύ',
			iconCls: 'pencil',
			handler : function() {
			var rowObj = itemDetail.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			//////////////////////////�ж��Ƿ��и����ϴ���¼///////////////////////////
			
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P014',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'���ϴ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
			
			
			
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("BillState");
				
			if(state == "δ�ύ" ){ Submitfun();}
			else {Ext.Msg.show({title:'����',msg:'�������ύ�������ظ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });	


var itemDetail = new dhc.herp.Gridapplydetail({
            title: '�������뵥',
            iconCls: 'list',
			region : 'center',
			url : projUrl2,		
            tbar:[addButton,'-',editButton,'-',delButton,'-',SubmitButton],
			fields : [{
						header : '��������ID',
						dataIndex : 'rowid',
						hidden : true
					  },{
				        id:'projdr',
				        header: '��ĿID',
				        dataIndex: 'projdr',
				        width:90,
				        allowBlank: true,
						hidden: true
				      },{
						id : 'code',   //3
						header : '��������',
						width : 100,
						editable:false,
						dataIndex : 'code',
						renderer: function(val,cellmeta, record,rowIndex, columnIndex, store)
						{
							return '<span style="color:blue;cursor:hand"><u>'+val+'</u></span>'
						}
					},{
						id : 'name',   //4
						header : '��Ŀ����',
						editable:false,
						width : 180,
						
						dataIndex : 'name',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'deptname',
						header : '��������',
						editable:false,
						width : 120,
						dataIndex : 'deptname',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'username',
						header : '������',
						width : 60,
						editable:false,
						dataIndex : 'username'

					},{
						id : 'Desc',
						header : '����˵��',
						width : 100,
						editable:false,
						dataIndex : 'Desc'
					},{
						id : 'Actmoney',
						header : '�������(Ԫ)',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'Actmoney',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'FundTotal',
						header : 'Ԥ���ܶ�',
						width : 120,
						editable : false,
						dataIndex : 'FundTotal',
						hidden : true
					},{
						id : 'ActPayWait',
						header : '��;����',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayWait',					
						hidden : true
					},{
						id : 'ActPayMoney',
						header : '�Ѿ�ִ��',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayMoney',
						hidden : true
					},{
						id : 'ReqMoney',
						header : '�����ʽ�',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ReqMoney',
						hidden : true

					},{
						id : 'budgco',
						header : '���ƽ���(��Ԫ)',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'budgco',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'BillState',    
						header : '����״̬',
						width : 60,
						align : 'left',
						editable:false,
						dataIndex : 'BillState'

					},{
						id : 'subuser',    
						header : '¼����',
						width : 100,
						align : 'center',
						editable:false,
						hidden : true,
						dataIndex : 'subuser'

					},{
						id : 'checkresult',    
						header : '�������',
						width : 180,
						align : 'left',
						editable:false,
						dataIndex : 'checkresult'

					},{
						id : 'checkdesc',    
						header : '�������',
						width : 180,
						align : 'left',
						editable:false,
						dataIndex : 'checkdesc'

					},{
							id:'upload',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					}],

					xtype : 'grid',
					loadMask : true,				
					atLoad: true
		});


//�ύ
submits=function(){
    var records = itemDetail.getSelectionModel().getSelections();
	var rowid = records[0].get("rowid")
	var BillState=records[0].get("BillState")		
	if(BillState=="�ύ"||(BillState=="ͨ��")||(BillState=="��ͨ��"))
	{
		Ext.Msg.show({
						title : '',
						msg : '���ύ�ĵ��������ٴ��ύ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
		return;
	}
	
	Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ύѡ������Ŀ��', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var rowIndex = itemGrid.getSelectionModel().lastActive;//�к�
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=submit&rowid='+rowid+'&userid='+userid,
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '�ύ�ɹ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
			
			
	itemGrid.load({params:{start:0, limit:25,userid:userid}});
	var d = new Ext.util.DelayedTask(function(){  
                itemGrid.getSelectionModel().selectRow(rowIndex);
            });  
            d.delay(1000); 
            
		itemGrid.getSelectionModel().selectRow(rowIndex);
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
			
		}
		
	});

};

uploadMainFun(itemDetail,'rowid','P014',18);
downloadMainFun(itemDetail,'rowid','P014',19);

//////////////////// ����gird�ĵ�Ԫ���¼�  //////////////////
itemDetail.on('cellclick', function(g, rowIndex, columnIndex, e) {
 //////////////////  ������������  ///////////////////////  
 
	if (columnIndex == 3) {	
	applynofun(itemDetail);	
	//rowid,projdr,code,deptname,username,name,Desc,facode,oldfundbilldr,BillState
	}
/* 
/////////////// ������Ŀ���� ///////////////
	if (columnIndex == 5) {
		var records = itemDetail.getSelectionModel().getSelections();
		var Name		 = records[0].get("name");
		var projdr		 = records[0].get("projdr");
		projnamefun(projdr,Name);
	}
*/

});