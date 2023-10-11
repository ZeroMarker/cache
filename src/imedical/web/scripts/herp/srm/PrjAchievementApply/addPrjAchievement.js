var userdr = session['LOGON.USERCODE'];

var projUrl='herp.srm.prjachievementapplyexe.csp';

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
/////////////////年度///////////////////////
var aYearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


aYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('aYearField').getRawValue()),
	method:'POST'});
});

var aYearField = new Ext.form.ComboBox({
	id: 'aYearField',
	fieldLabel: '年度',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:aYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'aYearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	labelSeparator:'',
	forceSelection:'true',
	editable:true
});

///////////////////////获奖名称//////////////////////////////
var aNameField = new Ext.form.TextArea({
	id:'aNameField',
	width:180,
	fieldLabel: '获奖项目',
	//allowBlank: false,
	labelSeparator:''
	// emptyText:'题目...'
	//anchor: '95%'
});

//////////////////////////参与人员。位次。是否本院////////////////////////////////////////////////////////////////////////
//////////////////参加人员///////////////////////
var aParticipantsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


aParticipantsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('aParticipantsField').getRawValue()),
	method:'POST'});
});

var aParticipantsField = new Ext.form.ComboBox({
	id: 'aParticipantsField',
	fieldLabel: '项目参加人员',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:aParticipantsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择项目参加人员...',
	name: 'aParticipantsField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	labelSeparator:'',
	forceSelection:'true',
	editable:true
});

///////////////////作者位次/////////////////////////////  
var AuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '第一'],['2', '第二'], ['3', '第三'], ['4', '第四'], ['5', '第五'],['6', '第六'],['7', '第七'],['8', '第八']]
	});		
		
var AuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'AuthorRangeCombox',
		           fieldLabel : '参与人位次',
	               width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : AuthorRangeDs,
		          // anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
				   labelSeparator:'',
		           // value:1,
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
		          // anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
				   labelSeparator:'',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
                                   AuthorRangeCombox.setValue('');
								   AuthorRangeCombox.disable();  //变为灰；不可编辑
                                   //AuthorRangeCombox.disabled=true;   //不变为灰；不可编辑	
                                   }				
                                   else{
								   AuthorRangeCombox.enable();  	
								   }								   
			}
	}	
});	

var aParticipantsGrid = new Ext.grid.GridPanel({
		id:'aParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
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
            {id: 'rowid', header: '参加人员ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '参加人员名称', dataIndex: 'name',align:'center',width: 100},
            {id: 'rangerowid', header: '参与人排名ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '参与人位次', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '参与科研成果时身份ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '参与人身份', dataIndex: 'isthehos',align:'center',width: 110}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 290,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个参加人员按钮////////////////
var addParticipants  = new Ext.Button({
		text: '增加',
		iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('aParticipantsField').getValue();
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			//alert(id);
			var ParticipantsName = Ext.getCmp('aParticipantsField').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var ptotal = aParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = aParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = aParticipantsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
//						   if(tmprange==AuthorRange)
//							{
//								Ext.Msg.show({title:'错误',msg:'不同的参与人员您选择了相同的位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//							  return;
//							}
                            
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
							if((tmprange==AuthorRange)&&(tmprange!="")&&(AuthorRange!=""))
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
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的参加人员!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的参加人员!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':ParticipantsName,'rangerowid':RangeId,'isthehosrowid':IsTheHosId,'range':AuthorRange,'isthehos':IsTheHos});
			aParticipantsGrid.stopEditing(); 
			aParticipantsGrid.getStore().insert(ptotal,data);
			// if(ptotal>0){
			   //prawValue=aParticipantsGrid.getStore().getAt(i).get('rowid');
				// var authorid = aParticipantsGrid.getStore().getAt(0).get('rowid');
				// var authorrangeid = aParticipantsGrid.getStore().getAt(0).get('rangerowid');
				// var authoristhehosid = aParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				// prawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				// for(var i=1;i<ptotal;i++){
				  //var prow = aParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  // var authorid = aParticipantsGrid.getStore().getAt(i).get('rowid');
				  // var authorrangeid = aParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  // var authoristhehosid = aParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  // var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  // prawValue = prawValue+","+prow;
				// }
			// }
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'删除',
		iconCls:'edit_remove',
		handler: function() {  
			var rows = aParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = aParticipantsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				aParticipantsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}

//			var ptotal = aParticipantsGrid.getStore().getCount();
//			//alert(total);
//			if(ptotal>0){
//				prawValue = aParticipantsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<ptotal;i++){
//				  var prow = aParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
//				  prawValue = prawValue+","+prow;
//				}
//			}
			
		}
	});
/////////////////奖项类型////////////////////////////
var aReWardTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

aReWardTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardTypeList',
						method : 'POST'
					});
		});

var aReWardTypeField = new Ext.form.ComboBox({
            id: 'aReWardTypeField',
			fieldLabel: '奖项级别',
			store : aReWardTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '请选择奖项类型...',
			name:'aReWardTypeField',
			width : 180,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true
		});

/////////////////奖项级别////////////////////////////
var aReWardNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

aReWardNameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardDictList',
						method : 'POST'
					});
		});

var aReWardNameField = new Ext.form.ComboBox({
            id: 'aReWardNameField',
			fieldLabel: '奖项类型',
			store : aReWardNameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '请选择奖项级别...',
			name:'aReWardNameField',
			width : 180,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true
		});

//////////////////////奖项等次//////////////////////////////////
var aRewardLevelDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '一等奖'], ['2', '二等奖'],['3', '三等奖']]
		});
