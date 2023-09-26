selection = function(type){
	var titleName="";
	if(type==1){
		titleName="指标窗口";
	}else{
		titleName="绩效单元窗口";
	}
	if(type==""){
		Ext.Msg.show({title:'提示',msg:'请选择分组类别!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		var userCode = session['LOGON.USERCODE'];
		var sm = new Ext.grid.CheckboxSelectionModel();
		var grid="";
		if(type==1){
			//type=1,添加指标
			var KPIUrl = '../csp/dhc.pa.jxgroupexe.csp';
			var KPIProxy= new Ext.data.HttpProxy({url:KPIUrl + '?action=kpi'});
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
		}else{
			//type=2,添加科室
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
				fieldLabel: '所属单位',
				width:215,
				listWidth : 215,
				allowBlank: false,
				store: unitDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择所属单位...',
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
			//设置默认排序字段和排序方向
			deptDs.setDefaultSort('deptID', 'desc');
			//数据库数据模型
			var deptCm = new Ext.grid.ColumnModel([
				sm,
				new Ext.grid.RowNumberer(),
				{header:'科室名称',dataIndex:'deptName',width:325}
			]);
			var grid = new Ext.grid.GridPanel({
				store:deptDs,
				cm:deptCm,
				trackMouseOver: true,
				stripeRows: true,
				sm:sm,
				loadMask: true,
				tbar:['单位:',unitField]
			});
		}
		
		var OkButton = new Ext.Toolbar.Button({
				text:'确定'
			});
		//定义按钮响应函数
		OkHandler = function(){
			var rowObj=grid.getSelections();
			var len = rowObj.length;
			if(len < 1){
				Ext.Msg.show({title:'注意',msg:'请选择需要数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
			
		//添加按钮的监听事件
		OkButton.addListener('click',OkHandler,false);
		
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
		
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			win.close();
		}
		
		//添加取消按钮的监听事件
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

		//窗口显示
		win.show();
	}
}