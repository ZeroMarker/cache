EditSysFun = function(sysField,lcode){

/////////////////////系统名称/////////////////////////////
var SysNamefield = new Ext.form.TextField({
		id: 'SysNamefield',
		fieldLabel: '系统名称',
		allowBlank: true,
		emptyText:'请填写...',
		width:100,
	    listWidth : 100
	});
var checkActive = new Ext.form.Checkbox({fieldLabel: '状态'});
//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
		var sysname=SysNamefield.getValue();
		AddSysGrid.load(({params:{start:0, limit:25,sname:sysname,lcode:lcode}}));
	}
});		

//确认按钮
var addButton = new Ext.Toolbar.Button({
	text: '确认',
    tooltip:'确认',        
    iconCls:'add'});


	// 科室设置grid
var AddSysGrid = new dhc.herp.Grid({
				title :' 系统选择',
				width : 400,
				region : 'center',
				url : 'herp.budg.moneyprojectexe.csp',
				fields : [
				//new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'Code',
							header : '系统编码',
							dataIndex : 'Code',
							width : 80,
							editable:false
						},{
							id : 'Name',
							header : '系统名称',
							dataIndex : 'Name',
							width : 200,
							editable:false
						},{
							id : 'State',
							header : '状态',
							dataIndex : 'State',
							width : 120,
							align : 'left',
							renderer : function(v, p, record){
			        			p.css += ' x-grid3-check-col-td'; 
			        			return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			    			},
			    			type : checkActive,
			    			editor : new Ext.form.Checkbox({allowBlank : true})

						}],
				tbar:['系统名称:',SysNamefield,'-',findButton]
			});
AddSysGrid.load(({params:{start:0, limit:25,sname:"",lcode:lcode}}));	
//定义添加按钮响应函数
addHandler = function(){
        var records=AddSysGrid.store.getModifiedRecords();
	    var str="",strs="";
		for(var i=0,len=AddSysGrid.store.data.length;i<len;i++){
			var data = AddSysGrid.store.getAt(i).data;//data就是对应record的一个一个的对象
			var rowid=data.rowid;
			var state=(data.State== true) ? '1' : '0';//获取的就是该对象dataIndex属性对应的值
			//alert(state);
			if(state=="1"){
			//str=rowid+"&"+state;
			str=rowid;
			strs=strs+"^"+str;
			//alert(strs);
			}
		}
		sysField.setValue(strs);	    
		//alert(strs);

	    /*//获取变化的行的数据
	    var o = {};
	    var tmpDate = AddSysGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    Ext.each(records, function(r) {
		var o = {};
		var tmpstro =r.data['rowid'];
	    for (var f in r.getChanges()) {

					o[f] = r.data[f];
					if (r.data[f] != null) {
						if (tmpDate.indexOf(f) >= 0) { // field.type=='date'
							if (r.data[f].toString() == "") {
								tmpstro += "&" + r.data[f].toString();
							} else {
								tmpstro += "&"
										+ new Date(r.data[f]).format('Y-m-d')
												.toString();
							}
						} else if (f != null) {
							var chk = r.data[f];
							if (chk === true)
								chk = 'Y';
							else if (chk === false)
								chk = 'N';

							tmpstro += "&" + encodeURIComponent(chk);
						}
					}
					tmpstros=tmpstros+"^"+tmpstro;
				}
	    });*/
		  window.close();
		  
		};
	
	addButton.addListener('click',addHandler,false);
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function() { window.close(); };

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [AddSysGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '同步系统选择',
				plain : true,
				width : 500,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [addButton,cancelButton]

			});
			
	window.show();
    AddSysGrid.btnAddHide();  //隐藏增加按钮
    AddSysGrid.btnSaveHide();  //隐藏保存按钮
    AddSysGrid.btnResetHide();  //隐藏重置按钮
    AddSysGrid.btnDeleteHide(); //隐藏删除按钮
    AddSysGrid.btnPrintHide();  //隐藏打印按钮
};