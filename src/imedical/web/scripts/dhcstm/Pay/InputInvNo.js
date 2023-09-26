// 名称:发票补录
// 编写日期:2013-5-16
//编写着:徐超
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];


var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'科室',
	name:'locField',
	anchor:'90%'
});
var ordlocField = new Ext.ux.LocComboBox({
	id:'ordlocField',
	fieldLabel:'医嘱接收科室',
	name:'ordlocField',
	anchor:'90%',
	defaultLoc:{}
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'开始日期',
	
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	//width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:'结束日期',
	
	value:new Date()
});
var vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'vendor',
	name : 'vendor',
	anchor : '90%',
	emptyText : '供应商...'
});

var regno = new Ext.form.TextField({
	fieldLabel : '登记号',
	id : 'regno',
	name : 'regno',
	anchor : '90%',
	enableKeyEvents:true,
	listeners:{
		'keydown':function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				var regno=field.getValue();
				Ext.Ajax.request({
					url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo&regno='+regno,
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							var value = jsonData.info;
							var arr = value.split("^");
							//基础信息
							field.setValue(arr[0]);
							Ext.getCmp('regnodetail').setValue(arr.slice(1));
						}
					},
					scope: this
				});
			}
		},
		'blur':function(field){
			if(field.getValue()==""){
				Ext.getCmp('regnodetail').setValue("");
			}
		}
	}
});
var regnodetail = new Ext.form.TextField({
	fieldLabel : '登记号信息',
	id : 'regnodetail',
	name : 'regnodetail',
	disabled:true,
	anchor : '90%'
});

var invono = new Ext.form.Checkbox({
	id: 'invono',
	hideLabel : true,
	boxLabel : '无发票号',
	anchor:'100%',
	checked:true,
	allowBlank:true
});
var paied = new Ext.form.Checkbox({
	id: 'paied',
	hideLabel : true,
	boxLabel : '仅结算',
	anchor:'100%',
	allowBlank:true
});
var byorddate = new Ext.form.Checkbox({
	id: 'byorddate',
	hideLabel : true,
	boxLabel : '按照医嘱日期',
	anchor:'100%',
	allowBlank:true
});

var findInputInvNo = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		InputInvNoGrid.removeAll();
		InputInvNoGrid.load();
	}
});
function paramsFn() {
	var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择起始日期!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择截止日期!");
			return false;
		}
		var locId = Ext.getCmp('ordlocField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择医嘱接收科室!");
			return false;
		}
		var vendor = Ext.getCmp('vendor').getValue();
		var regno = Ext.getCmp('regno').getValue();
		var invono = (Ext.getCmp('invono').getValue()==true?'1':'0');
		var paied = (Ext.getCmp('paied').getValue()==true?'1':'0');
		var byorddate = (Ext.getCmp('byorddate').getValue()==true?'1':'0');
		var strPar = startDate+"^"+endDate+"^"+locId+"^"+regno+"^"+invono+"^"+paied+"^"+byorddate+"^"+vendor;
	    return {
		'strPar': strPar
	};
	}
var updateInputInvNo = new Ext.Toolbar.Button({
	text:'保存发票信息',
    tooltip:'保存发票信息',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(InputInvNoGrid.activeEditor != null){
			InputInvNoGrid.activeEditor.completeEdit();
		} 
		var ListDetail="";
		var rowCount = InputInvNoGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = InputInvNoGrid.getStore().getAt(i);	
				//新增或数据发生变化时执行下述操作
				if(rowData.data.newRecord || rowData.dirty){					
					var orirowid=rowData.get("orirowid");
					var ingri = rowData.get("ingri");
					var invno =rowData.get("invno")
					var invdate =Ext.util.Format.date(rowData.get("invdate"),ARG_DATEFORMAT);
					var invamt =rowData.get("invamt")
					var IngriModify = rowData.get('IngriModify')
					var str = orirowid + "^" + ingri + "^"	+ invno + "^" + invdate + "^"+ invamt
							+ "^" + IngriModify;
					if(ListDetail==""){
						ListDetail=str;
					}
					else{
						ListDetail=ListDetail+RowDelim+str;
					}
				}
			}
			if(ListDetail==""){
				Msg.info("error", "没有需要保存的数据!");
				return false;
			}
			var url = "dhcstm.inputinvnoaction.csp?actiontype=Save";
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{ListDetail:ListDetail},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 刷新界面
								findInputInvNo.handler()
								Msg.info("success", "保存成功!");
								// 7.显示入库单数据

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "高值信息保存失败!");
								}else {
									Msg.info("error", "入库明细保存失败：");
								}
								
							}
						},
						scope : this
					});
			
	}
});
// 保存按钮
var copybutton = new Ext.Button({
		text: '复制发票信息',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			try {
				var row = InputInvNoGrid.getSelectionModel().getSelectedCell()[0];
				var INVno = InputInvNoGrid.getAt(row - 1).get('invno');
				var INVdate = InputInvNoGrid.getAt(row - 1).get('invdate');
				InputInvNoGrid.getAt(row).set("invno", INVno);
				InputInvNoGrid.getAt(row).set("invdate", INVdate);
				var col = GetColIndex(InputInvNoGrid, 'invno');
				if (row + 1 < InputInvNoGrid.getCount()) {
					InputInvNoGrid.startEditing(row + 1, col);
				}
			} catch (e) {}
		}
	});

