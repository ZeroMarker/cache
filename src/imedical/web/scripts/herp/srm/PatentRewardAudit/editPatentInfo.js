// JavaScript Document
/////////////////////修改功能/////////////////////
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
var rawValue = "";
editFun = function(InventorsIDs) {
	//alert(InventorsIDs);
	
	
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}

	///////////////////////专利名称//////////////////////////////
var eNameField = new Ext.form.TextField({
	id:'Name',
	width:180,
	fieldLabel: '专利名称',
	allowBlank: false,
	name:'Name',
	emptyText:'专利名称...',
	anchor: '95%'
});

	

/////////////////科室///////////////////////
var eDeptsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


eDeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptDr').getRawValue()),
	method:'POST'});
});

var eDeptFields = new Ext.form.ComboBox({
	id: 'DeptDr',
	fieldLabel: '科室',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:eDeptsDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'DeptDr',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



/////////////////专利发明人///////////////////////////
var eInventorssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


eInventorssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventors').getRawValue()),
	method:'POST'});
});

var eInventorsFields = new Ext.form.ComboBox({
	id: 'eInventors',
	fieldLabel: '专利发明人',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:eInventorssDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请重新选择专利发明人...',
	name: 'eInventors',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


///////////////////////证书号///////////////////////////
var eCertificateNoField = new Ext.form.TextField({
	id:'CertificateNo',
	fieldLabel: '证书号',
	width:180,
	allowBlank: false,
	name:'CertificateNo',
	emptyText:'证书号...',
	anchor: '95%'
});



////////////////////////授权日期///////////////////////
var eAnnDateFields = new Ext.form.DateField({
			fieldLabel: '授权公告日期',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			name:'AnnDate',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		

//////////////////////年度//////////////////////////////////
var eYearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearDr').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'YearDr',
	fieldLabel: '年度',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:eYearDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'YearDr',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



/////////////////专利权人///////////////////
var ePatenteesDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


ePatenteesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentee').getRawValue()),
	method:'POST'});
});

var ePatenteeFields = new Ext.form.ComboBox({
	id: 'Patentee',
	fieldLabel: '专利权人',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:ePatenteesDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请选择专利权人...',
	name: 'Patentee',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});





/////////////////////专利号//////////////////////////
var ePatentNumField = new Ext.form.TextField({
	id:'PatentNum',
    fieldLabel: '专利号',
	width:180,
    allowBlank: false,
	name:'PatentNum',
    emptyText:'专利号...',
    anchor: '95%'
	});
	


/////////////////申请日期///////////////////////
var eAppDateFields = new Ext.form.DateField({
			fieldLabel: '申请日期',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			name:'AppDate',
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});


/*
///////////////专利发明人多选框//////////////////
var eInventorsTextArea = new Ext.form.TextArea({
		id: 'eInventorsTextArea',
		name: 'eInventorsTextArea',
		autoScroll: true
	});
//////////////专利发明人的id//////////////////
var InventorsIDs = new Ext.form.TextField({
		id: 'InventorsIDs',
		name: 'InventorsIDs',
		width: 180,
		anchor: '95%'
	});
*/
//////////////////专利发明人///////////////////////
var InventorsGrid = new Ext.grid.GridPanel({
		id:'InventorsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=InventorID&start='+0+'&limit='+25+'&InventorsIDs='+InventorsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
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
    width: 260,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个发明人按钮////////////////
var eaddInventors  = new Ext.Button({
		text: '添加',
		handler: function(){
			var InventorId;
			var id = Ext.getCmp('eInventors').getValue();
			var InventorName = Ext.getCmp('eInventors').getRawValue();
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
		}
	});	
var edelInventors = new Ext.Button({
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
				/*
					grid.getSelectionModel().getSelected();//获取选中的第一条记录,返回record类型
					grid.getSelectionModel().getSelections();//获取选中的全部记录,返回一个数组,里面全是record类型
					
					grid.store.remove(record);//参数是record类型的,移除该数据
					grid.store.removeAt(rowIndex);//参数是行数,移除该行
					grid.store.removeAll();//移除全部数据
					
					有了上面这些,删除就简单了
					删除选中的第一条记录
					grid.store.remove(grid.getSelectionModel().getSelected());
					删除选中的全部记录
					var records = grid.getSelectionModel().getSelections();
					for(var i = 0,len = records.length;i<len;i++ ){
							grid.store.remove(records[i]);
					}
				*/
				 //InventorsGrid.getView().refresh();
				 //InventorsGrid.load({params:{start:0,limit:25,InventorsIDs:InventorsIDs}});
				 //alert(myRowid);	 
			}
			//alert(InventorsGrid.getColumnModel( ).getDataIndex(0).length);
			var total = InventorsGrid.getStore().getCount();
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				}
			}
		}
	});
	
	// create form panel
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
					//autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
			
					  /* eNameField,  
					  eDeptFields,
					   eInventorsFields,
					   eCertificateNoField,
					   eAnnDateFields*/
					   
					   eNameField,  
					   eDeptFields,
					   InventorsGrid,
					   //eInventorsTextArea,
					   eInventorsFields,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},eaddInventors,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},edelInventors]
						}
					   //eaddInventors,
					   //edelInventors					   
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
						/*eYearField,
						ePatenteeFields,
						ePatentNumField,
						eAppDateFields	*/	
						eYearField,
						ePatenteeFields,
						ePatentNumField,
						eAppDateFields,
						eCertificateNoField,
					    eAnnDateFields											
					]
				 }]
		}
	]		
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 80,
	frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			//InventorsGrid.load();
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '修改专利成果申请信息',
    width: 600,
    height:355,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '保存', 
      handler: function() {
      	// check form value
      		var Name = eNameField.getValue();
			var dept = rowObj[0].get("DeptDr");
      		var DeptDr = eDeptFields.getValue();
			var invent = rowObj[0].get("Inventors");
			var total = InventorsGrid.getStore().getCount();
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				};
			}
			var Inventors = rawValue;
			//alert(Inventors+"   "+invent+"   "+rawValue);
      		var CertificateNo = eCertificateNoField.getValue();
			//var AnnDate = eAnnDateFields.getValue().format("Y-m-d");
			var year = rowObj[0].get("YearDr");
      		var YearDr = eYearField.getValue();
			var patent = rowObj[0].get("Patentee");
			var Patentee = ePatenteeFields.getValue();
			var PatentNum = ePatentNumField.getValue();
      		//var AppDate = eAppDateFields.getValue().format("Y-m-d");
        	
			Name = Name.trim();
      		DeptDr =DeptDr.trim();
			YearDr =YearDr.trim();
			Patentee =Patentee.trim();
      		CertificateNo = CertificateNo.trim();
      		
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
      		 if(DeptDr==dept){DeptDr=""};
			 if(Inventors==invent){Inventors=""};
			 if(YearDr==year){YearDr=""};	
			 if(Patentee==patent){Patentee=""};	
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  'herp.srm.srmpatentrewardauditexe.csp?action=edit&rowid='+myRowid+'&Name='+encodeURIComponent(Name)+'&DeptDr='+encodeURIComponent(DeptDr)+'&Inventors='+Inventors+'&CertificateNo='+CertificateNo+'&AnnDate='+AnnDate+'&YearDr='+YearDr+'&Patentee='+Patentee+'&PatentNum='+PatentNum+'&AppDate='+AppDate,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info!=0) message='信息修改有误!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后保存。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: '取消',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
