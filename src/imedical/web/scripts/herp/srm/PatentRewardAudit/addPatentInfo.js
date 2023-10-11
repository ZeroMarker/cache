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
var NameField = new Ext.form.TextField({
	id:'NameField',
	width:180,
	fieldLabel: '专利名称',
	allowBlank: false,
	emptyText:'专利名称...',
	anchor: '95%'
});
	

/////////////////科室///////////////////////
var DeptsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


DeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '科室',
	width:170,
	listWidth : 220,
	allowBlank: true,
	store:DeptsDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'DeptFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



/////////////////专利发明人///////////////////////////
var InventorssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


InventorssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorsss').getRawValue()),
	method:'POST'});
});

var InventorsFields = new Ext.form.ComboBox({
	id: 'Inventorsss',
	fieldLabel: '专利发明人',
	width:170,
	listWidth : 220,
	allowBlank: true,
	store:InventorssDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请选择专利发明人...',
	name: 'Inventorsss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


///////////////////////证书号///////////////////////////
var CertificateNoField = new Ext.form.TextField({
	id:'CertificateNoField',
	fieldLabel: '证书号',
	width:180,
	allowBlank: false,
	emptyText:'证书号...',
	anchor: '95%'
});



////////////////////////授权日期///////////////////////
var AnnDateFields = new Ext.form.DateField({
			fieldLabel: '授权公告日期',
			width:170,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		

//////////////////////年度//////////////////////////////////
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),
	method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '年度',
	width:170,
	listWidth : 220,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



/////////////////专利权人///////////////////
var PatenteesDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


PatenteesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patenteess').getRawValue()),
	method:'POST'});
});

var PatenteeFields = new Ext.form.ComboBox({
	id: 'Patenteess',
	fieldLabel: '专利权人',
	width:170,
	listWidth : 220,
	allowBlank: true,
	store:PatenteesDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请选择专利权人...',
	name: 'Patenteess',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});





/////////////////////专利号//////////////////////////
var PatentNumField = new Ext.form.TextField({
	id:'PatentNumField',
    fieldLabel: '专利号',
	width:180,
    allowBlank: false,
    emptyText:'专利号...',
    anchor: '95%'
	});
	
	




/////////////////申请日期///////////////////////
var AppDateFields = new Ext.form.DateField({
			fieldLabel: '申请日期',
			width:170,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});


/*
///////////////专利发明人多选框//////////////////
var InventorsTextArea = new Ext.form.TextArea({
		id: 'InventorsTextArea',
		name: 'InventorsTextArea',
		autoScroll: true
	});
	
	
///////////////添加多个发明人按钮////////////////
var addInventors  = new Ext.Button({
		text: '添加',
		handler: function(){
			var rawName = Ext.getCmp('Inventorsss').getRawValue();
			var a = Ext.getCmp('Inventorsss').getValue();
			if(Ext.getCmp('InventorsTextArea').getRawValue()==""){
				Ext.getCmp('InventorsTextArea').setRawValue(rawName);
				rawValue = a;
			}else{
				rawValue = rawValue +","+ a;
				
				Ext.getCmp('InventorsTextArea').setRawValue(Ext.getCmp('InventorsTextArea').getRawValue()+'\n'+rawName);
			};
		}
	});
*/

//////////////////专利发明人///////////////////////
var InventorsGrid = new Ext.grid.GridPanel({
		id:'InventorsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		/*proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=InventorID&start='+0+'&limit='+25+'&InventorsIDs='+InventorsIDs,
		method:'POST'}),*/
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'rowid'},  
			 {name: 'Name'}
         ])  
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '发明人ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '发明人名称', dataIndex: 'Name',align:'center',width: 258}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 257,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个发明人按钮////////////////
var addInventors  = new Ext.Button({
		text: '添加',
		handler: function(){
			var InventorId;
			var id = Ext.getCmp('Inventorsss').getValue();
			//alert(id);
			var InventorName = Ext.getCmp('Inventorsss').getRawValue();
			var total = InventorsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = InventorsGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							InventorId=id;
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
				}else{
					InventorId=id;
				}	
			}
			var data = new Ext.data.Record({'rowid':InventorId,'Name':InventorName});
			InventorsGrid.stopEditing(); 
			InventorsGrid.getStore().insert(0,data);
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
		text:'删除',
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
							columnWidth : .1
						},
			
					   NameField,  
					   DeptFields,
					   //InventorsTextArea,
					   //addInventors
					   InventorsGrid,
					   InventorsFields,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addInventors,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},delInventors]
						}
					   //addInventors,
					   //delInventors
					  
					  
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
						YearField,
						PatenteeFields,
						PatentNumField,
						AppDateFields,
						CertificateNoField,
					    AnnDateFields												
					]
				 }]
		}
	]		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    labelWidth: 80,
	frame: true,
    items: colItems
	});
    
  // define window and show it in desktop
  var addWindow = new Ext.Window({
  	title: '添加专利成果',
    width: 600,
    height:355,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '保存', 
      handler: function() {
      		// check form value
      		var Name = NameField.getValue();
      		var DeptDr = DeptFields.getValue();
			var total = InventorsGrid.getStore().getCount();
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				};
			}
			var Inventors = rawValue;
      		var CertificateNo = CertificateNoField.getValue();
			var AnnDate = AnnDateFields.getValue();
      		var YearDr = YearField.getValue();
			var Patentee = PatenteeFields.getValue();
			var PatentNum = PatentNumField.getValue();
      		var AppDate = AppDateFields.getValue();
        	
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
      		if(DeptDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'科室为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Inventors=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'专利发明人为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(CertificateNo=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'证书号为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(AnnDate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'授权公告日期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(YearDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Patentee=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'专利权人为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(PatentNum=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'专利号为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(AppDate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'申请日期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'herp.srm.srmpatentrewardauditexe.csp?action=add&Name='+encodeURIComponent(Name)+'&Inventors='+Inventors+'&CertificateNo='+CertificateNo+'&AnnDate='+AnnDate+'&YearDr='+YearDr+'&Patentee='+Patentee+'&PatentNum='+PatentNum+'&AppDate='+AppDate+'&userdr='+userdr+'&DeptDr='+DeptDr,
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
				text: '取消',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};
