function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addJXUnitFun = function(schemGrid,ds,jxUnitGrid,pagingToolbar){

	var schemObj=schemGrid.getSelectionModel().getSelections()[0];
	if(schemObj==undefined){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���Բ���Ŀ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	}else{
	
	var userCode = session['LOGON.USERCODE'];
	var sm = new Ext.grid.CheckboxSelectionModel();
	var jxUnitUrl = '../csp/dhc.pa.unitdeptschemexe.csp';
	var jxUnitProxy= new Ext.data.HttpProxy({url:jxUnitUrl + '?action=jxunit'});
	var jxUnitDs = new Ext.data.Store({
		proxy: jxUnitProxy,
		reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['rowid','code','name','type']),
		remoteSort: true
	});
	//����Ĭ�������ֶκ�������
	jxUnitDs.setDefaultSort('rowid', 'desc');
	//���ݿ�����ģ��
	var jxUnitCm = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{header:'���Ҵ���',dataIndex:'code',width:180},
		{header:'��������',dataIndex:'name',width:180}
		
	]);
	var grid = new Ext.grid.GridPanel({
		store:jxUnitDs,
		cm:jxUnitCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true
	});
	jxUnitDs.load({params:{userCode:userCode,start:0,limit:10000}});
			
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
				rowid=rowObj[i].get("rowid");
				if(idStr==""){
					idStr=rowid;
				}else{
					idStr=idStr+"-"+rowid
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
		if(jxUnitDrStr==""){
			Ext.Msg.show({title:'��ʾ',msg:'��Ч��ԪΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var schemDr=schemGrid.getSelections()[0].get("rowid");
		schemDr = trim(schemDr);
		if(schemDr==""){
			Ext.Msg.show({title:'��ʾ',msg:'��Ч����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		Ext.Ajax.request({
			url:'../csp/dhc.pa.unitdeptschemexe.csp?action=add&schemDr='+schemDr+'&JXUnit='+jxUnitDrStr,
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					ds.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,schemDr:schemGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info!=0){
						//alert(jsonData.info)
						Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
					ds.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,schemDr:schemGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
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

	}}