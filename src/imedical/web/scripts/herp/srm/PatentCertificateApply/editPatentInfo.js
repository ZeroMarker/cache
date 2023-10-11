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
editFun = function(inventorsids) {
	//alert(InventorsIDs);
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("Name"));
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var myRowid = rowObj[0].get("rowid"); 
	}

	///////////////////////专利名称//////////////////////////////
var eNameField = new Ext.form.TextArea({
	id:'Name',
	width:180,
	fieldLabel: '专利名称',
	allowBlank: false,
	name:'Name',
	labelSeparator:''
	//emptyText:'专利名称...'
	//anchor: '95%'
});

/////////////专利类别
var ePatentTypeDs  = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '发明专利'], ['2', '实用新型专利'], ['3', '外观设计专利']]
		});
var ePatentTypeField  = new Ext.form.ComboBox({
			id:'PatentType',
			fieldLabel : '专利类别',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			allowBlank : false,
			store : ePatentTypeDs ,
			displayField : 'keyValue',
			valueField : 'key',
			//emptyText : '',
			name:'PatentType',		
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			mode : 'local', // 本地模式
			triggerAction : 'all',
			labelSeparator:''

		});

/////////////////科室///////////////////////
var eDeptsDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eDeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptDr').getRawValue()),
	method:'POST'});
});

var eDeptFields = new Ext.form.ComboBox({
	id: 'DeptDr',
	fieldLabel: '科室',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eDeptsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科室...',
	name: 'DeptDr',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});

	
//////////////////////年度//////////////////////////////////
var eYearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearDr').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'YearDr',
	fieldLabel: '年度',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'YearDr',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});

/////////////////专利权人///////////////////
var ePatenteesDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

ePatenteesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentee').getRawValue()),
	method:'POST'});
});

var ePatenteeFields = new Ext.form.ComboBox({
	id: 'Patentee',
	fieldLabel: '专利权人',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:ePatenteesDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择专利权人...',
	name: 'Patentee',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
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
	url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorsss').getRawValue()),
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
    autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=GetInventorsInfo&start='+0+'&limit='+25+'&IDs='+inventorsids,
		method:'POST'}),
	  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','rangerowid','range','isthehosrowid','isthehos'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '发明人ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '发明人名称', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: '位次ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '位次', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '是否本院ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '是否本院', dataIndex: 'isthehos',align:'center',width: 80}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 280,
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
				}else{
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
/////////////////申请日期///////////////////////
var eAppDateFields = new Ext.form.DateField({
			fieldLabel: '申请日期',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			name:'AppDate',
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true',
			labelSeparator:''

		});
		
var uePhoneField = new Ext.form.TextField({
		id: 'uePhoneField',
		fieldLabel: '电话号码',
		width:180,
		//listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uePhoneField',
		regex:/[0-9]/,
		regexText:"电话号码只能为数字",
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''

	});
var ueEMailField = new Ext.form.TextField({
		id: 'ueEMailField',
		fieldLabel: '邮箱地址',
		width:180,
		listWidth : 180,
		triggerAction: 'all',
		//emptyText:'',
		name: 'ueEMailField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''

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
			allowBlank : false,
			store : ePrjNameDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // 本地模式
			name:'ePrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''

	});
				
///院外依托课题
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'依托(院外)项目',
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
					   eYearField,
					   eNameField,  
					   ePatenteeFields,
					   ePatentTypeField,
					   eAppDateFields,
					   uePhoneField,
					   ueEMailField,
					   ePrjNameField
					  ]},
					  				   
						 
				 {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
						InventorsGrid,
					   InventorsFields,
					   InventorsRangeCombox,
					   IsTheHosCombox,
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
					   
					    					  
					]
				 }]
		}]
			
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 100,
	labelAlign:'right',
	  frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
	
			eNameField.setRawValue(rowObj[0].get("Name"));
			eYearField.setValue(rowObj[0].get("Year"));
			eYearField.setRawValue(rowObj[0].get("YearDr"));
			ePatentTypeField.setValue(rowObj[0].get("PatentType")); 
			ePatentTypeField.setRawValue(rowObj[0].get("PatentTypeList"));   
			 ePatenteeFields.setValue(rowObj[0].get("PatenteeDR"));	
			ePatenteeFields.setRawValue(rowObj[0].get("Patentee"));	
			eAppDateFields.setValue(rowObj[0].get("AppDate"));			
			uePhoneField.setRawValue(rowObj[0].get("Phone"));			
			ueEMailField.setRawValue(rowObj[0].get("Email"));
			ePrjNameField.setRawValue(rowObj[0].get("PrjName"));	
			
		});

  // define window and show it in desktop
  var allauthorinfo="";
  var editWindow = new Ext.Window({
  	title: '修改专利院内证明申请信息',
	iconCls: 'pencil',
    width: 640,
    height:400,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '保存', iconCls: 'save',

        handler: function() {
      		var Name = eNameField.getValue();
      		var YearDr = eYearField.getValue();
      		//var DeptDr = eDeptFields.getValue(); 	
      		var DeptDr="";	
      		var PatentType =ePatentTypeField.getValue();
      		var Patentee = ePatenteeFields.getValue();
      		
      		var AppDate = eAppDateFields.getRawValue();
      		//AppDate = AppDate.format("Y-m-d");
      		var Phone = uePhoneField.getValue();
			var Email = ueEMailField.getValue();
			
			var prjdr = ePrjNameField.getValue(); ///libairu20160913北京丰台
      		
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
			
			Name = Name.trim();
           //DeptDr =DeptDr.trim();
			YearDr =YearDr.trim();
			Patentee =Patentee.trim();

			if(Name=="")
			{
				Ext.Msg.show({title:'错误',msg:'专利名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(YearDr=="")
			{
				Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(PatentType=="")
			{
				Ext.Msg.show({title:'错误',msg:'专利类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(Patentee=="")
			{
				Ext.Msg.show({title:'错误',msg:'专利权人为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			/* if(Name=="")
			{
				Ext.Msg.show({title:'错误',msg:'专利名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}; */
			
		    /* var name = rowObj[0].get("Name");
      		var year = rowObj[0].get("YearDr");
      		var patent = rowObj[0].get("Patentee");
      		//var dept = rowObj[0].get("DeptDr");
      		var patenttype = rowObj[0].get("PatentTypeList");
      		
      		var appdate = rowObj[0].get("AppDate"); */
      		/* 
			    if(Name==name){Name=""};	
			    if(YearDr==year){YearDr=""};	
			    if(Patentee==patent){Patentee=""};	
			    if(PatentType==patenttype){PatentType=""};	
			    
			    if(AppDate==appdate){AppDate=""};	 */
			var IsApproved="";
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  projUrl+'?action=edit&rowid='+myRowid+'&Name='+encodeURIComponent(Name)+'&PatentType='+PatentType+'&YearDr='+YearDr+'&Patentee='+Patentee+'&AppDate='+AppDate+'&Phone='+Phone+'&Email='+Email+'&Inventors='+Inventors+'&IsApproved='+IsApproved+'&PrjDr='+prjdr,
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
									message = jsonData.info;
									if(jsonData.info=='RepTitle') message='输入的专利名称已经存在!';	
														
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
			text: '关闭',iconCls : 'cancel',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
