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
			//type=2,添加绩效单元
			//========================================================================
			//添加一个科室类别
			var unitTypeDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['deptID','deptName'])
			});

			unitTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'dhc.pa.jxgroupexe.csp?action=unittype&str='+Ext.getCmp('unitType').getRawValue(),method:'POST'})
			});

			var unitType = new Ext.form.ComboBox({
				id:'unitType',
				fieldLabel:'绩效单元类别',
				width:240,
				listWidth : 240,
				allowBlank:true,
				store:unitTypeDs,
				valueField:'deptID',
				displayField:'deptName',
				emptyText:'请选择绩效单元类别...',
				triggerAction:'all',
				name: 'unitType',
				emptyText:'',
				minChars:1,
				pageSize:10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});
			
			unitType.on("select",function(cmb,rec,id ){
				deptDs.load({params:{unitTypeDr:cmb.getValue()}});
			
			});
			//========================================================================
			var deptUrl = '../csp/dhc.pa.jxgroupexe.csp';
			var deptProxy= new Ext.data.HttpProxy({url:deptUrl + '?action=getJXUnit'});
			var deptDs = new Ext.data.Store({
				proxy: deptProxy,
				reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['deptID','deptName']),
				remoteSort: true
			});
			//设置默认排序字段和排序方向
			deptDs.setDefaultSort('deptID', 'desc');
			deptDs.on('load',function(){
		
				});
			//数据库数据模型
			var deptCm = new Ext.grid.ColumnModel([
				sm,
				new Ext.grid.RowNumberer(),
				{header:'绩效单元名称',dataIndex:'deptName',width:325}
			]);
			var str="单元类别";
			
			var label = new Ext.form.Label
          ({
              id:"labelID",
              
              text:"请选择科室类别:",
              
              height:100,//默认auto
              
              width:100,//默认auto
              
              autoShow:true,//默认false
              
              autoWidth:true,//默认false
              
              autoHeight:true,//默认false
              
              hidden:false,//默认false
              
              hideMode:"offsets",//默认display,可以取值：display，offsets，visibility
              
              cls:"cssLabel",//样式定义,默认""
              
              disabled:true,//默认false
              disabledClass:"",//默认x-item-disabled
              
              html:"Ext"//默认""
              
              //x:number,y:number,在容器中的x,y坐标
             
              
          });
			var grid = new Ext.grid.GridPanel({
				store:deptDs,
				cm:deptCm,
				//trackMouseOver: true,
				//stripeRows: true,
				sm:sm,
				region: 'center',
				layout:'fit',
				tbar:[label,"&nbsp&nbsp&nbsp",unitType]
	
			});
			//deptDs.load();
		}
		
		var OkButton = new Ext.Toolbar.Button({
				text:'确定'
			});
		//定义按钮响应函数
		OkHandler = function(){
			var rowObj=grid.getSelections();
			var len = rowObj.length;
			var idStr="";
			var nameStr="";
			if(len < 1){
				Ext.Msg.show({title:'注意',msg:'请选择需要数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
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
			height:450,
			minWidth: 420, 
			minHeight: 450,
			layout: 'fit',
			plain:true,
			modal:true,
			//bodyStyle:'padding:5px;',
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