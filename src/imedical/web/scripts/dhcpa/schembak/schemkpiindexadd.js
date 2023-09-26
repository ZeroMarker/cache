//添加函数
addSchemDetailFun = function(node){
    //alert(node);
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要添加指标的方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		
		var titleName="";
        titleName="指标窗口";

		var userCode = session['LOGON.USERCODE'];
		var sm = new Ext.grid.CheckboxSelectionModel();
		var grid="";
		//type=1,添加指标
		var KPIUrl = '../csp/dhc.pa.schemexe.csp';
		var KPIProxy= new Ext.data.HttpProxy({url:KPIUrl + '?action=kpi&schem='+node});
		var KPIDs = new Ext.data.Store({
		    proxy: KPIProxy,
			reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['KPIDr','KPIName']),
			remoteSort: true
		});
		//设置默认排序字段和排序方向
		KPIDs.setDefaultSort('KPIDr', 'desc');
		//数据库数据模型
		var KPICm = new Ext.grid.ColumnModel([
			sm,
			new Ext.grid.RowNumberer(),
			{header:'指标名称',dataIndex:'KPIName',width:325}
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
		fieldLabel: '指标',
		readOnly:true,
		itemCls:'sex-female', //向左浮动,处理控件横排
		clearCls:'allow-float' //允许两边浮动
		});
		
		var KPIDrStr="";
		OkHandler = function(){
			var rowObj=grid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1){
				Ext.Msg.show({title:'注意',msg:'请选择需要数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var idStr="";
					for(var i=0;i<len;i++){
						KPIDr=rowObj[i].get("KPIDr");
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
			text:'编辑',
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
				text:'添加'
			});

			editHandler = function(){
				OkHandler();
				var name = KPIDrStr;
				name = trim(name);
                var data = node+'^'+name;
                data = trim(data);
				Ext.Ajax.request({
					url: SchemUrl+'?action=addkpi&data='+data,
					waitMsg: '保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById("roo").reload();
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='EmptyRecData') message='空数据!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			};
	
			addButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'退出'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '选择指标',
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