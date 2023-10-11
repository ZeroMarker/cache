var userdr = session['LOGON.USERCODE'];
var rawValue = "";
Date.dayNames = ["日", "一", "二", "三", "四", "五", "六"];  
    Date.monthNames=["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "今天",  
            minText: "日期在最小日期之前",  
            maxText: "日期在最大日期之后",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '下月 (Control+Right)',  
            prevText: '上月 (Control+Left)',  
            monthYearText: '选择一个月 (Control+Up/Down 来改变年)',  
            todayTip: "{0} (Spacebar)",  
            okText: "确定",  
            cancelText: "取消" 
        });  
    } 
/////////////////添加功能/////////////////
addFun = function() {
///////////////////////专利名称//////////////////////////////
var NameField = new Ext.form.TextArea({
	id:'NameField',
	width:180,
	fieldLabel: '专利名称',
	allowBlank: false,
	labelSeparator:''
	//emptyText:'专利名称...'
	//anchor: '95%'
});
var PatentTypeDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '发明专利'], ['2', '实用新型专利'], ['3', '外观设计专利']]
		});
var PatentTypeField = new Ext.form.ComboBox({
            id: 'PatentType',
			fieldLabel : '专利类别',
			width : 180,
			listWidth : 180,
			allowBlank: false,
			store : PatentTypeDs,
			valueField : 'key',
			displayField : 'keyValue',
			//emptyText : '请选择类别',
			//pageSize : 10,
			minChars : 1,
			name:'PatentType',
			selectOnFocus : true,
			forceSelection : true,
			mode : 'local', // 本地模式
			triggerAction : 'all',
			labelSeparator:''
		});
/////////////////科室///////////////////////
var DeptsDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '科室',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:DeptsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科室...',
	name: 'DeptFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

///////////////////////证书号///////////////////////////
var CertificateNoField = new Ext.form.TextField({
	id:'CertificateNoField',
	fieldLabel: '证书号',
	width:180,
	allowBlank: false,
	labelSeparator:''
	//emptyText:'证书号...'
	//anchor: '95%'
});



////////////////////////授权日期///////////////////////
var AnnDateFields = new Ext.form.DateField({
			fieldLabel: '授权公告日期',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true',
			labelSeparator:''
		});
		
		
/////////////////公布单位///////////////////////
var AnnUintDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


AnnUintDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('AnnUintFields').getRawValue()),
	method:'POST'});
});

var AnnUintFields = new Ext.form.ComboBox({
	id: 'AnnUintFields',
	fieldLabel: '公布单位',
	width:180,
	listWidth : 260,
	allowBlank: false,
	store: AnnUintDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择公布单位...',
	name: 'AnnUintFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

//////////////////////年度//////////////////////////////////
var YearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),
	method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '年度',
	width:180,
	listWidth : 260,
	allowBlank: false,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});



/////////////////专利权人///////////////////
var PatenteesDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PatenteesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patenteess').getRawValue()),
	method:'POST'});
});

var PatenteeFields = new Ext.form.ComboBox({
	id: 'Patenteess',
	fieldLabel: '专利权人',
	width:180,
	listWidth : 260,
	allowBlank: false,
	store:PatenteesDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择专利权人...',
	name: 'Patenteess',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

/////////////////////专利号//////////////////////////
var PatentNumField = new Ext.form.TextField({
	id:'PatentNumField',
    fieldLabel: '专利号',
	width:180,
    allowBlank: false,
	labelSeparator:''
    //emptyText:'专利号...'
    //anchor: '95%'
	});
	
/////////////////申请日期///////////////////////
var AppDateFields = new Ext.form.DateField({
			fieldLabel: '申请日期',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true',
			labelSeparator:''
		});
//////////////////////////////专利发明人ID、位次、是否本院///////////////////////////////////
/////////////////专利发明人///////////////////////////
var InventorssDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

InventorssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorsss').getRawValue()),
	method:'POST'});
});

var InventorsFields = new Ext.form.ComboBox({
	id: 'Inventorsss',
	fieldLabel: '专利发明人',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:InventorssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择专利发明人...',
	name: 'Inventorsss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
///////////////////作者位次/////////////////////////////  
var InventorsRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '第一'],['2', '第二'], ['3', '第三'], ['4', '第四'], ['5', '第五'],['6', '第六'],['7', '第七'],['8', '第八']]
	});		
		
var InventorsRangeCombox = new Ext.form.ComboBox({
	                   id : 'InventorsRangeCombox',
		           fieldLabel : '位次',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : InventorsRangeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
///////////////////是否本院/////////////////////////////  
var IsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '是'],['0', '否']]
	});		
		
var IsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'IsTheHosCombox',
		           fieldLabel : '是否本院',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '参与专利发明时是否为本院人员',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
					