var aRewardLevelField = new Ext.form.ComboBox({
            id:'aRewardLevelField',
			fieldLabel : '奖项等次',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			//allowBlank : false,
			store : aRewardLevelDs,
			//anchor : '95%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			name:'aRewardLevelField',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});
	
/////////////////批准单位///////////////////////
var aRewardUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


aRewardUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('aRewardUnitField').getRawValue()),
	method:'POST'});
});

var aRewardUnitField = new Ext.form.ComboBox({
	id: 'aRewardUnitField',
	fieldLabel: '批准单位',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:aRewardUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择批准单位...',
	name: 'aRewardUnitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});

////////////////////////获奖日期///////////////////////
var aRewardDateField = new Ext.form.DateField({
			fieldLabel: '获奖日期',
			width:180,
			//allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			labelSeparator:'',
			selectOnFocus:'true'
		});
		
//////////////////////我院单位位次//////////////////////////////////
var aCompleteUnitDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '第一完成单位'], ['2', '第二完成单位'],['3', '第三完成单位'],['4', '第四完成单位'],['5', '第五完成单位'],['6', '第六完成单位'],['7', '第七完成单位'],['8', '第八完成单位']]
		});
var aCompleteUnitField = new Ext.form.ComboBox({
            id:'aCompleteUnitField',
			name:'aCompleteUnitField',
			fieldLabel : '我院单位位次',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			//allowBlank : false,
			store : aCompleteUnitDs,
			//anchor : '95%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			// emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
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
			// emptyText : '',
			//mode : 'local', // 本地模式
			name:'PrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
		});

///院外依托课题
var OutPrjNameField = new Ext.form.TextField({
	fieldLabel:'依托项目(院外)',
	width : 180,
	allowBlank : true,
	labelSeparator:'',
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
							columnWidth : .1
						}, */
					   aTypeCombox,
					   aYearField,                          
					   aNameField,
					   aParticipantsGrid,
					   aParticipantsField,
					   IsTheHosCombox,
					   AuthorRangeCombox,
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
							    /*,
							    {
							       xtype : 'displayfield',
							       value : ' *请添加全部项目人员！',
							       columnWidth : .7,
							       style:'color:red;'
							    }
							    */
							
							]
						},{
							columnWidth : 1,
						    xtype : 'panel',
						    layout : "column",
						    items : [
							{
							xtype : 'displayfield',
							value : ' *请添加全部项目参与人员！外院人员无需添加！',
							columnWidth : 1,
							style:'color:red;'
							}
							]
						}

						
						
						
						  
					]	 
				}
				, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						}, */
						aReWardTypeField,
						aReWardNameField,
						aRewardLevelField,
						aRewardUnitField,
						aRewardDateField,
						aCompleteUnitField,
						PrjNameField
					]
				 }
				 ]
		}
	]		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    //baseCls : 'x-plain',  Panel背景色颜色
    labelWidth: 100,
	labelAlign:'right',
	//labelAlign:'right',
	frame: true,
    items: colItems
	});
    
  var prawValue="";
  
  var addWindow = new Ext.Window({
  	title: '新增科研成果申请',
	iconCls: 'edit_add',
    width: 650,
    height:450,
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
      
            var Year = aYearField.getValue();
            var Name = aNameField.getValue();
			var RewardType = aReWardTypeField.getValue();
			var RewardName = aReWardNameField.getValue();
			var RewardLevel = aRewardLevelField.getValue();
			var RewardUnit = aRewardUnitField.getValue();
			var RewardDate = aRewardDateField.getRawValue();
			var CompleteUnit = aCompleteUnitField.getValue();
			
		    var ptotal = aParticipantsGrid.getStore().getCount();
		    
		    var prjdr = PrjNameField.getValue(); ///libairu20160913北京丰台
			if(ptotal>0){
				//prawValue = aParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorid = aParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = aParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = aParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				prawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = aParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  var authorid = aParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = aParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = aParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  prawValue = prawValue+","+prow;
				};
			}
			//alert("prawValue:"+prawValue);
			var Participants = prawValue;
			var SubUser = userdr;
			
			var Type = aTypeCombox.getValue();
      		
			if (Type=="")
			{
      			Ext.Msg.show({title:'错误',msg:'类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if (Year=="")
			{
      			Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(Name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'获奖项目为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Participants=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'参与人员为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
            if(RewardType=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'奖项级别为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RewardName=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'奖项类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RewardLevel=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'奖项等次为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RewardUnit=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'批准单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RewardDate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'获奖日期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(CompleteUnit=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'我院单位位次为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
			
			//alert(Type);
      	    if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: projUrl+'?action=add&Year='+encodeURIComponent(Year)+'&Name='+encodeURIComponent(Name)+'&Participants='+encodeURIComponent(Participants)+'&RewardType='+encodeURIComponent(RewardType)+'&RewardName='+encodeURIComponent(RewardName)+'&RewardLevel='+encodeURIComponent(RewardLevel)+'&RewardUnit='+encodeURIComponent(RewardUnit)+'&RewardDate='+RewardDate+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&SubUser='+userdr+'&Type='+Type+'&PrjDr='+prjdr,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  var data="||||"+userdr+"|";
								  itemGrid.load({params:{start:0, limit:25,data:data}});
									//window.close();
								  addWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepName') message='科研成果申请重复!';	
									if(jsonData.info=='RepDate') message='获奖日期不能大于当前日期!';						
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
