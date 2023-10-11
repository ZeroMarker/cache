var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var adjustdoURL='herp.budg.adjustdoexe.csp';
var schemmadstateURL='herp.budg.budgschemmadstateexe.csp';
var DeptDetailURL='herp.budg.adjustdosubjectinfo.csp';

DeptDetail = function(records){
	
	var year    = records[0].get("year");
	var adjustno= records[0].get("adjustno");
	var itemcode= records[0].get("bsdcode");
	var itemname= records[0].get("bidname");
	var isapprove= records[0].get("isapprove");
	
 	var statetitle = "科目信息: "+itemcode+itemname;
 	var deptdr="";
 
// ////////////科室名称////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : adjustdoURL+'?action=deptNList&year='+year,
						method : 'POST'
					});
		});
var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	var findButton = new Ext.Toolbar.Button({
		id:'findButton',
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		handler: function(){
	      var deptdr= deptCombo.getValue();
		  addmainGrid.load({params : {start:0,limit:25,year:year,adjustno:adjustno,itemcode:itemcode,deptdr:deptdr}});
		}
	});
	
	var saveButton = new Ext.Toolbar.Button({
		id:'saveButton',
		text: '保存',
		tooltip: '保存选中记录信息',
		iconCls: 'save',
		handler: function(){	
	            var rowObj = addmainGrid.getSelectionModel().getSelections();
	    		var len = rowObj.length;
	    		if(len <1){
				    Ext.Msg.show({title:'注意',msg:'请选中记录！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				    return;
		        }else{
					var data="";
					for(var i=0;i<len;i++){
							if(data==""){
								data=rowObj[i].get("rowid")+"^"+rowObj[i].get("AdjValue");
							}else{
								data=data+"|"+rowObj[i].get("rowid")+"^"+rowObj[i].get("AdjValue");
							}
					}
					//alert(data)
					if(data!=""){
						Ext.Ajax.request({
									url: DeptDetailURL+'?action=edit&data='+data,
									failure: function(result, request) {
										Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									},
									success: function(result, request) {
										var jsonData = Ext.util.JSON.decode( result.responseText );
									  	if (jsonData.success=='true') {
									  		Ext.Msg.show({title:'注意',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
											addmainGrid.load({params : {start:0,limit:25,year:year,adjustno:adjustno,itemcode:itemcode,deptdr:deptCombo.getValue()}});
											itemGridDs.reload();   //弹出窗体关闭，主表格停留在原先页
										}else{
									  		var msg='保存失败!'+'SQLError:'+jsonData.info;
									  		Ext.Msg.show({title:'注意',msg:msg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										}
									},
									scope: this
						});				
					}else{
						Ext.Msg.show({title:'注意',msg:'请选择数据!',width:160, buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
	    }
		}
	});
	
	if(isapprove==0){
		saveButton.show();
	}else{
		saveButton.hide();
	}	
			
var addmainGrid = new dhc.herp.Grid({
				width : 600,
				region : 'center',
				url : DeptDetailURL,
				sm : new Ext.grid.CheckboxSelectionModel(), //多选
				tbar:['科室:',deptCombo,'-',findButton,'-',saveButton],  
				fields : [
                    new Ext.grid.CheckboxSelectionModel({editable:false,singleSelect:false}),
					{  
						id: 'rowid', 
						header : 'ID',
						width : 60,
						editable:false,
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'bfDeptDR',
						header : '科室ID',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'DeptDR'
					}, {
						id : 'bfDeptNa',
						header : '科室名称',
						width : 120,
						editable:false,
						hidden : false,
						dataIndex : 'bfDeptNa'
					},{
						id : 'BefAdjValue',
						header : '调整前总预算',
						width : 120,
						editable:false,
                        align : 'right',
						hidden : false,
						dataIndex : 'BefAdjValue'
					}, {
						id : 'AdjValue',
						header : '本次调整',
						width : 80,
                        align : 'right',
						editable:true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red">'+value+'</span>';
						},
						dataIndex : 'AdjValue'
					},{
						id : 'AdjRange',
						header : '调整幅度(%)',
						width : 140,
						editable: false,
						align : 'right',
						dataIndex : 'AdjRange'
					}, {
						id : 'TotalValue',
						header : '调整后预算',
						width : 140,
						align : 'right',
						editable: false,
						dataIndex : 'TotalValue'
					}, {
						id : 'RealValueLast',
						header : '上年执行',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'RealValueLast'
						
					},{
						id : 'DifValue',
						header : '差额',
						width : 120,
						editable : false,
						align : 'right',
						dataIndex : 'DifValue'
						
					},{
						id : 'DifRate',
						header : '差异率(%)',
						width : 120,
						editable:false,
						align : 'right',
						//hidden:true,
						dataIndex : 'DifRate'

					}]
	});
    addmainGrid.btnAddHide();  //隐藏增加按钮
    addmainGrid.btnSaveHide();  //隐藏保存按钮
    addmainGrid.btnResetHide();  //隐藏重置按钮
    addmainGrid.btnDeleteHide(); //隐藏删除按钮
    addmainGrid.btnPrintHide();  //隐藏打印按钮
    
	/*
		目前表格多选框存在问题:若已经选了2行,但对另一行点击时,前两行的选择会被取消
		以下代码解决:
	*/    
    var SM=addmainGrid.getSelectionModel();
    //屏蔽checkbox以外的列的点击事件
    SM.handleMouseDown = Ext.emptyFn
    //这是表格的列点击事件
	addmainGrid.on('cellclick', function(grid, rowIndex,columnIndex,event) {
	    if (columnIndex != 0) {
		    //判断表格的行的选中状态
			if (SM.isSelected(rowIndex)){ 
				//设置CheckboxSelectionModel的选中行的状态
	            SM.deselectRow(rowIndex);
			}else{
				SM.selectRow(rowIndex, true);
			}
		}
	})
    
    
	var deptdr= deptCombo.getValue();
	addmainGrid.load({params:{year:year,adjustno:adjustno,itemcode:itemcode,deptdr:deptdr,start:0,limit:100}});
		
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  itemGridDs.reload();   //弹出窗体关闭，主表格停留在原先页
	  window.close();
	};
	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [addmainGrid]
			});

	var tabPanel =  new Ext.Panel({
	  	//activeTab: 0,
	  	layout: 'border',
	  	region:'center',
	  	items:[addmainGrid]                                 //添加Tabs
	  });
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 1000,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]
			});
	window.show();
};

/*
DbudgFun=function(){
// 年度///////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxURL+'?action=year&flag=',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
	
// ////////////方案类别////////////////////////
var typeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '计划指标'], ['2', '收支预算'], ['3', '费用标准'], ['4', '预算结果表']]
		});
var typeField = new Ext.form.ComboBox({
			id : 'typeField',
			fieldLabel : '方案类型',
			width : 200,
			selectOnFocus : true,
			store : typeStore,
			anchor : '90%',
		    //value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
////////////////科室名称/////////////////////////////////
var DnameDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});
	DnameDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:commonboxURL+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('DnameComb').getRawValue()),method:'POST'});		
	});		
	var DnameComb = new Ext.form.ComboBox({
		id: 'DnameComb',
		name: DnameComb,
		fieldLabel:'科室名称',
		store: DnameDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 120,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
		var year = yearCombo.getValue();
		var type = typeField.getValue();
		var deptDR= DnameComb.getValue();
		itemGridD.load({params : {start : 0,limit : 25,year : year,type : type,deptdr:deptDR}});
	}
});


var itemGridD = new dhc.herp.Grid({
            title : '科室预算编制状态查询',
			region : 'center',
			url : schemmadstateURL,
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'Year',
						header : '年度',
						dataIndex : 'Year',
						width : 50,
						editable:false,
						hidden : false

					}, {
						id : 'Code',
						header : '方案编码',
						width : 50,
						editable:false,
						allowBlank : false,
						dataIndex : 'Code'

					}, {
						id : 'Name',
						header : '方案名称',
						width : 120,
						editable:false,
						allowBlank : false,
						dataIndex : 'Name'

					}, {
						id : 'OrderBy',
						header : '编制顺序',
						width : 60,
						editable:false,
						allowBlank : false,
						dataIndex : 'OrderBy'

					}, {
						id : 'Type',
						header : '方案类型',
						width : 60,
						editable:false,
						allowBlank : false,
						hidden:true,
						dataIndex : 'Type'

					}, {
						id : 'deptdr',
						header : '编制科室',
						width : 60,
						editable:false,
						allowBlank : false,
						hidden:true,
						dataIndex : 'deptdr'

					}, {
						id : 'dName',
						header : '编制科室',
						width : 60,
						editable:false,
						allowBlank : false,
						hidden:false,
						dataIndex : 'dName'

					},{
						id : 'UserDR',
						header : '用户',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'UserDR'

					},{
						id : 'Initials',
						header : '登录用户名',
						width : 60,
						editable:false,
						hidden:false,
						dataIndex : 'Initials'

					},{
						id : 'ChkState',
						header : '编制状态',
						width : 60,
						editable:false,
						hidden:false,
						dataIndex : 'ChkState'

					},{
						id : 'ChkStep',
						header : '审核步骤',
						width : 60,
						editable:false,
						hidden:false,
						dataIndex : 'ChkStep'

					}],
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					viewConfig : {
						forceFit : true
					},
					tbar : ['年度:', yearCombo, '方案类型:', typeField,'科室:',DnameComb, '-', findButton],
					width:650,
					trackMouseOver: true,
					stripeRows: true

		});

    itemGridD.btnAddHide();  //隐藏增加按钮
    itemGridD.btnSaveHide();  //隐藏保存按钮
    itemGridD.btnResetHide();  //隐藏重置按钮
    itemGridD.btnDeleteHide(); //隐藏删除按钮
    itemGridD.btnPrintHide();  //隐藏打印按钮
    
itemGridD.load({	
	params:{start:0, limit:12}

});
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [itemGridD]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '科室预算编制状态查询',
				plain : true,
				width : 900,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}
*/