var clearInputInvNo = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('regno').setValue("");
		Ext.getCmp('vendor').setValue("");
		Ext.getCmp('regnodetail').setValue('');
		Ext.getCmp('ordlocField').setValue("");
		Ext.getCmp('invono').setValue(true);
		Ext.getCmp('paied').setValue(false);
		Ext.getCmp('byorddate').setValue(false);
		Ext.getCmp('startDateField').setValue(new Date());
		Ext.getCmp('endDateField').setValue(new Date());
		
		InputInvNoGrid.removeAll();
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:'发票号补录',
    tbar:[findInputInvNo,'-',updateInputInvNo,'-',clearInputInvNo,'-',copybutton],
	items : [{
		xtype : 'fieldset',
		title : '条件选项',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults : {border:false,xtype:'fieldset'},
		items : [{
				columnWidth : .2,
				items : [startDateField,endDateField]
			}, {
				columnWidth : .25,
				labelWidth : 100,
				items : [vendor,ordlocField]
			}, {
				columnWidth : .22,
				items : [regno,regnodetail]
			}, {
				columnWidth : .18,
				labelWidth : 100,
				items : [invono,byorddate]
			}, {
				columnWidth : .15,
				items : [paied]
		}]
	}]
});

var InputInvNoGrid="";
//配置数据源
var InputInvNoGridUrl = 'dhcstm.inputinvnoaction.csp';

//模型
var InputInvNoGridCm = [
	 {
        header:"供应商",
        dataIndex:'vendor',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"物资代码",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
        dataIndex:'desc',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"物资条码",
        dataIndex:'barcode',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"发票号",
        dataIndex:'invno',
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
			id:'invnoField',
            //allowBlank:false,
            selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InputInvNoGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(InputInvNoGrid,"invdate");
						InputInvNoGrid.startEditing(cell[0], col);
					}
				}
			}
        })
    },{
        header:"发票日期",
        dataIndex:'invdate',
        width:80,
        align:'left',
        sortable:true,
        renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			id:'invdateField',
			
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InputInvNoGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(InputInvNoGrid,"invamt");
						InputInvNoGrid.startEditing(cell[0], col);
					}
				}
			}
        })
      },{
        header:"发票金额",
        dataIndex:'invamt',
        width:100,
        align:'right',
        sortable:true,
        editor: new Ext.form.NumberField({
			id:'invamtField',
            //allowBlank:false,
            selectOnFocus:true,
            allowNegative:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InputInvNoGrid.getSelectionModel().getSelectedCell();
						if(cell[0]+1<InputInvNoGrid.store.getCount()){
							var col=GetColIndex(InputInvNoGrid,"invno");
							InputInvNoGrid.startEditing(cell[0]+1, col);
						}
					}
				}
			}
        })
  },{
        header:"入库单号",
        dataIndex:'ingno',
        width:150,
        align:'left',
        sortable:true
   },{
        header:"补录入库子表Dr",
        dataIndex:'IngriModify',
        width:60,
        hidden:true
   },{
        header:"补录入库单号",
        dataIndex:'IngriModifyNo',
        width:150,
        align:'left',
        sortable:true
   },{
        header:"生成日期",
        dataIndex:'dateofmanu',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"医嘱日期",
        dataIndex:'orddate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"医嘱时间",
        dataIndex:'ordtime',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"数量",
        dataIndex:'qty',
        width:40,
        align:'right',
        sortable:true
    },{
        header:"单位",
        dataIndex:'uomdesc',
        width:40,
        align:'left'
    },{
        header:"进价",
        dataIndex:'rp',
        width:50,
        align:'right',
        sortable:true
   },{
        header:"病区",
        dataIndex:'ward',
        width:100,
        align:'left',
        sortable:true
     
   },{
        header:"厂商",
        dataIndex:'manf',
        width:100,
        align:'left',
        sortable:true
   },{
        header:"患者登记号",
        dataIndex:'pano',
        width:100,
        align:'left',
        sortable:true
   },{
        header:"患者姓名",
        dataIndex:'paname',
        width:60,
        align:'left',
        sortable:true
   },{
        header:"医生",
        dataIndex:'doctor',
        width:60,
        align:'left',
        sortable:true
   },{
        header:"接收科室",
        dataIndex:'admloc',
        width:100,
        align:'left',
        sortable:true
	},{
        header:"中间表Id",
        dataIndex:'orirowid',
        width:100,
        align:'left',
        hidden:true,
        sortable:true
    },{
        header:"入库单id",
        dataIndex:'ingri',
        width:100,
        align:'left',
        hidden:true,
        sortable:true
    }
];
//初始化默认排序功能
InputInvNoGridCm.defaultSortable = true;
function cellSelectFn(sm, rowIndex, colIndex) {
}



var InputInvNoGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'center',
		id: 'InputInvNoGrid',
		contentColumns: InputInvNoGridCm,
		smRowSelFn: cellSelectFn,
		singleSelect: false,
		selectFirst: false,
		actionUrl: InputInvNoGridUrl,
		queryAction: "find",
		paramsFn: paramsFn,
		paging: false, //2015-12
		showTBar : false
})
//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,InputInvNoGrid],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=============================================