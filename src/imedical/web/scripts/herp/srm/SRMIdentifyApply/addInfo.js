var usercode = session['LOGON.USERCODE'];
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
///////////////////类型/////////////////////////////  
var aTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var aTypeCombox = new Ext.form.ComboBox({
	                   id : 'aTypeCombox',
		           fieldLabel : '类型',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
				   labelSeparator:'',
		           forceSelection : true
});		
///////////////////////鉴定名称//////////////////////////////
var NameField = new Ext.form.TextArea({
	id:'NameField',
	width:180,
	fieldLabel: '项目名称',
	allowBlank: false,
	labelSeparator:''
	// emptyText:'项目名称...'
	//anchor: '95%'
});
////////////////////////鉴定级别//////////////////////////
var IdentifyLevelStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '国际先进'], ['2', '国际领先'], ['3', '国内先进'], ['4', '国内领先']]
		});
var IdentifyLevelField = new Ext.form.ComboBox({
            id: 'IdentifyLevelField',
			fieldLabel : '鉴定级别',
			width : 180,
			listWidth : 180,
			allowBlank: false,
			store : IdentifyLevelStore,
			valueField : 'key',
			displayField : 'keyValue',
			// emptyText : '请选择类别',
			//pageSize : 10,
			minChars : 1,
			name:'IdentifyLevelField',
			selectOnFocus : true,
			forceSelection : true,
			mode : 'local', // 本地模式
			labelSeparator:'',
			triggerAction : 'all'
		});
/////////////////鉴定单位///////////////////////////
var addIdentifyUnitDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


addIdentifyUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('addIdentifyUnitField').getRawValue()),
	method:'POST'});
});

var addIdentifyUnitField = new Ext.form.ComboBox({
	id: 'addIdentifyUnitField',
	fieldLabel: '鉴定单位',
	width:180,
	listWidth : 260,
	allowBlank: false,
	store:addIdentifyUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择鉴定单位...',
	name: 'addIdentifyUnitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});
////////////////////////鉴定日期///////////////////////
var IdentifyDateFields = new Ext.form.DateField({
            id:'IdentifyDateFields',
			fieldLabel: '鉴定日期',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			labelSeparator:'',
			selectOnFocus:'true'
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
	// emptyText:'请选择年度...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});

/////////////////////备注//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '备注',
	width:180,
    allowBlank: true,
	labelSeparator:''
    // emptyText:'备注...'
    //anchor: '95%'
	});

//////////////////////////////参与人ID、位次、是否本院///////////////////////////////////
/////////////////参与人///////////////////////////
var ParticipantStore = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

ParticipantStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUser&str='+encodeURIComponent(Ext.getCmp('ParticipantsFields').getRawValue()),
	method:'POST'});
});

var ParticipantsFields = new Ext.form.ComboBox({
	id: 'ParticipantsFields',
	fieldLabel: '参与人员',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:ParticipantStore,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择参与人...',
	name: 'ParticipantsFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});
///////////////////参与人位次/////////////////////////////  
var ParticipantsRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '第一'],['2', '第二'], ['3', '第三'], ['4', '第四'], ['5', '第五'],['6', '第六'],['7', '第七'],['8', '第八']]
	});		
		
var ParticipantsRangeCombox = new Ext.form.ComboBox({
	                   id : 'ParticipantsRangeCombox',
		           fieldLabel : '人员位次',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : ParticipantsRangeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
				   labelSeparator:'',
		           selectOnFocus : true,
		           forceSelection : true
						  });	
///////////////////是否本院/////////////////////////////  
var IsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '本院职工'],['0', '外院人员'],['2','博士研究生'],['3','硕士研究生']]
	});		
		
var IsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'IsTheHosCombox',
		           fieldLabel : '参与人身份',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           // emptyText : '参与鉴定时身份...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:'',
				   listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
                                   ParticipantsRangeCombox.setValue('');
								   ParticipantsRangeCombox.disable();  //变为灰；不可编辑
                                   //ParticipantsRangeCombox.disabled=true;   //不变为灰；不可编辑	
                                   }				
                                   else{
								   ParticipantsRangeCombox.enable();  	
								   }								   
			}
	}	
});	
					
