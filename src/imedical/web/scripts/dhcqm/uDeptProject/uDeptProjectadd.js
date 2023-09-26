function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}


addSchemFun = function(dataStore,grid,pagingTool, RowId ) {

	

	
	var nameUrl = '../csp/dhc.qm.uDeptProjectexe.csp';
	var nameProxy= new Ext.data.HttpProxy({url:nameUrl + '?action=nameList'});
	var nameDs = new Ext.data.Store({   //��������Դ
           
			proxy: nameProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['rowid','deptGroupName']),
			remoteSort: true	
});
var sm = new Ext.grid.CheckboxSelectionModel();
	//����Ĭ�������ֶκ�������
	nameDs.setDefaultSort('rowid', 'deptGroupName');
	//���ݿ�����ģ��
	var nameCm = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{

            id:'deptGroupName',
            header: '��������',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'deptGroupName'
            
           
       }
		
		
	]);
	var grid = new Ext.grid.GridPanel({
		store:nameDs,
		cm:nameCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true
	});
	nameDs.load({params:{start:0,limit:10000}});
			
	var addButton = new Ext.Toolbar.Button({
		text:'���'
	});
			
	var jxUnitDrStr="";	
	//���尴ť��Ӧ����
	Handler = function(){
		var rowObj=grid.getSelections();
		var len = rowObj.length;
		var idStr="";
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			for(var i=0;i<len;i++){
				name=rowObj[i].get("rowid");
				if(idStr==""){
					idStr=name;
				}else{
					idStr=idStr+","+name
				}
			}
			jxUnitDrStr=idStr;
			win.close();
		}
	}
		
	//��Ӵ�����
	var addHandler = function(){
		Handler();
		jxUnitDrStr = trim(jxUnitDrStr);
		
		
		
      		
        	var data = jxUnitDrStr+'^'+RowId;
		Ext.Ajax.request({
			url:'../csp/dhc.qm.uDeptProjectexe.csp?action=add&data='+data,
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
				}else{
					if(jsonData.info!=0){
						//alert(jsonData.info)
						Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
					dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
				}
			},
			scope: this
		});
	}	
		
	//��Ӱ�ť�ļ����¼�
	addButton.addListener('click',addHandler,false);
		
	//���岢��ʼ��ȡ���޸İ�ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
		
	//����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function(){
		win.close();
	}
		
	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);
		
	var win = new Ext.Window({
		title:'��ӿ�����Ϣ',
		width:460,
		height:300,
		minWidth: 460, 
		minHeight: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:grid,
		buttons: [
			addButton,
			cancelButton
		]
	});

	//������ʾ
	win.show();
};