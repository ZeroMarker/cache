	// ��Ϣ�б�
		// ����·��
		var MasterUrl = DictUrl	+ 'datainputaction.csp?actiontype=QueryError';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ['IngrId','DataInputErrDate','DataInputErrTime','DataInputErrNo','DataInputErrDesc'];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "IngrId",
					fields : fields
				});
		// ���ݼ�
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
					
				});
				
			 	var nm = new Ext.grid.RowNumberer();
		        var MasterCm = new Ext.grid.ColumnModel([nm,{
					header : "rowid",
					dataIndex : 'IngrId',
					width : 60,
					align : 'right',
					sortable : true,
					hidden : true
				}, {
					header : "��������",
					dataIndex : 'DataInputErrDate',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '����ʱ��',
					dataIndex : 'DataInputErrTime',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '��������',
					dataIndex : 'DataInputErrNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '����ԭ��',
					dataIndex : 'DataInputErrDesc',
					width : 600,
					align : 'left',
					sortable : true
				}]);
		MasterCm.defaultSortable = true;	
		
		
//create grid
		var ErrorGrid = new Ext.grid.GridPanel({
					id : 'ErrorGrid',
			        title: '�������ݲ�ѯ',
			        frame:true,
			        tbar:[
			        	{
    		               text:"��ѯ",
    	 	               iconCls:'page_find',
    	 	               handler:function()
    	 		           {		
    	 			          Query();
    	 		           }
    		            }
    		            ,'-' ,
    		            {
    		               text:"ɾ��ȫ��",
    		               iconCls:'page_delete',
    		                handler:function()
    	 		           {		
    	 			          Delete();
    	 		           }
    		            } 
    		       ],
					
					cm : MasterCm,
					store : MasterStore	
				});
				
	//��ѯ����Ĵ�������						
	function Query(){
			MasterStore.removeAll();
			MasterStore.load({		
			
				callback:function(r,options, success){
					if(success==false){
	     				Msg.info("error", "��ѯ������鿴��־!");
	     			}
	     			}
				});
	}
	//ɾ��ȫ����������
	function Delete(){
			var url = DictUrl+ "datainputaction.csp?actiontype=DeleteErrorData";
               var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : 'ɾ����...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
									mask.hide();
								if (jsonData.success == 'true') {
									Msg.info("success", "ɾ���ɹ�!");
									MasterStore.removeAll();
								} else {
									Msg.info("error", "ɾ��ʧ��!");
								}
						
							},
							scope : this
						});
		
	}
	
	
	
	
	
	