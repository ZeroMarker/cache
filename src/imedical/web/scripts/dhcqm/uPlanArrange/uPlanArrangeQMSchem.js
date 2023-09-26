function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

QMSchem = function(dataStore,grid,pagingTool,addOrEdit) {
if(addOrEdit=="edit"){
	//得到已经选择的项目id
	var rowObj=itemGrid.getSelectionModel().getSelections();
	var schemDr=rowObj[0].data.qmschemDr;
	
	}else{
		var schemDr="";
	}

//定义勾选的数组
var selectArr=[];
	var nameUrl = '../csp/dhc.qm.uPlanArrangeexe.csp';
	var nameProxy= new Ext.data.HttpProxy({url:nameUrl + '?action=QMSchemList',method:'POST'});
	var nameDs = new Ext.data.Store({   //解析数据源
           
			proxy: nameProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['grouRowid','grouName']),
			remoteSort: true	
});
var sm = new Ext.grid.CheckboxSelectionModel();
	//设置默认排序字段和排序方向
	nameDs.setDefaultSort('grouRowid', 'grouName');

	//数据库数据模型
	var nameCm = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{

            id:'grouName',
            header: '检查项目',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'grouName' ,
            renderer: function(value, metaData, record, rowIndex, colIndex, store){
	           var grouRowid=record.data.grouRowid;
	           var isExt=schemDr.indexOf(grouRowid);
	           if(isExt>-1){
					selectArr.push(rowIndex);
		       }
	        	return value;
	        }
           
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

	nameDs.load({
		params:{start:0,limit:10000},
		callback: function(records, operation, success) {
			if(addOrEdit=="edit"){
			sm.selectRows(selectArr);
			}
		}
	});

	var addButton = new Ext.Toolbar.Button({
		text:'确定'
	});
			
	var jxUnitDrStr="";	
	var jxUnitDrStrl="";	
	//定义按钮响应函数
	Handler = function(){
		var rowObj=grid.getSelections();
		var len = rowObj.length;
		var idStr="";
		var idStrl="";
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			for(var i=0;i<len;i++){
				name=rowObj[i].get("grouRowid");
				namel=rowObj[i].get("grouName");
				if(idStr==""){
					idStr=name;
					idStrl=namel;
				}else{
					idStr=idStr+","+name
					idStrl=idStrl+","+namel
				}
			}
			jxUnitDrStr=idStr;
			jxUnitDrStrl=idStrl;
			win.close();
		}
	}
		
	//添加处理函数
	var addHandler = function(){
		Handler();
		jxUnitDrStr = trim(jxUnitDrStr);
		jxUnitDrStrl = trim(jxUnitDrStrl);
		
		QMSchemField.setRawValue(jxUnitDrStrl);
		
      	QMSchemF=jxUnitDrStr;
      	//QMSchemFl=jxUnitDrStrl;
      	//alert(QMSchemF);
      	//alert(QMSchemFl);
      	//alert(QMSchemField);
	}	
		
	//添加按钮的监听事件
	addButton.addListener('click',addHandler,false);
		
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
		title:'检查项目信息',
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

	//窗口显示
	win.show();
};