//////////////////专利发明人GridPanel///////////////////////
var InventorsGrid = new Ext.grid.GridPanel({
		id:'InventorsGrid',
    store: new Ext.data.Store({
    //autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		/*proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=InventorID&start='+0+'&limit='+25+'&InventorsIDs='+InventorsIDs,
		method:'POST'}),*/
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'rowid'},  
			 {name: 'name'},
			 {name: 'rangerowid'},  
			 {name: 'range'},
			 {name: 'isthehosrowid'},  
			 {name: 'isthehos'}
         ])  
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '发明人ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '发明人名称', dataIndex: 'name',align:'center',width: 100},
            {id: 'rangerowid', header: '位次ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '位次', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '是否本院ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '是否本院', dataIndex: 'isthehos',align:'center',width: 80}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 285,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个发明人按钮////////////////
var addInventors  = new Ext.Button({
		text: '增加',iconCls: 'edit_add',
		handler: function(){
			var InventorId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('Inventorsss').getValue();
			var rangeid = Ext.getCmp('InventorsRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			var InventorName = Ext.getCmp('Inventorsss').getRawValue();
			var InventorsRange = Ext.getCmp('InventorsRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			//var firstauthor = FristAuthor.getValue();
			
			var total = InventorsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = InventorsGrid.getStore().getAt(i).get('rowid');
					var tmprange = InventorsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							if(tmprange==InventorsRange)
							{
								Ext.Msg.show({title:'错误',msg:'不同的发明人您选择了相同的位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
						    InventorId=id;
						    RangeId=rangeid;
						    IsTheHosId=isthehosid;
						  }
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的发明人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的发明人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				
					if(InventorsRange=="")
							{
								Ext.Msg.show({title:'错误',msg:'请选择发明人位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							
							if(IsTheHos=="")
							{
								Ext.Msg.show({title:'错误',msg:'请选择是否为本院人员!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
				
				
				else{
					InventorId=id;
					RangeId=rangeid;
					IsTheHosId=isthehosid;
				}	
			}
			var data = new Ext.data.Record({'rowid':InventorId,'name':InventorName,'rangerowid':RangeId,'range':InventorsRange,'isthehosrowid':IsTheHosId,'isthehos':IsTheHos});
			InventorsGrid.stopEditing(); 
			InventorsGrid.getStore().insert(total,data);
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delInventors = new Ext.Button({
		text:'删除',iconCls: 'edit_remove',
		handler: function() {  
			var rows = InventorsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = InventorsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				InventorsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}

			var total = InventorsGrid.getStore().getCount();
			//alert(total);
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				}
			}
			
		}
	});
/////////////////第几完成单位///////////////////////////
var CompleteUnitStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','第一完成单位'],['2','第二完成单位'],['3','第三完成单位'],['4','第四完成单位'],['5','第五完成单位'],['6','第六完成单位'],['7','第七完成单位'],['8','第八完成单位']]
});

var CompleteUnitField = new Ext.form.ComboBox({
	id: 'CompleteUnitField',
	fieldLabel: '我院单位位次',
	width:180,
	//anchor: '95%',
	listWidth : 180,
	allowBlank:false,
	store:CompleteUnitStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'请选择我院单位位次...',
	mode : 'local',
	name: 'CompleteUnitField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''
});
///////////////////发票代码/////////////////////////////  
var InvoiceCodeField = new Ext.form.NumberField({
				fieldLabel: '发票代码',
				width:180,
				allowBlank : true, 
				disabled:false,
				//anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''
});	
///////////////////发票号码/////////////////////////////  
var InvoiceNoField = new Ext.form.NumberField({
				fieldLabel: '发票号码',
				width:180,
				allowBlank : true, 
				disabled:false,
				//anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''
});		
///////////////////申请报销/////////////////////////////  
var PageChargeField = new Ext.form.NumberField({
				fieldLabel: '申请报销',
				width:180,
				allowBlank: true,
				disabled:false,
				//anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''
});

////////////////////货币单位/////////////////////////////
var UnitMoneyStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['R','人民币'],['D','美元'],['E','欧元'],['P','英镑']]
});

var UnitMoneyField = new Ext.form.ComboBox({
	id: 'UnitMoneyField',
	fieldLabel: '货币单位',
	width:180,
	//anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:UnitMoneyStore,
	valueField: 'key',
	displayField: 'keyvalue',
	value:'R',
	triggerAction: 'all',
	//emptyText:'请选择货币单位...',
	mode : 'local',
	name: 'UnitMoneyField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''
});

////课题名称
var PrjNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
PrjNameDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('PrjNameField').getRawValue()),
						method : 'POST'
					});
		});
var PrjNameField = new Ext.form.ComboBox({
	        id:'PrjNameField',
			fieldLabel : '依托项目',
			width : 180,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : PrjNameDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // 本地模式
			name:'PrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
		});

///院外依托课题
var OutPrjNameField = new Ext.form.TextField({
	fieldLabel:'依托项目(院外)',
	width : 180,
	allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''
});
		
