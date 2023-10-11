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

editFun = function(participantids) {
	//alert(ParticipantsIDs);
	
	
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
		rowid = rowObj[0].get("rowid"); 
		var bftype = rowObj[0].get("TypeID"); 
		var bfyear = rowObj[0].get("YearID"); 
		var bfname = rowObj[0].get("Name"); 
		var bfrewardtypeid = rowObj[0].get("RewardTypeID"); 
		var bfrewardnameid = rowObj[0].get("RewardNameID"); 
		var bfrewardlevelid = rowObj[0].get("RewardLevelID"); 
		var bfrewardunitid = rowObj[0].get("RewardUnitID"); 
		var bfrewarddate   = rowObj[0].get("RewardDate"); 
		var bfcompleteunitid = rowObj[0].get("CompleteUnitID"); 
		var bfprjdr = rowObj[0].get("PrjDR"); 
	}

///////////////////类型/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '类型',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           value:bftype,
		           selectOnFocus : true,
				   labelSeparator:'',
		           forceSelection : true
});		
/////////////////年度///////////////////////
var eYearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('eYearField').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'eYearField',
	fieldLabel: '年度',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eYearDs,
	value:bfyear,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择年度...',
	name: 'eYearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});
/* 
eYearField.on('select',function(combo, record, index){
		bfyear = combo.getValue();
	}); */
///////////////////////获奖名称//////////////////////////////
var eNameField = new Ext.form.TextArea({
	id:'eNameField',
	width:180,
	value:bfname,
	fieldLabel: '获奖项目',
	allowBlank: false,
	labelSeparator:''
	// emptyText:'题目...'
	//anchor: '95%'
});

//////////////////////////参与人员。位次。是否本院////////////////////////////////////////////////////////////////////////
//////////////////参加人员///////////////////////
var eParticipantsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eParticipantsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('eParticipantsField').getRawValue()),
	method:'POST'});
});

var eParticipantsField = new Ext.form.ComboBox({
	id: 'eParticipantsField',
	fieldLabel: '项目参加人员',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eParticipantsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择项目参加人员...',
	name: 'eParticipantsField',
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
		           // value:1,
		           selectOnFocus : true,
				   labelSeparator:'',
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
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
				   labelSeparator:'',
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

var eParticipantsGrid = new Ext.grid.GridPanel({
		id:'eParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:projUrl+'?action=GetParticipantsInfo&start='+0+'&limit='+25+'&IDs='+participantids,
		method:'POST'}),
	  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','rangerowid','range','isthehosrowid','isthehos'])
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
			var id = Ext.getCmp('eParticipantsField').getValue();
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			//alert(id);
			var ParticipantsName = Ext.getCmp('eParticipantsField').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var ptotal = eParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = eParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = eParticipantsGrid.getStore().getAt(i).get('range');
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
				}if(isthehosid=="")
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
			eParticipantsGrid.stopEditing(); 
			eParticipantsGrid.getStore().insert(ptotal,data);
			if(ptotal>0){
			   // prawValue=eParticipantsGrid.getStore().getAt(i).get('rowid');
				var authorid = eParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = eParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = eParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				prawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = eParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  var authorid = eParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = eParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = eParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  prawValue = prawValue+","+prow;
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
			var rows = eParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = eParticipantsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				eParticipantsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}

//			var ptotal = eParticipantsGrid.getStore().getCount();
//			//alert(total);
//			if(ptotal>0){
//				prawValue = eParticipantsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<ptotal;i++){
//				  var prow = eParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
//				  prawValue = prawValue+","+prow;
//				}
//			}
			
		}
	});
/////////////////奖项类型////////////////////////////
var eReWardTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

eReWardTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardTypeList',
						method : 'POST'
					});
		});

var eReWardTypeField = new Ext.form.ComboBox({
            id: 'eReWardTypeField',
			fieldLabel: '奖项级别',
			store : eReWardTypeDs,
			value:bfrewardtypeid,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '请选择奖项类型...',
			name:'eReWardTypeField',
			width : 180,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true
		});

