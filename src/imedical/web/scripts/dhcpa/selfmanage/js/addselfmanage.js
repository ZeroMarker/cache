//��Ӻ���
addFun = function(node,DSDrowid){
    //alert(node);
	if(DSDrowid==""){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ���ָ��ķ���!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		
		var titleName="";
        titleName="��ӷ���";

		var userCode = session['LOGON.USERCODE'];
		var sm = new Ext.grid.CheckboxSelectionModel();
		var grid="";
		//type=1,���ָ��
		var KPIUrl = '../csp/dhc.pa.Selfmanageexe.csp';
		var KPIProxy= new Ext.data.HttpProxy({url:KPIUrl + '?action=GetDeptdetail&DSDrowid='+DSDrowid});
		var KPIDs = new Ext.data.Store({
		    proxy: KPIProxy,
			reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['rowid','name']),
			remoteSort: true
		});
		//����Ĭ�������ֶκ�������
		KPIDs.setDefaultSort('rowid', 'desc');
		//���ݿ�����ģ��
		var KPICm = new Ext.grid.ColumnModel([
			sm,
			new Ext.grid.RowNumberer(),
			{header:'�Բ���Ŀ����',dataIndex:'name',width:325}
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
			
		IDSet = new Ext.form.TextArea({
		id:'IDSet',
		width:355,
		height:60,
		labelWidth:20,
		fieldLabel: 'ָ��',
		readOnly:true,
		itemCls:'sex-female', //���󸡶�,����ؼ�����
		clearCls:'allow-float' //�������߸���
		});
		
		var KPIDrStr="";
		OkHandler = function(){
			var rowObj=grid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var idStr="";
					for(var i=0;i<len;i++){
						KPIDr=rowObj[i].get("rowid");
						if(idStr==""){
							idStr=KPIDr;
						}else{
							idStr=idStr+"-"+KPIDr
						}
						
					}
				KPIDrStr=idStr;	
				window.close();
			}
		}
	    /*
		var editorbutton = new Ext.Toolbar.Button({
			text:'�༭',
			itemCls:'age-field',
			handler:function(){
				selection(node);
			}
		});
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items: [
					IDSet,
					editorbutton
				]
			});	
			*/
			addButton = new Ext.Toolbar.Button({
				text:'���'
			});

			editHandler = function(){
				OkHandler();
				var name = KPIDrStr;
				name = trim(name);
                var data = DSDrowid+'^'+name;
                data = trim(data);
                if(name==""){
                	Ext.Msg.show({title:'����',msg:"��ѡ�����ݣ�",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                	return false;
                }else{
				Ext.Ajax.request({
					url: KPIUrl+'?action=addtree&data='+data,
					waitMsg: '������...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			};
	
			addButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'�˳�'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: 'ѡ��ָ��',
				width: 400,
				height:300,
				minWidth:400,
				minHeight: 300,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: grid,
				buttons:[addButton,cancel]
			});
			window.show();
		
	}
};