var colItems =	[
		{
			layout: 'column',
			border: false,
			defaults: {
				columnWidth: '.5',
				bodyStyle:'padding:5px 5px 0',
				border: false
			},            
			items: [
				{
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .05
						},
			           YearField,
					   PatenteeFields,
					   NameField,  
					   PatentTypeField,
					   //DeptFields,
					   InventorsGrid,
					   InventorsFields,
					   InventorsRangeCombox,
					   IsTheHosCombox,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [
							{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addInventors,{
							xtype : 'displayfield',
							
							columnWidth : .1
							},delInventors,
							{
							    xtype : 'displayfield',
							    columnWidth : .07
							}]
						},
						{
							columnWidth : 1,
						    xtype : 'panel',
						    layout : "column",
						    items : [
							{
							xtype : 'displayfield',
							value : ' *请添加全部发明人！外院人员无需添加！',
							columnWidth : 1,
							style:'color:red;'
							}
							]
						}
					]
				}, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
						PatentNumField,
						AppDateFields,
						CertificateNoField,
					    AnnDateFields,
					    AnnUintFields,
					    CompleteUnitField,
                        PageChargeField,
						UnitMoneyField,
						InvoiceCodeField,
						InvoiceNoField,
						PrjNameField							
					]
				 }]
		}
	]		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    labelWidth: 100,
	labelAlign:'right',
	frame: true,
    items: colItems
	});
    
  // define window and show it in desktop
  var allauthorinfo="";
  var addWindow = new Ext.Window({
  	title: '增加专利奖励申请信息',
	iconCls: 'edit_add',
    width: 640,
    height:560,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '保存',iconCls: 'save', 
      handler: function() {
      		// check form value
      var Name = NameField.getValue();
      var PatentType = PatentTypeField.getValue();
      //var DeptDr = DeptFields.getValue();
			var DeptDr="";
			var inventorscount = InventorsGrid.getStore().getCount();
			  if(inventorscount>0){
				var authorid = InventorsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = InventorsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = InventorsGrid.getStore().getAt(0).get('isthehosrowid');
				allauthorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<inventorscount;i++){
				  var authorid = InventorsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = InventorsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = InventorsGrid.getStore().getAt(i).get('isthehosrowid');
				  var authorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  allauthorinfo = allauthorinfo+","+authorinfo;
				   };
			   }
			   
			var Inventors = allauthorinfo;
      var CertificateNo = CertificateNoField.getValue();
			var AnnDate = AnnDateFields.getRawValue();
      var YearDr = YearField.getValue();
			var Patentee = PatenteeFields.getValue();
			var PatentNum = PatentNumField.getValue();
      var AppDate = AppDateFields.getRawValue();
      var AnnUnit = AnnUintFields.getValue();
      var CompleteUnit = CompleteUnitField.getValue();	
	   var VCAmount=PageChargeField.getValue();
	   var unitMoney=UnitMoneyField.getValue();
	   var InvoiceCode=InvoiceCodeField.getValue();
	   var InvoiceNo=InvoiceNoField.getValue();
	   
	   var prjdr = PrjNameField.getValue(); ///libairu20160913北京丰台
	   
			Name = Name.trim();
      DeptDr = DeptDr.trim();
			Inventors = Inventors.trim();
      CertificateNo = CertificateNo.trim();
      YearDr = YearDr.trim();
			Patentee = Patentee.trim();
			PatentNum = PatentNum.trim();
      		
      		
      if(Name=="")
      {
      	Ext.Msg.show({title:'错误',msg:'专利名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      if(CertificateNo=="")
      {
      	Ext.Msg.show({title:'错误',msg:'证书号为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
			if(PatentNum=="")
      {
      	Ext.Msg.show({title:'错误',msg:'专利号为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      
      		if(InventorsGrid.getStore().getCount()<1)
      {
      	Ext.Msg.show({title:'错误',msg:'请选择专利发明人',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      
	  
	  
        	if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: projUrl+'?action=add&Name='+encodeURIComponent(Name)+'&Inventors='+Inventors+'&CertificateNo='+CertificateNo+'&AnnDate='+AnnDate+'&YearDr='+YearDr+'&Patentee='+Patentee+'&PatentNum='+PatentNum+'&AppDate='+AppDate+'&userdr='+userdr+'&DeptDr='+DeptDr+'&PatentType='+PatentType+'&AnnUnit='+AnnUnit+'&CompleteUnit='+CompleteUnit+'&VCAmount='+VCAmount+'&InvoiceCode='+InvoiceCode+'&InvoiceNo='+InvoiceNo+'&unitMoneys='+unitMoney+'&PrjDr='+prjdr,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  itemGrid.load({params:{start:0, limit:25}});
									addWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepNum') message='输入的专利号已经存在!';	
									if(jsonData.info=='RepName') message='输入的专利名称已经存在!';	
									if(jsonData.info=='RepInvoice') message='输入的报销号已经存在!';	
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: '关闭',iconCls : 'cancel',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};
