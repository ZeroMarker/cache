function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addSchemDetailFun = function(node){

	var userCode = session['LOGON.USERCODE'];
	var sm = new Ext.grid.CheckboxSelectionModel();
	var grid="";
			//type=1,���ָ��
			var KPIUrl = '../csp/dhc.pa.schemexe.csp';
			var KPIProxy= new Ext.data.HttpProxy({url:KPIUrl + '?action=kpi&schem='+node});
			var KPIDs = new Ext.data.Store({
				proxy: KPIProxy,
				reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['KPIDr','KPIName']),
				remoteSort: true
			});
			//����Ĭ�������ֶκ�������
			KPIDs.setDefaultSort('KPIDr', 'desc');
			//���ݿ�����ģ��
			var KPICm = new Ext.grid.ColumnModel([
				sm,
				new Ext.grid.RowNumberer(),
				{header:'ָ������',dataIndex:'KPIName',width:325}
			]);
			var grid = new Ext.grid.GridPanel({
				store:KPIDs,
				cm:KPICm,
				trackMouseOver: true,
				stripeRows: true,
				sm:sm,
				loadMask: true
			});
			KPIDs.load({params:{userCode:userCode}});
			
	var addkpiButton = new Ext.Toolbar.Button({
		text:'����'
	});
			
	var jxUnitDrStr="";	
	//���尴ť��Ӧ����
	Handler = function(node){
		var rowObj=grid.getSelectionModel().getSelections();
		var len = rowObj.length;
		var idStr="";
		alert(len);
		if(node==null){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ���ָ��ķ���!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
		}else{
			for(var i=0;i<len;i++){
				jxUnitDr=rowObj[i].get("KPIDr");
				if(idStr==""){
					idStr=jxUnitDr;
				}else{
					idStr=idStr+"-"+jxUnitDr
				}
			}
			jxUnitDrStr=idStr;
			alert(jxUnitDrStr);
			//win.close();
		}
	}
		
	//��Ӵ�����
	var addHandler = function(node){
		Handler(node);
		jxUnitDrStr = trim(jxUnitDrStr);
		var name = jxUnitDrStr;
		name = trim(name);
        var data = node+'^'+name;
        data = trim(data);
		alert(data);		
		Ext.Ajax.request({
			url:SchemUrl+'?action=addkpi&data='+data,
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById("roo").reload();
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='EmptyRecData') message='������!';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
			scope: this
		});
	}	
		
	//��Ӱ�ť�ļ����¼�
	addkpiButton.addListener('click',addHandler(node),false);
		
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
		title:'��Ӽ�Ч��Ԫ',
		width:420,
		height:300,
		minWidth: 420, 
		minHeight: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:grid,
		buttons: [
			addkpiButton,
			cancelButton
		]
	});

	//������ʾ
	win.show();
}