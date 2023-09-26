selection = function(node){
	var titleName="";
    titleName="ָ�괰��";

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
	
		var OkButton = new Ext.Toolbar.Button({
				text:'ȷ��'
			});
		//���尴ť��Ӧ����
		OkHandler = function(){
			var rowObj=grid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var idStr="";
				var nameStr="";
					for(var i=0;i<len;i++){
						KPIDr=rowObj[i].get("KPIDr");
						if(idStr==""){
							idStr=KPIDr;
						}else{
							idStr=idStr+"-"+KPIDr
						}
						KPIName=rowObj[i].get("KPIName");
						if(nameStr==""){
							nameStr=KPIName;
						}else{
							nameStr=nameStr+"-"+KPIName;
						}
					}
					IDSet.setValue(nameStr);
					KPIDrStr=idStr;
					KPINameStr=nameStr;
					deptNameStr="";
					deptIDStr="";
				win.close();
			}
		}
			
		//��Ӱ�ť�ļ����¼�
		OkButton.addListener('click',OkHandler,false);
		
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
			title:titleName,
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
				OkButton,
				cancelButton
			]
		});

		//������ʾ
		win.show();
}