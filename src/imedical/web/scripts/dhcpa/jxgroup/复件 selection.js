selection = function(type){
	var titleName="";
	if(type==1){
		titleName="ָ�괰��";
	}else{
		titleName="��Ч��Ԫ����";
	}
	if(type==""){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		var userCode = session['LOGON.USERCODE'];
		var sm = new Ext.grid.CheckboxSelectionModel();
		var grid="";
		if(type==1){
			//type=1,���ָ��
			var KPIUrl = '../csp/dhc.pa.jxgroupexe.csp';
			var KPIProxy= new Ext.data.HttpProxy({url:KPIUrl + '?action=kpi'});
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
		}else{
			//type=2,��ӿ���
			var unitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			unitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=unit&str='+Ext.getCmp('unitField').getRawValue(),method:'POST'})
			});

			var unitField = new Ext.form.ComboBox({
				id: 'unitField',
				fieldLabel: '������λ',
				width:215,
				listWidth : 215,
				allowBlank: false,
				store: unitDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'��ѡ��������λ...',
				name: 'unitField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});

			unitField.on("select",function(cmb,rec,id){		
				deptDs.load({params:{unitDr:cmb.getValue()}});
			});
			
			var deptUrl = '../csp/dhc.pa.jxgroupexe.csp';
			var deptProxy= new Ext.data.HttpProxy({url:deptUrl + '?action=dept'});
			var deptDs = new Ext.data.Store({
				proxy: deptProxy,
				reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['deptID','deptName']),
				remoteSort: true
			});
			//����Ĭ�������ֶκ�������
			deptDs.setDefaultSort('deptID', 'desc');
			//���ݿ�����ģ��
			var deptCm = new Ext.grid.ColumnModel([
				sm,
				new Ext.grid.RowNumberer(),
				{header:'��������',dataIndex:'deptName',width:325}
			]);
			var grid = new Ext.grid.GridPanel({
				store:deptDs,
				cm:deptCm,
				trackMouseOver: true,
				stripeRows: true,
				sm:sm,
				loadMask: true,
				tbar:['��λ:',unitField]
			});
		}
		
		var OkButton = new Ext.Toolbar.Button({
				text:'ȷ��'
			});
		//���尴ť��Ӧ����
		OkHandler = function(){
			var rowObj=grid.getSelections();
			var len = rowObj.length;
			if(len < 1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var idStr="";
				var nameStr="";
				if(type==1){
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
				}else{
					for(var i=0;i<len;i++){
						deptID=rowObj[i].get("deptID");
						if(idStr==""){
							idStr=deptID;
						}else{
							idStr=idStr+"-"+deptID
						}
						deptName=rowObj[i].get("deptName");
						if(nameStr==""){
							nameStr=deptName;
						}else{
							nameStr=nameStr+"-"+deptName;
						}
					}
					IDSet.setValue(nameStr);
					deptIDStr=idStr;
					deptNameStr=nameStr;
					KPINameStr="";
					KPIDrStr="";
				}
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
}