/////////////////奖项级别////////////////////////////
var eReWardNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

eReWardNameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardDictList',
						method : 'POST'
					});
		});

var eReWardNameField = new Ext.form.ComboBox({
            id: 'eReWardNameField',
			fieldLabel: '奖项类型',
			store : eReWardNameDs,
			value:bfrewardnameid,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '请选择奖项级别...',
			name:'eReWardNameField',
			width : 180,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true
		});

//////////////////////奖项等次//////////////////////////////////
var eRewardLevelDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '一等奖'], ['2', '二等奖'],['3', '三等奖']]
		});
var eRewardLevelField = new Ext.form.ComboBox({
            id:'eRewardLevelField',
			fieldLabel : '奖项等次',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			allowBlank : false,
			store : eRewardLevelDs,
			value:bfrewardlevelid,
			//anchor : '95%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			// emptyText : '',
			name:'eRewardLevelField',
			mode : 'local', // 本地模式
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});
	
/////////////////批准单位///////////////////////
var eRewardUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eRewardUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('eRewardUnitField').getRawValue()),
	method:'POST'});
});

var eRewardUnitField = new Ext.form.ComboBox({
	id: 'eRewardUnitField',
	fieldLabel: '批准单位',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eRewardUnitDs,
	value:bfrewardunitid,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'请选择批准单位...',
	name: 'eRewardUnitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});

////////////////////////获奖日期///////////////////////
var eRewardDateField = new Ext.form.DateField({
			fieldLabel: '获奖日期',
			width:180,
			allowBlank:false,
			value:bfrewarddate,
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
var eCompleteUnitDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '第一完成单位'], ['2', '第二完成单位'],['3', '第三完成单位'],['4', '第四完成单位'],['5', '第五完成单位'],['6', '第六完成单位'],['7', '第七完成单位'],['8', '第八完成单位']]
		});
var eCompleteUnitField = new Ext.form.ComboBox({
            id:'eCompleteUnitField',
			name:'eCompleteUnitField',
			fieldLabel : '我院单位位次',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			allowBlank : false,
			store : eCompleteUnitDs,
			value:bfcompleteunitid,
			//anchor : '95%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			// emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});


////课题名称
var ePrjNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['rowid', 'name'])
	});
				
ePrjNameDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.srm.monographrewardapplyexe.csp'+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('ePrjNameField').getRawValue()),
		method : 'POST'
			});
	});
var ePrjNameField = new Ext.form.ComboBox({
	        id:'ePrjNameField',
			fieldLabel : '依托项目',
			width : 180,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : true,
			store : ePrjNameDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			// emptyText : '',
			//mode : 'local', // 本地模式
			name:'ePrjNameField',
			value:bfprjdr,
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
	});
				