//////////////////专利发明人GridPanel///////////////////////
var ParticipantsGrid = new Ext.grid.GridPanel({
		id:'ParticipantsGrid',
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
            {id: 'rowid', header: '参与人ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '参与人名称', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: '位次ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '人员位次', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '参与鉴定时身份ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '参与人身份', dataIndex: 'isthehos',align:'center',width: 110}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 272,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个参与人按钮////////////////
var addParticipants = new Ext.Button({
		text: '增加',
		iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('ParticipantsFields').getValue();
			var rangeid = Ext.getCmp('ParticipantsRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			var Name = Ext.getCmp('ParticipantsFields').getRawValue();
			var ParticipantsRange = Ext.getCmp('ParticipantsRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			//var firstauthor = FristAuthor.getValue();
			
			var total = ParticipantsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = ParticipantsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						    if(isthehosid=="")
						   {
						   Ext.Msg.show({title:'错误',msg:'请选择参与鉴定时身份!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				    return;
						   }
						   else{
						  if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
							  Ext.Msg.show({title:'错误',msg:'请选择参与人员位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if((tmprange==ParticipantsRange)&&(tmprange!="")&&(ParticipantsRange!=""))
							{
								Ext.Msg.show({title:'错误',msg:'不同的参与人您选择了相同的位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
						    ParticipantsId=id;
						    RangeId=rangeid;
						    IsTheHosId=isthehosid;
						  }
						}
					}
				}
			}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的参与人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
			}
			}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的参与人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				
					if(isthehosid=="")
					{
					Ext.Msg.show({title:'错误',msg:'请选择参与课题时身份!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				    return;
					}
				if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
					{
					Ext.Msg.show({title:'错误',msg:'请选择参与人员位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
					}
				else{
					ParticipantsId=id;
					RangeId=rangeid;
					IsTheHosId=isthehosid;
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':Name,'rangerowid':RangeId,'range':ParticipantsRange,'isthehosrowid':IsTheHosId,'isthehos':IsTheHos});
			ParticipantsGrid.stopEditing(); 
			ParticipantsGrid.getStore().insert(total,data);
			if(total>0){
				rawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'删除',
		iconCls:'edit_remove',
		handler: function() {  
			var rows = ParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = ParticipantsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				ParticipantsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}

			var total = ParticipantsGrid.getStore().getCount();
			//alert(total);
			if(total>0){
				rawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
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
	allowBlank: false,
	store:CompleteUnitStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	// emptyText:'请选择我院单位位次...',
	mode : 'local',
	name: 'CompleteUnitField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	labelSeparator:'',
	editable:true
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
			emptyText : '',
			//mode : 'local', // 本地模式
			name:'PrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});

///院外依托课题
var OutPrjNameField = new Ext.form.TextField({
	fieldLabel:'依托科研课题(院外)',
	width : 170,
	allowBlank : true,
	selectOnFocus : true
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
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .05
						}, */
					   aTypeCombox,
			           YearField,
					   NameField,  
					   IdentifyLevelField,
					   addIdentifyUnitField,
					   IdentifyDateFields,
					   CompleteUnitField,
					   RemarkField,
					   PrjNameField
					]	 
				}, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						}, */
                       ParticipantsGrid,
					   ParticipantsFields,
					   IsTheHosCombox,
					   ParticipantsRangeCombox,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addParticipants,{
							xtype : 'displayfield',
							
							columnWidth : .1
							},delParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    }
							
							]
						},{
							columnWidth : 1,
						    xtype : 'panel',
						    layout : "column",
						    items : [
							{
							xtype : 'displayfield',
							value : ' *请添加全部项目人员!外院人员无需添加!',
							columnWidth : 1,
							style:'color:red;'
							}
							]
						}
						
						 						
					]
				 }]
		}
	]		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    labelWidth: 90,
	labelAlign:'right',
	frame: true,
    items: colItems
	});
    
  // define window and show it in desktop
  var allauthorinfo="";
  var addWindow = new Ext.Window({
  	title: '新增科研鉴定申请',
	iconCls: 'edit_add',
    width: 650,
    height:400,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '保存',
		iconCls: 'save',
      handler: function() {
      		// check form value
	  var Year = YearField.getValue();
      var Name = NameField.getValue();
	  
	  var inventorscount = ParticipantsGrid.getStore().getCount();
	    if(inventorscount>0){
			var authorid = ParticipantsGrid.getStore().getAt(0).get('rowid');
			var authorrangeid = ParticipantsGrid.getStore().getAt(0).get('rangerowid');
			var authoristhehosid = ParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
			allauthorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
			for(var i=1;i<inventorscount;i++){
				var authorid = ParticipantsGrid.getStore().getAt(i).get('rowid');
				var authorrangeid = ParticipantsGrid.getStore().getAt(i).get('rangerowid');
				var authoristhehosid = ParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				var authorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				allauthorinfo = allauthorinfo+","+authorinfo;
				};
		}
			   
	  var Participants = allauthorinfo;
      var IdentifyLevel = IdentifyLevelField.getValue();
	  var IdentifyUnit = addIdentifyUnitField.getValue();
      var IdentifyDate = IdentifyDateFields.getRawValue();
	  var CompleteUnit = CompleteUnitField.getValue();
	  var Remark = RemarkField.getValue();
      var Type = aTypeCombox.getValue();
      
      var prjdr = PrjNameField.getValue(); ///libairu20160913北京丰台
	  
	  Year = Year.trim();
	  Name = Name.trim();
      Participants = Participants.trim();
	  IdentifyLevel = IdentifyLevel.trim();
      IdentifyUnit = IdentifyUnit.trim();
      //IdentifyDate = IdentifyDate.trim();
	  CompleteUnit = CompleteUnit.trim();
	  Remark = Remark.trim();
      		
      
	  if(Type=="")
      {
      	Ext.Msg.show({title:'错误',msg:'类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      if(Name=="")
      {
      	Ext.Msg.show({title:'错误',msg:'鉴定名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      
        if(ParticipantsGrid.getStore().getCount()<1)
      {
      	Ext.Msg.show({title:'错误',msg:'请选择项目参与人员',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      
      
      if (addFormPanel.form.isValid()) {
		Ext.Ajax.request({
		url: projUrl+'?action=add&Year='+encodeURIComponent(Year)+'&Name='+encodeURIComponent(Name)+'&Participants='+encodeURIComponent(Participants)+'&IdentifyLevel='+encodeURIComponent(IdentifyLevel)+'&IdentifyUnit='+encodeURIComponent(IdentifyUnit)+'&IdentifyDate='+IdentifyDate+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&Remark='+encodeURIComponent(Remark)+'&usercode='+usercode+'&Type='+Type+'&PrjDr='+prjdr,
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
			if(jsonData.info=='RepName') message='鉴定的项目名称已经存在!';	
			if(jsonData.info=='RepDate') message='鉴定日期不能大于当前日期!';							
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
	text: '关闭',
	iconCls: 'cancel',
    handler: function(){addWindow.close();}
   }]
});
    addWindow.show();
};