///院外依托课题
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'科研成果依托科研课题(院外)',
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
					   eTypeCombox,
					   eYearField,                          
					   eNameField,
					   eParticipantsGrid,
					   eParticipantsField,
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
							},delParticipants]
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
						eReWardTypeField,
						eReWardNameField,
						eRewardLevelField,
						eRewardUnitField,
						eRewardDateField,
						eCompleteUnitField,
						ePrjNameField
					]
				 }
				 ]
		}
	]		
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 100,
	labelAlign:'right',
	frame: true,
    items: colItems 
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			eYearField.setRawValue(rowObj[0].get("Year"));
			eNameField.setRawValue(rowObj[0].get("Name"));			
			eReWardTypeField.setRawValue(rowObj[0].get("RewardTypeName"));
			eReWardNameField.setRawValue(rowObj[0].get("RewardName"));
			eRewardLevelField.setRawValue(rowObj[0].get("RewardLevel"));
			eRewardUnitField.setRawValue(rowObj[0].get("RewardUnit"));
			eRewardDateField.setRawValue(rowObj[0].get("RewardDate"));
			eCompleteUnitField.setRawValue(rowObj[0].get("CompleteUnit"));
			eTypeCombox.setRawValue(rowObj[0].get("Type"))
			//ParticipantsGrid.load();
			ePrjNameField.setRawValue(rowObj[0].get("PrjName"));
		});

 var eprawValue="";
  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '修改科研成果申请',
	iconCls: 'pencil',
    width: 650,
    height:450,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '保存', 
		iconCls: 'save',
        handler: function() {
      	// check form value
            var Year = eYearField.getValue();
            var Name = eNameField.getValue();
			var RewardType = eReWardTypeField.getValue();
			var eRewardName = eReWardNameField.getValue();
			var RewardLevel = eRewardLevelField.getValue();
			var RewardUnit = eRewardUnitField.getValue();
			var RewardDate = eRewardDateField.getRawValue();
			var CompleteUnit = eCompleteUnitField.getValue();
			//alert("Year:"+Year);
		    var ptotal = eParticipantsGrid.getStore().getCount();
		    
		    var prjdr = ePrjNameField.getValue(); ///libairu20160913北京丰台
		    
			if(ptotal>0){
				//prawValue = eParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorid = eParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = eParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = eParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				eprawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = eParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  var authorid = eParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = eParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = eParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  eprawValue = eprawValue+","+prow;
				};
			}
			var Participants = eprawValue;
			var SubUser = userdr;
			
			var Type=eTypeCombox.getValue();
			
			// var year=rowObj[0].get("Year");
            // var name=rowObj[0].get("Name");
			// var participants=rowObj[0].get("Participants");
			// var rewardtype=rowObj[0].get("RewardTypeName");
			// var rewardname=rowObj[0].get("RewardName");
			// var rewardlevel=rowObj[0].get("RewardLevel");
			// var rewardunit=rowObj[0].get("RewardUnit");
			// var rewarddate=rowObj[0].get("RewardDate");
			// var completeunit=rowObj[0].get("CompleteUnit");
			// var subuser=rowObj[0].get("SubUser");
			
           if(eTypeCombox.getRawValue()=="")
     		{
     			Ext.Msg.show({title:'错误',msg:'类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
     			return;
     		};
           if(eYearField.getRawValue()=="")
     		{
     			Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
     			return;
     		};
     		if(eNameField.getRawValue()=="")
     		{
     			Ext.Msg.show({title:'错误',msg:'获奖项目为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
     			return;
     		};
			if(Participants=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'参与人员为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
            if(eReWardTypeField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'奖项级别为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eReWardNameField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'奖项类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eRewardLevelField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'奖项等次为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eRewardUnitField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'批准单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eRewardDateField.getValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'获奖日期为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eCompleteUnitField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'我院单位位次为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
            //if(year==Year){Year="";}
		    // if(name==Name){Name="";}
			// if(participants==Participants){Participants="";}
			// if(rewardtype==RewardType){RewardType="";}
			// if(rewardname==RewardName){RewardName="";}
			// if(rewardlevel==RewardLevel){RewardLevel="";}
		    // if(rewardunit==RewardUnit){RewardUnit="";}
			// if(rewarddate==RewardDate){RewardDate="";}
			// if(completeunit==CompleteUnit){CompleteUnit="";}
			// if(subuser==SubUser){SubUser="";}
		    
			// alert(Year+"^"+Name+"^"+Participants+"^"+RewardType+"^"+RewardName+"^"+RewardLevel+"^"+RewardUnit+"^"+RewardDate+"^"+CompleteUnit);
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  projUrl+'?action=edit&rowid='+rowid+'&Year='+encodeURIComponent(Year)+'&Name='+encodeURIComponent(Name)+'&Participants='+encodeURIComponent(Participants)+'&RewardType='+encodeURIComponent(RewardType)+'&RewardName='+encodeURIComponent(eRewardName)+'&RewardLevel='+encodeURIComponent(RewardLevel)+'&RewardUnit='+encodeURIComponent(RewardUnit)+'&RewardDate='+RewardDate+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&SubUser='+SubUser+'&Type='+Type+'&PrjDr='+prjdr,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									var data="||||"+userdr+"|";
									itemGrid.load({params:{start:0, limit:25,data:data}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=="RepName") message='科研成果申请重复!';
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
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
